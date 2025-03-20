create or replace procedure sp_genera_archivo(P_C_DIRECT IN VARCHAR2,
                                              P_C_NOMBRE IN VARCHAR2,
                                              P_N_NUMIMP IN NUMBER,
                                              p_c_coderr out varchar2,
                                              p_c_msgerr out varchar2
                                             ) is
    Cursor c_data is
    Select * 
      from aqpa118a a 
     where a.aqpa118aseq = P_N_NUMIMP order by 1,2;
     
   cursor c_datos is              
    select a.* 
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 98
  order by 1,2,3,4,5;
     
     
    v_archivo     UTL_FILE.FILE_TYPE; 
    Linea         varchar2(2000);   
    ln_cambia     NUMBER(9):=0;    

    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(90);  
    lv_asunto     VARCHAR2(90);   
    lv_directorio VARCHAR2(30);  
    lv_destinos   VARCHAR2(4000):='';    
    ln_cont       NUMBER(9):=0;    
    ln_activa     NUMBER(9):=0;
    ln_campos     NUMBER(9):=0;
    lv_archivo    VARCHAR2(40):='';
BEGIN
  
    --obtenemos los datos 
    lv_archivo    := trim(P_C_NOMBRE);
    lv_directorio := trim(P_C_DIRECT);
    For i in c_datos loop
      Case
         When i.tp1corr2 = 8 then
           lv_remitente  := lv_remitente || trim(i.tp1desc);
         When i.tp1corr2 = 7 then
           lv_asunto     := lv_asunto  ||  trim(i.tp1desc);
           ln_activa     := i.tp1nro1;
           ln_campos     := i.tp1nro2; 
         When i.tp1corr2 >=9 and i.tp1corr2 < 25 then 
             if ln_cambia = i.tp1corr2 or ln_cambia = 0 then
                lv_destinos := lv_destinos||trim(i.tp1desc);
             Else
                lv_destinos := lv_destinos||';';   
                lv_destinos := lv_destinos||trim(i.tp1desc);   
                ln_cont := ln_cont + 1;                        
             End If;        
             ln_cambia := i.tp1corr2;   
         Else
           null;
      End Case;
    End Loop;
    
    p_c_coderr := '000';
    v_archivo   := UTL_FILE.FOPEN(P_C_DIRECT,P_C_NOMBRE,'W');
    For i in c_data loop
      if i.aqpa118acor = 1 then
        Linea := Trim(i.aqpa118atpo)||';'||
                 Trim(i.aqpa118anro)||';'||
                 Trim(i.aqpa118aapa)||';'||
                 Trim(i.aqpa118anom)||';'||
                 Trim(i.aqpa118atel)||';'||
                 Trim(i.aqpa118amai)||';'||
                 Trim(i.aqpa118afec)||';'||
                 Trim(i.aqpa118aafp)||';'||
                 Trim(i.aqpa118acci)||';'||
                 Trim(i.aqpa118aubi)||';'||               
                 Trim(i.aqpa118arpt);
             if ln_campos = 1 then
                 Linea := Linea ||';'||Trim(i.aqpa118aax8)||';'||Trim(i.aqpa118aax9);
             End If;                   
      else
        Linea := Trim(i.aqpa118atpo)||';'||
                 Trim(i.aqpa118anro)||';'||
                 Trim(i.aqpa118aapa)||';'||
                 Trim(i.aqpa118anom)||';'||
                 Trim(i.aqpa118atel)||';'||
                 Trim(i.aqpa118amai)||';'||
                 Trim(i.aqpa118afec)||';'||
                 Trim(i.aqpa118aafp)||';'||
                 Trim(i.aqpa118acci)||';'||
                 Trim(i.aqpa118aubi)||';'||               
                 Trim(i.aqpa118arpt)||';';
             if ln_campos = 1 then
                 Linea := Linea ||Trim(i.aqpa118aax8)||';'||Trim(i.aqpa118aax9);
             End If;       
      end if;             
               UTL_FILE.PUT_LINE(v_archivo,Linea);          
    End Loop;
    UTL_FILE.FCLOSE(v_archivo);   
    
      if ln_cont >0 then
         lv_destinos := lv_destinos;      
         ln_cont := ln_cont + 1;        
      End if;      
      If  ln_cont >0 and  ln_activa > 0 then
        --Envia correo
        dbms_lob.createtemporary(ll_mensaje, TRUE);     
        if ln_cont > 1 then          
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados,</p>' ||  
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta el reporte con la columna Resultado completa.</p>';            
        Else
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado,</p>' ||            
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta el reporte con la columna Resultado completa.</p>';            
        End If;              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                            
                                   
        lv_mensaje := 
        '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
                          
        begin
        -- Call the procedure
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                         p_destinatarioscc   => 'jvisso@cajaarequipa.pe;jiparragu@cajaarequipa.pe;jyonz@cajaarequipa.pe',
                                         p_destinatariosbcc  => 'ylozada@cajaarequipa.pe',
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
        if p_c_coderr <> '000' then
           p_c_msgerr := 'No se pudo enviar correo-'||p_c_msgerr;
        End If;
      End If;
EXCEPTION
WHEN OTHERS THEN   
     p_c_coderr := sqlcode;
     p_c_msgerr := sqlerrm;
end sp_genera_archivo;
/

