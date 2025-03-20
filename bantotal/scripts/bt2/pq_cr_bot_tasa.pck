create or replace package PQ_CR_BOT_TASA is

  -- Author  : HSUAREZ
  -- Created : 13/02/2023 23:42:11
  -- Purpose : Proceso para eliminar la tasa

  procedure SP_ELIMINAR_TASA(VE_CORRELATIVO  IN NUMBER,
                             VE_CORR_INTERNO IN NUMBER);
  procedure SP_aprobacion_aqpc565(VE_CORRELATIVO  IN NUMBER,
                                  VE_CORR_INTERNO IN NUMBER,
                                  VE_ACCION       IN VARCHAR,
                                  VE_USER         IN VARCHAR,
                                  VE_ERROR        out number,
                                  ve_msj_error    out VARCHAR);
  FUNCTION FN_CR_CUERPO_HTML(ve_correlativo   in number,
                             ve_codigope      in number,
                             ve_codigopi      in number,
                             ve_usuario       in varchar,
                             ve_analista      in varchar,
                             ve_estado        in varchar)  RETURN CLOB ;
end PQ_CR_BOT_TASA;
/

create or replace package body PQ_CR_BOT_TASA is

  procedure SP_ELIMINAR_TASA(VE_CORRELATIVO  IN NUMBER,
                             VE_CORR_INTERNO IN NUMBER) IS
    vi_emp    aqpc565.AQPC565EMP%type;
    vi_suc    aqpc565.AQPC565SUC%type;
    vi_mod    aqpc565.AQPC565MOD%type;
    vi_mda    aqpc565.AQPC565MND%type;
    vi_pap    aqpc565.AQPC565PAP%type;
    vi_cta    aqpc565.AQPC565CTA%type;
    vi_ope    aqpc565.AQPC565OPE%type;
    vi_sbop   aqpc565.AQPC565SOPE%type;
    vi_top    aqpc565.AQPC565TOPE%type;
    vi_idcpi  aqpc565.aqpc565idcpi%type;
    VI_IDCPE  aqpc565.aqpc565idcpe%type;
    vi_cpara  varchar2(50);
    vi_cde    varchar2(50);
    
    ----
    VI_UDE    AQPC565.AQPC565DEU%type;
    VI_UPARA  AQPC565.AQPC565PARAU%type;
    ----
    vi_estado varchar(1);
    --HTML
    lv_body        varchar2(4000) := null;
    vi_msgbot      clob;
    vi_msghead     clob;
    ll_mensaje     clob;
    lv_mensaje      varchar2(32767);
    lv_asunto       varchar2(4000) := null;
    lv_remit       varchar2(200) := null;
    --- sql
    lc_coderr       varchar2(400) := null;
    lc_deserr       varchar2(400) := null;
    p_c_coderr      varchar2(400) := null;
    p_c_msgerr      varchar2(400) := null;
    --
    lv_bcc varchar(150);
  BEGIN
    --OBTENER LOS DATOS DEL CRÉDITO, E INFORMACION ADICIONAL PARA EL ENVIO DEL CORREO DE LA EJECUCIÓN.
    lv_remit  := 'notificacionesbantotal@cajaarequipa.pe'; --INICIALIZANDO EL REMITENTE.
    BEGIN
      SELECT A.AQPC565EMP,
             A.AQPC565SUC,
             A.AQPC565MOD,
             A.AQPC565MND,
             A.AQPC565PAP,
             A.AQPC565CTA,
             A.AQPC565OPE,
             A.AQPC565SOPE,
             A.AQPC565TOPE,
             A.AQPC565PARA,
             A.AQPC565DE,
             A.AQPC565PARAU,
             A.AQPC565DEU,
             A.AQPC565EST,
             A.AQPC565IDCPI,
             A.AQPC565IDCPE
             
        INTO VI_EMP,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             vi_sbop,
             vi_top,
             VI_CPARA,
             VI_CDE,
             VI_UPARA,
             VI_UDE,
             VI_ESTADO,
             vi_idcpi,
             VI_IDCPE
        FROM AQPC565 A
       WHERE AQPC565CORR = VE_CORRELATIVO
         --AND AQPC565CORR2 = VE_CORR_INTERNO
         AND AQPC565EST in ('A', 'R');
       exception
         when others then
           null;  
    END;
    --EJECUTAR EL PROCESO
    BEGIN
      IF (vi_estado = 'A') then
        UPDATE jaqa53
           set jaqa53est = 'S'
         WHERE jaqa53cod = VI_EMP
           AND jaqa53mod = VI_MOD
           AND jaqa53suc = VI_SUC
           AND jaqa53mda = VI_MDA
           AND jaqa53pap = VI_PAP
           AND jaqa53cta = VI_CTA
           AND jaqa53ope = VI_OPE
           AND jaqa53sbo = vi_sbop
           AND jaqa53top = vi_top
           AND jaqa53coe = vi_idcpi;
           commit;
      
        --ACTUALIZAR EL REGISTRO EN LA AQPC565.
       /* BEGIN
          UPDATE AQPC565
             SET AQPC565EST = 'A'
           WHERE AQPC565CORR = VE_CORRELATIVO;
        END;*/
      ELSE
        UPDATE jaqa53
           set jaqa53est = 'N'
         WHERE jaqa53cod = VI_EMP
           AND jaqa53mod = VI_MOD
           AND jaqa53suc = VI_SUC
           AND jaqa53mda = VI_MDA
           AND jaqa53pap = VI_PAP
           AND jaqa53cta = VI_CTA
           AND jaqa53ope = VI_OPE
           AND jaqa53sbo = vi_sbop
           AND jaqa53top = vi_top
           AND jaqa53coe = vi_idcpi;
           commit;
      
        --ACTUALIZAR EL REGISTRO EN LA AQPC565.
        /*BEGIN
          UPDATE AQPC565
             SET AQPC565EST = 'R'
           WHERE AQPC565CORR = VE_CORRELATIVO;
        END;*/
      END IF;
    END;
    --SI SE EJECUTO CORRECTAMENTE ENVIAR CORREO
    BEGIN
       --ARMANDO LA CABECERA DEL CORREO EN HTML.
       vi_msghead := PQ_CR_PROCESAR_BOT.FN_CR_HEAD_HTML(VI_IDCPE);
       ll_mensaje := ll_mensaje || vi_msghead;
       lv_mensaje := '<td align="center" style="padding:25px 0px"><img src="https://homebanking.cajaarequipa.pe:4443/assets/img/logos/logo.png"></td><hr>';
       dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
       --- FUNCION PARA OBTENER EL CUERPO
       ---
       lv_mensaje := PQ_CR_BOT_TASA.FN_CR_CUERPO_HTML(
                                                      ve_correlativo,
                                                      VI_IDCPE,
                                                      vi_idcpi,
                                                      VI_UDE,
                                                      VI_UDE,
                                                      vi_estado
       );
       ---
       -- ARMANDO EL ASUNTO DEL CORREO
       lv_asunto := '[C01] - ' || ve_correlativo ||' - Proceso de Eliminación de Tasa para la Cuenta: '||VI_CTA||' - Operacion: '||vi_ope;
       -- FIN ASUNTO
       --PROCESO PARA REEMPLAZAR LAS TILDES
       lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
       dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
       
       --
       --GUIA PARA ENVIAR CORREO CON COPIA 
        --
          BEGIN
               select trim(tp1desc)
               into lv_bcc
               from fst198
               where tp1cod1  = 11161
                 and tp1corr1 = 100
                 and tp1corr2 = 1
                 and tp1corr3 = 1;
          EXCEPTION
            WHEN OTHERS THEN
              lv_bcc :='';       
          END;
        --
       --
       --FIN PROCESO. 
       -- Call the procedure
       pq_ah_planillas.p_sendmailattach(p_destinatariospara =>VI_CDE,
                                       p_destinatarioscc   => VI_CPARA,
                                       p_destinatariosbcc  => lv_bcc,--'eninah@cajaarequipa.pe;hsuarez@cajaarequipa.pe;doris.choque@sesitdigital.com',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remit,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => '',
                                       p_archivosadjuntos  => '',
                                       p_c_coderr          => lc_coderr,
                                       p_c_deserr          => lc_deserr);
    EXCEPTION
      WHEN OTHERS THEN
        p_c_coderr := lc_coderr;
        if p_c_coderr = '000' then
          p_c_msgerr := 'Envío Satisfactorio, revise su bandeja de correo electrónico.';
        Else
          p_c_msgerr := lc_deserr;
        End if;
    END;
    p_c_coderr := lc_coderr;
    if p_c_coderr = '000' then
      p_c_msgerr := 'Envío Satisfactorio, revise su bandeja de correo electrónico.';
    Else
      p_c_msgerr := lc_deserr;
    End if;
  END;
  -------------------------------------------------------------------
  procedure SP_aprobacion_aqpc565(VE_CORRELATIVO  IN NUMBER,
                                  VE_CORR_INTERNO IN NUMBER,
                                  VE_ACCION       IN VARCHAR,
                                  VE_USER         IN VARCHAR,
                                  VE_ERROR        out number,
                                  ve_msj_error    out VARCHAR) IS
    vi_isupd number;
  BEGIN
    vi_isupd := 0;
    --VERIFICAR SI  REGISTRO PUEDE SER APROBADO O RECHAZADO
    BEGIN
      SELECT count(*)
        into vi_isupd
        FROM AQPC565 A
       WHERE AQPC565CORR = VE_CORRELATIVO
         AND AQPC565CORR2 = VE_CORR_INTERNO
         AND AQPC565EST <> 'A'
         AND AQPC565EST <> 'R';
    exception
      when others then
        vi_isupd := 0;
    END;
    if vi_isupd > 0 then
      begin
        update aqpc565
           set aqpc565est = VE_ACCION, aqpc565up_u = VE_USER
         WHERE AQPC565CORR = VE_CORRELATIVO
           AND AQPC565CORR2 = VE_CORR_INTERNO;
         commit;
        ve_error := 0;
        if VE_ACCION = 'A' then
          ve_msj_error := 'Se aprobó solicitud.';
        else
          ve_msj_error := 'Se rechazó solicitud.';
        end if;
      exception
        when others then
          ve_error := 1;
          if VE_ACCION = 'A' then
            ve_msj_error := 'No se puede aprobar solicitud.';
          else
            ve_msj_error := 'No se puede rechazar solicitud.';
          end if;
      end;
    else
      ve_error     := 1;
      ve_msj_error := 'No se puede aprobar o rechazar. Solicitud ya fue aprobada o rechazada';
    end if;
    if ve_error = 0 then
      BEGIN
        pq_cr_bot_tasa.SP_ELIMINAR_TASA(VE_CORRELATIVO, VE_CORR_INTERNO);
      exception
        when others then
          null;
      END;
    end if;
  
  END SP_aprobacion_aqpc565;
  -------------------------------------------------------------------
  FUNCTION FN_CR_CUERPO_HTML(ve_correlativo   in number,
                               ve_codigope      in number,
                               ve_codigopi      in number,
                               ve_usuario       in varchar,
                               ve_analista      in varchar,
                               ve_estado        in varchar) RETURN CLOB IS
    lv_body    varchar2(4000) := null;
    lv_body21  varchar2(4000) := null;
    lv_body22  varchar2(4000) := null;
    lv_body3   varchar2(4000) := null;
    lv_body4   varchar2(4000) := null;
    lv_bodya   varchar2(4000) := null;
    lv_bodyr   varchar2(4000) := null;
    lv_asuntoa varchar2(4000) := null;
    lv_asuntor varchar2(4000) := null;
    ll_mensaje      clob;
    lv_mensaje varchar2(32700) := null;
    ve_msg_bot clob;
    ve_body    clob;
    vi_cuenta    aqpc565.aqpc565cta%type;
    vi_operacion aqpc565.AQPC565OPE%type;
    vi_usuariod  aqpc565.aqpc565deu%type;
    vi_nombreusu varchar2(200);
  BEGIN
  
    BEGIN
       select AQPC565CTA,AQPC565OPE,AQPC565DEU
       into vi_cuenta,vi_operacion,vi_usuariod
       from AQPC565
       WHERE AQPC565CORR  = ve_correlativo
         AND AQPC565IDCPE = ve_codigope
         AND AQPC565IDCPI = ve_codigopi;
    END;
    BEGIN
      select f.ubnom into vi_nombreusu from fst746 f
      where f.ubuser = vi_usuariod;
    END;
  
    lv_body21 := '<br/><br/><h2>[C01] - ' || ve_correlativo ||'</h2><br/>Estimado <strong>' ||vi_nombreusu|| '</strong><br/> '||
                  '- Se Autorizó la Solicitud de Excepción de Eliminación de Tasa con Cuenta:  <strong>'||vi_cuenta||'</strong> y Operacion: <strong>'||vi_operacion||'</strong>';
    --lv_body21 := replace(lv_asuntoa, ' ', '%20');
    lv_body22 := '<br/><br/><h2>[C01] - ' || ve_correlativo ||'</h2><br/>Estimado <strong>' ||vi_nombreusu|| '</strong><br/> '||
                  '- Se Rechazo la Solicitud de Excepción de Eliminación de Tasa con Cuenta: <strong>'||vi_cuenta||'</strong> y Operacion: <strong>'||vi_operacion||'</strong>';
    --lv_body22 := replace(lv_asuntor, ' ', '%20');
    lv_body21 := pq_ah_email_trx.fn_ah_replace_tildes(lv_body21);
    lv_body22 := pq_ah_email_trx.fn_ah_replace_tildes(lv_body22);  
    lv_body := ve_body || lv_body;
  
    --REEMPLAZAR LAS " POR %22
    --lv_body   := replace(trim(lv_body), '"', '%22');
    --lv_body21 := replace(trim(lv_body21), '"', '%22');
   -- lv_body22 := replace(trim(lv_body22), '"', '%22');
  
    --lv_bodya := replace(trim(lv_body), ' ', '%20') /*||replace(trim(lc_Comentario),' ','%20')*/
    --            || '%0D%0A%0D%0A' || lv_body21 || '%0D%0A%0D%0A' ||
    --            lv_body3;
    --lv_bodyr := replace(trim(lv_body), ' ', '%20') /*||replace(trim(lc_Comentario),' ','%20')*/
    --            || '%0D%0A%0D%0A' || lv_body22 || '%0D%0A%0D%0A' ||
    --            lv_body4;
    lv_bodya := pq_ah_email_trx.fn_ah_replace_tildes(lv_body21);
    lv_bodyr := pq_ah_email_trx.fn_ah_replace_tildes(lv_body22);
    if ve_estado = 'A' then
       lv_mensaje := lv_bodya;
    ELSE
       lv_mensaje := lv_bodyr;
    END IF;
    dbms_lob.createtemporary(ll_mensaje, TRUE);
       dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
       lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';
       dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
       ---
       lv_mensaje := '<hr>
       <div class="footer">
          <font face="Verdana" color="Navy" size="1"><br>
          Aviso Legal. La información contenida en este correo electrónico, así como en cualquiera de sus archivos adjuntos, es confidencial y está dirigida exclusivamente a él o los destinatarios indicados.<br>
          Si Usted ha recibido este mail por error, por favor comuníquenoslo inmediatamente vía e-mail y tenga la amabilidad de eliminarlo de su sistema. Cualquier uso, reproducción, divulgación o distribución por otras personas distintas de él o los destinatarios está
           estrictamente prohibida.<br>
          Por favor, tenga en cuenta que cualquier opinión emitida en este correo electrónico es propia del autor o remitente y no representa necesariamente la opinión de la Caja Arequipa.<br>
          Finalmente, a pesar de sus esfuerzos razonables en el control de virus y programas maliciosos, la Caja Arequipa no puede asegurar que estos no se encuentren en este correo electrónico por causas ajenas a su control, por lo que usted debe analizar este correo
           electrónico y sus archivos adjuntos antes de abrirlos.<br>
          Caja Arequipa. <a href="http://www.cajaarequipa.pe" target="_blank" rel="noreferrer">www.cajaarequipa.pe</a><br>
          </font></div>';
       dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
       /*Footer*/
       ---    
       lv_mensaje := '</body>';
       dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
    return ll_mensaje;
  END;
  -------------------------------------------------------------------
end PQ_CR_BOT_TASA;
/

