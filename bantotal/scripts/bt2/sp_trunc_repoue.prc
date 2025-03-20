create or replace procedure sp_trunc_repoue as
begin
  execute immediate 'truncate table bantprod.repoue';
end;
/

