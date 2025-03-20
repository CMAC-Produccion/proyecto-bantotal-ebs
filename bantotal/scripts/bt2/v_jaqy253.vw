create or replace force view v_jaqy253 as
select
/*decode(a.jaqy252nutar,b.Z0E478NRO,*/substr(a.jaqy252nutar,0,6)||'******'||substr(a.jaqy252nutar,13,4)/*,a.jaqy252nutar)*/ jaqy252nutar,
--decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqy253feint, a.jaqy253hoint, a.jaqy253nuint, a.jaqy253nucan, a.jaqy253usblo
 from  jaqy253 a /*left outer join Z0E478 b
  on a.jaqy252nutar = b.Z0E478NRO*/
;

