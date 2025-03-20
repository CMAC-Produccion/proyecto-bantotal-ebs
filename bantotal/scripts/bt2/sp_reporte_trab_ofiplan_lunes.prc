create or replace procedure SP_REPORTE_TRAB_OFIPLAN_LUNES IS
  --Declaracion de variables
  cursor c_trab is
    select a.CO_TRAB CO_TRAB,
           a.NU_DOCU_IDEN NU_DOCU_IDEN,
           a.NO_APEL_PATE NO_APEL_PATE,
           a.NO_APEL_MATE NO_APEL_MATE,
           a.NO_TRAB NO_TRAB,
           a.CO_PUES_TRAB C_CODCAR,
           a.DE_PUES_TRAB C_DESCAR,
           a.fe_ingr_empr D_FECING
    FROM TRAB_OFIPLAN A
    order by a.CO_TRAB;

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

        DELETE trab_ofiplan;
        COMMIT;
        INSERT INTO trab_ofiplan
        select t_trab.co_trab,
               t_iden.nu_docu_iden,
               t_dape.no_apel_pate,
               t_dape.no_apel_mate,
               t_dape.no_trab,
               t_trab.co_pues_trab,
               t_pues.de_pues_trab,
               t_trab.fe_ingr_empr
        from tmtrab_empr@ofiplan t_trab,
             tmtrab_pers@ofiplan t_dape,
             tdiden_trab@ofiplan t_iden,
             ttpues_trab@ofiplan t_pues
        where t_trab.ti_situ='ACT'
              and t_trab.co_empr = '01'
              and t_trab.co_plan in ('EMP','PTM','EJE','PRA')
              and t_dape.co_trab = t_trab.co_trab
              and t_iden.co_trab = t_trab.co_trab
              and t_iden.ti_docu_iden = 'DNI'
              and t_pues.co_empr = t_trab.co_empr
              and t_pues.co_pues_trab = t_trab.co_pues_trab
         order by t_iden.nu_docu_iden,
               t_dape.no_apel_pate,
               t_dape.no_apel_mate;
        COMMIT;

        v_From      := 'bantoem@cajaarequipa.pe';
        v_Recipient := 'lrodriguez@cajaarequipa.pe';--'ehidalgom@cajaarequipa.pe';
--        v_Recipient := 'ehidalgom@cajaarequipa.pe';
        v_Subject   := 'Relacion de Trabajadores OFIPLAN '||to_char(sysdate, 'yyyy.mm.dd hh24:mi:ss');
--        C_SMTP_SERVER := '172.18.100.13';
--        C_SMTP_SERVER := '172.20.100.13';
          --22.09.2016
          C_SMTP_SERVER := '10.0.200.68';
          n_Port := 2528;
        
        select host_name into C_SMTP_SERVER from  systabrep.hostnames_mail where habilitado='S';
        select port into n_Port from  systabrep.hostnames_mail where habilitado='S';  

--        V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, 2528);
        V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, n_Port);
        msg           := 'Date: ' ||to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||utl_tcp.crlf ||
                         'From: ' || v_From || utl_tcp.crlf ||
                         'Subject: ' || v_Subject || utl_tcp.crlf ||
                         'To: ' || 'Luis Mauricio Rodriguez Bedoya' || utl_tcp.crlf;

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
                              utl_tcp.crlf || utl_tcp.crlf || 'Adj. Relación de Trabajadores OFIPLAN al ' || to_char(sysdate, 'DD-MM-RRRR') ||  CHR(13)
                              || CHR(13) || CHR(13) || 'Las comillas simples ('') se agregaron al inicio de las celdas del excel para reconocer los ceros de adelante.' || utl_tcp.crlf); --Message Body
          utl_smtp.write_data(V_Conexion,
                              '-------SECBOUND' || utl_tcp.crlf ||
                              --'Content-Type: text/plain;' || utl_tcp.crlf);--
                              'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              ' name=RELACION_TRABOFIP_' || to_char(sysdate, 'DD-MM-RRRR') || utl_tcp.crlf); --xls
          utl_smtp.write_data(V_Conexion,
                              'Content-Transfer_Encoding: 8bit' ||--8bit
                              utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              'Content-Disposition: attachment;' ||
                              utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              ' filename=RELACION_TRAB_OFIPLAN_' || to_char(sysdate, 'DD-MM-RRRR')||'.xls'|| utl_tcp.crlf ||
                              utl_tcp.crlf);

        v_header :='CODIGO_TRAB'||chr(9)||'DOC. IDE.'||chr(9)||'APELLIDO PATERNO'||chr(9)||'APELLIDO MATERNO'||chr(9)||'NOMBRES'||chr(9)||'COD. CARGO'||chr(9)||'DES. CARGO'||chr(9)||'FEC. INGRESO';

        utl_smtp.write_data(V_Conexion,v_header||utl_tcp.crlf);

        for r_trab in c_trab loop
             v_wstring := ''''||r_trab.CO_TRAB||chr(9)||''''||r_trab.NU_DOCU_IDEN||chr(9)||r_trab.NO_APEL_PATE||chr(9)||r_trab.NO_APEL_MATE||chr(9)||
                     r_trab.NO_TRAB||chr(9)||r_trab.C_CODCAR||chr(9)||r_trab.C_DESCAR||chr(9)||to_char(r_trab.D_FECING,'RRRR/MM/DD');

          --utl_smtp.write_data(V_Conexion,v_wstring||utl_tcp.crlf);
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

END SP_REPORTE_TRAB_OFIPLAN_LUNES;
/

