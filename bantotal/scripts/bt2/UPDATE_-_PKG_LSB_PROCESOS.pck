CREATE OR REPLACE PACKAGE PKG_LSB_PROCESOS AS
  TYPE T_REF_CURSOR IS REF CURSOR;

 PROCEDURE UP_SECRETO_COINCIDENCIAS_INS
 (
  ARGFLAG               NUMBER,
  ARGIDSECRETO          NUMBER,
  ARGTIPO_DOCUMENTO     NUMBER,
  ARGNUMERO_DOCUMENTO   VARCHAR2,
  ARGAPELLIDO_PATERNO   VARCHAR2,
  ARGAPELLIDO_MATERNO   VARCHAR2,
  ARGNOMBRES            VARCHAR2,
  ARGFECHA_PROCESO      VARCHAR2,
  ARGUSUARIO            VARCHAR2,
  OUTVAL  OUT           NUMBER
 );

 PROCEDURE UP_SECRETO_COINCIDENCIAS_SEL
 (
  ARGFLAG               NUMBER,
  ARGIDSECRETO          NUMBER,
  ARGTIPO_DOCUMENTO     NUMBER,
  ARGNUMERO_DOCUMENTO   VARCHAR2,
  ARGAPELLIDO_PATERNO   VARCHAR2,
  ARGAPELLIDO_MATERNO   VARCHAR2,
  ARGNOMBRES            VARCHAR2,
  ARGFECHA_PROCESO      VARCHAR2,
  ARGUSUARIO            VARCHAR2,
  OUTVAL OUT            NUMBER,
  O_RESULT_CURSOR       OUT T_REF_CURSOR
 );

 PROCEDURE UP_SECRETO_COINCIDENCIAS_UPD
 (
  ARGFLAG             NUMBER,
  ARGIDSECRETO        NUMBER,
  ARGTIPO_DOCUMENTO   NUMBER,
  ARGNUMERO_DOCUMENTO VARCHAR2,
  ARGAPELLIDO_PATERNO VARCHAR2,
  ARGAPELLIDO_MATERNO VARCHAR2,
  ARGNOMBRES          VARCHAR2,
  ARGFECHA_PROCESO    VARCHAR2,
  ARGUSUARIO          VARCHAR2,
  OUTVAL OUT          NUMBER
 );

 PROCEDURE UP_SECRETO_SEL
  (argFLAG                      NUMBER,
   argCODIGO                    NUMBER,
   argSECUENCIAOFI              NUMBER,
   argSECUENCIAPRO              NUMBER,
   argENTIDAD                   NUMBER,
   argENTIDADNOMBRE             VARCHAR2,  --
   argENTIDAD_EJECUTOR          VARCHAR2,
   argENTIDAD_EJECUTOR_CARGO    VARCHAR2,
   argINFO_ADICIONAL            VARCHAR2,
   argINFO_REQUERIDA            VARCHAR2,
   argPLAZO_ATENCION            VARCHAR2,
   argOFICIO_SBS                VARCHAR2,
   argNUMERO                    VARCHAR2,
   argOFICIO                    VARCHAR2,
   argAPE_PAT                   VARCHAR2,
   argAPE_MAT                   VARCHAR2,
   argNOMBRES                   VARCHAR2,
   argPROCESADO                 VARCHAR2,
   argTIPO_DOCUMENTO            NUMBER,
   argNUMERO_DOCUMENTO          VARCHAR2,
   argTIPO_PERSONA              VARCHAR2,
   argNUMERO_CUENTA             VARCHAR2,
   argCLIENTE                   NUMBER,
   argCARTA                     NUMBER,
   argHOMONIMIA                 NUMBER,
   argINCOMPLETO                NUMBER,
   argFLAG_SALDO                NUMBER,
   argESTADO                    NUMBER,
   argUSUARIO_REGISTRO          VARCHAR2,
   argFECHA_DESDE               VARCHAR2,
   argFECHA_HASTA               VARCHAR2,
   argFECHA_SECRETO             VARCHAR2,
   argFECHA_RESPUESTA           VARCHAR2,
   argUSUARIO_RESPUESTA         VARCHAR2,
   argFECHA_RECEPCION           VARCHAR2,
   argNRO_CARTA_INF             VARCHAR2,
   argNRO_CARTA_TIP             NUMBER,
   argCOD_CLIENTE               VARCHAR2,
   argFECHA_ING_ENTIDAD         VARCHAR2,
   argPRODUCTO                  VARCHAR2,
   argNRO_CARTA_DESDE           VARCHAR2,
   argNRO_CARTA_HASTA           VARCHAR2,
   argFECHA_DESPACHO            VARCHAR2,
   argFECHA_ENTREGA             VARCHAR2,
   argMOTIV_RECHZO              NUMBER,
   argSECUENCIA_CARGA           VARCHAR2,
   argPROC_FECHA                VARCHAR2,
   argPROC_HORA                 VARCHAR2,
   argPROC_USUARIO              VARCHAR2,
   argCORRELATIVO               VARCHAR2,
   argTIPODOI_SECBAN            VARCHAR2,
   argDELITOMATERIA_SECBAN      VARCHAR2,
   argNROENVIO_SECBAN           VARCHAR2,
   argNROEXPEDIENTE_SECBAN      VARCHAR2,
   argDIRECAUTORIDAD_SECBAN     VARCHAR2,
   argSECRETARIO_SECBAN         VARCHAR2,
   argOTRAINFO_SECBAN           VARCHAR2,
   argPRIORIDADALTA_SECBAN      VARCHAR2,
   argPERIODOCONS_SECBAN        VARCHAR2,
   argPAIS_SECBAN               VARCHAR2,
   argORIGEN                    NUMBER,
   argFLAG_IMPRESO              NUMBER,
   argPRE_CARTA                 NUMBER,
   argOBSERVACION               VARCHAR2,
   argCARTA_ARCHIVO             VARCHAR2,
   argPRE_PROCESO               NUMBER,
   argTIPO_SOLICITUD            VARCHAR2,
   argDOCUM_NOTIFICA            VARCHAR2,
   argCOD_DELITO                NUMBER,
   argMSG_PROC                  VARCHAR2,
   argTIPO_BUSQUEDA             VARCHAR2,
   argTIPO_RESPUESTA            NUMBER,
   argMAIL_TO                   VARCHAR2,
   argIND_ESTADO_MAIL           NUMBER,
   argFCHA_CORREO               VARCHAR2,
   --
   OUTVAL                       OUT NUMBER,
   O_RESULT_CURSOR              OUT T_REF_CURSOR
 );

 PROCEDURE UP_SECRETO_DEL
  (argFLAG                      NUMBER,
   argCODIGO                    NUMBER,
   argSECUENCIAOFI              NUMBER,
   argSECUENCIAPRO              NUMBER,
   argENTIDAD                   NUMBER,
   argENTIDADNOMBRE             VARCHAR2,  --
   argENTIDAD_EJECUTOR          VARCHAR2,
   argENTIDAD_EJECUTOR_CARGO    VARCHAR2,
   argINFO_ADICIONAL            VARCHAR2,
   argINFO_REQUERIDA            VARCHAR2,
   argPLAZO_ATENCION            VARCHAR2,
   argOFICIO_SBS                VARCHAR2,
   argNUMERO                    VARCHAR2,
   argOFICIO                    VARCHAR2,
   argAPE_PAT                   VARCHAR2,
   argAPE_MAT                   VARCHAR2,
   argNOMBRES                   VARCHAR2,
   argPROCESADO                 VARCHAR2,
   argTIPO_DOCUMENTO            NUMBER,
   argNUMERO_DOCUMENTO          VARCHAR2,
   argTIPO_PERSONA              VARCHAR2,
   argNUMERO_CUENTA             VARCHAR2,
   argCLIENTE                   NUMBER,
   argCARTA                     NUMBER,
   argHOMONIMIA                 NUMBER,
   argINCOMPLETO                NUMBER,
   argFLAG_SALDO                NUMBER,
   argESTADO                    NUMBER,
   argUSUARIO_REGISTRO          VARCHAR2,
   argFECHA_DESDE               VARCHAR2,
   argFECHA_HASTA               VARCHAR2,
   argFECHA_SECRETO             VARCHAR2,
   argFECHA_RESPUESTA           VARCHAR2,
   argUSUARIO_RESPUESTA         VARCHAR2,
   argFECHA_RECEPCION           VARCHAR2,
   argNRO_CARTA_INF             VARCHAR2,
   argNRO_CARTA_TIP             NUMBER,
   argCOD_CLIENTE               VARCHAR2,
   argFECHA_ING_ENTIDAD         VARCHAR2,
   argPRODUCTO                  VARCHAR2,
   argNRO_CARTA_DESDE           VARCHAR2,
   argNRO_CARTA_HASTA           VARCHAR2,
   argFECHA_DESPACHO            VARCHAR2,
   argFECHA_ENTREGA             VARCHAR2,
   argMOTIV_RECHZO              NUMBER,
   argSECUENCIA_CARGA           VARCHAR2,
   argPROC_FECHA                VARCHAR2,
   argPROC_HORA                 VARCHAR2,
   argPROC_USUARIO              VARCHAR2,
   argCORRELATIVO               VARCHAR2,
   argTIPODOI_SECBAN            VARCHAR2,
   argDELITOMATERIA_SECBAN      VARCHAR2,
   argNROENVIO_SECBAN           VARCHAR2,
   argNROEXPEDIENTE_SECBAN      VARCHAR2,
   argDIRECAUTORIDAD_SECBAN     VARCHAR2,
   argSECRETARIO_SECBAN         VARCHAR2,
   argOTRAINFO_SECBAN           VARCHAR2,
   argPRIORIDADALTA_SECBAN      VARCHAR2,
   argPERIODOCONS_SECBAN        VARCHAR2,
   argPAIS_SECBAN               VARCHAR2,
   argORIGEN                    NUMBER,
   argFLAG_IMPRESO              NUMBER,
   argPRE_CARTA                 NUMBER,
   argOBSERVACION               VARCHAR2,
   argCARTA_ARCHIVO             VARCHAR2,
   argPRE_PROCESO               NUMBER,
   argTIPO_SOLICITUD            VARCHAR2,
   argDOCUM_NOTIFICA            VARCHAR2,
   argCOD_DELITO                NUMBER,
   argMSG_PROC                  VARCHAR2,
   argTIPO_BUSQUEDA             VARCHAR2,
   argTIPO_RESPUESTA            NUMBER,
   argMAIL_TO                   VARCHAR2,
   argIND_ESTADO_MAIL           NUMBER,
   argFCHA_CORREO               VARCHAR2,
   --
   OUTVAL                       OUT NUMBER,
   outCODIGO                    OUT NUMBER
  );

 PROCEDURE UP_SECRETO_UPD
  (argFLAG                      NUMBER,
   argCODIGO                    NUMBER,
   argSECUENCIAOFI              NUMBER,
   argSECUENCIAPRO              NUMBER,
   argENTIDAD                   NUMBER,
   argENTIDADNOMBRE             VARCHAR2,  --
   argENTIDAD_EJECUTOR          VARCHAR2,
   argENTIDAD_EJECUTOR_CARGO    VARCHAR2,
   argINFO_ADICIONAL            VARCHAR2,
   argINFO_REQUERIDA            VARCHAR2,
   argPLAZO_ATENCION            VARCHAR2,
   argOFICIO_SBS                VARCHAR2,
   argNUMERO                    VARCHAR2,
   argOFICIO                    VARCHAR2,
   argAPE_PAT                   VARCHAR2,
   argAPE_MAT                   VARCHAR2,
   argNOMBRES                   VARCHAR2,
   argPROCESADO                 VARCHAR2,
   argTIPO_DOCUMENTO            NUMBER,
   argNUMERO_DOCUMENTO          VARCHAR2,
   argTIPO_PERSONA              VARCHAR2,
   argNUMERO_CUENTA             VARCHAR2,
   argCLIENTE                   NUMBER,
   argCARTA                     NUMBER,
   argHOMONIMIA                 NUMBER,
   argINCOMPLETO                NUMBER,
   argFLAG_SALDO                NUMBER,
   argESTADO                    NUMBER,
   argUSUARIO_REGISTRO          VARCHAR2,
   argFECHA_DESDE               VARCHAR2,
   argFECHA_HASTA               VARCHAR2,
   argFECHA_SECRETO             VARCHAR2,
   argFECHA_RESPUESTA           VARCHAR2,
   argUSUARIO_RESPUESTA         VARCHAR2,
   argFECHA_RECEPCION           VARCHAR2,
   argNRO_CARTA_INF             VARCHAR2,
   argNRO_CARTA_TIP             NUMBER,
   argCOD_CLIENTE               VARCHAR2,
   argFECHA_ING_ENTIDAD         VARCHAR2,
   argPRODUCTO                  VARCHAR2,
   argNRO_CARTA_DESDE           VARCHAR2,
   argNRO_CARTA_HASTA           VARCHAR2,
   argFECHA_DESPACHO            VARCHAR2,
   argFECHA_ENTREGA             VARCHAR2,
   argMOTIV_RECHZO              NUMBER,
   argSECUENCIA_CARGA           VARCHAR2,
   argPROC_FECHA                VARCHAR2,
   argPROC_HORA                 VARCHAR2,
   argPROC_USUARIO              VARCHAR2,
   argCORRELATIVO               VARCHAR2,
   argTIPODOI_SECBAN            VARCHAR2,
   argDELITOMATERIA_SECBAN      VARCHAR2,
   argNROENVIO_SECBAN           VARCHAR2,
   argNROEXPEDIENTE_SECBAN      VARCHAR2,
   argDIRECAUTORIDAD_SECBAN     VARCHAR2,
   argSECRETARIO_SECBAN         VARCHAR2,
   argOTRAINFO_SECBAN           VARCHAR2,
   argPRIORIDADALTA_SECBAN      VARCHAR2,
   argPERIODOCONS_SECBAN        VARCHAR2,
   argPAIS_SECBAN               VARCHAR2,
   argORIGEN                    NUMBER,
   argFLAG_IMPRESO              NUMBER,
   argPRE_CARTA                 NUMBER,
   argOBSERVACION               VARCHAR2,
   argCARTA_ARCHIVO             VARCHAR2,
   argPRE_PROCESO               NUMBER,
   argTIPO_SOLICITUD            VARCHAR2,
   argDOCUM_NOTIFICA            VARCHAR2,
   argCOD_DELITO                NUMBER,
   argMSG_PROC                  VARCHAR2,
   argTIPO_BUSQUEDA             VARCHAR2,
   argTIPO_RESPUESTA            NUMBER,
   argMAIL_TO                   VARCHAR2,
   argIND_ESTADO_MAIL           NUMBER,
   argFCHA_CORREO               VARCHAR2,
   --
   OUTVAL                       OUT NUMBER,
   outCODIGO                    OUT NUMBER
  );

 PROCEDURE UP_SECRETO_INS
  (argFLAG                      NUMBER,
   argCODIGO                    NUMBER,
   argSECUENCIAOFI              NUMBER,
   argSECUENCIAPRO              NUMBER,
   argENTIDAD                   NUMBER,
   argENTIDADNOMBRE             VARCHAR2,  --
   argENTIDAD_EJECUTOR          VARCHAR2,
   argENTIDAD_EJECUTOR_CARGO    VARCHAR2,
   argINFO_ADICIONAL            VARCHAR2,
   argINFO_REQUERIDA            VARCHAR2,
   argPLAZO_ATENCION            VARCHAR2,
   argOFICIO_SBS                VARCHAR2,
   argNUMERO                    VARCHAR2,
   argOFICIO                    VARCHAR2,
   argAPE_PAT                   VARCHAR2,
   argAPE_MAT                   VARCHAR2,
   argNOMBRES                   VARCHAR2,
   argPROCESADO                 VARCHAR2,
   argTIPO_DOCUMENTO            NUMBER,
   argNUMERO_DOCUMENTO          VARCHAR2,
   argTIPO_PERSONA              VARCHAR2,
   argNUMERO_CUENTA             VARCHAR2,
   argCLIENTE                   NUMBER,
   argCARTA                     NUMBER,
   argHOMONIMIA                 NUMBER,
   argINCOMPLETO                NUMBER,
   argFLAG_SALDO                NUMBER,
   argESTADO                    NUMBER,
   argUSUARIO_REGISTRO          VARCHAR2,
   argFECHA_DESDE               VARCHAR2,
   argFECHA_HASTA               VARCHAR2,
   argFECHA_SECRETO             VARCHAR2,
   argFECHA_RESPUESTA           VARCHAR2,
   argUSUARIO_RESPUESTA         VARCHAR2,
   argFECHA_RECEPCION           VARCHAR2,
   argNRO_CARTA_INF             VARCHAR2,
   argNRO_CARTA_TIP             NUMBER,
   argCOD_CLIENTE               VARCHAR2,
   argFECHA_ING_ENTIDAD         VARCHAR2,
   argPRODUCTO                  VARCHAR2,
   argNRO_CARTA_DESDE           VARCHAR2,
   argNRO_CARTA_HASTA           VARCHAR2,
   argFECHA_DESPACHO            VARCHAR2,
   argFECHA_ENTREGA             VARCHAR2,
   argMOTIV_RECHZO              NUMBER,
   argSECUENCIA_CARGA           VARCHAR2,
   argPROC_FECHA                VARCHAR2,
   argPROC_HORA                 VARCHAR2,
   argPROC_USUARIO              VARCHAR2,
   argCORRELATIVO               VARCHAR2,
   argTIPODOI_SECBAN            VARCHAR2,
   argDELITOMATERIA_SECBAN      VARCHAR2,
   argNROENVIO_SECBAN           VARCHAR2,
   argNROEXPEDIENTE_SECBAN      VARCHAR2,
   argDIRECAUTORIDAD_SECBAN     VARCHAR2,
   argSECRETARIO_SECBAN         VARCHAR2,
   argOTRAINFO_SECBAN           VARCHAR2,
   argPRIORIDADALTA_SECBAN      VARCHAR2,
   argPERIODOCONS_SECBAN        VARCHAR2,
   argPAIS_SECBAN               VARCHAR2,
   argORIGEN                    NUMBER,
   argFLAG_IMPRESO              NUMBER,
   argPRE_CARTA                 NUMBER,
   argOBSERVACION               VARCHAR2,
   argCARTA_ARCHIVO             VARCHAR2,
   argPRE_PROCESO               NUMBER,
   argTIPO_SOLICITUD            VARCHAR2,
   argDOCUM_NOTIFICA            VARCHAR2,
   argCOD_DELITO                NUMBER,
   argMSG_PROC                  VARCHAR2,
   argTIPO_BUSQUEDA             VARCHAR2,
   argTIPO_RESPUESTA            NUMBER,
   argMAIL_TO                   VARCHAR2,
   argIND_ESTADO_MAIL           NUMBER,
   argFCHA_CORREO               VARCHAR2,
   --
   OUTVAL                       OUT NUMBER,
   outCODIGO                    OUT NUMBER
  );

 PROCEDURE UP_SECRETO_GRUPO_CUENTA_DEL(
 argFLAG             NUMBER,
 argSECRETO          NUMBER,
 argCOD_GRUPO        VARCHAR2,
 argCOD_PRODUCTO     VARCHAR2,
 argCOD_AUX1         VARCHAR2,
 OUTVAL OUT          NUMBER
 );

 PROCEDURE UP_SECRETO_GRUPO_CUENTA_INS(
 argFLAG             NUMBER,
 argSECRETO          NUMBER,
 argCOD_GRUPO        VARCHAR2,
 argCOD_PRODUCTO     VARCHAR2,
 argCOD_AUX1         VARCHAR2,
 OUTVAL OUT          NUMBER
 );

 PROCEDURE UP_SECRETO_GRUPO_CUENTA_SEL(
 argFLAG             NUMBER,
 argSECRETO          NUMBER,
 argCOD_GRUPO        VARCHAR2,
 argCOD_PRODUCTO     VARCHAR2,
 argCOD_AUX1         VARCHAR2,
 OUTVAL              OUT NUMBER,
 O_RESULT_CURSOR     OUT T_REF_CURSOR
 );

 PROCEDURE UP_SECRETO_PRODUCTO_CUENTA_SEL(
 argFLAG             NUMBER,
 argSECRETO          NUMBER,
 argCOD_GRUPO        VARCHAR2,
/* argCOD_PRODUCTO     VARCHAR2
 argCOD_AUX1         VARCHAR2*/
 OUTVAL OUT          NUMBER,
 O_RESULT_CURSOR     OUT T_REF_CURSOR
 );

 PROCEDURE UP_SECRETO_PRODUCTO_CUENTA_UPD(
 argFLAG             NUMBER,
 argSECRETO          NUMBER,
 argCOD_GRUPO        VARCHAR2,
/* argCOD_PRODUCTO     VARCHAR2
 argCOD_AUX1         VARCHAR2*/
 OUTVAL OUT          NUMBER
 );

END;
/
CREATE OR REPLACE PACKAGE BODY PKG_LSB_PROCESOS AS
  wFECHA_SYS     DATE;
  wHORA_SYS      VARCHAR2(8);
  wx_SQL         VARCHAR2(32767);
  wx_WHERE       VARCHAR2(32767);
  wEXISTE        NUMBER;
  wERROR_PERSO   EXCEPTION;
  wERROR_DESCRIP VARCHAR2(500);

 PROCEDURE UP_SECRETO_COINCIDENCIAS_INS
 (
  ARGFLAG                NUMBER,
  ARGIDSECRETO          NUMBER,
  ARGTIPO_DOCUMENTO      NUMBER,
  ARGNUMERO_DOCUMENTO    VARCHAR2,
  ARGAPELLIDO_PATERNO    VARCHAR2,
  ARGAPELLIDO_MATERNO    VARCHAR2,
  ARGNOMBRES            VARCHAR2,
  ARGFECHA_PROCESO      VARCHAR2,
  ARGUSUARIO            VARCHAR2,
  OUTVAL  OUT            NUMBER
 )
 AS

 BEGIN
 --
 OUTVAL := 1;
 --
 IF argFlag = 1 THEN
    INSERT INTO SECRETO_COINCIDENCIAS(
           ID_SECRETO,         APELLIDO_PAT_DEMANDADO, APELLIDO_MAT_DEMANDADO, NOMBRE_RAZSOC_DEMANDADO,
           TIPO_DOCUMENTO,     NUMERO_DOCUMENTO,       FECHA_PROCESO,          USUARIO)
    VALUES(
           ARGIDSECRETO,       ARGAPELLIDO_PATERNO,    ARGAPELLIDO_MATERNO,     ARGNOMBRES,
           ARGTIPO_DOCUMENTO,  ARGNUMERO_DOCUMENTO,    ARGFECHA_PROCESO,        ARGUSUARIO);
  END IF;
 END;

 PROCEDURE UP_SECRETO_COINCIDENCIAS_SEL
 (
  ARGFLAG                NUMBER,
  ARGIDSECRETO          NUMBER,
  ARGTIPO_DOCUMENTO      NUMBER,
  ARGNUMERO_DOCUMENTO    VARCHAR2,
  ARGAPELLIDO_PATERNO    VARCHAR2,
  ARGAPELLIDO_MATERNO    VARCHAR2,
  ARGNOMBRES            VARCHAR2,
  ARGFECHA_PROCESO      VARCHAR2,
  ARGUSUARIO            VARCHAR2,
  OUTVAL OUT            NUMBER,
  O_RESULT_CURSOR       OUT T_REF_CURSOR
 )
 AS
 BEGIN
 --
 OUTVAL := 1;
 --
   OPEN O_RESULT_CURSOR FOR
   SELECT SECCOI.ID_SECRETO,
          SECCOI.APELLIDO_PAT_DEMANDADO,
          SECCOI.APELLIDO_MAT_DEMANDADO,
          SECCOI.NOMBRE_RAZSOC_DEMANDADO,
          TD.DESCRIPCION AS COD_DESCRIPCION,
          SECCOI.NUMERO_DOCUMENTO,
          SECCOI.FECHA_PROCESO,
          SECCOI.USUARIO,
          SECCOI.TIPO_DOCUMENTO
   FROM SECRETO_COINCIDENCIAS SECCOI
   LEFT JOIN TIPO_DOCUMENTO TD ON SECCOI.TIPO_DOCUMENTO = TD.CODIGO
   WHERE ID_SECRETO = ARGIDSECRETO;
 END;

 PROCEDURE UP_SECRETO_COINCIDENCIAS_UPD
 (
  ARGFLAG              NUMBER,
  ARGIDSECRETO        NUMBER,
  ARGTIPO_DOCUMENTO    NUMBER,
  ARGNUMERO_DOCUMENTO  VARCHAR2,
  ARGAPELLIDO_PATERNO  VARCHAR2,
  ARGAPELLIDO_MATERNO  VARCHAR2,
  ARGNOMBRES          VARCHAR2,
  ARGFECHA_PROCESO    VARCHAR2,
  ARGUSUARIO          VARCHAR2,
  OUTVAL OUT          NUMBER
 )
 AS
 BEGIN
 --
 OUTVAL := 1;
 --
   IF ARGFLAG = 1 THEN --  ACTUALIZA COMO CLIENTE
      UPDATE  SECRETO
        SET    TIPO_DOCUMENTO    =  ARGTIPO_DOCUMENTO,
              NUMERO_DOCUMENTO  =  ARGNUMERO_DOCUMENTO,
              ESTADO            =  30,
              CLIENTE            =  1,
              FECHA_MODI        =  TRUNC(SYSDATE),
              HORA_MODI          =  TO_CHAR(SYSDATE, 'HH24:MI:SS'),
              USUARIO_MODI      =  ARGUSUARIO
        WHERE  CODIGO            =  ARGIDSECRETO;
        --
        DELETE
        FROM  SECRETO_COINCIDENCIAS
        WHERE  ID_SECRETO  =  ARGIDSECRETO;
   END IF;
   --
   IF ARGFLAG = 2 THEN --  ACTUALIZA COMO NO CLIENTE
       UPDATE  SECRETO
        SET    ESTADO        =  30,
              FECHA_MODI    =  TRUNC(SYSDATE),
              HORA_MODI      =  TO_CHAR(SYSDATE, 'HH24:MI:SS'),
              USUARIO_MODI  =  ARGUSUARIO
       WHERE  CODIGO          =  ARGIDSECRETO;
       --
       DELETE
       FROM  SECRETO_COINCIDENCIAS
       WHERE  ID_SECRETO  =  ARGIDSECRETO;
   END IF;
   --
   IF ARGFLAG = 3 THEN --  ACTUALIZA COMO HOMONIMIA
       UPDATE  SECRETO
        SET    ESTADO        =  30,
              HOMONIMIA      =  1,
              FECHA_MODI    =  TRUNC(SYSDATE),
              HORA_MODI      =  TO_CHAR(SYSDATE, 'HH24:MI:SS'),
              USUARIO_MODI  =  ARGUSUARIO
       WHERE    CODIGO        =  ARGIDSECRETO;
       --
       DELETE
       FROM  SECRETO_COINCIDENCIAS
       WHERE  ID_SECRETO  =  ARGIDSECRETO;
   END IF;
   --
   IF ARGFLAG = 4 THEN --  ACTUALIZA COMO INCOMPLETO
       UPDATE  SECRETO
        SET    ESTADO        =  30,
              INCOMPLETO    =  1,
              FECHA_MODI    =  TRUNC(SYSDATE),
              HORA_MODI      =  TO_CHAR(SYSDATE, 'HH24:MI:SS'),
              USUARIO_MODI  =  ARGUSUARIO
       WHERE    CODIGO        =  ARGIDSECRETO;
       --
       DELETE
       FROM  SECRETO_COINCIDENCIAS
       WHERE  ID_SECRETO  =  ARGIDSECRETO;
   END IF;
 END;
 /*Secreto*/
 PROCEDURE UP_SECRETO_SEL
 (argFLAG                      NUMBER,
   argCODIGO                    NUMBER,
   argSECUENCIAOFI              NUMBER,
   argSECUENCIAPRO              NUMBER,
   argENTIDAD                   NUMBER,
   argENTIDADNOMBRE             VARCHAR2,
   argENTIDAD_EJECUTOR          VARCHAR2,
   argENTIDAD_EJECUTOR_CARGO    VARCHAR2,
   argINFO_ADICIONAL            VARCHAR2,
   argINFO_REQUERIDA            VARCHAR2,
   argPLAZO_ATENCION            VARCHAR2,
   argOFICIO_SBS                VARCHAR2,
   argNUMERO                    VARCHAR2,
   argOFICIO                    VARCHAR2,
   argAPE_PAT                   VARCHAR2,
   argAPE_MAT                   VARCHAR2,
   argNOMBRES                   VARCHAR2,
   argPROCESADO                 VARCHAR2,
   argTIPO_DOCUMENTO            NUMBER,
   argNUMERO_DOCUMENTO          VARCHAR2,
   argTIPO_PERSONA              VARCHAR2,
   argNUMERO_CUENTA             VARCHAR2,
   argCLIENTE                   NUMBER,
   argCARTA                     NUMBER,
   argHOMONIMIA                 NUMBER,
   argINCOMPLETO                NUMBER,
   argFLAG_SALDO                NUMBER,
   argESTADO                    NUMBER,
   argUSUARIO_REGISTRO          VARCHAR2,
   argFECHA_DESDE               VARCHAR2,
   argFECHA_HASTA               VARCHAR2,
   argFECHA_SECRETO             VARCHAR2,
   argFECHA_RESPUESTA           VARCHAR2,
   argUSUARIO_RESPUESTA         VARCHAR2,
   argFECHA_RECEPCION           VARCHAR2,
   argNRO_CARTA_INF             VARCHAR2,
   argNRO_CARTA_TIP             NUMBER,
   argCOD_CLIENTE               VARCHAR2,
   argFECHA_ING_ENTIDAD         VARCHAR2,
   argPRODUCTO                  VARCHAR2,
   argNRO_CARTA_DESDE           VARCHAR2,
   argNRO_CARTA_HASTA           VARCHAR2,
   argFECHA_DESPACHO            VARCHAR2,
   argFECHA_ENTREGA             VARCHAR2,
   argMOTIV_RECHZO              NUMBER,
   argSECUENCIA_CARGA           VARCHAR2,
   argPROC_FECHA                VARCHAR2,
   argPROC_HORA                 VARCHAR2,
   argPROC_USUARIO              VARCHAR2,
   argCORRELATIVO               VARCHAR2,
   argTIPODOI_SECBAN            VARCHAR2,
   argDELITOMATERIA_SECBAN      VARCHAR2,
   argNROENVIO_SECBAN           VARCHAR2,
   argNROEXPEDIENTE_SECBAN      VARCHAR2,
   argDIRECAUTORIDAD_SECBAN     VARCHAR2,
   argSECRETARIO_SECBAN         VARCHAR2,
   argOTRAINFO_SECBAN           VARCHAR2,
   argPRIORIDADALTA_SECBAN      VARCHAR2,
   argPERIODOCONS_SECBAN        VARCHAR2,
   argPAIS_SECBAN               VARCHAR2,
   argORIGEN                    NUMBER,
   argFLAG_IMPRESO              NUMBER,
   argPRE_CARTA                 NUMBER,
   argOBSERVACION               VARCHAR2,
   argCARTA_ARCHIVO             VARCHAR2,
   argPRE_PROCESO               NUMBER,
   argTIPO_SOLICITUD            VARCHAR2,
   argDOCUM_NOTIFICA            VARCHAR2,
   argCOD_DELITO                NUMBER,
   argMSG_PROC                  VARCHAR2,
   argTIPO_BUSQUEDA             VARCHAR2,
   argTIPO_RESPUESTA            NUMBER,
   argMAIL_TO                   VARCHAR2,
   argIND_ESTADO_MAIL           NUMBER,
   argFCHA_CORREO               VARCHAR2,
   --
   OUTVAL                       OUT NUMBER,
   O_RESULT_CURSOR              OUT T_REF_CURSOR
 )
 /*
 ------------------------------------------------------------------------------------
 GPS PERU
 Fecha creacion 11/06/2019
 Parametros :
 argFlag                      :Indicador para procesar sentencia.
 argCodigo                    :Codigo del oficio secreto.
 argSecuenciaOfi              :Numero de secuencia del Oficio.
 argSecuenciaPro              :Numero de secuencia del procesado.
 argEntidad                   :Id o codigo de la entidad.
 argEntidadNombre             :Nombre de la entidad.
 argentidad_ejecutor          :Nombre del responsable.
 argentidad_ejecutor_cargo    :Cargo del responsable.
 argInfo_adicional            :Informacion adicional.
 argInfo_requerida            :Informacion requerida.
 argoficio_sbs                :Nombre del oficio sbs.
 argnumero                    :Numero del oficio.
 argoficio                    :Nombre del oficio
 argApe_pat                   :Apellido paterno del procesado.
 argApe_mat                   :Apellido materno del procesado
 argNombres                   :Nombres del procesado.
 argProcesado                 :Nombres completos del procesado.
 argTipo_documento            :Tipo de documento del procesado.
 argNumero_documento          :Numero de documento del procesado.
 argTipo_persona              :Persona Natural o Juridica.
 argNumero_cuenta             :Numero de cuenta asociada.
 argCliente                   :Indica si es cliente o no.
 argcarta                     :Indica si genero carta.
 arghomonimia                 :Indica si es homonimia datos del procesado.
 argFlag_Saldo                :Indicador si informa saldo.
 argIncompleto                :Indicador si datos del procesado son icompletos.
 argEstado                    :Estado del oficio secreto.
 argUsuario_Registro          :Nombre del usuario que registra.
 argfecha_Desde               :Rango de fecha del oficio.
 argfecha_Hasta               :Rango de fecha del oficio.
 argfecha_Secreto             :Fecha secreto de ingreso de oficio.
 argfecha_Respuesta           :Fecha de respuesta del oficio.
 argFecha_recepcion           :Fecha de recepcion del oficio.
 argNro_Carta_Inf             :Numero de carta.
 argNro_Carta_Tip             :Numero de carta.
 argCod_Cliente               :Id o codigo del cliente.
 argFecha_Ing_Entidad         :Fecha de ingreso de Entidad.
 argProducto                  :Codigo del producto.
 argNro_Carta_Desde           :Rango de fecha de carta.
 argNro_Carta_Hasta           :Rango de fecha de carta.
 argFecha_Despacho            :Fecha de despacho del oficio.
 argFecha_Entrega             :Fecha de entrega de carta.
 argMotiv_Rechzo              :Codigo del motivo de rechazo de carta.
 argSecuencia_Carga           :Secuencia de carga del xsls.
 argproc_fecha                :Fecha de proceso.
 argproc_hora                 :Hora de proceso.
 argproc_usuario              :Usuario del proceso.
 argEntidadSolicitante_Secban :Entidad solicitante del secban.
 argTipoDOI_Secban            :Tipo de documento del secban.
 argDelitoMateria_Secban      :Delito/materia del secban.
 argNroEnvio_Secban           :Numero de envio del secban.
 argNroExpediente_Secban      :Numero de expediente del secban.
 argDirecAutoridad_Secban     :Direccion de la autoridad del secban.
 argSecretario_Secban         :Secretario del secban.
 argOtraInfo_Secban           :Otra informacion.
 argPrioridadAlta_Secban      :Indicar si es prioridad alta.
 argPeriodoCons_Secban        :Periodo del secban.
 argPais_Secban               :Pais
 argOrigen                    :Origen de registro.
 argPlazo_Atencion            :Plazo de atencion.
 OutIdSecreto                 :Indicador de estado.
 outVal                       :Indicador de estado.

 Objetivo           :Listar los procesados Lsb correspondientes e Insertar procesados.
 --------------------------------------------------------------------------------------------------------
 */
 AS
 wNOTIFICACIONES  LSB_PARAMETROS.PRM_TEXTO5%TYPE;
 BEGIN
   OUTVAL := 1;
   --
   /*Lista Secreto y Procesados*/
   IF argFLAG = 2 THEN
      OPEN O_RESULT_CURSOR FOR
      SELECT 0 AS CHK,
             S.CODIGO,
             S.OFICIO_SBS,
             S.SECUENCIA_OFI,
             S.SECUENCIA_PRO,
             S.ENTIDAD AS ID_ENTIDAD,
             LPAD(S.ENTIDAD,(CASE WHEN LENGTH(S.ENTIDAD) > 3 THEN LENGTH(S.ENTIDAD) ELSE 3 END),'0') || ' - ' || E.NOMBRE AS JUZGADO,
             S.OFICIO,
             NVL(S.NRO_EXPEDIENTE_REF,' ') AS NRO_EXPEDIENTE_REF,
             S.ENTIDAD_EJECUTOR,
             S.PLAZO_ATENCION,
             S.FECHA_SECRETO,
             S.PROCESADO,
             S.TIPO_DOCUMENTO,
             TD.DESCRIPCION AS DESC_DOCUMENTO,
             S.NUMERO_DOCUMENTO,
             TD.COD_HOMOLOGACION,
             S.TIPO_PERSONA,
             S.COD_CLIENTE,
             S.CLIENTE,
             NVL(SGC.TOT_PROD,0) AS TOT_PROD,
             S.CARTA,
             S.FLAG_IMPRESO,
             S.HOMONIMIA,
             S.FLAG_SALDO,
             S.INCOMPLETO,
             S.FECHA_RECEPCION,
             S.ENTIDAD_EJECUTOR_CARGO,
             S.FECHA_DESDE,
             S.FECHA_HASTA,
             S.SECUE_CARGA_XLS,
             S.DOCUM_NOTIFICA,
             S.USUARIO_REGISTRO,
             S.FECHA_REGISTRO,
             S.PROC_USUARIO,
             S.PROC_FECHA,
             S.PROC_HORA,
             S.FECHA_RESPUESTA,
             S.USUARIO_RESPUESTA,
             S.NRO_CARTA_INF,
             S.CARTA_ARCHIVO,
             E.UBIGEO,
             S.NUMERADOR_TIPO,
             S.COD_DELITO,
             D.DESC_LARGA AS DELITO_MATERIA,
             S.NRO_ENVIO,
             S.DESC_ENTIDAD_SOLIC,
             S.TPO_DOC_IDENT,
             S.DIRECCION_AUTORIDAD,
             S.SECRETARIO,
             S.INF_REQUERIDA,
             S.TIPO_BUSQUEDA,
             S.OTRA_INFORMACION,
             S.PRIORIDAD_ALTA,
             S.PERIODO_CONSULTA,
             S.PAIS,
             S.ORIG_REG,
             S.TIPO_RESPUESTA,
             S.MAIL_TO,
             S.IND_ESTADO_MAIL,
             S.FCHA_CORREO,
             0 AS FLAG_REG
        FROM SECRETO S
       INNER JOIN ENTIDAD E ON E.CODIGO = S.ENTIDAD
        LEFT JOIN TIPO_DOCUMENTO TD ON S.TIPO_DOCUMENTO = TD.CODIGO
        LEFT JOIN DELITO D ON D.CODIGO = S.COD_DELITO
        LEFT JOIN (SELECT SECRETO, COUNT(*) AS TOT_PROD
                     FROM SECRETO_PRODUCTO_CUENTA
                     GROUP BY SECRETO) SGC ON SGC.SECRETO = S.CODIGO
      WHERE S.FLAG_IMPRESO = 0
        AND S.ESTADO = argESTADO
        AND S.CARTA = argCARTA
        AND S.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN S.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
        AND (S.FECHA_REGISTRO >= CASE WHEN argFECHA_DESDE IS NULL THEN S.FECHA_REGISTRO ELSE TO_DATE(argFECHA_DESDE,'DD/MM/YYYY') END
             AND S.FECHA_REGISTRO <= CASE WHEN argFECHA_HASTA IS NULL THEN S.FECHA_REGISTRO ELSE TO_DATE(argFECHA_HASTA,'DD/MM/YYYY') END)
        AND S.ORIG_REG = CASE WHEN argORIGEN = 0 THEN S.ORIG_REG ELSE argORIGEN END
      ORDER BY S.CLIENTE DESC, NVL(SGC.TOT_PROD,0) DESC, S.OFICIO_SBS, S.OFICIO, E.NOMBRE;
   END IF;
   /*Consulta Lsb*/
   IF argFLAG = 3 THEN
     wNOTIFICACIONES := '';
     wEXISTE := 0;
     /*Recupera directorio de Notificaciones*/
     SELECT COUNT(*) INTO wEXISTE
       FROM LSB_PARAMETROS WHERE CODIGO = 13;
     --
     IF wEXISTE > 0 THEN
       SELECT PRM_TEXTO5 INTO wNOTIFICACIONES
         FROM LSB_PARAMETROS WHERE CODIGO = 13;
     END IF;
     --
     WX_SQL := '';
     WX_WHERE := '';
     WX_SQL := WX_SQL || ' SELECT S.CODIGO,
               S.OFICIO_SBS,
               S.SECUENCIA_OFI,
               S.SECUENCIA_PRO,
               S.ENTIDAD AS COD_ENTIDAD,
               LPAD(S.ENTIDAD,(CASE WHEN LENGTH(S.ENTIDAD) > 3 THEN LENGTH(S.ENTIDAD) ELSE 3 END),''0'') || '' - '' || E.NOMBRE AS DESC_ENTIDAD,
               S.OFICIO,
               S.NRO_EXPEDIENTE_REF,
               S.ENTIDAD_EJECUTOR,
               S.FECHA_SECRETO,
               S.PROCESADO,
               S.TIPO_DOCUMENTO,
               TD.DESCRIPCION AS COD_DESCRIPCION,
               S.NUMERO_DOCUMENTO,
               S.TIPO_PERSONA,
               S.COD_CLIENTE,
               S.TIPO_BUSQUEDA,
               S.CLIENTE,
               S.CARTA,
               S.FLAG_IMPRESO,
               S.HOMONIMIA,
               S.INCOMPLETO,
               S.FLAG_SALDO,
               NVL(SGC.TOT_PROD,0) AS TOT_PROD,
               S.FECHA_DESDE,
               S.FECHA_HASTA,
               S.SECUE_CARGA_XLS,
               S.DOCUM_NOTIFICA,
               S.USUARIO_REGISTRO,
               S.FECHA_REGISTRO,
               S.FECHA_RESPUESTA,
               S.USUARIO_RESPUESTA,
               S.NRO_CARTA_INF,
               S.CARTA_ARCHIVO,
               S.NUMERADOR_TIPO,
               S.ENTIDAD_EJECUTOR_CARGO,
               S.FECHA_DESPACHO,
               S.FECHA_ENTREGA,
               S.MOTIV_RECHAZO,
               LSE.DESCRIPCION,
               S.COD_DELITO,
               D.DESC_LARGA AS DELITO_MATERIA,
               S.INF_REQUERIDA,
               S.TIPO_RESPUESTA,
               S.MAIL_TO,
               S.IND_ESTADO_MAIL,
               S.FCHA_CORREO,
               E.MAIL_AGENCIA,
               CASE WHEN S.DOCUM_NOTIFICA IS NULL
                    THEN S.DOCUM_NOTIFICA
                    ELSE ''' ||  wNOTIFICACIONES || '''|| S.DOCUM_NOTIFICA END AS UBIC_NOTIFICA
                FROM SECRETO S
               INNER JOIN TIPO_DOCUMENTO TD ON S.TIPO_DOCUMENTO = TD.CODIGO
               INNER JOIN (SELECT ENT.CODIGO, ENT.NOMBRE, ENT.DIRECCION, ENT.UBIGEO,
                         UE.AGE_UBIGEO, UE.AGENCIA, UE.NOM_AGENCIA, UE.MAIL_AGENCIA, NVL(UE.IMPRIMIR,0) AS IMPRIMIR
                    FROM ENTIDAD ENT
                    LEFT JOIN UBIGEO UE ON (UE.CODDPTO = SUBSTR(ENT.UBIGEO,1,2) AND
                                            UE.CODPROV = SUBSTR(ENT.UBIGEO,3,2) AND
                                            UE.CODDIST = SUBSTR(ENT.UBIGEO,5,2))) E ON S.ENTIDAD = E.CODIGO
                LEFT JOIN DELITO D ON D.CODIGO = S.COD_DELITO
                LEFT JOIN LSB_ESTADO LSE ON S.MOTIV_RECHAZO = LSE.CODIGO
                LEFT JOIN (SELECT SECRETO, COUNT(*) AS TOT_PROD
                             FROM SECRETO_PRODUCTO_CUENTA
                            GROUP BY SECRETO) SGC ON SGC.SECRETO = S.CODIGO ';

     IF NOT argFECHA_DESDE IS NULL AND NOT argFECHA_HASTA IS NULL THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
         DBMS_OUTPUT.PUT_LINE('ERROR: ' ||WX_WHERE);
       END IF;
       IF argPRE_PROCESO = 1 THEN
         WX_WHERE := WX_WHERE || 'S.FECHA_REGISTRO BETWEEN TO_DATE(''' ||
               argFECHA_DESDE || ''',''dd/MM/yyyy'')  AND TO_DATE(''' ||
               argFECHA_HASTA ||''',''dd/MM/yyyy'')' ;
                            DBMS_OUTPUT.PUT_LINE('ERROR: ' ||WX_WHERE);
       ELSE
         WX_WHERE := WX_WHERE || 'S.FECHA_SECRETO BETWEEN TO_DATE(''' ||
               argFECHA_DESDE || ''',''dd/MM/yyyy'')  AND TO_DATE(''' ||
               argFECHA_HASTA ||''',''dd/MM/yyyy'')' ;
                            DBMS_OUTPUT.PUT_LINE('ERROR: ' ||WX_WHERE);
       END IF;
       DBMS_OUTPUT.PUT_LINE('ERROR: ' ||WX_WHERE);
     END IF;
     IF NOT argOFICIO_SBS IS NULL THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'UPPER(S.OFICIO_SBS) LIKE ''%' || argOFICIO_SBS || '%'' ';
     END IF;
     IF argENTIDAD <> 0 THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'S.ENTIDAD = ' || TO_CHAR(argENTIDAD) || '';
     END IF;
     IF NOT argOFICIO IS NULL THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'UPPER(S.OFICIO) LIKE ''%' || argOFICIO || '%'' ';
     END IF;
     IF NOT argPROCESADO IS NULL THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'UPPER(S.PROCESADO) LIKE  ''%' || argPROCESADO || '%''  ';
     END IF;
     IF NOT argNRO_CARTA_INF IS NULL THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'UPPER(S.NRO_CARTA_INF) LIKE ''%' || argNRO_CARTA_INF || '%'' ';
     END IF;
     IF argNRO_CARTA_TIP <> 0 THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'S.NUMERADOR_TIPO = ' || TO_CHAR(argNRO_CARTA_TIP) || '';
     END IF;
     IF argTIPO_RESPUESTA <> 0 THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'S.TIPO_RESPUESTA = ' || argTIPO_RESPUESTA || ' AND S.MAIL_TO IS NOT NULL';
     END IF;

     IF NOT WX_WHERE IS NULL THEN
       WX_WHERE := ' WHERE ' || WX_WHERE;
     END IF;
     --
     WX_SQL := WX_SQL || WX_WHERE || ' ORDER BY S.FECHA_SECRETO,S.OFICIO_SBS,S.ENTIDAD,S.OFICIO,S.PROCESADO ';
     OPEN O_RESULT_CURSOR FOR WX_SQL;
   END IF;
   /*Lista de Cartas a imprimir*/
   IF argFLAG = 4 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT 0 AS CHK,
            S.OFICIO_SBS,
            S.OFICIO,
            S.ENTIDAD AS ID_ENTIDAD,
            S.ENTIDAD_EJECUTOR,
            LPAD(S.ENTIDAD,(CASE WHEN LENGTH(S.ENTIDAD) > 3 THEN LENGTH(S.ENTIDAD) ELSE 3 END),'0') || ' - ' || E.NOMBRE AS JUZGADO,
            E.DIRECCION,
            S.NRO_CARTA_INF,
            S.CARTA_ARCHIVO,
            S.NUMERADOR_TIPO,
            S.DOCUM_NOTIFICA,
            E.UBIGEO,
            E.AGE_UBIGEO,
            E.AGENCIA,
            E.NOM_AGENCIA,
            E.MAIL_AGENCIA,
            E.IMPRIMIR,
            (CASE WHEN S.TIPO_RESPUESTA = 2 THEN 1 ELSE 0 END) AS TIPO_RESPUESTA,
            S.MAIL_TO,
            S.IND_ESTADO_MAIL,
            S.FCHA_CORREO
       FROM SECRETO S
      INNER JOIN (SELECT ENT.CODIGO, ENT.NOMBRE, ENT.DIRECCION, ENT.UBIGEO,
                         UE.AGE_UBIGEO, UE.AGENCIA, UE.NOM_AGENCIA, UE.MAIL_AGENCIA, NVL(UE.IMPRIMIR,0) AS IMPRIMIR
                    FROM ENTIDAD ENT
                    LEFT JOIN UBIGEO UE ON (UE.CODDPTO = SUBSTR(ENT.UBIGEO,1,2) AND
                                            UE.CODPROV = SUBSTR(ENT.UBIGEO,3,2) AND
                                            UE.CODDIST = SUBSTR(ENT.UBIGEO,5,2))) E ON E.CODIGO = S.ENTIDAD
      WHERE S.ESTADO = 32
       AND S.CARTA = 1
       AND S.FLAG_IMPRESO = 0
       AND S.IND_ESTADO_MAIL = 0
       AND NUMERADOR_TIPO =  CASE WHEN argNro_Carta_Tip = 0 THEN S.NUMERADOR_TIPO ELSE argNro_Carta_Tip END
     GROUP BY S.OFICIO_SBS,     S.OFICIO,        S.ENTIDAD,         S.ENTIDAD_EJECUTOR, E.NOMBRE,
              E.DIRECCION,      S.NRO_CARTA_INF, S.CARTA_ARCHIVO,   S.NUMERADOR_TIPO,   S.DOCUM_NOTIFICA,
              E.UBIGEO,         E.AGE_UBIGEO,    E.AGENCIA,         E.NOM_AGENCIA,      E.MAIL_AGENCIA,
              E.IMPRIMIR,       S.TIPO_RESPUESTA,S.MAIL_TO,         S.IND_ESTADO_MAIL,  S.FCHA_CORREO
     ORDER BY E.IMPRIMIR DESC, E.AGENCIA, E.AGE_UBIGEO;
   END IF;
   /*Correlativo para Cartas*/
   IF ARGFLAG = 5 THEN
      OPEN O_RESULT_CURSOR FOR
      SELECT DISTINCT CORRELATIVO
        FROM SECRETO
      WHERE CARTA = 1
        AND FLAG_IMPRESO = 1
      ORDER BY CORRELATIVO DESC;
   END IF;
   /*Listado de Control*/
   IF argFLAG = 6 THEN
/*      UPDATE SECRETO
             SET FECHA_DESPACHO = ARGFECHA_DESPACHO
      WHERE NRO_CARTA_INF BETWEEN ARGNRO_CARTA_DESDE AND ARGNRO_CARTA_HASTA;
 ;*/
       OPEN O_RESULT_CURSOR FOR
     SELECT D.AGENCIA, D.NOM_AGENCIA, D.NOMB_ENTIDAD,D.DIRECCION, D.ENT_LOCALIDAD, D.TIPO_RESPUESTA,COUNT(D.MAIL_TO) AS TOT_OFICIOS,
            COUNT(D.NRO_CARTA_INF) AS TOT_CARTAS, D.IND_ESTADO_MAIL
       FROM (SELECT E.AGENCIA, E.NOM_AGENCIA, E.NOMBRE AS NOMB_ENTIDAD, E.UBIGEO,
                    E.ENT_LOCALIDAD, E.DIRECCION, S.NRO_CARTA_INF, S.MAIL_TO, (CASE WHEN S.TIPO_RESPUESTA = 2 THEN 1 ELSE 0 END) AS TIPO_RESPUESTA,
                    S.IND_ESTADO_MAIL
                    --, S.OFICIO S.ENTIDAD_EJECUTOR, S.PROCESADO, E.UBIGEO, E.AGE_UBIGEO, E.IMPRIMIR
               FROM SECRETO S
              INNER JOIN (SELECT ENT.CODIGO, ENT.NOMBRE, ENT.DIRECCION, ENT.UBIGEO, UE.NOMBRE AS ENT_LOCALIDAD,
                                 UE.AGENCIA, UE.AGE_UBIGEO, UE.NOM_AGENCIA, NVL(UE.IMPRIMIR,0) AS IMPRIMIR
                            FROM ENTIDAD ENT
                            LEFT JOIN UBIGEO UE ON (UE.CODDPTO = SUBSTR(ENT.UBIGEO,1,2) AND
                                                    UE.CODPROV = SUBSTR(ENT.UBIGEO,3,2) AND
                                                    UE.CODDIST = SUBSTR(ENT.UBIGEO,5,2))) E ON E.CODIGO = S.ENTIDAD
              WHERE S.CARTA = 1
                AND S.FLAG_IMPRESO = 1
                AND S.NUMERO_CUENTA = argNUMERO_CUENTA
                AND NVL(E.IMPRIMIR,0) = argFLAG_IMPRESO
              GROUP BY E.AGENCIA, E.NOM_AGENCIA, E.NOMBRE, E.UBIGEO, E.ENT_LOCALIDAD, E.DIRECCION, S.NRO_CARTA_INF, S.TIPO_RESPUESTA, S.MAIL_TO,
                       S.IND_ESTADO_MAIL) D
      GROUP BY D.AGENCIA, D.NOM_AGENCIA, D.NOMB_ENTIDAD, D.UBIGEO, D.ENT_LOCALIDAD, D.DIRECCION, D.TIPO_RESPUESTA, D.IND_ESTADO_MAIL
      ORDER BY D.AGENCIA, D.TIPO_RESPUESTA;

   END IF;
   /*Lista de Despacho*/
   IF argFLAG = 7 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT S.NRO_CARTA_INF, S.OFICIO, S.ENTIDAD, E.NOMBRE AS NOMB_ENTIDAD, E.DIRECCION, S.ENTIDAD_EJECUTOR,
            S.PROCESADO, S.TIPO_RESPUESTA, S.IND_ESTADO_MAIL, E.MAIL_AGENCIA  --, E.UBIGEO, E.AGE_UBIGEO, E.AGENCIA, E.IMPRIMIR
       FROM SECRETO S
      INNER JOIN (SELECT ENT.CODIGO, ENT.NOMBRE, ENT.DIRECCION, ENT.UBIGEO,
                         UE.AGE_UBIGEO, UE.AGENCIA, UE.NOM_AGENCIA, UE.MAIL_AGENCIA, NVL(UE.IMPRIMIR,0) AS IMPRIMIR
                    FROM ENTIDAD ENT
                    LEFT JOIN UBIGEO UE ON (UE.CODDPTO = SUBSTR(ENT.UBIGEO,1,2) AND
                                            UE.CODPROV = SUBSTR(ENT.UBIGEO,3,2) AND
                                            UE.CODDIST = SUBSTR(ENT.UBIGEO,5,2))
                   WHERE NVL(UE.AGENCIA,' ') = CASE WHEN argNUMERO IS NULL THEN NVL(UE.AGENCIA,' ') ELSE argNUMERO END) E ON E.CODIGO = S.ENTIDAD
      WHERE S.CARTA = 1
        AND S.FLAG_IMPRESO = 1
        AND S.NUMERO_CUENTA = argNUMERO_CUENTA
        AND NVL(E.IMPRIMIR,0) = argFLAG_IMPRESO --Para Indicar Agencia si se Imprime
      ORDER BY E.NOMBRE, S.NRO_CARTA_INF;
   END IF;
   /*Consulta Oficio - Delito*/
   IF argFLAG = 8 THEN
     wNOTIFICACIONES := '';
     wEXISTE := 0;
     /*Recupera directorio de Notificaciones*/
     SELECT COUNT(*) INTO wEXISTE
       FROM LSB_PARAMETROS WHERE CODIGO = 12;
     --
     IF wEXISTE > 0 THEN
       SELECT PRM_TEXTO2 INTO wNOTIFICACIONES
         FROM LSB_PARAMETROS WHERE CODIGO = 12;
     END IF;
     --
     WX_SQL := '';
     WX_WHERE := '';
     WX_SQL := WX_SQL || ' SELECT S.CODIGO,
               S.OFICIO_SBS,
               S.ENTIDAD AS COD_ENTIDAD,
               LPAD(S.ENTIDAD,(CASE WHEN LENGTH(S.ENTIDAD) > 3 THEN LENGTH(S.ENTIDAD) ELSE 3 END),''0'') || '' - '' || E.NOMBRE AS DESC_ENTIDAD,
               S.OFICIO,
               S.NRO_EXPEDIENTE_REF,
               S.FECHA_SECRETO,
               S.PROCESADO,
               S.TIPO_DOCUMENTO,
               TD.DESCRIPCION AS COD_DESCRIPCION,
               S.NUMERO_DOCUMENTO,
               S.NRO_CARTA_INF,
               S.CARTA_ARCHIVO,
               S.NUMERADOR_TIPO,
               S.COD_DELITO,
               D.DESC_LARGA AS DELITO_MATERIA,
               S.DOCUM_NOTIFICA,
               CASE WHEN S.DOCUM_NOTIFICA IS NULL
                    THEN S.DOCUM_NOTIFICA
                    ELSE ''' ||  wNOTIFICACIONES || '''|| S.DOCUM_NOTIFICA END AS UBIC_NOTIFICA
          FROM SECRETO S
         INNER JOIN TIPO_DOCUMENTO TD ON S.TIPO_DOCUMENTO = TD.CODIGO
         INNER JOIN ENTIDAD E ON S.ENTIDAD = E.CODIGO
         INNER JOIN (SELECT CODIGO, DESC_LARGA FROM DELITO WHERE SELEC = 1) D ON D.CODIGO = S.COD_DELITO ';

     IF NOT argFECHA_DESDE IS NULL AND NOT argFECHA_HASTA IS NULL THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
         DBMS_OUTPUT.PUT_LINE('ERROR: ' ||WX_WHERE);
       END IF;
       IF argPRE_PROCESO = 1 THEN
         WX_WHERE := WX_WHERE || 'S.FECHA_REGISTRO BETWEEN TO_DATE(''' ||
               argFECHA_DESDE || ''',''dd/MM/yyyy'')  AND TO_DATE(''' ||
               argFECHA_HASTA ||''',''dd/MM/yyyy'')' ;
                            DBMS_OUTPUT.PUT_LINE('ERROR: ' ||WX_WHERE);
       ELSE
         WX_WHERE := WX_WHERE || 'S.FECHA_SECRETO BETWEEN TO_DATE(''' ||
               argFECHA_DESDE || ''',''dd/MM/yyyy'')  AND TO_DATE(''' ||
               argFECHA_HASTA ||''',''dd/MM/yyyy'')' ;
                            DBMS_OUTPUT.PUT_LINE('ERROR: ' ||WX_WHERE);
       END IF;
       DBMS_OUTPUT.PUT_LINE('ERROR: ' ||WX_WHERE);
     END IF;
     IF argNRO_CARTA_TIP <> 0 THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'S.NUMERADOR_TIPO = ' || TO_CHAR(argNRO_CARTA_TIP) || '';
     END IF;
/*     IF NOT argDELITOMATERIA_SECBAN IS NULL THEN
       IF NOT WX_WHERE IS NULL THEN
         WX_WHERE := WX_WHERE || ' AND ';
       END IF;
       WX_WHERE := WX_WHERE || 'D.CODIGO IN (' || argDELITOMATERIA_SECBAN || ')';
     END IF;*/
     IF NOT WX_WHERE IS NULL THEN
       WX_WHERE := ' WHERE ' || WX_WHERE;
     END IF;
     --
     WX_SQL := WX_SQL || WX_WHERE || ' ORDER BY S.FECHA_SECRETO,S.OFICIO_SBS,S.ENTIDAD,S.OFICIO,S.PROCESADO ';
     OPEN O_RESULT_CURSOR FOR WX_SQL;
   END IF;
   /*Lista Detalle Procesado*/
   IF argFLAG = 11 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT S.CODIGO,
             S.OFICIO_SBS,
             S.SECUENCIA_OFI,
             S.SECUENCIA_PRO,
             S.ENTIDAD AS COD_ENTIDAD,
             LPAD(S.ENTIDAD,(CASE WHEN LENGTH(S.ENTIDAD) > 3 THEN LENGTH(S.ENTIDAD) ELSE 3 END),'0') || ' - ' || E.NOMBRE AS DESC_ENTIDAD,
             S.FECHA_SECRETO,
             S.OFICIO,
             S.NRO_EXPEDIENTE_REF,
             S.PROCESADO,
             S.TIPO_DOCUMENTO,
             TD.DESCRIPCION AS COD_DESCRIPCION,
             S.TIPO_PERSONA,
             S.NUMERO_DOCUMENTO,
             S.CLIENTE,
             S.CARTA,
             S.FLAG_IMPRESO,
             S.HOMONIMIA,
             S.INCOMPLETO,
             S.FLAG_SALDO,
             S.FECHA_DESDE,
             S.FECHA_HASTA,
             S.COD_CLIENTE,
             S.NRO_CARTA_INF,
             S.FECHA_RESPUESTA,
             S.USUARIO_RESPUESTA,
             S.CARTA_ARCHIVO,
             S.DOCUM_NOTIFICA,
             S.SECUE_CARGA_XLS,
             S.FECHA_REGISTRO,
             S.USUARIO_REGISTRO,
             S.ENTIDAD_EJECUTOR,
             S.ENTIDAD_EJECUTOR_CARGO,
             S.NUMERADOR_TIPO,
             S.FECHA_DESPACHO,
             S.FECHA_ENTREGA,
             S.COD_DELITO,
             S.COD_DELITO || ' - ' || D.DESC_LARGA AS DELITO_MATERIA,
             S.MOTIV_RECHAZO,
             LSE.DESCRIPCION AS DESC_MOTIV_RECHAZO,
             S.INF_REQUERIDA,
             S.TIPO_BUSQUEDA,
             S.INF_ADICIONAL,
             S.TIPO_RESPUESTA,
             S.MAIL_TO,
             S.IND_ESTADO_MAIL,
             S.FCHA_CORREO
       FROM SECRETO S
      INNER JOIN TIPO_DOCUMENTO TD ON S.TIPO_DOCUMENTO = TD.CODIGO
      INNER JOIN ENTIDAD E ON S.ENTIDAD = E.CODIGO
       LEFT JOIN DELITO D ON D.CODIGO = S.COD_DELITO
       LEFT JOIN LSB_ESTADO LSE ON S.MOTIV_RECHAZO = LSE.CODIGO
      WHERE S.CODIGO = argCODIGO;
   END IF;
   /*Reproceso*/
   IF argFLAG = 13 THEN
      WX_SQL := '';
      WX_WHERE := '';
      WX_SQL := WX_SQL || 'SELECT ';
      WX_SQL := WX_SQL || 'S.FECHA_REGISTRO,E.NOMBRE AS ENTIDAD,S.OFICIO_SBS,S.OFICIO,S.PROCESADO,TD.DESCRIPCION AS TIPO_DOCUMENTO, ';
      WX_SQL := WX_SQL || 'S.NUMERO_DOCUMENTO,S.FECHA_RESPUESTA,S.NRO_CARTA_INF,S.CARTA_ARCHIVO,S.SECUE_CARGA_XLS ';
      WX_SQL := WX_SQL || 'FROM SECRETO S ';
      WX_SQL := WX_SQL || 'LEFT JOIN TIPO_DOCUMENTO TD ON TD.CODIGO = S.TIPO_DOCUMENTO ';
      WX_SQL := WX_SQL || 'LEFT JOIN ENTIDAD E ON E.CODIGO = S.ENTIDAD ';

      WX_WHERE := '';
      --
      IF ARGSECUENCIAPRO = 0  THEN
         IF NOT argFECHA_DESDE IS NULL AND NOT argFECHA_HASTA IS NULL THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'S.FECHA_REGISTRO BETWEEN ''' || argFECHA_DESDE || ''' AND ''' || argFECHA_HASTA || '''';
         END IF;
         IF NOT argSECUENCIA_CARGA IS NULL THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'S.SECUE_CARGA_XLS = ''' || ARGSECUENCIA_CARGA || '''';
         END IF;
         IF NOT argOFICIO IS NULL THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'S.OFICIO = ''' || ARGOFICIO || '''';
         END IF;
      ELSE
         IF NOT ARGFECHA_DESDE IS NULL AND NOT ARGFECHA_HASTA IS NULL THEN
              IF NOT WX_WHERE IS NULL THEN
                 WX_WHERE := WX_WHERE || ' AND ';
              END IF;
              WX_WHERE := WX_WHERE || 'S.FECHA_RESPUESTA BETWEEN ''' || ARGFECHA_DESDE || ''' AND ''' || ARGFECHA_HASTA || '''';
         END IF;
         IF NOT ARGNRO_CARTA_DESDE IS NULL AND NOT ARGNRO_CARTA_HASTA IS NULL THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'S.CORRELATIVO BETWEEN ''' || ARGNRO_CARTA_DESDE || ''' AND ''' || ARGNRO_CARTA_HASTA || '''';
         END IF;
      END IF;

      IF NOT WX_WHERE IS NULL THEN
         WX_SQL := WX_SQL || ' WHERE ' || WX_WHERE;
      END IF;

      OPEN O_RESULT_CURSOR FOR WX_SQL ;
   END IF;
   /*Correlativo de Cartas*/
   IF argFLAG = 14 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT DISTINCT CORRELATIVO
       FROM SECRETO
      WHERE CARTA = 1
      ORDER BY CORRELATIVO DESC;
   END IF;

   /*listado de control con correo*/
   IF argFLAG = 15 THEN
      OPEN O_RESULT_CURSOR FOR
     SELECT D.AGENCIA, D.NOM_AGENCIA, D.NOMB_ENTIDAD,D.DIRECCION, D.ENT_LOCALIDAD, D.TIPO_RESPUESTA,COUNT(D.MAIL_TO) AS TOT_OFICIOS,
            COUNT(D.NRO_CARTA_INF) AS TOT_CARTAS, D.IND_ESTADO_MAIL
       FROM (SELECT E.AGENCIA, E.NOM_AGENCIA, E.NOMBRE AS NOMB_ENTIDAD, E.UBIGEO,
                    E.ENT_LOCALIDAD, E.DIRECCION, S.NRO_CARTA_INF, S.MAIL_TO, (CASE WHEN S.TIPO_RESPUESTA = 2 THEN 1 ELSE 0 END) AS TIPO_RESPUESTA,
                    S.IND_ESTADO_MAIL
                    --, S.OFICIO S.ENTIDAD_EJECUTOR, S.PROCESADO, E.UBIGEO, E.AGE_UBIGEO, E.IMPRIMIR
               FROM SECRETO S
              INNER JOIN (SELECT ENT.CODIGO, ENT.NOMBRE, ENT.DIRECCION, ENT.UBIGEO, UE.NOMBRE AS ENT_LOCALIDAD,
                                 UE.AGENCIA, UE.AGE_UBIGEO, UE.NOM_AGENCIA, NVL(UE.IMPRIMIR,0) AS IMPRIMIR
                            FROM ENTIDAD ENT
                            LEFT JOIN UBIGEO UE ON (UE.CODDPTO = SUBSTR(ENT.UBIGEO,1,2) AND
                                                    UE.CODPROV = SUBSTR(ENT.UBIGEO,3,2) AND
                                                    UE.CODDIST = SUBSTR(ENT.UBIGEO,5,2))) E ON E.CODIGO = S.ENTIDAD
              WHERE S.CARTA = 1
                AND S.FLAG_IMPRESO = 0
                AND S.NUMERO_CUENTA is null
                AND NVL(E.IMPRIMIR,0) = argFLAG_IMPRESO
              GROUP BY E.AGENCIA, E.NOM_AGENCIA, E.NOMBRE, E.UBIGEO, E.ENT_LOCALIDAD, E.DIRECCION, S.NRO_CARTA_INF, S.TIPO_RESPUESTA, S.MAIL_TO,
                       S.IND_ESTADO_MAIL) D
      GROUP BY D.AGENCIA, D.NOM_AGENCIA, D.NOMB_ENTIDAD, D.UBIGEO, D.ENT_LOCALIDAD, D.DIRECCION, D.TIPO_RESPUESTA, D.IND_ESTADO_MAIL
      ORDER BY D.AGENCIA, D.TIPO_RESPUESTA;
   END IF;

   /*QRY para generacion de Cartas*/
   IF argFLAG = 97 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT 1 AS TIPO_CARTA,  --  CLIENTE_CON_CUENTA
            SEC.CODIGO,
            SEC.ENTIDAD_EJECUTOR,
            SEC.ENTIDAD_EJECUTOR_CARGO,
            ENT.NOMBRE AS ENTIDAD_NOMBRE,
            ENT.DIRECCION AS ENTIDAD_DIRECCION,
            ENT.COD_DSTR_JUDICIAL,
            ENT.DESCRIPCION AS ENTIDAD_DSTR_JUDICIAL,
            SEC.OFICIO_SBS,
            SEC.OFICIO,
            SEC.NRO_EXPEDIENTE_REF,
            SEC.PROCESADO,
            TD.DESCRIPCION || ' ' || SEC.NUMERO_DOCUMENTO AS DOI,
            SEC.CLIENTE,
            SEC.FLAG_SALDO,
            SEC.FECHA_DESDE,
            SEC.FECHA_HASTA,
            SEC_CTA.ID_REGISTRO AS ID_SECPROCTA,
            SEC_CTA.CUENTA,
            SEC_CTA.NOM_CUENTA,
            SEC_CTA.RELACION_CUENTA,
            SEC_CTA.MONEDA,
            CASE 
				WHEN SEC_CTA.MONTO_DESEMBOLSADO > 0 THEN SEC_CTA.MONTO_DESEMBOLSADO
				ELSE SEC_CTA.SALDO
			END AS SALDO,
            SEC_CTA.MONTO_DESEMBOLSADO,
            NVL(TO_CHAR(SEC_CTA.FECHA_APERTURA,'DD/MM/YYYY'),'') AS FECHA_APERTURA,
            NVL(TO_CHAR(SEC_CTA.FECHA_CIERRE,'DD/MM/YYYY'),'') AS FECHA_CIERRE,
            SEC_CTA.TIPO_OPERA,
            SEC_CTA.MODULO,
            SEC_CTA.TIP_PRODUCTO,
            SEC_CTA.PLAZO,
            SEC_CTA.TPO_MOVI,
            SEC_CTA.COD_GRUPO_BUSQ,
            SEC_CTA.COD_PRODUCTO,
            SEC_CTA.COD_AUX1,
            SEC_CTA.COD_ESTADO,
            SEC_CTA.ESTADO,
            SEC_CTA.PROC_FECHA,
            SEC_CTA.PROC_HORA,
            SEC_CTA.PROC_USUARIO,
            SEC_CTA.ABRV_MONEDA AS TEXTO_MONEDA,
            SEC.FECHA_RESPUESTA,
            SEC.USUARIO_RESPUESTA,
            SEC.NRO_CARTA_INF,
            SEC.CARTA_ARCHIVO,
            SEC.CORRELATIVO,
            SEC.NUMERADOR_TIPO,
            ENT.CODIGO AS COD_ENTIDAD,
            ENT.UBIGEO,
            ENT.DPTO,
            ENT.PROV,
            ENT.DIST
       FROM SECRETO SEC
      INNER JOIN TIPO_DOCUMENTO  TD ON SEC.TIPO_DOCUMENTO = TD.CODIGO
      INNER JOIN (SELECT E.CODIGO, E.NOMBRE, E.DIRECCION, E.COD_DSTR_JUDICIAL, DJ.DESCRIPCION,
                         E.UBIGEO, UBI_DPTO.NOMBRE AS DPTO, UBI_PROV.NOMBRE AS PROV, UBI_DIST.NOMBRE AS DIST
                    FROM ENTIDAD E
                    LEFT JOIN DISTRITO_JUDICIAL DJ ON E.COD_DSTR_JUDICIAL = DJ.CODIGO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODPROV = '00' AND CODDIST = '00') UBI_DPTO
                         ON SUBSTR(E.UBIGEO,1,2) = UBI_DPTO.CODDPTO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST = '00') UBI_PROV
                         ON SUBSTR(E.UBIGEO,1,4) = (UBI_PROV.CODDPTO || UBI_PROV.CODPROV)
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST <> '00') UBI_DIST
                         ON E.UBIGEO = (UBI_DIST.CODDPTO || UBI_DIST.CODPROV || UBI_DIST.CODDIST)) ENT
            ON SEC.ENTIDAD = ENT.CODIGO
      INNER JOIN (SELECT SPC.ID_REGISTRO, SPC.SECRETO,            SPC.COD_GRUPO_BUSQ,  SPC.COD_PRODUCTO, SPC.COD_AUX1,
                         SPC.CUENTA,      SPC.NOM_CUENTA,         SPC.RELACION_CUENTA, SPC.MONEDA,       SPC.SIGNO,
                         SPC.SALDO,       SPC.MONTO_DESEMBOLSADO, SPC.FECHA_APERTURA,  SPC.FECHA_CIERRE, SPC.TPO_MOVI,
                         SPC.TIPO_OPERA,  SPC.MODULO,             SPC.TIP_PRODUCTO,    SPC.PLAZO,        SPC.COD_ESTADO,
                         SPC.ESTADO,      SPC.PROC_FECHA,         SPC.PROC_HORA,       SPC.PROC_USUARIO, MN.ABRV_MONEDA
                    FROM SECRETO_PRODUCTO_CUENTA SPC
                   INNER JOIN MONEDA MN ON MN.COD_MONEDA = SPC.MONEDA
                   WHERE SPC.CHK_INF = 1) SEC_CTA
            ON SEC.CODIGO = SEC_CTA.SECRETO
      WHERE SEC.ESTADO  = 32
        AND SEC.CLIENTE = 1
        AND SEC.CARTA   = argCARTA
        AND SEC.PRE_CARTA = 1
        AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
      UNION ALL
     SELECT 2 AS TIPO_CARTA,  --  CLIENTE_SIN_CUENTA
            SEC.CODIGO,
            SEC.ENTIDAD_EJECUTOR,
            SEC.ENTIDAD_EJECUTOR_CARGO,
            ENT.NOMBRE AS ENTIDAD_NOMBRE,
            ENT.DIRECCION AS ENTIDAD_DIRECCION,
            ENT.COD_DSTR_JUDICIAL,
            ENT.DESCRIPCION AS ENTIDAD_DSTR_JUDICIAL,
            SEC.OFICIO_SBS,
            SEC.OFICIO,
            SEC.NRO_EXPEDIENTE_REF,
            SEC.PROCESADO,
            TD.DESCRIPCION || ' ' || SEC.NUMERO_DOCUMENTO AS DOI,
            SEC.CLIENTE,
            SEC.FLAG_SALDO,
            SEC.FECHA_DESDE,
            SEC.FECHA_HASTA,
            0 AS ID_SECPROCTA,
            '' AS CUENTA,
            '' AS NOM_CUENTA,
            '' AS RELACION_CUENTA,
            0 AS MONEDA,
            0 AS SALDO,
            0 AS MONTO_DESEMBOLSADO,
            NULL AS FECHA_APERTURA,
            NULL AS FECHA_CIERRE,
            '' AS TIPO_OPERA,
            0 AS MODULO,
            0 AS TIP_PRODUCTO,
            '' AS PLAZO,
            0  AS TPO_MOVI,
            '' AS COD_GRUPO_BUSQ,
            '' AS COD_PRODUCTO,
            '' AS COD_AUX1,
            '' AS COD_ESTADO,
            '' AS ESTADO,
            NULL AS PROC_FECHA,
            '' AS PROC_HORA,
            '' AS PROC_USUARIO,
            '' AS TEXTO_MONEDA,
            SEC.FECHA_RESPUESTA,
            SEC.USUARIO_RESPUESTA,
            SEC.NRO_CARTA_INF,
            SEC.CARTA_ARCHIVO,
            SEC.CORRELATIVO,
            SEC.NUMERADOR_TIPO,
            ENT.CODIGO AS COD_ENTIDAD,
            ENT.UBIGEO,
            ENT.DPTO,
            ENT.PROV,
            ENT.DIST
       FROM SECRETO SEC
      INNER JOIN (SELECT E.CODIGO, E.NOMBRE, E.DIRECCION, E.COD_DSTR_JUDICIAL, DJ.DESCRIPCION,
                         E.UBIGEO, UBI_DPTO.NOMBRE AS DPTO, UBI_PROV.NOMBRE AS PROV, UBI_DIST.NOMBRE AS DIST
                    FROM ENTIDAD E
                    LEFT JOIN DISTRITO_JUDICIAL DJ ON E.COD_DSTR_JUDICIAL = DJ.CODIGO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODPROV = '00' AND CODDIST = '00') UBI_DPTO
                         ON SUBSTR(E.UBIGEO,1,2) = UBI_DPTO.CODDPTO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST = '00') UBI_PROV
                         ON SUBSTR(E.UBIGEO,1,4) = (UBI_PROV.CODDPTO || UBI_PROV.CODPROV)
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST <> '00') UBI_DIST
                         ON E.UBIGEO = (UBI_DIST.CODDPTO || UBI_DIST.CODPROV || UBI_DIST.CODDIST)) ENT
            ON SEC.ENTIDAD = ENT.CODIGO
      INNER JOIN TIPO_DOCUMENTO TD ON SEC.TIPO_DOCUMENTO = TD.CODIGO
      WHERE SEC.ESTADO = 32
        AND SEC.CLIENTE = 1
        AND SEC.CARTA = argCARTA
        AND SEC.PRE_CARTA = 1
        AND  NOT EXISTS (SELECT SECRETO FROM SECRETO_PRODUCTO_CUENTA WHERE SECRETO = SEC.CODIGO AND CHK_INF = 1)
        AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
      UNION ALL
     SELECT 2 AS TIPO_CARTA,  --  NO_CLIENTE
            SEC.CODIGO,
            SEC.ENTIDAD_EJECUTOR,
            SEC.ENTIDAD_EJECUTOR_CARGO,
            ENT.NOMBRE AS ENTIDAD_NOMBRE,
            ENT.DIRECCION AS ENTIDAD_DIRECCION,
            ENT.COD_DSTR_JUDICIAL,
            ENT.DESCRIPCION AS ENTIDAD_DSTR_JUDICIAL,
            SEC.OFICIO_SBS,
            SEC.OFICIO,
            SEC.NRO_EXPEDIENTE_REF,
            SEC.PROCESADO,
            TD.DESCRIPCION || ' ' || SEC.NUMERO_DOCUMENTO AS DOI,
            SEC.CLIENTE,
            SEC.FLAG_SALDO,
            SEC.FECHA_DESDE,
            SEC.FECHA_HASTA,
            0 AS ID_SECPROCTA,
            '' AS CUENTA,
            '' AS NOM_CUENTA,
            '' AS RELACION_CUENTA,
            0 AS MONEDA,
            0 AS SALDO,
            0 AS MONTO_DESEMBOLSADO,
            NULL AS FECHA_APERTURA,
            NULL AS FECHA_CIERRE,
            '' AS TIPO_OPERA,
            0 AS MODULO,
            0 AS TIP_PRODUCTO,
            '' AS PLAZO,
            0  AS TPO_MOVI,
            '' AS COD_GRUPO_BUSQ,
            '' AS COD_PRODUCTO,
            '' AS COD_AUX1,
            '' AS COD_ESTADO,
            '' AS ESTADO,
            NULL AS PROC_FECHA,
            '' AS PROC_HORA,
            '' AS PROC_USUARIO,
            '' AS TEXTO_MONEDA,
            SEC.FECHA_RESPUESTA,
            SEC.USUARIO_RESPUESTA,
            SEC.NRO_CARTA_INF,
            SEC.CARTA_ARCHIVO,
            SEC.CORRELATIVO,
            SEC.NUMERADOR_TIPO,
            ENT.CODIGO AS COD_ENTIDAD,
            ENT.UBIGEO,
            ENT.DPTO,
            ENT.PROV,
            ENT.DIST
       FROM SECRETO SEC
      INNER JOIN (SELECT E.CODIGO, E.NOMBRE, E.DIRECCION, E.COD_DSTR_JUDICIAL, DJ.DESCRIPCION,
                         E.UBIGEO, UBI_DPTO.NOMBRE AS DPTO, UBI_PROV.NOMBRE AS PROV, UBI_DIST.NOMBRE AS DIST
                    FROM ENTIDAD E
                    LEFT JOIN DISTRITO_JUDICIAL DJ ON E.COD_DSTR_JUDICIAL = DJ.CODIGO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODPROV = '00' AND CODDIST = '00') UBI_DPTO
                         ON SUBSTR(E.UBIGEO,1,2) = UBI_DPTO.CODDPTO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST = '00') UBI_PROV
                         ON SUBSTR(E.UBIGEO,1,4) = (UBI_PROV.CODDPTO || UBI_PROV.CODPROV)
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST <> '00') UBI_DIST
                         ON E.UBIGEO = (UBI_DIST.CODDPTO || UBI_DIST.CODPROV || UBI_DIST.CODDIST)) ENT
            ON SEC.ENTIDAD = ENT.CODIGO
      INNER JOIN TIPO_DOCUMENTO TD ON SEC.TIPO_DOCUMENTO = TD.CODIGO
      WHERE SEC.ESTADO = 32
        AND SEC.CLIENTE = 0
        AND SEC.CARTA = argCARTA
        AND SEC.PRE_CARTA = 1
        AND SEC.HOMONIMIA = 0
        AND SEC.INCOMPLETO = 0
        AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
      UNION ALL
     SELECT 4 AS TIPO_CARTA,  --  Homonimia
            SEC.CODIGO,
            SEC.ENTIDAD_EJECUTOR,
            SEC.ENTIDAD_EJECUTOR_CARGO,
            ENT.NOMBRE AS ENTIDAD_NOMBRE,
            ENT.DIRECCION AS ENTIDAD_DIRECCION,
            ENT.COD_DSTR_JUDICIAL,
            ENT.DESCRIPCION AS ENTIDAD_DSTR_JUDICIAL,
            SEC.OFICIO_SBS,
            SEC.OFICIO,
            SEC.NRO_EXPEDIENTE_REF,
            SEC.PROCESADO,
            TD.DESCRIPCION || ' ' || SEC.NUMERO_DOCUMENTO AS DOI,
            SEC.CLIENTE,
            SEC.FLAG_SALDO,
            SEC.FECHA_DESDE,
            SEC.FECHA_HASTA,
            0 AS ID_SECPROCTA,
            '' AS CUENTA,
            '' AS NOM_CUENTA,
            '' AS RELACION_CUENTA,
            0 AS MONEDA,
            0 AS SALDO,
            0 AS MONTO_DESEMBOLSADO,
            NULL AS FECHA_APERTURA,
            NULL AS FECHA_CIERRE,
            '' AS TIPO_OPERA,
            0 AS MODULO,
            0 AS TIP_PRODUCTO,
            '' AS PLAZO,
            0  AS TPO_MOVI,
            '' AS COD_GRUPO_BUSQ,
            '' AS COD_PRODUCTO,
            '' AS COD_AUX1,
            '' AS COD_ESTADO,
            '' AS ESTADO,
            NULL AS PROC_FECHA,
            '' AS PROC_HORA,
            '' AS PROC_USUARIO,
            '' AS TEXTO_MONEDA,
            SEC.FECHA_RESPUESTA,
            SEC.USUARIO_RESPUESTA,
            SEC.NRO_CARTA_INF,
            SEC.CARTA_ARCHIVO,
            SEC.CORRELATIVO,
            SEC.NUMERADOR_TIPO,
            ENT.CODIGO AS COD_ENTIDAD,
            ENT.UBIGEO,
            ENT.DPTO,
            ENT.PROV,
            ENT.DIST
       FROM SECRETO SEC
      INNER JOIN TIPO_DOCUMENTO  TD ON SEC.TIPO_DOCUMENTO = TD.CODIGO
      INNER JOIN (SELECT E.CODIGO, E.NOMBRE, E.DIRECCION, E.COD_DSTR_JUDICIAL, DJ.DESCRIPCION,
                         E.UBIGEO, UBI_DPTO.NOMBRE AS DPTO, UBI_PROV.NOMBRE AS PROV, UBI_DIST.NOMBRE AS DIST
                    FROM ENTIDAD E
                    LEFT JOIN DISTRITO_JUDICIAL DJ ON E.COD_DSTR_JUDICIAL = DJ.CODIGO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODPROV = '00' AND CODDIST = '00') UBI_DPTO
                         ON SUBSTR(E.UBIGEO,1,2) = UBI_DPTO.CODDPTO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST = '00') UBI_PROV
                         ON SUBSTR(E.UBIGEO,1,4) = (UBI_PROV.CODDPTO || UBI_PROV.CODPROV)
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST <> '00') UBI_DIST
                         ON E.UBIGEO = (UBI_DIST.CODDPTO || UBI_DIST.CODPROV || UBI_DIST.CODDIST)) ENT
            ON SEC.ENTIDAD = ENT.CODIGO
      WHERE SEC.ESTADO  = 32
        AND SEC.CLIENTE = 0
        AND SEC.CARTA   = argCARTA
        AND SEC.PRE_CARTA = 1
        AND SEC.HOMONIMIA = 1
        AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
      UNION ALL
     SELECT 5 AS TIPO_CARTA,  --  Datos Incompletos
            SEC.CODIGO,
            SEC.ENTIDAD_EJECUTOR,
            SEC.ENTIDAD_EJECUTOR_CARGO,
            ENT.NOMBRE AS ENTIDAD_NOMBRE,
            ENT.DIRECCION AS ENTIDAD_DIRECCION,
            ENT.COD_DSTR_JUDICIAL,
            ENT.DESCRIPCION AS ENTIDAD_DSTR_JUDICIAL,
            SEC.OFICIO_SBS,
            SEC.OFICIO,
            SEC.NRO_EXPEDIENTE_REF,
            SEC.PROCESADO,
            TD.DESCRIPCION || ' ' || SEC.NUMERO_DOCUMENTO AS DOI,
            SEC.CLIENTE,
            SEC.FLAG_SALDO,
            SEC.FECHA_DESDE,
            SEC.FECHA_HASTA,
            0 AS ID_SECPROCTA,
            '' AS CUENTA,
            '' AS NOM_CUENTA,
            '' AS RELACION_CUENTA,
            0 AS MONEDA,
            0 AS SALDO,
            0 AS MONTO_DESEMBOLSADO,
            NULL AS FECHA_APERTURA,
            NULL AS FECHA_CIERRE,
            '' AS TIPO_OPERA,
            0 AS MODULO,
            0 AS TIP_PRODUCTO,
            '' AS PLAZO,
            0 AS TPO_MOVI,
            '' AS COD_GRUPO_BUSQ,
            '' AS COD_PRODUCTO,
            '' AS COD_AUX1,
            '' AS COD_ESTADO,
            '' AS ESTADO,
            NULL AS PROC_FECHA,
            '' AS PROC_HORA,
            '' AS PROC_USUARIO,
            '' AS TEXTO_MONEDA,
            SEC.FECHA_RESPUESTA,
            SEC.USUARIO_RESPUESTA,
            SEC.NRO_CARTA_INF,
            SEC.CARTA_ARCHIVO,
            SEC.CORRELATIVO,
            SEC.NUMERADOR_TIPO,
            ENT.CODIGO AS COD_ENTIDAD,
            ENT.UBIGEO,
            ENT.DPTO,
            ENT.PROV,
            ENT.DIST
       FROM SECRETO SEC
      INNER JOIN TIPO_DOCUMENTO  TD ON SEC.TIPO_DOCUMENTO = TD.CODIGO
      INNER JOIN (SELECT E.CODIGO, E.NOMBRE, E.DIRECCION, E.COD_DSTR_JUDICIAL, DJ.DESCRIPCION,
                         E.UBIGEO, UBI_DPTO.NOMBRE AS DPTO, UBI_PROV.NOMBRE AS PROV, UBI_DIST.NOMBRE AS DIST
                    FROM ENTIDAD E
                    LEFT JOIN DISTRITO_JUDICIAL DJ ON E.COD_DSTR_JUDICIAL = DJ.CODIGO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODPROV = '00' AND CODDIST = '00') UBI_DPTO
                         ON SUBSTR(E.UBIGEO,1,2) = UBI_DPTO.CODDPTO
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST = '00') UBI_PROV
                         ON SUBSTR(E.UBIGEO,1,4) = (UBI_PROV.CODDPTO || UBI_PROV.CODPROV)
                    LEFT JOIN (SELECT CODDPTO, CODPROV, CODDIST, NOMBRE FROM UBIGEO WHERE CODDIST <> '00') UBI_DIST
                         ON E.UBIGEO = (UBI_DIST.CODDPTO || UBI_DIST.CODPROV || UBI_DIST.CODDIST)) ENT
            ON SEC.ENTIDAD = ENT.CODIGO
      WHERE SEC.ESTADO  = 32
        AND SEC.CLIENTE = 0
        AND SEC.CARTA   = argCARTA
        AND SEC.PRE_CARTA = 1
        AND SEC.INCOMPLETO = 1
        AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END;
   END IF;
   /*Estadistico*/
   IF argFLAG = 20 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT SUM(ORIGEN_REG1 + ORIGEN_REG2 + ORIGEN_REG3) AS OFICIO_REG,
            SUM(ORIGEN_REG1) AS ORIGEN_REG1,
            SUM(ORIGEN_REG2) AS ORIGEN_REG2,
            SUM(ORIGEN_REG3) AS ORIGEN_REG3,
            SUM(CLIENTE) AS CLIENTE,
            SUM(CLIENTE_CON_CUENTA) AS CLIENTE_CON_CUENTA,
            SUM(CLIENTE_SIN_CUENTA) AS CLIENTE_SIN_CUENTA,
            SUM(NO_CLIENTE) AS NO_CLIENTE,
            SUM(CLIENTE + NO_CLIENTE) AS TOTAL_REG
      FROM (SELECT COUNT(SEC.PROCESADO) AS ORIGEN_REG1, /*Registrados*/
                   0 AS ORIGEN_REG2,
                   0 AS ORIGEN_REG3,
                   SUM(CASE WHEN SEC.CLIENTE = 1 THEN 1 ELSE 0 END) AS CLIENTE,
                   0 AS CLIENTE_CON_CUENTA,
                   0 AS CLIENTE_SIN_CUENTA,
                   SUM(CASE WHEN SEC.CLIENTE = 0 THEN 1 ELSE 0 END) AS NO_CLIENTE,
                   0 AS CARTAS_RECHAZADAS
              FROM SECRETO  SEC
             WHERE SEC.ORIG_REG = 1
               AND SEC.PROC_FECHA BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                          TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
               AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
             UNION ALL
            SELECT 0 AS ORIGEN_REG1,
                   COUNT(SEC.PROCESADO) AS ORIGEN_REG2, /*Individual*/
                   0 AS ORIGEN_REG3,
                   SUM(CASE WHEN SEC.CLIENTE = 1 THEN 1 ELSE 0 END) AS CLIENTE,
                   0 AS CLIENTE_CON_CUENTA,
                   0 AS CLIENTE_SIN_CUENTA,
                   SUM(CASE WHEN SEC.CLIENTE = 0 THEN 1 ELSE 0 END) AS NO_CLIENTE,
                   0 AS CARTAS_RECHAZADAS
              FROM SECRETO  SEC
             WHERE SEC.ORIG_REG =  2
               AND SEC.PROC_FECHA BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                          TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
               AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
             UNION ALL
            SELECT 0 AS ORIGEN_REG1,
                   0 AS ORIGEN_REG2,
                   COUNT(SEC.PROCESADO) AS ORIGEN_REG3,  /*SecBan*/
                   SUM(CASE WHEN SEC.CLIENTE = 1 THEN 1 ELSE 0 END) AS CLIENTE,
                   0 AS CLIENTE_CON_CUENTA,
                   0 AS CLIENTE_SIN_CUENTA,
                   SUM(CASE WHEN SEC.CLIENTE = 0 THEN 1 ELSE 0 END) AS NO_CLIENTE,
                   0 AS CARTAS_RECHAZADAS
              FROM  SECRETO  SEC
             WHERE SEC.ORIG_REG =  3
               AND SEC.PROC_FECHA BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                          TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
               AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
             UNION ALL
            SELECT 0 AS ORIGEN_REG1,  /*Cliente C/Ctas*/
                   0 AS ORIGEN_REG2,
                   0 AS ORIGEN_REG3,
                   0 AS CLIENTE,
                   COUNT(SEC.PROCESADO) AS CLIENTE_CON_CUENTA,
                   0 AS CLIENTE_SIN_CUENTA,
                   0 AS NO_CLIENTE,
                   0 AS CARTAS_RECHAZADAS
              FROM  SECRETO  SEC
             WHERE SEC.ESTADO  =  32
               AND SEC.CLIENTE =  1
               AND SEC.PROC_FECHA BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                          TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
               AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
               AND EXISTS (SELECT SECRETO FROM SECRETO_PRODUCTO_CUENTA WHERE SECRETO = SEC.CODIGO)
             UNION ALL
            SELECT 0 AS ORIGEN_REG1,  /*Cliente S/Ctas*/
                   0 AS ORIGEN_REG2,
                   0 AS ORIGEN_REG3,
                   0 AS CLIENTE,
                   0 AS CLIENTE_CON_CUENTA,
                   COUNT(SEC.PROCESADO) AS CLIENTE_SIN_CUENTA,
                   0 AS NO_CLIENTE,
                   0 AS CARTAS_RECHAZADAS
              FROM SECRETO  SEC
             WHERE SEC.ESTADO  =  32 AND
                   SEC.CLIENTE  =  1  AND
                   SEC.PROC_FECHA BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                          TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
               AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
               AND NOT EXISTS (SELECT SECRETO FROM SECRETO_PRODUCTO_CUENTA WHERE SECRETO = SEC.CODIGO)
             )  TABLA;
   END IF;
   /*Estadistico Productos*/
   IF argFLAG = 21 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT SPC.COD_PRODUCTO, SPC.NOM_CUENTA ,COUNT(*) AS CANT_PRD
       FROM SECRETO_PRODUCTO_CUENTA SPC
      INNER JOIN (SELECT S.CODIGO FROM SECRETO S
                   WHERE S.ESTADO = 32
                     AND S.CLIENTE = 1
                     AND S.PROC_FECHA BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                              TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
                     AND S.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN S.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
                 ) SE
                 ON SE.CODIGO = SPC.SECRETO
      GROUP BY SPC.COD_PRODUCTO, SPC.NOM_CUENTA;
   END IF;
   /*Estadisticos Cartas*/
   IF argFLAG = 22 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT COUNT(CART.NRO_CARTA_INF) AS TOT_CART,
            NVL(SUM(CASE WHEN CART.FLAG_IMPRESO = 1 THEN 1 ELSE 0 END),0) AS IMPRESO,
            NVL(SUM(CASE WHEN CART.MOTIV_RECHAZO IS NULL THEN 0 ELSE 1 END),0) AS RECHAZADO
       FROM (SELECT SEC.NRO_CARTA_INF, SEC.FLAG_IMPRESO, SEC.MOTIV_RECHAZO
               FROM SECRETO SEC
              WHERE SEC.CARTA = 1
                AND SEC.PROC_FECHA BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                           TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
                AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
              GROUP BY SEC.NRO_CARTA_INF, SEC.FLAG_IMPRESO, SEC.MOTIV_RECHAZO) CART;
   END IF;

   /*Consulta Resumen Proceso*/
   IF argFLAG = 23 THEN
     OPEN O_RESULT_CURSOR FOR
     SELECT TRUNC(FECHA_REG) AS FECHA_REG,
            USUARIO_REGISTRO,
            SUM(ORIGEN_REG1 + ORIGEN_REG2 + ORIGEN_REG3) AS TOTAL_REG,
            SUM(CLIENTE) AS CLIENTE,
            SUM(CORREO_AUT) AS CORREO_AUT,
            SUM(CARTA_AUT) AS CARTA_AUT,
            SUM(REG_CORREO_AUT) AS REG_CORREO_AUT,
            SUM(CORREO_AGE) AS CORREO_AGE,
            SUM(CARTA_AGE) AS CARTA_AGE,
            SUM(REG_CORREO_AGE) AS REG_CORREO_AGE,
            SUM(REG_CORREO_AUT + REG_CORREO_AGE) AS TOT_REG_CORREO,
            SUM(REG_CARTA_AUT) AS REG_CARTA_AUT,
            SUM(REG_CARTA_AGE) AS REG_CARTA_AGE,
            SUM(CARTA_FIS) AS CARTA_FIS,
            SUM(REG_CARTA_FIS) AS REG_CARTA_FIS,
            SUM(REG_CARTA_AUT + REG_CARTA_AGE + REG_CARTA_FIS) AS TOT_REG_CARTA,
            SUM(CARTA_AUT + CARTA_AGE + CARTA_FIS) AS TOTAL_CARTA,
            SUM(RECHAZADO) AS RECHAZADO,
            SUM(ORIGEN_REG1) AS ORIGEN_REG1,
            SUM(ORIGEN_REG2) AS ORIGEN_REG2,
            SUM(ORIGEN_REG3) AS ORIGEN_REG3,
            SUM(NO_CLIENTE) AS NO_CLIENTE,
            SUM(CLIENTE + NO_CLIENTE) AS TOTAL_CLI,
            SUM(SIN_CORREO) AS SIN_CORREO,
            SUM(CORREO_AUT + CORREO_AGE + SIN_CORREO) AS TOTAL_EMAIL

      FROM(
            SELECT TO_DATE(FECHA_REGISTRO,'dd/MM/yy') AS FECHA_REG,
                   SEC.USUARIO_REGISTRO,
                   COUNT(SEC.PROCESADO) AS ORIGEN_REG1, /*Individual*/
                   0 AS ORIGEN_REG2,
                   0 AS ORIGEN_REG3,
                   NVL(SUM(CASE WHEN SEC.CLIENTE = 1 THEN 1 ELSE 0 END),0) AS CLIENTE,
                   NVL(SUM(CASE WHEN SEC.CLIENTE = 0 THEN 1 ELSE 0 END),0) AS NO_CLIENTE,
                   0 AS CORREO_AUT,
                   0 AS REG_CORREO_AUT,
                   NVL(SUM(CASE WHEN SEC.TIPO_RESPUESTA = 1 AND SEC.MAIL_TO IS NOT NULL  THEN 1 ELSE 0 END),0) AS CORREO_AGE,
                   0 AS REG_CORREO_AGE,
                   0 AS SIN_CORREO,
                   0 AS REG_SIN_CORREO,
                   0 AS TOT_CART,
                   0 AS RECHAZADO,
                   0 AS REG_RECHAZADO,
                   0 AS CARTA_AUT,
                   0 AS REG_CARTA_AUT,
                   0 AS CARTA_AGE,
                   0 AS REG_CARTA_AGE,
                   0 AS CARTA_FIS,
                   0 AS REG_CARTA_FIS
              FROM SECRETO  SEC
              WHERE SEC.ORIG_REG = 1
                AND SEC.FECHA_REGISTRO BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                               TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
               AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
               GROUP BY SEC.FECHA_REGISTRO, SEC.USUARIO_REGISTRO
             UNION ALL
            SELECT TO_DATE(FECHA_REGISTRO,'dd/MM/yy') AS FECHA_REG,
                   SEC.USUARIO_REGISTRO,
                   0 AS ORIGEN_REG1,
                   COUNT(SEC.PROCESADO) AS ORIGEN_REG2, /*Masivo*/
                   0 AS ORIGEN_REG3,
                   NVL(SUM(CASE WHEN SEC.CLIENTE = 1 THEN 1 ELSE 0 END),0) AS CLIENTE,
                   NVL(SUM(CASE WHEN SEC.CLIENTE = 0 THEN 1 ELSE 0 END),0) AS NO_CLIENTE,
                   0 AS CORREO_AUT,
                   0 AS REG_CORREO_AUT,
                   NVL(SUM(CASE WHEN SEC.TIPO_RESPUESTA = 1 AND SEC.MAIL_TO IS NOT NULL  THEN 1 ELSE 0 END),0) AS CORREO_AGE,
                   0 AS REG_CORREO_AGE,
                   0 AS SIN_CORREO,
                   0 AS REG_SIN_CORREO,
                   0 AS TOT_CART,
                   0 AS RECHAZADO,
                   0 AS REG_RECHAZADO,
                   0 AS CARTA_AUT,
                   0 AS REG_CARTA_AUT,
                   0 AS CARTA_AGE,
                   0 AS REG_CARTA_AGE,
                   0 AS CARTA_FIS,
                   0 AS REG_CARTA_FIS
              FROM SECRETO  SEC
              WHERE SEC.ORIG_REG =  2
                AND SEC.FECHA_REGISTRO BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                               TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
                AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
                GROUP BY SEC.FECHA_REGISTRO, SEC.USUARIO_REGISTRO
             UNION ALL
             SELECT TO_DATE(FECHA_REGISTRO,'dd/MM/yy') AS FECHA_REG,
                    SEC.USUARIO_REGISTRO,
                    0 AS ORIGEN_REG1,
                    0 AS ORIGEN_REG2,
                    COUNT(SEC.PROCESADO) AS ORIGEN_REG3,  /*SecBan*/
                    NVL(SUM(CASE WHEN SEC.CLIENTE = 1 THEN 1 ELSE 0 END),0) AS CLIENTE,
                    NVL(SUM(CASE WHEN SEC.CLIENTE = 0 THEN 1 ELSE 0 END),0) AS NO_CLIENTE,
                    0 AS CORREO_AUT,
                    0 AS REG_CORREO_AUT,
                    0 AS CORREO_AGE,
                    0 AS REG_CORREO_AGE,
                    0 AS SIN_CORREO,
                    0 AS REG_SIN_CORREO,
                    0 AS TOT_CART,
                    0 AS RECHAZADO,
                    0 AS REG_RECHAZADO,
                    0 AS CARTA_AUT,
                    0 AS REG_CARTA_AUT,
                    0 AS CARTA_AGE,
                    0 AS REG_CARTA_AGE,
                    0 AS CARTA_FIS,
                    0 AS REG_CARTA_FIS
              FROM  SECRETO  SEC
              WHERE SEC.ORIG_REG =  3
               AND SEC.FECHA_REGISTRO BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                              TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
               AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
               GROUP BY SEC.FECHA_REGISTRO, SEC.USUARIO_REGISTRO
              UNION ALL
               SELECT TO_DATE(FECHA_REGISTRO,'dd/MM/yy') AS FECHA_REG,
                      USUARIO_REGISTRO,
                      0 AS ORIGEN_REG1,
                      0 AS ORIGEN_REG2,
                      0 AS ORIGEN_REG3,
                      0 AS CLIENTE,
                      0 AS NO_CLIENTE,
                      0 AS CORREO_AUT,
                      0 AS REG_CORREO_AUT,
                      0 AS CORREO_AGE,
                      0 AS REG_CORREO_AGE,
                      0 AS SIN_CORREO,
                      0 AS REG_SIN_CORREO,
                   COUNT(CART.NRO_CARTA_INF) AS TOT_CART, /*Cartas Generadas*/
                   NVL(SUM(CASE WHEN CART.MOTIV_RECHAZO IS NULL THEN 0 ELSE 1 END),0) AS RECHAZADO,
                   0 AS REG_RECHAZADO,
                   NVL(SUM(CASE WHEN CART.TIPO_RESPUESTA = 2 THEN 1 ELSE 0 END),0) AS CARTA_AUT,
                   0 AS REG_CARTA_AUT,
                   NVL(SUM(CASE WHEN CART.TIPO_RESPUESTA = 1 AND CART.MAIL_TO IS NOT NULL  THEN 1 ELSE 0 END), 0) AS CARTA_AGE,
                   0 AS REG_CARTA_AGE,
                   NVL(SUM(CASE WHEN CART.TIPO_RESPUESTA = 1 AND CART.MAIL_TO IS NULL  THEN 1 ELSE 0 END),0) AS CARTA_FIS,
                   0 AS REG_CARTA_FIS
              FROM (SELECT SEC.FECHA_REGISTRO, SEC.USUARIO_REGISTRO, SEC.NRO_CARTA_INF, SEC.FLAG_IMPRESO, SEC.MOTIV_RECHAZO, SEC.MAIL_TO, SEC.TIPO_RESPUESTA
               FROM SECRETO SEC
              WHERE SEC.CARTA = 1
                AND SEC.FECHA_REGISTRO BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                               TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
                AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
              GROUP BY SEC.FECHA_REGISTRO, SEC.USUARIO_REGISTRO, SEC.NRO_CARTA_INF, SEC.FLAG_IMPRESO, SEC.MOTIV_RECHAZO, SEC.MAIL_TO, SEC.TIPO_RESPUESTA) CART
              GROUP BY CART.FECHA_REGISTRO, CART.USUARIO_REGISTRO
             UNION ALL
              SELECT TO_DATE(FECHA_REGISTRO,'dd/MM/yy') AS FECHA_REG,
                      USUARIO_REGISTRO,
                      0 AS ORIGEN_REG1,
                      0 AS ORIGEN_REG2,
                      0 AS ORIGEN_REG3,
                      0 AS CLIENTE,
                      0 AS NO_CLIENTE,
                      NVL(SUM(CASE WHEN CART.TIPO_RESPUESTA = 2 THEN 1 ELSE 0 END),0) AS CORREO_AUT, /*Correo Autoridad*/
                      0 AS REG_CORREO_AUT,
                      0 AS CORREO_AGE,
                      0 AS REG_CORREO_AGE,
                      0 AS SIN_CORREO,
                      0 AS REG_SIN_CORREO,
                      0 AS TOT_CART,
                      0 AS RECHAZADO,
                      0 AS REG_RECHAZADO,
                      0 AS CARTA_AUT,
                      0 AS REG_CARTA_AUT,
                      0 AS CARTA_AGE,
                      0 AS REG_CARTA_AGE,
                      0 AS CARTA_FIS,
                      0 AS REG_CARTA_FIS
              FROM (SELECT SEC.FECHA_REGISTRO, SEC.NRO_CARTA_INF, SEC.USUARIO_REGISTRO, SEC.MAIL_TO, SEC.TIPO_RESPUESTA
               FROM SECRETO SEC
              WHERE SEC.CARTA = 1
                AND SEC.FECHA_REGISTRO BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                               TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
                AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
                AND TIPO_RESPUESTA = 2
              GROUP BY SEC.FECHA_REGISTRO, SEC.NRO_CARTA_INF, SEC.USUARIO_REGISTRO, SEC.MAIL_TO, SEC.TIPO_RESPUESTA) CART
              GROUP BY CART.FECHA_REGISTRO, CART.USUARIO_REGISTRO
             UNION ALL
              SELECT TO_DATE(FECHA_REGISTRO,'dd/MM/yy') AS FECHA_REG,
                      USUARIO_REGISTRO,
                      0 AS ORIGEN_REG1,
                      0 AS ORIGEN_REG2,
                      0 AS ORIGEN_REG3,
                      0 AS CLIENTE,
                      0 AS NO_CLIENTE,
                      0 AS CORREO_AUT,
                      0 AS REG_CORREO_AUT,
                      NVL(SUM(CASE WHEN CART.TIPO_RESPUESTA = 1 AND CART.MAIL_TO IS NOT NULL  THEN 1 ELSE 0 END), 0) AS CORREO_AGE, /*Correo Agencia*/
                      0 AS REG_CORREO_AGE,
                      NVL(SUM(CASE WHEN CART.TIPO_RESPUESTA = 1 AND CART.MAIL_TO IS NULL  THEN 1 ELSE 0 END),0) AS SIN_CORREO,
                      0 AS REG_SIN_CORREO,
                      0 AS TOT_CART,
                      0 AS RECHAZADO,
                      0 AS REG_RECHAZADO,
                      0 AS CARTA_AUT,
                      0 AS REG_CARTA_AUT,
                      0 AS CARTA_AGE,
                      0 AS REG_CARTA_AGE,
                      0 AS CARTA_FIS,
                      0 AS REG_CARTA_FIS
              FROM (SELECT SEC.FECHA_REGISTRO, SEC.USUARIO_REGISTRO, SEC.MAIL_TO, SEC.TIPO_RESPUESTA
                    FROM SECRETO SEC
                    WHERE SEC.CARTA = 1
                      AND SEC.FECHA_REGISTRO BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                                     TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
                      AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
                      AND TIPO_RESPUESTA = 1
              GROUP BY SEC.FECHA_REGISTRO, SEC.USUARIO_REGISTRO, SEC.MAIL_TO, SEC.TIPO_RESPUESTA) CART
              GROUP BY CART.FECHA_REGISTRO, CART.USUARIO_REGISTRO
             UNION ALL
              SELECT TO_DATE(FECHA_REGISTRO,'dd/MM/yy') AS FECHA_REG,
                     SEC.USUARIO_REGISTRO,
                     0 AS ORIGEN_REG1,
                     0 AS ORIGEN_REG2,
                     0 AS ORIGEN_REG3,
                     0 AS CLIENTE,
                     0 AS NO_CLIENTE,
                     0 AS CORREO_AUT,
                     NVL(SUM(CASE WHEN SEC.TIPO_RESPUESTA = 2 THEN 1 ELSE 0 END),0) AS REG_CORREO_AUT, /*Registros Correo*/
                     0 AS CORREO_AGE,
                     NVL(SUM(CASE WHEN SEC.TIPO_RESPUESTA = 1 AND SEC.MAIL_TO IS NOT NULL  THEN 1 ELSE 0 END),0) AS REG_CORREO_AGE,
                     0 AS SIN_CORREO,
                     NVL(SUM(CASE WHEN SEC.TIPO_RESPUESTA = 1 AND SEC.MAIL_TO IS NULL  THEN 1 ELSE 0 END),0) AS REG_SIN_CORREO,
                     0 AS TOT_CART,
                     0 AS RECHAZADO,
                     NVL(SUM(CASE WHEN SEC.MOTIV_RECHAZO IS NULL THEN 0 ELSE 1 END),0) AS REG_RECHAZADO, /*Registros Cartas*/
                     0 AS CARTA_AUT,
                     NVL(SUM(CASE WHEN SEC.TIPO_RESPUESTA = 2 THEN 1 ELSE 0 END),0) AS REG_CARTA_AUT,
                     0 AS CARTA_AGE,
                     NVL(SUM(CASE WHEN SEC.TIPO_RESPUESTA = 1 AND SEC.MAIL_TO IS NOT NULL  THEN 1 ELSE 0 END), 0) AS REG_CARTA_AGE,
                     0 AS CARTA_FIS,
                     NVL(SUM(CASE WHEN SEC.TIPO_RESPUESTA = 1 AND SEC.MAIL_TO IS NULL  THEN 1 ELSE 0 END),0) AS REG_CARTA_FIS
               FROM  SECRETO  SEC
               WHERE SEC.ORIG_REG =  3
                 AND SEC.FECHA_REGISTRO BETWEEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') AND
                                                TO_DATE(argFECHA_HASTA,'dd/MM/yyyy')
                 AND SEC.NUMERADOR_TIPO = CASE WHEN argNRO_CARTA_TIP = 0 THEN SEC.NUMERADOR_TIPO ELSE argNRO_CARTA_TIP END
                 AND SEC.CARTA = 1
               GROUP BY SEC.FECHA_REGISTRO, SEC.USUARIO_REGISTRO

              ) TABLA
              GROUP BY FECHA_REG, USUARIO_REGISTRO
              ORDER BY FECHA_REG desc;
   END IF;
   /*Valida Duplicados*/
   IF argFLAG = 99 THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT COUNT(*) AS CANTIDAD
       FROM SECRETO
      WHERE ENTIDAD           = argENTIDAD
        AND UPPER(OFICIO_SBS) = UPPER(argOFICIO_SBS)
        AND UPPER(OFICIO)     = UPPER(argOFICIO)
        AND NVL(UPPER(NRO_EXPEDIENTE_REF),' ') = NVL(UPPER(argNROEXPEDIENTE_SECBAN),' ')
        AND UPPER(PROCESADO)  = UPPER(argPROCESADO);
   END IF;

 EXCEPTION
  WHEN wERROR_PERSO THEN
    RAISE_APPLICATION_ERROR(-20201, wERROR_DESCRIP);
  WHEN OTHERS THEN
    OUTVAL := 0;
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE||' - '||SQLERRM);
    RAISE_APPLICATION_ERROR(-20001,'ERROR - '||SQLCODE||' - '||SQLERRM);
 END;

 PROCEDURE UP_SECRETO_DEL
  (argFLAG                      NUMBER,
   argCODIGO                    NUMBER,
   argSECUENCIAOFI              NUMBER,
   argSECUENCIAPRO              NUMBER,
   argENTIDAD                   NUMBER,
   argENTIDADNOMBRE             VARCHAR2,
   argENTIDAD_EJECUTOR          VARCHAR2,
   argENTIDAD_EJECUTOR_CARGO    VARCHAR2,
   argINFO_ADICIONAL            VARCHAR2,
   argINFO_REQUERIDA            VARCHAR2,
   argPLAZO_ATENCION            VARCHAR2,
   argOFICIO_SBS                VARCHAR2,
   argNUMERO                    VARCHAR2,
   argOFICIO                    VARCHAR2,
   argAPE_PAT                   VARCHAR2,
   argAPE_MAT                   VARCHAR2,
   argNOMBRES                   VARCHAR2,
   argPROCESADO                 VARCHAR2,
   argTIPO_DOCUMENTO            NUMBER,
   argNUMERO_DOCUMENTO          VARCHAR2,
   argTIPO_PERSONA              VARCHAR2,
   argNUMERO_CUENTA             VARCHAR2,
   argCLIENTE                   NUMBER,
   argCARTA                     NUMBER,
   argHOMONIMIA                 NUMBER,
   argINCOMPLETO                NUMBER,
   argFLAG_SALDO                NUMBER,
   argESTADO                    NUMBER,
   argUSUARIO_REGISTRO          VARCHAR2,
   argFECHA_DESDE               VARCHAR2,
   argFECHA_HASTA               VARCHAR2,
   argFECHA_SECRETO             VARCHAR2,
   argFECHA_RESPUESTA           VARCHAR2,
   argUSUARIO_RESPUESTA         VARCHAR2,
   argFECHA_RECEPCION           VARCHAR2,
   argNRO_CARTA_INF             VARCHAR2,
   argNRO_CARTA_TIP             NUMBER,
   argCOD_CLIENTE               VARCHAR2,
   argFECHA_ING_ENTIDAD         VARCHAR2,
   argPRODUCTO                  VARCHAR2,
   argNRO_CARTA_DESDE           VARCHAR2,
   argNRO_CARTA_HASTA           VARCHAR2,
   argFECHA_DESPACHO            VARCHAR2,
   argFECHA_ENTREGA             VARCHAR2,
   argMOTIV_RECHZO              NUMBER,
   argSECUENCIA_CARGA           VARCHAR2,
   argPROC_FECHA                VARCHAR2,
   argPROC_HORA                 VARCHAR2,
   argPROC_USUARIO              VARCHAR2,
   argCORRELATIVO               VARCHAR2,
   argTIPODOI_SECBAN            VARCHAR2,
   argDELITOMATERIA_SECBAN      VARCHAR2,
   argNROENVIO_SECBAN           VARCHAR2,
   argNROEXPEDIENTE_SECBAN      VARCHAR2,
   argDIRECAUTORIDAD_SECBAN     VARCHAR2,
   argSECRETARIO_SECBAN         VARCHAR2,
   argOTRAINFO_SECBAN           VARCHAR2,
   argPRIORIDADALTA_SECBAN      VARCHAR2,
   argPERIODOCONS_SECBAN        VARCHAR2,
   argPAIS_SECBAN               VARCHAR2,
   argORIGEN                    NUMBER,
   argFLAG_IMPRESO              NUMBER,
   argPRE_CARTA                 NUMBER,
   argOBSERVACION               VARCHAR2,
   argCARTA_ARCHIVO             VARCHAR2,
   argPRE_PROCESO               NUMBER,
   argTIPO_SOLICITUD            VARCHAR2,
   argDOCUM_NOTIFICA            VARCHAR2,
   argCOD_DELITO                NUMBER,
   argMSG_PROC                  VARCHAR2,
   argTIPO_BUSQUEDA             VARCHAR2,
   argTIPO_RESPUESTA            NUMBER,
   argMAIL_TO                   VARCHAR2,
   argIND_ESTADO_MAIL           NUMBER,
   argFCHA_CORREO               VARCHAR2,
   --
   OUTVAL                       OUT NUMBER,
   outCODIGO                    OUT NUMBER
  )
 AS
 WX_SQL          VARCHAR2(4000);
 WX_WHERE        VARCHAR2(2000);
 BEGIN
  --
  OUTVAL := 1;
  --
  wFECHA_SYS := TRUNC(SYSDATE);
  wHORA_SYS  := TO_CHAR(SYSDATE, 'hh24:mi:ss');
  --
  IF ARGFLAG = 1 THEN
     DELETE FROM SECRETO
     WHERE CODIGO = ARGCODIGO;
  END IF;
  --BORRA CABECERA Y DETALLE
  IF ARGFLAG = 2 THEN
    DELETE FROM SECRETO_PRODUCTO_CUENTA
     WHERE SECRETO = ARGCODIGO;
    --
    DELETE FROM SECRETO_GRUPO_CUENTA
     WHERE SECRETO = ARGCODIGO;
    --
    DELETE FROM SECRETO
     WHERE CODIGO = ARGCODIGO;
  END IF;
  --BORRA CABECERA Y DETALLE
  IF argFLAG = 3 THEN
    BEGIN
      WX_WHERE := '';
      IF ARGSECUENCIAPRO = 0 THEN
         IF NOT argFECHA_DESDE IS NULL AND NOT argFECHA_HASTA IS NULL THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'FECHA_REGISTRO BETWEEN TO_DATE(''' || argFECHA_DESDE || ''',''dd/MM/yyyy'') AND TO_DATE(''' || argFECHA_HASTA || ''',''dd/MM/yyyy'')' ;
         END IF;
         IF NOT argSECUENCIA_CARGA IS NULL THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'SECUE_CARGA_XLS = ' || argSECUENCIA_CARGA || '';
         END IF;
         IF NOT argOFICIO IS NULL THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'OFICIO = ''' || argOFICIO || '''';
         END IF;
      ELSE
         IF NOT argFECHA_DESDE IS NULL AND NOT argFECHA_HASTA IS NULL THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'FECHA_RESPUESTA BETWEEN TO_DATE(''' || argFECHA_DESDE || ''',''dd/MM/yyyy'') AND TO_DATE(''' || argFECHA_HASTA || ''',''dd/MM/yyyy'')' ;
         END IF;
         IF NOT argNRO_CARTA_DESDE IS NULL AND NOT argNRO_CARTA_HASTA IS NULL  THEN
            IF NOT WX_WHERE IS NULL THEN
               WX_WHERE := WX_WHERE || ' AND ';
            END IF;
            WX_WHERE := WX_WHERE || 'CORRELATIVO BETWEEN ''' || argNRO_CARTA_DESDE || ''' AND ''' || argNRO_CARTA_HASTA || '''';
         END IF;
      END IF;
      --
      IF ARGSECUENCIAPRO = 0 THEN
         WX_SQL := '';
         WX_SQL := WX_SQL || 'DELETE ';
         WX_SQL := WX_SQL || '  FROM SECRETO_PRODUCTO_CUENTA ';
         WX_SQL := WX_SQL || 'WHERE SECRETO IN ( ';
         WX_SQL := WX_SQL || 'SELECT CODIGO FROM SECRETO ';

         IF NOT WX_WHERE IS NULL THEN
            WX_SQL := WX_SQL || ' WHERE ' || WX_WHERE;
         END IF;

         WX_SQL := WX_SQL || ')';
         dbms_output.put_line('WQRY: ' || WX_SQL);
         --
         EXECUTE IMMEDIATE WX_SQL;
         --
          WX_SQL := '';
         WX_SQL := WX_SQL || 'DELETE ';
         WX_SQL := WX_SQL || '  FROM SECRETO_GRUPO_CUENTA ';
         WX_SQL := WX_SQL || 'WHERE SECRETO IN ( ';
         WX_SQL := WX_SQL || 'SELECT CODIGO FROM SECRETO ';

         IF NOT WX_WHERE IS NULL THEN
            WX_SQL := WX_SQL || ' WHERE ' || WX_WHERE;
         END IF;

         WX_SQL := WX_SQL || ')';
         dbms_output.put_line('WQRY: ' || WX_SQL);
         --
         EXECUTE IMMEDIATE WX_SQL;
         --
         WX_SQL := '';
         WX_SQL := WX_SQL || 'DELETE ';
         WX_SQL := WX_SQL || '  FROM SECRETO ';

         IF NOT WX_WHERE IS NULL THEN
            WX_SQL := WX_SQL || ' WHERE ' || WX_WHERE;
         END IF;
         --
         EXECUTE IMMEDIATE WX_SQL;
         --
         COMMIT;
         --
      ELSE
         WX_SQL := '';
         WX_SQL := WX_SQL || 'UPDATE SECRETO ';
         WX_SQL := WX_SQL || ' SET CARTA = 0, ';
         WX_SQL := WX_SQL || '     FLAG_IMPRESO = 0, ';
         WX_SQL := WX_SQL || '     NRO_CARTA_INF = NULL, ';
         WX_SQL := WX_SQL || '     CARTA_ARCHIVO = NULL, ';
         WX_SQL := WX_SQL || '     CORRELATIVO = NULL, ';
         WX_SQL := WX_SQL || '     FECHA_RESPUESTA = NULL, ';
         WX_SQL := WX_SQL || '     USUARIO_RESPUESTA = NULL, ' ;
         WX_SQL := WX_SQL || '     FECHA_MODI = ''' || TO_DATE(wFECHA_SYS,'DD/MM/YYYY') ||''', ' ;
         WX_SQL := WX_SQL || '     HORA_MODI = ''' || wHORA_SYS ||''', ' ;
         WX_SQL := WX_SQL || '     USUARIO_MODI = ''' || argUSUARIO_REGISTRO ||''' ' ;

         IF NOT WX_WHERE IS NULL THEN
            WX_SQL := WX_SQL || ' WHERE ' || WX_WHERE;
         END IF;
         --
         EXECUTE IMMEDIATE WX_SQL;
         COMMIT;
         --
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
          OUTVAL := 0;
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE||' - '||SQLERRM);
          RAISE_APPLICATION_ERROR(-20001,'ERROR - '||SQLCODE||' - '||SQLERRM);
    END;
  END IF;
 END;

 PROCEDURE UP_SECRETO_UPD
  (argFLAG                      NUMBER,
   argCODIGO                    NUMBER,
   argSECUENCIAOFI              NUMBER,
   argSECUENCIAPRO              NUMBER,
   argENTIDAD                   NUMBER,
   argENTIDADNOMBRE             VARCHAR2,  --
   argENTIDAD_EJECUTOR          VARCHAR2,
   argENTIDAD_EJECUTOR_CARGO    VARCHAR2,
   argINFO_ADICIONAL            VARCHAR2,
   argINFO_REQUERIDA            VARCHAR2,
   argPLAZO_ATENCION            VARCHAR2,
   argOFICIO_SBS                VARCHAR2,
   argNUMERO                    VARCHAR2,
   argOFICIO                    VARCHAR2,
   argAPE_PAT                   VARCHAR2,
   argAPE_MAT                   VARCHAR2,
   argNOMBRES                   VARCHAR2,
   argPROCESADO                 VARCHAR2,
   argTIPO_DOCUMENTO            NUMBER,
   argNUMERO_DOCUMENTO          VARCHAR2,
   argTIPO_PERSONA              VARCHAR2,
   argNUMERO_CUENTA             VARCHAR2,
   argCLIENTE                   NUMBER,
   argCARTA                     NUMBER,
   argHOMONIMIA                 NUMBER,
   argINCOMPLETO                NUMBER,
   argFLAG_SALDO                NUMBER,
   argESTADO                    NUMBER,
   argUSUARIO_REGISTRO          VARCHAR2,
   argFECHA_DESDE               VARCHAR2,
   argFECHA_HASTA               VARCHAR2,
   argFECHA_SECRETO             VARCHAR2,
   argFECHA_RESPUESTA           VARCHAR2,
   argUSUARIO_RESPUESTA         VARCHAR2,
   argFECHA_RECEPCION           VARCHAR2,
   argNRO_CARTA_INF             VARCHAR2,
   argNRO_CARTA_TIP             NUMBER,
   argCOD_CLIENTE               VARCHAR2,
   argFECHA_ING_ENTIDAD         VARCHAR2,
   argPRODUCTO                  VARCHAR2,
   argNRO_CARTA_DESDE           VARCHAR2,
   argNRO_CARTA_HASTA           VARCHAR2,
   argFECHA_DESPACHO            VARCHAR2,
   argFECHA_ENTREGA             VARCHAR2,
   argMOTIV_RECHZO              NUMBER,
   argSECUENCIA_CARGA           VARCHAR2,
   argPROC_FECHA                VARCHAR2,
   argPROC_HORA                 VARCHAR2,
   argPROC_USUARIO              VARCHAR2,
   argCORRELATIVO               VARCHAR2,
   argTIPODOI_SECBAN            VARCHAR2,
   argDELITOMATERIA_SECBAN      VARCHAR2,
   argNROENVIO_SECBAN           VARCHAR2,
   argNROEXPEDIENTE_SECBAN      VARCHAR2,
   argDIRECAUTORIDAD_SECBAN     VARCHAR2,
   argSECRETARIO_SECBAN         VARCHAR2,
   argOTRAINFO_SECBAN           VARCHAR2,
   argPRIORIDADALTA_SECBAN      VARCHAR2,
   argPERIODOCONS_SECBAN        VARCHAR2,
   argPAIS_SECBAN               VARCHAR2,
   argORIGEN                    NUMBER,
   argFLAG_IMPRESO              NUMBER,
   argPRE_CARTA                 NUMBER,
   argOBSERVACION               VARCHAR2,
   argCARTA_ARCHIVO             VARCHAR2,
   argPRE_PROCESO               NUMBER,
   argTIPO_SOLICITUD            VARCHAR2,
   argDOCUM_NOTIFICA            VARCHAR2,
   argCOD_DELITO                NUMBER,
   argMSG_PROC                  VARCHAR2,
   argTIPO_BUSQUEDA             VARCHAR2,
   argTIPO_RESPUESTA            NUMBER,
   argMAIL_TO                   VARCHAR2,
   argIND_ESTADO_MAIL           NUMBER,
   argFCHA_CORREO               VARCHAR2,
   --
   OUTVAL                       OUT NUMBER,
   outCODIGO                    OUT NUMBER
  )
 AS
 BEGIN
   OUTVAL    := 1;
   outCODIGO := 0;
   wERROR_DESCRIP := '';
   SELECT TRUNC(SYSDATE), TO_CHAR(SYSDATE, 'hh24:mi:ss') INTO wFECHA_SYS, wHORA_SYS
     FROM DUAL;
   /*Prepara Proc Interface*/
   IF argFLAG = 1 THEN
     UPDATE SECRETO
        SET PRE_PROCESO  = argPRE_PROCESO,
            FECHA_MODI   = wFECHA_SYS,
            HORA_MODI    = wHORA_SYS,
            USUARIO_MODI = argUSUARIO_REGISTRO
     WHERE CODIGO  = argCODIGO;
   END IF;
   /*Actualiza Despacho-Entrega*/
   IF argFlag = 5 THEN
     UPDATE SECRETO
        SET MOTIV_RECHAZO = argMOTIV_RECHZO,
            FECHA_ENTREGA = TO_DATE(argFECHA_ENTREGA,'DD/MM/YYYY'),
            FECHA_MODI    = wFECHA_SYS,
            HORA_MODI     = wHORA_SYS,
            USUARIO_MODI  = argUSUARIO_REGISTRO
      WHERE NRO_CARTA_INF = argNRO_CARTA_INF;
   END IF;
   /*Actualiza Notificacion*/
   IF argFLAG = 9 THEN
     wEXISTE := 0;
     --
     SELECT COUNT(*) INTO wEXISTE FROM SECRETO
      WHERE UPPER(OFICIO_SBS) = UPPER(argOFICIO_SBS);
     --
     IF wEXISTE > 0 THEN
       UPDATE SECRETO
          SET DOCUM_NOTIFICA  = argDOCUM_NOTIFICA,
              FECHA_MODI   = wFECHA_SYS,
              HORA_MODI    = wHORA_SYS,
              USUARIO_MODI = argUSUARIO_REGISTRO
        WHERE UPPER(OFICIO_SBS) = UPPER(argOFICIO_SBS)
          AND DOCUM_NOTIFICA IS NULL;
       --
     ELSE
       wERROR_DESCRIP := 'No existe numero de Oficio SBS registrado.';
       RAISE wERROR_PERSO;
     END IF;
     --
   END IF;
   /*Prepara generacion de Carta*/
   IF argFLAG = 10 THEN
     UPDATE SECRETO
        SET PRE_CARTA    = argPRE_CARTA,
            FECHA_MODI   = wFECHA_SYS,
            HORA_MODI    = wHORA_SYS,
            USUARIO_MODI = argUSUARIO_REGISTRO
      WHERE CODIGO = argCODIGO;
   END IF;
   --
   /*Actualiza Generacion de Carta*/
   IF argFLAG = 11 THEN
     UPDATE SECRETO
        SET CARTA           = argCARTA,
            PRE_CARTA       = 0,
            FECHA_RESPUESTA = argFECHA_RESPUESTA,
            USUARIO_RESPUESTA = argUSUARIO_RESPUESTA,
            NRO_CARTA_INF = argNRO_CARTA_INF,
            CARTA_ARCHIVO = argCARTA_ARCHIVO,
            CORRELATIVO   = argCORRELATIVO,
            FECHA_MODI    = wFECHA_SYS,
            HORA_MODI     = wHORA_SYS,
            USUARIO_MODI  = argUSUARIO_REGISTRO
      WHERE CODIGO = argCODIGO
        AND ESTADO = 32
        AND CARTA = argPRE_CARTA;
   END IF;
   /*Actualiza Impresion - Despacho*/
   IF argFLAG = 12 THEN

     UPDATE SECRETO
        SET FLAG_IMPRESO   = argFLAG_IMPRESO,
            NUMERO_CUENTA  = argNUMERO_CUENTA,
            FECHA_DESPACHO = TO_DATE(argFECHA_DESPACHO,('DD/MM/YYYY')),
            FECHA_MODI     = wFECHA_SYS,
            HORA_MODI      = wHORA_SYS,
            USUARIO_MODI   = argUSUARIO_REGISTRO
      WHERE NRO_CARTA_INF = argNRO_CARTA_INF;
   END IF;
   --
   /*Actualiza estado de carta para recrearla x Nro Carta*/
   IF argFLAG = 13 THEN
     UPDATE SECRETO
        SET PRE_CARTA = argPRE_CARTA,
            --CARTA = 0,
            FECHA_MODI     = wFECHA_SYS,
            HORA_MODI      = wHORA_SYS,
            USUARIO_MODI   = argUSUARIO_REGISTRO
      WHERE NRO_CARTA_INF = argNRO_CARTA_INF;
   END IF;
   /* Revierte estado de Pre-Carta*/
   IF argFLAG = 14 THEN
     UPDATE SECRETO
        SET PRE_CARTA    = argPRE_CARTA,
            FECHA_MODI   = wFECHA_SYS,
            HORA_MODI    = wHORA_SYS,
            USUARIO_MODI = argUSUARIO_REGISTRO
      WHERE CODIGO = argCODIGO
        AND PRE_CARTA = 1 ;
   END IF;

  /* Actualiza estado de Generaci¿n de Correo*/
   IF argFLAG = 15 THEN
     UPDATE SECRETO
        SET IND_ESTADO_MAIL = 1,
            FECHA_MODI   = wFECHA_SYS,
            HORA_MODI    = wHORA_SYS,
            USUARIO_MODI = argUSUARIO_REGISTRO,
            FECHA_DESPACHO = wFECHA_SYS
      WHERE OFICIO_SBS = argOFICIO_SBS;
   END IF;
   --
   /* Actualiza CORREO para Agencia*/
   IF argFLAG = 16 THEN
     UPDATE SECRETO
        SET MAIL_TO        = argMAIL_TO,
            FECHA_MODI     = wFECHA_SYS,
            HORA_MODI      = wHORA_SYS,
            USUARIO_MODI   = argUSUARIO_REGISTRO,
            FECHA_DESPACHO = wFECHA_SYS
      WHERE NRO_CARTA_INF = argNRO_CARTA_INF;
   END IF;
   /*Actualiza Cabecera Oficio Secreto*/
   /*IF argFLAG = 101 THEN
      UPDATE  SECRETO
      SET    ENTIDAD        =  ARGENTIDAD,
            OFICIO        =  ARGOFICIO,
            OFICIO_SBS    =  argoficio_sbs,
            FECHA_SECRETO = ARGFECHA_SECRETO
    WHERE  CODIGO  =  argCodigo;
   END IF;*/
   --
 EXCEPTION
   WHEN wERROR_PERSO THEN
      OUTVAL := 0;
      RAISE_APPLICATION_ERROR(-20201, wERROR_DESCRIP);
   WHEN OTHERS THEN
      OUTVAL := 0;
      DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE||' - '||SQLERRM);
      RAISE_APPLICATION_ERROR(-20001,'ERROR - '||SQLCODE||' - '||SQLERRM);
 END;

 PROCEDURE UP_SECRETO_INS
  (argFLAG                      NUMBER,
   argCODIGO                    NUMBER,
   argSECUENCIAOFI              NUMBER,
   argSECUENCIAPRO              NUMBER,
   argENTIDAD                   NUMBER,
   argENTIDADNOMBRE             VARCHAR2,  --
   argENTIDAD_EJECUTOR          VARCHAR2,
   argENTIDAD_EJECUTOR_CARGO    VARCHAR2,
   argINFO_ADICIONAL            VARCHAR2,
   argINFO_REQUERIDA            VARCHAR2,
   argPLAZO_ATENCION            VARCHAR2,
   argOFICIO_SBS                VARCHAR2,
   argNUMERO                    VARCHAR2,
   argOFICIO                    VARCHAR2,
   argAPE_PAT                   VARCHAR2,
   argAPE_MAT                   VARCHAR2,
   argNOMBRES                   VARCHAR2,
   argPROCESADO                 VARCHAR2,
   argTIPO_DOCUMENTO            NUMBER,
   argNUMERO_DOCUMENTO          VARCHAR2,
   argTIPO_PERSONA              VARCHAR2,
   argNUMERO_CUENTA             VARCHAR2,
   argCLIENTE                   NUMBER,
   argCARTA                     NUMBER,
   argHOMONIMIA                 NUMBER,
   argINCOMPLETO                NUMBER,
   argFLAG_SALDO                NUMBER,
   argESTADO                    NUMBER,
   argUSUARIO_REGISTRO          VARCHAR2,
   argFECHA_DESDE               VARCHAR2,
   argFECHA_HASTA               VARCHAR2,
   argFECHA_SECRETO             VARCHAR2,
   argFECHA_RESPUESTA           VARCHAR2,
   argUSUARIO_RESPUESTA         VARCHAR2,
   argFECHA_RECEPCION           VARCHAR2,
   argNRO_CARTA_INF             VARCHAR2,
   argNRO_CARTA_TIP             NUMBER,
   argCOD_CLIENTE               VARCHAR2,
   argFECHA_ING_ENTIDAD         VARCHAR2,
   argPRODUCTO                  VARCHAR2,
   argNRO_CARTA_DESDE           VARCHAR2,
   argNRO_CARTA_HASTA           VARCHAR2,
   argFECHA_DESPACHO            VARCHAR2,
   argFECHA_ENTREGA             VARCHAR2,
   argMOTIV_RECHZO              NUMBER,
   argSECUENCIA_CARGA           VARCHAR2,
   argPROC_FECHA                VARCHAR2,
   argPROC_HORA                 VARCHAR2,
   argPROC_USUARIO              VARCHAR2,
   argCORRELATIVO               VARCHAR2,
   argTIPODOI_SECBAN            VARCHAR2,
   argDELITOMATERIA_SECBAN      VARCHAR2,
   argNROENVIO_SECBAN           VARCHAR2,
   argNROEXPEDIENTE_SECBAN      VARCHAR2,
   argDIRECAUTORIDAD_SECBAN     VARCHAR2,
   argSECRETARIO_SECBAN         VARCHAR2,
   argOTRAINFO_SECBAN           VARCHAR2,
   argPRIORIDADALTA_SECBAN      VARCHAR2,
   argPERIODOCONS_SECBAN        VARCHAR2,
   argPAIS_SECBAN               VARCHAR2,
   argORIGEN                    NUMBER,
   argFLAG_IMPRESO              NUMBER,
   argPRE_CARTA                 NUMBER,
   argOBSERVACION               VARCHAR2,
   argCARTA_ARCHIVO             VARCHAR2,
   argPRE_PROCESO               NUMBER,
   argTIPO_SOLICITUD            VARCHAR2,
   argDOCUM_NOTIFICA            VARCHAR2,
   argCOD_DELITO                NUMBER,
   argMSG_PROC                  VARCHAR2,
   argTIPO_BUSQUEDA             VARCHAR2,
   argTIPO_RESPUESTA            NUMBER,
   argMAIL_TO                   VARCHAR2,
   argIND_ESTADO_MAIL           NUMBER,
   argFCHA_CORREO               VARCHAR2,
   --
   OUTVAL                       OUT NUMBER,
   outCODIGO                    OUT NUMBER
  )
/*
------------------------------------------------------------------------------------
GPS PERU
Fecha creacion 11/06/2019
Parametros :
 argFlag                      :Indicador para procesar sentencia.
 argCodigo                    :Codigo del oficio secreto.
 argSecuenciaOfi              :Numero de secuencia del Oficio.
 argSecuenciaPro              :Numero de secuencia del procesado.
 argEntidad                   :Id o codigo de la entidad.
 argEntidadNombre             :Nombre de la entidad.
 argentidad_ejecutor          :Nombre del responsable.
 argentidad_ejecutor_cargo    :Cargo del responsable.
 argInfo_adicional            :Informacion adicional.
 argInfo_requerida            :Informacion requerida.
 argoficio_sbs                :Nombre del oficio sbs.
 argnumero                    :Numero del oficio.
 argoficio                    :Nombre del oficio
 argApe_pat                   :Apellido paterno del procesado.
 argApe_mat                   :Apellido materno del procesado
 argNombres                   :Nombres del procesado.
 argProcesado                 :Nombres completos del procesado.
 argTipo_documento            :Tipo de documento del procesado.
 argNumero_documento          :Numero de documento del procesado.
 argTipo_persona              :Persona Natural o Juridica.
 argNumero_cuenta             :Numero de cuenta asociada.
 argCliente                   :Indica si es cliente o no.
 argcarta                     :Indica si genero carta.
 arghomonimia                 :Indica si es homonimia datos del procesado.
 argFlag_Saldo                :Indicador si informa saldo.
 argIncompleto                :Indicador si datos del procesado son icompletos.
 argEstado                    :Estado del oficio secreto.
 argUsuario_Registro          :Nombre del usuario que registra.
 argfecha_Desde               :Rango de fecha del oficio.
 argfecha_Hasta               :Rango de fecha del oficio.
 argfecha_Secreto             :Fecha secreto de ingreso de oficio.
 argfecha_Respuesta           :Fecha de respuesta del oficio.
 argFecha_recepcion           :Fecha de recepcion del oficio.
 argNro_Carta_Inf             :Numero de carta.
 argNro_Carta_Tip             :Numero de carta.
 argCod_Cliente               :Id o codigo del cliente.
 argFecha_Ing_Entidad         :Fecha de ingreso de Entidad.
 argProducto                  :Codigo del producto.
 argNro_Carta_Desde           :Rango de fecha de carta.
 argNro_Carta_Hasta           :Rango de fecha de carta.
 argFecha_Despacho            :Fecha de despacho del oficio.
 argFecha_Entrega             :Fecha de entrega de carta.
 argMotiv_Rechzo              :Codigo del motivo de rechazo de carta.
 argSecuencia_Carga           :Secuencia de carga del xsls.
 argproc_fecha                :Fecha de proceso.
 argproc_hora                 :Hora de proceso.
 argproc_usuario              :Usuario del proceso.
 argEntidadSolicitante_Secban :Entidad solicitante del secban.
 argTipoDOI_Secban            :Tipo de documento del secban.
 argDelitoMateria_Secban      :Delito/materia del secban.
 argNroEnvio_Secban           :Numero de envio del secban.
 argNroExpediente_Secban      :Numero de expediente del secban.
 argDirecAutoridad_Secban     :Direccion de la autoridad del secban.
 argSecretario_Secban         :Secretario del secban.
 argOtraInfo_Secban           :Otra informacion.
 argPrioridadAlta_Secban      :Indicar si es prioridad alta.
 argPeriodoCons_Secban        :Periodo del secban.
 argPais_Secban               :Pais
 argOrigen                    :Origen de registro.
 argPlazo_Atencion            :Plazo de atencion.
 OutIdSecreto                 :Indicador de estado.
 outVal                       :Indicador de estado.

 Objetivo           :Listar los procesados Lsb correspondientes e Insertar procesados.
--------------------------------------------------------------------------------------------------------
*/
 AS
   wCODIGO				SECRETO.CODIGO%TYPE;
   wFECHA_DESDE			SECRETO.FECHA_DESDE%TYPE;
   wFECHA_HASTA			SECRETO.FECHA_HASTA%TYPE;
   wFECHA_SECRETO		SECRETO.FECHA_SECRETO%TYPE;
   --wCOD_DELITO        SECRETO.COD_DELITO%TYPE;
   wExiste_SECRETO		NUMBER;
   wExiste_ENTIDAD		NUMBER;
   wExiste_DELITO		NUMBER;
   --
   --FECHAS_NO_SERAN_VALIDADAS_CON_LONGITUD: 02, 16, 17
   STRLONG_01_NRO_ENVIO				VARCHAR2(20);
   STRLONG_03_OFICIO_SBS			VARCHAR2(100);
   STRLONG_04_NRO_EXPEDIENTE_REF	VARCHAR2(150);
   STRLONG_05_TIPO_SOLICITUD		VARCHAR2(50);
   STRLONG_06_DESC_ENTIDAD_SOLIC	VARCHAR2(250);
   STRLONG_07_ENTIDAD_EJECUTOR		VARCHAR2(100);
   STRLONG_08_OFICIO				VARCHAR2(100);
   STRLONG_09_DIRECCION_AUTORIDAD	VARCHAR2(250);
   --10
   STRLONG_11_INF_REQUERIDA			VARCHAR2(500);
   STRLONG_12_INF_ADICIONAL			VARCHAR2(1000);
   STRLONG_13_PRIORIDAD_ALTA		VARCHAR2(30);
   STRLONG_14_PLAZO_ATENCION		VARCHAR2(30);
   STRLONG_15_PERIODO_CONSULTA		VARCHAR2(50);
   STRLONG_18_PROCESADO				VARCHAR2(150);
   STRLONG_19_APE_PATERNO			VARCHAR2(100);
   STRLONG_20_APE_MATERNO			VARCHAR2(100);
   STRLONG_21_NOMBRES				VARCHAR2(100);
   STRLONG_23_NUMERO_DOCUMENTO		VARCHAR2(20);
   STRLONG_24_PAIS					VARCHAR2(50);
   STRLONG_25_OBSERVACION			VARCHAR2(500);
 BEGIN
   --
   --OUTVAL        := 1;
   wFECHA_SYS := TRUNC(SYSDATE);
   wHORA_SYS  := TO_CHAR(SYSDATE, 'hh24:mi:ss');
   --
   IF argFLAG = 1 THEN
       	--



        --------------------------------------------------------------
        --VALIDACIONES DE LAS LONGITUDES:
        --------------------------------------------------------------
        --STRLONG_TIPO_SOLICITUD := FN_CALCULAR_VALOR_LONGITUD(argTIPO_SOLICITUD,50);
        STRLONG_01_NRO_ENVIO			:= FN_CALCULAR_VALOR_LONGITUD(argNROENVIO_SECBAN,20);
        STRLONG_03_OFICIO_SBS			:= FN_CALCULAR_VALOR_LONGITUD(argOFICIO_SBS,100);
        STRLONG_04_NRO_EXPEDIENTE_REF	:= FN_CALCULAR_VALOR_LONGITUD(argNROEXPEDIENTE_SECBAN,150);
        STRLONG_05_TIPO_SOLICITUD		:= FN_CALCULAR_VALOR_LONGITUD(argTIPO_SOLICITUD,50);
        STRLONG_06_DESC_ENTIDAD_SOLIC	:= FN_CALCULAR_VALOR_LONGITUD(argENTIDADNOMBRE,250);
        STRLONG_07_ENTIDAD_EJECUTOR		:= FN_CALCULAR_VALOR_LONGITUD(argENTIDAD_EJECUTOR,100);
        STRLONG_08_OFICIO				:= FN_CALCULAR_VALOR_LONGITUD(argOFICIO,100);
        STRLONG_09_DIRECCION_AUTORIDAD	:= FN_CALCULAR_VALOR_LONGITUD(argDIRECAUTORIDAD_SECBAN,250);
        --10
        STRLONG_11_INF_REQUERIDA		:= FN_CALCULAR_VALOR_LONGITUD(argINFO_REQUERIDA,500);
        STRLONG_12_INF_ADICIONAL		:= FN_CALCULAR_VALOR_LONGITUD(argINFO_ADICIONAL,1000);
        STRLONG_13_PRIORIDAD_ALTA		:= FN_CALCULAR_VALOR_LONGITUD(argPRIORIDADALTA_SECBAN,30);
        STRLONG_14_PLAZO_ATENCION		:= FN_CALCULAR_VALOR_LONGITUD(argPLAZO_ATENCION,30);
        STRLONG_15_PERIODO_CONSULTA		:= FN_CALCULAR_VALOR_LONGITUD(argPERIODOCONS_SECBAN,50);
        STRLONG_18_PROCESADO			:= FN_CALCULAR_VALOR_LONGITUD(argPROCESADO,150);
        STRLONG_19_APE_PATERNO			:= FN_CALCULAR_VALOR_LONGITUD(argAPE_PAT,100);
        STRLONG_20_APE_MATERNO			:= FN_CALCULAR_VALOR_LONGITUD(argAPE_MAT,100);
        STRLONG_21_NOMBRES				:= FN_CALCULAR_VALOR_LONGITUD(argNOMBRES,100);
        STRLONG_23_NUMERO_DOCUMENTO		:= FN_CALCULAR_VALOR_LONGITUD(argNUMERO_DOCUMENTO,20);
        STRLONG_24_PAIS					:= FN_CALCULAR_VALOR_LONGITUD(argPAIS_SECBAN,50);
        STRLONG_25_OBSERVACION			:= FN_CALCULAR_VALOR_LONGITUD(argOBSERVACION,500);
        --

        --VALIDACIONES:
        --0 SI EXISTE EL SECRETO
        IF STRLONG_23_NUMERO_DOCUMENTO IS NULL THEN
            SELECT COUNT(*)INTO wExiste_SECRETO FROM SECRETO
            WHERE ENTIDAD = argENTIDAD
            AND OFICIO = STRLONG_08_OFICIO
            AND NRO_EXPEDIENTE_REF = STRLONG_04_NRO_EXPEDIENTE_REF;
        ELSE
            SELECT COUNT(*)INTO wExiste_SECRETO FROM SECRETO
            WHERE ENTIDAD = argENTIDAD
            AND OFICIO = STRLONG_08_OFICIO
            AND NRO_EXPEDIENTE_REF = STRLONG_04_NRO_EXPEDIENTE_REF
            and NUMERO_DOCUMENTO = STRLONG_23_NUMERO_DOCUMENTO;
        END If;

        --1 SI EXISTE LA ENTIDAD
        SELECT COUNT(*) INTO wExiste_ENTIDAD FROM ENTIDAD
        WHERE CODIGO = argENTIDAD;
        --2 SI EXISTE EL DELITO
        SELECT COUNT(*) INTO wExiste_DELITO FROM DELITO
        WHERE CODIGO = argCOD_DELITO;
        --
        wFECHA_SECRETO := CASE WHEN argFECHA_SECRETO IS NOT NULL THEN TO_DATE(argFECHA_SECRETO,'dd/MM/yyyy') ELSE NULL END;
        wFECHA_DESDE   := CASE WHEN argFECHA_DESDE IS NOT NULL THEN TO_DATE(argFECHA_DESDE,'dd/MM/yyyy') ELSE NULL END;
        wFECHA_HASTA   := CASE WHEN argFECHA_HASTA IS NOT NULL THEN TO_DATE(argFECHA_HASTA,'dd/MM/yyyy') ELSE NULL END;
        --wCOD_DELITO    := CASE WHEN argCOD_DELITO > 0 THEN argCOD_DELITO ELSE NULL END;

        --
        IF(wExiste_ENTIDAD = 1)THEN
        --
            IF(wExiste_DELITO = 1)THEN
            --
            	SELECT SEQ_LSB_SECRETO.NEXTVAL INTO wCODIGO FROM DUAL;
                --
                INSERT INTO SECRETO
                    (CODIGO,				SECUENCIA_OFI,       			SECUENCIA_PRO,				ENTIDAD,            			ENTIDAD_EJECUTOR, 					ENTIDAD_EJECUTOR_CARGO, 			OFICIO_SBS,
                    OFICIO,          		PROCESADO,           			TIPO_DOCUMENTO,  			NUMERO_DOCUMENTO,   			NUMERO_CUENTA,    					NRO_CARTA_INF,          			NUMERADOR_TIPO,
                    CLIENTE,         		CARTA,               			HOMONIMIA,       			FLAG_SALDO,         			ESTADO,           					COD_CLIENTE,            			FECHA_DESDE,
                    FECHA_HASTA,     		FECHA_SECRETO,       			FECHA_REGISTRO,				HORA_REGISTRO,      			USUARIO_REGISTRO, 					FECHA_MODI,             			HORA_MODI,
                    USUARIO_MODI,    		DELITO_MATERIA,      			TIPO_PERSONA,				APE_PATERNO,        			APE_MATERNO,      					NOMBRES,                			INCOMPLETO,
                    ORIG_REG,        		NRO_EXPEDIENTE_REF,  			PLAZO_ATENCION,				DESC_ENTIDAD_SOLIC,				OBSERVACION,      					SECUE_CARGA_XLS,        			NUMERO,
                    NRO_ENVIO,       		TPO_DOC_IDENT,       			INF_REQUERIDA,				INF_ADICIONAL,      			PRIORIDAD_ALTA,   					DIRECCION_AUTORIDAD,				PERIODO_CONSULTA,
                    PAIS,            		TIPO_SOLICITUD,      			COD_DELITO,					TIPO_BUSQUEDA,              TIPO_RESPUESTA,             MAIL_TO,
                    IND_ESTADO_MAIL,    FCHA_CORREO)

                VALUES (wCODIGO,			argSECUENCIAOFI,         		argSECUENCIAPRO,			argENTIDAD,           			STRLONG_07_ENTIDAD_EJECUTOR,     	argENTIDAD_EJECUTOR_CARGO, 			STRLONG_03_OFICIO_SBS,
                    STRLONG_08_OFICIO,		STRLONG_18_PROCESADO,			argTIPO_DOCUMENTO,			STRLONG_23_NUMERO_DOCUMENTO,	argNUMERO_CUENTA,        			argNRO_CARTA_INF,          			argNRO_CARTA_TIP,
                    argCLIENTE,				argCARTA,                		argHOMONIMIA,      			argFLAG_SALDO,        			argESTADO,               			argCOD_CLIENTE,            			wFECHA_DESDE,
                    wFECHA_HASTA,			wFECHA_SECRETO,					wFECHA_SYS,        			wHORA_SYS,            			argUSUARIO_REGISTRO,     			wFECHA_SYS,                			wHORA_SYS,
                    argUSUARIO_REGISTRO, 	argDELITOMATERIA_SECBAN,		argTIPO_PERSONA,   			STRLONG_19_APE_PATERNO,			STRLONG_20_APE_MATERNO,    			STRLONG_21_NOMBRES,                	argINCOMPLETO,
                    argORIGEN,           	STRLONG_04_NRO_EXPEDIENTE_REF,	STRLONG_14_PLAZO_ATENCION,	STRLONG_06_DESC_ENTIDAD_SOLIC,	STRLONG_25_OBSERVACION,          	argSECUENCIA_CARGA,			argNUMERO,
                    STRLONG_01_NRO_ENVIO,  	argTIPODOI_SECBAN,				STRLONG_11_INF_REQUERIDA,	STRLONG_12_INF_ADICIONAL,		STRLONG_13_PRIORIDAD_ALTA,			STRLONG_09_DIRECCION_AUTORIDAD,		STRLONG_15_PERIODO_CONSULTA,
                    STRLONG_24_PAIS,      	STRLONG_05_TIPO_SOLICITUD,		argCOD_DELITO,				argTIPO_BUSQUEDA,           argTIPO_RESPUESTA,              argMAIL_TO,                       argIND_ESTADO_MAIL,
                    argFCHA_CORREO);
                --
                OUTVAL        := 1;
                outCODIGO := wCODIGO;
                --
            ELSE
                wERROR_DESCRIP := 'El Delito ingresado no existe.';
           		RAISE wERROR_PERSO;
            END IF;
        ELSE
           wERROR_DESCRIP := 'La Entidad ingresada no existe.';
           RAISE wERROR_PERSO;
        END IF;
   END IF;
   --
 EXCEPTION
    WHEN OTHERS THEN
      OUTVAL := 0;
      DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE||' - '||SQLERRM);
      RAISE_APPLICATION_ERROR(-20001,'ERROR - '||SQLCODE||' - '||SQLERRM);
 END;

 PROCEDURE UP_SECRETO_GRUPO_CUENTA_DEL(
 argFLAG             NUMBER,
 argSECRETO          NUMBER,
 argCOD_GRUPO        VARCHAR2,
 argCOD_PRODUCTO     VARCHAR2,
 argCOD_AUX1         VARCHAR2,
 OUTVAL OUT          NUMBER
 )
 AS
 BEGIN
  --
  OUTVAL := 1;
  --
   IF argFlag = 1 THEN
      DELETE FROM SECRETO_GRUPO_CUENTA
      WHERE SECRETO = argSECRETO
        AND COD_GRUPO = argCOD_GRUPO;
   END IF;

   IF argFlag = 2 THEN
   /*DELETE FROM secreto_cuenta
    WHERE secreto = argSecreto;*/

   DELETE FROM SECRETO_GRUPO_CUENTA
    WHERE SECRETO = argSECRETO;
   END IF;

  EXCEPTION
    WHEN OTHERS THEN
      OUTVAL := 0;
      DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE||' - '||SQLERRM);
      RAISE_APPLICATION_ERROR(-20001,'ERROR - '||SQLCODE||' - '||SQLERRM);
 END;

 PROCEDURE UP_SECRETO_GRUPO_CUENTA_INS(
 argFLAG             NUMBER,
 argSECRETO          NUMBER,
 argCOD_GRUPO        VARCHAR2,
 argCOD_PRODUCTO     VARCHAR2,
 argCOD_AUX1         VARCHAR2,
 OUTVAL OUT          NUMBER
 )
 AS
 BEGIN
  --
  OUTVAL := 1;
  --
   IF argFLAG = 1 THEN
      INSERT INTO SECRETO_GRUPO_CUENTA
             (SECRETO,    COD_GRUPO,    COD_PRODUCTO,    COD_AUX1)
      VALUES (argSECRETO, argCOD_GRUPO, argCOD_PRODUCTO, argCOD_AUX1);
   END IF;
   --
   IF argFlag = 2 THEN
/*     IF argCod_grupo <> '9999' and argCod_grupo <> '8888' THEN
         INSERT INTO SECRETO_GRUPO_CUENTA
               (SECRETO, COD_GRUPO, COD_PRODUCTO, COD_AUX1)
         SELECT argSECRETO AS SECRETO,TP.COD_GRUPO,TP.COD_PRODUCTO,TP.CODIGO_AUX1
         FROM TIPO_PRODUCTO TP
              INNER JOIN TIPO_PRODUCTO_GRUPO TPG ON TP.COD_GRUPO = TPG.COD_GRUPO AND TP.CODIGO_AUX1 = TPG.CODIGO_AUX1
         WHERE TP.FLAG_LSB = 1
           AND TPG.ID =  argCOD_GRUPO;
         --
         INSERT INTO SECRETO_GRUPO_CUENTA
               (SECRETO, COD_GRUPO, COD_PRODUCTO, COD_AUX1)
         SELECT argSECRETO AS SECRETO,TP.COD_GRUPO,TP.COD_PRODUCTO,TP.CODIGO_AUX1
           FROM TIPO_PRODUCTO TP
          INNER JOIN TIPO_PRODUCTO_GRUPO TPG ON TP.COD_GRUPO = TPG.COD_GRUPO AND TP.CODIGO_AUX1 = TPG.CODIGO_AUX1
         WHERE TP.FLAG_LSB = 1
           AND TPG.ID =  argCOD_GRUPO;
      ELSE
         INSERT INTO SECRETO_GRUPO_CUENTA
         SELECT argSECRETO AS SECRETO,argCOD_GRUPO,argCOD_GRUPO,argCOD_GRUPO FROM DUAL;
      END IF;*/
     INSERT INTO SECRETO_GRUPO_CUENTA
            (SECRETO, COD_GRUPO, COD_PRODUCTO, COD_AUX1)
     SELECT argSECRETO AS SECRETO,TP.COD_GRUPO,TP.COD_PRODUCTO,TP.CODIGO_AUX1
       FROM TIPO_PRODUCTO TP
       --INNER JOIN TIPO_PRODUCTO_GRUPO TPG ON TP.COD_GRUPO = TPG.COD_GRUPO AND TP.CODIGO_AUX1 = TPG.CODIGO_AUX1
      WHERE TP.FLAG_LSB = 1;
   END IF ;
   --
 EXCEPTION
    WHEN OTHERS THEN
      OUTVAL := 0;
      DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE||' - '||SQLERRM);
      RAISE_APPLICATION_ERROR(-20001,'ERROR - '||SQLCODE||' - '||SQLERRM);
 END;

 PROCEDURE UP_SECRETO_GRUPO_CUENTA_SEL(
 argFLAG             NUMBER,
 argSECRETO          NUMBER,
 argCOD_GRUPO        VARCHAR2,
 argCOD_PRODUCTO     VARCHAR2,
 argCOD_AUX1         VARCHAR2,
 OUTVAL              OUT NUMBER,
 O_RESULT_CURSOR     OUT T_REF_CURSOR
 )
 AS
 BEGIN
   OUTVAL := 1;
   --
   IF argFLAG = 1  THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT SECRETO, COD_GRUPO
       FROM SECRETO_GRUPO_CUENTa
      WHERE SECRETO = argSECRETO
        AND COD_GRUPO = argCOD_GRUPO;
   END IF;

   IF argFLAG = 2  THEN
       OPEN O_RESULT_CURSOR FOR
     SELECT SECRETO, COD_GRUPO
       FROM SECRETO_GRUPO_CUENTA
      WHERE SECRETO = argSECRETO;
   END IF;

 EXCEPTION
    WHEN OTHERS THEN
      OUTVAL := 0;
      DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE||' - '||SQLERRM);
      RAISE_APPLICATION_ERROR(-20001,'ERROR - '||SQLCODE||' - '||SQLERRM);
 END;

 PROCEDURE UP_SECRETO_PRODUCTO_CUENTA_SEL(
  argFLAG             NUMBER,
  argSECRETO          NUMBER,
  argCOD_GRUPO        VARCHAR2,
 /* argCOD_PRODUCTO     VARCHAR2
  argCOD_AUX1         VARCHAR2*/
  OUTVAL OUT          NUMBER,
  O_RESULT_CURSOR     OUT T_REF_CURSOR
 )
 AS
 BEGIN
  OUTVAL := 1;
  --
  IF argFLAG = 1  THEN
    OPEN O_RESULT_CURSOR FOR
    SELECT  SPC.CHK_INF,
            SPC.ID_REGISTRO,
            SPC.SECRETO,
            SPC.COD_GRUPO_BUSQ,
            SPC.COD_PRODUCTO,
            SPC.COD_AUX1,
            SPC.RELACION_CUENTA,
            SPC.NOM_CUENTA,
            SPC.CUENTA,
            SPC.MONEDA,
            MN.ABRV_MONEDA,
            SPC.SALDO,
            SPC.MONTO_DESEMBOLSADO,
            SPC.FECHA_APERTURA,
            SPC.FECHA_CIERRE,
            SPC.TPO_MOVI,
            SPC.MODULO,
            SPC.TIP_PRODUCTO,
            SPC.TIPO_OPERA,
            SPC.PLAZO,
            SPC.COD_ESTADO,
            SPC.ESTADO,
            SPC.PROC_FECHA,
            SPC.PROC_USUARIO,
            NVL(CONT,0) AS CONT_ADIC
    FROM SECRETO_PRODUCTO_CUENTA SPC
    INNER JOIN MONEDA MN ON MN.COD_MONEDA = SPC.MONEDA
    LEFT JOIN (SELECT COUNT(*) AS CONT, SECRETOPRODCTA
               FROM SECRETO_PRODUCTO_CUENTA_ADIC GROUP BY SECRETOPRODCTA) ADIC ON ADIC.SECRETOPRODCTA =SPC.ID_REGISTRO
    WHERE SECRETO = argSECRETO
    ORDER BY NOM_CUENTA;
  END IF;
 END;

 PROCEDURE UP_SECRETO_PRODUCTO_CUENTA_UPD
  (argFLAG             NUMBER,
   argSECRETO          NUMBER,
   argCOD_GRUPO        VARCHAR2,
/* argCOD_PRODUCTO     VARCHAR2
 argCOD_AUX1         VARCHAR2*/
   OUTVAL OUT          NUMBER
   )
 AS
 BEGIN
   OUTVAL := 1;
   --
   IF argFLAG = 1  THEN
     UPDATE SECRETO_PRODUCTO_CUENTA
        SET CHK_INF = TO_NUMBER(argCOD_GRUPO)
      WHERE ID_REGISTRO = argSECRETO;
   END IF;
   --
 EXCEPTION
   WHEN OTHERS THEN
       OUTVAL := 0;
       DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE||' - '||SQLERRM);
       RAISE_APPLICATION_ERROR(-20001,'ERROR - '||SQLCODE||' - '||SQLERRM);
 END;

END;
/
