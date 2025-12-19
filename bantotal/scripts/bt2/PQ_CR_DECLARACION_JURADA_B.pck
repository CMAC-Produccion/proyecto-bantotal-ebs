CREATE OR REPLACE PACKAGE PQ_CR_DECLARACION_JURADA_B IS

  -- ====================================================================================================
  -- NOMBRE                      : PQ_CR_DECLARACION_JURADA_B
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 05/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  PROCEDURE SP_CR_GRABAR_LOG_IMGS(PI_INSTANCIA IN NUMBER,
                                  PI_USUARIO   IN VARCHAR2,
                                  PI_PROGRAMA  IN VARCHAR2);
                                  
  -- ===================================================================================================
  PROCEDURE SP_CR_ENVIAR_MAIL_XLS(PI_FECHA_BT IN DATE);
   
  -- ===================================================================================================
  PROCEDURE SP_CR_CONFIG_MAIL(PI_DE     IN VARCHAR2,
                             PI_PARA   IN VARCHAR2,
                             PI_ASUNTO IN VARCHAR2,
                             PI_HEADER IN VARCHAR2,
                             PI_DATA   IN CLOB);
                             
  -- ===================================================================================================
  PROCEDURE SP_CR_MAIL_ROOT(PI_DE     IN VARCHAR2,
                            PI_PARA   IN VARCHAR2,
                            PI_ASUNTO IN VARCHAR2,
                            PI_SERVER IN VARCHAR2,
                            PI_PORT   IN NUMBER,
                            PI_HOST   IN VARCHAR2,
                            PI_HEADER IN VARCHAR2,
                            PI_DATA   IN CLOB);
                               
END PQ_CR_DECLARACION_JURADA_B;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_DECLARACION_JURADA_B IS

  PROCEDURE SP_CR_GRABAR_LOG_IMGS(PI_INSTANCIA IN NUMBER,
                                  PI_USUARIO   IN VARCHAR2,
                                  PI_PROGRAMA  IN VARCHAR2) IS
                             
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_GRABAR_LOG_IMGS
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 05/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : GRABAR LOG DE LAS IMAGENES DE LA DECLARACION JURADA BIENES 
  -- PARAMETROS                  : - PI_INSTANCIA | NUMBER(10)   | INSTANCIA
  --                               - PI_USUARIO   | VARCHAR2(10) | USUARIO BT
  --                               - PI_PROGRAMA  | VARCHAR2(10) | PROGRAMA
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
    
    V_FECHA_BT  DATE       := NULL;
    V_CORRL     NUMBER(17) := 0;
    
    CURSOR CUR_DATA IS
      SELECT D.REGCOD,
             D.REGNOM,
             D.CODZON,
             D.DESZON,
             D.SUCURS,
             D.SCNOM,
             E.SNG001PAIS,
             E.SNG001TDOC,
             E.SNG001NDOC,
             A.SNG122INST,
             B.XWFCUENTA,
             A.SNG122CTA,
             A.SNG122OPER,
             (SELECT TRIM(L.CTNOM)
                FROM FSD008 L
               WHERE L.PGCOD = A.SNG122PGC
                 AND L.CTNRO = A.SNG122CTA) GARANTE,
             C.IMG_CROQUIS,
             C.IMG_OPC1,
             C.IMG_MEDIDOR,
             C.IMG_OPC2,
             C.IMG_OPC3,
             C.IMG_OPC4,
             (
                CASE WHEN C.IMG_CROQUIS IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN C.IMG_OPC1 IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN C.IMG_MEDIDOR IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN C.IMG_OPC2 IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN C.IMG_OPC3 IS NOT NULL THEN 1 ELSE 0 END +
                CASE WHEN C.IMG_OPC4 IS NOT NULL THEN 1 ELSE 0 END
             ) TOTAL_IMG,
             (SELECT TRIM(X.SOURCE)
                FROM HISTORICO_OBTENER_DJB X
               WHERE X.INSTANCIA_SOLICITUD = A.SNG122INST
              ORDER BY X.ID DESC
              FETCH FIRST 1 ROW ONLY) SOURCE
        FROM SNG122 A, XWF700 B, SUSTENTO_VISITA_DJB C,
             REGSUC D, SNG001 E
       WHERE A.SNG122INST = PI_INSTANCIA
         AND B.XWFPRCINS  = A.SNG122INST
         AND B.XWFCAR3    = '1'
         AND C.ID_VISITA  = (SELECT T.ID_VISITA
                               FROM DETALLE_SOLICITUD_GARANTIAS T
                              WHERE T.CUENTA              = B.XWFCUENTA
                                AND T.OPERACION_GARANTIA  = A.SNG122OPER
                                AND T.INSTANCIA_SOLICITUD = A.SNG122INST
                                AND T.APLICA_DJB          = 1
                              ORDER BY T.ID DESC
                              FETCH FIRST 1 ROW ONLY)
         AND D.SUCURS     = B.XWFSUCURSAL
         AND E.SNG001INST = A.SNG122INST;
                     
  BEGIN    
    -- OBTENER FECHA BT --
    BEGIN 
      SELECT A.PGFAPE
        INTO V_FECHA_BT
        FROM FST017 A
       WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
        
    -- ACTUALIZAR ESTADO DE "S" A "N" --
    BEGIN
      UPDATE AQPD410 A
         SET A.AQPD410EST  = 'N'
       WHERE A.AQPD410INST = PI_INSTANCIA
         AND A.AQPD410EST  = 'S'
         AND A.AQPD410PGM  = PI_PROGRAMA;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    -- LEER DATA CURSOR --
    FOR I IN CUR_DATA LOOP
      -- OBTENER SIGUIENTE CORRELATIVO --
      BEGIN
        SELECT NVL(A.AQPD410COR, 0) + 1
          INTO V_CORRL
          FROM AQPD410 A
         WHERE A.AQPD410FERG = V_FECHA_BT
           AND ROWNUM        = 1
         ORDER BY A.AQPD410COR DESC;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_CORRL := 1;
        WHEN OTHERS THEN
          NULL;
      END;
            
      -- GRABAR LOG --
      BEGIN
        INSERT INTO AQPD410(AQPD410COR,
                            AQPD410FERG,
                            AQPD410CDRE,
                            AQPD410NMRE,
                            AQPD410CDZO,
                            AQPD410NMZO,
                            AQPD410CDAG,
                            AQPD410NMAG,
                            AQPD410PDOC,
                            AQPD410TDOC,
                            AQPD410NDOC,
                            AQPD410INST,
                            AQPD410CTCR,
                            AQPD410CTGR,
                            AQPD410OPGR,
                            AQPD410NMGR,
                            AQPD410IMG1,
                            AQPD410IMG2,
                            AQPD410IMG3,
                            AQPD410IMG4,
                            AQPD410IMG5,
                            AQPD410IMG6,
                            AQPD410TIMG,
                            AQPD410SOUR,
                            AQPD410EST,
                            AQPD410PGM,
                            AQPD410HORG,
                            AQPD410USRG)
        VALUES (V_CORRL,
                V_FECHA_BT,
                I.REGCOD,
                I.REGNOM,
                I.CODZON,
                I.DESZON,
                I.SUCURS,
                I.SCNOM,
                I.SNG001PAIS,
                I.SNG001TDOC,
                I.SNG001NDOC,
                I.SNG122INST,
                I.XWFCUENTA,
                I.SNG122CTA,
                I.SNG122OPER,
                I.GARANTE,
                I.IMG_CROQUIS,
                I.IMG_OPC1,
                I.IMG_MEDIDOR,
                I.IMG_OPC2,
                I.IMG_OPC3,
                I.IMG_OPC4,
                I.TOTAL_IMG,
                I.SOURCE,
                'S',
                PI_PROGRAMA,
                TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                PI_USUARIO);
        COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
      END;
    END LOOP;
  END SP_CR_GRABAR_LOG_IMGS;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_ENVIAR_MAIL_XLS(PI_FECHA_BT IN DATE) IS
  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_ENVIAR_MAIL_XLS
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 05/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : GENERAR EL ENCABEZADO Y LOS DATOS DEL REPORTE EN FORMATO XLS
  --                               CON EL FIN DE ADJUNTAR EL ARCHIVO EN EL CORREO ELECTRÓNICO
  -- PARAMETROS                  : - PI_FECHA_BT | DATE | FECHA BT
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
      
    V_ASUNTO      VARCHAR2(1000)  := NULL;
    V_NOM_FILE    VARCHAR2(100)   := NULL;
    V_HEADER      VARCHAR2(10000) := NULL;
    V_DATA        VARCHAR2(32000) := NULL;
    V_CLOB        CLOB            := NULL;
    V_NOM_PDOC    VARCHAR2(30)    := NULL;
    V_NOM_TDOC    VARCHAR2(20)    := NULL;
    V_EMAILS_PARA VARCHAR2(4000)  := NULL;
    
    CURSOR CUR_DJB IS
      SELECT A.AQPD410FERG,
             A.AQPD410HORG,
             A.AQPD410NMRE,
             A.AQPD410NMZO,
             A.AQPD410NMAG,
             A.AQPD410USRG,
             A.AQPD410PDOC,
             A.AQPD410TDOC,
             A.AQPD410NDOC,
             A.AQPD410INST,
             A.AQPD410CTCR,
             A.AQPD410CTGR,
             A.AQPD410OPGR,
             A.AQPD410NMGR,
             A.AQPD410TIMG,
             A.AQPD410EST,
             A.AQPD410SOUR
        FROM AQPD410 A
       WHERE A.AQPD410EST   = 'S'
         AND A.AQPD410FERG BETWEEN TRUNC(PI_FECHA_BT, 'MM') AND PI_FECHA_BT;
  BEGIN
    V_ASUNTO   := 'Declaracion Jurada de Bienes - Log';
    V_NOM_FILE := 'DJBLOG_' || TO_CHAR(PI_FECHA_BT, 'YYYYMMDD') || '.xls';
    
    V_HEADER := 'MIME-Version: 1.0' || UTL_TCP.CRLF ||
                'Content-Type: multipart/mixed;' || UTL_TCP.CRLF ||
                ' boundary=-----SECBOUND' || UTL_TCP.CRLF || UTL_TCP.CRLF ||
                '-------SECBOUND' || UTL_TCP.CRLF ||
                'Content-Type: text/plain;' || UTL_TCP.CRLF ||
                'Content-Transfer_Encoding: 8bit' || UTL_TCP.CRLF || UTL_TCP.CRLF ||
                'Estimados,' || CHR(13) ||
                'Se adjunta la declaracion jurada de bienes - log' || UTL_TCP.CRLF ||
                '-------SECBOUND' || UTL_TCP.CRLF ||
                'Content-Type: text/plain; charset=iso-8859-1' || UTL_TCP.CRLF ||
                ' name=RELACION_TRABCESE_' || TO_CHAR(SYSDATE, 'DD-MM-RR') || UTL_TCP.CRLF ||
                'Content-Transfer_Encoding: 8bit' || UTL_TCP.CRLF ||
                'Content-Disposition: attachment;' || UTL_TCP.CRLF ||
                ' filename=' || V_NOM_FILE || UTL_TCP.CRLF || UTL_TCP.CRLF;
    
    V_HEADER := V_HEADER || 'FECHA' || CHR(9) ||
                            'HORA' || CHR(9) ||
                            'REGION' || CHR(9) ||
                            'ZONA' || CHR(9) ||
                            'AGENCIA' || CHR(9) ||
                            'USUARIO BT' || CHR(9) ||
                            'PAIS DOCUMENTO' || CHR(9) ||
                            'TIPO DOCUMENTO' || CHR(9) ||
                            'NRO. DOCUMENTO' || CHR(9) ||
                            'INSTANCIA' || CHR(9) ||
                            'CUENTA CREDITO' || CHR(9) ||
                            'CUENTA GARANTIA' || CHR(9) ||
                            'OPERACION GARANTIA' || CHR(9) ||
                            'NOMBRE GARANTE' || CHR(9) ||
                            'TOTAL IMAGENES' || CHR(9) ||
                            'ESTADO' || CHR(9) ||
                            'SOURCE0' || CHR(9);
    
    FOR I IN CUR_DJB LOOP 
      V_NOM_PDOC := NULL;
      BEGIN
        SELECT TRIM(A.PANOM)
          INTO V_NOM_PDOC
          FROM FST013 A
         WHERE A.PAIS = I.AQPD410PDOC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      V_NOM_TDOC := NULL;
      BEGIN
        SELECT CASE
                  WHEN A.TDOCUM = 21 THEN 'DNI'
                  WHEN A.TDOCUM = 9 THEN 'RUC'
                  ELSE TRIM(A.TDNOM)
               END
          INTO V_NOM_TDOC
          FROM FST014 A
         WHERE A.TDOCUM = I.AQPD410TDOC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      V_DATA := TRIM(I.AQPD410FERG) || CHR(9) ||
                TRIM(I.AQPD410HORG) || CHR(9) ||
                TRIM(I.AQPD410NMRE) || CHR(9) ||
                TRIM(I.AQPD410NMZO) || CHR(9) ||
                TRIM(I.AQPD410NMAG) || CHR(9) ||
                TRIM(I.AQPD410USRG) || CHR(9) ||
                V_NOM_PDOC || CHR(9) ||
                V_NOM_TDOC || CHR(9) ||
                TRIM(I.AQPD410NDOC) || CHR(9) ||
                I.AQPD410INST || CHR(9) ||
                I.AQPD410CTCR || CHR(9) ||
                I.AQPD410CTGR || CHR(9) ||
                I.AQPD410OPGR || CHR(9) ||
                TRIM(I.AQPD410NMGR) || CHR(9) ||
                I.AQPD410TIMG || CHR(9) ||
                I.AQPD410EST || CHR(9) ||
                I.AQPD410SOUR || CHR(9) ||
                UTL_TCP.CRLF;
      V_CLOB := V_CLOB || TO_CLOB(V_DATA);
    END LOOP;   
    
    IF V_CLOB IS NOT NULL THEN
      BEGIN
        SELECT TRIM(LISTAGG(TRIM(A.TP1DESC) ||
                            (SELECT TRIM(T.TP1DESC)
                               FROM FST198 T
                              WHERE T.TP1COD   = 1
                                AND T.TP1COD1  = 111154
                                AND T.TP1CORR1 = 1
                                AND T.TP1CORR2 = 62
                                AND T.TP1CORR3 > 0
                                AND T.TP1NRO1  = 1
                                AND T.TP1NRO3  = A.TP1NRO3),
                            ';') WITHIN GROUP(ORDER BY A.TP1DESC))
          INTO V_EMAILS_PARA
          FROM FST198 A
         WHERE A.TP1COD   = 1
           AND A.TP1COD1  = 111154
           AND A.TP1CORR1 = 1
           AND A.TP1CORR2 = 61
           AND A.TP1CORR3 > 0
           AND A.TP1NRO1  = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SP_CR_CONFIG_MAIL(PI_DE     => 'notificaciones@cajaarequipa.pe',
                          PI_PARA   => V_EMAILS_PARA,
                          PI_ASUNTO => V_ASUNTO,
                          PI_HEADER => V_HEADER,
                          PI_DATA   => V_CLOB);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(SQLERRM);
      END;
    END IF;       
     
  END SP_CR_ENVIAR_MAIL_XLS;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_CONFIG_MAIL(PI_DE     IN VARCHAR2,
                              PI_PARA   IN VARCHAR2,
                              PI_ASUNTO IN VARCHAR2,
                              PI_HEADER IN VARCHAR2,
                              PI_DATA   IN CLOB) IS
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_CONFIG_MAIL
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 05/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : OBTENER EL SERVIDOR, PUERTO Y HOST PARA EL ENVIO DEL MAIL
  -- PARAMETROS                  : - PI_DE     | VARCHAR2(80)    | REMITENTE
  --                               - PI_PARA   | VARCHAR2(80)    | DESTINATARIO
  --                               - PI_ASUNTO | VARCHAR2(1000)  | ASUNTO
  --                               - PI_HEADER | VARCHAR2(10000) | HEADER MAIL
  --                               - PI_DATA   | VARCHAR2(32000) | DATA MAIL
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
    
    V_HOSTNAME VARCHAR2(64) := NULL;
    V_HOST     VARCHAR2(30) := NULL;
    V_SMTP     VARCHAR2(30) := NULL;
    V_PORT     NUMBER(9)    := 0;
    
    CURSOR C_HOST IS
      SELECT *
        FROM FST198 A
       WHERE A.TP1COD   = 1
         AND A.TP1COD1  = 10825
         AND A.TP1CORR1 = 61
         AND A.TP1CORR2 = 7;
   
  BEGIN
    BEGIN
      SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    FOR I IN C_HOST LOOP
      V_HOST := UPPER(TRIM(SUBSTR(I.TP1DESC, 1, INSTR(I.TP1DESC, '/') - 1)));
      V_SMTP := TRIM(SUBSTR(I.TP1DESC, INSTR(I.TP1DESC, '/') + 1, LENGTH(TRIM(I.TP1DESC))));
      V_PORT := I.TP1NRO3;
    
     EXIT WHEN UPPER(V_HOSTNAME) = V_HOST;
    END LOOP;
    
    BEGIN
      SP_CR_MAIL_ROOT(PI_DE     => PI_DE,
                      PI_PARA   => PI_PARA,
                      PI_ASUNTO => PI_ASUNTO,
                      PI_SERVER => V_SMTP,
                      PI_PORT   => V_PORT,
                      PI_HOST   => V_HOST,
                      PI_HEADER => PI_HEADER,
                      PI_DATA   => PI_DATA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

  END SP_CR_CONFIG_MAIL;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_MAIL_ROOT(PI_DE     IN VARCHAR2,
                            PI_PARA   IN VARCHAR2,
                            PI_ASUNTO IN VARCHAR2,
                            PI_SERVER IN VARCHAR2,
                            PI_PORT   IN NUMBER,
                            PI_HOST   IN VARCHAR2,
                            PI_HEADER IN VARCHAR2,
                            PI_DATA   IN CLOB) IS
  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_MAIL_ROOT
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 05/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : ENVIAR EL MAIL AL DESTINATARIO
  -- PARAMETROS                  : - PI_DE     | VARCHAR2(80)    | REMITENTE
  --                               - PI_PARA   | VARCHAR2(80)    | DESTINATARIO
  --                               - PI_ASUNTO | VARCHAR2(1000)  | ASUNTO
  --                               - PI_SERVER | VARCHAR2(30)    | SERVIDOR
  --                               - PI_PORT   | NUMBER(9)       | PUERTO
  --                               - PI_HOST   | VARCHAR2(30)    | HOST
  --                               - PI_HEADER | VARCHAR2(10000) | HEADER MAIL
  --                               - PI_DATA   | VARCHAR2(32000) | DATA MAIL
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
    V_FOUND     NUMBER          := 0;
    V_MENSAJE   VARCHAR2(32767) := NULL;
    V_AUXILIAR  VARCHAR2(32000) := NULL;
    V_MSG_ERROR VARCHAR2(1000)  := NULL;
    V_OFFSET    NUMBER          := 630;
    V_CONEXION UTL_SMTP.CONNECTION;
    
  BEGIN
    BEGIN
      SELECT COUNT(*)
        INTO V_FOUND
        FROM SYSTABREP.HOSTNAMES
       WHERE HABILITADO = 'S'
         AND UPPER(HOST_NAME) = PI_HOST;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    IF V_FOUND = 1 THEN
      V_CONEXION := UTL_SMTP.OPEN_CONNECTION(PI_SERVER, PI_PORT);
      V_MENSAJE  := 'Date: ' || TO_CHAR(SYSDATE, 'Dy, DD Mon YYYY hh24:mi:ss') || UTL_TCP.CRLF ||
                    'From: ' || PI_DE || UTL_TCP.CRLF ||
                    'Subject: ' || PI_ASUNTO || UTL_TCP.CRLF ||
                    'To: ' || PI_PARA || UTL_TCP.CRLF;
                    
      UTL_SMTP.HELO(V_CONEXION, PI_SERVER);
      UTL_SMTP.MAIL(V_CONEXION, PI_DE);
      UTL_SMTP.RCPT(V_CONEXION, PI_PARA);
      
      UTL_SMTP.OPEN_DATA(V_CONEXION);
      -- SE ESCRIBE LA CABECERA
      UTL_SMTP.WRITE_DATA(V_CONEXION, V_MENSAJE);
      -- SE ESCRIBE EL CONTENIDO DEL MENSAJE 
      UTL_SMTP.WRITE_DATA(V_CONEXION, PI_HEADER || UTL_TCP.CRLF);
      
      FOR LOOP_ATT IN 0 .. TRUNC(DBMS_LOB.GETLENGTH(PI_DATA) / V_OFFSET) LOOP
        V_AUXILIAR := DBMS_LOB.SUBSTR(PI_DATA, V_OFFSET, LOOP_ATT * V_OFFSET + 1);
        UTL_SMTP.WRITE_DATA(V_CONEXION, V_AUXILIAR);
      END LOOP;
      
      UTL_SMTP.WRITE_DATA(V_CONEXION, UTL_TCP.CRLF);
      UTL_SMTP.WRITE_DATA(V_CONEXION, UTL_TCP.CRLF);
      UTL_SMTP.WRITE_DATA(V_CONEXION, '-------SECBOUND--');
      UTL_SMTP.WRITE_DATA(V_CONEXION, UTL_TCP.CRLF);
      -- CERRAMOS LA CONEXION
      UTL_SMTP.CLOSE_DATA(V_CONEXION);
      UTL_SMTP.QUIT(V_CONEXION);
    END IF;
  EXCEPTION
    WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
        V_MSG_ERROR := 'Unable to send mail: ' || SQLERRM;
        RAISE_APPLICATION_ERROR(-20000, 'Unable to send mail: ' || V_MSG_ERROR);
  END SP_CR_MAIL_ROOT;
  
END PQ_CR_DECLARACION_JURADA_B;
/
