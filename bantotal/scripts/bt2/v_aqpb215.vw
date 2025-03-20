create or replace force view v_aqpb215 as
select
decode(a.aqpb215nro,b.Z0E478NRO,substr(a.aqpb215nro,0,6)||'******'||substr(a.aqpb215nro,13,4),a.aqpb215nro) aqpb215nro,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpb215pce, a.aqpb215nce, a.aqpb215fal, a.aqpb215hal, a.aqpb215ide, a.aqpb215gui, a.aqpb215an1,
a.aqpb215an2, a.aqpb215ac1, a.aqpb215ac2, a.aqpb215top, a.aqpb215ope, a.aqpb215cta, a.aqpb215mda, a.aqpb215suc,
a.aqpb215mod, a.aqpb215pgc, a.aqpb215est, a.aqpb215mai, a.aqpb215aty, a.aqpb215pap, a.aqpb215sbo, a.aqpb215lna,
a.aqpb215fna, a.aqpb215pai, a.aqpb215tdo, a.aqpb215ndo
 from AQPB215 a left outer join Z0E478 b
  on a.aqpb215nro=b.Z0E478NRO;

