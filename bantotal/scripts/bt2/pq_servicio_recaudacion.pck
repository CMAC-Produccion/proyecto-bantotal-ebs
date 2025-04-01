create or replace package "PQ_SERVICIO_RECAUDACION" is
  type pagos_filas is record(
    fila varchar2(1000));
  type pagos_tabla is table of pagos_filas;
  procedure sp_enviar_correo(p_c_CodEnt number,
                             p_c_CodSer number,
                             p_c_FecEnv date,
                             p_c_filas  out number);
  function fn_obtener_pagos(p_c_CodEnt number,
                            p_c_CodSer number,
                            p_c_FecEnv date) return pagos_tabla
    PIPELINED;
  procedure sp_agencia_exoneradas;
end PQ_SERVICIO_RECAUDACION;
 /* GOLDENGATE_DDL_REPLICATION */
/
create or replace package body PQ_SERVICIO_RECAUDACION is
  -- *****************************************************************
  -- Nombre                     : PQ_SERVICIO_RECAUDACION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECAUDOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 03/05/2017
  -- Autor de Creación          : Hlaqui
  -- Uso                        : Generar y enviar archivo de los pagos de servicios
  -- Estado                     : Activo
  -- Fecha de Modificación      : 18/06/2019
  -- Autor de la Modificación   : JPINTO
  -- Descripción de Modificación: Agregar la nueva empresa de servicio en linea SIELSE
  -- Fecha de Modificación      : 11/11/2019
  -- Autor de la Modificación   : JPINTO
  -- Descripción de Modificación: Agregar la nueva empresa de servicio en linea ElectroSUR
  -- Fecha de Modificación      : 28/09/2020
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Agregar la nueva empresa de servicio en linea Movistar
  -- Fecha de Modificación      : 09/10/2020
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Agregar la nueva empresa de servicio en linea Bitel
  -- Fecha de Modificación      : 20/01/2022
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Agregar la nueva empresa de servicio en linea Distriluz  
  -- Fecha de Modificación      : 21/04/2022
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Agregar la nueva empresa de servicio en linea LCC a formato estandar
  -- Fecha de Modificación      : 24/05/2022
  -- Autor de la Modificación   : RCUADROS
  -- Descripción de Modificación: Agregar nuevas empresas batch estandar
  -- Fecha de Modificación      : 31/08/2022
  -- Autor de la Modificación   : RCUADROS
  -- Descripción de Modificación: Agregar empresas Club Internacional y Multivision
  -- Fecha de Modificación      : 18/01/2023
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se obtiene la hora del sistema para nombre archivo Pago efectivo
  -- Fecha de Modificación      : 17/02/2023
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se añade Estandar de empresas con mas de 1 servicio--KASHIO
  -- Fecha de Modificación      : 03/05/2023
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se añade a Estandar de empresas con mas de 1 servicio--U. CONTINENTAL
  -- Fecha de Modificación      : 25/02/2024
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se añade a empresas Agente Cash
  -- Fecha de Modificación      : 19/03/2024
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se añade a Universidad Peruana Union (UPEU)
  -- Fecha de Modificación      : 14/05/2024
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se corrige cabecera de archivo para empresas Agente Cash
  -- Fecha de Modificación      : 24/06/2024
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se añade a CBPPUNO y SJBDELASALLE
  -- Fecha de Modificación      : 25/11/2024
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se archivo cada hora para empress Llamagas/Canaliza  
  -- Fecha de Modificación      : 27/11/2024
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se añade Colegio Buen Pastor
  -- Fecha de Modificación      : 14/03/2025
  -- Autor de la Modificación   : FPINTO
  -- Descripción de Modificación: Se añade variable nueva para empresas online estandar 
  -- *****************************************************************

  procedure sp_enviar_correo(p_c_CodEnt number,
                             p_c_CodSer number,
                             p_c_FecEnv date,
                             p_c_filas  out number) is
    p_c_msgerr varchar2(1000);

    cursor deta(fecha in date) is
      select fila
        from table(pq_servicio_recaudacion.fn_obtener_pagos(p_c_codent,
                                                            p_c_codser,
                                                            fecha));
  
    cursor destinatarios(codent in number) is
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
  
    cursor c_host is
      select *
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10825
         and Tp1corr1 = 61
         and Tp1corr2 = 7;
  
    v_wstring   varchar2(32000);
    v_header    varchar2(10000);
    v_From      VARCHAR2(80);
    v_host      VARCHAR2(80);
    v_Recipient VARCHAR2(80);
    v_Subject   VARCHAR2(200);
    v_Body      VARCHAR2(200);
  
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
    v_FlgTip      varchar2(1); --A: Automatico ; M: Manual
    v_Filename    varchar2(100);
    v_found       number;
    Conexion      varchar(5);
    Cnoarc         varchar(100); 

  
  BEGIN
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
    if p_c_FecEnv IS NULL THEN
      select pgfape into fecha from fst017 where pgcod = 1;
      v_FlgTip := 'A'; --Automatico - JOB
    Else
      fecha    := p_c_FecEnv;
      v_FlgTip := 'M'; --Manual - Panel Bantotal
    End If;
  
    For i in c_host loop
      v_host        := upper(TRIM(substr(i.tp1desc,
                                         1,
                                         instr(i.tp1desc, '/') - 1)));
      C_SMTP_SERVER := TRIM(substr(i.tp1desc,
                                   instr(i.tp1desc, '/') + 1,
                                   length(trim(i.tp1desc))));
      C_SMTP_PORT   := i.tp1nro3;
      if upper(VHOST_NAME) = v_host then
        Exit;
      End if;
    End loop;
  
    SELECT count(*)
      into v_found
      FROM systabrep.hostnames
     where habilitado = 'S'
       and upper(host_name) = UPPER(vhost_name);
  
    --    IF UPPER(VHOST_NAME) IN('SC01ZDBADM010101', 'SC01ZDBADM020101', 'T54BTRAC4052','T74BTRAC4051' /*, 'DSBD1051'*/) THEN
    if v_found = 1 then
      select jaql508abent
        into v_emp
        from jaql508
       where jaql508coent = p_c_CodEnt;
       
       select jaql509conex 
       into Conexion 
       from jaql509 
       where jaql508coent = p_c_CodEnt 
       and rownum = 1;
       
       begin        
         select Trim(jaql509noarc)
           into Cnoarc 
           from jaql509 
          where jaql508coent = p_c_CodEnt
            and jaql509cotse = p_c_CodSer;
       exception
         when others then
              Cnoarc := v_emp;
       end;
      begin
              select jaql514detsv
              into v_serv
              from jaql514
              where jaql514cotsv = p_c_CodSer;
      exception
        when others then
             v_serv := v_emp;
      end;
      
      select trim(tp1desc) tp1desc
        into remitente
        from fst198
       where Tp1cod = 1
         and tp1cod1 = 10801
         and Tp1corr1 = 22
         and Tp1corr2 = 3
         and tp1corr3 = 1;
    
      select trim(tp1desc) tp1desc
        into v_Recipient
        from fst198
       where Tp1cod = 1
         and tp1cod1 = 10801
         and Tp1corr1 = 22
         and Tp1corr2 = 4
         and tp1corr3 = 1;
         

      --r1 := pq_servicio_recaudacion.fn_obtener_pagos(p_c_codent, p_c_codser, p_c_fecenv);
      Case
        When p_c_CodEnt = '59' and v_FlgTip = 'A' Then
          v_Filename := 'G_CAJAAREQ_M_' || to_char(fecha, 'DDMMYYYY') ||to_char(sysdate,'HH24')||   
                        '.txt'; --Pago Efectivo --fpinto 18/01/2023 se obtiene la hora del sistema
        When p_c_CodEnt = '59' and v_FlgTip = 'M' Then
          v_Filename := 'G_CAJAAREQ_C_' || to_char(fecha, 'DDMMYYYY') ||
                        '.txt'; --Pago Efectivo
        When p_c_CodEnt = '65' Then
          v_Filename := 'CJAREQ_' || to_char(fecha, 'YYYYMMdd') || '.txt'; --ENTEL
        When p_c_CodEnt = '22' then
          v_Filename := to_char(fecha, 'YYYYMMdd') || 'cajaarequipa' ||
                        '.txt'; --SIELSE
		When p_c_CodEnt = '14' Then
          v_Filename := to_char(fecha, 'YYYYMMdd') || 'caja_arequipa' ||
                        '.txt'; --ELECTROSUR EN LINEA
        When p_c_CodEnt = '7'  Then
          v_Filename := 'CA' || to_char(fecha, 'YYYYMMDD') ||
                        '.txt'; --Movistar  
        When p_c_CodEnt = '9'  Then
          v_Filename := 'CAREQUIPA_' || to_char(fecha, 'YYYYMMDD') ||
                        '.txt'; --Bitel  
        When p_c_CodEnt = '398'  Then
          v_Filename := 'CAJAREQUIPA_' || to_char(fecha, 'YYYYMMDD') || '_R_ENOSA' ||
                        '.txt'; --Distriluz   ENOSA  
        When p_c_CodEnt = '399'  Then
          v_Filename := 'CAJAREQUIPA_' || to_char(fecha, 'YYYYMMDD') || '_R_ENSA' ||
                        '.txt'; --Distriluz   ENSA   
        When p_c_CodEnt = '400'  Then
          v_Filename := 'CAJAREQUIPA_' || to_char(fecha, 'YYYYMMDD') || '_R_HDNA' ||
                        '.txt'; --Distriluz   HIDRANDINA   
        When p_c_CodEnt = '3'  Then
          v_Filename := 'CAJAREQUIPA_' || to_char(fecha, 'YYYYMMDD') || '_R_ELCTRO' ||
                        '.txt'; --Distriluz   ELECTROCENTRO
        When p_c_CodEnt in ('451','454', '466')   Then
          v_Filename := v_emp || v_serv ||to_char(fecha, 'DD-MM-YYYY') ||
                        '.txt'; --KASHIO/U. CONTINENTAL/ COMBOPLAY 
        When p_c_CodEnt = '679' Then
          v_Filename := to_char(fecha, 'YYYYMMDD') || '_02_' || 'arq' ||
                        '.txt'; --Agente CASH - ELOR
        When p_c_CodEnt = '680' Then
          v_Filename := to_char(fecha, 'YYYYMMDD') || '_04_' || 'arq' ||
                        '.txt'; --Agente CASH - Electro Tocache 
        When p_c_CodEnt = '681' Then
          v_Filename := to_char(fecha, 'YYYYMMDD') || '_05_' || 'arq' ||
                        '.txt'; --Agente CASH - Eilhicha
        When p_c_CodEnt = '682' Then
          v_Filename := to_char(fecha, 'YYYYMMDD') || '_06_' || 'arq' ||
                        '.txt'; --Agente CASH - Hughesnet
        When p_c_CodEnt = '683' Then
          v_Filename := to_char(fecha, 'YYYYMMDD') || '_07_' || 'arq' ||
                        '.txt'; --Agente CASH - SedaChimbote                                                                                           
        else
          If Conexion = 'B' then
            If  v_FlgTip = 'A' then
              v_Filename := Cnoarc || to_char(fecha, 'DDMMYYYY')||to_char(sysdate,'HH24')|| '.PAGOS2';--fpinto 25/11/2024Llamagas/Canaliza
            else
             v_Filename := Cnoarc || to_char(fecha, 'DDMMYYYY') || '.PAGOS2';
            end if;
          else
             v_Filename := v_emp || to_char(fecha, 'DD-MM-YYYY') || '.txt';
          End if;
      End Case;
    
      v_From := remitente;
      --//
      if p_c_CodEnt in (22, 14) then
        v_Subject := 'CIERRE CONCILIACION COBRANZA - ' || v_emp || ' ' ||
                     to_char(fecha, 'dd-mm-yyyy');
      else
        v_Subject := 'Pagos recaudación - ' || v_emp || ' ' ||
                     to_char(fecha, 'dd-mm-yyyy');
      end if;
      --//
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, C_SMTP_PORT);
      msg        := 'Date: ' ||
                    to_char(fecha, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                    utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                    'Subject: ' || v_Subject || utl_tcp.crlf || 'To: ' || '' ||
                    utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      countDest := 0;
      --
    
      for dest in destinatarios(p_c_CodEnt) loop
        utl_smtp.Rcpt(V_Conexion, dest.tp1desc);
        countDest := countDest + 1;
      end loop;
    
      If countDest = 0 then
        utl_smtp.Rcpt(V_Conexion, v_Recipient);
      End If;
    
      --//
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
      v_Body := 'Buen día. Se adjunta pagos';
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || utl_tcp.crlf ||
                          utl_tcp.crlf || v_Body || '. ' || v_emp || ' ' ||
                          to_char(fecha, 'dd-mm-yyyy') || CHR(13) ||
                          CHR(13) || CHR(13) || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          '-------SECBOUND' || utl_tcp.crlf ||
                          'Content-Type: text/plain; charset=iso-8859-1' ||
                          utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          ' name=EXTRACTO_' || to_char(fecha, 'DD-MM-RRRR') ||
                          utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          'Content-Transfer_Encoding: 8bit' || utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion,
                          'Content-Disposition: attachment;' ||
                          utl_tcp.crlf);
      --v_Nombre := v_emp;    
      /*utl_smtp.write_data(V_Conexion,
      ' filename=' || v_Nombre ||
      to_char(fecha, 'DD-MM-RRRR') || '.txt' ||
      utl_tcp.crlf || utl_tcp.crlf); */
      utl_smtp.write_data(V_Conexion,
                          ' filename=' || v_Filename || utl_tcp.crlf ||
                          utl_tcp.crlf);
      p_c_filas := 0;
      for r_trab in deta(fecha) loop
        v_wstring := r_trab.fila;
        rawData   := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        p_c_filas := p_c_filas + 1;
      end loop;
    
      v_header := '';
      --utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
    
      --utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      --utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      --utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
    
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    END IF;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
  END sp_enviar_correo;

  function fn_obtener_pagos(p_c_CodEnt number,
                            p_c_CodSer number,
                            p_c_FecEnv date) return pagos_tabla
    PIPELINED is
    rec pagos_filas;
	CorEst  number;  --Correlativo Estandar	
  Conexion varchar(5);
  flgEstandar number; --fpinto 14/03/2025 se añade variable nueva para empresas online estandar 								   
  BEGIN
   
    select nvl(max(Tp1Imp1), 0) into CorEst from fst198 where Tp1cod = 1
    and Tp1cod1 = 10801
    and Tp1corr1 = 17                          
    and Tp1corr2 = p_c_CodEnt 
    and Tp1corr3 = 0;
    
    select jaql509conex into Conexion from jaql509 where jaql508coent = p_c_CodEnt and rownum= 1;
    --fpinto 14/03/2025 se añade obtencion de variables cuando empresa online standar con  trace propio
    begin
      select tp1imp1 into flgEstandar from fst198 where Tp1cod = 1
      and Tp1cod1 = 11143
      and Tp1corr1 = 16                          
      and Tp1corr2 = 1 
      and TP1NRO1 = p_c_CodEnt;
    exception
      WHEN NO_DATA_FOUND THEN
        flgEstandar :=0;
    end;
    
    If p_c_CodEnt = 56 then
      
      --SafetyPay
      for e in (select '     ' || case
                         when a.jaql515cotca = 1 then
                          'WP'
                         when a.jaql515cotca = 4 then 
                          'PA'													  							  
                         else
                          'OL'
                       end || case
                         when a.jaql515mdapg = 0 then
                          '01'
                         else
                          '10'
                       end || rpad(trim(a.jaql515sumin), 20, ' ') ||
                       '        ' || rpad(trim(a.jaql515sumin), 15, ' ') ||
                       rpad(nvl((select trim(jaql506clien)
                                  from jaql506
                                 where jaql506coent = p_c_CodEnt
                                   and jaql506cotse = a.jaql515cotsv
                                   and jaql506nrcon = a.jaql515sumin
                                   and rownum = 1),
                                (select trim(jaql507clien)
                                   from jaql507
                                  where jaql507coent = p_c_CodEnt
                                    and jaql507cotse = a.jaql515cotsv
                                    and jaql507nrcon = a.jaql515sumin
                                    and rownum = 1)),
                            30,
                            ' ') || to_char(jaql515femov, 'YYYYMMDD') ||
                       replace(trim(jaql515homov), ':', '') ||
                       lpad(trim(replace(to_char(b.jaql516mocob,
                                                 '9999999.99'),
                                         '.',
                                         '')),
                            13,
                            '0') || lpad(trim(replace(to_char(a.jaql515mtoce,
                                                              '9999999.99'),
                                                      '.',
                                                      '')),
                                         9,
                                         '0') ||
                       lpad(trim(b.jaql516nudoc), 16, '0') ||
                       to_char(jaql515femov, 'YYYYMMDD') ||
                       lpad(trim(c.jaqy584trace), 20, '0') || '000' fila
                  from jaql515 a
                 inner join jaql516 b
                    on a.jaql515copsv = b.jaql515copsv
                 inner join jaqy584 c
                    on c.jaqy584coent = a.jaql515coent
                   and c.jaqy584cotsv = a.jaql515cotsv
                   and c.jaqy584nrcon = a.jaql515sumin
                   and c.jaqy584copsv = a.jaql515copsv
				   and c.jaqy584coope = 'P'					   
                 where a.jaql515coent = p_c_CodEnt
                   and a.jaql515esreg = 'V'
                   and a.jaql515femov = p_c_FecEnv
                 order by a.jaql515copsv asc) loop
        select e.fila into rec from dual;
        pipe row(rec);
      end loop;
    end if;
    If p_c_CodEnt = 59 then
      --Pago Efectivo
      for e in (select lpad(trim(g.ubsuc), 14, ' ') ||
                       lpad(trim(g.ubsuc), 14, ' ') ||
                       lpad(trim(c.jaqy584trace), 14, ' ') ||
                       lpad(trim(a.jaql515sumin), 14, ' ') || case
                         when a.jaql515comon = 0 then
                          ' 000500'
                         else
                          ' 000501'
                       end || case
                         when a.jaql515cotca = 1 then
                          ' 3 2'
                         when a.jaql515cotca = 2 then
                          ' 414'
                         when a.jaql515cotca = 3 then
                          ' 114'
                         when a.jaql515cotca = 4 then
                          ' 2 2'
                         when a.jaql515cotca = 5 then
                          '1314'                        
                         when a.jaql515cotca = 6 then
                          ' 514'
                       end || lpad(trim(a.jaql515coent), 5, ' ') || ' 1' ||
                       lpad(trim(a.jaql515sumin), 14, ' ') ||
                       lpad(trim(to_char(b.jaql516mocob, '99999990.99')),
                            18,
                            ' ') ||
                       lpad(trim(to_char(nvl(nvl(JAQL506AUXN1, JAQL507AUXN1),
                                             JAQL507HAUXN1),
                                         '99999990.99')),
                            18,
                            ' ') --Monto
                       ||
                       lpad(trim(to_char(nvl(nvl(JAQL506AUXN2, JAQL507AUXN2),
                                             JAQL507HAUXN2),
                                         '99999990.99')),
                            18,
                            ' ') --Mora
                       || case
                         when a.jaql515comon = 0 then
                          '1'
                         else
                          '2'
                       end || to_char(TO_DATE(substr(nvl(nvl(jaql506fadoc,
                                                             jaql507fadoc),
                                                         jaql507hfadoc),
                                                     1,
                                                     19),
                                              'YYYY-MM-DD"T"HH24:MI:SS"'),
                                      'DDMMYYYYHH24MISS') ||
                       to_char(TO_DATE(substr(nvl(nvl(jaql506auxc3,
                                                      jaql507auxc3),
                                                  jaql507hauxc3),
                                              1,
                                              19),
                                       'YYYY-MM-DD"T"HH24:MI:SS"'),
                               'DDMMYYYYHH24MISS') ||
                       lpad(nvl(nvl(jaql506text1, jaql507text1),
                                jaql507htext1),
                            25,
                            ' ') || lpad(' ', 12, ' ') ||
                       to_char(jaql515femov, 'DDMMYYYY') ||
                       replace(trim(jaql515homov), ':', '') Fila
                  from jaql515 a
                 inner join jaql516 b
                    on a.jaql515copsv = b.jaql515copsv
                 inner join jaqy584 c
                    on c.jaqy584coent = a.jaql515coent
                   and c.jaqy584cotsv = a.jaql515cotsv
                   and c.jaqy584nrcon = a.jaql515sumin
                   and c.jaqy584copsv = a.jaql515copsv
                   and c.jaqy584coope = 'P'
                  left outer join jaql506 d
                    on d.jaql506coent = p_c_CodEnt
                   and d.jaql506nrcon = a.jaql515sumin
                  left outer join (select x.*
                                    from (select p.jaql507coent,
                                                 p.jaql507cotse,
                                                 p.jaql507nrcon,
                                                 p.jaql507mocob,
                                                 p.jaql507fadoc,
                                                 p.jaql507auxc3,
                                                 p.jaql507auxn1,
                                                 p.jaql507auxn2,
                                                 p.jaql507text1,
                                                 row_number() over(partition by p.jaql507coent, p.jaql507cotse, p.jaql507nrcon order by p.jaql507fepro) Orden
                                            from jaql507 p
                                           where p.jaql507coent = p_c_CodEnt) x
                                   where x.orden = 1) e
                    on e.jaql507nrcon = a.jaql515sumin
                  left outer join (select x.*
                                    from (select q.jaql507hcoent,
                                                 q.jaql507hcotse,
                                                 q.jaql507hnrcon,
                                                 q.jaql507hmocob,
                                                 q.jaql507hfadoc,
                                                 q.jaql507hauxc3,
                                                 q.jaql507hauxn1,
                                                 q.jaql507hauxn2,
                                                 q.jaql507htext1,
                                                 row_number() over(partition by q.jaql507hcoent, q.jaql507hcotse, q.jaql507hnrcon order by q.jaql507hfepro desc) Orden
                                            from jaql507h q
                                           where q.jaql507hcoent = 59) x
                                   where x.orden = 1) f
                    on f.jaql507hnrcon = a.jaql515sumin
                  left outer join fst046 g
                    on g.ubuser =
                       rpad(trim(nvl(a.jaql515cousu, 'USRSWITCH')), 10, ' ')
                 where a.JAQL515COENT = p_c_CodEnt
                   and a.jaql515esreg = 'V'
                   and a.JAQL515FEMOV = p_c_FecEnv /*in ('07/06/2018')*/
                 order by a.jaql515copsv asc) loop
        select e.fila into rec from dual;
        pipe row(rec);
      end loop;
    end if;
    If p_c_CodEnt = 66 then
      --Universidad Catolica Santa Maria
      for e in (select 'T' || ',' || lpad(trim(p_c_CodEnt), 20, '0') || ',' ||
                       to_char(p_c_FecEnv, 'YYYY/MM/DD') || ',' || count(1) || ',' ||
                       trim(to_char(sum(b.jaql516mocob), '9999999.99')) || ',' fila
                  from jaql515 a
                 inner join jaql516 b
                    on a.jaql515copsv = b.jaql515copsv
                 where a.jaql515coent = p_c_CodEnt
                   and a.jaql515esreg = 'V'
                   and a.jaql515femov = p_c_FecEnv --'08/11/2018'
                union all
                select x.fila
                  from (select 'D' || ',' ||
                               substr(trim(a.jaql515sumin), 1, 10) || ',' ||
                               rpad(trim(b.jaql516nudoc), 40, ' ') || ',' ||
                               trim(to_char(b.jaql516mocob, '9999999.99')) || ',' ||
                               '0.00' || ',' || a.jaql515homov || ',' ||
                               to_char(a.jaql515femov, 'YYMMDD') ||
                               lpad(a.jaql515pgsuc, 3, '0') ||
                               lpad(a.jaql515scmod, 3, '0') ||
                               lpad(a.jaql515stran, 3, '0') ||
                               lpad(a.jaql515snrel, 4, '0') || ',' fila
                          from jaql515 a
                         inner join jaql516 b
                            on a.jaql515copsv = b.jaql515copsv
                         where a.jaql515coent = p_c_CodEnt
                           and a.jaql515esreg = 'V'
                           and a.jaql515femov = p_c_FecEnv --'08/11/2018'
                         order by a.jaql515copsv asc) x) loop
        select e.fila into rec from dual;
        pipe row(rec);
      end loop;
    end if;
    If p_c_CodEnt = 65 then
      --ENTEL
      for e in (select 'CC00000222221C' || to_char(p_c_FecEnv, 'YYYYMMDD') ||
                       lpad(to_char(count(1)), 9, '0') ||
                       lpad(trim(replace(to_char(sum(b.jaqy584mocob),
                                                 '99999999.99'),
                                         '.',
                                         '')),
                            15,
                            '0') || '0000' || '000000235959' ||
                       lpad(' ', 138, ' ') fila
                  from jaql515 a
                 inner join jaqy584 b
                    on b.jaqy584coent = a.jaql515coent
                   and b.jaqy584cotsv = a.jaql515cotsv
                   and b.jaqy584nrcon = a.jaql515sumin
                   and b.jaqy584copsv = a.jaql515copsv
                   and b.jaqy584comsg = '200'
				   and b.jaqy584coope = '940000'								
                 where a.jaql515coent = 65
                   and jaql515femov = p_c_FecEnv
                   and a.jaql515esreg = 'V'
                union all
                select 'DD00000222221' ||
                       lpad(trim(a.jaql515sumin), 14, '0') ||
                       lpad(trim(b.jaqy584nuopc), 30, '0') ||
                       to_char(a.jaql515femov, 'YYYYMMDD') ||
                       to_char(a.jaql515femov, 'YYYYMMDD') ||
                       lpad(trim(replace(to_char(jaqy584mocob, '99999999.99'),
                                         '.',
                                         '')),
                            15,
                            '0') || lpad('0', 15, '0') ||
                       lpad(trim(replace(to_char(jaqy584mocob, '99999999.99'),
                                         '.',
                                         '')),
                            15,
                            '0') || '222221' || lpad(' ', 6, ' ') ||
                       lpad(' ', 22, ' ') || lpad(' ', 4, ' ') ||
                       lpad(to_char(a.jaql515cotca), 12, ' ') ||
                       replace(a.jaql515homov, ':', '') ||
                       lpad(' ', 10, ' ') || '  ' || lpad(' ', 10, ' ') || ' ' ||
                       '   '
                  from jaql515 a
                 inner join jaqy584 b
                    on b.jaqy584coent = a.jaql515coent
                   and b.jaqy584cotsv = a.jaql515cotsv
                   and b.jaqy584nrcon = a.jaql515sumin
                   and b.jaqy584copsv = a.jaql515copsv
                   and b.jaqy584comsg = '200'
				   and b.jaqy584coope = '940000'							
                 where a.jaql515coent = 65
                   and jaql515femov = p_c_FecEnv
                   and a.jaql515esreg = 'V' --order by 1 desc;
                
                ) loop
        select e.fila into rec from dual;
        pipe row(rec);
      end loop;
    end if;
    /*Empresas Estandar Online*/
     If CorEst > 0 or flgEstandar=1 then
       --14/03/2025 se comenta listado de empresas y se cambia a una variable
       --p_c_CodEnt in (414, 413, 466, 470, 686, 690,691,700, 706) then --ESTANDAR --fpinto 21/04/2022 se aumenta empresas LCC a formato estandar
                                                         --fpinto 22/09/2023 se aumenta COMBOPLAY  19/03/2024 UPEU fpinto 24/06/2024 se aumenta CBPPUNO y SJBDELASALLE 
                                                         --fpinto 27/11/2024 colegio Buen Pastor 
        for e in (
          select 'T' ||','|| p_c_CodEnt ||','|| to_char(p_c_FecEnv, 'YYYY/MM/DD')||','|| count(1) ||','|| trim(to_char(sum(b.jaql516mocob), '9999999.99'))||',' fila
            from jaql515 a
            inner join jaql516 b on a.jaql515copsv = b.jaql515copsv
            where a.jaql515coent = p_c_CodEnt
            and a.jaql515esreg = 'V' and a.jaql515femov = p_c_FecEnv --'08/11/2018'
            union all
            select x.fila from 
            (select 'D' ||','|| 
                   trim(a.jaql515sumin)||','||
                   trim(b.jaql516nudoc)||','||
                   trim(to_char(b.jaql516mocob, '9999999.99'))||','||                   
                   a.jaql515homov||','||
                   to_char(a.jaql515femov, 'YYMMDD') || lpad(a.jaql515pgsuc, 3, '0')|| lpad(a.jaql515scmod, 3, '0')|| lpad(a.jaql515stran, 3, '0')||
                   lpad(a.jaql515snrel, 4, '0') ||','   fila
            from jaql515 a
            inner join jaql516 b on a.jaql515copsv = b.jaql515copsv
            where a.jaql515coent = p_c_CodEnt
            and a.jaql515esreg = 'V' and a.jaql515femov = p_c_FecEnv --'08/11/2018'
            order by a.jaql515copsv asc) x
          )
        loop
            select e.fila into rec from dual;
            pipe row (rec);
        end loop;               
     end if;	
    --//
    If p_c_CodEnt in (22, 14) then
    
      --SIELSE, ELECTROSUR EN LINEA
      for e in (select y1.jaqy584c127p || '|' || y1.jaqy584c126p || '|' ||
                       (select rpad(trim(scnom), 60, ' ')
                          from fst001
                         where pgcod = 1
                           and sucurs = p1.jaql515pgsuc) || '|' ||
                       (select rpad(trim(jaql513descr), 30, ' ')
                          from jaql513
                         where jaql513cotca = p1.jaql515cotca) || '|' ||
                       to_char(p1.jaql515femov, 'yyyyMMdd') ||
                       replace(p1.jaql515homov, ':', '') || '|' ||
                       to_char(p1.jaql515femov, 'yyyyMMdd') ||
                       replace(p1.jaql515homov, ':', '') || '|' ||
                       to_char(p1.jaql515femov, 'yyyyMMdd') ||
                       lpad(to_char(p1.jaql515pgsuc), 4, '0') ||
                       lpad(to_char(p1.jaql515scmod), 4, '0') ||
                       lpad(to_char(p1.jaql515stran), 4, '0') ||
                       lpad(to_char(p1.jaql515snrel), 4, '0') || '|' ||
                       to_char(p1.jaql515mtoop, '999,999,999.00') || '|' ||
                       y1.JAQY584C125R fila
                  from jaqy584 y1, jaql515 p1
                 where y1.jaqy584feape = p1.jaql515femov
                   and p1.jaql515coent = y1.jaqy584coent
                   and p1.jaql515cotsv = y1.jaqy584cotsv
                   and p1.jaql515esreg = y1.jaqy584confi
                   and p1.jaql515sumin = y1.jaqy584nrcon
                   and p1.jaql515coent = p_c_CodEnt
                   and p1.jaql515cotsv = 2
                   and y1.jaqy584coope = 'P'
                   and y1.jaqy584confi = 'V'
                   and p1.jaql515esreg = 'V'
                   and p1.jaql515femov = p_c_FecEnv) loop
        select e.fila into rec from dual;
        pipe row(rec);
      end loop;
    end if;
    --//
    if p_c_CodEnt = '7' then
      --Movistar
      for e in (select 'DSDTMSG,DSDCOPERAC,DSDINSTITU,DSDSINSTIT,DSDTTERMIN,DSDIDTERMI,DSDFECHATR'||
                       ',DSDHORATRX,DSDNROTRAC,DSDIMPORTE,DSDNROABON,DSDMONEDA,DSDDATOSOR,DSDPTOEMIS'||
                       ',DSDCOMPAGO,DSDCOMAFEI,DSDCOMNAFE,DSDIGVCOM,DSDCOMISTO,DSDVALNETT,DSDIMPNETA'||
                       ',DSDFECABON,DSDMONEDAT,DSDNUMCUEN,DSDNUMTRXA,DSDCONSOLD,DSDGLOSAFA,DSDGLOSADE'||
                       ',DSDTIPOCPB,DSDTIPDOCI,DSDNUMDOCI,DSDNOMRAZS,DSDBASEIMP,DSDIGV,DSDFECCOMA,DSDTIPOCOM'||
                       ',DSDSERICOM,DSDNUMECOM' fila from dual
               union all
               select '0200' || ',' || ' ' || ',' || to_char(p.jaql515coent) || ',' ||
                    ' ' || ',' || case
                         when p.jaql515cotca = 1 then
                          ' 90'
                         when p.jaql515cotca = 7 then
                          ' 15'
                         when p.jaql515cotca = 6 then
                          ' 53'
                         when p.jaql515cotca = 4 then
                          ' 14' 
                       end || ',' || ' ' || ',' || to_char(p.jaql515femov, 'YYYYMMDD') || ',' ||
                    substr(p.jaql515homov,1,2)|| substr(p.jaql515homov,4,2)|| 
                    substr(p.jaql515homov,7,2) || ','
                    || j.jaqy584trace || ',' || to_char(p.jaql515mtoop,'999.99') || ',' ||
                    p.jaql515sumin || ',' || case 
                    when p.jaql515comon=0 then 
                      '604' 
                    when p.jaql515comon<>0 then 
                      '0'  
                    end || ',' || ' ' || ',' || to_char(p.jaql515femov, 'YYYYMMDD') || lpad(to_char(p.jaql515pgsuc),3,'0') 
                    ||lpad(to_char(p.jaql515scmod),3,'0')||lpad(to_char(p.jaql515stran),3,'0')||
                    lpad(to_char(p.jaql515snrel),4,'0') || ',' || 
                    to_char(p.jaql515femov, 'YYYYMMDD') || lpad(to_char(p.jaql515pgsuc),3,'0') 
                    ||lpad(to_char(p.jaql515scmod),3,'0')||lpad(to_char(p.jaql515stran),3,'0')||
                    lpad(to_char(p.jaql515snrel),4,'0') || ',' || '0' || ',' || '0' || ',' 
                    || '0' ||',' || '0' || ',' || to_char(p.jaql515mtoop,'999.99') || ',' ||
                    to_char(p.jaql515mtoop,'999.99') || ',' || to_char(p.jaql515femov, 'YYYYMMDD') || ','
                    ||  case 
                    when p.jaql515comon=0 then 
                      '604' 
                    when p.jaql515comon<>0 then 
                      '0'  
                    end || ',' || ' ' || ',' || to_char(p.jaql515femov, 'YYYYMMDD') || lpad(to_char(p.jaql515pgsuc),3,'0')||
                    lpad(to_char(p.jaql515scmod),3,'0')||lpad(to_char(p.jaql515stran),3,'0')|| lpad(to_char(p.jaql515snrel),4,'0')
                    || ',' || ' ' || ',' || 'Recarga Virtual Servicio Movil' || ',' || 'Recaudacion de Recargas Virtuales' || ','
                    ||'13'||','||' '||','||' '||','||' '||','||to_char(p.jaql515mtoop/1.18,'999.99')||','
                    || case
                    when length(trim(to_char((p.jaql515mtoop/1.18)*0.18,'999.99')))=3 
                      then to_char((p.jaql515mtoop/1.18)*0.18,'0.99')
                    when length(trim(to_char((p.jaql515mtoop/1.18)*0.18,'999.99')))>3 
                      then to_char((p.jaql515mtoop/1.18)*0.18,'999.99')  
                    end 
                    ||','||' '||','||' '||','||' '||','||' ' fila
                    from jaqy584 j, jaql515 p
                    where j.jaqy584feape = p.jaql515femov
                   and p.jaql515coent = j.jaqy584coent
                   and p.jaql515cotsv = j.jaqy584cotsv
                   and p.jaql515esreg = j.jaqy584confi
                   and p.jaql515sumin = j.jaqy584nrcon
                   and j.jaqy584itsuc = p.jaql515pgsuc
                   and j.jaqy584itmod = p.jaql515scmod
                   and j.jaqy584ttran = p.jaql515stran
                   and j.jaqy584itrel = p.jaql515snrel  
                   and j.jaqy584coent = p_c_CodEnt
                   and j.jaqy584feope = p_c_FecEnv
                   and p.jaql515esreg = 'V'
                   ) loop
        select e.fila into rec from dual;
        pipe row(rec);
      end loop;
     end if;
     --//
     if p_c_CodEnt = '9' then
      --Bitel
      for e in (select substr(j.jaqy584c120r,83,12) ||'|'|| trim(substr(j.jaqy584c120r,146,8)) ||'|'
                || to_char(j.jaqy584feope, 'YYYYMMDD') || substr(j.jaqy584hoope,1,2)|| substr(j.jaqy584hoope,4,2)|| 
                    substr(j.jaqy584hoope,7,2) || '|' || case
                    when j.jaqy584cotsv = 10 then
                         j.jaqy584c125r
                    when j.jaqy584cotsv = 6 then
                         trim(substr(j.jaqy584c120r,486,16))
                    end || '|' || case 
                    when j.jaqy584cocan = 1 then '90'
                    when j.jaqy584cocan = 3 then '15'
                    when j.jaqy584cocan = 4 then '14'
                    when j.jaqy584cocan = 6 then '15' 
                    when j.jaqy584cocan = 5 then '05' 
                    end||
                    '|' ||  lpad(to_char(j.jaqy584itsuc),3,'0') || '|' || j.jaqy584nrcon || '|' || case
                    when j.jaqy584cotsv = 10 then
                         trim(substr(j.jaqy584c120r,261,20))
                    when j.jaqy584cotsv = 6 then
                         ' '
                    end || '|' || j.jaqy584trace || '|' || substr(j.jaqy584c120r,340,15)||
                    '|' || substr(j.jaqy584c120r,471,15) || '|' || to_char(j.jaqy584mocob*100) 
                    || '|' || case 
                    when j.jaqy584mone=0 then 
                      '604' 
                    when j.jaqy584mone<>0 then 
                      '0'  
                    end || '|' || case
                    when j.jaqy584cotsv = 6 and j.jaqy584confi = 'V' then
                       'SUCCESS'
                    when j.jaqy584cotsv = 10 and j.jaqy584confi = 'V' then 
                       'SUCCESS'
                    when j.jaqy584confi = 'E' and j.jaqy584tmout = 1 then
                       'TIMEOUT' 
                       end fila
                    from jaqy584 j
                    inner join jaql513 p on p.jaql513cotca = j.jaqy584cocan
                    where j.jaqy584coent = p_c_CodEnt
                   and j.jaqy584feope = p_c_FecEnv
                   and ((j.jaqy584confi = 'V')or (j.jaqy584confi = 'E' and j.jaqy584tmout = 1))
                   ) loop
        select e.fila into rec from dual;
        pipe row(rec);
      end loop;
     end if;
     --/
     if p_c_CodEnt in (398, 399, 400, 3) then
      --Empresas Distriluz
      for e in (select lpad(to_char(sum(to_number(j.jaqy584c126r))),8,'0') || 
                       lpad(to_char(sum(j.jaqy584mocob)*100),12,'0') || 
                       to_char(p_c_FecEnv,'YYYYMMDD') fila 
                       from jaqy584 j
                       where j.jaqy584feope = p_c_FecEnv
                       and j.jaqy584confi = 'V'
                       and j.jaqy584coent = p_c_CodEnt
                       and j.jaqy584coope = 'P'
               union all
               select lpad(j.jaqy584nrcon,8,'0') || q.jaql516pefac || 
                      lpad(to_char(q.jaql516mocob*100),12,'0') ||
                      to_char(p_c_FecEnv,'YYYYMMDD') ||
                      q.jaql516nudoc fila 
                    from jaqy584 j, jaql515 p, jaql516 q
                    where j.jaqy584feape = p.jaql515femov
                   and p.jaql515coent = j.jaqy584coent
                   and p.jaql515cotsv = j.jaqy584cotsv
                   and p.jaql515esreg = j.jaqy584confi
                   and p.jaql515sumin = j.jaqy584nrcon
                   and j.jaqy584itsuc = p.jaql515pgsuc
                   and j.jaqy584itmod = p.jaql515scmod
                   and j.jaqy584ttran = p.jaql515stran
                   and j.jaqy584itrel = p.jaql515snrel 
                   and p.jaql515copsv = q.jaql515copsv 
                   and j.jaqy584coent = p_c_CodEnt
                   and j.jaqy584feope = p_c_FecEnv
                   and j.jaqy584confi = 'V'
                   ) loop
        select e.fila into rec from dual;
        pipe row(rec);
      end loop;
     end if;  
     --Empresas Batch Estandar --rcuadros 24/05/2022 se aumenta empresas batch estandar
     if CorEst = 0 and Conexion = 'B' and  p_c_CodEnt not in (5,10) then
        DECLARE 
            cursor c1 is 
            select Tp1nro1 from fst198 
            where Tp1cod = 1 
            and Tp1cod1  = 10801
            and Tp1corr1 = (p_c_CodEnt + 100)
            and Tp1corr2 = p_c_CodSer                     --//rcuadros 31/08/2022 - Se aumenta código de servicio 
            and Tp1corr3 > 0 order by Tp1corr3;
            type val is varray(11) of fst198.Tp1nro1%type;
            VecLen2 val := val();
            counter integer := 0;
        BEGIN 
            for x in c1 loop
                counter := counter + 1;
                VecLen2.extend;
                VecLen2(counter) := x.Tp1nro1;
            end loop;
            for e in (
                (select rpad(lpad(a.jaql515sumin, VecLen2(1), '0') ||
                       lpad(b.jaql516nudoc, VecLen2(2), '0') ||
                       lpad(to_char(a.jaql515femov, 'YYYYMMDD') , VecLen2(3), '0') ||
                       lpad(trim(replace(to_char(b.jaql516mocob, '9999999.99'), '.', '')), VecLen2(4), '0') ||
                       lpad(replace(a.jaql515homov, ':', ''), VecLen2(5), '0') ||
                       lpad(trim(to_char(a.jaql515snrel)), VecLen2(6), '0') ||
                       lpad(trim(to_char(a.jaql515cotca)), VecLen2(7), '0') ||
                       rpad(substr(nvl(nvl((select trim(jaql506clien) from jaql506 --//rcuadros 31/08/2022 - Se obtiene el nombre del cliente
                                            where jaql506coent = p_c_CodEnt
                                            and jaql506nrcon   = a.jaql515sumin
                                            and rownum = 1),
                                           (select trim(jaql507clien) from jaql507
                                            where jaql507coent = p_c_CodEnt
                                            and jaql507cotse   = a.jaql515cotsv
                                            and jaql507nrcon   = a.jaql515sumin
                                            and rownum = 1)), ' '), 1, VecLen2(8)), VecLen2(8), ' ') ||
                       '00000000' || '00000000', 250, ' ') fila --// rcuadros 18/11/2022 - se aumenta espacios en blanco, segun el formato estandar                  
                from jaql515 a
                inner join jaql516 b
                on a.jaql515copsv = b.jaql515copsv
                where a.jaql515coent = p_c_CodEnt
                and a.jaql515cotsv = p_c_CodSer
                and a.jaql515femov = p_c_FecEnv
                and a.jaql515esreg = 'V')
                union all
                (select '' from dual)
             )loop
             select e.fila into rec from dual;
             pipe row(rec);
           end loop;
       END;
     end if;
     
     --Club Internacional  --rcuadros 31/08/2022 - Se aumenta empresa Club Internacional
     if p_c_CodEnt = 10 and p_c_CodSer = 3 then                         
        for e in (select rpad(trim(lpad(trim(a.jaql515sumin), 7, '0')), 10, ' ') ||
                         rpad(trim(b.jaql516nudoc), 15, ' ') ||
                         rpad(trim(to_char(a.jaql515snrel)), 9, ' ') ||
                         trim(to_char(a.jaql515femov, 'DDMMYYYY')) ||
                         replace(a.jaql515homov, ':', '') ||
                         lpad(trim(replace(to_char(b.jaql516mocob, '99999999.99'), '.', '')), 12, '0') fila
                  from jaql515 a
                  inner join jaql516 b
                  on a.jaql515copsv = b.jaql515copsv
                  where a.jaql515coent = p_c_CodEnt
                  and a.jaql515cotsv = p_c_CodSer
                  and a.jaql515femov = p_c_FecEnv
                  and a.jaql515esreg = 'V'
         )loop
         select e.fila into rec from dual;
         pipe row(rec);
       end loop;
     end if;
     --Multivision  --rcuadros 31/08/2022 - Se aumenta empresa Multivision
     if p_c_CodEnt = 5 and p_c_CodSer = 4 then
        for e in (select rpad(trim(a.jaql515sumin), 10, ' ') ||
                         rpad(trim(b.jaql516nudoc), 15, ' ') ||
                         rpad(trim(to_char(a.jaql515snrel)), 9, ' ') ||
                         trim(to_char(a.jaql515femov, 'YYYYMMDD')) ||
                         replace(a.jaql515homov, ':', '') ||
                         lpad(trim(replace(to_char(b.jaql516mocob, '99999999.99'), '.', '')), 12, '0') ||
                         trim(to_char(a.jaql515femov, 'YYYY')) || lpad(to_char(a.jaql515femov, 'MM'), 2, '0') fila
                  from jaql515 a
                  inner join jaql516 b
                  on a.jaql515copsv = b.jaql515copsv
                  and a.jaql515cotsv = p_c_CodSer
                  where a.jaql515coent = p_c_CodEnt
                  and a.jaql515femov = p_c_FecEnv
                  and a.jaql515esreg = 'V'
         )loop
         select e.fila into rec from dual;
         pipe row(rec);
       end loop;
     end if;
     --//
     /*Empresas Estandar Online con mas de 1 servicio par diferenciar archivos*/
     If p_c_CodEnt in (451,454) then --ESTANDAR --KASHIO--fpinto 27/04/2023 se aumenta Universidad Continental a formato estandar
        for e in (
          select 'T' ||','|| p_c_CodEnt ||','|| to_char(p_c_FecEnv, 'YYYY/MM/DD')||','|| count(1) ||','|| trim(to_char(sum(b.jaql516mocob), '9999999.99'))||',' fila
            from jaql515 a
            inner join jaql516 b on a.jaql515copsv = b.jaql515copsv
            where a.jaql515coent = p_c_CodEnt
            and a.jaql515cotsv = p_c_CodSer
            and a.jaql515esreg = 'V' and a.jaql515femov = p_c_FecEnv --'08/11/2018'
            union all
            select x.fila from 
            (select 'D' ||','|| 
                   trim(a.jaql515sumin)||','||
                   trim(b.jaql516nudoc)||','||
                   trim(to_char(b.jaql516mocob, '9999999.99'))||','||                   
                   a.jaql515homov||','||
                   to_char(a.jaql515femov, 'YYMMDD') || lpad(a.jaql515pgsuc, 3, '0')|| lpad(a.jaql515scmod, 3, '0')|| lpad(a.jaql515stran, 3, '0')||
                   lpad(a.jaql515snrel, 4, '0') ||','   fila
            from jaql515 a
            inner join jaql516 b on a.jaql515copsv = b.jaql515copsv
            where a.jaql515coent = p_c_CodEnt
            and a.jaql515cotsv = p_c_CodSer
            and a.jaql515esreg = 'V' and a.jaql515femov = p_c_FecEnv --'08/11/2018'
            order by a.jaql515copsv asc) x
          )
        loop
            select e.fila into rec from dual;
            pipe row (rec);
        end loop;               
     end if;	
     If p_c_CodEnt in (679, 680, 681, 682, 683) then --25/02/2024 fpinto Empresas Agente Cash //14/05/2024 fpinto se corrigen datos      
        for e in (
        select 'CAB' ||'|20100209641|'|| case
                         when p_c_CodEnt = 679 then
                          '02'
                         when p_c_CodEnt = 680 then
                          '04'
                         when p_c_CodEnt = 681 then
                          '05'
                         when p_c_CodEnt = 682 then
                          '06'
                         when p_c_CodEnt = 683 then
                          '07' 
                       end||'|'|| count(1) ||'|'
        || case 
             when count(1)=0 then 
               '0.00'
             when count(1)>0 then
                  trim(to_char(sum(a.jaql515mtoop)))
             end||'|'|| to_char(sysdate, 'YYYYMMDD') fila
            from jaql515 a
            where a.jaql515coent = p_c_CodEnt
            and a.jaql515esreg = 'V' and a.jaql515femov = p_c_FecEnv --'08/11/2018'
        union all
          select x.fila from 
          (select 'DET' ||'|'|| 
                 trim(a.jaql515sumin)||'|'||
                 trim(to_char(a.jaql515mtoop, '9999999.99'))||'|'|| 
                 to_char(a.jaql515femov, 'YYYYMMDD')||'|'||
                 replace(a.jaql515homov, ':', '')||'|'||
                 trim(j.JAQY584C126R)||'|'||
                 trim(j.JAQY584C125R)||'|'||                   
                 trim(j.jaqy584nuref) fila
          from jaql515 a
          inner join jaqy584 j on a.jaql515coent = j.jaqy584coent and a.jaql515cotsv = j.jaqy584cotsv
                                  and a.jaql515esreg = j.jaqy584confi and a.jaql515sumin = j.jaqy584nrcon
                                  and j.jaqy584itsuc = a.jaql515pgsuc and j.jaqy584itmod = a.jaql515scmod
                                  and j.jaqy584ttran = a.jaql515stran and j.jaqy584itrel = a.jaql515snrel
          where a.jaql515coent = p_c_CodEnt
          and a.jaql515esreg = 'V' and a.jaql515femov = p_c_FecEnv --'08/11/2018'
          order by a.jaql515copsv asc) x
         )
        loop
            select e.fila into rec from dual;
            pipe row (rec);
        end loop;              
     end if;
     --//
    return;
  END fn_obtener_pagos;

  procedure sp_agencia_exoneradas is
    cursor agencias_servicios is
      select x.*,
             y.jaql509cobra,
             y.jaql509opecm,
             y.jaql509clicm,
             z.jaql874exone,
             case
               when y.jaql509clicm = 'S' and z.jaql874exone = 'S' then
                'S'
               when y.jaql509clicm = 'S' and z.jaql874exone = 'N' then
                'S'
               when y.jaql509clicm = 'N' and z.jaql874exone = 'S' then
                'S'
               when y.jaql509clicm = 'N' and z.jaql874exone = 'N' then
                'N'
             end Cobra
        from (select a.pgcod, a.sucurs, c.jaql508coent, c.jaql509cotse
                from fst001 a
               cross join jaql509 c
              minus
              select d.jaql518pgcod,
                     d.jaql518pgsuc,
                     d.jaql518coent,
                     d.jaql518cotsv
                from jaql518 d) x
       inner join jaql509 y
          on x.jaql508coent = y.jaql508coent
         and x.jaql509cotse = y.jaql509cotse
       inner join jaql874 z
          on x.pgcod = z.jaql874pgcod
         and x.sucurs = z.jaql874pgsuc;
  
    lc_error  varchar2(500);
    ln_nroerr number := 0;
  BEGIN
  
    insert into jaql874
      select 1, sucurs, 'N', trunc(sysdate), 'V', 'CIERRE'
        from fst001
      minus
      select 1, jaql874pgsuc, 'N', trunc(sysdate), 'V', 'CIERRE'
        from jaql874;
    commit;
  
    for p in agencias_servicios loop
      insert into jaql518
        (jaql518pgcod,
         jaql518pgsuc,
         jaql518coent,
         jaql518cotsv,
         jaql518cobra,
         jaql518exone,
         jaql518esreg)
      values
        (p.pgcod,
         p.sucurs,
         p.jaql508coent,
         p.jaql509cotse,
         p.cobra,
         p.jaql874exone,
         'V');
    end loop;
  
    select nvl(max(AQPA171Id), 0) + 1 into ln_nroerr from AQPA171;
    lc_error := 'Proceso Correcto';
    insert into AQPA171
      (AQPA171ID, AQPA171RESULT, AQPA171FECREG, AQPA171HORREG)
    values
      (ln_nroerr, lc_error, trunc(sysdate), TO_CHAR(sysdate, 'HH:MI:SS'));
    commit;
  
  EXCEPTION
    WHEN OTHERS THEN
      select nvl(max(AQPA171Id), 0) + 1 into ln_nroerr from AQPA171;
      lc_error := sqlerrm;
      insert into AQPA171
        (AQPA171ID, AQPA171RESULT, AQPA171FECREG, AQPA171HORREG)
      values
        (ln_nroerr, lc_error, trunc(sysdate), TO_CHAR(sysdate, 'HH:MI:SS'));
    
  end sp_agencia_exoneradas;

end PQ_SERVICIO_RECAUDACION;
/
