create or replace procedure SP_CR_TB_BDC01_AQPB877 is
begin
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  --FSD601
  begin
    execute immediate 'DROP TABLE AQPB877 PURGE';
  exception
    when others then
      null;
  end;
  execute immediate 'CREATE TABLE AQPB877 parallel (degree 8) nologging compress for archive low tablespace BANTPROD_BDC01 as ' ||
                    'SELECT  a.* FROM  FSD601 a';
  execute immediate 'alter TABLE AQPB877 parallel (degree 1) logging';

  execute immediate 'create unique index AQPB8771 on AQPB877
  (PGCOD, PPMOD, PPSUC, PPMDA, PPPAP, PPCTA, PPOPER, PPSBOP, PPTOPE, PPFPAG, PPTIPO) nologging COMPRESS ADVANCED HIGH
  PARALLEL 16 tablespace BANTPROD_BDC01_IDX';
  execute immediate 'alter index AQPB8771 logging noparallel';

  --11.2021
  execute immediate 'create index AQPB8772 on AQPB877 (PGCOD, PPCTA) nologging COMPRESS ADVANCED HIGH
  PARALLEL 16 tablespace BANTPROD_BDC01_IDX';
  execute immediate 'alter index AQPB8772 logging noparallel';

  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPB877',
                                  degree           => 40,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  begin
    execute immediate 'grant select, insert, update, delete on AQPB877 to ROL_SOPORTE_MESADEAYUDA';
--    execute immediate 'grant select on AQPB877 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lcarpio_func,RMEZA_ANX,JSAAVEDRA_ANX,AMANRIQUEL_ANX,WGASTELU_ANX,CEXLLOSA';
    execute immediate 'grant select on AQPB877 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lcarpio_func,RMEZA_ANX,CEXLLOSA';
  exception
  when others then
    null;
  end;
  execute immediate 'create or replace public synonym AQPB877 for AQPB877';
  execute immediate 'alter PACKAGE PQ_DATOS_ACL COMPILE DEBUG';
  execute immediate 'alter PACKAGE PQ_DATOS_ACL COMPILE DEBUG BODY';
  --01.2022
  execute immediate 'comment on table AQPB877 is    ''Tabla espejo de FSD601 para BDC01 fin de mes''';
  execute immediate 'comment on column AQPB877.pgcod is    ''Cod.''';
  execute immediate 'comment on column AQPB877.ppmod is    ''Modulo''';
  execute immediate 'comment on column AQPB877.ppsuc is    ''Sucurs''';
  execute immediate 'comment on column AQPB877.ppmda is    ''Moneda''';
  execute immediate 'comment on column AQPB877.pppap is    ''Papel''';
  execute immediate 'comment on column AQPB877.ppcta is    ''Ctnro''';
  execute immediate 'comment on column AQPB877.ppoper is   ''Operación''';
  execute immediate 'comment on column AQPB877.ppsbop is   ''Suboperación''';
  execute immediate 'comment on column AQPB877.pptope is   ''Tipo de operación''';
  execute immediate 'comment on column AQPB877.ppfpag is   ''Fecha de pago prevista''';
  execute immediate 'comment on column AQPB877.pptipo is   ''Tipo de cuota''';
  execute immediate 'comment on column AQPB877.ppfval is   ''Desde fecha''';
  execute immediate 'comment on column AQPB877.ppfvto is   ''Hasta fecha''';
  execute immediate 'comment on column AQPB877.pppzo is    ''Plazo de la cuota''';
  execute immediate 'comment on column AQPB877.ppcap is    ''Capital de la cuota''';
  execute immediate 'comment on column AQPB877.ppint is    ''Interés de la cuota''';
  execute immediate 'comment on column AQPB877.ppintmex is ''Interés p/impuesto Mex.''';
  execute immediate 'comment on column AQPB877.ppicap is   ''Impuesto sobre capital''';
  execute immediate 'comment on column AQPB877.ppiint is   ''Impuesto sobre interés''';
  execute immediate 'comment on column AQPB877.ppstat is   ''Estado de la cuota''';
  execute immediate 'comment on column AQPB877.ppnume is   ''Numerador de pagos a la cuota''';
  execute immediate 'comment on column AQPB877.ppfinv is   ''Fecha de pago inversa''';
  execute immediate 'comment on column AQPB877.d601cd is   ''D601cd''';
  execute immediate 'comment on column AQPB877.d601mo is   ''D601mo''';
  execute immediate 'comment on column AQPB877.d601su is   ''D601su''';
  execute immediate 'comment on column AQPB877.d601tr is   ''D601tr''';
  execute immediate 'comment on column AQPB877.d601re is   ''D601re''';
  execute immediate 'comment on column AQPB877.d601fc is   ''D601fc''';
  execute immediate 'comment on column AQPB877.d601or is   ''D601or''';
  execute immediate 'comment on column AQPB877.d601sb is   ''D601sb''';
  execute immediate 'comment on column AQPB877.d601co is   ''D601co''';
end;
/

