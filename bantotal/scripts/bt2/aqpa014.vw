create or replace force view aqpa014 as
select
PRODUCTO AS AQPA014PROD,
CERTIFICADO AS AQPA014CERT,
CUENTA AS AQPA014CUEN,
DOCUMENTO AS AQPA014DOCU
 from v_certseguros@sisretail;

