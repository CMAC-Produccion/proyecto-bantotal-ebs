CREATE OR REPLACE PROCEDURE SP_ACTUALIZA_TDW040(USUARIO in CHAR,SUCURSAL in number) IS
  CANTIDAD NUMBER;
  NOMBRE char(30);
BEGIN
  SELECT count(*) INTO CANTIDAD FROM tdw040 a WHERE a.tdw040pro=USUARIO;
    --Verifica proceso 1 (si el proceso ha sido ejecutado debe existir la fecha de proceso) :
    if cantidad>0 then
        delete from tdw040 WHERE tdw040pro=USUARIO;
    end if  ;
    select a.ubnom into NOMBRE from fst746 a where a.ubuser=USUARIO;
    insert into tdw040 values(USUARIO,NOMBRE ,SUCURSAL);
END;
/

