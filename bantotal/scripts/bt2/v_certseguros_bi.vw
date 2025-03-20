create or replace force view v_certseguros_bi as
select "PRODUCTO","CERTIFICADO","CUENTA","DOCUMENTO" from v_certseguros@sisretail;

