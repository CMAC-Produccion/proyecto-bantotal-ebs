create or replace procedure SP_REPORTE_FATCA(FECPRO DATE, TIPO_R VARCHAR2) is

  cursor monto is
    select n_monto2 cta, n_monto3 tipo, sum(n_monto1) total
      from crdtcap
     group by n_monto2, n_monto3;

  cursor cuentas(cta number) is
    select d_fecha1,
           c_descri,
           c_descri1,
           c_descri2,
           c_descri3,
           c_descri4,
           c_descri5,
           c_descri6,
           c_descri7,
           c_descri8,
           c_descri9,
           c_descri10,
           c_descri11,
           c_descri12,
           c_descri13,
           c_descri14,
           c_descri15,
           c_descri16,
           c_descri17,
           c_descri18,
           n_monto1,
           c_descri20,
           c_descri21,
           c_descri22,
           c_descri23,
           c_descri24,
           c_descri25,
           c_descri26,
           c_descri27,
           c_descri28
      from crdtcap
     where n_monto2 = cta;

begin
  EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=". "';     
  begin
  
    delete from crdtcap;
  
    insert into crdtcap
      (d_fecha1,
       c_descri,
       c_descri1,
       c_descri2,
       c_descri3,
       c_descri4,
       c_descri5,
       c_descri6,
       c_descri7,
       c_descri8,
       c_descri9,
       c_descri10,
       c_descri11,
       c_descri12,
       c_descri13,
       c_descri14,
       c_descri15,
       c_descri16,
       c_descri17,
       c_descri18,
       n_monto1,
       c_descri20,
       c_descri21,
       c_descri22,
       c_descri23,
       c_descri24,
       c_descri25,
       c_descri26,
       c_descri27,
       c_descri28,
       n_monto2,
       n_monto3)
    
      select trunc(sysdate) fecha,
             to_char(sysdate, 'hh24:mi:ss') hora,
             0 tin_f,
             'US' country_FTIN,
             a.pfnom1 firstname,
             a.pfape1 lastname,
             e.iso3166_a2 country,
             substr(d.sngc13dir, 1, 100) adress,
             nvl(g.depnom, 'NO REGISTRADO') city,
             to_char(a.pffnac, 'YYYY-MM-DD') birthdate,
             0 tin_j,
             '' razsocial,
             '' rep_fi,
             '' rep_group,
             Tipo_R docspec, -- depende si se reprocesa
             'ID' || lpad(to_char(rownum), 4, '0') RefId,
             decode(c.scmod,
                    21,
                    lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                    lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                    lpad(sctope, 3, '0'),
                    lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                    lpad(scmda, 3, '0') || lpad(scoper, 9, '0') ||
                    lpad(sctope, 3, '0')) account_n,
             3 account_h,
             'FATCA103' acct_h_type,
             'POR DEFINIR' substancial_o,
             trim(to_char(nvl(decode(c.scmda,
                                     0,
                                     (h.bcsdmo /
                                     fn_tipo_cambio(FECPRO, 0, 101, 0)),
                                     h.bcsdmo),
                              0),
                          99999999990.999)) balance,
             'USD' currcode,
             'FATCA502' type,
             '00.000' payment,
             'USD' currcode_pay,
             '' gdoc,
             '' gaccount,
             '' gtype,
             '' gbalance,
             '' gcurrcode,
             c.sccta,
             1
        from fsd002  a,
             fsr008  b,
             fsd011  c,
             sngc13  d,
             jaql053 e,
             FST068  g,
             fsh012  h
       where a.pfpnac = 840
         and a.pfpais = b.pepais
         and a.pftdoc = b.petdoc
         and a.pfndoc = b.pendoc
         and c.sccta = b.ctnro
         and d.sngc13pais = b.pepais
         and d.sngc13tdoc = b.petdoc
         and d.sngc13ndoc = b.pendoc
         and d.sngc13pdoc = e.iso3166_n
         and g.pais(+) = d.sngc13pdoc
         and g.depcod(+) = d.sngc13dpto
         and h.bcemp = c.pgcod
         and h.bcsuc = c.scsuc
         and h.bcrubr = c.scrub
         and h.bcmda = c.scmda
         and h.bcpap = c.scpap
         and h.bccta = c.sccta
         and h.bcoper = c.scoper
         and h.bcsbop = c.scsbop
         and h.bctop = c.sctope
         and h.bcfech = FECPRO
         and b.ttcod = 1
         and b.cttfir = 'T'
         and c.pgcod = 1
         and c.scmod = 21
            --and c.scstat <> 99
         and d.sngc13est = 'H'
      
      union
      
      select trunc(sysdate) fecha,
             to_char(sysdate, 'hh24:mi:ss') hora,
             0 tin_f,
             'US' country_FTIN,
             a.pfnom1 firstname,
             a.pfape1 lastname,
             e.iso3166_a2 country,
             substr(d.sngc13dir, 1, 100) adress,
             nvl(g.depnom, 'NO REGISTRADO') city,
             to_char(a.pffnac, 'YYYY-MM-DD') birthdate,
             0 tin_j,
             '' razsocial,
             '' rep_fi,
             '' rep_group,
             Tipo_R docspec, -- depende si se reprocesa
             'ID' || lpad(to_char(rownum), 4, '0') RefId,
             decode(aomod,
                    21,
                    lpad(aocta, 9, '0') || lpad(aomod, 3, '0') ||
                    lpad(aomda, 3, '0') || lpad(aosbop, 2, '0') ||
                    lpad(aotope, 3, '0'),
                    lpad(aocta, 9, '0') || lpad(aomod, 3, '0') ||
                    lpad(aomda, 3, '0') || lpad(aooper, 9, '0') ||
                    lpad(aotope, 3, '0')) account_n,
             3 account_h,
             'FATCA103' acct_h_type,
             'POR DEFINIR' substancial_o,
             trim(to_char(nvl(decode(aomda,
                                     0,
                                     (p.aoimp /
                                     fn_tipo_cambio(FECPRO, 0, 101, 0)),
                                     p.aoimp),
                              0),
                          99999999990.999)) balance,
             'USD' currcode,
             'FATCA502' type,
             '00.000' payment,
             'USD' currcode_pay,
             '' gdoc,
             '' gaccount,
             '' gtype,
             '' gbalance,
             '' gcurrcode,
             p.aocta,
             1
        from fsd002 a, fsr008 b, fsd010 p, sngc13 d, jaql053 e, FST068 g
       where a.pfpnac = 840
         and a.pfpais = b.pepais
         and a.pftdoc = b.petdoc
         and a.pfndoc = b.pendoc
         and p.aocta = b.ctnro
         and d.sngc13pais = b.pepais
         and d.sngc13tdoc = b.petdoc
         and d.sngc13ndoc = b.pendoc
         and d.sngc13pdoc = e.iso3166_n
         and g.pais(+) = d.sngc13pdoc
         and g.depcod(+) = d.sngc13dpto
         and p.aofval <= FECPRO
         and (p.aostat <> 99 or (p.aostat = 99 and p.aofe99 > FECPRO))
         and b.ttcod = 1
         and b.cttfir = 'T'
         and p.pgcod = 1
         and p.aomod = 22
         and d.sngc13est = 'H'
      
      union
      
      select trunc(sysdate) fecha,
             to_char(sysdate, 'hh24:mi:ss') hora,
             0 tin_f,
             'US' country_FTIN,
             '' firstname,
             '' lastname,
             --d.sngc13pdoc,
             --pfndoc
             e.iso3166_a2 country,
             substr(d.sngc13dir, 1, 100) adress,
             nvl(g.depnom, 'NO REGISTRADO') city,
             '' birthdate,
             0 tin_j,
             a.pjrazs razsocial,
             '' rep_fi,
             '' rep_group,
             Tipo_R docspec, -- depende si se reprocesa
             'ID' || lpad(to_char(rownum), 4, '0') RefId, -- función
             decode(c.scmod,
                    21,
                    lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                    lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                    lpad(sctope, 3, '0'),
                    lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                    lpad(scmda, 3, '0') || lpad(scoper, 9, '0') ||
                    lpad(sctope, 3, '0')) account_n,
             3 account_h,
             'FATCA103' acct_h_type,
             'POR DEFINIR' substancial_o,
             trim(to_char(decode(c.scmda,
                                 101,
                                 (h.bcsdmo *
                                 fn_tipo_cambio(FECPRO, 0, 101, 0)),
                                 h.bcsdmo),
                          99999999990.999)) balance,
             'USD' currcode,
             'FATCA502' type,
             '00.000' payment,
             'USD' currcode_pay,
             '' gdoc,
             '' gaccount,
             '' gtype,
             '' gbalance,
             '' gcurrcode,
             C.SCCTA,
             2
        from fsd003  a,
             fsr008  b,
             fsd011  c,
             sngc13  d,
             jaql053 e,
             FST068  g,
             fsh012  h
       where a.pjpais = 840
         and a.pjpais = b.pepais
         and a.pjtdoc = b.petdoc
         and a.pjndoc = b.pendoc
         and c.sccta = b.ctnro
         and d.sngc13pais = b.pepais
         and d.sngc13tdoc = b.petdoc
         and d.sngc13ndoc = b.pendoc
         and d.sngc13pdoc = e.iso3166_n
         and g.pais(+) = d.sngc13pdoc
         and g.depcod(+) = d.sngc13dpto
         and h.bcemp = c.pgcod
         and h.bcsuc = c.scsuc
         and h.bcrubr = c.scrub
         and h.bcmda = c.scmda
         and h.bcpap = c.scpap
         and h.bccta = c.sccta
         and h.bcoper = c.scoper
         and h.bcsbop = c.scsbop
         and h.bctop = c.sctope
         and h.bcfech = FECPRO
         and b.ttcod = 1
         and b.cttfir = 'T'
         and c.pgcod = 1
         and c.scmod = 21
            --and c.scstat <> 99
         and d.sngc13est = 'H'
      
      union
      
      select trunc(sysdate) fecha,
             to_char(sysdate, 'hh24:mi:ss') hora,
             0 tin_f,
             'US' country_FTIN,
             '' firstname,
             '' lastname,
             --d.sngc13pdoc,
             --pfndoc
             e.iso3166_a2 country,
             substr(d.sngc13dir, 1, 100) adress,
             nvl(g.depnom, 'NO REGISTRADO') city,
             '' birthdate,
             0 tin_j,
             a.pjrazs razsocial,
             '' rep_fi,
             '' rep_group,
             Tipo_R docspec, -- depende si se reprocesa
             'ID' || lpad(to_char(rownum), 4, '0') RefId,
             decode(aomod,
                    21,
                    lpad(aocta, 9, '0') || lpad(aomod, 3, '0') ||
                    lpad(aomda, 3, '0') || lpad(aosbop, 2, '0') ||
                    lpad(aotope, 3, '0'),
                    lpad(aocta, 9, '0') || lpad(aomod, 3, '0') ||
                    lpad(aomda, 3, '0') || lpad(aooper, 9, '0') ||
                    lpad(aotope, 3, '0')) account_n,
             3 account_h,
             'FATCA103' acct_h_type,
             'POR DEFINIR' substancial_o,
             trim(to_char(nvl(decode(aomda,
                                     0,
                                     (p.aoimp /
                                     fn_tipo_cambio(FECPRO, 0, 101, 0)),
                                     p.aoimp),
                              0),
                          99999999990.999)) balance,
             'USD' currcode,
             'FATCA502' type,
             '00.000' payment,
             'USD' currcode_pay,
             '' gdoc,
             '' gaccount,
             '' gtype,
             '' gbalance,
             '' gcurrcode,
             p.aocta,
             1
        from fsd003 a, fsr008 b, fsd010 p, sngc13 d, jaql053 e, FST068 g
       where a.pjpais = 840
         and a.pjpais = b.pepais
         and a.pjtdoc = b.petdoc
         and a.pjndoc = b.pendoc
         and p.aocta = b.ctnro
         and d.sngc13pais = b.pepais
         and d.sngc13tdoc = b.petdoc
         and d.sngc13ndoc = b.pendoc
         and d.sngc13pdoc = e.iso3166_n
         and g.pais(+) = d.sngc13pdoc
         and g.depcod(+) = d.sngc13dpto
         and p.aofval <= FECPRO
         and (p.aostat <> 99 or (p.aostat = 99 and p.aofe99 > FECPRO))
         and b.ttcod = 1
         and b.cttfir = 'T'
         and p.pgcod = 1
         and p.aomod = 22
         and d.sngc13est = 'H';
  
  end;

  delete from jaql052;

  begin
    for i in monto loop
      if (i.total >= 50000 and i.tipo = 1) or
         (i.total >= 250000 and i.tipo = 2) then
        -- mayor a 50 mil PN y 250 mil en PJ
        for j in cuentas(i.cta) loop
          insert into jaql052
          values
            (j.d_fecha1,
             j.c_descri,
             j.c_descri1,
             j.c_descri2,
             j.c_descri3,
             j.c_descri4,
             j.c_descri5,
             j.c_descri6,
             j.c_descri7,
             j.c_descri8,
             j.c_descri9,
             j.c_descri10,
             j.c_descri11,
             j.c_descri12,
             j.c_descri13,
             j.c_descri14,
             j.c_descri15,
             j.c_descri16,
             j.c_descri17,
             j.c_descri18,
             to_char(j.n_monto1, 99999999990.999),
             j.c_descri20,
             j.c_descri21,
             j.c_descri22,
             j.c_descri23,
             j.c_descri24,
             j.c_descri25,
             j.c_descri26,
             j.c_descri27,
             j.c_descri28);
        end loop;
      
      end if;
    
    end loop;
  end;

end SP_REPORTE_FATCA;
/

