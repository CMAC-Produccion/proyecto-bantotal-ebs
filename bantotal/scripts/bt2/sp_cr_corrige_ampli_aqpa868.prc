CREATE OR REPLACE PROCEDURE SP_CR_CORRIGE_AMPLI_AQPA868(CTA NUMBER,
                                                     NID NUMBER) IS
  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM AQPA868 A
   WHERE A.AQPA868CTA = CTA
     AND A.AQPA868ID = NID;

  IF N_CONT1 = 1 THEN
    EXECUTE IMMEDIATE 'create table operador.AQPA868_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from AQPA868 ' ||
                      'where aqpa868cta = ' || CTA || ' and AQPA868ID=' || NID;

    DELETE FROM AQPA868 A
     WHERE A.AQPA868CTA = CTA
       AND A.AQPA868ID = NID;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se eliminó AQPA868, ' || N_CONT1 || ' registro.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ' La NID:' || NID ||
                         ' considera ' || N_CONT1 ||
                         ' registro(s) para el delete a AQPA868.' ||
                         CHR(13) || 'No se realizó el Delete.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_CORRIGE_AMPLI_AQPA868', CTA||'-'||NID);
commit;
END SP_CR_CORRIGE_AMPLI_AQPA868;
/

