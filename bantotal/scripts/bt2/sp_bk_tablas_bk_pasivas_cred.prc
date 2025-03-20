CREATE OR REPLACE PROCEDURE SP_BK_TABLAS_BK_PASIVAS_CRED IS
  -- ---------------------------------------------------------------------------
  -- Nombre                   : SP_BK_TABLAS_BK_PASIVAS_CRED
  -- Sistema                  : BANTOTAL
  -- Módulo                   : BANTOTAL
  -- Versión                  : 1.0
  -- Fecha de Creación        : 2025.03.09
  -- Autor de Creación        : Erika V. Hidalgo Málaga
  -- Uso                      : Respaldo tablas previa migración pasivas
  -- Estado                   : Activo
  -- Acceso                   : Público
  -- Fecha de Modificación    : 
  -- Autor de Modificación    : 
  -- Descripción Modificación : 
  -- ---------------------------------------------------------------------------
  C_FECHA_HORA VARCHAR2(1000);
BEGIN
  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSD601_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSD601 a';
  operador.sp_alter_table_grant('FSD601_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSD601_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSD601_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSD601_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSD602_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSD602 a';
  operador.sp_alter_table_grant('FSD602_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSD602_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSD602_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSD602_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSD012_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSD012 a';
  operador.sp_alter_table_grant('FSD012_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSD012_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSD012_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSD012_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSD010_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSD010 a';
  operador.sp_alter_table_grant('FSD010_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSD010_' || C_FECHA_HORA ||'
                     parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSD010_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSD010_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSD011_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSD011 a';
  operador.sp_alter_table_grant('FSD011_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSD011_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSD011_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSD011_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSR011_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSR011 a';
  operador.sp_alter_table_grant('FSR011_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSR011_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSR011_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSR011_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSE113_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSE113 a';
  operador.sp_alter_table_grant('FSE113_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSE113_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSE113_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSE113_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSD427_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSD427 a';
  operador.sp_alter_table_grant('FSD427_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSD427_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSD427_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSD427_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSE013_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSE013 a';
  operador.sp_alter_table_grant('FSE013_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSE013_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSE013_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSE013_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSR427_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSR427 a';
  operador.sp_alter_table_grant('FSR427_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSR427_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSR427_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSR427_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.FSR111_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.FSR111 a';
  operador.sp_alter_table_grant('FSR111_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.FSR111_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.FSR111_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.FSR111_' || C_FECHA_HORA);

  C_FECHA_HORA := TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISS');
  EXECUTE IMMEDIATE 'CREATE TABLE operador.PQT100_' || C_FECHA_HORA ||
                    ' parallel (degree 8) nologging compress for archive low tablespace USERS_BANTPROD_B as ' ||
                    'SELECT  a.* FROM  bantprod.PQT100 a';
  operador.sp_alter_table_grant('PQT100_' || C_FECHA_HORA);
/*  EXECUTE IMMEDIATE 'alter TABLE operador.PQT100_' || C_FECHA_HORA ||
                    ' parallel (degree 1) logging';
  EXECUTE IMMEDIATE 'GRANT SELECT ON operador.PQT100_' || C_FECHA_HORA ||
                    ' TO ROL_PRODUCCION,ROL_DESARROLLO_CONS';
*/  dbms_output.put_line('operador.PQT100_' || C_FECHA_HORA);
END;
/

