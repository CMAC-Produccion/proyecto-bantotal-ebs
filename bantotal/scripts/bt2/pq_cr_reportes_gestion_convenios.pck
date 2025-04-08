CREATE OR REPLACE PACKAGE PQ_CR_REPORTES_GESTION_CONVENIOS IS

   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_REPORTES_GESTION_CONVENIOS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 21/11/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN / MILTON CORDOVA
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 27/03/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN / MILTON CORDOVA
   -- DESCRIPCION DE MODIFICACION : SE MODIFICARON LOS SIGUIENTES PROCEDIMIENTOS:
   --                               - SP_CR_REPORTE_SEGUIMIENTO
   --                               - SP_CR_REPORTE_SEGUIMIENTO_DETALLE
   --                               - SP_CR_REPORTE_CANJE_PUBLICITARIO
   --                               - SP_CR_PAGO_CASILLERO
   --                               - SP_CR_SEGMENTO_PERSONAS
   -- *****************************************************************
   -- FECHA DE MODIFICACION       : 05/04/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN 
   -- DESCRIPCION DE MODIFICACION : SE MODIFICARON LOS SIGUIENTES PROCEDIMIENTOS:
   --                               - SP_CR_REPORTE_SEGUIMIENTO
   --                               - SP_CR_REPORTE_SEGUIMIENTO_DETALLE
   -- *****************************************************************
   -- FECHA DE MODIFICACION       : 25/07/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN 
   -- DESCRIPCION DE MODIFICACION : SE MODIFICARON LOS SIGUIENTES PROCEDIMIENTOS:
   --                               - SP_CR_REPORTE_SEGUIMIENTO
   --                               - SP_CR_REPORTE_SEGUIMIENTO_DETALLE
   --                               - SP_CR_REPORTE_CANJE_PUBLICITARIO
   -- *****************************************************************
   -- FECHA DE MODIFICACION       : 11/03/2025
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN 
   -- DESCRIPCION DE MODIFICACION : SE MODIFICARON EL SIGUIENTE PROCEDIMIENTO:
   --                               - SP_CR_REPORTE_SEGUIMIENTO_DETALLE
   -- *****************************************************************

   PROCEDURE SP_CR_REPORTE_SEGUIMIENTO(P_CODIGO_CONVENIO   IN NUMBER,
                                       P_CODIGO_REGION     IN NUMBER,
                                       P_CODIGO_ZONA       IN NUMBER,
                                       P_CODIGO_SUCURSAL   IN NUMBER,
                                       P_CODIGO_ASESOR     IN VARCHAR2,
                                       P_FECHA_INICIO      IN DATE,
                                       P_FECHA_FIN         IN DATE,
                                       P_USUARIO_EJECUTO   IN VARCHAR2);
                                       
   PROCEDURE SP_CR_REPORTE_SEGUIMIENTO_DETALLE(P_CODIGO_CONVENIO   IN NUMBER,
                                               P_CODIGO_REGION     IN NUMBER,
                                               P_CODIGO_ZONA       IN NUMBER,
                                               P_CODIGO_SUCURSAL   IN NUMBER,
                                               P_CODIGO_ASESOR     IN VARCHAR2,
                                               P_FECHA_INICIO      IN DATE,
                                               P_FECHA_FIN         IN DATE,
                                               P_USUARIO_EJECUTO   IN VARCHAR2);
   
   PROCEDURE SP_CR_REPORTE_CANJE_PUBLICITARIO(P_CODIGO_CONVENIO   IN NUMBER,
                                              P_CODIGO_REGION     IN NUMBER,
                                              P_CODIGO_ZONA       IN NUMBER,
                                              P_CODIGO_SUCURSAL   IN NUMBER,
                                              P_CODIGO_ASESOR     IN VARCHAR2,
                                              P_FECHA_INICIO      IN DATE,
                                              P_FECHA_FIN         IN DATE,
                                              P_USUARIO_EJECUTO   IN VARCHAR2);
                                              
   PROCEDURE SP_CR_OBTENER_NOMBRE_CONVENIO(P_CODIGO_CONVENIO IN NUMBER,
                                           P_NOMBRE_CONVENIO OUT VARCHAR2);
                                           
  PROCEDURE SP_CR_PAGO_CASILLERO(
          P_COD_CONV IN NUMBER,
          P_COD_REG  IN NUMBER,
          P_COD_ZON  IN NUMBER,
          P_COD_SUC  IN NUMBER,
          P_COD_ASE  IN varchar2,
          P_FCH_INI  IN DATE,
          P_FCH_FIN  IN DATE,
          P_FCH_PRC  IN DATE,
          P_USU_PRC  IN VARCHAR2,
          P_HOR_PRC  IN VARCHAR2);
  PROCEDURE SP_CR_SEGMENTO_PERSONAS(
          P_COD_CONV IN NUMBER,
          P_COD_REG  IN NUMBER,
          P_COD_ZON  IN NUMBER,
          P_COD_SUC  IN NUMBER,
          P_COD_ASE  IN VARCHAR2,
          P_FCH_INI  IN DATE,
          P_FCH_FIN  IN DATE,
          P_FCH_PRC  IN DATE,
          P_USU_PRC  IN VARCHAR2,
          P_HOR_PRC  IN VARCHAR2);

END PQ_CR_REPORTES_GESTION_CONVENIOS;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_REPORTES_GESTION_CONVENIOS IS
   
   PROCEDURE SP_CR_REPORTE_SEGUIMIENTO(P_CODIGO_CONVENIO IN NUMBER,
                                       P_CODIGO_REGION   IN NUMBER,
                                       P_CODIGO_ZONA     IN NUMBER,
                                       P_CODIGO_SUCURSAL IN NUMBER,
                                       P_CODIGO_ASESOR   IN VARCHAR2,
                                       P_FECHA_INICIO    IN DATE,
                                       P_FECHA_FIN       IN DATE,
                                       P_USUARIO_EJECUTO IN VARCHAR2) IS
      
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_REPORTE_SEGUIMIENTO
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 21/11/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : GENERA EL REPORTE DE SEGUIMIENTO
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 27/03/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO EL CURSOR DATOS_CONVENIOS PARA REEEMPLAZAR 
      --                                 LA TABLA FST046 POR LA TABLA JAQA201 PARA OBTENER LA SUCURSAL.
      --                               - SE VALIDA SI LOS CREDITOS QUE ESTAN ASOCIADOS AL CONVENIO, SE
      --                                 ENCUENTRA VIGENTES PARA MOSTRAR DICHO CONVENIO EN EL
      --                                 REPORTE.
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 05/04/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO LA OBTENCION DE LOS PAGOS CUOTA COMPLETA,
      --                                 PAGOS CUOTA PARCIAL, CLIENTES SIN PAGO SIN DESCUENTO Y
      --                                 LA FECHA REAL DIA DE PAGO.
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 25/07/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO LA VALIDACION DE LOS CREDITOS
      --                                 VIGENTES POR CONVENIO.
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 01/04/2025
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO LA OBTENCION DEL MAXIMO CORRELATIVO
      --                                 DE LA TABLA JAQA38 Y JAQA39           
      -- *****************************************************************
   
      FECHA_SISTEMA              DATE;
      HORA_SISTEMA               VARCHAR2(8);
      MES_REGISTRO               VARCHAR2(30);
      CORRELATIVO                NUMBER(9);
      DIAS_ATRASO_ENVIO_LISTADO  NUMBER(4);
      DIAS_ATRASO_RECOJO_LISTADO NUMBER(4);
      DIAS_ATRASO_RECOJO_CHEQUE  NUMBER(4);
      PERIODO                    DATE;
      FECHA_INICIO               DATE;
      FECHA_FIN                  DATE;
      MEDIO_PAGO                 VARCHAR2(25);
      MONTO_CHEQUE               NUMBER(17, 2);
      DESCUENTO_CUOTA_COMPLETA   NUMBER(9);
      DESCUENTO_CUOTA_PARCIAL    NUMBER(9);
      SIN_DESCUENTO              NUMBER(9);
      SIN_CHEQUE                 VARCHAR2(250);
      DIA_PAGO                   NUMBER(5);
      DIA_PAGO_REAL              NUMBER(5);
      PAGO_CUOTA_COMPLETA        NUMBER(5);
      PAGO_CUOTA_PARCIAL         NUMBER(5);
      CLIENTE_SIN_PAGO           NUMBER(5);
      DIA_RECOJO_LISTADO         NUMBER(5);
      TOTAL_CREDITOS             NUMBER(17);
      OTROS_PAGOS                NUMBER(5);
      
      CURSOR DATOS_CONVENIOS IS
         SELECT A.PP101NCART, A.PP101NOMC, D.REGCOD, D.REGNOM, D.CODZON, 
                D.DESZON, D.SUCURS, D.SCNOM, B.JAQA300ARC, B.JAQA300FEL, 
                B.JAQA300FRC
           FROM FPP101 A, JAQA300 B, JAQA201 C, REGSUC D
          WHERE A.PP101NCART = B.JAQA300NCO
            AND C.JAQA201NCA = A.PP101NCART
            AND D.SUCURS     = C.JAQA201ARE
            AND A.PP101NCART = DECODE(NVL(P_CODIGO_CONVENIO, 0), 0, A.PP101NCART, P_CODIGO_CONVENIO)
            AND B.JAQA300ARC = DECODE(NVL(P_CODIGO_ASESOR, ' '), ' ', B.JAQA300ARC, RPAD(P_CODIGO_ASESOR, 10, ' '))
            AND C.JAQA201ARE IN (SELECT SUCURS
                                   FROM REGSUC
                                  WHERE REGCOD = DECODE(NVL(P_CODIGO_REGION, 0), 0, REGCOD, P_CODIGO_REGION)
                                    AND CODZON = DECODE(NVL(P_CODIGO_ZONA, 0), 0, CODZON, P_CODIGO_ZONA)
                                    AND SUCURS = DECODE(NVL(P_CODIGO_SUCURSAL, 0), 0, SUCURS, P_CODIGO_SUCURSAL))
            AND (SELECT COUNT(*)
                   FROM FPP102, FSD011 
                  WHERE PP102NCART = A.PP101NCART
                    AND PGCOD  = PP102COD
                    AND SCMOD  = PP102MOD
                    AND SCSUC  = PP102SUC
                    AND SCMDA  = PP102MDA
                    AND SCPAP  = PP102PAP
                    AND SCCTA  = PP102CTA
                    AND SCOPER = PP102OPE
                    AND SCSBOP = PP102SBO
                    AND SCTOPE = PP102TOP
                    AND SCSTAT <> 99
                    ) > 0;
   BEGIN
      BEGIN
         SELECT PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
           INTO FECHA_SISTEMA, HORA_SISTEMA
           FROM FST017
          WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         DELETE FROM AQPC298 WHERE AQPC298USUEJEC = P_USUARIO_EJECUTO;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      PERIODO      := NULL;
      CORRELATIVO  := 0;
      PERIODO      := P_FECHA_INICIO;      
      WHILE TRUNC(PERIODO, 'MONTH') <= TRUNC(P_FECHA_FIN, 'MONTH') LOOP
         MES_REGISTRO := TRIM(TO_CHAR(PERIODO,'MONTH', 'NLS_DATE_LANGUAGE = SPANISH')) ||
                         ' - ' || EXTRACT(YEAR FROM PERIODO);
         FOR J IN DATOS_CONVENIOS LOOP            
            MEDIO_PAGO                 := NULL;
            MONTO_CHEQUE               := NULL;
            DESCUENTO_CUOTA_COMPLETA   := NULL;
            DESCUENTO_CUOTA_PARCIAL    := NULL;
            SIN_DESCUENTO              := NULL;
            SIN_CHEQUE                 := NULL;
            DIA_RECOJO_LISTADO         := NULL;
            DIAS_ATRASO_ENVIO_LISTADO  := NULL;
            DIAS_ATRASO_RECOJO_LISTADO := NULL;
            DIAS_ATRASO_RECOJO_CHEQUE  := NULL;
            DIA_PAGO                   := NULL;
            FECHA_INICIO               := NULL;
            FECHA_FIN                  := NULL;
               
            CORRELATIVO := CORRELATIVO + 1;
            IF CORRELATIVO = 1 AND TRUNC(PERIODO, 'MONTH') < TRUNC(P_FECHA_FIN, 'MONTH') THEN
               FECHA_INICIO := P_FECHA_INICIO;
               FECHA_FIN    := LAST_DAY(PERIODO);
            ELSE
               IF TRUNC(PERIODO, 'MONTH') = TRUNC(P_FECHA_FIN, 'MONTH') THEN
                  FECHA_INICIO := TRUNC(PERIODO, 'MONTH');
                  FECHA_FIN    := P_FECHA_FIN;
               ELSE
                  IF TRUNC(PERIODO, 'MONTH') < TRUNC(P_FECHA_FIN, 'MONTH') THEN
                     FECHA_INICIO := TRUNC(PERIODO, 'MONTH');
                     FECHA_FIN    := LAST_DAY(PERIODO);
                  END IF;
               END IF;
            END IF;
            IF NVL(J.JAQA300FEL, 0) = 0 THEN
               DIAS_ATRASO_ENVIO_LISTADO := NULL;
            ELSE
               BEGIN
                  SELECT NVL(EXTRACT(DAY FROM B.JAQA38FCH), 0) - J.JAQA300FEL
                    INTO DIAS_ATRASO_ENVIO_LISTADO
                    FROM JAQA38 B
                   WHERE B.JAQA38NCO = J.PP101NCART
                     AND B.JAQA38COD = (SELECT TP1NRO1 
                                          FROM FST198 
                                         WHERE TP1COD   = 1 
                                           AND TP1COD1  = 111154 
                                           AND TP1CORR1 = 1 
                                           AND TP1CORR2 = 19 
                                           AND TP1CORR3 = 1)
                     AND B.JAQA38FCH =
                         (SELECT MAX(JAQA38FCH)
                            FROM JAQA38
                           WHERE JAQA38NCO = B.JAQA38NCO
                             AND JAQA38COD = B.JAQA38COD
                             AND JAQA38FCH BETWEEN FECHA_INICIO AND FECHA_FIN)
                     AND B.JAQA38COR =
                         (SELECT MAX(JAQA38COR)
                            FROM JAQA38
                           WHERE JAQA38NCO = B.JAQA38NCO
                             AND JAQA38COD = B.JAQA38COD
                             AND JAQA38FCH = B.JAQA38FCH);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     BEGIN
                        DIAS_ATRASO_ENVIO_LISTADO := FECHA_SISTEMA - TO_DATE(J.JAQA300FEL || '/' ||TO_CHAR(FECHA_INICIO, 'MM/RRRR'), 'DD/MM/RRRR');      
                     EXCEPTION
                        WHEN OTHERS THEN
                           DIAS_ATRASO_ENVIO_LISTADO := FECHA_SISTEMA - LAST_DAY(FECHA_INICIO);    
                     END;
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
            BEGIN
               SELECT JAQA31DRL
                 INTO DIA_RECOJO_LISTADO
                 FROM JAQA31
                WHERE JAQA31NCO = J.PP101NCART;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            IF NVL(DIA_RECOJO_LISTADO, 0) = 0 THEN
               DIAS_ATRASO_RECOJO_LISTADO := NULL;
            ELSE
               BEGIN
                  SELECT NVL(EXTRACT(DAY FROM B.JAQA38FCH), 0) - NVL(DIA_RECOJO_LISTADO, 0)
                    INTO DIAS_ATRASO_RECOJO_LISTADO
                    FROM JAQA38 B
                   WHERE B.JAQA38NCO = J.PP101NCART
                     AND B.JAQA38COD = (SELECT TP1NRO1 
                                       FROM FST198 
                                      WHERE TP1COD   = 1 
                                        AND TP1COD1  = 111154 
                                        AND TP1CORR1 = 1 
                                        AND TP1CORR2 = 19 
                                        AND TP1CORR3 = 2)
                     AND B.JAQA38FCH =
                         (SELECT MAX(JAQA38FCH)
                            FROM JAQA38
                           WHERE JAQA38NCO = B.JAQA38NCO
                             AND JAQA38COD = B.JAQA38COD
                             AND JAQA38FCH BETWEEN FECHA_INICIO AND FECHA_FIN)
                     AND B.JAQA38COR =
                         (SELECT MAX(JAQA38COR)
                            FROM JAQA38
                           WHERE JAQA38NCO = B.JAQA38NCO
                             AND JAQA38COD = B.JAQA38COD
                             AND JAQA38FCH = B.JAQA38FCH);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     BEGIN
                        DIAS_ATRASO_RECOJO_LISTADO := FECHA_SISTEMA - TO_DATE(DIA_RECOJO_LISTADO || '/' ||TO_CHAR(FECHA_INICIO,'MM/RRRR'), 'DD/MM/RRRR');  
                     EXCEPTION
                        WHEN OTHERS THEN
                           DIAS_ATRASO_RECOJO_LISTADO := FECHA_SISTEMA - LAST_DAY(FECHA_INICIO);    
                     END;
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
               
            IF NVL(J.JAQA300FRC, 0) = 0 THEN
               DIAS_ATRASO_RECOJO_CHEQUE := NULL;
            ELSE
               BEGIN
                  SELECT NVL(EXTRACT(DAY FROM D.JAQA39FEC), 0) - J.JAQA300FRC 
                    INTO DIAS_ATRASO_RECOJO_CHEQUE
                    FROM JAQA39 D
                   WHERE D.JAQA39NCO = J.PP101NCART
                     AND D.JAQA39FEC =
                         (SELECT MAX(JAQA39FEC)
                            FROM JAQA39
                           WHERE JAQA39NCO = D.JAQA39NCO
                             AND JAQA39FEC BETWEEN FECHA_INICIO AND FECHA_FIN)
                     AND D.JAQA39COR =
                         (SELECT MAX(JAQA39COR)
                            FROM JAQA39
                           WHERE JAQA39NCO = D.JAQA39NCO
                             AND JAQA39FEC = D.JAQA39FEC);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     BEGIN
                        DIAS_ATRASO_RECOJO_CHEQUE := FECHA_SISTEMA - TO_DATE(J.JAQA300FRC || '/' ||TO_CHAR(FECHA_INICIO, 'MM/RRRR'), 'DD/MM/RRRR');  
                     EXCEPTION
                        WHEN OTHERS THEN
                           DIAS_ATRASO_RECOJO_LISTADO := FECHA_SISTEMA - LAST_DAY(FECHA_INICIO);    
                     END;
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
               
            BEGIN
               SELECT D.JAQA39MPG, D.JAQA39MCT, D.JAQA39DCO, D.JAQA39DPA,
                      D.JAQA39SND, D.JAQA39MND
                 INTO MEDIO_PAGO, MONTO_CHEQUE, DESCUENTO_CUOTA_COMPLETA, DESCUENTO_CUOTA_PARCIAL,
                      SIN_DESCUENTO, SIN_CHEQUE
                 FROM JAQA39 D
                WHERE D.JAQA39NCO = J.PP101NCART
                  AND D.JAQA39FEC =
                      (SELECT MAX(JAQA39FEC)
                         FROM JAQA39
                        WHERE JAQA39NCO = D.JAQA39NCO
                          AND JAQA39FEC BETWEEN FECHA_INICIO AND FECHA_FIN)
                  AND D.JAQA39COR =
                      (SELECT MAX(JAQA39COR)
                         FROM JAQA39
                        WHERE JAQA39NCO = D.JAQA39NCO
                          AND JAQA39FEC = D.JAQA39FEC);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            DIA_PAGO_REAL := NULL;
            BEGIN
               SELECT EXTRACT(DAY FROM MAX(D.D602FC))
                 INTO DIA_PAGO_REAL
                 FROM FPP102 A, FSD011 B, FSD601 C, FSD602 D
                WHERE A.PP102NCART = J.PP101NCART
                  AND A.PP102COD   = B.PGCOD
                  AND A.PP102MOD   = (SELECT MODULO
                                        FROM FST111
                                       WHERE DSCOD  = 50
                                         AND MODULO = A.PP102MOD)
                  AND A.PP102SUC = B.SCSUC
                  AND A.PP102MDA = B.SCMDA
                  AND A.PP102PAP = B.SCPAP
                  AND A.PP102CTA = B.SCCTA
                  AND A.PP102OPE = B.SCOPER
                  AND A.PP102SBO = B.SCSBOP
                  AND A.PP102TOP = B.SCTOPE
                  AND B.SCSTAT <> 99
                  AND C.PGCOD  = A.PP102COD
                  AND C.PPMOD  = A.PP102MOD
                  AND C.PPSUC  = A.PP102SUC
                  AND C.PPMDA  = A.PP102MDA
                  AND C.PPPAP  = A.PP102PAP
                  AND C.PPCTA  = A.PP102CTA
                  AND C.PPOPER = A.PP102OPE
                  AND C.PPSBOP = A.PP102SBO
                  AND C.PPTOPE = A.PP102TOP
                  AND C.PPFPAG BETWEEN FECHA_INICIO AND FECHA_FIN
                  AND C.D601CO = 'S'
                  AND D.PGCOD  = C.PGCOD
                  AND D.PPMOD  = C.PPMOD
                  AND D.PPSUC  = C.PPSUC
                  AND D.PPMDA  = C.PPMDA
                  AND D.PPPAP  = C.PPPAP
                  AND D.PPCTA  = C.PPCTA
                  AND D.PPOPER = C.PPOPER
                  AND D.PPSBOP = C.PPSBOP
                  AND D.PPTOPE = C.PPTOPE
                  AND D.PPFPAG = C.PPFPAG
                  AND D.D602CO = 'S'
                  AND D.D602MO IN (SELECT TP1NRO1
                                     FROM FST198
                                    WHERE TP1COD   = 1
                                      AND TP1COD1  = 111154
                                      AND TP1CORR1 = 1
                                      AND TP1CORR2 = 29
                                      AND TP1CORR3 > 0
                                      AND TP1IMP1  = 1)
                  AND D.D602TR IN (SELECT TP1NRO2
                                     FROM FST198
                                    WHERE TP1COD   = 1
                                      AND TP1COD1  = 111154
                                      AND TP1CORR1 = 1
                                      AND TP1CORR2 = 29
                                      AND TP1CORR3 > 0
                                      AND TP1IMP1  = 1);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            TOTAL_CREDITOS := 0;
            BEGIN
               SELECT COUNT(*)
                 INTO TOTAL_CREDITOS
                 FROM FPP102 A, FSD011 B, FSD601 C
                WHERE A.PP102NCART = J.PP101NCART
                  AND A.PP102COD   = B.PGCOD
                  AND A.PP102MOD   = (SELECT MODULO
                                        FROM FST111
                                       WHERE DSCOD  = 50
                                         AND MODULO = A.PP102MOD)
                  AND A.PP102SUC = B.SCSUC
                  AND A.PP102MDA = B.SCMDA
                  AND A.PP102PAP = B.SCPAP
                  AND A.PP102CTA = B.SCCTA
                  AND A.PP102OPE = B.SCOPER
                  AND A.PP102SBO = B.SCSBOP
                  AND A.PP102TOP = B.SCTOPE
                  AND B.SCSTAT   <> 99
                  AND C.PGCOD  = A.PP102COD
                  AND C.PPMOD  = A.PP102MOD
                  AND C.PPSUC  = A.PP102SUC
                  AND C.PPMDA  = A.PP102MDA
                  AND C.PPPAP  = A.PP102PAP
                  AND C.PPCTA  = A.PP102CTA
                  AND C.PPOPER = A.PP102OPE
                  AND C.PPSBOP = A.PP102SBO
                  AND C.PPTOPE = A.PP102TOP
                  AND C.PPFPAG BETWEEN FECHA_INICIO AND FECHA_FIN;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            PAGO_CUOTA_PARCIAL := 0;
            BEGIN
               SELECT COUNT(*)
                 INTO PAGO_CUOTA_PARCIAL
                 FROM (SELECT D.*
                         FROM FPP102 A, FSD011 B, FSD601 C, FSD602 D
                        WHERE A.PP102NCART = J.PP101NCART
                          AND A.PP102COD   = B.PGCOD
                          AND A.PP102MOD   = (SELECT MODULO
                                                FROM FST111
                                               WHERE DSCOD  = 50
                                                 AND MODULO = A.PP102MOD)
                          AND A.PP102SUC = B.SCSUC
                          AND A.PP102MDA = B.SCMDA
                          AND A.PP102PAP = B.SCPAP
                          AND A.PP102CTA = B.SCCTA
                          AND A.PP102OPE = B.SCOPER
                          AND A.PP102SBO = B.SCSBOP
                          AND A.PP102TOP = B.SCTOPE
                          AND B.SCSTAT <> 99
                          AND C.PGCOD  = A.PP102COD
                          AND C.PPMOD  = A.PP102MOD
                          AND C.PPSUC  = A.PP102SUC
                          AND C.PPMDA  = A.PP102MDA
                          AND C.PPPAP  = A.PP102PAP
                          AND C.PPCTA  = A.PP102CTA
                          AND C.PPOPER = A.PP102OPE
                          AND C.PPSBOP = A.PP102SBO
                          AND C.PPTOPE = A.PP102TOP
                          AND C.PPFPAG BETWEEN FECHA_INICIO AND FECHA_FIN
                          AND C.D601CO  = 'S'
                          AND D.PGCOD   = C.PGCOD
                          AND D.PPMOD   = C.PPMOD
                          AND D.PPSUC   = C.PPSUC
                          AND D.PPMDA   = C.PPMDA
                          AND D.PPPAP   = C.PPPAP
                          AND D.PPCTA   = C.PPCTA
                          AND D.PPOPER  = C.PPOPER
                          AND D.PPSBOP  = C.PPSBOP
                          AND D.PPTOPE  = C.PPTOPE
                          AND D.PPFPAG  = C.PPFPAG
                          AND D.D602CO  = 'S'
                          AND D.PP1NUMP = (SELECT MAX(PP1NUMP)
                                             FROM FSD602
                                            WHERE PGCOD  = D.PGCOD
                                              AND PPMOD  = D.PPMOD
                                              AND PPSUC  = D.PPSUC
                                              AND PPMDA  = D.PPMDA
                                              AND PPPAP  = D.PPPAP
                                              AND PPCTA  = D.PPCTA
                                              AND PPOPER = D.PPOPER
                                              AND PPSBOP = D.PPSBOP
                                              AND PPTOPE = D.PPTOPE
                                              AND PPFPAG = D.PPFPAG
                                              AND D602CO = 'S')) T
                  WHERE T.PP1STAT = 'P';
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            PAGO_CUOTA_COMPLETA := 0;
            BEGIN
               SELECT COUNT(*)
                 INTO PAGO_CUOTA_COMPLETA
                 FROM (SELECT D.*
                         FROM FPP102 A, FSD011 B, FSD601 C, FSD602 D
                        WHERE A.PP102NCART = J.PP101NCART
                          AND A.PP102COD   = B.PGCOD
                          AND A.PP102MOD   = (SELECT MODULO
                                                FROM FST111
                                               WHERE DSCOD  = 50
                                                 AND MODULO = A.PP102MOD)
                          AND A.PP102SUC = B.SCSUC
                          AND A.PP102MDA = B.SCMDA
                          AND A.PP102PAP = B.SCPAP
                          AND A.PP102CTA = B.SCCTA
                          AND A.PP102OPE = B.SCOPER
                          AND A.PP102SBO = B.SCSBOP
                          AND A.PP102TOP = B.SCTOPE
                          AND B.SCSTAT <> 99
                          AND C.PGCOD  = A.PP102COD
                          AND C.PPMOD  = A.PP102MOD
                          AND C.PPSUC  = A.PP102SUC
                          AND C.PPMDA  = A.PP102MDA
                          AND C.PPPAP  = A.PP102PAP
                          AND C.PPCTA  = A.PP102CTA
                          AND C.PPOPER = A.PP102OPE
                          AND C.PPSBOP = A.PP102SBO
                          AND C.PPTOPE = A.PP102TOP
                          AND C.PPFPAG BETWEEN FECHA_INICIO AND FECHA_FIN
                          AND C.D601CO  = 'S'
                          AND D.PGCOD   = C.PGCOD
                          AND D.PPMOD   = C.PPMOD
                          AND D.PPSUC   = C.PPSUC
                          AND D.PPMDA   = C.PPMDA
                          AND D.PPPAP   = C.PPPAP
                          AND D.PPCTA   = C.PPCTA
                          AND D.PPOPER  = C.PPOPER
                          AND D.PPSBOP  = C.PPSBOP
                          AND D.PPTOPE  = C.PPTOPE
                          AND D.PPFPAG  = C.PPFPAG
                          AND D.D602CO  = 'S'
                          AND D.PP1NUMP = (SELECT MAX(PP1NUMP)
                                             FROM FSD602
                                            WHERE PGCOD  = D.PGCOD
                                              AND PPMOD  = D.PPMOD
                                              AND PPSUC  = D.PPSUC
                                              AND PPMDA  = D.PPMDA
                                              AND PPPAP  = D.PPPAP
                                              AND PPCTA  = D.PPCTA
                                              AND PPOPER = D.PPOPER
                                              AND PPSBOP = D.PPSBOP
                                              AND PPTOPE = D.PPTOPE
                                              AND PPFPAG = D.PPFPAG
                                              AND D602CO = 'S')) T
                  WHERE T.PP1STAT = 'T';
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            OTROS_PAGOS := 0;
            BEGIN
               SELECT COUNT(*)
                 INTO OTROS_PAGOS
                 FROM (SELECT COUNT(DISTINCT B.PGCOD||B.SCMOD||B.SCMDA||B.SCPAP||B.SCCTA|| 
                                             B.SCSUC||B.SCOPER||B.SCSBOP||B.SCTOPE)
                         FROM FPP102 A, FSD011 B, FSH016 C, FSH015 D
                        WHERE A.PP102NCART = J.PP101NCART
                          AND A.PP102COD = B.PGCOD
                          AND A.PP102MOD IN (SELECT MODULO
                                               FROM FST111
                                              WHERE DSCOD  = 50
                                                AND MODULO = A.PP102MOD)
                          AND B.PGCOD  = A.PP102COD
                          AND B.SCMDA  = A.PP102MDA
                          AND B.SCPAP  = A.PP102PAP
                          AND B.SCCTA  = A.PP102CTA
                          AND B.SCSUC  = A.PP102SUC
                          AND B.SCOPER = A.PP102OPE
                          AND B.SCSBOP = A.PP102SBO
                          AND B.SCTOPE = DECODE(B.SCSTAT, 23, 550, A.PP102TOP)
                          AND B.SCSTAT IN (90, 64, 23)
                          AND C.PGCOD  = B.PGCOD
                          AND C.HMODUL = B.SCMOD
                          AND C.HCTA   = B.SCCTA
                          AND C.HOPER  = B.SCOPER
                          AND C.HCMOD IN (SELECT TP1CORR1
                                            FROM FST198
                                           WHERE TP1COD1 = 10876
                                             AND TP1CORR1 < 999999
                                             AND TP1NRO1 = 1)
                          AND C.HTRAN IN (SELECT TP1CORR2
                                            FROM FST198
                                           WHERE TP1COD1 = 10876
                                             AND TP1CORR1 < 999999
                                             AND TP1NRO1 = 1)
                          AND D.PGCOD  = C.PGCOD
                          AND D.HCMOD  = C.HCMOD
                          AND D.HSUCOR = C.HSUCOR
                          AND D.HTRAN  = C.HTRAN
                          AND D.HNREL  = C.HNREL
                          AND D.HFCON BETWEEN FECHA_INICIO AND FECHA_FIN
                          AND D.HCCORR = 0
                       UNION
                       SELECT COUNT(DISTINCT B.PGCOD||B.SCMOD||B.SCMDA||B.SCPAP||B.SCCTA|| 
                                             B.SCSUC||B.SCOPER||B.SCSBOP||B.SCTOPE)
                         FROM FPP102 A, FSD011 B, FSD016 C, FSD015 D
                        WHERE A.PP102NCART = J.PP101NCART
                          AND A.PP102COD = B.PGCOD
                          AND A.PP102MOD IN (SELECT MODULO
                                               FROM FST111
                                              WHERE DSCOD  = 50
                                                AND MODULO = A.PP102MOD)
                          AND B.PGCOD  = A.PP102COD
                          AND B.SCMDA  = A.PP102MDA
                          AND B.SCPAP  = A.PP102PAP
                          AND B.SCCTA  = A.PP102CTA
                          AND B.SCSUC  = A.PP102SUC
                          AND B.SCOPER = A.PP102OPE
                          AND B.SCSBOP = A.PP102SBO
                          AND B.SCTOPE = DECODE(B.SCSTAT, 23, 550, A.PP102TOP)
                          AND B.SCSTAT IN (90, 64, 23)
                          AND C.PGCOD  = B.PGCOD
                          AND C.MODULO = B.SCMOD
                          AND C.CTNRO  = B.SCCTA
                          AND C.ITOPER = B.SCOPER
                          AND C.ITMOD IN (SELECT TP1CORR1
                                            FROM FST198
                                           WHERE TP1COD1 = 10876
                                             AND TP1CORR1 < 999999
                                             AND TP1NRO1 = 1)
                          AND C.ITTRAN IN (SELECT TP1CORR2
                                             FROM FST198
                                            WHERE TP1COD1 = 10876
                                              AND TP1CORR1 < 999999
                                              AND TP1NRO1 = 1)
                          AND D.PGCOD  = C.PGCOD
                          AND D.ITMOD  = C.ITMOD
                          AND D.ITSUC  = C.ITSUC
                          AND D.ITTRAN = C.ITTRAN
                          AND D.ITNREL = C.ITNREL
                          AND D.ITFCON BETWEEN FECHA_INICIO AND FECHA_FIN
                          AND D.ITCONT = 'S');
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            TOTAL_CREDITOS     := TOTAL_CREDITOS + OTROS_PAGOS;
            PAGO_CUOTA_PARCIAL := PAGO_CUOTA_PARCIAL + OTROS_PAGOS;
               
            CLIENTE_SIN_PAGO := 0;
            CLIENTE_SIN_PAGO := ABS(TOTAL_CREDITOS - (PAGO_CUOTA_COMPLETA + PAGO_CUOTA_PARCIAL));
               
            BEGIN
               SELECT JAQA201DPAG
               INTO DIA_PAGO
               FROM JAQA201
               WHERE JAQA201NCA = J.PP101NCART;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            BEGIN
               INSERT INTO AQPC298
                  (AQPC298CORRELA, AQPC298CODREGI, AQPC298NOMREGI, AQPC298CODZONA, AQPC298NOMZONA, AQPC298CODSUCU, AQPC298NOMSUCU,
                   AQPC298CODASES, AQPC298NOMASES, AQPC298CODCONV, AQPC298NOMCONV, AQPC298MESREGI, AQPC298DATENVL, AQPC298DATRECL,
                   AQPC298DATRECC, AQPC298MEDPAGO, AQPC298MNTOCHQ, AQPC298DESCUOC, AQPC298DESCUOP, AQPC298SINDESC, AQPC298SINCHEQ,
                   AQPC298DIAPAGO, AQPC298FHREPAG, AQPC298PAGCUOC, AQPC298PAGCUOP,  AQPC298CLISINP, AQPC298USUEJEC, AQPC298FCHEJEC,
                   AQPC298HOREJEC)
               VALUES
                  (CORRELATIVO, J.REGCOD, J.REGNOM, J.CODZON, J.DESZON, J.SUCURS, J.SCNOM, J.JAQA300ARC, NULL, J.PP101NCART, J.PP101NOMC, 
                   MES_REGISTRO, DIAS_ATRASO_ENVIO_LISTADO, DIAS_ATRASO_RECOJO_LISTADO, DIAS_ATRASO_RECOJO_CHEQUE, MEDIO_PAGO, MONTO_CHEQUE,
                   DESCUENTO_CUOTA_COMPLETA, DESCUENTO_CUOTA_PARCIAL, SIN_DESCUENTO, SIN_CHEQUE, DIA_PAGO, DIA_PAGO_REAL, PAGO_CUOTA_COMPLETA,
                   PAGO_CUOTA_PARCIAL, CLIENTE_SIN_PAGO, P_USUARIO_EJECUTO, FECHA_SISTEMA, HORA_SISTEMA);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END LOOP;
         PERIODO := ADD_MONTHS(PERIODO, 1);    
      END LOOP;
   END SP_CR_REPORTE_SEGUIMIENTO;
   
   PROCEDURE SP_CR_REPORTE_SEGUIMIENTO_DETALLE(P_CODIGO_CONVENIO   IN NUMBER,
                                               P_CODIGO_REGION     IN NUMBER,
                                               P_CODIGO_ZONA       IN NUMBER,
                                               P_CODIGO_SUCURSAL   IN NUMBER,
                                               P_CODIGO_ASESOR     IN VARCHAR2,
                                               P_FECHA_INICIO      IN DATE,
                                               P_FECHA_FIN         IN DATE,
                                               P_USUARIO_EJECUTO   IN VARCHAR2) IS
      
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_REPORTE_SEGUIMIENTO_DETALLE
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 21/11/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : GENERA EL REPORTE DE SEGMENTO PERSONAS
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 27/03/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO EL CURSOR DATOS_CONVENIOS PARA REEEMPLAZAR 
      --                                 LA TABLA FST046 POR LA TABLA JAQA201 PARA OBTENER LA SUCURSAL.
      --                               - SE VALIDA SI LOS CREDITOS QUE ESTAN ASOCIADOS AL CONVENIO, SE
      --                                 ENCUENTRA VIGENTES, PARA MOSTRAR DICHO CONVENIO EN EL
      --                                 REPORTE.
      --                               - SE REEMPLAZA LA LECTURA DE LA TABLA JAQA33 Y JAQA32 POR LA TABLA
      --                                 JAQA31 PARA VERIFICAR SI TIENE UN "PAGO CASILLERO" O "PAGO CANJE PUBLICITARIO".
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 05/04/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO LA OBTENCION DE LOS PAGOS CUOTA COMPLETA,
      --                                 PAGOS CUOTA PARCIAL, CLIENTES SIN PAGO SIN DESCUENTO Y
      --                                 LA FECHA REAL DIA DE PAGO.
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 25/07/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO LA VALIDACION DE LOS CREDITOS
      --                                 VIGENTES POR CONVENIO.
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 25/07/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO LA CONSULTA QUE OBTIENE
      --                                 EL DIA DE PAGO.                             
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 01/04/2025
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO LA CONSULTA QUE VALIDA SI TIENE "PAGO CASILLERO"
      --                               - SE MODIFICO LA OBTENCION DEL MAXIMO CORRELATIVO
      --                                 DE LA TABLA JAQA38 Y JAQA39             
      -- *****************************************************************
                                            
      FECHA_SISTEMA               DATE;
      HORA_SISTEMA                VARCHAR2(8);
      MES_REGISTRO                VARCHAR2(30);
      FECHA_INICIO                DATE;
      FECHA_FIN                   DATE;
      PERIODO                     DATE;
      CORRELATIVO                 NUMBER(9);
      DIA_ATRASO_ENVIO_LISTADO    NUMBER(5);
      DIA_ATRASO_RECOJO_LISTADO   NUMBER(5);
      DIA_ATRASO_RECOJO_CHEQUE    NUMBER(5);
      DIA_ARCHIVO_ENVIO_LISTADO   NUMBER(5);
      DIA_RECOJO_LISTADO          NUMBER(5);
      DIA_ARCHIVO_RECOJO_LISTADO  NUMBER(5);
      DIA_ARCHIVO_RECOJO_CHEQUE   NUMBER(5);
      MEDIO_PAGO                  VARCHAR2(25);
      MONTO_CHEQUE                NUMBER(17, 2);
      DESCUENTO_CUOTA_COMPLETA    NUMBER(9);
      DESCUENTO_CUOTA_PARCIAL     NUMBER(9);
      SIN_DESCUENTO               NUMBER(9);
      SIN_CHEQUE                  VARCHAR2(250);
      DIA_PAGO_REAL               NUMBER(5);
      PAGO_CUOTA_COMPLETA         NUMBER(5);
      PAGO_CUOTA_PARCIAL          NUMBER(5);
      CLIENTE_SIN_PAGO            NUMBER(5);
      MODALIDAD_PRESENTACION      VARCHAR2(50);
      REGISTRO_CARGO_RECEPCION    DATE;
      USUARIO_SUBIO_CARGO_LISTADO VARCHAR2(30);
      MODALIDAD_RECEPCION         VARCHAR2(50); 
      REGISTRO_CARGO              DATE; 
      USUARIO_SUBIO_CARGO_CHEQUE  VARCHAR2(10);
      PAGO_CASILLERO              VARCHAR2(2);
      PAGO_CANJE_PUBLICITARIO     VARCHAR2(2);
      CARGA_SISTEMA_LISTADO       VARCHAR2(2);
      MODALIDAD_ENVIO             VARCHAR2(50);
      TIPO_CARGA_LISTADO          VARCHAR2(50);
      TOTAL_CREDITOS              NUMBER(17);
      OTROS_PAGOS                 NUMBER(5);
      
      CURSOR DATOS_CONVENIOS IS
         SELECT A.PP101NCART, C.JAQA201DPAG, A.PP101NOMC, D.REGCOD, D.REGNOM,
                D.CODZON, D.DESZON, D.SUCURS, D.SCNOM, B.JAQA300ARC,
                B.JAQA300FEL, B.JAQA300FRC
           FROM FPP101 A, JAQA300 B, JAQA201 C, REGSUC D
          WHERE A.PP101NCART = B.JAQA300NCO
            AND C.JAQA201NCA = A.PP101NCART
            AND D.SUCURS     = C.JAQA201ARE
            AND A.PP101NCART = DECODE(NVL(P_CODIGO_CONVENIO, 0), 0, A.PP101NCART, P_CODIGO_CONVENIO)
            AND B.JAQA300ARC = DECODE(NVL(P_CODIGO_ASESOR, ' '), ' ', B.JAQA300ARC, RPAD(P_CODIGO_ASESOR, 10, ' '))
            AND C.JAQA201ARE IN (SELECT SUCURS
                                   FROM REGSUC
                                  WHERE REGCOD = DECODE(NVL(P_CODIGO_REGION, 0), 0, REGCOD, P_CODIGO_REGION)
                                    AND CODZON = DECODE(NVL(P_CODIGO_ZONA, 0), 0, CODZON, P_CODIGO_ZONA)
                                    AND SUCURS = DECODE(NVL(P_CODIGO_SUCURSAL, 0), 0, SUCURS, P_CODIGO_SUCURSAL))
            AND (SELECT COUNT(*)
                   FROM FPP102, FSD011 
                  WHERE PP102NCART = A.PP101NCART
                    AND PGCOD  = PP102COD
                    AND SCMOD  = PP102MOD
                    AND SCSUC  = PP102SUC
                    AND SCMDA  = PP102MDA
                    AND SCPAP  = PP102PAP
                    AND SCCTA  = PP102CTA
                    AND SCOPER = PP102OPE
                    AND SCSBOP = PP102SBO
                    AND SCTOPE = PP102TOP
                    AND SCSTAT <> 99
                    ) > 0;   
   BEGIN
      BEGIN
         SELECT PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
           INTO FECHA_SISTEMA, HORA_SISTEMA
           FROM FST017
          WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         DELETE FROM AQPC299 WHERE AQPC299USUEJEC = P_USUARIO_EJECUTO;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      PERIODO      := NULL;
      CORRELATIVO  := 0;
      PERIODO      := P_FECHA_INICIO;
      WHILE TRUNC(PERIODO, 'MONTH') <= TRUNC(P_FECHA_FIN, 'MONTH') LOOP
         MES_REGISTRO := TRIM(TO_CHAR(PERIODO,'MONTH', 'NLS_DATE_LANGUAGE = SPANISH')) ||
                         ' - ' || EXTRACT(YEAR FROM PERIODO);
         FOR J IN DATOS_CONVENIOS LOOP
            DIA_ATRASO_ENVIO_LISTADO    := NULL;
            DIA_ATRASO_RECOJO_LISTADO   := NULL;
            DIA_ATRASO_RECOJO_CHEQUE    := NULL;
            DIA_ARCHIVO_ENVIO_LISTADO   :=NULL;
            DIA_RECOJO_LISTADO          := NULL;
            DIA_ARCHIVO_RECOJO_LISTADO  := NULL;
            DIA_ARCHIVO_RECOJO_CHEQUE   := NULL;
            MEDIO_PAGO                  := NULL;
            MONTO_CHEQUE                := NULL;
            DESCUENTO_CUOTA_COMPLETA    := NULL;
            DESCUENTO_CUOTA_PARCIAL     := NULL;
            SIN_DESCUENTO               := NULL;
            SIN_CHEQUE                  := NULL;
            PAGO_CUOTA_COMPLETA         := NULL;
            PAGO_CUOTA_PARCIAL          := NULL;
            CLIENTE_SIN_PAGO            := NULL;
            MODALIDAD_PRESENTACION      := NULL;
            REGISTRO_CARGO_RECEPCION    := NULL;
            USUARIO_SUBIO_CARGO_LISTADO := NULL;
            MODALIDAD_RECEPCION         := NULL;
            REGISTRO_CARGO              := NULL; 
            USUARIO_SUBIO_CARGO_CHEQUE  := NULL;
            PAGO_CASILLERO              := NULL;
            PAGO_CANJE_PUBLICITARIO     := NULL;
            CARGA_SISTEMA_LISTADO       := NULL;
            MODALIDAD_ENVIO             := NULL;
            FECHA_INICIO                := NULL;
            FECHA_FIN                   := NULL;
            TIPO_CARGA_LISTADO          := NULL;
         
            CORRELATIVO := CORRELATIVO + 1;
            IF CORRELATIVO = 1 AND TRUNC(PERIODO, 'MONTH') < TRUNC(P_FECHA_FIN, 'MONTH') THEN
               FECHA_INICIO := P_FECHA_INICIO;
               FECHA_FIN    := LAST_DAY(PERIODO);
            ELSE
               IF TRUNC(PERIODO, 'MONTH') = TRUNC(P_FECHA_FIN, 'MONTH') THEN
                  FECHA_INICIO := TRUNC(PERIODO, 'MONTH');
                  FECHA_FIN    := P_FECHA_FIN;
               ELSE
                  IF TRUNC(PERIODO, 'MONTH') < TRUNC(P_FECHA_FIN, 'MONTH') THEN
                     FECHA_INICIO := TRUNC(PERIODO, 'MONTH');
                     FECHA_FIN    := LAST_DAY(PERIODO);
                  END IF;
               END IF;
            END IF;
               
            IF NVL(J.JAQA300FEL, 0) = 0 THEN
               DIA_ATRASO_ENVIO_LISTADO := NULL;
               DIA_ARCHIVO_ENVIO_LISTADO := NULL;
            ELSE
               BEGIN
                  SELECT (NVL(EXTRACT(DAY FROM B.JAQA38FCH), 0) - J.JAQA300FEL), NVL(EXTRACT(DAY FROM B.JAQA38FCH), 0)
                    INTO DIA_ATRASO_ENVIO_LISTADO, DIA_ARCHIVO_ENVIO_LISTADO
                    FROM JAQA38 B
                   WHERE B.JAQA38NCO = J.PP101NCART
                     AND B.JAQA38COD = (SELECT TP1NRO1 
                                          FROM FST198 
                                         WHERE TP1COD   = 1 
                                           AND TP1COD1  = 111154 
                                           AND TP1CORR1 = 1 
                                           AND TP1CORR2 = 19 
                                           AND TP1CORR3 = 1)
                     AND B.JAQA38FCH =
                         (SELECT MAX(JAQA38FCH)
                            FROM JAQA38
                           WHERE JAQA38NCO = B.JAQA38NCO
                             AND JAQA38COD = B.JAQA38COD
                             AND JAQA38FCH BETWEEN FECHA_INICIO AND FECHA_FIN)
                     AND B.JAQA38COR =
                         (SELECT MAX(JAQA38COR)
                            FROM JAQA38
                           WHERE JAQA38NCO = B.JAQA38NCO
                             AND JAQA38COD = B.JAQA38COD
                             AND JAQA38FCH = B.JAQA38FCH);
               EXCEPTION
                  WHEN OTHERS THEN
                     BEGIN
                        DIA_ATRASO_ENVIO_LISTADO := FECHA_SISTEMA - 
                                                    TO_DATE(J.JAQA300FEL || '/' ||TO_CHAR(FECHA_INICIO, 'MM/RRRR'), 'DD/MM/RRRR');      
                     EXCEPTION
                        WHEN OTHERS THEN
                           DIA_ATRASO_ENVIO_LISTADO := FECHA_SISTEMA - LAST_DAY(FECHA_INICIO);    
                     END;
               END;
            END IF;
            BEGIN
               SELECT TRIM(B.JAQA37NOM)
                 INTO MODALIDAD_PRESENTACION
                 FROM JAQA38 A, JAQA37 B
                WHERE A.JAQA38NCO = J.PP101NCART
                  AND A.JAQA38COD = B.JAQA37COD
                  AND A.JAQA38FCH =
                      (SELECT MAX(JAQA38FCH)
                         FROM JAQA38
                        WHERE JAQA38NCO = A.JAQA38NCO
                          AND JAQA38COD = A.JAQA38COD
                          AND JAQA38FCH BETWEEN FECHA_INICIO AND FECHA_FIN)
                  AND A.JAQA38COR =
                      (SELECT MAX(JAQA38COR)
                         FROM JAQA38
                        WHERE JAQA38NCO = A.JAQA38NCO
                          AND JAQA38COD = A.JAQA38COD
                          AND JAQA38FCH = A.JAQA38FCH)
                   AND A.JAQA38COD = (SELECT TP1NRO1 
                                        FROM FST198 
                                       WHERE TP1COD   = 1 
                                         AND TP1COD1  = 111154 
                                         AND TP1CORR1 = 1 
                                         AND TP1CORR2 = 19 
                                         AND TP1CORR3 = 3);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            BEGIN
               SELECT JAQA31DRL, CASE WHEN JAQA31RCR = 'S' THEN 'SI' ELSE 'N' END,
                      CASE WHEN JAQA31TLS = 'A' THEN 'AUTOMATICO' ELSE 'MANUAL' END
                 INTO DIA_RECOJO_LISTADO, CARGA_SISTEMA_LISTADO, MODALIDAD_ENVIO
                 FROM JAQA31
                WHERE JAQA31NCO = J.PP101NCART;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            IF NVL(DIA_RECOJO_LISTADO, 0) = 0 THEN
               DIA_ATRASO_RECOJO_LISTADO  := NULL;
               DIA_ARCHIVO_RECOJO_LISTADO := NULL;
            ELSE
               BEGIN
                  SELECT (NVL(EXTRACT(DAY FROM A.JAQA38FCH), 0) - NVL(DIA_RECOJO_LISTADO, 0)),
                          NVL(EXTRACT(DAY FROM A.JAQA38FCH), 0), 
                          CASE WHEN TRIM(A.JAQA38AC1) = 'M' THEN 'MANUAL' 
                               WHEN TRIM(A.JAQA38AC1) = 'D' THEN 'DIGITAL'
                               ELSE
                                 NULL
                          END
                    INTO DIA_ATRASO_RECOJO_LISTADO, DIA_ARCHIVO_RECOJO_LISTADO, 
                         TIPO_CARGA_LISTADO
                    FROM JAQA38 A
                   WHERE A.JAQA38NCO = J.PP101NCART
                     AND A.JAQA38COD = (SELECT TP1NRO1 
                                          FROM FST198 
                                         WHERE TP1COD   = 1 
                                           AND TP1COD1  = 111154 
                                           AND TP1CORR1 = 1 
                                           AND TP1CORR2 = 19 
                                           AND TP1CORR3 = 2)
                     AND A.JAQA38FCH =
                         (SELECT MAX(JAQA38FCH)
                            FROM JAQA38
                           WHERE JAQA38NCO = J.PP101NCART
                             AND JAQA38COD = A.JAQA38COD
                             AND JAQA38FCH BETWEEN FECHA_INICIO AND FECHA_FIN)
                     AND A.JAQA38COR =
                         (SELECT MAX(JAQA38COR)
                            FROM JAQA38
                           WHERE JAQA38NCO = A.JAQA38NCO
                             AND JAQA38COD = A.JAQA38COD
                             AND JAQA38FCH = A.JAQA38FCH);
               EXCEPTION
                  WHEN OTHERS THEN
                     BEGIN
                        DIA_ATRASO_RECOJO_LISTADO := FECHA_SISTEMA - 
                                                     TO_DATE(DIA_RECOJO_LISTADO || '/' ||TO_CHAR(FECHA_INICIO,'MM/RRRR'), 'DD/MM/RRRR');  
                     EXCEPTION
                        WHEN OTHERS THEN
                           DIA_ATRASO_RECOJO_LISTADO := FECHA_SISTEMA - LAST_DAY(FECHA_INICIO);    
                     END;
               END;
            END IF;
            BEGIN
               SELECT JAQA38FCH, TRIM(JAQA38USU)
                 INTO REGISTRO_CARGO_RECEPCION, USUARIO_SUBIO_CARGO_LISTADO
                 FROM JAQA38 A
                WHERE A.JAQA38NCO = J.PP101NCART
                  AND A.JAQA38COD = (SELECT TP1NRO1 
                                       FROM FST198 
                                      WHERE TP1COD   = 1 
                                        AND TP1COD1  = 111154 
                                        AND TP1CORR1 = 1 
                                        AND TP1CORR2 = 19 
                                        AND TP1CORR3 = 4)
                  AND A.JAQA38FCH =
                      (SELECT MAX(JAQA38FCH)
                         FROM JAQA38
                        WHERE JAQA38NCO = J.PP101NCART
                          AND JAQA38COD = A.JAQA38COD
                          AND JAQA38FCH BETWEEN FECHA_INICIO AND FECHA_FIN)
                  AND A.JAQA38COR =
                      (SELECT MAX(JAQA38COR)
                         FROM JAQA38
                        WHERE JAQA38NCO = J.PP101NCART
                          AND JAQA38COD = A.JAQA38COD
                          AND JAQA38FCH = A.JAQA38FCH);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            IF NVL(J.JAQA300FRC, 0) = 0 THEN
               DIA_ATRASO_RECOJO_CHEQUE := NULL;
               DIA_ARCHIVO_RECOJO_CHEQUE := NULL;
            ELSE
               BEGIN
                  SELECT (NVL(EXTRACT(DAY FROM A.JAQA39FEC), 0) - J.JAQA300FRC),
                          NVL(EXTRACT(DAY FROM A.JAQA39FEC), 0)
                    INTO DIA_ATRASO_RECOJO_CHEQUE, DIA_ARCHIVO_RECOJO_CHEQUE
                    FROM JAQA39 A
                   WHERE A.JAQA39NCO = J.PP101NCART
                     AND A.JAQA39FEC =
                         (SELECT MAX(JAQA39FEC)
                            FROM JAQA39
                           WHERE JAQA39NCO = J.PP101NCART
                             AND JAQA39FEC BETWEEN FECHA_INICIO AND FECHA_FIN)
                     AND A.JAQA39COR =
                         (SELECT MAX(JAQA39COR)
                            FROM JAQA39
                           WHERE JAQA39NCO = J.PP101NCART
                             AND JAQA39FEC = A.JAQA39FEC);
               EXCEPTION
                  WHEN OTHERS THEN
                     BEGIN
                        DIA_ATRASO_RECOJO_CHEQUE := FECHA_SISTEMA - 
                                                     TO_DATE(J.JAQA300FRC || '/' ||TO_CHAR(FECHA_INICIO, 'MM/RRRR'), 'DD/MM/RRRR');  
                     EXCEPTION
                        WHEN OTHERS THEN
                           DIA_ATRASO_RECOJO_CHEQUE := FECHA_SISTEMA - LAST_DAY(FECHA_INICIO);    
                     END;
               END;
            END IF;
            BEGIN
               SELECT TRIM(B.JAQA37NOM), A.JAQA38FCH, TRIM(A.JAQA38USU)
                 INTO MODALIDAD_RECEPCION, REGISTRO_CARGO, USUARIO_SUBIO_CARGO_CHEQUE
                 FROM JAQA38 A, JAQA37 B
                WHERE A.JAQA38NCO = J.PP101NCART
                  AND A.JAQA38COD = B.JAQA37COD
                  AND A.JAQA38FCH =
                      (SELECT MAX(JAQA38FCH)
                         FROM JAQA38
                        WHERE JAQA38NCO = J.PP101NCART
                          AND JAQA38COD = A.JAQA38COD
                          AND JAQA38FCH BETWEEN FECHA_INICIO AND FECHA_FIN)
                  AND A.JAQA38COR =
                      (SELECT MAX(JAQA38COR)
                         FROM JAQA38
                        WHERE JAQA38NCO = J.PP101NCART
                          AND JAQA38COD = A.JAQA38COD
                          AND JAQA38FCH = A.JAQA38FCH)
                   AND A.JAQA38COD = (SELECT TP1NRO1 
                                        FROM FST198 
                                       WHERE TP1COD   = 1 
                                         AND TP1COD1  = 111154 
                                         AND TP1CORR1 = 1 
                                         AND TP1CORR2 = 19 
                                         AND TP1CORR3 = 5);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            BEGIN
               SELECT A.JAQA39MPG, A.JAQA39MCT, A.JAQA39DCO, A.JAQA39DPA,
                      A.JAQA39SND, A.JAQA39MND
                 INTO MEDIO_PAGO, MONTO_CHEQUE, DESCUENTO_CUOTA_COMPLETA,
                      DESCUENTO_CUOTA_PARCIAL, SIN_DESCUENTO, SIN_CHEQUE
                 FROM JAQA39 A
                WHERE A.JAQA39NCO = J.PP101NCART
                  AND A.JAQA39FEC =
                      (SELECT MAX(JAQA39FEC)
                         FROM JAQA39
                        WHERE JAQA39NCO = J.PP101NCART
                          AND JAQA39FEC BETWEEN FECHA_INICIO AND FECHA_FIN)
                  AND A.JAQA39COR =
                      (SELECT MAX(JAQA39COR)
                         FROM JAQA39
                        WHERE JAQA39NCO = J.PP101NCART
                          AND JAQA39FEC = A.JAQA39FEC);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            DIA_PAGO_REAL := NULL;
            BEGIN
               SELECT EXTRACT(DAY FROM MAX(D.D602FC))
                 INTO DIA_PAGO_REAL
                 FROM FPP102 A, FSD011 B, FSD601 C, FSD602 D
                WHERE A.PP102NCART = J.PP101NCART
                  AND A.PP102COD   = B.PGCOD
                  AND A.PP102MOD   = (SELECT MODULO
                                        FROM FST111
                                       WHERE DSCOD  = 50
                                         AND MODULO = A.PP102MOD)
                  AND A.PP102SUC = B.SCSUC
                  AND A.PP102MDA = B.SCMDA
                  AND A.PP102PAP = B.SCPAP
                  AND A.PP102CTA = B.SCCTA
                  AND A.PP102OPE = B.SCOPER
                  AND A.PP102SBO = B.SCSBOP
                  AND A.PP102TOP = B.SCTOPE
                  AND B.SCSTAT <> 99
                  AND C.PGCOD  = A.PP102COD
                  AND C.PPMOD  = A.PP102MOD
                  AND C.PPSUC  = A.PP102SUC
                  AND C.PPMDA  = A.PP102MDA
                  AND C.PPPAP  = A.PP102PAP
                  AND C.PPCTA  = A.PP102CTA
                  AND C.PPOPER = A.PP102OPE
                  AND C.PPSBOP = A.PP102SBO
                  AND C.PPTOPE = A.PP102TOP
                  AND C.PPFPAG BETWEEN FECHA_INICIO AND FECHA_FIN
                  AND C.D601CO = 'S'
                  AND D.PGCOD  = C.PGCOD
                  AND D.PPMOD  = C.PPMOD
                  AND D.PPSUC  = C.PPSUC
                  AND D.PPMDA  = C.PPMDA
                  AND D.PPPAP  = C.PPPAP
                  AND D.PPCTA  = C.PPCTA
                  AND D.PPOPER = C.PPOPER
                  AND D.PPSBOP = C.PPSBOP
                  AND D.PPTOPE = C.PPTOPE
                  AND D.PPFPAG = C.PPFPAG
                  AND D.D602CO = 'S'
                  AND D.D602MO = (SELECT TP1NRO1
                                     FROM FST198
                                    WHERE TP1COD   = 1
                                      AND TP1COD1  = 111154
                                      AND TP1CORR1 = 1
                                      AND TP1CORR2 = 29
                                      AND TP1CORR3 = 1
                                      AND TP1IMP1  = 1)
                  AND D.D602TR = (SELECT TP1NRO2
                                    FROM FST198
                                   WHERE TP1COD   = 1
                                     AND TP1COD1  = 111154
                                     AND TP1CORR1 = 1
                                     AND TP1CORR2 = 29
                                     AND TP1CORR3 = 1
                                     AND TP1IMP1  = 1);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            TOTAL_CREDITOS := 0;
            BEGIN
               SELECT COUNT(*)
                 INTO TOTAL_CREDITOS
                 FROM FPP102 A, FSD011 B, FSD601 C
                WHERE A.PP102NCART = J.PP101NCART
                  AND A.PP102COD   = B.PGCOD
                  AND A.PP102MOD   = (SELECT MODULO
                                        FROM FST111
                                       WHERE DSCOD  = 50
                                         AND MODULO = A.PP102MOD)
                  AND A.PP102SUC = B.SCSUC
                  AND A.PP102MDA = B.SCMDA
                  AND A.PP102PAP = B.SCPAP
                  AND A.PP102CTA = B.SCCTA
                  AND A.PP102OPE = B.SCOPER
                  AND A.PP102SBO = B.SCSBOP
                  AND A.PP102TOP = B.SCTOPE
                  AND B.SCSTAT   <> 99
                  AND C.PGCOD  = A.PP102COD
                  AND C.PPMOD  = A.PP102MOD
                  AND C.PPSUC  = A.PP102SUC
                  AND C.PPMDA  = A.PP102MDA
                  AND C.PPPAP  = A.PP102PAP
                  AND C.PPCTA  = A.PP102CTA
                  AND C.PPOPER = A.PP102OPE
                  AND C.PPSBOP = A.PP102SBO
                  AND C.PPTOPE = A.PP102TOP
                  AND C.PPFPAG BETWEEN FECHA_INICIO AND FECHA_FIN;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            PAGO_CUOTA_PARCIAL := 0;
            BEGIN
               SELECT COUNT(*)
                 INTO PAGO_CUOTA_PARCIAL
                 FROM (SELECT D.*
                         FROM FPP102 A, FSD011 B, FSD601 C, FSD602 D
                        WHERE A.PP102NCART = J.PP101NCART
                          AND A.PP102COD   = B.PGCOD
                          AND A.PP102MOD   = (SELECT MODULO
                                                FROM FST111
                                               WHERE DSCOD  = 50
                                                 AND MODULO = A.PP102MOD)
                          AND A.PP102SUC = B.SCSUC
                          AND A.PP102MDA = B.SCMDA
                          AND A.PP102PAP = B.SCPAP
                          AND A.PP102CTA = B.SCCTA
                          AND A.PP102OPE = B.SCOPER
                          AND A.PP102SBO = B.SCSBOP
                          AND A.PP102TOP = B.SCTOPE
                          AND B.SCSTAT <> 99
                          AND C.PGCOD  = A.PP102COD
                          AND C.PPMOD  = A.PP102MOD
                          AND C.PPSUC  = A.PP102SUC
                          AND C.PPMDA  = A.PP102MDA
                          AND C.PPPAP  = A.PP102PAP
                          AND C.PPCTA  = A.PP102CTA
                          AND C.PPOPER = A.PP102OPE
                          AND C.PPSBOP = A.PP102SBO
                          AND C.PPTOPE = A.PP102TOP
                          AND C.PPFPAG BETWEEN FECHA_INICIO AND FECHA_FIN
                          AND C.D601CO  = 'S'
                          AND D.PGCOD   = C.PGCOD
                          AND D.PPMOD   = C.PPMOD
                          AND D.PPSUC   = C.PPSUC
                          AND D.PPMDA   = C.PPMDA
                          AND D.PPPAP   = C.PPPAP
                          AND D.PPCTA   = C.PPCTA
                          AND D.PPOPER  = C.PPOPER
                          AND D.PPSBOP  = C.PPSBOP
                          AND D.PPTOPE  = C.PPTOPE
                          AND D.PPFPAG  = C.PPFPAG
                          AND D.D602CO  = 'S'
                          AND D.PP1NUMP = (SELECT MAX(PP1NUMP)
                                             FROM FSD602
                                            WHERE PGCOD  = D.PGCOD
                                              AND PPMOD  = D.PPMOD
                                              AND PPSUC  = D.PPSUC
                                              AND PPMDA  = D.PPMDA
                                              AND PPPAP  = D.PPPAP
                                              AND PPCTA  = D.PPCTA
                                              AND PPOPER = D.PPOPER
                                              AND PPSBOP = D.PPSBOP
                                              AND PPTOPE = D.PPTOPE
                                              AND PPFPAG = D.PPFPAG
                                              AND D602CO = 'S')) D
                  WHERE D.PP1STAT = 'P';
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            PAGO_CUOTA_COMPLETA := 0;
            BEGIN
               SELECT COUNT(*)
                 INTO PAGO_CUOTA_COMPLETA
                 FROM (SELECT D.*
                         FROM FPP102 A, FSD011 B, FSD601 C, FSD602 D
                        WHERE A.PP102NCART = J.PP101NCART
                          AND A.PP102COD   = B.PGCOD
                          AND A.PP102MOD   = (SELECT MODULO
                                                FROM FST111
                                               WHERE DSCOD  = 50
                                                 AND MODULO = A.PP102MOD)
                          AND A.PP102SUC = B.SCSUC
                          AND A.PP102MDA = B.SCMDA
                          AND A.PP102PAP = B.SCPAP
                          AND A.PP102CTA = B.SCCTA
                          AND A.PP102OPE = B.SCOPER
                          AND A.PP102SBO = B.SCSBOP
                          AND A.PP102TOP = B.SCTOPE
                          AND B.SCSTAT <> 99
                          AND C.PGCOD  = A.PP102COD
                          AND C.PPMOD  = A.PP102MOD
                          AND C.PPSUC  = A.PP102SUC
                          AND C.PPMDA  = A.PP102MDA
                          AND C.PPPAP  = A.PP102PAP
                          AND C.PPCTA  = A.PP102CTA
                          AND C.PPOPER = A.PP102OPE
                          AND C.PPSBOP = A.PP102SBO
                          AND C.PPTOPE = A.PP102TOP
                          AND C.PPFPAG BETWEEN FECHA_INICIO AND FECHA_FIN
                          AND C.D601CO  = 'S'
                          AND D.PGCOD   = C.PGCOD
                          AND D.PPMOD   = C.PPMOD
                          AND D.PPSUC   = C.PPSUC
                          AND D.PPMDA   = C.PPMDA
                          AND D.PPPAP   = C.PPPAP
                          AND D.PPCTA   = C.PPCTA
                          AND D.PPOPER  = C.PPOPER
                          AND D.PPSBOP  = C.PPSBOP
                          AND D.PPTOPE  = C.PPTOPE
                          AND D.PPFPAG  = C.PPFPAG
                          AND D.D602CO  = 'S'
                          AND D.PP1NUMP = (SELECT MAX(PP1NUMP)
                                             FROM FSD602
                                            WHERE PGCOD  = D.PGCOD
                                              AND PPMOD  = D.PPMOD
                                              AND PPSUC  = D.PPSUC
                                              AND PPMDA  = D.PPMDA
                                              AND PPPAP  = D.PPPAP
                                              AND PPCTA  = D.PPCTA
                                              AND PPOPER = D.PPOPER
                                              AND PPSBOP = D.PPSBOP
                                              AND PPTOPE = D.PPTOPE
                                              AND PPFPAG = D.PPFPAG
                                              AND D602CO = 'S')) D
                  WHERE D.PP1STAT = 'T';
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            OTROS_PAGOS := 0;
            BEGIN
               SELECT COUNT(*)
                 INTO OTROS_PAGOS
                 FROM (SELECT COUNT(DISTINCT B.PGCOD||B.SCMOD||B.SCMDA||B.SCPAP||B.SCCTA|| 
                                             B.SCSUC||B.SCOPER||B.SCSBOP||B.SCTOPE)
                         FROM FPP102 A, FSD011 B, FSH016 C, FSH015 D
                        WHERE A.PP102NCART = J.PP101NCART
                          AND A.PP102COD = B.PGCOD
                          AND A.PP102MOD IN (SELECT MODULO
                                               FROM FST111
                                              WHERE DSCOD  = 50
                                                AND MODULO = A.PP102MOD)
                          AND B.PGCOD  = A.PP102COD
                          AND B.SCMDA  = A.PP102MDA
                          AND B.SCPAP  = A.PP102PAP
                          AND B.SCCTA  = A.PP102CTA
                          AND B.SCSUC  = A.PP102SUC
                          AND B.SCOPER = A.PP102OPE
                          AND B.SCSBOP = A.PP102SBO
                          AND B.SCTOPE = DECODE(B.SCSTAT, 23, 550, A.PP102TOP)
                          AND B.SCSTAT IN (90, 64, 23)
                          AND C.PGCOD  = B.PGCOD
                          AND C.HMODUL = B.SCMOD
                          AND C.HCTA   = B.SCCTA
                          AND C.HOPER  = B.SCOPER
                          AND C.HCMOD IN (SELECT TP1CORR1
                                            FROM FST198
                                           WHERE TP1COD1 = 10876
                                             AND TP1CORR1 < 999999
                                             AND TP1NRO1 = 1)
                          AND C.HTRAN IN (SELECT TP1CORR2
                                            FROM FST198
                                           WHERE TP1COD1 = 10876
                                             AND TP1CORR1 < 999999
                                             AND TP1NRO1 = 1)
                          AND D.PGCOD  = C.PGCOD
                          AND D.HCMOD  = C.HCMOD
                          AND D.HSUCOR = C.HSUCOR
                          AND D.HTRAN  = C.HTRAN
                          AND D.HNREL  = C.HNREL
                          AND D.HFCON BETWEEN FECHA_INICIO AND FECHA_FIN
                          AND D.HCCORR = 0
                       UNION
                       SELECT COUNT(DISTINCT B.PGCOD||B.SCMOD||B.SCMDA||B.SCPAP||B.SCCTA|| 
                                             B.SCSUC||B.SCOPER||B.SCSBOP||B.SCTOPE)
                         FROM FPP102 A, FSD011 B, FSD016 C, FSD015 D
                        WHERE A.PP102NCART = J.PP101NCART
                          AND A.PP102COD = B.PGCOD
                          AND A.PP102MOD IN (SELECT MODULO
                                               FROM FST111
                                              WHERE DSCOD  = 50
                                                AND MODULO = A.PP102MOD)
                          AND B.PGCOD  = A.PP102COD
                          AND B.SCMDA  = A.PP102MDA
                          AND B.SCPAP  = A.PP102PAP
                          AND B.SCCTA  = A.PP102CTA
                          AND B.SCSUC  = A.PP102SUC
                          AND B.SCOPER = A.PP102OPE
                          AND B.SCSBOP = A.PP102SBO
                          AND B.SCTOPE = DECODE(B.SCSTAT, 23, 550, A.PP102TOP)
                          AND B.SCSTAT IN (90, 64, 23)
                          AND C.PGCOD  = B.PGCOD
                          AND C.MODULO = B.SCMOD
                          AND C.CTNRO  = B.SCCTA
                          AND C.ITOPER = B.SCOPER
                          AND C.ITMOD IN (SELECT TP1CORR1
                                            FROM FST198
                                           WHERE TP1COD1 = 10876
                                             AND TP1CORR1 < 999999
                                             AND TP1NRO1 = 1)
                          AND C.ITTRAN IN (SELECT TP1CORR2
                                             FROM FST198
                                            WHERE TP1COD1 = 10876
                                              AND TP1CORR1 < 999999
                                              AND TP1NRO1 = 1)
                          AND D.PGCOD  = C.PGCOD
                          AND D.ITMOD  = C.ITMOD
                          AND D.ITSUC  = C.ITSUC
                          AND D.ITTRAN = C.ITTRAN
                          AND D.ITNREL = C.ITNREL
                          AND D.ITFCON BETWEEN FECHA_INICIO AND FECHA_FIN
                          AND D.ITCONT = 'S');
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
               
            TOTAL_CREDITOS     := TOTAL_CREDITOS + OTROS_PAGOS;
            PAGO_CUOTA_PARCIAL := PAGO_CUOTA_PARCIAL + OTROS_PAGOS;
               
            CLIENTE_SIN_PAGO := 0;
            CLIENTE_SIN_PAGO := ABS(TOTAL_CREDITOS - (PAGO_CUOTA_COMPLETA + PAGO_CUOTA_PARCIAL));
               
            BEGIN
               SELECT 'SI'
                 INTO PAGO_CASILLERO
                 FROM JAQA31
                WHERE JAQA31NCO = J.PP101NCART
                  AND JAQA31TPC IS NOT NULL
                  AND JAQA31TPC NOT IN (0, 99);
            EXCEPTION
               WHEN OTHERS THEN
                  PAGO_CASILLERO := 'NO';
            END;
               
            BEGIN
               SELECT 'SI'
                 INTO PAGO_CANJE_PUBLICITARIO
                 FROM JAQA31
                WHERE JAQA31NCO = J.PP101NCART
                  AND JAQA31CPB = 'S';
            EXCEPTION
               WHEN OTHERS THEN
                  PAGO_CANJE_PUBLICITARIO := 'NO';
            END;

            BEGIN
               INSERT INTO AQPC299
                  (AQPC299CORRELA, AQPC299CODREGI, AQPC299NOMREGI, AQPC299CODZONA, AQPC299NOMZONA, AQPC299CODSUCU, AQPC299NOMSUCU,
                   AQPC299CODASES, AQPC299NOMASES, AQPC299CODCONV, AQPC299NOMCONV, AQPC299MESREGI, AQPC299DIAENVL, AQPC299FHRENVL,
                   AQPC299DATRENV, AQPC299MODLENV, AQPC299MODLPRE, AQPC299DRELIST, AQPC299FHRRLST, AQPC299DATRLIS, AQPC299REGCRGR, 
                   AQPC299USUSCLS, AQPC299DRCHQTR, AQPC299FHRRCHQ, AQPC299DATRCHQ, AQPC299MODLREC, AQPC299REGICRG, AQPC299USUSCCH, 
                   AQPC299MEDPAGO, AQPC299MTOCHTR, AQPC299DESCUOC, AQPC299DESCUOP, AQPC299SINDESC, AQPC299SINCHTR, AQPC299CRGLIST,
                   AQPC299TIPCRGL, AQPC299CRGSISL, AQPC299DIAPAGO, AQPC299FHRDPAG, AQPC299EJECPAG, AQPC299PAGCUOC, AQPC299PAGCUOP, 
                   AQPC299CLISPSD, AQPC299PAGCASI, AQPC299PAGCPUB, AQPC299USUEJEC, AQPC299FCHEJEC, AQPC299HOREJEC)
               VALUES
                  (CORRELATIVO, J.REGCOD, J.REGNOM, J.CODZON, J.DESZON, J.SUCURS, J.SCNOM, J.JAQA300ARC, NULL, J.PP101NCART, J.PP101NOMC, 
                   MES_REGISTRO, J.JAQA300FEL, DIA_ARCHIVO_ENVIO_LISTADO, DIA_ATRASO_ENVIO_LISTADO, MODALIDAD_ENVIO, MODALIDAD_PRESENTACION, 
                   DIA_RECOJO_LISTADO, DIA_ARCHIVO_RECOJO_LISTADO,DIA_ATRASO_RECOJO_LISTADO, REGISTRO_CARGO_RECEPCION, USUARIO_SUBIO_CARGO_LISTADO, 
                   J.JAQA300FRC, DIA_ARCHIVO_RECOJO_CHEQUE, DIA_ATRASO_RECOJO_CHEQUE, MODALIDAD_RECEPCION, REGISTRO_CARGO, USUARIO_SUBIO_CARGO_CHEQUE,
                   MEDIO_PAGO, MONTO_CHEQUE, DESCUENTO_CUOTA_COMPLETA, DESCUENTO_CUOTA_PARCIAL, SIN_DESCUENTO, SIN_CHEQUE, 
                   CASE WHEN NVL(USUARIO_SUBIO_CARGO_LISTADO, ' ') <> ' ' THEN 'SI' ELSE 'NO' END, TIPO_CARGA_LISTADO, CARGA_SISTEMA_LISTADO, 
                   J.JAQA201DPAG, DIA_PAGO_REAL, CASE WHEN NVL(DIA_PAGO_REAL, 0) = 0 THEN 'NO' ELSE 'SI' END, PAGO_CUOTA_COMPLETA, 
                   PAGO_CUOTA_PARCIAL, CLIENTE_SIN_PAGO, PAGO_CASILLERO, PAGO_CANJE_PUBLICITARIO, P_USUARIO_EJECUTO, FECHA_SISTEMA, HORA_SISTEMA);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END LOOP;               
         PERIODO := ADD_MONTHS(PERIODO, 1);
      END LOOP;
   END SP_CR_REPORTE_SEGUIMIENTO_DETALLE;
   
   PROCEDURE SP_CR_REPORTE_CANJE_PUBLICITARIO(P_CODIGO_CONVENIO   IN NUMBER,
                                              P_CODIGO_REGION     IN NUMBER,
                                              P_CODIGO_ZONA       IN NUMBER,
                                              P_CODIGO_SUCURSAL   IN NUMBER,
                                              P_CODIGO_ASESOR     IN VARCHAR2,
                                              P_FECHA_INICIO      IN DATE,
                                              P_FECHA_FIN         IN DATE,
                                              P_USUARIO_EJECUTO   IN VARCHAR2) IS
      
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_REPORTE_CANJE_PUBLICITARIO
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 21/11/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : GENERA EL REPORTE DE CANJE PUBLICITARIO
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 27/03/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO EL CURSOR DATOS_CONVENIOS PARA REEEMPLAZAR 
      --                                 LA TABLA FST046 POR LA TABLA JAQA201 PARA OBTENER LA SUCURSAL.
      --                               - SE VALIDA SI LOS CREDITOS QUE ESTAN ASOCIADOS AL CONVENIO, SE
      --                                 ENCUENTRA VIGENTES PARA MOSTRAR DICHO CONVENIO EN EL
      --                                 REPORTE.
      -- *****************************************************************
      -- FECHA DE MODIFICACION       : 25/07/2024
      -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
      -- DESCRIPCION DE MODIFICACION : - SE MODIFICO LA VALIDACION DE LOS CREDITOS
      --                                 VIGENTES POR CONVENIO.
      -- *****************************************************************
   
      FECHA_SISTEMA   DATE;
      HORA_SISTEMA    VARCHAR2(8);
      MES_REGISTRO    VARCHAR2(30);
      CORRELATIVO     NUMBER(9);    
      PERIODO         DATE;                          
   
      CURSOR DATOS_CONVENIOS(PERIODO_MES DATE) IS                                           
         SELECT A.PP101NCART, A.PP101NOMC, D.REGCOD, D.REGNOM, D.CODZON, D.DESZON, D.SUCURS, 
                D.SCNOM, B.JAQA300ARC, F.JAQA31CPB, F.JAQA31INI, F.JAQA31FPG, F.JAQA31TRE, E.JAQA32UAU, 
                E.JAQA32FAU, E.JAQA32MAU, E.JAQA32TRE, E.JAQA32USO, E.JAQA32MSO, E.JAQA32CMT, E.JAQA32FSO
           FROM FPP101 A
           JOIN JAQA300 B
             ON B.JAQA300NCO = A.PP101NCART
           JOIN JAQA201 C
             ON C.JAQA201NCA = A.PP101NCART
           JOIN REGSUC D
             ON D.SUCURS = C.JAQA201ARE
           LEFT JOIN JAQA32 E
             ON E.JAQA32NCO = A.PP101NCART
             AND TRUNC(E.JAQA32FSO, 'MONTH') = TRUNC(PERIODO_MES, 'MONTH')
            AND E.JAQA32EST = 'S'
           LEFT JOIN JAQA31 F
             ON F.JAQA31NCO = A.PP101NCART
          WHERE A.PP101NCART = DECODE(NVL(P_CODIGO_CONVENIO, 0), 0, A.PP101NCART, P_CODIGO_CONVENIO)
            AND B.JAQA300ARC = DECODE(NVL(P_CODIGO_ASESOR, ' '), ' ', B.JAQA300ARC, RPAD(P_CODIGO_ASESOR, 10, ' '))
            AND C.JAQA201ARE IN (SELECT SUCURS
                                   FROM REGSUC
                                  WHERE REGCOD = DECODE(NVL(P_CODIGO_REGION, 0), 0, REGCOD, P_CODIGO_REGION)
                                    AND CODZON = DECODE(NVL(P_CODIGO_ZONA, 0), 0, CODZON, P_CODIGO_ZONA)
                                    AND SUCURS = DECODE(NVL(P_CODIGO_SUCURSAL, 0), 0, SUCURS, P_CODIGO_SUCURSAL))
            AND (SELECT COUNT(*)
                   FROM FPP102, FSD011 
                  WHERE PP102NCART = A.PP101NCART
                    AND PGCOD  = PP102COD
                    AND SCMOD  = PP102MOD
                    AND SCSUC  = PP102SUC
                    AND SCMDA  = PP102MDA
                    AND SCPAP  = PP102PAP
                    AND SCCTA  = PP102CTA
                    AND SCOPER = PP102OPE
                    AND SCSBOP = PP102SBO
                    AND SCTOPE = PP102TOP
                    AND SCSTAT <> 99
                    ) > 0;
            
   BEGIN
      BEGIN
         SELECT PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
         INTO FECHA_SISTEMA, HORA_SISTEMA
         FROM FST017
         WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         DELETE FROM AQPC751 WHERE AQPC751USUEJEC = P_USUARIO_EJECUTO;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      MES_REGISTRO := NULL;
      PERIODO      := NULL;
      CORRELATIVO  := 0;
      PERIODO      := P_FECHA_INICIO;
      WHILE TRUNC(PERIODO, 'MONTH') <= TRUNC(P_FECHA_FIN, 'MONTH') LOOP
         MES_REGISTRO := TRIM(TO_CHAR(PERIODO, 'MONTH', 'NLS_DATE_LANGUAGE = SPANISH')) || ' - ' || EXTRACT(YEAR FROM PERIODO);
         FOR J IN DATOS_CONVENIOS(PERIODO) LOOP            
            CORRELATIVO  := CORRELATIVO + 1;
            BEGIN
               INSERT INTO AQPC751 (AQPC751CORRELA, AQPC751CODREGI, AQPC751NOMREGI, AQPC751CODZONA, AQPC751NOMZONA, AQPC751CODSUCU,
                                    AQPC751NOMSUCU, AQPC751CODASES, AQPC751CODCONV, AQPC751NOMCONV, AQPC751MESREGI, 
                                    AQPC751PAGCANJ, AQPC751MTOAPRO, AQPC751FREPAGO, AQPC751TIPREGI, AQPC751USUAUTO, AQPC751FECHAUT, 
                                    AQPC751MTOAUTO, AQPC751TIPCONP, AQPC751USUSOLI, AQPC751MTOSOLI, AQPC751NOMSOLI, AQPC751COMENTA, 
                                    AQPC751USUEJEC, AQPC751FCHEJEC, AQPC751HOREJEC)
               VALUES (CORRELATIVO, J.REGCOD, J.REGNOM, J.CODZON, J.DESZON, J.SUCURS, J.SCNOM, J.JAQA300ARC, J.PP101NCART, J.PP101NOMC, MES_REGISTRO, 
                       CASE WHEN J.JAQA31CPB = 'S' THEN 'SI' ELSE 'NO' END, J.JAQA31INI, CASE WHEN TRIM(J.JAQA31FPG) = 'NA' THEN ' ' ELSE J.JAQA31FPG END, 
                       CASE WHEN TRIM(J.JAQA31TRE) = 'NA' THEN '' ELSE J.JAQA31TRE END, J.JAQA32UAU, J.JAQA32FAU, J.JAQA32MAU, J.JAQA32TRE, J.JAQA32USO, 
                       J.JAQA32MSO, J.JAQA32FAU, J.JAQA32CMT, P_USUARIO_EJECUTO, FECHA_SISTEMA, HORA_SISTEMA);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END LOOP;
         PERIODO := ADD_MONTHS(PERIODO, 1);
      END LOOP;
   END SP_CR_REPORTE_CANJE_PUBLICITARIO;
   
   PROCEDURE SP_CR_OBTENER_NOMBRE_CONVENIO(P_CODIGO_CONVENIO IN NUMBER,
                                           P_NOMBRE_CONVENIO OUT VARCHAR2) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_OBTENER_NOMBRE_CONVENIO
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 21/11/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : RETORNA EL NOMBRE DEL CONVENIO
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
                                           
   BEGIN
      SELECT TRIM(PP101NOMC)
      INTO P_NOMBRE_CONVENIO
      FROM FPP101
      WHERE PP101NCART = P_CODIGO_CONVENIO;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
   
   PROCEDURE SP_CR_PAGO_CASILLERO(
          P_COD_CONV IN NUMBER,
          P_COD_REG  IN NUMBER,
          P_COD_ZON  IN NUMBER,
          P_COD_SUC  IN NUMBER,
          P_COD_ASE  IN varchar2,
          P_FCH_INI  IN DATE,
          P_FCH_FIN  IN DATE,
          P_FCH_PRC  IN DATE,
          P_USU_PRC  IN VARCHAR2,
          P_HOR_PRC  IN VARCHAR2) IS
          
         -- *****************************************************************
         -- NOMBRE                      : SP_CR_PAGO_CASILLERO
         -- SISTEMA                     : BANTOTAL
         -- MODULO                      : CREDITOS - ACTIVAS
         -- VERSION                     : 1.0
         -- FECHA DE CREACION           : 21/11/2023
         -- AUTOR DE CREACION           : MILTON CORDOVA
         -- USO                         : PAGO CASILLERO
         -- ESTADO                      : ACTIVO
         -- ACCESO                      : PUBLICO
         --------------------------------------------------------------------
         -- FECHA DE MODIFICACION       : 
         -- AUTOR DE LA MODIFICACION    : 
         -- DESCRIPCION DE MODIFICACION : 
         --
         -- *****************************************************************
          
          MES_REGISTRO   VARCHAR2(20);
          CONTADOR    NUMBER(17,0);
          V_JAQA31PAG VARCHAR2(50); 
          V_JAQA31DPC VARCHAR2(50); 
          V_JAQA31VPC VARCHAR2(50); 
          V_JAQA31CAL VARCHAR2(50);   
          V_JAQA33MPC VARCHAR2(50); 
          V_JAQA33MPG VARCHAR2(50);
          V_JAQA33AAC VARCHAR2(50);
          V_JAQA33ANA VARCHAR2(50);
          X_JAQA33MPC VARCHAR2(50); 
          Y_JAQA33MPC VARCHAR2(50); 
          V_JAQA33FRG DATE;
          X_PAGO_CASILLERO VARCHAR2(2);
          FECHA_INICIO DATE;
          FECHA_FIN DATE;
          CREDITO_VIGENTE NUMBER(17);
          CURSOR C1 IS 
         SELECT A.PP101NCART, A.PP101DIAF, A.PP101NOMC, E.REGCOD, E.REGNOM,
                E.CODZON, E.DESZON, E.SUCURS, E.SCNOM, B.JAQA300ARC,
                B.JAQA300FEL, B.JAQA300FRC
           FROM FPP101 A, JAQA300 B, JAQA201 C, REGSUC E   
          WHERE A.PP101NCART = B.JAQA300NCO
            AND C.JAQA201NCA = A.PP101NCART
            AND E.SUCURS = C.JAQA201ARE            
            AND A.PP101NCART = DECODE(NVL(P_COD_CONV, 0), 0, A.PP101NCART, P_COD_CONV)
            AND B.JAQA300ARC = DECODE(NVL(P_COD_ASE, ' '), ' ', B.JAQA300ARC, RPAD(P_COD_ASE, 10, ' '))
            AND C.JAQA201ARE IN
                (SELECT SUCURS
                   FROM REGSUC
                  WHERE REGCOD = DECODE(NVL(P_COD_REG, 0), 0, REGCOD, P_COD_REG)
                    AND CODZON = DECODE(NVL(P_COD_ZON, 0), 0, CODZON, P_COD_ZON)
                    AND SUCURS = DECODE(NVL(P_COD_SUC, 0), 0, SUCURS, P_COD_SUC));
                                   
          BEGIN
            BEGIN
              DELETE FROM AQPC222 WHERE AQPC222USU = P_USU_PRC;
              COMMIT;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
            
            BEGIN                  
              SELECT NVL(MAX(AQPC222COR), 0) + 1 INTO CONTADOR FROM AQPC222
              WHERE  AQPC222FEC = P_FCH_PRC AND AQPC222HOR = P_HOR_PRC AND AQPC222USU = P_USU_PRC;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
            
            FECHA_INICIO := P_FCH_INI;
            FECHA_FIN    := P_FCH_FIN;
            
            WHILE FECHA_INICIO <= FECHA_FIN LOOP  
                           
              FOR I IN C1 LOOP
             BEGIN
               SELECT COUNT(*)
                 INTO CREDITO_VIGENTE
                 FROM FPP102 A, FSD011 B
                WHERE A.PP102NCART = I.PP101NCART
                  AND A.PP102COD = B.PGCOD
                  AND A.PP102MOD = (SELECT MODULO
                                      FROM FST111
                                     WHERE DSCOD = 50
                                       AND MODULO = A.PP102MOD)
                  AND A.PP102SUC = B.SCSUC
                  AND A.PP102MDA = B.SCMDA
                  AND A.PP102PAP = B.SCPAP
                  AND A.PP102CTA = B.SCCTA
                  AND A.PP102OPE = B.SCOPER
                  AND A.PP102SBO = B.SCSBOP
                  AND A.PP102TOP = B.SCTOPE
                  AND B.SCSTAT <> 99;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;   
            IF CREDITO_VIGENTE > 0 THEN 
              MES_REGISTRO := '';
              V_JAQA31PAG := '';
              V_JAQA31DPC := '';
              V_JAQA31VPC := '';
              V_JAQA31CAL := '';
              V_JAQA33MPC := '';
              V_JAQA33MPG := '';
              V_JAQA33AAC := '';
              V_JAQA33ANA := '';
              X_JAQA33MPC := '';
              Y_JAQA33MPC := '';
              X_PAGO_CASILLERO := '';
              MES_REGISTRO := TRIM(TO_CHAR(FECHA_INICIO, 'MONTH','NLS_DATE_LANGUAGE = SPANISH'))||' - '||EXTRACT(YEAR FROM FECHA_INICIO);
                           
              BEGIN -- JAQA31
                SELECT 
                DECODE(JAQA31PAG, 'AN', 'Anticipado', 'PO', 'Posterior'),
                JAQA31DPC,
                JAQA31VPC,
                DECODE(JAQA31CAL, 'CO', 'Completa', 'DE', 'Descontada'),
                CASE WHEN JAQA31TPC = 99 THEN 'NO' ELSE 'SI' END   
                INTO 
                V_JAQA31PAG, -- MODALIDAD DE PAGO CASILLERO
                V_JAQA31DPC, -- TIPO DE CASILLERO
                V_JAQA31VPC, -- CASILLERO APROBADO
                V_JAQA31CAL, -- MODALIDAD DE CALCULO
                X_PAGO_CASILLERO -- PAGO CASILLERO
                FROM JAQA31 WHERE JAQA31NCO = I.PP101NCART AND ROWNUM = 1;
                
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  V_JAQA31PAG := '';
                  V_JAQA31DPC := '';
                  V_JAQA31VPC := '';
                  V_JAQA31CAL := '';
                  X_PAGO_CASILLERO := 'NO';
                       WHEN OTHERS THEN
                  NULL;
              END;
              
              BEGIN -- JAQA33
                SELECT 
                CASE WHEN JAQA33MPG <> 'CHEQUE' OR JAQA33MPG <> 'TRANSFERENCIA' 
                THEN JAQA33MPC ELSE 0 END, 
                JAQA33MPG,
                JAQA33AAC,
                JAQA33ANA,
                JAQA33FRG
                INTO 
                Y_JAQA33MPC,  -- MONTO DE PAGO CASILLERO  
                V_JAQA33MPG, -- MEDIO DE PAGO
                V_JAQA33AAC, -- AREA QUE ABONO
                V_JAQA33ANA, -- USUARIO REGISTRO CARGO
                V_JAQA33FRG  -- FECHA REGISTRO CARGO
                FROM JAQA33 
                WHERE JAQA33NCO = I.PP101NCART AND
                to_char(JAQA33FRG, 'MMRRRR') = to_char(FECHA_INICIO,'MMRRRR');
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  V_JAQA33MPC := '';
                  V_JAQA33MPG := '';
                  V_JAQA33AAC := '';
                  V_JAQA33ANA := '';
                  V_JAQA33FRG := '';
                       WHEN OTHERS THEN
                  NULL;
              END;

              BEGIN
                  SELECT   
                  JAQA39MCT
                  INTO 
                  X_JAQA33MPC -- MONTO DE CHEQUE O TRANSFERENCIA
                  FROM JAQA39 WHERE JAQA39NCO =  I.PP101NCART
                   AND TO_CHAR(JAQA39FEC,'MMRRRR') = TO_CHAR(FECHA_INICIO,'MMRRRR') AND 
                   JAQA39COR = (SELECT   
                  MAX(JAQA39COR)
                  FROM JAQA39 WHERE JAQA39NCO =  I.PP101NCART
                   AND TO_CHAR(JAQA39FEC,'MMRRRR') = TO_CHAR(FECHA_INICIO,'MMRRRR'));-- OBTIENE EL MAXIMO CORRELATIVO
              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                V_JAQA33MPC := '';
                                       WHEN OTHERS THEN
                  NULL;
              END;
              
              BEGIN
              INSERT INTO AQPC222
              (AQPC222FEC,AQPC222HOR,AQPC222USU,AQPC222COR,AQPC222MES,
              AQPC222REG,AQPC222AGE,AQPC222CON,AQPC222CAR,AQPC222ANA,
              AQPC222PAC,AQPC222TPC,AQPC222VPC,AQPC222VP1,AQPC222PAG,
              AQPC222CAL,AQPC222MPC,AQPC222MPG,AQPC222AAB,AQPC222AN1,AQPC222FRG)
              VALUES
              (P_FCH_PRC,P_HOR_PRC,P_USU_PRC,CONTADOR,MES_REGISTRO,
              I.REGNOM,I.SCNOM,I.PP101NOMC,I.PP101NCART,I.JAQA300ARC,
              X_PAGO_CASILLERO,V_JAQA31DPC,V_JAQA31VPC,X_JAQA33MPC,V_JAQA31PAG,
              V_JAQA31CAL,Y_JAQA33MPC,V_JAQA33MPG,V_JAQA33AAC,V_JAQA33ANA,V_JAQA33FRG);
              COMMIT;
              CONTADOR := 1 + CONTADOR;
              EXCEPTION
                       WHEN OTHERS THEN
                  NULL;
              END;   
           END IF;
              END LOOP;
              FECHA_INICIO := ADD_MONTHS(FECHA_INICIO, 1);
              FECHA_INICIO := TO_DATE('01/'||TO_CHAR(EXTRACT(MONTH FROM FECHA_INICIO))||'/'||TO_CHAR(EXTRACT(YEAR FROM FECHA_INICIO)), 'DD/MM/YYYY');   
           END LOOP;   
          END SP_CR_PAGO_CASILLERO;
          
          PROCEDURE SP_CR_SEGMENTO_PERSONAS(
          P_COD_CONV IN NUMBER,
          P_COD_REG  IN NUMBER,
          P_COD_ZON  IN NUMBER,
          P_COD_SUC  IN NUMBER,
          P_COD_ASE  IN VARCHAR2,
          P_FCH_INI  IN DATE,
          P_FCH_FIN  IN DATE,
          P_FCH_PRC  IN DATE,
          P_USU_PRC  IN VARCHAR2,
          P_HOR_PRC  IN VARCHAR2) IS
          
         -- *****************************************************************
         -- NOMBRE                      : SP_CR_SEGMENTO_PERSONAS
         -- SISTEMA                     : BANTOTAL
         -- MODULO                      : CREDITOS - ACTIVAS
         -- VERSION                     : 1.0
         -- FECHA DE CREACION           : 21/11/2023
         -- AUTOR DE CREACION           : MILTON CORDOVA
         -- USO                         : SEGMENTO PERSONAS
         -- ESTADO                      : ACTIVO
         -- ACCESO                      : PUBLICO
         --------------------------------------------------------------------
         -- FECHA DE MODIFICACION       : 
         -- AUTOR DE LA MODIFICACION    : 
         -- DESCRIPCION DE MODIFICACION : 
         --
         -- *****************************************************************
          
          MES_REGISTRO   VARCHAR2(20);
          CONTADOR    NUMBER(17,0);
          V_JAQA31PAG VARCHAR2(50); 
          V_JAQA31TPC VARCHAR2(50); 
          V_JAQA31VPC VARCHAR2(50); 
          V_JAQA31CAL VARCHAR2(50);   
          V_JAQA33MPC VARCHAR2(50); 
          V_JAQA33MPG VARCHAR2(50);
          V_JAQA33AAC VARCHAR2(50);
          V_JAQA33ANA VARCHAR2(50);
          X_JAQA33MPC VARCHAR2(50); 
          Y_JAQA33MPC VARCHAR2(50); 
          V_JAQA33FRG DATE;
          X_PAGO_CASILLERO VARCHAR2(2);
          V_JAQA31DPC VARCHAR2(50);
          FECHA_INICIO DATE;
          FECHA_FIN DATE;
          CREDITO_VIGENTE NUMBER(17);
          CURSOR C1 IS 
         SELECT A.PP101NCART, A.PP101DIAF, A.PP101NOMC, E.REGCOD, E.REGNOM,
                E.CODZON, E.DESZON, E.SUCURS, E.SCNOM, B.JAQA300ARC,
                B.JAQA300FEL, B.JAQA300FRC
           FROM FPP101 A, JAQA300 B, JAQA201 C, REGSUC E   
          WHERE A.PP101NCART = B.JAQA300NCO
            AND C.JAQA201NCA = A.PP101NCART
            AND E.SUCURS = C.JAQA201ARE            
            AND A.PP101NCART = DECODE(NVL(P_COD_CONV, 0), 0, A.PP101NCART, P_COD_CONV)
            AND B.JAQA300ARC = DECODE(NVL(P_COD_ASE, ' '), ' ', B.JAQA300ARC, RPAD(P_COD_ASE, 10, ' '))
            AND C.JAQA201ARE IN
                (SELECT SUCURS
                   FROM REGSUC
                  WHERE REGCOD = DECODE(NVL(P_COD_REG, 0), 0, REGCOD, P_COD_REG)
                    AND CODZON = DECODE(NVL(P_COD_ZON, 0), 0, CODZON, P_COD_ZON)
                    AND SUCURS = DECODE(NVL(P_COD_SUC, 0), 0, SUCURS, P_COD_SUC));
                    
            CURSOR JAQA33(V_CONVENIO NUMBER, V_FECHA_INICIO DATE, V_FECHA_FIN DATE) IS
            SELECT JAQA33FRG FROM JAQA33 WHERE JAQA33NCO = V_CONVENIO AND JAQA33FRG >= V_FECHA_INICIO
            AND JAQA33FRG <= V_FECHA_FIN;
          BEGIN
            BEGIN
              DELETE FROM AQPC223 WHERE AQPC223USU = P_USU_PRC;
              COMMIT;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
            
            begin
              SELECT NVL(MAX(AQPC223COR), 0) + 1 INTO CONTADOR FROM AQPC223
              WHERE  AQPC223FEC = P_FCH_PRC AND AQPC223HOR = P_HOR_PRC AND AQPC223USU = P_USU_PRC;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;            
            
            FECHA_INICIO := P_FCH_INI;
            FECHA_FIN    := P_FCH_FIN;
            WHILE FECHA_INICIO <= FECHA_FIN LOOP
                          
            FOR I IN C1 LOOP  
              BEGIN
               SELECT COUNT(*)
                 INTO CREDITO_VIGENTE
                 FROM FPP102 A, FSD011 B
                WHERE A.PP102NCART = I.PP101NCART
                  AND A.PP102COD = B.PGCOD
                  AND A.PP102MOD = (SELECT MODULO
                                      FROM FST111
                                     WHERE DSCOD = 50
                                       AND MODULO = A.PP102MOD)
                  AND A.PP102SUC = B.SCSUC
                  AND A.PP102MDA = B.SCMDA
                  AND A.PP102PAP = B.SCPAP
                  AND A.PP102CTA = B.SCCTA
                  AND A.PP102OPE = B.SCOPER
                  AND A.PP102SBO = B.SCSBOP
                  AND A.PP102TOP = B.SCTOPE
                  AND B.SCSTAT <> 99;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;   
            IF CREDITO_VIGENTE > 0 THEN            
              MES_REGISTRO := '';
              V_JAQA31PAG := '';
              V_JAQA31TPC := '';
              V_JAQA31VPC := '';
              V_JAQA31CAL := '';
              V_JAQA33MPC := '';
              V_JAQA33MPG := '';
              V_JAQA33AAC := '';
              V_JAQA33ANA := '';
              X_JAQA33MPC := '';
              Y_JAQA33MPC := '';
              X_PAGO_CASILLERO := '';
              MES_REGISTRO := TRIM(TO_CHAR(FECHA_INICIO, 'MONTH','NLS_DATE_LANGUAGE = SPANISH'))||' - '||EXTRACT(YEAR FROM FECHA_INICIO);
               
              BEGIN -- JAQA31
                SELECT 
                DECODE(JAQA31PAG, 'AN', 'Anticipado', 'PO', 'Posterior'),
                JAQA31DPC,
                JAQA31VPC,
                DECODE(JAQA31CAL, 'CO', 'Completa', 'DE', 'Descontada'),
                CASE WHEN JAQA31TPC = 99 THEN 'NO' ELSE 'SI' END   
                INTO 
                V_JAQA31PAG, -- MODALIDAD DE PAGO CASILLERO
                V_JAQA31DPC, -- TIPO DE CASILLERO
                V_JAQA31VPC, -- CASILLERO APROBADO
                V_JAQA31CAL, -- MODALIDAD DE CALCULO
                X_PAGO_CASILLERO -- PAGO CASILLERO
                FROM JAQA31 WHERE JAQA31NCO = I.PP101NCART AND ROWNUM = 1;
                
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  V_JAQA31PAG := '';
                  V_JAQA31DPC := '';
                  V_JAQA31VPC := '';
                  V_JAQA31CAL := '';
                  X_PAGO_CASILLERO := 'NO';
                       WHEN OTHERS THEN
                  NULL;
              END;

              BEGIN -- JAQA33
                SELECT 
                CASE WHEN JAQA33MPG <> 'CHEQUE' OR JAQA33MPG <> 'TRANSFERENCIA' 
                THEN JAQA33MPC ELSE 0 END, 
                JAQA33MPG,
                JAQA33AAC,
                JAQA33ANA,
                JAQA33FRG
                INTO 
                Y_JAQA33MPC,  -- MONTO DE PAGO CASILLERO  
                V_JAQA33MPG, -- MEDIO DE PAGO
                V_JAQA33AAC, -- AREA QUE ABONO
                V_JAQA33ANA, -- USUARIO REGISTRO CARGO
                V_JAQA33FRG  -- FECHA REGISTRO CARGO
                FROM JAQA33 
                WHERE JAQA33NCO = I.PP101NCART AND
                to_char(JAQA33FRG, 'MMRRRR') = to_char(FECHA_INICIO,'MMRRRR') ;
 
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  V_JAQA33MPC := '';
                  V_JAQA33MPG := '';
                  V_JAQA33AAC := '';
                  V_JAQA33ANA := '';
                  V_JAQA33FRG := '';
                       WHEN OTHERS THEN
                  NULL;
              END;
             
              BEGIN
                  SELECT   
                  JAQA39MCT
                  INTO 
                  X_JAQA33MPC -- MONTO DE CHEQUE O TRANSFERENCIA
                  FROM JAQA39 WHERE JAQA39NCO =  I.PP101NCART
                   AND TO_CHAR(JAQA39FEC,'MMRRRR') = TO_CHAR(FECHA_INICIO,'MMRRRR') AND 
                   JAQA39COR = (SELECT   
                  MAX(JAQA39COR)
                  FROM JAQA39 WHERE JAQA39NCO =  I.PP101NCART
                   AND TO_CHAR(JAQA39FEC,'MMRRRR') = TO_CHAR(FECHA_INICIO,'MMRRRR'));-- OBTIENE EL MAXIMO CORRELATIVO                  
              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                V_JAQA33MPC := '';
                     WHEN OTHERS THEN
                  NULL;
              END;
              
              BEGIN
              INSERT INTO AQPC223
              (AQPC223FEC,AQPC223HOR,AQPC223USU,AQPC223COR,AQPC223MES,
              AQPC223REG,AQPC223AGE,AQPC223CON,AQPC223CAR,AQPC223ANA,
              AQPC223PAG,AQPC223TIP,AQPC223MCT,AQPC223MPC,AQPC223MCA,AQPC223AN1,
              AQPC223FER,AQPC223MPA,AQPC223MNP,AQPC223AAB,AQPC223FRC)
              VALUES
              (P_FCH_PRC,P_HOR_PRC,P_USU_PRC,CONTADOR,MES_REGISTRO,
              I.REGNOM,I.SCNOM,I.PP101NOMC,I.PP101NCART,I.JAQA300ARC,
              X_PAGO_CASILLERO,V_JAQA31DPC,X_JAQA33MPC,V_JAQA31PAG,V_JAQA31CAL,V_JAQA33ANA,
              V_JAQA33FRG,Y_JAQA33MPC,V_JAQA33MPG,V_JAQA33AAC,V_JAQA33FRG);
              COMMIT;
              CONTADOR := 1 + CONTADOR;
              EXCEPTION
               WHEN OTHERS THEN
                  NULL;
              END; 
              END IF;
              END LOOP;
              FECHA_INICIO := ADD_MONTHS(FECHA_INICIO, 1);
              FECHA_INICIO := TO_DATE('01/'||TO_CHAR(EXTRACT(MONTH FROM FECHA_INICIO))||'/'||TO_CHAR(EXTRACT(YEAR FROM FECHA_INICIO)), 'DD/MM/YYYY');           
            END LOOP;   
          END SP_CR_SEGMENTO_PERSONAS;

END PQ_CR_REPORTES_GESTION_CONVENIOS;
/
