create or replace force view v_jaqn810 as
select
a.jaqn810emp,
decode(a.jaqn810nta,b.Z0E478NRO,substr(a.jaqn810nta,0,6)||'******'||substr(a.jaqn810nta,13,4),a.jaqn810nta) jaqn810nta,
--substr(a.jaqn810nta,0,6)||'******'||substr(a.jaqn810nta,13,4) jaqn810nta,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqn810tta,
a.jaqn810suc,
a.jaqn810pai,
a.jaqn810tdo,
a.jaqn810nro,
a.jaqn810fec,
a.jaqn810nin,
a.jaqn810hit,
a.jaqn810txn,
a.jaqn810cor,
a.jaqn810tel,
a.jaqn810lgp,
a.jaqn810lgr
from JAQN810 a left outer join Z0E478 b
  on a.jaqn810nta=b.Z0E478NRO
;

