create or replace package PQ_CR_REPORTELINEAS_EF is

  -- Author  : MPOSTIGOC
  -- Created : 2/10/2019 11:24:42 a. m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_InicioReporte(ln_pais    in number,
                                ln_tdoc    in number,
                                lc_ndoc    in char,
                                ld_fecpro  in date,
                                lc_usuario in varchar2);
  -------------------------------------------------------                                
  procedure sp_cr_VerifEF(ln_pais          in number,
                          ln_tdoc          in number,
                          lc_ndoc          in char,
                          ld_fchevaluacion out date,
                          ln_InstEval      out number,
                          lc_SacaInfo      out varchar2);
  -------------------------------------------------------------                          
  procedure sp_cr_Lineas(ln_pais    in number,
                         ln_tdoc    in number,
                         lc_ndoc    in char,
                         ld_fecpro  in date,
                         lc_usuario in varchar2);
  -------------------------------------------------------
  procedure sp_cr_InsertLineas(ld_fecpro      in date,
                               lc_usuario     in varchar2,
                               ln_pais        in number,
                               ln_tdoc        in number,
                               lc_ndoc        in varchar2,
                               lc_NombCli     in varchar2,
                               ln_PGCOD       in number,
                               ln_MOD         in number,
                               ln_SUC         in number,
                               ln_MDA         in number,
                               ln_PAP         in number,
                               ln_CTA         in number,
                               ln_OPE         in number,
                               ln_SBOP        in number,
                               ln_TOPE        in number,
                               lc_NOMBAGE     in varchar2,
                               ln_MNTLN       in number,
                               ln_INSTLN      in number,
                               lc_nombreanlst in varchar2);
  -----------------------------------------------------------------
  procedure sp_Cr_DatosCabecera(ln_pais         in number,
                                ln_tdoc         in number,
                                lc_ndoc         in character,
                                ln_cuenta       in number,
                                ln_operacion    in number,
                                ln_tope         in number,
                                lc_desctdoc     out varchar2,
                                lc_NombCliente  out varchar2,
                                ln_nombagencia  out varchar2,
                                lc_analista     out varchar2,
                                ln_Instancia    out number,
                                lc_TipSolicitud out varchar2,
                                lc_Producto     out varchar2);
  -----------------------------------------------------------------
  procedure sp_Cr_Detalle(ln_pais      in number,
                          ln_tdoc      in number,
                          lc_ndoc      in character,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_tope      in number,
                          lc_SacoInfo  out varchar2);
  ----------------------------------------------------------------------
  procedure sp_cr_DetalleDisposicion(ln_Instancia in number,
                                     ln_pgcod     in number,
                                     ln_suct      in number,
                                     ln_modt      in number,
                                     ln_tran      in number,
                                     ln_relt      in number,
                                     ln_ordt      in number,
                                     ld_fect      in date,
                                     -- lc_hora      in character,
                                     lc_SacoInfo IN VARCHAR2);
  ----------------------------------------------------------------
  procedure sp_cr_DetalleOtorgamiento(ln_Instancia in number,
                                      lc_SacoInfo  IN VARCHAR2);
  ----------------------------------------------------------------
  procedure sp_cr_DetalleActualizacion(ln_Instancia in number,
                                       lc_SacoInfo  IN VARCHAR2);
  ---------------------------------------------------------------------
  procedure sp_cr_CuotaPtncl(ln_Instancia in number,
                             lc_SacoInfo  in varchar2);
  -----------------------------------------------------------------
  procedure sp_cr_CuotaPtncDP(ln_Instancia in number,
                              ln_pgcod     in number,
                              ln_suct      in number,
                              ln_modt      in number,
                              ln_tran      in number,
                              ln_relt      in number,
                              ld_fect      in date,
                              lc_SacoInfo  in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_LogCuentas(ln_corr      in number,
                             ld_fecpro    in date,
                             lc_hora      in character,
                             lc_user      in varchar2,
                             ln_pais      in number,
                             ln_tdoc      in number,
                             lc_ndoc      in varchar2,
                             ln_tcamb     in number,
                             ln_instancia in number,
                             ld_feval     in date,
                             ld_fical     in date,
                             ln_pgcod     in number,
                             ln_mod       in number,
                             ln_suc       in number,
                             ln_mda       in number,
                             ln_pap       in number,
                             ln_cta       in number,
                             ln_ope       in number,
                             ln_sbop      in number,
                             ln_tope      in number,
                             ln_ori       in number,
                             ln_ncuo      in number,
                             lc_est       in varchar2,
                             ln_tarea     in varchar2,
                             lc_indcred   in varchar2,
                             ln_naux1     in number,
                             ln_naux2     in number,
                             ln_naux3     in number);
  ----------------------------------------------------------------
  procedure sp_cr_LogRatioPeriodo(ln_corr    in number,
                                  ld_fec     in date,
                                  lc_hora    in character,
                                  lc_user    in varchar2,
                                  ln_pais    in number,
                                  ln_tdoc    in number,
                                  lc_ndoc    in varchar2,
                                  ln_tcamb   in number,
                                  ln_inst    in number,
                                  ld_feval   in date,
                                  ld_fecal   in date,
                                  lc_mesanio in varchar2,
                                  ln_capcaja in number,
                                  ln_ifis    in number,
                                  ln_resneto in number,
                                  ln_ccontg  in number,
                                  ln_cpoten  in number,
                                  ln_ratio   in number,
                                  ln_est     in varchar2,
                                  lc_tarea   in varchar2,
                                  ln_naux1   in number,
                                  ln_naux2   in number,
                                  ln_naux3   in number);
  -------------------------------------------------------------
  procedure sp_cr_MaxRatio(ln_corr    in number,
                           ln_pais    in number,
                           ln_tdoc    in number,
                           lc_ndoc    in varchar2,
                           ln_tcamb   in number,
                           ln_inst    in number,
                           ld_fec     in date,
                           lc_hora    in character,
                           lc_user    in varchar2,
                           lc_mesanio in varchar2,
                           ln_capcaja in number,
                           ln_ifis    in number,
                           ln_resneto in number,
                           ln_ccontg  in number,
                           ln_cpoten  in number,
                           ln_ratio   in number,
                           lc_est     in varchar2,
                           lc_tarea   in varchar2,
                           ln_naux1   in number,
                           ln_naux2   in number,
                           ln_naux3   in number);
  ---------------------------------------------------------------
  procedure sp_cr_ActMntCuotaAE(ln_Instancia in number,
                                lc_mesanio   in varchar2,
                                lc_flgprg    in varchar2);
  ----------------------------------------------------------------
  procedure sp_Cr_ActCuotaAQPA362AC(ln_instancia in number);
  -------------------------------------------------------------
  procedure sp_cr_logpotencial(ln_pais   in number,
                               ln_tdoc   in number,
                               lc_ndoc   in varchar2,
                               ln_inst   in number,
                               ld_frcc   in date,
                               lc_enti   in varchar2,
                               lc_relac  in varchar2,
                               ln_util   in number,
                               ln_nutil  in number,
                               ln_factor in number,
                               ln_cpoten in number);

end PQ_CR_REPORTELINEAS_EF;
/

create or replace package body PQ_CR_REPORTELINEAS_EF is

  procedure sp_cr_InicioReporte(ln_pais    in number,
                                ln_tdoc    in number,
                                lc_ndoc    in char,
                                ld_fecpro  in date,
                                lc_usuario in varchar2) is
  
    ld_fchevaluacion  date;
    ln_InstEval       number := 0;
    lc_SacaInfo       varchar2(5) := 'O';
    lc_TieneEvalflujo varchar2(5) := 'N';
  
  begin
    PQ_CR_REPORTELINEAS_EF.sp_cr_VerifEF(ln_pais,
                                         ln_tdoc,
                                         lc_ndoc,
                                         ld_fchevaluacion,
                                         ln_InstEval,
                                         lc_SacaInfo);
    pq_cr_ratio_evalflujo_rte.sp_cr_verfevalflujo(ln_InstEval,
                                                  lc_TieneEvalflujo);
  
    if lc_TieneEvalflujo = 'S' then
    
      begin
        delete from aqpa361 a
         where a.aqpa361pais = ln_pais
           and a.aqpa361tdoc = ln_tdoc
           and a.aqpa361ndoc = lc_ndoc;
        commit;
      end;
    
      pq_cr_reportelineas_ef.sp_cr_Lineas(ln_pais    => ln_pais,
                                          ln_tdoc    => ln_tdoc,
                                          lc_ndoc    => lc_ndoc,
                                          ld_fecpro  => ld_fecpro,
                                          lc_usuario => lc_usuario);
    end if;
  
  end sp_cr_InicioReporte;
  ---------------------------------------------------------------------------
  procedure sp_cr_VerifEF(ln_pais          in number,
                          ln_tdoc          in number,
                          lc_ndoc          in char,
                          ld_fchevaluacion out date,
                          ln_InstEval      out number,
                          lc_SacaInfo      out varchar2) is
  
    cursor lista_creditos(ln_pais number, ln_tdoc number, lc_ndoc char) is
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
      --and d.sng021tmod = 13
       order by x.xwfprcins;
  
    ld_MaxFchEva515 date;
    ln_EvalAux      number := 0;
    ln_Eval         number := 0;
    ln_InstaEva     number := 0;
    ln_Ins515       number := 0;
    ld_fcheval120   date;
    lc_FlgInstLinAE varchar2(2) := 'N';
  
  begin
    lc_SacaInfo := 'OT';
  
    for l in lista_creditos(ln_pais, ln_tdoc, lc_ndoc) loop
      --Instancia desembolsadas para el cliente
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
    
      pq_cr_ratio_evalflujo.sp_cr_fchevaluacion(ln_instancia     => ln_InstaEva,
                                                ld_fchevaluacion => ld_fcheval120);
    
    end;
  
    begin
      -- Instancias Actualizadas fuera del Flujo, por el Panel de Actualizacion de Evaluacion
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
    
      if lc_FlgInstLinAE = 'N' then
        begin
          select max(j.jaqz515ins)
            into ln_Ins515
            from jaqz515 j
           where j.jaqz515pai = ln_pais
             and j.jaqz515tdo = ln_tdoc
             and trim(j.jaqz515ndo) = lc_ndoc
             and j.jaqz515fee = ld_MaxFchEva515;
        end;
      end if;
    
    end;
  
    if ld_fcheval120 is not null and ld_MaxFchEva515 is not null then
    
      if ld_fcheval120 >= ld_MaxFchEva515 then
        ld_fchevaluacion := ld_fcheval120;
        ln_InstEval      := ln_InstaEva;
        lc_SacaInfo      := 'OT';
      else
        if ld_fcheval120 < ld_MaxFchEva515 then
          ld_fchevaluacion := ld_MaxFchEva515;
          ln_InstEval      := ln_Ins515;
          lc_SacaInfo      := 'AC';
        end if;
      end if;
    
    else
      if ld_fcheval120 is null and ld_MaxFchEva515 is not null then
        ld_fchevaluacion := ld_MaxFchEva515;
        ln_InstEval      := ln_Ins515;
        lc_SacaInfo      := 'AC';
      else
        if ld_fcheval120 is not null and ld_MaxFchEva515 is null then
          ld_fchevaluacion := ld_fcheval120;
          ln_InstEval      := ln_InstaEva;
          lc_SacaInfo      := 'OT';
        end if;
      end if;
    end if;
  
    ln_InstEval := nvl(ln_InstEval, 0);
  
  end sp_cr_VerifEF;
  -----------------------------------------------------------------
  procedure sp_cr_Lineas(ln_pais    in number,
                         ln_tdoc    in number,
                         lc_ndoc    in char,
                         ld_fecpro  in date,
                         lc_usuario in varchar2) is
  
    cursor listado_lineas is
    
      select f.pgcod,
             f.aomod,
             f.aosuc,
             f.aomda,
             f.aopap,
             f.aocta,
             f.aooper,
             f.aosbop,
             f.aotope,
             f.aofval,
             f.aoimp
        from fsd010 f
       where f.pgcod = 1
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = lc_ndoc)
         and f.aopap = 0
         and f.aostat <> 99
         and aomod = 117; -- Solo se extrae Lineas
  
    lc_NombAge     varchar2(30);
    ln_InstCred    number := 0;
    lc_NombCliente varchar2(150);
    lc_codase      varchar2(10);
    lc_nombanalst  varchar2(150);
  
  begin
  
    for l in listado_lineas loop
    
      begin
        select f.scnom
          into lc_NombAge
          from fst001 f
         where f.pgcod = 1
           and f.sucurs = l.aosuc;
      end;
    
      begin
        ln_InstCred := fn_instancia_credito(v_Scmod  => l.aomod,
                                            v_Scsuc  => l.aosuc,
                                            v_Scmda  => l.aomda,
                                            v_Scpap  => l.aopap,
                                            v_Sccta  => l.aocta,
                                            v_Scoper => l.aooper,
                                            v_Scsbop => l.aosbop,
                                            v_Sctope => l.aotope);
      end;
    
      begin
        select s.sng001ase
          into lc_codase
          from sng001 s
         where s.sng001inst = ln_InstCred;
      exception
        when others then
          null;
      end;
    
      begin
      
        select Ubnom
          into lc_nombanalst
          from fst746
         where Ubuser = lc_codase;
      exception
        when others then
          null;
        
      end;
    
      begin
        select trim(f.pfape1) || ' ' || trim(f.pfape2) || ',' ||
               trim(f.pfnom1) || ' ' || trim(f.pfnom2)
          into lc_NombCliente
          from FSD002 f
         where f.pfpais = ln_pais
           and f.pftdoc = ln_tdoc
           and f.pfndoc = lc_ndoc;
      end;
    
      pq_cr_reportelineas_ef.sp_cr_InsertLineas(ld_fecpro      => ld_fecpro,
                                                lc_usuario     => lc_usuario,
                                                ln_pais        => ln_pais,
                                                ln_tdoc        => ln_tdoc,
                                                lc_ndoc        => lc_ndoc,
                                                lc_NombCli     => lc_NombCliente,
                                                ln_PGCOD       => l.pgcod,
                                                ln_MOD         => l.aomod,
                                                ln_SUC         => l.aosuc,
                                                ln_MDA         => l.aomda,
                                                ln_PAP         => l.aopap,
                                                ln_CTA         => l.aocta,
                                                ln_OPE         => l.aooper,
                                                ln_SBOP        => l.aosbop,
                                                ln_TOPE        => l.aotope,
                                                lc_NOMBAGE     => lc_NombAge,
                                                ln_MNTLN       => l.aoimp,
                                                ln_INSTLN      => ln_InstCred,
                                                lc_nombreanlst => lc_nombanalst);
    
    end loop;
  
  end sp_cr_Lineas;
  ---------------------------------------------------------------
  procedure sp_cr_InsertLineas(ld_fecpro      in date,
                               lc_usuario     in varchar2,
                               ln_pais        in number,
                               ln_tdoc        in number,
                               lc_ndoc        in varchar2,
                               lc_NombCli     in varchar2,
                               ln_PGCOD       in number,
                               ln_MOD         in number,
                               ln_SUC         in number,
                               ln_MDA         in number,
                               ln_PAP         in number,
                               ln_CTA         in number,
                               ln_OPE         in number,
                               ln_SBOP        in number,
                               ln_TOPE        in number,
                               lc_NOMBAGE     in varchar2,
                               ln_MNTLN       in number,
                               ln_INSTLN      in number,
                               lc_nombreanlst in varchar2) is
  
    ln_corr number := 0;
    lc_hora char(8) := '00:00:00';
  begin
  
    begin
      select max(a.aqpa361corr)
        into ln_corr
        from aqpa361 a
       where a.aqpa361fec = ld_fecpro
         and a.aqpa361user = lc_usuario
         and a.aqpa361pais = ln_pais
         and a.aqpa361tdoc = ln_tdoc
         and a.aqpa361ndoc = lc_ndoc;
    exception
      when others then
        ln_corr := 0;
    end;
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into AQPA361
        (AQPA361CORR,
         AQPA361FEC,
         AQPA361HORA,
         AQPA361USER,
         AQPA361PAIS,
         AQPA361TDOC,
         AQPA361NDOC,
         AQPA361NOMB,
         AQPA361PGCOD,
         AQPA361MOD,
         AQPA361SUC,
         AQPA361MDA,
         AQPA361PAP,
         AQPA361CTA,
         AQPA361OPE,
         AQPA361SBOP,
         AQPA361TOPE,
         AQPA361NOMBAGE,
         AQPA361MNTLN,
         AQPA361INSTLN,
         AQPA361ANLST)
      values
        (ln_corr + 1,
         ld_fecpro,
         lc_hora,
         lc_usuario,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         lc_NombCli,
         ln_PGCOD,
         ln_MOD,
         ln_SUC,
         ln_MDA,
         ln_PAP,
         ln_CTA,
         ln_OPE,
         ln_SBOP,
         ln_TOPE,
         lc_NOMBAGE,
         ln_MNTLN,
         ln_INSTLN,
         lc_nombreanlst);
      commit;
    end;
  end sp_cr_InsertLineas;
  ----------------------------------------------------------------
  procedure sp_Cr_DatosCabecera(ln_pais         in number,
                                ln_tdoc         in number,
                                lc_ndoc         in character,
                                ln_cuenta       in number,
                                ln_operacion    in number,
                                ln_tope         in number,
                                lc_desctdoc     out varchar2,
                                lc_NombCliente  out varchar2,
                                ln_nombagencia  out varchar2,
                                lc_analista     out varchar2,
                                ln_Instancia    out number,
                                lc_TipSolicitud out varchar2,
                                lc_Producto     out varchar2) is
  
    ln_ori    number := 0;
    ln_Modulo number := 0;
  
  begin
  
    begin
      select Tdnom into lc_desctdoc from fst014 where Tdocum = ln_tdoc;
    exception
      when others then
        null;
    end;
  
    begin
      select trim(f.pfape1) || ' ' || trim(f.pfape2) || ',' ||
             trim(f.pfnom1) || ' ' || trim(f.pfnom2)
        into lc_NombCliente
        from FSD002 f
       where f.pfpais = ln_pais
         and f.pftdoc = ln_tdoc
         and f.pfndoc = lc_ndoc;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpa361nombage,
             a.aqpa361anlst,
             a.aqpa361instln,
             a.aqpa361mod
        into ln_nombagencia, lc_analista, ln_Instancia, ln_Modulo
        from aqpa361 a
       where a.aqpa361cta = ln_cuenta
         and a.aqpa361ope = ln_operacion
         and a.aqpa361tope = ln_tope;
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng001ori
        into ln_ori
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        ln_ori := 0;
    end;
  
    begin
      select UPPER(Tpdesc)
        into lc_TipSolicitud
        from fst098
       where Pgcod = 1
         and Tpcod = 7717
         and Tpnro = ln_ori;
    exception
      when others then
        null;
    end;
  
    begin
      select UPPER(Tonom)
        into lc_Producto
        from fst004
       where Modulo = ln_Modulo
         and Totope = ln_tope;
    exception
      when others then
        null;
    End;
  
  end sp_Cr_DatosCabecera;

  ---------------------------------------------------------------
  procedure sp_Cr_Detalle(ln_pais      in number,
                          ln_tdoc      in number,
                          lc_ndoc      in character,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_tope      in number,
                          lc_SacoInfo  out varchar2) is
  
    ln_InsLinea      number;
    ld_FchUltDisp    date;
    ld_HoraUltDisp   character(10) := '00:00:00';
    ln_pgcod         number;
    ln_suct          number;
    ln_modt          number;
    ln_tran          number;
    ln_relt          number;
    ln_ordt          number;
    ln_sbort         number;
    ld_fchevaluacion date;
    ln_InstEval      number := 0;
  
  begin
  
    lc_SacoInfo := 'NC';
  
    -- eliminar todo lo procesado en la tabla por cliente
  
    begin
    
      begin
        delete from aqpa362 a
         where a.aqpa362pais = ln_pais
           and a.aqpa362tdoc = ln_tdoc
           and trim(a.aqpa362ndoc) = trim(lc_ndoc);
      
      end;
    
      begin
        delete from aqpa363 a
         where a.aqpa363pais = ln_pais
           and a.aqpa363tdoc = ln_tdoc
           and trim(a.aqpa363ndoc) = trim(lc_ndoc);
      
      end;
    
      begin
        delete from aqpa364 a
         where a.aqpa364pais = ln_pais
           and a.aqpa364tdoc = ln_tdoc
           and trim(a.aqpa364ndoc) = trim(lc_ndoc);
      
      end;
    
      begin
        delete from aqpa365 a
         where a.aqpa365pais = ln_pais
           and a.aqpa365tdoc = ln_tdoc
           and trim(a.aqpa365ndoc) = trim(lc_ndoc);
      end;
    
      commit;
    
    end;
  
    begin
      select a.aqpa361instln
        into ln_InsLinea
        from aqpa361 a
       where a.aqpa361cta = ln_cuenta
         and a.aqpa361ope = ln_operacion
         and a.aqpa361tope = ln_tope;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpa357fec)
        into ld_FchUltDisp
        from aqpa357 a
       where a.aqpa357instl = ln_InsLinea;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpa357hora)
        into ld_HoraUltDisp
        from aqpa357 a
       where a.aqpa357instl = ln_InsLinea
         and a.aqpa357fec = ld_FchUltDisp;
    exception
      when others then
        null;
    end;
  
    if ld_FchUltDisp is not null then
    
      begin
        select distinct a.aqpa357pgcod,
                        a.aqpa357itsuc,
                        a.aqpa357itmod,
                        a.aqpa357ittran,
                        a.aqpa357itnrel,
                        a.aqpa357itord,
                        a.aqpa357itsbor
          into ln_pgcod,
               ln_suct,
               ln_modt,
               ln_tran,
               ln_relt,
               ln_ordt,
               ln_sbort
          from aqpa357 a
         where a.aqpa357instl = ln_InsLinea
           and a.aqpa357fec = ld_FchUltDisp
           and a.aqpa357hora = ld_HoraUltDisp
           and rownum = 1;
      end;
    
      lc_SacoInfo := 'DP';
    
    else
      if ld_FchUltDisp is null then
      
        pq_cr_reportelineas_ef.sp_cr_VerifEF(ln_pais,
                                             ln_tdoc,
                                             lc_ndoc,
                                             ld_fchevaluacion,
                                             ln_InstEval,
                                             lc_SacoInfo);
      
      end if;
    end if;
  
    if lc_SacoInfo = 'DP' then
    
      pq_cr_reportelineas_ef.sp_cr_DetalleDisposicion(ln_Instancia => ln_InsLinea,
                                                      ln_pgcod     => ln_pgcod,
                                                      ln_suct      => ln_suct,
                                                      ln_modt      => ln_modt,
                                                      ln_tran      => ln_tran,
                                                      ln_relt      => ln_relt,
                                                      ln_ordt      => ln_ordt,
                                                      ld_fect      => ld_FchUltDisp,
                                                      lc_SacoInfo  => lc_SacoInfo);
    
    else
      if lc_SacoInfo = 'OT' then
        pq_cr_reportelineas_ef.sp_cr_DetalleOtorgamiento(ln_Instancia => ln_InstEval,
                                                         lc_SacoInfo  => lc_SacoInfo);
      else
        if lc_SacoInfo = 'AC' then
          pq_cr_reportelineas_ef.sp_cr_DetalleActualizacion(ln_Instancia => ln_InstEval,
                                                            lc_SacoInfo  => lc_SacoInfo);
        end if;
      end if;
    
    end if;
  
  end sp_Cr_Detalle;
  ----------------------------------------------------------------
  procedure sp_cr_DetalleDisposicion(ln_Instancia in number,
                                     ln_pgcod     in number,
                                     ln_suct      in number,
                                     ln_modt      in number,
                                     ln_tran      in number,
                                     ln_relt      in number,
                                     ln_ordt      in number,
                                     ld_fect      in date,
                                     lc_SacoInfo  in varchar2) is
  
    cursor log_cuentas is
      select *
        from aqpa357 b
       where b.aqpa357pgcod = ln_pgcod
         and b.aqpa357itsuc = ln_suct
         and b.aqpa357itmod = ln_modt
         and b.aqpa357ittran = ln_tran
         and b.aqpa357itnrel = ln_relt
         and b.aqpa357itord = ln_ordt
         and b.aqpa357fec = ld_fect
         and b.aqpa357instl = ln_Instancia;
  
    cursor log_ratioperiodo is
      select *
        from aqpa358 b
       where b.aqpa358pgcod = ln_pgcod
         and b.aqpa358itsuc = ln_suct
         and b.aqpa358itmod = ln_modt
         and b.aqpa358ittran = ln_tran
         and b.aqpa358itnrel = ln_relt
         and b.aqpa358itord = ln_ordt
         and b.aqpa358fec = ld_fect
         and b.aqpa358instl = ln_Instancia;
  
    cursor log_maxratio is
      select *
        from aqpa359 b
       where b.aqpa359pgcod = ln_pgcod
         and b.aqpa359itsuc = ln_suct
         and b.aqpa359itmod = ln_modt
         and b.aqpa359ittran = ln_tran
         and b.aqpa359itnrel = ln_relt
         and b.aqpa359itord = ln_ordt
         and b.aqpa359fec = ld_fect
         and b.aqpa359instl = ln_Instancia;
  
  begin
  
    for lc in log_cuentas loop
      pq_Cr_reportelineas_ef.sp_cr_LogCuentas(ln_corr      => lc.aqpa357corr,
                                              ld_fecpro    => lc.aqpa357fec,
                                              lc_hora      => lc.aqpa357hora,
                                              lc_user      => lc.aqpa357user,
                                              ln_pais      => lc.aqpa357pais,
                                              ln_tdoc      => lc.aqpa357tdoc,
                                              lc_ndoc      => lc.aqpa357ndoc,
                                              ln_tcamb     => lc.aqpa357tcamb,
                                              ln_instancia => ln_Instancia,
                                              ld_feval     => lc.aqpa357feval,
                                              ld_fical     => lc.aqpa357fical,
                                              ln_pgcod     => lc.aqpa357emp,
                                              ln_mod       => lc.aqpa357mod,
                                              ln_suc       => lc.aqpa357suc,
                                              ln_mda       => lc.aqpa357mda,
                                              ln_pap       => lc.aqpa357pap,
                                              ln_cta       => lc.aqpa357cta,
                                              ln_ope       => lc.aqpa357ope,
                                              ln_sbop      => lc.aqpa357sbop,
                                              ln_tope      => lc.aqpa357tope,
                                              ln_ori       => lc.aqpa357ori,
                                              ln_ncuo      => lc.aqpa357ncuo,
                                              lc_est       => lc.aqpa357est,
                                              ln_tarea     => lc_SacoInfo,
                                              lc_indcred   => lc.aqpa357indcred,
                                              ln_naux1     => lc.aqpa357naux1,
                                              ln_naux2     => lc.aqpa357naux2,
                                              ln_naux3     => lc.aqpa357naux3);
    
    end loop;
  
    for lp in log_ratioperiodo loop
      pq_Cr_reportelineas_ef.sp_cr_LogRatioPeriodo(ln_corr    => lp.aqpa358corr,
                                                   ld_fec     => lp.aqpa358fec,
                                                   lc_hora    => lp.aqpa358hora,
                                                   lc_user    => lp.aqpa358user,
                                                   ln_pais    => lp.aqpa358pais,
                                                   ln_tdoc    => lp.aqpa358tdoc,
                                                   lc_ndoc    => lp.aqpa358ndoc,
                                                   ln_tcamb   => lp.aqpa358tcamb,
                                                   ln_inst    => lp.aqpa358instl,
                                                   ld_feval   => lp.aqpa358feval,
                                                   ld_fecal   => lp.aqpa358fecal,
                                                   lc_mesanio => lp.aqpa358mesanio,
                                                   ln_capcaja => lp.aqpa358capcaja,
                                                   ln_ifis    => lp.aqpa358ifis,
                                                   ln_resneto => lp.aqpa358resneto,
                                                   ln_ccontg  => lp.aqpa358ccontg,
                                                   ln_cpoten  => lp.aqpa358cpoten,
                                                   ln_ratio   => lp.aqpa358ratio,
                                                   ln_est     => lp.aqpa358est,
                                                   lc_tarea   => lc_SacoInfo,
                                                   ln_naux1   => lp.aqpa358naux1,
                                                   ln_naux2   => lp.aqpa358naux2,
                                                   ln_naux3   => lp.aqpa358naux3);
    
    end loop;
  
    for lm in log_maxratio loop
      pq_cr_reportelineas_ef.sp_cr_MaxRatio(ln_corr    => lm.aqpa359corr,
                                            ln_pais    => lm.aqpa359pais,
                                            ln_tdoc    => lm.aqpa359tdoc,
                                            lc_ndoc    => lm.aqpa359ndoc,
                                            ln_tcamb   => lm.aqpa359tcamb,
                                            ln_inst    => lm.aqpa359instl,
                                            ld_fec     => lm.aqpa359fec,
                                            lc_hora    => lm.aqpa359hora,
                                            lc_user    => lm.aqpa359user,
                                            lc_mesanio => lm.aqpa359mesanio,
                                            ln_capcaja => lm.aqpa359capcaja,
                                            ln_ifis    => lm.aqpa359ifis,
                                            ln_resneto => lm.aqpa359resneto,
                                            ln_ccontg  => lm.aqpa359ccontg,
                                            ln_cpoten  => lm.aqpa359cpoten,
                                            ln_ratio   => lm.aqpa359ratio,
                                            lc_est     => lm.aqpa359est,
                                            lc_tarea   => lc_SacoInfo,
                                            ln_naux1   => lm.aqpa359naux1,
                                            ln_naux2   => lm.aqpa359naux2,
                                            ln_naux3   => lm.aqpa359naux3);
    end loop;
  
    pq_cr_reportelineas_ef.sp_cr_CuotaPtncDP(ln_Instancia,
                                             ln_pgcod,
                                             ln_suct,
                                             ln_modt,
                                             ln_tran,
                                             ln_relt,
                                             ld_fect,
                                             lc_SacoInfo);
  
  end sp_cr_DetalleDisposicion;
  ----------------------------------------------------------------
  procedure sp_cr_DetalleOtorgamiento(ln_Instancia in number,
                                      lc_SacoInfo  in varchar2) is
  
    cursor log_cuentas is
      select *
        from aqpa352 a
       where a.aqpa352inst = ln_Instancia
         and a.aqpa352est = 'H';
  
    cursor log_ratioperiodo is
      select *
        from aqpa353 a
       where a.aqpa353inst = ln_Instancia
         and a.aqpa353est = 'H';
  
    cursor log_maxratio is
      select *
        from aqpa354 a
       where a.aqpa354inst = ln_Instancia
         and a.aqpa354est = 'H';
  
  begin
  
    for lc in log_cuentas loop
      pq_Cr_reportelineas_ef.sp_cr_LogCuentas(ln_corr      => lc.aqpa352corr,
                                              ld_fecpro    => lc.aqpa352fec,
                                              lc_hora      => lc.aqpa352hora,
                                              lc_user      => lc.aqpa352user,
                                              ln_pais      => lc.aqpa352pais,
                                              ln_tdoc      => lc.aqpa352tdoc,
                                              lc_ndoc      => lc.aqpa352ndoc,
                                              ln_tcamb     => lc.aqpa352tcamb,
                                              ln_instancia => ln_Instancia,
                                              ld_feval     => lc.aqpa352feval,
                                              ld_fical     => lc.aqpa352fical,
                                              ln_pgcod     => lc.aqpa352pgcod,
                                              ln_mod       => lc.aqpa352mod,
                                              ln_suc       => lc.aqpa352suc,
                                              ln_mda       => lc.aqpa352mda,
                                              ln_pap       => lc.aqpa352pap,
                                              ln_cta       => lc.aqpa352cta,
                                              ln_ope       => lc.aqpa352ope,
                                              ln_sbop      => lc.aqpa352sbop,
                                              ln_tope      => lc.aqpa352tope,
                                              ln_ori       => lc.aqpa352ori,
                                              ln_ncuo      => lc.aqpa352ncuo,
                                              lc_est       => lc.aqpa352est,
                                              ln_tarea     => lc_SacoInfo,
                                              lc_indcred   => lc.aqpa352indcred,
                                              ln_naux1     => lc.aqpa352naux1,
                                              ln_naux2     => lc.aqpa352naux2,
                                              ln_naux3     => lc.aqpa352naux3);
    
    end loop;
  
    for lp in log_ratioperiodo loop
      pq_Cr_reportelineas_ef.sp_cr_LogRatioPeriodo(ln_corr    => lp.aqpa353corr,
                                                   ld_fec     => lp.aqpa353fec,
                                                   lc_hora    => lp.aqpa353hora,
                                                   lc_user    => lp.aqpa353user,
                                                   ln_pais    => lp.aqpa353pais,
                                                   ln_tdoc    => lp.aqpa353tdoc,
                                                   lc_ndoc    => lp.aqpa353ndoc,
                                                   ln_tcamb   => lp.aqpa353tcamb,
                                                   ln_inst    => lp.aqpa353inst,
                                                   ld_feval   => lp.aqpa353feval,
                                                   ld_fecal   => lp.aqpa353fecal,
                                                   lc_mesanio => lp.aqpa353mesanio,
                                                   ln_capcaja => lp.aqpa353capcaja,
                                                   ln_ifis    => lp.aqpa353ifis,
                                                   ln_resneto => lp.aqpa353resneto,
                                                   ln_ccontg  => lp.aqpa353ccontg,
                                                   ln_cpoten  => lp.aqpa353cpoten,
                                                   ln_ratio   => lp.aqpa353ratio,
                                                   ln_est     => lp.aqpa353est,
                                                   lc_tarea   => lc_SacoInfo,
                                                   ln_naux1   => lp.aqpa353naux1,
                                                   ln_naux2   => lp.aqpa353naux2,
                                                   ln_naux3   => lp.aqpa353naux3);
    
    end loop;
  
    for lm in log_maxratio loop
      pq_cr_reportelineas_ef.sp_cr_MaxRatio(ln_corr    => lm.aqpa354corr,
                                            ln_pais    => lm.aqpa354pais,
                                            ln_tdoc    => lm.aqpa354tdoc,
                                            lc_ndoc    => lm.aqpa354ndoc,
                                            ln_tcamb   => lm.aqpa354tcamb,
                                            ln_inst    => lm.aqpa354inst,
                                            ld_fec     => lm.aqpa354fec,
                                            lc_hora    => lm.aqpa354hora,
                                            lc_user    => lm.aqpa354user,
                                            lc_mesanio => lm.aqpa354mesanio,
                                            ln_capcaja => lm.aqpa354capcaja,
                                            ln_ifis    => lm.aqpa354ifis,
                                            ln_resneto => lm.aqpa354resneto,
                                            ln_ccontg  => lm.aqpa354ccontg,
                                            ln_cpoten  => lm.aqpa354cpoten,
                                            ln_ratio   => lm.aqpa354ratio,
                                            lc_est     => lm.aqpa354est,
                                            lc_tarea   => lc_SacoInfo,
                                            ln_naux1   => lm.aqpa354naux1,
                                            ln_naux2   => lm.aqpa354naux2,
                                            ln_naux3   => lm.aqpa354naux3);
    end loop;
  
    pq_cr_reportelineas_ef.sp_cr_CuotaPtncl(ln_Instancia => ln_Instancia,
                                            lc_SacoInfo  => lc_SacoInfo);
  
  end sp_cr_DetalleOtorgamiento;
  ----------------------------------------------------------------
  procedure sp_cr_DetalleActualizacion(ln_Instancia in number,
                                       lc_SacoInfo  in varchar2) is
  
    cursor log_cuentas is
      select *
        from aqpa352a a
       where a.aqpa352ainst = ln_Instancia
         and a.aqpa352aest = 'H';
  
    cursor log_ratioperiodo is
      select *
        from aqpa410a a
       where a.aqpa410ainst = ln_Instancia
         and a.aqpa410aesta = 'S';
  
    cursor log_maxratio(ln_maxratio number) is
      select a.aqpa410acorr,
             a.aqpa410apais,
             a.aqpa410atdoc,
             a.aqpa410andoc,
             a.aqpa410ainst,
             a.aqpa410afecp,
             A.AQPA410AASES,
             A.AQPA410AFCON,
             A.AQPA410ACUOC,
             A.AQPA410AIFIS,
             A.AQPA410ARESN,
             A.AQPA410ACCO,
             A.AQPA410ACPO,
             A.AQPA410ARATIO,
             A.AQPA410AESTA
        from aqpa410a a
       where a.aqpa410ainst = ln_Instancia
         and a.aqpa410aratio = ln_maxratio;
  
    lc_hora       character(10) := '00:00:00';
    ln_tcamb      number(14, 8) := 0.000000;
    lc_aniomescuo varchar2(8);
    ln_maxratio   number(10, 6);
  
  begin
  
    begin
      select max(a.aqpa410aratio)
        into ln_maxratio
        from aqpa410a a
       where a.aqpa410ainst = ln_Instancia
         and a.aqpa410aesta = 'S';
    
    end;
  
    for lc in log_cuentas loop
      pq_Cr_reportelineas_ef.sp_cr_LogCuentas(ln_corr      => lc.aqpa352acorr,
                                              ld_fecpro    => lc.aqpa352afec,
                                              lc_hora      => lc.aqpa352ahora,
                                              lc_user      => lc.aqpa352auser,
                                              ln_pais      => lc.aqpa352apais,
                                              ln_tdoc      => lc.aqpa352atdoc,
                                              lc_ndoc      => lc.aqpa352andoc,
                                              ln_tcamb     => lc.aqpa352atcamb,
                                              ln_instancia => ln_Instancia,
                                              ld_feval     => lc.aqpa352afeval,
                                              ld_fical     => lc.aqpa352afical,
                                              ln_pgcod     => lc.aqpa352apgcod,
                                              ln_mod       => lc.aqpa352amod,
                                              ln_suc       => lc.aqpa352asuc,
                                              ln_mda       => lc.aqpa352amda,
                                              ln_pap       => lc.aqpa352apap,
                                              ln_cta       => lc.aqpa352acta,
                                              ln_ope       => lc.aqpa352aope,
                                              ln_sbop      => lc.aqpa352asbop,
                                              ln_tope      => lc.aqpa352atope,
                                              ln_ori       => lc.aqpa352aori,
                                              ln_ncuo      => lc.aqpa352ancuo,
                                              lc_est       => lc.aqpa352aest,
                                              ln_tarea     => lc_SacoInfo,
                                              lc_indcred   => lc.aqpa352aindcred,
                                              ln_naux1     => lc.aqpa352anaux1,
                                              ln_naux2     => lc.aqpa352anaux2,
                                              ln_naux3     => lc.aqpa352anaux3);
      lc_hora  := lc.aqpa352ahora;
      ln_tcamb := lc.aqpa352atcamb;
    
    end loop;
  
    for lp in log_ratioperiodo loop
    
      begin
        select to_char(lp.aqpa410afcon, 'YYYYMM')
          into lc_aniomescuo
          from dual;
      end;
    
      pq_Cr_reportelineas_ef.sp_cr_LogRatioPeriodo(ln_corr    => lp.aqpa410acorr,
                                                   ld_fec     => lp.aqpa410afecp,
                                                   lc_hora    => lc_hora,
                                                   lc_user    => lp.aqpa410aases,
                                                   ln_pais    => lp.aqpa410apais,
                                                   ln_tdoc    => lp.aqpa410atdoc,
                                                   lc_ndoc    => lp.aqpa410andoc,
                                                   ln_tcamb   => ln_tcamb,
                                                   ln_inst    => lp.aqpa410ainst,
                                                   ld_feval   => lp.aqpa410afeval,
                                                   ld_fecal   => lp.aqpa410afcon,
                                                   lc_mesanio => lc_aniomescuo,
                                                   ln_capcaja => nvl(lp.aqpa410acuoc,
                                                                     0),
                                                   ln_ifis    => nvl(lp.aqpa410aifis,
                                                                     0),
                                                   ln_resneto => nvl(lp.aqpa410aresn,
                                                                     0),
                                                   ln_ccontg  => nvl(lp.aqpa410acco,
                                                                     0),
                                                   ln_cpoten  => nvl(lp.aqpa410acpo,
                                                                     0),
                                                   ln_ratio   => nvl(lp.aqpa410aratio,
                                                                     0),
                                                   ln_est     => lp.aqpa410aesta,
                                                   lc_tarea   => lc_SacoInfo,
                                                   ln_naux1   => 0.00,
                                                   ln_naux2   => 0.00,
                                                   ln_naux3   => 0.00);
    
    end loop;
  
    for lm in log_maxratio(ln_maxratio) loop
    
      begin
        select to_char(lm.aqpa410afcon, 'YYYYMM')
          into lc_aniomescuo
          from dual;
      end;
    
      pq_cr_reportelineas_ef.sp_cr_MaxRatio(ln_corr    => lm.aqpa410acorr,
                                            ln_pais    => lm.aqpa410apais,
                                            ln_tdoc    => lm.aqpa410atdoc,
                                            lc_ndoc    => lm.aqpa410andoc,
                                            ln_tcamb   => ln_tcamb,
                                            ln_inst    => lm.aqpa410ainst,
                                            ld_fec     => lm.aqpa410afecp,
                                            lc_hora    => trim(lc_hora),
                                            lc_user    => lm.aqpa410aases,
                                            lc_mesanio => lc_aniomescuo,
                                            ln_capcaja => nvl(lm.aqpa410acuoc,
                                                              0),
                                            ln_ifis    => nvl(lm.aqpa410aifis,
                                                              0),
                                            ln_resneto => nvl(lm.aqpa410aresn,
                                                              0),
                                            ln_ccontg  => nvl(lm.aqpa410acco,
                                                              0),
                                            ln_cpoten  => nvl(lm.aqpa410acpo,
                                                              0),
                                            ln_ratio   => nvl(lm.aqpa410aratio,
                                                              0),
                                            lc_est     => lm.aqpa410aesta,
                                            lc_tarea   => lc_SacoInfo,
                                            ln_naux1   => 0.00,
                                            ln_naux2   => 0.00,
                                            ln_naux3   => 0.00);
    
      pq_cr_reportelineas_ef.sp_cr_ActMntCuotaAE(ln_Instancia => lm.aqpa410ainst,
                                                 lc_mesanio   => lc_aniomescuo,
                                                 lc_flgprg    => 'S');
    
      pq_cr_reportelineas_ef.sp_Cr_ActCuotaAQPA362AC(ln_instancia => lm.aqpa410ainst);
    
    end loop;
  
    pq_cr_reportelineas_ef.sp_cr_CuotaPtncl(ln_Instancia => ln_Instancia,
                                            lc_SacoInfo  => lc_SacoInfo);
  
  end sp_cr_DetalleActualizacion;
  -----------------------------------------------------------------
  procedure sp_cr_CuotaPtncl(ln_Instancia in number,
                             lc_SacoInfo  in varchar2) is
  
    cursor Log_PtnclOtorg is
    
      select j.jaqy327pais,
             j.jaqy327tdoc,
             j.jaqy327ndoc,
             j.jaqy327frcc,
             j.jaqy327rela,
             j.jaqy327enti,
             j.jaqy327util,
             j.jaqy327aux8,
             j.jaqy327fac2,
             j.jaqy327cptn
        from jaqy327 j
       where j.jaqy327inst = ln_instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327chek = '1'
         and j.jaqy327cptn > 0;
  
    cursor log_PtnclDispo is
    
      select a.aqpa417frcc,
             a.aqpa417enti,
             a.aqpa417gast,
             a.aqpa417fact,
             a.aqpa417cptn
        from aqpa417 a
       where a.aqpa417inst = ln_Instancia;
  
    cursor log_PtnclActuEval is
    
      select a.aqpa421frcc,
             a.aqpa421enti,
             a.aqpa421gast,
             a.aqpa421fact,
             a.aqpa421cptn
        from aqpa421 a
       where a.aqpa421inst = ln_Instancia;
  
    ln_pais number;
    ln_tdoc number;
    lc_ndoc varchar2(12);
  
  begin
  
    if lc_SacoInfo = 'OT' then
    
      for po in Log_PtnclOtorg loop
        pq_cr_reportelineas_ef.sp_cr_logpotencial(ln_pais   => po.jaqy327pais,
                                                  ln_tdoc   => po.jaqy327tdoc,
                                                  lc_ndoc   => po.jaqy327ndoc,
                                                  ln_inst   => ln_Instancia,
                                                  ld_frcc   => po.jaqy327frcc,
                                                  lc_enti   => po.jaqy327enti,
                                                  lc_relac  => po.jaqy327rela,
                                                  ln_util   => po.jaqy327util,
                                                  ln_nutil  => po.jaqy327aux8,
                                                  ln_factor => po.jaqy327fac2,
                                                  ln_cpoten => po.jaqy327cptn);
      
      end loop;
    
    else
      if lc_SacoInfo = 'DP' then
      
        begin
          select s.sng001pais, s.sng001tdoc, s.sng001ndoc
            into ln_pais, ln_tdoc, lc_ndoc
            from sng001 s
           where s.sng001inst = ln_Instancia;
        exception
          when others then
            null;
        end;
      
        for pd in Log_PtnclDispo loop
          pq_cr_reportelineas_ef.sp_cr_logpotencial(ln_pais   => ln_pais,
                                                    ln_tdoc   => ln_tdoc,
                                                    lc_ndoc   => lc_ndoc,
                                                    ln_inst   => ln_Instancia,
                                                    ld_frcc   => pd.aqpa417frcc,
                                                    lc_enti   => pd.aqpa417enti,
                                                    lc_relac  => 'Integrante',
                                                    ln_util   => 0.00,
                                                    ln_nutil  => pd.aqpa417gast,
                                                    ln_factor => pd.aqpa417fact,
                                                    ln_cpoten => pd.aqpa417cptn);
        
        end loop;
      else
        if lc_SacoInfo = 'AC' then
        
          begin
            select s.sng001pais, s.sng001tdoc, s.sng001ndoc
              into ln_pais, ln_tdoc, lc_ndoc
              from sng001 s
             where s.sng001inst = ln_Instancia;
          exception
            when others then
              null;
          end;
        
          for pd in log_PtnclActuEval loop
            pq_cr_reportelineas_ef.sp_cr_logpotencial(ln_pais   => ln_pais,
                                                      ln_tdoc   => ln_tdoc,
                                                      lc_ndoc   => lc_ndoc,
                                                      ln_inst   => ln_Instancia,
                                                      ld_frcc   => pd.aqpa421frcc,
                                                      lc_enti   => pd.aqpa421enti,
                                                      lc_relac  => 'Integrante',
                                                      ln_util   => 0.00,
                                                      ln_nutil  => pd.aqpa421gast,
                                                      ln_factor => pd.aqpa421fact,
                                                      ln_cpoten => pd.aqpa421cptn);
          
          end loop;
        end if;
      end if;
    end if;
  
  end sp_cr_CuotaPtncl;
  -----------------------------------------------------------------
  procedure sp_cr_CuotaPtncDP(ln_Instancia in number,
                              ln_pgcod     in number,
                              ln_suct      in number,
                              ln_modt      in number,
                              ln_tran      in number,
                              ln_relt      in number,
                              ld_fect      in date,
                              lc_SacoInfo  in varchar2) is
  
    cursor log_PtnclDispo is
    
      select a.aqpa417frcc,
             a.aqpa417enti,
             a.aqpa417gast,
             a.aqpa417fact,
             a.aqpa417cptn
        from aqpa417 a
       where a.aqpa417inst = ln_Instancia
         and a.aqpa417pgcod = ln_pgcod
         and a.aqpa417itsuc = ln_suct
         and a.aqpa417itmod = ln_modt
         and a.aqpa417ittra = ln_tran
         and a.aqpa417itnrel = ln_relt
         and a.aqpa417itfcon = ld_fect;
  
    ln_pais number;
    ln_tdoc number;
    lc_ndoc varchar2(12);
  
  begin
  
    if lc_SacoInfo = 'DP' then
    
      begin
        select s.sng001pais, s.sng001tdoc, s.sng001ndoc
          into ln_pais, ln_tdoc, lc_ndoc
          from sng001 s
         where s.sng001inst = ln_Instancia;
      exception
        when others then
          null;
      end;
    
      for pd in Log_PtnclDispo loop
        pq_cr_reportelineas_ef.sp_cr_logpotencial(ln_pais   => ln_pais,
                                                  ln_tdoc   => ln_tdoc,
                                                  lc_ndoc   => lc_ndoc,
                                                  ln_inst   => ln_Instancia,
                                                  ld_frcc   => pd.aqpa417frcc,
                                                  lc_enti   => pd.aqpa417enti,
                                                  lc_relac  => 'Integrante',
                                                  ln_util   => 0.00,
                                                  ln_nutil  => pd.aqpa417gast,
                                                  ln_factor => pd.aqpa417fact,
                                                  ln_cpoten => pd.aqpa417cptn);
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaPtncDP;
  -----------------------------------------------------------------  
  procedure sp_cr_LogCuentas(ln_corr      in number,
                             ld_fecpro    in date,
                             lc_hora      in character,
                             lc_user      in varchar2,
                             ln_pais      in number,
                             ln_tdoc      in number,
                             lc_ndoc      in varchar2,
                             ln_tcamb     in number,
                             ln_instancia in number,
                             ld_feval     in date,
                             ld_fical     in date,
                             ln_pgcod     in number,
                             ln_mod       in number,
                             ln_suc       in number,
                             ln_mda       in number,
                             ln_pap       in number,
                             ln_cta       in number,
                             ln_ope       in number,
                             ln_sbop      in number,
                             ln_tope      in number,
                             ln_ori       in number,
                             ln_ncuo      in number,
                             lc_est       in varchar2,
                             ln_tarea     in varchar2,
                             lc_indcred   in varchar2,
                             ln_naux1     in number,
                             ln_naux2     in number,
                             ln_naux3     in number) is
  
    lc_horar character(8) := '00:00:00';
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_horar from dual;
    end;
  
    begin
    
      insert into AQPA362
        (AQPA362CORR,
         AQPA362HORAR,
         AQPA362FEC,
         AQPA362HORA,
         AQPA362USER,
         AQPA362PAIS,
         AQPA362TDOC,
         AQPA362NDOC,
         AQPA362TCAMB,
         AQPA362INST,
         AQPA362FEVAL,
         AQPA362FICAL,
         AQPA362PGCOD,
         AQPA362MOD,
         AQPA362SUC,
         AQPA362MDA,
         AQPA362PAP,
         AQPA362CTA,
         AQPA362OPE,
         AQPA362SBOP,
         AQPA362TOPE,
         AQPA362ORI,
         AQPA362NCUO,
         AQPA362EST,
         AQPA362TAREA,
         AQPA362INDCRED,
         AQPA362NAUX1,
         AQPA362NAUX2,
         AQPA362NAUX3)
      values
        (ln_corr,
         lc_horar,
         ld_fecpro,
         lc_hora,
         lc_user,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_tcamb,
         ln_instancia,
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
         ln_ori,
         ln_ncuo,
         lc_est,
         ln_tarea,
         lc_indcred,
         ln_naux1,
         ln_naux2,
         ln_naux3);
      commit;
    
    end;
  
  end sp_cr_LogCuentas;
  ----------------------------------------------------------------
  procedure sp_cr_LogRatioPeriodo(ln_corr    in number,
                                  ld_fec     in date,
                                  lc_hora    in character,
                                  lc_user    in varchar2,
                                  ln_pais    in number,
                                  ln_tdoc    in number,
                                  lc_ndoc    in varchar2,
                                  ln_tcamb   in number,
                                  ln_inst    in number,
                                  ld_feval   in date,
                                  ld_fecal   in date,
                                  lc_mesanio in varchar2,
                                  ln_capcaja in number,
                                  ln_ifis    in number,
                                  ln_resneto in number,
                                  ln_ccontg  in number,
                                  ln_cpoten  in number,
                                  ln_ratio   in number,
                                  ln_est     in varchar2,
                                  lc_tarea   in varchar2,
                                  ln_naux1   in number,
                                  ln_naux2   in number,
                                  ln_naux3   in number) is
  
    lc_horar character(8) := '00:00:00';
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_horar from dual;
    end;
  
    begin
      insert into aqpa363
        (aqpa363corr,
         aqpa363horar,
         aqpa363fec,
         aqpa363hora,
         aqpa363user,
         aqpa363pais,
         aqpa363tdoc,
         aqpa363ndoc,
         aqpa363tcamb,
         aqpa363inst,
         aqpa363feval,
         aqpa363fecal,
         aqpa363mesanio,
         aqpa363capcaja,
         aqpa363ifis,
         aqpa363resneto,
         aqpa363ccontg,
         aqpa363cpoten,
         aqpa363ratio,
         aqpa363est,
         aqpa363tarea,
         aqpa363naux1,
         aqpa363naux2,
         aqpa363naux3)
      values
        (ln_corr,
         lc_horar,
         ld_fec,
         lc_hora,
         lc_user,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_tcamb,
         ln_inst,
         ld_feval,
         ld_fecal,
         lc_mesanio,
         ln_capcaja,
         ln_ifis,
         ln_resneto,
         ln_ccontg,
         ln_cpoten,
         ln_ratio,
         ln_est,
         lc_tarea,
         ln_naux1,
         ln_naux2,
         ln_naux3);
      commit;
    end;
  
  end sp_cr_LogRatioPeriodo;

  ------------------------------------------------------------
  procedure sp_cr_MaxRatio(ln_corr    in number,
                           ln_pais    in number,
                           ln_tdoc    in number,
                           lc_ndoc    in varchar2,
                           ln_tcamb   in number,
                           ln_inst    in number,
                           ld_fec     in date,
                           lc_hora    in character,
                           lc_user    in varchar2,
                           lc_mesanio in varchar2,
                           ln_capcaja in number,
                           ln_ifis    in number,
                           ln_resneto in number,
                           ln_ccontg  in number,
                           ln_cpoten  in number,
                           ln_ratio   in number,
                           lc_est     in varchar2,
                           lc_tarea   in varchar2,
                           ln_naux1   in number,
                           ln_naux2   in number,
                           ln_naux3   in number) is
  
    lc_horar character(8) := '00:00:00';
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_horar from dual;
    end;
  
    begin
      insert into aqpa364
        (aqpa364corr,
         aqpa364horar,
         aqpa364pais,
         aqpa364tdoc,
         aqpa364ndoc,
         aqpa364tcamb,
         aqpa364inst,
         aqpa364fec,
         aqpa364hora,
         aqpa364user,
         aqpa364mesanio,
         aqpa364capcaja,
         aqpa364ifis,
         aqpa364resneto,
         aqpa364ccontg,
         aqpa364cpoten,
         aqpa364ratio,
         aqpa364est,
         aqpa364tarea,
         aqpa364naux1,
         aqpa364naux2,
         aqpa364naux3)
      
      values
        (ln_corr,
         lc_horar,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_tcamb,
         ln_inst,
         ld_fec,
         lc_hora,
         lc_user,
         lc_mesanio,
         ln_capcaja,
         ln_ifis,
         ln_resneto,
         ln_ccontg,
         ln_cpoten,
         ln_ratio,
         lc_est,
         lc_tarea,
         ln_naux1,
         ln_naux2,
         ln_naux3);
      commit;
    end;
  
  end sp_cr_MaxRatio;
  ---------------------------------------------------------------
  procedure sp_cr_ActMntCuotaAE(ln_Instancia in number,
                                lc_mesanio   in varchar2,
                                lc_flgprg    in varchar2) is
  
    cursor Lista_OtrosCred(lc_estado varchar2) is
    -- Cursor Creditos que no son Linea (Solo Linea Utilizada) ni Desembolso Parcial
      select a.aqpa352apgcod   ln_pgcod,
             a.aqpa352amod     ln_mod,
             a.aqpa352asuc     ln_suc,
             a.aqpa352amda     ln_mda,
             a.aqpa352apap     ln_pap,
             a.aqpa352acta     ln_cta,
             a.aqpa352aope     ln_ope,
             a.aqpa352asbop    ln_sbop,
             a.aqpa352atope    ln_tope,
             a.aqpa352aindcred lc_IndCred,
             a.aqpa352atcamb   ln_tipcamb
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
             a.aqpa352aindcred lc_IndCred,
             a.aqpa352atcamb   ln_tipcamb
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
             a.aqpa352aindcred lc_IndCred,
             a.aqpa352atcamb   ln_tipcamb
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
             a.aqpa352aindcred lc_IndCred,
             a.aqpa352atcamb   ln_tipcamb
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
             a.aqpa352aindcred lc_IndCred,
             a.aqpa352atcamb   ln_tipcamb
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
             a.aqpa352aindcred lc_IndCred,
             a.aqpa352atcamb   ln_tipcamb
        from aqpa352a a
       where a.aqpa352ainst = ln_Instancia
         and a.aqpa352aest = lc_estado
         and a.aqpa352aori = 7 -- Desembolsos parciales
         and a.aqpa352aindcred = 'CredVuelo';
  
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
  
    for oc in Lista_OtrosCred(lc_estado) loop
    
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
    
      --if oc.ln_mod <> 117 then
      begin
        update aqpa352a a
           set a.aqpa352anaux1 = ln_MntCuoMes
         where a.aqpa352apgcod = oc.ln_pgcod
           and a.aqpa352amod = oc.ln_mod
           and a.aqpa352asuc = oc.ln_suc
           and a.aqpa352amda = oc.ln_mda
           and a.aqpa352apap = oc.ln_pap
           and a.aqpa352acta = oc.ln_cta
           and a.aqpa352aope = oc.ln_ope
           and a.aqpa352asbop = oc.ln_sbop
           and a.aqpa352atope = oc.ln_tope
           and a.aqpa352ainst = ln_Instancia
           and a.aqpa352aest = lc_estado;
        commit;
      end;
    
      -- else
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
              select a.aqpa410afcon
                into ld_FchCalend
                from AQPA410A a
               where a.AQPA410Ainst = ln_Instancia
                 and a.AQPA410Acorr = NroCreOtorg
                 and a.AQPA410Aesta = 'S';
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
                update aqpa352a a
                   set a.aqpa352anaux1 = ln_MntCuoMes
                 where a.aqpa352apgcod = oc.ln_pgcod
                   and a.aqpa352amod = oc.ln_mod
                   and a.aqpa352asuc = oc.ln_suc
                   and a.aqpa352amda = oc.ln_mda
                   and a.aqpa352apap = oc.ln_pap
                   and a.aqpa352acta = oc.ln_cta
                   and a.aqpa352aope = oc.ln_ope
                   and a.aqpa352asbop = oc.ln_sbop
                   and a.aqpa352atope = oc.ln_tope
                   and a.aqpa352ainst = ln_Instancia
                   and a.aqpa352aest = lc_estado;
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
            
              if ld_UltDia = ld_FchFin then
              
                ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
                begin
                  ln_MntCuoMes := ln_MntCuoMes + ln_CuoDisp;
                  ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
                end;
              
                begin
                  update aqpa352a a
                     set a.aqpa352anaux1 = ln_MntCuoMes
                   where a.aqpa352apgcod = oc.ln_pgcod
                     and a.aqpa352amod = oc.ln_mod
                     and a.aqpa352asuc = oc.ln_suc
                     and a.aqpa352amda = oc.ln_mda
                     and a.aqpa352apap = oc.ln_pap
                     and a.aqpa352acta = oc.ln_cta
                     and a.aqpa352aope = oc.ln_ope
                     and a.aqpa352asbop = oc.ln_sbop
                     and a.aqpa352atope = oc.ln_tope
                     and a.aqpa352ainst = ln_Instancia
                     and a.aqpa352aest = lc_estado;
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
              select a.aqpa410afcon
                into ld_FchCalend
                from AQPA410A a
               where a.AQPA410Ainst = ln_Instancia
                 and a.AQPA410Acorr = ln_MaxPlazAdi
                 and a.AQPA410Aesta = 'S';
            exception
              when others then
                null;
            end;
          
            if ld_FchCalend = ld_FchFin then
              begin
                update aqpa352a a
                   set a.aqpa352anaux3 = ln_CuoCapAdi
                 where a.aqpa352apgcod = oc.ln_pgcod
                   and a.aqpa352amod = oc.ln_mod
                   and a.aqpa352asuc = oc.ln_suc
                   and a.aqpa352amda = oc.ln_mda
                   and a.aqpa352apap = oc.ln_pap
                   and a.aqpa352acta = oc.ln_cta
                   and a.aqpa352aope = oc.ln_ope
                   and a.aqpa352asbop = oc.ln_sbop
                   and a.aqpa352atope = oc.ln_tope
                   and a.aqpa352ainst = ln_Instancia
                   and a.aqpa352aest = lc_estado;
                commit;
              end;
            end if;
          
          end if;
        end if;
      end if;
    end loop;
  
    for lv in linea_vuelo(lc_estado) loop
    
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
        select a.aqpa410afcon
          into ld_FchCalend
          from AQPA410A a
         where a.AQPA410Ainst = ln_Instancia
           and a.AQPA410Acorr = ln_MaxPlazAdi
           and a.AQPA410Aesta = 'S';
      exception
        when others then
          null;
      end;
    
      if ld_FchCalend = ld_FchFin then
        begin
          update aqpa352a a
             set a.aqpa352anaux3 = ln_CuoCapAdi
           where a.aqpa352apgcod = lv.ln_pgcod
             and a.aqpa352amod = lv.ln_mod
             and a.aqpa352asuc = lv.ln_suc
             and a.aqpa352amda = lv.ln_mda
             and a.aqpa352apap = lv.ln_pap
             and a.aqpa352acta = lv.ln_cta
             and a.aqpa352aope = lv.ln_ope
             and a.aqpa352asbop = lv.ln_sbop
             and a.aqpa352atope = lv.ln_tope
             and a.aqpa352ainst = ln_Instancia
             and a.aqpa352aest = lc_estado;
          commit;
        end;
      end if;
    
    end loop;
  
    for lg in linea_vigente(lc_estado) loop
    
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
        select a.aqpa410afcon
          into ld_FchCalend
          from AQPA410A a
         where a.AQPA410Ainst = ln_Instancia
           and a.AQPA410Acorr = ln_MaxPlazAdi + 1
           and a.AQPA410Aesta = 'S';
      exception
        when others then
          null;
      end;
    
      if ld_FchCalend = ld_FchFin then
        begin
          update aqpa352a a
             set a.aqpa352anaux3 = ln_CuoCapAdi
           where a.aqpa352apgcod = lg.ln_pgcod
             and a.aqpa352amod = lg.ln_mod
             and a.aqpa352asuc = lg.ln_suc
             and a.aqpa352amda = lg.ln_mda
             and a.aqpa352apap = lg.ln_pap
             and a.aqpa352acta = lg.ln_cta
             and a.aqpa352aope = lg.ln_ope
             and a.aqpa352asbop = lg.ln_sbop
             and a.aqpa352atope = lg.ln_tope
             and a.aqpa352ainst = ln_Instancia
             and a.aqpa352aest = lc_estado;
          commit;
        end;
      end if;
    
    end loop;
  
    for lc in linea_vencida(lc_estado) loop
    
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
        update aqpa352a a
           set a.aqpa352anaux1 = ln_MntCuoMes
         where a.aqpa352apgcod = lc.ln_pgcod
           and a.aqpa352amod = lc.ln_mod
           and a.aqpa352asuc = lc.ln_suc
           and a.aqpa352amda = lc.ln_mda
           and a.aqpa352apap = lc.ln_pap
           and a.aqpa352acta = lc.ln_cta
           and a.aqpa352aope = lc.ln_ope
           and a.aqpa352asbop = lc.ln_sbop
           and a.aqpa352atope = lc.ln_tope
           and a.aqpa352ainst = ln_Instancia
           and a.aqpa352aest = lc_estado;
        commit;
      end;
    
    end loop;
  
    for cp in credito_parcial(lc_estado) loop
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
          update aqpa352a a
             set a.aqpa352anaux1 = ln_MntCuoMes
           where a.aqpa352apgcod = cp.ln_pgcod
             and a.aqpa352amod = cp.ln_mod
             and a.aqpa352asuc = cp.ln_suc
             and a.aqpa352amda = cp.ln_mda
             and a.aqpa352apap = cp.ln_pap
             and a.aqpa352acta = cp.ln_cta
             and a.aqpa352aope = cp.ln_ope
             and a.aqpa352asbop = cp.ln_sbop
             and a.aqpa352atope = cp.ln_tope
             and a.aqpa352ainst = ln_Instancia
             and a.aqpa352aest = lc_estado;
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
            update aqpa352a a
               set a.aqpa352anaux1 = ln_MntCuoMes
             where a.aqpa352apgcod = cp.ln_pgcod
               and a.aqpa352amod = cp.ln_mod
               and a.aqpa352asuc = cp.ln_suc
               and a.aqpa352amda = cp.ln_mda
               and a.aqpa352apap = cp.ln_pap
               and a.aqpa352acta = cp.ln_cta
               and a.aqpa352aope = cp.ln_ope
               and a.aqpa352asbop = cp.ln_sbop
               and a.aqpa352atope = cp.ln_tope
               and a.aqpa352ainst = ln_Instancia
               and a.aqpa352aest = lc_estado;
            commit;
          end;
        
        end if;
      end if;
    end loop;
  
    for pv in Lista_ParcVuelo(lc_estado) loop
    
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
        update aqpa352a a
           set a.aqpa352anaux1 = ln_MntCuoMes
         where a.aqpa352apgcod = pv.ln_pgcod
           and a.aqpa352amod = pv.ln_mod
           and a.aqpa352asuc = pv.ln_suc
           and a.aqpa352amda = pv.ln_mda
           and a.aqpa352apap = pv.ln_pap
           and a.aqpa352acta = pv.ln_cta
           and a.aqpa352aope = pv.ln_ope
           and a.aqpa352asbop = pv.ln_sbop
           and a.aqpa352atope = pv.ln_tope
           and a.aqpa352ainst = ln_Instancia
           and a.aqpa352aest = lc_estado;
        commit;
      end;
    end loop;
  
  end sp_cr_ActMntCuotaAE;
  -----------------------------------------------------------------
  procedure sp_Cr_ActCuotaAQPA362AC(ln_instancia in number) is
  
    cursor lista_update is
      select a.aqpa352acorr,
             a.aqpa352afec,
             a.aqpa352auser,
             a.aqpa352apais,
             a.aqpa352atdoc,
             a.aqpa352andoc,
             a.aqpa352ainst,
             a.aqpa352apgcod,
             a.aqpa352amod,
             a.aqpa352asuc,
             a.aqpa352amda,
             a.aqpa352apap,
             a.aqpa352acta,
             a.aqpa352aope,
             a.aqpa352asbop,
             a.aqpa352atope,
             a.aqpa352anaux1
        from aqpa352a a
       where a.aqpa352ainst = ln_instancia;
  
  begin
  
    for l in lista_update loop
    
      begin
        update aqpa362 a
           set a.aqpa362naux1 = l.aqpa352anaux1
         where a.aqpa362inst = ln_instancia
           and a.aqpa362pgcod = l.aqpa352apgcod
           and a.aqpa362mod = l.aqpa352amod
           and a.aqpa362suc = l.aqpa352asuc
           and a.aqpa362mda = l.aqpa352amda
           and a.aqpa362pap = l.aqpa352apap
           and a.aqpa362cta = l.aqpa352acta
           and a.aqpa362ope = l.aqpa352aope
           and a.aqpa362sbop = l.aqpa352asbop
           and a.aqpa362tope = l.aqpa352atope;
        commit;
      end;
    
    end loop;
  
  end sp_Cr_ActCuotaAQPA362AC;
  ---------------------------------------------------------
  procedure sp_cr_logpotencial(ln_pais   in number,
                               ln_tdoc   in number,
                               lc_ndoc   in varchar2,
                               ln_inst   in number,
                               ld_frcc   in date,
                               lc_enti   in varchar2,
                               lc_relac  in varchar2,
                               ln_util   in number,
                               ln_nutil  in number,
                               ln_factor in number,
                               ln_cpoten in number) is
  
    lc_horar character(8) := '00:00:00';
    ln_corr  number(5) := 0;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_horar from dual;
    end;
  
    begin
      select max(a.aqpa365corr)
        into ln_corr
        from aqpa365 a
       where a.aqpa365pais = ln_pais
         and a.aqpa365tdoc = ln_tdoc
         and a.aqpa365ndoc = lc_ndoc;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      insert into aqpa365
        (aqpa365corr,
         aqpa365horar,
         aqpa365pais,
         aqpa365tdoc,
         aqpa365ndoc,
         aqpa365inst,
         aqpa365frcc,
         aqpa365enti,
         aqpa365relac,
         aqpa365util,
         aqpa365nutil,
         aqpa365factor,
         aqpa365cpoten)
      values
        (ln_corr + 1,
         lc_horar,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_inst,
         ld_frcc,
         lc_enti,
         lc_relac,
         ln_util,
         ln_nutil,
         ln_factor,
         ln_cpoten);
      commit;
    end;
  
  end sp_cr_logpotencial;
  ----------------------------------------------------------------  
end PQ_CR_REPORTELINEAS_EF;
/

