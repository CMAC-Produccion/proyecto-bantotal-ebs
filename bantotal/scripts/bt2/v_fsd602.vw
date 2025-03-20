create or replace force view v_fsd602 as
select pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, ppfpag, pptipo, pp1nump, pp1fech, pp1cap, pp1int, pp1intmex,
pp1intm, pp1intmmex, pp1icap, pp1iint, pp1iintm, pp1salcap, pp1salint, pp1salade, pp1salmor, pp1stat, pp1salintm, pp1salmorm, pp1saladem,
d602cd, d602mo, d602su, d602tr, d602re, d602fc, d602or, d602sb, d602co from fsd602
union all
select pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, ppfpag, pptipo, pp1nump, pp1fech, pp1cap, pp1int, pp1intmex,
pp1intm, pp1intmmex, pp1icap, pp1iint, pp1iintm, pp1salcap, pp1salint, pp1salade, pp1salmor, pp1stat, pp1salintm, pp1salmorm, pp1saladem,
d602cd, d602mo, d602su, d602tr, d602re, d602fc, d602or, d602sb, d602co from fsd602
 where 1=2 with read only;

