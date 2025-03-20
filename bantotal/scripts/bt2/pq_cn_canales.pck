CREATE OR REPLACE PACKAGE PQ_CN_CANALES IS
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CN_CANALES
  -- Sistema               : BANTOTAL
  -- Módulo                : CANALES
  -- Versión               : 1.0
  -- Fecha de Creación     : 08/02/2024
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Uso                   : Funcionalidad de envio de correos
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 17/07/2024
  -- Autor de Creación     : Danny Manrique Callata
  -- Descripción Modific.  : Se agrega validacion de correo
  -- Fecha de Modificación : 17/07/2024
  -- Autor de Creación     : Danny Manrique Callata
  -- Descripción Modific.  : Actualizacion de validacion de correo
  -- ------------------------------------------------------------------------------------------------
  
  PROCEDURE sp_enviar_correo(pc_deststos IN VARCHAR2,
                             pc_destsccs IN VARCHAR2,
                             pc_destsbcc IN VARCHAR2,
                             po_msjemail IN CLOB,
                             pc_remitent IN VARCHAR2,
                             pc_asuntoms IN VARCHAR2,
                             pc_tipomsje IN VARCHAR2,
                             pc_direccto IN VARCHAR2,
                             pc_archadjt IN VARCHAR2,
                             pc_coderror OUT VARCHAR2,
                             pc_msjerror OUT VARCHAR2
                            );
                                                    
  PROCEDURE sp_enviar_correo_reenvio(pc_destinos IN VARCHAR2,
                                     pc_destinoscc IN VARCHAR2,
                                     pc_destinosbcc IN VARCHAR2,
                                     pc_mensaje IN CLOB,
                                     pc_remitente IN VARCHAR2,
                                     pc_asunto IN VARCHAR2,
                                     pc_tipomensaje IN VARCHAR2,
                                     pc_directorio IN VARCHAR2,
                                     pc_archivo IN VARCHAR2,
                                     pc_coderr OUT VARCHAR2,
                                     pc_msjerr OUT VARCHAR2
                                    );                            
END PQ_CN_CANALES;
/

CREATE OR REPLACE PACKAGE BODY PQ_CN_CANALES IS

  PROCEDURE sp_enviar_correo(pc_deststos IN VARCHAR2,  -- Destinatarios
                             pc_destsccs IN VARCHAR2,  -- Destinatarios Copia
                             pc_destsbcc IN VARCHAR2,  -- Destinatarios Copia Oculta
                             po_msjemail IN CLOB,      -- Mensaje
                             pc_remitent IN VARCHAR2,  -- Remitente
                             pc_asuntoms IN VARCHAR2,  -- Asunto
                             pc_tipomsje IN VARCHAR2,  -- Tipo Mensaje
                             pc_direccto IN VARCHAR2,  -- Direcctorio
                             pc_archadjt IN VARCHAR2,  -- Archivos Adjuntos
                             pc_coderror OUT VARCHAR2, -- Codigo Error
                             pc_msjerror OUT VARCHAR2  -- Mensaje Error
                             ) IS 
    
    v_host_name           VARCHAR2(100);
    v_found               NUMBER;
    v_smtp_server         VARCHAR2(100);
    v_smtp_port           NUMBER;
    v_conexion            UTL_SMTP.CONNECTION;
    v_recipient           VARCHAR2(100);
    v_from                VARCHAR2(100) := pc_remitent;
    v_to                  VARCHAR2(32767) := pc_deststos;
    v_cc                  VARCHAR2(32767) := pc_destsccs;
    v_bcc                 VARCHAR2(32767) := pc_destsbcc;
    v_subject             VARCHAR2(500) := pc_asuntoms;
    v_filepath            VARCHAR2(32767) := pc_direccto;
    v_content_type        VARCHAR2(50) := pc_tipomsje;
    v_attachments         VARCHAR2(32767) := pc_archadjt;
    v_header              VARCHAR2(32767);
    v_body                VARCHAR2(32767);
    v_file                VARCHAR2(32767);
    v_end                 VARCHAR2(100);
    v_boundary            VARCHAR2(50) := 'DMW.Boundary.B164240059B29C0E4EFEC397';
    v_content_disposition VARCHAR2(50);
    v_transfer_encoding   VARCHAR2(50);
    v_filename            VARCHAR2(1000);
    v_res                 VARCHAR2(100);
      
    FUNCTION agregar_adjunto(po_conexion IN OUT UTL_SMTP.CONNECTION,
                             pc_filename IN VARCHAR2,
                             pc_direccto IN VARCHAR2) RETURN VARCHAR2 IS
                      
      v_chunk_size          BINARY_INTEGER := 672 * 3;
      v_bfile               BFILE;
      v_file_length         PLS_INTEGER;
      v_buf                 RAW(2100);
      v_modulo              PLS_INTEGER;
      v_pieces              PLS_INTEGER;
      v_file_pos            PLS_INTEGER := 1;
      v_content_type        VARCHAR2(50) := 'text/plain';
      v_boundary            VARCHAR2(50) := 'DMW.Boundary.B164240059B29C0E4EFEC397';
      v_content_disposition VARCHAR2(50) := 'inline';
      v_transfer_encoding   VARCHAR2(50) := 'base64';
      v_file                VARCHAR2(32767);
      
    BEGIN                
      v_file := '--' || v_boundary || UTL_TCP.CRLF ||
               'Content-Type: ' || v_content_type || '; name="' || pc_filename || '"' || UTL_TCP.CRLF ||
               'Content-Disposition: ' || v_content_disposition || '; filename="' || pc_filename || '"' || UTL_TCP.CRLF ||
               'Content-Transfer-Encoding: ' || v_transfer_encoding || UTL_TCP.CRLF || UTL_TCP.CRLF;

      UTL_SMTP.WRITE_DATA(po_conexion, v_file);
                   
      v_bfile := BFILENAME(pc_direccto, pc_filename);
      v_file_length := DBMS_LOB.GETLENGTH(v_bfile);
      v_pieces := TRUNC(v_file_length / v_chunk_size);
      v_modulo := MOD(v_file_length, v_chunk_size);

      IF (v_modulo <> 0) THEN
        v_pieces := v_pieces + 1;
      END IF;
      
      DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);

      FOR i IN 1..v_pieces LOOP
        v_buf := NULL;
        DBMS_LOB.READ(v_bfile, v_chunk_size, v_file_pos, v_buf);
        v_file_pos := i * v_chunk_size + 1;
        UTL_SMTP.WRITE_RAW_DATA(po_conexion, UTL_ENCODE.BASE64_ENCODE(v_buf));
      END LOOP;

      DBMS_LOB.FILECLOSE(v_bfile);
      UTL_SMTP.WRITE_DATA(po_conexion, UTL_TCP.CRLF);
      RETURN NULL;
    EXCEPTION
      WHEN OTHERS THEN
        pc_coderror := '997';
        pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM);
        BEGIN
          UTL_SMTP.CLOSE_CONNECTION(po_conexion);
        EXCEPTION
          WHEN OTHERS THEN
            pc_coderror := '97x';
            pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM);       
        END;
        RETURN pc_msjerror;
    END agregar_adjunto;
    
  BEGIN
    pc_coderror := '000';
    pc_msjerror := NULL;
    
    SELECT host_name INTO v_host_name
      FROM V$INSTANCE;

    SELECT COUNT(*) INTO v_found
      FROM systabrep.hostnames
     WHERE habilitado = 'S'
       AND upper(host_name) = upper(v_host_name);
    
    IF v_found = 1 THEN
        BEGIN
          SELECT TRIM(tp1desc) tp1desc
            INTO v_smtp_server
            FROM fst198
           WHERE tp1cod1 = 10801
             AND tp1corr1 = 6
             AND tp1corr2 = 10
             AND tp1corr3 = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            pc_coderror := '999';
            pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM || ' | ' || 'SMTP server IP address was not found');
            RETURN;
        END;

        BEGIN
          SELECT TO_NUMBER(TRIM(tp1desc))
            INTO v_smtp_port
            FROM fst198
           WHERE tp1cod1 = 10801
             AND tp1corr1 = 6
             AND tp1corr2 = 2
             AND tp1corr3 = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            pc_coderror := '998';
            pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM || ' | ' || 'SMTP server port was not found');
            RETURN;
        END;

      v_conexion := UTL_SMTP.OPEN_CONNECTION(v_smtp_server, v_smtp_port);
      UTL_SMTP.HELO(v_conexion, v_smtp_server);
      UTL_SMTP.MAIL(v_conexion, v_from);
          
      FOR dest IN (SELECT TRIM(REGEXP_SUBSTR(v_to, '[^;]+', 1, LEVEL)) AS recipient
                   FROM dual
                   CONNECT BY REGEXP_SUBSTR(v_to, '[^;]+', 1, LEVEL) IS NOT NULL)
      LOOP
        v_recipient := TRIM(dest.recipient);
        IF v_recipient IS NOT NULL THEN
           UTL_SMTP.RCPT(v_conexion, v_recipient);
        END IF;
      END LOOP;
      
      FOR dest IN (SELECT TRIM(REGEXP_SUBSTR(v_cc, '[^;]+', 1, LEVEL)) AS recipient
                   FROM dual
                   CONNECT BY REGEXP_SUBSTR(v_cc, '[^;]+', 1, LEVEL) IS NOT NULL)
      LOOP
        v_recipient := TRIM(dest.recipient);
        IF v_recipient IS NOT NULL THEN
           UTL_SMTP.RCPT(v_conexion, v_recipient);
        END IF;
      END LOOP;
   
      FOR dest IN (SELECT TRIM(REGEXP_SUBSTR(v_bcc, '[^;]+', 1, LEVEL)) AS recipient
                   FROM dual
                   CONNECT BY REGEXP_SUBSTR(v_bcc, '[^;]+', 1, LEVEL) IS NOT NULL)
      LOOP
        v_recipient := TRIM(dest.recipient);
        IF v_recipient IS NOT NULL THEN
           UTL_SMTP.RCPT(v_conexion, v_recipient);
        END IF;
      END LOOP;
      
      v_header := 'Date: ' || TO_CHAR(SYSDATE + 0.208333333, 'Dy, DD Mon YYYY hh24:mi:ss') || UTL_TCP.CRLF ||
                  'From: ' || v_from || UTL_TCP.CRLF ||
                  'Subject: ' || v_subject || UTL_TCP.CRLF ||
                  'To: ' || v_to || UTL_TCP.CRLF ||
                  'Cc: ' || v_cc || UTL_TCP.CRLF ||
                  'Bcc: ' || v_bcc || UTL_TCP.CRLF ||
                  'MIME-Version: 1.0' || UTL_TCP.CRLF ||
                  'Content-Type: multipart/mixed; boundary="' || v_boundary || '"' || UTL_TCP.CRLF || UTL_TCP.CRLF ||
                  'This is a multi-part message in MIME format.' || UTL_TCP.CRLF || UTL_TCP.CRLF;
      
      UTL_SMTP.OPEN_DATA(v_conexion);
      UTL_SMTP.WRITE_DATA(v_conexion, v_header);
      
      v_body := '--' || v_boundary || UTL_TCP.CRLF ||
                'Content-Type: ' || v_content_type || '; charset=UTF-8' || UTL_TCP.CRLF ||
                'Content-Transfer-Encoding: 7bit' || UTL_TCP.CRLF || UTL_TCP.CRLF ||
                po_msjemail || UTL_TCP.CRLF || UTL_TCP.CRLF;
      
      UTL_SMTP.WRITE_DATA(v_conexion, v_body);
      
      IF v_attachments IS NOT NULL THEN
        FOR v_attachment IN (SELECT TRIM(REGEXP_SUBSTR(v_attachments, '[^;]+', 1, LEVEL)) AS filename
                             FROM dual
                             CONNECT BY REGEXP_SUBSTR(v_attachments, '[^;]+', 1, LEVEL) IS NOT NULL)
        LOOP       
          v_filename := TRIM(v_attachment.filename);
          IF v_filename IS NOT NULL THEN
            BEGIN
              v_res := agregar_adjunto(v_conexion, v_filename, v_filepath);
            EXCEPTION
              WHEN OTHERS THEN
                RETURN;
            END;
          END IF;
        END LOOP;
      END IF;
      
      v_end := '--' || v_boundary || '--' || UTL_TCP.CRLF;
      
      UTL_SMTP.WRITE_DATA(v_conexion, v_end);
      UTL_SMTP.CLOSE_DATA(v_conexion);
      UTL_SMTP.CLOSE_CONNECTION(v_conexion);
    ELSE
      pc_coderror := '996';
      pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM || ' | ' || 'Host was not found');
      RETURN;
    END IF;
  EXCEPTION
    WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
      pc_coderror := '995';
      pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM);
      BEGIN
        UTL_SMTP.CLOSE_CONNECTION(v_conexion);
      EXCEPTION
        WHEN OTHERS THEN
          pc_coderror := '95x';
          pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM);
      END;
    WHEN OTHERS THEN
      pc_coderror := '994';
      pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM);
      BEGIN
        UTL_SMTP.CLOSE_CONNECTION(v_conexion);
      EXCEPTION
        WHEN OTHERS THEN
          pc_coderror := '94x';
          pc_msjerror := TO_CHAR(SQLCODE || ' - ' || SQLERRM);
      END;
  END sp_enviar_correo;
  
  PROCEDURE sp_enviar_correo_reenvio(pc_destinos IN VARCHAR2,
                                     pc_destinoscc IN VARCHAR2,
                                     pc_destinosbcc IN VARCHAR2,
                                     pc_mensaje IN CLOB,
                                     pc_remitente IN VARCHAR2,
                                     pc_asunto IN VARCHAR2,
                                     pc_tipomensaje IN VARCHAR2,
                                     pc_directorio IN VARCHAR2,
                                     pc_archivo IN VARCHAR2,
                                     pc_coderr OUT VARCHAR2,
                                     pc_msjerr OUT VARCHAR2
                                     ) IS 
  BEGIN
    pc_coderr := '000';
    pc_msjerr := '';
    
    --Dmanriquec - validacion correo
    --If pc_destinos <> ' ' THEN
    IF Trim(pc_destinos) IS NOT NULL THEN
      PQ_CN_CANALES.sp_enviar_correo(pc_deststos => pc_destinos,
                                     pc_destsccs => pc_destinoscc,
                                     pc_destsbcc => pc_destinosbcc,
                                     po_msjemail => pc_mensaje,
                                     pc_remitent => pc_remitente,
                                     pc_asuntoms => pc_asunto,
                                     pc_tipomsje => pc_tipomensaje,
                                     pc_direccto => pc_directorio,
                                     pc_archadjt => pc_archivo,
                                     pc_coderror => pc_coderr,
                                     pc_msjerror => pc_msjerr
                                     );
      IF pc_coderr <> '000' THEN
        pc_coderr := '993';
        pc_msjerr := 'Se reenviara el correo en el transcurso del dia...';
        BEGIN
            INSERT INTO aqpa145(aqpa145cor,
                                aqpa145cod,
                                aqpa145fer,
                                aqpa145hre,
                                aqpa145asu,
                                aqpa145par,
                                aqpa145pcc,
                                aqpa145cco,
                                aqpa145msg,
                                aqpa145rem,
                                aqpa145dir,
                                aqpa145adj,
                                aqpa145est,
                                aqpa145nro,
                                aqpa145ax1,
                                aqpa145ax2,
                                aqpa145ax3,
                                aqpa145ax4,
                                aqpa145ax5,
                                aqpa145ax6,
                                aqpa145ax7,
                                aqpa145ax8,
                                aqpa145ax9
                               )
            VALUES(SQ_AH_ID_RENVIO_MAIL.NEXTVAL,
                   991,
                   TRUNC(SYSDATE),
                   TO_CHAR(SYSDATE,'HH24:MI:SS'),
                   pc_asunto,
                   pc_destinos,
                   pc_destinoscc,
                   pc_destinosbcc,
                   pc_mensaje,
                   pc_remitente,
                   pc_directorio,
                   pc_archivo,
                   'P',
                   0,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null
                  );
                  COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            pc_coderr := '992';
            pc_msjerr := SQLERRM;
        END;
      END IF;
    ELSE
        pc_coderr := '994';
        pc_msjerr := 'No se encontro correo vinculado al cliente';
    END IF;  
  END sp_enviar_correo_reenvio; 
END PQ_CN_CANALES;
/

