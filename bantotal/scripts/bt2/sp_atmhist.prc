create or replace procedure SP_ATMHIST(P_FECHA IN DATE)
 IS
begin
--Atm Historico
DELETE ATMHIST;
COMMIT;

INSERT INTO ATMHIST
select b.hsubop, c.z0e475dsc ATM, count(a.pgcod) OPERACIONES
  from fsh015 a, fsh016 b, z0e475 c
 where a.hcmod = 66
   and a.pgcod = b.pgcod
   and a.hsucor = b.hsucor
   and a.hcmod = b.hcmod
   and a.htran = b.htran
   and a.hnrel = b.hnrel
   and a.hfcon = b.hfcon
   and b.hmodul = 23
   and c.z0e475caj = b.hsubop
   and a.hfcon = P_FECHA /*TO_DATE('11072013','DDMMYYYY')*/
   and a.husing not in ('JPINTO')
 group by b.hsubop, c.z0e475dsc;
COMMIT;
END;
/

