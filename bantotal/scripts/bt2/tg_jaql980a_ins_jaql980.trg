CREATE OR REPLACE TRIGGER TG_JAQL980A_INS_JAQL980
  after insert on JAQL980A
  for each row

DECLARE



BEGIN



      begin
        pq_op_asientos_creditos.sp_op_fsd016(pn_cor => :new.JAQL980Acor,
                                             pn_pgcod => :new.JAQL980Acod,
                                             pn_hcmod => :new.JAQL980Amod,
                                             pn_hsucor => :new.JAQL980Asuc,
                                             pn_htran => :new.JAQL980Atran,
                                             pn_hnrel => :new.JAQL980Anrel,
                                             pd_fecpro => :new.JAQL980Afcon,
                                             pc_uing => :new.JAQL980Auing,
                                             pc_hora => :new.JAQL980Ahora,
                                             pc_cont => :new.JAQL980Acont,
                                             pn_corr => :new.JAQL980Acorr);

      exception
        when others then
          null;
      end;


exception
  when others then
    null;

END TG_JAQL980A_INS_JAQL980;
/

