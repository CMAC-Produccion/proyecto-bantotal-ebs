create or replace force view v_jaql099 as
select
a.jaql99fepr, a.codproductocobro99, a.numcertificadocobro99, a.numcuotacobro99, a.idtitularcta99, a.tipoid99, a.tipocta99, a.numcta99,
decode(a.numtarjeta99,trim(b.Z0E478NRO),substr(a.numtarjeta99,0,6)||'******'||substr(a.numtarjeta99,13,4),a.numtarjeta99) numtarjeta99,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.montoprimacuota99, a.fecemisioncuota99, a.fecpagocuota99, a.docdeposito99, a.fecdeposito99, a.coderror99, a.descerror99, a.jaql99au01,
a.jaql99itmo, a.jaql99ittr, a.jaql99itre
from  JAQL099 a left outer join Z0E478 b
  on a.numtarjeta99=trim(b.Z0E478NRO);

