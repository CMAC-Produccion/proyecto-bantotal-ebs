create or replace force view v_jaqn811 as
select
a.jaqn811emp,
decode(a.jaqn811nta,b.Z0E478NRO,substr(a.jaqn811nta,0,6)||'******'||substr(a.jaqn811nta,13,4),a.jaqn811nta) jaqn811nta,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqn811tta, a.jaqn811suc, a.jaqn811pai, a.jaqn811tdo, a.jaqn811nro, a.jaqn811fec,
a.jaqn811cor, a.jaqn811ori, a.jaqn811tdi, a.jaqn811ido, a.jaqn811tok, a.jaqn811lin, a.jaqn811lou
from JAQN811 a left outer join Z0E478 b
  on a.jaqn811nta=b.Z0E478NRO;

