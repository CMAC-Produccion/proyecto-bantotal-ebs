CREATE OR REPLACE TRIGGER TG_FST046_AU_01
  after update
  on FST046 
  for each row
declare
  lv_numdoc varchar2(12):='';
  lv_id     varchar2(11):='';
begin
  if :new.ubsuc <> :old.ubsuc then
    begin
      Select trim(a.jaqn002ndo) 
        into lv_numdoc 
        from jaqn002 a 
       where a.jaqn002usr = rpad(:old.ubuser,10,' ');
    Exception
    When others then  
      return;
    End;
    
    begin
      Select a.employee_id 
        into lv_id 
        from ca_alt_vs_empleados@erp a 
       where a.employee_num = lv_numdoc; 
    Exception
    When others then  
      return;
    End;    
    
    update aqpa141 a 
       set a.aqpa141fag = trunc(sysdate)
     where a.aqpa141cod = lv_id;
  End If;
exception
when others then  
  null;
end TG_FST046_AU_01;
/

