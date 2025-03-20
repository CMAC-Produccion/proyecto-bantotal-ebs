CREATE OR REPLACE PROCEDURE SP_EST_CADENA_RIESGOS (FECHA IN DATE) IS
  n_cont number;
BEGIN
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL = TRUE';

  IF (TRUNC(SYSDATE) = TRUNC(LAST_DAY(SYSDATE))) THEN --si es fin de mes
 
    IF(TO_CHAR(SYSDATE,'D') = '7') THEN               --si es día domingo hay que borrar data antes de ejecutar cadena de riesgos
    
      SELECT /*+PARALLEL(FSD212,15)*/
       COUNT(*)
        INTO N_CONT
        FROM FSD212
       WHERE FSD212.Pgcod = 1
         AND FSD212.CatCod in (1, 6)
         AND FSD212.Catfchdes = FECHA; --1m
      
      IF N_CONT > 0 THEN 

        --Tabla de calificación la cual se vuelve a recalcular
        EXECUTE IMMEDIATE 'CREATE INDEX FSD2123 ON FSD212(PGCOD,CATCOD,CATFCHDES) PARALLEL 10 NOLOGGING TABLESPACE BANTPROD_C_IDX';--5M
        EXECUTE IMMEDIATE 'ALTER INDEX FSD2123 PARALLEL 1 LOGGING';

        BEGIN--3m
            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                          TABNAME          => 'FSD212',
                                          DEGREE           => 10,
                                          GRANULARITY      => 'ALL',
                                          ESTIMATE_PERCENT => 20,
                                          CASCADE          => TRUE);
        END;

        DELETE /*+parallel(FSD212,15)*/ FROM FSD212
         WHERE FSD212.Pgcod = 1
           AND FSD212.CatCod = 6
           AND FSD212.Catfchdes = FECHA/*TO_DATE('31082016', 'DDMMYYYY')*/;--9m
        commit;

        DELETE /*+parallel(FSD212,15)*/ FROM FSD212
         WHERE FSD212.Pgcod = 1
           AND FSD212.CatCod = 1
           AND FSD212.Catfchdes = FECHA/*TO_DATE('31082016', 'DDMMYYYY')*/;--8m
        commit;

        EXECUTE IMMEDIATE 'DROP INDEX BANTPROD.FSD2123';
        
      END IF;  
      
    END IF;
  END IF;


  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'FSD212',
                                  DEGREE           => 10,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 20,
                                  CASCADE          => TRUE);
  END;

  --Tablas temporales de cadena de riesgos
  EXECUTE IMMEDIATE 'TRUNCATE TABLE FRI100';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE FRI101';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE FRI102';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE FRI105';

  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'FRI100',
                                  DEGREE           => 10,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 20,
                                  CASCADE          => TRUE);
  END;

  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'FRI101',
                                  DEGREE           => 10,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 20,
                                  CASCADE          => TRUE);
  END;

  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'FRI102',
                                  DEGREE           => 10,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 20,
                                  CASCADE          => TRUE);
  END;

  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'FRI105',
                                  DEGREE           => 10,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 20,
                                  CASCADE          => TRUE);
  END;

  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'FSD011',
                                  DEGREE           => 10,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 20,
                                  CASCADE          => TRUE);
  END;

END;
/

