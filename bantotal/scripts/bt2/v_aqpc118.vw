create or replace force view v_aqpc118 as
select
a.aqpc118id,
--substr(a.aqpc118tar,0,6)||'******'||substr(a.aqpc118tar,13,4) AQPC118TAR,
decode(a.aqpc118tar,b.Z0E478NRO,substr(a.aqpc118tar,0,6)||'******'||substr(a.aqpc118tar,13,4),a.aqpc118tar) AQPC118TAR,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpc118met,
a.aqpc118fei,
a.aqpc118hoi,
a.aqpc118trc,
a.aqpc118est,
a.aqpc118tex,
a.aqpc118cer,
a.aqpc118mer,
a.aqpc118req,
a.aqpc118res,
a.aqpc118ced,
a.aqpc118med,
a.aqpc118pgm
-- from AQPC118
from AQPC118 a left outer join Z0E478 b
  on a.AQPC118TAR=b.Z0E478NRO
;

