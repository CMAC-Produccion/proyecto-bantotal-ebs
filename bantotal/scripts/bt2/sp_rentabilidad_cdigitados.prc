create or replace procedure sp_rentabilidad_cdigitados(re_fecha in date,re_usuario in char,RESULTADO OUT VARCHAR2) is
begin
   RESULTADO := '';
   -- carga los valores que fueron ingresados digitalmente en el JAQZ259I al JAQZ259        
--    Begin
      update
      (select jaqz259sal,jaqz259isal from jaqz259 j
      inner join jaqz259i i on i.jaqz259icodc=j.jaqz259codc and i.jaqz259isuc=j.jaqz259suc and i.jaqz259ifecp=j.jaqz259fecp and i.jaqz259ifecp=re_fecha
      and j.jaqz259codg in (select JAQZ259GCOD from JAQZ259G where JAQZ259GTIP=1)) t
      set t.jaqz259sal=t.jaqz259isal;
      commit;
--    exception
--            when others then
--              RESULTADO := '1';
--            end;

end sp_rentabilidad_cdigitados;
/

