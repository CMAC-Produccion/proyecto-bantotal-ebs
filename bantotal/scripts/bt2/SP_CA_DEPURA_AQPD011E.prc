CREATE OR REPLACE PROCEDURE SP_CA_DEPURA_AQPD011E IS
  -- *****************************************************************
  -- NOMBRE                     : SP_CA_DEPURA_AQPD011E
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
 -- Fecha de Creación          : 18/12/2025
  -- Autor de Creación          : Katerine Cabrera
  -- USO                        : DEPURA 1 MES de AQPD011E
  -- ESTADO                     : ACTIVO
  -- Acceso                     : Público
  -- PARÁMETROS DE ENTRADA      : 
  N_CONT NUMBER := 0;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM AQPD011E A
   WHERE A.AQPD011EFPR <= TRUNC(SYSDATE - 30);
  IF N_CONT > 0 THEN
    dbms_output.put_line('depura'); 
    EXECUTE IMMEDIATE 'CREATE TABLE OPERADOR.AQPD011E_DEPU_' ||
                      TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD_HH24MISSFF3') ||
                      ' PARALLEL(DEGREE 4) NOLOGGING COMPRESS AS
    SELECT A.*
      FROM AQPD011E A
     WHERE A.AQPD011EFPR <= trunc(sysdate-30)';
    DELETE FROM AQPD011E A WHERE A.AQPD011EFPR <= TRUNC(SYSDATE - 30);
    COMMIT;
  END IF;
END;
/
