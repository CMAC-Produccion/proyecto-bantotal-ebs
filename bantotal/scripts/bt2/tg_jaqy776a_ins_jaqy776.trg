CREATE OR REPLACE TRIGGER TG_JAQY776a_INS_JAQY776
  after insert on JAQY776
  for each row

DECLARE

BEGIN
      begin

          If :new.PPG001CDAT = 23 then

             PQ_CR_BUSQUEDA_PLACA.sp_cr_limpiar_placas(:new.PPG001MOD,
                                                       :new.PPG001SUC,
                                                       :new.PPG001MDA,
                                                       :new.PPG001PAP,
                                                       :new.PPG001CTA,
                                                       :new.PPG001OPE,
                                                       :new.PPG001SBO,
                                                       :new.PPG001TOP,
                                                       :new.PPG001COR,
                                                       :new.PPG001FRM,
                                                       :new.PPG001CDAT );
          End If;

      exception
        when others then
          null;
      end;


exception
  when others then
    null;

END TG_JAQY776a_INS_JAQY776;
/

