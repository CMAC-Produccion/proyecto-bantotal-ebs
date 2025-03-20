CREATE OR REPLACE PROCEDURE SP_AR_INSERTA_RIESGOS_MH_AQPC314(pd_fecfmes date, pc_modo varchar2, pc_coderr out varchar2, pc_deserr out varchar2) is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : SP_AR_INSERTA_RIESGOS_MH_AQPC314
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
  partcci     := 'AQPC314_' || mes || anio;
  fec_part    := to_char(pd_fecfmes + 1, 'YYYY-MM-DD'); --para fecha límite de partición
  ld_MesAct   := TO_DATE('01/' || to_char(sysdate, 'MM/YYYY'), 'DD/MM/YYYY');
  ld_MesCar   := TO_DATE('01/' || to_char(pd_fecfmes, 'MM/YYYY'), 'DD/MM/YYYY');
  partcci_sig := 'AQPC314_' || to_char(ADD_MONTHS(pd_fecfmes, 1), 'MMRRRR');
  ld_MinMesCar := TO_DATE('01/01/2021', 'DD/MM/YYYY');
  partcci_upd  := 'AQPC314_' || to_char(pd_fecfmes, 'MMRRRR'); --rcuadros 06/09/2023
  
  -- Verifica que la fecha de carga corresponda a la fecha de los registros de la tabla temporal
  begin
    select to_date(aqpc3141fecpro, 'DD/MM/YYYY') into ld_FecCar from aqpc3141 WHERE rownum <= 1;
  exception
    when others then
      pc_coderr := '31001';
      pc_deserr := '31001-(01) | No hay datos para cargar en el archivo Migra.csv';
      return;
  end;
  
  if ld_FecCar <> pd_fecfmes then
    pc_coderr := '31002';
    pc_deserr := '31002-(02) | Fecha de carga ingresada es diferente a la fecha de carga de los registros del archivo Migra.csv';
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
    where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC314' and PARTITION_POSITION = (select max(PARTITION_POSITION) from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC314');

    if to_date(ld_MesCar, 'DD/MM/YYYY') > add_months(to_date(ld_lastPartDate, 'DD/MM/YYYY'), 1) then
      pc_coderr := '31005';
      pc_deserr := '31005-(05) | La fecha de carga no es válida';
      return;
    end if;
    -- Valida particion siguiente
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC314' and PARTITION_NAME = partcci_sig;
    
    if ln_Contad > 0 then
      pc_coderr := '31006';
      pc_deserr := '31006-(06) | No se puede cargar información anterior al último mes procesado';
      return;
    end if;
    -- Verifica si ya existe una partición previa, y si existe la borra
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC314' and PARTITION_NAME = partcci;

    if ln_Contad > 0 then
      begin
        execute immediate 'ALTER TABLE AQPC314 DROP PARTITION ' || partcci || ' UPDATE INDEXES';
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
      execute immediate 'ALTER TABLE AQPC314 ADD PARTITION ' || partcci ||
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
      execute immediate 'ALTER TABLE AQPC314 MODIFY PARTITION ' || partcci ||
      ' UNUSABLE LOCAL INDEXES';
    exception
      when others then
        c_error := to_char(SQLCODE || ' - ' || SQLERRM);
        begin
          sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                              PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                              PC_MOTIVO  => 'NO se pudo inhabilitar los ìndices de la partición AQPC314' ||
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
                              PC_MOTIVO  => 'NO se pudo inhabilitar los ìndices de la partición AQPC314' ||
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
    select count(*) into ln_Contad from DBA_TAB_PARTITIONS where TABLE_OWNER = 'BANTPROD' and TABLE_NAME = 'AQPC314' and PARTITION_NAME = partcci_upd;
    
    if ln_Contad > 0 then
       begin
        execute immediate 'DELETE FROM AQPC314 PARTITION (' || partcci_upd || ')';
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

  execute immediate 'ALTER TABLE AQPC314 PARALLEL 10';
  -- Inserta registros
  begin
  -- Inserta AQPC314
  insert /*+append*/
  into aqpc314
    (aqpc314fecpro,
    aqpc314bccta,
    aqpc314bcoper,
    aqpc314region,
    aqpc314nomreg,
    aqpc314codzon,
    aqpc314deszon,
    aqpc314bcsuc,
    aqpc314sucrsl,
    aqpc314bcmda,
    aqpc314pepais,
    aqpc314petdoc,
    aqpc314pendoc,
    aqpc314penom,
    aqpc314fcdsbs,
    aqpc314fciu,
    aqpc314fciuco,
    aqpc314sctciu,
    aqpc314fnciud,
    aqpc314dpto,
    aqpc314flglur,
    aqpc314mod,
    aqpc314desmod,
    aqpc314segcli,
    aqpc314cat2,
    aqpc314cat6,
    aqpc314cat8,
    aqpc314cat,
    aqpc314cat5,
    aqpc314catal,
    aqpc314diatr,
    aqpc314tipsbs,
    aqpc314sldven,
    aqpc314sldjud,
    aqpc314sldref,
    aqpc314sldnor,
    aqpc314sldcas,
    aqpc314prvsob,
    aqpc314prvesp,
    aqpc314prvobl,
    aqpc314prvcoc,
    aqpc314prvcoi,
    aqpc314diferi,
    aqpc314cuota,
    aqpc314cuopen,
    aqpc314cuopag,
    aqpc314bcfval,
    aqpc314scradm,
    aqpc314scrseg,
    aqpc314pdadmi,
    aqpc314pdsegu,
    aqpc314flglu,
    aqpc314mo,
    aqpc314desmo,
    aqpc314segcl,
    aqpc314ct2,
    aqpc314ct6,
    aqpc314ct8,
    aqpc314ct,
    aqpc314ct5,
    aqpc314cata,
    aqpc314diat,
    aqpc314tipsb,
    aqpc314sldove,
    aqpc314sldoju,
    aqpc314sldore,
    aqpc314sldono,
    aqpc314sldoca,
    aqpc314sldov,
    aqpc314prvso,
    aqpc314prves,
    aqpc314prvob,
    aqpc314prvcvc,
    aqpc314prvci,
    aqpc314cndona,
    aqpc314difer,
    aqpc314cuot,
    aqpc314cuope,
    aqpc314cuopa,
    aqpc314bcfva,
    aqpc314scrad,
    aqpc314scrse,
    aqpc314pdadm,
    aqpc314pdseg,
    aqpc314modori,
    aqpc314dsmdor,
    aqpc314anlsta,
    aqpc314fecdes,
    aqpc314crtpex,
    aqpc314codefi,
    aqpc314tipo,
    aqpc314cobert,
    aqpc314saldoi,
    aqpc314saldoh,
    aqpc314saldo,
    aqpc314saldo1,
    aqpc314saldon,
    aqpc314provto,
    aqpc314provt1,
    aqpc314provsa,
    aqpc314provsn,
    aqpc314porcsi,
    aqpc314prvsoc,
    aqpc314prvesc,
    aqpc314prvobc,
    aqpc314tipon1,
    aqpc314prvccc,
    aqpc314tipon2,
    aqpc314dvngds,
    aqpc314prvcic,
    aqpc314tipogf,
    aqpc314gasmsf,
    aqpc314gsmssc,
    aqpc314grurpr,
    aqpc314tramot,
    aqpc314tramt1,
    aqpc314flgrpr)
  select /*+parallel(g,10)*/
    case when regexp_like(g.aqpc3141fecpro, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3141fecpro, 'DD/MM/YYYY') else null end,
    case when g.aqpc3141bccta like '-%' then to_number(g.aqpc3141bccta, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141bccta, '^\d+(\.\d+)?$') then to_number(g.aqpc3141bccta, '999999999.99999999999999999') else null end,
    case when g.aqpc3141bcoper like '-%' then to_number(g.aqpc3141bcoper, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141bcoper, '^\d+(\.\d+)?$') then to_number(g.aqpc3141bcoper, '999999999.99999999999999999') else null end,
    case when g.aqpc3141region like '-%' then to_number(g.aqpc3141region, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141region, '^\d+(\.\d+)?$') then to_number(g.aqpc3141region, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141nomreg, '"', '')),
    case when g.aqpc3141codzon like '-%' then to_number(g.aqpc3141codzon, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141codzon, '^\d+(\.\d+)?$') then to_number(g.aqpc3141codzon, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141deszon, '"', '')),
    case when g.aqpc3141bcsuc like '-%' then to_number(g.aqpc3141bcsuc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141bcsuc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141bcsuc, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141sucrsl, '"', '')),
    case when g.aqpc3141bcmda like '-%' then to_number(g.aqpc3141bcmda, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141bcmda, '^\d+(\.\d+)?$') then to_number(g.aqpc3141bcmda, '999999999.99999999999999999') else null end,
    case when g.aqpc3141pepais like '-%' then to_number(g.aqpc3141pepais, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141pepais, '^\d+(\.\d+)?$') then to_number(g.aqpc3141pepais, '999999999.99999999999999999') else null end,
    case when g.aqpc3141petdoc like '-%' then to_number(g.aqpc3141petdoc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141petdoc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141petdoc, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141pendoc, '"', '')),
    trim(replace(g.aqpc3141penom, '"', '')),
    case when g.aqpc3141fcdsbs like '-%' then to_number(g.aqpc3141fcdsbs, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141fcdsbs, '^\d+(\.\d+)?$') then to_number(g.aqpc3141fcdsbs, '999999999.99999999999999999') else null end,
    case when g.aqpc3141fciu like '-%' then to_number(g.aqpc3141fciu, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141fciu, '^\d+(\.\d+)?$') then to_number(g.aqpc3141fciu, '999999999.99999999999999999') else null end,
    case when g.aqpc3141fciuco like '-%' and not regexp_like(g.aqpc3141fciuco, '^-?\d+(\.\d+)?[eE][+-]?\d+$') then to_number(g.aqpc3141sldove, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141fciuco, '^\d+(\.\d+)?$') then to_number(g.aqpc3141fciuco, 'FM9999999999999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141sctciu, '"', '')),
    trim(replace(g.aqpc3141fnciud, '"', '')),
    trim(replace(g.aqpc3141dpto, '"', '')),
    trim(replace(g.aqpc3141flglur, '"', '')),
    case when g.aqpc3141mod like '-%' then to_number(g.aqpc3141mod, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141mod, '^\d+(\.\d+)?$') then to_number(g.aqpc3141mod, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141desmod, '"', '')),
    trim(replace(g.aqpc3141segcli, '"', '')),
    trim(replace(g.aqpc3141cat2, '"', '')),
    trim(replace(g.aqpc3141cat6, '"', '')),
    trim(replace(g.aqpc3141cat8, '"', '')),
    trim(replace(g.aqpc3141cat, '"', '')),
    trim(replace(g.aqpc3141cat5, '"', '')),
    trim(replace(g.aqpc3141catal, '"', '')),
    case when g.aqpc3141diatr like '-%' then to_number(g.aqpc3141diatr, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141diatr, '^\d+(\.\d+)?$') then to_number(g.aqpc3141diatr, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141tipsbs, '"', '')),
    case when g.aqpc3141sldven like '-%' and not regexp_like(g.aqpc3141sldven, '^-?\d+(\.\d+)?[eE][+-]?\d+$') then to_number(g.aqpc3141sldven, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldven, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldven, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldjud like '-%' then to_number(g.aqpc3141sldjud, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldjud, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldjud, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldref like '-%' then to_number(g.aqpc3141sldref, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldref, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldref, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldnor like '-%' and not regexp_like(g.aqpc3141sldnor, '^-?\d+(\.\d+)?[eE][+-]?\d+$') then to_number(g.aqpc3141sldnor, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldnor, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldnor, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldcas like '-%' then to_number(g.aqpc3141sldcas, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldcas, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldcas, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvsob like '-%' then to_number(g.aqpc3141prvsob, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvsob, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvsob, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvesp like '-%' then to_number(g.aqpc3141prvesp, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvesp, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvesp, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvobl like '-%' then to_number(g.aqpc3141prvobl, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvobl, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvobl, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvcoc like '-%' then to_number(g.aqpc3141prvcoc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvcoc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvcoc, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvcoi like '-%' then to_number(g.aqpc3141prvcoi, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvcoi, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvcoi, '999999999.99999999999999999') else null end,
    case when g.aqpc3141diferi like '-%' then to_number(g.aqpc3141diferi, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141diferi, '^\d+(\.\d+)?$') then to_number(g.aqpc3141diferi, '999999999.99999999999999999') else null end,
    case when g.aqpc3141cuota like '-%' then to_number(g.aqpc3141cuota, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141cuota, '^\d+(\.\d+)?$') then to_number(g.aqpc3141cuota, '999999999.99999999999999999') else null end,
    case when g.aqpc3141cuopen like '-%' then to_number(g.aqpc3141cuopen, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141cuopen, '^\d+(\.\d+)?$') then to_number(g.aqpc3141cuopen, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141cuopag, '"', '')),
    case when regexp_like(g.aqpc3141bcfval, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3141bcfval, 'DD/MM/YYYY') else null end,
    trim(replace(g.aqpc3141scradm, '"', '')),
    trim(replace(g.aqpc3141scrseg, '"', '')),
    case when g.aqpc3141pdadmi like '-%' then to_number(g.aqpc3141pdadmi, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141pdadmi, '^\d+(\.\d+)?$') then to_number(g.aqpc3141pdadmi, '999999999.99999999999999999') else null end,
    case when g.aqpc3141pdsegu like '-%' then to_number(g.aqpc3141pdsegu, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141pdsegu, '^\d+(\.\d+)?$') then to_number(g.aqpc3141pdsegu, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141flglu, '"', '')),
    case when g.aqpc3141mo like '-%' then to_number(g.aqpc3141mo, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141mo, '^\d+(\.\d+)?$') then to_number(g.aqpc3141mo, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141desmo, '"', '')),
    trim(replace(g.aqpc3141segcl, '"', '')),
    trim(replace(g.aqpc3141ct2, '"', '')),
    trim(replace(g.aqpc3141ct6, '"', '')),
    trim(replace(g.aqpc3141ct8, '"', '')),
    trim(replace(g.aqpc3141ct, '"', '')),
    trim(replace(g.aqpc3141ct5, '"', '')),
    trim(replace(g.aqpc3141cata, '"', '')),
    case when g.aqpc3141diat like '-%' then to_number(g.aqpc3141diat, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141diat, '^\d+(\.\d+)?$') then to_number(g.aqpc3141diat, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141tipsb, '"', '')),
    case when g.aqpc3141sldove like '-%' and not regexp_like(g.aqpc3141sldove, '^-?\d+(\.\d+)?[eE][+-]?\d+$') then to_number(g.aqpc3141sldove, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldove, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldove, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldoju like '-%' then to_number(g.aqpc3141sldoju, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldoju, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldoju, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldore like '-%' then to_number(g.aqpc3141sldore, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldore, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldore, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldono like '-%' and not regexp_like(g.aqpc3141sldono, '^-?\d+(\.\d+)?[eE][+-]?\d+$') then to_number(g.aqpc3141sldono, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldono, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldono, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldoca like '-%' then to_number(g.aqpc3141sldoca, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldoca, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldoca, '999999999.99999999999999999') else null end,
    case when g.aqpc3141sldov like '-%' then to_number(g.aqpc3141sldov, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141sldov, '^\d+(\.\d+)?$') then to_number(g.aqpc3141sldov, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvso like '-%' then to_number(g.aqpc3141prvso, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvso, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvso, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prves like '-%' then to_number(g.aqpc3141prves, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prves, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prves, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvob like '-%' then to_number(g.aqpc3141prvob, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvob, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvob, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvcvc like '-%' then to_number(g.aqpc3141prvcvc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvcvc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvcvc, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvci like '-%' then to_number(g.aqpc3141prvci, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvci, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvci, '999999999.99999999999999999') else null end,
    case when g.aqpc3141cndona like '-%' then to_number(g.aqpc3141cndona, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141cndona, '^\d+(\.\d+)?$') then to_number(g.aqpc3141cndona, '999999999.99999999999999999') else null end,
    case when g.aqpc3141difer like '-%' then to_number(g.aqpc3141difer, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141difer, '^\d+(\.\d+)?$') then to_number(g.aqpc3141difer, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141cuot, '"', '')),
    trim(replace(g.aqpc3141cuope, '"', '')),
    trim(replace(g.aqpc3141cuopa, '"', '')),
    trim(replace(g.aqpc3141bcfva, '"', '')),
    trim(replace(g.aqpc3141scrad, '"', '')),
    trim(replace(g.aqpc3141scrse, '"', '')),
    case when g.aqpc3141pdadm like '-%' then to_number(g.aqpc3141pdadm, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141pdadm, '^\d+(\.\d+)?$') then to_number(g.aqpc3141pdadm, '999999999.99999999999999999') else null end,
    case when g.aqpc3141pdseg like '-%' then to_number(g.aqpc3141pdseg, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141pdseg, '^\d+(\.\d+)?$') then to_number(g.aqpc3141pdseg, '999999999.99999999999999999') else null end,
    case when g.aqpc3141modori like '-%' then to_number(g.aqpc3141modori, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141modori, '^\d+(\.\d+)?$') then to_number(g.aqpc3141modori, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141dsmdor, '"', '')),
    trim(replace(g.aqpc3141anlsta, '"', '')),
    case when regexp_like(g.aqpc3141fecdes, '^(\d{2})/(\d{2})/(\d{4})$') then to_date(g.aqpc3141fecdes, 'DD/MM/YYYY') else null end,
    trim(replace(g.aqpc3141crtpex, '"', '')),
    trim(replace(g.aqpc3141codefi, '"', '')),
    trim(replace(g.aqpc3141tipo, '"', '')),
    case when g.aqpc3141cobert like '-%' then to_number(g.aqpc3141cobert, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141cobert, '^\d+(\.\d+)?$') then to_number(g.aqpc3141cobert, '999999999.99999999999999999') else null end,
    case when g.aqpc3141saldoi like '-%' then to_number(g.aqpc3141saldoi, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141saldoi, '^\d+(\.\d+)?$') then to_number(g.aqpc3141saldoi, '999999999.99999999999999999') else null end,
    case when g.aqpc3141saldoh like '-%' then to_number(g.aqpc3141saldoh, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141saldoh, '^\d+(\.\d+)?$') then to_number(g.aqpc3141saldoh, '999999999.99999999999999999') else null end,
    case when g.aqpc3141saldo like '-%' then to_number(g.aqpc3141saldo, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141saldo, '^\d+(\.\d+)?$') then to_number(g.aqpc3141saldo, '999999999.99999999999999999') else null end,
    case when g.aqpc3141saldo1 like '-%' then to_number(g.aqpc3141saldo1, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141saldo1, '^\d+(\.\d+)?$') then to_number(g.aqpc3141saldo1, '999999999.99999999999999999') else null end,
    case when g.aqpc3141saldon like '-%' then to_number(g.aqpc3141saldon, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141saldon, '^\d+(\.\d+)?$') then to_number(g.aqpc3141saldon, '999999999.99999999999999999') else null end,
    case when g.aqpc3141provto like '-%' then to_number(g.aqpc3141provto, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141provto, '^\d+(\.\d+)?$') then to_number(g.aqpc3141provto, '999999999.99999999999999999') else null end,
    case when g.aqpc3141provt1 like '-%' then to_number(g.aqpc3141provt1, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141provt1, '^\d+(\.\d+)?$') then to_number(g.aqpc3141provt1, '999999999.99999999999999999') else null end,
    case when g.aqpc3141provsa like '-%' then to_number(g.aqpc3141provsa, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141provsa, '^\d+(\.\d+)?$') then to_number(g.aqpc3141provsa, '999999999.99999999999999999') else null end,
    case when g.aqpc3141provsn like '-%' then to_number(g.aqpc3141provsn, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141provsn, '^\d+(\.\d+)?$') then to_number(g.aqpc3141provsn, '999999999.99999999999999999') else null end,
    case when g.aqpc3141porcsi like '-%' then to_number(g.aqpc3141porcsi, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141porcsi, '^\d+(\.\d+)?$') then to_number(g.aqpc3141porcsi, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvsoc like '-%' then to_number(g.aqpc3141prvsoc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvsoc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvsoc, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvesc like '-%' then to_number(g.aqpc3141prvesc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvesc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvesc, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvobc like '-%' then to_number(g.aqpc3141prvobc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvobc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvobc, '999999999.99999999999999999') else null end,
    case when g.aqpc3141tipon1 like '-%' then to_number(g.aqpc3141tipon1, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141tipon1, '^\d+(\.\d+)?$') then to_number(g.aqpc3141tipon1, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvccc like '-%' then to_number(g.aqpc3141prvccc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvccc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvccc, '999999999.99999999999999999') else null end,
    case when g.aqpc3141tipon2 like '-%' then to_number(g.aqpc3141tipon2, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141tipon2, '^\d+(\.\d+)?$') then to_number(g.aqpc3141tipon2, '999999999.99999999999999999') else null end,
    case when g.aqpc3141dvngds like '-%' then to_number(g.aqpc3141dvngds, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141dvngds, '^\d+(\.\d+)?$') then to_number(g.aqpc3141dvngds, '999999999.99999999999999999') else null end,
    case when g.aqpc3141prvcic like '-%' then to_number(g.aqpc3141prvcic, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141prvcic, '^\d+(\.\d+)?$') then to_number(g.aqpc3141prvcic, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141tipogf, '"', '')),
    case when g.aqpc3141gasmsf like '-%' then to_number(g.aqpc3141gasmsf, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141gasmsf, '^\d+(\.\d+)?$') then to_number(g.aqpc3141gasmsf, '999999999.99999999999999999') else null end,
    case when g.aqpc3141gsmssc like '-%' then to_number(g.aqpc3141gsmssc, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141gsmssc, '^\d+(\.\d+)?$') then to_number(g.aqpc3141gsmssc, '999999999.99999999999999999') else null end,
    case when g.aqpc3141grurpr like '-%' then to_number(g.aqpc3141grurpr, 'S999999999.99999999999999999') when regexp_like(g.aqpc3141grurpr, '^\d+(\.\d+)?$') then to_number(g.aqpc3141grurpr, '999999999.99999999999999999') else null end,
    trim(replace(g.aqpc3141tramot, '"', '')),
    trim(replace(g.aqpc3141tramt1, '"', '')),
    trim(replace(g.aqpc3141flgrpr, '"', ''))
  from aqpc3141 g;
  commit;
  exception
    when others then
	  execute immediate 'ALTER TABLE AQPC314 PARALLEL 1';
      c_error := to_char(SQLCODE || ' - ' || SQLERRM);
      pc_coderr := '31009';
      pc_deserr := '31009-(09) | No se pudieron insertar los registros';
      return;
  end;
  --Activa índices de partición
  begin
    execute immediate 'ALTER TABLE AQPC314 MODIFY PARTITION ' || partcci ||
    ' REBUILD UNUSABLE LOCAL INDEXES';
  exception
    when others then
      c_error := to_char(SQLCODE || ' - ' || SQLERRM);
      begin
        sys.sp_sy_enviamail(PC_DE      => 'ehidalgom@cajaarequipa.pe',
                            PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                            PC_MOTIVO  => 'NO se pudo habilitar los ìndices de la partición AQPC314' ||
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
                            PC_MOTIVO  => 'NO se pudo habilitar los ìndices de la partición AQPC314' ||
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

  execute immediate 'ALTER TABLE AQPC314 PARALLEL 1';

  --Estadísticas
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPC314',
                                  degree           => 10,
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  partname         => partcci);
  end;
end SP_AR_INSERTA_RIESGOS_MH_AQPC314;
/

