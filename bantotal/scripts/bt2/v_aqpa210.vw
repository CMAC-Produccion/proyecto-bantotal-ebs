create or replace force view v_aqpa210 as
select
a.aqpa210pjpais,
a.aqpa210pjtdoc,
a.aqpa210pjndoc,
a.aqpa210ctnro,
a.aqpa210sucurs,
a.aqpa210usu
 from AQPA210 a;

