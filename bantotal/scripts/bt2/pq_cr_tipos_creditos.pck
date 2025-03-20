CREATE OR REPLACE PACKAGE PQ_CR_TIPOS_CREDITOS IS
   
   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_TIPOS_CREDITOS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************

   PROCEDURE SP_CR_VALIDAR_TIPO_CREDITO(PN_INSTANCIA        IN NUMBER,
                                        PN_MODULO_CREDITO   OUT NUMBER,
                                        PN_TIPO_CREDITO     OUT NUMBER,
                                        PV_NOMBRE_TPCREDITO OUT VARCHAR2);

END PQ_CR_TIPOS_CREDITOS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_TIPOS_CREDITOS IS

   PROCEDURE SP_CR_VALIDAR_TIPO_CREDITO(PN_INSTANCIA        IN NUMBER,
                                        PN_MODULO_CREDITO   OUT NUMBER,
                                        PN_TIPO_CREDITO     OUT NUMBER,
                                        PV_NOMBRE_TPCREDITO OUT VARCHAR2) IS
      
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_TIPO_CREDITO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDA EL TIPO DE CREDITO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************   
   
      MODULO_CREDITO   NUMBER(3);
      TIPO_CREDITO     NUMBER(4);
      NOMBRE_TPCREDITO VARCHAR2(30);
   BEGIN
      MODULO_CREDITO := 0;
      TIPO_CREDITO   := 0;
      BEGIN
         SELECT A.XWFMODULO, B.SNG014COD
           INTO MODULO_CREDITO, TIPO_CREDITO
           FROM XWF700 A, SNG001 B
          WHERE A.XWFPRCINS  = PN_INSTANCIA
            AND A.XWFCAR3    = '1'
            AND B.SNG001INST = A.XWFPRCINS;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      NOMBRE_TPCREDITO := NULL;
      BEGIN
         SELECT TRIM(A.TP1DESC)
           INTO NOMBRE_TPCREDITO
           FROM FST198 A
          WHERE A.TP1COD   = 1
            AND A.TP1COD1  = 111154
            AND A.TP1CORR1 = 1
            AND A.TP1CORR2 = 39
            AND A.TP1CORR3 > 0
            AND A.TP1IMP1  = 1
            AND A.TP1NRO1  = TIPO_CREDITO
            AND A.TP1NRO2  = MODULO_CREDITO;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      PN_MODULO_CREDITO   := MODULO_CREDITO;
      PN_TIPO_CREDITO     := TIPO_CREDITO;
      PV_NOMBRE_TPCREDITO := NOMBRE_TPCREDITO;
   
   END SP_CR_VALIDAR_TIPO_CREDITO;
   
END PQ_CR_TIPOS_CREDITOS;
/

