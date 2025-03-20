create or replace force view v_jaqz203 as
select
substr(a.jaqz203tar,0,6)||'******'||substr(a.jaqz203tar,13,4) jaqz203tar,
jaqz203feci,
jaqz203hori,
jaqz203toke,
jaqz203fech
from JAQZ203 a;

