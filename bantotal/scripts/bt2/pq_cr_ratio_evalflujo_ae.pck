create or replace package PQ_CR_RATIO_EVALFLUJO_AE is

  -- Author  : MPOSTIGOC
  -- Created : 23/08/2019 6:17:17 p. m.
  -- Purpose : Actualiza Monto Deuda CMAC para Actualizar Evaluacion

  procedure sp_cr_VerfEvalFlujoPanel(ln_Instancia      in number,
                                     ln_EvalFlujoPanel out varchar2);
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
  procedure sp_cr_CalcCuentasII(ln_Instancia in number,
                                lc_prgm      in varchar2,
                                lc_Usuario   in varchar2,
                                ld_FecProc   in date);
  -----------------------------------------------------------
  procedure sp_cr_CalcRatioPanel(ln_Instancia in number);
  ------------------------------------------------------------
  procedure sp_cr_fchevaluacion(ln_Instancia     in number,
                                ld_fchevaluacion out date);
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
  --------------------------------------------------------------
  procedure sp_cr_DatosPanelEFII(ln_Instancia in number,
                                 ld_FecPro    in date,
                                 lc_Usuario   in varchar2);
  ----------------------------------------------------------
  procedure sp_cr_UpdateAQPA410A(ln_Instancia in number);

end PQ_CR_RATIO_EVALFLUJO_AE;
/

create or replace package body PQ_CR_RATIO_EVALFLUJO_AE is

  --------------------------------------
  procedure sp_cr_VerfEvalFlujoPanel(ln_Instancia      in number,
                                     ln_EvalFlujoPanel out varchar2) is
    ln_reg number := 0;
  begin
  
    begin
      select count(*)
        into ln_reg
        from AQPA411A a
       where a.AQPA411Ainst = ln_Instancia;
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
  
    ln_EvalFlujoPanel varchar2(2) := 'N';
  
  begin
  
    if lc_prgm = 'HAQPA411A' then
      begin
        PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_VerfEvalFlujoPanel(ln_Instancia,
                                                          ln_EvalFlujoPanel);
      end;
    
    end if;
  
    if ln_EvalFlujoPanel = 'S' and lc_prgm = 'HAQPA411A' then
    
      PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_CalcCuentasII(ln_Instancia,
                                                   lc_prgm,
                                                   lc_Usuario,
                                                   ld_FecProc);
    
      PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_DatosPanelEFII(ln_Instancia,
                                                    ld_FecProc,
                                                    lc_Usuario);
      PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_CalcRatioPanel(ln_Instancia);
    
    end if;
  
    ln_capcmac    := nvl(ln_capcmac, 0);
    ln_capifis    := nvl(ln_capifis, 0);
    ln_capcontgnt := nvl(ln_capcontgnt, 0);
    ln_capptncl   := nvl(ln_capptncl, 0);
    ln_ResulNeto  := nvl(ln_ResulNeto, 0);
    ln_Ratio      := nvl(ln_Ratio, 0);
  
  end sp_cr_InicioRatio;
  -----------------------------------------------------------------------
  procedure sp_cr_CalcCuentasII(ln_Instancia in number,
                                lc_prgm      in varchar2,
                                lc_Usuario   in varchar2,
                                ld_FecProc   in date) is
  
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
  
    if lc_prgm = 'HAQPA411A' then
      lc_flgprg := 'S';
    
      begin
        delete from aqpa352a a where a.aqpa352ainst = ln_Instancia;
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
      PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_fchevaluacion(ln_Instancia,
                                                   ld_fcheval);
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
          
            if Tiene_Uso = 'S' then
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
            
              PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogCuentas(ld_FecProc,
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
                PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogCuentas(ld_FecProc,
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
          
            PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogCuentas(ld_FecProc,
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
             and f.d601co = 'X'
             and f.ppfpag >= ld_MinFchCred;
        exception
          when others then
            ln_TieneCalndario := 0;
        end;
      
        if ln_TieneCalndario > 0 then
        
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
        
          PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogCuentas(ld_FecProc,
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
        
          if Tiene_Uso = 'S' then
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
          
            PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogCuentas(ld_FecProc,
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
            
              PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogCuentas(ld_FecProc,
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
  
  end sp_cr_CalcCuentasII;

  -------------------------------------------------------------------------
  procedure sp_cr_CalcRatioPanel(ln_Instancia in number) is
  
    cursor Lista_OtrosCred(lc_estado varchar2) is
    -- Cursor Creditos que no son Linea ni Desembolso Parcial
      select a.aqpa352apgcod   ln_pgcod,
             a.aqpa352amod     ln_mod,
             a.aqpa352asuc     ln_suc,
             a.aqpa352amda     ln_mda,
             a.aqpa352apap     ln_pap,
             a.aqpa352acta     ln_cta,
             a.aqpa352aope     ln_ope,
             a.aqpa352asbop    ln_sbop,
             a.aqpa352atope    ln_tope,
             a.aqpa352aindcred lc_IndCred
        from aqpa352a a
       where a.aqpa352ainst = ln_Instancia
         and a.aqpa352aest = lc_estado
         and a.aqpa352amod <> 117 --Excluye Lineas
         and a.aqpa352aori <> 7 --Excluye desembolsos parciales
         and a.aqpa352aindcred in ('CredVigent', 'CredVencid', 'CredVuelo');
  
    cursor linea_vuelo(lc_estado varchar2) is
      select a.aqpa352apgcod   ln_pgcod,
             a.aqpa352amod     ln_mod,
             a.aqpa352asuc     ln_suc,
             a.aqpa352amda     ln_mda,
             a.aqpa352apap     ln_pap,
             a.aqpa352acta     ln_cta,
             a.aqpa352aope     ln_ope,
             a.aqpa352asbop    ln_sbop,
             a.aqpa352atope    ln_tope,
             a.aqpa352aindcred lc_IndCred
        from aqpa352a a
       where a.aqpa352ainst = ln_Instancia
         and a.aqpa352aest = lc_estado
         and a.aqpa352aindcred = 'CredVuelo'
         and a.aqpa352amod = 117;
  
    cursor linea_vigente(lc_estado varchar2) is
    -- Linea Vigente sin uso
      select a.aqpa352apgcod   ln_pgcod,
             a.aqpa352amod     ln_mod,
             a.aqpa352asuc     ln_suc,
             a.aqpa352amda     ln_mda,
             a.aqpa352apap     ln_pap,
             a.aqpa352acta     ln_cta,
             a.aqpa352aope     ln_ope,
             a.aqpa352asbop    ln_sbop,
             a.aqpa352atope    ln_tope,
             a.aqpa352aindcred lc_IndCred
        from aqpa352a a
       where a.aqpa352ainst = ln_Instancia
         and a.aqpa352aest = lc_estado
         and a.aqpa352aindcred = 'CredVigent'
         and a.aqpa352amod = 117;
  
    cursor linea_vencida(lc_estado varchar2) is
      select a.aqpa352apgcod   ln_pgcod,
             a.aqpa352amod     ln_mod,
             a.aqpa352asuc     ln_suc,
             a.aqpa352amda     ln_mda,
             a.aqpa352apap     ln_pap,
             a.aqpa352acta     ln_cta,
             a.aqpa352aope     ln_ope,
             a.aqpa352asbop    ln_sbop,
             a.aqpa352atope    ln_tope,
             a.aqpa352aindcred lc_IndCred
        from aqpa352a a
       where a.aqpa352ainst = ln_Instancia
         and a.aqpa352aest = lc_estado
         and a.aqpa352aindcred = 'LineaVencd';
  
    cursor credito_parcial(lc_estado varchar2) is
      select a.aqpa352apgcod   ln_pgcod,
             a.aqpa352amod     ln_mod,
             a.aqpa352asuc     ln_suc,
             a.aqpa352amda     ln_mda,
             a.aqpa352apap     ln_pap,
             a.aqpa352acta     ln_cta,
             a.aqpa352aope     ln_ope,
             a.aqpa352asbop    ln_sbop,
             a.aqpa352atope    ln_tope,
             a.aqpa352aindcred lc_IndCred
        from aqpa352a a
       where a.aqpa352ainst = ln_Instancia
         and a.aqpa352aest = lc_estado
         and a.aqpa352aori = 7
         and a.aqpa352aindcred in ('CredVigent', 'CredVencid');
  
    cursor Lista_ParcVuelo(lc_estado varchar2) is
      select a.aqpa352apgcod   ln_pgcod,
             a.aqpa352amod     ln_mod,
             a.aqpa352asuc     ln_suc,
             a.aqpa352amda     ln_mda,
             a.aqpa352apap     ln_pap,
             a.aqpa352acta     ln_cta,
             a.aqpa352aope     ln_ope,
             a.aqpa352asbop    ln_sbop,
             a.aqpa352atope    ln_tope,
             a.aqpa352aindcred lc_IndCred
        from aqpa352a a
       where a.aqpa352ainst = ln_Instancia
         and a.aqpa352aest = lc_estado
         and a.aqpa352aori = 7 -- Desembolsos parciales
         and a.aqpa352aindcred = 'CredVuelo';
  
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
    NroCreOtorg        number;
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
      select min(a.AQPA411Afeca)
        into ld_ffin
        from AQPA411A a
       where a.AQPA411Ainst = ln_Instancia;
    end;
  
    begin
      select max(a.AQPA411Afeca)
        into ld_MaxFchCalnd
        from AQPA411A a
       where a.AQPA411Ainst = ln_Instancia;
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
  
    for oc in Lista_OtrosCred(lc_estado) loop
    
      begin
        select min(a.AQPA411Afeca)
          into ld_ffin
          from AQPA411A a
         where a.AQPA411Ainst = ln_Instancia;
      end;
      begin
        select max(a.AQPA411Afeca)
          into ld_MaxFchCalnd
          from AQPA411A a
         where a.AQPA411Ainst = ln_Instancia;
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
          PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
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
              select a.AQPA356Acapcaja
                into ln_mntacumld
                from AQPA356A a
               where a.AQPA356Ainst = ln_Instancia
                 and a.AQPA356Acorr = NroCreOtorg
                 and a.AQPA356Aest = 'H';
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
              update AQPA356A a
                 set a.AQPA356Acapcaja = ln_newmnt
               where a.AQPA356Ainst = ln_Instancia
                 and a.AQPA356Aest = 'H'
                 AND a.AQPA356Acorr = NroCreOtorg;
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
                   and f.d601co = 'X';
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
                select a.AQPA356Acapcaja
                  into ln_mntacumld
                  from AQPA356A a
                 where a.AQPA356Ainst = ln_Instancia
                   and a.AQPA356Afecal = ld_UltDia
                   and a.AQPA356Aest = 'H';
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
                update AQPA356A a
                   set a.AQPA356Acapcaja = ln_newmnt
                 where a.AQPA356Ainst = ln_Instancia
                   and a.AQPA356Aest = 'H'
                   and a.AQPA356Afecal = ld_UltDia;
              end;
            
            end if;
          end if;
        
        else
          if lc_fgAdic = 'S' then
          
            ln_newmnt := 0;
          
            PQ_CR_RATIO_EVALFLUJO.sp_CapLineaAdicional(ln_mod10        => oc.ln_mod,
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
              select a.AQPA356Acapcaja
                into ln_mntacumld
                from AQPA356A a
               where a.AQPA356Ainst = ln_Instancia
                 and a.AQPA356Acorr = ln_MaxPlazAdi
                 and a.AQPA356Aest = 'H';
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
              update AQPA356A a
                 set a.AQPA356Acapcaja = ln_newmnt
               where a.AQPA356Ainst = ln_Instancia
                 and a.AQPA356Aest = 'H'
                 AND a.AQPA356Acorr = ln_MaxPlazAdi;
            end;
          end if;
        end if;
      end if;
    
    end loop;
  
    for lv in linea_vuelo(lc_estado) loop
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
        PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                       ln_modulo      => Lv.LN_MOD,
                                                       ln_mntcuota    => ln_MntCuota,
                                                       ld_fchPanel    => ld_ffin,
                                                       ln_NroCuOtorg  => NroCreOtorg,
                                                       ln_NroCuotCred => ln_NroCuot,
                                                       lc_Indicador   => lv.lc_indcred);
      
      end;
    
      PQ_CR_RATIO_EVALFLUJO.sp_CapLineaAdiVuel(ln_mod10        => lv.ln_mod,
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
          select a.AQPA356Acapcaja
            into ln_mntacumld
            from AQPA356A a
           where a.AQPA356Ainst = ln_Instancia
             and a.AQPA356Acorr = ln_MaxPlazAdi
             and a.AQPA356Aest = 'H';
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
          update AQPA356A a
             set a.AQPA356Acapcaja = ln_newmnt
           where a.AQPA356Ainst = ln_Instancia
             and a.AQPA356Aest = 'H'
             AND a.AQPA356Acorr = ln_MaxPlazAdi;
        end;
      
      end if;
    end loop;
  
    for lg in linea_vigente(lc_estado) loop
    
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
      
        PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                       ln_modulo      => Lg.LN_MOD,
                                                       ln_mntcuota    => ln_MntCuota,
                                                       ld_fchPanel    => ld_ffin,
                                                       ln_NroCuOtorg  => NroCreOtorg,
                                                       ln_NroCuotCred => ln_NroCuot,
                                                       lc_Indicador   => lg.lc_indcred);
      else
        if LC_VerfAdi = 'S' then
        
          PQ_CR_RATIO_EVALFLUJO.sp_CapLineaAdicional(ln_mod10        => lg.ln_mod,
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
              select a.AQPA356Acapcaja
                into ln_mntacumld
                from AQPA356A a
               where a.AQPA356Ainst = ln_Instancia
                 and a.AQPA356Acorr = ln_MaxPlazAdi
                 and a.AQPA356Aest = 'H';
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
              update AQPA356A a
                 set a.AQPA356Acapcaja = ln_newmnt
               where a.AQPA356Ainst = ln_Instancia
                 and a.AQPA356Aest = 'H'
                 AND a.AQPA356Acorr = ln_MaxPlazAdi;
            end;
          
          end if;
        end if;
      end if;
    
    end loop;
  
    for lc in linea_vencida(lc_estado) loop
    
      begin
        select min(a.AQPA411Afeca)
          into ld_ffin
          from AQPA411A a
         where a.AQPA411Ainst = ln_Instancia;
      end;
      begin
        select max(a.AQPA411Afeca)
          into ld_MaxFchCalnd
          from AQPA411A a
         where a.AQPA411Ainst = ln_Instancia;
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
          PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
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
  
    for cp in credito_parcial(lc_estado) loop
      PQ_CR_RATIO_EVALFLUJO.sp_cr_VerfDesmbPendiente(cp.ln_pgcod,
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
      
        PQ_CR_RATIO_EVALFLUJO.sp_Cr_CalcParcialPend(cp.ln_pgcod,
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
          select min(a.AQPA411Afeca)
            into ld_ffin
            from AQPA411A a
           where a.AQPA411Ainst = ln_Instancia;
        end;
        begin
          select max(a.AQPA411Afeca)
            into ld_MaxFchCalnd
            from AQPA411A a
           where a.AQPA411Ainst = ln_Instancia;
        end;
      
        begin
          ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
        end;
      
        while ld_ffin <= ld_MaxFchCalnd loop
        
          ln_MntCuoMesAux := 0;
          ln_MntCuoMes    := 0;
          ln_ratiomens    := 0;
        
          begin
            PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                           ln_modulo      => cp.LN_MOD,
                                                           ln_mntcuota    => ln_CuotPendt,
                                                           ld_fchPanel    => ld_ffin,
                                                           ln_NroCuOtorg  => NroCreOtorg,
                                                           ln_NroCuotCred => ln_NroCuot,
                                                           lc_Indicador   => cp.lc_indcred);
          
          end;
        
          ld_fini := add_months(ld_fini, +1);
          ld_ffin := add_months(ld_ffin, +1);
        end loop;
      
      else
        if lc_VerfDesembPendt = 'T' then
          -- Con Desembolso Total  
          begin
            select min(a.AQPA411Afeca)
              into ld_ffin
              from AQPA411A a
             where a.AQPA411Ainst = ln_Instancia;
          end;
          begin
            select max(a.AQPA411Afeca)
              into ld_MaxFchCalnd
              from AQPA411A a
             where a.AQPA411Ainst = ln_Instancia;
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
              PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
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
  
    for pv in Lista_ParcVuelo(lc_estado) loop
      begin
        select min(a.AQPA411Afeca)
          into ld_ffin
          from AQPA411A a
         where a.AQPA411Ainst = ln_Instancia;
      end;
      begin
        select max(a.AQPA411Afeca)
          into ld_MaxFchCalnd
          from AQPA411A a
         where a.AQPA411Ainst = ln_Instancia;
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
          PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
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
  
    PQ_CR_RATIO_EVALFLUJO_AE.sp_cr_Updateaqpa410A(ln_Instancia);
  
  end sp_cr_CalcRatioPanel;
  -------------------------------------------------------------------------------
  procedure sp_cr_fchevaluacion(ln_Instancia     in number,
                                ld_fchevaluacion out date) is
  
    ln_pais number := 0;
    ln_tdoc number := 0;
    ln_ndoc varchar2(12);
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, ln_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        ln_pais := 0;
        ln_tdoc := 0;
        ln_ndoc := '00000000000';
    end;
  
    if ln_pais > 0 then
      begin
        select max(j.jaqz515fee)
          into ld_fchevaluacion
          from jaqz515 j
         where j.jaqz515pai = ln_pais
           and j.jaqz515tdo = ln_tdoc
           and j.jaqz515ndo = ln_ndoc;
      exception
        when others then
          null;
      end;
    end if;
  
  end sp_cr_fchevaluacion;
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
          select a.AQPA356Acapcaja
            into ln_mntacumld
            from AQPA356A a
           where a.AQPA356Ainst = ln_Instancia
             and a.AQPA356Acorr = ln_NroCuotCred + 1
             and a.AQPA356Aest = 'H';
        exception
          when others then
            ln_mntacumld := 0.00;
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA356A a
             set a.AQPA356Acapcaja = ln_newmnt
           where a.AQPA356Ainst = ln_Instancia
             and a.AQPA356Aest = 'H'
             AND a.AQPA356Acorr = ln_NroCuotCred + 1;
        end;
      
      else
        if lc_Indicador = 'CredVigent' then
          -- Si la linea es vigente, el monto calculado se coloca en la ultima cuota
          -- del credito a otorgar
          begin
            select a.AQPA356Acapcaja
              into ln_mntacumld
              from AQPA356A a
             where a.AQPA356Ainst = ln_Instancia
               and a.AQPA356Acorr = ln_NroCuOtorg + 1
               and a.AQPA356Aest = 'H';
          exception
            when others then
              ln_mntacumld := 0.00;
          end;
        
          begin
            ln_newmnt := ln_mntacumld + ln_mntcuota;
          end;
        
          begin
            update AQPA356A a
               set a.AQPA356Acapcaja = ln_newmnt
             where a.AQPA356Ainst = ln_Instancia
               and a.AQPA356Aest = 'H'
               AND a.AQPA356Acorr = ln_NroCuOtorg + 1;
          end;
        end if;
      end if;
    
    else
      if ln_modulo <> 117 then
        begin
          select a.AQPA356Acapcaja
            into ln_mntacumld
            from AQPA356A a
           where a.AQPA356Ainst = ln_Instancia
             and a.AQPA356Afecal = ld_fchPanel
             and a.AQPA356Aest = 'H';
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA356A a
             set a.AQPA356Acapcaja = ln_newmnt
           where a.AQPA356Ainst = ln_Instancia
             and a.AQPA356Aest = 'H'
             AND a.AQPA356Afecal = ld_fchPanel;
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
    
      select max(j.aqpa352acorr)
        into ln_corr
        from aqpa352a j
       where j.aqpa352afec = ld_fec
         and j.aqpa352ainst = ln_inst;
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
      insert into aqpa352a
        (aqpa352acorr,
         aqpa352afec,
         aqpa352ahora,
         aqpa352auser,
         aqpa352apais,
         aqpa352atdoc,
         aqpa352andoc,
         aqpa352atcamb,
         aqpa352ainst,
         aqpa352aFEVAL,
         aqpa352aFICAL,
         aqpa352apgcod,
         aqpa352amod,
         aqpa352asuc,
         aqpa352amda,
         aqpa352apap,
         aqpa352acta,
         aqpa352aope,
         aqpa352asbop,
         aqpa352atope,
         aqpa352aori,
         aqpa352ancuo,
         aqpa352aest,
         aqpa352atarea,
         aqpa352aIndCred,
         aqpa352aNAUX1,
         aqpa352aNAUX2)
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
      commit;
    
    end;
  
  end sp_cr_LogCuentas;
  -------------------------------------------------------------
  procedure sp_cr_DatosPanelEFII(ln_Instancia in number,
                                 ld_FecPro    in date,
                                 lc_Usuario   in varchar2) is
  
    cursor Cuotas_EvalFlujo is
      select *
        from AQPA411A a
       where a.AQPA411Ainst = ln_Instancia
       order by a.AQPA411Afeca;
  
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
      delete AQPA356A a where a.AQPA356Ainst = ln_Instancia;
    end;
  
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
  
    for c in Cuotas_EvalFlujo loop
    
      begin
        select to_char(c.AQPA411Afeca, 'YYYYMM')
          into lc_aniomescuo
          from dual;
      end;
    
      begin
      
        insert into AQPA356A
          (AQPA356Acorr,
           AQPA356Afec,
           AQPA356Ahora,
           AQPA356Auser,
           AQPA356Apais,
           AQPA356Atdoc,
           AQPA356Andoc,
           AQPA356Atcamb,
           AQPA356Ainst,
           AQPA356Afeval,
           AQPA356Afecal,
           AQPA356Amesanio,
           AQPA356Acapcaja,
           AQPA356Aest)
        
        values
          (c.AQPA411Acorr,
           ld_FecPro,
           lc_hora,
           lc_Usuario,
           ln_Pepais,
           ln_Petdoc,
           ln_Pendoc,
           ln_TipCamb,
           ln_Instancia,
           c.AQPA411Afece,
           c.AQPA411Afeca,
           lc_aniomescuo,
           0.00,
           'H');
      
        COMMIT;
      
      end;
    
    end loop;
  
  end sp_cr_DatosPanelEFII;
  -----------------------------------------------------------
  procedure sp_cr_UpdateAQPA410A(ln_Instancia in number) is
  
    cursor up_cuotacmac is
      select b.AQPA356Afecal fch_calendario, b.AQPA356Acapcaja ln_cuocmac
        from AQPA356A B
       WHERE B.AQPA356AINST = ln_Instancia
         and b.AQPA356Aest = 'H';
  
  begin
    for u in up_cuotacmac loop
      begin
        update aqpa410A a
           set a.aqpa410Acuoc = u.ln_cuocmac
         where a.aqpa410Ainst = ln_Instancia
           and a.aqpa410Aesta = 'S'
           and a.aqpa410Afcon = u.fch_calendario;
      end;
      commit;
    end loop;
  end;
  -----------------------------------------------------------------------------------
end PQ_CR_RATIO_EVALFLUJO_AE;
/

