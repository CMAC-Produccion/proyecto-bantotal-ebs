CREATE OR REPLACE PROCEDURE SP_RENAME_AUD_JAQZ862_AUDIT_BT
IS
  C_ERROR VARCHAR2(5000);
BEGIN
--Renombrar tabla AUD_JAQZ862_AUDIT por AUD_JAQZ862_AUDIT_DDMMRRRR_HHMI
execute immediate 'RENAME AUD_JAQZ862_AUDIT TO AUD_JAQZ862_AUDIT_'||TO_CHAR(SYSDATE,'DDMMRRRR_HH24MI');
--Renombrar tabla AUD_JAQZ862_AUDIT_NEW por AUD_JAQZ862_AUDIT
execute immediate 'RENAME AUD_JAQZ862_AUDIT_NEW TO AUD_JAQZ862_AUDIT';
--Recrear sinónimo
execute immediate 'create or replace public synonym AUD_JAQZ862_AUDIT for bantprod.AUD_JAQZ862_AUDIT';
--Compilar objetos
execute immediate 'ALTER PROCEDURE BANTPROD.AUD_C_JAQZ862_AUDIT COMPILE DEBUG';
execute immediate 'ALTER TRIGGER BANTPROD.T_AUD_JAQZ862_AUD_D COMPILE DEBUG';
execute immediate 'ALTER TRIGGER BANTPROD.T_AUD_JAQZ862_AUD_I COMPILE DEBUG';
execute immediate 'ALTER TRIGGER BANTPROD.T_AUD_JAQZ862_AUD_U COMPILE DEBUG';
EXCEPTION
  WHEN OTHERS THEN
    c_error := TO_CHAR('ERROR: '||SQLCODE||' - '||SQLERRM);
    sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',   'FALLÓ EN RENAME DE AUD_JAQZ862_AUDIT','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla AUD_JAQZ862_AUDIT');
    DBMS_OUTPUT.PUT_LINE('c_error:'||c_error);
END SP_RENAME_AUD_JAQZ862_AUDIT_BT;
/

