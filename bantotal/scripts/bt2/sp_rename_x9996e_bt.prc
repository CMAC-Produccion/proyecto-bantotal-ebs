CREATE OR REPLACE PROCEDURE SP_RENAME_X9996E_BT
IS
  C_ERROR VARCHAR2(5000);
BEGIN
--Renombrar tabla X9996E por X9996E_DDMMRRRR_HHMI
execute immediate 'RENAME X9996E TO X9996E_'||TO_CHAR(SYSDATE,'DDMMRRRR_HH24MI');
--Renombrar tabla X9996E_NEW por X9996E
execute immediate 'RENAME X9996E_NEW TO X9996E';
--Recrear sinónimo
execute immediate 'create or replace public synonym X9996E for bantprod.X9996E';
--Ejecutar grants
--execute immediate 'grant select on X9996E to ROL_BANTPROY_CONS';
EXCEPTION
  WHEN OTHERS THEN
    c_error := TO_CHAR('ERROR: '||SQLCODE||' - '||SQLERRM);
    sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',   'FALLÓ EN RENAME DE X9996E','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla X9996E');
    sys.sp_sy_enviamail('mblas@cajaarequipa.pe','mblas@cajaarequipa.pe',       'FALLÓ EN RENAME DE X9996E','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla X9996E');
    sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',       'FALLÓ EN RENAME DE X9996E','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla X9996E');
    --AGREGAR A OPERADOR ENCARGADO
END SP_RENAME_X9996E_BT;
/

