CREATE OR REPLACE PACKAGE PQ_CR_FORMULARIO_SEGMENTO IS

   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_FORMULARIO_SEGMENTO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 05/07/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 09/01/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE MODIFICO EL PROCESO SP_CR_ENVIAR_CORREO
   -- *****************************************************************
   -- FECHA DE MODIFICACION       : 26/02/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE MODIFICO EL PROCESO SP_CR_ENVIAR_CORREO
   -- *****************************************************************

   PROCEDURE SP_CR_MOSTRAR_ULTIMO_REG(pINST        IN NUMBER,
                                      pFECP        OUT DATE,
                                      pHORP        OUT VARCHAR2,
                                      pUSUP        OUT VARCHAR2,
                                      pCODRE       OUT NUMBER,
                                      pRESU        OUT VARCHAR2,
                                      pCODSL       OUT NUMBER,
                                      pSOLI        OUT VARCHAR2,
                                      pCODOP       OUT NUMBER,
                                      pOPCN        OUT VARCHAR2,
                                      pCODDE       OUT NUMBER,
                                      pDEUD        OUT VARCHAR2,
                                      pGLOS        OUT VARCHAR2,
                                      pCODC1       OUT NUMBER,
                                      pCOND1       OUT VARCHAR2,
                                      pCODC2       OUT NUMBER,
                                      pCOND2       OUT VARCHAR2,
                                      P_COMENTARIO OUT VARCHAR2);

   PROCEDURE SP_CR_GRABAR_FORMULARIO(pINST        IN  NUMBER,
                                     pCTA         IN  NUMBER,
                                     pFCHP        IN  DATE,
                                     pHORP        IN  VARCHAR2,
                                     pUSRP        IN  VARCHAR2,
                                     pCODRE       IN  NUMBER,
                                     pRESU        IN  VARCHAR2,
                                     pCODSL       IN  NUMBER,
                                     pSOLI        IN  VARCHAR2,
                                     pCODOP       IN  NUMBER,
                                     pOPCN        IN  VARCHAR2,
                                     pCODDE       IN  NUMBER,
                                     pDEUD        IN  VARCHAR2,
                                     pGLOS        IN  VARCHAR2,
                                     pCODC1       IN  NUMBER,
                                     pCOND1       IN  VARCHAR2,
                                     pCODC2       IN  NUMBER,
                                     pCOND2       IN  VARCHAR2,
                                     pMTO         IN  NUMBER,
                                     P_COMENTARIO IN VARCHAR2,
                                     pGUARDO      OUT VARCHAR2);

   PROCEDURE SP_CR_ACTIVAR_BTN_CONFI(pINST   IN  NUMBER,
                                     pCONF   OUT VARCHAR2,
                                     pESTADO OUT VARCHAR2,
                                     pCODRES OUT NUMBER);

   PROCEDURE SP_CR_ACTUALIZAR_FORMULARIO(pINST      IN  NUMBER,
                                         pMOD       IN  NUMBER,
                                         pCORR      IN  NUMBER,
                                         pUSUP      IN  VARCHAR2,
                                         pACTUALIZO OUT VARCHAR2);

   PROCEDURE SP_CR_ENVIAR_CORREO(pINST         IN  NUMBER,
                                 pMDA          IN  NUMBER,
                                 pCORR         IN  NUMBER,
                                 pSEGA         IN  VARCHAR2,
                                 pSEGN         IN  VARCHAR2,
                                 P_ERROR_ENVIO OUT VARCHAR2);

   PROCEDURE SP_CR_ACTIVAR_CONTROL_DUPLICIDAD(pFHOY       IN  DATE,
                                              pINST       IN  NUMBER,
                                              pFCHULTREG  OUT DATE,
                                              pDUPLICIDAD OUT VARCHAR2);

END PQ_CR_FORMULARIO_SEGMENTO;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_FORMULARIO_SEGMENTO IS

   PROCEDURE SP_CR_MOSTRAR_ULTIMO_REG(pINST        IN NUMBER,
                                      pFECP        OUT DATE,
                                      pHORP        OUT VARCHAR2,
                                      pUSUP        OUT VARCHAR2,
                                      pCODRE       OUT NUMBER,
                                      pRESU        OUT VARCHAR2,
                                      pCODSL       OUT NUMBER,
                                      pSOLI        OUT VARCHAR2,
                                      pCODOP       OUT NUMBER,
                                      pOPCN        OUT VARCHAR2,
                                      pCODDE       OUT NUMBER,
                                      pDEUD        OUT VARCHAR2,
                                      pGLOS        OUT VARCHAR2,
                                      pCODC1       OUT NUMBER,
                                      pCOND1       OUT VARCHAR2,
                                      pCODC2       OUT NUMBER,
                                      pCOND2       OUT VARCHAR2,
                                      P_COMENTARIO OUT VARCHAR2) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_MOSTRAR_ULTIMO_REG
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/07/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : MOSTRAR EL ULTIMO REGISTRO QUE SE HA
      --                               GUARDADO EN EL FORMULARIO
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
   BEGIN
      BEGIN
         SELECT AQPB947FECP1,
                AQPB947HORP1,
                AQPB947USRP,
                AQPB947CODRE,
                AQPB947RESUL,
                AQPB947CODSL,
                AQPB947SOLIC,
                AQPB947CODOP,
                AQPB947OPCIO,
                AQPB947CODDE,
                AQPB947DEUDA,
                AQPB947GLOSA,
                AQPB947CODC1,
                AQPB947COND1,
                AQPB947CODC2,
                AQPB947COND2,
                AQPB947COMMT
           INTO pFECP,
                pHORP,
                pUSUP,
                pCODRE,
                pRESU,
                pCODSL,
                pSOLI,
                pCODOP,
                pOPCN,
                pCODDE,
                pDEUD,
                pGLOS,
                pCODC1,
                pCOND1,
                pCODC2,
                pCOND2,
                P_COMENTARIO
           FROM AQPB947
          WHERE AQPB947INST1 = pINST
            AND AQPB947FECP1 = (SELECT MAX(AQPB947FECP1)
                                  FROM AQPB947
                                 WHERE AQPB947INST1 = pINST)
            AND AQPB947HORP1 =
                (SELECT MAX(AQPB947HORP1)
                   FROM AQPB947
                  WHERE AQPB947INST1 = pINST
                    AND AQPB947FECP1 =
                        (SELECT MAX(AQPB947FECP1)
                           FROM AQPB947
                          WHERE AQPB947INST1 = pINST));
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_MOSTRAR_ULTIMO_REG;

   PROCEDURE SP_CR_GRABAR_FORMULARIO(pINST        IN NUMBER,
                                     pCTA         IN NUMBER,
                                     pFCHP        IN DATE,
                                     pHORP        IN VARCHAR2,
                                     pUSRP        IN VARCHAR2,
                                     pCODRE       IN NUMBER,
                                     pRESU        IN VARCHAR2,
                                     pCODSL       IN NUMBER,
                                     pSOLI        IN VARCHAR2,
                                     pCODOP       IN NUMBER,
                                     pOPCN        IN VARCHAR2,
                                     pCODDE       IN NUMBER,
                                     pDEUD        IN VARCHAR2,
                                     pGLOS        IN VARCHAR2,
                                     pCODC1       IN NUMBER,
                                     pCOND1       IN VARCHAR2,
                                     pCODC2       IN NUMBER,
                                     pCOND2       IN VARCHAR2,
                                     pMTO         IN NUMBER,
                                     P_COMENTARIO IN VARCHAR2,
                                     pGUARDO      OUT VARCHAR2) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_GRABAR_FORMULARIO
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/07/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : GRABAR LO QUE SE HA INGRESADO EN EL PANEL
      --                               DEL FORMULARIO 
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
      V_PAIS     NUMBER(3);
      V_TDOC     NUMBER(2);
      V_NDOC     VARCHAR2(12);
      V_CORR     NUMBER(10);
      V_EST_CONF VARCHAR2(2);
      V_NRO_EXCP NUMBER(10);
      V_ASESOR   VARCHAR2(10);
      V_CARGO    NUMBER(3);
   BEGIN
      BEGIN
         SELECT PEPAIS, PETDOC, PENDOC
           INTO V_PAIS, V_TDOC, V_NDOC
           FROM FSR008
          WHERE PGCOD = 1
            AND CTNRO = pCTA
            AND CTTFIR = 'T';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT NVL(MAX(AQPB947CORR1), 0)
           INTO V_CORR
           FROM AQPB947
          WHERE AQPB947FECP1 = pFCHP;
         V_CORR := V_CORR + 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_CORR := 1;
         WHEN OTHERS THEN
            NULL;
      END;
      CASE
         WHEN pCODRE = 1 THEN
            V_EST_CONF := 'C';
            V_NRO_EXCP := 0;
         WHEN pCODRE = 2 THEN
            V_EST_CONF := 'CA';
            V_NRO_EXCP := 0;
         WHEN pCODRE = 3 THEN
            V_EST_CONF := 'NC';
            V_NRO_EXCP := 0;
         WHEN pCODRE = 4 THEN
            V_EST_CONF := 'EG';
            V_NRO_EXCP := 1;
         ELSE
            NULL;
      END CASE;
      BEGIN
         SELECT TRIM(SNG001ASE)
           INTO V_ASESOR
           FROM SNG001
          WHERE SNG001INST = pINST;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT SNG055CAR
           INTO V_CARGO
           FROM SNG057
          WHERE SNG055EMP = 1
            AND SNG057USR = RPAD(pUSRP, 10, ' ');
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         INSERT INTO AQPB947
            (AQPB947CORR1,
             AQPB947FECP1,
             AQPB947HORP1,
             AQPB947INST1,
             AQPB947PAIS,
             AQPB947TDOC,
             AQPB947NDOC,
             AQPB947CTA,
             AQPB947USRP,
             AQPB947ESTA,
             AQPB947CODRE,
             AQPB947RESUL,
             AQPB947CODSL,
             AQPB947SOLIC,
             AQPB947CODOP,
             AQPB947OPCIO,
             AQPB947CODDE,
             AQPB947DEUDA,
             AQPB947GLOSA,
             AQPB947CODC1,
             AQPB947COND1,
             AQPB947CODC2,
             AQPB947COND2,
             AQPB947MONTO,
             AQPB947ESTCF,
             AQPB947FCONF,
             AQPB947USRCF,
             AQPB947ASESO,
             AQPB947CARGO,
             AQPB947NEXCP,
             AQPB947COMMT)
         VALUES
            (V_CORR,
             pFCHP,
             pHORP,
             pINST,
             V_PAIS,
             V_TDOC,
             V_NDOC,
             pCTA,
             pUSRP,
             'P',
             pCODRE,
             pRESU,
             pCODSL,
             pSOLI,
             pCODOP,
             pOPCN,
             pCODDE,
             pDEUD,
             pGLOS,
             pCODC1,
             pCOND1,
             pCODC2,
             pCOND2,
             pMTO,
             V_EST_CONF,
             pFCHP,
             pUSRP,
             V_ASESOR,
             V_CARGO,
             V_NRO_EXCP,
             P_COMENTARIO);
         COMMIT;
         pGUARDO := 'S';
      EXCEPTION
         WHEN OTHERS THEN
            pGUARDO := 'N';
      END;
   END SP_CR_GRABAR_FORMULARIO;

   PROCEDURE SP_CR_ACTIVAR_BTN_CONFI(pINST   IN NUMBER,
                                     pCONF   OUT VARCHAR2,
                                     pESTADO OUT VARCHAR2,
                                     pCODRES OUT NUMBER) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_ACTIVAR_BTN_CONFI
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/07/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : RETORNA 3 RESULTADOS, OBTENIENDO EL ULTIMO
      --                               REGISTRO GUARDADO DESDE EL FORMULARO PARA VALIDAR
      --                               DESDE EL PANEL
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
   BEGIN
      BEGIN
         SELECT 'S', AQPB947ESTA, AQPB947CODRE
           INTO pCONF, pESTADO, pCODRES
           FROM AQPB947
          WHERE AQPB947INST1 = pINST
            AND AQPB947FECP1 = (SELECT MAX(AQPB947FECP1)
                                  FROM AQPB947
                                 WHERE AQPB947INST1 = pINST)
            AND AQPB947HORP1 =
                (SELECT MAX(AQPB947HORP1)
                   FROM AQPB947
                  WHERE AQPB947INST1 = pINST
                    AND AQPB947FECP1 =
                        (SELECT MAX(AQPB947FECP1)
                           FROM AQPB947
                          WHERE AQPB947INST1 = pINST));
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_ACTIVAR_BTN_CONFI;

   PROCEDURE SP_CR_ACTUALIZAR_FORMULARIO(pINST      IN NUMBER,
                                         pMOD       IN NUMBER,
                                         pCORR      IN NUMBER,
                                         pUSUP      IN VARCHAR2,
                                         pACTUALIZO OUT VARCHAR2) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_ACTUALIZAR_FORMULARIO
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/07/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : ACTUALIZA EL ULTIMO REGISTRO GUARDADO, EN EL MOMENTO
      --                               QUE EL USUARIO CONFIRME EL CAMBIO DE LA NUEVA SEGMENTACION
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
      V_FECHA      DATE;
      V_HORA       VARCHAR2(8);
      V_INST       NUMBER(10);
      V_PGFAPE     DATE;
      V_ITEM       NUMBER(9);
      V_CORR_CONCP NUMBER(9);
      V_OUT_SEGA   NUMBER(1);
   
      V_PAIS NUMBER(3);
      V_TDOC NUMBER(2);
      V_NDOC VARCHAR2(12);
   
      V_C_NULL VARCHAR2(1) := NULL;
      V_N_NULL NUMBER(5) := NULL;
   
      V_OUT_MAY_SAL            NUMBER(17, 2);
      V_MAY_SAL                VARCHAR(100);
      V_OUT_DIA_ATRASO_E       NUMBER(17, 2);
      V_DIA_ATRASO_E           VARCHAR(100);
      V_OUT_SEG_ORI            VARCHAR2(30);
      V_SEG_ORI                VARCHAR2(100);
      V_OUT_FECH_SOLIC_NO_CONF VARCHAR2(10);
      V_FECH_SOLIC_NO_CONF     VARCHAR2(100);
      V_OUT_NUM_EXC_GC         NUMBER(10);
      V_NUM_EXC_GC             VARCHAR2(100);
      V_OUT_SOBRE_ENDEUDADO    VARCHAR2(2);
      V_SOBRE_ENDEUDADO        VARCHAR2(100);
      V_OUT_LISTA_NEGRA        VARCHAR2(2);
      V_LISTA_NEGRA            VARCHAR2(100);
      V_OUT_INST_CAMP          VARCHAR2(2);
      V_INST_CAMP              VARCHAR2(100);
      V_OUT_NUM_CAM_SEG        NUMBER(10);
      V_OUT_FECH_CAM           DATE;
      V_OUT_NUM_INST_CAM       NUMBER(10);
      V_OUT_ULT_SEG            VARCHAR2(50);
      V_OUT_CRED_VIG_ATR       VARCHAR2(2);
   
      V_NUM_CAM_SEG  VARCHAR2(100);
      V_FECH_CAM     VARCHAR2(100);
      V_NUM_INST_CAM VARCHAR2(100);
      V_ULT_SEG      VARCHAR2(100);
      V_CRED_VIG_ATR VARCHAR2(100);
   
      V_NOM_VAR    VARCHAR2(30);
      V_OUT_VAL    VARCHAR2(40);
      V_CONCEPTO1  VARCHAR2(100);
      V_CONCEPTO2  VARCHAR2(100);
      V_CONCEPTO3  VARCHAR2(100);
      V_CONCEPTO4  VARCHAR2(100);
      V_CONCEPTO5  VARCHAR2(100);
      V_CONCEPTO6  VARCHAR2(100);
      V_CONCEPTO7  VARCHAR2(100);
      V_CONCEPTO8  VARCHAR2(100);
      V_CONCEPTO9  VARCHAR2(100);
      V_CONCEPTO10 VARCHAR2(100);
      V_CONCEPTO11 VARCHAR2(100);
      V_CONCEPTO12 VARCHAR2(100);
      V_CONCEPTO13 VARCHAR2(100);
      V_CONCEPTO14 VARCHAR2(100);
      V_CONCEPTO15 VARCHAR2(100);
      V_CONCEPTO16 VARCHAR2(100);
      V_CONCEPTO17 VARCHAR2(100);
      V_CONCEPTO18 VARCHAR2(100);
      V_CONCEPTO19 VARCHAR2(100);
      V_CONCEPTO20 VARCHAR2(100);
   
      CURSOR C1 IS
         SELECT RNG68COD FROM FRNG41 WHERE RNG49COD = 1623;
      CURSOR C2 IS
         SELECT A.TP1NRO1, B.RNG68COD
           FROM FST198 A, FRNG41 B
          WHERE A.TP1COD = 1
            AND A.TP1COD1 = 11115
            AND A.TP1CORR1 = 200
            AND A.TP1NRO1 IN (1626, 1627)
            AND A.TP1NRO1 = B.RNG49COD;
      CURSOR C3 IS
         SELECT A.TP1NRO1, B.RNG68COD
           FROM FST198 A, FRNG41 B
          WHERE A.TP1COD = 1
            AND A.TP1COD1 = 11115
            AND A.TP1CORR1 = 500
            AND A.TP1NRO1 = B.RNG49COD;
      CURSOR AUX_C1(NRO1 NUMBER, NRO2 NUMBER) IS
         SELECT TP1NRO1, TP1NRO3, TP1DESC
           FROM FST198
          WHERE TP1COD = 1
            AND TP1COD1 = 11115
            AND TP1CORR1 = 100
            AND TP1NRO1 = NRO1
            AND TP1NRO2 = NRO2;
   BEGIN
      BEGIN
         SELECT JAQZ870FECP, JAQZ870HORP, JAQZ870INST
           INTO V_FECHA, V_HORA, V_INST
           FROM JAQZ870
          WHERE JAQZ870CORR = pCORR
            AND JAQZ870INST = pINST;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT PGFAPE INTO V_PGFAPE FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC
           INTO V_PAIS, V_TDOC, V_NDOC
           FROM SNG001
          WHERE SNG001INST = pINST;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         V_MAY_SAL     := NULL;
         V_OUT_MAY_SAL := 0;
         PQ_CR_CAMBIO_SEGMENTO.SP_SALDOCON_MN_HIST(V_PGFAPE,
                                                   V_PAIS,
                                                   V_TDOC,
                                                   V_NDOC,
                                                   V_OUT_MAY_SAL);
         V_MAY_SAL := TRIM(TO_CHAR(V_OUT_MAY_SAL));
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         V_DIA_ATRASO_E     := NULL;
         V_OUT_DIA_ATRASO_E := 0;
         PQ_CR_CAMBIO_SEGMENTO.SP_DIAATRASO_LINEA(V_PAIS,
                                                  V_TDOC,
                                                  V_NDOC,
                                                  V_PGFAPE,
                                                  V_OUT_DIA_ATRASO_E);
         V_DIA_ATRASO_E := TRIM(TO_CHAR(V_OUT_DIA_ATRASO_E));
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         V_FECH_SOLIC_NO_CONF     := NULL;
         V_OUT_FECH_SOLIC_NO_CONF := NULL;
         V_OUT_NUM_EXC_GC         := 0;
         V_NUM_EXC_GC             := NULL;
         PQ_CR_DATOS_PANEL_SEGM.SP_CR_BUSQUEDA_DATOS_CONFORMIDAD(pINST,
                                                                 V_OUT_FECH_SOLIC_NO_CONF,
                                                                 V_C_NULL,
                                                                 V_C_NULL,
                                                                 V_C_NULL,
                                                                 V_OUT_NUM_EXC_GC);
         V_FECH_SOLIC_NO_CONF := TRIM(V_OUT_FECH_SOLIC_NO_CONF);
         V_NUM_EXC_GC         := TRIM(TO_CHAR(V_OUT_NUM_EXC_GC));
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         V_OUT_SOBRE_ENDEUDADO := NULL;
         V_OUT_LISTA_NEGRA     := NULL;
         V_OUT_INST_CAMP       := NULL;
      
         PQ_CR_DATOS_PANEL_SEGM.SP_CR_OBTIENE_SEGMENTACION(pINST,
                                                           V_PAIS,
                                                           V_TDOC,
                                                           V_NDOC,
                                                           V_OUT_SOBRE_ENDEUDADO,
                                                           V_OUT_LISTA_NEGRA,
                                                           V_OUT_INST_CAMP);
         V_SOBRE_ENDEUDADO := TRIM(V_OUT_SOBRE_ENDEUDADO);
         V_LISTA_NEGRA     := TRIM(V_OUT_LISTA_NEGRA);
         V_INST_CAMP       := TRIM(V_OUT_INST_CAMP);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         V_OUT_NUM_CAM_SEG  := 0;
         V_OUT_FECH_CAM     := NULL;
         V_OUT_NUM_INST_CAM := 0;
         V_OUT_ULT_SEG      := NULL;
         V_OUT_CRED_VIG_ATR := NULL;
      
         V_NUM_CAM_SEG  := NULL;
         V_FECH_CAM     := NULL;
         V_NUM_INST_CAM := NULL;
         V_ULT_SEG      := NULL;
         V_CRED_VIG_ATR := NULL;
      
         PQ_CR_DATOS_PANEL_SEGM.SP_VARIABLES_SEGMENTACION(pINST,
                                                          V_OUT_NUM_CAM_SEG,
                                                          V_OUT_FECH_CAM,
                                                          V_OUT_NUM_INST_CAM,
                                                          V_OUT_ULT_SEG,
                                                          V_OUT_CRED_VIG_ATR);
      
         V_NUM_CAM_SEG  := TRIM(TO_CHAR(V_OUT_NUM_CAM_SEG));
         V_FECH_CAM     := TRIM(TO_CHAR(V_OUT_FECH_CAM, 'DD/MM/RRRR'));
         V_NUM_INST_CAM := TRIM(TO_CHAR(V_OUT_NUM_INST_CAM));
         V_ULT_SEG      := TRIM(V_OUT_ULT_SEG);
         V_CRED_VIG_ATR := TRIM(V_OUT_CRED_VIG_ATR);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      V_OUT_SEGA := 0;
      PQ_CR_VERIFICASEGMENTO.SP_CR_SEGMNTOACTUAL(pINST, V_OUT_SEGA);
      IF V_OUT_SEGA = 1 THEN
         IF pMOD = 103 THEN
            FOR X IN C1 LOOP
               BEGIN
                  SELECT TP1NRO3, TRIM(TP1DESC)
                    INTO V_ITEM, V_NOM_VAR
                    FROM FST198
                   WHERE TP1COD = 1
                     AND TP1COD1 = 11115
                     AND TP1CORR1 = 100
                     AND TP1NRO1 = 1623
                     AND TP1NRO2 = X.RNG68COD;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     V_ITEM := NULL;
                  WHEN OTHERS THEN
                     NULL;
               END;
               IF V_ITEM IS NOT NULL THEN
                  V_OUT_VAL := NULL;
                  PQ_CR_SEG_EXCEP.SP_CR_VARIABLES_PAE(pINST,
                                                      V_ITEM,
                                                      V_OUT_VAL);
                  BEGIN
                     SELECT TP1CORR3
                       INTO V_CORR_CONCP
                       FROM FST198
                      WHERE TP1COD = 1
                        AND TP1COD1 = 111154
                        AND TP1CORR1 = 14
                        AND TP1NRO1 = 1623
                        AND TP1DESC = RPAD(V_NOM_VAR, 30, ' ');
                  EXCEPTION
                     WHEN OTHERS THEN
                        NULL;
                  END;
                  CASE
                     WHEN V_CORR_CONCP = 41 THEN
                        V_CONCEPTO1 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 42 THEN
                        V_CONCEPTO2 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 43 THEN
                        V_CONCEPTO3 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 44 THEN
                        V_CONCEPTO4 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 45 THEN
                        V_CONCEPTO5 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 46 THEN
                        V_CONCEPTO6 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 47 THEN
                        V_CONCEPTO7 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 48 THEN
                        V_CONCEPTO8 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 49 THEN
                        V_CONCEPTO9 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 50 THEN
                        V_CONCEPTO10 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 51 THEN
                        V_CONCEPTO11 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 52 THEN
                        V_CONCEPTO12 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 53 THEN
                        V_CONCEPTO13 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 54 THEN
                        V_CONCEPTO14 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 55 THEN
                        V_CONCEPTO15 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 56 THEN
                        V_CONCEPTO16 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 57 THEN
                        V_CONCEPTO17 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 58 THEN
                        V_CONCEPTO18 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 59 THEN
                        V_CONCEPTO19 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 60 THEN
                        V_CONCEPTO20 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     ELSE
                        NULL;
                  END CASE;
               END IF;
            END LOOP;
            BEGIN
               V_SEG_ORI     := NULL;
               V_OUT_SEG_ORI := NULL;
               PQ_CR_SEGMENTACION_MICRO_LINEA.sp_cr_NS_LINEA(V_PGFAPE,
                                                             V_PAIS,
                                                             V_TDOC,
                                                             V_NDOC,
                                                             pUSUP,
                                                             V_C_NULL,
                                                             V_OUT_SEG_ORI);
               V_SEG_ORI := TRIM(V_OUT_SEG_ORI);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            BEGIN
               UPDATE AQPB947
                  SET AQPB947ESTA  = 'H',
                      AQPB947CORR2 = pCORR,
                      AQPB947INST2 = V_INST,
                      AQPB947FECP2 = V_FECHA,
                      AQPB947HORP2 = V_HORA,
                      AQPB947VAR41 = V_CONCEPTO1,
                      AQPB947VAR42 = V_CONCEPTO2,
                      AQPB947VAR43 = V_CONCEPTO3,
                      AQPB947VAR44 = V_CONCEPTO4,
                      AQPB947VAR45 = V_CONCEPTO5,
                      AQPB947VAR46 = V_CONCEPTO6,
                      AQPB947VAR47 = V_CONCEPTO7,
                      AQPB947VAR48 = V_CONCEPTO8,
                      AQPB947VAR49 = V_CONCEPTO9,
                      AQPB947VAR50 = V_CONCEPTO10,
                      AQPB947VAR51 = V_CONCEPTO11,
                      AQPB947VAR52 = V_CONCEPTO12,
                      AQPB947VAR53 = V_CONCEPTO13,
                      AQPB947VAR54 = V_CONCEPTO14,
                      AQPB947VAR55 = V_CONCEPTO15,
                      AQPB947VAR56 = V_CONCEPTO16,
                      AQPB947VAR57 = V_CONCEPTO17,
                      AQPB947VAR58 = V_CONCEPTO18,
                      AQPB947VAR59 = V_CONCEPTO19,
                      AQPB947VAR60 = V_CONCEPTO20,
                      AQPB947MYSAL = V_MAY_SAL,
                      AQPB947DATRE = V_DIA_ATRASO_E,
                      AQPB947NCAMS = V_NUM_CAM_SEG,
                      AQPB947FHCAM = V_FECH_CAM,
                      AQPB947NINSC = V_NUM_INST_CAM,
                      AQPB947SEGOR = V_SEG_ORI,
                      AQPB947FSLNC = V_FECH_SOLIC_NO_CONF,
                      AQPB947NEXGC = V_NUM_EXC_GC,
                      AQPB947ULSEG = V_ULT_SEG,
                      AQPB947SBRED = V_SOBRE_ENDEUDADO,
                      AQPB947LSTNG = V_LISTA_NEGRA,
                      AQPB947INSCP = V_INST_CAMP,
                      AQPB947CVIGA = V_CRED_VIG_ATR,
                      AQPB947VAUX1 = 'MICRO'
                WHERE AQPB947INST1 = pINST
                  AND AQPB947FECP1 =
                      (SELECT MAX(AQPB947FECP1)
                         FROM AQPB947
                        WHERE AQPB947INST1 = pINST)
                  AND AQPB947HORP1 =
                      (SELECT MAX(AQPB947HORP1)
                         FROM AQPB947
                        WHERE AQPB947INST1 = pINST
                          AND AQPB947FECP1 =
                              (SELECT MAX(AQPB947FECP1)
                                 FROM AQPB947
                                WHERE AQPB947INST1 = pINST));
               COMMIT;
               pACTUALIZO := 'S';
            EXCEPTION
               WHEN OTHERS THEN
                  pACTUALIZO := 'N';
            END;
         ELSE
            FOR X IN C2 LOOP
               BEGIN
                  SELECT TP1NRO3, TRIM(TP1DESC)
                    INTO V_ITEM, V_NOM_VAR
                    FROM FST198
                   WHERE TP1COD = 1
                     AND TP1COD1 = 11115
                     AND TP1CORR1 = 100
                     AND TP1NRO1 = X.TP1NRO1
                     AND TP1NRO2 = X.RNG68COD;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     V_ITEM := NULL;
                  WHEN OTHERS THEN
                     NULL;
               END;
               IF V_ITEM IS NOT NULL THEN
                  V_OUT_VAL := NULL;
                  PQ_CR_SEG_EXCEP.SP_CR_VARIABLES_PAE(pINST,
                                                      V_ITEM,
                                                      V_OUT_VAL);
                  BEGIN
                     SELECT TP1CORR3
                       INTO V_CORR_CONCP
                       FROM FST198
                      WHERE TP1COD = 1
                        AND TP1COD1 = 111154
                        AND TP1CORR1 = 14
                        AND TP1NRO1 = X.TP1NRO1
                        AND TP1DESC = RPAD(V_NOM_VAR, 30, ' ');
                  EXCEPTION
                     WHEN OTHERS THEN
                        NULL;
                  END;
                  CASE
                     WHEN V_CORR_CONCP = 1 THEN
                        V_CONCEPTO1 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 2 THEN
                        V_CONCEPTO2 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 3 THEN
                        V_CONCEPTO3 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 4 THEN
                        V_CONCEPTO4 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 5 THEN
                        V_CONCEPTO5 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 6 THEN
                        V_CONCEPTO6 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 7 THEN
                        V_CONCEPTO7 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 8 THEN
                        V_CONCEPTO8 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 9 THEN
                        V_CONCEPTO9 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 10 THEN
                        V_CONCEPTO10 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 11 THEN
                        V_CONCEPTO11 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 12 THEN
                        V_CONCEPTO12 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 13 THEN
                        V_CONCEPTO13 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 14 THEN
                        V_CONCEPTO14 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 15 THEN
                        V_CONCEPTO15 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 16 THEN
                        V_CONCEPTO16 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 17 THEN
                        V_CONCEPTO17 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 18 THEN
                        V_CONCEPTO18 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 19 THEN
                        V_CONCEPTO19 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     WHEN V_CORR_CONCP = 20 THEN
                        V_CONCEPTO20 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                     ELSE
                        NULL;
                  END CASE;
               END IF;
            END LOOP;
            BEGIN
               V_SEG_ORI     := NULL;
               V_OUT_SEG_ORI := NULL;
               PQ_CR_NUEVA_SEGMENTACION_MYPE22.SP_CR_NS_LINEA(V_PGFAPE,
                                                              V_PAIS,
                                                              V_TDOC,
                                                              V_NDOC,
                                                              pUSUP,
                                                              V_N_NULL,
                                                              V_OUT_SEG_ORI);
               V_SEG_ORI := TRIM(V_OUT_SEG_ORI);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            BEGIN
               UPDATE AQPB947
                  SET AQPB947ESTA  = 'H',
                      AQPB947CORR2 = pCORR,
                      AQPB947INST2 = V_INST,
                      AQPB947FECP2 = V_FECHA,
                      AQPB947HORP2 = V_HORA,
                      AQPB947VAR1  = V_CONCEPTO1,
                      AQPB947VAR2  = V_CONCEPTO2,
                      AQPB947VAR3  = V_CONCEPTO3,
                      AQPB947VAR4  = V_CONCEPTO4,
                      AQPB947VAR5  = V_CONCEPTO5,
                      AQPB947VAR6  = V_CONCEPTO6,
                      AQPB947VAR7  = V_CONCEPTO7,
                      AQPB947VAR8  = V_CONCEPTO8,
                      AQPB947VAR9  = V_CONCEPTO9,
                      AQPB947VAR10 = V_CONCEPTO10,
                      AQPB947VAR11 = V_CONCEPTO11,
                      AQPB947VAR12 = V_CONCEPTO12,
                      AQPB947VAR13 = V_CONCEPTO13,
                      AQPB947VAR14 = V_CONCEPTO14,
                      AQPB947VAR15 = V_CONCEPTO15,
                      AQPB947VAR16 = V_CONCEPTO16,
                      AQPB947VAR17 = V_CONCEPTO17,
                      AQPB947VAR18 = V_CONCEPTO18,
                      AQPB947VAR19 = V_CONCEPTO19,
                      AQPB947VAR20 = V_CONCEPTO20,
                      AQPB947MYSAL = V_MAY_SAL,
                      AQPB947DATRE = V_DIA_ATRASO_E,
                      AQPB947NCAMS = V_NUM_CAM_SEG,
                      AQPB947FHCAM = V_FECH_CAM,
                      AQPB947NINSC = V_NUM_INST_CAM,
                      AQPB947SEGOR = V_SEG_ORI,
                      AQPB947FSLNC = V_FECH_SOLIC_NO_CONF,
                      AQPB947NEXGC = V_NUM_EXC_GC,
                      AQPB947ULSEG = V_ULT_SEG,
                      AQPB947SBRED = V_SOBRE_ENDEUDADO,
                      AQPB947LSTNG = V_LISTA_NEGRA,
                      AQPB947INSCP = V_INST_CAMP,
                      AQPB947CVIGA = V_CRED_VIG_ATR,
                      AQPB947VAUX1 = 'PYME'
                WHERE AQPB947INST1 = pINST
                  AND AQPB947FECP1 =
                      (SELECT MAX(AQPB947FECP1)
                         FROM AQPB947
                        WHERE AQPB947INST1 = pINST)
                  AND AQPB947HORP1 =
                      (SELECT MAX(AQPB947HORP1)
                         FROM AQPB947
                        WHERE AQPB947INST1 = pINST
                          AND AQPB947FECP1 =
                              (SELECT MAX(AQPB947FECP1)
                                 FROM AQPB947
                                WHERE AQPB947INST1 = pINST));
               COMMIT;
               pACTUALIZO := 'S';
            EXCEPTION
               WHEN OTHERS THEN
                  pACTUALIZO := 'N';
            END;
         END IF;
      ELSE
         FOR X IN C3 LOOP
            BEGIN
               SELECT TP1NRO3, TRIM(TP1DESC)
                 INTO V_ITEM, V_NOM_VAR
                 FROM FST198
                WHERE TP1COD = 1
                  AND TP1COD1 = 11115
                  AND TP1CORR1 = 100
                  AND TP1NRO1 = X.TP1NRO1
                  AND TP1NRO2 = X.RNG68COD;
               PQ_CR_SEG_EXCEP.SP_CR_VARIABLES_PAE(pINST,
                                                   V_ITEM,
                                                   V_OUT_VAL);
               BEGIN
                  SELECT TP1CORR3
                    INTO V_CORR_CONCP
                    FROM FST198
                   WHERE TP1COD = 1
                     AND TP1COD1 = 111154
                     AND TP1CORR1 = 14
                     AND TP1NRO1 = X.TP1NRO1
                     AND TP1DESC = RPAD(V_NOM_VAR, 30, ' ');
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               CASE
                  WHEN V_CORR_CONCP = 21 THEN
                     V_CONCEPTO1 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 22 THEN
                     V_CONCEPTO2 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 23 THEN
                     V_CONCEPTO3 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 24 THEN
                     V_CONCEPTO4 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 25 THEN
                     V_CONCEPTO5 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 26 THEN
                     V_CONCEPTO6 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 27 THEN
                     V_CONCEPTO7 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 28 THEN
                     V_CONCEPTO8 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 29 THEN
                     V_CONCEPTO9 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 30 THEN
                     V_CONCEPTO10 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 31 THEN
                     V_CONCEPTO11 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 32 THEN
                     V_CONCEPTO12 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 33 THEN
                     V_CONCEPTO13 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 34 THEN
                     V_CONCEPTO14 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 35 THEN
                     V_CONCEPTO15 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 36 THEN
                     V_CONCEPTO16 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 37 THEN
                     V_CONCEPTO17 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 38 THEN
                     V_CONCEPTO18 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 39 THEN
                     V_CONCEPTO19 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  WHEN V_CORR_CONCP = 40 THEN
                     V_CONCEPTO20 := V_NOM_VAR || ':' || TRIM(V_OUT_VAL);
                  ELSE
                     NULL;
               END CASE;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  V_ITEM    := NULL;
                  V_NOM_VAR := NULL;
               WHEN TOO_MANY_ROWS THEN
                  V_ITEM    := NULL;
                  V_NOM_VAR := NULL;
                  FOR I IN AUX_C1(X.TP1NRO1, X.RNG68COD) LOOP
                     PQ_CR_SEG_EXCEP.SP_CR_VARIABLES_PAE(pINST,
                                                         I.TP1NRO3,
                                                         V_OUT_VAL);
                     BEGIN
                        SELECT TP1CORR3
                          INTO V_CORR_CONCP
                          FROM FST198
                         WHERE TP1COD = 1
                           AND TP1COD1 = 111154
                           AND TP1CORR1 = 14
                           AND TP1NRO1 = X.TP1NRO1
                           AND TP1DESC = RPAD(I.TP1DESC, 30, ' ');
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;
                     CASE
                        WHEN V_CORR_CONCP = 21 THEN
                           V_CONCEPTO1 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 22 THEN
                           V_CONCEPTO2 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 23 THEN
                           V_CONCEPTO3 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 24 THEN
                           V_CONCEPTO4 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 25 THEN
                           V_CONCEPTO5 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 26 THEN
                           V_CONCEPTO6 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 27 THEN
                           V_CONCEPTO7 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 28 THEN
                           V_CONCEPTO8 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 29 THEN
                           V_CONCEPTO9 := TRIM(I.TP1DESC) || ':' ||
                                          TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 30 THEN
                           V_CONCEPTO10 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 31 THEN
                           V_CONCEPTO11 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 32 THEN
                           V_CONCEPTO12 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 33 THEN
                           V_CONCEPTO13 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 34 THEN
                           V_CONCEPTO14 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 35 THEN
                           V_CONCEPTO15 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 36 THEN
                           V_CONCEPTO16 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 37 THEN
                           V_CONCEPTO17 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 38 THEN
                           V_CONCEPTO18 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 39 THEN
                           V_CONCEPTO19 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        WHEN V_CORR_CONCP = 40 THEN
                           V_CONCEPTO20 := TRIM(I.TP1DESC) || ':' ||
                                           TRIM(V_OUT_VAL);
                        ELSE
                           NULL;
                     END CASE;
                  END LOOP;
               WHEN OTHERS THEN
                  NULL;
            END;
         END LOOP;
         BEGIN
            V_SEG_ORI     := NULL;
            V_OUT_SEG_ORI := NULL;
            PQ_CR_SEGMENTACION_CONSUMO_LINEA.SP_CR_NS_LINEA(V_PGFAPE,
                                                            V_PAIS,
                                                            V_TDOC,
                                                            V_NDOC,
                                                            pUSUP,
                                                            V_C_NULL,
                                                            V_OUT_SEG_ORI);
            V_SEG_ORI := TRIM(V_OUT_SEG_ORI);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         BEGIN
            UPDATE AQPB947
               SET AQPB947ESTA  = 'H',
                   AQPB947CORR2 = pCORR,
                   AQPB947INST2 = V_INST,
                   AQPB947FECP2 = V_FECHA,
                   AQPB947HORP2 = V_HORA,
                   AQPB947VAR21 = V_CONCEPTO1,
                   AQPB947VAR22 = V_CONCEPTO2,
                   AQPB947VAR23 = V_CONCEPTO3,
                   AQPB947VAR24 = V_CONCEPTO4,
                   AQPB947VAR25 = V_CONCEPTO5,
                   AQPB947VAR26 = V_CONCEPTO6,
                   AQPB947VAR27 = V_CONCEPTO7,
                   AQPB947VAR28 = V_CONCEPTO8,
                   AQPB947VAR29 = V_CONCEPTO9,
                   AQPB947VAR30 = V_CONCEPTO10,
                   AQPB947VAR31 = V_CONCEPTO11,
                   AQPB947VAR32 = V_CONCEPTO12,
                   AQPB947VAR33 = V_CONCEPTO13,
                   AQPB947VAR34 = V_CONCEPTO14,
                   AQPB947VAR35 = V_CONCEPTO15,
                   AQPB947VAR36 = V_CONCEPTO16,
                   AQPB947VAR37 = V_CONCEPTO17,
                   AQPB947VAR38 = V_CONCEPTO18,
                   AQPB947VAR39 = V_CONCEPTO19,
                   AQPB947VAR40 = V_CONCEPTO20,
                   AQPB947MYSAL = V_MAY_SAL,
                   AQPB947DATRE = V_DIA_ATRASO_E,
                   AQPB947NCAMS = V_NUM_CAM_SEG,
                   AQPB947FHCAM = V_FECH_CAM,
                   AQPB947NINSC = V_NUM_INST_CAM,
                   AQPB947SEGOR = V_SEG_ORI,
                   AQPB947FSLNC = V_FECH_SOLIC_NO_CONF,
                   AQPB947NEXGC = V_NUM_EXC_GC,
                   AQPB947ULSEG = V_ULT_SEG,
                   AQPB947SBRED = V_SOBRE_ENDEUDADO,
                   AQPB947LSTNG = V_LISTA_NEGRA,
                   AQPB947INSCP = V_INST_CAMP,
                   AQPB947CVIGA = V_CRED_VIG_ATR,
                   AQPB947VAUX1 = 'CONSUMO'
             WHERE AQPB947INST1 = pINST
               AND AQPB947FECP1 =
                   (SELECT MAX(AQPB947FECP1)
                      FROM AQPB947
                     WHERE AQPB947INST1 = pINST)
               AND AQPB947HORP1 =
                   (SELECT MAX(AQPB947HORP1)
                      FROM AQPB947
                     WHERE AQPB947INST1 = pINST
                       AND AQPB947FECP1 =
                           (SELECT MAX(AQPB947FECP1)
                              FROM AQPB947
                             WHERE AQPB947INST1 = pINST));
            COMMIT;
            pACTUALIZO := 'S';
         EXCEPTION
            WHEN OTHERS THEN
               pACTUALIZO := 'N';
         END;
      END IF;
      IF pACTUALIZO = 'S' THEN
         BEGIN
            UPDATE AQPB947
               SET AQPB947ESTA = 'I'
             WHERE AQPB947INST1 = pINST
               AND AQPB947FECP1 = (SELECT A.AQPB947FECP1
                                     FROM (SELECT ROW_NUMBER() OVER(ORDER BY AQPB947FECP1, AQPB947HORP1 DESC) AS FILA,
                                                  AQPB947FECP1
                                             FROM AQPB947
                                            WHERE AQPB947INST1 = pINST) A
                                    WHERE FILA = 2)
               AND AQPB947HORP1 = (SELECT A.AQPB947HORP1
                                     FROM (SELECT ROW_NUMBER() OVER(ORDER BY AQPB947FECP1, AQPB947HORP1 DESC) AS FILA,
                                                  AQPB947HORP1
                                             FROM AQPB947
                                            WHERE AQPB947INST1 = pINST) A
                                    WHERE FILA = 2);
         
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END IF;
   END SP_CR_ACTUALIZAR_FORMULARIO;

   PROCEDURE SP_CR_ENVIAR_CORREO(pINST         IN  NUMBER,
                                 pMDA          IN  NUMBER,
                                 pCORR         IN  NUMBER,
                                 pSEGA         IN  VARCHAR2,
                                 pSEGN         IN  VARCHAR2,
                                 P_ERROR_ENVIO OUT VARCHAR2) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_ENVIAR_CORREO
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/07/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : ENVIAR CORREO AL GERENTE DE AGENCIA, ASESOR Y
      --                               AL USUARIO QUE ESTA EJECUTANDO EL PANEL, EN EL MOMENTO
      --                               QUE EL USUARIO CONFIRME EL CAMBIO DE LA NUEVA SEGMENTACION
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 09/01/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : SE AGREGO UN PROCESO PARA EL RE-ENVIO DEL CORREO, EN CASO QUE
      --                               QUE NO SE HAYA PODIADO ENVIAR EL CORREO LA PRIMERA VEZ
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 26/03/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : SE MODIFICO LA ESTRUCTURA DEL CORREO
      -- *****************************************************************
   
      V_PGFAPE            DATE;
      V_CODRES            NUMBER(3);
      V_CTA               NUMBER(9);
      V_NOM_CLI           VARCHAR2(35);
      V_SIGNO_MDA         VARCHAR2(4);
      V_MONTO             VARCHAR2(20);
      V_ASUNTO            VARCHAR2(100);
      V_EMISOR            VARCHAR2(40);
      V_MENSAJE           CLOB;
      V_EMAIL_GUIA        VARCHAR2(30);
      V_DOMINIO_GUIA      VARCHAR2(30);
      V_EMAIL2            VARCHAR2(40);
      V_EMAIL3            VARCHAR2(40);
      V_DESTIN            VARCHAR2(250);
      V_DESTCC            VARCHAR2(3000);
      V_OUTCODE1          VARCHAR2(5);
      V_OUTMSGE1          VARCHAR2(500);
      V_OUTCODE2          VARCHAR2(5);
      V_OUTMSGE2          VARCHAR2(500);
      CONDICION1          VARCHAR2(150);
      CONDICION2          VARCHAR2(150);
      COMENTARIO          VARCHAR2(150);
      BUSCAR_CARACTER     VARCHAR2(1);
      REEMPLAZAR_CARACTER VARCHAR2(30);
      
      CURSOR LISTA_TILDES IS SELECT *
        FROM FST198
       WHERE TP1COD   = 1
         AND TP1COD1  = 10825
         AND TP1CORR1 = 75
         AND TP1CORR2 = 1;
   BEGIN
      BEGIN
         SELECT PGFAPE INTO V_PGFAPE FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_PGFAPE := NULL;
      END;
      BEGIN
         SELECT TRIM(TP1DESC)
           INTO V_EMAIL_GUIA
           FROM FST198
          WHERE TP1COD = 1
            AND TP1COD1 = 111154
            AND TP1CORR1 = 1
            AND TP1CORR2 = 13
            AND TP1CORR3 = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_EMAIL_GUIA := NULL;
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT TRIM(TP1DESC)
           INTO V_DOMINIO_GUIA
           FROM FST198
          WHERE TP1COD = 1
            AND TP1COD1 = 111154
            AND TP1CORR1 = 1
            AND TP1CORR2 = 14
            AND TP1CORR3 = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_DOMINIO_GUIA := NULL;
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT TRIM(B.WFUSREMAIL)
           INTO V_EMAIL2
           FROM SNG001 A, WFUSERS B
          WHERE A.SNG001INST = pINST
            AND A.SNG001ASE = B.WFUSRCOD;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_EMAIL2 := NULL;
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT TRIM(B.WFUSREMAIL)
           INTO V_EMAIL3
           FROM SNG057 A, WFUSERS B, SNG001 C
          WHERE C.SNG001INST = pINST
            AND A.SNG055EMP = 1
            AND A.SNG057USR = C.SNG001ASE
            AND A.SNG057SUP = B.WFUSRCOD
            AND (V_PGFAPE >= A.SNG057INI AND V_PGFAPE <= A.SNG057FIN);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_EMAIL3 := NULL;
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT AQPB947CODRE, AQPB947CTA,
                TRIM(TO_CHAR(AQPB947MONTO, '99999999999G999G999D00', 'NLS_NUMERIC_CHARACTERS = ''.,''')),
                TRIM(AQPB947COND1), TRIM(AQPB947COND2), TRIM(AQPB947COMMT)
           INTO V_CODRES, V_CTA, V_MONTO, CONDICION1, CONDICION2, COMENTARIO
           FROM AQPB947
          WHERE AQPB947INST2 = pINST
            AND AQPB947CORR2 = pCORR;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT TRIM(CTNOM)
           INTO V_NOM_CLI
           FROM FSD008
          WHERE PGCOD = 1
            AND CTNRO = V_CTA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT TRIM(MOSIGN)
           INTO V_SIGNO_MDA
           FROM FST005
          WHERE MONEDA = pMDA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      CASE
         WHEN V_CODRES = 1 THEN
            IF V_EMAIL2 IS NOT NULL THEN
               V_DESTIN := V_EMAIL2;
               IF V_EMAIL3 IS NOT NULL THEN
                  V_DESTIN := V_DESTIN || ';' || V_EMAIL3;
               END IF;
            ELSE
               IF V_EMAIL3 IS NOT NULL THEN
                  V_DESTIN := V_EMAIL3;
               ELSE
                  V_DESTIN := ' ';
               END IF;
            END IF;
            IF V_EMAIL_GUIA IS NULL OR V_DOMINIO_GUIA IS NULL THEN
               V_DESTCC := ' ';
            ELSE
               V_DESTCC := V_EMAIL_GUIA || V_DOMINIO_GUIA;
            END IF;
            V_ASUNTO  := 'Mensaje de Cambio de Segmentación - Cliente: ' || V_NOM_CLI;
            V_EMISOR  := 'notificaciones@cajaarequipa.pe';
            V_MENSAJE := '<html>
                           <head>
                              <style type="text/css"></style>
                           </head>
                           <body>
                             <p>Estimado(a): Se ha realizado la evaluación de su solicitud y <strong>se realizó el cambio de manera satisfactoria del segmento ' 
                             || pSEGA || ' a ' || pSEGN || '</strong></p>
                             <ul>
                               <li>Cuenta: ' || V_CTA || '</li>
                               <li>Instancia: ' || pINST || '</li>
                               <li>Monto: ' || V_SIGNO_MDA || ' ' || V_MONTO || '</li>
                             </ul>
                             <p><strong>El monto, plazo y otras condiciones deben ser evaluados por los comités correspondientes.</strong></p>
                             <p>Saludos,</p>
                             <p>Departamento de Calidad y Tecnología Crediticia</p>
                             <p><strong><em>"Personas sirviendo a personas"</em></strong></p>
                           </body>
                         </html>';
                         
            FOR J IN LISTA_TILDES LOOP
               BUSCAR_CARACTER     := SUBSTR(TRIM(J.TP1DESC), 1, 1);
               REEMPLAZAR_CARACTER := SUBSTR(TRIM(J.TP1DESC), 3, LENGTH(TRIM(J.TP1DESC)) - 2);
               V_MENSAJE           := REPLACE(V_MENSAJE, BUSCAR_CARACTER, REEMPLAZAR_CARACTER);
            END LOOP;
            
            BEGIN
               PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_DESTIN,
                                                p_DestinatariosCC   => V_DESTCC,
                                                p_DestinatariosBcc  => ' ',
                                                p_Mensaje           => V_MENSAJE,
                                                p_Remitente         => V_EMISOR,
                                                p_Asunto            => V_ASUNTO,
                                                p_TipoMensaje       => 'HTML',
                                                p_Directorio        => ' ',
                                                p_ArchivosAdjuntos  => ' ',
                                                p_c_coderr          => V_OUTCODE1,
                                                p_c_deserr          => V_OUTMSGE1);
            EXCEPTION
               WHEN OTHERS THEN
                  V_OUTMSGE1 := SUBSTR(TRIM(SQLERRM), 1, 500);
            END;
            BEGIN
               UPDATE AQPB947
                  SET AQPB947DESTI = TRIM(V_DESTIN) || ';' || TRIM(V_DESTCC),
                      AQPB947MENSJ = V_MENSAJE,
                      AQPB947ERROR = V_OUTMSGE1
                WHERE AQPB947INST2 = pINST
                  AND AQPB947CORR2 = pCORR;
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            IF V_OUTCODE1 <> '000' THEN
               BEGIN
                  PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 2,
                                                            P_C_ASUNTO => V_ASUNTO,
                                                            P_C_DESPAR => V_DESTIN,
                                                            P_C_DESCOC => V_DESTCC,
                                                            P_C_DESCCO => ' ',
                                                            P_C_MENSAJ => V_MENSAJE,
                                                            P_C_REMITE => V_EMISOR,
                                                            P_C_DIRECT => ' ',
                                                            P_C_ADJUNT => ' ',
                                                            P_N_AUX001 => pINST,
                                                            P_N_AUX002 => 0,
                                                            P_N_AUX003 => 0,
                                                            P_N_AUX004 => 0,
                                                            P_D_AUX005 => NULL,
                                                            P_D_AUX006 => NULL,
                                                            P_C_AUX007 => 'CAMBIO DE SEGMENTO',
                                                            P_C_AUX008 => 'HJAQZ874',
                                                            P_C_AUX009 => ' ',
                                                            P_C_CODERR => V_OUTCODE2,
                                                            P_C_MSGERR => V_OUTMSGE2);
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
            P_ERROR_ENVIO := V_OUTCODE1;
         WHEN V_CODRES = 2 THEN
            IF V_EMAIL2 IS NOT NULL THEN
               V_DESTIN := V_EMAIL2;
               IF V_EMAIL3 IS NOT NULL THEN
                  V_DESTIN := V_DESTIN || ';' || V_EMAIL3;
               END IF;
            ELSE
               IF V_EMAIL3 IS NOT NULL THEN
                  V_DESTIN := V_EMAIL3;
               ELSE
                  V_DESTIN := ' ';
               END IF;
            END IF;
            IF V_EMAIL_GUIA IS NULL OR V_DOMINIO_GUIA IS NULL THEN
               V_DESTCC := ' ';
            ELSE
               V_DESTCC := V_EMAIL_GUIA || V_DOMINIO_GUIA;
            END IF;
            V_ASUNTO  := 'Mensaje de Cambio de Segmentación - Cliente: ' || V_NOM_CLI;
            V_EMISOR  := 'notificaciones@cajaarequipa.pe';
            V_MENSAJE := '<html>
                           <head>
                              <style type="text/css"></style>
                           </head>
                           <body>
                             <p>Estimado(a): Se ha realizado la evaluación de su solicitud y <strong>se realizó el cambio de manera satisfactoria del segmento ' 
                             || pSEGA || ' a ' || pSEGN || ' por autonomía de GCRE</strong></p>
                             <ul>
                               <li>Cuenta: ' || V_CTA || '</li>
                               <li>Instancia: ' || pINST || '</li>
                               <li>Monto: ' || V_SIGNO_MDA || ' ' || V_MONTO || '</li>
                             </ul>
                             <p><strong>El monto, plazo y otras condiciones deben ser evaluados por los comités correspondientes.</strong></p>
                             <p>Saludos,</p>
                             <p>Departamento de Calidad y Tecnología Crediticia</p>
                             <p><strong><em>"Personas sirviendo a personas"</em></strong></p>
                           </body>
                         </html>';
            
            FOR J IN LISTA_TILDES LOOP
               BUSCAR_CARACTER     := SUBSTR(TRIM(J.TP1DESC), 1, 1);
               REEMPLAZAR_CARACTER := SUBSTR(TRIM(J.TP1DESC), 3, LENGTH(TRIM(J.TP1DESC)) - 2);
               V_MENSAJE           := REPLACE(V_MENSAJE, BUSCAR_CARACTER, REEMPLAZAR_CARACTER);
            END LOOP;
            
            BEGIN
               PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_DESTIN,
                                                p_DestinatariosCC   => V_DESTCC,
                                                p_DestinatariosBcc  => ' ',
                                                p_Mensaje           => V_MENSAJE,
                                                p_Remitente         => V_EMISOR,
                                                p_Asunto            => V_ASUNTO,
                                                p_TipoMensaje       => 'HTML',
                                                p_Directorio        => ' ',
                                                p_ArchivosAdjuntos  => ' ',
                                                p_c_coderr          => V_OUTCODE1,
                                                p_c_deserr          => V_OUTMSGE1);
            EXCEPTION
               WHEN OTHERS THEN
                  V_OUTMSGE1 := SUBSTR(TRIM(SQLERRM), 1, 500);
            END;
            BEGIN
               UPDATE AQPB947
                  SET AQPB947DESTI = TRIM(V_DESTIN) || ';' || TRIM(V_DESTCC),
                      AQPB947MENSJ = V_MENSAJE,
                      AQPB947ERROR = V_OUTMSGE1
                WHERE AQPB947INST2 = pINST
                  AND AQPB947CORR2 = pCORR;
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            IF V_OUTCODE1 <> '000' THEN
               BEGIN
                  PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 2,
                                                            P_C_ASUNTO => V_ASUNTO,
                                                            P_C_DESPAR => V_DESTIN,
                                                            P_C_DESCOC => V_DESTCC,
                                                            P_C_DESCCO => ' ',
                                                            P_C_MENSAJ => V_MENSAJE,
                                                            P_C_REMITE => V_EMISOR,
                                                            P_C_DIRECT => ' ',
                                                            P_C_ADJUNT => ' ',
                                                            P_N_AUX001 => pINST,
                                                            P_N_AUX002 => 0,
                                                            P_N_AUX003 => 0,
                                                            P_N_AUX004 => 0,
                                                            P_D_AUX005 => NULL,
                                                            P_D_AUX006 => NULL,
                                                            P_C_AUX007 => 'CAMBIO DE SEGMENTO',
                                                            P_C_AUX008 => 'HJAQZ874',
                                                            P_C_AUX009 => ' ',
                                                            P_C_CODERR => V_OUTCODE2,
                                                            P_C_MSGERR => V_OUTMSGE2);
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
            P_ERROR_ENVIO := V_OUTCODE1;
         WHEN V_CODRES = 3 THEN
            IF V_EMAIL2 IS NOT NULL THEN
               V_DESTIN := V_EMAIL2;
               IF V_EMAIL3 IS NOT NULL THEN
                  V_DESTIN := V_DESTIN || ';' || V_EMAIL3;
               END IF;
            ELSE
               IF V_EMAIL3 IS NOT NULL THEN
                  V_DESTIN := V_EMAIL3;
               ELSE
                  V_DESTIN := ' ';
               END IF;
            END IF;
            IF V_EMAIL_GUIA IS NULL OR V_DOMINIO_GUIA IS NULL THEN
               V_DESTCC := ' ';
            ELSE
               V_DESTCC := V_EMAIL_GUIA || V_DOMINIO_GUIA;
            END IF;
            V_ASUNTO  := 'Mensaje de Cambio de Segmentación - Cliente: ' || V_NOM_CLI;
            V_EMISOR  := 'notificaciones@cajaarequipa.pe';
            V_MENSAJE := '<html>
                           <head>
                              <style type="text/css"></style>
                           </head>
                           <body>
                             <p>Estimado(a): Se ha realizado la evaluación de su solicitud y por el momento el cliente no cumple las consideraciones 
                                             para el segmento requerido:</p>
                             <ul>
                               <li>Cuenta: ' || V_CTA || '</li>
                               <li>Instancia: ' || pINST || '</li>
                               <li>Monto: ' || V_SIGNO_MDA || ' ' || V_MONTO || '</li>
                               <li>Condición 1: ' || CONDICION1 || '</li>
                               <li>Condición 2: ' || CONDICION2 || '</li>
                               <li>Comentario: ' || COMENTARIO || '</li>
                             </ul>
                             <p>Saludos,</p>
                             <p>Departamento de Calidad y Tecnología Crediticia</p>
                           </body>
                         </html>';
            
            FOR J IN LISTA_TILDES LOOP
               BUSCAR_CARACTER     := SUBSTR(TRIM(J.TP1DESC), 1, 1);
               REEMPLAZAR_CARACTER := SUBSTR(TRIM(J.TP1DESC), 3, LENGTH(TRIM(J.TP1DESC)) - 2);
               V_MENSAJE           := REPLACE(V_MENSAJE, BUSCAR_CARACTER, REEMPLAZAR_CARACTER);
            END LOOP;
            
            BEGIN
               PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_DESTIN,
                                                p_DestinatariosCC   => V_DESTCC,
                                                p_DestinatariosBcc  => ' ',
                                                p_Mensaje           => V_MENSAJE,
                                                p_Remitente         => V_EMISOR,
                                                p_Asunto            => V_ASUNTO,
                                                p_TipoMensaje       => 'HTML',
                                                p_Directorio        => ' ',
                                                p_ArchivosAdjuntos  => ' ',
                                                p_c_coderr          => V_OUTCODE1,
                                                p_c_deserr          => V_OUTMSGE1);
            EXCEPTION
               WHEN OTHERS THEN
                  V_OUTMSGE1 := SUBSTR(TRIM(SQLERRM), 1, 500);
            END;
            BEGIN
               UPDATE AQPB947
                  SET AQPB947DESTI = TRIM(V_DESTIN) || ';' || TRIM(V_DESTCC),
                      AQPB947MENSJ = V_MENSAJE,
                      AQPB947ERROR = V_OUTMSGE1
                WHERE AQPB947INST2 = pINST
                  AND AQPB947CORR2 = pCORR;
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            IF V_OUTCODE1 <> '000' THEN
               BEGIN
                  PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 2,
                                                            P_C_ASUNTO => V_ASUNTO,
                                                            P_C_DESPAR => V_DESTIN,
                                                            P_C_DESCOC => V_DESTCC,
                                                            P_C_DESCCO => ' ',
                                                            P_C_MENSAJ => V_MENSAJE,
                                                            P_C_REMITE => V_EMISOR,
                                                            P_C_DIRECT => ' ',
                                                            P_C_ADJUNT => ' ',
                                                            P_N_AUX001 => pINST,
                                                            P_N_AUX002 => 0,
                                                            P_N_AUX003 => 0,
                                                            P_N_AUX004 => 0,
                                                            P_D_AUX005 => NULL,
                                                            P_D_AUX006 => NULL,
                                                            P_C_AUX007 => 'CAMBIO DE SEGMENTO',
                                                            P_C_AUX008 => 'HJAQZ874',
                                                            P_C_AUX009 => ' ',
                                                            P_C_CODERR => V_OUTCODE2,
                                                            P_C_MSGERR => V_OUTMSGE2);
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
            P_ERROR_ENVIO := V_OUTCODE1;
         WHEN V_CODRES = 4 THEN
            IF V_EMAIL2 IS NOT NULL THEN
               V_DESTIN := V_EMAIL2;
               IF V_EMAIL3 IS NOT NULL THEN
                  V_DESTIN := V_DESTIN || ';' || V_EMAIL3;
               END IF;
            ELSE
               IF V_EMAIL3 IS NOT NULL THEN
                  V_DESTIN := V_EMAIL3;
               ELSE
                  V_DESTIN := ' ';
               END IF;
            END IF;
            IF V_EMAIL_GUIA IS NULL OR V_DOMINIO_GUIA IS NULL THEN
               V_DESTCC := ' ';
            ELSE
               V_DESTCC := V_EMAIL_GUIA || V_DOMINIO_GUIA;
            END IF;
            V_ASUNTO  := 'Mensaje de Cambio de Segmentación - Cliente: ' || V_NOM_CLI;
            V_EMISOR  := 'notificaciones@cajaarequipa.pe';
            V_MENSAJE := '<html>
                           <head>
                              <style type="text/css"></style>
                           </head>
                           <body>
                             <p>Estimado(a): Se ha realizado la evaluación de su solicitud y <strong>se realizó el cambio de manera satisfactoria del segmento ' 
                             || pSEGA || ' a ' || pSEGN || ' por excepción de GCRE</strong></p>
                             <ul>
                               <li>Cuenta: ' || V_CTA || '</li>
                               <li>Instancia: ' || pINST || '</li>
                               <li>Monto: ' || V_SIGNO_MDA || ' ' || V_MONTO || '</li>
                             </ul>
                             <p><strong>El monto, plazo y otras condiciones deben ser evaluados por los comités correspondientes.</strong></p>
                             <p>Saludos,</p>
                             <p>Departamento de Calidad y Tecnología Crediticia</p>
                             <p><strong><em>"Personas sirviendo a personas"</em></strong></p>
                           </body>
                         </html>';
            
            FOR J IN LISTA_TILDES LOOP
               BUSCAR_CARACTER     := SUBSTR(TRIM(J.TP1DESC), 1, 1);
               REEMPLAZAR_CARACTER := SUBSTR(TRIM(J.TP1DESC), 3, LENGTH(TRIM(J.TP1DESC)) - 2);
               V_MENSAJE           := REPLACE(V_MENSAJE, BUSCAR_CARACTER, REEMPLAZAR_CARACTER);
            END LOOP;
            
            BEGIN
               PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_DESTIN,
                                                p_DestinatariosCC   => V_DESTCC,
                                                p_DestinatariosBcc  => ' ',
                                                p_Mensaje           => V_MENSAJE,
                                                p_Remitente         => V_EMISOR,
                                                p_Asunto            => V_ASUNTO,
                                                p_TipoMensaje       => 'HTML',
                                                p_Directorio        => ' ',
                                                p_ArchivosAdjuntos  => ' ',
                                                p_c_coderr          => V_OUTCODE1,
                                                p_c_deserr          => V_OUTMSGE1);
            EXCEPTION
               WHEN OTHERS THEN
                  V_OUTMSGE1 := SUBSTR(TRIM(SQLERRM), 1, 500);
            END;
            BEGIN
               UPDATE AQPB947
                  SET AQPB947DESTI = TRIM(V_DESTIN) || ';' || TRIM(V_DESTCC),
                      AQPB947MENSJ = V_MENSAJE,
                      AQPB947ERROR = V_OUTMSGE1
                WHERE AQPB947INST2 = pINST
                  AND AQPB947CORR2 = pCORR;
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            IF V_OUTCODE1 <> '000' THEN
               BEGIN
                  PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 2,
                                                            P_C_ASUNTO => V_ASUNTO,
                                                            P_C_DESPAR => V_DESTIN,
                                                            P_C_DESCOC => V_DESTCC,
                                                            P_C_DESCCO => ' ',
                                                            P_C_MENSAJ => V_MENSAJE,
                                                            P_C_REMITE => V_EMISOR,
                                                            P_C_DIRECT => ' ',
                                                            P_C_ADJUNT => ' ',
                                                            P_N_AUX001 => pINST,
                                                            P_N_AUX002 => 0,
                                                            P_N_AUX003 => 0,
                                                            P_N_AUX004 => 0,
                                                            P_D_AUX005 => NULL,
                                                            P_D_AUX006 => NULL,
                                                            P_C_AUX007 => 'CAMBIO DE SEGMENTO',
                                                            P_C_AUX008 => 'HJAQZ874',
                                                            P_C_AUX009 => ' ',
                                                            P_C_CODERR => V_OUTCODE2,
                                                            P_C_MSGERR => V_OUTMSGE2);
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
            P_ERROR_ENVIO := V_OUTCODE1;
         ELSE
            NULL;
      END CASE;
   END SP_CR_ENVIAR_CORREO;

   PROCEDURE SP_CR_ACTIVAR_CONTROL_DUPLICIDAD(pFHOY       IN DATE,
                                              pINST       IN NUMBER,
                                              pFCHULTREG  OUT DATE,
                                              pDUPLICIDAD OUT VARCHAR2) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_ACTIVAR_CONTROL_DUPLICIDAD
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/07/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : VALIDA SI EL CLIENTE TIENE MAS DE 1 CAMBIO
      --                               DE SEGMENTO REALIZADO
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
      V_FCHINI DATE;
      V_PAIS   NUMBER(3);
      V_TDOC   NUMBER(2);
      V_NDOC   VARCHAR2(12);
      V_CONT   NUMBER(9);
   BEGIN
      V_FCHINI := ADD_MONTHS(pFHOY, -3);
      BEGIN
         SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC
           INTO V_PAIS, V_TDOC, V_NDOC
           FROM SNG001
          WHERE SNG001INST = pINST;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT COUNT(DISTINCT JAQZ870CORR || JAQZ870FECP || JAQZ870HORP ||
                      JAQZ870INST),
                MAX(JAQZ870FECP)
           INTO V_CONT, pFCHULTREG
           FROM SNG001 A, JAQZ870 B
          WHERE A.SNG001PAIS = V_PAIS
            AND A.SNG001TDOC = V_TDOC
            AND A.SNG001NDOC = V_NDOC
            AND B.JAQZ870INST = A.SNG001INST
            AND B.JAQZ870FECP BETWEEN V_FCHINI AND pFHOY;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_CONT := 0;
         WHEN OTHERS THEN
            NULL;
      END;
      IF V_CONT >= 1 THEN
         pDUPLICIDAD := 'S';
      ELSE
         pFCHULTREG  := NULL;
         pDUPLICIDAD := 'N';
      END IF;
   END SP_CR_ACTIVAR_CONTROL_DUPLICIDAD;

END PQ_CR_FORMULARIO_SEGMENTO;
/

