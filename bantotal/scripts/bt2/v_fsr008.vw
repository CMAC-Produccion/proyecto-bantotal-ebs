create or replace force view v_fsr008 as
select "PGCOD","CTNRO","PEPAIS","PETDOC","PENDOC","TTCOD","CTTFIR" from FSR008 union all select "PGCOD","CTNRO","PEPAIS","PETDOC","PENDOC","TTCOD","CTTFIR" from FSR008 where 1=2 with read only;

