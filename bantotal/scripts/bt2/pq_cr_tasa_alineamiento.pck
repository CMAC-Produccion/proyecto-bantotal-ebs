create or replace package PQ_CR_TASA_ALINEAMIENTO is

  -- Author  : MPOSTIGOC
  -- Created : 8/11/2022 10:43:53
  -- Purpose : 

  procedure sp_cr_iniciotasa(ln_pais          in number,
                             ln_tdoc          in number,
                             lc_ndoc          in varchar2,
                             ln_tasaponderada out number);
  ------------------------------------------------
  procedure sp_cr_InsertTasaXcuenta(ln_pais in number,
                                    ln_tdoc in number,
                                    lc_ndoc in varchar2,
                                    lc_Ok   out varchar2);
  -----------------------------------------------------------

  procedure sp_cr_logaqpb157a(ln_pais   in number,
                              ln_tdoc   in number,
                              lc_ndoc   in varchar2,
                              ld_fecha  in date,
                              ln_pgcod  in number,
                              ln_mod    in number,
                              ln_suc    in number,
                              ln_mda    in number,
                              ln_pap    in number,
                              ln_cta    in number,
                              ln_ope    in number,
                              ln_sbop   in number,
                              ln_top    in number,
                              ln_mntdes in number,
                              ln_tasa   in number,
                              ln_mtpon  in number);
  ----------------------------------------------------                              
  procedure sp_cr_logaqpb157(ln_pais   in number,
                             ln_tdoc   in number,
                             lc_ndoc   in varchar2,
                             ld_fecha  in date,
                             lc_cuenta in number,
                             ln_mnttot in number,
                             ln_mtpont in number,
                             ln_tasapo in number);
  -------------------------------------------------

  procedure sp_cr_VerfCliEnAliInt(ln_Instancia   in number,
                                  lc_EstaEnLista out varchar2);
  -------------------------------------------------
  procedure sp_cr_VerVinculacion(ln_instancia in number,
                                 lc_Vinculado out varchar2);
  --------------------------------------------
  procedure sp_Cr_VerfDuplicado(ln_Instancia in number,
                                lc_VerfDoble out varchar2);
  ----------------------------------------------------
  procedure sp_cr_VerfAnclado(ln_instancia in number,
                              lc_VerfAncla out varchar2);

-----------------------------------------------------
end PQ_CR_TASA_ALINEAMIENTO;
/

create or replace package body PQ_CR_TASA_ALINEAMIENTO is

  procedure sp_cr_iniciotasa(ln_pais          in number,
                             ln_tdoc          in number,
                             lc_ndoc          in varchar2,
                             ln_tasaponderada out number) is
  
    cursor lista_vinc is
      select *
        from aqpb934 a
       where a.aqpb934pais = ln_pais
         and a.aqpb934tdoc = ln_tdoc
         and a.aqpb934ndoc = lc_ndoc
         and a.aqpb934est = 'H'
         and a.aqpb934vin = 'V';
  
    ln_mntdesemb10   number(17, 2) := 0.00;
    ln_mntdesemb11   number(17, 2) := 0.00;
    ln_mntdesemb     number(17, 2) := 0.00;
    ld_FchSist       date;
    ln_mtponderado   number(17, 2);
    ln_TotalDesem    number(17, 2);
    ln_TotalMntPonde number(17, 2);
    ln_cuenta        number;
    ln_saldo11       number(17, 2) := 0.00;
    ln_int11         number(17, 2) := 0.00;
  
  begin
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
    
      update aqpb157a a
         set a.aqpb157aest = 'I'
       where a.aqpb157apais = ln_pais
         and a.aqpb157atdoc = ln_tdoc
         and a.aqpb157andoc = lc_ndoc;
    
      update aqpb157 a
         set a.aqpb157est = 'I'
       where a.aqpb157pais = ln_pais
         and a.aqpb157tdoc = ln_tdoc
         and a.aqpb157ndoc = lc_ndoc;
      commit;
    
    end;
  
    for l in lista_vinc loop
      ln_mntdesemb10   := 0;
      ln_mtponderado   := 0;
      ln_TotalDesem    := 0;
      ln_TotalMntPonde := 0;
      ln_saldo11       := 0.00;
      ln_int11         := 0.00;
    
      begin
        select x.xllcapital
          into ln_mntdesemb10
          from X054023 X
         where x.xllpgcod = l.aqpb934cod
           and x.xllaomod = l.aqpb934mod
           and x.xllaosuc = l.aqpb934suc
           and x.xllaomda = l.aqpb934mda
           and x.xllaopap = l.aqpb934pap
           and x.xllaocta = l.aqpb934cta
           and x.xllaooper = l.aqpb934oper
           and x.xllaosbop = l.aqpb934sbop
           and x.xllaotop = l.aqpb934top;
      exception
        when others then
          null;
      end;
      ln_mntdesemb := nvl(ln_mntdesemb, 0);
    
      if ln_mntdesemb10 = 0 then
      
        begin
          select f.aoimp
            into ln_mntdesemb10
            from fsd010 f
           where f.pgcod = l.aqpb934cod
             and f.aomod = l.aqpb934mod
             and f.aosuc = l.aqpb934suc
             and f.aomda = l.aqpb934mda
             and f.aopap = l.aqpb934pap
             and f.aocta = l.aqpb934cta
             and f.aooper = l.aqpb934oper
             and f.aosbop = l.aqpb934sbop
             and f.aotope = l.aqpb934top;
        exception
          when others then
            ln_mntdesemb10 := 0;
        end;
      end if;
    
      begin
        begin
          select f.SCSDO
            into ln_saldo11
            from fsd011 f
           where f.PGCOD = l.aqpb934cod
             and f.SCSUC = l.aqpb934suc
             and f.SCMDA = l.aqpb934mda
             and f.SCPAP = l.aqpb934pap
             and f.SCCTA = l.aqpb934cta
             and f.SCOPER = l.aqpb934oper
             and f.SCSBOP = l.aqpb934sbop
             and f.SCTOPE = l.aqpb934mod
             and f.SCMOD = l.aqpb934mod;
        exception
          when others then
            ln_saldo11 := 0;
        end;
      
        if ln_saldo11 < 0 then
          ln_saldo11 := ln_saldo11 * -1;
        end if;
      
        begin
          select f.SCSDO
            into ln_int11
            from fsd011 f
           where f.PGCOD = l.aqpb934cod
             and f.SCSUC = l.aqpb934suc
             and f.SCMDA = l.aqpb934mda
             and f.SCPAP = l.aqpb934pap
             and f.SCCTA = l.aqpb934cta
             and f.SCOPER = l.aqpb934oper
             and f.SCSBOP = l.aqpb934sbop
             and f.SCmod = 403;
        exception
          when others then
            ln_int11 := 0;
        end;
        if ln_int11 < 0 then
          ln_int11 := ln_int11 * -1;
        end if;
      
        ln_mntdesemb11 := nvl(ln_saldo11, 0) + nvl(ln_int11, 0);
      end;
    
      if ln_mntdesemb11 > ln_mntdesemb10 then
        ln_mntdesemb := ln_mntdesemb11;
      else
        if ln_mntdesemb10 > ln_mntdesemb11 then
          ln_mntdesemb := ln_mntdesemb10;
        end if;
      end if;
    
      begin
        select (ln_mntdesemb * l.aqpb934tasa) / 100
          into ln_mtponderado
          from dual;
      exception
        when others then
          null;
      end;
    
      begin
        pq_Cr_tasa_alineamiento.sp_cr_logaqpb157a(ln_pais   => l.aqpb934pais,
                                                  ln_tdoc   => l.aqpb934tdoc,
                                                  lc_ndoc   => l.aqpb934ndoc,
                                                  ld_fecha  => ld_FchSist,
                                                  ln_pgcod  => l.aqpb934cod,
                                                  ln_mod    => l.aqpb934mod,
                                                  ln_suc    => l.aqpb934suc,
                                                  ln_mda    => l.aqpb934mda,
                                                  ln_pap    => l.aqpb934pap,
                                                  ln_cta    => l.aqpb934cta,
                                                  ln_ope    => l.aqpb934oper,
                                                  ln_sbop   => l.aqpb934sbop,
                                                  ln_top    => l.aqpb934top,
                                                  ln_mntdes => ln_mntdesemb,
                                                  ln_tasa   => l.aqpb934tasa,
                                                  ln_mtpon  => ln_mtponderado);
      exception
        when others then
          null;
      end;
    
    end loop;
  
    begin
      select sum(a.aqpb157amntdes), sum(a.aqpb157amtpon)
        into ln_TotalDesem, ln_TotalMntPonde
        from aqpb157a a
       where a.aqpb157apais = ln_pais
         and a.aqpb157atdoc = ln_tdoc
         and a.aqpb157andoc = lc_ndoc
         and a.aqpb157aest = 'H';
    exception
      when others then
        ln_TotalDesem    := 0;
        ln_TotalMntPonde := 0;
    end;
  
    begin
      select round((ln_TotalMntPonde / ln_TotalDesem) * 100, 6)
        into ln_tasaponderada
        from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpb934cta
        into ln_cuenta
        from aqpb934 a
       where a.aqpb934pais = ln_pais
         and a.aqpb934tdoc = ln_tdoc
         and a.aqpb934ndoc = lc_ndoc
         and a.aqpb934est = 'H'
         and a.aqpb934vin = 'V'
         and a.aqpb934prin = 'S';
    exception
      when others then
        null;
    end;
  
    begin
    
      pq_cR_tasa_alineamiento.sp_cr_logaqpb157(ln_pais   => ln_pais,
                                               ln_tdoc   => ln_tdoc,
                                               lc_ndoc   => lc_ndoc,
                                               ld_fecha  => ld_FchSist,
                                               lc_cuenta => ln_cuenta,
                                               ln_mnttot => ln_TotalDesem,
                                               ln_mtpont => ln_TotalMntPonde,
                                               ln_tasapo => ln_tasaponderada);
    exception
      when others then
        null;
    end;
  
  end sp_cr_iniciotasa;
  ----------------------------------------------
  procedure sp_cr_InsertTasaXcuenta(ln_pais in number,
                                    ln_tdoc in number,
                                    lc_ndoc in varchar2,
                                    lc_Ok   out varchar2) is
  
    cursor ModPizarra is
    
      select distinct p.pp028mod, p.pp028defn, p.pp028mda
        from fst198 f, fpp028 p
       where f.tp1nro2 = p.pp028mod
         and f.tp1nro3 = p.pp028top
         and f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 901
         and f.tp1corr2 = 1
         and f.tp1corr3 > 0
         and p.pp017par = 17
         and p.pp028emp = 1
       order by p.pp028mod;
  
    cursor cuentas is
    
      select f.CTNRO
        from fsr008 f
       where f.PEPAIS = ln_pais
         and f.PETDOC = ln_tdoc
         and f.PENDOC = rpad(lc_ndoc, 12, ' ')
         and f.CTTFIR = 'T';
  
    ln_cuenta       number;
    ln_MaxMntDesemb number(17, 2) := 0.00;
    vTpfinv         number;
    ln_Pp028DefN    number;
    ln_dia          varchar2(2);
    ln_mes          varchar2(2);
    ln_anio         varchar2(4);
    ld_FchInv       number;
    ld_FchSist      date;
    vFechahasta     date;
    ln_nroreg027    number := 0;
    ln_nroreg327    number := 0;
    ln_nroregr27    number := 0;
    ln_tasapond     number(10, 6) := 0.00;
    ln_MntAdi       number(17, 2) := 0.00;
  
  begin
  
    begin
      select a.aqpb157cta, a.aqpb157tasapo
        into ln_cuenta, ln_tasapond
        from aqpb157 a
       where a.aqpb157pais = ln_pais
         and a.aqpb157tdoc = ln_tdoc
         and a.aqpb157ndoc = lc_ndoc
         and a.aqpb157est = 'H';
    exception
      when others then
        null;
    end;
  
    begin
      select sum(a.aqpb157amntdes)
        into ln_MaxMntDesemb
        from aqpb157a a
       where a.aqpb157apais = ln_pais
         and a.aqpb157atdoc = ln_tdoc
         and a.aqpb157andoc = lc_ndoc
         and a.aqpb157aest = 'H';
    exception
      when others then
        null;
    end;
  
    ln_MntAdi       := (ln_MaxMntDesemb * 25) / 100;
    ln_MaxMntDesemb := ln_MaxMntDesemb + ln_MntAdi;
  
    begin
      -- actualiza en la tabla log de vinculaciones
      update aqpb934 a
         set a.aqpb934tasp = ln_tasapond
       where a.aqpb934pais = ln_pais
         and a.aqpb934tdoc = ln_tdoc
         and a.aqpb934ndoc = lc_ndoc
         and a.aqpb934est = 'H'
         and a.aqpb934vin = 'V';
    end;
    begin
    
      begin
        select a.pgfape into ld_FchSist from fst017 a where a.pgcod = 1;
      exception
        when others then
          null;
      end;
    
      begin
        select to_date(f.tp1nro3, 'DD/MM/YYYY')
          into vFechahasta
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 901
           and f.tp1corr2 = 2;
      exception
        when others then
          null;
      end;
    
      if vFechahasta is null then
        vFechahasta := '31/12/2022';
      end if;
    
      begin
        select to_char(ld_FchSist, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_FchSist, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_FchSist, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    /* begin
      select s.CTNRO, count(*)
        into ln_CtaIndv, ln_count
        from fsr008 s
       where s.CTNRO in ((select f.CTNRO
                           from fsr008 f
                          where f.PEPAIS = ln_pais
                            and f.PETDOC = ln_tdoc
                            and f.PENDOC = lc_ndoc
                            and f.CTTFIR = 'T'))
       group by s.CTNRO
      having count(*) = 1;
    exception
      when others then
        null;
    end;*/
  
    for p in ModPizarra loop
      for c in cuentas loop
      
        ln_Pp028DefN := p.pp028defn;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = p.pp028mod
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = c.ctnro
               and f.moneda = p.pp028mda
               and f.papel = 0
               and f.tpfdes = ld_FchSist
               and f.tpmto = ln_MaxMntDesemb;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 p.pp028mod,
                 ln_Pp028DefN,
                 c.ctnro,
                 p.pp028mda,
                 0,
                 ld_FchSist,
                 ln_MaxMntDesemb,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          end if;
        
          begin
            --fsd327
            begin
              select count(*)
                into ln_nroreg327
                from fsd327 f
               where f.vt1pgcod = 1
                 and f.vt1mod = p.pp028mod
                 and f.vt1tpiz = ln_Pp028DefN
                 and f.vt1ctnr = c.ctnro
                 and f.vt1mon = p.pp028mda
                 and f.vt1pap = 0
                 and f.vt1tpfd = ld_FchSist;
            exception
              when others then
                ln_nroreg327 := 0;
            end;
          
            if ln_nroreg327 = 0 then
            
              begin
                insert into fsd327
                  (vt1pgcod,
                   vt1mod,
                   vt1tpiz,
                   vt1ctnr,
                   vt1mon,
                   vt1pap,
                   vt1tpfd,
                   vt1fchven)
                values
                  (1,
                   p.pp028mod,
                   ln_Pp028DefN,
                   c.ctnro,
                   p.pp028mda,
                   0,
                   ld_FchSist,
                   vFechahasta);
              end;
              commit;
            
            end if;
          end;
        
          begin
            --fsr027
            begin
              select count(*)
                into ln_nroregr27
                from fsr027 f
               where f.pgcod = 1
                 and f.modulo = p.pp028mod
                 and f.tpizar = ln_Pp028DefN
                 and f.ctnro = c.ctnro
                 and f.moneda = p.pp028mda
                 and f.papel = 0
                 and f.tpfdes = ld_FchSist
                 and f.tpmto = ln_MaxMntDesemb
                 and f.tppzo = 99999;
            exception
              when others then
                ln_nroregr27 := 0;
            end;
          
            if ln_nroregr27 = 0 then
            
              begin
                insert into fsr027
                  (pgcod,
                   modulo,
                   tpizar,
                   ctnro,
                   moneda,
                   papel,
                   tpfdes,
                   tpmto,
                   tppzo,
                   tptasa)
                values
                  (1,
                   p.pp028mod,
                   ln_Pp028DefN,
                   c.ctnro,
                   p.pp028mda,
                   0,
                   ld_FchSist,
                   ln_MaxMntDesemb,
                   99999,
                   ln_tasapond);
              
              exception
                when others then
                  null;
                  commit;
              end;
            else
              if ln_nroregr27 = 1 then
                -- mpostigoc 20.09.2020
                begin
                  update fsr027 f
                     set f.tptasa = ln_tasapond
                   where f.pgcod = 1
                     and f.modulo = p.pp028mod
                     and f.tpizar = ln_Pp028DefN
                     and f.ctnro = c.ctnro
                     and f.moneda = p.pp028mda
                     and f.papel = 0
                     and f.tpfdes = ld_FchSist
                     and f.tpmto = ln_MaxMntDesemb
                     and f.tppzo = 99999;
                
                  commit;
                end;
              
              end if;
            end if;
          end;
          commit;
        
        end if;
        commit;
      end loop;
    end loop;
  
    lc_Ok := 'OK';
  
  end sp_cr_InsertTasaXcuenta;
  ----------------------------------------------
  procedure sp_cr_logaqpb157a(ln_pais   in number,
                              ln_tdoc   in number,
                              lc_ndoc   in varchar2,
                              ld_fecha  in date,
                              ln_pgcod  in number,
                              ln_mod    in number,
                              ln_suc    in number,
                              ln_mda    in number,
                              ln_pap    in number,
                              ln_cta    in number,
                              ln_ope    in number,
                              ln_sbop   in number,
                              ln_top    in number,
                              ln_mntdes in number,
                              ln_tasa   in number,
                              ln_mtpon  in number) is
  
    ln_corr number;
    lc_hora char(8);
  
  begin
  
    begin
      select max(a.aqpb157acorr)
        into ln_corr
        from aqpb157a a
       where a.aqpb157apais = ln_pais
         and a.aqpb157atdoc = ln_tdoc
         and a.aqpb157andoc = lc_ndoc;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb157a
        (aqpb157acorr,
         aqpb157apais,
         aqpb157atdoc,
         aqpb157andoc,
         aqpb157afecha,
         aqpb157ahora,
         aqpb157apgcod,
         aqpb157amod,
         aqpb157asuc,
         aqpb157amda,
         aqpb157apap,
         aqpb157acta,
         aqpb157aope,
         aqpb157asbop,
         aqpb157atop,
         aqpb157amntdes,
         aqpb157atasa,
         aqpb157amtpon,
         aqpb157aest)
      values
        (ln_corr + 1,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ld_fecha,
         lc_hora,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_top,
         ln_mntdes,
         ln_tasa,
         ln_mtpon,
         'H');
      commit;
    end;
  
  end sp_cr_logaqpb157a;
  ------------------------------------------------------------------------------------
  procedure sp_cr_logaqpb157(ln_pais   in number,
                             ln_tdoc   in number,
                             lc_ndoc   in varchar2,
                             ld_fecha  in date,
                             lc_cuenta in number,
                             ln_mnttot in number,
                             ln_mtpont in number,
                             ln_tasapo in number) is
  
    ln_corr number := 0;
    lc_hora char(8);
  begin
  
    begin
      select max(a.aqpb157corr)
        into ln_corr
        from aqpb157 a
       where a.aqpb157pais = ln_pais
         and a.aqpb157tdoc = ln_tdoc
         and a.aqpb157ndoc = lc_ndoc;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb157
        (aqpb157corr,
         aqpb157pais,
         aqpb157tdoc,
         aqpb157ndoc,
         aqpb157fecha,
         aqpb157hora,
         aqpb157cta,
         aqpb157mnttot,
         aqpb157mtpont,
         aqpb157tasapo,
         aqpb157est)
      values
        (ln_corr + 1,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ld_fecha,
         lc_hora,
         lc_cuenta,
         ln_mnttot,
         ln_mtpont,
         ln_tasapo,
         'H');
      commit;
    end;
  
  end sp_cr_logaqpb157;
  ----------------------------------------------

  procedure sp_cr_VerfCliEnAliInt(ln_Instancia   in number,
                                  lc_EstaEnLista out varchar2) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_ndoc   varchar2(12);
    ln_NroReg number;
  
  begin
  
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
      select count(*)
        into ln_NroReg
        from aqpb299 a
       where a.AQPB299PAIS = LN_PAis
         and a.aqpb299tdoc = ln_tdoc
         and a.aqpb299doc = rpad(lc_ndoc, 12, ' ');
    exception
      when others then
        ln_NroReg := 0;
    end;
  
    if ln_NroReg > 0 then
      lc_EstaEnLista := 'S';
    else
      lc_EstaEnLista := 'N';
    end if;
  
  end sp_cr_VerfCliEnAliInt;
  --------------------------------------------
  procedure sp_cr_VerVinculacion(ln_instancia in number,
                                 lc_Vinculado out varchar2) is
  
    ln_pais    number;
    ln_tdoc    number;
    lc_ndoc    number;
    ln_NroReg  number;
    ln_NroReg2 number;
    ln_tipsoli number;
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, s.sng001ori
        into ln_pais, ln_tdoc, lc_ndoc, ln_tipsoli
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_tipsoli = 4 then
      begin
        select count(*)
          into ln_NroReg
          from (select a.aqpb934cod,
                       a.aqpb934mod,
                       a.aqpb934suc,
                       a.aqpb934mda,
                       a.aqpb934pap,
                       a.aqpb934cta,
                       a.aqpb934oper,
                       a.aqpb934sbop,
                       a.aqpb934top
                  from aqpb934 a
                 where a.aqpb934pais = ln_pais
                   and a.aqpb934tdoc = ln_tdoc
                   and a.aqpb934ndoc = lc_ndoc
                   and a.aqpb934est = 'H'
                   and a.aqpb934vin = 'V'
                   and a.aqpb934prin = 'N'
                minus
                select j.jaqy800pgcd,
                       j.jaqy800mod,
                       j.jaqy800suc,
                       j.jaqy800mda,
                       j.jaqy800pap,
                       j.jaqy800cta,
                       j.jaqy800ope,
                       j.jaqy800sbop,
                       j.jaqy800tope
                  from jaqy800 j
                 where j.jaqy800ins = ln_Instancia
                   and j.jaqy800vinc = 'S') t;
      exception
        when others then
          ln_NroReg := 0;
      end;
    
      begin
        select count(*)
          into ln_NroReg2
          from (select j.jaqy800pgcd,
                       j.jaqy800mod,
                       j.jaqy800suc,
                       j.jaqy800mda,
                       j.jaqy800pap,
                       j.jaqy800cta,
                       j.jaqy800ope,
                       j.jaqy800sbop,
                       j.jaqy800tope
                  from jaqy800 j
                 where j.jaqy800ins = ln_Instancia
                   and j.jaqy800vinc = 'S'
                minus
                select a.aqpb934cod,
                       a.aqpb934mod,
                       a.aqpb934suc,
                       a.aqpb934mda,
                       a.aqpb934pap,
                       a.aqpb934cta,
                       a.aqpb934oper,
                       a.aqpb934sbop,
                       a.aqpb934top
                  from aqpb934 a
                 where a.aqpb934pais = ln_pais
                   and a.aqpb934tdoc = ln_tdoc
                   and a.aqpb934ndoc = lc_ndoc
                   and a.aqpb934est = 'H'
                   and a.aqpb934vin = 'V'
                   and a.aqpb934prin = 'N') t;
      exception
        when others then
          ln_NroReg := 0;
      end;
    
      if ln_NroReg > 0 or ln_NroReg2 > 0 then
        lc_Vinculado := 'N';
      else
        lc_Vinculado := 'S';
      end if;
    else
      if ln_tipsoli = 0 then
        begin
          select count(*)
            into ln_NroReg
            from (select a.aqpb934cod,
                         a.aqpb934mod,
                         a.aqpb934suc,
                         a.aqpb934mda,
                         a.aqpb934pap,
                         a.aqpb934cta,
                         a.aqpb934oper,
                         a.aqpb934sbop,
                         a.aqpb934top
                    from aqpb934 a
                   where a.aqpb934pais = ln_pais
                     and a.aqpb934tdoc = ln_tdoc
                     and a.aqpb934ndoc = lc_ndoc
                     and a.aqpb934est = 'H'
                     and a.aqpb934vin = 'V'
                  minus
                  select j.jaqy800pgcd,
                         j.jaqy800mod,
                         j.jaqy800suc,
                         j.jaqy800mda,
                         j.jaqy800pap,
                         j.jaqy800cta,
                         j.jaqy800ope,
                         j.jaqy800sbop,
                         j.jaqy800tope
                    from jaqy800 j
                   where j.jaqy800ins = ln_Instancia
                     and j.jaqy800vinc = 'S') t;
        exception
          when others then
            ln_NroReg := 0;
        end;
      
        begin
          select count(*)
            into ln_NroReg2
            from (select j.jaqy800pgcd,
                         j.jaqy800mod,
                         j.jaqy800suc,
                         j.jaqy800mda,
                         j.jaqy800pap,
                         j.jaqy800cta,
                         j.jaqy800ope,
                         j.jaqy800sbop,
                         j.jaqy800tope
                    from jaqy800 j
                   where j.jaqy800ins = ln_Instancia
                     and j.jaqy800vinc = 'S'
                  minus
                  select a.aqpb934cod,
                         a.aqpb934mod,
                         a.aqpb934suc,
                         a.aqpb934mda,
                         a.aqpb934pap,
                         a.aqpb934cta,
                         a.aqpb934oper,
                         a.aqpb934sbop,
                         a.aqpb934top
                    from aqpb934 a
                   where a.aqpb934pais = ln_pais
                     and a.aqpb934tdoc = ln_tdoc
                     and a.aqpb934ndoc = lc_ndoc
                     and a.aqpb934est = 'H'
                     and a.aqpb934vin = 'V') t;
        exception
          when others then
            ln_NroReg := 0;
        end;
      
        if ln_NroReg > 0 or ln_NroReg2 > 0 then
          lc_Vinculado := 'N';
        else
          lc_Vinculado := 'S';
        end if;
      
      end if;
    end if;
  end sp_cr_VerVinculacion;
  --------------------------------------------
  procedure sp_Cr_VerfDuplicado(ln_Instancia in number,
                                lc_VerfDoble out varchar2) is
  
    ln_pgcod    number;
    ln_suc      number;
    ln_mod      number;
    ln_mda      number;
    ln_pap      number;
    ln_cta      number;
    ln_ope      number;
    ln_sbop     number;
    ln_tope     number;
    ln_EstaVinc number;
  
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
        into ln_pgcod,
             ln_suc,
             ln_mod,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbop,
             ln_tope
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 <> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_EstaVinc
        from jaqy800 j
       where j.jaqy800ins = ln_Instancia
         and j.jaqy800pgcd = ln_pgcod
         and j.jaqy800mod = ln_mod
         and j.jaqy800suc = ln_suc
         and j.jaqy800mda = ln_mda
         and j.jaqy800pap = ln_pap
         and j.jaqy800cta = ln_cta
         and j.jaqy800ope = ln_ope
         and j.jaqy800sbop = ln_sbop
         and j.jaqy800tope = ln_tope
         and j.jaqy800vinc = 'S';
    exception
      when others then
        ln_EstaVinc := 0;
    end;
  
    if ln_EstaVinc > 0 then
      lc_VerfDoble := 'S';
    else
      lc_VerfDoble := 'N';
    end if;
  
  end sp_Cr_VerfDuplicado;
  ------------------------------------------------
  procedure sp_cr_VerfAnclado(ln_instancia in number,
                              lc_VerfAncla out varchar2) is
  
    ln_pgcod   number;
    ln_suc     number;
    ln_mod     number;
    ln_mda     number;
    ln_pap     number;
    ln_cta     number;
    ln_ope     number;
    ln_sbop    number;
    ln_tope    number;
    ln_EstaAso number;
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
        into ln_pgcod,
             ln_suc,
             ln_mod,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbop,
             ln_tope
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 <> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_EstaAso
        from aqpb299 a
       where a.aqpb299emp = ln_pgcod
         and a.aqpb299suc = ln_suc
         and a.aqpb299mod = ln_mod
         and a.aqpb299mda = ln_mda
         and a.aqpb299pap = ln_pap
         and a.aqpb299cta = ln_cta
         and a.aqpb299oper = ln_ope
         and a.aqpb299sbop = ln_sbop
         and a.aqpb299top = ln_tope
         and a.aqpb299ancla = 'ancla';
    exception
      when others then
        null;
    end;
  
    if ln_EstaAso > 0 then
      lc_VerfAncla := 'S';
    else
      lc_VerfAncla := 'N';
    end if;
  
  end sp_cr_VerfAnclado;
  --------------------------------------------
end PQ_CR_TASA_ALINEAMIENTO;
/

