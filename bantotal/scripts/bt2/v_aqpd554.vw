create or replace force view v_aqpd554 as
select unit aqpd554unit,
trace aqpd554trace,
pan aqpd554pan,
date_ext aqpd554date
from atmstatus_ext@cajero;

