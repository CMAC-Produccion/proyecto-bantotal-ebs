CREATE OR REPLACE PACKAGE PQ_CR_CARGA_CAMPANIA IS

   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_CARGA_CAMPANIA
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 30/07/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   -- *****************************************************************

   PROCEDURE SP_CR_ENVIO_MAILS;

/*==================================================================================================================*/
   PROCEDURE SP_CR_ACT_AUX5_JAQZ697;
   
/*==================================================================================================================*/
   PROCEDURE SP_CR_JOB_AUX5_JAQZ697;

END PQ_CR_CARGA_CAMPANIA;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CARGA_CAMPANIA IS

   PROCEDURE SP_CR_ENVIO_MAILS IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_ENVIO_MAILS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 30/07/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- PARAMETROS                  : NINGUNO
   -- USO                         : ENVIA EMAILS A LOS ASESORES
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      ASUNTO        VARCHAR2(100);
      EMISOR        VARCHAR2(100);
      MENSAJE       CLOB;
      COD_ERROR     VARCHAR2(5);
      MSG_ERROR     VARCHAR2(4000);
      EMAIL_ASESOR  VARCHAR2(40);
      EMAIL_DOMINIO VARCHAR2(30);
      DESTN_PARA    VARCHAR2(4000);
      COD_ERRSQL    VARCHAR2(5);
      MSG_ERRSQL    VARCHAR2(4000);
      FECHA_SISTEMA DATE;
      CORRELATIVO   NUMBER(17);
      TILDE         VARCHAR2(30);
      ESPECIAL      VARCHAR2(30);
   
      CURSOR USUARIOS IS
         SELECT DISTINCT UPPER(A1.JAQZ697ASE) AS JAQZ697ASE
           FROM JAQZ697 A1
          WHERE A1.JAQZ697FEP = (SELECT MAX(A2.JAQZ697FEP) 
                                   FROM JAQZ697 A2);
      
      CURSOR EMAILS_GUIA IS
         SELECT *
           FROM FST198 A1
          WHERE A1.TP1COD   = 1
            AND A1.TP1COD1  = 111154
            AND A1.TP1CORR1 = 1
            AND A1.TP1CORR2 = 44
            AND A1.TP1CORR3 > 0
            AND A1.TP1NRO1  = 1;
      
      CURSOR TILDES IS
         SELECT *
           FROM FST198 A1
          WHERE A1.TP1COD   = 1
            AND A1.TP1COD1  = 10825
            AND A1.TP1CORR1 = 75
            AND A1.TP1CORR2 = 1;
   BEGIN
      FECHA_SISTEMA := NULL;
      BEGIN
         SELECT A1.PGFAPE
           INTO FECHA_SISTEMA
           FROM FST017 A1
          WHERE A1.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
      	  NULL;
      END;
      
      CORRELATIVO := 0;
      BEGIN
         SELECT NVL(MAX(A1.AQPC793CORR), 0)
           INTO CORRELATIVO
           FROM AQPC793 A1
          WHERE A1.AQPC793FHREG = FECHA_SISTEMA
            AND A1.AQPC793PGM   = 'PQ_CR_CARGA_CAMPANIA.SP_CR_ENVIO_MAILS';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   
      FOR J1 IN USUARIOS LOOP
         COD_ERROR   := '00000';
         MSG_ERROR   := ' ';
         CORRELATIVO := CORRELATIVO + 1;
                  
         EMAIL_ASESOR := NULL;
         BEGIN
            SELECT TRIM(A1.WFUSREMAIL)
              INTO EMAIL_ASESOR
              FROM WFUSERS A1
             WHERE A1.WFUSRCOD = RPAD(J1.JAQZ697ASE, 30, ' ');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               COD_ERROR := '90000';
               MSG_ERROR := 'No existe el correo del usuario ' || TRIM(J1.JAQZ697ASE);
            WHEN OTHERS THEN
               NULL;
         END;
         
         IF COD_ERROR <> '00000' OR EMAIL_ASESOR IS NULL THEN
            BEGIN
               INSERT INTO AQPC793
                  (AQPC793CORR,
                   AQPC793FHREG,
                   AQPC793HOREG,
                   AQPC793PGM,
                   AQPC793CODUSU,
                   AQPC793DTPARA,
                   AQPC793DTCC,
                   AQPC793DTBCC,
                   AQPC793ASUNTO,
                   AQPC793EMISOR,
                   AQPC793MENSJE,
                   AQPC793ENVIO,
                   AQPC793CODERR,
                   AQPC793MSGERR)
               VALUES
                  (CORRELATIVO,
                   FECHA_SISTEMA,
                   TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                   'PQ_CR_CARGA_CAMPANIA.SP_CR_ENVIO_MAILS',
                   J1.JAQZ697ASE,
                   ' ',
                   ' ',
                   ' ',
                   ' ',
                   ' ',
                   ' ',
                   'N',
                   COD_ERROR,
                   MSG_ERROR);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         ELSE
            DESTN_PARA := NULL;
            FOR J2 IN EMAILS_GUIA LOOP
               EMAIL_DOMINIO := NULL;
               BEGIN
                  SELECT TRIM(A1.TP1DESC)
                    INTO EMAIL_DOMINIO
                    FROM FST198 A1
                   WHERE A1.TP1COD   = 1
                     AND A1.TP1COD1  = 111154
                     AND A1.TP1CORR1 = 1
                     AND A1.TP1CORR2 = 45
                     AND A1.TP1CORR3 > 0
                     AND A1.TP1NRO1  = 1
                     AND A1.TP1NRO3  = J2.TP1NRO3;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               
               IF DESTN_PARA IS NULL THEN
                  DESTN_PARA := TRIM(EMAIL_ASESOR) || ';' || TRIM(J2.TP1DESC) || TRIM(EMAIL_DOMINIO);
               ELSE
                  DESTN_PARA := TRIM(DESTN_PARA) || ';' || TRIM(J2.TP1DESC) || TRIM(EMAIL_DOMINIO);
               END IF;
            END LOOP;
            
            IF DESTN_PARA IS NULL THEN
               DESTN_PARA := TRIM(EMAIL_ASESOR);
            END IF;
            
            BEGIN
               ASUNTO  := 'NOTIFICACION - Nueva Carga de Campania';
               EMISOR  := 'notificaciones@cajaarequipa.pe';
               MENSAJE := '<html>
                              <head><style type="text/css"></style></head>
                              <body>
                                <p>Estimad@,</p>
                                <p>El día de hoy se realizó una nueva carga de campaña, verifica las nuevas 
                                   ofertas para tus clientes en tu panel ingresando a BANTOTAL</p>
                              </body>
                           </html>';
                           
               FOR J3 IN TILDES LOOP
                  TILDE    := NULL;
                  ESPECIAL := NULL;
                  
                  TILDE    := SUBSTR(TRIM(J3.TP1DESC), 1, 1);
                  ESPECIAL := SUBSTR(TRIM(J3.TP1DESC), 3, LENGTH(TRIM(J3.TP1DESC)) - 2);
                     
                  MENSAJE  := REPLACE(MENSAJE, TILDE, ESPECIAL);
               END LOOP;
               
               PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => DESTN_PARA, 
                                                p_DestinatariosCC   => ' ', 
                                                p_DestinatariosBcc  => ' ', 
                                                p_Mensaje           => MENSAJE, 
                                                p_Remitente         => EMISOR, 
                                                p_Asunto            => ASUNTO, 
                                                p_TipoMensaje       => 'HTML', 
                                                p_Directorio        => ' ', 
                                                p_ArchivosAdjuntos  => ' ',
                                                p_c_coderr          => COD_ERROR, 
                                                p_c_deserr          => MSG_ERROR);
            EXCEPTION
               WHEN OTHERS THEN
                  COD_ERRSQL := '00000';
                  MSG_ERRSQL := ' ';
                  
                  COD_ERRSQL := TRIM(TO_CHAR(SQLCODE));
                  MSG_ERRSQL := REPLACE(TRIM(SQLERRM), 'ORA' || SQLCODE || ': ', ' ');
                  
                  BEGIN
                     INSERT INTO AQPC793
                        (AQPC793CORR,
                         AQPC793FHREG,
                         AQPC793HOREG,
                         AQPC793PGM,
                         AQPC793CODUSU,
                         AQPC793DTPARA,
                         AQPC793DTCC,
                         AQPC793DTBCC,
                         AQPC793ASUNTO,
                         AQPC793EMISOR,
                         AQPC793MENSJE,
                         AQPC793ENVIO,
                         AQPC793CODERR,
                         AQPC793MSGERR)
                     VALUES
                        (CORRELATIVO,
                         FECHA_SISTEMA,
                         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                         'PQ_CR_CARGA_CAMPANIA.SP_CR_ENVIO_MAILS',
                         J1.JAQZ697ASE,
                         DESTN_PARA,
                         ' ',
                         ' ',
                         ASUNTO,
                         EMISOR,
                         MENSAJE,
                         'N',
                         COD_ERRSQL,
                         MSG_ERRSQL);
                     COMMIT;
                  EXCEPTION
                     WHEN OTHERS THEN
                        NULL;
                  END;
            END;
            
            IF COD_ERROR <> '000' THEN
               BEGIN
                  INSERT INTO AQPC793
                     (AQPC793CORR,
                      AQPC793FHREG,
                      AQPC793HOREG,
                      AQPC793PGM,
                      AQPC793CODUSU,
                      AQPC793DTPARA,
                      AQPC793DTCC,
                      AQPC793DTBCC,
                      AQPC793ASUNTO,
                      AQPC793EMISOR,
                      AQPC793MENSJE,
                      AQPC793ENVIO,
                      AQPC793CODERR,
                      AQPC793MSGERR)
                  VALUES
                     (CORRELATIVO,
                      FECHA_SISTEMA,
                      TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                      'PQ_CR_CARGA_CAMPANIA.SP_CR_ENVIO_MAILS',
                      J1.JAQZ697ASE,
                      DESTN_PARA,
                      ' ',
                      ' ',
                      ASUNTO,
                      EMISOR,
                      MENSAJE,
                      'N',
                      COD_ERROR,
                      MSG_ERROR);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            ELSE
               BEGIN
                  INSERT INTO AQPC793
                     (AQPC793CORR,
                      AQPC793FHREG,
                      AQPC793HOREG,
                      AQPC793PGM,
                      AQPC793CODUSU,
                      AQPC793DTPARA,
                      AQPC793DTCC,
                      AQPC793DTBCC,
                      AQPC793ASUNTO,
                      AQPC793EMISOR,
                      AQPC793MENSJE,
                      AQPC793ENVIO,
                      AQPC793CODERR,
                      AQPC793MSGERR)
                  VALUES
                     (CORRELATIVO,
                      FECHA_SISTEMA,
                      TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                      'PQ_CR_CARGA_CAMPANIA.SP_CR_ENVIO_MAILS',
                      J1.JAQZ697ASE,
                      DESTN_PARA,
                      ' ',
                      ' ',
                      ASUNTO,
                      EMISOR,
                      MENSAJE,
                      'S',
                      COD_ERROR,
                      MSG_ERROR);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
         END IF;
      END LOOP;
   END SP_CR_ENVIO_MAILS;

/*==================================================================================================================*/
   PROCEDURE SP_CR_ACT_AUX5_JAQZ697 IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_ACT_AUX5_JAQZ697
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 30/07/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- PARAMETROS                  : NINGUNO
   -- USO                         : ACTUALIZA LOS SIGUIENTES CAMPOS DE LA TABLA JAQZ697:
   --                               - JAQZ697AU5  : INDICADOR (AQPC796IND)
   --                               - JAQZ697AUX1 : FECHA DE REGISTRO (AQPC796FHREG)
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
      FECHA_SISTEMA DATE;
      CORRELATIVO   NUMBER(17);
      
      CURSOR USRBNDJ_PUENTE IS
         SELECT *
           FROM USRBNDJ.AQPC795 A1;
   
      CURSOR BT_PUENTE IS 
         SELECT A1.*
           FROM AQPC796 A1, USRBNDJ.AQPC795 B1
          WHERE A1.AQPC796CORR  = B1.AQPC795CORR
            AND A1.AQPC796FHREG = FECHA_SISTEMA
            AND A1.AQPC796HOREG = (SELECT MAX(A2.AQPC796HOREG)
                                     FROM AQPC796 A2
                                    WHERE A2.AQPC796CORR  = A1.AQPC796CORR
                                      AND A2.AQPC796FHREG = A1.AQPC796FHREG);
   BEGIN
      BEGIN
         UPDATE TAB_JOBS A1
            SET A1.D_FECINI = SYSDATE
          WHERE A1.N_NUMER1 = 1
            AND A1.C_CODAGE = 'CRGCMP';
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
          WHERE A1.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
           NULL;
      END;
      
      CORRELATIVO := 0;
      BEGIN
         SELECT NVL(MAX(A1.AQPC796NREG), 0)
           INTO CORRELATIVO
           FROM AQPC796 A1
          WHERE A1.AQPC796FHREG = FECHA_SISTEMA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      FOR J1 IN USRBNDJ_PUENTE LOOP
         BEGIN
            CORRELATIVO := CORRELATIVO + 1;
            
            INSERT INTO AQPC796
               (AQPC796NREG,
                AQPC796FHREG,
                AQPC796HOREG,
                AQPC796FHCRG,
                AQPC796CORR,
                AQPC796IND)
            VALUES 
               (CORRELATIVO,
                FECHA_SISTEMA,
                TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                J1.AQPC795FHCRG,
                J1.AQPC795CORR,
                J1.AQPC795IND);
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
      
      FOR J2 IN BT_PUENTE LOOP
         BEGIN
            UPDATE JAQZ697 A1
               SET A1.JAQZ697AU5  = J2.AQPC796IND,
                   A1.JAQZ697AUX2 = J2.AQPC796FHREG
             WHERE A1.JAQZ697FEP = J2.AQPC796FHCRG
               AND A1.JAQZ697COR = J2.AQPC796CORR;
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
      
      
      
      BEGIN
         UPDATE TAB_JOBS A1
            SET A1.D_FECFIN = SYSDATE
          WHERE A1.N_NUMER1 = 1
            AND A1.C_CODAGE = 'CRGCMP';
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
   END SP_CR_ACT_AUX5_JAQZ697;

/*==================================================================================================================*/
   PROCEDURE SP_CR_JOB_AUX5_JAQZ697 IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_JOB_AUX5_JAQZ697
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 01/08/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- PARAMETROS                  : NINGUNO
   -- USO                         : JOB DEL PROCEDIMIENTO SP_CR_ACT_AUX5_JAQZ697
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      NRO_JOB NUMBER;
      V_CONTADOR NUMBER(17);
      V_LIMITE_JOBS NUMBER(9);
   BEGIN
      BEGIN
         DELETE
            FROM TAB_JOBS A1
           WHERE A1.C_CODAGE = 'CRGCMP';
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         NRO_JOB := 0;
         IF SYS.FN_BD_ISRAC = 'TRUE' THEN
            DBMS_JOB.SUBMIT(JOB       => NRO_JOB,
                            WHAT      => 'BEGIN PQ_CR_CARGA_CAMPANIA.SP_CR_ACT_AUX5_JAQZ697; END;',
                            NEXT_DATE => SYSDATE + 1 / (24 * 180),
                            INTERVAL  => NULL,
                            NO_PARSE  => FALSE,
                            INSTANCE  => 1,
                            FORCE     => FALSE);
         ELSE
            DBMS_JOB.SUBMIT(JOB       => NRO_JOB,
                            WHAT      => 'BEGIN PQ_CR_CARGA_CAMPANIA.SP_CR_ACT_AUX5_JAQZ697; END;',
                            NEXT_DATE => SYSDATE + 1 / (24 * 180),
                            INTERVAL  => NULL,
                            NO_PARSE  => FALSE,
                            FORCE     => FALSE);
            END IF;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      V_LIMITE_JOBS := 0;
      BEGIN
      SELECT TP1NRO1
        INTO V_LIMITE_JOBS
        FROM FST198
       WHERE TP1COD   = 1
         AND TP1COD1  = 11169
         AND TP1CORR1 = 11
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        V_LIMITE_JOBS := 20;
    END;
      
      V_CONTADOR := 0;
      BEGIN
         SELECT NVL(COUNT(*), 0)
           INTO V_CONTADOR
           FROM DBA_JOBS A1
          WHERE UPPER(A1.WHAT) LIKE '%PQ_CR_CARGA_CAMPANIA.SP_CR_ACT_AUX5_JAQZ697%';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      WHILE V_CONTADOR = V_LIMITE_JOBS LOOP
        BEGIN
          SELECT NVL(COUNT(*), 0)
            INTO V_CONTADOR
            FROM DBA_JOBS X
           WHERE UPPER(X.WHAT) LIKE '%PQ_CR_CARGA_CAMPANIA.SP_CR_ACT_AUX5_JAQZ697%';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END LOOP;
      
      BEGIN
         INSERT INTO TAB_JOBS
            (C_CODAGE, 
             N_NUMER1, 
             C_DETJOB)
         VALUES
            ('CRGCMP',
             1,
             'BEGIN PQ_CR_CARGA_CAMPANIA.SP_CR_ACT_AUX5_JAQZ697; END;');
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
   END SP_CR_JOB_AUX5_JAQZ697;

END PQ_CR_CARGA_CAMPANIA;
/

