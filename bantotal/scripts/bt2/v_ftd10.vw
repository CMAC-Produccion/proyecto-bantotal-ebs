create or replace force view v_ftd10 as
select
decode(a.td10tar,b.Z0E478NRO,substr(a.td10tar,0,6)||'******'||substr(a.td10tar,13,4),substr(a.td10tar,0,6)||'******'||substr(a.td10tar,13,4)) td10tar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.td10suc, a.td10tiptar, a.td10fchvto, a.td10estenv, a.td10est, a.td10fchsol, a.td10fchrec, a.td10fchent, a.td10lote, a.td10ususol,
a.td10usucon, a.td10usuent, a.td10car, a.td10sucdst, a.td10canfch, a.td10canusu, a.td10canmot, a.td10cancod
 from FTD10 a left outer join Z0E478 b
  on a.td10tar=b.Z0E478NRO;

