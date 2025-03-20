CREATE OR REPLACE PROCEDURE SP_SY_COLL_INDUTI
IS
  INDICE VARCHAR2(30);
  PART VARCHAR2(1);
  CURSOR C_IND
  IS
    SELECT *
     FROM /*sys.*/V$OBJECT_USAGE
     WHERE USED IN ('YES','NO');
BEGIN
  FOR I IN C_IND LOOP
    BEGIN
      select INDEX_NAME
       INTO INDICE
       from systabrep.INDICES_UTILIZADOS
       WHERE trunc(fecha) = trunc(sysdate) and INDEX_NAME=I.INDEX_NAME;
    EXCEPTION
      when no_data_found then
        insert into systabrep.INDICES_UTILIZADOS
        values(sysdate,user,I.INDEX_NAME,I.TABLE_NAME,PART,I.MONITORING,I.USED,I.START_MONITORING,I.END_MONITORING);
        COMMIT;
    END;
  END LOOP;
EXCEPTION
    when others then
         null;
END SP_SY_COLL_INDUTI;
/

