CREATE OR REPLACE PACKAGE PQ_CR_SORTEO_PAG_PUNTUAL IS

  -- *****************************************************************
  -- Nombre                     : pq_cr_sorteo_pag_puntual
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 4/11/2024 
  -- Autor de Creación          : Romario Castro - IGS
  -- Uso                        : Envio correo con excel adjunto para sorteo de pagos puntuales
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : --
  -- Parámetros de Salida       : --
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   :
  -- Descripción de Modificación: 
  -- *****************************************************************     

  PROCEDURE SP_GENRA_NOTIFIC_PAG_PUNTUAL_NAV24;

  PROCEDURE SP_JOB_CARGA_NOTIFI;

  -----------------------------------------------------------------------
  procedure sp_cr_config_mail( ------------------------
                              p_c_de         in varchar2, -- De    
                              p_c_recipiente in varchar2, -- Para
                              subject        in varchar2, -- Subject
                              -------------------------                            
                              fecha_proceso in date, -- Fecha de proceso
                              --------------------                           
                              v_header in varchar2, -- Cabecera
                              rawdata  in clob -- Detalle Excel
                              );
  -----------------------------------------------------------------------
  procedure sp_cr_mail_root(p_c_de         in varchar2, -- De
                            p_c_recipiente in varchar2, -- Para
                            subject        in varchar2, -- Subject
                            fecha_proceso  in date, -- Fecha de Proceso
                            --------------------
                            c_smtp_server in varchar2, -- Ip
                            port          in NUMBER, -- Puerto
                            host          in varchar2, -- Host
                            --------------------                            
                            v_header in varchar2, -- Cabecera
                            rawdata  in clob -- Detalle Excel
                            );
  -----------------------------------------------------------------------

END PQ_CR_SORTEO_PAG_PUNTUAL;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_SORTEO_PAG_PUNTUAL IS

  PROCEDURE SP_GENRA_NOTIFIC_PAG_PUNTUAL_NAV24 IS
    -----------------------------------------------------------------------
    CURSOR CORREOS IS
      SELECT TP1DESC corrDesc
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 210
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1; -- PARA LOS DESTINATARIOS PRINCIPALES  TP1CORR2 = 1, Y TP1CORR2 = 2 SON EN COPIAS CC   
    -----------------------------------------------------------------------
    CURSOR PAGOS(XFECHA DATE) IS
      select DISTINCT J.AQPB184PAIS PAIS,
                      J.AQPB184TDOC TIDOC,
                      J.AQPB184NDOC NRDOC,
                      J.AQPB184NOMB NOMCLI,
                      J.AQPB184CTA NRCTA,
                      J.AQPB184OPE OPERACION,
                      J.AQPB184FCALND FECCUOTA,
                      J.AQPB184FPAGO FECPAGO,
                      J.AQPB184SUC SUCURSAL,
                      J.AQPB184DPTO DEPTARTMTO,
                      J.AQPB184OPCNS NROOPCIONES
        from AQPB184 J
       WHERE J.AQPB184FCHCAR = XFECHA;
    -----------------------------------------------------------------------   
    --------------------          
    SUBJECT VARCHAR2(1000);
    --------------------              
    V_HEADER  VARCHAR2(10000); -- CABECERA
    V_WSTRING CLOB;
    DATA      VARCHAR2(32000);

    --------------------

    REMITENTE     VARCHAR(80);


    V_DOMINIOCORR VARCHAR2(30);
    ----------------------


    LV_DESTINOS VARCHAR2(80);
    CONTADOR    NUMBER(9) := 0;
    V_NOMSUCUR  VARCHAR2(30);
    FECMAXB184  DATE;
  

    v_filename VARCHAR2(100);
  
  BEGIN
  
    BEGIN
      SELECT TP1DESC
        INTO V_DOMINIOCORR
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 210
         AND TP1CORR2 = 0
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        V_DOMINIOCORR := '';
    END;
  
    V_DOMINIOCORR := TRIM(V_DOMINIOCORR);
  
    BEGIN
      SELECT TP1DESC
        INTO REMITENTE
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 210
         AND TP1CORR2 = 0
         AND TP1CORR3 = 2;
    EXCEPTION
      WHEN OTHERS THEN
        REMITENTE := '';
    END;
    REMITENTE := TRIM(REMITENTE);
  
    REMITENTE := REMITENTE || V_DOMINIOCORR;
  
    LV_DESTINOS := '';
    FOR reg_corr IN CORREOS LOOP
      IF trim(reg_corr.corrdesc) IS NOT NULL THEN
        IF LV_DESTINOS IS NULL THEN
          LV_DESTINOS := LV_DESTINOS || trim(reg_corr.corrdesc) ||
                         V_DOMINIOCORR; -- || ';';
        ELSE
          LV_DESTINOS := LV_DESTINOS || ';' || trim(reg_corr.corrdesc) ||
                         V_DOMINIOCORR; -- || ';';               
        END IF;
      END IF;
    END LOOP;

  
    FECMAXB184 := '';
    BEGIN
      SELECT MAX(AQPB184FCHCAR) INTO FECMAXB184 FROM AQPB184;
    EXCEPTION
      WHEN OTHERS THEN
        FECMAXB184 := '';
    END;
    --------------------------------------------------------------------
  
    IF FECMAXB184 IS NOT NULL THEN
    
      subject := 'Sorteo Pagos Puntuales - ' ||
                 to_char(FECMAXB184, 'yyyy/mm/dd');
      -- Nombre del archivo Excel
      v_filename := 'Sorteo_PagoPuntual_' ||
                    to_char(FECMAXB184, 'DD-MM-RR') || '.xls';
    
      -- Encabezados MIME
      v_header := 'MIME-Version: 1.0' || utl_tcp.crlf -- Use MIME mail standard
                  || 'Content-Type: multipart/mixed;' || utl_tcp.crlf ||
                  ' boundary=-----SECBOUND' || utl_tcp.crlf || utl_tcp.crlf ||
                  '-------SECBOUND' || utl_tcp.crlf ||
                  'Content-Type: text/plain;' || utl_tcp.crlf ||
                  'Content-Transfer_Encoding: 8bit' || --8bit
                  utl_tcp.crlf || utl_tcp.crlf || 'Estimados,' || CHR(13) ||
                  'Se adjunta el listado de pagos puntuales al cierre del ' ||
                  to_char(FECMAXB184, 'DD/MM/RRRR') || '.' || CHR(13) ||
                  CHR(13) || CHR(13) || '   ' || utl_tcp.crlf --Message Body                           
                  || '-------SECBOUND' || utl_tcp.crlf ||
                  'Content-Type: text/plain; charset=iso-8859-1' ||
                  utl_tcp.crlf || ' name=RELACION_TRABCESE_' ||
                  to_char(sysdate, 'DD-MM-RR') || utl_tcp.crlf --xls
                  || 'Content-Transfer_Encoding: 8bit' || --8bit
                  utl_tcp.crlf || 'Content-Disposition: attachment;' ||
                  utl_tcp.crlf || ' filename=' || v_filename ||
                  utl_tcp.crlf || utl_tcp.crlf;
      ------------------------------------------------------------------------------                       
      v_header := v_header || '  ' || chr(9) || 'PAIS' || chr(9) || 'TDOC' ||
                  chr(9) || 'NDOC' || chr(9) || 'NOMBRE CLIENTE' || chr(9) ||
                  'CUENTA' || chr(9) || 'OPERACION' || chr(9) ||
                  'FCH_CUOTA' || chr(9) || 'FECH_OPERACION' || chr(9) ||
                  'AGENCIA' || chr(9) || 'DPTO' || chr(9) || 'NRO_OPCIONES';
    
      FOR datos IN PAGOS(FECMAXB184) LOOP
        V_NOMSUCUR := '';
        CONTADOR   := CONTADOR + 1;
      
        begin
          SELECT SCNOM into V_NOMSUCUR FROM REGSUC WHERE SUCURS = 1;
        EXCEPTION
          WHEN OTHERS THEN
            V_NOMSUCUR := '';
        end;
      
        data := CONTADOR || chr(9) || datos.pais || chr(9) || datos.tidoc ||
                chr(9) || '="' || datos.nrdoc || '" ' || chr(9) ||
                datos.nomcli || chr(9) || datos.nrcta || chr(9) ||
                datos.operacion || chr(9) || datos.feccuota || chr(9) ||
                datos.fecpago || chr(9) || V_NOMSUCUR || chr(9) ||
                datos.deptartmto || chr(9) || datos.nroopciones ||
                utl_tcp.crlf;
      
        data := replace(data, 'Ñ', 'N');
      
        v_wstring := v_wstring || to_clob(data);
      
      END LOOP;
    
      if v_wstring is not null then
        sp_cr_config_mail(remitente, --de
                          LV_DESTINOS, --LV_DESTINOS, --para
                          subject, -- asunto
                          FECMAXB184, -- 
                          --------------------                           
                          v_header, -- Cabecera
                          v_wstring -- Detalle Excel
                          );
      end if;
    END IF;
  END;
  -----------------------------------------------------------------------

  PROCEDURE SP_JOB_CARGA_NOTIFI IS
    lc_digito   NUMBER;
    lc_hostname varchar2(64);

    lc_variable varchar2(4000);
    ln_job      number := 0;


    ln_numjob   number(5);
  
  BEGIN
    lc_digito := 9;
    --PROCESO DE CARGA AQPB184
    begin
      select host_name into lc_hostname from v$instance;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    end;
    for i in 0 .. lc_digito loop
    
      lc_variable := ' begin ' ||
                     ' pq_cr_sorteo_pyme2020.sp_cr_nav24pagos(' || i || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;
    
      BEGIN
        IF SYS.FN_BD_ISRAC = 'TRUE' THEN
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          instance  => 1,
                          force     => false);
        else
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          force     => false);
        end if;
        commit;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
    
    ln_numjob := 0;
    
    begin
      SELECT count(*)
        INTO ln_numjob
        FROM dba_jobs x
       WHERE upper(x.what) LIKE '%PQ_CR_SORTEO_PYME2020.SP_CR_NAV24PAGOS%';
    exception
      when others then
        ln_numjob := 0;
    end;
  
    While ln_numjob > 0 loop
      begin
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE
               '%PQ_CR_SORTEO_PYME2020.SP_CR_NAV24PAGOS%';
      exception
        when others then
          ln_numjob := 0;
      end;
    End loop;
  
    ------ENVIAR CORREO
    BEGIN
      PQ_CR_SORTEO_PAG_PUNTUAL.SP_GENRA_NOTIFIC_PAG_PUNTUAL_NAV24;
    EXCEPTION
      when others then
        NULL;
    END;
  
  END;

  -----------------------------------------------------------------------
  procedure sp_cr_config_mail( ------------------------
                              p_c_de         in varchar2, -- De    
                              p_c_recipiente in varchar2, -- Para
                              subject        in varchar2, -- Subject
                              -------------------------                            
                              fecha_proceso in date, -- Fecha de proceso
                              --------------------                           
                              v_header in varchar2, -- Cabecera
                              rawdata  in clob -- Detalle Excel
                              ) is
    --Cursor
    cursor c_host is
      select *
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10825
         and Tp1corr1 = 61
         and Tp1corr2 = 7;
    -- Variables
    c_smtp_server VARCHAR2(30);
    port          number;
    host          VARCHAR2(100);
    -- 
    lc_hostname varchar2(64);
    lv_smtp     varchar2(30);
    lv_host     varchar2(30);
    ln_port     number(9);
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      WHEN NO_DATA_FOUND then
        lc_hostname := '';
    end;
  
    For i in c_host loop
      lv_host := upper(TRIM(substr(i.tp1desc, 1, instr(i.tp1desc, '/') - 1)));
      lv_smtp := TRIM(substr(i.tp1desc,
                             instr(i.tp1desc, '/') + 1,
                             length(trim(i.tp1desc))));
      ln_port := i.tp1nro3;
    
      if upper(lc_hostname) = lv_host then
      
        Exit;
      End if;
    End loop;
  
    c_smtp_server := lv_smtp; --'10.0.200.68';
    port          := ln_port; --2530;
  
    host := lv_host;
  
    sp_cr_mail_root(p_c_de, --de
                    p_c_recipiente, --para
                    subject, --subject
                    fecha_proceso, --fecha de procesamiento
                    -------------------------
                    c_smtp_server, -- ip del servidor
                    port, -- puerto del servidor
                    host, -- host del servidor
                    -------------------------                            
                    v_header, -- Cabecera
                    rawdata -- Detalle Excel
                    );
  end;
  -----------------------------------------------------------------------
  procedure sp_cr_mail_root(p_c_de         in varchar2, -- De
                            p_c_recipiente in varchar2, -- Para
                            subject        in varchar2, -- Subject
                            fecha_proceso  in date, -- Fecha de Proceso
                            --------------------
                            c_smtp_server in varchar2, -- Ip
                            port          in NUMBER, -- Puerto
                            host          in varchar2, -- Host
                            --------------------                            
                            v_header in varchar2, -- Cabecera
                            rawdata  in clob -- Detalle Excel
                            ) is
  
    CURSOR CORREOSCOPIAS IS
      SELECT TP1DESC corrDesc
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 210
         AND TP1CORR2 = 2
         AND TP1CORR3 > 0;  --para los correos de copias
    
    V_DOMINIOCORR varchar2(30);
    V_CORRCOPIAS VARCHAR2(100);
    v_wstring   varchar2(32000);
    auxiliar    varchar2(32000);
    v_From      VARCHAR2(80);
    v_Recipient VARCHAR2(100);
  
    lv_destinosx varchar2(100);
  
    v_Subject  VARCHAR2(80);
    V_Conexion utl_smtp.Connection;
    v_clob     CLOB;
    msg        varchar2(32767);
    p_c_msgerr VARCHAR2(1000);
    vhost_name VARCHAR2(100);
    v_found    number;

    datas      long raw;
    c_mime_boundary CONSTANT VARCHAR2(256) := '--AAAAA000956--';
    l_n_offset NUMBER := 630;
  begin
    v_clob := 'Number' || ',' || 'Name' || UTL_TCP.crlf;
    begin      
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
    exception 
      when others then
        null;
    end;
  
    v_From      := p_c_de;
    v_Recipient := P_C_RECIPIENTE;
    v_Subject   := subject;
   
  begin
    SELECT count(*)
      into v_found
      FROM systabrep.hostnames
     where habilitado = 'S'
       and upper(host_name) = UPPER(vhost_name);
  exception 
    when others then
      null;
  end;

    BEGIN
      SELECT TP1DESC
        INTO V_DOMINIOCORR
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 210
         AND TP1CORR2 = 0
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        V_DOMINIOCORR := '';
    END;
  
    V_DOMINIOCORR := TRIM(V_DOMINIOCORR);  
    lv_destinosx := '';
    For k in correosCopias loop 
       IF  trim(k.corrdesc) IS NOT NULL THEN                               
            lv_destinosx := lv_destinosx||trim(k.corrdesc)|| V_DOMINIOCORR || ';';     
       END IF;
    End loop;
    
    if lv_destinosx is not null  then   
      lv_destinosx := substr(lv_destinosx,1,length(lv_destinosx)-1);   
    End If; 
  
    if v_found = 1 then
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, Port);
      msg        := 'Date: ' ||
                    to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                    utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                    'Subject: ' || v_Subject || utl_tcp.crlf || 'CC:' ||
                    lv_destinosx || utl_tcp.crlf || 'To: ' || v_Recipient ||
                    utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      utl_smtp.Rcpt(V_Conexion, v_Recipient); -- correo principal destinatario
      
    
      For m in CorreosCopias loop  --enviar a los copias
          IF  trim(m.corrdesc) IS NOT NULL THEN                               
            V_CORRCOPIAS := trim(m.corrdesc)|| V_DOMINIOCORR;  
            V_CORRCOPIAS := TRIM(V_CORRCOPIAS);   
             utl_smtp.Rcpt(V_Conexion, V_CORRCOPIAS);  
          END IF;         
      End loop;
      
      --PRUEBA
     /* V_CORRCOPIAS := 'romario.castro@igs.com.pe';
      utl_smtp.Rcpt(V_Conexion, V_CORRCOPIAS);  */
    
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg);
      --Se escribe el contenido del mensaje 
      utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
      FOR loop_att IN 0 .. TRUNC(DBMS_LOB.getlength(rawdata) / l_n_offset) LOOP
        auxiliar := DBMS_LOB.substr(rawdata,
                                    l_n_offset,
                                    loop_att * l_n_offset + 1);
        UTL_SMTP.write_data(V_Conexion, auxiliar);
      END LOOP;
    
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
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000,
                              'Unable to send mail: ' || p_c_msgerr);
  end;
  -----------------------------------------------------------------------

END PQ_CR_SORTEO_PAG_PUNTUAL;
/

