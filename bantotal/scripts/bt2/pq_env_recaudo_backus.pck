create or replace package PQ_ENV_RECAUDO_BACKUS is

--  procedure sp_enviar_correo(p_c_msgerr out varchar2);
  procedure sp_enviar_correo(p_c_FecEnv date, p_c_filas out number);
end PQ_ENV_RECAUDO_BACKUS;
/

create or replace package body PQ_ENV_RECAUDO_BACKUS is
  -- *****************************************************************
  -- Nombre                     : PQ_ENV_RECAUDO_BACKUS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECAUDO
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/10/2015
  -- Autor de Creación          : Hlaqui
  -- Uso                        : Generar y enviar los pagos de recaudo BACKUS por correo
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      : 10/02/2015
  -- Autor de la Modificación   : Hlaqui
  -- Descripción de Modificación: Se quita caracteres especiales y tildes.
  -- Fecha de Modificación      : 25/06/2018
  -- Autor de la Modificación   : Hlaqui
  -- Descripción de Modificación: Se modifica para que destinatarios funcione con guía de dominios
  -- Fecha de Modificación      : 27/02/2024
  -- Autor de la Modificación   : Fpinto
  -- Descripción de Modificación: Se quita caracteres especiales y tildes en nombre de cliente.
  -- *****************************************************************

  --create or replace TYPE ArrayCabecera IS TABLE OF varchar2(250); 
--  procedure sp_enviar_correo(p_c_msgerr out varchar2) is        
--  procedure sp_enviar_correo is        
    procedure sp_enviar_correo(p_c_FecEnv date, p_c_filas out number) is        
    p_c_msgerr varchar2(1000);
    cursor deta (fecha in date) is           
      --Cabecera
      select '01'||';'|| to_char(fecha,'DD/MM/YYYY') || ';' || substr(C.tp1desc,1, 23) || ';' 
             || to_char(SYSDATE, 'HH24:MI:SS') || ';' || substr(B.tp1desc, 1, 30)  || '; ;' AS fila
      from fst017 A, fst198 B, fst198 C
      where A.pgcod=1
      and B.tp1cod1=10801 and B.tp1corr1 = 208 and B.tp1corr2=1 and B.tp1corr3=1
      and C.tp1cod1=10801 and C.tp1corr1 = 208 and C.tp1corr2=1 and C.tp1corr3=2
      union all
      --Detalle
      select fila from (
      select '02' || ';' || lpad(jaql515sumin, 8, '0') || '   '  || ';' ||  rpad(trim(translate(jaql506clien,'áéíóöoúüuñÑ','aeiooouuunN')), 50, ' ') 
             || ';' || rpad(upper(translate(lower(scnom),'áéíóöoúüuñ','aeiooouuun')), 25, ' ') || ';'|| rpad(a.jaql515copsv, 10, ' ') || ';' || 
             lpad( trim(replace(to_char(jaql516mocob,'9999999.99'), '.','')), 13, '0') || ';' AS fila, b.jaql515copsv       
      from jaql515 a
      inner join jaql516 b
      on a.jaql515copsv = b.jaql515copsv
      inner join jaql506 c
      on jaql506nrcon = jaql515sumin
      and jaql506coent = 8
      and jaql506cotse = 3
      inner join fst001 d
      on d.sucurs = a.jaql515pgsuc
      where jaql515coent = 8 
      and jaql515cotsv = 3
      and jaql515esreg	=	'V'
      and jaql515femov = fecha 
      order by b.jaql515copsv asc );

    cursor destinatarios(codent in number,codsrv in number) is
       select trim(a.tp1desc) || '@' || trim(b.tp1desc) tp1desc
        from fst198 a
       inner join fst198 b
          on b.tp1cod = 1
         and b.tp1cod1 = 10801
         and b.tp1corr1 = 35
         and b.tp1corr2 = a.tp1nro3
       where a.tp1cod = 1
         and a.tp1cod1 = 10801
         and a.tp1corr1 = 25
         and a.tp1corr2 = codent;
         
    cursor destinatarios_2(codent in number,codsrv in number) is
      select trim(tp1desc) tp1desc
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 25
         and tp1corr2 = codent
         and tp1nro1 = codsrv
         and tp1nro3 = 1;
          
    cursor asunto is
      select trim(tp1desc) tp1desc
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 22
         and Tp1corr2 = 5;
         
    cursor cuerpo is
      select trim(tp1desc) tp1desc
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 22
         and Tp1corr2 = 6;
         
    cursor nombreArc is
      select trim(tp1desc) tp1desc
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 22
         and Tp1corr2 = 7;
     
     cursor c_host is
    select * 
      from fst198
     Where Tp1cod  = 1
       and Tp1cod1  = 10825
       and Tp1corr1 = 61
       and Tp1corr2 = 7;
                 
    v_wstring     varchar2(32000);
    v_header      varchar2(10000);
    v_From        VARCHAR2(80);
    v_Recipient   VARCHAR2(80);
    v_Subject     VARCHAR2(200);
    v_Body        VARCHAR2(200);
    v_Nombre      VARCHAR2(200);
    C_SMTP_SERVER VARCHAR2(30);
    C_SMTP_PORT   VARCHAR2(4);
    V_Conexion    utl_smtp.Connection;
    msg           varchar2(32767);
    vhost_name    VARCHAR2(100);
    rawData       RAW(32000);
    v_serv        varchar2(60);
    v_emp         varchar2(60);
    remitente     varchar2(30);
    fecha         date;
    countDest     number;
    v_host        VARCHAR2(80);
    codent        number;
    codsrv        number;
		v_found number;
		
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE; 
    if p_c_FecEnv IS NULL THEN
       select pgfape into fecha from fst017 where pgcod = 1;         
    Else
       fecha := p_c_FecEnv;
    End If;
    
    codent:= 8;
    codsrv:= 3;
    
    For i in c_host loop
        v_host := upper(TRIM(substr(i.tp1desc,1,instr(i.tp1desc,'/')-1)));        
        C_SMTP_SERVER := TRIM(substr(i.tp1desc,instr(i.tp1desc,'/')+1,length(trim(i.tp1desc)))); 
        C_SMTP_PORT := i.tp1nro3;
        if upper(VHOST_NAME) = v_host then
          Exit;
        End if;
    End loop; 
            
		SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);
   
--    IF  UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052'/*,'DSBD1051'*/) THEN
--    IF  UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052','BTRAC4051') THEN
--    IF  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') THEN    
--    if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      
			  if v_found =1 then
			select jaql508abent
        into v_emp
        from jaql508
       where jaql508coent = 8; -- Recaudo Backus
       
      select jaql514detsv
        into v_serv
        from jaql514
       where jaql514cotsv = 3; -- Servicio: Otras instituciones
      
      select trim(tp1desc) tp1desc
        into remitente
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 22
         and Tp1corr2 = 3
         and tp1corr3 = 1;
         
      select trim(tp1desc) tp1desc
        into v_Recipient
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 22
         and Tp1corr2 = 4
         and tp1corr3 = 1;         
   
      v_From      := remitente;
      
      v_Subject := '';
      For asu in asunto loop
          v_Subject := v_Subject || asu.tp1desc;
      end loop;
      
      
      v_Subject     := v_Subject || v_emp || ' - ' || v_serv || ' ' ||
                       to_char(fecha, 'yyyy.mm.dd hh24:mi:ss');
      --C_SMTP_SERVER := '172.20.100.13';
      V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, C_SMTP_PORT);
      msg           := 'Date: ' ||
                       to_char(fecha, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                       utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                       'Subject: ' || v_Subject || utl_tcp.crlf || 'To: ' ||
                       '' || utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      countDest := 0;
      for dest in destinatarios(codent,codsrv) loop
        utl_smtp.Rcpt(V_Conexion, dest.tp1desc);
        --utl_smtp.Rcpt(V_Conexion, dest.tp1desc || '@backus.sabmiller.com');
        countDest := countDest + 1;
      end loop;      
      If countDest = 0 then
         utl_smtp.Rcpt(V_Conexion, v_Recipient);         
      End If;
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg);
      utl_smtp.write_data(V_Conexion, 'MIME-Version: 1.0' || utl_tcp.crlf); -- Use MIME mail standard
      utl_smtp.write_data(V_Conexion,
                          'Content-Type: multipart/mixed;' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' boundary=-----SECBOUND' || utl_tcp.crlf ||
                          utl_tcp.crlf);
    
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          'Content-Type: text/plain;' || utl_tcp.crlf);
      --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
      v_Body := '';
      For cue in cuerpo loop
          v_Body := v_Body || cue.tp1desc;
      end loop;
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || --8bit
                          utl_tcp.crlf || utl_tcp.crlf || v_Body || '. ' || v_emp || ' - ' || v_serv 
                          || ' ' || to_char(fecha, 'DD-MM-RRRR') || CHR(13) ||
                          CHR(13) || CHR(13) || utl_tcp.crlf); --Message Body
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          --'Content-Type: text/plain;' || utl_tcp.crlf);--
                           'Content-Type: text/plain; charset=iso-8859-1' ||
                           utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' name=EXTRACTO_' ||
                          to_char(fecha, 'DD-MM-RRRR') || utl_tcp.crlf); --xls
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || --8bit
                          utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          'Content-Disposition: attachment;' ||
                          utl_tcp.crlf);
      
      v_Nombre := '';
      For nom in nombreArc loop
          v_Nombre := v_Nombre || nom.tp1desc;
      end loop;
      
      utl_smtp.write_data(V_Conexion,
                          ' filename=' || v_Nombre ||
                          to_char(fecha, 'DD-MM-RRRR') || '.txt' ||
                          utl_tcp.crlf || utl_tcp.crlf);                         
      p_c_filas:=0;
      for r_trab in deta(fecha) loop
        v_wstring := r_trab.fila;                           
        --utl_smtp.write_data(V_Conexion,v_wstring||utl_tcp.crlf);
        -- transforma el v_wstring en RAW y escribe el cuerpo del correo
        rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        p_c_filas := p_c_filas + 1;
      end loop;
      
      v_header := '';
      utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
      
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
    
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    END IF;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
  END sp_enviar_correo;
  

end PQ_ENV_RECAUDO_BACKUS;
/

