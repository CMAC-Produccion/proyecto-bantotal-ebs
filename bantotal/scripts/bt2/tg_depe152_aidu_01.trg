CREATE OR REPLACE TRIGGER TG_DEPE152_AIDU_01
  after insert or update or delete
  on depe152
  for each row
begin
  pq_cr_fmv_correos.sp_mail_factor_bms(:new.depe152fec,
                                       :new.depe152hor);

  exception
    when others then
      null;
end TG_DEPE152_AIDU_01;
/

