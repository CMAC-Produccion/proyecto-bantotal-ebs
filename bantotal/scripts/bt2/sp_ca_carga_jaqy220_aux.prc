CREATE OR REPLACE PROCEDURE SP_CA_CARGA_JAQY220_AUX IS
BEGIN
  DELETE JAQY220_AUX;
  COMMIT;
  INSERT INTO JAQY220_AUX
    SELECT * FROM JAQY220;

  COMMIT;
  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'JAQY220_AUX',
                                  DEGREE           => 4,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 100,
                                  CASCADE          => TRUE);
  END;
END SP_CA_CARGA_JAQY220_AUX;
/

