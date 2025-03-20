create or replace force view v_aqpb101 as
select
a.aqpb101corr,
a.aqpb101fecdi,
decode(a.aqpb101numtar,trim(b.Z0E478NRO),substr(a.aqpb101numtar,0,6)||'******'||substr(a.aqpb101numtar,13,4),a.aqpb101numtar) aqpb101numtar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.aqpb101agen,
a.aqpb101codpa,
a.aqpb101tipdoc,
a.aqpb101nrodoc,
a.aqpb101op1res,
a.aqpb101op2asi,
a.aqpb101op3act,
a.aqpb101actasi,
a.aqpb101ctainc,
a.aqpb101codusu,
a.aqpb101feuatm,
a.aqpb101feucor,
a.aqpb101feucam,
a.aqpb101feukas,
a.aqpb101feuven
from AQPB101 a left outer join Z0E478 b
  on a.aqpb101numtar=trim(b.Z0E478NRO);

