create or replace procedure sp_cl_mail_bloqueo_tarjeta(P_N_CODPAI IN NUMBER,
                                                       P_N_TIPDOC IN NUMBER,
                                                       P_C_NUMDOC IN VARCHAR2,
                                                       P_C_NUMTAR IN VARCHAR2,
                                                       p_c_coderr out varchar2,
                                                       p_c_deserr out varchar2
                                                       ) is
       
  cursor c_mails(ln_pais in number, ln_tipo in number, lc_numero in char)        is
   select trim(substr(y.pextxt,1,instr(y.pextxt,'\')-1)) mail
     from fsx001 y
    where y.pepais = ln_pais
      and y.petdoc = ln_tipo
      and y.pendoc = rpad(lc_numero,12,' ')
      and y.txcod  = 0
      and trim(y.pextxt) is not null
      and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(y.pextxt,1,instr(y.pextxt,'\')-1))) = 'S';                     
      
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(50);  
    lv_asunto     VARCHAR2(50);  
    lv_directorio VARCHAR2(50);  
    lv_archivos   VARCHAR2(50);      
    lv_destinos   VARCHAR2(4000):='';  
    ln_cont2      NUMBER(9):=0;
    lv_nombre     VARCHAR2(40);
    ld_fecha      date;
    lv_tarjeta    VARCHAR2(16);
  begin
    p_c_coderr := '000';   
      
    --Obtenemos datos para el envio

    lv_remitente  := 'notificacionessms@cajaarequipa.pe';
    lv_asunto     := 'Bloqueo de Tarjeta';
    lv_directorio := 'DTPUMP_PR_EMAIL_DIG';
     
    lv_destinos := '';     

    For k in c_mails(P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC) loop            
       ln_cont2 := ln_cont2 + 1;  
       lv_destinos := lv_destinos||trim(k.mail)||';';   
    End loop;  
    lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
                
    if ln_cont2 > 0 then
           --obtenemos el nombre del cliente
           begin
             Select trim(b.pfnom1)
               into lv_nombre
               from FSD002 B
              where b.pfpais = P_N_CODPAI  
                and b.pftdoc = P_N_TIPDOC
                and b.pfndoc = rpad(P_C_NUMDOC,12,' ');             
           exception
           when others then
             lv_nombre := null;
           end;      
                   
           ld_fecha := trunc(sysdate);
           lv_tarjeta := substr(trim(P_C_NUMTAR),1,6)||'******'||substr(trim(P_C_NUMTAR),13,4);                   

           dbms_lob.createtemporary(ll_mensaje, TRUE);              
           lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Hola '||lv_nombre|| '</p>' ||  
                         '<p "font-family: Arial, sans-serif; font-size: 14px;">Te comunicamos que con fecha '||to_char(ld_fecha,'dd/mm/rrrr')||' procesamos tu solicitud y tu tarjeta '||lv_tarjeta||' ha sido bloqueada con &eacute;xito.</p>';  
           dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
           lv_mensaje := '
                          <table width="1000" height="54" border="0">
                            <tbody>
                              <tr>
                              <td "font-family: Arial, sans-serif; font-size: 14px;" width="15" colspan="2" height="23"><p>Para tramitar una nueva tarjeta, s&oacute;lo sigue los siguientes pasos:</p></td>      
                              </tr>    
                              <tr>
                                <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">1. <a href="https://www.cajaarequipa.pe/agencias/" >Ac&eacute;rcate a cualquiera de nuestras agencias a nivel nacional portando tu DNI</a></td>
                              </tr>                                  
                              <tr>
                                <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">2.	Solicita el duplicado de tarjeta en ventanilla/plataforma</td>
                              </tr>
                              <tr>
                                <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">3.	<a href="https://www.cajaarequipa.pe/tarifario-de-comisiones-por-productos-pasivos/" >Realiza el pago de la comisi&oacute;n correspondiente</a></td>
                              </tr>
                            </tbody>
                          </table>';               
           dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
                 
           lv_mensaje := 
           '<p "font-family: Arial, sans-serif; font-size: 14px;">&iexcl;Te esperamos&#33;<br/>Caja Arequipa<br/>Impulsando tu bienestar</p>';                                          
           dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
                                   
        begin
          p_c_coderr := '000';
          lv_archivos := 'Informacion de tu Tarjeta de Debito.pdf';
                
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
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
              exception
              when others then  
                   p_c_coderr := '00x';
                   p_c_deserr := sqlerrm;                                                   
              end;
                                                 
              if p_c_coderr = '000' then
                 p_c_deserr := 'Envio Satisfactorio';                         
              End If;            
        exception
        when others then                                                                                  
          p_c_coderr := '00x';
          p_c_deserr := sqlerrm;        
        end;  
        dbms_lob.freetemporary(ll_mensaje);        
    Else --no tiene contactos       
         p_c_coderr := '00z';
         p_c_deserr := 'No existe email destino para enviar correo';        
    End If;  
  exception 
  when others then  
    p_c_coderr := '00x';
    p_c_deserr := sqlerrm;
end sp_cl_mail_bloqueo_tarjeta;
/

