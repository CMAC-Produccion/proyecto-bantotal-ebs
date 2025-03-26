create or replace package PQ_CN_RECLAMOS is
  procedure sp_envio_correo(pc_codrec IN VARCHAR2, pc_coderr OUT VARCHAR2, pc_msjerr OUT VARCHAR2);
end PQ_CN_RECLAMOS;
/
create or replace package body PQ_CN_RECLAMOS is procedure sp_envio_correo(pc_codrec IN VARCHAR2, pc_coderr OUT VARCHAR2, pc_msjerr OUT VARCHAR2) is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CN_RECLAMOS
  -- Sistema               : BANTOTAL
  -- Módulo                : RECLAMOS
  -- Versión               : 1.0
  -- Fecha de Creación     : 26/12/2023
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Uso                   : Envio de constancia de registro de reclamo por la web
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 25/03/2025
  -- Autor de Modificación : Renzo Cuadros Salazar
  -- Descripción Modific.  : Se agrego funcionalidad de reenvio de correo
  -- Fecha de Modificación : 
  -- Autor de Modificación : 
  -- Descripción Modific.  :   
  -- ------------------------------------------------------------------------------------------------

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
  lc_codrec     VARCHAR2(20);
  ld_pgfape     DATE;
  ln_tiprec     NUMBER;
  lc_tiprec     VARCHAR2(15);
  
  begin
    lc_codrec := trim(pc_codrec);
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
      select jaql420eml, jaql420nomarc, jaql420trc 
        into lc_correo, lc_nomarch, ln_tiprec 
        from jaql420 
       where jaql420cod = lc_codrec;
    exception
      when others then
        pc_coderr := '32501';
        pc_msjerr := 'El registro no existe.';
        return;
    end;
    
    -- Obtener remitente envio de constancia
    begin
      select tp1desc into lc_remitente 
        from fst198 
       where tp1cod = 1 
         and tp1cod1 = 11159 
         and tp1corr1 = 11 
         and tp1corr2 = 2 
         and tp1corr3 = 1 
         and tp1nro1 = 1;
    exception
      when others then
        null;
    end;
    
    -- Obtener remitente envio de constancia
    begin
      select tp1desc into lc_destinoscc 
        from fst198 
       where tp1cod = 1 
         and tp1cod1 = 11159 
         and tp1corr1 = 11 
         and tp1corr2 = 4 
         and tp1corr3 = 2 
         and tp1nro1 = 1;
    exception
      when others then
        null;
    end;
    
    lc_fecenvio := ld_pgfape;
    lc_horenvio := trim(to_char(sysdate, 'HH24:MI:SS'));
    lc_destinos := lc_correo;
    
    if ln_tiprec = 1 then
      lc_tiprec := 'reclamo';
    else
      lc_tiprec := 'queja';
    end if;
    
    lc_asunto := 'Conoce el estado de tu ' || lc_tiprec || ' con código ' || lc_codrec;
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
                            '<font face="sans-serif" size="1" color="#BFDBFE" style="font-family: sans-serif, serif, EmojiFont;"><span style="font-size:10px;"><b>Código de ' || lc_tiprec || ': </b></span></font>' ||
                            '<font face="sans-serif" size="1" color="#BFDBFE" style="font-family: sans-serif, serif, EmojiFont;"><span style="font-size:10px;"><b>' || lc_codrec || ' </b></span></font>' ||
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
            update jaql420 set jaql420rptenv = pc_msjerr, jaql420fecenv = lc_fecenvio, jaql420horenv = lc_horenvio where jaql420cod = lc_codrec;
            commit;
          end if;
      exception
        when others then
            pc_coderr := '993';
            pc_msjerr := 'Se reenviara el correo en el transcurso del dia...';
            begin
                insert into aqpa145(aqpa145cor,
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
                values(SQ_AH_ID_RENVIO_MAIL.NEXTVAL,
                       991,
                       TRUNC(SYSDATE),
                       TO_CHAR(SYSDATE,'HH24:MI:SS'),
                       lc_asunto,
                       lc_destinos,
                       lc_destinoscc,
                       '',
                       ll_mensaje,
                       lc_remitente,
                       lc_directorio,
                       lc_nomarch,
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
                      commit;
            exception
              when others then
                rollback;
                pc_coderr := '992';
                pc_msjerr := sqlerrm;
            end;
      end;
      dbms_lob.freetemporary(ll_mensaje);
                                   
  end sp_envio_correo;
  
end PQ_CN_RECLAMOS;
/
