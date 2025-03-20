create or replace procedure SP_AH_VALIDA_PAGOS_RECAUD (c_destinatario in varchar2) IS
  cursor C_VALIDA is
    SELECT JAQL82COIN, JAQL82COPA, JAQL82FEPA, JAQL82COBT, JAQL82ESTA
      FROM JAQL082 JJ
     WHERE JJ.JAQL82ESTA <> 'S'
       AND (JJ.JAQL82ITCD, JJ.JAQL82ITSU, JJ.JAQL82ITMO, JJ.JAQL82ITTR,
            JJ.JAQL82ITRE, JJ.JAQL82ITFC) IN
           (SELECT PGCOD, HSUCOR, HCMOD, HTRAN, HNREL, HFCON
              FROM FSH015
             WHERE HCCORR = 0)
       AND JJ.JAQL82FEPA =TRUNC(SYSDATE) - 1
       AND EXISTS (SELECT 1
              FROM CTREG10@COLE
             WHERE REGIDPAGBT = TO_CHAR(JJ.JAQL82COBT)
               AND REGEST = 'P'
               AND JJ.JAQL82COIN = rpad(REGCIACOD,20,' ')
               AND JJ.JAQL82FEPA = REGFCHPAG
               AND JJ.JAQL82COPA = rpad(REGCPAGCOD,20,' ')
               AND JJ.JAQL82MONE = REGTIPMONCOD);


  v_wstring varchar2 (32000);
  v_header varchar2(10000);
  v_From      VARCHAR2(80);
  v_Recipient VARCHAR2(80);
  v_Subject   VARCHAR2(80);
  C_SMTP_SERVER VARCHAR2(30);
  V_Conexion    utl_smtp.Connection;
  msg           varchar2(32767);
  p_c_msgerr VARCHAR2(1000);
  vhost_name VARCHAR2( 100 );
  rawData    RAW(32000);
  c_nomcol VARCHAR2( 60 );
  ln_cont number;
	v_found number;
	n_Port number;
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE=ENGLISH';
     
  SELECT HOST_NAME
    INTO vhost_name
  FROM V$INSTANCE;

SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);


  SELECT COUNT(*)
   into ln_cont
      FROM JAQL082 JJ
     WHERE JJ.JAQL82ESTA <> 'S'
       AND (JJ.JAQL82ITCD, JJ.JAQL82ITSU, JJ.JAQL82ITMO, JJ.JAQL82ITTR,
            JJ.JAQL82ITRE, JJ.JAQL82ITFC) IN
           (SELECT PGCOD, HSUCOR, HCMOD, HTRAN, HNREL, HFCON
              FROM FSH015
             WHERE HCCORR = 0)
       AND JJ.JAQL82FEPA =TRUNC(SYSDATE) - 1
       AND EXISTS (SELECT 1
              FROM CTREG10@COLE
             WHERE REGIDPAGBT = TO_CHAR(JJ.JAQL82COBT)
               AND REGEST = 'P'
               AND JJ.JAQL82COIN = rpad(REGCIACOD,20,' ')
               AND JJ.JAQL82FEPA = REGFCHPAG
               AND JJ.JAQL82COPA = rpad(REGCPAGCOD,20,' ')
               AND JJ.JAQL82MONE = REGTIPMONCOD);

  commit;
  if ( ln_cont>0 )then
--    if UPPER(vhost_name) in ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') then
--    if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
  if v_found =1 then
		
      v_From      := 'reportesahorro@cajaarequipa.pe';
      v_Recipient := c_destinatario;
      v_Subject   := 'Pagos_JAQL082_'||to_char(sysdate, 'yymmdd');
      C_SMTP_SERVER := '10.0.200.68';
      n_Port := 2528;
      
      select host_name into C_SMTP_SERVER from  systabrep.hostnames_mail where habilitado='S';
      select port into n_Port from  systabrep.hostnames_mail where habilitado='S';
      
--      V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, 2528);
      V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, n_Port);
      msg           := 'Date: ' ||to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||utl_tcp.crlf ||
                       'From: ' || v_From || utl_tcp.crlf ||
                       'Subject: ' || v_Subject || utl_tcp.crlf ||
                       'To: ' || v_Recipient || utl_tcp.crlf;

      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      utl_smtp.Rcpt(V_Conexion, v_Recipient);
      UTL_SMTP.OPEN_DATA(V_Conexion);

      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg);
      utl_smtp.write_data(V_Conexion,
                          'MIME-Version: 1.0' || utl_tcp.crlf);                           -- Use MIME mail standard
      utl_smtp.write_data(V_Conexion,'Content-Type: multipart/mixed;' ||utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf);

      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          'Content-Type: text/plain;' || utl_tcp.crlf);
                          --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' ||--8bit
                          utl_tcp.crlf || utl_tcp.crlf || 'Adj. Pagos_JAQL082_'||to_char(sysdate, 'yymmdd')|| utl_tcp.crlf); --Message Body
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          --'Content-Type: text/plain;' || utl_tcp.crlf);--
                          'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' name='|| 'Pagos_JAQL082_'||to_char(sysdate, 'yymmdd')||'.txt'|| utl_tcp.crlf); --TXT
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' ||--8bit
                          utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          'Content-Disposition: attachment;' ||
                          utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                              ' filename='|| 'Pagos_JAQL082_'||to_char(sysdate, 'yymmdd')||'.txt'|| utl_tcp.crlf ||
                              utl_tcp.crlf);

      for R_VALIDA in C_VALIDA loop
            v_wstring := R_VALIDA.JAQL82COIN||chr(9)||R_VALIDA.JAQL82COPA||chr(9)||R_VALIDA.JAQL82FEPA||chr(9)||
                         R_VALIDA.JAQL82COBT||chr(9)||R_VALIDA.JAQL82ESTA;
            -- transforma el v_wstring en RAW y escribe el cuerpo del correo
            rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
            UTL_smtp.write_raw_data(V_Conexion, rawData);
      end loop;

      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
      commit;
    END IF;
  end if;
EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
END SP_AH_VALIDA_PAGOS_RECAUD;
/

