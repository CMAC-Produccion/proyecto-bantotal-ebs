CREATE OR REPLACE PACKAGE PQ_CR_CONVENIO_CONS IS
  
   -- **************************************************************************************
   -- NOMBRE                      : PQ_CR_CONVENIO_CONS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 08/08/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 18/10/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE MODIFICO EL PROCEDIMIENTO
   --                               - SP_CR_OBTENER_DOC_EMPLEADOR
   -- **************************************************************************************

   /*==================================================================================================================*/
   PROCEDURE SP_CR_CONDICION_FECHA(PN_NUMINS  IN  NUMBER,  
                                 PC_INDICADOR OUT VARCHAR2,                        
                                 PD_FECHA     OUT DATE);
                                 
   /*==================================================================================================================*/
   PROCEDURE SP_CR_OBTENER_CONVENIO(P_INSTANCIA    IN  NUMBER,
                                    P_NRO_CONVENIO OUT NUMBER,
                                    P_NOM_CONVENIO OUT VARCHAR2);
                                    
   /*==================================================================================================================*/
   PROCEDURE SP_CR_OBTENER_FECHA_CUOTA_MAX(P_INSTANCIA       IN  NUMBER,
                                           P_FECHA_MAX_CUOTA OUT DATE);
                                           
   /*==================================================================================================================*/
   PROCEDURE SP_CR_OBTENER_RUC_CONVENIO(P_INSTANCIA    IN  NUMBER,
                                        P_RUC_CONVENIO OUT VARCHAR2);
                                        
   /*==================================================================================================================*/
   PROCEDURE SP_CR_OBTENER_DOC_EMPLEADOR(P_INSTANCIA     IN  NUMBER,
                                         P_DOC_EMPLEADOR OUT VARCHAR2);
                                         
   /*==================================================================================================================*/
   PROCEDURE SP_CR_DATOS_CONVENIO(P_INSTANCIA IN  NUMBER,
                                  PC_CONVENIO OUT VARCHAR2);                                                           
END PQ_CR_CONVENIO_CONS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CONVENIO_CONS IS

   PROCEDURE SP_CR_CONDICION_FECHA(PN_NUMINS    IN NUMBER,  
                                   PC_INDICADOR OUT VARCHAR2,                        
                                   PD_FECHA     OUT DATE) IS
                                      
   -- **************************************************************************************
   -- NOMBRE                      : SP_CONDICION_FECHA
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 12/08/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : OBTENER FECHA DE VENCIMIENTO
   -- PARAMETROS                  : - PN_NUMINS    : NUMBER(10)
   --                               - PC_INDICADOR : VARCHAR2(30)
   --                               - PD_FECHA     : DATE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- **************************************************************************************
   
   LN_PAIS   NUMBER;
   LN_TDOC   NUMBER;
   LC_NUMDOC CHAR(12);
   LN_CODCON NUMBER;
   LN_MODULO NUMBER;
   LN_CUENTA NUMBER;
   BEGIN
       
      BEGIN
         SELECT X.XWFMODULO, 
                X.XWFCUENTA
           INTO LN_MODULO, 
                LN_CUENTA
           FROM XWF700 X
          WHERE X.XWFPRCINS = PN_NUMINS
            AND X.XWFCAR3   = '1';
      EXCEPTION
         WHEN OTHERS THEN
            LN_MODULO := NULL;
            LN_CUENTA := NULL;
      END;
     
      -- CONSUMO: 106
      IF LN_MODULO = 106 THEN      
         BEGIN
            SELECT S.SNG001PAIS, 
                   S.SNG001TDOC, 
                   S.SNG001NDOC
              INTO LN_PAIS, 
                   LN_TDOC, 
                   LC_NUMDOC
              FROM SNG001 S
             WHERE S.SNG001INST = PN_NUMINS;
         EXCEPTION
            WHEN OTHERS THEN
               LN_PAIS   := NULL;
               LN_TDOC   := NULL;
               LC_NUMDOC := NULL;
         END;
      
         BEGIN
            SELECT T.JAQA58NOCN, 
                   T.JAQA58FEVE --FECHA DE VENCIMIENTO
              INTO PC_INDICADOR, 
                   PD_FECHA
              FROM JAQA58 T
             WHERE JAQA58PAIS = LN_PAIS
               AND JAQA58TDOC = LN_TDOC
               AND JAQA58NDOC = LC_NUMDOC;
         EXCEPTION
            WHEN OTHERS THEN
               PC_INDICADOR := NULL;
               PD_FECHA     := NULL;
         END;
      END IF; 
      
      -- CONVENIO: 107
      IF LN_MODULO = 107 THEN           
         BEGIN
           PQ_CR_CONVENIOESSALUD.SP_CR_NROCONVENIO(LN_INSTANCIA => PN_NUMINS,
                                                   LN_NROCONV   => LN_CODCON);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
                 
         BEGIN
            SELECT T.JAQA305VA2, 
                   T.JAQA305FVE --FECHA DE VENCIMIENTO
              INTO PC_INDICADOR, 
                   PD_FECHA
              FROM JAQA305 T
             WHERE T.JAQA305CTA = LN_CUENTA
               AND T.JAQA305NCA = LN_CODCON;
         EXCEPTION
            WHEN OTHERS THEN
               PC_INDICADOR := NULL;
               PD_FECHA     := NULL;
         END;
      END IF;
               
      IF PD_FECHA = TO_DATE('01/01/0001','DD/MM/YYYY') THEN
         PD_FECHA := NULL;       
      END IF;    
             
   END SP_CR_CONDICION_FECHA;

   /*==================================================================================================================*/
   PROCEDURE SP_CR_OBTENER_CONVENIO(P_INSTANCIA    IN  NUMBER,
                                    P_NRO_CONVENIO OUT NUMBER,
                                    P_NOM_CONVENIO OUT VARCHAR2) IS
      
   -- **************************************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_CONVENIO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 12/08/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDAR SI EL CLIENTE TIENE CREDITOS VIGENTES/CANCELADOS Y
   --                               QUE EN SU ULTIMO PAGO REALIZADO HAYA SIDO LA 30/120 O 209/65
   --                               PARA PODER OBTENER EL NRO. DE CONVENIO Y LA DESCRIPCION.
   -- PARAMETROS                  : - P_INSTANCIA    : NUMBER(10)
   --                               - P_NRO_CONVENIO : NUMBER(4)
   --                               - P_NOM_CONVENIO : VARCHAR2(50)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- **************************************************************************************
   
      V_FECHASIS DATE           := NULL;
      NRO_CONVENIO NUMBER(4)    := NULL;
      NOM_CONVENIO VARCHAR2(50) := NULL;
      V_MAXFECPAG  DATE         := NULL;
      V_XMAXFECPAG DATE         := TO_DATE('01/01/0001', 'DD/MM/RRRR');
      V_CUENTA     NUMBER(9)    := NULL;
      
      CURSOR C_CUENTAS IS
         SELECT C1.*
           FROM SNG001 A1, FSR008 B1, FSR008 C1
          WHERE A1.SNG001INST = P_INSTANCIA
            AND B1.PGCOD  = 1
            AND B1.CTNRO  = A1.SNG001CTA
            AND C1.PEPAIS = B1.PEPAIS
            AND C1.PETDOC = B1.PETDOC
            AND C1.PENDOC = B1.PENDOC
            AND C1.CTTFIR = 'T';
   BEGIN
      BEGIN 
         SELECT A1.PGFAPE
           INTO V_FECHASIS
           FROM FST017 A1
          WHERE A1.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
      	  NULL;
      END;
      
      FOR J1 IN C_CUENTAS LOOP
         V_MAXFECPAG  := NULL;
         NRO_CONVENIO := NULL;
         NOM_CONVENIO := NULL;
         
         BEGIN
            SELECT NVL(MAX(B1.PPFPAG), TO_DATE('01/01/0001', 'DD/MM/RRRR'))
              INTO V_MAXFECPAG
              FROM FST198 A1, FSD602 B1 
             WHERE A1.TP1COD   = 1
               AND A1.TP1COD1  = 111154
               AND A1.TP1CORR1 = 1
               AND A1.TP1CORR2 = 47
               AND A1.TP1CORR3 > 0
               AND A1.TP1IMP1  = 1
               AND B1.D602CD   = 1
               AND B1.D602MO   = A1.TP1NRO2
               AND B1.D602SU   = 904
               AND B1.D602TR   = A1.TP1NRO3
               AND B1.D602CO   = 'S'
               AND B1.PPCTA    = J1.CTNRO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         IF V_MAXFECPAG > V_XMAXFECPAG THEN
            V_XMAXFECPAG := V_MAXFECPAG;
            V_CUENTA     := J1.CTNRO;
         END IF;
      END LOOP;
      
      BEGIN
         SELECT D1.PP101NCART,
                TRIM(D1.PP101NOMC)
           INTO NRO_CONVENIO,
                NOM_CONVENIO
           FROM FST198 A1, FSD602 B1, FSD016 C1,
                FPP101 D1
          WHERE A1.TP1COD   = 1
            AND A1.TP1COD1  = 111154
            AND A1.TP1CORR1 = 1
            AND A1.TP1CORR2 = 47
            AND A1.TP1CORR3 > 0
            AND A1.TP1IMP1  = 1
            AND B1.D602CD   = 1
            AND B1.D602MO   = A1.TP1NRO2
            AND B1.D602SU   = 904
            AND B1.D602TR   = A1.TP1NRO3
            AND B1.D602CO   = 'S'
            AND B1.PPCTA    = V_CUENTA
            AND B1.PPFPAG   = V_XMAXFECPAG
            AND B1.D602FC   = V_FECHASIS
            AND C1.PGCOD    = 1
            AND C1.ITSUC    = B1.D602SU
            AND C1.ITMOD    = B1.D602MO
            AND C1.ITTRAN   = B1.D602TR
            AND C1.ITNREL   = B1.D602RE
            AND C1.ITORD    = A1.TP1NRO1
            AND D1.PP101NCART = C1.ITOPER;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT D1.PP101NCART,
                      TRIM(D1.PP101NOMC)
                 INTO NRO_CONVENIO,
                      NOM_CONVENIO
                 FROM FST198 A1, FSD602 B1, FSH016 C1,
                      FPP101 D1
                WHERE A1.TP1COD   = 1
                  AND A1.TP1COD1  = 111154
                  AND A1.TP1CORR1 = 1
                  AND A1.TP1CORR2 = 47
                  AND A1.TP1CORR3 > 0
                  AND A1.TP1IMP1  = 1
                  AND B1.D602CD   = 1
                  AND B1.D602MO   = A1.TP1NRO2
                  AND B1.D602SU   = 904
                  AND B1.D602TR   = A1.TP1NRO3
                  AND B1.D602CO   = 'S'
                  AND B1.PPCTA    = V_CUENTA
                  AND B1.PPFPAG   = V_XMAXFECPAG
                  AND C1.PGCOD    = 1
                  AND C1.HCMOD    = B1.D602MO
                  AND C1.HSUCOR   = B1.D602SU
                  AND C1.HTRAN    = B1.D602TR
                  AND C1.HNREL    = B1.D602RE
                  AND C1.HFCON    = B1.D602FC
                  AND C1.HCORD    = A1.TP1NRO1
                  AND D1.PP101NCART = C1.HOPER;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_NRO_CONVENIO := NRO_CONVENIO;
      P_NOM_CONVENIO := NOM_CONVENIO;
      
   END SP_CR_OBTENER_CONVENIO;
   
   /*==================================================================================================================*/
   PROCEDURE SP_CR_OBTENER_FECHA_CUOTA_MAX(P_INSTANCIA       IN  NUMBER,
                                           P_FECHA_MAX_CUOTA OUT DATE) IS
   
   -- **************************************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_FECHA_CUOTA_MAX
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 12/08/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : OBTENER EL DOCUMENTO DEL EMPLEADOR
   -- PARAMETROS                  : - P_INSTANCIA       : NUMBER(10)
   --                               - P_FECHA_MAX_CUOTA : DATE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- **************************************************************************************
                                            
      FECHA_MAX_CUOTA DATE := NULL;
   BEGIN
      BEGIN
         SELECT MAX(B1.PPFPAG)
           INTO FECHA_MAX_CUOTA
           FROM XWF700 A1, FSD601 B1
          WHERE A1.XWFPRCINS = P_INSTANCIA
            AND A1.XWFCAR3   = '1'
            AND B1.PGCOD  = A1.XWFEMPRESA
            AND B1.PPMOD  = A1.XWFMODULO
            AND B1.PPSUC  = A1.XWFSUCURSAL
            AND B1.PPMDA  = A1.XWFMONEDA
            AND B1.PPPAP  = A1.XWFPAPEL
            AND B1.PPCTA  = A1.XWFCUENTA
            AND B1.PPOPER = A1.XWFOPERACION
            AND B1.PPSBOP = A1.XWFSUBOPE
            AND B1.PPTOPE = A1.XWFTIPOPE
            AND B1.D601CO = 'X';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_FECHA_MAX_CUOTA := FECHA_MAX_CUOTA;
      
   END SP_CR_OBTENER_FECHA_CUOTA_MAX;
/*==================================================================================================================*/
   PROCEDURE SP_CR_OBTENER_RUC_CONVENIO(P_INSTANCIA    IN  NUMBER,
                                        P_RUC_CONVENIO OUT VARCHAR2) IS
   
   -- **************************************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_RUC_CONVENIO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 12/08/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : OBTENER EL RUC DEL CONVENIO
   -- PARAMETROS                  : - P_INSTANCIA    : NUMBER(10)
   --                               - P_RUC_CONVENIO : VARCHAR2(12)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- **************************************************************************************
      
      NRO_CONVENIO NUMBER(4);                               
      RUC_CONVENIO VARCHAR2(50);
   BEGIN
      BEGIN
         PQ_CR_CONVENIOESSALUD.SP_CR_NROCONVENIO(LN_INSTANCIA => P_INSTANCIA, 
                                                 LN_NROCONV   => NRO_CONVENIO);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      RUC_CONVENIO := NULL;
      BEGIN
         SELECT TRIM(B1.PENDOC)
           INTO RUC_CONVENIO
           FROM FPP101 A1, FSR008 B1
          WHERE A1.PP101NCART = NRO_CONVENIO
            AND B1.PGCOD      = 1
            AND B1.CTNRO      = A1.PP101AUX1
            AND B1.CTTFIR     = 'T';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_RUC_CONVENIO := RUC_CONVENIO;
      
   END SP_CR_OBTENER_RUC_CONVENIO;
   
   /*==================================================================================================================*/
   PROCEDURE SP_CR_OBTENER_DOC_EMPLEADOR(P_INSTANCIA     IN  NUMBER,
                                         P_DOC_EMPLEADOR OUT VARCHAR2) IS
      
   -- **************************************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_DOC_EMPLEADOR
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 12/08/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : OBTENER EL DOCUMENTO DEL EMPLEADOR
   -- PARAMETROS                  : - P_INSTANCIA     : NUMBER(10)
   --                               - P_DOC_EMPLEADOR : VARCHAR2(4)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 18/10/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE AGREGO LA CONDICION DE SNGC60CORR = 0 DE LA TABLA SNGC60
   --
   -- **************************************************************************************
                                         
      DOC_EMPLEADOR VARCHAR2(12) := NULL;
   BEGIN      
      BEGIN
         SELECT TRIM(C1.SNGC60RUTE)
           INTO DOC_EMPLEADOR
           FROM SNG001 A1, FSD008 B1, SNGC60 C1
          WHERE A1.SNG001INST = P_INSTANCIA
            AND B1.PGCOD  = 1
            AND B1.CTNRO  = A1.SNG001CTA
            AND B1.CTSEGM = 2
            AND C1.SNGC60PAIS = A1.SNG001PAIS
            AND C1.SNGC60TDOC = A1.SNG001TDOC
            AND C1.SNGC60NDOC = A1.SNG001NDOC
            AND C1.SNGC60CORR = 0;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_DOC_EMPLEADOR := DOC_EMPLEADOR;
      
   END SP_CR_OBTENER_DOC_EMPLEADOR;

   /*==================================================================================================================*/
   PROCEDURE SP_CR_DATOS_CONVENIO(P_INSTANCIA IN  NUMBER,
                                  PC_CONVENIO OUT VARCHAR2) IS
   
   -- **************************************************************************************
   -- NOMBRE                      : SP_CR_DATOS_CONVENIO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 23/09/2024
   -- AUTOR DE CREACION           : DCASTRO
   -- USO                         : RETORNA CODIGO Y NOMBRE DEL CONVENIO
   -- PARAMETROS                  : - P_INSTANCIA : NUMBER(10)
   --                               - PC_CONVENIO : VARCHAR2(30)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- **************************************************************************************
      
      NRO_CONVENIO NUMBER(4)    := NULL;                               
      RUC_CONVENIO VARCHAR2(50) := NULL;
   BEGIN
      BEGIN
         PQ_CR_CONVENIOESSALUD.SP_CR_NROCONVENIO(LN_INSTANCIA => P_INSTANCIA, 
                                                 LN_NROCONV   => NRO_CONVENIO);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;

      IF NRO_CONVENIO IS NOT NULL THEN
        BEGIN
          SELECT F.PP101NOMC
            INTO PC_CONVENIO
            FROM FPP101 F
           WHERE F.PP101NCART = NRO_CONVENIO;
          EXCEPTION WHEN OTHERS THEN
            PC_CONVENIO := NULL;
        END;  
      END IF;
 
      PC_CONVENIO := SUBSTR(TRIM(NRO_CONVENIO) ||'-'||PC_CONVENIO, 1,30);
      
  END SP_CR_DATOS_CONVENIO;

END PQ_CR_CONVENIO_CONS;
/

