create or replace procedure SP_AH_CORREO_LEGAL(N_DOC in VARCHAR2,
                                               N_RUC IN VARCHAR2,
                                               T_OBS IN VARCHAR2,
                                               V_USU in VARCHAR2) is
   correo     varchar2(50):= null; 
   correo1    varchar2(50):= null;    
   ll_mensaje clob;    
   lv_mensaje VARCHAR2(32767);
   lv_motivo  varchar2(100) := 'Registro de Poderes';
   l_crlf     char(2) := Chr(13)||Chr(10);---chr(10)||chr(13);                                                                                      
   V_numdoc   varchar2(30):= null;                                        
   lc_usuario char(10):= null;
   rsocial    char(100):= null;
   nombreusuario char(30) := null;      
   Mensaje    clob;
   lc_coderr varchar2(400):= null;
   lc_deserr varchar2(400):= null;
   
begin
  
  v_numdoc := n_doc||'.pdf';
  
 -- lc_usuario := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);  
    LC_USUARIO := TRIM(V_USU);
    dbms_lob.createtemporary(ll_mensaje, TRUE);
  Begin
    select ubnom
      into nombreusuario
      from fst746
     where ubuser = LC_USUARIO;
  Exception
    when no_data_found then
        nombreusuario:= null;
  end;
  
  SELECT Trim(jaqy690mail), 
         trim(jaqy690aux7),
         jaqy690aux6
    into correo,
         correo1,
         rsocial
    FROM JAQY690 
   WHERE jaqy690arch = v_numdoc
     AND JAQY690NRUC = N_RUC 
     AND JAQY690ESTA IN('D','P');
     
  UPDATE JAQY690
     SET JAQY690ESTA ='P',
         JAQY690FECP = SYSDATE,
         jaqy690horp = to_char(sysdate,'HH24:MI:SS') ,
         jaqy690usup = LC_USUARIO
   WHERE jaqy690arch = v_numdoc
     AND JAQY690NRUC = N_RUC 
     AND JAQY690ESTA ='D';
   COMMIT;      



   /*  lv_mensaje := 'Estimado(a)'|| l_crlf;
     lv_mensaje := lv_mensaje|| l_crlf;
     lv_mensaje := lv_mensaje ||'Existe observaciones para la persona jurídica:  '||rsocial||l_crlf;    
     lv_mensaje := lv_mensaje ||'con número de documento: '||N_RUC||' '||'y son:'||l_crlf;    
     lv_mensaje := lv_mensaje ||l_crlf;   
     lv_mensaje := lv_mensaje ||T_OBS||l_crlf;   
     lv_mensaje := lv_mensaje ||l_crlf;   
     lv_mensaje := lv_mensaje ||l_crlf;   
     lv_mensaje := lv_mensaje ||'Usuario del Registro:'||lc_usuario||'  '||nombreusuario ||l_crlf;   --||' '||'Asesoria Legal'
     lv_mensaje := lv_mensaje ||'Asesoria Legal'||l_crlf;    
     lv_mensaje := lv_mensaje ||'Atentamente'|| l_crlf;
     lv_mensaje := lv_mensaje ||l_crlf;       
     lv_mensaje := lv_mensaje ||'Caja Arequipa'|| l_crlf;
 --    lv_mensaje := trim(lv_mensaje); 
--      mensaje := lv_mensaje;

       if correo is not null then
	      
         sys.SP_SY_ENVIAMAIL(pc_aquien => Correo,--- sys.sp_sy_enviamail_html_silvia ---sys.sp_sy_enviamail_html
                                      pc_de => 'notificacionesbantotal@cajaarequipa.pe',--'bsanchez@cajaarequipa.pe',
                                      pc_motivo => lv_motivo,
                                      pc_mensaje => lv_mensaje-- ll_mensaje  mensaje --
                                      );---                                
       end if;  
       if correo1 is not null then	      
           sys.SP_SY_ENVIAMAIL(pc_aquien => Correo1,--- sys.sp_sy_enviamail_html_silvia ---sys.sp_sy_enviamail_html
                                      pc_de => 'notificacionesbantotal@cajaarequipa.pe',--'bsanchez@cajaarequipa.pe',
                                      pc_motivo => lv_motivo,
                                      pc_mensaje => lv_mensaje --mensaje--lv_mensaje-- ll_mensaje
                                      );---                                
       end if;  */
       lv_mensaje :=            
            '<p style="font-family:''Verdana'', Courier, monospace;  font-size:13px"> Estimado(a):  </p>' ||
            '<p style="font-family:''Verdana'', Courier, monospace;  font-size:13px"> Existe observaciones para la persona jurídica:  '|| rsocial || 'con numero de documento  '|| N_RUC || '  y son:  </p>' ||
            '<p style="font-family:''Verdana'', Courier, monospace;  font-size:13px">  </p>' ||
            '<p style="font-family:''Verdana'', Courier, monospace;  font-size:13px; color:red"> '|| T_OBS|| '</p>' ||
            '<p style="font-family:''Verdana'', Courier, monospace;  font-size:13px">  </p>' ||
            '<p style="font-family:''Verdana'', Courier, monospace;  font-size:13px"> Asesoria Legal </p>' ||
            '<p style="font-family:''Verdana'', Courier, monospace;  font-size:13px"> Atentamente </p>' ||
            '<p style="font-family:''Verdana'', Courier, monospace;  font-size:13px"> CAJA AREQUIPA </p>';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
       BEGIN
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(correo),
                                           p_destinatarioscc   => trim(correo1),
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => ll_mensaje,
                                           p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                           p_asunto            => lv_motivo,--'Alerta de Declaracion Jurada Anual'||i.jaqz574year,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => '',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr          => lc_coderr,
                                           p_c_deserr          => lc_deserr
                                           );
       exception
         when others then
           
          UPDATE JAQY690
             SET jaqy690aux5 = substr(lc_deserr,1,50)
           WHERE jaqy690arch = v_numdoc
             AND JAQY690NRUC = N_RUC;
          commit;   
       END;
               
       
Exception
  When no_data_found then
    null;  
  
end SP_AH_CORREO_LEGAL;
/

