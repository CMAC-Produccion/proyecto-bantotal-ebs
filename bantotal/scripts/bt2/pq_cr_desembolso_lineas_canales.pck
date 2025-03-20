CREATE OR REPLACE PACKAGE PQ_CR_DESEMBOLSO_LINEAS_CANALES IS
   
   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_DESEMBOLSO_LINEAS_CANALES
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 17/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************

   PROCEDURE SP_CR_GRABAR_CODIGO_CONTROL(P_EMPRESA        IN NUMBER,
                                         P_SUCURSAL       IN NUMBER,
                                         P_MODULO         IN NUMBER,
                                         P_TRANSACCION    IN NUMBER,
                                         P_RELACION       IN NUMBER,
                                         P_CODIGO_CONTROL IN NUMBER,
                                         P_PROGRAMA       IN VARCHAR2);

   PROCEDURE SP_CR_OBTENER_CODIGO_CONTROL(P_NUMERO1        IN  NUMBER,
                                          P_PROGRAMA       IN  VARCHAR2,
                                          P_CODIGO_CONTROL OUT NUMBER);

   PROCEDURE SP_CR_GRABAR_LOG(P_EMPRESA                IN NUMBER,
                              P_SUCURSAL_TRANSACCION   IN NUMBER,
                              P_MODULO_TRANSACCION     IN NUMBER,
                              P_TRANSACCION            IN NUMBER,
                              P_RELACION_TRANSACCION   IN NUMBER,
                              P_ORDINAL_TRANSACCION    IN NUMBER,
                              P_SUBORDINAL_TRANSACCION IN NUMBER,
                              P_CANCEL_TRANSACCION     IN VARCHAR2,
                              P_USUARIO_REGISTRO       IN VARCHAR2,
                              P_PROGRAMA               IN VARCHAR2);

END PQ_CR_DESEMBOLSO_LINEAS_CANALES;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_DESEMBOLSO_LINEAS_CANALES IS

   PROCEDURE SP_CR_GRABAR_CODIGO_CONTROL(P_EMPRESA        IN NUMBER,
                                         P_SUCURSAL       IN NUMBER,
                                         P_MODULO         IN NUMBER,
                                         P_TRANSACCION    IN NUMBER,
                                         P_RELACION       IN NUMBER,
                                         P_CODIGO_CONTROL IN NUMBER,
                                         P_PROGRAMA       IN VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_GRABAR_CODIGO_CONTROL
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 17/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GRABA EL CODIGO DE CONTROL EN LAS TABLAS
   --                               FSD603 Y FSX015
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      EXISTE_FORMATO VARCHAR2(1);
      FECHA_SISTEMA  DATE;
   BEGIN
      BEGIN
         SELECT PGFAPE 
           INTO FECHA_SISTEMA 
           FROM FST017 
          WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT 'S'
           INTO EXISTE_FORMATO
           FROM FSD603
          WHERE PGCOD  = P_EMPRESA
            AND ITSUC  = P_SUCURSAL
            AND ITMOD  = P_MODULO
            AND ITTRAN = P_TRANSACCION
            AND ITNREL = P_RELACION;
      EXCEPTION
         WHEN OTHERS THEN
            EXISTE_FORMATO := 'N';
      END;
      IF EXISTE_FORMATO = 'N' THEN
         BEGIN
            INSERT INTO FSD603 (PGCOD, ITSUC, ITMOD, ITTRAN, ITNREL, PFDID, PFDDRE5)
            VALUES (P_EMPRESA, P_SUCURSAL, P_MODULO, P_TRANSACCION, P_RELACION, 0, P_CODIGO_CONTROL);
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         BEGIN
            INSERT INTO FSX015(PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, TXCOD, TXRENG, TXTEXT)
            VALUES (P_EMPRESA, P_MODULO, P_SUCURSAL, P_TRANSACCION, P_RELACION, FECHA_SISTEMA,
                    1, 1, P_PROGRAMA);
            
            INSERT INTO FSX015(PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, TXCOD, TXRENG, TXTEXT)
            VALUES (P_EMPRESA, P_MODULO, P_SUCURSAL, P_TRANSACCION, P_RELACION, FECHA_SISTEMA,
                    666, 666, TRIM(TO_CHAR(P_CODIGO_CONTROL)));
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      ELSE
         IF EXISTE_FORMATO = 'S' THEN
            BEGIN
               UPDATE FSD603
                  SET PFDDRE5 = P_CODIGO_CONTROL
                WHERE PGCOD  = P_EMPRESA
                  AND ITSUC  = P_SUCURSAL
                  AND ITMOD  = P_MODULO
                  AND ITTRAN = P_TRANSACCION
                  AND ITNREL = P_RELACION;
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            BEGIN
               INSERT INTO FSX015(PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, TXCOD, TXRENG, TXTEXT)
               VALUES (P_EMPRESA, P_MODULO, P_SUCURSAL, P_TRANSACCION, P_RELACION, FECHA_SISTEMA,
                       1, 1, P_PROGRAMA);
                       
               INSERT INTO FSX015(PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, TXCOD, TXRENG, TXTEXT)
               VALUES (P_EMPRESA, P_MODULO, P_SUCURSAL, P_TRANSACCION, P_RELACION, FECHA_SISTEMA,
                       666, 666, TRIM(TO_CHAR(P_CODIGO_CONTROL)));
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END IF;
      END IF;
   END SP_CR_GRABAR_CODIGO_CONTROL;

   PROCEDURE SP_CR_OBTENER_CODIGO_CONTROL(P_NUMERO1        IN NUMBER,
                                          P_PROGRAMA       IN VARCHAR2,
                                          P_CODIGO_CONTROL OUT NUMBER) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_CODIGO_CONTROL
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 17/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : OBTIENE EL CODIGO DE CONTROL
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
   BEGIN
      SELECT TP1NRO2
        INTO P_CODIGO_CONTROL
        FROM FST198
       WHERE TP1COD   = 1
         AND TP1COD1  = 111154
         AND TP1CORR1 = 1
         AND TP1CORR2 = 16
         AND TP1CORR3 > 0
         AND TP1NRO1  = P_NUMERO1
         AND TP1DESC  = RPAD(P_PROGRAMA, 30, ' ');
   EXCEPTION
      WHEN OTHERS THEN
         P_CODIGO_CONTROL := 0;
   END SP_CR_OBTENER_CODIGO_CONTROL;

   PROCEDURE SP_CR_GRABAR_LOG(P_EMPRESA                IN NUMBER,
                              P_SUCURSAL_TRANSACCION   IN NUMBER,
                              P_MODULO_TRANSACCION     IN NUMBER,
                              P_TRANSACCION            IN NUMBER,
                              P_RELACION_TRANSACCION   IN NUMBER,
                              P_ORDINAL_TRANSACCION    IN NUMBER,
                              P_SUBORDINAL_TRANSACCION IN NUMBER,
                              P_CANCEL_TRANSACCION     IN VARCHAR2,
                              P_USUARIO_REGISTRO       IN VARCHAR2,
                              P_PROGRAMA               IN VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_GRABAR_LOG
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 17/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GRABA EN LA TABLA LOG
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
         SELECT PGFAPE 
           INTO FECHA_SISTEMA 
           FROM FST017 
          WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         INSERT INTO AQPC753 (AQPC753COD, AQPC753ITSUC, AQPC753ITMOD, AQPC753ITTRAN, AQPC753ITNREL,
                              AQPC753ITORD, AQPC753ITSBOR, AQPC753PRGM, AQPC753CANCEL, AQPC753USER,
                              AQPC753FECHA, AQPC753HORA)
         VALUES (P_EMPRESA, P_SUCURSAL_TRANSACCION, P_MODULO_TRANSACCION, P_TRANSACCION, P_RELACION_TRANSACCION,
                 P_ORDINAL_TRANSACCION, P_SUBORDINAL_TRANSACCION, P_PROGRAMA, P_CANCEL_TRANSACCION, P_USUARIO_REGISTRO,
                 FECHA_SISTEMA, TO_CHAR(SYSDATE(), 'HH24:MI:SS'));
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_GRABAR_LOG;

END PQ_CR_DESEMBOLSO_LINEAS_CANALES;
/

