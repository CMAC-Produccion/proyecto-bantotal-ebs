create or replace procedure SP_SY_STOP_SCHEJOBS_BANTPROD (C_JOB_NAME varchar2)
is
  -- *****************************************************************
  -- NOMBRE                     : SP_SY_STOP_SCHEJOBS_BANTPROD
  -- SISTEMA                    : BANTOTAL
  -- M�DULO                     : ADMINISTRACION JOBS
  -- VERSI�N                    : 1.0
  -- FECHA DE CREACI�N          : 01/12/2023
  -- AUTOR DE CREACI�N          : ERIKA HIDALGO
  -- USO                        : Stop schedulers de bantprod ejecutados por otro usuario
  -- ESTADO                     : ACTIVO
  -- PAR�METROS DE ENTRADA      :
  -- FECHA DE MODIFICACI�N      :
  -- AUTOR DE MODIFICACI�N      :
  cursor c1 is
    SELECT 'begin DBMS_SCHEDULER.stop_JOB (job_name => ''' || JOB_NAME ||
           ''',force=>true);COMMIT; end;' COMANDO
      FROM DBA_SCHEDULER_RUNNING_JOBS
     WHERE OWNER = 'BANTPROD'
       AND JOB_NAME LIKE upper('%'||C_JOB_NAME||'%');
begin
  for i in c1 loop
    begin
    dbms_output.put_line(i.COMANDO);
    execute immediate i.COMANDO;
    exception
      when others then
        null;
    end;
  end loop;
end SP_SY_STOP_SCHEJOBS_BANTPROD;
/

