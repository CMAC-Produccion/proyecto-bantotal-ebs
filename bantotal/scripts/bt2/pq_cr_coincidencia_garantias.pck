create or replace package PQ_CR_COINCIDENCIA_GARANTIAS is

  -- *****************************************************************
  -- Nombre                     : PAQUETE PREVIO A LA BUSQUEDA DE COINCIDENCIA DE GARANTIAS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.01.22
  -- Autor de Creación          : APACHECOH
  -- Uso                        : Carga la tabla temporal AQPC954A
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.03.08
  -- Autor de la Modificación   : APACHECOH
  -- Descripción de Modificación: Modificación en limpieza de tabla AQPC954A
  -- Fecha de Modificación      : 2024.07.10
  -- Autor de la Modificación   : APACHECOH
  -- Descripción de Modificación: Actualizacion AQPC954A
  -- *****************************************************************

  PROCEDURE sp_cr_carga_tabla_aqpc954a(vi_usuario in varchar2,
                                       vi_ubigeo  in number);

end PQ_CR_COINCIDENCIA_GARANTIAS;
/

create or replace package body PQ_CR_COINCIDENCIA_GARANTIAS is

  PROCEDURE sp_cr_carga_tabla_aqpc954a(vi_usuario in varchar2,
                                       vi_ubigeo in number)
  -- ***************************************************************** 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.22
    -- Autor de Creación          : APACHECO
    -- Uso                        : Carga la tabla temporal AQPC954A
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_ubigeo (Ubigeo)
    --                            : vi_usuario (Usuario)
    -- *****************************************************************
   IS
   lv_error   varchar2(500);
   ln_flag    number(5);
   lv_fecha   date;
   lv_hora    varchar2(8);
  BEGIN
    --Validamos fecha y hora de la guia
    BEGIN
      SELECT TO_DATE(SUBSTR(TP1DESC, 1, 10), 'DD/MM/RRRR'),
             SUBSTR(TP1DESC, 11, 5)
        INTO lv_fecha, lv_hora  
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11171
         AND TP1CORR1 = 21
         AND TP1CORR2 = 3
         AND TP1CORR3 > 0
         AND TP1NRO1 = vi_ubigeo;
    EXCEPTION WHEN OTHERS THEN
      NULL;     
    END;
    BEGIN
      SELECT COUNT(*)
        INTO ln_flag
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11171
         AND TP1CORR1 = 21
         AND TP1CORR2 = 2
         AND TP1CORR3 > 0
         AND TO_CHAR(SYSDATE, 'HH24:MI') >= TP1DESC
         AND lv_hora < TP1DESC;
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    IF ln_flag > 0 OR TRUNC(SYSDATE) > lv_fecha THEN
        BEGIN
          DELETE FROM AQPC954A WHERE AQPC954AAUX4 = vi_ubigeo; --and AQPC954AUSU = vi_usuario;
          COMMIT;
        EXCEPTION WHEN OTHERS THEN
          NULL;
        END;
        BEGIN
          INSERT INTO AQPC954A
            (AQPC954AUSU,
             AQPC954AFEC,
             AQPC954AHOR,
             AQPC954AEMP,
             AQPC954AMOD,
             AQPC954ASUC,
             AQPC954AMDA,
             AQPC954APAP,
             AQPC954ACTA,
             AQPC954AOPE,
             AQPC954ASBO,
             AQPC954ATOP,
             AQPC954ADIR,
             AQPC954AAUX4)      
            SELECT vi_usuario,
                   TRUNC(SYSDATE),
                   TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                   T.PPG001COD,
                   T.PPG001MOD,
                   T.PPG001SUC,
                   T.PPG001MDA,
                   T.PPG001PAP,
                   T.PPG001CTA,
                   T.PPG001OPE,
                   T.PPG001SBO,
                   T.PPG001TOP,
                   UPPER(T.PPG001DATO),
                   vi_ubigeo
              FROM (SELECT /*all_rows*/ DISTINCT 
                           A.PPG001COD,
                           A.PPG001MOD,
                           A.PPG001SUC,
                           A.PPG001MDA,
                           A.PPG001PAP,
                           A.PPG001CTA,
                           A.PPG001OPE,
                           A.PPG001SBO,
                           A.PPG001TOP,
                           A.PPG001DATO
                      FROM PPG001 A, PPG008 B
                     WHERE A.PPG001CdAt = 41
                       AND A.PPG001COD = B.PPG008PGC
                       AND A.PPG001MOD = B.PPG008MOD
                       AND A.PPG001SUC = B.PPG008SUC
                       AND A.PPG001MDA = B.PPG008MDA
                       AND A.PPG001PAP = B.PPG008PAP
                       AND A.PPG001CTA = B.PPG008CTA
                       AND A.PPG001OPE = B.PPG008OPE
                       AND A.PPG001SBO = B.PPG008SBO
                       AND A.PPG001TOP = B.PPG008TOP
                       AND A.PPG001FRM = B.PPG008FRM
                       AND B.PPG008CdAt = 59
                       AND B.PPG008CIP = 40/*IN (SELECT TP1NRO1
                                             FROM FST198
                                            WHERE TP1COD = 1
                                              AND TP1COD1 = 11171
                                              AND TP1CORR1 = 21
                                              AND TP1CORR2 = 1
                                              AND TP1CORR3 > 0)*/) T,
                   PPG008 C
             WHERE C.PPG008CdAt = 58
               AND T.PPG001COD = C.PPG008PGC
               AND T.PPG001MOD = C.PPG008MOD
               AND T.PPG001SUC = C.PPG008SUC
               AND T.PPG001MDA = C.PPG008MDA
               AND T.PPG001PAP = C.PPG008PAP
               AND T.PPG001CTA = C.PPG008CTA
               AND T.PPG001OPE = C.PPG008OPE
               AND T.PPG001SBO = C.PPG008SBO
               AND T.PPG001TOP = C.PPG008TOP
               AND C.PPG008CIP = vi_ubigeo;
               COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            --lv_error := SQLERRM;
            NULL;
        END;
        --Actualizamos la guia
        BEGIN
          UPDATE FST198
             SET TP1DESC = TO_CHAR(SYSDATE, 'DD/MM/RRRR HH24:MI')
           WHERE TP1COD = 1
             AND TP1COD1 = 11171
             AND TP1CORR1 = 21
             AND TP1CORR2 = 3
             AND TP1CORR3 > 0
             AND TP1NRO1 = vi_ubigeo;
           COMMIT;
        EXCEPTION WHEN OTHERS THEN
          NULL;
        END;
    END IF;   
  END sp_cr_carga_tabla_aqpc954a;

end PQ_CR_COINCIDENCIA_GARANTIAS;
/

