create or replace force view v_aqpb101b as
select
a.aqpb101bpro,
decode(a.aqpb101btar,b.Z0E478NRO,substr(a.aqpb101btar,0,6)||'******'||substr(a.aqpb101btar,13,4),a.aqpb101btar) aqpb101btar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpb101bfec,
a.aqpb101bhor
from AQPB101B a left outer join Z0E478 b
  on a.aqpb101btar=b.Z0E478NRO;

