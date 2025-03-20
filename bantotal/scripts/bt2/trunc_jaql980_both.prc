create or replace procedure trunc_JAQL980_both as
begin
  execute immediate 'truncate table bantprod.JAQL980A';
  execute immediate 'truncate table bantprod.JAQL980';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'JAQL980A',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'JAQL980',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;
end;
/

