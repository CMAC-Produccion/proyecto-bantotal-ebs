create or replace package PQ_CR_ENVIOREPROG is
  -- *****************************************************************
  -- Nombre                     : PQ PARA ENVIO DE CORREOS PARA REPROGRAMACIONES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020.03.23
  -- Autor de Creación          : CMAC-GCARRANZAS
  -- Uso                        :
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :
  -- Autor de Modificación      :
  -- Descripción de Modificación:
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_ah_envio_constancia(P_V_ARC    VARCHAR2,
                                   P_V_MAIL   VARCHAR2,
                                   P_V_CAN    VARCHAR2,
                                   P_N_MDA    number,
                                   P_N_CTA    number,
                                   P_N_OPE    number,
                                   P_N_FEX    date,
                                   P_N_HOR    VARCHAR2,
                                   P_C_CODERR OUT VARCHAR2,
                                   p_c_DESERR OUT VARCHAR2);

  Procedure sp_cr_envio_reprogramacion(P_V_ARC    VARCHAR2,
                                       P_V_MAIL   VARCHAR2,
                                       P_V_CAN    VARCHAR2,
                                       P_N_MDA    number,
                                       P_N_CTA    number,
                                       P_N_OPE    number,
                                       P_N_FEX    date,
                                       P_N_HOR    VARCHAR2,
                                       P_C_CODERR OUT VARCHAR2,
                                       p_c_DESERR OUT VARCHAR2);

  Procedure sp_cr_envio_reprog_analistas(P_V_ARC    VARCHAR2,
                                         P_V_CAN    VARCHAR2,
                                         P_N_MDA    number,
                                         P_N_CTA    number,
                                         P_N_OPE    number,
                                         P_N_FEX    date,
                                         P_N_HOR    VARCHAR2,
                                         P_C_CODERR OUT VARCHAR2,
                                         p_c_DESERR OUT VARCHAR2);
/*
  procedure sp_maximo_cor(v_fecope in date,
                          v_Scmda  in number,
                          v_Sccta  in number,
                          v_Scoper in number,
                          v_cor    out number);
*/
  Procedure sp_cr_envio_reprog_analis_v2(P_V_ARC    VARCHAR2,
                                         P_V_CAN    VARCHAR2,
                                         P_N_CTA    number,
                                         P_C_CODERR OUT VARCHAR2,
                                         p_c_DESERR OUT VARCHAR2);                         

end PQ_CR_ENVIOREPROG;
/

create or replace package body PQ_CR_ENVIOREPROG is
  Procedure sp_ah_envio_constancia(P_V_ARC    VARCHAR2,
                                   P_V_MAIL   VARCHAR2,
                                   P_V_CAN    VARCHAR2,
                                   P_N_MDA    number,
                                   P_N_CTA    number,
                                   P_N_OPE    number,
                                   P_N_FEX    date,
                                   P_N_HOR    VARCHAR2,
                                   P_C_CODERR OUT VARCHAR2,
                                   p_c_DESERR OUT VARCHAR2) is
  
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    lv_remitente  VARCHAR2(30);
    lv_asunto     VARCHAR2(90);
    lv_directorio VARCHAR2(30);
    lv_contacto   VARCHAR2(110);
    lv_destinos   VARCHAR2(32767) := '';
  
    lc_usuarioAnalista  CHAR(10);
    lv_nombreAnalista   varchar2(150);
    lv_telefonoAnalista varchar2(150);
    lv_emailAnalista    varchar2(150);
  
    lv_pendoc varchar2(100);
    ln_petdoc number;
    ln_pepais number;
    --lv_moneda     VARCHAR2(10);
  
    --lc_fecope VARCHAR2(30);
    lv_numcre VARCHAR2(50);
    lv_auxili varchar2(10);
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
  
    --pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';   --validar correo
  
    lv_remitente := 'notificaciones@cajaarequipa.pe';
  
    --lc_fecope     := trim(to_char(P_N_FEX, 'DD/MM/YYYY')) || ' ' || trim(P_N_HOR);
    lv_asunto     := 'ENVIO AUTOMATICO -  CONFIRMACION ' ||
                     'REPROGRAMACIÓN DE CRÉDITO ';
    lv_directorio := 'DTPUMP_PR_EMAIL_DIG';
  
    BEGIN
      select petdoc, pendoc, pepais
        into ln_petdoc, lv_pendoc, ln_pepais
        from fsr008
       where ctnro = P_N_CTA
         and cttfir = 'T'
         and Ttcod = 1
         and pgcod = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lv_pendoc   := null;
        lv_contacto := '';
    END;
  
    if lv_pendoc is NULL then
      lv_contacto := '';
    else
      BEGIN
        SELECT PENOM
          INTO lv_contacto
          FROM FSD001
         where petdoc = ln_petdoc
           and pendoc = lv_pendoc
           and pepais = ln_pepais;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_contacto := '';
      END;
    end if;
  
    SELECT LPAD(TRIM(to_char(P_N_CTA)), 9, '0') ||
           LPAD(TRIM(to_char(P_N_MDA)), 3, '0') ||
           LPAD(TRIM(to_char(P_N_OPE)), 9, '0')
      into lv_numcre
      FROM DUAL;
  
    lc_usuarioAnalista := P_V_CAN;
    BEGIN
      select jaql708nom, jaql708tlf, jaql708mail
        into lv_nombreAnalista, lv_telefonoAnalista, lv_emailAnalista
        from Jaql708
       where jaql708usr = lc_usuarioAnalista
         and rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      
        select ubnom
          into lv_nombreAnalista
          from fst746
         where ubuser = lc_usuarioAnalista;
        lv_telefonoAnalista := '';
        lv_emailAnalista    := TRIM(P_V_CAN) || '@cajaarequipa.pe';
    END;
  
    --lv_destinos  := lv_emailAnalista || ';' || P_V_MAIL ;
    /*SELECT  CASE WHEN P_V_MAIL IS NULL OR P_V_MAIL = lv_auxili THEN lv_emailAnalista
            ELSE lv_emailAnalista || ';' || P_V_MAIL END into lv_destinos
    FROM DUAL;*/
    lv_destinos := lv_emailAnalista || ';' || P_V_MAIL;
    lv_auxili   := substr(lv_destinos, length(trim(lv_destinos)), 1);
    if lv_auxili = ';' then
      lv_destinos := replace(lv_destinos, ';', '');
    end if;
  
    dbms_lob.createtemporary(ll_mensaje, TRUE);
  
    /*lv_mensaje := '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>' ||
                  '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE REPROGRAMACIÓN ' ||
                  '</b>' || '<br>' || '<hr>' || '<table>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' ||
                  lv_contacto || '</td></tr>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Nro. crédito</td><td> </td><td>' ||
                  trim(lv_numcre) || '</td></tr> ' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Número de operación</td><td> </td><td>' ||
                  trim(P_N_OPE) || '</td></tr> ' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||
                  trim(lc_fecope) || '</td></tr>' ||                 
                  '</table>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
    lv_mensaje := '<hr><span style="font-family:Calibri; font-size:12px">El cronograma de pagos está adjunto.</span>' ||
                  '<hr>' || '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja.</span>' ||
                  '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje.</span>' ||
                  '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.</span>' ||
                  '<br>' || '<br>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);*/
  
    lv_mensaje := q'<<style> p.MsoNormal, li.MsoNormal, div.MsoNormal	{margin:0cm;	margin-bottom:.0001pt;	text-autospace:none;	font-size:11.0pt;} p.MsoBodyText, li.MsoBodyText, div.MsoBodyText     {margin:0cm;	margin-bottom:.0001pt;	text-autospace:none;	font-size:15.0pt;	font-weight:bold;}</style> 
    <div class=WordSection1 style='font-family:"Calibri","sans-serif";text-align:justify'>

<p align=center style="background-color:#002753" ><b ><span ><img width=178 height=77 id="Imagen 2" src="https://www.cajaarequipa.pe/wp-content/uploads/2020/03/logo-caja.png" ></span></b></p></br>

<p style='margin:0cm;margin-bottom:.0001pt;'><span style='font-size:16.0pt;'>Estimado: <b>>' ||
                  lv_contacto ||
                  ' </b></span></p></br>
<p class=MsoNormal >Hemos asumido un compromiso para apoyar la inclusión financiera y de servicio a nuestros clientes y ahora en las circunstancias que a todos nos toca vivir estamos #juntosContigo para poder superar esta emergencia nacional; es así que hemos desarrollado alternativas para que puedas superar estos momentos difíciles.</span>
</p></br>

<p class=MsoNormal >En atención a la solicitud recibida para reprogramar su crédito (s), le comunicamos que ha sido aprobada bajo las condiciones que podrá apreciar en el cronograma de pagos que adjuntamos y en base al plazo solicitado por usted, se ha mantenido en lo posible las fechas de pago de su actual crédito, manteniendo el valor de las cuotas en los meses restantes, con variación en la última cuota en función al plazo de gracia que usted ha solicitado y a la fecha ajustada de su próximo vencimiento de cuota, queremos recordarle que Caja Arequipa mantuvo inalterable la deuda sin incrementar intereses o costos adicionales durante el periodo de emergencia. Agradecemos pueda usted revisar dicho cronograma y la fecha del pago de su próxima cuota, y si tienes alguna duda o necesidad de aclaración, inmediatamente comunicarse con su Analista de Créditos.</span></p></br></br>

<pre><p class=MsoNormal >Nombre del Analista    : ' ||
                  lv_nombreAnalista ||
                  ' </span></p></pre>
<pre><p class=MsoNormal >Teléfono               : ' ||
                  lv_telefonoAnalista ||
                  ' </span></p></pre>
<pre><p class=MsoNormal >Email                  : ' ||
                  lv_emailAnalista || q'<</span></p></br></pre>

<p class=MsoNormal >Confiamos en que esta operación pueda dar tranquilidad a sus compromisos y juntos superar esta emergencia siempre con el respeto a las medidas decretadas por el gobierno, la prevención y la solidaridad.</span></p></br>

<p style='margin:0cm;margin-bottom:.0001pt'><span style='font-size:12.0pt;;color:#021B40'>Atentamente,</span></p></br>

<p class=MsoBodyText align=center style='margin-top:2.4pt;margin-right:0cm;
margin-bottom:0cm;margin-left:144.0pt;margin-bottom:.0001pt;text-align:center;
text-indent:36.0pt;line-height:103%'><span style='font-size:16.0pt;
line-height:103%;;color:#021B40'>Caja Arequipa</span></p></br>

<pre><p class=MsoNormal ><b><span style='font-size:14.0pt;;color:#0C6286'>#YoMeQuedoEnCasa         #PensamosEnTuBienestar</span></b></p></pre>

<pre><p class=MsoNormal ><b><span style='font-size:14.0pt;;color:#0C6286'>#CajaConSentido          #JuntosContigo</pre></span></b></p></pre>

</div>>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    begin
      -- Call the procedure
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => '',
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => P_V_ARC,
                                       p_c_coderr          => p_c_coderr,
                                       p_c_deserr          => p_c_deserr);
    exception
      when others then
        p_c_coderr := '00x';
        p_c_deserr := sqlerrm;
    end;
    dbms_lob.freetemporary(ll_mensaje);
  
  end sp_ah_envio_constancia;

  Procedure sp_cr_envio_reprogramacion(P_V_ARC    VARCHAR2,
                                       P_V_MAIL   VARCHAR2,
                                       P_V_CAN    VARCHAR2,
                                       P_N_MDA    number,
                                       P_N_CTA    number,
                                       P_N_OPE    number,
                                       P_N_FEX    date,
                                       P_N_HOR    VARCHAR2,
                                       P_C_CODERR OUT VARCHAR2,
                                       p_c_DESERR OUT VARCHAR2) is
  
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    lv_remitente  VARCHAR2(30);
    lv_asunto     VARCHAR2(90);
    lv_directorio VARCHAR2(30);
    lv_contacto   VARCHAR2(110);
    lv_destinos   VARCHAR2(32767) := '';
  
    lc_usuarioAnalista  CHAR(10);
    lv_nombreAnalista   varchar2(150);
    lv_telefonoAnalista varchar2(150);
    lv_emailAnalista    varchar2(150);
  
    lv_pendoc varchar2(100);
    ln_petdoc number;
    ln_pepais number;
    --lv_moneda     VARCHAR2(10);
  
    --lc_fecope VARCHAR2(30);
    lv_numcre VARCHAR2(50);
    lv_auxili varchar2(10);
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
  
    --pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';   --validar correo
  
    lv_remitente := 'notificaciones@cajaarequipa.pe';
  
    /*lc_fecope     := trim(to_char(P_N_FEX, 'DD/MM/YYYY')) || ' ' ||
    trim(P_N_HOR);*/
    lv_asunto     := 'ENVIO AUTOMATICO -  CONFIRMACION ' ||
                     'REPROGRAMACIÓN DE CRÉDITO ';
    lv_directorio := 'DTPUMP_PR_EMAIL_DIG';
  
    BEGIN
      select petdoc, pendoc, pepais
        into ln_petdoc, lv_pendoc, ln_pepais
        from fsr008
       where ctnro = P_N_CTA
         and cttfir = 'T'
         and Ttcod = 1
         and pgcod = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lv_pendoc   := null;
        lv_contacto := '';
    END;
  
    if lv_pendoc is NULL then
      lv_contacto := '';
    else
      BEGIN
        SELECT PENOM
          INTO lv_contacto
          FROM FSD001
         where petdoc = ln_petdoc
           and pendoc = lv_pendoc
           and pepais = ln_pepais;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_contacto := '';
      END;
    end if;
  
    SELECT LPAD(TRIM(to_char(P_N_CTA)), 9, '0') ||
           LPAD(TRIM(to_char(P_N_MDA)), 3, '0') ||
           LPAD(TRIM(to_char(P_N_OPE)), 9, '0')
      into lv_numcre
      FROM DUAL;
  
    lc_usuarioAnalista := P_V_CAN;
    BEGIN
      select jaql708nom, jaql708tlf, jaql708mail
        into lv_nombreAnalista, lv_telefonoAnalista, lv_emailAnalista
        from Jaql708
       where jaql708usr = lc_usuarioAnalista
         and rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      
        select ubnom
          into lv_nombreAnalista
          from fst746
         where ubuser = lc_usuarioAnalista;
        lv_telefonoAnalista := '';
        lv_emailAnalista    := TRIM(P_V_CAN) || '@cajaarequipa.pe';
    END;
  
    --lv_destinos  := lv_emailAnalista || ';' || P_V_MAIL ;
    /*SELECT  CASE WHEN P_V_MAIL IS NULL OR P_V_MAIL = lv_auxili THEN lv_emailAnalista
            ELSE lv_emailAnalista || ';' || P_V_MAIL END into lv_destinos
    FROM DUAL;*/
    lv_destinos := lv_emailAnalista || ';' || P_V_MAIL;
    lv_auxili   := substr(lv_destinos, length(trim(lv_destinos)), 1);
    if lv_auxili = ';' then
      lv_destinos := replace(lv_destinos, ';', '');
    end if;
  
    dbms_lob.createtemporary(ll_mensaje, TRUE);
  
    /*lv_mensaje := '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>' ||
                  '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE REPROGRAMACIÓN ' ||
                  '</b>' || '<br>' || '<hr>' || '<table>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' ||
                  lv_contacto || '</td></tr>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Nro. crédito</td><td> </td><td>' ||
                  trim(lv_numcre) || '</td></tr> ' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Número de operación</td><td> </td><td>' ||
                  trim(P_N_OPE) || '</td></tr> ' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||
                  trim(lc_fecope) || '</td></tr>' ||                 
                  '</table>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
    lv_mensaje := '<hr><span style="font-family:Calibri; font-size:12px">El cronograma de pagos está adjunto.</span>' ||
                  '<hr>' || '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja.</span>' ||
                  '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje.</span>' ||
                  '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.</span>' ||
                  '<br>' || '<br>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);*/
  
    lv_mensaje := q'<<style> p.MsoNormal, li.MsoNormal, div.MsoNormal	{margin:0cm;	margin-bottom:.0001pt;	text-autospace:none;	font-size:11.0pt;} p.MsoBodyText, li.MsoBodyText, div.MsoBodyText     {margin:0cm;	margin-bottom:.0001pt;	text-autospace:none;	font-size:15.0pt;	font-weight:bold;}</style> 
    <div class=WordSection1 style='font-family:"Calibri","sans-serif";text-align:justify'>

<p align=center style="background-color:#002753" ><b ><span ><img width=178 height=77 id="Imagen 2" src="https://www.cajaarequipa.pe/wp-content/uploads/2020/03/logo-caja.png" ></span></b></p></br>

<p style='margin:0cm;margin-bottom:.0001pt;'><span style='font-size:16.0pt;'>Estimado: <b>>' ||
                  lv_contacto ||
                  ' </b></span></p></br>
<p class=MsoNormal >Hemos asumido un compromiso para apoyar la inclusión financiera y de servicio a nuestros clientes y ahora en las circunstancias que a todos nos toca vivir estamos #juntosContigo para poder superar esta emergencia nacional; es así que hemos desarrollado alternativas para que puedas superar estos momentos difíciles.</span>
</p></br>

<p class=MsoNormal >En atención a la solicitud recibida para reprogramar su crédito (s), le comunicamos que ha sido aprobada bajo las condiciones que podrá apreciar en el cronograma de pagos que adjuntamos y en base al plazo solicitado por usted, se ha mantenido en lo posible las fechas de pago de su actual crédito, manteniendo el valor de las cuotas en los meses restantes, con variación en la última cuota en función al plazo de gracia que usted ha solicitado y a la fecha ajustada de su próximo vencimiento de cuota, queremos recordarle que Caja Arequipa mantuvo inalterable la deuda sin incrementar intereses o costos adicionales durante el periodo de emergencia. Agradecemos pueda usted revisar dicho cronograma y la fecha del pago de su próxima cuota, y si tienes alguna duda o necesidad de aclaración, inmediatamente comunicarse con su Analista de Créditos.</span></p></br></br>

<pre><p class=MsoNormal >Nombre del Analista    : ' ||
                  lv_nombreAnalista ||
                  ' </span></p></pre>
<pre><p class=MsoNormal >Teléfono               : ' ||
                  lv_telefonoAnalista ||
                  ' </span></p></pre>
<pre><p class=MsoNormal >Email                  : ' ||
                  lv_emailAnalista || q'<</span></p></br></pre>

<p class=MsoNormal >Confiamos en que esta operación pueda dar tranquilidad a sus compromisos y juntos superar esta emergencia siempre con el respeto a las medidas decretadas por el gobierno, la prevención y la solidaridad.</span></p></br>

<p style='margin:0cm;margin-bottom:.0001pt'><span style='font-size:12.0pt;;color:#021B40'>Atentamente,</span></p></br>

<p class=MsoBodyText align=center style='margin-top:2.4pt;margin-right:0cm;
margin-bottom:0cm;margin-left:144.0pt;margin-bottom:.0001pt;text-align:center;
text-indent:36.0pt;line-height:103%'><span style='font-size:16.0pt;
line-height:103%;;color:#021B40'>Caja Arequipa</span></p></br>

<pre><p class=MsoNormal ><b><span style='font-size:14.0pt;;color:#0C6286'>#YoMeQuedoEnCasa         #PensamosEnTuBienestar</span></b></p></pre>

<pre><p class=MsoNormal ><b><span style='font-size:14.0pt;;color:#0C6286'>#CajaConSentido          #JuntosContigo</pre></span></b></p></pre>

</div>>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    begin
      -- Call the procedure
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => '',
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => P_V_ARC,
                                       p_c_coderr          => p_c_coderr,
                                       p_c_deserr          => p_c_deserr);
    exception
      when others then
        p_c_coderr := '00x';
        p_c_deserr := sqlerrm;
    end;
    dbms_lob.freetemporary(ll_mensaje);
  
  end sp_cr_envio_reprogramacion;
  
  Procedure sp_cr_envio_reprog_analistas(P_V_ARC    VARCHAR2,
                                         P_V_CAN    VARCHAR2,
                                         P_N_MDA    number,
                                         P_N_CTA    number,
                                         P_N_OPE    number,
                                         P_N_FEX    date,
                                         P_N_HOR    VARCHAR2,
                                         P_C_CODERR OUT VARCHAR2,
                                         p_c_DESERR OUT VARCHAR2) is
  
    ll_mensaje      CLOB;
    lv_mensaje      VARCHAR2(32767);
    lv_remitente    VARCHAR2(30);
    lv_asunto       VARCHAR2(90);
    lv_directorio   VARCHAR2(30);
    lv_contacto     VARCHAR2(110);
    lv_cliente_telf varchar2(100);
    lv_destinos     VARCHAR2(32767) := '';
  
    lc_usuarioAnalista  CHAR(10);
    lv_nombreAnalista   varchar2(150);
    lv_telefonoAnalista varchar2(150);
    lv_emailAnalista    varchar2(150);
  
    lv_pendoc varchar2(100);
    ln_petdoc number;
    ln_pepais number;
    --lv_moneda     VARCHAR2(10);
  
    --lc_fecope VARCHAR2(30);
    --lv_numcre VARCHAR2(50);
    lv_auxili varchar2(10);
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
  
    --pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';   --validar correo
  
    lv_remitente := 'notificaciones@cajaarequipa.pe';
  
    /*lc_fecope     := trim(to_char(P_N_FEX, 'DD/MM/YYYY')) || ' ' ||
    trim(P_N_HOR);*/
    lv_asunto     := 'ENVIO AUTOMATICO -  CONFIRMACION ' ||
                     'REPROGRAMACIÓN DE CRÉDITO ';
    lv_directorio := 'DTPUMP_PR_EMAIL_DIG';
  
    -- Inicio -- Obtener datos del Cliente
    BEGIN
      select petdoc, pendoc, pepais
        into ln_petdoc, lv_pendoc, ln_pepais
        from fsr008
       where ctnro = P_N_CTA
         and cttfir = 'T'
         and Ttcod = 1
         and pgcod = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lv_pendoc   := null;
        lv_contacto := '';
    END;
  
    if lv_pendoc is NULL then
      lv_contacto     := '';
      lv_cliente_telf := '';
    else
      BEGIN
        SELECT PENOM
          INTO lv_contacto
          FROM FSD001
         where petdoc = ln_petdoc
           and pendoc = lv_pendoc
           and pepais = ln_pepais;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_contacto := '';
      END;
    
      BEGIN
        select f.dotelfp
          into lv_cliente_telf
          from fsr005 f
         where f.docod in (1, 2)
           and f.pendoc = lv_pendoc
           and f.petdoc = ln_petdoc
           and f.pepais = ln_pepais
           and rownum = 1
         order by f.docod asc;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_cliente_telf := '';
      END;
    end if;
    -- Fin -- Obtener datos del cliente
  
    /*    SELECT LPAD(TRIM(to_char(P_N_CTA)), 9, '0') ||
         LPAD(TRIM(to_char(P_N_MDA)), 3, '0') ||
         LPAD(TRIM(to_char(P_N_OPE)), 9, '0')
    into lv_numcre
    FROM DUAL;*/
  
    lc_usuarioAnalista := P_V_CAN;
    BEGIN
      select jaql708nom, jaql708tlf, jaql708mail
        into lv_nombreAnalista, lv_telefonoAnalista, lv_emailAnalista
        from Jaql708
       where jaql708usr = lc_usuarioAnalista
         and rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        select ubnom
          into lv_nombreAnalista
          from fst746
         where ubuser = lc_usuarioAnalista;
        --lv_telefonoAnalista := '';
        lv_emailAnalista := TRIM(P_V_CAN) || '@cajaarequipa.pe';
    END;
  
    --lv_destinos  := lv_emailAnalista || ';' || P_V_MAIL ;
    /*SELECT  CASE WHEN P_V_MAIL IS NULL OR P_V_MAIL = lv_auxili THEN lv_emailAnalista
            ELSE lv_emailAnalista || ';' || P_V_MAIL END into lv_destinos
    FROM DUAL;*/
    lv_destinos := lv_emailAnalista;
    lv_auxili   := substr(lv_destinos, length(trim(lv_destinos)), 1);
    if lv_auxili = ';' then
      lv_destinos := replace(lv_destinos, ';', '');
    end if;
  
    dbms_lob.createtemporary(ll_mensaje, TRUE);
  
    /*lv_mensaje := '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>' ||
                  '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE REPROGRAMACIÓN ' ||
                  '</b>' || '<br>' || '<hr>' || '<table>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' ||
                  lv_contacto || '</td></tr>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Nro. crédito</td><td> </td><td>' ||
                  trim(lv_numcre) || '</td></tr> ' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Número de operación</td><td> </td><td>' ||
                  trim(P_N_OPE) || '</td></tr> ' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||
                  trim(lc_fecope) || '</td></tr>' ||                 
                  '</table>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
    lv_mensaje := '<hr><span style="font-family:Calibri; font-size:12px">El cronograma de pagos está adjunto.</span>' ||
                  '<hr>' || '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja.</span>' ||
                  '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje.</span>' ||
                  '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px">Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.</span>' ||
                  '<br>' || '<br>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);*/
  
    lv_mensaje := q'<<style> p.MsoNormal, li.MsoNormal, div.MsoNormal	{margin:0cm;	margin-bottom:.0001pt;	text-autospace:none;	font-size:11.0pt;} p.MsoBodyText, li.MsoBodyText, div.MsoBodyText     {margin:0cm;	margin-bottom:.0001pt;	text-autospace:none;	font-size:15.0pt;	font-weight:bold;}</style> 
    <div class=WordSection1 style='font-family:"Calibri","sans-serif";text-align:justify'>

<p align=center style="background-color:#002753" ><b ><span ><img width=178 height=77 id="Imagen 2" src="https://www.cajaarequipa.pe/wp-content/uploads/2020/03/logo-caja.png" ></span></b></p></br>

<p style='margin:0cm;margin-bottom:.0001pt;'><span style='font-size:16.0pt;'>Estimado: <b>>' ||
                  lv_nombreAnalista ||
                  ' </b></span></p></br>
<p class=MsoNormal >Hemos enviado el Plan de reprogramación de crédito de tu cliente, es importante que tengas el conocimiento que se hizo llegar un SMS al cliente indicando:  En aplicación a las Resoluciones 11150 y 11170-2020 SBS  se alcanza su nuevo cronograma, si desea su reversión y mantener su cronograma original debe comunicar en los tres días siguientes a partir de hoy en una agencia o al correo reprogramacioncov19@cajaarequipa.pe para conocer su decisión.</span>
</p></br>

<pre><p class=MsoNormal >Nombre del Cliente    : ' ||
                  lv_contacto ||
                  ' </span></p></pre>
<pre><p class=MsoNormal >Teléfono               : ' ||
                  lv_cliente_telf || q'<</span></p></br></pre>

<p class=MsoNormal >Confiamos en que esta operación puedan dar tranquilidad a nuestros clientes y juntos superar esta emergencias siempre con el respeto a las medidas decretadas por el gobierno, la prevención y la solidaridad.</span></p></br>

<p style='margin:0cm;margin-bottom:.0001pt'><span style='font-size:12.0pt;;color:#021B40'>Atentamente,</span></p></br>

<p class=MsoBodyText align=center style='margin-top:2.4pt;margin-right:0cm;
margin-bottom:0cm;margin-left:144.0pt;margin-bottom:.0001pt;text-align:center;
text-indent:36.0pt;line-height:103%'><span style='font-size:16.0pt;
line-height:103%;;color:#021B40'>Caja Arequipa</span></p></br>

<pre><p class=MsoNormal ><b><span style='font-size:14.0pt;;color:#0C6286'>#YoMeQuedoEnCasa         #PensamosEnTuBienestar</span></b></p></pre>

<pre><p class=MsoNormal ><b><span style='font-size:14.0pt;;color:#0C6286'>#CajaConSentido          #JuntosContigo</pre></span></b></p></pre>

</div>>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    begin
      -- Call the procedure
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => '',
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => P_V_ARC,
                                       p_c_coderr          => p_c_coderr,
                                       p_c_deserr          => p_c_deserr);
    exception
      when others then
        p_c_coderr := '00x';
        p_c_deserr := sqlerrm;
    end;
    dbms_lob.freetemporary(ll_mensaje);
  
  end sp_cr_envio_reprog_analistas;
/*
  procedure sp_maximo_cor(v_fecope in date,
                          v_Scmda  in number,
                          v_Sccta  in number,
                          v_Scoper in number,
                          v_cor    out number) is
  
  begin
  
    begin
      select max(j.jaqz698cor)
        into v_cor
        from jaqz698 j
       where j.jaqz698fep = v_fecope
         and j.jaqz698mda = v_Scmda
         and j.jaqz698cta = v_Sccta
         and j.jaqz698ope = v_Scoper;
    exception
      when others then
        v_cor := 0;
    end;
  
  end sp_maximo_cor;*/
  
  Procedure sp_cr_envio_reprog_analis_v2(P_V_ARC    VARCHAR2,
                                         P_V_CAN    VARCHAR2,
                                         P_N_CTA    number,
                                         P_C_CODERR OUT VARCHAR2,
                                         p_c_DESERR OUT VARCHAR2) is
  
    ll_mensaje      CLOB;
    lv_mensaje      VARCHAR2(32767);
    lv_remitente    VARCHAR2(30);
    lv_asunto       VARCHAR2(90);
    lv_directorio   VARCHAR2(30);
    lv_contacto     VARCHAR2(110);
    lv_cliente_telf varchar2(100);
    lv_destinos     VARCHAR2(32767) := '';
  
    lc_usuarioAnalista  CHAR(10);
    lv_nombreAnalista   varchar2(150);
    lv_telefonoAnalista varchar2(150);
    lv_emailAnalista    varchar2(150);
  
    lv_pendoc varchar2(100);
    ln_petdoc number;
    ln_pepais number;
    --lv_moneda     VARCHAR2(10);
  
    --lc_fecope VARCHAR2(30);
    --lv_numcre VARCHAR2(50);
    lv_auxili varchar2(10);
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
  
    --pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';   --validar correo
  
    lv_remitente := 'notificaciones@cajaarequipa.pe';
 
    lv_asunto     := 'ENVIO AUTOMATICO -  CONFIRMACION ' ||
                     'REPROGRAMACIÓN DE CRÉDITO ';
    lv_directorio := 'DTPUMP_PR_EMAIL_DIG';
  
    -- Inicio -- Obtener datos del Cliente
    BEGIN
      select petdoc, pendoc, pepais
        into ln_petdoc, lv_pendoc, ln_pepais
        from fsr008
       where ctnro = P_N_CTA
         and cttfir = 'T'
         and Ttcod = 1
         and pgcod = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        lv_pendoc   := null;
        lv_contacto := '';
    END;
  
    if lv_pendoc is NULL then
      lv_contacto     := '';
      lv_cliente_telf := '';
    else
      BEGIN
        SELECT PENOM
          INTO lv_contacto
          FROM FSD001
         where petdoc = ln_petdoc
           and pendoc = lv_pendoc
           and pepais = ln_pepais;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_contacto := '';
      END;
    
      BEGIN
        select f.dotelfp
          into lv_cliente_telf
          from fsr005 f
         where f.docod in (1, 2)
           and f.pendoc = lv_pendoc
           and f.petdoc = ln_petdoc
           and f.pepais = ln_pepais
           and rownum = 1
         order by f.docod asc;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_cliente_telf := '';
      END;
    end if;
    -- Fin -- Obtener datos del cliente
  
    lc_usuarioAnalista := P_V_CAN;
    BEGIN
      select jaql708nom, jaql708tlf, jaql708mail
        into lv_nombreAnalista, lv_telefonoAnalista, lv_emailAnalista
        from Jaql708
       where jaql708usr = lc_usuarioAnalista
         and rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        select ubnom
          into lv_nombreAnalista
          from fst746
         where ubuser = lc_usuarioAnalista;
        --lv_telefonoAnalista := '';
        lv_emailAnalista := TRIM(P_V_CAN) || '@cajaarequipa.pe';
    END;
  
    --lv_destinos  := lv_emailAnalista || ';' || P_V_MAIL ;
    /*SELECT  CASE WHEN P_V_MAIL IS NULL OR P_V_MAIL = lv_auxili THEN lv_emailAnalista
            ELSE lv_emailAnalista || ';' || P_V_MAIL END into lv_destinos
    FROM DUAL;*/
    lv_destinos := lv_emailAnalista;
    lv_auxili   := substr(lv_destinos, length(trim(lv_destinos)), 1);
    if lv_auxili = ';' then
      lv_destinos := replace(lv_destinos, ';', '');
    end if;
  
    dbms_lob.createtemporary(ll_mensaje, TRUE);
       
    lv_mensaje := q'<<style> p.MsoNormal, li.MsoNormal, div.MsoNormal	{margin:0cm;	margin-bottom:.0001pt;	text-autospace:none;	font-size:11.0pt;} p.MsoBodyText, li.MsoBodyText, div.MsoBodyText     {margin:0cm;	margin-bottom:.0001pt;	text-autospace:none;	font-size:15.0pt;	font-weight:bold;}</style> 
    <div class=WordSection1 style='font-family:"Calibri","sans-serif";text-align:justify'>

<p align=center style="background-color:#002753" ><b ><span ><img width=178 height=77 id="Imagen 2" src="https://www.cajaarequipa.pe/wp-content/uploads/2020/03/logo-caja.png" ></span></b></p></br>

<p style='margin:0cm;margin-bottom:.0001pt;'><span style='font-size:16.0pt;'>Estimado: <b>>' ||
                  lv_nombreAnalista ||
                  ' </b></span></p></br>
<p class=MsoNormal >Hemos enviado el nuevo plan de pagos de crédito de tu cliente, es importante que tengas conocimiento que se hizo llegar un SMS para que pueda descargar su nuevo cronograma, así como tu numero para que pueda contactarse en caso necesite de tu apoyo en absolver dudas o acerca de la posible reversión del mismo, importante que señales la importancia de que la reversión podría llevar a una pérdida de su buena calificación de no regularizar su deuda, así como la importancia de cumplir con las fechas de su nuevo plan de pagos.</span>
</p></br>

<pre><p class=MsoNormal >Nombre del Cliente    : ' ||
                  lv_contacto ||
                  ' </span></p></pre>
<pre><p class=MsoNormal >Teléfono               : ' ||
                  lv_cliente_telf || q'<</span></p></br></pre>

<p class=MsoNormal >Confiamos en que esta operación puedan dar tranquilidad a nuestros clientes y juntos superar esta emergencias siempre con el respeto a las medidas decretadas por el gobierno, la prevención y la solidaridad.</span></p></br>

<p style='margin:0cm;margin-bottom:.0001pt'><span style='font-size:12.0pt;;color:#021B40'>Atentamente,</span></p></br>

<p class=MsoBodyText align=center style='margin-top:2.4pt;margin-right:0cm;
margin-bottom:0cm;margin-left:144.0pt;margin-bottom:.0001pt;text-align:center;
text-indent:36.0pt;line-height:103%'><span style='font-size:16.0pt;
line-height:103%;;color:#021B40'>Caja Arequipa</span></p></br>

<pre><p class=MsoNormal ><b><span style='font-size:14.0pt;;color:#0C6286'>#YoMeQuedoEnCasa         #PensamosEnTuBienestar</span></b></p></pre>

<pre><p class=MsoNormal ><b><span style='font-size:14.0pt;;color:#0C6286'>#CajaConSentido          #JuntosContigo</pre></span></b></p></pre>

</div>>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    begin
      -- Call the procedure
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => '',
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => P_V_ARC,
                                       p_c_coderr          => p_c_coderr,
                                       p_c_deserr          => p_c_deserr);
    exception
      when others then
        p_c_coderr := '00x';
        p_c_deserr := sqlerrm;
    end;
    dbms_lob.freetemporary(ll_mensaje);
  
  end sp_cr_envio_reprog_analis_v2;

end PQ_CR_ENVIOREPROG;
/

