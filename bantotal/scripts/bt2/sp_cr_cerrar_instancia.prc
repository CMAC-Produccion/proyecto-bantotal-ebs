CREATE OR REPLACE PROCEDURE SP_CR_CERRAR_INSTANCIA(LN_INS NUMBER) IS
  LN_ID  NUMBER(10);
  N_CONT NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT
    FROM WFWRKITEMS A
   WHERE A.WFINSPRCID = LN_INS
     AND A.WFITEMSTSACT = 1;

  IF (N_CONT = 1) THEN
    SELECT A.WFITEMID
      INTO LN_ID
      FROM WFWRKITEMS A
     WHERE A.WFINSPRCID = LN_INS
       AND A.WFITEMSTSACT = 1;

    EXECUTE IMMEDIATE 'create table operador.wfworklist_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from wfworklist ' ||
                      'where wfwrklstitemid =' || LN_ID;
    EXECUTE IMMEDIATE 'create table operador.wfwrkitems_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from wfwrkitems ' ||
                      'where wfinsprcid =' || LN_INS ||
                      ' and wfitemstsact=1';
    EXECUTE IMMEDIATE 'create table operador.wfinstprc_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from wfinstprc ' ||
                      'where wfinsprcid =' || LN_INS;

    DELETE FROM WFWORKLIST C WHERE C.WFWRKLSTITEMID = LN_ID;

    UPDATE WFWRKITEMS A
       SET WFSTSCOD = 'B', WFITEMSTSACT = 0, WFITEMEND = SYSDATE
     WHERE A.WFINSPRCID = LN_INS
       AND A.WFITEMSTSACT = 1;

    UPDATE WFINSTPRC B
       SET WFINSPRCSTA = 'B', WFINSPRCOSTA = 0, WFINSPRCEND = SYSDATE
     WHERE B.WFINSPRCID = LN_INS;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se procesó instancia:' || LN_INS);
  ELSE
    DBMS_OUTPUT.PUT_LINE('La Instancia :' || LN_INS || ' considera ' ||
                         N_CONT || ' registro(s) en la tabla wfwrkitems.' ||
                         CHR(13) ||
                         'No se realizaron el delete y updates.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_CERRAR_INSTANCIA',   LN_INS);
commit;
END SP_CR_CERRAR_INSTANCIA;
/

