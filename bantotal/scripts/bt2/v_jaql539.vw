create or replace force view v_jaql539 as
select  a.jaql539cotra,
a.jaql539nucam,
a.jaql539timsj,
case when jaql539nucam=2 then substr(a.jaql539valtr,0,8)||'******'||substr(a.jaql539valtr,15,4)
     when jaql539nucam=35 then substr(a.jaql539valtr,0,8)||'******'||substr(a.jaql539valtr,15,4)||substr(a.jaql539valtr,17,4)
     else   a.jaql539valtr end jaql539valtr
from  JAQL539 a;

