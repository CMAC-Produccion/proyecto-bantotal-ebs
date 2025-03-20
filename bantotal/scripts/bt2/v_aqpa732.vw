create or replace force view v_aqpa732 as
select
aqpa732id,
aqpa732fecreg,
aqpa732horreg,
aqpa732tokrefid,
--aqpa732numtar,
decode(a.aqpa732numtar,b.Z0E478NRO,substr(a.aqpa732numtar,0,6)||'******'||substr(a.aqpa732numtar,13,4),a.aqpa732numtar) aqpa732numtar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
--aqpa732numtarnew,
decode(a.aqpa732numtarnew,b.Z0E478NRO,substr(a.aqpa732numtarnew,0,6)||'******'||substr(a.aqpa732numtarnew,13,4),a.aqpa732numtarnew) aqpa732numtarnew,
aqpa732metodo,
aqpa732accion,
aqpa732trareq,
aqpa732trares,
aqpa732coderr,
aqpa732msgerr,
aqpa732timexe,
aqpa732idproceso,
aqpa732reason

from AQPA732 a left outer join Z0E478 b
  on a.aqpa732numtar=b.Z0E478NRO
;

