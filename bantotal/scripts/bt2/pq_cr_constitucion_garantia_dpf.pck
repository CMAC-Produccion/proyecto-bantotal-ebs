CREATE OR REPLACE PACKAGE PQ_CR_CONSTITUCION_GARANTIA_DPF IS

   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_CONSTITUCION_GARANTIA_DPF
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 05/03/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 09/07/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE AGREGARON LOS SIGUIENTES PROCEDIMIENTOS:
   --                               - SP_CR_DESEMBOLSOS_GARANTIA_DPF
   --                               - SP_CR_OBTENER_TIPO_CAMBIO
   -- *****************************************************************
   -- FECHA DE MODIFICACION       : 06/09/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE MODIFICO EL SIGUIENTE PROCREDIMIENTO:
   --                               - SP_CR_REPORTE_GARANTIAS_DPF
   -- *****************************************************************

/*============================================================================================================================*/
   PROCEDURE SP_CR_DESEMBOLSOS_GARANTIA_DPF(P_REGION           IN NUMBER,
                                            P_ZONA             IN NUMBER,
                                            P_SUCURSAL         IN NUMBER,
                                            P_USUARIO_REGISTRO IN VARCHAR2,
                                            P_TIPO_MONEDA      IN VARCHAR2,
                                            P_IMPORTE_MANUAL   IN VARCHAR2,
                                            P_IMPORTE_GUIA     IN NUMBER,
                                            P_IMPORTE_INICIO   IN NUMBER,
                                            P_IMPORTE_FIN      IN NUMBER,
                                            P_FECHA_INICIO     IN DATE,
                                            P_FECHA_FIN        IN DATE);

/*============================================================================================================================*/
   PROCEDURE SP_CR_REPORTE_GARANTIAS_DPF(P_USUARIO_REGISTRO IN VARCHAR2,
                                         P_TIPO_DESEMBOLSO  IN NUMBER);

/*============================================================================================================================*/   
   PROCEDURE SP_CR_OBTENER_TIPO_CAMBIO(P_TIPO_CAMBIO_DOLAR OUT NUMBER);

END PQ_CR_CONSTITUCION_GARANTIA_DPF;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CONSTITUCION_GARANTIA_DPF IS

   PROCEDURE SP_CR_DESEMBOLSOS_GARANTIA_DPF(P_REGION           IN NUMBER,
                                            P_ZONA             IN NUMBER,
                                            P_SUCURSAL         IN NUMBER,
                                            P_USUARIO_REGISTRO IN VARCHAR2,
                                            P_TIPO_MONEDA      IN VARCHAR2,
                                            P_IMPORTE_MANUAL   IN VARCHAR2,
                                            P_IMPORTE_GUIA     IN NUMBER,
                                            P_IMPORTE_INICIO   IN NUMBER,
                                            P_IMPORTE_FIN      IN NUMBER,
                                            P_FECHA_INICIO     IN DATE,
                                            P_FECHA_FIN        IN DATE) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_DESEMBOLSOS_GARANTIA_DPF
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 09/07/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA DATA DEDESEMBOLSOS CON GARANTIA DPF
   -- PARAMETROS                  : - P_REGION           : NUMBER(3)
   --                               - P_ZONA             : NUMBER(2)
   --                               - P_SUCURSAL         : NUMBER(3)
   --                               - P_USUARIO_REGISTRO : VARCHAR2(10)
   --                               - P_TIPO_MONEDA      : VARCHAR2(1)
   --                               - P_IMPORTE_MANUAL   : VARCHAR2(1)
   --                               - P_IMPORTE_GUIA     : NUMBER(9)
   --                               - P_IMPORTE_INICIO   : NUMBER(17, 2)
   --                               - P_IMPORTE_FIN      : NUMBER(17, 2)
   --                               - P_FECHA_INICIO     : DATE
   --                               - P_FECHA_FIN        : DATE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      FECHA_SISTEMA DATE;
   BEGIN
      BEGIN
         DELETE FROM AQPC792 A1 
            WHERE A1.AQPC792UREG = P_USUARIO_REGISTRO;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   
      FECHA_SISTEMA := NULL;
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
         INSERT INTO AQPC792
            (AQPC792CORR,
             AQPC792UREG,
             AQPC792FREG,
             AQPC792HREG,
             AQPC792INST,
             AQPC792EMP,
             AQPC792MOD,
             AQPC792SUC,
             AQPC792MDA,
             AQPC792PAP,
             AQPC792CTA,
             AQPC792OPER,
             AQPC792SBOP,
             AQPC792TOPE,
             AQPC792EMPG,
             AQPC792MODG,
             AQPC792SUCG,
             AQPC792MDAG,
             AQPC792PAPG,
             AQPC792CTAG,
             AQPC792OPERG,
             AQPC792SBOPG,
             AQPC792TOPEG,
             AQPC792FVAL,
             AQPC792IMP,
             AQPC792STAT)
            SELECT ROWNUM,
                   P_USUARIO_REGISTRO,
                   FECHA_SISTEMA,
                   TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                   B1.XWFPRCINS,
                   A1.PGCOD,
                   A1.AOMOD,
                   A1.AOSUC,
                   A1.AOMDA,
                   A1.AOPAP,
                   A1.AOCTA,
                   A1.AOOPER,
                   A1.AOSBOP,
                   A1.AOTOPE,
                   C1.SNG122PGC,
                   C1.SNG122MOD,
                   C1.SNG122SUC,
                   C1.SNG122MDA,
                   C1.SNG122PAP,
                   C1.SNG122CTA,
                   C1.SNG122OPER,
                   C1.SNG122SBOP,
                   C1.SNG122TOPE,
                   A1.AOFVAL,
                   A1.AOIMP,
                   A1.AOSTAT
              FROM FSD010 A1, XWF700 B1, SNG122 C1
             WHERE A1.PGCOD = 1
               AND A1.AOSUC IN (SELECT SUCURS
                                  FROM REGSUC A2
                                 WHERE A2.REGCOD = DECODE(NVL(P_REGION, 0), 0, A2.REGCOD, P_REGION)
                                   AND A2.CODZON = DECODE(NVL(P_ZONA, 0), 0, A2.CODZON, P_ZONA)
                                   AND A2.SUCURS = DECODE(NVL(P_SUCURSAL, 0), 0, A2.SUCURS, P_SUCURSAL))
               AND A1.AOMDA = DECODE(P_TIPO_MONEDA, 'D', 101, 0)
               AND A1.AOIMP BETWEEN
                   DECODE(P_IMPORTE_MANUAL,
                          'S',
                          P_IMPORTE_INICIO,
                          (SELECT TP1IMP1
                             FROM FST198 A3
                            WHERE A3.TP1COD   = 1
                              AND A3.TP1COD1  = 111154
                              AND A3.TP1CORR1 = 1
                              AND A3.TP1CORR2 = 40
                              AND A3.TP1CORR3 = P_IMPORTE_GUIA
                              AND A3.TP1NRO1  = 1))
               AND DECODE(P_IMPORTE_MANUAL,
                          'S',
                          DECODE(NVL(P_IMPORTE_FIN, 0), 0, 99999999999999999.99, P_IMPORTE_FIN),
                          (SELECT CASE
                                     WHEN TP1IMP2 = 0 THEN
                                      99999999999999999.99
                                     ELSE
                                      TP1IMP2
                                  END
                             FROM FST198 A4
                            WHERE A4.TP1COD   = 1
                              AND A4.TP1COD1  = 111154
                              AND A4.TP1CORR1 = 1
                              AND A4.TP1CORR2 = 40
                              AND A4.TP1CORR3 = P_IMPORTE_GUIA
                              AND A4.TP1NRO1  = 1))
               AND A1.AOFVAL BETWEEN P_FECHA_INICIO AND P_FECHA_FIN
               AND A1.AOSTAT <> 99
               AND B1.XWFEMPRESA   = A1.PGCOD
               AND B1.XWFSUCURSAL  = A1.AOSUC
               AND B1.XWFMODULO    = A1.AOMOD
               AND B1.XWFMONEDA    = A1.AOMDA
               AND B1.XWFPAPEL     = A1.AOPAP
               AND B1.XWFCUENTA    = A1.AOCTA
               AND B1.XWFOPERACION = A1.AOOPER
               AND B1.XWFSUBOPE    = A1.AOSBOP
               AND B1.XWFTIPOPE    = A1.AOTOPE
               AND B1.XWFCAR3      = '1'
               AND C1.SNG122INST   = B1.XWFPRCINS
               AND C1.SNG122MOD    = 70
               AND C1.SNG122TOPE   = 80;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_DESEMBOLSOS_GARANTIA_DPF;

/*============================================================================================================================*/
   PROCEDURE SP_CR_REPORTE_GARANTIAS_DPF(P_USUARIO_REGISTRO IN VARCHAR2,
                                         P_TIPO_DESEMBOLSO  IN NUMBER) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_REPORTE_GARANTIAS_DPF
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 05/03/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA REPORTE DE DESEMBOLSOS CON GARANTIA DPF
   -- PARAMETROS                  : - P_USUARIO_REGISTRO : VARCHAR2(10)
   --                               - P_TIPO_DESEMBOLSO  : NUMBER(2)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 09/07/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE OPTIMIZO EL CURSOR QUE OBTENIA
   --                               LOS DESEMBOLSOS CON GARANTIA DPF
   -- *****************************************************************
   -- FECHA DE MODIFICACION       : 06/09/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE INICIALIZARON VARIABLES
   -- *****************************************************************
   
      CONTADOR                NUMBER(17);
      CODIGO_REGION           NUMBER(3);
      NOMBRE_REGION           VARCHAR2(40);
      CODIGO_ZONA             NUMBER(2);
      NOMBRE_ZONA             VARCHAR2(50);
      CODIGO_SUCURSAL         NUMBER(3);
      NOMBRE_SUCURSAL         VARCHAR2(30);
      SIGNO_MONEDA_GARANTIA   VARCHAR2(4);
      SIGNO_MONEDA            VARCHAR2(4);
      PAIS_DOCUMENTO_GARANTIA NUMBER(3);
      TIPO_DOCUMENTO_GARANTIA NUMBER(2);
      NRO_DOCUMENTO_GARANTIA  VARCHAR2(12);
      NOMBRE_CLIENTE_GARANTIA VARCHAR2(100);
      PAIS_DOCUMENTO          NUMBER(3);
      TIPO_DOCUMENTO          NUMBER(2);
      NRO_DOCUMENTO           VARCHAR2(12);
      NOMBRE_CLIENTE          VARCHAR2(100);
      CODIGO_ANALISTA         VARCHAR2(10);
      NOMBRE_ANALISTA         VARCHAR2(100);
      FECHA_SISTEMA           DATE;
      HORA_DESEMBOLSO         VARCHAR2(8);
      CODIGO_OPERADOR         VARCHAR2(10);
      NOMBRE_OPERADOR         VARCHAR2(100);
      DPF                     VARCHAR2(28);
      NOMBRE_ESTADO_GARANTIA  VARCHAR2(30);
      GARANTIA_CERTIFICADA    VARCHAR2(2);
      EMPRESA_TRN             NUMBER(3);
      MODULO_TRN              NUMBER(3);
      SUCURSAL_TRN            NUMBER(3);
      TRANSACCION             NUMBER(3);
      RELACION_TRN            NUMBER(3);
      FHCONTABLE_TRN          DATE;
   
      CURSOR DESEMBOLSOS_GARANTIA_DPF_1 IS
         SELECT A1.AQPC792INST,
                A1.AQPC792EMP,
                A1.AQPC792MOD,
                A1.AQPC792SUC,
                A1.AQPC792MDA,
                A1.AQPC792PAP,
                A1.AQPC792CTA,
                A1.AQPC792OPER,
                A1.AQPC792SBOP,
                A1.AQPC792TOPE,
                A1.AQPC792EMPG,
                A1.AQPC792MODG,
                A1.AQPC792SUCG,
                A1.AQPC792MDAG,
                A1.AQPC792PAPG,
                A1.AQPC792CTAG,
                A1.AQPC792OPERG,
                A1.AQPC792SBOPG,
                A1.AQPC792TOPEG,
                A1.AQPC792FVAL,
                A1.AQPC792IMP,
                A1.AQPC792STAT,
                C1.R1COD,
                C1.R1MOD,
                C1.R1SUC,
                C1.R1MDA,
                C1.R1PAP,
                C1.R1CTA,
                C1.R1OPER,
                C1.R1SBOP,
                C1.R1TOPE,
                'CONTRATACION DIGITAL' AS TIPO_DESEMBOLSO
           FROM AQPC792 A1, FSR011 C1
          WHERE A1.AQPC792UREG = P_USUARIO_REGISTRO
            AND C1.R2COD   = A1.AQPC792EMPG
            AND C1.R2MOD   = A1.AQPC792MODG
            AND C1.R2SUC   = A1.AQPC792SUCG
            AND C1.R2MDA   = A1.AQPC792MDAG
            AND C1.R2PAP   = A1.AQPC792PAPG
            AND C1.R2CTA   = A1.AQPC792CTAG
            AND C1.R2OPER  = A1.AQPC792OPERG
            AND C1.R2SBOP  = A1.AQPC792SBOPG
            AND C1.R2TOPE  = A1.AQPC792TOPEG
            AND C1.RELCOD  = 2
            AND C1.R011FC  = (SELECT MAX(R011FC)
                                FROM FSR011 A2
                               WHERE A2.R2COD  = A1.AQPC792EMPG
                                 AND A2.R2MOD  = A1.AQPC792MODG
                                 AND A2.R2SUC  = A1.AQPC792SUCG
                                 AND A2.R2MDA  = A1.AQPC792MDAG
                                 AND A2.R2PAP  = A1.AQPC792PAPG
                                 AND A2.R2CTA  = A1.AQPC792CTAG
                                 AND A2.R2OPER = A1.AQPC792OPERG
                                 AND A2.R2SBOP = A1.AQPC792SBOPG
                                 AND A2.R2TOPE = A1.AQPC792TOPEG
                                 AND A2.RELCOD = 2)
            AND EXISTS (SELECT *
                          FROM JAQM1A A3
                         WHERE A3.JAQM1AINS = A1.AQPC792INST
                           AND A3.JAQM1AEST = 'P');
      
      CURSOR DESEMBOLSOS_GARANTIA_DPF_2 IS
         SELECT A1.AQPC792INST,
                A1.AQPC792EMP,
                A1.AQPC792MOD,
                A1.AQPC792SUC,
                A1.AQPC792MDA,
                A1.AQPC792PAP,
                A1.AQPC792CTA,
                A1.AQPC792OPER,
                A1.AQPC792SBOP,
                A1.AQPC792TOPE,
                A1.AQPC792EMPG,
                A1.AQPC792MODG,
                A1.AQPC792SUCG,
                A1.AQPC792MDAG,
                A1.AQPC792PAPG,
                A1.AQPC792CTAG,
                A1.AQPC792OPERG,
                A1.AQPC792SBOPG,
                A1.AQPC792TOPEG,
                A1.AQPC792FVAL,
                A1.AQPC792IMP,
                A1.AQPC792STAT,
                C1.R1COD,
                C1.R1MOD,
                C1.R1SUC,
                C1.R1MDA,
                C1.R1PAP,
                C1.R1CTA,
                C1.R1OPER,
                C1.R1SBOP,
                C1.R1TOPE,
                'CONTRATACION NORMAL' AS TIPO_DESEMBOLSO
           FROM AQPC792 A1, FSR011 C1
          WHERE A1.AQPC792UREG = P_USUARIO_REGISTRO
            AND C1.R2COD   = A1.AQPC792EMPG
            AND C1.R2MOD   = A1.AQPC792MODG
            AND C1.R2SUC   = A1.AQPC792SUCG
            AND C1.R2MDA   = A1.AQPC792MDAG
            AND C1.R2PAP   = A1.AQPC792PAPG
            AND C1.R2CTA   = A1.AQPC792CTAG
            AND C1.R2OPER  = A1.AQPC792OPERG
            AND C1.R2SBOP  = A1.AQPC792SBOPG
            AND C1.R2TOPE  = A1.AQPC792TOPEG
            AND C1.RELCOD  = 2
            AND C1.R011FC  = (SELECT MAX(R011FC)
                                FROM FSR011 A2
                               WHERE A2.R2COD  = A1.AQPC792EMPG
                                 AND A2.R2MOD  = A1.AQPC792MODG
                                 AND A2.R2SUC  = A1.AQPC792SUCG
                                 AND A2.R2MDA  = A1.AQPC792MDAG
                                 AND A2.R2PAP  = A1.AQPC792PAPG
                                 AND A2.R2CTA  = A1.AQPC792CTAG
                                 AND A2.R2OPER = A1.AQPC792OPERG
                                 AND A2.R2SBOP = A1.AQPC792SBOPG
                                 AND A2.R2TOPE = A1.AQPC792TOPEG
                                 AND A2.RELCOD = 2)
            AND NOT EXISTS (SELECT *
                              FROM JAQM1A A3
                             WHERE A3.JAQM1AINS = A1.AQPC792INST
                               AND A3.JAQM1AEST = 'P');
      
      CURSOR DESEMBOLSOS_GARANTIA_DPF_3 IS
         SELECT A1.AQPC792INST,
                A1.AQPC792EMP,
                A1.AQPC792MOD,
                A1.AQPC792SUC,
                A1.AQPC792MDA,
                A1.AQPC792PAP,
                A1.AQPC792CTA,
                A1.AQPC792OPER,
                A1.AQPC792SBOP,
                A1.AQPC792TOPE,
                A1.AQPC792EMPG,
                A1.AQPC792MODG,
                A1.AQPC792SUCG,
                A1.AQPC792MDAG,
                A1.AQPC792PAPG,
                A1.AQPC792CTAG,
                A1.AQPC792OPERG,
                A1.AQPC792SBOPG,
                A1.AQPC792TOPEG,
                A1.AQPC792FVAL,
                A1.AQPC792IMP,
                A1.AQPC792STAT,
                C1.R1COD,
                C1.R1MOD,
                C1.R1SUC,
                C1.R1MDA,
                C1.R1PAP,
                C1.R1CTA,
                C1.R1OPER,
                C1.R1SBOP,
                C1.R1TOPE,
                'CONTRATACION DIGITAL' AS TIPO_DESEMBOLSO
           FROM AQPC792 A1, FSR011 C1
          WHERE A1.AQPC792UREG = P_USUARIO_REGISTRO
            AND C1.R2COD   = A1.AQPC792EMPG
            AND C1.R2MOD   = A1.AQPC792MODG
            AND C1.R2SUC   = A1.AQPC792SUCG
            AND C1.R2MDA   = A1.AQPC792MDAG
            AND C1.R2PAP   = A1.AQPC792PAPG
            AND C1.R2CTA   = A1.AQPC792CTAG
            AND C1.R2OPER  = A1.AQPC792OPERG
            AND C1.R2SBOP  = A1.AQPC792SBOPG
            AND C1.R2TOPE  = A1.AQPC792TOPEG
            AND C1.RELCOD  = 2
            AND C1.R011FC  = (SELECT MAX(R011FC)
                                FROM FSR011 A2
                               WHERE A2.R2COD  = A1.AQPC792EMPG
                                 AND A2.R2MOD  = A1.AQPC792MODG
                                 AND A2.R2SUC  = A1.AQPC792SUCG
                                 AND A2.R2MDA  = A1.AQPC792MDAG
                                 AND A2.R2PAP  = A1.AQPC792PAPG
                                 AND A2.R2CTA  = A1.AQPC792CTAG
                                 AND A2.R2OPER = A1.AQPC792OPERG
                                 AND A2.R2SBOP = A1.AQPC792SBOPG
                                 AND A2.R2TOPE = A1.AQPC792TOPEG
                                 AND A2.RELCOD = 2)
            AND EXISTS (SELECT *
                          FROM JAQM1A A3
                         WHERE A3.JAQM1AINS = A1.AQPC792INST
                           AND A3.JAQM1AEST = 'P')
            UNION ALL
         SELECT A1.AQPC792INST,
                A1.AQPC792EMP,
                A1.AQPC792MOD,
                A1.AQPC792SUC,
                A1.AQPC792MDA,
                A1.AQPC792PAP,
                A1.AQPC792CTA,
                A1.AQPC792OPER,
                A1.AQPC792SBOP,
                A1.AQPC792TOPE,
                A1.AQPC792EMPG,
                A1.AQPC792MODG,
                A1.AQPC792SUCG,
                A1.AQPC792MDAG,
                A1.AQPC792PAPG,
                A1.AQPC792CTAG,
                A1.AQPC792OPERG,
                A1.AQPC792SBOPG,
                A1.AQPC792TOPEG,
                A1.AQPC792FVAL,
                A1.AQPC792IMP,
                A1.AQPC792STAT,
                C1.R1COD,
                C1.R1MOD,
                C1.R1SUC,
                C1.R1MDA,
                C1.R1PAP,
                C1.R1CTA,
                C1.R1OPER,
                C1.R1SBOP,
                C1.R1TOPE,
                'CONTRATACION NORMAL' AS TIPO_DESEMBOLSO
           FROM AQPC792 A1, FSR011 C1
          WHERE A1.AQPC792UREG = P_USUARIO_REGISTRO
            AND C1.R2COD   = A1.AQPC792EMPG
            AND C1.R2MOD   = A1.AQPC792MODG
            AND C1.R2SUC   = A1.AQPC792SUCG
            AND C1.R2MDA   = A1.AQPC792MDAG
            AND C1.R2PAP   = A1.AQPC792PAPG
            AND C1.R2CTA   = A1.AQPC792CTAG
            AND C1.R2OPER  = A1.AQPC792OPERG
            AND C1.R2SBOP  = A1.AQPC792SBOPG
            AND C1.R2TOPE  = A1.AQPC792TOPEG
            AND C1.RELCOD  = 2
            AND C1.R011FC  = (SELECT MAX(R011FC)
                                FROM FSR011 A2
                               WHERE A2.R2COD  = A1.AQPC792EMPG
                                 AND A2.R2MOD  = A1.AQPC792MODG
                                 AND A2.R2SUC  = A1.AQPC792SUCG
                                 AND A2.R2MDA  = A1.AQPC792MDAG
                                 AND A2.R2PAP  = A1.AQPC792PAPG
                                 AND A2.R2CTA  = A1.AQPC792CTAG
                                 AND A2.R2OPER = A1.AQPC792OPERG
                                 AND A2.R2SBOP = A1.AQPC792SBOPG
                                 AND A2.R2TOPE = A1.AQPC792TOPEG
                                 AND A2.RELCOD = 2)
            AND NOT EXISTS (SELECT *
                              FROM JAQM1A A3
                             WHERE A3.JAQM1AINS = A1.AQPC792INST
                               AND A3.JAQM1AEST = 'P');
   BEGIN
      BEGIN
         DELETE FROM AQPC783 
            WHERE AQPC783USUP = P_USUARIO_REGISTRO;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   
      FECHA_SISTEMA := NULL;
      BEGIN
         SELECT A1.PGFAPE
           INTO FECHA_SISTEMA
           FROM FST017 A1
          WHERE A1.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   
      CASE
         WHEN P_TIPO_DESEMBOLSO = 1 THEN
            CONTADOR := 0;
            FOR J1 IN DESEMBOLSOS_GARANTIA_DPF_1 LOOP
               CONTADOR := CONTADOR + 1;
            
               /*==================== DATOS DEL CRÉDITO ====================*/
            
               CODIGO_REGION   := NULL;
               NOMBRE_REGION   := NULL;
               CODIGO_ZONA     := NULL;
               NOMBRE_ZONA     := NULL;
               CODIGO_SUCURSAL := NULL;
               NOMBRE_SUCURSAL := NULL;
               BEGIN
                  SELECT REGCOD,
                         TRIM(REGNOM),
                         CODZON,
                         TRIM(DESZON),
                         SUCURS,
                         TRIM(SCNOM)
                    INTO CODIGO_REGION,
                         NOMBRE_REGION,
                         CODIGO_ZONA,
                         NOMBRE_ZONA,
                         CODIGO_SUCURSAL,
                         NOMBRE_SUCURSAL
                    FROM REGSUC
                   WHERE SUCURS = J1.AQPC792SUC;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               CODIGO_ANALISTA := NULL;
               NOMBRE_ANALISTA := NULL;
               BEGIN
                  SELECT A.SNG001ASE, 
                         TRIM(B.UBNOM)
                    INTO CODIGO_ANALISTA, 
                         NOMBRE_ANALISTA
                    FROM SNG001 A, FST746 B
                   WHERE A.SNG001INST = J1.AQPC792INST
                     AND B.UBUSER     = A.SNG001ASE;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               EMPRESA_TRN    := NULL;
               MODULO_TRN     := NULL;
               SUCURSAL_TRN   := NULL;
               TRANSACCION    := NULL;
               RELACION_TRN   := NULL;
               FHCONTABLE_TRN := NULL;
               BEGIN
                  SELECT A1.D601CD, 
                         A1.D601MO, 
                         A1.D601SU, 
                         A1.D601TR, 
                         A1.D601RE,
                         A1.D601FC
                    INTO EMPRESA_TRN,
                         MODULO_TRN,
                         SUCURSAL_TRN,
                         TRANSACCION,
                         RELACION_TRN,
                         FHCONTABLE_TRN
                    FROM FSD601 A1
                   WHERE A1.PGCOD  = J1.AQPC792EMP
                     AND A1.PPMOD  = J1.AQPC792MOD
                     AND A1.PPSUC  = J1.AQPC792SUC
                     AND A1.PPMDA  = J1.AQPC792MDA
                     AND A1.PPPAP  = J1.AQPC792PAP
                     AND A1.PPCTA  = J1.AQPC792CTA
                     AND A1.PPOPER = J1.AQPC792OPER
                     AND A1.PPSBOP = J1.AQPC792SBOP
                     AND A1.PPTOPE = J1.AQPC792TOPE
                     AND A1.D601CO = 'S'
                     AND ROWNUM    = 1;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               HORA_DESEMBOLSO := NULL;
               CODIGO_OPERADOR := NULL;
               BEGIN
                  SELECT A1.ITHORA,
                         A1.ITUING
                    INTO HORA_DESEMBOLSO,
                         CODIGO_OPERADOR
                    FROM FSD015 A1
                   WHERE A1.PGCOD  = EMPRESA_TRN
                     AND A1.ITSUC  = SUCURSAL_TRN
                     AND A1.ITMOD  = MODULO_TRN
                     AND A1.ITTRAN = TRANSACCION
                     AND A1.ITNREL = RELACION_TRN
                     AND ROWNUM    = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     BEGIN
                        SELECT A1.HHORA,
                               A1.HUSING
                          INTO HORA_DESEMBOLSO,
                               CODIGO_OPERADOR
                          FROM FSH015 A1
                         WHERE A1.PGCOD  = EMPRESA_TRN
                           AND A1.HCMOD  = MODULO_TRN
                           AND A1.HSUCOR = SUCURSAL_TRN
                           AND A1.HTRAN  = TRANSACCION
                           AND A1.HNREL  = RELACION_TRN
                           AND A1.HFCON  = FHCONTABLE_TRN
                           AND ROWNUM    = 1;
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               NOMBRE_OPERADOR := NULL;
               BEGIN
                  SELECT TRIM(A1.UBNOM)
                    INTO NOMBRE_OPERADOR
                    FROM FST746 A1
                   WHERE A1.UBUSER = RPAD(CODIGO_OPERADOR, 10, ' ');
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               SIGNO_MONEDA := NULL;
               BEGIN
                  SELECT TRIM(MOSIGN)
                    INTO SIGNO_MONEDA
                    FROM FST005
                   WHERE MONEDA = J1.AQPC792MDA;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               PAIS_DOCUMENTO := NULL;
               TIPO_DOCUMENTO := NULL;
               NRO_DOCUMENTO  := NULL;
               BEGIN
                  SELECT PEPAIS, 
                         PETDOC, 
                         PENDOC
                    INTO PAIS_DOCUMENTO, 
                         TIPO_DOCUMENTO, 
                         NRO_DOCUMENTO
                    FROM FSR008
                   WHERE CTNRO  = J1.AQPC792CTA
                     AND CTTFIR = 'T';
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               NOMBRE_CLIENTE := NULL;
               BEGIN
                  SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                         TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)
                    INTO NOMBRE_CLIENTE
                    FROM FSD002
                   WHERE PFPAIS = PAIS_DOCUMENTO
                     AND PFTDOC = TIPO_DOCUMENTO
                     AND PFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     SELECT TRIM(PJRAZS)
                       INTO NOMBRE_CLIENTE
                       FROM FSD003
                      WHERE PJPAIS = PAIS_DOCUMENTO
                        AND PJTDOC = TIPO_DOCUMENTO
                        AND PJNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               /*==================== DATOS DE LA GARANTÍA ====================*/
            
               PAIS_DOCUMENTO := NULL;
               TIPO_DOCUMENTO := NULL;
               NRO_DOCUMENTO  := NULL;
               BEGIN
                  SELECT PEPAIS, 
                         PETDOC, 
                         PENDOC
                    INTO PAIS_DOCUMENTO, 
                         TIPO_DOCUMENTO, 
                         NRO_DOCUMENTO
                    FROM FSR008
                   WHERE CTNRO  = J1.AQPC792CTAG
                     AND CTTFIR = 'T';
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               NOMBRE_CLIENTE_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                         TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)
                    INTO NOMBRE_CLIENTE_GARANTIA
                    FROM FSD002
                   WHERE PFPAIS = PAIS_DOCUMENTO
                     AND PFTDOC = TIPO_DOCUMENTO
                     AND PFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     SELECT TRIM(PJRAZS)
                       INTO NOMBRE_CLIENTE_GARANTIA
                       FROM FSD003
                      WHERE PJPAIS = PAIS_DOCUMENTO
                        AND PJTDOC = TIPO_DOCUMENTO
                        AND PJNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               SIGNO_MONEDA_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(MOSIGN)
                    INTO SIGNO_MONEDA_GARANTIA
                    FROM FST005
                   WHERE MONEDA = J1.AQPC792MDAG;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               DPF := NULL;
               DPF := LPAD(TRIM(TO_CHAR(J1.R1CTA)), 9, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1MOD)), 3, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1MDA)), 4, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1OPER)), 9, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1TOPE)), 3, '0');
               
               NOMBRE_ESTADO_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(A1.CENOM)
                    INTO NOMBRE_ESTADO_GARANTIA
                    FROM FST026 A1
                   WHERE A1.CECOD = J1.AQPC792STAT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               GARANTIA_CERTIFICADA := 'NO';
               BEGIN
                  SELECT 'SI'
                    INTO GARANTIA_CERTIFICADA
                    FROM JAQA11 A1
                   WHERE A1.JAQA11EMP = J1.AQPC792EMPG
                     AND A1.JAQA11MOD = J1.AQPC792MODG
                     AND A1.JAQA11SUC = J1.AQPC792SUCG
                     AND A1.JAQA11MDA = J1.AQPC792MDAG
                     AND A1.JAQA11PAP = J1.AQPC792PAPG
                     AND A1.JAQA11CTA = J1.AQPC792CTAG
                     AND A1.JAQA11OPE = J1.AQPC792OPERG
                     AND A1.JAQA11SBO = J1.AQPC792SBOPG
                     AND A1.JAQA11TOP = J1.AQPC792TOPEG
                     AND A1.JAQA11EST = 'S'
                     AND ROWNUM       = 1;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               BEGIN
                  INSERT INTO AQPC783
                     (AQPC783CORR,
                      AQPC783USUP,
                      AQPC783FDESEM,
                      AQPC783HORA,
                      AQPC783CODREG,
                      AQPC783NOMREG,
                      AQPC783CODZON,
                      AQPC783NOMZON,
                      AQPC783CODSUC,
                      AQPC783NOMSUC,
                      AQPC783CODOPR,
                      AQPC783NOMOPR,
                      AQPC783EMP,
                      AQPC783MOD,
                      AQPC783SUC,
                      AQPC783MDA,
                      AQPC783PAP,
                      AQPC783CTA,
                      AQPC783OPER,
                      AQPC783SBOP,
                      AQPC783TOPE,
                      AQPC783EMPG,
                      AQPC783MODG,
                      AQPC783SUCG,
                      AQPC783MDAG,
                      AQPC783PAPG,
                      AQPC783CTAG,
                      AQPC783OPERG,
                      AQPC783SBOPG,
                      AQPC783TOPEG,
                      AQPC783SMDAG,
                      AQPC783SMDA,
                      AQPC783PAISG,
                      AQPC783TDOCG,
                      AQPC783NDOCG,
                      AQPC783NOMCLG,
                      AQPC783PAIS,
                      AQPC783TDOC,
                      AQPC783NDOC,
                      AQPC783NOMCLI,
                      AQPC783MONTO,
                      AQPC783CODANL,
                      AQPC783NOMANL,
                      AQPC783DPF,
                      AQPC783TPDESB,
                      AQPC783FCHP,
                      AQPC783HORP,
                      AQPC783ESTG,
                      AQPC783NESTG,
                      AQPC783GCERTF)
                  VALUES
                     (CONTADOR,
                      P_USUARIO_REGISTRO,
                      J1.AQPC792FVAL,
                      HORA_DESEMBOLSO,
                      CODIGO_REGION,
                      NOMBRE_REGION,
                      CODIGO_ZONA,
                      NOMBRE_ZONA,
                      CODIGO_SUCURSAL,
                      NOMBRE_SUCURSAL,
                      CODIGO_OPERADOR,
                      NOMBRE_OPERADOR,
                      J1.AQPC792EMP,
                      J1.AQPC792MOD,
                      J1.AQPC792SUC,
                      J1.AQPC792MDA,
                      J1.AQPC792PAP,
                      J1.AQPC792CTA,
                      J1.AQPC792OPER,
                      J1.AQPC792SBOP,
                      J1.AQPC792TOPE,
                      J1.AQPC792EMPG,
                      J1.AQPC792MODG,
                      J1.AQPC792SUCG,
                      J1.AQPC792MDAG,
                      J1.AQPC792PAPG,
                      J1.AQPC792CTAG,
                      J1.AQPC792OPERG,
                      J1.AQPC792SBOPG,
                      J1.AQPC792TOPEG,
                      SIGNO_MONEDA_GARANTIA,
                      SIGNO_MONEDA,
                      PAIS_DOCUMENTO_GARANTIA,
                      TIPO_DOCUMENTO_GARANTIA,
                      NRO_DOCUMENTO_GARANTIA,
                      NOMBRE_CLIENTE_GARANTIA,
                      PAIS_DOCUMENTO,
                      TIPO_DOCUMENTO,
                      NRO_DOCUMENTO,
                      NOMBRE_CLIENTE,
                      J1.AQPC792IMP,
                      CODIGO_ANALISTA,
                      NOMBRE_ANALISTA,
                      DPF,
                      J1.TIPO_DESEMBOLSO,
                      FECHA_SISTEMA,
                      TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                      J1.AQPC792STAT,
                      NOMBRE_ESTADO_GARANTIA,
                      GARANTIA_CERTIFICADA);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END LOOP;
         WHEN P_TIPO_DESEMBOLSO = 2 THEN
            CONTADOR := 0;
            FOR J1 IN DESEMBOLSOS_GARANTIA_DPF_2 LOOP
               CONTADOR := CONTADOR + 1;
            
               /*==================== DATOS DEL CRÉDITO ====================*/
            
               CODIGO_REGION   := NULL;
               NOMBRE_REGION   := NULL;
               CODIGO_ZONA     := NULL;
               NOMBRE_ZONA     := NULL;
               CODIGO_SUCURSAL := NULL;
               NOMBRE_SUCURSAL := NULL;
               BEGIN
                  SELECT REGCOD,
                         TRIM(REGNOM),
                         CODZON,
                         TRIM(DESZON),
                         SUCURS,
                         TRIM(SCNOM)
                    INTO CODIGO_REGION,
                         NOMBRE_REGION,
                         CODIGO_ZONA,
                         NOMBRE_ZONA,
                         CODIGO_SUCURSAL,
                         NOMBRE_SUCURSAL
                    FROM REGSUC
                   WHERE SUCURS = J1.AQPC792SUC;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               CODIGO_ANALISTA := NULL;
               NOMBRE_ANALISTA := NULL;
               BEGIN
                  SELECT A.SNG001ASE, 
                         TRIM(B.UBNOM)
                    INTO CODIGO_ANALISTA, 
                         NOMBRE_ANALISTA
                    FROM SNG001 A, FST746 B
                   WHERE A.SNG001INST = J1.AQPC792INST
                     AND B.UBUSER     = A.SNG001ASE;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               EMPRESA_TRN    := NULL;
               MODULO_TRN     := NULL;
               SUCURSAL_TRN   := NULL;
               TRANSACCION    := NULL;
               RELACION_TRN   := NULL;
               FHCONTABLE_TRN := NULL;
               BEGIN
                  SELECT A1.D601CD, 
                         A1.D601MO, 
                         A1.D601SU, 
                         A1.D601TR, 
                         A1.D601RE,
                         A1.D601FC
                    INTO EMPRESA_TRN,
                         MODULO_TRN,
                         SUCURSAL_TRN,
                         TRANSACCION,
                         RELACION_TRN,
                         FHCONTABLE_TRN
                    FROM FSD601 A1
                   WHERE A1.PGCOD  = J1.AQPC792EMP
                     AND A1.PPMOD  = J1.AQPC792MOD
                     AND A1.PPSUC  = J1.AQPC792SUC
                     AND A1.PPMDA  = J1.AQPC792MDA
                     AND A1.PPPAP  = J1.AQPC792PAP
                     AND A1.PPCTA  = J1.AQPC792CTA
                     AND A1.PPOPER = J1.AQPC792OPER
                     AND A1.PPSBOP = J1.AQPC792SBOP
                     AND A1.PPTOPE = J1.AQPC792TOPE
                     AND A1.D601CO = 'S'
                     AND ROWNUM    = 1;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               HORA_DESEMBOLSO := NULL;
               CODIGO_OPERADOR := NULL;
               BEGIN
                  SELECT A1.ITHORA,
                         A1.ITUING
                    INTO HORA_DESEMBOLSO,
                         CODIGO_OPERADOR
                    FROM FSD015 A1
                   WHERE A1.PGCOD  = EMPRESA_TRN
                     AND A1.ITSUC  = SUCURSAL_TRN
                     AND A1.ITMOD  = MODULO_TRN
                     AND A1.ITTRAN = TRANSACCION
                     AND A1.ITNREL = RELACION_TRN
                     AND ROWNUM    = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     BEGIN
                        SELECT A1.HHORA,
                               A1.HUSING
                          INTO HORA_DESEMBOLSO,
                               CODIGO_OPERADOR
                          FROM FSH015 A1
                         WHERE A1.PGCOD  = EMPRESA_TRN
                           AND A1.HCMOD  = MODULO_TRN
                           AND A1.HSUCOR = SUCURSAL_TRN
                           AND A1.HTRAN  = TRANSACCION
                           AND A1.HNREL  = RELACION_TRN
                           AND A1.HFCON  = FHCONTABLE_TRN
                           AND ROWNUM    = 1;
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               NOMBRE_OPERADOR := NULL;
               BEGIN
                  SELECT TRIM(A1.UBNOM)
                    INTO NOMBRE_OPERADOR
                    FROM FST746 A1
                   WHERE A1.UBUSER = RPAD(CODIGO_OPERADOR, 10, ' ');
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               SIGNO_MONEDA := NULL;
               BEGIN
                  SELECT TRIM(MOSIGN)
                    INTO SIGNO_MONEDA
                    FROM FST005
                   WHERE MONEDA = J1.AQPC792MDA;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               PAIS_DOCUMENTO := NULL;
               TIPO_DOCUMENTO := NULL;
               NRO_DOCUMENTO  := NULL;
               BEGIN
                  SELECT PEPAIS, 
                         PETDOC, 
                         PENDOC
                    INTO PAIS_DOCUMENTO, 
                         TIPO_DOCUMENTO, 
                         NRO_DOCUMENTO
                    FROM FSR008
                   WHERE CTNRO  = J1.AQPC792CTA
                     AND CTTFIR = 'T';
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               NOMBRE_CLIENTE := NULL;
               BEGIN
                  SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                         TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)
                    INTO NOMBRE_CLIENTE
                    FROM FSD002
                   WHERE PFPAIS = PAIS_DOCUMENTO
                     AND PFTDOC = TIPO_DOCUMENTO
                     AND PFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     SELECT TRIM(PJRAZS)
                       INTO NOMBRE_CLIENTE
                       FROM FSD003
                      WHERE PJPAIS = PAIS_DOCUMENTO
                        AND PJTDOC = TIPO_DOCUMENTO
                        AND PJNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               /*==================== DATOS DE LA GARANTÍA ====================*/
            
               PAIS_DOCUMENTO := NULL;
               TIPO_DOCUMENTO := NULL;
               NRO_DOCUMENTO  := NULL;
               BEGIN
                  SELECT PEPAIS, 
                         PETDOC, 
                         PENDOC
                    INTO PAIS_DOCUMENTO, 
                         TIPO_DOCUMENTO, 
                         NRO_DOCUMENTO
                    FROM FSR008
                   WHERE CTNRO  = J1.AQPC792CTAG
                     AND CTTFIR = 'T';
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               NOMBRE_CLIENTE_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                         TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)
                    INTO NOMBRE_CLIENTE_GARANTIA
                    FROM FSD002
                   WHERE PFPAIS = PAIS_DOCUMENTO
                     AND PFTDOC = TIPO_DOCUMENTO
                     AND PFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     SELECT TRIM(PJRAZS)
                       INTO NOMBRE_CLIENTE_GARANTIA
                       FROM FSD003
                      WHERE PJPAIS = PAIS_DOCUMENTO
                        AND PJTDOC = TIPO_DOCUMENTO
                        AND PJNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               SIGNO_MONEDA_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(MOSIGN)
                    INTO SIGNO_MONEDA_GARANTIA
                    FROM FST005
                   WHERE MONEDA = J1.AQPC792MDAG;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               DPF := NULL;
               DPF := LPAD(TRIM(TO_CHAR(J1.R1CTA)), 9, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1MOD)), 3, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1MDA)), 4, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1OPER)), 9, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1TOPE)), 3, '0');
               
               NOMBRE_ESTADO_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(A1.CENOM)
                    INTO NOMBRE_ESTADO_GARANTIA
                    FROM FST026 A1
                   WHERE A1.CECOD = J1.AQPC792STAT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               GARANTIA_CERTIFICADA := 'NO';
               BEGIN
                  SELECT 'SI'
                    INTO GARANTIA_CERTIFICADA
                    FROM JAQA11 A1
                   WHERE A1.JAQA11EMP = J1.AQPC792EMPG
                     AND A1.JAQA11MOD = J1.AQPC792MODG
                     AND A1.JAQA11SUC = J1.AQPC792SUCG
                     AND A1.JAQA11MDA = J1.AQPC792MDAG
                     AND A1.JAQA11PAP = J1.AQPC792PAPG
                     AND A1.JAQA11CTA = J1.AQPC792CTAG
                     AND A1.JAQA11OPE = J1.AQPC792OPERG
                     AND A1.JAQA11SBO = J1.AQPC792SBOPG
                     AND A1.JAQA11TOP = J1.AQPC792TOPEG
                     AND A1.JAQA11EST = 'S'
                     AND ROWNUM       = 1;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               BEGIN
                  INSERT INTO AQPC783
                     (AQPC783CORR,
                      AQPC783USUP,
                      AQPC783FDESEM,
                      AQPC783HORA,
                      AQPC783CODREG,
                      AQPC783NOMREG,
                      AQPC783CODZON,
                      AQPC783NOMZON,
                      AQPC783CODSUC,
                      AQPC783NOMSUC,
                      AQPC783CODOPR,
                      AQPC783NOMOPR,
                      AQPC783EMP,
                      AQPC783MOD,
                      AQPC783SUC,
                      AQPC783MDA,
                      AQPC783PAP,
                      AQPC783CTA,
                      AQPC783OPER,
                      AQPC783SBOP,
                      AQPC783TOPE,
                      AQPC783EMPG,
                      AQPC783MODG,
                      AQPC783SUCG,
                      AQPC783MDAG,
                      AQPC783PAPG,
                      AQPC783CTAG,
                      AQPC783OPERG,
                      AQPC783SBOPG,
                      AQPC783TOPEG,
                      AQPC783SMDAG,
                      AQPC783SMDA,
                      AQPC783PAISG,
                      AQPC783TDOCG,
                      AQPC783NDOCG,
                      AQPC783NOMCLG,
                      AQPC783PAIS,
                      AQPC783TDOC,
                      AQPC783NDOC,
                      AQPC783NOMCLI,
                      AQPC783MONTO,
                      AQPC783CODANL,
                      AQPC783NOMANL,
                      AQPC783DPF,
                      AQPC783TPDESB,
                      AQPC783FCHP,
                      AQPC783HORP,
                      AQPC783ESTG,
                      AQPC783NESTG,
                      AQPC783GCERTF)
                  VALUES
                     (CONTADOR,
                      P_USUARIO_REGISTRO,
                      J1.AQPC792FVAL,
                      HORA_DESEMBOLSO,
                      CODIGO_REGION,
                      NOMBRE_REGION,
                      CODIGO_ZONA,
                      NOMBRE_ZONA,
                      CODIGO_SUCURSAL,
                      NOMBRE_SUCURSAL,
                      CODIGO_OPERADOR,
                      NOMBRE_OPERADOR,
                      J1.AQPC792EMP,
                      J1.AQPC792MOD,
                      J1.AQPC792SUC,
                      J1.AQPC792MDA,
                      J1.AQPC792PAP,
                      J1.AQPC792CTA,
                      J1.AQPC792OPER,
                      J1.AQPC792SBOP,
                      J1.AQPC792TOPE,
                      J1.AQPC792EMPG,
                      J1.AQPC792MODG,
                      J1.AQPC792SUCG,
                      J1.AQPC792MDAG,
                      J1.AQPC792PAPG,
                      J1.AQPC792CTAG,
                      J1.AQPC792OPERG,
                      J1.AQPC792SBOPG,
                      J1.AQPC792TOPEG,
                      SIGNO_MONEDA_GARANTIA,
                      SIGNO_MONEDA,
                      PAIS_DOCUMENTO_GARANTIA,
                      TIPO_DOCUMENTO_GARANTIA,
                      NRO_DOCUMENTO_GARANTIA,
                      NOMBRE_CLIENTE_GARANTIA,
                      PAIS_DOCUMENTO,
                      TIPO_DOCUMENTO,
                      NRO_DOCUMENTO,
                      NOMBRE_CLIENTE,
                      J1.AQPC792IMP,
                      CODIGO_ANALISTA,
                      NOMBRE_ANALISTA,
                      DPF,
                      J1.TIPO_DESEMBOLSO,
                      FECHA_SISTEMA,
                      TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                      J1.AQPC792STAT,
                      NOMBRE_ESTADO_GARANTIA,
                      GARANTIA_CERTIFICADA);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END LOOP;
         WHEN P_TIPO_DESEMBOLSO = 3 THEN
            CONTADOR := 0;
            FOR J1 IN DESEMBOLSOS_GARANTIA_DPF_3 LOOP
               CONTADOR := CONTADOR + 1;
            
               /*==================== DATOS DEL CRÉDITO ====================*/
            
               CODIGO_REGION   := NULL;
               NOMBRE_REGION   := NULL;
               CODIGO_ZONA     := NULL;
               NOMBRE_ZONA     := NULL;
               CODIGO_SUCURSAL := NULL;
               NOMBRE_SUCURSAL := NULL;
               BEGIN
                  SELECT REGCOD,
                         TRIM(REGNOM),
                         CODZON,
                         TRIM(DESZON),
                         SUCURS,
                         TRIM(SCNOM)
                    INTO CODIGO_REGION,
                         NOMBRE_REGION,
                         CODIGO_ZONA,
                         NOMBRE_ZONA,
                         CODIGO_SUCURSAL,
                         NOMBRE_SUCURSAL
                    FROM REGSUC
                   WHERE SUCURS = J1.AQPC792SUC;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               CODIGO_ANALISTA := NULL;
               NOMBRE_ANALISTA := NULL;
               BEGIN
                  SELECT A.SNG001ASE, 
                         TRIM(B.UBNOM)
                    INTO CODIGO_ANALISTA, 
                         NOMBRE_ANALISTA
                    FROM SNG001 A, FST746 B
                   WHERE A.SNG001INST = J1.AQPC792INST
                     AND B.UBUSER     = A.SNG001ASE;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               EMPRESA_TRN    := NULL;
               MODULO_TRN     := NULL;
               SUCURSAL_TRN   := NULL;
               TRANSACCION    := NULL;
               RELACION_TRN   := NULL;
               FHCONTABLE_TRN := NULL;
               BEGIN
                  SELECT A1.D601CD, 
                         A1.D601MO, 
                         A1.D601SU, 
                         A1.D601TR, 
                         A1.D601RE,
                         A1.D601FC
                    INTO EMPRESA_TRN,
                         MODULO_TRN,
                         SUCURSAL_TRN,
                         TRANSACCION,
                         RELACION_TRN,
                         FHCONTABLE_TRN
                    FROM FSD601 A1
                   WHERE A1.PGCOD  = J1.AQPC792EMP
                     AND A1.PPMOD  = J1.AQPC792MOD
                     AND A1.PPSUC  = J1.AQPC792SUC
                     AND A1.PPMDA  = J1.AQPC792MDA
                     AND A1.PPPAP  = J1.AQPC792PAP
                     AND A1.PPCTA  = J1.AQPC792CTA
                     AND A1.PPOPER = J1.AQPC792OPER
                     AND A1.PPSBOP = J1.AQPC792SBOP
                     AND A1.PPTOPE = J1.AQPC792TOPE
                     AND A1.D601CO = 'S'
                     AND ROWNUM    = 1;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               HORA_DESEMBOLSO := NULL;
               CODIGO_OPERADOR := NULL;
               BEGIN
                  SELECT A1.ITHORA,
                         A1.ITUING
                    INTO HORA_DESEMBOLSO,
                         CODIGO_OPERADOR
                    FROM FSD015 A1
                   WHERE A1.PGCOD  = EMPRESA_TRN
                     AND A1.ITSUC  = SUCURSAL_TRN
                     AND A1.ITMOD  = MODULO_TRN
                     AND A1.ITTRAN = TRANSACCION
                     AND A1.ITNREL = RELACION_TRN
                     AND ROWNUM    = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     BEGIN
                        SELECT A1.HHORA,
                               A1.HUSING
                          INTO HORA_DESEMBOLSO,
                               CODIGO_OPERADOR
                          FROM FSH015 A1
                         WHERE A1.PGCOD  = EMPRESA_TRN
                           AND A1.HCMOD  = MODULO_TRN
                           AND A1.HSUCOR = SUCURSAL_TRN
                           AND A1.HTRAN  = TRANSACCION
                           AND A1.HNREL  = RELACION_TRN
                           AND A1.HFCON  = FHCONTABLE_TRN
                           AND ROWNUM    = 1;
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               NOMBRE_OPERADOR := NULL;
               BEGIN
                  SELECT TRIM(A1.UBNOM)
                    INTO NOMBRE_OPERADOR
                    FROM FST746 A1
                   WHERE A1.UBUSER = RPAD(CODIGO_OPERADOR, 10, ' ');
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               SIGNO_MONEDA := NULL;
               BEGIN
                  SELECT TRIM(MOSIGN)
                    INTO SIGNO_MONEDA
                    FROM FST005
                   WHERE MONEDA = J1.AQPC792MDA;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               PAIS_DOCUMENTO := NULL;
               TIPO_DOCUMENTO := NULL;
               NRO_DOCUMENTO  := NULL;
               BEGIN
                  SELECT PEPAIS, 
                         PETDOC, 
                         PENDOC
                    INTO PAIS_DOCUMENTO, 
                         TIPO_DOCUMENTO, 
                         NRO_DOCUMENTO
                    FROM FSR008
                   WHERE CTNRO  = J1.AQPC792CTA
                     AND CTTFIR = 'T';
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               NOMBRE_CLIENTE := NULL;
               BEGIN
                  SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                         TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)
                    INTO NOMBRE_CLIENTE
                    FROM FSD002
                   WHERE PFPAIS = PAIS_DOCUMENTO
                     AND PFTDOC = TIPO_DOCUMENTO
                     AND PFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     SELECT TRIM(PJRAZS)
                       INTO NOMBRE_CLIENTE
                       FROM FSD003
                      WHERE PJPAIS = PAIS_DOCUMENTO
                        AND PJTDOC = TIPO_DOCUMENTO
                        AND PJNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               /*==================== DATOS DE LA GARANTÍA ====================*/
            
               PAIS_DOCUMENTO := NULL;
               TIPO_DOCUMENTO := NULL;
               NRO_DOCUMENTO  := NULL;
               BEGIN
                  SELECT PEPAIS, 
                         PETDOC, 
                         PENDOC
                    INTO PAIS_DOCUMENTO, 
                         TIPO_DOCUMENTO, 
                         NRO_DOCUMENTO
                    FROM FSR008
                   WHERE CTNRO  = J1.AQPC792CTAG
                     AND CTTFIR = 'T';
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               NOMBRE_CLIENTE_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                         TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)
                    INTO NOMBRE_CLIENTE_GARANTIA
                    FROM FSD002
                   WHERE PFPAIS = PAIS_DOCUMENTO
                     AND PFTDOC = TIPO_DOCUMENTO
                     AND PFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     SELECT TRIM(PJRAZS)
                       INTO NOMBRE_CLIENTE_GARANTIA
                       FROM FSD003
                      WHERE PJPAIS = PAIS_DOCUMENTO
                        AND PJTDOC = TIPO_DOCUMENTO
                        AND PJNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               SIGNO_MONEDA_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(MOSIGN)
                    INTO SIGNO_MONEDA_GARANTIA
                    FROM FST005
                   WHERE MONEDA = J1.AQPC792MDAG;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               DPF := NULL;
               DPF := LPAD(TRIM(TO_CHAR(J1.R1CTA)), 9, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1MOD)), 3, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1MDA)), 4, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1OPER)), 9, '0') ||
                      LPAD(TRIM(TO_CHAR(J1.R1TOPE)), 3, '0');
               
               NOMBRE_ESTADO_GARANTIA := NULL;
               BEGIN
                  SELECT TRIM(A1.CENOM)
                    INTO NOMBRE_ESTADO_GARANTIA
                    FROM FST026 A1
                   WHERE A1.CECOD = J1.AQPC792STAT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               GARANTIA_CERTIFICADA := 'NO';
               BEGIN
                  SELECT 'SI'
                    INTO GARANTIA_CERTIFICADA
                    FROM JAQA11 A1
                   WHERE A1.JAQA11EMP = J1.AQPC792EMPG
                     AND A1.JAQA11MOD = J1.AQPC792MODG
                     AND A1.JAQA11SUC = J1.AQPC792SUCG
                     AND A1.JAQA11MDA = J1.AQPC792MDAG
                     AND A1.JAQA11PAP = J1.AQPC792PAPG
                     AND A1.JAQA11CTA = J1.AQPC792CTAG
                     AND A1.JAQA11OPE = J1.AQPC792OPERG
                     AND A1.JAQA11SBO = J1.AQPC792SBOPG
                     AND A1.JAQA11TOP = J1.AQPC792TOPEG
                     AND A1.JAQA11EST = 'S'
                     AND ROWNUM       = 1;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            
               BEGIN
                  INSERT INTO AQPC783
                     (AQPC783CORR,
                      AQPC783USUP,
                      AQPC783FDESEM,
                      AQPC783HORA,
                      AQPC783CODREG,
                      AQPC783NOMREG,
                      AQPC783CODZON,
                      AQPC783NOMZON,
                      AQPC783CODSUC,
                      AQPC783NOMSUC,
                      AQPC783CODOPR,
                      AQPC783NOMOPR,
                      AQPC783EMP,
                      AQPC783MOD,
                      AQPC783SUC,
                      AQPC783MDA,
                      AQPC783PAP,
                      AQPC783CTA,
                      AQPC783OPER,
                      AQPC783SBOP,
                      AQPC783TOPE,
                      AQPC783EMPG,
                      AQPC783MODG,
                      AQPC783SUCG,
                      AQPC783MDAG,
                      AQPC783PAPG,
                      AQPC783CTAG,
                      AQPC783OPERG,
                      AQPC783SBOPG,
                      AQPC783TOPEG,
                      AQPC783SMDAG,
                      AQPC783SMDA,
                      AQPC783PAISG,
                      AQPC783TDOCG,
                      AQPC783NDOCG,
                      AQPC783NOMCLG,
                      AQPC783PAIS,
                      AQPC783TDOC,
                      AQPC783NDOC,
                      AQPC783NOMCLI,
                      AQPC783MONTO,
                      AQPC783CODANL,
                      AQPC783NOMANL,
                      AQPC783DPF,
                      AQPC783TPDESB,
                      AQPC783FCHP,
                      AQPC783HORP,
                      AQPC783ESTG,
                      AQPC783NESTG,
                      AQPC783GCERTF)
                  VALUES
                     (CONTADOR,
                      P_USUARIO_REGISTRO,
                      J1.AQPC792FVAL,
                      HORA_DESEMBOLSO,
                      CODIGO_REGION,
                      NOMBRE_REGION,
                      CODIGO_ZONA,
                      NOMBRE_ZONA,
                      CODIGO_SUCURSAL,
                      NOMBRE_SUCURSAL,
                      CODIGO_OPERADOR,
                      NOMBRE_OPERADOR,
                      J1.AQPC792EMP,
                      J1.AQPC792MOD,
                      J1.AQPC792SUC,
                      J1.AQPC792MDA,
                      J1.AQPC792PAP,
                      J1.AQPC792CTA,
                      J1.AQPC792OPER,
                      J1.AQPC792SBOP,
                      J1.AQPC792TOPE,
                      J1.AQPC792EMPG,
                      J1.AQPC792MODG,
                      J1.AQPC792SUCG,
                      J1.AQPC792MDAG,
                      J1.AQPC792PAPG,
                      J1.AQPC792CTAG,
                      J1.AQPC792OPERG,
                      J1.AQPC792SBOPG,
                      J1.AQPC792TOPEG,
                      SIGNO_MONEDA_GARANTIA,
                      SIGNO_MONEDA,
                      PAIS_DOCUMENTO_GARANTIA,
                      TIPO_DOCUMENTO_GARANTIA,
                      NRO_DOCUMENTO_GARANTIA,
                      NOMBRE_CLIENTE_GARANTIA,
                      PAIS_DOCUMENTO,
                      TIPO_DOCUMENTO,
                      NRO_DOCUMENTO,
                      NOMBRE_CLIENTE,
                      J1.AQPC792IMP,
                      CODIGO_ANALISTA,
                      NOMBRE_ANALISTA,
                      DPF,
                      J1.TIPO_DESEMBOLSO,
                      FECHA_SISTEMA,
                      TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                      J1.AQPC792STAT,
                      NOMBRE_ESTADO_GARANTIA,
                      GARANTIA_CERTIFICADA);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END LOOP;
      END CASE;
   END SP_CR_REPORTE_GARANTIAS_DPF;

/*============================================================================================================================*/ 
   PROCEDURE SP_CR_OBTENER_TIPO_CAMBIO(P_TIPO_CAMBIO_DOLAR OUT NUMBER) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_TIPO_CAMBIO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 09/07/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : OBTENER EL TIPO DE CAMBIO(DOLAR) AL CIERRE DEL
   --                               MES ANTERIOR
   -- PARAMETROS                  : - P_TIPO_CAMBIO_DOLAR : NUMBER(14, 8)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      FECHA_SISTEMA     DATE;
      TIPO_CAMBIO_DOLAR NUMBER(14, 8);
   BEGIN
      FECHA_SISTEMA := NULL;
      BEGIN
         SELECT A1.PGFAPE
           INTO FECHA_SISTEMA
           FROM FST017 A1
          WHERE A1.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      TIPO_CAMBIO_DOLAR := 0;
      BEGIN
         SELECT A1.COTCBI
           INTO TIPO_CAMBIO_DOLAR
           FROM FSH005 A1
          WHERE A1.MONEDA = 101
            AND A1.COFDES = LAST_DAY(ADD_MONTHS(FECHA_SISTEMA, - 1));
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_TIPO_CAMBIO_DOLAR := TIPO_CAMBIO_DOLAR;
      
   END SP_CR_OBTENER_TIPO_CAMBIO;

END PQ_CR_CONSTITUCION_GARANTIA_DPF;
/

