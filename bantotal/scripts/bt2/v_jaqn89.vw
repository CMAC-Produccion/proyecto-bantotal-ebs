create or replace force view v_jaqn89 as
select
a.jaqn89emp,
decode(a.JAQN89NTA,b.Z0E478NRO,substr(a.JAQN89NTA,0,6)||'******'||substr(a.JAQN89NTA,13,4),a.JAQN89NTA) JAQN89NTA,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqn89tta, a.jaqn89suc, a.jaqn89pai, a.jaqn89tdo, a.jaqn89nro, jaqn89fec,
jaqn89cor, jaqn89tdi, jaqn89ido, jaqn89tok, jaqn89lin, jaqn89lou
from JAQN89 a left outer join Z0E478 b
  on a.JAQN89NTA=b.Z0E478NRO;

