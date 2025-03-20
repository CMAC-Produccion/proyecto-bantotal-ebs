create or replace force view v_aqpb214 as
select
a.aqpb214idl,
decode(a.aqpb214tar,b.Z0E478NRO,substr(a.aqpb214tar,0,6)||'******'||substr(a.aqpb214tar,13,4),a.aqpb214tar) aqpb214tar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpb214met, a.aqpb214fei, a.aqpb214hoi, a.aqpb214est, a.aqpb214tex, a.aqpb214cer, a.aqpb214mer,
a.aqpb214an1, a.aqpb214ac1, a.aqpb214af1, a.aqpb214req, a.aqpb214res, a.aqpb214med, a.aqpb214ced, a.aqpb214pgm
 from AQPB214 a left outer join Z0E478 b
  on a.aqpb214tar=b.Z0E478NRO;

