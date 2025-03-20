create or replace force view v_aqpa198 as
select
substr(a.aqpa198nutar,0,6)||'******'||substr(a.aqpa198nutar,13,4) aqpa198nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
  aqpa198imei  ,
  aqpa198modelo ,
  aqpa198fecreg,
  aqpa198horreg,--
  aqpa198paidoc,
  aqpa198tipdoc,
  aqpa198numdoc,
  aqpa198deviceid,
  aqpa198dso,
  aqpa198dlat,
  aqpa198dlong,
  aqpa198estado,
  aqpa198canal,
  aqpa198fecact,
  aqpa198horact,
  aqpa198usuario
from AQPA198 a left outer join Z0E478 b
on a.aqpa198nutar=b.Z0E478NRO
;

