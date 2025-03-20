create or replace package PQ_CR_FONDO_CRECER is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
  procedure sp_cr_batch;
  ----------------------------------------------------------------------------
  procedure sp_cr_insertAQPA377(ln_pais    in number,
                                ln_tdoc    in number,
                                lc_ndoc    in varchar2,
                                ln_pgcodtr in number,
                                ln_itsuc   in number,
                                ln_itmod   in number,
                                ln_ittran  in number,
                                ln_itnrel  in number,
                                ln_itord   in number,
                                ln_itsbor  in number,
                                lc_htran   in char,
                                ld_ftran   in date,
                                ln_inst    in number,
                                ln_tcred   in varchar2,
                                ln_pgcod   in number,
                                ln_mod     in number,
                                ln_suc     in number,
                                ln_mda     in number,
                                ln_pap     in number,
                                ln_cta     in number,
                                ln_ope     in number,
                                ln_sbop    in number,
                                ln_tope    in number,
                                ln_mnto    in number,
                                lc_indic   in varchar2,
                                lc_est     in varchar2,
                                lc_user    in varchar2);
  ---------------------------------------------------------------------------
  procedure sp_cr_RTEnlinea(ln_pgcodtr in number,
                            ln_itsuc   in number,
                            ln_itmod   in number,
                            ln_ittran  in number,
                            ln_itnrel  in number,
                            ln_itord   in number,
                            ln_itsbor  in number);
  -----------------------------------------------------------------------------
  procedure sp_cr_RNFondoCrecer(ln_instancia in number,
                                lc_PrtnFC    out varchar2);
  -------------------------------------------------------------------------------------------
  procedure sp_cr_ExtornoFC(PPgcod  in number,
                            Pitmod  in number,
                            PItsuc  in number,
                            PIttran in number,
                            PItnrel in number,
                            PItord  in number,
                            PItsbor in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_FONDO_CRECER;
/

create or replace package body PQ_CR_FONDO_CRECER is

  procedure sp_cr_batch is
  
    cursor listado(ld_FchInicio date, ln_MaxMntXPers number) is
      select g.PGCOD,
             g.HCMOD,
             g.HSUCOR,
             g.HTRAN,
             g.HNREL,
             g.HFCON,
             g.HCORD,
             g.HCSUBO,
             g.HMODUL,
             g.HTOPER,
             g.HSUCUR,
             g.HMDA,
             g.HPAP,
             g.HCTA,
             g.HOPER,
             g.HSUBOP,
             g.HCIMP1,
             f.hhora,
             f.husing
        from fsh015 f, fsh016 g
       where f.pgcod = g.PGCOD
         and f.hcmod = g.HCMOD
         and f.hsucor = g.HSUCOR
         and f.htran = g.HTRAN
         and f.hnrel = g.HNREL
         and f.hfcon = g.HFCON
         and f.hccorr <> 99
         and f.hfcon >= ld_FchInicio
         and g.HCIMP1 <= ln_MaxMntXPers
         and (g.HMODUL in
             (select h.modulo from fst111 h where h.dscod = 50) or
             g.HMODUL = 117)
         and (f.hcmod, f.htran) in
             (select t.tp1nro2, t.tp1nro3
                from fst198 t
               where t.tp1cod = 1
                 and t.tp1cod1 = 11138
                 and t.tp1corr1 = 6
                 and t.tp1corr2 = 2)
         and g.hmda = 0;
  
    ld_FchInicio   date;
    ln_MaxMntXPers number(17, 2) := 0.00;
    ln_MaxMntTotal number(17, 2) := 0.00;
    ln_instancia   number;
    LN_TIPOCRED    number;
    lc_tipcred     varchar2(30);
    ln_TipCredOK   number := 0;
    ln_MontoTotal  number(17, 2) := 0.00;
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
  
  begin
  
    begin
      select to_date(Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
                     'DD/MM/YYYY')
        into ld_FchInicio
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11138
         and t.tp1corr1 = 6
         and t.tp1corr2 = 1
         and t.tp1corr3 = 3;
    end;
  
    begin
      select t.tp1imp1
        into ln_MaxMntXPers
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11138
         and t.tp1corr1 = 6
         and t.tp1corr2 = 1
         and t.tp1corr3 = 1;
    exception
      when others then
        ln_MaxMntXPers := 0;
    end;
  
    begin
      select t.tp1imp1
        into ln_MaxMntTotal
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11138
         and t.tp1corr1 = 6
         and t.tp1corr2 = 1
         and t.tp1corr3 = 2;
    exception
      when others then
        ln_MaxMntTotal := 0;
    end;
  
    for l in listado(ld_FchInicio, ln_MaxMntXPers) loop
      LN_TIPOCRED := 0;
    
      ln_instancia := fn_instancia_credito(v_Scmod  => l.hmodul,
                                           v_Scsuc  => l.hsucur,
                                           v_Scmda  => l.hmda,
                                           v_Scpap  => l.hpap,
                                           v_Sccta  => l.hcta,
                                           v_Scoper => l.hoper,
                                           v_Scsbop => l.hsubop,
                                           v_Sctope => l.htoper);
    
      if ln_instancia > 0 then
      
        begin
          select w.wfattsval
            into lc_tipcred
            from wfattsvalues w
           where w.wfinsprcid = ln_instancia
             and w.wfattsid = 'TIPO_CREDITO';
        exception
          when others then
            null;
        end;
      
        LN_TIPOCRED := to_number(substr(lc_tipcred,
                                        1,
                                        INSTR(lc_tipcred, ';') - 1));
      
        begin
          select count(*)
            into ln_TipCredOK
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11138
             and t.tp1corr1 = 6
             and t.tp1corr2 = 3
             and t.tp1nro3 = LN_TIPOCRED;
        exception
          when others then
            ln_TipCredOK := 0;
        end;
      
        if ln_TipCredOK > 0 then
        
          ln_MontoTotal := ln_MontoTotal + l.hcimp1;
        
          if ln_MontoTotal <= ln_MaxMntTotal then
          
            begin
              select f.pepais, f.petdoc, f.pendoc
                into ln_pais, ln_tdoc, lc_ndoc
                from fsr008 f
               where f.pgcod = 1
                 and f.ctnro = l.hcta
                 and f.cttfir = 'T';
            exception
              when others then
                null;
            end;
          
            begin
            
              pq_cr_fondo_crecer.sp_cr_insertAQPA377(ln_pais    => ln_pais,
                                                     ln_tdoc    => ln_tdoc,
                                                     lc_ndoc    => lc_ndoc,
                                                     ln_pgcodtr => l.pgcod,
                                                     ln_itsuc   => l.hsucor,
                                                     ln_itmod   => l.hcmod,
                                                     ln_ittran  => l.htran,
                                                     ln_itnrel  => l.hnrel,
                                                     ln_itord   => l.hcord,
                                                     ln_itsbor  => l.hcsubo,
                                                     lc_htran   => l.hhora,
                                                     ld_ftran   => l.hfcon,
                                                     ln_inst    => ln_instancia,
                                                     ln_tcred   => lc_tipcred,
                                                     ln_pgcod   => l.pgcod,
                                                     ln_mod     => l.hmodul,
                                                     ln_suc     => l.hsucur,
                                                     ln_mda     => l.hmda,
                                                     ln_pap     => l.hpap,
                                                     ln_cta     => l.hcta,
                                                     ln_ope     => l.hoper,
                                                     ln_sbop    => l.hsubop,
                                                     ln_tope    => l.htoper,
                                                     ln_mnto    => l.hcimp1,
                                                     lc_indic   => 'B',
                                                     lc_est     => 'S',
                                                     lc_user    => l.husing);
            end;
          else
            ln_MontoTotal := ln_MontoTotal - l.hcimp1;
          end if;
        
        end if;
      end if;
    
      begin
        update fst198 t
           set t.tp1imp1 = ln_MontoTotal
         where t.tp1cod = 1
           and t.tp1cod1 = 11138
           and t.tp1corr1 = 6
           and t.tp1corr2 = 1
           and t.tp1corr3 = 4;
        commit;
      end;
    
    end loop;
  end;
  --------------------------------------------------------------------------------------
  procedure sp_cr_insertAQPA377(ln_pais    in number,
                                ln_tdoc    in number,
                                lc_ndoc    in varchar2,
                                ln_pgcodtr in number,
                                ln_itsuc   in number,
                                ln_itmod   in number,
                                ln_ittran  in number,
                                ln_itnrel  in number,
                                ln_itord   in number,
                                ln_itsbor  in number,
                                lc_htran   in char,
                                ld_ftran   in date,
                                ln_inst    in number,
                                ln_tcred   in varchar2,
                                ln_pgcod   in number,
                                ln_mod     in number,
                                ln_suc     in number,
                                ln_mda     in number,
                                ln_pap     in number,
                                ln_cta     in number,
                                ln_ope     in number,
                                ln_sbop    in number,
                                ln_tope    in number,
                                ln_mnto    in number,
                                lc_indic   in varchar2,
                                lc_est     in varchar2,
                                lc_user    in varchar2) is
  
    ln_corr number;
    lc_hora char(8) := '00:00:00';
    ld_fec  date;
  
  begin
  
    begin
      select max(a.aqpa377corr)
        into ln_corr
        from aqpa377 a
       where a.aqpa377ftran = ld_ftran;
    end;
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select f.pgfape into ld_fec from FST017 f where f.pgcod = 1;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa377
        (aqpa377corr,
         aqpa377fec,
         aqpa377hora,
         aqpa377pais,
         aqpa377tdoc,
         aqpa377ndoc,
         aqpa377ipgcod,
         aqpa377itsuc,
         aqpa377itmod,
         aqpa377ittran,
         aqpa377itnrel,
         aqpa377itord,
         aqpa377itsbor,
         aqpa377htran,
         aqpa377ftran,
         aqpa377inst,
         AQPA377tcred,
         aqpa377pgcod,
         aqpa377mod,
         aqpa377suc,
         aqpa377mda,
         aqpa377pap,
         aqpa377cta,
         aqpa377ope,
         aqpa377sbop,
         aqpa377tope,
         aqpa377mnto,
         aqpa377indic,
         aqpa377est,
         aqpa377user)
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_pgcodtr,
         ln_itsuc,
         ln_itmod,
         ln_ittran,
         ln_itnrel,
         ln_itord,
         ln_itsbor,
         lc_htran,
         ld_ftran,
         ln_inst,
         ln_tcred,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_mnto,
         lc_indic,
         lc_est,
         lc_user);
      commit;
    end;
  end;
  --------------------------------------------------------------------------------------
  procedure sp_cr_RTEnlinea(ln_pgcodtr in number,
                            ln_itsuc   in number,
                            ln_itmod   in number,
                            ln_ittran  in number,
                            ln_itnrel  in number,
                            ln_itord   in number,
                            ln_itsbor  in number) is
  
    ln_pgcod       number;
    ln_modulo      number;
    ln_itsucd      number;
    ln_moneda      number;
    ln_papel       number;
    ln_ctnro       number;
    ln_itoper      number;
    ln_itsubo      number;
    ln_ittope      number;
    ln_itimp1      number;
    ld_itfcon      date;
    lc_ithora      char(8);
    lc_ituing      varchar2(10);
    ln_instancia   number;
    LN_TIPOCRED    number;
    lc_tipcred     varchar2(30);
    ln_TipCredOK   number := 0;
    ln_MaxMntTotal number(17, 2) := 0.00;
    ln_MontoTotal  number(17, 2) := 0.00;
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
  
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
             f.ittope,
             f.itimp1,
             g.itfcon,
             g.ithora,
             g.ituing
        into ln_pgcod,
             ln_modulo,
             ln_itsucd,
             ln_moneda,
             ln_papel,
             ln_ctnro,
             ln_itoper,
             ln_itsubo,
             ln_ittope,
             ln_itimp1,
             ld_itfcon,
             lc_ithora,
             lc_ituing
        from fsd016 f, FSD015 g
       where f.pgcod = g.pgcod
         and f.itsuc = g.itsuc
         and f.itmod = g.itmod
         and f.ittran = g.ittran
         and f.itnrel = g.itnrel
         and f.pgcod = ln_pgcodtr
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    end;
  
    LN_TIPOCRED := 0;
  
    ln_instancia := fn_instancia_credito(v_Scmod  => ln_modulo,
                                         v_Scsuc  => ln_itsucd,
                                         v_Scmda  => ln_moneda,
                                         v_Scpap  => ln_papel,
                                         v_Sccta  => ln_ctnro,
                                         v_Scoper => ln_itoper,
                                         v_Scsbop => ln_itsubo,
                                         v_Sctope => ln_ittope);
  
    if ln_instancia > 0 then
    
      begin
        select w.wfattsval
          into lc_tipcred
          from wfattsvalues w
         where w.wfinsprcid = ln_instancia
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
    
      LN_TIPOCRED := to_number(substr(lc_tipcred,
                                      1,
                                      INSTR(lc_tipcred, ';') - 1));
    
      begin
        select count(*)
          into ln_TipCredOK
          from fst198 t
         where t.tp1cod = 1
           and t.tp1cod1 = 11138
           and t.tp1corr1 = 6
           and t.tp1corr2 = 3
           and t.tp1nro3 = LN_TIPOCRED;
      exception
        when others then
          ln_TipCredOK := 0;
      end;
    
      if ln_TipCredOK > 0 then
        begin
          select t.tp1imp1
            into ln_MontoTotal
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11138
             and t.tp1corr1 = 6
             and t.tp1corr2 = 1
             and t.tp1corr3 = 4;
        exception
          when others then
            ln_MontoTotal := 0;
        end;
      
        begin
          select t.tp1imp1
            into ln_MaxMntTotal
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11138
             and t.tp1corr1 = 6
             and t.tp1corr2 = 1
             and t.tp1corr3 = 2;
        exception
          when others then
            ln_MaxMntTotal := 0;
        end;
      
        ln_MontoTotal := ln_MontoTotal + ln_itimp1;
      
        if ln_MontoTotal <= ln_MaxMntTotal then
        
          begin
            select f.pepais, f.petdoc, f.pendoc
              into ln_pais, ln_tdoc, lc_ndoc
              from fsr008 f
             where f.pgcod = 1
               and f.ctnro = ln_ctnro
               and f.cttfir = 'T';
          exception
            when others then
              null;
          end;
        
          begin
          
            pq_cr_fondo_crecer.sp_cr_insertAQPA377(ln_pais    => ln_pais,
                                                   ln_tdoc    => ln_tdoc,
                                                   lc_ndoc    => lc_ndoc,
                                                   ln_pgcodtr => ln_pgcodtr,
                                                   ln_itsuc   => ln_itsuc,
                                                   ln_itmod   => ln_itmod,
                                                   ln_ittran  => ln_ittran,
                                                   ln_itnrel  => ln_itnrel,
                                                   ln_itord   => ln_itord,
                                                   ln_itsbor  => ln_itsbor,
                                                   lc_htran   => lc_ithora,
                                                   ld_ftran   => ld_itfcon,
                                                   ln_inst    => ln_instancia,
                                                   ln_tcred   => lc_tipcred,
                                                   ln_pgcod   => ln_pgcod,
                                                   ln_mod     => ln_modulo,
                                                   ln_suc     => ln_itsucd,
                                                   ln_mda     => ln_moneda,
                                                   ln_pap     => ln_papel,
                                                   ln_cta     => ln_ctnro,
                                                   ln_ope     => ln_itoper,
                                                   ln_sbop    => ln_itsubo,
                                                   ln_tope    => ln_ittope,
                                                   ln_mnto    => ln_itimp1,
                                                   lc_indic   => 'L',
                                                   lc_est     => 'S',
                                                   lc_user    => lc_ituing);
          
            begin
              update fst198 t
                 set t.tp1imp1 = ln_MontoTotal
               where t.tp1cod = 1
                 and t.tp1cod1 = 11138
                 and t.tp1corr1 = 6
                 and t.tp1corr2 = 1
                 and t.tp1corr3 = 4;
              commit;
            end;
          end;
        else
          ln_MontoTotal := ln_MontoTotal - ln_itimp1;
        end if;
      
      end if;
    end if;
  
  end sp_cr_RTEnlinea;
  --------------------------------------------------------------------------------------
  procedure sp_cr_RNFondoCrecer(ln_instancia in number,
                                lc_PrtnFC    out varchar2) is
  
    /*ln_capital     number(17, 2) := 0.00;
    LN_TIPOCRED    number;
    lc_tipcred     varchar2(30);
    ln_TipCredOK   number := 0;
    ln_MaxMntTotal number(17, 2) := 0.00;
    ln_MontoTotal  number(17, 2) := 0.00;*/
  
    ln_NroReg number := 0;
  
  begin
  
    /*  LN_TIPOCRED := 0;
    lc_PrtnFC   := 'N';*/
  
    if ln_instancia > 0 then
    
      begin
        select count(*)
          into ln_NroReg
          from aqpa377 a
         where a.aqpa377inst = ln_instancia
           and a.aqpa377est = 'S';
      exception
        when others then
          ln_NroReg := 0;
      end;
    
      if ln_NroReg > 0 then
        lc_PrtnFC := 'S';
      else
        if ln_NroReg = 0 then
          lc_PrtnFC := 'N';
        end if;
      end if;
    
      /* begin
        select w.wfattsval
          into lc_tipcred
          from wfattsvalues w
         where w.wfinsprcid = ln_instancia
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
      
      LN_TIPOCRED := to_number(substr(lc_tipcred,
                                      1,
                                      INSTR(lc_tipcred, ';') - 1));
      
      begin
        select count(*)
          into ln_TipCredOK
          from fst198 t
         where t.tp1cod = 1
           and t.tp1cod1 = 11138
           and t.tp1corr1 = 6
           and t.tp1corr2 = 3
           and t.tp1nro3 = LN_TIPOCRED;
      exception
        when others then
          ln_TipCredOK := 0;
      end;
      
      if ln_TipCredOK > 0 then
        begin
          select w.xllcapital
            into ln_capital
            from xwf700 x, x054023 w
           where x.xwfempresa = w.xllpgcod
             and x.xwfsucursal = w.xllaosuc
             and x.xwfmodulo = w.xllaomod
             and x.xwfmoneda = w.xllaomda
             and x.xwfpapel = w.xllaopap
             and x.xwfcuenta = w.xllaocta
             and x.xwfoperacion = w.xllaooper
             and x.xwfsubope = w.xllaosbop
             and x.xwftipope = w.xllaotop
             and x.xwfprcins = ln_instancia
             and x.xwfcar3 = '1';
        end;
      
        begin
          select t.tp1imp1
            into ln_MontoTotal
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11138
             and t.tp1corr1 = 6
             and t.tp1corr2 = 1
             and t.tp1corr3 = 4;
        exception
          when others then
            ln_MontoTotal := 0;
        end;
      
        begin
          select t.tp1imp1
            into ln_MaxMntTotal
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11138
             and t.tp1corr1 = 6
             and t.tp1corr2 = 1
             and t.tp1corr3 = 2;
        exception
          when others then
            ln_MaxMntTotal := 0;
        end;
      
        ln_MontoTotal := ln_MontoTotal + ln_capital;
      
        if ln_MontoTotal <= ln_MaxMntTotal then
          lc_PrtnFC := 'S';
        end if;
      end if;*/
    end if;
  
    lc_PrtnFC := nvl(lc_PrtnFC, 'N');
  
  end sp_cr_RNFondoCrecer;
  ------------------------------------------------------------------------------------
  procedure sp_cr_ExtornoFC(PPgcod  in number,
                            Pitmod  in number,
                            PItsuc  in number,
                            PIttran in number,
                            PItnrel in number,
                            PItord  in number,
                            PItsbor in number) is
  
    ld_fchSist     date;
    ModAnu         number;
    ln_NroRelacion number;
  begin
  
    begin
    
      select f.pgfape into ld_fchSist from fst017 f where f.pgcod = 1;
    
    end;
    begin
    
      select to_number(Txtext)
        into ln_NroRelacion
        from FSX015
       Where PgCod = PPgcod
         and Hcmod = Pitmod
         and Hsucor = PItsuc
         and Htran = PIttran
         and Hnrel = PItnrel
         and Hfcon = ld_fchSist
         and Txcod = 0
         and Txreng = 1;
    
    end;
    ModAnu := Pitmod - 500;
  
    begin
      update aqpa377 a
         set a.aqpa377est = 'E'
       where a.aqpa377ipgcod = PPgcod
         and a.aqpa377itsuc = PItsuc
         and a.aqpa377itmod = ModAnu
         and a.aqpa377ittran = PIttran
         and a.aqpa377itnrel = ln_NroRelacion
         and a.aqpa377itord = PItord
         and a.aqpa377itsbor = PItsbor
         and a.aqpa377ftran = ld_fchSist
         and a.aqpa377est = 'S';
      commit;
    end;
  
  end sp_cr_ExtornoFC;
  --------------------------------------------------------------------------------------

end PQ_CR_FONDO_CRECER;
/

