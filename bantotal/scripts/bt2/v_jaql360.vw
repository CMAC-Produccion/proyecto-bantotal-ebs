create or replace force view v_jaql360 as
select
a.codproductocobro, a.numcertificadocobro, a.numcuotacobro, a.idtitularcta, a.tipoid, a.tipocta, a.numcta,
decode(a.numtarjeta,trim(b.Z0E478NRO),substr(a.numtarjeta,0,6)||'******'||substr(a.numtarjeta,13,4),a.numtarjeta) numtarjeta99,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.montoprimacuota, a.fecemisioncuota
from jaql360 a left outer join Z0E478 b
  on a.numtarjeta=trim(b.Z0E478NRO);

