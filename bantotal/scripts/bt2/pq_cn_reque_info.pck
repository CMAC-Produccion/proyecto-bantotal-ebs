create or replace package PQ_CN_REQUE_INFO is
  procedure sp_envio_correo(pc_codreq IN VARCHAR2, pc_coderr OUT VARCHAR2, pc_msjerr OUT VARCHAR2);
end PQ_CN_REQUE_INFO;
/

create or replace package body PQ_CN_REQUE_INFO is procedure sp_envio_correo(pc_codreq IN VARCHAR2, pc_coderr OUT VARCHAR2, pc_msjerr OUT VARCHAR2) is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CN_REQUE_INFO
  -- Sistema               : BANTOTAL
  -- Módulo                : RECLAMOS
  -- Versión               : 1.0
  -- Fecha de Creación     : 26/12/2023
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Uso                   : Envio de constancia de requerimiento de informacion
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 
  -- Autor de Creación     : 
  -- Descripción Modific.  : 
  -- -------------------------------------------------------------------------------------------------
  
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);
  lc_remitente  VARCHAR2(50);
  lc_destinoscc VARCHAR2(50);
  lc_asunto     VARCHAR2(150);
  lc_directorio VARCHAR2(30);
  lc_destinos   VARCHAR2(32767) := '';
  lc_fecenvio   DATE;
  lc_horenvio   VARCHAR2(8);
  lc_correo     VARCHAR2(200);
  lc_nomarch    VARCHAR2(100);
  lc_codreq     VARCHAR2(20);
  ld_pgfape     DATE;
  
  begin
    lc_codreq := trim(pc_codreq);
    pc_coderr := '000';
    pc_msjerr := '';
    
    -- Obtener fecha de apertura
    begin
      select pgfape 
        into ld_pgfape 
        from fst017 
       where pgcod = 1;
    exception
      when others then
        null;
    end;
    
    -- Obtener email del cliente y nombre de archivo de constancia
    begin
      select jaqy290_reml, jaqy290nomarc 
        into lc_correo, lc_nomarch 
        from jaqy290_r 
       where jaqy290_rcod = lc_codreq;
    exception
      when others then
        pc_coderr := '32001';
        pc_msjerr := 'El registro no existe.';
        return;
    end;

    -- Obtener remitente envio de constancia
    begin
      select tp1desc into lc_remitente 
        from fst198 
       where tp1cod = 1 
         and tp1cod1 = 11159 
         and tp1corr1 = 10 
         and tp1corr2 = 5 
         and tp1corr3 = 2 
         and tp1nro1 = 1;
    exception
      when others then
        null;
    end;
    
    -- Obtener destinatario copia envio de constancia
    begin
      lc_destinoscc := '';
      for i in (
        select tp1desc 
          from fst198 
         where tp1cod = 1 
           and tp1cod1 = 11159 
           and tp1corr1 = 10 
           and tp1corr2 > 6 
           and tp1corr3 = 3 
           and tp1nro1 = 1
      ) loop
        lc_destinoscc := Trim(lc_destinoscc) || Trim(i.tp1desc);
      end loop;
    exception
      when others then
        null;
    end;
           
    lc_fecenvio := ld_pgfape;
    lc_horenvio := trim(to_char(sysdate, 'HH24:MI:SS'));    
    lc_destinos := lc_correo;
    lc_asunto := 'Conoce el estado de tu requerimiento con código ' || lc_codreq;
    lc_directorio:= 'DTPUMP_PR_EMAIL_DIG';
    dbms_lob.createtemporary(ll_mensaje, true);
    lv_mensaje :=
    '<div>' ||
        '<div style="margin:0;padding:0;">' ||
            '<table width="460" align="center" border="0" cellspacing="0" style="width:460px;">' ||
                '<tbody>' ||
                    '<tr height="14" style="height:14px;background-color:#0A3FA8;">' ||
                        '<td colspan="4"></td>' ||
                    '</tr>' ||
                    '<tr height="32" style="height:32px;background-color:#0A3FA8;">' ||
                        '<td width="17" style="width:17px;"></td>' ||
                        '<td><img src="https://i.ibb.co/1d8SXQr/logo.png" width="77" height="32"></td>' ||
                        '<td width="120" style="width:120px;"></td>' ||
                        '<td>' ||
                            '<font face="sans-serif" size="1" color="#BFDBFE" style="font-family: sans-serif, serif, EmojiFont;"><span style="font-size:10px;"><b>Código de requerimiento: </b></span></font>' ||
                            '<font face="sans-serif" size="1" color="#BFDBFE" style="font-family: sans-serif, serif, EmojiFont;"><span style="font-size:10px;"><b>' || lc_codreq || ' </b></span></font>' ||
                        '</td>' ||
                    '</tr>' ||
                    '<tr height="14" style="height:14px;background-color:#0A3FA8;">' ||
                        '<td colspan="4"></td>' ||
                    '</tr>' ||
                '</tbody>' ||
            '</table>' ||
            '<table width="460" align="center" border="0" cellspacing="0" style="width:460px;">' ||
                '<tbody>' ||
                    '<tr>' ||
                        '<td><img src="https://i.ibb.co/f9xvBt1/mail-reclamo.png" width="460" height="177"></td>' ||
                    '</tr>' ||
                '</tbody>' ||
            '</table>' ||
            '<table width="355" align="center" border="0" cellspacing="0" style="width:355px;background-color:white;">' ||
                '<tbody>' ||
                    '<tr>' ||
                        '<td><img src="https://i.ibb.co/7VT1k20/Recibido.png" width="355" height="206"></td>' ||
                    '</tr>' ||
                '</tbody>' ||
            '</table>' ||
            '<br>' ||
            '<br>' ||
            '<span style="font-family:Calibri; font-size:14.5px">Por favor no respondas sobre este correo</span>' ||
            '<br>' ||
            '<br>' ||
            '<font face="Calibri" size="1" style="font-family: Calibri;"><span style="font-size:14.5px;">Saludos Cordiales</span></font>' ||
            '<br>' ||
            '<font face="Calibri" size="1" color="#052A6E" style="font-family: Calibri;"><span style="font-size:16.5px;"><b>CAJA AREQUIPA</b></span></font>' ||
        '</div>' ||
    '</div>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      begin
        -- Call the procedure
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => lc_destinos,
                                         p_destinatarioscc   => lc_destinoscc,
                                         p_destinatariosbcc  => '',
                                         p_mensaje           => ll_mensaje,
                                         p_remitente         => lc_remitente,
                                         p_asunto            => lc_asunto,
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => lc_directorio,
                                         p_archivosadjuntos  => lc_nomarch,
                                         p_c_coderr          => pc_coderr,
                                         p_c_deserr          => pc_msjerr
                                        );
          if pc_coderr = '000' then
            pc_msjerr := 'Envio Satisfactorio';
            update jaqy290_r set jaqy290rptenv = pc_msjerr, jaqy290fecenv = lc_fecenvio, jaqy290horenv = lc_horenvio where jaqy290_rcod = lc_codreq;
            commit;
          end if;
                              
      exception
        when others then
           pc_coderr := '00x';
           pc_msjerr := sqlerrm;
      end;
      dbms_lob.freetemporary(ll_mensaje);
                                   
  end sp_envio_correo;
  
end PQ_CN_REQUE_INFO;
/

