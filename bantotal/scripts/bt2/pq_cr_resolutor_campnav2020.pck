create or replace package pq_cr_resolutor_campnav2020 is

  procedure sp_valida(pn_ins       in number,
                      pd_Fecpro    in date,
                      pn_mtoMaximo out number,
                      pn_mtoHisMax out number);

end pq_cr_resolutor_campnav2020;
/

create or replace package body pq_cr_resolutor_campnav2020 is

  procedure sp_valida(pn_ins       in number,
                      pd_Fecpro    in date,
                      pn_mtoMaximo out number,
                      pn_mtoHisMax out number) is
  
    cursor creditos(cn_pai in number, cn_tdo in number, cc_ndo in char) is
    
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope,
             a.aoimp
        from fsd010 a
       where a.pgcod = 1
         and a.aomod in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (106, 107, 108, 200, 33))
         and aostat <> 99
         and aocta in (select ctnro
                         from fsr008 b
                        where b.pepais = cn_pai
                          and b.petdoc = cn_tdo
                          and b.pendoc = cc_ndo
                          and b.cttfir = 'T');
  
    ln_pai       number(3);
    ln_tdo       number(2);
    lc_ndo       char(12);
    ln_instancia number(10);
    lc_garantia  char(1);
    lc_hipo      char(1);
    ln_mtoAnt    number(17, 2) := 0;
    ln_mtoMaximo number(17, 2) := 0;
  
    cursor creditos_his(cd_fec in date,
                        cn_pai in number,
                        cn_tdo in number,
                        cc_ndo in char) is
    
      select a.bcemp,
             a.bcmod,
             a.bcsuc,
             a.bcmda,
             a.bcpap,
             a.bccta,
             a.bcoper,
             a.bcsbop,
             a.bctop,
             (a.bcsdmn * -1) bcsdmn
        from fsh012 a
       where a.bcemp = 1
         and a.bcmod in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (106, 107, 108, 200, 33))
         and a.bcfech = cd_fec
         and a.bccta in (select ctnro
                           from fsr008 b
                          where b.pepais = cn_pai
                            and b.petdoc = cn_tdo
                            and b.pendoc = cc_ndo
                            and b.cttfir = 'T')
         and substr(a.bcrubr, 5, 2) <> '04';
  
    ln_meses      number(3);
    ln_k          number(3);
    ln_ins2       number(10);
    lc_garantia2  char(1);
    ln_mtoAnt2    number(17, 2) := 0;
    ln_mtoMaximo2 number(17, 2) := 0;
    ld_fecFM      date;
  begin
  
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    for i in creditos(ln_pai, ln_tdo, lc_ndo) loop
      lc_garantia  := 'N';
      lc_hipo      := 'N';
      ln_instancia := fn_instancia_credito(v_Scmod  => i.aomod,
                                           v_Scsuc  => i.aosuc,
                                           v_Scmda  => i.aomda,
                                           v_Scpap  => i.aopap,
                                           v_Sccta  => i.aocta,
                                           v_Scoper => i.aooper,
                                           v_Scsbop => i.aosbop,
                                           v_Sctope => i.aotope);
    
      begin
        select 'S'
          into lc_garantia
          from sng122 a
         where a.sng122inst = ln_instancia
           and a.sng122tope in (select aa.tp1nro1
                                  from fst198 aa
                                 where aa.tp1cod = 1
                                   and aa.tp1cod1 = 10899
                                   and aa.tp1corr1 = 222222
                                   and aa.tp1corr2 = 1
                                   and aa.tp1corr3 > 0)
           and rownum = 1;
      exception
        when others then
          lc_garantia := 'N';
      end;
    
      begin
        select 'S'
          into lc_hipo
          from fsd011 a
         where a.pgcod = i.pgcod
           and a.scmod = i.aomod
           and a.scsuc = i.aosuc
           and a.scmda = i.aomda
           and a.scpap = i.aopap
           and a.sccta = i.aocta
           and a.scoper = i.aooper
           and a.scsbop = i.aosbop
           and a.sctope = i.aotope
           and substr(a.scrub, 5, 2) = '04';
      exception
        when others then
          lc_hipo := 'N';
      end;
    
      if nvl(lc_hipo, 'N') = 'N' and nvl(lc_garantia, 'N') = 'N' then
        if i.aoimp > ln_mtoAnt then
          ln_mtoMaximo := i.aoimp;
        end if;
        ln_mtoAnt := i.aoimp;
      end if;
    
    end loop;
  
    pn_mtoMaximo := nvl(ln_mtoMaximo, 0);
  
    -----saldo deudor ultimos 18 meses
  
    begin
      select a.tp1nro1
        into ln_meses
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 222222
         and a.tp1corr2 = 2
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    ld_fecFM := last_day(add_months(pd_fecpro, -1));
    ln_k     := 1;
  
    while ln_k <= ln_meses loop
      for j in creditos_his(ld_fecFM, ln_pai, ln_tdo, lc_ndo) loop
        lc_garantia2 := 'N';
        ln_ins2      := fn_instancia_credito(v_Scmod  => j.bcmod,
                                             v_Scsuc  => j.bcsuc,
                                             v_Scmda  => j.bcmda,
                                             v_Scpap  => j.bcpap,
                                             v_Sccta  => j.bccta,
                                             v_Scoper => j.bcoper,
                                             v_Scsbop => j.bcsbop,
                                             v_Sctope => j.bctop);
      
        begin
          select 'S'
            into lc_garantia2
            from sng122 a
           where a.sng122inst = ln_ins2
             and a.sng122tope in (select aa.tp1nro1
                                    from fst198 aa
                                   where aa.tp1cod = 1
                                     and aa.tp1cod1 = 10899
                                     and aa.tp1corr1 = 222222
                                     and aa.tp1corr2 = 1
                                     and aa.tp1corr3 > 0)
             and rownum = 1;
        exception
          when others then
            lc_garantia2 := 'N';
        end;
      
        if nvl(lc_garantia2, 'N') = 'N' then
          if j.bcsdmn > ln_mtoAnt2 then
            ln_mtoMaximo2 := j.bcsdmn;
          end if;
          ln_mtoAnt2 := j.bcsdmn;
        end if;
      
      end loop;
      ld_fecFM := add_months(ld_fecFM, -1);
      ln_k     := ln_k + 1;
    end loop;
  
    pn_mtoHisMax := nvl(ln_mtoMaximo2, 0);
  
  end sp_valida;

end pq_cr_resolutor_campnav2020;
/

