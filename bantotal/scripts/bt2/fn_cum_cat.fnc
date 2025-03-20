create or replace function fn_cum_cat (input varchar2) return varchar2
    parallel_enable aggregate using type_cum_iter_cat;
/

