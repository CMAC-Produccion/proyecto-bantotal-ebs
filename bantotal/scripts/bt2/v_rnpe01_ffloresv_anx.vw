create or replace force view v_rnpe01_ffloresv_anx as
select
rnpe01emp,
rnpe01fech,
rnpe01inf,
rnpe01cod,
rnpe01desc,
rnpe01num1,
rnpe01num2,
rnpe01num3,
rnpe01fec1,
rnpe01fec2,
rnpe01fec3,
rnpe01car1,
rnpe01car2,
rnpe01car3
from RNPE01
 /* GOLDENGATE_DDL_REPLICATION */;

