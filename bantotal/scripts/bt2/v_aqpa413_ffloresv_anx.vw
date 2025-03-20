create or replace force view v_aqpa413_ffloresv_anx as
select
aqpa413inst,
aqpa413moda,
aqpa413tipo,
aqpa413user,
aqpa413csbs,
aqpa413frcc,
aqpa413fpro,
aqpa413rubro,
aqpa413enti,
aqpa413cent,
aqpa413util,
aqpa413nout,
aqpa413corr,
aqpa413rub72
from AQPA413
 /* GOLDENGATE_DDL_REPLICATION */;

