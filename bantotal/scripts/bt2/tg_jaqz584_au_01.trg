CREATE OR REPLACE TRIGGER TG_JAQZ584_AU_01
 after update
  on fst017 
  
declare
  -- local variables here
  cursor datos (fecha1 date) is
  select * from  jaqz584
   where jaqz584fecini = fecha1;
fecha date;    
begin
  select pgfape  into fecha from fst017 where pgcod = 1;
  For reg in datos(fecha) loop
    update jaqz584
       set jaqz584est ='N'
     where jaqz584cod = reg.jaqz584cod
       and jaqz584codigo = reg.jaqz584codigo
       and jaqz584est = 'S';
  end loop;
    update jaqz584
       set jaqz584est ='S'
     where jaqz584est = 'H'
       and jaqz584fecini  = fecha;
  
end TG_JAQZ584_AU_01;
/

