create or replace force view v_certseguros_pr as
select "PRODUCTO","CERTIFICADO","CUENTA","DOCUMENTO" from v_certseguros@sisretail;

