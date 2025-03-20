create or replace procedure SP_ST_BANTPROD_3 IS
    -- *****************************************************************
    -- Nombre                     : SP_ST_BANTPROD_3
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
UPDATE AQPD501 SET fecini=sysdate WHERE table_name='FSH021';
COMMIT;
begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'FSH021',
                                degree           => 40,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;--70m
UPDATE AQPD501 SET APLICADO = 'S',fecfin=sysdate WHERE table_name='FSH021';
COMMIT;

UPDATE AQPD501 SET fecini=sysdate WHERE table_name='FSX016';
COMMIT;
begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'FSX016',
                                degree           => 40,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;--25m
UPDATE AQPD501 SET APLICADO = 'S',fecfin=sysdate WHERE table_name='FSX016';
COMMIT;

UPDATE AQPD501 SET fecini=sysdate WHERE table_name='TI0019';
COMMIT;
begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'TI0019',
                                degree           => 40,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;--20m
UPDATE AQPD501 SET APLICADO = 'S',fecfin=sysdate WHERE table_name='TI0019';
COMMIT;

UPDATE AQPD501 SET fecini=sysdate WHERE table_name='JAQL357';
COMMIT;
begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'JAQL357',
                                degree           => 40,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;--9m
UPDATE AQPD501 SET APLICADO = 'S',fecfin=sysdate WHERE table_name='JAQL357';
COMMIT;


UPDATE AQPD501 SET fecini=sysdate WHERE table_name='JAQL099';
COMMIT;
begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'JAQL099',
                                degree           => 40,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;--8m
UPDATE AQPD501 SET APLICADO = 'S',fecfin=sysdate WHERE table_name='JAQL099';
COMMIT;

UPDATE AQPD501 SET fecini=sysdate WHERE table_name='JAQL547';
COMMIT;
begin
  DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                tabname          => 'JAQL547',
                                degree           => 40,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;--11m
UPDATE AQPD501 SET APLICADO = 'S',fecfin=sysdate WHERE table_name='JAQL547';
COMMIT;

 insert into AQPD501h
    select *
      from AQPD501
     where table_name in ('FSH021',
                              'FSX016',
                              'TI0019',
                              'JAQL547',
                              'JAQL099',
                              'JAQL357');
  commit;

end SP_ST_BANTPROD_3;
/

