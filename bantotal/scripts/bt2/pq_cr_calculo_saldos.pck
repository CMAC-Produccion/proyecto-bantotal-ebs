CREATE OR REPLACE PACKAGE PQ_CR_CALCULO_SALDOS IS
  
  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_CALCULO_SALDOS
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 16/10/2024
  -- AUTOR DE CREACION           : HSUAREZ
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- **************************************************************************************
  
  PROCEDURE SP_OBTENER_SALDO_SBS(
                                  PN_PAIS   IN NUMBER,
                                  PN_TIPDOC IN NUMBER,
                                  PC_NUMDOC IN CHAR,                          
                                  VO_RPTA OUT CHAR
                                );
  PROCEDURE SP_OBTENER_SALDO_SBS_CONYUGE(
                                  PN_PAIS   IN NUMBER,
                                  PN_TIPDOC IN NUMBER,
                                  PC_NUMDOC IN CHAR,                         
                                  VO_RPTA OUT CHAR
                                );
END PQ_CR_CALCULO_SALDOS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CALCULO_SALDOS IS

  PROCEDURE SP_OBTENER_SALDO_SBS(
                                  PN_PAIS   IN NUMBER,
                                  PN_TIPDOC IN NUMBER,
                                  PC_NUMDOC IN CHAR,                         
                                  VO_RPTA OUT CHAR
                                ) IS
  
  -- **************************************************************************************
  -- NOMBRE                      : SP_OBTENER_SALDO_SBS
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 16/10/2024
  -- AUTOR DE CREACION           : HSUAREZ
  -- USO                         : RETORNA EL SALDO SBS DEL CLIENTE
  -- ESTADO					         : ACTIVO
  -- ACCESO                      : PUBLICO
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- **************************************************************************************
                  
    LD_FECRCC   DATE;
    LD_FECSIS   DATE;    
    LN_TIPODNI  NUMBER(2);
    LN_TIPORUC  NUMBER(2);
    LN_TIPOCEX  NUMBER(2);
    LC_C_TDOCID CHAR(1);

    LC_DOCIDE   VARCHAR(12);
    LC_CODSBS   VARCHAR(12);
  
    LN_TIPCEDIDENT NUMBER;
    LN_CONTADOR NUMBER := 0;
    LC_ENTIDAD VARCHAR2(50);
    LC_NOMPRG  VARCHAR2(10);
    VALOR      NUMBER;
    --DATOS_CONYUGE;
    VI_PAISC   NUMBER(3);
    VI_PETDOCC NUMBER(2);
    VI_PENDOCC CHAR(12);
    VI_RPTA VARCHAR(1);
    CURSOR SALDOS(VC_CODSBS IN CHAR, VD_FECRCC IN DATE) IS
      SELECT /*+ ALL_ROWS*/  /*C_CODEMP, C_DESEFI, */
         SUM(SALCAP0) SALCAP0,
         SUM(SALCAP1) SALCAP1,
         SUM(SALCAP2) SALCAP2,
         SUM(SALCAP3) SALCAP3,
         SUM(SALCAP4) SALCAP4,
         SUM(SALCAP5) SALCAP5            
         FROM (
         SELECT /*+ ALL_ROWS*/ DISTINCT A.D_FECPRE , A.C_CODEMP,T.C_DESEFI ,          
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -5) THEN SUM(A.N_SALCAP) END SALCAP0, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -4) THEN SUM(A.N_SALCAP) END SALCAP1, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -3) THEN SUM(A.N_SALCAP) END SALCAP2, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -2) THEN SUM(A.N_SALCAP) END SALCAP3, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -1) THEN SUM(A.N_SALCAP) END SALCAP4, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -0) THEN SUM(A.N_SALCAP) END SALCAP5,                       
          SUM(A.N_SALCAP) SALCAP         
           -- INTO LN_SALDO1
            FROM CLDRCCS A, AHTBANC T
           WHERE C_CODSBS = VC_CODSBS
             AND D_FECPRE BETWEEN ADD_MONTHS(VD_FECRCC, -5) AND ADD_MONTHS(VD_FECRCC, 0)
             AND (
                  C_CUENTA LIKE ('14_102%')--SE AGREGO AL FINAL DEL LIKE 02 PARA SOLO MICRO
               OR C_CUENTA LIKE ('14_402%') 
               OR C_CUENTA LIKE ('14_502%')
               OR C_CUENTA LIKE ('14_602%')
               OR C_CUENTA LIKE ('14_112%')--SE AGREGO AL FINAL DEL LIKE 02 PARA SOLO PEQUEÑA
               OR C_CUENTA LIKE ('14_412%') 
               OR C_CUENTA LIKE ('14_512%')
               OR C_CUENTA LIKE ('14_612%')
               OR C_CUENTA LIKE ('14_113%')--SE AGREGO AL FINAL DEL LIKE 02 PARA SOLO MEDIANA
               OR C_CUENTA LIKE ('14_413%') 
               OR C_CUENTA LIKE ('14_513%')
               OR C_CUENTA LIKE ('14_613%')
               --OR C_CUENTA LIKE ('81_3%')             
             )
             --AND ( T.C_DESEFI LIKE '%REACTIVA%' OR T.C_DESEFI LIKE '%CRECER%' OR T.C_DESEFI LIKE '%FONDOS%')
             AND T.C_CODEFI = A.C_CODEMP
             GROUP BY A.D_FECPRE ,A.C_CODEMP,T.C_DESEFI
             ORDER BY 1 );
             
  BEGIN
      LN_TIPODNI     := 21;
      LN_TIPORUC     := 9;
      LN_TIPOCEX     := 2;
      LN_TIPCEDIDENT := 10;-- MPOSTIGOC 29.06.2021
      --OBTENER FECHA DEL SISTEMA
      BEGIN
        SELECT  F.PGFAPE
          INTO LD_FECSIS
        FROM FST017 F WHERE F.PGCOD = 1;
       EXCEPTION WHEN OTHERS THEN
          LD_FECSIS := NULL;   
      END;
      --OBTENER FECHA DEL ULTIMO RCC
      BEGIN
        SELECT TO_DATE(TPNRO, 'dd.mm.yyyy')
          INTO LD_FECRCC
          FROM FST098
         WHERE PGCOD = 1
           AND TPCOD = 7647
           AND TPCORR = 12;
      EXCEPTION WHEN OTHERS THEN
          LD_FECRCC := NULL;   
      END;
      --------------------------------
      -- VALIDAR SI TIENE CONYUGE
      BEGIN
        --TABLA FSR002 - VICOD 66
        SELECT  R.RPPAIS,R.RPTDOC,R.RPNDOC
           INTO VI_PAISC, VI_PETDOCC, VI_PENDOCC
          FROM FSR002 R
         WHERE R.PEPAIS = PN_PAIS
           AND R.PETDOC = PN_TIPDOC
           AND R.PENDOC = PC_NUMDOC
           AND R.RPCCYG = 66;
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
              SELECT R.PEPAIS,R.PETDOC,R.PENDOC
              INTO VI_PAISC, VI_PETDOCC, VI_PENDOCC
              FROM FSR002 R
             WHERE R.RPPAIS = PN_PAIS
               AND R.RPTDOC = PN_TIPDOC
               AND R.RPNDOC = PC_NUMDOC
               AND R.RPCCYG = 66;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
      END;
      -- VALIDAR RCC CONYUGE
      ----------------------
      PQ_CR_CALCULO_SALDOS.SP_OBTENER_SALDO_SBS_CONYUGE(
                                                         VI_PAISC,
                                                         VI_PETDOCC,
                                                         VI_PENDOCC,
                                                         VI_RPTA
                                                       );
      IF VI_RPTA = 'S' THEN
        VO_RPTA := VI_RPTA;
        RETURN;
      END IF;
      --------------------------------
      --LD_FECRCC := '31/12/2022';
      --VALIDAR TIPO DE DOCUMENTO SBS
      IF PN_TIPDOC = LN_TIPODNI OR PN_TIPDOC <> LN_TIPORUC THEN
        IF PN_TIPDOC = LN_TIPODNI THEN
          LC_C_TDOCID := '1';
        END IF;
        IF PN_TIPDOC = LN_TIPOCEX OR PN_TIPDOC = LN_TIPCEDIDENT THEN
          LC_C_TDOCID := '2';
        END IF;
        IF PN_TIPDOC <> LN_TIPODNI AND PN_TIPDOC <> LN_TIPORUC AND LC_C_TDOCID IS NULL THEN
          --LC_C_TDOCID := TO_CHAR(PN_TIPDOC);
          ---2023.08.21 DCASTRO SE MODIFICO
          IF PN_TIPDOC > 10 THEN
               BEGIN
                 SELECT F.TP1NRO2
                   INTO LC_C_TDOCID
                   FROM FST198 F
                  WHERE F.TP1COD = 1
                    AND TP1COD1 = 11111
                    AND TP1CORR1 = 1
                    AND TP1CORR2 = 5
                    AND TP1NRO1 = PN_TIPDOC; -- GUIA DE EQUIVALENCIA DE TIPO DE DOC CON LA RCC
               EXCEPTION
                 WHEN OTHERS THEN
                   LC_C_TDOCID := NULL;
               END;
          ELSE
               LC_C_TDOCID := TO_CHAR(PN_TIPDOC);
          END IF;
          --2023.08.21 DCASTRO SE MODIFICO          
        END IF;    
      LC_DOCIDE := TRIM(PC_NUMDOC);    
      IF PN_TIPDOC = LN_TIPORUC THEN      
        BEGIN
          SELECT A.C_CODSBS
            INTO LC_CODSBS
            FROM CLDRCCI A
           WHERE C_DOCTRI = LC_DOCIDE
             AND D_FECPRE = LD_FECRCC
             AND ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            LC_CODSBS := NULL;
        END;
      ELSE      
        BEGIN
          SELECT A.C_CODSBS
            INTO LC_CODSBS
            FROM CLDRCCI A
           WHERE C_TDOCID = LC_C_TDOCID
             AND C_DOCIDE = LC_DOCIDE
             AND D_FECPRE = LD_FECRCC
             AND ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            LC_CODSBS := NULL;
        END;      
      END IF;      
      --OBTENER LOS SALDOS.
      FOR I IN SALDOS(LC_CODSBS, LD_FECRCC) LOOP                
          IF NVL(I.SALCAP5,0) > NVL(I.SALCAP4,0) THEN
             LN_CONTADOR := LN_CONTADOR + 1;
          END IF;
          IF NVL(I.SALCAP4,0) > NVL(I.SALCAP3,0) THEN
             LN_CONTADOR := LN_CONTADOR + 1;
          END IF;  
      END LOOP;
      
      END IF;
      --
      IF LN_CONTADOR > 0 THEN
        VO_RPTA := 'S';
      ELSE        
        VO_RPTA := 'N';
      END IF;
  END;
  
  PROCEDURE SP_OBTENER_SALDO_SBS_CONYUGE(
                                  PN_PAIS   IN NUMBER,
                                  PN_TIPDOC IN NUMBER,
                                  PC_NUMDOC IN CHAR,                         
                                  VO_RPTA OUT CHAR
                                ) IS      
  
  -- **************************************************************************************
  -- NOMBRE                      : SP_OBTENER_SALDO_SBS_CONYUGE
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 16/10/2024
  -- AUTOR DE CREACION           : HSUAREZ
  -- USO                         : RETORNA EL SALDO SBS DEL CONYUGUE
  -- ESTADO					         : ACTIVO
  -- ACCESO                      : PUBLICO
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- **************************************************************************************
                          
    LD_FECRCC   DATE;
    LD_FECSIS   DATE;    
    LN_TIPODNI  NUMBER(2);
    LN_TIPORUC  NUMBER(2);
    LN_TIPOCEX  NUMBER(2);
    LC_C_TDOCID CHAR(1);

    LC_DOCIDE   VARCHAR(12);
    LC_CODSBS   VARCHAR(12);
  
    LN_TIPCEDIDENT NUMBER;
    LN_CONTADOR NUMBER := 0;
    LC_ENTIDAD VARCHAR2(50);
    LC_NOMPRG  VARCHAR2(10);
    VALOR      NUMBER;
    --DATOS_CONYUGE;
    
    
    CURSOR SALDOS(VC_CODSBS IN CHAR, VD_FECRCC IN DATE) IS
      SELECT /*+ ALL_ROWS*/  /*C_CODEMP, C_DESEFI, */
         SUM(SALCAP0) SALCAP0,
         SUM(SALCAP1) SALCAP1,
         SUM(SALCAP2) SALCAP2,
         SUM(SALCAP3) SALCAP3,
         SUM(SALCAP4) SALCAP4,
         SUM(SALCAP5) SALCAP5            
         FROM (
         SELECT /*+ ALL_ROWS*/ DISTINCT A.D_FECPRE , A.C_CODEMP,T.C_DESEFI ,          
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -5) THEN SUM(A.N_SALCAP) END SALCAP0, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -4) THEN SUM(A.N_SALCAP) END SALCAP1, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -3) THEN SUM(A.N_SALCAP) END SALCAP2, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -2) THEN SUM(A.N_SALCAP) END SALCAP3, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -1) THEN SUM(A.N_SALCAP) END SALCAP4, 
          CASE WHEN A.D_FECPRE =  ADD_MONTHS(VD_FECRCC, -0) THEN SUM(A.N_SALCAP) END SALCAP5,                       
          SUM(A.N_SALCAP) SALCAP         
           -- INTO LN_SALDO1
            FROM CLDRCCS A, AHTBANC T
           WHERE C_CODSBS = VC_CODSBS
             AND D_FECPRE BETWEEN ADD_MONTHS(VD_FECRCC, -5) AND ADD_MONTHS(VD_FECRCC, 0)
             AND (
                  C_CUENTA LIKE ('14_102%')--SE AGREGO AL FINAL DEL LIKE 02 PARA SOLO MICRO
               OR C_CUENTA LIKE ('14_402%') 
               OR C_CUENTA LIKE ('14_502%')
               OR C_CUENTA LIKE ('14_602%')
               OR C_CUENTA LIKE ('14_112%')--SE AGREGO AL FINAL DEL LIKE 02 PARA SOLO PEQUEÑA
               OR C_CUENTA LIKE ('14_412%') 
               OR C_CUENTA LIKE ('14_512%')
               OR C_CUENTA LIKE ('14_612%')
               OR C_CUENTA LIKE ('14_113%')--SE AGREGO AL FINAL DEL LIKE 02 PARA SOLO MEDIANA
               OR C_CUENTA LIKE ('14_413%') 
               OR C_CUENTA LIKE ('14_513%')
               OR C_CUENTA LIKE ('14_613%')
               --OR C_CUENTA LIKE ('81_3%')             
             )
             --AND ( T.C_DESEFI LIKE '%REACTIVA%' OR T.C_DESEFI LIKE '%CRECER%' OR T.C_DESEFI LIKE '%FONDOS%')
             AND T.C_CODEFI = A.C_CODEMP
             GROUP BY A.D_FECPRE ,A.C_CODEMP,T.C_DESEFI
             ORDER BY 1 );
             
  BEGIN
      LN_TIPODNI     := 21;
      LN_TIPORUC     := 9;
      LN_TIPOCEX     := 2;
      LN_TIPCEDIDENT := 10;-- MPOSTIGOC 29.06.2021
      --OBTENER FECHA DEL SISTEMA
      BEGIN
        SELECT  F.PGFAPE
          INTO LD_FECSIS
        FROM FST017 F WHERE F.PGCOD = 1;
       EXCEPTION WHEN OTHERS THEN
          LD_FECSIS := NULL;   
      END;
      --OBTENER FECHA DEL ULTIMO RCC
      BEGIN
        SELECT TO_DATE(TPNRO, 'dd.mm.yyyy')
          INTO LD_FECRCC
          FROM FST098
         WHERE PGCOD = 1
           AND TPCOD = 7647
           AND TPCORR = 12;
      EXCEPTION WHEN OTHERS THEN
          LD_FECRCC := NULL;   
      END;
      
      --LD_FECRCC := '31/12/2022';
      --VALIDAR TIPO DE DOCUMENTO SBS
      IF PN_TIPDOC = LN_TIPODNI OR PN_TIPDOC <> LN_TIPORUC THEN
        IF PN_TIPDOC = LN_TIPODNI THEN
          LC_C_TDOCID := '1';
        END IF;
        IF PN_TIPDOC = LN_TIPOCEX OR PN_TIPDOC = LN_TIPCEDIDENT THEN
          LC_C_TDOCID := '2';
        END IF;
        IF PN_TIPDOC <> LN_TIPODNI AND PN_TIPDOC <> LN_TIPORUC AND LC_C_TDOCID IS NULL THEN
          --LC_C_TDOCID := TO_CHAR(PN_TIPDOC);
          ---2023.08.21 DCASTRO SE MODIFICO
          IF PN_TIPDOC > 10 THEN
               BEGIN
                 SELECT F.TP1NRO2
                   INTO LC_C_TDOCID
                   FROM FST198 F
                  WHERE F.TP1COD = 1
                    AND TP1COD1 = 11111
                    AND TP1CORR1 = 1
                    AND TP1CORR2 = 5
                    AND TP1NRO1 = PN_TIPDOC; -- GUIA DE EQUIVALENCIA DE TIPO DE DOC CON LA RCC
               EXCEPTION
                 WHEN OTHERS THEN
                   LC_C_TDOCID := NULL;
               END;
          ELSE
               LC_C_TDOCID := TO_CHAR(PN_TIPDOC);
          END IF;
          --2023.08.21 DCASTRO SE MODIFICO          
        END IF;    
      LC_DOCIDE := TRIM(PC_NUMDOC);    
      IF PN_TIPDOC = LN_TIPORUC THEN      
        BEGIN
          SELECT A.C_CODSBS
            INTO LC_CODSBS
            FROM CLDRCCI A
           WHERE C_DOCTRI = LC_DOCIDE
             AND D_FECPRE = LD_FECRCC
             AND ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            LC_CODSBS := NULL;
        END;
      ELSE      
        BEGIN
          SELECT A.C_CODSBS
            INTO LC_CODSBS
            FROM CLDRCCI A
           WHERE C_TDOCID = LC_C_TDOCID
             AND C_DOCIDE = LC_DOCIDE
             AND D_FECPRE = LD_FECRCC
             AND ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            LC_CODSBS := NULL;
        END;      
      END IF;      
      --OBTENER LOS SALDOS.
      FOR I IN SALDOS(LC_CODSBS, LD_FECRCC) LOOP                
          IF NVL(I.SALCAP5,0) > NVL(I.SALCAP4,0) THEN
             LN_CONTADOR := LN_CONTADOR + 1;
          END IF;
          IF NVL(I.SALCAP4,0) > NVL(I.SALCAP3,0) THEN
             LN_CONTADOR := LN_CONTADOR + 1;
          END IF;  
      END LOOP;
      
      END IF;
      --
      IF LN_CONTADOR > 0 THEN
        VO_RPTA := 'S';
      ELSE        
        VO_RPTA := 'N';
      END IF;
  END;
 
END PQ_CR_CALCULO_SALDOS;
/

