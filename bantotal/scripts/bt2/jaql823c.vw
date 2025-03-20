create or replace force view jaql823c as
select distinct a.pfpais as ncodpai,a.pftdoc as ntipdoc,a.pfndoc as cnumdoc,
       a.pfape1 as capepat,a.pfape2 as capemat,a.pfnom1 as cprinom,a.pfnom2 as csegnom,
       a.pffnac as dfecnac,a.pfeciv as cestciv,a.pfcant as ccodsex
  from fsd002 a,z0e478 b
where  b.z0e478thp = a.pfpais
   and b.z0e478tht = a.pftdoc
   and b.z0e478thd = a.pfndoc;

