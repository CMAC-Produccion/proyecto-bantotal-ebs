create or replace procedure sp_ah_notifica_expe(P_D_FECPRO IN DATE,
                                                P_C_NOMARC IN VARCHAR2,
                                                p_c_coderr out varchar2,
                                                p_c_msgerr out varchar2
                                                ) is
    -- *****************************************************************
    -- Nombre                     : sp_ah_notifica_expe
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.09.17
    -- Autor de Creación          : Yrving Lozada
    -- Uso                        : Envía correos a perfiles de experiencia al cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- *****************************************************************   
                                                    
    Cursor c_perfiles is
    Select a.* 
      from fst198 a 
     where a.TP1COD  = 1 
       and a.TP1COD1 = 10825 
       and a.tp1corr1 = 131 
       and a.tp1corr2 = 1;
       
    Cursor c_usuarios(lv_perfil in varchar2) is          
        select x.* 
          from PRFU00 x 
         where x.pgcod = 1 
           and x.prfgcod = rpad(trim(lv_perfil),10,' ');
       
       
    lv_destinos   varchar2(400) := '';
    lv_cc         varchar2(400) := '';
    lv_archivo    varchar2(50) := '';
    lv_asunto     varchar2(100);
    lv_directorio varchar2(100);
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);    
    lv_remitente  varchar2(100);     
    ln_cont       number(3):=0;
  begin
    p_c_coderr := '000';
  
    lv_archivo  := trim(P_C_NOMARC);  
    lv_directorio := 'DTPUMP_PR_EMAIL';
    lv_remitente  := 'procesosbantotal@cajaarequipa.pe';
    lv_asunto     := 'REPORTE ENVIO SMS APERTURA-RENOVACION-DESEMBOLSO';
          
    -- ARMADO DEL CUERPO   
    
      dbms_lob.createtemporary(ll_mensaje, TRUE);
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) Previo saludo,</p>' ||
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Adjuntamos el reporte del día '||to_char(P_D_FECPRO,'dd/mm/rrrr')||'</p>';               
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
          
    --DATOS PARA EL ENVIO DEL MAIL
    For i in c_perfiles loop
      ln_cont := ln_cont + 1;  
      For j in c_usuarios(i.tp1desc) loop
        lv_destinos:= lower(trim(j.ubuser))||'@cajaarequipa.pe';
        if trim(lv_destinos) is not null then
          --Enviamos el correo
          
          begin
            -- Call the procedure
            pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                             p_destinatarioscc   => lv_cc,
                                             p_destinatariosbcc  => '',
                                             p_mensaje           => ll_mensaje,
                                             p_remitente         => lv_remitente,
                                             p_asunto            => lv_asunto,
                                             p_tipomensaje       => 'HTML',
                                             p_directorio        => lv_directorio,
                                             p_archivosadjuntos  => lv_archivo,
                                             p_c_coderr          => p_c_coderr,
                                             p_c_deserr          => p_c_msgerr);
          exception
            when others then        
              p_c_coderr := '00x';
              p_c_msgerr := sqlerrm;
          end;
          
          if p_c_coderr = '000' then
             p_c_msgerr := 'ENVIO SATISFACTORIO';
          Else
            --REGISTRAMOS EL RENVIO
            PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 10,--RENVIO CORREO EXPERIENCIA AL CLIENTE
                                                      P_C_ASUNTO => lv_asunto,
                                                      P_C_DESPAR => lv_destinos,
                                                      P_C_DESCOC => NULL,
                                                      P_C_DESCCO => NULL,
                                                      P_C_MENSAJ => ll_mensaje,
                                                      P_C_REMITE => lv_remitente,
                                                      P_C_DIRECT => lv_directorio,
                                                      P_C_ADJUNT => lv_archivo,
                                                      P_N_AUX001 => NULL,
                                                      P_N_AUX002 => NULL,
                                                      P_N_AUX003 => NULL,
                                                      P_N_AUX004 => NULL,
                                                      P_D_AUX005 => P_D_FECPRO,
                                                      P_D_AUX006 => NULL,
                                                      P_C_AUX007 => NULL,
                                                      P_C_AUX008 => NULL,
                                                      P_C_AUX009 => NULL,
                                                      p_c_coderr => p_c_coderr,
                                                      p_c_msgerr => p_c_msgerr
                                                      ); 
            If p_c_coderr = '000' then                                                        
               p_c_msgerr := 'REGISTRO RE-ENVIO SATISFACTORIO';                                                                                
            End If;  
          End if;        
        End if; 
      End loop;
    End loop;
    if ln_cont = 0 then
       p_c_coderr := '001';
       p_c_msgerr := 'NO HAY PERFILES PARAMETRIZADOS PARA EL ENVIO'; 
    end if;
  dbms_lob.freetemporary(ll_mensaje);
exception
when others then
  p_c_coderr := sqlcode;
  p_c_msgerr := sqlerrm;
end sp_ah_notifica_expe;
/

