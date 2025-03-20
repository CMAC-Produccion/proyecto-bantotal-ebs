create or replace force view v_jaqz235 as
select
decode(a.jaqz235tarje,b.Z0E478NRO,substr(a.jaqz235tarje,0,6)||'******'||substr(a.jaqz235tarje,13,4),a.jaqz235tarje) jaqz235tarje,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqz235corre, a.jaqz235fecha, a.jaqz235hora, a.jaqz235tipoo, a.jaqz235ctaor, a.jaqz235ctade, a.jaqz235coent, a.jaqz235cotsv, a.jaqz235contr,
a.jaqz235impor, a.jaqz235trdni, a.jaqz235trtdo, a.jaqz235trnom, a.jaqz235auxv1, a.jaqz235auxv2, a.jaqz235auxv3, a.jaqz235auxn1, a.jaqz235auxn2,
a.jaqz235auxn3, a.jaqz235direc, a.jaqz235telef, a.jaqz235celul, a.jaqz235conce, a.jaqz235tipot, a.jaqz235tipob, a.jaqz235desc
 from JAQZ235 a left outer join Z0E478 b
  on a.jaqz235tarje=b.Z0E478NRO;

