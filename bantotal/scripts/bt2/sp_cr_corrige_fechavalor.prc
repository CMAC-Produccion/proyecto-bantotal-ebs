CREATE OR REPLACE PROCEDURE SP_CR_CORRIGE_FECHAVALOR(CTA    NUMBER,
                                                     OPER   NUMBER,
                                                     SUBOPE NUMBER,
                                                     DFECHA DATE) IS
  N_EXISTE NUMBER := 0;
  N_CONT NUMBER := 0;
BEGIN

  /*SELECT COUNT(*)
    INTO N_EXISTE
    FROM FSD010 J
   WHERE J.PGCOD = 1
     AND J.AOCTA = CTA
     AND J.AOOPER = OPER
     AND J.AOSBOP = SUBOPE;*/

  SELECT COUNT(*)
     INTO N_CONT
     FROM X054023 YY
     WHERE YY.XLLAOCTA = CTA
       AND YY.XLLAOOPER = OPER
       AND YY.XLLAOSBOP = SUBOPE;

  --IF N_EXISTE = 0 THEN
    IF N_CONT =1 THEN
      EXECUTE IMMEDIATE 'create table operador.x054023_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from x054023 ' ||
                        'where xllaocta = ' || CTA || ' and xllaooper = ' || OPER ||
                        ' and xllaosbop = ' || SUBOPE;

      UPDATE X054023 YY
         SET YY.XLLFVALOR = DFECHA
       WHERE YY.XLLAOCTA = CTA
         AND YY.XLLAOOPER = OPER
         AND YY.XLLAOSBOP = SUBOPE; -- 1 REGISTRO
      COMMIT;
      dbms_output.put_line('SE ACTUALIZO ' || n_cont || ' registro.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Va a actualizar más de un registro para la cuenta y operacion ingresada. No se realizó el update.');
    END IF;
  /*ELSE
    DBMS_OUTPUT.PUT_LINE('Existen registros en la FSD010 para la cuenta y operacion ingresada. No se realizó el update.');
  END IF;*/
  --log ejecucion
  insert into AQPB876 values (user,sysdate,'SP_CR_CORRIGE_FECHAVALOR',CTA||'-'||OPER||'-'||SUBOPE||'-'||to_char(DFECHA,'DD/MM/RRRR'));
  commit;
END SP_CR_CORRIGE_FECHAVALOR;
/

