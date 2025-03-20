create or replace procedure SP_CR_UPDATE_JAQL406FOP is

begin
  
    update jaql406 
    set jaql406fop = jaql406fec
    where jaql406fop is null;
    
    commit;

end;
/

