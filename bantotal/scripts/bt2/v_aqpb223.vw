create or replace force view v_aqpb223 as
select
a.aqpb223idl,
--a.aqpb223nro,
decode(a.aqpb223nro,b.Z0E478NRO,substr(a.aqpb223nro,0,6)||'******'||substr(a.aqpb223nro,13,4),a.aqpb223nro) aqpb223nro,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpb223fei, a.aqpb223hoi, a.aqpb223pgc, a.aqpb223mod, a.aqpb223suc, a.aqpb223mda, a.aqpb223pap, a.aqpb223cta, a.aqpb223ope,
a.aqpb223sbo, a.aqpb223top, a.aqpb223imp, a.aqpb223cab, a.aqpb223nut, a.aqpb223noc, a.aqpb223bmi, a.aqpb223tmc, a.aqpb223cqr,
a.aqpb223tip, a.aqpb223cau, a.aqpb223iid, a.aqpb223tre, a.aqpb223tex, a.aqpb223req, a.aqpb223res, a.aqpb223est, a.aqpb223cer,
a.aqpb223mer, a.aqpb223ced, a.aqpb223med, a.aqpb223pgo, a.aqpb223moc, a.aqpb223suo, a.aqpb223tnc, a.aqpb223nrc, a.aqpb223fec,
a.aqpb223con, a.aqpb223cms, a.aqpb223ctr, a.aqpb223an1, a.aqpb223ac1, a.aqpb223af1, a.aqpb223at1
from AQPB223 a left outer join Z0E478 b
  on a.aqpb223nro=b.Z0E478NRO
;

