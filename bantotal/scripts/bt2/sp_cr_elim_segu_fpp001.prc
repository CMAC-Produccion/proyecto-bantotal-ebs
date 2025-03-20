CREATE OR REPLACE PROCEDURE SP_CR_ELIM_SEGU_FPP001(MODU    NUMBER,
                                                   CTA     NUMBER,
                                                   OPER    NUMBER,
                                                   SUBOPE  NUMBER,
                                                   V_SGCOD NUMBER) IS
  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM FPP001
   WHERE PGCOD = 1
     AND AOMOD = MODU
     AND AOCTA = CTA
     AND AOOPER = OPER
     AND AOSBOP = SUBOPE
     AND SGCOD = V_SGCOD;

  IF N_CONT1 = 1 THEN
    EXECUTE IMMEDIATE 'create table operador.FPP001_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from FPP001 ' ||
                      'where PGCOD = 1 and AOMOD = ' || MODU ||
                      ' and AOCTA = ' || CTA || ' and AOOPER = ' || OPER ||
                      ' and AOSBOP = ' || SUBOPE || ' and SGCOD = ' ||
                      V_SGCOD;

    DELETE FROM FPP001
     WHERE PGCOD = 1
       AND AOMOD = MODU
       AND AOCTA = CTA
       AND AOOPER = OPER
       AND AOSBOP = SUBOPE
       AND SGCOD = V_SGCOD;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se eliminó de FPP001, ' || N_CONT1 ||
                         ' registro.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('El módulo :' || MODU || ', la cuenta:' || CTA ||
                         ', la operacion:' || OPER || ', la suboperacion:' ||
                         SUBOPE || ' y el codigo de seguro:' || V_SGCOD ||
                         ' considera ' || N_CONT1 ||
                         ' registro(s) para el delete a FPP001.' ||
                         CHR(13) || 'No se realizó el Delete.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_ELIM_SEGU_FPP001',  MODU||'-'||CTA||'-'||OPER||'-'||SUBOPE||'-'||V_SGCOD );
commit;
END SP_CR_ELIM_SEGU_FPP001;
/

