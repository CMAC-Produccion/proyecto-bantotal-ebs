create or replace package PQ_CR_CALCULOSALDOS is
  procedure sp_cr_saldocapital(pn_cuenta   in number,
                               pn_tipcamb  in number,
                               pn_saldocap out number,
                               pn_saldodes out number);
  function fn_esDesembParc(pn_pgcod  number,
                           pn_scmod  number,
                           pn_scsuc  number,
                           pn_scmda  number,
                           pn_scpap  number,
                           pn_sccta  number,
                           pn_scoper number,
                           pn_scsbop number,
                           pn_sctope number) return number;
end PQ_CR_CALCULOSALDOS;
/

create or replace package body PQ_CR_CALCULOSALDOS is

  procedure sp_cr_saldocapital(pn_cuenta   in number,
                               pn_tipcamb  in number,
                               pn_saldocap out number,
                               pn_saldodes out number) is
    cursor creditos is
      select *
        from fsd011
       where scmod in (select tp1nro1
                         from fst198
                        where tp1cod = 1
                          and tp1cod1 = 11105
                          and tp1corr1 = 25
                          and tp1corr2 = 1
                          and tp1corr3 <> 0)
         and scstat <> 99
         and (pgcod, sccta) in (select pgcod, ctnro
                                  from fsr008
                                 where (pepais, petdoc, pendoc) in
                                       (select pepais, petdoc, pendoc
                                          from fsr008
                                         where pgcod = 1
                                           and ctnro = pn_cuenta)
                                   and cttfir = 'T'
                                UNION
                                select pgcod, ctnro
                                  from fsr008
                                 where (pepais, petdoc, pendoc) in
                                       (select rppais, rptdoc, rpndoc
                                          from fsr002
                                         where (pepais, petdoc, pendoc) in
                                               (select pepais, petdoc, pendoc
                                                  from fsr008
                                                 where pgcod = 1
                                                   and ctnro = pn_cuenta)
                                           and rpccyg = 66
                                        UNION
                                        select pepais, petdoc, pendoc
                                          from fsr002
                                         where (rppais, rptdoc, rpndoc) in
                                               (select pepais, petdoc, pendoc
                                                  from fsr008
                                                 where pgcod = 1
                                                   and ctnro = pn_cuenta)
                                           and rpccyg = 66)
                                   and cttfir = 'T')
         and substr(scrub, 5, 2) <> '04';
    cursor creditoFsd010(cpn_pgcod number, cpn_aomod number, cpn_aosuc number, cpn_aomda number, cpn_aopap number, cpn_aocta number, cpn_aooper number, cpn_aosbop number, cpn_aotop number) is
      select *
        from fsd010 a
       where a.pgcod = cpn_pgcod
         and a.aomod = cpn_aomod
         and a.aosuc = cpn_aosuc
         and a.aomda = cpn_aomda
         and a.aopap = cpn_aopap
         and a.aocta = cpn_aocta
         and a.aooper = cpn_aooper
         and a.aosbop = cpn_aosbop
         and a.aotope = cpn_aotop;
  
    ln_saldo number(18, 2);
  begin
    pn_saldocap := 0;
    pn_saldodes := 0;
  
    For i in creditos loop
      if fn_esDesembParc(i.pgcod,
                         i.scmod,
                         i.scsuc,
                         i.scmda,
                         i.scpap,
                         i.sccta,
                         i.scoper,
                         i.scsbop,
                         i.sctope) = 0 then
        ln_saldo := i.scsdo;
        if ln_saldo < 0 then
          ln_saldo := ln_saldo * -1;
        end if;
      
        if i.scmda = 101 then
          ln_saldo := ln_saldo * pn_tipcamb;
        end If;
      
        pn_saldocap := pn_saldocap + ln_saldo;
        For j in creditoFsd010(i.pgcod,
                               i.scmod,
                               i.scsuc,
                               i.scmda,
                               i.scpap,
                               i.sccta,
                               i.scoper,
                               i.scsbop,
                               i.sctope) loop
          ln_saldo := j.aoimp;
          if ln_saldo < 0 then
            ln_saldo := ln_saldo * -1;
          end if;
        
          if i.scmda = 101 then
            ln_saldo := ln_saldo * pn_tipcamb;
          end If;
        
          pn_saldodes := pn_saldodes + ln_saldo;
        
        end loop;
      end if;
    end loop;
  
  end sp_cr_saldocapital;

  function fn_esDesembParc(pn_pgcod  number,
                           pn_scmod  number,
                           pn_scsuc  number,
                           pn_scmda  number,
                           pn_scpap  number,
                           pn_sccta  number,
                           pn_scoper number,
                           pn_scsbop number,
                           pn_sctope number) return number is
    respuesta number;
    instancia number(10);
    origen    number(2);
  begin
    begin
      select a.xwfprcins
        into instancia
        from xwf700 a
       where a.xwfempresa = pn_pgcod
         and a.xwfsucursal = pn_scsuc
         and a.xwfmodulo = pn_scmod
         and a.xwfmoneda = pn_scmda
         and a.xwfpapel = pn_scpap
         and a.xwfcuenta = pn_sccta
         and a.xwfoperacion = pn_scoper
         and a.xwfsubope = pn_scsbop
         and a.xwftipope = pn_sctope
         and a.xwfcar3 = '1';
    
      select sng001ori
        into origen
        from sng001
       where sng001inst = instancia;
    exception
      when others then
        origen := 0;
    end;
    If origen = 7 then
      respuesta := 1;
    else
      respuesta := 0;
    end if;
  
    return respuesta;
  
  end fn_esDesembParc;
end PQ_CR_CALCULOSALDOS;
/

