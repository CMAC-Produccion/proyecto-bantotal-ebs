create or replace procedure SP_CR_TB_BDC01_AQPB879 is
begin
  --FSD010
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  begin
    execute immediate 'DROP TABLE AQPB879 PURGE';
  exception
    when others then
      null;
  end;
  execute immediate 'CREATE TABLE AQPB879 parallel (degree 8) nologging compress for archive low tablespace BANTPROD_BDC01 as '||
                    'SELECT  a.* FROM  FSD010 a';
  execute immediate 'alter TABLE AQPB879 parallel (degree 1) logging';

  execute immediate 'create unique index AQPB8791 on AQPB879
  (PGCOD, AOMOD, AOSUC, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP, AOTOPE) nologging COMPRESS ADVANCED HIGH
  PARALLEL 16 tablespace BANTPROD_BDC01_IDX';

  execute immediate 'alter index AQPB8791 logging noparallel';
  --11.2021
  execute immediate 'create index AQPB8792 on AQPB879
  (PGCOD, AOCTA, AOMOD) nologging COMPRESS ADVANCED HIGH PARALLEL 16 tablespace BANTPROD_BDC01_IDX';

  execute immediate 'alter index AQPB8792 logging noparallel';
    
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPB879',
                                  degree           => 40,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  
  --execute immediate 'grant select on AQPB879 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lllosa,LCARPIO_FUNC';
  begin
    execute immediate 'grant select, insert, update, delete on AQPB879 to ROL_SOPORTE_MESADEAYUDA';
    execute immediate 'grant select on AQPB879 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lcarpio_func,CEXLLOSA';
  exception
  when others then
    null;
  end;
  execute immediate 'create or replace public synonym AQPB879 for AQPB879';
  execute immediate 'alter PACKAGE PQ_DATOS_ACL COMPILE DEBUG';
  execute immediate 'alter PACKAGE PQ_DATOS_ACL COMPILE DEBUG BODY';

  --01.2022
  execute immediate 'comment on column AQPB879.pgcod    IS ''Cod.''';
  execute immediate 'comment on column AQPB879.aomod    IS ''Modulo''';
  execute immediate 'comment on column AQPB879.aosuc    IS ''Sucursal''';
  execute immediate 'comment on column AQPB879.aomda    IS ''Moneda''';
  execute immediate 'comment on column AQPB879.aopap    IS ''Papel''';
  execute immediate 'comment on column AQPB879.aocta    IS ''CTNRO''';
  execute immediate 'comment on column AQPB879.aooper   IS ''Operación''';
  execute immediate 'comment on column AQPB879.aosbop   IS ''Sub-operac.''';
  execute immediate 'comment on column AQPB879.aotope   IS ''Tipo operac.''';
  execute immediate 'comment on column AQPB879.aofval   IS ''Tasa Mora''';
  execute immediate 'comment on column AQPB879.aofvto   IS ''Días p/revisión de Tasa''';
  execute immediate 'comment on column AQPB879.aopzo    IS ''Fecha última revisación tasa''';
  execute immediate 'comment on column AQPB879.aottas   IS ''Numerador de eventos''';
  execute immediate 'comment on column AQPB879.aotasa   IS ''F/valor''';
  execute immediate 'comment on column AQPB879.aotmor   IS ''F/vto''';
  execute immediate 'comment on column AQPB879.aottac   IS ''Plazo''';
  execute immediate 'comment on column AQPB879.aotasc   IS ''Tipo de Tasa''';
  execute immediate 'comment on column AQPB879.aotdia   IS ''Tasa''';
  execute immediate 'comment on column AQPB879.aotvto   IS ''Tipo Tasa de Corte''';
  execute immediate 'comment on column AQPB879.aotano   IS ''Tasa de Corte''';
  execute immediate 'comment on column AQPB879.aotint   IS ''Tipo de días''';
  execute immediate 'comment on column AQPB879.aodrev   IS ''Tipo de ajuste en vencto.''';
  execute immediate 'comment on column AQPB879.aoimp    IS ''Tipo de ano''';
  execute immediate 'comment on column AQPB879.aopre    IS ''Tipo de cálculo de interés''';
  execute immediate 'comment on column AQPB879.aopre1   IS ''Importe''';
  execute immediate 'comment on column AQPB879.aotcbi   IS ''Precio''';
  execute immediate 'comment on column AQPB879.aotcbi1  IS ''Precio''';
  execute immediate 'comment on column AQPB879.aoarb    IS ''Aotcbi''';
  execute immediate 'comment on column AQPB879.aoarb1   IS ''Aotcbi1''';
  execute immediate 'comment on column AQPB879.aomd     IS ''Aoarb''';
  execute immediate 'comment on column AQPB879.aomd1    IS ''Aoarb1''';
  execute immediate 'comment on column AQPB879.aonume   IS ''Aomd''';
  execute immediate 'comment on column AQPB879.aofnum   IS ''Aomd1''';
  execute immediate 'comment on column AQPB879.aoafiv   IS ''Intereses al Vencimiento''';
  execute immediate 'comment on column AQPB879.aocbcu   IS ''Afectada por IVA?''';
  execute immediate 'comment on column AQPB879.aostat   IS ''Cod.actividad BCU''';
  execute immediate 'comment on column AQPB879.aoavis   IS ''Status''';
  execute immediate 'comment on column AQPB879.aoplus   IS ''Aviso (vto. etc..)''';
  execute immediate 'comment on column AQPB879.aoeven   IS ''Tasa Plus''';
  execute immediate 'comment on column AQPB879.aofe99   IS ''Fecha de baja''';
  execute immediate 'comment on column AQPB879.aocltcod IS ''Aocltcod''';
  execute immediate 'comment on column AQPB879.aoperiod IS ''Período (Itper)''';

end;
/

