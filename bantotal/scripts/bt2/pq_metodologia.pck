create or replace package PQ_METODOLOGIA is
procedure proc_garantias(
  PN_PGCOD	in number,
  PN_AOMOD	in number,
  PN_AOSUC	in number,
  PN_AOMDA	in number,
  PN_AOPAP	in number,
  PN_AOCTA	in number,
  PN_AOOPER	in number,
  PN_AOSBOP	in number,
  PN_AOTOPE	in number,
  PN_MONGAS	out number,
  PN_MONGAD	out number,
  PC_DESGAR out VARCHAR2
 );
end PQ_METODOLOGIA;
/

create or replace package body PQ_METODOLOGIA is
  
  procedure proc_garantias(
    PN_PGCOD	in number,
    PN_AOMOD	in number,
    PN_AOSUC	in number,
    PN_AOMDA	in number,
    PN_AOPAP	in number,
    PN_AOCTA	in number,
    PN_AOOPER	in number,
    PN_AOSBOP	in number,
    PN_AOTOPE	in number,
    PN_MONGAS	out number,
    PN_MONGAD	out number,
    PC_DESGAR out VARCHAR2
   )
   is
   
   cursor cur_garantias( LN_PGCOD	in NUMBER,
                     LN_AOMOD	in NUMBER,
                     LN_AOSUC	in NUMBER,
                     LN_AOMDA	in NUMBER,
                     LN_AOPAP	in NUMBER,
                     LN_AOCTA	in NUMBER,
                     LN_AOOPER in NUMBER,
                     LN_AOSBOP in NUMBER,
                     LN_AOTOPE in NUMBER
   ) is
  --  select /*+parallel(g,2,1) use_nl(g a)*/
    select /*+ use_nl(g a)*/
      distinct
      h.pgcod, h.aomod, h.aosuc, h.aomda, h.aopap, h.aocta, h.aooper, h.aosbop, h.aotope, h.aoimp
      from fsr011 a, fsd010 c, fsr011 g, fsd010 h
    where  c.pgcod  = LN_PGCOD
       and c.aosuc  = LN_AOSUC
       and c.aomda  = LN_AOMDA
       and c.aopap  = LN_AOPAP
       and c.aocta  = LN_AOCTA
       and c.aooper = LN_AOOPER
       and c.aotope = LN_AOTOPE
       and c.aomod  = LN_AOMOD
       and c.aosbop = LN_AOSBOP
       and a.relcod = 46
       and a.r1suc  = c.aosuc
       and a.r1mda  = c.aomda
       and a.r1pap  = c.aopap
       and a.r1cta  = c.aocta
       and a.r1oper = c.aooper
       and a.r1tope = c.aotope
       and a.r1mod  = c.aomod
       and a.r1sbop = c.aosbop
       and g.relcod = 50
       and g.r011co = 'S'

       and g.r1suc  = a.r2suc
       and g.r1mda  = a.r2mda
       and g.r1pap  = a.r2pap
       and g.r1cta  = a.r2cta
       and g.r1oper = a.r2oper
       and g.r1tope = a.r2tope
       and g.r1mod  = a.r2mod
       and g.r1sbop  = a.r2sbop
       and c.aomod = 116
       and a.r011co = 'S'
       and a.r1cod = 1

       and h.pgcod  = g.r2cod
       and h.aosuc  = g.r2suc
       and h.aomda  = g.r2mda
       and h.aopap  = g.r2pap
       and h.aocta  = g.r2cta
       and h.aooper = g.r2oper
       and h.aotope = g.r2tope
       and h.aomod  = g.r2mod
       and h.aosbop = g.r2sbop
    union
    select
    distinct
      h.pgcod,
      h.aomod,
      h.aosuc,
      h.aomda,
      h.aopap,
      h.aocta,
      h.aooper,
      h.aosbop,
      h.aotope, h.aoimp
      from fsr011 a, fsd010 c, fsd010 h
    where a.relcod = 50
       and c.aosuc = LN_AOSUC
       and c.aomda = LN_AOMDA
       and c.aopap = LN_AOPAP
       and c.aocta = LN_AOCTA
       and c.aooper = LN_AOOPER
       and c.aosbop = LN_AOSBOP
       and c.aotope = LN_AOTOPE
       and c.aomod = LN_AOMOD

       and c.aosuc = a.r1suc
       and c.aomda = a.r1mda
       and c.aopap = a.r1pap
       and c.aocta = a.r1cta
       and c.aooper = a.r1oper
       and c.aosbop = a.r1sbop
       and c.aotope = a.r1tope
       and c.aomod = a.r1mod
       and c.aomod <> 116
       and a.r011co = 'S'

       and h.pgcod = 1
       and h.aosuc = a.r2suc
       and h.aomda = a.r2mda
       and h.aopap = a.r2pap
       and h.aocta = a.r2cta
       and h.aooper = a.r2oper
       and h.aosbop = a.r2sbop
       and h.aotope = a.r2tope
       and h.aomod = a.r2mod
       and r1cod = 1;
       
       ln_monsol number;
       ln_mondol number;
              
       lc_desgar varchar2(2000);
       lc_tonom char(30);
       garantias_rec cur_garantias%ROWTYPE;
       ln_contador number;
  begin
      EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';  
      ln_monsol := 0;
      ln_mondol := 0;
      lc_desgar := '';
      ln_contador := 0;
      open cur_garantias(
        PN_PGCOD, PN_AOMOD, PN_AOSUC,
        PN_AOMDA, PN_AOPAP, PN_AOCTA,
        PN_AOOPER, PN_AOSBOP, PN_AOTOPE
      );
      loop
      
        fetch cur_garantias
          into garantias_rec;
        exit when cur_garantias%notfound;          
        begin        
          SELECT tonom INTO lc_tonom
          FROM Fst004
          WHERE Modulo = garantias_rec.aomod and
                 Totope = garantias_rec.aotope;
        exception
          when no_data_found then
          lc_tonom := ' ';
        end;
    
       if ln_contador = 0 then
          lc_desgar := lc_tonom;
          ln_contador := ln_contador + 1;
       else
          lc_desgar := Trim(lc_desgar) || ' - '|| Trim(lc_tonom);
       end if;
         
       IF garantias_rec.aomda = 0 then 
          ln_monsol := ln_monsol + garantias_rec.aoimp;
       ELSE
          ln_mondol := ln_mondol + garantias_rec.aoimp;
       END IF;
          
       
        
      end loop;

      close cur_garantias;
      PN_MONGAS := ln_monsol;
      PN_MONGAD := ln_mondol;
      PC_DESGAR := lc_desgar;
  end proc_garantias;
END PQ_METODOLOGIA;
/

