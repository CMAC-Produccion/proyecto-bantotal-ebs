create or replace procedure SP_ST_BANTPROD_4 IS
    -- *****************************************************************
    -- Nombre                     : SP_ST_BANTPROD_4
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : ADMINISTRATIVO
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 2024.09.25
    -- Autor de Creaci�n          : EHIDALGOM
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Fecha de Modificaci�n      : -
    -- Autor de la Modificaci�n   : -
    -- Descripci�n de Modificaci�n: -
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

