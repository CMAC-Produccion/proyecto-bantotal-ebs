CREATE OR REPLACE PACKAGE PQ_CR_SITUACION_OPERACIONES IS

  -- ====================================================================================================
  -- NOMBRE                      : PQ_CR_SITUACION_OPERACIONES
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 13/10/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  PROCEDURE SP_CR_GRABAR_CABECERA(PI_EMPRESA    IN NUMBER,
                                  PI_MODULO     IN NUMBER,
                                  PI_SUCURSAL   IN NUMBER,
                                  PI_MONEDA     IN NUMBER,
                                  PI_PAPEL      IN NUMBER,
                                  PI_CUENTA     IN NUMBER,
                                  PI_OPERACION  IN NUMBER,
                                  PI_SOPERACION IN NUMBER,
                                  PI_TOPERACION IN NUMBER,
                                  PI_FECHA      IN DATE);
                                  
  -- ===================================================================================================
  PROCEDURE SP_CR_GRABAR_DETALLE(PI_NRO_CUOTAS IN NUMBER,
                                 PI_EMPRESA    IN NUMBER,
                                 PI_MODULO     IN NUMBER,
                                 PI_SUCURSAL   IN NUMBER,
                                 PI_MONEDA     IN NUMBER,
                                 PI_PAPEL      IN NUMBER,
                                 PI_CUENTA     IN NUMBER,
                                 PI_OPERACION  IN NUMBER,
                                 PI_SOPERACION IN NUMBER,
                                 PI_TOPERACION IN NUMBER,
                                 PI_FECHA_PAGO IN DATE,
                                 PI_FECHA      IN DATE,
                                 PI_CAPITAL    IN NUMBER,
                                 PI_INTERES    IN NUMBER,
                                 PI_MORA       IN NUMBER,
                                 PI_GASTOS     IN NUMBER,
                                 PI_INTC       IN NUMBER,
                                 PI_SEGURO     IN NUMBER,
                                 PI_PENALIDAD  IN NUMBER,
                                 PI_ITF        IN NUMBER);
  
  -- ===================================================================================================
  PROCEDURE SP_CR_VALIDAR_MODULO(PI_MODULO   IN  NUMBER,
                                 PO_ESVALIDO OUT VARCHAR2);
                                 
  -- ===================================================================================================
  PROCEDURE SP_CR_GRABAR_ESTADO_PROCESO(PI_FEC_CARGA  IN DATE,
                                        PI_EMPRESA    IN NUMBER,
                                        PI_MODULO     IN NUMBER,
                                        PI_SUCURSAL   IN NUMBER,
                                        PI_MONEDA     IN NUMBER,
                                        PI_PAPEL      IN NUMBER,
                                        PI_CUENTA     IN NUMBER,
                                        PI_OPERACION  IN NUMBER,
                                        PI_SOPERACION IN NUMBER,
                                        PI_TOPERACION IN NUMBER,
                                        PI_COD_ERROR  IN NUMBER,
                                        PI_MSG_ERROR  IN VARCHAR2);
                                        
  -- ===================================================================================================
  PROCEDURE SP_CR_ELIMINAR_DATA(PI_FEC_CARGA  IN DATE,
                                PI_EMPRESA    IN NUMBER,
                                PI_MODULO     IN NUMBER,
                                PI_SUCURSAL   IN NUMBER,
                                PI_MONEDA     IN NUMBER,
                                PI_PAPEL      IN NUMBER,
                                PI_CUENTA     IN NUMBER,
                                PI_OPERACION  IN NUMBER,
                                PI_SOPERACION IN NUMBER,
                                PI_TOPERACION IN NUMBER);
                                
  -- ===================================================================================================
  PROCEDURE SP_CR_CARGA_BANDEJAS_A_BT;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_GRABAR_CRED_REFI;
                                       
END PQ_CR_SITUACION_OPERACIONES;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_SITUACION_OPERACIONES IS
  
  PROCEDURE SP_CR_GRABAR_CABECERA(PI_EMPRESA    IN NUMBER,
                                  PI_MODULO     IN NUMBER,
                                  PI_SUCURSAL   IN NUMBER,
                                  PI_MONEDA     IN NUMBER,
                                  PI_PAPEL      IN NUMBER,
                                  PI_CUENTA     IN NUMBER,
                                  PI_OPERACION  IN NUMBER,
                                  PI_SOPERACION IN NUMBER,
                                  PI_TOPERACION IN NUMBER,
                                  PI_FECHA      IN DATE) IS
                                  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_GRABAR_CABECERA
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 13/10/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : 
  -- PARAMETROS                  : - PI_EMPRESA    | NUMBER(3)
  --                               - PI_MODULO     | NUMBER(3)
  --                               - PI_SUCURSAL   | NUMBER(3)
  --                               - PI_MONEDA     | NUMBER(4)
  --                               - PI_PAPEL      | NUMBER(4)
  --                               - PI_CUENTA     | NUMBER(9)
  --                               - PI_OPERACION  | NUMBER(9)
  --                               - PI_SOPERACION | NUMBER(3)
  --                               - PI_TOPERACION | NUMBER(3)
  --                               - PI_FECHA      | DATE
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  V_INSTANCIA     NUMBER(10)   := 0;
  V_AQPD412INS    NUMBER(10)   := 0;
  V_PROCESAR      VARCHAR(1)   := 'N';
  V_FECHA_BT      DATE         := NULL;
  
  V_TOT_CUOTA     NUMBER(18)    := 0;
  V_CANC_CAPITAL  NUMBER(18,2)  := 0;
  V_CANC_INTERES  NUMBER(18,2)  := 0;
  V_CANC_MORA      NUMBER(18,2) := 0;
  V_CANC_GASTOS    NUMBER(18,2) := 0;
  V_CANC_ICV       NUMBER(18,2) := 0;
  V_CANC_SEGURO    NUMBER(18,2) := 0;
  V_CANC_PENALIDAD NUMBER(18,2) := 0;
  V_CANC_ITF       NUMBER(18,2) := 0;
  
  V_CUOTA     NUMBER(18)   := 0;
  V_CAPITAL   NUMBER(18,2) := 0;
  V_INTERES   NUMBER(18,2) := 0;
  V_MORA      NUMBER(18,2) := 0;
  V_GASTOS    NUMBER(18,2) := 0;
  V_ICV       NUMBER(18,2) := 0;
  V_SEGURO    NUMBER(18,2) := 0;
  V_PENALIDAD NUMBER(18,2) := 0;
  V_ITF       NUMBER(18,2) := 0;
  
  BEGIN
    -- VALIDAR SI EXISTE EL CREDITO CARGADO --
    BEGIN
      SELECT 'S',
             A.AQPD412INS
        INTO V_PROCESAR,
             V_AQPD412INS
        FROM AQPD412 A
       WHERE A.AQPD412EMP  = PI_EMPRESA
         AND A.AQPD412MOD  = PI_MODULO
         AND A.AQPD412SUC  = PI_SUCURSAL
         AND A.AQPD412MDA  = PI_MONEDA
         AND A.AQPD412PAP  = PI_PAPEL
         AND A.AQPD412CTA  = PI_CUENTA
         AND A.AQPD412OPE  = PI_OPERACION
         AND A.AQPD412SOP  = PI_SOPERACION
         AND A.AQPD412TOP  = PI_TOPERACION
         AND A.AQPD412FCAR = PI_FECHA
         AND A.AQPD412EST  = 'S';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    IF V_PROCESAR = 'S' THEN
      -- OBTENER FECHA BT --
      BEGIN 
         SELECT A.PGFAPE
           INTO V_FECHA_BT
           FROM FST017 A
          WHERE A.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
          NULL;
      END;
      
      -- OBTENER TOTAL CUOTA CANCELACION --
      BEGIN
        SELECT COUNT(1)
          INTO V_TOT_CUOTA
          FROM AQPD411 A
         WHERE A.AQPD411FCAR = PI_FECHA
           AND A.AQPD411EMP  = PI_EMPRESA
           AND A.AQPD411MOD  = PI_MODULO
           AND A.AQPD411SUC  = PI_SUCURSAL
           AND A.AQPD411MDA  = PI_MONEDA
           AND A.AQPD411PAP  = PI_PAPEL
           AND A.AQPD411CTA  = PI_CUENTA
           AND A.AQPD411OPE  = PI_OPERACION
           AND A.AQPD411SOP  = PI_SOPERACION
           AND A.AQPD411TOP  = PI_TOPERACION;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      -- OBTENER TOTAL CUOTA MORA --
      BEGIN
        SELECT COUNT(1)
          INTO V_CUOTA
          FROM AQPD411 A
         WHERE A.AQPD411FCAR < PI_FECHA
           AND A.AQPD411EMP  = PI_EMPRESA
           AND A.AQPD411MOD  = PI_MODULO
           AND A.AQPD411SUC  = PI_SUCURSAL
           AND A.AQPD411MDA  = PI_MONEDA
           AND A.AQPD411PAP  = PI_PAPEL
           AND A.AQPD411CTA  = PI_CUENTA
           AND A.AQPD411OPE  = PI_OPERACION
           AND A.AQPD411SOP  = PI_SOPERACION
           AND A.AQPD411TOP  = PI_TOPERACION;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      -- OBTENER MONTO TOTAL CANCELACION --
      BEGIN
        SELECT SUM(AQPD411CAP),
               SUM(AQPD411INT),
               SUM(AQPD411MOR),
               SUM(AQPD411GST),
               SUM(AQPD411INC),
               SUM(AQPD411SEG),
               SUM(AQPD411PLD),
               SUM(AQPD411ITF)
          INTO V_CANC_CAPITAL,
               V_CANC_INTERES,
               V_CANC_MORA,
               V_CANC_GASTOS,
               V_CANC_ICV,
               V_CANC_SEGURO,
               V_CANC_PENALIDAD,
               V_CANC_ITF
          FROM AQPD411 A
         WHERE A.AQPD411FCAR = PI_FECHA
           AND A.AQPD411EMP  = PI_EMPRESA
           AND A.AQPD411MOD  = PI_MODULO
           AND A.AQPD411SUC  = PI_SUCURSAL
           AND A.AQPD411MDA  = PI_MONEDA
           AND A.AQPD411PAP  = PI_PAPEL
           AND A.AQPD411CTA  = PI_CUENTA
           AND A.AQPD411OPE  = PI_OPERACION
           AND A.AQPD411SOP  = PI_SOPERACION
           AND A.AQPD411TOP  = PI_TOPERACION;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      -- OBTENER MONTO TOTAL MORA --
      BEGIN
        SELECT SUM(AQPD411CAP),
               SUM(AQPD411INT),
               SUM(AQPD411MOR),
               SUM(AQPD411GST),
               SUM(AQPD411INC),
               SUM(AQPD411SEG),
               SUM(AQPD411PLD),
               SUM(AQPD411ITF)
          INTO V_CAPITAL,
               V_INTERES,
               V_MORA,
               V_GASTOS,
               V_ICV,
               V_SEGURO,
               V_PENALIDAD,
               V_ITF
          FROM AQPD411 A
         WHERE A.AQPD411FCAR = PI_FECHA
           AND A.AQPD411EMP  = PI_EMPRESA
           AND A.AQPD411MOD  = PI_MODULO
           AND A.AQPD411SUC  = PI_SUCURSAL
           AND A.AQPD411MDA  = PI_MONEDA
           AND A.AQPD411PAP  = PI_PAPEL
           AND A.AQPD411CTA  = PI_CUENTA
           AND A.AQPD411OPE  = PI_OPERACION
           AND A.AQPD411SOP  = PI_SOPERACION
           AND A.AQPD411TOP  = PI_TOPERACION
           AND A.AQPD411FPG  < PI_FECHA;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      -- ACTUALIZAR CABECERA CON LOS MONTOS DE CANCELACION TOTAL Y MORA --
      BEGIN
        UPDATE AQPD412 A
           SET A.AQPD412TCUO = V_TOT_CUOTA,
               A.AQPD412CCAP = V_CANC_CAPITAL,
               A.AQPD412CINT = V_CANC_INTERES,
               A.AQPD412CMOR = V_CANC_MORA,
               A.AQPD412CGST = V_CANC_GASTOS,
               A.AQPD412CICV = V_CANC_ICV,
               A.AQPD412CSEG = V_CANC_SEGURO,
               A.AQPD412CPLD = V_CANC_PENALIDAD,
               A.AQPD412CITF = V_CANC_ITF,
               A.AQPD412CUO  = V_CUOTA,
               A.AQPD412CAP  = V_CAPITAL,
               A.AQPD412INT  = V_INTERES,
               A.AQPD412MOR  = V_MORA,
               A.AQPD412GST  = V_GASTOS,
               A.AQPD412ICV  = V_ICV,
               A.AQPD412SEG  = V_SEGURO,
               A.AQPD412PLD  = V_PENALIDAD,
               A.AQPD412ITF  = V_ITF,
               A.AQPD412CDCM   = A.AQPD412CDCA  * A.AQPD412CCAP,
               A.AQPD412CDIM   = A.AQPD412CDINT * A.AQPD412CINT,
               A.AQPD412CDMM   = A.AQPD412CDMO  * A.AQPD412CMOR,
               A.AQPD412CDOM   = A.AQPD412CDOT  * A.AQPD412CGST,
               A.AQPD412CDICVM = A.AQPD412CDICV * A.AQPD412CICV,
               A.AQPD412CDSM   = A.AQPD412CDSE  * A.AQPD412CSEG,
               A.AQPD412CDPM   = A.AQPD412CDPE  * A.AQPD412CPLD,
               A.AQPD412CDITFM = A.AQPD412CDITF * A.AQPD412CITF,         
               A.AQPD412CXDC   = A.AQPD412CXDCM   * A.AQPD412CAP,
               A.AQPD412CXDI   = A.AQPD412CXDIM   * A.AQPD412INT,
               A.AQPD412CXDM   = A.AQPD412CXDMM   * A.AQPD412MOR,
               A.AQPD412CXDO   = A.AQPD412CXDOM   * A.AQPD412GST,
               A.AQPD412CXDICV = A.AQPD412CXDICVM * A.AQPD412ICV,
               A.AQPD412CXDS   = A.AQPD412CXDSM   * A.AQPD412SEG,
               A.AQPD412CXDP   = A.AQPD412CXDPM   * A.AQPD412PLD,
               A.AQPD412CXDITF = A.AQPD412CXDITFM * A.AQPD412ITF,
               A.AQPD412FEC  = V_FECHA_BT,
               A.AQPD412HOR  = TO_CHAR(SYSDATE, 'HH24:MI:SS')
         WHERE A.AQPD412EMP  = PI_EMPRESA
           AND A.AQPD412MOD  = PI_MODULO
           AND A.AQPD412SUC  = PI_SUCURSAL
           AND A.AQPD412MDA  = PI_MONEDA
           AND A.AQPD412PAP  = PI_PAPEL
           AND A.AQPD412CTA  = PI_CUENTA
           AND A.AQPD412OPE  = PI_OPERACION
           AND A.AQPD412SOP  = PI_SOPERACION
           AND A.AQPD412TOP  = PI_TOPERACION
           AND A.AQPD412FCAR = PI_FECHA
           AND A.AQPD412EST  = 'S';
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      IF V_AQPD412INS IS NULL OR V_AQPD412INS = 0 THEN
        -- OBTENER INSTANCIA --
        BEGIN
          V_INSTANCIA := FN_INSTANCIA_CREDITO(V_SCMOD  => PI_MODULO,
                                              V_SCSUC  => PI_SUCURSAL,
                                              V_SCMDA  => PI_MONEDA,
                                              V_SCPAP  => PI_PAPEL,
                                              V_SCCTA  => PI_CUENTA,
                                              V_SCOPER => PI_OPERACION,
                                              V_SCSBOP => PI_SOPERACION,
                                              V_SCTOPE => PI_TOPERACION);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        
        -- GRABAR LA INSTANCIA CABECERA --
        BEGIN
          UPDATE AQPD412 A
             SET A.AQPD412INS  = V_INSTANCIA
           WHERE A.AQPD412EMP  = PI_EMPRESA
             AND A.AQPD412MOD  = PI_MODULO
             AND A.AQPD412SUC  = PI_SUCURSAL
             AND A.AQPD412MDA  = PI_MONEDA
             AND A.AQPD412PAP  = PI_PAPEL
             AND A.AQPD412CTA  = PI_CUENTA
             AND A.AQPD412OPE  = PI_OPERACION
             AND A.AQPD412SOP  = PI_SOPERACION
             AND A.AQPD412TOP  = PI_TOPERACION
             AND A.AQPD412FCAR = PI_FECHA
             AND A.AQPD412EST  = 'S';
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        
        -- GRABAR INSTANCIA DETALLE --
        BEGIN
          UPDATE AQPD411 A
             SET A.AQPD411INS  = V_INSTANCIA
           WHERE A.AQPD411FCAR = PI_FECHA
             AND A.AQPD411EMP  = PI_EMPRESA
             AND A.AQPD411MOD  = PI_MODULO
             AND A.AQPD411SUC  = PI_SUCURSAL
             AND A.AQPD411MDA  = PI_MONEDA
             AND A.AQPD411PAP  = PI_PAPEL
             AND A.AQPD411CTA  = PI_CUENTA
             AND A.AQPD411OPE  = PI_OPERACION
             AND A.AQPD411SOP  = PI_SOPERACION
             AND A.AQPD411TOP  = PI_TOPERACION;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        -- GRABAR INSTANCIA DETALLE --
        BEGIN
          UPDATE AQPD411 A
             SET A.AQPD411INS  = V_AQPD412INS
           WHERE A.AQPD411FCAR = PI_FECHA
             AND A.AQPD411EMP  = PI_EMPRESA
             AND A.AQPD411MOD  = PI_MODULO
             AND A.AQPD411SUC  = PI_SUCURSAL
             AND A.AQPD411MDA  = PI_MONEDA
             AND A.AQPD411PAP  = PI_PAPEL
             AND A.AQPD411CTA  = PI_CUENTA
             AND A.AQPD411OPE  = PI_OPERACION
             AND A.AQPD411SOP  = PI_SOPERACION
             AND A.AQPD411TOP  = PI_TOPERACION;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    END IF;
    
  END SP_CR_GRABAR_CABECERA;

  -- ===================================================================================================

  PROCEDURE SP_CR_GRABAR_DETALLE(PI_NRO_CUOTAS IN NUMBER,
                                 PI_EMPRESA    IN NUMBER,
                                 PI_MODULO     IN NUMBER,
                                 PI_SUCURSAL   IN NUMBER,
                                 PI_MONEDA     IN NUMBER,
                                 PI_PAPEL      IN NUMBER,
                                 PI_CUENTA     IN NUMBER,
                                 PI_OPERACION  IN NUMBER,
                                 PI_SOPERACION IN NUMBER,
                                 PI_TOPERACION IN NUMBER,
                                 PI_FECHA_PAGO IN DATE,
                                 PI_FECHA      IN DATE,
                                 PI_CAPITAL    IN NUMBER,
                                 PI_INTERES    IN NUMBER,
                                 PI_MORA       IN NUMBER,
                                 PI_GASTOS     IN NUMBER,
                                 PI_INTC       IN NUMBER,
                                 PI_SEGURO     IN NUMBER,
                                 PI_PENALIDAD  IN NUMBER,
                                 PI_ITF        IN NUMBER) IS
                                 
  -- ====================================================================================================
  -- NOMBRE                      : NOMBRE_PROCEDIMIENTO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 13/10/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : 
  -- PARAMETROS                  : - PI_NRO_CUOTAS | NUMBER(10)
  --                               - PI_EMPRESA    | NUMBER(3)
  --                               - PI_MODULO     | NUMBER(3)
  --                               - PI_SUCURSAL   | NUMBER(3)
  --                               - PI_MONEDA     | NUMBER(4)
  --                               - PI_PAPEL      | NUMBER(4)
  --                               - PI_CUENTA     | NUMBER(9)
  --                               - PI_OPERACION  | NUMBER(9)
  --                               - PI_SOPERACION | NUMBER(3)
  --                               - PI_TOPERACION | NUMBER(3)
  --                               - PI_FECHA_PAGO | DATE
  --                               - PI_FECHA      | DATE
  --                               - PI_CAPITAL    | NUMBER(18,2)
  --                               - PI_INTERES    | NUMBER(18,2)
  --                               - PI_MORA       | NUMBER(18,2)
  --                               - PI_GASTOS     | NUMBER(18,2)
  --                               - PI_INTC       | NUMBER(18,2)
  --                               - PI_SEGURO     | NUMBER(18,2)
  --                               - PI_PENALIDAD  | NUMBER(18,2)
  --                               - PI_ITF        | NUMBER(18,2)
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  V_PROCESAR  VARCHAR(1) := 'N';
  V_CORREL    NUMBER(18) := 0;
  
  BEGIN    
    -- VALIDAR SI EXISTE EL CREDITO CARGADO --
    BEGIN
      SELECT 'S'
        INTO V_PROCESAR
        FROM AQPD412 A
       WHERE A.AQPD412EMP  = PI_EMPRESA
         AND A.AQPD412MOD  = PI_MODULO
         AND A.AQPD412SUC  = PI_SUCURSAL
         AND A.AQPD412MDA  = PI_MONEDA
         AND A.AQPD412PAP  = PI_PAPEL
         AND A.AQPD412CTA  = PI_CUENTA
         AND A.AQPD412OPE  = PI_OPERACION
         AND A.AQPD412SOP  = PI_SOPERACION
         AND A.AQPD412TOP  = PI_TOPERACION
         AND A.AQPD412FCAR = PI_FECHA
         AND A.AQPD412EST  = 'S';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    IF V_PROCESAR = 'S' THEN
      -- OBTENER MAXIMO CORRELATIVO --
      BEGIN
        SELECT NVL(MAX(A.AQPD411CORR), 0) + 1
          INTO V_CORREL
          FROM AQPD411 A
         WHERE A.AQPD411FCAR = PI_FECHA
           AND A.AQPD411EMP  = PI_EMPRESA
           AND A.AQPD411MOD  = PI_MODULO
           AND A.AQPD411SUC  = PI_SUCURSAL
           AND A.AQPD411MDA  = PI_MONEDA
           AND A.AQPD411PAP  = PI_PAPEL
           AND A.AQPD411CTA  = PI_CUENTA
           AND A.AQPD411OPE  = PI_OPERACION
           AND A.AQPD411SOP  = PI_SOPERACION
           AND A.AQPD411TOP  = PI_TOPERACION;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      -- GRABAR DETALLE DEUDA --              
      BEGIN
        INSERT INTO AQPD411(AQPD411CORR,
                            AQPD411FCAR,
                            AQPD411EMP,
                            AQPD411MOD,
                            AQPD411SUC,
                            AQPD411MDA,
                            AQPD411PAP,
                            AQPD411CTA,
                            AQPD411OPE,
                            AQPD411SOP,
                            AQPD411TOP,
                            AQPD411FPG,
                            AQPD411NCU,
                            AQPD411CAP,
                            AQPD411INT,
                            AQPD411MOR,
                            AQPD411GST,
                            AQPD411INC,
                            AQPD411SEG,
                            AQPD411PLD,
                            AQPD411ITF,
                            AQPD411CUO)
        VALUES(V_CORREL,
               PI_FECHA,
               PI_EMPRESA,
               PI_MODULO,
               PI_SUCURSAL,
               PI_MONEDA,
               PI_PAPEL,
               PI_CUENTA,
               PI_OPERACION,
               PI_SOPERACION,
               PI_TOPERACION,
               PI_FECHA_PAGO,
               PI_NRO_CUOTAS,
               PI_CAPITAL,
               PI_INTERES,
               PI_MORA,
               PI_GASTOS,
               PI_INTC,
               PI_SEGURO,
               PI_PENALIDAD,
               PI_ITF,
               (PI_CAPITAL + PI_INTERES + PI_MORA + PI_INTC + PI_SEGURO + PI_PENALIDAD + PI_ITF));
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END SP_CR_GRABAR_DETALLE;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_VALIDAR_MODULO(PI_MODULO   IN  NUMBER,
                                 PO_ESVALIDO OUT VARCHAR2) IS
                                 
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_VALIDAR_MODULO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 13/10/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : VALIDA EL MODULO
  -- PARAMETROS                  : - PI_MODULO   | NUMBER(3)
  --                               - PO_ESVALIDO | VARCHAR2(1)
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  V_ESVALIDO VARCHAR2(1) := 'N';
  
  BEGIN
    BEGIN
      SELECT 'S'
        INTO V_ESVALIDO
        FROM FST111 A
       WHERE A.DSCOD  = 50
         AND A.MODULO = PI_MODULO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    PO_ESVALIDO := V_ESVALIDO;
  END SP_CR_VALIDAR_MODULO;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_GRABAR_ESTADO_PROCESO(PI_FEC_CARGA  IN DATE,
                                        PI_EMPRESA    IN NUMBER,
                                        PI_MODULO     IN NUMBER,
                                        PI_SUCURSAL   IN NUMBER,
                                        PI_MONEDA     IN NUMBER,
                                        PI_PAPEL      IN NUMBER,
                                        PI_CUENTA     IN NUMBER,
                                        PI_OPERACION  IN NUMBER,
                                        PI_SOPERACION IN NUMBER,
                                        PI_TOPERACION IN NUMBER,
                                        PI_COD_ERROR  IN NUMBER,
                                        PI_MSG_ERROR  IN VARCHAR2) IS
                                        
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_GRABAR_ESTADO_PROCESO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 13/10/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : GRABAR ESTADO DEL PROCESO
  -- PARAMETROS                  : - PI_FEC_CARGA  | DATE
  --                               - PI_EMPRESA    | NUMBER(3)
  --                               - PI_MODULO     | NUMBER(3)
  --                               - PI_SUCURSAL   | NUMBER(3)
  --                               - PI_MONEDA     | NUMBER(4)
  --                               - PI_PAPEL      | NUMBER(4)
  --                               - PI_CUENTA     | NUMBER(9)
  --                               - PI_OPERACION  | NUMBER(9)
  --                               - PI_SOPERACION | NUMBER(3)
  --                               - PI_TOPERACION | NUMBER(3)
  --                               - PI_COD_ERROR  | NUMBER(5)
  --                               - PI_MSG_ERROR  | VARCHAR2(255)
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  V_FECHA_BT DATE := NULL;
  
  BEGIN
    -- OBTENER FECHA BT --
    BEGIN 
     SELECT A.PGFAPE
        INTO V_FECHA_BT
        FROM FST017 A
       WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    BEGIN
      UPDATE AQPD412 A
         SET A.AQPD412CERR = PI_COD_ERROR,
             A.AQPD412MERR = PI_MSG_ERROR,
             A.AQPD412FEC  = V_FECHA_BT,
             A.AQPD412HOR  = TO_CHAR(SYSDATE, 'HH24:MI:SS')
        WHERE A.AQPD412EMP  = PI_EMPRESA
          AND A.AQPD412MOD  = PI_MODULO
          AND A.AQPD412SUC  = PI_SUCURSAL
          AND A.AQPD412MDA  = PI_MONEDA
          AND A.AQPD412PAP  = PI_PAPEL
          AND A.AQPD412CTA  = PI_CUENTA
          AND A.AQPD412OPE  = PI_OPERACION
          AND A.AQPD412SOP  = PI_SOPERACION
          AND A.AQPD412TOP  = PI_TOPERACION
          AND A.AQPD412FCAR = PI_FEC_CARGA
          AND A.AQPD412EST  = 'S';
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_GRABAR_ESTADO_PROCESO;
  
  -- ====================================================================================================
  PROCEDURE SP_CR_ELIMINAR_DATA(PI_FEC_CARGA  IN DATE,
                                PI_EMPRESA    IN NUMBER,
                                PI_MODULO     IN NUMBER,
                                PI_SUCURSAL   IN NUMBER,
                                PI_MONEDA     IN NUMBER,
                                PI_PAPEL      IN NUMBER,
                                PI_CUENTA     IN NUMBER,
                                PI_OPERACION  IN NUMBER,
                                PI_SOPERACION IN NUMBER,
                                PI_TOPERACION IN NUMBER) IS
                                
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_ELIMINAR_DATA
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 13/10/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : ELIMINA LA DATA CARGADA PARA VOLVER A REGISTRAR PARA OBTENER LA
  --                               ULTIMA ACTUALIZACION
  -- PARAMETROS                  :
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================

  BEGIN
    BEGIN
      DELETE FROM AQPD411 A
        WHERE A.AQPD411FCAR = PI_FEC_CARGA
         AND A.AQPD411EMP  = PI_EMPRESA
         AND A.AQPD411MOD  = PI_MODULO
         AND A.AQPD411SUC  = PI_SUCURSAL
         AND A.AQPD411MDA  = PI_MONEDA
         AND A.AQPD411PAP  = PI_PAPEL
         AND A.AQPD411CTA  = PI_CUENTA
         AND A.AQPD411OPE  = PI_OPERACION
         AND A.AQPD411SOP  = PI_SOPERACION
         AND A.AQPD411TOP  = PI_TOPERACION;
      COMMIT;
    EXCEPTION
       WHEN OTHERS THEN
          NULL;
    END;
  END SP_CR_ELIMINAR_DATA;
  
  -- ====================================================================================================
  PROCEDURE SP_CR_CARGA_BANDEJAS_A_BT IS
  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_CARGA_BANDEJAS_A_BT
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 13/10/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : REALIZAR LA CARGA EN LA TABLA BT DESDE EL ESQUEMA DE BANDEJAS
  -- PARAMETROS                  :
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  BEGIN
    BEGIN
      INSERT INTO AQPD412(AQPD412EMP,
                          AQPD412MOD,
                          AQPD412SUC,
                          AQPD412MDA,
                          AQPD412PAP,
                          AQPD412CTA,
                          AQPD412OPE,
                          AQPD412SOP,
                          AQPD412TOP,
                          AQPD412FCAR,
                          AQPD412INS,
                          AQPD412PDOC,
                          AQPD412TDOC,
                          AQPD412NDOC,
                          AQPD412SDOC,
                          AQPD412MTMD,
                          AQPD412NMRE,
                          AQPD412NMZO,
                          AQPD412NMAG,
                          AQPD412CMTE,
                          AQPD412CDAN,
                          AQPD412NMCL,
                          AQPD412NCVG,
                          AQPD412STKP,
                          AQPD412GRPC,
                          AQPD412PORP,
                          AQPD412GRUP,
                          AQPD412FRPG,
                          AQPD412RATR,
                          AQPD412CALI,
                          AQPD412CLIA,
                          AQPD412FREF,
                          AQPD412CDCA,
                          AQPD412CDINT,
                          AQPD412CDMO,
                          AQPD412CDOT,
                          AQPD412CDICV,
                          AQPD412CDSE,
                          AQPD412CDPE,
                          AQPD412CDITF,
                          AQPD412CXDC,
                          AQPD412CXDI,
                          AQPD412CXDM,
                          AQPD412CXDO,
                          AQPD412CXDICV,
                          AQPD412CXDS,
                          AQPD412CXDP,
                          AQPD412CXDITF,
                          AQPD412EST)
      SELECT A.AQPD413EMP,   
             A.AQPD413MOD,
             A.AQPD413SUC,
             A.AQPD413MDA,
             A.AQPD413PAP,   
             A.AQPD413CTA,   
             A.AQPD413OPE,   
             A.AQPD413SOP,   
             A.AQPD413TOP,   
             A.AQPD413FCAR,   
             A.AQPD413INS,  
             A.AQPD413PDOC,   
             A.AQPD413TDOC,  
             A.AQPD413NDOC,  
             A.AQPD413SDOC,  
             A.AQPD413MTMD,   
             A.AQPD413NMRE,   
             A.AQPD413NMZO,  
             A.AQPD413NMAG,  
             A.AQPD413CMTE,  
             A.AQPD413CDAN,  
             A.AQPD413NMCL,  
             A.AQPD413NCVG,  
             A.AQPD413STKP,  
             A.AQPD413GRPC,  
             A.AQPD413PORP,  
             A.AQPD413GRUP,  
             A.AQPD413FRPG,  
             A.AQPD413RATR,  
             A.AQPD413CALI,  
             A.AQPD413CLIA,  
             A.AQPD413FREF,  
             A.AQPD413CDCA,  
             A.AQPD413CDINT,  
             A.AQPD413CDMO, 
             A.AQPD413CDOT,  
             A.AQPD413CDICV,  
             A.AQPD413CDSE, 
             A.AQPD413CDPE,  
             A.AQPD413CDITF,
             A.AQPD413CXDC,
             A.AQPD413CXDI,  
             A.AQPD413CXDM,  
             A.AQPD413CXDO,  
             A.AQPD413CXDICV, 
             A.AQPD413CXDS,
             A.AQPD413CXDP,  
             A.AQPD413CXDITF,
             'S'   
          FROM USRBNDJ.AQPD413 A;
      COMMIT;
    EXCEPTION
       WHEN OTHERS THEN
          NULL;
    END;
    
    BEGIN
      DELETE FROM USRBNDJ.AQPD413 A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_CARGA_BANDEJAS_A_BT;
  
  -- ====================================================================================================
  PROCEDURE SP_CR_GRABAR_CRED_REFI IS
  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_GRABAR_CRED_REFI
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 13/10/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : GRABAR EN LA TABLA DE CREDTIOS REFINANCIADOS
  -- PARAMETROS                  : - PI_FECHA_CARGA | DATE
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  V_FECHA_BT DATE := NULL;
  
  BEGIN
    BEGIN 
      SELECT A.PGFAPE
        INTO V_FECHA_BT
        FROM FST017 A
       WHERE A.PGCOD = 1;
    EXCEPTION
       WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      INSERT INTO AQPD153
        (AQPD153PAIS,
         AQPD153TIPDOC,
         AQPD153NUMDOC,
         AQPD153EMP,
         AQPD153MOD,
         AQPD153SUC,
         AQPD153MDA,
         AQPD153PAP,
         AQPD153CTA,
         AQPD153OPE,
         AQPD153SBOP,
         AQPD153TOPE,
         AQPD153INST,
         AQPD153MTO,
         AQPD153MTOCAP,
         AQPD153FECCAR,
         AQPD153HORCAR,
         AQPD153ESTCAR,
         AQPD153MEMO)
        SELECT A.AQPD412PDOC,
               A.AQPD412TDOC,
               A.AQPD412NDOC,
               A.AQPD412EMP,
               A.AQPD412MOD,
               A.AQPD412SUC,
               A.AQPD412MDA,
               A.AQPD412PAP,
               A.AQPD412CTA,
               A.AQPD412OPE,
               A.AQPD412SOP,
               A.AQPD412TOP,
               A.AQPD412INS,
               A.AQPD412SDOC,
               A.AQPD412MTMD,
               A.AQPD412FCAR,
               A.AQPD412HOR,
               'H',
               'SANEAMIENTO'
          FROM AQPD412 A
         WHERE A.AQPD412FCAR = V_FECHA_BT
           AND A.AQPD412EST = 'S';
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_GRABAR_CRED_REFI;
    
END PQ_CR_SITUACION_OPERACIONES;
/
