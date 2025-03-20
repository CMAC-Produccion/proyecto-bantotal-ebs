create or replace force view v_wsaqp01 as
select
a.wsaqp01fec, a.wsaqp01hor, a.wsaqp01ori, a.wsaqp01usr,
decode(a.wsaqp01tar,b.Z0E478NRO,substr(a.wsaqp01tar,0,6)||'******'||substr(a.wsaqp01tar,13,4),a.wsaqp01tar) wsaqp01tar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.wsaqp01est, a.wsaqp01ide, a.wsaqp01ok
 from  WSAQP01 a left outer join Z0E478 b
  on a.wsaqp01tar=b.Z0E478NRO;

