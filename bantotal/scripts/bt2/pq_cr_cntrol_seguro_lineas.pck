create or replace package PQ_CR_CNTROL_SEGURO_LINEAS is

  -- Author  : MPOSTIGOC
  -- Created : 8/08/2023 12:34:29
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_inicio(ln_pgcodt  in number,
                         ln_suct    in number,
                         ln_modt    in number,
                         ln_ttran   in number,
                         ln_relt    in number,
                         ln_ordt    in number,
                         ln_sbort   in number,
                         lc_pcancel out varchar2,
                         lc_mensjae out varchar2);
  ---------------------------------------------------------  
  procedure sp_Cr_log_AQPB167(ln_pgtx    in number,
                              ln_suct    in number,
                              ln_modt    in number,
                              ln_ttran   in number,
                              ln_relt    in number,
                              ln_ordt    in number,
                              ln_sbor    in number,
                              ln_pgcod   in number,
                              ln_mod     in number,
                              ln_suc     in number,
                              ln_mda     in number,
                              ln_pap     in number,
                              ln_cta     in number,
                              ln_ope     in number,
                              ln_sbop    in number,
                              ln_tope    in number,
                              ld_fdes    in date,
                              ln_nseg    in number,
                              lc_pcancel in varchar2,
                              lc_mensaje in varchar2);

end PQ_CR_CNTROL_SEGURO_LINEAS;
/

create or replace package body PQ_CR_CNTROL_SEGURO_LINEAS is

  procedure sp_cr_inicio(ln_pgcodt  in number,
                         ln_suct    in number,
                         ln_modt    in number,
                         ln_ttran   in number,
                         ln_relt    in number,
                         ln_ordt    in number,
                         ln_sbort   in number,
                         lc_pcancel out varchar2,
                         lc_mensjae out varchar2) is
  
    ln_pgcod116  number;
    ln_mod116    number;
    ln_suc116    number;
    ln_mda116    number;
    ln_pap116    number;
    ln_cta116    number;
    ln_ope116    number;
    ln_sbop116   number;
    ln_tope116   number;
    ln_fchdesemb date;
    ld_fchValid  date;
    ln_nrosegs   number;
  
  begin
  
    lc_pcancel := 'N';
    ln_nrosegs := 0;
  
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
        into ln_pgcod116,
             ln_mod116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_ope116,
             ln_sbop116,
             ln_tope116
        from fsd016 f
       where f.pgcod = ln_pgcodt
         and f.itsuc = ln_suct
         and f.itmod = ln_modt
         and f.ittran = ln_ttran
         and f.itnrel = ln_relt
         and f.itord = ln_ordt
         and f.itsbor = ln_sbort;
    exception
      when others then
        null;
    end;
  
    begin
      select f.AOFVAL
        into ln_fchdesemb
        from fsd010 f
       where f.PGCOD = ln_pgcod116
         and f.AOMOD = 117
         and f.AOCTA = ln_cta116
         and f.AOSUC = ln_suc116
         and f.AOMDA = ln_mda116
         and f.AOPAP = ln_pap116
         and f.AOSBOP = ln_sbop116
         and f.AOTOPE = ln_tope116
         and f.AOSTAT = 0;
    exception
      when others then
        null;
    end;
  
    begin
      select to_date(f.tp1desc, 'dd/mm/yyyy')
        into ld_fchValid
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 122
         and f.tp1corr3 = 1
         and f.tp1nro3 = 1;
    exception
      when others then
        null;
    end;
  
    if ln_fchdesemb < ld_fchValid then
    
      begin
        -- Verifica seguros
        select count(*)
          into ln_nrosegs
          from fpp001 f
         where f.pgcod = ln_pgcod116
           and f.aomod = ln_mod116
           and f.aosuc = ln_suc116
           and f.aomda = ln_mda116
           and f.aopap = ln_pap116
           and f.aocta = ln_cta116
           and f.aooper = ln_ope116
           and f.aosbop = ln_sbop116
           and f.aotope = ln_tope116
           and f.sgcod in (select h.sgcod
                             from fst300 h
                            where h.sgsn02 = 5
                              and h.sgcod >= 351);
      exception
        when others then
          ln_nrosegs := 0;
      end;
    
      if ln_nrosegs > 0 then
        lc_pcancel := 'D';
        lc_mensjae := 'No corresponde Seguros para esta Linea';
      
      else
        lc_pcancel := 'N';
        lc_mensjae := 'Existoso';
      
      end if;
    
    else
      if ln_fchdesemb >= ld_fchValid then
      
        begin
          -- seguro duplicado
          select count(*)
            into ln_nrosegs
            from fpp001 f
           where f.pgcod = ln_pgcod116
             and f.aomod = ln_mod116
             and f.aosuc = ln_suc116
             and f.aomda = ln_mda116
             and f.aopap = ln_pap116
             and f.aocta = ln_cta116
             and f.aooper = ln_ope116
             and f.aosbop = ln_sbop116
             and f.aotope = ln_tope116
             and f.sgcod in (select h.sgcod
                               from fst300 h
                              where h.sgsn02 = 5
                                and h.sgcod >= 351);
        exception
          when others then
            ln_nrosegs := 0;
        end;
      
        if ln_nrosegs > 1 then
          lc_pcancel := 'F';
          lc_mensjae := 'Verificar seguros, más de lo permitido';
        
        else
          lc_pcancel := 'N';
          lc_mensjae := 'Existoso';
        
        end if;
      end if;
    end if;
  
    begin
      pq_Cr_cntrol_seguro_lineas.sp_Cr_log_AQPB167(ln_pgtx    => ln_pgcodt,
                                                   ln_suct    => ln_suct,
                                                   ln_modt    => ln_modt,
                                                   ln_ttran   => ln_ttran,
                                                   ln_relt    => ln_relt,
                                                   ln_ordt    => ln_ordt,
                                                   ln_sbor    => ln_sbort,
                                                   ln_pgcod   => ln_pgcod116,
                                                   ln_mod     => ln_mod116,
                                                   ln_suc     => ln_suc116,
                                                   ln_mda     => ln_mda116,
                                                   ln_pap     => ln_pap116,
                                                   ln_cta     => ln_cta116,
                                                   ln_ope     => ln_ope116,
                                                   ln_sbop    => ln_sbop116,
                                                   ln_tope    => ln_tope116,
                                                   ld_fdes    => ln_fchdesemb,
                                                   ln_nseg    => ln_nrosegs,
                                                   lc_pcancel => lc_pcancel,
                                                   lc_mensaje => lc_mensjae);
    exception
      when others then
        null;
    end;
  end;
  ----------------------------------------------------------
  procedure sp_Cr_log_AQPB167(ln_pgtx    in number,
                              ln_suct    in number,
                              ln_modt    in number,
                              ln_ttran   in number,
                              ln_relt    in number,
                              ln_ordt    in number,
                              ln_sbor    in number,
                              ln_pgcod   in number,
                              ln_mod     in number,
                              ln_suc     in number,
                              ln_mda     in number,
                              ln_pap     in number,
                              ln_cta     in number,
                              ln_ope     in number,
                              ln_sbop    in number,
                              ln_tope    in number,
                              ld_fdes    in date,
                              ln_nseg    in number,
                              lc_pcancel in varchar2,
                              lc_mensaje in varchar2) is
  
    ln_corr    number;
    lc_hora    char(8) := '00:00:00';
    ld_fchsist date;
  
  begin
  
    begin
      select f.pgfape into ld_fchsist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb167corr)
        into ln_corr
        from aqpb167 a
       where a.aqpb167fec = ld_fchsist;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb167
        (aqpb167corr,
         aqpb167fec,
         aqpb167hora,
         aqpb167pgtx,
         aqpb167suct,
         aqpb167modt,
         aqpb167ttran,
         aqpb167relt,
         aqpb167ordt,
         aqpb167sbor,
         aqpb167pgcod,
         aqpb167mod,
         aqpb167suc,
         aqpb167mda,
         aqpb167pap,
         aqpb167cta,
         aqpb167ope,
         aqpb167sbop,
         aqpb167tope,
         aqpb167fdes,
         aqpb167nseg,
         aqpb167pcancel,
         aqpb167msnj)
      values
        (ln_corr + 1,
         ld_fchsist,
         lc_hora,
         ln_pgtx,
         ln_suct,
         ln_modt,
         ln_ttran,
         ln_relt,
         ln_ordt,
         ln_sbor,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ld_fdes,
         ln_nseg,
         lc_pcancel,
         lc_mensaje);
    exception
      when others then
        null;
    end;
  
  end sp_Cr_log_AQPB167;
  ----------------------------------------------------------

end PQ_CR_CNTROL_SEGURO_LINEAS;
/

