CREATE OR REPLACE TRIGGER TG_FSD015_AU_01
  after update on fsd015  
  FOR EACH ROW  
    
declare
  -- local variables here
  MODULO NUMBER:=22;
  TRAN   NUMBER:=300;
   
begin
  if MODULO = :new.ITMOD and tran =:new.ITTRAN and :new.ITCONT = 'S' then
      update jaqz551
           set jaqz551hora = :new.ITHORA--,
           --    jaqz551a5= to_char(:new.ITMOD)||to_char(:new.ITTRAN)||to_char(:new.ITNREL)||:new.ITHORA
         where jaqz551pgc   = :new.PGCOD
           and jaqz551isuc1 = :new.ITSUC
           and jaqz551mod   = :new.ITMOD
           and jaqz551tran  = :new.ITTRAN
           and jaqz551rel   = :new.ITNREL
           and jaqz551fech  = :new.ITFCON;
  end if;
exception
  when others then
     null;    
end TG_FSD015_AU_01;
/

