create or replace force view v_seguros_func as
select "PRODUCTO","CERTIFICADO","CUENTA","DOCUMENTO" from v_certseguros@sisretail;

