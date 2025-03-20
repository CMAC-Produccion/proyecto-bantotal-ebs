CREATE OR REPLACE PROCEDURE SP_JAQN870_AYUDA(P_JAQN870TIPN NUMBER,
                                             P_JAQN870CTA  NUMBER,
                                             P_JAQN870OPE  NUMBER,
                                             P_JAQN870TIPA NUMBER) IS
  N_CONT NUMBER := 0;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM JAQN870
   WHERE JAQN870CTA = P_JAQN870CTA
     AND JAQN870OPE = P_JAQN870OPE
     AND JAQN870TIP = P_JAQN870TIPA
     AND JAQN870EST = 'I';

  IF N_CONT = 1 THEN

    EXECUTE IMMEDIATE 'create table operador.JAQN870_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from JAQN870 where JAQN870CTA=' ||
                      P_JAQN870CTA || ' and JAQN870OPE ='||
                      P_JAQN870OPE || ' and JAQN870TIP ='||
                      P_JAQN870TIPA || ' and JAQN870EST = ''I''';

    UPDATE JAQN870
       SET JAQN870TIP = P_JAQN870TIPN
     WHERE JAQN870CTA = P_JAQN870CTA
       AND JAQN870OPE = P_JAQN870OPE
       AND JAQN870TIP = P_JAQN870TIPA
       AND JAQN870EST = 'I';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                         ' registro(s) en JAQN870 para JAQN870CTA:' ||
                         P_JAQN870CTA || ' , JAQN870OPE:' || P_JAQN870OPE|| ' , JAQN870TIP:' || P_JAQN870TIPA|| ' y JAQN870EST: I');
  ELSE
    DBMS_OUTPUT.PUT_LINE('El JAQN870CTA:' || P_JAQN870CTA ||
                         ' , JAQN870OPE:' || P_JAQN870OPE ||
												 ' , JAQN870TIP:' || P_JAQN870TIPA ||
												 ' y JAQN870EST: I  considera ' ||
                         N_CONT || ' registro(s) en la JAQN870.' ||
                         CHR(13) || 'No se realizó el Update.');
  END IF;

  insert into AQPB876
  values
    (user,
     sysdate,
     'SP_JAQN870_AYUDA',
     P_JAQN870TIPN || '-' || P_JAQN870CTA || '-' ||
     P_JAQN870OPE || '-' || P_JAQN870TIPA);
  commit;
END SP_JAQN870_AYUDA;
/

