create or replace procedure SP_CR_INSERT_JAQL406(
                                  P_JAQL406Pgc in JAQL406.JAQL406PGC%TYPE,
                                  P_JAQL406Mod in JAQL406.JAQL406MOD%TYPE,
                                  P_JAQL406Suc in JAQL406.JAQL406SUC%TYPE,
                                  P_JAQL406Mda in JAQL406.JAQL406MDA%TYPE,
                                  P_JAQL406Pap in JAQL406.JAQL406PAP%TYPE,
                                  P_JAQL406Cta in JAQL406.JAQL406CTA%TYPE,
                                  P_JAQL406Ope in JAQL406.JAQL406OPE%TYPE,
                                  P_JAQL406Sbo in JAQL406.JAQL406SBO%TYPE,
                                  P_JAQL406Top in JAQL406.JAQL406TOP%TYPE,
                                  P_JAQL406Cre in JAQL406.JAQL406CRE%TYPE,
                                  P_JAQL406Fec in JAQL406.JAQL406FEC%TYPE,
                                  P_JAQL406Fop in JAQL406.JAQL406FOP%TYPE,
                                  P_JAQL406Est in JAQL406.JAQL406EST%TYPE,
                                  P_JAQL406Usr in JAQL406.JAQL406USR%TYPE,
                                  P_JAQL406Age in JAQL406.JAQL406AGE%TYPE,
                                  P_JAQL406Dpt in JAQL406.JAQL406DPT%TYPE,
                                  P_JAQL406Ant in JAQL406.JAQL406ANT%TYPE,
                                  P_JAQL406Atr in JAQL406.JAQL406ATR%TYPE,
                                  P_JAQL406Cal in JAQL406.JAQL406CAL%TYPE,
                                  P_JAQL406Tip in JAQL406.JAQL406TIP%TYPE       
                         ) is
  begin
  
                       
  
      insert into jaql406
      (
          JAQL406Cup,
          JAQL406Pgc,
          JAQL406Mod,
          JAQL406Suc,
          JAQL406Mda,
          JAQL406Pap,
          JAQL406Cta,
          JAQL406Ope,
          JAQL406Sbo,
          JAQL406Top,
          JAQL406Cre,
          JAQL406Fec,
          JAQL406Fop,
          JAQL406Est,
          JAQL406Usr,
          JAQL406Age,
          JAQL406Dpt,
          JAQL406Ant,
          JAQL406Atr,
          JAQL406Cal,
          JAQL406Tip
      )
      values
      (
          SQ_AH_JAQL406.NEXTVAL,
          P_JAQL406Pgc,
          P_JAQL406Mod,
          P_JAQL406Suc,
          P_JAQL406Mda,
          P_JAQL406Pap,
          P_JAQL406Cta,
          P_JAQL406Ope,
          P_JAQL406Sbo,
          P_JAQL406Top,
          P_JAQL406Cre,
          P_JAQL406Fop,
          null,
          P_JAQL406Est,
          P_JAQL406Usr,
          P_JAQL406Age,
          P_JAQL406Dpt,
          P_JAQL406Ant,
          P_JAQL406Atr,
          P_JAQL406Cal,
          P_JAQL406Tip
      );

      commit;



  end;
/

