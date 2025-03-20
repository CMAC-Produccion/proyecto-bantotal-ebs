create or replace force view v_aqpa707a as
select
a.aqpa707acodusu, a.aqpa707acorr, a.aqpa707afecini, a.aqpa707afecfin, a.aqpa707afecreg, a.aqpa707ahorreg, a.aqpa707anumope, a.aqpa707atipope,
decode(a.aqpa707anumtar,null,null,decode(a.aqpa707anumtar,substr(b.Z0E478NRO,1,16),substr(a.aqpa707anumtar,0,6)||'******'||substr(a.aqpa707anumtar,13,4),a.aqpa707anumtar)) aqpa707anumtar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpa707anumcta, a.aqpa707aimpope, a.aqpa707amodulo, a.aqpa707atransa, a.aqpa707aauxn2,
a.aqpa707aauxn3, a.aqpa707aauxc1, a.aqpa707aauxc2, a.aqpa707arelaci, a.aqpa707aauxn1, a.aqpa707asucurs, a.aqpa707atotal,
a.aqpa707aflag
from AQPA707A a left outer join Z0E478 b
  on rpad(a.aqpa707anumtar,19,' ')=b.Z0E478NRO;

