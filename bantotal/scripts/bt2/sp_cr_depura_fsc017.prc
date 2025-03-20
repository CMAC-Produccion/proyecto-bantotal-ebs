CREATE OR REPLACE PROCEDURE SP_CR_DEPURA_FSC017
IS
  N_CONT NUMBER;
  N_MAX NUMBER;
  N_RESTA NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT MAX(IMPNRO) INTO N_MAX FROM FSC017 WHERE IMPNRO>0 AND IMPNRO<999999999;
  N_RESTA := N_MAX - (100000*7);
  SELECT COUNT(1) INTO N_CONT FROM FSC017 WHERE IMPNRO < N_RESTA AND IMPNRO NOT IN (-1,999999999);
  IF N_CONT > 0 THEN
    EXECUTE IMMEDIATE 'create table operador.FSC017_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' compress as select * from FSC017 where impnro<' ||
                      N_RESTA;

    DELETE FROM FSC017
    WHERE IMPNRO < N_RESTA AND IMPNRO NOT IN (-1,999999999);
    COMMIT;
    --SELECT * FROM FSC017 WHERE IMPNRO IN (999999999,-1,76175093)

    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'FSC017',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;
  END IF;
END SP_CR_DEPURA_FSC017;
/

