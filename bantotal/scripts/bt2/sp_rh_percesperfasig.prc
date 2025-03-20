CREATE OR REPLACE PROCEDURE "SP_RH_PERCESPERFASIG" IS
  -- *****************************************************************
  -- NOMBRE                     : SP_RH_PERCESPERFASIG
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 25/01/2024
  -- AUTOR DE CREACIÓN          : ERIKA HIDALGO
  -- USO                        : Personal cesado con perfiles asignados
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      :
  -- FECHA DE MODIFICACIÓN      :
  -- AUTOR DE MODIFICACIÓN      :
  CURSOR C_TRABCESA IS
    SELECT * FROM CRDTCAP;
  CURSOR C_MAILS IS
    SELECT 'ehidalgom@cajaarequipa.pe' P_C_RECIPIENTE
      FROM DUAL
    UNION
    SELECT 'kcabrerac@cajaarequipa.pe' P_C_RECIPIENTE
      FROM DUAL
    UNION
    SELECT 'lcarpio@cajaarequipa.pe' P_C_RECIPIENTE
      FROM DUAL
    UNION
    SELECT 'cnavarro@cajaarequipa.pe' P_C_RECIPIENTE
      FROM DUAL
    UNION
    SELECT 'rzegarrae@cajaarequipa.pe' P_C_RECIPIENTE
      FROM DUAL
    UNION
    SELECT 'rmezac@cajaarequipa.pe' P_C_RECIPIENTE
      FROM DUAL
    UNION
    SELECT 'acordova@cajaarequipa.pe' P_C_RECIPIENTE
      FROM DUAL
    UNION
    SELECT 'vdiazf@cajaarequipa.pe' P_C_RECIPIENTE
      FROM DUAL;

  V_WSTRING     VARCHAR2(32000);
  V_HEADER      VARCHAR2(10000);
  V_FROM        VARCHAR2(80);
  V_RECIPIENT   VARCHAR2(80);
  V_SUBJECT     VARCHAR2(80);
  C_SMTP_SERVER VARCHAR2(30);
  V_CONEXION    UTL_SMTP.CONNECTION;
  MSG           VARCHAR2(32767);
  P_C_MSGERR    VARCHAR2(1000);
  VHOST_NAME    VARCHAR2(100);
  RAWDATA       RAW(32000);
  V_FOUND       NUMBER;
  N_PORT        NUMBER;
  N_CONT        NUMBER;
  N_CONT2       NUMBER;
BEGIN

  SELECT COUNT(1)
    INTO N_CONT
    FROM PRFU00 A
   WHERE A.PRFGCOD = 'CESADO'
     AND (SELECT COUNT(1)
            FROM PRFU00 L
           WHERE L.PGCOD = 1
             AND L.UBUSER = A.UBUSER) > 1;

  IF N_CONT > 0 THEN
    DELETE CRDTCAP;
    COMMIT;
    INSERT INTO CRDTCAP
      (N_MONTO1,
       C_DESCRI1,
       C_DESCRI2,
       D_FECHA1,
       D_FECHA2,
       C_DESCRI3,
       N_MONTO2)
      SELECT PGCOD,
             PRFGCOD,
             UBUSER,
             PRFUFECALT,
             PRFUFECVTO,
             PRFUUSER,
             PRFUTPO
        FROM PRFU00 B
       WHERE B.PRFGCOD <> 'CESADO'
         AND B.UBUSER IN
             (SELECT A.UBUSER
                FROM PRFU00 A
               WHERE A.PRFGCOD = 'CESADO'
                 AND (SELECT COUNT(*)
                        FROM PRFU00 L
                       WHERE L.PGCOD = 1
                         AND L.UBUSER = A.UBUSER) > 1);
    COMMIT;
  
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
  
    SELECT COUNT(*)
      INTO V_FOUND
      FROM SYSTABREP.HOSTNAMES
     WHERE HABILITADO = 'S'
       AND UPPER(HOST_NAME) = UPPER(VHOST_NAME);
  
    IF V_FOUND = 1 THEN
      FOR I IN C_MAILS LOOP
        BEGIN
          V_FROM        := 'ceseusuarios@cajaarequipa.pe';
          V_RECIPIENT   := I.P_C_RECIPIENTE;
          V_SUBJECT     := 'Personal cesado con perfiles asignados - ' ||
                           TO_CHAR(SYSDATE, 'yyyy.mm.dd');
          C_SMTP_SERVER := '10.0.200.68';
          N_PORT        := 2528;
        
          SELECT HOST_NAME
            INTO C_SMTP_SERVER
            FROM SYSTABREP.HOSTNAMES_MAIL
           WHERE HABILITADO = 'S';
          SELECT PORT
            INTO N_PORT
            FROM SYSTABREP.HOSTNAMES_MAIL
           WHERE HABILITADO = 'S';
          --        V_CONEXION    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, 2528);
          V_CONEXION := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, N_PORT);
          MSG        := 'Date: ' ||
                        TO_CHAR(SYSDATE, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                        UTL_TCP.CRLF || 'From: ' || V_FROM || UTL_TCP.CRLF ||
                        'Subject: ' || V_SUBJECT || UTL_TCP.CRLF || 'To: ' ||
                        V_RECIPIENT || UTL_TCP.CRLF;
        
          --SE NEGOCIA LA TRANSACCION CON EL SERVIDOR SMTP
          UTL_SMTP.HELO(V_CONEXION, C_SMTP_SERVER);
          UTL_SMTP.MAIL(V_CONEXION, V_FROM);
          UTL_SMTP.RCPT(V_CONEXION, V_RECIPIENT);
          UTL_SMTP.OPEN_DATA(V_CONEXION);
        
          --SE ESCRIBE LA CABECERA
          UTL_SMTP.WRITE_DATA(V_CONEXION, MSG);
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              'MIME-Version: 1.0' || UTL_TCP.CRLF); -- USE MIME MAIL STANDARD
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              'Content-Type: multipart/mixed;' ||
                              UTL_TCP.CRLF);
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              ' boundary=-----SECBOUND' || UTL_TCP.CRLF ||
                              UTL_TCP.CRLF);
        
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              '-------SECBOUND' || UTL_TCP.CRLF ||
                              'Content-Type: text/plain;' || UTL_TCP.CRLF);
          --'CONTENT-TYPE: TEXT/PLAIN; CHARSET=ISO-8859-1' || UTL_TCP.CRLF);
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              'Content-Transfer_Encoding: 8bit' || --8BIT
                              UTL_TCP.CRLF || UTL_TCP.CRLF ||
                              'Adj. Personal cesado con perfiles asignados - ' ||
                              TO_CHAR(SYSDATE, 'DD-MM-RRRR') || CHR(13) ||
                              CHR(13) || CHR(13) || UTL_TCP.CRLF); --MESSAGE BODY
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              '-------SECBOUND' || UTL_TCP.CRLF ||
                              --'CONTENT-TYPE: TEXT/PLAIN;' || UTL_TCP.CRLF);--
                               'Content-Type: text/plain; charset=iso-8859-1' ||
                               UTL_TCP.CRLF);
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              ' name=PERS_CESADO_PERFASIG_' ||
                              TO_CHAR(SYSDATE, 'DD-MM-RR') || UTL_TCP.CRLF); --XLS
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              'Content-Transfer_Encoding: 8bit' || --8BIT
                              UTL_TCP.CRLF);
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              'Content-Disposition: attachment;' ||
                              UTL_TCP.CRLF);
          UTL_SMTP.WRITE_DATA(V_CONEXION,
                              ' filename=PERSONAL_CESADO_PERFASIG_' ||
                              TO_CHAR(SYSDATE, 'DD-MM-RR') || '.xls' ||
                              UTL_TCP.CRLF || UTL_TCP.CRLF);
        
          V_HEADER := 'EMPRESA' || CHR(9) || 'PERFIL DE GRUPO (CÓDIGO)' ||
                      CHR(9) || 'USUARIO' || CHR(9) ||
                      'FECHA ALTA - REL.PERF.USER' || CHR(9) ||
                      'FEC.VTO. P/REL.PERF.USER' || CHR(9) ||
                      'USER OPERADOR DEL ALTA' || CHR(9) ||
                      'TIPO DE USUARIO';
          UTL_SMTP.WRITE_DATA(V_CONEXION, V_HEADER || UTL_TCP.CRLF);
        
          FOR R_TRAB IN C_TRABCESA LOOP
            V_WSTRING := TRUNC(R_TRAB.N_MONTO1) || CHR(9) ||
                         R_TRAB.C_DESCRI1 || CHR(9) || R_TRAB.C_DESCRI2 ||
                         CHR(9) || TO_CHAR(R_TRAB.D_FECHA1, 'RRRR/MM/DD') ||
                         CHR(9) || TO_CHAR(R_TRAB.D_FECHA2, 'RRRR/MM/DD') ||
                         CHR(9) || R_TRAB.C_DESCRI3 || CHR(9) ||
                         TRUNC(R_TRAB.N_MONTO2);
            --UTL_SMTP.WRITE_DATA(V_CONEXION,V_WSTRING||UTL_TCP.CRLF);
            -- TRANSFORMA EL V_WSTRING EN RAW Y ESCRIBE EL CUERPO DEL CORREO
            RAWDATA := UTL_RAW.CAST_TO_RAW(V_WSTRING || UTL_TCP.CRLF);
            UTL_SMTP.WRITE_RAW_DATA(V_CONEXION, RAWDATA);
          
          END LOOP;
        
          UTL_SMTP.WRITE_DATA(V_CONEXION, UTL_TCP.CRLF);
          UTL_SMTP.WRITE_DATA(V_CONEXION, UTL_TCP.CRLF);
          UTL_SMTP.WRITE_DATA(V_CONEXION, '-------SECBOUND--'); -- END MIME MAIL
          UTL_SMTP.WRITE_DATA(V_CONEXION, UTL_TCP.CRLF);
        
          --CERRAMOS LA CONEXION
          UTL_SMTP.CLOSE_DATA(V_CONEXION);
          UTL_SMTP.QUIT(V_CONEXION);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END LOOP;
    END IF;
  
    SELECT COUNT(1)
      INTO N_CONT2
      FROM PRFU00 B
     WHERE B.PRFGCOD <> 'CESADO'
       AND B.UBUSER IN
           (SELECT A.UBUSER
              FROM PRFU00 A
             WHERE A.PRFGCOD = 'CESADO'
               AND (SELECT COUNT(1)
                      FROM PRFU00 L
                     WHERE L.PGCOD = 1
                       AND L.UBUSER = A.UBUSER) > 1);
  
    DELETE FROM PRFU00 B
     WHERE B.PRFGCOD <> 'CESADO'
       AND B.UBUSER IN
           (SELECT A.UBUSER
              FROM PRFU00 A
             WHERE A.PRFGCOD = 'CESADO'
               AND (SELECT COUNT(1)
                      FROM PRFU00 L
                     WHERE L.PGCOD = 1
                       AND L.UBUSER = A.UBUSER) > 1);
    COMMIT;
    INSERT INTO AQPB876
    VALUES
      (USER,
       SYSDATE,
       'SP_RH_PERCESPERFASIG',
       'Eliminó ' || N_CONT2 || ' registros.');
    COMMIT;
  END IF;
END SP_RH_PERCESPERFASIG;
 /* GOLDENGATE_DDL_REPLICATION */
/

