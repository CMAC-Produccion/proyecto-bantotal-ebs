create or replace force view v_aqpa726 as
select
aqpa726id,
--a.aqpa726numtar,
decode(a.aqpa726numtar,b.Z0E478NRO,substr(a.aqpa726numtar,0,6)||'******'||substr(a.aqpa726numtar,13,4),a.aqpa726numtar) aqpa726numtar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpa726canal, a.aqpa726correo, a.aqpa726celular, a.aqpa726texto,
a.aqpa726fecreg, a.aqpa726horreg, a.aqpa726errcel, a.aqpa726errcor
from AQPA726 a left outer join Z0E478 b
  on a.aqpa726numtar=b.Z0E478NRO
;

