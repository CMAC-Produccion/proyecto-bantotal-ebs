create or replace force view v_repext as
select
jaqy254pgctr, jaqy254suctr, jaqy254modtr, jaqy254codtr, jaqy254reltr, jaqy254fetra, jaqy254feneg, jaqy254feini, jaqy254fefin, jaqy254comsg, trac,
substr(a.tarjeta,0,6)||'******'||substr(a.tarjeta,13,4) tarjeta,
fecha, hora, operacion, moneda_trx, monto_trx, lugar, estado, motivo_rechazo, cta, oper, toper, modul, mda, pepais, petdoc, pendoc, penom,
imp1, oper_h16
from REPEXT a;

