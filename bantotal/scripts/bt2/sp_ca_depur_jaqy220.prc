CREATE OR REPLACE PROCEDURE SP_CA_DEPUR_JAQY220 IS
  CURSOR C1 IS
    SELECT JAQY220COR JAQY220COR_2, JAQY220USU JAQY220USU_2
      FROM JAQY220_AUX;
BEGIN
  FOR I IN C1 LOOP
    DELETE FROM JAQY220
     WHERE JAQY220COR = I.JAQY220COR_2
       AND JAQY220USU = I.JAQY220USU_2;
    COMMIT;
  END LOOP;

  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'JAQY220',
                                  DEGREE           => 4,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 100,
                                  CASCADE          => TRUE);
  END;
END SP_CA_DEPUR_JAQY220;
/

