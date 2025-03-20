create or replace package pq_cr_var_adelantosueldo is

  -- Author  : GCARRANZAS
  -- Created : 28/04/2021 12:22:35
  -- Purpose : Variables para cargar base de datos 

  PROCEDURE SP_CR_CUENTA_VIGENTE(PN_PAIS          IN NUMBER,
                                 PN_TIPODOCUMENTO IN NUMBER,
                                 PC_DOCUMENTO     IN CHAR,
                                 PD_FECHASISTEMA  IN DATE,
                                 PV_CUENTAVIGENTE OUT VARCHAR2,
                                 PV_DESC_JUD      OUT VARCHAR2);
  -----------------------------------------------------------------
  PROCEDURE SP_CR_CUENTA_VIGENTE_Carga(PN_PAIS          IN NUMBER,
                                       PN_TIPODOCUMENTO IN NUMBER,
                                       PC_DOCUMENTO     IN CHAR,
                                       PD_FECHASISTEMA  IN DATE,
                                       PV_CUENTAVIGENTE OUT VARCHAR2,
                                       PV_DESC_JUD      OUT VARCHAR2);
  ------------------------------------------------------------                                 

  PROCEDURE SP_CR_CUENTA_ABONOS(PN_pgcod        IN NUMBER,
                                PN_Scmod        IN NUMBER,
                                PN_Scsuc        IN NUMBER,
                                PN_Scmda        IN NUMBER,
                                PN_Scpap        IN NUMBER,
                                PN_Sccta        IN NUMBER,
                                PN_Scoper       IN NUMBER,
                                PN_Scsbop       IN NUMBER,
                                PN_Sctope       IN NUMBER,
                                PD_FECHASISTEMA IN DATE,
                                PN_ABON_PROM    OUT NUMBER,
                                PN_ABON_MIN     OUT NUMBER,
                                PN_PRCN_DIF     OUT NUMBER,
                                PV_RESP_PROM    OUT VARCHAR2,
                                PV_RESP_MIN     OUT VARCHAR2,
                                PV_RESP_DIF     OUT VARCHAR2);

end pq_cr_var_adelantosueldo;
/

create or replace package body pq_cr_var_adelantosueldo is

  PROCEDURE SP_CR_CUENTA_VIGENTE(PN_PAIS          IN NUMBER,
                                 PN_TIPODOCUMENTO IN NUMBER,
                                 PC_DOCUMENTO     IN CHAR,
                                 PD_FECHASISTEMA  IN DATE,
                                 PV_CUENTAVIGENTE OUT VARCHAR2,
                                 PV_DESC_JUD      OUT VARCHAR2) IS
    LN_MESES  NUMBER;
    LN_CUENTA NUMBER;
    --LD_FECHASISTEMA DATE;
    ld_maxfech607   date;
    lc_Mes607       varchar2(2);
    lc_Marzo        varchar2(2);
    lc_Julio        varchar2(2);
    lc_Diciembre    varchar2(2);
    ln_NroReg       number;
    ln_TieneDep     number;
    ld_MaxFechAbono date;
  
    CURSOR CUENTAS_CLIENTE IS
      SELECT F.PGCOD,
             F.SCMOD,
             F.SCSUC,
             F.SCMDA,
             F.SCPAP,
             F.SCCTA,
             F.SCOPER,
             F.SCSBOP,
             F.SCTOPE
        FROM FSD011 F, FSR008 S
       WHERE F.PGCOD = S.PGCOD
         and f.pgcod = 1
         AND F.scmod = 21
         and f.scmda in (0, 101)
         and f.scpap = 0
         AND F.sctope = 6
         AND F.scstat NOT IN (81, 99)
         AND F.SCFULM > ADD_MONTHS(PD_FECHASISTEMA, LN_MESES * -1)
         AND F.sccta = S.CTNRO
         AND S.TTCOD = 1
         AND S.CTTFIR = 'T'
         AND S.PEPAIS = PN_PAIS
         AND S.PETDOC = PN_TIPODOCUMENTO
         AND S.PENDOC = PC_DOCUMENTO;
  
  BEGIN
  
    PV_CUENTAVIGENTE := 'N';
  
    BEGIN
      select F.TP1NRO1
        INTO LN_MESES
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 11138
         and f.tp1corr1 = 17
         and f.tp1corr2 = 1
         AND F.TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        LN_MESES := 6;
    END;
  
    /*
      BEGIN
        SELECT F.PGFAPE INTO LD_FECHASISTEMA FROM FST017 F WHERE F.PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          LD_FECHASISTEMA := TO_DATE(current_date, 'DD/MM/YYY');
      END;
    */
  
    BEGIN
      SELECT F.CTNRO
        INTO LN_CUENTA
        FROM FSR008 F
       WHERE F.PGCOD = 1
         AND F.TTCOD = 1
         AND F.CTTFIR = 'T'
         AND F.PEPAIS = PN_PAIS
         AND F.PETDOC = PN_TIPODOCUMENTO
         AND F.PENDOC = PC_DOCUMENTO;
    EXCEPTION
      WHEN OTHERS THEN
        PV_CUENTAVIGENTE := 'N';
    END;
  
    FOR C IN CUENTAS_CLIENTE LOOP
      /*SELECT CASE
                 WHEN COUNT(G.MESES) = LN_MESES THEN
                  'S'
                 ELSE
                  'N'
               END
          INTO PV_CUENTAVIGENTE
          FROM (SELECT \*+index(f fsh01299)*\ EXTRACT(MONTH FROM f.bcfech) MESES--17092021 hint
                  FROM fsh012 f
                 where f.bcemp = C.PGCOD
                   AND F.BCMOD = C.SCMOD
                   AND F.BCSUC = C.SCSUC
                   AND F.BCMDA = C.SCMDA
                   AND F.BCPAP = C.SCPAP
                   AND F.BCCTA = C.SCCTA
                   AND F.BCOPER = C.SCOPER
                   AND F.BCSBOP = C.SCSBOP
                   AND F.BCTOP = C.SCTOPE
                   and f.bcprod not in (81, 99)
                   and f.bcfech > ADD_MONTHS(PD_FECHASISTEMA, LN_MESES * -1)
                   AND TO_CHAR(f.bcfech, 'MMYYYY') <>
                       TO_CHAR(PD_FECHASISTEMA, 'MMYYYY') ---no seleccionar el mes actual
                 group by EXTRACT(MONTH FROM f.bcfech)) G;--mpostigoc INC3755
      */
    
      begin
        select max(a.aqpb607fecc) into ld_maxfech607 from aqpb607 a;
      exception
        when others then
          null;
      end;
    
      begin
        select to_char(ld_maxfech607, 'MM') into lc_Mes607 from dual;
      exception
        when others then
          null;
      end;
    
      begin
        SELECT ADD_MONTHS(TRUNC(ld_maxfech607, 'MM'), -1)
          into ld_MaxFechAbono
          FROM DUAL;
      exception
        when others then
          null;
      end;
    
      lc_Marzo     := '03';
      lc_Julio     := '07';
      lc_Diciembre := '12';
    
      if lc_Mes607 = lc_Marzo or lc_Mes607 = lc_Julio or
         lc_Mes607 = lc_Diciembre then
        begin
          SELECT ADD_MONTHS(TRUNC(ld_maxfech607, 'MM'), -2)
            into ld_MaxFechAbono
            FROM DUAL;
        exception
          when others then
            null;
        end;
      end if;
    
      begin
        select count(*)
          into ln_TieneDep
          from aqpb455 a
         where a.aqpb455emp = c.pgcod
           and a.aqpb455mod = c.scmod
           and a.aqpb455suc = c.scsuc
           and a.aqpb455mda = c.scmda
           and a.aqpb455pap = c.scpap
           and a.aqpb455cta = c.sccta
           and a.aqpb455ope = c.scoper
           and a.aqpb455sbop = c.scsbop
           and a.aqpb455tope = c.sctope
           and a.aqpb455est = 'G'
           and a.aqpb455fproc = ld_maxfech607
           and a.qpb455fecha = ld_MaxFechAbono;
      exception
        when others then
          null;
      end;
    
      if ln_TieneDep > 0 then
      
        begin
          select count(*)
            into ln_NroReg
            from aqpb455 a
           where a.aqpb455emp = c.pgcod
             and a.aqpb455mod = c.scmod
             and a.aqpb455suc = c.scsuc
             and a.aqpb455mda = c.scmda
             and a.aqpb455pap = c.scpap
             and a.aqpb455cta = c.sccta
             and a.aqpb455ope = c.scoper
             and a.aqpb455sbop = c.scsbop
             and a.aqpb455tope = c.sctope
             and a.aqpb455est = 'G'
             and a.aqpb455fproc = ld_maxfech607;
        exception
          when others then
            null;
        end;
      
        if ln_NroReg = LN_MESES then
          PV_CUENTAVIGENTE := 'S';
        else
          PV_CUENTAVIGENTE := 'N';
        end if;
      
        EXIT WHEN PV_CUENTAVIGENTE = 'S';
      
      else
        PV_CUENTAVIGENTE := 'N';
      end if;
    
    END LOOP;
  
    BEGIN
      SELECT 'S'
        INTO PV_DESC_JUD
        FROM FSD011 F, FSR008 S
       WHERE F.PGCOD = S.PGCOD
         and f.pgcod = 1
         AND F.scmod = 21
         AND F.sccta = S.CTNRO
         AND F.sctope = 5
         AND F.scstat NOT IN (81, 99)
         AND S.TTCOD = 1
         AND S.CTTFIR = 'T'
         AND S.PEPAIS = PN_PAIS
         AND S.PETDOC = PN_TIPODOCUMENTO
         AND S.PENDOC = PC_DOCUMENTO;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        PV_DESC_JUD := 'S';
      WHEN OTHERS THEN
        PV_DESC_JUD := 'N';
    END;
  
  END SP_CR_CUENTA_VIGENTE;
  -----------------------------------------------------------------

  PROCEDURE SP_CR_CUENTA_VIGENTE_Carga(PN_PAIS          IN NUMBER,
                                       PN_TIPODOCUMENTO IN NUMBER,
                                       PC_DOCUMENTO     IN CHAR,
                                       PD_FECHASISTEMA  IN DATE,
                                       PV_CUENTAVIGENTE OUT VARCHAR2,
                                       PV_DESC_JUD      OUT VARCHAR2) IS
    LN_MESES  NUMBER;
    LN_CUENTA NUMBER;
  
    lc_Mes607       varchar2(2);
    lc_Marzo        varchar2(2);
    lc_Julio        varchar2(2);
    lc_Diciembre    varchar2(2);
    ln_NroReg       number;
    ln_TieneDep     number;
    ld_MaxFechAbono date;
  
    CURSOR CUENTAS_CLIENTE IS
      SELECT F.PGCOD,
             F.SCMOD,
             F.SCSUC,
             F.SCMDA,
             F.SCPAP,
             F.SCCTA,
             F.SCOPER,
             F.SCSBOP,
             F.SCTOPE
        FROM FSD011 F, FSR008 S
       WHERE F.PGCOD = S.PGCOD
         and f.pgcod = 1
         AND F.scmod = 21
         and f.scpap = 0
         AND F.sccta = S.CTNRO
         AND F.sctope = 6
         AND F.scstat NOT IN (81, 99)
         AND F.SCFULM > ADD_MONTHS(PD_FECHASISTEMA, LN_MESES * -1)
         AND S.TTCOD = 1
         AND S.CTTFIR = 'T'
         AND S.PEPAIS = PN_PAIS
         AND S.PETDOC = PN_TIPODOCUMENTO
         AND S.PENDOC = PC_DOCUMENTO;
  
  BEGIN
  
    PV_CUENTAVIGENTE := 'N';
  
    BEGIN
      select F.TP1NRO1
        INTO LN_MESES
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 11138
         and f.tp1corr1 = 17
         and f.tp1corr2 = 1
         AND F.TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        LN_MESES := 6;
    END;
  
    BEGIN
      SELECT F.CTNRO
        INTO LN_CUENTA
        FROM FSR008 F
       WHERE F.PGCOD = 1
         AND F.TTCOD = 1
         AND F.CTTFIR = 'T'
         AND F.PEPAIS = PN_PAIS
         AND F.PETDOC = PN_TIPODOCUMENTO
         AND F.PENDOC = PC_DOCUMENTO;
    EXCEPTION
      WHEN OTHERS THEN
        PV_CUENTAVIGENTE := 'N';
    END;
  
    FOR C IN CUENTAS_CLIENTE LOOP
    
      begin
        SELECT ADD_MONTHS(TRUNC(PD_FECHASISTEMA, 'MM'), -1)
          into ld_MaxFechAbono
          FROM DUAL;
      exception
        when others then
          null;
      end;
    
      begin
        select to_char(ld_MaxFechAbono, 'MM') into lc_Mes607 from dual;
      exception
        when others then
          null;
      end; -- mpostigoc 02.07.2022
    
      lc_Marzo     := '03';
      lc_Julio     := '07';
      lc_Diciembre := '12';
    
      if lc_Mes607 = lc_Marzo or lc_Mes607 = lc_Julio or
         lc_Mes607 = lc_Diciembre then
        begin
          SELECT ADD_MONTHS(TRUNC(PD_FECHASISTEMA, 'MM'), -2)
            into ld_MaxFechAbono
            FROM DUAL;
        exception
          when others then
            null;
        end;
      end if;
    
      begin
        select count(*)
          into ln_TieneDep
          from aqpb455 a
         where a.aqpb455emp = c.pgcod
           and a.aqpb455mod = c.scmod
           and a.aqpb455suc = c.scsuc
           and a.aqpb455mda = c.scmda
           and a.aqpb455pap = c.scpap
           and a.aqpb455cta = c.sccta
           and a.aqpb455ope = c.scoper
           and a.aqpb455sbop = c.scsbop
           and a.aqpb455tope = c.sctope
           and a.aqpb455est = 'G'
           and a.aqpb455fproc = PD_FECHASISTEMA
           and a.qpb455fecha = ld_MaxFechAbono;
      exception
        when others then
          null;
      end;
    
      if ln_TieneDep > 0 then
      
        begin
          select count(*)
            into ln_NroReg
            from aqpb455 a
           where a.aqpb455emp = c.pgcod
             and a.aqpb455mod = c.scmod
             and a.aqpb455suc = c.scsuc
             and a.aqpb455mda = c.scmda
             and a.aqpb455pap = c.scpap
             and a.aqpb455cta = c.sccta
             and a.aqpb455ope = c.scoper
             and a.aqpb455sbop = c.scsbop
             and a.aqpb455tope = c.sctope
             and a.aqpb455est = 'G'
             and a.aqpb455fproc = PD_FECHASISTEMA;
        exception
          when others then
            null;
        end;
      
        if ln_NroReg = LN_MESES then
          PV_CUENTAVIGENTE := 'S';
        else
          PV_CUENTAVIGENTE := 'N';
        end if;
      
        EXIT WHEN PV_CUENTAVIGENTE = 'S';
      
      else
        PV_CUENTAVIGENTE := 'N';
      end if;
    
    END LOOP;
  
    BEGIN
      SELECT 'S'
        INTO PV_DESC_JUD
        FROM FSD011 F, FSR008 S
       WHERE F.PGCOD = S.PGCOD
         and f.pgcod = 1
         AND F.scmod = 21
         and f.scpap = 0
         AND F.sccta = S.CTNRO
         AND F.sctope = 5
         AND F.scstat NOT IN (81, 99)
         AND S.TTCOD = 1
         AND S.CTTFIR = 'T'
         AND S.PEPAIS = PN_PAIS
         AND S.PETDOC = PN_TIPODOCUMENTO
         AND S.PENDOC = PC_DOCUMENTO;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        PV_DESC_JUD := 'S';
      WHEN OTHERS THEN
        PV_DESC_JUD := 'N';
    END;
  
  END SP_CR_CUENTA_VIGENTE_Carga;

  ---------------------------------------------------------------

  PROCEDURE SP_CR_CUENTA_ABONOS(PN_pgcod        IN NUMBER,
                                PN_Scmod        IN NUMBER,
                                PN_Scsuc        IN NUMBER,
                                PN_Scmda        IN NUMBER,
                                PN_Scpap        IN NUMBER,
                                PN_Sccta        IN NUMBER,
                                PN_Scoper       IN NUMBER,
                                PN_Scsbop       IN NUMBER,
                                PN_Sctope       IN NUMBER,
                                PD_FECHASISTEMA IN DATE,
                                PN_ABON_PROM    OUT NUMBER,
                                PN_ABON_MIN     OUT NUMBER,
                                PN_PRCN_DIF     OUT NUMBER,
                                PV_RESP_PROM    OUT VARCHAR2,
                                PV_RESP_MIN     OUT VARCHAR2,
                                PV_RESP_DIF     OUT VARCHAR2) IS
  
    LN_MESES NUMBER;
    --LD_FECHASISTEMA DATE;
    LC_HORASISTEMA CHAR(8);
  
    CURSOR ABONOS IS
      SELECT C.FECHA, C.MONTO, C.RESTA, C.DIFERENCIA
        FROM (SELECT G.FECHA,
                     G.MONTO,
                     MONTO - lead(MONTO, 1) over(order by FECHA desc) RESTA,
                     ROUND((MONTO - lead(MONTO, 1) over(order by FECHA desc)) * 100 /
                           g.MONTO,
                           2) DIFERENCIA
                FROM (select TRUNC(F.HFCON, 'MONTH') FECHA,
                             SUM(F.HCIMP1) MONTO
                        from fsh016 f, fsh015 c
                       where c.pgcod = f.pgcod
                         and c.hcmod = f.hcmod
                         and c.hsucor = f.hsucor
                         and c.htran = f.htran
                         and c.hnrel = f.hnrel
                         and c.hfcon = f.hfcon
                         and c.hccorr <> 99
                         and f.hcodmo = 2 -- ingresos
                         and ((f.hcmod = 99 and f.htran = 280) or
                             (f.hcmod = 50 and f.htran = 10) or
                             (f.hcmod = 18 and f.htran = 52))
                         AND EXTRACT(MONTH FROM F.HFCON) NOT IN (3, 7, 12) --- NO MARZO, JULIO Y DICIEMBRE
                         AND F.HFCON >=
                             ADD_MONTHS(TRUNC(PD_FECHASISTEMA, 'MONTH'),
                                        LN_MESES * -1 - 4) --SE AGREGAN MAS MESES A LA CONSULTA EN CASO AFECTE LO DE QUITAR MARZO, J... Y EL ACTUAL
                         AND F.HFCON < TRUNC(PD_FECHASISTEMA, 'MONTH') --NO MOSTRAR EL MES ACTUAL
                         and f.pgcod = PN_pgcod
                         AND F.HMODUL = PN_Scmod
                         AND F.HSUCUR = PN_Scsuc
                         AND F.HMDA = PN_Scmda
                         AND F.HPAP = PN_Scpap
                         AND F.HCTA = PN_Sccta
                         AND F.HOPER = PN_Scoper
                         AND F.HSUBOP = PN_Scsbop
                         AND F.HTOPER = PN_Sctope
                       group by TRUNC(F.HFCON, 'MONTH')) G
               ORDER BY G.FECHA DESC) C
       WHERE ROWNUM <= LN_MESES;
  
  BEGIN
  
    /*
      BEGIN
        SELECT F.PGFAPE INTO LD_FECHASISTEMA FROM FST017 F WHERE F.PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          LD_FECHASISTEMA := TO_DATE(current_date, 'DD/MM/YYY');
      END;
    */
  
    SELECT TO_CHAR(SYSDATE, 'hh24:mi:ss') INTO LC_HORASISTEMA FROM DUAL;
  
    BEGIN
      select F.TP1NRO1
        INTO LN_MESES
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 11138
         and f.tp1corr1 = 17
         and f.tp1corr2 = 1
         AND F.TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        LN_MESES := 6;
    END;
  
    --ELIMINAR CUENTAS DEL MISMO DÍA
    DELETE FROM AQPB455 A
     WHERE A.AQPB455EMP = PN_pgcod
       AND A.AQPB455MOD = PN_Scmod
       AND A.AQPB455SUC = PN_Scsuc
       AND A.AQPB455MDA = PN_Scmda
       AND A.AQPB455PAP = PN_Scpap
       AND A.AQPB455CTA = PN_Sccta
       AND A.AQPB455OPE = PN_Scoper
       AND A.AQPB455SBOP = PN_Scsbop
       AND A.AQPB455TOPE = PN_Sctope
       AND A.AQPB455FPROC = PD_FECHASISTEMA;
    COMMIT;
  
    --DESACTIVAR CUENTAS DE OTROS DÍAS
    UPDATE AQPB455 A
       SET A.AQPB455EST = 'C'
     WHERE A.AQPB455EST = 'G'
       AND A.AQPB455EMP = PN_pgcod
       AND A.AQPB455MOD = PN_Scmod
       AND A.AQPB455SUC = PN_Scsuc
       AND A.AQPB455MDA = PN_Scmda
       AND A.AQPB455PAP = PN_Scpap
       AND A.AQPB455CTA = PN_Sccta
       AND A.AQPB455OPE = PN_Scoper
       AND A.AQPB455SBOP = PN_Scsbop
       AND A.AQPB455TOPE = PN_Sctope;
    COMMIT;
  
    FOR R IN ABONOS() LOOP
      begin
        INSERT INTO AQPB455
          (aqpb455emp,
           aqpb455mod,
           aqpb455suc,
           aqpb455mda,
           aqpb455pap,
           aqpb455cta,
           aqpb455ope,
           aqpb455sbop,
           aqpb455tope,
           aqpb455fproc,
           AQPB455HORA,
           aqpb455est,
           qpb455fecha,
           aqpb455monto,
           aqpb455resta,
           AQPB455PORCNT)
        VALUES
          (PN_pgcod,
           PN_Scmod,
           PN_Scsuc,
           PN_Scmda,
           PN_Scpap,
           PN_Sccta,
           PN_Scoper,
           PN_Scsbop,
           PN_Sctope,
           PD_FECHASISTEMA,
           LC_HORASISTEMA,
           'G',
           R.FECHA,
           R.MONTO,
           R.RESTA,
           R.DIFERENCIA);
      exception
        when others then
          begin
            insert into jaqz840
              (jaqz840prgm,
               jaqz840nmbvar,
               jaqz840fecproc,
               jaqz840hora,
               jaqz840user,
               jaqz840varin1,
               jaqz840varin2,
               jaqz840varin3,
               jaqz840varin4,
               jaqz840varin5,
               jaqz840varin6,
               jaqz840varin7,
               jaqz840varin8,
               jaqz840varin9,
               jaqz840varin10,
               jaqz840varin11,
               jaqz840varin12,
               jaqz840varin13,
               jaqz840varin14)
            values
              ('CTASUELDO',
               'ABONOS',
               PD_FECHASISTEMA,
               LC_HORASISTEMA,
               'BANTPROD',
               PN_pgcod,
               PN_Scmod,
               PN_Scsuc,
               PN_Scmda,
               PN_Scpap,
               PN_Sccta,
               PN_Scoper,
               PN_Scsbop,
               PN_Sctope,
               'G',
               R.FECHA,
               R.MONTO,
               R.RESTA,
               R.DIFERENCIA);
          EXCEPTION
            when others then
              null;
          end;
      end;
      COMMIT;
    END LOOP;
  
    BEGIN
      SELECT MIN(A.AQPB455MONTO),
             AVG(A.AQPB455MONTO),
             ROUND(MAX(A.AQPB455PORCNT), 0)
        INTO PN_ABON_MIN, PN_ABON_PROM, PN_PRCN_DIF
        FROM AQPB455 A
       WHERE A.AQPB455EST = 'G'
         AND A.AQPB455EMP = PN_pgcod
         AND A.AQPB455MOD = PN_Scmod
         AND A.AQPB455SUC = PN_Scsuc
         AND A.AQPB455MDA = PN_Scmda
         AND A.AQPB455PAP = PN_Scpap
         AND A.AQPB455CTA = PN_Sccta
         AND A.AQPB455OPE = PN_Scoper
         AND A.AQPB455SBOP = PN_Scsbop
         AND A.AQPB455TOPE = PN_Sctope
         AND A.AQPB455FPROC = PD_FECHASISTEMA;
    EXCEPTION
      WHEN OTHERS THEN
        PN_ABON_MIN  := 0;
        PN_ABON_PROM := 0;
    END;
  
    IF PN_ABON_PROM >= 400 THEN
      PV_RESP_PROM := 'S';
    ELSE
      PV_RESP_PROM := 'N';
    END IF;
  
    IF PN_ABON_MIN >= 400 THEN
      PV_RESP_MIN := 'S';
    ELSE
      PV_RESP_MIN := 'N';
    END IF;
  
    IF PN_PRCN_DIF <= 20 THEN
      PV_RESP_DIF := 'S';
    ELSE
      PV_RESP_DIF := 'N';
    END IF;
  
  END SP_CR_CUENTA_ABONOS;
end pq_cr_var_adelantosueldo;
/

