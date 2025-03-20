CREATE OR REPLACE PACKAGE PQ_CR_RECATEGORIZACION_CAPTACION IS

   PROCEDURE SP_CR_DATOS_CAPTACION(P_CUENTA                  IN NUMBER,
                                   P_OPERACION               IN NUMBER,
                                   P_MONEDA                  IN NUMBER,
                                   P_SUCURSAL                IN NUMBER,
                                   P_FECHA_PROCESO           IN DATE,
                                   P_FECHA_CONTABLE          IN DATE,
                                   O_CLIENTE_INACTIVO        OUT VARCHAR2,
                                   O_ORIGEN_CAPTACION        OUT NUMBER,
                                   O_NOMBRE_ORIGEN_CAPTACION OUT VARCHAR2,
                                   O_USUARIO_CAPTACION       OUT VARCHAR2);
 
END PQ_CR_RECATEGORIZACION_CAPTACION;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_RECATEGORIZACION_CAPTACION IS

   PROCEDURE SP_CR_DATOS_CAPTACION(P_CUENTA                  IN NUMBER,
                                   P_OPERACION               IN NUMBER,
                                   P_MONEDA                  IN NUMBER,
                                   P_SUCURSAL                IN NUMBER,
                                   P_FECHA_PROCESO           IN DATE,
                                   P_FECHA_CONTABLE          IN DATE,
                                   O_CLIENTE_INACTIVO        OUT VARCHAR2,
                                   O_ORIGEN_CAPTACION        OUT NUMBER,
                                   O_NOMBRE_ORIGEN_CAPTACION OUT VARCHAR2,
                                   O_USUARIO_CAPTACION       OUT VARCHAR2) IS
                                   
      V_CREDITOS_VIGENTES       NUMBER(10);
      V_ORIGEN_CAPTACION        NUMBER(4);
      V_USUARIO_CAPTACION       VARCHAR2(10);
      V_NOMBRE_ORIGEN_CAPTACION VARCHAR2(30);

   BEGIN
      BEGIN
         SELECT COUNT(*)
           INTO V_CREDITOS_VIGENTES
           FROM FSD010
          WHERE PGCOD = 1
            AND AOCTA IN
                (SELECT DISTINCT CTNRO
                   FROM FSR008
                  WHERE PENDOC IN
                        (SELECT PENDOC FROM FSR008 WHERE CTNRO = P_CUENTA))
            AND AOMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
            AND AOSTAT <> 99
            AND AOFVAL < P_FECHA_CONTABLE;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      IF V_CREDITOS_VIGENTES > 0 THEN
         O_CLIENTE_INACTIVO := 'N';
      ELSE
         O_CLIENTE_INACTIVO := 'S';
      END IF;
      BEGIN
         SELECT B.SNG015COD, B.SNG001USC
           INTO V_ORIGEN_CAPTACION, V_USUARIO_CAPTACION
           FROM XWF700 A, SNG001 B
          WHERE A.XWFEMPRESA   = 1
            AND A.XWFSUCURSAL  = P_SUCURSAL
            AND A.XWFMONEDA    = P_MONEDA
            AND A.XWFCUENTA    = P_CUENTA
            AND A.XWFOPERACION = P_OPERACION
            AND A.XWFCAR3      = '1'
            AND A.XWFPRCINS    = B.SNG001INST;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT TRIM(SNG015DSC)
           INTO V_NOMBRE_ORIGEN_CAPTACION
           FROM SNG015
          WHERE SNG015COD = V_ORIGEN_CAPTACION;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      O_ORIGEN_CAPTACION        := V_ORIGEN_CAPTACION;
      O_NOMBRE_ORIGEN_CAPTACION := V_NOMBRE_ORIGEN_CAPTACION;
      O_USUARIO_CAPTACION       := V_USUARIO_CAPTACION; 
   END SP_CR_DATOS_CAPTACION;
      
END PQ_CR_RECATEGORIZACION_CAPTACION;
/

