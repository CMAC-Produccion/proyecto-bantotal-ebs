create or replace procedure sp_actualizafpp002(pd_fec date) is

  cursor creditos is
  
    select distinct pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope
      from fpp002
     where (pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope) in
           (select aqpb002emp,
                   aqpb002mod,
                   aqpb002suc,
                   aqpb002mda,
                   aqpb002pap,
                   aqpb002cta,
                   aqpb002ope,
                   aqpb002sbo,
                   aqpb002top
              from aqpb002
			 where aqpb002fep = pd_fec
			 and aqpb002est = 'C'
			 and aqpb002revr is null);

  cursor juntos(ln_pgcod  number,
                ln_ppmod  number,
                ln_ppsuc  number,
                ln_ppmda  number,
                ln_pppap  number,
                ln_ppcta  number,
                ln_ppoper number,
                ln_ppsbop number,
                ln_pptope number) is
    select *
      from (select a.ppfpag,
                   a.pptipo,
                   b.ppfpag ppfpag003,
                   b.pptipo pptipo003
              from (select rownum cont1, a2.*
                      from (select a1.*
                              from fsd601 a1
                             where a1.pgcod = ln_pgcod
                               and a1.ppmod = ln_ppmod
                               and a1.ppsuc = ln_ppsuc
                               and a1.ppmda = ln_ppmda
                               and a1.pppap = ln_pppap
                               and a1.ppcta = ln_ppcta
                               and a1.ppoper = ln_ppoper
                               and a1.ppsbop = ln_ppsbop
                               and a1.pptope = ln_pptope
                               and a1.d601co = 'S'
                               and a1.pptipo <> 'K'
                             order by a1.ppfpag) a2) a
             inner join (select rownum cont2, b2.*
                          from (select b1.*
                                  from fpp002 b1
                                 where b1.pgcod = ln_pgcod
                                   and b1.ppmod = ln_ppmod
                                   and b1.ppsuc = ln_ppsuc
                                   and b1.ppmda = ln_ppmda
                                   and b1.pppap = ln_pppap
                                   and b1.ppcta = ln_ppcta
                                   and b1.ppoper = ln_ppoper
                                   and b1.ppsbop = ln_ppsbop
                                   and b1.pptope = ln_pptope
                                 order by b1.ppfpag) b2) b
                on a.pgcod = b.pgcod
               and a.ppmod = b.ppmod
               and a.ppsuc = b.ppsuc
               and a.ppmda = b.ppmda
               and a.pppap = b.pppap
               and a.ppcta = b.ppcta
               and a.ppoper = b.ppoper
               and a.ppsbop = b.ppsbop
               and a.pptope = b.pptope
               and a.cont1 = b.cont2
             where a.pgcod = ln_pgcod
               and a.ppmod = ln_ppmod
               and a.ppsuc = ln_ppsuc
               and a.ppmda = ln_ppmda
               and a.pppap = ln_pppap
               and a.ppcta = ln_ppcta
               and a.ppoper = ln_ppoper
               and a.ppsbop = ln_ppsbop
               and a.pptope = ln_pptope
               and a.d601co = 'S') xx
     where xx.ppfpag <> xx.ppfpag003
    
     order by xx.ppfpag desc;
begin
  for i in creditos loop    
    insert into jaqz520_002
      select *
        from fpp002 a
       where a.pgcod = i.pgcod
         and a.ppmod = i.ppmod
         and a.ppsuc = i.ppsuc
         and a.ppmda = i.ppmda
         and a.pppap = i.pppap
         and a.ppcta = i.ppcta
         and a.ppoper = i.ppoper
         and a.ppsbop = i.ppsbop
         and a.pptope = i.pptope;
  
    for g in juntos(i.pgcod,
                    i.ppmod,
                    i.ppsuc,
                    i.ppmda,
                    i.pppap,
                    i.ppcta,
                    i.ppoper,
                    i.ppsbop,
                    i.pptope) loop
      update fpp002 a
         set ppfpag = g.ppfpag, pptipo = g.pptipo
       where a.pgcod = i.pgcod
         and a.ppmod = i.ppmod
         and a.ppsuc = i.ppsuc
         and a.ppmda = i.ppmda
         and a.pppap = i.pppap
         and a.ppcta = i.ppcta
         and a.ppoper = i.ppoper
         and a.ppsbop = i.ppsbop
         and a.pptope = i.pptope
         and a.ppfpag = g.ppfpag003;
    
    end loop;
  end loop;
  commit;
end sp_actualizafpp002;
/

