create or replace force view v_aqpa104 as
Select a.sucurs,a.scnom,b.ffecha, b.fhabil
from fst001 a,
      fst028 b
where a.pgcod = 1
  and a.sucurs < 300
  and a.calcod = b.calcod
  and b.ffecha between trunc(sysdate) and trunc(sysdate+365)
  and b.fhabil='N';

