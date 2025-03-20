CREATE OR REPLACE PROCEDURE SP_CR_JAQY800_VINC(CTA NUMBER, OPER NUMBER, INSTANCIA NUMBER) IS
  N_CONT NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(1)
    INTO N_CONT
    FROM JAQY800 J
   WHERE J.JAQY800PGCD = 1
     AND J.JAQY800CTA = CTA
     AND J.JAQY800OPE = OPER
     AND j.JAQY800INS = INSTANCIA;--18.12.2020

  IF N_CONT > 0 THEN

    EXECUTE IMMEDIATE 'create table operador.JAQY800_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from JAQY800 where JAQY800PGCD = 1 and jaqy800cta=' || CTA ||
                      'AND jaqy800ope=' || OPER ||' AND JAQY800INS='||INSTANCIA;

    UPDATE JAQY800 J
       SET J.JAQY800VINC = 'N'
     WHERE J.JAQY800CTA = CTA
       AND J.JAQY800OPE = OPER
       AND J.JAQY800INS = INSTANCIA
       AND J.JAQY800VINC = 'S';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                         ' registro(s) de JAQY800 para JAQY800CTA:' || CTA ||
                         ' , JAQY800OPE:' || OPER||' e JAQY800INS:'||INSTANCIA);
  ELSE
    DBMS_OUTPUT.PUT_LINE('La JAQY800CTA:' || CTA || ', JAQY800OPE:' || OPER ||' e JAQY800INS:'||INSTANCIA||
                         ' considera ' || N_CONT ||
                         ' registro(s) en JAQY800' || CHR(13) ||
                         'No se realizó el Update.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_JAQY800_VINC',   CTA||'-'||OPER||'-'||INSTANCIA);
commit;
END SP_CR_JAQY800_VINC;
/

