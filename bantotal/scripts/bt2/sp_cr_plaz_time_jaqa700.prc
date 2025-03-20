CREATE OR REPLACE PROCEDURE SP_CR_PLAZ_TIME_JAQA700(CTA NUMBER,
                                                    PLZ NUMBER,
                                                    NCM number,
                                                    EST CHAR) IS
  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO

  SELECT COUNT(*)
    INTO N_CONT1
    FROM JAQA700 A
   WHERE A.JAQA700EMP = 1
     AND A.JAQA700CTA = CTA
     AND A.JAQA700EST = EST;

  IF N_CONT1 = 1 THEN
    EXECUTE IMMEDIATE 'create table operador.JAQA700_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from JAQA700 ' ||
                      'where JAQA700EMP = 1 and JAQA700CTA = ' || CTA ||
                      ' and JAQA700EST = ''' || EST || '''';
  
    update JAQA700
       set JAQA700PLZ = PLZ, JAQA700NCM = NCM
     where JAQA700CTA = CTA
       AND JAQA700EST = EST;
  
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizó JAQA700, ' || N_CONT1 ||
                         ' registro.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ' considera ' || N_CONT1 ||
                         ' registro(s) para el update a JAQA700.' ||
                         CHR(13) || 'No se realizó el Update.');
  END IF;
  insert into AQPB876 values (user,sysdate,'SP_CR_PLAZ_TIME_JAQA700',   CTA||'-'||PLZ||'-'||NCM||'-'||EST);
  commit;
END SP_CR_PLAZ_TIME_JAQA700;
/

