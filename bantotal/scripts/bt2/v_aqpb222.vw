create or replace force view v_aqpb222 as
select
a.aqpb222idl,
decode(a.AQPB222NRO,b.Z0E478NRO,substr(a.AQPB222NRO,0,6)||'******'||substr(a.AQPB222NRO,13,4),a.AQPB222NRO) AQPB222NRO,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpb222fei, a.aqpb222hoi, a.aqpb222pgc, a.aqpb222mod, a.aqpb222suc, a.aqpb222mda, a.aqpb222pap, a.aqpb222cta, a.aqpb222ope,
a.aqpb222sbo, a.aqpb222top, a.aqpb222imp, a.aqpb222cor, a.aqpb222ncu, a.aqpb222itc, a.aqpb222mid, a.aqpb222cqr, a.aqpb222tip,
a.aqpb222pnu, a.aqpb222cau, a.aqpb222trn, a.aqpb222tid, a.aqpb222eti, a.aqpb222idu, a.aqpb222tex, a.aqpb222req, a.aqpb222res,
a.aqpb222est, a.aqpb222cer, a.aqpb222mer, a.aqpb222ced, a.aqpb222med, a.aqpb222pgo, a.aqpb222moc, a.aqpb222suo, a.aqpb222tnc,
a.aqpb222nrc, a.aqpb222fec, a.aqpb222con, a.aqpb222cms, a.aqpb222ctr, a.aqpb222an1, a.aqpb222ac1, a.aqpb222af1, a.aqpb222at1
from AQPB222 a left outer join Z0E478 b
  on a.AQPB222NRO=b.Z0E478NRO;

