CREATE OR REPLACE TRIGGER TG_JAQY776_INS_PPG001
  after insert on PPG001
  for each row

DECLARE

BEGIN
       insert into jaqy776 (PPG001COD,
                            PPG001MOD,
                            PPG001SUC,
                            PPG001MDA,
                            PPG001PAP,
                            PPG001CTA,
                            PPG001OPE,
                            PPG001SBO,
                            PPG001TOP,
                            PPG001COR,
                            PPG001FRM,
                            PPG001CDAT,
                            PPG001DATO,
                            PPG001AU1,
                            PPG001AU2,
                            PPG001AU3,
                            PPG001AU4,
                            PPG001AU5,
                            PPG001AU6,
                            PPG001AU7)

                   values (:new.ppg001cod,
                           :new.ppg001mod,
                           :new.ppg001suc,
                           :new.ppg001mda,
                           :new.ppg001pap,
                           :new.ppg001cta,
                           :new.ppg001ope,
                           :new.ppg001sbo,
                           :new.ppg001top,
                           :new.ppg001cor,
                           :new.ppg001frm,
                           :new.ppg001cdat,
                           :new.ppg001dato,
                           :new.ppg001au1,
                           :new.ppg001au2,
                           :new.ppg001au3,
                           :new.ppg001au4,
                           :new.ppg001au5,
                           :new.ppg001au6,
                           :new.ppg001au7);
                  -- commit;

END TG_JAQY776_INS_PPG001;
/

