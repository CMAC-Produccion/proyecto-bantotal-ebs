CREATE OR REPLACE PROCEDURE SP_AH_ES_ACTIVACION_CTA(P_PGCOD  IN NUMBER,
                                                    P_ITSUC  IN NUMBER,
                                                    P_ITMOD  IN NUMBER,
                                                    P_ITTRAN IN NUMBER,
                                                    P_ITNREL IN NUMBER,
                                                    P_RESULT OUT NUMBER,
                                                    P_ERRCOD OUT VARCHAR,
                                                    P_ERRMSG OUT VARCHAR) IS

  -- ***************************************************************************************
  -- Nombre                     : SP_AH_ES_ACTIVACION_CTA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.04.29
  -- Autor de Creación          : CVILLON
  -- Uso                        : Impresion de Texto en Boletas
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.04.19
  -- Modificado                 : CVILLON
  -- Descripción                : Nuevo conteo de TRX
  -- ***************************************************************************************

  ---***
  ln_ORDINAL     NUMBER(2);
  ln_QTY_ORDINAL NUMBER(9);
  ---***
  ln_SCMOD  NUMBER(3);
  ln_SCTOPE NUMBER(3);
  ln_SCSUC  NUMBER(3);
  ln_SCMDA  NUMBER(4);
  ln_SCPAP  NUMBER(4);
  ln_CTA    NUMBER(9);
  ln_SCOPER NUMBER(9);
  ln_SCSBOB NUMBER(3);

  ---***

BEGIN
  ---***
  P_RESULT := 0;
  P_ERRCOD := '000';
  P_ERRMSG := '';
  ---***
  ln_ORDINAL     := 0;
  ln_QTY_ORDINAL := 0;
  ---***
  ln_SCMOD  := 0;
  ln_SCTOPE := 0;
  ln_SCSUC  := 0;
  ln_SCMDA  := 0;
  ln_SCPAP  := 0;
  ln_CTA    := 0;
  ln_SCOPER := 0;
  ln_SCSBOB := 0;

  ---***

  ---*** OBTENER ORDINAL DE lA CUENTA - TRX DE ACTIVACION 
  FOR CROW IN (SELECT *
                 FROM FST198
                WHERE TP1COD = 1
                  AND TP1COD1 = 11146
                  AND TP1CORR1 = 1
                  AND TP1CORR2 = 14
                  AND TP1NRO1 = P_ITMOD
                  AND TP1NRO2 = P_ITTRAN
                  AND TP1NRO3 = 1)
  
   LOOP
    ---***
    SELECT COUNT(*)
      INTO ln_QTY_ORDINAL
      FROM FSD016
     WHERE PGCOD = P_PGCOD
       AND ITSUC = P_ITSUC
       AND ITMOD = P_ITMOD
       AND ITTRAN = P_ITTRAN
       AND ITNREL = P_ITNREL
       AND ITTRAN <> (CASE
             WHEN ITMOD = 21 THEN
              90
             ELSE
              999
           END)
       AND ITORD = CROW.TP1IMP1;
    ---***
    IF (ln_QTY_ORDINAL > 0) THEN
      ln_ORDINAL := CROW.TP1IMP1;
    END IF;
    ---***                                                    
  END LOOP;

  IF (ln_ORDINAL = 0) THEN
    -- No es TRX de Activación
    P_RESULT := 0;
    P_ERRCOD := '000';
    P_ERRMSG := '';
    RETURN;
  END IF;

  ---*** OBTENEMOS DATOS DE lA CTA DEL ORDINAL CORRECTO
  ---*** NO EL QUE LLEGA EN LOS PARAMETROS QUE DEPENDE DE TONDE COLGARON EL PROGRAMA
  SELECT MODULO, ITTOPE, ITSUCD, MONEDA, PAPEL, CTNRO, ITOPER, ITSUBO
    INTO ln_SCMOD,
         ln_SCTOPE,
         ln_SCSUC,
         ln_SCMDA,
         ln_SCPAP,
         ln_CTA,
         ln_SCOPER,
         ln_SCSBOB
    FROM FSD016
   WHERE PGCOD = P_PGCOD
     AND ITSUC = P_ITSUC
     AND ITMOD = P_ITMOD
     AND ITTRAN = P_ITTRAN
     AND ITTRAN <> (CASE
           WHEN ITMOD = 21 THEN
            90
           ELSE
            999
         END)
     AND ITNREL = P_ITNREL
     AND ITORD = ln_ORDINAL;
  ---***
  ---*** 
  ---*** ES LA 1RA OPERACION DE lA CUENTA???(ASOCIADA AL DPF SI CORRESPONDE)
  FOR XROW IN (SELECT *
                 FROM (SELECT f16.CTNRO, f15.*
                         FROM FSD015 f15
                         JOIN FSD016 f16
                           ON (f15.PGCOD = f16.PGCOD AND
                              f15.ITSUC = f16.ITSUC AND
                              f15.ITMOD = f16.ITMOD AND
                              f15.ITTRAN = f16.ITTRAN AND
                              f15.ITNREL = f16.ITNREL)
                        WHERE f15.PGCOD = 1
                          AND f15.ITCONT = 'S'
                          AND f15.ITCORR <> 99
                          AND f16.CTNRO = ln_CTA
                          AND f16.MODULO = ln_SCMOD
                          AND f16.ITSUCD = ln_SCSUC
                          AND f16.MONEDA = ln_SCMDA
                          AND f16.PAPEL = ln_SCPAP
                          AND f16.ITOPER = ln_SCOPER
                          AND f16.ITSUBO = ln_SCSBOB
                          AND f16.ITTOPE = ln_SCTOPE
                          AND f16.ITTRAN <> (CASE
                                WHEN f16.ITMOD = 21 THEN
                                 90
                                ELSE
                                 999
                              END)
                        ORDER BY f15.ITHORA)
                WHERE ROWNUM = 1) LOOP
    ---*** VERIFICAMOS SI ES LA 1RA TRX DE LA CUENTA
    IF (XROW.PGCOD = P_PGCOD AND XROW.ITSUC = P_ITSUC AND
       XROW.ITMOD = P_ITMOD AND XROW.ITTRAN = P_ITTRAN AND
       XROW.ITNREL = P_ITNREL AND XROW.CTNRO = ln_CTA) THEN
      ---***
      P_RESULT := 1;
      ---***
    END IF;
  
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    P_RESULT := 2;
    P_ERRCOD := SQLCODE;
    P_ERRMSG := SQLERRM;
END SP_AH_ES_ACTIVACION_CTA;
/

