CREATE OR REPLACE PROCEDURE SP_CR_JAQM80_ELIMINA(P_JAQM80FC DATE,
                                                 P_JAQM80ID NUMBER) IS
  N_CONT NUMBER;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM JAQM80 A
   WHERE A.JAQM80FC = P_JAQM80FC
     AND A.JAQM80ID = P_JAQM80ID;

  IF N_CONT > 0 THEN
  
    EXECUTE IMMEDIATE 'create table operador.JAQM80_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from JAQM80 A where A.JAQM80FC = to_date(''' ||
                      TO_CHAR(P_JAQM80FC, 'YYYYMMDD') ||
                      ''',''YYYYMMDD'') AND A.JAQM80ID =' || P_JAQM80ID;
    DELETE FROM JAQM80 A
     WHERE A.JAQM80FC = P_JAQM80FC
       AND A.JAQM80ID = P_JAQM80ID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                         ' registro(s) de JAQM80 para JAQM80FC:' ||
                         P_JAQM80FC || ' y JAQM80ID:' || P_JAQM80ID);
  ELSE
    DBMS_OUTPUT.PUT_LINE('La JAQM80FC:' || P_JAQM80FC || ' y JAQM80ID:' ||
                         P_JAQM80ID || ' considera ' || N_CONT ||
                         ' registro(s) en JAQM80' || CHR(13) ||
                         'No se realizó el Delete.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_JAQM80_ELIMINA', to_char(P_JAQM80FC,'DD/MM/RRRR')||'-'||P_JAQM80ID);
commit;
END SP_CR_JAQM80_ELIMINA;
/

