create or replace force view v_fst746 as
select "UBUSER","UBNOM","PGCODAC","PGNOMAC","UBFECH","UBHORA" from FST746 union all select "UBUSER","UBNOM","PGCODAC","PGNOMAC","UBFECH","UBHORA" from FST746 where 1=2  with read only;

