create or replace package pq_cn_reportes is

  -- Author  : HLAQUI
  -- Created : 30/12/2019
  -- Purpose : Paquete que obtiene reportes para canales
  -- Autor Modificacion: Keny J. Pauccarima Vásquez
  -- Fecha Modificacion: 04/04/2024
  -- Descripcion Modificacion: Se añade reporte de concilición PCSE a través de Bantotal
  -- Autor Modificacion: Keny J. Pauccarima Vásquez
  -- Fecha Modificacion: 09/04/2024
  -- Descripcion Modificacion: Se añade modificación reporte de conciliación PCSE
  -- Autor Modificacion: Keny J. Pauccarima Vásquez
  -- Fecha Modificacion: 01/07/2024
  -- Descripcion Modificacion: Se añade reportes de transacción de ATM. 
  ----sp_reporte_transaccion_ATM: reporte Transacciones aprobadas en el Switch Transacional FTS sin confirmación de respuesta del ATM 	
  ----sp_reporte_transaccion_ATM_02: 	Reporte Transacciones aprobadas en el Switch Transaccional FTS con generación de código de error (fraude).
  -- Autor Modificacion: 
  -- Fecha Modificacion:
  -- Descripcion:
  procedure sp_reporte_limites(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_numtar varchar2, p_c_error out varchar2);
  procedure sp_reporte_cajamovil(pd_fecini in date, pd_fecfin in date, pn_tiprep in number);
  procedure sp_reporte_trama745(pd_fecha in date);
  procedure sp_reporte_operaciones_cm_hb(p_dFecIni in date, p_dFecFin in date, p_cCodUsu in varchar2,
                                         p_nRegMas out number, p_nRegFem out number, p_nRegJur out number,
                                         p_nTraMas out number, p_nTraFem out number, p_nTraJur out number,
                                         p_cError out varchar2);
  procedure sp_reporte_agentes_rep30(p_cCodUsu in varchar2, p_cError out varchar2);
  procedure sp_reporte_cajeros_rep30(p_cCodUsu in varchar2, p_cError out varchar2);
  procedure sp_reporte_conciliacion_PCSE(pd_fecha in date, pd_error out varchar2);
  procedure sp_reporte_transaccion_ATM(pd_fecha in date, pd_error out varchar2);
  procedure sp_reporte_transaccion_ATM_02(pd_fecha in date, pd_error out varchar2);
end pq_cn_reportes;
/

create or replace package body pq_cn_reportes is

procedure sp_reporte_limites(p_c_Codusu varchar2, p_d_FecIni date, p_d_FecFin date, p_c_numtar varchar2,p_c_error out varchar2) is
  begin         
      delete from aqpa706a where aqpa706aCodUsu = upper(p_c_Codusu);
      commit;
      insert into aqpa706a --Reporte de Límites
      (aqpa706acodusu, aqpa706acorr, aqpa706afecini, aqpa706afecfin, aqpa706afecreg, 
       aqpa706ahorreg, aqpa706anomcli, aqpa706anumdoc, aqpa706amedio, aqpa706alimini, 
       aqpa706alimnue, aqpa706acorreo )
       
      
      select upper(p_c_Codusu), rownum, p_d_FecIni, p_d_FecFin, x.z0e483fch Fecha, z0e483hor Hora, z0e483nom Nombre_Cliente, z0e483thd Documento, x.medio, 
      case 
        when x.z0e483lex_prev = 1 then 'A'
        when x.z0e483lex_prev = 2 then 'B'
        when x.z0e483lex_prev = 3 then 'C'
        when x.z0e483lex_prev = 4 then 'D'
        when x.z0e483lex_prev = 5 then 'E'
        when x.z0e483lex_prev = 6 then 'F'
        end Limite_Inicial,  
      case 
        when x.z0e483lex = 1 then 'A'
        when x.z0e483lex = 2 then 'B'
        when x.z0e483lex = 3 then 'C'
        when x.z0e483lex = 4 then 'D'
        when x.z0e483lex = 5 then 'E'
        when x.z0e483lex = 6 then 'F'
        end Nuevo_Limite
      ,
      (select jaqz205email from jaqz205 where JAQZ205NUTAR = x.z0e483nro) Correo
      from (

          select z0e483fch, z0e483hor, z0e483nom, z0e483thd,   z0e483nro,
                 case when z0e483uau = 'USRMOVIL' then 'APP'
                      when z0e483uau = 'USRHB' then 'HB'
                      else 'Agencia'
                 end medio,
                 z0e483lex,
                 lead(z0e483lex, 1, 0) OVER (partition by z0e483nro order by z0e483fch desc, z0e483hor desc) AS z0e483lex_prev
          from z0e483
          where z0e463cod = 1 and z0e483nro = rpad(trim(p_c_numtar),19,' ') and  z0e483fmd >= p_d_FecIni and z0e483fmd <= p_d_FecFin  and z0e483est<>'NA'             

      ) x where 
      x.z0e483lex <> x.z0e483lex_prev order by z0e483fch asc, z0e483hor asc;     
      commit;
  EXCEPTION
    WHEN OTHERS THEN
      p_c_error := sqlerrm;
end sp_reporte_limites;

procedure sp_reporte_cajamovil(pd_fecini in date,
                            pd_fecfin in date,
                            pn_tiprep in number) is
                            
    
     cursor creditos is
        select itimp1 Monto, to_char(ittasa, 'FM9999.00') Tasa, z.sucurs codAgencia,z.scnom Agencia, x.moneda,x.ctnro cuenta, y.pendoc documento,  
               (SELECT penom from fsd001 where pendoc=y.pendoc) Cliente, x.itfcon fecha_desembolso , x.ithora hora_desembolso,
                x.itoper operacion, x.modulo, x.ittope 
        from (
        select itsucd, ctnro, itoper, itsubo,itimp1, ittasa,a.itfcon, a.ithora, b.moneda, b.modulo, b.ittope from fsd015 a
        inner join fsd016 b on 
              a.pgcod= b.pgcod and a.itmod = b.itmod and 
              a.ittran = b.ittran and a.itnrel=b.itnrel and
              a.itsuc= b.itsuc and b.itord = 10
        where a.itmod=489 and a.ittran in (951,360) and a.itcont='S'
              and a.itfcon between pd_fecini and  pd_fecfin
        union all
        select hsucur, hcta, hoper, hsubop,hcimp1, hctasa,a.hfcon, a.hhora, b.hmda, b.hmodul, b.htoper from fsh015 a 
        inner join fsh016 b on 
              a.pgcod = b.pgcod and a.hcmod=b.hcmod and 
              a.htran = b.htran and a.hnrel = b.hnrel and 
              a.hsucor = b.hsucor and a.hfcon = b.hfcon and b.hcord=10
        where a.hcmod=489 and a.htran in (951,360) and a.hccorr=0
              and a.hfcon between pd_fecini and  pd_fecfin ) x 
        inner join fsr008 y on y.ctnro = x.ctnro and y.cttfir='T'
        inner join fst001 z on z.sucurs = x.itsucd
        order by x.itfcon desc, x.ithora desc;  
    
     cursor lineas is
        select itimp1 Monto, to_char(ittasa, 'FM9999.00') Tasa, z.sucurs codAgencia,z.scnom Agencia, x.moneda,x.ctnro cuenta, y.pendoc documento,  
          (SELECT penom from fsd001 where pendoc=y.pendoc) Cliente, x.itfcon fecha_desembolso , x.ithora hora_desembolso,
                  x.itoper operacion       
          from (
          select itsucd, ctnro, itoper, itsubo,itimp1, ittasa,a.itfcon, a.ithora, b.moneda from fsd015 a
          inner join fsd016 b on 
                a.pgcod= b.pgcod and a.itmod = b.itmod and 
                a.ittran = b.ittran and a.itnrel=b.itnrel and
                a.itsuc= b.itsuc and b.itord = 10
          where a.itmod=489 and a.ittran in (59,61) and a.itcont='S' --86
                and a.itfcon between pd_fecini and  pd_fecfin
          union all
          select hsucur, hcta, hoper, hsubop,hcimp1, hctasa,a.hfcon, a.hhora, b.hmda from fsh015 a 
          inner join fsh016 b on 
                a.pgcod = b.pgcod and a.hcmod=b.hcmod and 
                a.htran = b.htran and a.hnrel = b.hnrel and 
                a.hsucor = b.hsucor and a.hfcon = b.hfcon and b.hcord=10
          where a.hcmod=489 and a.htran in (59,61) and a.hccorr=0
                and a.hfcon between pd_fecini and  pd_fecfin) x 
          inner join fsr008 y on y.ctnro = x.ctnro and y.cttfir='T'
          inner join fst001 z on z.sucurs = x.itsucd
          order by x.itfcon desc, x.ithora desc;
     
     cursor dpf is
        select itimp1 Monto, itpzo Plazo, z.sucurs codAgencia,z.scnom Agencia, x.moneda,x.ctnro cuenta, y.pendoc documento,  
          (SELECT penom from fsd001 where pendoc=y.pendoc) Cliente, x.itfcon fecha_apertura , x.ithora hora_apertura,
                x.itoper operacion       
          from (
          select itsucd, ctnro, itoper, itsubo,itimp1, ittasa,a.itfcon, a.ithora, b.moneda,b.itpzo from fsd015 a
          inner join fsd016 b on 
                a.pgcod= b.pgcod and a.itmod = b.itmod and 
                a.ittran = b.ittran and a.itnrel=b.itnrel and
                a.itsuc= b.itsuc and b.itord = 5
          where a.itmod=489 and a.ittran in (800) and a.itcont='S' --86
                and a.itfcon between pd_fecini and  pd_fecfin
          union all
          select hsucur, hcta, hoper, hsubop,hcimp1, hctasa,a.hfcon, a.hhora, b.hmda,b.hcpzo from fsh015 a 
          inner join fsh016 b on 
                a.pgcod = b.pgcod and a.hcmod=b.hcmod and 
                a.htran = b.htran and a.hnrel = b.hnrel and 
                a.hsucor = b.hsucor and a.hfcon = b.hfcon and b.hcord=5
          where a.hcmod=489 and a.htran in (800) and a.hccorr=0
                and a.hfcon between pd_fecini and  pd_fecfin) x 
          inner join fsr008 y on y.ctnro = x.ctnro and y.cttfir='T'
          inner join fst001 z on z.sucurs = x.itsucd
          order by x.itfcon desc, x.ithora desc;
     
     cursor aperturaCuentas is
        select tonom SubTipo, y.scsuc codAgencia, w.scnom Agencia, moneda, cuenta, SubOpe , numdoc documento, 
          (SELECT penom from fsd001 where pendoc=numdoc and petdoc= tipdoc and pepais=pais) Cliente, 
          Fecha, hora, 
            case when trim(tarjeta) is null then 'N' else 'S' end TieneTarjeta, 
          medio  
        from (
          select to_number(substr(aqpa705ctaori,1,9)) Cuenta, to_number(substr(aqpa705ctaori,16,2)) SubOpe,to_number(substr(aqpa705ctaori,18,3)) TipOpe, aqpa705ctaori,
            aqpa705fectra Fecha , aqpa705hortra Hora, aqpa705nutar tarjeta,aqpa705pdoc pais, aqpa705tdoc tipdoc,aqpa705ndoc numdoc, aqpa705mdaope moneda, aqpa705auxv5 medio
            from aqpa705 a where aqpa705tipope in ('A','T') ) x 
          inner join fsd011 y on y.PGCOD =1 and SCCTA=x.cuenta and y.SCMOd=21 and y.SCMDA=x.moneda and y.SCPAP=0 and y.SCTOPE = x.tipope and y.SCOPER=0 and y.SCSBOP=x.SubOpe
          inner join fst004 z on z.modulo=21 and z.totope=x.TipOpe
          inner join fst001 w on w.sucurs = y.scsuc
        where Fecha between pd_fecini and  pd_fecfin
        order by fecha desc, hora desc;
     
     cursor proteccionTarjeta is
        select aqpa191fecreg fecha, aqpa191horreg hora, aqpa191numdoc numdoc, aqpa191importe monto 
        from aqpa191 
        where aqpa191tipope = 'P' and aqpa191fecreg between pd_fecini and  pd_fecfin
        ORDER BY fecha desc, hora desc; 
     
     cursor soat is
        select aqpa191fecreg fecha, aqpa191horreg hora, aqpa191numdoc numdoc, aqpa191importe monto 
        from aqpa191 
        where aqpa191tipope = 'C' and aqpa191fecreg between pd_fecini and  pd_fecfin
        ORDER BY fecha desc, hora desc; 
      
    cursor destinatarios is
       select trim(a.tp1desc) || '@' || trim(b.tp1desc) tp1desc
        from fst198 a
       inner join fst198 b
          on a.tp1nro2 = b.tp1corr2
         and b.tp1cod = 1
         and b.tp1cod1 = 10801
         and b.tp1corr1 = 35
         and b.tp1corr3 = 0
       where a.tp1cod = 1
         and a.tp1cod1 = 11142
         and a.Tp1corr1 = 5
         and a.tp1corr2 = 1         
         and a.tp1corr3 > 0;
   
   
   cursor c_host is
      select *
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10825
         and Tp1corr1 = 61
         and Tp1corr2 = 7;   
  
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
    v_host      VARCHAR2(80);
    
  BEGIN
   /*if pn_tiprep = 1 then                   

     
   end if;  */
  
   SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
   
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
       
  if v_found =1 then
                            
      v_From      := 'cajamovil@cajaarequipa.pe';           
      v_Subject := 'Reporte de CajaMovil';
      /*For asu in asunto loop
          v_Subject := v_Subject || asu.tp1desc;
      end loop;            
      v_Subject     := v_Subject || ' ' || v_emp || ' - ' || v_serv || ' ' ||
                       to_char(fecha, 'yyyy.mm.dd');--yyyy.mm.dd hh24:mi:ss    */    
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
      for dest in destinatarios() loop
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
      v_Body := 'Se adjunta reporte solicitado';    
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
      
      v_Nombre := 'Reporte_Varios'; --CAMBIAR
      IF pn_tiprep = 1 THEN                   
           v_Nombre := 'Reporte_Creditos'; --CAMBIAR 
      ELSIF pn_tiprep = 2 THEN 
           v_Nombre := 'Reporte_Lineas'; --CAMBIAR 
      ELSIF pn_tiprep = 3 THEN 
           v_Nombre := 'Reporte_DPF'; --CAMBIAR 
      ELSIF pn_tiprep = 4 THEN 
           v_Nombre := 'Reporte_AperturaCuentas'; --CAMBIAR 
      ELSIF pn_tiprep = 5 THEN 
           v_Nombre := 'Reporte_Protecion'; --CAMBIAR 
      ELSIF pn_tiprep = 6 THEN 
           v_Nombre := 'Reporte_Soat'; --CAMBIAR 
      END IF;     
      
      utl_smtp.write_data(V_Conexion,
                          ' filename=' || v_Nombre ||
                          to_char(fecha, 'DD-MM-RRRR') || '.xls' ||
                          utl_tcp.crlf || utl_tcp.crlf);                              
      
      IF pn_tiprep = 1 THEN                   
          --nombres de las columnas
          v_wstring := ' ' || chr(9) || 'CODAGENCIA' || chr(9) || 'AGENCIA' || chr(9) || 'MONEDA'
                    || chr(9) || 'CUENTA' || chr(9) || 'DOCUMENTO' || chr(9) || 'CLIENTE' || chr(9) || 'TASA'
                    || chr(9) || 'MONTO DESEMBOLSO' || chr(9) || 'FECHA ' || chr(9) || 'HORA '
                    || chr(9) || 'OPERACION' || chr(9) || 'MODULO' || chr(9) || 'TIP OPE' || chr(9);
          rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
          UTL_smtp.write_raw_data(V_Conexion, rawData);
          corr := 1;
          --contenido de las columnas      
          for x in creditos loop       
            
            v_wstring := corr || chr(9) || x.codagencia || chr(9) || 
                         x.agencia || chr(9) || x.moneda || chr(9) || x.cuenta || chr(9) || x.documento || chr(9) ||
                         x.cliente || chr(9) || x.Tasa || chr(9) || x.Monto || chr(9) || x.fecha_desembolso || chr(9) || 
                         x.hora_desembolso || chr(9) || x.operacion || chr(9) || x.modulo  || chr(9) || x.ittope || chr(9); 
            rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
            UTL_smtp.write_raw_data(V_Conexion, rawData);
            corr:= corr + 1;
          end loop;
      ELSIF pn_tiprep = 2 THEN 
           --nombres de las columnas
          v_wstring := ' ' || chr(9) || 'CODAGENCIA' || chr(9) || 'AGENCIA' || chr(9) || 'MONEDA'
                    || chr(9) || 'CUENTA' || chr(9) || 'DOCUMENTO' || chr(9) || 'CLIENTE' || chr(9) || 'TASA'
                    || chr(9) || 'MONTO DESEMBOLSO' || chr(9) || 'FECHA ' || chr(9) || 'HORA '
                    || chr(9) || 'OPERACION' || chr(9);-- || 'MODULO' || chr(9) || 'TIP OPE' || chr(9);
          rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
          UTL_smtp.write_raw_data(V_Conexion, rawData);
          corr := 1;
          --contenido de las columnas      
          for x in lineas loop       
            
            v_wstring := corr || chr(9) || x.codagencia || chr(9) || 
                         x.agencia || chr(9) || x.moneda || chr(9) || x.cuenta || chr(9) || x.documento || chr(9) ||
                         x.cliente || chr(9) || x.Tasa || chr(9) || x.Monto || chr(9) || x.fecha_desembolso || chr(9) || 
                         x.hora_desembolso || chr(9) || x.operacion || chr(9);-- || x.modulo  || chr(9) || x.ittope || chr(9); 
            rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
            UTL_smtp.write_raw_data(V_Conexion, rawData);
            corr:= corr + 1;
          end loop;
      ELSIF pn_tiprep = 3 THEN 
           --nombres de las columnas
          v_wstring := ' ' || chr(9) || 'CODAGENCIA' || chr(9) || 'AGENCIA' || chr(9) || 'MONEDA'
                    || chr(9) || 'CUENTA' || chr(9) || 'DOCUMENTO' || chr(9) || 'CLIENTE' || chr(9) || 'PLAZO'
                    || chr(9) || 'MONTO APERTURA' || chr(9) || 'FECHA ' || chr(9) || 'HORA '
                    || chr(9) || 'OPERACION' || chr(9);-- || 'MODULO' || chr(9) || 'TIP OPE' || chr(9);
          rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
          UTL_smtp.write_raw_data(V_Conexion, rawData);
          corr := 1;
          --contenido de las columnas      
          for x in dpf loop       
            
            v_wstring := corr || chr(9) || x.codagencia || chr(9) || 
                         x.agencia || chr(9) || x.moneda || chr(9) || x.cuenta || chr(9) || x.documento || chr(9) ||
                         x.cliente || chr(9) || x.plazo || chr(9) || x.Monto || chr(9) || x.fecha_apertura || chr(9) || 
                         x.hora_apertura || chr(9) || x.operacion || chr(9);-- || x.modulo  || chr(9) || x.ittope || chr(9); 
            rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
            UTL_smtp.write_raw_data(V_Conexion, rawData);
            corr:= corr + 1;
          end loop;
      ELSIF pn_tiprep = 4 THEN 
           --nombres de las columnas
          v_wstring := ' ' || chr(9) || 'CODAGENCIA' || chr(9) || 'AGENCIA' || chr(9) || 'MONEDA'
                    || chr(9) || 'CUENTA' || chr(9) || 'DOCUMENTO' || chr(9) || 'CLIENTE' || chr(9) || 'SUB OPE'
                    || chr(9) || 'SUB TIPO' || chr(9) || 'FECHA ' || chr(9) || 'HORA '
                    || chr(9) || 'TIENE TARJETA' || chr(9) || 'MEDIO' || chr(9);--  ||'TIP OPE' || chr(9);
          rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
          UTL_smtp.write_raw_data(V_Conexion, rawData);
          corr := 1;
          --contenido de las columnas      
          for x in aperturaCuentas loop       
            
            v_wstring := corr || chr(9) || x.codagencia || chr(9) || 
                         x.agencia || chr(9) || x.moneda || chr(9) || x.cuenta || chr(9) || x.documento || chr(9) ||
                         x.cliente || chr(9) || x.Subope || chr(9) || x.Subtipo || chr(9) || x.fecha || chr(9) || 
                         x.hora || chr(9) || x.tienetarjeta || chr(9)|| x.medio  || chr(9);--  || x.ittope || chr(9); 
            rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
            UTL_smtp.write_raw_data(V_Conexion, rawData);
            corr:= corr + 1;
          end loop;
      ELSIF pn_tiprep = 5 THEN 
           --nombres de las columnas
          v_wstring := ' ' || chr(9) || 'DOCUMENTO' || chr(9) || 'MONTO' || chr(9) || 'FECHA'
                    || chr(9) || 'HORA' || chr(9);--  ||'TIP OPE' || chr(9);
          rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
          UTL_smtp.write_raw_data(V_Conexion, rawData);
          corr := 1;
          --contenido de las columnas      
          for x in proteccionTarjeta loop       
            
            v_wstring := corr || chr(9) || x.numdoc || chr(9) || 
                         x.monto || chr(9) || x.fecha || chr(9) || x.hora || chr(9);--  || x.ittope || chr(9); 
            rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
            UTL_smtp.write_raw_data(V_Conexion, rawData);
            corr:= corr + 1;
          end loop;
      ELSIF pn_tiprep = 6 THEN 
           --nombres de las columnas
          v_wstring := ' ' || chr(9) || 'DOCUMENTO' || chr(9) || 'MONTO' || chr(9) || 'FECHA'
                    || chr(9) || 'HORA' || chr(9);--  ||'TIP OPE' || chr(9);
          rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
          UTL_smtp.write_raw_data(V_Conexion, rawData);
          corr := 1;
          --contenido de las columnas      
          for x in soat loop       
            
            v_wstring := corr || chr(9) || x.numdoc || chr(9) || 
                         x.monto || chr(9) || x.fecha || chr(9) || x.hora || chr(9);--  || x.ittope || chr(9); 
            rawData := utl_raw.cast_to_raw(v_wstring || utl_tcp.crlf);
            UTL_smtp.write_raw_data(V_Conexion, rawData);
            corr:= corr + 1;
          end loop;
      END IF; 
      
      
      
      v_header := '';
      utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
   
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
      --p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000, 'Unable to send mail: ' || sqlerrm);
  END sp_reporte_cajamovil;
  
procedure sp_reporte_trama745(pd_fecha in date) is
  
cursor afiliaciones (fecha date) is
select * from jaqz208 a where jaqz208cotra='100033' and jaqz208secrs='00000' and jaqz208fetra = fecha;

cursor loginlogs (fecha date) is
select * from jaqz208 where jaqz208cotra='100098' and jaqz208secrs in ('00000','55003', '55002') and jaqz208fetra = fecha;
ip varchar (100) ; 
tipo varchar (20) ; 
canal varchar(20);
dni varchar(20);
idcorr number(9);
indclav varchar(20);
bloqtem varchar(20);
nomcli varchar(30);
ldFecha date;
lcError varchar(500);
ncanal varchar(5);
dso varchar(20);
modelo varchar(50);
devideid varchar(50);

  BEGIN
    if pd_fecha IS NULL THEN
      select pgfape -1 into ldFecha from fst017 where pgcod = 1;     
    Else
      ldFecha    := pd_fecha;
    End If;
/* Hlaqui 22/04/2022 - Ya no aplica debido a que se registrará la data de forma inmediata en el procedimiento AQPA720C    
    begin
      idcorr := 1;
      for i in afiliaciones (ldFecha) loop   
        ip:=trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/IPADDR/text()').GETSTRINGVAL());
        ncanal:=trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/CANAL/text()').GETSTRINGVAL());
        canal:=case when Trim(ncanal)='3' then 'HOMEBANKING' else 'CAJAMOVIL' end;       
        select trim(z0e478thd) into dni from z0e478 where  z0e478nro=i.jaqz208nutar and rownum = 1;
        
        insert into AQPA725 (AQPA725ID,AQPA725TIPOPE,AQPA725FECHA,AQPA725HORA,AQPA725TIPDIS,AQPA725IMEI,AQPA725NUMTAR,AQPA725NUMDOC,
        AQPA725CLAATM,AQPA725CLAVE6,AQPA725INDCLA,AQPA725BLOTMP,AQPA725NOMCLI,AQPA725CODTRA)
        select idcorr,'AFILIACION',i.JAQZ208FETRA, i.JAQZ208HOTRA, canal, ip ,'426153******' || substr(i.jaqz208nutar,13,4),dni, 'Sí', null, null, null, null, null
        from dual;
        commit;
        idcorr:=idcorr + 1;      
      end loop;                   
    exception
    when others then
         lcError := sqlerrm;
    end;
    
    begin
      idcorr := 1;
      for i in loginlogs (ldFecha) loop   
        tipo:=trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/TIPO/text()').GETSTRINGVAL());
        ncanal:=trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/CANAL/text()').GETSTRINGVAL());
        If tipo = 'LOGIN' and Trim(ncanal) in ('3','6') Then --Solo si la trama es LOGIN en APP y HB           
           ip:=trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/IMEI/text()').GETSTRINGVAL());
           devideid:= case when XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/DDEVICEID/text()') is null then ' ' else trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/DDEVICEID/text()').GETSTRINGVAL()) end ;         
           ncanal:=trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/CANAL/text()').GETSTRINGVAL());           
           dso:=case when XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/DSO/text()') is null then ' ' else trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/DSO/text()').GETSTRINGVAL()) end ;
           modelo:=case when XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/DMODELO/text()') is null then ' ' else trim(XMLTYPE(i.jaqz208trama).EXTRACT('/TRAMAIB/DMODELO/text()').GETSTRINGVAL()) end ;                  
           canal:=case when Trim(ncanal)='3' then 'HOMEBANKING' else 'CAJAMOVIL' end;
           
           indclav:=case when i.jaqz208secrs='00000' then 'Conforme' when i.jaqz208secrs in ('55003', '55002') then  'Errada' end;
           bloqtem:=case when i.jaqz208secrs='55003' then 'Sí' else 'No' end;
           select trim(z0e478thd), trim(z0e478nom) into dni, nomcli from z0e478 where  z0e478nro=i.jaqz208nutar and rownum = 1;
        
           insert into AQPA725 (AQPA725ID,AQPA725TIPOPE,AQPA725FECHA,AQPA725HORA,AQPA725TIPDIS,AQPA725IMEI,AQPA725NUMTAR,AQPA725NUMDOC,AQPA725CLAATM,AQPA725CLAVE6,AQPA725INDCLA,AQPA725BLOTMP,AQPA725NOMCLI,AQPA725CODTRA, AQPA725tiptel, Aqpa725auxc1,Aqpa725auxc2)
           select idcorr,'LOGIN',i.JAQZ208FETRA, i.JAQZ208HOTRA, canal, ip ,'426153******' || substr(i.jaqz208nutar,13,4),dni, null, 'Sí', indclav, bloqtem, nomcli, i.jaqz208cotra, dso,modelo,devideid
           from dual;
           commit;
           idcorr:=idcorr + 1; 
        End If;          
             
      end loop; 
                  
    exception
    when others then
         lcError := sqlerrm;      
    end;               
    */
end sp_reporte_trama745;

procedure sp_reporte_operaciones_cm_hb(p_dFecIni in date, p_dFecFin in date, p_cCodUsu in varchar2,
                                       p_nRegMas out number, p_nRegFem out number, p_nRegJur out number,
                                       p_nTraMas out number, p_nTraFem out number, p_nTraJur out number,
                                       p_cError out varchar2) is
    -- jlunaf 11/07/2023 - Se actualiza cursor para considerar cantidad de transacciones y totales diferenciados por género
    cursor homebanking(p_nTipCam number) is 
       SELECT /*+ choose*/
          D.SNGC13DPTO, D.SNGC13PROV, D.SNGC13DIST, COUNT(B.HCORD) AS TRANS,
          COUNT(CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'M' THEN B.HCORD END) AS TRANS_MASC, -- jlunaf 11/07/2023 - Cantidad de transacciones por persona natural masculino
          COUNT(CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'F' THEN B.HCORD END) AS TRANS_FEME, -- jlunaf 11/07/2023 - Cantidad de transacciones por persona natural femenino
          COUNT(CASE WHEN E.PETIPO = 'J' THEN B.HCORD END) AS TRANS_JURI, -- jlunaf 11/07/2023 - Cantidad de transacciones por persona juridica
          SUM(CASE B.HMDA WHEN 0 THEN B.HCIMP1 ELSE B.HCIMP1 * p_nTipCam END) AS MONTOT,
          SUM(CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'M' THEN (CASE B.HMDA WHEN 0 THEN B.HCIMP1 ELSE B.HCIMP1 * p_nTipCam END) ELSE 0 END) AS MONTOT_MASC, -- jlunaf 11/07/2023 - Monto total por persona natural masculino
          SUM(CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'F' THEN (CASE B.HMDA WHEN 0 THEN B.HCIMP1 ELSE B.HCIMP1 * p_nTipCam END) ELSE 0 END) AS MONTOT_FEME, -- jlunaf 11/07/2023 - Monto total por persona natural femenino
          SUM(CASE WHEN E.PETIPO = 'J' THEN (CASE B.HMDA WHEN 0 THEN B.HCIMP1 ELSE B.HCIMP1 * p_nTipCam END) ELSE 0 END) AS MONTOT_JURI, -- jlunaf 11/07/2023 - Monto total por persona juridica
          COUNT(DISTINCT CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'M' THEN C.PEPAIS||C.PETDOC||C.PENDOC END) AS MASC,
          COUNT(DISTINCT CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'F' THEN C.PEPAIS||C.PETDOC||C.PENDOC END) AS FEME,
          COUNT(DISTINCT CASE WHEN E.PETIPO = 'J' THEN C.PEPAIS||C.PETDOC||C.PENDOC END) AS JURI
       FROM FSH015 A
       INNER JOIN FST198 G ON G.TP1COD = 1 AND G.TP1COD1 = 11158 AND G.TP1CORR1 = 3
                          AND G.TP1CORR2 = A.HCMOD AND G.TP1CORR3 = A.HTRAN
       INNER JOIN FSH016 B ON B.PGCOD = A.PGCOD AND B.HCMOD = A.HCMOD AND B.HSUCOR = A.HSUCOR 
                          AND B.HTRAN = A.HTRAN AND B.HNREL = A.HNREL AND B.HFCON = A.HFCON AND B.HCORD = G.TP1NRO1
       INNER JOIN FSR008 C ON C.CTNRO = B.HCTA AND C.CTTFIR = 'T'
       INNER JOIN SNGC13 D ON D.SNGC13PAIS = C.PEPAIS AND D.SNGC13TDOC = C.PETDOC AND D.SNGC13NDOC = C.PENDOC
                          AND D.DOCOD = 1 AND D.SNGC13CORR = 1
       INNER JOIN FSD001 E ON E.PEPAIS = C.PEPAIS AND E.PETDOC = C.PETDOC AND E.PENDOC = C.PENDOC
       LEFT JOIN FSD002 F ON F.PFPAIS = C.PEPAIS AND F.PFTDOC = C.PETDOC AND F.PFNDOC = C.PENDOC
       LEFT JOIN FST071 H ON H.FST071PAI = 604 AND H.FST071DPT = D.SNGC13DPTO AND H.FST071LOC = D.SNGC13PROV
                         AND H.FST071COL = D.SNGC13DIST
       WHERE A.HCMOD = 140 AND A.HCCORR = 0 AND A.HFCON BETWEEN p_dFecIni AND p_dFecFin AND NOT H.FST071DSC IS NULL
       GROUP BY D.SNGC13DPTO, D.SNGC13PROV, D.SNGC13DIST
       ORDER BY D.SNGC13DPTO, D.SNGC13PROV, D.SNGC13DIST;
    -- jlunaf 11/07/2023 - Se actualiza cursor para considerar cantidad de transacciones y totales diferenciados por género
    cursor cajamovil(p_nTipCam number) is 
       SELECT /*+ choose*/
          D.SNGC13DPTO, D.SNGC13PROV, D.SNGC13DIST, COUNT(B.HCORD) AS TRANS,
          COUNT(CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'M' THEN B.HCORD END) AS TRANS_MASC, -- jlunaf 11/07/2023 - Cantidad de transacciones por persona natural masculino
          COUNT(CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'F' THEN B.HCORD END) AS TRANS_FEME, -- jlunaf 11/07/2023 - Cantidad de transacciones por persona natural femenino
          COUNT(CASE WHEN E.PETIPO = 'J' THEN B.HCORD END) AS TRANS_JURI, -- jlunaf 11/07/2023 - Cantidad de transacciones por persona juridica
          SUM(CASE B.HMDA WHEN 0 THEN B.HCIMP1 ELSE B.HCIMP1 * p_nTipCam END) AS MONTOT,
          SUM(CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'M' THEN (CASE B.HMDA WHEN 0 THEN B.HCIMP1 ELSE B.HCIMP1 * p_nTipCam END) ELSE 0 END) AS MONTOT_MASC, -- jlunaf 11/07/2023 - Monto total por persona natural masculino
          SUM(CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'F' THEN (CASE B.HMDA WHEN 0 THEN B.HCIMP1 ELSE B.HCIMP1 * p_nTipCam END) ELSE 0 END) AS MONTOT_FEME, -- jlunaf 11/07/2023 - Monto total por persona natural femenino
          SUM(CASE WHEN E.PETIPO = 'J' THEN (CASE B.HMDA WHEN 0 THEN B.HCIMP1 ELSE B.HCIMP1 * p_nTipCam END) ELSE 0 END) AS MONTOT_JURI, -- jlunaf 11/07/2023 - Monto total por persona juridica
          COUNT(DISTINCT CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'M' THEN C.PEPAIS||C.PETDOC||C.PENDOC END) AS MASC,
          COUNT(DISTINCT CASE WHEN E.PETIPO = 'F' AND UPPER(F.PFCANT) = 'F' THEN C.PEPAIS||C.PETDOC||C.PENDOC END) AS FEME,
          COUNT(DISTINCT CASE WHEN E.PETIPO = 'J' THEN C.PEPAIS||C.PETDOC||C.PENDOC END) AS JURI
       FROM FSH015 A
       INNER JOIN FST198 G ON G.TP1COD = 1 AND G.TP1COD1 = 11158 AND G.TP1CORR1 = 3
                          AND G.TP1CORR2 = A.HCMOD AND G.TP1CORR3 = A.HTRAN
       INNER JOIN FSH016 B ON B.PGCOD = A.PGCOD AND B.HCMOD = A.HCMOD AND B.HSUCOR = A.HSUCOR 
                          AND B.HTRAN = A.HTRAN AND B.HNREL = A.HNREL AND B.HFCON = A.HFCON AND B.HCORD = G.TP1NRO1
       INNER JOIN FSR008 C ON C.CTNRO = B.HCTA AND C.CTTFIR = 'T'
       INNER JOIN SNGC13 D ON D.SNGC13PAIS = C.PEPAIS AND D.SNGC13TDOC = C.PETDOC AND D.SNGC13NDOC = C.PENDOC
                          AND D.DOCOD = 1 AND D.SNGC13CORR = 1
       INNER JOIN FSD001 E ON E.PEPAIS = C.PEPAIS AND E.PETDOC = C.PETDOC AND E.PENDOC = C.PENDOC
       LEFT JOIN FSD002 F ON F.PFPAIS = C.PEPAIS AND F.PFTDOC = C.PETDOC AND F.PFNDOC = C.PENDOC
       LEFT JOIN FST071 H ON H.FST071PAI = 604 AND H.FST071DPT = D.SNGC13DPTO AND H.FST071LOC = D.SNGC13PROV
                         AND H.FST071COL = D.SNGC13DIST
       WHERE A.HCMOD IN (489, 66) AND A.HCCORR = 0 AND A.HFCON BETWEEN p_dFecIni AND p_dFecFin AND NOT H.FST071DSC IS NULL
       GROUP BY D.SNGC13DPTO, D.SNGC13PROV, D.SNGC13DIST
       ORDER BY D.SNGC13DPTO, D.SNGC13PROV, D.SNGC13DIST;
    cursor usuariosRegistrados is 
       SELECT C.SNGC13DPTO, C.SNGC13PROV, C.SNGC13DIST,
              COUNT(CASE WHEN D.PETIPO = 'F' AND UPPER(E.PFCANT) = 'M' THEN 1 END) AS MASC,
              COUNT(CASE WHEN D.PETIPO = 'F' AND UPPER(E.PFCANT) = 'F' THEN 1 END) AS FEME,
              COUNT(CASE WHEN D.PETIPO = 'J' THEN 1 END) AS JURI FROM JAQZ205 A
       INNER JOIN Z0E478 B ON B.Z0E478NRO = A.JAQZ205NUTAR
       INNER JOIN SNGC13 C ON C.SNGC13PAIS = B.Z0E478THP AND C.SNGC13TDOC = B.Z0E478THT AND C.SNGC13NDOC = B.Z0E478THD
                          AND C.DOCOD = 1 AND C.SNGC13CORR = 1
       INNER JOIN FSD001 D ON D.PEPAIS = B.Z0E478THP AND D.PETDOC = B.Z0E478THT AND D.PENDOC = B.Z0E478THD
       LEFT JOIN FSD002 E ON E.PFPAIS = B.Z0E478THP AND E.PFTDOC = B.Z0E478THT AND E.PFNDOC = B.Z0E478THD
       LEFT JOIN FST071 F ON F.FST071PAI = 604 AND F.FST071DPT = C.SNGC13DPTO AND F.FST071LOC = C.SNGC13PROV
                         AND F.FST071COL = C.SNGC13DIST
       WHERE A.JAQZ205FEAFI <= p_dFecFin AND NOT F.FST071DSC IS NULL
       GROUP BY C.SNGC13DPTO, C.SNGC13PROV, C.SNGC13DIST;
    ln_tipcam number := 0;
    i         number := 0;
    ln_count  number;
    ln_CanMas number;
    ln_CanFem number;
    ln_CanJur number;
   begin
     delete from aqpc111 where aqpc111CodUsu = upper(p_cCodUsu);
     commit;
     sp_tipo_cambio(FECHA => p_dFecFin, monori => 101, mondes => 0,
                    tipo => 500, tc => ln_tipcam);
     FOR r IN homebanking (ln_tipcam) LOOP
         i := i + 1;
         -- HOMEBANKING
         -- jlunaf 11/07/2023 - Se actualiza insert para considerar cantidad de transacciones y totales diferenciados por género
         insert into aqpc111
            (aqpc111codusu, aqpc111corr, aqpc111fecini, aqpc111fecfin, aqpc111dpto, aqpc111prov, aqpc111dist,
             aqpc111modulo, aqpc111ntran, aqpc111ntranf, aqpc111ntranm, aqpc111ntranj, aqpc111montot, aqpc111monfem,
             aqpc111monmas, aqpc111monjur, aqpc111ntrusm, aqpc111ntrusf, aqpc111ntrjur, aqpc111nrgusm, aqpc111nrgusf,
             aqpc111nrgjur) values
            (p_cCodUsu, i, p_dFecIni, p_dFecFin, r.SNGC13DPTO, r.SNGC13PROV, r.SNGC13DIST, 140, r.TRANS, r.trans_feme,
             r.trans_masc, r.trans_juri, r.MONTOT, r.montot_feme, r.montot_masc, r.montot_juri, r.MASC, r.FEME, r.JURI, 0, 0, 0);
     END LOOP;
     commit;
     FOR r IN cajamovil (ln_tipcam) LOOP
         i := i + 1;
         -- CAJAMOVIL
         -- jlunaf 11/07/2023 - Se actualiza insert para considerar cantidad de transacciones y totales diferenciados por género
         insert into aqpc111
            (aqpc111codusu, aqpc111corr, aqpc111fecini, aqpc111fecfin, aqpc111dpto, aqpc111prov, aqpc111dist,
             aqpc111modulo, aqpc111ntran, aqpc111ntranf, aqpc111ntranm, aqpc111ntranj, aqpc111montot, aqpc111monfem,
             aqpc111monmas, aqpc111monjur, aqpc111ntrusm, aqpc111ntrusf, aqpc111ntrjur, aqpc111nrgusm, aqpc111nrgusf,
             aqpc111nrgjur) values
            (p_cCodUsu, i, p_dFecIni, p_dFecFin, r.SNGC13DPTO, r.SNGC13PROV, r.SNGC13DIST, 489, r.TRANS, r.trans_feme,
             r.trans_masc, r.trans_juri, r.MONTOT, r.montot_feme, r.montot_masc, r.montot_juri, r.MASC, r.FEME, r.JURI, 0, 0, 0);
     END LOOP;
     commit;
     FOR r IN usuariosRegistrados LOOP
         SELECT COUNT(AQPC111CORR) INTO ln_count FROM AQPC111 WHERE AQPC111CODUSU = p_cCodUsu AND AQPC111DPTO = r.sngc13dpto
            AND AQPC111PROV = r.sngc13prov AND AQPC111DIST = r.sngc13dist;
         IF ln_count > 0 THEN
            update aqpc111 set aqpc111nrgusm = r.masc, aqpc111nrgusf = r.feme, aqpc111nrgjur = r.juri
             where aqpc111codusu = p_cCodUsu and aqpc111dpto = r.sngc13dpto and aqpc111prov = r.sngc13prov and
                   aqpc111dist = r.sngc13dist;
         ELSE
            i := i + 1;
            insert into aqpc111
               (aqpc111codusu, aqpc111corr, aqpc111fecini, aqpc111fecfin, aqpc111dpto, aqpc111prov, aqpc111dist,
                aqpc111modulo, aqpc111ntran, aqpc111montot, aqpc111ntrusm, aqpc111ntrusf, aqpc111ntrjur, aqpc111nrgusm,
                aqpc111nrgusf, aqpc111nrgjur) values
               (p_cCodUsu, i, p_dFecIni, p_dFecFin, r.sngc13dpto, r.sngc13prov, r.sngc13dist, 489, 0, 0, 0, 0, 0,
                r.masc, r.feme, r.juri);
         END IF;
     END LOOP;
     commit;
     
     -- TOTAL USUARIOS REGISTRADOS ENTRE LAS FECHAS INGRESADAS
     begin
       SELECT COUNT(CASE WHEN C.PETIPO = 'F' AND UPPER(D.PFCANT) = 'M' THEN 1 END),
              COUNT(CASE WHEN C.PETIPO = 'F' AND UPPER(D.PFCANT) = 'F' THEN 1 END),
              COUNT(CASE WHEN C.PETIPO = 'J' THEN 1 END) INTO p_nRegMas, p_nRegFem, p_nRegJur FROM JAQZ205 A
       INNER JOIN Z0E478 B ON B.Z0E478NRO = A.JAQZ205NUTAR
       INNER JOIN FSD001 C ON C.PEPAIS = B.Z0E478THP AND C.PETDOC = B.Z0E478THT AND C.PENDOC = B.Z0E478THD
       LEFT JOIN FSD002 D ON D.PFPAIS = B.Z0E478THP AND D.PFTDOC = B.Z0E478THT AND D.PFNDOC = B.Z0E478THD
       LEFT JOIN SNGC13 E ON E.SNGC13PAIS = B.Z0E478THP AND E.SNGC13TDOC = B.Z0E478THT AND E.SNGC13NDOC = B.Z0E478THD
                          AND E.DOCOD = 1 AND E.SNGC13CORR = 1
       LEFT JOIN FST071 F ON F.FST071PAI = 604 AND F.FST071DPT = E.SNGC13DPTO AND F.FST071LOC = E.SNGC13PROV
                         AND F.FST071COL = E.SNGC13DIST
       WHERE A.JAQZ205FEAFI <= p_dFecFin AND NOT F.FST071DSC IS NULL;
     exception
       when others then
         p_nRegMas := 0;
         p_nRegFem := 0;
         p_nRegJur := 0;
     end;
     
     -- TOTAL USUARIOS QUE REALIZARON TRANSACCIONES ENTRE LAS FECHAS INGRESADAS
     begin
       SELECT COUNT(CASE WHEN A.PETIPO = 'F' AND UPPER(B.PFCANT) = 'M' THEN 1 END),
              COUNT(CASE WHEN A.PETIPO = 'F' AND UPPER(B.PFCANT) = 'F' THEN 1 END),
              COUNT(CASE WHEN A.PETIPO = 'J' THEN 1 END) INTO p_nTraMas, p_nTraFem, p_nTraJur
       FROM
       (SELECT /*+ choose*/
               DISTINCT D.PEPAIS, D.PETDOC, D.PENDOC, D.PETIPO
        FROM FSH015 A
        INNER JOIN FST198 E ON E.TP1COD = 1 AND E.TP1COD1 = 11158 AND E.TP1CORR1 = 3
                           AND E.TP1CORR2 = A.HCMOD AND E.TP1CORR3 = A.HTRAN
        INNER JOIN FSH016 B ON B.PGCOD = A.PGCOD AND B.HCMOD = A.HCMOD AND B.HSUCOR = A.HSUCOR 
                           AND B.HTRAN = A.HTRAN AND B.HNREL = A.HNREL AND B.HFCON = A.HFCON AND B.HCORD = E.TP1NRO1
        INNER JOIN FSR008 C ON C.CTNRO = B.HCTA AND C.CTTFIR = 'T'
        INNER JOIN FSD001 D ON D.PEPAIS = C.PEPAIS AND D.PETDOC = C.PETDOC AND D.PENDOC = C.PENDOC
        INNER JOIN SNGC13 F ON F.SNGC13PAIS = C.PEPAIS AND F.SNGC13TDOC = C.PETDOC AND F.SNGC13NDOC = C.PENDOC
                          AND F.DOCOD = 1 AND F.SNGC13CORR = 1
        LEFT JOIN FST071 G ON G.FST071PAI = 604 AND G.FST071DPT = F.SNGC13DPTO AND G.FST071LOC = F.SNGC13PROV
                         AND G.FST071COL = F.SNGC13DIST
        WHERE A.HCMOD IN (140, 489, 66) AND A.HCCORR = 0 AND A.HFCON BETWEEN p_dFecIni AND p_dFecFin AND NOT G.FST071DSC IS NULL) A
       LEFT JOIN FSD002 B ON B.PFPAIS = A.PEPAIS AND B.PFTDOC = A.PETDOC AND B.PFNDOC = A.PENDOC
       INNER JOIN SNGC13 C ON C.SNGC13PAIS = A.PEPAIS AND C.SNGC13TDOC = A.PETDOC AND C.SNGC13NDOC = A.PENDOC
                          AND C.DOCOD = 1 AND C.SNGC13CORR = 1
       LEFT JOIN FST071 D ON D.FST071PAI = 604 AND D.FST071DPT = C.SNGC13DPTO AND D.FST071LOC = C.SNGC13PROV
                         AND D.FST071COL = C.SNGC13DIST
       WHERE NOT D.FST071DSC IS NULL;
     exception
       when others then
         p_nTraMas := 0;
         p_nTraFem := 0;
         p_nTraJur := 0;
     end;
   exception
     when others then
       p_cError := sqlerrm;
end sp_reporte_operaciones_cm_hb;

procedure sp_reporte_agentes_rep30(p_cCodUsu in varchar2, p_cError out varchar2) is
    i         number;
    lc_Tipo   character(1) := 'A';
    lc_NumDoc varchar2(20);
    lc_Direcc varchar2(1000);
    ln_CodInt number;
    lc_CodInt varchar2(20);
    lc_Propie varchar2(200);
    ln_CodDep number(5);
    ln_CodDis number(9);
    lc_TipDoc varchar2(5);
    ln_Latitu number(17,14);
    ln_Longit number(17,14);
    lc_Agrega varchar2(40);
    lc_NomCom varchar2(100);
   begin
     -- Limpia espacios en blanco
     UPDATE AQPC113 SET AQPC113NOMCOM = REPLACE(AQPC113NOMCOM, '    ', ' '),
                        AQPC113DIRECC = REPLACE(AQPC113DIRECC, '    ', ' '),
                        AQPC113PROPIE = REPLACE(AQPC113PROPIE, '    ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113NOMCOM = REPLACE(AQPC113NOMCOM, '   ', ' '),
                        AQPC113DIRECC = REPLACE(AQPC113DIRECC, '   ', ' '),
                        AQPC113PROPIE = REPLACE(AQPC113PROPIE, '   ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113NOMCOM = REPLACE(AQPC113NOMCOM, '  ', ' '),
                        AQPC113DIRECC = REPLACE(AQPC113DIRECC, '  ', ' '),
                        AQPC113PROPIE = REPLACE(AQPC113PROPIE, '  ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     -- Se limpia direcciones - eliminación de caracteres
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' NRO ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' NO. ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' NR ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' NUM ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     -- jlunaf 11/07/2023 - Se añade filtro para caracter [N°]
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' N° ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '?')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '.')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '(')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ')')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ':')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '''')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '¿')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '#')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'Á', 'A')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'É', 'E')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'Í', 'I')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'Ó', 'O')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'Ú', 'U')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     -- Se limpia direcciones - reeemplazo de abreviaciones
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AH ', 'AAHH ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AH %' OR AQPC113DIRECC LIKE '% AH %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AA HH ', 'AAHH ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AA HH %' OR AQPC113DIRECC LIKE '% AA HH %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'A H ', 'AAHH ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'A H %' OR AQPC113DIRECC LIKE '% A H %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASENTAMIENTO HUMANO', 'AAHH')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASOCIACION DE VIVIENDA', 'ASOC VIV')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASOCIACION VIVIENDA', 'ASOC VIV')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASOC DE VIV ', 'ASOC VIV ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASOCIACION', 'ASOC')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASC ', 'ASOC ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ASC %' OR AQPC113DIRECC LIKE '% ASC %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AVENIDA', 'AV')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AVDA ', 'AV ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AVDA %' OR AQPC113DIRECC LIKE '% AVDA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AVN ', 'AV ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AVN %' OR AQPC113DIRECC LIKE '% AVN %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AVE ', 'AV ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AVE %' OR AQPC113DIRECC LIKE '% AVE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'BAR ', 'BARRIO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'BAR %' OR AQPC113DIRECC LIKE '% BAR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'BARR ', 'BARRIO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'BARR %' OR AQPC113DIRECC LIKE '% BARR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'BOULEVARD', 'BLV')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CL ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CL %' OR AQPC113DIRECC LIKE '% CL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CA ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CA %' OR AQPC113DIRECC LIKE '% CA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CAL ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CAL %' OR AQPC113DIRECC LIKE '% CAL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CALL ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CALL %' OR AQPC113DIRECC LIKE '% CALL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CLLE ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CLLE %' OR AQPC113DIRECC LIKE '% CLLE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CARR ', 'CARRETERA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CARR %' OR AQPC113DIRECC LIKE '% CARR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CRT ', 'CARRETERA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CRT %' OR AQPC113DIRECC LIKE '% CRT %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CRRTA ', 'CARRETERA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CRRTA %' OR AQPC113DIRECC LIKE '% CRRTA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CRTERA ', 'CARRETERA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CRTERA %' OR AQPC113DIRECC LIKE '% CRTERA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CUADRA', 'CDRA')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CC ', 'CENTRO COMERCIAL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CC %' OR AQPC113DIRECC LIKE '% CC %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CIRCUNV ', 'CIRCUNVALACION ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CIRCUNV %' OR AQPC113DIRECC LIKE '% CIRCUNV %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CIRCUNVA ', 'CIRCUNVALACION ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CIRCUNVA %' OR AQPC113DIRECC LIKE '% CIRCUNVA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CMTE ', 'COMANDANTE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CMTE %' OR AQPC113DIRECC LIKE '% CMTE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CMDTE ', 'COMANDANTE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CMDTE %' OR AQPC113DIRECC LIKE '% CMDTE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'COOPERATIVA', 'COOP')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CRNEL ', 'CORONEL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CRNEL %' OR AQPC113DIRECC LIKE '% CRNEL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'EDIF ', 'EDIFICIO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'EDIF %' OR AQPC113DIRECC LIKE '% EDIF %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ESQ ', 'ESQUINA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ESQ %' OR AQPC113DIRECC LIKE '% ESQ %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ET ', 'ETAPA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ET %' OR AQPC113DIRECC LIKE '% ET %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'GRAL ', 'GENERAL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'GRAL %' OR AQPC113DIRECC LIKE '% GRAL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'JRN ', 'JR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'JRN %' OR AQPC113DIRECC LIKE '% JRN %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'JIR ', 'JR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'JIR %' OR AQPC113DIRECC LIKE '% JIR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'JIRON', 'JR')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'KILOMETRO', 'KM')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'LOTE ', 'LT ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'LOTE %' OR AQPC113DIRECC LIKE '% LOTE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MERCADO', 'MCDO')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MDO ', 'MCDO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'MDO %' OR AQPC113DIRECC LIKE '% MDO %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MANZANA', 'MZ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MAZ ', 'MZ ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'MAZ %' OR AQPC113DIRECC LIKE '% MAZ %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MANZ ', 'MZ ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'MANZ %' OR AQPC113DIRECC LIKE '% MANZ %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'OVA ', 'OVALO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'OVA %' OR AQPC113DIRECC LIKE '% OVA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PANAM ', 'PANAMERICANA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PANAM %' OR AQPC113DIRECC LIKE '% PANAM %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PJE ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PJE %' OR AQPC113DIRECC LIKE '% PJE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PSJE ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PSJE %' OR AQPC113DIRECC LIKE '% PSJE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PSAJE ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PSAJE %' OR AQPC113DIRECC LIKE '% PSAJE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PAS ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PAS %' OR AQPC113DIRECC LIKE '% PAS %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PS ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PS %' OR AQPC113DIRECC LIKE '% PS %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PQ ', 'PARQUE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PQ %' OR AQPC113DIRECC LIKE '% PQ %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PQE ', 'PARQUE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PQE %' OR AQPC113DIRECC LIKE '% PQE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PLZA ', 'PLAZA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PLZA %' OR AQPC113DIRECC LIKE '% PLZA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PZA ', 'PLAZA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PZA %' OR AQPC113DIRECC LIKE '% PZA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PROLO ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PROLO %' OR AQPC113DIRECC LIKE '% PROLO %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PROLOG ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PROLOG %' OR AQPC113DIRECC LIKE '% PROLOG %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PR ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PR %' OR AQPC113DIRECC LIKE '% PR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PROLONGACION', 'PROLG')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PL ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PL %' OR AQPC113DIRECC LIKE '% PL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PRLGA ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PRLGA %' OR AQPC113DIRECC LIKE '% PRLGA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PROLON ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PROLON %' OR AQPC113DIRECC LIKE '% PROLON %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PTO ', 'PUESTO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PTO %' OR AQPC113DIRECC LIKE '% PTO %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'RES ', 'RESIDENCIAL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'RES %' OR AQPC113DIRECC LIKE '% RES %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'RESD ', 'RESIDENCIAL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'RESD %' OR AQPC113DIRECC LIKE '% RESD %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' SN ', ' S/N ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' S N ', ' S/N ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'STO ', 'SANTA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'STO %' OR AQPC113DIRECC LIKE '% STO %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'SECC ', 'SECCION ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'SECC %' OR AQPC113DIRECC LIKE '% SECC %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'SEC ', 'SECTOR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'SEC %' OR AQPC113DIRECC LIKE '% SEC %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'SECT ', 'SECTOR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'SECT %' OR AQPC113DIRECC LIKE '% SECT %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ST ', 'SECTOR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ST %' OR AQPC113DIRECC LIKE '% ST %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'SR ', 'SEÑOR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'SR %' OR AQPC113DIRECC LIKE '% SR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'TDA ', 'TIENDA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'TDA %' OR AQPC113DIRECC LIKE '% TDA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'UR ', 'URB ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'UR %' OR AQPC113DIRECC LIKE '% UR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'URBA ', 'URB ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'URBA %' OR AQPC113DIRECC LIKE '% URBA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ZNA ', 'ZONA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ZNA %' OR AQPC113DIRECC LIKE '% ZNA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ZON ', 'ZONA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ZON %' OR AQPC113DIRECC LIKE '% ZON %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ZA ', 'ZONA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ZA %' OR AQPC113DIRECC LIKE '% ZA %');
     -- Actualización de código de departamento
     UPDATE AQPC113 A SET A.AQPC113DEPCOD = (SELECT B.DEPCOD FROM FST068 B WHERE PAIS = 604 AND TRIM(B.DEPNOM) = A.AQPC113DPTO)
        WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 A SET A.AQPC113DEPCOD = 0 WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo AND A.AQPC113DEPCOD IS NULL;
     -- Actualización de código de provincia
     UPDATE AQPC113 A SET A.AQPC113LOCCOD = (SELECT B.LOCCOD FROM FST070 B WHERE B.PAIS = 604 AND B.DEPCOD = A.AQPC113DEPCOD
                                                                             AND TRIM(B.LOCNOM) = A.AQPC113PROV)
        WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 A SET A.AQPC113LOCCOD = 0 WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo AND A.AQPC113LOCCOD IS NULL;
     -- Actualización de código de distrito
     UPDATE AQPC113 A SET A.AQPC113CODDIS = (SELECT B.FST071COL FROM FST071 B WHERE B.FST071PAI = 604 AND B.FST071DPT = A.AQPC113DEPCOD
                                                                                AND B.FST071LOC = A.AQPC113LOCCOD AND TRIM(B.FST071DSC) = A.AQPC113DIST)
        WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 A SET A.AQPC113CODDIS = 0 WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo AND A.AQPC113CODDIS IS NULL;
     -- Generación de data para reporte agentes
     i := 0;
     lc_NumDoc := ' ';
     lc_Direcc := ' ';
     ln_CodInt := 0;
     lc_CodInt := '';
     delete from aqpc114 where aqpc114CodUsu = upper(p_cCodUsu) and aqpc114Tipo = lc_Tipo;
     commit;
     FOR r IN (SELECT A.AQPC113DEPCOD, A.AQPC113LOCCOD, A.AQPC113CODDIS, A.AQPC113NOMCOM, A.AQPC113DIRECC, A.AQPC113LATI,
                      A.AQPC113LONG, A.AQPC113PROPIE, A.AQPC113TIPDOC, A.AQPC113NUMDOC, A.AQPC113AGREGA, SUM(A.AQPC113NUMCAJ) AS NTOTAL
               FROM AQPC113 A WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo
               GROUP BY A.AQPC113DEPCOD, A.AQPC113LOCCOD, A.AQPC113CODDIS, A.AQPC113NOMCOM, A.AQPC113DIRECC,
                        A.AQPC113LATI, A.AQPC113LONG, A.AQPC113PROPIE, A.AQPC113TIPDOC, A.AQPC113NUMDOC, A.AQPC113AGREGA
               ORDER BY A.AQPC113DEPCOD, A.AQPC113LOCCOD, A.AQPC113CODDIS, A.AQPC113PROPIE, A.AQPC113DIRECC, A.AQPC113AGREGA) LOOP
         i := i + 1;
         -- AGENTES CORRESPONSALES
         IF lc_NumDoc <> r.AQPC113NUMDOC OR lc_Direcc <> r.AQPC113DIRECC THEN
            ln_CodInt := ln_CodInt + 1;
            lc_CodInt := TRIM(TO_CHAR(ln_CodInt));
         END IF;
         insert into AQPC114
            (AQPC114CODUSU, AQPC114TIPO, AQPC114CORR, AQPC114CODINT, AQPC114CODDEP, AQPC114CODPRV, AQPC114CODDIS, AQPC114NOMCOM,
             AQPC114DIRECC, AQPC114LATI, AQPC114LONG, AQPC114PROPIE, AQPC114TIPDOC, AQPC114NUMDOC, AQPC114AGREGA, AQPC114TOTAL) values
            (p_cCodUsu, lc_Tipo, i, lc_CodInt, r.AQPC113DEPCOD, r.AQPC113LOCCOD, r.AQPC113CODDIS, r.AQPC113NOMCOM,
             r.AQPC113DIRECC, r.AQPC113LATI, r.AQPC113LONG, r.AQPC113PROPIE, r.AQPC113TIPDOC, r.AQPC113NUMDOC, r.AQPC113AGREGA, r.NTOTAL);
         lc_NumDoc := r.AQPC113NUMDOC;
         lc_Direcc := r.AQPC113DIRECC;
     END LOOP;
     commit;
     lc_NumDoc := ' ';
     lc_Propie := ' ';
     i := 0;
     -- Validacion error de mismo número de documento pero diferente nombre
     FOR r IN (SELECT DISTINCT A.AQPC114NUMDOC, A.AQPC114PROPIE
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114NUMDOC, A.AQPC114PROPIE) LOOP
         IF lc_NumDoc <> r.AQPC114NUMDOC THEN
            lc_NumDoc := r.AQPC114NUMDOC;
            lc_Propie := r.AQPC114PROPIE;
            i := 0;
         ELSIF lc_Propie <> r.AQPC114PROPIE THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = '001' WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                                                         AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = '001' WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                                                      AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = r.AQPC114PROPIE;
            i := 1;
         END IF;
     END LOOP;
     commit;
     lc_NumDoc := ' ';
     lc_Propie := ' ';
     i := 0;
     -- Validacion error de mismo nombre pero diferente número de documento
     FOR r IN (SELECT DISTINCT A.AQPC114PROPIE, A.AQPC114NUMDOC
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114PROPIE, A.AQPC114NUMDOC) LOOP
         IF lc_Propie <> r.AQPC114PROPIE THEN
            lc_Propie := r.AQPC114PROPIE;
            lc_NumDoc := r.AQPC114NUMDOC;
            i := 0;
         ELSIF lc_NumDoc <> r.AQPC114NUMDOC THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '002' ELSE AQPC114ERROR||',002' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '002' ELSE AQPC114ERROR||',002' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114NUMDOC = r.AQPC114NUMDOC AND AQPC114PROPIE = lc_Propie;
            i := 1;
         END IF;
     END LOOP;
     commit;
     lc_NumDoc := ' ';
     lc_Propie := ' ';
     lc_Direcc := ' ';
     ln_CodDis := 0;
     i := 0;
     -- Validacion error de mismo nombre, mismo número de documento, misma direccion pero diferente distrito
     FOR r IN (SELECT DISTINCT A.AQPC114NUMDOC, A.AQPC114PROPIE, A.AQPC114DIRECC, A.AQPC114CODDIS FROM AQPC114 A
                  WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114NUMDOC, A.AQPC114PROPIE, A.AQPC114DIRECC, A.AQPC114CODDIS) LOOP
         IF lc_NumDoc <> r.AQPC114NUMDOC OR lc_Propie <> r.AQPC114PROPIE OR lc_Direcc <> r.AQPC114DIRECC THEN
            lc_NumDoc := r.AQPC114NUMDOC;
            lc_Propie := r.AQPC114PROPIE;
            lc_Direcc := r.AQPC114DIRECC;
            ln_CodDis := r.AQPC114CODDIS;
            i := 0;
         ELSIF ln_CodDis <> r.AQPC114CODDIS THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '003' ELSE AQPC114ERROR||',003' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie AND AQPC114DIRECC = lc_Direcc
                    AND AQPC114CODDIS = ln_CodDis;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '003' ELSE AQPC114ERROR||',003' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie AND AQPC114DIRECC = lc_Direcc
                 AND AQPC114CODDIS = r.AQPC114CODDIS;
            i := 1;
         END IF;
     END LOOP;
     commit;
     lc_NumDoc := ' ';
     lc_TipDoc := ' ';
     i := 0;
     -- Validacion error de mismo número de documento pero diferente tipo de documento
     FOR r IN (SELECT DISTINCT A.AQPC114NUMDOC, A.AQPC114TIPDOC
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114NUMDOC, A.AQPC114TIPDOC) LOOP
         IF lc_NumDoc <> r.AQPC114NUMDOC THEN
            lc_NumDoc := r.AQPC114NUMDOC;
            lc_TipDoc := r.AQPC114TIPDOC;
            i := 0;
         ELSIF lc_TipDoc <> r.AQPC114TIPDOC THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '004' ELSE AQPC114ERROR||',004' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114NUMDOC = lc_NumDoc AND AQPC114TIPDOC = lc_TipDoc;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '004' ELSE AQPC114ERROR||',004' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114NUMDOC = lc_NumDoc AND AQPC114TIPDOC = r.AQPC114TIPDOC;
            i := 1;
         END IF;
     END LOOP;
     commit;
     lc_NumDoc := ' ';
     lc_Propie := ' ';
     ln_CodDis := 0;
     lc_Direcc := ' ';
     i := 0;
     -- Validacion error de mismo nombre, mismo número de documento, mismo distrito pero diferente direccion
     FOR r IN (SELECT DISTINCT A.AQPC114NUMDOC, A.AQPC114PROPIE, A.AQPC114CODDIS, A.AQPC114DIRECC FROM AQPC114 A
                  WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114NUMDOC, A.AQPC114PROPIE, A.AQPC114CODDIS, A.AQPC114DIRECC) LOOP
         IF lc_NumDoc <> r.AQPC114NUMDOC OR lc_Propie <> r.AQPC114PROPIE OR ln_CodDis <> r.AQPC114CODDIS THEN
            lc_NumDoc := r.AQPC114NUMDOC;
            lc_Propie := r.AQPC114PROPIE;
            ln_CodDis := r.AQPC114CODDIS;
            lc_Direcc := r.AQPC114DIRECC;
            i := 0;
         ELSIF lc_Direcc <> r.AQPC114DIRECC THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '005' ELSE AQPC114ERROR||',005' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie AND AQPC114CODDIS = ln_CodDis
                    AND AQPC114DIRECC = lc_Direcc;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '005' ELSE AQPC114ERROR||',005' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie AND AQPC114CODDIS = ln_CodDis
                 AND AQPC114DIRECC = r.AQPC114DIRECC;
            i := 1;
         END IF;
     END LOOP;
     commit;
     lc_NumDoc := ' ';
     lc_Propie := ' ';
     ln_CodDis := 0;
     lc_Direcc := ' ';
     ln_Latitu := 0;
     ln_Longit := 0;
     i := 0;
     -- Validacion error de mismo nombre, mismo número de documento, mismo distrito, misma direccion pero diferentes coordenadas
     FOR r IN (SELECT DISTINCT A.AQPC114NUMDOC, A.AQPC114PROPIE, A.AQPC114CODDIS, A.AQPC114DIRECC,
                               A.AQPC114LATI, A.AQPC114LONG FROM AQPC114 A
                  WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114NUMDOC, A.AQPC114PROPIE, A.AQPC114CODDIS, A.AQPC114DIRECC, A.AQPC114LATI,
                        A.AQPC114LONG) LOOP
         IF lc_NumDoc <> r.AQPC114NUMDOC OR lc_Propie <> r.AQPC114PROPIE OR ln_CodDis <> r.AQPC114CODDIS
            OR lc_Direcc <> r.AQPC114DIRECC THEN
            lc_NumDoc := r.AQPC114NUMDOC;
            lc_Propie := r.AQPC114PROPIE;
            ln_CodDis := r.AQPC114CODDIS;
            lc_Direcc := r.AQPC114DIRECC;
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            i := 0;
         ELSIF ln_Latitu <> r.AQPC114LATI OR ln_Longit <> r.AQPC114LONG THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '006' ELSE AQPC114ERROR||',006' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie AND AQPC114CODDIS = ln_CodDis
                    AND AQPC114DIRECC = lc_Direcc AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '006' ELSE AQPC114ERROR||',006' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie AND AQPC114CODDIS = ln_CodDis
                 AND AQPC114DIRECC = lc_Direcc AND AQPC114LATI = r.AQPC114LATI AND AQPC114LONG = r.AQPC114LONG;
            i := 1;
         END IF;
     END LOOP;
     commit;
     lc_NumDoc := ' ';
     lc_Propie := ' ';
     ln_CodDis := 0;
     lc_Direcc := ' ';
     lc_Agrega := ' ';
     lc_NomCom := ' ';
     i := 0;
     -- Validacion error de mismo nombre, mismo número de documento, mismo distrito, misma direccion, mismo agregador pero diferente nombre comercial
     FOR r IN (SELECT DISTINCT A.AQPC114NUMDOC, A.AQPC114PROPIE, A.AQPC114CODDIS, A.AQPC114DIRECC,
                               A.AQPC114AGREGA, A.AQPC114NOMCOM FROM AQPC114 A
                  WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114NUMDOC, A.AQPC114PROPIE, A.AQPC114CODDIS, A.AQPC114DIRECC, A.AQPC114AGREGA,
                        A.AQPC114NOMCOM) LOOP
         IF lc_NumDoc <> r.AQPC114NUMDOC OR lc_Propie <> r.AQPC114PROPIE OR ln_CodDis <> r.AQPC114CODDIS
            OR lc_Direcc <> r.AQPC114DIRECC OR lc_Agrega <> r.AQPC114AGREGA THEN
            lc_NumDoc := r.AQPC114NUMDOC;
            lc_Propie := r.AQPC114PROPIE;
            ln_CodDis := r.AQPC114CODDIS;
            lc_Direcc := r.AQPC114DIRECC;
            lc_Agrega := r.AQPC114AGREGA;
            lc_NomCom := r.AQPC114NOMCOM;
            i := 0;
         ELSIF lc_NomCom <> r.AQPC114NOMCOM THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '007' ELSE AQPC114ERROR||',007' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie AND AQPC114CODDIS = ln_CodDis
                    AND AQPC114DIRECC = lc_Direcc AND AQPC114AGREGA = lc_Agrega AND AQPC114NOMCOM = lc_NomCom;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '007' ELSE AQPC114ERROR||',007' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114NUMDOC = lc_NumDoc AND AQPC114PROPIE = lc_Propie AND AQPC114CODDIS = ln_CodDis
                 AND AQPC114DIRECC = lc_Direcc AND AQPC114AGREGA = lc_Agrega AND AQPC114NOMCOM = r.AQPC114NOMCOM;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     lc_Direcc := ' ';
     i := 0;
     -- Validacion error de misma Latitud, misma logitud pero diferente dirección
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114DIRECC
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114DIRECC) LOOP
         IF ln_Latitu <> r.AQPC114LATI OR ln_Longit <> r.AQPC114LONG THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            lc_Direcc := r.AQPC114DIRECC;
            i := 0;
         ELSIF lc_Direcc <> r.AQPC114DIRECC THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '008' ELSE AQPC114ERROR||',008' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114DIRECC = lc_Direcc;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '008' ELSE AQPC114ERROR||',008' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                 AND AQPC114DIRECC = r.AQPC114DIRECC;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     ln_CodDis := 0;
     i := 0;
     -- Validacion error de misma Latitud, misma logitud pero diferente distrito
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDIS
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDIS) LOOP
         IF ln_Latitu <> r.AQPC114LATI OR ln_Longit <> r.AQPC114LONG THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            ln_CodDis := r.AQPC114CODDIS;
            i := 0;
         ELSIF ln_CodDis <> r.AQPC114CODDIS THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '009' ELSE AQPC114ERROR||',009' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114CODDIS = ln_CodDis;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '009' ELSE AQPC114ERROR||',009' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                 AND AQPC114CODDIS = r.AQPC114CODDIS;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     ln_CodDep := 0;
     i := 0;
     -- Validacion error de misma Latitud, misma logitud pero diferente departamento
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDEP
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDEP) LOOP
         IF ln_Latitu <> r.AQPC114LATI OR ln_Longit <> r.AQPC114LONG THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            ln_CodDep := r.AQPC114CODDEP;
            i := 0;
         ELSIF ln_CodDep <> r.AQPC114CODDEP THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '010' ELSE AQPC114ERROR||',010' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114CODDEP = ln_CodDep;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '010' ELSE AQPC114ERROR||',010' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                 AND AQPC114CODDEP = r.AQPC114CODDEP;
            i := 1;
         END IF;
     END LOOP;
     commit;
   exception
     when others then
       p_cError := sqlerrm;
end sp_reporte_agentes_rep30;

procedure sp_reporte_cajeros_rep30(p_cCodUsu in varchar2, p_cError out varchar2) is
    i         number;
    lc_Tipo   character(1) := 'C';
    ln_CodDep number(5);
    lc_Direcc varchar2(1000);
    lc_Agrega varchar2(40);
    ln_CodDis number(9);
    ln_Longit number(17,14);
    ln_Latitu number(17,14);
    ln_CodPrv number(5);
   begin
     -- Limpia espacios en blanco
     UPDATE AQPC113 SET AQPC113NOMCOM = REPLACE(AQPC113NOMCOM, '    ', ' '),
                        AQPC113DIRECC = REPLACE(AQPC113DIRECC, '    ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113NOMCOM = REPLACE(AQPC113NOMCOM, '   ', ' '),
                        AQPC113DIRECC = REPLACE(AQPC113DIRECC, '   ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113NOMCOM = REPLACE(AQPC113NOMCOM, '  ', ' '),
                        AQPC113DIRECC = REPLACE(AQPC113DIRECC, '  ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     -- Se limpia direcciones - eliminación de caracteres
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' NRO ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' NO. ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' NR ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' NUM ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     -- jlunaf 11/07/2023 - Se añade filtro para caracter [N°]
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' N° ', ' ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '?')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '.')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '(')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ')')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ':')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '''')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '¿')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, '#')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'Á', 'A')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'É', 'E')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'Í', 'I')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'Ó', 'O')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'Ú', 'U')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     -- Se limpia direcciones - reeemplazo de abreviaciones
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AH ', 'AAHH ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AH %' OR AQPC113DIRECC LIKE '% AH %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AA HH ', 'AAHH ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AA HH %' OR AQPC113DIRECC LIKE '% AA HH %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'A H ', 'AAHH ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'A H %' OR AQPC113DIRECC LIKE '% A H %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASENTAMIENTO HUMANO', 'AAHH')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASOCIACION DE VIVIENDA', 'ASOC VIV')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASOCIACION VIVIENDA', 'ASOC VIV')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASOC DE VIV ', 'ASOC VIV ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASOCIACION', 'ASOC')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ASC ', 'ASOC ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ASC %' OR AQPC113DIRECC LIKE '% ASC %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AVENIDA', 'AV')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AVDA ', 'AV ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AVDA %' OR AQPC113DIRECC LIKE '% AVDA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AVN ', 'AV ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AVN %' OR AQPC113DIRECC LIKE '% AVN %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'AVE ', 'AV ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'AVE %' OR AQPC113DIRECC LIKE '% AVE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'BAR ', 'BARRIO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'BAR %' OR AQPC113DIRECC LIKE '% BAR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'BARR ', 'BARRIO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'BARR %' OR AQPC113DIRECC LIKE '% BARR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'BOULEVARD', 'BLV')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CL ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CL %' OR AQPC113DIRECC LIKE '% CL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CA ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CA %' OR AQPC113DIRECC LIKE '% CA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CAL ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CAL %' OR AQPC113DIRECC LIKE '% CAL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CALL ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CALL %' OR AQPC113DIRECC LIKE '% CALL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CLLE ', 'CALLE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CLLE %' OR AQPC113DIRECC LIKE '% CLLE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CARR ', 'CARRETERA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CARR %' OR AQPC113DIRECC LIKE '% CARR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CRT ', 'CARRETERA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CRT %' OR AQPC113DIRECC LIKE '% CRT %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CRRTA ', 'CARRETERA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CRRTA %' OR AQPC113DIRECC LIKE '% CRRTA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CRTERA ', 'CARRETERA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CRTERA %' OR AQPC113DIRECC LIKE '% CRTERA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CUADRA', 'CDRA')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CC ', 'CENTRO COMERCIAL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CC %' OR AQPC113DIRECC LIKE '% CC %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CIRCUNV ', 'CIRCUNVALACION ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CIRCUNV %' OR AQPC113DIRECC LIKE '% CIRCUNV %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CIRCUNVA ', 'CIRCUNVALACION ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CIRCUNVA %' OR AQPC113DIRECC LIKE '% CIRCUNVA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CMTE ', 'COMANDANTE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CMTE %' OR AQPC113DIRECC LIKE '% CMTE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CMDTE ', 'COMANDANTE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CMDTE %' OR AQPC113DIRECC LIKE '% CMDTE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'COOPERATIVA', 'COOP')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'CRNEL ', 'CORONEL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'CRNEL %' OR AQPC113DIRECC LIKE '% CRNEL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'EDIF ', 'EDIFICIO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'EDIF %' OR AQPC113DIRECC LIKE '% EDIF %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ESQ ', 'ESQUINA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ESQ %' OR AQPC113DIRECC LIKE '% ESQ %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ET ', 'ETAPA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ET %' OR AQPC113DIRECC LIKE '% ET %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'GRAL ', 'GENERAL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'GRAL %' OR AQPC113DIRECC LIKE '% GRAL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'JRN ', 'JR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'JRN %' OR AQPC113DIRECC LIKE '% JRN %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'JIR ', 'JR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'JIR %' OR AQPC113DIRECC LIKE '% JIR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'JIRON', 'JR')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'KILOMETRO', 'KM')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'LOTE ', 'LT ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'LOTE %' OR AQPC113DIRECC LIKE '% LOTE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MERCADO', 'MCDO')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MDO ', 'MCDO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'MDO %' OR AQPC113DIRECC LIKE '% MDO %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MANZANA', 'MZ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MAZ ', 'MZ ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'MAZ %' OR AQPC113DIRECC LIKE '% MAZ %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'MANZ ', 'MZ ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'MANZ %' OR AQPC113DIRECC LIKE '% MANZ %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'OVA ', 'OVALO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'OVA %' OR AQPC113DIRECC LIKE '% OVA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PANAM ', 'PANAMERICANA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PANAM %' OR AQPC113DIRECC LIKE '% PANAM %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PJE ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PJE %' OR AQPC113DIRECC LIKE '% PJE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PSJE ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PSJE %' OR AQPC113DIRECC LIKE '% PSJE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PSAJE ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PSAJE %' OR AQPC113DIRECC LIKE '% PSAJE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PAS ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PAS %' OR AQPC113DIRECC LIKE '% PAS %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PS ', 'PASAJE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PS %' OR AQPC113DIRECC LIKE '% PS %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PQ ', 'PARQUE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PQ %' OR AQPC113DIRECC LIKE '% PQ %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PQE ', 'PARQUE ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PQE %' OR AQPC113DIRECC LIKE '% PQE %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PLZA ', 'PLAZA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PLZA %' OR AQPC113DIRECC LIKE '% PLZA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PZA ', 'PLAZA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PZA %' OR AQPC113DIRECC LIKE '% PZA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PROLO ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PROLO %' OR AQPC113DIRECC LIKE '% PROLO %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PROLOG ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PROLOG %' OR AQPC113DIRECC LIKE '% PROLOG %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PR ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PR %' OR AQPC113DIRECC LIKE '% PR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PROLONGACION', 'PROLG')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PL ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PL %' OR AQPC113DIRECC LIKE '% PL %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PRLGA ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PRLGA %' OR AQPC113DIRECC LIKE '% PRLGA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PROLON ', 'PROLG ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PROLON %' OR AQPC113DIRECC LIKE '% PROLON %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'PTO ', 'PUESTO ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'PTO %' OR AQPC113DIRECC LIKE '% PTO %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'RES ', 'RESIDENCIAL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'RES %' OR AQPC113DIRECC LIKE '% RES %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'RESD ', 'RESIDENCIAL ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'RESD %' OR AQPC113DIRECC LIKE '% RESD %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' SN ', ' S/N ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, ' S N ', ' S/N ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'STO ', 'SANTA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'STO %' OR AQPC113DIRECC LIKE '% STO %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'SECC ', 'SECCION ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'SECC %' OR AQPC113DIRECC LIKE '% SECC %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'SEC ', 'SECTOR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'SEC %' OR AQPC113DIRECC LIKE '% SEC %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'SECT ', 'SECTOR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'SECT %' OR AQPC113DIRECC LIKE '% SECT %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ST ', 'SECTOR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ST %' OR AQPC113DIRECC LIKE '% ST %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'SR ', 'SEÑOR ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'SR %' OR AQPC113DIRECC LIKE '% SR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'TDA ', 'TIENDA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'TDA %' OR AQPC113DIRECC LIKE '% TDA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'UR ', 'URB ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'UR %' OR AQPC113DIRECC LIKE '% UR %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'URBA ', 'URB ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'URBA %' OR AQPC113DIRECC LIKE '% URBA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ZNA ', 'ZONA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ZNA %' OR AQPC113DIRECC LIKE '% ZNA %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ZON ', 'ZONA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ZON %' OR AQPC113DIRECC LIKE '% ZON %');
     UPDATE AQPC113 SET AQPC113DIRECC = REPLACE(AQPC113DIRECC, 'ZA ', 'ZONA ')
     WHERE AQPC113CODUSU = p_cCodUsu AND AQPC113TIPO = lc_Tipo AND
          (AQPC113DIRECC LIKE 'ZA %' OR AQPC113DIRECC LIKE '% ZA %');
     -- Actualización de código de departamento
     UPDATE AQPC113 A SET A.AQPC113DEPCOD = (SELECT B.DEPCOD FROM FST068 B WHERE PAIS = 604 AND TRIM(B.DEPNOM) = A.AQPC113DPTO)
        WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 A SET A.AQPC113DEPCOD = 0 WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo AND A.AQPC113DEPCOD IS NULL;
     -- Actualización de código de provincia
     UPDATE AQPC113 A SET A.AQPC113LOCCOD = (SELECT B.LOCCOD FROM FST070 B WHERE B.PAIS = 604 AND B.DEPCOD = A.AQPC113DEPCOD
                                                                             AND TRIM(B.LOCNOM) = A.AQPC113PROV)
        WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 A SET A.AQPC113LOCCOD = 0 WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo AND A.AQPC113LOCCOD IS NULL;
     -- Actualización de código de distrito
     UPDATE AQPC113 A SET A.AQPC113CODDIS = (SELECT B.FST071COL FROM FST071 B WHERE B.FST071PAI = 604 AND B.FST071DPT = A.AQPC113DEPCOD
                                                                                AND B.FST071LOC = A.AQPC113LOCCOD AND TRIM(B.FST071DSC) = A.AQPC113DIST)
        WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo;
     UPDATE AQPC113 A SET A.AQPC113CODDIS = 0 WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo AND A.AQPC113CODDIS IS NULL;
     -- Generación de data para reporte ATMs
     i := 0;
     delete from aqpc114 where aqpc114CodUsu = upper(p_cCodUsu) and aqpc114Tipo = lc_Tipo;
     commit;
     FOR r IN (SELECT A.AQPC113DEPCOD, A.AQPC113LOCCOD, A.AQPC113CODDIS, A.AQPC113DIRECC, A.AQPC113LATI,
                      A.AQPC113LONG, A.AQPC113AGREGA, SUM(A.AQPC113NUMCAJ) AS NTOTAL,
                      SUM(CASE A.AQPC113TIPCAJ WHEN 'MULTIFUNCION' THEN A.AQPC113NUMCAJ ELSE 0 END) AS NTOTDEP
               FROM AQPC113 A WHERE A.AQPC113CODUSU = p_cCodUsu AND A.AQPC113TIPO = lc_Tipo
               GROUP BY A.AQPC113DEPCOD, A.AQPC113LOCCOD, A.AQPC113CODDIS, A.AQPC113DIRECC, A.AQPC113LATI,
                        A.AQPC113LONG, A.AQPC113AGREGA
               ORDER BY A.AQPC113DEPCOD, A.AQPC113LOCCOD, A.AQPC113CODDIS, A.AQPC113DIRECC, A.AQPC113AGREGA) LOOP
         i := i + 1;
         -- ATMS
         insert into AQPC114
            (AQPC114CODUSU, AQPC114TIPO, AQPC114CORR, AQPC114CODDEP, AQPC114CODPRV, AQPC114CODDIS, AQPC114DIRECC,
             AQPC114LATI, AQPC114LONG, AQPC114AGREGA, AQPC114TOTAL, AQPC114TOTDEP) values
            (p_cCodUsu, lc_Tipo, i, r.AQPC113DEPCOD, r.AQPC113LOCCOD, r.AQPC113CODDIS, r.AQPC113DIRECC,
             r.AQPC113LATI, r.AQPC113LONG, r.AQPC113AGREGA, r.NTOTAL, r.NTOTDEP);
     END LOOP;
     commit;
     ln_CodDep := 0;
     lc_Direcc := ' ';
     ln_CodDis := 0;
     i := 0;
     -- Validacion error de mismo departamento, misma dirección pero diferente distrito
     FOR r IN (SELECT DISTINCT A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114CODDIS
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114CODDIS) LOOP
         IF ln_CodDep <> r.AQPC114CODDEP OR lc_Direcc <> r.AQPC114DIRECC THEN
            ln_CodDep := r.AQPC114CODDEP;
            lc_Direcc := r.AQPC114DIRECC;
            ln_CodDis := r.AQPC114CODDIS;
            i := 0;
         ELSIF ln_CodDis <> r.AQPC114CODDIS THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = '001' WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                                                         AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                                                         AND AQPC114CODDIS = ln_CodDis;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = '001' WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                                                      AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                                                      AND AQPC114CODDIS = r.AQPC114CODDIS;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_CodDep := 0;
     lc_Direcc := ' ';
     lc_Agrega := ' ';
     ln_CodDis := 0;
     i := 0;
     -- Validacion error de mismo departamento, misma dirección pero diferente red y diferente distrito
     FOR r IN (SELECT DISTINCT A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114AGREGA, A.AQPC114CODDIS
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114AGREGA, A.AQPC114CODDIS) LOOP
         IF ln_CodDep <> r.AQPC114CODDEP OR lc_Direcc <> r.AQPC114DIRECC THEN
            ln_CodDep := r.AQPC114CODDEP;
            lc_Direcc := r.AQPC114DIRECC;
            lc_Agrega := r.AQPC114AGREGA;
            ln_CodDis := r.AQPC114CODDIS;
            i := 0;
         ELSIF lc_Agrega <> r.AQPC114AGREGA AND ln_CodDis <> r.AQPC114CODDIS THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '002' ELSE AQPC114ERROR||',002' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                    AND AQPC114AGREGA = lc_Agrega AND AQPC114CODDIS = ln_CodDis;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '002' ELSE AQPC114ERROR||',002' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                 AND AQPC114AGREGA = r.AQPC114AGREGA AND AQPC114CODDIS = r.AQPC114CODDIS;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_CodDep := 0;
     lc_Direcc := ' ';
     lc_Agrega := ' ';
     ln_CodDis := 0;
     i := 0;
     -- Validacion error de mismo departamento, misma dirección, misma red pero diferente distrito
     FOR r IN (SELECT DISTINCT A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114AGREGA, A.AQPC114CODDIS
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114AGREGA, A.AQPC114CODDIS) LOOP
         IF ln_CodDep <> r.AQPC114CODDEP OR lc_Direcc <> r.AQPC114DIRECC OR lc_Agrega <> r.AQPC114AGREGA THEN
            ln_CodDep := r.AQPC114CODDEP;
            lc_Direcc := r.AQPC114DIRECC;
            lc_Agrega := r.AQPC114AGREGA;
            ln_CodDis := r.AQPC114CODDIS;
            i := 0;
         ELSIF ln_CodDis <> r.AQPC114CODDIS THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '003' ELSE AQPC114ERROR||',003' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                    AND AQPC114AGREGA = lc_Agrega AND AQPC114CODDIS = ln_CodDis;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '003' ELSE AQPC114ERROR||',003' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                 AND AQPC114AGREGA = lc_Agrega AND AQPC114CODDIS = r.AQPC114CODDIS;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_CodDep := 0;
     lc_Direcc := ' ';
     ln_CodDis := 0;
     ln_Longit := 0;
     i := 0;
     -- Validacion error de mismo departamento, misma dirección, mismo distrito pero diferente longitud 
     FOR r IN (SELECT DISTINCT A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114CODDIS, A.AQPC114LONG
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114CODDIS, A.AQPC114LONG) LOOP
         IF ln_CodDep <> r.AQPC114CODDEP OR lc_Direcc <> r.AQPC114DIRECC OR ln_CodDis <> r.AQPC114CODDIS THEN
            ln_CodDep := r.AQPC114CODDEP;
            lc_Direcc := r.AQPC114DIRECC;
            ln_CodDis := r.AQPC114CODDIS;
            ln_Longit := r.AQPC114LONG;
            i := 0;
         ELSIF ln_Longit <> r.AQPC114LONG THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '004' ELSE AQPC114ERROR||',004' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                    AND AQPC114CODDIS = ln_CodDis AND AQPC114LONG = ln_Longit;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '004' ELSE AQPC114ERROR||',004' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                 AND AQPC114CODDIS = ln_CodDis AND AQPC114LONG = r.AQPC114LONG;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_CodDep := 0;
     lc_Direcc := ' ';
     ln_CodDis := 0;
     ln_Latitu := 0;
     i := 0;
     -- Validacion error de mismo departamento, misma dirección, mismo distrito pero diferente latitud
     FOR r IN (SELECT DISTINCT A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114CODDIS, A.AQPC114LATI
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114CODDEP, A.AQPC114DIRECC, A.AQPC114CODDIS, A.AQPC114LATI) LOOP
         IF ln_CodDep <> r.AQPC114CODDEP OR lc_Direcc <> r.AQPC114DIRECC OR ln_CodDis <> r.AQPC114CODDIS THEN
            ln_CodDep := r.AQPC114CODDEP;
            lc_Direcc := r.AQPC114DIRECC;
            ln_CodDis := r.AQPC114CODDIS;
            ln_Latitu := r.AQPC114LATI;
            i := 0;
         ELSIF ln_Latitu <> r.AQPC114LATI THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '005' ELSE AQPC114ERROR||',005' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                    AND AQPC114CODDIS = ln_CodDis AND AQPC114LATI = ln_Latitu;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '005' ELSE AQPC114ERROR||',005' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114CODDEP = ln_CodDep AND AQPC114DIRECC = lc_Direcc
                 AND AQPC114CODDIS = ln_CodDis AND AQPC114LATI = r.AQPC114LATI;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     lc_Direcc := ' ';
     i := 0;
     -- Validacion error de misma Latitud, misma logitud pero diferente dirección
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114DIRECC
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114DIRECC) LOOP
         IF ln_Latitu <> r.AQPC114LATI OR ln_Longit <> r.AQPC114LONG THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            lc_Direcc := r.AQPC114DIRECC;
            i := 0;
         ELSIF lc_Direcc <> r.AQPC114DIRECC THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '006' ELSE AQPC114ERROR||',006' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114DIRECC = lc_Direcc;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '006' ELSE AQPC114ERROR||',006' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                 AND AQPC114DIRECC = r.AQPC114DIRECC;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     ln_CodDis := 0;
     i := 0;
     -- Validacion error de misma Latitud, misma logitud pero diferente distrito
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDIS
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDIS) LOOP
         IF ln_Latitu <> r.AQPC114LATI OR ln_Longit <> r.AQPC114LONG THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            ln_CodDis := r.AQPC114CODDIS;
            i := 0;
         ELSIF ln_CodDis <> r.AQPC114CODDIS THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '007' ELSE AQPC114ERROR||',007' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114CODDIS = ln_CodDis;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '007' ELSE AQPC114ERROR||',007' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                 AND AQPC114CODDIS = r.AQPC114CODDIS;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     ln_CodDep := 0;
     i := 0;
     -- Validacion error de misma Latitud, misma logitud pero diferente departamento
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDEP
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDEP) LOOP
         IF ln_Latitu <> r.AQPC114LATI OR ln_Longit <> r.AQPC114LONG THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            ln_CodDep := r.AQPC114CODDEP;
            i := 0;
         ELSIF ln_CodDep <> r.AQPC114CODDEP THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '008' ELSE AQPC114ERROR||',008' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114CODDEP = ln_CodDep;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '008' ELSE AQPC114ERROR||',008' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                 AND AQPC114CODDEP = r.AQPC114CODDEP;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     lc_Direcc := ' ';
     i := 0;
     -- Validacion error de misma latitud pero diferente longitud y diferente dirección
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114DIRECC
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114DIRECC) LOOP
         IF ln_Latitu <> r.AQPC114LATI THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            lc_Direcc := r.AQPC114DIRECC;
            i := 0;
         ELSIF ln_Longit <> r.AQPC114LONG AND lc_Direcc <> r.AQPC114DIRECC THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '009' ELSE AQPC114ERROR||',009' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114DIRECC = lc_Direcc;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '009' ELSE AQPC114ERROR||',009' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = r.AQPC114LONG
                 AND AQPC114DIRECC = r.AQPC114DIRECC;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Longit := 0;
     ln_Latitu := 0;
     lc_Direcc := ' ';
     i := 0;
     -- Validacion error de misma longitud pero diferente latitud y diferente dirección
     FOR r IN (SELECT DISTINCT A.AQPC114LONG, A.AQPC114LATI, A.AQPC114DIRECC
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LONG, A.AQPC114LATI, A.AQPC114DIRECC) LOOP
         IF ln_Longit <> r.AQPC114LONG THEN
            ln_Longit := r.AQPC114LONG;
            ln_Latitu := r.AQPC114LATI;
            lc_Direcc := r.AQPC114DIRECC;
            i := 0;
         ELSIF ln_Latitu <> r.AQPC114LATI AND lc_Direcc <> r.AQPC114DIRECC THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '010' ELSE AQPC114ERROR||',010' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LONG = ln_Longit AND AQPC114LATI = ln_Latitu
                    AND AQPC114DIRECC = lc_Direcc;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '010' ELSE AQPC114ERROR||',010' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LONG = ln_Longit AND AQPC114LATI = r.AQPC114LATI
                 AND AQPC114DIRECC = r.AQPC114DIRECC;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     ln_CodDep := 0;
     i := 0;
     -- Validacion error de misma latitud pero diferente longitud y diferente departamento
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDEP
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDEP) LOOP
         IF ln_Latitu <> r.AQPC114LATI THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            ln_CodDep := r.AQPC114CODDEP;
            i := 0;
         ELSIF ln_Longit <> r.AQPC114LONG AND ln_CodDep <> r.AQPC114CODDEP THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '011' ELSE AQPC114ERROR||',011' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114CODDEP = ln_CodDep;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '011' ELSE AQPC114ERROR||',011' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = r.AQPC114LONG
                 AND AQPC114CODDEP = r.AQPC114CODDEP;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Longit := 0;
     ln_Latitu := 0;
     ln_CodDep := 0;
     i := 0;
     -- Validacion error de misma longitud pero diferente latitud y diferente departamento
     FOR r IN (SELECT DISTINCT A.AQPC114LONG, A.AQPC114LATI, A.AQPC114CODDEP
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LONG, A.AQPC114LATI, A.AQPC114CODDEP) LOOP
         IF ln_Longit <> r.AQPC114LONG THEN
            ln_Longit := r.AQPC114LONG;
            ln_Latitu := r.AQPC114LATI;
            ln_CodDep := r.AQPC114CODDEP;
            i := 0;
         ELSIF ln_Latitu <> r.AQPC114LATI AND ln_CodDep <> r.AQPC114CODDEP THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '012' ELSE AQPC114ERROR||',012' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LONG = ln_Longit AND AQPC114LATI = ln_Latitu
                    AND AQPC114CODDEP = ln_CodDep;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '012' ELSE AQPC114ERROR||',012' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LONG = ln_Longit AND AQPC114LATI = r.AQPC114LATI
                 AND AQPC114CODDEP = r.AQPC114CODDEP;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     ln_CodPrv := 0;
     i := 0;
     -- Validacion error de misma latitud pero diferente longitud y diferente provincia
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODPRV
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODPRV) LOOP
         IF ln_Latitu <> r.AQPC114LATI THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            ln_CodPrv := r.AQPC114CODPRV;
            i := 0;
         ELSIF ln_Longit <> r.AQPC114LONG AND ln_CodPrv <> r.AQPC114CODPRV THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '013' ELSE AQPC114ERROR||',013' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114CODPRV = ln_CodPrv;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '013' ELSE AQPC114ERROR||',013' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = r.AQPC114LONG
                 AND AQPC114CODPRV = r.AQPC114CODPRV;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Longit := 0;
     ln_Latitu := 0;
     ln_CodPrv := 0;
     i := 0;
     -- Validacion error de misma longitud pero diferente latitud y diferente provincia
     FOR r IN (SELECT DISTINCT A.AQPC114LONG, A.AQPC114LATI, A.AQPC114CODPRV
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LONG, A.AQPC114LATI, A.AQPC114CODPRV) LOOP
         IF ln_Longit <> r.AQPC114LONG THEN
            ln_Longit := r.AQPC114LONG;
            ln_Latitu := r.AQPC114LATI;
            ln_CodPrv := r.AQPC114CODPRV;
            i := 0;
         ELSIF ln_Latitu <> r.AQPC114LATI AND ln_CodPrv <> r.AQPC114CODPRV THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '014' ELSE AQPC114ERROR||',014' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LONG = ln_Longit AND AQPC114LATI = ln_Latitu
                    AND AQPC114CODPRV = ln_CodPrv;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '014' ELSE AQPC114ERROR||',014' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LONG = ln_Longit AND AQPC114LATI = r.AQPC114LATI
                 AND AQPC114CODPRV = r.AQPC114CODPRV;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Latitu := 0;
     ln_Longit := 0;
     ln_CodDis := 0;
     i := 0;
     -- Validacion error de misma latitud pero diferente longitud y diferente distrito
     FOR r IN (SELECT DISTINCT A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDIS
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LATI, A.AQPC114LONG, A.AQPC114CODDIS) LOOP
         IF ln_Latitu <> r.AQPC114LATI THEN
            ln_Latitu := r.AQPC114LATI;
            ln_Longit := r.AQPC114LONG;
            ln_CodDis := r.AQPC114CODDIS;
            i := 0;
         ELSIF ln_Longit <> r.AQPC114LONG AND ln_CodDis <> r.AQPC114CODDIS THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '015' ELSE AQPC114ERROR||',015' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LATI = ln_Latitu AND AQPC114LONG = ln_Longit
                    AND AQPC114CODDIS = ln_CodDis;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '015' ELSE AQPC114ERROR||',015' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LATI = ln_Latitu AND AQPC114LONG = r.AQPC114LONG
                 AND AQPC114CODDIS = r.AQPC114CODDIS;
            i := 1;
         END IF;
     END LOOP;
     commit;
     ln_Longit := 0;
     ln_Latitu := 0;
     ln_CodDis := 0;
     i := 0;
     -- Validacion error de misma longitud pero diferente latitud y diferente distrito
     FOR r IN (SELECT DISTINCT A.AQPC114LONG, A.AQPC114LATI, A.AQPC114CODDIS
               FROM AQPC114 A WHERE A.AQPC114CODUSU = p_cCodUsu AND A.AQPC114TIPO = lc_Tipo
               ORDER BY A.AQPC114LONG, A.AQPC114LATI, A.AQPC114CODDIS) LOOP
         IF ln_Longit <> r.AQPC114LONG THEN
            ln_Longit := r.AQPC114LONG;
            ln_Latitu := r.AQPC114LATI;
            ln_CodDis := r.AQPC114CODDIS;
            i := 0;
         ELSIF ln_Latitu <> r.AQPC114LATI AND ln_CodDis <> r.AQPC114CODDIS THEN
            IF i = 0 THEN
               UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '016' ELSE AQPC114ERROR||',016' END
                  WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                    AND AQPC114LONG = ln_Longit AND AQPC114LATI = ln_Latitu
                    AND AQPC114CODDIS = ln_CodDis;
            END IF;
            UPDATE AQPC114 SET AQPC114ERROR = CASE WHEN AQPC114ERROR IS NULL THEN '016' ELSE AQPC114ERROR||',016' END
               WHERE AQPC114CODUSU = p_cCodUsu AND AQPC114TIPO = lc_Tipo
                 AND AQPC114LONG = ln_Longit AND AQPC114LATI = r.AQPC114LATI
                 AND AQPC114CODDIS = r.AQPC114CODDIS;
            i := 1;
         END IF;
     END LOOP;
     commit;
   exception
     when others then
       p_cError := sqlerrm;
end sp_reporte_cajeros_rep30;


procedure sp_reporte_conciliacion_PCSE(pd_fecha in date, pd_error out varchar2) is
  fecha date;
 begin    
        
   select pgfape into fecha from fst017 where pgcod = 1;
   
   Delete aqpd551 where aqpd551fec= pd_fecha;
   Commit;
  if pd_fecha = fecha then 

       INSERT INTO aqpd551 (aqpd551fec, aqpd551mod, aqpd551tran, aqpd551rel, aqpd551codBan, aqpd551oper, aqpd551mon,
                     aqpd551mod2, aqpd551tran2, aqpd551rel2, aqpd551oper2, aqpd551mon2,
                     aqpd551cntmod, aqpd551cntagen, aqpd551csubop, aqpd551ctipop, aqpd551csuc)
        select a.ITFCON Fecha,
               a.ITMOD Modulo, a.ITTRAN Transaccion, a.ITNREL Relacion, 
               b.CTNRO CodigoBanco,b.ITOPER Operacion, b.ITIMP1 Monto,     
               d.ITMOD Modulo, d.ITTRAN Transaccion, d.ITNREL Relacion,
               d.ITOPER Operacion, d.ITIMP1 Monto,
               e.MODULO Cuenta_Modulo, e.CTNRO Cuenta_Agente, e.ITSUBO Cuenta_Suboperacion,
               e.ITTOPE Cuenta_TipoOperacion, e.ITSUCD Cuenta_Sucursal
               from fsd015 a 
        inner join fsd016 b on a.PGCOD=b.PGCOD and a.ITSUC=b.ITSUC and a.ITMOD=b.ITMOD and a.ITTRAN=b.ITTRAN 
                            and a.ITNREL=b.ITNREL
        left outer join fsd016 d on b.PGCOD=d.PGCOD and b.ITSUC=d.ITSUC and d.ITMOD=10 and d.ITTRAN=501
                               and b.ITSBOR=d.ITSBOR and d.ITORD=7 and b.ITOPER=d.ITOPER                
        left outer join fsd016 e on e.PGCOD=d.PGCOD and e.ITSUC=d.ITSUC and e.ITMOD=d.ITMOD and e.ITTRAN=d.ITTRAN
                               and e.ITNREL=d.ITNREL and e.ITORD=12 
        where a.pgcod=1 and a.itsuc=904 and a.itmod=51 and a.ittran=100 and a.ituing='BOTAGENTES' and b.ITORD=15
        and itfcon=pd_fecha
        ORDER BY a.itnrel;
        commit;
        pd_error:='OK';
 
  else 
    
        INSERT INTO aqpd551 (aqpd551fec, aqpd551mod, aqpd551tran, aqpd551rel, aqpd551codBan, aqpd551oper, aqpd551mon,
                     aqpd551mod2, aqpd551tran2, aqpd551rel2, aqpd551oper2, aqpd551mon2,
                     aqpd551cntmod, aqpd551cntagen, aqpd551csubop, aqpd551ctipop, aqpd551csuc)

              select a.hfcon,
                     a.hcmod, a.htran, a.hnrel, 
                     b.hcta,b.hoper , b.hcimp1 ,     
                     d.hcmod , d.htran , d.hnrel,
                     d.hoper , d.hcimp1 ,
                     e.hmodul , e.hcta , e.hsubop ,
                     e.htoper , e.hsucur 
                     from fsh015 a 
              inner join fsh016 b on a.PGCOD=b.PGCOD and a.hsucor=b.hsucor and a.hcmod=b.hcmod and a.htran=b.htran 
                                  and a.hnrel=b.hnrel and a.hfcon=b.hfcon
              left outer join fsh016 d on b.PGCOD=d.PGCOD and b.hsucor=d.hsucor and d.hcmod=10 and d.htran=501
                                     and b.hcsubo=d.hcsubo and d.hcord=7 and b.hoper=d.hoper and b.hfcon=d.hfcon                
              left outer join fsh016 e on e.pgcod=d.PGCOD and e.hsucor=d.hsucor and e.hcmod=d.hcmod and e.htran=d.htran
                                     and e.hnrel=d.hnrel and e.hcord=12 and d.hfcon=e.hfcon
              where a.pgcod=1 and a.hsucor=904 and a.hcmod=51 and a.htran=100 and a.husing='BOTAGENTES' and b.hcord=15
              and a.hfcon=pd_fecha
              ORDER BY a.hnrel;
              commit;
              pd_error:='OK';
  
  END IF;

end sp_reporte_conciliacion_PCSE;
procedure sp_reporte_transaccion_ATM(pd_fecha in date, pd_error out varchar2)is
 --Reporte Transacciones aprobadas en el Switch Transacional FTS sin confirmación de respuesta del ATM 
   begin  
 
   Delete aqpd553;
   Commit;
   
   insert into aqpd553 (aqpd553nutar, aqpd553coter,aqpd553imptrans,aqpd553fetra, aqpd553nutra, aqpd553nrodoc)
   select '426153******'||substr(a.jaql540nutar,13,4) Tarjeta, a.JAQL540COTER nro_ATM, 
         to_number(y.jaql539valtr)/100.00 Importe, a.JAQL540FEINI fecha_transaccion, 
         a.jaql540nutra numero_trace, e.z0e478thd
   from jaql540 a
   inner join jaql539 x on a.jaql540cotra = x.jaql539cotra and x.jaql539nucam=32 and x.jaql539valtr='06890600'
   left outer join jaql539 y on a.jaql540cotra = y.jaql539cotra and y.jaql539nucam=4
   left outer join jaql540 c
   on c.JAQL540COMSJ=500 and c.JAQL540FEINI=a.JAQL540FEINI and c.JAQL540CORES='00' and c.JAQL540COREF=a.jaql540cotra
   left outer join jaql540 d
   on d.JAQL540COMSJ in (400, 420) and d.JAQL540FEINI=a.JAQL540FEINI and d.JAQL540CORES='00' 
   and d.JAQL540NUTRA=a.JAQL540NUTRA and d.JAQL540COTRX=a.JAQL540COTRX
   and d.JAQL540COTER=a.JAQL540COTER
   inner join z0e478 e on trim(e.z0e478nro) = a.jaql540nutar
   where  
   a.JAQL540COTRX like '01%' and a.JAQL540CORES = '00' and a.JAQL540COMSJ=200 
   and c.jaql540cotra is null and d.jaql540cotra is null
   and a.jaql540feini= pd_fecha;

   commit;

   pd_error:='OK'; 
   
end sp_reporte_transaccion_ATM;

procedure sp_reporte_transaccion_ATM_02(pd_fecha in date, pd_error out varchar2)is
  --Reporte Transacciones aprobadas en el Switch Transaccional FTS con generación de código de error (fraude).
   begin  
   
   Delete aqpd553;
   Commit;
   
     insert into aqpd553 (aqpd553nutar, aqpd553coter,aqpd553imptrans,aqpd553fetra, aqpd553nutra, aqpd553nrodoc)
     select '426153******'||substr(a.jaql540nutar,13,4) Tarjeta, a.JAQL540COTER nro_ATM, 
             to_number(y.jaql539valtr)/100.00 Importe, a.JAQL540FEINI fecha_transaccion, 
             a.jaql540nutra numero_trace, e.z0e478thd
     from jaql540 a
     inner join jaql539 x on a.jaql540cotra = x.jaql539cotra and x.jaql539nucam=32 and x.jaql539valtr='06890600'
     left outer join jaql539 y on a.jaql540cotra = y.jaql539cotra and y.jaql539nucam=4
     left outer join jaql540 c
     on c.JAQL540COMSJ=500 and c.JAQL540FEINI=a.JAQL540FEINI and c.JAQL540CORES='00' and c.JAQL540COREF=a.jaql540cotra
     left outer join jaql540 d
     on d.JAQL540COMSJ in (400, 420) and d.JAQL540FEINI=a.JAQL540FEINI and d.JAQL540CORES='00' 
     and d.JAQL540NUTRA=a.JAQL540NUTRA and d.JAQL540COTRX=a.JAQL540COTRX
     and d.JAQL540COTER=a.JAQL540COTER
     left outer join V_aqpd554 e on e.aqpd554date = a.jaql540feini and to_number(substr(to_char(e.aqpd554trace),3))=to_number(a.jaql540nutra)
     inner join z0e478 e on trim(e.z0e478nro) = a.jaql540nutar 
     where  
     a.JAQL540COTRX like '01%' and a.JAQL540CORES = '00' and a.JAQL540COMSJ=200 
     and c.jaql540cotra is null and d.jaql540cotra is null
     and e.aqpd554unit is not null
     and a.jaql540feini=pd_fecha;

     commit;

     pd_error:='OK'; 
   
end sp_reporte_transaccion_ATM_02;

end pq_cn_reportes;
/

