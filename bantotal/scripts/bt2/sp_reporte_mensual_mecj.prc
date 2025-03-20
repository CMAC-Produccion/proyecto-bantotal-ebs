create or replace procedure "SP_REPORTE_MENSUAL_MECJ" IS
  --Declaracion de variables
  CURSOR C_REPORTE IS
    select * from REP_MENSUAL_MECJ;
  CURSOR C_MAIL IS
    select 'mretamozo@cajaarequipa.pe' mail from DUAL
    UNION
    select 'csosa@cajaarequipa.pe' mail from DUAL
    UNION
    select 'cjurado@cajaarequipa.pe' mail from DUAL
    union
    select 'ehidalgom@cajaarequipa.pe' mail from DUAL
        union
    select 'kcabrerac@cajaarequipa.pe' mail from DUAL;

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
  v_found number;
  n_Port number;
BEGIN

  SELECT HOST_NAME
    INTO VHOST_NAME
  FROM V$INSTANCE;

--  IF  UPPER(VHOST_NAME) IN ('BTRAC1051','BTRAC1052') THEN
--  IF  UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052') THEN
--  IF  UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052','BTRAC4051') THEN
--  IF  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') THEN
--    if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
 SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);
  
 
  if v_found =1 then
    
      DELETE rep_mensual_MECJ;
      COMMIT;
      INSERT INTO REP_MENSUAL_MECJ
      select a.sccta Cta_pres,
                 a.scoper Ope_pres,
                 a.scsbop Subop_pres,
                 a.scmod Mod_pres,
                 a.sctope tip_pres,
                 a.scsuc suc_pres,
                 a.scrub rub_pres,
                 a.scsdo saldo_pres,
                 a.scstat estado_pres,
                 b.sccta Cta_Interes,
                 b.scoper Ope_Interes,
                 b.scsbop Subop_Interes,
                 b.scmod Mod_Interes,
                 b.sctope tip_Interes,
                 b.scsuc  suc_Interes,
                 b.scrub rub_Interes,
                 b.scsdo saldo_Interes,
                 c.rrrubr Rub_Int_Correcto
            from fsd011 a, fsd011 b, fsr014 c
        where a.scstat in (23, 25, 64)
               and a.pgcod = b.pgcod
               and a.scsuc = b.scsuc
               and a.scmda = b.scmda
               and a.scpap = b.scpap
               and a.sccta = a.sccta
               and a.scoper = b.scoper
               and a.scsbop = b.scsbop
               and b.scmod = 455
               and substr(a.scrub, 5, 2) <> substr(b.scrub, 7, 2)
               and c.rubro = a.scrub
               and c.rrcod = 148
               and substr(a.scrub, 1, 2) <> 19;
      COMMIT;
      FOR j IN C_MAIL LOOP
              v_From      := 'bantoem@cajaarequipa.pe';
              v_Recipient := j.mail;
              v_Subject   := 'Reporte_Conta_Reclasifica_Interes_Judicial_Tipificacion'||to_char(sysdate, 'yyyy.mm.dd hh24:mi:ss');
--              C_SMTP_SERVER := '172.20.100.13';
--              C_SMTP_SERVER := '172.18.100.13';
              --22.09.2016
              C_SMTP_SERVER := '10.0.200.68';
              n_Port := 2528;
              
              select host_name into C_SMTP_SERVER from  systabrep.hostnames_mail where habilitado='S';
              select port into n_Port from  systabrep.hostnames_mail where habilitado='S';

              --V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, 2528);
              V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, n_Port);
              msg           := 'Date: ' ||to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||utl_tcp.crlf ||
                               'From: ' || v_From || utl_tcp.crlf ||
                               'Subject: ' || v_Subject || utl_tcp.crlf ||
                               'To: ' || j.mail || utl_tcp.crlf;

              --Se negocia la transaccion con el servidor SMTP
              utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
              utl_smtp.Mail(V_Conexion, v_From);
              utl_smtp.Rcpt(V_Conexion, v_Recipient);
              UTL_SMTP.OPEN_DATA(V_Conexion);

              --Se escribe la cabecera
              UTL_SMTP.WRITE_DATA(V_Conexion, msg);
              utl_smtp.write_data(V_Conexion,
                                  'MIME-Version: 1.0' || utl_tcp.crlf);                                                                     -- Use MIME mail standard
              utl_smtp.write_data(V_Conexion,'Content-Type: multipart/mixed;' ||utl_tcp.crlf);
              utl_smtp.write_data(V_Conexion,' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf);

              utl_smtp.write_data(V_Conexion,
                                  '-------SECBOUND' || utl_tcp.crlf ||
                                  'Content-Type: text/plain;' || utl_tcp.crlf);
                                  --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
              utl_smtp.write_data(V_Conexion,
                                  'Content-Transfer_Encoding: 8bit' ||--8bit
                                  utl_tcp.crlf || utl_tcp.crlf || 'Adj. Reporte_Conta_Reclasifica_Interes_Judicial_Tipificacion' ||  CHR(13) || utl_tcp.crlf); --Message Body
              utl_smtp.write_data(V_Conexion,
                                  '-------SECBOUND' || utl_tcp.crlf ||
                                  --'Content-Type: text/plain;' || utl_tcp.crlf);--
                                  'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
              utl_smtp.write_data(V_Conexion,
                                  ' name=CONT_RECLA_INT_JUD_' || to_char(sysdate, 'DD-MM-RRRR') || utl_tcp.crlf); --xls
              utl_smtp.write_data(V_Conexion,
                                  'Content-Transfer_Encoding: 8bit' ||--8bit
                                  utl_tcp.crlf);
              utl_smtp.write_data(V_Conexion,
                                  'Content-Disposition: attachment;' ||
                                  utl_tcp.crlf);
              utl_smtp.write_data(V_Conexion,
                                  ' filename=CONT_RECLA_INT_JUD_' || to_char(sysdate, 'DD-MM-RRRR')||'.xls'|| utl_tcp.crlf ||
                                  utl_tcp.crlf);

              v_header :='CTA_PRES'||chr(9)||'OPE_PRES'||chr(9)||'SUBOP_PRES'||CHR(9)||'MOD_PRES'||CHR(9)||'TIP_PRES'||CHR(9)||'SUC_PRES'||CHR(9)||
                         'RUB_PRES'||CHR(9)||'SALDO_PRES'||CHR(9)||'ESTADO_PRES'||CHR(9)||'CTA_INTERES'||CHR(9)||'OPE_INTERES'||CHR(9)||
                         'SUBOP_INTERES'||CHR(9)||'MOD_INTERES'||CHR(9)||'TIP_INTERES'||CHR(9)||'SUC_INTERES'||CHR(9)||'RUB_INTERES'||CHR(9)||
                         'SALDO_INTERES'||CHR(9)||'RUB_INT_CORRECTO';

              utl_smtp.write_data(V_Conexion,v_header||utl_tcp.crlf);

              for R_REPORTE in C_REPORTE loop
                 v_wstring := r_reporte.CTA_PRES||chr(9)||r_reporte.OPE_PRES||chr(9)||r_reporte.SUBOP_PRES||chr(9)||r_reporte.MOD_PRES||chr(9)||
                           r_reporte.TIP_PRES||chr(9)||r_reporte.SUC_PRES||chr(9)||r_reporte.RUB_PRES||chr(9)||r_reporte.SALDO_PRES||chr(9)||
                           r_reporte.ESTADO_PRES||chr(9)||r_reporte.CTA_INTERES||chr(9)||r_reporte.OPE_INTERES||chr(9)||r_reporte.SUBOP_INTERES||chr(9)||
                           r_reporte.MOD_INTERES||chr(9)||r_reporte.TIP_INTERES||chr(9)||r_reporte.SUC_INTERES||chr(9)||r_reporte.RUB_INTERES||chr(9)||
                           r_reporte.SALDO_INTERES||chr(9)||r_reporte.RUB_INT_CORRECTO;

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
      END LOOP;
  END IF;
EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
END SP_REPORTE_MENSUAL_MECJ;
 /* GOLDENGATE_DDL_REPLICATION */
/

