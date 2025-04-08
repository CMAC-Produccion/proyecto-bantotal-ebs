create or replace package PQ_CR_CREDITOS_APROBADO_CONSUMO is

  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_CREDITOS_APROBADO_CONSUMO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 03/03/2025 10:16:54
  -- AUTOR DE CREACION           : JALVAROH
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- Purpose                     : PANEL INFORMATIVO PARA CLIENTES APROBADOS
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- **************************************************************************************

  PROCEDURE SP_VALIDAR_CREDITOS_APROBADOS(VI_EMPRESA   IN NUMBER,
                                          VI_SUCURSAL  IN NUMBER,
                                          VI_MODULO    IN NUMBER,
                                          VI_MONEDA    IN NUMBER,
                                          VI_PAPEL     IN NUMBER,
                                          VI_CUENTA    IN NUMBER,
                                          VI_OPERACION IN NUMBER,
                                          VI_SUBOPER   IN NUMBER,
                                          VI_TIPOER    IN NUMBER,
                                          VO_NUMDOC    OUT VARCHAR2,
                                          VO_CTA       OUT NUMBER,
                                          VO_MOD       OUT NUMBER,
                                          VO_TOP       OUT NUMBER,
                                          VO_RPTA      OUT VARCHAR2,
                                          VO_MENSAJE   OUT VARCHAR2);

  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTENER_MENSAJE(ve_codigo in number, vo_mensaje out varchar);

  -----------------------------------------------------------------------------

  PROCEDURE SP_CR_INFORMO_CLIENTE(VI_USUARIO  IN VARCHAR2,
                                  VI_CTA      IN NUMBER,
                                  VI_MOD      IN NUMBER,
                                  VI_TOP      IN NUMBER,
                                  VI_NUMDOC   IN VARCHAR2,
                                  VO_CODERROR OUT VARCHAR2,
                                  VO_MSGERROR OUT VARCHAR2);
  ------------------------------------------------------------------------------
  PROCEDURE SP_CR_INSERT_AQPD760(LN_CORR    IN NUMBER,
                                 LN_PGCOD   IN NUMBER,
                                 LN_SUC     IN NUMBER,
                                 LN_MOD     IN NUMBER,
                                 LN_MON     IN NUMBER,
                                 LN_PAP     IN NUMBER,
                                 LN_CTA     IN NUMBER,
                                 LN_OPE     IN NUMBER,
                                 LN_SBOPE   IN NUMBER,
                                 LN_TPOPE   IN NUMBER,
                                 LV_NDOC    IN VARCHAR2,
                                 LV_USUG    IN VARCHAR2,
                                 LV_NUSUG   IN VARCHAR2,
                                 LV_ageor   IN VARCHAR2,
                                 LD_FCHG    IN DATE,
                                 LV_HRAG    IN VARCHAR2,
                                 LV_ESTG    IN VARCHAR2,
                                 LV_USUG2   IN VARCHAR2,
                                 LD_FCHG2   IN DATE,
                                 LV_HRAG2   IN VARCHAR2,
                                 LV_ESTG2   IN VARCHAR2,
                                 LV_marca   IN VARCHAR2,
                                 LV_candes  IN VARCHAR2,
                                 LV_nomusu2 IN VARCHAR2,
                                 LN_codreg  IN NUMBER,
                                 LV_region  IN VARCHAR2,
                                 LN_codzona IN NUMBER,
                                 LV_zona    IN VARCHAR2,
                                 LN_SUCDES  IN NUMBER,
                                 LV_agen    IN VARCHAR2,
                                 LN_mont    IN NUMBER,
                                 LN_plz     IN NUMBER);
  ------------------------------------------------------------------------------
  PROCEDURE SP_CR_VALIDAR_DESEMBOLSOS_AQPD760(VI_PGCOD      IN NUMBER,
                                              VI_PITSUC     IN NUMBER,
                                              VI_PITMOD     IN NUMBER,
                                              VI_PITTRAN    IN NUMBER,
                                              VI_PITNREL    IN NUMBER,
                                              VI_PITORDI    IN NUMBER,
                                              VI_USUARIORTE IN VARCHAR2);

end PQ_CR_CREDITOS_APROBADO_CONSUMO;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_CREDITOS_APROBADO_CONSUMO IS
  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_CREDITOS_APROBADO_CONSUMO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 31/03/2025 10:16:54
  -- AUTOR DE CREACION           : JALVAROH
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- Purpose                     : PANEL INFORMATIVO PARA CLIENTES APROBADOS
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- **************************************************************************************

  PROCEDURE SP_VALIDAR_CREDITOS_APROBADOS(VI_EMPRESA   IN NUMBER,
                                          VI_SUCURSAL  IN NUMBER,
                                          VI_MODULO    IN NUMBER,
                                          VI_MONEDA    IN NUMBER,
                                          VI_PAPEL     IN NUMBER,
                                          VI_CUENTA    IN NUMBER,
                                          VI_OPERACION IN NUMBER,
                                          VI_SUBOPER   IN NUMBER,
                                          VI_TIPOER    IN NUMBER,
                                          VO_NUMDOC    OUT VARCHAR2,
                                          VO_CTA       OUT NUMBER,
                                          VO_MOD       OUT NUMBER,
                                          VO_TOP       OUT NUMBER,
                                          VO_RPTA      OUT VARCHAR2,
                                          VO_MENSAJE   OUT VARCHAR2) IS
    VII_INSTANCIA NUMBER(9);
    VII_NUMDOC    VARCHAR2(12);
    VII_PAIS      NUMBER(3);
    VII_TDOC      NUMBER(2);
    V_EXISTE      NUMBER := 0; -- Variable para almacenar si existe un registro
    VV_EXISTE     NUMBER := 0;
    STR_VO_CTA    VARCHAR2(12);
  
  BEGIN
    -- Bloque 1: Obtener instancia
    BEGIN
      SELECT A.XWFPRCINS
        INTO VII_INSTANCIA
        FROM xwf700 A
       WHERE A.XWFEMPRESA = VI_EMPRESA
         AND A.XWFSUCURSAL = VI_SUCURSAL
         AND A.XWFMODULO = VI_MODULO
         AND A.XWFMONEDA = VI_MONEDA
         AND A.XWFPAPEL = VI_PAPEL
         AND A.XWFCUENTA = VI_CUENTA
         AND A.XWFOPERACION = VI_OPERACION
         AND A.XWFSUBOPE = VI_SUBOPER
         AND A.XWFTIPOPE = VI_TIPOER
         AND A.XWFCAR3 = '1';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      WHEN OTHERS THEN
        NULL;
    END;
  
    SELECT TO_CHAR(VI_CUENTA) INTO STR_VO_CTA FROM DUAL;
  
    BEGIN
      IF NVL(VI_MODULO, 0) >= 100 AND NVL(VI_MODULO, 0) <= 200 THEN
      
        -- Bloque 2: Obtener número de documento
      
        SELECT B.SNG001NDOC, B.SNG001PAIS, B.SNG001TDOC
          INTO VII_NUMDOC, VII_PAIS, VII_TDOC --  pais y tipo de documento 
          FROM sng001 B
         WHERE B.SNG001INST = VII_INSTANCIA;
      
      ELSE
        SELECT W.PENDOC, W.PEPAIS, W.PETDOC
          INTO VII_NUMDOC, VII_PAIS, VII_TDOC
          FROM fSR008 W
         WHERE CTNRO = STR_VO_CTA
           AND CTTFIR = 'T';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        VII_NUMDOC := null;
        VII_PAIS   := null;
        VII_TDOC   := null;
    END;
  
    -- Bloque 3: Verificar existencia en JAQZ697
  
    BEGIN
      SELECT COUNT(1), q.jaqz697cta, q.jaqz697mod, q.jaqz697top
        INTO V_EXISTE, VO_CTA, VO_MOD, VO_TOP
        FROM JAQZ697 q
       WHERE q.JAQZ697FEP =
             (SELECT MAX(a.JAQZ697FEP)
                FROM JAQZ697 a
               WHERE a.JAQZ697MOD = 106
                 AND a.JAQZ697AU5 = 'B'
                 AND a.JAQZ697TOP IN (93, 94, 95))
            -- AND q.jaqz697pai = VII_PAIS
            -- AND q.jaqz697tdo = VII_TDOC
         AND q.jaqz697ndo = VII_NUMDOC
         AND q.JAQZ697MOD = 106
         AND q.JAQZ697AU5 = 'B'
         AND q.JAQZ697TOP IN (93, 94, 95)
       GROUP BY Q.JAQZ697CTA, Q.JAQZ697MOD, Q.JAQZ697TOP;
    EXCEPTION
      WHEN OTHERS THEN
        V_EXISTE := NULL;
        VO_CTA   := NULL;
        VO_MOD   := NULL;
        VO_TOP   := NULL;
        -- VO_RPTA    := 'N';
      -- VO_MENSAJE := 'Error en la consulta: ' || SQLERRM;
    END;
  
    -- verificamos si ya fue notificado 
    BEGIN
      SELECT COUNT(1)
        INTO VV_EXISTE
        FROM AQPD760 M
       WHERE RPAD(M.AQPD760NDOC, 12, ' ') = VII_NUMDOC
         AND M.AQPD760CTA = VO_CTA;
    
    EXCEPTION
      WHEN OTHERS THEN
        VV_EXISTE := NULL;
    END;
    -- Si existe al menos un registro, asignar 'S', si no, 'N'
    IF V_EXISTE > 0 AND VV_EXISTE = 0 THEN
      VO_RPTA   := 'S';
      VO_NUMDOC := VII_NUMDOC;
      BEGIN
        PQ_CR_CREDITOS_APROBADO_CONSUMO.SP_OBTENER_MENSAJE(1, VO_MENSAJE);
      END;
    ELSE
      VO_RPTA    := 'N';
      VO_NUMDOC  := NULL;
      VO_MENSAJE := NULL;
    END IF;
  
    -- VO_MENSAJE := 'Consulta ejecutada correctamente';
  
  END SP_VALIDAR_CREDITOS_APROBADOS;

  PROCEDURE SP_OBTENER_MENSAJE(ve_codigo in number, vo_mensaje out varchar) IS
    CURSOR LISTA IS
      SELECT *
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11165
         AND TP1CORR1 = 2
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0;
  BEGIN
    BEGIN
      vo_mensaje := '';
      FOR X IN LISTA LOOP
        vo_mensaje := vo_mensaje || TRIM(X.TP1DESC) || ' ';
      END LOOP;
    
    EXCEPTION
      WHEN OTHERS THEN
        VO_MENSAJE := 'Indicar al Cliente que tiene un CREDITO APROBADO inmediato';
    END;
  END SP_OBTENER_MENSAJE;

  PROCEDURE SP_CR_INFORMO_CLIENTE(VI_USUARIO  IN VARCHAR2,
                                  VI_CTA      IN NUMBER,
                                  VI_MOD      IN NUMBER,
                                  VI_TOP      IN NUMBER,
                                  VI_NUMDOC   IN VARCHAR2,
                                  VO_CODERROR OUT VARCHAR2,
                                  VO_MSGERROR OUT VARCHAR2) IS
  
    NEXT_CORR            NUMBER(10); -- Próximo valor del correlativo
    FECHSTADO            DATE; -- fecha de la modificacion del estado
    HORASTADO            VARCHAR2(10);
    NOM_ANALISTA_INFORMO VARCHAR2(60);
    NOM_AGENCIA          VARCHAR2(30);
    VI_SUCURSAL          NUMBER(3);
  
  BEGIN
  
    BEGIN
      SELECT pgfape INTO FECHSTADO FROM fst017 WHERE pgcod = 1;
    
      HORASTADO := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- Calcular el siguiente valor del correlativo
    BEGIN
      SELECT NVL(MAX(aqpd760corr), 0) + 1
        INTO NEXT_CORR
        FROM AQPD760
       WHERE TO_DATE(AQPD760FCHG, 'DD/MM/YYYY') =
             TO_DATE(FECHSTADO, 'DD/MM/YYYY');
    EXCEPTION
      WHEN OTHERS THEN
        NEXT_CORR := NULL;
    END;
    --  NOMBRE DEL ANALISTA 
    BEGIN
      SELECT UBNOM
        INTO NOM_ANALISTA_INFORMO
        FROM fst746
       WHERE UBUSER = RPAD(VI_USUARIO, 10, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NOM_ANALISTA_INFORMO := NULL;
    END;
  
    -- SACAMOS LA SUCURSAL DEL USUARIO 
    BEGIN
      select n.ubsuc
        into VI_SUCURSAL
        from fst046 n
       where n.UBUSER = RPAD(VI_USUARIO, 10, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        VI_SUCURSAL := NULL;
    END;
  
    -- NOMBRE DE LA AGENCIA 
  
    BEGIN
      select SCNOM INTO NOM_AGENCIA from regsuc where SUCURS = VI_SUCURSAL;
    EXCEPTION
      WHEN OTHERS THEN
        NOM_AGENCIA := NULL;
    END;
  
    BEGIN
      PQ_CR_CREDITOS_APROBADO_CONSUMO.SP_CR_INSERT_AQPD760(LN_CORR    => NEXT_CORR,
                                                           LN_PGCOD   => NULL,
                                                           LN_SUC     => NULL,
                                                           LN_MOD     => VI_MOD,
                                                           LN_MON     => NULL,
                                                           LN_PAP     => NULL,
                                                           LN_CTA     => VI_CTA,
                                                           LN_OPE     => NULL,
                                                           LN_SBOPE   => NULL,
                                                           LN_TPOPE   => VI_TOP,
                                                           LV_NDOC    => VI_NUMDOC,
                                                           LV_USUG    => VI_USUARIO,
                                                           LV_NUSUG   => NOM_ANALISTA_INFORMO,
                                                           LV_ageor   => NOM_AGENCIA,
                                                           LD_FCHG    => FECHSTADO,
                                                           LV_HRAG    => HORASTADO,
                                                           LV_ESTG    => 'S',
                                                           LV_USUG2   => NULL,
                                                           LD_FCHG2   => NULL,
                                                           LV_HRAG2   => NULL,
                                                           LV_ESTG2   => 'N',
                                                           LV_marca   => NULL,
                                                           LV_candes  => NULL,
                                                           LV_nomusu2 => NULL,
                                                           LN_codreg  => NULL,
                                                           LV_region  => NULL,
                                                           LN_codzona => NULL,
                                                           LV_zona    => NULL,
                                                           LN_SUCDES  => NULL,
                                                           LV_agen    => NULL,
                                                           LN_mont    => NULL,
                                                           LN_plz     => NULL);
    
    EXCEPTION
    
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_INFORMO_CLIENTE;

  PROCEDURE SP_CR_INSERT_AQPD760(LN_CORR    IN NUMBER,
                                 LN_PGCOD   IN NUMBER,
                                 LN_SUC     IN NUMBER,
                                 LN_MOD     IN NUMBER,
                                 LN_MON     IN NUMBER,
                                 LN_PAP     IN NUMBER,
                                 LN_CTA     IN NUMBER,
                                 LN_OPE     IN NUMBER,
                                 LN_SBOPE   IN NUMBER,
                                 LN_TPOPE   IN NUMBER,
                                 LV_NDOC    IN VARCHAR2,
                                 LV_USUG    IN VARCHAR2,
                                 LV_NUSUG   IN VARCHAR2,
                                 LV_ageor   IN VARCHAR2,
                                 LD_FCHG    IN DATE,
                                 LV_HRAG    IN VARCHAR2,
                                 LV_ESTG    IN VARCHAR2,
                                 LV_USUG2   IN VARCHAR2,
                                 LD_FCHG2   IN DATE,
                                 LV_HRAG2   IN VARCHAR2,
                                 LV_ESTG2   IN VARCHAR2,
                                 LV_marca   IN VARCHAR2,
                                 LV_candes  IN VARCHAR2,
                                 LV_nomusu2 IN VARCHAR2,
                                 LN_codreg  IN NUMBER,
                                 LV_region  IN VARCHAR2,
                                 LN_codzona IN NUMBER,
                                 LV_zona    IN VARCHAR2,
                                 LN_SUCDES  IN NUMBER,
                                 LV_agen    IN VARCHAR2,
                                 LN_mont    IN NUMBER,
                                 LN_plz     IN NUMBER) IS
  BEGIN
    -- Insertar el nuevo registro
    INSERT INTO AQPD760
      (aqpd760corr,
       aqpd760pgcod,
       aqpd760suc,
       aqpd760mod,
       aqpd760mon,
       aqpd760pap,
       aqpd760cta,
       aqpd760ope,
       aqpd760sbope,
       aqpd760tpope,
       aqpd760ndoc,
       aqpd760usug,
       AQPD760NUSUG,
       aqpd760ageor,
       aqpd760fchg,
       aqpd760hrag,
       aqpd760estg,
       aqpd760usug2,
       aqpd760fchg2,
       aqpd760hrag2,
       aqpd760estg2,
       aqpd760marca,
       aqpd760candes,
       aqpd760nomusu2,
       aqpd760codreg,
       aqpd760region,
       aqpd760codzona,
       aqpd760zona,
       AQPD760SUCDES,
       aqpd760agen,
       aqpd760mont,
       aqpd760plz)
    VALUES
      (LN_CORR,
       LN_PGCOD,
       LN_SUC,
       LN_MOD,
       LN_MON,
       LN_PAP,
       LN_CTA,
       LN_OPE,
       LN_SBOPE,
       LN_TPOPE,
       LV_NDOC,
       LV_USUG,
       LV_NUSUG,
       LV_ageor,
       LD_FCHG,
       LV_HRAG,
       LV_ESTG,
       LV_USUG2,
       LD_FCHG2,
       LV_HRAG2,
       LV_ESTG2,
       LV_marca,
       LV_candes,
       LV_nomusu2,
       LN_codreg,
       LV_region,
       LN_codzona,
       LV_zona,
       LN_SUCDES,
       LV_agen,
       LN_mont,
       LN_plz);
  
    -- Confirmar la transacción
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('Registro insertado exitosamente en AQPD760.');
  EXCEPTION
    WHEN OTHERS THEN
      -- Manejo de errores
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error al insertar el registro: ' || SQLERRM);
    
  END SP_CR_INSERT_AQPD760;

  PROCEDURE SP_CR_VALIDAR_DESEMBOLSOS_AQPD760(VI_PGCOD      IN NUMBER,
                                              VI_PITSUC     IN NUMBER,
                                              VI_PITMOD     IN NUMBER,
                                              VI_PITTRAN    IN NUMBER,
                                              VI_PITNREL    IN NUMBER,
                                              VI_PITORDI    IN NUMBER,
                                              VI_USUARIORTE IN VARCHAR2) IS
  
    vi_count_aqpd NUMBER := 0;
    vi_count_fsd  NUMBER := 0;
  
    VI_EMPRESA   NUMBER;
    VI_SUCURSAL  NUMBER;
    VI_MODULO    NUMBER;
    VI_MONEDA    NUMBER;
    VI_PAPEL     NUMBER;
    VI_CUENTA    NUMBER;
    VI_OPERACION NUMBER;
    VI_SUBOPER   NUMBER;
    VI_TIPOER    NUMBER;
  
    VI_REGCOD  NUMBER;
    VI_REGNOM  VARCHAR2(20);
    VI_CODZON  NUMBER;
    VI_DESZON  VARCHAR2(20);
    VI_SCNOM   VARCHAR2(20);
    VI_AOPZO   NUMBER;
    VI_AOIMP   number(17, 2);
    VI_CANDES  VARCHAR2(40);
    VI_UBNOM   CHAR(30);
    VI_FECHA   DATE;
    VI_HORA    VARCHAR2(10);
    VI_PENDOC  CHAR(12);
    VI_NDOCDES VARCHAR2(12);
  
  BEGIN
  
    BEGIN
      --CLAVE DE CRÉDITO
      SELECT PGCOD,
             ITSUCD,
             MODULO,
             MONEDA,
             PAPEL,
             CTNRO,
             ITOPER,
             ITSUBO,
             ITTOPE
        INTO VI_EMPRESA,
             VI_SUCURSAL,
             VI_MODULO,
             VI_MONEDA,
             VI_PAPEL,
             VI_CUENTA,
             VI_OPERACION,
             VI_SUBOPER,
             VI_TIPOER
        FROM fsd016
       WHERE PGCOD = VI_PGCOD
         AND ITSUC = VI_PITSUC
         AND ITMOD = VI_PITMOD
         AND ITTRAN = VI_PITTRAN
         AND ITNREL = VI_PITNREL
         AND ITORD = VI_PITORDI;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos en fsd016.');
        RETURN;
    END;
    BEGIN
      SELECT PENDOC
        INTO VI_PENDOC
        FROM Fsr008
       WHERE CTNRO = VI_CUENTA
         AND CTTFIR = 'T';
      VI_NDOCDES := RTRIM(VI_PENDOC);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        VI_PENDOC := NULL;
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos para la cuenta.');
        RETURN;
    END;
    BEGIN
      --VALIDAR SI EXISTE EN AQPD760
      BEGIN
        SELECT COUNT(*)
          INTO vi_count_aqpd
          FROM aqpd760
         WHERE aqpd760ndoc = VI_NDOCDES
           and aqpd760cta = VI_CUENTA;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          vi_count_aqpd := 0;
      END;
      IF vi_count_aqpd = 0 THEN
        RETURN;
      END IF;
      --NOMBRE DE ANALISTA
      BEGIN
        SELECT UBNOM
          INTO VI_UBNOM
          FROM FST746
         WHERE UBUSER = RPAD(VI_USUARIORTE, 10, ' ');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          VI_UBNOM := 'DESCONOCIDO';
      END;
    
      -- REGION Y ZONA DE DESEMBOLSO
      BEGIN
        SELECT REGCOD, REGNOM, CODZON, DESZON, SCNOM
          INTO VI_REGCOD, VI_REGNOM, VI_CODZON, VI_DESZON, VI_SCNOM
          FROM REGSUC
         WHERE SUCURS = VI_SUCURSAL;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          VI_REGCOD := NULL;
          VI_REGNOM := 'SIN REGIÓN';
          VI_CODZON := NULL;
          VI_DESZON := 'SIN ZONA';
          VI_SCNOM  := 'SIN AGENCIA';
      END;
      --CANAL DESEMBOLSO
      BEGIN
        SELECT TRNOM
          INTO VI_CANDES
          FROM FST034
         WHERE TRMOD = VI_PITMOD
           AND TRNRO = VI_PITTRAN;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          VI_CANDES := 'DESCONOCIDO';
      END;
    
      BEGIN
        --OBTENER PLAZO Y MONTO
        SELECT AOPZO, AOIMP
          INTO VI_AOPZO, VI_AOIMP
          FROM fsd010
         WHERE pgcod = VI_EMPRESA
           AND aosuc = VI_SUCURSAL
           AND aomod = VI_MODULO
           AND aomda = VI_MONEDA
           AND aopap = VI_PAPEL
           AND aocta = VI_CUENTA
           AND aooper = VI_OPERACION
           AND aosbop = VI_SUBOPER
           AND aotope = VI_TIPOER;
        -- FECHA Y HORA DESEMBOLSO
        SELECT pgfape INTO VI_FECHA FROM fst017 WHERE pgcod = 1;
      
        VI_HORA := TO_CHAR(SYSDATE, 'HH24:MI:SS');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          VI_AOPZO := 0;
          VI_AOIMP := 0;
      END;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        vi_count_aqpd := 0;
    END;
  
    -- VALIDAR SI EXISTE EN LA AQPD760
    IF vi_count_aqpd > 0 THEN
      -- VALIDAR SI EXISTE EN FSD010
      SELECT COUNT(*)
        INTO vi_count_fsd
        FROM fsd010
       WHERE pgcod = VI_EMPRESA
         AND aosuc = VI_SUCURSAL
         AND aomod = VI_MODULO
         AND aomda = VI_MONEDA
         AND aopap = VI_PAPEL
         AND aocta = VI_CUENTA
         AND aooper = VI_OPERACION
         AND aosbop = VI_SUBOPER
         AND aotope = VI_TIPOER;
    
      -- ACTUALIZAR ESTADO EN AQPD760
      BEGIN
        UPDATE aqpd760 a
           SET a.aqpd760estg2 = CASE
                                  WHEN vi_count_fsd > 0 THEN
                                   'S'
                                  ELSE
                                   'N'
                                END,
               a.aqpd760usug2   = VI_USUARIORTE,
               A.AQPD760MONT    = VI_AOIMP,
               A.AQPD760PLZ     = VI_AOPZO,
               A.AQPD760CODREG  = VI_REGCOD,
               A.AQPD760REGION  = VI_REGNOM,
               A.AQPD760CODZONA = VI_CODZON,
               A.AQPD760ZONA    = VI_DESZON,
               A.AQPD760CANDES  = VI_CANDES,
               A.AQPD760AGEN    = VI_SCNOM,
               A.AQPD760NOMUSU2 = VI_UBNOM,
               A.AQPD760FCHG2   = VI_FECHA,
               A.AQPD760HRAG2   = VI_HORA,
               A.AQPD760PGCOD   = VI_EMPRESA,
               A.AQPD760SUC     = VI_SUCURSAL,
               A.AQPD760SUCDES  = VI_SUCURSAL,
               A.AQPD760PAP     = VI_PAPEL,
               A.AQPD760MON     = VI_MONEDA,
               A.AQPD760OPE     = VI_OPERACION,
               A.AQPD760SBOPE   = VI_SUBOPER,
               A.AQPD760TPOPE   = VI_TIPOER
         WHERE aqpd760mod = VI_MODULO
              
           AND aqpd760cta = VI_CUENTA
           AND aqpd760ndoc = VI_NDOCDES;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Error en UPDATE AQPD760: ' || SQLERRM);
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- Manejo de errores
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error al insertar el registro: ' || SQLERRM);
    
  END SP_CR_VALIDAR_DESEMBOLSOS_AQPD760;

END PQ_CR_CREDITOS_APROBADO_CONSUMO;
/
