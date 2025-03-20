CREATE OR REPLACE PROCEDURE SP_RENAME_Z0E4GE_BT
IS
  C_ERROR VARCHAR2(5000);
BEGIN
--Renombrar tabla Z0E4GE por Z0E4GE_DDMMRRRR_HHMI
execute immediate 'RENAME Z0E4GE TO Z0E4GE_'||TO_CHAR(SYSDATE,'DDMMRRRR_HH24MI');
--Renombrar tabla Z0E4GE_NEW por Z0E4GE
execute immediate 'RENAME Z0E4GE_NEW TO Z0E4GE';
--Recrear sinónimo
execute immediate 'create or replace public synonym Z0E4GE for bantprod.Z0E4GE';
--Ejecutar grants
execute immediate 'grant select on Z0E4GE to ROL_BANTPROD_CONS';
execute immediate 'grant select on Z0E4GE to ROL_BANTPROY_CONS';
EXCEPTION
  WHEN OTHERS THEN
    c_error := TO_CHAR('ERROR: '||SQLCODE||' - '||SQLERRM);
    sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',   'FALLÓ EN RENAME DE Z0E4GE','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla Z0E4GE');
    --AGREGAR A OPERADOR ENCARGADO
END SP_RENAME_Z0E4GE_BT;
/

