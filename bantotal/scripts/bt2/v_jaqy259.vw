create or replace force view v_jaqy259 as
select
decode(a.jaqy259nutar,b.Z0E478NRO,substr(a.jaqy259nutar,0,6)||'******'||substr(a.jaqy259nutar,13,4),a.jaqy259nutar) jaqy259nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqy259habil, a.jaqy259usafi, a.jaqy259feafi, a.jaqy259hoafi, a.jaqy259usdes, a.jaqy259fedes, a.jaqy259hodes, a.jaqy259titar
 from JAQY259 a left outer join Z0E478 b
  on a.jaqy259nutar=b.Z0E478NRO;

