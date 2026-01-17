CREATE OR REPLACE PROCEDURE SP_RH_REACTIVA_VACA_LICE

  -- *****************************************************************
  -- NOMBRE                     : SP_RH_REACTIVA_VACA_LICE
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- Fecha de Creación          : 12/01/2026
  -- Autor de Creación          : Luigui Lupacca
  -- USO                        : Reactiva usuarios al finalizar todas sus ausencias, restaurando valores originales desde AQPD502.
  -- ESTADO                     : ACTIVO
  -- Acceso                     : Público
  -- *****************************************************************
  
IS
  V_HOSTNAME VARCHAR2(100);
  V_UBUSER VARCHAR2(10);
  V_ERROR VARCHAR2(2000);
  V_COUNT NUMBER;
  
  -- Variables para construcción del correo HTML
  V_HTML_REACTIVADOS CLOB := '';
  V_TOTAL_REACTIVADOS NUMBER := 0;
  V_HTML_FINAL CLOB;
  
  -- Cursor: Solo usuarios con backup ACTIVO
  CURSOR c_usuarios_a_reactivar IS
    SELECT DISTINCT AQPD502UBUSER
    FROM AQPD502
    WHERE AQPD502ESTADO = 'ACTIVO';

BEGIN
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
  
  FOR rec IN c_usuarios_a_reactivar LOOP
    BEGIN
      V_UBUSER := rec.AQPD502UBUSER;
      
      -- Verificar que TODAS las ausencias terminaron
      SELECT COUNT(*) INTO V_COUNT
      FROM AQPD502
      WHERE AQPD502UBUSER = V_UBUSER
        AND AQPD502ESTADO IN ('ACTIVO', 'REGISTRADO')
        AND TRUNC(SYSDATE) <= TRUNC(NVL(AQPD502FECFIN, AQPD502FECINI));
      
      IF V_COUNT = 0 THEN
        -- Todas las ausencias terminaron
        DECLARE
          v_ubsuc NUMBER;
          v_ubcaj VARCHAR2(1);
          v_ubncaj NUMBER;
          v_ubniv NUMBER;
          v_ubmnu VARCHAR2(20);
          v_ubprd NUMBER;
          v_nombres VARCHAR2(200);
          v_dni VARCHAR2(20);
          v_motivos VARCHAR2(500) := '';
          v_fecha_inicio DATE;
          v_fecha_fin DATE;
          
          -- Cursor para obtener todas las ausencias del usuario
          CURSOR c_ausencias IS
            SELECT AQPD502MOTIVO, AQPD502FECINI, AQPD502FECFIN
            FROM AQPD502
            WHERE AQPD502UBUSER = V_UBUSER
              AND AQPD502ESTADO IN ('ACTIVO', 'REGISTRADO')
            ORDER BY AQPD502FECINI;
        BEGIN
          
          -- Obtener valores SOLO del registro ACTIVO (tiene el backup)
          SELECT AQPD502UBSUC, AQPD502UBCAJ, AQPD502UBNCAJ, AQPD502UBNIV, AQPD502UBMNU, AQPD502UBPRD, 
                 AQPD502NOMBRES, AQPD502DNI, AQPD502FECINI, AQPD502FECFIN
          INTO v_ubsuc, v_ubcaj, v_ubncaj, v_ubniv, v_ubmnu, v_ubprd, v_nombres, v_dni,
               v_fecha_inicio, v_fecha_fin
          FROM AQPD502
          WHERE AQPD502UBUSER = V_UBUSER
            AND AQPD502ESTADO = 'ACTIVO'
            AND AQPD502UBSUC IS NOT NULL
            AND ROWNUM = 1;
          
          -- Construir lista de motivos
          FOR aus IN c_ausencias LOOP
            IF v_motivos IS NOT NULL THEN
              v_motivos := v_motivos || ', ';
            END IF;
            v_motivos := v_motivos || aus.AQPD502MOTIVO || ' (' || 
                         TO_CHAR(aus.AQPD502FECINI, 'DD/MM') || '-' || 
                         TO_CHAR(aus.AQPD502FECFIN, 'DD/MM') || ')';
          END LOOP;
          
          -- Restaurar valores originales
          UPDATE FST046 SET
            UBSUC = v_ubsuc,
            UBCAJ = v_ubcaj,
            UBNCAJ = v_ubncaj,
            UBNIV = v_ubniv,
            UBMNU = v_ubmnu,
            UBPRD = v_ubprd
          WHERE PGCOD = 1 AND UBUSER = V_UBUSER;
          
          -- Marcar TODOS como RESTAURADO
          UPDATE AQPD502
          SET AQPD502ESTADO = 'RESTAURADO',
              AQPD502FECRESTA = SYSDATE
          WHERE AQPD502UBUSER = V_UBUSER
            AND AQPD502ESTADO IN ('ACTIVO', 'REGISTRADO');
          
          COMMIT;
          
          -- Agregar fila a HTML
          V_HTML_REACTIVADOS := V_HTML_REACTIVADOS || 
            '<tr style="background-color: #D1ECF1;">' ||
            '<td style="padding: 8px; border: 1px solid #ddd;">' || V_UBUSER || '</td>' ||
            '<td style="padding: 8px; border: 1px solid #ddd;">' || v_dni || '</td>' ||
            '<td style="padding: 8px; border: 1px solid #ddd;">' || v_nombres || '</td>' ||
            '<td style="padding: 8px; border: 1px solid #ddd; font-size: 11px;">' || v_motivos || '</td>' ||
            '<td style="padding: 8px; border: 1px solid #ddd; text-align: center;">' || v_ubsuc || '</td>' ||
            '<td style="padding: 8px; border: 1px solid #ddd; text-align: center;">' || v_ubcaj || '</td>' ||
            '<td style="padding: 8px; border: 1px solid #ddd; text-align: center; font-weight: bold; color: #0C5460;">ACTIVO NUEVAMENTE</td>' ||
            '</tr>';
          
          V_TOTAL_REACTIVADOS := V_TOTAL_REACTIVADOS + 1;
          
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            -- No hay backup ACTIVO con valores guardados
            V_ERROR := 'Usuario ' || V_UBUSER || ' sin backup ACTIVO disponible';
            
            SYS.SP_SY_ENVIAMAIL_HTML(
              'igs_llupacca@cajaarequipa.pe',
              'igs_llupacca@cajaarequipa.pe',
              'ADVERTENCIA Reactivación - ' || V_UBUSER,
              V_ERROR || CHR(13) ||
              'Revisar manualmente en FST046'
            );
            
            SYS.SP_SY_ENVIAMAIL_HTML(
              'ehidalgom@cajaarequipa.pe',
              'ehidalgom@cajaarequipa.pe',
              'ADVERTENCIA Reactivación - ' || V_UBUSER,
              V_ERROR || CHR(13) ||
              'Revisar manualmente en FST046'
            );
            
            SYS.SP_SY_ENVIAMAIL_HTML(
              'kcabrerac@cajaarequipa.pe',
              'kcabrerac@cajaarequipa.pe',
              'ADVERTENCIA Reactivación - ' || V_UBUSER,
              V_ERROR || CHR(13) ||
              'Revisar manualmente en FST046'
            );
            
        END;
      END IF;
      
    EXCEPTION
      WHEN OTHERS THEN
        V_ERROR := 'Error reactivando ' || V_UBUSER || ': ' || SQLERRM;
        ROLLBACK;
    END;
  END LOOP;
  
  -- ============================================
  -- ENVIAR CORREO CONSOLIDADO
  -- ============================================
  IF V_TOTAL_REACTIVADOS > 0 THEN
    
    V_HTML_FINAL := 
      '<html><body style="font-family: Arial, sans-serif;">' ||
      '<h2 style="color: #0C5460;">Reporte de Reactivación de Usuarios - ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI') || '</h2>' ||
      '<p><strong>Servidor:</strong> ' || V_HOSTNAME || '</p>' ||
      '<p><strong>Base de Datos:</strong> ' || SYS_CONTEXT('USERENV', 'DB_NAME') || '</p>' ||
      '<p><strong>Total Reactivados:</strong> ' || V_TOTAL_REACTIVADOS || ' usuarios</p>' ||
      
      '<table style="border-collapse: collapse; width: 100%; margin-top: 20px;">' ||
      '<thead>' ||
      '<tr style="background-color: #17A2B8; color: white;">' ||
      '<th style="padding: 10px; border: 1px solid #ddd;">Usuario BT</th>' ||
      '<th style="padding: 10px; border: 1px solid #ddd;">DNI</th>' ||
      '<th style="padding: 10px; border: 1px solid #ddd;">Nombres</th>' ||
      '<th style="padding: 10px; border: 1px solid #ddd;">Ausencias</th>' ||
      '<th style="padding: 10px; border: 1px solid #ddd;">Sucursal</th>' ||
      '<th style="padding: 10px; border: 1px solid #ddd;">Caja</th>' ||
      '<th style="padding: 10px; border: 1px solid #ddd;">Estado</th>' ||
      '</tr>' ||
      '</thead>' ||
      '<tbody>' ||
      V_HTML_REACTIVADOS ||
      '</tbody></table>' ||
      
      '<div style="margin-top: 30px; padding: 15px; background-color: #D1ECF1; border-left: 4px solid #17A2B8;">' ||
      '<p style="margin: 5px 0;"><strong>Información:</strong></p>' ||
      '<p style="margin: 5px 0;">Los usuarios fueron reactivados exitosamente en FST046</p>' ||
      '<p style="margin: 5px 0;">Se restauraron los valores originales de sucursal y permisos</p>' ||
      '<p style="margin: 5px 0;">Todas las ausencias asociadas fueron marcadas como RESTAURADO</p>' ||
      '<p style="margin: 5px 0;">Fecha de restauración: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') || '</p>' ||
      '</div>' ||
      
      '</body></html>';
    
    -- Enviar correo único
    SYS.SP_SY_ENVIAMAIL_HTML(
      'igs_llupacca@cajaarequipa.pe',
      'igs_llupacca@cajaarequipa.pe',
      'Usuarios Reactivados - Fin de Vacaciones/Licencias - ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'),
      V_HTML_FINAL
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'ehidalgom@cajaarequipa.pe',
      'ehidalgom@cajaarequipa.pe',
      'Usuarios Reactivados - Fin de Vacaciones/Licencias - ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'),
      V_HTML_FINAL
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'kcabrerac@cajaarequipa.pe',
      'kcabrerac@cajaarequipa.pe',
      'Usuarios Reactivados - Fin de Vacaciones/Licencias - ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'),
      V_HTML_FINAL
    );
    
  END IF;
  
EXCEPTION
  WHEN OTHERS THEN
    V_ERROR := 'Error general: ' || SQLERRM;
    SYS.SP_SY_ENVIAMAIL_HTML(
      'igs_llupacca@cajaarequipa.pe',
      'igs_llupacca@cajaarequipa.pe',
      'ERROR CRÍTICO SP_RH_REACTIVA_VACA_LICE',
      'Error: ' || V_ERROR || CHR(13) || CHR(13) ||
      'Servidor: ' || V_HOSTNAME || CHR(13) ||
      'Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'ehidalgom@cajaarequipa.pe',
      'ehidalgom@cajaarequipa.pe',
      'ERROR CRÍTICO SP_RH_REACTIVA_VACA_LICE',
      'Error: ' || V_ERROR || CHR(13) || CHR(13) ||
      'Servidor: ' || V_HOSTNAME || CHR(13) ||
      'Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'kcabrerac@cajaarequipa.pe',
      'kcabrerac@cajaarequipa.pe',
      'ERROR CRÍTICO SP_RH_REACTIVA_VACA_LICE',
      'Error: ' || V_ERROR || CHR(13) || CHR(13) ||
      'Servidor: ' || V_HOSTNAME || CHR(13) ||
      'Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
    );
END SP_RH_REACTIVA_VACA_LICE;
/
