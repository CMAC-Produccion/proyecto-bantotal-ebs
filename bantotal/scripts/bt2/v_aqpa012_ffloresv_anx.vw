create or replace force view v_aqpa012_ffloresv_anx as
select
aqpa012corre,
aqpa012integr,
aqpa012fchsis,
aqpa012tipers,
aqpa012mod,
aqpa012reg,
aqpa012loc,
aqpa012ticli,
aqpa012tdoc,
aqpa012aux2,
aqpa012aux3,
aqpa012aux4,
aqpa012aux5,
aqpa012sec,
aqpa012conec
from AQPA012
 /* GOLDENGATE_DDL_REPLICATION */;

