create or replace procedure trunc_CAP001 as
begin
  execute immediate 'truncate table bantprod.cap001';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'CAP001',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;
end;
/

