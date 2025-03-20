create or replace force view v_jaql629 as
select
decode(a.jaql629nutar,b.Z0E478NRO,substr(a.jaql629nutar,0,6)||'******'||substr(a.jaql629nutar,13,4),a.jaql629nutar) jaql629nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql629habil, a.jaql629can00, a.jaql629can01, a.jaql629can02, a.jaql629can03, a.jaql629can04, a.jaql629can05, a.jaql629can06,
a.jaql629can07, a.jaql629can08, a.jaql629can09, a.jaql629can10, a.jaql629can11, a.jaql629can12, a.jaql629obser, a.jaql629uscre,
a.jaql629fecre, a.jaql629hocre, a.jaqy629usmod, a.jaql629femod, a.jaql629homod, a.jaql629auxc1, a.jaql629auxc2, a.jaql629auxc3
 from  JAQL629 a left outer join Z0E478 b
  on a.jaql629nutar = b.Z0E478NRO;

