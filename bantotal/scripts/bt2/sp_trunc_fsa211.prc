create or replace procedure SP_TRUNC_FSA211 as
begin
  execute immediate 'truncate table FSA211';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'FSA211',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;
end SP_TRUNC_FSA211;
/

