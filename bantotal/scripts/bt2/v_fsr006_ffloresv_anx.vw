create or replace force view v_fsr006_ffloresv_anx as
select
docod,
pgcod,
ctnro,
doord,
dotlex,
dofax
from FSR006
 /* GOLDENGATE_DDL_REPLICATION */;

