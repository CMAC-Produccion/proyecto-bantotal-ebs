create or replace force view v_aqpb216 as
select
a.aqpb216idl, a.aqpb216sen,
decode(a.aqpb216nro,b.Z0E478NRO,substr(a.aqpb216nro,0,6)||'******'||substr(a.aqpb216nro,13,4),a.aqpb216nro) aqpb216nro,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpb216pco, a.aqpb216nco, a.aqpb216nrd, a.aqpb216pcd, a.aqpb216ncd,
a.aqpb216fet, a.aqpb216hot, a.aqpb216trc, a.aqpb216imp, a.aqpb216mda, a.aqpb216des, a.aqpb216pgo, a.aqpb216moo,
a.aqpb216suo, a.aqpb216mdo, a.aqpb216pao, a.aqpb216cto, a.aqpb216opo, a.aqpb216sbo, a.aqpb216too, a.aqpb216pgd,
a.aqpb216mod, a.aqpb216sud, a.aqpb216mdd, a.aqpb216pad, a.aqpb216ctd, a.aqpb216opd, a.aqpb216sbd, a.aqpb216tod,
a.aqpb216est, a.aqpb216pgc, a.aqpb216moc, a.aqpb216suc, a.aqpb216tnc, a.aqpb216nrc, a.aqpb216fec, a.aqpb216con,
a.aqpb216mnc, a.aqpb216tid,A.AQPB216CMS,A.AQPB216CTR,A.aqpb216dirdes,A.aqpb216idedes,A.aqpb216ideqr
 from AQPB216 a left outer join Z0E478 b
  on a.aqpb216nro=b.Z0E478NRO;

