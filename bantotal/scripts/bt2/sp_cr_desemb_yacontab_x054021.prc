CREATE OR REPLACE PROCEDURE SP_CR_DESEMB_YACONTAB_X054021(CTA    NUMBER,
                                                          OPER   NUMBER,
                                                          SUBOPE NUMBER) IS

  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM X054021 A
   WHERE A.XLLOAOCTA = CTA
     AND A.XLLOAOOPER = OPER
     AND A.XLLOAOSBOP = SUBOPE
     AND A.XLLOUSTS = 0
     AND A.XLLOTXTCOD = 4
     AND A.XLLOTXTLIN = 1; --ELIMINAR REGISTRO PARA CONTINUAR DESEMBOLSO

  IF N_CONT1 = 1 THEN
    EXECUTE IMMEDIATE 'create table operador.x054021_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from x054021 ' ||
                      'where xlloaocta = ' || CTA || ' and xlloaooper=' || OPER ||
                      ' and xlloaosbop=' || SUBOPE ||
                      ' and xllousts=0 and xllotxtcod=4 and xllotxtlin=1';

    DELETE FROM X054021 A
     WHERE A.XLLOAOCTA = CTA
       AND A.XLLOAOOPER = OPER
       AND A.XLLOAOSBOP = SUBOPE
       AND A.XLLOUSTS = 0
       AND A.XLLOTXTCOD = 4
       AND A.XLLOTXTLIN = 1; --ELIMINAR REGISTRO PARA CONTINUAR DESEMBOLSO

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se eliminó x054021, ' || N_CONT1 || ' registro.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ' La Operacion:' || OPER ||
                         ' La suboperacion:' || SUBOPE || ' considera ' ||
                         N_CONT1 ||
                         ' registro(s) para el delete a x054021.' ||
                         CHR(13) || 'No se realizó el Delete.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_DESEMB_YACONTAB_X054021', CTA||'-'||OPER||'-'||SUBOPE);
commit;
END SP_CR_DESEMB_YACONTAB_X054021;
/

