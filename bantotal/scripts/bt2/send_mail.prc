CREATE OR REPLACE PROCEDURE send_mail (p_to        IN VARCHAR2,
                                       p_from      IN VARCHAR2,
                                       --p_cc   IN VARCHAR2 DEFAULT NULL,
                                       p_subject   IN VARCHAR2,
                                       p_html_msg  IN LONG DEFAULT NULL                                       
                                       )
AS
  l_mail_conn   UTL_SMTP.connection;
  l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
--  p_smtp_host  VARCHAR2(20) :='172.20.100.13';
  --22.09.2016
  p_smtp_host  VARCHAR2(20) :='10.0.200.68';
  p_smtp_port  NUMBER   :=2528;
  p_text_msg  VARCHAR2(800) DEFAULT NULL;
  --p_cc VARCHAR2 DEFAULT NULL;  
  vhost_name    VARCHAR2(100);
	v_found number;
BEGIN
  
  select host_name into p_smtp_host from  systabrep.hostnames_mail where habilitado='S';
  select port into p_smtp_port from  systabrep.hostnames_mail where habilitado='S';
  
  SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
	
	SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);

 
--  IF  UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052') THEN    
--  IF  UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052','BTRAC4051') THEN  
--  IF  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') THEN
--  if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
    --p_cc :='kvalenciac@cajaarequipa.pe';  -- colocar aqui otro destinatario por defecto 
  if v_found =1 then   
 l_mail_conn := UTL_SMTP.open_connection(p_smtp_host, p_smtp_port);
    UTL_SMTP.helo(l_mail_conn, p_smtp_host);
    UTL_SMTP.mail(l_mail_conn, p_from);
    UTL_SMTP.rcpt(l_mail_conn, p_to);
   -- UTL_SMTP.rcpt(l_mail_conn, p_cc);
    UTL_SMTP.open_data(l_mail_conn);
    
    UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'To: ' || p_to || UTL_TCP.crlf);
    --UTL_SMTP.write_data(l_mail_conn, 'CC: ' || p_cc || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'From: ' || p_from || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || p_subject || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'Reply-To: ' || p_from || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
    
    IF p_text_msg IS NOT NULL THEN
      UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
      UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);

      UTL_SMTP.write_data(l_mail_conn, p_text_msg);
      UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
    END IF;

    IF p_html_msg IS NOT NULL THEN
      UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
      UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/html; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);

      UTL_SMTP.write_data(l_mail_conn, p_html_msg);
      UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
    END IF;

    UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
    UTL_SMTP.close_data(l_mail_conn);
    UTL_SMTP.quit(l_mail_conn);
  end if;    
END;
/

