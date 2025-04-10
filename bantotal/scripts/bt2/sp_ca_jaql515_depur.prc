CREATE OR REPLACE PROCEDURE SP_CA_JAQL515_DEPUR(P_FECHA DATE) IS
  CURSOR C_IDX IS
    SELECT INDEX_NAME INDICE
      FROM DBA_INDEXES
     WHERE TABLE_NAME = 'JAQL515'
       AND TABLE_OWNER = 'BANTPROD';
BEGIN
  --1RA ITERACIÓN
  UPDATE JAQL515 A
     SET A.JAQL515SUMIN = '99999999999999999999'
   WHERE A.JAQL515FEMOV < P_FECHA;
  COMMIT;
  --2DA ITERACIÓN
  UPDATE JAQL515 A
     SET A.JAQL515SUMIN = '88888888888888888888'
   WHERE A.JAQL515FEMOV < P_FECHA;
  COMMIT;
  --3RA ITERACIÓN
  UPDATE JAQL515 A
     SET A.JAQL515SUMIN = '77777777777777777777'
   WHERE A.JAQL515FEMOV < P_FECHA;
  COMMIT;
  --DEPURACIÓN
  DELETE /*+PARALLEL(15)*/
  FROM JAQL515 A
   WHERE A.JAQL515FEMOV < P_FECHA;
  COMMIT;

  BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                  TABNAME          => 'JAQL515',
                                  DEGREE           => 12,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                  CASCADE          => TRUE);
  END;

  FOR I IN C_IDX LOOP
    EXECUTE IMMEDIATE 'alter index ' || I.INDICE || ' rebuild online';
  END LOOP;
  --LOG
  INSERT INTO AQPB884 VALUES (USER, SYSDATE, 'SP_CA_JAQL515_DEPUR');
  COMMIT;

END SP_CA_JAQL515_DEPUR;
/

