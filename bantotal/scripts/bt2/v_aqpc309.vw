create or replace force view v_aqpc309 as
select
a.aqpc309id, a.aqpc309fecreg, a.aqpc309horreg, a.aqpc309scmod, a.aqpc309sctope, a.aqpc309scsuc, a.aqpc309scmda, a.aqpc309scpap, a.aqpc309sccta,
a.aqpc309scoper, a.aqpc309scsbop, a.aqpc309itsuc, a.aqpc309itmod, a.aqpc309ittran, a.aqpc309itnrel, a.aqpc309fecpro, a.aqpc309pgcod,
a.aqpc309hcmod, a.aqpc309hsucor, a.aqpc309htran, a.aqpc309hnrel, a.aqpc309hfcon, a.aqpc309moncom, a.aqpc309pordev, a.aqpc309monto,
a.aqpc309codcam,
substr(a.aqpc309numtar,0,6)||'******'||substr(a.aqpc309numtar,13,4) aqpc309numtar,
a.aqpc309pepais, a.aqpc309petdoc, a.aqpc309pendoc, a.aqpc309codcon, a.aqpc309msgcon, a.aqpc309usuario,
a.aqpc309auxv1, a.aqpc309auxv2, a.aqpc309auxv3, a.aqpc309auxn1, a.aqpc309auxn2, a.aqpc309auxn3
from AQPC309 a;

