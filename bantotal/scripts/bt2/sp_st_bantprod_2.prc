create or replace procedure SP_ST_BANTPROD_2 IS
    -- *****************************************************************
    -- Nombre                     : SP_ST_BANTPROD_2
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
  CURSOR C1 IS
    SELECT ROWID FILA, A.*
      FROM AQPD501 A
     WHERE A.APLICADO IS NULL
       and A.grupo = 2
       and table_name not in ('FPAE71','FSH016','JAQL546','FSH021','JAQL547','JAQL099','TI0019','JAQL357','FSH012','FSX016','fsi001','RNPE06','FSR008','FSH014','JAQL539')
     ORDER BY A.LAST_ANALYZED;

  LVCCAD VARCHAR2(2000);
BEGIN
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  FOR I IN C1 LOOP
    begin
      update AQPD501 set fecini = sysdate where rowid = I.FILA;
      commit;
        BEGIN
          DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                        TABNAME          => I.TABLE_NAME,
                                        DEGREE           => 40,
                                        GRANULARITY      => 'ALL',
                                        ESTIMATE_PERCENT => 100,
                                        CASCADE          => TRUE);
        END;
      UPDATE AQPD501
         SET APLICADO = 'S', fecfin = sysdate
       WHERE ROWID = I.FILA;
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
    select *
      from AQPD501
     where grupo = 2
       and table_name not in ('FPAE71',
                              'FSH016',
                              'JAQL546',
                              'FSH021',
                              'JAQL547',
                              'JAQL099',
                              'TI0019',
                              'JAQL357',
                              'FSH012',
                              'FSX016',
                              'RNPE06','FSR008','FSH014','JAQL539');
  commit;
END SP_ST_BANTPROD_2;
/

