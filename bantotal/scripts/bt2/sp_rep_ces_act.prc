CREATE OR REPLACE PROCEDURE sp_rep_ces_act (P_C_RECIPIENTE  IN VARCHAR2) is
    cursor c_users is
      SELECT T3.NU_DOCU_IDEN DNI,    
       t9.co_cent_cost,
       t1.co_trab CODIGO_TRABAJADOR,
            T2.NO_APEL_PATE || ' ' || T2.NO_APEL_MATE apellidos,
    T2.NO_TRAB AS nombres, 
    T1.CO_PUES_TRAB cod_puesto,
    T4.DE_PUES_TRAB PUESTO,
    t1.co_sede,
    T5.de_sede SEDE,
    t1.co_area,
    t6.de_area AREA,
    t1.co_secc,
    t7.de_secc SECCION,
    t1.fe_ingr_empr  FECHA_INGRESO,
    T1.fe_cese_trab FECHA_CESE,
    t2.no_dire_mai1 MAIL,
    case when t1.TI_SITU = 'ANU' then 'CESADO' else 'ACTIVO' end estado, 
    t1.co_unid,
    t8.de_unid
FROM TMTRAB_EMPR@OFIPLAN T1,
     TDIDEN_TRAB@OFIPLAN T3, 
     TMTRAB_PERS@OFIPLAN T2,
     TTPUES_TRAB@OFIPLAN T4,
     ttsede@OFIPLAN T5,
     ttarea@OFIPLAN T6,
     ttsecc@OFIPLAN T7,
     TMUNID_EMPR@OFIPLAN  T8,
     tdccos_trab@Ofiplan t9
WHERE     (T1.CO_PLAN in ('EMP','PTM', 'EJE') and T1.TI_SITU='ANU')
          and (T1.CO_TRAB = T3.CO_TRAB AND T3.TI_DOCU_IDEN = 'DNI' )
          and (T1.CO_TRAB = T2.CO_TRAB )
          and T1.fe_cese_trab > (select to_date(sysdate-to_char(sysdate,'DD'),'DD.MM.YY') from dual) 
          and T1.CO_EMPR = T4.CO_EMPR AND T1.CO_PUES_TRAB = T4.CO_PUES_TRAB 

          and t5.co_sede = t1.co_sede
          and t6.co_area = t1.co_area
          and t6.co_depa = t1.co_depa

          and t7.co_area = t1.co_area
          and t7.co_secc = t1.co_secc
          and t7.co_depa = t1.co_depa
          
          and t8.co_empr = t1.co_empr
          and t8.co_unid = t1.co_unid
          
          and t9.co_empr(+) = t1.co_empr
          and t9.co_trab(+) = T1.CO_TRAB
          and t9.ti_auxi_empr(+) = 'K'
          and t9.st_repo(+) = 'S'

union 
SELECT T3.NU_DOCU_IDEN DNI,    
       t9.co_cent_cost,
       t1.co_trab CODIGO_TRABAJADOR,
            T2.NO_APEL_PATE || ' ' || T2.NO_APEL_MATE apellidos,
    T2.NO_TRAB AS nombres, 
    T1.CO_PUES_TRAB cod_puesto,
    T4.DE_PUES_TRAB PUESTO,
    t1.co_sede,
    T5.de_sede SEDE,
    t1.co_area,
    t6.de_area AREA,
    t1.co_secc,
    t7.de_secc SECCION,
    t1.fe_ingr_empr  FECHA_INGRESO,
    T1.fe_cese_trab FECHA_CESE,
    t2.no_dire_mai1 MAIL,
    case when t1.TI_SITU = 'ANU' then 'CESADO' else 'ACTIVO' end estado, 
    t1.co_unid,
    t8.de_unid
FROM TMTRAB_EMPR@OFIPLAN T1,
     TDIDEN_TRAB@OFIPLAN T3, 
     TMTRAB_PERS@OFIPLAN T2,
     TTPUES_TRAB@OFIPLAN T4,
     ttsede@OFIPLAN T5,
     ttarea@OFIPLAN T6,
     ttsecc@OFIPLAN T7,
     TMUNID_EMPR@OFIPLAN  T8,
     tdccos_trab@Ofiplan t9
WHERE     (T1.CO_PLAN in ('EMP','PTM', 'EJE') and T1.TI_SITU='ACT')
--          and (T1.CO_TRAB = T3.CO_TRAB AND T3.TI_DOCU_IDEN = 'DNI' )
          and (T1.CO_TRAB = T3.CO_TRAB AND T3.TI_DOCU_IDEN in ('DNI','PAS') )--22.11.2021 JSANCHEZ
          and (T1.CO_TRAB = T2.CO_TRAB )
          and (T4.CO_EMPR = T1.CO_EMPR and T4.CO_PUES_TRAB = T1.CO_PUES_TRAB)
          and t5.co_sede = t1.co_sede
          and t6.co_area = t1.co_area
          and t6.co_depa = t1.co_depa

          and t7.co_area = t1.co_area
          and t7.co_secc = t1.co_secc
          and t7.co_depa = t1.co_depa

          and t8.co_empr = t1.co_empr
          and t8.co_unid = t1.co_unid

          and t9.co_empr(+) = t1.co_empr
          and t9.co_trab(+) = T1.CO_TRAB
          and t9.ti_auxi_empr(+) = 'K'
          and t9.st_repo(+) = 'S';


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
--    c_dni VARCHAR2(100);
    v_found NUMBER := 0;
    n_Port number;
BEGIN
    SELECT HOST_NAME
      INTO VHOST_NAME
    FROM V$INSTANCE;


    SELECT count(*) into v_found
    FROM systabrep.hostnames
    where habilitado = 'S' and upper(host_name)=UPPER(VHOST_NAME);

--    If  UPPER(vhost_name) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051'/*DGLIMA*/) then
    if v_found =1 then
        v_From      := 'alertausersbt@cajaarequipa.pe';
        v_Recipient := P_C_RECIPIENTE;
				v_Subject   := 'Relacion de Cesados-Activos_'||to_char(sysdate-1, 'yyyy.mm.dd');
        C_SMTP_SERVER := '10.0.200.68';
        n_Port:=2528;
  select host_name into C_SMTP_SERVER from  systabrep.hostnames_mail where habilitado='S';
  select port into n_Port from  systabrep.hostnames_mail where habilitado='S';


--        V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, 2528);
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
                              utl_tcp.crlf || utl_tcp.crlf || 'Adj. Relación de Trabajadores Cesados - Activos ' || to_char(sysdate-1, 'DD-MM-RRRR') ||  CHR(13)
--                              || CHR(13) || CHR(13) || 'Las comillas simples ('') se agregaron al inicio de las celdas del excel para reconocer los ceros de adelante.' || utl_tcp.crlf); --Message Body
                              || CHR(13) || utl_tcp.crlf); --Message Body
          utl_smtp.write_data(V_Conexion,
                              '-------SECBOUND' || utl_tcp.crlf ||
                              --'Content-Type: text/plain;' || utl_tcp.crlf);--
                              'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              ' name=REL_TRAB_CES_ACT_' || to_char(sysdate-1, 'DD-MM-RR') || utl_tcp.crlf); --xls
          utl_smtp.write_data(V_Conexion,
                              'Content-Transfer_Encoding: 8bit' ||--8bit
                              utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              'Content-Disposition: attachment;' ||
                              utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              ' filename=REL_TRAB_CES_ACT_' || to_char(sysdate-1, 'DD-MM-RR')||'.xls'|| utl_tcp.crlf ||
                              utl_tcp.crlf);

        v_header :='DNI'||chr(9)||'CO_CENT_COST'||chr(9)||'CODIGO_TRABAJADOR'||chr(9)||'APELLIDOS'||chr(9)||'NOMBRES'||chr(9)||
                   'COD_PUESTO'||chr(9)||'PUESTO'||chr(9)||'CO_SEDE'||chr(9)||'SEDE'||chr(9)||'CO_AREA'||chr(9)||'AREA'||chr(9)||
									 'CO_SECC'||chr(9)||'SECCION'||chr(9)||'FECHA_INGRESO'||chr(9)||'FECHA_CESE'||chr(9)||'MAIL'||chr(9)||'ESTADO'||chr(9)||'CO_UNID'||chr(9)||'DE_UNID';
        utl_smtp.write_data(V_Conexion,v_header||utl_tcp.crlf);

        for r_trab in c_users loop
             v_wstring := ''''||r_trab.dni||chr(9)||''''||r_trab.co_cent_cost||chr(9)||r_trab.codigo_trabajador||chr(9)||r_trab.apellidos||chr(9)||r_trab.nombres||chr(9)||''''||r_trab.cod_puesto||chr(9)||r_trab.puesto||chr(9)||''''||r_trab.co_sede||chr(9)||r_trab.sede||chr(9)||''''||r_trab.co_area||chr(9)||r_trab.area||chr(9)||''''||r_trab.co_secc||chr(9)||r_trab.seccion||chr(9)||to_char(r_trab.fecha_ingreso,'dd/mm/rrrr')||chr(9)||to_char(r_trab.fecha_cese,'dd/mm/rrrr')||chr(9)||r_trab.mail||chr(9)||r_trab.estado||chr(9)||''''||r_trab.co_unid||chr(9)||r_trab.de_unid;
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
    end if;
EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || p_c_msgerr);
end sp_rep_ces_act;
/

