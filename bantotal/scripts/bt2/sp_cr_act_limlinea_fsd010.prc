CREATE OR REPLACE PROCEDURE SP_CR_ACT_LIMLINEA_FSD010(CTA  NUMBER,
                                                               OPER NUMBER) IS
  N_CONT  NUMBER;
  N_CONT2 NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT
    FROM FSD010 K
   WHERE K.PGCOD = 1
     AND K.AOMOD = 117
     AND K.AOCTA = CTA
     AND K.AOOPER = OPER;

  SELECT COUNT(*)
    INTO N_CONT2
    FROM FSD011 L
   WHERE L.PGCOD = 1
     AND L.SCCTA = CTA
     AND L.SCOPER = OPER
     AND L.SCMOD = 117
     AND L.SCSDO > 0;

  IF (N_CONT = 1 AND N_CONT2 = 1) THEN

    EXECUTE IMMEDIATE 'create table operador.fsd010_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from fsd010 ' ||
                      'where PGCOD = 1 and AOMOD=117 and  AOCTA=' || CTA ||
                      ' and aooper=' || OPER;

    UPDATE FSD010 K
       SET K.AOIMP =
           (SELECT SCSDO
              FROM FSD011 L
             WHERE L.PGCOD = 1
               AND L.SCCTA = K.AOCTA
               AND L.SCOPER = K.AOOPER
               AND L.SCMOD = 117
               AND L.SCSDO > 0)
     WHERE K.PGCOD = 1
       AND K.AOMOD = 117
       AND K.AOCTA = CTA
       AND K.AOOPER = OPER;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se procesó cuenta:' || CTA || ' y operación:' || OPER ||
                         ' en la FSD010.');
  ELSE
    IF (N_CONT <> 1) THEN
      DBMS_OUTPUT.PUT_LINE('La cuenta :' || CTA || ' y operación:' || OPER ||
                           ' considera ' || N_CONT ||
                           ' registro(s) en la tabla fsd010.' || CHR(13) ||
                           'No se realizó el update.');
    END IF;
    IF (N_CONT2 <> 1) THEN
      DBMS_OUTPUT.PUT_LINE('La cuenta :' || CTA || ' y operación:' || OPER ||
                           ' considera ' || N_CONT2 ||
                           ' registro(s) en la tabla fsd011.' || CHR(13) ||
                           'No se realizó el update.');
    END IF;
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_ACT_LIMLINEA_FSD010',   CTA||'-'||OPER);
commit;
END SP_CR_ACT_LIMLINEA_FSD010;
/

