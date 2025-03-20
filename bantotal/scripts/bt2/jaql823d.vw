create or replace force view jaql823d as
select distinct a.pjpais as ncodpai,a.pjtdoc as ntipdoc,a.pjndoc as cnumdoc,
       a.pjrazs as crazsoc,a.Pjfcon as dfeccon
  from fsd003 a,z0e478 b
where b.z0e478thp = a.pjpais
   and b.z0e478tht = a.pjtdoc
   and b.z0e478thd = a.pjndoc;

