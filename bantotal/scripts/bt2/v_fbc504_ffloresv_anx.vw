create or replace force view v_fbc504_ffloresv_anx as
select
bcinfor,
bcemp,
bccolu,
bcunid,
bcreng,
bcfinf,
bcform,
bcsdo5041,
bcsdo5042,
bcpais,
bctdoc
from FBC504
 /* GOLDENGATE_DDL_REPLICATION */;

