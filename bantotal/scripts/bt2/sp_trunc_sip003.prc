create or replace procedure sp_trunc_SIP003 as
begin
--  execute immediate 'truncate table bantprod.SIP003';
  --aprobado por Luis C.
  delete /*+all_rows*/
  from sip003
   where sip3oper in ((select scoper
                        from fsd011 a, fst111 b
                       where pgcod = 1
                         and scmod = modulo
                         and dscod = 50
                         and modulo > 100));
  commit;

  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'SIP003',
                                  degree           => 20,--01.09.2022
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;
end;
/

