create or replace package PQ_CR_REPRO_MASIVO is

  -- Author  : CHERNANDEZ
  -- Created : 29/03/2020
  -- Purpose :
  -- MODIFCADO :--chernandez 06/04/2020
  --Autor modificacion: chernandez
  --fecha modificacion: 10/07/2020
  --Descripcion modificacion: se agrego validacion de fsd012
  --Autor modificacion: jrodriguej
  --fecha modificacion: 26/08/2020
  --Descripcion modificacion: se retira el procedimiento sp_inserta_hsd010

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
                          pc_usu in varchar2,
                          pn_cor in number);
  Procedure sp_cargaInicial(pn_emp       in number,
                            pn_mod       in number,
                            pn_suc       in number,
                            pn_mda       in number,
                            pn_pap       in number,
                            pn_cta       in number,
                            pn_ope       in number,
                            pn_sbo       in number,
                            pn_top       in number,
                            p_n_grupo    in number,
                            p_d_fecpro   in date,
                            p_n_corr     in number,
                            pn_instancia in number);
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
                                p_d_fecpro in date,
                                p_n_corr   in number);
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
                                p_d_fecpro in date,
                                p_n_corr   in number);
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
                                p_d_fecpro in date,
                                p_n_corr   in number);
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
                                p_d_fecpro in date,
                                p_n_corr   in number);
  Procedure sp_insert_jaqz856_857(p_n_emp    in number,
                                  p_n_mod    in number,
                                  p_n_suc    in number,
                                  p_n_mda    in number,
                                  p_n_pap    in number,
                                  p_n_cta    in number,
                                  p_n_ope    in number,
                                  p_n_sbo    in number,
                                  p_n_top    in number,
                                  p_d_fecpro in date,
                                  p_n_corr   in number);
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
                              pn_cor     in number,
                              pn_ind     out number);
  -------------------------------------------------------
  procedure sp_cr_VerfEvento3(ln_pgcod     in number,
                              ln_mod       in number,
                              ln_suc       in number,
                              ln_mda       in number,
                              ln_pap       in number,
                              ln_cta       in number,
                              ln_ope       in number,
                              ln_sbo       in number,
                              ln_tpo       in number,
                              lc_FlagEvnt3 out varchar2);
  -------------------------------------------------------
  procedure sp_cr_up_fsd012(ln_pgcod in number,
                            ln_mod   in number,
                            ln_suc   in number,
                            ln_mda   in number,
                            ln_pap   in number,
                            ln_cta   in number,
                            ln_ope   in number,
                            ln_sbo   in number,
                            ln_tpo   in number,
                            ld_fec   in date,
                            ld_fecre in date);
  -------------------------------------------------------
  /*procedure sp_cr_bk_fsd012(pn_emp in number,
  pn_mod in number,
  pn_suc in number,
  pn_mda in number,
  pn_pap in number,
  pn_cta in number,
  pn_ope in number,
  pn_sbo in number,
  pn_top in number);*/
  ---------------------------------------------------------
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
                          pd_fec in date,
                          pn_cor in number);

  Procedure Sp_valida_pagos(p_n_emp in number,
                            p_n_mod in number,
                            p_n_suc in number,
                            p_n_mda in number,
                            p_n_pap in number,
                            p_n_cta in number,
                            p_n_ope in number,
                            p_n_sbo in number,
                            p_n_top in number,
                            pn_ind  out number);
  Procedure Sp_actualiza_bk(pn_emp      in number,
                            pn_mod      in number,
                            pn_suc      in number,
                            pn_mda      in number,
                            pn_pap      in number,
                            pn_cta      in number,
                            pn_ope      in number,
                            pn_sbo      in number,
                            pn_top      in number,
                            pn_gru      in number,
                            pd_fec      in date,
                            pn_cor      in number,
                            pv_correo   in varchar2,
                            pv_telefono in varchar2);
  procedure sp_enviocorreoRpta(p_instancia in number);

end PQ_CR_REPRO_MASIVO;
/

create or replace package body PQ_CR_REPRO_MASIVO is

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
                          pc_usu in varchar2,
                          pn_cor in number) is
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
       'ESA20');

    insert into AQPA004
      (aqpa004cod,
       aqpa004mod,
       aqpa004suc,
       aqpa004mda,
       aqpa004pap,
       aqpa004cta,
       aqpa004oper,
       aqpa004sbop,
       aqpa004tope,
       aqpa004fval,
       aqpa004fvto,
       aqpa004pzo,
       aqpa004ttas,
       aqpa004tasa,
       aqpa004tmor,
       aqpa004ttac,
       aqpa004tasc,
       aqpa004tdia,
       aqpa004tvto,
       aqpa004tano,
       aqpa004tint,
       aqpa004drev,
       aqpa004imp,
       aqpa004pre,
       aqpa004pre1,
       aqpa004tcbi,
       aqpa004tcbi1,
       aqpa004arb,
       aqpa004arb1,
       aqpa004md,
       aqpa004md1,
       aqpa004nume,
       aqpa004fnum,
       aqpa004afiv,
       aqpa004cbcu,
       aqpa004stat,
       aqpa004avis,
       aqpa004plus,
       aqpa004even,
       aqpa004fe99,
       aqpa004cltcod,
       aqpa004period,
       aqpa004fecpro,
       aqpa004horpro,
       aqpa004cor)
      select a.*, pd_fec, pc_hor, pn_cor --chernandez 19/03/2020
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
      (aqpa005cod,
       aqpa005suc,
       aqpa005rub,
       aqpa005mda,
       aqpa005pap,
       aqpa005cta,
       aqpa005oper,
       aqpa005sbop,
       aqpa005tope,
       aqpa005mod,
       aqpa005fcon,
       aqpa005fval,
       aqpa005fvto,
       aqpa005fulm,
       aqpa005pzo,
       aqpa005sdo,
       aqpa005sdoh,
       aqpa005segm,
       aqpa005func,
       aqpa005stat,
       aqpa005cc,
       aqpa005tit,
       aqpa005cap,
       aqpa005plzo,
       aqpa005gru,
       aqpa005fecpro,
       aqpa005horpro,
       aqpa005cor)
      select a.*, pd_fec, pc_hor, pn_cor --chernandez 19/03/2020
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
      (aqpa006cod,
       aqpa006mod,
       aqpa006suc,
       aqpa006mda,
       aqpa006pap,
       aqpa006cta,
       aqpa006oper,
       aqpa006sbop,
       aqpa006tope,
       aqpa006fpag,
       aqpa006tipo,
       aqpa006fval,
       aqpa006fvto,
       aqpa006pzo,
       aqpa006cap,
       aqpa006int,
       aqpa006intmex,
       aqpa006icap,
       aqpa006iint,
       aqpa006stat,
       aqpa006nume,
       aqpa006finv,
       aqpa006cd,
       aqpa006mo,
       aqpa006su,
       aqpa006tr,
       aqpa006re,
       aqpa006fc,
       aqpa006or,
       aqpa006sb,
       aqpa006co,
       aqpa006fecpro,
       aqpa006horpro,
       aqpa006cor)
      select a.*, pd_fec, pc_hor, pn_cor --chernandez 19/03/2020
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
      (aqpa007cod,
       aqpa007mod,
       aqpa007suc,
       aqpa007mda,
       aqpa007pap,
       aqpa007cta,
       aqpa007oper,
       aqpa007sbop,
       aqpa007tope,
       aqpa007fpag,
       aqpa007tipo,
       aqpa007exte,
       aqpa007imp1,
       aqpa007imp2,
       aqpa007imp3,
       aqpa007imp4,
       aqpa007imp5,
       aqpa007imp6,
       aqpa007imp7,
       aqpa007imp8,
       aqpa007imp9,
       aqpa007imp10,
       aqpa007imp11,
       aqpa007imp12,
       aqpa007imp13,
       aqpa007imp14,
       aqpa007imp15,
       aqpa007imp16,
       aqpa007imp17,
       aqpa007imp18,
       aqpa007imp19,
       aqpa007imp20,
       aqpa007fecpro,
       aqpa007horpro,
       aqpa007cor)
      select a.*, pd_fec, pc_hor, pn_cor --chernandez 19/03/2020
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
      (aqpa008cod,
       aqpa008mod,
       aqpa008suc,
       aqpa008mda,
       aqpa008pap,
       aqpa008cta,
       aqpa008oper,
       aqpa008sbop,
       aqpa008tope,
       aqpa008fpag,
       aqpa008tipo,
       aqpa0081nump,
       aqpa0081fech,
       aqpa0081cap,
       aqpa0081int,
       aqpa0081intmex,
       aqpa0081intm,
       aqpa0081intmmex,
       aqpa0081icap,
       aqpa0081iint,
       aqpa0081iintm,
       aqpa0081salcap,
       aqpa0081salint,
       aqpa0081salade,
       aqpa0081salmor,
       aqpa0081stat,
       aqpa0081salintm,
       aqpa0081salmorm,
       aqpa0081saladem,
       aqpa008cd,
       aqpa008mo,
       aqpa008su,
       aqpa008tr,
       aqpa008re,
       aqpa008fc,
       aqpa008or,
       aqpa008sb,
       aqpa008co,
       aqpa008fecpro,
       aqpa008horpro,
       aqpa008cor)
      select a.*, pd_fec, pc_hor, pn_cor --chernandez 19/03/2020
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
      (aqpa009cod,
       aqpa009mod,
       aqpa009suc,
       aqpa009mda,
       aqpa009pap,
       aqpa009cta,
       aqpa009oper,
       aqpa009sbop,
       aqpa009tope,
       aqpa009fpag,
       aqpa009tipo,
       aqpa009nump,
       aqpa009exte,
       aqpa009imp1,
       aqpa009imp2,
       aqpa009imp3,
       aqpa009imp4,
       aqpa009imp5,
       aqpa009imp6,
       aqpa009imp7,
       aqpa009imp8,
       aqpa009imp9,
       aqpa009imp10,
       aqpa009imp11,
       aqpa009imp12,
       aqpa009imp13,
       aqpa009imp14,
       aqpa009imp15,
       aqpa009imp16,
       aqpa009imp17,
       aqpa009imp18,
       aqpa009imp19,
       aqpa009imp20,
       aqpa009sal1,
       aqpa009sal2,
       aqpa009sal3,
       aqpa009sal4,
       aqpa009sal5,
       aqpa009sal6,
       aqpa009sal7,
       aqpa009sal8,
       aqpa009sal9,
       aqpa009sal10,
       aqpa009sal11,
       aqpa009sal12,
       aqpa009sal13,
       aqpa009sal14,
       aqpa009sal15,
       aqpa009sal16,
       aqpa009sal17,
       aqpa009sal18,
       aqpa009sal19,
       aqpa009sal20,
       aqpa009fecpro,
       aqpa009horpro,
       aqpa009cor)
      select a.*, pd_fec, pc_hor, pn_cor --chernandez 19/03/2020
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

    insert into aqpa004e --chernandez 10/07/2020
      select a.*, pd_fec, pn_cor
        from jaqz520_002 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;

    insert into aqpa004f --chernandez 10/07/2020
      select a.*, pd_fec, pn_cor
        from jaqz520_012 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
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

    delete from jaqz520_002 a --chernandez 10/07/2020
     where a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;

    delete from jaqz520_012 a --chernandez 10/07/2020
     where a.pgcod = pn_emp
       and a.aomod = pn_mod
       and a.aosuc = pn_suc
       and a.aomda = pn_mda
       and a.aopap = pn_pap
       and a.aocta = pn_cta
       and a.aooper = pn_ope
       and a.aosbop = pn_sbo
       and a.aotope = pn_top;
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
    --chernandez 10/07/2020
    insert into jaqz520_002
      select a.*
        from fpp002 a
       where pgcod = pn_emp
         and ppmod = pn_mod
         and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = pn_sbo
         and pptope = pn_top;

    --chernandez 10/07/2020
    insert into jaqz520_012
      select *
        from fsd012 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;

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
       aqpa4chpro,
       aqpa4ccor)
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
             pc_hor,
             pn_cor
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
       aqpa4dhopro,
       aqpa4dcor)
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
             pc_hor,
             pn_cor

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

    commit;

  end Sp_backup_ini;

  Procedure sp_cargaInicial(pn_emp       in number,
                            pn_mod       in number,
                            pn_suc       in number,
                            pn_mda       in number,
                            pn_pap       in number,
                            pn_cta       in number,
                            pn_ope       in number,
                            pn_sbo       in number,
                            pn_top       in number,
                            p_n_grupo    in number,
                            p_d_fecpro   in date,
                            p_n_corr     in number,
                            pn_instancia in number) is

    ln_estcre number(2);
    cursor datos is
      select a.pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope,
             a.aostat ln_estcre,
             c.scrub  ln_rub,
             c.scsdo  ln_sdo

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
    ln_tdoc number(3);
    lc_ndoc character(12);
  begin
    begin
      select sng001tdoc, sng001ndoc
        into ln_tdoc, lc_ndoc
        from sng001
       where sng001inst = pn_instancia;
    exception
      when others then
        null;
    end;
    begin
      for i in datos loop

        update AQPB002 a
           set AQPB002estcr = i.ln_estcre,
               AQPB002RUB   = i.ln_rub,
               AQPB002SDO   = i.ln_sdo,
               AQPB002TDO   = ln_tdoc,
               AQPB002NDO   = lc_ndoc
         where a.AQPB002emp = i.pgcod
           and a.AQPB002mod = i.aomod
           and a.AQPB002suc = i.aosuc
           and a.AQPB002mda = i.aomda
           and a.AQPB002pap = i.aopap
           and a.AQPB002cta = i.aocta
           and a.AQPB002ope = i.aooper
           and a.AQPB002sbo = i.aosbop
           and a.AQPB002top = i.aotope
           and a.AQPB002grp = p_n_grupo
           and a.AQPB002fep = p_d_fecpro
           and a.aqpb002cor = p_n_corr;
        commit;
      end loop;
    exception
      when others then
        null;
    end;

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
                                p_d_fecpro in date,
                                p_n_corr   in number) is
    cursor creditos is
      select b.AQPB002emp pgcod,
             b.AQPB002mod aomod,
             b.AQPB002suc aosuc,
             b.AQPB002mda aomda,
             b.AQPB002pap aopap,
             b.AQPB002cta aocta,
             b.AQPB002ope aooper,
             b.AQPB002sbo aosbop,
             b.AQPB002top aotope,
             b.AQPB002pdi
        from AQPB002 b
       where b.AQPB002emp = p_n_emp
         and b.AQPB002mod = p_n_mod
         and b.AQPB002suc = p_n_suc
         and b.AQPB002mda = p_n_mda
         and b.AQPB002pap = p_n_pap
         and b.AQPB002cta = p_n_cta
         and b.AQPB002ope = p_n_ope
         and b.AQPB002sbo = p_n_sbo
         and b.AQPB002top = p_n_top
         and b.AQPB002grp = p_n_grupo
         and b.AQPB002fep = p_d_fecpro
         and b.aqpb002cor = p_n_corr;

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
      ln_numpdi := i.AQPB002pdi;

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

      end loop;

      --PPFVAL
      update AQPB002 A
         set a.AQPB002PRO601 = 'S'
       where a.AQPB002emp = i.pgcod
         and a.AQPB002mod = i.aomod
         and a.AQPB002suc = i.aosuc
         and a.AQPB002mda = i.aomda
         and a.AQPB002pap = i.aopap
         and a.AQPB002cta = i.aocta
         and a.AQPB002ope = i.aooper
         and a.AQPB002sbo = i.aosbop
         and a.AQPB002top = i.aotope
         and a.AQPB002grp = p_n_grupo
         and a.AQPB002fep = p_d_fecpro
         and a.aqpb002cor = p_n_corr;

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
                                p_d_fecpro in date,
                                p_n_corr   in number) is
    cursor creditos is

      select b.AQPB002emp pgcod,
             b.AQPB002mod aomod,
             b.AQPB002suc aosuc,
             b.AQPB002mda aomda,
             b.AQPB002pap aopap,
             b.AQPB002cta aocta,
             b.AQPB002ope aooper,
             b.AQPB002sbo aosbop,
             b.AQPB002top aotope,
             b.AQPB002pdi
        from AQPB002 b
       where b.AQPB002emp = p_n_emp
         and b.AQPB002mod = p_n_mod
         and b.AQPB002suc = p_n_suc
         and b.AQPB002mda = p_n_mda
         and b.AQPB002pap = p_n_pap
         and b.AQPB002cta = p_n_cta
         and b.AQPB002ope = p_n_ope
         and b.AQPB002sbo = p_n_sbo
         and b.AQPB002top = p_n_top
         and b.AQPB002grp = p_n_grupo
         and b.AQPB002fep = p_d_fecpro
         and b.aqpb002cor = p_n_corr;

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

    ld_ppfpag date;

    lc_hab_ppfpag char(1);

    ld_ppfpag_F date;

    ln_countTot number;
    ln_contAF   number;

    --mod@abr 20170403
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
      counter   := 0;
      name_list := c_list();
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

      ln_numpdi := i.AQPB002pdi;
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

      end loop;

      update AQPB002 A
         set a.AQPB002PRO611 = 'S'
       where a.AQPB002emp = i.pgcod
         and a.AQPB002mod = i.aomod
         and a.AQPB002suc = i.aosuc
         and a.AQPB002mda = i.aomda
         and a.AQPB002pap = i.aopap
         and a.AQPB002cta = i.aocta
         and a.AQPB002ope = i.aooper
         and a.AQPB002sbo = i.aosbop
         and a.AQPB002top = i.aotope
         and a.AQPB002grp = p_n_grupo
         and a.AQPB002fep = p_d_fecpro
         and a.aqpb002cor = p_n_corr;

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
                                p_d_fecpro in date,
                                p_n_corr   in number) is
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
             b.AQPB002pzo,
             a.aofval
        from fsd010 a, AQPB002 b
       where a.pgcod = b.AQPB002emp
         and a.aomod = b.AQPB002mod
         and a.aosuc = b.AQPB002suc
         and a.aomda = b.AQPB002mda
         and a.aopap = b.AQPB002pap
         and a.aocta = b.AQPB002cta
         and a.aooper = b.AQPB002ope
         and a.aosbop = b.AQPB002sbo
         and a.aotope = b.AQPB002top
         and b.AQPB002emp = p_n_emp
         and b.AQPB002mod = p_n_mod
         and b.AQPB002suc = p_n_suc
         and b.AQPB002mda = p_n_mda
         and b.AQPB002pap = p_n_pap
         and b.AQPB002cta = p_n_cta
         and b.AQPB002ope = p_n_ope
         and b.AQPB002sbo = p_n_sbo
         and b.AQPB002top = p_n_top
         and b.AQPB002grp = p_n_grupo
         and b.AQPB002fep = p_d_fecpro
         and b.aqpb002cor = p_n_corr;

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

      update AQPB002 A
         set a.AQPB002PRO10 = 'S'
       where a.AQPB002emp = i.pgcod
         and a.AQPB002mod = i.aomod
         and a.AQPB002suc = i.aosuc
         and a.AQPB002mda = i.aomda
         and a.AQPB002pap = i.aopap
         and a.AQPB002cta = i.aocta
         and a.AQPB002ope = i.aooper
         and a.AQPB002sbo = i.aosbop
         and a.AQPB002top = i.aotope
         and a.AQPB002grp = p_n_grupo
         and a.AQPB002fep = p_d_fecpro
         and a.aqpb002cor = p_n_corr;

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
                                p_d_fecpro in date,
                                p_n_corr   in number) is
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
             b.AQPB002pzo,
             a.scfval --mod@abr 20170405
        from fsd011 a, AQPB002 b
       where a.pgcod = b.AQPB002emp
         and a.scsuc = b.AQPB002suc
         and a.scmda = b.AQPB002mda
         and a.scpap = b.AQPB002pap
         and a.sccta = b.AQPB002cta
         and a.scoper = b.AQPB002ope
         and a.scsbop = b.AQPB002sbo
         and a.sctope = b.AQPB002top
         and a.scmod = b.AQPB002mod
         and a.scfvto is not null
         and b.AQPB002emp = p_n_emp
         and b.AQPB002mod = p_n_mod
         and b.AQPB002suc = p_n_suc
         and b.AQPB002mda = p_n_mda
         and b.AQPB002pap = p_n_pap
         and b.AQPB002cta = p_n_cta
         and b.AQPB002ope = p_n_ope
         and b.AQPB002sbo = p_n_sbo
         and b.AQPB002top = p_n_top
         and b.AQPB002grp = p_n_grupo
         and b.AQPB002fep = p_d_fecpro
         and b.aqpb002cor = p_n_corr;
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

      update AQPB002 A
         set a.AQPB002PRO11 = 'S'
       where a.AQPB002emp = i.pgcod
         and a.AQPB002mod = i.scmod
         and a.AQPB002suc = i.scsuc
         and a.AQPB002mda = i.scmda
         and a.AQPB002pap = i.scpap
         and a.AQPB002cta = i.sccta
         and a.AQPB002ope = i.scoper
         and a.AQPB002sbo = i.scsbop
         and a.AQPB002top = i.sctope
         and a.AQPB002grp = p_n_grupo
         and a.AQPB002fep = p_d_fecpro
         and a.aqpb002cor = p_n_corr;

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
                                  p_d_fecpro in date,
                                  p_n_corr   in number) is

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

          select j.AQPB002emp,
                 j.AQPB002mod,
                 j.AQPB002suc,
                 j.AQPB002mda,
                 j.AQPB002pap,
                 j.AQPB002cta,
                 j.AQPB002ope,
                 j.AQPB002sbo,
                 j.AQPB002top,
                 j.AQPB002pzo,
                 j.AQPB002est,
                 j.AQPB002ind,
                 j.AQPB002grp,
                 j.AQPB002rub,
                 j.AQPB002sdo,
                 j.AQPB002fep

            from AQPB002 j
           where j.AQPB002pro10 = 'S'
             and j.AQPB002pro11 = 'S'
             and j.AQPB002pro601 = 'S'
             and j.AQPB002pro611 = 'S'
             and j.AQPB002emp = p_n_emp
             and j.AQPB002mod = p_n_mod
             and j.AQPB002suc = p_n_suc
             and j.AQPB002mda = p_n_mda
             and j.AQPB002pap = p_n_pap
             and j.AQPB002cta = p_n_cta
             and j.AQPB002ope = p_n_ope
             and j.AQPB002sbo = p_n_sbo
             and j.AQPB002top = p_n_top
             and j.AQPB002fep = p_d_fecpro
             and j.aqpb002cor = p_n_corr;

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

          select j.AQPB002emp,
                 j.AQPB002mod,
                 j.AQPB002suc,
                 j.AQPB002mda,
                 j.AQPB002pap,
                 j.AQPB002cta,
                 j.AQPB002ope,
                 j.AQPB002sbo,
                 j.AQPB002top,
                 j.AQPB002pzo,
                 j.AQPB002est,
                 j.AQPB002ind,
                 j.AQPB002grp,
                 j.AQPB002rub,
                 j.AQPB002sdo,
                 j.AQPB002fep

            from AQPB002 j
           where j.AQPB002pro10 = 'S'
             and j.AQPB002pro11 = 'S'
             and j.AQPB002pro601 = 'S'
             and j.AQPB002pro611 = 'S'
             and j.AQPB002emp = p_n_emp
             and j.AQPB002mod = p_n_mod
             and j.AQPB002suc = p_n_suc
             and j.AQPB002mda = p_n_mda
             and j.AQPB002pap = p_n_pap
             and j.AQPB002cta = p_n_cta
             and j.AQPB002ope = p_n_ope
             and j.AQPB002sbo = p_n_sbo
             and j.AQPB002top = p_n_top
             and j.AQPB002fep = p_d_fecpro
             and j.aqpb002cor = p_n_corr;

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
          select j.AQPB002emp,
                 j.AQPB002mod,
                 j.AQPB002suc,
                 j.AQPB002mda,
                 j.AQPB002pap,
                 j.AQPB002cta,
                 j.AQPB002ope,
                 j.AQPB002sbo,
                 j.AQPB002top,
                 j.AQPB002pzo,
                 j.AQPB002est,
                 j.AQPB002ind,
                 j.AQPB002grp,
                 j.AQPB002rub,
                 j.AQPB002sdo,
                 j.AQPB002fep

            from AQPB002 j
           where j.AQPB002pro10 = 'S'
             and j.AQPB002pro11 = 'S'
             and j.AQPB002pro601 = 'S'
             and j.AQPB002pro611 = 'S'
             and j.AQPB002emp = p_n_emp
             and j.AQPB002mod = p_n_mod
             and j.AQPB002suc = p_n_suc
             and j.AQPB002mda = p_n_mda
             and j.AQPB002pap = p_n_pap
             and j.AQPB002cta = p_n_cta
             and j.AQPB002ope = p_n_ope
             and j.AQPB002sbo = p_n_sbo
             and j.AQPB002top = p_n_top
             and j.AQPB002fep = p_d_fecpro
             and j.aqpb002cor = p_n_corr;
      end if;
    exception
      when others then
        null;
    End;
    commit;
  end sp_insert_jaqz856_857;
  ----------------------------------------------------------------------
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
                              pn_cor     in number,
                              pn_ind     out number) is

    cursor creditos is
      select *
        from AQPB002 b
       where /*b.AQPB002ind in ('S', 'P')
                                                                                                                                                                                                                                                                                                                                                                                                   and*/
       b.AQPB002emp = p_n_emp
       and b.AQPB002mod = p_n_mod
       and b.AQPB002suc = p_n_suc
       and b.AQPB002mda = p_n_mda
       and b.AQPB002pap = p_n_pap
       and b.AQPB002cta = p_n_cta
       and b.AQPB002ope = p_n_ope
       and b.AQPB002sbo = p_n_sbo
       and b.AQPB002top = p_n_top
       and b.AQPB002grp = p_n_gru
       and b.AQPB002fep = p_d_fecpro
       and b.aqpb002cor = pn_cor
       and b.AQPB002pro10 = 'S'
       and b.AQPB002pro11 = 'S'
       and b.AQPB002pro601 = 'S'
       and b.AQPB002pro611 = 'S'
       and b.AQPB002revr is null;

    cursor pagos is
      select a.*
        from fsd602 a
        full join jaqz520_602 b
          on a.pgcod = b.pgcod
         and a.ppmod = b.ppmod
         and a.ppsuc = b.ppsuc
         and a.ppmda = b.ppmda
         and a.pppap = b.pppap
         and a.ppcta = b.ppcta
         and a.ppoper = b.ppoper
         and a.ppsbop = b.ppsbop
         and a.pptope = b.pptope
         and a.pp1nump = b.pp1nump
       where a.pgcod = p_n_emp
         and a.ppmod = p_n_mod
         and a.ppsuc = p_n_suc
         and a.ppmda = p_n_mda
         and a.pppap = p_n_pap
         and a.ppcta = p_n_cta
         and a.ppoper = p_n_ope
         and a.ppsbop = p_n_sbo
         and a.pptope = p_n_top
         and b.ppcta is null;

    ld_fvto11    date;
    ln_pzo11     number(5);
    ld_fvto10    date;
    ln_pzo10     number(5);
    contPagos    number(5);
    contSeguros  number(5);
    ln_602Ant    number(5);
    ln_pp1nump   number(5);
    lf_fecpagbk  date;
    lc_tipobk    char(1);
    ln_mora      varchar2(1);
    lc_FlagEvnt3 varchar2(5) := 'N';
    lc_HoraExtorno char(8) := '00:00:00'; -- agregado 11.10.21 bba
    lc_usuarExtorno char(10); -- agregado 11.10.21 bba
    ln_sucurExtorno number; -- agregado 11.10.21 bba
    vl_numObserv number(9); --agregado 17.12.2021 bba

  begin
    pn_ind := 0;
    begin
      select 0 -- 0 si no se ha revertido aun, 1 si ya se revirtio o no existe
        into pn_ind
        from AQPB002 b
       where /*b.AQPB002ind in ('S', 'P')
                                                                                                                                                                                                                                                                                                                                                                                                   and */
       b.AQPB002emp = p_n_emp
       and b.AQPB002mod = p_n_mod
       and b.AQPB002suc = p_n_suc
       and b.AQPB002mda = p_n_mda
       and b.AQPB002pap = p_n_pap
       and b.AQPB002cta = p_n_cta
       and b.AQPB002ope = p_n_ope
       and b.AQPB002sbo = p_n_sbo
       and b.AQPB002top = p_n_top
       and b.AQPB002grp = p_n_gru
       and b.AQPB002fep = p_d_fecpro
       and b.aqpb002cor = pn_cor
       and b.AQPB002pro10 = 'S'
       and b.AQPB002pro11 = 'S'
       and b.AQPB002pro601 = 'S'
       and b.AQPB002pro611 = 'S'
       and b.AQPB002revr is null;
    exception
      when others then
        pn_ind := 1;
    end;

    If pn_ind = 0 then
      begin
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
           order by ppfpag;

          select count(*)
            into ln_602Ant
            from JAQZ520_602 a
           where a.pgcod = p_n_emp
             and a.ppmod = p_n_mod
             and a.ppsuc = p_n_suc
             and a.ppmda = p_n_mda
             and a.pppap = p_n_pap
             and a.ppcta = p_n_cta
             and a.ppoper = p_n_ope
             and a.ppsbop = p_n_sbo
             and a.pptope = p_n_top
             and a.d602co = 'S';
          ln_mora := 'N';
          if i.aqpb002fei < pd_fec then
            ln_mora := 'S';
          End if;
          if i.aqpb002mora = 'S' then
            ln_mora := 'S';
          End if;

          --tiene pagos posteriores y estaba o estaría en mora
                if contPagos <> ln_602Ant and ln_mora = 'S' then
                  pn_ind := 2;
                else
                  --valido si agregó o desafilió seguros

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
                     and AQPA4CCor = pn_cor
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
                          -- mpostigoc 14.05.2020
                          --chernandez 10/07/2020
                          /*pq_cr_repro_masivo.sp_cr_VerfEvento3(p_n_emp,
                          p_n_mod,
                          p_n_suc,
                          p_n_mda,
                          p_n_pap,
                          p_n_cta,
                          p_n_ope,
                          p_n_sbo,
                          p_n_top,
                          lc_FlagEvnt3);*/
                          lc_FlagEvnt3 := 'N';
                                if lc_FlagEvnt3 = 'S' then
                                  pn_ind := 4;
                                else
                                  --creditos obse para Reactiva y Mype(tabla producto de carga masiva) BBA 17.12.2021
                                   WITH bloqueados_reactiva_fae as (
                                      SELECT F.EMPRESA as emp, F.MODULO as modl, F.SUCURSAL as sucur, F.MONEDA as mnda, F.PAPEL as papl, 
                                             SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) as cta,
                                            SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1, 99) as oper,  
                                            F.SUBOPERACION as sbop, F.TIPOOPERACION as tope
                                      FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
                                      WHERE F.IDFONDO = G.IDFONDO
                                       AND G.ESTADOSOLICITUD IN ( 'BT','AP','CE')                
                                       AND F.EMPRESA = p_n_emp
                                       AND F.MODULO = p_n_mod
                                       AND F.SUCURSAL = p_n_suc
                                       AND F.MONEDA = p_n_mda
                                       AND F.PAPEL = p_n_pap
                                       AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = p_n_cta         
                                       AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1, 99) = p_n_ope         
                                       AND F.SUBOPERACION = p_n_sbo
                                       AND F.TIPOOPERACION = p_n_top)
                                       
                                       select count(*) into vl_numObserv
                                       from bloqueados_reactiva_fae 
                                       where  (emp,  modl,  sucur,  mnda,  papl,  cta,  oper,   sbop,  tope) not in 
                                            (SELECT AQPB764BPEMP, AQPB764BOMOD, AQPB764BOSUC, AQPB764BMNDA, AQPB764BPAPL, AQPB764BCCTA, AQPB764BOPER, AQPB764BSBOP, AQPB764BTOPE 
                                            from AQPB764B
                                            where AQPB764BPEMP = p_n_emp
                                            and AQPB764BOMOD = p_n_mod
                                            and AQPB764BOSUC = p_n_suc
                                            and AQPB764BMNDA = p_n_mda
                                            and AQPB764BPAPL = p_n_pap
                                            and AQPB764BCCTA = p_n_cta
                                            and AQPB764BOPER = p_n_ope
                                            and AQPB764BSBOP = p_n_sbo
                                            and AQPB764BTOPE = p_n_top
                                            and AQPB764BEST <> 'D');

                                      if vl_numObserv > 0 then
                                         pn_ind := 6;

                                      else
                                          PQ_CR_REPRO_MASIVO.Sp_backup_ext(i.AQPB002emp,
                                                                           i.AQPB002mod,
                                                                           i.AQPB002suc,
                                                                           i.AQPB002mda,
                                                                           i.AQPB002pap,
                                                                           i.AQPB002cta,
                                                                           i.AQPB002ope,
                                                                           i.AQPB002sbo,
                                                                           i.AQPB002top,
                                                                           i.AQPB002grp,
                                                                           i.AQPB002fep,
                                                                           i.aqpb002cor);

                                        select nvl(max(pp1nump), 0)
                                          into ln_pp1nump
                                          from jaqz520_602 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.ppmod = i.AQPB002mod
                                           and a.ppsuc = i.AQPB002suc
                                           and a.ppmda = i.AQPB002mda
                                           and a.pppap = i.AQPB002pap
                                           and a.ppcta = i.AQPB002cta
                                           and a.ppoper = i.AQPB002ope
                                           and a.ppsbop = i.AQPB002sbo
                                           and a.pptope = i.AQPB002top;

                                        delete from fsd602 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.ppmod = i.AQPB002mod
                                           and a.ppsuc = i.AQPB002suc
                                           and a.ppmda = i.AQPB002mda
                                           and a.pppap = i.AQPB002pap
                                           and a.ppcta = i.AQPB002cta
                                           and a.ppoper = i.AQPB002ope
                                           and a.ppsbop = i.AQPB002sbo
                                           and a.pptope = i.AQPB002top
                                           and a.pp1nump <= ln_pp1nump;

                                        insert into fsd602
                                          select *
                                            from jaqz520_602 a
                                           where a.pgcod = i.AQPB002emp
                                             and a.ppmod = i.AQPB002mod
                                             and a.ppsuc = i.AQPB002suc
                                             and a.ppmda = i.AQPB002mda
                                             and a.pppap = i.AQPB002pap
                                             and a.ppcta = i.AQPB002cta
                                             and a.ppoper = i.AQPB002ope
                                             and a.ppsbop = i.AQPB002sbo
                                             and a.pptope = i.AQPB002top;

                                        delete from fsd612 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.ppmod = i.AQPB002mod
                                           and a.ppsuc = i.AQPB002suc
                                           and a.ppmda = i.AQPB002mda
                                           and a.pppap = i.AQPB002pap
                                           and a.ppcta = i.AQPB002cta
                                           and a.ppoper = i.AQPB002ope
                                           and a.ppsbop = i.AQPB002sbo
                                           and a.pptope = i.AQPB002top
                                           and a.pp1nump <= ln_pp1nump;

                                        insert into fsd612
                                          select *
                                            from jaqz520_612 a
                                           where a.pgcod = i.AQPB002emp
                                             and a.ppmod = i.AQPB002mod
                                             and a.ppsuc = i.AQPB002suc
                                             and a.ppmda = i.AQPB002mda
                                             and a.pppap = i.AQPB002pap
                                             and a.ppcta = i.AQPB002cta
                                             and a.ppoper = i.AQPB002ope
                                             and a.ppsbop = i.AQPB002sbo
                                             and a.pptope = i.AQPB002top;

                                        delete from fpp003 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.ppmod = i.AQPB002mod
                                           and a.ppsuc = i.AQPB002suc
                                           and a.ppmda = i.AQPB002mda
                                           and a.pppap = i.AQPB002pap
                                           and a.ppcta = i.AQPB002cta
                                           and a.ppoper = i.AQPB002ope
                                           and a.ppsbop = i.AQPB002sbo
                                           and a.pptope = i.AQPB002top
                                           and a.pp003nump <= ln_pp1nump;

                                        insert into fpp003
                                          select aqpa4dpgcod,
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
                                                 --aqpa4dfepro,
                                                 aqpa4dimp,
                                                 aqpa4dstat,
                                                 aqpa4daux1,
                                                 aqpa4daux2,
                                                 aqpa4daux3

                                            from AQPA004D a
                                           where a.aqpa4dpgcod = i.AQPB002emp
                                             and a.aqpa4dmod = i.AQPB002mod
                                             and a.aqpa4dsuc = i.AQPB002suc
                                             and a.aqpa4dmda = i.AQPB002mda
                                             and a.aqpa4dpap = i.AQPB002pap
                                             and a.aqpa4dcta = i.AQPB002cta
                                             and a.aqpa4doper = i.AQPB002ope
                                             and a.aqpa4dsbop = i.AQPB002sbo
                                             and a.aqpa4dtope = i.AQPB002top
                                             and a.aqpa4dfepro = i.aqpb002fep
                                             and a.aqpa4dcor = i.aqpb002cor;

                                        for gg in pagos loop
                                          select b.ppfpag, b.pptipo
                                            into lf_fecpagbk, lc_tipobk
                                            from (select rownum cont1, a2.*
                                                    from (select a1.*
                                                            from fsd601 a1
                                                           where a1.pgcod = gg.pgcod
                                                             and a1.ppmod = gg.ppmod
                                                             and a1.ppsuc = gg.ppsuc
                                                             and a1.ppmda = gg.ppmda
                                                             and a1.pppap = gg.pppap
                                                             and a1.ppcta = gg.ppcta
                                                             and a1.ppoper = gg.ppoper
                                                             and a1.ppsbop = gg.ppsbop
                                                             and a1.pptope = gg.pptope
                                                             and a1.d601co = 'S'
                                                           order by a1.ppfpag) a2) a
                                           inner join (select rownum cont2, b2.*
                                                         from (select b1.*
                                                                 from jaqz520_601 b1
                                                                where b1.pgcod = gg.pgcod
                                                                  and b1.ppmod = gg.ppmod
                                                                  and b1.ppsuc = gg.ppsuc
                                                                  and b1.ppmda = gg.ppmda
                                                                  and b1.pppap = gg.pppap
                                                                  and b1.ppcta = gg.ppcta
                                                                  and b1.ppoper = gg.ppoper
                                                                  and b1.ppsbop = gg.ppsbop
                                                                  and b1.pptope = gg.pptope
                                                                  and b1.d601co = 'S'
                                                                order by b1.ppfpag) b2) b
                                              on a.pgcod = b.pgcod
                                             and a.ppmod = b.ppmod
                                             and a.ppsuc = b.ppsuc
                                             and a.ppmda = b.ppmda
                                             and a.pppap = b.pppap
                                             and a.ppcta = b.ppcta
                                             and a.ppoper = b.ppoper
                                             and a.ppsbop = b.ppsbop
                                             and a.pptope = b.pptope
                                             and a.cont1 = b.cont2
                                           where a.pgcod = gg.pgcod
                                             and a.ppmod = gg.ppmod
                                             and a.ppsuc = gg.ppsuc
                                             and a.ppmda = gg.ppmda
                                             and a.pppap = gg.pppap
                                             and a.ppcta = gg.ppcta
                                             and a.ppoper = gg.ppoper
                                             and a.ppsbop = gg.ppsbop
                                             and a.pptope = gg.pptope
                                             and a.d601co = 'S'
                                             and a.ppfpag = gg.ppfpag;

                                          update fsd602 a
                                             set ppfpag = lf_fecpagbk, pptipo = lc_tipobk
                                           where a.pgcod = gg.pgcod
                                             and a.ppmod = gg.ppmod
                                             and a.ppsuc = gg.ppsuc
                                             and a.ppmda = gg.ppmda
                                             and a.pppap = gg.pppap
                                             and a.ppcta = gg.ppcta
                                             and a.ppoper = gg.ppoper
                                             and a.ppsbop = gg.ppsbop
                                             and a.pptope = gg.pptope
                                             and a.pp1nump = gg.pp1nump
                                             and a.ppfpag = gg.ppfpag;

                                          update fsd612 a
                                             set ppfpag = lf_fecpagbk, pptipo = lc_tipobk
                                           where a.pgcod = gg.pgcod
                                             and a.ppmod = gg.ppmod
                                             and a.ppsuc = gg.ppsuc
                                             and a.ppmda = gg.ppmda
                                             and a.pppap = gg.pppap
                                             and a.ppcta = gg.ppcta
                                             and a.ppoper = gg.ppoper
                                             and a.ppsbop = gg.ppsbop
                                             and a.pptope = gg.pptope
                                             and a.pp1nump = gg.pp1nump
                                             and a.ppfpag = gg.ppfpag;

                                          update fpp003 a
                                             set ppfpag = lf_fecpagbk, pptipo = lc_tipobk
                                           where a.pgcod = gg.pgcod
                                             and a.ppmod = gg.ppmod
                                             and a.ppsuc = gg.ppsuc
                                             and a.ppmda = gg.ppmda
                                             and a.pppap = gg.pppap
                                             and a.ppcta = gg.ppcta
                                             and a.ppoper = gg.ppoper
                                             and a.ppsbop = gg.ppsbop
                                             and a.pptope = gg.pptope
                                             and a.pp003nump = gg.pp1nump
                                             and a.ppfpag = gg.ppfpag;

                                        end loop;

                                        --cronograma
                                        --chernandez 06/04/2020
                                        delete from fpp002 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.ppmod = i.AQPB002mod
                                           and a.ppsuc = i.AQPB002suc
                                           and a.ppmda = i.AQPB002mda
                                           and a.pppap = i.AQPB002pap
                                           and a.ppcta = i.AQPB002cta
                                           and a.ppoper = i.AQPB002ope
                                           and a.ppsbop = i.AQPB002sbo
                                           and a.pptope = i.AQPB002top;

                                        insert into fpp002 a
                                          select *
                                            from jaqz520_002 a
                                           where a.pgcod = i.AQPB002emp
                                             and a.ppmod = i.AQPB002mod
                                             and a.ppsuc = i.AQPB002suc
                                             and a.ppmda = i.AQPB002mda
                                             and a.pppap = i.AQPB002pap
                                             and a.ppcta = i.AQPB002cta
                                             and a.ppoper = i.AQPB002ope
                                             and a.ppsbop = i.AQPB002sbo
                                             and a.pptope = i.AQPB002top;

                                        delete from fsd601 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.ppmod = i.AQPB002mod
                                           and a.ppsuc = i.AQPB002suc
                                           and a.ppmda = i.AQPB002mda
                                           and a.pppap = i.AQPB002pap
                                           and a.ppcta = i.AQPB002cta
                                           and a.ppoper = i.AQPB002ope
                                           and a.ppsbop = i.AQPB002sbo
                                           and a.pptope = i.AQPB002top;

                                        insert into fsd601 a
                                          select *
                                            from jaqz520_601 a
                                           where a.pgcod = i.AQPB002emp
                                             and a.ppmod = i.AQPB002mod
                                             and a.ppsuc = i.AQPB002suc
                                             and a.ppmda = i.AQPB002mda
                                             and a.pppap = i.AQPB002pap
                                             and a.ppcta = i.AQPB002cta
                                             and a.ppoper = i.AQPB002ope
                                             and a.ppsbop = i.AQPB002sbo
                                             and a.pptope = i.AQPB002top;
                                        --Actualiza si se revertio FSD601
                                        UPDATE AQPB002 a
                                           set a.AQPB002r601 = 'S'
                                         where a.AQPB002emp = i.AQPB002emp
                                           and a.AQPB002mod = i.AQPB002mod
                                           and a.AQPB002suc = i.AQPB002suc
                                           and a.AQPB002mda = i.AQPB002mda
                                           and a.AQPB002pap = i.AQPB002pap
                                           and a.AQPB002cta = i.AQPB002cta
                                           and a.AQPB002ope = i.AQPB002ope
                                           and a.AQPB002sbo = i.AQPB002sbo
                                           and a.AQPB002top = i.AQPB002top
                                           and a.AQPB002grp = i.AQPB002grp
                                           and a.AQPB002fep = i.AQPB002fep
                                           and a.aqpb002cor = i.aqpb002cor;

                                        delete from fsd611 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.ppmod = i.AQPB002mod
                                           and a.ppsuc = i.AQPB002suc
                                           and a.ppmda = i.AQPB002mda
                                           and a.pppap = i.AQPB002pap
                                           and a.ppcta = i.AQPB002cta
                                           and a.ppoper = i.AQPB002ope
                                           and a.ppsbop = i.AQPB002sbo
                                           and a.pptope = i.AQPB002top;

                                        insert into fsd611 a
                                          select *
                                            from jaqz520_611 a
                                           where a.pgcod = i.AQPB002emp
                                             and a.ppmod = i.AQPB002mod
                                             and a.ppsuc = i.AQPB002suc
                                             and a.ppmda = i.AQPB002mda
                                             and a.pppap = i.AQPB002pap
                                             and a.ppcta = i.AQPB002cta
                                             and a.ppoper = i.AQPB002ope
                                             and a.ppsbop = i.AQPB002sbo
                                             and a.pptope = i.AQPB002top;

                                        --Actualiza si se revertio FSD611
                                        UPDATE AQPB002 a
                                           set a.AQPB002r611 = 'S'
                                         where a.AQPB002emp = i.AQPB002emp
                                           and a.AQPB002mod = i.AQPB002mod
                                           and a.AQPB002suc = i.AQPB002suc
                                           and a.AQPB002mda = i.AQPB002mda
                                           and a.AQPB002pap = i.AQPB002pap
                                           and a.AQPB002cta = i.AQPB002cta
                                           and a.AQPB002ope = i.AQPB002ope
                                           and a.AQPB002sbo = i.AQPB002sbo
                                           and a.AQPB002top = i.AQPB002top
                                           and a.AQPB002grp = i.AQPB002grp
                                           and a.AQPB002fep = i.AQPB002fep
                                           and a.aqpb002cor = i.aqpb002cor;

                                        select aofvto, aopzo
                                          into ld_fvto10, ln_pzo10
                                          from jaqz520_010 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.aomod = i.AQPB002mod
                                           and a.aosuc = i.AQPB002suc
                                           and a.aomda = i.AQPB002mda
                                           and a.aopap = i.AQPB002pap
                                           and a.aocta = i.AQPB002cta
                                           and a.aooper = i.AQPB002ope
                                           and a.aosbop = i.AQPB002sbo
                                           and a.aotope = i.AQPB002top;

                                        update fsd010 a
                                           set a.aofvto = ld_fvto10, a.aopzo = ln_pzo10
                                         where a.pgcod = i.AQPB002emp
                                           and a.aomod = i.AQPB002mod
                                           and a.aosuc = i.AQPB002suc
                                           and a.aomda = i.AQPB002mda
                                           and a.aopap = i.AQPB002pap
                                           and a.aocta = i.AQPB002cta
                                           and a.aooper = i.AQPB002ope
                                           and a.aosbop = i.AQPB002sbo
                                           and a.aotope = i.AQPB002top;

                                        --Actualiza si se revertio FSD010
                                        UPDATE AQPB002 a
                                           set a.AQPB002r010 = 'S'
                                         where a.AQPB002emp = i.AQPB002emp
                                           and a.AQPB002mod = i.AQPB002mod
                                           and a.AQPB002suc = i.AQPB002suc
                                           and a.AQPB002mda = i.AQPB002mda
                                           and a.AQPB002pap = i.AQPB002pap
                                           and a.AQPB002cta = i.AQPB002cta
                                           and a.AQPB002ope = i.AQPB002ope
                                           and a.AQPB002sbo = i.AQPB002sbo
                                           and a.AQPB002top = i.AQPB002top
                                           and a.AQPB002grp = i.AQPB002grp
                                           and a.AQPB002fep = i.AQPB002fep
                                           and a.aqpb002cor = i.aqpb002cor;

                                        select a.scfvto, a.scpzo
                                          into ld_fvto11, ln_pzo11
                                          from jaqz520_011 a
                                         where a.pgcod = i.AQPB002emp
                                           and a.scmod = i.AQPB002mod
                                           and a.scsuc = i.AQPB002suc
                                           and a.scmda = i.AQPB002mda
                                           and a.scpap = i.AQPB002pap
                                           and a.sccta = i.AQPB002cta
                                           and a.scoper = i.AQPB002ope
                                           and a.scsbop = i.AQPB002sbo
                                           and a.sctope = i.AQPB002top;

                                        update fsd011 a
                                           set a.scfvto = ld_fvto11, a.scpzo = ln_pzo11
                                         where a.pgcod = i.AQPB002emp
                                           and a.scmod = i.AQPB002mod
                                           and a.scsuc = i.AQPB002suc
                                           and a.scmda = i.AQPB002mda
                                           and a.scpap = i.AQPB002pap
                                           and a.sccta = i.AQPB002cta
                                           and a.scoper = i.AQPB002ope
                                           and a.scsbop = i.AQPB002sbo
                                           and a.sctope = i.AQPB002top;

                                        --Actualiza si se revertio FSD011
                                        UPDATE AQPB002 a
                                           set a.AQPB002r011 = 'S'
                                         where a.AQPB002emp = i.AQPB002emp
                                           and a.AQPB002mod = i.AQPB002mod
                                           and a.AQPB002suc = i.AQPB002suc
                                           and a.AQPB002mda = i.AQPB002mda
                                           and a.AQPB002pap = i.AQPB002pap
                                           and a.AQPB002cta = i.AQPB002cta
                                           and a.AQPB002ope = i.AQPB002ope
                                           and a.AQPB002sbo = i.AQPB002sbo
                                           and a.AQPB002top = i.AQPB002top
                                           and a.AQPB002grp = i.AQPB002grp
                                           and a.AQPB002fep = i.AQPB002fep
                                           and a.aqpb002cor = i.aqpb002cor;

                                        --Actualiza estado, fecha y usario que hizo la reversion

                                       begin -- agregado 11.10.21 - BBA
                                            select to_char(sysdate, 'HH24:MI:SS')
                                              into lc_HoraExtorno
                                              from dual;
                                       end;

                                       begin -- agregado 11.10.21 - BBA
                                           select UBUSER, UBSUC
                                           into lc_usuarExtorno, ln_sucurExtorno
                                           from FST046
                                           where UBUSER = pc_usr;
                                        end;

                                        update AQPB002 a
                                           set a.AQPB002revr = 'S',
                                               a.AQPB002feca = pd_fec,
                                               a.AQPB002HEXT = lc_HoraExtorno, -- agregado 11.10.21 - BBA
                                               a.AQPB002usrr = lc_usuarExtorno, -- agregado 11.10.21 - BBA
                                               a.AQPB002SUEXT = ln_sucurExtorno -- agregado 11.10.21 - BBA

                                         where a.AQPB002emp = i.AQPB002emp
                                           and a.AQPB002mod = i.AQPB002mod
                                           and a.AQPB002suc = i.AQPB002suc
                                           and a.AQPB002mda = i.AQPB002mda
                                           and a.AQPB002pap = i.AQPB002pap
                                           and a.AQPB002cta = i.AQPB002cta
                                           and a.AQPB002ope = i.AQPB002ope
                                           and a.AQPB002sbo = i.AQPB002sbo
                                           and a.AQPB002top = i.AQPB002top
                                           and a.AQPB002grp = i.AQPB002grp
                                           and a.AQPB002fep = i.AQPB002fep
                                           and a.aqpb002cor = i.aqpb002cor;

                                        update AQPB001 a
                                           set a.AQPB001EST = 'E' --, AQPB001fecext = pd_fec
                                         where a.AQPB001hpgcod = i.AQPB002emp
                                           and a.AQPB001hmodul = i.AQPB002mod
                                           and a.AQPB001hsucur = i.AQPB002suc
                                           and a.AQPB001hmda = i.AQPB002mda
                                           and a.AQPB001hpap = i.AQPB002pap
                                           and a.AQPB001hcta = i.AQPB002cta
                                           and a.AQPB001hoper = i.AQPB002ope
                                           and a.AQPB001hsubop = i.AQPB002sbo
                                           and a.AQPB001htoper = i.AQPB002top
                                           and a.aqpb001fecha = i.aqpb002fep
                                           and a.aqpb001cor = i.aqpb002cor;

                                        update AQPB001A a
                                           set a.AQPB001AEST = 'E'
                                         where a.AQPB001APGCOD = i.AQPB002emp
                                           and a.AQPB001APPMOD = i.AQPB002mod
                                           and a.AQPB001APPSUC = i.AQPB002suc
                                           and a.AQPB001APPMDA = i.AQPB002mda
                                           and a.AQPB001APPPAP = i.AQPB002pap
                                           and a.AQPB001APPCTA = i.AQPB002cta
                                           and a.AQPB001APPOPER = i.AQPB002ope
                                           and a.AQPB001APPSBOP = i.AQPB002sbo
                                           and a.AQPB001APPTOPE = i.AQPB002top
                                           and a.aqpb001Afecha = i.aqpb002fep
                                           and a.aqpb001Acor = i.aqpb002cor;

                                        --fpp003
                                        --mpostigoc 15.05.2020
                                        --chernandez 10/07/2020
                                        pq_cr_repro_masivo.sp_cr_up_fsd012(ln_pgcod => i.AQPB002emp,
                                                                           ln_mod   => i.AQPB002mod,
                                                                           ln_suc   => i.AQPB002suc,
                                                                           ln_mda   => i.AQPB002mda,
                                                                           ln_pap   => i.AQPB002pap,
                                                                           ln_cta   => i.AQPB002cta,
                                                                           ln_ope   => i.AQPB002ope,
                                                                           ln_sbo   => i.AQPB002sbo,
                                                                           ln_tpo   => i.AQPB002top,
                                                                           ld_fec   => i.AQPB002fem,
                                                                           ld_fecre => i.AQPB002fep);
                                      end if;
                                end if;
                        end if;
                end If;
        end loop;
        commit;
      exception
        when others then
          rollback;
          null;
      End;

    End if;
  end Sp_extorno_cuenta;
  ---------------------------------------------------------------------
  -- mpostigoc 14052020 verifica si el credito tiene algun evento de cambio de tasa posterior al que tenia en tabla jaqa250
  procedure sp_cr_VerfEvento3(ln_pgcod     in number,
                              ln_mod       in number,
                              ln_suc       in number,
                              ln_mda       in number,
                              ln_pap       in number,
                              ln_cta       in number,
                              ln_ope       in number,
                              ln_sbo       in number,
                              ln_tpo       in number,
                              lc_FlagEvnt3 out varchar2) is

    cursor listado is
      select j.jaqa250fre,
             j.jaqa250emp,
             j.jaqa250mod,
             j.jaqa250suc,
             j.jaqa250mda,
             j.jaqa250pap,
             j.jaqa250cta,
             j.jaqa250ope,
             j.jaqa250sbo,
             j.jaqa250tpo
        from jaqa250 j
       where j.jaqa250emp = ln_pgcod
         and j.jaqa250mod = ln_mod
         and j.jaqa250suc = ln_suc
         and j.jaqa250mda = ln_mda
         and j.jaqa250pap = ln_pap
         and j.jaqa250cta = ln_cta
         and j.jaqa250ope = ln_ope
         and j.jaqa250sbo = ln_sbo
         and j.jaqa250tpo = ln_tpo
            --and j.jaqa250fpg >= (select min(a.aqpb002fep) from aqpb002 a)--chernandez 11/07/2020
         and j.jaqa250est = 'S';

    ln_corr    number;
    ln_corrNew number;
    ln_NroReg  number := 0;

  BEGIN

    ln_corr      := 0;
    ln_corrNew   := 0;
    lc_FlagEvnt3 := 'N';

    for i in listado loop
      begin
        -- primero verificamos si existe algun registro de cambio de tasa parala fecha de la reprogramacion
        begin
          select count(*)
            into ln_NroReg
            from fsd012 f
           where f.pgcod = i.jaqa250emp
             and f.aomod = i.jaqa250mod
             and f.aosuc = i.jaqa250suc
             and f.aomda = i.jaqa250mda
             and f.aopap = i.jaqa250pap
             and f.aocta = i.jaqa250cta
             and f.aooper = i.jaqa250ope
             and f.aosbop = i.jaqa250sbo
             and f.aotope = i.jaqa250tpo
             and f.evtipo = 3
             and f.evfval >= i.jaqa250fre
             and f.d012co = 'S';
        end;

        if ln_NroReg > 0 then
          --aqui hay q verificar que no haya otro correlativo posterior.
          begin
            select max(f.evcorr)
              into ln_corr
              from fsd012 f
             where f.pgcod = i.jaqa250emp
               and f.aomod = i.jaqa250mod
               and f.aosuc = i.jaqa250suc
               and f.aomda = i.jaqa250mda
               and f.aopap = i.jaqa250pap
               and f.aocta = i.jaqa250cta
               and f.aooper = i.jaqa250ope
               and f.aosbop = i.jaqa250sbo
               and f.aotope = i.jaqa250tpo
               and f.evtipo = 3
               and f.evfval = i.jaqa250fre
               and f.d012co = 'S';
          exception
            when others then
              ln_corr := 0;
          end;

          ln_corr := nvl(ln_corr, 0);

          begin
            select max(f.evcorr)
              into ln_corrNew
              from fsd012 f
             where f.pgcod = i.jaqa250emp
               and f.aomod = i.jaqa250mod
               and f.aosuc = i.jaqa250suc
               and f.aomda = i.jaqa250mda
               and f.aopap = i.jaqa250pap
               and f.aocta = i.jaqa250cta
               and f.aooper = i.jaqa250ope
               and f.aosbop = i.jaqa250sbo
               and f.aotope = i.jaqa250tpo
               and f.evtipo = 3
               and f.d012co = 'S';
          exception
            when others then
              ln_corrNew := 0;
          end;

          if ln_corrNew > ln_corr then
            lc_FlagEvnt3 := 'S';
          end if;

        else
          lc_FlagEvnt3 := 'N';
        end if;
      end;

    end loop;

  end sp_cr_VerfEvento3;
  ---------------------------------------------------------------------
  -- mpostigoc actualiza la fsd012 para el evento 3
  procedure sp_cr_up_fsd012(ln_pgcod in number,
                            ln_mod   in number,
                            ln_suc   in number,
                            ln_mda   in number,
                            ln_pap   in number,
                            ln_cta   in number,
                            ln_ope   in number,
                            ln_sbo   in number,
                            ln_tpo   in number,
                            ld_fec   in date,
                            ld_fecre in date) is
    /*
      cursor listado is
        select j.jaqa250fre,
               j.jaqa250emp,
               j.jaqa250mod,
               j.jaqa250suc,
               j.jaqa250mda,
               j.jaqa250pap,
               j.jaqa250cta,
               j.jaqa250ope,
               j.jaqa250sbo,
               j.jaqa250tpo
          from jaqa250 j
         where j.jaqa250emp = ln_pgcod
           and j.jaqa250mod = ln_mod
           and j.jaqa250suc = ln_suc
           and j.jaqa250mda = ln_mda
           and j.jaqa250pap = ln_pap
           and j.jaqa250cta = ln_cta
           and j.jaqa250ope = ln_ope
           and j.jaqa250sbo = ln_sbo
           and j.jaqa250tpo = ln_tpo
              --and j.jaqa250fpg >= (select min(a.aqpb002fep) from aqpb002 a)--chernandez 10/07/2020
           and j.jaqa250est = 'S';
    */
    cursor creditos_jaqa257 is
      select *
        from jaqa257 a
       where a.jaqa257emp = ln_pgcod
         and a.jaqa257mod = ln_mod
         and a.jaqa257suc = ln_suc
         and a.jaqa257mda = ln_mda
         and a.jaqa257pap = ln_pap
         and a.jaqa257cta = ln_cta
         and a.jaqa257ope = ln_ope
         and a.jaqa257sbo = ln_sbo
         and a.jaqa257tpo = ln_tpo
         and a.jaqa257est = 'S'
       order by jaqa257fec desc;

    ld_fecCtasa    date;
    ld_AQPA380FVAL date;
    ln_aqpa380corr number(10);
  BEGIN

    --chernandez 10/07/2020
    --verificar jaqa257
    for ff in creditos_jaqa257 loop
      if ff.jaqa257fec >= ld_fecre then
        begin
          select /*AQPA380FVAL,*/ max(aqpa380corr)
            into /*ld_AQPA380FVAL,*/ ln_aqpa380corr
            from aqpa380 a
           inner join fsd012 b
              on aqpa380cod = pgcod
             and aqpa380mod = aomod
             and aqpa380suc = aosuc
             and aqpa380mda = aomda
             and aqpa380pap = aopap
             and aqpa380cta = aocta
             and aqpa380oper = aooper
             and aqpa380sbop = aosbop
             and aqpa380tope = aotope
             and aqpa380tipo = evtipo
             and aqpa380corr = evcorr
           where aqpa380cod = ln_pgcod
             and aqpa380mod = ln_mod
             and aqpa380suc = ln_suc
             and aqpa380mda = ln_mda
             and aqpa380pap = ln_pap
             and aqpa380cta = ln_cta
             and aqpa380oper = ln_ope
             and aqpa380sbop = ln_sbo
             and aqpa380tope = ln_tpo
             and aqpa380tipo = 3
             and aqpa380est = 'H';
          --and d012co = 'S'
        exception
          when others then
            ld_AQPA380FVAL := ff.jaqa257fre;
            ln_aqpa380corr := 1;
        end;
        update fsd012
           set d012co = 'E'
         where pgcod = ln_pgcod
           and aomod = ln_mod
           and aosuc = ln_suc
           and aomda = ln_mda
           and aopap = ln_pap
           and aocta = ln_cta
           and aooper = ln_ope
           and aosbop = ln_sbo
           and aotope = ln_tpo
           and evtipo = 3
           --and evfval > ld_AQPA380FVAL
           and evcorr > ln_aqpa380corr;
        update aqpa380
           set aqpa380est = 'I'
         where aqpa380cod = ln_pgcod
           and aqpa380mod = ln_mod
           and aqpa380suc = ln_suc
           and aqpa380mda = ln_mda
           and aqpa380pap = ln_pap
           and aqpa380cta = ln_cta
           and aqpa380oper = ln_ope
           and aqpa380sbop = ln_sbo
           and aqpa380tope = ln_tpo;
        update jaqa257
           set jaqa257Est = 'X'
         where jaqa257emp = ln_pgcod
           and jaqa257mod = ln_mod
           and jaqa257suc = ln_suc
           and jaqa257mda = ln_mda
           and jaqa257pap = ln_pap
           and jaqa257cta = ln_cta
           and jaqa257ope = ln_ope
           and jaqa257sbo = ln_sbo
           and jaqa257tpo = ln_tpo
           and jaqa257fec = ff.jaqa257fec;

      end if;
    end loop;

    begin
      select a.jaqa250fre
        into ld_fecCtasa
        from jaqa250 a
       where a.jaqa250EMP = ln_pgcod
         and a.jaqa250MOD = ln_mod
         and a.jaqa250SUC = ln_suc
         and a.jaqa250MDA = ln_mda
         and a.jaqa250PAP = ln_pap
         and a.jaqa250CTA = ln_cta
         and a.jaqa250OPE = ln_ope
         and a.jaqa250SBO = ln_sbo
         and a.jaqa250TPO = ln_tpo
         and a.jaqa250fpg = ld_fec
         and a.jaqa250est = 'S';

      --select a.pptipo
      --delete from fsd012 a
      update fsd012 a
         set d012co = 'E'
       where a.pgcod = ln_pgcod
         and a.aomod = ln_mod
         and a.aosuc = ln_suc
         and a.aomda = ln_mda
         and a.aopap = ln_pap
         and a.aocta = ln_cta
         and a.aooper = ln_ope
         and a.aosbop = ln_sbo
         and a.aotope = ln_tpo
         and a.evfval = ld_fecCtasa
         and a.evtipo = 3;

      update jaqa250 z
         set z.jaqa250est = 'X'
       where z.jaqa250emp = ln_pgcod
         and z.jaqa250mod = ln_mod
         and z.jaqa250suc = ln_suc
         and z.jaqa250mda = ln_mda
         and z.jaqa250pap = ln_pap
         and z.jaqa250cta = ln_cta
         and z.jaqa250ope = ln_ope
         and z.jaqa250sbo = ln_sbo
         and z.jaqa250tpo = ln_tpo
         and z.jaqa250fpg = ld_fec
         and z.jaqa250fre = ld_fecCtasa;

    exception
      when others then
        null;
    end;

    /*for i in listado loop
      begin
        --aqui hay q verificar que no haya otro correlativo posterior.
        select max(f.evcorr)
          into ln_corr
          from fsd012 f
         where f.pgcod = i.jaqa250emp
           and f.aomod = i.jaqa250mod
           and f.aosuc = i.jaqa250suc
           and f.aomda = i.jaqa250mda
           and f.aopap = i.jaqa250pap
           and f.aocta = i.jaqa250cta
           and f.aooper = i.jaqa250ope
           and f.aosbop = i.jaqa250sbo
           and f.aotope = i.jaqa250tpo
           and f.evtipo = 3
           and f.evfval = i.jaqa250fre
           and f.d012co = 'S';
      exception
        when others then
          ln_corr := 0;
      end;

      if ln_corr <> 0 then
        DELETE FROM FSD012 f
         where f.pgcod = ln_pgcod
           and f.aomod = ln_mod
           and f.aosuc = ln_suc
           and f.aomda = ln_mda
           and f.aopap = ln_pap
           and f.aocta = ln_cta
           and f.aooper = ln_ope
           and f.aosbop = ln_sbo
           and f.aotope = ln_tpo
           and f.evtipo = 3
           and f.evfval = i.jaqa250fre
           and f.evcorr = ln_corr;

        -- mpostigoc 25.06.2020
        update jaqa250 z
           set z.jaqa250est = 'X'
         where z.jaqa250emp = i.jaqa250emp
           and z.jaqa250mod = i.jaqa250mod
           and z.jaqa250suc = i.jaqa250suc
           and z.jaqa250mda = i.jaqa250mda
           and z.jaqa250pap = i.jaqa250pap
           and z.jaqa250cta = i.jaqa250cta
           and z.jaqa250ope = i.jaqa250ope
           and z.jaqa250sbo = i.jaqa250sbo
           and z.jaqa250tpo = i.jaqa250tpo
           and z.jaqa250fre = i.jaqa250fre;
        commit;
      end if;

    end loop;*/

  end sp_cr_up_fsd012;
  ---------------------------------------------------------------------
  /*procedure sp_cr_bk_fsd012(pn_emp in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,
                            pn_top in number) is
    cursor reg_fsd012 is
      select *
        from fsd012 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top;

    ld_fchsist date;
    lc_hora    char(8) := '00:00:00';
    ln_corre   number := 0;

  begin

    begin
      select f.pgfape into ld_fchsist from fst017 f where f.pgcod = 1;
    end;
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;

    for f in reg_fsd012 loop

      begin
        select max(a.aqpa379corre)
          into ln_corre
          from aqpa379 a
         where a.aqpa379fech = ld_fchsist;
      end;

      ln_corre := nvl(ln_corre, 0);

      begin
        insert into aqpa379
          (aqpa379corre,
           aqpa379fech,
           aqpa379hora,
           aqpa379cod,
           aqpa379mod,
           aqpa379suc,
           aqpa379mda,
           aqpa379pap,
           aqpa379cta,
           aqpa379oper,
           aqpa379sbop,
           aqpa379tope,
           aqpa379corr,
           aqpa379tipo,
           aqpa379fval,
           aqpa379fvto,
           aqpa379imp,
           aqpa379ttas,
           aqpa379tasa,
           aqpa379cap,
           aqpa379int,
           aqpa379mor,
           aqpa379scap,
           aqpa379sint,
           aqpa379smor,
           aqpa379intc,
           aqpa379morc,
           aqpa379cd01,
           aqpa379cd02,
           aqpa379inv,
           aqpa379per,
           aqpa379tcbi,
           aqpa379tcbi1,
           aqpa379arb,
           aqpa379arb1,
           aqpa379md,
           aqpa379md1,
           aqpa379pre,
           aqpa379pre1,
           aqpa37912cd,
           aqpa37912mo,
           aqpa37912su,
           aqpa37912tr,
           aqpa37912re,
           aqpa37912fc,
           aqpa37912or,
           aqpa37912sb,
           aqpa37912co)
        values
          (ln_corre + 1,
           ld_fchsist,
           lc_hora,
           f.pgcod,
           f.aomod,
           f.aosuc,
           f.aomda,
           f.aopap,
           f.aocta,
           f.aooper,
           f.aosbop,
           f.aotope,
           f.evcorr,
           f.evtipo,
           f.evfval,
           f.evfvto,
           f.evimp,
           f.evttas,
           f.evtasa,
           f.evcap,
           f.evint,
           f.evmor,
           f.evscap,
           f.evsint,
           f.evsmor,
           f.evintc,
           f.evmorc,
           f.evcd01,
           f.evcd02,
           f.evinv,
           f.evper,
           f.evtcbi,
           f.evtcbi1,
           f.evarb,
           f.evarb1,
           f.evmd,
           f.evmd1,
           f.evpre,
           f.evpre1,
           f.d012cd,
           f.d012mo,
           f.d012su,
           f.d012tr,
           f.d012re,
           f.d012fc,
           f.d012or,
           f.d012sb,
           f.d012co);
        commit;

      end;

    end loop;
  end sp_cr_bk_fsd012;*/
  ---------------------------------------------------------------------
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
                          pd_fec in date,
                          pn_cor in number) is

    -- MODIFCADO : DCASTRO 2017.05.17 Se detallo campos a insertar en JAQZ525_519

  begin
    insert into jaqz525_010
      select a.*, pd_fec, pn_cor, pn_gru
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
      select a.*, pd_fec, pn_cor, pn_gru
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
      select a.*, pd_fec, pn_cor, pn_gru
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
      select a.*, pd_fec, pn_cor, pn_gru
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
      select a.*, pd_fec, pn_cor, pn_gru
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
      select a.*, pd_fec, pn_cor, pn_gru
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

    insert into jaqz525_003
      select a.*, pd_fec, pn_cor, pn_gru
        from fpp003 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;

    /*chernandez 10/07/2020*/
    insert into jaqz525_002
      select a.*, pd_fec, pn_cor, pn_gru
        from fpp002 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;

    insert into jaqz525_012
      select a.*, pd_fec, pn_cor, pn_gru
        from fsd012 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;

    insert into jaqz525_001
      select a.*, pd_fec, pn_cor, pn_gru
        from fpp001 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    commit;

  end Sp_backup_ext;

  Procedure Sp_valida_pagos(p_n_emp in number,
                            p_n_mod in number,
                            p_n_suc in number,
                            p_n_mda in number,
                            p_n_pap in number,
                            p_n_cta in number,
                            p_n_ope in number,
                            p_n_sbo in number,
                            p_n_top in number,
                            pn_ind  out number) is

    contPagos number(5);
    ln_602Ant number(5);

  begin

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
     order by ppfpag;

    select count(*)
      into ln_602Ant
      from JAQZ520_602 a
     where a.pgcod = p_n_emp
       and a.ppmod = p_n_mod
       and a.ppsuc = p_n_suc
       and a.ppmda = p_n_mda
       and a.pppap = p_n_pap
       and a.ppcta = p_n_cta
       and a.ppoper = p_n_ope
       and a.ppsbop = p_n_sbo
       and a.pptope = p_n_top
       and a.d602co = 'S';

    --tiene pagos posteriores y esta en mora
    if contPagos <> ln_602Ant then
      pn_ind := 1;
    end if;
  end sp_valida_pagos;

  Procedure Sp_actualiza_bk(pn_emp      in number,
                            pn_mod      in number,
                            pn_suc      in number,
                            pn_mda      in number,
                            pn_pap      in number,
                            pn_cta      in number,
                            pn_ope      in number,
                            pn_sbo      in number,
                            pn_top      in number,
                            pn_gru      in number,
                            pd_fec      in date,
                            pn_cor      in number,
                            pv_correo   in varchar2,
                            pv_telefono in varchar2) is
  begin
    update AQPB002 a
       set AQPB002ECORREO = pv_correo, AQPB002ETELEFO = pv_telefono
     where a.AQPB002emp = pn_emp
       and a.AQPB002mod = pn_mod
       and a.AQPB002suc = pn_suc
       and a.AQPB002mda = pn_mda
       and a.AQPB002pap = pn_pap
       and a.AQPB002cta = pn_cta
       and a.AQPB002ope = pn_ope
       and a.AQPB002sbo = pn_sbo
       and a.AQPB002top = pn_top
       and a.AQPB002grp = pn_gru
       and a.AQPB002fep = pd_fec
       and a.aqpb002cor = pn_cor;
    commit;
  end Sp_actualiza_bk;

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

  -- -- -- -- -- -- -- -- -- -- -- --  -- -- -- -- -- -- -- -- -- -- -- --


end PQ_CR_REPRO_MASIVO;
/

