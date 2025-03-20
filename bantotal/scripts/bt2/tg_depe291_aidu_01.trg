CREATE OR REPLACE TRIGGER TG_DEPE291_AIDU_01
  after insert or update or delete
  on depe291
  for each row
begin
  pq_cr_fmv_correos.sp_mail_factor_bfh(:new.depe291fec,
                                       :new.depe291hor);
  exception
    when others then
      null;
end TG_DEPE291_AIDU_01;
/

