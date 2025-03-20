create or replace procedure SP_ST_BANTPROD_7 IS
    -- *****************************************************************
    -- Nombre                     : SP_ST_BANTPROD_7
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
  UPDATE AQPD501 SET fecini = sysdate WHERE table_name = 'FSR008';
  COMMIT;

  begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'FSR008',
                                degree           => 10,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
  end;

  UPDATE AQPD501
     SET APLICADO = 'S', fecfin = sysdate
   WHERE table_name = 'FSR008';
  COMMIT;
  UPDATE AQPD501 SET fecini = sysdate WHERE table_name = 'RNPE06';
  COMMIT;
   begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'RNPE06',
                                  DEGREE           => 50,
                                  GRANULARITY      => 'ALL',
                                  ESTIMATE_PERCENT => 100,
                                  CASCADE          => TRUE);
  end;
  UPDATE AQPD501
     SET APLICADO = 'S', fecfin = sysdate
   WHERE table_name = 'RNPE06';
  COMMIT;

 insert into AQPD501h
    select *
      from AQPD501
     where table_name  in ('FSR008','RNPE06');
  commit;
end SP_ST_BANTPROD_7;
/

