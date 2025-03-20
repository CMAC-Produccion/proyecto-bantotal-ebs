create or replace procedure SP_CR_TB_BDC01_AQPB887 is
begin
  --FSD612
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  begin
    execute immediate 'DROP TABLE AQPB887 PURGE';
  exception
    when others then
      null;
  end;
  execute immediate 'CREATE TABLE AQPB887 parallel (degree 8) nologging compress for archive low tablespace BANTPROD_BDC01 as '||
                    'SELECT  a.* FROM  FSD612 a';
  execute immediate 'alter TABLE AQPB887 parallel (degree 1) logging';

  execute immediate 'create unique index AQPB887A2 on AQPB887
  (PGCOD, PPMOD, PPSUC, PPMDA, PPPAP, PPCTA, PPOPER, PPSBOP, PPTOPE, PPFPAG, PPTIPO, PP1NUMP, PP1EXTE) nologging COMPRESS ADVANCED HIGH
  PARALLEL 8 tablespace BANTPROD_BDC01_IDX';

  execute immediate 'alter index AQPB887A2 logging noparallel';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPB887',
                                  degree           => 40,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;

--  execute immediate 'grant select on AQPB887 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lllosa,LCARPIO_FUNC';
  execute immediate 'grant select on AQPB887 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,LCARPIO_FUNC';
  execute immediate 'create or replace public synonym AQPB887 for AQPB887';

  execute immediate 'comment on table AQPB887 is    ''Tabla espejo de FSD612 para BDC01 fin de mes''';
  execute immediate 'comment on column AQPB887.pgcod is       ''Cod. Empresa''';
  execute immediate 'comment on column AQPB887.ppmod is       ''Modulo''';
  execute immediate 'comment on column AQPB887.ppsuc is       ''Sucurs''';
  execute immediate 'comment on column AQPB887.ppmda is       ''Moneda''';
  execute immediate 'comment on column AQPB887.pppap is       ''Papel''';
  execute immediate 'comment on column AQPB887.ppcta is       ''CTNRO''';
  execute immediate 'comment on column AQPB887.ppoper is       ''Operación''';
  execute immediate 'comment on column AQPB887.ppsbop is       ''Suboperación''';
  execute immediate 'comment on column AQPB887.pptope is       ''Tipo de operación''';
  execute immediate 'comment on column AQPB887.ppfpag is       ''Fecha de pago prevista''';
  execute immediate 'comment on column AQPB887.pptipo is       ''Tipo de cuota''';
  execute immediate 'comment on column AQPB887.pp1nump is       ''Número de pago a la cuota''';
  execute immediate 'comment on column AQPB887.Pp1exte is       ''Pp1exte''';
  execute immediate 'comment on column AQPB887.Pp1imp1 is       ''Pp1imp1''';
  execute immediate 'comment on column AQPB887.Pp1imp2 is       ''Pp1imp2''';
  execute immediate 'comment on column AQPB887.Pp1imp3 is       ''Pp1imp3''';
  execute immediate 'comment on column AQPB887.Pp1imp4 is       ''Pp1imp4''';
  execute immediate 'comment on column AQPB887.Pp1imp5 is       ''Pp1imp5''';
  execute immediate 'comment on column AQPB887.Pp1imp6 is       ''Pp1imp6''';
  execute immediate 'comment on column AQPB887.Pp1imp7 is       ''Pp1imp7''';
  execute immediate 'comment on column AQPB887.Pp1imp8 is       ''Pp1imp8''';
  execute immediate 'comment on column AQPB887.Pp1imp9 is       ''Pp1imp9''';
  execute immediate 'comment on column AQPB887.Pp1imp10 is       ''Pp1imp10''';
  execute immediate 'comment on column AQPB887.Pp1imp11 is       ''Pp1imp11''';
  execute immediate 'comment on column AQPB887.Pp1imp12 is       ''Pp1imp12''';
  execute immediate 'comment on column AQPB887.Pp1imp13 is       ''Pp1imp13''';
  execute immediate 'comment on column AQPB887.Pp1imp14 is       ''Pp1imp14''';
  execute immediate 'comment on column AQPB887.Pp1imp15 is       ''Pp1imp15''';
  execute immediate 'comment on column AQPB887.Pp1imp16 is       ''Pp1imp16''';
  execute immediate 'comment on column AQPB887.Pp1imp17 is       ''Pp1imp17''';
  execute immediate 'comment on column AQPB887.Pp1imp18 is       ''Pp1imp18''';
  execute immediate 'comment on column AQPB887.Pp1imp19 is       ''Pp1imp19''';
  execute immediate 'comment on column AQPB887.Pp1imp20 is       ''Pp1imp20''';
  execute immediate 'comment on column AQPB887.Pp1sal1 is       ''Pp1sal1''';
  execute immediate 'comment on column AQPB887.Pp1sal2 is       ''Pp1sal2''';
  execute immediate 'comment on column AQPB887.Pp1sal3 is       ''Pp1sal3''';
  execute immediate 'comment on column AQPB887.Pp1sal4 is       ''Pp1sal4''';
  execute immediate 'comment on column AQPB887.Pp1sal5 is       ''Pp1sal5''';
  execute immediate 'comment on column AQPB887.Pp1sal6 is       ''Pp1sal6''';
  execute immediate 'comment on column AQPB887.Pp1sal7 is       ''Pp1sal7''';
  execute immediate 'comment on column AQPB887.Pp1sal8 is       ''Pp1sal8''';
  execute immediate 'comment on column AQPB887.Pp1sal9 is       ''Pp1sal9''';
  execute immediate 'comment on column AQPB887.Pp1sal10 is       ''Pp1sal10''';
  execute immediate 'comment on column AQPB887.Pp1sal11 is       ''Pp1sal11''';
  execute immediate 'comment on column AQPB887.Pp1sal12 is       ''Pp1sal12''';
  execute immediate 'comment on column AQPB887.Pp1sal13 is       ''Pp1sal13''';
  execute immediate 'comment on column AQPB887.Pp1sal14 is       ''Pp1sal14''';
  execute immediate 'comment on column AQPB887.Pp1sal15 is       ''Pp1sal15''';
  execute immediate 'comment on column AQPB887.Pp1sal16 is       ''Pp1sal16''';
  execute immediate 'comment on column AQPB887.Pp1sal17 is       ''Pp1sal17''';
  execute immediate 'comment on column AQPB887.Pp1sal18 is       ''Pp1sal18''';
  execute immediate 'comment on column AQPB887.Pp1sal19 is       ''Pp1sal19''';
  execute immediate 'comment on column AQPB887.Pp1sal20 is       ''Pp1sal20''';
end;
/

