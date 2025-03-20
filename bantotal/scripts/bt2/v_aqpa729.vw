create or replace force view v_aqpa729 as
select
a.aqpa729id,
a.aqpa729tipope,
--aqpa729numtar,
/*decode(a.aqpa729numtar,b.Z0E478NRO,*/substr(a.aqpa729numtar,0,6)||'******'||substr(a.aqpa729numtar,13,4)/*,a.aqpa729numtar) */aqpa729numtar,
--decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpa729fecreg,
a.aqpa729horreg,
a.aqpa729nomtar,
a.aqpa729reqid,
a.aqpa729inscod,
a.aqpa729vauide,
a.aqpa729wallid,
a.aqpa729tokreqid,
a.aqpa729tokrefid,
a.aqpa729panrefid,
a.aqpa729procid,
a.aqpa729uselan,
a.aqpa729source,
a.aqpa729toktyp,
a.aqpa729tokreqnam,
a.aqpa729recdec,
a.aqpa729recdeccod,
a.aqpa729returncod,
a.aqpa729errdes,
a.aqpa729errint,
a.aqpa729train,
a.aqpa729traout,
a.aqpa729numaux2,
a.aqpa729numaux1,
a.aqpa729varaux2,
a.aqpa729varaux1

from AQPA729 a /*left outer join Z0E478 b
  on a.aqpa729numtar=b.Z0E478NRO*/
;

