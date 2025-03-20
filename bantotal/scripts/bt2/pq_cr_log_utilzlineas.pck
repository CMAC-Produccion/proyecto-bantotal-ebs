create or replace package PQ_CR_LOG_UTILZLINEAS is

  -- Author  : MPOSTIGOC
  -- Created : 18/07/2023 09:03:48
  -- Purpose : 

  procedure sp_cr_inicio(ln_pgcodt in number,
                         ln_suct   in number,
                         ln_modt   in number,
                         ln_ttran  in number,
                         ln_relt   in number,
                         ln_ordt   in number,
                         ln_sbort  in number);
  ---------------------------------------------------
  procedure sp_cr_LogAQPB164(ln_inst  in number,
                             ln_pais  in number,
                             ln_tdoc  in number,
                             ln_ndoc  in varchar2,
                             ln_pgcod in number,
                             ln_mod   in number,
                             ln_suc   in number,
                             ln_mda   in number,
                             ln_pap   in number,
                             ln_cta   in number,
                             ln_ope   in number,
                             ln_sbop  in number,
                             ln_tope  in number,
                             ln_pgtx  in number,
                             ln_suct  in number,
                             ln_modt  in number,
                             ln_ttran in number,
                             ln_relt  in number,
                             ln_ordt  in number,
                             ln_sbor  in number,
                             lc_ident in varchar2);

end PQ_CR_LOG_UTILZLINEAS;
/

create or replace package body PQ_CR_LOG_UTILZLINEAS is

  procedure sp_cr_inicio(ln_pgcodt in number,
                         ln_suct   in number,
                         ln_modt   in number,
                         ln_ttran  in number,
                         ln_relt   in number,
                         ln_ordt   in number,
                         ln_sbort  in number) is
  
    ln_pgcod116    number;
    ln_mod116      number;
    ln_suc116      number;
    ln_mda116      number;
    ln_pap116      number;
    ln_cta116      number;
    ln_ope116      number;
    ln_sbop116     number;
    ln_tope116     number;
    ln_pgcod117    number;
    ln_mod117      number;
    ln_suc117      number;
    ln_mda117      number;
    ln_pap117      number;
    ln_cta117      number;
    ln_ope117      number;
    ln_sbop117     number;
    ln_tope117     number;
    ln_NroDispscns number := 0;
    lc_Tipo        varchar2(30);
    ln_instancia   number;
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ld_fchSist     date;
    ln_NroRel      number;
    ModAnu         number;
  
  begin
  
    if ln_modt < 500 then
    
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
        select f.r2cod,
               f.r2mod,
               f.r2suc,
               f.r2mda,
               f.r2pap,
               f.r2cta,
               f.r2oper,
               f.r2sbop,
               f.r2tope
          into ln_pgcod117,
               ln_mod117,
               ln_suc117,
               ln_mda117,
               ln_pap117,
               ln_cta117,
               ln_ope117,
               ln_sbop117,
               ln_tope117
          from fsr011 f
         where f.r1cod = ln_pgcod116
           and f.r1mod = ln_mod116
           and f.r1suc = ln_suc116
           and f.r1mda = ln_mda116
           and f.r1pap = ln_pap116
           and f.r1cta = ln_cta116
           and f.r1oper = ln_ope116
           and f.r1sbop = ln_sbop116
           and f.r1tope = ln_tope116
           and f.relcod = 46
           and f.r011co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_NroDispscns
          from fsr011 f
         where f.r2cod = ln_pgcod117
           and f.r2mod = ln_mod117
           and f.r2suc = ln_suc117
           and f.r2mda = ln_mda117
           and f.r2pap = ln_pap117
           and f.r2cta = ln_cta117
           and f.r2oper = ln_ope117
           and f.r2sbop = ln_sbop117
           and f.r2tope = ln_tope117
           and f.relcod = 46
           and f.r011co = 'S';
      exception
        when others then
          null;
      end;
    
      if ln_NroDispscns = 1 then
        lc_Tipo := 'NUEVO';
      else
        if ln_NroDispscns > 1 then
          lc_Tipo := 'RECURRENTE';
        end if;
      end if;
    
      begin
        ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod117,
                                             v_Scsuc  => ln_suc117,
                                             v_Scmda  => ln_mda117,
                                             v_Scpap  => ln_pap117,
                                             v_Sccta  => ln_cta117,
                                             v_Scoper => ln_ope117,
                                             v_Scsbop => ln_sbop117,
                                             v_Sctope => ln_tope117);
      end;
    
      begin
        select s.sng001pais, s.sng001tdoc, s.sng001ndoc
          into ln_pais, ln_tdoc, lc_ndoc
          from sng001 s
         where s.sng001inst = ln_instancia;
      exception
        when others then
          null;
      end;
    
      ln_instancia := nvl(ln_instancia, 0);
    
      begin
        PQ_CR_LOG_UTILZLINEAS.sp_cr_LogAQPB164(ln_inst  => ln_instancia,
                                               ln_pais  => ln_pais,
                                               ln_tdoc  => ln_tdoc,
                                               ln_ndoc  => lc_ndoc,
                                               ln_pgcod => ln_pgcod116,
                                               ln_mod   => ln_mod116,
                                               ln_suc   => ln_suc116,
                                               ln_mda   => ln_mda116,
                                               ln_pap   => ln_pap116,
                                               ln_cta   => ln_cta116,
                                               ln_ope   => ln_ope116,
                                               ln_sbop  => ln_sbop116,
                                               ln_tope  => ln_tope116,
                                               ln_pgtx  => ln_pgcodt,
                                               ln_suct  => ln_suct,
                                               ln_modt  => ln_modt,
                                               ln_ttran => ln_ttran,
                                               ln_relt  => ln_relt,
                                               ln_ordt  => ln_ordt,
                                               ln_sbor  => ln_sbort,
                                               lc_ident => lc_Tipo);
        /*  exception
        when others then
          null;*/
      end;
    
    else
      if ln_modt > 500 then
      
        begin
        
          select f.pgfape into ld_fchSist from fst017 f where f.pgcod = 1;
        exception
          when others then
            null;
        end;
      
        begin
          select to_number(Txtext)
            into ln_NroRel
            from FSX015
           Where PgCod = ln_pgcodt
             and Hcmod = ln_modt
             and Hsucor = ln_suct
             and Htran = ln_ttran
             and Hnrel = ln_relt
             and Hfcon = ld_fchSist
             and Txcod = 0
             and Txreng = 1;
        exception
          when others then
            null;
        end;
      
        ModAnu := ln_modt - 500;
      
        begin
          update aqpb164 a
             set a.aqpb164est = 'E'
           where a.aqpb164pgtx = ln_pgcodt
             and a.aqpb164suct = ln_suct
             and a.aqpb164modt = ModAnu
             and a.aqpb164ttran = ln_ttran
             and a.aqpb164relt = ln_NroRel
             and a.aqpb164ordt = ln_ordt
             and a.aqpb164sbor = ln_sbort;
        exception
          when others then
            null;
        end;
      
      end if;
    end if;
  
  end sp_cr_inicio;
  ------------------------------------------------------------------
  procedure sp_cr_LogAQPB164(ln_inst  in number,
                             ln_pais  in number,
                             ln_tdoc  in number,
                             ln_ndoc  in varchar2,
                             ln_pgcod in number,
                             ln_mod   in number,
                             ln_suc   in number,
                             ln_mda   in number,
                             ln_pap   in number,
                             ln_cta   in number,
                             ln_ope   in number,
                             ln_sbop  in number,
                             ln_tope  in number,
                             ln_pgtx  in number,
                             ln_suct  in number,
                             ln_modt  in number,
                             ln_ttran in number,
                             ln_relt  in number,
                             ln_ordt  in number,
                             ln_sbor  in number,
                             lc_ident in varchar2) is
    ld_fec  date;
    lc_hora varchar2(8) := '00:00:00';
    ln_corr number := 0;
  
  begin
    begin
      select max(a.aqpb164corr)
        into ln_corr
        from aqpb164 a
       where a.aqpb164inst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select f.pgfape into ld_fec from fst017 f where f.pgcod = 1;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb164
        (aqpb164corr,
         aqpb164inst,
         aqpb164pais,
         aqpb164tdoc,
         aqpb164ndoc,
         aqpb164fec,
         aqpb164hora,
         aqpb164pgcod,
         aqpb164mod,
         aqpb164suc,
         aqpb164mda,
         aqpb164pap,
         aqpb164cta,
         aqpb164ope,
         aqpb164sbop,
         aqpb164tope,
         aqpb164pgtx,
         aqpb164suct,
         aqpb164modt,
         aqpb164ttran,
         aqpb164relt,
         aqpb164ordt,
         aqpb164sbor,
         aqpb164ident,
         aqpb164est)
      values
        (ln_corr + 1,
         ln_inst,
         ln_pais,
         ln_tdoc,
         ln_ndoc,
         ld_fec,
         lc_hora,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_pgtx,
         ln_suct,
         ln_modt,
         ln_ttran,
         ln_relt,
         ln_ordt,
         ln_sbor,
         lc_ident,
         'H');
    end;
  end;
  ------------------------------------------------------------------
end PQ_CR_LOG_UTILZLINEAS;
/

