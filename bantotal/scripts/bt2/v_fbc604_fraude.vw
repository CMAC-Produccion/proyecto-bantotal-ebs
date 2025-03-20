create or replace force view v_fbc604_fraude as
select
a.BC604Mod,
a.BC604suc,
a.BC604Trn,
a.BC604NREL,
a.BC604fch,
a.BC604OEfe
from FBC604 a;

