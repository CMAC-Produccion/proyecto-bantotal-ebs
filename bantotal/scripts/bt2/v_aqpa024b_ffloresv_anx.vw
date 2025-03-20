create or replace force view v_aqpa024b_ffloresv_anx as
select
aqpa024binst,
aqpa024bcsbs,
aqpa024bcemp,
aqpa024bcuen,
aqpa024bfpre,
aqpa024bfech,
aqpa024bhora,
aqpa024butil,
aqpa024btipo,
aqpa024baux1,
aqpa024baux2
from AQPA024B
 /* GOLDENGATE_DDL_REPLICATION */;

