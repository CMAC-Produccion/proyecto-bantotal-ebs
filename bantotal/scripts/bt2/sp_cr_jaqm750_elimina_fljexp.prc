CREATE OR REPLACE PROCEDURE SP_CR_JAQM750_ELIMINA_FLJEXP(P_JAQM750FCH DATE,
                                                 P_JAQM750REG NUMBER) IS
  N_CONT NUMBER;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM JAQM750 A
   WHERE A.JAQM750FCH = P_JAQM750FCH
     AND A.JAQM750REG = P_JAQM750REG;

  IF N_CONT > 0 THEN

    EXECUTE IMMEDIATE 'create table operador.JAQM750_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from JAQM750 A where A.JAQM750FCH = to_date(''' ||
                      TO_CHAR(P_JAQM750FCH, 'YYYYMMDD') ||
                      ''',''YYYYMMDD'') AND A.JAQM750REG =' || P_JAQM750REG;
    DELETE FROM JAQM750 A
     WHERE A.JAQM750FCH = P_JAQM750FCH
       AND A.JAQM750REG = P_JAQM750REG;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                         ' registro(s) de JAQM750 para JAQM750FCH:' ||
                         P_JAQM750FCH || ' y JAQM750REG:' || P_JAQM750REG);
  ELSE
    DBMS_OUTPUT.PUT_LINE('La JAQM750FCH:' || P_JAQM750FCH || ' y JAQM750REG:' ||
                         P_JAQM750REG || ' considera ' || N_CONT ||
                         ' registro(s) en JAQM750' || CHR(13) ||
                         'No se realizó el Delete.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_JAQM750_ELIMINA_FLJEXP', to_char(P_JAQM750FCH,'DD/MM/RRRR')||'-'||P_JAQM750REG);
commit;  
END SP_CR_JAQM750_ELIMINA_FLJEXP;
/

