create or replace procedure sp_cl_valida_BN(P_N_TIPDAT IN NUMBER,
                                            P_C_VALDAT IN VARCHAR2,
                                            P_C_NUMDOC IN VARCHAR,
                                            P_D_FECPRO IN DATE,
                                            p_c_coderr out varchar2,
                                            p_c_msgerr out varchar2          
                                            ) is
  cursor c_mails is
  Select trim(a.tp1desc) mail
    from fst198 a
   where a.tp1cod = 1
     and a.tp1cod1 = 10825
     and a.tp1corr1 = 116
     and a.tp1corr2 = 3;
  
                                            
  lv_flag         varchar2(1):='N';     
  lc_coderr       varchar2(4000);
  lc_deserr       varchar2(4000); 
  lv_canal        varchar2(100);   
  lv_fecha        varchar2(50);  
  lv_hora         varchar2(20);   
  lv_tipo         varchar2(50);  
  lv_dato         varchar2(100); 
  lv_documento    varchar2(50);     
  lv_destinos     varchar2(400):= '';      
  lv_remitente    varchar2(100); 
  lv_asunto       varchar2(100);   
  lv_directorio   varchar2(100);    
  lv_archivo      varchar2(100);
  ll_mensaje      CLOB;
  lv_mensaje      VARCHAR2(32767);                     
begin
  p_c_coderr  := '000';
  lv_canal    := 'VENTANILLA'; 
  lv_fecha    := to_char(P_D_FECPRO,'dd/mm/rrrr'); 
  lv_hora     := to_char(sysdate,'HH24:mi:ss'); 
  if P_N_TIPDAT = 2 then
    lv_dato     := upper(trim(P_C_VALDAT)); 
  Else
    lv_dato     := TRIM(P_C_VALDAT); 
  End If;
  lv_documento:= P_C_NUMDOC; 
  lv_remitente:= 'AlertasFraude@cajaarequipa.pe'; 
  lv_asunto   := 'Posible fraude';
  lv_archivo  := '';

  begin    
   Select trim(a.tp1desc)
     into lv_tipo
     from fst198 a
    where a.tp1cod = 1
      and a.tp1cod1 = 10825
      and a.tp1corr1 = 116
      and a.tp1corr2 = 1
      and a.tp1nro1 = P_N_TIPDAT;
  exception
  when others then
    lv_tipo := null;
  end;

  begin
    Select 'S'
      into lv_flag
      from AQPA133 a
     where a.aqpa133tip = P_N_TIPDAT
       and a.aqpa133val = lv_dato
       and a.aqpa133est = 'S';
    if lv_flag = 'S' then
       p_c_coderr := '001';
       p_c_msgerr := 'Dato se encuentra registrado en Base Negativa';
    End If;
  exception
  when no_data_found then 
    p_c_coderr := '000';
    p_c_msgerr := '';     
  When Others then
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;
  end;
  --enviamos correo a prevención y fraude
  if lv_flag = 'S' then
    
     for j in c_mails loop
       lv_destinos  := lv_destinos||j.mail ||';';      
     End loop;
     if lv_destinos is not null then       
        lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);    
           
        dbms_lob.createtemporary(ll_mensaje, TRUE);              
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Por medio de la presente, se comunica el intento de registro/modificación del siguiente dato en BANTOTAL.</p>'; 
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                                  
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
        
        lv_mensaje := '<table cellspacing=0 cellpadding=2 width=450>';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);       
                        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Canal:'||'</td>'||
        '    <td align="left">'||lv_canal||'</td>'||
        '  </tr>                ';    
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);    
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
                  
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Fecha:'||'</td>'||
        '    <td align="left">'||lv_fecha||'</td>'||
        '  </tr>                ';       
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);              

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Hora:'||'</td>'||
        '    <td align="left">'||lv_hora||'</td>'||
        '  </tr>                ';       
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Tipo de dato:'||'</td>'||
        '    <td align="left">'||lv_tipo||'</td>'||
        '  </tr>                ';       
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Dato:'||'</td>'||
        '    <td align="left">'||lv_dato||'</td>'||
        '  </tr>                ';       
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                       

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Motivo:'||'</td>'||
        '    <td align="left">'||'MANTENIMIENTO DE DATOS'||'</td>'||
        '  </tr>                ';       
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);             

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Documento afectado:'||'</td>'||
        '    <td align="left">'||lv_documento||'</td>'||
        '  </tr>                ';       
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
                                    
        lv_mensaje := 
        '</table>';   
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
                                              
        lv_mensaje := 
        '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
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
                                           p_archivosadjuntos  => lv_archivo,
                                           p_c_coderr          => lc_coderr,
                                           p_c_deserr          => lc_deserr
                                           );

        end;
      End If;                
  End If;  
exception
when others then  
  p_c_coderr := sqlcode;
  p_c_msgerr := sqlerrm;
end sp_cl_valida_BN;
/

