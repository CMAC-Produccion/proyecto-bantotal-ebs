CREATE OR REPLACE TRIGGER TG_UPD_FSR111
  after update on FSR111
  for each row
declare
  -- local variables here
begin
  if :old.i1mod in (22,122) and :old.i1tope = 4 and :old.inscod = 7 then
    update jaql726 a
       set a.jaql726esre = :new.r111co
     where jaql726pgco = :old.i1cod
       and jaql726scmo in (22,122)
       and jaql726scsu = :old.i1suc
       and jaql726scmd = :old.i1mda
       and jaql726scpa = :old.i1pap
       and jaql726scct = :old.i1cta
       and jaql726scop = :old.i1oper
       and jaql726scsb = :old.i1sbop
       and jaql726scto = :old.i1tope;  
  end if;

end TG_UPD_FSR111;
/

