CREATE OR REPLACE TRIGGER "CREA_ASESOR_INS"
  after insert on fst046
  
  for each row
declare
  -- pragma autonomous_transaction;

  -- local variables here

begin
  SP_ACTUALIZA_TDW040 (:new.ubuser,:new.ubsuc) ;  
end CREA_ASESOR;
/

