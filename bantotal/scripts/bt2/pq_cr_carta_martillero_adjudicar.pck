CREATE OR REPLACE PACKAGE PQ_CR_CARTA_MARTILLERO_ADJUDICAR IS

   -- ====================================================================================================
   -- NOMBRE                      : PQ_CR_CARTA_MARTILLERO_ADJUDICAR
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/01/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -- ====================================================================================================
   -- FECHA DE MODIFICACION       : 21/11/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE MODIFICO EL PROCEDIMIENTO:
   --                               - SP_CR_PRECIO_BASE
   -- ====================================================================================================

   PROCEDURE SP_CR_MAXIMO_ESTADO_ADJUDICAR(P_EMPRESA IN  NUMBER,
                                           P_LOTE    IN  NUMBER,
                                           P_ESTADO  OUT NUMBER);
   
   /*===================================================================================================*/   
   PROCEDURE SP_CR_MAXIMA_SUBOPERACION_LOTE(P_EMPRESA           IN  NUMBER,
                                            P_LOTE              IN  NUMBER,
                                            P_SUCURSAL          IN  NUMBER,
                                            P_SUBOPERACION_LOTE OUT NUMBER);
   
   /*===================================================================================================*/
   PROCEDURE SP_CR_FECHA_REMATE_Y_ADJUDICAR(P_REMATE          IN  NUMBER,
                                            P_SUCURSAL        IN  NUMBER,
                                            P_FECHA_REMATE    OUT DATE,
                                            P_FECHA_ADJUDICAR OUT DATE);
   
   /*===================================================================================================*/                                          
   PROCEDURE SP_CR_PRECIO_BASE(P_REMATE      IN  NUMBER,
                               P_EMPRESA     IN  NUMBER,
                               P_LOTE        IN  NUMBER,
                               P_PRECIO_BASE OUT NUMBER);
   
   /*===================================================================================================*/                            
   PROCEDURE SP_CR_NOMBRE_CLIENTE(P_EMPRESA        IN  NUMBER,
                                  P_CUENTA         IN  NUMBER,
                                  P_NOMBRE_CLIENTE OUT VARCHAR2);
   
   /*===================================================================================================*/
   PROCEDURE SP_CR_MAXIMA_SUBOPERACION_CONTRATO(P_EMPRESA               IN  NUMBER,
                                                P_MODULO                IN  NUMBER,
                                                P_SUCURSAL              IN  NUMBER,
                                                P_MONEDA                IN  NUMBER,
                                                P_PAPEL                 IN  NUMBER,
                                                P_CUENTA                IN  NUMBER,
                                                P_OPERACION             IN  NUMBER,
                                                P_SUBOPERACION_CONTRATO OUT NUMBER);
   
   /*===================================================================================================*/                                             
   PROCEDURE SP_CR_DATOS_CUERPO_CABECERA(P_ESTIMADO  OUT VARCHAR2,
                                         P_DOMICILIO OUT VARCHAR2,
                                         P_DISTRITO  OUT VARCHAR2);
                                         
END PQ_CR_CARTA_MARTILLERO_ADJUDICAR;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CARTA_MARTILLERO_ADJUDICAR IS
   
   PROCEDURE SP_CR_MAXIMO_ESTADO_ADJUDICAR(P_EMPRESA IN  NUMBER,
                                           P_LOTE    IN  NUMBER,
                                           P_ESTADO  OUT NUMBER) IS
   BEGIN
      SELECT PP182COD
        INTO P_ESTADO
        FROM FPP183
       WHERE PP173COD = P_EMPRESA
         AND PP174COD = P_LOTE
         AND PP183COD = (SELECT MAX(PP183COD)
                           FROM FPP183
                          WHERE PP173COD = P_EMPRESA
                            AND PP174COD = P_LOTE)
         AND PP183CON = 'S';
   EXCEPTION
      WHEN OTHERS THEN
         P_ESTADO := 0;
   END SP_CR_MAXIMO_ESTADO_ADJUDICAR;
   
   PROCEDURE SP_CR_MAXIMA_SUBOPERACION_LOTE(P_EMPRESA      IN   NUMBER,
                                            P_LOTE         IN   NUMBER,
                                            P_SUCURSAL     IN   NUMBER,
                                            P_SUBOPERACION_LOTE OUT NUMBER) IS
   BEGIN
      SELECT MAX(PP175SBOP)
        INTO P_SUBOPERACION_LOTE
        FROM FPP175
       WHERE PP173COD = P_EMPRESA
         AND PP174COD = P_LOTE
         AND PP175SUC = P_SUCURSAL;
   EXCEPTION
      WHEN OTHERS THEN
         P_SUBOPERACION_LOTE := 0;
   END SP_CR_MAXIMA_SUBOPERACION_LOTE;
   
   PROCEDURE SP_CR_FECHA_REMATE_Y_ADJUDICAR(P_REMATE          IN  NUMBER,
                                            P_SUCURSAL        IN  NUMBER,
                                            P_FECHA_REMATE    OUT DATE,
                                            P_FECHA_ADJUDICAR OUT DATE) IS
      V_FECHA_REMATE      DATE;
      V_DIAS              NUMBER(9);
      V_FECHA_HABIL       VARCHAR2(1);
      V_FECHA_ADJUDICAR   DATE;
      V_CODIGO_CALENDARIO NUMBER(3);
   BEGIN
      BEGIN
         SELECT QZ441DFEC
           INTO V_FECHA_REMATE
           FROM JAQZ441
          WHERE QZ440CODRE = P_REMATE
            AND PP177CODD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_FECHA_REMATE := NULL;
      END;
      BEGIN
         SELECT NVL(TP1NRO1, 0)
           INTO V_DIAS
           FROM FST198
          WHERE TP1COD   = 1
            AND TP1COD1  = 1024
            AND TP1CORR1 = 100
            AND TP1CORR2 = 4
            AND TP1CORR3 = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_DIAS := 0;
      END;
      BEGIN
         SELECT NVL(CALCOD, 0)
         INTO V_CODIGO_CALENDARIO
         FROM FST001
         WHERE PGCOD = 1 AND SUCURS = P_SUCURSAL;
      EXCEPTION
         WHEN OTHERS THEN
            V_CODIGO_CALENDARIO := 0;
      END;
      V_FECHA_HABIL     := 'N';
      V_FECHA_ADJUDICAR := V_FECHA_REMATE + V_DIAS;
      LOOP
         V_FECHA_ADJUDICAR := V_FECHA_ADJUDICAR + 1;
         BEGIN
            SELECT FHABIL
              INTO V_FECHA_HABIL
              FROM FST028
             WHERE CalCod = V_CODIGO_CALENDARIO
               AND Ffecha = V_FECHA_ADJUDICAR;
         EXCEPTION
            WHEN OTHERS THEN
               V_FECHA_HABIL := 'S';
         END;
         EXIT WHEN V_FECHA_HABIL = 'S';
      END LOOP;
      P_FECHA_REMATE    := V_FECHA_REMATE;           
      P_FECHA_ADJUDICAR := V_FECHA_ADJUDICAR; 
   END SP_CR_FECHA_REMATE_Y_ADJUDICAR;
   
   PROCEDURE SP_CR_PRECIO_BASE(P_REMATE      IN  NUMBER,
                               P_EMPRESA     IN  NUMBER,
                               P_LOTE        IN  NUMBER,
                               P_PRECIO_BASE OUT NUMBER) IS
                               
   -- ====================================================================================================
   -- NOMBRE                      : SP_CR_PRECIO_BASE
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 20/01/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA EL PRECIO BASE
   -- PARAMETROS                  : P_REMATE      | NUMBER(4)
   --                               P_EMPRESA     | NUMBER(3)
   --                               P_LOTE        | NUMBER(9)
   --                               P_PRECIO_BASE | NUMBER(17, 2)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -- ====================================================================================================
   -- FECHA DE MODIFICACION       : 21/11/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE CAMBIA LA CONSULTA PARA OBTENER EL PRECIO BASE DE LA TABLA
   --                               FPP187 POR LA TABLA JAQZ443
   -- ====================================================================================================
                               
   BEGIN
      SELECT A1.QZ443DSAL
        INTO P_PRECIO_BASE
        FROM JAQZ443 A1
       WHERE A1.QZ440CODRE = P_REMATE
         AND A1.PP173COD   = P_EMPRESA
         AND A1.PP174COD   = P_LOTE
         AND A1.PP177CODD  = 3;
   EXCEPTION 
      WHEN OTHERS THEN 
         P_PRECIO_BASE := 0;
   END SP_CR_PRECIO_BASE;
   
   PROCEDURE SP_CR_NOMBRE_CLIENTE(P_EMPRESA        IN  NUMBER,
                                  P_CUENTA         IN  NUMBER,
                                  P_NOMBRE_CLIENTE OUT VARCHAR2) IS
   BEGIN
      SELECT TRIM(PENOM)
        INTO P_NOMBRE_CLIENTE
        FROM FSR008 A, FSD001 B
       WHERE A.PGCOD  = P_EMPRESA
         AND A.CTNRO  = P_CUENTA
         AND A.CTTFIR = 'T'
         AND B.PEPAIS = A.PEPAIS
         AND B.PETDOC = A.PETDOC
         AND B.PENDOC = A.PENDOC;
   EXCEPTION
      WHEN OTHERS THEN
         P_NOMBRE_CLIENTE := NULL;
   END;
   
   PROCEDURE SP_CR_MAXIMA_SUBOPERACION_CONTRATO(P_EMPRESA               IN  NUMBER,
                                                P_MODULO                IN  NUMBER,
                                                P_SUCURSAL              IN  NUMBER,
                                                P_MONEDA                IN  NUMBER,
                                                P_PAPEL                 IN  NUMBER,
                                                P_CUENTA                IN  NUMBER,
                                                P_OPERACION             IN  NUMBER,
                                                P_SUBOPERACION_CONTRATO OUT NUMBER) IS
   BEGIN
      SELECT MAX(AOSBOP)
        INTO P_SUBOPERACION_CONTRATO
        FROM FSD010
       WHERE PGCOD  = P_EMPRESA
         AND AOMOD  = P_MODULO
         AND AOSUC  = P_SUCURSAL
         AND AOMDA  = P_MONEDA
         AND AOPAP  = P_PAPEL
         AND AOCTA  = P_CUENTA
         AND AOOPER = P_OPERACION;
   EXCEPTION
      WHEN OTHERS THEN
         P_SUBOPERACION_CONTRATO := 0;
   END SP_CR_MAXIMA_SUBOPERACION_CONTRATO;
   
   PROCEDURE SP_CR_DATOS_CUERPO_CABECERA(P_ESTIMADO  OUT VARCHAR2,
                                         P_DOMICILIO OUT VARCHAR2,
                                         P_DISTRITO  OUT VARCHAR2) IS
      V_ESTIMADO  VARCHAR2(60);
      V_DOMICILIO VARCHAR2(60);
      V_DISTRITO  VARCHAR2(60);
      
      CURSOR C1 IS 
         SELECT TP1CORR3, TP1DESC 
           FROM FST198 
         WHERE TP1COD   = 1 
           AND TP1COD1  = 1024 
           AND TP1CORR1 = 100 
           AND TP1CORR2 = 5 
           AND TP1CORR3 > 0;
   BEGIN
      V_ESTIMADO  := NULL;
      V_DOMICILIO := NULL;
      V_DISTRITO  := NULL;
      FOR I IN C1 LOOP
         CASE
            WHEN I.TP1CORR3 = 1 THEN
               V_ESTIMADO := TRIM(I.TP1DESC);
            WHEN I.TP1CORR3 = 2 OR I.TP1CORR3 = 3 THEN
               IF I.TP1DESC IS NOT NULL THEN
                  IF V_DOMICILIO IS NULL THEN
                     V_DOMICILIO := TRIM(I.TP1DESC);
                  ELSE
                     V_DOMICILIO := TRIM(V_DOMICILIO)||' '||TRIM(I.TP1DESC);
                  END IF;
               END IF;
            WHEN I.TP1CORR3 = 4 OR I.TP1CORR3 = 5 THEN
               IF I.TP1DESC IS NOT NULL THEN
                  IF V_DOMICILIO IS NULL THEN
                     V_DISTRITO := TRIM(I.TP1DESC);
                  ELSE
                     V_DISTRITO := TRIM(V_DISTRITO)||' '||TRIM(I.TP1DESC);
                  END IF;
               END IF;
            ELSE
               NULL;
         END CASE;
      END LOOP;
      P_ESTIMADO  := V_ESTIMADO;
      P_DOMICILIO := V_DOMICILIO;
      P_DISTRITO  := V_DISTRITO;
   EXCEPTION
      WHEN OTHERS THEN
         P_ESTIMADO  := NULL;
         P_DOMICILIO := NULL;
         P_DISTRITO  := NULL;
   END SP_CR_DATOS_CUERPO_CABECERA;
   
END PQ_CR_CARTA_MARTILLERO_ADJUDICAR;
/

