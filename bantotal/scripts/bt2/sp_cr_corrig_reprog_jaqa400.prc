CREATE OR REPLACE PROCEDURE SP_CR_CORRIG_REPROG_JAQA400(CTA     NUMBER,
                                                        OPER    NUMBER,
                                                        FECHA   DATE,
                                                        OLD_EST CHAR,
                                                        NEW_EST CHAR) IS
  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM JAQA400
   WHERE JAQA400EMP = 1
     AND JAQA400CTA = CTA
     AND JAQA400OPE = OPER
     AND JAQA400FEC = FECHA
     AND JAQA400EST = OLD_EST;

  IF N_CONT1 = 1 THEN
    EXECUTE IMMEDIATE 'create table operador.JAQA400_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from JAQA400 ' ||
                      'where JAQA400EMP = 1 ' || ' and JAQA400CTA = ' || CTA ||
                      ' and JAQA400OPE = ' || OPER || ' and JAQA400FEC =
                      TO_DATE('''||to_char(FECHA,'YYYYMMDD')||''','' YYYYMMDD '') and JAQA400EST = '' ||
                      OLD_EST||''';

    UPDATE JAQA400
       SET JAQA400EST = NEW_EST
     WHERE JAQA400EMP = 1
       AND JAQA400CTA = CTA
       AND JAQA400OPE = OPER
       AND JAQA400FEC = FECHA
       AND JAQA400EST = OLD_EST;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizó JAQA400, ' || N_CONT1 ||
                         ' registro.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ', la operacion:' || OPER ||
                         ', la fecha:'||FECHA||' y el estado:' ||
                         OLD_EST || ' considera ' || N_CONT1 ||
                         ' registro(s) para el update a JAQA400.' ||
                         CHR(13) || 'No se realizó el Update.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_CORRIG_REPROG_JAQA400', CTA||'-'||OPER||'-'||to_char(FECHA,'DD/MM/RRRR')||'-'||OLD_EST||'-'||NEW_EST );
commit;
END SP_CR_CORRIG_REPROG_JAQA400;
/

