create or replace force view v_aqpb117 as
select
a.aqpb117fecha,
a.aqpb117hor,
-- aqpb117nutar,--
substr(a.aqpb117nutar,0,6)||'******'||substr(a.aqpb117nutar,13,4) aqpb117nutar,
A.aqpb117thd, --
--decode(a.aqpb117thd,null,null,'****'||substr(trim(a.aqpb117thd),5,length(trim(a.aqpb117thd))-4)) aqpb117thd,
a.aqpb117pto,
a.aqpb117ppc,
a.aqpb117pbcc,
a.aqpb117text,
a.aqpb117pfrom,
a.aqpb117asun,
a.aqpb117coderr,
a.aqpb117msjerr,
a.aqpb117canal
from AQPB117 a
;

