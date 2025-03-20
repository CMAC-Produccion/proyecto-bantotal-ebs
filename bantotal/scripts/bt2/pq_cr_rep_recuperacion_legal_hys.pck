create or replace package PQ_CR_REP_RECUPERACION_LEGAL_HYS is
  -- Author  : EFUENTES
  -- Created : 28/06/2022 10:00:00
  -- Purpose : PAQUETE PARA LA REGULARIZACIÓN DE TRANSACCIONES FALTANTES EN jaqy711 - AMORTIZACIONES
  --------------------------------------------------------------------------------------------------
  -- Modificación  : KVALENCIAC
  -- Created : 14/08/2023
  -- Purpose : Se adicionó el proceoso de obtención de clave para adicionar de la FSH016
  ------------------------------------------------------------------------
--  Procedure sp_cr_cred_amort_CV(pn_suc IN number, pd_fecproc IN date, pd_fecha1 in date, pd_fecha2 in date);
  Procedure sp_cr_cred_amort_CV(pd_fecproc IN date, pd_fecha1 in date, pd_fecha2 in date);

  ------------------------------------------------------------------------
  Procedure sp_cr_verificar_exist(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,

                                  pn_fpag  in date,
                                  pn_tsuc  in number,
                                  pn_tmod  in number,
                                  pn_ttran in number,
                                  pn_nrel  in number,
                                  pv_flg   out varchar2);
  ------------------------------------------------------------------------
  Procedure sp_cr_montos_amort(pn_ITSUC in number,
                               pn_ITMOD  in number,
                               pn_ITTRAN in  number,
                               pn_ITNREL in number,
                               pn_FCON in date, 
                               pn_capital in out number,
                               pn_interes   in out number,
                               pn_int_comp_extra in out number,
                               pn_mora   in out number,
                               pn_seguros  in out number,
                               pn_rub_obli  in out number,
                               pn_gastos  in out number,
                               pn_ITF  in out number);
                               
  --------------------------------------------------------------------
  Procedure sp_cr_obtiene_pk(pt_pgcod in number,
                             pt_modt in number,
                             pt_tran in number,
                             pt_suct in number,
                             pt_rel in number,
                             pt_suc out number,
                             pt_mod out number,
                             pt_moneda out number,
                             pt_papel  out number ,
                             pt_cnta in out number,
                             pt_operac in out number,
                             pt_sboper out number,
                             pt_toper out number,
                             pt_fecpag in date);   
                                                         
end PQ_CR_REP_RECUPERACION_LEGAL_HYS;
/

create or replace package body PQ_CR_REP_RECUPERACION_LEGAL_HYS is
  ------------------------------------------------------------------------
--  Procedure sp_cr_cred_amort_CV(pn_suc IN number, pd_fecproc IN date, pd_fecha1 in date, pd_fecha2 in date) is
  Procedure sp_cr_cred_amort_CV(pd_fecproc IN date, pd_fecha1 in date, pd_fecha2 in date) is
    cursor c_cart_cred_act is    
      select distinct h.pgcod, h.hmda, h.hpap, h.hcta, h.hoper, h.hcmod, h.htran, h.hsucor, h.hnrel, h.hfcon
      from fsh016 h
      inner join fst198 g 
              on h.hcmod = g.tp1corr1 and h.htran = g.tp1corr2 and h.hcord = g.tp1imp1
             and g.tp1cod = 1 and g.tp1cod1 = 10876 and g.tp1corr1 <> 999999 
      inner join fsh015 f
              on f.pgcod = h.pgcod
             and f.hsucor = h.hsucor
             and f.hcmod = h.hcmod
             and f.htran = h.htran
             and f.hnrel = h.hnrel
             and f.hfcon = h.hfcon
             /*and f.hsucor = pn_suc
             and f.hsucor = 2
             and f.hcmod = 30
             and f.htran = 395
             and f.hnrel = 1
             and f.hfcon = '02/05/2022'*/
      where f.hccorr = 0
        and f.hfcon between pd_fecha1 and pd_fecha2;
         
      /*select distinct h.pgcod, h.moneda, h.papel, h.ctnro, h.itoper, h.itmod, h.ittran, h.itsuc, h.itnrel
        from fsd016 h
       inner join fst198 g
          on h.itmod = g.tp1corr1 and h.ittran = g.tp1corr2 and h.itord = g.tp1imp1
         and g.tp1cod = 1 and g.tp1cod1 = 10876 and g.tp1corr1 <> 999999
       inner join fsd015 f
          on f.pgcod = h.pgcod and f.itsuc = h.itsuc and f.itmod = h.itmod
         and f.ittran = h.ittran and f.itnrel = h.itnrel and f.itsuc = pn_suc
       where f.itcont = 'S'
         and f.itcorr = 0;*/
  
    cursor transaccion(p_pgcod  in number, p_itmod  in number, p_ittran in number, p_itsuc  in number, p_itnrel in number, p_fcon in date) is
      select f_pag, hcmod, htran, hsucor, hnrel,
      sum(decode(tp1nro1,1,(monto/cont) ,0 ))  capital,
      sum(decode(tp1nro1,2,(monto/cont),0 )) interes,
      sum(decode(tp1nro3,1,decode(tp1nro1,3,(monto/cont),0 ),4,decode(tp1nro1,3,(monto4/cont),0 ),12)) int_comp_extra,
      sum(decode(tp1nro3,1,decode(tp1nro1,4,(monto/cont),0),4,decode(tp1nro1,4,(monto4/cont),0),12)) mora,
      sum(decode(tp1nro1,5,(monto/cont),0 )) seguros,
      sum(decode(tp1nro1,6,(monto/cont),0 )) rub_obli,
      sum(decode(tp1nro1,7,(monto/cont),0 )) gastos
      from
      (select g.tp1nro1, h.hcmod, g.tp1nro3, h.htran, h.hsucor, h.hnrel, f.hfcon as f_pag,
              sum(h.hcimp1) monto, sum(h.hcimp4) monto4,count(*) cont
      from fsh016 h
      inner join fst198 g 
              on h.hcmod = g.tp1corr1 and h.htran = g.tp1corr2 and h.hcord = g.tp1imp1
             and g.tp1cod = 1 and g.tp1cod1 = 10876 and g.tp1corr1 <> 999999
      inner join fsh015 f
              on f.pgcod = h.pgcod and f.hsucor = h.hsucor and f.hcmod = h.hcmod
             and f.htran = h.htran and f.hnrel = h.hnrel and f.hfcon = h.hfcon
      where f.pgcod = p_pgcod
        and f.hcmod = p_itmod
        and f.htran = p_ittran
        and f.hsucor = p_itsuc
        and f.hnrel = p_itnrel
        and f.hfcon = p_fcon
        --and f.itcont = 'S'
        and f.hccorr = 0
      group by g.tp1nro1, h.hcmod, h.htran, h.hsucor, h.hnrel, f.hfcon, f.hfvc, g.tp1nro3)
      group by f_pag, hcmod, htran, hsucor, hnrel;
        
        /*
        select f_pag,itmod,ittran,itsuc,itnrel,
        sum(decode(tp1nro1,1,(monto/cont) ,0 ))  capital,
        sum(decode(tp1nro1,2,(monto/cont),0 )) interes,
        sum(decode(tp1nro3,1,decode(tp1nro1,3,(monto/cont),0 ),4,decode(tp1nro1,3,(monto4/cont),0 ),12,decode(tp1nro1,3,(monto12/cont),0 ))) int_comp_extra, -- 062017 -- sum(decode(tp1nro1,3,(monto/cont),0 )) int_comp_extra,--ICV        
        sum(decode(tp1nro3,1,decode(tp1nro1,4,(monto/cont),0),4,decode(tp1nro1,4,(monto4/cont),0),12,decode(tp1nro1,4,(monto12/cont),0 ))) mora,   --062017 -- sum(decode(tp1nro1,4,(monto/cont),0 )) mora,
        sum(decode(tp1nro1,5,(monto/cont),0 )) seguros,
        sum(decode(tp1nro1,6,(monto/cont),0 )) rub_obli,
        sum(decode(tp1nro1,7,(monto/cont),0 )) gastos
        from
        (select g.tp1nro1,h.itmod,g.tp1nro3,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,-- 062017 (select g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto, sum(h.itimp4) monto4, sum(h.itimp12) monto12,count(*) cont --062017 se adiciono suma de impuestos --sum(h.itimp1) monto,count(*) cont
        from
        fsd016 h
        inner join fst198 g
        on  h.itmod=g.tp1corr1
        and h.ittran=g.tp1corr2
         and h.itord=g.tp1imp1 --  062017--and h.itord=g.tp1corr3
        and g.tp1cod=1
        and g.tp1cod1=10876
        and g.tp1corr1<>999999
        inner join fsd015 f
        on  f.pgcod=h.pgcod
        and f.itsuc=h.itsuc
        and f.itmod=h.itmod
        and f.ittran=h.ittran
        and f.itnrel=h.itnrel

        where f.pgcod=p_pgcod
        and f.itmod=p_itmod
        and f.ittran=p_ittran
        and f.itsuc=p_itsuc
        and f.itnrel=p_itnrel

        and f.itcont='S'
        and f.itcorr=0
        group by g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1nro3  )--062017 --group by g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc)
        group by f_pag,itmod,ittran,itsuc,itnrel;
        */
  
    ld_fecasig    date;
    ld_fdemand    date;
    lc_abrev      varchar2(5);
    ln_capingreso number(17, 2);
    lc_desctran   varchar2(30);
    ln_corr       number(18);
    ln_pais       number(3); --pais
    ln_tdoc       number(2); --tipo doc
    lc_ndoc       varchar2(12); --nro doc
  
    lc_nomtit fsd001.penom%type; --nombre titular
    lc_dirtit sngc13.sngc13dir%type; --direccion titular
    lc_reftit sngc13.sngc13ref1%type; --referencia titular
    lc_distit fst071.fst071dsc%type; --ditrito titular
  
    lc_coderr         varchar2(500);
    lc_msgerr         varchar2(500);
    lc_descsuc        varchar2(30);
    pl_pgcod          fsd601.pgcod%type;
    pl_scsuc          fsd601.ppsuc%type;
    pl_scmod          fsd601.ppmod%type;
    pl_scmda          fsd601.ppmda%type;
    pl_scpap          fsd601.pppap%type;
    pl_sccta          fsd601.ppcta%type;
    pl_scoper         fsd601.ppoper%type;
    pl_scsbop         fsd601.ppsbop%type;
    pl_sctope         fsd601.pptope%type;
    fpag              date;
    ln_capital        number(17, 2);
    ln_interes        number(17, 2);
    ln_int_comp_extra number(17, 2);
    ln_mora           number(17, 2);
    ln_rub_obli       number(17, 2);
    ln_gastos         number(17, 2);
    ln_seguros        number(17, 2);
  
    ITF         number(17, 2);
    ln_stat     number(2, 0);
    ln_dat      number(4, 0);
    pf_pasajud  date;
    pf_trancart date;
    ln_valido   number(5, 0);
    pn_flgexist varchar2(1);
  begin
  
    FOR c in c_cart_cred_act LOOP
      for y in transaccion(c.pgcod, c.hcmod, c.htran, c.hsucor, c.hnrel, c.hfcon) loop
        
        pl_scsuc  := null;
        pl_scmod  := null;
        pl_scmda  := null;
        pl_scpap  := null;
        pl_sccta  := c.hcta;
        pl_scoper := c.hoper;
        pl_scsbop := null;
        pl_sctope := null;
      
        pl_sccta  := c.hcta;
        pl_scoper := c.hoper;
      
        PQ_CR_REP_RECUPERACION_LEGAL_HYS.sp_cr_obtiene_pk(pt_pgcod  => c.pgcod, --in
                                                      pt_modt   => c.hcmod, --in
                                                      pt_tran   => c.htran, --in
                                                      pt_suct   => c.hsucor, --in
                                                      pt_rel    => c.hnrel, --in
                                                      pt_suc    => pl_scsuc, --out
                                                      pt_mod    => pl_scmod, --out
                                                      pt_moneda => pl_scmda, --out
                                                      pt_papel  => pl_scpap, --out
                                                      pt_cnta   => pl_sccta, --in out
                                                      pt_operac => pl_scoper, --in out
                                                      pt_sboper => pl_scsbop, --out
                                                      pt_toper  => pl_sctope, --out
                                                      pt_fecpag => y.f_pag); --in
                                                      
        PQ_CR_REP_RECUPERACION_LEGAL_HYS.sp_cr_verificar_exist(pn_cod   => c.pgcod,   --in
                                                               pn_mod   => pl_scmod,  --in
                                                               pn_suc   => pl_scsuc,  --in
                                                               pn_mda   => pl_scmda,  --in
                                                               pn_pap   => pl_scpap,  --in
                                                               pn_cta   => pl_sccta,  --in
                                                               pn_ope   => pl_scoper, --in
                                                               pn_sbo   => pl_scsbop, --in
                                                               pn_top   => pl_sctope, --in
 
                                                               pn_fpag  => c.hfcon,  --in
                                                               pn_tsuc  => c.hsucor, --in
                                                               pn_tmod  => c.hcmod,  --in
                                                               pn_ttran => c.htran,  --in
                                                               pn_nrel  => c.hnrel,  --in
                                                               pv_flg   => pn_flgexist); --our
                                                               
        fpag := y.f_pag;
        
        if pn_flgexist = 'N' then
          pq_cr_rep_recuperacion_legal.sp_cr_mod_est_act(pt_fecpag  => fpag, --in out
                                                         pt_pgcod   => c.pgcod, --in
                                                         pt_suc     => pl_scsuc, --in
                                                         pt_mod     => pl_scmod, --in
                                                         pt_moneda  => pl_scmda, --in
                                                         pt_papel   => pl_scpap, --in
                                                         pt_cnta    => pl_sccta, --in
                                                         pt_operac  => pl_scoper, --in
                                                         pt_sboper  => pl_scsbop, --in
                                                         pt_toper   => pl_sctope, --in
                                                         estado     => ln_stat, --out
                                                         pt_datraso => ln_dat, --out
                                                         pn_ITSUC   => y.hsucor, --in
                                                         pn_ITMOD   => y.hcmod, --in
                                                         pn_ITTRAN  => y.htran, --in
                                                         pn_ITNREL  => y.hnrel); --in
        
          ln_valido := pq_cr_rep_recuperacion_legal.fn_pago_valido(pt_pgcod  => c.pgcod,
                                                                   pt_suc    => pl_scsuc,
                                                                   pt_mod    => pl_scmod,
                                                                   pt_moneda => pl_scmda,
                                                                   pt_papel  => pl_scpap,
                                                                   pt_cnta   => pl_sccta,
                                                                   pt_operac => pl_scoper,
                                                                   pt_sboper => pl_scsbop,
                                                                   pt_toper  => pl_sctope,
                                                                   pn_itsuc  => y.hsucor,
                                                                   pn_itmod  => y.hcmod,
                                                                   pn_ittran => y.htran,
                                                                   pn_itnrel => y.hnrel,
                                                                   pn_stat   => ln_stat);
      
          IF (ln_valido = 1) then
            ln_capital        := y.capital;
            ln_interes        := y.interes;
            ln_int_comp_extra := y.int_comp_extra;
            ln_mora           := y.mora;
            ln_rub_obli       := y.rub_obli;
            ln_gastos         := y.gastos;
            ln_seguros        := y.seguros;
            
            PQ_CR_REP_RECUPERACION_LEGAL_HYS.sp_cr_montos_amort(pn_itsuc          => y.hsucor,
                                                                pn_itmod          => y.hcmod,
                                                                pn_ittran         => y.htran,
                                                                pn_itnrel         => y.hnrel,
                                                                pn_fcon           => y.f_pag,
                                                                pn_capital        => ln_capital,
                                                                pn_interes        => ln_interes,
                                                                pn_int_comp_extra => ln_int_comp_extra,
                                                                pn_mora           => ln_mora,
                                                                pn_seguros        => ln_seguros,
                                                                pn_rub_obli       => ln_rub_obli,
                                                                pn_gastos         => ln_gastos,
                                                                pn_itf            => ITF);
          
            pq_cr_rep_recuperacion_legal.sp_cr_abog_dmda(pt_pgcod    => c.pgcod, --in
                                                         pt_modu     => pl_scmod, --in
                                                         pt_sucu     => pl_scsuc, --in
                                                         pt_moneda   => pl_scmda, --in
                                                         pt_papel    => pl_scpap, --in
                                                         pt_cnta     => pl_sccta, --in
                                                         pt_operac   => pl_scoper, --in
                                                         pt_sboper   => pl_scsbop, --in
                                                         pt_toper    => pl_sctope, --in
                                                         pn_scstat   => ln_stat, --in
                                                         pf_asig     => ld_fecasig, --out
                                                         pc_abrev    => lc_abrev, --out
                                                         pf_deman    => ld_fdemand, --out
                                                         pf_pasajud  => pf_pasajud, --out
                                                         pf_trancart => pf_trancart); --out

            ln_capingreso := pq_cr_rep_recuperacion_legal.fn_cr_cap_ingreso(pt_pgcod  => c.pgcod,
                                                                            pt_cnta   => pl_sccta,
                                                                            pt_operac => pl_sctope);
          
            lc_desctran := pq_cr_rep_recuperacion_legal.fn_cr_desc_trans(pt_pgcod => c.pgcod,
                                                                         itmod    => y.hcmod,
                                                                         ittran   => y.htran);
          
            pq_cr_rep_recuperacion_legal.sp_cr_datos_titular(pn_pgcod  => c.pgcod, --in
                                                             pn_cta    => pl_sccta, --in
                                                             pn_pais   => ln_pais, --out
                                                             pn_petdoc => ln_tdoc, --out
                                                             pn_pendoc => lc_ndoc, --out
                                                             pc_nomtit => lc_nomtit, --out
                                                             pc_dirtit => lc_dirtit, --out
                                                             pc_reftit => lc_reftit, --out
                                                             pc_distit => lc_distit); --out
                                                             
            lc_descsuc := pq_cr_rep_recuperacion_legal.fn_cr_desc_sucursal(pn_pgcod  => c.pgcod,
                                                                           pn_succod => pl_scsuc);
          
            begin
              --genera el correlativo
              select nvl(max(t.JAQY711CORR), 0) + 1
                into ln_corr
                from jaqy711 t
               where JAQY711COD = c.pgcod
                 and JAQY711MOD = pl_scmod
                 and JAQY711SUC = pl_scsuc
                 and JAQY711MDA = pl_scmda
                 and JAQY711PAP = pl_scpap
                 and JAQY711CTA = pl_sccta
                 and JAQY711OPE = pl_scoper
                 and JAQY711SBO = pl_scsbop
                 and JAQY711TOP = pl_sctope
                 and JAQY711FPAG = y.f_pag; --pd_fecproc;
            
              insert into jaqy711
                (JAQY711CORR, --ln_corr,
                 JAQY711COD, --c.pgcod,
                 JAQY711MOD, --c.scmod,
                 JAQY711SUC, --c.scsuc,
                 JAQY711MDA, --c.scmda,
                 JAQY711PAP, --c.scpap,
                 JAQY711CTA, --c.sccta,
                 JAQY711OPE, --c.scoper,
                 JAQY711SBO, --c.scsbop,
                 JAQY711TOP, --c.sctope,
                 JAQY711FPAG, --pd_fecproc,
                 JAQY711TMOD, --itmod,
                 JAQY711TTRAN, --ittran,
                 JAQY711NTRA, --lc_desctran,
                 JAQY711NAGE, --lc_descsuc,
                 JAQY711PAI, --ln_pais,
                 JAQY711TDC, --ln_tdoc,
                 JAQY711NDC, --lc_ndoc,
                 JAQY711NCLI, --lc_nomtit,
                 JAQY711FDE, --ld_fdemand,
                 JAQY711FASI, --ld_fecasig,
                 JAQY711CIN, --ln_capingreso,
                 JAQY711MPA, --capital+interes+int_comp_extra+mora+rub_obli+gastos,
                 JAQY711CAP, --capital,
                 JAQY711INT, --interes,
                 JAQY711ICOM, --int_comp_extra,
                 JAQY711MOR, --mora,
                 JAQY711ROB, --rub_obli,
                 JAQY711GAS, --gastos,
                 JAQY711ITF, --ITF,
                 JAQY711ABO, --lc_abrev,
                 JAQY711FPRO,
                 JAQY711NREL,
                 JAQY711TSUC,
                 jaqy711stat,
                 jaqy711dat,
                 jaqy711seg,
                 jaqy711ftc)
              values
                (ln_corr,
                 c.pgcod,--666
                 pl_scmod,
                 pl_scsuc,
                 pl_scmda,
                 pl_scpap,
                 pl_sccta,
                 pl_scoper,
                 pl_scsbop,
                 pl_sctope,
                 fpag, --.f_pag,
                 y.hcmod,
                 y.htran,
                 lc_desctran,
                 lc_descsuc,
                 ln_pais,
                 ln_tdoc,
                 lc_ndoc,
                 lc_nomtit,
                 ld_fdemand,
                 ld_fecasig,
                 ln_capingreso,
                 ln_capital + ln_interes + ln_int_comp_extra + ln_mora + ln_rub_obli + ln_gastos + ITF + ln_seguros,
                 ln_capital,
                 ln_interes,
                 ln_int_comp_extra,
                 ln_mora,
                 ln_rub_obli,
                 ln_gastos,
                 ITF,
                 lc_abrev,
                 pd_fecproc, --y.f_pag
                 y.hnrel,
                 y.hsucor,
                 ln_stat,
                 ln_dat,
                 ln_seguros,
                 pf_trancart);
              commit;
            
            exception
              when no_data_found then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
              
            end;
          END IF;
          
        end if;
      end loop;
    END LOOP;
  
  end;

  ------------------------------------------------------------------------
  Procedure sp_cr_verificar_exist(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,

                                  pn_fpag  in date,
                                  pn_tsuc  in number,
                                  pn_tmod  in number,
                                  pn_ttran in number,
                                  pn_nrel  in number,
                                  pv_flg   out varchar2) is
    lc_msgerr  varchar2(500);
  begin
    begin
      select 'S'
        into pv_flg
        from JAQY711
       where JAQY711COD = pn_cod
         and JAQY711MOD = pn_mod
         and JAQY711SUC = pn_suc
         and JAQY711MDA = pn_mda
         and JAQY711PAP = pn_pap
         and JAQY711CTA = pn_cta
         and JAQY711OPE = pn_ope
         and JAQY711SBO = pn_sbo
         and JAQY711TOP = pn_top
            
         and JAQY711FPAG = pn_fpag
         and JAQY711TSUC = pn_tsuc
         and JAQY711TMOD = pn_tmod
         and JAQY711TTRAN = pn_ttran
         and JAQY711NREL = pn_nrel;
    exception
      when too_many_rows then
        pv_flg := 'S';
      when others then
        pv_flg    := 'N';
        lc_msgerr := sqlerrm;
    end;
  end sp_cr_verificar_exist;

  ------------------------------------------------------------------------
  Procedure sp_cr_montos_amort(pn_ITSUC in number,
                               pn_ITMOD  in number,
                               pn_ITTRAN in  number,
                               pn_ITNREL in number,
                               pn_FCON in date, 
                               pn_capital in out number,
                               pn_interes   in out number,
                               pn_int_comp_extra in out number,
                               pn_mora   in out number,
                               pn_seguros  in out number,
                               pn_rub_obli  in out number,
                               pn_gastos  in out number,
                               pn_ITF  in out number)
  is
   lc_coderr varchar2(500);
   lc_msgerr  varchar2(500);
   monto_pago number:=0;
  begin

    begin
      select h.hcimp1
        into pn_ITF
        from fsh016 h
       where h.hsucor = pn_ITSUC
         and h.hcmod = pn_ITMOD
         and h.htran = pn_ITTRAN
         and h.hnrel = pn_ITNREL
         and h.hfcon = pn_FCON
         and h.hrubro in ('2517050901001','2527050901001');
    exception
      when no_data_found then
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
        pn_ITF:=0;
      when others then
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
    end;

    If(pn_ITMOD=30 and (pn_ITTRAN=669 or pn_ITTRAN=670)) THEN
      begin
        select(
          select sum(h.hcimp1) as monto
            from fsh016 h
      inner join fst198 f
              on h.hcmod = f.tp1corr1
             and h.htran = f.tp1corr2
             and h.hcord = f.tp1imp1 -- f.tp1corr3 --062017
           where h.hcmod = pn_ITMOD
             and h.hsucor = pn_ITSUC
             and h.htran = pn_ITTRAN
             and h.hnrel = pn_ITNREL
             and h.hfcon = pn_FCON
             and f.tp1cod1 = 10876
             and h.hcmod <> 999999) -
         (select hcimp1 as monto
            from fsh016
           where hcmod = pn_ITMOD
             and hsucor = pn_ITSUC
             and htran = pn_ITTRAN
             and hnrel = pn_ITNREL
             and hfcon = pn_FCON
             and hcord = 56)
          into monto_pago
          from dual;

        IF(monto_pago<pn_ITF and  monto_pago>0 and pn_ITF>0) then
          pn_ITF :=monto_pago;
          pn_capital :=0;
          pn_seguros:=0;
          pn_gastos:=0;
          pn_rub_obli:=0;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        end if;
        
        monto_pago:=monto_pago-pn_ITF;
        if(monto_pago<=0) then
          pn_capital :=0;
          pn_seguros:=0;
          pn_gastos:=0;
          pn_rub_obli:=0;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        end if ;

        if(monto_pago<pn_capital and monto_pago>0 ) then
          pn_capital :=monto_pago;
          pn_seguros:=0;
          pn_gastos:=0;
          pn_rub_obli:=0;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        end if;
        
        monto_pago:=monto_pago-pn_capital;
        if(monto_pago<=0) then
          pn_seguros:=0;
          pn_gastos:=0;
          pn_rub_obli:=0;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        end if ;


        IF(monto_pago<pn_seguros and  monto_pago>0 and pn_seguros>0) then
          pn_seguros :=monto_pago;
          pn_gastos:=0;
          pn_rub_obli:=0;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        End if;
        
        monto_pago:=monto_pago-pn_seguros;
        if(monto_pago<=0) then
          pn_gastos:=0;
          pn_rub_obli:=0;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        end if ;

        IF(monto_pago<pn_gastos and monto_pago>0 and pn_gastos>0) then
          pn_gastos :=monto_pago;
          pn_rub_obli:=0;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        End if;
        
        monto_pago:=monto_pago-pn_gastos;
        if(monto_pago<=0) then
          pn_rub_obli:=0;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        end if ;

        IF(monto_pago<pn_rub_obli and monto_pago>0 and pn_rub_obli>0) then
          pn_rub_obli :=monto_pago;
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        End if;
        
        monto_pago:=monto_pago-pn_rub_obli;
        if(monto_pago<=0) then
          pn_mora:=0;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        end if ;

        IF(monto_pago<pn_mora and monto_pago>0 and pn_mora>0) then
          pn_mora :=monto_pago;
          pn_int_comp_extra:=0;
          pn_interes:=0;
        End if;
        
        monto_pago:=monto_pago-pn_mora;
        if(monto_pago<=0) then
          pn_int_comp_extra:=0;
          pn_interes:=0;
        end if ;

        IF(monto_pago<pn_int_comp_extra and monto_pago>0 and pn_int_comp_extra>0 ) then
          pn_int_comp_extra :=monto_pago;
          pn_interes:=0;
        End if;
        
        monto_pago:=monto_pago-pn_int_comp_extra;
        if(monto_pago<=0) then
          pn_interes:=0;
        end if ;

        IF(monto_pago<pn_interes  and monto_pago>0 and pn_interes>0) then
          pn_interes :=monto_pago;
        End if;

        monto_pago:=monto_pago-pn_interes;
        if(monto_pago<=0) then
          monto_pago:=0;
        end if ;

      exception
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := sqlerrm;
      end;
    End if;
    
  exception
    when no_data_found then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
  end sp_cr_montos_amort;
--------------------------------------------------------------  
Procedure sp_cr_obtiene_pk(pt_pgcod in number,
                           pt_modt in number,
                           pt_tran in number,
                           pt_suct in number,
                           pt_rel in number,
                           pt_suc out number,
                           pt_mod out number,
                           pt_moneda  out number,
                           pt_papel  out number ,
                           pt_cnta in out number,
                           pt_operac in out number,
                           pt_sboper out number,
                           pt_toper out number,
                           pt_fecpag in date)

is
 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 ln_indicador number(5):=1;
 ln_tp1imp1 number(3);
 ln_tp1imp2 number(3);
begin

   if(pt_modt=30 and pt_tran in (395,397)) then
    begin
     select distinct AOMOD,
            AOSUC,
            AOMDA,
            AOPAP,
            AOCTA,
            AOOPER,
            AOSBOP,
            AOTOPE
          into
            pt_mod,
            pt_suc,
            pt_moneda,
            pt_papel,
            pt_cnta,
            pt_operac,
            pt_sboper,
            pt_toper
       from fsd010
      where aocta = pt_cnta
        and aooper = pt_operac
        and aotope = 550;
     exception
         when others THEN
                  ln_indicador:=0;
     end;
   end if;
   if((pt_modt=30 and pt_tran in (407,408,403,401)) or (pt_modt=98 and pt_tran in (303))) then
    begin
           select  distinct JAQL166SCMOD,
                  JAQL166SCSUC,
                  JAQL166SCMDA,
                  JAQL166SCPAP,
                  JAQL166SCCTA,
                  JAQL166SCOPE,
                  JAQL166SCSBO,
                  JAQL166SCTOP
                  into
                    pt_mod,
                    pt_suc,
                    pt_moneda,
                    pt_papel,
                    pt_cnta,
                    pt_operac,
                    pt_sboper,
                    pt_toper
             from jaql166
            where d166mo = pt_modt
              and d166tr = pt_tran
              and d166su = pt_suct
              and d166re = pt_rel
              and jaql166fpga= pt_fecpag;
     exception
         when others THEN
                  ln_indicador:=0;
     end;
   else
     begin
             select distinct  PPSUC,
                    PPMOD,
                    PPMDA,
                    PPPAP,
                    PPCTA,
                    PPOPER,
                    PPSBOP,
                    PPTOPE
                    into
                      pt_suc,
                      pt_mod,
                      pt_moneda,
                      pt_papel,
                      pt_cnta,
                      pt_operac,
                      pt_sboper,
                      pt_toper
             from fsd602
             where d602mo =  pt_modt
             and d602tr  =   pt_tran
             and d602su  =   pt_suct
             and d602re  =   pt_rel
             and d602fc = pt_fecpag;
       exception
         when others THEN
             -- ln_indicador:=0; --comentado 20/12/2022 kvalenciac
             --inicio 20/12/2022 kvalenciac
             --busco el ordinal de donde buscará la clave del crédito
             ln_tp1imp1 :=0;
             ln_tp1imp2 :=0;
             begin 
               select tp1imp1, tp1imp2 into ln_tp1imp1, ln_tp1imp2 from fst198 
               where tp1cod=1 
               and tp1cod1=11123 
               and tp1corr1=10 
               and tp1corr2=4
               and TP1nro1=pt_modt
               and TP1nro2=pt_tran;--TP1nro1-> modulo y TP1nro2-> transacción  
             exception
             when others then
                begin
                    select tp1nro1, tp1nro2 into ln_tp1imp1, ln_tp1imp2 from fst198 
                     where tp1cod=1 
                     and tp1cod1=11123 
                     and tp1corr1=9 
                     and tp1corr2=1
                     and TP1imp1=pt_modt
                     and TP1imp2=pt_tran;--TP1nro1-> modulo y TP1nro2-> transacción 
                 exception
                 when others then
                    ln_tp1imp1 :=10;
                 end;
             end;
             if (ln_tp1imp1>0 or ln_tp1imp2>0) then
               begin 
                 select hsucur, --Itsucd,
                        hmodul, --Modulo,
                        hmda,   --Moneda, 
                        hpap,   --Papel,
                        hcta,   --Ctnro,
                        hoper,  --Itoper,
                        hsubop, --Itsubo,
                        htoper --Ittope             
                    into
                      pt_suc,
                      pt_mod,
                      pt_moneda,
                      pt_papel,
                      pt_cnta,
                      pt_operac,
                      pt_sboper,
                      pt_toper
                   from fsh016--fsd016
                   where hsucor = pt_suct
                     and hcmod  = pt_modt
                     and htran =  pt_tran
                     and hnrel =  pt_rel
                     and hfcon =  pt_fecpag
                     and hcord  = ln_tp1imp1;
                  exception
                    when others then
                      begin
                       select hsucur, --Itsucd,
                              hmodul, --Modulo,
                              hmda,   --Moneda, 
                              hpap,   --Papel,
                              hcta,   --Ctnro,
                              hoper,  --Itoper,
                              hsubop, --Itsubo,
                              htoper --Ittope         
                      into
                        pt_suc,
                        pt_mod,
                        pt_moneda,
                        pt_papel,
                        pt_cnta,
                        pt_operac,
                        pt_sboper,
                        pt_toper
                       from fsh016--fsd016
                       where hsucor = pt_suct
                         and hcmod  = pt_modt
                         and htran =  pt_tran
                         and hnrel =  pt_rel
                         and hfcon =  pt_fecpag
                         and hcord  = ln_tp1imp2;
                      exception 
                        when others then
                          ln_indicador:=0;
                      end;
                  end;
             end if;
     end;
   end if;
end sp_cr_obtiene_pk;
------------------------------------------------------------------------

end PQ_CR_REP_RECUPERACION_LEGAL_HYS;
/

