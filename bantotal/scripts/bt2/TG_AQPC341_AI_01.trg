CREATE OR REPLACE TRIGGER TG_AQPC341_AI_01
  AFTER INSERT ON aqpc341
  FOR EACH ROW

  -- *****************************************************************
  -- Nombre                      : TG_AQPC341_AU_02
  -- Sistema                     : BANTOTAL
  -- M�dulo                      : CANALES
  -- Versi�n                     : 1.0
  -- Fecha de Creaci�n           : 2025.05.12
  -- Autor de Creaci�n           : Renzo Cuadros Salazar
  -- Uso                         : Registro notificaciones push, correo y sms
  -- Estado                      : Activo
  -- Acceso                      : P�blico
  -- Fecha de Modificaci�n       : 23/05/2025
  -- Autor de la Modificaci�n    : Renzo Cuadros
  -- Descripci�n la Modificaci�n : Se agrega trim al campo push token para envitar errores en envios
  -- Fecha de Modificaci�n       : 23/06/2025
  -- Autor de la Modificaci�n    : Renzo Cuadros
  -- Descripci�n la Modificaci�n : Se intercambian los flags de celular y mail
  -- Fecha de Modificaci�n       : 14/07/2025
  -- Autor de la Modificaci�n    : Renzo Cuadros
  -- Descripci�n la modificaci�n : Se toma en cuenta el flag en 's' para celular y correo
  -- Fecha de modificaci�n       : 22/09/2025
  -- Autor de la modificaci�n    : Renzo Cuadros
  -- Descripci�n la modificaci�n : Se obtiene datos del cliente juridico de la FSD001
  -- *****************************************************************
  
DECLARE
  lv_recipient  VARCHAR2(100);
  lv_cliente    VARCHAR2(25);
  lv_operacion  VARCHAR2(50);
  lv_moneda     VARCHAR2(5);
  lv_fecha_hora VARCHAR2(50);
  lv_ubigueo    VARCHAR2(40);
  lv_codigo     VARCHAR2(30);
  lv_fcm_token  VARCHAR2(300);
  lv_mensaje    VARCHAR2(4000) := '';
  lv_correo     VARCHAR2(400) := '';
  ln_celular    NUMBER(12);
  ll_mensaje    CLOB;
  lc_mail       CHAR(1) := 'N';
  lc_cel        CHAR(1) := 'N';
  lc_sex        CHAR(1);
  lv_aux1       VARCHAR2(100);
BEGIN

  lv_codigo := LPAD(:new.AQPC341CTA, 9, '0') ||
               LPAD(:new.AQPC341MOD, 3, '0') ||
               LPAD(:new.AQPC341MDA, 3, '0') ||
               LPAD(:new.AQPC341SBO, 2, '0') ||
               LPAD(:new.AQPC341TOP, 3, '0');

  IF :new.AQPC341MTX = 604 THEN
    lv_moneda := 'S/.';
  ELSE
    lv_moneda := 'USD.';
  END IF;
  
  lv_ubigueo := TRIM(:new.AQPC341NCO);

  IF TRUNC(SYSDATE) = :new.AQPC341FET THEN
    lv_fecha_hora := ' hoy a las ' || SUBSTR(:new.AQPC341HOT, 1, 5);
  ELSE
    lv_fecha_hora := ' el ' || TO_CHAR(:new.AQPC341FET, 'dd/mm') || ' ' ||
                     SUBSTR(:new.AQPC341HOT, 1, 5);
  END IF;

  -- verificamos si esta afiliado
  BEGIN
    SELECT TRIM(x.mail_cliente),
           TO_NUMBER('51' || TRIM(x.celular_cliente)),
           case when x.enviar_mail = 'S' then 'P' else x.enviar_mail end enviar_mail,
           case when x.enviar_celular = 'S' then 'P' else x.enviar_celular end enviar_celular -- rcuadros 14/07/2025           
      INTO lv_correo, ln_celular, lc_mail, lc_cel
      FROM ichannelalert.clientes_afiliados x
     WHERE x.codigo_cliente = lv_codigo
       AND (x.enviar_mail in ('P', 'S') OR x.enviar_celular in ('P', 'S')); -- rcuadros 23/06/2025
  
  EXCEPTION
    WHEN OTHERS THEN
      lv_correo  := NULL;
      ln_celular := NULL;
  END;
  
  -- solo si esta afiliado hacemos algo si no salimos
  IF lv_correo IS NOT NULL OR ln_celular IS NOT NULL THEN
    -- obtenemos nombre del cliente
    BEGIN
      SELECT TRIM(UPPER(a.pfnom1)), a.pfcant
        INTO lv_cliente, lc_sex
        FROM FSD002 a
       WHERE a.pfpais = :new.AQPC341PAI
         AND a.pftdoc = :new.AQPC341TDO
         AND a.pfndoc = :new.AQPC341DOC;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT TRIM(UPPER(SUBSTR(a.penom, 1, 25))), 'N' -- rcuadros 22/09/2025
            INTO lv_cliente, lc_sex
            FROM FSD001 a
           WHERE a.pepais = :new.AQPC341PAI
             AND a.petdoc = :new.AQPC341TDO
             AND a.pendoc = :new.AQPC341DOC;
        EXCEPTION
          WHEN OTHERS THEN
            lv_cliente := NULL;
            lc_sex     := NULL;
        END;
      WHEN OTHERS THEN
        lv_cliente := NULL;
        lc_sex     := NULL;
    END;
    -- verificamos si tiene push activo
    BEGIN
      SELECT JAQZ205AUX2
        INTO lv_fcm_token
        FROM jaqz205
       WHERE JAQZ205NUTAR = (SELECT Z0E478NRO
                               FROM Z0E479
                              WHERE Z0E479SUC = :new.AQPC341SCS
                                AND Z0E479CTA = :new.AQPC341CTA
                                AND Z0E479SCT = :new.AQPC341SBO
                                AND Z0E479MOD = :new.AQPC341MOD
                                AND Z0E479MON = :new.AQPC341MDA
                                AND Z0E479PAP = :new.AQPC341PAP
                                AND Z0E479TOP = :new.AQPC341TOP
                                AND Z0E479OPE = :new.AQPC341OPE
                                AND Z0E479EST = 'AC'
                                AND ROWNUM = 1
                            );
    EXCEPTION
      WHEN OTHERS THEN
        lv_fcm_token := NULL;
    END;
  
    IF :new.AQPC341TIP = 'E' THEN
      lv_operacion := 'ENVIO ' || TRIM(:new.AQPC341BIL);
      lv_recipient := ' para ' || :new.AQPC341RCP;
    ELSE
      lv_operacion := 'ABONO ' || TRIM(:new.AQPC341BIL);
      lv_recipient := ' de ' || :new.AQPC341RCP;
    END IF;
  
    lv_ubigueo := lv_operacion;
  
    -- si tiene fcm token
    IF TRIM(lv_fcm_token) IS NOT NULL THEN -- rcuadros 23/05/2025
      CASE
        WHEN lc_sex = 'M' THEN
          lv_aux1 := 'Estimado ' || lv_cliente;
        WHEN lc_sex = 'F' THEN
          lv_aux1 := 'Estimada ' || lv_cliente;
        ELSE
          lv_aux1 := 'Estimado '; -- rcuadros 22/09/2025
      END CASE;
      lv_mensaje := lv_aux1 ||
                    ' Caja Arequipa le informa sobre la operaci�n ' ||
                    lv_operacion || ' por ' || lv_moneda ||
                    TRIM(TO_CHAR(:new.AQPC341MOT, '9,999,999.90')) ||
                    lv_recipient || lv_fecha_hora || ' realizada en' || ': ' ||
                    lv_ubigueo;
    
      -- registra notificaci�n
      BEGIN
        INSERT INTO AQPA147
          (aqpa147cor,
           aqpa147fec,
           aqpa147hor,
           aqpa147med,
           aqpa147ori,
           aqpa147msg,
           aqpa147des,
           aqpa147cta,
           aqpa147pai,
           aqpa147tpo,
           aqpa147num,
           aqpa147mon,
           aqpa147top,
           aqpa147nop,
           aqpa147est,
           aqpa147suc,
           aqpa147mod,
           aqpa147tra,
           aqpa147rel,
           aqpa147fco)
        VALUES
          (SQ_AH_ID_PUSH.NEXTVAL,
           TRUNC(SYSDATE),
           :new.AQPC341HOT,
           'PUSH',
           'BANTOTAL',
           lv_mensaje,
           lv_fcm_token,
           lv_codigo,
           :new.AQPC341PAI,
           :new.AQPC341TDO,
           :new.AQPC341DOC,
           :new.AQPC341MOT,
           lv_operacion,
           NULL,
           'N',
           :new.AQPC341SUC,
           :new.AQPC341MOC,
           :new.AQPC341TNC,
           :new.AQPC341NRC,
           :new.AQPC341FET);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      IF lv_correo IS NOT NULL AND lc_mail = 'P' THEN
        lv_mensaje := '';
        -- registra notificaci�n
        DBMS_LOB.CREATETEMPORARY(ll_mensaje, TRUE);
        CASE
          WHEN lc_sex = 'M' THEN
            lv_aux1 := 'Estimado ' || lv_cliente;
          WHEN lc_sex = 'F' THEN
            lv_aux1 := 'Estimada ' || lv_cliente;
          ELSE
            lv_aux1 := 'Estimado '; -- rcuadros 22/09/2025
        END CASE;
        lv_mensaje := lv_aux1 ||
                      ' Caja Arequipa le informa sobre la operaci�n ' ||
                      lv_operacion || ' por ' || lv_moneda ||
                      TRIM(TO_CHAR(:new.AQPC341MOT, '9,999,999.90')) ||
                      lv_recipient || lv_fecha_hora || ' realizada en' || ': ' ||
                      lv_ubigueo;
      
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">' ||
                      lv_mensaje || '</p>';
        DBMS_LOB.WRITEAPPEND(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';
        DBMS_LOB.WRITEAPPEND(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>NOTA: NO RESPONDER A ESTE CORREO.</strong></p>';
        DBMS_LOB.WRITEAPPEND(ll_mensaje, length(lv_mensaje), lv_mensaje);
        BEGIN
          INSERT INTO AQPA147
            (aqpa147cor,
             aqpa147fec,
             aqpa147hor,
             aqpa147med,
             aqpa147ori,
             aqpa147msg,
             aqpa147des,
             aqpa147cta,
             aqpa147pai,
             aqpa147tpo,
             aqpa147num,
             aqpa147mon,
             aqpa147top,
             aqpa147nop,
             aqpa147est,
             aqpa147suc,
             aqpa147mod,
             aqpa147tra,
             aqpa147rel,
             aqpa147fco)
          VALUES
            (SQ_AH_ID_PUSH.NEXTVAL,
             TRUNC(SYSDATE),
             :new.AQPC341HOT,
             'CORREO',
             'BANTOTAL',
             ll_mensaje,
             lv_correo,
             lv_codigo,
             :new.AQPC341PAI,
             :new.AQPC341TDO,
             :new.AQPC341DOC,
             :new.AQPC341MOT,
             lv_operacion,
             NULL,
             'N',
             :new.AQPC341SUC,
             :new.AQPC341MOC,
             :new.AQPC341TNC,
             :new.AQPC341NRC,
             :new.AQPC341FET);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        dbms_lob.freetemporary(ll_mensaje);
      END IF;
    ELSE
      -- registra notificaci�n mail
      IF lv_correo IS NOT NULL AND lc_mail = 'P' THEN
        -- registra notificaci�n
        dbms_lob.createtemporary(ll_mensaje, TRUE);
        CASE
          WHEN lc_sex = 'M' THEN
            lv_aux1 := 'Estimado ' || lv_cliente;
          WHEN lc_sex = 'F' THEN
            lv_aux1 := 'Estimada ' || lv_cliente;
          ELSE
            lv_aux1 := 'Estimado '; -- rcuadros 22/09/2025
        END CASE;
        
        lv_mensaje := lv_aux1 ||
                      ' Caja Arequipa le informa sobre la operaci�n ' ||
                      lv_operacion || ' por ' || lv_MONEDA ||
                      TRIM(TO_CHAR(:new.AQPC341MOT, '9,999,999.90')) ||
                      lv_recipient || lv_fecha_hora || ' realizada en' || ': ' ||
                      lv_ubigueo;
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">' ||
                      lv_mensaje || '</p>';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>NOTA: NO RESPONDER A ESTE CORREO.</strong></p>';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
        BEGIN
          INSERT INTO AQPA147
            (aqpa147cor,
             aqpa147fec,
             aqpa147hor,
             aqpa147med,
             aqpa147ori,
             aqpa147msg,
             aqpa147des,
             aqpa147cta,
             aqpa147pai,
             aqpa147tpo,
             aqpa147num,
             aqpa147mon,
             aqpa147top,
             aqpa147nop,
             aqpa147est,
             aqpa147suc,
             aqpa147mod,
             aqpa147tra,
             aqpa147rel,
             aqpa147fco)
          VALUES
            (SQ_AH_ID_PUSH.NEXTVAL,
             TRUNC(SYSDATE),
             :new.AQPC341HOT,
             'CORREO',
             'BANTOTAL',
             ll_mensaje,
             lv_correo,
             lv_codigo,
             :new.AQPC341PAI,
             :new.AQPC341TDO,
             :new.AQPC341DOC,
             :new.AQPC341MOT,
             lv_operacion,
             NULL,
             'N',
             :new.AQPC341SUC,
             :new.AQPC341MOC,
             :new.AQPC341TNC,
             :new.AQPC341NRC,
             :new.AQPC341FET);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        DBMS_LOB.FREETEMPORARY(ll_mensaje);
      END IF;
    
      -- registra notificaci�n sms
      IF ln_celular IS NOT NULL AND lc_cel = 'P' THEN
        CASE
          WHEN lc_sex = 'M' THEN
            lv_aux1 := 'Estimado ' || lv_cliente;
          WHEN lc_sex = 'F' THEN
            lv_aux1 := 'Estimada ' || lv_cliente;
          ELSE
            lv_aux1 := 'Estimado '; -- rcuadros 22/09/2025
        END CASE;
      
        lv_mensaje := lv_aux1 ||
                      ' Caja Arequipa le informa sobre la operaci�n ' ||
                      lv_operacion || ' por ' || lv_MONEDA ||
                      TRIM(TO_CHAR(:new.AQPC341MOT, '9,999,999.90')) ||
                      lv_recipient || lv_fecha_hora || ' realizada en' || ': ' ||
                      lv_ubigueo;
        BEGIN
          INSERT INTO AQPA147
            (aqpa147cor,
             aqpa147fec,
             aqpa147hor,
             aqpa147med,
             aqpa147ori,
             aqpa147msg,
             aqpa147des,
             aqpa147cta,
             aqpa147pai,
             aqpa147tpo,
             aqpa147num,
             aqpa147mon,
             aqpa147top,
             aqpa147nop,
             aqpa147est,
             aqpa147suc,
             aqpa147mod,
             aqpa147tra,
             aqpa147rel,
             aqpa147fco)
          VALUES
            (SQ_AH_ID_PUSH.NEXTVAL,
             TRUNC(SYSDATE),
             :new.AQPC341HOT,
             'CELULAR',
             'BANTOTAL',
             lv_mensaje,
             ln_celular,
             lv_codigo,
             :new.AQPC341PAI,
             :new.AQPC341TDO,
             :new.AQPC341DOC,
             :new.AQPC341MOT,
             lv_operacion,
             NULL,
             'N',
             :new.AQPC341SUC,
             :new.AQPC341MOC,
             :new.AQPC341TNC,
             :new.AQPC341NRC,
             :new.AQPC341FET);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END TG_AQPC341_AI_01;
/
