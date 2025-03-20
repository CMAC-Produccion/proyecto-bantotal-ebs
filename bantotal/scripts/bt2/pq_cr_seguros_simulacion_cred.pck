CREATE OR REPLACE PACKAGE PQ_CR_SEGUROS_SIMULACION_CRED IS
   
   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_SEGUROS_SIMULACION_CRED
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 12/03/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************   

   PROCEDURE SP_CR_VALIDAR_SEGUROS(PN_PAIS              IN NUMBER,
                                   PN_TIPO_DOCUMENTO    IN NUMBER,
                                   PV_DOCUMENTO         IN VARCHAR2,
                                   PN_EMPRESA           IN NUMBER,
                                   PN_MODULO            IN NUMBER,
                                   PN_SUCURSAL          IN NUMBER,
                                   PN_CUENTA            IN NUMBER,
                                   PN_OPERACION         IN NUMBER,
                                   PN_MONEDA            IN NUMBER,
                                   PN_PAPEL             IN NUMBER,
                                   PN_TIPO_OPERACION    IN NUMBER,
                                   PN_TASA_CREDITO      IN NUMBER,
                                   PN_MONTO_CREDITO     IN NUMBER,
                                   PN_PERIODO_DIAS      IN NUMBER,
                                   PN_CANTIDAD_CUOTAS   IN NUMBER,
                                   PD_FECHA_PRIMER_PAGO IN DATE,
                                   PV_RESPUESTA_SD      OUT VARCHAR2,
                                   PN_CODIGO_SD         OUT NUMBER,
                                   PN_IMPORTE_SD        OUT NUMBER,
                                   PV_RESPUESTA_SM      OUT VARCHAR2,
                                   PN_CODIGO_SM         OUT NUMBER,
                                   PN_IMPORTE_SM        OUT NUMBER,
                                   PV_RESPUESTA_SVC     OUT VARCHAR2,
                                   PN_CODIGO_SVC        OUT NUMBER,
                                   PN_IMPORTE_SVC       OUT NUMBER);

END PQ_CR_SEGUROS_SIMULACION_CRED;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_SEGUROS_SIMULACION_CRED IS

   PROCEDURE SP_CR_VALIDAR_SEGUROS(PN_PAIS              IN NUMBER,
                                   PN_TIPO_DOCUMENTO    IN NUMBER,
                                   PV_DOCUMENTO         IN VARCHAR2,
                                   PN_EMPRESA           IN NUMBER,
                                   PN_MODULO            IN NUMBER,
                                   PN_SUCURSAL          IN NUMBER,
                                   PN_CUENTA            IN NUMBER,
                                   PN_OPERACION         IN NUMBER,
                                   PN_MONEDA            IN NUMBER,
                                   PN_PAPEL             IN NUMBER,
                                   PN_TIPO_OPERACION    IN NUMBER,
                                   PN_TASA_CREDITO      IN NUMBER,
                                   PN_MONTO_CREDITO     IN NUMBER,
                                   PN_PERIODO_DIAS      IN NUMBER,
                                   PN_CANTIDAD_CUOTAS   IN NUMBER,
                                   PD_FECHA_PRIMER_PAGO IN DATE,
                                   PV_RESPUESTA_SD      OUT VARCHAR2,
                                   PN_CODIGO_SD         OUT NUMBER,
                                   PN_IMPORTE_SD        OUT NUMBER,
                                   PV_RESPUESTA_SM      OUT VARCHAR2,
                                   PN_CODIGO_SM         OUT NUMBER,
                                   PN_IMPORTE_SM        OUT NUMBER,
                                   PV_RESPUESTA_SVC     OUT VARCHAR2,
                                   PN_CODIGO_SVC        OUT NUMBER,
                                   PN_IMPORTE_SVC       OUT NUMBER) IS
    
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_SEGUROS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 12/03/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDA QUE TIPO DE SEGURO TIENE EL CLIENTE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
   RESPUESTA_SD VARCHAR2(1);
   CODIGO_SD    NUMBER(9);
   RESPUESTA_SM VARCHAR2(1);
   CODIGO_SM    NUMBER(9);
    
   BEGIN
      RESPUESTA_SD := 'N';
      CODIGO_SD    := 0;
      IF PN_TIPO_DOCUMENTO <> 9 THEN
         BEGIN
            SELECT 'S', A.SGCOD
              INTO RESPUESTA_SD, CODIGO_SD
              FROM FST300 A, FPP065 B
             WHERE A.SGCOD BETWEEN 351 AND 358
               AND B.PP065SGCOD = A.SGCOD
               AND B.PP065TIPO3 = PN_PERIODO_DIAS;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END IF;
      
      RESPUESTA_SM := 'N';
      CODIGO_SM    := 0;
      BEGIN
         SELECT 'S', SGCOD
           INTO RESPUESTA_SM, CODIGO_SM
           FROM FST300 A, FPP065 B
          WHERE A.SGCOD BETWEEN 166 AND 173
            AND B.PP065SGCOD = A.SGCOD
            AND B.PP065TIPO3 = PN_PERIODO_DIAS;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      PV_RESPUESTA_SD := NULL;
      PN_CODIGO_SD    := NULL;
      PV_RESPUESTA_SM := NULL;
      PN_CODIGO_SM    := NULL;
      
      PV_RESPUESTA_SD := RESPUESTA_SD; -- SEGURO DESGRAVAMEN
      PN_CODIGO_SD    := CODIGO_SD;    -- SEGURO DESGRAVAMEN
      PV_RESPUESTA_SM := RESPUESTA_SM; -- SEGURO MULTIRIESGO
      PN_CODIGO_SM    := CODIGO_SM;    -- SEGURO MULTIRIESGO
      
   END SP_CR_VALIDAR_SEGUROS;

END PQ_CR_SEGUROS_SIMULACION_CRED;
/

