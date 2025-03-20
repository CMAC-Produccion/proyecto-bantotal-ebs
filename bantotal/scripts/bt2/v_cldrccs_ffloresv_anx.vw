create or replace force view v_cldrccs_ffloresv_anx as
select
c_codsbs,
n_diaatr,
c_tipreg,
c_tipdet,
c_codemp,
c_cuenta,
c_calvig
from CLDRCCS
 /* GOLDENGATE_DDL_REPLICATION */;

