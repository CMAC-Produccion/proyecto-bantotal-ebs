CREATE OR REPLACE PROCEDURE SP_CA_DEPURA_JAQM71 IS
  -- *****************************************************************
  -- NOMBRE                     : SP_CA_DEPURA_JAQM71
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- Fecha de Creación          : 26/12/2025
  -- Autor de Creación          : Katerine Cabrera
  -- USO                        : DEPURA JAQM71, dejando 3 dias
  -- ESTADO                     : ACTIVO
  -- Acceso                     : Público
  -- PARÁMETROS DE ENTRADA      : 
  N_CONT NUMBER := 0;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM JAQM71 A
   WHERE A.JAQM71FECH <= TRUNC(SYSDATE - 3);
  IF N_CONT > 0 THEN
    dbms_output.put_line('depura'); 
    EXECUTE IMMEDIATE 'CREATE TABLE OPERADOR.JAQM71_DEPU_' ||
                      TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD_HH24MISSFF3') ||
                      ' PARALLEL(DEGREE 4) NOLOGGING COMPRESS AS
    SELECT A.*
      FROM JAQM71 A
     WHERE A.JAQM71FECH <= trunc(sysdate-3)';
    DELETE FROM JAQM71 A WHERE A.JAQM71FECH <= TRUNC(SYSDATE - 3);
    COMMIT;
  END IF;
END;
/
