create or replace procedure sp_envia_archivo_CTS(P_C_DIRECT  IN VARCHAR2,
                                                 P_C_NOMBRE  IN VARCHAR2,    
                                                 P_D_FECPRO  IN DATE, 
                                                 P_C_CODUSU  IN VARCHAR2,
                                                 P_N_NUMREG  IN NUMBER,
                                                 P_C_CODIGO  IN VARCHAR2,
                                                 P_C_MENSAJE IN VARCHAR2,                                             
                                                 p_c_coderr out varchar2,
                                                 p_c_msgerr out varchar2
                                                ) is

   --Datos destinatarios  
   cursor c_datos is              
    select a.* 
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 99
  order by 1,2,3,4,5;
  
   --Datos procesos centrales  
   cursor c_datos2 is                 
    select a.*
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 72
       and a.Tp1corr2 = 5;   
     
    ln_cambia     NUMBER(9):=0;    

    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(90);  
    lv_asunto     VARCHAR2(90);   
    lv_directorio VARCHAR2(30);  
    lv_destinos   VARCHAR2(4000):='';    
    ln_cont       NUMBER(9):=0;    
    lv_archivo    VARCHAR2(40):='';
    lv_motivo1    VARCHAR2(400):='';
    lv_motivo2    VARCHAR2(400):='';     
    l_bfile       BFILE;
    l_blob        BLOB;
    ln_numsec     number(9):=0;
BEGIN
    p_c_coderr := '000';    
    --envio de mail
    --obtenemos los datos 
    lv_archivo    := trim(P_C_NOMBRE);
    lv_directorio := trim(P_C_DIRECT);
    For i in c_datos loop
      Case
         When i.tp1corr2 = 1 then
           lv_remitente  := lv_remitente || trim(i.tp1desc);
         When i.tp1corr2 = 2 then
           lv_asunto     := lv_asunto  ||  trim(i.tp1desc);
         When i.tp1corr2 >=3 then 
             if ln_cambia = i.tp1corr2 or ln_cambia = 0 then
                lv_destinos := lv_destinos||trim(i.tp1desc);
             Else
                lv_destinos := lv_destinos||';';   
                lv_destinos := lv_destinos||trim(i.tp1desc);                          
             End If;        
             ln_cambia := i.tp1corr2;  
             ln_cont := ln_cont + 1;  
         Else
           null;
      End Case;
    End Loop;
    
      If  ln_cont >0  then
        --Envia correo
        dbms_lob.createtemporary(ll_mensaje, TRUE);        
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados Se&ntilde;ores,</p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">En adjunto se env&iacute;a archivo con detalle de clientes, 
                      cuyas cuentas han recibido dep&oacute;sito el d&iacute;a '||to_char(P_D_FECPRO,'dd/mm/rrrr')||', para su procesamiento y entrega 
                      de comunicaci&oacute;n, seg&uacute;n normativa.</p>';            
            
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
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_msgerr
                                         );
        exception
        when others then  
             p_c_coderr := '00x';
             p_c_msgerr := sqlerrm;                                                   
        end;
        dbms_lob.freetemporary(ll_mensaje);              

      End If;
      If p_c_coderr = '000' then
        lv_motivo2 := 'ENVIO SATISFATORIO';
        p_c_msgerr := lv_motivo2;
      Else
        lv_motivo2 := 'NO SE PUDO ENVIAR CORREO';
      End if;
      --registrar en la tabla AQPA119 el archivo y los datos de proceso y de envio 
      begin
        insert into AQPA119(aqpa119seq, 
                            aqpa119fep, 
                            aqpa119hrp,
                            aqpa119esp, 
                            aqpa119msp, 
                            aqpa119fev, 
                            aqpa119hrv, 
                            aqpa119des, 
                            aqpa119esv, 
                            aqpa119msv, 
                            aqpa119usr, 
                            aqpa119arc                                                                                
                            )
                     values(SQ_AH_ID_LOGCTS.NEXTVAL,
                            P_D_FECPRO,
                            to_char(sysdate,'hh24:mi:ss'),
                            decode(trim(P_C_CODIGO),'000','S','N'),
                            P_C_MENSAJE,
                            P_D_FECPRO,
                            to_char(sysdate,'hh24:mi:ss'),
                            lv_destinos,
                            decode(p_c_coderr,'000','S','N'),
                            p_c_msgerr,                          
                            P_C_CODUSU,
                            EMPTY_BLOB()
                            )
                            RETURN aqpa119arc INTO l_blob;                          
                            
          l_bfile := BFILENAME(lv_directorio, lv_archivo);
          DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
          DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
          DBMS_LOB.fileclose(l_bfile);
          COMMIT;                                
                  
        p_c_coderr := '000';
        p_c_msgerr := '';      
      Exception
      When others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
      end;
    --correo para procesos centrales
    ln_cont := 0;  
    lv_destinos :='';
    ln_cambia := 0;
    For i in c_datos2 loop
      Case
         When i.tp1corr2 >=5 then 
             if ln_cambia = i.tp1corr2 or ln_cambia = 0 then
                lv_destinos := lv_destinos||trim(i.tp1desc);
             Else
                lv_destinos := lv_destinos||';';   
                lv_destinos := lv_destinos||trim(i.tp1desc);                          
             End If;        
             ln_cambia := i.tp1corr3;  
             ln_cont := ln_cont + 1;  
         Else
           null;
      End Case;
    End Loop;    
         
      If  ln_cont >0  then
        --Envia correo
        lv_motivo1 := P_C_MENSAJE;

        dbms_lob.createtemporary(ll_mensaje, TRUE);        
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados</p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Se proces&oacute; el detalle de clientes, 
                      cuyas cuentas han recibido dep&oacute;sito el d&iacute;a '||to_char(P_D_FECPRO,'dd/mm/rrrr')||', con el siguiente resultado:</p>';            
            
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                            
                            
        lv_mensaje := '
                      <table width="830" height="54" border="0">
                        <tbody>
                          <tr>
                          <td "font-family: Arial, sans-serif; font-size: 14px;" width="15" colspan="2" height="23"><p><strong>Detalles:</strong>:</p></td>      
                          </tr>	  
                                              
                          <tr>
                            <td width="15" height="23"><strong></strong></td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Resultado del proceso: '||lv_motivo1||' - '||trim(to_char(P_N_NUMREG))||' registros procesados'||'.</td>
                          </tr>
                          <tr>
                            <td width="15" height="23"><strong></strong></td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Resultado del env&iacute;o del correo: '||lv_motivo2||'.</td>
                          </tr>                                
                        </tbody>
                      </table>';               
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
                                         p_directorio        => '',
                                         p_archivosadjuntos  => '',
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_msgerr
                                         );
        exception
        when others then  
             p_c_coderr := '00x';
             p_c_msgerr := sqlerrm;                                                   
        end;
              
        If p_c_coderr = '000' then
           lv_motivo2 := 'ENVIO SATISFATORIO';
        Else
           lv_motivo2 := p_c_msgerr;
        End if;                                
      End If;  
      --registrar en la tabla AQPA119a el log de envío de correo a procesos centrales
      select SQ_AH_ID_LOGCTS.CURRVAL into ln_numsec from dual;
      begin
        insert into AQPA119A(aqpa119aseq,
                             aqpa119afev,
                             aqpa119ahrv,
                             aqpa119amsv,
                             aqpa119ades,
                             aqpa119aesv,
                             aqpa119ausr,
                             aqpa119acue                             
                             )
                     values(ln_numsec,
                            trunc(sysdate),
                            to_char(sysdate,'hh24:mi:ss'),
                            lv_motivo2,
                            lv_destinos,
                            decode(p_c_coderr,'000','S','N'),                            
                            P_C_CODUSU,
                            ll_mensaje
                            );
        COMMIT;                                                  
        p_c_coderr := '000';
        p_c_msgerr := '';      
      Exception
      When others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
      end;
      dbms_lob.freetemporary(ll_mensaje);      
EXCEPTION
WHEN OTHERS THEN   
     p_c_coderr := sqlcode;
     p_c_msgerr := sqlerrm;
end sp_envia_archivo_CTS;
/

