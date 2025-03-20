CREATE OR REPLACE PROCEDURE "SP_RENAME_AUD_Z0E478_AUDIT_BT"
IS
  C_ERROR VARCHAR2(5000);
BEGIN
--Renombrar tabla AUD_Z0E478_AUDIT por AUD_Z0E478_AUDIT_DDMMRRRR_HHMI
execute immediate 'RENAME AUD_Z0E478_AUDIT TO AUD_Z0E478_AUDIT_'||TO_CHAR(SYSDATE,'DDMMRRRR_HH24MI');
--Renombrar tabla AUD_Z0E478_AUDIT_NEW por AUD_Z0E478_AUDIT
execute immediate 'RENAME AUD_Z0E478_AUDIT_NEW TO AUD_Z0E478_AUDIT';
--Recrear sin�nimo
execute immediate 'create or replace public synonym AUD_Z0E478_AUDIT for bantprod.AUD_Z0E478_AUDIT';
--Compilar objetos
execute immediate 'ALTER PROCEDURE BANTPROD.AUD_C_Z0E478_AUDIT COMPILE DEBUG';
execute immediate 'ALTER TRIGGER T_AUD_Z0E478_AUD_D COMPILE DEBUG';
execute immediate 'ALTER TRIGGER T_AUD_Z0E478_AUD_I COMPILE DEBUG';
execute immediate 'ALTER TRIGGER T_AUD_Z0E478_AUD_U COMPILE DEBUG';
EXCEPTION
  WHEN OTHERS THEN
    c_error := TO_CHAR('ERROR: '||SQLCODE||' - '||SQLERRM);
    sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',   'FALL� EN RENAME DE AUD_Z0E478_AUDIT','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla AUD_Z0E478_AUDIT');
    sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',   'FALL� EN RENAME DE AUD_Z0E478_AUDIT','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla AUD_Z0E478_AUDIT');
    DBMS_OUTPUT.PUT_LINE('c_error:'||c_error);
END SP_RENAME_AUD_Z0E478_AUDIT_BT;
 /* GOLDENGATE_DDL_REPLICATION */
/

