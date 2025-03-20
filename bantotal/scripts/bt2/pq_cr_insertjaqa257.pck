CREATE OR REPLACE PACKAGE PQ_cR_InsertJaqa257 is
  Procedure Sp_update(pd_fecpro in date);
end;
/

CREATE OR REPLACE PACKAGE body PQ_cR_InsertJaqa257 is

  Procedure Sp_update(pd_fecpro in date) is
  
    cursor creditos is
      select *
        from jaqa257 a
       where a.jaqa257fec = pd_fecpro
         and a.jaqa257est = 'A';
    ld_MaxFch602 date;
    ld_MinFch601 date;
    ld_fecpag    date;
    ln_period    number(5);
    ln_cont      number(5);
    ln_sdo       number(17, 2);
  begin
  
    for l in creditos loop
    
      begin
        select max(f.ppfpag)
          into ld_MaxFch602
          from fsd602 f
         where f.pgcod = l.jaqa257emp
           and f.ppmod = l.jaqa257mod
           and f.ppsuc = l.jaqa257suc
           and f.ppmda = l.jaqa257mda
           and f.pppap = l.jaqa257pap
           and f.ppcta = l.jaqa257cta
           and f.ppoper = l.jaqa257ope
           and f.ppsbop = l.jaqa257sbo
           and f.pptope = l.jaqa257tpo
           and f.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      if ld_MaxFch602 is not null then
      
        begin
          select min(f.ppfval), min(f.ppfpag)
            into ld_MinFch601, ld_fecpag
            from fsd601 f
           where f.pgcod = l.jaqa257emp
             and f.ppmod = l.jaqa257mod
             and f.ppsuc = l.jaqa257suc
             and f.ppmda = l.jaqa257mda
             and f.pppap = l.jaqa257pap
             and f.ppcta = l.jaqa257cta
             and f.ppoper = l.jaqa257ope
             and f.ppsbop = l.jaqa257sbo
             and f.pptope = l.jaqa257tpo
             and f.ppfpag > ld_MaxFch602
             and f.d601co = 'S';
        exception
          when others then
            null;
        end;
      
        begin
          select count(*)
            into ln_cont
            from fsd601 f
           where f.pgcod = l.jaqa257emp
             and f.ppmod = l.jaqa257mod
             and f.ppsuc = l.jaqa257suc
             and f.ppmda = l.jaqa257mda
             and f.pppap = l.jaqa257pap
             and f.ppcta = l.jaqa257cta
             and f.ppoper = l.jaqa257ope
             and f.ppsbop = l.jaqa257sbo
             and f.pptope = l.jaqa257tpo
             and f.ppfpag > ld_MaxFch602
             and f.d601co = 'S';
        exception
          when others then
            null;
        end;
      else
        begin
          select min(f.ppfval), min(f.ppfpag)
            into ld_MinFch601, ld_fecpag
            from fsd601 f
           where f.pgcod = l.jaqa257emp
             and f.ppmod = l.jaqa257mod
             and f.ppsuc = l.jaqa257suc
             and f.ppmda = l.jaqa257mda
             and f.pppap = l.jaqa257pap
             and f.ppcta = l.jaqa257cta
             and f.ppoper = l.jaqa257ope
             and f.ppsbop = l.jaqa257sbo
             and f.pptope = l.jaqa257tpo
             and f.d601co = 'S';
        exception
          when others then
            null;
        end;
      
        begin
          select count(*)
            into ln_cont
            from fsd601 f
           where f.pgcod = l.jaqa257emp
             and f.ppmod = l.jaqa257mod
             and f.ppsuc = l.jaqa257suc
             and f.ppmda = l.jaqa257mda
             and f.pppap = l.jaqa257pap
             and f.ppcta = l.jaqa257cta
             and f.ppoper = l.jaqa257ope
             and f.ppsbop = l.jaqa257sbo
             and f.pptope = l.jaqa257tpo
             and f.d601co = 'S';
        exception
          when others then
            null;
        end;
      end if;
    
      begin
        select a.scsdo * -1
          into ln_sdo
          from fsd011 a
         where a.pgcod = l.jaqa257emp
           and a.scmod = l.jaqa257mod
           and a.scsuc = l.jaqa257suc
           and a.scmda = l.jaqa257mda
           and a.scpap = l.jaqa257pap
           and a.sccta = l.jaqa257cta
           and a.scoper = l.jaqa257ope
           and a.scsbop = l.jaqa257sbo
           and a.sctope = l.jaqa257tpo;
      exception
        when others then
          null;
      end;
    
      begin
        select a.aoperiod
          into ln_period
          from fsd010 a
         where a.pgcod = l.jaqa257emp
           and a.aomod = l.jaqa257mod
           and a.aosuc = l.jaqa257suc
           and a.aomda = l.jaqa257mda
           and a.aopap = l.jaqa257pap
           and a.aocta = l.jaqa257cta
           and a.aooper = l.jaqa257ope
           and a.aosbop = l.jaqa257sbo
           and a.aotope = l.jaqa257tpo;
      exception
        when others then
          null;
      end;
    
      update jaqa257 a
         set a.jaqa257ccu = ln_cont,
             a.jaqa257pcu = ln_period,
             a.jaqa257scr = ln_sdo,
             a.JAQA257FRE = ld_MinFch601,
             a.JAQA257FPG = ld_fecpag
       where a.jaqa257emp = l.jaqa257emp
         and a.jaqa257mod = l.jaqa257mod
         and a.jaqa257suc = l.jaqa257suc
         and a.jaqa257mda = l.jaqa257mda
         and a.jaqa257pap = l.jaqa257pap
         and a.jaqa257cta = l.jaqa257cta
         and a.jaqa257ope = l.jaqa257ope
         and a.jaqa257sbo = l.jaqa257sbo
         and a.jaqa257tpo = l.jaqa257tpo;
    
      commit;
    
    end loop;
    commit;
  end Sp_update;

end;
/

