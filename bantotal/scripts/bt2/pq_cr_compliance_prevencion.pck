CREATE OR REPLACE PACKAGE PQ_CR_COMPLIANCE_PREVENCION IS

  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_COMPLIANCE_PREVENCION
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 7/05/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- **************************************************************************************

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_OBTENER_CALIF(P_NRODOC  IN VARCHAR2,
                                P_FINMES  IN DATE,
                                P_CODSBS  OUT NUMBER,
                                P_DIASATR OUT NUMBER,
                                P_CALIF   OUT VARCHAR2,
                                P_COMENT  OUT VARCHAR2,
                                P_CODERR  OUT NUMBER,
                                P_MSGERR  OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_OBTENER_EST_INFO(P_CODINFO IN VARCHAR2,
                                   P_ESTINFO OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_OBTENER_NROREL_INFO(P_NRODOC IN VARCHAR2,
                                      P_NROINF IN VARCHAR2,
                                      P_NROREL OUT NUMBER);

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_GRABAR_CABECERA(P_NRODOC  IN VARCHAR2,
                                  P_NROINF  IN VARCHAR2,
                                  P_AREAINF IN VARCHAR2,
                                  P_CODATEN IN VARCHAR2,
                                  P_EMLATEN IN VARCHAR2,
                                  P_NOMATEN IN VARCHAR2,
                                  P_CODFUNC IN VARCHAR2,
                                  P_EMLFUNC IN VARCHAR2,
                                  P_NOMFUNC IN VARCHAR2,
                                  P_EMLADIC IN VARCHAR2,
                                  P_NOMCLI  IN VARCHAR2,
                                  P_USUREG  IN VARCHAR2,
                                  P_NOMARC1 IN VARCHAR2,
                                  P_COMENT  IN VARCHAR2);

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_GRABAR_DETALLE(P_NROREL  IN NUMBER,
                                 P_NRODOC  IN VARCHAR2,
                                 P_NROINF  IN VARCHAR2,
                                 P_FCHCLF  IN DATE,
                                 P_CALIF   IN VARCHAR2,
                                 P_CODSBS  IN NUMBER,
                                 P_COMENT  IN VARCHAR2,
                                 P_DIASATR IN NUMBER,
                                 P_RECTIF  IN VARCHAR2);

  ------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------

  PROCEDURE SP_CR_CAMBIO_ESTADO_DETALLE(VI_DESTINO  IN VARCHAR2,
                                        VI_USUARIO  IN VARCHAR2,
                                        VI_NDOC407  IN VARCHAR2,
                                        VI_NUMINFO  IN VARCHAR2,
                                        VI_MOTIVO   IN VARCHAR2,
                                        VI_NUMREL   IN NUMBER,
                                        VO_CODERROR OUT VARCHAR2,
                                        VO_MSGERROR OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_ENVIO_CORREO(VI_DESTINO IN VARCHAR2,
                               VI_USUARIO  IN VARCHAR2,
                               VI_NOMINFO  IN VARCHAR2,
                               VI_NDOC407  IN VARCHAR2,
                               VI_NUMINFO  IN VARCHAR2,
                               VO_CODERROR OUT VARCHAR2,
                               VO_MSGERROR OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_ENVIARCORREO_TI(P_NRODOC  IN VARCHAR2,
                                  P_CODINFO IN VARCHAR2,
                                  P_RELINFO IN NUMBER);
  
  -----------------------------------------------------------------------------------------                               
  FUNCTION FN_ENTRCC_NOCAJA2(P_CODSBS IN VARCHAR2, P_FECDES IN DATE) RETURN VARCHAR2;

END PQ_CR_COMPLIANCE_PREVENCION;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_COMPLIANCE_PREVENCION IS

  PROCEDURE SP_CR_OBTENER_CALIF(P_NRODOC  IN VARCHAR2,
                                P_FINMES  IN DATE,
                                P_CODSBS  OUT NUMBER,
                                P_DIASATR OUT NUMBER,
                                P_CALIF   OUT VARCHAR2,
                                P_COMENT  OUT VARCHAR2,
                                P_CODERR  OUT NUMBER,
                                P_MSGERR  OUT VARCHAR2) IS
  
    -- **************************************************************************************
    -- NOMBRE                      : SP_CR_OBTENER_CALIF
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 05/02/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : OBTENER LA CLASIFICACION DEL CLIENTE
    -- PARAMETROS                  : P_NRODOC   | VARCHAR2(12)
    --                               P_FINMES   | DATE
    --                               P_CODSBS   | NUMBER(10)
    --                               P_DIASATR  | NUMBER(5)
    --                               P_CALIF    | VARCHAR2(30)
    --                               P_COMENT   | VARCHAR2(200)
    --                               P_CODERR   | NUMBER(5)
    --                               P_MSGERR   | VARCHAR2(255)
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -----------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- **************************************************************************************
  
    V_FINMES  DATE := NULL;
    V_CODSBS  NUMBER(10) := NULL;
    V_DIASATR NUMBER(5) := 0;
    V_CALIF   VARCHAR2(30) := NULL;
    V_COMENT  VARCHAR2(200) := NULL;
    V_NRODOC  VARCHAR2(12) := NULL;
    V_CODERR  VARCHAR2(5) := 0;
    V_MSGERR  VARCHAR2(255) := 'Ok';
  BEGIN
    BEGIN
      WITH CTE_DATA1 AS
       (SELECT C1.AQPB880FPR,
               A1.CTNRO,
               A1.PENDOC,
               B1.BC739SBS,
               CASE
                 WHEN C1.RI105AUX2 IS NOT NULL THEN
                  C1.RI105AUX2
                 ELSE
                  D1.N_DIAATR
               END DIASATR,
               E1.CATCATEG CALIF4,
               E2.CATCATEG CALIF9,
               E3.CATCATEG CALIF6,
               E4.CATCATEG CALIF8,
               CASE
                 WHEN C1.RI105RUB LIKE '14__02%' THEN
                  'MICROEMPRESAS'
                 WHEN C1.RI105RUB LIKE '14__03%' THEN
                  'CONSUMO'
                 WHEN C1.RI105RUB LIKE '14__04%' THEN
                  'HIPOTECARIO'
                 WHEN C1.RI105RUB LIKE '14__09%' OR
                      C1.RI105RUB LIKE '14__10%' THEN
                  'CORPORATIVO E.I.F.'
                 WHEN C1.RI105RUB LIKE '14__11%' THEN
                  'GRANDES EMPRESAS'
                 WHEN C1.RI105RUB LIKE '14__12%' THEN
                  'MEDIANAS EMPRESAS'
                 WHEN C1.RI105RUB LIKE '14__13%' THEN
                  'PEQUEÑAS EMPRESAS'
               END TIPOSBS
          FROM FSR008 A1
          JOIN FBC739 B1
            ON B1.BC739CTA = A1.CTNRO
          LEFT JOIN AQPB880 C1
            ON C1.AQPB880FPR = P_FINMES
           AND C1.RI105COD = 1
           AND C1.RI105CTA = A1.CTNRO
           AND REGEXP_LIKE(C1.RI105RUB, '^14.[1-6]')
          LEFT JOIN CLDRCCS D1
            ON D1.D_FECPRE = P_FINMES
           AND D1.C_CODSBS = LPAD(TRIM(TO_CHAR(B1.BC739SBS)), 10, '0')
           AND D1.C_CODEMP = '00104'
           AND REGEXP_LIKE(D1.C_CUENTA, '^81.302')
          LEFT JOIN FSD212 E1
            ON E1.PGCOD = 1
           AND E1.CATCTA = A1.CTNRO
           AND E1.CATCOD = 4
           AND E1.CATFCHDES = P_FINMES
          LEFT JOIN FSD212 E2
            ON E2.PGCOD = 1
           AND E2.CATCTA = A1.CTNRO
           AND E2.CATCOD = 9
           AND E2.CATFCHDES = P_FINMES
          LEFT JOIN FSD212 E3
            ON E3.PGCOD = 1
           AND E3.CATCTA = A1.CTNRO
           AND E3.CATCOD = 6
           AND E3.CATFCHDES = P_FINMES
          LEFT JOIN FSD212 E4
            ON E4.PGCOD = 1
           AND E4.CATCTA = A1.CTNRO
           AND E4.CATCOD = 8
           AND E4.CATFCHDES = P_FINMES
         WHERE A1.PENDOC = RPAD(P_NRODOC, 12, ' ')
           AND A1.CTTFIR = 'T'),
      CTE_DATA2 AS
       (SELECT CTE1.*,
               CASE
                 WHEN TIPOSBS IN ('CORPORATIVO E.I.F.',
                                  'GRANDES EMPRESAS',
                                  'MEDIANAS EMPRESAS') AND
                      NVL(DIASATR, 0) <= 8 THEN
                  '0.NORMAL'
                 WHEN TIPOSBS IN ('CORPORATIVO E.I.F.',
                                  'GRANDES EMPRESAS',
                                  'MEDIANAS EMPRESAS') AND
                      NVL(DIASATR, 0) > 8 AND NVL(DIASATR, 0) <= 60 THEN
                  '1.CPP'
                 WHEN TIPOSBS IN ('CORPORATIVO E.I.F.',
                                  'GRANDES EMPRESAS',
                                  'MEDIANAS EMPRESAS') AND
                      NVL(DIASATR, 0) > 60 AND NVL(DIASATR, 0) <= 120 THEN
                  '2.DEFICIENTE'
                 WHEN TIPOSBS IN ('CORPORATIVO E.I.F.',
                                  'GRANDES EMPRESAS',
                                  'MEDIANAS EMPRESAS') AND
                      NVL(DIASATR, 0) > 120 AND NVL(DIASATR, 0) <= 243 OR
                      TIPOSBS IN ('CORPORATIVO E.I.F.',
                                  'GRANDES EMPRESAS',
                                  'MEDIANAS EMPRESAS') AND
                      NVL(DIASATR, 0) > 243 AND NVL(DIASATR, 0) <= 365 THEN
                  '3.DUDOSO'
                 WHEN TIPOSBS IN ('CORPORATIVO E.I.F.',
                                  'GRANDES EMPRESAS',
                                  'MEDIANAS EMPRESAS') AND
                      NVL(DIASATR, 0) > 365 THEN
                  '4.PERDIDA'
                 WHEN TIPOSBS IN
                      ('PEQUEÑAS EMPRESAS', 'MICROEMPRESAS', 'CONSUMO') AND
                      NVL(DIASATR, 0) <= 8 THEN
                  '0.NORMAL'
                 WHEN TIPOSBS IN
                      ('PEQUEÑAS EMPRESAS', 'MICROEMPRESAS', 'CONSUMO') AND
                      NVL(DIASATR, 0) > 8 AND NVL(DIASATR, 0) <= 30 THEN
                  '1.CPP'
                 WHEN TIPOSBS IN
                      ('PEQUEÑAS EMPRESAS', 'MICROEMPRESAS', 'CONSUMO') AND
                      NVL(DIASATR, 0) > 30 AND NVL(DIASATR, 0) <= 60 THEN
                  '2.DEFICIENTE'
                 WHEN TIPOSBS IN
                      ('PEQUEÑAS EMPRESAS', 'MICROEMPRESAS', 'CONSUMO') AND
                      NVL(DIASATR, 0) > 60 AND NVL(DIASATR, 0) <= 90 OR
                      TIPOSBS IN
                      ('PEQUEÑAS EMPRESAS', 'MICROEMPRESAS', 'CONSUMO') AND
                      NVL(DIASATR, 0) > 90 AND NVL(DIASATR, 0) <= 120 THEN
                  '3.DUDOSO'
                 WHEN TIPOSBS IN
                      ('PEQUEÑAS EMPRESAS', 'MICROEMPRESAS', 'CONSUMO') AND
                      NVL(DIASATR, 0) > 120 THEN
                  '4.PERDIDA'
                 WHEN TIPOSBS = 'HIPOTECARIO' AND NVL(DIASATR, 0) <= 30 THEN
                  '0.NORMAL'
                 WHEN TIPOSBS = 'HIPOTECARIO' AND NVL(DIASATR, 0) > 30 AND
                      NVL(DIASATR, 0) <= 60 THEN
                  '1.CPP'
                 WHEN TIPOSBS = 'HIPOTECARIO' AND NVL(DIASATR, 0) > 60 AND
                      NVL(DIASATR, 0) <= 120 THEN
                  '2.DEFICIENTE'
                 WHEN TIPOSBS = 'HIPOTECARIO' AND NVL(DIASATR, 0) > 120 AND
                      NVL(DIASATR, 0) <= 243 OR
                      TIPOSBS = 'HIPOTECARIO' AND NVL(DIASATR, 0) > 243 AND
                      NVL(DIASATR, 0) <= 365 THEN
                  '3.DUDOSO'
                 WHEN TIPOSBS = 'HIPOTECARIO' AND NVL(DIASATR, 0) > 365 THEN
                  '4.PERDIDA'
                 ELSE
                  ''
               END CATCOD6CAL,
               (SELECT COUNT(DISTINCT CTNRO)
                  FROM CTE_DATA1
                 WHERE DIASATR IS NOT NULL) NUMCRED
          FROM CTE_DATA1 CTE1),
      CTE_DATA3 AS
       (SELECT CTE2.*,
               CASE
                 WHEN TO_NUMBER(SUBSTR(CALIF4, 1, 1)) >
                      TO_NUMBER(SUBSTR(CALIF9, 1, 1)) THEN
                  'ALINEAMIENTO EXTERNO - ' || FN_ENTRCC_NOCAJA2(LPAD(TRIM(TO_CHAR(BC739SBS)), 10, '0'), ADD_MONTHS(P_FINMES, -1))
                 WHEN TO_NUMBER(SUBSTR(CALIF9, 1, 1)) >
                      TO_NUMBER(SUBSTR(CALIF8, 1, 1)) AND NUMCRED > 1 AND
                      CALIF8 IS NOT NULL THEN
                  'ALINEAMIENTO INTERNO REFI'
                 WHEN TO_NUMBER(SUBSTR(CALIF9, 1, 1)) >
                      TO_NUMBER(SUBSTR(CATCOD6CAL, 1, 1)) AND NUMCRED > 1 THEN
                  'ALINEAMIENTO INTERNO'
                 WHEN TO_NUMBER(SUBSTR(CALIF8, 1, 1)) IS NOT NULL THEN
                  'REFINANCIADO'
                 WHEN NVL(DIASATR, 0) > 0 THEN
                  'ATRASO'
                 ELSE
                  ''
               END COMENT
          FROM CTE_DATA2 CTE2)
      
      SELECT AQPB880FPR,
             PENDOC,
             BC739SBS,
             MAX(DIASATR),
             MAX(CALIF4),
             MAX(COMENT)
        INTO V_FINMES, V_NRODOC, V_CODSBS, V_DIASATR, V_CALIF, V_COMENT
        FROM CTE_DATA3
       WHERE DIASATR IS NOT NULL
       GROUP BY AQPB880FPR, PENDOC, BC739SBS;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CODERR := 1;
        V_MSGERR := 'No se encontró información';
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_CODSBS  := V_CODSBS;
    P_DIASATR := V_DIASATR;
    P_CALIF   := V_CALIF;
    P_COMENT  := V_COMENT;
    P_CODERR  := V_CODERR;
    P_MSGERR  := V_MSGERR;
  
  END SP_CR_OBTENER_CALIF;

  ---------------------------------------------------------------------------------------------------- 
  PROCEDURE SP_CR_OBTENER_EST_INFO(P_CODINFO IN VARCHAR2,
                                   P_ESTINFO OUT VARCHAR2) IS
  
    -- ====================================================================================================
    -- NOMBRE                      : SP_CR_OBTENER_EST_INFO
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 05/02/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : RETORNA EL ESTADO DEL INFORME
    -- PARAMETROS                  : - P_CODINFO | VARCHAR2(20) | CODIGO INFORME
    --                               - P_ESTINFO | VARCHAR2(1)  | ESTADO INFORME
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================
  
    V_ESTINFO VARCHAR2(1) := NULL;
  
  BEGIN
    BEGIN
      SELECT A.AQPD407EST
        INTO V_ESTINFO
        FROM AQPD407 A
       WHERE A.AQPD407NINF = P_CODINFO
         AND A.AQPD407NREL =
             (SELECT MAX(T.AQPD407NREL)
                FROM AQPD407 T
               WHERE T.AQPD407NINF = P_CODINFO);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_ESTINFO := V_ESTINFO;
  
  END SP_CR_OBTENER_EST_INFO;

  ----------------------------------------------------------------------------------------------------
  PROCEDURE SP_CR_OBTENER_NROREL_INFO(P_NRODOC IN VARCHAR2,
                                      P_NROINF IN VARCHAR2,
                                      P_NROREL OUT NUMBER) IS
  
    -- ====================================================================================================
    -- NOMBRE                      : SP_CR_OBTENER_NROREL_INFO
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 05/02/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : RETORNA LA RELACION MAXIMA DEL INFORME
    -- PARAMETROS                  : - P_NRODOC | VARCHAR2(12) | NRO. DOCUMENTO
    --                               - P_NROINF | VARCHAR2(20) | CODIGO INFORME
    --                               - P_NROREL | NUMBER(17)   | RELACION INFORME
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================
  
    V_NROREL NUMBER(17) := 0;
  
  BEGIN
    BEGIN
      SELECT MAX(A.AQPD407NREL)
        INTO V_NROREL
        FROM AQPD407 A
       WHERE A.AQPD407NDOC = P_NRODOC
         AND A.AQPD407NINF = P_NROINF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_NROREL := V_NROREL;
  
  END SP_CR_OBTENER_NROREL_INFO;

  ---------------------------------------------------------------------------------------------------- 
  PROCEDURE SP_CR_GRABAR_CABECERA(P_NRODOC  IN VARCHAR2,
                                  P_NROINF  IN VARCHAR2,
                                  P_AREAINF IN VARCHAR2,
                                  P_CODATEN IN VARCHAR2,
                                  P_EMLATEN IN VARCHAR2,
                                  P_NOMATEN IN VARCHAR2,
                                  P_CODFUNC IN VARCHAR2,
                                  P_EMLFUNC IN VARCHAR2,
                                  P_NOMFUNC IN VARCHAR2,
                                  P_EMLADIC IN VARCHAR2,
                                  P_NOMCLI  IN VARCHAR2,
                                  P_USUREG  IN VARCHAR2,
                                  P_NOMARC1 IN VARCHAR2,
                                  P_COMENT  IN VARCHAR2
                                  ) IS
  
    ----------------------------------------------------------------------------------------------------
    -- NOMBRE                      : SP_CR_GRABAR_CABECERA
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 05/02/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : GRABAR LA CABECERA DEL INFORME DE RECTIFICACION
    -- PARAMETROS                  : - P_NRODOC  | VARCHAR2(12)  | NRO. DOCUMENTO
    --                               - P_NROINF  | VARCHAR2(20)  | CODIGO INFORME
    --                               - P_AREAINF | VARCHAR2(40)  | AREA INFORME
    --                               - P_CODATEN | VARCHAR2(10)  | CODIGO ATENCION
    --                               - P_EMLATEN | VARCHAR2(40)  | EMAIL ATENCION
    --                               - P_NOMATEN | VARCHAR2(30)  | NOMBRE ATENCION
    --                               - P_CODFUNC | VARCHAR2(255) | CODIGO FUNCIONARIO AUTORIZA
    --                               - P_EMLFUNC | VARCHAR2(100) | EMAIL FUNCIONARIO AUTORIZA
    --                               - P_NOMFUNC | VARCHAR2(10)  | NOMBRE FUNCIONARIO AUTORIZA
    --                               - P_EMLADIC | VARCHAR2(255) | EMAILS ADICIONALES
    --                               - P_NOMCLI  | VARCHAR2(255) | NOMBRE CLIENTE
    --                               - P_USUREG  | VARCHAR2(10)  | CODIGO USUARIO GENERO INFORME
    --                               - P_NOMARC1 | VARCHAR2(255) | INFORME RECTIFICACION PDF
    --                               - P_COMENT  | VARCHAR2(255) | COMENTARIO RECLAMOS
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    ----------------------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    ----------------------------------------------------------------------------------------------------
  
    V_FCHSIST DATE       := NULL;
    V_NROREL  NUMBER(17) := 0;
      
  BEGIN  
    BEGIN
      SELECT A1.PGFAPE INTO V_FCHSIST FROM FST017 A1 WHERE A1.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT NVL(MAX(A.AQPD407NREL), 0) + 1
        INTO V_NROREL
        FROM AQPD407 A
       WHERE A.AQPD407NDOC = P_NRODOC
         AND A.AQPD407NINF = P_NROINF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      INSERT INTO AQPD407
        (AQPD407NDOC,
         AQPD407NINF,
         AQPD407NREL,
         AQPD407AREA,
         AQPD407CDATEN,
         AQPD407EMATEN,
         AQPD407NOATEN,
         AQPD407CDFUNC,
         AQPD407EMFUNC,
         AQPD407NOFUNC,
         AQPD407EMADIC,
         AQPD407NOMCLI,
         AQPD407NOMAR1,
         AQPD407COMNT2,
         AQPD407EST,
         AQPD407USU1,
         AQPD407FCH1,
         AQPD407HRA1)
      VALUES
        (P_NRODOC,
         P_NROINF,
         V_NROREL,
         P_AREAINF,
         P_CODATEN,
         P_EMLATEN,
         P_NOMATEN,
         P_CODFUNC,
         P_EMLFUNC,
         P_NOMFUNC,
         P_EMLADIC,
         P_NOMCLI,
         P_NOMARC1,
         P_COMENT,
         'P',
         P_USUREG,
         V_FCHSIST,
         TO_CHAR(SYSDATE, 'HH24:MI:SS'));
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_GRABAR_CABECERA;

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_GRABAR_DETALLE(P_NROREL  IN NUMBER,
                                 P_NRODOC  IN VARCHAR2,
                                 P_NROINF  IN VARCHAR2,
                                 P_FCHCLF  IN DATE,
                                 P_CALIF   IN VARCHAR2,
                                 P_CODSBS  IN NUMBER,
                                 P_COMENT  IN VARCHAR2,
                                 P_DIASATR IN NUMBER,
                                 P_RECTIF  IN VARCHAR2) IS
  
    -- **************************************************************************************
    -- NOMBRE                      : SP_CR_GRABAR_INFORME
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 05/02/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : GRABAR EL DETALLE DEL INFORME DE RECTIFICACION
    -- PARAMETROS                  : P_NROREL  | NUMBER(17)    | RELACION INFORME
    --                               P_NRODOC  | VARCHAR2(10)  | NRO. DOCUMENTO
    --                               P_NROINF  | VARCHAR2(20)  | CODIGO INFORME
    --                               P_FCHCLF  | DATE          | FECHA CALIFICACION
    --                               P_CALIF   | VARCHAR2(15)  | DESCRIPCION CALIFICACION
    --                               P_CODSBS  | NUMBER(10)    | CODIGO SBS
    --                               P_COMENT  | VARCHAR2(255) | COMENTARIO REFERIDO
    --                               P_DIASATR | NUMBER(10)    | DIAS ATRASO
    --                               P_RECTIF  | VARCHAR2(255) | RECTIFICACION
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -----------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- **************************************************************************************
  
    V_FCHSIST DATE := NULL;
    V_CORREL  NUMBER(17) := 0;
  
  BEGIN
    BEGIN
      SELECT A1.PGFAPE INTO V_FCHSIST FROM FST017 A1 WHERE A1.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT NVL(MAX(A.AQPC798CORR), 0) + 1
        INTO V_CORREL
        FROM AQPC798 A
       WHERE A.AQPC798NDOC = P_NRODOC
         AND A.AQPC798NINF = P_NROINF
         AND A.AQPC798NREL = P_NROREL;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      INSERT INTO AQPC798
        (AQPC798NREL,
         AQPC798NDOC,
         AQPC798NINF,
         AQPC798CORR,
         AQPC798FCLF,
         AQPC798CALF,
         AQPC798CSBS,
         AQPC798COMT,
         AQPC798DATR,
         AQPC798RCTF)
      VALUES
        (P_NROREL,
         P_NRODOC,
         P_NROINF,
         V_CORREL,
         P_FCHCLF,
         P_CALIF,
         P_CODSBS,
         P_COMENT,
         P_DIASATR,
         P_RECTIF);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_GRABAR_DETALLE;

  ----------------------------------------------------------------------------------------------------
 

  PROCEDURE SP_CR_CAMBIO_ESTADO_DETALLE(VI_DESTINO  IN VARCHAR2,
                                        VI_USUARIO  IN VARCHAR2,
                                        VI_NDOC407  IN VARCHAR2,
                                        VI_NUMINFO  IN VARCHAR2,
                                        VI_MOTIVO   IN VARCHAR2,
                                        VI_NUMREL   IN NUMBER,
                                        VO_CODERROR OUT VARCHAR2,
                                        VO_MSGERROR OUT VARCHAR2) IS
    -- **************************************************************************************
    -- NOMBRE                      : SP_CR_CAMBIO_ESTADO_DETALLE
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 26/02/2025
    -- AUTOR DE CREACION           : JAIR IMANOL ALVARO HUAMANI 
    -- USO                         : CAMBIO DE ESTADO DE LA CABECERA /GESTIONADO/ENVIADO TI
    -- PARAMETROS                  : VI_DESTINO  | VARCHAR2
    --                               VI_NDOC407  | VARCHAR2
    --                               VI_NUMINFO  | NUMBER
    --                               VI_MOTIVO   | VARCHAR
    --                               VO_CODERROR | VARCHAR2
    --                               VO_MSGERROR | VARCHAR2
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -----------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- **************************************************************************************
    FECHSTADO DATE; -- fecha de la modificacion del estado
    HORASTADO VARCHAR2(10);
  
  BEGIN
    BEGIN
      SELECT pgfape INTO FECHSTADO FROM fst017 WHERE pgcod = 1;
    
      HORASTADO := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF VI_DESTINO = 'R' THEN
      -- CAMBIO DE ESTADO A RECHAZADO || TIENE COMO MINIMO UN RECHAZADO
    
      BEGIN
        UPDATE AQPD407
           SET AQPD407.AQPD407EST  = 'R',
               AQPD407.AQPD407USU2 = VI_USUARIO,
               AQPD407.AQPD407FCH2 = FECHSTADO,
               AQPD407.AQPD407HRA2 = HORASTADO
         WHERE AQPD407.AQPD407NDOC = VI_NDOC407
           AND AQPD407.AQPD407NINF = VI_NUMINFO
           AND AQPD407.AQPD407NREL = VI_NUMREL;
      
        COMMIT;
      
      EXCEPTION
        WHEN OTHERS THEN
          -- Si hay un error, se captura y se devuelven los mensajes de error
          VO_CODERROR := SQLCODE;
          VO_MSGERROR := SQLERRM;
          ROLLBACK; -- Revertimos los cambios en caso de error  
      END;
    ELSIF VI_DESTINO = 'D' THEN
      -- CAMBIO DE ESTADO A GESTIONADO || TODOS SON APROBADOS
      BEGIN
        UPDATE AQPD407
           SET AQPD407.AQPD407EST    = 'D',
               AQPD407.AQPD407COMENT = VI_MOTIVO,
               AQPD407.AQPD407USU2   = VI_USUARIO,
               AQPD407.AQPD407FCH2   = FECHSTADO,
               AQPD407.AQPD407HRA2   = HORASTADO
         WHERE AQPD407.AQPD407NDOC = VI_NDOC407
           AND AQPD407.AQPD407NINF = VI_NUMINFO
           AND AQPD407.AQPD407NREL = VI_NUMREL;
      
        COMMIT;
      
      EXCEPTION
        WHEN OTHERS THEN
          -- Si hay un error, se captura y se devuelven los mensajes de error
          VO_CODERROR := SQLCODE;
          VO_MSGERROR := SQLERRM;
          ROLLBACK; -- Revertimos los cambios en caso de error  
      END;
    
    ELSE
      VO_CODERROR := '1'; -- Sin error
      VO_MSGERROR := 'ERROR AL ACTUALIZAR ESTADOS';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- Si hay un error, se captura y se devuelven los mensajes de error
      VO_CODERROR := SQLCODE;
      VO_MSGERROR := SQLERRM;
      ROLLBACK; -- Revertimos los cambios en caso de error  
  END SP_CR_CAMBIO_ESTADO_DETALLE;

      PROCEDURE SP_CR_ENVIO_CORREO(VI_DESTINO IN VARCHAR2,
                               VI_USUARIO  IN VARCHAR2,
                               VI_NOMINFO  IN VARCHAR2,
                               VI_NDOC407  IN VARCHAR2,
                               VI_NUMINFO  IN VARCHAR2,
                               VO_CODERROR OUT VARCHAR2,
                               VO_MSGERROR OUT VARCHAR2) IS
    -- **************************************************************************************
    -- NOMBRE                      : SP_CR_ENVIO_CORRREO
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 26/02/2025
    -- AUTOR DE CREACION           : JAIR IMANOL ALVARO HUAMANI 
    -- USO                         : ENVIO DE CORREO DEPENDIENDO DE LA RESTRICCION AL AREA DE 
    --                               TI O AL AREA DE RECLAMOS, MAS ADJUNTO DE INFORME 
    -- PARAMETROS                  : VI_NOMINFO   | VARCHAR2
    --                               VI_NDOC407   | VARCHAR2
    --                               VI_NUMREL407 | NUMBER
    --                               VO_CODERROR  | VARCHAR2
    --                               VO_MSGERROR  | VARCHAR2
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -----------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- **************************************************************************************
  
    correo_usuario varchar2(40);
    usuario        varchar2(40);
    nombre_usuario varchar2(60);
    FECHSTADO      DATE; -- fecha de la modificacion del estado
    HORASTADO      VARCHAR2(10);
    destinatario   VARCHAR2(30);
    ccompia        VARCHAR2(255);
  
  BEGIN
  
    BEGIN
      -- usuario que gestiono 
      select AQPD407USU1, AQPD407EMFUNC
        into usuario, ccompia
        from AQPD407
       where AQPD407NINF = VI_NUMINFO
         and AQPD407NDOC = VI_NDOC407;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      -- sacar fecha y hora actual 
      SELECT pgfape INTO FECHSTADO FROM fst017 WHERE pgcod = 1;
    
      HORASTADO := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
    
      SELECT WFUSREMAIL
        INTO correo_usuario
        FROM WFUSERS
       WHERE WFUSRCOD = RPAD(usuario, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      -- sacamor el nombre del usuario 
      SELECT UBNOM
        INTO nombre_usuario
        FROM fst746
       WHERE UBUSER = RPAD(usuario, 10, ' ');
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  

    -- ENVIO AREA DE RECLAMOS 
  
    BEGIN
      -- 
      UPDATE AQPD407
         SET AQPD407.AQPD407USU2 = VI_USUARIO,
             AQPD407.AQPD407FCH2 = FECHSTADO,
             AQPD407.AQPD407HRA2 = HORASTADO
       WHERE AQPD407.AQPD407NDOC = VI_NDOC407
         AND AQPD407.AQPD407NINF = VI_NUMINFO;
    
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
   IF VI_DESTINO = 'R' THEN 
    BEGIN
     -- correo para pase a produccion ----  || ';InteligenciadeRiesgos@cajaarequipa.pe'
      PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => correo_usuario, -- VARCHAR2(4000)
                                       p_DestinatariosCC   => ccompia || ';InteligenciadeRiesgos@cajaarequipa.pe', -- VARCHAR2(4000)
                                       p_DestinatariosBcc  => ' ', -- VARCHAR2(4000)
                                       p_Mensaje           => '<html>
                                                                <head><style type="text/css"></style></head>
                                                                  <body>
                                                                     <p>Estimad@ ' ||
                                                              nombre_usuario ||
                                                              ',</p>
                                                                     <p>Mediante el presente se comunica que el informe ya ha sido rectificado.</p>
                                                              
                                                             <ul>
                                                                 <li>Nombre Informe: ' || VI_NOMINFO || '</li>
                                                                 <li>Código Informe: ' || VI_NUMINFO || '</li>
                                                                 <li>Nro. Documento: ' || VI_NDOC407 || '</li>
                                                              </ul>
                                                              
                                                              <p>Muchas gracias,</p>
                                                              <p>Saludos.</p>
                                                                  </body>
                                                               </html>', -- CLOB
                                       p_Remitente         => 'notificaciones@cajaarequipa.pe', -- VARCHAR2(100)
                                       p_Asunto            => 'Area de reclamos', -- VARCHAR2(100)
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => 'BT_COMPLIANCE',
                                       p_ArchivosAdjuntos  => VI_NOMINFO,
                                       p_c_coderr          => VO_CODERROR, -- VARCHAR2(5)
                                       p_c_deserr          => VO_MSGERROR -- VARCHAR2(4000)
                                       );
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
     ELSIF VI_DESTINO = 'D' THEN
    
    BEGIN
    
      PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => correo_usuario, -- VARCHAR2(4000)
                                       p_DestinatariosCC   => ccompia || ';InteligenciadeRiesgos@cajaarequipa.pe', -- VARCHAR2(4000)
                                       p_DestinatariosBcc  => ' ', -- VARCHAR2(4000)
                                       p_Mensaje           => '<html>
                                                                <head><style type="text/css"></style></head>
                                                                  <body>
                                                                     <p>Estimad@ ' ||
                                                              nombre_usuario ||
                                                              ',</p>
                                                                     <p>Mediante el presente se comunica que el informe ya ha sido devuelto.</p>
                                                              
                                                             <ul>
                                                                 <li>Nombre Informe: ' || VI_NOMINFO || '</li>
                                                                 <li>Código Informe: ' || VI_NUMINFO || '</li>
                                                                 <li>Nro. Documento: ' || VI_NDOC407 || '</li>
                                                              </ul>
                                                              
                                                              <p>Muchas gracias,</p>
                                                              <p>Saludos.</p>
                                                                  </body>
                                                               </html>', -- CLOB
                                       p_Remitente         => 'notificaciones@cajaarequipa.pe', -- VARCHAR2(100)
                                       p_Asunto            => 'Area de reclamos', -- VARCHAR2(100)
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => 'BT_COMPLIANCE',
                                       p_ArchivosAdjuntos  => VI_NOMINFO,
                                       p_c_coderr          => VO_CODERROR, -- VARCHAR2(5)
                                       p_c_deserr          => VO_MSGERROR -- VARCHAR2(4000)
                                       );
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
      
      ELSE
        VO_CODERROR := '1'; -- Sin error
        VO_MSGERROR := 'DESTINO INCORRECTO';
      
      END IF;
    
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  ----------------------------------------------------------------------------------------------------
  PROCEDURE SP_CR_ENVIARCORREO_TI(P_NRODOC  IN VARCHAR2,
                                  P_CODINFO IN VARCHAR2,
                                  P_RELINFO IN NUMBER) IS
  
    -- ====================================================================================================
    -- NOMBRE                      : NOMBRE_PROCEDIMIENTO
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 05/02/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : ENVIA CORREO AREA TI
    -- PARAMETROS                  : - P_NRODOC  | VARCHAR2(12) | NRO. DOCUMENTO
    --                               - P_CODINFO | VARCHAR2(20) | CODIGO INFORME
    --                               - P_RELINFO | NUMBER(17)   | RELACION INFORME
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================                               
  
    V_TILDE      VARCHAR2(30) := NULL;
    V_ESPECIAL   VARCHAR2(30) := NULL;
    V_CORREOPARA VARCHAR2(4000) := NULL;
    V_CORREOCC   VARCHAR2(4000) := NULL;
    V_MSGCORREO  CLOB := NULL;
    V_NOMCLI     VARCHAR2(100) := NULL;
    V_CODSBS     NUMBER(10) := NULL;
    V_NOMARCH1   VARCHAR2(255) := NULL;
    V_CODERREML  VARCHAR2(5) := NULL;
    V_MSGERREML  VARCHAR2(4000) := NULL;
    V_CODERR     NUMBER(5) := 0;
    V_MSGERR     VARCHAR2(255) := 'OK';
  
    CURSOR TILDES IS
      SELECT A.TP1DESC
        FROM FST198 A
       WHERE A.TP1COD = 1
         AND A.TP1COD1 = 10825
         AND A.TP1CORR1 = 75
         AND A.TP1CORR2 = 1;
  
  BEGIN
    BEGIN
      SELECT TRIM(A.AQPD407EMATEN),
             TRIM(A.AQPD407EMADIC),
             TRIM(A.AQPD407NOMCLI),
             TRIM(A.AQPD407NOMAR1)
        INTO V_CORREOPARA, V_CORREOCC, V_NOMCLI, V_NOMARCH1
        FROM AQPD407 A
       WHERE A.AQPD407NDOC = P_NRODOC
         AND A.AQPD407NINF = P_CODINFO
         AND A.AQPD407NREL = P_RELINFO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT A.AQPC798CSBS
        INTO V_CODSBS
        FROM AQPC798 A
       WHERE A.AQPC798NREL = P_RELINFO
         AND A.AQPC798NDOC = P_NRODOC
         AND A.AQPC798NINF = P_CODINFO
         AND ROWNUM        = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      V_MSGCORREO := '<html>
                      <head></head>
                      <body>
                         <p>Estimad@,</p>
                          <p>El informe de rectificación ha sido elaborado y está disponible para su revisión. Por favor, ' ||
                     'bríndele la atención correspondiente.</p>
                          <ul>
                             <li>Código Informe: ' ||
                     P_CODINFO ||
                     '</li>
                             <li>Nro. Documento: ' ||
                     P_NRODOC ||
                     '</li>
                             <li>Código SBS: ' ||
                     V_CODSBS || '</li>
                          </ul>
                       </body>
                       </html>';
    
      FOR I IN TILDES LOOP
        V_TILDE    := SUBSTR(TRIM(I.TP1DESC), 1, 1);
        V_ESPECIAL := SUBSTR(TRIM(I.TP1DESC),
                             3,
                             LENGTH(TRIM(I.TP1DESC)) - 2);
      
        V_MSGCORREO := REPLACE(V_MSGCORREO, V_TILDE, V_ESPECIAL);
      
        V_TILDE    := NULL;
        V_ESPECIAL := NULL;
      END LOOP;
    
      PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_CORREOPARA,
                                       p_DestinatariosCC   => V_CORREOCC,
                                       p_DestinatariosBcc  => ' ',
                                       p_Mensaje           => V_MSGCORREO,
                                       p_Remitente         => 'notificaciones@cajaarequipa.pe',
                                       p_Asunto            => 'Informe de Rectificacion del Cliente: ' ||
                                                              V_NOMCLI,
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => 'BT_COMPLIANCE',
                                       p_ArchivosAdjuntos  => V_NOMARCH1,
                                       p_c_coderr          => V_CODERREML,
                                       p_c_deserr          => V_MSGERREML
                                       );
                                       
      IF TO_NUMBER(TRIM(V_CODERREML)) <> 0 THEN
        V_CODERR := 1;
        V_MSGERR := SUBSTR(TRIM(V_MSGERREML), 1, 255);
        BEGIN
          UPDATE AQPD407 A
            SET A.AQPD407CDEML1 = V_CODERR,
                A.AQPD407MSEML1 = V_MSGERR,
                A.AQPD407MAIL1  = V_MSGCORREO
            WHERE A.AQPD407NDOC = P_NRODOC
              AND A.AQPD407NINF = P_CODINFO
              AND A.AQPD407NREL = P_RELINFO;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        BEGIN
          UPDATE AQPD407 A
            SET A.AQPD407CDEML1 = V_CODERR,
                A.AQPD407MSEML1 = V_MSGERR,
                A.AQPD407MAIL1  = V_MSGCORREO
            WHERE A.AQPD407NDOC = P_NRODOC
              AND A.AQPD407NINF = P_CODINFO
              AND A.AQPD407NREL = P_RELINFO;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        V_CODERR := 1;
        V_MSGERR := SUBSTR(TRIM(SQLERRM), INSTR(TRIM(SQLERRM), '-') + 8, 255);
        
        BEGIN
          UPDATE AQPD407 A
            SET A.AQPD407CDEML1 = V_CODERR,
                A.AQPD407MSEML1 = V_MSGERR,
                A.AQPD407MAIL1  = V_MSGCORREO
            WHERE A.AQPD407NDOC = P_NRODOC
              AND A.AQPD407NINF = P_CODINFO
              AND A.AQPD407NREL = P_RELINFO;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
    END;
  END SP_CR_ENVIARCORREO_TI;
  
  ----------------------------------------------------------------------------------------------------
  FUNCTION FN_ENTRCC_NOCAJA2(P_CODSBS IN VARCHAR2, 
                             P_FECDES IN DATE) RETURN VARCHAR2 IS
    
  -- ====================================================================================================
  -- NOMBRE                      : FN_ENTRCC_NOCAJA2
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 5/02/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : RETORNA LA DESCRIPCION DE LA ENTIDAD FINANCIERA
  -- PARAMETROS                  : - P_CODSBS | VARCHAR2(10)
  --                               - P_FECDES | DATE
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
    V_SALDOMAX NUMBER         := 0;
    V_ENTIDAD  VARCHAR2(5)    := NULL;
    V_CODEMP   VARCHAR2(1000) := NULL;

  CURSOR C_ENT IS
    SELECT C_CODEMP, SUM(N_SALCAP) SALDO, D_FECPRE
      FROM CLDRCCS S
     WHERE S.D_FECPRE = P_FECDES
       AND S.C_CODEMP <> '00104'
       AND S.C_CODSBS = P_CODSBS
       AND (REGEXP_LIKE(S.C_CUENTA,'^14.[1-6]') OR REGEXP_LIKE(S.C_CUENTA,'^81.302'))
     GROUP BY C_CODEMP, D_FECPRE;

  BEGIN
    FOR X IN C_ENT LOOP
      IF X.SALDO > V_SALDOMAX THEN
        V_SALDOMAX := X.SALDO;
        V_ENTIDAD  := X.C_CODEMP;
      END IF;
    END LOOP;
    
    BEGIN
      SELECT TRIM(A.C_DESEFI)
        INTO V_CODEMP
        FROM AHTBANC A
       WHERE A.C_CODEFI = V_ENTIDAD;
    EXCEPTION
       WHEN OTHERS THEN
          NULL;
    END;
    
    RETURN V_CODEMP;
  END FN_ENTRCC_NOCAJA2;

END PQ_CR_COMPLIANCE_PREVENCION;
/

