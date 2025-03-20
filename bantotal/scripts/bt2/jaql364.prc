CREATE OR REPLACE PROCEDURE "JAQL364" (aout_texto IN VARCHAR2)
IS
BEGIN
     INSERT INTO FSX016 (pgcod,hcmod,hsucor,htran,hnrel,hfcon,hcord,hcsubo,txcod,txoren,txtord)
     VALUES(1,0,11,0,0,current_date,0,0,666,1,aout_texto);
     commit;
END;
/

