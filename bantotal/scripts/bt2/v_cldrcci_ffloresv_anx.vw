create or replace force view v_cldrcci_ffloresv_anx as
select
c_tipreg,
c_codsbs,
c_tipdet,
d_fecpre,
c_tdoctr,
c_tdocid,
c_person,
c_tipemp,
n_canent,
n_calif0,
n_calif1,
n_calif2,
n_calif3,
n_calif4,
c_segnom
from CLDRCCI
 /* GOLDENGATE_DDL_REPLICATION */;

