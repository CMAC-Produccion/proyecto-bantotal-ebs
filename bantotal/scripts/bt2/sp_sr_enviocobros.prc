create or replace procedure sp_sr_enviocobros (c_destinatario in varchar2) IS
  cursor C_ULS1 is
    ---formateado  / enviar en texto paa envio por correo
    ---Cabecera
    select t_titu.tipo || ',' || t_titu.idempresa || ',' || t_titu.fecha || ',' ||
           ltrim(to_char(t_titu.registros, '9999999')) || ',' ||
           ltrim(to_char(t_titu.total, '9999990.99')) || ',' CABECERA
      from jaqz602 t_titu
    union all
    ---Detalle
    select t_base.tipo || ',' || t_base.codigo || ',' || t_base.key || ',' ||
           ltrim(to_char(t_base.valor_pagado, '9999990.99')) || ',' ||
           ltrim(to_char(t_base.valor_interes, '99990.99')) || ',' ||
           t_base.hora || ',' || t_base.comprobante || ',' CABECERA
      from jaqz603 t_base;


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
  EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE=ENGLISH';
  SELECT HOST_NAME
    INTO vhost_name
  FROM V$INSTANCE;
	
	SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);



--  IF  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') THEN
--  if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
  if v_found =1 then
		
    DELETE FROM jaqz604;
    COMMIT;
    INSERT INTO jaqz604
    select t_cabe.regciacod,
             t_cuen.cuenro,
             t_cabe.regnrorec,
             t_cabe.regcpagcod cpagcod,
             t_cabe.regfchpag,
             t_cabe.regidpagbt,
             t_alum.cpaginstcod codigo,
             t_deta.regprdocod prdocod,
             substr(t_subp.spdonom, 8, 10) prdodes,
             sum(case when substr(t_deta.regadicod,1,4) = '10MR' then t_deta.regmonto else 0 end) Pagos,
             sum(case when substr(t_deta.regadicod,1,5) = '20IPM' then t_deta.regmonto else 0 end) Mora,
             sum(case when t_deta.regadicod = '40COMICMAC' then t_deta.regmonto else 0 end) Comis_Usuario,
             sum(case when t_deta.regadicod = '40COMICLIE' then t_deta.regmonto else 0 end) Comis_cliente
      from ctreg10@cole t_cabe,
           ctreg20@cole t_deta,
           cpcue10@cole t_cuen,
           cmpag10@cole t_alum,
           cppag10@cole t_rela,
           cpprd10@cole t_peri,
           cpspr10@cole t_subp
      where t_cabe.regciacod = '0000000597'
            and t_cabe.regest = 'P'
            and t_cabe.regfchpag = to_date(to_char(sysdate, 'yyyy.mm.dd'), 'yyyy.mm.dd')
            and t_cabe.regusecod = 'CMAC'
            and t_deta.regnrorec = t_cabe.regnrorec
            and t_deta.regciacod = t_cabe.regciacod
            and t_deta.regcpagcod = t_cabe.regcpagcod
             and t_cuen.ciacod = t_cabe.regciacod
             and t_alum.cpagcod = t_cabe.regcpagcod
             and t_rela.ciacod = t_alum.ciacod
             and t_rela.cpagcod = t_alum.cpagcod
             and t_rela.prdocod = t_deta.regprdocod
             and t_peri.ciacod = t_rela.ciacod
             and t_peri.prdocod = t_rela.prdocod
             --and t_peri.prdoest = '2'
             and t_subp.ciacod = t_peri.ciacod
             and t_subp.prdocod = t_peri.prdocod
             and t_subp.spdocod = t_deta.regspdocod
             --and t_subp.spdoest = '2'
      group by t_cabe.regciacod,
               t_cuen.cuenro,
               t_cabe.regnrorec,
               t_cabe.regcpagcod,
               t_cabe.regfchpag,
               t_cabe.regidpagbt,
               t_alum.cpaginstcod,
               t_deta.regprdocod,
               substr(t_subp.spdonom, 8, 10);

    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'jaqz604',
                                    degree           => 8,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    DELETE FROM jaqz603;
    COMMIT;

    INSERT INTO jaqz603
    select 'C' tipo,
           substr(t_inst.codigo,1,10) codigo,
           rpad(trim(substr(t_inst.prdodes,1,30)),30, ' ') key,
           t_inst.pagos valor_pagado,
           t_inst.mora valor_interes,
           t_trad.ithora hora,
           to_char(t_trad.itfcon, 'yymmdd') || lpad(t_trad.itsuc, 3 ,'0') || lpad(t_trad.itmod, 3 ,'0') || lpad(t_trad.ittran, 3 ,'0') || lpad(t_trad.itnrel, 4 ,'0') comprobante,
           t_movi.jaql82user
    from jaqz604 t_inst,
         jaql082 t_movi,
         fsd015 t_trad
    where t_movi.jaql82cobt(+) = to_number(t_inst.regidpagbt)
          and t_trad.pgcod(+) = 1
          and t_trad.itmod(+) = t_movi.jaql82itmo
          and t_trad.itsuc(+) = t_movi.jaql82itsu
          and t_trad.ittran(+) = t_movi.jaql82ittr
          and t_trad.itnrel(+) = t_movi.jaql82itre
          and t_trad.itfcon(+) = t_movi.jaql82itfc
    order by t_trad.ithora;


    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'jaqz603',
                                    degree           => 8,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    --totales
    DELETE FROM jaqz602;
    COMMIT;

    INSERT INTO jaqz602
    select 'C' tipo,
           lpad(597, 10, '0') idempresa,
           to_char(sysdate, 'yyyy/mm/dd') fecha,
           count(*) registros,
           sum(t_base.valor_pagado + t_base.valor_interes) total
    from jaqz603 t_base;

    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'jaqz602',
                                    degree           => 8,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    v_From      := 'reportesahorro@cajaarequipa.pe';
    v_Recipient := c_destinatario;
    v_Subject   := 'C'||to_char(sysdate, 'yymmdd')||'_1.597';--CAAMMDD_1.597
    C_SMTP_SERVER := '10.0.200.68';
    n_Port := 2528;
    
    select host_name into C_SMTP_SERVER from  systabrep.hostnames_mail where habilitado='S';
    select port into n_Port from  systabrep.hostnames_mail where habilitado='S';
    
--    V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, 2528);
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
                        'MIME-Version: 1.0' || utl_tcp.crlf);                                                                     -- Use MIME mail standard
    utl_smtp.write_data(V_Conexion,'Content-Type: multipart/mixed;' ||utl_tcp.crlf);
    utl_smtp.write_data(V_Conexion,' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf);

    utl_smtp.write_data(V_Conexion,
                        '-------SECBOUND' || utl_tcp.crlf ||
                       'Content-Type: text/plain;' || utl_tcp.crlf);
                        --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
    utl_smtp.write_data(V_Conexion,
                        'Content-Transfer_Encoding: 8bit' ||--8bit
                        utl_tcp.crlf || utl_tcp.crlf || 'Adj. C'||to_char(sysdate, 'yymmdd')||'_1.597' || utl_tcp.crlf); --Message Body
    utl_smtp.write_data(V_Conexion,
                        '-------SECBOUND' || utl_tcp.crlf ||
                        --'Content-Type: text/plain;' || utl_tcp.crlf);--
                        'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
    utl_smtp.write_data(V_Conexion,
                        ' name='|| 'C'||to_char(sysdate, 'yymmdd')||'_1.597' || utl_tcp.crlf); --TXT
    utl_smtp.write_data(V_Conexion,
                        'Content-Transfer_Encoding: 8bit' ||--8bit
                        utl_tcp.crlf);
    utl_smtp.write_data(V_Conexion,
                        'Content-Disposition: attachment;' ||
                        utl_tcp.crlf);
    utl_smtp.write_data(V_Conexion,
                            ' filename='|| 'C'||to_char(sysdate, 'yymmdd')||'_1.597'|| utl_tcp.crlf ||
                            utl_tcp.crlf);

    for R_ULS1 in C_ULS1 loop
          v_wstring := R_ULS1.CABECERA;
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

  END IF;
EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
END sp_sr_enviocobros;
/

