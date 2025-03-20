create or replace force view v_fsd601 as
select pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, ppfpag, pptipo, ppfval, ppfvto, pppzo, ppcap, ppint,
ppintmex, ppicap, ppiint, ppstat, ppnume, ppfinv, d601cd, d601mo, d601su, d601tr, d601re, d601fc, d601or, d601sb, d601co from fsd601
union all
select pgcod, ppmod, ppsuc, ppmda, pppap, ppcta, ppoper, ppsbop, pptope, ppfpag, pptipo, ppfval, ppfvto, pppzo, ppcap, ppint,
ppintmex, ppicap, ppiint, ppstat, ppnume, ppfinv, d601cd, d601mo, d601su, d601tr, d601re, d601fc, d601or, d601sb, d601co from fsd601
 where 1=2 with read only;

