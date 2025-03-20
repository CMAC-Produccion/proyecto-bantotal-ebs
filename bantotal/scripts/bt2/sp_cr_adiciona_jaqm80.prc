CREATE OR REPLACE PROCEDURE SP_CR_ADICIONA_JAQM80(LN_INS NUMBER) IS
  N_CONT NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*) INTO N_CONT FROM JAQM80 A WHERE A.JAQM80SO = LN_INS;

  IF (N_CONT = 1) THEN

    EXECUTE IMMEDIATE 'create table operador.jaqm80_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from jaqm80 ' ||
                      'where jaqm80so =' || LN_INS;

    UPDATE JAQM80
       SET JAQM80ES = 'B', JAQM80SO = NULL
     WHERE JAQM80SO = LN_INS;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se procesó instancia:' || LN_INS);
  ELSE
    DBMS_OUTPUT.PUT_LINE('La Instancia :' || LN_INS || ' considera ' ||
                         N_CONT || ' registro(s) en la tabla jaqm80.' ||
                         CHR(13) || 'No se realizó el update.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_ADICIONA_JAQM80',   LN_INS);
commit;
END SP_CR_ADICIONA_JAQM80;
/

