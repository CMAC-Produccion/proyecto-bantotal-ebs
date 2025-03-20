create or replace force view v_fau011_ffloresv_anx as
select
auxpgcod,
auxscsuc,
auxscrub,
auxscmda,
auxscpap,
auxsccta,
auxscoper,
auxscsbop,
auxsctope,
auxscmod,
auxscfcon,
auxscfval,
auxscfvto,
auxscfulm,
auxscpzo,
auxscsdoh,
auxscsegm,
auxscfunc,
auxscstat,
auxsccc,
auxsctit,
auxsccap,
auxscplzo,
auxscgru
from FAU011
 /* GOLDENGATE_DDL_REPLICATION */;

