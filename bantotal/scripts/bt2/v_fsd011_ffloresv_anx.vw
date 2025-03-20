create or replace force view v_fsd011_ffloresv_anx as
select
pgcod,
scsuc,
scsbop,
scmod,
scmda,
scpap,
sccta,
scoper,
sctope,
scrub,
scfcon,
scfval,
scfvto,
scfulm,
scpzo,
scsdoh,
scsegm,
scfunc,
scstat,
sccc,
sctit,
sccap,
scplzo,
scgru
from FSD011
 /* GOLDENGATE_DDL_REPLICATION */;

