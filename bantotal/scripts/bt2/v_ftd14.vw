create or replace force view v_ftd14 as
select
decode(a.td14tar,b.Z0E478NRO,substr(a.td14tar,0,6)||'******'||substr(a.td14tar,13,4),a.td14tar) td14tar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.td14fchneg,
a.td14codlim,
a.td14mda,
a.td14imp
 from FTD14 a left outer join Z0E478 b
  on a.td14tar=b.Z0E478NRO;

