create or replace force view v_aqpc312 as
select
aqpc312usureg, aqpc312fecreg, aqpc312numcor, aqpc312pgcod, aqpc312hcmod, aqpc312hsucor, aqpc312htran, aqpc312hnrel, aqpc312hfcon, aqpc312hcord,
aqpc312hcsubo, aqpc312hmodul, aqpc312htoper, aqpc312hmda, aqpc312hsucur, aqpc312hpap, aqpc312hcta, aqpc312hoper, aqpc312hsubop, aqpc312hfval,
aqpc312hcimp1,
substr(a.aqpc312hcref,0,6)||'******'||substr(a.aqpc312hcref,13,4)||substr(a.aqpc312hcref,17,length(a.aqpc312hcref)) aqpc312hcref
from AQPC312 a;

