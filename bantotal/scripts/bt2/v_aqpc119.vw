create or replace force view v_aqpc119 as
select substr(aqpc119tar,0,6)||'******'||substr(aqpc119tar,13,4) aqpc119tar,
aqpc119pce,
aqpc119nce,
aqpc119fal,
aqpc119hal,
aqpc119est,
aqpc119idr,
aqpc119pai,
aqpc119tdo,
aqpc119ndo,
aqpc119pgc,
aqpc119mod,
aqpc119suc,
aqpc119mda,
aqpc119pap,
aqpc119cta,
aqpc119ope,
aqpc119sbo,
aqpc119top
from AQPC119;

