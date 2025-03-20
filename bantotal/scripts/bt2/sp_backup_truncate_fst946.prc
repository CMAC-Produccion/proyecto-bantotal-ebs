create or replace procedure "SP_BACKUP_TRUNCATE_FST946" IS
  --Declaracion de variables
  VSTR_SQL VARCHAR2(1000);
  VHOST_NAME VARCHAR2( 100 );
  p_c_msgerr VARCHAR2(1000);

BEGIN

  SELECT HOST_NAME
    INTO VHOST_NAME
  FROM V$INSTANCE;

     VSTR_SQL := 'create table OPERADOR.FST946_'||to_char(sysdate,'yyyymmdd')||' 
      parallel (degree 4) nologging compress as select a.* from FST946 a';

     execute immediate VSTR_SQL;

     VSTR_SQL := 'truncate table FST946';
     execute immediate VSTR_SQL;

     begin
       DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                     tabname          => 'FST946',
                                     degree           => 8,
                                     granularity      => 'ALL',
                                     estimate_percent => 100,
                                     cascade          => TRUE);
     end;

     sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                   'Se ejecuto el procedimiento BACKUP_TRUNCATE_FST946',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'Se ejecuto el procedimiento SP_BACKUP_TRUNCATE_FST946');

     sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','jsanchez@cajaarequipa.pe',
                   'Se ejecuto el procedimiento BACKUP_TRUNCATE_FST946',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'Se ejecuto el procedimiento SP_BACKUP_TRUNCATE_FST946');

     sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
                   'Se ejecuto el procedimiento BACKUP_TRUNCATE_FST946',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'Se ejecuto el procedimiento SP_BACKUP_TRUNCATE_FST946');
EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || p_c_msgerr);
  WHEN others THEN
    null;

END SP_BACKUP_TRUNCATE_FST946;
 /* GOLDENGATE_DDL_REPLICATION */
/

