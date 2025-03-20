create or replace force view v_fsd612 as
select pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, ppfpag, pptipo, pp1nump, pp1exte, pp1imp1, pp1imp2, pp1imp3, pp1imp4,
pp1imp5, pp1imp6, pp1imp7, pp1imp8, pp1imp9, pp1imp10, pp1imp11, pp1imp12, pp1imp13, pp1imp14, pp1imp15, pp1imp16, pp1imp17, pp1imp18, pp1imp19,
pp1imp20, pp1sal1, pp1sal2, pp1sal3, pp1sal4, pp1sal5, pp1sal6, pp1sal7, pp1sal8, pp1sal9, pp1sal10, pp1sal11, pp1sal12, pp1sal13, pp1sal14,
pp1sal15, pp1sal16, pp1sal17, pp1sal18, pp1sal19, pp1sal20
 from FSD612
union all
select pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, ppfpag, pptipo, pp1nump, pp1exte, pp1imp1, pp1imp2, pp1imp3, pp1imp4,
pp1imp5, pp1imp6, pp1imp7, pp1imp8, pp1imp9, pp1imp10, pp1imp11, pp1imp12, pp1imp13, pp1imp14, pp1imp15, pp1imp16, pp1imp17, pp1imp18, pp1imp19,
pp1imp20, pp1sal1, pp1sal2, pp1sal3, pp1sal4, pp1sal5, pp1sal6, pp1sal7, pp1sal8, pp1sal9, pp1sal10, pp1sal11, pp1sal12, pp1sal13, pp1sal14,
pp1sal15, pp1sal16, pp1sal17, pp1sal18, pp1sal19, pp1sal20
 from FSD612
 where 1=2 with read only;

