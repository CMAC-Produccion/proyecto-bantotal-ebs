CREATE OR REPLACE PROCEDURE "SP_AR_INSERTA_RIESGOS_MH_AQPC313"(pd_fecfmes date, pc_modo varchar2, pc_coderr out varchar2, pc_deserr out varchar2) is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : SP_AR_INSERTA_RIESGOS_MH_AQPC313
  -- Sistema               : BANTOTAL
  -- Módulo                : Activas
  -- Versión               : 1.0
  -- Fecha de Creación     : 19/06/2023
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Uso                   : Carga de tablas externas enviados por metod.y herramientas de riesgo
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 06/09/2023
  -- Autor de Modificación : Renzo Cuadros Salazar
  -- Descripción Modific.  : Se agrega flag para actualizar datos de una fecha ya procesada
  -- Fecha de Modificación : 
  -- Autor de Modificación : 
  -- Descripción Modific.  : 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  anio        CHAR(4);
  mes         CHAR(2);
  ld_FecCar   DATE;
  partcci     VARCHAR2(14);
  ln_Contad   NUMBER;
  fec_part    VARCHAR2(10);
  c_error     VARCHAR2(2000);
  V_HOSTNAME  VARCHAR2(100);
  ld_MesAct   DATE;
  ld_MesCar   DATE;
  partcci_sig VARCHAR2(14);
  ld_MinMesCar DATE;
  ld_lastPartDate DATE;
  partcci_upd VARCHAR2(14); --rcuadros 06/09/2023
begin
  pc_coderr := '00000';
  pc_deserr := '';
  select HOST_NAME into V_HOSTNAME from v$instance;
  
  begin
    execute immediate 'ALTER SESSION SET COMMIT_WAIT=NOWAIT';
    execute immediate 'ALTER SESSION SET COMMIT_LOGGING=BATCH';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS';
  exception
    when others then
      null;
  end;
  
  anio        := to_char(pd_fecfmes, 'RRRR');
  mes         := to_char(pd_fecfmes, 'MM');
  partcci     := 'AQPC313_' || mes || anio;
  fec_part    := to_char(pd_fecfmes + 1, 'YYYY-MM-DD'); --para fecha límite de partición
  ld_MesAct   := TO_DATE('01/' || to_char(sysdate, 'MM/YYYY'), 'DD/MM/YYYY');
  ld_MesCar   := TO_DATE('01/' || to_char(pd_fecfmes, 'MM/YYYY'), 'DD/MM/YYYY');
  partcci_sig := 'AQPC313_' || to_char(ADD_MONTHS(pd_fecfmes, 1), 'MMRRRR');
  ld_MinMesCar := TO_DATE('01/01/2020', 'DD/MM/YYYY');
  partcci_upd  := 'AQPC313_' || to_char(pd_fecfmes, 'MMRRRR'); --rcuadros 06/09/2023
  
  -- Verifica que la fecha de carga corresponda a la fecha de los registros de la tabla temporal
  begin
    select to_date(aqpc3131fecpro, 'DD/MM/YYYY') into ld_FecCar from aqpc3131 WHERE rownum <= 1;
  exception
    when others then
      pc_coderr := '31001';
      pc_deserr := '31001-(01) | No hay datos para cargar en el archivo Global_F.csv';
      return;
  end;
  
  if ld_FecCar <> pd_fecfmes then
    pc_coderr := '31002';
    pc_deserr := '31002-(02) | Fecha de carga ingresada es diferente a la fecha de carga de los registros del archivo Global_F.csv';
    return;
  end if;
  
  if pc_modo = 'C' then --Carga Normal --rcuadros 06/09/2023
    -- Valida fecha de carga
    if months_between(ld_MesAct, ld_MesCar) > 43 then
      pc_coderr := '31003';
      pc_deserr := '31003-(03) | No se puede cargar información con fecha muy antigua';
      return;
    elsif months_between(sysdate, pd_fecfmes) < 0 then
      pc_coderr := '31004';
      pc_deserr := '31004-(04) | Fecha de carga ingresada no puede ser mayor al día de hoy';
      return;
    end if;
    -- Valida la fecha de carga no sea mayor por 1 mes a la fecha de la ultima particion
    select to_date('01/' || substr(min(PARTITION_NAME), -6), 'DD/MM/YYYY') into ld_lastPartDate from DBA_TAB_PARTITIONS
    where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC313' and PARTITION_POSITION = (select max(PARTITION_POSITION) from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC313');

    if to_date(ld_MesCar, 'DD/MM/YYYY') > add_months(to_date(ld_lastPartDate, 'DD/MM/YYYY'), 1) then
      pc_coderr := '31005';
      pc_deserr := '31005-(05) | La fecha de carga no es válida';
      return;
    end if;
    -- Valida particion siguiente
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC313' and PARTITION_NAME = partcci_sig;  
    if ln_Contad > 0 then
      pc_coderr := '31006';
      pc_deserr := '31006-(06) | No se puede cargar información anterior al último mes procesado';
      return;
    end if;
    -- Verifica si ya existe una partición previa, y si existe la borra
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC313' and PARTITION_NAME = partcci;
    if ln_Contad > 0 then
      begin
        execute immediate 'ALTER TABLE AQPC313 DROP PARTITION ' || partcci || ' UPDATE INDEXES';
        exception
          when others then
            c_error := to_char(SQLCODE || ' - ' || SQLERRM);
            begin
              sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                                  PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                                  PC_MOTIVO  => 'NO se pudo eliminar la partición ' ||
                                                 partcci || ' - ' ||
                                                 sys_context('USERENV', 'DB_NAME'),
                                  PC_MENSAJE => 'NO se pudo eliminar la partición ' ||
                                                 partcci || CHR(13) || c_error);
            exception
              when others then
                null;
            end;
            begin 
              sys.sp_sy_enviamail(PC_DE      => 'kcabrerac@cajaarequipa.pe',
                                  PC_AQUIEN  => 'kcabrerac@cajaarequipa.pe',
                                  PC_MOTIVO  => 'NO se pudo eliminar la partición ' ||
                                                 partcci || ' - ' ||
                                                 sys_context('USERENV', 'DB_NAME'),
                                  PC_MENSAJE => 'NO se pudo eliminar la partición ' ||
                                                 partcci || CHR(13) || c_error);
            exception
              when others then
                null;
            end;
            pc_coderr := '31007';
            pc_deserr := '31007-(07) | No se pudo borrar la partición';
            return; --si no se borra la partición, termina el procedimiento
      end;
    end if;
      
    -- Añade una nueva partición
    begin
      execute immediate 'ALTER TABLE AQPC313 ADD PARTITION ' || partcci ||
      ' VALUES LESS THAN (TO_DATE(''' || fec_part || ''', ''YYYY-MM-DD'')) TABLESPACE BANTPROD_B';
    exception
      when others then
        c_error := TO_CHAR(SQLCODE || ' - ' || SQLERRM);
        begin
          sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                              PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo crear la partición ' ||
                                            partcci || ' - ' ||
                                            sys_context('USERENV', 'DB_NAME'),
                              PC_MENSAJE => 'NO se pudo crear la partición ' ||
                                            partcci || CHR(13) || c_error);
        exception
          when others then
            null;
        end;
        begin
          sys.sp_sy_enviamail(PC_DE      => 'kcabrerac@cajaarequipa.pe',
                              PC_AQUIEN  => 'kcabrerac@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo crear la partición ' ||
                                            partcci || ' - ' ||
                                            sys_context('USERENV', 'DB_NAME'),
                              PC_MENSAJE => 'NO se pudo crear la partición ' ||
                                            partcci || CHR(13) || c_error);
        exception
          when others then
            null;
        end;
        pc_coderr := '31008';
        pc_deserr := '31008-(08) | No se pudo añadir la partición';
        return; --si no se crea la partición, termina el procedimiento
    end;

    --Deshabilito índices de nueva partición
    begin
      execute immediate 'ALTER TABLE AQPC313 MODIFY PARTITION ' || partcci ||
      ' UNUSABLE LOCAL INDEXES';
    exception
      when others then
        c_error := to_char(SQLCODE || ' - ' || SQLERRM);
        begin
          sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                              PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo inhabilitar los ìndices de la partición AQPC313' ||
                                            partcci || ' - ' ||
                                            sys_context('USERENV', 'DB_NAME'),
                              PC_MENSAJE => 'NO se pudo inhabilitar los ìndices de la partición ' ||
                                            partcci || CHR(13) || c_error);
        exception
          when others then
            null;
        end;
        begin
          sys.sp_sy_enviamail(PC_DE      => 'kcabrerac@cajaarequipa.pe',
                              PC_AQUIEN  => 'kcabrerac@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo inhabilitar los ìndices de la partición AQPC313' ||
                                            partcci || ' - ' ||
                                            sys_context('USERENV', 'DB_NAME'),
                              PC_MENSAJE => 'NO se pudo inhabilitar los ìndices de la partición ' ||
                                            partcci || CHR(13) || c_error);
        exception
          when others then
            null;
        end;
    end;
  else --Actualizar
    --Verificamos si la particion existe
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC313' and PARTITION_NAME = partcci_upd;
    
    if ln_Contad > 0 then
       begin
        execute immediate 'DELETE FROM AQPC313 PARTITION (' || partcci_upd || ')';
        exception
          when others then
            c_error := to_char(SQLCODE || ' - ' || SQLERRM);
            begin
              sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                                  PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                                  PC_MOTIVO  => 'NO se pudo eliminar los datos de la partición ' ||
                                                 partcci_upd || ' - ' ||
                                                 sys_context('USERENV', 'DB_NAME'),
                                  PC_MENSAJE => 'NO se pudo eliminar los datos de la partición ' ||
                                                 partcci_upd || CHR(13) || c_error);
            exception
              when others then
                null;
            end;
            begin 
              sys.sp_sy_enviamail(PC_DE      => 'kcabrerac@cajaarequipa.pe',
                                  PC_AQUIEN  => 'kcabrerac@cajaarequipa.pe',
                                  PC_MOTIVO  => 'NO se pudo eliminar los datos de la partición ' ||
                                                 partcci_upd || ' - ' ||
                                                 sys_context('USERENV', 'DB_NAME'),
                                  PC_MENSAJE => 'NO se pudo eliminar los datos de la partición ' ||
                                                 partcci_upd || CHR(13) || c_error);
            exception
              when others then
                null;
            end;
            pc_coderr := '31011';
            pc_deserr := '31011-(11) | No se pudo borrar los datos de la partición';
            return; --si no se borra la partición, termina el procedimiento
      end;
    else
      pc_coderr := '31012';
      pc_deserr := '31012-(12) | La fecha que intenta actualizar no existe';
      return;
    end if;
  end if; --rcuadros 06/09/2023
  
  begin
    execute immediate 'ALTER SESSION ENABLE PARALLEL DML';
  exception
    when others then
      null;
  end;
  
  begin
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  exception
    when others then
      null;
  end;

  execute immediate 'ALTER TABLE AQPC313 PARALLEL 10';
  -- Inserta registros
  begin
  -- Inserta AQPC313
  insert /*+append*/
  into aqpc313
    (aqpc313fecpro,
    aqpc313bccta,
    aqpc313bcoper,
    aqpc313pago)
  select /*+parallel(g,10)*/
    case when regexp_like(g.aqpc3131fecpro, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3131fecpro, 'DD/MM/YYYY') else null end,
    case when regexp_like(g.aqpc3131bccta, '^\d+$') then to_number(g.aqpc3131bccta) else null end,
    case when regexp_like(g.aqpc3131bcoper, '^\d+$') then to_number(g.aqpc3131bcoper) else null end,
    case when regexp_like(regexp_replace(trim(to_char(aqpc3131pago)), '[^0-9]', ''), '^\d+$') then to_number(regexp_replace(trim(to_char(aqpc3131pago)), '[^0-9]', '')) else null end
  from aqpc3131 g;
  commit;
  exception
    when others then
	  execute immediate 'ALTER TABLE AQPC313 PARALLEL 1';
      c_error := to_char(SQLCODE || ' - ' || SQLERRM);
      pc_coderr := '31009';
      pc_deserr := '31009-(09) | No se pudieron insertar los registros';
      return;
  end;
  --Activa índices de partición
  begin
    execute immediate 'ALTER TABLE AQPC313 MODIFY PARTITION ' || partcci ||
    ' REBUILD UNUSABLE LOCAL INDEXES';
  exception
    when others then
      c_error := to_char(SQLCODE || ' - ' || SQLERRM);
      begin
        sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                            PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                            PC_MOTIVO  => 'NO se pudo habilitar los ìndices de la partición AQPC313' ||
                                          partcci || ' - ' ||
                                          sys_context('USERENV', 'DB_NAME'),
                            PC_MENSAJE => 'NO se pudo habilitar los ìndices de la partición ' ||
                                          partcci || CHR(13) || c_error);
      exception
        when others then
          null;
      end;
      begin
        sys.sp_sy_enviamail(PC_DE      => 'kcabrerac@cajaarequipa.pe',
                            PC_AQUIEN  => 'kcabrerac@cajaarequipa.pe',
                            PC_MOTIVO  => 'NO se pudo habilitar los ìndices de la partición AQPC313' ||
                                          partcci || ' - ' ||
                                          sys_context('USERENV', 'DB_NAME'),
                            PC_MENSAJE => 'NO se pudo habilitar los ìndices de la partición ' ||
                                          partcci || CHR(13) || c_error);
      exception
        when others then
          null;
      end;
      pc_coderr := '31010';
      pc_deserr := '31010-(10) | No se pudieron reactivar los índices de la partición';
      return; --si no se habilitan los índices de la partición, termina el procedimiento
  end;

  execute immediate 'ALTER TABLE AQPC313 PARALLEL 1';

  --Estadísticas
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPC313',
                                  degree           => 10,
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  partname         => partcci);
  end;
end SP_AR_INSERTA_RIESGOS_MH_AQPC313;
 /* GOLDENGATE_DDL_REPLICATION */
/

