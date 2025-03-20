create or replace procedure SP_CR_TB_BDC01_AQPB886 is
begin
  --FSD611
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  begin
    execute immediate 'DROP TABLE AQPB886 PURGE';
  exception
    when others then
      null;
  end;
  execute immediate 'CREATE TABLE AQPB886 parallel (degree 8) nologging compress for archive low tablespace BANTPROD_BDC01 as '||
                    'SELECT  a.* FROM  FSD611 a';
  execute immediate 'alter TABLE AQPB886 parallel (degree 1) logging';

  execute immediate 'create unique index AQPB886A2 on AQPB886
  (PGCOD, PPMOD, PPSUC, PPMDA, PPPAP, PPCTA, PPOPER, PPSBOP, PPTOPE, PPFPAG, PPTIPO, PPEXTE) nologging COMPRESS ADVANCED HIGH
  PARALLEL 8 tablespace BANTPROD_BDC01_IDX';

  execute immediate 'alter index AQPB886A2 logging noparallel';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPB886',
                                  degree           => 40,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;

--  execute immediate 'grant select on AQPB886 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lllosa,LCARPIO_FUNC';
  execute immediate 'grant select on AQPB886 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,LCARPIO_FUNC';
  execute immediate 'create or replace public synonym AQPB886 for AQPB886';

  execute immediate 'comment on table AQPB886 is    ''Tabla espejo de FSD611 para BDC01 fin de mes''';
  execute immediate 'comment on column AQPB886.pgcod is       ''Cod. Empresa''';
  execute immediate 'comment on column AQPB886.Ppmod is       ''Modulo''';
  execute immediate 'comment on column AQPB886.Ppsuc is       ''Sucurs''';
  execute immediate 'comment on column AQPB886.Ppmda is       ''Moneda''';
  execute immediate 'comment on column AQPB886.Pppap is       ''Papel''';
  execute immediate 'comment on column AQPB886.PPCTA is       ''CTNRO''';
  execute immediate 'comment on column AQPB886.PPOPER is       ''Operación''';
  execute immediate 'comment on column AQPB886.Ppsbop is       ''Suboperación''';
  execute immediate 'comment on column AQPB886.Pptope is       ''Tipo de operación''';
  execute immediate 'comment on column AQPB886.Ppfpag is       ''Fecha de pago prevista''';
  execute immediate 'comment on column AQPB886.Pptipo is       ''Tipo de cuota''';
  execute immediate 'comment on column AQPB886.Ppexte is       ''Ppexte''';
  execute immediate 'comment on column AQPB886.Ppimp1 is       ''Ppimp1''';
  execute immediate 'comment on column AQPB886.Ppimp2 is       ''Ppimp2''';
  execute immediate 'comment on column AQPB886.Ppimp3 is       ''Ppimp3''';
  execute immediate 'comment on column AQPB886.Ppimp4 is       ''Ppimp4''';
  execute immediate 'comment on column AQPB886.Ppimp5 is       ''Ppimp5''';
  execute immediate 'comment on column AQPB886.Ppimp6 is       ''Ppimp6''';
  execute immediate 'comment on column AQPB886.Ppimp7 is       ''Ppimp7''';
  execute immediate 'comment on column AQPB886.Ppimp8 is       ''Ppimp8''';
  execute immediate 'comment on column AQPB886.Ppimp9 is       ''Ppimp9''';
  execute immediate 'comment on column AQPB886.Ppimp10 is       ''Ppimp10''';
  execute immediate 'comment on column AQPB886.Ppimp11 is       ''Ppimp11''';
  execute immediate 'comment on column AQPB886.Ppimp12 is       ''Ppimp12''';
  execute immediate 'comment on column AQPB886.Ppimp13 is       ''Ppimp13''';
  execute immediate 'comment on column AQPB886.Ppimp14 is       ''Ppimp14''';
  execute immediate 'comment on column AQPB886.Ppimp15 is       ''Ppimp15''';
  execute immediate 'comment on column AQPB886.Ppimp16 is       ''Ppimp16''';
  execute immediate 'comment on column AQPB886.Ppimp17 is       ''Ppimp17''';
  execute immediate 'comment on column AQPB886.Ppimp18 is       ''Ppimp18''';
  execute immediate 'comment on column AQPB886.Ppimp19 is       ''Ppimp19''';
  execute immediate 'comment on column AQPB886.Ppimp20 is       ''Ppimp20''';
end;
/

