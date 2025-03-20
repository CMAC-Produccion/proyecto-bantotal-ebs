create or replace procedure SP_ST_BANTPROD_1 IS
    -- *****************************************************************
    -- Nombre                     : SP_ST_BANTPROD_1
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
  CURSOR C0 IS
    SELECT ROWID FILA, A.*
      FROM AQPD501 A
     where rownum<3801;
  CURSOR C1 IS
    SELECT ROWID FILA, A.*
      FROM AQPD501 A
     WHERE A.APLICADO IS NULL and A.grupo=1
       and table_name not in ('FPAE71','FSH016','JAQL546','FSH021','JAQL547','JAQL099','TI0019','JAQL357','FSH012','FSX016','fsi001','RNPE06','FSR008','FSH014','JAQL539')
     ORDER BY A.LAST_ANALYZED;

  LVCCAD VARCHAR2(2000);
BEGIN
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  delete AQPD501;
  commit;

  insert into AQPD501
  select owner, table_name, tablespace_name, num_rows, last_analyzed, trunc(sysdate) fecha, null aplicado, null fecini, null fecfin, null grupo,
  cluster_name, iot_name, status, pct_free, pct_used, ini_trans, max_trans, initial_extent, next_extent, min_extents, max_extents,
  pct_increase, freelists, freelist_groups, logging, backed_up, blocks, empty_blocks, avg_space, chain_cnt, avg_row_len, avg_space_freelist_blocks,
  num_freelist_blocks, degree, instances, cache, table_lock, sample_size, partitioned, iot_type, temporary, secondary, nested,
  buffer_pool, flash_cache, cell_flash_cache, row_movement, global_stats, user_stats, duration, skip_corrupt, monitoring, cluster_owner,
  dependencies, compression, compress_for, dropped, read_only, segment_created, result_cache
  from dba_tables a
  where a.owner='BANTPROD' and a.temporary='N'
  order by a.last_analyzed;
  commit;

  FOR I IN C0 LOOP
    update AQPD501
       set grupo=1
     where rowid=I.FILA;
    commit;
  end loop;

  update AQPD501
     set grupo=2
   where grupo is null;
  commit;

  FOR I IN C1 LOOP
    begin
      update AQPD501
         set fecini=sysdate
       where rowid=I.FILA;
      commit;
        BEGIN
          DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                        TABNAME          => I.TABLE_NAME,
                                        DEGREE           => 40,
                                        GRANULARITY      => 'ALL',
                                        ESTIMATE_PERCENT => 100,
                                        CASCADE          => TRUE);
        END;
      UPDATE AQPD501 SET APLICADO = 'S',fecfin=sysdate WHERE ROWID = I.FILA;
      COMMIT;
    exception
      when others then
        LVCCAD := TO_CHAR(SQLCODE||' - '||SQLERRM);
        UPDATE AQPD501
           SET APLICADO = 'E', iot_name=LVCCAD, fecfin = sysdate
         WHERE ROWID = I.FILA;
        COMMIT;
    end;
  END LOOP;
  insert into AQPD501h
  select * from AQPD501 where grupo=1
  and table_name not in ('FPAE71','FSH016','JAQL546','FSH021','JAQL547','JAQL099','TI0019','JAQL357','FSH012','FSX016','RNPE06','FSR008','FSH014','JAQL539');
  commit;
END SP_ST_BANTPROD_1;
/

