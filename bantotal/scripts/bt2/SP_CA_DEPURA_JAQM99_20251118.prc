CREATE OR REPLACE PROCEDURE SP_CA_DEPURA_JAQM99 IS
  -- *****************************************************************
  -- NOMBRE                     : SP_CA_DEPURA_JAQM99
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- Fecha de Creación          : 18/11/2025
  -- Autor de Creación          : ERIKA HIDALGO
  -- USO                        : DEPURA 1 SEMANA de JAQM99
  -- ESTADO                     : ACTIVO
  -- Acceso                     : Público
  -- PARÁMETROS DE ENTRADA      :
  N_CONT NUMBER := 0;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM JAQM99 A
   WHERE A.JAQM99FECH <= TRUNC(SYSDATE - 8);
  IF N_CONT > 0 THEN
    dbms_output.put_line('depura');
    EXECUTE IMMEDIATE 'CREATE TABLE OPERADOR.JAQM99_DEPU_' ||
                      TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD_HH24MISSFF3') ||
                      ' PARALLEL(DEGREE 4) NOLOGGING COMPRESS AS
    SELECT A.*
      FROM JAQM99 A
     WHERE A.JAQM99FECH <= trunc(sysdate-8)';
    DELETE FROM JAQM99 A WHERE A.JAQM99FECH <= TRUNC(SYSDATE - 8);
    COMMIT;
  END IF;
END;
/
