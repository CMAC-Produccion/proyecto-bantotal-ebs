CREATE OR REPLACE PACKAGE PQ_CR_BLOQ_REPROG IS

  -- ====================================================================================================
  -- NOMBRE                      : PQ_CR_BLOQ_REPROG
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 06/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  PROCEDURE SP_CR_SAVE_AUTORIZACION(PI_INSTANCIA   IN NUMBER,
                                    PI_IDBLOQ      IN NUMBER,
                                    PI_ESTADO      IN VARCHAR2,
                                    PI_AUTORIZADOR IN VARCHAR2,
                                    PI_COMENTARIO  IN VARCHAR2);
                                    
  -- ===================================================================================================
  
  PROCEDURE SP_CR_UPDATE_ESTADO(PI_INSTANCIA   IN NUMBER,
                                PI_IDBLOQ      IN NUMBER,
                                PI_ESTADO      IN VARCHAR2,
                                PI_AUTORIZADOR IN VARCHAR2);
                                
  -- ===================================================================================================
  PROCEDURE SP_CR_ENVIAR_CORREO(PI_INSTANCIA IN VARCHAR2,
                                PI_ID_BLOQ   IN NUMBER);
                                
  -- ===================================================================================================
  PROCEDURE SP_CR_VALIDAR_ESTADO(PI_INSTANCIA IN  NUMBER,
                                 PI_IDBLOQ    IN  NUMBER,
                                 PO_COD_ERROR OUT NUMBER,
                                 PO_MSG_ERROR OUT VARCHAR2);
                                 
  -- ===================================================================================================
  PROCEDURE SP_CR_GET_TIPREPROG(PI_EMPRESA   IN NUMBER,
                                PI_MODULO    IN  NUMBER,
                                PI_SUCURSAL  IN  NUMBER,
                                PI_MONEDA    IN  NUMBER,
                                PI_PAPEL     IN  NUMBER,
                                PI_CUENTA    IN  NUMBER,
                                PI_OPERACION IN  NUMBER,
                                PI_SUBOPER   IN  NUMBER,
                                PI_TIPOPER   IN  NUMBER,
                                PI_FE_RPRG   IN  DATE,
                                PO_TIPO_RPRG OUT VARCHAR2);

END PQ_CR_BLOQ_REPROG;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_BLOQ_REPROG IS
  
  PROCEDURE SP_CR_SAVE_AUTORIZACION(PI_INSTANCIA   IN NUMBER,
                                    PI_IDBLOQ      IN NUMBER,
                                    PI_ESTADO      IN VARCHAR2,
                                    PI_AUTORIZADOR IN VARCHAR2,
                                    PI_COMENTARIO  IN VARCHAR2) IS
                                    
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_SAVE_AUTORIZACION
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 06/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : GRABAR LA AUTORIZACION DE LA BLOQUEANTE
  -- PARAMETROS                  : - PI_INSTANCIA   | NUMBER(10)
  --                               - PI_IDBLOQ      | NUMBER(17)
  --                               - PI_ESTADO      | VARCHAR2(1)
  --                               - PI_AUTORIZADOR | VARCHAR2(10)
  --                               - PI_COMENTARIO  | VARCHAR2(255)
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
                                    
  BEGIN
    -- SAVE COMENTARIO BLOQUEANTE --
    BEGIN
       UPDATE AQPD159 A
          SET A.AQPD159CMTA = PI_COMENTARIO
         WHERE A.AQPD159CORBLO = PI_IDBLOQ
           AND A.AQPD159INST   = PI_INSTANCIA
           AND A.AQPD159UAPRO  = RPAD(PI_AUTORIZADOR, 10, ' ');
       COMMIT;
    EXCEPTION
       WHEN OTHERS THEN
          NULL;
    END;
    
    -- UPDATE ESTADO BLOQUEANTE --
    BEGIN
      SP_CR_UPDATE_ESTADO(PI_INSTANCIA   => PI_INSTANCIA,
                          PI_IDBLOQ      => PI_IDBLOQ,
                          PI_ESTADO      => PI_ESTADO,
                          PI_AUTORIZADOR => PI_AUTORIZADOR);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_UPDATE_ESTADO(PI_INSTANCIA   IN NUMBER,
                                PI_IDBLOQ      IN NUMBER,
                                PI_ESTADO      IN VARCHAR2,
                                PI_AUTORIZADOR IN VARCHAR2) IS
                                  
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_MANTENEDOR_BLOQ
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 06/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : ACTUALIZAR EL ESTADO DE LA BLOQUEANTE
  -- PARAMETROS                  : - PI_INSTANCIA   | NUMBER(10)
  --                               - PI_IDBLOQ      | NUMBER(17)
  --                               - PI_ESTADO      | VARCHAR2(1)
  --                               - PI_AUTORIZADOR | VARCHAR2(10)
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  V_FECHA_BT     DATE        := NULL;
  V_TIPO_AUTO    VARCHAR2(3) := NULL;
  V_ENVIAR_EMAIL VARCHAR2(1) := 'N';
  V_CONT_BLOQ    NUMBER(17)  := 0;
  
  BEGIN    
    -- GET FECHA BANTOTAL --
    BEGIN 
       SELECT A.PGFAPE
         INTO V_FECHA_BT
         FROM FST017 A
        WHERE A.PGCOD = 1;
    EXCEPTION
       WHEN OTHERS THEN
        NULL;
    END;
    
    -- VALIDAR AUTORIZADOR --
    BEGIN
      SELECT 'AUT'
        INTO V_TIPO_AUTO
        FROM AQPD159 A 
       WHERE A.AQPD159INST   = PI_INSTANCIA
         AND A.AQPD159CORBLO = PI_IDBLOQ
         AND A.AQPD159UAPRO  = RPAD(PI_AUTORIZADOR, 10, ' ');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT 'SUP'
            INTO V_TIPO_AUTO
            FROM AQPD159 A, SNG057 B
           WHERE A.AQPD159INST   = PI_INSTANCIA
             AND A.AQPD159CORBLO = PI_IDBLOQ
             AND B.SNG057USR     = A.AQPD159UAPRO
             AND B.SNG057SUP     = RPAD(PI_AUTORIZADOR, 10, ' ')
             AND (B.SNG057INI >= V_FECHA_BT AND B.SNG057FIN <= V_FECHA_BT);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN OTHERS THEN
        NULL;
    END;
        
    IF V_TIPO_AUTO = 'AUT' THEN
      BEGIN
        UPDATE AQPD159 A
          SET A.AQPD159EST    = PI_ESTADO,
              A.AQPD159UAPRR  = PI_AUTORIZADOR,
              A.AQPD159FEACT  = V_FECHA_BT,
              A.AQPD159HORACT = TO_CHAR(SYSDATE, 'HH24:MI:SS')
         WHERE A.AQPD159INST   = PI_INSTANCIA
           AND A.AQPD159CORBLO = PI_IDBLOQ
           AND A.AQPD159UAPRO  = RPAD(PI_AUTORIZADOR, 10, ' ')
           AND A.AQPD159EST    = 'P';
         COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
      END;
    ELSE
      IF V_TIPO_AUTO = 'SUP' THEN
        BEGIN
          UPDATE AQPD159 A
             SET A.AQPD159EST    = PI_ESTADO,
                 A.AQPD159UAPRR  = PI_AUTORIZADOR,
                 A.AQPD159FEACT  = V_FECHA_BT,
                 A.AQPD159HORACT = TO_CHAR(SYSDATE, 'HH24:MI:SS')
           WHERE A.AQPD159INST   = PI_INSTANCIA
             AND A.AQPD159CORBLO = PI_IDBLOQ
             AND A.AQPD159UAPRO  =
                 (SELECT T.SNG057USR
                    FROM SNG057 T
                   WHERE T.SNG057USR = A.AQPD159UAPRO
                     AND T.SNG057SUP = PI_AUTORIZADOR
                     AND (T.SNG057INI >= V_FECHA_BT AND T.SNG057FIN <= V_FECHA_BT)
                     AND ROWNUM      = 1)
             AND A.AQPD159EST = 'P';
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    END IF;
    
    IF PI_ESTADO = 'A' THEN
      -- UPDATE ESTADO DETALLE --
      BEGIN
        UPDATE AQPC203 A
           SET A.AQPC203ESX = PI_ESTADO
         WHERE A.AQPC203COR = PI_IDBLOQ
           AND (A.AQPC203ESX = 'P' OR A.AQPC203ESX IS NULL)
           AND EXISTS (SELECT 1
                         FROM AQPD159 T
                        WHERE T.AQPD159CORBLO  = A.AQPC203COR
                          AND T.AQPD159INST    = PI_INSTANCIA
                          AND T.AQPD159VAREGLA = A.AQPC203VRE
                          AND T.AQPD159EST     = 'A');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      -- GET CANTIDAD BLOQUEANTES --
      BEGIN
        SELECT COUNT(1)
          INTO V_CONT_BLOQ
          FROM AQPC203 A
         WHERE A.AQPC203COR = PI_IDBLOQ;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
          
      -- UPDATE ESTADO CABECERA --
      BEGIN
         UPDATE AQPC202 A
            SET A.AQPC202EST = PI_ESTADO
           WHERE A.AQPC202INS = PI_INSTANCIA
             AND A.AQPC202COR = PI_IDBLOQ
             AND (A.AQPC202EST = 'P' OR A.AQPC202EST = 'S')
             AND (SELECT COUNT(1)
                   FROM AQPC203 T
                  WHERE T.AQPC203COR = A.AQPC202COR
                    AND T.AQPC203ESX = 'A') = V_CONT_BLOQ;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
    ELSE
      IF PI_ESTADO = 'R' THEN
        -- UPDATE ESTADO DETALLE --
        BEGIN
          UPDATE AQPC203 A
             SET A.AQPC203ESX = PI_ESTADO
           WHERE A.AQPC203COR = PI_IDBLOQ
             AND (A.AQPC203ESX = 'P' OR A.AQPC203ESX IS NULL)
             AND EXISTS (SELECT 1
                           FROM AQPD159 T
                          WHERE T.AQPD159CORBLO  = A.AQPC203COR
                            AND T.AQPD159INST    = PI_INSTANCIA
                            AND T.AQPD159VAREGLA = A.AQPC203VRE
                            AND T.AQPD159EST     = 'R');
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        
        -- UPDATE ESTADO CABECERA --
        BEGIN
           UPDATE AQPC202 A
              SET A.AQPC202EST = PI_ESTADO
             WHERE A.AQPC202INS = PI_INSTANCIA
               AND A.AQPC202COR = PI_IDBLOQ
               AND (A.AQPC202EST = 'P' OR A.AQPC202EST = 'S')
               AND EXISTS (SELECT 1
                             FROM AQPC203 T
                            WHERE T.AQPC203COR = A.AQPC202COR
                              AND T.AQPC203ESX = 'R');
           COMMIT;
        EXCEPTION
           WHEN OTHERS THEN
              NULL;
        END;
      END IF;
    END IF;
    
    -- VALIDAR SI DEBO ENVIAR EL CORREO --
    BEGIN
      SELECT 'S'
        INTO V_ENVIAR_EMAIL
        FROM AQPC202 A
       WHERE A.AQPC202INS = PI_INSTANCIA
         AND A.AQPC202COR = PI_IDBLOQ
         AND (A.AQPC202EST = 'A' OR A.AQPC202EST = 'R');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    IF V_ENVIAR_EMAIL = 'S' THEN
      -- ENVIAR CORREO --
      BEGIN
        SP_CR_ENVIAR_CORREO(PI_INSTANCIA => PI_INSTANCIA,
                            PI_ID_BLOQ   => PI_IDBLOQ);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END SP_CR_UPDATE_ESTADO;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_ENVIAR_CORREO(PI_INSTANCIA IN VARCHAR2,
                                PI_ID_BLOQ   IN NUMBER) IS
                                
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_ENVIAR_CORREO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 06/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : ENVIAR EL CORREO DE LA AUTORIZACION
  -- PARAMETROS                  : - PI_INSTANCIA | NUMBER(10)
  --                               - PI_ID_BLOQ   | NUMBER(17)
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
  V_EMAILS_PARA  VARCHAR2(4000)  := NULL;
  V_EMAILS_CC    VARCHAR2(4000)  := NULL;
  V_CODERR_EMAIL VARCHAR2(5)     := NULL;
  V_MSGERR_EMAIL VARCHAR2(4000)  := NULL;
  V_ESTRUCTURA   VARCHAR2(32767) := NULL;
  V_EST_BLOQ     VARCHAR2(1)     := NULL;
  V_DSC_EST_BLOQ VARCHAR2(20)    := NULL;
  V_MSG_MAIL     CLOB            := NULL;
  
  CURSOR C_REGLAS IS
   SELECT C.AQPD159CMTA, C.AQPD159EST, B.AQPC203VRE
     FROM AQPC202 A, AQPC203 B, AQPD159 C
    WHERE A.AQPC202INS = PI_INSTANCIA
      AND A.AQPC202COR = PI_ID_BLOQ
      AND A.AQPC202EST IN ('A', 'R')
      AND B.AQPC203COR     = A.AQPC202COR
      AND B.AQPC203ESX     = A.AQPC202EST
      AND C.AQPD159CORBLO  = B.AQPC203COR
      AND C.AQPD159VAREGLA = B.AQPC203VRE
      AND C.AQPD159EST     = B.AQPC203ESX;
                 
  BEGIN
    -- GET EMAILS PARA --
    BEGIN
      SELECT REGEXP_REPLACE(
                TRIM(LISTAGG(TRIM(WFUSREMAIL) || ';')
                    WITHIN GROUP(ORDER BY A.AQPC202USU)),
             ';$', '') EMAIL
        INTO V_EMAILS_PARA
        FROM AQPC202 A, WFUSERS B
         WHERE A.AQPC202INS = PI_INSTANCIA
           AND A.AQPC202COR = PI_ID_BLOQ
           AND B.WFUSRCOD   = RPAD(A.AQPC202USU, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    -- GET EMAILS COPIA --
    BEGIN
      SELECT REGEXP_REPLACE(
                TRIM(LISTAGG(TRIM(B.WFUSREMAIL) || ';')
                    WITHIN GROUP(ORDER BY B.WFUSRCOD)),
              ';$', '') EMAIL
        INTO V_EMAILS_CC
        FROM AQPD159 A, WFUSERS B
       WHERE A.AQPD159INST   = PI_INSTANCIA
         AND A.AQPD159CORBLO = PI_ID_BLOQ
         AND A.AQPD159EST    = 'A'
         AND B.WFUSRCOD      = RPAD(A.AQPD159UAPRO, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    -- ENVIAR EMAIL --
    BEGIN
      -- GET ESTADO BLOQUEANTE --
      BEGIN
        SELECT A.AQPC202EST
          INTO V_EST_BLOQ
          FROM AQPC202 A
         WHERE A.AQPC202INS = PI_INSTANCIA
           AND A.AQPC202COR = PI_ID_BLOQ
           AND A.AQPC202EST IN ('A', 'R');
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      -- CREAR CLOB TEMPORAL --
      DBMS_LOB.CREATETEMPORARY(V_MSG_MAIL, TRUE);
      
      IF V_EST_BLOQ = 'A' THEN
        V_ESTRUCTURA := '<p>Estimad@,</p>' ||
                        '<p>Todas las bloqueantes fueron aprobadas.</p>' ||
                        '<p>A continuación se detalla el resultado de las bloqueantes:</p>';
      END IF;
      IF V_EST_BLOQ = 'R' THEN
        V_ESTRUCTURA := '<p>Estimad@,</p>' ||
                        '<p>Una bloqueante fue rechazada, por lo que será necesario volver a gestionar la reprogramación.</p>' ||
                        '<p>A continuación se detalla el resultado de las bloqueantes:</p>';
      END IF;
      
      V_ESTRUCTURA := PQ_AH_EMAIL_TRX.FN_AH_REPLACE_TILDES(V_ESTRUCTURA);
      DBMS_LOB.WRITEAPPEND(V_MSG_MAIL, LENGTH(V_ESTRUCTURA), V_ESTRUCTURA);
      
      -- ARMAR CABECERA GRILLA --
      V_ESTRUCTURA := '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 14px;}</style>' ||
                      '<table cellspacing=0 cellpadding=3 width=900 border="1">';
      
      DBMS_LOB.WRITEAPPEND(V_MSG_MAIL, LENGTH(V_ESTRUCTURA), V_ESTRUCTURA);
      
      V_ESTRUCTURA := '  <tr>' ||
                      '    <td width="300" style="border-bottom: 1px solid black;"><b>Bloqueante</b></td>' ||
                      '    <td width="300" style="border-bottom: 1px solid black;"><b>Comentario</b></td>' ||
                      '    <td width="300" style="border-bottom: 1px solid black;"><b>Estado</b></td>' ||
                      '  </tr>';
      DBMS_LOB.WRITEAPPEND(V_MSG_MAIL, LENGTH(V_ESTRUCTURA), V_ESTRUCTURA);
      
      -- ARMAR EL DETALLE GRILLA --
      
      FOR I IN C_REGLAS LOOP
        IF I.AQPD159EST = 'A' THEN 
          V_DSC_EST_BLOQ := 'APROBADO';
        END IF;
        IF I.AQPD159EST = 'R' THEN 
          V_DSC_EST_BLOQ := 'RECHAZADO';
        END IF;
        
        V_ESTRUCTURA := '  <tr>' ||
                        '    <td width="300" style="border-bottom: 1px solid black;">' || TRIM(I.AQPC203VRE) || '</td>' ||
                        '    <td width="300" style="border-bottom: 1px solid black;">' || TRIM(I.AQPD159CMTA) || '</td>' ||
                        '    <td width="300" style="border-bottom: 1px solid black;">' || TRIM(V_DSC_EST_BLOQ) || '</td>' ||
                        '  </tr>';
                        
        DBMS_LOB.WRITEAPPEND(V_MSG_MAIL, LENGTH(V_ESTRUCTURA), V_ESTRUCTURA);
      END LOOP;
      
      -- CERRAR --
      V_ESTRUCTURA := '</table>';
      DBMS_LOB.WRITEAPPEND(V_MSG_MAIL, LENGTH(V_ESTRUCTURA), V_ESTRUCTURA);
      
      PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_EMAILS_PARA, -- VARCHAR2(4000)
                                       p_DestinatariosCC   => V_EMAILS_CC, -- VARCHAR2(4000)
                                       p_DestinatariosBcc  => ' ', -- VARCHAR2(4000)
                                       p_Mensaje           => V_MSG_MAIL, -- CLOB
                                       p_Remitente         => 'notificacionesbantotal@cajaarequipa.pe', -- VARCHAR2(100)
                                       p_Asunto            => 'AUTORIZACION DE EXCEPCIONES REPROGRAMACION SIN CAPITALIZACION', -- VARCHAR2(100)
                                       p_TipoMensaje       => 'HTML', 
                                       p_Directorio        => ' ', 
                                       p_ArchivosAdjuntos  => ' ',
                                       p_c_coderr          => V_CODERR_EMAIL, -- VARCHAR2(5)
                                       p_c_deserr          => V_MSGERR_EMAIL); -- VARCHAR2(4000)  
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END; 
    
  END SP_CR_ENVIAR_CORREO;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_VALIDAR_ESTADO(PI_INSTANCIA IN  NUMBER,
                                 PI_IDBLOQ    IN  NUMBER,
                                 PO_COD_ERROR OUT NUMBER,
                                 PO_MSG_ERROR OUT VARCHAR2) IS
                                 
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_VALIDAR_ESTADO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 10/11/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : VALIDAR EL ESTADO DE LA BLOQUEANTE
  -- PARAMETROS                  : - PI_INSTANCIA | NUMBER(10)
  --                               - PI_IDBLOQ    | NUMBER(17)
  --                               - PI_COD_ERROR | NUMBER(5)
  --                               - PI_MSG_ERROR | VARCHAR2(255)
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
                                 
  V_EST_BLOQ VARCHAR2(1)    := NULL;
  V_COD_ERROR NUMBER(5)     := 0;
  V_MSG_ERROR VARCHAR2(255) := NULL;
                                 
  BEGIN
    BEGIN
      SELECT A.AQPC202EST
        INTO V_EST_BLOQ
        FROM AQPC202 A
       WHERE A.AQPC202INS = PI_INSTANCIA
         AND A.AQPC202COR = PI_IDBLOQ;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    IF V_EST_BLOQ = 'A' THEN
      V_COD_ERROR := 90001;
      V_MSG_ERROR := 'La bloqueante ya se encuentra aprobada';
    END IF;
    
    IF V_EST_BLOQ = 'R' THEN
      V_COD_ERROR := 90002;
      V_MSG_ERROR := 'La bloqueante fue rechazada, por lo que será necesario volver a gestionar la reprogramación';
    END IF;

    PO_COD_ERROR := V_COD_ERROR;
    PO_MSG_ERROR := V_MSG_ERROR;
  END SP_CR_VALIDAR_ESTADO;
  
  -- ===================================================================================================
  PROCEDURE SP_CR_GET_TIPREPROG(PI_EMPRESA   IN NUMBER,
                                PI_MODULO    IN  NUMBER,
                                PI_SUCURSAL  IN  NUMBER,
                                PI_MONEDA    IN  NUMBER,
                                PI_PAPEL     IN  NUMBER,
                                PI_CUENTA    IN  NUMBER,
                                PI_OPERACION IN  NUMBER,
                                PI_SUBOPER   IN  NUMBER,
                                PI_TIPOPER   IN  NUMBER,
                                PI_FE_RPRG   IN  DATE,
                                PO_TIPO_RPRG OUT VARCHAR2) IS
  
    -- ====================================================================================================
    -- NOMBRE                      : SP_CR_GET_TIPREPROG
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 11/11/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : OBTENER EL TIPO DE REPROGRAMACION
    -- PARAMETROS                  : - PI_EMPRESA   | NUMBER(3)
    --                               - PI_MODULO    | NUMBER(3)
    --                               - PI_SUCURSAL  | NUMBER(3)
    --                               - PI_MONEDA    | NUMBER(4)
    --                               - PI_PAPEL     | NUMBER(4)
    --                               - PI_CUENTA    | NUMBER(9)
    --                               - PI_OPERACION | NUMBER(9)
    --                               - PI_SUBOPER   | NUMBER(3)
    --                               - PI_TIPOPER   | NUMBER(3)
    --                               - PI_FE_RPRG   | DATE
    --                               - PO_TIPO_RPRG | VARCHAR2(20)
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================
  
    V_TIPO_RPRG VARCHAR2(20) := NULL;
  
  BEGIN
    BEGIN
      SELECT CASE
               WHEN A.JAQA400AN1 = 93 THEN 'Desastre Natural'
               WHEN A.JAQA400AN1 = 94 THEN 'Cambio de Fecha'
               WHEN A.JAQA400AN1 = 95 THEN 'Normalizacion'
               ELSE ' '
             END
        INTO V_TIPO_RPRG
        FROM JAQA400 A
       WHERE A.JAQA400EMP = PI_EMPRESA
         AND A.JAQA400MOD = PI_MODULO
         AND A.JAQA400SUC = PI_SUCURSAL
         AND A.JAQA400MDA = PI_MONEDA
         AND A.JAQA400PAP = PI_PAPEL
         AND A.JAQA400CTA = PI_CUENTA
         AND A.JAQA400OPE = PI_OPERACION
         AND A.JAQA400SBO = PI_SUBOPER
         AND A.JAQA400TOP = PI_TIPOPER
         AND A.JAQA400FEC = PI_FE_RPRG
         AND A.JAQA400EST = 'E';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    PO_TIPO_RPRG := V_TIPO_RPRG;
  END SP_CR_GET_TIPREPROG;
  
END PQ_CR_BLOQ_REPROG;
/
