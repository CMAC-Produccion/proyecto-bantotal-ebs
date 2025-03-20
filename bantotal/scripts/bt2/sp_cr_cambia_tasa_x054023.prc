CREATE OR REPLACE PROCEDURE SP_CR_CAMBIA_TASA_X054023(CTA  NUMBER,
                                                     OPER NUMBER,
                                                     SUBOPE NUMBER,
                                                     TASA NUMBER) IS

  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM X054023 A
   WHERE A.XLLAOCTA=CTA AND A.XLLAOOPER=OPER AND A.XLLAOSBOP=SUBOPE;

  IF N_CONT1 = 1 THEN
    EXECUTE IMMEDIATE 'create table operador.X054023_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from X054023 ' ||
                      'where XLLAOCTA = ' || CTA||' and XLLAOOPER='||OPER||' and XLLAOSBOP='||SUBOPE;

    UPDATE X054023 A
    SET A.XLLTASAP=TASA
    WHERE A.XLLAOCTA=CTA AND A.XLLAOOPER=OPER AND A.XLLAOSBOP=SUBOPE;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SE ACTUALIZó X054023, ' || N_CONT1 ||
                         ' registro.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA ||' La Operacion:'||OPER||' La suboperacion:'||SUBOPE||
                           ' considera ' || N_CONT1 ||
                           ' registro(s) para el update a X054023.' ||
                           CHR(13) || 'No se realizó el Update.');
  END IF;

insert into AQPB876 values (user,sysdate,'SP_CR_CAMBIA_TASA_X054023',   CTA||'-'||OPER||'-'||SUBOPE||'-'||TASA);
commit;
END SP_CR_CAMBIA_TASA_X054023;
/

