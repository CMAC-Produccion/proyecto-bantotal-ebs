CREATE OR REPLACE PROCEDURE "SP_RENAME_AUD_FST946_AUDIT_BT"
IS
  C_ERROR VARCHAR2(5000);
BEGIN
--Renombrar tabla AUD_FST946_AUDIT por AUD_FST946_AUDIT_DDMMRRRR_HHMI
execute immediate 'RENAME AUD_FST946_AUDIT TO AUD_FST946_AUDIT_'||TO_CHAR(SYSDATE,'RRRRMMDD_HH24MI');
--Renombrar tabla AUD_FST946_AUDIT_NEW por AUD_FST946_AUDIT
execute immediate 'RENAME AUD_FST946_AUDIT_NEW TO AUD_FST946_AUDIT';
--Recrear sin�nimo
execute immediate 'create or replace public synonym AUD_FST946_AUDIT for bantprod.AUD_FST946_AUDIT';
--Compilar objetos
execute immediate 'ALTER PROCEDURE BANTPROD.AUD_C_FST946_AUDIT COMPILE DEBUG';
execute immediate 'ALTER TRIGGER BANTPROD.T_AUD_FST946_AUD_D COMPILE DEBUG';
execute immediate 'ALTER TRIGGER BANTPROD.T_AUD_FST946_AUD_I COMPILE DEBUG';
execute immediate 'ALTER TRIGGER BANTPROD.T_AUD_FST946_AUD_U COMPILE DEBUG';
EXCEPTION
  WHEN OTHERS THEN
    c_error := TO_CHAR('ERROR: '||SQLCODE||' - '||SQLERRM);
    sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',   'FALL� EN RENAME DE AUD_FST946_AUDIT','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla AUD_FST946_AUDIT');
    sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',   'FALL� EN RENAME DE AUD_FST946_AUDIT','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla AUD_FST946_AUDIT');
    DBMS_OUTPUT.PUT_LINE('c_error:'||c_error);
END SP_RENAME_AUD_FST946_AUDIT_BT;
 /* GOLDENGATE_DDL_REPLICATION */
/

