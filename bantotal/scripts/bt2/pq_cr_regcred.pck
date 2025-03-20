create or replace package PQ_CR_REGCRED is

  -- Author  : ABERNEDO
  -- Created : 02/03/2017 12:46:53 p.m.
  -- Purpose : 

  -- Public type declarations
  Procedure Sp_Refinanciado(pn_ins in number, ln_cont out number);
  Procedure Sp_ActEconomica(pn_ins in number, pc_flg out varchar2);
  Procedure Sp_Analista(pn_ins in number, pc_analista out varchar2);
  Procedure Es_director(pn_ins in number, pc_flg out varchar2);
  Procedure Sp_Ampliado(pn_ins in number, ln_cont out number);

end PQ_CR_REGCRED;
/

create or replace package body PQ_CR_REGCRED is

  -- Private type declarations
  Procedure Sp_Refinanciado(pn_ins in number, ln_cont out number) is
  
    ln_ori number(2);
  
    lc_desembolsada char(1);
  
    ln_ins     number(10);
    ln_ins_aux number(10);
  
    --mod@abr 20170810
    cursor creditos(ln_ins in number) is
      select xwfempresa,
             xwfsucursal,
             xwfmodulo,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        from xwf700 a
       where a.xwfprcins = ln_ins
         and a.xwfcar3 <> '1';
    --fin mod@abr 20170810
  begin
    ln_ins  := pn_ins;
    ln_cont := 0;
  
    /* begin --mod@abr 20200627
      select a.sng001ori
        into ln_ori
        from sng001 a
       where a.sng001inst = ln_ins;
    exception
      when others then
        null;
    end;
    
    if ln_ori = 3 then
      lc_desembolsada := 'S';
    else
      lc_desembolsada := 'N';
    end if;
    
    while ln_ori in (3, 13, 14, 15, 16) loop
    
      if ln_ori = 3 and lc_desembolsada = 'S' then
        ln_cont := ln_cont + 1;
      end if;
      ln_ins_aux := ln_ins;
      begin
        for i in creditos(ln_ins) loop
        
          ln_ins := fn_instancia_credito(i.xwfmodulo,
                                         i.xwfsucursal,
                                         i.xwfmoneda,
                                         i.xwfpapel,
                                         i.xwfcuenta,
                                         i.xwfoperacion,
                                         i.xwfsubope,
                                         i.xwftipope);
        
          if ln_ins_aux <> ln_ins then
            exit;
          end if;
        end loop;
      end;
    
      lc_desembolsada := 'N';
      begin
        select 'S'
          into lc_desembolsada
          from xwf070 b, wfwrkitems c
         where c.wfinsprcid = ln_ins
           and c.wftaskcod = 55
           and c.wfitemid = b.xwfwrkite
           and rownum = 1;
      exception
        when others then
          lc_desembolsada := 'N';
      end;
    
      ln_ori := null;
      begin
        select a.sng001ori
          into ln_ori
          from sng001 a
         where a.sng001inst = ln_ins;
      exception
        when others then
          null;
      end;
    
    end loop;*/ --mod@abr 20200627
  
  end Sp_Refinanciado;
  --------------------------------------------------------------------------------------
  Procedure Sp_ActEconomica(pn_ins in number, pc_flg out varchar2) is
  
    ln_pai    number(3);
    ln_tdo    number(2);
    lc_ndo    char(12);
    ln_paiCyg number(3);
    ln_tdoCyg number(2);
    lc_ndoCyg char(12);
  
  begin
  
    --conyugue
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when too_many_rows then
        begin
          select a.sng001pais, a.sng001tdoc, a.sng001ndoc
            into ln_pai, ln_tdo, lc_ndo
            from sng001 a
           where a.sng001inst = pn_ins
             and rownum = 1;
        exception
          when others then
            null;
          
        end;
      when others then
        null;
    end;
  
    begin
      select a.rppais, a.rptdoc, a.rpndoc
        into ln_paiCyg, ln_tdoCyg, lc_ndoCyg
        from fsr002 a
       where a.pepais = ln_pai
         and a.petdoc = ln_tdo
         and a.pendoc = lc_ndo
         and a.rpccyg = 66;
    exception
      when others then
        null;
    end;
  
    --actividad
    pc_flg := 'N';
    begin
      select 'S'
        into pc_flg
        from sngc60 aa, sngc07 b
       where aa.sngc60pais = ln_paiCyg
         and aa.sngc60tdoc = ln_tdoCyg
         and aa.sngc60ndoc = lc_ndoCyg
         and aa.sngc60ocup = b.sngc07cod
         and b.segcod in (1, 2);
    exception
      when too_many_rows then
        begin
          select 'S'
            into pc_flg
            from sngc60 aa, sngc07 b
           where aa.sngc60pais = ln_paiCyg
             and aa.sngc60tdoc = ln_tdoCyg
             and aa.sngc60ndoc = lc_ndoCyg
             and aa.sngc60corr in
                 (select max(a.sngc60corr)
                    from sngc60 a
                   where a.sngc60pais = aa.sngc60pais
                     and a.sngc60tdoc = aa.sngc60tdoc
                     and a.sngc60ndoc = aa.sngc60ndoc)
             and aa.sngc60ocup = b.sngc07cod
             and b.segcod in (1, 2);
        exception
          when others then
            pc_flg := 'N';
          
        end;
      when others then
        pc_flg := 'N';
    end;
  
  end Sp_ActEconomica;
  --------------------------------------------------------------------------------------
  Procedure Sp_Analista(pn_ins in number, pc_analista out varchar2) is
  
    cursor cuentas(cn_pai in number, cn_tdo in number, cc_ndo in char) is
      select a.ctnro
        from fsr008 a
       where a.pepais = cn_pai
         and a.petdoc = cn_tdo
         and a.pendoc = cc_ndo;
  
    cursor creditos(cn_cta in number) is
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope
        from fsd010 a
       where a.pgcod = 1
         and a.aocta = cn_cta
         and aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in (107, 108))
         and aostat <> 99;
  
    cursor vuelo(cn_pai in number, cn_tdo in number, cc_ndo in char) is
      select a.sng001inst
        from sng001 a, wfwrkitems b
       where b.wfinsprcid = a.sng001inst
         and b.wfitemstsact = 1
         and sng001pais = cn_pai
         and sng001tdoc = cn_tdo
         and sng001ndoc = cc_ndo;
  
    ln_pai          number(3);
    ln_tdo          number(2);
    lc_ndo          char(12);
    ln_instancia    number(10);
    ln_emp          number(3);
    ln_mod          number(3);
    ln_suc          number(3);
    ln_mda          number(4);
    ln_pap          number(4);
    ln_cta          number(9);
    ln_ope          number(9);
    ln_sbo          number(3);
    ln_top          number(3);
    lc_contab       char(1);
    lc_analista_ant char(10);
    lc_garantia     char(1);
  begin
  
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when too_many_rows then
        begin
          select a.sng001pais, a.sng001tdoc, a.sng001ndoc
            into ln_pai, ln_tdo, lc_ndo
            from sng001 a
           where a.sng001inst = pn_ins
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    for i in cuentas(ln_pai, ln_tdo, lc_ndo) loop
    
      for j in creditos(i.ctnro) loop
      
        if j.aomod = 116 then
        
          begin
            select a.r2cod,
                   a.r2mod,
                   a.r2suc,
                   a.r2mda,
                   a.r2pap,
                   a.r2cta,
                   a.r2oper,
                   a.r2sbop,
                   a.r2tope
              into ln_emp,
                   ln_mod,
                   ln_suc,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_ope,
                   ln_sbo,
                   ln_top
              from fsr011 a
             where a.r1cod = j.pgcod
               and a.r1mod = j.aomod
               and a.r1suc = j.aosuc
               and a.r1mda = j.aomda
               and a.r1pap = j.aopap
               and a.r1cta = j.aocta
               and a.r1oper = j.aooper
               and a.r1sbop = j.aosbop
               and a.r1tope = j.aotope
               and relcod = 46;
          exception
            when too_many_rows then
              begin
                select a.r2cod,
                       a.r2mod,
                       a.r2suc,
                       a.r2mda,
                       a.r2pap,
                       a.r2cta,
                       a.r2oper,
                       a.r2sbop,
                       a.r2tope
                  into ln_emp,
                       ln_mod,
                       ln_suc,
                       ln_mda,
                       ln_pap,
                       ln_cta,
                       ln_ope,
                       ln_sbo,
                       ln_top
                  from fsr011 a
                 where a.r1cod = j.pgcod
                   and a.r1mod = j.aomod
                   and a.r1suc = j.aosuc
                   and a.r1mda = j.aomda
                   and a.r1pap = j.aopap
                   and a.r1cta = j.aocta
                   and a.r1oper = j.aooper
                   and a.r1sbop = j.aosbop
                   and a.r1tope = j.aotope
                   and relcod = 46
                   and rownum = 1;
              exception
                when others then
                  null;
              end;
            when others then
              null;
          end;
        
        else
          ln_emp := j.pgcod;
          ln_mod := j.aomod;
          ln_suc := j.aosuc;
          ln_mda := j.aomda;
          ln_pap := j.aopap;
          ln_cta := j.aocta;
          ln_ope := j.aooper;
          ln_sbo := j.aosbop;
          ln_top := j.aotope;
        
        end if;
      
        ln_instancia := fn_instancia_credito(ln_mod,
                                             ln_suc,
                                             ln_mda,
                                             ln_pap,
                                             ln_cta,
                                             ln_ope,
                                             ln_sbo,
                                             ln_top);
        --verifica instancia contabilizadad
        lc_contab := 'N';
        begin
          select 'S'
            into lc_contab
            from xwf070 a
           where a.xwfprcin = ln_instancia
             and a.xwfcont = 'S'
             and rownum = 1;
        exception
          when others then
            lc_contab := 'N';
        end;
      
        --verifica garantias DPF y CTS
        lc_garantia := 'N';
        begin
          select 'S'
            into lc_garantia
            from sng122 a
           where a.sng122inst = ln_instancia
             and a.sng122tope in (80, 85)
             and rownum = 1;
        
        exception
          when others then
            lc_garantia := 'N';
        end;
      
        if lc_garantia = 'N' and lc_contab = 'S' then
          begin
            select a.sng001ase
              into pc_analista
              from sng001 a
             where a.sng001inst = ln_instancia
               and a.SNG001FIn >= to_date('2013.07.01', 'yyyy.mm.dd');
          exception
            when too_many_rows then
              begin
                select a.sng001ase
                  into pc_analista
                  from sng001 a
                 where a.sng001inst = ln_instancia
                   and a.SNG001FIn >= to_date('2013.07.01', 'yyyy.mm.dd')
                   and rownum = 1;
              exception
                when others then
                  null;
              end;
            when others then
              null;
          end;
        
          if lc_analista_ant is null then
            lc_analista_ant := pc_analista;
          end if;
        
          if trim(pc_analista) <> trim(lc_analista_ant) then
            pc_analista := 'ERROR';
          else
            lc_analista_ant := pc_analista;
          end if;
        
          if pc_analista = 'ERROR' then
            exit;
          end if;
        end if;
      end loop;
      if pc_analista = 'ERROR' then
        exit;
      end if;
    end loop;
  
    if pc_analista <> 'ERROR' then
    
      for k in vuelo(ln_pai, ln_tdo, lc_ndo) loop
        --verifica garantias DPF y CTS
        lc_garantia := 'N';
        begin
          select 'S'
            into lc_garantia
            from sng122 a
           where a.sng122inst = k.sng001inst
             and a.sng122tope in (80, 85)
             and rownum = 1;
        exception
          when others then
            lc_garantia := 'N';
        end;
      
        if lc_garantia = 'N' then
          begin
            select a.sng001ase
              into pc_analista
              from sng001 a
             where a.sng001inst = k.sng001inst
               and a.SNG001FIn >= to_date('2013.07.01', 'yyyy.mm.dd');
          exception
            when too_many_rows then
              begin
                select a.sng001ase
                  into pc_analista
                  from sng001 a
                 where a.sng001inst = k.sng001inst
                   and a.SNG001FIn >= to_date('2013.07.01', 'yyyy.mm.dd')
                   and rownum = 1;
              exception
                when others then
                  null;
              end;
            when others then
              null;
          end;
        
          if lc_analista_ant is null then
            lc_analista_ant := pc_analista;
          end if;
        
          if trim(pc_analista) <> trim(lc_analista_ant) then
            pc_analista := 'ERROR';
          else
            lc_analista_ant := pc_analista;
          end if;
        
          if pc_analista = 'ERROR' then
            exit;
          end if;
        end if;
      
      end loop;
    
    end if;
  
  end Sp_Analista;
  --------------------------------------------------------------------------------------
  Procedure Es_director(pn_ins in number, pc_flg out varchar2) is
    ln_pai number(3);
    ln_tdo number(2);
    lc_ndo char(12);
  begin
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when too_many_rows then
        begin
          select a.sng001pais, a.sng001tdoc, a.sng001ndoc
            into ln_pai, ln_tdo, lc_ndo
            from sng001 a
           where a.sng001inst = pn_ins
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
    pc_flg := 'N';
    begin
      select 'S'
        into pc_flg
        from sng057 s, jaqn002 j
       where JAQN002PGC = 1
         and JAQN002PAI = ln_pai
         AND JAQN002TDO = ln_tdo
         AND JAQN002NDO = lc_ndo
         and s.SNG057USR = J.JAQN002USR
         and s.sng055car = 516
         and rownum = 1;
    exception
      when others then
        pc_flg := 'N';
    end;
  end Es_director;
  --------------------------------------------------------------------------------------

  Procedure Sp_Ampliado(pn_ins in number, ln_cont out number) is
  
    ln_ori number(2);
  
    lc_desembolsada char(1);
  
    ln_ins     number(10);
    ln_ins_aux number(10);
  
    --mod@abr 20170810
    cursor creditos(ln_ins in number) is
      select xwfempresa,
             xwfsucursal,
             xwfmodulo,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        from xwf700 a
       where a.xwfprcins = ln_ins
         and a.xwfcar3 <> '1';
    --fin mod@abr 20170810
  begin
    ln_ins  := pn_ins;
    ln_cont := 0;
  
    --mod@abr 20201027
    /*
    begin
      select a.sng001ori
        into ln_ori
        from sng001 a
       where a.sng001inst = ln_ins;
    exception
      when others then
        null;
    end;
    
    if ln_ori = 4 then
      lc_desembolsada := 'S';
    else
      lc_desembolsada := 'N';
    end if;
    
    while ln_ori in (4, 13, 14, 15, 16) loop
    
      if ln_ori = 4 and lc_desembolsada = 'S' then
        ln_cont := ln_cont + 1;
      end if;
      ln_ins_aux := ln_ins;
      begin
        for i in creditos(ln_ins) loop
        
          ln_ins := nvl(fn_instancia_credito(i.xwfmodulo,
                                             i.xwfsucursal,
                                             i.xwfmoneda,
                                             i.xwfpapel,
                                             i.xwfcuenta,
                                             i.xwfoperacion,
                                             i.xwfsubope,
                                             i.xwftipope),
                        0);
        
          if ln_ins_aux <> ln_ins then
            exit;
          end if;
        end loop;
      end;
    
      if ln_ins_aux = ln_ins then
        exit;
      end if;
    
      lc_desembolsada := 'N';
      begin
        select 'S'
          into lc_desembolsada
          from xwf070 b, wfwrkitems c
         where c.wfinsprcid = ln_ins
           and c.wftaskcod = 55
           and c.wfitemid = b.xwfwrkite
           and rownum = 1;
      exception
        when others then
          lc_desembolsada := 'N';
      end;
    
      ln_ori := null;
      begin
        select a.sng001ori
          into ln_ori
          from sng001 a
         where a.sng001inst = ln_ins;
      exception
        when others then
          null;
      end;
    
    end loop;*/
    --mod@abr 20201027
  
  end Sp_Ampliado;

--------------------------------------------------------------------------------------
end PQ_CR_REGCRED;
/

