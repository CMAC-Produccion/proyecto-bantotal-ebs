create or replace procedure trunc_JAQY646B as
begin
  execute immediate 'truncate table bantprod.JAQY646B';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'JAQY646B',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;
end;
/

