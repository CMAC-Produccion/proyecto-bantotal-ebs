create or replace force view v_z0e482 as
select substr(z0e481nro,0,6)||'******'||substr(z0e481nro,13,4) z0e481nro, z0e482suc, z0e482cta, z0e482sct, z0e482mod, z0e482mon,
z0e482pap, z0e482top, z0e482ope, z0e482pgc, z0e482est, z0e482tus, z0e460cod, z0e480cod, z0e482fmd, z0e482umd, z0e482fau, z0e482uau,
z0e482tnv, z0e482ctb
from z0e482;

