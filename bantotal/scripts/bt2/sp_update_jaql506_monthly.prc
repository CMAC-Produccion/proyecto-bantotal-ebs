create or replace procedure "SP_UPDATE_JAQL506_MONTHLY" IS
  --Declaracion de variables
  VSTR_SQL VARCHAR2(1000);
  VHOST_NAME VARCHAR2( 100 );
  p_c_msgerr VARCHAR2(1000);
v_found number;
  --crea una tabla backup
  --trunca la tabla principal
BEGIN
/*     VSTR_SQL := 'alter table JAQL506 nologging';
     execute immediate VSTR_SQL;*/
     update /*+ALL_ROWS*/ jaql506 set jaql506fepro = trunc(sysdate) WHERE jaql506coent<>2;
     commit;
/*     VSTR_SQL := 'alter table jaql506 logging';
     execute immediate VSTR_SQL;*/
     sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                   'Se ejecuto el procedimiento SP_UPDATE_JAQL506_MONTHLY',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'Se ejecuto el procedimiento SP_UPDATE_JAQL506_MONTHLY');
     sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
                   'Se ejecuto el procedimiento SP_UPDATE_JAQL506_MONTHLY',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'Se ejecuto el procedimiento SP_UPDATE_JAQL506_MONTHLY');              

     sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','gyaranga@cajaarequipa.pe',
                   'Se ejecuto el procedimiento SP_UPDATE_JAQL506_MONTHLY',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'Se ejecuto el procedimiento SP_UPDATE_JAQL506_MONTHLY');

EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
  WHEN others THEN
    sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                   'ERROR en ejecución del procedimiento SP_UPDATE_JAQL506_MONTHLY',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'ERROR en ejecución del procedimiento SP_UPDATE_JAQL506_MONTHLY');
    sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
                   'ERROR en ejecución del procedimiento SP_UPDATE_JAQL506_MONTHLY',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'ERROR en ejecución del procedimiento SP_UPDATE_JAQL506_MONTHLY');

END SP_UPDATE_JAQL506_MONTHLY;
 /* GOLDENGATE_DDL_REPLICATION */
/

