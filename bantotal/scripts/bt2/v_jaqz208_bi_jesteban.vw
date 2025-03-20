create or replace force view v_jaqz208_bi_jesteban as
select
a.jaqz208seint, a.jaqz208fetra, a.jaqz208hotra, a.jaqz208cores, a.jaqz208feits, a.jaqz208hoits,
decode(b.z0e478thd,null,null,b.Z0E478THP) Z0E478THP,
decode(b.z0e478thd,null,null,b.Z0E478THT) Z0E478THT,
decode(b.z0e478thd,null,null,b.z0e478thd) z0e478thd,
a.jaqz208cotra, a.jaqz208fefts, a.jaqz208hofts, a.jaqz208sefec, a.jaqz208sehor
from JAQZ208 a left outer join Z0E478 b
  on a.jaqz208nutar=b.Z0E478NRO;

