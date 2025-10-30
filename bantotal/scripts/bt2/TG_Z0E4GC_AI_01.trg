CREATE OR REPLACE TRIGGER TG_Z0E4GC_AI_01
  AFTER INSERT ON z0e4gc
  FOR EACH ROW

  -- *****************************************************************
  -- Nombre                      : TG_Z0E4GC_AI_01
  -- Sistema                     : BANTOTAL
  -- Módulo                      : CANALES
  -- Versión                     : 1.0
  -- Fecha de Creación           : 2025.10.24
  -- Autor de Creación           : Renzo Cuadros Salazar
  -- Uso                         : Registro notificaciones push, correo y sms de operaciones offline
  -- Estado                      : Activo
  -- Acceso                      : Público
  -- Fecha de Modificación       :
  -- Autor de la Modificación    :
  -- Descripción la Modificación :
  -- *****************************************************************

DECLARE
  lv_cliente    VARCHAR2(25);
  lv_operacion  VARCHAR2(50);
  lv_moneda     VARCHAR2(5);
  ln_cuenta     NUMBER(9);
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
  ln_pepais     NUMBER(3);
  ln_petdoc     NUMBER(2);
  lc_pendoc     CHAR(12);
  lv_aux1       VARCHAR2(100);

  CURSOR c_notifica IS
    SELECT UPPER(x.operacion) operacion
    FROM (
      SELECT TP1DESC AS OPERACION, TP1NRO1, TP1NRO2
      FROM (
        SELECT TP1NRO1, TP1NRO2, TP1DESC, ROW_NUMBER() OVER (PARTITION BY TP1NRO1, TP1NRO2 ORDER BY TP1DESC DESC) orden
        FROM (
          SELECT TP1NRO1, TP1NRO2, TP1DESC
          FROM FST198 z
          WHERE z.TP1COD = 1
            AND z.TP1COD1 = 10864
            AND z.TP1CORR1 = 2
          UNION ALL
          SELECT TP1NRO1, TP1NRO2, TP1DESC
          FROM FST198 c
          WHERE c.TP1COD = 1
            AND c.TP1COD1 = 10825
            AND c.TP1CORR1 = 8
            AND c.TP1IMP3 = 1
        )
      )
      WHERE orden = 1
    ) x
    INNER JOIN Z0E470 d
      ON d.Z0E476COD = :new.Z0E4GCTOP
      AND d.Z0E470CMS = :new.Z0E4GCDPG
    INNER JOIN x9996c f
      ON f.X9996ACNCO = d.Z0E470CNP
      AND f.X9996BOPCO = d.Z0E470OPP
      AND f.X9996CVART = d.Z0E470VAP
    WHERE x.TP1NRO1 = f.X9996CTMOD
      AND x.TP1NRO2 = f.X9996CTTRN;

BEGIN
  FOR i IN c_notifica LOOP
    ln_cuenta := :new.Z0E4GCDCT;
    lv_codigo := LPAD(:new.Z0E4GCDCT, 9, '0') || LPAD(:new.Z0E4GCDMD, 3, '0') || LPAD(:new.Z0E4GCDMO, 3, '0') || LPAD(:new.Z0E4GCDSC, 2, '0') || LPAD(:new.Z0E4GCDTO, 3, '0');
    lv_operacion := TRIM(i.operacion);

    IF :new.Z0E4GCDMO = 0 THEN
      lv_moneda := 'S/.';
    ELSE
      lv_moneda := 'USD.';
    END IF;

    lv_ubigueo := SUBSTR(TRIM(:new.Z0E4GCTXT), INSTR(TRIM(:new.Z0E4GCTXT), '@', 1, 4) + 1);

    IF TRUNC(SYSDATE) = :new.Z0E4GCFEC THEN
      lv_fecha_hora := ' hoy a las ' || SUBSTR(:new.Z0E4GCHOR, 1, 5);
    ELSE
      lv_fecha_hora := ' el ' || TO_CHAR(:new.Z0E4GCFEC, 'dd/mm') || ' ' || SUBSTR(:new.Z0E4GCHOR, 1, 5);
    END IF;

    -- verificamos si esta afiliado
    BEGIN
      SELECT TRIM(x.MAIL_CLIENTE),
             TO_NUMBER('51' || TRIM(x.celular_cliente)),
             CASE WHEN x.ENVIAR_MAIL = 'S' THEN 'P' ELSE x.ENVIAR_MAIL END ENVIAR_MAIL,
             CASE WHEN x.ENVIAR_CELULAR = 'S' THEN 'P' ELSE x.ENVIAR_CELULAR END ENVIAR_CELULAR
        INTO lv_correo, ln_celular, lc_mail, lc_cel
        FROM ICHANNELALERT.CLIENTES_AFILIADOS x
       WHERE x.CODIGO_CLIENTE = lv_codigo
         AND (x.ENVIAR_MAIL IN ('P', 'S')
         OR x.ENVIAR_CELULAR IN ('P', 'S'));

    EXCEPTION
      WHEN OTHERS THEN
        lv_correo  := NULL;
        ln_celular := NULL;
    END;

    -- solo si esta afiliado hacemos algo si no salimos
    IF lv_correo IS NOT NULL OR ln_celular IS NOT NULL THEN
      -- obtenemos nombre del cliente
      BEGIN
        SELECT TRIM(UPPER(a.PFNOM1)), a.PFCANT, a.PFPAIS, a.PFTDOC, a.PFNDOC
          INTO lv_cliente, lc_sex, ln_pepais, ln_petdoc, lc_pendoc
          FROM FSD002 a
          INNER JOIN FSR008 b
          ON a.PFPAIS = b.PEPAIS
          AND a.PFTDOC = b.PETDOC
          AND a.PFNDOC = b.PENDOC
          WHERE b.CTNRO = ln_cuenta
          AND b.PGCOD = 1
          AND b.TTCOD = 1
          AND b.CTTFIR = 'T';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT TRIM(UPPER(SUBSTR(a.PENOM, 1, 25))), 'N', a.PEPAIS, a.PETDOC, a.PENDOC
              INTO lv_cliente, lc_sex, ln_pepais, ln_petdoc, lc_pendoc
              FROM FSD001 a
              INNER JOIN FSR008 b
              ON a.PEPAIS = b.PEPAIS
              AND a.PETDOC = b.PETDOC
              AND a.PENDOC = b.PENDOC
              WHERE b.CTNRO = ln_cuenta
              AND b.PGCOD = 1
              AND b.TTCOD = 1
              AND b.CTTFIR = 'T';
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
                                WHERE Z0E479SUC = :new.Z0E4GCDSU
                                  AND Z0E479CTA = :new.Z0E4GCDCT
                                  AND Z0E479SCT = :new.Z0E4GCDSC
                                  AND Z0E479MOD = :new.Z0E4GCDMD
                                  AND Z0E479MON = :new.Z0E4GCDMO
                                  AND Z0E479PAP = :new.Z0E4GCDPA
                                  AND Z0E479TOP = :new.Z0E4GCDTO
                                  AND Z0E479OPE = :new.Z0E4GCDOP
                                  AND Z0E479EST = 'AC'
                                  AND ROWNUM = 1
                              );
      EXCEPTION
        WHEN OTHERS THEN
          lv_fcm_token := NULL;
      END;

      -- si tiene fcm token
      IF TRIM(lv_fcm_token) IS NOT NULL THEN
        CASE
          WHEN lc_sex = 'M' THEN
            lv_aux1 := 'Estimado ' || lv_cliente;
          WHEN lc_sex = 'F' THEN
            lv_aux1 := 'Estimada ' || lv_cliente;
          ELSE
            lv_aux1 := 'Estimado ';
        END CASE;

        lv_mensaje := lv_aux1 ||
                      ' Caja Arequipa le informa sobre la operación ' ||
                      lv_operacion || ' por ' || lv_moneda ||
                      TRIM(TO_CHAR(:new.Z0E4GCIMD, '9,999,999.90')) ||
                      lv_fecha_hora || ' realizada en' || ': ' ||
                      lv_ubigueo;

        -- registra notificación
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
             :new.Z0E4GCHOR,
             'PUSH',
             'BANTOTAL',
             lv_mensaje,
             lv_fcm_token,
             lv_codigo,
             ln_pepais,
             ln_petdoc,
             lc_pendoc,
             :new.Z0E4GCIMD,
             lv_operacion,
             NULL,
             'N',
             NULL,
             NULL,
             NULL,
             NULL,
             NULL);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;

        IF lv_correo IS NOT NULL AND lc_mail = 'P' THEN
          lv_mensaje := '';
          -- registra notificación
          DBMS_LOB.CREATETEMPORARY(ll_mensaje, TRUE);
          CASE
            WHEN lc_sex = 'M' THEN
              lv_aux1 := 'Estimado ' || lv_cliente;
            WHEN lc_sex = 'F' THEN
              lv_aux1 := 'Estimada ' || lv_cliente;
            ELSE
              lv_aux1 := 'Estimado ';
          END CASE;

          lv_mensaje := lv_aux1 ||
                        ' Caja Arequipa le informa sobre la operación ' ||
                        lv_operacion || ' por ' || lv_moneda ||
                        TRIM(TO_CHAR(:new.Z0E4GCIMD, '9,999,999.90')) ||
                        lv_fecha_hora || ' realizada en' || ': ' ||
                        lv_ubigueo;

          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">' || lv_mensaje || '</p>';
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
               :new.Z0E4GCHOR,
               'CORREO',
               'BANTOTAL',
               ll_mensaje,
               lv_correo,
               lv_codigo,
               ln_pepais,
               ln_petdoc,
               lc_pendoc,
               :new.Z0E4GCIMD,
               lv_operacion,
               NULL,
               'N',
               NULL,
               NULL,
               NULL,
               NULL,
               NULL);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          dbms_lob.freetemporary(ll_mensaje);
        END IF;
      ELSE
        -- registra notificación mail
        IF lv_correo IS NOT NULL AND lc_mail = 'P' THEN
          -- registra notificación
          dbms_lob.createtemporary(ll_mensaje, TRUE);
          CASE
            WHEN lc_sex = 'M' THEN
              lv_aux1 := 'Estimado ' || lv_cliente;
            WHEN lc_sex = 'F' THEN
              lv_aux1 := 'Estimada ' || lv_cliente;
            ELSE
              lv_aux1 := 'Estimado ';
          END CASE;

          lv_mensaje := lv_aux1 ||
                        ' Caja Arequipa le informa sobre la operación ' ||
                        lv_operacion || ' por ' || lv_MONEDA ||
                        TRIM(TO_CHAR(:new.Z0E4GCIMD, '9,999,999.90')) ||
                        lv_fecha_hora || ' realizada en' || ': ' ||
                        lv_ubigueo;
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">' || lv_mensaje || '</p>';
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
               :new.Z0E4GCHOR,
               'CORREO',
               'BANTOTAL',
               ll_mensaje,
               lv_correo,
               lv_codigo,
               ln_pepais,
               ln_petdoc,
               lc_pendoc,
               :new.Z0E4GCIMD,
               lv_operacion,
               NULL,
               'N',
               NULL,
               NULL,
               NULL,
               NULL,
               NULL);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          DBMS_LOB.FREETEMPORARY(ll_mensaje);
        END IF;

        -- registra notificación sms
        IF ln_celular IS NOT NULL AND lc_cel = 'P' THEN
          CASE
            WHEN lc_sex = 'M' THEN
              lv_aux1 := 'Estimado ' || lv_cliente;
            WHEN lc_sex = 'F' THEN
              lv_aux1 := 'Estimada ' || lv_cliente;
            ELSE
              lv_aux1 := 'Estimado ';
          END CASE;

          lv_mensaje := lv_aux1 ||
                        ' Caja Arequipa le informa sobre la operación ' ||
                        lv_operacion || ' por ' || lv_MONEDA ||
                        TRIM(TO_CHAR(:new.Z0E4GCIMD, '9,999,999.90')) ||
                        lv_fecha_hora || ' realizada en' || ': ' ||
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
               :new.Z0E4GCHOR,
               'CELULAR',
               'BANTOTAL',
               lv_mensaje,
               ln_celular,
               lv_codigo,
               ln_pepais,
               ln_petdoc,
               lc_pendoc,
               :new.Z0E4GCIMD,
               lv_operacion,
               NULL,
               'N',
               NULL,
               NULL,
               NULL,
               NULL,
               NULL);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      END IF;
    END IF;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END TG_Z0E4GC_AI_01;
/
