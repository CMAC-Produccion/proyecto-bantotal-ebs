create or replace force view v_jaql005 as
select
a.jaql5fetra, a.jaql5hotra, a.jaql5seint, a.jaql5coing, a.jaql5cores, a.jaql5feits, a.jaql5hoits, a.jaql5fefts, a.jaql5hofts, a.jaql5texti,
decode(a.jaql5nutar,b.Z0E478NRO,substr(a.jaql5nutar,0,6)||'******'||substr(a.jaql5nutar,13,4),a.jaql5nutar) jaql5nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql5comen, a.jaql5seiso, a.jaql5cotra, a.jaql5fehot, a.jaql5feneg, a.jaql5honeg, a.jaql5inadq, a.jaql5inemi, a.jaql3cored, a.jaql9nuele,
a.jaql5cisot, a.jaql5cisoc, a.jaql5secan, a.jaql5seope, a.jaql5sevar, a.jaql5sefec, a.jaql5sehor, a.jaql5secre, a.jaql5secrs, a.jaql5gineg,
a.jaql5coaut, a.jaql5texto, a.jaql5tiout, a.jaql5tidtr, a.jaql5coire, a.jaql5aux1, a.jaql5aux2, a.jaql5aux3, a.jaql5aux4, a.jaql5aux5,
a.jaql5aux6, a.jaql5aux7, a.jaql5aux8, a.jaql5aux9, a.jaql5aux10, a.jaql5aux11, a.jaql5aux12, a.jaql5aux13, a.jaql5aux14, a.jaql5aux15,
a.jaql5aux16, a.jaql5aux17, a.jaql5aux18
from JAQL005 a left outer join Z0E478 b
  on a.jaql5nutar=b.Z0E478NRO;

