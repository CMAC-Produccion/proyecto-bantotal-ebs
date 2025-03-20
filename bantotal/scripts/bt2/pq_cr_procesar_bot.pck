create or replace package PQ_CR_PROCESAR_BOT is

  -- Author  : HSUAREZ
  -- Created : 30/09/2022 10:45:26
  -- Purpose : Paquete que sirve de intermedio que el bot llamara para procesar lo solicitado
  PROCEDURE SP_ENVIAR_MAIL_BOT(VI_IDCORRELATIVO NUMBER, --CORRELATIVO GENERAL
                               VI_GESTION       NUMBER, -- SI REQUIERE GESTION DE USUARIO
                               VI_IDCODIGOPE    NUMBER, --PROCESO A EJECUTAR
                               VI_ID_CODIGOPI   NUMBER, --PROCESO DE CODIGO INTERNO
                               VI_INSTANCIA     NUMBER, --INSTANCIA
                               VI_AUXILIAR1     NUMBER, --CAMPO AXULIAR
                               VI_AUXILIAR2     VARCHAR, --CAMPO AXULIAR2
                               VI_CODERROR      OUT NUMBER, --CODIGO DE ERROR
                               VI_MSGERROR      OUT VARCHAR --MENSAJE DE ERROR
                               );
  FUNCTION FN_CR_READ_HTML(VE_CODIGO_PROCESO NUMBER) RETURN CLOB;
  FUNCTION FN_CR_HEAD_HTML(VE_CODIGO_PROCESO NUMBER) RETURN CLOB;
  FUNCTION BOTONES_ACCION_HTML(ve_correlativo   in number,
                               ve_codigope      in number,
                               ve_codigopi      in number,
                               ve_mailbot       in varchar,
                               ve_usuario       in varchar,
                               ve_analista      in varchar,
                               ve_AQPC565DE     in varchar2,
                               ve_AQPC565ASBOT  in varchar2,
                               ve_AQPC565CPBOTA in varchar2,
                               ve_AQPC565CPBOTR in varchar2) RETURN CLOB;
  PROCEDURE SP_CR_EXECUTE_SPBOT(VE_IDCODIGO      IN NUMBER,
                                VE_IDCODPRO      IN NUMBER,
                                VE_IDCODPROC_INT IN NUMBER,
                                VE_AUTORIZADOR   IN VARCHAR,
                                VE_CORREO_AUTO   IN VARCHAR,
                                VE_SOLICITANTE   IN VARCHAR,
                                VE_COMENTARIO    IN VARCHAR,
                                VE_ESTADO        IN VARCHAR,
                                VO_COD_ERROR     OUT VARCHAR,
                                VO_MSG_ERROR     OUT VARCHAR);
  PROCEDURE SP_SR_GENERAR_ARRAY_VARCHAR(VE_PROCESO     in number,
                                        VE_CORRELATIVO IN NUMBER,
                                        VE_ORDEN       in number,
                                        VE_CADENA      in varchar,
                                        vo_cantidad    out number);

  PROCEDURE SP_CR_ARMAR_CONSULTA(VE_CORRELATIVO in number,
                                 VE_PROCESO     IN NUMBER,
                                 VE_PROCESO_INT IN NUMBER,
                                 VE_CANT_VAR    IN NUMBER,
                                 VE_PQT         IN VARCHAR,
                                 VE_PCDM        IN VARCHAR,
                                 VO_CONSULTA    OUT VARCHAR);
  PROCEDURE SP_CR_EJECUTAR_PROCESO_MANUAL(VE_PROCESO     in number,
                                          VE_CORRELATIVO IN NUMBER);
end PQ_CR_PROCESAR_BOT;
/

create or replace package body PQ_CR_PROCESAR_BOT is

  PROCEDURE SP_ENVIAR_MAIL_BOT(VI_IDCORRELATIVO NUMBER, --CORRELATIVO GENERAL
                               VI_GESTION       NUMBER, -- SI REQUIERE GESTION DE USUARIO
                               VI_IDCODIGOPE    NUMBER, --PROCESO A EJECUTAR
                               VI_ID_CODIGOPI   NUMBER, --PROCESO DE CODIGO INTERNO
                               VI_INSTANCIA     NUMBER, --INSTANCIA
                               VI_AUXILIAR1     NUMBER, --CAMPO AXULIAR
                               VI_AUXILIAR2     VARCHAR, --CAMPO AXULIAR2
                               VI_CODERROR      OUT NUMBER, --CODIGO DE ERROR
                               VI_MSGERROR      OUT VARCHAR --MENSAJE DE ERROR
                               ) IS
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_mail_auto
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.2
    -- Fecha de Creación          : 19/12/2022
    -- Autor de Creación          : HENRY SUAREZ
    -- Uso                        : ENVIO DE CORREO
    -- Estado                     : ACTIVO
    -- Acceso                     : PUBLICO
    -- Parámetros de Entrada      : P_N_CODEXC
    -- Retorno                    : p_c_coderr, p_c_msgerr
    -- *****************************************************************
  
    /*
    cursor c_archivos(lv_codblq in varchar2) is     
      Select dbms_lob.getlength(a.aqpc204arc) len,
             a.aqpc204arc,
             trim(a.aqpc204nom) aqpc204nom
        from AQPC204 a
       where a.aqpc204co1 = P_N_CODEXC
         and a.aqpc204vre = lv_codblq;
    */
    vblob           BLOB;
    vstart          NUMBER := 1;
    bytelen         NUMBER := 32000;
    len             NUMBER;
    my_vr           RAW(32000);
    x               NUMBER;
    GUIA            VARCHAR2(1);
    lv_nomrep       varchar2(30) := null;
    l_output        utl_file.file_type;
    lv_nomarc       varchar2(250) := null;
    lv_aqpc203vre   aqpc203.aqpc203vre%type;
    lc_Usuario      varchar2(10) := null;
    lc_Analista     varchar2(10) := null;
    ld_usuario      varchar2(50) := null;
    ld_Analista     varchar2(50) := null;
    lc_Cliente      varchar2(250) := null;
    ln_Cuenta       number(9) := 0;
    ln_Operacion    number(9) := 0;
    lc_Producto     varchar2(30) := null;
    ln_SaldoCapital number(17, 2) := 0;
    lc_sucursal     char(30) := null;
    lc_Bloqueante   varchar2(250) := null;
    lc_Comentario   varchar2(250) := null;
    lv_archxblq     varchar2(4000) := null;
    lv_archivos     varchar2(4000) := null;
    ll_mensaje      clob;
    ll_mensaje1     clob;
    lv_mensaje      varchar2(32767);
    p_c_coderr      varchar2(400) := null;
    lc_coderr       varchar2(400) := null;
    lc_deserr       varchar2(400) := null;
    p_c_msgerr      varchar2(400) := null;
    lv_mailbot      varchar2(50) := null;
    lv_asunto       varchar2(4000) := null;
  
    lv_body        varchar2(4000) := null;
    vi_msgbot      clob;
    vi_msghead     clob;
    lv_bloqueantes varchar2(4000) := null;
    lv_parar       varchar2(200) := null;
    lv_paraa       varchar2(200) := null;
    lv_paracc      varchar2(200) := null;
    lv_remit       varchar2(200) := null;
    lv_body2       varchar2(4000) := null;
    --PARA LA PLANTILLA HTML
    lv_head_html clob;
  
    --08.05.2022 variable
    vi_cargo        number(3);
    vi_suc_crd      number(3);
    vi_rcod_crd     number(3);
    vi_autorizador  varchar(10);
    vi_sautorizador varchar(10);
    lv_bcc varchar(100);
    --
    VI_AQPC565PARA  aqpc565.aqpc565para%type;
    VI_AQPC565DE    aqpc565.aqpc565de%type;
    VI_AQPC565CC    aqpc565.aqpc565cc%type;
    VI_AQPC565ASNT  aqpc565.aqpc565asnt%type;
    VI_AQPC565CRPO  aqpc565.aqpc565crpo%type;
    VI_AQPC565DIREC aqpc565.aqpc565direc%type;
    VI_AQPC565ARCH  aqpc565.aqpc565arch%type;
    VI_AQPC565ASBOT aqpc565.aqpc565asbot%type;
    VI_AQPC565CBOT1 aqpc565.aqpc565cbot1%type;
    VI_AQPC565CBOT2 aqpc565.aqpc565cbot2%type;
    VI_AQPC565GSTN  aqpc565.aqpc565gstn%type;
    --
  begin
    BEGIN
      SELECT AQPC565PARA,
             AQPC565DE,
             AQPC565CC,
             AQPC565ASNT,
             AQPC565CRPO,
             AQPC565DIREC,
             AQPC565ARCH,
             AQPC565ASBOT,
             AQPC565CBOT1,
             AQPC565CBOT2,
             AQPC565GSTN
        into VI_AQPC565PARA,
             VI_AQPC565DE,
             VI_AQPC565CC,
             VI_AQPC565ASNT,
             VI_AQPC565CRPO,
             VI_AQPC565DIREC,
             VI_AQPC565ARCH,
             VI_AQPC565ASBOT,
             VI_AQPC565CBOT1,
             VI_AQPC565CBOT2,
             VI_AQPC565GSTN
        FROM AQPC565 A
       WHERE A.AQPC565CORR = VI_IDCORRELATIVO
         AND A.AQPC565IDCPE = VI_IDCODIGOPE;
    exception
      when others then
        p_c_coderr := '005';
        p_c_msgerr := 'No se encontro el registro a procesar.';
    END;
    --VI_AQPC565CC := 'hsuarez@cajaarequipa.pe'; --borrar
    --VI_AQPC565DE := 'hsuarez@cajaarequipa.pe'; --borrar
    lv_mailbot   := 'autorizacionesbt';
    lv_paracc    := VI_AQPC565CC;
    lv_parar     := VI_AQPC565PARA;--'rmontesr@cajaarequipa.pe';
    lv_paraa     := lv_paracc;--'eninah@cajaarequipa.pe;apachecoh@cajaarequipa.pe;doris.choque@sesitdigital.com'; --||';'||lv_paracc;
  
    lv_remit  := 'notificacionesbantotal@cajaarequipa.pe';
    lv_asunto := VI_AQPC565ASNT;
  
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    dbms_lob.createtemporary(ll_mensaje1, TRUE);
    --
    vi_msghead := PQ_CR_PROCESAR_BOT.FN_CR_HEAD_HTML(VI_IDCODIGOPE);
    ll_mensaje := ll_mensaje || vi_msghead;
    lv_mensaje := '<td align="center" style="padding:25px 0px"><img src="https://homebanking.cajaarequipa.pe:4443/assets/img/logos/logo.png"></td><hr>';
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    ---
    lv_mensaje := VI_AQPC565CRPO;
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje);
  
    lv_nomrep := 'DTPUMP_PR_EMAIL';
    vstart    := 1;
    bytelen   := 32000;
    --armamos el detalle de los bloqueantes
    --Limpiams variable 08.05.2022
  
    lv_bloqueantes := '';
    lv_archivos    := '';
    lv_archxblq    := '';
    --
    -- ARMAMOS CUERPO Y ASUNTO DE MAIL DE APROBACION O RECHAZO
    --
    -- 06.05.2022 - SE REALIZO EL CAMBIO DONDE DICE AUTORIZACION/RECHAZO POR ALGO MAS DINAMICO.
  
    --FIN ARMADO
    --06.05.2022 - SE CAMBIO EL CC POR QUE SE ESTA ENVIADO AL MISMO AUTORIZADOR, DEBIENDO SER ANALISTA O ASESOR.  
    vi_msgbot := empty_clob();
    vi_msgbot := PQ_CR_PROCESAR_BOT.BOTONES_ACCION_HTML(VI_IDCORRELATIVO,
                                                        VI_IDCODIGOPE,
                                                        VI_ID_CODIGOPI,
                                                        lv_mailbot,
                                                        VI_AQPC565PARA,
                                                        vi_AQPC565DE,
                                                        VI_AQPC565DE,
                                                        VI_AQPC565ASBOT,
                                                        VI_AQPC565CBOT1,
                                                        VI_AQPC565CBOT2);
  
    ll_mensaje := ll_mensaje || vi_msgbot;
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
    --envio correo usuario aprobador            
    begin
      -- Call the procedure
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_parar,
                                       p_destinatarioscc   => lv_paraa,
                                       p_destinatariosbcc  => lv_bcc,
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remit,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_nomrep,
                                       p_archivosadjuntos  => lv_archivos,
                                       p_c_coderr          => lc_coderr,
                                       p_c_deserr          => lc_deserr);
    end;
  
    dbms_lob.freetemporary(ll_mensaje);
    dbms_lob.freetemporary(ll_mensaje1);
  
    p_c_coderr := lc_coderr;
    if p_c_coderr = '000' then
      p_c_msgerr := 'Envío Satisfactorio, revise su bandeja de correo electrónico.';
    Else
      p_c_msgerr := lc_deserr;
    End if;
  
    --actualizamos la tabla
    begin
      update AQPC565 a
         set --a.AQPC565C_ERR = decode(p_c_coderr, '000', 'S', 'N'),
             A.AQPC565MSJERR = substr(p_c_msgerr, 1, 100)
       where a.aqpc565CORR = VI_IDCORRELATIVO
         AND a.AQPC565IDCPE = VI_IDCODIGOPE;
      if sql%notfound then
        p_c_coderr := '004';
        p_c_msgerr := 'Ocurrio un error al procesar la información, vuelva a intentar.';
        return;
      Else
        commit;
      End If;
    End;
    VI_MSGERROR := p_c_msgerr;
  Exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
    
      VI_MSGERROR := p_c_msgerr;
  end;
  -----------------------------------------------------------
  FUNCTION FN_CR_READ_HTML(VE_CODIGO_PROCESO NUMBER) RETURN CLOB is
    CADENA      CLOB;
    vi_etiqueta varchar2(32767);
    vi_head     clob;
    vi_style    clob;
    vi_script   clob;
    vi_body     clob;
    data        number(17);
  BEGIN
    CADENA := EMPTY_CLOB();
    dbms_lob.createtemporary(CADENA, TRUE);
    vi_etiqueta := '<!DOCTYPE html><html lang="en" xmlns="https://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office">';
    dbms_lob.writeappend(CADENA, length(vi_etiqueta), vi_etiqueta);
    vi_etiqueta := vi_etiqueta || '<head>';
    dbms_lob.writeappend(CADENA, length(vi_etiqueta), vi_etiqueta);
    --HTML HEAD,CSS,SCRIPT,BODY
    BEGIN
      SELECT A.AQPC578HEAD, A.AQPC578CSS, A.AQPC578JS, A.AQPC578BODY
        INTO vi_head, vi_style, vi_script, vi_body
        FROM AQPC578 A
       WHERE A.AQPC578COD = VE_CODIGO_PROCESO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    CADENA := CADENA || vi_head;
    CADENA := CADENA || vi_style;
    CADENA := CADENA || vi_script;
    --dbms_lob.append(CADENA,vi_head);
    --dbms_lob.append(CADENA,vi_style);
    --dbms_lob.append(CADENA,vi_script);
    vi_etiqueta := '</head>';
    --dbms_lob.append(v_lob_bis,v_lob);
    dbms_lob.writeappend(CADENA, length(vi_etiqueta), vi_etiqueta);
    dbms_lob.writeappend(CADENA, length(vi_body), vi_body);
    vi_etiqueta := '</html>';
    dbms_lob.writeappend(CADENA, length(vi_etiqueta), vi_etiqueta);
    RETURN CADENA;
  END;
  -------------------------------------------------------------------
  FUNCTION FN_CR_HEAD_HTML(VE_CODIGO_PROCESO NUMBER) RETURN CLOB is
    CADENA      CLOB;
    vi_etiqueta varchar2(32767);
    vi_head     clob;
    vi_style    clob;
    vi_script   clob;
    vi_body     clob;
    data        number(17);
  BEGIN
    CADENA := EMPTY_CLOB();
    dbms_lob.createtemporary(CADENA, TRUE);
    vi_etiqueta := '<html>';
    --dbms_lob.writeappend(CADENA, length(vi_etiqueta), vi_etiqueta);
    vi_etiqueta := vi_etiqueta || '<head>';
    dbms_lob.writeappend(CADENA, length(vi_etiqueta), vi_etiqueta);
    --HTML HEAD,CSS,SCRIPT,BODY
    BEGIN
      SELECT A.AQPC578HEAD, A.AQPC578CSS, A.AQPC578JS, A.AQPC578BODY
        INTO vi_head, vi_style, vi_script, vi_body
        FROM AQPC578 A
       WHERE A.AQPC578COD = VE_CODIGO_PROCESO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    CADENA      := CADENA || vi_head;
    CADENA      := CADENA || vi_style;
    CADENA      := CADENA || vi_script;
    vi_etiqueta := '</head>';
  
    RETURN CADENA;
  END;
  ---------------------------------------------------------------------
  FUNCTION BOTONES_ACCION_HTML(ve_correlativo   in number,
                               ve_codigope      in number,
                               ve_codigopi      in number,
                               ve_mailbot       in varchar,
                               ve_usuario       in varchar,
                               ve_analista      in varchar,
                               ve_AQPC565DE     in varchar2,
                               ve_AQPC565ASBOT  in varchar2,
                               ve_AQPC565CPBOTA in varchar2,
                               ve_AQPC565CPBOTR in varchar2) RETURN CLOB IS
    lv_body    varchar2(4000) := null;
    lv_body21  varchar2(4000) := null;
    lv_body22  varchar2(4000) := null;
    lv_body3   varchar2(4000) := null;
    lv_body4   varchar2(4000) := null;
    lv_bodya   varchar2(4000) := null;
    lv_bodyr   varchar2(4000) := null;
    lv_asuntoa varchar2(4000) := null;
    lv_asuntor varchar2(4000) := null;
    lv_mensaje varchar2(32700) := null;
    ve_msg_bot clob;
    ve_body    clob;
  BEGIN
  
    lv_body21 := 'Se realizó la autorización de las bloqueantes solicitadas que corresponden a ' ||
                 ve_AQPC565CPBOTA;
    lv_body21 := replace(lv_body21, ' ', '%20');
    lv_body22 := 'Se realizó el rechazo de las bloqueantes solicitadas que corresponden a ' ||
                 ve_AQPC565CPBOTR;
    lv_body22 := replace(lv_body22, ' ', '%20');
  
    lv_body3 := '- IDCODIGO: ' || ve_correlativo || '%0D%0A' ||
                '- IDCODPROCESO: ' || ve_codigope || '%0D%0A' ||
                '- IDCODPROCESO_INTERNO: ' || ve_codigopi || '%0D%0A' ||
                '- AUTORIZADOR: ' || ve_usuario || '%0D%0A' ||
                '- SOLICITANTE: ' || ve_analista || '%0D%0A' ||
                '- ESTADO: Autorizado';
    lv_body4 := lv_body3;
    lv_body3 := replace(lv_body3, ' ', '%20');
    lv_body4 := '- IDCODIGO: ' || ve_correlativo || '%0D%0A' ||
                '- IDCODPROCESO: ' || ve_codigope || '%0D%0A' ||
                '- IDCODPROCESO_INTERNO: ' || ve_codigopi || '%0D%0A' ||
                '- AUTORIZADOR: ' || ve_usuario || '%0D%0A' ||
                '- SOLICITANTE: ' || ve_analista || '%0D%0A' ||
                '- ESTADO: Rechazado';
    lv_body4 := lv_body4;
    lv_body4 := replace(lv_body4, ' ', '%20');
  
    lv_asuntoa := '[C01] - ' || ve_correlativo ||
                  '- Se Autoriza la Solicitud de Excepción de Eliminación de Tasa ';
    lv_asuntoa := replace(lv_asuntoa, ' ', '%20') || Ve_AQPC565ASBOT;
    lv_asuntor := '[C01] - ' || ve_correlativo ||
                  '- Se Rechaza la Solicitud de Excepción de Eliinación de Tasa ';
    lv_asuntor := replace(lv_asuntor, ' ', '%20') || Ve_AQPC565ASBOT;
    lv_asuntoa := pq_ah_email_trx.fn_ah_replace_tildes(lv_asuntoa);
    lv_asuntor := pq_ah_email_trx.fn_ah_replace_tildes(lv_asuntor);
  
    lv_body := 'Comentarios del Autorizador: ';
    --ve_body  := PQ_CR_PROCESAR_BOT.FN_CR_HEAD_HTML(3);
    lv_body := ve_body || lv_body;
  
    --REEMPLAZAR LAS " POR %22
    lv_body   := replace(trim(lv_body), '"', '%22');
    lv_body21 := replace(trim(lv_body21), '"', '%22');
    lv_body22 := replace(trim(lv_body22), '"', '%22');
  
    lv_bodya := replace(trim(lv_body), ' ', '%20') /*||replace(trim(lc_Comentario),' ','%20')*/
                || '%0D%0A%0D%0A' || lv_body21 || '%0D%0A%0D%0A' ||
                lv_body3;
    lv_bodyr := replace(trim(lv_body), ' ', '%20') /*||replace(trim(lc_Comentario),' ','%20')*/
                || '%0D%0A%0D%0A' || lv_body22 || '%0D%0A%0D%0A' ||
                lv_body4;
    lv_bodya := pq_ah_email_trx.fn_ah_replace_tildes(lv_bodya);
    lv_bodyr := pq_ah_email_trx.fn_ah_replace_tildes(lv_bodyr);
  
    lv_mensaje := '<table class="tabla_botones"><tr>' || ' 
                               <td width="300">
                                   <b><a class="btn-primary" href="mailto:' ||
                  ve_mailbot || '@cajaarequipa.pe?cc=' ||
                  lower(ve_AQPC565DE) || '&Subject=' || lv_asuntoa ||
                  '&body=' || lv_bodya || '">AUTORIZAR</a></b></td>' ||
                  '<td width="300"><b><a class="btn-primary" href="mailto:' ||
                  ve_mailbot || '@cajaarequipa.pe?cc=' ||
                  lower(ve_AQPC565DE) || '&Subject=' || lv_asuntor ||
                  '&body=' || lv_bodyr || '">RECHAZAR</a></b></td>' ||
                  '  </tr></table>';
    --lv_mensaje := replace(trim(lv_mensaje), '"', '%22');
    ve_msg_bot := lv_mensaje;
    return ve_msg_bot;
  END;

  ---------------------------------------------------------------------
  PROCEDURE SP_CR_EXECUTE_SPBOT(VE_IDCODIGO      IN NUMBER,
                                VE_IDCODPRO      IN NUMBER,
                                VE_IDCODPROC_INT IN NUMBER,
                                VE_AUTORIZADOR   IN VARCHAR,
                                VE_CORREO_AUTO   IN VARCHAR,
                                VE_SOLICITANTE   IN VARCHAR,
                                VE_COMENTARIO    IN VARCHAR,
                                VE_ESTADO        IN VARCHAR,
                                VO_COD_ERROR     OUT VARCHAR,
                                VO_MSG_ERROR     OUT VARCHAR) IS
    vi_variables      varchar(3000);
    vi_instancia      xwf700.xwfprcins%type;
    vi_aqpc565usue    aqpc565.AQPC565U_ENV%type;
    vi_aqpc565est     aqpc565.AQPC565EST%type;
    vi_emp            aqpc565.AQPC565EMP%type;
    vi_suc            aqpc565.AQPC565SUC%type;
    vi_mod            aqpc565.AQPC565MOD%type;
    vi_mda            aqpc565.AQPC565MND%type;
    vi_pap            aqpc565.AQPC565PAP%type;
    vi_cta            aqpc565.AQPC565CTA%type;
    vi_ope            aqpc565.AQPC565OPE%type;
    vi_sbop           aqpc565.AQPC565SOPE%type;
    vi_top            aqpc565.AQPC565TOPE%type;
    vi_cant_variables number(9);
    --vi_array_variables  dbms_utility.lname_array;
    -----
    VI_PI_PQT  aqpc566.aqpc566pqt%type;
    VI_PI_PCDM aqpc566.aqpc566pcdm%type;
    VI_PI_PROG aqpc566.aqpc566prog%type;
    -----
    vi_consulta_execute varchar2(500);
    VS_CONSULTA         VARCHAR(500);
    -----
    y number(9);
    -----
    --Cursor para separar variables.
    cursor lista_variables(c_variables in varchar) is
      select regexp_substr(c_variables, '[^;]+', 1, level) as cadena,
             level nivel
        from dual
      connect by regexp_substr(c_variables, '[^;]+', 1, level) is not null;
  
  BEGIN
    --BUSCAR SI EL REGISTRO EXISTE EN LA TABLA AQPBC565
    VO_COD_ERROR := '0000'; --SE REALIZO CAMBIO PARA INICIALIZAR EL VALOR DE RESPUESTA EN CASO NO HAYA ERRORES EL CODIGO DE ERROR SERA 0000
    --VALIDAR SI LOS DATOS SON CORRECTOS.
    BEGIN
      select aqpc565var,
             aqpc565inst,
             aqpc565u_env,
             aqpc565est,
             aqpc565emp,
             aqpc565suc,
             aqpc565mod,
             aqpc565mnd,
             aqpc565pap,
             aqpc565cta,
             aqpc565ope,
             aqpc565sope,
             aqpc565tope
        INTO vi_variables,
             vi_instancia,
             vi_aqpc565usue,
             vi_aqpc565est,
             vi_emp,
             vi_suc,
             vi_mod,
             vi_mda,
             vi_pap,
             vi_cta,
             vi_ope,
             vi_sbop,
             vi_top
        from aqpc565
       WHERE AQPC565CORR = VE_IDCODIGO
         AND AQPC565IDCPE = VE_IDCODPRO;
      --AND AQPC565IDCPI  = VE_IDCODPROC_INT comentado solo para pruebas del Bot, para no validar el usuario.
      --AND AQPC565PARA   = VE_AUTORIZADOR; comentado solo para pruebas del Bot, para no validar el usuario.
    exception
      when others then
        --DBMS_OUTPUT.PUT_LINE(SQLERRM);
        --DBMS_OUTPUT.PUT_LINE(SQLCODE);
        VO_COD_ERROR := '0008';
        vo_MSG_ERROR := 'No se encuentra la solicitud para Autorizar/Rechazar, validar si ya lo Autorizo/Rechazo';
    END;
  
    IF upper(substr(vi_aqpc565est, 1, 1)) = 'A' THEN
      VO_COD_ERROR := '0001';
      vo_MSG_ERROR := 'La solicitud ya fue autorizada es un correo anterior';
    
    end if;
  
    IF upper(substr(vi_aqpc565est, 1, 1)) = 'R' THEN
      VO_COD_ERROR := '0002';
      vo_MSG_ERROR := 'La solicitud ya fue rechazada es un correo anterior';
    
    end if;
    --DESCOMPONER LAS VARIABLES A EJECUTAR E INCLUIR EN EL PROCESO CAMPO aqpc565var
    IF vi_variables IS NOT NULL THEN
      --PRIMERO OBTENER DESCOMPOSICION POR ; PARA OBTENER CANTIDAD DE VARIABLES
      y := 0;
      FOR X IN lista_variables(vi_variables) LOOP
        --DESCOMPONER LAS VARIABLES POR VARIABLE,TIPO DATO Y VALOR.                 
        y := y + 1;
        PQ_CR_PROCESAR_BOT.SP_SR_GENERAR_ARRAY_VARCHAR(VE_IDCODPRO,
                                                       VE_IDCODIGO,
                                                       y,
                                                       x.cadena,
                                                       vi_cant_variables);
      END LOOP;
    
    END IF;
    --VALIDAR CUAL ES EL PROCESO A EJECUTAR.
    --EL VE_IDCODPRO indica que codigo de proceso es el que define cual es que se debe eliminar.
    BEGIN
      SELECT AQPC566PQT, AQPC566PCDM, AQPC566PROG
        INTO VI_PI_PQT, VI_PI_PCDM, VI_PI_PROG
        FROM AQPC566 A
       WHERE A.AQPC566COD = VE_IDCODPRO;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0003';
        VO_MSG_ERROR := 'No se encontro el proceso a ejecutar para el proceso seleccionado: ' ||
                        VE_IDCODPRO;
    END;
  
    -- ARMAR EL PROCESO A EJECUTAR.
    BEGIN
      if nvl(VI_PI_PROG, '') IS NULL then
        PQ_CR_PROCESAR_BOT.SP_CR_ARMAR_CONSULTA(VE_IDCODIGO,
                                                VE_IDCODPRO,
                                                VE_IDCODPROC_INT,
                                                Y,
                                                VI_PI_PQT,
                                                VI_PI_PCDM,
                                                VS_CONSULTA);
      else
        NULL; --todavia no definido para el caso de que sea programa, no seria desde paquete.
      end if;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0005';
        VO_MSG_ERROR := 'Ocurrio un problema al trata de armar la consulta del correlativo: ' ||
                        VE_IDCODIGO;
    END;
    --PROCESO PARA ACTUALIZAR LOS DATOS DE LA TABLA PARA INDICAR SI SE EHJECUTO EL PROCESO O SI NO SE PUDO EJECUTAR.
    BEGIN
     update aqpc565 A5
           set A5.AQPC565MSJERR = VO_MSG_ERROR,
               A5.AQPC565C_ERR  = TO_NUMBER(VO_COD_ERROR),
               A5.AQPC565EST    = upper(substr(VE_ESTADO, 1, 1)) --PARA INDICAR QUE ES ERROR
         WHERE AQPC565CORR = VE_IDCODIGO
           AND AQPC565IDCPE = VE_IDCODPRO;
        COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
           VO_COD_ERROR := '0007';
           VO_MSG_ERROR := 'Ocurrio un problema al Actualizar los registros, registro no encontrado ' ||
                        VE_IDCODIGO;
           VO_MSG_ERROR := 'Ocurrio un problema al Ejecutar el proceso de Eliminacion de Tasa'; --Borrar 
    END;    
    BEGIN
      VS_CONSULTA := 'BEGIN ' || VS_CONSULTA || ' END';
      --EXECUTE IMMEDIATE VS_CONSULTA; regresar a cmo estaba antes HSUAREZ
      execute immediate 'DECLARE BEGIN PQ_CR_BOT_TASA.SP_ELIMINAR_TASA(' ||
                        VE_IDCODIGO || ',1); END;';
      --dbms_output.put_line('DECLARE BEGIN PQ_CR_BOT_TASA.SP_ELIMINAR_TASA(' ||
      --                     VE_IDCODIGO || ',1) END');
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0006';
        VO_MSG_ERROR := 'Ocurrio un problema al trata de ejecutar la consulta : ' ||
                        VS_CONSULTA;
        VO_MSG_ERROR := 'Ocurrio un problema al Ejecutar el proceso de Eliminacion de Tasa'; --Borrar         
    END;
    BEGIN
      IF LENGTH(VO_MSG_ERROR) > 0 THEN
        update aqpc565 A5
           set A5.AQPC565MSJERR = VO_MSG_ERROR,
               A5.AQPC565C_ERR  = TO_NUMBER(VO_COD_ERROR),
               A5.AQPC565EST    = 'E' --PARA INDICAR QUE ES ERRRO 
         WHERE AQPC565CORR = VE_IDCODIGO
           AND AQPC565IDCPE = VE_IDCODPRO;
        --AND AQPC565IDCPI  = VE_IDCODPROC_INT 27.02.2023 - descomentar, solo comentado para pruebas Bot.
        --AND AQPC565PARA   = VE_AUTORIZADOR;
        COMMIT;
      ELSE
        update aqpc565 A5
           set A5.AQPC565MSJERR = VO_MSG_ERROR,
               A5.AQPC565C_ERR  = TO_NUMBER(VO_COD_ERROR),
               A5.AQPC565EST    = upper(substr(VE_ESTADO, 1, 1)) --PARA INDICAR QUE ES ERROR
         WHERE AQPC565CORR = VE_IDCODIGO
           AND AQPC565IDCPE = VE_IDCODPRO;
        --AND AQPC565IDCPI  = VE_IDCODPROC_INT 27.02.2023 - descomentar, solo comentado para pruebas Bot.
        --AND AQPC565PARA   = VE_AUTORIZADOR; - descomentar, solo comentado para pruebas Bot.
        COMMIT;
      END IF;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0007';
        VO_MSG_ERROR := 'Ocurrio un problema al Actualizar los registros, registro no encontrado ' ||
                        VE_IDCODIGO;
        VO_MSG_ERROR := 'Ocurrio un problema al Ejecutar el proceso de Eliminacion de Tasa'; --Borrar
    END;
    /*
    insert into prueba_log
      (pgcod, msg, fecha)
    values
      (100, 'BOT-' || VE_IDCODIGO || '-' || VO_COD_ERROR, sysdate);
    commit;
    */
  EXCEPTION
    WHEN OTHERS THEN
      VO_COD_ERROR := '0010';
      VO_MSG_ERROR := 'Ocurrio un problema al trata de ejecutar el proceso con correlativo: ' ||
                      VE_IDCODIGO;
      VO_MSG_ERROR := 'Ocurrio un problema al Ejecutar el proceso de Eliminacion de Tasa'; --Borrar
      /*
      insert into prueba_log
        (pgcod, msg, fecha)
      values
        (100, 'BOT-' || VE_IDCODIGO || '-' || VO_COD_ERROR, sysdate);
      commit;
      */
  END;
  ---------------------------------------------------------------------
  PROCEDURE SP_SR_GENERAR_ARRAY_VARCHAR(VE_PROCESO     in number,
                                        VE_CORRELATIVO IN NUMBER,
                                        VE_ORDEN       in number,
                                        VE_CADENA      in varchar,
                                        vo_cantidad    out number) IS
    l_input varchar2(4000) := VE_CADENA;
    l_count binary_integer;
    l_array dbms_utility.lname_array;
  
    vi_variable  varchar(20);
    vi_tipo_dato varchar(20);
    vi_valor     varchar(150);
  BEGIN
    l_input := replace(l_input, '|', ',');
    dbms_utility.comma_to_table(list   => regexp_replace(l_input,
                                                         '(^|,)',
                                                         '\1x'),
                                tablen => l_count,
                                tab    => l_array);
    dbms_output.put_line(l_count);
    for i in 1 .. l_count loop
      dbms_output.put_line('Element ' || to_char(i) ||
                           ' of array contains: ' || substr(l_array(i), 2));
      if l_count = 2 then
        if i = 1 then
          vi_variable := substr(l_array(i), 2);
        end if;
        if i = 2 then
          vi_valor := substr(l_array(i), 2);
        end if;
      end if;
    
      if l_count = 3 then
        if i = 1 then
          vi_variable := substr(l_array(i), 2);
        end if;
        if i = 2 then
          vi_tipo_dato := substr(l_array(i), 2);
        end if;
        if i = 3 then
          vi_valor := substr(l_array(i), 2);
        end if;
      end if;
    end loop;
    vo_cantidad := l_count;
    --LIMPIAR REGISTROS DE LA VARIABLE
    BEGIN
      delete from aqpc702
       where aqpc702cor = VE_CORRELATIVO
         and aqpc702anno = TO_CHAR(SYSDATE, 'RRRR')
         and aqpc702cpe = VE_PROCESO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --
    if vo_cantidad > 0 then
      begin
        insert into aqpc702
          (aqpc702cor,
           AQPC702ANNO,
           aqpc702ord,
           aqpc702cpe,
           aqpc702var,
           aqpc702tdato,
           aqpc702valor)
        values
          (VE_CORRELATIVO,
           TO_CHAR(SYSDATE, 'RRRR'),
           VE_ORDEN,
           VE_PROCESO,
           vi_variable,
           vi_tipo_dato,
           vi_valor);
        commit;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE SP_CR_ARMAR_CONSULTA(VE_CORRELATIVO in number,
                                 VE_PROCESO     IN NUMBER,
                                 VE_PROCESO_INT IN NUMBER,
                                 VE_CANT_VAR    IN NUMBER,
                                 VE_PQT         IN VARCHAR,
                                 VE_PCDM        IN VARCHAR,
                                 VO_CONSULTA    OUT VARCHAR) IS
    CURSOR LISTADO_VARIABLES IS
      SELECT *
        FROM aqpc702 A
       WHERE A.AQPC702COR = VE_CORRELATIVO
         AND A.AQPC702ANNO =
             (SELECT TO_CHAR(PGFAPE, 'RRRR') FROM FST017 WHERE PGCOD = 1)
         AND A.AQPC702CPE = VE_PROCESO
       order by A.AQPC702ORD ASC;
    ---
    vi_variables varchar(300);
    y            number(3);
    ---
  BEGIN
    --VALIDAR SI ES UN PAQUETE O SOLO UN PROCEDIMIENTO.
    IF NVL(VE_PQT, '') = '' THEN
      VO_CONSULTA := VE_PCDM;
    ELSE
      VO_CONSULTA := VE_PQT || '.' || VE_PCDM;
    END IF;
    --VALIDAR SI TIENE VARIABLES PARA INCLUIRLOS EN LA CONSULTA
    IF VE_CANT_VAR > 0 THEN
      BEGIN
        FOR x in LISTADO_VARIABLES LOOP
          y := y + 1;
          if x.aqpc702tdato = 'V' or x.aqpc702tdato = 'C' or
             nvl(x.aqpc702tdato, '') IS NULL and
             (VE_CANT_VAR = 1 OR y = VE_CANT_VAR) then
            --para indicar que es de tipo varchar O CHARACTER
            vi_variables := vi_variables || '''' || x.aqpc702valor || '''';
          ELSE
            IF x.aqpc702tdato = 'V' or x.aqpc702tdato = 'C' or
               nvl(x.aqpc702tdato, '') IS NULL THEN
              vi_variables := vi_variables || '''' || x.aqpc702valor ||
                              ''',';
            END IF;
          END IF;
        
          if x.aqpc702tdato = 'N' and (VE_CANT_VAR = 1 OR y = VE_CANT_VAR) then
            --para indicar que es de tipo varchar O CHARACTER
            vi_variables := vi_variables || '''' || x.aqpc702valor || '''';
          ELSE
            IF x.aqpc702tdato = 'N' THEN
              vi_variables := vi_variables || x.aqpc702valor || ',';
            END IF;
          END IF;
        
          if x.aqpc702tdato = 'D' and (VE_CANT_VAR = 1 OR y = VE_CANT_VAR) then
            --para indicar que es de tipo varchar O CHARACTER
            vi_variables := vi_variables || 'to_date(' || x.aqpc702valor ||
                            ',''RRRR'')';
          ELSE
            IF x.aqpc702tdato = 'D' THEN
              vi_variables := vi_variables || 'to_date(' || x.aqpc702valor ||
                              ',''RRRR''),';
            END IF;
          END IF;
        END LOOP;
      END;
      --FINALIZAR ARMADO DE CONSULTA
      VO_CONSULTA := VO_CONSULTA || '(' || VE_CORRELATIVO || ',' ||
                     vi_variables || ');';
    ELSE
      --FINALIZAR ARMADO DE CONSULTA  
      VO_CONSULTA := VO_CONSULTA;
    END IF;
  END;
  PROCEDURE SP_CR_EJECUTAR_PROCESO_MANUAL(VE_PROCESO     in number,
                                          VE_CORRELATIVO IN NUMBER) IS
    vi_variables      varchar(3000);
    vi_instancia      xwf700.xwfempresa%type;
    vi_aqpc565usue    aqpc565.AQPC565U_ENV%type;
    vi_aqpc565est     aqpc565.AQPC565EST%type;
    vi_emp            aqpc565.AQPC565EMP%type;
    vi_suc            aqpc565.AQPC565SUC%type;
    vi_mod            aqpc565.AQPC565MOD%type;
    vi_mda            aqpc565.AQPC565MND%type;
    vi_pap            aqpc565.AQPC565PAP%type;
    vi_cta            aqpc565.AQPC565CTA%type;
    vi_ope            aqpc565.AQPC565OPE%type;
    vi_sbop           aqpc565.AQPC565SOPE%type;
    vi_top            aqpc565.AQPC565TOPE%type;
    vi_cant_variables number(9);
    --vi_array_variables  dbms_utility.lname_array;
    -----
    VI_PI_PQT  aqpc566.aqpc566pqt%type;
    VI_PI_PCDM aqpc566.aqpc566pcdm%type;
    VI_PI_PROG aqpc566.aqpc566prog%type;
    -----
    vi_consulta_execute varchar2(500);
    VS_CONSULTA         VARCHAR(500);
    -----
    VO_COD_ERROR VARCHAR(10);
    VO_MSG_ERROR VARCHAR(350);
    -----
    y number(9);
    -----
    --Cursor para separar variables.
    cursor lista_variables(c_variables in varchar) is
      select regexp_substr(c_variables, '[^;]+', 1, level) as cadena,
             level nivel
        from dual
      connect by regexp_substr(c_variables, '[^;]+', 1, level) is not null;
  
  BEGIN
    --BUSCAR SI EL REGISTRO EXISTE EN LA TABLA AQPBC565
    --VALIDAR SI LOS DATOS SON CORRECTOS.
    BEGIN
      select aqpc565var,
             aqpc565inst,
             aqpc565u_env,
             aqpc565est,
             aqpc565emp,
             aqpc565suc,
             aqpc565mod,
             aqpc565mnd,
             aqpc565pap,
             aqpc565cta,
             aqpc565ope,
             aqpc565sope,
             aqpc565tope
        INTO vi_variables,
             vi_instancia,
             vi_aqpc565usue,
             vi_aqpc565est,
             vi_emp,
             vi_suc,
             vi_mod,
             vi_mda,
             vi_pap,
             vi_cta,
             vi_ope,
             vi_sbop,
             vi_top
        from aqpc565
       WHERE AQPC565CORR = VE_CORRELATIVO
         AND AQPC565IDCPE = VE_PROCESO;
    exception
      when others then
        null;
    END;
  
    IF upper(substr(vi_aqpc565est, 1, 1)) = 'A' THEN
      VO_COD_ERROR := '0001';
      vo_MSG_ERROR := 'La solicitud ya fue autorizada es un correo anterior';
    
    end if;
  
    IF upper(substr(vi_aqpc565est, 1, 1)) = 'R' THEN
      VO_COD_ERROR := '0002';
      vo_MSG_ERROR := 'La solicitud ya fue rechazada es un correo anterior';
    
    end if;
    --DESCOMPONER LAS VARIABLES A EJECUTAR E INCLUIR EN EL PROCESO CAMPO aqpc565var
    IF vi_variables IS NOT NULL THEN
      --PRIMERO OBTENER DESCOMPOSICION POR ; PARA OBTENER CANTIDAD DE VARIABLES
      y := 0;
      FOR X IN lista_variables(vi_variables) LOOP
        --DESCOMPONER LAS VARIABLES POR VARIABLE,TIPO DATO Y VALOR.                 
        y := y + 1;
        PQ_CR_PROCESAR_BOT.SP_SR_GENERAR_ARRAY_VARCHAR(VE_PROCESO,
                                                       VE_CORRELATIVO,
                                                       y,
                                                       x.cadena,
                                                       vi_cant_variables);
      END LOOP;
    
    END IF;
    --VALIDAR CUAL ES EL PROCESO A EJECUTAR.
    --EL VE_IDCODPRO indica que codigo de proceso es el que define cual es que se debe eliminar.
    BEGIN
      SELECT AQPC566PQT, AQPC566PCDM, AQPC566PROG
        INTO VI_PI_PQT, VI_PI_PCDM, VI_PI_PROG
        FROM AQPC566 A
       WHERE A.AQPC566COD = VE_PROCESO;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0003';
        VO_MSG_ERROR := 'No se encontro el proceso a ejecutar para el proceso seleccionado: ' ||
                        VE_PROCESO;
    END;
  
    -- ARMAR EL PROCESO A EJECUTAR.
    BEGIN
      if nvl(VI_PI_PROG, '') IS NULL then
        PQ_CR_PROCESAR_BOT.SP_CR_ARMAR_CONSULTA(VE_CORRELATIVO,
                                                VE_PROCESO,
                                                0,
                                                Y,
                                                VI_PI_PQT,
                                                VI_PI_PCDM,
                                                VS_CONSULTA);
      else
        NULL; --todavia no definido para el caso de que sea programa, no seria desde paquete.
      end if;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0005';
        VO_MSG_ERROR := 'Ocurrio un problema al trata de armar la consulta del correlativo: ' ||
                        VE_CORRELATIVO;
    END;
    --PROCESO PARA ACTUALIZAR LOS DATOS DE LA TABLA PARA INDICAR SI SE EHJECUTO EL PROCESO O SI NO SE PUDO EJECUTAR.
    BEGIN
      VS_CONSULTA := 'BEGIN ' || VS_CONSULTA || ' END';
      --EXECUTE IMMEDIATE VS_CONSULTA;
      execute immediate 'DECLARE BEGIN PQ_CR_BOT_TASA.SP_ELIMINAR_TASA(' ||
                        VE_CORRELATIVO || ',1); END;';
      /*dbms_output.put_line('DECLARE BEGIN PQ_CR_BOT_TASA.SP_ELIMINAR_TASA(' ||
                           VE_IDCODIGO || ',1) END');*/
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0006';
        VO_MSG_ERROR := 'Ocurrio un problema al trata de ejecutar la consulta : ' ||
                        VS_CONSULTA;
    END;
    BEGIN
      IF LENGTH(VO_MSG_ERROR) > 0 THEN
        update aqpc565 A5
           set A5.AQPC565MSJERR = VO_MSG_ERROR,
               A5.AQPC565C_ERR  = TO_NUMBER(VO_COD_ERROR),
               A5.AQPC565EST    = 'E' --PARA INDICAR QUE ES ERRRO 
         WHERE AQPC565CORR = VE_CORRELATIVO
           AND AQPC565IDCPE = VE_PROCESO;
        /*AND AQPC565IDCPI  = VE_IDCODPROC_INT
        AND AQPC565PARA   = VE_AUTORIZADOR;*/
        COMMIT;
      ELSE
        update aqpc565 A5
           set A5.AQPC565MSJERR = VO_MSG_ERROR,
               A5.AQPC565C_ERR  = TO_NUMBER(VO_COD_ERROR),
               A5.AQPC565EST    = upper(substr(vi_aqpc565est, 1, 1)) --PARA INDICAR QUE ES ERROR
         WHERE AQPC565CORR = VE_CORRELATIVO
           AND AQPC565IDCPE = VE_PROCESO; /*
                                         AND AQPC565IDCPI  = VE_IDCODPROC_INT
                                         AND AQPC565PARA   = VE_AUTORIZADOR; */
        COMMIT;
      END IF;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        VO_COD_ERROR := '0007';
        VO_MSG_ERROR := 'Ocurrio un problema al Actualizar los registros, registro no encontrado ' ||
                        VE_CORRELATIVO;
    END;
    dbms_output.put_line(VO_COD_ERROR || ' ' || vo_MSG_ERROR);
    if VO_COD_ERROR <> '0000' then
      VO_MSG_ERROR := 'No se pudo procesar lo solicitado, error al Eliminar Tasa';
    end if;
    /*
    insert into prueba_log
      (pgcod, msg, fecha)
    values
      (100, 'BOT-' || VE_CORRELATIVO, sysdate);
    */
  EXCEPTION
    WHEN OTHERS THEN
      VO_COD_ERROR := '0010';
      VO_MSG_ERROR := 'Ocurrio un problema al trata de ejecutar el proceso con correlativo: ' ||
                      VE_CORRELATIVO;
      dbms_output.put_line(VO_COD_ERROR || ' ' || vo_MSG_ERROR);
      if VO_COD_ERROR <> '0000' then
        VO_MSG_ERROR := 'No se pudo procesar lo solicitado, error al Eliminar Tasa';
      end if;
      /*
      insert into prueba_log
        (pgcod, msg, fecha)
      values
        (100, 'BOT-' || VE_CORRELATIVO, sysdate);
      */
  END;

end PQ_CR_PROCESAR_BOT;
/

