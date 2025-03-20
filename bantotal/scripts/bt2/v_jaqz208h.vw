create or replace force view v_jaqz208h as
select
a.jaqz208seint, a.jaqz208fetra, a.jaqz208hotra, a.jaqz208cores, a.jaqz208feits, a.jaqz208hoits,
decode(a.jaqz208nutar,b.Z0E478NRO,substr(a.jaqz208nutar,0,6)||'******'||substr(a.jaqz208nutar,13,4),a.jaqz208nutar) jaqz208nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqz208cotra, a.jaqz208fefts, a.jaqz208hofts, a.jaqz208sefec, a.jaqz208sehor, a.jaqz208secre,
a.jaqz208secrs,
decode(trim(a.jaqz208nutar),'',a.jaqz208texto,FN_CC_REPLACE_TRAMA(a.jaqz208texto)) jaqz208texto,
a.JAQZ208TRAMA
from JAQZ208 a left outer join Z0E478 b
  on a.jaqz208nutar=b.Z0E478NRO;

