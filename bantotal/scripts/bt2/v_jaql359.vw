create or replace force view v_jaql359 as
select a.jaql359fearc, a.jaql359fetxr, a.jaql359hotxr, a.jaql359corre, a.jaql6seint, a.jaql359nutra, a.jaql359comsg, a.jaql359cotr1,
decode(a.jaql359nutar,b.Z0E478NRO,substr(a.jaql359nutar,0,6)||'******'||substr(a.jaql359nutar,13,4),a.jaql359nutar) jaql359nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql359cotr2, a.jaql359cotra, a.jaql359ticob, a.jaql359nucta, a.jaql359comon, a.jaql359mtotx, a.jaql359coerr, a.jaql359xtrno,
a.jaql359coesv, a.jaql359depro, a.jaql359nroco, a.jaql359cocco
 from JAQL359 a left outer join Z0E478 b
  on a.jaql359nutar=b.Z0E478NRO;

