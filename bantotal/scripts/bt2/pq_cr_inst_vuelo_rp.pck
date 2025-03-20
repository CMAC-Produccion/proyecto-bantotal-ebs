CREATE OR REPLACE PACKAGE PQ_CR_INST_VUELO_RP IS

   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_INST_VUELO_RP
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 18/09/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   -- *****************************************************************

   PROCEDURE SP_CR_VALIDAR_CTA_OPER(P_INSTANCIA IN NUMBER,
                                    P_RESPUESTA OUT VARCHAR2);

END PQ_CR_INST_VUELO_RP;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_INST_VUELO_RP IS

   PROCEDURE SP_CR_VALIDAR_CTA_OPER(P_INSTANCIA IN NUMBER,
                                    P_RESPUESTA OUT VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_CTA_OPER
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 18/09/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDA SI LA CUENTA Y OPERACION EXISTE EN LA GUIA
   -- PARAMETROS                  : - P_INSTANCIA  : NUMBER(10)
   --                               - P_RESPUESTA  : VARCHAR2(1)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************                                 
                                    
      V_CUENTA    NUMBER(9) := 0;
      V_OPERACION NUMBER(9) := 0;
      V_RESPUESTA VARCHAR2(1);                              
   BEGIN
      BEGIN
         SELECT A1.XWFCUENTA,
                A1.XWFOPERACION
           INTO V_CUENTA,
                V_OPERACION
           FROM XWF700 A1
          WHERE A1.XWFPRCINS = P_INSTANCIA
            AND A1.XWFCAR3   = '1';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         SELECT 'S'
           INTO V_RESPUESTA
           FROM FST198 A1
          WHERE A1.TP1COD   = 1
            AND A1.TP1COD1  = 111154
            AND A1.TP1CORR1 = 1
            AND A1.TP1CORR2 = 50
            AND A1.TP1CORR3 > 0
            AND A1.TP1IMP1  = 1
            AND A1.TP1NRO1  = V_CUENTA
            AND A1.TP1NRO2  = V_OPERACION;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_RESPUESTA := 'N';
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_RESPUESTA := V_RESPUESTA;
      
   END SP_CR_VALIDAR_CTA_OPER;

END PQ_CR_INST_VUELO_RP;
/

