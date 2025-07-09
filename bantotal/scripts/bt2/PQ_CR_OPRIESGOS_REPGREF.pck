create or replace package PQ_CR_OPRIESGOS_REPGREF is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_OPRIESGOS_REPGREF
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 26/06/2025 18:12:59
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Controles para Ajuste Opinión de Riesgos Reprogramados y Refinanciados
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  procedure sp_Cr_NroReproRiesgos(ln_instancia in number,
                                  ln_NroReprog out number);
  ---------------------------------------------------------------------
  procedure sp_Cr_LogAQPD060(ln_inst      in number,
                             ln_cta       in number,
                             ln_operacion in number,
                             ln_nroreprog in number);
  ---------------------------------------------------------------------
  procedure sp_cr_VerfReprgRef(ln_instancia    in number,
                               lc_VerfReprgRef out varchar2);
  ----------------------------------------------------------------------                               
  procedure sp_Cr_LogAQPD061(ln_inst       in number,
                             ln_cta        in number,
                             ln_operacion  in number,
                             ld_fmaxreprog in date,
                             lv_CambEstado in varchar2);
  -----------------------------------------------------------------------
end PQ_CR_OPRIESGOS_REPGREF;
/
create or replace package body PQ_CR_OPRIESGOS_REPGREF is

  procedure sp_Cr_NroReproRiesgos(ln_instancia in number,
                                  ln_NroReprog out number) is
  
    ln_TipSol    number;
    ln_cuenta    number;
    ln_operacion number;
  
  begin
  
    ln_NroReprog := 0;
  
    begin
      select s.sng001ori
        into ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        ln_TipSol := 0;
    end;
  
    if ln_TipSol in (13, 14, 16) then
    
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
        update aqpd060 a
           set a.aqpd060est = 'I'
         where a.aqpd060inst = ln_instancia
           and a.aqpd060est = 'H';
        commit;
      end;
    
      begin
        select count(distinct a.aqpb836fec)
          into ln_NroReprog
          from aqpb836 a
         where a.aqpb836emp = 1
           and a.aqpb836cta = ln_cuenta
           and a.aqpb836oper = ln_operacion
           and TRIM(AQPB836TIP) NOT IN ('EXCL. OM-19109', 'EXCL. OM-63223');
      exception
        when others then
          ln_NroReprog := 0;
      end;
    
      PQ_CR_OPRIESGOS_REPGREF.sp_Cr_LogAQPD060(ln_inst      => ln_instancia,
                                               ln_cta       => ln_cuenta,
                                               ln_operacion => ln_operacion,
                                               ln_nroreprog => ln_NroReprog);
    end if;
  
  end sp_Cr_NroReproRiesgos;
  -----------------------------------------------------------
  procedure sp_Cr_LogAQPD060(ln_inst      in number,
                             ln_cta       in number,
                             ln_operacion in number,
                             ln_nroreprog in number) is
  
    ln_cor     number := 0;
    lv_hora    varchar2(10) := '00:00:00';
    ld_FchSist date;
  
  begin
  
    begin
      select max(a.aqpd060cor)
        into ln_cor
        from aqpd060 a
       where a.aqpd060inst = ln_inst;
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
      insert into aqpd060
        (aqpd060cor,
         aqpd060fecha,
         aqpd060hora,
         aqpd060inst,
         aqpd060cta,
         aqpd060operacion,
         aqpd060nroreprog,
         aqpd060est)
      values
        (ln_cor + 1,
         ld_FchSist,
         lv_hora,
         ln_inst,
         ln_cta,
         ln_operacion,
         ln_nroreprog,
         'H');
      commit;
    end;
  
  end sp_Cr_LogAQPD060;
  -----------------------------------------------------------
  procedure sp_cr_VerfReprgRef(ln_instancia    in number,
                               lc_VerfReprgRef out varchar2) is
  
    ln_TipSol        number;
    ln_cuenta        number;
    ln_operacion     number;
    ld_MaxReprog     date;
    ln_CambEstReprog number;
  
  begin
  
    lc_VerfReprgRef := 'N';
  
    begin
      select s.sng001ori
        into ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        ln_TipSol := 0;
    end;
  
    if ln_TipSol = 3 then
    
      begin
        select x.xwfcuenta, x.xwfoperacion
          into ln_cuenta, ln_operacion
          from xwf700 x
         where x.xwfprcins = ln_instancia
           and x.xwfcar3 <> '1';
      exception
        when others then
          null;
      end;
    
      begin
        update aqpd061 a
           set a.aqpd061est = 'I'
         where a.aqpd061inst = ln_instancia
           and a.aqpd061est = 'H';
        commit;
      end;
    
      begin
        select max(distinct a.aqpb836fec)
          into ld_MaxReprog
          from aqpb836 a
         where a.aqpb836emp = 1
           and a.aqpb836cta = ln_cuenta
           and a.aqpb836oper = ln_operacion;
      exception
        when others then
          null;
      end;
    
      if ld_MaxReprog is not null then
      
        begin
          select count(*)
            into ln_CambEstReprog
            from aqpb836 a
           where a.aqpb836emp = 1
             and a.aqpb836cta = ln_cuenta
             and a.aqpb836oper = ln_operacion
             and a.aqpb836fec = ld_MaxReprog
             and TRIM(AQPB836TIP) IN ('EXCL. OM-19109', 'EXCL. OM-63223');
        exception
          when others then
            null;
        end;
      
        if ln_CambEstReprog > 0 then
          lc_VerfReprgRef := 'N';
        else
          lc_VerfReprgRef := 'S';
        end if;
      end if;
    
      PQ_CR_OPRIESGOS_REPGREF.sp_Cr_LogAQPD061(ln_inst       => ln_instancia,
                                               ln_cta        => ln_cuenta,
                                               ln_operacion  => ln_operacion,
                                               ld_fmaxreprog => ld_MaxReprog,
                                               lv_CambEstado => lc_VerfReprgRef);
    
    end if;
  
  end sp_cr_VerfReprgRef;
  -----------------------------------------------------------
  procedure sp_Cr_LogAQPD061(ln_inst       in number,
                             ln_cta        in number,
                             ln_operacion  in number,
                             ld_fmaxreprog in date,
                             lv_CambEstado in varchar2) is
  
    ln_cor     number := 0;
    lv_hora    varchar2(10) := '00:00:00';
    ld_FchSist date;
  
  begin
  
    begin
      select max(a.aqpd060cor)
        into ln_cor
        from aqpd060 a
       where a.aqpd060inst = ln_inst;
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
      insert into aqpd061
        (aqpd061cor,
         aqpd061fecha,
         aqpd061hora,
         aqpd061inst,
         aqpd061cta,
         aqpd061operacion,
         aqpd061fmaxreprog,
         aqpd061cestreprg,
         aqpd061est)
      values
        (ln_cor + 1,
         ld_FchSist,
         lv_hora,
         ln_inst,
         ln_cta,
         ln_operacion,
         ld_fmaxreprog,
         lv_CambEstado,
         'H');
      commit;
    end;
  
  end sp_Cr_LogAQPD061;
end PQ_CR_OPRIESGOS_REPGREF;
/
