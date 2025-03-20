create or replace force view v_jaqy260 as
select
decode(a.jaqy259nutar,b.Z0E478NRO,substr(a.jaqy259nutar,0,6)||'******'||substr(a.jaqy259nutar,13,4),a.jaqy259nutar) jaqy259nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqy260corre, a.jaqy260habil, a.jaqy260usafi, a.jaqy260feafi, a.jaqy260hoafi, a.jaqy260usdes, a.jaqy260fedes, a.jaqy260hodes, a.jaqy260titar
 from JAQY260 a left outer join Z0E478 b
  on a.jaqy259nutar=b.Z0E478NRO;

