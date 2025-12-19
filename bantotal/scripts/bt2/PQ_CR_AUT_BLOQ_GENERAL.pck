create or replace package PQ_CR_AUT_BLOQ_GENERAL is
  
  -- ====================================================================================================
  -- NOMBRE                      : PQ_CR_AUT_BLOQ_GENERAL
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 09/11/2025
  -- AUTOR DE CREACION           : HENRY SUAREZ
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================  

  
  -- Public type declarations
  PROCEDURE SP_ENVIO_CORREO_BOT(VE_CORR_AUT_REPRO NUMBER,
                                VE_AQPC565IDCPE   NUMBER, --CODIGO ASIGNADO PARA LA BLQOUEANTE RELACION AQPC566
                                VE_INSTANCIA      NUMBER,
                                VE_USUARIOING     VARCHAR2,
                                VE_ASUNTO         VARCHAR2,
                                VE_ASUNTO_BOT     VARCHAR2,
                                VE_MENSAJE        VARCHAR2,
                                VE_CORRPARA       VARCHAR2,
                                VE_CORRDE         VARCHAR2,
                                VO_COD_ERROR      OUT VARCHAR2,
                                VO_MSG_ERROR      OUT VARCHAR2);

  PROCEDURE SP_INSERT_AQPC565(VE_CORR_AUT_PRG     NUMBER, --ESTE CORRELATIVO ES PROPIO DE LA TABLA QUE ESTEN USANDO.
                              VE_INSTANCIA        NUMBER,
                              VE_USUARIOING       VARCHAR2,
                              VE_AQPC565IDCPE     NUMBER,
                              VE_ASUNTO           VARCHAR2,
                              VE_ASUNTO_BOT       VARCHAR2,
                              VE_MENSAJE          VARCHAR2,
                              VE_CORRPARA         VARCHAR2,
                              VE_CORRDE           VARCHAR2,
                              VO_CORRELATIVO      OUT NUMBER,
                              VO_COD_ERROR        OUT VARCHAR2,
                              VO_MSG_ERROR        OUT VARCHAR2);

  PROCEDURE SP_CR_EXCEPCIONAR_BLQ(VE_CORR       IN NUMBER,
                                  VE_USUARIO    IN VARCHAR,
                                  VE_COMENT     IN VARCHAR,
                                  VE_EST        IN VARCHAR,                                  
                                  VE_INST       IN NUMBER);
                                  
  PROCEDURE SP_CR_AGREGA_AQPC565VAR(VE_CORRELATIVOE IN NUMBER,
                                    VE_INSTANCIA    IN NUMBER,
                                    VO_AQPC565VAR   OUT VARCHAR2,
                                    VO_COD_ERROR    OUT VARCHAR2,
                                    VO_MSG_ERROR    OUT VARCHAR2);
end PQ_CR_AUT_BLOQ_GENERAL;
/
create or replace package body PQ_CR_AUT_BLOQ_GENERAL is

  PROCEDURE SP_ENVIO_CORREO_BOT(VE_CORR_AUT_REPRO NUMBER,
                                VE_AQPC565IDCPE   NUMBER, --CODIGO ASIGNADO PARA LA BLQOUEANTE RELACION AQPC566
                                VE_INSTANCIA      NUMBER,
                                VE_USUARIOING     VARCHAR2,
                                VE_ASUNTO         VARCHAR2,
                                VE_ASUNTO_BOT     VARCHAR2,
                                VE_MENSAJE        VARCHAR2,
                                VE_CORRPARA       VARCHAR2,
                                VE_CORRDE         VARCHAR2,
                                VO_COD_ERROR      OUT VARCHAR2,
                                VO_MSG_ERROR      OUT VARCHAR2) IS
                                
  -- ====================================================================================================
  -- NOMBRE                      : SP_ENVIO_CORREO_BOT
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 09/11/2025
  -- AUTOR DE CREACION           : HENRY SUAREZ
  -- USO                         : ENVIAR CORREO BOT
  -- PARAMETROS                  : - VE_CORR_AUT_REPRO
  --                               - VE_AQPC565IDCPE
  --                               - VE_INSTANCIA
  --                               - VE_USUARIOING
  --                               - VE_ASUNTO
  --                               - VE_ASUNTO_BOT
  --                               - VE_MENSAJE
  --                               - VE_CORRPARA
  --                               - VE_CORRDE
  --                               - VO_COD_ERROR
  --                               - VO_MSG_ERROR
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
                                
    VIO_AQPC565CORR  NUMBER(12);
    VIO_AQPC565CORR2 NUMBER(12);
    VIO_COERR        NUMBER(5);
    VIO_MSGGERR      VARCHAR2(100);
    VIO_CORRELATIVO  NUMBER(12);
  BEGIN
    
  
    BEGIN
      PQ_CR_AUT_BLOQ_GENERAL.SP_INSERT_AQPC565(VE_CORR_AUT_REPRO,
                                               VE_INSTANCIA,
                                               VE_USUARIOING,
                                               VE_AQPC565IDCPE,
                                               VE_ASUNTO,
                                               VE_ASUNTO_BOT,
                                               VE_MENSAJE,
                                               VE_CORRPARA,
                                               VE_CORRDE,
                                               VIO_CORRELATIVO,
                                               VO_COD_ERROR,
                                               VO_MSG_ERROR);
    
    END;
  
    BEGIN
      PQ_CR_PROCESOS_BOT.sp_cr_devolver_corr_exte(VE_AQPC565IDCPE,
                                                  VE_INSTANCIA,
                                                  VIO_AQPC565CORR,
                                                  VIO_AQPC565CORR2,
                                                  VIO_COERR,
                                                  VIO_MSGGERR);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    VIO_COERR := NVL(VIO_COERR, 0);
  
    --llamar al proceso q ejeucta el bot
    IF VIO_COERR = 0 THEN
      BEGIN
        PQ_CR_PROCESAR_BOT.SP_ENVIAR_MAIL_BOT(VE_CORR_AUT_REPRO,
                                              0,
                                              VE_AQPC565IDCPE,
                                              VIO_AQPC565CORR2,
                                              VE_INSTANCIA,
                                              0,
                                              '',
                                              VIO_COERR,
                                              VIO_MSGGERR);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END;

  PROCEDURE SP_INSERT_AQPC565(VE_CORR_AUT_PRG     NUMBER, --ESTE CORRELATIVO ES PROPIO DE LA TABLA QUE ESTEN USANDO.
                              VE_INSTANCIA        NUMBER,
                              VE_USUARIOING       VARCHAR2,
                              VE_AQPC565IDCPE     NUMBER,
                              VE_ASUNTO           VARCHAR2,
                              VE_ASUNTO_BOT       VARCHAR2,
                              VE_MENSAJE          VARCHAR2,
                              VE_CORRPARA         VARCHAR2,
                              VE_CORRDE           VARCHAR2,
                              VO_CORRELATIVO      OUT NUMBER,
                              VO_COD_ERROR        OUT VARCHAR2,
                              VO_MSG_ERROR        OUT VARCHAR2) IS
                              
  -- ====================================================================================================
  -- NOMBRE                      : SP_INSERT_AQPC565
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 09/11/2025
  -- AUTOR DE CREACION           : HENRY SUAREZ
  -- USO                         : GRABAR LAS APROBACIONES DEL CORREO BOT
  -- PARAMETROS                  : - VE_CORR_AUT_REPRO
  --                               - VE_INSTANCIA
  --                               - VE_USUARIOING
  --                               - VE_AQPC565IDCPE
  --                               - VE_ASUNTO
  --                               - VE_ASUNTO_BOT
  --                               - VE_MENSAJE
  --                               - VE_CORRPARA
  --                               - VE_CORRDE
  --                               - VO_CORRELATIVO
  --                               - VO_COD_ERROR
  --                               - VO_MSG_ERROR
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
                              
    VI_EMP  xwf700.xwfempresa%type;
    VI_SUC  xwf700.xwfsucursal%type;
    VI_MOD  xwf700.xwfmodulo%type;
    VI_MDA  xwf700.xwfmoneda%type;
    VI_PAP  xwf700.xwfpapel%type;
    VI_CTA  xwf700.xwfcuenta%type;
    VI_OPE  xwf700.xwfoperacion%type;
    VI_SBOP xwf700.xwfsubope%type;
    VI_TOPE xwf700.xwftipope%type;
  
    VIO_AQPC565VAR   VARCHAR2(3000);
    VIO_COD_ERROR     VARCHAR2(10);
    VIO_MSG_ERROR     VARCHAR2(100);
    
  BEGIN     
    BEGIN
      PQ_CR_AUT_BLOQ_GENERAL.SP_CR_AGREGA_AQPC565VAR(VE_CORR_AUT_PRG,
                                                     VE_INSTANCIA,
                                                     VIO_AQPC565VAR,
                                                     VIO_COD_ERROR,
                                                     VIO_MSG_ERROR);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFSUCURSAL,
             X.XWFMODULO,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE
        INTO VI_EMP,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBOP,
             VI_TOPE
        FROM XWF700 X
       WHERE XWFPRCINS = VE_INSTANCIA
         AND XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      INSERT INTO AQPC565
        (AQPC565PARA,
         AQPC565DE,
         AQPC565IDCPE,
         AQPC565ASNT,
         AQPC565CRPO,
         AQPC565ASBOT,
         AQPC565CBOT1,
         AQPC565GSTN,
         
         AQPC565F_REG,
         AQPC565H_REG,
         AQPC565U_REG,
         
         AQPC565VAR,
         
         Aqpc565inst,
         AQPC565EMP,
         AQPC565SUC,
         AQPC565MOD,
         AQPC565MND,
         AQPC565PAP,
         AQPC565CTA,
         AQPC565OPE,
         AQPC565SOPE,
         AQPC565TOPE,
         AQPC565EST
         
         )
      VALUES
        (
         
         VE_CORRPARA,
         VE_CORRDE,
         VE_AQPC565IDCPE, -- DIFINIDO EN AQPC566
         VE_ASUNTO,
         VE_MENSAJE,
         VE_ASUNTO_BOT,
         '',
         1, -- INDICA Q NECESITA APROB O RECHAZ
         
         TO_DATE(SYSDATE, 'dd/mm/rrrr'),
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         VE_USUARIOING,
         
         VIO_AQPC565VAR,
         
         VE_INSTANCIA,
         VI_EMP,
         VI_SUC,
         VI_MOD,
         VI_MDA,
         VI_PAP,
         VI_CTA,
         VI_OPE,
         VI_SBOP,
         VI_TOPE,
         'P'         
         )
         RETURNING  AQPC565CORR INTO  VO_CORRELATIVO;
         
         
      COMMIT;
    
      /* EXCEPTION
      WHEN OTHERS THEN
        NULL; */
    END;
  END;
  PROCEDURE SP_CR_EXCEPCIONAR_BLQ(VE_CORR       IN NUMBER,
                                  VE_USUARIO    IN VARCHAR,
                                  VE_COMENT     IN VARCHAR,
                                  VE_EST        IN VARCHAR,                                  
                                  VE_INST       IN NUMBER) IS
                                  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_EXCEPCIONAR_BLQ
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 09/11/2025
  -- AUTOR DE CREACION           : HENRY SUAREZ
  -- USO                         : EXCEPCIONAR BLOQUEANTE
  -- PARAMETROS                  : - VE_CORR
  --                               - VE_USUARIO
  --                               - VE_COMENT
  --                               - VE_EST
  --                               - VE_INST
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
                                  
    VI_COD_ERROR VARCHAR2(4) := '';
    VI_MSG_ERROR VARCHAR2(150) := '';
    USUARIO      VARCHAR2(30) := '';
    ESTADO       VARCHAR2(1) := '';
  BEGIN 
    
    --EXTRAE LA INICIAL DEL ESTADO SELECCIONADO DEL CLIENTE
    BEGIN
      ESTADO := SUBSTR(VE_EST, 1, 1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      /*
      PQ_CR_REPROG_SIN_CAP.SP_GRABAR_APROBACION(VE_FECHAREG  => VE_FEC_REPROG,
                                                VE_CODREPROG => VE_COD_REPROG,
                                                VE_INSTANCIA => VE_INST,
                                                --
                                                VE_UBUSER     => USUARIO,
                                                VE_COMENTARIO => VE_COMENT,
                                                VE_ESTADO     => ESTADO,
                                                --
                                                VO_CODERROR => VI_COD_ERROR,
                                                VO_MSGERROR => VI_MSG_ERROR);
                                                */
                                                NULL;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;  
  END SP_CR_EXCEPCIONAR_BLQ;
  
  PROCEDURE SP_CR_AGREGA_AQPC565VAR(VE_CORRELATIVOE IN NUMBER,
                                    VE_INSTANCIA    IN NUMBER,
                                    VO_AQPC565VAR   OUT VARCHAR2,
                                    VO_COD_ERROR    OUT VARCHAR2,
                                    VO_MSG_ERROR    OUT VARCHAR2) IS
                                    
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_AGREGA_AQPC565VAR
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 09/11/2025
  -- AUTOR DE CREACION           : HENRY SUAREZ
  -- USO                         : AGREGAR VARIABLE AQPC565
  -- PARAMETROS                  : - VE_CORRELATIVOE
  --                               - VE_INSTANCIA
  --                               - VO_AQPC565VAR
  --                               - VO_COD_ERROR
  --                               - VO_MSG_ERROR
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
                                    
  BEGIN
    --AQUI DEFINIR UNA TABLA PARA COLOCAR EL PROCESO A EJECUTAR QUE DEVUELVA LA VARIABLE CONCATENADA, DEJO PENDIENTE.
    
    NULL;
  END;
end PQ_CR_AUT_BLOQ_GENERAL;
/
