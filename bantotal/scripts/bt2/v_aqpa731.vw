create or replace force view v_aqpa731 as
select
a.aqpa731id,
a.aqpa731tokrefid,
--aqpa731numtar,
decode(a.aqpa731numtar,b.Z0E478NRO,substr(a.aqpa731numtar,0,6)||'******'||substr(a.aqpa731numtar,13,4),a.aqpa731numtar) aqpa731numtar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
--aqpa731tarori,
decode(a.aqpa731tarori,b.Z0E478NRO,substr(a.aqpa731tarori,0,6)||'******'||substr(a.aqpa731tarori,13,4),a.aqpa731tarori) aqpa731tarori,
a.aqpa731devid,
a.aqpa731devtyp,
a.aqpa731devnum,
a.aqpa731devnam,
a.aqpa731sernum,
a.aqpa731devidx,
a.aqpa731evento,
a.aqpa731fecreg,
a.aqpa731horreg,
a.aqpa731fecact,
a.aqpa731horact

from AQPA731 a left outer join Z0E478 b
  on a.aqpa731numtar=b.Z0E478NRO
;

