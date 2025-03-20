create or replace package PQ_CR_RATIO_EVALFLUJO is

  -- Author  : MPOSTIGOC
  -- Created : 10/04/2019 6:17:17 p. m.
  -- Purpose : Ratio Evaluacion por flujo
  -- Fecha de Modificación      : 15/03/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se descomento el monto de cuota potencial en el denominador de la formula  
  -----------------------------------------------------------

  procedure sp_cr_VerfEvalFlujoPanel(ln_Instancia      in number,
                                     ln_EvalFlujoPanel out varchar2);
  ------------------------------------------------------
  procedure sp_cr_VerfEvalFlujo(ln_Instancia in number,
                                ln_EvalFlujo out varchar2);
  -------------------------------------------------
  procedure sp_cr_InicioRatio(ln_Instancia  in number,
                              lc_prgm       in varchar2,
                              lc_Usuario    in varchar2,
                              ld_FecProc    in date,
                              ln_capcmac    out number,
                              ln_capifis    out number,
                              ln_capcontgnt out number,
                              ln_capptncl   out number,
                              ln_ResulNeto  out number,
                              ln_Ratio      out number);
  -----------------------------------------------------------------------
  procedure sp_cr_CalcCuentasII(ln_Instancia  in number,
                                lc_prgm       in varchar2,
                                lc_Usuario    in varchar2,
                                ld_FecProc    in date,
                                ln_capcontgnt out number);
  ------------------------------------------------------------------------
  procedure sp_cr_CalcRatio(ln_Instancia in number,
                            --  pd_fecpro     in date,
                            -- lc_Usuario    in varchar2,
                            lc_prgm in varchar2);
  -----------------------------------------------------------
  procedure sp_cr_CalcRatioPanel(ln_Instancia in number);
  ---------------------------------------------------------
  /*procedure sp_cr_CalcRatioII(ln_Instancia  in number,
  pd_fecpro     in date,
  lc_Usuario    in varchar2,
  lc_prgm       in varchar2,
  ln_capcontgnt in number);*/
  --------------------------------------------------------------
  procedure sp_cr_DatosRatio(ln_instancia  in number,
                             lc_prgm       in varchar2,
                             ln_capcaja    out number,
                             ln_capifis    out number,
                             ln_capcontgnt out number,
                             ln_capptncl   out number,
                             ln_ResulNeto  out number,
                             ln_Ratio      out number);
  --------------------------------------------------------------                             
  procedure sp_cr_ActMntCuota(ln_Instancia in number,
                              lc_mesanio   in varchar2,
                              lc_flgprg    in varchar2);
  ---------------------------------------------------------------
  procedure sp_cr_NroCuOPreseteo(ln_pgcod        in number,
                                 ln_modulo       in number,
                                 ln_sucursal     in number,
                                 ln_moneda       in number,
                                 ln_papel        in number,
                                 ln_cuenta       in number,
                                 ln_operacion    in number,
                                 ln_suboperacion in number,
                                 ln_tipoperacion in number,
                                 -- ln_InsCredito   in number,
                                 ln_NroCuot out number);
  -------------------------------------------------------------
  procedure sp_cr_TipoSolicitud(ln_InstCred in number,
                                ln_TipoOri  out number);
  --------------------------------------------------------------
  procedure sp_cr_VerfUsoLinea(ln_pgcod        in number,
                               ln_modulo       in number,
                               ln_sucursal     in number,
                               ln_moneda       in number,
                               ln_papel        in number,
                               ln_cuenta       in number,
                               ln_operacion    in number,
                               ln_sboperacion  in number,
                               ln_tipoperacion in number,
                               Tiene_Uso       out varchar2,
                               ln_pgcod116     out number,
                               ln_modulo116    out number,
                               ln_sucursal116  out number,
                               ln_moneda116    out number,
                               ln_papel116     out number,
                               ln_cuenta116    out number,
                               ln_operacion116 out number,
                               ln_sbop116      out number,
                               ln_top116       out number);
  ------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                pd_fecpro       in date,
                                lc_flgprg       in varchar2,
                                lc_Usuario      in varchar2,
                                lc_prgm         in varchar2,
                                ln_MntCuoCntgCF out number);
  -----------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  pd_fecpro         in date,
                                  lc_flgprg         in varchar2,
                                  lc_Usuario        in varchar2,
                                  lc_prgm           in varchar2,
                                  ln_MntCuoCntgAval out number);
  ----------------------------------------------------------
  procedure sp_cR_CuotaPotencial(ln_Instancia   in number,
                                 ln_MntPotncial out number);
  ------------------------------------------------------------
  procedure sp_cr_fchevaluacion(ln_Instancia     in number,
                                ld_fchevaluacion out date);
  ----------------------------------------------------------
  --mod 2016.04.13
  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2);
  ----------------------------------------------------------
  --mod 2016.04.13
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2);
  ----------------------------------------------------------------

  procedure sp_refinanLinea(ln_pgcod10  in number,
                            ln_mod10    in number,
                            ln_suc10    in number,
                            ln_mda10    in number,
                            ln_pap10    in number,
                            ln_cta10    in number,
                            ln_oper10   in number,
                            lc_fgRefLin out varchar2);
  ----------------------------------------------------------
  procedure sp_cr_VerVincLinea(ln_mod10  in number,
                               ln_suc10  in number,
                               ln_mda10  in number,
                               ln_pap10  in number,
                               ln_cta10  in number,
                               ln_oper10 in number,
                               ln_sbop10 in number,
                               ln_tope10 in number,
                               lc_FlgLn  out varchar2);

  -----------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais      in number,
                           ln_Petdoc      in number,
                           ln_Pendoc      in varchar2,
                           tipocambio     in number,
                           Instancia      in number,
                           pd_fecpro      in date,
                           lc_Usuario     in varchar2,
                           lc_mesanio     in varchar2,
                           ln_captotcaja  in number,
                           ln_ifis        in number,
                           ln_ResultNeto  in number,
                           ln_MntCuoCntg  in number,
                           ln_MntPotncial in number,
                           ln_ratio       in number,
                           lc_flgprg      in varchar2,
                           ln_Tarea       in number);
  ----------------------------------------------------
  /*procedure sp_cr_LogDetMensual(ln_inst    in number,
  ld_fec     in date,
  lc_flgprg  in varchar2,
  lc_user    in varchar2,
  ln_pais    in number,
  ln_tdoc    in number,
  lc_ndoc    in varchar2,
  ln_tcamb   in number,
  ld_feval   in date,
  ln_mesanio in number,
  ln_capcaja in number,
  ln_ifis    in number,
  ln_resneto in number,
  ln_ccontg  in number,
  ln_cpoten  in number,
  ln_ratio   in number,
  ln_tarea   in number);*/

  ---------------------------------------------------------
  procedure sp_cr_LogDetMensualII(ln_Instancia   in number,
                                  ln_modulo      in number,
                                  ln_mntcuota    in number,
                                  ld_fchPanel    in date,
                                  ln_NroCuOtorg  in number,
                                  ln_NroCuotCred in number,
                                  lc_programa    in varchar2,
                                  lc_Indicador   in varchar2);
  ---------------------------------------------------------
  procedure sp_cr_LogDetMensPanel(ln_Instancia   in number,
                                  ln_modulo      in number,
                                  ln_mntcuota    in number,
                                  ld_fchPanel    in date,
                                  ln_NroCuOtorg  in number,
                                  ln_NroCuotCred in number,
                                  lc_Indicador   in varchar2);
  -------------------------------------------------------
  procedure sp_cr_LogCuentas(ld_fec     in date,
                             lc_user    in varchar2,
                             ln_pais    in number,
                             ln_tdoc    in number,
                             ln_ndoc    in varchar2,
                             ln_tcamb   in number,
                             ln_inst    in number,
                             ld_feval   in date,
                             ld_fical   in date,
                             ln_pgcod   in number,
                             ln_mod     in number,
                             ln_suc     in number,
                             ln_mda     in number,
                             ln_pap     in number,
                             ln_cta     in number,
                             ln_ope     in number,
                             ln_sbop    in number,
                             ln_tope    in number,
                             ln_TipoOri in number,
                             ln_NroCuot in number,
                             ln_tarea   in number,
                             lc_IndCred in varchar2,
                             lc_flgprg  in varchar2,
                             ln_SaldCap in number,
                             ln_monto   in number);
  --------------------------------------------------------
  procedure sp_cr_DatosPanelEF(ln_Instancia  in number,
                               ld_FecPro     in date,
                               lc_Usuario    in varchar2,
                               ln_capcontgnt in number,
                               lc_prgm       in varchar2);
  --------------------------------------------------------------
  procedure sp_cr_DatosPanelEFII(ln_Instancia in number,
                                 ld_FecPro    in date,
                                 lc_Usuario   in varchar2);
  -----------------------------------------------------------                               
  procedure sp_cr_CalCuota( --ln_InsCredito in number,
                           ln_pgcod    in number,
                           ln_mod      in number,
                           ln_suc      in number,
                           ln_mda      in number,
                           ln_pap      in number,
                           ln_cta      in number,
                           ln_ope      in number,
                           ln_sbop     in number,
                           ln_tope     in number,
                           ld_fini     in date,
                           ld_ffin     in date,
                           ln_TipCamb  in number,
                           ln_NroCuot  out number,
                           ln_MntCuota out number);
  ----------------------------------------------------------
  procedure sp_cr_CalCuotaDispnbl(ln_pgcod        in number,
                                  ln_suc          in number,
                                  ln_mod          in number,
                                  ln_mda          in number,
                                  ln_pap          in number,
                                  ln_cta          in number,
                                  ln_oper         in number,
                                  ln_sbop         in number,
                                  ln_tope         in number,
                                  ln_MntDispnbl   in number,
                                  tipocambio      in number,
                                  ln_CuotaDispnbl out number);
  -----------------------------------------------------------
  procedure sp_cr_CalFormula(ln_Instancia in number,
                             lc_programa  in varchar2);
  -------------------------------------------------------------
  procedure sp_cr_CalcDisponible(ln_pgcod     in number,
                                 ln_mod       in number,
                                 ln_suc       in number,
                                 ln_mda       in number,
                                 ln_pap       in number,
                                 ln_cta       in number,
                                 ln_ope       in number,
                                 ln_sbop      in number,
                                 ln_tope      in number,
                                 ln_MntDispnb out number);
  ----------------------------------------------------------
  procedure sp_cr_UpdateAQPA410(ln_Instancia in number);
  ----------------------------------------------------------
  procedure sp_cr_VerfDesmbPendiente(ln_pgcod           in number,
                                     ln_mod             in number,
                                     ln_suc             in number,
                                     ln_mda             in number,
                                     ln_pap             in number,
                                     ln_cta             in number,
                                     ln_oper            in number,
                                     ln_sbop            in number,
                                     ln_tope            in number,
                                     lc_VerfDesembPendt out varchar2,
                                     ln_NroDesemblsPact out number,
                                     ln_DesembHechos    out number);
  ---------------------------------------------------------
  procedure sp_Cr_CalcParcialPend(ln_pgcod       in number,
                                  ln_mod         in number,
                                  ln_suc         in number,
                                  ln_mda         in number,
                                  ln_pap         in number,
                                  ln_cta         in number,
                                  ln_ope         in number,
                                  ln_sbop        in number,
                                  ln_tope        in number,
                                  ln_DesembHecho in number,
                                  ln_TipCamb     in number,
                                  ln_CuotPendt   out number);
  ---------------------------------------------------------------
  procedure sp_capacidadlinea(ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              tipocambio in number,
                              ln_formula out number);
  -----------------------------------------------------------
  procedure sp_CapLineaAdicional(ln_mod10        in number,
                                 ln_suc10        in number,
                                 ln_mda10        in number,
                                 ln_pap10        in number,
                                 ln_cta10        in number,
                                 ln_oper10       in number,
                                 ln_sbop10       in number,
                                 ln_tope10       in number,
                                 tipocambio      in number,
                                 ln_plazo        out number,
                                 ln_CapAdicional out number);
  ----------------------------------------------------------
  procedure sp_CapLineaAdiVuel(ln_mod10        in number,
                               ln_suc10        in number,
                               ln_mda10        in number,
                               ln_pap10        in number,
                               ln_cta10        in number,
                               ln_oper10       in number,
                               ln_sbop10       in number,
                               ln_tope10       in number,
                               tipocambio      in number,
                               ln_plazo        out number,
                               ln_CapAdicional out number);

end PQ_CR_RATIO_EVALFLUJO;
/

create or replace package body PQ_CR_RATIO_EVALFLUJO is

  --------------------------------------
  procedure sp_cr_VerfEvalFlujoPanel(ln_Instancia      in number,
                                     ln_EvalFlujoPanel out varchar2) is
    ln_reg number := 0;
  begin
  
    begin
      select count(*)
        into ln_reg
        from aqpa411 a
       where a.aqpa411inst = ln_Instancia;
    exception
      when others then
        ln_reg := 0;
    end;
  
    if ln_reg > 0 then
      ln_EvalFlujoPanel := 'S';
    elsif ln_reg <= 0 then
      ln_EvalFlujoPanel := 'N';
    end if;
  
  end sp_cr_VerfEvalFlujoPanel;
  --------------------------------------------
  procedure sp_cr_VerfEvalFlujo(ln_Instancia in number,
                                ln_EvalFlujo out varchar2) is
    ln_reg number := 0;
  begin
  
    begin
      select count(*)
        into ln_reg
        from aqpa410 a
       where a.aqpa410inst = ln_Instancia
         and a.aqpa410esta = 'S';
    exception
      when others then
        ln_reg := 0;
    end;
  
    if ln_reg > 0 then
      ln_EvalFlujo := 'S';
    elsif ln_reg <= 0 then
      ln_EvalFlujo := 'N';
    end if;
  
  end sp_cr_VerfEvalFlujo;
  ------------------------------------------------
  procedure sp_cr_InicioRatio(ln_Instancia  in number,
                              lc_prgm       in varchar2,
                              lc_Usuario    in varchar2,
                              ld_FecProc    in date,
                              ln_capcmac    out number,
                              ln_capifis    out number,
                              ln_capcontgnt out number,
                              ln_capptncl   out number,
                              ln_ResulNeto  out number,
                              ln_Ratio      out number) is
  
    ln_EvalFlujo      varchar2(2) := 'N';
    ln_EvalFlujoPanel varchar2(2) := 'N';
    lc_EjecRatio      varchar2(2) := 'N';
    ln_Tarea          number;
    lc_flgprg         varchar2(2) := 'N';
    ln_TamañoVar      number := 0;
    lc_NewUsuario     varchar2(10);
  
  begin
  
    -- 20.05.2020  mpostigoc
    begin
      SELECT LENGTH(lc_Usuario) into ln_TamañoVar FROM DUAL;
    exception
      when others then
        ln_TamañoVar := 0;
    end;
  
    if ln_TamañoVar > 10 then
      begin
        SELECT upper(SUBSTR(lc_Usuario, -10)) into lc_NewUsuario FROM DUAL;
      EXCEPTION
        when others then
          null;
      end;
    else
      lc_NewUsuario := lc_Usuario;
    end if;
    -- 20.05.2020  mpostigoc
  
    if lc_prgm = 'HAQPA411' then
      begin
        PQ_CR_RATIO_EVALFLUJO.sp_cr_VerfEvalFlujoPanel(ln_Instancia,
                                                       ln_EvalFlujoPanel);
      end;
    else
    
      begin
        PQ_CR_RATIO_EVALFLUJO.sp_cr_VerfEvalFlujo(ln_Instancia,
                                                  ln_EvalFlujo);
      end;
    
    end if;
  
    if ln_EvalFlujoPanel = 'S' and lc_prgm = 'HAQPA411' then
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcCuentasII(ln_Instancia,
                                                lc_prgm,
                                                lc_NewUsuario,
                                                ld_FecProc,
                                                ln_capcontgnt);
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_DatosPanelEFII(ln_Instancia,
                                                 ld_FecProc,
                                                 lc_NewUsuario);
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcRatioPanel(ln_Instancia);
    
    else
      if ln_EvalFlujo = 'S' and lc_prgm <> 'HAQPA411' then
      
        begin
          -- Tarea de la solicitud
          select w.wftaskcod
            into ln_Tarea
            from wfwrkitems w
           where w.wfinsprcid = ln_Instancia
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
             and a.tp1corr1 = 850
             and a.TP1CORR2 = 101
             and a.tp1corr3 > 0
             and trim(a.tp1desc) = trim(lc_prgm)
             and a.tp1nro3 = ln_Tarea;
        exception
          when others then
            lc_EjecRatio := 'N';
        end;
      
        -- Solo si la tarea y programa stan incluidos en la guia pueden ejecutar el ratio
        -- excepcionado la impresion de ratios
      
        begin
          select 'S'
            into lc_flgprg
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 850
             and a.tp1corr2 = 101
                --and a.tp1corr3 = 1
             and trim(a.tp1desc) = trim(lc_prgm)
             and a.tp1nro3 = ln_Tarea;
        exception
          when others then
            lc_flgprg := 'N';
        end;
      
        if lc_EjecRatio = 'S' and lc_flgprg = 'S' then
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcCuentasII(ln_Instancia,
                                                    lc_prgm,
                                                    lc_NewUsuario,
                                                    ld_FecProc,
                                                    ln_capcontgnt);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_DatosPanelEF(ln_Instancia,
                                                   ld_FecProc,
                                                   lc_NewUsuario,
                                                   ln_capcontgnt,
                                                   lc_prgm);
        
          --Vuelve a Calcular la cuota en el Panel   
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_DatosPanelEFII(ln_Instancia,
                                                     ld_FecProc,
                                                     lc_NewUsuario);
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcRatioPanel(ln_Instancia);
        
          pq_cr_panel_agropecuario.sp_calcula(ln_Instancia, ld_FecProc);
        
          -- Fin Actualizacion Panel    
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcRatio(ln_Instancia, lc_prgm);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_DatosRatio(ln_Instancia,
                                                 lc_prgm,
                                                 ln_capcmac,
                                                 ln_capifis,
                                                 ln_capcontgnt,
                                                 ln_capptncl,
                                                 ln_ResulNeto,
                                                 ln_Ratio);
        
        end if;
      
      else
        if ln_EvalFlujo = 'N' then
          ln_capcmac    := 0;
          ln_capifis    := 0;
          ln_capcontgnt := 0;
          ln_capptncl   := 0;
          ln_ResulNeto  := 0;
          ln_Ratio      := 0;
        
        end if;
      end if;
    end if;
  
    ln_capcmac    := nvl(ln_capcmac, 0);
    ln_capifis    := nvl(ln_capifis, 0);
    ln_capcontgnt := nvl(ln_capcontgnt, 0);
    ln_capptncl   := nvl(ln_capptncl, 0);
    ln_ResulNeto  := nvl(ln_ResulNeto, 0);
    ln_Ratio      := nvl(ln_Ratio, 0);
  
  end sp_cr_InicioRatio;
  -------------------------------------------------------
  procedure sp_cr_CalcCuentasII(ln_Instancia  in number,
                                lc_prgm       in varchar2,
                                lc_Usuario    in varchar2,
                                ld_FecProc    in date,
                                ln_capcontgnt out number) is
  
    cursor lista_cuentas is
    
      select distinct f.ctnro ln_cuenta
        from fsr008 f
       where (f.pepais, f.petdoc, f.pendoc) in
             (select f.pepais, f.petdoc, f.pendoc
                from sng001 s, fsr008 f
               where s.sng001inst = ln_Instancia
                 and s.sng001cta = f.ctnro
              union
              select g.rppais, g.rptdoc, g.rpndoc
                from fsr008 h, sng001 s, fsr002 g
               where s.sng001inst = ln_Instancia
                 and s.sng001cta = h.ctnro
                 and h.pepais = g.pepais
                 and h.petdoc = g.petdoc
                 and h.pendoc = g.pendoc
                 and g.rpccyg = 66
              union
              select g.pepais, g.petdoc, g.pendoc
                from fsr008 h, sng001 s, fsr002 g
               where s.sng001inst = ln_Instancia
                 and s.sng001cta = h.ctnro
                 and h.pepais = g.rppais
                 and h.petdoc = g.rptdoc
                 and h.pendoc = g.rpndoc
                 and g.rpccyg = 66);
  
    cursor inserta_vencidos(ln_cuenta number) is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta = ln_cuenta
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (select f.tp1nro3
                                       from fst198 f
                                      where f.tp1cod = 1
                                        and f.tp1cod1 = 10899
                                        and f.tp1corr1 = 850
                                        and f.tp1corr2 = 102
                                        and f.tp1corr3 > 0)))
         and d10.Aostat <> 99
         and d10.aofvto < ld_FecProc;
  
    cursor inserta(ln_cuenta number) is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta = ln_cuenta
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (select f.tp1nro3
                                       from fst198 f
                                      where f.tp1cod = 1
                                        and f.tp1cod1 = 10899
                                        and f.tp1corr1 = 850
                                        and f.tp1corr2 = 102
                                        and f.tp1corr3 > 0)) or
             d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= ld_FecProc;
  
    cursor vuelo(ln_cuenta number) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10
        from xwf700 x, wfwrkitems wf
       where x.xwfempresa = 1
         and x.xwfcuenta = ln_cuenta
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (select f.tp1nro3
                                       from fst198 f
                                      where f.tp1cod = 1
                                        and f.tp1cod1 = 10899
                                        and f.tp1corr1 = 850
                                        and f.tp1corr2 = 102
                                        and f.tp1corr3 > 0)) or
             x.xwfmodulo = 117)
         and wf.wfinsprcid = x.xwfprcins
         and wf.wfitemstsact = 1
         and x.xwfcar3 = '1';
  
    cursor lineas_ven(ln_cuenta number) is
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
         and d10.Aocta = ln_cuenta
         and d10.Aomod = 117
         and d10.aofvto < ld_FecProc;
  
    lc_FlgLn          varchar2(2);
    lc_fgAdic         varchar2(1);
    lc_fgAmpl         varchar2(1);
    lc_ven            char(1);
    ln_indicador      number(10);
    lc_fgRefLin       varchar2(1);
    lc_flgprg         varchar2(2) := 'N';
    lc_IndCred        varchar2(10);
    ln_TipCamb        number;
    ln_MntCuoCntgCF   number := 0;
    ln_MntCuoCntgAval number := 0;
    lc_EjecRatio      varchar2(5) := 'N';
    ln_Tarea          number(10);
    ln_TieneCalndario number := 0;
    ln_Pepais         number;
    ln_Petdoc         number;
    ln_Pendoc         varchar2(12);
    ld_fcheval        date;
    ld_MinFchCred     date;
    ln_InstCred       number;
    ln_TipoOri        number;
    ln_NroCuot        number;
    Tiene_Uso         varchar2(5) := 'N';
    ln_pgcod116       number;
    ln_modulo116      number;
    ln_sucursal116    number;
    ln_moneda116      number;
    ln_papel116       number;
    ln_cuenta116      number;
    ln_operacion116   number;
    ln_sbop116        number;
    ln_top116         number;
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
      
    end;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
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
         and a.tp1corr1 = 850
         and a.TP1CORR2 = 101
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    -- Solo si la tarea y programa stan incluidos en la guia pueden ejecutar el ratio
    -- excepcionado la impresion de ratios
  
    begin
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 850
         and a.tp1corr2 = 101
            --  and a.tp1corr3 = 1
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_flgprg := 'N';
    end;
  
    if lc_prgm = 'RJAQY843' then
    
      lc_flgprg := 'R';
    
      begin
        delete aqpa352 J
         WHERE J.aqpa352INST = ln_Instancia
           and j.aqpa352est = 'R';
      end;
    
    end if;
  
    if lc_flgprg = 'S' and lc_EjecRatio = 'S' then
    
      begin
        UPDATE aqpa352 j
           set aqpa352est = 'I'
         where j.aqpa352inst = ln_Instancia
           and j.aqpa352est = 'H'
           and j.aqpa352tarea = ln_Tarea;
        commit;
      end;
    
    end if;
  
    begin
      --Tipo de Cambio
      select s. sng120tcbi
        into ln_TipCamb
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipCamb := 0;
    end;
  
    begin
      PQ_CR_RATIO_EVALFLUJO.sp_cr_fchevaluacion(ln_Instancia, ld_fcheval);
    end;
  
    begin
      ld_MinFchCred := ADD_MONTHS(last_Day(ld_fcheval), -1) + 1;
    end;
  
    for q in lista_cuentas loop
    
      for i in inserta(q.ln_cuenta) loop
      
        lc_fgAdic    := null;
        lc_fgAmpl    := null;
        ln_indicador := 1;
        lc_IndCred   := 'CredVigent';
        lc_FlgLn     := 'N';
      
        begin
          -- Verifico si el credito vigente tiene cuotas a partir de la primera fecha del panel de evaluacion por flujo
          -- del credito en proceso(primer dia el mes de la primera cuota)
          select count(*)
            into ln_TieneCalndario
            from fsd601 f
           where f.pgcod = i.ln_pgcod10
             and f.ppmod = i.ln_mod10
             and f.ppsuc = i.ln_suc10
             and f.ppmda = i.ln_mda10
             and f.pppap = i.ln_pap10
             and f.ppcta = i.ln_cta10
             and f.ppoper = i.ln_oper10
             and f.ppsbop = i.ln_sbop10
             and f.pptope = i.ln_tope10
             and f.d601co = 'S'
             and f.ppfpag >= ld_MinFchCred;
        exception
          when others then
            ln_TieneCalndario := 0;
        end;
      
        if i.ln_mod10 = 117 then
          ln_TieneCalndario := 1;
        end if;
      
        if ln_TieneCalndario > 0 then
        
          PQ_CR_RATIO_EVALFLUJO.sp_refinanLinea(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                lc_fgRefLin);
        
          /* PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(i.ln_mod10,
          i.ln_tope10,
          lc_fgAdic);*/
          PQ_CR_RATIO_EVALFLUJO.Sp_ampliados_CK(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_fgAmpl);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_VerVincLinea(i.ln_mod10,
                                                   i.ln_suc10,
                                                   i.ln_mda10,
                                                   i.ln_pap10,
                                                   i.ln_cta10,
                                                   i.ln_oper10,
                                                   i.ln_sbop10,
                                                   i.ln_tope10,
                                                   lc_FlgLn);
        
          if /*lc_fgAdic <> 'S' and*/
           lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
          
            ln_InstCred := fn_instancia_credito(i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(i.ln_pgcod10,
                                                       i.ln_mod10,
                                                       i.ln_suc10,
                                                       i.ln_mda10,
                                                       i.ln_pap10,
                                                       i.ln_cta10,
                                                       i.ln_oper10,
                                                       i.ln_sbop10,
                                                       i.ln_tope10,
                                                       ln_NroCuot);
            if i.ln_mod10 = 117 then
              PQ_CR_RATIO_EVALFLUJO.sp_cr_VerfUsoLinea(i.ln_pgcod10,
                                                       i.ln_mod10,
                                                       i.ln_suc10,
                                                       i.ln_mda10,
                                                       i.ln_pap10,
                                                       i.ln_cta10,
                                                       i.ln_oper10,
                                                       i.ln_sbop10,
                                                       i.ln_tope10,
                                                       Tiene_Uso,
                                                       ln_pgcod116,
                                                       ln_modulo116,
                                                       ln_sucursal116,
                                                       ln_moneda116,
                                                       ln_papel116,
                                                       ln_cuenta116,
                                                       ln_operacion116,
                                                       ln_sbop116,
                                                       ln_top116);
            
            end if;
          
            if Tiene_Uso = 'S' and i.ln_mod10 = 117 then
              -- mpostigoc 12.08.2021
              PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod116,
                                                         ln_modulo116,
                                                         ln_sucursal116,
                                                         ln_moneda116,
                                                         ln_papel116,
                                                         ln_cuenta116,
                                                         ln_operacion116,
                                                         ln_sbop116,
                                                         ln_top116,
                                                         ln_NroCuot);
            
              PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(ld_FecProc,
                                                     lc_Usuario,
                                                     ln_Pepais,
                                                     ln_Petdoc,
                                                     ln_Pendoc,
                                                     ln_TipCamb,
                                                     ln_Instancia,
                                                     ld_fcheval,
                                                     ld_MinFchCred,
                                                     ln_pgcod116,
                                                     ln_modulo116,
                                                     ln_sucursal116,
                                                     ln_moneda116,
                                                     ln_papel116,
                                                     ln_cuenta116,
                                                     ln_operacion116,
                                                     ln_sbop116,
                                                     ln_top116,
                                                     ln_TipoOri,
                                                     ln_NroCuot,
                                                     ln_Tarea,
                                                     lc_IndCred,
                                                     lc_flgprg,
                                                     0.00,
                                                     0.00);
            else
              if Tiene_Uso = 'N' then
                PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(ld_FecProc,
                                                       lc_Usuario,
                                                       ln_Pepais,
                                                       ln_Petdoc,
                                                       ln_Pendoc,
                                                       ln_TipCamb,
                                                       ln_Instancia,
                                                       ld_fcheval,
                                                       ld_MinFchCred,
                                                       i.ln_pgcod10,
                                                       i.ln_mod10,
                                                       i.ln_suc10,
                                                       i.ln_mda10,
                                                       i.ln_pap10,
                                                       i.ln_cta10,
                                                       i.ln_oper10,
                                                       i.ln_sbop10,
                                                       i.ln_tope10,
                                                       ln_TipoOri,
                                                       ln_NroCuot,
                                                       ln_Tarea,
                                                       lc_IndCred,
                                                       lc_flgprg,
                                                       0.00,
                                                       0.00);
              end if;
            end if;
          
          end if;
        end if;
      
      end loop;
    
      for i in inserta_vencidos(q.ln_cuenta) loop
      
        lc_fgAdic    := null;
        lc_fgAmpl    := null;
        ln_indicador := 1;
        lc_IndCred   := 'CredVencid';
      
        begin
          -- Verifico si el credito vigente tiene cuotas a partir de la primera fecha de pago
          -- del credito agropecuario
          select count(*)
            into ln_TieneCalndario
            from fsd601 f
           where f.pgcod = i.ln_pgcod10
             and f.ppmod = i.ln_mod10
             and f.ppsuc = i.ln_suc10
             and f.ppmda = i.ln_mda10
             and f.pppap = i.ln_pap10
             and f.ppcta = i.ln_cta10
             and f.ppoper = i.ln_oper10
             and f.ppsbop = i.ln_sbop10
             and f.pptope = i.ln_tope10
             and f.d601co = 'S'
             and f.ppfpag >= ld_MinFchCred;
        exception
          when others then
            ln_TieneCalndario := 0;
        end;
      
        if ln_TieneCalndario > 0 then
        
          PQ_CR_RATIO_EVALFLUJO.sp_refinanLinea(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                lc_fgRefLin);
        
          /*  PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(i.ln_mod10,
          i.ln_tope10,
          lc_fgAdic);*/
          PQ_CR_RATIO_EVALFLUJO.Sp_ampliados_CK(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_fgAmpl);
          PQ_CR_RATIO_EVALFLUJO.sp_cr_VerVincLinea(i.ln_mod10,
                                                   i.ln_suc10,
                                                   i.ln_mda10,
                                                   i.ln_pap10,
                                                   i.ln_cta10,
                                                   i.ln_oper10,
                                                   i.ln_sbop10,
                                                   i.ln_tope10,
                                                   lc_FlgLn);
        
          if /*lc_fgAdic <> 'S' and*/
           lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
            ln_InstCred := fn_instancia_credito(i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(i.ln_pgcod10,
                                                       i.ln_mod10,
                                                       i.ln_suc10,
                                                       i.ln_mda10,
                                                       i.ln_pap10,
                                                       i.ln_cta10,
                                                       i.ln_oper10,
                                                       i.ln_sbop10,
                                                       i.ln_tope10,
                                                       ln_NroCuot);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(ld_FecProc,
                                                   lc_Usuario,
                                                   ln_Pepais,
                                                   ln_Petdoc,
                                                   ln_Pendoc,
                                                   ln_TipCamb,
                                                   ln_Instancia,
                                                   ld_fcheval,
                                                   ld_MinFchCred,
                                                   i.ln_pgcod10,
                                                   i.ln_mod10,
                                                   i.ln_suc10,
                                                   i.ln_mda10,
                                                   i.ln_pap10,
                                                   i.ln_cta10,
                                                   i.ln_oper10,
                                                   i.ln_sbop10,
                                                   i.ln_tope10,
                                                   ln_TipoOri,
                                                   ln_NroCuot,
                                                   ln_Tarea,
                                                   lc_IndCred,
                                                   lc_flgprg,
                                                   0.00,
                                                   0.00);
          
          end if;
        end if;
      end loop;
    
      for c in vuelo(q.ln_cuenta) loop
        ln_indicador := 2;
        lc_IndCred   := 'CredVuelo';
      
        begin
          -- Verifico si el credito vigente tiene cuotas a partir de la primera fecha de pago
          -- del credito agropecuario
          select count(*)
            into ln_TieneCalndario
            from fsd601 f
           where f.pgcod = c.ln_pgcod10
             and f.ppmod = c.ln_mod10
             and f.ppsuc = c.ln_suc10
             and f.ppmda = c.ln_mda10
             and f.pppap = c.ln_pap10
             and f.ppcta = c.ln_cta10
             and f.ppoper = c.ln_oper10
             and f.ppsbop = c.ln_sbop10
             and f.pptope = c.ln_tope10
             and f.d601co in ('X', 'E')
             and f.ppfpag >= ld_MinFchCred;
        exception
          when others then
            ln_TieneCalndario := 0;
        end;
      
        if ln_TieneCalndario > 0 then
        
          /*PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(c.ln_mod10,
          c.ln_tope10,
          lc_fgAdic);*/
        
          --if lc_fgAdic <> 'S' then
        
          ln_InstCred := fn_instancia_credito(c.ln_mod10,
                                              c.ln_suc10,
                                              c.ln_mda10,
                                              c.ln_pap10,
                                              c.ln_cta10,
                                              c.ln_oper10,
                                              c.ln_sbop10,
                                              c.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(c.ln_pgcod10,
                                                     c.ln_mod10,
                                                     c.ln_suc10,
                                                     c.ln_mda10,
                                                     c.ln_pap10,
                                                     c.ln_cta10,
                                                     c.ln_oper10,
                                                     c.ln_sbop10,
                                                     c.ln_tope10,
                                                     ln_NroCuot);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(ld_FecProc,
                                                 lc_Usuario,
                                                 ln_Pepais,
                                                 ln_Petdoc,
                                                 ln_Pendoc,
                                                 ln_TipCamb,
                                                 ln_Instancia,
                                                 ld_fcheval,
                                                 ld_MinFchCred,
                                                 c.ln_pgcod10,
                                                 c.ln_mod10,
                                                 c.ln_suc10,
                                                 c.ln_mda10,
                                                 c.ln_pap10,
                                                 c.ln_cta10,
                                                 c.ln_oper10,
                                                 c.ln_sbop10,
                                                 c.ln_tope10,
                                                 ln_TipoOri,
                                                 ln_NroCuot,
                                                 ln_Tarea,
                                                 lc_IndCred,
                                                 lc_flgprg,
                                                 0.00,
                                                 0.00);
        
          --  end if;
        end if;
      
      end loop;
    
      for j in lineas_ven(q.ln_cuenta) loop
      
        lc_IndCred := 'LineaVencd';
      
        ln_indicador := 3;
        begin
          select 'S'
            into lc_ven
            from fsr011 a, fsd010 b
           where a.r2cod = j.ln_pgcod10
             and a.r2mod = j.ln_mod10
             and a.r2suc = j.ln_suc10
             and a.r2mda = j.ln_mda10
             and a.r2pap = j.ln_pap10
             and a.r2cta = j.ln_cta10
             and a.r2oper = j.ln_oper10
             and a.r2sbop = j.ln_sbop10
             and a.r2tope = j.ln_tope10
             and a.r1cod = b.pgcod
             and a.r1mod = b.aomod
             and a.r1suc = b.aosuc
             and a.r1mda = b.aomda
             and a.r1pap = b.aopap
             and a.r1cta = b.aocta
             and a.r1oper = b.aooper
             and a.r1sbop = b.aosbop
             and a.r1tope = b.aotope
             and b.aostat <> 99
             and relcod = 46
             and rownum = 1;
        exception
          when no_data_found then
            lc_ven := 'N';
        end;
      
        lc_fgAdic := null;
      
        /* begin
          -- Verifico si el credito vigente tiene cuotas a partir de la primera fecha de pago
          -- del credito agropecuario
          select count(*)
            into ln_TieneCalndario
            from fsd601 f
           where f.pgcod = j.ln_pgcod10
             and f.ppmod = j.ln_mod10
             and f.ppsuc = j.ln_suc10
             and f.ppmda = j.ln_mda10
             and f.pppap = j.ln_pap10
             and f.ppcta = j.ln_cta10
             and f.ppoper = j.ln_oper10
             and f.ppsbop = j.ln_sbop10
             and f.pptope = j.ln_tope10
             and f.d601co = 'S'
             and f.ppfpag >= ld_MinFchCred;
        exception
          when others then
            ln_TieneCalndario := 0;
        end;
        
        if ln_TieneCalndario > 0 then*/
      
        /*PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(j.ln_mod10,
        j.ln_tope10,
        lc_fgAdic);*/
      
        PQ_CR_RATIO_EVALFLUJO.sp_refinanLinea(J.ln_pgcod10,
                                              J.ln_mod10,
                                              J.ln_suc10,
                                              J.ln_mda10,
                                              J.ln_pap10,
                                              J.ln_cta10,
                                              J.ln_oper10,
                                              lc_fgRefLin);
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_VerVincLinea(j.ln_mod10,
                                                 j.ln_suc10,
                                                 j.ln_mda10,
                                                 j.ln_pap10,
                                                 j.ln_cta10,
                                                 j.ln_oper10,
                                                 j.ln_sbop10,
                                                 j.ln_tope10,
                                                 lc_FlgLn);
      
        if lc_ven = 'S' and /*lc_fgAdic <> 'S' and */
           lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        
          ln_InstCred := fn_instancia_credito(j.ln_mod10,
                                              j.ln_suc10,
                                              j.ln_mda10,
                                              j.ln_pap10,
                                              j.ln_cta10,
                                              j.ln_oper10,
                                              j.ln_sbop10,
                                              j.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(j.ln_pgcod10,
                                                     j.ln_mod10,
                                                     j.ln_suc10,
                                                     j.ln_mda10,
                                                     j.ln_pap10,
                                                     j.ln_cta10,
                                                     j.ln_oper10,
                                                     j.ln_sbop10,
                                                     j.ln_tope10,
                                                     ln_NroCuot);
          if j.ln_mod10 = 117 then
            PQ_CR_RATIO_EVALFLUJO.sp_cr_VerfUsoLinea(j.ln_pgcod10,
                                                     j.ln_mod10,
                                                     j.ln_suc10,
                                                     j.ln_mda10,
                                                     j.ln_pap10,
                                                     j.ln_cta10,
                                                     j.ln_oper10,
                                                     j.ln_sbop10,
                                                     j.ln_tope10,
                                                     Tiene_Uso,
                                                     ln_pgcod116,
                                                     ln_modulo116,
                                                     ln_sucursal116,
                                                     ln_moneda116,
                                                     ln_papel116,
                                                     ln_cuenta116,
                                                     ln_operacion116,
                                                     ln_sbop116,
                                                     ln_top116);
          
          end if;
        
          if Tiene_Uso = 'S' and j.ln_mod10 = 117 then
            -- mpostigoc 11.08.2021
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod116,
                                                       ln_modulo116,
                                                       ln_sucursal116,
                                                       ln_moneda116,
                                                       ln_papel116,
                                                       ln_cuenta116,
                                                       ln_operacion116,
                                                       ln_sbop116,
                                                       ln_top116,
                                                       ln_NroCuot);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(ld_FecProc,
                                                   lc_Usuario,
                                                   ln_Pepais,
                                                   ln_Petdoc,
                                                   ln_Pendoc,
                                                   ln_TipCamb,
                                                   ln_Instancia,
                                                   ld_fcheval,
                                                   ld_MinFchCred,
                                                   ln_pgcod116,
                                                   ln_modulo116,
                                                   ln_sucursal116,
                                                   ln_moneda116,
                                                   ln_papel116,
                                                   ln_cuenta116,
                                                   ln_operacion116,
                                                   ln_sbop116,
                                                   ln_top116,
                                                   ln_TipoOri,
                                                   ln_NroCuot,
                                                   ln_Tarea,
                                                   lc_IndCred,
                                                   lc_flgprg,
                                                   0.00,
                                                   0.00);
          else
            if Tiene_Uso = 'N' then
            
              PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(ld_FecProc,
                                                     lc_Usuario,
                                                     ln_Pepais,
                                                     ln_Petdoc,
                                                     ln_Pendoc,
                                                     ln_TipCamb,
                                                     ln_Instancia,
                                                     ld_fcheval,
                                                     ld_MinFchCred,
                                                     j.ln_pgcod10,
                                                     j.ln_mod10,
                                                     j.ln_suc10,
                                                     j.ln_mda10,
                                                     j.ln_pap10,
                                                     j.ln_cta10,
                                                     j.ln_oper10,
                                                     j.ln_sbop10,
                                                     j.ln_tope10,
                                                     ln_TipoOri,
                                                     ln_NroCuot,
                                                     ln_Tarea,
                                                     lc_IndCred,
                                                     lc_flgprg,
                                                     0.00,
                                                     0.00);
            
            end if;
          end if;
        end if;
      
      end loop;
    end loop;
  
    begin
      -- Cuota Contingente  
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CuotaContinCF(ln_Instancia,
                                                ld_FecProc,
                                                lc_flgprg,
                                                lc_Usuario,
                                                lc_prgm,
                                                ln_MntCuoCntgCF);
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CuotaContinAval(ln_Instancia,
                                                  ld_FecProc,
                                                  lc_flgprg,
                                                  lc_Usuario,
                                                  lc_prgm,
                                                  ln_MntCuoCntgAval);
    
      ln_capcontgnt := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
    end;
    commit;
  
  end sp_cr_CalcCuentasII;

  ------------------------------------------------------------------------
  procedure sp_cr_CalcRatio(ln_Instancia in number, lc_prgm in varchar2) is
  
    cursor Lista_OtrosCred(lc_estado varchar2, ln_Tarea number) is
    -- Cursor Creditos que no son Linea (Solo Linea Utilizada) ni Desembolso Parcial
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352mod <> 117 --Excluye Lineas
         and a.aqpa352ori <> 7 --Excluye desembolsos parciales
         and a.aqpa352indcred in ('CredVigent', 'CredVencid', 'CredVuelo')
         and a.aqpa352tarea = ln_Tarea;
  
    cursor linea_vuelo(lc_estado varchar2, ln_Tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'CredVuelo'
         and a.aqpa352mod = 117
         and a.aqpa352tarea = ln_Tarea;
  
    cursor linea_vigente(lc_estado varchar2, ln_Tarea number) is
    -- Linea Vigente sin uso
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'CredVigent'
         and a.aqpa352mod = 117
         and a.aqpa352tarea = ln_Tarea;
  
    cursor linea_vencida(lc_estado varchar2, ln_Tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'LineaVencd'
         and a.aqpa352tarea = ln_Tarea;
  
    cursor credito_parcial(lc_estado varchar2, ln_Tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352ori = 7
         and a.aqpa352indcred in ('CredVigent', 'CredVencid')
         and a.aqpa352tarea = ln_Tarea;
  
    cursor Lista_ParcVuelo(lc_estado varchar2, ln_Tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352ori = 7 -- Desembolsos parciales
         and a.aqpa352indcred = 'CredVuelo'
         and a.aqpa352tarea = ln_Tarea;
  
    ld_MaxFchCalnd     date;
    ln_MntCuoMesAux    number(17, 2) := 0;
    ln_MntCuoMes       number(17, 2) := 0;
    ld_fini            date;
    ld_ffin            date;
    ln_TipCamb         number;
    ln_ratiomens       number(10, 6) := 0;
    lc_estado          varchar2(2);
    ln_MntCuota        number := 0.00;
    ln_emp             number;
    ln_sucur           number;
    ln_mod             number;
    ln_mda             number;
    ln_pap             number;
    ln_cta             number;
    ln_oper            number;
    ln_sbop            number;
    ln_tipoper         number;
    NroCreOtorg        number(17);
    ln_NroCuot         number;
    ln_MntDispnb       number(17, 2) := 0.00;
    ln_CuoDisp         number(17, 2) := 0.00;
    ln_mntacumld       number(17, 2) := 0.00;
    ln_newmnt          number(17, 2) := 0.00;
    lc_VerfDesembPendt varchar2(5) := 'T';
    ln_NroDesemblsPact number := 0;
    ln_DesembHechos    number := 0;
    ln_CuotPendt       number(17, 2) := 0.00;
    ld_MaxFechCalnd    date;
    ld_UltDia          date;
    lc_fgAdic          varchar2(2) := 'N';
    ln_MaxPlazAdi      number := 0;
    ln_CuoCapAdi       number(17, 2) := 0.00;
    LC_VerfAdi         varchar2(2) := 'N';
    ln_TieneCalndario  number := 0;
    ln_Tarea           number := 0; --26.10.20202 mpostigoc
  
  begin
  
    if lc_prgm = 'RAQPA367' then
      lc_estado := 'H';
    else
      if lc_prgm = 'RJAQY843' then
        lc_estado := 'R';
      end if;
    end if;
  
    begin
      --Tipo de Cambio
      select s. sng120tcbi
        into ln_TipCamb
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipCamb := 0;
    end;
  
    begin
      select min(a.aqpa411feca)
        into ld_ffin
        from aqpa411 a
       where a.aqpa411inst = ln_Instancia;
    EXCEPTION
      when others then
        null;
    end;
  
    begin
      select max(a.aqpa411feca)
        into ld_MaxFchCalnd
        from aqpa411 a
       where a.aqpa411inst = ln_Instancia;
    EXCEPTION
      when others then
        null;
    end;
  
    begin
      ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
    end;
  
    begin
      begin
        select x.xwfempresa,
               x.xwfsucursal,
               x.xwfmodulo,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_emp,
               ln_sucur,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_oper,
               ln_sbop,
               ln_tipoper
          from xwf700 x
         where x.xwfprcins = ln_Instancia
           and x.xwfcar3 = '1';
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        if ln_mod <> 117 then
        
          begin
            select months_between(max(f.ppfvto), min(f.ppfval))
              into NroCreOtorg
              from fsd601 f
             where f.pgcod = ln_emp
               and f.ppmod = ln_mod
               and f.ppsuc = ln_sucur
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_oper
               and f.ppsbop = ln_sbop
               and f.pptope = ln_tipoper;
          exception
            when others then
              NroCreOtorg := 0;
          end;
        
        else
          if ln_mod = 117 then
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod        => ln_emp,
                                                       ln_modulo       => ln_mod,
                                                       ln_sucursal     => ln_sucur,
                                                       ln_moneda       => ln_mda,
                                                       ln_papel        => ln_pap,
                                                       ln_cuenta       => ln_cta,
                                                       ln_operacion    => ln_oper,
                                                       ln_suboperacion => ln_sbop,
                                                       ln_tipoperacion => ln_tipoper,
                                                       ln_NroCuot      => NroCreOtorg);
          end if;
        end if;
      end;
    
    end;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    for oc in Lista_OtrosCred(lc_estado, ln_Tarea) loop
    
      begin
        select min(a.aqpa411feca)
          into ld_ffin
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
      begin
        select max(a.aqpa411feca)
          into ld_MaxFchCalnd
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(oc.ln_pgcod,
                                             oc.ln_mod,
                                             oc.ln_suc,
                                             oc.ln_mda,
                                             oc.ln_pap,
                                             oc.ln_cta,
                                             oc.ln_ope,
                                             oc.ln_sbop,
                                             oc.ln_tope,
                                             ld_fini,
                                             ld_ffin,
                                             ln_TipCamb,
                                             ln_NroCuot,
                                             ln_MntCuota);
      
        begin
          PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                      ln_modulo      => oc.LN_MOD,
                                                      ln_mntcuota    => ln_MntCuota,
                                                      ld_fchPanel    => ld_ffin,
                                                      ln_NroCuOtorg  => NroCreOtorg,
                                                      ln_NroCuotCred => ln_NroCuot,
                                                      lc_programa    => lc_prgm,
                                                      lc_Indicador   => oc.lc_indcred);
        
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      
      end loop;
    
      if oc.ln_mod = 116 then
      
        PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(oc.ln_mod,
                                              oc.ln_tope,
                                              lc_fgAdic);
      
        if lc_fgAdic = 'N' then
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcDisponible(oc.ln_pgcod,
                                                     oc.ln_mod,
                                                     oc.ln_suc,
                                                     oc.ln_mda,
                                                     oc.ln_pap,
                                                     oc.ln_cta,
                                                     oc.ln_ope,
                                                     oc.ln_sbop,
                                                     oc.ln_tope,
                                                     ln_MntDispnb);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuotaDispnbl(ln_pgcod        => oc.ln_pgcod,
                                                      ln_suc          => oc.ln_suc,
                                                      ln_mod          => oc.ln_mod,
                                                      ln_mda          => oc.ln_mda,
                                                      ln_pap          => oc.ln_pap,
                                                      ln_cta          => oc.ln_cta,
                                                      ln_oper         => oc.ln_ope,
                                                      ln_sbop         => oc.ln_sbop,
                                                      ln_tope         => oc.ln_tope,
                                                      ln_MntDispnbl   => ln_MntDispnb,
                                                      tipocambio      => ln_TipCamb,
                                                      ln_CuotaDispnbl => ln_CuoDisp);
        
          ln_CuoDisp := nvl(ln_CuoDisp, 0);
          ln_CuoDisp := ln_CuoDisp * NroCreOtorg;
        
          if ln_mod = 117 then
            NroCreOtorg := NroCreOtorg + 1;
          end if;
        
          if ln_mod = 117 then
          
            begin
              select a.AQPA353capcaja
                into ln_mntacumld
                from AQPA353 a
               where a.AQPA353inst = ln_Instancia
                 and a.AQPA353corr = NroCreOtorg
                 and a.AQPA353est = lc_estado
                 and a.aqpa353tarea = ln_Tarea;
            exception
              when others then
                ln_mntacumld := 0.00;
            end;
          
            ln_mntacumld := nvl(ln_mntacumld, 0);
            begin
              ln_newmnt := ln_mntacumld + ln_CuoDisp;
              ln_newmnt := nvl(ln_newmnt, 0);
            end;
          
            begin
              update AQPA353 a
                 set a.AQPA353capcaja = ln_newmnt
               where a.AQPA353inst = ln_Instancia
                 and a.AQPA353est = lc_estado
                 AND a.AQPA353corr = NroCreOtorg
                 and a.aqpa353tarea = ln_Tarea;
            end;
          
          else
            if ln_mod <> 117 then
            
              begin
                select max(f.ppfpag)
                  into ld_MaxFechCalnd
                  from fsd601 f
                 where f.pgcod = ln_emp
                   and f.ppmod = ln_mod
                   and f.ppsuc = ln_sucur
                   and f.ppmda = ln_mda
                   and f.pppap = ln_pap
                   and f.ppcta = ln_cta
                   and f.ppoper = ln_oper
                   and f.ppsbop = ln_sbop
                   and f.pptope = ln_tipoper
                   and f.d601co in ('X', 'E');
              exception
                when others then
                  null;
              end;
            
              begin
                begin
                  ld_UltDia := last_Day(ld_MaxFechCalnd);
                end;
              end;
            
              begin
                select a.AQPA353capcaja
                  into ln_mntacumld
                  from AQPA353 a
                 where a.AQPA353inst = ln_Instancia
                   and a.aqpa353fecal = ld_UltDia
                   and a.AQPA353est = lc_estado
                   and a.aqpa353tarea = ln_Tarea;
              exception
                when others then
                  ln_mntacumld := 0.00;
              end;
            
              ln_mntacumld := nvl(ln_mntacumld, 0);
              begin
                ln_newmnt := ln_mntacumld + ln_CuoDisp;
                ln_newmnt := nvl(ln_newmnt, 0);
              end;
            
              begin
                update AQPA353 a
                   set a.AQPA353capcaja = ln_newmnt
                 where a.AQPA353inst = ln_Instancia
                   and a.AQPA353est = lc_estado
                   and a.aqpa353fecal = ld_UltDia
                   and a.aqpa353tarea = ln_Tarea;
              end;
            
            end if;
          end if;
        
        else
          if lc_fgAdic = 'S' then
            ln_newmnt := 0;
          
            pq_cr_ratio_evalflujo.sp_CapLineaAdicional(ln_mod10        => oc.ln_mod,
                                                       ln_suc10        => oc.ln_suc,
                                                       ln_mda10        => oc.ln_mda,
                                                       ln_pap10        => oc.ln_pap,
                                                       ln_cta10        => oc.ln_cta,
                                                       ln_oper10       => oc.ln_ope,
                                                       ln_sbop10       => oc.ln_sbop,
                                                       ln_tope10       => oc.ln_tope,
                                                       tipocambio      => ln_TipCamb,
                                                       ln_plazo        => ln_MaxPlazAdi,
                                                       ln_CapAdicional => ln_CuoCapAdi);
          
            ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
          
            begin
              select a.AQPA353capcaja
                into ln_mntacumld
                from AQPA353 a
               where a.AQPA353inst = ln_Instancia
                 and a.aqpa353corr = ln_MaxPlazAdi
                 and a.AQPA353est = lc_estado
                 and a.aqpa353tarea = ln_Tarea;
            exception
              when others then
                ln_mntacumld := 0.00;
            end;
          
            ln_mntacumld := nvl(ln_mntacumld, 0);
          
            begin
              ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
              ln_newmnt := nvl(ln_newmnt, 0);
            end;
          
            begin
              update AQPA353 a
                 set a.AQPA353capcaja = ln_newmnt
               where a.AQPA353inst = ln_Instancia
                 and a.AQPA353est = lc_estado
                 AND a.AQPA353corr = ln_MaxPlazAdi
                 and a.aqpa353tarea = ln_Tarea;
            end;
          
          end if;
        end if;
      
      end if;
    
    end loop;
  
    for lv in linea_vuelo(lc_estado, ln_Tarea) loop
    
      ln_MaxPlazAdi := 0;
      ln_CuoCapAdi  := 0.00;
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lv.ln_pgcod,
                                           lv.ln_mod,
                                           lv.ln_suc,
                                           lv.ln_mda,
                                           lv.ln_pap,
                                           lv.ln_cta,
                                           lv.ln_ope,
                                           lv.ln_sbop,
                                           lv.ln_tope,
                                           ld_fini,
                                           ld_ffin,
                                           ln_TipCamb,
                                           ln_NroCuot,
                                           ln_MntCuota);
    
      begin
        PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                    ln_modulo      => Lv.LN_MOD,
                                                    ln_mntcuota    => ln_MntCuota,
                                                    ld_fchPanel    => ld_ffin,
                                                    ln_NroCuOtorg  => NroCreOtorg,
                                                    ln_NroCuotCred => ln_NroCuot,
                                                    lc_programa    => lc_prgm,
                                                    lc_Indicador   => lv.lc_indcred);
      end;
    
      pq_cr_ratio_evalflujo.sp_CapLineaAdiVuel(ln_mod10        => lv.ln_mod,
                                               ln_suc10        => lv.ln_suc,
                                               ln_mda10        => lv.ln_mda,
                                               ln_pap10        => lv.ln_pap,
                                               ln_cta10        => lv.ln_cta,
                                               ln_oper10       => lv.ln_ope,
                                               ln_sbop10       => lv.ln_sbop,
                                               ln_tope10       => lv.ln_tope,
                                               tipocambio      => ln_TipCamb,
                                               ln_plazo        => ln_MaxPlazAdi,
                                               ln_CapAdicional => ln_CuoCapAdi);
    
      ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
    
      if ln_CuoCapAdi > 0 then
        begin
          select a.AQPA353capcaja
            into ln_mntacumld
            from AQPA353 a
           where a.AQPA353inst = ln_Instancia
             and a.aqpa353corr = ln_MaxPlazAdi
             and a.AQPA353est = lc_estado
             and a.aqpa353tarea = ln_Tarea;
        exception
          when others then
            ln_mntacumld := 0.00;
        end;
      
        ln_mntacumld := nvl(ln_mntacumld, 0);
      
        begin
          ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
          ln_newmnt := nvl(ln_newmnt, 0);
        end;
      
        begin
          update AQPA353 a
             set a.AQPA353capcaja = ln_newmnt
           where a.AQPA353inst = ln_Instancia
             and a.AQPA353est = lc_estado
             AND a.AQPA353corr = ln_MaxPlazAdi
             and a.aqpa353tarea = ln_Tarea;
        end;
      
      end if;
    
    end loop;
  
    for lg in linea_vigente(lc_estado, ln_Tarea) loop
    
      PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(pn_mod  => LG.LN_MOD,
                                            pn_top  => LG.LN_TOPE,
                                            Pc_flag => LC_VerfAdi);
    
      if LC_VerfAdi = 'N' then
      
        begin
          pq_cr_resolutor_cappago.sp_capacidadlinea(lg.ln_mod,
                                                    lg.ln_suc,
                                                    lg.ln_mda,
                                                    lg.ln_pap,
                                                    lg.ln_cta,
                                                    lg.ln_ope,
                                                    lg.ln_sbop,
                                                    lg.ln_tope,
                                                    ln_TipCamb,
                                                    ln_MntCuoMesAux);
        
          ln_MntCuota := ln_MntCuoMesAux * NroCreOtorg;
          ln_MntCuota := nvl(ln_MntCuota, 0);
        
        end;
      
        begin
          PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                      ln_modulo      => Lg.LN_MOD,
                                                      ln_mntcuota    => ln_MntCuota,
                                                      ld_fchPanel    => ld_ffin,
                                                      ln_NroCuOtorg  => NroCreOtorg,
                                                      ln_NroCuotCred => ln_NroCuot,
                                                      lc_programa    => lc_prgm,
                                                      lc_Indicador   => lg.lc_indcred);
        end;
      
      else
        if LC_VerfAdi = 'S' then
          pq_cr_ratio_evalflujo.sp_CapLineaAdicional(ln_mod10        => Lg.ln_mod,
                                                     ln_suc10        => Lg.ln_suc,
                                                     ln_mda10        => Lg.ln_mda,
                                                     ln_pap10        => Lg.ln_pap,
                                                     ln_cta10        => Lg.ln_cta,
                                                     ln_oper10       => Lg.ln_ope,
                                                     ln_sbop10       => Lg.ln_sbop,
                                                     ln_tope10       => Lg.ln_tope,
                                                     tipocambio      => ln_TipCamb,
                                                     ln_plazo        => ln_MaxPlazAdi,
                                                     ln_CapAdicional => ln_CuoCapAdi);
        
          ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
        
          if ln_CuoCapAdi > 0 then
            begin
              select a.AQPA353capcaja
                into ln_mntacumld
                from AQPA353 a
               where a.AQPA353inst = ln_Instancia
                 and a.aqpa353corr = ln_MaxPlazAdi
                 and a.AQPA353est = lc_estado
                 and a.aqpa353tarea = ln_Tarea;
            exception
              when others then
                ln_mntacumld := 0.00;
            end;
          
            ln_mntacumld := nvl(ln_mntacumld, 0);
          
            begin
              ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
              ln_newmnt := nvl(ln_newmnt, 0);
            end;
          
            begin
              update AQPA353 a
                 set a.AQPA353capcaja = ln_newmnt
               where a.AQPA353inst = ln_Instancia
                 and a.AQPA353est = lc_estado
                 AND a.AQPA353corr = ln_MaxPlazAdi
                 and a.aqpa353tarea = ln_Tarea;
            end;
          end if;
        end if;
      end if;
    
    end loop;
  
    for lc in linea_vencida(lc_estado, ln_Tarea) loop
    
      begin
        select min(a.aqpa411feca)
          into ld_ffin
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
      begin
        select max(a.aqpa411feca)
          into ld_MaxFchCalnd
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lc.ln_pgcod,
                                             lc.ln_mod,
                                             lc.ln_suc,
                                             lc.ln_mda,
                                             lc.ln_pap,
                                             lc.ln_cta,
                                             lc.ln_ope,
                                             lc.ln_sbop,
                                             lc.ln_tope,
                                             ld_fini,
                                             ld_ffin,
                                             ln_TipCamb,
                                             ln_NroCuot,
                                             ln_MntCuota);
      
        begin
          PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                      ln_modulo      => Lc.LN_MOD,
                                                      ln_mntcuota    => ln_MntCuota,
                                                      ld_fchPanel    => ld_ffin,
                                                      ln_NroCuOtorg  => NroCreOtorg,
                                                      ln_NroCuotCred => ln_NroCuot,
                                                      lc_programa    => lc_prgm,
                                                      lc_Indicador   => lc.lc_indcred);
        
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      end loop;
    end loop;
  
    for cp in credito_parcial(lc_estado, ln_Tarea) loop
      pq_cr_ratio_evalflujo.sp_cr_VerfDesmbPendiente(cp.ln_pgcod,
                                                     cp.ln_mod,
                                                     cp.ln_suc,
                                                     cp.ln_mda,
                                                     cp.ln_pap,
                                                     cp.ln_cta,
                                                     cp.ln_ope,
                                                     cp.ln_sbop,
                                                     cp.ln_tope,
                                                     lc_VerfDesembPendt,
                                                     ln_NroDesemblsPact,
                                                     ln_DesembHechos);
    
      if lc_VerfDesembPendt = 'P' then
        -- Con Desembolso Pendiente    
      
        Pq_Cr_Ratio_Evalflujo.sp_Cr_CalcParcialPend(cp.ln_pgcod,
                                                    cp.ln_mod,
                                                    cp.ln_suc,
                                                    cp.ln_mda,
                                                    cp.ln_pap,
                                                    cp.ln_cta,
                                                    cp.ln_ope,
                                                    cp.ln_sbop,
                                                    cp.ln_tope,
                                                    ln_DesembHechos,
                                                    ln_TipCamb,
                                                    ln_CuotPendt);
      
        ln_MntCuota := nvl(ln_CuotPendt, 0);
      
        begin
          select min(a.aqpa411feca)
            into ld_ffin
            from aqpa411 a
           where a.aqpa411inst = ln_Instancia;
        EXCEPTION
          when others then
            null;
        end;
        begin
          select max(a.aqpa411feca)
            into ld_MaxFchCalnd
            from aqpa411 a
           where a.aqpa411inst = ln_Instancia;
        EXCEPTION
          when others then
            null;
        end;
      
        begin
          ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
        end;
      
        while ld_ffin <= ld_MaxFchCalnd loop
        
          begin
            -- Verifico si el credito vigente tiene cuotas en el periodo 
            select count(*)
              into ln_TieneCalndario
              from fsd601 f
             where f.pgcod = cp.ln_pgcod
               and f.ppmod = cp.ln_mod
               and f.ppsuc = cp.ln_suc
               and f.ppmda = cp.ln_mda
               and f.pppap = cp.ln_pap
               and f.ppcta = cp.ln_cta
               and f.ppoper = cp.ln_ope
               and f.ppsbop = cp.ln_sbop
               and f.pptope = cp.ln_tope
               and f.d601co = 'S'
               and f.ppfpag between ld_fini and ld_ffin;
          exception
            when others then
              ln_TieneCalndario := 0;
          end;
        
          if ln_TieneCalndario > 0 then
          
            begin
              PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                          ln_modulo      => cp.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_programa    => lc_prgm,
                                                          lc_Indicador   => cp.lc_indcred);
            
            end;
          end if;
        
          ld_fini := add_months(ld_fini, +1);
          ld_ffin := add_months(ld_ffin, +1);
        end loop;
      
      else
        if lc_VerfDesembPendt = 'T' then
          -- Con Desembolso Total  
          begin
            select min(a.aqpa411feca)
              into ld_ffin
              from aqpa411 a
             where a.aqpa411inst = ln_Instancia;
          EXCEPTION
            when others then
              null;
          end;
        
          begin
            select max(a.aqpa411feca)
              into ld_MaxFchCalnd
              from aqpa411 a
             where a.aqpa411inst = ln_Instancia;
          EXCEPTION
            when others then
              null;
          end;
        
          begin
            ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
          end;
        
          while ld_ffin <= ld_MaxFchCalnd loop
          
            ln_MntCuoMesAux := 0;
            ln_MntCuoMes    := 0;
            ln_ratiomens    := 0;
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(cp.ln_pgcod,
                                                 cp.ln_mod,
                                                 cp.ln_suc,
                                                 cp.ln_mda,
                                                 cp.ln_pap,
                                                 cp.ln_cta,
                                                 cp.ln_ope,
                                                 cp.ln_sbop,
                                                 cp.ln_tope,
                                                 ld_fini,
                                                 ld_ffin,
                                                 ln_TipCamb,
                                                 ln_NroCuot,
                                                 ln_MntCuota);
          
            begin
              PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                          ln_modulo      => cp.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_programa    => lc_prgm,
                                                          lc_Indicador   => cp.lc_indcred);
            
            end;
          
            ld_fini := add_months(ld_fini, +1);
            ld_ffin := add_months(ld_ffin, +1);
          
          end loop;
        
        end if;
      end if;
    
    end loop;
  
    for pv in Lista_ParcVuelo(lc_estado, ln_Tarea) loop
      begin
        select min(a.aqpa411feca)
          into ld_ffin
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
      begin
        select max(a.aqpa411feca)
          into ld_MaxFchCalnd
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(pv.ln_pgcod,
                                             pv.ln_mod,
                                             pv.ln_suc,
                                             pv.ln_mda,
                                             pv.ln_pap,
                                             pv.ln_cta,
                                             pv.ln_ope,
                                             pv.ln_sbop,
                                             pv.ln_tope,
                                             ld_fini,
                                             ld_ffin,
                                             ln_TipCamb,
                                             ln_NroCuot,
                                             ln_MntCuota);
      
        begin
          PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                      ln_modulo      => pv.LN_MOD,
                                                      ln_mntcuota    => ln_MntCuota,
                                                      ld_fchPanel    => ld_ffin,
                                                      ln_NroCuOtorg  => NroCreOtorg,
                                                      ln_NroCuotCred => ln_NroCuot,
                                                      lc_programa    => lc_prgm,
                                                      lc_Indicador   => pv.lc_indcred);
        
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      
      end loop;
    
    end loop;
  
    begin
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalFormula(ln_Instancia, lc_prgm);
    end;
  
  end sp_cr_CalcRatio;
  -------------------------------------------------------------------------
  procedure sp_cr_CalcRatioPanel(ln_Instancia in number) is
  
    cursor Lista_OtrosCred(lc_estado varchar2, ln_Tarea number) is
    -- Cursor Creditos que no son Linea ni Desembolso Parcial
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352mod <> 117 --Excluye Lineas
         and a.aqpa352ori <> 7 --Excluye desembolsos parciales
         and a.aqpa352indcred in ('CredVigent', 'CredVencid', 'CredVuelo')
         and a.aqpa352tarea = ln_Tarea;
  
    cursor linea_vuelo(lc_estado varchar2, ln_Tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'CredVuelo'
         and a.aqpa352mod = 117
         and a.aqpa352tarea = ln_Tarea;
  
    cursor linea_vigente(lc_estado varchar2, ln_Tarea number) is
    -- Linea Vigente sin uso
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'CredVigent'
         and a.aqpa352mod = 117
         and a.aqpa352tarea = ln_Tarea;
  
    cursor linea_vencida(lc_estado varchar2, ln_Tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'LineaVencd'
         and a.aqpa352tarea = ln_Tarea;
  
    cursor credito_parcial(lc_estado varchar2, ln_Tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352ori = 7
         and a.aqpa352indcred in ('CredVigent', 'CredVencid')
         and a.aqpa352tarea = ln_Tarea;
  
    cursor Lista_ParcVuelo(lc_estado varchar2, ln_Tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352ori = 7 -- Desembolsos parciales
         and a.aqpa352indcred = 'CredVuelo'
         and a.aqpa352tarea = ln_Tarea;
  
    ld_MaxFchCalnd     date;
    ln_MntCuoMesAux    number(17, 2) := 0;
    ln_MntCuoMes       number(17, 2) := 0;
    ld_fini            date;
    ld_ffin            date;
    ln_TipCamb         number(14, 8) := 0.00000000;
    ln_ratiomens       number(10, 6) := 0;
    lc_estado          varchar2(2);
    ln_MntCuota        number(17, 2) := 0.00;
    ln_emp             number;
    ln_sucur           number;
    ln_mod             number;
    ln_mda             number;
    ln_pap             number;
    ln_cta             number;
    ln_oper            number;
    ln_sbop            number;
    ln_tipoper         number;
    NroCreOtorg        number(17);
    ln_NroCuot         number;
    ln_MntDispnb       number(17, 2) := 0.00;
    ln_CuoDisp         number(17, 2) := 0.00;
    ln_mntacumld       number(17, 2) := 0.00;
    ln_newmnt          number(17, 2) := 0.00;
    lc_VerfDesembPendt varchar2(5) := 'T';
    ln_NroDesemblsPact number := 0;
    ln_DesembHechos    number := 0;
    ln_CuotPendt       number(17, 2) := 0.00;
    ld_MaxFechCalnd    date;
    ld_UltDia          date;
    lc_fgAdic          varchar2(2) := 'N';
    LC_VerfAdi         varchar2(2) := 'N';
    ln_MaxPlazAdi      number := 0;
    ln_CuoCapAdi       number(17, 2) := 0.00;
    ln_TieneCalndario  number := 0;
    ln_Tarea           number;
  
  begin
  
    -- Solo si la tarea y programa stan incluidos en la guia pueden ejecutar el ratio
    -- excepcionado la impresion de ratios
  
    lc_estado := 'H';
  
    begin
      --Tipo de Cambio
      select s. sng120tcbi
        into ln_TipCamb
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipCamb := 0;
    end;
  
    begin
      select min(a.aqpa411feca)
        into ld_ffin
        from aqpa411 a
       where a.aqpa411inst = ln_Instancia;
    EXCEPTION
      when others then
        null;
    end;
  
    begin
      select max(a.aqpa411feca)
        into ld_MaxFchCalnd
        from aqpa411 a
       where a.aqpa411inst = ln_Instancia;
    EXCEPTION
      when others then
        null;
    end;
  
    begin
      ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
    end;
  
    begin
      begin
        select x.xwfempresa,
               x.xwfsucursal,
               x.xwfmodulo,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_emp,
               ln_sucur,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_oper,
               ln_sbop,
               ln_tipoper
          from xwf700 x
         where x.xwfprcins = ln_Instancia
           and x.xwfcar3 = '1';
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        if ln_mod <> 117 then
        
          begin
            select months_between(max(f.ppfvto), min(f.ppfval))
              into NroCreOtorg
              from fsd601 f
             where f.pgcod = ln_emp
               and f.ppmod = ln_mod
               and f.ppsuc = ln_sucur
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_oper
               and f.ppsbop = ln_sbop
               and f.pptope = ln_tipoper;
          exception
            when others then
              NroCreOtorg := 0;
          end;
        
        else
          if ln_mod = 117 then
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod        => ln_emp,
                                                       ln_modulo       => ln_mod,
                                                       ln_sucursal     => ln_sucur,
                                                       ln_moneda       => ln_mda,
                                                       ln_papel        => ln_pap,
                                                       ln_cuenta       => ln_cta,
                                                       ln_operacion    => ln_oper,
                                                       ln_suboperacion => ln_sbop,
                                                       ln_tipoperacion => ln_tipoper,
                                                       ln_NroCuot      => NroCreOtorg);
          end if;
        end if;
      end;
    
    end;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    for oc in Lista_OtrosCred(lc_estado, ln_Tarea) loop
    
      begin
        select min(a.aqpa411feca)
          into ld_ffin
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        select max(a.aqpa411feca)
          into ld_MaxFchCalnd
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(oc.ln_pgcod,
                                             oc.ln_mod,
                                             oc.ln_suc,
                                             oc.ln_mda,
                                             oc.ln_pap,
                                             oc.ln_cta,
                                             oc.ln_ope,
                                             oc.ln_sbop,
                                             oc.ln_tope,
                                             ld_fini,
                                             ld_ffin,
                                             ln_TipCamb,
                                             ln_NroCuot,
                                             ln_MntCuota);
      
        begin
          PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                      ln_modulo      => oc.LN_MOD,
                                                      ln_mntcuota    => ln_MntCuota,
                                                      ld_fchPanel    => ld_ffin,
                                                      ln_NroCuOtorg  => NroCreOtorg,
                                                      ln_NroCuotCred => ln_NroCuot,
                                                      lc_Indicador   => oc.lc_indcred);
        
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      
      end loop;
    
      if oc.ln_mod = 116 then
      
        PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(oc.ln_mod,
                                              oc.ln_tope,
                                              lc_fgAdic);
      
        if lc_fgAdic = 'N' then
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcDisponible(oc.ln_pgcod,
                                                     oc.ln_mod,
                                                     oc.ln_suc,
                                                     oc.ln_mda,
                                                     oc.ln_pap,
                                                     oc.ln_cta,
                                                     oc.ln_ope,
                                                     oc.ln_sbop,
                                                     oc.ln_tope,
                                                     ln_MntDispnb);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuotaDispnbl(ln_pgcod        => oc.ln_pgcod,
                                                      ln_suc          => oc.ln_suc,
                                                      ln_mod          => oc.ln_mod,
                                                      ln_mda          => oc.ln_mda,
                                                      ln_pap          => oc.ln_pap,
                                                      ln_cta          => oc.ln_cta,
                                                      ln_oper         => oc.ln_ope,
                                                      ln_sbop         => oc.ln_sbop,
                                                      ln_tope         => oc.ln_tope,
                                                      ln_MntDispnbl   => ln_MntDispnb,
                                                      tipocambio      => ln_TipCamb,
                                                      ln_CuotaDispnbl => ln_CuoDisp);
        
          ln_CuoDisp := nvl(ln_CuoDisp, 0);
          ln_CuoDisp := ln_CuoDisp * NroCreOtorg;
        
          if ln_mod = 117 then
            NroCreOtorg := NroCreOtorg + 1;
          end if;
        
          if ln_mod = 117 then
          
            begin
              select a.AQPA356capcaja
                into ln_mntacumld
                from AQPA356 a
               where a.AQPA356inst = ln_Instancia
                 and a.AQPA356corr = NroCreOtorg
                 and a.AQPA356est = 'H';
            exception
              when others then
                ln_mntacumld := 0.00;
            end;
          
            ln_mntacumld := nvl(ln_mntacumld, 0);
            begin
              ln_newmnt := ln_mntacumld + ln_CuoDisp;
              ln_newmnt := nvl(ln_newmnt, 0);
            end;
          
            begin
              update AQPA356 a
                 set a.AQPA356capcaja = ln_newmnt
               where a.AQPA356inst = ln_Instancia
                 and a.AQPA356est = 'H'
                 AND a.AQPA356corr = NroCreOtorg;
            end;
          
          else
            if ln_mod <> 117 then
            
              begin
                select max(f.ppfpag)
                  into ld_MaxFechCalnd
                  from fsd601 f
                 where f.pgcod = ln_emp
                   and f.ppmod = ln_mod
                   and f.ppsuc = ln_sucur
                   and f.ppmda = ln_mda
                   and f.pppap = ln_pap
                   and f.ppcta = ln_cta
                   and f.ppoper = ln_oper
                   and f.ppsbop = ln_sbop
                   and f.pptope = ln_tipoper
                   and f.d601co in ('X', 'E');
              exception
                when others then
                  null;
              end;
            
              begin
                begin
                  ld_UltDia := last_Day(ld_MaxFechCalnd);
                end;
              end;
            
              begin
                select a.AQPA356capcaja
                  into ln_mntacumld
                  from AQPA356 a
                 where a.AQPA356inst = ln_Instancia
                   and a.aqpa356fecal = ld_UltDia
                   and a.AQPA356est = 'H';
              exception
                when others then
                  ln_mntacumld := 0.00;
              end;
            
              ln_mntacumld := nvl(ln_mntacumld, 0);
              begin
                ln_newmnt := ln_mntacumld + ln_CuoDisp;
                ln_newmnt := nvl(ln_newmnt, 0);
              end;
            
              begin
                update AQPA356 a
                   set a.AQPA356capcaja = ln_newmnt
                 where a.AQPA356inst = ln_Instancia
                   and a.AQPA356est = 'H'
                   and a.aqpa356fecal = ld_UltDia;
              end;
            
            end if;
          end if;
        
        else
          if lc_fgAdic = 'S' then
          
            ln_newmnt := 0;
          
            pq_cr_ratio_evalflujo.sp_CapLineaAdicional(ln_mod10        => oc.ln_mod,
                                                       ln_suc10        => oc.ln_suc,
                                                       ln_mda10        => oc.ln_mda,
                                                       ln_pap10        => oc.ln_pap,
                                                       ln_cta10        => oc.ln_cta,
                                                       ln_oper10       => oc.ln_ope,
                                                       ln_sbop10       => oc.ln_sbop,
                                                       ln_tope10       => oc.ln_tope,
                                                       tipocambio      => ln_TipCamb,
                                                       ln_plazo        => ln_MaxPlazAdi,
                                                       ln_CapAdicional => ln_CuoCapAdi);
          
            ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
          
            begin
              select a.AQPA356capcaja
                into ln_mntacumld
                from AQPA356 a
               where a.AQPA356inst = ln_Instancia
                 and a.aqpa356corr = ln_MaxPlazAdi
                 and a.AQPA356est = 'H';
            exception
              when others then
                ln_mntacumld := 0.00;
            end;
          
            ln_mntacumld := nvl(ln_mntacumld, 0);
          
            begin
              ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
              ln_newmnt := nvl(ln_newmnt, 0);
            end;
          
            begin
              update AQPA356 a
                 set a.AQPA356capcaja = ln_newmnt
               where a.AQPA356inst = ln_Instancia
                 and a.AQPA356est = 'H'
                 AND a.AQPA356corr = ln_MaxPlazAdi;
            end;
          end if;
        end if;
      end if;
    
    end loop;
  
    for lv in linea_vuelo(lc_estado, ln_Tarea) loop
      ln_MaxPlazAdi := 0;
      ln_CuoCapAdi  := 0.00;
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lv.ln_pgcod,
                                           lv.ln_mod,
                                           lv.ln_suc,
                                           lv.ln_mda,
                                           lv.ln_pap,
                                           lv.ln_cta,
                                           lv.ln_ope,
                                           lv.ln_sbop,
                                           lv.ln_tope,
                                           ld_fini,
                                           ld_ffin,
                                           ln_TipCamb,
                                           ln_NroCuot,
                                           ln_MntCuota);
    
      begin
        PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                    ln_modulo      => Lv.LN_MOD,
                                                    ln_mntcuota    => ln_MntCuota,
                                                    ld_fchPanel    => ld_ffin,
                                                    ln_NroCuOtorg  => NroCreOtorg,
                                                    ln_NroCuotCred => ln_NroCuot,
                                                    lc_Indicador   => lv.lc_indcred);
      
      end;
    
      pq_cr_ratio_evalflujo.sp_CapLineaAdiVuel(ln_mod10        => lv.ln_mod,
                                               ln_suc10        => lv.ln_suc,
                                               ln_mda10        => lv.ln_mda,
                                               ln_pap10        => lv.ln_pap,
                                               ln_cta10        => lv.ln_cta,
                                               ln_oper10       => lv.ln_ope,
                                               ln_sbop10       => lv.ln_sbop,
                                               ln_tope10       => lv.ln_tope,
                                               tipocambio      => ln_TipCamb,
                                               ln_plazo        => ln_MaxPlazAdi,
                                               ln_CapAdicional => ln_CuoCapAdi);
    
      ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
    
      if ln_CuoCapAdi > 0 then
        begin
          select a.AQPA356capcaja
            into ln_mntacumld
            from AQPA356 a
           where a.AQPA356inst = ln_Instancia
             and a.aqpa356corr = ln_MaxPlazAdi
             and a.AQPA356est = 'H';
        exception
          when others then
            ln_mntacumld := 0.00;
        end;
      
        ln_mntacumld := nvl(ln_mntacumld, 0);
      
        begin
          ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
          ln_newmnt := nvl(ln_newmnt, 0);
        end;
      
        begin
          update AQPA356 a
             set a.AQPA356capcaja = ln_newmnt
           where a.AQPA356inst = ln_Instancia
             and a.AQPA356est = 'H'
             AND a.AQPA356corr = ln_MaxPlazAdi;
        end;
      
      end if;
    end loop;
  
    for lg in linea_vigente(lc_estado, ln_Tarea) loop
    
      ln_MaxPlazAdi := 0;
      ln_CuoCapAdi  := 0.00;
    
      --if ln_mod = 117 then
    
      PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(pn_mod  => LG.LN_MOD,
                                            pn_top  => LG.LN_TOPE,
                                            Pc_flag => LC_VerfAdi);
    
      if LC_VerfAdi = 'N' then
      
        begin
          pq_cr_resolutor_cappago.sp_capacidadlinea(lg.ln_mod,
                                                    lg.ln_suc,
                                                    lg.ln_mda,
                                                    lg.ln_pap,
                                                    lg.ln_cta,
                                                    lg.ln_ope,
                                                    lg.ln_sbop,
                                                    lg.ln_tope,
                                                    ln_TipCamb,
                                                    ln_MntCuoMesAux);
        
          ln_MntCuota := ln_MntCuoMesAux * NroCreOtorg;
          ln_MntCuota := nvl(ln_MntCuota, 0);
        
        end;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                    ln_modulo      => Lg.LN_MOD,
                                                    ln_mntcuota    => ln_MntCuota,
                                                    ld_fchPanel    => ld_ffin,
                                                    ln_NroCuOtorg  => NroCreOtorg,
                                                    ln_NroCuotCred => ln_NroCuot,
                                                    lc_Indicador   => lg.lc_indcred);
      else
        if LC_VerfAdi = 'S' then
        
          pq_cr_ratio_evalflujo.sp_CapLineaAdicional(ln_mod10        => lg.ln_mod,
                                                     ln_suc10        => lg.ln_suc,
                                                     ln_mda10        => lg.ln_mda,
                                                     ln_pap10        => lg.ln_pap,
                                                     ln_cta10        => lg.ln_cta,
                                                     ln_oper10       => lg.ln_ope,
                                                     ln_sbop10       => lg.ln_sbop,
                                                     ln_tope10       => lg.ln_tope,
                                                     tipocambio      => ln_TipCamb,
                                                     ln_plazo        => ln_MaxPlazAdi,
                                                     ln_CapAdicional => ln_CuoCapAdi);
        
          ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
        
          if ln_CuoCapAdi > 0 then
            begin
              select a.AQPA356capcaja
                into ln_mntacumld
                from AQPA356 a
               where a.AQPA356inst = ln_Instancia
                 and a.aqpa356corr = ln_MaxPlazAdi
                 and a.AQPA356est = 'H';
            exception
              when others then
                ln_mntacumld := 0.00;
            end;
          
            ln_mntacumld := nvl(ln_mntacumld, 0);
          
            begin
              ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
              ln_newmnt := nvl(ln_newmnt, 0);
            end;
          
            begin
              update AQPA356 a
                 set a.AQPA356capcaja = ln_newmnt
               where a.AQPA356inst = ln_Instancia
                 and a.AQPA356est = 'H'
                 AND a.AQPA356corr = ln_MaxPlazAdi;
            end;
          
          end if;
        end if;
      end if;
    end loop;
  
    for lc in linea_vencida(lc_estado, ln_Tarea) loop
    
      begin
        select min(a.aqpa411feca)
          into ld_ffin
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        select max(a.aqpa411feca)
          into ld_MaxFchCalnd
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lc.ln_pgcod,
                                             lc.ln_mod,
                                             lc.ln_suc,
                                             lc.ln_mda,
                                             lc.ln_pap,
                                             lc.ln_cta,
                                             lc.ln_ope,
                                             lc.ln_sbop,
                                             lc.ln_tope,
                                             ld_fini,
                                             ld_ffin,
                                             ln_TipCamb,
                                             ln_NroCuot,
                                             ln_MntCuota);
      
        begin
          PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                      ln_modulo      => lc.LN_MOD,
                                                      ln_mntcuota    => ln_MntCuota,
                                                      ld_fchPanel    => ld_ffin,
                                                      ln_NroCuOtorg  => NroCreOtorg,
                                                      ln_NroCuotCred => ln_NroCuot,
                                                      lc_Indicador   => lc.lc_indcred);
        
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      end loop;
    end loop;
  
    for cp in credito_parcial(lc_estado, ln_Tarea) loop
      pq_cr_ratio_evalflujo.sp_cr_VerfDesmbPendiente(cp.ln_pgcod,
                                                     cp.ln_mod,
                                                     cp.ln_suc,
                                                     cp.ln_mda,
                                                     cp.ln_pap,
                                                     cp.ln_cta,
                                                     cp.ln_ope,
                                                     cp.ln_sbop,
                                                     cp.ln_tope,
                                                     lc_VerfDesembPendt,
                                                     ln_NroDesemblsPact,
                                                     ln_DesembHechos);
    
      if lc_VerfDesembPendt = 'P' then
        -- Con Desembolso Pendiente    
      
        Pq_Cr_Ratio_Evalflujo.sp_Cr_CalcParcialPend(cp.ln_pgcod,
                                                    cp.ln_mod,
                                                    cp.ln_suc,
                                                    cp.ln_mda,
                                                    cp.ln_pap,
                                                    cp.ln_cta,
                                                    cp.ln_ope,
                                                    cp.ln_sbop,
                                                    cp.ln_tope,
                                                    ln_DesembHechos,
                                                    ln_TipCamb,
                                                    ln_CuotPendt);
      
        begin
          select min(a.aqpa411feca)
            into ld_ffin
            from aqpa411 a
           where a.aqpa411inst = ln_Instancia;
        EXCEPTION
          when others then
            null;
        end;
        begin
          select max(a.aqpa411feca)
            into ld_MaxFchCalnd
            from aqpa411 a
           where a.aqpa411inst = ln_Instancia;
        EXCEPTION
          when others then
            null;
        end;
      
        begin
          ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
        end;
      
        while ld_ffin <= ld_MaxFchCalnd loop
        
          begin
            -- Verifico si el credito vigente tiene cuotas en el periodo 
            select count(*)
              into ln_TieneCalndario
              from fsd601 f
             where f.pgcod = cp.ln_pgcod
               and f.ppmod = cp.ln_mod
               and f.ppsuc = cp.ln_suc
               and f.ppmda = cp.ln_mda
               and f.pppap = cp.ln_pap
               and f.ppcta = cp.ln_cta
               and f.ppoper = cp.ln_ope
               and f.ppsbop = cp.ln_sbop
               and f.pptope = cp.ln_tope
               and f.d601co = 'S'
               and f.ppfpag between ld_fini and ld_ffin;
          exception
            when others then
              ln_TieneCalndario := 0;
          end;
        
          if ln_TieneCalndario > 0 then
            begin
              PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                          ln_modulo      => cp.LN_MOD,
                                                          ln_mntcuota    => ln_CuotPendt,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => cp.lc_indcred);
            
            end;
          end if;
        
          ld_fini := add_months(ld_fini, +1);
          ld_ffin := add_months(ld_ffin, +1);
        end loop;
      
      else
        if lc_VerfDesembPendt = 'T' then
          -- Con Desembolso Total  
          begin
            select min(a.aqpa411feca)
              into ld_ffin
              from aqpa411 a
             where a.aqpa411inst = ln_Instancia;
          EXCEPTION
            when others then
              null;
          end;
        
          begin
            select max(a.aqpa411feca)
              into ld_MaxFchCalnd
              from aqpa411 a
             where a.aqpa411inst = ln_Instancia;
          EXCEPTION
            when others then
              null;
          end;
        
          begin
            ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
          end;
        
          while ld_ffin <= ld_MaxFchCalnd loop
          
            ln_MntCuoMesAux := 0;
            ln_MntCuoMes    := 0;
            ln_ratiomens    := 0;
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota( --ln_InstCred,
                                                 cp.ln_pgcod,
                                                 cp.ln_mod,
                                                 cp.ln_suc,
                                                 cp.ln_mda,
                                                 cp.ln_pap,
                                                 cp.ln_cta,
                                                 cp.ln_ope,
                                                 cp.ln_sbop,
                                                 cp.ln_tope,
                                                 ld_fini,
                                                 ld_ffin,
                                                 ln_TipCamb,
                                                 ln_NroCuot,
                                                 ln_MntCuota);
          
            begin
              PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                          ln_modulo      => cp.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => cp.lc_indcred);
            
            end;
          
            ld_fini := add_months(ld_fini, +1);
            ld_ffin := add_months(ld_ffin, +1);
          
          end loop;
        
        end if;
      end if;
    end loop;
  
    for pv in Lista_ParcVuelo(lc_estado, ln_Tarea) loop
    
      begin
        select min(a.aqpa411feca)
          into ld_ffin
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        select max(a.aqpa411feca)
          into ld_MaxFchCalnd
          from aqpa411 a
         where a.aqpa411inst = ln_Instancia;
      EXCEPTION
        when others then
          null;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(pv.ln_pgcod,
                                             pv.ln_mod,
                                             pv.ln_suc,
                                             pv.ln_mda,
                                             pv.ln_pap,
                                             pv.ln_cta,
                                             pv.ln_ope,
                                             pv.ln_sbop,
                                             pv.ln_tope,
                                             ld_fini,
                                             ld_ffin,
                                             ln_TipCamb,
                                             ln_NroCuot,
                                             ln_MntCuota);
      
        begin
          PQ_CR_RATIO_EVALFLUJO.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                      ln_modulo      => pv.LN_MOD,
                                                      ln_mntcuota    => ln_MntCuota,
                                                      ld_fchPanel    => ld_ffin,
                                                      ln_NroCuOtorg  => NroCreOtorg,
                                                      ln_NroCuotCred => ln_NroCuot,
                                                      lc_Indicador   => pv.lc_indcred);
        
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      
      end loop;
    
    end loop;
  
    PQ_CR_RATIO_EVALFLUJO.sp_cr_UpdateAQPA410(ln_Instancia);
  
  end sp_cr_CalcRatioPanel;
  ------------------------------------------------------------------------------
  procedure sp_cr_DatosRatio(ln_instancia  in number,
                             lc_prgm       in varchar2,
                             ln_capcaja    out number,
                             ln_capifis    out number,
                             ln_capcontgnt out number,
                             ln_capptncl   out number,
                             ln_ResulNeto  out number,
                             ln_Ratio      out number) is
  
    ld_fech      date;
    lc_user      varchar2(10);
    ln_pais      number;
    ln_tdoc      number;
    ln_ndoc      varchar2(12);
    ln_tcamb     number;
    ln_inst      number;
    lc_mesanio   varchar2(8);
    ln_tarea     number;
    lc_flgprg    varchar2(2) := 'N';
    lc_EjecRatio varchar2(2) := 'N';
    lc_Estado    varchar2(2) := 'H';
  
  begin
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
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
         and a.tp1corr1 = 850
         and a.TP1CORR2 = 101
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    begin
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 850
         and a.TP1CORR2 = 101
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_flgprg := 'N';
    end;
  
    if lc_prgm = 'RJAQY843' then
    
      lc_flgprg := 'R';
      lc_Estado := 'R';
    
      begin
        delete aqpa354 J
         WHERE J.aqpa354INST = ln_Instancia
           and j.aqpa354est = 'R';
      end;
    
    end if;
  
    if lc_flgprg = 'S' and lc_EjecRatio = 'S' then
    
      begin
        UPDATE aqpa354 j
           set aqpa354est = 'I'
         where j.aqpa354inst = ln_Instancia
           and j.aqpa354est = 'H'
           and j.aqpa354tarea = ln_Tarea;
        commit;
      end;
    
      lc_Estado := 'H';
    
    end if;
  
    begin
      select a.aqpa353fec,
             a.aqpa353pais,
             a.aqpa353tdoc,
             a.aqpa353ndoc,
             a.aqpa353tcamb,
             a.aqpa353inst,
             a.aqpa353user,
             a.aqpa353mesanio,
             a.aqpa353capcaja,
             a.aqpa353ifis,
             a.aqpa353resneto,
             a.aqpa353ccontg,
             a.aqpa353cpoten,
             a.aqpa353ratio
        into ld_fech,
             ln_pais,
             ln_tdoc,
             ln_ndoc,
             ln_tcamb,
             ln_inst,
             lc_user,
             lc_mesanio,
             ln_capcaja,
             ln_capifis,
             ln_ResulNeto,
             ln_capcontgnt,
             ln_capptncl,
             ln_Ratio
        from aqpa353 a
       where a.aqpa353inst = ln_instancia
         and a.aqpa353est = lc_Estado
         and a.aqpa353tarea = ln_tarea
         and a.aqpa353ratio =
             (select max(b.aqpa353ratio)
                from aqpa353 b
               where b.aqpa353inst = ln_instancia
                 and b.aqpa353est = lc_Estado
                 and b.aqpa353tarea = ln_tarea);
    exception
      when too_many_rows then
        begin
          select a.aqpa353fec,
                 a.aqpa353pais,
                 a.aqpa353tdoc,
                 a.aqpa353ndoc,
                 a.aqpa353tcamb,
                 a.aqpa353inst,
                 a.aqpa353user,
                 a.aqpa353mesanio,
                 a.aqpa353capcaja,
                 a.aqpa353ifis,
                 a.aqpa353resneto,
                 a.aqpa353ccontg,
                 a.aqpa353cpoten,
                 a.aqpa353ratio
            into ld_fech,
                 ln_pais,
                 ln_tdoc,
                 ln_ndoc,
                 ln_tcamb,
                 ln_inst,
                 lc_user,
                 lc_mesanio,
                 ln_capcaja,
                 ln_capifis,
                 ln_ResulNeto,
                 ln_capcontgnt,
                 ln_capptncl,
                 ln_Ratio
            from aqpa353 a
           where a.aqpa353inst = ln_instancia
             and a.aqpa353est = lc_Estado
             and a.aqpa353tarea = ln_tarea
             and a.aqpa353mesanio =
                 (select min(b.aqpa353mesanio)
                    from aqpa353 b
                   where b.aqpa353inst = ln_instancia
                     and b.aqpa353est = lc_Estado
                     and b.aqpa353tarea = ln_tarea
                     and b.aqpa353ratio =
                         (select max(b.aqpa353ratio)
                            from aqpa353 c
                           where c.aqpa353inst = ln_instancia
                             and c.aqpa353est = lc_Estado
                             and c.aqpa353tarea = ln_tarea));
        exception
          when others then
            null;
        end;
      when no_data_found then
        null;
      
    end;
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
      begin
        PQ_CR_RATIO_EVALFLUJO.sp_cr_LogRatio(ln_Pepais      => ln_pais,
                                             ln_Petdoc      => ln_tdoc,
                                             ln_Pendoc      => ln_ndoc,
                                             tipocambio     => ln_tcamb,
                                             Instancia      => ln_inst,
                                             pd_fecpro      => ld_fech,
                                             lc_Usuario     => lc_user,
                                             lc_mesanio     => lc_mesanio,
                                             ln_captotcaja  => ln_capcaja,
                                             ln_ifis        => ln_capifis,
                                             ln_ResultNeto  => ln_ResulNeto,
                                             ln_MntCuoCntg  => ln_capcontgnt,
                                             ln_MntPotncial => ln_capptncl,
                                             ln_ratio       => ln_ratio,
                                             lc_flgprg      => lc_flgprg,
                                             ln_Tarea       => ln_tarea);
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_ActMntCuota(ln_Instancia => ln_inst,
                                                lc_mesanio   => lc_mesanio,
                                                lc_flgprg    => lc_flgprg);
      end;
    end if;
  
  end sp_cr_DatosRatio;

  -------------------------------------------------------------------------------
  procedure sp_cr_ActMntCuota(ln_Instancia in number,
                              lc_mesanio   in varchar2,
                              lc_flgprg    in varchar2) is
  
    cursor Lista_OtrosCred(lc_estado varchar2, ln_tarea number) is
    -- Cursor Creditos que no son Linea (Solo Linea Utilizada) ni Desembolso Parcial
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred,
             a.aqpa352tcamb   ln_tipcamb
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352mod <> 117 --Excluye Lineas
         and a.aqpa352ori <> 7 --Excluye desembolsos parciales
         and a.aqpa352indcred in ('CredVigent', 'CredVencid', 'CredVuelo')
         and a.aqpa352tarea = ln_tarea;
  
    cursor linea_vuelo(lc_estado varchar2, ln_tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred,
             a.aqpa352tcamb   ln_tipcamb
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'CredVuelo'
         and a.aqpa352mod = 117
         and a.aqpa352tarea = ln_tarea;
  
    cursor linea_vigente(lc_estado varchar2, ln_tarea number) is
    -- Linea Vigente sin uso
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred,
             a.aqpa352tcamb   ln_tipcamb
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'CredVigent'
         and a.aqpa352mod = 117
         and a.aqpa352tarea = ln_tarea;
  
    cursor linea_vencida(lc_estado varchar2, ln_tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred,
             a.aqpa352tcamb   ln_tipcamb
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352indcred = 'LineaVencd'
         and a.aqpa352tarea = ln_tarea;
  
    cursor credito_parcial(lc_estado varchar2, ln_tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred,
             a.aqpa352tcamb   ln_tipcamb
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352ori = 7
         and a.aqpa352indcred in ('CredVigent', 'CredVencid')
         and a.aqpa352tarea = ln_tarea;
  
    cursor Lista_ParcVuelo(lc_estado varchar2, ln_tarea number) is
      select a.aqpa352pgcod   ln_pgcod,
             a.aqpa352mod     ln_mod,
             a.aqpa352suc     ln_suc,
             a.aqpa352mda     ln_mda,
             a.aqpa352pap     ln_pap,
             a.aqpa352cta     ln_cta,
             a.aqpa352ope     ln_ope,
             a.aqpa352sbop    ln_sbop,
             a.aqpa352tope    ln_tope,
             a.aqpa352indcred lc_IndCred,
             a.aqpa352tcamb   ln_tipcamb
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = lc_estado
         and a.aqpa352ori = 7 -- Desembolsos parciales
         and a.aqpa352indcred = 'CredVuelo'
         and a.aqpa352tarea = ln_tarea;
  
    ld_FchIni       date;
    lc_estado       varchar2(2);
    ld_FchFin       date;
    ln_MntCuoMes    number(17, 2) := 0.00;
    ln_emp          number := 0;
    ln_sucur        number := 0;
    ln_mod          number := 0;
    ln_mda          number := 0;
    ln_pap          number := 0;
    ln_cta          number := 0;
    ln_oper         number := 0;
    ln_sbop         number := 0;
    ln_tipoper      number := 0;
    NroCreOtorg     number := 0;
    ln_CuoDisp      number(17, 2) := 0.00;
    ln_MntDispnb    number(17, 2) := 0.00;
    ln_MntCuoMesAux number(17, 2) := 0.00;
    ld_FchCalend    date;
    ln_mntacumld    number(17, 2) := 0.00;
    ld_MaxFechCalnd date;
    ld_UltDia       date;
    --ln_CuoDisp      number(17, 2) := 0.00;
    ln_NroCuot         number;
    lc_VerfDesembPendt varchar2(2) := 'T';
    ln_NroDesemblsPact number := 0;
    ln_DesembHechos    number := 0;
    lc_fgAdic          varchar2(2) := 'N';
    ln_newmnt          number(17, 2) := 0.00;
    ln_MaxPlazAdi      number := 0;
    ln_CuoCapAdi       number(17, 2) := 0.00;
    ln_tarea           number;
  
  begin
  
    if lc_flgprg = 'S' then
      lc_estado := 'H';
    else
      if lc_flgprg = 'R' then
        lc_estado := 'R';
      end if;
    end if;
  
    begin
      ld_FchIni := to_date(lc_mesanio || '01', 'yyyymmdd');
    
      ld_FchFin := last_day(ld_FchIni);
    end;
  
    begin
      begin
        select x.xwfempresa,
               x.xwfsucursal,
               x.xwfmodulo,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_emp,
               ln_sucur,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_oper,
               ln_sbop,
               ln_tipoper
          from xwf700 x
         where x.xwfprcins = ln_Instancia
           and x.xwfcar3 = '1';
      end;
    
      begin
        if ln_mod <> 117 then
        
          begin
            select months_between(max(f.ppfvto), min(f.ppfval))
              into NroCreOtorg
              from fsd601 f
             where f.pgcod = ln_emp
               and f.ppmod = ln_mod
               and f.ppsuc = ln_sucur
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_oper
               and f.ppsbop = ln_sbop
               and f.pptope = ln_tipoper;
          exception
            when others then
              NroCreOtorg := 0;
          end;
        
        else
          if ln_mod = 117 then
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod        => ln_emp,
                                                       ln_modulo       => ln_mod,
                                                       ln_sucursal     => ln_sucur,
                                                       ln_moneda       => ln_mda,
                                                       ln_papel        => ln_pap,
                                                       ln_cuenta       => ln_cta,
                                                       ln_operacion    => ln_oper,
                                                       ln_suboperacion => ln_sbop,
                                                       ln_tipoperacion => ln_tipoper,
                                                       ln_NroCuot      => NroCreOtorg);
          end if;
        end if;
      end;
    
    end;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    for oc in Lista_OtrosCred(lc_estado, ln_Tarea) loop
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(oc.ln_pgcod,
                                           oc.ln_mod,
                                           oc.ln_suc,
                                           oc.ln_mda,
                                           oc.ln_pap,
                                           oc.ln_cta,
                                           oc.ln_ope,
                                           oc.ln_sbop,
                                           oc.ln_tope,
                                           ld_FchIni,
                                           ld_FchFin,
                                           oc.ln_tipcamb,
                                           ln_NroCuot,
                                           ln_MntCuoMes);
    
      -- if oc.ln_mod <> 116 then
      begin
        update aqpa352 a
           set a.aqpa352naux1 = ln_MntCuoMes
         where a.aqpa352pgcod = oc.ln_pgcod
           and a.aqpa352mod = oc.ln_mod
           and a.aqpa352suc = oc.ln_suc
           and a.aqpa352mda = oc.ln_mda
           and a.aqpa352pap = oc.ln_pap
           and a.aqpa352cta = oc.ln_cta
           and a.aqpa352ope = oc.ln_ope
           and a.aqpa352sbop = oc.ln_sbop
           and a.aqpa352tope = oc.ln_tope
           and a.aqpa352inst = ln_Instancia
           and a.aqpa352est = lc_estado
           and a.aqpa352tarea = ln_tarea;
        commit;
      end;
    
      --  else
      if oc.ln_mod = 116 then
      
        PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(oc.ln_mod,
                                              oc.ln_tope,
                                              lc_fgAdic);
      
        if lc_fgAdic = 'N' then
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcDisponible(oc.ln_pgcod,
                                                     oc.ln_mod,
                                                     oc.ln_suc,
                                                     oc.ln_mda,
                                                     oc.ln_pap,
                                                     oc.ln_cta,
                                                     oc.ln_ope,
                                                     oc.ln_sbop,
                                                     oc.ln_tope,
                                                     ln_MntDispnb);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuotaDispnbl(ln_pgcod        => oc.ln_pgcod,
                                                      ln_suc          => oc.ln_suc,
                                                      ln_mod          => oc.ln_mod,
                                                      ln_mda          => oc.ln_mda,
                                                      ln_pap          => oc.ln_pap,
                                                      ln_cta          => oc.ln_cta,
                                                      ln_oper         => oc.ln_ope,
                                                      ln_sbop         => oc.ln_sbop,
                                                      ln_tope         => oc.ln_tope,
                                                      ln_MntDispnbl   => ln_MntDispnb,
                                                      tipocambio      => oc.ln_TipCamb,
                                                      ln_CuotaDispnbl => ln_CuoDisp);
        
          ln_CuoDisp := nvl(ln_CuoDisp, 0);
          ln_CuoDisp := ln_CuoDisp * NroCreOtorg;
        
          if ln_mod = 117 then
          
            begin
              select a.aqpa353fecal
                into ld_FchCalend
                from AQPA353 a
               where a.AQPA353inst = ln_Instancia
                 and a.AQPA353corr = NroCreOtorg + 1
                 and a.AQPA353est = lc_estado
                 and a.aqpa353tarea = ln_tarea;
            exception
              when others then
                ln_mntacumld := 0.00;
            end;
          
            ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
            begin
              ln_MntCuoMes := ln_MntCuoMes + ln_CuoDisp;
              ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
            end;
          
            if ld_FchCalend = ld_FchFin then
            
              begin
                update aqpa352 a
                   set a.aqpa352naux1 = ln_MntCuoMes
                 where a.aqpa352pgcod = oc.ln_pgcod
                   and a.aqpa352mod = oc.ln_mod
                   and a.aqpa352suc = oc.ln_suc
                   and a.aqpa352mda = oc.ln_mda
                   and a.aqpa352pap = oc.ln_pap
                   and a.aqpa352cta = oc.ln_cta
                   and a.aqpa352ope = oc.ln_ope
                   and a.aqpa352sbop = oc.ln_sbop
                   and a.aqpa352tope = oc.ln_tope
                   and a.aqpa352inst = ln_Instancia
                   and a.aqpa352est = lc_estado
                   and a.aqpa352tarea = ln_Tarea;
                commit;
              end;
            end if;
          
          else
            if ln_mod <> 117 then
            
              begin
                select max(f.ppfpag)
                  into ld_MaxFechCalnd
                  from fsd601 f
                 where f.pgcod = ln_emp
                   and f.ppmod = ln_mod
                   and f.ppsuc = ln_sucur
                   and f.ppmda = ln_mda
                   and f.pppap = ln_pap
                   and f.ppcta = ln_cta
                   and f.ppoper = ln_oper
                   and f.ppsbop = ln_sbop
                   and f.pptope = ln_tipoper
                   and f.d601co in ('X', 'E');
              exception
                when others then
                  null;
              end;
            
              begin
                begin
                  ld_UltDia := last_Day(ld_MaxFechCalnd);
                end;
              end;
            
              if ld_UltDia = ld_FchFin then
              
                ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
                begin
                  ln_MntCuoMes := ln_MntCuoMes + ln_CuoDisp;
                  ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
                end;
              
                begin
                  update aqpa352 a
                     set a.aqpa352naux1 = ln_MntCuoMes
                   where a.aqpa352pgcod = oc.ln_pgcod
                     and a.aqpa352mod = oc.ln_mod
                     and a.aqpa352suc = oc.ln_suc
                     and a.aqpa352mda = oc.ln_mda
                     and a.aqpa352pap = oc.ln_pap
                     and a.aqpa352cta = oc.ln_cta
                     and a.aqpa352ope = oc.ln_ope
                     and a.aqpa352sbop = oc.ln_sbop
                     and a.aqpa352tope = oc.ln_tope
                     and a.aqpa352inst = ln_Instancia
                     and a.aqpa352est = lc_estado
                     and a.aqpa352tarea = ln_Tarea;
                  commit;
                end;
              
              end if;
            
            end if;
          end if;
        else
          if lc_fgAdic = 'S' then
            ln_newmnt := 0;
          
            pq_cr_ratio_evalflujo.sp_CapLineaAdicional(ln_mod10        => oc.ln_mod,
                                                       ln_suc10        => oc.ln_suc,
                                                       ln_mda10        => oc.ln_mda,
                                                       ln_pap10        => oc.ln_pap,
                                                       ln_cta10        => oc.ln_cta,
                                                       ln_oper10       => oc.ln_ope,
                                                       ln_sbop10       => oc.ln_sbop,
                                                       ln_tope10       => oc.ln_tope,
                                                       tipocambio      => oc.ln_tipcamb,
                                                       ln_plazo        => ln_MaxPlazAdi,
                                                       ln_CapAdicional => ln_CuoCapAdi);
          
            ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
          
            begin
              select a.aqpa353fecal
                into ld_FchCalend
                from AQPA353 a
               where a.AQPA353inst = ln_Instancia
                 and a.aqpa353corr = ln_MaxPlazAdi
                 and a.AQPA353est = lc_estado
                 and a.aqpa353tarea = ln_Tarea;
            exception
              when others then
                null;
            end;
          
            if ld_FchCalend = ld_FchFin then
              begin
                update aqpa352 a
                   set a.aqpa352naux1 = ln_CuoCapAdi
                 where a.aqpa352pgcod = oc.ln_pgcod
                   and a.aqpa352mod = oc.ln_mod
                   and a.aqpa352suc = oc.ln_suc
                   and a.aqpa352mda = oc.ln_mda
                   and a.aqpa352pap = oc.ln_pap
                   and a.aqpa352cta = oc.ln_cta
                   and a.aqpa352ope = oc.ln_ope
                   and a.aqpa352sbop = oc.ln_sbop
                   and a.aqpa352tope = oc.ln_tope
                   and a.aqpa352inst = ln_Instancia
                   and a.aqpa352est = lc_estado
                   and a.aqpa352tarea = ln_Tarea;
                commit;
              end;
            end if;
          
          end if;
        end if;
      end if;
    
    -- end if;
    end loop;
  
    for lv in linea_vuelo(lc_estado, ln_Tarea) loop
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lv.ln_pgcod,
                                           lv.ln_mod,
                                           lv.ln_suc,
                                           lv.ln_mda,
                                           lv.ln_pap,
                                           lv.ln_cta,
                                           lv.ln_ope,
                                           lv.ln_sbop,
                                           lv.ln_tope,
                                           ld_FchIni,
                                           ld_FchFin,
                                           lv.ln_TipCamb,
                                           ln_NroCuot,
                                           ln_MntCuoMes);
    
      pq_cr_ratio_evalflujo.sp_CapLineaAdiVuel(ln_mod10        => lv.ln_mod,
                                               ln_suc10        => lv.ln_suc,
                                               ln_mda10        => lv.ln_mda,
                                               ln_pap10        => lv.ln_pap,
                                               ln_cta10        => lv.ln_cta,
                                               ln_oper10       => lv.ln_ope,
                                               ln_sbop10       => lv.ln_sbop,
                                               ln_tope10       => lv.ln_tope,
                                               tipocambio      => LV.ln_TipCamb,
                                               ln_plazo        => ln_MaxPlazAdi,
                                               ln_CapAdicional => ln_CuoCapAdi);
    
      begin
        update aqpa352 a
           set a.aqpa352naux1 = ln_MntCuoMes
         where a.aqpa352pgcod = lv.ln_pgcod
           and a.aqpa352mod = lv.ln_mod
           and a.aqpa352suc = lv.ln_suc
           and a.aqpa352mda = lv.ln_mda
           and a.aqpa352pap = lv.ln_pap
           and a.aqpa352cta = lv.ln_cta
           and a.aqpa352ope = lv.ln_ope
           and a.aqpa352sbop = lv.ln_sbop
           and a.aqpa352tope = lv.ln_tope
           and a.aqpa352inst = ln_Instancia
           and a.aqpa352est = lc_estado
           and a.aqpa352tarea = ln_Tarea;
        commit;
      end;
    
      begin
        select a.aqpa353fecal
          into ld_FchCalend
          from AQPA353 a
         where a.AQPA353inst = ln_Instancia
           and a.aqpa353corr = ln_MaxPlazAdi + 1
           and a.AQPA353est = lc_estado
           and a.aqpa353tarea = ln_Tarea;
      exception
        when others then
          null;
      end;
    
      if ld_FchCalend = ld_FchFin then
        begin
          update aqpa352 a
             set a.aqpa352naux1 = ln_CuoCapAdi
           where a.aqpa352pgcod = lv.ln_pgcod
             and a.aqpa352mod = lv.ln_mod
             and a.aqpa352suc = lv.ln_suc
             and a.aqpa352mda = lv.ln_mda
             and a.aqpa352pap = lv.ln_pap
             and a.aqpa352cta = lv.ln_cta
             and a.aqpa352ope = lv.ln_ope
             and a.aqpa352sbop = lv.ln_sbop
             and a.aqpa352tope = lv.ln_tope
             and a.aqpa352inst = ln_Instancia
             and a.aqpa352est = lc_estado
             and a.aqpa352tarea = ln_Tarea;
          commit;
        end;
      end if;
    
    end loop;
  
    for lg in linea_vigente(lc_estado, ln_Tarea) loop
    
      begin
        pq_cr_resolutor_cappago.sp_capacidadlinea(lg.ln_mod,
                                                  lg.ln_suc,
                                                  lg.ln_mda,
                                                  lg.ln_pap,
                                                  lg.ln_cta,
                                                  lg.ln_ope,
                                                  lg.ln_sbop,
                                                  lg.ln_tope,
                                                  lg.ln_tipcamb,
                                                  ln_MntCuoMesAux);
        ln_MntCuoMesAux := nvl(ln_MntCuoMesAux, 0);
        ln_MntCuoMes    := ln_MntCuoMesAux * NroCreOtorg;
        ln_MntCuoMes    := nvl(ln_MntCuoMes, 0);
      
      end;
    
      pq_cr_ratio_evalflujo.sp_CapLineaAdicional(ln_mod10        => lg.ln_mod,
                                                 ln_suc10        => lg.ln_suc,
                                                 ln_mda10        => lg.ln_mda,
                                                 ln_pap10        => lg.ln_pap,
                                                 ln_cta10        => lg.ln_cta,
                                                 ln_oper10       => lg.ln_ope,
                                                 ln_sbop10       => lg.ln_sbop,
                                                 ln_tope10       => lg.ln_tope,
                                                 tipocambio      => lg.ln_tipcamb,
                                                 ln_plazo        => ln_MaxPlazAdi,
                                                 ln_CapAdicional => ln_CuoCapAdi);
    
      begin
        select a.aqpa353fecal
          into ld_FchCalend
          from AQPA353 a
         where a.AQPA353inst = ln_Instancia
           and a.aqpa353corr = ln_MaxPlazAdi + 1
           and a.AQPA353est = lc_estado
           and a.aqpa353tarea = ln_Tarea;
      exception
        when others then
          null;
      end;
    
      if ld_FchCalend = ld_FchFin then
        begin
          update aqpa352 a
             set a.aqpa352naux1 = ln_CuoCapAdi
           where a.aqpa352pgcod = lg.ln_pgcod
             and a.aqpa352mod = lg.ln_mod
             and a.aqpa352suc = lg.ln_suc
             and a.aqpa352mda = lg.ln_mda
             and a.aqpa352pap = lg.ln_pap
             and a.aqpa352cta = lg.ln_cta
             and a.aqpa352ope = lg.ln_ope
             and a.aqpa352sbop = lg.ln_sbop
             and a.aqpa352tope = lg.ln_tope
             and a.aqpa352inst = ln_Instancia
             and a.aqpa352est = lc_estado
             and a.aqpa352tarea = ln_Tarea;
          commit;
        end;
      end if;
    
    end loop;
  
    for lc in linea_vencida(lc_estado, ln_tarea) loop
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lc.ln_pgcod,
                                           lc.ln_mod,
                                           lc.ln_suc,
                                           lc.ln_mda,
                                           lc.ln_pap,
                                           lc.ln_cta,
                                           lc.ln_ope,
                                           lc.ln_sbop,
                                           lc.ln_tope,
                                           ld_FchIni,
                                           ld_FchFin,
                                           lc.ln_tipcamb,
                                           ln_NroCuot,
                                           ln_MntCuoMes);
    
      begin
        update aqpa352 a
           set a.aqpa352naux1 = ln_MntCuoMes
         where a.aqpa352pgcod = lc.ln_pgcod
           and a.aqpa352mod = lc.ln_mod
           and a.aqpa352suc = lc.ln_suc
           and a.aqpa352mda = lc.ln_mda
           and a.aqpa352pap = lc.ln_pap
           and a.aqpa352cta = lc.ln_cta
           and a.aqpa352ope = lc.ln_ope
           and a.aqpa352sbop = lc.ln_sbop
           and a.aqpa352tope = lc.ln_tope
           and a.aqpa352inst = ln_Instancia
           and a.aqpa352est = lc_estado
           and a.aqpa352tarea = ln_Tarea;
        commit;
      end;
    
    end loop;
  
    for cp in credito_parcial(lc_estado, ln_Tarea) loop
      pq_cr_ratio_evalflujo.sp_cr_VerfDesmbPendiente(cp.ln_pgcod,
                                                     cp.ln_mod,
                                                     cp.ln_suc,
                                                     cp.ln_mda,
                                                     cp.ln_pap,
                                                     cp.ln_cta,
                                                     cp.ln_ope,
                                                     cp.ln_sbop,
                                                     cp.ln_tope,
                                                     lc_VerfDesembPendt,
                                                     ln_NroDesemblsPact,
                                                     ln_DesembHechos);
    
      if lc_VerfDesembPendt = 'P' then
        -- Con Desembolso Pendiente    
      
        Pq_Cr_Ratio_Evalflujo.sp_Cr_CalcParcialPend(cp.ln_pgcod,
                                                    cp.ln_mod,
                                                    cp.ln_suc,
                                                    cp.ln_mda,
                                                    cp.ln_pap,
                                                    cp.ln_cta,
                                                    cp.ln_ope,
                                                    cp.ln_sbop,
                                                    cp.ln_tope,
                                                    ln_DesembHechos,
                                                    cp.ln_TipCamb,
                                                    ln_MntCuoMes);
      
        begin
          update aqpa352 a
             set a.aqpa352naux1 = ln_MntCuoMes
           where a.aqpa352pgcod = cp.ln_pgcod
             and a.aqpa352mod = cp.ln_mod
             and a.aqpa352suc = cp.ln_suc
             and a.aqpa352mda = cp.ln_mda
             and a.aqpa352pap = cp.ln_pap
             and a.aqpa352cta = cp.ln_cta
             and a.aqpa352ope = cp.ln_ope
             and a.aqpa352sbop = cp.ln_sbop
             and a.aqpa352tope = cp.ln_tope
             and a.aqpa352inst = ln_Instancia
             and a.aqpa352est = lc_estado
             and a.aqpa352tarea = ln_Tarea;
          commit;
        end;
      
      else
        if lc_VerfDesembPendt = 'T' then
          -- Con Desembolso Total  
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(cp.ln_pgcod,
                                               cp.ln_mod,
                                               cp.ln_suc,
                                               cp.ln_mda,
                                               cp.ln_pap,
                                               cp.ln_cta,
                                               cp.ln_ope,
                                               cp.ln_sbop,
                                               cp.ln_tope,
                                               ld_FchIni,
                                               ld_FchFin,
                                               cp.ln_TipCamb,
                                               ln_NroCuot,
                                               ln_MntCuoMes);
        
          begin
            update aqpa352 a
               set a.aqpa352naux1 = ln_MntCuoMes
             where a.aqpa352pgcod = cp.ln_pgcod
               and a.aqpa352mod = cp.ln_mod
               and a.aqpa352suc = cp.ln_suc
               and a.aqpa352mda = cp.ln_mda
               and a.aqpa352pap = cp.ln_pap
               and a.aqpa352cta = cp.ln_cta
               and a.aqpa352ope = cp.ln_ope
               and a.aqpa352sbop = cp.ln_sbop
               and a.aqpa352tope = cp.ln_tope
               and a.aqpa352inst = ln_Instancia
               and a.aqpa352est = lc_estado
               and a.aqpa352tarea = ln_Tarea;
            commit;
          end;
        
        end if;
      end if;
    end loop;
  
    for pv in Lista_ParcVuelo(lc_estado, ln_Tarea) loop
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(pv.ln_pgcod,
                                           pv.ln_mod,
                                           pv.ln_suc,
                                           pv.ln_mda,
                                           pv.ln_pap,
                                           pv.ln_cta,
                                           pv.ln_ope,
                                           pv.ln_sbop,
                                           pv.ln_tope,
                                           ld_FchIni,
                                           ld_FchFin,
                                           pv.ln_tipcamb,
                                           ln_NroCuot,
                                           ln_MntCuoMes);
    
      begin
        update aqpa352 a
           set a.aqpa352naux1 = ln_MntCuoMes
         where a.aqpa352pgcod = pv.ln_pgcod
           and a.aqpa352mod = pv.ln_mod
           and a.aqpa352suc = pv.ln_suc
           and a.aqpa352mda = pv.ln_mda
           and a.aqpa352pap = pv.ln_pap
           and a.aqpa352cta = pv.ln_cta
           and a.aqpa352ope = pv.ln_ope
           and a.aqpa352sbop = pv.ln_sbop
           and a.aqpa352tope = pv.ln_tope
           and a.aqpa352inst = ln_Instancia
           and a.aqpa352est = lc_estado
           and a.aqpa352tarea = ln_Tarea;
        commit;
      end;
    end loop;
  
  end sp_cr_ActMntCuota;
  ------------------------------------------------------------------------------
  procedure sp_cr_NroCuOPreseteo(ln_pgcod        in number,
                                 ln_modulo       in number,
                                 ln_sucursal     in number,
                                 ln_moneda       in number,
                                 ln_papel        in number,
                                 ln_cuenta       in number,
                                 ln_operacion    in number,
                                 ln_suboperacion in number,
                                 ln_tipoperacion in number,
                                 --ln_InsCredito   in number,
                                 ln_NroCuot out number) is
  
    lc_FlagGuia   varchar2(2) := 'N';
    LN_TIPOCRED   number;
    lc_FlagSegmnt varchar2(2) := 'N';
  
  begin
  
    if ln_modulo not in (116, 117) then
      begin
        select count(*)
          into ln_NroCuot
          from fsd601 f
         where f.pgcod = ln_pgcod
           and f.ppmod = ln_modulo
           and f.ppsuc = ln_sucursal
           and f.ppmda = ln_moneda
           and f.pppap = ln_papel
           and f.ppcta = ln_cuenta
           and f.ppoper = ln_operacion
           and f.ppsbop = ln_suboperacion
           and f.pptope = ln_tipoperacion
           and f.d601co in ('S', 'X', 'E');
      exception
        when others then
          ln_NroCuot := 0;
      end;
    
    else
      if ln_modulo in (116, 117) then
      
        begin
          select 'S'
            into lc_FlagGuia
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 13
             and a.tp1corr2 = 18
             and a.tp1nro2 = ln_modulo
             and a.tp1nro3 = ln_tipoperacion;
        exception
          when others then
            lc_FlagGuia := 'N';
          
        end;
      
        if lc_FlagGuia = 'S' then
          --Extraemos el plazo de la guia
        
          begin
            select to_number(ww.pp028defc)
              into LN_TIPOCRED
              from fpp028 ww
             where ww.pp017par = 115
               and ww.pp028mod = ln_modulo
               and ww.pp028top = ln_tipoperacion
               and ww.pp028emp = ln_pgcod
               and ww.pp028mda = ln_moneda
               and ww.pp028pap = ln_papel;
          EXCEPTION
            when others then
              null;
          end;
        
          begin
            select 'S'
              into lc_FlagSegmnt
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 13
               and a.tp1corr2 = 17
               and a.tp1nro3 = substr(LN_TIPOCRED, 7, 2);
          exception
            when others then
              lc_FlagSegmnt := 'N';
          end;
        
          if lc_FlagSegmnt = 'S' then
            -- mpostigoc 23/11/2017
          
            begin
              select f.pp028maxn
                into ln_NroCuot
                from fpp028 f
               where f.pp017par = 103
                 and f.pp028mod = 116
                 and f.pp028top = ln_tipoperacion
                 and f.pp028mda = ln_moneda; -- plazo
            exception
              when others then
                null;
            end;
          
          else
            if lc_FlagSegmnt = 'N' then
            
              begin
                select a.tp1nro2
                  into ln_NroCuot
                  from fst198 a
                 where a.tp1cod = 1
                   and a.tp1cod1 = 10899
                   and a.tp1corr1 = 13
                   and a.tp1corr2 = 17
                   and a.tp1corr3 = 4;
              EXCEPTION
                when others then
                  null;
              end;
            
            end if;
          end if;
        
        else
        
          if lc_FlagGuia = 'N' then
            -- Extraemos el plazo del Preseteo
            begin
              select f.pp028maxn
                into ln_NroCuot
                from fpp028 f
               where f.pp017par = 103
                 and f.pp028mod = 116
                 and f.pp028top = ln_tipoperacion
                 and f.pp028mda = ln_moneda; -- plazo
            exception
              when others then
                null;
            end;
          
          end if;
        
        end if;
      end if;
    end if;
  
  end sp_cr_NroCuOPreseteo;

  -----------------------------------------------------------------------------
  procedure sp_cr_TipoSolicitud(ln_InstCred in number,
                                ln_TipoOri  out number) is
  
  begin
  
    begin
      select s.sng001ori
        into ln_TipoOri
        from sng001 s
       where s.sng001inst = ln_InstCred;
    exception
      when others then
        ln_TipoOri := 0;
    end;
  
  end sp_cr_TipoSolicitud;

  ---------------------------------------------------------------------------
  procedure sp_cr_VerfUsoLinea(ln_pgcod        in number,
                               ln_modulo       in number,
                               ln_sucursal     in number,
                               ln_moneda       in number,
                               ln_papel        in number,
                               ln_cuenta       in number,
                               ln_operacion    in number,
                               ln_sboperacion  in number,
                               ln_tipoperacion in number,
                               Tiene_Uso       out varchar2,
                               ln_pgcod116     out number,
                               ln_modulo116    out number,
                               ln_sucursal116  out number,
                               ln_moneda116    out number,
                               ln_papel116     out number,
                               ln_cuenta116    out number,
                               ln_operacion116 out number,
                               ln_sbop116      out number,
                               ln_top116       out number) is
  
    cursor disposicion_lineas is
      select r1cod  ln_pgcod116,
             r1mod  ln_modulo116,
             r1suc  ln_sucursal116,
             r1mda  ln_moneda116,
             r1pap  ln_papel116,
             r1cta  ln_cuenta116,
             r1oper ln_operacion116,
             r1sbop ln_sbop116,
             r1tope ln_top116
        from fsr011 f
       where f.r2cod = ln_pgcod
         and f.r2mod = ln_modulo
         and f.r2suc = ln_sucursal
         and f.r2cta = ln_cuenta
         and f.r2oper = ln_operacion
         and f.r2sbop = ln_sboperacion
         and f.r2mda = ln_moneda
         and f.r2pap = ln_papel
         and f.r2tope = ln_tipoperacion
         and f.relcod = 46;
  
  begin
  
    Tiene_Uso := 'N';
  
    for d in disposicion_lineas loop
    
      ln_pgcod116     := d.ln_pgcod116;
      ln_modulo116    := d.ln_modulo116;
      ln_sucursal116  := d.ln_sucursal116;
      ln_moneda116    := d.ln_moneda116;
      ln_papel116     := d.ln_papel116;
      ln_cuenta116    := d.ln_cuenta116;
      ln_operacion116 := d.ln_operacion116;
      ln_sbop116      := d.ln_sbop116;
      ln_top116       := d.ln_top116;
    
      begin
        select 'S'
          into Tiene_Uso
          from fsd010 f
         where f.pgcod = ln_pgcod116
           and f.aomod = ln_modulo116
           and f.aosuc = ln_sucursal116
           and f.aomda = ln_moneda116
           and f.aopap = ln_papel116
           and f.aocta = ln_cuenta116
           and f.aooper = ln_operacion116
           and f.aosbop = ln_sbop116
           and f.aotope = ln_top116
           and f.aostat <> 99;
      exception
        when others then
          Tiene_Uso := 'N';
      end;
    
      if Tiene_Uso = 'S' THEN
        exit;
      end if;
    end loop;
  
  end sp_cr_VerfUsoLinea;

  ------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                pd_fecpro       in date,
                                lc_flgprg       in varchar2,
                                lc_Usuario      in varchar2,
                                lc_prgm         in varchar2,
                                ln_MntCuoCntgCF out number) is
  
    cursor lista_CredVigCF(ln_pais number,
                           ln_tdoc number,
                           lc_ndoc varchar2) is
    
      select distinct d10.pgcod    ln_pgcod10,
                      d10.aomod    ln_mod10,
                      d10.aosuc    ln_suc10,
                      d10.aomda    ln_mda10,
                      d10.aopap    ln_pap10,
                      d10.aocta    ln_cta10,
                      d10.aooper   ln_oper10,
                      d10.aosbop   ln_sbop10,
                      d10.aotope   ln_tope10,
                      d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from sng001 s, fsr008 f
                            where s.sng001inst = ln_Instancia
                              and s.sng001pais = f.pepais
                              and s.sng001tdoc = f.Petdoc
                              and s.sng001ndoc = f.pendoc
                              and cttfir = 'T')
         and d10.Aomod = 141
         and d10.Aostat <> 99;
  
    cursor lista_CredvueloCF(ln_pais number,
                             ln_tdoc number,
                             lc_ndoc varchar2) is
    
      select distinct x.xwfempresa   ln_pgcod10,
                      x.xwfmodulo    ln_mod10,
                      x.xwfsucursal  ln_suc10,
                      x.xwfmoneda    ln_mda10,
                      x.xwfpapel     ln_pap10,
                      x.xwfcuenta    ln_cta10,
                      x.xwfoperacion ln_oper10,
                      x.xwfsubope    ln_sbop10,
                      x.xwftipope    ln_tope10,
                      x.xwfprcins    ln_InstAvalada
        from xwf700 x, wfwrkitems w
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from sng001 s, fsr008 f
                              where s.sng001inst = ln_Instancia
                                and s.sng001pais = f.pepais
                                and s.sng001tdoc = f.Petdoc
                                and s.sng001ndoc = f.pendoc
                                and cttfir = 'T')
            
         and x.xwfmodulo = 141
         and x.XWFPRCINS = w.wfinsprcid
         and w.wfitemstsact = 1
         and x.xwfcar3 = '1';
  
    ln_pais          number;
    ln_tdoc          number;
    lc_ndoc          number;
    ln_CuotCntgAux   number;
    ln_SaldCap       number;
    ln_tipocambio    number;
    ln_Tarea         number;
    ld_fcheval       date;
    ld_MinFchCred    date;
    lc_EjecRatio     varchar2(2);
    ld_MinFchCredAux date;
    ln_InstCred      number;
    ln_TipoOri       number;
    ln_NroCuot       number;
  
  begin
    ln_MntCuoCntgCF := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
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
         and a.tp1corr1 = 850
         and a.TP1CORR2 = 101
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    begin
      PQ_CR_RATIO_EVALFLUJO.sp_cr_fchevaluacion(ln_Instancia, ld_fcheval);
    end;
  
    begin
      select min(F.PPFPAG)
        into ld_MinFchCredAux
        from xwf700 x, fsd601 f
       where x.xwfprcins = ln_Instancia
         and x.xwfempresa = f.pgcod
         and x.xwfsucursal = f.ppsuc
         and x.xwfmodulo = f.ppmod
         and x.xwfmoneda = f.ppmda
         and x.xwfpapel = f.pppap
         and x.xwfcuenta = f.ppcta
         and x.xwfoperacion = f.ppoper
         and x.xwfsubope = f.ppsbop
         and x.xwftipope = f.pptope
         and x.xwfcar3 = '1'
         and f.d601co in ('X', 'E');
    exception
      when others then
        null;
    end;
  
    begin
      ld_MinFchCred := ADD_MONTHS(last_Day(ld_MinFchCredAux), -1) + 1;
    end;
  
    if ln_pais is not null then
    
      for l in lista_CredVigCF(ln_pais, ln_tdoc, lc_ndoc) loop
        begin
          select f.scsdo * -1
            into ln_SaldCap
            from fsd011 f
           where f.pgcod = l.ln_pgcod10
             and f.scsuc = l.ln_suc10
             and f.scmda = l.ln_mda10
             and f.scpap = l.ln_pap10
             and f.sccta = l.ln_cta10
             and f.scoper = l.ln_oper10
             and f.scsbop = l.ln_sbop10
             and f.sctope = l.ln_tope10;
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if l.ln_mda10 = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
        
          begin
          
            ln_InstCred := fn_instancia_credito(l.ln_mod10,
                                                l.ln_suc10,
                                                l.ln_mda10,
                                                l.ln_pap10,
                                                l.ln_cta10,
                                                l.ln_oper10,
                                                l.ln_sbop10,
                                                l.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(l.ln_pgcod10,
                                                       l.ln_mod10,
                                                       l.ln_suc10,
                                                       l.ln_mda10,
                                                       l.ln_pap10,
                                                       l.ln_cta10,
                                                       l.ln_oper10,
                                                       l.ln_sbop10,
                                                       l.ln_tope10,
                                                       -- ln_InstCred,
                                                       ln_NroCuot);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(pd_fecpro,
                                                   lc_Usuario,
                                                   ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   ln_tipocambio,
                                                   ln_Instancia,
                                                   ld_fcheval,
                                                   ld_MinFchCred,
                                                   l.ln_pgcod10,
                                                   l.ln_mod10,
                                                   l.ln_suc10,
                                                   l.ln_mda10,
                                                   l.ln_pap10,
                                                   l.ln_cta10,
                                                   l.ln_oper10,
                                                   l.ln_sbop10,
                                                   l.ln_tope10,
                                                   ln_TipoOri,
                                                   ln_NroCuot,
                                                   ln_Tarea,
                                                   'CredVgntCF',
                                                   lc_flgprg,
                                                   ln_SaldCap,
                                                   ln_CuotCntgAux);
          end;
        end if;
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloCF(ln_pais, ln_tdoc, lc_ndoc) loop
      
        begin
          select w.xwfmonto1
            into ln_SaldCap
            from xwf700 w
           where w.xwfprcins = v.ln_InstAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if v.ln_mda10 = 101 then
        
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
        
          begin
          
            ln_InstCred := fn_instancia_credito(v.ln_mod10,
                                                v.ln_suc10,
                                                v.ln_mda10,
                                                v.ln_pap10,
                                                v.ln_cta10,
                                                v.ln_oper10,
                                                v.ln_sbop10,
                                                v.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(v.ln_pgcod10,
                                                       v.ln_mod10,
                                                       v.ln_suc10,
                                                       v.ln_mda10,
                                                       v.ln_pap10,
                                                       v.ln_cta10,
                                                       v.ln_oper10,
                                                       v.ln_sbop10,
                                                       v.ln_tope10,
                                                       -- ln_InstCred,
                                                       ln_NroCuot);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(pd_fecpro,
                                                   lc_Usuario,
                                                   ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   ln_tipocambio,
                                                   ln_Instancia,
                                                   ld_fcheval,
                                                   ld_MinFchCred,
                                                   v.ln_pgcod10,
                                                   v.ln_mod10,
                                                   v.ln_suc10,
                                                   v.ln_mda10,
                                                   v.ln_pap10,
                                                   v.ln_cta10,
                                                   v.ln_oper10,
                                                   v.ln_sbop10,
                                                   v.ln_tope10,
                                                   ln_TipoOri,
                                                   ln_NroCuot,
                                                   ln_Tarea,
                                                   'CredVuelCF',
                                                   lc_flgprg,
                                                   ln_SaldCap,
                                                   ln_CuotCntgAux);
          
          end;
        end if;
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  pd_fecpro         in date,
                                  lc_flgprg         in varchar2,
                                  lc_Usuario        in varchar2,
                                  lc_prgm           in varchar2,
                                  ln_MntCuoCntgAval out number) is
  
    cursor lista_CredVigAval(ln_pais number,
                             ln_tdoc number,
                             lc_doc  varchar2) is
      select distinct h.pgcod  ln_pgcod10,
                      h.aomod  ln_mod10,
                      h.aosuc  ln_suc10,
                      h.aomda  ln_mda10,
                      h.aopap  ln_pap10,
                      h.aocta  ln_cta10,
                      h.aooper ln_oper10,
                      h.aosbop ln_sbop10,
                      h.aotope ln_tope10
        from sng003 g, xwf700 x, fsd010 h
       where g.sng003cta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_doc
                                and f.cttfir = 'T')
         and g.sng001inst = x.xwfprcins
         and x.xwfcar3 = '1'
         and x.xwfempresa = h.pgcod
         and x.xwfsucursal = h.aosuc
         and x.xwfmodulo = h.aomod
         and x.xwfmoneda = h.aomda
         and x.xwfpapel = h.aopap
         and x.xwfcuenta = h.aocta
         and x.xwfoperacion = h.aooper
         and x.xwfsubope = h.aosbop
         and x.xwftipope = h.aotope
         and x.xwfmodulo in
             (select k.modulo
                from fst111 k
               where k.dscod = 50
                 and k.modulo not in (33, 200))
         and h.aostat <> 99;
  
    cursor lista_CredvueloAval(ln_pais number,
                               ln_tdoc number,
                               lc_doc  varchar2) is
    
      select distinct x.xwfempresa   ln_pgcod10,
                      x.xwfsucursal  ln_suc10,
                      x.xwfmodulo    ln_mod10,
                      x.xwfmoneda    ln_mda10,
                      x.xwfpapel     ln_pap10,
                      x.xwfcuenta    ln_cta10,
                      x.xwfoperacion ln_oper10,
                      x.xwfsubope    ln_sbop10,
                      x.xwftipope    ln_tope10,
                      x.xwfprcins    ln_InstanciaAvalada
      
        from sng003 g, xwf700 x, wfwrkitems w
       where g.sng003cta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_doc
                                and f.cttfir = 'T')
         and g.sng001inst = x.xwfprcins
         and x.xwfcar3 = '1'
         and x.xwfprcins = w.wfinsprcid
         and x.xwfmodulo in
             (select k.modulo
                from fst111 k
               where k.dscod = 50
                 and k.modulo not in (33, 200))
         and w.wfitemstsact = 1;
  
    ln_pais          number;
    ln_tdoc          number;
    lc_ndoc          varchar2(12);
    ln_paiscy        number;
    ln_tdoccy        number;
    lc_ndoccy        varchar2(12);
    ln_CuotCntgAux   number;
    ln_SaldCap       number;
    ln_tipocambio    number;
    ln_Tarea         number;
    ld_fcheval       date;
    ld_MinFchCred    date;
    lc_EjecRatio     varchar2(2);
    ld_MinFchCredAux date;
    ln_InstCred      number;
    ln_TipoOri       number;
    ln_NroCuot       number;
    ln_EsConsd       number;
  
  begin
    ln_MntCuoCntgAval := 0;
  
    begin
      -- Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      --- Datos del Cnyuge
      select f.rppais, f.rptdoc, f.rpndoc
        into ln_paiscy, ln_tdoccy, lc_ndoccy
        from fsr002 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.rpccyg = 66;
    exception
      when no_data_found then
        begin
          select f.rppais, f.rptdoc, f.rpndoc
            into ln_paiscy, ln_tdoccy, lc_ndoccy
            from fsr002 f
           where f.rppais = ln_pais
             and f.rptdoc = ln_tdoc
             and f.rpndoc = lc_ndoc
             and f.rpccyg = 66;
        exception
          when others then
            null;
        end;
      when others then
        null;
      
    end;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
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
         and a.tp1corr1 = 850
         and a.TP1CORR2 = 101
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    begin
      PQ_CR_RATIO_EVALFLUJO.sp_cr_fchevaluacion(ln_Instancia, ld_fcheval);
    end;
  
    begin
      select min(F.PPFPAG)
        into ld_MinFchCredAux
        from xwf700 x, fsd601 f
       where x.xwfprcins = ln_Instancia
         and x.xwfempresa = f.pgcod
         and x.xwfsucursal = f.ppsuc
         and x.xwfmodulo = f.ppmod
         and x.xwfmoneda = f.ppmda
         and x.xwfpapel = f.pppap
         and x.xwfcuenta = f.ppcta
         and x.xwfoperacion = f.ppoper
         and x.xwfsubope = f.ppsbop
         and x.xwftipope = f.pptope
         and x.xwfcar3 = '1'
         and f.d601co in ('X', 'E');
    exception
      when others then
        null;
    end;
  
    begin
      ld_MinFchCred := ADD_MONTHS(last_Day(ld_MinFchCredAux), -1) + 1;
    end;
  
    if ln_pais is not null then
    
      for l in lista_CredVigAval(ln_pais, ln_tdoc, lc_ndoc) loop
        begin
          select f.scsdo * -1
            into ln_SaldCap
            from fsd011 f
           where f.pgcod = l.ln_pgcod10
             and f.scsuc = l.ln_suc10
             and f.scmda = l.ln_mda10
             and f.scpap = l.ln_pap10
             and f.sccta = l.ln_cta10
             and f.scoper = l.ln_oper10
             and f.scsbop = l.ln_sbop10
             and f.sctope = l.ln_tope10;
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if l.ln_mda10 = 101 then
        
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
          begin
          
            ln_InstCred := fn_instancia_credito(l.ln_mod10,
                                                l.ln_suc10,
                                                l.ln_mda10,
                                                l.ln_pap10,
                                                l.ln_cta10,
                                                l.ln_oper10,
                                                l.ln_sbop10,
                                                l.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(l.ln_pgcod10,
                                                       l.ln_mod10,
                                                       l.ln_suc10,
                                                       l.ln_mda10,
                                                       l.ln_pap10,
                                                       l.ln_cta10,
                                                       l.ln_oper10,
                                                       l.ln_sbop10,
                                                       l.ln_tope10,
                                                       --  ln_InstCred,
                                                       ln_NroCuot);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(pd_fecpro,
                                                   lc_Usuario,
                                                   ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   ln_tipocambio,
                                                   ln_Instancia,
                                                   ld_fcheval,
                                                   ld_MinFchCred,
                                                   l.ln_pgcod10,
                                                   l.ln_mod10,
                                                   l.ln_suc10,
                                                   l.ln_mda10,
                                                   l.ln_pap10,
                                                   l.ln_cta10,
                                                   l.ln_oper10,
                                                   l.ln_sbop10,
                                                   l.ln_tope10,
                                                   ln_TipoOri,
                                                   ln_NroCuot,
                                                   ln_Tarea,
                                                   'CredVgnAvl',
                                                   lc_flgprg,
                                                   ln_SaldCap,
                                                   ln_CuotCntgAux);
          
          end;
        end if;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloAval(ln_pais, ln_tdoc, lc_ndoc) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1
            into ln_SaldCap
            from xwf700 w
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
        if v.ln_mda10 = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
          begin
            ln_InstCred := fn_instancia_credito(v.ln_mod10,
                                                v.ln_suc10,
                                                v.ln_mda10,
                                                v.ln_pap10,
                                                v.ln_cta10,
                                                v.ln_oper10,
                                                v.ln_sbop10,
                                                v.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(v.ln_pgcod10,
                                                       v.ln_mod10,
                                                       v.ln_suc10,
                                                       v.ln_mda10,
                                                       v.ln_pap10,
                                                       v.ln_cta10,
                                                       v.ln_oper10,
                                                       v.ln_sbop10,
                                                       v.ln_tope10,
                                                       --ln_InstCred,
                                                       ln_NroCuot);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(pd_fecpro,
                                                   lc_Usuario,
                                                   ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   ln_tipocambio,
                                                   ln_Instancia,
                                                   ld_fcheval,
                                                   ld_MinFchCred,
                                                   v.ln_pgcod10,
                                                   v.ln_mod10,
                                                   v.ln_suc10,
                                                   v.ln_mda10,
                                                   v.ln_pap10,
                                                   v.ln_cta10,
                                                   v.ln_oper10,
                                                   v.ln_sbop10,
                                                   v.ln_tope10,
                                                   ln_TipoOri,
                                                   ln_NroCuot,
                                                   ln_Tarea,
                                                   'CredVlAval',
                                                   lc_flgprg,
                                                   ln_SaldCap,
                                                   ln_CuotCntgAux);
          end;
        end if;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
    if ln_paiscy is not null then
      for l in lista_CredVigAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        if lc_flgprg = 'S' then
          begin
            select count(*)
              into ln_EsConsd
              from aqpa352 j
             where j.aqpa352pgcod = l.ln_pgcod10
               and j.aqpa352mod = l.ln_mod10
               and j.aqpa352suc = l.ln_suc10
               and j.aqpa352mda = l.ln_mda10
               and j.aqpa352pap = l.ln_pap10
               and j.aqpa352cta = l.ln_cta10
               and j.aqpa352ope = l.ln_oper10
               and j.aqpa352sbop = l.ln_sbop10
               and j.aqpa352tope = l.ln_tope10
               and j.aqpa352inst = ln_Instancia
               and j.aqpa352est = 'H';
          end;
        else
          if lc_flgprg = 'R' then
          
            begin
              select count(*)
                into ln_EsConsd
                from aqpa352 j
               where j.aqpa352pgcod = l.ln_pgcod10
                 and j.aqpa352mod = l.ln_mod10
                 and j.aqpa352suc = l.ln_suc10
                 and j.aqpa352mda = l.ln_mda10
                 and j.aqpa352pap = l.ln_pap10
                 and j.aqpa352cta = l.ln_cta10
                 and j.aqpa352ope = l.ln_oper10
                 and j.aqpa352sbop = l.ln_sbop10
                 and j.aqpa352tope = l.ln_tope10
                 and j.aqpa352inst = ln_Instancia
                 and j.aqpa352est = 'R';
            end;
          
          end if;
        end if;
      
        if ln_EsConsd = 0 then
        
          begin
            select f.scsdo * -1
              into ln_SaldCap
              from fsd011 f
             where f.pgcod = l.ln_pgcod10
               and f.scsuc = l.ln_suc10
               and f.scmda = l.ln_mda10
               and f.scpap = l.ln_pap10
               and f.sccta = l.ln_cta10
               and f.scoper = l.ln_oper10
               and f.scsbop = l.ln_sbop10
               and f.sctope = l.ln_tope10;
          exception
            when others then
              ln_SaldCap := 0;
          end;
        
          if l.ln_mda10 = 101 then
            ln_SaldCap := ln_SaldCap * ln_tipocambio;
          end if;
        
          ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
        
          if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
            begin
            
              ln_InstCred := fn_instancia_credito(l.ln_mod10,
                                                  l.ln_suc10,
                                                  l.ln_mda10,
                                                  l.ln_pap10,
                                                  l.ln_cta10,
                                                  l.ln_oper10,
                                                  l.ln_sbop10,
                                                  l.ln_tope10);
            
              PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                        ln_TipoOri);
            
              PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(l.ln_pgcod10,
                                                         l.ln_mod10,
                                                         l.ln_suc10,
                                                         l.ln_mda10,
                                                         l.ln_pap10,
                                                         l.ln_cta10,
                                                         l.ln_oper10,
                                                         l.ln_sbop10,
                                                         l.ln_tope10,
                                                         -- ln_InstCred,
                                                         ln_NroCuot);
            
              PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(pd_fecpro,
                                                     lc_Usuario,
                                                     ln_pais,
                                                     ln_tdoc,
                                                     lc_ndoc,
                                                     ln_tipocambio,
                                                     ln_Instancia,
                                                     ld_fcheval,
                                                     ld_MinFchCred,
                                                     l.ln_pgcod10,
                                                     l.ln_mod10,
                                                     l.ln_suc10,
                                                     l.ln_mda10,
                                                     l.ln_pap10,
                                                     l.ln_cta10,
                                                     l.ln_oper10,
                                                     l.ln_sbop10,
                                                     l.ln_tope10,
                                                     ln_TipoOri,
                                                     ln_NroCuot,
                                                     ln_Tarea,
                                                     'CredVgnAvl',
                                                     lc_flgprg,
                                                     ln_SaldCap,
                                                     ln_CuotCntgAux);
            end;
          
          end if;
        
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
        end if;
      end loop;
    
      for v in lista_CredvueloAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1
            into ln_SaldCap
            from xwf700 w
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if V.ln_mda10 = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
        
          begin
            ln_InstCred := fn_instancia_credito(v.ln_mod10,
                                                v.ln_suc10,
                                                v.ln_mda10,
                                                v.ln_pap10,
                                                v.ln_cta10,
                                                v.ln_oper10,
                                                v.ln_sbop10,
                                                v.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(v.ln_pgcod10,
                                                       v.ln_mod10,
                                                       v.ln_suc10,
                                                       v.ln_mda10,
                                                       v.ln_pap10,
                                                       v.ln_cta10,
                                                       v.ln_oper10,
                                                       v.ln_sbop10,
                                                       v.ln_tope10,
                                                       --  ln_InstCred,
                                                       ln_NroCuot);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_LogCuentas(pd_fecpro,
                                                   lc_Usuario,
                                                   ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   ln_tipocambio,
                                                   ln_Instancia,
                                                   ld_fcheval,
                                                   ld_MinFchCred,
                                                   v.ln_pgcod10,
                                                   v.ln_mod10,
                                                   v.ln_suc10,
                                                   v.ln_mda10,
                                                   v.ln_pap10,
                                                   v.ln_cta10,
                                                   v.ln_oper10,
                                                   v.ln_sbop10,
                                                   v.ln_tope10,
                                                   ln_TipoOri,
                                                   ln_NroCuot,
                                                   ln_Tarea,
                                                   'CredVlAval',
                                                   lc_flgprg,
                                                   ln_SaldCap,
                                                   ln_CuotCntgAux);
          end;
        
        end if;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    end if;
  
  end sp_cr_CuotaContinAval;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaPotencial(ln_Instancia   in number,
                                 ln_MntPotncial out number) is
  
    ln_TipoSol number;
  
  begin
  
    begin
      select s.sng021tmod
        into ln_TipoSol
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_TipoSol = 13 then
    
      ln_MntPotncial := 0;
    
      begin
        select sum(j.jaqy327cptn)
          into ln_MntPotncial
          from jaqy327 j
         where j.jaqy327inst = ln_Instancia
           and j.jaqy327esta = 'S'
           and j.jaqy327chek = '1';
      exception
        when others then
          ln_MntPotncial := 0;
      end;
    
    else
      if ln_TipoSol = 14 then
      
        ln_MntPotncial := 0;
      
        begin
          select sum(j.jaqz862cptn)
            into ln_MntPotncial
            from jaqz862 j
           where j.jaqz862inst = ln_Instancia
             and j.jaqz862esta = 'S'
             and j.jaqz862chek = '1';
        exception
          when others then
            ln_MntPotncial := 0;
        end;
      
      end if;
    end if;
  
    ln_MntPotncial := nvl(ln_MntPotncial, 0);
  
  end sp_cR_CuotaPotencial;
  -------------------------------------------------------------------------------
  procedure sp_cr_fchevaluacion(ln_Instancia     in number,
                                ld_fchevaluacion out date) is
    ln_TipoSol          number;
    ld_fchevaluacionAux date;
  
  begin
  
    begin
      select s.sng021tmod
        into ln_TipoSol
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        null;
    end;
    if ln_TipoSol = 13 then
      begin
        select SNG120FPag
          into ld_fchevaluacionAux
          from sng120 s
         where s.sng120ins = ln_Instancia
           and s.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    elsif ln_TipoSol = 14 then
      begin
        select SNG120FVal
          into ld_fchevaluacionAux
          from sng120 s
         where s.sng120ins = ln_Instancia
           and s.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    end if;
    ld_fchevaluacion := ld_fchevaluacionAux;
  
  end sp_cr_fchevaluacion;
  -------------------------------------------------------------------------------------------
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2) is --mod 2016.04.12
  
  begin
  
    begin
    
      select 'S'
        into Pc_flag
        from xwf700 a, sng001 s /* xwf070 w,*/, wfwrkitems x
       where a.xwfempresa = ln_emp10
         and a.xwfsucursal = ln_suc10
         and a.xwfmodulo = ln_mod10
         and a.xwfmoneda = ln_mda10
         and a.xwfpapel = ln_pap10
         and a.xwfcuenta = ln_cta10
         and a.xwfoperacion = ln_oper10
         and a.xwfsubope = ln_sbop10
         and a.xwftipope = ln_tope10
         and a.xwfprcins = s.sng001inst
         and s.sng001ori in (4, 15) -- Ampliaciones Normales, Ampliaciones Especiales
         and s.sng001inst = x.wfinsprcid
         and x.wfitemstsact = 1
         and rownum = 1;
    exception
      when no_data_found then
        Pc_flag := 'N';
    end;
  
  end Sp_ampliados_CK;

  --------------------------------------------------------------------------

  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2) is --mod 2016.04.12
  
  begin
    if pn_mod in (117, 116) then
      begin
        select 'S'
          into Pc_flag
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 20001
           and a.tp1corr1 = 1
           and a.tp1corr2 = 1211
           and a.tp1nro1 = pn_top;
      
      exception
        when no_data_found then
          Pc_flag := 'N';
      end;
    else
      Pc_flag := 'N';
    end if;
  
  end Sp_Adicional_CK;

  ------------------------------------------------------------

  procedure sp_refinanLinea(ln_pgcod10  in number,
                            ln_mod10    in number,
                            ln_suc10    in number,
                            ln_mda10    in number,
                            ln_pap10    in number,
                            ln_cta10    in number,
                            ln_oper10   in number,
                            lc_fgRefLin out varchar2) is
    --2017.03.28 DCASTRO se agrego condicion rownum    
  
    ln_InstVerfca number; --07012020 mpostigoc
  begin
  
    lc_fgRefLin := 'N';
    if ln_mod10 = 117 then
    
      begin
        select max(w.xwfprcins)
          into ln_InstVerfca
          from fsr011 f, xwf700 w
         where f.r1cod = w.xwfempresa
           and f.r1mod = w.xwfmodulo
           and f.r1suc = w.xwfsucursal
           and f.r1mda = w.xwfmoneda
           and f.r1pap = w.xwfpapel
           and f.r1cta = w.xwfcuenta
           and w.xwfcar3 = 'R'
           and f.r2cod = ln_pgcod10
           and f.r2mod = ln_mod10
           and f.r2suc = ln_suc10
           and f.R2MDA = ln_mda10
           and f.R2PAP = ln_pap10
           and f.r2cta = ln_cta10
           and f.r2oper = ln_oper10
           and f.relcod = 46; --mpostigoc 25/02/2020
      exception
        when no_data_found then
          ln_InstVerfca := 0;
      end;
    
      --mpostigoc 20200107 INC2264
      begin
        select 'S'
          into lc_fgRefLin
          from wfwrkitems w, sng001 s
         where w.wfinsprcid = s.sng001inst
           and w.wfinsprcid = ln_InstVerfca
           and s.sng001ori in (3, 13, 14)
           and w.wfitemstsact = 1;
      exception
        when others then
          lc_fgRefLin := 'N';
      end;
      --    
    else
    
      begin
        select 'S'
          into lc_fgRefLin
          from xwf700 a, sng001 s /*, xwf070 w*/, wfwrkitems x
         where a.xwfempresa = ln_pgcod10
           and a.xwfsucursal = ln_suc10
           and a.xwfmodulo = ln_mod10
           and a.xwfmoneda = ln_mda10
           and a.xwfpapel = ln_pap10
           and a.xwfcuenta = ln_cta10
           and a.xwfoperacion = ln_oper10
           and a.xwfprcins = s.sng001inst
           and s.sng001ori in (3, 13, 14) -- Refinanciaciones, Reprogramaciones
           and s.sng001inst = x.wfinsprcid
           and x.wfitemstsact = 1
           and rownum = 1;
      
      exception
        when no_data_found then
          lc_fgRefLin := 'N';
        
      end;
    end if;
  
  end sp_refinanLinea;
  --------------------------------------------------
  procedure sp_cr_VerVincLinea(ln_mod10  in number,
                               ln_suc10  in number,
                               ln_mda10  in number,
                               ln_pap10  in number,
                               ln_cta10  in number,
                               ln_oper10 in number,
                               ln_sbop10 in number,
                               ln_tope10 in number,
                               lc_FlgLn  out varchar2) is
  
    ln_InsVinc  number := 0;
    Ln_EstVignt number := 0;
  
  begin
    lc_FlgLn := 'N';
  
    begin
      select j.jaqy800ins
        into ln_InsVinc
        from jaqy800 j
       where JAQY800PGCD = 1
         and JAQY800MOD = ln_mod10
         and JAQY800SUC = ln_suc10
         and JAQY800MDA = ln_mda10
         and JAQY800PAP = ln_pap10
         and JAQY800CTA = ln_cta10
         and JAQY800OPE = ln_oper10
         and JAQY800SBOP = ln_sbop10
         and JAQY800TOPE = ln_tope10
         and jaqy800vinc = 'S'
         and rownum = 1;
    exception
      when others then
        ln_InsVinc := 0;
    end;
  
    if ln_InsVinc <> 0 then
      begin
        select count(*)
          into Ln_EstVignt
          from wfwrkitems w
         where w.wfinsprcid = ln_InsVinc
           and w.wfitemstsact = 1;
      exception
        when others then
          Ln_EstVignt := 0;
      end;
    
      if Ln_EstVignt > 0 then
        lc_FlgLn := 'S';
      
      else
        if Ln_EstVignt = 0 then
        
          begin
            select 'S'
              into lc_FlgLn
              from xwf700 x, fsd010 f
             where x.xwfprcins = ln_InsVinc
               and x.xwfcar3 = '1'
               and x.xwfempresa = f.pgcod
               and x.xwfsucursal = f.aosuc
               and x.xwfmodulo = f.aomod
               and x.xwfmoneda = f.aomda
               and x.xwfpapel = f.aopap
               and x.xwfcuenta = f.aocta
               and x.xwfoperacion = f.aooper
               and x.xwfsubope = f.aosbop
               and x.xwftipope = f.aotope;
          exception
            when others then
              lc_FlgLn := 'N';
          end;
        end if;
      end if;
    end if;
  
  end;
  -----------------------------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais      in number,
                           ln_Petdoc      in number,
                           ln_Pendoc      in varchar2,
                           tipocambio     in number,
                           Instancia      in number,
                           pd_fecpro      in date,
                           lc_Usuario     in varchar2,
                           lc_mesanio     in varchar2,
                           ln_captotcaja  in number,
                           ln_ifis        in number,
                           ln_ResultNeto  in number,
                           ln_MntCuoCntg  in number,
                           ln_MntPotncial in number,
                           ln_ratio       in number,
                           lc_flgprg      in varchar2,
                           ln_Tarea       in number) is
  
    ln_corr   number;
    lc_IndEst varchar2(2);
    lc_hora   character(8);
  
    --  ln_Instancia number;
  
  begin
  
    begin
    
      select max(j.aqpa354corr)
        into ln_corr
        from aqpa354 j
       where j.aqpa354fec = pd_fecpro
         and j.aqpa354inst = Instancia
         and j.aqpa354tarea = ln_Tarea;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    if lc_flgprg = 'S' then
    
      lc_IndEst := 'H';
    
      begin
        update aqpa354 j
           set j.aqpa354est = 'I'
         where j.aqpa354inst = Instancia
           and j.aqpa354est = 'H'
           and j.aqpa354tarea = ln_Tarea;
        commit;
      end;
    
    else
      if lc_flgprg = 'R' then
      
        lc_IndEst := 'R';
      
      end if;
    
    end if;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa354
        (aqpa354corr,
         aqpa354pais,
         aqpa354tdoc,
         aqpa354ndoc,
         aqpa354tcamb,
         aqpa354inst,
         aqpa354fec,
         aqpa354hora,
         aqpa354user,
         aqpa354mesanio,
         aqpa354capcaja,
         aqpa354ifis,
         aqpa354resneto,
         aqpa354ccontg,
         aqpa354cpoten,
         aqpa354ratio,
         aqpa354est,
         aqpa354tarea)
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         tipocambio,
         Instancia,
         pd_fecpro,
         lc_hora,
         lc_Usuario,
         lc_mesanio,
         ln_captotcaja,
         ln_ifis,
         ln_ResultNeto,
         ln_MntCuoCntg,
         ln_MntPotncial,
         ln_ratio,
         lc_IndEst,
         ln_Tarea);
    exception
      when others then
        null;
        commit;
      
    end;
  
  end sp_cr_LogRatio;
  ----------------------------------------------------------------------
  procedure sp_cr_LogDetMensualII(ln_Instancia   in number,
                                  ln_modulo      in number,
                                  ln_mntcuota    in number,
                                  ld_fchPanel    in date,
                                  ln_NroCuOtorg  in number,
                                  ln_NroCuotCred in number,
                                  lc_programa    in varchar2,
                                  lc_Indicador   in varchar2) is
  
    ln_mntacumld number := 0.00;
    ln_newmnt    number := 0.00;
    ln_Estado    varchar2(2) := 'H';
    ln_tarea     number;
  
  begin
  
    if lc_programa = 'RJAQY843' then
      ln_Estado := 'R';
    else
      if lc_programa = 'RAQPA367' then
        ln_Estado := 'H';
      end if;
    end if;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    if ln_modulo = 117 then
    
      if lc_Indicador = 'CredVuelo' then
        -- Si la linea es la que se esta otorgando, el monto calculado se coloca 
        -- en la ultima cuota según su máximo plazo de utilización
      
        begin
          select a.AQPA353capcaja
            into ln_mntacumld
            from AQPA353 a
           where a.AQPA353inst = ln_Instancia
             and a.AQPA353corr = ln_NroCuotCred + 1
             and a.AQPA353est = ln_Estado
             and a.aqpa353tarea = ln_Tarea;
        exception
          when others then
            ln_mntacumld := 0.00;
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA353 a
             set a.AQPA353capcaja = ln_newmnt
           where a.AQPA353inst = ln_Instancia
             and a.AQPA353est = ln_Estado
             AND a.AQPA353corr = ln_NroCuotCred + 1
             and a.aqpa353tarea = ln_Tarea;
        end;
      else
        if lc_Indicador = 'CredVigent' then
          begin
            select a.AQPA353capcaja
              into ln_mntacumld
              from AQPA353 a
             where a.AQPA353inst = ln_Instancia
               and a.AQPA353corr = ln_NroCuOtorg + 1
               and a.AQPA353est = ln_Estado
               and a.aqpa353tarea = ln_Tarea;
          exception
            when others then
              ln_mntacumld := 0.00;
          end;
        
          begin
            ln_newmnt := ln_mntacumld + ln_mntcuota;
          end;
        
          begin
            update AQPA353 a
               set a.AQPA353capcaja = ln_newmnt
             where a.AQPA353inst = ln_Instancia
               and a.AQPA353est = ln_Estado
               AND a.AQPA353corr = ln_NroCuOtorg + 1
               and a.aqpa353tarea = ln_Tarea;
          end;
        end if;
      end if;
    else
      if ln_modulo <> 117 then
        begin
          select a.AQPA353capcaja
            into ln_mntacumld
            from AQPA353 a
           where a.AQPA353inst = ln_Instancia
             and a.AQPA353fecal = ld_fchPanel
             and a.AQPA353est = ln_Estado
             and a.aqpa353tarea = ln_Tarea;
        exception
          when others then
            ln_mntacumld := 0;
        end;
      
        begin
          ln_newmnt := nvl(ln_mntacumld, 0) + nvl(ln_mntcuota, 0);
        end;
      
        begin
          update AQPA353 a
             set a.AQPA353capcaja = ln_newmnt
           where a.AQPA353inst = ln_Instancia
             and a.AQPA353est = ln_Estado
             AND a.AQPA353fecal = ld_fchPanel
             and a.aqpa353tarea = ln_Tarea;
        end;
      
      end if;
    end if;
    commit;
  
  end sp_cr_LogDetMensualII;
  ---------------------------------------------------------------
  procedure sp_cr_LogDetMensPanel(ln_Instancia   in number,
                                  ln_modulo      in number,
                                  ln_mntcuota    in number,
                                  ld_fchPanel    in date,
                                  ln_NroCuOtorg  in number,
                                  ln_NroCuotCred in number,
                                  lc_Indicador   in varchar2) is
  
    ln_mntacumld number := 0.00;
    ln_newmnt    number := 0.00;
  begin
  
    if ln_modulo = 117 then
    
      if lc_Indicador = 'CredVuelo' then
        -- Si la linea es la que se esta otorgando, el monto calculado se coloca 
        -- en la ultima cuota según su máximo plazo de utilización
      
        begin
          select a.AQPA356capcaja
            into ln_mntacumld
            from AQPA356 a
           where a.AQPA356inst = ln_Instancia
             and a.AQPA356corr = ln_NroCuotCred + 1
             and a.AQPA356est = 'H';
        exception
          when others then
            ln_mntacumld := 0.00;
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA356 a
             set a.AQPA356capcaja = ln_newmnt
           where a.AQPA356inst = ln_Instancia
             and a.AQPA356est = 'H'
             AND a.AQPA356corr = ln_NroCuotCred + 1;
          commit;
        end;
      
      else
        if lc_Indicador = 'CredVigent' then
          -- Si la linea es vigente, el monto calculado se coloca en la ultima cuota
          -- del credito a otorgar
          begin
            select a.AQPA356capcaja
              into ln_mntacumld
              from AQPA356 a
             where a.AQPA356inst = ln_Instancia
               and a.AQPA356corr = ln_NroCuOtorg + 1
               and a.AQPA356est = 'H';
          exception
            when others then
              ln_mntacumld := 0.00;
          end;
        
          begin
            ln_newmnt := ln_mntacumld + ln_mntcuota;
          end;
        
          begin
            update AQPA356 a
               set a.AQPA356capcaja = ln_newmnt
             where a.AQPA356inst = ln_Instancia
               and a.AQPA356est = 'H'
               AND a.AQPA356corr = ln_NroCuOtorg + 1;
            commit;
          end;
        end if;
      end if;
    
    else
      if ln_modulo <> 117 then
        begin
          select a.AQPA356capcaja
            into ln_mntacumld
            from AQPA356 a
           where a.AQPA356inst = ln_Instancia
             and a.AQPA356fecal = ld_fchPanel
             and a.AQPA356est = 'H';
        exception
          when others then
            ln_mntacumld := 0;
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA356 a
             set a.AQPA356capcaja = ln_newmnt
           where a.AQPA356inst = ln_Instancia
             and a.AQPA356est = 'H'
             AND a.AQPA356fecal = ld_fchPanel;
          commit;
        end;
      
      end if;
    end if;
  
    commit;
  
  end sp_cr_LogDetMensPanel;

  -------------------------------------------------------------------
  procedure sp_cr_LogCuentas(ld_fec     in date,
                             lc_user    in varchar2,
                             ln_pais    in number,
                             ln_tdoc    in number,
                             ln_ndoc    in varchar2,
                             ln_tcamb   in number,
                             ln_inst    in number,
                             ld_feval   in date,
                             ld_fical   in date,
                             ln_pgcod   in number,
                             ln_mod     in number,
                             ln_suc     in number,
                             ln_mda     in number,
                             ln_pap     in number,
                             ln_cta     in number,
                             ln_ope     in number,
                             ln_sbop    in number,
                             ln_tope    in number,
                             ln_TipoOri in number,
                             ln_NroCuot in number,
                             ln_tarea   in number,
                             lc_IndCred in varchar2,
                             lc_flgprg  in varchar2,
                             ln_SaldCap in number,
                             ln_monto   in number) is
  
    ln_corr   number;
    lc_hora   character(8);
    lc_IndEst varchar2(2);
  
  begin
  
    begin
    
      select max(j.aqpa352corr)
        into ln_corr
        from aqpa352 j
       where j.aqpa352fec = ld_fec
         and j.aqpa352inst = ln_inst
         and j.aqpa352tarea = ln_tarea;
    exception
      when no_data_found then
        ln_corr := 0;
      
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    if lc_flgprg = 'S' then
    
      lc_IndEst := 'H';
    
    else
      if lc_flgprg = 'R' then
      
        lc_IndEst := 'R';
      
      end if;
    end if;
  
    -- if lc_exist = 'N' then
  
    begin
      insert into aqpa352
        (aqpa352corr,
         aqpa352fec,
         aqpa352hora,
         aqpa352user,
         aqpa352pais,
         aqpa352tdoc,
         aqpa352ndoc,
         aqpa352tcamb,
         aqpa352inst,
         AQPA352FEVAL,
         AQPA352FICAL,
         aqpa352pgcod,
         aqpa352mod,
         aqpa352suc,
         aqpa352mda,
         aqpa352pap,
         aqpa352cta,
         aqpa352ope,
         aqpa352sbop,
         aqpa352tope,
         AQPA352ori,
         AQPA352ncuo,
         aqpa352est,
         aqpa352tarea,
         aqpa352IndCred,
         AQPA352NAUX1,
         AQPA352NAUX2)
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         lc_user,
         ln_pais,
         ln_tdoc,
         ln_ndoc,
         ln_tcamb,
         ln_inst,
         ld_feval,
         ld_fical,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_TipoOri,
         ln_NroCuot,
         lc_IndEst,
         ln_tarea,
         lc_IndCred,
         ln_SaldCap,
         ln_monto);
    exception
      when others then
        null;
      
        commit;
      
    end;
  
  end sp_cr_LogCuentas;
  ---------------------------------------------------------------
  procedure sp_cr_DatosPanelEF(ln_Instancia  in number,
                               ld_FecPro     in date,
                               lc_Usuario    in varchar2,
                               ln_capcontgnt in number,
                               lc_prgm       in varchar2) is
  
    cursor Cuotas_EvalFlujo is
      select *
        from aqpa410 a
       where a.aqpa410inst = ln_Instancia
         and a.aqpa410esta = 'S'
       order by a.aqpa410fcon;
  
    lc_aniomescuo  varchar2(8);
    lc_hora        character(8) := '00:00:00';
    ln_Pepais      number;
    ln_Petdoc      number;
    ln_Pendoc      varchar2(12);
    ln_TipCamb     number;
    ln_corr        number := 0;
    ln_Estado      varchar2(5) := 'H';
    ln_Tarea       number;
    ln_MntPotncial number(17, 2) := 0.00;
  
  begin
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    if lc_prgm = 'RJAQY843' then
    
      begin
        -- Elimina los registros que se hayan almacenado anteriormente
        -- para el calculo del Ratio Evaluacion por Flujo
        delete aqpa353 a
         where a.aqpa353inst = ln_Instancia
           and a.aqpa353est = 'R';
        commit;
        ln_Estado := 'R';
      end;
    
    else
      if lc_prgm = 'RAQPA367' then
        begin
          -- Actualiza el estado de los registros que se hayan almacenado anteriormente
          -- para el calculo del Ratio Evaluacion por Flujo
          update aqpa353 a
             set a.aqpa353est = 'I'
           where a.aqpa353inst = ln_Instancia
             and a.aqpa353est = 'H'
             and a.aqpa353tarea = ln_Tarea;
          commit;
        end;
      
        ln_Estado := 'H';
      
      end if;
    end if;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      --Tipo de Cambio
      select s. sng120tcbi
        into ln_TipCamb
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipCamb := 0;
    end;
  
    begin
      -- Cuota Potencial
      PQ_CR_RATIO_EVALFLUJO.sp_cR_CuotaPotencial(ln_Instancia,
                                                 ln_MntPotncial);
    
      ln_MntPotncial := nvl(ln_MntPotncial, 0);
    end;
  
    for c in Cuotas_EvalFlujo loop
    
      begin
        select to_char(c.aqpa410fcon, 'YYYYMM')
          into lc_aniomescuo
          from dual;
      exception
        when others then
          null;
      end;
    
      begin
        select max(a.aqpa353corr)
          into ln_corr
          from aqpa353 a
         where a.aqpa353inst = ln_Instancia
           and a.aqpa353tarea = ln_tarea
           and a.aqpa353est = ln_Estado;
      exception
        when others then
          null;
      end;
    
      ln_corr := nvl(ln_corr, 0);
    
      begin
      
        insert into aqpa353
          (aqpa353corr,
           aqpa353fec,
           aqpa353hora,
           aqpa353user,
           aqpa353pais,
           aqpa353tdoc,
           aqpa353ndoc,
           aqpa353tcamb,
           aqpa353inst,
           aqpa353feval,
           aqpa353fecal,
           aqpa353mesanio,
           aqpa353capcaja,
           aqpa353ifis,
           aqpa353resneto,
           aqpa353ccontg,
           aqpa353cpoten,
           aqpa353ratio,
           aqpa353est,
           aqpa353tarea)
        values
          (ln_corr + 1,
           ld_FecPro,
           lc_hora,
           lc_Usuario,
           ln_Pepais,
           ln_Petdoc,
           ln_Pendoc,
           ln_TipCamb,
           ln_Instancia,
           c.aqpa410feval,
           c.aqpa410fcon,
           lc_aniomescuo,
           0.00,
           0.00, -- c.aqpa410ifis,
           0.00, -- c.aqpa410resn,
           ln_capcontgnt,
           ln_MntPotncial,
           0.000000,
           ln_Estado,
           ln_Tarea);
        /* exception
        when others then
          null;*/
      
        COMMIT;
        -- ln_corr := ln_corr + 1;        
      end;
      COMMIT;
    
    end loop;
  
  end sp_cr_DatosPanelEF;
  -------------------------------------------------------------
  procedure sp_cr_DatosPanelEFII(ln_Instancia in number,
                                 ld_FecPro    in date,
                                 lc_Usuario   in varchar2) is
  
    cursor Cuotas_EvalFlujo is
      select *
        from aqpa411 a
       where a.aqpa411inst = ln_Instancia
       order by a.aqpa411feca;
  
    lc_aniomescuo varchar2(8);
    lc_hora       character(8) := '00:00:00';
    ln_Pepais     number;
    ln_Petdoc     number;
    ln_Pendoc     varchar2(12);
    ln_TipCamb    number;
  
  begin
  
    begin
      -- Eliminar los registros que se hayan almacenado anteriormente
      -- para el calculo del Ratio Evaluacion por Flujo
      delete aqpa356 a where a.aqpa356inst = ln_Instancia;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      --Tipo de Cambio
      select s. sng120tcbi
        into ln_TipCamb
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipCamb := 0;
    end;
  
    for c in Cuotas_EvalFlujo loop
    
      begin
        select to_char(c.aqpa411feca, 'YYYYMM')
          into lc_aniomescuo
          from dual;
      exception
        when others then
          null;
      end;
    
      begin
      
        insert into aqpa356
          (aqpa356corr,
           aqpa356fec,
           aqpa356hora,
           aqpa356user,
           aqpa356pais,
           aqpa356tdoc,
           aqpa356ndoc,
           aqpa356tcamb,
           aqpa356inst,
           aqpa356feval,
           aqpa356fecal,
           aqpa356mesanio,
           aqpa356capcaja,
           aqpa356est)
        
        values
          (c.aqpa411corr,
           ld_FecPro,
           lc_hora,
           lc_Usuario,
           ln_Pepais,
           ln_Petdoc,
           ln_Pendoc,
           ln_TipCamb,
           ln_Instancia,
           c.aqpa411fece,
           c.aqpa411feca,
           lc_aniomescuo,
           0.00,
           'H');
      exception
        when others then
          null;
        
          COMMIT;
        
      end;
    
    end loop;
  
  end sp_cr_DatosPanelEFII;
  -----------------------------------------------------------
  procedure sp_cr_CalCuota( --ln_InsCredito in number,
                           ln_pgcod    in number,
                           ln_mod      in number,
                           ln_suc      in number,
                           ln_mda      in number,
                           ln_pap      in number,
                           ln_cta      in number,
                           ln_ope      in number,
                           ln_sbop     in number,
                           ln_tope     in number,
                           ld_fini     in date,
                           ld_ffin     in date,
                           ln_TipCamb  in number,
                           ln_NroCuot  out number,
                           ln_MntCuota out number) is
  
    ln_MntCuoMesCapint number := 0.00;
    ln_MntCuoMesSeg    number := 0.00;
    ln_MntCuoMesAux    number(17, 2) := 0.00;
  
  begin
  
    if ln_mod <> 117 then
    
      begin
        select /*+ parallel(n,2,1)*/
         sum(n.ppcap + n.ppint)
          into ln_MntCuoMesCapint
          from fsd601 n
         where n.pgcod = ln_pgcod
           and n.ppcta = ln_cta
           and n.ppmda = ln_mda
           and n.ppsuc = ln_suc
           and n.pppap = ln_pap
           and n.ppoper = ln_ope
           and n.ppsbop = ln_sbop
           and n.pptope = ln_tope
           and n.ppmod = ln_mod
           and n.d601co in ('S', 'X', 'E')
           and n.ppfpag between ld_fini and ld_ffin
           and (n.ppcap + n.ppint) > 0
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
                   and o.d602co in ('S', 'X')
                   and (o.pp1cap + o.pp1int) > 0);
      end;
    
      ln_MntCuoMesCapint := nvl(ln_MntCuoMesCapint, 0);
    
      if ln_mda = 101 then
        ln_MntCuoMesCapint := ln_MntCuoMesCapint * ln_TipCamb;
      end if;
    
      if ln_MntCuoMesCapint > 0 then
        -- INC2081 MPOSTIGOC
        begin
          select /*+ parallel(n,2,1)*/
           sum(n.ppimp11 + n.ppimp12 + n.ppimp13 + n.ppimp14 + n.ppimp15)
            into ln_MntCuoMesSeg
            from fsd611 n
           where n.pgcod = ln_pgcod
             and n.ppcta = ln_cta
             and n.ppmda = ln_mda
             and n.ppsuc = ln_suc
             and n.pppap = ln_pap
             and n.ppoper = ln_ope
             and n.ppsbop = ln_sbop
             and n.pptope = ln_tope
             and n.ppmod = ln_mod
             and n.ppfpag between ld_fini and ld_ffin
             and not exists
           (select /*+ parallel(o,2,1)*/
                   g.ppmod, g.ppcta, g.ppoper, g.pptope, g.ppfpag
                    from fsd602 o, fsd612 g
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
                     and o.d602co in ('S', 'X')
                     and (o.pp1cap + o.pp1int) > 0
                     and o.pgcod = g.pgcod
                     and o.ppmod = g.ppmod
                     and o.ppsuc = g.ppsuc
                     and o.ppmda = g.ppmda
                     and o.pppap = g.pppap
                     and o.ppcta = g.ppcta
                     and o.ppoper = g.ppoper
                     and o.ppsbop = g.ppsbop
                     and o.pptope = g.pptope);
        end;
      
        ln_MntCuoMesSeg := nvl(ln_MntCuoMesSeg, 0);
      
        if ln_mda = 101 then
          ln_MntCuoMesSeg := ln_MntCuoMesSeg * ln_TipCamb;
        end if;
      end if; -- INC2081 MPOSTIGOC
    
      ln_MntCuoMesSeg    := nvl(ln_MntCuoMesSeg, 0);
      ln_MntCuoMesCapint := nvl(ln_MntCuoMesCapint, 0);
    
      ln_MntCuota := ln_MntCuoMesCapint + ln_MntCuoMesSeg;
      ln_MntCuota := nvl(ln_MntCuota, 0);
    
      begin
        PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod,
                                                   ln_mod,
                                                   ln_suc,
                                                   ln_mda,
                                                   ln_pap,
                                                   ln_cta,
                                                   ln_ope,
                                                   ln_sbop,
                                                   ln_tope,
                                                   -- ln_InsCredito,
                                                   ln_NroCuot);
      end;
    
    else
      if ln_mod = 117 then
      
        begin
          pq_cr_ratio_evalflujo.sp_capacidadlinea(ln_mod,
                                                  ln_suc,
                                                  ln_mda,
                                                  ln_pap,
                                                  ln_cta,
                                                  ln_ope,
                                                  ln_sbop,
                                                  ln_tope,
                                                  ln_TipCamb,
                                                  ln_MntCuoMesAux);
        end;
        begin
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod,
                                                     ln_mod,
                                                     ln_suc,
                                                     ln_mda,
                                                     ln_pap,
                                                     ln_cta,
                                                     ln_ope,
                                                     ln_sbop,
                                                     ln_tope,
                                                     -- ln_InsCredito,
                                                     ln_NroCuot);
        end;
        ln_MntCuota := ln_MntCuoMesAux * ln_NroCuot;
        ln_MntCuota := nvl(ln_MntCuota, 0);
      end if;
    end if;
  
  end sp_cr_CalCuota;
  -----------------------------------------------------------
  procedure sp_cr_CalCuotaDispnbl(ln_pgcod        in number,
                                  ln_suc          in number,
                                  ln_mod          in number,
                                  ln_mda          in number,
                                  ln_pap          in number,
                                  ln_cta          in number,
                                  ln_oper         in number,
                                  ln_sbop         in number,
                                  ln_tope         in number,
                                  ln_MntDispnbl   in number,
                                  tipocambio      in number,
                                  ln_CuotaDispnbl out number) is
  
    lc_FlagGuia   varchar2(2) := 'N';
    LN_TIPOCRED   number;
    lc_FlagSegmnt varchar2(2) := 'N';
    ln_plazo      number := 0;
    ln_paralelo   number := 0;
    ln_tasa       number := 0;
    ln_instancia  number := 0;
    ln_saldo      number(17, 2);
  
  begin
  
    ln_saldo := ln_MntDispnbl;
  
    begin
      select 'S'
        into lc_FlagGuia
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 18
         and a.tp1nro2 = ln_mod
         and a.tp1nro3 = ln_tope;
    exception
      when others then
        lc_FlagGuia := 'N';
    end;
  
    if lc_FlagGuia = 'S' then
      --Extraemos el plazo de la guia
    
      begin
        ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                             v_Scsuc  => ln_suc,
                                             v_Scmda  => ln_mda,
                                             v_Scpap  => ln_pap,
                                             v_Sccta  => ln_cta,
                                             v_Scoper => ln_oper,
                                             v_Scsbop => ln_sbop,
                                             v_Sctope => ln_tope);
      
      end;
    
      begin
        -- Tipo de Credito en el flujo
      
        select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval, ';', ''))),
                                        '([A-Z])',
                                        ''))
          into LN_TIPOCRED
          from wfattsvalues w
         where w.wfinsprcid = ln_instancia
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
    
      begin
        select 'S'
          into lc_FlagSegmnt
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 17
           and a.tp1nro3 = LN_TIPOCRED;
      exception
        when others then
          lc_FlagSegmnt := 'N';
      end;
    
      if lc_FlagSegmnt = 'S' then
        -- mpostigoc 23/11/2017
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = ln_tope
             and f.pp028mda = ln_mda; -- plazo
        exception
          when others then
            null;
        end;
      
      else
        if lc_FlagSegmnt = 'N' then
        
          begin
            select a.tp1nro2
              into ln_plazo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 13
               and a.tp1corr2 = 17
               and a.tp1corr3 = 4;
          exception
            when others then
              null;
          end;
        
        end if;
      end if;
    
    else
    
      if lc_FlagGuia = 'N' then
        -- Extraemos el plazo del Preseteo
        -- mpostigoc 09/01/2018
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = ln_tope
             and f.pp028mda = ln_mda; -- plazo
        exception
          when others then
            null;
        end;
      
      end if;
    
    end if;
  
    begin
      -- 02.11.2022 control de tasas
      begin
        select x.xlltasap
          into ln_tasa
          from x054023 x
         where x.Xllpgcod = ln_pgcod
           and x.Xllaomod = ln_mod
           and x.Xllaosuc = ln_suc
           and x.Xllaomda = ln_mda
           and x.Xllaopap = ln_pap
           and x.XLLAOCTA = ln_cta
           and x.Xllaooper = ln_oper
           and x.Xllaosbop = ln_sbop
           and x.Xllaotop = ln_tope;
      exception
        when others then
          ln_tasa := 0.00;
      end;
    
      if ln_tasa = 0 then
        begin
          select f.aotasa
            into ln_tasa
            from fsd010 f
           where f.pgcod = ln_pgcod
             and f.aomod = ln_mod
             and f.aosuc = ln_suc
             and f.aomda = ln_mda
             and f.aopap = ln_pap
             and f.aocta = ln_cta
             and f.aooper = ln_oper
             and f.aosbop = ln_sbop
             and f.aotope = ln_tope;
        exception
          when others then
            ln_tasa := 2.99;
        end;
      end if;
    end;
  
    begin
      select SUM(SNGE01IMPA)
        into ln_paralelo
        from SNGE01
       WHERE SNGE01INST = ln_instancia;
    exception
      when others then
        ln_paralelo := 0.00;
    end;
  
    ln_saldo := nvl(ln_saldo, 0) - nvl(ln_paralelo, 0);
  
    if ln_mda = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    begin
    
      ln_CuotaDispnbl := (ln_saldo *
                         ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                         (1 - power((1 + ((power((1 + (ln_tasa / 100)),
                                                 (1 / 12))) - 1)),
                                    -ln_plazo));
    
    end;
  end sp_cr_CalCuotaDispnbl;

  -----------------------------------------------------------
  procedure sp_cr_CalFormula(ln_Instancia in number,
                             lc_programa  in varchar2) is
  
    cursor lista_reg(lc_estado varchar2, ln_Tarea number) is
    
      select b.aqpa353capcaja ln_cmac,
             --  b.aqpa353ifis    ln_ifis,
             --  b.aqpa353resneto ln_resneto,
             b.aqpa353ccontg ln_ccontg,
             b.aqpa353cpoten ln_cpoten,
             b.aqpa353fecal  ld_fcalnd
        from aqpa353 B
       WHERE B.AQPA353INST = ln_Instancia
         and b.aqpa353est = lc_estado
         and b.aqpa353tarea = ln_Tarea;
  
    ln_ReslNeto  number(17, 2) := 0.00;
    ln_DeudaIFIS number(17, 2) := 0.00;
    ln_ratio     number(12, 6) := 0.000000;
    ln_Estado    varchar2(5) := 'H';
    ln_dividendo number;
    ln_divisor   number;
    ln_Tarea     number;
  
  begin
  
    if lc_programa = 'RJAQY843' then
      ln_Estado := 'R';
    else
      if lc_programa = 'RAQPA367' then
        ln_Estado := 'H';
      end if;
    end if;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    for l in lista_reg(ln_Estado, ln_Tarea) loop
    
      begin
        select a.aqpa410resn, a.aqpa410ifis
          into ln_ReslNeto, ln_DeudaIFIS
          from aqpa410 a
         where a.aqpa410inst = ln_Instancia
           and a.aqpa410fcon = l.ld_fcalnd
           and a.aqpa410esta = 'S';
      exception
        when others then
          ln_ReslNeto  := 0.00;
          ln_DeudaIFIS := 0.00;
      end;
    
      --  ln_DeudaIFIS := nvl(ln_DeudaIFIS, 0) - nvl(l.ln_cpoten, 0); -- mpostigoc 03.07.21
    
      ln_dividendo := nvl(l.ln_cmac, 0) + nvl(ln_DeudaIFIS, 0) +
                      nvl(l.ln_ccontg, 0) + nvl(l.ln_cpoten, 0);
      ln_divisor   := nvl(ln_DeudaIFIS, 0) + nvl(ln_ReslNeto, 0) +
                      nvl(l.ln_cpoten, 0);
    
      if ln_divisor > 0 and l.ln_cmac > 0 then
        begin
          ln_ratio := round((ln_dividendo / ln_divisor), 6);
        end;
      else
        ln_ratio := 0.000000;
      end if;
    
      begin
        update aqpa353 a
           set a.aqpa353ifis    = ln_DeudaIFIS,
               a.aqpa353resneto = ln_ReslNeto,
               a.aqpa353ratio   = ln_ratio
         where a.aqpa353inst = ln_Instancia
           and a.aqpa353fecal = l.ld_fcalnd
           and a.aqpa353est = ln_Estado
           and a.aqpa353tarea = ln_Tarea;
      end;
    
    end loop;
  
    commit;
  
  end sp_cr_CalFormula;
  ------------------------------------------------------------
  procedure sp_cr_CalcDisponible(ln_pgcod     in number,
                                 ln_mod       in number,
                                 ln_suc       in number,
                                 ln_mda       in number,
                                 ln_pap       in number,
                                 ln_cta       in number,
                                 ln_ope       in number,
                                 ln_sbop      in number,
                                 ln_tope      in number,
                                 ln_MntDispnb out number) is
  
    ln_pgcod117     number;
    ln_modulo117    number;
    ln_sucursal117  number;
    ln_moneda117    number;
    ln_papel117     number;
    ln_cuenta117    number;
    ln_operacion117 number;
    ln_sbop117      number;
    ln_top117       number;
    ln_LineaTotal   number(17, 2) := 0.00;
    ln_LineaUtilzd  number(17, 2) := 0.00;
  
  begin
  
    begin
      select r2cod,
             r2mod,
             r2suc,
             r2mda,
             r2pap,
             r2cta,
             r2oper,
             r2sbop,
             r2tope
        into ln_pgcod117,
             ln_modulo117,
             ln_sucursal117,
             ln_moneda117,
             ln_papel117,
             ln_cuenta117,
             ln_operacion117,
             ln_sbop117,
             ln_top117
        from fsr011 f
       where f.r1cod = ln_pgcod
         and f.r1mod = ln_mod
         and f.r1suc = ln_suc
         and f.r1cta = ln_cta
         and f.r1oper = ln_ope
         and f.r1sbop = ln_sbop
         and f.r1mda = ln_mda
         and f.r1pap = ln_pap
         and f.r1tope = ln_tope
         and f.relcod = 46;
    exception
      when others then
        ln_pgcod117     := 0;
        ln_modulo117    := 0;
        ln_sucursal117  := 0;
        ln_moneda117    := 0;
        ln_papel117     := 0;
        ln_cuenta117    := 0;
        ln_operacion117 := 0;
        ln_sbop117      := 0;
        ln_top117       := 0;
    end;
  
    if ln_modulo117 > 0 then
    
      begin
        select f.scsdo
          into ln_LineaTotal
          from fsd011 f
         where f.pgcod = ln_pgcod117
           and f.scsuc = ln_sucursal117
           and f.scmda = ln_moneda117
           and f.scpap = ln_papel117
           and f.sccta = ln_cuenta117
           and f.scoper = ln_operacion117
           and f.scsbop = ln_sbop117
           and f.sctope = ln_top117
           and f.scmod = ln_modulo117;
      exception
        when others then
          ln_LineaTotal := 0.00;
      end;
    end if;
  
    begin
      select f.scsdo * -1
        into ln_LineaUtilzd
        from fsd011 f
       where f.pgcod = ln_pgcod
         and f.scmod = ln_mod
         and f.scsuc = ln_suc
         and f.scmda = ln_mda
         and f.scpap = ln_pap
         and f.sccta = ln_cta
         and f.scoper = ln_ope
         and f.scsbop = ln_sbop
         and f.sctope = ln_tope;
    exception
      when others then
        ln_LineaUtilzd := 0.00;
    end;
  
    ln_MntDispnb := ln_LineaTotal - ln_LineaUtilzd;
  
  end sp_cr_CalcDisponible;
  -----------------------------------------------------------
  procedure sp_cr_UpdateAQPA410(ln_Instancia in number) is
  
    cursor up_cuotacmac is
      select b.aqpa356fecal fch_calendario, b.aqpa356capcaja ln_cuocmac
        from aqpa356 B
       WHERE B.AQPA356INST = ln_Instancia
         and b.aqpa356est = 'H';
  
  begin
    for u in up_cuotacmac loop
      begin
        update aqpa410 a
           set a.aqpa410cuoc = u.ln_cuocmac
         where a.aqpa410inst = ln_Instancia
           and a.aqpa410esta = 'S'
           and a.aqpa410fcon = u.fch_calendario;
      end;
      commit;
    end loop;
  end;
  -------------------------------------------------------------
  procedure sp_cr_VerfDesmbPendiente(ln_pgcod           in number,
                                     ln_mod             in number,
                                     ln_suc             in number,
                                     ln_mda             in number,
                                     ln_pap             in number,
                                     ln_cta             in number,
                                     ln_oper            in number,
                                     ln_sbop            in number,
                                     ln_tope            in number,
                                     lc_VerfDesembPendt out varchar2,
                                     ln_NroDesemblsPact out number,
                                     ln_DesembHechos    out number) is
  
    ln_insta      number := 0;
    ln_DesemHech1 number := 0;
    ln_DesemHech2 number := 0;
  
  begin
  
    ln_NroDesemblsPact := 0;
    ln_DesembHechos    := 0;
  
    begin
      ln_insta := fn_instancia_credito(v_Scmod  => ln_mod,
                                       v_Scsuc  => ln_suc,
                                       v_Scmda  => ln_mda,
                                       v_Scpap  => ln_pap,
                                       v_Sccta  => ln_cta,
                                       v_Scoper => ln_oper,
                                       v_Scsbop => ln_sbop,
                                       v_Sctope => ln_tope);
    end;
  
    begin
      select count(*)
        into ln_NroDesemblsPact
        from sng002 s
       where s.sng001inst = ln_insta;
    exception
      when others then
        ln_NroDesemblsPact := 0;
    end;
  
    begin
      begin
        select count(*)
          into ln_DesemHech1
          from fsd601 g
         where g.pgcod = ln_pgcod
           and g.ppmod = ln_mod
           and g.ppsuc = ln_suc
           and g.ppmda = ln_mda
           and g.pppap = ln_pap
           and g.ppcta = ln_cta
           and g.ppoper = ln_oper
           and g.ppsbop = ln_sbop
           and g.pptope = ln_tope
           and rownum = 1;
      exception
        when others then
          ln_DesemHech1 := 0;
      end;
    
      begin
        select count(*)
          into ln_DesemHech2
          from fsd602 g
         where g.pgcod = ln_pgcod
           and g.ppmod = ln_mod
           and g.ppsuc = ln_suc
           and g.ppmda = ln_mda
           and g.pppap = ln_pap
           and g.ppcta = ln_cta
           and g.ppoper = ln_oper
           and g.ppsbop = ln_sbop
           and g.pptope = ln_tope
           and g.pp1cap < 0
           and (g.d602mo, g.d602tr) in (select 30, 508 from dual);
      exception
        when others then
          ln_DesemHech2 := 0;
      end;
    
      ln_DesembHechos := nvl(ln_DesemHech1, 0) + nvl(ln_DesemHech2, 0);
    end;
  
    if ln_NroDesemblsPact > ln_DesembHechos then
      lc_VerfDesembPendt := 'P';
    else
      lc_VerfDesembPendt := 'T';
    end if;
  
  end sp_cr_VerfDesmbPendiente;
  --------------------------------------------------------------
  procedure sp_Cr_CalcParcialPend(ln_pgcod       in number,
                                  ln_mod         in number,
                                  ln_suc         in number,
                                  ln_mda         in number,
                                  ln_pap         in number,
                                  ln_cta         in number,
                                  ln_ope         in number,
                                  ln_sbop        in number,
                                  ln_tope        in number,
                                  ln_DesembHecho in number,
                                  ln_TipCamb     in number,
                                  ln_CuotPendt   out number) is
  
    ln_SaldCap      number(17, 2) := 0.00;
    ln_insta        number := 0;
    ln_SaldPend     number(17, 2) := 0.00;
    ln_CuotCaln     number := 0;
    ln_CuotPag      number := 0;
    ln_Plazo        number := 0;
    ln_tasa         number;
    ln_period       number := 0;
    ln_Cuo          number(17, 2) := 0.00;
    ln_mensual      number := 0;
    ln_MntPendiente number(17, 2) := 0.00;
  
  begin
  
    begin
      select g.scsdo * -1
        into ln_SaldCap
        from fsd011 g
       where g.pgcod = ln_pgcod
         and g.scmod = ln_mod
         and g.scsuc = ln_suc
         and g.scmda = ln_mda
         and g.scpap = ln_pap
         and g.sccta = ln_cta
         and g.scoper = ln_ope
         and g.scsbop = ln_sbop
         and g.sctope = ln_tope;
    exception
      when others then
        ln_SaldCap := 0.00;
    end;
  
    begin
      ln_insta := fn_instancia_credito(v_Scmod  => ln_mod,
                                       v_Scsuc  => ln_suc,
                                       v_Scmda  => ln_mda,
                                       v_Scpap  => ln_pap,
                                       v_Sccta  => ln_cta,
                                       v_Scoper => ln_ope,
                                       v_Scsbop => ln_sbop,
                                       v_Sctope => ln_tope);
    end;
  
    begin
      select sum(s.sng002mon)
        into ln_MntPendiente
        from sng002 s
       where s.sng001inst = ln_insta
         and s.sng002cor > ln_DesembHecho;
    exception
      when others then
        null;
    end;
  
    ln_SaldPend := nvl(ln_SaldCap, 0) + nvl(ln_MntPendiente, 0);
  
    if ln_mda = 101 then
      ln_SaldPend := ln_SaldPend * ln_TipCamb;
    end if;
  
    begin
      select A.SNG120TASA, a.sng120per
        into ln_tasa, ln_period
        from sng120 a
       where a.sng120ins = ln_insta
         and a.sng120tsk like 'APROBAC%'
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_CuotPag
        from fsd602 g
       where g.pgcod = ln_pgcod
         and g.ppmod = ln_mod
         and g.ppsuc = ln_suc
         and g.ppmda = ln_mda
         and g.pppap = ln_pap
         and g.ppcta = ln_cta
         and g.ppoper = ln_ope
         and g.ppsbop = ln_sbop
         and g.pptope = ln_tope
         and (g.d602mo, g.d602tr) not in (select 30, 508 from dual)
         and g.pp1stat = 'T'
         and g.d602co = 'S';
    exception
      when others then
        ln_CuotPag := 0;
    end;
  
    begin
      select count(*)
        into ln_CuotCaln
        from fsd601 g
       where g.pgcod = ln_pgcod
         and g.ppmod = ln_mod
         and g.ppsuc = ln_suc
         and g.ppmda = ln_mda
         and g.pppap = ln_pap
         and g.ppcta = ln_cta
         and g.ppoper = ln_ope
         and g.ppsbop = ln_sbop
         and g.pptope = ln_tope
         and g.d601co = 'S';
    exception
      when others then
        ln_CuotCaln := 0;
    end;
  
    ln_Plazo   := nvl(ln_CuotCaln, 0) - nvl(ln_CuotPag, 0);
    ln_mensual := ln_period / 30;
  
    ln_Cuo := (ln_SaldPend *
              ((power((1 + (ln_tasa / 100)), (ln_mensual / 12))) - 1)) /
              (1 - power((1 +
                         ((power((1 + (ln_tasa / 100)), (ln_Plazo / 12))) - 1)),
                         -ln_mensual));
  
    ln_CuotPendt := nvl(ln_Cuo, 0);
  
  end sp_Cr_CalcParcialPend;
  -------------------------------------------------------------
  procedure sp_capacidadlinea(ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              tipocambio in number,
                              ln_formula out number) is
  
    ln_plazo      number(17, 2);
    ln_tasa       number(14, 8);
    ln_saldo      number(17, 2) := 0.00;
    instancia     number;
    ln_instancia  number;
    ln_paralelo   number(17, 2) := 0.00;
    LN_TIPOCRED   number;
    lc_FlagSegmnt varchar2(2);
    lc_FlagGuia   varchar2(1) := 'N';
  
  begin
  
    begin
      select 'S'
        into lc_FlagGuia
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 18
         and a.tp1nro2 = ln_mod10
         and a.tp1nro3 = ln_tope10;
    exception
      when others then
        lc_FlagGuia := 'N';
      
    end;
  
    if lc_FlagGuia = 'S' then
      --Extraemos el plazo de la guia
    
      begin
        select x.xwfprcins
          into ln_instancia
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfsucursal = ln_suc10
           and x.xwfmodulo = ln_mod10
           and x.xwfmoneda = ln_mda10
           and x.xwfpapel = ln_pap10
           and x.xwfcuenta = ln_cta10
           and x.xwfoperacion = ln_oper10
           and x.xwfsubope = ln_sbop10
           and x.xwftipope = ln_tope10
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      begin
        -- Tipo de Credito en el flujo
      
        select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval, ';', ''))),
                                        '([A-Z])',
                                        ''))
          into LN_TIPOCRED
          from wfattsvalues w
         where w.wfinsprcid = ln_instancia
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
    
      begin
        select 'S'
          into lc_FlagSegmnt
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 17
           and a.tp1nro3 = LN_TIPOCRED;
      exception
        when others then
          lc_FlagSegmnt := 'N';
      end;
    
      if lc_FlagSegmnt = 'S' then
        -- mpostigoc 23/11/2017
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = ln_tope10
             and f.pp028mda = ln_mda10; -- plazo
        exception
          when others then
            null;
        end;
      
      else
        if lc_FlagSegmnt = 'N' then
        
          begin
            select a.tp1nro2
              into ln_plazo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 13
               and a.tp1corr2 = 17
               and a.tp1corr3 = 4;
          exception
            when others then
              null;
          end;
        
        end if;
      end if;
    
    else
    
      if lc_FlagGuia = 'N' then
        -- Extraemos el plazo del Preseteo
        -- mpostigoc 09/01/2018
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = ln_tope10
             and f.pp028mda = ln_mda10; -- plazo
        exception
          when others then
            null;
        end;
      
      end if;
    
    end if;
  
    begin
      select aotasa, aoimp
        into ln_tasa, ln_saldo
        from fsd010
       where pgcod = 1
         and aocta = ln_cta10
         and aooper = ln_oper10
         and aomod = ln_mod10
         and aosuc = ln_suc10
         and aomda = ln_mda10
         and aopap = ln_pap10
         and aosbop = ln_sbop10
         and aotope = ln_tope10; --tasa
    exception
      when others then
        ln_tasa  := 0.00;
        ln_saldo := 0.00;
    end;
  
    if ln_saldo = 0 then
      begin
        select x.xwfmonto1, x.xwfprcins
          into ln_saldo, instancia
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfsucursal = ln_suc10
           and x.xwfmodulo = ln_mod10
           and x.xwfmoneda = ln_mda10
           and x.xwfpapel = ln_pap10
           and x.xwfcuenta = ln_cta10
           and x.xwfoperacion = ln_oper10
           and x.xwfsubope = ln_sbop10
           and x.xwftipope = ln_tope10;
      exception
        when others then
          null;
        
      end;
    
      begin
        select x.xlltasap
          into ln_tasa
          from x054023 x
         where x.Xllpgcod = 1
           and x.Xllaomod = ln_mod10
           and x.Xllaosuc = ln_suc10
           and x.Xllaomda = ln_mda10
           and x.Xllaopap = ln_pap10
           and x.XLLAOCTA = ln_cta10
           and x.Xllaooper = ln_oper10
           and x.Xllaosbop = ln_sbop10
           and x.Xllaotop = ln_tope10;
      exception
        when others then
          NULL;
      end;
    end if;
  
    begin
      select SUM(SNGE01IMPA)
        into ln_paralelo
        from SNGE01
       WHERE SNGE01INST = instancia;
    exception
      when others then
        null;
    end;
  
    ln_saldo := nvl(ln_saldo, 0) - nvl(ln_paralelo, 0);
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    begin
      ln_formula := (ln_saldo *
                    ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                    (1 - power((1 +
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                               -ln_plazo));
    end;
  
  end sp_capacidadlinea;
  ----------------------------------------------------------------------------------
  procedure sp_CapLineaAdicional(ln_mod10        in number,
                                 ln_suc10        in number,
                                 ln_mda10        in number,
                                 ln_pap10        in number,
                                 ln_cta10        in number,
                                 ln_oper10       in number,
                                 ln_sbop10       in number,
                                 ln_tope10       in number,
                                 tipocambio      in number,
                                 ln_plazo        out number,
                                 ln_CapAdicional out number) is
  
    ln_tasa      number(14, 8);
    ln_saldo     number(17, 2) := 0.00;
    ln_instancia number := 0;
    ln_TotalAdi  number(17, 2) := 0.00;
    ln_UsadoAdi  number(17, 2) := 0.00;
  
  begin
  
    /*begin
      select f.pp028maxn
        into ln_plazo
        from fpp028 f
       where f.pp017par = 103
         and f.pp028mod = 116
         and f.pp028top = ln_tope10
         and f.pp028mda = ln_mda10; -- plazo
    exception
      when others then
        null;
    end;*/
  
    begin
      select max(aaa.pp026cod) / 30
        into ln_plazo
        from fpp026 aaa
       where aaa.pp026mod = 116
         and aaa.pp026top = ln_tope10
         and aaa.pp026mda = ln_mda10
         and aaa.pp017par = 18;
    exception
      when others then
        ln_plazo := 0;
    end;
  
    begin
      select aotasa --, aoimp
        into ln_tasa --, ln_saldo
        from fsd010
       where pgcod = 1
         and aocta = ln_cta10
         and aooper = ln_oper10
         and aomod = ln_mod10
         and aosuc = ln_suc10
         and aomda = ln_mda10
         and aopap = ln_pap10
         and aosbop = ln_sbop10
         and aotope = ln_tope10; --tasa
    exception
      when others then
        null;
    end;
  
    begin
      ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod10,
                                           v_Scsuc  => ln_suc10,
                                           v_Scmda  => ln_mda10,
                                           v_Scpap  => ln_pap10,
                                           v_Sccta  => ln_cta10,
                                           v_Scoper => ln_oper10,
                                           v_Scsbop => ln_sbop10,
                                           v_Sctope => ln_tope10);
    
    end;
  
    begin
      select SUM(SNGE01IMPA)
        into ln_TotalAdi
        from SNGE01
       WHERE SNGE01INST = ln_Instancia;
    exception
      when others then
        ln_TotalAdi := 0;
    end;
  
    if ln_mod10 = 116 then
      begin
        select f.scsdo * -1
          into ln_UsadoAdi
          from fsd011 f
         where f.pgcod = 1
           and f.scmod = ln_mod10
           and f.scsuc = ln_suc10
           and f.scmda = ln_mda10
           and f.scpap = ln_pap10
           and f.sccta = ln_cta10
           and f.scoper = ln_oper10
           and f.scsbop = ln_sbop10
           and f.sctope = ln_tope10;
      exception
        when others then
          ln_UsadoAdi := 0.00;
      end;
    end if;
  
    ln_saldo := nvl(ln_TotalAdi, 0) - nvl(ln_UsadoAdi, 0);
    ln_saldo := nvl(ln_saldo, 0);
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    begin
      ln_CapAdicional := (ln_saldo *
                         ((power((1 + (ln_tasa / 100)), (ln_plazo / 12))) - 1)) /
                         (1 - power((1 + ((power((1 + (ln_tasa / 100)),
                                                 (1 / 12))) - 1)),
                                    -ln_plazo));
    end;
    ln_CapAdicional := nvl(ln_CapAdicional, 0);
  
  end sp_CapLineaAdicional;
  ------------------------------------------------------------------------------------
  procedure sp_CapLineaAdiVuel(ln_mod10        in number,
                               ln_suc10        in number,
                               ln_mda10        in number,
                               ln_pap10        in number,
                               ln_cta10        in number,
                               ln_oper10       in number,
                               ln_sbop10       in number,
                               ln_tope10       in number,
                               tipocambio      in number,
                               ln_plazo        out number,
                               ln_CapAdicional out number) is
  
    ln_tasa         number(14, 8);
    ln_Instancia    number := 0;
    ln_MntAdicional number(17, 2) := 0.00;
    ln_TopeAdic     number := 0;
  
  begin
    ln_CapAdicional := 0;
    ln_plazo        := 0;
  
    begin
      ln_Instancia := fn_instancia_credito(v_Scmod  => ln_mod10,
                                           v_Scsuc  => ln_suc10,
                                           v_Scmda  => ln_mda10,
                                           v_Scpap  => ln_pap10,
                                           v_Sccta  => ln_cta10,
                                           v_Scoper => ln_oper10,
                                           v_Scsbop => ln_sbop10,
                                           v_Sctope => ln_tope10);
    end;
  
    if ln_Instancia > 0 then
    
      begin
        select SUM(SNGE01IMPA)
          into ln_MntAdicional
          from SNGE01
         WHERE SNGE01INST = ln_Instancia;
      exception
        when others then
          ln_MntAdicional := 0;
      end;
      ln_MntAdicional := nvl(ln_MntAdicional, 0);
    
    end if;
  
    if ln_MntAdicional > 0 then
    
      begin
        select a.tp1nro1
          into ln_TopeAdic
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 20001
           and a.tp1corr1 = 1
           and a.tp1corr2 = 1211
           and a.tp1corr3 = ln_tope10;
      exception
        when others then
          ln_TopeAdic := 0;
      end;
    
      if ln_TopeAdic > 0 then
      
        /* begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = ln_TopeAdic
             and f.pp028mda = ln_mda10; -- plazo
        exception
          when others then
            null;
        end;*/
      
        begin
          select max(aaa.pp026cod) / 30
            into ln_plazo
            from fpp026 aaa
           where aaa.pp026mod = 116
             and aaa.pp026top = ln_TopeAdic
             and aaa.pp026mda = ln_mda10
             and aaa.pp017par = 18;
        exception
          when others then
            ln_plazo := 0;
        end;
      
        begin
          select x.xlltasap
            into ln_tasa
            from x054023 x
           where x.Xllpgcod = 1
             and x.Xllaomod = ln_mod10
             and x.Xllaosuc = ln_suc10
             and x.Xllaomda = ln_mda10
             and x.Xllaopap = ln_pap10
             and x.XLLAOCTA = ln_cta10
             and x.Xllaooper = ln_oper10
             and x.Xllaosbop = ln_sbop10
             and x.Xllaotop = ln_tope10;
        exception
          when others then
            NULL;
        end;
      
        if ln_mda10 = 101 then
          ln_MntAdicional := ln_MntAdicional * tipocambio;
        end if;
      
        begin
          ln_CapAdicional := (ln_MntAdicional *
                             ((power((1 + (ln_tasa / 100)),
                                      (ln_plazo / 12))) - 1)) /
                             (1 - power((1 + ((power((1 + (ln_tasa / 100)),
                                                     (1 / 12))) - 1)),
                                        -ln_plazo));
        end;
      
      end if;
    end if;
  
    ln_CapAdicional := nvl(ln_CapAdicional, 0);
  
  end sp_CapLineaAdiVuel;
  -----------------------------------------------------------------------------------
end PQ_CR_RATIO_EVALFLUJO;
/

