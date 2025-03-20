create or replace procedure SP_DESEMB(P_FECHA IN DATE)
 IS
begin
--Atm Historico
DELETE DESEMB;
COMMIT;

INSERT INTO DESEMB
select a.aofval,
       a.aosuc,
       c.scnom,
       sum(decode(a.aomda, 0, a.aoimp, 0)) SaldoSoles,
       sum(decode(a.aomda, 0, 1, 0)) NroSoles,
       sum(decode(a.aomda, 101, a.aoimp, 0)) SaldoDolares,
       sum(decode(a.aomda, 101, 1, 0)) NroDolares
  from fsd010 a, fst003 b, fst001 c
 where a.aomod = b.modulo
   and a.aosuc = c.sucurs
   and a.aofval = P_FECHA /*TO_DATE('18072013', 'DDMMYYYY')*/
   and a.aomod in (select modulo from fst111 where dscod = 50)
   and a.aomod <> 120
 group by a.aofval, a.aosuc, c.scnom
 order by 1,2;
COMMIT;
END;
/

