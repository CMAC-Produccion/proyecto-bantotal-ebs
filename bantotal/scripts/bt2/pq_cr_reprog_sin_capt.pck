CREATE OR REPLACE PACKAGE PQ_CR_REPROG_SIN_CAPT IS
   
   -- **********************************************************************************************************************************
   -- NOMBRE                      : PQ_CR_REPROG_SIN_CAPT
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/09/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --                               
   -- ***********************************************************************************************************************************   

   PROCEDURE SP_CR_NRO_REPROGRAMADOS(P_INSTANCIA IN  NUMBER,
                                     P_RESPUESTA OUT VARCHAR2);

END PQ_CR_REPROG_SIN_CAPT;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_REPROG_SIN_CAPT IS

   PROCEDURE SP_CR_NRO_REPROGRAMADOS(P_INSTANCIA IN  NUMBER,
                                     P_RESPUESTA OUT VARCHAR2) IS

   -- **********************************************************************************************************************************
   -- NOMBRE                      : SP_CR_NRO_REPROGRAMADOS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/09/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDA SI TIENE REPROGRAMACIONES
   -- PARAMETROS                  : P_INSTANCIA | NUMBER(10)
   --                               P_RESPUESTA | VARCHAR2(1)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ---------------------------------------------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- **********************************************************************************************************************************

      V_EMPRESA       NUMBER(3)  := 0;
      V_SUCURSAL      NUMBER(3)  := 0;
      V_MODULO        NUMBER(3)  := 0;
      V_MONEDA        NUMBER(4)  := 0;
      V_PAPEL         NUMBER(4)  := 0;
      V_CUENTA        NUMBER(9)  := 0;
      V_OPERACION     NUMBER(9)  := 0;
      V_SUBOPER       NUMBER(3)  := 0;
      V_TIPOPER       NUMBER(3)  := 0;
      V_INSTULTREPROG NUMBER(10) := 0;
      V_NRO_REPROG    NUMBER(17) := 0;
   BEGIN   
      BEGIN
         SELECT A1.XWFEMPRESA,
                A1.XWFSUCURSAL,
                A1.XWFMODULO,
                A1.XWFMONEDA,
                A1.XWFPAPEL,
                A1.XWFCUENTA,
                A1.XWFOPERACION,
                A1.XWFSUBOPE,
                A1.XWFTIPOPE
           INTO V_EMPRESA,
                V_SUCURSAL,
                V_MODULO,
                V_MONEDA,
                V_PAPEL,
                V_CUENTA,
                V_OPERACION,
                V_SUBOPER,
                V_TIPOPER
           FROM XWF700 A1
          WHERE A1.XWFPRCINS = P_INSTANCIA
            AND A1.XWFCAR3   = '1';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         SELECT NVL(MAX(S.SNG001INST), 0)
           INTO V_INSTULTREPROG
           FROM XWF700 D, SNG001 S, WFWRKITEMS W, XWF070 X70
          WHERE D.XWFPRCINS    = S.SNG001INST
            AND S.SNG001INST   = W.WFINSPRCID
            AND W.WFTASKCOD    = 55
            AND X70.XWFWRKITE  = W.WFITEMID
            AND X70.XWFPGCOD   = D.XWFEMPRESA
            AND X70.XWFPRCIN   = D.XWFPRCINS
            AND S.SNG001ORI   IN (13, 14, 16)
            AND D.XWFEMPRESA   = V_EMPRESA
            AND D.XWFSUCURSAL  = V_SUCURSAL
            AND D.XWFMODULO    = V_MODULO
            AND D.XWFMONEDA    = V_MONEDA
            AND D.XWFPAPEL     = V_PAPEL
            AND D.XWFCUENTA    = V_CUENTA
            AND D.XWFOPERACION = V_OPERACION
            AND D.XWFSUBOPE    = V_SUBOPER
            AND D.XWFTIPOPE    = V_TIPOPER
            AND D.XWFCAR3      = '1'
            AND X70.XWFCONT    = 'S';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      IF V_INSTULTREPROG <> 0 THEN
         BEGIN
            SELECT NVL(COUNT(*), 0)
              INTO V_NRO_REPROG
              FROM XWF700 X, FSD010 F
             WHERE X.XWFPRCINS    = V_INSTULTREPROG
               AND X.XWFCAR3      = '1'
               AND X.XWFEMPRESA   = F.PGCOD
               AND X.XWFSUCURSAL  = F.AOSUC
               AND X.XWFMODULO    = F.AOMOD
               AND X.XWFMONEDA    = F.AOMDA
               AND X.XWFPAPEL     = F.AOPAP
               AND X.XWFCUENTA    = F.AOCTA
               AND X.XWFOPERACION = F.AOOPER
               AND X.XWFSUBOPE    = F.AOSBOP
               AND X.XWFTIPOPE    = F.AOTOPE;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END IF;
      
      IF V_NRO_REPROG >= 1 THEN
         P_RESPUESTA := 'S';
      ELSE
         P_RESPUESTA := 'N';
      END IF;  
   END SP_CR_NRO_REPROGRAMADOS;

END PQ_CR_REPROG_SIN_CAPT;
/

