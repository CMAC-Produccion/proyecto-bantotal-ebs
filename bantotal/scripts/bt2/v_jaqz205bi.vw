create or replace force view v_jaqz205bi as
select
decode(a.jaqz205nutar,b.Z0E478NRO,substr(a.jaqz205nutar,0,6)||'******'||substr(a.jaqz205nutar,13,4),a.jaqz205nutar) jaqz205nutar,
z0e478thd,
a.jaqz205habil, a.jaqz205usafi, a.jaqz205feafi, a.jaqz205hoafi, a.jaqz205usdes, a.jaqz205fedes, a.jaqz205hodes, a.jaqz205titar, a.jaqz205feult,
a.jaqz205hoult, a.jaqz205email, a.jaqz205celul, a.jaqz205estok, a.jaqz205seseg, a.jaqz205esurl, a.jaqz205urlpu, a.jaqz205tipafi, a.jaqz205imei,
a.jaqz205aux1, a.jaqz205aux2, a.jaqz205aux3, a.jaqz205aux4, a.jaqz205aux5
 from JAQZ205 a left outer join Z0E478 b
  on a.jaqz205nutar=b.Z0E478NRO;

