CREATE OR REPLACE PROCEDURE SP_RH_DESACTIVA_VACA_LICE

  -- *****************************************************************
  -- NOMBRE                     : SP_RH_DESACTIVA_VACA_LICE
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- Fecha de Creación          : 12/01/2026
  -- Autor de Creación          : Luigui Lupacca
  -- USO                        : Consulta TDVACA y TDLICE_TRAB desde SQL Server vía DBLINK OFIASIS. Desactiva usuarios en FST046 y guarda backup.  
  -- ESTADO                     : ACTIVO
  -- Acceso                     : Público
  -- *****************************************************************
  
IS
  V_HOSTNAME VARCHAR2(100);
  V_UBUSER VARCHAR2(10);
  V_COUNT NUMBER;
  V_ERROR VARCHAR2(2000);
  V_SOLAPAMIENTO NUMBER;
  
  -- Variables para construcción del correo HTML
  V_HTML_VACACIONES CLOB := '';
  V_HTML_LICENCIAS CLOB := '';
  V_TOTAL_VACACIONES NUMBER := 0;
  V_TOTAL_LICENCIAS NUMBER := 0;
  V_HTML_FINAL CLOB;

  CURSOR c_vacaciones IS
    SELECT DISTINCT
      v.CO_TRAB AS COD_TRABAJADOR,
      ide.NU_DOCU_IDEN AS DNI,
      te.NO_APEL_PATE || ' ' || te.NO_APEL_MATE || ', ' || te.NO_TRAB AS NOMBRES,
      j.JAQN002USR AS USUARIO_BT,
      v.FE_INIC_VACA AS FECHA_INICIO,
      v.FE_FINA_VACA AS FECHA_FIN,
      'VACACIONES' AS MOTIVO
    FROM TDVACA@OFIASIS v
    INNER JOIN TDIDEN_TRAB@OFIASIS ide ON v.CO_TRAB = ide.CO_TRAB 
      AND ide.TI_DOCU_IDEN = 'DNI'
    INNER JOIN TMTRAB_PERS@OFIASIS te ON v.CO_TRAB = te.CO_TRAB
    INNER JOIN TMTRAB_EMPR@OFIASIS emp ON v.CO_TRAB = emp.CO_TRAB
    INNER JOIN JAQN002 j ON TRIM(ide.NU_DOCU_IDEN) = TRIM(j.JAQN002NDO)
    WHERE v.TI_SITU = 'APR'
      AND emp.TI_SITU = 'ACT'
      AND TRUNC(SYSDATE) BETWEEN TRUNC(v.FE_INIC_VACA) AND TRUNC(NVL(v.FE_FINA_VACA, v.FE_INIC_VACA + NVL(v.NU_DIAS, 0)))
      AND j.JAQN002USR IS NOT NULL;
  
  CURSOR c_licencias IS
    SELECT DISTINCT
      l.CO_TRAB AS COD_TRABAJADOR,
      ide.NU_DOCU_IDEN AS DNI,
      te.NO_APEL_PATE || ' ' || te.NO_APEL_MATE || ', ' || te.NO_TRAB AS NOMBRES,
      j.JAQN002USR AS USUARIO_BT,
      l.FE_INIC_LICE AS FECHA_INICIO,
      l.FE_FINA_LICE AS FECHA_FIN,
      'LICENCIA' AS MOTIVO
    FROM TDLICE_TRAB@OFIASIS l
    INNER JOIN TDIDEN_TRAB@OFIASIS ide ON l.CO_TRAB = ide.CO_TRAB 
      AND ide.TI_DOCU_IDEN = 'DNI'
    INNER JOIN TMTRAB_PERS@OFIASIS te ON l.CO_TRAB = te.CO_TRAB
    INNER JOIN TMTRAB_EMPR@OFIASIS emp ON l.CO_TRAB = emp.CO_TRAB
    INNER JOIN JAQN002 j ON TRIM(ide.NU_DOCU_IDEN) = TRIM(j.JAQN002NDO)
    WHERE emp.TI_SITU = 'ACT'
      AND TRUNC(SYSDATE) BETWEEN TRUNC(l.FE_INIC_LICE) AND TRUNC(NVL(l.FE_FINA_LICE, l.FE_INIC_LICE + NVL(l.NU_DIAS_LICE, 0)))
      AND j.JAQN002USR IS NOT NULL;

BEGIN
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;

  -- ============================================
  -- PROCESAR VACACIONES
  -- ============================================
  FOR rec IN c_vacaciones LOOP
    BEGIN
      V_UBUSER := rec.USUARIO_BT;

      -- Verificar que usuario existe en FST046
      SELECT COUNT(*) INTO V_COUNT
      FROM FST046
      WHERE PGCOD = 1 AND UBUSER = V_UBUSER;

      IF V_COUNT > 0 THEN
        -- Verificar que no está cesado
        SELECT COUNT(*) INTO V_COUNT
        FROM PRFU00
        WHERE PGCOD = 1 AND PRFGCOD = 'CESADO' AND UBUSER = V_UBUSER;

        IF V_COUNT = 0 THEN
          
          -- ?? VALIDAR SOLAPAMIENTO: Evitar duplicados exactos
          SELECT COUNT(*) INTO V_SOLAPAMIENTO
          FROM AQPD502
          WHERE AQPD502UBUSER = V_UBUSER
            AND AQPD502ESTADO IN ('ACTIVO', 'REGISTRADO')
            AND AQPD502MOTIVO = rec.MOTIVO
            AND TRUNC(AQPD502FECINI) = TRUNC(rec.FECHA_INICIO)
            AND TRUNC(NVL(AQPD502FECFIN, AQPD502FECINI)) = TRUNC(NVL(rec.FECHA_FIN, rec.FECHA_INICIO));
          
          IF V_SOLAPAMIENTO > 0 THEN
            -- Ya existe este registro exacto, saltar
            CONTINUE;
          END IF;
          
          -- Verificar si YA existe un backup ACTIVO
          SELECT COUNT(*) INTO V_COUNT
          FROM AQPD502
          WHERE AQPD502UBUSER = V_UBUSER
            AND AQPD502ESTADO = 'ACTIVO';
          
          IF V_COUNT > 0 THEN
            -- Ya desactivado, solo registrar ausencia adicional
            INSERT INTO AQPD502 (
              AQPD502UBUSER, AQPD502UBSUC, AQPD502UBCAJ, AQPD502UBNCAJ, AQPD502UBNIV, AQPD502UBMNU, AQPD502UBPRD,
              AQPD502FECBK, AQPD502MOTIVO, AQPD502COTRAB, AQPD502DNI, AQPD502NOMBRES,
              AQPD502FECINI, AQPD502FECFIN, AQPD502ESTADO
            ) VALUES (
              V_UBUSER, NULL, NULL, NULL, NULL, NULL, NULL,
              SYSDATE, rec.MOTIVO, rec.COD_TRABAJADOR, rec.DNI, rec.NOMBRES,
              rec.FECHA_INICIO, rec.FECHA_FIN, 'REGISTRADO'
            );
            
            COMMIT;
            
            -- Agregar a HTML (Registrado - fondo amarillo)
            V_HTML_VACACIONES := V_HTML_VACACIONES || 
              '<tr style="background-color: #FFF3CD;">' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.USUARIO_BT || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.DNI || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.NOMBRES || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || TO_CHAR(rec.FECHA_INICIO, 'DD/MM/YYYY') || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || TO_CHAR(rec.FECHA_FIN, 'DD/MM/YYYY') || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd; font-weight: bold;">REGISTRADO</td>' ||
              '</tr>';
            
          ELSE
            -- Primera desactivación: guardar backup y desactivar
            INSERT INTO AQPD502 (
              AQPD502UBUSER, AQPD502UBSUC, AQPD502UBCAJ, AQPD502UBNCAJ, AQPD502UBNIV, AQPD502UBMNU, AQPD502UBPRD,
              AQPD502FECBK, AQPD502MOTIVO, AQPD502COTRAB, AQPD502DNI, AQPD502NOMBRES,
              AQPD502FECINI, AQPD502FECFIN, AQPD502ESTADO
            )
            SELECT 
              UBUSER, UBSUC, UBCAJ, UBNCAJ, UBNIV, UBMNU, UBPRD,
              SYSDATE, rec.MOTIVO, rec.COD_TRABAJADOR, rec.DNI, rec.NOMBRES,
              rec.FECHA_INICIO, rec.FECHA_FIN, 'ACTIVO'
            FROM FST046
            WHERE PGCOD = 1 AND UBUSER = V_UBUSER;
            
            UPDATE FST046 SET
              UBSUC = 999,
              UBCAJ = 'N',
              UBNCAJ = 0,
              UBNIV = 0,
              UBMNU = 'MINSTAL',
              UBPRD = 0
            WHERE PGCOD = 1 AND UBUSER = V_UBUSER;
            
            COMMIT;
            
            -- Agregar a HTML (Desactivado - fondo verde)
            V_HTML_VACACIONES := V_HTML_VACACIONES || 
              '<tr style="background-color: #D4EDDA;">' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.USUARIO_BT || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.DNI || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.NOMBRES || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || TO_CHAR(rec.FECHA_INICIO, 'DD/MM/YYYY') || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || TO_CHAR(rec.FECHA_FIN, 'DD/MM/YYYY') || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd; font-weight: bold; color: #155724;">DESACTIVADO</td>' ||
              '</tr>';
          END IF;
          
          V_TOTAL_VACACIONES := V_TOTAL_VACACIONES + 1;
          
        END IF;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        V_ERROR := 'Error vacaciones ' || V_UBUSER || ': ' || SQLERRM;
        ROLLBACK;
    END;
  END LOOP;

  -- ============================================
  -- PROCESAR LICENCIAS 
  -- ============================================
  FOR rec IN c_licencias LOOP
    BEGIN
      V_UBUSER := rec.USUARIO_BT;

      SELECT COUNT(*) INTO V_COUNT
      FROM FST046
      WHERE PGCOD = 1 AND UBUSER = V_UBUSER;

      IF V_COUNT > 0 THEN
        SELECT COUNT(*) INTO V_COUNT
        FROM PRFU00
        WHERE PGCOD = 1 AND PRFGCOD = 'CESADO' AND UBUSER = V_UBUSER;

        IF V_COUNT = 0 THEN
          
          SELECT COUNT(*) INTO V_SOLAPAMIENTO
          FROM AQPD502
          WHERE AQPD502UBUSER = V_UBUSER
            AND AQPD502ESTADO IN ('ACTIVO', 'REGISTRADO')
            AND AQPD502MOTIVO = rec.MOTIVO
            AND TRUNC(AQPD502FECINI) = TRUNC(rec.FECHA_INICIO)
            AND TRUNC(NVL(AQPD502FECFIN, AQPD502FECINI)) = TRUNC(NVL(rec.FECHA_FIN, rec.FECHA_INICIO));
          
          IF V_SOLAPAMIENTO > 0 THEN
            CONTINUE;
          END IF;
          
          SELECT COUNT(*) INTO V_COUNT
          FROM AQPD502
          WHERE AQPD502UBUSER = V_UBUSER
            AND AQPD502ESTADO = 'ACTIVO';
          
          IF V_COUNT > 0 THEN
            INSERT INTO AQPD502 (
              AQPD502UBUSER, AQPD502UBSUC, AQPD502UBCAJ, AQPD502UBNCAJ, AQPD502UBNIV, AQPD502UBMNU, AQPD502UBPRD,
              AQPD502FECBK, AQPD502MOTIVO, AQPD502COTRAB, AQPD502DNI, AQPD502NOMBRES,
              AQPD502FECINI, AQPD502FECFIN, AQPD502ESTADO
            ) VALUES (
              V_UBUSER, NULL, NULL, NULL, NULL, NULL, NULL,
              SYSDATE, rec.MOTIVO, rec.COD_TRABAJADOR, rec.DNI, rec.NOMBRES,
              rec.FECHA_INICIO, rec.FECHA_FIN, 'REGISTRADO'
            );
            
            COMMIT;
            
            -- Agregar a HTML (Registrado)
            V_HTML_LICENCIAS := V_HTML_LICENCIAS || 
              '<tr style="background-color: #FFF3CD;">' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.USUARIO_BT || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.DNI || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.NOMBRES || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || TO_CHAR(rec.FECHA_INICIO, 'DD/MM/YYYY') || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || TO_CHAR(rec.FECHA_FIN, 'DD/MM/YYYY') || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd; font-weight: bold;">REGISTRADO</td>' ||
              '</tr>';
            
          ELSE
            INSERT INTO AQPD502 (
              AQPD502UBUSER, AQPD502UBSUC, AQPD502UBCAJ, AQPD502UBNCAJ, AQPD502UBNIV, AQPD502UBMNU, AQPD502UBPRD,
              AQPD502FECBK, AQPD502MOTIVO, AQPD502COTRAB, AQPD502DNI, AQPD502NOMBRES,
              AQPD502FECINI, AQPD502FECFIN, AQPD502ESTADO
            )
            SELECT 
              UBUSER, UBSUC, UBCAJ, UBNCAJ, UBNIV, UBMNU, UBPRD,
              SYSDATE, rec.MOTIVO, rec.COD_TRABAJADOR, rec.DNI, rec.NOMBRES,
              rec.FECHA_INICIO, rec.FECHA_FIN, 'ACTIVO'
            FROM FST046
            WHERE PGCOD = 1 AND UBUSER = V_UBUSER;
            
            UPDATE FST046 SET
              UBSUC = 999,
              UBCAJ = 'N',
              UBNCAJ = 0,
              UBNIV = 0,
              UBMNU = 'MINSTAL',
              UBPRD = 0
            WHERE PGCOD = 1 AND UBUSER = V_UBUSER;
            
            COMMIT;
            
            -- Agregar a HTML (Desactivado)
            V_HTML_LICENCIAS := V_HTML_LICENCIAS || 
              '<tr style="background-color: #D4EDDA;">' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.USUARIO_BT || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.DNI || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || rec.NOMBRES || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || TO_CHAR(rec.FECHA_INICIO, 'DD/MM/YYYY') || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd;">' || TO_CHAR(rec.FECHA_FIN, 'DD/MM/YYYY') || '</td>' ||
              '<td style="padding: 8px; border: 1px solid #ddd; font-weight: bold; color: #155724;">DESACTIVADO</td>' ||
              '</tr>';
          END IF;
          
          V_TOTAL_LICENCIAS := V_TOTAL_LICENCIAS + 1;
          
        END IF;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        V_ERROR := 'Error licencia ' || V_UBUSER || ': ' || SQLERRM;
        ROLLBACK;
    END;
  END LOOP;
-- ============================================
  -- ENVIAR CORREO CONSOLIDADO AL FINAL
  -- ============================================
  IF V_TOTAL_VACACIONES > 0 OR V_TOTAL_LICENCIAS > 0 THEN
    
    V_HTML_FINAL := 
      '<html><body style="font-family: Arial, sans-serif;">' ||
      '<h2 style="color: #2C3E50;">Reporte de Desactivación de Usuarios - ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI') || '</h2>' ||
      '<p><strong>Servidor:</strong> ' || V_HOSTNAME || '</p>' ||
      '<p><strong>Total Procesados:</strong> ' || (V_TOTAL_VACACIONES + V_TOTAL_LICENCIAS) || ' usuarios</p>';
    
    -- Tabla de VACACIONES
    IF V_TOTAL_VACACIONES > 0 THEN
      V_HTML_FINAL := V_HTML_FINAL ||
        '<h3 style="color: #27AE60; margin-top: 30px;">VACACIONES (' || V_TOTAL_VACACIONES || ')</h3>' ||
        '<table style="border-collapse: collapse; width: 100%; margin-bottom: 20px;">' ||
        '<thead>' ||
        '<tr style="background-color: #27AE60; color: white;">' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Usuario BT</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">DNI</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Nombres</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Fecha Inicio</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Fecha Fin</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Acción</th>' ||
        '</tr>' ||
        '</thead>' ||
        '<tbody>' ||
        V_HTML_VACACIONES ||
        '</tbody></table>';
    END IF;
    
    -- Tabla de LICENCIAS
    IF V_TOTAL_LICENCIAS > 0 THEN
      V_HTML_FINAL := V_HTML_FINAL ||
        '<h3 style="color: #E67E22; margin-top: 30px;">LICENCIAS (' || V_TOTAL_LICENCIAS || ')</h3>' ||
        '<table style="border-collapse: collapse; width: 100%; margin-bottom: 20px;">' ||
        '<thead>' ||
        '<tr style="background-color: #E67E22; color: white;">' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Usuario BT</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">DNI</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Nombres</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Fecha Inicio</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Fecha Fin</th>' ||
        '<th style="padding: 10px; border: 1px solid #ddd;">Acción</th>' ||
        '</tr>' ||
        '</thead>' ||
        '<tbody>' ||
        V_HTML_LICENCIAS ||
        '</tbody></table>';
    END IF;
    
    -- Leyenda
    V_HTML_FINAL := V_HTML_FINAL ||
      '<div style="margin-top: 30px; padding: 15px; background-color: #F8F9FA; border-left: 4px solid #3498DB;">' ||
      '<p style="margin: 5px 0;"><strong>Leyenda:</strong></p>' ||
      '<p style="margin: 5px 0;"><span style="background-color: #D4EDDA; padding: 2px 8px;">DESACTIVADO</span> - Usuario desactivado en FST046</p>' ||
      '<p style="margin: 5px 0;"><span style="background-color: #FFF3CD; padding: 2px 8px;">REGISTRADO</span> - Ausencia adicional (usuario ya estaba desactivado)</p>' ||
      '</div>' ||
      '</body></html>';
    
    -- Enviar correo único
    SYS.SP_SY_ENVIAMAIL_HTML(
      'igs_llupacca@cajaarequipa.pe',
      'igs_llupacca@cajaarequipa.pe',
      'Usuarios Desactivados por Vacaciones/Licencias - ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'),
      V_HTML_FINAL
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'ehidalgom@cajaarequipa.pe',
      'ehidalgom@cajaarequipa.pe',
      'Usuarios Desactivados por Vacaciones/Licencias - ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'),
      V_HTML_FINAL
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'kcabrerac@cajaarequipa.pe',
      'kcabrerac@cajaarequipa.pe',
      'Usuarios Desactivados por Vacaciones/Licencias - ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'),
      V_HTML_FINAL
    );
    
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    V_ERROR := 'Error general: ' || SQLERRM;
    SYS.SP_SY_ENVIAMAIL_HTML(
      'igs_llupacca@cajaarequipa.pe',
      'igs_llupacca@cajaarequipa.pe',
      'ERROR CRÍTICO SP_RH_DESACTIVA_VACA_LICE',
      'Error: ' || V_ERROR || CHR(13) || CHR(13) ||
      'Servidor: ' || V_HOSTNAME || CHR(13) ||
      'Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'ehidalgom@cajaarequipa.pe',
      'ehidalgom@cajaarequipa.pe',
      'ERROR CRÍTICO SP_RH_DESACTIVA_VACA_LICE',
      'Error: ' || V_ERROR || CHR(13) || CHR(13) ||
      'Servidor: ' || V_HOSTNAME || CHR(13) ||
      'Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'kcabrerac@cajaarequipa.pe',
      'kcabrerac@cajaarequipa.pe',
      'ERROR CRÍTICO SP_RH_DESACTIVA_VACA_LICE',
      'Error: ' || V_ERROR || CHR(13) || CHR(13) ||
      'Servidor: ' || V_HOSTNAME || CHR(13) ||
      'Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
    );
END SP_RH_DESACTIVA_VACA_LICE;
/
