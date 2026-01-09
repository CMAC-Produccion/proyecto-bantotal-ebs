create or replace package "PQ_CR_ENVIAR_CORREOS" is

    -- *****************************************************************
    -- Nombre                     : Enviar correo a trabajadores con CC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.07.25
    -- Autor de Creación          : BKLAUER
    -- Uso                        : Envía correos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 14/11/2023
    -- Autor de la Modificación   : Ylozada
    -- Descripción de Modificación: Se eliminó la restricción de no enviar a gerentes y gerentes de linea
    -- Fecha de Modificación      : 27/03/2024
    -- Autor de la Modificación   : Ylozada
    -- Descripción de Modificación: Se creo el proceso sp_ah_notifica_fraude para notificar psoible fraude
    -- Fecha de Modificación      : 11/06/2024
    -- Autor de la Modificación   : Ylozada
    -- Descripción de Modificación: Se adicionó control de correo destino
    -- Fecha de Modificación      : 28/06/2024
    -- Autor de la Modificación   : Ylozada
    -- Descripción de Modificación: Se corrigió query de sp_ah_verifica_trab    
    -- Fecha de Modificación      : 30/12/2025
    -- Autor de la Modificación   : Ylozada
    -- Descripción de Modificación: Se deshabilitó envio de correo del reporte de rotación.    
    --
    -- *****************************************************************     
  function fn_cr_leer_usuario_empleado(num_dni varchar2) return varchar2;
  function fn_cr_leer_correo_jefe(num_dni varchar2) return varchar2;
  procedure sp_cr_envia_correo_empleado(pc_de      varchar2,
                                        pc_aquien  varchar2,
                                        pc_cc1     varchar2,
                                        pc_cc2     varchar2,
                                        pc_asunto  varchar2,
                                        pc_mensaje varchar2);
  procedure actualiza_estado_empleado(num_dni varchar2, estado char);
  procedure notificar_empleados;
  procedure sp_cl_cargo_ofiplan(num_dni  in varchar2,
                                pc_cargo out varchar2,
                                p_c_flag out varchar2);
  Procedure sp_ah_notifica_rrhh(P_D_FECPRO IN DATE,
                                P_D_FECRCC IN DATE,
                                P_C_NOMARC IN VARCHAR2,
                                P_C_CODCAR IN VARCHAR2,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2);
  Procedure sp_cr_generadata(P_N_NUMIMP IN NUMBER,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2);
  procedure sp_cl_cargo_ofiplan_lin(num_dni   in varchar2,
                                    pc_codcar in varchar2,
                                    pc_cargo  out varchar2,
                                    p_c_flag  out varchar2);
  procedure sp_cl_validarotacion(P_D_FECPRO IN DATE,
                                 P_D_FECING IN DATE,
                                 p_c_indrot out varchar2);
  procedure sp_cr_genera_rotacion(P_C_MODO   IN VARCHAR2,
                                  P_D_FECPRO IN DATE,  
                                  P_C_CODUSU IN VARCHAR2,
                                  p_c_coderr out varchar2,
                                  p_c_msgerr out varchar2
                                 );     
  Procedure sp_ah_notifica_rota(P_D_FECPRO IN DATE,
                                P_C_NOMARC IN VARCHAR2,
                                P_C_CODTIP IN VARCHAR2,
                                P_C_CODMOD IN VARCHAR2,                                                                
                                P_C_CODUSU IN VARCHAR2,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2);
  Procedure sp_ah_verifica_trab;
  Procedure sp_ah_valida_CON_DIR; 
  Procedure sp_ah_reprocesa_mail(P_N_CODPRO IN NUMBER, --CODIGO DE PROCESO
                                 P_C_ASUNTO IN VARCHAR2, --ASUNTO 
                                 P_C_DESPAR IN VARCHAR2, --DESTINATARIOS (PARA)
                                 P_C_DESCOC IN VARCHAR2, --DESTINATARIOS (CC)
                                 P_C_DESCCO IN VARCHAR2, --DESTINATARIOS (CCO)
                                 P_C_MENSAJ IN CLOB,     --CUERPO EN HTML
                                 P_C_REMITE IN VARCHAR2, --REMITENTE
                                 P_C_DIRECT IN VARCHAR2, --DIRECTORIO PARA OBTENER LOS ADJUNTOS
                                 P_C_ADJUNT IN VARCHAR2, --LISTADO DE ARCHIVOS SEPARADOS POR ;      
                                 P_N_AUX001 IN NUMBER,   --NUMBER(17,2)    
                                 P_N_AUX002 IN NUMBER,   --NUMBER(17,2)
                                 P_N_AUX003 IN NUMBER,   --NUMBER(9)
                                 P_N_AUX004 IN NUMBER,   --NUMBER(9)
                                 P_D_AUX005 IN DATE,     --DATE
                                 P_D_AUX006 IN DATE,     --DATE
                                 P_C_AUX007 IN VARCHAR2, --VARCHAR2(100)
                                 P_C_AUX008 IN VARCHAR2, --VARCHAR2(100)
                                 P_C_AUX009 IN VARCHAR2, --VARCHAR2(100)
                                 p_c_coderr out varchar2, 
                                 p_c_msgerr out varchar2                                
                                 );   
 Procedure sp_lanza_renvio_mail;                                                                                                                             
 Procedure sp_ah_notifica_fraude(P_D_FECPRO IN DATE,
                                 P_C_HORPRO IN VARCHAR2,
                                 P_N_ITMOD  IN NUMBER,
                                 P_N_ITTRAN IN NUMBER,
                                 P_C_VALOR  IN VARCHAR2,
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2                                 
                                 );
  Procedure sp_ah_valida_transf_cce(P_N_PGCOD  IN NUMBER,
                                    P_N_ITMOD  IN NUMBER,
                                    P_N_ITSUC  IN NUMBER,
                                    P_N_ITTRAN IN NUMBER,
                                    P_N_ITNREL IN NUMBER,
                                    P_D_FECCON IN DATE,
                                    p_c_ccides out varchar2
                                    );                                 
end PQ_CR_ENVIAR_CORREOS;
 /* GOLDENGATE_DDL_REPLICATION */
/
create or replace package body "PQ_CR_ENVIAR_CORREOS" is

  --Crea un cursor a partir de JAQZ652 recuperando todos aquellos trabajadores con riesgo crediticio
  cursor cur_emp is
    select distinct (select to_date(tpnro, 'dd/mm/yyyy')
                       from fst098
                      where tpcod = 7647
                        and tpcorr = 12) jaqzfecrcc,
                    a.jaqz652ndoc,
                    a.jaqz652nomt,
                    a.jaqz652est,
                    a.jaqz652cal0,
                    a.jaqz652cal1,
                    a.jaqz652cal2,
                    a.jaqz652cal3,
                    a.jaqz652cal4
      from jaqz652 a, fsd002 b
     where a.jaqz652pai = b.pfpais
       and a.jaqz652tdoc = b.pftdoc
       and a.jaqz652ndoc = trim(b.pfndoc)
       and a.jaqz652ndoc in (select jaqz651ndoc from jaqz651)
       and (a.jaqz652cal1 <> 0 or a.jaqz652cal2 <> 0 or a.jaqz652cal3 <> 0 or
           a.jaqz652cal4 <> 0)
       and a.jaqz652est = 'N'
       and b.PFEBCO = 'S'
     order by a.jaqz652nomt;

  --Recupera la dirección electrónica de un trabajador para enviarle el correo
  function fn_cr_leer_usuario_empleado(num_dni varchar2) return varchar2 is
    dir_correo varchar2(50);
  begin
    select lower(email_address)
      into dir_correo
      from ca_alt_vs_empleados@erp
     where employee_num = num_dni
       and email_address like '%@cajaarequipa.pe'
       and cod_cargo not in (Select trim(b.TP1DESC)
                               from fst198 b
                              where b.TP1COD = 1
                                and b.TP1COD1 = 10825
                                and b.TP1CORR1 = 121
                                and b.TP1CORR2 = 1);
    /*and cargo_empl not in ('GERENTE DE ADMINISTRACION Y OPERACIONES','GERENTE DE ADMINISTRACION',
    'GERENTE DE AHORROS Y SERVICIOS','GERENTE DE AUDITORIA',
    'GERENTE DE COMPLIANCE Y PREVENCION','GERENTE DE DESARROLLO COMERCIAL',
    'GERENTE DE DESARROLLO HUMANO','GERENTE DE ESTRATEGIAS DE NEGOCIOS',
    'GERENTE DE FINANZAS','GERENTE DE FINANZAS Y PLANEAMIENTO','GERENTE DE NEGOCIOS',
    'GERENTE DE OPERACIONES Y CANALES','GERENTE DE PLANEAMIENTO Y CONTROL',
    'GERENTE DE RIESGOS','GERENTE DE SOLUCIONES DE NEGOCIO (E)','GERENTE LEGAL');*/
    return dir_correo;
  exception
  When no_data_found then
      begin
        select 'XXX'
          into dir_correo
          from ca_alt_vs_empleados@erp
         where employee_num = num_dni
           and email_address like '%@cajaarequipa.pe'
           and cod_cargo in (Select trim(b.TP1DESC)
                                   from fst198 b
                                  where b.TP1COD = 1
                                    and b.TP1COD1 = 10825
                                    and b.TP1CORR1 = 121
                                    and b.TP1CORR2 = 1);    
        return dir_correo;                                        
      Exception
      When Others then  
        return '';
      end;
  when others then
      return '';
  end fn_cr_leer_usuario_empleado;

  --Recupera la dirección electrónica del jefe del trabajador
  function fn_cr_leer_correo_jefe(num_dni varchar2) return varchar2 is
    dir_correo varchar2(50);
  begin
    select lower(email_address)
      into dir_correo
      from ca_alt_vs_empleados@erp
     where employee_id = (select id_jefe_empl
                            from ca_alt_vs_empleados@erp
                           where employee_num = num_dni);
    if dir_correo is null then
      --dir_correo := 'registrosdepersonal@cajaarequipa.pe';
      begin
        Select trim(a.tp1desc) || '@cajaarequipa.pe'
          into dir_correo
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10825
           and a.tp1corr1 = 121
           and a.tp1corr2 = 4;
      Exception
        when others then
          dir_correo := null;
      End;
    end if;
    return dir_correo;
  exception
    when others then
      return '';
  end fn_cr_leer_correo_jefe;

  --Envía un correo-e al trabajador
  procedure sp_cr_envia_correo_empleado(pc_de      VARCHAR2,
                                        pc_aquien  VARCHAR2,
                                        pc_cc1     VARCHAR2,
                                        pc_cc2     VARCHAR2,
                                        pc_asunto  VARCHAR2,
                                        pc_mensaje VARCHAR2) is
  
    EmailServer VARCHAR2(80) := '10.0.200.68';
    Port        NUMBER := 2528;
    conn        UTL_SMTP.CONNECTION;
    crlf        VARCHAR2(2) := CHR(10);
    mesg        VARCHAR2(32000);
    vhost_name  VARCHAR2(100);
    v_found     number;
  begin
  
    select host_name
      into EmailServer
      from systabrep.hostnames_mail
     where habilitado = 'S';
    select port
      into Port
      from systabrep.hostnames_mail
     where habilitado = 'S';
  
    select host_name into vhost_name from v$instance;
    if pc_aquien is not null then
      --  if  UPPER(vhost_name) in ('BTRAC2051','BTRAC2052','BTRAC4051'/*DGLIMA*/) then
      --  IF UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051'/*DGLIMA*/) then    
      --  if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      SELECT count(*)
        into v_found
        FROM systabrep.hostnames
       where habilitado = 'S'
         and upper(host_name) = UPPER(vhost_name);
    
      if v_found = 1 then
        conn := utl_smtp.OPEN_CONNECTION(EmailServer, Port);
        utl_smtp.HELO(conn, EmailServer);
        utl_smtp.MAIL(conn, pc_de);
        utl_smtp.RCPT(conn, pc_aquien);
        utl_smtp.RCPT(conn, pc_cc1);
        utl_smtp.RCPT(conn, pc_cc2);
        mesg := 'From: ' || pc_de || crlf || 'To: ' || pc_aquien || crlf ||
                'CC: ' || pc_cc1 || crlf || 'CC: ' || pc_cc2 || crlf ||
                'Subject: ' || pc_asunto || crlf || '' || crlf ||
                pc_mensaje || crlf || crlf || '.' || crlf;
      
        utl_smtp.OPEN_DATA(conn);
        utl_smtp.WRITE_DATA(conn, mesg);
        utl_smtp.CLOSE_DATA(conn);
        --          UTL_SMTP.QUIT(conn);
        utl_smtp.close_connection(conn);
      end if;
    end if;
  exception
    when others then
      utl_smtp.close_connection(conn);
  end sp_cr_envia_correo_empleado;

  --Actualiza el estado del registro del trabajador en JAQZ652 indicando que ya se le envió el correo
  procedure actualiza_estado_empleado(num_dni varchar2, estado char) is
  begin
    update jaqz652 set jaqz652est = estado where jaqz652ndoc = num_dni;
    commit;
  end actualiza_estado_empleado;

  --PROCEDIMIENTO PRINCIPAL
  procedure notificar_empleados is
    buzon      varchar2(50);
    copia      varchar2(50); -- := 'registrosdepersonal@cajaarequipa.pe';
    copfn      varchar2(50); -- := 'bklauer@cajaarequipa.pe';
    cont       int := 0;
    lv_coderr  varchar2(400);
    lv_deserr  varchar2(400);
    lc_codest  char(1);
    ll_mensaje CLOB;
    lv_mensaje VARCHAR2(32767);
    lc_exc     char(1):='N';    
  begin
    begin
      Select trim(a.tp1desc) || '@cajaarequipa.pe'
        into copia
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10825
         and a.tp1corr1 = 121
         and a.tp1corr2 = 4;
    Exception
      when others then
        copia := null;
    End;
    for t in cur_emp loop
      buzon := fn_cr_leer_usuario_empleado(t.jaqz652ndoc);
      if buzon = 'XXX' then
        lc_exc := 'S';
        begin
          select lower(email_address)
            into buzon
            from ca_alt_vs_empleados@erp
           where employee_num = t.jaqz652ndoc
             and email_address like '%@cajaarequipa.pe';
        exception
        when others then   
          buzon := '';
        end;
      Else
        lc_exc := 'N';  
      End if;  
      if buzon is not null then
        If lc_exc = 'N' then
           copfn := fn_cr_leer_correo_jefe(t.jaqz652ndoc);
        Else
            begin
              select lower(email_address)
                into copfn
                from ca_alt_vs_empleados@erp
               where email_address like '%@cajaarequipa.pe'
                 and cod_cargo = '0000002973'; --CARGO DEL GERENTE DE ADMINISTRACION DE PERSONAL
            exception
            when others then   
              copfn := '';
            end;          
        End If;
        
        /*        begin
        sp_cr_envia_correo_empleado ('ebsdjp@cajaarequipa.pe', buzon, copia, copfn,
                   'Aviso de Calificación Crediticia', 
                   'Estimado(a) ' || t.jaqz652nomt || chr(10) || 
                   'Su calificación crediticia al ' || t.jaqzfecrcc || ' es: ' || chr(10) ||
                   'Normal: ' || t.jaqz652cal0 || '%' || chr(10) ||
                   'CPP: ' || t.jaqz652cal1 || '%' || chr(10) ||
                   'Deficiente: ' || t.jaqz652cal2 || '%' || chr(10) ||
                   'Dudoso: ' || t.jaqz652cal3 || '%' || chr(10) ||
                   'Pérdida: ' || t.jaqz652cal4 || '%' || chr(10) || chr(10) || chr(10) || 
                   'Le agradeceremos regularizar su situación a fin de no incumplir con nuestro' ||
                   ' Reglamento Interno de Trabajo y de evitar observaciones por parte de los' || 
                   ' Organismos Reguladores y de Control.');
        exception
        when others then
          sp_cr_envia_correo_empleado ('ebsdjp@cajaarequipa.pe', 'bklauer@cajaarequipa.pe', 'bklauer@cajaarequipa.pe', 'bklauer@cajaarequipa.pe',
                                       'ERROR Correo incorrecto', copfn); 
        end;*/
        dbms_lob.createtemporary(ll_mensaje, TRUE);
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) ' ||
                      t.jaqz652nomt || ' - ' || trim(t.jaqz652ndoc) ||
                      '</p>' ||
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">' ||
                      'Su calificación crediticia al ' || t.jaqzfecrcc ||
                      ' es:' || '</p>';
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje :=  --ll_mensaje ||                                                
         '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
                      '<table cellspacing=0 cellpadding=2 width=450>' ||
                      '  <tr>' ||
                      '    <td width="200" style="border-bottom: 1px solid black;"><b>Detalle:</b></td>' ||
                      '    <td width="200" style="border-bottom: 1px solid black;"><b></b></td>' ||
                      '  </tr>          ';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '  <tr>' || '    <td align="left">' || 'Normal:' ||
                      '</td>' || '    <td align="left">' ||
                      to_char(t.jaqz652cal0, '990.90') || '%' || '</td>' ||
                      '  </tr>                ';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '  <tr>' || '    <td align="left">' || 'CPP:' ||
                      '</td>' || '    <td align="left">' ||
                      to_char(t.jaqz652cal1, '990.90') || '%' || '</td>' ||
                      '  </tr>                ';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '  <tr>' || '    <td align="left">' || 'Deficiente:' ||
                      '</td>' || '    <td align="left">' ||
                      to_char(t.jaqz652cal2, '990.90') || '%' || '</td>' ||
                      '  </tr>                ';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '  <tr>' || '    <td align="left">' || 'Dudoso:' ||
                      '</td>' || '    <td align="left">' ||
                      to_char(t.jaqz652cal3, '990.90') || '%' || '</td>' ||
                      '  </tr>                ';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '  <tr>' || '    <td align="left">' || 'Pérdida:' ||
                      '</td>' || '    <td align="left">' ||
                      to_char(t.jaqz652cal4, '990.90') || '%' || '</td>' ||
                      '  </tr>                ';
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '</table>';
      
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">' ||
                      'Le agradeceremos regularizar su situación a fin de no incumplir con nuestro' ||
                      ' Reglamento Interno de Trabajo y de evitar observaciones por parte de los' ||
                      ' Organismos Reguladores y de Control.' || '</p>';
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
        begin
          -- Call the procedure
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => buzon,
                                           p_destinatarioscc   => copfn,
                                           p_destinatariosbcc  => copia,
                                           p_mensaje           => ll_mensaje,
                                           p_remitente         => 'ebsdjp@cajaarequipa.pe',
                                           p_asunto            => 'Aviso de Calificación Crediticia',
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => '',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr          => lv_coderr,
                                           p_c_deserr          => lv_deserr);
        Exception
          when others then
            lv_coderr := '001';
            lv_deserr := substr(sqlerrm, 1, 400);
        end;
      
        if lv_coderr = '000' then
          lv_deserr := 'ENVIO SATISFACTORIO';
          lc_codest := 'S';
        Else
          lc_codest := 'N';
        End If;
      
        BEGIN
          insert into aqpa137
            (aqpa137per,
             aqpa137num,
             aqpa137fec,
             aqpa137hor,
             aqpa137bdy,
             aqpa137cue,
             aqpa137est,
             aqpa137msg)
          values
            (t.jaqzfecrcc,
             t.jaqz652ndoc,
             trunc(sysdate),
             to_char(sysdate, 'HH24:MI:SS'),
             ll_mensaje,
             buzon || ';' || copfn || ';' || copia,
             lc_codest,
             lv_deserr);
        
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        commit;
        dbms_lob.freetemporary(ll_mensaje);
      
        actualiza_estado_empleado(t.jaqz652ndoc, 'S');
        cont := cont + 1;
        --dbms_output.put_line('Enviado ' || cont || ' correos satisfactoriamente');
      end if;
    end loop;
    commit;
  exception
    when others then
      sp_cr_envia_correo_empleado('ebsdjp@cajaarequipa.pe',
                                  'bklauer@cajaarequipa.pe',
                                  'bklauer@cajaarequipa.pe',
                                  'bklauer@cajaarequipa.pe',
                                  'ERROR Correo incorrecto',
                                  copfn);
      commit;
  end notificar_empleados;
  procedure sp_cl_cargo_ofiplan(num_dni  in varchar2,
                                pc_cargo out varchar2,
                                p_c_flag out varchar2) is
  begin
    select a.cargo_empl, 'S'
      into pc_cargo, p_c_flag
      from ca_alt_vs_empleados@erp a, fst198 b
     where a.employee_num = num_dni
       and a.cod_cargo = trim(b.tp1desc)
       and b.tp1cod = 1
       and b.tp1cod1 = 10825
       and b.tp1corr1 = 121
       and b.tp1corr2 = 1;
  exception
    when others then
      pc_cargo := null;
      p_c_flag := 'N';
  end sp_cl_cargo_ofiplan;
  Procedure sp_ah_notifica_rrhh(P_D_FECPRO IN DATE,
                                P_D_FECRCC IN DATE,
                                P_C_NOMARC IN VARCHAR2,
                                P_C_CODCAR IN VARCHAR2,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2) is
  
    lv_destinos   varchar2(400) := '';
    lv_archivo    varchar2(30) := '';
    lv_remitente  varchar2(100);
    lv_asunto     varchar2(100);
    lv_directorio varchar2(100);
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    l_bfile       BFILE;
    l_blob        BLOB;        
    lv_estado     char(1):='';    
  begin
    p_c_coderr := '000';
  
    lv_archivo  := trim(P_C_NOMARC);
    lv_destinos := '';
  
    lv_directorio := 'DTPUMP_PR_EMAIL_DIG';
    lv_remitente  := 'procesosbantotal@cajaarequipa.pe';
    lv_asunto     := 'CALIFICACION CREDITICIA';
    -- ARMADO DEL CUERPO        
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a)</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">En adjunto archivo PDF con la calificación al: ' ||
                  to_char(P_D_FECRCC, 'dd/mm/rrrr') || '.</p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    if P_C_CODCAR = '0' then
      --ENVIO MENSUAL
      begin
        Select trim(a.tp1desc)
          into lv_destinos
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10825
           and a.tp1corr1 = 121
           and a.tp1corr2 = 3;
      Exception
        when others then
          lv_destinos := null;
      End;
    
      if trim(lv_destinos) is not null then
        --Enviamos el correo
        begin
          -- Call the procedure
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                           p_destinatarioscc   => '',
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => ll_mensaje,
                                           p_remitente         => lv_remitente,
                                           p_asunto            => lv_asunto,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => lv_directorio,
                                           p_archivosadjuntos  => lv_archivo,
                                           p_c_coderr          => p_c_coderr,
                                           p_c_deserr          => p_c_msgerr);
        exception
          when others then
            p_c_coderr := '00x';
            p_c_msgerr := sqlerrm;
        end;
        if p_c_coderr = '000' then
          p_c_msgerr := 'ENVIO SATISFACTORIO';
        End If;
      Else
        p_c_msgerr := 'NO SE ENCONTRO CUENTA DE CORREO PARAMETRIZADA';
      End If;
    End if;
  
    if P_C_CODCAR <> '0' then
      --ENVIO SEMESTRAL
      begin
        select lower(email_address)
          into lv_destinos
          from ca_alt_vs_empleados@erp
         where cod_cargo = P_C_CODCAR;
      Exception
        when others then
          lv_destinos := null;
      End;
    
      if trim(lv_destinos) is not null then
        --Enviamos el correo
        begin
          -- Call the procedure
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                           p_destinatarioscc   => '',
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => ll_mensaje,
                                           p_remitente         => lv_remitente,
                                           p_asunto            => lv_asunto,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => lv_directorio,
                                           p_archivosadjuntos  => lv_archivo,
                                           p_c_coderr          => p_c_coderr,
                                           p_c_deserr          => p_c_msgerr);
        exception
          when others then
            p_c_coderr := '00x';
            p_c_msgerr := sqlerrm;
        end;
        if p_c_coderr = '000' then
           lv_estado := 'S';
           p_c_msgerr := 'ENVIO SATISFACTORIO';
        else
           lv_estado := 'N';
        End If;
      Else
        p_c_msgerr := 'NO SE ENCONTRO CUENTA DE CORREO DEL GERENTE DE LINEA';
      End If;
    End if;
    
      --REGISTRA LOG DE ENVIO DE MAIL
      BEGIN
       insert into aqpa141b(aqpa141bcor,
                            aqpa141bfec,
                            aqpa141bhor,
                            aqpa141btip,
                            aqpa141bmod,
                            aqpa141basu,
                            aqpa141bdes,
                            aqpa141bcco,
                            aqpa141bnom,
                            aqpa141bbdy,
                            aqpa141barc,
                            aqpa141best,
                            aqpa141bmsg
                           ) values
                           (SQ_AH_ID_ENVIOMAIL_RRHH.NEXTVAL,
                            P_D_FECPRO,
                            TO_CHAR(sysdate,'hh24:mi:ss'),
                            DECODE(P_C_CODCAR,0,'M','S'),
                            DECODE(P_C_CODCAR,0,TO_CHAR(P_D_FECPRO,'dd'),TO_CHAR(P_D_FECPRO,'mm')),
                            lv_asunto,                                
                            lv_destinos,
                            '',
                            lv_archivo,
                            ll_mensaje,
                            EMPTY_BLOB(),
                            lv_estado,
                            p_c_msgerr
                           )
                         RETURN aqpa141barc INTO l_blob;
        l_bfile := BFILENAME(lv_directorio, lv_archivo);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);    
        commit;          
      EXCEPTION
      WHEN OTHERS THEN
         p_c_coderr := '00x'; 
         p_c_msgerr := sqlerrm; 
         insert into aqpa141b(aqpa141bcor,
                              aqpa141bfec,
                              aqpa141bhor,
                              aqpa141btip,
                              aqpa141bmod,
                              aqpa141basu,
                              aqpa141bdes,
                              aqpa141bcco,
                              aqpa141bnom,
                              aqpa141bbdy,
                              aqpa141best,
                              aqpa141bmsg
                             ) values
                             (SQ_AH_ID_ENVIOMAIL_RRHH.CURRVAL,
                              P_D_FECPRO,
                              TO_CHAR(sysdate,'hh24:mi:ss'),
                              DECODE(P_C_CODCAR,0,'M','S'),
                              DECODE(P_C_CODCAR,0,TO_CHAR(P_D_FECPRO,'dd'),TO_CHAR(P_D_FECPRO,'mm')),
                              lv_asunto,                                
                              lv_destinos,
                              '',
                              lv_archivo,
                              ll_mensaje,
                              'N',
                              p_c_msgerr
                             );
      END;
      commit;    
    
    dbms_lob.freetemporary(ll_mensaje);
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_ah_notifica_rrhh;
  Procedure sp_cr_generadata(P_N_NUMIMP IN NUMBER,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2) is
    cursor c_trab is
      Select b.aqpa138apai, b.aqpa138atpo, b.aqpa138anum
        from aqpa138 a, aqpa138a b
       where a.aqpa138seq = b.aqpa138aseq
         and a.aqpa138est = 'I'
         and a.aqpa138seq = P_N_NUMIMP;
  
    cursor data(p_n_tipdoc in number,
                p_c_numdoc in varchar2,
                ld_fecrcc  in date) is
      Select x.AQPA138BNOM,
             x.AQPA138BSBS,
             MAX(x.AQPA138BFE1) AQPA138BFE1,
             MAX(x.AQPA138BCA1) AQPA138BCA1,
             MAX(x.AQPA138BC01) AQPA138BC01,
             MAX(x.AQPA138BC11) AQPA138BC11,
             MAX(x.AQPA138BC21) AQPA138BC21,
             MAX(x.AQPA138BC31) AQPA138BC31,
             MAX(x.AQPA138BC41) AQPA138BC41,
             MAX(x.AQPA138BSA1) AQPA138BSA1,
             MAX(x.AQPA138BFE2) AQPA138BFE2,
             MAX(x.AQPA138BCA2) AQPA138BCA2,
             MAX(x.AQPA138BC02) AQPA138BC02,
             MAX(x.AQPA138BC12) AQPA138BC12,
             MAX(x.AQPA138BC22) AQPA138BC22,
             MAX(x.AQPA138BC32) AQPA138BC32,
             MAX(x.AQPA138BC42) AQPA138BC42,
             MAX(x.AQPA138BSA2) AQPA138BSA2,
             MAX(x.AQPA138BFE3) AQPA138BFE3,
             MAX(x.AQPA138BCA3) AQPA138BCA3,
             MAX(x.AQPA138BC03) AQPA138BC03,
             MAX(x.AQPA138BC13) AQPA138BC13,
             MAX(x.AQPA138BC23) AQPA138BC23,
             MAX(x.AQPA138BC33) AQPA138BC33,
             MAX(x.AQPA138BC43) AQPA138BC43,
             MAX(x.AQPA138BSA3) AQPA138BSA3
        from (Select b.c_nomdeu AQPA138BNOM,
                     b.c_codsbs AQPA138BSBS,
                     b.d_fecpre AQPA138BFE1,
                     b.n_canent AQPA138BCA1,
                     b.n_calif0 AQPA138BC01,
                     b.n_calif1 AQPA138BC11,
                     b.n_calif2 AQPA138BC21,
                     b.n_calif3 AQPA138BC31,
                     b.n_calif4 AQPA138BC41,
                     sum(case
                           when (substr(s.c_cuenta, 1, 4) in
                                ('1411',
                                  '1413',
                                  '1414',
                                  '1415',
                                  '1416',
                                  '1421',
                                  '1423',
                                  '1424',
                                  '1425',
                                  '1426') or
                                substr(s.c_cuenta, 1, 6) in
                                ('811302', '812302', '811925', '812925') or
                                substr(s.c_cuenta, 1, 4) in
                                ('7101', '7102', '7103', '7104', '1412', '1422')) then
                            s.n_salcap
                           else
                            0
                         end) AQPA138BSA1,
                     to_date('01/01/0001', 'dd/mm/rrrr') AQPA138BFE2,
                     0 AQPA138BCA2,
                     0 AQPA138BC02,
                     0 AQPA138BC12,
                     0 AQPA138BC22,
                     0 AQPA138BC32,
                     0 AQPA138BC42,
                     0 AQPA138BSA2,
                     to_date('01/01/0001', 'dd/mm/rrrr') AQPA138BFE3,
                     0 AQPA138BCA3,
                     0 AQPA138BC03,
                     0 AQPA138BC13,
                     0 AQPA138BC23,
                     0 AQPA138BC33,
                     0 AQPA138BC43,
                     0 AQPA138BSA3
                from cldrcci b, cldrccs s
               where b.c_docide(+) = p_c_numdoc
                 and b.d_fecpre(+) = ld_fecrcc
                 and s.c_codsbs(+) = b.c_codsbs
                 and s.d_fecpre(+) = b.d_fecpre
                 and b.c_tdocid = decode(p_n_tipdoc, 21, 1, 2)
               group by b.c_nomdeu,
                        b.c_codsbs,
                        b.d_fecpre,
                        b.n_canent,
                        b.n_calif0,
                        b.n_calif1,
                        b.n_calif2,
                        b.n_calif3,
                        b.n_calif4
              union all
              Select b.c_nomdeu AQPA138BNOM,
                     b.c_codsbs AQPA138BSBS,
                     to_date('01/01/0001', 'dd/mm/rrrr') AQPA138BFE1,
                     0 AQPA138BCA1,
                     0 AQPA138BC01,
                     0 AQPA138BC11,
                     0 AQPA138BC21,
                     0 AQPA138BC31,
                     0 AQPA138BC41,
                     0 AQPA138BSA1,
                     b.d_fecpre AQPA138BFE2,
                     b.n_canent AQPA138BCA2,
                     b.n_calif0 AQPA138BC02,
                     b.n_calif1 AQPA138BC12,
                     b.n_calif2 AQPA138BC22,
                     b.n_calif3 AQPA138BC32,
                     b.n_calif4 AQPA138BC42,
                     sum(case
                           when (substr(s.c_cuenta, 1, 4) in
                                ('1411',
                                  '1413',
                                  '1414',
                                  '1415',
                                  '1416',
                                  '1421',
                                  '1423',
                                  '1424',
                                  '1425',
                                  '1426') or
                                substr(s.c_cuenta, 1, 6) in
                                ('811302', '812302', '811925', '812925') or
                                substr(s.c_cuenta, 1, 4) in
                                ('7101', '7102', '7103', '7104', '1412', '1422')) then
                            s.n_salcap
                           else
                            0
                         end) AQPA138BSA2,
                     to_date('01/01/0001', 'dd/mm/rrrr') AQPA138BFE3,
                     0 AQPA138BCA3,
                     0 AQPA138BC03,
                     0 AQPA138BC13,
                     0 AQPA138BC23,
                     0 AQPA138BC33,
                     0 AQPA138BC43,
                     0 AQPA138BSA3
                from cldrcci b, cldrccs s
               where b.c_docide(+) = p_c_numdoc
                 and b.d_fecpre(+) = add_months(ld_fecrcc, -1)
                 and s.c_codsbs(+) = b.c_codsbs
                 and s.d_fecpre(+) = b.d_fecpre
                 and b.c_tdocid = decode(p_n_tipdoc, 21, 1, 2)
               group by b.c_nomdeu,
                        b.c_codsbs,
                        b.d_fecpre,
                        b.n_canent,
                        b.n_calif0,
                        b.n_calif1,
                        b.n_calif2,
                        b.n_calif3,
                        b.n_calif4
              union all
              Select b.c_nomdeu AQPA138BNOM,
                     b.c_codsbs AQPA138BSBS,
                     to_date('01/01/0001', 'dd/mm/rrrr') AQPA138BFE1,
                     0 AQPA138BCA1,
                     0 AQPA138BC01,
                     0 AQPA138BC11,
                     0 AQPA138BC21,
                     0 AQPA138BC31,
                     0 AQPA138BC41,
                     0 AQPA138BSA1,
                     to_date('01/01/0001', 'dd/mm/rrrr') AQPA138BFE2,
                     0 AQPA138BCA2,
                     0 AQPA138BC02,
                     0 AQPA138BC12,
                     0 AQPA138BC22,
                     0 AQPA138BC32,
                     0 AQPA138BC42,
                     0 AQPA138BSA2,
                     b.d_fecpre AQPA138BFE3,
                     b.n_canent AQPA138BCA3,
                     b.n_calif0 AQPA138BC03,
                     b.n_calif1 AQPA138BC13,
                     b.n_calif2 AQPA138BC23,
                     b.n_calif3 AQPA138BC33,
                     b.n_calif4 AQPA138BC43,
                     sum(case
                           when (substr(s.c_cuenta, 1, 4) in
                                ('1411',
                                  '1413',
                                  '1414',
                                  '1415',
                                  '1416',
                                  '1421',
                                  '1423',
                                  '1424',
                                  '1425',
                                  '1426') or
                                substr(s.c_cuenta, 1, 6) in
                                ('811302', '812302', '811925', '812925') or
                                substr(s.c_cuenta, 1, 4) in
                                ('7101', '7102', '7103', '7104', '1412', '1422')) then
                            s.n_salcap
                           else
                            0
                         end) AQPA138BSA3
                from cldrcci b, cldrccs s
               where b.c_docide(+) = p_c_numdoc
                 and b.d_fecpre(+) = add_months(ld_fecrcc, -2)
                 and s.c_codsbs(+) = b.c_codsbs
                 and s.d_fecpre(+) = b.d_fecpre
                 and b.c_tdocid = decode(p_n_tipdoc, 21, 1, 2)
               group by b.c_nomdeu,
                        b.c_codsbs,
                        b.d_fecpre,
                        b.n_canent,
                        b.n_calif0,
                        b.n_calif1,
                        b.n_calif2,
                        b.n_calif3,
                        b.n_calif4) x
       group by x.AQPA138BNOM, x.AQPA138BSBS;
    ld_fecrcc      date;
    ln_cont        number;
    lc_AQPA138BCAR varchar2(120);
    ld_AQPA138BFIN date;
    lc_AQPA138BFAM char(1);
    ln_AQPA138BCOD number;
  begin
    p_c_coderr := '000';
    begin
      select to_date(f.tpnro, 'DDMMRRRR')
        into ld_fecrcc
        from fst098 f
       where tpcod = 7647
         and tpcorr = 12;
    Exception
      When others then
        ld_fecrcc := null;
    end;
    ln_cont := 0;
    For i in c_trab loop
      --OBTENEMOS DATOS OFIPLAN
      begin
        select a.cargo_empl, a.fecha_ingreso, a.employee_id
          into lc_AQPA138BCAR, ld_AQPA138BFIN, ln_AQPA138BCOD
          from ca_alt_vs_empleados@erp a
         where a.employee_num = i.aqpa138anum;
      exception
        when others then
          lc_AQPA138BCAR := '';
          ld_AQPA138BFIN := null;
          ln_AQPA138BCOD := null;
      end;
    
      --BUSCAMOS FAMILIARES
      begin
        Select decode(nvl(sum(x.familiares), 0), 0, 'N', 'S')
          into lc_AQPA138BFAM
          from (select count(1) familiares
                  from fsr002 t_fami, fst020 t_defa
                 where t_fami.pepais = i.aqpa138apai
                   and t_fami.petdoc = i.aqpa138atpo
                   and t_fami.pendoc = rpad(i.aqpa138anum, 12, ' ')
                   and t_defa.vicod = t_fami.rpccyg
                   and exists (select 1
                          from fsd002 t_iden
                         where t_iden.pfpais = t_fami.rppais
                           and t_iden.pftdoc = t_fami.rptdoc
                           and t_iden.pfndoc = t_fami.rpndoc
                           and t_iden.pfebco = 'S')
                union all
                select count(1) familiares
                  from fsr002 t_fami, fst020 t_defa
                 where t_fami.rppais = i.aqpa138apai
                   and t_fami.rptdoc = i.aqpa138atpo
                   and t_fami.rpndoc = rpad(i.aqpa138anum, 12, ' ')
                   and t_defa.vicod = t_fami.rpccyg
                   and exists (select 1
                          from fsd002 t_iden
                         where t_iden.pfpais = t_fami.pepais
                           and t_iden.pftdoc = t_fami.petdoc
                           and t_iden.pfndoc = t_fami.pendoc
                           and t_iden.pfebco = 'S')) x;
      exception
        when others then
          lc_AQPA138BFAM := 'N';
      end;
    
      For j in data(i.aqpa138atpo, i.aqpa138anum, ld_fecrcc) loop
        ln_cont := ln_cont + 1;
        insert into AQPA138B
          (AQPA138BSEQ,
           AQPA138BCOR,
           AQPA138BPAI,
           AQPA138BTPO,
           AQPA138BNUM,
           AQPA138BCOD,
           AQPA138BNOM,
           AQPA138BCAR,
           AQPA138BFIN,
           AQPA138BFAM,
           AQPA138BSBS,
           AQPA138BFE1,
           AQPA138BCA1,
           AQPA138BSA1,
           AQPA138BC01,
           AQPA138BC11,
           AQPA138BC21,
           AQPA138BC31,
           AQPA138BC41,
           AQPA138BFE2,
           AQPA138BCA2,
           AQPA138BSA2,
           AQPA138BC02,
           AQPA138BC12,
           AQPA138BC22,
           AQPA138BC32,
           AQPA138BC42,
           AQPA138BFE3,
           AQPA138BCA3,
           AQPA138BSA3,
           AQPA138BC03,
           AQPA138BC13,
           AQPA138BC23,
           AQPA138BC33,
           AQPA138BC43)
        values
          (P_N_NUMIMP,
           ln_cont,
           i.aqpa138apai,
           i.aqpa138atpo,
           i.aqpa138anum,
           ln_AQPA138BCOD,
           j.AQPA138BNOM,
           lc_AQPA138BCAR,
           ld_AQPA138BFIN,
           lc_AQPA138BFAM,
           j.AQPA138BSBS,
           j.AQPA138BFE1,
           j.AQPA138BCA1,
           j.AQPA138BSA1,
           j.AQPA138BC01,
           j.AQPA138BC11,
           j.AQPA138BC21,
           j.AQPA138BC31,
           j.AQPA138BC41,
           j.AQPA138BFE2,
           j.AQPA138BCA2,
           j.AQPA138BSA2,
           j.AQPA138BC02,
           j.AQPA138BC12,
           j.AQPA138BC22,
           j.AQPA138BC32,
           j.AQPA138BC42,
           j.AQPA138BFE3,
           j.AQPA138BCA3,
           j.AQPA138BSA3,
           j.AQPA138BC03,
           j.AQPA138BC13,
           j.AQPA138BC23,
           j.AQPA138BC33,
           j.AQPA138BC43);
      End loop;
    End loop;
    --Actualizamos la cabecera de la importación con el resultado
    begin
      update AQPA138 a
         set a.aqpa138est = 'P',
             a.aqpa138msg = 'PROCESADO SATISFACTORIAMENTE'
       where a.aqpa138seq = P_N_NUMIMP;
    exception
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
        rollback;
    end;
    commit;
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
      rollback;
      begin
        update AQPA138 a
           set a.aqpa138est = 'E', a.aqpa138msg = p_c_msgerr
         where a.aqpa138seq = P_N_NUMIMP;
        commit;
      exception
        when others then
          p_c_coderr := sqlcode;
          p_c_msgerr := sqlerrm;
          rollback;
      end;
  end sp_cr_generadata;
  procedure sp_cl_cargo_ofiplan_lin(num_dni   in varchar2,
                                    pc_codcar in varchar2,
                                    pc_cargo  out varchar2,
                                    p_c_flag  out varchar2) is
    pc_depa varchar2(10);
    pc_area varchar2(10);
  begin
    begin
      select a.cargo_empl, a.co_depa, a.co_area
        into pc_cargo, pc_depa, pc_area
        from ca_alt_vs_empleados@erp a
       where a.employee_num = num_dni;
    exception
      when others then
        pc_cargo := null;
        p_c_flag := 'N';
        return;
    end;
  
    begin
      Select 'S'
        into p_c_flag
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10825
         and a.tp1corr1 = 121
         and a.tp1corr2 = 5
         and a.tp1nro1 = to_number(trim(pc_depa))
         and a.tp1nro2 = to_number(trim(pc_area))
         and a.tp1desc = rpad(pc_codcar, 30, ' ');
    Exception
      when others then
        p_c_flag := 'N';
    End;
  exception
    when others then
      pc_cargo := null;
      p_c_flag := 'N';
  end sp_cl_cargo_ofiplan_lin;
  procedure sp_cl_validarotacion(P_D_FECPRO IN DATE,
                                 P_D_FECING IN DATE,
                                 p_c_indrot out varchar2) is
    ld_fecfin date;
    ld_feclim date;
    ln_nummes number(9) := 0;
    ln_mesale number(9) := 0;
  begin
    begin
      Select a.tp1nro1,a.tp1nro2 
        into ln_nummes,ln_mesale
        from fst198 a 
       where a.TP1COD  = 1 
         and a.TP1COD1 = 10825 
         and a.tp1corr1 = 125
         and a.tp1corr2 = 1;
    exception
    when others then  
      p_c_indrot := 'N';
      return;
    end;
    
    ld_fecfin := add_months(P_D_FECING, ln_nummes); --obtenemos fecha fin segun parametro
    ld_feclim := to_date('01/' ||to_char(add_months(P_D_FECPRO, ln_mesale), 'MM') ||to_char(add_months(P_D_FECPRO, ln_mesale), 'rrrr'),'dd/mm/rrrr');
    if ld_feclim >= ld_fecfin then
      p_c_indrot := 'S';
    ELse
      p_c_indrot := 'N';
    End If;
  exception
    when others then
      p_c_indrot := 'N';
  end sp_cl_validarotacion;
  procedure sp_cr_genera_rotacion(P_C_MODO   IN VARCHAR2,
                                  P_D_FECPRO IN DATE,  
                                  P_C_CODUSU IN VARCHAR2,
                                  p_c_coderr out varchar2,
                                  p_c_msgerr out varchar2
                                 ) is
  --OBTENEMOS LOS JEFES REGIONALES Y ZONALES       
  cursor c_gerentes_zon is
    Select b.sng057usr,c.codzon,c.deszon       
      from fst046 a, 
           sng057 b,
           regsuc c
     where a.pgcod     = b.sng055emp
       and a.ubuser    = b.sng057usr  
       and a.ubsuc     = c.sucurs
       and b.sng055car = 220
       --and a.ubsuc = 12 --comentarlo       
       and a.ubsuc < 500 
       and not exists(
            Select 1
             from prfu00 a 
            where a.pgcod =  b.sng055emp 
              and a.ubuser =  b.sng057usr
              and a.prfgcod = 'GREG01' --GERENTE REGIONAL          
             ) 
union all
    Select distinct 
           'ZONA-'||Z.codzon "sng057usr",
           z.codzon,
           z.deszon 
      from regsuc z 
     where z.regcod > 0 
       and z.codzon > 0   
    minus   
    Select 'ZONA-'||c.codzon "sng057usr",c.codzon,c.deszon       
      from fst046 a, 
           sng057 b,
           regsuc c
     where a.pgcod     = b.sng055emp
       and a.ubuser    = b.sng057usr  
       and a.ubsuc     = c.sucurs
       and b.sng055car = 220
       --and a.ubsuc = 12 --comentarlo       
       and a.ubsuc < 500 
       and not exists(
            Select 1
             from prfu00 a 
            where a.pgcod =  b.sng055emp 
              and a.ubuser =  b.sng057usr
              and a.prfgcod = 'GREG01' --GERENTE REGIONAL          
             ) 
     order by codzon;
              
/*    Select b.sng057usr,a.ubsuc,c.codzon,c.deszon       
      from fst046 a, 
           sng057 b,
           regsuc c
     where a.pgcod     = b.sng055emp
       and a.ubuser    = b.sng057usr  
       and a.ubsuc     = c.sucurs             
       and b.sng055car = 220
       --and a.ubsuc = 12 --comentarlo       
       and a.ubsuc < 500 
       and not exists(
            Select 1
             from prfu00 a 
            where a.pgcod =  b.sng055emp 
              and a.ubuser =  b.sng057usr
              and a.prfgcod = 'GREG01' --GERENTE REGIONAL          
             ) 
      order by c.codzon;*/     

   cursor c_listado(ln_codzon in number) is  
    Select a.*
      from REGSUC   a          
     where a.regcod > 0       
       and a.SUCURS < 500
       and a.codzon = ln_codzon
   order by a.sucurs;       
       
  cursor c_trabajadores(ln_codsuc in number,lv_tipo in varchar2) is
    Select distinct d.area_empl,d.employee_id,d.full_name,d.cargo_empl,d.fecha_ingreso,e.aqpa141fag,c.pfpais,c.pftdoc,c.pfndoc,a.ubuser,a.ubsuc  
      from fst046  a, 
           jaqn002 b,
           fsd002  c,
           ca_alt_vs_empleados@erp  d,
           aqpa141 e,
           prfu00  f
     where a.pgcod = b.jaqn002pgc
       and a.ubuser = b.jaqn002usr
       and b.jaqn002pai = c.pfpais
       and b.jaqn002tdo = c.pftdoc
       and b.jaqn002ndo = c.pfndoc
       and c.pfndoc = rpad(d.employee_num,12,' ')
       and d.employee_id = e.aqpa141cod
       and f.pgcod = a.pgcod
       and f.ubuser = a.ubuser
       and Exists (Select 1 
                     from fst198 x 
                    where x.tp1cod = 1 
                      and x.tp1cod1 = 10825 
                      and x.tp1corr1 = 125 
                      and x.tp1corr2 >= decode(lv_tipo,'C',3,'A',4,'E',5,3) 
                      and x.tp1corr2 <= decode(lv_tipo,'C',3,'A',4,'E',5,5) 
                      and rpad(trim(x.tp1desc),10,' ') = f.prfgcod
                  )
       and c.pfebco = 'S'
       and a.ubsuc = decode(ln_codsuc,0,a.ubsuc,ln_codsuc);--PARAMETRO      
       
  lv_indrot        char(1):='N';  
  ln_cont          number:=0;  
  ln_años          number(10):=0;                         
  ln_meses         number(10):=0;  
  ln_valor         number(10):=0;        
  lv_mensaje       varchar2(50):='';    
  lv_mensa         varchar2(50):='';   
  lv_region        varchar2(50):='';    
  lv_usuario       varchar2(10):='';     
  lv_modo          char(1):='';   
  lv_perfil        char(10):='';           
  begin
    p_c_coderr := '0000';
    if P_C_MODO = 'C' then -- CREDITOS
       begin delete from aqpa141a a where a.aqpa141afec = p_d_fecpro and a.aqpa141amod = p_c_modo; commit; exception when others then null; end;
       For i in c_gerentes_zon loop         
          For j in c_listado(i.codzon) loop
              ln_cont:= 0;   
              --POR CADA SUCURSAL IR A BUSCAR LOS TRABAJADORES QUE CUMPLAN CON LOS PERFILES
              For k in c_trabajadores(j.sucurs,P_C_MODO) loop
                  lv_mensaje := NULL;
                  pq_cr_enviar_correos.sp_cl_validarotacion(p_d_fecpro => P_D_FECPRO,
                                                            p_d_fecing => k.aqpa141fag,
                                                            p_c_indrot => lv_indrot
                                                            );
                  --PARAMETRO TOTAL DE MESES TOPE EN AGENCIA                                                                
                  begin
                    Select ceil(a.tp1nro1/12)
                      into ln_valor
                      from fst198 a 
                     where a.TP1COD  = 1 
                       and a.TP1COD1 = 10825 
                       and a.tp1corr1 = 125
                       and a.tp1corr2 = 1;
                  exception
                  when others then  
                    ln_valor := 0;
                  end;       
                                                                       
                  BEGIN Select ceil(MONTHS_BETWEEN(P_D_FECPRO,k.aqpa141fag)/12) into ln_años from DUAL; END;   
                  if ln_años > ln_valor then
                     lv_mensa := 'MAYOR A '||trim(to_char(ln_valor))||' AÑOS';
                  Else
                     lv_mensa := 'MENOR A '||trim(to_char(ln_valor))||' AÑOS';
                  End if;
                  
                  if lv_indrot = 'S' then --NOTIFICAR
                    --OBTENEMOS LA REGION
                    begin
                      Select 'REGION '||upper(trim(a.regnom))
                        into lv_region
                       from regsuc a               
                      Where a.sucurs = k.ubsuc
                        and rownum < 2;   
                    exception
                    when others then  
                      lv_region := '';
                    end;        
                                                          
                    BEGIN Select trunc(MONTHS_BETWEEN(P_D_FECPRO,k.aqpa141fag)/12,0) into ln_años from DUAL; END;                                                                                                        
                    if ln_años > 0 then
                       lv_mensaje := trim(to_char(ln_años))||' AÑOS ';                        
                    End If;

                    BEGIN Select trunc((MONTHS_BETWEEN(P_D_FECPRO,k.aqpa141fag)/12-ln_años)*12,0) into ln_meses from DUAL; END;                                                                                                          
                    if ln_meses > 0 then
                       lv_mensaje := lv_mensaje || trim(to_char(ln_meses))||' MESES ';                        
                    End If;     
                    ln_cont := ln_cont + 1;
                    begin
                      insert into aqpa141a(aqpa141afec, 
                                           aqpa141amod,
                                           aqpa141ausr,
                                           aqpa141azon,
                                           aqpa141asuc,
                                           aqpa141acor,
                                           aqpa141aage, 
                                           aqpa141acod, 
                                           aqpa141anom, 
                                           aqpa141acar, 
                                           aqpa141aing, 
                                           aqpa141areg, 
                                           aqpa141afag, 
                                           aqpa141aant, 
                                           aqpa141aan2, 
                                           aqpa141apai, 
                                           aqpa141atpo, 
                                           aqpa141anum
                                           ) values
                                           (
                                           P_D_FECPRO,
                                           P_C_MODO,
                                           i.sng057usr,                                           
                                           i.codzon,
                                           j.sucurs,
                                           ln_cont,
                                           k.area_empl,
                                           k.employee_id,
                                           k.full_name,
                                           k.cargo_empl,
                                           k.fecha_ingreso,
                                           lv_region,
                                           k.aqpa141fag,
                                           lv_mensa,
                                           lv_mensaje,
                                           k.pfpais,
                                           k.pftdoc,
                                           k.pfndoc
                                           );
                                           commit;
                    Exception
                    when others then
                      p_c_coderr := sqlcode;
                      p_c_msgerr := sqlerrm;    
                      return;                         
                    end;
                  End If;
              End loop;
          End loop;           
       End Loop;     
       commit;
    End If;
    
    if P_C_MODO <> 'C' then -- AHORROS(A), EJECUTIVOS(E) Y ALL A DEMANDA(D)
       begin delete from aqpa141a a where a.aqpa141afec = p_d_fecpro and a.aqpa141amod = p_c_modo; commit; exception when others then null; end;
       ln_cont:= 0;
                 
       --OBTENEMOS USUARIO PARA GRABAR DATA         
       begin
        Select TRIM(a.tp1desc)--upper(substr(a.tp1desc,1,instr(lower(trim(a.tp1desc)),'@cajaarequipa.pe')-1))
          into lv_perfil
          from fst198 a 
         where a.TP1COD  = 1 
           and a.TP1COD1 = 10825 
           and a.tp1corr1 = 125
           and a.tp1corr2 = 6
           and a.tp1nro1 = decode(P_C_MODO,'A',2,'E',3,0);
       exception
       when others then  
        lv_perfil := null;
       end;    
       
       if trim(lv_perfil) is not null then     
         begin
          select trim(x.ubuser)
            into lv_usuario 
            from prfu00 x 
           where x.pgcod = 1 
             and x.prfgcod = lv_perfil
             and rownum = 1;          
         exception 
         when others then    
            lv_usuario := P_C_CODUSU;
         end;
       Else
          lv_usuario := P_C_CODUSU;
       end if;
                                         
       --BUSCAR LOS TRABAJADORES QUE CUMPLAN CON LOS PERFILES
       For k in c_trabajadores(0,P_C_MODO) loop
          lv_mensaje := NULL;
          pq_cr_enviar_correos.sp_cl_validarotacion(p_d_fecpro => P_D_FECPRO,
                                                    p_d_fecing => k.aqpa141fag,
                                                    p_c_indrot => lv_indrot
                                                    );
          --PARAMETRO TOTAL DE MESES TOPE EN AGENCIA                                          
          begin
            Select ceil(a.tp1nro1/12)
              into ln_valor
              from fst198 a 
             where a.TP1COD  = 1 
               and a.TP1COD1 = 10825 
               and a.tp1corr1 = 125
               and a.tp1corr2 = 1;
          exception
          when others then  
            ln_valor := 0;
          end;       
                                                                       
          BEGIN Select ceil(MONTHS_BETWEEN(P_D_FECPRO,k.aqpa141fag)/12) into ln_años from DUAL; END;   
          if ln_años > ln_valor then
             lv_mensa := 'MAYOR A '||trim(to_char(ln_valor))||' AÑOS';
          Else
             lv_mensa := 'MENOR A '||trim(to_char(ln_valor))||' AÑOS';
          End if; 
                                                            
          if lv_indrot = 'S' OR P_C_MODO = 'D' then  
            --OBTENEMOS POR EL USUARIO EL PERFIL      
            begin
              Select 'C'
                into lv_modo
                from prfu00 f
               where f.pgcod = 1
                 and f.ubuser = k.ubuser
                 and Exists (Select 1 
                                   from fst198 x 
                                  where x.tp1cod = 1 
                                    and x.tp1cod1 = 10825 
                                    and x.tp1corr1 = 125 
                                    and x.tp1corr2 = 3 --SI ES DE CREDITOS
                                    and rpad(trim(x.tp1desc),10,' ') = f.prfgcod
                                )
                 and rownum <2;
            exception
            when others then  
              lv_modo := '';
            end;                
            
            if lv_modo = 'C' then
                --OBTENEMOS LA REGION DEL TRABAJADOR CREDITOS
                begin
                 Select 'REGION '||upper(trim(a.regnom))
                   into lv_region
                   from regsuc a 
                  Where a.sucurs = k.ubsuc
                    and rownum < 2;   
                exception
                when others then  
                  lv_region := '';
                end;
            Else                    
                --OBTENEMOS LA REGION DE OPERACIONES
                begin
                 SELECT upper(trim(b.tp1desc))
                   INTO lv_region
                   FROM FST198 a,
                        FST198 b
                  WHERE a.tp1cod   = b.tp1cod
                    and a.tp1cod1  = b.tp1cod1
                    and a.tp1corr1 = b.tp1corr1
                    and a.tp1nro1  = b.tp1corr3
                    and b.tp1corr2 = 3
                    and b.TP1COD1  = 11110 
                    AND b.TP1CORR1 = 5 
                    and a.TP1COD1  = 11110 
                    AND a.TP1CORR1 = 5 
                    AND A.tp1corr2 = 2
                    and a.tp1nro3  = k.ubsuc;
                exception
                when others then  
                   if k.ubsuc = 904 then
                      lv_region := 'ADMINISTRACION';
                   Else  
                      lv_region := '';
                   End If;
                end;    
            End if;                              
                                                          
                                                                                    
            BEGIN Select trunc(MONTHS_BETWEEN(P_D_FECPRO,k.aqpa141fag)/12,0) into ln_años from DUAL; END;                                                                                                        
            if ln_años > 0 then
               lv_mensaje := trim(to_char(ln_años))||' AÑOS ';                        
            End If;

            BEGIN Select trunc((MONTHS_BETWEEN(P_D_FECPRO,k.aqpa141fag)/12-ln_años)*12,0) into ln_meses from DUAL; END;                                                                                                          
            if ln_meses > 0 then
               lv_mensaje := lv_mensaje || trim(to_char(ln_meses))||' MESES ';                        
            End If;     
            ln_cont := ln_cont + 1;
            begin
              insert into aqpa141a(aqpa141afec, 
                                   aqpa141amod,
                                   aqpa141ausr,
                                   aqpa141azon,
                                   aqpa141asuc,
                                   aqpa141acor,
                                   aqpa141aage, 
                                   aqpa141acod, 
                                   aqpa141anom, 
                                   aqpa141acar, 
                                   aqpa141aing, 
                                   aqpa141areg, 
                                   aqpa141afag, 
                                   aqpa141aant, 
                                   aqpa141aan2, 
                                   aqpa141apai, 
                                   aqpa141atpo, 
                                   aqpa141anum
                                   ) values
                                   (
                                   P_D_FECPRO,
                                   P_C_MODO,
                                   lv_usuario,                                           
                                   0,
                                   k.ubsuc,
                                   ln_cont,
                                   k.area_empl,
                                   k.employee_id,
                                   k.full_name,
                                   k.cargo_empl,
                                   k.fecha_ingreso,
                                   lv_region,
                                   k.aqpa141fag,
                                   lv_mensa,
                                   lv_mensaje,
                                   k.pfpais,
                                   k.pftdoc,
                                   k.pfndoc
                                   );
                                   commit;
            Exception
            when others then
              p_c_coderr := sqlcode;
              p_c_msgerr := sqlerrm;    
              return;                         
            end;
          End If;
       End loop; 
    End If;    
  exception
  when others then
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;   
  end sp_cr_genera_rotacion; 
  Procedure sp_ah_notifica_rota(P_D_FECPRO IN DATE,
                                P_C_NOMARC IN VARCHAR2,
                                P_C_CODTIP IN VARCHAR2,
                                P_C_CODMOD IN VARCHAR2,
                                P_C_CODUSU IN VARCHAR2,
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2) is
    Cursor c_datos(ln_tipo in number) is
    Select a.* 
      from fst198 a 
     where a.TP1COD  = 1 
       and a.TP1COD1 = 10825 
       and a.tp1corr1 = 125 
       and a.tp1corr2 = ln_tipo;
       
    lv_destinos   varchar2(400) := '';
    lv_cc         varchar2(400) := '';
    lv_greg       varchar2(400) := '';
    lv_archivo    varchar2(50) := '';
    lv_remitente  varchar2(100);
    lv_asunto     varchar2(100);
    lv_directorio varchar2(100);
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);    
    ln_tipo       number(2):=0;
    ln_tp1nro1    number(9):=0;
    ln_anos       number(9):=0;
    l_bfile       BFILE;
    l_blob        BLOB;        
    lv_estado     char(1):='';
  begin
    p_c_coderr := '000';
  
    lv_archivo  := trim(P_C_NOMARC);  
    lv_directorio := 'DTPUMP_PR_EMAIL_DIG';
    lv_remitente  := 'procesosbantotal@cajaarequipa.pe';
    lv_asunto     := 'AVISO DE PERMANENCIA EN AGENCIA';
    
    if P_C_CODTIP = 'M' then
       ln_tipo := 6;
    End If;
    if P_C_CODTIP = 'T' then
       ln_tipo := 7;
    End If;
    if P_C_CODTIP = 'D' then
       ln_tipo := 99;
    End If;
    
    if P_C_CODMOD = 'C' then
       ln_tp1nro1 := 1;
    End If;
    if P_C_CODMOD = 'A' then
       ln_tp1nro1 := 2;
    End If;
    if P_C_CODMOD = 'E' then
       ln_tp1nro1 := 3;
    End If;    

    if ln_tp1nro1 = 1 And P_C_CODTIP = 'M' then
        begin
          Select trim(lower(e.ubuser))||'@cajaarequipa.pe'
            into lv_greg
           from regsuc a, 
                fst046 b,
                regsuc c,
                prfu00 d,
                fst046 e
          Where a.sucurs = b.ubsuc
            and c.regcod = a.regcod  
            and d.pgcod = e.pgcod
            and d.ubuser = e.ubuser
            and d.prfgcod = 'GREG01'  
            and c.sucurs  = e.ubsuc   
            and b.pgcod = 1
            and b.ubuser = RPAD(P_C_CODUSU,10,' ')
            and rownum < 2;   
              
            lv_destinos := trim(lower(P_C_CODUSU))||'@cajaarequipa.pe'||';'||lv_greg;      
        exception
        when others then
          --si no hay gerente regional es porque el usuario de la zona no existe y hay q buscar el gerente regional por el codigo de la zona
          lv_destinos := NULL;
          begin
              Select trim(lower(e.ubuser))||'@cajaarequipa.pe'
                into lv_greg
               from regsuc a, 
                    fst046 b,
                    regsuc c,
                    prfu00 d,
                    fst046 e
              Where a.sucurs = b.ubsuc
                and c.regcod = a.regcod  
                and d.pgcod = e.pgcod
                and d.ubuser = e.ubuser
                and d.prfgcod = 'GREG01'  
                and c.sucurs  = e.ubsuc   
                and b.pgcod = 1
                and c.codzon = substr(trim(P_C_CODUSU),instr(trim(P_C_CODUSU),'-',1)+1,10)
                and rownum < 2;  
                
                lv_destinos := lv_greg;                  
          exception
          when others then
            lv_destinos := NULL;
          end;          
        end;
     End If;          
    --DATOS PARA EL ENVIO DEL MAIL
    For i in c_datos(ln_tipo) loop
      if i.tp1nro2 = 1 then--CORREO
        Case      
          When i.tp1nro1 = ln_tp1nro1 then --Para
            lv_destinos := lv_destinos||trim(lower(i.tp1desc));
          When i.tp1nro1 = 4 then --CC
            lv_cc := lv_cc||trim(lower(i.tp1desc));
          Else
            null;
        End Case;
      end if;
      
      if i.tp1nro2 = 2 then--PERFIL        
        Case      
          When i.tp1nro1 = ln_tp1nro1 then --Para
            begin
             select lower(trim(x.ubuser))||'@cajaarequipa.pe'
               into lv_destinos 
               from prfu00 x 
              where x.pgcod = 1 
                and x.prfgcod = rpad(trim(i.tp1desc),10,' ')
                and rownum = 1;          
            exception 
            when others then    
              lv_destinos := null;
            end;
          When i.tp1nro1 = 4 then --CC
            lv_cc := lv_cc||trim(lower(i.tp1desc));
          Else
            null;
        End Case;
      End If;
    End loop;
    
    if lv_destinos is null  And P_C_CODTIP = 'D' then --ejecución a demanda
       lv_destinos := TRIM(lower(P_C_CODUSU))||'@cajaarequipa.pe';
       lv_cc := '';
    End If;
    
    begin
      Select ceil(a.tp1nro1/12)
        into ln_anos
        from fst198 a 
       where a.TP1COD  = 1 
         and a.TP1COD1 = 10825 
         and a.tp1corr1 = 125
         and a.tp1corr2 = 1;
    exception
    when others then  
      ln_anos := 0;
    end;     
    -- ARMADO DEL CUERPO   
    If P_C_CODTIP = 'D' then     
      lv_asunto     := 'REPORTE DE ANTIGUEDAD DE TRABAJADORES EN AGENCIA O UNIDAD ADMINISTRATIVA';      
      dbms_lob.createtemporary(ll_mensaje, TRUE);
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) Previo saludo,</p>' ||
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Adjuntamos el reporte del personal de agencia o unidad administrativa.</p>';               
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
    else
      dbms_lob.createtemporary(ll_mensaje, TRUE);
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) Previo saludo,</p>' ||
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Adjuntamos el reporte del personal de su gerencia; en el que se detalla el tiempo de permanencia en una misma agencia.</p>'||
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Le recordamos que deberá programar el desplazamiento del personal antes de llegar al umbral establecido de permanencia (periodos no mayores a '||trim(to_char(ln_anos))||' años)</p>'||                  
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">En caso tenga alguna duda o consulta comunicarse con <a href="mailto:DepartamentodeRRHH-Administracion@cajaarequipa.pe">DepartamentodeRRHH-Administracion@cajaarequipa.pe</a></p>';                                    

      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    End if;
        
    --if trim(lv_destinos) is not null then
    if trim(lv_destinos) is not null and (1 = 0) then    
      --Enviamos el correo
      
      begin
        -- Call the procedure
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                         p_destinatarioscc   => lv_cc,
                                         p_destinatariosbcc  => '',
                                         p_mensaje           => ll_mensaje,
                                         p_remitente         => lv_remitente,
                                         p_asunto            => lv_asunto,
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => lv_directorio,
                                         p_archivosadjuntos  => lv_archivo,
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_msgerr);
      exception
        when others then
          lv_estado := 'N';          
          p_c_coderr := '00x';
          p_c_msgerr := sqlerrm;
      end;
      
      if p_c_coderr = '000' then
         lv_estado := 'S';
         p_c_msgerr := 'ENVIO SATISFACTORIO';
      Else
         lv_estado := 'N';
      End If;
      --REGISTRA LOG DE ENVIO DE MAIL
      BEGIN
       insert into aqpa141b(aqpa141bcor,
                            aqpa141bfec,
                            aqpa141bhor,
                            aqpa141btip,
                            aqpa141bmod,
                            aqpa141basu,
                            aqpa141bdes,
                            aqpa141bcco,
                            aqpa141bnom,
                            aqpa141bbdy,
                            aqpa141barc,
                            aqpa141best,
                            aqpa141bmsg
                           ) values
                           (SQ_AH_ID_ENVIOMAIL_RRHH.NEXTVAL,
                            P_D_FECPRO,
                            TO_CHAR(sysdate,'hh24:mi:ss'),
                            P_C_CODTIP,
                            P_C_CODMOD,
                            lv_asunto,                                
                            lv_destinos,
                            lv_cc,
                            lv_archivo,
                            ll_mensaje,
                            EMPTY_BLOB(),
                            lv_estado,
                            p_c_msgerr
                           )
                         RETURN aqpa141barc INTO l_blob;
        l_bfile := BFILENAME(lv_directorio, lv_archivo);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);    
        commit;          
      EXCEPTION
      WHEN OTHERS THEN
         p_c_coderr := '00x'; 
         p_c_msgerr := sqlerrm; 
         insert into aqpa141b(aqpa141bcor,
                              aqpa141bfec,
                              aqpa141bhor,
                              aqpa141btip,
                              aqpa141bmod,
                              aqpa141basu,
                              aqpa141bdes,
                              aqpa141bcco,
                              aqpa141bnom,
                              aqpa141bbdy,
                              aqpa141best,
                              aqpa141bmsg
                             ) values
                             (SQ_AH_ID_ENVIOMAIL_RRHH.CURRVAL,
                              P_D_FECPRO,
                              TO_CHAR(sysdate,'hh24:mi:ss'),
                              P_C_CODTIP,
                              P_C_CODMOD,
                              lv_asunto,                                
                              lv_destinos,
                              lv_cc,
                              lv_archivo,
                              ll_mensaje,
                              'N',
                              p_c_msgerr
                             );
      END;
      commit;
    Else
      p_c_msgerr := 'NO SE ENCONTRO CUENTA DE CORREO PARAMETRIZADA';
    End If;     
    dbms_lob.freetemporary(ll_mensaje);
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_ah_notifica_rota;                                    
  Procedure sp_ah_verifica_trab is  
  begin
/*      MERGE INTO AQPA141 x
      USING ca_alt_vs_empleados@erp a
      ON (x.aqpa141cod = a.EMPLOYEE_ID)
      WHEN MATCHED THEN
        UPDATE
           SET x.aqpa141fag = a.FECHA_INGRESO
         WHERE a.FECHA_INGRESO > x.aqpa141fag
      WHEN NOT MATCHED THEN
        INSERT
          (x.aqpa141cod, x.aqpa141fag)
        VALUES
          (a.EMPLOYEE_ID, a.FECHA_INGRESO);*/
          
      MERGE INTO AQPA141 x
      USING ca_alt_vs_empleados@erp a
      ON (x.aqpa141cod = a.EMPLOYEE_ID)
      WHEN MATCHED THEN
        UPDATE
           SET x.aqpa141fag = case
                              when (a.FECHA_INGRESO > x.aqpa141fag) or trim(x.aqpa141ax7) is null then
                                a.FECHA_INGRESO                                
                              else
                                trunc(sysdate)
                              End,
               x.aqpa141ax7 = a.co_grup_ocup
         WHERE (a.FECHA_INGRESO > x.aqpa141fag
                OR 
                trim(x.aqpa141ax7) <> trim(a.co_grup_ocup)
                OR 
                trim(x.aqpa141ax7) is null
               )
      WHEN NOT MATCHED THEN
        INSERT
          (x.aqpa141cod, x.aqpa141fag, x.aqpa141ax7)
        VALUES
          (a.EMPLOYEE_ID, a.FECHA_INGRESO, trim(a.co_grup_ocup));          
      commit;
  exception
  when others then  
    null;
  end sp_ah_verifica_trab;  
Procedure sp_ah_valida_CON_DIR is
  cursor c_vigentes_bt is
    select a.*      
      from aqpa301 a, fsd002 b, fst198 c
     where a.aqpa301pais = b.pfpais
       and a.aqpa301tdoc = b.pftdoc
       and a.aqpa301ndoc = b.pfndoc
       and a.aqpa301carg = c.tp1nro1
       and c.tp1cod = 1
       and c.tp1cod1 = 11136
       and c.tp1corr1 = 2
       and a.aqpa301est = 'S';--VIGENTES
     
  cursor c_vigentes_of is      
  select distinct 
        604 pais,
        decode(ti_docu_iden,'DNI',21,'CEX',2,0) tipodoc,  
        ide.nu_docu_iden,
        emp.co_pues_trab,
        emp.co_cali_trab
  from tmtrab_pers@ofiplan per
  left outer join tdiden_trab@ofiplan ide on per.co_trab=ide.co_trab and ti_docu_iden in ('DNI','CEX')
  left outer join tmtrab_empr@ofiplan emp on per.co_trab=emp.co_trab    
  where emp.ti_situ='ACT' 
    and emp.co_cali_trab in ('CON','DIR');--ACTIVOS
    
  lv_indvig    varchar2(1):='N';
  lv_numdoc    varchar2(12):='';
  lc_numdoc    char(12):='';
  ld_fecing    date;
  ln_codcar    number(9):=0;
  ln_id        number(15):=0;
  begin
  --
  -- recorrer todo los viegentes de bt y verificar que sigan vigentes en of si no lo encuentra actualiza a fecha de vencimiento sysdate     
  --  
  For i in c_vigentes_bt loop
    lv_numdoc := trim(i.aqpa301ndoc);
    begin
      select 'S'
        into lv_indvig
        from tmtrab_pers@ofiplan per
        left outer join tdiden_trab@ofiplan ide on per.co_trab=ide.co_trab and ti_docu_iden in ('DNI','CEX')
        left outer join tmtrab_empr@ofiplan emp on per.co_trab=emp.co_trab    
        where emp.ti_situ='ACT' 
          and emp.co_cali_trab = decode(trim(i.aqpa301ax7),'CONFIANZA','CON','DIRECCION','DIR',NULL) --in ('CON','DIR')
          and ide.nu_docu_iden = lv_numdoc;--ACTIVOS       
    exception
    when others then  
      lv_indvig := 'N';
    end;
    
    If lv_indvig = 'N' then
      --GRABAMOS HISTORIAL DE CAMBIOS AQPA302
      begin
        -- Call the procedure
        sp_correl_sq(p_c_nomseq => 'SQ_CL_ID_LOGDIR',
                     p_c_codusu => 'BANTOTAL',
                     p_n_correl => ln_id);
      exception
      when others then               
        ln_id := 0;
      end;
      
      if ln_id > 0 then
        begin
          insert into AQPA302(aqpa302corr,aqpa302pais,aqpa302tdoc,aqpa302ndoc,aqpa302carg,  
                              aqpa302est,aqpa302fini,aqpa302fces,aqpa302npai,aqpa302ntdo,  
                              aqpa302nndo,aqpa302ncar,aqpa302nest,aqpa302nfin,aqpa302nfce,  
                              aqpa302sucrea,aqpa302usurea,aqpa302fecrea,aqpa302hrarea,aqpa302sucrem,
                              aqpa302usurem,aqpa302fecrem,aqpa302hrarem,aqpa302sucreg,aqpa302usureg,
                              aqpa302fecreg,aqpa302hrareg
                              ) values
                              (ln_id,i.aqpa301pais,i.aqpa301tdoc,i.aqpa301ndoc,i.AQPA301CARG,
                               'S',i.AQPA301FINI,null,i.aqpa301pais,i.aqpa301tdoc,
                               i.aqpa301ndoc,i.AQPA301CARG,'S',i.AQPA301FINI,i.aqpa301fces,
                               i.aqpa301sucreg,i.aqpa301usureg,i.aqpa301fecreg,i.aqpa301hrareg,i.aqpa301sucmod,
                               i.aqpa301usumod,i.aqpa301fecmod,i.aqpa301hramod,904,'BANTOTAL',
                               trunc(sysdate),to_char(sysdate,'HH24:mi:ss')
                              );  
                              commit;                          
        exception
        when others then
          null;
        end;
      End if;
            
      update aqpa301 a 
         set a.AQPA301EST    = lv_indvig, 
             a.AQPA301FCES   = trunc(sysdate),
             a.AQPA301SUCMOD = 904,
             a.AQPA301USUMOD = 'BANTOTAL',
             a.AQPA301FECMOD = trunc(sysdate),	
             a.AQPA301HRAMOD = to_char(sysdate,'HH24:mi:ss')
       where a.aqpa301pais = i.aqpa301pais
         and a.aqpa301tdoc = i.aqpa301tdoc 
         and a.aqpa301ndoc = i.aqpa301ndoc
         and a.aqpa301carg = i.AQPA301CARG 
         and a.aqpa301fini = i.AQPA301FINI; 
         commit;
    End If;
  End loop;
  
  --
  -- recorrer todos los activos de of y verifica en bt si sguen activos con la misma calificcion
  -- si no existe en bt registrar como nuevo mapeando el cargo      
  --    
  For i in c_vigentes_of loop
    lc_numdoc := trim(i.nu_docu_iden);
    begin
      select 'S'
        into lv_indvig        
        from aqpa301 a
       where a.aqpa301pais = 604
         and a.aqpa301tdoc = i.tipodoc
         and a.aqpa301ndoc = lc_numdoc
         and a.aqpa301ax7  = rpad(decode(trim(i.co_cali_trab),'CON','CONFIANZA','DIR','DIRECCION',NULL),100,' ')
         and a.aqpa301est  = 'S';--VIGENTES 
    exception
    when others then  
      lv_indvig := 'N';
    end;
    
    If lv_indvig = 'N' then
       -- OBTENEMOS FECHA DE INGRESO SEGUN BT
       begin
         Select a.pffibc
           into ld_fecing  
           from fsd002 a 
          where a.pfpais = 604 
            and a.pftdoc = i.tipodoc 
            and a.pfndoc = lc_numdoc;
       exception
       when others then
         ld_fecing := null;
       end;
       --OBTENEMOS CARGO
       begin
        Select c.tp1nro1
          into ln_codcar
          from fst198 c
         where c.tp1cod = 1
           and c.tp1cod1 = 11136
           and c.tp1corr1 = 3
           and c.tp1corr2 = 1
           and c.tp1desc = rpad(i.co_pues_trab,30,' ');
       exception
       when others then
         ln_codcar := 0;
       end;
       
       if ln_codcar > 0 then        
         begin
           insert into aqpa301(aqpa301pais,
                               aqpa301tdoc,
                               aqpa301ndoc,
                               aqpa301carg,
                               aqpa301est,
                               aqpa301fini,
                               aqpa301sucreg,
                               aqpa301usureg,
                               aqpa301fecreg,
                               aqpa301hrareg,
                               aqpa301ax5,
                               aqpa301ax7
                              )
                        values(604,
                               i.tipodoc,
                               i.nu_docu_iden,
                               ln_codcar,
                               'S',
                               trunc(sysdate),
                               904,
                               'BANTOTAL',
                               trunc(sysdate),
                               to_char(sysdate,'HH24:mi:ss'),
                               ld_fecing,
                               decode(trim(i.co_cali_trab),'CON','CONFIANZA','DIR','DIRECCION',NULL)
                              );
                              commit;
         Exception
         when others then
           null;
         end;
       End if;
    End If;
  End loop;  
  exception
  when others then
    null;
  end sp_ah_valida_CON_DIR;  

  Procedure sp_ah_reprocesa_mail(P_N_CODPRO IN NUMBER, --CODIGO DE PROCESO
                                 P_C_ASUNTO IN VARCHAR2, --ASUNTO             
                                 P_C_DESPAR IN VARCHAR2, --DESTINATARIOS (PARA)
                                 P_C_DESCOC IN VARCHAR2, --DESTINATARIOS (CC)
                                 P_C_DESCCO IN VARCHAR2, --DESTINATARIOS (CCO)
                                 P_C_MENSAJ IN CLOB,     --CUERPO EN HTML
                                 P_C_REMITE IN VARCHAR2, --REMITENTE
                                 P_C_DIRECT IN VARCHAR2, --DIRECTORIO PARA OBTENER LOS ADJUNTOS
                                 P_C_ADJUNT IN VARCHAR2, --LISTADO DE ARCHIVOS SEPARADOS POR ;      
                                 P_N_AUX001 IN NUMBER,   --NUMBER(17,2)    
                                 P_N_AUX002 IN NUMBER,   --NUMBER(17,2)
                                 P_N_AUX003 IN NUMBER,   --NUMBER(9)
                                 P_N_AUX004 IN NUMBER,   --NUMBER(9)
                                 P_D_AUX005 IN DATE,     --DATE
                                 P_D_AUX006 IN DATE,     --DATE
                                 P_C_AUX007 IN VARCHAR2, --VARCHAR2(100)
                                 P_C_AUX008 IN VARCHAR2, --VARCHAR2(100)
                                 P_C_AUX009 IN VARCHAR2, --VARCHAR2(100)
                                 p_c_coderr out varchar2, 
                                 p_c_msgerr out varchar2                                
                                 ) is  
  lv_valido      varchar2(1):= 'N'; 
  ln_len         number(9):= 0;     
  ln_punto       number(9):= 0;                              
  i              number(9):= 1;  
  lv_cadena      varchar2(400):= null;
  begin
    p_c_coderr := '000'; 
    ln_len := length(trim(P_C_DESPAR));  
        
    While i < ln_len loop
        select instr(trim(P_C_DESPAR),';',i) into ln_punto from dual;
        if ln_punto = 0 then
           lv_cadena := substr(trim(P_C_DESPAR),i,(ln_len-i)+1);
           PQ_CL_VOLCADO_CAMPANA.sp_valida_mail(P_C_MAIL  => lv_cadena,
                                                P_C_ERROR => lv_valido
                                               );                
           i:= ln_len; 
        Else
          lv_cadena := substr(trim(P_C_DESPAR),i,(ln_punto-i));            
          PQ_CL_VOLCADO_CAMPANA.sp_valida_mail(P_C_MAIL  => lv_cadena,
                                               P_C_ERROR => lv_valido
                                               );                    
          if lv_valido = 'N' then
             Exit;
          Else
             i := ln_punto + 1;  
          end if;                                                                            
        End If;  
    End loop;

    if lv_valido = 'S' then
      begin
        insert into aqpa145(aqpa145cor,
                            aqpa145cod,
                            aqpa145fer,
                            aqpa145hre,
                            aqpa145asu,
                            aqpa145par,
                            aqpa145pcc,
                            aqpa145cco,
                            aqpa145msg,
                            aqpa145rem,
                            aqpa145dir,
                            aqpa145adj,
                            aqpa145est,
                            aqpa145nro,
                            aqpa145ax1,
                            aqpa145ax2,
                            aqpa145ax3,
                            aqpa145ax4,
                            aqpa145ax5,
                            aqpa145ax6,
                            aqpa145ax7,
                            aqpa145ax8,
                            aqpa145ax9
                            )
                     values(SQ_AH_ID_RENVIO_MAIL.NEXTVAL,
                            P_N_CODPRO,
                            trunc(sysdate),
                            to_char(sysdate,'HH24:MI:SS'),
                            P_C_ASUNTO,
                            P_C_DESPAR,
                            P_C_DESCOC,
                            P_C_DESCCO,
                            P_C_MENSAJ,
                            P_C_REMITE,
                            P_C_DIRECT,
                            P_C_ADJUNT,
                            'P',
                            0,
                            P_N_AUX001,
                            P_N_AUX002,
                            P_N_AUX003,
                            P_N_AUX004,
                            P_D_AUX005,
                            P_D_AUX006,
                            P_C_AUX007,
                            P_C_AUX008,
                            P_C_AUX009
                            );
                            commit;     
                            p_c_msgerr := 'Grabación Satisfactoria';   
      Exception
      When others then    
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;      
      end; 
    else      
       p_c_coderr := '001'; 
       p_c_msgerr := 'Correo destino inválido';      
    End if;                   
                 
  exception
  when others then  
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;
  end sp_ah_reprocesa_mail;                             
  
  procedure sp_lanza_renvio_mail is
    
  cursor c_pendientes is
  select * 
    from aqpa145 a 
   where a.aqpa145est = 'P'
     and (a.aqpa145cer is null 
          or 
          a.aqpa145cer not in ('1006','1003')
         );  
   
  lv_coderr varchar2(4000);
  lv_deserr varchar2(4000);
  lv_estado varchar2(1);
  begin
    for i in c_pendientes loop
      begin
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(i.aqpa145par),
                                       p_destinatarioscc   => trim(i.aqpa145pcc),
                                       p_destinatariosbcc  => trim(i.aqpa145pcc),
                                       p_mensaje           => i.aqpa145msg,
                                       p_remitente         => trim(i.aqpa145rem),
                                       p_asunto            => trim(i.aqpa145asu),
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => trim(i.aqpa145dir),
                                       p_archivosadjuntos  => trim(i.aqpa145adj),
                                       p_c_coderr          => lv_coderr,
                                       p_c_deserr          => lv_deserr
                                       ); 
      if lv_coderr <> '000' then
         lv_estado := 'P';     
      Else
         lv_estado := 'S';
         lv_deserr := 'ENVIO SATISFACTORIO';
      End If;
      
      update aqpa145 a 
         set a.aqpa145est = lv_estado,
             a.aqpa145fev = trunc(sysdate),
             a.aqpa145hev = to_char(sysdate,'HH24:MI:SS'),
             a.aqpa145nro = a.aqpa145nro + 1,
             a.aqpa145cer = lv_coderr,
             a.aqpa145mer = lv_deserr
       where a.aqpa145cor = i.aqpa145cor;
       commit;                                          
      exception
      when others then
        lv_coderr := sqlcode;
        lv_deserr := sqlerrm;
        
        update aqpa145 a 
           set a.aqpa145est = i.aqpa145est,
               a.aqpa145fev = trunc(sysdate),
               a.aqpa145hev = to_char(sysdate,'HH24:MI:SS'),
               a.aqpa145nro = a.aqpa145nro + 1,
               a.aqpa145cer = lv_coderr,
               a.aqpa145mer = lv_deserr
         where a.aqpa145cor = i.aqpa145cor;  
         commit;      
      end;
    end loop;
  exception
  when others then  
    null;
  end sp_lanza_renvio_mail;  
  Procedure sp_ah_notifica_fraude(P_D_FECPRO IN DATE,
                                  P_C_HORPRO IN VARCHAR2,
                                  P_N_ITMOD  IN NUMBER,
                                  P_N_ITTRAN IN NUMBER,
                                  P_C_VALOR  IN VARCHAR2,
                                  p_c_coderr out varchar2,
                                  p_c_msgerr out varchar2
                                  ) is
    lv_destinos   varchar2(400) := '';
    lv_archivo    varchar2(30) := '';
    lv_remitente  varchar2(100);
    lv_asunto     varchar2(100);
    lv_directorio varchar2(100);
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767); 
    lv_operación  varchar2(30):='';                                         
  begin
    p_c_coderr  := '000';
    lv_archivo  := '';
    lv_destinos := 'prevencion@cajaarequipa.pe';
  
    lv_directorio := '';
    lv_remitente  := 'informacion@cajaarequipa.pe';
    lv_asunto     := 'Posible Fraude';
    
    begin
      select upper(trim(x.trnom)) 
        into lv_operación
        from fst034 x 
       where x.pgcod = 1  
         and x.trmod = P_N_ITMOD
         and x.trnro = P_N_ITTRAN;
    exception
    when others then     
      lv_operación := null;
    end;
    -- ARMADO DEL CUERPO        
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Se ha detectado un posible fraude el día: ' ||
                  to_char(P_D_FECPRO, 'dd/mm/rrrr') ||' '||trim(P_C_HORPRO)|| ' al realizar la operación '||lv_operación||'.</p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">El producto/CCI identificado en la base negativa de Caja Arequipa es: '||P_C_VALOR||' </p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
     
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

    
      if trim(lv_destinos) is not null then
        --Enviamos el correo
        begin
          -- Call the procedure
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                           p_destinatarioscc   => '',
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => ll_mensaje,
                                           p_remitente         => lv_remitente,
                                           p_asunto            => lv_asunto,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => lv_directorio,
                                           p_archivosadjuntos  => lv_archivo,
                                           p_c_coderr          => p_c_coderr,
                                           p_c_deserr          => p_c_msgerr);
        exception
          when others then
            p_c_coderr := '00x';
            p_c_msgerr := sqlerrm;
        end;
        if p_c_coderr = '000' then
           p_c_msgerr := 'ENVIO SATISFACTORIO';
        Else
          --REGISTRAMOS RENVIO DE MAIL  
          PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 3,--RENVIO NOTIFICACIONES POSIBLE FRAUDE
                                                    P_C_ASUNTO => lv_asunto,
                                                    P_C_DESPAR => lv_destinos,
                                                    P_C_DESCOC => null,
                                                    P_C_DESCCO => null,
                                                    P_C_MENSAJ => ll_mensaje,
                                                    P_C_REMITE => lv_remitente,
                                                    P_C_DIRECT => lv_directorio,
                                                    P_C_ADJUNT => lv_archivo,
                                                    P_N_AUX001 => null,
                                                    P_N_AUX002 => null,
                                                    P_N_AUX003 => null,
                                                    P_N_AUX004 => null,
                                                    P_D_AUX005 => null,
                                                    P_D_AUX006 => null,
                                                    P_C_AUX007 => null,
                                                    P_C_AUX008 => P_C_VALOR,
                                                    P_C_AUX009 => null,
                                                    p_c_coderr => p_c_coderr,
                                                    p_c_msgerr => p_c_msgerr
                                                    );          
        End If;
      End If;
    dbms_lob.freetemporary(ll_mensaje);   
  exception
  when others then   
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;    
  end sp_ah_notifica_fraude;                                                 
  Procedure sp_ah_valida_transf_cce(P_N_PGCOD  IN NUMBER,
                                    P_N_ITMOD  IN NUMBER,
                                    P_N_ITSUC  IN NUMBER,
                                    P_N_ITTRAN IN NUMBER,
                                    P_N_ITNREL IN NUMBER,
                                    P_D_FECCON IN DATE,
                                    p_c_ccides out varchar2
                                    ) is
  begin
    Select trim(a.se115ccids)
      into p_c_ccides
      from fse115 a 
     where a.se115cd = P_N_PGCOD
       and a.se115su = P_N_ITSUC
       and a.se115md = P_N_ITMOD
       and a.se115tr = P_N_ITTRAN
       and a.se115re = P_N_ITNREL
       and a.se115fc = P_D_FECCON;
  exception
  when others then  
    p_c_ccides := '';  
  end sp_ah_valida_transf_cce;
end PQ_CR_ENVIAR_CORREOS;
 /* GOLDENGATE_DDL_REPLICATION */
/
