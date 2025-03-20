create or replace procedure SP_CR_MC_REP_CARTERA_OPE(P_USER in varchar, P_EMPCOD in number, P_NROOPE in number, P_ERRCOD out varchar, P_ERRMSG out varchar) as

ld_crefec DATE;

begin

select aqpb506acrefec into ld_crefec from aqpb506a where aqpb506aempcod = P_EMPCOD AND aqpb506anroope = P_NROOPE;


---*** REP. Generado Anteriormente x el Usuario
delete from AQPB506C where AQPB506CCREUSR  = P_USER;
---***
insert into AQPB506C(
---*** SOLES
select 0 AS AQPB506CID, P_USER AS AQPB506CCREUSR, SYSDATE AS AQPB506CCRETIM, ld_crefec AS AQPB506CFECVIG
, P_NROOPE AS AQPB506CNROOPE, COALESCE(SUM(b.aqpb506bmonsal), 0) AS AQPB506CSALTOT, count(b.aqpb506bnrocre) AS AQPB506CQTYCRE
,ld_crefec AS AQPB506CFECMAR, 0 AS AQPB506CMONEDA
from aqpb506b b
where b.aqpb506bempcod = P_EMPCOD AND b.aqpb506bnroope = P_NROOPE AND b.aqpb506bscmda = 0

UNION

---*** DOLARES
select 101 AS AQPB506CID,P_USER AS AQPB506CCREUSR, SYSDATE AS AQPB506CCRETIM, ld_crefec AS AQPB506CFECVIG
, P_NROOPE AS AQPB506CNROOPE, COALESCE(SUM(b.aqpb506bmonsal), 0) AS AQPB506CSALTOT, count(b.aqpb506bnrocre) AS AQPB506CQTYCRE
,ld_crefec AS AQPB506CFECMAR, 101 AS AQPB506CMONEDA
from aqpb506b b
where b.aqpb506bempcod = P_EMPCOD AND b.aqpb506bnroope = P_NROOPE AND b.aqpb506bscmda = 101
);
---***
commit;
---***
P_ERRCOD := '000';
P_ERRMSG := 'PROCESO TERMINADO SATISFACTORIAMENTE!!!';
---***
exception
when others then
    ---***
    IF (SQLCODE = 100) THEN
      P_ERRCOD := '001';
      P_ERRMSG := 'OCURRIÓ UN ERROR : No hay Datos para esta Empresa/Operación';
    ELSE
      P_ERRCOD := '002';
      P_ERRMSG := 'OCURRIÓ UN ERROR';
    END IF;
end;
/

