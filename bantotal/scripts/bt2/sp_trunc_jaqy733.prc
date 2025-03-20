create or replace procedure sp_trunc_JAQY733 as
begin
  execute immediate 'truncate table JAQY733';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'JAQY733',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;
end;
/

