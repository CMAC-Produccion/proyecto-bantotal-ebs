create or replace procedure SP_CHEQUEVAL(P_FECHA IN DATE)
 IS
begin
--Cheques valorizados
DELETE CHEQUEVAL;
COMMIT;

INSERT INTO CHEQUEVAL
select t.hsucor,
       t.hcta,
       t.hoper,
       t.hcmod,
       s.chcheq,
       s.chbco,
       t.hfcon,
       t.hcimp1,
       t.hmda
  from fse111 s
 inner join fsh016 t
    on s.CHCOD = t.pgcod
   and s.CHSUC = t.hsucor
   and s.chmod = t.hmodul
   and s.chmda = t.hmda
   and s.chpap = t.hpap
   and s.chcta = t.hcta
   and s.choper = t.hoper
   and s.chsbop = t.hsubop
   and s.chtope = t.htoper
 where s.chfcon = P_FECHA/*TO_DATE('18072013','DDMMYYYY')*/
 --between to_date('01/07/2013', 'dd/mm/yyyy') and to_date('10/07/2013', 'dd/mm/yyyy')
 order by 2, 3, 5;
COMMIT;
END;
/

