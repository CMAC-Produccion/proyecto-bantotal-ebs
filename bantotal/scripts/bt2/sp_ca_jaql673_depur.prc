create or replace procedure SP_CA_JAQL673_DEPUR(P_FECHA date) is
begin
  --1ra iteración
  update JAQL673 a
     set a.JAQL673COTRA = '999999'
   WHERE a.jaql673fetra <= P_FECHA;
  commit;
  --2da iteración
  update JAQL673 a
     set a.JAQL673COTRA = '888888'
   WHERE a.jaql673fetra <= P_FECHA;
  commit;
  --3ra iteración
  update JAQL673 a
     set a.JAQL673COTRA = '777777'
   WHERE a.jaql673fetra <= P_FECHA;
  commit;
  --depuración
  delete
  from JAQL673 a
   WHERE a.jaql673fetra <= P_FECHA;
  commit;

  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'JAQL673',
                                  degree           => 12,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => true);
  end;
  --log
  insert into AQPB884 values (user,sysdate,'SP_CA_JAQL673_DEPUR');
  commit;

end SP_CA_JAQL673_DEPUR;
/

