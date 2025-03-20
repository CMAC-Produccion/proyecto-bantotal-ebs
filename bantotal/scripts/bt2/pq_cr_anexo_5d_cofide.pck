CREATE OR REPLACE PACKAGE PQ_CR_ANEXO_5D_COFIDE IS
   
   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_ANEXO_5D_COFIDE
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 10/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************   

   PROCEDURE SP_CR_INFORMACION_ADICIONAL_5D;

END PQ_CR_ANEXO_5D_COFIDE;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_ANEXO_5D_COFIDE IS

   PROCEDURE SP_CR_INFORMACION_ADICIONAL_5D IS
      
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_INFORMACION_ADICIONAL_5D
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 10/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA INFORMACION ADICIONAL ANEXO 5D
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      EMPRESA_CREDITO      NUMBER(3);
      MODULO_CREDITO       NUMBER(3);
      SUCURSAL_CREDITO     NUMBER(3);
      MONEDA_CREDITO       NUMBER(4);
      PAPEL_CREDITO        NUMBER(4);
      CUENTA_CREDITO       NUMBER(9);
      OPERACION_CREDITO    NUMBER(9);
      SBOPER_CREDITO       NUMBER(3);
      TPOPER_CREDITO       NUMBER(3);
      TOTAL_CUOTAS         NUMBER(9);
      TOTAL_CUOTAS_PAGA    NUMBER(9);
      TOTAL_CUOTAS_PEND    NUMBER(9);
      TOTAL_CUOTAS_VENC    NUMBER(9);
      NRO_ENTIDADES        NUMBER(3);
      PAIS_DOCUMENTO       NUMBER(3);
      RPLEGAL_TIPO_DOC     NUMBER(3);
      TIPO_DOCUMENTO       NUMBER(2);
      CODIGO_CIIU          NUMBER(9);
      CODIGO_DEPARTAMENTO  NUMBER(5);
      CODIGO_PROVINCIA     NUMBER(5);
      CODIGO_DISTRITO      NUMBER(9);
      INSTANCIA            NUMBER(10);
      NRO70                NUMBER(10);
      EVAL71               NUMBER(10);
      RUBRO_CREDITO        NUMBER(16);
      CONTADOR             NUMBER(17);
      CORRELATIVO          NUMBER(17);
      TASA_INTERES         NUMBER(10, 6);
      CALIFICACION_NORMAL  NUMBER(5, 2);
      CALIFICACION_CPP     NUMBER(5, 2);
      CALIFICACION_DEFICI  NUMBER(5, 2);
      CALIFICACION_DUDOSO  NUMBER(5, 2);
      CALIFICACION_PERDIDA NUMBER(5, 2);
      TIPO_CAMBIO_DOLAR    NUMBER(14, 8);
      MONTO_DESEMBOLSO     NUMBER(17, 2);
      SALDO_MONEDA_ORIG    NUMBER(17, 2);
      SALDO_TOTAL          NUMBER(17, 2);
      SALDO_GARANTIA       NUMBER(17, 2);
      VENTAS               NUMBER(17, 2);
      
      TIPO_PERSONA        VARCHAR2(1);
      EXISTE_FSD004       VARCHAR2(1);
      RPLEGAL_SEXO        VARCHAR2(1);
      HORA_SISTEMA        VARCHAR2(8);
      CODIGO_SBS          VARCHAR2(10);
      NRO_DOCUMENTO       VARCHAR2(12);
      RPLEGAL_NRO_DOC     VARCHAR2(12);
      MODALIDAD           VARCHAR2(20);
      REPROGRAMADO        VARCHAR2(1);
      NRO_CREDITO         VARCHAR2(25);
      SIGNO_MONEDA        VARCHAR2(25);
      SEXO_CLIENTE        VARCHAR2(25);
      NOMBRE_TIPO_DOC     VARCHAR2(25);
      NOMBRE_TIPO_PERSONA VARCHAR2(25);
      NOMBRE_PAIS         VARCHAR2(30);
      CALIFICACION_SBS    VARCHAR2(15);
      NOMBRE_MODULO       VARCHAR2(30);
      NOMBRE_TIPO_OPER    VARCHAR2(30);
      RPLEGAL_CARGO       VARCHAR2(30);
      NOMBRE_CIIU         VARCHAR2(100);
      RPLEGAL_NOMBRE      VARCHAR2(100);
      CADENA_VAL          VARCHAR2(100);
      TIPO_CREDITO        VARCHAR2(100);
      NOMBRE_CLIENTE      VARCHAR2(100);
      SITUACION_CONTABLE  VARCHAR2(100);
      NOMBRE_DIRECCION    VARCHAR2(150);
      NOMBRE_DISTRITO     VARCHAR2(150);
      NOMBRE_PROVINCIA    VARCHAR2(150);
      NOMBRE_DEPARTAMENTO VARCHAR2(150);
      NOMBRE_PARTIDA      VARCHAR2(500);
      TIPOS_GARANTIAS     VARCHAR2(500);
      NOMBRE_GARANTIA     VARCHAR2(500);
      GARANTIAS_PARTIDAS  VARCHAR2(500);
      
      
      FECHA_NACIMIENTO DATE;
      FECHA_APROBACION DATE;
      FECHA_DESEMBOLSO DATE;
      FECHA_VENC_DESMB DATE;
      FECHA_CIERRE     DATE;
      FECHA_SISTEMA    DATE;
      PERIODO_VENTAS   DATE;
      
      CURSOR BANDEJAS IS 
         SELECT * FROM USRBNDJ.AQPC758;
         
      CURSOR GARANTIAS_FSR011(EMPRESA_CREDITO   NUMBER, 
                              MODULO_CREDITO    NUMBER, 
                              SUCURSAL_CREDITO  NUMBER, 
                              MONEDA_CREDITO    NUMBER, 
                              PAPEL_CREDITO     NUMBER, 
                              CUENTA_CREDITO    NUMBER, 
                              OPERACION_CREDITO NUMBER, 
                              SBOPER_CREDITO    NUMBER, 
                              TPOPER_CREDITO    NUMBER) IS
         SELECT DISTINCT R2MOD, R2MDA, R2PAP, R2TOPE
           FROM FSR011
          WHERE R1COD  = EMPRESA_CREDITO  
            AND R1MOD  = MODULO_CREDITO   
            AND R1SUC  = SUCURSAL_CREDITO 
            AND R1MDA  = MONEDA_CREDITO   
            AND R1PAP  = PAPEL_CREDITO    
            AND R1CTA  = CUENTA_CREDITO   
            AND R1OPER = OPERACION_CREDITO
            AND R1SBOP = SBOPER_CREDITO   
            AND R1TOPE = TPOPER_CREDITO    
            AND RELCOD = 50
            AND R011CO = 'S';

      CURSOR GARANTIAS_SNG122(INSTANCIA NUMBER) IS
         SELECT DISTINCT SNG122MOD, SNG122MDA, SNG122PAP, SNG122TOPE
           FROM SNG122
          WHERE SNG122INST  = INSTANCIA;
          
      CURSOR GARANTIAS_PPG001(EMPRESA        NUMBER, 
                              MODULO         NUMBER, 
                              SUCURSAL       NUMBER, 
                              MONEDA         NUMBER, 
                              PAPEL          NUMBER, 
                              CUENTA         NUMBER, 
                              OPERACION      NUMBER, 
                              SUBOPERACION   NUMBER, 
                              TIPO_OPERACION NUMBER) IS
         SELECT C.PPG001DATO
           FROM FSR011 A, FSD010 B, PPG001 C
          WHERE A.R1COD      = EMPRESA
            AND A.R1MOD      = MODULO
            AND A.R1SUC      = SUCURSAL
            AND A.R1MDA      = MONEDA
            AND A.R1PAP      = PAPEL
            AND A.R1CTA      = CUENTA
            AND A.R1OPER     = OPERACION
            AND A.R1SBOP     = SUBOPERACION
            AND A.R1TOPE     = TIPO_OPERACION
            AND A.RELCOD     = 50
            AND B.PGCOD      = A.R2COD 
            AND B.AOMOD      = A.R2MOD 
            AND B.AOSUC      = A.R2SUC 
            AND B.AOMDA      = A.R2MDA 
            AND B.AOPAP      = A.R2PAP 
            AND B.AOCTA      = A.R2CTA 
            AND B.AOOPER     = A.R2OPER
            AND B.AOSBOP     = A.R2SBOP
            AND B.AOTOPE     = A.R2TOPE
            AND C.PPG001COD  = B.PGCOD 
            AND C.PPG001MOD  = 470
            AND C.PPG001SUC  = B.AOSUC 
            AND C.PPG001MDA  = B.AOMDA 
            AND C.PPG001PAP  = B.AOPAP 
            AND C.PPG001CTA  = B.AOCTA 
            AND C.PPG001OPE  = B.AOOPER
            AND C.PPG001SBO  = B.AOSBOP
            AND C.PPG001TOP  = B.AOTOPE
            AND C.PPG001CDAT = 129
            AND C.PPG001DATO IS NOT NULL
            AND C.PPG001FRM  = (SELECT MAX(PPG000FRM)
                                  FROM PPG000
                                 WHERE PPG000PGC = B.PGCOD 
                                   AND PPG000MOD = 470
                                   AND PPG000SUC = B.AOSUC 
                                   AND PPG000MDA = B.AOMDA 
                                   AND PPG000PAP = B.AOPAP 
                                   AND PPG000CTA = B.AOCTA 
                                   AND PPG000OPE = B.AOOPER
                                   AND PPG000SBO = B.AOSBOP
                                   AND PPG000TOP = B.AOTOPE
                                   AND PPG000TCO = 'S');
   BEGIN
      BEGIN
         SELECT PGFCIE, PGFAPE
           INTO FECHA_CIERRE, FECHA_SISTEMA
           FROM FST017 
          WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      FOR J IN BANDEJAS LOOP
         HORA_SISTEMA := NULL;
         HORA_SISTEMA := TO_CHAR(SYSDATE, 'HH24:MI:SS');
      
         EMPRESA_CREDITO   := NULL;
         MODULO_CREDITO    := NULL;
         SUCURSAL_CREDITO  := NULL;
         MONEDA_CREDITO    := NULL;
         PAPEL_CREDITO     := NULL;
         CUENTA_CREDITO    := NULL;
         OPERACION_CREDITO := NULL;
         SBOPER_CREDITO    := NULL;
         TPOPER_CREDITO    := NULL;
         MONTO_DESEMBOLSO  := NULL;
         FECHA_DESEMBOLSO  := NULL;
         FECHA_VENC_DESMB  := NULL;
         BEGIN
            SELECT PGCOD, AOMOD, AOSUC, AOMDA, AOPAP,  
                   AOCTA, AOOPER, AOSBOP, AOTOPE, AOIMP,  
                   AOFVAL, AOFVTO
              INTO EMPRESA_CREDITO, MODULO_CREDITO, SUCURSAL_CREDITO, 
                   MONEDA_CREDITO, PAPEL_CREDITO, CUENTA_CREDITO, 
                   OPERACION_CREDITO, SBOPER_CREDITO, TPOPER_CREDITO, 
                   MONTO_DESEMBOLSO, FECHA_DESEMBOLSO, FECHA_VENC_DESMB
              FROM FSD010
             WHERE AOCTA  = J.AQPC758CTA
               AND AOOPER = J.AQPC758OPER
               AND AOMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NRO_CREDITO := NULL;
         NRO_CREDITO := (LPAD(TRIM(TO_CHAR(CUENTA_CREDITO)), 9, '0') || '-' ||
                         LPAD(TRIM(TO_CHAR(OPERACION_CREDITO)), 9, '0'));
         
         INSTANCIA := NULL;
         BEGIN
            SELECT XWFPRCINS
              INTO INSTANCIA
              FROM XWF700
             WHERE XWFEMPRESA   = EMPRESA_CREDITO
               AND XWFSUCURSAL  = SUCURSAL_CREDITO
               AND XWFMODULO    = MODULO_CREDITO
               AND XWFMONEDA    = MONEDA_CREDITO
               AND XWFPAPEL     = PAPEL_CREDITO
               AND XWFCUENTA    = CUENTA_CREDITO
               AND XWFOPERACION = OPERACION_CREDITO
               AND XWFSUBOPE    = SBOPER_CREDITO
               AND XWFTIPOPE    = TPOPER_CREDITO
               AND XWFCAR3      = '1';
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         TASA_INTERES := 0;
         BEGIN
            SELECT A.EVTASA
              INTO TASA_INTERES
              FROM FSD012 A
             WHERE A.PGCOD  = EMPRESA_CREDITO
               AND A.AOMOD  = MODULO_CREDITO
               AND A.AOSUC  = SUCURSAL_CREDITO
               AND A.AOMDA  = MONEDA_CREDITO
               AND A.AOPAP  = PAPEL_CREDITO
               AND A.AOCTA  = CUENTA_CREDITO
               AND A.AOOPER = OPERACION_CREDITO
               AND A.AOSBOP = SBOPER_CREDITO
               AND A.AOTOPE = TPOPER_CREDITO
               AND A.EVTIPO = 3
               AND A.D012CO = 'S'
               AND A.EVFVAL = (SELECT MAX(A1.EVFVAL) 
                                 FROM FSD012 A1
                                WHERE A1.PGCOD  = A.PGCOD 
                                  AND A1.AOMOD  = A.AOMOD 
                                  AND A1.AOSUC  = A.AOSUC 
                                  AND A1.AOMDA  = A.AOMDA 
                                  AND A1.AOPAP  = A.AOPAP 
                                  AND A1.AOCTA  = A.AOCTA 
                                  AND A1.AOOPER = A.AOOPER
                                  AND A1.AOSBOP = A.AOSBOP
                                  AND A1.AOTOPE = A.AOTOPE
                                  AND A1.EVTIPO = A.EVTIPO
                                  AND A1.D012CO = A.D012CO);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               BEGIN
                  SELECT A.AOTASA
                    INTO TASA_INTERES
                    FROM FSD010 A
                   WHERE A.PGCOD  = EMPRESA_CREDITO
                     AND A.AOMOD  = MODULO_CREDITO
                     AND A.AOSUC  = SUCURSAL_CREDITO
                     AND A.AOMDA  = MONEDA_CREDITO
                     AND A.AOPAP  = PAPEL_CREDITO
                     AND A.AOCTA  = CUENTA_CREDITO
                     AND A.AOOPER = OPERACION_CREDITO
                     AND A.AOSBOP = SBOPER_CREDITO
                     AND A.AOTOPE = TPOPER_CREDITO
                     AND A.AOSTAT <> 99;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            WHEN OTHERS THEN
               NULL;
         END;
         
         SALDO_GARANTIA := 0;
         BEGIN
            SELECT A.SNG122SDOG
              INTO SALDO_GARANTIA
              FROM SNG122 A
             WHERE A.SNG122INST = INSTANCIA;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NOMBRE_MODULO := NULL;
         BEGIN
            SELECT TRIM(MDNOM)
              INTO NOMBRE_MODULO
              FROM FST003 A
             WHERE A.MODULO = MODULO_CREDITO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NOMBRE_TIPO_OPER := NULL;
         BEGIN
            SELECT TRIM(TONOM)
              INTO NOMBRE_TIPO_OPER
              FROM FST004 A
             WHERE A.MODULO = MODULO_CREDITO 
               AND A.TOTOPE = TPOPER_CREDITO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NOMBRE_CLIENTE := NULL;
         BEGIN
            SELECT TRIM(A.CTNOM)
              INTO NOMBRE_CLIENTE
              FROM FSD008 A
             WHERE A.CTNRO = CUENTA_CREDITO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
                  
         CALIFICACION_SBS := NULL;
         BEGIN
            SELECT TRIM(B.CATCATE)
              INTO CALIFICACION_SBS
              FROM FSD212 A, FSR212 B
             WHERE A.PGCOD     = 1
               AND A.CATCTA    = CUENTA_CREDITO
               AND A.CATCOD    = 4
               AND A.CATFCHDES = FECHA_CIERRE
               AND B.CATCATE   = A.CATCATEG
               AND B.CATCOD    = 4;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
              
         SIGNO_MONEDA := NULL;
         BEGIN
            SELECT TRIM(MOSIGN)
              INTO SIGNO_MONEDA
              FROM FST005
             WHERE MONEDA = MONEDA_CREDITO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;

         SALDO_MONEDA_ORIG := 0;
         BEGIN
            SELECT SCSDO, 
                   CASE 
                      WHEN SUBSTR(TRIM(TO_CHAR(SCRUB)), 1, 2) = '14' AND SUBSTR(TRIM(TO_CHAR(SCRUB)), 4, 1) = '1' THEN
                         'VIGENTE'
                      WHEN SUBSTR(TRIM(TO_CHAR(SCRUB)), 1, 2) = '14' AND SUBSTR(TRIM(TO_CHAR(SCRUB)), 4, 1) = '4' THEN
                         'REFINANCIADO'
                      WHEN SUBSTR(TRIM(TO_CHAR(SCRUB)), 1, 2) = '14' AND SUBSTR(TRIM(TO_CHAR(SCRUB)), 4, 1) = '5' THEN
                         'VENCIDO'
                      WHEN SUBSTR(TRIM(TO_CHAR(SCRUB)), 1, 2) = '14' AND SUBSTR(TRIM(TO_CHAR(SCRUB)), 4, 1) = '6' THEN
                         'JUDICIAL'
                      ELSE
                         ' '
                   END,
                   SCRUB
              INTO SALDO_MONEDA_ORIG, SITUACION_CONTABLE, RUBRO_CREDITO
              FROM FSD011
             WHERE PGCOD  = EMPRESA_CREDITO
               AND SCMOD  = MODULO_CREDITO
               AND SCMDA  = MONEDA_CREDITO
               AND SCPAP  = PAPEL_CREDITO
               AND SCCTA  = CUENTA_CREDITO
               AND SCSUC  = SUCURSAL_CREDITO
               AND SCOPER = OPERACION_CREDITO
               AND SCSBOP = SBOPER_CREDITO
               AND SCTOPE = TPOPER_CREDITO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         IF MONEDA_CREDITO = 101 THEN
            TIPO_CAMBIO_DOLAR := 0;
            SALDO_TOTAL       := 0;
            BEGIN
               TIPO_CAMBIO_DOLAR := FN_TIPO_CAMBIO_FIJO(P_FECHA => FECHA_SISTEMA);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            
            SALDO_TOTAL := SALDO_MONEDA_ORIG / TIPO_CAMBIO_DOLAR;
         END IF;
                  
         PAIS_DOCUMENTO   := NULL;
         TIPO_DOCUMENTO   := NULL;
         NRO_DOCUMENTO    := NULL;
         BEGIN
            SELECT A.PEPAIS, A.PETDOC, A.PENDOC
              INTO PAIS_DOCUMENTO, TIPO_DOCUMENTO, NRO_DOCUMENTO
              FROM FSR008 A
             WHERE A.CTNRO  = CUENTA_CREDITO
               AND A.CTTFIR = 'T';
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         SEXO_CLIENTE     := NULL;
         FECHA_NACIMIENTO := NULL;
         BEGIN
            SELECT A.PFCANT, A.PFFNAC
              INTO SEXO_CLIENTE, FECHA_NACIMIENTO
              FROM FSD002 A
             WHERE A.PFPAIS = PAIS_DOCUMENTO
               AND A.PFTDOC = TIPO_DOCUMENTO
               AND A.PFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         CODIGO_CIIU    := NULL;
         NOMBRE_CIIU    := NULL;
         BEGIN
            PQ_CR_ACTUALIZA_CIIU.SP_CR_CIIUACTUAL(LN_PAIS     => PAIS_DOCUMENTO,
                                                  LN_TDOC     => TIPO_DOCUMENTO,
                                                  LC_NDOC     => NRO_DOCUMENTO,
                                                  LN_CODCIIU  => CODIGO_CIIU,
                                                  LC_DESCCIIU => NOMBRE_CIIU);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         CODIGO_SBS := NULL;
         BEGIN
            SELECT TRIM(TO_CHAR(A.BC739SBS))
              INTO CODIGO_SBS
              FROM FBC739 A
             WHERE A.BC739CTA = CUENTA_CREDITO;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               BEGIN
                  SELECT TRIM(TO_CHAR(A.BC739SBS))
                    INTO CODIGO_SBS
                    FROM FBC739 A
                   WHERE A.BC739PAIS = PAIS_DOCUMENTO
                     AND A.BC739TDOC = TIPO_DOCUMENTO
                     AND A.BC739NDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            WHEN OTHERS THEN
               NULL;
         END;
         
         CALIFICACION_NORMAL  := 0;
         CALIFICACION_CPP     := 0;
         CALIFICACION_DEFICI  := 0;
         CALIFICACION_DUDOSO  := 0;
         CALIFICACION_PERDIDA := 0;
         NRO_ENTIDADES        := 0;
         BEGIN
            SELECT N_CALIF0, N_CALIF1, N_CALIF2, 
                   N_CALIF3, N_CALIF4, N_CANENT
              INTO CALIFICACION_NORMAL, CALIFICACION_CPP, CALIFICACION_DEFICI,
                   CALIFICACION_DUDOSO, CALIFICACION_PERDIDA, NRO_ENTIDADES
              FROM CLDRCCI
             WHERE C_CODSBS = CODIGO_SBS
               AND D_FECPRE = (SELECT TO_DATE(TPNRO, 'DD/MM/RRRR')
                                 FROM FST098
                                WHERE PGCOD  = 1
                                  AND TPCOD  = 7647
                                  AND TPCORR = 12);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         CODIGO_DEPARTAMENTO := NULL;
         CODIGO_PROVINCIA    := NULL;
         CODIGO_DISTRITO     := NULL;
         NOMBRE_DIRECCION    := NULL;
         BEGIN
            SELECT A.SNGC13DPTO, A.SNGC13PROV, A.SNGC13DIST,
                   TRIM(A.SNGC13DIR)
              INTO CODIGO_DEPARTAMENTO, CODIGO_PROVINCIA,
                   CODIGO_DISTRITO, NOMBRE_DIRECCION
              FROM SNGC13 A
             WHERE A.SNGC13PAIS = PAIS_DOCUMENTO
               AND A.SNGC13TDOC = TIPO_DOCUMENTO
               AND A.SNGC13NDOC = RPAD(NRO_DOCUMENTO, 12, ' ')
               AND A.DOCOD      = 1
               AND A.SNGC13EST  = 'H';
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NOMBRE_DEPARTAMENTO := NULL;
         BEGIN
            SELECT TRIM(A.DEPNOM)
              INTO NOMBRE_DEPARTAMENTO
              FROM FST068 A
             WHERE A.PAIS   = PAIS_DOCUMENTO
               AND A.DEPCOD = CODIGO_DEPARTAMENTO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
           
         NOMBRE_PROVINCIA := NULL;
         BEGIN
            SELECT TRIM(A.LOCNOM)
              INTO NOMBRE_PROVINCIA
              FROM FST070 A
             WHERE A.PAIS   = PAIS_DOCUMENTO
               AND A.DEPCOD = CODIGO_DEPARTAMENTO
               AND A.LOCCOD = CODIGO_PROVINCIA;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NOMBRE_DISTRITO := NULL;
         BEGIN
            SELECT TRIM(A.FST071DSC)
              INTO NOMBRE_DISTRITO
              FROM FST071 A
             WHERE A.FST071PAI = PAIS_DOCUMENTO
               AND A.FST071DPT = CODIGO_DEPARTAMENTO
               AND A.FST071LOC = CODIGO_PROVINCIA
               AND A.FST071COL = CODIGO_DISTRITO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NOMBRE_TIPO_DOC := NULL;
         BEGIN
            SELECT CASE
                      WHEN TDOCUM = 9 THEN 'RUC'
                      WHEN TDOCUM = 21 THEN 'DNI'
                      ELSE TRIM(TDNOM)
                   END
              INTO NOMBRE_TIPO_DOC
              FROM FST014
             WHERE TDOCUM = TIPO_DOCUMENTO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NOMBRE_PAIS := NULL;
         BEGIN
            SELECT TRIM(A.PANOM)
              INTO NOMBRE_PAIS
              FROM FST013 A
             WHERE A.PAIS = PAIS_DOCUMENTO;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         FECHA_APROBACION := NULL;
         BEGIN
            SELECT TRUNC(WFITEMEND)
              INTO FECHA_APROBACION
              FROM WFWRKITEMS
             WHERE WFTASKCOD  = 11
               AND WFSTSCOD   = 'C'
               AND WFINSPRCID = INSTANCIA;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         MODALIDAD := NULL;
         BEGIN
            MODALIDAD := PQ_DATOS_SBS_2023.FN_MDCR(PN_EMP    => EMPRESA_CREDITO,
                                                   PN_MOD    => MODULO_CREDITO,
                                                   PN_SUC    => SUCURSAL_CREDITO,
                                                   PN_MDA    => MONEDA_CREDITO,
                                                   PN_PAP    => PAPEL_CREDITO,
                                                   PN_CTA    => CUENTA_CREDITO,
                                                   PN_OPER   => OPERACION_CREDITO,
                                                   PN_SBOP   => SBOPER_CREDITO,
                                                   PN_TOP    => TPOPER_CREDITO,
                                                   PD_FECPRO => FECHA_CIERRE,
                                                   PN_RUBRO  => RUBRO_CREDITO,
                                                   PN_STAT   => 0,
                                                   PN_INSTAC => INSTANCIA,
                                                   PC_INDAMP => 'N',
                                                   PN_NUMRPR => 0,
                                                   PN_PAIS   => PAIS_DOCUMENTO,
                                                   PN_TIPDOC => TIPO_DOCUMENTO,
                                                   PC_NUMDOC => NRO_DOCUMENTO);
            
            IF (MODALIDAD = 'COVID_19' OR MODALIDAD = 'REP_CAMBIO_FECHA' OR MODALIDAD = 'REP_DESASTRES') THEN
               REPROGRAMADO := 'S';
            ELSE
               REPROGRAMADO := 'N';
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         TOTAL_CUOTAS := 0;
         BEGIN
            SELECT COUNT(*)
              INTO TOTAL_CUOTAS
              FROM FSD601
             WHERE PGCOD  = EMPRESA_CREDITO
               AND PPMOD  = MODULO_CREDITO
               AND PPSUC  = SUCURSAL_CREDITO
               AND PPMDA  = MONEDA_CREDITO
               AND PPPAP  = PAPEL_CREDITO
               AND PPCTA  = CUENTA_CREDITO
               AND PPOPER = OPERACION_CREDITO
               AND PPSBOP = SBOPER_CREDITO
               AND PPTOPE = TPOPER_CREDITO
               AND D601CO = 'S';
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         TOTAL_CUOTAS_PAGA := 0;
         BEGIN
            SELECT COUNT(*)
              INTO TOTAL_CUOTAS_PAGA
              FROM (SELECT *
                      FROM FSD601 A, FSD602 B
                     WHERE A.PGCOD   = EMPRESA_CREDITO
                       AND A.PPMOD   = MODULO_CREDITO
                       AND A.PPSUC   = SUCURSAL_CREDITO
                       AND A.PPMDA   = MONEDA_CREDITO
                       AND A.PPPAP   = PAPEL_CREDITO
                       AND A.PPCTA   = CUENTA_CREDITO
                       AND A.PPOPER  = OPERACION_CREDITO
                       AND A.PPSBOP  = SBOPER_CREDITO
                       AND A.PPTOPE  = TPOPER_CREDITO
                       AND A.D601CO  = 'S'
                       AND B.PGCOD   = A.PGCOD 
                       AND B.PPMOD   = A.PPMOD 
                       AND B.PPSUC   = A.PPSUC 
                       AND B.PPMDA   = A.PPMDA 
                       AND B.PPPAP   = A.PPPAP 
                       AND B.PPCTA   = A.PPCTA 
                       AND B.PPOPER  = A.PPOPER
                       AND B.PPSBOP  = A.PPSBOP
                       AND B.PPTOPE  = A.PPTOPE
                       AND B.PPFPAG  = A.PPFPAG
                       AND B.D602CO  = 'S'
                       AND B.PP1NUMP = (SELECT MAX(PP1NUMP)
                                          FROM FSD602
                                         WHERE PGCOD  = B.PGCOD 
                                           AND PPMOD  = B.PPMOD 
                                           AND PPSUC  = B.PPSUC 
                                           AND PPMDA  = B.PPMDA 
                                           AND PPPAP  = B.PPPAP 
                                           AND PPCTA  = B.PPCTA 
                                           AND PPOPER = B.PPOPER
                                           AND PPSBOP = B.PPSBOP
                                           AND PPTOPE = B.PPTOPE
                                           AND PPFPAG = B.PPFPAG
                                           AND D602CO = 'S')) T
            WHERE T.PP1STAT = 'T';
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         TOTAL_CUOTAS_PEND := 0;
         BEGIN
            SELECT COUNT(*)
              INTO TOTAL_CUOTAS_PEND
              FROM (SELECT B.*
                      FROM FSD601 A, FSD602 B
                     WHERE A.PGCOD   = EMPRESA_CREDITO
                       AND A.PPMOD   = MODULO_CREDITO
                       AND A.PPSUC   = SUCURSAL_CREDITO
                       AND A.PPMDA   = MONEDA_CREDITO
                       AND A.PPPAP   = PAPEL_CREDITO
                       AND A.PPCTA   = CUENTA_CREDITO
                       AND A.PPOPER  = OPERACION_CREDITO
                       AND A.PPSBOP  = SBOPER_CREDITO
                       AND A.PPTOPE  = TPOPER_CREDITO
                       AND A.D601CO  = 'S'
                       AND B.PGCOD   = A.PGCOD 
                       AND B.PPMOD   = A.PPMOD 
                       AND B.PPSUC   = A.PPSUC 
                       AND B.PPMDA   = A.PPMDA 
                       AND B.PPPAP   = A.PPPAP 
                       AND B.PPCTA   = A.PPCTA 
                       AND B.PPOPER  = A.PPOPER
                       AND B.PPSBOP  = A.PPSBOP
                       AND B.PPTOPE  = A.PPTOPE
                       AND B.PPFPAG  = A.PPFPAG
                       AND B.D602CO  = 'S'
                       AND B.PP1NUMP = (SELECT MAX(PP1NUMP)
                                          FROM FSD602
                                         WHERE PGCOD  = B.PGCOD 
                                           AND PPMOD  = B.PPMOD 
                                           AND PPSUC  = B.PPSUC 
                                           AND PPMDA  = B.PPMDA 
                                           AND PPPAP  = B.PPPAP 
                                           AND PPCTA  = B.PPCTA 
                                           AND PPOPER = B.PPOPER
                                           AND PPSBOP = B.PPSBOP
                                           AND PPTOPE = B.PPTOPE
                                           AND PPFPAG = B.PPFPAG
                                           AND D602CO = 'S')) T
            WHERE T.PP1STAT = 'P';
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         TOTAL_CUOTAS_VENC := 0;
         BEGIN
            SELECT COUNT(*)
              INTO TOTAL_CUOTAS_VENC
              FROM FSD601 A
             WHERE A.PGCOD  = EMPRESA_CREDITO
               AND A.PPMOD  = MODULO_CREDITO
               AND A.PPSUC  = SUCURSAL_CREDITO
               AND A.PPMDA  = MONEDA_CREDITO
               AND A.PPPAP  = PAPEL_CREDITO
               AND A.PPCTA  = CUENTA_CREDITO
               AND A.PPOPER = OPERACION_CREDITO
               AND A.PPSBOP = SBOPER_CREDITO
               AND A.PPTOPE = TPOPER_CREDITO
               AND A.PPFPAG < FECHA_SISTEMA
               AND A.D601CO = 'S'
               AND NOT EXISTS (SELECT *
                                 FROM FSD602 A1
                                WHERE A1.PGCOD   = A.PGCOD 
                                  AND A1.PPMOD   = A.PPMOD 
                                  AND A1.PPSUC   = A.PPSUC 
                                  AND A1.PPMDA   = A.PPMDA 
                                  AND A1.PPPAP   = A.PPPAP 
                                  AND A1.PPCTA   = A.PPCTA 
                                  AND A1.PPOPER  = A.PPOPER
                                  AND A1.PPSBOP  = A.PPSBOP
                                  AND A1.PPTOPE  = A.PPTOPE
                                  AND A1.PPFPAG  = A.PPFPAG
                                  AND A1.D602CO  = 'S'
                                  AND A1.PP1NUMP = (SELECT MAX(PP1NUMP)
                                                      FROM FSD602 A2
                                                     WHERE A2.PGCOD  = A1.PGCOD 
                                                       AND A2.PPMOD  = A1.PPMOD 
                                                       AND A2.PPSUC  = A1.PPSUC 
                                                       AND A2.PPMDA  = A1.PPMDA 
                                                       AND A2.PPPAP  = A1.PPPAP 
                                                       AND A2.PPCTA  = A1.PPCTA 
                                                       AND A2.PPOPER = A1.PPOPER
                                                       AND A2.PPSBOP = A1.PPSBOP
                                                       AND A2.PPTOPE = A1.PPTOPE
                                                       AND A2.PPFPAG = A1.PPFPAG
                                                       AND A2.D602CO = 'S')
                                  AND A1.PP1STAT = 'T');
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         TIPO_PERSONA := NULL;
         BEGIN
            SELECT TRIM(PETIPO)
              INTO TIPO_PERSONA
              FROM FSD001
             WHERE PEPAIS = PAIS_DOCUMENTO 
               AND PETDOC = TIPO_DOCUMENTO 
               AND PENDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         EXISTE_FSD004 := 'N';
         BEGIN
            SELECT 'S'
              INTO EXISTE_FSD004
              FROM FSD004
             WHERE IFPAIS = PAIS_DOCUMENTO 
               AND IFTDOC = TIPO_DOCUMENTO 
               AND IFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         NOMBRE_TIPO_PERSONA := NULL;
         IF EXISTE_FSD004 = 'S' THEN
            NOMBRE_TIPO_PERSONA := 'INSTITUCIÓN FINANCIERA';
         ELSE
            IF TIPO_PERSONA = 'F' THEN
               NOMBRE_TIPO_PERSONA := 'PERSONA NATURAL';
            ELSE
               IF TIPO_PERSONA = 'J' THEN
                  NOMBRE_TIPO_PERSONA := 'PERSONA JURÍDICA';
               END IF;
            END IF;
         END IF;
         
         NRO70 := 0;
         BEGIN
            SELECT MAX(A.PAE70NRO)
              INTO NRO70
              FROM FPAE70 A
             WHERE A.PAE51EVA = 2
               AND A.PAE70INS = INSTANCIA;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         IF NRO70 > 0 THEN
            EVAL71 := 0;
            BEGIN
               SELECT TO_NUMBER(A.PAE71VAL)
                 INTO EVAL71
                 FROM FPAE71 A
                WHERE A.PAE51EVA = 2
                  AND A.PAE70NRO = NRO70
                  AND A.PAE71ITE = 101;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            
            CADENA_VAL := NULL;
            IF EVAL71 < 10 THEN
               CADENA_VAL := '0' || TRIM(TO_CHAR(EVAL71)) || '%';
            ELSE
               CADENA_VAL := TRIM(TO_CHAR(EVAL71)) || '%';
            END IF;
            
            TIPO_CREDITO := NULL;
            BEGIN
               SELECT DISTINCT TRIM(A.RNG50RET)
                 INTO TIPO_CREDITO
                 FROM FRNG50 A
                WHERE A.RNG49COD = 1510
                  AND A.RNG50RET LIKE CADENA_VAL;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         ELSE
            TIPO_CREDITO := 'SIN INFORMACIÓN';
         END IF;
         
         RPLEGAL_NOMBRE   := NULL;
         RPLEGAL_CARGO    := NULL;
         RPLEGAL_TIPO_DOC := NULL;
         RPLEGAL_NRO_DOC  := NULL;
         RPLEGAL_SEXO     := NULL;
         BEGIN
            SELECT TRIM(B.PFAPE1) || TRIM(B.PFAPE2) || TRIM(B.PFNOM1) || TRIM(B.PFNOM2),
                   TRIM(C.VINOM), A.PFTDO1, TRIM(A.PFNDO1), B.PFCANT
              INTO RPLEGAL_NOMBRE, RPLEGAL_CARGO, RPLEGAL_TIPO_DOC, RPLEGAL_NRO_DOC,
                   RPLEGAL_SEXO
              FROM FSR003 A, FSD002 B, FST020 C
             WHERE A.PFPAI1 = B.PFPAIS
               AND A.PFTDO1 = B.PFTDOC
               AND A.PFNDO1 = B.PFNDOC
               AND A.PJPAIS = PAIS_DOCUMENTO
               AND A.PJTDOC = TIPO_DOCUMENTO
               AND A.PJNDOC = RPAD(NRO_DOCUMENTO, 12, ' ')
               AND A.VICOD  = C.VICOD
               AND A.VICOD  = 7;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         VENTAS := 0;
         BEGIN
            SELECT B.SNG023MTO
              INTO VENTAS
              FROM SNG021 A, SNG023 B
             WHERE A.SNG021EVAL = B.SNG021EVAL
               AND A.SNG021SOL  = INSTANCIA
               AND B.SNG026COD  = 73;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         PERIODO_VENTAS := NULL;
         BEGIN
            SELECT LAST_DAY(A.SNG021FEC)
              INTO PERIODO_VENTAS
              FROM SNG021 A
             WHERE A.SNG021SOL = INSTANCIA;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         CONTADOR        := 0;
         TIPOS_GARANTIAS := NULL;
         FOR J IN GARANTIAS_FSR011(EMPRESA_CREDITO , 
                                   MODULO_CREDITO, 
                                   SUCURSAL_CREDITO, 
                                   MONEDA_CREDITO,   
                                   PAPEL_CREDITO,    
                                   CUENTA_CREDITO,   
                                   OPERACION_CREDITO,
                                   SBOPER_CREDITO,   
                                   TPOPER_CREDITO)
         LOOP
            CONTADOR := CONTADOR + 1;
            
            NOMBRE_GARANTIA := NULL;
            BEGIN
               SELECT TRIM(PPG018DESC)
                 INTO NOMBRE_GARANTIA
                 FROM PPG018
                WHERE PPG018MOD = J.R2MOD
                  AND PPG018MDA = J.R2MDA 
                  AND PPG018PAP = J.R2PAP
                  AND PPG018TOP = J.R2TOPE;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            
            TIPOS_GARANTIAS := TIPOS_GARANTIAS || NOMBRE_GARANTIA || '|';
         END LOOP;
         
         TIPOS_GARANTIAS := SUBSTR(TIPOS_GARANTIAS, 1, LENGTH(TIPOS_GARANTIAS) - 1);
         
         
         IF CONTADOR = 0 THEN
            TIPOS_GARANTIAS := NULL;
            FOR T IN GARANTIAS_SNG122(INSTANCIA) LOOP
               NOMBRE_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(PPG018DESC)
                    INTO NOMBRE_GARANTIA
                    FROM PPG018
                   WHERE PPG018MOD = T.SNG122MOD
                     AND PPG018MDA = T.SNG122MDA 
                     AND PPG018PAP = T.SNG122PAP
                     AND PPG018TOP = T.SNG122TOPE;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               TIPOS_GARANTIAS := TIPOS_GARANTIAS || NOMBRE_GARANTIA || '|';
            END LOOP;
            
             TIPOS_GARANTIAS := SUBSTR(TIPOS_GARANTIAS, 1, LENGTH(TIPOS_GARANTIAS) - 1);
         END IF;
         
         GARANTIAS_PARTIDAS := NULL;
         FOR I IN GARANTIAS_PPG001(EMPRESA_CREDITO , 
                                   MODULO_CREDITO, 
                                   SUCURSAL_CREDITO, 
                                   MONEDA_CREDITO,   
                                   PAPEL_CREDITO,    
                                   CUENTA_CREDITO,   
                                   OPERACION_CREDITO,
                                   SBOPER_CREDITO,   
                                   TPOPER_CREDITO)
         LOOP
            NOMBRE_PARTIDA := NULL;
            NOMBRE_PARTIDA := I.PPG001DATO;
            
            GARANTIAS_PARTIDAS := GARANTIAS_PARTIDAS || NOMBRE_PARTIDA || '|';
         END LOOP;
         
         GARANTIAS_PARTIDAS := SUBSTR(GARANTIAS_PARTIDAS, 1, LENGTH(GARANTIAS_PARTIDAS) - 1);
         
         BEGIN
            SELECT NVL(MAX(A.AQPC759CORR), 0) + 1
              INTO CORRELATIVO
              FROM AQPC759 A
             WHERE A.AQPC759FHREG = FECHA_SISTEMA;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         /*=================== INSERT ===================*/
         BEGIN
            INSERT INTO AQPC759 (AQPC759CORR,    -- CORRELATIVO
                                 AQPC759FHREG,   -- FECHA REGISTRO
                                 AQPC759HRREG,   -- HORA REGISTRO
                                 AQPC759INST,    -- INSTANCIA
                                 AQPC759EMP,     -- EMPRESA CRÉDITO
                                 AQPC759MOD,     -- MÓDULO CRÉDITO
                                 AQPC759SUC,     -- SUCURSAL CRÉDITO
                                 AQPC759MDA,     -- MONEDA CRÉDITO
                                 AQPC759PAP,     -- PAPEL CRÉDITO
                                 AQPC759CTA,     -- CUENTA CRÉDITO
                                 AQPC759OPER,    -- OPERACIÓN CRÉDITO
                                 AQPC759SBOP,    -- SUBOPERACIÓN CRÉDITO
                                 AQPC759TOPE,    -- TIPO OPERACIÓN CRÉDITO
                                 AQPC759TPFOND,  -- TIPO DE FONDO
                                 AQPC759TPSBS,   -- TIPO SBS
                                 AQPC759CATEG,   -- CATEGORÍA
                                 AQPC759SDO,     -- SALDO
                                 AQPC759DIFERI,  -- DIFERIDO
                                 AQPC759SDOCON,  -- SALDO CONSOLIDADO
                                 AQPC759PROVIS,  -- PROVISIÓN
                                 AQPC759SDOCNCC, -- SALDO CAPITAL NETO CON COBERTURA
                                 AQPC759SDOCNSC, -- SALDO CAPITAL NETO SIN COBERTURA
                                 AQPC759NROCRD,  -- NRO. CRÉDITO
                                 AQPC759CODCLI,  -- CÓDIGO CLIENTE
                                 AQPC759CODSBS,  -- CÓDIGO SBS
                                 AQPC759TIPCRD,  -- TIPO CRÉDITO
                                 AQPC759PRODUC,  -- PRODUCTO
                                 AQPC759LINCOF,  -- LINEA COFIDE
                                 AQPC759NOMCLI,  -- NOMBRE DEL CLIENTE
                                 AQPC759CALISBS, -- CALIFICACIÓN SBS
                                 AQPC759NORMAL,  -- NORMAL
                                 AQPC759CPP,     -- CPP
                                 AQPC759DEFIC,   -- DEFICIENTE
                                 AQPC759DUDOSO,  -- DUDOSO
                                 AQPC759PERDID,  -- PERDIDA
                                 AQPC759NROENA,  -- NRO. ENTIDADES ACTUAL
                                 AQPC759MDAPRE,  -- MONEDA DEL PRÉSTAMO
                                 AQPC759MTODES,  -- MONTO DESEMBOLSADO TOTAL S/
                                 AQPC759SDOTOR,  -- SALDO TOTAL (MONEDA ORIGINAL)
                                 AQPC759SDOTOT,  -- SALDO TOTAL S/
                                 AQPC759FACCOB,  -- FACTOR DE COBERTURA
                                 AQPC759PROVSN,  -- PROVISIÓN S/
                                 AQPC759PRVPRC,  -- PROVISIÓN PROCICLICA S/
                                 AQPC759PRVTOT,  -- PROVISIÓN TOTAL S/
                                 AQPC759SDOVEC,  -- SALDO VENCIDO S/
                                 AQPC759TIPPER,  -- TIPO PERSONA
                                 AQPC759SEXO,    -- SEXO
                                 AQPC759FCNACC,  -- FECHA NACIMIENTO - CONSTITUCIÓN
                                 AQPC759DIRECC,  -- DIRECCIÓN
                                 AQPC759DISTRI,  -- DISTRITO
                                 AQPC759PROVIN,  -- PROVINCIA
                                 AQPC759DEPART,  -- DEPARTAMENTO
                                 AQPC759PAIS,    -- NOMBRE PAÍS
                                 AQPC759TIPDOC,  -- TIPO DE DOCUMENTO
                                 AQPC759NRODOC,  -- NRO. DOCUMENTO
                                 AQPC759CODCIIU, -- CÓDIGO CIIU
                                 AQPC759DESCIIU, -- DESCRIPCIÓN CIIU
                                 AQPC759TEA,     -- TASA DE INTERES (TEA)
                                 AQPC759FCAPRO,  -- FECHA DE APROBACIÓN
                                 AQPC759FCDESM,  -- FECHA DE DESEMBOLSO
                                 AQPC759FCVENC,  -- FECHA DE VENCIMIENTO
                                 AQPC759SITCON,  -- SITUACIÓN CONTABLE
                                 AQPC759REPROG,  -- REPROGRAMADO
                                 AQPC759TOTCUO,  -- TOTAL CUOTAS
                                 AQPC759CUOPAG,  -- CUOTAS PAGADAS
                                 AQPC759CUOPEN,  -- CUOTAS PENDIENTES
                                 AQPC759CUOVEN,  -- CUOTAS VENCIDAS
                                 AQPC759TIPGRT,  -- TIPOS GARANTÍAS
                                 AQPC759IMPORT,  -- IMPORTE
                                 AQPC759NROFIC,  -- NRO. FICHA
                                 AQPC759REPLN,   -- REPRESENTANTE LEGAL NOMBRE
                                 AQPC759REPLC,   -- REPRESENTANTE LEGAL CARGO
                                 AQPC759REPLTD,  -- REPRESENTANTE LEGAL TIPO DOCUMENTO
                                 AQPC759REPLND,  -- REPRESENTANTE LEGAL NRO. DOCUMENTO
                                 AQPC759REPLSX,  -- REPRESENTANTE LEGAL SEXO
                                 AQPC759VENTAS,  -- VENTAS
                                 AQPC759PERVEN,  -- PERIODO DE VENTAS
                                 AQPC759COBEFO   -- COBERTURA FONDO
                                 )
                                 
            VALUES (CORRELATIVO,          -- CORRELATIVO
                    FECHA_SISTEMA,        -- FECHA DE REGISTRO
                    HORA_SISTEMA,         -- HORA DE REGISTRO
                    INSTANCIA,            -- INSTANCIA
                    EMPRESA_CREDITO,      -- EMPRESA CRÉDITO
                    MODULO_CREDITO,       -- MÓDULO CRÉDITO
                    SUCURSAL_CREDITO,     -- SUCURSAL CRÉDITO
                    MONEDA_CREDITO,       -- MONEDA CRÉDITO
                    PAPEL_CREDITO,        -- PAPEL CRÉDITO
                    CUENTA_CREDITO,       -- CUENTA CRÉDITO
                    OPERACION_CREDITO,    -- OPERACIÓN CRÉDITO
                    SBOPER_CREDITO,       -- SUBOPERACIÓN CRÉDITO
                    TPOPER_CREDITO,        -- TIPO OPERACIÓN CRÉDITO
                    J.AQPC758TPFOND,      -- TIPO DE FONDO
                    J.AQPC758TPSBS,       -- TIPO SBS
                    J.AQPC758CATEG,       -- CATEGORÍA
                    J.AQPC758SDO,         -- SALDO
                    J.AQPC758DIFERI,      -- DIFERIDO
                    J.AQPC758SDOCON,      -- SALDO CONSOLIDADO
                    J.AQPC758PROVIS,      -- PROVISIÓN
                    J.AQPC758SDONCC,      -- SALDO CAPITAL NETO CON COBERTURA
                    J.AQPC758SDONSC,      -- SALDO CAPITAL NETO SIN COBERTURA
                    NRO_CREDITO,          -- NRO. CRÉDITO
                    CUENTA_CREDITO,       -- CÓDIGO CLIENTE
                    CODIGO_SBS,           -- CÓDIGO SBS
                    TIPO_CREDITO,         -- TIPO CRÉDITO
                    NOMBRE_MODULO,        -- PRODUCTO
                    NOMBRE_TIPO_OPER,     -- LINEA COFIDE
                    NOMBRE_CLIENTE,       -- NOMBRE DEL CLIENTE
                    CALIFICACION_SBS,     -- CALIFICACIÓN SBS
                    CALIFICACION_NORMAL,  -- NORMAL
                    CALIFICACION_CPP,     -- CPP
                    CALIFICACION_DEFICI,  -- DEFICIENTE
                    CALIFICACION_DUDOSO,  -- DUDOSO
                    CALIFICACION_PERDIDA, -- PERDIDA
                    NRO_ENTIDADES,        -- NRO. ENTIDADES ACTUAL
                    SIGNO_MONEDA,         -- MONEDA DEL PRÉSTAMO
                    MONTO_DESEMBOLSO,     -- MONTO DESEMBOLSADO TOTAL S/
                    SALDO_MONEDA_ORIG,    -- SALDO TOTAL (MONEDA ORIGINAL)
                    SALDO_TOTAL,          -- SALDO TOTAL S/
                    0,                    -- FACTOR DE COBERTURA
                    J.AQPC758PROVIS,      -- PROVISIÓN S/
                    0,                    -- PROVISIÓN PROCICLICA S/
                    0,                    -- PROVISIÓN TOTAL S/
                    SALDO_MONEDA_ORIG,    -- SALDO VENCIDO S/
                    TIPO_PERSONA,         -- TIPO PERSONA
                    SEXO_CLIENTE,         -- SEXO
                    FECHA_NACIMIENTO,     -- FECHA NACIMIENTO - CONSTITUCIÓN
                    NOMBRE_DIRECCION,     -- DIRECCIÓN
                    NOMBRE_DISTRITO,      -- DISTRITO
                    NOMBRE_PROVINCIA,     -- PROVINCIA
                    NOMBRE_DEPARTAMENTO,  -- DEPARTAMENTO    
                    NOMBRE_PAIS,          -- NOMBRE PAÍS
                    NOMBRE_TIPO_DOC,      -- TIPO DE DOCUMENTO
                    NRO_DOCUMENTO,        -- NRO. DOCUMENTO
                    CODIGO_CIIU,          -- CÓDIGO CIIU
                    NOMBRE_CIIU,          -- DESCRIPCIÓN CIIU
                    TASA_INTERES,         -- TASA DE INTERES (TEA)
                    FECHA_APROBACION,     -- FECHA DE APROBACIÓN
                    FECHA_DESEMBOLSO,     -- FECHA DE DESEMBOLSO
                    FECHA_VENC_DESMB,     -- FECHA DE VENCIMIENTO
                    SITUACION_CONTABLE,   -- SITUACIÓN CONTABLE
                    REPROGRAMADO,         -- REPROGRAMADO
                    TOTAL_CUOTAS,         -- TOTAL CUOTAS
                    TOTAL_CUOTAS_PAGA,    -- CUOTAS PAGADAS
                    TOTAL_CUOTAS_PEND,    -- CUOTAS PENDIENTES
                    TOTAL_CUOTAS_VENC,    -- CUOTAS VENCIDAS
                    TIPOS_GARANTIAS,      -- TIPOS GARANTÍAS
                    SALDO_GARANTIA,       -- IMPORTE
                    GARANTIAS_PARTIDAS,   -- NRO. FICHA  
                    RPLEGAL_NOMBRE,       -- REPRESENTANTE LEGAL NOMBRE
                    RPLEGAL_CARGO,        -- REPRESENTANTE LEGAL CARGO
                    RPLEGAL_TIPO_DOC,     -- REPRESENTANTE LEGAL TIPO DOCUMENTO
                    RPLEGAL_NRO_DOC,      -- REPRESENTANTE LEGAL NRO. DOCUMENTO
                    RPLEGAL_SEXO,         -- REPRESENTANTE LEGAL SEXO
                    VENTAS,               -- VENTAS
                    PERIODO_VENTAS,       -- PERIODO DE VENTAS
                    ''                    -- COBERTURA FONDO
                    );                  
            
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
   END SP_CR_INFORMACION_ADICIONAL_5D;   

END PQ_CR_ANEXO_5D_COFIDE;
/

