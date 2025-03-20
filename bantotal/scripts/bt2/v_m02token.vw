create or replace force view v_m02token as
select
decode(a.numtar,b.Z0E478NRO,substr(a.numtar,0,6)||'******'||substr(a.numtar,13,4),a.numtar) numtar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.token,
a.idtra,
a.estok,
a.dattk, medio, destino ,resultado,
operacion,canal, tipotoken, ddeviceid, dmodelo, dso, dlat, dlong
from M02TOKEN a left outer join Z0E478 b
  on a.numtar=b.Z0E478NRO;

