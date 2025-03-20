CREATE OR REPLACE PROCEDURE SP_CR_INS_SEGU_EXTOR_FPP001(MODULO      NUMBER,
                                                                 CTA         NUMBER,
                                                                 OPER        NUMBER,
                                                                 SUBOPER     NUMBER,
                                                                 LN_SGCOD    NUMBER,
                                                                 LN_PP001IMP NUMBER) IS
  N_CONT NUMBER;
  SUCU   NUMBER;
  MONE   NUMBER;
  PAPE   NUMBER;
  TOPE   NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO

  SELECT COUNT(*)
    INTO N_CONT
    FROM FSD010 A
   WHERE A.PGCOD = 1
     AND A.AOMOD = MODULO
     AND A.AOCTA = CTA
     AND A.AOOPER = OPER
     AND A.AOSBOP = SUBOPER;

  IF (N_CONT = 1) THEN
    SELECT A.AOSUC, A.AOMDA, A.AOPAP, A.AOTOPE
      INTO SUCU, MONE, PAPE, TOPE
      FROM FSD010 A
     WHERE A.PGCOD = 1
       AND A.AOMOD = MODULO
       AND AOCTA = CTA
       AND AOOPER = OPER
       AND AOSBOP = SUBOPER;

    INSERT INTO FPP001
      (PGCOD,
       AOMOD,
       AOSUC,
       AOMDA,
       AOPAP,
       AOCTA,
       AOOPER,
       AOSBOP,
       AOTOPE,
       SGCOD,
       PP001VC,
       PP001IMP,
       PP001PORC,
       PP001PLUS,
       PP001PART,
       PP001VEH,
       PP001INM,
       PP001END,
       PP001STAT,
       PP001CO,
       PP001AUX1,
       PP001AUX2,
       PP001AUX3,
       PP001AUX4,
       PP001AUX5,
       PP001AUX6,
       PP001AUX7)
    VALUES
      (1,
       MODULO, --PARAM_IN
       SUCU, --FSD010
       MONE, --FSD010
       PAPE, --FSD010
       CTA, --PARAM_IN
       OPER, --PARAM_IN
       SUBOPER, --PARAM_IN
       TOPE, --FSD010
       LN_SGCOD, --PARAM_IN
       0.00, --
       LN_PP001IMP, --PARAM_IN
       0.000000, --
       0.000000, --
       100.000000, --
       0, --
       0, --
       ' ', --
       ' ', --
       'S', --
       0.00, --
       0.000000, --
       TO_DATE('01-01-0001', 'dd-mm-yyyy'), --
       0.00, --
       '                              ', --
       ' ', --
       'I'); --INSERT

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se insertó en la FPP001.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La Cuenta :' || CTA || ' la operación:' || OPER ||
                         ' el módulo:' || MODULO || ' la suboperación:' ||
                         SUBOPER || ' considera ' || N_CONT ||
                         ' registro(s) en la tabla fsd010.' || CHR(13) ||
                         'No se realizó el insert.');
  END IF;

insert into AQPB876 values (user,sysdate,'SP_CR_INS_SEGU_EXTOR_FPP001',   MODULO||'-'||CTA||'-'||OPER||'-'||
SUBOPER||'-'||LN_SGCOD||'-'||LN_PP001IMP);
commit;
END SP_CR_INS_SEGU_EXTOR_FPP001;
/

