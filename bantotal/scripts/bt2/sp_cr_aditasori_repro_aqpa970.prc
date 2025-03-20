CREATE OR REPLACE PROCEDURE SP_CR_ADITASORI_REPRO_AQPA970(CTA    NUMBER,
                                                          OPER   NUMBER,
                                                          MODU   NUMBER,
                                                          SUBOPE NUMBER,
                                                          TASA   NUMBER) IS

  N_CONT1 NUMBER := 0;
  N_CONT2 NUMBER := 0;
  N_SUCU  NUMBER;
  N_MDA   NUMBER;
  N_PAP   NUMBER;
  N_TOP   NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM FSD011 B
   WHERE B.PGCOD = 1
     AND B.SCMOD = MODU
     AND B.SCCTA = CTA
     AND B.SCOPER = OPER
     AND B.SCSBOP = SUBOPE;

  IF N_CONT1 = 1 /*FSD011*/
   THEN

    SELECT SCSUC, SCMDA, SCPAP, SCTOPE
      INTO N_SUCU, N_MDA, N_PAP, N_TOP
      FROM FSD011 B
     WHERE B.PGCOD = 1
       AND B.SCMOD = MODU
       AND B.SCCTA = CTA
       AND B.SCOPER = OPER
       AND B.SCSBOP = SUBOPE;

    SELECT COUNT(*)
      INTO N_CONT2
      FROM AQPA970 A
     WHERE AQPA970FEP = TRUNC(SYSDATE)
       AND AQPA970EMP = 1
       AND AQPA970MOD = MODU ---+
       AND AQPA970SUC = N_SUCU --
       AND AQPA970MDA = N_MDA --
       AND AQPA970PAP = N_PAP --
       AND AQPA970CTA = CTA ---+
       AND AQPA970OPE = OPER ---+
       AND AQPA970SBO = SUBOPE ---+
       AND AQPA970TOP = N_TOP; --

    IF (N_CONT2 > 0) THEN
      --BORRAR
      EXECUTE IMMEDIATE 'create table operador.AQPA970_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from AQPA970 ' ||
                        'where AQPA970FEP = to_date(''' ||
                        TO_CHAR(TRUNC(SYSDATE), 'YYYYMMDD') ||
                        ''',''YYYYMMDD'') and AQPA970EMP = 1 and AQPA970MOD=' || MODU ||
                        ' and AQPA970SUC=' || N_SUCU ||
                        ' and AQPA970MDA = ' || N_MDA ||
                        ' and AQPA970PAP = ' || N_PAP ||
                        ' AND AQPA970CTA = ' || CTA || ' and AQPA970OPE = ' || OPER ||
                        ' AND AQPA970SBO = ' || SUBOPE ||
                        ' AND AQPA970TOP = ' || N_TOP;

      DELETE FROM AQPA970
       WHERE AQPA970FEP = TRUNC(SYSDATE)
         AND AQPA970EMP = 1
         AND AQPA970MOD = MODU ---+
         AND AQPA970SUC = N_SUCU --
         AND AQPA970MDA = N_MDA --
         AND AQPA970PAP = N_PAP --
         AND AQPA970CTA = CTA ---+
         AND AQPA970OPE = OPER ---+
         AND AQPA970SBO = SUBOPE ---+
         AND AQPA970TOP = N_TOP; --
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ' La Operacion:' || OPER ||
                           ' La suboperacion:' || SUBOPE || ' El modulo:' || MODU ||
                           ' considera ' || N_CONT2 ||
                           ' registro(s) en la AQPA970.' || CHR(13) ||
                           'Se eliminó registro en AQPA970.');
    END IF;

    INSERT INTO AQPA970
      (AQPA970FEP,
       AQPA970EMP,
       AQPA970MOD,
       AQPA970SUC,
       AQPA970MDA,
       AQPA970PAP,
       AQPA970CTA,
       AQPA970OPE,
       AQPA970SBO,
       AQPA970TOP,
       AQPA970TASA)
    VALUES
      (TRUNC(SYSDATE),
       1,
       MODU,
       N_SUCU, --
       N_MDA, --
       N_PAP, --
       CTA, ---+
       OPER, ---+
       SUBOPE, ---+
       N_TOP, --
       TASA); ---+
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SE INSERTO AQPA970, ' || N_CONT1 || ' registro.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ' La Operacion:' || OPER ||
                         ' La suboperacion:' || SUBOPE || ' El modulo:' || MODU ||
                         ' considera ' || N_CONT1 ||
                         ' registro(s) en la FSD011.' || CHR(13) ||
                         'No se realizó el insert a la AQPA970.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_ADITASORI_REPRO_AQPA970', CTA||'-'||OPER||'-'||MODU||'-'||SUBOPE||'-'||TASA);
commit;
END SP_CR_ADITASORI_REPRO_AQPA970;
/

