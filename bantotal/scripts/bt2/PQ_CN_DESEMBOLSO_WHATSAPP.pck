create or replace package PQ_CN_DESEMBOLSO_WHATSAPP is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CN_DESEMBOLSO_WHATSAPP
  -- Sistema               : BANTOTAL
  -- Módulo                : CANALES
  -- Versión               : 1.0
  -- Fecha de Creación     : 21/11/2025
  -- Autor de Creación     : Hernan Laqui Jimenez
  -- Uso                   : Funcionalidad para desembolsos por whatsapp
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 
  -- Autor de Creación     : 
  -- Descripción Modific.  : 
  -- ------------------------------------------------------------------------------------------------
  
  -- Public function and procedure declarations
  
  Procedure migrar_aqpb902a_aqpd257;    
  Procedure sp_ah_envio_constancia(                            
                             P_N_ID IN NUMBER,     
                             P_C_EMAILS IN VARCHAR2,
                             P_C_CODERR out varchar2,
                    	       p_c_DESERR out varchar2
                            ); 

end PQ_CN_DESEMBOLSO_WHATSAPP;
/
create or replace package body PQ_CN_DESEMBOLSO_WHATSAPP is

    
  Procedure migrar_aqpb902a_aqpd257 is 
                                   
  cursor c1 (fecha date, hora varchar) is  
  select AQPB902ACOD, AQPB902AMOD, AQPB902ASUC, AQPB902AMDA, AQPB902APAP, AQPB902ACTA, AQPB902AOPER, AQPB902ASBOP, AQPB902ATOPE, AQPB902AINST, 
  AQPB902AEMIS, AQPB902ADEST, AQPB902ACOPI, AQPB902AMESG, AQPB902AASUN, AQPB902ADDIG, AQPB902AERRO, AQPB902AERMG,AQPB902AUSUR,AQPB902AFECR, AQPB902AHORA
  from aqpb902a where AQPB902ADDIG=1 and AQPB902AERRO='0' and AQPB902AFECR=fecha and AQPB902AHORA>=hora;
  
  cursor datos_credito(instancia number) is 
  
  select   SNG001PAIS docpais, SNG001TDOC doctipo, SNG001NDOC docNumero, case when c.xwfmoneda = 0 then 'SOLES' else 'DOLARES' end moneda,               
           s.sng001ori,
               c.xwfmonto1 monto,
               c.xwfplazo1 plazo,   
               (select trim(penom) from fsd001 where pepais= SNG001PAIS and petdoc=SNG001TDOC and pendoc=SNG001NDOC) nombreCliente,      
               (select xlltasap
                  from x054023
                 where xllaocta = c.xwfcuenta
                   and xllaooper = c.xwfoperacion
                   and XLLAOSBOP = c.xwfsubope 
                ) tasa,                
                    (
                     select to_char( min(ppfpag), 'dd/mm/yyyy')
                                 from fsd601
                                where ppcta = c.xwfcuenta
                                  and ppoper = c.xwfoperacion      
                                  and ppint > 0 
                                   )                        
                    fechapago,
               (select xllcantcuo
                  from x054023
                 where xllaocta = c.xwfcuenta
                   and xllaooper = c.xwfoperacion
                   and XLLAOSBOP = c.xwfsubope 
                   ) 
                   cuotas,
               (select xllperiodo
                  from x054023
                 where xllaocta = c.xwfcuenta
                   and xllaooper = c.xwfoperacion
                   and XLLAOSBOP = c.xwfsubope 
                   ) periodo,
               (select g.ppcap + g.ppint + nvl((select ppimp11 + ppimp12 + ppimp13 + ppimp14 + ppimp15
                                                 from fsd611 a
                                                where ppcta = g.ppcta
                                                  and ppoper = g.ppoper
                                                  and a.ppfpag = g.ppfpag
                                                  and a.ppsbop = g.ppsbop 
                                                  ),
                                               0)
                  from fsd601 g
                 where g.ppcta = c.xwfcuenta
                   and g.ppoper = c.xwfoperacion
                   and g.ppsbop = c.xwfsubope 
                   and ppint>0
                   and rownum <= 1) cuotamensual   
               from sng001     s,
                     wfwrkitems b,
                     xwf700     c                    
               where s.sng001inst = instancia
                 and s.sng001inst = b.wfinsprcid                
                 and b.wfinsprcid = c.xwfprcins
                 and s.sng001inst = c.xwfprcins                                        
                 and s.sng001pais = 604
                 and c.xwfcar3 = '1'
                 and b.wftaskcod in ('55')
                 and b.wfitemstsact=1 
                 and s.sng001ori=0 --Solo créditos NORMALES            
                 and c.XWFMODULO=106 --Solo CONSUMO
                 ;   
                
                   
  
  ld_fechamax   DATE; 
  lv_horamax    VARCHAR(20); 

  ln_instancia  NUMBER(9); 
  ln_validainstancia  NUMBER(9);    
  lv_error varchar(1000);
  lv_estadoinicial   VARCHAR(20); 
  
  begin      
    ld_fechamax:= trunc(sysdate);
    begin
          select nvl(max(aqpd257HorRef),'00:00:00') into lv_horamax from aqpd257 where  aqpd257FECREG=ld_fechamax ;
    exception
    when others then  
         lv_horamax := '00:00:00';
    end;          

    begin
          select trim(TP1DESC) into lv_estadoinicial  from fst198 where tp1cod1=11147 and tp1corr1=100 and tp1corr2=1 and tp1corr3=1;
    exception
    when others then  
         lv_estadoinicial := 'NOINICIADO';
    end;          
        

      
   for i in c1 (ld_fechamax,lv_horamax) loop 
       ln_instancia := i.AQPB902AINST;
       select count(1) into ln_validainstancia from aqpd257 where aqpd257Instancia=ln_instancia and aqpd257fecreg=ld_fechamax;
       
       If ln_validainstancia=0 then
          begin
               for j in datos_credito (ln_instancia) loop
                  insert into aqpd257
                 (AQPD257ID, AQPD257INSTANCIA, AQPD257CREEMP, AQPD257CREMOD, AQPD257CRESUC, AQPD257CREMDA, AQPD257CREPAP, AQPD257CRECTA, AQPD257CREOPE, AQPD257CRESOP, 
                  AQPD257CRETOP, AQPD257FECREG, AQPD257HORREG, AQPD257PAIDOC, AQPD257TIPDOC, AQPD257NUMDOC, AQPD257NOMCLI, 
                  AQPD257MONTO,AQPD257MONEDA,AQPD257PERIODO, AQPD257PLAZO, AQPD257CUOTAS, AQPD257MONCUO, AQPD257FECPAG, AQPD257TEA, AQPD257HORREF,
                  AQPD257ESTDES, AQPD257ESTOTP, AQPD257ESTBIO, AQPD257ESTWHA, AQPD257ESTINI, AQPD257ESTBOT, AQPD257ORISOL
                  )                   
                 Values
                 (SQ_CN_AQPD257.Nextval, ln_instancia, i.AQPB902ACOD, i.AQPB902AMOD, i.AQPB902ASUC, i.AQPB902AMDA, i.AQPB902APAP, i.AQPB902ACTA, i.AQPB902AOPER, i.AQPB902ASBOP, 
                 i.AQPB902ATOPE, ld_fechamax, to_char(sysdate, 'hh24:mi:ss'),j.docpais, j.doctipo, j.docnumero, j.nombreCLiente, 
                 j.monto, j.moneda, j.periodo, j.plazo, j.cuotas, j.cuotamensual, j.fechapago, j.tasa, i.AQPB902AHORA,
                 'NOPROCESADO','NOPROCESADO','NOPROCESADO','NOPROCESADO',lv_estadoinicial,'NOPROCESADO',j.sng001ori
                 );
                 commit;
               End loop;
          
          exception
          when others then   
               lv_error:= sqlerrm;         
          end;
                                                            
       End If;         
   End Loop;  
    
       
   
                                   
  end migrar_aqpb902a_aqpd257;   
  
    Procedure sp_ah_envio_constancia(
                             P_N_ID IN NUMBER,                             
                             P_C_EMAILS IN VARCHAR2,
                             P_C_CODERR OUT VARCHAR2,
                    	       p_c_DESERR OUT VARCHAR2) 
                             is
      
                           
                                   
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);     
  lv_remitente  VARCHAR2(50);  
  lv_asunto     VARCHAR2(90);  
  lv_directorio VARCHAR2(30);  

  lv_destinos   VARCHAR2(32767):='';    
  lv_moneda     VARCHAR2(10);   
  lc_fecope   VARCHAR2(30); 
  lc_numtra   VARCHAR2(40); 
  

  L_AQPD257CREMDA number;
  L_AQPD257CORREO varchar2(100);
  L_AQPD257TRXFEC date;
  L_AQPD257TRXHOR varchar2(10);
  L_AQPD257TRXSUC number;
  L_AQPD257TRXMOD number;
  L_AQPD257TRXTRA number;
  L_AQPD257TRXREL number;
  L_AQPD257NOMCLI varchar2(100);
  L_AQPD257NUMCRE varchar2(30);
  L_AQPD257MONTO  number;
  L_AQPD257NUMCTA varchar2(30);
  L_AQPD257FECPAG date;
  L_AQPD257MONCUO number;
  L_AQPD257ARCHIV varchar2(1000);


  begin
    p_c_coderr := '000';
    p_c_deserr := '';        
  select
    AQPD257CREMDA, AQPD257CORREO, AQPD257TRXFEC, AQPD257TRXHOR, AQPD257TRXSUC, AQPD257TRXMOD, AQPD257TRXTRA, AQPD257TRXREL,
    AQPD257NOMCLI, AQPD257NUMCRE,AQPD257MONTO,AQPD257NUMCTA,AQPD257FECPAG,AQPD257MONCUO,AQPD257ARCHIV
  into
    L_AQPD257CREMDA, L_AQPD257CORREO, L_AQPD257TRXFEC, L_AQPD257TRXHOR, L_AQPD257TRXSUC, L_AQPD257TRXMOD, L_AQPD257TRXTRA, L_AQPD257TRXREL,
    L_AQPD257NOMCLI, L_AQPD257NUMCRE,L_AQPD257MONTO,L_AQPD257NUMCTA,L_AQPD257FECPAG,L_AQPD257MONCUO,L_AQPD257ARCHIV
  from aqpd257 where aqpd257id=P_N_ID;
           
   
    
    if L_AQPD257CREMDA = 0 then
       lv_moneda := 'S/ ';
    else
       lv_moneda := '$ ';
    end if;
    if P_C_EMAILS is null then
       lv_destinos := L_AQPD257CORREO;
    else
       lv_destinos := P_C_EMAILS;
    end if;        
    lv_remitente := 'whatsapp@cajaarequipa.pe';                 
    lc_fecope:= trim(to_char(L_AQPD257TRXFEC, 'DD/MM/YYYY')) || ' ' || trim(L_AQPD257TRXHOR) ;
    lc_numtra:= trim(to_char(L_AQPD257TRXFEC, 'YYYYMMDD')) || lpad(trim(L_AQPD257TRXSUC),3,'0') || lpad(trim(L_AQPD257TRXMOD),3,'0') || lpad(trim(L_AQPD257TRXTRA),3,'0') || lpad(trim(L_AQPD257TRXREL),4,'0');
       
      
       lv_asunto    := 'ENVIO AUTOMATICO -  CONFIRMACION ' || 'DESEMBOLSO DE CREDITO POR WHATSAPP' ; 
       lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';        
       dbms_lob.createtemporary(ll_mensaje, TRUE);              
        
       lv_mensaje := 
       '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
             Caja Arequipa</div>'||                  
       '<b style="font-family:Calibri; font-size:14px"> CONSTANCIA DE DESEMBOLSO DE CREDITO POR WHATSAPP</b>'||
       '<br>'||
       '<hr>' ||
       '<table>'||
       

       '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || L_AQPD257NOMCLI || '</td></tr>' ||
       '<tr><td colspan="3">&nbsp;</td></tr>'||
       '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de crédito</td><td> </td><td>' || trim(L_AQPD257NUMCRE) || '</td></tr> '||               
       '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
       '<tr style="font-family:Calibri; font-size:14px"><td>Número de transacción</td><td> </td><td>' || trim(lc_numtra) || '</td></tr> ' ||
       '<tr><td colspan="3">&nbsp;</td></tr>'||         
       '<tr style="font-family:Calibri; font-size:14px"><td>Monto del desembolso</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPD257MONTO,'9999,999.99')) || '</td></tr> '||         
       '<tr style="font-family:Calibri; font-size:14px"><td>Cuenta de abono</td><td> </td><td>' || trim(L_AQPD257NUMCTA) || '</td></tr> '||
       '<tr style="font-family:Calibri; font-size:14px"><td>Fecha primer pago</td><td> </td><td>' || trim(L_AQPD257FECPAG) || '</td></tr> '||
       '<tr style="font-family:Calibri; font-size:14px"><td>Monto cuota</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPD257MONCUO,'9999,999.99'))  || '</td></tr> ';                  
          
       lv_mensaje := lv_mensaje || '</table>';
                 
       lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
       dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
       lv_mensaje :=                            
       '<hr><span style="font-family:Calibri; font-size:12px">Se adjuntan los documentos del crédito desembolsado. Puedes verificar desembolso en cuenta en nuestros canales de atención.</span>'||
       '<hr>'||
       '<br>'||
       '<span style="font-family:Calibri; font-size:12px">El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja.</span>'||
       '<br>'||                
       '<span style="font-family:Calibri; font-size:12px">Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje.</span>'||
       '<br>'||
       '<span style="font-family:Calibri; font-size:12px">Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.</span>'||
       '<br>'||
       '<br>'
       ;
       lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                       
       dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                
    

                                                           
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
                                               p_archivosadjuntos  => L_AQPD257ARCHIV,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
      exception
      when others then  
           p_c_coderr := '00x';
           p_c_deserr := sqlerrm;                                                   
      end;      
      dbms_lob.freetemporary(ll_mensaje);    
                                   
  end sp_ah_envio_constancia;                                                              
      
  

end PQ_CN_DESEMBOLSO_WHATSAPP;
/
