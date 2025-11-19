create or replace package PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS is

  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 17/09/2025 12:15:16
  -- AUTOR DE CREACION           : JALVAROH
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- Purpose                     : REPORTE DE GARANTIAS REALES INSCRITAS
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 13/11/2025
  -- AUTOR DE LA MODIFICACION    : JALVAROH
  -- DESCRIPCION DE MODIFICACION : AGREGAMOS PROCEDIMIENTO PARA LA CALIFICACION DE CREDITOS
  -- ************************************************************************************** 

  PROCEDURE SP_CR_LISTA_GARANTIA(VI_FECHA    IN DATE,
                                 VI_USUARIO  IN VARCHAR2,
                                 VO_CODERROR OUT VARCHAR2,
                                 VO_MSGERROR OUT VARCHAR2);

  --------------------------------------------------------------------------
  PROCEDURE SP_CR_DATOS_TITULAR(VI_CUENTA       IN NUMBER,
                                VI_NOM_TITULAR  OUT VARCHAR2,
                                VI_NDOC_TITULAR OUT CHAR,
                                VI_TIPO_DOC     OUT NUMBER);
  --------------------------------------------------------------------------
  PROCEDURE SP_CR_DATOS_INTEGRANTES(VI_CUENTA           IN NUMBER,
                                    VI_NOM_INTEGRANTES  OUT VARCHAR2,
                                    VI_NDOC_INTEGRANTES OUT VARCHAR2);

  ------------------------------------------------------------------------------
  FUNCTION FN_OBTENER_PPG008Desc(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN CHAR;
  -------------------------------------------------------------------------
  FUNCTION FN_OBTENER_PPG001DATO(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN CHAR;
  ---------------------------------------------------------------------------

  FUNCTION FN_OBTENER_PPG002Dato(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN DATE;

  ----------------------------------------------------------------------------

  FUNCTION FN_OBTENER_PPG004DATO(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN NUMBER;

  -----------------------------------------------------------------------------

  PROCEDURE SP_CR_INSERT_AQPD722(VI_AQPD722COD  IN NUMBER,
                                 VI_AQPD722SUC  IN NUMBER,
                                 VI_AQPD722MOD  IN NUMBER,
                                 VI_AQPD722MDA  IN NUMBER,
                                 VI_AQPD722PAP  IN NUMBER,
                                 VI_AQPD722CTA  IN NUMBER,
                                 VI_AQPD722OPER IN NUMBER,
                                 VI_AQPD722SBOP IN NUMBER,
                                 VI_AQPD722TOPE IN NUMBER,
                                 
                                 VI_AQPD722R1COD  IN NUMBER,
                                 VI_AQPD722R1SUC  IN NUMBER,
                                 VI_AQPD722R1MOD  IN NUMBER,
                                 VI_AQPD722R1MDA  IN NUMBER,
                                 VI_AQPD722R1PAP  IN NUMBER,
                                 VI_AQPD722R1CTA  IN NUMBER,
                                 VI_AQPD722R1OPER IN NUMBER,
                                 VI_AQPD722R1SBOP IN NUMBER,
                                 VI_AQPD722R1TOPE IN NUMBER,
                                 
                                 VI_AQPD722FCHD IN DATE,
                                 -- VI_AQPD722CTAC  IN NUMBER,
                                 -- VI_AQPD722OPEC  IN NUMBER,
                                 VI_AQPD722INST  IN CHAR,
                                 VI_AQPD722TDOCG IN NUMBER,
                                 -- VI_AQPD722TOPEG IN NUMBER,
                                 VI_AQPD722DESG IN CHAR,
                                 -- VI_AQPD722MDAG  IN NUMBER,
                                 VI_AQPD722MTOG  IN NUMBER,
                                 VI_AQPD722RBRO  IN NUMBER,
                                 VI_AQPD722DESEG IN CHAR,
                                 VI_AQPD722TITG  IN CHAR,
                                 -- VI_AQPD722SUCG  IN NUMBER,
                                 -- AQPD722DSUCG  
                                 VI_AQPD722ZONA  IN CHAR,
                                 VI_AQPD722FCHES IN DATE,
                                 VI_AQPD722FCHIS IN DATE,
                                 VI_AQPD722NTRO  IN CHAR,
                                 VI_AQPD722OFIR  IN CHAR,
                                 VI_AQPD722PTDA  IN CHAR,
                                 VI_AQPD722TPOC  IN CHAR,
                                 VI_AQPD722RNGO  IN CHAR,
                                 VI_AQPD722RZON  IN CHAR,
                                 VI_AQPD722DREC  IN CHAR,
                                 VI_AQPD722UBIG  IN CHAR,
                                 VI_AQPD722DIST  IN CHAR,
                                 VI_AQPD722PROV  IN CHAR,
                                 VI_AQPD722DEPR  IN CHAR,
                                 VI_AQPD722FCHTA IN DATE,
                                 VI_AQPD722PRIT  IN CHAR,
                                 VI_AQPD722VALC  IN NUMBER,
                                 VI_AQPD722VALT  IN NUMBER,
                                 VI_AQPD722VALE  IN NUMBER,
                                 VI_AQPD722VALR  IN NUMBER,
                                 VI_AQPD722POLM  IN NUMBER,
                                 VI_AQPD722NROP  IN CHAR,
                                 VI_AQPD722INIP  IN DATE,
                                 VI_AQPD722FINP  IN DATE,
                                 VI_AQPD722TITC  IN CHAR,
                                 -- VI_AQPD722MDAC  IN NUMBER,
                                 VI_AQPD722MTOC IN NUMBER,
                                 VI_AQPD722SLDC IN NUMBER,
                                 VI_AQPD722PLZO IN NUMBER,
                                 VI_AQPD722USUA IN CHAR,
                                 VI_AQPD722ESTC IN CHAR,
                                 VI_AQPD722PSBS IN VARCHAR2,
                                 
                                 VI_AQPD722FCHA  IN DATE,
                                 VI_AQPD722HRAA  IN VARCHAR2,
                                 VI_AQPD722USUA2 IN VARCHAR,
                                 VI_AQPD722DCALF IN VARCHAR2);
  ----------------------------------------------------------------------
  PROCEDURE SP_CR_FECHA_MAXIMA(VI_FECHA OUT DATE);
  ----------------------------------------------------------------------

  PROCEDURE SP_CR_INSTANCIA_TDOC_NDOC_ASE(vi_r1cod      IN NUMBER,
                                          vi_r1suc      IN NUMBER,
                                          vi_r1mod      IN NUMBER,
                                          vi_r1mda      IN NUMBER,
                                          vi_r1pap      IN NUMBER,
                                          vi_r1cta      IN NUMBER,
                                          vi_r1oper     IN NUMBER,
                                          vi_r1sbop     IN NUMBER,
                                          vi_r1tope     IN NUMBER,
                                          VI_INSTANCIA  OUT CHAR,
                                          VI_SNG001TDOC OUT NUMBER,
                                          VI_SNG001NDOC OUT CHAR,
                                          VI_SNG001ASE  OUT VARCHAR2);
  ---------------------------------------------------------------------

  PROCEDURE SP_CR_UBIGEO_DIS_PROV_DEPAR(VI_SNG001TDOC   IN NUMBER,
                                        VI_SNG001NDOC   IN CHAR,
                                        VI_UBIGEO       OUT CHAR,
                                        VI_DISTRITO     OUT CHAR,
                                        VI_PROVINCIA    OUT CHAR,
                                        VI_DEPARTAMENTO OUT CHAR);
  ---------------------------------------------------------------------
  PROCEDURE SP_CR_FSD010(vi_r1cod            IN NUMBER,
                         vi_r1mod            IN NUMBER,
                         vi_r1suc            IN NUMBER,
                         vi_r1mda            IN NUMBER,
                         vi_r1pap            IN NUMBER,
                         vi_r1cta            IN NUMBER,
                         vi_r1oper           IN NUMBER,
                         vi_r1sbop           IN NUMBER,
                         vi_r1tope           IN NUMBER,
                         VI_FECHA_DESEMBOLSO OUT DATE,
                         VI_AOSTAT           OUT NUMBER,
                         VI_CENOM            OUT CHAR,
                         VI_AOIMP            OUT NUMBER,
                         VI_AOPZO            OUT NUMBER);
  ------------------------------------------------------------------------

  PROCEDURE SP_CR_FSD011(vi_r1cod  IN NUMBER,
                         vi_r1suc  IN NUMBER,
                         vi_r1mda  IN NUMBER,
                         vi_r1pap  IN NUMBER,
                         vi_r1cta  IN NUMBER,
                         vi_r1oper IN NUMBER,
                         vi_r1mod  IN NUMBER,
                         vi_r1sbop IN NUMBER,
                         vi_r1tope IN NUMBER,
                         VI_SALDO  OUT NUMBER,
                         VI_SCRUB  OUT NUMBER);
  -------------------------------------------------------------------------
  PROCEDURE SP_CR_CODIGO_SBS(VI_PGCOD   IN NUMBER,
                             VI_CUENTA  IN NUMBER,
                             VI_COD_SBS OUT VARCHAR2);
  --------------------------------------------------------------------------
  PROCEDURE SP_CR_POLIZA_MULTIRR(VI_PGCOD  IN NUMBER,
                                 VI_AOMOD  IN NUMBER,
                                 VI_AOSUC  IN NUMBER,
                                 VI_AOMDA  IN NUMBER,
                                 VI_AOPAP  IN NUMBER,
                                 VI_AOCTA  IN NUMBER,
                                 VI_AOOPER IN NUMBER,
                                 VI_AOSBOP IN NUMBER,
                                 VI_AOTOPE IN NUMBER,
                                 VI_sgcod  OUT NUMBER);
  -------------------------------------------------------------------------
  PROCEDURE SP_CR_CALIFICACION_CREDITO(VI_PGCOD  IN NUMBER,
                                       VI_AOMOD  IN NUMBER,
                                       VI_AOSUC  IN NUMBER,
                                       VI_AOMDA  IN NUMBER,
                                       VI_AOPAP  IN NUMBER,
                                       VI_AOCTA  IN NUMBER,
                                       VI_AOOPER IN NUMBER,
                                       VI_AOSBOP IN NUMBER,
                                       VI_AOTOPE IN NUMBER,
                                       VI_DCALF  OUT VARCHAR2);

end PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS;
/
create or replace package body PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS is

  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 17/09/2025 12:15:16
  -- AUTOR DE CREACION           : JALVAROH
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- Purpose                     : REPORTE DE GARANTIAS REALES INSCRITAS
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 13/11/2025
  -- AUTOR DE LA MODIFICACION    : JALVAROH
  -- DESCRIPCION DE MODIFICACION : AGREGAMOS PROCEDIMIENTO PARA LA CALIFICACION DE CREDITOS
  -- ************************************************************************************** 

  PROCEDURE SP_CR_LISTA_GARANTIA(VI_FECHA    IN DATE,
                                 VI_USUARIO  IN VARCHAR2,
                                 VO_CODERROR OUT VARCHAR2,
                                 VO_MSGERROR OUT VARCHAR2)
  
   IS
    cursor lista_garantias is
      select a.PGCOD,
             a.SCSUC,
             a.SCMDA,
             a.SCPAP,
             a.SCCTA,
             a.SCOPER,
             a.SCSBOP,
             a.SCTOPE,
             a.SCMOD
        from fsd011 a
       where a.PGCOD = 1
         and a.scmod = 70
         and a.scstat = 0
         and a.sctope in (SELECT TP1NRO2
                            FROM fst198
                           WHERE TP1COD1 = 10846
                             AND TP1CORR1 = 80
                             AND TP1CORR2 = 1)
         and a.scstat = 0;
  
    ln_existe       number;
    ln_xwfprcins    number;
    ln_xwfempresa   number;
    ln_xwfmodulo    number;
    ln_xwfmoneda    number;
    ln_xwfpapel     number;
    ln_xwfcuenta    number;
    ln_xwfsucursal  number;
    ln_xwfoperacion number;
    ln_xwfsubope    number;
    ln_xwftipope    number;
    -------- salida de procedimiento --------
    ln_ppg000frm number;
    --------- VARIABLES DE LAS FUNCIONES-----
  
    VI_AQPD722FCHES     DATE;
    VI_AQPD722FCHIS     DATE;
    VI_AQPD722NTRO      CHAR(50);
    VI_AQPD722OFIR      CHAR(50);
    VI_AQPD722TPOC      CHAR(50);
    VI_AQPD722RNGO      CHAR(50);
    VI_AQPD722PRIT      CHAR(50);
    VI_AQPD722PTDA      CHAR(50);
    VI_AQPD722RZON      CHAR(50);
    VI_AQPD722DREC      CHAR(50);
    VI_AQPD722VALC      NUMBER(17, 2);
    VI_AQPD722VALT      NUMBER(17, 2);
    VI_AQPD722VALE      NUMBER(17, 2);
    VI_AQPD722FCHTA     DATE;
    VI_NOM_TITULAR      VARCHAR2(150);
    VI_NDOC_TITULAR     CHAR(12);
    VI_NOM_TITULAR_CRE  VARCHAR2(150);
    VI_NDOC_TITULAR_CRE CHAR(12);
    VI_AQPD722NROP      CHAR(50);
    VI_AQPD722INIP      DATE;
    VI_AQPD722FINP      DATE;
    VI_AQPD722VALR      NUMBER(17, 2);
    VI_AQPD722PSBS      VARCHAR2(10);
    VI_AQPD722POLM      NUMBER(9);
    VI_DCALF            VARCHAR2(50);
  
    VI_HORA VARCHAR2(10);
  
    VI_NOM_INTEGRANTES  VARCHAR2(450);
    VI_NDOC_INTEGRANTES VARCHAR2(450);
    VI_NOMBRE_ARCH      VARCHAR2(150);
  
    v_EXISTE_AQPD722 NUMBER := 0;
  
    --------------------------------------
  
    VI_FECHA_DESEMBOLSO   DATE;
    VI_FECHA_DESEMBOLSO_C DATE;
    VI_FECHA_DESEMBOLSO_G DATE;
  
    ---- clave de credito ----------------
  
    -- Record para R1
    TYPE t_r1 IS RECORD(
      r1cod  fsr011.r1cod%TYPE,
      r1mod  fsr011.r1mod%TYPE,
      r1suc  fsr011.r1suc%TYPE,
      r1mda  fsr011.r1mda%TYPE,
      r1pap  fsr011.r1pap%TYPE,
      r1cta  fsr011.r1cta%TYPE,
      r1oper fsr011.r1oper%TYPE,
      r1sbop fsr011.r1sbop%TYPE,
      r1tope fsr011.r1tope%TYPE);
  
    TYPE t_tabla_r1 IS TABLE OF t_r1 INDEX BY PLS_INTEGER;
    tabla_r1 t_tabla_r1;
    idx      PLS_INTEGER := 0;
  
    vi_r1cod  NUMBER(3);
    vi_r1mod  NUMBER(3);
    vi_r1suc  NUMBER(3);
    vi_r1mda  NUMBER(4);
    vi_r1pap  NUMBER(4);
    vi_r1cta  NUMBER(9);
    vi_r1oper NUMBER(9);
    vi_r1sbop NUMBER(3);
    vi_r1tope NUMBER(3);
  
    VI_INSTANCIA     CHAR(12);
    VI_SNG001NDOC    CHAR(12);
    VI_SNG001TDOC    NUMBER(2);
    VI_DESC_GARANTIA CHAR(30);
    VI_SCRUB         NUMBER(16);
    VI_SCRUB_C       NUMBER(16);
    VI_SCRUB_G       NUMBER(16);
    VI_SALDO         NUMBER(17, 2);
    VI_SALDO_C       NUMBER(17, 2);
    VI_SALDO_G       NUMBER(17, 2);
    VI_SNG001ASE     CHAR(10);
    vi_min_aosbop    NUMBER(3);
  
    VI_COD_REGION   NUMBER(3);
    VI_NOM_REGION   CHAR(40);
    VI_UBIGEO       CHAR(6);
    VI_DISTRITO     CHAR(30);
    VI_PROVINCIA    CHAR(30);
    VI_DEPARTAMENTO CHAR(20);
    VI_TIPO_DOC_G   NUMBER(2);
    VI_TIPO_DOC_C   NUMBER(2);
    VI_AOIMP        NUMBER(17, 2);
    VI_AOIMP_C      NUMBER(17, 2);
    VI_AOIMP_G      NUMBER(17, 2);
    VI_CENOM        CHAR(30);
    VI_CENOM_C      CHAR(30);
    VI_CENOM_G      CHAR(30);
    VI_AOSTAT       NUMBER(2);
    VI_AOSTAT_C     NUMBER(2);
    VI_AOSTAT_G     NUMBER(2);
    VI_AOPZO        NUMBER(5);
    VI_AOPZO_C      NUMBER(5);
    VI_AOPZO_G      NUMBER(5);
  
  BEGIN
    -- validamos si existe datos con la fechas 
    BEGIN
      SELECT 1
        INTO v_EXISTE_AQPD722
        FROM AQPD722 a
       WHERE a.aqpd722fcha = VI_FECHA
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        v_EXISTE_AQPD722 := NULL;
      
    END;
    --  si exite data, procedemos a limpiar 
    IF v_EXISTE_AQPD722 = 1 THEN
      DELETE FROM AQPD722 WHERE aqpd722fcha = VI_FECHA;
      COMMIT;
    END IF;
  
    VI_HORA := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    BEGIN
    
      FOR f IN lista_garantias LOOP
        idx := 0;
        tabla_r1.DELETE;
      
        -------------------------------------------------------------------
        -- Caso 1: FSR011 + FSD010
        -------------------------------------------------------------------
        FOR r IN (SELECT b.r1cod,
                         b.r1mod,
                         b.r1suc,
                         b.r1mda,
                         b.r1pap,
                         b.r1cta,
                         b.r1oper,
                         b.r1sbop,
                         b.r1tope
                    FROM fsr011 b
                    JOIN fsd010 s
                      ON s.pgcod = b.r1cod
                     AND s.aomod = b.r1mod
                     AND s.aosuc = b.r1suc
                     AND s.aomda = b.r1mda
                     AND s.aopap = b.r1pap
                     AND s.aocta = b.r1cta
                     AND s.aooper = b.r1oper
                     AND s.aosbop = b.r1sbop
                     AND s.aotope = b.r1tope
                   WHERE b.r2cod = f.pgcod
                     AND b.r2suc = f.scsuc
                     AND b.r2mda = f.scmda
                     AND b.r2pap = f.scpap
                     AND b.r2cta = f.sccta
                     AND b.r2oper = f.scoper
                     AND b.r2sbop = f.scsbop
                     AND b.r2tope = f.sctope
                     AND b.r2mod = f.scmod
                     AND b.relcod = 50
                     AND s.aostat <> 99
                     AND b.r011co = 'S') LOOP
          idx := idx + 1;
          tabla_r1(idx).r1cod := r.r1cod;
          tabla_r1(idx).r1mod := r.r1mod;
          tabla_r1(idx).r1suc := r.r1suc;
          tabla_r1(idx).r1mda := r.r1mda;
          tabla_r1(idx).r1pap := r.r1pap;
          tabla_r1(idx).r1cta := r.r1cta;
          tabla_r1(idx).r1oper := r.r1oper;
          tabla_r1(idx).r1sbop := r.r1sbop;
          tabla_r1(idx).r1tope := r.r1tope;
        END LOOP;
      
        -------------------------------------------------------------------
        -- Caso 2: solo si no hubo registros en Caso 1
        -------------------------------------------------------------------
        IF tabla_r1.COUNT = 0 THEN
          FOR r2 IN (SELECT x.xwfempresa   AS r1cod,
                            x.xwfmodulo    AS r1mod,
                            x.xwfsucursal  AS r1suc,
                            x.xwfmoneda    AS r1mda,
                            x.xwfpapel     AS r1pap,
                            x.xwfcuenta    AS r1cta,
                            x.xwfoperacion AS r1oper,
                            x.xwfsubope    AS r1sbop,
                            x.xwftipope    AS r1tope
                       FROM sng122 s
                       JOIN xwf700 x
                         ON x.xwfprcins = s.sng122inst
                       JOIN wfwrkitems w
                         ON w.wfinsprcid = x.xwfprcins
                      WHERE s.sng122pgc = f.pgcod
                        AND s.sng122mod = f.scmod
                        AND s.sng122suc = f.scsuc
                        AND s.sng122mda = f.scmda
                        AND s.sng122pap = f.scpap
                        AND s.sng122cta = f.sccta
                        AND s.sng122oper = f.scoper
                        AND s.sng122sbop = f.scsbop
                        AND s.sng122tope = f.sctope
                        AND x.xwfcar3 = '1'
                        AND w.wftaskcod IN (7, 11, 55)
                        AND w.wfitemstsact = 1) LOOP
            idx := idx + 1;
            tabla_r1(idx).r1cod := r2.r1cod;
            tabla_r1(idx).r1mod := r2.r1mod;
            tabla_r1(idx).r1suc := r2.r1suc;
            tabla_r1(idx).r1mda := r2.r1mda;
            tabla_r1(idx).r1pap := r2.r1pap;
            tabla_r1(idx).r1cta := r2.r1cta;
            tabla_r1(idx).r1oper := r2.r1oper;
            tabla_r1(idx).r1sbop := r2.r1sbop;
            tabla_r1(idx).r1tope := r2.r1tope;
          END LOOP;
        END IF;
      
        IF tabla_r1.COUNT > 0 THEN
        
          /*  dbms_output.put_line('Garantías:-' || f.pgcod || '-' || f.SCSUC || '-' ||
          f.SCMOD || '-' || f.SCMDA || '-' || f.SCPAP || '-' ||
          f.SCCTA || '-' || f.SCOPER || '-' ||
          f.SCSBOP || '-' || f.SCTOPE); */
        
          -- Sacamos la fecha de desembolso con tada la clave de credito
        
          FOR i IN 1 .. tabla_r1.COUNT LOOP
            vi_r1cod  := tabla_r1(i).r1cod;
            vi_r1mod  := tabla_r1(i).r1mod;
            vi_r1suc  := tabla_r1(i).r1suc;
            vi_r1mda  := tabla_r1(i).r1mda;
            vi_r1pap  := tabla_r1(i).r1pap;
            vi_r1cta  := tabla_r1(i).r1cta;
            vi_r1oper := tabla_r1(i).r1oper;
            vi_r1sbop := tabla_r1(i).r1sbop;
            vi_r1tope := tabla_r1(i).r1tope;
          
            /* DBMS_OUTPUT.PUT_LINE('Procesando R1 => ' || vi_r1cod || '-' ||
            vi_r1mod); */
          
            -- obtenemos la minima suboperacion 
            SELECT MIN(b.aosbop)
              into vi_min_aosbop
              FROM fsd010 b
             WHERE b.pgcod = vi_r1cod
               AND b.aomod = vi_r1mod
               AND b.aosuc = vi_r1suc
               AND b.aomda = vi_r1mda
               AND b.aopap = vi_r1pap
               AND b.aocta = vi_r1cta
               AND b.aooper = vi_r1oper
               AND b.aotope = vi_r1tope;
          
            -- fecha de desembolso por la clave de credito
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_FSD010(vi_r1cod            => vi_r1cod,
                                                                  vi_r1mod            => vi_r1mod,
                                                                  vi_r1suc            => vi_r1suc,
                                                                  vi_r1mda            => vi_r1mda,
                                                                  vi_r1pap            => vi_r1pap,
                                                                  vi_r1cta            => vi_r1cta,
                                                                  vi_r1oper           => vi_r1oper,
                                                                  vi_r1sbop           => vi_min_aosbop,
                                                                  vi_r1tope           => vi_r1tope,
                                                                  VI_FECHA_DESEMBOLSO => VI_FECHA_DESEMBOLSO,
                                                                  VI_AOSTAT           => VI_AOSTAT,
                                                                  VI_CENOM            => VI_CENOM, -- char 30
                                                                  VI_AOIMP            => VI_AOIMP, -- number 17,2
                                                                  VI_AOPZO            => VI_AOPZO);
          
            -- Credito  OBTENEMOS fecha desembolso, estado, descripcion, monto                                                      
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_FSD010(vi_r1cod            => vi_r1cod,
                                                                  vi_r1mod            => vi_r1mod,
                                                                  vi_r1suc            => vi_r1suc,
                                                                  vi_r1mda            => vi_r1mda,
                                                                  vi_r1pap            => vi_r1pap,
                                                                  vi_r1cta            => vi_r1cta,
                                                                  vi_r1oper           => vi_r1oper,
                                                                  vi_r1sbop           => vi_r1sbop,
                                                                  vi_r1tope           => vi_r1tope,
                                                                  VI_FECHA_DESEMBOLSO => VI_FECHA_DESEMBOLSO_C,
                                                                  VI_AOSTAT           => VI_AOSTAT_C, -- NUMBER 2
                                                                  VI_CENOM            => VI_CENOM_C, -- char 30
                                                                  VI_AOIMP            => VI_AOIMP_C, -- number 17,2
                                                                  VI_AOPZO            => VI_AOPZO_C); -- number 5
          
            -- Garantia OBTENEMOS fecha desembolso, estado, descripcion, monto                                                     
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_FSD010(vi_r1cod            => f.pgcod,
                                                                  vi_r1mod            => f.SCMOD,
                                                                  vi_r1suc            => f.SCSUC,
                                                                  vi_r1mda            => f.SCMDA,
                                                                  vi_r1pap            => f.SCPAP,
                                                                  vi_r1cta            => f.SCCTA,
                                                                  vi_r1oper           => f.SCOPER,
                                                                  vi_r1sbop           => f.SCSBOP,
                                                                  vi_r1tope           => f.SCTOPE,
                                                                  VI_FECHA_DESEMBOLSO => VI_FECHA_DESEMBOLSO_G,
                                                                  VI_AOSTAT           => VI_AOSTAT_G,
                                                                  VI_CENOM            => VI_CENOM_G, -- char 30
                                                                  VI_AOIMP            => VI_AOIMP_G, -- number 17,2
                                                                  VI_AOPZO            => VI_AOPZO_G);
          
            -- obtenemos las instancia clave de credito asi como el asesor           
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_INSTANCIA_TDOC_NDOC_ASE(vi_r1cod      => vi_r1cod,
                                                                                   vi_r1suc      => vi_r1suc,
                                                                                   vi_r1mod      => vi_r1mod,
                                                                                   vi_r1mda      => vi_r1mda,
                                                                                   vi_r1pap      => vi_r1pap,
                                                                                   vi_r1cta      => vi_r1cta,
                                                                                   vi_r1oper     => vi_r1oper,
                                                                                   vi_r1sbop     => vi_r1sbop,
                                                                                   vi_r1tope     => vi_r1tope,
                                                                                   VI_INSTANCIA  => VI_INSTANCIA,
                                                                                   VI_SNG001TDOC => VI_SNG001TDOC,
                                                                                   VI_SNG001NDOC => VI_SNG001NDOC,
                                                                                   VI_SNG001ASE  => VI_SNG001ASE);
          
            -- sacamos la description de la garantia
            BEGIN
              select TONOM
                INTO VI_DESC_GARANTIA
                from fst004
               where modulo = f.SCMOD
                 and totope = f.SCTOPE;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          
            -- Obtenemos la zona de la Garantia    
            BEGIN
              select REGCOD
                into VI_COD_REGION -- NUMBER(3)
                from Fst811 ---Relacion Zona- Sucursal
                       Where PgCod = 1 and RegCod < 100 and OfiCod = f.SCSUC; --obtengo el código de la zona  colocando en oficod la sucursal
            
              select REGNOM
                into VI_NOM_REGION -- CHAR(40)
                from Fst810 --obtengo el nombre de la zona 
                       Where PgCod = 1 and RegCod = VI_COD_REGION and RegCod < 100; --coloco el código de la zona 
            
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          
            -- optenemos ubigeo por cliente 
            -- optenemos distrito / provincia / departamento 
          
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_UBIGEO_DIS_PROV_DEPAR(VI_SNG001TDOC   => VI_SNG001TDOC,
                                                                                 VI_SNG001NDOC   => VI_SNG001NDOC,
                                                                                 VI_UBIGEO       => VI_UBIGEO,
                                                                                 VI_DISTRITO     => VI_DISTRITO,
                                                                                 VI_PROVINCIA    => VI_PROVINCIA,
                                                                                 VI_DEPARTAMENTO => VI_DEPARTAMENTO);
          
            -- obtenemso el saldo por la clave de credito r1                                                                  
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_FSD011(vi_r1cod  => vi_r1cod,
                                                                  vi_r1suc  => vi_r1suc,
                                                                  vi_r1mda  => vi_r1mda,
                                                                  vi_r1pap  => vi_r1pap,
                                                                  vi_r1cta  => vi_r1cta,
                                                                  vi_r1oper => vi_r1oper,
                                                                  vi_r1mod  => vi_r1mod,
                                                                  vi_r1sbop => vi_r1sbop,
                                                                  vi_r1tope => vi_r1tope,
                                                                  VI_SALDO  => VI_SALDO_C,
                                                                  VI_SCRUB  => VI_SCRUB_C);
          
            -- Obtenemos la calificacion de credito
          
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_CALIFICACION_CREDITO(VI_PGCOD  => vi_r1cod,
                                                                                VI_AOMOD  => vi_r1mod,
                                                                                VI_AOSUC  => vi_r1suc,
                                                                                VI_AOMDA  => vi_r1mda,
                                                                                VI_AOPAP  => vi_r1pap,
                                                                                VI_AOCTA  => vi_r1cta,
                                                                                VI_AOOPER => vi_r1oper,
                                                                                VI_AOSBOP => vi_r1sbop,
                                                                                VI_AOTOPE => vi_r1tope,
                                                                                VI_DCALF  => VI_DCALF);
          
            -- obtenemso el saldo por la clave de garantia r2                                                  
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_FSD011(vi_r1cod  => f.pgcod,
                                                                  vi_r1suc  => f.SCSUC,
                                                                  vi_r1mda  => f.SCMDA,
                                                                  vi_r1pap  => f.SCPAP,
                                                                  vi_r1cta  => f.SCCTA,
                                                                  vi_r1oper => f.SCOPER,
                                                                  vi_r1mod  => f.SCMOD,
                                                                  vi_r1sbop => f.SCSBOP,
                                                                  vi_r1tope => f.SCTOPE,
                                                                  VI_SALDO  => VI_SALDO_G,
                                                                  VI_SCRUB  => VI_SCRUB_G);
          
            -- Sacamos el titular de la garantia 
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_DATOS_TITULAR(VI_CUENTA       => f.SCCTA,
                                                                         VI_NOM_TITULAR  => VI_NOM_TITULAR,
                                                                         VI_NDOC_TITULAR => VI_NDOC_TITULAR,
                                                                         VI_TIPO_DOC     => VI_TIPO_DOC_G);
          
            -- Sacamos el titular de credito
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_DATOS_TITULAR(VI_CUENTA       => vi_r1cta,
                                                                         VI_NOM_TITULAR  => VI_NOM_TITULAR_CRE,
                                                                         VI_NDOC_TITULAR => VI_NDOC_TITULAR_CRE,
                                                                         VI_TIPO_DOC     => VI_TIPO_DOC_C);
          
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_DATOS_INTEGRANTES(VI_CUENTA           => f.SCCTA,
                                                                             VI_NOM_INTEGRANTES  => VI_NOM_INTEGRANTES,
                                                                             VI_NDOC_INTEGRANTES => VI_NDOC_INTEGRANTES);
          
            -- Obtenemos el codigo sbs 
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_CODIGO_SBS(VI_PGCOD   => f.pgcod, -- R2 Garantia
                                                                      VI_CUENTA  => f.SCCTA, -- R2
                                                                      VI_COD_SBS => VI_AQPD722PSBS);
          
            -- POLIZA MULTIRR. GARANTIA                                                             
            PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_POLIZA_MULTIRR(VI_PGCOD  => vi_r1cod,
                                                                          VI_AOMOD  => vi_r1mod,
                                                                          VI_AOSUC  => vi_r1suc,
                                                                          VI_AOMDA  => vi_r1mda,
                                                                          VI_AOPAP  => vi_r1pap,
                                                                          VI_AOCTA  => vi_r1cta,
                                                                          VI_AOOPER => vi_r1oper,
                                                                          VI_AOSBOP => vi_r1sbop,
                                                                          VI_AOTOPE => vi_r1tope,
                                                                          VI_sgcod  => VI_AQPD722POLM);
          
            -- fecha de escritura 
            VI_AQPD722FCHES := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG002Dato(VI_ppg000pgc => f.pgcod,
                                                                                              VI_ppg000suc => f.SCSUC,
                                                                                              VI_ppg000mda => f.SCMDA,
                                                                                              VI_ppg000pap => f.SCPAP,
                                                                                              VI_ppg000cta => f.SCCTA,
                                                                                              VI_ppg000ope => f.SCOPER,
                                                                                              VI_ppg000sbo => f.SCSBOP,
                                                                                              VI_ppg000top => f.SCTOPE,
                                                                                              VI_cdat      => 93);
          
            -- fecha de inscripcion                                                                            
            VI_AQPD722FCHIS := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG002Dato(VI_ppg000pgc => f.pgcod,
                                                                                              VI_ppg000suc => f.SCSUC,
                                                                                              VI_ppg000mda => f.SCMDA,
                                                                                              VI_ppg000pap => f.SCPAP,
                                                                                              VI_ppg000cta => f.SCCTA,
                                                                                              VI_ppg000ope => f.SCOPER,
                                                                                              VI_ppg000sbo => f.SCSBOP,
                                                                                              VI_ppg000top => f.SCTOPE,
                                                                                              VI_cdat      => 95);
          
            -- notario      
            VI_AQPD722NTRO := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 109);
          
            -- oficina registral 
            VI_AQPD722OFIR := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 69);
          
            -- partida                                                                          
            VI_AQPD722PTDA := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG001DATO(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 129);
          
            -- tipo cobertura 
            VI_AQPD722TPOC := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 108);
          
            -- rango inscripcion 
            VI_AQPD722RNGO := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 149);
          
            -- razon 
            VI_AQPD722RZON := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG001DATO(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 143);
          
            -- direccion 
          
            VI_AQPD722DREC := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG001DATO(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 41);
          
            -- fecha de tasacion                                                                                                                                                 
            VI_AQPD722FCHTA := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG002Dato(VI_ppg000pgc => f.pgcod,
                                                                                              VI_ppg000suc => f.SCSUC,
                                                                                              VI_ppg000mda => f.SCMDA,
                                                                                              VI_ppg000pap => f.SCPAP,
                                                                                              VI_ppg000cta => f.SCCTA,
                                                                                              VI_ppg000ope => f.SCOPER,
                                                                                              VI_ppg000sbo => f.SCSBOP,
                                                                                              VI_ppg000top => f.SCTOPE,
                                                                                              VI_cdat      => 77);
          
            -- perito 
            VI_AQPD722PRIT := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 121);
          
            -- valor comercial 
            VI_AQPD722VALC := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG004DATO(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 63);
          
            -- valor terreno 
            VI_AQPD722VALT := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG004DATO(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 62);
          
            -- valor edificacion 
            VI_AQPD722VALE := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG004DATO(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 67);
          
            -- valor realizacion         
            VI_AQPD722VALR := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG004DATO(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 136);
          
            -- nro de poliza 
            VI_AQPD722NROP := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG001DATO(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 155);
          
            -- FECHA inicio de poliza 
            VI_AQPD722INIP := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG002Dato(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 101);
          
            -- FECHA fin de poliza                                                                                  
            VI_AQPD722FINP := PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.FN_OBTENER_PPG002Dato(VI_ppg000pgc => f.pgcod,
                                                                                             VI_ppg000suc => f.SCSUC,
                                                                                             VI_ppg000mda => f.SCMDA,
                                                                                             VI_ppg000pap => f.SCPAP,
                                                                                             VI_ppg000cta => f.SCCTA,
                                                                                             VI_ppg000ope => f.SCOPER,
                                                                                             VI_ppg000sbo => f.SCSBOP,
                                                                                             VI_ppg000top => f.SCTOPE,
                                                                                             VI_cdat      => 102);
          
            BEGIN
            
              -- r2 agrantia 
              -- r1 credito 
            
              PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS.SP_CR_INSERT_AQPD722(VI_AQPD722COD    => f.pgcod, -- R2 Garantia 
                                                                            VI_AQPD722SUC    => f.SCSUC, -- R2
                                                                            VI_AQPD722MOD    => f.SCMOD, -- R2
                                                                            VI_AQPD722MDA    => f.SCMDA, -- R2
                                                                            VI_AQPD722PAP    => f.SCPAP, -- R2
                                                                            VI_AQPD722CTA    => f.SCCTA, -- R2
                                                                            VI_AQPD722OPER   => f.SCOPER, -- R2
                                                                            VI_AQPD722SBOP   => f.SCSBOP, -- R2
                                                                            VI_AQPD722TOPE   => f.SCTOPE, -- R2
                                                                            VI_AQPD722R1COD  => vi_r1cod,
                                                                            VI_AQPD722R1SUC  => vi_r1mod,
                                                                            VI_AQPD722R1MOD  => vi_r1suc,
                                                                            VI_AQPD722R1MDA  => vi_r1mda,
                                                                            VI_AQPD722R1PAP  => vi_r1pap,
                                                                            VI_AQPD722R1CTA  => vi_r1cta,
                                                                            VI_AQPD722R1OPER => vi_r1oper,
                                                                            VI_AQPD722R1SBOP => vi_r1sbop,
                                                                            VI_AQPD722R1TOPE => vi_r1tope,
                                                                            VI_AQPD722FCHD   => VI_FECHA_DESEMBOLSO,
                                                                            VI_AQPD722INST   => VI_INSTANCIA,
                                                                            VI_AQPD722TDOCG  => VI_TIPO_DOC_G,
                                                                            VI_AQPD722DESG   => VI_DESC_GARANTIA,
                                                                            VI_AQPD722MTOG   => VI_AOIMP_G, -- number 17,2 
                                                                            VI_AQPD722RBRO   => VI_SCRUB_G,
                                                                            VI_AQPD722DESEG  => VI_CENOM_G, --CHAR 30 
                                                                            VI_AQPD722TITG   => VI_NOM_TITULAR,
                                                                            VI_AQPD722ZONA   => VI_NOM_REGION,
                                                                            VI_AQPD722FCHES  => VI_AQPD722FCHES,
                                                                            VI_AQPD722FCHIS  => VI_AQPD722FCHIS,
                                                                            VI_AQPD722NTRO   => VI_AQPD722NTRO,
                                                                            VI_AQPD722OFIR   => VI_AQPD722OFIR,
                                                                            VI_AQPD722PTDA   => VI_AQPD722PTDA,
                                                                            VI_AQPD722TPOC   => VI_AQPD722TPOC,
                                                                            VI_AQPD722RNGO   => VI_AQPD722RNGO,
                                                                            VI_AQPD722RZON   => VI_AQPD722RZON,
                                                                            VI_AQPD722DREC   => VI_AQPD722DREC,
                                                                            VI_AQPD722UBIG   => VI_UBIGEO, --CHAR 6
                                                                            VI_AQPD722DIST   => VI_DISTRITO,
                                                                            VI_AQPD722PROV   => VI_PROVINCIA,
                                                                            VI_AQPD722DEPR   => VI_DEPARTAMENTO,
                                                                            VI_AQPD722FCHTA  => VI_AQPD722FCHTA,
                                                                            VI_AQPD722PRIT   => VI_AQPD722PRIT,
                                                                            VI_AQPD722VALC   => VI_AQPD722VALC,
                                                                            VI_AQPD722VALT   => VI_AQPD722VALT,
                                                                            VI_AQPD722VALE   => VI_AQPD722VALE,
                                                                            VI_AQPD722VALR   => VI_AQPD722VALR,
                                                                            VI_AQPD722POLM   => VI_AQPD722POLM,
                                                                            VI_AQPD722NROP   => VI_AQPD722NROP,
                                                                            VI_AQPD722INIP   => VI_AQPD722INIP,
                                                                            VI_AQPD722FINP   => VI_AQPD722FINP,
                                                                            VI_AQPD722TITC   => VI_NOM_TITULAR_CRE,
                                                                            VI_AQPD722MTOC   => VI_AOIMP_C, -- number 17,2
                                                                            VI_AQPD722SLDC   => VI_SALDO_C,
                                                                            VI_AQPD722PLZO   => VI_AOPZO_C, -- NUMBER 5
                                                                            VI_AQPD722USUA   => VI_SNG001ASE,
                                                                            VI_AQPD722ESTC   => VI_AOSTAT_C, -- number 2
                                                                            VI_AQPD722PSBS   => VI_AQPD722PSBS,
                                                                            VI_AQPD722FCHA   => VI_FECHA,
                                                                            VI_AQPD722HRAA   => VI_HORA,
                                                                            VI_AQPD722USUA2  => VI_USUARIO,
                                                                            VI_AQPD722DCALF  => VI_DCALF);
            
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
              
            END;
          
          --      ELSE
          END LOOP;
        end if;
      
      end loop;
    
    END;
  
  END SP_CR_LISTA_GARANTIA;

  PROCEDURE SP_CR_DATOS_TITULAR(VI_CUENTA       IN NUMBER,
                                VI_NOM_TITULAR  OUT VARCHAR2,
                                VI_NDOC_TITULAR OUT CHAR,
                                VI_TIPO_DOC     OUT NUMBER) IS
  
  BEGIN
  
    BEGIN
      SELECT PENDOC, PETDOC
        INTO VI_NDOC_TITULAR, VI_TIPO_DOC
        FROM fsr008 F
       WHERE F.ctnro = VI_CUENTA
         AND F.CTTFIR = 'T';
    EXCEPTION
      WHEN OTHERS THEN
        VI_NDOC_TITULAR := NULL;
      
    END;
  
    BEGIN
      SELECT PENOM
        INTO VI_NOM_TITULAR
        FROM fsd001
       WHERE pendoc = VI_NDOC_TITULAR;
    EXCEPTION
      WHEN OTHERS THEN
        VI_NDOC_TITULAR := NULL;
      
    END;
  
  END SP_CR_DATOS_TITULAR;

  PROCEDURE SP_CR_DATOS_INTEGRANTES(VI_CUENTA           IN NUMBER,
                                    VI_NOM_INTEGRANTES  OUT VARCHAR2,
                                    VI_NDOC_INTEGRANTES OUT VARCHAR2) IS
    -- Variables locales
    CURSOR C_DOCS IS
      SELECT PENDOC
        FROM fsr008 F
       WHERE F.ctnro = VI_CUENTA
         AND F.CTTFIR <> 'T';
  
    V_DOC VARCHAR2(450);
    V_NOM VARCHAR2(450);
  BEGIN
    -- Inicializa las variables de salida
    VI_NDOC_INTEGRANTES := '';
    VI_NOM_INTEGRANTES  := '';
  
    -- Recorre los documentos
    FOR R_DOC IN C_DOCS LOOP
      V_DOC := R_DOC.PENDOC;
    
      -- Concatenar documento con ;
      IF VI_NDOC_INTEGRANTES IS NOT NULL THEN
        VI_NDOC_INTEGRANTES := TRIM(VI_NDOC_INTEGRANTES) || '; ';
      END IF;
      VI_NDOC_INTEGRANTES := TRIM(V_DOC);
    
      -- Buscar nombre correspondiente
      BEGIN
        SELECT PENOM INTO V_NOM FROM fsd001 WHERE pendoc = V_DOC;
      
        -- Concatenar nombre con ;
        IF VI_NOM_INTEGRANTES IS NOT NULL THEN
          VI_NOM_INTEGRANTES := TRIM(VI_NOM_INTEGRANTES) || '; ';
        END IF;
        VI_NOM_INTEGRANTES := TRIM(V_NOM);
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL; -- Si no encuentra nombre, simplemente continúa
        WHEN OTHERS THEN
          NULL; -- Manejo general de errores
      END;
    END LOOP;
  END SP_CR_DATOS_INTEGRANTES;

  FUNCTION FN_OBTENER_PPG008Desc(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN CHAR IS
  
    VI_PPG008Desc CHAR(50);
  
  BEGIN
  
    BEGIN
      SELECT PPG008DESC
        INTO VI_PPG008Desc
        FROM ppg000 p
       INNER JOIN ppg008 a
          ON a.ppg008pgc = p.ppg000pgc
         AND a.PPG008MOD = p.ppg000mod
         AND a.PPG008SUC = p.ppg000suc
         AND a.PPG008MDA = p.ppg000mda
         AND a.PPG008PAP = p.ppg000pap
         AND a.PPG008CTA = p.ppg000cta
         AND a.PPG008OPE = p.ppg000ope
         AND a.PPG008SBO = p.ppg000sbo
         AND a.PPG008TOP = p.ppg000top
         AND a.ppg008frm = p.ppg000frm
         AND a.ppg008cdat = VI_cdat
       WHERE p.ppg000pgc = VI_ppg000pgc
         AND p.ppg000suc = VI_ppg000suc
         AND p.ppg000mda = VI_ppg000mda
         AND p.ppg000pap = VI_ppg000pap
         AND p.ppg000cta = VI_ppg000cta
         AND p.ppg000ope = VI_ppg000ope
         AND p.ppg000sbo = VI_ppg000sbo
         AND p.ppg000top = VI_ppg000top
         AND p.ppg000tco = 'S';
    
    EXCEPTION
      WHEN OTHERS THEN
      
        NULL;
    END;
  
    RETURN TRIM(VI_PPG008Desc);
  
  END FN_OBTENER_PPG008Desc;

  FUNCTION FN_OBTENER_PPG001DATO(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN CHAR IS
  
    VI_PPG001DATO CHAR(50);
  
  BEGIN
  
    BEGIN
      SELECT PPG001DATO
        INTO VI_PPG001DATO
        FROM ppg000 p
       INNER JOIN ppg001 a
          ON a.ppg001cod = p.ppg000pgc
         AND a.ppg001mod = p.ppg000mod
         AND a.ppg001suc = p.ppg000suc
         AND a.ppg001mda = p.ppg000mda
         AND a.ppg001pap = p.ppg000pap
         AND a.ppg001cta = p.ppg000cta
         AND a.ppg001ope = p.ppg000ope
         AND a.ppg001sbo = p.ppg000sbo
         AND a.ppg001top = p.ppg000top
         AND a.ppg001frm = p.ppg000frm
         AND a.ppg001cdat = VI_cdat
       WHERE p.ppg000pgc = VI_ppg000pgc
         AND p.ppg000suc = VI_ppg000suc
         AND p.ppg000mda = VI_ppg000mda
         AND p.ppg000pap = VI_ppg000pap
         AND p.ppg000cta = VI_ppg000cta
         AND p.ppg000ope = VI_ppg000ope
         AND p.ppg000sbo = VI_ppg000sbo
         AND p.ppg000top = VI_ppg000top
         AND p.ppg000tco = 'S';
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    RETURN TRIM(VI_PPG001DATO);
  
  END FN_OBTENER_PPG001DATO;

  FUNCTION FN_OBTENER_PPG002Dato(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN DATE IS
  
    VI_PPG002DATO DATE;
  
  BEGIN
  
    BEGIN
      SELECT PPG002DATO
        INTO VI_PPG002DATO
        FROM ppg000 p
       INNER JOIN ppg002 a
          ON a.ppg002cod = p.ppg000pgc
         AND a.ppg002mod = p.ppg000mod
         AND a.ppg002suc = p.ppg000suc
         AND a.ppg002mda = p.ppg000mda
         AND a.ppg002pap = p.ppg000pap
         AND a.ppg002cta = p.ppg000cta
         AND a.ppg002ope = p.ppg000ope
         AND a.ppg002sbo = p.ppg000sbo
         AND a.ppg002top = p.ppg000top
         AND a.ppg002frm = p.ppg000frm
         AND a.ppg002cdat = VI_cdat
       WHERE p.ppg000pgc = VI_ppg000pgc
         AND p.ppg000suc = VI_ppg000suc
         AND p.ppg000mda = VI_ppg000mda
         AND p.ppg000pap = VI_ppg000pap
         AND p.ppg000cta = VI_ppg000cta
         AND p.ppg000ope = VI_ppg000ope
         AND p.ppg000sbo = VI_ppg000sbo
         AND p.ppg000top = VI_ppg000top
         AND p.ppg000tco = 'S';
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    RETURN VI_PPG002DATO;
  
  END FN_OBTENER_PPG002Dato;

  FUNCTION FN_OBTENER_PPG004DATO(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN NUMBER IS
  
    VI_PPG004DATO number(17, 2);
  
  BEGIN
  
    BEGIN
      SELECT PPG004DATO
        INTO VI_PPG004DATO
        FROM ppg000 p
       INNER JOIN ppg004 a
          ON a.ppg004cod = p.ppg000pgc
         AND a.ppg004mod = p.ppg000mod
         AND a.ppg004suc = p.ppg000suc
         AND a.ppg004mda = p.ppg000mda
         AND a.ppg004pap = p.ppg000pap
         AND a.ppg004cta = p.ppg000cta
         AND a.ppg004ope = p.ppg000ope
         AND a.ppg004sbo = p.ppg000sbo
         AND a.ppg004top = p.ppg000top
         AND a.ppg004frm = p.ppg000frm
         AND a.ppg004cdat = VI_cdat
       WHERE p.ppg000pgc = VI_ppg000pgc
         AND p.ppg000suc = VI_ppg000suc
         AND p.ppg000mda = VI_ppg000mda
         AND p.ppg000pap = VI_ppg000pap
         AND p.ppg000cta = VI_ppg000cta
         AND p.ppg000ope = VI_ppg000ope
         AND p.ppg000sbo = VI_ppg000sbo
         AND p.ppg000top = VI_ppg000top
         AND p.ppg000tco = 'S';
    
    EXCEPTION
      WHEN OTHERS THEN
      
        NULL;
    END;
  
    RETURN VI_PPG004DATO;
  
  END FN_OBTENER_PPG004DATO;

  PROCEDURE SP_CR_INSERT_AQPD722(VI_AQPD722COD  IN NUMBER,
                                 VI_AQPD722SUC  IN NUMBER,
                                 VI_AQPD722MOD  IN NUMBER,
                                 VI_AQPD722MDA  IN NUMBER,
                                 VI_AQPD722PAP  IN NUMBER,
                                 VI_AQPD722CTA  IN NUMBER,
                                 VI_AQPD722OPER IN NUMBER,
                                 VI_AQPD722SBOP IN NUMBER,
                                 VI_AQPD722TOPE IN NUMBER,
                                 
                                 VI_AQPD722R1COD  IN NUMBER,
                                 VI_AQPD722R1SUC  IN NUMBER,
                                 VI_AQPD722R1MOD  IN NUMBER,
                                 VI_AQPD722R1MDA  IN NUMBER,
                                 VI_AQPD722R1PAP  IN NUMBER,
                                 VI_AQPD722R1CTA  IN NUMBER,
                                 VI_AQPD722R1OPER IN NUMBER,
                                 VI_AQPD722R1SBOP IN NUMBER,
                                 VI_AQPD722R1TOPE IN NUMBER,
                                 
                                 VI_AQPD722FCHD IN DATE,
                                 -- VI_AQPD722CTAC  IN NUMBER,
                                 -- VI_AQPD722OPEC  IN NUMBER,
                                 VI_AQPD722INST  IN CHAR,
                                 VI_AQPD722TDOCG IN NUMBER,
                                 -- VI_AQPD722TOPEG IN NUMBER,
                                 VI_AQPD722DESG IN CHAR,
                                 -- VI_AQPD722MDAG  IN NUMBER,
                                 VI_AQPD722MTOG  IN NUMBER,
                                 VI_AQPD722RBRO  IN NUMBER,
                                 VI_AQPD722DESEG IN CHAR,
                                 VI_AQPD722TITG  IN CHAR,
                                 -- VI_AQPD722SUCG  IN NUMBER,
                                 -- AQPD722DSUCG  
                                 VI_AQPD722ZONA  IN CHAR,
                                 VI_AQPD722FCHES IN DATE,
                                 VI_AQPD722FCHIS IN DATE,
                                 VI_AQPD722NTRO  IN CHAR,
                                 VI_AQPD722OFIR  IN CHAR,
                                 VI_AQPD722PTDA  IN CHAR,
                                 VI_AQPD722TPOC  IN CHAR,
                                 VI_AQPD722RNGO  IN CHAR,
                                 VI_AQPD722RZON  IN CHAR,
                                 VI_AQPD722DREC  IN CHAR,
                                 VI_AQPD722UBIG  IN CHAR,
                                 VI_AQPD722DIST  IN CHAR,
                                 VI_AQPD722PROV  IN CHAR,
                                 VI_AQPD722DEPR  IN CHAR,
                                 VI_AQPD722FCHTA IN DATE,
                                 VI_AQPD722PRIT  IN CHAR,
                                 VI_AQPD722VALC  IN NUMBER,
                                 VI_AQPD722VALT  IN NUMBER,
                                 VI_AQPD722VALE  IN NUMBER,
                                 VI_AQPD722VALR  IN NUMBER,
                                 VI_AQPD722POLM  IN NUMBER,
                                 VI_AQPD722NROP  IN CHAR,
                                 VI_AQPD722INIP  IN DATE,
                                 VI_AQPD722FINP  IN DATE,
                                 VI_AQPD722TITC  IN CHAR,
                                 -- VI_AQPD722MDAC  IN NUMBER,
                                 VI_AQPD722MTOC IN NUMBER,
                                 VI_AQPD722SLDC IN NUMBER,
                                 VI_AQPD722PLZO IN NUMBER,
                                 VI_AQPD722USUA IN CHAR,
                                 VI_AQPD722ESTC IN CHAR,
                                 VI_AQPD722PSBS IN VARCHAR2,
                                 
                                 VI_AQPD722FCHA  IN DATE,
                                 VI_AQPD722HRAA  IN VARCHAR2,
                                 VI_AQPD722USUA2 IN VARCHAR,
                                 VI_AQPD722DCALF IN VARCHAR2) IS
  
  BEGIN
  
    INSERT INTO AQPD722
      (
       
       AQPD722COD,
       AQPD722SUC,
       AQPD722MOD,
       AQPD722MDA,
       AQPD722PAP,
       AQPD722CTA,
       AQPD722OPER,
       AQPD722SBOP,
       AQPD722TOPE,
       AQPD722R1COD,
       AQPD722R1SUC,
       AQPD722R1MOD,
       AQPD722R1MDA,
       AQPD722R1PAP,
       AQPD722R1CTA,
       AQPD722R1OPER,
       AQPD722R1SBOP,
       AQPD722R1TOPE,
       AQPD722FCHD,
       -- AQPD722CTAC,
       -- AQPD722OPEC,
       AQPD722INST,
       AQPD722TDOCG,
       -- AQPD722TOPEG,
       AQPD722DESG,
       -- AQPD722MDAG,
       AQPD722MTOG,
       AQPD722RBRO,
       AQPD722DESEG,
       AQPD722TITG,
       -- AQPD722SUCG,
       -- AQPD722DSUCG,
       AQPD722ZONA,
       AQPD722FCHES,
       AQPD722FCHIS,
       AQPD722NTRO,
       AQPD722OFIR,
       AQPD722PTDA,
       AQPD722TPOC,
       AQPD722RNGO,
       AQPD722RZON,
       AQPD722DREC,
       AQPD722UBIG,
       AQPD722DIST,
       AQPD722PROV,
       AQPD722DEPR,
       AQPD722FCHTA,
       AQPD722PRIT,
       AQPD722VALC,
       AQPD722VALT,
       AQPD722VALE,
       AQPD722VALR,
       AQPD722POLM,
       AQPD722NROP,
       AQPD722INIP,
       AQPD722FINP,
       AQPD722TITC,
       -- AQPD722MDAC,
       AQPD722MTOC,
       AQPD722SLDC,
       AQPD722PLZO,
       AQPD722USUA,
       AQPD722ESTC,
       AQPD722PSBS,
       
       AQPD722FCHA,
       AQPD722HRAA,
       AQPD722USUA2,
       AQPD722DCALF
       
       )
    VALUES
      (
       
       VI_AQPD722COD,
       VI_AQPD722SUC,
       VI_AQPD722MOD,
       VI_AQPD722MDA,
       VI_AQPD722PAP,
       VI_AQPD722CTA,
       VI_AQPD722OPER,
       VI_AQPD722SBOP,
       VI_AQPD722TOPE,
       VI_AQPD722R1COD,
       VI_AQPD722R1SUC,
       VI_AQPD722R1MOD,
       VI_AQPD722R1MDA,
       VI_AQPD722R1PAP,
       VI_AQPD722R1CTA,
       VI_AQPD722R1OPER,
       VI_AQPD722R1SBOP,
       VI_AQPD722R1TOPE,
       VI_AQPD722FCHD,
       -- VI_AQPD722CTAC,
       -- VI_AQPD722OPEC,
       VI_AQPD722INST,
       VI_AQPD722TDOCG,
       -- VI_AQPD722TOPEG,
       VI_AQPD722DESG,
       -- VI_AQPD722MDAG,
       VI_AQPD722MTOG,
       VI_AQPD722RBRO,
       VI_AQPD722DESEG,
       VI_AQPD722TITG,
       -- VI_AQPD722SUCG,
       -- AQPD722DSUCG,     
       VI_AQPD722ZONA,
       VI_AQPD722FCHES,
       VI_AQPD722FCHIS,
       VI_AQPD722NTRO,
       VI_AQPD722OFIR,
       VI_AQPD722PTDA,
       VI_AQPD722TPOC,
       VI_AQPD722RNGO,
       VI_AQPD722RZON,
       VI_AQPD722DREC,
       VI_AQPD722UBIG,
       VI_AQPD722DIST,
       VI_AQPD722PROV,
       VI_AQPD722DEPR,
       VI_AQPD722FCHTA,
       VI_AQPD722PRIT,
       VI_AQPD722VALC,
       VI_AQPD722VALT,
       VI_AQPD722VALE,
       VI_AQPD722VALR,
       VI_AQPD722POLM,
       VI_AQPD722NROP,
       VI_AQPD722INIP,
       VI_AQPD722FINP,
       VI_AQPD722TITC,
       -- VI_AQPD722MDAC,
       VI_AQPD722MTOC,
       VI_AQPD722SLDC,
       VI_AQPD722PLZO,
       VI_AQPD722USUA,
       VI_AQPD722ESTC,
       VI_AQPD722PSBS,
       
       VI_AQPD722FCHA,
       VI_AQPD722HRAA,
       VI_AQPD722USUA2,
       VI_AQPD722DCALF);
  
    COMMIT;
    -- DBMS_OUTPUT.PUT_LINE('Registro insertado exitosamente en AQPD722.');
  EXCEPTION
    WHEN OTHERS THEN
      -- Manejo de errores
      ROLLBACK;
      --  DBMS_OUTPUT.PUT_LINE('Error al insertar el registro: ' || SQLERRM);
  
  END SP_CR_INSERT_AQPD722;

  PROCEDURE SP_CR_FECHA_MAXIMA(VI_FECHA OUT DATE) IS
  
  BEGIN
    BEGIN
      SELECT MAX(AQPD722FCHA) INTO VI_FECHA FROM AQPD722;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_FECHA_MAXIMA;

  PROCEDURE SP_CR_INSTANCIA_TDOC_NDOC_ASE(vi_r1cod      IN NUMBER,
                                          vi_r1suc      IN NUMBER,
                                          vi_r1mod      IN NUMBER,
                                          vi_r1mda      IN NUMBER,
                                          vi_r1pap      IN NUMBER,
                                          vi_r1cta      IN NUMBER,
                                          vi_r1oper     IN NUMBER,
                                          vi_r1sbop     IN NUMBER,
                                          vi_r1tope     IN NUMBER,
                                          VI_INSTANCIA  OUT CHAR,
                                          VI_SNG001TDOC OUT NUMBER,
                                          VI_SNG001NDOC OUT CHAR,
                                          VI_SNG001ASE  OUT VARCHAR2) IS
  
  BEGIN
    BEGIN
    
      -- obtenemos las instancia clave de credito           
      BEGIN
        SELECT XWFPRCINS
          into VI_INSTANCIA
          FROM xwf700 a
         WHERE a.XWFEMPRESA = vi_r1cod
           AND a.XWFSUCURSAL = vi_r1suc
           AND a.XWFMODULO = vi_r1mod
           AND a.XWFMONEDA = vi_r1mda
           AND a.XWFPAPEL = vi_r1pap
           AND a.XWFCUENTA = vi_r1cta
           AND a.XWFOPERACION = vi_r1oper
           AND a.XWFSUBOPE = vi_r1sbop
           AND a.XWFTIPOPE = vi_r1tope
           AND a.xwfcar3 = '1';
      
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
        
      END;
    
      BEGIN
        SELECT SNG001TDOC, SNG001NDOC, SNG001ASE
          into VI_SNG001TDOC, VI_SNG001NDOC, VI_SNG001ASE
          FROM sng001
         WHERE SNG001INST = TO_NUMBER(TRIM(VI_INSTANCIA));
      
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
        
      END;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_INSTANCIA_TDOC_NDOC_ASE;

  PROCEDURE SP_CR_UBIGEO_DIS_PROV_DEPAR(VI_SNG001TDOC   IN NUMBER,
                                        VI_SNG001NDOC   IN CHAR,
                                        VI_UBIGEO       OUT CHAR,
                                        VI_DISTRITO     OUT CHAR,
                                        VI_PROVINCIA    OUT CHAR,
                                        VI_DEPARTAMENTO OUT CHAR) IS
  
  BEGIN
  
    -- optenemos ubigeo por cliente 
    BEGIN
    
      select SNGC13UGEO
        into VI_UBIGEO
        from sngc13
       where SNGC13TDOC = VI_SNG001TDOC
         and sngc13ndoc = VI_SNG001NDOC
         AND docod = 1
         and sngc13est = 'H';
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- optenemos distrito / provincia / departamento  
    BEGIN
    
      select FST071DSC
        into VI_DISTRITO
        from fst071
       where FST071COL = TO_NUMBER(VI_UBIGEO); --ubigeo hasta distrito  char 30
    
      select LOCNOM
        into VI_PROVINCIA
        from FST070
       where LOCCOD = TO_NUMBER(SUBSTR(VI_UBIGEO, 1, 4)); --UBIGEO HASTA PROVINCIA char 30
    
      select DEPNOM
        into VI_DEPARTAMENTO
        from fst068
       where DEPCOD = TO_NUMBER(SUBSTR(VI_UBIGEO, 1, 2)); --UBIGEO HASTA DEPARTAMENTO. char 20
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_UBIGEO_DIS_PROV_DEPAR;

  PROCEDURE SP_CR_FSD010(vi_r1cod            IN NUMBER,
                         vi_r1mod            IN NUMBER,
                         vi_r1suc            IN NUMBER,
                         vi_r1mda            IN NUMBER,
                         vi_r1pap            IN NUMBER,
                         vi_r1cta            IN NUMBER,
                         vi_r1oper           IN NUMBER,
                         vi_r1sbop           IN NUMBER,
                         vi_r1tope           IN NUMBER,
                         VI_FECHA_DESEMBOLSO OUT DATE,
                         VI_AOSTAT           OUT NUMBER,
                         VI_CENOM            OUT CHAR,
                         VI_AOIMP            OUT NUMBER,
                         VI_AOPZO            OUT NUMBER) IS
  
  BEGIN
    BEGIN
      select AOFVAL, AOSTAT, AOIMP, AOPZO
        into VI_FECHA_DESEMBOLSO, VI_AOSTAT, VI_AOIMP, VI_AOPZO
        from fsd010 a
       where a.pgcod = vi_r1cod
         and a.aomod = vi_r1mod
         and a.aosuc = vi_r1suc
         and a.aomda = vi_r1mda
         and a.aopap = vi_r1pap
         and a.aocta = vi_r1cta
         and a.aooper = vi_r1oper
         and a.aosbop = vi_r1sbop
         and a.aotope = vi_r1tope;
    
      select CENOM INTO VI_CENOM from FST026 where CECOD = VI_AOSTAT;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_FSD010;

  PROCEDURE SP_CR_FSD011(vi_r1cod  IN NUMBER,
                         vi_r1suc  IN NUMBER,
                         vi_r1mda  IN NUMBER,
                         vi_r1pap  IN NUMBER,
                         vi_r1cta  IN NUMBER,
                         vi_r1oper IN NUMBER,
                         vi_r1mod  IN NUMBER,
                         vi_r1sbop IN NUMBER,
                         vi_r1tope IN NUMBER,
                         VI_SALDO  OUT NUMBER,
                         VI_SCRUB  OUT NUMBER) IS
  
  BEGIN
    BEGIN
    
      -- obtenemso el saldo por la clave de credito r1
      BEGIN
      
        SELECT SCSDO, SCRUB
          into VI_SALDO, VI_SCRUB
          FROM FSD011 f
         where f.pgcod = vi_r1cod
           and f.scsuc = vi_r1suc
           and f.scmda = vi_r1mda
           and f.scpap = vi_r1pap
           and f.sccta = vi_r1cta
           and f.scoper = vi_r1oper
           and f.scmod = vi_r1mod
           and f.scsbop = vi_r1sbop
           and f.sctope = vi_r1tope;
      EXCEPTION
        WHEN OTHERS THEN
          VI_SALDO := NULL;
      END;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_FSD011;

  PROCEDURE SP_CR_CODIGO_SBS(VI_PGCOD   IN NUMBER,
                             VI_CUENTA  IN NUMBER,
                             VI_COD_SBS OUT VARCHAR2) IS
  
    ln_Pepais NUMBER(3);
    ln_Petdoc NUMBER(2);
    lc_Pendoc CHAR(12);
  
  BEGIN
    -- Obtengo el código de la SBS JAQL175CODSBS
    begin
      select Pepais, Petdoc, Pendoc
        into ln_Pepais, ln_Petdoc, lc_Pendoc
        from FSR008 --:Titular Cuenta
       Where PgCod = VI_PGCOD
         and Ctnro = VI_CUENTA
         and Ttcod = 1
         and Cttfir = 'T';
    exception
      when others then
        ln_Pepais := 0;
        ln_Petdoc := 0;
        lc_Pendoc := '';
    end;
    begin
      select c_codsbs
        into VI_COD_SBS
        from cldrcci
       where c_docide = lc_Pendoc
         and rownum = 1
       order by d_fecpre desc; --sacar al última fecha obtengo el codsbs
    exception
      when no_data_found then
        begin
          select lpad(to_char(c.bc739sbs), 10, 0)
            into VI_COD_SBS
            from fbc739 c
           where c.bc739pais = ln_Pepais
             and c.bc739tdoc = ln_Petdoc
             and c.bc739ndoc = lc_Pendoc
             and c.bc739cta = VI_CUENTA;
        exception
          when no_data_found then
            VI_COD_SBS := 0;
        end;
    end;
  
  END SP_CR_CODIGO_SBS;

  PROCEDURE SP_CR_POLIZA_MULTIRR(VI_PGCOD  IN NUMBER,
                                 VI_AOMOD  IN NUMBER,
                                 VI_AOSUC  IN NUMBER,
                                 VI_AOMDA  IN NUMBER,
                                 VI_AOPAP  IN NUMBER,
                                 VI_AOCTA  IN NUMBER,
                                 VI_AOOPER IN NUMBER,
                                 VI_AOSBOP IN NUMBER,
                                 VI_AOTOPE IN NUMBER,
                                 VI_sgcod  OUT NUMBER) IS
  
  BEGIN
  
    BEGIN
      SELECT a.sgcod
        INTO VI_sgcod
        FROM fpp001 a
       where a.PGCOD = VI_PGCOD
         AND a.AOMOD = VI_AOMOD
         AND a.AOSUC = VI_AOSUC
         AND a.AOMDA = VI_AOMDA
         AND a.AOPAP = VI_AOPAP
         AND a.AOCTA = VI_AOCTA
         AND a.AOOPER = VI_AOOPER
         AND a.AOSBOP = VI_AOSBOP
         AND a.AOTOPE = VI_AOTOPE
         AND a.sgcod in (select tp1nro1
                           from fst198
                          where tp1cod1 = 10875
                            and tp1corr1 = 10);
    
    EXCEPTION
      WHEN OTHERS THEN
        VI_sgcod := 0;
    END;
  
  END SP_CR_POLIZA_MULTIRR;

  PROCEDURE SP_CR_CALIFICACION_CREDITO(VI_PGCOD  IN NUMBER,
                                       VI_AOMOD  IN NUMBER,
                                       VI_AOSUC  IN NUMBER,
                                       VI_AOMDA  IN NUMBER,
                                       VI_AOPAP  IN NUMBER,
                                       VI_AOCTA  IN NUMBER,
                                       VI_AOOPER IN NUMBER,
                                       VI_AOSBOP IN NUMBER,
                                       VI_AOTOPE IN NUMBER,
                                       VI_DCALF  OUT VARCHAR2) IS
  
  BEGIN
  
    BEGIN
      SELECT jaql964dcalf
        INTO VI_DCALF
        FROM jaql964
       WHERE jaql964pgcod = VI_PGCOD
         AND jaql964mod = VI_AOMOD
         AND jaql964suc = VI_AOSUC
         AND jaql964mda = VI_AOMDA
         AND jaql964pap = VI_AOPAP
         AND jaql964cta = VI_AOCTA
         AND jaql964ope = VI_AOOPER
         AND jaql964sob = VI_AOSBOP
         AND jaql964top = VI_AOTOPE;
    
    EXCEPTION
      WHEN OTHERS THEN
        VI_DCALF := null;
    END;
  
  END SP_CR_CALIFICACION_CREDITO;

end PQ_CR_REPORTE_GARANTIAS_REALES_INSCRITAS;
/
