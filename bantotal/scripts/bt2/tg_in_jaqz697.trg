CREATE OR REPLACE TRIGGER TG_IN_JAQZ697
  after update on jaqz697
  for each row

declare
  -- local variables here
begin
  if :NEW.JAQZ697FAN is not null and :new.jaqz697mot is null then
  
    pq_cr_tasas_camp_nova.sp_cr_elimpiza(:new.jaqz697cta);
  
  end if;
exception
  when others then
    null;
  
end TG_IN_JAQZ697;
/

