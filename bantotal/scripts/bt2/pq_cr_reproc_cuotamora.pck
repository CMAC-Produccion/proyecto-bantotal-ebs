create or replace package pq_cr_reproc_cuotaMora is

  Procedure sp_proceso(pd_fecpro in date);
  Procedure sp_monto_cuota(pn_emp      in number,
                           pn_mod      in number,
                           pn_suc      in number,
                           pn_mda      in number,
                           pn_pap      in number,
                           pn_cta      in number,
                           pn_ope      in number,
                           pn_sbo      in number,
                           pn_top      in number,
                           pd_fec      in date,
                           pn_cap      in number,
                           pn_int      in number,
                           pd_fecpro   in date,
                           pn_segTotal out number,
                           pn_icvTotal out number,
                           pn_morTotal out number,
                           pn_capTotal out number,
                           pn_intTotal out number,
                           pn_penTotal out number,
                           pn_oroTotal out number,
                           pn_mto      out number);

  Procedure Sp_PagoAdelantado(pn_emp  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pd_fec  in date,
                              pn_tint in number, --mod@abr 20171011
                              pn_tmor in number, --mod@abr 20171011
                              --  in date, --mod@abr 20190328    
                              pn_capIN   in number, --mod@abr 20171011
                              pn_intIN   in number, --mod@abr 20171011
                              pn_cap     out number,
                              pn_int     out number,
                              pn_segT    out number,
                              pn_morT    out number,
                              pn_icvT    out number,
                              pd_fecpago out date,
                              pn_penT    out number, --mod@abr20190328
                              pn_oroT    out number --mod@abr20190412
                              );
  Procedure Sp_PagoAdelantado_New(pn_emp     in number,
                                  pn_mod     in number,
                                  pn_suc     in number,
                                  pn_mda     in number,
                                  pn_pap     in number,
                                  pn_cta     in number,
                                  pn_ope     in number,
                                  pn_sbo     in number,
                                  pn_top     in number,
                                  pd_fec     in date,
                                  pn_cap     out number,
                                  pn_int     out number,
                                  pn_segT    out number,
                                  pn_morT    out number,
                                  pn_icvT    out number,
                                  pd_fecpago out date,
                                  pn_penT    out number,
                                  pn_oroT    out number);
  Procedure Sp_penalidad(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number,
                         pn_dia in number,
                         pn_pen out number);
  Procedure Sp_OtrosRubrosOblig(pn_emp in number,
                                pn_mod in number,
                                pn_suc in number,
                                pn_mda in number,
                                pn_pap in number,
                                pn_cta in number,
                                pn_ope in number,
                                pn_sbo in number,
                                pn_top in number,
                                pd_fec in date,
                                pn_mto out number);
  Procedure Fn_cr_MismoDia(pn_emp  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number,
                           pn_num  in number,
                           pd_fec  in date,
                           pc_flgD out char,
                           pd_fecP out date);
  Procedure Sp_cr_CalculoParciales(pn_emp    in number,
                                   pn_mod    in number,
                                   pn_suc    in number,
                                   pn_mda    in number,
                                   pn_pap    in number,
                                   pn_cta    in number,
                                   pn_ope    in number,
                                   pn_sbo    in number,
                                   pn_top    in number,
                                   pd_fecP   in date, --fecha de vcto de cuota
                                   pd_fec    in date, -- fecha de pago de la cuota
                                   pn_tint   in number, -- tasa de icv 
                                   pn_tmor   in number, -- tasa moratoria
                                   pn_dia    in number, --dias de atraso
                                   pn_cap    in number, --capital de la cuota
                                   pn_int    in number, --interes de la cuota
                                   pn_capP   in number, --capital pagado
                                   pn_intP   in number, --interes pagado
                                   pn_icvA   in number, --icv que debe
                                   pn_morA   in number, --mora que debe
                                   ln_icvDif out number,
                                   ln_morDif out number);
end pq_cr_reproc_cuotaMora;
/

create or replace package body pq_cr_reproc_cuotaMora is

  Procedure sp_proceso(pd_fecpro in date) is
  
    /* cursor creditos is
        select *
          from aqpb002 a
        --where a.aqpb002cta = 2301858
        --  and a.aqpb002ope = 7560987
        ;
    */
    cursor calendario is
      select a.*, b.*
        from jaqz520_601 a, aqpb002 b --fsd601 a
       where /*a.pgcod = cn_emp
                                                                           and a.ppmod = cn_mod
                                                                           and a.ppsuc = cn_suc
                                                                           and a.ppmda = cn_mda
                                                                           and a.pppap = cn_pap
                                                                           and a.ppcta = cn_cta
                                                                           and a.ppoper = cn_ope
                                                                           and a.ppsbop = cn_sbo
                                                                           and a.pptope = cn_top
                                                                           and */
       a.d601co = 'S'
       and a.ppfpag <= pd_fecpro
       and (a.ppcap + a.ppint) <> 0
       and a.pgcod = b.aqpb002emp
       and a.ppmod = b.aqpb002mod
       and a.ppsuc = b.aqpb002suc
       and a.ppmda = b.aqpb002mda
       and a.pppap = b.aqpb002pap
       and a.ppcta = b.aqpb002cta
       and a.ppoper = b.aqpb002ope
       and a.ppsbop = b.aqpb002sbo
       and a.pptope = b.aqpb002top
      --and a.ppcta = 2410758
      --and a.ppoper = 6227163
       and not exists (select b.ppmod,
               b.ppsuc,
               b.ppmda,
               b.pppap,
               b.ppcta,
               b.ppoper,
               b.ppsbop,
               b.pptope,
               b.ppfpag
          from jaqz520_602 b --fsd602 b
         where b.pgcod = a.pgcod
           and b.ppmod = a.ppmod
           and b.ppsuc = a.ppsuc
           and b.ppmda = a.ppmda
           and b.pppap = a.pppap
           and b.ppcta = a.ppcta
           and b.ppoper = a.ppoper
           and b.ppsbop = a.ppsbop
           and b.pptope = a.pptope
           and b.ppfpag = a.ppfpag
           and b.d602co = 'S'
           and b.pp1stat = 'T'
           and (b.pp1cap + b.pp1int) <> 0)
       order by a.ppfpag;
    ln_seg number(17, 2) := 0;
    ln_icv number(17, 2) := 0;
    ln_mor number(17, 2) := 0;
    ln_cap number(17, 2) := 0;
    ln_int number(17, 2) := 0;
    ln_pen number(17, 2) := 0;
    ln_oro number(17, 2) := 0;
    ln_mto number(17, 2) := 0;
    --ln_segT number(17, 2) := 0;
    --ln_icvT number(17, 2) := 0;
    --ln_morT number(17, 2) := 0;
    --ln_capT number(17, 2) := 0;
    --ln_intT number(17, 2) := 0;
    --ln_penT number(17, 2) := 0;
    --ln_oroT number(17, 2) := 0;
    --ln_mtoT number(17, 2) := 0;
  
  begin
    /*    for i in creditos loop
    ln_seg := 0;
    ln_icv := 0;
    ln_mor := 0;
    ln_cap := 0;
    ln_int := 0;
    ln_pen := 0;
    ln_oro := 0;
    ln_mto := 0;*/
  
    for j in calendario /*(i.aqpb002emp,
                                                                          i.aqpb002mod,
                                                                          i.aqpb002suc,
                                                                          i.aqpb002mda,
                                                                          i.aqpb002pap,
                                                                          i.aqpb002cta,
                                                                          i.aqpb002ope,
                                                                          i.aqpb002sbo,
                                                                          i.aqpb002top)*/
     loop
      pq_Cr_reproc_cuotaMora.sp_monto_cuota(pn_emp      => j.pgcod,
                                            pn_mod      => j.ppmod,
                                            pn_suc      => j.ppsuc,
                                            pn_mda      => j.ppmda,
                                            pn_pap      => j.pppap,
                                            pn_cta      => j.ppcta,
                                            pn_ope      => j.ppoper,
                                            pn_sbo      => j.ppsbop,
                                            pn_top      => j.pptope,
                                            pd_fec      => j.ppfpag,
                                            pn_cap      => j.ppcap,
                                            pn_int      => j.ppint,
                                            pd_fecpro   => pd_fecpro,
                                            pn_segTotal => ln_seg,
                                            pn_icvTotal => ln_icv,
                                            pn_morTotal => ln_mor,
                                            pn_capTotal => ln_cap,
                                            pn_intTotal => ln_int,
                                            pn_penTotal => ln_pen,
                                            pn_oroTotal => ln_oro,
                                            pn_mto      => ln_mto);
      /*
      ln_segT := ln_segT + nvl(ln_seg, 0);
      ln_icvT := ln_icvT + nvl(ln_icv, 0);
      ln_morT := ln_morT + nvl(ln_mor, 0);
      ln_capT := ln_capT + nvl(ln_cap, 0);
      ln_intT := ln_intT + nvl(ln_int, 0);
      ln_penT := ln_penT + nvl(ln_pen, 0);
      ln_oroT := ln_oroT + nvl(ln_oro, 0);
      ln_mtoT := ln_mtoT + nvl(ln_mto, 0);*/
    
      insert into aqpa860
        (aqpa860emp,
         aqpa860mod,
         aqpa860suc,
         aqpa860mda,
         aqpa860pap,
         aqpa860cta,
         aqpa860ope,
         aqpa860sbo,
         aqpa860top,
         aqpa860fec,
         aqpa860cor,
         aqpa860cap,
         aqpa860int,
         aqpa860seg,
         aqpa860mor,
         aqpa860icv,
         aqpa860pen,
         aqpa860oro,
         aqpa860mto,
         aqpa860fep,
         AQPA860FCU)
      values
        (j.aqpb002emp,
         j.aqpb002mod,
         j.aqpb002suc,
         j.aqpb002mda,
         j.aqpb002pap,
         j.aqpb002cta,
         j.aqpb002ope,
         j.aqpb002sbo,
         j.aqpb002top,
         j.aqpb002fep,
         j.aqpb002cor,
         ln_cap,
         ln_int,
         ln_seg,
         ln_mor,
         ln_icv,
         ln_pen,
         ln_oro,
         ln_mto,
         pd_Fecpro,
         j.ppfpag);
    
      --end loop;
    
      commit;
    end loop;
  
  end sp_proceso;

  Procedure sp_monto_cuota(pn_emp      in number,
                           pn_mod      in number,
                           pn_suc      in number,
                           pn_mda      in number,
                           pn_pap      in number,
                           pn_cta      in number,
                           pn_ope      in number,
                           pn_sbo      in number,
                           pn_top      in number,
                           pd_fec      in date,
                           pn_cap      in number,
                           pn_int      in number,
                           pd_fecpro   in date,
                           pn_segTotal out number,
                           pn_icvTotal out number,
                           pn_morTotal out number,
                           pn_capTotal out number,
                           pn_intTotal out number,
                           pn_penTotal out number,
                           pn_oroTotal out number,
                           pn_mto      out number) is
    -- *****************************************************************
    -- Nombre                     : fn_monto_cuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
    ln_com       number(17, 2);
    ln_mor       number(17, 2);
    ln_tasint    number(10, 5);
    ln_tasmor    number(10, 5);
    ln_mto       number(17, 2);
    ln_seg       number(17, 2);
    ln_dia       number(5);
    ln_capA      number(17, 2);
    ln_intA      number(17, 2);
    ln_segA      number(17, 2);
    ln_capTotal  number(17, 2);
    ln_intTotal  number(17, 2);
    ln_segTotal  number(17, 2);
    ln_morA      number(17, 2);
    ln_icvA      number(17, 2);
    ln_morTotal  number(17, 2); --mod@abr 20171011
    ln_icvTotal  number(17, 2); --mod@abr 20171011
    ld_fecpago   date;
    ln_pen       number(17, 2); --mod@abr20180328
    ln_penA      number(17, 2); --mod@abr20180328
    ln_penTotal  number(17, 2); --mod@abr20180328
    ln_oro       number(17, 2); --mod@abr20180412
    ln_oroA      number(17, 2); --mod@abr20180412
    ln_oroTotal  number(17, 2); --mod@abr20180412
    ln_diaP      number(5); --mod@abr20190416
    ld_fecmaxPag date; --mod@abr20200318
    ld_fecGuia   date; --mod@abr20200318
    lc_flg       char(1); --mod@abr20200318
  begin
    --tasa de interes
    ln_tasint := pq_cr_cuotamora.BT_Tasa_Interes(pn_emp,
                                                 pn_mod,
                                                 pn_suc,
                                                 pn_mda,
                                                 pn_pap,
                                                 pn_cta,
                                                 pn_ope,
                                                 pn_sbo,
                                                 pn_top);
    --tasa de mora                                                    
    ln_tasmor := pq_cr_cuotamora.BT_Tasa_Mora(pn_emp,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
    --pagos adelantado
    --mod@abr 20190624
    pq_cr_reproc_cuotaMora.Sp_PagoAdelantado_new(pn_emp,
                                                 pn_mod,
                                                 pn_suc,
                                                 pn_mda,
                                                 pn_pap,
                                                 pn_cta,
                                                 pn_ope,
                                                 pn_sbo,
                                                 pn_top,
                                                 pd_fec,
                                                 ln_capA,
                                                 ln_intA,
                                                 ln_segA,
                                                 ln_morA,
                                                 ln_icvA,
                                                 ld_fecpago,
                                                 ln_penA,
                                                 ln_oroA);
  
    --pq_cr_cuotamora.Sp_PagoAdelantado(pn_emp, --mod@abr 20190624
    --                                  pn_mod,  --mod@abr 20190624
    --                                 pn_suc,  --mod@abr 20190624
    --                                  pn_mda,  --mod@abr 20190624
    --                                  pn_pap,  --mod@abr 20190624 
    --                                  pn_cta,  --mod@abr 20190624
    --                                  pn_ope,  --mod@abr 20190624
    --                                  pn_sbo,  --mod@abr 20190624
    --                                  pn_top,  --mod@abr 20190624
    --                                  pd_fec,  --mod@abr 20190624
    --                                  ln_tasint, --mod@abr 20190624
    --                                  ln_tasmor, --mod@abr 20190624
    --                                  --pd_fecpro, mod@abr20190328
    --                                  pn_cap,     --mod@abr 20190624
    --                                  pn_int,     --mod@abr 20190624
    --                                  ln_capA,    --mod@abr 20190624
    --                                  ln_intA,    --mod@abr 20190624
    --                                  ln_segA,    --mod@abr 20190624
    --                                  ln_morA,    --mod@abr 20190624
    --                                  ln_icvA,    --mod@abr 20190624
    --                                  ld_fecpago, --mod@abr 20190624
    --                                  ln_penA,    --mod@abr 20190624
    --                                  ln_oroA);   --mod@abr 20190624
    --mod@abr 20190624
    --mod@abr 20200318
    begin
      select max(a.pp1fech)
        into ld_fecmaxPag
        from jaqz520_602 a -- fsd602 a
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
      when others then
        null;
    end;
  
    begin
      select to_date(tp1desc, 'dd/mm/yyyy')
        into ld_fecGuia
        from fst198
       where TP1COD = 1
         and TP1COD1 = 11105
         and TP1CORR1 = 35
         and TP1CORR2 = 1
         and TP1CORR3 = 1;
    exception
      when others then
        null;
    end;
    lc_flg := 'N';
  
    begin
      select 'S'
        into lc_flg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 44444
         and a.tp1corr2 = 1
         and tp1nro1 = 1;
    exception
      when others then
        null;
    end;
  
    if ld_fecmaxPag > ld_fecGuia then
      ld_fecGuia := ld_fecmaxPag;
    end if;
    --mod@abr 20200318
    --dias de atraso
  
    if lc_flg = 'S' then
      --mod@abr 20200318
      if ld_fecpago is not null then
        --mod@abr 20200318
        ln_dia := ld_fecGuia - ld_fecpago; --mod@abr 20200318
      else
        ln_dia := ld_fecGuia - pd_fec; --mod@abr 20200318
      end if;
    
      ln_diaP := ld_fecGuia - pd_fec; --mod@abr 20200318
    else
      if ld_fecpago is not null then
        ln_dia := pd_fecpro - ld_fecpago;
      else
        ln_dia := pd_fecpro - pd_fec;
      end if;
    
      ln_diaP := pd_fecpro - pd_fec;
    end if;
  
    --seguros
    begin
      select a.ppimp11 + a.ppimp12 + a.ppimp13 + a.ppimp14
        into ln_seg
        from jaqz520_611 a -- fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec;
    exception
      when others then
        null;
    end;
  
    --mod@abr20190328
    pq_cr_reproc_cuotaMora.Sp_penalidad(pn_emp => pn_emp,
                                        pn_mod => pn_mod,
                                        pn_suc => pn_suc,
                                        pn_mda => pn_mda,
                                        pn_pap => pn_pap,
                                        pn_cta => pn_cta,
                                        pn_ope => pn_ope,
                                        pn_sbo => pn_sbo,
                                        pn_top => pn_top,
                                        pn_dia => ln_diaP,
                                        pn_pen => ln_pen);
    --mod@abr20190328
  
    --mod@abr20190412
    pq_cr_reproc_cuotaMora.Sp_otrosRubrosOblig(pn_emp => pn_emp,
                                               pn_mod => pn_mod,
                                               pn_suc => pn_suc,
                                               pn_mda => pn_mda,
                                               pn_pap => pn_pap,
                                               pn_cta => pn_cta,
                                               pn_ope => pn_ope,
                                               pn_sbo => pn_sbo,
                                               pn_top => pn_top,
                                               pd_fec => pd_Fec,
                                               pn_mto => ln_oro);
    --mod@abr20190412
  
    ln_capTotal := nvl(pn_cap, 0) - nvl(ln_capA, 0);
    ln_intTotal := nvl(pn_int, 0) - nvl(ln_intA, 0);
    ln_segTotal := nvl(ln_seg, 0) - nvl(ln_segA, 0);
    ln_penTotal := nvl(ln_pen, 0) - nvl(ln_penA, 0); --mod@abr20190328
    if ln_penTotal < 0 then
      ln_penTotal := 0;
    end if;
  
    ln_oroTotal := nvl(ln_oro, 0) - nvl(ln_oroA, 0); --mod@abr20190412
    --interes compensatorio
    ln_com := round((Power(1 + (ln_tasint / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);
    --interes moratorio
    ln_mor := round((Power(1 + (ln_tasmor / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);
  
    --ln_morTotal := nvl(ln_mor, 0) + nvl(ln_morA, 0); --mod@abr 20171011 --mod@abr 20190624
    --ln_icvTotal := nvl(ln_com, 0) + nvl(ln_icvA, 0); --mod@abr 20171011 --mod@abr 20190624
  
    ln_morTotal := nvl(ln_mor, 0) - nvl(ln_morA, 0); --mod@abr 20190624
    ln_icvTotal := nvl(ln_com, 0) - nvl(ln_icvA, 0); --mod@abr 20190624
  
    ln_mto := nvl(ln_segTotal, 0) + nvl(ln_icvTotal, 0) +
              nvl(ln_morTotal, 0) + nvl(ln_capTotal, 0) + --mod@abr 20171011
              nvl(ln_intTotal, 0) + nvl(ln_penTotal, 0) + --mod@abr20190328
              nvl(ln_oroTotal, 0) --mod@abr20190412
    
     ;
  
    pn_segTotal := ln_segTotal;
    pn_icvTotal := ln_icvTotal;
    pn_morTotal := ln_morTotal;
    pn_capTotal := ln_capTotal;
    pn_intTotal := ln_intTotal;
    pn_penTotal := ln_penTotal;
    pn_oroTotal := ln_oroTotal;
    pn_mto      := ln_mto;
  
    --return ln_mto;
  end sp_monto_cuota;

  Procedure Sp_PagoAdelantado(pn_emp  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pd_fec  in date,
                              pn_tint in number, --mod@abr 20171011
                              pn_tmor in number, --mod@abr 20171011
                              --  in date, --mod@abr 20190328    
                              pn_capIN   in number, --mod@abr 20171011
                              pn_intIN   in number, --mod@abr 20171011
                              pn_cap     out number,
                              pn_int     out number,
                              pn_segT    out number,
                              pn_morT    out number,
                              pn_icvT    out number,
                              pd_fecpago out date,
                              pn_penT    out number, --mod@abr20190328
                              pn_oroT    out number --mod@abr20190412
                              ) is
    ln_seg      number(18, 2);
    ln_mor      number(18, 2);
    ln_icv      number(18, 2);
    ln_dia      number;
    ln_cap      number(17, 2);
    ln_int      number(17, 2);
    ln_morDif   number(18, 2);
    ln_icvDif   number(18, 2);
    ld_fecmax   date;
    ln_morDif_A number(18, 2) := 0;
    ln_icvDif_A number(18, 2) := 0;
    ld_fecaux   date := to_date('01.01.0001', 'dd.mm.yyyy');
    --lc_flg_ICV char(1):='N';
    --lc_flg_MOR char(1):='N';
    --ln_mor_AUX number(18,2);
    --ln_icv_AUX number(18,2);
    --lc_flgB char(1) := 'N';
    lc_flgPar char(1);
    ld_fecPar date;
    --lc_flgOk char(1):='N';
    ln_cont number(5) := 0;
    ln_pen  number(17, 2);
    ln_oro  number(17, 2);
  
    cursor calendario is
      select *
        from jaqz520_602 a -- fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.pp1stat = 'P'
         and a.d602co = 'S';
  begin
    begin
      select sum(a.pp1cap), sum(a.pp1int)
        into pn_cap, pn_int
        from jaqz520_602 a --fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.pp1stat = 'P'
         and a.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    pn_segT := 0;
    pn_morT := 0;
    pn_icvT := 0;
    pn_penT := 0; --mod@abr20190328
    pn_oroT := 0; --mod@abr20190412
  
    if pn_cap is not null then
      for i in calendario loop
        begin
          select sum(a.pp1imp11 + a.pp1imp12 + a.pp1imp13 + a.pp1imp14)
            into ln_seg
            from jaqz520_612 a --fsd612 a
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
             and a.pp1nump = i.pp1nump;
        exception
          when others then
            null;
          
        end;
      
        ---mod@abr 20190328
        begin
          select a.aqpa4dimp --.pp003imp
            into ln_pen
            from aqpa004d a --fpp003 a
           where a.aqpa4dpgcod = i.pgcod
             and a.aqpa4dmod = i.ppmod
             and a.aqpa4dsuc = i.ppsuc
             and a.aqpa4dmda = i.ppmda
             and a.aqpa4dpap = i.pppap
             and a.aqpa4dcta = i.ppcta
             and a.aqpa4doper = i.ppoper
             and a.aqpa4dsbop = i.ppsbop
             and a.aqpa4dtope = i.pptope
             and a.aqpa4dfpag = i.ppfpag
             and a.aqpa4dnump = i.pp1nump
             and a.aqpa4dprcnc = 3;
        
        exception
          when others then
            null;
          
        end;
        ---mod@abr 20190328
      
        ---mod@abr 20190412
        begin
          select a.aqpa4dimp --a.pp003imp
            into ln_oro
            from aqpa004d a --fpp003 a
           where a.aqpa4dpgcod = i.pgcod
             and a.aqpa4dmod = i.ppmod
             and a.aqpa4dsuc = i.ppsuc
             and a.aqpa4dmda = i.ppmda
             and a.aqpa4dpap = i.pppap
             and a.aqpa4dcta = i.ppcta
             and a.aqpa4doper = i.ppoper
             and a.aqpa4dsbop = i.ppsbop
             and a.aqpa4dtope = i.pptope
             and a.aqpa4dfpag = i.ppfpag
             and a.aqpa4dnump = i.pp1nump
             and a.aqpa4dprcnc = 6;
        
        exception
          when others then
            null;
          
        end;
        ---mod@abr 20190412
      
        --mod@abr 20171011
        --dias de atraso
        if i.pp1fech > pd_fec then
          begin
            select max(a.pp1fech)
              into ld_fecmax
              from jaqz520_602 a --fsd602 a
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
               and a.ppfpag = pd_fec
               and a.pp1fech > pd_fec
               and a.pp1fech < i.pp1fech
               and a.pp1stat = 'P'
               and a.d602co = 'S';
          exception
            when others then
              null;
          end;
          if ld_fecmax is null then
            ld_fecmax := i.ppfpag;
          end if;
        
          ln_dia := i.pp1fech - ld_fecmax;
        
          --calculo capital e interes
          begin
            select sum(a.pp1cap), sum(a.pp1int)
              into ln_cap, ln_int
              from jaqz520_602 a -- fsd602 a
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
               and a.pp1fech < i.pp1fech
               and a.pp1stat = 'P'
               and a.d602co = 'S';
          exception
            when others then
              null;
          end;
        
          --Verifica si esta cuota forma parte de parciales en el mismo dia
          pq_cr_reproc_cuotaMora.Fn_cr_MismoDia(pn_emp  => i.pgcod,
                                                pn_mod  => i.ppmod,
                                                pn_suc  => i.ppsuc,
                                                pn_mda  => i.ppmda,
                                                pn_pap  => i.pppap,
                                                pn_cta  => i.ppcta,
                                                pn_ope  => i.ppoper,
                                                pn_sbo  => i.ppsbop,
                                                pn_top  => i.pptope,
                                                pn_num  => i.pp1nump,
                                                pd_fec  => i.pp1fech,
                                                pc_flgD => lc_flgPar,
                                                pd_fecP => ld_fecPar);
          if lc_flgPar = 'S' then
            ln_cont := ln_cont + 1;
          end if;
          if lc_flgPar = 'S' and ln_cont = 1 then
            pq_cr_cuotamora.Sp_cr_CalculoParciales(pn_emp    => i.pgcod,
                                                   pn_mod    => i.ppmod,
                                                   pn_suc    => i.ppsuc,
                                                   pn_mda    => i.ppmda,
                                                   pn_pap    => i.pppap,
                                                   pn_cta    => i.ppcta,
                                                   pn_ope    => i.ppoper,
                                                   pn_sbo    => i.ppsbop,
                                                   pn_top    => i.pptope,
                                                   pd_fecP   => i.ppfpag,
                                                   pd_fec    => ld_fecPar,
                                                   pn_tint   => pn_tint,
                                                   pn_tmor   => pn_tmor,
                                                   pn_dia    => ln_dia,
                                                   pn_cap    => pn_capIN,
                                                   pn_int    => pn_intIN,
                                                   pn_capP   => ln_cap,
                                                   pn_intP   => ln_int,
                                                   pn_icvA   => ln_icvDif_A,
                                                   pn_morA   => ln_morDif_A,
                                                   ln_icvDif => ln_icvDif,
                                                   ln_morDif => ln_morDif);
          
            ln_morDif_A := ln_morDif;
            ln_icvDif_A := ln_icvDif;
          end if;
        
          if lc_flgPar = 'N' then
          
            begin
              select sum(a.pp1imp2), sum(a.pp1imp3)
                into ln_mor, ln_icv
                from jaqz520_612 a -- fsd612 a
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
                 and a.pp1nump = i.pp1nump;
            exception
              when others then
                null;
              
            end;
          
            --interes compensatorio
            ln_icvDif := (round((Power(1 + (pn_tint / 100), (ln_dia / 360)) - 1) *
                                ((pn_capIN - nvl(ln_cap, 0)) +
                                (pn_intIN - nvl(ln_int, 0))),
                                2) + ln_icvDif_A) - nvl(ln_icv, 0);
          
            --interes moratorio
            ln_morDif := (round((Power(1 + (pn_tmor / 100), (ln_dia / 360)) - 1) *
                                ((pn_capIN - nvl(ln_cap, 0)) +
                                (pn_intIN - nvl(ln_int, 0))),
                                2) + ln_morDif_A) - nvl(ln_mor, 0);
            /* end if;
            
            if ld_fecaux = i.pp1fech then 
               if nvl(ln_mor,0) = 0 and nvl(ln_icv,0) = 0 then
                  ln_icvDif := (round((Power(1+(pn_tint/100),(ln_dia/360)) -1) * 
                                 ((pn_capIN-nvl(ln_cap,0)) + (pn_intIN-nvl(ln_int,0))),2))-nvl(ln_icv,0) ;
                  ln_morDif := (round((Power(1+(pn_tmor/100),(ln_dia/360)) -1) * 
                               ((pn_capIN-nvl(ln_cap,0)) + (pn_intIN-nvl(ln_int,0))),2))-nvl(ln_mor,0) ;
                  ln_morDif_A := ln_morDif;
                  ln_icvDif_A := ln_icvDif;
                  lc_flgB := 'S';
                  else
                       if lc_flgB = 'S' then 
                          ln_icvDif := (round((Power(1+(pn_tint/100),(ln_dia/360)) -1) * 
                                 ((pn_capIN-nvl(ln_cap,0)) + (pn_intIN-nvl(ln_int,0))),2))-nvl(ln_icv,0) ;
                          ln_morDif := (round((Power(1+(pn_tmor/100),(ln_dia/360)) -1) * 
                                       ((pn_capIN-nvl(ln_cap,0)) + (pn_intIN-nvl(ln_int,0))),2))-nvl(ln_mor,0) ;
                          ln_morDif_A := ln_morDif;
                          ln_icvDif_A := ln_icvDif;  
                          lc_flgB := 'N';           
                          else
                             ln_morDif_A := ln_morDif;
                             ln_icvDif_A := ln_icvDif; 
                       end if;      
               end if;
               else*/
            ln_morDif_A := ln_morDif;
            ln_icvDif_A := ln_icvDif;
          end if;
        end if;
      
        --mod@abr 20171011
      
        pn_segT   := pn_segT + nvl(ln_seg, 0);
        pn_morT   := ln_morDif_A; --pn_morT+nvl(ln_morDif,0);
        pn_icvT   := ln_icvDif_A; --pn_icvT+nvl(ln_icvDif,0);
        ld_fecaux := i.pp1fech;
        pn_penT   := pn_penT + nvl(ln_pen, 0); --mod@br20190328
        pn_oroT   := pn_oroT + nvl(ln_oro, 0); --mod@br20190328
      
      end loop;
    end if;
  
    pn_cap := nvl(pn_cap, 0);
    pn_int := nvl(pn_int, 0);
  
    begin
      select max(a.pp1fech)
        into pd_fecpago
        from jaqz520_602 a -- fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.pp1stat = 'P'
         and a.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    --MOD@ABR 20171011
    if pd_fecpago <= pd_fec then
      pd_fecpago := null;
    end if;
    --MOD@ABR 20171011
  
  end Sp_PagoAdelantado;

  Procedure Sp_PagoAdelantado_New(pn_emp     in number,
                                  pn_mod     in number,
                                  pn_suc     in number,
                                  pn_mda     in number,
                                  pn_pap     in number,
                                  pn_cta     in number,
                                  pn_ope     in number,
                                  pn_sbo     in number,
                                  pn_top     in number,
                                  pd_fec     in date,
                                  pn_cap     out number,
                                  pn_int     out number,
                                  pn_segT    out number,
                                  pn_morT    out number,
                                  pn_icvT    out number,
                                  pd_fecpago out date,
                                  pn_penT    out number,
                                  pn_oroT    out number) is
  
    ld_fecult date;
  
  begin
    begin
      select sum(a.pp1cap), sum(a.pp1int)
        into pn_cap, pn_int
        from jaqz520_602 a -- fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.pp1stat = 'P'
         and a.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    pn_segT := 0;
    pn_morT := 0;
    pn_icvT := 0;
    pn_penT := 0;
    pn_oroT := 0;
  
    if pn_cap is not null or pn_int is not null then
    
      begin
        select max(a.pp1fech)
          into pd_fecpago
          from jaqz520_602 a --fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = pd_fec
           and (a.pp1cap + a.pp1int) <> 0
           and a.pp1stat = 'P'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select sum(a.pp1imp2), sum(a.pp1imp3)
          into pn_morT, pn_icvT
          from jaqz520_612 a, --fsd612 a, 
               jaqz520_602 b --fsd602 b
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = pd_fec
           and a.pgcod = b.pgcod
           and a.ppmod = b.ppmod
           and a.ppsuc = b.ppsuc
           and a.ppmda = b.ppmda
           and a.pppap = b.pppap
           and a.ppcta = b.ppcta
           and a.ppoper = b.ppoper
           and a.ppsbop = b.ppsbop
           and a.pptope = b.pptope
           and a.ppfpag = b.ppfpag
           and a.pp1nump = b.pp1nump
           and b.pp1fech > ld_fecult
           and b.d602co = 'S'
           and b.pp1stat = 'P'
        
        ;
      exception
        when others then
          null;
        
      end;
    
    end if;
  
    pn_cap := nvl(pn_cap, 0);
    pn_int := nvl(pn_int, 0);
  
    --MOD@ABR 20171011
    if pd_fecpago <= pd_fec then
      pd_fecpago := null;
    end if;
    --MOD@ABR 20171011
  
    --mod@abr 20190624
    --se calculara la penalidad, otros rubros de la obligacion y seguros por cuota no por pago
    begin
      select sum(a.pp1imp11 + a.pp1imp12 + a.pp1imp13 + a.pp1imp14)
        into pn_segT
        from jaqz520_612 a, -- fsd612 a, 
             jaqz520_602 b --fsd602 b
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.pgcod = b.pgcod
         and a.ppmod = b.ppmod
         and a.ppsuc = b.ppsuc
         and a.ppmda = b.ppmda
         and a.pppap = b.pppap
         and a.ppcta = b.ppcta
         and a.ppoper = b.ppoper
         and a.ppsbop = b.ppsbop
         and a.pptope = b.pptope
         and a.ppfpag = b.ppfpag
         and a.pp1nump = b.pp1nump
         and b.d602co = 'S'
         and b.pp1stat = 'P';
    exception
      when others then
        null;
      
    end;
  
    begin
      select sum(a.aqpa4dimp)
        into pn_penT
        from aqpa004d    a, -- fpp003 a, 
             jaqz520_602 b -- fsd602 b
       where a.aqpa4dpgcod = pn_emp
         and a.aqpa4dmod = pn_mod
         and a.aqpa4dsuc = pn_suc
         and a.aqpa4dmda = pn_mda
         and a.aqpa4dpap = pn_pap
         and a.aqpa4dcta = pn_cta
         and a.aqpa4doper = pn_ope
         and a.aqpa4dsbop = pn_sbo
         and a.aqpa4dtope = pn_top
         and a.aqpa4dfpag = pd_fec
         and a.aqpa4dpgcod = b.pgcod
         and a.aqpa4dmod = b.ppmod
         and a.aqpa4dsuc = b.ppsuc
         and a.aqpa4dmda = b.ppmda
         and a.aqpa4dpap = b.pppap
         and a.aqpa4dcta = b.ppcta
         and a.aqpa4doper = b.ppoper
         and a.aqpa4dsbop = b.ppsbop
         and a.aqpa4dtope = b.pptope
         and a.aqpa4dfpag = b.ppfpag
         and a.aqpa4dnump = b.pp1nump
         and b.d602co = 'S'
         and b.pp1stat = 'P'
         and aqpa4dprcnc = 3;
    
    exception
      when others then
        null;
      
    end;
  
    begin
      select sum(a.aqpa4dimp)
        into pn_oroT
        from aqpa004d    a, --fpp003 a, 
             jaqz520_602 b -- fsd602 b
       where a.aqpa4dpgcod = pn_emp
         and a.aqpa4dmod = pn_mod
         and a.aqpa4dsuc = pn_suc
         and a.aqpa4dmda = pn_mda
         and a.aqpa4dpap = pn_pap
         and a.aqpa4dcta = pn_cta
         and a.aqpa4doper = pn_ope
         and a.aqpa4dsbop = pn_sbo
         and a.aqpa4dtope = pn_top
         and a.aqpa4dfpag = pd_fec
         and a.aqpa4dpgcod = b.pgcod
         and a.aqpa4dmod = b.ppmod
         and a.aqpa4dsuc = b.ppsuc
         and a.aqpa4dmda = b.ppmda
         and a.aqpa4dpap = b.pppap
         and a.aqpa4dcta = b.ppcta
         and a.aqpa4doper = b.ppoper
         and a.aqpa4dsbop = b.ppsbop
         and a.aqpa4dtope = b.pptope
         and a.aqpa4dfpag = b.ppfpag
         and a.aqpa4dnump = b.pp1nump
         and b.d602co = 'S'
         and b.pp1stat = 'P'
         and aqpa4dprcnc = 6;
    
    exception
      when others then
        null;
      
    end;
    --mod@abr 20190624
  
  end Sp_PagoAdelantado_New;

  Procedure Sp_penalidad(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number,
                         pn_dia in number,
                         pn_pen out number) is
  
    lc_indicador char(60);
    ln_saldoK    number(17, 2);
    ln_saldoIni  number(17, 2);
    ln_saldoMax  number(17, 2);
    ln_MONTO     number(17, 2);
    ln_DiasMax   number(5);
    ln_DiasMin   number(5);
    ln_PENALIDAD number(17, 2);
  begin
  
    begin
      select sum(a.aoimp)
        into ln_saldoK
        from jaqz520_010 a -- fsd010 a
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
        ln_saldoK := 0;
    end;
  
    --1 --verificar si credito posee penalidad     
    begin
      select trim(x.xllotexto)
        into lc_indicador
        from x054021 x
       where x.xlloaocta = pn_cta
         and x.xlloaooper = pn_ope
         and x.xllotxtcod = 250;
    exception
      when too_many_rows then
        begin
          select trim(x.xllotexto)
            into lc_indicador
            from x054021 x
           where x.xlloaocta = pn_cta
             and x.xlloaooper = pn_ope
             and x.xllotxtcod = 250
             and rownum = 1;
        exception
          when others then
            lc_indicador := null;
        end;
      when others then
        lc_indicador := null;
    end;
  
    if lc_indicador = 'P' then
      --2 --obtener rango de montos
    
      begin
        select max(comto) MINIMO_SAL
          into ln_saldoIni
          from fsd026
         where COCOD = 3
           and comod = pn_mod
           and comda = pn_mda
           and comto < ln_saldoK;
      exception
        when others then
          ln_saldoIni := 0;
      end;
    
      ln_saldoIni := NVL(ln_saldoIni, 0);
      begin
        select min(comto) MAXIMO_SAL
          into ln_saldoMax
          from fsd026
         where COCOD = 3
           and comod = pn_mod
           and comda = pn_mda
           and comto >= ln_saldoK;
      exception
        when others then
          ln_saldoMax := 0;
      end;
      ln_saldoMax := nvl(ln_saldoMax, 0);
    
      begin
        select comto
          into ln_MONTO
          from fsd026 f
         where COCOD = 3
           and comod = pn_mod
           and comda = pn_mda
           and comto > ln_saldoIni
           and comto <= ln_saldoMax;
      exception
        when others then
          ln_MONTO := 0;
      end;
      ln_MONTO := nvl(ln_MONTO, 0);
    
      --3---obtener rango de dias
      begin
        select min(copzo) MAXIMO
          into ln_DiasMax
          from fsp026
         where COCOD = 3
           and comod = pn_mod
           and comda = pn_mda
           and comto = ln_MONTO
           and copzo >= pn_dia;
      exception
        when others then
          ln_DiasMax := 0;
      end;
      ln_DiasMax := nvl(ln_DiasMax, 0);
    
      begin
        select max(copzo) MINIMO
          into ln_DiasMin
          from fsp026
         where COCOD = 3
           and comod = pn_mod
           and comda = pn_mda
           and comto = ln_MONTO
           and copzo < pn_dia;
      exception
        when others then
          ln_DiasMin := 0;
      end;
      ln_DiasMin := nvl(ln_DiasMin, 0);
    
      begin
        select coimpp
          into ln_PENALIDAD
          from fsp026
         where COCOD = 3
           and comod = pn_mod
           and comda = pn_mda
           and comto = ln_MONTO
           and copzo > ln_DiasMin
           and copzo <= ln_DiasMax;
      exception
        when others then
          ln_PENALIDAD := 0;
      end;
      ln_PENALIDAD := nvl(ln_PENALIDAD, 0);
    
      --
    end if;
  
    pn_pen := ln_PENALIDAD;
  
  end Sp_penalidad;

  Procedure Sp_OtrosRubrosOblig(pn_emp in number,
                                pn_mod in number,
                                pn_suc in number,
                                pn_mda in number,
                                pn_pap in number,
                                pn_cta in number,
                                pn_ope in number,
                                pn_sbo in number,
                                pn_top in number,
                                pd_fec in date,
                                pn_mto out number) is
  
    ln_mto number(17, 2);
  begin
  
    begin
      select a.pp002imp
        into ln_mto
        from jaqz520_002 a --fpp002 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and prestconc = 6;
    exception
      when others then
        ln_mto := 0;
    end;
  
    pn_mto := nvl(ln_mto, 0);
  
  end Sp_OtrosRubrosOblig;

  Procedure Fn_cr_MismoDia(pn_emp  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number,
                           pn_num  in number,
                           pd_fec  in date,
                           pc_flgD out char,
                           pd_fecP out date) is
  
    ln_numD    number(9);
    ld_fecha   date;
    ld_fecauxD date;
    ld_fecult  date;
  
  begin
  
    pc_flgD  := 'N';
    ld_fecha := pd_fec;
    pd_fecP  := ld_fecha;
    begin
      select min(a.pp1nump)
        into ln_numD
        from jaqz520_602 a -- fsd602 a
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
         and a.pp1stat = 'P'
         and a.pp1nump > pn_num;
    exception
      when others then
        null;
    end;
  
    if ln_numD is not null then
      begin
        select a.pp1fech
          into ld_fecauxD
          from jaqz520_602 a --fsd602 a
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
           and a.pp1stat = 'P'
           and a.pp1nump = ln_numD;
      exception
        when others then
          null;
      end;
    
      if ld_fecauxD = pd_fec then
        pc_flgD := 'S';
      end if;
    end if;
  
    if pc_flgD = 'N' then
      begin
        select a.pp1fech
          into ld_fecult
          from jaqz520_602 a --fsd602 a
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
           and a.pp1stat = 'P'
           and a.pp1nump = pn_num;
      exception
        when others then
          null;
      end;
    end if;
  
    if ld_fecult = pd_fec then
      pc_flgD := 'S';
    end if;
  
  end Fn_cr_MismoDia;

  Procedure Sp_cr_CalculoParciales(pn_emp    in number,
                                   pn_mod    in number,
                                   pn_suc    in number,
                                   pn_mda    in number,
                                   pn_pap    in number,
                                   pn_cta    in number,
                                   pn_ope    in number,
                                   pn_sbo    in number,
                                   pn_top    in number,
                                   pd_fecP   in date, --fecha de vcto de cuota
                                   pd_fec    in date, -- fecha de pago de la cuota
                                   pn_tint   in number, -- tasa de icv 
                                   pn_tmor   in number, -- tasa moratoria
                                   pn_dia    in number, --dias de atraso
                                   pn_cap    in number, --capital de la cuota
                                   pn_int    in number, --interes de la cuota
                                   pn_capP   in number, --capital pagado
                                   pn_intP   in number, --interes pagado
                                   pn_icvA   in number, --icv que debe
                                   pn_morA   in number, --mora que debe
                                   ln_icvDif out number,
                                   ln_morDif out number) is
  
    ln_mor number(17, 2);
    ln_icv number(17, 2);
  
  begin
    begin
      select sum(a.pp1imp2), sum(a.pp1imp3)
        into ln_mor, ln_icv
        from jaqz520_612 a, --fsd612 a, 
             jaqz520_602 b --fsd602 b
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fecP
         and a.pgcod = b.pgcod
         and a.ppmod = b.ppmod
         and a.ppsuc = b.ppsuc
         and a.ppmda = b.ppmda
         and a.pppap = b.pppap
         and a.ppcta = b.ppcta
         and a.ppoper = b.ppoper
         and a.ppsbop = b.ppsbop
         and a.pptope = b.pptope
         and a.ppfpag = b.ppfpag
         and b.pp1fech = pd_fec
         and a.pp1nump = b.pp1nump
         and b.d602co = 'S'
         and b.pp1stat = 'P';
    exception
      when others then
        null;
      
    end;
  
    --interes compensatorio
    ln_icvDif := (round((Power(1 + (pn_tint / 100), (pn_dia / 360)) - 1) *
                        ((pn_cap - nvl(pn_capP, 0)) +
                        (pn_int - nvl(pn_intP, 0))),
                        2) + pn_icvA) - nvl(ln_icv, 0);
    --interes moratorio
    ln_morDif := (round((Power(1 + (pn_tmor / 100), (pn_dia / 360)) - 1) *
                        ((pn_cap - nvl(pn_capP, 0)) +
                        (pn_int - nvl(pn_intP, 0))),
                        2) + pn_morA) - nvl(ln_mor, 0);
  
  end Sp_cr_CalculoParciales;

end pq_cr_reproc_cuotaMora;
/

