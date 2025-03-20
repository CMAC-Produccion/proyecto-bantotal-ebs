create or replace force view v_m01seed as
select
substr(a.numtar,0,6)||'******'||substr(a.numtar,13,4) numtar,
idtar
from M01SEED a;

