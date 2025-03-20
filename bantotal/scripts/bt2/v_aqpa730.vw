create or replace force view v_aqpa730 as
select
a.aqpa730id,
a.aqpa730tokrefid,
-- aqpa730numtar,
substr(a.aqpa730numtar,0,6)||'******'||substr(a.aqpa730numtar,13,4) aqpa730numtar,
--decode(a.aqpa730numtar,b.Z0E478NRO,substr(a.aqpa730numtar,0,6)||'******'||substr(a.aqpa730numtar,13,4),a.aqpa730numtar) aqpa730numtar,
a.aqpa730evento,
a.aqpa730action,
a.aqpa730actionbt,
a.aqpa730fecreg,
a.aqpa730horreg,
a.aqpa730fecact,
a.aqpa730horact,
a.aqpa730ulteve,
a.aqpa730paidoc,
a.aqpa730tipdoc,
a.aqpa730numdoc,
--decode(a.aqpa730numdoc,null,null,'****'||substr(trim(a.aqpa730numdoc),5,length(trim(a.aqpa730numdoc))-4)) aqpa730numdoc,
--a.aqpa730tarori,
substr(a.aqpa730tarori,0,6)||'******'||substr(a.aqpa730tarori,13,4) aqpa730tarori,
a.aqpa730tokreqnam,
a.aqpa730toktyp,
a.aqpa730tokreqid,
a.aqpa730tokexp,
a.aqpa730token,
a.aqpa730horbt,
a.aqpa730fecbt,
a.aqpa730horcar,
a.aqpa730feccar,
a.aqpa730chncar,
a.aqpa730eventobt

from AQPA730 a /*left outer join Z0E478 b
  on a.aqpa730numtar=b.Z0E478NRO*/
;

