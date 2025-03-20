create or replace procedure sp_rentabilidad_totales(re_fecha in date,re_usuario in char,RESULTADO OUT VARCHAR2 /*q out sys_refcursor*/) is
/*scnom varchar(250);
v_sql VARCHAR2 (4000);*/
cadena varchar(4000);
ld_fec varchar(6);
begin
RESULTADO := '';
cadena:='';
ld_fec := concat(to_char(re_fecha,'MM'), to_char(re_fecha,'YYYY')) ;
delete JAQZ259 where jaqz259SUC=1000 and jaqz259FECP=re_fecha;
commit;
-------------inserta los totalizados por concepto en la JAQZ259 con código de sucursal 1000
Begin
  Insert into JAQZ259 (JAQZ259FECP,JAQZ259CODC,JAQZ259SUC,JAQZ259SAL,JAQZ259CODPER,JAQZ259CODG,JAQZ259USU,JAQZ259FUPD)
  select c.jaqz259fecp,c.jaqz259codc,1000,sum(c.jaqz259sal),ld_fec,c.jaqz259codg,re_usuario,sysdate
  from JAQZ259 c where c.jaqz259fecp=re_fecha and 
  c.jaqz259codg in (select  jaqz259gcod from jaqz259g where jaqz259gtip=1)
  group by c.jaqz259fecp,c.jaqz259codc,c.jaqz259codg;
  commit;   
exception
            when others then
              RESULTADO := '1';
            end;
-------------------------
/*DECLARE
     CURSOR C2 IS select trim(scnom) from FST001 order by sucurs;
     scnom varchar(50); 
    BEGIN
     OPEN C2;
     LOOP
       FETCH C2 INTO scnom;
       EXIT WHEN C2%NOTFOUND;
       if (cadena!=' ') then
         cadena := cadena || ', ';
       end if;
       cadena := cadena ||'''' || scnom || '''';
     END LOOP;
     CLOSE C2;
   END;

   v_sql :='select * from (select jaqz259codc as mapeo,jaqz259cRUB as RUBro,jaqz259cdes,scnom,jaqz259sal
    from jaqz259 j join fst001 f on f.sucurs=j.jaqz259suc
    join jaqz259c c on c.jaqz259ccod=j.jaqz259codc 
    order by jaqz259codg)
    PIVOT
     (      
      sum(jaqz259sal)
      for scnom in  (' || cadena || ' )
     )';     
     open q FOR v_sql;  
*/
end sp_rentabilidad_totales;
/

