create or replace force view v_fsd002_ffloresv_anx as
select
pfpais,
pftdoc,
pfape1,
pfape2,
pfnom1,
pfnom2,
pfebco,
pffibc,
pffnac,
pfpnac,
pflnac,
pfcleg,
pffleg,
pffal,
pfffal,
pfcapl,
pffant,
pfepat,
pffpep
from FSD002
 /* GOLDENGATE_DDL_REPLICATION */;

