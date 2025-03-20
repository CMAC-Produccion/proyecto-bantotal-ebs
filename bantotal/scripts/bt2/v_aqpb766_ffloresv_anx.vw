create or replace force view v_aqpb766_ffloresv_anx as
select
aqpb766nsol,
aqpb766tdoc,
aqpb766scor,
aqpb766tabl,
aqpb766usrp,
aqpb766fprc,
aqpb766hora
from AQPB766
 /* GOLDENGATE_DDL_REPLICATION */;

