create or replace force view v_fsd002_misti as
select
a.pfpais,
a.pftdoc,
a.pfndoc,
a.pfape1,
a.pfape2,
a.pfnom1,
a.pfnom2,
a.pfebco,
a.pffibc,
--a.pfcant,
a.pffnac,
--a.pfeciv,
a.pfpnac,
a.pflnac,
a.pfcleg,
a.pffleg,
a.pffal,
a.pfffal,
a.pfcapl,
a.pffant,
a.pfepat,
a.pffpep
from FSD002 a
;

