create or replace procedure SP_ST_BANTPROD_6 IS
    -- *****************************************************************
    -- Nombre                     : SP_ST_BANTPROD_6
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
  UPDATE AQPD501 SET fecini = sysdate WHERE table_name = 'FSH016';
  COMMIT;

  begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'FSH016',
                                degree           => 50,
                                granularity      => 'ALL',
                                estimate_percent => dbms_stats.auto_sample_size,
                                cascade          => TRUE);
  end;

  UPDATE AQPD501
     SET APLICADO = 'S', fecfin = sysdate
   WHERE table_name = 'FSH016';
  COMMIT;

  UPDATE AQPD501 SET fecini = sysdate WHERE table_name = 'FSH014';
  COMMIT;

  begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'FSH014',
                                degree           => 50,
                                granularity      => 'ALL',
                                estimate_percent => dbms_stats.auto_sample_size,
                                cascade          => TRUE);
  end;

  UPDATE AQPD501
     SET APLICADO = 'S', fecfin = sysdate
   WHERE table_name = 'FSH014';
  COMMIT;


  UPDATE AQPD501 SET fecini = sysdate WHERE table_name = 'JAQL539';
  COMMIT;

  begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'JAQL539',
                                degree           => 50,
                                granularity      => 'ALL',
                                estimate_percent => dbms_stats.auto_sample_size,
                                cascade          => TRUE);
  end;

  UPDATE AQPD501
     SET APLICADO = 'S', fecfin = sysdate
   WHERE table_name = 'JAQL539';
  COMMIT;

 insert into AQPD501h
    select *
      from AQPD501
     where table_name in ('FSH016','FSH014','JAQL539');
  commit;
end SP_ST_BANTPROD_6;
/

