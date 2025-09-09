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
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
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
                             lv_enlimt    in varchar2);
  ------------------------------------------------------------
  procedure sp_cr_RTE_UPDAQPD059(ln_pgcodt in number,
                                 ln_suct   in number,
                                 ln_modt   in number,
                                 ln_ttran  in number,
                                 ln_relt   in number,
                                 ln_ordt   in number);
  ---------------------------------------------------------
  procedure sp_Cr_UpdAQPD059(ln_instancia in number, ln_indicar in number);

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
  
  begin
  
    lc_EstaLimi := 'S';
  
    begin
      update aqpd059 a
         set a.aqpd059est = 'I'
       where a.aqpd059inst = ln_Instancia;
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
               and w.xwfcar3 = '1';
          exception
            when others then
              ln_CapRepr := 0;
          end;
        
          if ln_CapRepr <= ln_MaxSaldRepro then
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
                                                  lv_enlimt    => lc_EstaLimi);
        
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
               and w.xwfprcins = ln_Instancia;
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
        
          if ln_CapRepr <= ln_MaxSaldRepro then
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
                                                  lv_enlimt    => lc_EstaLimi);
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
                             lv_enlimt    in varchar2) is
  
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
         aqpd059est)
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
         'H');
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
      select max(b.aqpb200fecha) into ld_FchMxLim from aqpb200 b;
    exception
      when others then
        null;
    end;
  
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
    commit;
  
  end sp_Cr_UpdAQPD059;
  -----------------------------------------------------------------
end PQ_CR_CNTRL_LIMITREPRO;
/
