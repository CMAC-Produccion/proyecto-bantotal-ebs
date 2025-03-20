create or replace force view v_aqpb296_bi as
select
a.aqpb296feca,
a.aqpb296pais,
a.aqpb296tdoc,
a.aqpb296ndoc,
a.aqpb296tipol,
a.aqpb296est,
a.aqpb296desc,
a.aqpb296mto1,
--aqpb296mto2,
--aqpb296mto3,
a.aqpb296usu1,
--aqpb296usu2,
a.aqpb296usu3,
a.aqpb296fech1,
--aqpb296fech2,
--aqpb296fech3,
a.aqpb296var1,
a.aqpb296var2,
a.aqpb296var3,
a.aqpb296hora,
a.aqpb296age,
a.aqpb296zon,
a.aqpb296reg
from BANTPROD.AQPB296 a
;

