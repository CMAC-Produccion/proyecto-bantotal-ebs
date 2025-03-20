create or replace package PQ_ENV_EXTRAC_PAGSERV is

  procedure sp_enviar_correo(p_n_codesv in number,
                             p_n_codtsv in number,
                             p_c_user   in char,
                             p_d_fecha  in date,
                             p_c_msgerr out varchar2);
  function fn_obtener_contrato (p_suc number,p_mod number,p_tra number,p_rel number,p_fec date,
                               p_ent number,
                               p_ser number)
  return varchar2;
end PQ_ENV_EXTRAC_PAGSERV;
/

create or replace package body PQ_ENV_EXTRAC_PAGSERV is
  -- *****************************************************************
  -- Nombre                     : PQ_ENV_EXTRAC_PAGSERV
  -- Sistema                    : BANTOTAL
  -- Módulo                     : BELE
  -- Versión                    : 1.0
  -- Fecha de Creación          : 25/02/2014
  -- Autor de Creación          : Chernandez.
  -- Uso                        : Generar y enviar extractos de pagos de servicios por correo
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      : 26/06/2014
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Fecha de Modificación      : 11/01/2016
  -- Autor de la Modificación   : HLAQUI
  -- Descripción de Modificación: Se agrega condición para que no envíe correo cuando sea empresa 8 (BACKUS)
  -- Fecha de Modificación      : 01/12/2016
  -- Autor de la Modificación   : CHERNANDEZ
  -- Descripción de Modificación: Se cambio el formato de hora
  -- Fecha de Modificación      : 22/08/2017
  -- Autor de la Modificación   : HLAQUI
  -- Descripción de Modificación: Se modifica logica para obtener los correos destinatarios  
  -- Fecha de Modificación      : 12/10/2020
  -- Autor de la Modificación   : HLAQUI
  -- Descripción de Modificación: Se obtiene la data de la JAQY220
  -- Fecha de Modificación      : 11/12/2023
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se cambia el server de envio de correos y se diferencia por empresa
  -- *****************************************************************

  --create or replace TYPE ArrayCabecera IS TABLE OF varchar2(250); 
  --create public synonym PQ_ENV_EXTRAC_PAGSERV for BTDESA3008.PQ_ENV_EXTRAC_PAGSERV;
  procedure sp_enviar_correo(p_n_codesv in number,
                             p_n_codtsv in number,
                             p_c_user   in char,
                             p_d_fecha  in date,
                             p_c_msgerr out varchar2) is
    cursor deta(cp_c_user in varchar) is
      select JAQY220cor,
             JAQY220usu,
             JAQY220mov,
             JAQY220fmv,
             JAQY220cct,
             JAQY220fvl,
             JAQY220dsc,
             JAQY220doc,
             JAQY220dep,
             JAQY220ret,
             JAQY220sdo,
             JAQY220ope,
             JAQY220age,
             JAQY220hor,
             JAQY220ndp,
             JAQY220TMO SCMOD,
             JAQY220TTR STRAN,
             JAQY220TRE SNREL,
             JAQY220omd,
             JAQY220TSU
        from JAQY220
       where trim(JAQY220USU) = trim(cp_c_user)       
       order by JAQY220FMV,JAQY220HOR,JAQY220OMD,JAQY220COR;
      /* 
      select jaql867cor,
             jaql867usu,
             jaql867mov,
             jaql867fmv,
             jaql867cct,
             jaql867fvl,
             jaql867dsc,
             jaql867doc,
             jaql867dep,
             jaql867ret,
             jaql867sdo,
             jaql867ope,
             jaql867age,
             jaql867hor,
             jaql867ndp,
             to_number(substr(jaql867ndp,1,3)) SCMOD,
             to_number(substr(jaql867ndp,4,3)) STRAN,
             to_number(substr(jaql867ndp,7,4)) SNREL,
             jaql867omd,
             jaql867suc
        from jaql867
       where trim(jaql867USU) = trim(cp_c_user)
         --and JAQL867FMV = dp_fecha
       order by jaql867cor asc;
       */
    cursor destinatarios(cp_codemp in number,cp_codser in number) is
       select trim(a.tp1desc) || '@' || trim(b.tp1desc) tp1desc
        from fst198 a
       inner join fst198 b
          on a.tp1nro2 = b.tp1corr2
         and b.tp1cod = 1
         and b.tp1cod1 = 10801
         and b.tp1corr1 = 35
         and b.tp1corr3 = 0
       where a.tp1cod = 1
         and a.tp1cod1 = 10801
         and a.Tp1corr1 = 7
         and a.tp1corr2 = cp_codemp
         and a.tp1nro1 = cp_codser
         and a.tp1nro3=1; --Solo VIGENTES
  
    cursor cabecera is
      select * 
        from jaqy565 
        where jaqy565COENT = p_n_codesv --fpinto 11/12/2023 se diferencia por empresa
        order by jaqy565cod asc;
    
    cursor asunto is
      select trim(tp1desc) tp1desc
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 7;
         
    cursor cuerpo is
      select trim(tp1desc) tp1desc
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 8;
         
    cursor nombreArc is
      select trim(tp1desc) tp1desc
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 9;
  
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
    --p_c_msgerr    VARCHAR2(1000);
    vhost_name    VARCHAR2(100);
    rawData       RAW(32000);
    cant          number;
    corr          number;
    v_sumin       varchar2(20);
    v_serv        varchar2(60);
    v_emp         varchar2(60);
    remitente     varchar2(30);
    fecha         date;
    countDest     number;
		v_found number;
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
    fecha := p_d_fecha;   
		
		SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);

    --select pgfape-1 into fecha from fst017 where pgcod = 1;
    
    --IF UPPER(VHOST_NAME) IN ('BTRAC1051','BTRAC1052','PPDB1051','DSBD1051') and p_n_codesv not in(8) THEN
--    IF UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052') and p_n_codesv not in(8) THEN
--    IF UPPER(VHOST_NAME) IN ('BTRAC2051','BTRAC2052','BTRAC4051','DSBD1051','PPDB1051') and p_n_codesv not in(8) THEN
--    IF UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') and p_n_codesv not in(8) THEN    
--    if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') and p_n_codesv not in(8) THEN    
  if v_found =1 then
      select jaql508abent
        into v_emp
        from jaql508
       where jaql508coent = p_n_codesv;
       
      select jaql514detsv
        into v_serv
        from jaql514
       where jaql514cotsv = p_n_codtsv;
      
      select trim(tp1desc) tp1desc
        into remitente
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 4
         and tp1corr3 = 1;
         
      select trim(tp1desc) tp1desc
        into v_Recipient
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 5
         and tp1corr3 = 1;
         
      select trim(tp1desc) tp1desc
        into C_SMTP_SERVER
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 1 --fpinto 11/12/2023 cambio de server de envio de correos
         and tp1corr3 = 1;
         
      select trim(tp1desc) tp1desc
        into C_SMTP_PORT
        from fst198
       where tp1cod1 = 10801
         and Tp1corr1 = 6
         and Tp1corr2 = 2
         and tp1corr3 = 1;
         
      v_From      := remitente;
      --C_SMTP_SERVER := '10.0.0.49';
      --C_SMTP_PORT := '25';
      --v_Recipient := 'chernandez@cajaarequipa.pe';
      --        v_Recipient := 'ehidalgom@cajaarequipa.pe';
      
      v_Subject := '';
      For asu in asunto loop
          v_Subject := v_Subject || asu.tp1desc;
      end loop;
      
      
      v_Subject     := v_Subject || ' ' || v_emp || ' - ' || v_serv || ' ' ||
                       to_char(fecha, 'yyyy.mm.dd');--yyyy.mm.dd hh24:mi:ss
      --C_SMTP_SERVER := '172.20.100.13';
      V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, C_SMTP_PORT);
      msg           := 'Date: ' ||
                       to_char(sysdate + 0.208333333, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                       utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                       'Subject: ' || v_Subject || utl_tcp.crlf || 'To: ' ||
                       '' || utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      countDest := 0;
      for dest in destinatarios(p_n_codesv,p_n_codtsv) loop
        utl_smtp.Rcpt(V_Conexion, dest.tp1desc);
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
                          utl_tcp.crlf || utl_tcp.crlf || v_Body|| ' '  || v_emp || ' - ' || v_serv 
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
                          to_char(fecha, 'DD-MM-RRRR') || '.xls' ||
                          utl_tcp.crlf || utl_tcp.crlf);
                          
      select count(*) into cant from jaqy565 where jaqy565COENT = p_n_codesv; --fpinto 11/12/2023 se diferencia por empresa
      cant := cant - 4;
      
      for cab in cabecera() loop
        if(cab.jaqy565cod <= cant)then
          v_header := cab.jaqy565desc;
          utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
        End If;
      end loop;
      corr := 1;
      for r_trab in deta(p_c_user) loop
        v_sumin := fn_obtener_contrato(r_trab.JAQY220TSU,r_trab.SCMOD,r_trab.stran,r_trab.snrel,r_trab.JAQY220FMV,p_n_codesv,p_n_codtsv);
        --v_sumin := '';
        v_wstring := corr || chr(9) || r_trab.JAQY220mov || chr(9) || 
                     to_char(r_trab.JAQY220fmv,'DD/MM/YYYY') || chr(9) || r_trab.JAQY220cct || chr(9) ||
                     to_char(r_trab.JAQY220fvl,'DD/MM/YYYY') || chr(9) || r_trab.JAQY220dsc || chr(9) || 
                     r_trab.JAQY220doc || chr(9) || r_trab.JAQY220dep || chr(9) || 
                     r_trab.JAQY220ret || chr(9) || r_trab.JAQY220sdo || chr(9) ||
                     v_sumin || chr(9);
                           
        --utl_smtp.write_data(V_Conexion,v_wstring||utl_tcp.crlf);
        -- transforma el v_wstring en RAW y escribe el cuerpo del correo
        rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        corr:= corr + 1;
      end loop;
      
      v_header := '';
      utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
      
      for cab in cabecera() loop
        if(cab.jaqy565cod > cant)then
          v_header := cab.jaqy565desc;
          utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
        End If;
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
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
  END sp_enviar_correo;
  
  function fn_obtener_contrato(p_suc number,
                               p_mod number,
                               p_tra number,
                               p_rel number,
                               p_fec date,
                               p_ent number,
                               p_ser number) return varchar2 is
    v_sumin VARCHAR2(20);
  begin
    v_sumin := '';
  begin
    select JAQL515SUMIN
      into v_sumin
      from jaql515
     Where JAQL515COENT = p_ent
       and JAQL515COTSV = p_ser
       and JAQL515PGSUC = p_suc
       and JAQL515SCMOD = p_mod
       and JAQL515STRAN = p_tra
       and JAQL515SNREL = p_rel
       and JAQL515ESREG = 'V'
       and JAQL515FEMOV = p_fec;
     --order by JAQL515PGSUC, JAQL515SCMOD, JAQL515STRAN, JAQL515FEMOV;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_sumin := '';
    
  end;
  return v_sumin;
  end fn_obtener_contrato;


end PQ_ENV_EXTRAC_PAGSERV;
/

