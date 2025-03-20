create or replace procedure SP_SY_DROP_SCHEJOBS_BANTPROD ( C_JOB_NAME varchar2)
is
  -- *****************************************************************
  -- NOMBRE                     : SP_SY_DROP_SCHEJOBS_BANTPROD
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION JOBS
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 01/12/2023
  -- AUTOR DE CREACIÓN          : ERIKA HIDALGO
  -- USO                        : Eliminar schedulers de bantprod ejecutados por otro usuario
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      :
  -- FECHA DE MODIFICACIÓN      :
  -- AUTOR DE MODIFICACIÓN      :
  cursor c2 is
    SELECT 'begin DBMS_SCHEDULER.drop_JOB (job_name => ''' || job_name ||
           ''');COMMIT; end;' COMANDO
      FROM DBA_SCHEDULER_JOBS
     WHERE OWNER = 'BANTPROD'
       AND JOB_NAME LIKE upper('%' || C_JOB_NAME || '%');
begin
  for j in c2 loop
    begin
    dbms_output.put_line(j.COMANDO);
    execute immediate j.COMANDO;
    exception
      when others then
        null;
    end;
  end loop;
end SP_SY_DROP_SCHEJOBS_BANTPROD;
/

