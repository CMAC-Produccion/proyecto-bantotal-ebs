CREATE OR REPLACE TRIGGER TG_AQPB115_BI_01
   AFTER INSERT ON AQPB115
   FOR EACH ROW
DECLARE
   CODIGO_CANAL           NUMBER(2);
   CODIGO_ERROR_AQPB115   VARCHAR2(5);
   CODIGO_ANALISTA        VARCHAR2(30);
   TIPO_DOCUMENTO         NUMBER(2);
   NOMBRE_TIPO_DOCUMENTO  VARCHAR2(20);
   PAIS_DOCUMENTO         NUMBER(3);
   NRO_DOCUMENTO          VARCHAR2(12);
   MODULO_CREDITO         NUMBER(3);
   NOMBRE_MODULO          VARCHAR2(30);
   TIPO_OPERACION_CREDITO NUMBER(3);
   NOMBRE_TIPO_OPERACION  VARCHAR2(30);
   MONTO_CREDITO          VARCHAR2(40);
   MONEDA_CREDITO         NUMBER(4);
   SIGNO_MONEDA           VARCHAR2(4);
   FRECUENCIA             NUMBER(5);
   PLAZO_MESES            NUMBER(10);
   CELULAR_CLIENTE        VARCHAR2(40);
   CORREO_ANALISTA        VARCHAR2(40);
   IMAGEN_CLOB            CLOB;
   EMISOR                 VARCHAR2(40);
   ASUNTO                 VARCHAR2(100);
   CUERPO_MENSAJE         CLOB;
   CODIGO_ERROR_ENVIO     VARCHAR2(5);
   MENSAJE_ERROR_ENVIO    VARCHAR2(250);
   NOMBRE_ANALISTA        VARCHAR2(30);
   NOMBRE_CLIENTE         VARCHAR2(100);
   FECHA_CONSULTA         DATE;
   HORA_CONSULTA          VARCHAR2(8);
   lv_mensaje             VARCHAR2(32767);
BEGIN
   CODIGO_CANAL           := :NEW.AQPB115CANAL;
   CODIGO_ERROR_AQPB115   := TRIM(:NEW.AQPB115CODERR);
   CODIGO_ANALISTA        := TRIM(:NEW.AQPB115ANA);
   PAIS_DOCUMENTO         := :NEW.AQPB115PAI;
   TIPO_DOCUMENTO         := :NEW.AQPB115TIPDOC;
   NRO_DOCUMENTO          := :NEW.AQPB115NRODOC;
   MODULO_CREDITO         := :NEW.AQPB115MOD;
   TIPO_OPERACION_CREDITO := :NEW.AQPB115TIPOPE;
   MONTO_CREDITO          := TRIM(TO_CHAR(:NEW.AQPB115MTO, '99999999999G999G999D00', 'NLS_NUMERIC_CHARACTERS = ''.,'''));
   MONEDA_CREDITO         := :NEW.AQPB115MON;
   FRECUENCIA             := :NEW.AQPB115PZO;
   PLAZO_MESES            := :NEW.AQPB115CUO;
   CELULAR_CLIENTE        := :NEW.AQPB115CEL1;
   FECHA_CONSULTA         := :NEW.AQPB115FEC;
   HORA_CONSULTA          := :NEW.AQPB115HOR;

   IF CODIGO_ERROR_AQPB115 = '00000' AND CODIGO_CANAL = 11 THEN
      IF NOT REGEXP_LIKE(CELULAR_CLIENTE, '^[0-9]{9}$') THEN
         CELULAR_CLIENTE := NULL;
      END IF;

      NOMBRE_TIPO_DOCUMENTO := NULL;
      BEGIN
         SELECT CASE
                   WHEN TDOCUM = 9 THEN
                    'RUC'
                   WHEN TDOCUM = 21 THEN
                    'DNI'
                   ELSE
                    TRIM(TDNOM)
                END
           INTO NOMBRE_TIPO_DOCUMENTO
           FROM FST014
          WHERE TDOCUM = TIPO_DOCUMENTO;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;

      NOMBRE_CLIENTE := NULL;
      BEGIN
         SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' || TRIM(PFNOM1) || ' ' ||
                TRIM(PFNOM2)
           INTO NOMBRE_CLIENTE
           FROM FSD002
          WHERE PFPAIS = PAIS_DOCUMENTO
            AND PFTDOC = TIPO_DOCUMENTO
            AND PFNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT TRIM(PJRAZS)
                 INTO NOMBRE_CLIENTE
                 FROM FSD003
                WHERE PJPAIS = PAIS_DOCUMENTO
                  AND PJTDOC = TIPO_DOCUMENTO
                  AND PJNDOC = RPAD(NRO_DOCUMENTO, 12, ' ');
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN OTHERS THEN
            NULL;
      END;

      NOMBRE_MODULO := NULL;
      BEGIN
         SELECT TRIM(MDNOM)
           INTO NOMBRE_MODULO
           FROM FST003
          WHERE MODULO = MODULO_CREDITO;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;

      NOMBRE_TIPO_OPERACION := NULL;
      BEGIN
         SELECT TRIM(TONOM)
           INTO NOMBRE_TIPO_OPERACION
           FROM FST004
          WHERE MODULO = MODULO_CREDITO
            AND TOTOPE = TIPO_OPERACION_CREDITO;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;

      SIGNO_MONEDA := NULL;
      BEGIN
         SELECT TRIM(MOSIGN)
           INTO SIGNO_MONEDA
           FROM FST005
          WHERE MONEDA = MONEDA_CREDITO;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;

      CORREO_ANALISTA := NULL;
      NOMBRE_ANALISTA := NULL;
      BEGIN
         SELECT TRIM(WFUSREMAIL), TRIM(WFUSRNAME)
           INTO CORREO_ANALISTA, NOMBRE_ANALISTA
           FROM WFUSERS
          WHERE WFUSRCOD = RPAD(UPPER(CODIGO_ANALISTA), 30, ' ');
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;

      IMAGEN_CLOB := NULL;
      BEGIN
         SELECT AQPC757CLOB
           INTO IMAGEN_CLOB
           FROM AQPC757
          WHERE AQPC757GUIA  = 111154
            AND AQPC757CORR1 = 1
            AND AQPC757CORR2 = 1
            AND AQPC757CORR3 = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      IF CORREO_ANALISTA IS NOT NULL THEN
         ASUNTO         := 'Correo Simulacion Al Toke';
         EMISOR         := 'notificaciones@cajaarequipa.pe';
         dbms_lob.createtemporary(CUERPO_MENSAJE, TRUE);
         lv_mensaje := '<html>
                            <head><style type="text/css"></style></head>
                               <body>
                                  <p>Estimad@ ' || NOMBRE_ANALISTA || '</p>
                                  <p>Nos dirigimos a ti con el propósito de facilitarle la información correspondiente a la consulta realizada el día ' || FECHA_CONSULTA ||' a las '
                                  || HORA_CONSULTA|| ', con el objetivo de mantener un contacto eficiente con tu cliente.</p>
                                  <p>Detalles de la consulta:</p>
                                  <ul>
                                     <li>Tipo de Documento: ' || NOMBRE_TIPO_DOCUMENTO ||'</li>
                                     <li>Nro. de Documento: ' || NRO_DOCUMENTO ||'</li>
                                     <li>Cliente: ' || NOMBRE_CLIENTE ||'</li>
                                     <li>Módulo : ' || MODULO_CREDITO || ' - ' || NOMBRE_MODULO||'</li>
                                     <li>Tipo de Operación: ' || TIPO_OPERACION_CREDITO || ' - ' || NOMBRE_TIPO_OPERACION || '</li>
                                     <li>Monto : ' || MONTO_CREDITO || '</li>
                                     <li>Moneda : ' || SIGNO_MONEDA || '</li>
                                     <li>Frecuencia : ' || FRECUENCIA || '</li>
                                     <li>Plazo en Meses : ' || PLAZO_MESES || '</li>
                                     <li>Celular del Cliente: ' || CELULAR_CLIENTE || '</li>
                                  </ul>';
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
         dbms_lob.writeappend(CUERPO_MENSAJE, length(lv_mensaje), lv_mensaje);
         lv_mensaje := '          <footer>
                                     <p>Agradecemos tu atención y esperamos sigas haciendo uso del aplicativo.</p>
                                     <p>Cordialmente,</p>
                                     <p>Simulador Al Toke</p>
                                     <img src="data:image/png;base64,';
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
         dbms_lob.writeappend(CUERPO_MENSAJE, length(lv_mensaje), lv_mensaje);
         CUERPO_MENSAJE := CUERPO_MENSAJE || IMAGEN_CLOB;
         lv_mensaje := '"/>
                                  </footer>
                               </body>
                            </html>';
         dbms_lob.writeappend(CUERPO_MENSAJE, length(lv_mensaje), lv_mensaje);

         BEGIN
            PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => CORREO_ANALISTA,
                                             p_DestinatariosCC   => '',
                                             p_DestinatariosBcc  => '',
                                             p_Mensaje           => CUERPO_MENSAJE,
                                             p_Remitente         => EMISOR,
                                             p_Asunto            => ASUNTO,
                                             p_TipoMensaje       => 'HTML',
                                             p_Directorio        => '' ,
                                             p_ArchivosAdjuntos  => '',
                                             p_c_coderr          => CODIGO_ERROR_ENVIO,
                                             p_c_deserr          => MENSAJE_ERROR_ENVIO);
              dbms_output.put_line(EMISOR);
              dbms_output.put_line(MENSAJE_ERROR_ENVIO);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;

         IF CODIGO_ERROR_ENVIO <> '000' THEN
            BEGIN
               PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 2,
                                                         P_C_ASUNTO => ASUNTO,
                                                         P_C_DESPAR => CORREO_ANALISTA,
                                                         P_C_DESCOC => ' ',
                                                         P_C_DESCCO => ' ',
                                                         P_C_MENSAJ => CUERPO_MENSAJE,
                                                         P_C_REMITE => EMISOR,
                                                         P_C_DIRECT => ' ',
                                                         P_C_ADJUNT => ' ',
                                                         P_N_AUX001 => TO_NUMBER(TRIM(NRO_DOCUMENTO)),
                                                         P_N_AUX002 => 0,
                                                         P_N_AUX003 => 0,
                                                         P_N_AUX004 => 0,
                                                         P_D_AUX005 => NULL,
                                                         P_D_AUX006 => NULL,
                                                         P_C_AUX007 => 'CORREO SIMULACION AL TOKE',
                                                         P_C_AUX008 => 'TG_AQPB115_BI_01',
                                                         P_C_AUX009 => 'TRIGGER',
                                                         P_C_CODERR => CODIGO_ERROR_ENVIO,
                                                         P_C_MSGERR => MENSAJE_ERROR_ENVIO);
            EXCEPTION
               WHEN OTHERS THEN
                 NULL;
            END;
         END IF;
         dbms_lob.freetemporary(CUERPO_MENSAJE);
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END TG_AQPB115_BI_01;
/

