create or replace package PQ_CR_RTES_DISPMOVIL is

  -- Author  : MPOSTIGOC
  -- Created : 13/01/2020 6:35:40 p. m.
  -- Purpose : 

  procedure sp_cr_VerfEvalFlujo(ln_mod117    in number,
                                ln_suc117    in number,
                                ln_mda117    in number,
                                ln_pap117    in number,
                                ln_cta117    in number,
                                ln_oper117   in number,
                                ln_sbop117   in number,
                                ln_tope117   in number,
                                ln_EvalFlujo out varchar2);
  ----------------------------------------------------------
  procedure sp_cr_SegmntLineaMovil(ln_mod117      in number,
                                   ln_suc117      in number,
                                   ln_mda117      in number,
                                   ln_pap117      in number,
                                   ln_cta117      in number,
                                   ln_oper117     in number,
                                   ln_sbop117     in number,
                                   ln_tope117     in number,
                                   lc_CambSegmnto out varchar2);
  ------------------------------------------------------------
  procedure sp_cr_VerfNroCuotMax(ln_mod117  in number,
                                 ln_suc117  in number,
                                 ln_mda117  in number,
                                 ln_pap117  in number,
                                 ln_cta117  in number,
                                 ln_oper117 in number,
                                 ln_sbop117 in number,
                                 ln_tope117 in number,
                                 --ln_plazoIng  in number,
                                 ln_PlazoSist out number /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 lc_pcancel   out varchar2*/);
  ------------------------------------------------------------------
  procedure sp_cr_ControlAntg(ln_mod117  in number,
                              ln_suc117  in number,
                              ln_mda117  in number,
                              ln_pap117  in number,
                              ln_cta117  in number,
                              ln_oper117 in number,
                              ln_sbop117 in number,
                              ln_tope117 in number,
                              -- ln_plazoIng  in number,
                              ln_PlazoSist out number /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                lc_pcancel   out varchar2*/);
  ----------------------------------------------------------------
  procedure sp_cr_ControlNuevo(ln_mod117  in number,
                               ln_mda117  in number,
                               ln_tope117 in number,
                               --ln_plazoIng  in number,
                               ln_PlazoSist out number /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                lc_pcancel   out varchar2*/);
  --------------------------------------------------------------------
  procedure sp_cr_verfvinclinea(ln_pgcod117     in number,
                                ln_modulo117    in number,
                                ln_sucursal117  in number,
                                ln_moneda117    in number,
                                ln_papel117     in number,
                                ln_cuenta117    in number,
                                ln_operacion117 in number,
                                ln_suboper117   in number,
                                ln_tipoper117   in number,
                                ln_InsEliminada out number);
  --------------------------------------------------------------------
  Procedure Sp_baja_solicitud(ln_ins in number);
  -------------------------------------------------------------------
  procedure sp_cr_ActualizaLogs(ln_TPGCODA in number,
                                ln_ITSUCA  in number,
                                ln_ITMODA  in number,
                                ln_ITTRANA in number,
                                ln_ITNRELA in number,
                                ln_ITORDA  in number,
                                ln_ITSBORA in number,
                                ln_TPGCODF in number,
                                ln_ITSUCF  in number,
                                ln_ITMODF  in number,
                                ln_ITTRANF in number,
                                ln_ITNRELF in number,
                                ln_ITORDF  in number,
                                ln_ITSBORF in number,
                                ld_fecpro  in date);
  -------------------------------------------------------------------
  procedure sp_cr_UltFchPagada(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cta       in number,
                               ln_oper      in number,
                               ln_sbop      in number,
                               ln_tope      in number,
                               ld_UltFch    out date,
                               ld_FchCuoImp out date);

end PQ_CR_RTES_DISPMOVIL;
/

create or replace package body PQ_CR_RTES_DISPMOVIL is

  procedure sp_cr_VerfEvalFlujo(ln_mod117    in number,
                                ln_suc117    in number,
                                ln_mda117    in number,
                                ln_pap117    in number,
                                ln_cta117    in number,
                                ln_oper117   in number,
                                ln_sbop117   in number,
                                ln_tope117   in number,
                                ln_EvalFlujo out varchar2) is
  
    cursor lista_creditos(ln_pais number, ln_tdoc number, lc_ndoc varchar2) is
      select x.xwfempresa   ln_pgcod,
             x.xwfsucursal  ln_suc,
             x.xwfmodulo    ln_mod,
             x.xwfmoneda    ln_mda,
             x.xwfpapel     ln_pap,
             x.xwfcuenta    ln_cta,
             x.xwfoperacion ln_ope,
             x.xwfsubope    ln_sbop,
             x.xwftipope    ln_tope,
             x.xwfprcins    ln_InstAux
        from xwf700 x, fsd010 f, sng021 d
       where x.xwfprcins in (select s.sng001inst
                               from sng001 s
                              where s.sng001pais = ln_pais
                                and s.sng001tdoc = ln_tdoc
                                and s.sng001ndoc = lc_ndoc)
         and x.xwfempresa = f.pgcod
         and x.xwfsucursal = f.aosuc
         and x.xwfmodulo = f.aomod
         and x.xwfmoneda = f.aomda
         and x.xwfpapel = f.aopap
         and x.xwfcuenta = f.aocta
         and x.xwfoperacion = f.aooper
         and x.xwfsubope = f.aosbop
         and x.xwftipope = f.aotope
         and x.xwfcar3 = '1'
         and d.sng021sol = x.xwfprcins
         and d.sng021tmod = 13
       order by x.xwfprcins;
  
    ln_pais         number := 0;
    ln_tdoc         number := 0;
    lc_ndoc         varchar2(12);
    ld_MaxFchEva515 date;
    ln_EvalAux      number := 0;
    ln_Eval         number := 0;
    ln_InstaEva     number := 0;
    ln_Ins515       number := 0;
    ld_fcheval120   date;
    ln_reg          number := 0;
    ln_regOtorg     number := 0;
    ln_InstLinea    number;
    --ld_fchevaluacion date;
    ln_InstEval number;
  
  begin
  
    ln_EvalFlujo := 'N';
  
    --***** 1RA PARTE
    begin
      ln_InstLinea := fn_instancia_credito(v_Scmod  => ln_mod117,
                                           v_Scsuc  => ln_suc117,
                                           v_Scmda  => ln_mda117,
                                           v_Scpap  => ln_pap117,
                                           v_Sccta  => ln_cta117,
                                           v_Scoper => ln_oper117,
                                           v_Scsbop => ln_sbop117,
                                           v_Sctope => ln_tope117);
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_InstLinea;
    exception
      when others then
        null;
    end;
  
    for l in lista_creditos(ln_pais, ln_tdoc, lc_ndoc) loop
    
      begin
        select d.sng021eval
          into ln_EvalAux
          from sng021 d
         where d.sng021sol = l.ln_instaux;
      exception
        when others then
          ln_EvalAux := 0;
        
      end;
    
      if ln_Eval < ln_EvalAux then
        ln_Eval     := ln_EvalAux;
        ln_InstaEva := l.ln_instaux;
      end if;
    
    end loop;
  
    begin
      select SNG120FPag
        into ld_fcheval120
        from sng120 s
       where s.sng120ins = ln_InstaEva
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;
  
    begin
      begin
        select max(j.jaqz515fee)
          into ld_MaxFchEva515
          from jaqz515 j
         where j.jaqz515pai = ln_pais
           and j.jaqz515tdo = ln_tdoc
           and trim(j.jaqz515ndo) = lc_ndoc;
      exception
        when others then
          null;
      end;
    
      begin
        select max(j.jaqz515ins)
          into ln_Ins515
          from jaqz515 j
         where j.jaqz515pai = ln_pais
           and j.jaqz515tdo = ln_tdoc
           and trim(j.jaqz515ndo) = lc_ndoc
           and j.jaqz515fee = ld_MaxFchEva515;
      exception
        when others then
          null;
      end;
    
    end;
  
    if ld_fcheval120 is not null and ld_MaxFchEva515 is not null then
    
      if ld_fcheval120 >= ld_MaxFchEva515 then
        --ld_fchevaluacion := ld_fcheval120;
        ln_InstEval := ln_InstaEva;
      else
        if ld_fcheval120 < ld_MaxFchEva515 then
          --ld_fchevaluacion := ld_MaxFchEva515;
          ln_InstEval := ln_Ins515;
        end if;
      end if;
    
    else
      if ld_fcheval120 is null and ld_MaxFchEva515 is not null then
        --ld_fchevaluacion := ld_MaxFchEva515;
        ln_InstEval := ln_Ins515;
      else
        if ld_fcheval120 is not null and ld_MaxFchEva515 is null then
          -- ld_fchevaluacion := ld_fcheval120;
          ln_InstEval := ln_InstaEva;
        end if;
      end if;
    end if;
  
    ln_InstEval := nvl(ln_InstEval, 0);
  
    --********** 2DA PARTE 
  
    if ln_InstEval > 0 then
      begin
        select count(*)
          into ln_regOtorg
          from aqpa410 a
         where a.aqpa410inst = ln_InstEval
           and a.aqpa410esta = 'S';
      exception
        when others then
          ln_regOtorg := 0;
      end;
    
      begin
        select count(*)
          into ln_reg
          from aqpa410a a
         where a.aqpa410ainst = ln_InstEval
           and a.aqpa410aesta = 'S';
      exception
        when others then
          ln_reg := 0;
      end;
    
      if ln_reg > 0 or ln_regOtorg > 0 then
        ln_EvalFlujo := 'S';
      elsif ln_reg <= 0 then
        ln_EvalFlujo := 'N';
      end if;
    
    end if;
  end;
  ----------------------------------------------------------------
  procedure sp_cr_SegmntLineaMovil(ln_mod117      in number,
                                   ln_suc117      in number,
                                   ln_mda117      in number,
                                   ln_pap117      in number,
                                   ln_cta117      in number,
                                   ln_oper117     in number,
                                   ln_sbop117     in number,
                                   ln_tope117     in number,
                                   lc_CambSegmnto out varchar2) is
  
    ln_Instancia         number;
    lc_SegmntoEvaluacion number;
    lc_SegmntoActual     number;
  
  begin
  
    lc_CambSegmnto := 'N';
    begin
      ln_Instancia := fn_instancia_credito(v_Scmod  => ln_mod117,
                                           v_Scsuc  => ln_suc117,
                                           v_Scmda  => ln_mda117,
                                           v_Scpap  => ln_pap117,
                                           v_Sccta  => ln_cta117,
                                           v_Scoper => ln_oper117,
                                           v_Scsbop => ln_sbop117,
                                           v_Sctope => ln_tope117);
    end;
  
    -- Segmento de la etapa de Evaluacion / Propuesta
    PQ_CR_RTE_VERIFICASEGMENTO.sp_cr_VerifSegmEvaluacion(ln_Instancia,
                                                         lc_SegmntoEvaluacion);
  
    -- Segmento Actual
    PQ_CR_RTE_VERIFICASEGMENTO.sp_cr_SegmntoActual(ln_Instancia,
                                                   lc_SegmntoActual);
  
    lc_SegmntoEvaluacion := nvl(lc_SegmntoEvaluacion, 999);
    lc_SegmntoActual     := nvl(lc_SegmntoActual, 999);
  
    if lc_SegmntoActual <> lc_SegmntoEvaluacion then
      lc_CambSegmnto := 'S';
    end if;
  
    if lc_SegmntoEvaluacion = 999 then
      lc_CambSegmnto := 'S';
    end if;
  
  end sp_Cr_segmntLineaMovil;
  ------------------------------------------------------------------------------  
  procedure sp_cr_VerfNroCuotMax(ln_mod117  in number,
                                 ln_suc117  in number,
                                 ln_mda117  in number,
                                 ln_pap117  in number,
                                 ln_cta117  in number,
                                 ln_oper117 in number,
                                 ln_sbop117 in number,
                                 ln_tope117 in number,
                                 --ln_plazoIng  in number,
                                 ln_PlazoSist out number /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              lc_pcancel   out varchar2*/) is
  
    ld_FchNuevPlazoLine date;
    ld_FchDesembol      date;
  
  begin
  
    if ln_cta117 is not null then
      begin
        -- Fecha de Inicio del nuevo control de Plazo
        select to_date(a.tp1nro1 || '/' || a.tp1nro2 || '/' || a.tp1nro3,
                       'DD/MM/YYYY')
          into ld_FchNuevPlazoLine
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 22
           and a.tp1corr3 = 1;
      end;
    
      begin
        -- Fecha de Desembolso
        select f.aofval
          into ld_FchDesembol
          from fsd010 f
         where f.pgcod = 1 --ln_pgcod117
           and f.aomod = ln_mod117
           and f.aosuc = ln_suc117
           and f.aomda = ln_mda117
           and f.aopap = ln_pap117
           and f.aocta = ln_cta117
           and f.aooper = ln_oper117
           and f.aosbop = ln_sbop117
           and f.aotope = ln_tope117;
      end;
    
      if ld_FchDesembol < ld_FchNuevPlazoLine then
        pq_cr_rtes_dispmovil.sp_cr_ControlAntg(ln_mod117,
                                               ln_suc117,
                                               ln_mda117,
                                               ln_pap117,
                                               ln_cta117,
                                               ln_oper117,
                                               ln_sbop117,
                                               ln_tope117,
                                               --ln_plazoIng,
                                               ln_PlazoSist /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  lc_pcancel*/);
      
      else
        if ld_FchDesembol >= ld_FchNuevPlazoLine then
          pq_cr_rtes_dispmovil.sp_cr_ControlNuevo(ln_mod117,
                                                  ln_mda117,
                                                  ln_tope117,
                                                  -- ln_plazoIng,
                                                  ln_PlazoSist /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            lc_pcancel*/);
        end if;
      end if;
    
      /*else
      lc_pcancel := 'N';*/
    end if;
  
  end sp_cr_VerfNroCuotMax;
  ----------------------------------------------------
  procedure sp_cr_ControlAntg(ln_mod117  in number,
                              ln_suc117  in number,
                              ln_mda117  in number,
                              ln_pap117  in number,
                              ln_cta117  in number,
                              ln_oper117 in number,
                              ln_sbop117 in number,
                              ln_tope117 in number,
                              -- ln_plazoIng  in number,
                              ln_PlazoSist out number) is
  
    ln_instancia117    number;
    lc_FlagGuia        varchar2(1);
    lc_FlagGuiaAdic    varchar2(1) := 'N';
    lc_FlagGuiaAdicPrf varchar2(1) := 'N';
  
  begin
  
    begin
      -- Verifica si es una adicional   
      select 'S'
        into lc_FlagGuiaAdic
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 19
         and a.tp1nro2 = 117
         and a.tp1nro3 = ln_tope117;
    exception
      when others then
        lc_FlagGuiaAdic := 'N';
    end;
  
    if lc_FlagGuiaAdic = 'S' then
    
      begin
        -- Verifica si es una adicional Preferencial
        select 'S'
          into lc_FlagGuiaAdicPrf
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 20
           and a.tp1nro2 = 117
           and a.tp1nro3 = ln_tope117;
      exception
        when others then
          lc_FlagGuiaAdicPrf := 'N';
      end;
    
      if lc_FlagGuiaAdicPrf = 'S' then
      
        begin
        
          select a.tp1nro3
            into ln_PlazoSist
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 13
             and a.tp1corr2 = 21
             and a.tp1corr3 = 2;
        end;
      
      else
        if lc_FlagGuiaAdicPrf = 'N' then
          begin
          
            select a.tp1nro3
              into ln_PlazoSist
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 13
               and a.tp1corr2 = 21
               and a.tp1corr3 = 1;
          end;
        
        end if;
      end if;
    
    else
      if lc_FlagGuiaAdic = 'N' then
      
        begin
          select 'S'
            into lc_FlagGuia
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 13
             and a.tp1corr2 = 18
             and a.tp1nro2 = ln_mod117
             and a.tp1nro3 = ln_tope117;
        exception
          when others then
            lc_FlagGuia := 'N';
          
        end;
      
        if lc_FlagGuia = 'S' then
        
          begin
          
            ln_instancia117 := fn_instancia_credito(v_Scmod  => ln_mod117,
                                                    v_Scsuc  => ln_suc117,
                                                    v_Scmda  => ln_mda117,
                                                    v_Scpap  => ln_pap117,
                                                    v_Sccta  => ln_cta117,
                                                    v_Scoper => ln_oper117,
                                                    v_Scsbop => ln_sbop117,
                                                    v_Sctope => ln_tope117);
          
            pq_cr_rtelineasplazo.sp_cr_VerTipoCred(ln_instancia117,
                                                   ln_PlazoSist);
          end;
        
        else
        
          if lc_FlagGuia = 'N' then
            -- Extraemos el plazo del Preseteo
            -- mpostigoc 09/01/2018          
            begin
              select f.pp028maxn
                into ln_PlazoSist
                from fpp028 f
               where f.pp017par = 103
                 and f.pp028mod = 116
                 and f.pp028top = ln_tope117
                 and f.pp028mda = ln_mda117; -- plazo
            exception
              when others then
                null;
            end;
          end if;
        end if;
      end if;
    end if;
  
    /* if ln_plazoIng > ln_PlazoSist then
      lc_pcancel := 'S';
    else
      lc_pcancel := 'N';
    end if;*/
  
  end sp_cr_ControlAntg;
  --------------------------------------------------
  procedure sp_cr_ControlNuevo(ln_mod117  in number,
                               ln_mda117  in number,
                               ln_tope117 in number,
                               --ln_plazoIng  in number,
                               ln_PlazoSist out number /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  lc_pcancel   out varchar2*/) is
  
    lc_FlagGuia     varchar2(1);
    lc_FlagGuiaAdic varchar2(1) := 'N';
  
  begin
    begin
      -- Verifica si es una adicional   
      select 'S'
        into lc_FlagGuiaAdic
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 23
         and a.tp1corr3 > 1
         and a.tp1nro2 = 117
         and a.tp1nro3 = ln_tope117;
    
    exception
      when others then
        lc_FlagGuiaAdic := 'N';
    end;
  
    if lc_FlagGuiaAdic = 'S' then
    
      begin
        select a.tp1imp1
          into ln_PlazoSist
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 23
           and a.tp1corr3 > 1
           and a.tp1nro2 = 117
           and a.tp1nro3 = ln_tope117;
      exception
        when others then
          ln_PlazoSist := 0;
      end;
    else
    
      if lc_FlagGuiaAdic = 'N' then
      
        begin
          select 'S'
            into lc_FlagGuia
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 13
             and a.tp1corr2 = 24
             and a.tp1corr3 > 0
             and a.tp1nro2 = ln_mod117
             and a.tp1nro3 = ln_tope117;
        exception
          when others then
            lc_FlagGuia := 'N';
        end;
      
        if lc_FlagGuia = 'S' then
        
          begin
            select f.pp028maxn
              into ln_PlazoSist
              from fpp028 f
             where f.pp017par = 103
               and f.pp028mod = 116
               and f.pp028top = ln_tope117
               and f.pp028mda = ln_mda117; -- plazo
          exception
            when others then
              null;
          end;
        
        else
        
          if lc_FlagGuia = 'N' then
            -- Extraemos el plazo del Preseteo
            -- mpostigoc 09/01/2018
          
            begin
              select f.pp028maxn
                into ln_PlazoSist
                from fpp028 f
               where f.pp017par = 103
                 and f.pp028mod = 116
                 and f.pp028top = ln_tope117
                 and f.pp028mda = ln_mda117; -- plazo
            exception
              when others then
                null;
            end;
          
          end if;
        
        end if;
      
      end if;
    end if;
  
    ----- Verifica Plazo de la Linea que se esta procesando
  
    /* if ln_PlazoSist is not null then
    
      if ln_plazoIng > ln_PlazoSist then
        lc_pcancel := 'S';
      else
        lc_pcancel := 'N';
      end if;
    else
      lc_pcancel := 'N';
    end if;*/
  
  end sp_cr_ControlNuevo;
  -------------------------------------------------------------- 
  procedure sp_cr_verfvinclinea(ln_pgcod117     in number,
                                ln_modulo117    in number,
                                ln_sucursal117  in number,
                                ln_moneda117    in number,
                                ln_papel117     in number,
                                ln_cuenta117    in number,
                                ln_operacion117 in number,
                                ln_suboper117   in number,
                                ln_tipoper117   in number,
                                ln_InsEliminada out number) is
  
    cursor lista_vinculados is
      select jaqy800ins ln_Instancia
        from jaqy800
       where JAQY800PGCD = ln_pgcod117
         and JAQY800MOD = ln_modulo117
         and JAQY800SUC = ln_sucursal117
         and JAQY800MDA = ln_moneda117
         and JAQY800PAP = ln_papel117
         and JAQY800CTA = ln_cuenta117
         and JAQY800OPE = ln_operacion117
         and JAQY800SBOP = ln_suboper117
         and JAQY800TOPE = ln_tipoper117
         and jaqy800vinc = 'S';
  
    lc_EstVinculado varchar2(2) := 'N';
  
  begin
  
    -- con la linea principal verificamos todos los vinculados que podria tener la linea de credito
    for v in lista_vinculados loop
    
      begin
        -- verificamos que la instancia este activa
        select 'S'
          into lc_EstVinculado
          from wfwrkitems w
         where w.wfinsprcid = v.ln_Instancia
           and w.wfitemstsact = 1;
      exception
        when others then
          lc_EstVinculado := 'N';
      end;
    
      if lc_EstVinculado = 'S' then
        ln_InsEliminada := v.ln_Instancia;
        pq_cr_rtes_dispmovil.sp_baja_solicitud(v.ln_Instancia);
      end if;
    
    end loop;
  
  end sp_cr_verfvinclinea;
  --------------------------------------------------------------
  Procedure Sp_baja_solicitud(ln_ins in number) is
  
    ln_id number(10);
  begin
  
    begin
      select a.wfitemid
        into ln_id
        from wfwrkitems a
       where a.wfinsprcid = ln_ins
         and a.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    delete from wfworklist c where c.wfwrklstitemid = ln_id;
    commit;
  
    update wfwrkitems a
       set WFStsCod = 'B', WFItemStsAct = 0, WFItemEnd = sysdate
     where a.wfinsprcid = ln_ins
       and a.wfitemstsact = 1;
    commit;
  
    update wfinstprc b
       set WFInsPrcSta = 'B', WFInsPrcOSta = 0, WFInsPrcEnd = sysdate
     where b.wfinsprcid = ln_ins;
    commit;
  
  end Sp_baja_solicitud;
  ----------------------------------------------------------- 
  procedure sp_cr_ActualizaLogs(ln_TPGCODA in number,
                                ln_ITSUCA  in number,
                                ln_ITMODA  in number,
                                ln_ITTRANA in number,
                                ln_ITNRELA in number,
                                ln_ITORDA  in number,
                                ln_ITSBORA in number,
                                ln_TPGCODF in number,
                                ln_ITSUCF  in number,
                                ln_ITMODF  in number,
                                ln_ITTRANF in number,
                                ln_ITNRELF in number,
                                ln_ITORDF  in number,
                                ln_ITSBORF in number,
                                ld_fecpro  in date) is
  
  begin
  
    begin
      update aqpa270a a
         set a.aqpa270apgcod  = ln_TPGCODF,
             a.aqpa270aitsuc  = ln_ITSUCF,
             a.aqpa270aitmod  = ln_ITMODF,
             a.aqpa270aittran = ln_ITTRANF,
             a.aqpa270aitnrel = ln_ITNRELF,
             a.aqpa270aitord  = ln_ITORDF,
             a.aqpa270aitsbor = ln_ITSBORF,
             A.AQPA270AEST    = 'H'
       where a.aqpa270apgcod = ln_TPGCODA
         and a.aqpa270aitsuc = ln_ITSUCA
         and a.aqpa270aitmod = ln_ITMODA
         and a.aqpa270aittran = ln_ITTRANA
         and a.aqpa270aitnrel = ln_ITNRELA
         and a.aqpa270aitord = ln_ITORDA
         and a.aqpa270aitsbor = ln_ITSBORA
         and a.aqpa270afec = ld_fecpro
         and a.aqpa270aest = 'I';
      commit;
    end;
  
    begin
      update aqpa271a a
         set A.AQPA271AIPGCOD = ln_TPGCODF,
             a.aqpa271aitsuc  = ln_ITSUCF,
             a.aqpa271aitmod  = ln_ITMODF,
             a.aqpa271aittran = ln_ITTRANF,
             a.aqpa271aitnrel = ln_ITNRELF,
             a.aqpa271aitord  = ln_ITORDF,
             a.aqpa271aitsbor = ln_ITSBORF,
             a.aqpa271aest    = 'H'
       where a.aqpa271aIpgcod = ln_TPGCODA
         and a.aqpa271aitsuc = ln_ITSUCA
         and a.aqpa271aitmod = ln_ITMODA
         and a.aqpa271aittran = ln_ITTRANA
         and a.aqpa271aitnrel = ln_ITNRELA
         and a.aqpa271aitord = ln_ITORDA
         and a.aqpa271aitsbor = ln_ITSBORA
         and a.aqpa271afec = ld_fecpro
         and a.aqpa271aest = 'I';
      commit;
    end;
  
  end sp_cr_ActualizaLogs;
  -------------------------------------------------------------
  procedure sp_cr_UltFchPagada(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cta       in number,
                               ln_oper      in number,
                               ln_sbop      in number,
                               ln_tope      in number,
                               ld_UltFch    out date,
                               ld_FchCuoImp out date) is
  
    ln_pgcod116  number := 0;
    ln_mod116    number := 0;
    ln_suc116    number := 0;
    ln_mda116    number := 0;
    ln_pap116    number := 0;
    ln_cta116    number := 0;
    ln_oper116   number := 0;
    ln_sbop116   number := 0;
    ln_tope116   number := 0;
    ld_FchSist   date;
    ld_UltFchAux date;
    ld_EstUltPag varchar2(5) := 'N';
  
  begin
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    end;
  
    begin
      select a.r1cod,
             a.r1mod,
             a.r1suc,
             a.r1mda,
             a.r1pap,
             a.r1cta,
             a.r1oper,
             a.r1sbop,
             a.r1tope
        into ln_pgcod116,
             ln_mod116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_oper116,
             ln_sbop116,
             ln_tope116
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod
         and a.r2mod = ln_mod
         and a.r2suc = ln_suc
         and a.r2mda = ln_mda
         and a.r2pap = ln_pap
         and a.r2cta = ln_cta
         and a.r2oper = ln_oper
         and a.r2sbop = ln_sbop
         and a.r2tope = ln_tope
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
      when others then
        null;
    end;
  
    if ln_pgcod116 > 0 then
      begin
        begin
          select max(f.ppfpag)
            into ld_UltFch
            from fsd602 f
           where f.pgcod = ln_pgcod116
             and f.ppmod = ln_mod116
             and f.ppsuc = ln_suc116
             and f.ppmda = ln_mda116
             and f.pppap = ln_pap116
             and f.ppcta = ln_cta116
             and f.ppoper = ln_oper116
             and f.ppsbop = ln_sbop116
             and f.pptope = ln_tope116
             and f.pp1stat = 'T'
             and f.d602co = 'S'
             and f.pp1cap >= 0;
        exception
          when others then
            begin
              --Hlaqui - Se quita el +1 a la fecha del sistema
              select f.pgfape
                into ld_UltFch
                from fst017 f
               where f.pgcod = 1;
            end;
        end;
      
        if ld_UltFch is null then
          ld_UltFch := ld_FchSist - 1; --mpostigoc 03/02/2020 PRY2348        
        end if;
      end;
      begin
        begin
          select max(f.ppfpag)
            into ld_UltFchAux
            from fsd602 f
           where f.pgcod = ln_pgcod116
             and f.ppmod = ln_mod116
             and f.ppsuc = ln_suc116
             and f.ppmda = ln_mda116
             and f.pppap = ln_pap116
             and f.ppcta = ln_cta116
             and f.ppoper = ln_oper116
             and f.ppsbop = ln_sbop116
             and f.pptope = ln_tope116
             and f.d602co = 'S'
             and f.pp1cap >= 0;
        exception
          when others then
            null;
        end;
      
        begin
          select max(f.pp1stat)
            into ld_EstUltPag
            from fsd602 f
           where f.pgcod = ln_pgcod116
             and f.ppmod = ln_mod116
             and f.ppsuc = ln_suc116
             and f.ppmda = ln_mda116
             and f.pppap = ln_pap116
             and f.ppcta = ln_cta116
             and f.ppoper = ln_oper116
             and f.ppsbop = ln_sbop116
             and f.pptope = ln_tope116
             and f.d602co = 'S'
             and f.pp1cap >= 0
             and f.ppfpag = ld_UltFchAux;
        exception
          when others then
            ld_EstUltPag := 'N';
        end;
      
        ld_EstUltPag := nvl(ld_EstUltPag, 'N');
      
        if ld_EstUltPag = 'P' then
          ld_FchCuoImp := ld_UltFchAux;
        
        else
          if ld_EstUltPag = 'T' then
            begin
              select min(f.ppfpag)
                into ld_FchCuoImp
                from fsd601 f
               where f.pgcod = ln_pgcod116
                 and f.ppmod = ln_mod116
                 and f.ppsuc = ln_suc116
                 and f.ppmda = ln_mda116
                 and f.pppap = ln_pap116
                 and f.ppcta = ln_cta116
                 and f.ppoper = ln_oper116
                 and f.ppsbop = ln_sbop116
                 and f.pptope = ln_tope116
                 and f.ppfpag > ld_UltFchAux;
            exception
              when others then
                null;
            end;
          else
            if ld_EstUltPag = 'N' then
              begin
                select min(f.ppfpag)
                  into ld_FchCuoImp
                  from fsd601 f
                 where f.pgcod = ln_pgcod116
                   and f.ppmod = ln_mod116
                   and f.ppsuc = ln_suc116
                   and f.ppmda = ln_mda116
                   and f.pppap = ln_pap116
                   and f.ppcta = ln_cta116
                   and f.ppoper = ln_oper116
                   and f.ppsbop = ln_sbop116
                   and f.pptope = ln_tope116
                   and f.d601co = 'S';
              exception
                when others then
                  ld_FchCuoImp := ld_FchSist;
              end;
            end if;
          end if;
        end if;
      end;
    else
      ld_UltFch    := ld_FchSist;
      ld_FchCuoImp := ld_FchSist;
    end if;
  
  end sp_cr_UltFchPagada;
  -------------------------------------------------------------
end PQ_CR_RTES_DISPMOVIL;
/

