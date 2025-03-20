CREATE OR REPLACE PACKAGE PQ_CR_DATOS_SEGMENTACION IS
   
   -----------------------------------------------------------------------------------------
   -- NOMBRE                      : PQ_CR_DATOS_SEGMENTACION
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 16/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   -----------------------------------------------------------------------------------------

   -----------------------------------------------------------------------------------------
   PROCEDURE SP_CR_VALIDAR_ETAPA_CREDITO(P_INSTANCIA    IN  NUMBER,
                                         P_ITEM_ETAPA   OUT NUMBER,
                                         P_CODIGO_ETAPA OUT NUMBER,
                                         P_NOMBRE_ETAPA OUT VARCHAR2);
   
   -----------------------------------------------------------------------------------------                                   
   PROCEDURE SP_CR_VALIDAR_SALDO_SBS(P_INSTANCIA        IN  NUMBER,
                                     P_INCREMENTO_SALDO OUT VARCHAR2);
   
   -----------------------------------------------------------------------------------------
   PROCEDURE SP_CR_OBTENER_CALIFICACION(P_INSTANCIA        IN  NUMBER,
                                        P_FECHA_RCC        OUT DATE,
                                        P_CALIF_NORMAL     OUT NUMBER,
                                        P_CALIF_CPP        OUT NUMBER,
                                        P_CALIF_DEFICIENTE OUT NUMBER,
                                        P_CALIF_DUDOSO     OUT NUMBER,
                                        P_CALIF_PERDIDA    OUT NUMBER);
   
   -----------------------------------------------------------------------------------------                                  
   PROCEDURE SP_CR_VALIDAR_IMPORTE_EXCEPTION(P_INSTANCIA       IN  NUMBER,
                                             P_IMPORTE         OUT NUMBER,
                                             P_EXCEPCION       OUT VARCHAR2,
                                             P_CODIGO_ERROR    OUT VARCHAR2,
                                             P_MENSAJE_ERROR   OUT VARCHAR2);                                     
                                                                             
   -----------------------------------------------------------------------------------------
   PROCEDURE SP_CR_GRABAR_LOG_SEGMENTACION(P_USUARIO_REGISTRO  IN VARCHAR2,
                                           P_INSTANCIA         IN VARCHAR2,
                                           P_EMPRESA           IN VARCHAR2,
                                           P_MODULO            IN NUMBER,
                                           P_SUCURSAL          IN NUMBER,
                                           P_MONEDA            IN NUMBER,
                                           P_PAPEL             IN NUMBER,
                                           P_CUENTA            IN NUMBER,
                                           P_OPERACION         IN NUMBER,
                                           P_SUBOPERACION      IN NUMBER,
                                           P_TIPO_OPERACION    IN NUMBER,
                                           P_ITEM_ETAPA        IN NUMBER,
                                           P_CODIGO_ETAPA      IN NUMBER,
                                           P_NOMBRE_ETAPA      IN VARCHAR2,
                                           P_TIPO_SEGMENTO     IN NUMBER,
                                           P_COD_SEGM_ANTERIOR IN NUMBER,
                                           P_NOM_SEGM_ANTERIOR IN VARCHAR2,
                                           P_COD_SEGM_ACTUAL   IN NUMBER,
                                           P_NOM_SEGM_ACTUAL   IN VARCHAR2,
                                           P_MONTO_PROPUESTO   IN NUMBER,
                                           P_TOPE_SEGMENTO     IN NUMBER,
                                           P_TOPE_MAXIMO_SEG   IN NUMBER,
                                           P_PORCENTAJE_SEG    IN NUMBER,
                                           P_PROMEDIO_DIAS     IN NUMBER,
                                           P_FECHA_RCC         IN DATE,
                                           P_CALIF_NORMAL      IN NUMBER,
                                           P_CALIF_CPP         IN NUMBER,
                                           P_CALIF_DEFICIENTE  IN NUMBER,
                                           P_CALIF_DUDOSO      IN NUMBER,
                                           P_CALIF_PERDIDA     IN NUMBER,
                                           P_ESTADO            IN VARCHAR2,
                                           P_CODERROR          OUT VARCHAR2,
                                           P_MSGERROR          OUT VARCHAR2);

END PQ_CR_DATOS_SEGMENTACION;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_DATOS_SEGMENTACION IS

   PROCEDURE SP_CR_VALIDAR_ETAPA_CREDITO(P_INSTANCIA    IN  NUMBER,
                                         P_ITEM_ETAPA   OUT NUMBER,
                                         P_CODIGO_ETAPA OUT NUMBER,
                                         P_NOMBRE_ETAPA OUT VARCHAR2) IS
                                         
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_ETAPA_CREDITO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 16/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- PARAMETROS                  : - P_INSTANCIA   : NUMBER(10)
   --                               - P_ITEM_ETAPA  : NUMBER(10)
   --                               - P_CODIGO_ETAPA: NUMBER(4)
   --                               - P_NOMBRE_ETAPA: VARCHAR2(50)
   -- USO                         : VALIDA LA ETAPA EN LA QUE SE ENCUENTRA
   --                               EL CREDITO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      ITEM_ETAPA   NUMBER(10);
      CODIGO_ETAPA NUMBER(4);
      NOMBRE_ETAPA VARCHAR2(50);
   BEGIN
      ITEM_ETAPA   := 0;
      CODIGO_ETAPA := 0;
      BEGIN
         SELECT A1.WFITEMID, A1.WFTASKCOD, TRIM(B1.WFTASKNAME)
           INTO ITEM_ETAPA, CODIGO_ETAPA, NOMBRE_ETAPA
           FROM WFWRKITEMS A1, WFTASK B1
          WHERE A1.WFINSPRCID   = P_INSTANCIA
            AND A1.WFITEMSTSACT = 1
            AND A1.WFITEMID     = (SELECT MAX(A2.WFITEMID)
                                     FROM WFWRKITEMS A2
                                    WHERE A2.WFINSPRCID   = A1.WFINSPRCID
                                      AND A2.WFITEMSTSACT = 1)
            AND A1.WFTASKCOD < (SELECT A3.TPIMP
                                  FROM FST098 A3
                                 WHERE A3.PGCOD  = 1
                                   AND A3.TPCOD  = 7753
                                   AND A3.TPCORR = 13
                                   AND A3.TPNRO  = 1)
            AND B1.WFPRCID   = 2
            AND B1.WFTASKCOD = A1.WFTASKCOD;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_ITEM_ETAPA   := ITEM_ETAPA;
      P_CODIGO_ETAPA := CODIGO_ETAPA;
      P_NOMBRE_ETAPA := NOMBRE_ETAPA;
      
   END SP_CR_VALIDAR_ETAPA_CREDITO;
   
/*==================================================================================================================*/
   PROCEDURE SP_CR_VALIDAR_SALDO_SBS(P_INSTANCIA        IN  NUMBER,
                                     P_INCREMENTO_SALDO OUT VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_SALDO_SBS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 16/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- PARAMETROS                  : - P_INSTANCIA        : NUMBER(10)
   --                               - P_INCREMENTO_SALDO : VARCHAR2(2)
   -- USO                         : VALIDA SI TIENE UN INCREMENTO DE SALDO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      PAIS_DOCUMENTO   NUMBER(3);
      TIPO_DOCUMENTO   NUMBER(2);
      NRO_DOCUMENTO    VARCHAR2(12);
      INCREMENTO_SALDO VARCHAR2(1);
   BEGIN
      PAIS_DOCUMENTO := 0;
      TIPO_DOCUMENTO := 0;
      NRO_DOCUMENTO  := NULL;
      BEGIN
         SELECT A1.SNG001PAIS, A1.SNG001TDOC, A1.SNG001NDOC
           INTO PAIS_DOCUMENTO, TIPO_DOCUMENTO, NRO_DOCUMENTO
           FROM SNG001 A1
          WHERE A1.SNG001INST = P_INSTANCIA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      INCREMENTO_SALDO := NULL;
      BEGIN
         PQ_CR_CALCULO_SALDOS.SP_OBTENER_SALDO_SBS(PN_PAIS   => PAIS_DOCUMENTO,
                                                   PN_TIPDOC => TIPO_DOCUMENTO,
                                                   PC_NUMDOC => NRO_DOCUMENTO,
                                                   VO_RPTA   => INCREMENTO_SALDO);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_INCREMENTO_SALDO := INCREMENTO_SALDO;
   END SP_CR_VALIDAR_SALDO_SBS;
   
/*==================================================================================================================*/ 
   PROCEDURE SP_CR_OBTENER_CALIFICACION(P_INSTANCIA        IN  NUMBER,
                                        P_FECHA_RCC        OUT DATE,
                                        P_CALIF_NORMAL     OUT NUMBER,
                                        P_CALIF_CPP        OUT NUMBER,
                                        P_CALIF_DEFICIENTE OUT NUMBER,
                                        P_CALIF_DUDOSO     OUT NUMBER,
                                        P_CALIF_PERDIDA    OUT NUMBER) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_CALIFICACION
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 16/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- PARAMETROS                  : - P_INSTANCIA        : NUMBER(10)
   --                               - P_FECHA_RCC        : DATE
   --                               - P_CALIF_NORMAL     : NUMBER(5, 2)
   --                               - P_CALIF_CPP        : NUMBER(5, 2)
   --                               - P_CALIF_DEFICIENTE : NUMBER(5, 2)
   --                               - P_CALIF_DUDOSO     : NUMBER(5, 2)
   --                               - P_CALIF_PERDIDA    : NUMBER(5, 2)
   -- USO                         : OBTIENE LA CALIFICACION DEL CLIENTE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      CUENTA_CREDITO   NUMBER(9);
      PAIS_DOCUMENTO   NUMBER(3);
      TIPO_DOCUMENTO   NUMBER(2);
      CALIF_NORMAL     NUMBER(5, 2);
      CALIF_CPP        NUMBER(5, 2);
      CALIF_DEFICIENTE NUMBER(5, 2);
      CALIF_DUDOSO     NUMBER(5, 2);
      CALIF_PERDIDA    NUMBER(5, 2);
      NRO_DOCUMENTO    VARCHAR2(12);
      FECHA_RCC        DATE;
   BEGIN
      CUENTA_CREDITO := 0;
      BEGIN
         SELECT A1.XWFCUENTA
           INTO CUENTA_CREDITO
           FROM XWF700 A1
          WHERE A1.XWFPRCINS = P_INSTANCIA
            AND A1.XWFCAR3   = '1';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      PAIS_DOCUMENTO := 0;
      TIPO_DOCUMENTO := 0;
      NRO_DOCUMENTO  := NULL;
      BEGIN
         SELECT A1.PEPAIS, A1.PETDOC, TRIM(A1.PENDOC)
           INTO PAIS_DOCUMENTO, TIPO_DOCUMENTO, NRO_DOCUMENTO
           FROM FSR008 A1
          WHERE A1.PGCOD  = 1
            AND A1.CTNRO  = CUENTA_CREDITO
            AND A1.CTTFIR = 'T';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      FECHA_RCC := NULL;
      BEGIN
         SELECT TO_DATE(A1.TPNRO, 'DD/MM/RRRR')
           INTO FECHA_RCC
           FROM FST098 A1
          WHERE A1.PGCOD  = 1
            AND A1.TPCOD  = 7647
            AND A1.TPCORR = 12;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      CALIF_NORMAL     := 0;
      CALIF_CPP        := 0;
      CALIF_DEFICIENTE := 0;
      CALIF_DUDOSO     := 0;
      CALIF_PERDIDA    := 0;
      BEGIN
         SELECT A1.N_CALIF0, A1.N_CALIF1, A1.N_CALIF2,
                A1.N_CALIF3, A1.N_CALIF4
           INTO CALIF_NORMAL, CALIF_CPP, CALIF_DEFICIENTE,
                CALIF_DUDOSO, CALIF_PERDIDA
           FROM CLDRCCI A1
          WHERE A1.D_FECPRE = FECHA_RCC
            AND A1.C_TDOCID = (SELECT TRIM(TO_CHAR(A3.TP1NRO2))
                                 FROM FST198 A3
                                WHERE A3.TP1COD   = 1
                                  AND A3.TP1COD1  = 11111
                                  AND A3.TP1CORR1 = 1
                                  AND A3.TP1CORR2 = 5
                                  AND A3.TP1CORR3 > 0
                                  AND A3.TP1NRO1  = TIPO_DOCUMENTO)
            AND A1.C_DOCIDE = NRO_DOCUMENTO
            AND ROWNUM      = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT A1.N_CALIF0, A1.N_CALIF1, A1.N_CALIF2,
                      A1.N_CALIF3, A1.N_CALIF4
                 INTO CALIF_NORMAL, CALIF_CPP, CALIF_DEFICIENTE,
                      CALIF_DUDOSO, CALIF_PERDIDA
                 FROM CLDRCCI A1
                WHERE A1.D_FECPRE = FECHA_RCC
                  AND A1.C_TDOCTR = (SELECT TRIM(TO_CHAR(A3.TP1NRO2))
                                       FROM FST198 A3
                                      WHERE A3.TP1COD   = 1
                                        AND A3.TP1COD1  = 11111
                                        AND A3.TP1CORR1 = 1
                                        AND A3.TP1CORR2 = 5
                                        AND A3.TP1CORR3 > 0
                                        AND A3.TP1NRO1  = TIPO_DOCUMENTO)
                  AND A1.C_DOCTRI = NRO_DOCUMENTO
                  AND ROWNUM      = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_FECHA_RCC        := FECHA_RCC;
      P_CALIF_NORMAL     := CALIF_NORMAL;
      P_CALIF_CPP        := CALIF_CPP;
      P_CALIF_DEFICIENTE := CALIF_DEFICIENTE;
      P_CALIF_DUDOSO     := CALIF_DUDOSO;
      P_CALIF_PERDIDA    := CALIF_PERDIDA;
      
   END SP_CR_OBTENER_CALIFICACION;
   
/*==================================================================================================================*/
   PROCEDURE SP_CR_VALIDAR_IMPORTE_EXCEPTION(P_INSTANCIA       IN  NUMBER,
                                             P_IMPORTE         OUT NUMBER,
                                             P_EXCEPCION       OUT VARCHAR2,
                                             P_CODIGO_ERROR    OUT VARCHAR2,
                                             P_MENSAJE_ERROR   OUT VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_IMPORTE_EXCEPTION
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 16/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- PARAMETROS                  : - P_INSTANCIA     : NUMBER(10)
   --                               - P_IMPORTE       : NUMBER(17, 2)
   --                               - P_EXCEPCION     : VARCHAR2(1)
   --                               - P_CODIGO_ERROR  : VARCHAR2(5)
   --                               - P_MENSAJE_ERROR : VARCHAR2(255)
   -- USO                         : VALIDA SI EL MONTO PROPUESTO EXISTE EN LA TABLA LOG
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      MONTO_PROPUESTO NUMBER(17, 2);
      EXCEPCION       VARCHAR2(1);
      CODIGO_ERROR    VARCHAR2(5);
      MENSAJE_ERROR   VARCHAR2(255);                                        
   BEGIN
      CODIGO_ERROR    := '00000';
      MENSAJE_ERROR   := NULL;
      MONTO_PROPUESTO := 0;
      EXCEPCION       := 'N';
      BEGIN
         SELECT A1.AQPC791MTOPRO, 'S'
           INTO MONTO_PROPUESTO, EXCEPCION
           FROM AQPC791 A1
          WHERE A1.AQPC791INST = P_INSTANCIA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_IMPORTE       := MONTO_PROPUESTO;
      P_EXCEPCION     := EXCEPCION;
      P_CODIGO_ERROR  := CODIGO_ERROR;
      P_MENSAJE_ERROR := MENSAJE_ERROR;
      
   END SP_CR_VALIDAR_IMPORTE_EXCEPTION;

/*==================================================================================================================*/
   PROCEDURE SP_CR_GRABAR_LOG_SEGMENTACION(P_USUARIO_REGISTRO  IN VARCHAR2,
                                           P_INSTANCIA         IN VARCHAR2,
                                           P_EMPRESA           IN VARCHAR2,
                                           P_MODULO            IN NUMBER,
                                           P_SUCURSAL          IN NUMBER,
                                           P_MONEDA            IN NUMBER,
                                           P_PAPEL             IN NUMBER,
                                           P_CUENTA            IN NUMBER,
                                           P_OPERACION         IN NUMBER,
                                           P_SUBOPERACION      IN NUMBER,
                                           P_TIPO_OPERACION    IN NUMBER,
                                           P_ITEM_ETAPA        IN NUMBER,
                                           P_CODIGO_ETAPA      IN NUMBER,
                                           P_NOMBRE_ETAPA      IN VARCHAR2,
                                           P_TIPO_SEGMENTO     IN NUMBER,
                                           P_COD_SEGM_ANTERIOR IN NUMBER,
                                           P_NOM_SEGM_ANTERIOR IN VARCHAR2,
                                           P_COD_SEGM_ACTUAL   IN NUMBER,
                                           P_NOM_SEGM_ACTUAL   IN VARCHAR2,
                                           P_MONTO_PROPUESTO   IN NUMBER,
                                           P_TOPE_SEGMENTO     IN NUMBER,
                                           P_TOPE_MAXIMO_SEG   IN NUMBER,
                                           P_PORCENTAJE_SEG    IN NUMBER,
                                           P_PROMEDIO_DIAS     IN NUMBER,
                                           P_FECHA_RCC         IN DATE,
                                           P_CALIF_NORMAL      IN NUMBER,
                                           P_CALIF_CPP         IN NUMBER,
                                           P_CALIF_DEFICIENTE  IN NUMBER,
                                           P_CALIF_DUDOSO      IN NUMBER,
                                           P_CALIF_PERDIDA     IN NUMBER,
                                           P_ESTADO            IN VARCHAR2,
                                           P_CODERROR          OUT VARCHAR2,
                                           P_MSGERROR          OUT VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_GRABAR_LOG_SEGMENTACION
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 16/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- PARAMETROS                  : - P_USUARIO_REGISTRO  : VARCHAR2(10)
   --                               - P_INSTANCIA         : NUMBER(10)
   --                               - P_EMPRESA           : NUMBER(3)
   --                               - P_MODULO            : NUMBER(3)
   --                               - P_SUCURSAL          : NUMBER(3)
   --                               - P_MONEDA            : NUMBER(4)
   --                               - P_PAPEL             : NUMBER(4)
   --                               - P_CUENTA            : NUMBER(9)
   --                               - P_OPERACION         : NUMBER(9)
   --                               - P_SUBOPER           : NUMBER(3)
   --                               - P_TIPO_OPER         : NUMBER(3)
   --                               - P_ITEM_ETAPA        : NUMBER(10)
   --                               - P_CODIGO_ETAPA      : NUMBER(4)
   --                               - P_NOMBRE_ETAPA      : VARCHAR2(50)
   --                               - P_TIPO_SEGMENTO     : NUMBER(2)
   --                               - P_COD_SEGM_ANTERIOR : NUMBER(5)
   --                               - P_NOM_SEGM_ANTERIOR : VARCHAR2(40)
   --                               - P_COD_SEGM_ACTUAL   : NUMBER(5)
   --                               - P_NOM_SEGM_ACTUAL   : VARCHAR2(40)
   --                               - P_MONTO_PROPUESTO   : NUMBER(17, 2)
   --                               - P_TOPE_SEGMENTO     : NUMBER(17, 2)
   --                               - P_TOPE_MAXIMO_SEG   : NUMBER(17, 2)
   --                               - P_PORCENTAJE_SEG    : NUMBER(17, 2)
   --                               - P_PROMEDIO_DIAS     : NUMBER(9, 2)
   --                               - P_FECHA_RCC         : DATE
   --                               - P_CLASIF_NORMAL     : NUMBER(5, 2)
   --                               - P_CLASIF_CPP        : NUMBER(5, 2)
   --                               - P_CALIF_DEFICIENTE  : NUMBER(5, 2)
   --                               - P_CALIF_DUDOSO      : NUMBER(5, 2)
   --                               - P_CALIF_PERDIDA     : NUMBER(5, 2)
   --                               - P_ESTADO            : VARCHAR2(1)
   --                               - P_CODERROR          : VARCHAR2(1)
   --                               - P_MSGERROR          : VARCHAR2(1)
   -- USO                         : GRABA EL MONTO APROBADO DE LA SEGMENTACION
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      FECHA_SISTEMA  DATE          := NULL;
      PAIS_DOCUMENTO NUMBER(3)     := NULL;
      TIPO_DOCUMENTO NUMBER(2)     := NULL;
      CORRELATIVO    NUMBER(17)    := NULL;
      NRO_DOCUMENTO  VARCHAR2(12)  := NULL;
      V_EXSTREG      VARCHAR2(1)   := 'N';
      V_CODERROR     VARCHAR2(5)   := '00000';
      V_MSGERROR     VARCHAR2(255) := NULL;                     
   BEGIN
      BEGIN
         SELECT 'S'
           INTO V_EXSTREG
           FROM AQPC791 A1
          WHERE A1.AQPC791INST   = P_INSTANCIA
            AND A1.AQPC791ESTADO = P_ESTADO;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT A1.PGFAPE
                 INTO FECHA_SISTEMA
                 FROM FST017 A1
                WHERE A1.PGCOD = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            
            BEGIN
               SELECT NVL(MAX(A1.AQPC791CORR), 0) + 1
                 INTO CORRELATIVO
                 FROM AQPC791 A1
                WHERE A1.AQPC791FHREG = FECHA_SISTEMA;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            
            BEGIN
               SELECT A1.PEPAIS, A1.PETDOC, A1.PENDOC
                 INTO PAIS_DOCUMENTO, TIPO_DOCUMENTO, NRO_DOCUMENTO
                 FROM FSR008 A1
                WHERE A1.PGCOD  = 1
                  AND A1.CTNRO  = P_CUENTA
                  AND A1.CTTFIR = 'T';
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;

            BEGIN
               INSERT INTO AQPC791 (AQPC791CORR,
                                    AQPC791FHREG,
                                    AQPC791HOREG,
                                    AQPC791USREG,
                                    AQPC791INST,
                                    AQPC791EMP,
                                    AQPC791MOD,
                                    AQPC791SUC,
                                    AQPC791MDA,
                                    AQPC791PAP,
                                    AQPC791CTA,
                                    AQPC791OPER,
                                    AQPC791SBOP,
                                    AQPC791TOPE,
                                    AQPC791PAIS,
                                    AQPC791TDOC,
                                    AQPC791NDOC,
                                    AQPC791ITMETP,
                                    AQPC791CODETP,
                                    AQPC791NOMETP,
                                    AQPC791TIPSEG,
                                    AQPC791CSEGAN,
                                    AQPC791NSEGAN,
                                    AQPC791CSEGAC,
                                    AQPC791NSEGAC,
                                    AQPC791MTOPRO,
                                    AQPC791TOPSEG,
                                    AQPC791MAXSEG,
                                    AQPC791PRJSEG,
                                    AQPC791PRMDIA,
                                    AQPC791FHRCC,
                                    AQPC791NORMAL,
                                    AQPC791CPP,
                                    AQPC791DEFI,
                                    AQPC791DUDOSO,
                                    AQPC791PERDID,
                                    AQPC791ESTADO)
               VALUES (CORRELATIVO,
                       FECHA_SISTEMA,
                       TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                       P_USUARIO_REGISTRO,
                       P_INSTANCIA,
                       P_EMPRESA,      
                       P_MODULO,
                       P_SUCURSAL,
                       P_MONEDA,
                       P_PAPEL,
                       P_CUENTA,
                       P_OPERACION,
                       P_SUBOPERACION,
                       P_TIPO_OPERACION,
                       PAIS_DOCUMENTO,
                       TIPO_DOCUMENTO,
                       NRO_DOCUMENTO,
                       P_ITEM_ETAPA,
                       P_CODIGO_ETAPA,
                       P_NOMBRE_ETAPA,
                       P_TIPO_SEGMENTO,
                       P_COD_SEGM_ANTERIOR,
                       P_NOM_SEGM_ANTERIOR,
                       P_COD_SEGM_ACTUAL,
                       P_NOM_SEGM_ACTUAL,
                       P_MONTO_PROPUESTO,
                       P_TOPE_SEGMENTO,
                       P_TOPE_MAXIMO_SEG,
                       P_PORCENTAJE_SEG,
                       P_PROMEDIO_DIAS,
                       P_FECHA_RCC,
                       P_CALIF_NORMAL,
                       P_CALIF_CPP,
                       P_CALIF_DEFICIENTE,
                       P_CALIF_DUDOSO,
                       P_CALIF_PERDIDA,
                       P_ESTADO);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN OTHERS THEN
            NULL;
      END;
      
      IF V_EXSTREG = 'S' THEN
         CASE
            WHEN P_ESTADO = 'A' THEN
               V_CODERROR := '90001';
               V_MSGERROR := 'La solicitud ' || P_INSTANCIA || ' ya se encuentra aprobada';
            WHEN P_ESTADO = 'R' THEN
               V_CODERROR := '90002';
               V_MSGERROR := 'La solicitud ' || P_INSTANCIA || ' ya se encuentra rechazada. Generar una nueva solicitud';
            ELSE
               NULL;
         END CASE;
      END IF;
      
      P_CODERROR := V_CODERROR;
      P_MSGERROR := V_MSGERROR;
      
   END SP_CR_GRABAR_LOG_SEGMENTACION;

END PQ_CR_DATOS_SEGMENTACION;
/

