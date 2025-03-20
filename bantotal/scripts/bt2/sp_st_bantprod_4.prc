create or replace procedure SP_ST_BANTPROD_4 IS
    -- *****************************************************************
    -- Nombre                     : SP_ST_BANTPROD_4
    -- Sistema                    : BANTOTAL
    -- Módulo                     : ADMINISTRATIVO
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.09.25
    -- Autor de Creación          : EHIDALGOM
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de la Modificación   : -
    -- Descripción de Modificación: -
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
begin

  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  UPDATE AQPD501 SET fecini = sysdate WHERE table_name = 'FPAE71';
  COMMIT;

  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'FPAE71',
                                  degree           => 35,
                                  granularity      => 'ALL',
                                  estimate_percent => 25,
                                  cascade          => TRUE);
  end;

  UPDATE AQPD501
     SET APLICADO = 'S', fecfin = sysdate
   WHERE table_name = 'FPAE71';
  COMMIT;

 insert into AQPD501h
    select *
      from AQPD501
     where table_name in ('FPAE71');
  commit;

end SP_ST_BANTPROD_4;
/

