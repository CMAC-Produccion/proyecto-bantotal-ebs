create or replace procedure SP_SY_REMOVE_JOBS_BANTPROD (C_USER varchar2, C_WHAT varchar2) is
  -- *****************************************************************
  -- NOMBRE                     : SP_SY_REMOVE_JOBS_BANTPROD
  -- SISTEMA                    : BANTOTAL
  -- M�DULO                     : ADMINISTRACION JOBS
  -- VERSI�N                    : 1.0
  -- FECHA DE CREACI�N          : 01/12/2023
  -- AUTOR DE CREACI�N          : ERIKA HIDALGO
  -- USO                        : Elimina dbms_jobs de bantprod ejecutados por otro usuario
  -- ESTADO                     : ACTIVO
  -- PAR�METROS DE ENTRADA      :
  -- FECHA DE MODIFICACI�N      :
  -- AUTOR DE MODIFICACI�N      :
  cursor c1 is
    SELECT 'BEGIN DBMS_JOB.REMOVE(JOB => ' || JOB || ') ;COMMIT; END;' COMANDO
      FROM DBA_JOBS A
     WHERE LOG_USER = C_USER and UPPER(WHAT) LIKE upper('%'||C_WHAT||'%');
begin
  for i in c1 loop
    dbms_output.put_line(i.COMANDO);
    execute immediate i.COMANDO;
  end loop;
end;
/

