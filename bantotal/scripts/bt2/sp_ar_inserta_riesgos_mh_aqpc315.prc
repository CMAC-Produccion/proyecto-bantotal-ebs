CREATE OR REPLACE PROCEDURE SP_AR_INSERTA_RIESGOS_MH_AQPC315(pd_fecfmes date, pc_modo varchar2, pc_coderr out varchar2, pc_deserr out varchar2) is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : SP_AR_INSERTA_RIESGOS_MH_AQPC315
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
  
  anio         := to_char(pd_fecfmes, 'RRRR');
  mes          := to_char(pd_fecfmes, 'MM');
  partcci      := 'AQPC315_' || mes || anio;
  fec_part     := to_char(pd_fecfmes + 1, 'YYYY-MM-DD'); --para fecha límite de partición
  ld_MesAct    := TO_DATE('01/' || to_char(sysdate, 'MM/YYYY'), 'DD/MM/YYYY');
  ld_MesCar    := TO_DATE('01/' || to_char(pd_fecfmes, 'MM/YYYY'), 'DD/MM/YYYY');
  partcci_sig  := 'AQPC315_' || to_char(ADD_MONTHS(pd_fecfmes, 1), 'MMRRRR');
  ld_MinMesCar := TO_DATE('01/01/2020', 'DD/MM/YYYY');
  partcci_upd  := 'AQPC315_' || to_char(pd_fecfmes, 'MMRRRR');
  
  -- Verifica que la fecha de carga corresponda a la fecha de los registros de la tabla temporal
    begin
      select to_date(aqpc3151fecpro, 'DD/MM/YYYY') into ld_FecCar from aqpc3151 WHERE rownum <= 1;
    exception
      when others then
        pc_coderr := '31001';
        pc_deserr := '31001-(01) | No hay datos para cargar en el archivo TMA.csv';
        return;
    end;
    
    if ld_FecCar <> pd_fecfmes then
      pc_coderr := '31002';
      pc_deserr := '31002-(02) | Fecha de carga ingresada es diferente a la fecha de carga de los registros del archivo TMA.csv';
      return;
    end if;
    
  if pc_modo = 'C' then --Carga Normal --rcuadros 06/09/2023
    -- Valida fecha de carga
    if ld_MesCar < ld_MinMesCar then
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
    where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC315' and PARTITION_POSITION = (select max(PARTITION_POSITION) from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC315');

    if to_date(ld_MesCar, 'DD/MM/YYYY') > add_months(to_date(ld_lastPartDate, 'DD/MM/YYYY'), 1) then
      pc_coderr := '31005';
      pc_deserr := '31005-(05) | La fecha de carga no es válida';
      return;
    end if;
    -- Valida particion siguiente
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC315' and PARTITION_NAME = partcci_sig;
    
    if ln_Contad > 0 then
      pc_coderr := '31006';
      pc_deserr := '31006-(06) | No se puede cargar información anterior al último mes procesado';
      return;
    end if;
    -- Verifica si ya existe una partición previa, y si existe la borra
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC315' and PARTITION_NAME = partcci;

    if ln_Contad > 0 then
      begin
        execute immediate 'ALTER TABLE AQPC315 DROP PARTITION ' || partcci || ' UPDATE INDEXES';
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
              sys.sp_sy_enviamail(PC_DE      => 'mblas@cajaarequipa.pe',
                                  PC_AQUIEN  => 'mblas@cajaarequipa.pe',
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
      execute immediate 'ALTER TABLE AQPC315 ADD PARTITION ' || partcci ||
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
          sys.sp_sy_enviamail(PC_DE      => 'mblas@cajaarequipa.pe',
                              PC_AQUIEN  => 'mblas@cajaarequipa.pe',
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
      execute immediate 'ALTER TABLE AQPC315 MODIFY PARTITION ' || partcci ||
      ' UNUSABLE LOCAL INDEXES';
    exception
      when others then
        c_error := to_char(SQLCODE || ' - ' || SQLERRM);
        begin
          sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                              PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo inhabilitar los ìndices de la partición AQPC315' ||
                                            partcci || ' - ' ||
                                            sys_context('USERENV', 'DB_NAME'),
                              PC_MENSAJE => 'NO se pudo inhabilitar los ìndices de la partición ' ||
                                            partcci || CHR(13) || c_error);
        exception
          when others then
            null;
        end;
        begin
          sys.sp_sy_enviamail(PC_DE      => 'mblas@cajaarequipa.pe',
                              PC_AQUIEN  => 'mblas@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo inhabilitar los ìndices de la partición AQPC315' ||
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
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC315' and PARTITION_NAME = partcci_upd;
    
    if ln_Contad > 0 then
       begin
        execute immediate 'DELETE FROM AQPC315 PARTITION (' || partcci_upd || ')';
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
              sys.sp_sy_enviamail(PC_DE      => 'mblas@cajaarequipa.pe',
                                  PC_AQUIEN  => 'mblas@cajaarequipa.pe',
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

  execute immediate 'ALTER TABLE AQPC315 PARALLEL 10';
  -- Inserta registros
  begin
  -- Inserta AQPC315
  insert /*+append*/
  into aqpc315
    (aqpc315fecpro,
    aqpc315cta,
    aqpc315oper,
    aqpc315ase,
    aqpc315tippeq,
    aqpc315nomreg,
    aqpc315deszon,
    aqpc315scnom,
    aqpc315depart,
    aqpc315provin,
    aqpc315distri,
    aqpc315segmen,
    aqpc315ciiu,
    aqpc315descii,
    aqpc315modulo,
    aqpc315estado,
    aqpc315es_mod,
    aqpc315fechac,
    aqpc315tipsbs,
    aqpc315tasa,
    aqpc315desem,
    aqpc315venci,
    aqpc315codsbs,
    aqpc315mtdsso,
    aqpc315estdo2,
    aqpc315saldo0,
    aqpc315saldo1,
    aqpc315saldo2,
    aqpc315saldo3,
    aqpc315saldo4,
    aqpc315saldo5,
    aqpc315saldo6,
    aqpc315saldo7,
    aqpc315saldo8,
    aqpc315saldo9,
    aqpc315sald10,
    aqpc315sald11,
    aqpc315sald12,
    aqpc315ndia0,
    aqpc315ndia1,
    aqpc315ndia2,
    aqpc315ndia3,
    aqpc315ndia4,
    aqpc315ndia5,
    aqpc315ndia6,
    aqpc315ndia7,
    aqpc315ndia8,
    aqpc315ndia9,
    aqpc315ndia10,
    aqpc315ndia11,
    aqpc315ndia12,
    aqpc315cal0,
    aqpc315cal1,
    aqpc315cal2,
    aqpc315cal3,
    aqpc315cal4,
    aqpc315cal5,
    aqpc315cal6,
    aqpc315cal7,
    aqpc315cal8,
    aqpc315cal9,
    aqpc315cal10,
    aqpc315cal11,
    aqpc315cal12,
    aqpc315fecha,
    aqpc315cod1,
    aqpc315rangmo,
    aqpc315tipcr2,
    aqpc315caso12,
    aqpc315atrafi,
    aqpc315sldfn,
    aqpc315column,
    aqpc315catfin,
    aqpc315v2,
    aqpc315sldfin,
    aqpc315sldini,
    aqpc315catbas,
    aqpc315prini,
    aqpc315prvfin,
    aqpc315prvin1,
    aqpc315prvfi1,
    aqpc315flgrep)
  select /*+parallel(g,10)*/
    case when regexp_like(g.aqpc3151fecpro, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3151fecpro, 'DD/MM/YYYY') else null end,
    case when g.aqpc3151cta like '-%' then to_number(g.aqpc3151cta, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cta, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cta, '999999999.99999999999999999') else null end,
    case when g.aqpc3151oper like '-%' then to_number(g.aqpc3151oper, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151oper, '^\d+(\.\d+)?$') then to_number(g.aqpc3151oper, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3151ase, '"', '')),
    trim(replace(g.aqpc3151tippeq, '"', '')),
    trim(replace(g.aqpc3151nomreg, '"', '')),
    trim(replace(g.aqpc3151deszon, '"', '')),
    trim(replace(g.aqpc3151scnom, '"', '')),
    trim(replace(g.aqpc3151depart, '"', '')),
    trim(replace(g.aqpc3151provin, '"', '')),
    trim(replace(g.aqpc3151distri, '"', '')),
    trim(replace(g.aqpc3151segmen, '"', '')),
    case when g.aqpc3151ciiu like '-%' then to_number(g.aqpc3151ciiu, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ciiu, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ciiu, '999999999.99999999999999999') else null end,
    trim(replace(substr(g.aqpc3151descii, 1, 70), '"', '')),--excede el tamaño: original: 50 / real:70
    trim(replace(g.aqpc3151modulo, '"', '')),
    trim(replace(g.aqpc3151estado, '"', '')),
    trim(replace(g.aqpc3151es_mod, '"', '')),
    case when regexp_like(g.aqpc3151fechac, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3151fechac, 'DD/MM/YYYY') else null end,
    trim(replace(g.aqpc3151tipsbs, '""', '')),
    case when g.aqpc3151tasa like '-%' then to_number(g.aqpc3151tasa, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151tasa, '^\d+(\.\d+)?$') then to_number(g.aqpc3151tasa, '999999999.99999999999999999') else null end,
    case when regexp_like(g.aqpc3151desem, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3151desem, 'DD/MM/YYYY') else null end,
    case when regexp_like(g.aqpc3151venci, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3151venci, 'DD/MM/YYYY') else null end,
    case when g.aqpc3151codsbs like '-%' then to_number(g.aqpc3151codsbs, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151codsbs, '^\d+(\.\d+)?$') then to_number(g.aqpc3151codsbs, '999999999.99999999999999999') else null end,
    case when g.aqpc3151mtdsso like '-%' then to_number(g.aqpc3151mtdsso, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151mtdsso, '^\d+(\.\d+)?$') then to_number(g.aqpc3151mtdsso, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3151estdo2, '"', '')),
    case when g.aqpc3151saldo0 like '-%' then to_number(g.aqpc3151saldo0, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo0, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo0, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo1 like '-%' then to_number(g.aqpc3151saldo1, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo1, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo1, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo2 like '-%' then to_number(g.aqpc3151saldo2, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo2, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo2, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo3 like '-%' then to_number(g.aqpc3151saldo3, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo3, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo3, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo4 like '-%' then to_number(g.aqpc3151saldo4, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo4, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo4, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo5 like '-%' then to_number(g.aqpc3151saldo5, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo5, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo5, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo6 like '-%' then to_number(g.aqpc3151saldo6, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo6, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo6, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo7 like '-%' then to_number(g.aqpc3151saldo7, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo7, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo7, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo8 like '-%' then to_number(g.aqpc3151saldo8, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo8, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo8, '999999999.99999999999999999') else null end,
    case when g.aqpc3151saldo9 like '-%' then to_number(g.aqpc3151saldo9, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151saldo9, '^\d+(\.\d+)?$') then to_number(g.aqpc3151saldo9, '999999999.99999999999999999') else null end,
    case when g.aqpc3151sald10 like '-%' then to_number(g.aqpc3151sald10, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151sald10, '^\d+(\.\d+)?$') then to_number(g.aqpc3151sald10, '999999999.99999999999999999') else null end,
    case when g.aqpc3151sald11 like '-%' then to_number(g.aqpc3151sald11, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151sald11, '^\d+(\.\d+)?$') then to_number(g.aqpc3151sald11, '999999999.99999999999999999') else null end,
    case when g.aqpc3151sald12 like '-%' then to_number(g.aqpc3151sald12, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151sald12, '^\d+(\.\d+)?$') then to_number(g.aqpc3151sald12, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia0 like '-%' then to_number(g.aqpc3151ndia0, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia0, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia0, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia1 like '-%' then to_number(g.aqpc3151ndia1, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia1, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia1, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia2 like '-%' then to_number(g.aqpc3151ndia2, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia2, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia2, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia3 like '-%' then to_number(g.aqpc3151ndia3, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia3, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia3, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia4 like '-%' then to_number(g.aqpc3151ndia4, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia4, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia4, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia5 like '-%' then to_number(g.aqpc3151ndia5, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia5, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia5, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia6 like '-%' then to_number(g.aqpc3151ndia6, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia6, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia6, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia7 like '-%' then to_number(g.aqpc3151ndia7, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia7, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia7, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia8 like '-%' then to_number(g.aqpc3151ndia8, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia8, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia8, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia9 like '-%' then to_number(g.aqpc3151ndia9, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia9, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia9, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia10 like '-%' then to_number(g.aqpc3151ndia10, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia10, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia10, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia11 like '-%' then to_number(g.aqpc3151ndia11, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia11, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia11, '999999999.99999999999999999') else null end,
    case when g.aqpc3151ndia12 like '-%' then to_number(g.aqpc3151ndia12, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151ndia12, '^\d+(\.\d+)?$') then to_number(g.aqpc3151ndia12, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal0 like '-%' then to_number(g.aqpc3151cal0, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal0, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal0, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal1 like '-%' then to_number(g.aqpc3151cal1, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal1, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal1, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal2 like '-%' then to_number(g.aqpc3151cal2, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal2, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal2, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal3 like '-%' then to_number(g.aqpc3151cal3, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal3, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal3, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal4 like '-%' then to_number(g.aqpc3151cal4, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal4, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal4, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal5 like '-%' then to_number(g.aqpc3151cal5, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal5, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal5, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal6 like '-%' then to_number(g.aqpc3151cal6, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal6, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal6, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal7 like '-%' then to_number(g.aqpc3151cal7, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal7, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal7, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal8 like '-%' then to_number(g.aqpc3151cal8, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal8, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal8, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal9 like '-%' then to_number(g.aqpc3151cal9, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal9, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal9, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal10 like '-%' then to_number(g.aqpc3151cal10, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal10, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal10, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal11 like '-%' then to_number(g.aqpc3151cal11, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal11, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal11, '999999999.99999999999999999') else null end,
    case when g.aqpc3151cal12 like '-%' then to_number(g.aqpc3151cal12, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151cal12, '^\d+(\.\d+)?$') then to_number(g.aqpc3151cal12, '999999999.99999999999999999') else null end,
    case when regexp_like(g.aqpc3151fecha, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3151fecha, 'DD/MM/YYYY') else null end,
    trim(replace(g.aqpc3151cod1, '"', '')),
    trim(replace(g.aqpc3151rangmo, '"', '')),
    trim(replace(g.aqpc3151tipcr2, '"', '')),
    case when g.aqpc3151caso12 like '-%' then to_number(g.aqpc3151caso12, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151caso12, '^\d+(\.\d+)?$') then to_number(g.aqpc3151caso12, '999999999.99999999999999999') else null end,
    case when g.aqpc3151atrafi like '-%' then to_number(g.aqpc3151atrafi, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151atrafi, '^\d+(\.\d+)?$') then to_number(g.aqpc3151atrafi, '999999999.99999999999999999') else null end,
    case when g.aqpc3151sldfn like '-%' then to_number(g.aqpc3151sldfn, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151sldfn, '^\d+(\.\d+)?$') then to_number(g.aqpc3151sldfn, '999999999.99999999999999999') else null end,
    case when g.aqpc3151column like '-%' then to_number(g.aqpc3151column, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151column, '^\d+(\.\d+)?$') then to_number(g.aqpc3151column, '999999999.99999999999999999') else null end,
    case when g.aqpc3151catfin like '-%' then to_number(g.aqpc3151catfin, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151catfin, '^\d+(\.\d+)?$') then to_number(g.aqpc3151catfin, '999999999.99999999999999999') else null end,
    case when g.aqpc3151v2 like '-%' then to_number(g.aqpc3151v2, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151v2, '^\d+(\.\d+)?$') then to_number(g.aqpc3151v2, '999999999.99999999999999999') else null end,
    case when g.aqpc3151sldfin like '-%' then to_number(g.aqpc3151sldfin, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151sldfin, '^\d+(\.\d+)?$') then to_number(g.aqpc3151sldfin, '999999999.99999999999999999') else null end,
    case when g.aqpc3151sldini like '-%' then to_number(g.aqpc3151sldini, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151sldini, '^\d+(\.\d+)?$') then to_number(g.aqpc3151sldini, '999999999.99999999999999999') else null end,
    case when g.aqpc3151catbas like '-%' then to_number(g.aqpc3151catbas, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151catbas, '^\d+(\.\d+)?$') then to_number(g.aqpc3151catbas, '999999999.99999999999999999') else null end,
    case when g.aqpc3151prini like '-%' then to_number(g.aqpc3151prini, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151prini, '^\d+(\.\d+)?$') then to_number(g.aqpc3151prini, '999999999.99999999999999999') else null end,
    case when g.aqpc3151prvfin like '-%' then to_number(g.aqpc3151prvfin, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151prvfin, '^\d+(\.\d+)?$') then to_number(g.aqpc3151prvfin, '999999999.99999999999999999') else null end,
    case when g.aqpc3151prvin1 like '-%' then to_number(g.aqpc3151prvin1, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151prvin1, '^\d+(\.\d+)?$') then to_number(g.aqpc3151prvin1, '999999999.99999999999999999') else null end,
    case when g.aqpc3151prvfi1 like '-%' then to_number(g.aqpc3151prvfi1, 'S999999999.99999999999999999') when regexp_like(g.aqpc3151prvfi1, '^\d+(\.\d+)?$') then to_number(g.aqpc3151prvfi1, '999999999.99999999999999999') else null end,
    trim(replace(substr(g.aqpc3151flgrep, 1, 15), '"', ''))--excede el tamaño: original: 10 / real:15
  from aqpc3151 g;
  commit;
  exception
    when others then
	  execute immediate 'ALTER TABLE AQPC315 PARALLEL 1';
      c_error := to_char(SQLCODE || ' - ' || SQLERRM);
      pc_coderr := '31009';
      pc_deserr := '31009-(09) | No se pudieron insertar los registros';
      return;
  end;
  
  if pc_modo = 'C' then --Carga Normal --rcuadros 06/09/2023
    --Activa índices de partición
    begin
      execute immediate 'ALTER TABLE AQPC315 MODIFY PARTITION ' || partcci ||
      ' REBUILD UNUSABLE LOCAL INDEXES';
    exception
      when others then
        c_error := to_char(SQLCODE || ' - ' || SQLERRM);
        begin
          sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                              PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo habilitar los ìndices de la partición AQPC315' ||
                                            partcci || ' - ' ||
                                            sys_context('USERENV', 'DB_NAME'),
                              PC_MENSAJE => 'NO se pudo habilitar los ìndices de la partición ' ||
                                            partcci || CHR(13) || c_error);
        exception
          when others then
            null;
        end;
        begin
          sys.sp_sy_enviamail(PC_DE      => 'mblas@cajaarequipa.pe',
                              PC_AQUIEN  => 'mblas@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo habilitar los ìndices de la partición AQPC315' ||
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
  end if; --rcuadros 06/09/2023
  
  execute immediate 'ALTER TABLE AQPC315 PARALLEL 1';

  --Estadísticas
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPC315',
                                  degree           => 10,
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  partname         => partcci);
  end;
end SP_AR_INSERTA_RIESGOS_MH_AQPC315;
/

