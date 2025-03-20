CREATE OR REPLACE PROCEDURE SP_CR_CORRIGE_PANEL_EXCEP(VI_CODIGO NUMBER) IS
  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
     from fst198 where tp1nro1 = VI_CODIGO and tp1desc = to_char(trunc(sysdate), 'DD/MM/RRRR');

  IF N_CONT1 <> 1 THEN

    insert into fst198 (tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3,tp1nro1,tp1desc)
  values(1,10899,400000,109,
  (select (max(tp1corr3)+1) from fst198 where tp1cod1=10899 and tp1corr1=400000 and tp1corr2=109 and tp1corr3>=0),
  VI_CODIGO,/* Ingresar Instancia*/
  to_char(trunc(sysdate),'dd/mm/yyyy'));

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Se insertó en tabla FST198, 1 registro.');

  ELSE
    DBMS_OUTPUT.PUT_LINE('La instancia ' || VI_CODIGO ||
                         ' ya se encuentra registrada. No se realizó el insert.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_CORRIGE_PANEL_EXCEP', VI_CODIGO);
commit;
END SP_CR_CORRIGE_PANEL_EXCEP;
/

