create or replace force view v_aqpa352_ffloresv_anx as
select
aqpa352corr,
aqpa352fec,
aqpa352hora,
aqpa352user,
aqpa352pais,
aqpa352tdoc,
aqpa352tcamb,
aqpa352inst,
aqpa352feval,
aqpa352fical,
aqpa352ori,
aqpa352ncuo,
aqpa352est,
aqpa352naux1,
aqpa352naux2,
aqpa352naux3,
aqpa352naux4,
aqpa352naux5,
aqpa352vaux1,
aqpa352vaux2,
aqpa352vaux3,
aqpa352vaux4,
aqpa352vaux5,
aqpa352daux1,
aqpa352daux2,
aqpa352daux3
from AQPA352
 /* GOLDENGATE_DDL_REPLICATION */;

