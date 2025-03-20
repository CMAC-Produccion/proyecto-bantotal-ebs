create or replace force view v_aqpa730_precon as
select
a.aqpa730id,
a.aqpa730tokrefid,
--a.aqpa730numtar,
substr(a.aqpa730numtar,0,6)||'******'||substr(a.aqpa730numtar,13,4) aqpa730numtar,
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
a.aqpa730tarori,
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
from AQPA730 a
;

