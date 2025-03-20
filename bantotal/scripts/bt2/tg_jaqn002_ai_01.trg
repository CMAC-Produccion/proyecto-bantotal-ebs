CREATE OR REPLACE TRIGGER TG_JAQN002_AI_01
  after insert
  on JAQN002 
  for each row
declare
  lv_id     varchar2(11):='';
begin 
  begin
    Select a.employee_id 
      into lv_id 
      from ca_alt_vs_empleados@erp a 
     where a.employee_num = trim(:new.jaqn002ndo); 
  Exception
  When others then  
    return;
  End;
  begin
    insert into aqpa141(aqpa141cod,
                        aqpa141fag
                       ) values
                       (lv_id,
                        trunc(sysdate)
                       );
  exception
  when others then                       
    return;
  end;
Exception
when others then
    null;   
end TG_JAQN002_AI_01;
/

