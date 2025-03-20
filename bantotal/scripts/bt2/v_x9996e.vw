create or replace force view v_x9996e as
select  a.x9996acnco, a.x9996dfesv, a.x9996dhosv, a.x9996drqsv, a.x9996edato, a.x9996etdat,
case
    when a.x9996evalc like '4261%' then
      substr(trim(a.x9996evalc),0,6)||'******'||substr(trim(a.x9996evalc),13,4)
  else a.x9996evalc
    end x9996evalc,
a.x9996evall
from  X9996E a;

