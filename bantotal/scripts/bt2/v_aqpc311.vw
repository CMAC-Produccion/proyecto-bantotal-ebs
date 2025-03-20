create or replace force view v_aqpc311 as
select
a.aqpc311id, a.aqpc311fecreg, a.aqpc311horreg,
substr(a.aqpc311numtar,0,6)||'******'||substr(a.aqpc311numtar,13,4) aqpc311numtar,
a.aqpc311pepais, a.aqpc311petdoc, a.aqpc311pendoc, a.aqpc311tipevt,
a.aqpc311descri, a.aqpc311ddeviceid, a.aqpc311dmodelo, a.aqpc311dso, a.aqpc311dlat, a.aqpc311dlong, a.aqpc311valact, a.aqpc311valnue,
a.aqpc311usobio, a.aqpc311respro, a.aqpc311detres, a.aqpc311canal, a.aqpc311usuage, a.aqpc311codage, a.aqpc311auxn1, a.aqpc311auxn2,
a.aqpc311auxn3, a.aqpc311auxv1, a.aqpc311auxv2, a.aqpc311auxv3, a.AQPC311FECREA
from AQPC311 a;

