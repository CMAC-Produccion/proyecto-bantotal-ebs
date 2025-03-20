create or replace package PQ_CR_REPRO_IND is

  -- Author  : CHERNANDEZ
  -- Created : 13/03/2019
  -- Purpose :
  -- MODIFCADO :

  -- Public type declarations
  Function fn_esParcial(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pc_ind in char) return char;
  Procedure sp_backup_ini(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pc_hor in varchar2,
                          pc_usu in varchar2);
  Procedure sp_cargaInicial(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pn_plazo  in number,
                            pd_fecpro in date,
                            pd_fecpen in date,
                            pn_grupo  out number);
  Procedure Sp_Actualiza_FSD601(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date);
  Procedure Sp_Actualiza_FSD611(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date);
  Procedure Sp_Actualiza_FSD010(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date);
  Procedure Sp_Actualiza_FSD011(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date);
  Procedure sp_insert_jaqz856_857(p_n_emp    in number,
                                  p_n_mod    in number,
                                  p_n_suc    in number,
                                  p_n_mda    in number,
                                  p_n_pap    in number,
                                  p_n_cta    in number,
                                  p_n_ope    in number,
                                  p_n_sbo    in number,
                                  p_n_top    in number,
                                  p_d_fecpro in date);
  Procedure Sp_extorno_cuenta(p_n_emp    in number,
                              p_n_mod    in number,
                              p_n_suc    in number,
                              p_n_mda    in number,
                              p_n_pap    in number,
                              p_n_cta    in number,
                              p_n_ope    in number,
                              p_n_sbo    in number,
                              p_n_top    in number,
                              p_n_gru    in number,
                              p_d_fecpro in date,
                              pc_usr     in char,
                              pd_fec     in date,
                              pn_ind     out number);
  Procedure Sp_verifica602(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fec    in date,
                           lc_cambia out char);
  Procedure Sp_backup_ext(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pn_gru in number,
                          pd_fec in date);

  Procedure Sp_Revierte602_612(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pn_gru in number,
                               pd_fep in date,
                               pc_usr in char,
                               pd_fec in date);
  procedure sp_enviocorreoRpta(p_instancia in number);
end PQ_CR_REPRO_IND;
/

create or replace package body PQ_CR_REPRO_IND is
  Function fn_esParcial(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pc_ind in char) return char is
    ld_maxpag date;
    lc_flg    char(1);
    lc_stat   char(1);
  begin
  
    if pc_ind = 'S' then
      begin
        select max(a.ppfpag)
          into ld_maxpag
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.d602co = 'S';
      exception
        when too_many_rows then
          begin
            select max(a.ppfpag)
              into ld_maxpag
              from fsd602 a
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
               and a.d602co = 'S'
               and rownum = 1;
          exception
            when others then
              null;
          end;
        when others then
          null;
      end;
    
      if ld_maxpag is not null then
        begin
          select 'T'
            into lc_stat
            from fsd602 a
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
             and a.ppfpag = ld_maxpag
             and a.pp1stat = 'T'
             and a.d602co = 'S';
        exception
          when others then
            null;
        end;
        if lc_stat = 'T' then
          lc_flg := 'S';
        else
          lc_flg := 'P';
        end if;
      else
        lc_flg := 'S';
      end if;
    
    else
      lc_flg := pc_ind;
    end if;
  
    return lc_flg;
  
  end Fn_esParcial;

  Procedure sp_backup_ini(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pc_hor in varchar2,
                          pc_usu in varchar2) is
    pc_usuChar Character(10);
  
  begin
  
    pc_usuChar := pc_usu;
  
    insert into AQPA004L
      (AQPA4LPGCOD,
       AQPA4LMOD,
       AQPA4LSUC,
       AQPA4LMDA,
       AQPA4LPAP,
       AQPA4LCTA,
       AQPA4LOPER,
       AQPA4LSBOP,
       AQPA4LTOPE,
       AQPA4LFEC,
       AQPA4LHOR,
       AQPA4LUSU,
       AQPA4LTIPO)
    VALUES
      (pn_emp,
       pn_mod,
       pn_suc,
       pn_mda,
       pn_pap,
       pn_cta,
       pn_ope,
       pn_sbo,
       pn_top,
       pd_fec,
       pc_hor,
       pc_usuChar,
       'FEN19');
  
    insert into AQPA004
      select a.*, pd_fec, pc_hor, 1 --chernandez 19/03/2020
        from jaqz520_010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
  
    insert into AQPA005
      select a.*, pd_fec, pc_hor, 1 --chernandez 19/03/2020
        from jaqz520_011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top;
  
    insert into AQPA006
      select a.*, pd_fec, pc_hor, 1 --chernandez 19/03/2020
        from jaqz520_601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into AQPA007
      select a.*, pd_fec, pc_hor, 1 --chernandez 19/03/2020
        from jaqz520_611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into AQPA008
      select a.*, pd_fec, pc_hor, 1 --chernandez 19/03/2020
        from jaqz520_602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into AQPA009
      select a.*, pd_fec, pc_hor, 1 --chernandez 19/03/2020
        from jaqz520_612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
    -------------
    delete from jaqz520_010 a
     where a.pgcod = pn_emp
       and a.aomod = pn_mod
       and a.aosuc = pn_suc
       and a.aomda = pn_mda
       and a.aopap = pn_pap
       and a.aocta = pn_cta
       and a.aooper = pn_ope
       and a.aosbop = pn_sbo
       and a.aotope = pn_top;
  
    delete from jaqz520_011 a
     where a.pgcod = pn_emp
       and a.scmod = pn_mod
       and a.scsuc = pn_suc
       and a.scmda = pn_mda
       and a.scpap = pn_pap
       and a.sccta = pn_cta
       and a.scoper = pn_ope
       and a.scsbop = pn_sbo
       and a.sctope = pn_top;
  
    delete from jaqz520_601 a
     where a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_611 a
     where a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_602 a
     where a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_612 a
     where a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    ----------------
  
    insert into jaqz520_010
      select *
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    insert into jaqz520_011
      select *
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top;
  
    insert into jaqz520_601
      select *
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_611
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_602
      select *
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_612
      select *
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into aqpa004c
      (aqpa4cpgcod,
       aqpa4caomod,
       aqpa4caosuc,
       aqpa4caomda,
       aqpa4caopap,
       aqpa4caocta,
       aqpa4caooper,
       aqpa4caosbop,
       aqpa4caotope,
       aqpa4csgcod,
       aqpa4cfpro,
       aqpa4cvc,
       aqpa4cimp,
       aqpa4cporc,
       aqpa4cplus,
       aqpa4cpart,
       aqpa4cveh,
       aqpa4cinm,
       aqpa4cend,
       aqpa4cstat,
       aqpa4cco,
       aqpa4caux1,
       aqpa4caux2,
       aqpa4caux3,
       aqpa4caux4,
       aqpa4caux5,
       aqpa4caux6,
       aqpa4caux7,
       aqpa4chpro)
      select pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope,
             sgcod,
             pd_fec,
             pp001vc,
             pp001imp,
             pp001porc,
             pp001plus,
             pp001part,
             pp001veh,
             pp001inm,
             pp001end,
             pp001stat,
             pp001co,
             pp001aux1,
             pp001aux2,
             pp001aux3,
             pp001aux4,
             pp001aux5,
             pp001aux6,
             pp001aux7,
             pc_hor
        from fpp001
       where pgcod = pn_emp
         and aomod = pn_mod
         and aosuc = pn_suc
         and aomda = pn_mda
         and aopap = pn_pap
         and aocta = pn_cta
         and aooper = pn_ope
         and aosbop = pn_sbo
         and aotope = pn_top;
  
    insert into aqpa004d
      (aqpa4dpgcod,
       aqpa4dmod,
       aqpa4dsuc,
       aqpa4dmda,
       aqpa4dpap,
       aqpa4dcta,
       aqpa4doper,
       aqpa4dsbop,
       aqpa4dtope,
       aqpa4dfpag,
       aqpa4dtipo,
       aqpa4dnump,
       aqpa4dprcnc,
       aqpa4dfepro,
       aqpa4dimp,
       aqpa4dstat,
       aqpa4daux1,
       aqpa4daux2,
       aqpa4daux3,
       aqpa4dhopro)
      select pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             ppsbop,
             pptope,
             ppfpag,
             pptipo,
             pp003nump,
             prestconc,
             pd_fec,
             pp003imp,
             pp003stat,
             pp003aux1,
             pp003aux2,
             pp003aux3,
             pc_hor
        from fpp003
       where pgcod = pn_emp
         and ppmod = pn_mod
         and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = pn_sbo
         and pptope = pn_top;
  
    insert into aqpa010f
      (aqpa010fhpgcod,
       aqpa010fhmodul,
       aqpa010fhtoper,
       aqpa010fhsucur,
       aqpa010fhmda,
       aqpa010fhpap,
       aqpa010fhcta,
       aqpa010fhoper,
       aqpa010fhsubop,
       aqpa010fmcapitd,
       aqpa010fmsegud,
       aqpa010fmotrod,
       aqpa010fmpenad,
       aqpa010fminmod,
       aqpa010fmicvd,
       aqpa010fmincod,
       aqpa010fhrubroc,
       aqpa010fmseguc,
       aqpa010fmotroc,
       aqpa010fmpenac,
       aqpa010fminmoc,
       aqpa010fmicvc,
       aqpa010fmincoc,
       aqpa010fmcapitc,
       aqpa010fmsumac,
       aqpa010fstatc,
       aqpa010ftipcre,
       aqpa010fdiaatr,
       aqpa010ffecint,
       aqpa010fnroexp,
       aqpa010facupag,
       aqpa010fdacupag,
       aqpa010fcanesp,
       aqpa010ffecext,
       aqpa010fest,
       aqpa010fmgasc,
       aqpa010fmgasd,
       aqpa010fcorr,
       aqpa010fhopro)
      select aqpa010hpgcod,
             aqpa010hmodul,
             aqpa010htoper,
             aqpa010hsucur,
             aqpa010hmda,
             aqpa010hpap,
             aqpa010hcta,
             aqpa010hoper,
             aqpa010hsubop,
             aqpa010mcapitd,
             aqpa010msegud,
             aqpa010motrod,
             aqpa010mpenad,
             aqpa010minmod,
             aqpa010micvd,
             aqpa010mincod,
             aqpa010hrubroc,
             aqpa010mseguc,
             aqpa010motroc,
             aqpa010mpenac,
             aqpa010minmoc,
             aqpa010micvc,
             aqpa010mincoc,
             aqpa010mcapitc,
             aqpa010msumac,
             aqpa010statc,
             aqpa010tipcre,
             aqpa010diaatr,
             aqpa010fecint,
             aqpa010nroexp,
             aqpa010acupag,
             aqpa010dacupag,
             aqpa010canesp,
             aqpa010fecext,
             aqpa010est,
             aqpa010mgasc,
             aqpa010mgasd,
             (select count(*) + 1
                from AQPA010f
               where aqpa010fhpgcod = pn_emp
                 and aqpa010fhmodul = pn_mod
                 and aqpa010fhsucur = pn_suc
                 and aqpa010fhmda = pn_mda
                 and aqpa010fhpap = pn_pap
                 and aqpa010fhcta = pn_cta
                 and aqpa010fhoper = pn_ope
                 and aqpa010fhsubop = pn_sbo
                 and aqpa010fhtoper = pn_top),
             pc_hor
        from AQPA010
       where aqpa010hpgcod = pn_emp
         and aqpa010hmodul = pn_mod
         and aqpa010hsucur = pn_suc
         and aqpa010hmda = pn_mda
         and aqpa010hpap = pn_pap
         and aqpa010hcta = pn_cta
         and aqpa010hoper = pn_ope
         and aqpa010hsubop = pn_sbo
         and aqpa010htoper = pn_top;
  
    insert into aqpa010g
      (aqpa010gpgcod,
       aqpa010gppmod,
       aqpa010gppsuc,
       aqpa010gppmda,
       aqpa010gpppap,
       aqpa010gppcta,
       aqpa010gppoper,
       aqpa010gppsbop,
       aqpa010gpptope,
       aqpa010gcuota,
       aqpa010gfecuo,
       aqpa010gcapitd,
       aqpa010ginterd,
       aqpa010gsegurd,
       aqpa010gicvd,
       aqpa010gintmord,
       aqpa010gpend,
       aqpa010gmontod,
       aqpa010gcapit,
       aqpa010ginter,
       aqpa010gsegur,
       aqpa010gicv,
       aqpa010gintmor,
       aqpa010gpen,
       aqpa010gmonto,
       aqpa010gdiatr,
       aqpa010gcuot,
       aqpa010gfeult,
       aqpa010gfvto,
       aqpa010gest,
       aqpa010ggast,
       aqpa010gotro,
       aqpa010ggasd,
       aqpa010gotrd,
       aqpa010gcorr,
       aqpa010ghopro)
      select aqpa010apgcod,
             aqpa010appmod,
             aqpa010appsuc,
             aqpa010appmda,
             aqpa010apppap,
             aqpa010appcta,
             aqpa010appoper,
             aqpa010appsbop,
             aqpa010apptope,
             aqpa010acuota,
             aqpa010afecuo,
             aqpa010acapitd,
             aqpa010ainterd,
             aqpa010asegurd,
             aqpa010aicvd,
             aqpa010aintmord,
             aqpa010apend,
             aqpa010amontod,
             aqpa010acapit,
             aqpa010ainter,
             aqpa010asegur,
             aqpa010aicv,
             aqpa010aintmor,
             aqpa010apen,
             aqpa010amonto,
             aqpa010adiatr,
             aqpa010acuot,
             aqpa010afeult,
             aqpa010afvto,
             aqpa010aest,
             aqpa010agast,
             aqpa010aotro,
             aqpa010agasd,
             aqpa010aotrd,
             (select count(*)
                from AQPA010g
               where aqpa010gpgcod = pn_emp
                 and aqpa010gppmod = pn_mod
                 and aqpa010gppsuc = pn_suc
                 and aqpa010gppmda = pn_mda
                 and aqpa010gpppap = pn_pap
                 and aqpa010gppcta = pn_cta
                 and aqpa010gppoper = pn_ope
                 and aqpa010gppsbop = pn_sbo
                 and aqpa010gpptope = pn_top),
             pc_hor
        from AQPA010A
       where aqpa010apgcod = pn_emp
         and aqpa010appmod = pn_mod
         and aqpa010appsuc = pn_suc
         and aqpa010appmda = pn_mda
         and aqpa010apppap = pn_pap
         and aqpa010appcta = pn_cta
         and aqpa010appoper = pn_ope
         and aqpa010appsbop = pn_sbo
         and aqpa010apptope = pn_top;
  
    delete from AQPA010
     where aqpa010hpgcod = pn_emp
       and aqpa010hmodul = pn_mod
       and aqpa010hsucur = pn_suc
       and aqpa010hmda = pn_mda
       and aqpa010hpap = pn_pap
       and aqpa010hcta = pn_cta
       and aqpa010hoper = pn_ope
       and aqpa010hsubop = pn_sbo
       and aqpa010htoper = pn_top;
  
    delete from AQPA010A
     where aqpa010apgcod = pn_emp
       and aqpa010appmod = pn_mod
       and aqpa010appsuc = pn_suc
       and aqpa010appmda = pn_mda
       and aqpa010apppap = pn_pap
       and aqpa010appcta = pn_cta
       and aqpa010appoper = pn_ope
       and aqpa010appsbop = pn_sbo
       and aqpa010apptope = pn_top;
    commit;
  
  end Sp_backup_ini;

  Procedure sp_cargaInicial(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pn_plazo  in number,
                            pd_fecpro in date,
                            pd_fecpen in date,
                            pn_grupo  out number) is
    lc_ind   char(1);
    ln_anio  number(5);
    v_existe number(5);
  begin
  
    ln_anio := extract(year from pd_fecpro);
  
    begin
      select tp1nro1
        into pn_grupo
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 16
         and tp1corr2 = 2
         and tp1corr3 = ln_anio;
    exception
      when others then
      
        select max(a.jaqz519grp) + 1 into pn_grupo from jaqz519 a;
        insert into fst198
        values
          (1,
           11105,
           16,
           2,
           ln_anio,
           pn_grupo,
           0,
           0,
           'Cod Grupo ' || to_char(ln_anio),
           0.00,
           0.00,
           0.00);
    end;
    begin
      select 1
        into v_existe
        from jaqz519 a
       where a.jaqz519emp = pn_emp
         and a.jaqz519mod = pn_mod
         and a.jaqz519suc = pn_suc
         and a.jaqz519mda = pn_mda
         and a.jaqz519pap = pn_pap
         and a.jaqz519cta = pn_cta
         and a.jaqz519ope = pn_ope
         and a.jaqz519sbo = pn_sbo
         and a.jaqz519top = pn_top
         and a.jaqz519grp = pn_grupo
         and a.jaqz519fep = pd_fecpro;
    exception
      when others then
        v_existe := 0;
    End;
    If v_existe = 1 then
      pn_grupo := pn_grupo + 1;
    End if;
  
    begin
      insert into jaqz519
        (jaqz519emp,
         jaqz519mod,
         jaqz519suc,
         jaqz519mda,
         jaqz519pap,
         jaqz519cta,
         jaqz519ope,
         jaqz519sbo,
         jaqz519top,
         jaqz519pzo,
         jaqz519est,
         jaqz519ind,
         jaqz519grp,
         jaqz519rub,
         jaqz519sdo,
         jaqz519pdi,
         jaqz519fep,
         jaqz519fpp)
      
        select distinct a.pgcod jaqz519emp,
                        aomod jaqz519mod,
                        aosuc jaqz519suc,
                        aomda jaqz519mda,
                        aopap jaqz519pap,
                        aocta jaqz519cta,
                        aooper jaqz519ope,
                        aosbop jaqz519sbo,
                        aotope jaqz519top,
                        pn_plazo,
                        aostat jaqz519est,
                        case
                          when aostat = 99 then
                           'C'
                          when aomod in (117, 116) then
                           'M'
                          else
                           'S'
                        end jaqz519ind,
                        pn_grupo,
                        c.scrub jaqz519rub,
                        c.scsdo jaqz519sdo,
                        pn_plazo / 30 jaqz519pdi,
                        pd_fecpro,
                        pd_fecpen
        
          from fsd010 a, fsd011 c
         where a.pgcod = c.pgcod
           and a.aomod = c.scmod
           and a.aosuc = c.scsuc
           and a.aomda = c.scmda
           and a.aopap = c.scpap
           and a.aocta = c.sccta
           and a.aooper = c.scoper
           and a.aosbop = c.scsbop
           and a.aotope = c.sctope
           and a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
    
      commit;
      select case
               when aostat = 99 then
                'C'
               when aomod in (117, 116) then
                'M'
               else
                'S'
             end
        into lc_ind
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    exception
      when others then
        null;
    end;
  
    lc_ind := PQ_CR_REPRO_IND.Fn_esParcial(pn_emp,
                                           pn_mod,
                                           pn_suc,
                                           pn_mda,
                                           pn_pap,
                                           pn_cta,
                                           pn_ope,
                                           pn_sbo,
                                           pn_top,
                                           lc_ind);
    update jaqz519 a
       set a.jaqz519ind = lc_ind
     where a.jaqz519emp = pn_emp
       and a.jaqz519mod = pn_mod
       and a.jaqz519suc = pn_suc
       and a.jaqz519mda = pn_mda
       and a.jaqz519pap = pn_pap
       and a.jaqz519cta = pn_cta
       and a.jaqz519ope = pn_ope
       and a.jaqz519sbo = pn_sbo
       and a.jaqz519top = pn_top
       and a.jaqz519grp = pn_grupo
       and a.jaqz519fep = pd_fecpro;
  
    commit;
  
  end sp_cargaInicial;

  Procedure Sp_Actualiza_FSD601(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date) is
    cursor creditos is
      select b.jaqz519emp pgcod,
             b.jaqz519mod aomod,
             b.jaqz519suc aosuc,
             b.jaqz519mda aomda,
             b.jaqz519pap aopap,
             b.jaqz519cta aocta,
             b.jaqz519ope aooper,
             b.jaqz519sbo aosbop,
             b.jaqz519top aotope,
             b.jaqz519pdi
        from jaqz519 b
       where b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519ind = 'S'
         and b.jaqz519grp = p_n_grupo
         and b.jaqz519fep = p_d_fecpro;
  
    ld_fecpxv date;
  
    cursor calendario(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pd_fec in date) is
      select *
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0
         and a.ppfpag >= pd_fec
       order by ppfpag desc;
  
    cursor calendario_asc(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date) is
      select *
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0
         and a.ppfpag >= pd_fec
       order by ppfpag asc;
  
    type c_list is varray(999) of fsd601.ppfpag%type;
    name_list c_list := c_list();
    counter   number := 0;
    ln_cont   number;
    ln_int    number;
  
    ld_ppfpag     date;
    ld_ppfval     date;
    ld_ppfvto     date;
    lc_hab_ppfpag char(1);
    lc_hab_ppfval char(1);
    lc_hab_ppfvto char(1);
    ld_ppfpag_F   date;
    ld_ppfval_F   date;
    ld_ppfvto_F   date;
    ld_ppfpag_ini date;
  
    ln_countTot number;
    ln_contAF   number;
  
    --PPFVAL
    type c_list_FV is varray(999) of fsd601.ppfval%type;
    name_list_FV c_list_FV := c_list_FV();
    counter_FV   number := 0;
    ln_contFV    number;
    ln_intFV     number;
    --PPFVAL
  
    --mod@abr 20170403
    ln_numpdi number;
    --mod@abr 20170403
  
  BEGIN
  
    for i in creditos loop
      ld_fecpxv     := null;
      ld_ppfpag_ini := null;
    
      begin
        select /*+ parallel(n,2,1)*/
         min(n.ppfpag)
          into ld_ppfpag_ini
          from fsd601 n
         where n.pgcod = i.pgcod
           and n.ppcta = i.aocta
           and n.ppmda = i.aomda
           and n.ppsuc = i.aosuc
           and n.pppap = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod = i.aomod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0;
      
      exception
        when others then
          null;
      end;
    
      begin
        select /*+ parallel(n,2,1)*/
         min(n.ppfpag)
          into ld_fecpxv
          from fsd601 n
         where n.pgcod = i.pgcod
           and n.ppcta = i.aocta
           and n.ppmda = i.aomda
           and n.ppsuc = i.aosuc
           and n.pppap = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod = i.aomod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0
           and not exists (select /*+ parallel(o,2,1)*/
                 ppmod, ppcta, ppoper, pptope, ppfpag
                  from fsd602 o
                 where o.pgcod = n.pgcod
                   and o.ppmod = n.ppmod
                   and o.ppsuc = n.ppsuc
                   and o.ppmda = n.ppmda
                   and o.pppap = n.pppap
                   and o.ppcta = n.ppcta
                   and o.ppoper = n.ppoper
                   and o.ppsbop = n.ppsbop
                   and o.pptope = n.pptope
                   and o.ppfpag = n.ppfpag
                   and o.pp1stat = 'T'
                   and o.d602co = 'S'
                   and (o.pp1cap + o.pp1int) <> 0);
      exception
        when others then
          null;
      end;
    
      counter     := 0;
      ln_countTot := 0;
      name_list   := c_list();
      for j in calendario_asc(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope,
                              ld_fecpxv) loop
      
        counter := counter + 1;
        name_list.extend;
        name_list(counter) := j.ppfpag;
      
      end loop;
      ln_countTot := counter;
      ln_cont     := 0;
      ln_contAF   := 0;
    
      --mod@abr 20170403
      ln_numpdi := i.jaqz519pdi;
    
      for k in calendario(i.pgcod,
                          i.aomod,
                          i.aosuc,
                          i.aomda,
                          i.aopap,
                          i.aocta,
                          i.aooper,
                          i.aosbop,
                          i.aotope,
                          ld_fecpxv) loop
        ln_cont := ln_cont + 1;
      
        --if ln_cont < ln_numpdi + 1 then
      
        ld_ppfpag := add_months(k.ppfpag, ln_numpdi); --MOD@ABR 20170403
        ld_ppfval := add_months(k.ppfval, ln_numpdi); --MOD@ABR 20170403
        ld_ppfvto := add_months(k.ppfvto, ln_numpdi); --MOD@ABR 20170403
      
        --verificar si es dia habil
        begin
          select a.fhabil
            into lc_hab_ppfpag
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_ppfpag
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_ppfpag = 'N' then
          begin
            select min(a.ffecha)
              into ld_ppfpag_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_ppfpag
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_ppfpag_F := ld_ppfpag;
        
        end if;
      
        begin
          select a.fhabil
            into lc_hab_ppfval
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_ppfval
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_ppfval = 'N' then
          begin
            select min(a.ffecha)
              into ld_ppfval_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_ppfval
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_ppfval_F := ld_ppfval;
        end if;
      
        begin
          select a.fhabil
            into lc_hab_ppfvto
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_ppfvto
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_ppfpag = 'N' then
          begin
            select min(a.ffecha)
              into ld_ppfvto_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_ppfvto
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_ppfvto_F := ld_ppfvto;
        end if;
        --dbms_output.put_line('0-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag); 
        begin
          --chernandez
          --if ld_ppfpag_ini <> k.ppfpag then
          if ln_countTot <> ln_cont then
          
            update fsd601 a
               set a.ppfpag = ld_ppfpag_F,
                   a.ppfval = ld_ppfval_F,
                   a.ppfvto = ld_ppfvto_F,
                   a.pptipo = 'F'
             where a.pgcod = k.pgcod
               and a.ppmod = k.ppmod
               and a.ppsuc = k.ppsuc
               and a.ppmda = k.ppmda
               and a.pppap = k.pppap
               and a.ppcta = k.ppcta
               and a.ppoper = k.ppoper
               and a.ppsbop = k.ppsbop
               and a.pptope = k.pptope
               and a.ppfpag = k.ppfpag;
          else
            update fsd601 a
               set a.ppfpag = ld_ppfpag_F,
                   a.ppfvto = ld_ppfvto_F,
                   a.pptipo = 'F'
             where a.pgcod = k.pgcod
               and a.ppmod = k.ppmod
               and a.ppsuc = k.ppsuc
               and a.ppmda = k.ppmda
               and a.pppap = k.pppap
               and a.ppcta = k.ppcta
               and a.ppoper = k.ppoper
               and a.ppsbop = k.ppsbop
               and a.pptope = k.pptope
               and a.ppfpag = k.ppfpag;
          end if;
        end;
      
      /*else
                                      
                                        ln_contAF := ln_contAF + 1;
                                        ln_int    := counter;
                                      
                                        while ln_int = counter loop
                                          ld_ppfpag_F := name_list(ln_int);
                                          ln_int      := ln_int - 1;
                                        
                                          begin
                                            update fsd601 a
                                               set a.ppfpag = ld_ppfpag_F,
                                                   a.ppfvto = ld_ppfpag_F,
                                                   a.pptipo = 'F'
                                             where a.pgcod = k.pgcod
                                               and a.ppmod = k.ppmod
                                               and a.ppsuc = k.ppsuc
                                               and a.ppmda = k.ppmda
                                               and a.pppap = k.pppap
                                               and a.ppcta = k.ppcta
                                               and a.ppoper = k.ppoper
                                               and a.ppsbop = k.ppsbop
                                               and a.pptope = k.pptope
                                               and a.ppfpag = k.ppfpag;
                                             end;
                                        end loop;
                                        counter := counter - 1;
                                      
                                        If (ln_countTot - ln_contAF) = ln_numpdi then
                                          exit;
                                        end if;
                                      
                                      end if;*/
      
      end loop;
    
      --PPFVAL
      /*
      counter_FV   := 0;
      name_list_FV := c_list_FV();
      for j in calendario_asc(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope,
                              ld_fecpxv) loop
      
        counter_FV := counter_FV + 1;
        name_list_FV.extend;
        name_list_FV(counter_FV) := j.ppfpag;
      
      end loop;
      
      ln_contFV := 0;
      
      ln_intFV := 1;
      For g in calendario_asc(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope,
                              ld_fecpxv) loop
        ln_contFV := ln_contFV + 1;
      
        if ln_contFV >= 1 then
          counter_FV := ln_intFV;
          while ln_intFV = counter_FV loop
            ld_ppfval_F := name_list_FV(ln_intFV);
            counter_FV := counter_FV - 1;
            begin
              if ld_ppfpag_ini <> g.ppfval then
                update fsd601 a
                   set a.ppfval = ld_ppfval_F
                 where a.pgcod = g.pgcod
                   and a.ppmod = g.ppmod
                   and a.ppsuc = g.ppsuc
                   and a.ppmda = g.ppmda
                   and a.pppap = g.pppap
                   and a.ppcta = g.ppcta
                   and a.ppoper = g.ppoper
                   and a.ppsbop = g.ppsbop
                   and a.pptope = g.pptope
                   and a.ppfpag = g.ppfpag;
              end if;
            end;
          
          end loop;
          ln_intFV := ln_intFV + 1;
        end if;
      end loop;*/
      --PPFVAL
      update jaqz519 A
         set a.JAQZ519PRO601 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.aomod
         and a.jaqz519suc = i.aosuc
         and a.jaqz519mda = i.aomda
         and a.jaqz519pap = i.aopap
         and a.jaqz519cta = i.aocta
         and a.jaqz519ope = i.aooper
         and a.jaqz519sbo = i.aosbop
         and a.jaqz519top = i.aotope
         and a.jaqz519grp = p_n_grupo
         and a.jaqz519fep = p_d_fecpro;
    
    END LOOP;
    commit;
  END Sp_Actualiza_FSD601;

  Procedure Sp_Actualiza_FSD611(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date) is
    cursor creditos is
    
      select b.jaqz519emp pgcod,
             b.jaqz519mod aomod,
             b.jaqz519suc aosuc,
             b.jaqz519mda aomda,
             b.jaqz519pap aopap,
             b.jaqz519cta aocta,
             b.jaqz519ope aooper,
             b.jaqz519sbo aosbop,
             b.jaqz519top aotope,
             b.jaqz519pdi
        from jaqz519 b
       where b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519ind = 'S'
         and b.jaqz519grp = p_n_grupo
         and b.jaqz519fep = p_d_fecpro;
  
    ld_fecpxv date;
  
    cursor calendario(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pd_fec in date) is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag >= pd_fec
       order by ppfpag desc;
  
    cursor calendario_asc(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date) is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag >= pd_fec
       order by ppfpag asc;
  
    type c_list is varray(999) of fsd601.ppfpag%type;
    name_list c_list := c_list();
    counter   number := 0;
    ln_cont   number;
    ln_int    number;
  
    ld_ppfpag date;
  
    lc_hab_ppfpag char(1);
  
    ld_ppfpag_F date;
  
    ln_countTot number;
    ln_contAF   number;
  
    --mod@abr 20170403
    ld_fecha  date;
    ln_numpdi number;
    --mod@abr 20170403
  
  BEGIN
  
    for i in creditos loop
      ld_fecpxv := null;
    
      begin
        select /*+ parallel(n,2,1)*/
         min(n.ppfpag)
          into ld_fecpxv
          from fsd611 n
         where n.pgcod = i.pgcod
           and n.ppcta = i.aocta
           and n.ppmda = i.aomda
           and n.ppsuc = i.aosuc
           and n.pppap = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod = i.aomod
              --and n.d601co = 'S'
              --and (n.ppcap+n.ppint)<>0
           and not exists (select /*+ parallel(o,2,1)*/
                 ppmod, ppcta, ppoper, pptope, ppfpag
                  from fsd602 o
                 where o.pgcod = n.pgcod
                   and o.ppmod = n.ppmod
                   and o.ppsuc = n.ppsuc
                   and o.ppmda = n.ppmda
                   and o.pppap = n.pppap
                   and o.ppcta = n.ppcta
                   and o.ppoper = n.ppoper
                   and o.ppsbop = n.ppsbop
                   and o.pptope = n.pptope
                   and o.ppfpag = n.ppfpag
                   and o.pp1stat = 'T'
                   and o.d602co = 'S'
                   and (o.pp1cap + o.pp1int) <> 0);
      exception
        when others then
          null;
      end;
      --dbms_output.put_line('ld_fecpxv-'||ld_fecpxv ); 
      counter     := 0;
      ln_countTot := 0;
      name_list   := c_list();
      for j in calendario_asc(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope,
                              ld_fecpxv) loop
      
        counter := counter + 1;
        name_list.extend;
        name_list(counter) := j.ppfpag;
        --dbms_output.put_line('Customer('||counter ||'):'||name_list(counter)); 
      
      end loop;
      ln_countTot := counter;
      ln_cont     := 0;
      ln_contAF   := 0;
    
      --mod@abr 20170403    
    
      ln_numpdi := i.jaqz519pdi;
      --mod@abr 20170403
    
      for k in calendario(i.pgcod,
                          i.aomod,
                          i.aosuc,
                          i.aomda,
                          i.aopap,
                          i.aocta,
                          i.aooper,
                          i.aosbop,
                          i.aotope,
                          ld_fecpxv) loop
        ln_cont := ln_cont + 1;
      
        --if ln_cont < ln_numpdi + 1 then
        --mod@abr 20170403
      
        ld_ppfpag := add_months(k.ppfpag, ln_numpdi); --mod@abr 20170403
      
        --verificar si es dia habil
        begin
          select a.fhabil
            into lc_hab_ppfpag
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_ppfpag
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_ppfpag = 'N' then
          begin
            select min(a.ffecha)
              into ld_ppfpag_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_ppfpag
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_ppfpag_F := ld_ppfpag;
        
        end if;
      
        begin
          update fsd611 a
             set a.ppfpag = ld_ppfpag_F, a.pptipo = 'F'
           where a.pgcod = k.pgcod
             and a.ppmod = k.ppmod
             and a.ppsuc = k.ppsuc
             and a.ppmda = k.ppmda
             and a.pppap = k.pppap
             and a.ppcta = k.ppcta
             and a.ppoper = k.ppoper
             and a.ppsbop = k.ppsbop
             and a.pptope = k.pptope
             and a.ppfpag = k.ppfpag;
        
        end;
      
      /*else
                                      
                                        ln_contAF := ln_contAF + 1;
                                        ln_int    := counter;
                                      
                                        while ln_int = counter loop
                                          ld_ppfpag_F := name_list(ln_int);
                                          ln_int      := ln_int - 1;
                                        
                                          begin
                                            update fsd611 a
                                               set a.ppfpag = ld_ppfpag_F, a.pptipo = 'F'
                                             where a.pgcod = k.pgcod
                                               and a.ppmod = k.ppmod
                                               and a.ppsuc = k.ppsuc
                                               and a.ppmda = k.ppmda
                                               and a.pppap = k.pppap
                                               and a.ppcta = k.ppcta
                                               and a.ppoper = k.ppoper
                                               and a.ppsbop = k.ppsbop
                                               and a.pptope = k.pptope
                                               and a.ppfpag = k.ppfpag;
                                          
                                          end;
                                        end loop;
                                        counter := counter - 1;
                                      
                                        If (ln_countTot - ln_contAF) = ln_numpdi then
                                          exit;
                                        end if;
                                      
                                      end if;*/
      
      end loop;
    
      update jaqz519 A
         set a.JAQZ519PRO611 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.aomod
         and a.jaqz519suc = i.aosuc
         and a.jaqz519mda = i.aomda
         and a.jaqz519pap = i.aopap
         and a.jaqz519cta = i.aocta
         and a.jaqz519ope = i.aooper
         and a.jaqz519sbo = i.aosbop
         and a.jaqz519top = i.aotope
         and a.jaqz519grp = p_n_grupo
         and a.jaqz519fep = p_d_fecpro;
    
    END LOOP;
    commit;
  END Sp_Actualiza_FSD611;

  Procedure Sp_Actualiza_FSD010(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date) is
    cursor creditos is
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope,
             b.jaqz519pzo,
             a.aofval
        from fsd010 a, jaqz519 b
       where a.pgcod = b.jaqz519emp
         and a.aomod = b.jaqz519mod
         and a.aosuc = b.jaqz519suc
         and a.aomda = b.jaqz519mda
         and a.aopap = b.jaqz519pap
         and a.aocta = b.jaqz519cta
         and a.aooper = b.jaqz519ope
         and a.aosbop = b.jaqz519sbo
         and a.aotope = b.jaqz519top
         and b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519ind = 'S'
         and b.jaqz519grp = p_n_grupo
         and b.jaqz519fep = p_d_fecpro;
  
    ld_fecvto date;
  begin
  
    for i in creditos loop
    
      begin
        select max(ppfpag)
          into ld_fecvto
          from fsd601 a
         where a.pgcod = i.pgcod
           and a.ppmod = i.aomod
           and a.ppsuc = i.aosuc
           and a.ppmda = i.aomda
           and a.pppap = i.aopap
           and a.ppcta = i.aocta
           and a.ppoper = i.aooper
           and a.ppsbop = i.aosbop
           and a.pptope = i.aotope
           and d601co = 'S';
      exception
        when others then
          null;
      end;
    
      update fsd010
         set aofvto = ld_fecvto, aopzo = ld_fecvto - i.aofval --mod@abr20170405
       where pgcod = i.pgcod
         and aomod = i.aomod
         and aosuc = i.aosuc
         and aomda = i.aomda
         and aopap = i.aopap
         and aocta = i.aocta
         and aooper = i.aooper
         and aosbop = i.aosbop
         and aotope = i.aotope;
      commit;
    
      update jaqz519 A
         set a.JAQZ519PRO10 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.aomod
         and a.jaqz519suc = i.aosuc
         and a.jaqz519mda = i.aomda
         and a.jaqz519pap = i.aopap
         and a.jaqz519cta = i.aocta
         and a.jaqz519ope = i.aooper
         and a.jaqz519sbo = i.aosbop
         and a.jaqz519top = i.aotope
         and a.jaqz519grp = p_n_grupo
         and a.jaqz519fep = p_d_fecpro;
    
    --COMMIT;
    
    end loop;
    commit;
  end Sp_Actualiza_FSD010;

  Procedure Sp_Actualiza_FSD011(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date) is
    cursor creditos is
      select a.pgcod,
             a.scsuc,
             a.scmda,
             a.scpap,
             a.sccta,
             a.scoper,
             a.scsbop,
             a.sctope,
             a.scmod,
             b.jaqz519pzo,
             a.scfval --mod@abr 20170405
        from fsd011 a, jaqz519 b
       where a.pgcod = b.jaqz519emp
         and a.scsuc = b.jaqz519suc
         and a.scmda = b.jaqz519mda
         and a.scpap = b.jaqz519pap
         and a.sccta = b.jaqz519cta
         and a.scoper = b.jaqz519ope
         and a.scsbop = b.jaqz519sbo
         and a.sctope = b.jaqz519top
         and a.scmod = b.jaqz519mod
         and a.scfvto is not null
         and b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519ind = 'S'
         and b.jaqz519grp = p_n_grupo
         and b.jaqz519fep = p_d_fecpro;
    ld_fecvto date;
  
  begin
    for i in creditos loop
    
      begin
        select max(ppfpag)
          into ld_fecvto
          from fsd601 a
         where a.pgcod = i.pgcod
           and a.ppmod = i.scmod
           and a.ppsuc = i.scsuc
           and a.ppmda = i.scmda
           and a.pppap = i.scpap
           and a.ppcta = i.sccta
           and a.ppoper = i.scoper
           and a.ppsbop = i.scsbop
           and a.pptope = i.sctope
           and d601co = 'S';
      exception
        when others then
          null;
      end;
    
      update fsd011
         set scfvto = ld_fecvto, scpzo = ld_fecvto - i.scfval --mod@abr 20170405
       where pgcod = i.pgcod
         and scsuc = i.scsuc
         and scmda = i.scmda
         and scpap = i.scpap
         and sccta = i.sccta
         and scoper = i.scoper
         and scsbop = i.scsbop
         and sctope = i.sctope
         and scmod = i.scmod;
    
      --commit;  
    
      update jaqz519 A
         set a.JAQZ519PRO11 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.scmod
         and a.jaqz519suc = i.scsuc
         and a.jaqz519mda = i.scmda
         and a.jaqz519pap = i.scpap
         and a.jaqz519cta = i.sccta
         and a.jaqz519ope = i.scoper
         and a.jaqz519sbo = i.scsbop
         and a.jaqz519top = i.sctope
         and a.jaqz519grp = p_n_grupo
         and a.jaqz519fep = p_d_fecpro;
    
    --COMMIT;
    
    end loop;
    commit;
  end Sp_Actualiza_FSD011;

  Procedure sp_insert_jaqz856_857(p_n_emp    in number,
                                  p_n_mod    in number,
                                  p_n_suc    in number,
                                  p_n_mda    in number,
                                  p_n_pap    in number,
                                  p_n_cta    in number,
                                  p_n_ope    in number,
                                  p_n_sbo    in number,
                                  p_n_top    in number,
                                  p_d_fecpro in date) is
  
  Begin
    Begin
      if p_n_mod = 107 then
      
        insert into AQPA004P
          (aqpa004pemp,
           aqpa004pmod,
           aqpa004psuc,
           aqpa004pmda,
           aqpa004ppap,
           aqpa004pcta,
           aqpa004pope,
           aqpa004psbo,
           aqpa004ptop,
           aqpa004ppzo,
           aqpa004pest,
           aqpa004pind,
           aqpa004pgrp,
           aqpa004prub,
           aqpa004psdo,
           aqpa004ppdi,
           aqpa004pfep,
           aqpa004pmodt,
           aqpa004psuct,
           aqpa004ptrat,
           aqpa004prelt,
           aqpa004pcont,
           aqpa004pfect,
           aqpa004psdo11,
           aqpa004prev,
           aqpa004pcor)
          select jaqz867emp,
                 jaqz867mod,
                 jaqz867suc,
                 jaqz867mda,
                 jaqz867pap,
                 jaqz867cta,
                 jaqz867ope,
                 jaqz867sbo,
                 jaqz867top,
                 jaqz867pzo,
                 jaqz867est,
                 jaqz867ind,
                 jaqz867grp,
                 jaqz867rub,
                 jaqz867sdo,
                 jaqz867pdi,
                 jaqz867fep,
                 jaqz867modt,
                 jaqz867suct,
                 jaqz867trat,
                 jaqz867relt,
                 jaqz867cont,
                 jaqz867fect,
                 jaqz867sdo11,
                 jaqz867rev,
                 (select count(*) + 1
                    from aqpa004P
                   where aqpa004Pemp = p_n_emp
                     and aqpa004Pmod = p_n_mod
                     and aqpa004Psuc = p_n_suc
                     and aqpa004Pmda = p_n_mda
                     and aqpa004Ppap = p_n_pap
                     and aqpa004Pcta = p_n_cta
                     and aqpa004Pope = p_n_ope
                     and aqpa004Psbo = p_n_sbo
                     and aqpa004Ptop = p_n_top)
            from jaqz867
           where jaqz867emp = p_n_emp
             and jaqz867mod = p_n_mod
             and jaqz867suc = p_n_suc
             and jaqz867mda = p_n_mda
             and jaqz867pap = p_n_pap
             and jaqz867cta = p_n_cta
             and jaqz867ope = p_n_ope
             and jaqz867sbo = p_n_sbo
             and jaqz867top = p_n_top;
      
        delete from jaqz867
         where jaqz867emp = p_n_emp
           and jaqz867mod = p_n_mod
           and jaqz867suc = p_n_suc
           and jaqz867mda = p_n_mda
           and jaqz867pap = p_n_pap
           and jaqz867cta = p_n_cta
           and jaqz867ope = p_n_ope
           and jaqz867sbo = p_n_sbo
           and jaqz867top = p_n_top;
      
        insert into jaqz867
          (jaqz867emp,
           jaqz867mod,
           jaqz867suc,
           jaqz867mda,
           jaqz867pap,
           jaqz867cta,
           jaqz867ope,
           jaqz867sbo,
           jaqz867top,
           jaqz867pzo,
           jaqz867est,
           jaqz867ind,
           jaqz867grp,
           jaqz867rub,
           jaqz867sdo,
           jaqz867fep)
        
          select j.jaqz519emp,
                 j.jaqz519mod,
                 j.jaqz519suc,
                 j.jaqz519mda,
                 j.jaqz519pap,
                 j.jaqz519cta,
                 j.jaqz519ope,
                 j.jaqz519sbo,
                 j.jaqz519top,
                 j.jaqz519pzo,
                 j.jaqz519est,
                 j.jaqz519ind,
                 j.jaqz519grp,
                 j.jaqz519rub,
                 j.jaqz519sdo,
                 j.jaqz519fep
          
            from JAQZ519 j
           where j.jaqz519pro10 = 'S'
             and j.jaqz519pro11 = 'S'
             and j.jaqz519pro601 = 'S'
             and j.jaqz519pro611 = 'S'
             and j.jaqz519emp = p_n_emp
             and j.jaqz519mod = p_n_mod
             and j.jaqz519suc = p_n_suc
             and j.jaqz519mda = p_n_mda
             and j.jaqz519pap = p_n_pap
             and j.jaqz519cta = p_n_cta
             and j.jaqz519ope = p_n_ope
             and j.jaqz519sbo = p_n_sbo
             and j.jaqz519top = p_n_top
             and j.jaqz519fep = p_d_fecpro;
      
      else
        insert into AQPA004A
          (aqpa4aemp,
           aqpa4amod,
           aqpa4asuc,
           aqpa4amda,
           aqpa4apap,
           aqpa4acta,
           aqpa4aope,
           aqpa4asbo,
           aqpa4atop,
           aqpa4apzo,
           aqpa4aest,
           aqpa4aind,
           aqpa4agrp,
           aqpa4arub,
           aqpa4asdo,
           aqpa4apdi,
           aqpa4afep,
           aqpa4amodt,
           aqpa4asuct,
           aqpa4atrat,
           aqpa4arelt,
           aqpa4acont,
           aqpa4afect,
           aqpa4arev,
           aqpa4acor)
          select jaqz856emp,
                 jaqz856mod,
                 jaqz856suc,
                 jaqz856mda,
                 jaqz856pap,
                 jaqz856cta,
                 jaqz856ope,
                 jaqz856sbo,
                 jaqz856top,
                 jaqz856pzo,
                 jaqz856est,
                 jaqz856ind,
                 jaqz856grp,
                 jaqz856rub,
                 jaqz856sdo,
                 jaqz856pdi,
                 jaqz856fep,
                 jaqz856modt,
                 jaqz856suct,
                 jaqz856trat,
                 jaqz856relt,
                 jaqz856cont,
                 jaqz856fect,
                 jaqz856rev,
                 (select count(*) + 1
                    from aqpa004a
                   where aqpa4aemp = p_n_emp
                     and aqpa4amod = p_n_mod
                     and aqpa4asuc = p_n_suc
                     and aqpa4amda = p_n_mda
                     and aqpa4apap = p_n_pap
                     and aqpa4acta = p_n_cta
                     and aqpa4aope = p_n_ope
                     and aqpa4asbo = p_n_sbo
                     and aqpa4atop = p_n_top)
            from jaqz856
           where jaqz856emp = p_n_emp
             and jaqz856mod = p_n_mod
             and jaqz856suc = p_n_suc
             and jaqz856mda = p_n_mda
             and jaqz856pap = p_n_pap
             and jaqz856cta = p_n_cta
             and jaqz856ope = p_n_ope
             and jaqz856sbo = p_n_sbo
             and jaqz856top = p_n_top;
        delete from jaqz856
         where jaqz856emp = p_n_emp
           and jaqz856mod = p_n_mod
           and jaqz856suc = p_n_suc
           and jaqz856mda = p_n_mda
           and jaqz856pap = p_n_pap
           and jaqz856cta = p_n_cta
           and jaqz856ope = p_n_ope
           and jaqz856sbo = p_n_sbo
           and jaqz856top = p_n_top;
      
        insert into jaqz856
          (jaqz856emp,
           jaqz856mod,
           jaqz856suc,
           jaqz856mda,
           jaqz856pap,
           jaqz856cta,
           jaqz856ope,
           jaqz856sbo,
           jaqz856top,
           jaqz856pzo,
           jaqz856est,
           jaqz856ind,
           jaqz856grp,
           jaqz856rub,
           jaqz856sdo,
           jaqz856fep)
        
          select j.jaqz519emp,
                 j.jaqz519mod,
                 j.jaqz519suc,
                 j.jaqz519mda,
                 j.jaqz519pap,
                 j.jaqz519cta,
                 j.jaqz519ope,
                 j.jaqz519sbo,
                 j.jaqz519top,
                 j.jaqz519pzo,
                 j.jaqz519est,
                 j.jaqz519ind,
                 j.jaqz519grp,
                 j.jaqz519rub,
                 j.jaqz519sdo,
                 j.jaqz519fep
          
            from JAQZ519 j
           where j.jaqz519pro10 = 'S'
             and j.jaqz519pro11 = 'S'
             and j.jaqz519pro601 = 'S'
             and j.jaqz519pro611 = 'S'
             and j.jaqz519emp = p_n_emp
             and j.jaqz519mod = p_n_mod
             and j.jaqz519suc = p_n_suc
             and j.jaqz519mda = p_n_mda
             and j.jaqz519pap = p_n_pap
             and j.jaqz519cta = p_n_cta
             and j.jaqz519ope = p_n_ope
             and j.jaqz519sbo = p_n_sbo
             and j.jaqz519top = p_n_top
             and j.jaqz519fep = p_d_fecpro;
      
        -- insercion JAQZ857 --
        insert into aqpa004b
          (aqpa4bemp,
           aqpa4bmod,
           aqpa4bsuc,
           aqpa4bmda,
           aqpa4bpap,
           aqpa4bcta,
           aqpa4bope,
           aqpa4bsbo,
           aqpa4btop,
           aqpa4bpzo,
           aqpa4best,
           aqpa4bind,
           aqpa4bgrp,
           aqpa4brub,
           aqpa4bsdo,
           aqpa4bpdi,
           aqpa4bfep,
           aqpa4bmodt,
           aqpa4bsuct,
           aqpa4btrat,
           aqpa4brelt,
           aqpa4bcont,
           aqpa4bfect,
           aqpa4bsdo11,
           aqpa4brev,
           aqpa4bcor)
        
          select jaqz857emp,
                 jaqz857mod,
                 jaqz857suc,
                 jaqz857mda,
                 jaqz857pap,
                 jaqz857cta,
                 jaqz857ope,
                 jaqz857sbo,
                 jaqz857top,
                 jaqz857pzo,
                 jaqz857est,
                 jaqz857ind,
                 jaqz857grp,
                 jaqz857rub,
                 jaqz857sdo,
                 jaqz857pdi,
                 jaqz857fep,
                 jaqz857modt,
                 jaqz857suct,
                 jaqz857trat,
                 jaqz857relt,
                 jaqz857cont,
                 jaqz857fect,
                 jaqz857sdo11,
                 jaqz857rev,
                 (select count(*) + 1
                    from aqpa004b
                   where aqpa4bemp = p_n_emp
                     and aqpa4bmod = p_n_mod
                     and aqpa4bsuc = p_n_suc
                     and aqpa4bmda = p_n_mda
                     and aqpa4bpap = p_n_pap
                     and aqpa4bcta = p_n_cta
                     and aqpa4bope = p_n_ope
                     and aqpa4bsbo = p_n_sbo
                     and aqpa4btop = p_n_top)
            from jaqz857
           where jaqz857emp = p_n_emp
             and jaqz857mod = p_n_mod
             and jaqz857suc = p_n_suc
             and jaqz857mda = p_n_mda
             and jaqz857pap = p_n_pap
             and jaqz857cta = p_n_cta
             and jaqz857ope = p_n_ope
             and jaqz857sbo = p_n_sbo
             and jaqz857top = p_n_top;
      
        delete from jaqz857
         where jaqz857emp = p_n_emp
           and jaqz857mod = p_n_mod
           and jaqz857suc = p_n_suc
           and jaqz857mda = p_n_mda
           and jaqz857pap = p_n_pap
           and jaqz857cta = p_n_cta
           and jaqz857ope = p_n_ope
           and jaqz857sbo = p_n_sbo
           and jaqz857top = p_n_top;
      
        insert into jaqz857
          (jaqz857emp,
           jaqz857mod,
           jaqz857suc,
           jaqz857mda,
           jaqz857pap,
           jaqz857cta,
           jaqz857ope,
           jaqz857sbo,
           jaqz857top,
           jaqz857pzo,
           jaqz857est,
           jaqz857ind,
           jaqz857grp,
           jaqz857rub,
           jaqz857sdo,
           jaqz857fep)
          select j.jaqz519emp,
                 j.jaqz519mod,
                 j.jaqz519suc,
                 j.jaqz519mda,
                 j.jaqz519pap,
                 j.jaqz519cta,
                 j.jaqz519ope,
                 j.jaqz519sbo,
                 j.jaqz519top,
                 j.jaqz519pzo,
                 j.jaqz519est,
                 j.jaqz519ind,
                 j.jaqz519grp,
                 j.jaqz519rub,
                 j.jaqz519sdo,
                 j.jaqz519fep
          
            from JAQZ519 j
           where j.jaqz519pro10 = 'S'
             and j.jaqz519pro11 = 'S'
             and j.jaqz519pro601 = 'S'
             and j.jaqz519pro611 = 'S'
             and j.jaqz519emp = p_n_emp
             and j.jaqz519mod = p_n_mod
             and j.jaqz519suc = p_n_suc
             and j.jaqz519mda = p_n_mda
             and j.jaqz519pap = p_n_pap
             and j.jaqz519cta = p_n_cta
             and j.jaqz519ope = p_n_ope
             and j.jaqz519sbo = p_n_sbo
             and j.jaqz519top = p_n_top
             and j.jaqz519fep = p_d_fecpro;
      end if;
    exception
      when others then
        null;
    End;
    commit;
  end sp_insert_jaqz856_857;

  Procedure Sp_extorno_cuenta(p_n_emp    in number,
                              p_n_mod    in number,
                              p_n_suc    in number,
                              p_n_mda    in number,
                              p_n_pap    in number,
                              p_n_cta    in number,
                              p_n_ope    in number,
                              p_n_sbo    in number,
                              p_n_top    in number,
                              p_n_gru    in number,
                              p_d_fecpro in date, --fecha reprogramación
                              pc_usr     in char,
                              pd_fec     in date, --fecha actual sistema
                              pn_ind     out number) is
  
    cursor creditos is
      select *
        from jaqz519 b
       where b.jaqz519ind in ('S', 'P')
         and b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519grp = p_n_gru
         and b.jaqz519fep = p_d_fecpro
         and b.jaqz519pro10 = 'S'
         and b.jaqz519pro11 = 'S'
         and b.jaqz519pro601 = 'S'
         and b.jaqz519pro611 = 'S'
         and b.jaqz519revr is null;
  
    cursor calendario_1(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number) is
      select *
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d601co = 'S'
       order by ppfpag;
  
    cursor calendario_2(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number) is
      select *
        from jaqz520_601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d601co = 'S'
       order by ppfpag;
  
    cursor jaqz522(pn_emp in number,
                   pn_mod in number,
                   pn_suc in number,
                   pn_mda in number,
                   pn_pap in number,
                   pn_cta in number,
                   pn_ope in number,
                   pn_sbo in number,
                   pn_top in number) is
    
      select *
        from jaqz522 a
       where a.jaqz522emp = pn_emp
         and a.jaqz522mod = pn_mod
         and a.jaqz522suc = pn_suc
         and a.jaqz522mda = pn_mda
         and a.jaqz522pap = pn_pap
         and a.jaqz522cta = pn_cta
         and a.jaqz522ope = pn_ope
         and a.jaqz522sbo = pn_sbo
         and a.jaqz522top = pn_top;
  
    ld_fvto11    date;
    ln_pzo11     number(5);
    ld_fvto10    date;
    ln_pzo10     number(5);
    ln_contador1 number(10);
    ln_contador2 number(10);
    ln_con1      number(10);
    ln_con2      number(10);
    ld_fecAnt    date;
    lc_Spago     char(1);
    contPagos    number(5);
    contSeguros  number(5);
    pc_maxhora   char(8);
  
  begin
    pn_ind := 0;
    begin
      select 0 -- 0 si no se ha revertido aun, 1 si ya se revirtio o no existe
        into pn_ind
        from jaqz519 b
       where b.jaqz519ind in ('S', 'P')
         and b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519grp = p_n_gru
         and b.jaqz519fep = p_d_fecpro
         and b.jaqz519pro10 = 'S'
         and b.jaqz519pro11 = 'S'
         and b.jaqz519pro601 = 'S'
         and b.jaqz519pro611 = 'S'
         and b.jaqz519revr is null;
    exception
      when others then
        pn_ind := 1;
    end;
  
    If pn_ind = 0 then
    
      for i in creditos loop
      
        --valido que no tenga pagos vigentes luego de la reprogramación
        select count(*)
          into contPagos
          from fsd602 a
         where a.pgcod = p_n_emp
           and a.ppmod = p_n_mod
           and a.ppsuc = p_n_suc
           and a.ppmda = p_n_mda
           and a.pppap = p_n_pap
           and a.ppcta = p_n_cta
           and a.ppoper = p_n_ope
           and a.ppsbop = p_n_sbo
           and a.pptope = p_n_top
           and a.d602co = 'S'
           and a.ppfpag >= p_d_fecpro
           and a.pptipo = 'F'
         order by ppfpag;
      
        if contPagos > 0 then
          pn_ind := 2;
        else
          --valido si agregó o desafilió seguros
          pc_maxhora := '';
          begin
            select max(aqpa4chpro)
              into pc_maxhora
              from aqpa004c p
             where AQPA4CPGCOD = p_n_emp
               and AQPA4CAOMOD = p_n_mod
               and AQPA4CAOSUC = p_n_suc
               and AQPA4CAOMDA = p_n_mda
               and AQPA4CAOPAP = p_n_pap
               and AQPA4CAOCTA = p_n_cta
               and AQPA4CAOOPER = p_n_ope
               and AQPA4CAOSBOP = p_n_sbo
               and AQPA4CAOTOPE = p_n_top
               and AQPA4CFPRO = p_d_fecpro;
          Exception
            when others then
              null;
          end;
        
          select count(*)
            into contSeguros
            from fpp001 o
            full join aqpa004c p
              on AQPA4CPGCOD = PGCOD
             and AQPA4CAOMOD = AOMOD
             and AQPA4CAOSUC = AOSUC
             and AQPA4CAOMDA = AOMDA
             and AQPA4CAOPAP = AOPAP
             and AQPA4CAOCTA = AOCTA
             and AQPA4CAOOPER = AOOPER
             and AQPA4CAOSBOP = AOSBOP
             and AQPA4CAOTOPE = AOTOPE
             and AQPA4CSGCOD = SGCOD
             and AQPA4CFPRO = p_d_fecpro
             and AQPA4CHPRO = pc_maxhora
           where pgcod = p_n_emp
             and AOMOD = p_n_mod
             and AOSUC = p_n_suc
             and AOMDA = p_n_mda
             and AOPAP = p_n_pap
             and aocta = p_n_cta
             and aooper = p_n_ope
             and aosbop = p_n_sbo
             and aotope = p_n_top
             and (aocta is null or aqpa4caocta is null); --graba afilian seguros
          if contSeguros > 0 then
            pn_ind := 3;
          else
            delete from jaqz522 a
             where a.jaqz522emp = p_n_emp
               and a.jaqz522mod = p_n_mod
               and a.jaqz522suc = p_n_suc
               and a.jaqz522mda = p_n_mda
               and a.jaqz522pap = p_n_pap
               and a.jaqz522cta = p_n_cta
               and a.jaqz522ope = p_n_ope
               and a.jaqz522sbo = p_n_sbo
               and a.jaqz522top = p_n_top;
          
            delete from jaqz522_aux a
             where a.jaqz522emp = p_n_emp
               and a.jaqz522mod = p_n_mod
               and a.jaqz522suc = p_n_suc
               and a.jaqz522mda = p_n_mda
               and a.jaqz522pap = p_n_pap
               and a.jaqz522cta = p_n_cta
               and a.jaqz522ope = p_n_ope
               and a.jaqz522sbo = p_n_sbo
               and a.jaqz522top = p_n_top;
          
            pq_cr_repro_ind.Sp_verifica602(i.jaqz519emp,
                                           i.jaqz519mod,
                                           i.jaqz519suc,
                                           i.jaqz519mda,
                                           i.jaqz519pap,
                                           i.jaqz519cta,
                                           i.jaqz519ope,
                                           i.jaqz519sbo,
                                           i.jaqz519top,
                                           i.jaqz519fpp,
                                           lc_Spago);
          
            pq_cr_repro_ind.Sp_backup_ext(i.jaqz519emp,
                                          i.jaqz519mod,
                                          i.jaqz519suc,
                                          i.jaqz519mda,
                                          i.jaqz519pap,
                                          i.jaqz519cta,
                                          i.jaqz519ope,
                                          i.jaqz519sbo,
                                          i.jaqz519top,
                                          i.jaqz519grp,
                                          i.jaqz519fep);
          
            if lc_Spago = 'S' then
            
              begin
                select count(*)
                  into ln_con1
                  from fsd601 a
                 where a.pgcod = i.jaqz519emp
                   and a.ppmod = i.jaqz519mod
                   and a.ppsuc = i.jaqz519suc
                   and a.ppmda = i.jaqz519mda
                   and a.pppap = i.jaqz519pap
                   and a.ppcta = i.jaqz519cta
                   and a.ppoper = i.jaqz519ope
                   and a.ppsbop = i.jaqz519sbo
                   and a.pptope = i.jaqz519top
                   and a.d601co = 'S';
              exception
                when others then
                  null;
              end;
            
              begin
                select count(*)
                  into ln_con2
                  from jaqz520_601 a
                 where a.pgcod = i.jaqz519emp
                   and a.ppmod = i.jaqz519mod
                   and a.ppsuc = i.jaqz519suc
                   and a.ppmda = i.jaqz519mda
                   and a.pppap = i.jaqz519pap
                   and a.ppcta = i.jaqz519cta
                   and a.ppoper = i.jaqz519ope
                   and a.ppsbop = i.jaqz519sbo
                   and a.pptope = i.jaqz519top
                   and a.d601co = 'S';
              exception
                when others then
                  null;
              end;
            
              ln_contador1 := 0;
              ln_contador2 := 0;
              ld_fecAnt    := null;
            
              if ln_con1 = ln_con2 then
              
                for j in calendario_1(i.jaqz519emp,
                                      i.jaqz519mod,
                                      i.jaqz519suc,
                                      i.jaqz519mda,
                                      i.jaqz519pap,
                                      i.jaqz519cta,
                                      i.jaqz519ope,
                                      i.jaqz519sbo,
                                      i.jaqz519top) loop
                
                  ln_contador1 := ln_contador1 + 1;
                  insert into jaqz522
                    (jaqz522cod,
                     jaqz522emp,
                     jaqz522mod,
                     jaqz522suc,
                     jaqz522mda,
                     jaqz522pap,
                     jaqz522cta,
                     jaqz522ope,
                     jaqz522sbo,
                     jaqz522top,
                     jaqz522fac,
                     jaqz522usr,
                     jaqz522fep)
                  values
                    (ln_contador1,
                     i.jaqz519emp,
                     i.jaqz519mod,
                     i.jaqz519suc,
                     i.jaqz519mda,
                     i.jaqz519pap,
                     i.jaqz519cta,
                     i.jaqz519ope,
                     i.jaqz519sbo,
                     i.jaqz519top,
                     j.ppfpag,
                     pc_usr,
                     pd_fec);
                
                  commit;
                end loop;
              
                for k in calendario_2(i.jaqz519emp,
                                      i.jaqz519mod,
                                      i.jaqz519suc,
                                      i.jaqz519mda,
                                      i.jaqz519pap,
                                      i.jaqz519cta,
                                      i.jaqz519ope,
                                      i.jaqz519sbo,
                                      i.jaqz519top) loop
                
                  ln_contador2 := ln_contador2 + 1;
                  insert into jaqz522_aux
                    (jaqz522cod,
                     jaqz522emp,
                     jaqz522mod,
                     jaqz522suc,
                     jaqz522mda,
                     jaqz522pap,
                     jaqz522cta,
                     jaqz522ope,
                     jaqz522sbo,
                     jaqz522top,
                     jaqz522fan)
                  values
                    (ln_contador2,
                     i.jaqz519emp,
                     i.jaqz519mod,
                     i.jaqz519suc,
                     i.jaqz519mda,
                     i.jaqz519pap,
                     i.jaqz519cta,
                     i.jaqz519ope,
                     i.jaqz519sbo,
                     i.jaqz519top,
                     k.ppfpag);
                
                  commit;
                end loop;
              
                commit;
              
                for m in jaqz522(i.jaqz519emp,
                                 i.jaqz519mod,
                                 i.jaqz519suc,
                                 i.jaqz519mda,
                                 i.jaqz519pap,
                                 i.jaqz519cta,
                                 i.jaqz519ope,
                                 i.jaqz519sbo,
                                 i.jaqz519top) loop
                  begin
                    select a.jaqz522fan
                      into ld_fecAnt
                      from jaqz522_aux a
                     where a.jaqz522cod = m.jaqz522cod
                       and a.jaqz522emp = m.jaqz522emp
                       and a.jaqz522mod = m.jaqz522mod
                       and a.jaqz522suc = m.jaqz522suc
                       and a.jaqz522mda = m.jaqz522mda
                       and a.jaqz522pap = m.jaqz522pap
                       and a.jaqz522cta = m.jaqz522cta
                       and a.jaqz522ope = m.jaqz522ope
                       and a.jaqz522sbo = m.jaqz522sbo
                       and a.jaqz522top = m.jaqz522top;
                  exception
                    when others then
                      null;
                  end;
                
                  update jaqz522 a
                     set a.jaqz522fan = ld_fecAnt
                   where a.jaqz522cod = m.jaqz522cod
                     and a.jaqz522emp = m.jaqz522emp
                     and a.jaqz522mod = m.jaqz522mod
                     and a.jaqz522suc = m.jaqz522suc
                     and a.jaqz522mda = m.jaqz522mda
                     and a.jaqz522pap = m.jaqz522pap
                     and a.jaqz522cta = m.jaqz522cta
                     and a.jaqz522ope = m.jaqz522ope
                     and a.jaqz522sbo = m.jaqz522sbo
                     and a.jaqz522top = m.jaqz522top;
                
                  commit;
                end loop;
                commit;
              
                pq_cr_repro_ind.Sp_Revierte602_612(i.jaqz519emp,
                                                   i.jaqz519mod,
                                                   i.jaqz519suc,
                                                   i.jaqz519mda,
                                                   i.jaqz519pap,
                                                   i.jaqz519cta,
                                                   i.jaqz519ope,
                                                   i.jaqz519sbo,
                                                   i.jaqz519top,
                                                   i.jaqz519grp,
                                                   i.jaqz519fep,
                                                   pc_usr,
                                                   pd_fec);
                --Actualiza si ya pago
                update jaqz519 a
                   set a.jaqz519spag = 'S'
                 where a.jaqz519emp = i.jaqz519emp
                   and a.jaqz519mod = i.jaqz519mod
                   and a.jaqz519suc = i.jaqz519suc
                   and a.jaqz519mda = i.jaqz519mda
                   and a.jaqz519pap = i.jaqz519pap
                   and a.jaqz519cta = i.jaqz519cta
                   and a.jaqz519ope = i.jaqz519ope
                   and a.jaqz519sbo = i.jaqz519sbo
                   and a.jaqz519top = i.jaqz519top
                   and a.jaqz519grp = i.jaqz519grp
                   and a.jaqz519fep = i.jaqz519fep;
                commit;
              
              end if;
            
            end if;
          
            delete from fsd601 a
             where a.pgcod = i.jaqz519emp
               and a.ppmod = i.jaqz519mod
               and a.ppsuc = i.jaqz519suc
               and a.ppmda = i.jaqz519mda
               and a.pppap = i.jaqz519pap
               and a.ppcta = i.jaqz519cta
               and a.ppoper = i.jaqz519ope
               and a.ppsbop = i.jaqz519sbo
               and a.pptope = i.jaqz519top;
          
            insert into fsd601 a
              select *
                from jaqz520_601 a
               where a.pgcod = i.jaqz519emp
                 and a.ppmod = i.jaqz519mod
                 and a.ppsuc = i.jaqz519suc
                 and a.ppmda = i.jaqz519mda
                 and a.pppap = i.jaqz519pap
                 and a.ppcta = i.jaqz519cta
                 and a.ppoper = i.jaqz519ope
                 and a.ppsbop = i.jaqz519sbo
                 and a.pptope = i.jaqz519top;
            --Actualiza si se revertio FSD601
            UPDATE jaqz519 a
               set a.jaqz519r601 = 'S'
             where a.jaqz519emp = i.jaqz519emp
               and a.jaqz519mod = i.jaqz519mod
               and a.jaqz519suc = i.jaqz519suc
               and a.jaqz519mda = i.jaqz519mda
               and a.jaqz519pap = i.jaqz519pap
               and a.jaqz519cta = i.jaqz519cta
               and a.jaqz519ope = i.jaqz519ope
               and a.jaqz519sbo = i.jaqz519sbo
               and a.jaqz519top = i.jaqz519top
               and a.jaqz519grp = i.jaqz519grp
               and a.jaqz519fep = i.jaqz519fep;
          
            delete from fsd611 a
             where a.pgcod = i.jaqz519emp
               and a.ppmod = i.jaqz519mod
               and a.ppsuc = i.jaqz519suc
               and a.ppmda = i.jaqz519mda
               and a.pppap = i.jaqz519pap
               and a.ppcta = i.jaqz519cta
               and a.ppoper = i.jaqz519ope
               and a.ppsbop = i.jaqz519sbo
               and a.pptope = i.jaqz519top;
          
            insert into fsd611 a
              select *
                from jaqz520_611 a
               where a.pgcod = i.jaqz519emp
                 and a.ppmod = i.jaqz519mod
                 and a.ppsuc = i.jaqz519suc
                 and a.ppmda = i.jaqz519mda
                 and a.pppap = i.jaqz519pap
                 and a.ppcta = i.jaqz519cta
                 and a.ppoper = i.jaqz519ope
                 and a.ppsbop = i.jaqz519sbo
                 and a.pptope = i.jaqz519top;
          
            --Actualiza si se revertio FSD611
            UPDATE jaqz519 a
               set a.jaqz519r611 = 'S'
             where a.jaqz519emp = i.jaqz519emp
               and a.jaqz519mod = i.jaqz519mod
               and a.jaqz519suc = i.jaqz519suc
               and a.jaqz519mda = i.jaqz519mda
               and a.jaqz519pap = i.jaqz519pap
               and a.jaqz519cta = i.jaqz519cta
               and a.jaqz519ope = i.jaqz519ope
               and a.jaqz519sbo = i.jaqz519sbo
               and a.jaqz519top = i.jaqz519top
               and a.jaqz519grp = i.jaqz519grp
               and a.jaqz519fep = i.jaqz519fep;
          
            select aofvto, aopzo
              into ld_fvto10, ln_pzo10
              from jaqz520_010 a
             where a.pgcod = i.jaqz519emp
               and a.aomod = i.jaqz519mod
               and a.aosuc = i.jaqz519suc
               and a.aomda = i.jaqz519mda
               and a.aopap = i.jaqz519pap
               and a.aocta = i.jaqz519cta
               and a.aooper = i.jaqz519ope
               and a.aosbop = i.jaqz519sbo
               and a.aotope = i.jaqz519top;
          
            update fsd010 a
               set a.aofvto = ld_fvto10, a.aopzo = ln_pzo10
             where a.pgcod = i.jaqz519emp
               and a.aomod = i.jaqz519mod
               and a.aosuc = i.jaqz519suc
               and a.aomda = i.jaqz519mda
               and a.aopap = i.jaqz519pap
               and a.aocta = i.jaqz519cta
               and a.aooper = i.jaqz519ope
               and a.aosbop = i.jaqz519sbo
               and a.aotope = i.jaqz519top;
          
            --Actualiza si se revertio FSD010
            UPDATE jaqz519 a
               set a.jaqz519r010 = 'S'
             where a.jaqz519emp = i.jaqz519emp
               and a.jaqz519mod = i.jaqz519mod
               and a.jaqz519suc = i.jaqz519suc
               and a.jaqz519mda = i.jaqz519mda
               and a.jaqz519pap = i.jaqz519pap
               and a.jaqz519cta = i.jaqz519cta
               and a.jaqz519ope = i.jaqz519ope
               and a.jaqz519sbo = i.jaqz519sbo
               and a.jaqz519top = i.jaqz519top
               and a.jaqz519grp = i.jaqz519grp
               and a.jaqz519fep = i.jaqz519fep;
          
            select a.scfvto, a.scpzo
              into ld_fvto11, ln_pzo11
              from jaqz520_011 a
             where a.pgcod = i.jaqz519emp
               and a.scmod = i.jaqz519mod
               and a.scsuc = i.jaqz519suc
               and a.scmda = i.jaqz519mda
               and a.scpap = i.jaqz519pap
               and a.sccta = i.jaqz519cta
               and a.scoper = i.jaqz519ope
               and a.scsbop = i.jaqz519sbo
               and a.sctope = i.jaqz519top;
          
            update fsd011 a
               set a.scfvto = ld_fvto11, a.scpzo = ln_pzo11
             where a.pgcod = i.jaqz519emp
               and a.scmod = i.jaqz519mod
               and a.scsuc = i.jaqz519suc
               and a.scmda = i.jaqz519mda
               and a.scpap = i.jaqz519pap
               and a.sccta = i.jaqz519cta
               and a.scoper = i.jaqz519ope
               and a.scsbop = i.jaqz519sbo
               and a.sctope = i.jaqz519top;
          
            --Actualiza si se revertio FSD011
            UPDATE jaqz519 a
               set a.jaqz519r011 = 'S'
             where a.jaqz519emp = i.jaqz519emp
               and a.jaqz519mod = i.jaqz519mod
               and a.jaqz519suc = i.jaqz519suc
               and a.jaqz519mda = i.jaqz519mda
               and a.jaqz519pap = i.jaqz519pap
               and a.jaqz519cta = i.jaqz519cta
               and a.jaqz519ope = i.jaqz519ope
               and a.jaqz519sbo = i.jaqz519sbo
               and a.jaqz519top = i.jaqz519top
               and a.jaqz519grp = i.jaqz519grp
               and a.jaqz519fep = i.jaqz519fep;
          
            --Actualiza estado, fecha y usario que hizo la reversion
            update jaqz519 a
               set a.jaqz519revr = 'S',
                   a.jaqz519feca = pd_fec,
                   a.jaqz519usrr = pc_usr
             where a.jaqz519emp = i.jaqz519emp
               and a.jaqz519mod = i.jaqz519mod
               and a.jaqz519suc = i.jaqz519suc
               and a.jaqz519mda = i.jaqz519mda
               and a.jaqz519pap = i.jaqz519pap
               and a.jaqz519cta = i.jaqz519cta
               and a.jaqz519ope = i.jaqz519ope
               and a.jaqz519sbo = i.jaqz519sbo
               and a.jaqz519top = i.jaqz519top
               and a.jaqz519grp = i.jaqz519grp
               and a.jaqz519fep = i.jaqz519fep;
          
            update jaqz856 a
               set a.jaqz856rev = 'S'
             where a.jaqz856emp = i.jaqz519emp
               and a.jaqz856mod = i.jaqz519mod
               and a.jaqz856suc = i.jaqz519suc
               and a.jaqz856mda = i.jaqz519mda
               and a.jaqz856pap = i.jaqz519pap
               and a.jaqz856cta = i.jaqz519cta
               and a.jaqz856ope = i.jaqz519ope
               and a.jaqz856sbo = i.jaqz519sbo
               and a.jaqz856top = i.jaqz519top;
          
            update jaqz857 a
               set a.jaqz857rev = 'S'
             where a.jaqz857emp = i.jaqz519emp
               and a.jaqz857mod = i.jaqz519mod
               and a.jaqz857suc = i.jaqz519suc
               and a.jaqz857mda = i.jaqz519mda
               and a.jaqz857pap = i.jaqz519pap
               and a.jaqz857cta = i.jaqz519cta
               and a.jaqz857ope = i.jaqz519ope
               and a.jaqz857sbo = i.jaqz519sbo
               and a.jaqz857top = i.jaqz519top;
          
            update AQPA010 a
               set a.AQPA010EST = 'E', aqpa010fecext = pd_fec
             where a.AQPA010hpgcod = i.jaqz519emp
               and a.AQPA010hmodul = i.jaqz519mod
               and a.AQPA010hsucur = i.jaqz519suc
               and a.AQPA010hmda = i.jaqz519mda
               and a.AQPA010hpap = i.jaqz519pap
               and a.AQPA010hcta = i.jaqz519cta
               and a.AQPA010hoper = i.jaqz519ope
               and a.aqpa010hsubop = i.jaqz519sbo
               and a.AQPA010htoper = i.jaqz519top;
          
            update AQPA010A a
               set a.AQPA010AEST = 'E'
             where a.AQPA010APGCOD = i.jaqz519emp
               and a.AQPA010APPMOD = i.jaqz519mod
               and a.AQPA010APPSUC = i.jaqz519suc
               and a.AQPA010APPMDA = i.jaqz519mda
               and a.AQPA010APPPAP = i.jaqz519pap
               and a.AQPA010APPCTA = i.jaqz519cta
               and a.AQPA010APPOPER = i.jaqz519ope
               and a.AQPA010APPSBOP = i.jaqz519sbo
               and a.AQPA010APPTOPE = i.jaqz519top;
          
            commit;
          end if;
        end If;
      end loop;
      commit;
    End if;
  end Sp_extorno_cuenta;

  Procedure Sp_verifica602(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fec    in date,
                           lc_cambia out char) is
  
  begin
    lc_cambia := 'N';
    begin
      select 'S'
        into lc_cambia
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag >= pd_fec
         and a.pptipo = 'F'
         and rownum = 1;
    exception
      when others then
        lc_cambia := 'N';
    end;
  end Sp_verifica602;

  Procedure Sp_backup_ext(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pn_gru in number,
                          pd_fec in date) is
  
    -- MODIFCADO : DCASTRO 2017.05.17 Se detallo campos a insertar en JAQZ525_519                     
  
  begin
    insert into jaqz525_010
      select a.*,pd_fec,1,pn_gru
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
  
    insert into jaqz525_011
      select a.*,pd_fec,1,pn_gru
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top;
  
    insert into jaqz525_601
      select a.*,pd_fec,1,pn_gru
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz525_611
      select a.*,pd_fec,1,pn_gru
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz525_602
      select a.*,pd_fec,1,pn_gru
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz525_612
      select a.*,pd_fec,1,pn_gru
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz525_519
      select jaqz519emp,
             jaqz519mod,
             jaqz519suc,
             jaqz519mda,
             jaqz519pap,
             jaqz519cta,
             jaqz519ope,
             jaqz519sbo,
             jaqz519top,
             jaqz519pzo,
             jaqz519est,
             jaqz519ind,
             jaqz519grp,
             jaqz519rub,
             jaqz519sdo,
             jaqz519pdi,
             jaqz519pro10,
             jaqz519pro11,
             jaqz519pro601,
             jaqz519pro611,
             jaqz519fep,
             jaqz519fpp,
             jaqz519vac,
             jaqz519vac2,
             jaqz519cap,
             jaqz519int,
             jaqz519mor,
             jaqz519seg,
             jaqz519pro602,
             jaqz519pro612,
             jaqz519feca,
             jaqz519r010,
             jaqz519r011,
             jaqz519r601,
             jaqz519r611,
             jaqz519r602,
             jaqz519r612,
             jaqz519spag,
             jaqz519revr,
             jaqz519usrr,
             jaqz519fere
        from jaqz519 a
       where a.jaqz519emp = pn_emp
         and a.jaqz519mod = pn_mod
         and a.jaqz519suc = pn_suc
         and a.jaqz519mda = pn_mda
         and a.jaqz519pap = pn_pap
         and a.jaqz519cta = pn_cta
         and a.jaqz519ope = pn_ope
         and a.jaqz519sbo = pn_sbo
         and a.jaqz519top = pn_top
         and a.jaqz519grp = pn_gru
         and a.jaqz519fep = pd_fec;
  
    commit;
  
  end Sp_backup_ext;

  Procedure Sp_Revierte602_612(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pn_gru in number,
                               pd_fep in date,
                               pc_usr in char,
                               pd_fec in date) is
  
    cursor calendario is
      select *
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S'
       order by ppfpag;
    ld_fecant date;
  
  begin
    for i in calendario loop
      begin
        select a.jaqz522fan
          into ld_fecant
          from jaqz522 a
         where a.jaqz522emp = i.pgcod
           and a.jaqz522mod = i.ppmod
           and a.jaqz522suc = i.ppsuc
           and a.jaqz522mda = i.ppmda
           and a.jaqz522pap = i.pppap
           and a.jaqz522cta = i.ppcta
           and a.jaqz522ope = i.ppoper
           and a.jaqz522sbo = i.ppsbop
           and a.jaqz522top = i.pptope
           and a.jaqz522fac = i.ppfpag
           and a.jaqz522usr = pc_usr
           and a.jaqz522fep = pd_fec;
      exception
        when others then
          null;
      end;
    
      update fsd602 a
         set a.ppfpag = ld_fecant, a.pptipo = 'M'
       where a.pgcod = i.pgcod
         and a.ppmod = i.ppmod
         and a.ppsuc = i.ppsuc
         and a.ppmda = i.ppmda
         and a.pppap = i.pppap
         and a.ppcta = i.ppcta
         and a.ppoper = i.ppoper
         and a.ppsbop = i.ppsbop
         and a.pptope = i.pptope
         and a.ppfpag = i.ppfpag
         and a.d602co = 'S';
    
      --Actualiza si se revertio FSD602
      UPDATE jaqz519 a
         set a.jaqz519r602 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.ppmod
         and a.jaqz519suc = i.ppsuc
         and a.jaqz519mda = i.ppmda
         and a.jaqz519pap = i.pppap
         and a.jaqz519cta = i.ppcta
         and a.jaqz519ope = i.ppoper
         and a.jaqz519sbo = i.ppsbop
         and a.jaqz519top = i.pptope
         and a.jaqz519grp = pn_gru
         and a.jaqz519fep = pd_fep;
    
      update fsd612 a
         set a.ppfpag = ld_fecant, a.pptipo = 'M'
       where a.pgcod = i.pgcod
         and a.ppmod = i.ppmod
         and a.ppsuc = i.ppsuc
         and a.ppmda = i.ppmda
         and a.pppap = i.pppap
         and a.ppcta = i.ppcta
         and a.ppoper = i.ppoper
         and a.ppsbop = i.ppsbop
         and a.pptope = i.pptope
         and a.ppfpag = i.ppfpag;
    
      --Actualiza si se revertio FSD612
      UPDATE jaqz519 a
         set a.jaqz519r612 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.ppmod
         and a.jaqz519suc = i.ppsuc
         and a.jaqz519mda = i.ppmda
         and a.jaqz519pap = i.pppap
         and a.jaqz519cta = i.ppcta
         and a.jaqz519ope = i.ppoper
         and a.jaqz519sbo = i.ppsbop
         and a.jaqz519top = i.pptope
         and a.jaqz519grp = pn_gru
         and a.jaqz519fep = pd_fep;
      commit;
    end loop;
    commit;
  end Sp_Revierte602_612;

  procedure sp_enviocorreoRpta(p_instancia in number) IS
  
    lv_mensaje VARCHAR2(2000);
  
    cursor correos is
    
      SELECT CONCAT(TRIM(sng057sup), '@cajaarequipa.pe') email
        from (select sng057sup
                from sng057
               where sng055emp = 1
                 and sng057usr in
                     (select sng001ase
                        from sng001
                       where sng001inst = p_instancia)
                 and sng057sup is not null
                 and trim(sng057sup) <> ' ')
      UNION
      SELECT CONCAT(TRIM(sng001ase), '@cajaarequipa.pe') email
        from (select sng001ase from sng001 where sng001inst = p_instancia)
      UNION
      SELECT CONCAT(TRIM(fs.UBUSER), '@cajaarequipa.pe') email
        FROM prfu00 fs, fst046 af
       where fs.prfgcod = 'GAGE01'
         and fs.ubuser = af.ubuser
         and ubsuc in
             (select sng001age from sng001 where sng001inst = p_instancia);
  
  begin
    for i in correos loop
    
      lv_mensaje := '<html><head><style type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
                    '</head><body><br><p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">Estimado.</p>' ||
                    '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                    'Se realizó la reprogramación del crédito ' ||
                    to_char(p_instancia) ||
                    '.</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                    'Saludos</p></body></html>';
      sys.sp_sy_enviamail_html(pc_aquien  => i.email,
                               pc_de      => 'notificaciones@cajaarequipa.pe',
                               pc_motivo  => 'Reprogramaciones',
                               pc_mensaje => lv_mensaje);
    
    end loop;
  
  END sp_enviocorreoRpta;

end PQ_CR_REPRO_IND;
/

