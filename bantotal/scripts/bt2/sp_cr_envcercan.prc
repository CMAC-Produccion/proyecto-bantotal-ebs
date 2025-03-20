CREATE OR REPLACE PROCEDURE sp_cr_envcercan(P_D_FECPRO IN DATE,
                                             P_N_CODSUC IN NUMBER,
                                             P_D_FECINI IN DATE,
                                             P_D_FECFIN IN DATE,      
                                             P_C_NOMARC IN VARCHAR2,
                                             P_C_MAIDES IN VARCHAR2,                           
                                             p_c_coderr out varchar2,
                                             p_c_msgerr out varchar2) is                                                       
  
  lv_destinos     varchar2(400):= '';     
  lv_archivo      varchar2(40) := '';  
  lv_remitente    varchar2(100); 
  lv_asunto       varchar2(100); 
  lv_estado       CHAR(1);
  lv_directorio   varchar2(100);    
  ll_mensaje      CLOB;
  lv_mensaje      VARCHAR2(32767);  
  l_bfile         BFILE;
  l_blob          BLOB;                                         
  lv_indenv       char(1):='N';
  lc_usrori       char(10);
  lc_usrsup       char(10); 
  begin      
  p_c_coderr := '000';                               
              
  lv_archivo := trim(P_C_NOMARC);
  lv_destinos := ''; 
           
  lv_directorio:= 'DTPUMP_PR_EMAIL';
  lv_remitente := 'procesosbantotal@cajaarequipa.pe';
  lv_asunto    := 'Comunicacion Certificado de No Adeudo';
  -- ARMADO DEL CUERPO        
  dbms_lob.createtemporary(ll_mensaje, TRUE);              
  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) Cliente</p>' ||  
               '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta archivo PDF Certificado de no adeudo.</p>';          
  lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
  lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';                                          
  lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
  
  lv_destinos := lower(P_C_MAIDES);               
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
                                      p_c_coderr          => p_c_coderr,
                                      p_c_deserr          => p_c_msgerr);
  exception
  when others then  
     p_c_coderr := '00x';
     p_c_msgerr := sqlerrm;                                                   
  end; 
  if p_c_coderr = '000' then
     lv_estado  := 'S';
     p_c_msgerr := 'ENVIO SATISFACTORIO';
  Else
     lv_estado := 'N';
  End If; 
/*begin
     insert into aqpa122b(aqpa122bfec,
                          aqpa122bsuc,
                          aqpa122bfin,
                          aqpa122bffi,
                          aqpa122bust,
                          aqpa122buss,
                          aqpa122bhor,
                          aqpa122best,
                          aqpa122bmsg,
                          aqpa122bnom,
                          aqpa122barc,
                          aqpa122bcue) 
                  values (P_D_FECPRO,
                          P_N_CODSUC,
                          P_D_FECINI,
                          P_D_FECFIN,
                          lc_usrori,
                          lc_usrsup,                                
                          TO_CHAR(SYSDATE,'hh24:mi:ss'),
                          lv_estado,
                          p_c_msgerr,
                          lv_archivo,
                          EMPTY_BLOB(),
                          ll_mensaje)
                   RETURN aqpa122barc INTO l_blob;
        l_bfile := BFILENAME(lv_directorio, lv_archivo);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);    
        commit;                           
      exception
      when dup_val_on_index then
        delete from aqpa122b a
         where a.aqpa122bfec = P_D_FECPRO
           and a.aqpa122bsuc = P_N_CODSUC;
           commit;
            begin
               insert into aqpa122b(aqpa122bfec,
                                    aqpa122bsuc,
                                    aqpa122bfin,
                                    aqpa122bffi,
                                    aqpa122bust,
                                    aqpa122buss,
                                    aqpa122bhor,
                                    aqpa122best,
                                    aqpa122bmsg,
                                    aqpa122bnom,
                                    aqpa122barc,
                                    aqpa122bcue)
                             values (P_D_FECPRO,
                                    P_N_CODSUC,
                                    P_D_FECINI,
                                    P_D_FECFIN,
                                    lc_usrori,
                                    lc_usrsup,                                  
                                    TO_CHAR(SYSDATE,'hh24:mi:ss'),
                                    lv_estado,
                                    p_c_msgerr,
                                    lv_archivo,
                                    EMPTY_BLOB(),
                                    ll_mensaje)
                             RETURN aqpa122barc INTO l_blob;
              l_bfile := BFILENAME(lv_directorio, lv_archivo);
              DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
              DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
              DBMS_LOB.fileclose(l_bfile);    
              commit;                           
            exception
            when others then
               p_c_coderr := sqlcode;
               p_c_msgerr := sqlerrm;          
            end;       
      when others then
         p_c_coderr := sqlcode;
         p_c_msgerr := sqlerrm;          
      end; 
  dbms_lob.freetemporary(ll_mensaje);                  
  exception
  when others then  
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;*/      
  
end sp_cr_envcercan;
/

