create or replace package pq_cr_excel_mail_devenga is

  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS DEVENGADOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.04.05
  -- Autor de Creación          : RCASTRO
  -- Uso                        : Automatización de reporte de devengados
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  --
  --
  -- *****************************************************************
  -----------------------------------------------------------------------
  
  procedure sp_cr_obtenerdatos(fechaIngreso in date);
  
  -----------------------------------------------------------------------
  procedure sp_cr_config_mail( ------------------------
                               p_c_de in varchar2,        -- De    
                               p_c_recipiente in varchar2,-- Para
                               subject in varchar2,       -- Subject
                               -------------------------                            
                               fecha_proceso in date,     -- Fecha de proceso
                               --------------------                           
                               v_header in varchar2,      -- Cabecera
                               rawdata  in clob           -- Detalle Excel
                             );
  -----------------------------------------------------------------------
  procedure sp_cr_mail_root(p_c_de in varchar2,        -- De
                            p_c_recipiente in varchar2,-- Para
                            subject in varchar2,       -- Subject
                            fecha_proceso in date,     -- Fecha de Proceso
                            --------------------
                            c_smtp_server in varchar2, -- Ip
                            port in NUMBER,            -- Puerto
                            host in varchar2,          -- Host
                            --------------------                            
                            v_header in varchar2,  -- Cabecera
                            rawdata  in clob       -- Detalle Excel
                            );
  -----------------------------------------------------------------------

end pq_cr_excel_mail_devenga;
/

create or replace package body pq_cr_excel_mail_devenga is
  -----------------------------------------------------------------------
  procedure sp_cr_obtenerdatos(fechaIngreso in Date)  as 
  fechaFinMesAnte date := fechaIngreso;  
  -------------------  
  cursor correos is 
  SELECT * FROM FST098 WHERE TPCOD = 7751 and TPNRO = 1;  -- para los destinatarios principales  TPNRO = 1, y tpnro = 2 son en copias CC   
  -------------
    cursor pagos is
    Select 
    a.AQPB758HEMP ,
    a.AQPB758HMOD ,
    a.AQPB758HSUC ,
    a.AQPB758HMDA ,
    a.AQPB758HPAP ,
    a.AQPB758HCTA ,
    a.AQPB758HOPE ,
    a.AQPB758HSBO ,
    a.AQPB758HTOP ,
    a.AQPB758HORI ,
    a.AQPB758HFEP ,
    a.AQPB758HBCCATE  ,
    a.AQPB758HRUBR    ,
    a.AQPB758HIMPEXT  ,
    a.AQPB758HMODT    ,
    a.AQPB758HSUCT    ,
    a.AQPB758HTRAT    ,
    a.AQPB758HRELT    ,
    a.AQPB758HCONT    ,
    a.AQPB758HERROR   ,
    a.AQPB758HFECT    ,
    a.AQPB758HFCAR    ,
    a.AQPB758HUSER    
    from AQPB758H A
    where a.AQPB758HFCAR =  fechaFinMesAnte; 
         
    fecha_proceso DATE;
    --------------------            
    flag_data char(1);
    ln_pago number(17,6);
    flg_hdata char(1);
    
    --------------------          
    subject varchar2(1000);   
    --------------------              
    v_header varchar2(10000);-- Cabecera
    v_wstring clob;
    data varchar2(32000);
    rawdata long raw;
    --------------------
    ln_analista char(10);
    remitente varchar(100);
    Subtotal number(17,2) := 0;
    textSubtotal varchar(30); 
    ----------------------
    contador number := 0;
    importeChar varchar2(30);
    textRubro  varchar2(16);
    lv_destinos varchar2(300);
    ----------------------    
    begin
      begin
         select 
              'S'
         into 
              flag_data
         from AQPB758H A
         where a.AQPB758HFCAR =  fechaFinMesAnte and rownum = 1;
         exception
              WHEN NO_DATA_FOUND THEN 
                   flag_data := 'N';        
       end;
       
       begin
          select tpdesc into remitente from FST098 WHERE TPCOD = 7751 and TPNRO = 3;       
       End;        
       
       If flag_data = 'S' then
           for corr in correos loop        
                         ---------------------------------------------------------------------------------
                         Subtotal := 0;
                         for r_trab in pagos() loop
                           contador := contador + 1;
                           importeChar := replace(to_char(r_trab.AQPB758HIMPEXT),',','.');                          
                           textRubro   := to_char((r_trab.AQPB758HRUBR));                           
                           Subtotal := Subtotal + r_trab.AQPB758HIMPEXT;
                             
                           data := contador ||chr(9) || r_trab.AQPB758HEMP||chr(9)|| r_trab.AQPB758HMOD||chr(9)||r_trab.AQPB758HSUC||chr(9)|| r_trab.AQPB758HMDA ||chr(9)|| r_trab.AQPB758HPAP ||chr(9)|| r_trab.AQPB758HCTA ||chr(9)|| r_trab.AQPB758HOPE ||chr(9)|| r_trab.AQPB758HSBO ||chr(9)|| r_trab.AQPB758HTOP ||chr(9)
                                   || r_trab.AQPB758HORI||chr(9)|| r_trab.AQPB758HFEP||chr(9)|| r_trab.AQPB758HBCCATE ||chr(9) || chr(2) ||textRubro ||chr(9)|| importeChar ||utl_tcp.crlf;                                                           
                           v_wstring := v_wstring||to_clob(data);                        
                         end loop;                                                   
                                                  
                         textSubtotal:= replace(to_char(Subtotal),',','.');   
                         ---------------------------------------------------------------------------------            
                         flg_hdata := 'S';   
                         subject := 'Extorno Intereses devengados '||to_char(fechaFinMesAnte, 'yyyy/mm/dd');
                         ------------------------------------------------------------------------------
                         v_header := 'MIME-Version: 1.0' || utl_tcp.crlf                                                                     -- Use MIME mail standard
                                     ||'Content-Type: multipart/mixed;' ||utl_tcp.crlf
                                     ||' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf
                                     ||'-------SECBOUND' || utl_tcp.crlf
                                     ||'Content-Type: text/plain;' || utl_tcp.crlf||                                                            
                                     'Content-Transfer_Encoding: 8bit' ||--8bit
                                     utl_tcp.crlf || utl_tcp.crlf || 'Estimado Walter,' || CHR(13) || 'Buenos días' || CHR(13) || 'El impacto al cierre del ' || to_char(fechaFinMesAnte, 'DD/MM/RRRR')|| ' fue de S/ ' || to_char(trim(textSubtotal)) || '.' || CHR(13)
                                     || 'Se adjunta el listado de Saldos devengados.'  || CHR(13)                         
                                     || CHR(13) || CHR(13) || '   ' || utl_tcp.crlf --Message Body                           
                                     ||'-------SECBOUND' || utl_tcp.crlf ||                    
                                     'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf                           
                                     ||' name=RELACION_TRABCESE_' || to_char(sysdate, 'DD-MM-RR') || utl_tcp.crlf --xls
                                     ||'Content-Transfer_Encoding: 8bit' ||--8bit
                                     utl_tcp.crlf||'Content-Disposition: attachment;' ||utl_tcp.crlf
                                     ||' filename=Devengados_incluido_rubro_' || to_char(fechaFinMesAnte, 'DD-MM-RR')||'.xls'|| utl_tcp.crlf || utl_tcp.crlf;
                         ------------------------------------------------------------------------------                       
                         v_header := v_header||'NRO'||chr(9)||'ESCENARIO'||chr(9)||'MODULO'||chr(9)||'SUCURSAL'||chr(9)||'MONEDA'||chr(9)||'PAPEL'||chr(9)||'CUENTA'||chr(9)||'OPERACION'||chr(9)||'SUBOPERACION'||chr(9)||'TIPO DE OPERACION'||chr(9)
                                             ||'TIPO DE REPROGRAMACIÓN'||chr(9)||'FECHA DE REPROGRAMACION'||chr(9)||'CATEGORIA'||chr(9)||'RUBRO'||chr(9)||'IMPORTE A EXTORNAR'||chr(9);                                                                                                 
                                   
        
                         -------------------------------------------------------------------------------
                             
                          if  v_wstring is not null  then   
                                        
                               sp_cr_config_mail(remitente,  --de
                                                 corr.tpdesc, --para
                                                 subject,       -- asunto
                                                 fecha_proceso, -- 
                                                 --------------------                           
                                                 v_header,      -- Cabecera
                                                 v_wstring      -- Detalle Excel
                                              );                                
                          end if;
                          v_wstring := '';                     
           end loop;
       End if;
  end;
  -----------------------------------------------------------------------
  procedure sp_cr_config_mail( ------------------------
                               p_c_de in varchar2,        -- De    
                               p_c_recipiente in varchar2,-- Para
                               subject in varchar2,       -- Subject
                               -------------------------                            
                               fecha_proceso in date,     -- Fecha de proceso
                               --------------------                           
                               v_header in varchar2,      -- Cabecera
                               rawdata  in clob           -- Detalle Excel
                             )
  is
  --Cursor
  cursor c_host is
    select * 
      from fst198
     Where Tp1cod  = 1
       and Tp1cod1  = 10825
       and Tp1corr1 = 61
       and Tp1corr2 = 7;
  -- Variables
  c_smtp_server VARCHAR2(30);
  port  number;
  host VARCHAR2(100);
  -- 
  lc_hostname varchar2(64);
  lv_smtp     varchar2(30);
  lv_host     varchar2(30);
  ln_port     number(9); 
  begin     

      begin
          select host_name
          into lc_hostname
          from v$instance;
      exception
      WHEN NO_DATA_FOUND then
          lc_hostname := ''; 
      end;

          For i in c_host loop
            lv_host := upper(TRIM(substr(i.tp1desc,1,instr(i.tp1desc,'/')-1)));        
            lv_smtp := TRIM(substr(i.tp1desc,instr(i.tp1desc,'/')+1,length(trim(i.tp1desc)))); 
            ln_port := i.tp1nro3;
          
            if upper(lc_hostname) = lv_host then
              
              Exit;
             End if;
          End loop;

           c_smtp_server := lv_smtp;--'10.0.200.68';
           port          := ln_port;--2530;
           
           host          := lv_host;
  
           sp_cr_mail_root(p_c_de,         --de
                           p_c_recipiente, --para
                           subject,        --subject
                           fecha_proceso,  --fecha de procesamiento
                           -------------------------
                           c_smtp_server,  -- ip del servidor
                           port,           -- puerto del servidor
                           host,           -- host del servidor
                           -------------------------                            
                           v_header,       -- Cabecera
                           rawdata       -- Detalle Excel
                          );  
  end;                                                  
  -----------------------------------------------------------------------
  procedure sp_cr_mail_root(p_c_de in varchar2,        -- De
                            p_c_recipiente in varchar2,-- Para
                            subject in varchar2,       -- Subject
                            fecha_proceso in date,     -- Fecha de Proceso
                            --------------------
                            c_smtp_server in varchar2, -- Ip
                            port in NUMBER,            -- Puerto
                            host in varchar2,          -- Host
                            --------------------                            
                            v_header in varchar2,  -- Cabecera
                            rawdata  in clob       -- Detalle Excel
                            )
  is

  cursor correosCopias is 
    SELECT * FROM FST098 WHERE TPCOD = 7751 and TPNRO = 2; --para los correos de copias
      
  v_wstring varchar2 (32000);
  auxiliar varchar2 (32000);
  v_From      VARCHAR2(80);
  v_Recipient VARCHAR2(80);
  
  lv_destinos varchar2(300); 
  
  v_Subject   VARCHAR2(80);
  V_Conexion    utl_smtp.Connection;
  v_clob                     CLOB;
  msg           varchar2(32767);
  p_c_msgerr VARCHAR2(1000);
  vhost_name VARCHAR2( 100 );
  v_found number;
  c_dni VARCHAR2(100);
  datas long raw;
  c_mime_boundary   CONSTANT VARCHAR2 (256)      := '--AAAAA000956--';
  l_n_offset NUMBER:=630;
  begin 
  v_clob := 'Number' || ',' || 'Name' || UTL_TCP.crlf;
  SELECT HOST_NAME
    INTO VHOST_NAME
  FROM V$INSTANCE;
        
     -- IF UPPER(VHOST_NAME) IN ('BTRAC1051','BTRAC1052',host) then 
    -- IF UPPER(VHOST_NAME) IN  ('SC01ZDBADM010101','SC01ZDBADM020101',host) then
     -- IF UPPER(VHOST_NAME) IN  ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') then
      v_From      := p_c_de;
      v_Recipient := P_C_RECIPIENTE;    
      v_Subject   := subject;
              
    SELECT count(*) into v_found
    FROM systabrep.hostnames 
    where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);
 

    For k in correosCopias loop                                 
                lv_destinos := lv_destinos||trim(k.tpdesc)||';';     
            End loop;
    if lv_destinos is not null  then   
      lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);   
    End If;

  if v_found =1 then
      V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER,Port);
      msg           := 'Date: ' ||to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||utl_tcp.crlf ||
                       'From: ' || v_From || utl_tcp.crlf ||
                       'Subject: ' || v_Subject || utl_tcp.crlf ||       
                       'CC:'|| lv_destinos || utl_tcp.crlf ||                
                       'To: ' || v_Recipient || utl_tcp.crlf; 

      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      utl_smtp.Rcpt(V_Conexion, v_Recipient);
      
      For m in CorreosCopias loop  --enviar a los copias
          utl_smtp.Rcpt(V_Conexion, m.tpdesc);  
      End loop;
              
      UTL_SMTP.OPEN_DATA(V_Conexion);

      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg);
      --Se escribe el contenido del mensaje 
      utl_smtp.write_data(V_Conexion,v_header||utl_tcp.crlf);
      FOR loop_att IN 0 .. TRUNC(DBMS_LOB.getlength(rawdata)/l_n_offset)
      LOOP
          auxiliar := DBMS_LOB.substr(rawdata, l_n_offset, loop_att * l_n_offset + 1);
          UTL_SMTP.write_data(V_Conexion, auxiliar);
      END LOOP;
              
      --UTL_smtp.write_raw_data(V_Conexion, UTL_ENCODE.base64_encode(rawdata));
      --datas := (CAST(rawdata as long raw);
      --UTL_smtp.write_raw_data(V_Conexion, rawData);
              
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);      
  end if;  
  EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
  p_c_msgerr:='Unable to send mail: ' || sqlerrm;
  raise_application_error(-20000, 'Unable to send mail: ' || p_c_msgerr);  
  end;                             
  -----------------------------------------------------------------------


end pq_cr_excel_mail_devenga;
/

