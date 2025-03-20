create or replace procedure SP_CR_TB_BDC01_AQPB878 is
begin
  --FSD602
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  begin
    execute immediate 'DROP TABLE AQPB878 PURGE';
  exception
    when others then
      null;
  end;
  execute immediate 'CREATE TABLE AQPB878 parallel (degree 8) nologging compress for archive low tablespace BANTPROD_BDC01 as '||
                    'SELECT  a.* FROM  FSD602 a';
  execute immediate 'alter TABLE AQPB878 parallel (degree 1) logging';

  execute immediate 'create unique index AQPB8781 on AQPB878
  (PGCOD, PPMOD, PPSUC, PPMDA, PPPAP, PPCTA, PPOPER, PPSBOP, PPTOPE, PPFPAG, PPTIPO, PP1NUMP) nologging COMPRESS ADVANCED HIGH
  PARALLEL 8 tablespace BANTPROD_BDC01_IDX';

  execute immediate 'alter index AQPB8781 logging noparallel';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPB878',
                                  degree           => 40,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;

  --11.2021
--  execute immediate 'grant select on AQPB878 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lllosa,LCARPIO_FUNC';
  begin
    execute immediate 'grant select, insert, update, delete on AQPB878 to ROL_SOPORTE_MESADEAYUDA';
--    execute immediate 'grant select on AQPB878 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lcarpio_func,RMEZA_ANX,JSAAVEDRA_ANX,AMANRIQUEL_ANX,WGASTELU_ANX,CEXLLOSA';
    execute immediate 'grant select on AQPB878 to rol_bantprod_cons,rol_produccion,rol_mesa_de_ayuda,lcarpio_func,RMEZA_ANX,CEXLLOSA';
  exception
  when others then
    null;
  end;
  execute immediate 'create or replace public synonym AQPB878 for AQPB878';
  execute immediate 'alter PACKAGE PQ_DATOS_ACL COMPILE DEBUG';
  execute immediate 'alter PACKAGE PQ_DATOS_ACL COMPILE DEBUG BODY';

  --01.2022
  execute immediate 'comment on table AQPB878 is    ''Tabla espejo de FSD602 para BDC01 fin de mes''';
  execute immediate 'comment on column AQPB878.pgcod is       ''Cod.''';
  execute immediate 'comment on column AQPB878.ppmod is       ''Modulo''';
  execute immediate 'comment on column AQPB878.ppsuc is       ''Sucurs''';
  execute immediate 'comment on column AQPB878.ppmda is       ''Moneda''';
  execute immediate 'comment on column AQPB878.pppap is       ''Papel''';
  execute immediate 'comment on column AQPB878.ppcta is       ''CTNRO''';
  execute immediate 'comment on column AQPB878.ppoper is      ''Operación''';
  execute immediate 'comment on column AQPB878.ppsbop is      ''Suboperación''';
  execute immediate 'comment on column AQPB878.pptope is      ''Tipo de operación''';
  execute immediate 'comment on column AQPB878.ppfpag is      ''Fecha de pago prevista''';
  execute immediate 'comment on column AQPB878.pptipo is      ''Tipo de cuota''';
  execute immediate 'comment on column AQPB878.pp1nump is     ''Número de pago a la cuota''';
  execute immediate 'comment on column AQPB878.pp1fech is     ''Fecha de pago''';
  execute immediate 'comment on column AQPB878.pp1cap is      ''Cuotaparte de pago a capital''';
  execute immediate 'comment on column AQPB878.pp1int is      ''Cuotaparte de pago a interés''';
  execute immediate 'comment on column AQPB878.pp1intmex is   ''Cuotaparte interés México''';
  execute immediate 'comment on column AQPB878.pp1intm is     ''Cuotaparte de pago a int.mora''';
  execute immediate 'comment on column AQPB878.pp1intmmex is  ''Cuotaparte mora México''';
  execute immediate 'comment on column AQPB878.pp1icap is     ''Cuotparte a impuesto de capit.''';
  execute immediate 'comment on column AQPB878.pp1iint is     ''Cuotaparte a impuesto de int.''';
  execute immediate 'comment on column AQPB878.pp1iintm is    ''Cuotaparte a impu. de int.mora''';
  execute immediate 'comment on column AQPB878.pp1salcap is   ''Saldo de capital de cuota''';
  execute immediate 'comment on column AQPB878.pp1salint is   ''Saldo de interés de cuota''';
  execute immediate 'comment on column AQPB878.pp1salade is   ''Saldo de intereses adelantados''';
  execute immediate 'comment on column AQPB878.pp1salmor is   ''Saldo de int. de mora de cuota''';
  execute immediate 'comment on column AQPB878.pp1stat is     ''Estado de la cuota''';
  execute immediate 'comment on column AQPB878.pp1salintm is  ''Saldo interés p/impuesto Mex.''';
  execute immediate 'comment on column AQPB878.pp1salmorm is  ''Saldo mora p/impuesto Mex.''';
  execute immediate 'comment on column AQPB878.pp1saladem is  ''Sdo Int Adel p/impuesto Mex.''';
  execute immediate 'comment on column AQPB878.d602cd is      ''D602cd''';
  execute immediate 'comment on column AQPB878.d602mo is      ''D602mo''';
  execute immediate 'comment on column AQPB878.d602su is      ''D602su''';
  execute immediate 'comment on column AQPB878.d602tr is      ''D602tr''';
  execute immediate 'comment on column AQPB878.d602re is      ''D602re''';
  execute immediate 'comment on column AQPB878.d602fc is      ''D602fc''';
  execute immediate 'comment on column AQPB878.d602or is      ''D602or''';
  execute immediate 'comment on column AQPB878.d602sb is      ''D602sb''';
  execute immediate 'comment on column AQPB878.d602co is      ''D602co''';
end;
/

