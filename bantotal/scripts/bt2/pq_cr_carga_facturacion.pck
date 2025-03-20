create or replace package PQ_CR_CARGA_FACTURACION is
  -- *****************************************************************
  -- Nombre                      : PQ_CR_CARGA_FACTURACION
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 
  -- Autor de Creaci�n          : DCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 
  -- Autor de la Modificaci�n   : DCASTRO
  -- Descripci�n de Modificaci�n: 2019.01.16 DCASTRO se modific� sp_cr_proceso
  --                              2019.02.19 DCASTRO se modifico sp_cr_proceso_inserta      
  -- Fecha de Modificaci�n      : 29/10/2020
  -- Autor de la Modificaci�n   : JRODRIGUEJ
  -- Descripci�n de Modificaci�n: Se modific� el cursor del proc. sp_cr_envio_SUNAT, 
  --                              para que solo considere operaciones gravadas
  -- Fecha de Modificaci�n      : 27/11/2020  
  -- Autor de la Modificaci�n   : JRODRIGUEJ
  -- Descripci�n de Modificaci�n: Adici�n del proceso sp_cr_sch_inserta_m    
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_proceso(pd_Fecpro in date);
  Procedure sp_cr_proceso_inserta(pd_Fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_carga_facturas(pd_Fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure Sp_cr_EnvioSUNAT(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
  procedure sp_cr_sch_inserta_m(pd_fecpro in date);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
end PQ_CR_CARGA_FACTURACION;
/

create or replace package body PQ_CR_CARGA_FACTURACION is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_CARGA_FACTURACION
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 
  -- Autor de Creaci�n          : DCASTRO
  -- Uso                        : Procesos para carga de informacion de facturacion electronica
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 
  -- Autor de la Modificaci�n   : DCASTRO
  -- Descripci�n de Modificaci�n: 2019.01.16 DCASTRO se modific� sp_cr_proceso
  -- Fecha de Modificaci�n      : 10.06.2019
  -- Autor de la Modificaci�n   : ABERNEDO
  -- Descripci�n de Modificaci�n: Se agrego proceso sp_cr_envioSunat y se agrego 
  --                              proceso de respuesta
  -- Fecha de Modificaci�n      : 29/10/2020  
  -- Autor de la Modificaci�n   : JRODRIGUEJ
  -- Descripci�n de Modificaci�n: Se modific� el cursor del proc. sp_cr_envio_SUNAT, 
  --                              para que solo considere operaciones gravadas  
  -- Fecha de Modificaci�n      : 27/11/2020  
  -- Autor de la Modificaci�n   : JRODRIGUEJ
  -- Descripci�n de Modificaci�n: Adici�n del proceso sp_cr_sch_inserta_m   
  -- *****************************************************************

  Procedure sp_cr_proceso(pd_Fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_proceso
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 
    -- Autor de Creaci�n          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Fecha de Modificaci�n      : 2019.01.16
    -- Autor de la Modificaci�n   : DCASTRO
    -- Descripci�n de Modificaci�n: Se agreg� sentencia de paralelismo y modificacion de variable lc_proceso 
    -- *****************************************************************
  
    ld_fecini       date;
    lc_fechaproceso varchar2(8);
    lc_tabla        varchar2(30);
    lc_SQL          varchar2(10000);
    lc_nomusr     varchar2(50);
  
  Begin
    
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;  
  
    --16.01.2019
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  
    lc_fechaproceso := to_char(pd_Fecpro, 'yyyymmdd');
    --16.01.2019
  
    --1----CREAR INDICE a TABLA operador.fsd016_20181112_4013
    --  descomentar en qa y produccion
    begin
      operador.sp_ct_index_fsd016(lc_fechaproceso);
    end;
  
    --eliminacion de dia 10 atras
    ld_fecini := to_date(lc_fechaproceso, 'yyyymmdd') - 10;
    delete from /*bantprod.*/ jaqz659 a where a.jaqz659fecpr = ld_fecini;
    commit;
  
    --insercion de tabla
    lc_tabla := 'operador.fsd016_' || lc_fechaproceso || '_4013'; --_&nombreTabla a
  
    lc_SQL := 'insert into /*bantprod.*/jaqz659(jaqz659fecpr, jaqz659pgcod, jaqz659itsuc, jaqz659itmod, jaqz659ittran, jaqz659itnrel, jaqz659itord, jaqz659itsbor,
           jaqz659modulo, jaqz659ittope, jaqz659itsucd, jaqz659rubro, jaqz659moneda, jaqz659papel, jaqz659ctnro, jaqz659itoper, jaqz659itsubo, jaqz659itfval,
           jaqz659itfvto, jaqz659itafiv, jaqz659itafgt, jaqz659itimp1, jaqz659itimp2, jaqz659itimp3, jaqz659itimp4, jaqz659itimp5, jaqz659itimp6, jaqz659itimp7,
           jaqz659itimp8, jaqz659itimp9, jaqz659itimp10, jaqz659itimp11, jaqz659itimp12, jaqz659itimp13, jaqz659itimp14, jaqz659itimp15, jaqz659itimp16, jaqz659itimp17,
           jaqz659itimp18, jaqz659itimp19, jaqz659itimp20, jaqz659itdbha)
       select to_date(''' || lc_fechaproceso ||
              ''',''yyyymmdd'') , i.pgcod, i.itsuc, i.itmod, i.ittran, i.itnrel, i.itord, i.itsbor, 
       i.modulo, i.ittope, i.itsucd, i.rubro, i.moneda, i.papel, i.ctnro, i.itoper, i.itsubo, i.itfval,
       i.itfvto, i.itafiv, i.itafgt, i.itimp1, i.itimp2, i.itimp3, i.itimp4, i.itimp5, i.itimp6, i.itimp7,
       i.itimp8, i.itimp9, i.itimp10, i.itimp11, i.itimp12, i.itimp13, i.itimp14, i.itimp15, i.itimp16, i.itimp17,
       i.itimp18, i.itimp19, i.itimp20, i.itdbha from ' ||
              lc_tabla ||
              ' i where i.pgcod  =1  
       and (i.itmod, i.ittran) in (select b.sr171trmod,b.sr171trnro from fsr171 b) ';
  
    EXECUTE IMMEDIATE lc_SQL;
  
    commit;
  
    --4.1-APLICAR ESTADISTICAS
  
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'DESA021118',--'BANTPROD',
                                    TABNAME          => 'JAQZ659',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;
  
  end sp_cr_proceso;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_proceso_inserta(pd_Fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_proceso_inserta
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 
    -- Autor de Creaci�n          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************
  
    cursor movimientos is
    /* select  f.sr171tremp ,f.st171cpcod , f.sr171trmod, f.sr171trnro, f.sr171trord, g.st171cpdsc ,h.hcimp1,h.hsucor, h.hnrel, h.hfcon, h.hcta, h.hsucur
                                          from \*bantprod.*\fsr171 f , \*bantprod.*\FST171 G, \*bantprod. *\fsh016 h
                                          where h.pgcod = f.sr171tremp
                                          and h.hcmod = f.sr171trmod
                                          and h.htran = f.sr171trnro
                                          and h.hcord = f.sr171trord
                                          and h.hfcon = pd_Fecpro --to_date(pd_Fecpro, 'yyyymmdd')  ---> CAMBIAR FECHA DE PROCESO
                                          and F.ST171CPCOD =  G.ST171CPCOD
                                          and h.hcafgt = 'C'
                                          and h.hcmod not in ( 99,599) 
                                          and h.hrubro not in ('4212290000007', '4222290000007')
                                          and (h.hcmod,h.htran) not in (select 30, 351 from dual)
                                          and (h.hcmod,h.htran) not in (select 30, 350 from dual)
                                          and (h.hcmod,h.htran) not in (select 30, 355 from dual)
                                          and (h.hcmod,h.htran) not in (select 30, 356 from dual)
                                          and (h.hcmod,h.htran) not in (select 30, 357 from dual)
                                          and (h.hcmod,h.htran) not in (select 30, 360 from dual)
                                          and not exists (
                                              select  1
                                              from \*bantprod.*\fsx016  x
                                              where x.pgcod = h.pgcod
                                              and x.hcmod = h.hcmod
                                              and x.hsucor = h.hsucor
                                              and x.htran = h.htran
                                              and x.hnrel = h.hnrel
                                              and x.hfcon = h.hfcon
                                              and x.txcod = 200
                                          )
                                          order by  h.hsucor, f.sr171trmod, f.sr171trnro, h.hnrel , f.st171cpcod, f.sr171trord ;*/
    
      select /* +ALL_ROWS*/f.sr171tremp, ---20221029 se agrego hints
             f.st171cpcod,
             f.sr171trmod,
             f.sr171trnro,
             f.sr171trord,
             g.st171cpdsc,
             h.jaqz675asuc  hsucor,
             h.jaqz675anre  hnrel,
             pd_fecpro      hfcon,
             h.jaqz675acta  hcta,
             h.jaqz675asucu hsucur,
             h.jaqz675aimp1 hcimp1
        from FSR171 F, FST171 G, JAQZ675A h
       where h.jaqz675acod = F.SR171TREMP
         AND h.jaqz675amod = F.SR171TRMOD
         AND h.jaqz675atrn = F.SR171TRNRO
         AND h.jaqz675acor = F.SR171TRORD
            --AND h.jaqz675acsu = F.SR171TRSBO
         AND f.ST171CPCOD = G.ST171CPCOD
       order by h.jaqz675acod,
                f.sr171trmod,
                f.sr171trnro,
                h.jaqz675anre,
                f.st171cpcod,
                f.sr171trord;
  
    cursor cabecera is
      select * from fst171 f where f.st171cpcod in (1, 3, 4, 5);
  
    cursor fse170(lc_fecha date) is
            select distinct lc_fecha fecha,
                          JAQZ676DOEMP,
                          JAQZ676DOID,
                          JAQZ676CPCOD,
                          JAQZ676VNRO,
                          JAQZ676VCHR,
                          JAQZ676VFCH,
                          JAQZ676VIMP,
                          JAQZ676VTAS
            from JAQZ676
           where (JAQZ676DOEMP, JAQZ676DOID, JAQZ676CPCOD, JAQZ676VNRO) not in
                 (select JAQZ676DOEMP, JAQZ676DOID, JAQZ676CPCOD, JAQZ676VNRO
                    from JAQZ676 j
                   where j.jaqz676vnro = 0
                     and j.jaqz676vchr = 'Nro de Cuenta');    
  
    lc_fechaproceso varchar2(8);
    ln_txoren       number;
    ln_numero       number;
    ln_contador     number;
    ln_cuenta       number;
    ln_sucursal     number;
    lc_hora         char(8);
    ln_relacion     number;
    --lc_flag     char(1);
    ln_modulo number;
    ln_tran   number;
    ln_sucur  number;
    lc_err    varchar2(300);
    lc_nomusr     varchar2(50);
  begin
  
    lc_fechaproceso := to_char(pd_Fecpro, 'yyyymmdd');
  
    ln_numero   := 500;
    ln_contador := 1;
    
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;     
  
    execute immediate ('truncate table fse170h');
    execute immediate ('truncate table JAQZ676'); --FSE170_FAC
    execute immediate ('truncate table JAQZ675'); --FSX016_FAC
  
    execute immediate ('truncate table JAQZ675A'); --FSH016
    execute immediate ('alter table JAQZ675A parallel 10'); --FSH016
  
    execute immediate ('truncate table JAQZ685'); --mod@abr 20190304
  
    insert into JAQZ685 --parallel (degree 10) nologging AS 
      SELECT /*+parallel(H,10)*/
       H.PGCOD,
       H.HCMOD,
       H.HSUCOR,
       H.HTRAN,
       H.HNREL,
       H.HFCON,
       H.HCORD,
       H.HCSUBO,
       H.HCTA,
       H.HSUCUR,
       H.HCIMP1,
       H.HRUBRO,
       HCAFGT
        FROM FSH016 H
       WHERE H.PGCOD = 1
         AND H.HFCON = pd_Fecpro;
    commit;
  
    INSERT /*+append*/
    INTO JAQZ675A
      (JAQZ675ACOD,
       JAQZ675AMOD,
       JAQZ675ASUC,
       JAQZ675ATRN,
       JAQZ675ANRE,
       JAQZ675AFCO,
       JAQZ675ACOR,
       JAQZ675ACSU,
       JAQZ675ACTA,
       JAQZ675ASUCU,
       JAQZ675AIMP1)
      select /*+parallel(H,10)*/ --20221029 se agrego hints
       H.JAQZ685PGC,
             H.JAQZ685MOD,
             H.JAQZ685SUC,
             H.JAQZ685TRA,
             H.JAQZ685REL,
             H.JAQZ685HFC,
             H.JAQZ685HCO,
             H.JAQZ685HCS,
             H.JAQZ685CTA,
             H.JAQZ685SUX,
             H.JAQZ685IMP
        from JAQZ685 H
       where H.JAQZ685CAF = 'C'
         and (H.JAQZ685MOD, H.JAQZ685TRA) IN
             (SELECT A.TP1NRO1, A.TP1NRO2
                FROM FST198 A
               WHERE A.TP1COD = 1
                 AND A.TP1COD1 = 11120
                 AND A.TP1CORR1 = 4
                 AND A.TP1NRO1 IS NOT NULL)
         AND H.JAQZ685RUB NOT IN (4212290000007, 4222290000007);
    commit;

    --20221029 se agrego estadisticas
    
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'BANTPROD', --'DESA021118',--'BANTPROD',
                                    TABNAME          => 'JAQZ685',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;

    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'BANTPROD', --'DESA021118',--'BANTPROD',
                                    TABNAME          => 'JAQZ675A',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;
    --20221029 se agrego estadisticas
      
    for i in movimientos loop
    
      if i.hnrel <> ln_relacion or i.sr171trmod <> ln_modulo or
         i.sr171trnro <> ln_tran or i.hsucor <> ln_sucur then
        ln_contador := 1;
        ln_numero   := ln_numero + 1;
      end if;
    
      ln_txoren   := i.ST171CPCOD + 100;
      ln_cuenta   := i.hcta;
      ln_sucursal := i.hsucur;
    
      if ln_contador = 1 then
        for y in cabecera loop
          if y.ST171CPCOD = 1 then
            --sucursal
            insert into JAQZ675
              (JAQZ675cod,
               JAQZ675mod,
               JAQZ675suc,
               JAQZ675trn,
               JAQZ675nre,
               JAQZ675fco,
               JAQZ675cor,
               JAQZ675csu,
               JAQZ675tco,
               JAQZ675toe,
               JAQZ675tor,
               JAQZ675tsu,
               JAQZ675tru,
               JAQZ675tmd,
               JAQZ675tpa,
               JAQZ675tct,
               JAQZ675top,
               JAQZ675tsb,
               JAQZ675tto,
               JAQZ675tmo)
            values
              (i.sr171tremp,
               i.sr171trmod,
               i.hsucor,
               i.sr171trnro,
               i.hnrel,
               i.hfcon,
               10,
               1,
               200,
               101,
               ln_sucursal,
               0,
               ln_numero,
               0,
               0,
               0,
               0,
               0,
               0,
               0);
          
            insert into JAQZ676
              (JAQZ676doemp,
               JAQZ676doid,
               JAQZ676cpcod,
               JAQZ676vnro,
               JAQZ676vchr,
               JAQZ676vfch,
               JAQZ676vimp,
               JAQZ676vtas)
            values
              (i.sr171tremp,
               ln_numero,
               y.ST171CPCOD,
               ln_sucursal,
               trim(y.st171cpdsc),
               null,
               0,
               0);
          
          elsif y.ST171CPCOD = 3 then
            --hora
            /*begin
              select a.hhora
                into lc_hora
                from fsh015 a 
                where a.pgcod  = i.sr171tremp 
                  and a.hcmod  = i.sr171trmod 
                  and a.hsucor = i.hsucor 
                  and a.htran  = i.sr171trnro 
                  and a.hnrel  = i.hnrel 
                  and a.hfcon  = i.hfcon;
            exception when others then
                  lc_hora := null;              
            end;*/
          
            begin
              select a.hhora
                into lc_hora
                from fsH015 a
               where a.pgcod = i.sr171tremp
                 and a.hcmod = i.sr171trmod
                 and a.hsucor = i.hsucor
                 and a.htran = i.sr171trnro
                 and a.hnrel = i.hnrel
                 and a.hfcon = i.hfcon;
            exception
              when others then
                lc_hora := null;
            end;
          
            insert into JAQZ675
              (JAQZ675cod,
               JAQZ675mod,
               JAQZ675suc,
               JAQZ675trn,
               JAQZ675nre,
               JAQZ675fco,
               JAQZ675cor,
               JAQZ675csu,
               JAQZ675tco,
               JAQZ675toe,
               JAQZ675tor,
               JAQZ675tsu,
               JAQZ675tru,
               JAQZ675tmd,
               JAQZ675tpa,
               JAQZ675tct,
               JAQZ675top,
               JAQZ675tsb,
               JAQZ675tto,
               JAQZ675tmo)
            values
              (i.sr171tremp,
               i.sr171trmod,
               i.hsucor,
               i.sr171trnro,
               i.hnrel,
               i.hfcon,
               10,
               1,
               200,
               103,
               lc_hora,
               0,
               ln_numero,
               0,
               0,
               0,
               0,
               0,
               0,
               0);
          
            insert into JAQZ676
              (JAQZ676doemp,
               JAQZ676doid,
               JAQZ676cpcod,
               JAQZ676vnro,
               JAQZ676vchr,
               JAQZ676vfch,
               JAQZ676vimp,
               JAQZ676vtas)
            values
              (i.sr171tremp,
               ln_numero,
               y.ST171CPCOD,
               0,
               lc_hora,
               null,
               0,
               0);
          
          elsif y.ST171CPCOD = 4 then
            --fecha
            insert into JAQZ675
              (JAQZ675cod,
               JAQZ675mod,
               JAQZ675suc,
               JAQZ675trn,
               JAQZ675nre,
               JAQZ675fco,
               JAQZ675cor,
               JAQZ675csu,
               JAQZ675tco,
               JAQZ675toe,
               JAQZ675tor,
               JAQZ675tsu,
               JAQZ675tru,
               JAQZ675tmd,
               JAQZ675tpa,
               JAQZ675tct,
               JAQZ675top,
               JAQZ675tsb,
               JAQZ675tto,
               JAQZ675tmo)
            values
              (i.sr171tremp,
               i.sr171trmod,
               i.hsucor,
               i.sr171trnro,
               i.hnrel,
               i.hfcon,
               10,
               1,
               200,
               104,
               i.hfcon,
               0,
               ln_numero,
               0,
               0,
               0,
               0,
               0,
               0,
               0);
          
            insert into JAQZ676
              (JAQZ676doemp,
               JAQZ676doid,
               JAQZ676cpcod,
               JAQZ676vnro,
               JAQZ676vchr,
               JAQZ676vfch,
               JAQZ676vimp,
               JAQZ676vtas)
            values
              (i.sr171tremp,
               ln_numero,
               y.ST171CPCOD,
               0,
               trim(y.st171cpdsc),
               i.hfcon,
               0,
               0);
          
          elsif y.ST171CPCOD = 5 then
            --cuenta
          
            insert into JAQZ675
              (JAQZ675cod,
               JAQZ675mod,
               JAQZ675suc,
               JAQZ675trn,
               JAQZ675nre,
               JAQZ675fco,
               JAQZ675cor,
               JAQZ675csu,
               JAQZ675tco,
               JAQZ675toe,
               JAQZ675tor,
               JAQZ675tsu,
               JAQZ675tru,
               JAQZ675tmd,
               JAQZ675tpa,
               JAQZ675tct,
               JAQZ675top,
               JAQZ675tsb,
               JAQZ675tto,
               JAQZ675tmo)
            values
              (i.sr171tremp,
               i.sr171trmod,
               i.hsucor,
               i.sr171trnro,
               i.hnrel,
               i.hfcon,
               10,
               1,
               200,
               105,
               ln_cuenta,
               0,
               ln_numero,
               0,
               0,
               0,
               0,
               0,
               0,
               0);
          
            insert into JAQZ676
              (JAQZ676doemp,
               JAQZ676doid,
               JAQZ676cpcod,
               JAQZ676vnro,
               JAQZ676vchr,
               JAQZ676vfch,
               JAQZ676vimp,
               JAQZ676vtas)
            values
              (i.sr171tremp,
               ln_numero,
               y.ST171CPCOD,
               ln_cuenta,
               trim(y.st171cpdsc),
               null,
               0,
               0);
          end if;
          commit;
        end loop;
        ln_contador := ln_contador + 1;
      end if;
    
      insert into JAQZ675
        (JAQZ675cod,
         JAQZ675mod,
         JAQZ675suc,
         JAQZ675trn,
         JAQZ675nre,
         JAQZ675fco,
         JAQZ675cor,
         JAQZ675csu,
         JAQZ675tco,
         JAQZ675toe,
         JAQZ675tor,
         JAQZ675tsu,
         JAQZ675tru,
         JAQZ675tmd,
         JAQZ675tpa,
         JAQZ675tct,
         JAQZ675top,
         JAQZ675tsb,
         JAQZ675tto,
         JAQZ675tmo)
      values
        (i.sr171tremp,
         i.sr171trmod,
         i.hsucor,
         i.sr171trnro,
         i.hnrel,
         i.hfcon,
         10,
         1,
         200,
         ln_txoren,
         i.hcimp1,
         0,
         ln_numero,
         0,
         0,
         0,
         0,
         0,
         0,
         0);
    
      insert into JAQZ676
        (JAQZ676doemp,
         JAQZ676doid,
         JAQZ676cpcod,
         JAQZ676vnro,
         JAQZ676vchr,
         JAQZ676vfch,
         JAQZ676vimp,
         JAQZ676vtas)
      values
        (i.sr171tremp,
         ln_numero,
         i.ST171CPCOD,
         0,
         trim(i.st171cpdsc),
         null,
         trunc(i.hcimp1),
         0);
    
      ln_relacion := i.hnrel;
      ln_modulo   := i.sr171trmod;
      ln_tran     := i.sr171trnro;
      ln_sucur    := i.hsucor;
      commit;
    end loop;
    commit;
  
    pq_cr_factura_electronica.Sp_cr_proceso_bach_2(pd_fecpro);
  
    execute immediate ('alter table JAQZ675A parallel 1'); --FSH016  2019.02.19 DCASTRO se modifico parallel 10 a 1
  
    --estadisticas
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'BANTPROD',
                                    TABNAME          => 'JAQZ675',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;
  
    --1.2--------------
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'BANTPROD',
                                    TABNAME          => 'JAQZ676',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;
  
    --modificacion de punto
    begin
      update JAQZ675 a
         set a.JAQZ675TOR = trim(case
                                   when substr(JAQZ675TOR, 1, 1) = ',' then
                                    replace(JAQZ675TOR, ',', '0.')
                                   else
                                    replace(JAQZ675TOR, ',', '.')
                                 end)
       where a.JAQZ675COD = 1
         and a.JAQZ675FCO = pd_fecpro --fecha diaria
         and a.JAQZ675TCO = 200
         and a.JAQZ675TOE > 105;
    
    exception
      when others then
        null;
    end;
    commit;
  
    --Insertar en FSX016 y FSE170H
    /*begin
     insert into fsx016
     select f.jaqz675cod,f.jaqz675mod,f.jaqz675suc,f.jaqz675trn,f.jaqz675nre,f.jaqz675fco,
            f.jaqz675cor,f.jaqz675csu,f.jaqz675tco,f.jaqz675toe,f.jaqz675tor,f.jaqz675tsu,
            f.jaqz675tru,f.jaqz675tmd,f.jaqz675tpa,f.jaqz675tct,f.jaqz675top,f.jaqz675tsb,
            f.jaqz675tto,f.jaqz675tmo from JAQZ675 f 
      where f.JAQZ675FCO = pd_fecpro
        and not exists (
                         select  1
                            from fsx016  x
                           where x.pgcod = f.jaqz675cod
                             and x.hcmod   = f.jaqz675mod
                             and x.hsucor  = f.jaqz675suc
                             and x.htran   = f.jaqz675trn
                             and x.hnrel   = f.jaqz675nre
                             and x.hfcon   = f.jaqz675fco
                             and x.txcod   = 200
                     ); --fecha diaria
     commit;
     
     exception
         when others then
         null;
         --lc_err :=sqlerrm;
         --insert into prueba_fact
         --values();
         --commit;
     end;
    */
  
    -- jrodriguej  24.05.2021
    for j in fse170(pd_Fecpro) loop
      
        begin
          
          insert into Fse170h 
          (
            sd170hfecha,
            sd170hdoemp,
            sd170hdoid,
            st171hcpcod,
            se170hvnro,
            se170hvchr,
            se170hvfch,
            se170hvimp,
            se170hvtas
          )
          values
          (
            j.fecha,
            j.JAQZ676DOEMP,
            j.JAQZ676DOID,
            j.JAQZ676CPCOD,
            j.JAQZ676VNRO,
            j.JAQZ676VCHR,
            j.JAQZ676VFCH,
            j.JAQZ676VIMP,
            j.JAQZ676VTAS
          )
          ;  
          commit;    
          
        exception
          when others then  
            
          null;  
          
        end;    
    
    end loop;    
  
    /*
    begin
      insert into Fse170h
        select distinct pd_fecpro,
                        JAQZ676DOEMP,
                        JAQZ676DOID,
                        JAQZ676CPCOD,
                        JAQZ676VNRO,
                        JAQZ676VCHR,
                        JAQZ676VFCH,
                        JAQZ676VIMP,
                        JAQZ676VTAS
          from JAQZ676
         where (JAQZ676DOEMP, JAQZ676DOID, JAQZ676CPCOD, JAQZ676VNRO) not in
               (select JAQZ676DOEMP, JAQZ676DOID, JAQZ676CPCOD, JAQZ676VNRO
                  from JAQZ676 j
                 where j.jaqz676vnro = 0
                   and j.jaqz676vchr = 'Nro de Cuenta');
    
      commit;
    exception
      when others then
        lc_err := trim(sqlerrm);
        insert into aqpa460e
          (aqpa460eserie, aqpa460eamsge)
        values
          ('MMM', lc_err);
        commit;
    end;
    */
  
    update jaqz675 a set a.jaqz675cpc = jaqz675toe - 100;
    commit;
  
    -----8-------insertar registros de bantotal
    /*    begin
       insert into \*bantprod.*\Fse170h  --  --> CAMBIAR FECHA DE PROCESO
       select to_date(lc_fechaproceso, 'yyyymmdd'),  sd170doemp, sd170doid, st171cpcod, se170vnro, se170vchr, se170vfch, se170vimp, se170vtas --125438
       from \*bantprod.*\fsx016 f, \*bantprod.*\fse170 g 
       where f.pgcod = g.sd170doemp
       and f.txcod = 200
       and g.sd170doid = f.txtrub
       and f.txoren =  g.st171cpcod +100
       and f.hfcon = to_date(lc_fechaproceso, 'yyyymmdd')  --> CAMBIAR FECHA DE PROCESO
       and g.sd170doid >= 33000;
       commit;
    exception when others then
       null;
    end;   */
    ----8.1 aplicar estadisticas
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'BANTPROD', --'DESA021118',--'BANTPROD',
                                    TABNAME          => 'Fse170h',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;
  
  end sp_cr_proceso_inserta;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_carga_facturas(pd_Fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_factura
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 
    -- Autor de Creaci�n          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************
  
    lc_fechaproceso varchar2(8);
  
  Begin
  
    begin
      pq_cr_carga_facturacion.sp_cr_proceso(pd_fecpro => pd_Fecpro);
    end;
  
    begin
      pq_cr_carga_facturacion.sp_cr_proceso_inserta(pd_fecpro => pd_Fecpro);
    end;
  
    begin
      pq_cr_factura_electronica.sp_transaccion_valida(pd_pgfape => pd_Fecpro); --> CAMBIAR FECHA DE PROCESO
    end;
  
    --11 � actualizar correo electronico
    begin
      update /*bantprod.*/ aqpa460 a
         set a.aqpa460corrr = 'Reportefactele@cajaarequipa.pe',
             a.aqpa460trecv = 'Reportefactele@cajaarequipa.pe'
       where a.aqpa460femi = to_date(lc_fechaproceso, 'yyyymmdd') --> CAMBIAR FECHA DE PROCESO
         and (a.aqpa460corrr is null or a.aqpa460trecv is null);
      commit;
    exception
      when others then
        null;
    end;
  
    --12 -actualizar registros
    begin
      update /*bantprod.*/ aqpa460 a
         set a.aqpa460corrr = 'Reportefactele@cajaarequipa.pe',
             a.aqpa460trecv = 'Reportefactele@cajaarequipa.pe'
       where a.aqpa460femi = to_date(lc_fechaproceso, 'yyyymmdd') --> CAMBIAR FECHA DE PROCESO
         and (a.aqpa460corrr like '%Correspondencia%' or
             a.aqpa460corrr like '%Corporativo%');
      commit;
    exception
      when others then
        null;
    end;
  
    --ELminar indice drop index operador.idx_fsd016_20181112_4013;
    -- descomentar en QA y produccion
    begin
      operador.sp_dr_index_fsd016;
    end;
  
    --Mod@abr 20190610
    begin
      Pq_Cr_Carga_Facturacion.Sp_cr_EnvioSUNAT(pd_fecpro => pd_Fecpro);
    end;
  
    /*se comento 20221029
    begin
      pq_ar_facturacion_e.pr_ar_get_masivo_xml_pdf;
    end;
    */
    --Mod@abr 20190610
  
  end sp_cr_carga_facturas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure Sp_cr_EnvioSUNAT(pd_fecpro in date) IS
  --- 2022-06-12 DCASTRO se agrego cursr para notas de credito por comision aqpa466
  --- 2022-07-12 DCASTRO se modific� cursr para notas de credito  comision aqpa466
  
    cursor facturas is
    /*
      select aqpa465serie,
             aqpa465corr,
             aqpa465pgcod,
             aqpa465mod,
             aqpa465sucor,
             aqpa465tran,
             aqpa465rel,
             aqpa465con,
             aqpa465msgs,
             aqpa465msgt,
             aqpa465usu,
             AQPA465HOR,
             AQPA465HASH,
             AQPA465FEC,
             aqpa465est,
             AQPA465URSUD,
             aqpa465fecd,
             aqpa465hord
        from aqpa465 a
       where a.aqpa465con = pd_fecpro --CAMBIAR FECHA PROCESO
         and a.aqpa465est is null
      union
      select aqpa466serie aqpa465serie,
             aqpa466corr  aqpa465corr,
             aqpa466pgcod aqpa465pgcod,
             aqpa466mod   aqpa465mod,
             aqpa466sucor aqpa465sucor,
             aqpa466tran  aqpa465tran,
             aqpa466rel   aqpa465rel,
             aqpa466con   aqpa465con,
             aqpa466msgs  aqpa465msgs,
             aqpa466msgt  aqpa465msgt,
             aqpa466usu   aqpa465usu,
             aqpa466hor   AQPA465HOR,
             aqpa466hash  AQPA465HASH,
             aqpa466fec   AQPA465FEC,
             aqpa466est   aqpa465est,
             aqpa466usud  AQPA465URSUD,
             aqpa466fecd  aqpa465fecd,
             aqpa466hord  aqpa465hord
        from aqpa466 a
       where a.aqpa466con = pd_fecpro --CAMBIAR FECHA PROCESO
         and a.aqpa466serie = 'FC01'
         and a.aqpa466est is null;
      */
      
         select a.aqpa465serie,
             a.aqpa465corr,
             a.aqpa465pgcod,
             a.aqpa465mod,
             a.aqpa465sucor,
             a.aqpa465tran,
             a.aqpa465rel,
             a.aqpa465con,
             a.aqpa465msgs,
             a.aqpa465msgt,
             a.aqpa465usu,
             a.AQPA465HOR,
             a.AQPA465HASH,
             a.AQPA465FEC,
             a.aqpa465est,
             a.AQPA465URSUD,
             a.aqpa465fecd,
             a.aqpa465hord
        from aqpa465 a,
             (select distinct g.aqpa460pgc,
                              g.aqpa460mod,
                              g.aqpa460suc,
                              g.aqpa460trx,
                              g.aqpa460rel,
                              g.aqpa460femi,
                              g.aqpa460tcomf
                from aqpa460 g
               where g.aqpa460femi = pd_fecpro
                 and g.aqpa460mode is null) x
       where a.aqpa465pgcod = x.aqpa460pgc
         and a.aqpa465mod = x.aqpa460mod
         and a.aqpa465sucor = x.aqpa460suc
         and a.aqpa465tran = x.aqpa460trx
         and a.aqpa465rel = x.aqpa460rel
         and a.aqpa465con = x.aqpa460femi
         and a.aqpa465con = pd_fecpro --CAMBIAR FECHA PROCESO
         and a.aqpa465est is null
         and ((a.aqpa465mod, a.aqpa465tran) in ----INCLUYE SOLO A LOS GRAVADOS
             (select k.tp1nro1, k.tp1nro2
                 from fst198 k
                where 
                  k.tp1cod = 1
                  and k.tp1cod1 = 11120
                  and k.tp1corr1 = 3
                  and k.tp1corr2 = 1
                  and tp1corr3 > 0) or x.aqpa460tcomf <> '13');
                  
      
  cursor facturas_nc is
      
      select aqpa466serie aqpa465serie,
             aqpa466corr  aqpa465corr,
             aqpa466pgcod aqpa465pgcod,
             aqpa466mod   aqpa465mod,
             aqpa466sucor aqpa465sucor,
             aqpa466tran  aqpa465tran,
             aqpa466rel   aqpa465rel,
             aqpa466con   aqpa465con,
             aqpa466msgs  aqpa465msgs,
             aqpa466msgt  aqpa465msgt,
             aqpa466usu   aqpa465usu,
             aqpa466hor   AQPA465HOR,
             aqpa466hash  AQPA465HASH,
             aqpa466fec   AQPA465FEC,
             aqpa466est   aqpa465est,
             aqpa466usud  AQPA465URSUD,
             aqpa466fecd  aqpa465fecd,
             aqpa466hord  aqpa465hord
        from aqpa466 a,
             (select distinct g.aqpa460pgce,
                              g.aqpa460mode,
                              g.aqpa460suce,
                              g.aqpa460trxe,
                              g.aqpa460rele,
                              g.aqpa460femi,
                              g.aqpa460tcomf
                from aqpa460 g
               where g.aqpa460femi = pd_fecpro
                 and g.aqpa460mode is not null) x
       where a.aqpa466pgcod = x.aqpa460pgce
         and a.aqpa466mod = x.aqpa460mode
         and a.aqpa466sucor = x.aqpa460suce
         and a.aqpa466tran = x.aqpa460trxe
         and a.aqpa466rel = x.aqpa460rele
         and a.aqpa466con = x.aqpa460femi
         and a.aqpa466con = pd_fecpro --CAMBIAR FECHA PROCESO
            --and a.aqpa466serie = 'FC01'
         and a.aqpa466est is null
         and ((a.aqpa466mod, a.aqpa466tran) in ----INCLUYE SOLO A LOS GRAVADOS
             (select k.tp1nro1, k.tp1nro2
                 from fst198 k
                where 
                  k.tp1cod = 1
                  and k.tp1cod1 = 11120
                  and k.tp1corr1 = 3
                  and k.tp1corr2 = 1
                  and tp1corr3 > 0) or x.aqpa460tcomf <> '87')

      ;
  
    lc_flag   char(1);
    lc_error  varchar2(3000);
    lc_codigo varchar2(3000);
  
  BEGIN
  
    --1 enviando facturas
    for i in facturas loop
    
      begin
      
        pq_ar_facturacion_e.pr_ar_main(pn_serie       => i.aqpa465serie,
                                       pn_nro         => i.aqpa465corr,
                                       pv_flag_error  => lc_flag,
                                       pv_error       => lc_error,
                                       pv_codigo_hash => lc_codigo);
      end;
    
    end loop;
  
    --se agrego 20221029
    begin
      pq_ar_facturacion_e.pr_ar_get_masivo_xml_pdf;
    end;
    --20221029
    
    --2 enviando notas de credito
    for i in facturas_nc loop
    
      begin
      
        pq_ar_facturacion_e.pr_ar_main(pn_serie       => i.aqpa465serie,
                                       pn_nro         => i.aqpa465corr,
                                       pv_flag_error  => lc_flag,
                                       pv_error       => lc_error,
                                       pv_codigo_hash => lc_codigo);
      end;
    
    end loop;
  
    --se agrego 20221029
    begin
      pq_ar_facturacion_e.pr_ar_get_masivo_xml_pdf;
    end;
    --20221029
  
  END Sp_cr_EnvioSUNAT;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_sch_inserta_m(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_sch_inserta_m
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 27/11/2020
    -- Autor de Creaci�n          : JRODRIGUEJ
    -- Uso                        : Ejecuci�n del proceso sp_cr_proceso_inserta por schedulers
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************    
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    
     lc_err    varchar2(300);
   lc_nomusr     varchar2(50);
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
      --and sucurs < 800
      --or sucurs >= 900
      ;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then --2022.11.18 dcastro se agrego excepcion
       null;
    end;     
  
    
    -- Pasos Previos
    execute immediate ('truncate table fse170h');
    execute immediate ('truncate table JAQZ676'); --FSE170_FAC
    execute immediate ('truncate table JAQZ675'); --FSX016_FAC
  
    execute immediate ('truncate table JAQZ675A'); --FSH016
    execute immediate ('alter table JAQZ675A parallel 10'); --FSH016
  
    execute immediate ('truncate table JAQZ685'); --mod@abr 20190304    
  
  
    -- Inicio de Ejecuci�n
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'INS_REP_M';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_Factura_Electronica.sp_cr_proceso_inserta_M( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini || ');' ||
                       ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Ins_Dae_M');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Ins_Dae_M');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('INSREP_M', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := pq_cr_Factura_Electronica.fn_cr_verifica_tarea(lc_prefjob,
                                                                lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_Factura_Electronica.fn_cr_verifica_tarea(lc_prefjob,
                                                                  lc_hostname);
    End loop;
    -- ===========================================================================
    -- PASO 2
    -- ===========================================================================   
    execute immediate ('truncate table JAQZ675A'); --FSH016
     
    for i in sucursal loop
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'INB_REP_M';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_Factura_Electronica.Sp_cr_proceso_bach_2M( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini || ');' ||
                       ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Inb_Dae_M');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Inb_Dae_M');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('INBREP_M', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := pq_cr_Factura_Electronica.fn_cr_verifica_tarea(lc_prefjob,
                                                                lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_Factura_Electronica.fn_cr_verifica_tarea(lc_prefjob,
                                                                  lc_hostname);
    End loop;    
    
    -- Pasos Posteriores
    execute immediate ('alter table JAQZ675A parallel 1'); --FSH016  2019.02.19 DCASTRO se modifico parallel 10 a 1
  
    --estadisticas
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'BANTPROD', ----BANTPROD, --DESA200120
                                    TABNAME          => 'JAQZ675',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;
  
    --1.2--------------
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'BANTPROD', ----BANTPROD, --DESA200120
                                    TABNAME          => 'JAQZ676',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;    
    
    begin
      update JAQZ675 a
         set a.JAQZ675TOR = trim(case
                                   when substr(JAQZ675TOR, 1, 1) = ',' then
                                    replace(JAQZ675TOR, ',', '0.')
                                   else
                                    replace(JAQZ675TOR, ',', '.')
                                 end)
       where a.JAQZ675COD = 1
         and a.JAQZ675FCO = pd_fecpro --fecha diaria
         and a.JAQZ675TCO = 200
         and a.JAQZ675TOE > 105;
    
    exception
      when others then
        null;
    end;
    commit;
  
 
    begin
      insert into Fse170h
        select distinct pd_fecpro,
                        JAQZ676DOEMP,
                        JAQZ676DOID,
                        JAQZ676CPCOD,
                        JAQZ676VNRO,
                        JAQZ676VCHR,
                        JAQZ676VFCH,
                        JAQZ676VIMP,
                        JAQZ676VTAS
          from JAQZ676
         where (JAQZ676DOEMP, JAQZ676DOID, JAQZ676CPCOD, JAQZ676VNRO) not in
               (select JAQZ676DOEMP, JAQZ676DOID, JAQZ676CPCOD, JAQZ676VNRO
                  from JAQZ676 j
                 where j.jaqz676vnro = 0
                   and j.jaqz676vchr = 'Nro de Cuenta')
                    ;
    
      commit;
    exception
      when others then
        lc_err := trim(sqlerrm);
        insert into aqpa460e
          (aqpa460eserie, aqpa460eamsge)
        values
          ('MMM', lc_err);
        commit;
    end;
  
    update jaqz675 a set a.jaqz675cpc = jaqz675toe - 100;
    commit;
  
    -----8-------insertar registros de bantotal

    ----8.1 aplicar estadisticas
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'BANTPROD', --'DESA021118',--'BANTPROD', DESA250219,DESA200120
                                    TABNAME          => 'Fse170h',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;
      
  
  end sp_cr_sch_inserta_m;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --         

end PQ_CR_CARGA_FACTURACION;
/

