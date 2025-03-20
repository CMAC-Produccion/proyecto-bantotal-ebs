create or replace package PQ_CR_RATIO_PARALELO is

  -- Author  : MPOSTIGOC
  -- Created : 13/10/2020 10:18:55 a. m.
  -- Purpose : 

  procedure sp_InicioRatio(Instancia        in number,
                           pd_fecpro        in date,
                           lc_prgm          in varchar2,
                           lc_Usuario       in varchar2,
                           ln_DeudaCMAC     out number,
                           ln_NivelVenta    out number,
                           ln_RatioParalelo out number);
  --------------------------------------------------------
  procedure sp_InicioRatio_rep(Instancia        in number,
                           pd_fecpro        in date,
                           lc_prgm          in varchar2,
                           lc_Usuario       in varchar2,
                           ln_DeudaCMAC     out number,
                           ln_NivelVenta    out number,
                           ln_RatioParalelo out number);
  ---------------------------------------------------
  procedure sp_InicioRatio_DTEN(ln_corre         in number,
                                ld_fchcorre      in date,
                                pd_fecpro        in date,
                                lc_Usuario       in varchar2,
                                ln_mntprop       in number,
                                ln_DeudaCMAC     out number,
                                ln_NivelVenta    out number,
                                ln_RatioParalelo out number);
  ------------------------------------------------------
  procedure sp_cr_nrocuotas(ln_pgcod10   in number,
                            ln_mod10     in number,
                            ln_suc10     in number,
                            ln_mda10     in number,
                            ln_pap10     in number,
                            ln_cta10     in number,
                            ln_oper10    in number,
                            ln_sbop10    in number,
                            ln_tope10    in number,
                            ln_nrocuotas out number);
  --------------------------------------------------------
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in char,
                         Instancia    in number,
                         pd_fecpro    in date,
                         ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         tipocambio   in number,
                         lc_IndCred   in varchar2,
                         lc_EjecRatio in varchar2,
                         lc_Usuario   in varchar2,
                         ln_Tarea     in number,
                         ln_SaldCap   out number);
  --------------------------------------------------------
  procedure sp_resolutor_rep(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in char,
                         Instancia    in number,
                         pd_fecpro    in date,
                         ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         tipocambio   in number,
                         lc_IndCred   in varchar2,
                         lc_EjecRatio in varchar2,
                         lc_Usuario   in varchar2,
                         ln_Tarea     in number,
                         lc_estado    in varchar2,
                         ln_SaldCap   out number);
  --------------------------------------------------------------
  procedure sp_resolutor_DT(ln_Pepais    in number,
                            ln_Petdoc    in number,
                            ln_Pendoc    in char,
                            ln_corre     in number,
                            ld_fchcorre  in date,
                            pd_fecpro    in date,
                            ln_pgcod10   in number,
                            ln_mod10     in number,
                            ln_suc10     in number,
                            ln_mda10     in number,
                            ln_pap10     in number,
                            ln_cta10     in number,
                            ln_oper10    in number,
                            ln_sbop10    in number,
                            ln_tope10    in number,
                            tipocambio   in number,
                            lc_IndCred   in varchar2,
                            lc_EjecRatio in varchar2,
                            lc_Usuario   in varchar2,
                            ln_SaldCap   out number);
  ---------------------------------------------------------
  procedure sp_resolutor_prop(ln_Pepais      in number,
                              ln_Petdoc      in number,
                              ln_Pendoc      in char,
                              ln_Correlativo in number,
                              ld_fchcorre    in date,
                              pd_fecpro      in date,
                              ln_pgcod10     in number,
                              ln_mod10       in number,
                              ln_suc10       in number,
                              ln_mda10       in number,
                              ln_pap10       in number,
                              ln_cta10       in number,
                              ln_oper10      in number,
                              ln_sbop10      in number,
                              ln_tope10      in number,
                              ln_nrocuotas   in number,
                              tipocambio     in number,
                              lc_IndCred     in varchar2,
                              lc_Usuario     in varchar2,
                              ln_saldo       in number);
  -----------------------------------------------------------
  procedure sp_cr_saldocapital(ln_pgcod10  in number,
                               ln_mod10    in number,
                               ln_suc10    in number,
                               ln_mda10    in number,
                               ln_pap10    in number,
                               ln_cta10    in number,
                               ln_oper10   in number,
                               ln_sbop     in number,
                               ln_tope10   in number,
                               tipocambio  in number,
                               ln_saldocap out number);
  ----------------------------------------------------------------
  procedure sp_cr_logcAQPA383(ln_Pepais  in number,
                              ln_Petdoc  in number,
                              ln_Pendoc  in varchar2,
                              tipocambio in number,
                              pd_fecpro  in date,
                              Instancia  in number,
                              ln_deucmac in number,
                              ln_niventa in number,
                              ln_ratio   in number,
                              lc_usuario in varchar2,
                              lc_tarea   in number);
  ------------------------------------------------------------
  procedure sp_cr_logcAQPA383a(ln_Pepais  in number,
                               ln_Petdoc  in number,
                               ln_Pendoc  in varchar2,
                               tipocambio in number,
                               pd_fecpro  in date,
                               ln_corr    in number,
                               ld_fchcor  in date,
                               ln_deucmac in number,
                               ln_niventa in number,
                               ln_ratio   in number,
                               lc_usuario in varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_LogDetAQPA384(ld_fec   in date,
                                ln_pais  in number,
                                ln_tdoc  in number,
                                lc_ndoc  in varchar2,
                                ln_tcamb in number,
                                ln_inst  in number,
                                ln_pgcod in number,
                                ln_mod   in number,
                                ln_suc   in number,
                                ln_mda   in number,
                                ln_pap   in number,
                                ln_cta   in number,
                                ln_ope   in number,
                                ln_sbop  in number,
                                ln_tope  in number,
                                ln_nrcuo in number,
                                ln_saldo in number,
                                ld_indic in varchar2,
                                lc_user  in varchar2,
                                ln_tarea in number);
  -----------------------------------------------------------------------
  procedure sp_cr_LogDetAQPA384a(ld_fec    in date,
                                 ln_pais   in number,
                                 ln_tdoc   in number,
                                 lc_ndoc   in varchar2,
                                 ln_tcamb  in number,
                                 ln_corr   in number,
                                 ld_fchcor in date,
                                 ln_pgcod  in number,
                                 ln_mod    in number,
                                 ln_suc    in number,
                                 ln_mda    in number,
                                 ln_pap    in number,
                                 ln_cta    in number,
                                 ln_ope    in number,
                                 ln_sbop   in number,
                                 ln_tope   in number,
                                 ln_nrcuo  in number,
                                 ln_saldo  in number,
                                 ld_indic  in varchar2,
                                 lc_user   in varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_logcAQPA383_rep(ln_Pepais  in number,
                              ln_Petdoc  in number,
                              ln_Pendoc  in varchar2,
                              tipocambio in number,
                              pd_fecpro  in date,
                              Instancia  in number,
                              ln_deucmac in number,
                              ln_niventa in number,
                              ln_ratio   in number,
                              lc_usuario in varchar2,
                              lc_tarea   in number,
                              lc_estado  in varchar2);
  
  ------------------------------------------------------------------
  procedure sp_cr_LogDetAQPA384_rep(ld_fec   in date,
                                ln_pais  in number,
                                ln_tdoc  in number,
                                lc_ndoc  in varchar2,
                                ln_tcamb in number,
                                ln_inst  in number,
                                ln_pgcod in number,
                                ln_mod   in number,
                                ln_suc   in number,
                                ln_mda   in number,
                                ln_pap   in number,
                                ln_cta   in number,
                                ln_ope   in number,
                                ln_sbop  in number,
                                ln_tope  in number,
                                ln_nrcuo in number,
                                ln_saldo in number,
                                ld_indic in varchar2,
                                lc_user  in varchar2,
                                ln_tarea in number,
                                lc_estado  in varchar2);
  
                                 
end PQ_CR_RATIO_PARALELO;
/

create or replace package body PQ_CR_RATIO_PARALELO is

  ----------------------------------------------------------------------------------
  procedure sp_InicioRatio(Instancia        in number,
                           pd_fecpro        in date,
                           lc_prgm          in varchar2,
                           lc_Usuario       in varchar2,
                           ln_DeudaCMAC     out number,
                           ln_NivelVenta    out number,
                           ln_RatioParalelo out number) is
  
    cursor inserta_vencidos(ln_Pepais number,
                            ln_Petdoc number,
                            ln_Pendoc varchar2) is
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)))
         and d10.Aostat <> 99
         and d10.aofvto < pd_fecpro;
  
    cursor inserta(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro;
  
    cursor vuelo(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             x.xwfprcins    ln_InstVuelo
        from sng001 s, wfwrkitems w, xwf700 x
       where s.sng001pais = ln_Pepais
         and s.sng001tdoc = ln_Petdoc
         and s.sng001ndoc = ln_Pendoc
         and s.sng001inst = w.wfinsprcid
         and w.wfitemstsact = 1
         and w.wfinsprcid = x.xwfprcins
         and x.xwfcar3 = '1';
  
    lc_FlgLn      varchar2(2);
    lc_fgAdic     varchar2(1); --mod 2016.04.12
    lc_fgAmpl     varchar2(1); --mod 2016.04.12
    ln_indicador  number(10); --mod 2016.04.12
    lc_fgRefLin   varchar2(1); -- 28/06/16 mpostigoc
    lc_IndCred    varchar2(10);
    ln_tipocambio number;
    lc_EjecRatio  varchar2(5) := 'N';
    ln_Tarea      number(10);
    ln_Pepais     number;
    ln_Petdoc     number;
    ln_Pendoc     varchar2(12);
    ln_capacidad  number(17, 2) := 0.00;
    evaluacion    number;
    mntsoles      number(17, 2) := 0.00;
    mntdolar      number(17, 2) := 0.00;
    ln_captotal1  number(17, 6) := 0.00;
  
  begin
  
    ln_DeudaCMAC := 0;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      select 'S'
        into lc_EjecRatio
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.TP1CORR2 = 51
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    if lc_EjecRatio = 'S' then
    
      begin
        UPDATE aqpa383 a
           set a.aqpa383est = 'I'
         where a.aqpa383inst = Instancia
           and a.aqpa383est = 'H'
           and a.aqpa383tarea = ln_Tarea;
      
        update aqpa384 a
           set a.aqpa384est = 'I'
         where a.aqpa384inst = Instancia
           and a.aqpa384est = 'H'
           and a.aqpa384tarea = ln_Tarea;
        commit;
      end;
    
    end if;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 1;
    end;
  
    if ln_tipocambio = 1 then
    
      ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
    
    end if;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = Instancia;
    exception
      when others then
        null;
    end;
  
    for i in inserta(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
    
      pq_cr_resolutor_cappago.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
    
      pq_cr_resolutor_cappago.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' and
         i.ln_tope10 <> 550 then
        pq_cr_ratio_paralelo.sp_resolutor(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          Instancia,
                                          pd_fecpro,
                                          i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          ln_tipocambio,
                                          lc_IndCred,
                                          lc_EjecRatio,
                                          lc_Usuario,
                                          ln_Tarea,
                                          ln_capacidad);
        ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for i in inserta_vencidos(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      pq_cr_resolutor_cappago.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
    
      pq_cr_resolutor_cappago.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' and
         i.ln_tope10 <> 550 then
      
        pq_cr_ratio_paralelo.sp_resolutor(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          Instancia,
                                          pd_fecpro,
                                          i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          ln_tipocambio,
                                          lc_IndCred,
                                          lc_EjecRatio,
                                          lc_Usuario,
                                          ln_Tarea,
                                          ln_capacidad);
      
        ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
      
      end if;
    end loop;
  
    for c in vuelo(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      pq_cr_ratio_paralelo.sp_resolutor(ln_Pepais,
                                        ln_Petdoc,
                                        ln_Pendoc,
                                        Instancia,
                                        pd_fecpro,
                                        c.ln_pgcod10,
                                        c.ln_mod10,
                                        c.ln_suc10,
                                        c.ln_mda10,
                                        c.ln_pap10,
                                        c.ln_cta10,
                                        c.ln_oper10,
                                        c.ln_sbop10,
                                        c.ln_tope10,
                                        ln_tipocambio,
                                        lc_IndCred,
                                        lc_EjecRatio,
                                        lc_Usuario,
                                        ln_Tarea,
                                        ln_capacidad);
    
      ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
    
    end loop;
  
    --- Venta
  
    begin
      select a.sng021eval
        into evaluacion
        from sng021 a
       where a.sng021sol = Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng023mto
        into mntsoles
        from sng023 a
       where a.sng021eval = evaluacion
         and a.sng026cod = 73;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng023mto
        into mntdolar
        from sng023 a
       where a.sng021eval = evaluacion
         and a.sng026cod = 573;
    exception
      when others then
        null;
    end;
  
    ln_NivelVenta := ((mntdolar * ln_tipocambio) + mntsoles);
    ln_NivelVenta := nvl(ln_NivelVenta, 0);
    ln_NivelVenta := round(ln_NivelVenta, 2);
  
    if ln_NivelVenta > 0 then
    
      ln_captotal1 := round((ln_DeudaCMAC / ln_NivelVenta), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    ln_RatioParalelo := nvl(ln_captotal1, 0);
  
    if lc_EjecRatio = 'S' then
      pq_cr_ratio_paralelo.sp_cr_logcAQPA383(ln_Pepais  => ln_Pepais,
                                             ln_Petdoc  => ln_Petdoc,
                                             ln_Pendoc  => ln_Pendoc,
                                             tipocambio => ln_tipocambio,
                                             pd_fecpro  => pd_fecpro,
                                             Instancia  => Instancia,
                                             ln_deucmac => ln_DeudaCMAC,
                                             ln_niventa => ln_NivelVenta,
                                             ln_ratio   => ln_RatioParalelo,
                                             lc_usuario => lc_Usuario,
                                             lc_tarea   => ln_Tarea);
    end if;
  
  end sp_InicioRatio;
   ----------------------------------------------------------------------------------
  procedure sp_InicioRatio_rep(Instancia        in number,
                           pd_fecpro        in date,
                           lc_prgm          in varchar2,
                           lc_Usuario       in varchar2,
                           ln_DeudaCMAC     out number,
                           ln_NivelVenta    out number,
                           ln_RatioParalelo out number) is
  
    cursor inserta_vencidos(ln_Pepais number,
                            ln_Petdoc number,
                            ln_Pendoc varchar2) is
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)))
         and d10.Aostat <> 99
         and d10.aofvto < pd_fecpro;
  
    cursor inserta(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro;
  
    cursor vuelo(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             x.xwfprcins    ln_InstVuelo
        from sng001 s, wfwrkitems w, xwf700 x
       where s.sng001pais = ln_Pepais
         and s.sng001tdoc = ln_Petdoc
         and s.sng001ndoc = ln_Pendoc
         and s.sng001inst = w.wfinsprcid
         and w.wfitemstsact = 1
         and w.wfinsprcid = x.xwfprcins
         and x.xwfcar3 = '1';
  
    lc_FlgLn      varchar2(2);
    lc_fgAdic     varchar2(1); --mod 2016.04.12
    lc_fgAmpl     varchar2(1); --mod 2016.04.12
    ln_indicador  number(10); --mod 2016.04.12
    lc_fgRefLin   varchar2(1); -- 28/06/16 mpostigoc
    lc_IndCred    varchar2(10);
    ln_tipocambio number;
    lc_EjecRatio  varchar2(5) := 'N';
    ln_Tarea      number(10);
    ln_Pepais     number;
    ln_Petdoc     number;
    ln_Pendoc     varchar2(12);
    ln_capacidad  number(17, 2) := 0.00;
    evaluacion    number;
    mntsoles      number(17, 2) := 0.00;
    mntdolar      number(17, 2) := 0.00;
    ln_captotal1  number(17, 6) := 0.00;
    lc_flgprg     varchar2(1);
  
  begin
  
    ln_DeudaCMAC := 0;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      select 'S'
        into lc_EjecRatio
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.TP1CORR2 = 51
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
    
    if lc_prgm = 'RJAQY843' then     
    
      lc_flgprg := 'R';
    
      begin
        delete aqpa384 J
         WHERE J.aqpa384INST = Instancia
           and j.aqpa384est = 'R';
      end;
      begin
        delete aqpa383 J
         WHERE J.aqpa383INST = Instancia
           and j.aqpa383est = 'R';
      end;
    
    end if;
  
    if lc_EjecRatio = 'S'  and lc_flgprg <> 'R' then
    
      begin
        UPDATE aqpa383 a
           set a.aqpa383est = 'I'
         where a.aqpa383inst = Instancia
           and a.aqpa383est = 'H'
           and a.aqpa383tarea = ln_Tarea;
      
        update aqpa384 a
           set a.aqpa384est = 'I'
         where a.aqpa384inst = Instancia
           and a.aqpa384est = 'H'
           and a.aqpa384tarea = ln_Tarea;
        commit;
      end;
    
    end if;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 1;
    end;
  
    if ln_tipocambio = 1 then
    
      ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
    
    end if;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = Instancia;
    exception
      when others then
        null;
    end;
  
    for i in inserta(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
    
      pq_cr_resolutor_cappago.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
    
      pq_cr_resolutor_cappago.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' and
         i.ln_tope10 <> 550 then
        pq_cr_ratio_paralelo.sp_resolutor_rep(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          Instancia,
                                          pd_fecpro,
                                          i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          ln_tipocambio,
                                          lc_IndCred,
                                          lc_EjecRatio,
                                          lc_Usuario,
                                          ln_Tarea,
                                          lc_flgprg,
                                          ln_capacidad);
        ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for i in inserta_vencidos(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      pq_cr_resolutor_cappago.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
    
      pq_cr_resolutor_cappago.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' and
         i.ln_tope10 <> 550 then
      
        pq_cr_ratio_paralelo.sp_resolutor_rep(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          Instancia,
                                          pd_fecpro,
                                          i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          ln_tipocambio,
                                          lc_IndCred,
                                          lc_EjecRatio,
                                          lc_Usuario,
                                          ln_Tarea,
                                          lc_flgprg,
                                          ln_capacidad);
      
        ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
      
      end if;
    end loop;
  
    for c in vuelo(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      pq_cr_ratio_paralelo.sp_resolutor_rep(ln_Pepais,
                                        ln_Petdoc,
                                        ln_Pendoc,
                                        Instancia,
                                        pd_fecpro,
                                        c.ln_pgcod10,
                                        c.ln_mod10,
                                        c.ln_suc10,
                                        c.ln_mda10,
                                        c.ln_pap10,
                                        c.ln_cta10,
                                        c.ln_oper10,
                                        c.ln_sbop10,
                                        c.ln_tope10,
                                        ln_tipocambio,
                                        lc_IndCred,
                                        lc_EjecRatio,
                                        lc_Usuario,
                                        ln_Tarea,
                                        lc_flgprg,
                                        ln_capacidad);
    
      ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
    
    end loop;
  
    --- Venta
  
    begin
      select a.sng021eval
        into evaluacion
        from sng021 a
       where a.sng021sol = Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng023mto
        into mntsoles
        from sng023 a
       where a.sng021eval = evaluacion
         and a.sng026cod = 73;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng023mto
        into mntdolar
        from sng023 a
       where a.sng021eval = evaluacion
         and a.sng026cod = 573;
    exception
      when others then
        null;
    end;
  
    ln_NivelVenta := ((mntdolar * ln_tipocambio) + mntsoles);
    ln_NivelVenta := nvl(ln_NivelVenta, 0);
    ln_NivelVenta := round(ln_NivelVenta, 2);
  
    if ln_NivelVenta > 0 then
    
      ln_captotal1 := round((ln_DeudaCMAC / ln_NivelVenta), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    ln_RatioParalelo := nvl(ln_captotal1, 0);
  
    if lc_EjecRatio = 'S' then
      pq_cr_ratio_paralelo.sp_cr_logcAQPA383_rep(ln_Pepais  => ln_Pepais,
                                             ln_Petdoc  => ln_Petdoc,
                                             ln_Pendoc  => ln_Pendoc,
                                             tipocambio => ln_tipocambio,
                                             pd_fecpro  => pd_fecpro,
                                             Instancia  => Instancia,
                                             ln_deucmac => ln_DeudaCMAC,
                                             ln_niventa => ln_NivelVenta,
                                             ln_ratio   => ln_RatioParalelo,
                                             lc_usuario => lc_Usuario,
                                             lc_tarea   => ln_Tarea,
                                             lc_estado  => lc_flgprg);
    end if;
  
  end sp_InicioRatio_rep;
  ----------------------------------------------------------------------------------
  procedure sp_InicioRatio_DTEN(ln_corre         in number,
                                ld_fchcorre      in date,
                                pd_fecpro        in date,
                                lc_Usuario       in varchar2,
                                ln_mntprop       in number,
                                ln_DeudaCMAC     out number,
                                ln_NivelVenta    out number,
                                ln_RatioParalelo out number) is
  
    cursor inserta_vencidos(ln_Pepais number,
                            ln_Petdoc number,
                            ln_Pendoc varchar2) is
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)))
         and d10.Aostat <> 99
         and d10.aofvto < pd_fecpro;
  
    cursor inserta(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro;
  
    cursor vuelo(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             x.xwfprcins    ln_InstVuelo
        from sng001 s, wfwrkitems w, xwf700 x
       where s.sng001pais = ln_Pepais
         and s.sng001tdoc = ln_Petdoc
         and s.sng001ndoc = ln_Pendoc
         and s.sng001inst = w.wfinsprcid
         and w.wfitemstsact = 1
         and w.wfinsprcid = x.xwfprcins
         and x.xwfcar3 = '1';
  
    cursor cred_propuesto is
      select 1            ln_pgcod10,
             j.jaqz697mod ln_mod10,
             j.jaqz697suc ln_suc10,
             j.jaqz697mda ln_mda10,
             0            ln_pap10,
             j.jaqz697cta ln_cta10,
             j.jaqz697opa ln_oper10,
             0            ln_sbop10,
             j.jaqz697top ln_tope10,
             j.jaqz697cuo ln_nrocuotas
        from jaqz697 j
       where j.jaqz697fep = ld_fchcorre
         and j.jaqz697cor = ln_corre;
  
    lc_FlgLn      varchar2(2);
    lc_fgAdic     varchar2(1); --mod 2016.04.12
    lc_fgAmpl     varchar2(1); --mod 2016.04.12
    ln_indicador  number(10); --mod 2016.04.12
    lc_fgRefLin   varchar2(1); -- 28/06/16 mpostigoc
    lc_IndCred    varchar2(10);
    ln_tipocambio number;
    lc_EjecRatio  varchar2(5) := 'S';
    ln_Pepais     number;
    ln_Petdoc     number;
    ln_Pendoc     varchar2(12);
    ln_capacidad  number(17, 2) := 0.00;
    mntsoles      number(17, 2) := 0.00;
    mntdolar      number(17, 2) := 0.00;
    ln_captotal1  number(17, 6) := 0.000000;
    ln_NroEval    number(10) := 0.00;
  
  begin
  
    ln_DeudaCMAC := 0;
  
    begin
      select j.jaqz697pai, j.jaqz697tdo, j.jaqz697ndo
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from jaqz697 j
       where j.jaqz697fep = ld_fchcorre
         and j.jaqz697cor = ln_corre;
    exception
      when others then
        null;
    end;
  
    if lc_EjecRatio = 'S' then
    
      begin
        UPDATE aqpa383a a
           set a.aqpa383aest = 'I'
         where a.aqpa383acorrp = ln_corre
           and a.aqpa383afchcor = ld_fchcorre
           and a.aqpa383aest = 'H';
      
        update aqpa384a a
           set a.aqpa384aest = 'I'
         where a.aqpa384acorrp = ln_corre
           and a.aqpa384afchcor = ld_fchcorre
           and a.aqpa384aest = 'H';
        commit;
      end;
    
    end if;
  
    ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
  
    for i in inserta(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
    
      pq_cr_resolutor_cappago.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
    
      pq_cr_resolutor_cappago.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' and
         i.ln_tope10 <> 550 then
        pq_cr_ratio_paralelo.sp_resolutor_DT(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             ln_corre,
                                             ld_fchcorre,
                                             pd_fecpro,
                                             i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             ln_tipocambio,
                                             lc_IndCred,
                                             lc_EjecRatio,
                                             lc_Usuario,
                                             ln_capacidad);
      
        ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for i in inserta_vencidos(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      pq_cr_resolutor_cappago.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
    
      pq_cr_resolutor_cappago.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' and
         i.ln_tope10 <> 550 then
      
        pq_cr_ratio_paralelo.sp_resolutor_DT(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             ln_corre,
                                             ld_fchcorre,
                                             pd_fecpro,
                                             i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             ln_tipocambio,
                                             lc_IndCred,
                                             lc_EjecRatio,
                                             lc_Usuario,
                                             ln_capacidad);
      
        ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
      
      end if;
    end loop;
  
    for c in vuelo(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      pq_cr_ratio_paralelo.sp_resolutor_DT(ln_Pepais,
                                           ln_Petdoc,
                                           ln_Pendoc,
                                           ln_corre,
                                           ld_fchcorre,
                                           pd_fecpro,
                                           c.ln_pgcod10,
                                           c.ln_mod10,
                                           c.ln_suc10,
                                           c.ln_mda10,
                                           c.ln_pap10,
                                           c.ln_cta10,
                                           c.ln_oper10,
                                           c.ln_sbop10,
                                           c.ln_tope10,
                                           ln_tipocambio,
                                           lc_IndCred,
                                           lc_EjecRatio,
                                           lc_Usuario,
                                           ln_capacidad);
    
      ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_capacidad, 0);
    
    end loop;
  
    for p in cred_propuesto loop
      pq_cr_ratio_paralelo.sp_resolutor_prop(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             ln_corre,
                                             ld_fchcorre,
                                             pd_fecpro,
                                             p.ln_pgcod10,
                                             p.ln_mod10,
                                             p.ln_suc10,
                                             p.ln_mda10,
                                             p.ln_pap10,
                                             p.ln_cta10,
                                             p.ln_oper10,
                                             p.ln_sbop10,
                                             p.ln_tope10,
                                             p.ln_nrocuotas,
                                             ln_tipocambio,
                                             'CredProp',
                                             lc_Usuario,
                                             ln_mntprop);
      ln_DeudaCMAC := nvl(ln_DeudaCMAC, 0) + nvl(ln_mntprop, 0);
    end loop;
  
    --- Nivel de Venta
  
    -- Deuda IFIS y Cuota Potencial
    begin
      select y.jaqz697eva
        into ln_NroEval
        from jaqz697 y
       where y.jaqz697fep = ld_fchcorre
         and y.jaqz697cor = ln_corre;
    exception
      when others then
        ln_NroEval := 0;
    end;
  
    begin
      select a.aqpa190bmto
        into mntsoles
        from aqpa190b_bdj a
       where a.aqpa190beval = ln_NroEval
         and a.aqpa190bcod = 73;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpa190bmto
        into mntdolar
        from aqpa190b_bdj a
       where a.aqpa190beval = ln_NroEval
         and a.aqpa190bcod = 573;
    exception
      when others then
        null;
    end;
  
    ln_NivelVenta := ((mntdolar * ln_tipocambio) + mntsoles);
    ln_NivelVenta := nvl(ln_NivelVenta, 0);
    ln_NivelVenta := round(ln_NivelVenta, 2);
  
    if ln_NivelVenta > 0 then
    
      ln_captotal1 := round((ln_DeudaCMAC / ln_NivelVenta), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    ln_RatioParalelo := nvl(ln_captotal1, 0);
  
    pq_cr_ratio_paralelo.sp_cr_logcAQPA383a(ln_Pepais  => ln_Pepais,
                                            ln_Petdoc  => ln_Petdoc,
                                            ln_Pendoc  => ln_Pendoc,
                                            tipocambio => ln_tipocambio,
                                            pd_fecpro  => pd_fecpro,
                                            ln_corr    => ln_corre,
                                            ld_fchcor  => ld_fchcorre,
                                            ln_deucmac => ln_DeudaCMAC,
                                            ln_niventa => ln_NivelVenta,
                                            ln_ratio   => ln_RatioParalelo,
                                            lc_usuario => lc_Usuario);
  
  end sp_InicioRatio_DTEN;
  -------------------------------------------------------------------------
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in char,
                         Instancia    in number,
                         pd_fecpro    in date,
                         ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         tipocambio   in number,
                         lc_IndCred   in varchar2,
                         lc_EjecRatio in varchar2,
                         lc_Usuario   in varchar2,
                         ln_Tarea     in number,
                         ln_SaldCap   out number) is
  
    ln_nrocuotas number(17);
  
  begin
  
    pq_cr_ratio_paralelo.sp_cr_nrocuotas(ln_pgcod10   => ln_pgcod10,
                                         ln_mod10     => ln_mod10,
                                         ln_suc10     => ln_suc10,
                                         ln_mda10     => ln_mda10,
                                         ln_pap10     => ln_pap10,
                                         ln_cta10     => ln_cta10,
                                         ln_oper10    => ln_oper10,
                                         ln_sbop10    => ln_sbop10,
                                         ln_tope10    => ln_tope10,
                                         ln_nrocuotas => ln_nrocuotas);
  
    if ln_mod10 = 105 or ln_nrocuotas = 1 then
      pq_cR_ratio_paralelo.sp_cr_saldocapital(ln_pgcod10  => ln_pgcod10,
                                              ln_mod10    => ln_mod10,
                                              ln_suc10    => ln_suc10,
                                              ln_mda10    => ln_mda10,
                                              ln_pap10    => ln_pap10,
                                              ln_cta10    => ln_cta10,
                                              ln_oper10   => ln_oper10,
                                              ln_sbop     => ln_sbop10,
                                              ln_tope10   => ln_tope10,
                                              tipocambio  => tipocambio,
                                              ln_saldocap => ln_SaldCap);
    
      ln_SaldCap := nvl(ln_SaldCap, 0);
    
    end if;
  
    if lc_EjecRatio = 'S' then
    
      if ln_SaldCap > 0 then
      
        pq_cr_ratio_paralelo.sp_cr_LogDetAQPA384(ld_fec   => pd_fecpro,
                                                 ln_pais  => ln_Pepais,
                                                 ln_tdoc  => ln_Petdoc,
                                                 lc_ndoc  => ln_Pendoc,
                                                 ln_tcamb => tipocambio,
                                                 ln_inst  => Instancia,
                                                 ln_pgcod => ln_pgcod10,
                                                 ln_mod   => ln_mod10,
                                                 ln_suc   => ln_suc10,
                                                 ln_mda   => ln_mda10,
                                                 ln_pap   => ln_pap10,
                                                 ln_cta   => ln_cta10,
                                                 ln_ope   => ln_oper10,
                                                 ln_sbop  => ln_sbop10,
                                                 ln_tope  => ln_tope10,
                                                 ln_nrcuo => ln_nrocuotas,
                                                 ln_saldo => ln_SaldCap,
                                                 ld_indic => lc_IndCred,
                                                 lc_user  => lc_Usuario,
                                                 ln_tarea => ln_Tarea);
      end if;
    end if;
  
  end sp_resolutor;
  -------------------------------------------------------------------------
  procedure sp_resolutor_rep(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in char,
                         Instancia    in number,
                         pd_fecpro    in date,
                         ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         tipocambio   in number,
                         lc_IndCred   in varchar2,
                         lc_EjecRatio in varchar2,
                         lc_Usuario   in varchar2,
                         ln_Tarea     in number,
                         lc_estado    in varchar2,
                         ln_SaldCap   out number) is
  
    ln_nrocuotas number(17);
  
  begin
  
    pq_cr_ratio_paralelo.sp_cr_nrocuotas(ln_pgcod10   => ln_pgcod10,
                                         ln_mod10     => ln_mod10,
                                         ln_suc10     => ln_suc10,
                                         ln_mda10     => ln_mda10,
                                         ln_pap10     => ln_pap10,
                                         ln_cta10     => ln_cta10,
                                         ln_oper10    => ln_oper10,
                                         ln_sbop10    => ln_sbop10,
                                         ln_tope10    => ln_tope10,
                                         ln_nrocuotas => ln_nrocuotas);
  
    if ln_mod10 = 105 or ln_nrocuotas = 1 then
      pq_cR_ratio_paralelo.sp_cr_saldocapital(ln_pgcod10  => ln_pgcod10,
                                              ln_mod10    => ln_mod10,
                                              ln_suc10    => ln_suc10,
                                              ln_mda10    => ln_mda10,
                                              ln_pap10    => ln_pap10,
                                              ln_cta10    => ln_cta10,
                                              ln_oper10   => ln_oper10,
                                              ln_sbop     => ln_sbop10,
                                              ln_tope10   => ln_tope10,
                                              tipocambio  => tipocambio,
                                              ln_saldocap => ln_SaldCap);
    
      ln_SaldCap := nvl(ln_SaldCap, 0);
    
    end if;
  
    if lc_EjecRatio = 'S' then
    
      if ln_SaldCap > 0 then
      
        pq_cr_ratio_paralelo.sp_cr_LogDetAQPA384_rep(ld_fec   => pd_fecpro,
                                                 ln_pais  => ln_Pepais,
                                                 ln_tdoc  => ln_Petdoc,
                                                 lc_ndoc  => ln_Pendoc,
                                                 ln_tcamb => tipocambio,
                                                 ln_inst  => Instancia,
                                                 ln_pgcod => ln_pgcod10,
                                                 ln_mod   => ln_mod10,
                                                 ln_suc   => ln_suc10,
                                                 ln_mda   => ln_mda10,
                                                 ln_pap   => ln_pap10,
                                                 ln_cta   => ln_cta10,
                                                 ln_ope   => ln_oper10,
                                                 ln_sbop  => ln_sbop10,
                                                 ln_tope  => ln_tope10,
                                                 ln_nrcuo => ln_nrocuotas,
                                                 ln_saldo => ln_SaldCap,
                                                 ld_indic => lc_IndCred,
                                                 lc_user  => lc_Usuario,
                                                 ln_tarea => ln_Tarea,
                                                 lc_estado=> lc_estado);
      end if;
    end if;
  
  end sp_resolutor_rep;
  -------------------------------------------------------------------------
  procedure sp_resolutor_DT(ln_Pepais    in number,
                            ln_Petdoc    in number,
                            ln_Pendoc    in char,
                            ln_corre     in number,
                            ld_fchcorre  in date,
                            pd_fecpro    in date,
                            ln_pgcod10   in number,
                            ln_mod10     in number,
                            ln_suc10     in number,
                            ln_mda10     in number,
                            ln_pap10     in number,
                            ln_cta10     in number,
                            ln_oper10    in number,
                            ln_sbop10    in number,
                            ln_tope10    in number,
                            tipocambio   in number,
                            lc_IndCred   in varchar2,
                            lc_EjecRatio in varchar2,
                            lc_Usuario   in varchar2,
                            ln_SaldCap   out number) is
  
    ln_nrocuotas number(17);
  
  begin
  
    pq_cr_ratio_paralelo.sp_cr_nrocuotas(ln_pgcod10   => ln_pgcod10,
                                         ln_mod10     => ln_mod10,
                                         ln_suc10     => ln_suc10,
                                         ln_mda10     => ln_mda10,
                                         ln_pap10     => ln_pap10,
                                         ln_cta10     => ln_cta10,
                                         ln_oper10    => ln_oper10,
                                         ln_sbop10    => ln_sbop10,
                                         ln_tope10    => ln_tope10,
                                         ln_nrocuotas => ln_nrocuotas);
  
    if ln_mod10 = 105 or ln_nrocuotas = 1 then
      pq_cR_ratio_paralelo.sp_cr_saldocapital(ln_pgcod10  => ln_pgcod10,
                                              ln_mod10    => ln_mod10,
                                              ln_suc10    => ln_suc10,
                                              ln_mda10    => ln_mda10,
                                              ln_pap10    => ln_pap10,
                                              ln_cta10    => ln_cta10,
                                              ln_oper10   => ln_oper10,
                                              ln_sbop     => ln_sbop10,
                                              ln_tope10   => ln_tope10,
                                              tipocambio  => tipocambio,
                                              ln_saldocap => ln_SaldCap);
    
      ln_SaldCap := nvl(ln_SaldCap, 0);
    
    end if;
  
    if lc_EjecRatio = 'S' then
    
      if ln_SaldCap > 0 then
      
        pq_cr_ratio_paralelo.sp_cr_LogDetAQPA384a(ld_fec    => pd_fecpro,
                                                  ln_pais   => ln_Pepais,
                                                  ln_tdoc   => ln_Petdoc,
                                                  lc_ndoc   => ln_Pendoc,
                                                  ln_tcamb  => tipocambio,
                                                  ln_corr   => ln_corre,
                                                  ld_fchcor => ld_fchcorre,
                                                  ln_pgcod  => ln_pgcod10,
                                                  ln_mod    => ln_mod10,
                                                  ln_suc    => ln_suc10,
                                                  ln_mda    => ln_mda10,
                                                  ln_pap    => ln_pap10,
                                                  ln_cta    => ln_cta10,
                                                  ln_ope    => ln_oper10,
                                                  ln_sbop   => ln_sbop10,
                                                  ln_tope   => ln_tope10,
                                                  ln_nrcuo  => ln_nrocuotas,
                                                  ln_saldo  => ln_SaldCap,
                                                  ld_indic  => lc_IndCred,
                                                  lc_user   => lc_Usuario);
      end if;
    end if;
  
  end sp_resolutor_DT;
  -----------------------------------------------------------
  procedure sp_resolutor_prop(ln_Pepais      in number,
                              ln_Petdoc      in number,
                              ln_Pendoc      in char,
                              ln_Correlativo in number,
                              ld_fchcorre    in date,
                              pd_fecpro      in date,
                              ln_pgcod10     in number,
                              ln_mod10       in number,
                              ln_suc10       in number,
                              ln_mda10       in number,
                              ln_pap10       in number,
                              ln_cta10       in number,
                              ln_oper10      in number,
                              ln_sbop10      in number,
                              ln_tope10      in number,
                              ln_nrocuotas   in number,
                              tipocambio     in number,
                              lc_IndCred     in varchar2,
                              lc_Usuario     in varchar2,
                              ln_saldo       in number) is
  
  begin
  
    PQ_CR_RATIO_PARALELO.sp_cr_LogDetAQPA384a(ld_fec    => pd_fecpro,
                                              ln_pais   => ln_Pepais,
                                              ln_tdoc   => ln_Petdoc,
                                              lc_ndoc   => ln_Pendoc,
                                              ln_tcamb  => tipocambio,
                                              ln_corr   => ln_Correlativo,
                                              ld_fchcor => ld_fchcorre,
                                              ln_pgcod  => ln_pgcod10,
                                              ln_mod    => ln_mod10,
                                              ln_suc    => ln_suc10,
                                              ln_mda    => ln_mda10,
                                              ln_pap    => ln_pap10,
                                              ln_cta    => ln_cta10,
                                              ln_ope    => ln_oper10,
                                              ln_sbop   => ln_sbop10,
                                              ln_tope   => ln_tope10,
                                              ln_nrcuo  => ln_nrocuotas,
                                              ln_saldo  => ln_saldo,
                                              ld_indic  => lc_IndCred,
                                              lc_user   => lc_Usuario);
  
  end sp_resolutor_prop;

  ----------------------------------------------------------
  procedure sp_cr_nrocuotas(ln_pgcod10   in number,
                            ln_mod10     in number,
                            ln_suc10     in number,
                            ln_mda10     in number,
                            ln_pap10     in number,
                            ln_cta10     in number,
                            ln_oper10    in number,
                            ln_sbop10    in number,
                            ln_tope10    in number,
                            ln_nrocuotas out number) is
  begin
    begin
      select x.xllcantcuo
        into ln_nrocuotas
        from x054023 x
       where x.xllpgcod = ln_pgcod10
         and x.xllaomod = ln_mod10
         and x.xllaosuc = ln_suc10
         and x.xllaomda = ln_mda10
         and x.xllaopap = ln_pap10
         and x.xllaocta = ln_cta10
         and x.xllaooper = ln_oper10
         and x.xllaosbop = ln_sbop10
         and x.xllaotop = ln_tope10;
    exception
      when others then
        ln_nrocuotas := 0;
    end;
  
  end sp_cr_nrocuotas;
  --------------------------------------------------------------------------------

  procedure sp_cr_saldocapital(ln_pgcod10  in number,
                               ln_mod10    in number,
                               ln_suc10    in number,
                               ln_mda10    in number,
                               ln_pap10    in number,
                               ln_cta10    in number,
                               ln_oper10   in number,
                               ln_sbop     in number,
                               ln_tope10   in number,
                               tipocambio  in number,
                               ln_saldocap out number) is
  
  begin
  
    begin
      select scsdo
        into ln_saldocap
        from fsd011
       where PGCOD = ln_pgcod10
         and SCMOD = ln_mod10
         and SCMDA = ln_mda10
         and SCPAP = ln_pap10
         and SCCTA = ln_cta10
         and SCSUC = ln_suc10
         and SCOPER = ln_oper10
         and scsbop = ln_sbop
         and sctope = ln_tope10
         and scstat <> 99;
    exception
      when others then
        null;
    end;
  
    if ln_saldocap is null then
    
      begin
        select x.xllcapital
          into ln_saldocap
          from x054023 x
         where x.xllpgcod = ln_pgcod10
           and x.xllaomod = ln_mod10
           and x.xllaosuc = ln_suc10
           and x.xllaomda = ln_mda10
           and x.xllaopap = ln_pap10
           and x.xllaocta = ln_cta10
           and x.xllaooper = ln_oper10
           and x.xllaosbop = ln_sbop
           and x.xllaotop = ln_tope10;
      end;
    
    end if;
  
    if ln_mda10 = 101 then
      ln_saldocap := ln_saldocap * tipocambio;
    end if;
  
    if ln_saldocap < 0 then
      ln_saldocap := ln_saldocap * -1;
    end if;
  
  end sp_cr_saldocapital;
  ------------------------------------------------------
  procedure sp_cr_logcAQPA383(ln_Pepais  in number,
                              ln_Petdoc  in number,
                              ln_Pendoc  in varchar2,
                              tipocambio in number,
                              pd_fecpro  in date,
                              Instancia  in number,
                              ln_deucmac in number,
                              ln_niventa in number,
                              ln_ratio   in number,
                              lc_usuario in varchar2,
                              lc_tarea   in number) is
  
    ln_corr   number := 0;
    lc_IndEst varchar2(5) := 'H';
    lc_hora   char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpa383corr)
        into ln_corr
        from aqpa383 a
       where a.aqpa383fec = pd_fecpro
         and a.aqpa383inst = Instancia;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr   := nvl(ln_corr, 0);
    lc_IndEst := 'H';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa383
        (aqpa383corr,
         aqpa383pais,
         aqpa383tdoc,
         aqpa383ndoc,
         aqpa383tcamb,
         aqpa383fec,
         aqpa383inst,
         aqpa383deucmac,
         aqpa383niventa,
         aqpa383ratio,
         aqpa383est,
         aqpa383hora,
         aqpa383user,
         aqpa383tarea)
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         tipocambio,
         pd_fecpro,
         Instancia,
         ln_deucmac,
         ln_niventa,
         ln_ratio,
         lc_IndEst,
         lc_hora,
         lc_usuario,
         lc_tarea);
      commit;
    end;
  
  end sp_cr_logcAQPA383;
  ---------------------------------------------------
  procedure sp_cr_logcAQPA383a(ln_Pepais  in number,
                               ln_Petdoc  in number,
                               ln_Pendoc  in varchar2,
                               tipocambio in number,
                               pd_fecpro  in date,
                               ln_corr    in number,
                               ld_fchcor  in date,
                               ln_deucmac in number,
                               ln_niventa in number,
                               ln_ratio   in number,
                               lc_usuario in varchar2) is
  
    ln_corre  number := 0;
    lc_IndEst varchar2(5) := 'H';
    lc_hora   char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpa383acorr)
        into ln_corre
        from aqpa383a a
       where a.aqpa383afec = pd_fecpro
         and a.aqpa383acorrp = ln_corr
         and a.aqpa383afchcor = ld_fchcor;
    exception
      when others then
        ln_corre := 0;
    end;
  
    ln_corre  := nvl(ln_corre, 0);
    lc_IndEst := 'H';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa383a
        (aqpa383acorr,
         aqpa383apais,
         aqpa383atdoc,
         aqpa383andoc,
         aqpa383atcamb,
         aqpa383afec,
         aqpa383acorrp,
         aqpa383afchcor,
         aqpa383adeucmac,
         aqpa383aniventa,
         aqpa383aratio,
         aqpa383aest,
         aqpa383ahora,
         aqpa383auser)
      values
        (ln_corre + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         tipocambio,
         pd_fecpro,
         ln_corr,
         ld_fchcor,
         ln_deucmac,
         ln_niventa,
         ln_ratio,
         lc_IndEst,
         lc_hora,
         lc_usuario);
      commit;
    end;
  
  end sp_cr_logcAQPA383a;
  ---------------------------------------------------------------------------
  procedure sp_cr_LogDetAQPA384(ld_fec   in date,
                                ln_pais  in number,
                                ln_tdoc  in number,
                                lc_ndoc  in varchar2,
                                ln_tcamb in number,
                                ln_inst  in number,
                                ln_pgcod in number,
                                ln_mod   in number,
                                ln_suc   in number,
                                ln_mda   in number,
                                ln_pap   in number,
                                ln_cta   in number,
                                ln_ope   in number,
                                ln_sbop  in number,
                                ln_tope  in number,
                                ln_nrcuo in number,
                                ln_saldo in number,
                                ld_indic in varchar2,
                                lc_user  in varchar2,
                                ln_tarea in number) is
    ln_corr   number := 0;
    lc_IndEst varchar2(5) := 'H';
    lc_hora   char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpa384corr)
        into ln_corr
        from aqpa384 a
       where a.aqpa384fec = ld_fec
         and a.aqpa384inst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr   := nvl(ln_corr, 0);
    lc_IndEst := 'H';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa384
        (aqpa384corr,
         aqpa384fec,
         aqpa384hora,
         aqpa384pais,
         aqpa384tdoc,
         aqpa384ndoc,
         aqpa384tcamb,
         aqpa384inst,
         aqpa384pgcod,
         aqpa384mod,
         aqpa384suc,
         aqpa384mda,
         aqpa384pap,
         aqpa384cta,
         aqpa384ope,
         aqpa384sbop,
         aqpa384tope,
         aqpa384nrcuo,
         aqpa384saldo,
         aqpa384indic,
         aqpa384est,
         aqpa384user,
         aqpa384tarea)
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_tcamb,
         ln_inst,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_nrcuo,
         ln_saldo,
         ld_indic,
         lc_IndEst,
         lc_user,
         ln_tarea);
    
      commit;
    
    end;
  end sp_cr_LogDetAQPA384;
  -----------------------------------------------------------------------
  procedure sp_cr_LogDetAQPA384a(ld_fec    in date,
                                 ln_pais   in number,
                                 ln_tdoc   in number,
                                 lc_ndoc   in varchar2,
                                 ln_tcamb  in number,
                                 ln_corr   in number,
                                 ld_fchcor in date,
                                 ln_pgcod  in number,
                                 ln_mod    in number,
                                 ln_suc    in number,
                                 ln_mda    in number,
                                 ln_pap    in number,
                                 ln_cta    in number,
                                 ln_ope    in number,
                                 ln_sbop   in number,
                                 ln_tope   in number,
                                 ln_nrcuo  in number,
                                 ln_saldo  in number,
                                 ld_indic  in varchar2,
                                 lc_user   in varchar2) is
    ln_corre  number := 0;
    lc_IndEst varchar2(5) := 'H';
    lc_hora   char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpa384acorr)
        into ln_corre
        from aqpa384a a
       where a.aqpa384afec = ld_fec
         and a.aqpa384acorrp = ln_corr
         and a.aqpa384afchcor = ld_fchcor;
    exception
      when others then
        ln_corre := 0;
    end;
  
    ln_corre  := nvl(ln_corre, 0);
    lc_IndEst := 'H';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa384a
        (aqpa384acorr,
         aqpa384afec,
         aqpa384ahora,
         aqpa384apais,
         aqpa384atdoc,
         aqpa384andoc,
         aqpa384atcamb,
         aqpa384acorrp,
         aqpa384afchcor,
         aqpa384apgcod,
         aqpa384amod,
         aqpa384asuc,
         aqpa384amda,
         aqpa384apap,
         aqpa384acta,
         aqpa384aope,
         aqpa384asbop,
         aqpa384atope,
         aqpa384anrcuo,
         aqpa384asaldo,
         aqpa384aindic,
         aqpa384aest,
         aqpa384auser)
      values
        (ln_corre + 1,
         ld_fec,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_tcamb,
         ln_corr,
         ld_fchcor,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_nrcuo,
         ln_saldo,
         ld_indic,
         lc_IndEst,
         lc_user);
    
      commit;
    
    end;
  end sp_cr_LogDetAQPA384a;
  ------------------------------------------------------
  procedure sp_cr_logcAQPA383_rep(ln_Pepais  in number,
                              ln_Petdoc  in number,
                              ln_Pendoc  in varchar2,
                              tipocambio in number,
                              pd_fecpro  in date,
                              Instancia  in number,
                              ln_deucmac in number,
                              ln_niventa in number,
                              ln_ratio   in number,
                              lc_usuario in varchar2,
                              lc_tarea   in number,
                              lc_estado  in varchar2) is
  
    ln_corr   number := 0;
    
    lc_hora   char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpa383corr)
        into ln_corr
        from aqpa383 a
       where a.aqpa383fec = pd_fecpro
         and a.aqpa383inst = Instancia;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr   := nvl(ln_corr, 0);
    
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa383
        (aqpa383corr,
         aqpa383pais,
         aqpa383tdoc,
         aqpa383ndoc,
         aqpa383tcamb,
         aqpa383fec,
         aqpa383inst,
         aqpa383deucmac,
         aqpa383niventa,
         aqpa383ratio,
         aqpa383est,
         aqpa383hora,
         aqpa383user,
         aqpa383tarea)
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         tipocambio,
         pd_fecpro,
         Instancia,
         ln_deucmac,
         ln_niventa,
         ln_ratio,
         lc_estado,
         lc_hora,
         lc_usuario,
         lc_tarea);
      commit;
    end;
  
  end sp_cr_logcAQPA383_rep;
 
  ---------------------------------------------------------------------------
  procedure sp_cr_LogDetAQPA384_rep(ld_fec   in date,
                                ln_pais  in number,
                                ln_tdoc  in number,
                                lc_ndoc  in varchar2,
                                ln_tcamb in number,
                                ln_inst  in number,
                                ln_pgcod in number,
                                ln_mod   in number,
                                ln_suc   in number,
                                ln_mda   in number,
                                ln_pap   in number,
                                ln_cta   in number,
                                ln_ope   in number,
                                ln_sbop  in number,
                                ln_tope  in number,
                                ln_nrcuo in number,
                                ln_saldo in number,
                                ld_indic in varchar2,
                                lc_user  in varchar2,
                                ln_tarea in number,
                                lc_estado  in varchar2) is
    ln_corr   number := 0;
    
    lc_hora   char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpa384corr)
        into ln_corr
        from aqpa384 a
       where a.aqpa384fec = ld_fec
         and a.aqpa384inst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr   := nvl(ln_corr, 0);
    
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa384
        (aqpa384corr,
         aqpa384fec,
         aqpa384hora,
         aqpa384pais,
         aqpa384tdoc,
         aqpa384ndoc,
         aqpa384tcamb,
         aqpa384inst,
         aqpa384pgcod,
         aqpa384mod,
         aqpa384suc,
         aqpa384mda,
         aqpa384pap,
         aqpa384cta,
         aqpa384ope,
         aqpa384sbop,
         aqpa384tope,
         aqpa384nrcuo,
         aqpa384saldo,
         aqpa384indic,
         aqpa384est,
         aqpa384user,
         aqpa384tarea)
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_tcamb,
         ln_inst,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_nrcuo,
         ln_saldo,
         ld_indic,
         lc_estado,
         lc_user,
         ln_tarea);
    
      commit;
    
    end;
  end sp_cr_LogDetAQPA384_rep;
  
  -------------------------------------------------------------------------
end PQ_CR_RATIO_PARALELO;
/

