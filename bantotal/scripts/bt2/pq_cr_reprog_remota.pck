CREATE OR REPLACE PACKAGE PQ_CR_REPROG_REMOTA IS

   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_REPROG_REMOTA
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 31/07/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 20/09/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE MODIFICO EL PROCEDIMIENTO
   --                               - SP_CR_VALIDAR_DESMB_REMOTO
   -- *****************************************************************

/*==================================================================================================================*/
   PROCEDURE SP_CR_VALIDAR_DESMB_REMOTO(P_INSTANCIA IN  NUMBER,
                                        P_DIASVGN   OUT NUMBER);

/*==================================================================================================================*/   
   PROCEDURE SP_CR_GRABAR_AUTORIZACION(P_CORR_RPROG   IN NUMBER,
                                       P_INSTANCIA    IN NUMBER,
                                       P_PAIS_DOC     IN NUMBER,
                                       P_TIPO_DOC     IN NUMBER,
                                       P_NRO_DOC      IN VARCHAR2,
                                       P_EMPRESA      IN NUMBER,
                                       P_MODULO       IN NUMBER,
                                       P_SUCURSAL     IN NUMBER,
                                       P_MONEDA       IN NUMBER,
                                       P_PAPEL        IN NUMBER,
                                       P_CUENTA       IN NUMBER,
                                       P_OPERACION    IN NUMBER,
                                       P_SBOPERACION  IN NUMBER,
                                       P_TIPO_OPER    IN NUMBER,
                                       P_FECHA_RPROG  IN DATE,
                                       P_ESTADO_HABI  IN VARCHAR2,
                                       P_TIPO_RPROG   IN VARCHAR2,
                                       P_ESTADO_RPROG IN VARCHAR2,
                                       P_DIAS_VIGNT   IN NUMBER,
                                       P_COD_USUARIO  IN VARCHAR2);

END PQ_CR_REPROG_REMOTA;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_REPROG_REMOTA IS

/*==================================================================================================================*/
   PROCEDURE SP_CR_VALIDAR_DESMB_REMOTO(P_INSTANCIA IN  NUMBER,
                                        P_DIASVGN   OUT NUMBER) IS
                                        
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_DESMB_REMOTO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 31/07/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDA SI EL CLIENTE REALIZO LA AUTORIZACION REMOTA
   -- PARAMETROS                  : P_INSTANCIA | NUMBER(10)
   --                               P_DIASVGN   | NUMBER(5)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 20/09/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE REALIZO EL AJUSTE QUE CALCULA
   --                               LOS DIAS VIGENTES
   --
   -- *****************************************************************
      V_FECHASIS DATE      := NULL;
      V_DIASVGN  NUMBER(5) := 0;                   
   BEGIN      
      BEGIN 
         SELECT A1.PGFAPE
           INTO V_FECHASIS
           FROM FST017 A1
          WHERE A1.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
      	  NULL;
      END;
      
      BEGIN
         SELECT CASE
                  WHEN (V_FECHASIS - A1.AQPC794FHREG) > A1.AQPC794DVIG THEN
                     0
                  ELSE
                     A1.AQPC794DVIG - (V_FECHASIS - A1.AQPC794FHREG)
                END CASE
           INTO V_DIASVGN
           FROM AQPC794 A1
          WHERE A1.AQPC794INST  = P_INSTANCIA
            AND A1.AQPC794DRMT  = 'V'
            AND A1.AQPC794FHREG = (SELECT MAX(A2.AQPC794FHREG)
                                     FROM AQPC794 A2
                                    WHERE A2.AQPC794INST  = P_INSTANCIA
                                      AND A2.AQPC794DRMT  = 'V');
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_DIASVGN := V_DIASVGN;
      
   END SP_CR_VALIDAR_DESMB_REMOTO;
   
/*==================================================================================================================*/
   PROCEDURE SP_CR_GRABAR_AUTORIZACION(P_CORR_RPROG   IN NUMBER,
                                       P_INSTANCIA    IN NUMBER,
                                       P_PAIS_DOC     IN NUMBER,
                                       P_TIPO_DOC     IN NUMBER,
                                       P_NRO_DOC      IN VARCHAR2,
                                       P_EMPRESA      IN NUMBER,
                                       P_MODULO       IN NUMBER,
                                       P_SUCURSAL     IN NUMBER,
                                       P_MONEDA       IN NUMBER,
                                       P_PAPEL        IN NUMBER,
                                       P_CUENTA       IN NUMBER,
                                       P_OPERACION    IN NUMBER,
                                       P_SBOPERACION  IN NUMBER,
                                       P_TIPO_OPER    IN NUMBER,
                                       P_FECHA_RPROG  IN DATE,
                                       P_ESTADO_HABI  IN VARCHAR2,
                                       P_TIPO_RPROG   IN VARCHAR2,
                                       P_ESTADO_RPROG IN VARCHAR2,
                                       P_DIAS_VIGNT   IN NUMBER,
                                       P_COD_USUARIO  IN VARCHAR2) IS
  
   -- **************************************************************************************************
   -- NOMBRE                      : SP_CR_GRABAR_AUTORIZACION
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 31/07/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GRABAR LA AUTORIZACION REMOTA
   -- PARAMETROS                  : - CORRELATIVO REPROGRAMACIÓN: P_CORR_RPROG   | NUMBER(10)
   --                               - P_INSTANCIA    : NUMBER(10)
   --                               - P_PAIS_DOC     : NUMBER(3)
   --                               - P_TIPO_DOC     : NUMBER(2)
   --                               - P_NRO_DOC      : VARCHAR2(12)
   --                               - P_EMPRESA      : NUMBER(3)
   --                               - P_MODULO       : NUMBER(3)
   --                               - P_SUCURSAL     : NUMBER(3)
   --                               - P_MONEDA       : NUMBER(4)
   --                               - P_PAPEL        : NUMBER(4)
   --                               - P_CUENTA       : NUMBER(9)
   --                               - P_OPERACION    : NUMBER(9)
   --                               - P_SBOPERACION  : NUMBER(3)
   --                               - P_TIPO_OPER    : NUMBER(3)
   --                               - P_FECHA_RPROG  : DATE
   --                               - P_ESTADO_HABI  : VARCHAR2(1)
   --                               - P_TIPO_RPROG   : NUMBER(4)
   --                               - P_ESTADO_RPROG : VARCHAR2(1)
   --                               - P_DIAS_VIGNT   : NUMBER(5)
   --                               - P_COD_USUARIO  : VARCHAR2(10)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   -----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- **************************************************************************************************
   
      FECHA_SISTEMA DATE;
      CORRELATIVO   NUMBER(17);                          
   BEGIN
      BEGIN
         UPDATE AQPC794 A1
            SET A1.AQPC794DRMT = 'H'
           WHERE A1.AQPC794INST  = P_INSTANCIA
             AND A1.AQPC794DRMT  = 'V'
             AND A1.AQPC794FHREG = (SELECT MAX(A2.AQPC794FHREG)
                                      FROM AQPC794 A2
                                     WHERE A2.AQPC794INST  = P_INSTANCIA
                                       AND A2.AQPC794DRMT  = 'V');
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
          WHERE A1.PGCOD  = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         SELECT NVL(MAX(A1.AQPC794CORR), 0) + 1
           INTO CORRELATIVO
           FROM AQPC794 A1
          WHERE A1.AQPC794INST  = P_INSTANCIA
            AND A1.AQPC794FHREG = FECHA_SISTEMA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
         
      BEGIN
         INSERT INTO AQPC794
            (AQPC794CORR,
             AQPC794USREG,
             AQPC794FHREG,
             AQPC794HOREG,
             AQPC794CRPG,
             AQPC794INST,
             AQPC794PAIS,
             AQPC794TDOC,
             AQPC794NDOC,
             AQPC794EMP,
             AQPC794MOD,
             AQPC794SUC,
             AQPC794MDA,
             AQPC794PAP,
             AQPC794CTA,
             AQPC794OPER,
             AQPC794SBOP,
             AQPC794TOP,
             AQPC794FHRPG,
             AQPC794EHAB,
             AQPC794ERPG,
             AQPC794TRPG,
             AQPC794DRMT,
             AQPC794FHVIG,
             AQPC794DVIG)
         VALUES
            (CORRELATIVO,
             P_COD_USUARIO,
             FECHA_SISTEMA,
             TO_CHAR(SYSDATE, 'HH24:MI:SS'),
             P_CORR_RPROG,
             P_INSTANCIA,
             P_PAIS_DOC,
             P_TIPO_DOC,
             P_NRO_DOC,
             P_EMPRESA,
             P_MODULO,
             P_SUCURSAL,
             P_MONEDA,
             P_PAPEL,
             P_CUENTA,
             P_OPERACION,
             P_SBOPERACION,
             P_TIPO_OPER,
             P_FECHA_RPROG,
             P_ESTADO_HABI,
             P_ESTADO_RPROG,
             P_TIPO_RPROG,
             'V',
             (FECHA_SISTEMA + P_DIAS_VIGNT),
             P_DIAS_VIGNT);
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_GRABAR_AUTORIZACION;

END PQ_CR_REPROG_REMOTA;
/

