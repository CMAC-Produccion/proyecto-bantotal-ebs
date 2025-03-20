create or replace procedure trunc_cartera as
begin
  execute immediate 'truncate table bantprod.cartera';
end;
/

