CREATE OR REPLACE PROCEDURE SP_CR_LINEA_VENCIDA_FSD010_11(CTA    NUMBER,
                                        OPER   NUMBER,
                                        MODULO NUMBER) IS
  --27.08.2020
  N_CONT1 NUMBER := 0;
  N_CONT2 NUMBER := 0;
  FECHA DATE;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  IF (MODULO IN (116, 117)) THEN
    SELECT COUNT(*)
      INTO N_CONT1
      FROM FSD010
     WHERE PGCOD = 1
       AND AOMOD = MODULO
       AND AOCTA = CTA
       AND AOOPER = OPER;

    SELECT COUNT(*)
      INTO N_CONT2
      FROM FSD011
     WHERE PGCOD = 1
       AND SCCTA = CTA
       AND SCOPER = OPER
       AND SCMOD = MODULO;
    IF N_CONT1 = 1 AND N_CONT2 = 1 THEN
      EXECUTE IMMEDIATE 'create table operador.FSD010_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from FSD010 ' ||
                        'where PGCOD=1 and AOMOD = ' || MODULO ||
                        ' and AOCTA = ' || CTA || ' and AOOPER = ' || OPER;
      EXECUTE IMMEDIATE 'create table operador.FSD011_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from FSD011 ' ||
                        'where PGCOD=1 and sccta = ' || CTA ||
                        ' and scoper = ' || OPER || ' and scmod = ' ||
                        MODULO;
                        
      IF(TO_CHAR(SYSDATE,'D')=6) THEN      --SABADO            
        FECHA := TRUNC(SYSDATE)+2;
      ELSE  
        FECHA := TRUNC(SYSDATE)+1;
      END IF;
      
      UPDATE FSD010
         SET AOFVTO = FECHA
       WHERE PGCOD = 1
         AND AOMOD = MODULO
         AND AOCTA = CTA
         AND AOOPER = OPER;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('SE ACTUALIZO ' || N_CONT1 ||
                           ' registro en FSD010.');
      UPDATE FSD011
         SET SCFVTO = FECHA
       WHERE PGCOD = 1
         AND SCCTA = CTA
         AND SCOPER = OPER
         AND SCMOD = MODULO;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('SE ACTUALIZO ' || N_CONT2 ||
                           ' registro en FSD011.');
    ELSE
      IF N_CONT1 <> 1 THEN
        DBMS_OUTPUT.PUT_LINE('La Cuenta:' || CTA || ' La Operacion:' || OPER ||
                             ' El Modulo:' || MODULO || ' considera ' ||
                             N_CONT1 || ' registro(s).' || CHR(13) ||
                             'No se realizó el Update en la FSD010.');
      END IF;
      IF N_CONT2 <> 1 THEN
        DBMS_OUTPUT.PUT_LINE('La Cuenta:' || CTA || ' La Operacion:' || OPER ||
                             ' El Modulo:' || MODULO || ' considera ' ||
                             N_CONT2 || ' registro(s).' || CHR(13) ||
                             'No se realizó el Update en la FSD011.');
      END IF;
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Valor MODULO no es 116 o 117. Revisar');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_LINEA_VENCIDA_FSD010_11',   CTA||'-'||OPER||'-'||MODULO);
commit;
END SP_CR_LINEA_VENCIDA_FSD010_11;
/

