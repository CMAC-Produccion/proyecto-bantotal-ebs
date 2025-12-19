create or replace package PQ_CR_CNTRL_LIMITREPRO is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_CNTRL_LIMITREPRO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 25/06/2025 15:05:50
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Control en el Limite de reprogramaciones por region - Riesgos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 25/09/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego validacion de Control de Opinion de Riesgos
  -- Fecha de Modificación      : 19/11/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego Validacion para control de Limites por Agencia y Nacional
  -- *****************************************************************

  procedure sp_Cr_Inicio(ln_Instancia in number,
                         ln_Indicador in number,
                         lc_EstaLimi  out varchar2);
  ---------------------------------------------------
  procedure sp_Cr_LogAQPD059(ln_inst      in number,
                             ln_modali    in number,
                             ln_codreg    in number,
                             lv_region    in varchar2,
                             ln_saldreprt in number,
                             ln_mntacumt  in number,
                             ln_mntdisp   in number,
                             ln_capcred   in number,
                             lv_enlimt    in varchar2,
                             lv_IndOR     in varchar2);
  ------------------------------------------------------------
  procedure sp_cr_RTE_UPDAQPD059(ln_pgcodt in number,
                                 ln_suct   in number,
                                 ln_modt   in number,
                                 ln_ttran  in number,
                                 ln_relt   in number,
                                 ln_ordt   in number);
  ---------------------------------------------------------
  procedure sp_Cr_UpdAQPD059(ln_instancia in number, ln_indicar in number);
  --------------------------------------------------------------------------
  procedure sp_Cr_LimiteAgencia(ln_Instancia  in number,
                                ln_Indicador  in number,
                                lc_EstaLimAge out varchar2);
  ----------------------------------------------------------------------------
  procedure sp_cr_LogAQPD066(ln_inst      in number,
                             ln_modali    in number,
                             ln_codsuc    in number,
                             lv_sucur     in varchar2,
                             ln_saldreprt in number,
                             ln_mntacumt  in number,
                             ln_mntdisp   in number,
                             ln_capcred   in number,
                             lv_enlimt    in varchar2,
                             lv_IndOR     in varchar2,
                             lv_IndBE     in varchar2);
  ----------------------------------------------------------------------------
  procedure sp_Cr_LimtNacional(ln_Instancia  in number,
                               ln_Indicador  in number,
                               lc_EstaLimNac out varchar2);
  -------------------------------------------------------------------------------
  procedure sp_cr_LogAQPD067(ln_inst      in number,
                             ln_modali    in number,
                             ln_codpai    in number,
                             lv_pais      in varchar2,
                             ln_saldreprt in number,
                             ln_mntacumt  in number,
                             ln_mntdisp   in number,
                             ln_capcred   in number,
                             lv_enlimt    in varchar2,
                             lv_IndOR     in varchar2,
                             lv_IndBE     in varchar2);

end PQ_CR_CNTRL_LIMITREPRO;
/
create or replace package body PQ_CR_CNTRL_LIMITREPRO is

  procedure sp_Cr_Inicio(ln_Instancia in number,
                         ln_Indicador in number,
                         lc_EstaLimi  out varchar2) is
  
    ln_RegCred      number;
    ld_FchCargLim   date;
    ln_CapRepr      number(17, 2);
    ln_MaxSaldRepro number(17, 2);
    ln_OriSol       number;
    lv_NombReg      varchar2(50);
    ln_SalRepTotal  number(17, 2) := 0.00;
    ln_MntAcuRepr   number(17, 2) := 0.00;
    ln_cuenta       number;
    ln_operacion    number;
    ln_NroReprog    number;
    vi_tieneOpinion number;
    vi_TipoOpinion  varchar2(5);
    vi_mensaje      varchar(300);
    Lv_IndOpRiesg   varchar2(5) := 'N';
    ln_dia          number;
    ln_tdoc         number;
    lv_ndoc         varchar2(12);
    lc_score        varchar2(15);
    ln_probal       number(9, 7);
    lc_SegmRiesgo   varchar2(15);
    ln_PDCal        number(9, 7);
    lc_tabla        varchar2(15);
    ld_fchscore     date;
    lc_scoreabr     varchar2(10);
    lc_NewScore     Varchar2(30);
  
  begin
  
    lc_EstaLimi := 'S';
  
    begin
      select extract(day from f.pgfape)
        into ln_dia
        from fst017 f
       where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpd059 a
         set a.aqpd059est = 'I'
       where a.aqpd059inst = ln_Instancia;
      commit;
    end;
  
    begin
      select s.sng001tdoc, s.sng001ndoc
        into ln_tdoc, lv_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_Indicador = 1 then
    
      begin
        select s.sng001ori
          into ln_OriSol
          from sng001 s
         where s.sng001inst = ln_Instancia;
      exception
        when others then
          ln_OriSol := 0;
      end;
    
      if ln_OriSol in (13, 14, 16) then
      
        begin
          select x.xwfcuenta, x.xwfoperacion
            into ln_cuenta, ln_operacion
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        begin
          select count(distinct a.aqpb836fec)
            into ln_NroReprog
            from aqpb836 a
           where a.aqpb836emp = 1
             and a.aqpb836cta = ln_cuenta
             and a.aqpb836oper = ln_operacion
             and TRIM(AQPB836TIP) NOT IN
                 ('EXCL. OM-19109', 'EXCL. OM-63223');
        exception
          when others then
            ln_NroReprog := 0;
        end;
      
        if ln_NroReprog = 0 then
        
          begin
            select r.regcod, r.regnom
              into ln_RegCred, lv_NombReg
              from regsuc r
             where r.sucurs = (select x.xwfsucursal
                                 from xwf700 x
                                where x.xwfprcins = ln_Instancia
                                  and x.xwfcar3 <> '1');
          exception
            when others then
              ln_RegCred := 0;
          end;
        
          begin
            select max(a.aqpb200fecha) into ld_FchCargLim from aqpb200 a;
          exception
            when others then
              null;
          end;
        
          begin
            select a.aqpb200saldcalt, a.aqpb200mntact, a.aqpb200saldrep
              into ln_SalRepTotal, ln_MntAcuRepr, ln_MaxSaldRepro
              from aqpb200 a
             where a.aqpb200fecha = ld_FchCargLim
               and a.aqpb200codreg = ln_RegCred
               and a.aqpb200est = 'H';
          exception
            when others then
              ln_MaxSaldRepro := 0;
          end;
        
          begin
            select x.xllcapital
              into ln_CapRepr
              from xwf700 w, x054023 x
             where w.xwfempresa = x.xllpgcod
               and w.xwfsucursal = x.xllaosuc
               and w.xwfmodulo = x.xllaomod
               and w.xwfmoneda = x.xllaomda
               and w.xwfpapel = x.xllaopap
               and w.xwfcuenta = x.xllaocta
               and w.xwfoperacion = x.xllaooper
               and w.xwfsubope = x.xllaosbop
               and w.xwftipope = x.xllaotop
               and w.xwfprcins = ln_Instancia
               and w.xwfcar3 = '1'
               and rownum = 1;
          exception
            when others then
              ln_CapRepr := 0;
          end;
        
          if ln_CapRepr <= ln_MaxSaldRepro or ln_dia = 1 then
            lc_EstaLimi := 'S';
          else
            lc_EstaLimi := 'N';
          end if;
        
          pq_cr_cntrl_limitrepro.sp_Cr_LogAQPD059(ln_inst      => ln_Instancia,
                                                  ln_modali    => ln_Indicador,
                                                  ln_codreg    => ln_RegCred,
                                                  lv_region    => lv_NombReg,
                                                  ln_saldreprt => ln_SalRepTotal,
                                                  ln_mntacumt  => ln_MntAcuRepr,
                                                  ln_mntdisp   => ln_MaxSaldRepro,
                                                  ln_capcred   => ln_CapRepr,
                                                  lv_enlimt    => lc_EstaLimi,
                                                  lv_IndOR     => Lv_IndOpRiesg);
        
        end if;
      end if;
    
    else
      if ln_Indicador = 2 then
      
        begin
          select x.xwfcuenta, x.xwfoperacion
            into ln_cuenta, ln_operacion
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        begin
          select count(distinct a.aqpb836fec)
            into ln_NroReprog
            from aqpb836 a
           where a.aqpb836emp = 1
             and a.aqpb836cta = ln_cuenta
             and a.aqpb836oper = ln_operacion
             and TRIM(AQPB836TIP) NOT IN
                 ('EXCL. OM-19109', 'EXCL. OM-63223');
        exception
          when others then
            ln_NroReprog := 0;
        end;
      
        if ln_NroReprog = 0 then
          begin
            select x.xllcapital
              into ln_CapRepr
              from X054023 x, xwf700 w
             where x.xllpgcod = w.xwfempresa
               and x.xllaomod = w.xwfmodulo
               and x.xllaosuc = w.xwfsucursal
               and x.xllaomda = w.xwfmoneda
               and x.xllaopap = w.xwfpapel
               and x.xllaocta = w.xwfcuenta
               and x.xllaooper = w.xwfoperacion
               and x.xllaosbop = 609
               and w.xwfprcins = ln_Instancia
               and rownum = 1;
          exception
            when others then
              ln_CapRepr := 0;
          end;
        
          begin
            select r.regcod, r.regnom
              into ln_RegCred, lv_NombReg
              from regsuc r
             where r.sucurs =
                   (select s.sng001age
                      from sng001 s
                     where s.sng001inst = ln_Instancia);
          exception
            when others then
              ln_RegCred := 0;
          end;
        
          begin
            select max(a.aqpb200fecha) into ld_FchCargLim from aqpb200 a;
          exception
            when others then
              null;
          end;
        
          begin
            select a.aqpb200saldcalt, a.aqpb200mntact, a.aqpb200saldrep
              into ln_SalRepTotal, ln_MntAcuRepr, ln_MaxSaldRepro
              from aqpb200 a
             where a.aqpb200fecha = ld_FchCargLim
               and a.aqpb200codreg = ln_RegCred
               and a.aqpb200est = 'H';
          exception
            when others then
              ln_MaxSaldRepro := 0;
          end;
        
          ln_CapRepr := 120000;
          if ln_CapRepr <= ln_MaxSaldRepro or ln_dia = 1 then
            lc_EstaLimi := 'S';
          else
            lc_EstaLimi := 'N';
          end if;
        
          if lc_EstaLimi = 'N' then
          
            Pq_Cr_Score_Rcc.sp_cr_scoreDNI_II(ln_inst       => ln_Instancia,
                                              ln_tdoc       => ln_tdoc,
                                              lc_ndoc       => trim(lv_ndoc),
                                              lc_prgm       => 'LIMTREGNL',
                                              lc_user       => 'REPSNCAP',
                                              lc_score      => lc_score,
                                              ln_probal     => ln_probal,
                                              lc_SegmRiesgo => lc_SegmRiesgo,
                                              ln_PDCal      => ln_PDCal,
                                              lc_tabla      => lc_tabla,
                                              ld_fchscore   => ld_fchscore,
                                              lc_scoreabr   => lc_scoreabr,
                                              lc_NewScore   => lc_NewScore);
          
            pq_cr_reprogramaexo.sp_validaopinion(ln_Instancia,
                                                 vi_tieneOpinion,
                                                 vi_TipoOpinion,
                                                 vi_mensaje);
            lc_NewScore := trim(lc_NewScore);
          
            If vi_tieneOpinion = 1 and TRIM(vi_TipoOpinion) = 'V' and
               (lc_NewScore = 'POTENCIAL' or lc_NewScore = 'SUSTANCIAL') THEN
              lc_EstaLimi   := 'S';
              Lv_IndOpRiesg := 'S';
            end if;
          
          end if;
        
          pq_cr_cntrl_limitrepro.sp_Cr_LogAQPD059(ln_inst      => ln_Instancia,
                                                  ln_modali    => ln_Indicador,
                                                  ln_codreg    => ln_RegCred,
                                                  lv_region    => lv_NombReg,
                                                  ln_saldreprt => ln_SalRepTotal,
                                                  ln_mntacumt  => ln_MntAcuRepr,
                                                  ln_mntdisp   => ln_MaxSaldRepro,
                                                  ln_capcred   => ln_CapRepr,
                                                  lv_enlimt    => lc_EstaLimi,
                                                  lv_IndOR     => Lv_IndOpRiesg);
        end if;
      end if;
    end if;
  
  end sp_Cr_Inicio;
  ------------------------------------------------------------------
  procedure sp_Cr_LogAQPD059(ln_inst      in number,
                             ln_modali    in number,
                             ln_codreg    in number,
                             lv_region    in varchar2,
                             ln_saldreprt in number,
                             ln_mntacumt  in number,
                             ln_mntdisp   in number,
                             ln_capcred   in number,
                             lv_enlimt    in varchar2,
                             lv_IndOR     in varchar2) is
  
    ln_cor     number := 0;
    lv_hora    varchar2(10) := '00:00:00';
    ld_FchSist date;
  
  begin
  
    begin
      select max(a.aqpd059cor)
        into ln_cor
        from aqpd059 a
       where a.aqpd059inst = ln_inst;
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpd059
        (aqpd059cor,
         aqpd059fecha,
         aqpd059hora,
         aqpd059inst,
         aqpd059modali,
         aqpd059codreg,
         aqpd059region,
         aqpd059saldreprt,
         aqpd059mntacumt,
         aqpd059mntdisp,
         aqpd059capcred,
         aqpd059enlimt,
         aqpd059desemb,
         aqpd059est,
         aqpd059indor)
      values
        (ln_cor + 1,
         ld_FchSist,
         lv_hora,
         ln_inst,
         ln_modali,
         ln_codreg,
         lv_region,
         ln_saldreprt,
         ln_mntacumt,
         ln_mntdisp,
         ln_capcred,
         lv_enlimt,
         'N',
         'H',
         lv_IndOR);
    exception
      when others then
        null;
    end;
    commit;
  
  end sp_Cr_LogAQPD059;
  -----------------------------------------------------------
  procedure sp_cr_RTE_UPDAQPD059(ln_pgcodt in number,
                                 ln_suct   in number,
                                 ln_modt   in number,
                                 ln_ttran  in number,
                                 ln_relt   in number,
                                 ln_ordt   in number) is
  
    ln_pgcod     number;
    ln_mod       number;
    ln_suc       number;
    ln_mda       number;
    ln_pap       number;
    ln_cta       number;
    ln_ope       number;
    ln_sub       number;
    ln_tope      number;
    ln_instancia number;
  
  begin
    begin
      select f.pgcod,
             f.modulo,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo,
             f.ittope
        into ln_pgcod,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sub,
             ln_tope
        from fsd016 f
       where f.pgcod = ln_pgcodt
         and f.itsuc = ln_suct
         and f.itmod = ln_modt
         and f.ittran = ln_ttran
         and f.itnrel = ln_relt
         and f.itord = ln_ordt;
    exception
      when others then
        null;
    end;
  
    ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                         v_Scsuc  => ln_suc,
                                         v_Scmda  => ln_mda,
                                         v_Scpap  => ln_pap,
                                         v_Sccta  => ln_cta,
                                         v_Scoper => ln_ope,
                                         v_Scsbop => ln_sub,
                                         v_Sctope => ln_tope);
  
    pq_Cr_cntrl_limitrepro.sp_Cr_UpdAQPD059(ln_instancia => ln_instancia,
                                            ln_indicar   => 1);
  
  end sp_cr_RTE_UPDAQPD059;
  ---------------------------------------------------------------
  procedure sp_Cr_UpdAQPD059(ln_instancia in number, ln_indicar in number) is
  
    ln_CapCred  number(17, 2) := 0.00;
    ld_FchMxLim date;
    ln_Region   number;
    ln_suc      number;
  
  begin
  
    begin
      select a.aqpd059codreg, a.aqpd059capcred
        into ln_Region, ln_CapCred
        from aqpd059 a
       where a.aqpd059inst = ln_instancia
         and a.aqpd059est = 'H'
         and a.aqpd059enlimt = 'S';
    exception
      when others then
        ln_Region := 0;
    end;
  
    begin
      select x.xwfsucursal
        into ln_suc
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select max(b.aqpb200fecha) into ld_FchMxLim from aqpb200 b;
    exception
      when others then
        null;
    end;
  
    --REGION
  
    begin
      update aqpd059 a
         set a.aqpd059desemb = 'S'
       where a.aqpd059inst = ln_instancia
         and a.aqpd059modali = ln_indicar
         and a.aqpd059enlimt = 'S'
         and a.aqpd059est = 'H';
    end;
  
    begin
      update aqpb200 a
         set a.aqpb200mntact  = a.aqpb200mntact + ln_CapCred,
             a.aqpb200saldrep = a.aqpb200saldrep - ln_CapCred
       where a.aqpb200fecha = ld_FchMxLim
         and a.aqpb200codreg = ln_Region
         and a.aqpb200est = 'H';
    end;
  
    -- AGENCIA
  
    begin
      update aqpd066 a
         set a.aqpd066desemb = 'S'
       where a.aqpd066inst = ln_instancia
         and a.aqpd066modali = ln_indicar
         and a.aqpd066enlimt = 'S'
         and a.aqpd066est = 'H';
    end;
  
    begin
      update aqpd064 a
         set a.aqpd064mntact    = a.aqpd064mntact + ln_CapCred,
             a.aqpd064sldrepage = a.aqpd064sldrepage - ln_CapCred
       where a.aqpd064fecha = ld_FchMxLim
         and a.aqpd064codreg = ln_Suc
         and a.aqpd064est = 'H';
    end;
  
    -- NACIONAL
    begin
      update aqpd067 a
         set a.aqpd067desemb = 'S'
       where a.aqpd067inst = ln_instancia
         and a.aqpd067modali = ln_indicar
         and a.aqpd067enlimt = 'S'
         and a.aqpd067est = 'H';
    end;
  
    begin
      update aqpd065 a
         set a.aqpd065mntact    = a.aqpd065mntact + ln_CapCred,
             a.aqpd065sldrepNac = a.aqpd065sldrepNac - ln_CapCred
       where a.aqpd065fecha = ld_FchMxLim
         and a.aqpd065codpais = 604
         and a.aqpd065est = 'H';
    end;
  
    commit;
  
  end sp_Cr_UpdAQPD059;
  -----------------------------------------------------------------
  procedure sp_Cr_LimiteAgencia(ln_Instancia  in number,
                                ln_Indicador  in number,
                                lc_EstaLimAge out varchar2) is
  
    ln_SucCred      number;
    ld_FchCargLim   date;
    ln_CapRepr      number(17, 2);
    ln_MaxSaldRepro number(17, 2);
    ln_OriSol       number;
    lv_NombSuc      varchar2(100);
    ln_SalRepTotal  number(17, 2) := 0.00;
    ln_MntAcuRepr   number(17, 2) := 0.00;
    ln_cuenta       number;
    ln_operacion    number;
    ln_NroReprog    number;
    vi_tieneOpinion number;
    vi_TipoOpinion  varchar2(5);
    vi_mensaje      varchar(300);
    Lv_IndOpRiesg   varchar2(5) := 'N';
    ln_dia          number;
  
  begin
  
    lc_EstaLimAge := 'S';
  
    begin
      select extract(day from f.pgfape)
        into ln_dia
        from fst017 f
       where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpd066 a
         set a.aqpd066est = 'I'
       where a.aqpd066inst = ln_Instancia;
      commit;
    end;
  
    if ln_Indicador = 1 then
    
      begin
        select s.sng001ori
          into ln_OriSol
          from sng001 s
         where s.sng001inst = ln_Instancia;
      exception
        when others then
          ln_OriSol := 0;
      end;
    
      if ln_OriSol in (13, 14, 16) then
      
        begin
          select x.xwfcuenta, x.xwfoperacion
            into ln_cuenta, ln_operacion
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        begin
          select count(distinct a.aqpb836fec)
            into ln_NroReprog
            from aqpb836 a
           where a.aqpb836emp = 1
             and a.aqpb836cta = ln_cuenta
             and a.aqpb836oper = ln_operacion
             and TRIM(AQPB836TIP) NOT IN
                 ('EXCL. OM-19109', 'EXCL. OM-63223');
        exception
          when others then
            ln_NroReprog := 0;
        end;
      
        if ln_NroReprog = 0 then
        
          begin
            select x.xwfsucursal
              into ln_SucCred
              from xwf700 x
             where x.xwfprcins = ln_Instancia
               and x.xwfcar3 <> '1';
          exception
            when others then
              ln_SucCred := 0;
          end;
        
          begin
            select r.scnom
              into lv_NombSuc
              from regsuc r
             where r.sucurs = ln_SucCred;
          exception
            when others then
              null;
          end;
        
          begin
            select max(a.aqpd064fecha) into ld_FchCargLim from aqpd064 a;
          exception
            when others then
              null;
          end;
        
          begin
            select a.aqpd064saldlmt, a.aqpd064mntact, a.aqpd064sldrepage
              into ln_SalRepTotal, ln_MntAcuRepr, ln_MaxSaldRepro
              from aqpd064 a
             where a.aqpd064codsuc = ln_SucCred
               and a.aqpd064fecha = ld_FchCargLim
               and a.aqpd064est = 'H';
          exception
            when others then
              ln_MaxSaldRepro := 0;
          end;
        
          begin
            select x.xllcapital
              into ln_CapRepr
              from xwf700 w, x054023 x
             where w.xwfempresa = x.xllpgcod
               and w.xwfsucursal = x.xllaosuc
               and w.xwfmodulo = x.xllaomod
               and w.xwfmoneda = x.xllaomda
               and w.xwfpapel = x.xllaopap
               and w.xwfcuenta = x.xllaocta
               and w.xwfoperacion = x.xllaooper
               and w.xwfsubope = x.xllaosbop
               and w.xwftipope = x.xllaotop
               and w.xwfprcins = ln_Instancia
               and w.xwfcar3 = '1'
               and rownum = 1;
          exception
            when others then
              ln_CapRepr := 0;
          end;
        
          if ln_CapRepr <= ln_MaxSaldRepro or ln_dia = 1 then
            lc_EstaLimAge := 'S';
          else
            lc_EstaLimAge := 'N';
          end if;
        
          pq_cr_cntrl_limitrepro.sp_Cr_LogAQPD066(ln_inst      => ln_Instancia,
                                                  ln_modali    => ln_Indicador,
                                                  ln_codsuc    => ln_SucCred,
                                                  lv_sucur     => lv_NombSuc,
                                                  ln_saldreprt => ln_SalRepTotal,
                                                  ln_mntacumt  => ln_MntAcuRepr,
                                                  ln_mntdisp   => ln_MaxSaldRepro,
                                                  ln_capcred   => ln_CapRepr,
                                                  lv_enlimt    => lc_EstaLimAge,
                                                  lv_IndOR     => Lv_IndOpRiesg,
                                                  lv_IndBE     => 'N');
        
        end if;
      end if;
    
    else
      if ln_Indicador = 2 then
      
        begin
          select x.xwfcuenta, x.xwfoperacion
            into ln_cuenta, ln_operacion
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        begin
          select count(distinct a.aqpb836fec)
            into ln_NroReprog
            from aqpb836 a
           where a.aqpb836emp = 1
             and a.aqpb836cta = ln_cuenta
             and a.aqpb836oper = ln_operacion
             and TRIM(AQPB836TIP) NOT IN
                 ('EXCL. OM-19109', 'EXCL. OM-63223');
        exception
          when others then
            ln_NroReprog := 0;
        end;
      
        if ln_NroReprog = 0 then
          begin
            select x.xllcapital
              into ln_CapRepr
              from X054023 x, xwf700 w
             where x.xllpgcod = w.xwfempresa
               and x.xllaomod = w.xwfmodulo
               and x.xllaosuc = w.xwfsucursal
               and x.xllaomda = w.xwfmoneda
               and x.xllaopap = w.xwfpapel
               and x.xllaocta = w.xwfcuenta
               and x.xllaooper = w.xwfoperacion
               and x.xllaosbop = 609
               and w.xwfprcins = ln_Instancia
               and rownum = 1;
          exception
            when others then
              ln_CapRepr := 0;
          end;
        
          begin
            select x.xwfsucursal
              into ln_SucCred
              from xwf700 x
             where x.xwfprcins = ln_Instancia
               and x.xwfcar3 = '1';
          exception
            when others then
              ln_SucCred := 0;
          end;
        
          begin
            select r.scnom
              into lv_NombSuc
              from regsuc r
             where r.sucurs = ln_SucCred;
          exception
            when others then
              null;
          end;
        
          begin
            select max(a.aqpd064fecha) into ld_FchCargLim from aqpd064 a;
          exception
            when others then
              null;
          end;
        
          begin
            select a.aqpd064saldlmt, a.aqpd064mntact, a.aqpd064sldrepage
              into ln_SalRepTotal, ln_MntAcuRepr, ln_MaxSaldRepro
              from aqpd064 a
             where a.aqpd064fecha = ld_FchCargLim
               and a.aqpd064codsuc = ln_SucCred
               and a.aqpd064est = 'H';
          exception
            when others then
              ln_MaxSaldRepro := 0;
          end;
        
          if ln_CapRepr <= ln_MaxSaldRepro or ln_dia = 1 then
            lc_EstaLimAge := 'S';
          else
            lc_EstaLimAge := 'N';
          end if;
        
          /* if lc_EstaLimAge = 'N' then
            pq_cr_reprogramaexo.sp_validaopinion(ln_Instancia,
                                                 vi_tieneOpinion,
                                                 vi_TipoOpinion,
                                                 vi_mensaje);
          
            If vi_tieneOpinion = 1 and TRIM(vi_TipoOpinion) = 'V' THEN
              lc_EstaLimAge := 'S';
              Lv_IndOpRiesg := 'S';
            end if;
          
          end if;*/
        
          pq_cr_cntrl_limitrepro.sp_Cr_LogAQPD066(ln_inst      => ln_Instancia,
                                                  ln_modali    => ln_Indicador,
                                                  ln_codsuc    => ln_SucCred,
                                                  lv_sucur     => lv_NombSuc,
                                                  ln_saldreprt => ln_SalRepTotal,
                                                  ln_mntacumt  => ln_MntAcuRepr,
                                                  ln_mntdisp   => ln_MaxSaldRepro,
                                                  ln_capcred   => ln_CapRepr,
                                                  lv_enlimt    => lc_EstaLimAge,
                                                  lv_IndOR     => Lv_IndOpRiesg,
                                                  lv_IndBE     => 'N');
        end if;
      end if;
    end if;
  
  end sp_Cr_LimiteAgencia;
  --------------------------------------------------------------
  procedure sp_cr_LogAQPD066(ln_inst      in number,
                             ln_modali    in number,
                             ln_codsuc    in number,
                             lv_sucur     in varchar2,
                             ln_saldreprt in number,
                             ln_mntacumt  in number,
                             ln_mntdisp   in number,
                             ln_capcred   in number,
                             lv_enlimt    in varchar2,
                             lv_IndOR     in varchar2,
                             lv_IndBE     in varchar2) is
  
    ln_cor     number := 0;
    lv_hora    varchar2(10) := '00:00:00';
    ld_FchSist date;
  
  begin
  
    begin
      select max(a.aqpd066cor)
        into ln_cor
        from aqpd066 a
       where a.aqpd066inst = ln_inst;
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
    begin
      insert into aqpd066
        (aqpd066cor,
         aqpd066fecha,
         aqpd066hora,
         aqpd066inst,
         aqpd066modali,
         aqpd066codsuc,
         aqpd066sucur,
         aqpd066saldreprt,
         aqpd066mntacumt,
         aqpd066mntdisp,
         aqpd066capcred,
         aqpd066enlimt,
         aqpd066desemb,
         aqpd066est,
         aqpd066indor,
         aqpd066indBE)
      values
        (ln_cor + 1,
         ld_FchSist,
         lv_hora,
         ln_inst,
         ln_modali,
         ln_codsuc,
         lv_sucur,
         ln_saldreprt,
         ln_mntacumt,
         ln_mntdisp,
         ln_capcred,
         lv_enlimt,
         'N',
         'H',
         lv_IndOR,
         lv_IndBE);
    exception
      when others then
        null;
    end;
    commit;
  
  end sp_cr_LogAQPD066;
  -----------------------------------------------------------------
  procedure sp_Cr_LimtNacional(ln_Instancia  in number,
                               ln_Indicador  in number,
                               lc_EstaLimNac out varchar2) is
  
    ln_SucCred      number;
    ld_FchCargLim   date;
    ln_CapRepr      number(17, 2);
    ln_MaxSaldRepro number(17, 2);
    ln_OriSol       number;
    lv_NombSuc      varchar2(100);
    ln_SalRepTotal  number(17, 2) := 0.00;
    ln_MntAcuRepr   number(17, 2) := 0.00;
    ln_cuenta       number;
    ln_operacion    number;
    ln_NroReprog    number;
    vi_tieneOpinion number;
    vi_TipoOpinion  varchar2(5);
    vi_mensaje      varchar(300);
    Lv_IndOpRiesg   varchar2(5) := 'N';
    ln_dia          number;
  
  begin
  
    lc_EstaLimNac := 'S';
  
    begin
      select extract(day from f.pgfape)
        into ln_dia
        from fst017 f
       where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpd067 a
         set a.aqpd067est = 'I'
       where a.aqpd067inst = ln_Instancia;
      commit;
    end;
  
    if ln_Indicador = 1 then
    
      begin
        select s.sng001ori
          into ln_OriSol
          from sng001 s
         where s.sng001inst = ln_Instancia;
      exception
        when others then
          ln_OriSol := 0;
      end;
    
      if ln_OriSol in (13, 14, 16) then
      
        begin
          select x.xwfcuenta, x.xwfoperacion
            into ln_cuenta, ln_operacion
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        begin
          select count(distinct a.aqpb836fec)
            into ln_NroReprog
            from aqpb836 a
           where a.aqpb836emp = 1
             and a.aqpb836cta = ln_cuenta
             and a.aqpb836oper = ln_operacion
             and TRIM(AQPB836TIP) NOT IN
                 ('EXCL. OM-19109', 'EXCL. OM-63223');
        exception
          when others then
            ln_NroReprog := 0;
        end;
      
        if ln_NroReprog = 0 then
        
          begin
            select x.xwfsucursal
              into ln_SucCred
              from xwf700 x
             where x.xwfprcins = ln_Instancia
               and x.xwfcar3 <> '1';
          exception
            when others then
              ln_SucCred := 0;
          end;
        
          begin
            select r.scnom
              into lv_NombSuc
              from regsuc r
             where r.sucurs = ln_SucCred;
          exception
            when others then
              null;
          end;
        
          begin
            select max(a.aqpd065fecha) into ld_FchCargLim from aqpd065 a;
          exception
            when others then
              null;
          end;
        
          begin
            select a.aqpd065saldlmt, a.aqpd065mntact, a.aqpd065sldrepnac
              into ln_SalRepTotal, ln_MntAcuRepr, ln_MaxSaldRepro
              from aqpd065 a
             where a.aqpd065codpais = 604
               and a.aqpd065fecha = ld_FchCargLim
               and a.aqpd065est = 'H';
          exception
            when others then
              ln_MaxSaldRepro := 0;
          end;
        
          begin
            select x.xllcapital
              into ln_CapRepr
              from xwf700 w, x054023 x
             where w.xwfempresa = x.xllpgcod
               and w.xwfsucursal = x.xllaosuc
               and w.xwfmodulo = x.xllaomod
               and w.xwfmoneda = x.xllaomda
               and w.xwfpapel = x.xllaopap
               and w.xwfcuenta = x.xllaocta
               and w.xwfoperacion = x.xllaooper
               and w.xwfsubope = x.xllaosbop
               and w.xwftipope = x.xllaotop
               and w.xwfprcins = ln_Instancia
               and w.xwfcar3 = '1'
               and rownum = 1;
          exception
            when others then
              ln_CapRepr := 0;
          end;
        
          if ln_CapRepr <= ln_MaxSaldRepro or ln_dia = 1 then
            lc_EstaLimNac := 'S';
          else
            lc_EstaLimNac := 'N';
          end if;
        
          pq_cr_cntrl_limitrepro.sp_Cr_LogAQPD067(ln_inst      => ln_Instancia,
                                                  ln_modali    => ln_Indicador,
                                                  ln_codpai    => 604,
                                                  lv_pais      => 'PERU',
                                                  ln_saldreprt => ln_SalRepTotal,
                                                  ln_mntacumt  => ln_MntAcuRepr,
                                                  ln_mntdisp   => ln_MaxSaldRepro,
                                                  ln_capcred   => ln_CapRepr,
                                                  lv_enlimt    => lc_EstaLimNac,
                                                  lv_IndOR     => Lv_IndOpRiesg,
                                                  lv_IndBE     => 'N');
        
        end if;
      end if;
    
    else
      if ln_Indicador = 2 then
      
        begin
          select x.xwfcuenta, x.xwfoperacion
            into ln_cuenta, ln_operacion
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        begin
          select count(distinct a.aqpb836fec)
            into ln_NroReprog
            from aqpb836 a
           where a.aqpb836emp = 1
             and a.aqpb836cta = ln_cuenta
             and a.aqpb836oper = ln_operacion
             and TRIM(AQPB836TIP) NOT IN
                 ('EXCL. OM-19109', 'EXCL. OM-63223');
        exception
          when others then
            ln_NroReprog := 0;
        end;
      
        if ln_NroReprog = 0 then
          begin
            select x.xllcapital
              into ln_CapRepr
              from X054023 x, xwf700 w
             where x.xllpgcod = w.xwfempresa
               and x.xllaomod = w.xwfmodulo
               and x.xllaosuc = w.xwfsucursal
               and x.xllaomda = w.xwfmoneda
               and x.xllaopap = w.xwfpapel
               and x.xllaocta = w.xwfcuenta
               and x.xllaooper = w.xwfoperacion
               and x.xllaosbop = 609
               and w.xwfprcins = ln_Instancia
               and rownum = 1;
          exception
            when others then
              ln_CapRepr := 0;
          end;
        
          begin
            select x.xwfsucursal
              into ln_SucCred
              from xwf700 x
             where x.xwfprcins = ln_Instancia
               and x.xwfcar3 = '1';
          exception
            when others then
              ln_SucCred := 0;
          end;
        
          begin
            select r.scnom
              into lv_NombSuc
              from regsuc r
             where r.sucurs = ln_SucCred;
          exception
            when others then
              null;
          end;
        
          begin
            select max(a.aqpd064fecha) into ld_FchCargLim from aqpd064 a;
          exception
            when others then
              null;
          end;
        
          begin
            select a.aqpd065saldlmt, a.aqpd065mntact, a.aqpd065sldrepnac
              into ln_SalRepTotal, ln_MntAcuRepr, ln_MaxSaldRepro
              from aqpd065 a
             where a.aqpd065codpais = 604
               and a.aqpd065fecha = ld_FchCargLim
               and a.aqpd065est = 'H';
          exception
            when others then
              ln_MaxSaldRepro := 0;
          end;
        
          if ln_CapRepr <= ln_MaxSaldRepro or ln_dia = 1 then
            lc_EstaLimNac := 'S';
          else
            lc_EstaLimNac := 'N';
          end if;
        
          /*  if lc_EstaLimNac = 'N' then
            pq_cr_reprogramaexo.sp_validaopinion(ln_Instancia,
                                                 vi_tieneOpinion,
                                                 vi_TipoOpinion,
                                                 vi_mensaje);
          
            If vi_tieneOpinion = 1 and TRIM(vi_TipoOpinion) = 'V' THEN
              lc_EstaLimNac := 'S';
              Lv_IndOpRiesg := 'S';
            end if;
          
          end if;*/
        
          pq_cr_cntrl_limitrepro.sp_Cr_LogAQPD067(ln_inst      => ln_Instancia,
                                                  ln_modali    => ln_Indicador,
                                                  ln_codpai    => 604,
                                                  lv_pais      => 'PERU',
                                                  ln_saldreprt => ln_SalRepTotal,
                                                  ln_mntacumt  => ln_MntAcuRepr,
                                                  ln_mntdisp   => ln_MaxSaldRepro,
                                                  ln_capcred   => ln_CapRepr,
                                                  lv_enlimt    => lc_EstaLimNac,
                                                  lv_IndOR     => Lv_IndOpRiesg,
                                                  lv_IndBE     => 'N');
        end if;
      end if;
    end if;
  
  end sp_Cr_LimtNacional;
  -----------------------------------------------------------------
  procedure sp_cr_LogAQPD067(ln_inst      in number,
                             ln_modali    in number,
                             ln_codpai    in number,
                             lv_pais      in varchar2,
                             ln_saldreprt in number,
                             ln_mntacumt  in number,
                             ln_mntdisp   in number,
                             ln_capcred   in number,
                             lv_enlimt    in varchar2,
                             lv_IndOR     in varchar2,
                             lv_IndBE     in varchar2) is
  
    ln_cor     number := 0;
    lv_hora    varchar2(10) := '00:00:00';
    ld_FchSist date;
  
  begin
  
    begin
      select max(a.aqpd067cor)
        into ln_cor
        from aqpd067 a
       where a.aqpd067inst = ln_inst;
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
    begin
      insert into aqpd067
        (aqpd067cor,
         aqpd067fecha,
         aqpd067hora,
         aqpd067inst,
         aqpd067modali,
         aqpd067codpai,
         aqpd067pais,
         aqpd067saldreprt,
         aqpd067mntacumt,
         aqpd067mntdisp,
         aqpd067capcred,
         aqpd067enlimt,
         aqpd067desemb,
         aqpd067est,
         aqpd067indor,
         aqpd067indBE)
      values
        (ln_cor + 1,
         ld_FchSist,
         lv_hora,
         ln_inst,
         ln_modali,
         ln_codpai,
         lv_pais,
         ln_saldreprt,
         ln_mntacumt,
         ln_mntdisp,
         ln_capcred,
         lv_enlimt,
         'N',
         'H',
         lv_IndOR,
         lv_IndBE);
    exception
      when others then
        null;
    end;
    commit;
  
  end sp_cr_LogAQPD067;
  -----------------------------------------------------------------
end PQ_CR_CNTRL_LIMITREPRO;
/
