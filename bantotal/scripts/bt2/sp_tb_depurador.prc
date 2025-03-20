create or replace procedure SP_TB_DEPURADOR is

begin
  begin
    execute immediate ('truncate table FSD015');
  exception
    when others then
      RAISE_APPLICATION_ERROR(-20003, 'Error al truncate a FSD015');
  end;

  begin
    execute immediate ('truncate table FSD016');
  exception
    when others then
      RAISE_APPLICATION_ERROR(-20003, 'Error al truncate a FSD016');
  end;

  begin
    execute immediate ('truncate table FSD603');
  exception
    when others then
      RAISE_APPLICATION_ERROR(-20003, 'Error al truncate a FSD603');
  end;

  begin
    --  dbms_stats.unlock_schema_stats('BANTPROD');
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'FSD015',
                                  degree           => 10,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;

  begin
    --  dbms_stats.unlock_schema_stats('BANTPROD');
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'FSD016',
                                  degree           => 10,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;

  begin
    --  dbms_stats.unlock_schema_stats('BANTPROD');
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'FSD603',
                                  degree           => 10,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;

end SP_TB_DEPURADOR;
/

