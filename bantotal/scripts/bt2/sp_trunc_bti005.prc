create or replace procedure "SP_TRUNC_BTI005" as
  VSTR_SQL   VARCHAR2(1000);
  VHOST_NAME VARCHAR2(100);
  p_c_msgerr VARCHAR2(1000);
  v_found    number;
begin
  if to_number(to_char(sysdate, 'DD')) in (1, 2, 3) then
    --03.02.2015

    VSTR_SQL := 'create table OPERADOR.BTI005_' ||
                to_char(sysdate, 'yyyymmdd') || ' compress as select * from BTI005';
    execute immediate VSTR_SQL;

  end if;

  execute immediate 'truncate table BTI005';
  --29.12.2021
  execute immediate 'alter table BTI005 move tablespace BANTPROD_H';
  execute immediate 'alter index SYS_C00983295 rebuild tablespace BANTPROD_H_IDX';

  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'BTI005',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => TRUE);
  end;
  sys.sp_sy_enviamail('bantoem@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Se ejecuto el procedimiento SP_TRUNC_BTI005',
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      CHR(13) || 'Se ejecuto el procedimiento SP_TRUNC_BTI005');
  sys.sp_sy_enviamail('bantoem@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Se ejecuto el procedimiento SP_TRUNC_BTI005',
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      CHR(13) || 'Se ejecuto el procedimiento SP_TRUNC_BTI005');

  sys.sp_sy_enviamail('bantoem@cajaarequipa.pe',
                      'jsanchez@cajaarequipa.pe',
                      'Se ejecuto el procedimiento SP_TRUNC_BTI005',
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      CHR(13) || 'Se ejecuto el procedimiento SP_TRUNC_BTI005');

EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
  WHEN others THEN
    null;
END;
 /* GOLDENGATE_DDL_REPLICATION */
/

