create or replace force view v_fsd611 as
select pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, ppfpag, pptipo, ppexte, ppimp1, ppimp2, ppimp3, ppimp4,
ppimp5, ppimp6, ppimp7, ppimp8, ppimp9, ppimp10, ppimp11, ppimp12, ppimp13, ppimp14, ppimp15, ppimp16, ppimp17, ppimp18, ppimp19, ppimp20
 from FSD611
union all
select pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, ppfpag, pptipo, ppexte, ppimp1, ppimp2, ppimp3, ppimp4,
ppimp5, ppimp6, ppimp7, ppimp8, ppimp9, ppimp10, ppimp11, ppimp12, ppimp13, ppimp14, ppimp15, ppimp16, ppimp17, ppimp18, ppimp19, ppimp20
 from FSD611
 where 1=2 with read only;

