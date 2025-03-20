create or replace force view v_fst001_ffloresv_anx as
select
pgcod,
sucurs,
scnom,
scnomr,
sccall,
scnro,
scciud,
scdept
,calcod
/*sclat,
sclng*/
from FST001
 /* GOLDENGATE_DDL_REPLICATION */;

