create or replace procedure SP_CHEQUEDIA(P_FECHA IN DATE)
 IS
begin 
DELETE CHEQUEDIA;
COMMIT;

INSERT INTO CHEQUEDIA 
select c.scnom, q.chcheq, b.banom, q.sccta, q.scmda, q.scsdo, q.scfcon
  from (select scmda,
               scsuc,
               sccta,
               scoper,
               scsbop,
               chcheq,
               chbco,
               chsbco,
               scsdo,
               scfcon,
               scfvto,
               scstat,
               i2mod,
               i2rub,
               i2cta,
               i2oper,
               i2sbop,
               e111mo,
               e111tr
          from (select pgcod,
                       scmda,
                       scsuc,
                       sccta,
                       scmod,
                       scpap,
                       sctope,
                       scoper,
                       scsbop,
                       chcheq,
                       chbco,
                       chsbco,
                       scsdo,
                       scfcon,
                       scfvto,
                       scstat,
                       e111mo,
                       e111tr
                  from fsd011 a
                  left join fse111 b
                    on pgcod = chcod
                   and scsuc = chsuc
                   and scmda = chmda
                   and scpap = chpap
                   and sccta = chcta
                   and scoper = choper
                   and scsbop = chsbop
                   and sctope = chtope
                 where pgcod = 1
                   and scmod = 19
                   and scfcon = P_FECHA /*TO_DATE('18072013','DDMMYYYY')*/) x
          left join (select * from fsr111 c where inscod = 3)
            on x.pgcod = i1cod
           and x.scmod = i1mod
           and x.scsuc = i1suc
           and x.scmda = i1mda
           and x.scpap = i1pap
           and x.sccta = i1cta
           and x.scoper = i1oper
           and x.scsbop = i1sbop
           and x.sctope = i1tope) q,
       fst002 b,
       fst001 c
 where q.chbco = b.banco
   and q.scsuc = c.sucurs;

COMMIT;
END;
/

