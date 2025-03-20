CREATE OR REPLACE PROCEDURE SP_CA_CDETAB_DEPUR(C_TABLA VARCHAR2, C_CAMPOUPD VARCHAR2, C_CAMPOFEC VARCHAR2, P_FECHA DATE) IS
  -- *****************************************************************
  -- NOMBRE                     : SP_CA_CDETAB_DEPUR
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- USO                        : DEPURACIÓN TABLAS CDE
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      : C_TABLA TABLA A DEPURAR, C_CAMPOUPD CAMPO A ACTUALIZAR, 
  --                              C_CAMPOFEC CAMPO FECHA A UTILIZAR PARA DEPURACIÓN, P_FECHA FECHA HASTA DONDE DEPURAR
  C_FECTRIM VARCHAR2(40);
  N_FECTRIM NUMBER;
BEGIN
    IF C_CAMPOUPD <> REPLACE(REPLACE(C_CAMPOUPD,'TRIM(',''),')','') THEN  --SE DEPURA POR FECHA DIRECTA
      IF C_TABLA IN ('JAQL819A','JAQL977') THEN --CAMPOFECHA ES NUMBER
        N_FECTRIM:= TO_NUMBER(TO_CHAR(P_FECHA,'YYYYMMDD'));
        --1RA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''999999''
         WHERE A.'||C_CAMPOFEC||' <= '||N_FECTRIM;
        COMMIT;
        --2DA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''888888''
         WHERE A.'||C_CAMPOFEC||' <= '||N_FECTRIM;
        COMMIT;
        --3RA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''777777''
         WHERE A.'||C_CAMPOFEC||' <= '||N_FECTRIM;
        COMMIT;
        --DEPURACIÓN 
        EXECUTE IMMEDIATE 'DELETE FROM '||C_TABLA||' A WHERE A.'||C_CAMPOFEC||' <= '||N_FECTRIM;
        COMMIT;
      ELSIF C_TABLA IN ('JAQL357') THEN --CAMPOFECHA ES VARCHAR
        C_FECTRIM := TO_CHAR(P_FECHA,'YYYYMMDD');
        --1RA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''999999''
         WHERE A.'||C_CAMPOFEC||' <= '||C_FECTRIM;
        COMMIT;
        --2DA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''888888''
         WHERE A.'||C_CAMPOFEC||' <= '||C_FECTRIM;
        COMMIT;
        --3RA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''777777''
         WHERE A.'||C_CAMPOFEC||' <= '||C_FECTRIM;
        COMMIT;
        --DEPURACIÓN 
        EXECUTE IMMEDIATE 'DELETE FROM '||C_TABLA||' A WHERE A.'||C_CAMPOFEC||' <= '||C_FECTRIM;
        COMMIT;
      ELSIF C_TABLA IN ('Z0E478') THEN --CONDICIÓN PARTICULAR
        --1RA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.Z0E478NOM = ''999999''
         WHERE A.Z0E463COD IN (5 /*BLOQUEADA*/, 8 /*VENCIDA*/, 9 /*CANCELADA*/) 
         AND A.'||C_CAMPOFEC||' <= '||P_FECHA;
        COMMIT;
        --2DA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.Z0E478NOM = ''888888''
         WHERE A.Z0E463COD IN (5 /*BLOQUEADA*/, 8 /*VENCIDA*/, 9 /*CANCELADA*/) 
         AND A.'||C_CAMPOFEC||' <= '||P_FECHA;
        COMMIT;
        --3RA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.Z0E478NOM = ''777777''
         WHERE A.Z0E463COD IN (5 /*BLOQUEADA*/, 8 /*VENCIDA*/, 9 /*CANCELADA*/) 
         AND A.'||C_CAMPOFEC||' <= '||P_FECHA;
        COMMIT;
        --DEPURACIÓN 
        EXECUTE IMMEDIATE 'DELETE FROM '||C_TABLA||' A 
        WHERE A.Z0E463COD IN (5 /*BLOQUEADA*/, 8 /*VENCIDA*/, 9 /*CANCELADA*/) 
        AND A.'||C_CAMPOFEC||' <= '||P_FECHA;
        COMMIT;
      ELSE --CAMPOFECHA ES DATE
        --1RA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''999999''
         WHERE A.'||C_CAMPOFEC||' <= '||P_FECHA;
        COMMIT;
        --2DA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''888888''
         WHERE A.'||C_CAMPOFEC||' <= '||P_FECHA;
        COMMIT;
        --3RA ITERACIÓN
        EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
           SET A.'||C_CAMPOUPD||' = ''777777''
         WHERE A.'||C_CAMPOFEC||' <= '||P_FECHA;
        COMMIT; 
        --DEPURACIÓN 
        EXECUTE IMMEDIATE 'DELETE FROM '||C_TABLA||' A WHERE A.'||C_CAMPOFEC||' <= '||P_FECHA;
        COMMIT; 
      END IF;
    ELSE--SE DEPURA A PARTIR DE LA TABLA Z0E478
      --1RA ITERACIÓN
      EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
         SET A.'||C_CAMPOUPD||' = ''999999''
        WHERE A.'||C_CAMPOUPD||' IN (SELECT Z0E478NRO FROM Z0E478 WHERE Z0E463COD IN (5 /*BLOQUEADA*/, 8 /*VENCIDA*/, 9 /*CANCELADA*/)
         AND Z0E478FAL <= '||P_FECHA||')';
      COMMIT;
      --2DA ITERACIÓN
      EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
         SET A.'||C_CAMPOUPD||' = ''888888''
        WHERE A.'||C_CAMPOUPD||' IN (SELECT Z0E478NRO FROM Z0E478 WHERE Z0E463COD IN (5 /*BLOQUEADA*/, 8 /*VENCIDA*/, 9 /*CANCELADA*/)
         AND Z0E478FAL <= '||P_FECHA||')';
      COMMIT;
      --3RA ITERACIÓN
      EXECUTE IMMEDIATE 'UPDATE '|| C_TABLA || ' A
         SET A.'||C_CAMPOUPD||' = ''777777''
        WHERE A.'||C_CAMPOUPD||' IN (SELECT Z0E478NRO FROM Z0E478 WHERE Z0E463COD IN (5 /*BLOQUEADA*/, 8 /*VENCIDA*/, 9 /*CANCELADA*/)
         AND Z0E478FAL <= '||P_FECHA||')';
      COMMIT;
      --DEPURACIÓN 
      EXECUTE IMMEDIATE 'DELETE FROM '||C_TABLA||' A 
      WHERE A.'||C_CAMPOUPD||' IN
         (SELECT Z0E478NRO
            FROM Z0E478 WHERE Z0E463COD IN (5 /*BLOQUEADA*/, 8 /*VENCIDA*/, 9 /*CANCELADA*/)
             AND Z0E478FAL <= '||P_FECHA;
      COMMIT;
    END IF;

  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => C_TABLA,
                                  DEGREE           => 12,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                  CASCADE          => TRUE);
  END;

  --LOG
  INSERT INTO AQPB884 VALUES (USER, SYSDATE, 'SP_CA_DEPURA_TRJ_'||C_TABLA);
  COMMIT;

END SP_CA_CDETAB_DEPUR;
/

