CREATE OR REPLACE TRIGGER TG_JAQL472_UPD
  after update on JAQL472
  for each row
declare

begin
  if nvl(:new.JAQL472EXT,'N') = 'S' then
  
     begin
       update TS_AP_CA_DET_PAGOS_INT@erp a
          set a.STATUS_PAYMENT   = null, --NULO X EXTORNO
              a.DATE_PAYMENT     = null, -- sysdate   
              a.HOLD_REASON_CODE = null,
              a.HOLD_OUTPUT      = null
        where a.id = :new.ID;
     exception
       when others then
         null;
     end;
  
  end If;
end TG_JAQL472_UPD;
/

