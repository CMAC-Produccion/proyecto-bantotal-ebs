CREATE OR REPLACE PROCEDURE SP_CR_RECLASIF_FSD011(CTA    NUMBER,
                                                  OPER   NUMBER,
                                                  SUBOPE NUMBER,
                                                  MODU   NUMBER,
                                                  FECHA  DATE) IS
  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM FSD011
   WHERE PGCOD = 1
     AND SCCTA = CTA
     AND SCOPER = OPER
     AND SCSBOP = SUBOPE
     AND SCMOD = MODU;

  IF N_CONT1 = 1 THEN
    EXECUTE IMMEDIATE 'create table operador.FSD011_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from FSD011 ' ||
                      'where PGCOD = 1 and SCCTA = ' || CTA ||
                      ' and SCOPER = ' || OPER || ' and SCSBOP = ' ||
                      SUBOPE || ' and SCMOD = ' || MODU;

    UPDATE FSD011
       SET SCFVAL = FECHA
     WHERE PGCOD = 1
       AND SCCTA = CTA
       AND SCOPER = OPER
       AND SCSBOP = SUBOPE
       AND SCMOD = MODU;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizó FSD011, ' || N_CONT1 ||
                         ' registro.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ', la operación:' || OPER ||
                         ', la suboperación:' || SUBOPE || ' y modulo:' || MODU ||
                         ' considera ' || N_CONT1 ||
                         ' registro(s) para el update a FSD011.' ||
                         CHR(13) || 'No se realizó el Update.');
  END IF;
  insert into AQPB876 values (user,sysdate,'SP_CR_RECLASIF_FSD011',   CTA||'-'||OPER||'-'||SUBOPE||'-'||MODU||'-'||to_char(FECHA,'DD/MM/RRRR'));
  commit;
END SP_CR_RECLASIF_FSD011;
/

