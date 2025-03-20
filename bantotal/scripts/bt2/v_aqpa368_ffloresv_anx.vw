create or replace force view v_aqpa368_ffloresv_anx as
select
aqpa368corr,
aqpa368fec,
aqpa368hora,
aqpa368user,
aqpa368inst,
aqpa368pais,
aqpa368tdoc,
aqpa368tdias,
aqpa368ncuot,
aqpa368promt,
aqpa368mormax,
aqpa368naux1,
aqpa368naux2,
aqpa368naux3,
aqpa368naux4,
aqpa368naux5,
aqpa368vaux1,
aqpa368vaux2,
aqpa368vaux3,
aqpa368vaux4,
aqpa368vaux5,
aqpa368daux1,
aqpa368daux2,
aqpa368daux3
from AQPA368
 /* GOLDENGATE_DDL_REPLICATION */;

