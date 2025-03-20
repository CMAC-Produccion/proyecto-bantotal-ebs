create or replace package PQ_ENV_CORREO_BANCA_MOVIL is

  procedure sp_enviar_correo(p_pgcod    number,
                             p_mod      number,
                             p_tra      number,
                             p_rel      number,
                             p_fec      date,
                             p_dest     varchar2,
                             p_ctaori   varchar2,
                             p_cliori   varchar2,
                             p_ctades   varchar2,
                             p_clides   varchar2,
                             p_monto    varchar2,
                             p_comision varchar2,
                             p_codent   number,
                             p_codtsv   number,
                             p_contrato varchar2,
                             p_formato  number,
                             p_coderr   out varchar2,
                             p_c_msgerr out varchar2);
  function fn_obtener_empresa(p_empresa number) return varchar2;
  function fn_obtener_servicio(p_servicio number) return varchar2;
  function fn_obtener_institucion(p_inst number) return varchar2;
  procedure sp_enviar_correo_bk(p_pgcod    number,
                                p_mod      number,
                                p_tra      number,
                                p_rel      number,
                                p_fec      date,
                                p_dest     varchar2,
                                p_ctaori   varchar2,
                                p_cliori   varchar2,
                                p_ctades   varchar2,
                                p_clides   varchar2,
                                p_monto    varchar2,
                                p_comision varchar2,
                                p_codent   number,
                                p_codtsv   number,
                                p_contrato varchar2,
                                p_formato  number,
                                p_coderr   out varchar2,
                                p_c_msgerr out varchar2);
  procedure sp_correo_conexion(p_nombre   varchar2,
                               p_tarj     varchar2,
                               p_correo   varchar2,
                               p_lugar    varchar2,
                               p_fecha    date,
                               p_hora     varchar2,
                               p_coderr   out varchar2,
                               p_c_msgerr out varchar2);

  procedure sp_correo_afiliacion(p_numtar   varchar2,
                                 p_coderr   out varchar2,
                                 p_c_msgerr out varchar2);
  procedure sp_correo_afiliacionD2(p_numtar   varchar2,
                                   p_codigo varchar2,
                                   p_coderr   out varchar2,
                                   p_c_msgerr out varchar2);

end PQ_ENV_CORREO_BANCA_MOVIL;
/

create or replace package body PQ_ENV_CORREO_BANCA_MOVIL is
  -- *****************************************************************
  -- Nombre                     : PQ_ENV_CORREO_BANCA_MOVIL
  -- Sistema                    : BANTOTAL
  -- Módulo                     : BANCA MOVIL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 24/02/2016
  -- Autor de Creación          : Chernandez.
  -- Uso                        : Envia correo confirmacion banca movil
  -- Estado                     : Activo
  -- *****************************************************************

  procedure sp_enviar_correo(p_pgcod    number,
                             p_mod      number,
                             p_tra      number,
                             p_rel      number,
                             p_fec      date,
                             p_dest     varchar2,
                             p_ctaori   varchar2,
                             p_cliori   varchar2,
                             p_ctades   varchar2,
                             p_clides   varchar2,
                             p_monto    varchar2,
                             p_comision varchar2,
                             p_codent   number,
                             p_codtsv   number,
                             p_contrato varchar2,
                             p_formato  number,
                             p_coderr   out varchar2,
                             p_c_msgerr out varchar2) is
  
    v_From VARCHAR2(80);
  
    v_Subject VARCHAR2(200);
    v_Body    VARCHAR2(10000);
  
    C_SMTP_SERVER VARCHAR2(30);
    C_SMTP_PORT   VARCHAR2(4);
    V_Conexion    utl_smtp.Connection;
    msg           varchar2(32767);
    --p_c_msgerr    VARCHAR2(1000);
    vhost_name VARCHAR2(100);
    nomtransac varchar2(30);
    control    varchar2(30);
    cliori     varchar2(150);
    clides     varchar2(150);
    monto      varchar2(150);
    ls_concepto varchar2(66);
    ls_COENT   number(3);
    ls_COTSV   number(3);
    ls_sumin VARCHAR2(20);
    ls_copsv  number(10);
    ls_nomcli VARCHAR2(150);
    ls_recibo varchar2(200);
    vhora varchar2(8);
    fecha date;
  v_found number;
	
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
    cliori := replace(p_cliori, '+', ' ');
    clides := replace(p_clides, '+', ' ');
    monto  := replace(p_monto, '+', ' ');
		
		SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);

--    if  UPPER(VHOST_NAME) in ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051')  then             
--    if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
    --IF UPPER(VHOST_NAME) IN ('DSBD1051') THEN
      if v_found =1 then
      select trim(tp1desc) tp1desc
        into C_SMTP_SERVER
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 1
         and tp1corr3 = 1;
    
      select trim(tp1desc) tp1desc
        into C_SMTP_PORT
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 2
         and tp1corr3 = 1;
    
      --v_From      := 'nbantotal@cajaarequipa.pe';
      v_From := 'cajamovil@cajaarequipa.pe';
    
      select upper(trim(trnom))
        into nomtransac
        from fst034
       where pgcod = p_pgcod
         and trmod = p_mod
         and trnro = p_tra;
      
      select a.ithora into vhora from fsd015 a 
      where a.pgcod=1 and a.itsuc=907 and a.itmod=p_mod and a.ittran=p_tra and a.itnrel=p_rel;
      
    
      v_Subject := 'ENVIO AUTOMATICO -  CONFIRMACION ' || nomtransac || ' - CAJA MOVIL/OPERACIONES POR INTERNET';
    
      if (p_fec<to_date('01/01/2010','dd/mm/yyyy')) then
            fecha      := sysdate;
      else
            fecha      := p_fec;
      end if;
            
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, C_SMTP_PORT);
      msg        := 'Date: ' ||
                    to_char(fecha, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                    utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                    'Subject: ' || v_Subject || utl_tcp.crlf || 'To: ' ||
                    p_dest || utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      utl_smtp.Rcpt(V_Conexion, p_dest);
    
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg); --date
      utl_smtp.write_data(V_Conexion, 'MIME-Version: 1.0' || utl_tcp.crlf); -- Use MIME mail standard
      utl_smtp.write_data(V_Conexion,
                          'Content-Type: multipart/mixed;' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' boundary=-----SECBOUND' || utl_tcp.crlf ||
                          utl_tcp.crlf);
    
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          'Content-Type: text/html;charset="iso-8859-1"' ||
                          utl_tcp.crlf);
      --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
    
      control := to_char(fecha, 'yyyymmdd') || '907' || lpad(to_char(p_mod),3,'0') ||
                 lpad(to_char(p_tra),3,'0') || lpad(to_char(p_rel),4,'0');
      v_Body  := '<head>    
                    <style type="text/css">
                        .style1
                        {
                            font-family: "Tahoma";
                            font-size: x-small;
                        }
                    </style>
                </head>
                <table style="width: 100%">
                <tr style="background-color:#002753; width:100%">
                    <td style="background-color:#002753; " class="style2">
                <img src="http://www.cajaarequipa.pe/wp-content/themes/ut23UzL5V_carequipa/images/logo.png" style="background-color:#002753" alt="Caja Arequipa" \>
                </td>
                </tr>
                </table>' ||                 
                 '<br />CONSTANCIA DE '|| nomtransac ||' - CAJA MOVIL/OPERACIONES POR INTERNET<br /><br />' ||
                 '<hr>' ||
                 '<table>'||
                 '<tr class="style1"><td>Titular</td><td> </td><td>:' || cliori || '</td></tr>' ||
                 '<tr class="style1"><td>Fecha y hora</td><td> </td><td>:' || to_char(fecha, 'dd/MM/YYYY') || ' - ' || vhora || '</td></tr>' ||
                 '<tr class="style1"><td>Número de operación</td><td> </td><td>:' ||control || '</td></tr>';
      if p_formato = 0 then
        begin
          select txtord 
          into ls_concepto
          from fsx016 
         where pgcod = p_pgcod 
           and hcmod = p_mod 
           and htran = p_tra 
           and hfcon = p_fec
           and hnrel = p_rel 
           and hcord = 10 
           and hsucor = 907;
          EXCEPTION          
          when no_data_found then
           ls_concepto := ' ';
          when others then
            ls_concepto := ' ';
          end;
         
        v_Body := v_Body ||
                  '<tr class="style1"><td>Cuenta Origen</td><td> </td><td>:' ||replace(p_ctaori, '+', ' ') || '</td></tr>'||
                  '<tr class="style1"><td>Cuenta Destino</td><td> </td><td>:' ||
                  replace(p_ctades, '+', ' ') || '</td></tr>' ||
                  '<tr class="style1"><td>Titular de la cuenta</td><td> </td><td>:' ||
                  clides || '</td></tr>' ||
                  '<tr class="style1"><td>Monto</td><td> </td><td>:' ||monto ||'</td></tr>'||
                  '<tr class="style1"><td>Concepto</td><td> </td><td>:' ||ls_concepto || '</td></tr>';
      else
        if p_formato = 1 then
          
          select jaql515coent, jaql515cotsv, jaql515sumin, jaql515copsv
            into ls_COENT,ls_COTSV,ls_sumin,ls_copsv
            from jaql515
           where jaql515pgsuc = 907
             and jaql515scmod = p_mod
             and jaql515stran = p_tra
             and jaql515snrel = p_rel
             and jaql515femov = trunc(fecha)
             and rownum = 1;
       
          begin   
            select jaql506Clien
              into ls_nomcli
              from jaql506
             where jaql506coent = ls_COENT
               and jaql506cotse = ls_COTSV
               and jaql506nrcon = ls_sumin
               and rownum = 1;
          exception 
               when no_data_found then
                 ls_nomcli:='***';
          end;       
           
           select rtrim(xmlagg(xmlelement(e, jaql516nudoc || '- ') ORDER BY jaql516nudoc)
                        .extract('//text()'),
                        '- ')
             into ls_recibo
             from jaql516
            where jaql515copsv = ls_copsv;
	  
          v_Body := v_Body ||
                    '<tr class="style1"><td>Empresa</td><td> </td><td>:' ||
                    fn_obtener_empresa(p_codent) || '</td></tr>' ||
                    '<tr class="style1"><td>Servicio</td><td> </td><td>:' ||
                    fn_obtener_servicio(p_codtsv) || '</td></tr>' ||
                    '<tr class="style1"><td>Codigo de usuario</td><td> </td><td>:' ||
                    ls_sumin || '</td></tr>' ||
                    '<tr class="style1"><td>Titular del Servicio</td><td> </td><td>:' ||
                    ls_nomcli || '</td></tr>' ||
                    '<tr class="style1"><td>N Recibo</td><td> </td><td>:' ||
                    ls_recibo || '</td></tr>' ||
                    '<tr class="style1"><td>Importe Pagado</td><td> </td><td>:' ||
                    monto || '</td></tr>' ;
        else
          if p_formato = 2 then
            v_Body := v_Body ||
                      '<tr class="style1"><td>Institución</td><td> </td><td>:' ||
                      fn_obtener_institucion(p_codent) || '</td></tr>' ||
                      '<tr class="style1"><td>Nombre cliente</td><td> </td><td>:' ||
                      clides || '</td></tr>' ||
                      '<tr class="style1"><td>Codigo Cliente</td><td> </td><td>:' ||
                      replace(p_contrato, '+', ' ') || '</td></tr>' ||
                      '<tr class="style1"><td>Monto</td><td> </td><td>:' ||
                      monto || '</td></tr>' ||
                      '<tr class="style1"><td>Comision</td><td> </td><td>:' ||
                      replace(p_comision, '+', ' ') || '</td></tr>';
          else
            if p_formato = 3 then
              v_Body := v_Body ||
                        '<tr class="style1"><td>Cuenta Origen</td><td> </td><td>:' ||replace(p_ctaori, '+', ' ') || '</td></tr>'||
                        '<tr class="style1"><td>Número Crédito</td><td> </td><td>:' ||
                        replace(p_ctades, '+', ' ') || '</td></tr>' ||
                        '<tr class="style1"><td>Importe a Acreditar</td><td> </td><td>:' ||
                        monto || '</td></tr>';
            end if;
          end if;
        end if;
      end if;
      v_Body := v_Body ||

                --'<tr class="style1"><td>Estado</td><td> </td><td>:Transaccion realizada' ||
                
                
                '</table>' || '<hr>' ||
                '<br />Puedes verificar tu operación a través de nuestros canales de atención :
                Caja Internet, Caja Móvil, Cajeros Automáticos, Agente Caja o en cualquiera de nuestras agencias a nivel nacional. 
                ' ||
                '<br />__________________________________________________________________________________________________________________<br /><br />' ||
                '<br />El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja. <br />' ||
                '<br />Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje. <br />' ||
                '<br />Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.  <br /><br />';
    
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || --8bit
                          utl_tcp.crlf || utl_tcp.crlf || v_Body || CHR(13) ||
                          CHR(13) || CHR(13) || utl_tcp.crlf); --Message Body
      /*utl_smtp.write_data(V_Conexion,
      '-------SECBOUND' || utl_tcp.crlf ||
      --'Content-Type: text/plain;' || utl_tcp.crlf);--
       'Content-Type: text/plain; charset=iso-8859-1' ||
       utl_tcp.crlf);*/
    
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
    
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    END IF;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_coderr := '80000';
      --p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      p_c_msgerr := 'No se puede enviar MAIL, posiblemente este mal registrado.';
      --raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
  
  END sp_enviar_correo;
  
 

  function fn_obtener_empresa(p_empresa number) return varchar2 is
  
    nombre varchar2(60);
  begin
    nombre := '';
    begin
      select JAQL508ABENT
        into nombre
        from jaql508
       Where JAQL508COENT = p_empresa;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nombre := '';
      
    end;
    return nombre;
  end fn_obtener_empresa;

  function fn_obtener_servicio(p_servicio number) return varchar2 is
  
    nombre varchar2(60);
  begin
    nombre := '';
    begin
      select JAQL514DETSV
        into nombre
        from jaql514
       Where jaql514COTSV = p_servicio;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nombre := '';
      
    end;
    return nombre;
  end fn_obtener_servicio;

  function fn_obtener_institucion(p_inst number) return varchar2 is
  
    nombre varchar2(60);
  begin
    nombre := '';
    begin
      select jaqz205ides
        into nombre
        from jaqz205i
       Where jaqz205icod = p_inst;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nombre := '';
      
    end;
    return nombre;
  end fn_obtener_institucion;
  procedure sp_enviar_correo_bk(p_pgcod    number,
                                p_mod      number,
                                p_tra      number,
                                p_rel      number,
                                p_fec      date,
                                p_dest     varchar2,
                                p_ctaori   varchar2,
                                p_cliori   varchar2,
                                p_ctades   varchar2,
                                p_clides   varchar2,
                                p_monto    varchar2,
                                p_comision varchar2,
                                p_codent   number,
                                p_codtsv   number,
                                p_contrato varchar2,
                                p_formato  number,
                                p_coderr   out varchar2,
                                p_c_msgerr out varchar2) is
  
    v_From VARCHAR2(80);
  
    v_Subject VARCHAR2(200);
    v_Body    VARCHAR2(1000);
  
    C_SMTP_SERVER VARCHAR2(30);
    C_SMTP_PORT   VARCHAR2(4);
    V_Conexion    utl_smtp.Connection;
    msg           varchar2(32767);
    --p_c_msgerr    VARCHAR2(1000);
    vhost_name VARCHAR2(100);
    nomtransac varchar2(30);
    control    varchar2(30);
  
    fecha date;
  v_found number;
	
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
  
	SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);

--    if  UPPER(VHOST_NAME) in ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051')  then             
    --IF UPPER(VHOST_NAME) IN  ('DSBD1051') THEN
      if v_found =1 then
      select trim(tp1desc) tp1desc
        into C_SMTP_SERVER
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 1
         and tp1corr3 = 1;
    
      select trim(tp1desc) tp1desc
        into C_SMTP_PORT
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 2
         and tp1corr3 = 1;
    
      --v_From      := 'nbantotal@cajaarequipa.pe';
      v_From := 'cajamovil@cajaarequipa.pe';
    
      select trnom
        into nomtransac
        from fst034
       where pgcod = p_pgcod
         and trmod = p_mod
         and trnro = p_tra;
    
      v_Subject := 'CONFIRMACION ' || nomtransac;
    
      fecha      := p_fec;
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, C_SMTP_PORT);
      msg        := 'Date: ' ||
                    to_char(fecha, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                    utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                    'Subject: ' || v_Subject || utl_tcp.crlf || 'To: ' ||
                    p_dest || utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      utl_smtp.Rcpt(V_Conexion, p_dest);
    
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg);
      utl_smtp.write_data(V_Conexion, 'MIME-Version: 1.0' || utl_tcp.crlf); -- Use MIME mail standard
      utl_smtp.write_data(V_Conexion,
                          'Content-Type: multipart/mixed;' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' boundary=-----SECBOUND' || utl_tcp.crlf ||
                          utl_tcp.crlf);
    
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          'Content-Type: text/plain;' || utl_tcp.crlf);
      --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
      control := to_char(fecha, 'ddmmyyyy') || to_char(p_mod) ||
                 to_char(p_tra) || to_char(p_rel);
      v_Body  := 'Estimado Cliente:' || CHR(13) || CHR(13) ||
                 '<p>Se ha realizado la siguiente transacción:</p>' ||
                 CHR(13) || CHR(13) || 'Operación . . . . . . . . . :' ||
                 nomtransac || CHR(13) || CHR(13) ||
                 'Cuenta Origen . . . . . .:' || p_ctaori || CHR(13) ||
                 CHR(13) || 'Titular de la cuenta . .:' || p_cliori ||
                 CHR(13) || CHR(13);
      if p_formato = 0 then
        v_Body := v_Body || 'Cuenta Destino . . . . .:' || p_ctades ||
                  CHR(13) || CHR(13) || 'Titular de la cuenta . .:' ||
                  p_clides || CHR(13) || CHR(13) ||
                  'Importe a Acreditar . .:' || p_monto || CHR(13) ||
                  CHR(13);
      else
        if p_formato = 1 then
          v_Body := v_Body || 'Empresa   . . . . . . . . . :' ||
                    fn_obtener_empresa(p_codent) || CHR(13) || CHR(13) ||
                    'Servicio  . . . . . . . . . :' ||
                    fn_obtener_servicio(p_codtsv) || CHR(13) || CHR(13) ||
                    'Contrato  . . . . . . . . . :' || p_contrato ||
                    CHR(13) || CHR(13) || 'Monto     . . . . . . . . . :' ||
                    p_monto || CHR(13) || CHR(13) ||
                    'Comision  . . . . . . . . . :' || p_comision ||
                    CHR(13) || CHR(13);
        else
          if p_formato = 2 then
            v_Body := v_Body || 'Institución . . . . . . . . :' ||
                      fn_obtener_institucion(p_codent) || CHR(13) ||
                      CHR(13) || 'Nombre cliente. . . . . . . :' ||
                      p_clides || CHR(13) || CHR(13) ||
                      'Codigo Cliente. . . . . . . :' || p_contrato ||
                      CHR(13) || CHR(13) || 'Monto     . . . . . . . . . :' ||
                      p_monto || CHR(13) || CHR(13) ||
                      'Comision  . . . . . . . . . :' || p_comision ||
                      CHR(13) || CHR(13);
          else
            if p_formato = 3 then
              v_Body := v_Body || 'Número Crédito . . . . .:' || p_ctades ||
                        CHR(13) || CHR(13) || 'Importe a Acreditar . .:' ||
                        p_monto || CHR(13) || CHR(13);
            end if;
          end if;
        end if;
      end if;
      v_Body := v_Body || 'Nro. de Control . . . . .:' || control ||
                CHR(13) || CHR(13) ||
                'Estado . . . . . . . . . . . .:Transaccion realizada' ||
                CHR(13) || CHR(13) || CHR(13) || CHR(13) ||
                'Saludos cordiales' || CHR(13) || CHR(13) ||
                'Caja Municipal de Ahorro y Credito de Arequipa' || CHR(13);
    
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || --8bit
                          utl_tcp.crlf || utl_tcp.crlf || v_Body || CHR(13) ||
                          CHR(13) || CHR(13) || utl_tcp.crlf); --Message Body
      /*utl_smtp.write_data(V_Conexion,
      '-------SECBOUND' || utl_tcp.crlf ||
      --'Content-Type: text/plain;' || utl_tcp.crlf);--
       'Content-Type: text/plain; charset=iso-8859-1' ||
       utl_tcp.crlf);*/
    
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
    
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    END IF;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      --raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
      p_coderr := '80000';
  END sp_enviar_correo_bk;

  procedure sp_correo_conexion(p_nombre   varchar2,
                               p_tarj     varchar2,
                               p_correo   varchar2,
                               p_lugar    varchar2,
                               p_fecha    date,
                               p_hora     varchar2,
                               p_coderr   out varchar2,
                               p_c_msgerr out varchar2) is
  
    v_From VARCHAR2(80);
  
    v_Subject VARCHAR2(200);
    v_Body    VARCHAR2(10000);
  
    C_SMTP_SERVER VARCHAR2(30);
    C_SMTP_PORT   VARCHAR2(4);
    V_Conexion    utl_smtp.Connection;
    msg           varchar2(32767);
    --p_c_msgerr    VARCHAR2(1000);
    vhost_name VARCHAR2(100);
  
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
    --IF UPPER(VHOST_NAME) IN ('DSBD1051') THEN
    IF UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052','DWHBD1051') THEN
               
	
      select trim(tp1desc) tp1desc
        into C_SMTP_SERVER
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 1
         and tp1corr3 = 1;
    
      select trim(tp1desc) tp1desc
        into C_SMTP_PORT
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 2
         and tp1corr3 = 1;
    
      --v_From      := 'nbantotal@cajaarequipa.pe';
      v_From := 'cajamovil@cajaarequipa.pe';
    
      v_Subject := 'Caja Arequipa Notificación de Ingreso';
    
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, C_SMTP_PORT);
      msg        :=  --'Date: ' ||
      --to_char(fecha, 'Dy, DD Mon YYYY hh24:mi:ss') ||
      --utl_tcp.crlf || 
       'From: ' || v_From || utl_tcp.crlf || 'Subject: ' ||
                    v_Subject || utl_tcp.crlf || 'To: ' || p_correo ||
                    utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      utl_smtp.Rcpt(V_Conexion, p_correo);
    
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg); --date
      utl_smtp.write_data(V_Conexion, 'MIME-Version: 1.0' || utl_tcp.crlf); -- Use MIME mail standard
      utl_smtp.write_data(V_Conexion,
                          'Content-Type: multipart/mixed;' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' boundary=-----SECBOUND' || utl_tcp.crlf ||
                          utl_tcp.crlf);
    
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          'Content-Type: text/html;charset="iso-8859-1"' ||
                          utl_tcp.crlf);
      --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
    
      v_Body := '<head>    
                    <style type="text/css">
                        .style1
                        {
                            font-family: "Tahoma";
                            font-size: x-small;
                        }
                    </style>
                </head>
                <table style="width: 100%">
                <tr style="background-color:#002753; width:100%">
                    <td style="background-color:#002753; " class="style2">
                <img src="http://www.cajaarequipa.pe/wp-content/themes/ut23UzL5V_carequipa/images/logo.png" style="background-color:#002753" alt="Caja Arequipa" \>
                </td>
                </tr>
                </table>' ||
                '<p style="font-family: Tahoma;font-size: x-small;"> <b>Estimado Cliente ' ||
                p_nombre || ': </b>' ||
                '<br /><br />Le informamos que se ha registrado un ingreso a ' ||
                p_lugar || ' con su tarjeta ' || p_tarj || ' el
                día ' || to_char(p_fecha, 'dd/mm/YYYY') ||
                ' a las ' || p_hora ||
                '.<br /><br />
                Esta alerta es enviada automaticamente por su seguridad, si es que usted no reconoce esta operación, proceda a bloquear su tarjeta.</p>';
    
      v_Body := v_Body || ' ' ||
                '<p style="font-family: Tahoma;font-size: x-small;">Gracias' ||
                '<br /><br />Caja Arequipa </p>';
    
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || --8bit
                          utl_tcp.crlf || utl_tcp.crlf || v_Body || CHR(13) ||
                          CHR(13) || CHR(13) || utl_tcp.crlf); --Message Body
      /*utl_smtp.write_data(V_Conexion,
      '-------SECBOUND' || utl_tcp.crlf ||
      --'Content-Type: text/plain;' || utl_tcp.crlf);--
       'Content-Type: text/plain; charset=iso-8859-1' ||
       utl_tcp.crlf);*/
    
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
    
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    END IF;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      --raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
      p_coderr := '80000';
  END sp_correo_conexion;

  procedure sp_correo_afiliacion(p_numtar   varchar2,
                                 p_coderr   out varchar2,
                                 p_c_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_correo_afiliacion
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Correo de Afiliaciones Caja Móvil
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
    v_From        VARCHAR2(80);
    v_Subject     VARCHAR2(200);
    v_Body        VARCHAR2(10000);
    C_SMTP_SERVER VARCHAR2(30);
    C_SMTP_PORT   VARCHAR2(4);
    V_Conexion    utl_smtp.Connection;
    msg           varchar2(32767);
    vhost_name    VARCHAR2(100);
    ld_fecha      date;
    ld_nomcli     varchar2(30);
    ld_cordes     varchar2(100);
    ls_nomdis     varchar2(100);
    ls_numtar     CHAR(19);
    ls_numcel     varchar2(10);
    ln_codope     number(9);
		v_found number;
		
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
  
	SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);

--    if  UPPER(VHOST_NAME) in ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051')  then             
   -- IF UPPER(VHOST_NAME) IN ('DSBD1051') THEN
	   if v_found =1 then
      ls_numtar := p_numtar;
      select trim(tp1desc) tp1desc
        into C_SMTP_SERVER
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 1
         and tp1corr3 = 1;
    
      select trim(tp1desc) tp1desc
        into C_SMTP_PORT
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 2
         and tp1corr3 = 1;
    
      -- Datos de Afiliacion
    
      select to_date(jaqz205feafi || ' ' || jaqz205hoafi,
                     'DD/MM/YY hh24:mi:ss'),
             coalesce(jaqz205EMAIL, ''),
             coalesce(jaqz205aux1, ''),
             coalesce(jaqz205celul, '')
        into ld_fecha, ld_cordes, ls_nomdis, ls_numcel
        from jaqz205
       where jaqz205nutar = ls_numtar;
    
      select max(jaqz208SEINT)
        into ln_codope
        from jaqz208
       where jaqz208nutar = ls_numtar;
    
      select cli.penom
        into ld_nomcli
        from z0e478 pue
       inner join fsd001 cli
          on cli.pepais = pue.z0e478thp
         and cli.petdoc = pue.z0e478tht
         and cli.pendoc = pue.z0e478thd
       where pue.z0e478nro = ls_numtar;
    
      --v_From      := 'nbantotal@cajaarequipa.pe';
      v_From    := 'cajamovil@cajaarequipa.pe';
      v_Subject := 'ENVIO AUTOMATICO - CONSTANCIA DE AFILIACION- CAJA MOVIL AQP / OPERACIONES POR INTERNET';
    
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, C_SMTP_PORT);
      msg        := 'Date: ' ||
                    to_char(ld_fecha, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                    utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                    'Subject: ' || v_Subject || utl_tcp.crlf || 'To: ' ||
                    ld_cordes || utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      utl_smtp.Rcpt(V_Conexion, ld_cordes);
    
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg); --date
      utl_smtp.write_data(V_Conexion, 'MIME-Version: 1.0' || utl_tcp.crlf); -- Use MIME mail standard
      utl_smtp.write_data(V_Conexion,
                          'Content-Type: multipart/mixed;' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' boundary=-----SECBOUND' || utl_tcp.crlf ||
                          utl_tcp.crlf);
    
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          'Content-Type: text/html;charset="iso-8859-1"' ||
                          utl_tcp.crlf);
      --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
    
      v_Body := '<head>    
                    <style type="text/css">
                        .style1
                        {
                            font-family: "Tahoma";
                            font-size: x-small;
                        }
                    </style>
                </head>
                <table style="width: 100%">
                <tr style="background-color:#002753; width:100%">
                    <td style="background-color:#002753; " class="style2">
                <img src="http://www.cajaarequipa.pe/wp-content/themes/ut23UzL5V_carequipa/images/logo.png" style="background-color:#002753" alt="Caja Arequipa" \>
                </td>
                </tr>
                </table>' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Te has afiliado correctamente a CAJA MOVIL / OPERACIONES POR INTERNET de Caja Arequipa.<br /><br />' ||
                '<hr>' ||
                '<table><tr class="style1"><td>Titular</td><td> </td><td>: ' ||
                ld_nomcli || '</td></tr>' ||
                '<tr class="style1"><td>Tarjeta de Debito</td><td> </td><td>: xxxx-xxxx-xxxx-' ||
                substr(p_numtar, LENGTH(p_numtar) - 3, LENGTH(p_numtar)) ||
                '</td></tr>' ||
                '<tr class="style1"><td>Fecha y hora</td><td> </td><td>: ' ||
                ld_fecha || '</td></tr>' ||
                '<tr class="style1"><td>Número de operación</td><td> </td><td>: ' ||
                ln_codope || '</td></tr>' ||
                '<tr class="style1"><td>Dispositivo</td><td> </td><td>: ' ||
                ls_nomdis || '</td></tr>' || '</table>' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Medios de Comunicación Directa (1):<br /><br />' ||
                '<hr>' ||
               
                '<table>' ||
                '<tr class="style1"><td>- Nro de Celular</td><td> </td><td>: ' ||
                ls_numcel || '</td></tr>' ||
                '<tr class="style1"><td>- Correo Electrónico: </td><td> </td><td>: ' ||
                ld_cordes || '</td></tr>' || '</table>';
      v_Body := v_Body || '</table>' || '<hr>' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Tipo de Servicio Seleccionado: CONSULTAS<br /><br />' ||
                '<hr>' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Nota 1: Los datos personales proporcionados serán utilizados de acuerdo a la autorización expresa pactada en el contrato de depósitos <br /><br />' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Si no has realizado esta operación o tienes cualquier duda respecto al servicio de Caja Movil/Operaciones por internet, puedes comunicarte con nosotros<br /><br />' ||
                '<br /><br />Caja Arequipa </p>'||
                '<br />__________________________________________________________________________________________________________________<br /><br />' ||
                '<br />El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja. <br />' ||
                '<br />Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje. <br />' ||
                '<br />Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.  <br /><br />';
    
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || --8bit
                          utl_tcp.crlf || utl_tcp.crlf || v_Body || CHR(13) ||
                          CHR(13) || CHR(13) || utl_tcp.crlf); --Message Body
      /*utl_smtp.write_data(V_Conexion,
      '-------SECBOUND' || utl_tcp.crlf ||
      --'Content-Type: text/plain;' || utl_tcp.crlf);--
       'Content-Type: text/plain; charset=iso-8859-1' ||
       utl_tcp.crlf);*/
    
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
    
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    END IF;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      --raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
      p_coderr := '80000';
    when no_data_found then
      p_coderr   := '00011';
      p_c_msgerr := 'NO HAY DATOS';
    when others then
      p_coderr   := '00099';
      p_c_msgerr := 'ERROR INTERNO';
    
  END sp_correo_afiliacion;

  procedure sp_correo_afiliacionD2(p_numtar   varchar2,
                                   p_codigo varchar2,
                                   p_coderr   out varchar2,
                                   p_c_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_correo_afiliacion
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Correo de Afiliaciones Caja Móvil
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
    v_From        VARCHAR2(80);
    v_Subject     VARCHAR2(200);
    v_Body        VARCHAR2(10000);
    C_SMTP_SERVER VARCHAR2(30);
    C_SMTP_PORT   VARCHAR2(4);
    V_Conexion    utl_smtp.Connection;
    msg           varchar2(32767);
    vhost_name    VARCHAR2(100);
    ld_fecha      date;
    ld_nomcli     varchar2(30);
    ld_cordes     varchar2(100);
    ls_nomdis     varchar2(100);
    ls_numtar     CHAR(19);
    ls_numcel     varchar2(10);
    ln_codope     number(9);
    ls_tipenvi    varchar2(100);
		v_found number;
		
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
    ls_tipenvi := '';
  
	SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);

--    if  UPPER(VHOST_NAME) in ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051')  then             
    --IF UPPER(VHOST_NAME) IN ('DSBD1051') THEN
      
			if v_found =1 then
			ls_numtar := p_numtar;
      select trim(tp1desc) tp1desc
        into C_SMTP_SERVER
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 1
         and tp1corr3 = 1;
    
      select trim(tp1desc) tp1desc
        into C_SMTP_PORT
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 2
         and tp1corr3 = 1;
    
      -- Datos de Afiliacion
    
      select to_date(jaqz205feafi || ' ' || jaqz205hoafi,
                     'DD/MM/YY hh24:mi:ss'),
             coalesce(jaqz205EMAIL, ''),
             coalesce(jaqz205aux1, ''),
             coalesce(jaqz205celul, '')
        into ld_fecha, ld_cordes, ls_nomdis, ls_numcel
        from jaqz205
       where jaqz205nutar = ls_numtar;
    
      select max(jaqz208SEINT)
        into ln_codope
        from jaqz208
       where jaqz208nutar = ls_numtar;
    
      select cli.penom
        into ld_nomcli
        from z0e478 pue
       inner join fsd001 cli
          on cli.pepais = pue.z0e478thp
         and cli.petdoc = pue.z0e478tht
         and cli.pendoc = pue.z0e478thd
       where pue.z0e478nro = ls_numtar;
       
       if p_codigo = '1' then
            ls_tipenvi:='SMS';
       end if;
       
       if p_codigo = '2' then
            ls_tipenvi:='Correo Electrónico';         
       end if;
      --v_From      := 'nbantotal@cajaarequipa.pe';
      v_From    := 'cajamovil@cajaarequipa.pe';
      v_Subject := 'ENVIO AUTOMATICO - CONSTANCIA DE AFILIACION- CAJA MOVIL / OPERACIONES POR INTERNET';
    
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, C_SMTP_PORT);
      msg        := 'Date: ' ||
                    to_char(ld_fecha, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                    utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                    'Subject: ' || v_Subject || utl_tcp.crlf || 'To: ' ||
                    ld_cordes || utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      utl_smtp.Rcpt(V_Conexion, ld_cordes);
    
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg); --date
      utl_smtp.write_data(V_Conexion, 'MIME-Version: 1.0' || utl_tcp.crlf); -- Use MIME mail standard
      utl_smtp.write_data(V_Conexion,
                          'Content-Type: multipart/mixed;' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' boundary=-----SECBOUND' || utl_tcp.crlf ||
                          utl_tcp.crlf);
    
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          'Content-Type: text/html;charset="iso-8859-1"' ||
                          utl_tcp.crlf);
      --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
    
      v_Body := '<head>    
                    <style type="text/css">
                        .style1
                        {
                            font-family: "Tahoma";
                            font-size: x-small;
                        }
                    </style>
                </head>
                <table style="width: 100%">
                <tr style="background-color:#002753; width:100%">
                    <td style="background-color:#002753; " class="style2">
                <img src="http://www.cajaarequipa.pe/wp-content/themes/ut23UzL5V_carequipa/images/logo.png" style="background-color:#002753" alt="Caja Arequipa" \>
                </td>
                </tr>
                </table>' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Te has afiliado correctamente a CAJA MOVIL/ OPERACIONES POR INTERNET de Caja Arequipa.<br /><br />' ||
                '<hr>' ||
                '<table><tr class="style1"><td>Titular</td><td> </td><td>: ' ||
                ld_nomcli || '</td></tr>' ||
                '<tr class="style1"><td>Tarjeta de Debito</td><td> </td><td>: xxxx-xxxx-xxxx-' ||
                substr(p_numtar, LENGTH(p_numtar) - 3, LENGTH(p_numtar)) ||
                '</td></tr>' ||
                '<tr class="style1"><td>Fecha y hora</td><td> </td><td>: ' ||
                ld_fecha || '</td></tr>' ||
                '<tr class="style1"><td>Número de operación</td><td> </td><td>: ' ||
                ln_codope || '</td></tr>' ||
                '<tr class="style1"><td>Dispositivo</td><td> </td><td>: ' ||
                ls_nomdis || '</td></tr>' || '</table>' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Medios de Comunicación Directa (1):<br /><br />' ||
                '<hr>' ||
               
                '<table>' ||
                '<tr class="style1"><td>- Nro de Celular</td><td> </td><td>: ' ||
                ls_numcel || '</td></tr>' ||
                '<tr class="style1"><td>- Correo Electrónico: </td><td> </td><td>: ' ||
                ld_cordes || '</td></tr>' || '</table>';
      v_Body := v_Body || '</table>' || '<hr>' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Tipo de Servicio Seleccionado: OPERACIONES (2)<br /><br />' ||
                '<br />  Medio de Autenticación de la Operación: '|| ls_tipenvi||' <br /><br />' ||
                '<hr>' ||
                '<p style="font-family: Tahoma;font-size: x-small;">' ||
                '<br />Nota 1: Los datos personales proporcionados serán utilizados de acuerdo a la autorización expresa pactada en el contrato de depósitos. <br /><br />' ||
                '<br />Nota 2: El cliente acepta y reconoce las operaciones realizadas con la Clave de Seguridad y el Código de Autenticado por el medio seleccionado.<br /><br />' ||
                '<br />Si no has realizado esta operación o tienes cualquier duda respecto al servicio de Caja Móvil, puedes comunicarte con nosotros <br /><br />' ||
                '<br /><br />Caja Arequipa </p>'||
                '<br />__________________________________________________________________________________________________________________<br /><br />' ||
                '<br />El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja. <br />' ||
                '<br />Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje. <br />' ||
                '<br />Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.  <br /><br />';


    
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || --8bit
                          utl_tcp.crlf || utl_tcp.crlf || v_Body || CHR(13) ||
                          CHR(13) || CHR(13) || utl_tcp.crlf); --Message Body
      /*utl_smtp.write_data(V_Conexion,
      '-------SECBOUND' || utl_tcp.crlf ||
      --'Content-Type: text/plain;' || utl_tcp.crlf);--
       'Content-Type: text/plain; charset=iso-8859-1' ||
       utl_tcp.crlf);*/
    
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
    
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    END IF;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      --raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);   
      p_coderr := '80000';
    when no_data_found then
      p_coderr   := '00011';
      p_c_msgerr := 'NO HAY DATOS';
    when others then
      p_coderr   := '00099';
      p_c_msgerr := 'ERROR INTERNO';
    
  END sp_correo_afiliacionD2;

end PQ_ENV_CORREO_BANCA_MOVIL;
/

