CREATE OR REPLACE TRIGGER TG_DEPE301_AU_01
  after insert or update or delete
  on depe301 
  for each row
declare
  -- local variables here
	mensaje varchar2(500);
	titulo varchar2(100);
begin
   -- 
        IF DELETING THEN 
              pq_cr_fmv_correos.sp_mail_factor_bbp_pbp(:new.depe301tip,
                                                       --:new.depe301for,
                                                       :new.depe301fec,
                                                       :new.depe301hor
                                                       );
        end if;
        IF INSERTING  THEN 
              pq_cr_fmv_correos.sp_mail_factor_bbp_pbp(:new.depe301tip,
                                                       --:new.depe301for,
                                                       :new.depe301fec,
                                                       :new.depe301hor
                                                       );
        end if;  
        IF UPDATING  THEN
              pq_cr_fmv_correos.sp_mail_factor_bbp_pbp(:new.depe301tip,
                                                       --:new.depe301for,
                                                       :new.depe301fec,
                                                       :new.depe301hor
                                                       );
        End if;   

  Exception
      When others then
           null;
end TG_DEPE301_AU_01;
/

