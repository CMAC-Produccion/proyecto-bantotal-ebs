create or replace procedure SP_BACKUP_FRTASKS_FRPROCES IS
  --Declaracion de variables
  VSTR_SQL VARCHAR2(1000);
  --crea una tabla backup
BEGIN
     VSTR_SQL := 'create table OPERADOR.FRTASKS_'||to_char(sysdate,'yyyymmdd')||' as select * from FRTASKS';
     execute immediate VSTR_SQL;
     VSTR_SQL := 'create table OPERADOR.FRPROCES_'||to_char(sysdate,'yyyymmdd')||' as select * from FRPROCES';
     execute immediate VSTR_SQL;
EXCEPTION
  WHEN others THEN
    null;
END SP_BACKUP_FRTASKS_FRPROCES;
/

