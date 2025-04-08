CREATE OR REPLACE PACKAGE PQ_CR_DATOS_CONSULTA_BURO IS
   
  -- ====================================================================================================
  -- NOMBRE                      : PQ_CR_DATOS_CONSULTA_BURO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 17/11/2022
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 27/02/2024
  -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
  -- DESCRIPCION DE MODIFICACION : SE AGREGO EL PROCEDIMIENTO SP_CR_OBTENER_DATOS_PRECALIF
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 29/04/2024
  -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
  -- DESCRIPCION DE MODIFICACION : SE AGREGARON LOS SIGUIENTES PROCEDIMIENTO:
  --                               - SP_CR_VALIDAR_LIMITE_CONSULTAS
  --                               - SP_CR_OBTENER_SCORE_2
  --                               - SP_CR_GRABAR_LOG_MAX_CONSULTAS
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 22/11/2024
  -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
  -- DESCRIPCION DE MODIFICACION : SE AGREGO EL PROCEDIMIENTO:
  --                               - SP_CR_CALIF_RANGO_MESES
  --                               SE MODIFICO EL PROCEDIMIENTO:
  --                               - SP_CR_OBTENER_DATOS_PRECALIF
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 11/03/2025
  -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
  -- DESCRIPCION DE MODIFICACION : SE AGREGO LOS SIGUIENTES PROCEDIMIENTOS:
  --                               - SP_CR_OBTENER_FECHA_RCC
  --                               - SP_CR_OBTENER_TPDOC_RCC
  --                               - SP_CR_OBTENER_ANTIG_RCC
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 28/03/2025
  -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
  -- DESCRIPCION DE MODIFICACION : SE MODIFICO EL PROCEDIMIENTO:
  --                               - SP_CR_OBTENER_TPDOC_RCC
  -- ====================================================================================================

   
  PROCEDURE SP_CR_BUSQUEDA_CONSULTA_BURO(PN_CORREL IN NUMBER,
                                        PV_CALIFI OUT VARCHAR2,
                                        PN_SERCON OUT NUMBER,
                                        PN_VLBURO OUT NUMBER,
                                        PN_SERBUR OUT NUMBER,
                                        PN_CODERR OUT NUMBER);
                                        
  /*===================================================================================================*/
  PROCEDURE SP_CR_GRABAR_ARCHIVO_CRU(PN_PAIS    IN NUMBER,
                                    PN_TDOC    IN NUMBER,
                                    PN_NDOC    IN VARCHAR2,
                                    PN_NUCON   IN NUMBER,
                                    PV_USER    IN VARCHAR2,
                                    PN_USUC    IN NUMBER,
                                    PV_ARCHIVO IN VARCHAR2,
                                    PV_ERRCRU  IN VARCHAR2,
                                    PV_MSGCRU  IN VARCHAR2,
                                    PN_CODERR  OUT NUMBER);
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_TIPO_SEGM(P_PAIS      IN  NUMBER,
                                   P_TDOC      IN  NUMBER,
                                   P_NDOC      IN  VARCHAR2,
                                   P_USER      IN  VARCHAR2,
                                   P_SEGM_MICR OUT VARCHAR2,
                                   P_SEGM_PYME OUT VARCHAR2,
                                   P_SEGM_CONS OUT VARCHAR2);
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_CALIFICACION(P_PAIS      IN  NUMBER,
                                      P_TDOC      IN  NUMBER,
                                      P_NDOC      IN  VARCHAR2,
                                      PN_CALIF    OUT NUMBER,
                                      PC_CALIF    OUT VARCHAR2,
                                      P_FECHA_ACT OUT DATE);
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_SCORE(P_TIPO_DOCUMENTO  IN  NUMBER,
                               P_NRO_DOCUMENTO   IN  VARCHAR2,
                               P_USUARIO_EJECUTA IN  VARCHAR2,
                               P_SEGMENTO_RIESGO OUT VARCHAR2,
                               P_RIESGO_SCORE    OUT VARCHAR2,
                               P_TIPO_SCORE      OUT VARCHAR2,
                               P_PUNTAJE         OUT NUMBER,
                               P_FECHA_SCORE     OUT DATE);
  
  /*===================================================================================================*/              
  PROCEDURE SP_CR_OBTENER_SCORE_SMS(P_TIPO_DOCUMENTO  IN NUMBER,
                                   P_NRO_DOCUMENTO   IN VARCHAR2,
                                   P_USUARIO_EJECUTA IN VARCHAR2,
                                   P_SEGMENTO_RIESGO OUT VARCHAR2,
                                   P_RIESGO_SCORE    OUT VARCHAR2,
                                   P_TIPO_SCORE      OUT VARCHAR2,
                                   P_PUNTAJE         OUT NUMBER,
                                   P_FECHA_SCORE     OUT DATE);
                                   
  /*===================================================================================================*/
  PROCEDURE SP_OBTENER_PEOR_CALIFICACION(P_PAIS   IN  NUMBER,
                                        P_TDOC   IN  NUMBER,
                                        P_NDOC   IN  VARCHAR2,
                                        PN_CALIF OUT NUMBER,
                                        PC_CALIF OUT VARCHAR2);
                                        
  /*===================================================================================================*/                                        
  PROCEDURE SP_CR_GRABAR_LOG(P_PAIS                    IN NUMBER,
                            P_TIPO_DOCUMENTO          IN NUMBER,
                            P_NRO_DOCUMENTO           IN VARCHAR2,
                            P_SUCURSAL                IN NUMBER,
                            P_CALIFICACION            IN VARCHAR2,
                            P_SERIAL_CONEXION         IN NUMBER,
                            P_SERIAL_BURO             IN NUMBER,
                            P_BURO                    IN NUMBER,
                            P_CORRELATIVO             IN NUMBER,
                            P_SEGMENTO_MICRO          IN VARCHAR2,
                            P_SEGMENTO_MYPE           IN VARCHAR2,
                            P_SEGMENTO_CONSUMO        IN VARCHAR2,                              
                            P_PORCENTAJE_CALIFICACION IN NUMBER,
                            P_ULTIMA_CALIFICACION     IN VARCHAR2,
                            P_SEGMENTO_RIESGO         IN VARCHAR2,
                            P_FECHA_ACTUALIZACION     IN DATE,
                            P_TIPO_SCORE              IN VARCHAR2,
                            P_PUNTAJE                 IN NUMBER,
                            P_RIESGO_SCORE            IN VARCHAR2,
                            P_FECHA_SCORE_ULTIMA      IN DATE,
                            P_CODIGO_ERROR            IN VARCHAR2,
                            P_MENSAJE_ERROR           IN VARCHAR2,
                            P_USUARIO_EJECUCION       IN VARCHAR2,
                            P_ORIGEN                  IN NUMBER);
  /*===================================================================================================*/
  PROCEDURE SP_CR_GRABAR_LOG_2(P_PAIS                    IN NUMBER,
                              P_TIPO_DOCUMENTO          IN NUMBER,
                              P_NRO_DOCUMENTO           IN VARCHAR2,
                              P_SUCURSAL                IN NUMBER,
                              P_CALIFICACION            IN VARCHAR2,
                              P_SERIAL_CONEXION         IN NUMBER,
                              P_SERIAL_BURO             IN NUMBER,
                              P_BURO                    IN NUMBER,
                              P_CORRELATIVO             IN NUMBER,
                              P_SEGMENTO_MICRO          IN VARCHAR2,
                              P_SEGMENTO_MYPE           IN VARCHAR2,
                              P_SEGMENTO_CONSUMO        IN VARCHAR2,
                              P_PORCENTAJE_CALIFICACION IN NUMBER,
                              P_ULTIMA_ACTUALIZACION    IN VARCHAR2,
                              P_SEGMENTO_RIESGO         IN VARCHAR2,
                              P_FECHA_ACTUALIZACION     IN DATE,
                              P_TIPO_SCORE              IN VARCHAR2,
                              P_PUNTAJE                 IN NUMBER,
                              P_RIESGO_SCORE            IN VARCHAR2,
                              P_FECHA_SCORE_ULTIMA      IN DATE,
                              P_NOMBRE_CLIENTE          IN VARCHAR2,
                              P_EDAD_CLIENTE            IN NUMBER,
                              P_CANT_TIPO_LISTA         IN NUMBER,
                              P_NRO_ENTIDADES           IN NUMBER,
                              P_CODIGO_ERROR            IN VARCHAR2,
                              P_MENSAJE_ERROR           IN VARCHAR2,
                              P_USUARIO_EJECUCION       IN VARCHAR2,
                              P_ORIGEN                  IN NUMBER);
                              
  /*===================================================================================================*/                          
  PROCEDURE SP_CR_OBTENER_DATOS_PRECALIF(PN_PAIS_DOCUMENTO  IN  NUMBER,
                                        PN_TIPO_DOCUMENTO  IN  NUMBER,
                                        PV_NRO_DOCUMENTO   IN  VARCHAR2,
                                        PV_NOMBRE_CLIENTE  OUT VARCHAR2,
                                        PN_EDAD_CLIENTE    OUT NUMBER,
                                        PN_CANT_TIPO_LISTA OUT NUMBER,
                                        PN_NRO_ENTIDADES   OUT NUMBER);
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_VALIDAR_LIMITE_CONSULTAS(PV_USUARIO       IN  VARCHAR2,
                                          PV_CODIGO_ERROR  OUT VARCHAR2,
                                          PV_MENSAJE_ERROR OUT VARCHAR2);
  
  /*===================================================================================================*/   
  PROCEDURE SP_CR_OBTENER_SCORE_2(PN_PAIS_DOCUMENTO IN  NUMBER,
                                 PN_TIPO_DOCUMENTO IN  NUMBER,
                                 PV_DOCUMENTO      IN  VARCHAR2,
                                 PV_USUARIO        IN  VARCHAR2,
                                 PV_SCORE_CLIENTE  OUT VARCHAR2,
                                 PV_DESC_PRECALIF  OUT VARCHAR2,
                                 PV_NOMBRE_CLIENTE OUT VARCHAR2);
                                 
  /*===================================================================================================*/
  PROCEDURE SP_CR_GRABAR_LOG_MAX_CONSULTAS(PN_PAIS_DOCUMENTO  IN NUMBER,
                                          PN_TIPO_DOCUMENTO  IN NUMBER,
                                          PV_DOCUMENTO       IN VARCHAR2,
                                          PV_USUARIO         IN VARCHAR2,
                                          PV_NOMBRE_CLIENTE  IN VARCHAR2,
                                          PV_SCORE_CLIENTE   IN VARCHAR2,
                                          PV_DESC_PRECALIF   IN VARCHAR2,
                                          PN_CORR_PRECALIF   IN NUMBER,
                                          PV_PRECALIFICACION IN VARCHAR2,
                                          PN_SERIAL_CONEXION IN NUMBER,
                                          PV_CODIGO_ERROR    IN VARCHAR2,
                                          PV_MENSAJE_ERROR   IN VARCHAR2);
                                              
  /*===================================================================================================*/
  PROCEDURE SP_CR_CALIF_RANGO_MESES(P_FECRCC IN  DATE,
                                    P_TIPDOC IN  NUMBER,
                                    P_NRODOC IN  VARCHAR2,
                                    P_CALIF3 OUT NUMBER,
                                    P_CALIF4 OUT NUMBER);
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_FECHA_RCC(P_FCH_RCC OUT DATE);
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_TPDOC_RCC(P_TIPO_DOC  IN  NUMBER,
                                    P_TPDOC_RCC OUT VARCHAR2);
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_ANTIG_RCC(P_TIPO_DOC  IN  NUMBER,
                                    P_NRO_DOC   IN  VARCHAR2,
                                    P_FCH_RCC   IN  DATE,
                                    P_ANTIG_RCC OUT NUMBER);
  
END PQ_CR_DATOS_CONSULTA_BURO;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_DATOS_CONSULTA_BURO IS

   PROCEDURE SP_CR_BUSQUEDA_CONSULTA_BURO(PN_CORREL IN NUMBER,
                                          PV_CALIFI OUT VARCHAR2,
                                          PN_SERCON OUT NUMBER,
                                          PN_VLBURO OUT NUMBER,
                                          PN_SERBUR OUT NUMBER,
                                          PN_CODERR OUT NUMBER) IS
      -- *****************************************************************
      -- NOMBRE                     : SP_CR_BUSQUEDA_CONSULTA_BURO
      -- SISTEMA                    : BANTOTAL
      -- MÓDULO                     : CRÉDITOS - ACTIVAS
      -- VERSIÓN                    : 1.0
      -- FECHA DE CREACIÓN          : 2022.11.17
      -- AUTOR DE CREACIÓN          : ALONSO PACHECO HUACHACA
      -- USO                        : BUSCA DATOS CONSULTA BURO
      -- ESTADO                     : ACTIVO
      -- ACCESO                     : PÚBLICO
      -- PARÁMETROS DE ENTRADA      : PN_CORREL ( CORRELATIVO )
      -- PARÁMETROS DE SALIDA       : PV_CALIFI ( PRECALIFICACION )
      --                              PN_SERCON ( SERIAL CONSULTA )
      --                              PN_VLBURO ( BURO )
      --                              PN_SERBUR ( SERIAL BURO )
      --                              PN_CODERR ( COD ERROR ) (0/ERROR | 1/OK)
      -- FECHA DE MODIFICACIÓN      : 
      -- AUTOR DE LA MODIFICACIÓN   : 
      -- DESCRIPCIÓN DE MODIFICACIÓN: 
      -- *****************************************************************                                         
   BEGIN
      PN_CODERR := 1;
      --VALOR DE PRECALIFICACION
      BEGIN
         SELECT J.JAQY599ACCIO
           INTO PV_CALIFI
           FROM USRCOBUS.JAQY599 J /*DESARROLLO: JAQY599 J */
          WHERE J.JAQY599CORRE = PN_CORREL;
      EXCEPTION
         WHEN OTHERS THEN
            PN_CODERR := 0;
      END;
      --SERIAL DE CONSULTA
      BEGIN
         SELECT A.AQPA012CONEC
           INTO PN_SERCON
           FROM USRCOBUS.AQPA012 A /* DESARROLLO: AQPA012 A*/
          WHERE A.AQPA012CORRE = PN_CORREL;
      EXCEPTION
         WHEN OTHERS THEN
            PN_CODERR := 0;
      END;
      --SERIAL DE BURO
      BEGIN
         SELECT L.AQPA011LBURO, L.AQPA011LSERIA
           INTO PN_VLBURO, PN_SERBUR
           FROM USRCOBUS.AQPA011L L /*DESARROLLO: AQPA011L L */
          WHERE L.AQPA011LNUCON = PN_SERCON
            AND L.AQPA011LESTAD = 1
            AND L.AQPA011LHORA =
                (SELECT MIN(B.AQPA011LHORA)
                   FROM AQPA011L B
                  WHERE B.AQPA011LNUCON = PN_SERCON
                    AND B.AQPA011LESTAD = 1)
            AND ROWNUM = 1;
      EXCEPTION
         WHEN OTHERS THEN
            PN_CODERR := 0;
      END;
   END SP_CR_BUSQUEDA_CONSULTA_BURO;

   PROCEDURE SP_CR_GRABAR_ARCHIVO_CRU(PN_PAIS    IN NUMBER,
                                      PN_TDOC    IN NUMBER,
                                      PN_NDOC    IN VARCHAR2,
                                      PN_NUCON   IN NUMBER,
                                      PV_USER    IN VARCHAR2,
                                      PN_USUC    IN NUMBER,
                                      PV_ARCHIVO IN VARCHAR2,
                                      PV_ERRCRU  IN VARCHAR2,
                                      PV_MSGCRU  IN VARCHAR2,
                                      PN_CODERR  OUT NUMBER) IS
      -- *****************************************************************
      -- NOMBRE                     : SP_CR_BUSQUEDA_CONSULTA_BURO
      -- SISTEMA                    : BANTOTAL
      -- MÓDULO                     : CRÉDITOS - ACTIVAS
      -- VERSIÓN                    : 1.0
      -- FECHA DE CREACIÓN          : 2023.04.03
      -- AUTOR DE CREACIÓN          : ALONSO PACHECO HUACHACA
      -- USO                        : BUSCA DATOS CONSULTA BURO
      -- ESTADO                     : ACTIVO
      -- ACCESO                     : PÚBLICO
      -- PARÁMETROS DE ENTRADA      : PN_PAIS ( PAIS )
      --                              PN_NDOC ( TIPO DE DOCUMENTO )
      --                              PN_NDOC ( NUMERO DE DOCUMENTO )
      --                              PN_NUCON ( NUMERO DE CONSULTA )
      --                              PV_USER ( USUARIO CONSULTA )
      --                              PN_USUC ( SUCURSAL CONSULTA )
      --                              PV_ARCHIVO ( ARCHIVO )
      --                              PV_RUTA ( RUTA )
      -- PARÁMETROS DE SALIDA       : PN_CODERR ( COD ERROR ) (0 / ERROR | 1 / OK)
      -- FECHA DE MODIFICACIÓN      : 
      -- AUTOR DE LA MODIFICACIÓN   : 
      -- DESCRIPCIÓN DE MODIFICACIÓN: 
      -- *****************************************************************   
      L_BFILE BFILE;
      L_BLOB  BLOB;
      N_YEAR  NUMBER(4);
      L_USUC  NUMBER(4);
      V_MSSG  VARCHAR2(150);
   BEGIN
   
      BEGIN
         SELECT EXTRACT(YEAR FROM SYSDATE) INTO N_YEAR FROM DUAL;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   
      /*BEGIN
        SELECT UBSUC
          INTO L_USUC
          FROM FST046
         WHERE UBUSER = RPAD(PV_USER, '10', ' ');
      EXCEPTION
        WHEN OTHERS THEN
          L_USUC := 904;
      END;*/
   
      IF PV_ERRCRU = '00000' OR PV_ERRCRU IS NULL THEN
         BEGIN
            PN_CODERR := 1;
         
            INSERT INTO AQPB942
               (AQPB942NUCON,
                AQPB942ANIO,
                AQPB942FECH,
                AQPB942HORA,
                AQPB942USER,
                AQPB942USUC,
                AQPB942TDOC,
                AQPB942NDOC,
                AQPB942FILE,
                AQPB942BLOB,
                AQPB942CERR,
                AQPB942MERR)
            VALUES
               (PN_NUCON,
                N_YEAR,
                TO_DATE(SYSDATE),
                TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                PV_USER,
                PN_USUC,
                PN_TDOC,
                PN_NDOC,
                PV_ARCHIVO,
                EMPTY_BLOB(),
                1,
                'OK') RETURN AQPB942BLOB INTO L_BLOB;
            L_BFILE := BFILENAME('DT_CRU_EXP_DIG', PV_ARCHIVO);
            DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
            DBMS_LOB.LOADFROMFILE(L_BLOB,
                                  L_BFILE,
                                  DBMS_LOB.GETLENGTH(L_BFILE));
            DBMS_LOB.FILECLOSE(L_BFILE);
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               V_MSSG := SUBSTR(SQLERRM, 1, 150);
               BEGIN
                  INSERT INTO AQPB942
                     (AQPB942NUCON,
                      AQPB942ANIO,
                      AQPB942FECH,
                      AQPB942HORA,
                      AQPB942USER,
                      AQPB942USUC,
                      AQPB942TDOC,
                      AQPB942NDOC,
                      AQPB942FILE,
                      AQPB942BLOB,
                      AQPB942CERR,
                      AQPB942MERR)
                  VALUES
                     (PN_NUCON,
                      N_YEAR,
                      TO_DATE(SYSDATE),
                      TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                      PV_USER,
                      PN_USUC,
                      PN_TDOC,
                      PN_NDOC,
                      PV_ARCHIVO,
                      EMPTY_BLOB(),
                      0,
                      V_MSSG);
                  COMMIT;
               
                  PN_CODERR := 0;
               EXCEPTION
                  WHEN OTHERS THEN
                     PN_CODERR := 0;
               END;
         END;
      ELSE
         BEGIN
            INSERT INTO AQPB942
               (AQPB942NUCON,
                AQPB942ANIO,
                AQPB942FECH,
                AQPB942HORA,
                AQPB942USER,
                AQPB942USUC,
                AQPB942TDOC,
                AQPB942NDOC,
                AQPB942FILE,
                AQPB942BLOB,
                AQPB942CERR,
                AQPB942MERR)
            VALUES
               (PN_NUCON,
                N_YEAR,
                TO_DATE(SYSDATE),
                TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                PV_USER,
                PN_USUC,
                PN_TDOC,
                PN_NDOC,
                PV_ARCHIVO,
                EMPTY_BLOB(),
                0,
                PV_MSGCRU);
            COMMIT;
         
            PN_CODERR := 0;
         EXCEPTION
            WHEN OTHERS THEN
               PN_CODERR := 0;
         END;
      END IF;
   END SP_CR_GRABAR_ARCHIVO_CRU;

   PROCEDURE SP_CR_OBTENER_TIPO_SEGM(P_PAIS      IN NUMBER,
                                     P_TDOC      IN NUMBER,
                                     P_NDOC      IN VARCHAR2,
                                     P_USER      IN VARCHAR2,
                                     P_SEGM_MICR OUT VARCHAR2,
                                     P_SEGM_PYME OUT VARCHAR2,
                                     P_SEGM_CONS OUT VARCHAR2) IS
   
      V_PGFAPE DATE;
      V_N_NULL NUMBER(5);
   
   BEGIN
      BEGIN
         SELECT PGFAPE INTO V_PGFAPE FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_PGFAPE := NULL;
      END;
      BEGIN
         PQ_CR_SEGMENTACION_MICRO_LINEA.SP_CR_NS_LINEA(P_D_FECPRO => V_PGFAPE,
                                                       PN_PAIS    => P_PAIS,
                                                       PN_TDOC    => P_TDOC,
                                                       PC_NDOC    => P_NDOC,
                                                       PC_USR     => P_USER,
                                                       PN_SEGM    => V_N_NULL,
                                                       PV_SEGM    => P_SEGM_MICR);
      EXCEPTION
         WHEN OTHERS THEN
            P_SEGM_MICR := NULL;
      END;
      BEGIN
         PQ_CR_NUEVA_SEGMENTACION_MYPE22.sp_cr_NS_LINEA(P_D_FECPRO => V_PGFAPE,
                                                        PN_PAIS    => P_PAIS,
                                                        PN_TDOC    => P_TDOC,
                                                        PC_NDOC    => P_NDOC,
                                                        PC_USR     => P_USER,
                                                        PN_SEGM    => V_N_NULL,
                                                        PV_SEGM    => P_SEGM_PYME);
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            P_SEGM_PYME := NULL;
      END;
      BEGIN
         PQ_CR_SEGMENTACION_CONSUMO_LINEA.SP_CR_NS_LINEA(P_D_FECPRO => V_PGFAPE,
                                                         PN_PAIS    => P_PAIS,
                                                         PN_TDOC    => P_TDOC,
                                                         PC_NDOC    => P_NDOC,
                                                         PC_USR     => P_USER,
                                                         PN_SEGM    => V_N_NULL,
                                                         PV_SEGM    => P_SEGM_CONS);
      EXCEPTION
         WHEN OTHERS THEN
            P_SEGM_CONS := NULL;
      END;
   END SP_CR_OBTENER_TIPO_SEGM;

   PROCEDURE SP_CR_OBTENER_CALIFICACION(P_PAIS      IN NUMBER,
                                        P_TDOC      IN NUMBER,
                                        P_NDOC      IN VARCHAR2,
                                        PN_CALIF    OUT NUMBER,
                                        PC_CALIF    OUT VARCHAR2,
                                        P_FECHA_ACT OUT DATE) IS
      V_FECHA     DATE;
      V_TDOC_ID   VARCHAR2(1);
      V_CALIF0    NUMBER(5, 2);
      V_CALIF1    NUMBER(5, 2);
      V_CALIF2    NUMBER(5, 2);
      V_CALIF3    NUMBER(5, 2);
      V_CALIF4    NUMBER(5, 2);
      V_CALIF_MAX NUMBER(5, 2);
      V_LONGITUD  NUMBER(10);
      V_CALIF_NOM VARCHAR2(30);
      V_FLAG      VARCHAR2(1);
   
      TYPE ARREGLO IS VARRAY(10) OF NUMBER;
      V_ARREGLO ARREGLO := ARREGLO();
   BEGIN
      BEGIN
         SELECT TO_DATE(TRIM(TO_CHAR(TPNRO)), 'DD/MM/RRRR')
           INTO V_FECHA
           FROM FST098
          WHERE PGCOD = 1
            AND TPCOD = 7647
            AND TPCORR = 12;
      EXCEPTION
         WHEN OTHERS THEN
            V_FECHA := NULL;
      END;
      BEGIN
         SELECT TRIM(TO_CHAR(TP1NRO2))
           INTO V_TDOC_ID
           FROM FST198
          WHERE TP1COD = 1
            AND TP1COD1 = 11111
            AND TP1CORR1 = 1
            AND TP1CORR2 = 5
            AND TP1CORR3 > 0
            AND TP1NRO1 = P_TDOC;
      EXCEPTION
         WHEN OTHERS THEN
            V_TDOC_ID := NULL;
      END;
      BEGIN
         SELECT 'S',
                NVL(N_CALIF0, 0),
                NVL(N_CALIF1, 0),
                NVL(N_CALIF2, 0),
                NVL(N_CALIF3, 0),
                NVL(N_CALIF4, 0)
           INTO V_FLAG, V_CALIF0, V_CALIF1, V_CALIF2, V_CALIF3, V_CALIF4
           FROM CLDRCCI
          WHERE D_FECPRE = V_FECHA
            AND C_TDOCID = V_TDOC_ID
            AND C_DOCIDE = P_NDOC
            AND ROWNUM   = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_FLAG := 'N';
            BEGIN
               SELECT 'S',
                      NVL(N_CALIF0, 0),
                      NVL(N_CALIF1, 0),
                      NVL(N_CALIF2, 0),
                      NVL(N_CALIF3, 0),
                      NVL(N_CALIF4, 0)
                 INTO V_FLAG,
                      V_CALIF0,
                      V_CALIF1,
                      V_CALIF2,
                      V_CALIF3,
                      V_CALIF4
                 FROM CLDRCCI
                WHERE D_FECPRE = V_FECHA
                  AND C_TDOCTR = V_TDOC_ID
                  AND C_DOCTRI = P_NDOC
                  AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  V_FLAG := 'N';
               WHEN OTHERS THEN
                  V_FLAG := NULL;
            END;
         WHEN OTHERS THEN
            V_FLAG := NULL;
      END;
      V_CALIF_MAX := 0;
      V_CALIF_NOM := NULL;
      IF V_FLAG = 'N' OR
         (V_CALIF0 + V_CALIF1 + V_CALIF2 + V_CALIF3 + V_CALIF4) = 0 THEN
         V_CALIF_MAX := 100;
         V_CALIF_NOM := '0.NORMAL';
      ELSE
         V_ARREGLO  := ARREGLO(V_CALIF0,
                               V_CALIF1,
                               V_CALIF2,
                               V_CALIF3,
                               V_CALIF4);
         V_LONGITUD := V_ARREGLO.COUNT;
         FOR I IN 1 .. V_LONGITUD LOOP
            IF V_CALIF_MAX <= V_ARREGLO(I) THEN
               V_CALIF_MAX := V_ARREGLO(I);
               CASE
                  WHEN I = 1 THEN
                     V_CALIF_NOM := '0.NORMAL';
                  WHEN I = 2 THEN
                     V_CALIF_NOM := '1.CPP';
                  WHEN I = 3 THEN
                     V_CALIF_NOM := '2.DEFICIENTE';
                  WHEN I = 4 THEN
                     V_CALIF_NOM := '3.DUDOSA';
                  WHEN I = 5 THEN
                     V_CALIF_NOM := '4.PERDIDA';
                  ELSE
                     V_CALIF_NOM := NULL;
               END CASE;
            END IF;
         END LOOP;
      END IF;
      PN_CALIF    := V_CALIF_MAX;
      PC_CALIF    := V_CALIF_NOM;
      P_FECHA_ACT := V_FECHA;
   END SP_CR_OBTENER_CALIFICACION;

   PROCEDURE SP_CR_OBTENER_SCORE(P_TIPO_DOCUMENTO  IN  NUMBER,
                                 P_NRO_DOCUMENTO   IN  VARCHAR2,
                                 P_USUARIO_EJECUTA IN  VARCHAR2,
                                 P_SEGMENTO_RIESGO OUT VARCHAR2,
                                 P_RIESGO_SCORE    OUT VARCHAR2,
                                 P_TIPO_SCORE      OUT VARCHAR2,
                                 P_PUNTAJE         OUT NUMBER,
                                 P_FECHA_SCORE     OUT DATE) IS
      V_PROGRAMA     VARCHAR2(50);
      V_PROBAL       NUMBER(9, 7);
      V_NUMERO2      NUMBER(5);
      V_TABLA        VARCHAR2(50);
      V_FECHA_SCORE  DATE;
      V_TIPO_SCORE   VARCHAR2(50);
      V_PUNTAJE      NUMBER(9, 2);
      V_RIESGO_SCORE VARCHAR2(50);
   BEGIN
      V_PROGRAMA := 'BTSERVICE CRU';
      BEGIN
         PQ_CR_SCORE_RCC.SP_CR_SCOREDNI(ln_inst       => 0,
                                        ln_tdoc       => P_TIPO_DOCUMENTO,
                                        lc_ndoc       => P_NRO_DOCUMENTO,
                                        lc_prgm       => V_PROGRAMA,
                                        lc_user       => P_USUARIO_EJECUTA,
                                        lc_score      => V_RIESGO_SCORE,
                                        ln_probal     => V_PROBAL,
                                        lc_SegmRiesgo => P_SEGMENTO_RIESGO,
                                        ln_PDCal      => V_NUMERO2,
                                        lc_tabla      => V_TABLA,
                                        ld_fchscore   => V_FECHA_SCORE);
      EXCEPTION
         WHEN OTHERS THEN
            P_SEGMENTO_RIESGO := NULL;
      END;
      V_TIPO_SCORE := 'CLIENTE NUEVO';
      IF V_TABLA = 'JAQL640' AND (V_PROBAL != 0 AND V_PROBAL != 1 AND V_PROBAL != 1000) THEN
         V_PUNTAJE    := TRUNC((LN((1 - V_PROBAL) / V_PROBAL)) * 77 / LN(2.3) + 350);
         V_TIPO_SCORE := 'CLIENTE DE CAJA AREQUIPA';
      ELSIF V_TABLA = 'JAQL639' AND (V_PROBAL != 0 AND V_PROBAL != 1 AND V_PROBAL != 1000) THEN
         V_PUNTAJE := TRUNC((LN((1 - V_PROBAL) / V_PROBAL)) * 91 / LN(1.7) + 190);
      END IF;  
      IF V_PROBAL = 1 THEN
         V_PUNTAJE := 0;
      ELSIF V_PROBAL = 0 THEN
         V_PUNTAJE := 982;
      END IF;  
      IF V_PUNTAJE < 122 THEN
         V_PUNTAJE := 122;
      ELSIF V_PUNTAJE > 982 THEN
         V_PUNTAJE := 982;
      END IF;
      IF V_RIESGO_SCORE = 'SIN SCORE' THEN
         V_PUNTAJE := 0.00;
      END IF;
      P_RIESGO_SCORE := TRIM(V_RIESGO_SCORE);
      P_PUNTAJE      := V_PUNTAJE;
      P_TIPO_SCORE   := TRIM(V_TIPO_SCORE);
      P_FECHA_SCORE  := V_FECHA_SCORE;
   END SP_CR_OBTENER_SCORE;
   
   PROCEDURE SP_CR_OBTENER_SCORE_SMS(P_TIPO_DOCUMENTO  IN  NUMBER,
                                     P_NRO_DOCUMENTO   IN  VARCHAR2,
                                     P_USUARIO_EJECUTA IN  VARCHAR2,
                                     P_SEGMENTO_RIESGO OUT VARCHAR2,
                                     P_RIESGO_SCORE    OUT VARCHAR2,
                                     P_TIPO_SCORE      OUT VARCHAR2,
                                     P_PUNTAJE         OUT NUMBER,
                                     P_FECHA_SCORE     OUT DATE) IS
      V_PROGRAMA        VARCHAR2(50);
      V_PROBAL          NUMBER(9, 7);
      V_NUMERO2         NUMBER(5);
      V_TABLA           VARCHAR2(50);
      V_FECHA_SCORE     DATE;
      V_TIPO_SCORE      VARCHAR2(50);
      V_PUNTAJE         NUMBER(9, 2);
      V_RIESGO_SCORE    VARCHAR2(50);
      V_SEGMENTO_RIESGO VARCHAR2(10);
   BEGIN
      V_PROGRAMA := 'BTSERVICE SMS';
      BEGIN
         PQ_CR_SCORE_RCC.SP_CR_SCOREDNI(ln_inst       => 0,
                                        ln_tdoc       => P_TIPO_DOCUMENTO,
                                        lc_ndoc       => P_NRO_DOCUMENTO,
                                        lc_prgm       => V_PROGRAMA,
                                        lc_user       => P_USUARIO_EJECUTA,
                                        lc_score      => V_RIESGO_SCORE,
                                        ln_probal     => V_PROBAL,
                                        lc_SegmRiesgo => V_SEGMENTO_RIESGO,
                                        ln_PDCal      => V_NUMERO2,
                                        lc_tabla      => V_TABLA,
                                        ld_fchscore   => V_FECHA_SCORE);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      V_TIPO_SCORE := 'CLIENTE NUEVO';
      IF V_TABLA = 'JAQL640' AND (V_PROBAL != 0 AND V_PROBAL != 1 AND V_PROBAL != 1000) THEN
         V_PUNTAJE    := TRUNC((LN((1 - V_PROBAL) / V_PROBAL)) * 77 / LN(2.3) + 350);
         V_TIPO_SCORE := 'CLIENTE DE CAJA AREQUIPA';
      ELSIF V_TABLA = 'JAQL639' AND (V_PROBAL != 0 AND V_PROBAL != 1 AND V_PROBAL != 1000) THEN
         V_PUNTAJE := TRUNC((LN((1 - V_PROBAL) / V_PROBAL)) * 91 / LN(1.7) + 190);
      END IF;  
      IF V_PROBAL = 1 THEN
         V_PUNTAJE := 0;
      ELSIF V_PROBAL = 0 THEN
         V_PUNTAJE := 982;
      END IF;  
      IF V_PUNTAJE < 122 THEN
         V_PUNTAJE := 122;
      ELSIF V_PUNTAJE > 982 THEN
         V_PUNTAJE := 982;
      END IF;
      IF V_RIESGO_SCORE = 'SIN SCORE' THEN
         V_PUNTAJE := 0.00;
      END IF;
      P_RIESGO_SCORE    := TRIM(V_RIESGO_SCORE);
      P_PUNTAJE         := V_PUNTAJE;
      P_TIPO_SCORE      := TRIM(V_TIPO_SCORE);
      P_FECHA_SCORE     := V_FECHA_SCORE;
      P_SEGMENTO_RIESGO := V_SEGMENTO_RIESGO;
   END SP_CR_OBTENER_SCORE_SMS;

   PROCEDURE SP_OBTENER_PEOR_CALIFICACION(P_PAIS   IN NUMBER,
                                          P_TDOC   IN NUMBER,
                                          P_NDOC   IN VARCHAR2,
                                          PN_CALIF OUT NUMBER,
                                          PC_CALIF OUT VARCHAR2) IS
      V_FECHA            DATE;
      V_TDOC_ID          VARCHAR(1);
      V_FLAG             VARCHAR2(1);
      V_CALIF0           NUMBER(5, 2);
      V_CALIF1           NUMBER(5, 2);
      V_CALIF2           NUMBER(5, 2);
      V_CALIF3           NUMBER(5, 2);
      V_CALIF4           NUMBER(5, 2);
      V_PORCENTAJE_CALIF NUMBER(5, 2);
      V_DESCR_CALIF      VARCHAR2(30);
      V_LONGITUD         NUMBER(10);
   
      TYPE ARREGLO IS VARRAY(10) OF NUMBER;
      V_ARREGLO ARREGLO := ARREGLO();
   BEGIN
      BEGIN
         SELECT TO_DATE(TRIM(TO_CHAR(TPNRO)), 'DD/MM/RRRR')
           INTO V_FECHA
           FROM FST098
          WHERE PGCOD = 1
            AND TPCOD = 7647
            AND TPCORR = 12;
      EXCEPTION
         WHEN OTHERS THEN
            V_FECHA := NULL;
      END;
      BEGIN
         SELECT TRIM(TO_CHAR(TP1NRO2))
           INTO V_TDOC_ID
           FROM FST198
          WHERE TP1COD = 1
            AND TP1COD1 = 11111
            AND TP1CORR1 = 1
            AND TP1CORR2 = 5
            AND TP1CORR3 > 0
            AND TP1NRO1 = P_TDOC;
      EXCEPTION
         WHEN OTHERS THEN
            V_TDOC_ID := NULL;
      END;
      BEGIN
         SELECT 'S',
                NVL(N_CALIF0, 0),
                NVL(N_CALIF1, 0),
                NVL(N_CALIF2, 0),
                NVL(N_CALIF3, 0),
                NVL(N_CALIF4, 0)
           INTO V_FLAG, V_CALIF0, V_CALIF1, V_CALIF2, V_CALIF3, V_CALIF4
           FROM CLDRCCI
          WHERE D_FECPRE = V_FECHA
            AND C_TDOCID = V_TDOC_ID
            AND C_DOCIDE = P_NDOC
            AND ROWNUM   = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_FLAG := 'N';
            BEGIN
               SELECT 'S',
                      NVL(N_CALIF0, 0),
                      NVL(N_CALIF1, 0),
                      NVL(N_CALIF2, 0),
                      NVL(N_CALIF3, 0),
                      NVL(N_CALIF4, 0)
                 INTO V_FLAG,
                      V_CALIF0,
                      V_CALIF1,
                      V_CALIF2,
                      V_CALIF3,
                      V_CALIF4
                 FROM CLDRCCI
                WHERE D_FECPRE = V_FECHA
                  AND C_TDOCTR = V_TDOC_ID
                  AND C_DOCTRI = P_NDOC
                  AND ROWNUM   = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  V_FLAG := 'N';
               WHEN OTHERS THEN
                  V_FLAG := NULL;
            END;
         WHEN OTHERS THEN
            V_FLAG := NULL;
      END;
      V_PORCENTAJE_CALIF := 0;
      V_DESCR_CALIF      := NULL;
      IF V_FLAG = 'N' OR
         (V_CALIF0 + V_CALIF1 + V_CALIF2 + V_CALIF3 + V_CALIF4) = 0 THEN
         V_PORCENTAJE_CALIF := 100;
         V_DESCR_CALIF      := '0.NORMAL';
      ELSE
         V_ARREGLO  := ARREGLO(V_CALIF4,
                               V_CALIF3,
                               V_CALIF2,
                               V_CALIF1,
                               V_CALIF0);
         V_LONGITUD := V_ARREGLO.COUNT;
         FOR I IN 1 .. V_LONGITUD LOOP
            IF V_ARREGLO(I) <> 0 THEN
               V_PORCENTAJE_CALIF := V_ARREGLO(I);
               CASE
                  WHEN I = 1 THEN
                     V_DESCR_CALIF := '4.PERDIDA';
                  WHEN I = 2 THEN
                     V_DESCR_CALIF := '3.DUDOSA';
                  WHEN I = 3 THEN
                     V_DESCR_CALIF := '2.DEFICIENTE';
                  WHEN I = 4 THEN
                     V_DESCR_CALIF := '1.CPP';
                  WHEN I = 5 THEN
                     V_DESCR_CALIF := '0.NORMAL';
                  ELSE
                     V_DESCR_CALIF := NULL;
               END CASE;
               EXIT;
            END IF;
         END LOOP;
      END IF;
      PN_CALIF := V_PORCENTAJE_CALIF;
      PC_CALIF := V_DESCR_CALIF;
   END SP_OBTENER_PEOR_CALIFICACION;
   
   PROCEDURE SP_CR_GRABAR_LOG(P_PAIS                    IN NUMBER,
                              P_TIPO_DOCUMENTO          IN NUMBER,
                              P_NRO_DOCUMENTO           IN VARCHAR2,
                              P_SUCURSAL                IN NUMBER,
                              P_CALIFICACION            IN VARCHAR2,
                              P_SERIAL_CONEXION         IN NUMBER,
                              P_SERIAL_BURO             IN NUMBER,
                              P_BURO                    IN NUMBER,
                              P_CORRELATIVO             IN NUMBER,
                              P_SEGMENTO_MICRO          IN VARCHAR2,
                              P_SEGMENTO_MYPE           IN VARCHAR2,
                              P_SEGMENTO_CONSUMO        IN VARCHAR2,                              
                              P_PORCENTAJE_CALIFICACION IN NUMBER,
                              P_ULTIMA_CALIFICACION    IN VARCHAR2,
                              P_SEGMENTO_RIESGO         IN VARCHAR2,
                              P_FECHA_ACTUALIZACION     IN DATE,
                              P_TIPO_SCORE              IN VARCHAR2,
                              P_PUNTAJE                 IN NUMBER,
                              P_RIESGO_SCORE            IN VARCHAR2,
                              P_FECHA_SCORE_ULTIMA      IN DATE,
                              P_CODIGO_ERROR            IN VARCHAR2,
                              P_MENSAJE_ERROR           IN VARCHAR2,
                              P_USUARIO_EJECUCION       IN VARCHAR2,
                              P_ORIGEN                  IN NUMBER) IS
      V_FECHA_SISTEMA DATE;
      V_HORA_SISTEMA  VARCHAR2(8);
   BEGIN      
      BEGIN
         SELECT PGFAPE INTO V_FECHA_SISTEMA FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_FECHA_SISTEMA := NULL;
      END;
      V_HORA_SISTEMA := TO_CHAR(SYSDATE(), 'HH24:MI:SS');
      BEGIN
         INSERT INTO AQPC275
            (AQPC275PAIS,
             AQPC275TDOC,
             AQPC275NDOC,
             AQPC275SUC,
             AQPC275PCLF,
             AQPC275SRCN,
             AQPC275SRBR,
             AQPC275BURO,
             AQPC275CPCF,
             AQPC275SEGMI,
             AQPC275SEGMY,
             AQPC275SEGCS,
             AQPC275PRCLF,
             AQPC275ULCLF,
             AQPC275SEGRG,
             AQPC275FHACT,
             AQPC275TPSCR,
             AQPC275PUNTJ,
             AQPC275RSSCR,
             AQPC275FHSCU,
             AQPC275CERR,
             AQPC275MSGE,
             AQPC275FPRC,
             AQPC275HPRC,
             AQPC275USU,
             AQPC275ORIG)
         VALUES
            (P_PAIS,
             P_TIPO_DOCUMENTO,
             P_NRO_DOCUMENTO,
             P_SUCURSAL,
             P_CALIFICACION,
             P_SERIAL_CONEXION,
             P_SERIAL_BURO,
             P_BURO,
             P_CORRELATIVO,
             P_SEGMENTO_MICRO,
             P_SEGMENTO_MYPE,
             P_SEGMENTO_CONSUMO,
             P_PORCENTAJE_CALIFICACION,
             P_ULTIMA_CALIFICACION,
             P_SEGMENTO_RIESGO,
             P_FECHA_ACTUALIZACION,
             P_TIPO_SCORE,
             P_PUNTAJE,
             P_RIESGO_SCORE,
             P_FECHA_SCORE_ULTIMA,
             P_CODIGO_ERROR,
             P_MENSAJE_ERROR,
             V_FECHA_SISTEMA,
             V_HORA_SISTEMA,
             P_USUARIO_EJECUCION,
             P_ORIGEN);
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            BEGIN
               INSERT INTO AQPC275
                  (AQPC275PAIS,
                   AQPC275TDOC,
                   AQPC275NDOC,
                   AQPC275FPRC,
                   AQPC275HPRC,
                   AQPC275USU)
               VALUES
                  (P_PAIS,
                   P_TIPO_DOCUMENTO,
                   P_NRO_DOCUMENTO,
                   V_FECHA_SISTEMA,
                   V_HORA_SISTEMA,
                   P_USUARIO_EJECUCION);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
      END;
   END SP_CR_GRABAR_LOG;
   
   PROCEDURE SP_CR_GRABAR_LOG_2(P_PAIS                    IN NUMBER,
                                P_TIPO_DOCUMENTO          IN NUMBER,
                                P_NRO_DOCUMENTO           IN VARCHAR2,
                                P_SUCURSAL                IN NUMBER,
                                P_CALIFICACION            IN VARCHAR2,
                                P_SERIAL_CONEXION         IN NUMBER,
                                P_SERIAL_BURO             IN NUMBER,
                                P_BURO                    IN NUMBER,
                                P_CORRELATIVO             IN NUMBER,
                                P_SEGMENTO_MICRO          IN VARCHAR2,
                                P_SEGMENTO_MYPE           IN VARCHAR2,
                                P_SEGMENTO_CONSUMO        IN VARCHAR2,
                                P_PORCENTAJE_CALIFICACION IN NUMBER,
                                P_ULTIMA_ACTUALIZACION    IN VARCHAR2,
                                P_SEGMENTO_RIESGO         IN VARCHAR2,
                                P_FECHA_ACTUALIZACION     IN DATE,
                                P_TIPO_SCORE              IN VARCHAR2,
                                P_PUNTAJE                 IN NUMBER,
                                P_RIESGO_SCORE            IN VARCHAR2,
                                P_FECHA_SCORE_ULTIMA      IN DATE,
                                P_NOMBRE_CLIENTE          IN VARCHAR2,
                                P_EDAD_CLIENTE            IN NUMBER,
                                P_CANT_TIPO_LISTA         IN NUMBER,
                                P_NRO_ENTIDADES           IN NUMBER,
                                P_CODIGO_ERROR            IN VARCHAR2,
                                P_MENSAJE_ERROR           IN VARCHAR2,
                                P_USUARIO_EJECUCION       IN VARCHAR2,
                                P_ORIGEN                  IN NUMBER) IS
      V_FECHA_SISTEMA DATE;
      V_HORA_SISTEMA  VARCHAR2(8);
   BEGIN      
      BEGIN
         SELECT PGFAPE INTO V_FECHA_SISTEMA FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_FECHA_SISTEMA := NULL;
      END;
      V_HORA_SISTEMA := TO_CHAR(SYSDATE(), 'HH24:MI:SS');
      BEGIN
         INSERT INTO AQPC275
            (AQPC275PAIS,
             AQPC275TDOC,
             AQPC275NDOC,
             AQPC275SUC,
             AQPC275PCLF,
             AQPC275SRCN,
             AQPC275SRBR,
             AQPC275BURO,
             AQPC275CPCF,
             AQPC275SEGMI,
             AQPC275SEGMY,
             AQPC275SEGCS,
             AQPC275PRCLF,
             AQPC275ULCLF,
             AQPC275SEGRG,
             AQPC275FHACT,
             AQPC275TPSCR,
             AQPC275PUNTJ,
             AQPC275RSSCR,
             AQPC275FHSCU,
             AQPC275NOMCLI,
             AQPC275EDADCL,
             AQPC275CANTLS,
             AQPC275NROENT,
             AQPC275CERR,
             AQPC275MSGE,
             AQPC275FPRC,
             AQPC275HPRC,
             AQPC275USU,
             AQPC275ORIG)
         VALUES
            (P_PAIS,
             P_TIPO_DOCUMENTO,
             P_NRO_DOCUMENTO,
             P_SUCURSAL,
             P_CALIFICACION,
             P_SERIAL_CONEXION,
             P_SERIAL_BURO,
             P_BURO,
             P_CORRELATIVO,
             P_SEGMENTO_MICRO,
             P_SEGMENTO_MYPE,
             P_SEGMENTO_CONSUMO,
             P_PORCENTAJE_CALIFICACION,
             P_ULTIMA_ACTUALIZACION,
             P_SEGMENTO_RIESGO,
             P_FECHA_ACTUALIZACION,
             P_TIPO_SCORE,
             P_PUNTAJE,
             P_RIESGO_SCORE,
             P_FECHA_SCORE_ULTIMA,
             P_NOMBRE_CLIENTE,
             P_EDAD_CLIENTE,
             P_CANT_TIPO_LISTA,
             P_NRO_ENTIDADES,
             P_CODIGO_ERROR,
             P_MENSAJE_ERROR,
             V_FECHA_SISTEMA,
             V_HORA_SISTEMA,
             P_USUARIO_EJECUCION,
             P_ORIGEN);
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            BEGIN
               INSERT INTO AQPC275
                  (AQPC275PAIS,
                   AQPC275TDOC,
                   AQPC275NDOC,
                   AQPC275FPRC,
                   AQPC275HPRC,
                   AQPC275USU)
               VALUES
                  (P_PAIS,
                   P_TIPO_DOCUMENTO,
                   P_NRO_DOCUMENTO,
                   V_FECHA_SISTEMA,
                   V_HORA_SISTEMA,
                   P_USUARIO_EJECUCION);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
      END;
   END SP_CR_GRABAR_LOG_2;
   
   PROCEDURE SP_CR_OBTENER_DATOS_PRECALIF(PN_PAIS_DOCUMENTO  IN  NUMBER,
                                          PN_TIPO_DOCUMENTO  IN  NUMBER,
                                          PV_NRO_DOCUMENTO   IN  VARCHAR2,
                                          PV_NOMBRE_CLIENTE  OUT VARCHAR2,
                                          PN_EDAD_CLIENTE    OUT NUMBER,
                                          PN_CANT_TIPO_LISTA OUT NUMBER,
                                          PN_NRO_ENTIDADES   OUT NUMBER) IS
      
   -- ====================================================================================================
   -- NOMBRE                      : SP_CR_OBTENER_DATOS_PRECALIF
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 27/02/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA LOS SIGUIENTES DATOS: NOMBRE CLIENTE, EDAD CLIENTE,
   --                               CANTIDAD TIPO LISTAS Y NRO. ENTIDADES
   -- PARAMETROS                  : PN_PAIS_DOCUMENTO  | NUMBER(3)
   --                               PN_TIPO_DOCUMENTO  | NUMBER(2)
   --                               PV_NRO_DOCUMENTO   | VARCHAR2(12)
   --                               PV_NOMBRE_CLIENTE  | VARCHAR2(100)
   --                               PN_EDAD_CLIENTE    | NUMBER(3)
   --                               PN_CANT_TIPO_LISTA | NUMBER(2)
   --                               PN_NRO_ENTIDADES   | NUMBER(10)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -- ====================================================================================================
   -- FECHA DE MODIFICACION       : 22/11/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE REEMPLAZO LA LECTURA DE LA TABLA RCC POR
   --                               LA TABLA AQPC572 PARA OBTENER EL NOMBRE DEL 
   --                               CLIENTE
   -- ====================================================================================================
   
      FECHA_SISTEMA      DATE;
      NOMBRE_CLIENTE     VARCHAR2(100);
      EDAD_CLIENTE       NUMBER(3);
      CANT_TIPO_LISTA    NUMBER(2);
      NRO_ENTIDADES      NUMBER(10);
      LIMITE_RCC         NUMBER(4);
      FECHA_RCC          DATE;
      TIPO_DOCUMENTO_RCC VARCHAR2(1);
      EXISTE_PERSONA     VARCHAR2(1);
      EXISTE_RUC         VARCHAR2(1);
      CONTADOR           NUMBER(9);
      EXISTE_JAQY490S    VARCHAR2(1);
      
   BEGIN
      FECHA_SISTEMA := NULL;
      BEGIN
         SELECT PGFAPE
           INTO FECHA_SISTEMA
           FROM FST017
          WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      LIMITE_RCC := 0;
      BEGIN
         SELECT TPNRO
           INTO LIMITE_RCC
           FROM FST098
          WHERE PGCOD  = 1
            AND TPCOD  = 7752
            AND TPCORR = 6;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            LIMITE_RCC := 12;
         WHEN OTHERS THEN
            NULL;
      END;
      
      FECHA_RCC := NULL;
      BEGIN
         SELECT TO_DATE(TPNRO, 'DD/MM/RRRR')
           INTO FECHA_RCC
           FROM FST098
          WHERE PGCOD  = 1
            AND TPCOD  = 7647
            AND TPCORR = 12;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      TIPO_DOCUMENTO_RCC := NULL;
      BEGIN
         SELECT TP1NRO2
           INTO TIPO_DOCUMENTO_RCC
           FROM FST198
          WHERE TP1COD   = 1
            AND TP1COD1  = 11111
            AND TP1CORR1 = 1
            AND TP1CORR2 = 5
            AND TP1NRO1  = PN_TIPO_DOCUMENTO;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      EDAD_CLIENTE := 0;
      BEGIN
         SELECT FLOOR(MONTHS_BETWEEN(FECHA_SISTEMA, PFFNAC) / 12)
           INTO EDAD_CLIENTE
           FROM FSD002
          WHERE PFPAIS = PN_PAIS_DOCUMENTO
            AND PFTDOC = PN_TIPO_DOCUMENTO
            AND PFNDOC = RPAD(PV_NRO_DOCUMENTO, 12, ' ');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT FLOOR(MONTHS_BETWEEN(FECHA_SISTEMA, SNGC11DAT1) / 12)
                 INTO EDAD_CLIENTE
                 FROM SNGC11
                WHERE SNGC11PAIS = PN_PAIS_DOCUMENTO
                  AND SNGC11TDOC = PN_TIPO_DOCUMENTO
                  AND SNGC11NDOC = RPAD(PV_NRO_DOCUMENTO, 12, ' ');
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN OTHERS THEN
            NULL;
      END;
      
      CANT_TIPO_LISTA := 0;
      BEGIN
         SELECT COUNT(*)
           INTO CANT_TIPO_LISTA
           FROM FSD201 A, FST501 B
          WHERE A.LNPAIS = PN_PAIS_DOCUMENTO
            AND A.LNTDOC = PN_TIPO_DOCUMENTO
            AND A.LNNDOC = RPAD(PV_NRO_DOCUMENTO, 25, ' ')
            AND B.TLIS   = A.TLIS;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      IF PN_TIPO_DOCUMENTO <> 9 THEN
         
         EXISTE_JAQY490S := 'N';
         BEGIN
            SELECT 'S'
               INTO EXISTE_JAQY490S
               FROM JAQY490S
             WHERE JAQY490PAI = PN_PAIS_DOCUMENTO
               AND JAQY490TDO = PN_TIPO_DOCUMENTO
               AND JAQY490NDO = RPAD(PV_NRO_DOCUMENTO, 12, ' ')
               AND JAQY490FEC = (SELECT MAX(JAQY490FEC) FROM JAQY490S);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NRO_ENTIDADES := 0;
         IF EXISTE_JAQY490S = 'N' THEN
            BEGIN
               SELECT N_CANENT
                 INTO NRO_ENTIDADES
                 FROM CLDRCCI
                WHERE D_FECPRE = FECHA_RCC
                  AND C_TDOCID = TIPO_DOCUMENTO_RCC
                  AND C_DOCIDE = PV_NRO_DOCUMENTO
                  AND ROWNUM   = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  DBMS_OUTPUT.PUT_LINE(SQLERRM);
            END;
         ELSE
            BEGIN
               SELECT NVL(JAQY490NEN, 0)
                 INTO NRO_ENTIDADES
                 FROM JAQY490
                WHERE JAQY490NDI = PV_NRO_DOCUMENTO
                  AND JAQY490FEC = (SELECT MAX(JAQY490FEC) FROM JAQY490)
                  AND JAQY490PER = 1
                  AND JAQY490TDI = 1
                  AND JAQY490SBS = (SELECT MAX(JAQY490SBS)
                                      FROM JAQY490
                                     WHERE JAQY490NDI = PV_NRO_DOCUMENTO);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  NRO_ENTIDADES := 0;
                  BEGIN
                     SELECT NVL(JAQY490NEN, 0)
                       INTO NRO_ENTIDADES
                       FROM JAQY490
                      WHERE JAQY490NDI = PV_NRO_DOCUMENTO
                        AND JAQY490FEC = (SELECT MAX(JAQY490FEC) FROM JAQY490);
                  EXCEPTION
                     WHEN OTHERS THEN
                        NULL;
                  END;
               WHEN OTHERS THEN
                  NULL;
            END;
         END IF;
         
         NOMBRE_CLIENTE := NULL;
         BEGIN
            SELECT TRIM(A1.AQPC572NOMBR)
              INTO NOMBRE_CLIENTE
              FROM AQPC572 A1
             WHERE A1.AQPC572TIDOB = PN_TIPO_DOCUMENTO
               AND A1.AQPC572NUDOC = RPAD(PV_NRO_DOCUMENTO, 12, ' ')
               AND A1.AQPC572FEENV = (SELECT MAX(A2.AQPC572FEENV)
                                        FROM AQPC572 A2
                                       WHERE A2.AQPC572TIDOB = A1.AQPC572TIDOB
                                         AND A2.AQPC572NUDOC = A1.AQPC572NUDOC)
               AND A1.AQPC572HOENV = (SELECT MAX(A3.AQPC572HOENV)
                                        FROM AQPC572 A3
                                       WHERE A3.AQPC572TIDOB = A1.AQPC572TIDOB
                                         AND A3.AQPC572NUDOC = A1.AQPC572NUDOC
                                         AND A3.AQPC572FEENV = A1.AQPC572FEENV);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               BEGIN
                  SELECT TRIM(PENOM)
                    INTO NOMBRE_CLIENTE
                    FROM FSD001
                   WHERE PEPAIS = PN_PAIS_DOCUMENTO
                     AND PETDOC = PN_TIPO_DOCUMENTO
                     AND PENDOC = RPAD(PV_NRO_DOCUMENTO, 12, ' ');
               EXCEPTION 
                  WHEN OTHERS THEN
                     NULL;
               END;
            WHEN OTHERS THEN
               NULL;
         END;       
      ELSE
         EXISTE_JAQY490S := 'N';
         BEGIN
            SELECT 'S'
               INTO EXISTE_JAQY490S
               FROM JAQY490S
             WHERE JAQY490PAI = PN_PAIS_DOCUMENTO
               AND JAQY490TDO = PN_TIPO_DOCUMENTO
               AND JAQY490NDO = RPAD(PV_NRO_DOCUMENTO, 12, ' ')
               AND JAQY490FEC = (SELECT MAX(JAQY490FEC) FROM JAQY490S);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NRO_ENTIDADES := 0;
         IF EXISTE_JAQY490S = 'N' THEN
            BEGIN
               SELECT N_CANENT
                 INTO NRO_ENTIDADES
                 FROM CLDRCCI
                WHERE D_FECPRE = FECHA_RCC
                  AND C_TDOCTR = TIPO_DOCUMENTO_RCC
                  AND C_DOCTRI = PV_NRO_DOCUMENTO
                  AND ROWNUM   = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         ELSE
            BEGIN
               SELECT NVL(JAQY490NEN, 0)
                 INTO NRO_ENTIDADES
                 FROM JAQY490
                WHERE JAQY490NDT = PV_NRO_DOCUMENTO
                  AND JAQY490FEC = (SELECT MAX(JAQY490FEC) FROM JAQY490)
                  AND JAQY490TDI = 2;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END IF;
         
         NOMBRE_CLIENTE := NULL;
         BEGIN
            SELECT TRIM(A1.AQPC572NOMBR)
              INTO NOMBRE_CLIENTE
              FROM AQPC572 A1
             WHERE A1.AQPC572TIDOB = PN_TIPO_DOCUMENTO
               AND A1.AQPC572NUDOC = RPAD(PV_NRO_DOCUMENTO, 12, ' ')
               AND A1.AQPC572FEENV = (SELECT MAX(A2.AQPC572FEENV)
                                        FROM AQPC572 A2
                                       WHERE A2.AQPC572TIDOB = A1.AQPC572TIDOB
                                         AND A2.AQPC572NUDOC = A1.AQPC572NUDOC)
               AND A1.AQPC572HOENV = (SELECT MAX(A3.AQPC572HOENV)
                                        FROM AQPC572 A3
                                       WHERE A3.AQPC572TIDOB = A1.AQPC572TIDOB
                                         AND A3.AQPC572NUDOC = A1.AQPC572NUDOC
                                         AND A3.AQPC572FEENV = A1.AQPC572FEENV);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               BEGIN
                  SELECT TRIM(PJRAZS)
                    INTO NOMBRE_CLIENTE
                    FROM FSD003
                   WHERE PJPAIS = PN_PAIS_DOCUMENTO
                     AND PJTDOC = PN_TIPO_DOCUMENTO
                     AND PJNDOC = RPAD(PV_NRO_DOCUMENTO, 12, ' ');
               EXCEPTION 
                  WHEN OTHERS THEN
                     NULL;
               END;
            WHEN OTHERS THEN
               NULL;
         END;
      END IF;
      
      PV_NOMBRE_CLIENTE  := NULL;
      PN_EDAD_CLIENTE    := 0;
      PN_CANT_TIPO_LISTA := 0;
      PN_NRO_ENTIDADES   := 0;
      
      PV_NOMBRE_CLIENTE  := NOMBRE_CLIENTE;
      PN_EDAD_CLIENTE    := EDAD_CLIENTE;
      PN_CANT_TIPO_LISTA := CANT_TIPO_LISTA;
      PN_NRO_ENTIDADES   := NRO_ENTIDADES;
      
   END SP_CR_OBTENER_DATOS_PRECALIF;
   
   PROCEDURE SP_CR_OBTENER_SCORE_2(PN_PAIS_DOCUMENTO IN  NUMBER,
                                   PN_TIPO_DOCUMENTO IN  NUMBER,
                                   PV_DOCUMENTO      IN  VARCHAR2,
                                   PV_USUARIO        IN  VARCHAR2,
                                   PV_SCORE_CLIENTE  OUT VARCHAR2,
                                   PV_DESC_PRECALIF  OUT VARCHAR2,
                                   PV_NOMBRE_CLIENTE OUT VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_SCORE_2
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 29/04/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA LOS SIGUIENTES DATOS:
   --                               - SCORE CLIENTE
   --                               - DESCRIPCION PRECALIFICACION
   --                               - NOMBRE CLIENTE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      SEGMENTO      VARCHAR2(10);
      TABLA         VARCHAR2(15);
      NIVEL_RIESGO  VARCHAR2(100);
      TIPO_SCORE    VARCHAR2(30);
      PROGRAMA      VARCHAR2(10);
      PROBALIDAD    NUMBER(8, 7);
      PDCAL         NUMBER(8, 7);
      EDAD_CLIENTE  NUMBER(3);
      CANTIDAD_LNG  NUMBER(2);
      NRO_ENTIDADES NUMBER(10);
      FECHA_SCORE   DATE;                                 
   BEGIN
      PROGRAMA         := 'PAQPD417';
      SEGMENTO         := NULL;
      TABLA            := NULL;
      NIVEL_RIESGO     := NULL;
      TIPO_SCORE       := NULL;
      PROBALIDAD       := 0;
      PDCAL            := 0;
      FECHA_SCORE      := NULL;
      PV_SCORE_CLIENTE := NULL;
      BEGIN
         PQ_CR_SCORE_RCC.SP_CR_SCOREDNI_II(LN_INST       => 0,
                                           LN_TDOC       => PN_TIPO_DOCUMENTO,
                                           LC_NDOC       => PV_DOCUMENTO,
                                           LC_PRGM       => PROGRAMA,
                                           LC_USER       => PV_USUARIO,
                                           LC_SCORE      => NIVEL_RIESGO,
                                           LN_PROBAL     => PROBALIDAD,
                                           LC_SEGMRIESGO => SEGMENTO,
                                           LN_PDCAL      => PDCAL,
                                           LC_TABLA      => TABLA,
                                           LD_FCHSCORE   => FECHA_SCORE,
                                           LC_SCOREABR   => PV_SCORE_CLIENTE,
                                           LC_NEWSCORE   => TIPO_SCORE);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      PV_DESC_PRECALIF := NULL;
      BEGIN
         SELECT TRIM(A.TP1DESC)
           INTO PV_DESC_PRECALIF
           FROM FST198 A
          WHERE A.TP1COD   = 1
            AND A.TP1COD1  = 111154
            AND A.TP1CORR1 = 1
            AND A.TP1CORR2 = 32
            AND A.TP1CORR3 > 0
            AND A.TP1NRO1  = 1
            AND A.TP1NRO3  = (SELECT A1.TP1NRO3
                                FROM FST198 A1
                               WHERE A1.TP1COD   = 1
                                 AND A1.TP1COD1  = 111154
                                 AND A1.TP1CORR1 = 1
                                 AND A1.TP1CORR2 = 31
                                 AND A1.TP1CORR3 > 0
                                 AND A1.TP1NRO1  = 1
                                 AND A1.TP1DESC  = RPAD(TRIM(UPPER(PV_SCORE_CLIENTE)), 30, ' '));
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      PV_NOMBRE_CLIENTE := NULL;
      EDAD_CLIENTE      := 0;
      CANTIDAD_LNG      := 0;
      NRO_ENTIDADES     := 0;
      BEGIN
         SP_CR_OBTENER_DATOS_PRECALIF(PN_PAIS_DOCUMENTO  => PN_PAIS_DOCUMENTO,
                                      PN_TIPO_DOCUMENTO  => PN_TIPO_DOCUMENTO,
                                      PV_NRO_DOCUMENTO   => PV_DOCUMENTO,
                                      PV_NOMBRE_CLIENTE  => PV_NOMBRE_CLIENTE,
                                      PN_EDAD_CLIENTE    => EDAD_CLIENTE,
                                      PN_CANT_TIPO_LISTA => CANTIDAD_LNG,
                                      PN_NRO_ENTIDADES   => NRO_ENTIDADES);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_OBTENER_SCORE_2;
   
   PROCEDURE SP_CR_GRABAR_LOG_MAX_CONSULTAS(PN_PAIS_DOCUMENTO  IN NUMBER,
                                            PN_TIPO_DOCUMENTO  IN NUMBER,
                                            PV_DOCUMENTO       IN VARCHAR2,
                                            PV_USUARIO         IN VARCHAR2,
                                            PV_NOMBRE_CLIENTE  IN VARCHAR2,
                                            PV_SCORE_CLIENTE   IN VARCHAR2,
                                            PV_DESC_PRECALIF   IN VARCHAR2,
                                            PN_CORR_PRECALIF   IN NUMBER,
                                            PV_PRECALIFICACION IN VARCHAR2,
                                            PN_SERIAL_CONEXION IN NUMBER,
                                            PV_CODIGO_ERROR    IN VARCHAR2,
                                            PV_MENSAJE_ERROR   IN VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_SCORE_2
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 29/04/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GRABA LAS CONSULTAS REALIZADAS POR EL CLIENTE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
                                            
      FECHA_SISTEMA DATE;
      HORA_SISTEMA  VARCHAR2(8);
      CORRELATIVO   NUMBER(17);
   BEGIN
      FECHA_SISTEMA := NULL;
      HORA_SISTEMA  := NULL;
      BEGIN
         SELECT PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
           INTO FECHA_SISTEMA, HORA_SISTEMA
           FROM FST017 A
          WHERE A.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;

      CORRELATIVO := 0;
      BEGIN
         SELECT NVL(MAX(A.AQPC785CORR), 0) + 1
           INTO CORRELATIVO
           FROM AQPC785 A
          WHERE A.AQPC785USERP = PV_USUARIO
            AND A.AQPC785FECHP = FECHA_SISTEMA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
            
      BEGIN
         INSERT INTO AQPC785(AQPC785CORR, AQPC785USERP, AQPC785FECHP, AQPC785HORAP, AQPC785PAIS, AQPC785TDOC,
                             AQPC785NDOC, AQPC785NCLI, AQPC785SCORE, AQPC785DPCLF, AQPC785CPCLF, AQPC785PRCLF, 
                             AQPC785SRCNX, AQPC785CODERR, AQPC785MSGERR)
         VALUES(CORRELATIVO, PV_USUARIO, FECHA_SISTEMA, HORA_SISTEMA, PN_PAIS_DOCUMENTO, PN_TIPO_DOCUMENTO,
                PV_DOCUMENTO, PV_NOMBRE_CLIENTE, PV_SCORE_CLIENTE, PV_DESC_PRECALIF, PN_CORR_PRECALIF, PV_PRECALIFICACION,
                PN_SERIAL_CONEXION, PV_CODIGO_ERROR, PV_MENSAJE_ERROR);
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_GRABAR_LOG_MAX_CONSULTAS;
   
   PROCEDURE SP_CR_VALIDAR_LIMITE_CONSULTAS(PV_USUARIO       IN  VARCHAR2,
                                            PV_CODIGO_ERROR  OUT VARCHAR2,
                                            PV_MENSAJE_ERROR OUT VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_SCORE_2
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 29/04/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDA SI EL CLIENTE LLEGO AL LIMITE DE CONSULTAS
   --                               REALIZADAS EN EL DIA.
   --                               VALORES QUE RETORNA SON:
   --                               - CODIGO ERROR
   --                               - MENSAJE ERROR
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
                                            
      FECHA_SISTEMA    DATE;
      TOTAL_CONSULTAS  NUMBER(9);
      LIMITE_CONSULTAS NUMBER(9);                                       
   BEGIN
      FECHA_SISTEMA := NULL;
      BEGIN
         SELECT PGFAPE
           INTO FECHA_SISTEMA
           FROM FST017 A
          WHERE A.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      TOTAL_CONSULTAS := 0;
      BEGIN
         SELECT COUNT(*)
           INTO TOTAL_CONSULTAS
           FROM AQPC785 A
          WHERE A.AQPC785USERP = PV_USUARIO
            AND A.AQPC785FECHP = FECHA_SISTEMA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      LIMITE_CONSULTAS  := 0;
      BEGIN
         SELECT A.TP1NRO3
           INTO LIMITE_CONSULTAS
           FROM FST198 A
          WHERE A.TP1COD   = 1
            AND A.TP1COD1  = 111154
            AND A.TP1CORR1 = 1
            AND A.TP1CORR2 = 30
            AND A.TP1CORR3 > 0
            AND A.TP1NRO1  = 1
            AND A.TP1DESC  = RPAD(UPPER(PV_USUARIO), 30, ' ');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            LIMITE_CONSULTAS := 20;
         WHEN OTHERS THEN
            NULL;
      END;
      
      PV_CODIGO_ERROR  := '00000';
      PV_MENSAJE_ERROR := 'OK';
      IF TOTAL_CONSULTAS >= LIMITE_CONSULTAS THEN
         PV_CODIGO_ERROR  := '90000';
         PV_MENSAJE_ERROR := 'El usuario ' || TRIM(PV_USUARIO) || ' alcanzo el maximo de consultas por día ' || LIMITE_CONSULTAS;
      END IF;
   END SP_CR_VALIDAR_LIMITE_CONSULTAS;
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_CALIF_RANGO_MESES(P_FECRCC IN  DATE,
                                     P_TIPDOC IN  NUMBER,
                                     P_NRODOC IN  VARCHAR2,
                                     P_CALIF3 OUT NUMBER,
                                     P_CALIF4 OUT NUMBER) IS
   
   -- ====================================================================================================
   -- NOMBRE                      : SP_CR_CALIF_RANGO_MESES
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/11/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA LA CALIFICACION RCC TITULAR EN UN RANGO DE MESES
   -- PARAMETROS                  : P_FECRCC | DATE
   --                               P_TIPDOC | NUMBER(2)
   --                               P_NRODOC | VARCHAR2(12)
   --                               P_CALIF3 | NUMBER(5, 2)
   --                               P_CALIF4 | NUMBER(5, 2)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -- ====================================================================================================
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   -- ====================================================================================================
                                     
      V_CALIF3 NUMBER(5, 2) := 0;
      V_CALIF4 NUMBER(5, 2) := 0;                                  
   BEGIN
      BEGIN
         SELECT A1.N_CALIF3,
                A1.N_CALIF4
           INTO V_CALIF3,
                V_CALIF4
           FROM CLDRCCI A1
          WHERE A1.D_FECPRE = P_FECRCC
            AND A1.C_TDOCID = (SELECT TRIM(TO_CHAR(A2.TP1NRO2))
                                 FROM FST198 A2
                                WHERE A2.TP1COD   = 1
                                  AND A2.TP1COD1  = 11111
                                  AND A2.TP1CORR1 = 1
                                  AND A2.TP1CORR2 = 5
                                  AND A2.TP1CORR3 > 0
                                  AND A2.TP1NRO1  = P_TIPDOC)
            AND A1.C_DOCIDE = P_NRODOC
            AND ROWNUM      = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT A1.N_CALIF3,
                      A1.N_CALIF4
                 INTO V_CALIF3,
                      V_CALIF4
                 FROM CLDRCCI A1
                WHERE A1.D_FECPRE = P_FECRCC
                  AND A1.C_TDOCTR = (SELECT TRIM(TO_CHAR(A2.TP1NRO2))
                                       FROM FST198 A2
                                      WHERE A2.TP1COD   = 1
                                        AND A2.TP1COD1  = 11111
                                        AND A2.TP1CORR1 = 1
                                        AND A2.TP1CORR2 = 5
                                        AND A2.TP1CORR3 > 0
                                        AND A2.TP1NRO1  = P_TIPDOC)
                  AND A1.C_DOCTRI = P_NRODOC
                  AND ROWNUM      = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_CALIF3 := V_CALIF3;
      P_CALIF4 := V_CALIF4;
      
   END SP_CR_CALIF_RANGO_MESES;
  
  /*===================================================================================================*/ 
  PROCEDURE SP_CR_OBTENER_FECHA_RCC(P_FCH_RCC OUT DATE) IS
  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_OBTENER_FECHA_RCC
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 11/03/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : RETORNA LA FECHA RCC PARAMETRIZADO
  -- PARAMETROS                  : - P_FCH_RCC | DATE | FECHA RCC GUIA
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
    V_FCH_RCC DATE := NULL;
    
  BEGIN
    -- OBTENER FECHA RCC GUIA --
    BEGIN
      SELECT TO_DATE(TRIM(TO_CHAR(TPNRO)), 'DD/MM/RRRR')
        INTO V_FCH_RCC
        FROM FST098
       WHERE PGCOD  = 1
         AND TPCOD  = 7647
         AND TPCORR = 12;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    P_FCH_RCC := V_FCH_RCC;
    
  END SP_CR_OBTENER_FECHA_RCC;
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_TPDOC_RCC(P_TIPO_DOC  IN  NUMBER,
                                    P_TPDOC_RCC OUT VARCHAR2) IS
  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_OBTENER_TPDOC_RCC
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 11/03/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : RETORNA EL TIPO DOCUMENTO RCC
  -- PARAMETROS                  : - P_TIPO_DOC  | NUMBER(2)   | TIPO DOCUMENTO
  --                               - P_TPDOC_RCC | VARCHAR2(1) | TIPO DOCUMENTO RCC
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 28/03/2025
  -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
  -- DESCRIPCION DE MODIFICACION : SE AGREGO EL RETORNO DEL VALOR DEL TIPO DOCUMENTO RCC
  -- ====================================================================================================
    
    V_TPDOC_RCC VARCHAR2(1) := NULL;
  BEGIN
    -- OBTENER TIPO DOCUMENTO RCC --
    BEGIN
      SELECT TRIM(TO_CHAR(TP1NRO2))
        INTO V_TPDOC_RCC
        FROM FST198 A
       WHERE A.TP1COD   = 1
         AND A.TP1COD1  = 11111
         AND A.TP1CORR1 = 1
         AND A.TP1CORR2 = 5
         AND A.TP1CORR3 > 0
         AND A.TP1NRO1  = P_TIPO_DOC;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    P_TPDOC_RCC := V_TPDOC_RCC;
    
  END SP_CR_OBTENER_TPDOC_RCC;
  
  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_ANTIG_RCC(P_TIPO_DOC  IN  NUMBER,
                                    P_NRO_DOC   IN  VARCHAR2,
                                    P_FCH_RCC   IN  DATE,
                                    P_ANTIG_RCC OUT NUMBER) IS
  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_OBTENER_ANTIG_RCC
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 11/03/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : RETORNA LA ANTIGUEDAD RCC
  -- PARAMETROS                  : - P_TIPO_DOC  | NUMBER(2)    | TIPO DOCUMENTO
  --                               - P_NRO_DOC   | VARCHAR2(12) | NRO. DOCUMENTO
  --                               - P_FCH_RCC   | DATE         | FECHA RCC
  --                               - P_ANTIG_RCC | NUMBER(2)    | ANTIGUEDAD RCC
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
    
    V_ANTIG_RCC  NUMBER(2) := 0; -- ANTIGUEDAD RCC
    V_ANTIG_GUIA NUMBER(2) := 0; -- ANTIGUEDAD RCC GUIA
  BEGIN
    -- OBTENER ANTIGUEDAD RCC --
    BEGIN
      SELECT COUNT(1)
        INTO V_ANTIG_RCC
        FROM CLDRCCI A
       WHERE A.C_CODSBS IN (SELECT TRIM(T.C_CODSBS)
                             FROM CLDRCCI T
                            WHERE T.D_FECPRE = (SELECT TO_DATE(TRIM(TO_CHAR(TPNRO)), 'DD/MM/RRRR')
                                                  FROM FST098
                                                 WHERE PGCOD  = 1
                                                   AND TPCOD  = 7647
                                                   AND TPCORR = 12)
                              AND T.C_TDOCID = (SELECT TRIM(TO_CHAR(TP1NRO2))
                                                  FROM FST198
                                                 WHERE TP1COD   = 1
                                                   AND TP1COD1  = 11111
                                                   AND TP1CORR1 = 1
                                                   AND TP1CORR2 = 5
                                                   AND TP1CORR3 > 0
                                                   AND TP1NRO1  = P_TIPO_DOC)
                              AND T.C_DOCIDE = P_NRO_DOC)
        AND A.C_TIPREG = '1'
        AND A.C_TIPDET = 'Z';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT COUNT(1)
            INTO V_ANTIG_RCC
            FROM CLDRCCI A
           WHERE A.C_CODSBS IN (SELECT TRIM(T.C_CODSBS)
                                 FROM CLDRCCI T
                                WHERE T.D_FECPRE = (SELECT TO_DATE(TRIM(TO_CHAR(TPNRO)), 'DD/MM/RRRR')
                                                      FROM FST098
                                                     WHERE PGCOD  = 1
                                                       AND TPCOD  = 7647
                                                       AND TPCORR = 12)
                                  AND T.C_TDOCTR = (SELECT TRIM(TO_CHAR(TP1NRO2))
                                                      FROM FST198
                                                     WHERE TP1COD   = 1
                                                       AND TP1COD1  = 11111
                                                       AND TP1CORR1 = 1
                                                       AND TP1CORR2 = 5
                                                       AND TP1CORR3 > 0
                                                       AND TP1NRO1  = P_TIPO_DOC)
                                  AND T.C_DOCTRI = P_NRO_DOC)
            AND A.C_TIPREG = '1'
            AND A.C_TIPDET = 'Z';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN OTHERS THEN
        NULL;
    END;
    
    -- OBTENER ANTIGUEDAD RCC GUIA --
    BEGIN
      SELECT A.TPNRO
        INTO V_ANTIG_GUIA
        FROM FST098 A
       WHERE A.PGCOD  = 1
         AND A.TPCOD  = 7638
         AND A.TPCORR = 88;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    IF V_ANTIG_RCC <= V_ANTIG_GUIA THEN
      P_ANTIG_RCC := V_ANTIG_RCC;
    ELSE
      P_ANTIG_RCC := V_ANTIG_GUIA;
    END IF;
    
  END SP_CR_OBTENER_ANTIG_RCC;

END PQ_CR_DATOS_CONSULTA_BURO;
/
