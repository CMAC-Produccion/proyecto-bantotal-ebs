create or replace force view v_jaql635h as
select
a.n_serenvh,
a.c_canenvh,
a.d_fecenvh,
a.c_horenvh,
bantprod.FN_CC_REPLACE_TRAMA_JAQL540(a.c_trmenvh) c_trmenvh,
a.c_obsenvh,
a.c_auxvc1h,
a.c_auxvc2h,
a.c_auxvc3h,
a.n_auxnu1h,
a.n_auxnu2h,
a.n_auxnu3h,
a.d_auxda1h,
a.d_auxda2h,
a.d_auxda3h
from JAQL635H a;

