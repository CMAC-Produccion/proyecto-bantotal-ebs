CREATE OR REPLACE PROCEDURE SP_CR_REPORTE_PROVEEDORES(
P_C_INI IN DATE,
P_C_FIN IN DATE,
P_C_FEC IN DATE,
P_C_HOR IN VARCHAR2,
P_C_USU IN VARCHAR2,
P_C_MOD IN NUMBER)
AS

-- *****************************************************************
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 2022.05.05
-- Autor de Creación          : Milton Cordova IGS
-- Uso                        : Reporte de Consulta de Buro
-- Estado                     : Activo
-- Acceso                     : Público
-- Parámetros de Entrada      : P_D_FECPRO ( Fecha RCC )
--                            : P_C_INI ( Fecha Incio )
--                            : P_C_FIN ( Fecha Fin)
--                            : P_C_FEC ( Fecha Consulta )
--                            : P_C_HOR ( Hora Consulta )
--                            : P_C_USU ( Usuario )
--                            : P_C_MOD ( Tipo Operacion )
-- Parámetros de Salida       : 
-- Fecha de Modificación      : 2022.10.05
-- Autor de Modificación      : Alonso Pacheco Huachaca
-- Uso                        : Optimización de Reporte de Buro
-- ******************************************************************

EXPERIAN_OK NUMBER(17);
SENTINEL_OK NUMBER(17);
EQUIFAX_OK NUMBER(17);
EXPERIAN_ERROR NUMBER(17);
SENTINEL_ERROR NUMBER(17);
EQUIFAX_ERROR NUMBER(17);

CURSOR REPORTE_AQPC210(C_C_BURO VARCHAR2) IS
SELECT 
AQPC210COD SU,
AQPC210ANO AN,
AQPC210MES ME
FROM AQPC210
WHERE AQPC210USU = P_C_USU
  AND AQPC210FEC = P_C_FEC
  AND AQPC210BUR = RPAD(C_C_BURO, 15, ' ');   

BEGIN
  
  IF P_C_MOD = 2 THEN
    --LIMPIAR TABLA
    BEGIN
    DELETE FROM AQPC210 WHERE AQPC210USU = P_C_USU AND AQPC210FEC = P_C_FEC AND AQPC210BUR = 'EXPERIAN';
    COMMIT;
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    -- REPORTE EXPERIAN
    BEGIN
      INSERT INTO AQPC210(AQPC210FEC, AQPC210HOR, AQPC210USU, AQPC210ANO, AQPC210MES, AQPC210COD, AQPC210SUC, AQPC210BUR)  
      SELECT P_C_FEC, P_C_HOR, P_C_USU,
             A.ANO, A.MES, A.COD_SUC, A.NOM_SUC, A.BURO FROM
      (SELECT to_char(aqpc572feenv, 'YYYY') ANO,
        concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) MES,
        --to_char(aqpc572feenv, 'Month','nls_date_language=spanish') MES,
        aqpc572ussuc COD_SUC, 
        (SELECT SCNOM FROM FST001 WHERE SUCURS = aqpc572ussuc) NOM_SUC,
        'EXPERIAN' BURO
        FROM aqpc572 
        WHERE aqpc572feenv >= P_C_INI AND aqpc572feenv <= P_C_FIN AND aqpc572buro = 1
        GROUP BY to_char(aqpc572feenv, 'YYYY'), concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')), aqpc572ussuc
        ORDER BY to_char(aqpc572feenv, 'YYYY'), concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')), aqpc572ussuc ASC)
      A;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;   
    FOR B IN REPORTE_AQPC210('EXPERIAN') LOOP
      BEGIN
        SELECT COUNT(*) INTO EXPERIAN_OK
        FROM aqpc572
        WHERE aqpc572buro = 1 AND aqpc572ussuc = B.SU AND to_char(aqpc572feenv, 'YYYY') = B.AN AND concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) = B.ME AND aqpc572rescod = '00000';
      
        SELECT COUNT(*) INTO EXPERIAN_ERROR
        FROM aqpc572
        WHERE aqpc572buro = 1 AND aqpc572ussuc = B.SU AND to_char(aqpc572feenv, 'YYYY') = B.AN AND concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) = B.ME AND aqpc572rescod <> '00000';
            
        UPDATE AQPC210 SET AQPC210COK = EXPERIAN_OK, AQPC210CER = EXPERIAN_ERROR, AQPC210TOT = EXPERIAN_OK + EXPERIAN_ERROR 
        WHERE AQPC210FEC = P_C_FEC AND AQPC210HOR = P_C_HOR AND AQPC210USU = P_C_USU AND AQPC210COD = B.SU AND  AQPC210ANO = B.AN AND AQPC210MES = B.ME AND AQPC210BUR = 'EXPERIAN';      
      EXCEPTION WHEN OTHERS THEN
        NULL;
      END;
    END LOOP;
    COMMIT;
  ELSIF P_C_MOD = 3 THEN
    --LIMPIAR TABLA
    BEGIN
    DELETE FROM AQPC210 WHERE AQPC210USU = P_C_USU AND AQPC210FEC = P_C_FEC AND AQPC210BUR = 'SENTINEL';
    COMMIT;
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    -- REPORTE SENTINEL
    BEGIN
      INSERT INTO AQPC210(AQPC210FEC, AQPC210HOR, AQPC210USU, AQPC210ANO, AQPC210MES, AQPC210COD, AQPC210SUC, AQPC210BUR)      
      SELECT P_C_FEC, P_C_HOR, P_C_USU,
             A.ANO, A.MES, A.COD_SUC, A.NOM_SUC, A.BURO FROM
      (SELECT to_char(aqpc572feenv, 'YYYY') ANO,
        concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) MES,
        aqpc572ussuc COD_SUC,
        (SELECT SCNOM FROM FST001 WHERE SUCURS = aqpc572ussuc) NOM_SUC, 
        'SENTINEL' BURO
        FROM aqpc572 
        WHERE aqpc572feenv >= P_C_INI AND aqpc572feenv <= P_C_FIN AND aqpc572buro = 2
        GROUP BY to_char(aqpc572feenv, 'YYYY'), concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')), aqpc572ussuc
        ORDER BY to_char(aqpc572feenv, 'YYYY'), concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')), aqpc572ussuc ASC)
      A;
    EXCEPTION WHEN OTHERS THEN
        NULL;      
    END;
    FOR B IN REPORTE_AQPC210('SENTINEL') LOOP
      BEGIN
        SELECT COUNT(*) INTO SENTINEL_OK
        FROM aqpc572
        WHERE aqpc572buro = 2 AND aqpc572ussuc = B.SU AND to_char(aqpc572feenv, 'YYYY') = B.AN AND concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) = B.ME AND aqpc572rescod = '00000';
      
        SELECT COUNT(*) INTO SENTINEL_ERROR
        FROM aqpc572
        WHERE aqpc572buro = 2 AND aqpc572ussuc = B.SU AND to_char(aqpc572feenv, 'YYYY') = B.AN AND concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) = B.ME AND aqpc572rescod <> '00000';
            
        UPDATE AQPC210 SET AQPC210COK = SENTINEL_OK, AQPC210CER = SENTINEL_ERROR, AQPC210TOT = SENTINEL_OK + SENTINEL_ERROR 
        WHERE AQPC210FEC = P_C_FEC AND AQPC210HOR = P_C_HOR AND AQPC210USU = P_C_USU AND AQPC210COD = B.SU AND  AQPC210ANO = B.AN AND AQPC210MES = B.ME AND AQPC210BUR = 'SENTINEL';
      EXCEPTION WHEN OTHERS THEN
        NULL;
      END;
    END LOOP;
    COMMIT;    
  ELSIF P_C_MOD = 4 THEN
    --LIMPIAR TABLA
    BEGIN
    DELETE FROM AQPC210 WHERE AQPC210USU = P_C_USU AND AQPC210FEC = P_C_FEC AND AQPC210BUR = 'EQUIFAX';
    COMMIT;
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    -- REPORTE EQUIFAX
    BEGIN
      INSERT INTO AQPC210(AQPC210FEC, AQPC210HOR, AQPC210USU, AQPC210ANO, AQPC210MES, AQPC210COD, AQPC210SUC, AQPC210BUR)      
      SELECT P_C_FEC, P_C_HOR, P_C_USU,
             A.ANO, A.MES, A.COD_SUC, A.NOM_SUC, A.BURO FROM
      (SELECT to_char(aqpc572feenv, 'YYYY') ANO,
        concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) MES,
        aqpc572ussuc COD_SUC,
        (SELECT SCNOM FROM FST001 WHERE SUCURS = aqpc572ussuc) NOM_SUC,
        'EQUIFAX' BURO
        FROM aqpc572
        WHERE aqpc572feenv >= P_C_INI AND aqpc572feenv <= P_C_FIN AND aqpc572buro = 3
        GROUP BY to_char(aqpc572feenv, 'YYYY'), concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')), aqpc572ussuc
        ORDER BY to_char(aqpc572feenv, 'YYYY'), concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')), aqpc572ussuc ASC)
      A;
    EXCEPTION WHEN OTHERS THEN
        NULL;      
    END;
    FOR B IN REPORTE_AQPC210('EQUIFAX') LOOP
      BEGIN
        SELECT COUNT(*) INTO EQUIFAX_OK
        FROM aqpc572
        WHERE aqpc572buro = 3 AND aqpc572ussuc = B.SU AND to_char(aqpc572feenv, 'YYYY') = B.AN AND concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) = B.ME AND aqpc572rescod = '000';
      
        SELECT COUNT(*) INTO EQUIFAX_ERROR
        FROM aqpc572
        WHERE aqpc572buro = 3 AND aqpc572ussuc = B.SU AND to_char(aqpc572feenv, 'YYYY') = B.AN AND concat(concat(to_char(aqpc572feenv,'mm'),' - '),to_char(aqpc572feenv, 'Month','nls_date_language=spanish')) = B.ME AND aqpc572rescod <> '000';
            
        UPDATE AQPC210 SET AQPC210COK = EQUIFAX_OK, AQPC210CER = EQUIFAX_ERROR, AQPC210TOT = EQUIFAX_OK + EQUIFAX_ERROR 
        WHERE AQPC210FEC = P_C_FEC AND AQPC210HOR = P_C_HOR AND AQPC210USU = P_C_USU AND AQPC210COD = B.SU AND  AQPC210ANO = B.AN AND AQPC210MES = B.ME AND AQPC210BUR = 'EQUIFAX';
      EXCEPTION WHEN OTHERS THEN
        NULL;
      END;
    END LOOP;
    COMMIT; 
  END IF;
END;
/

