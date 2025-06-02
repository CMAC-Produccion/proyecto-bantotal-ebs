create or replace package PQ_CN_CAJAMOVIL is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CN_CAJAMOVIL
  -- Sistema               : BANTOTAL
  -- Módulo                : CANALES
  -- Versión               : 1.0
  -- Fecha de Creación     : 01/04/2024
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Uso                   : Funcionalidad caja movil
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 01/05/2024
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Descripción Modific.  : Afiliacion / Desafiliacion de Cuentas FastCash a Tarjetas
  -- Fecha de Modificación : 15/06/2024
  -- Autor de Creación     : Hernan Laqui Jimenez
  -- Descripción Modific.  : Se modifica para agregar el canal 10 - Neocaja P51
  -- Fecha de Modificación : 18/06/2024
  -- Autor de Creación     : Hernan Laqui Jimenez
  -- Descripción Modific.  : Se modifica el envío de constancia para lineas, se cambia directorio  
  -- Fecha de Modificación : 27/06/2024
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Descripción Modific.  : Afiliacion / Desafiliacion codigo de referido - NeoCaja P51
  -- Fecha de Modificación : 02/02/2025
  -- Autor de Creación     : Frank Pinto Carpio
  -- Descripción Modific.  : Amortizacion de creditos
  -- Fecha de Modificación : 05/05/2025
  -- Autor de Creación     : Renzo Cuadros Salazar
  -- Descripción Modific.  : Se agregaron procedimientos para obtener fecha y hora del tipo de cambio
  -- Fecha de Modificación : 21/05/2025
  -- Autor de Creación     : Frank Pinto Carpio
  -- Descripción Modific.  : Se corrige variable de directorio de envio de cronograma nuevo tras amortizacion de credito

  -- ------------------------------------------------------------------------------------------------
  
  -- Public function and procedure declarations
  
  Procedure sp_ah_envio_mail(P_N_CODPAI IN NUMBER,          
                             P_N_TIPDOC IN NUMBER,
                             P_C_NUMDOC IN VARCHAR2,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_ADJUNT IN VARCHAR2,
                             P_C_TIPO IN VARCHAR2,                                                          
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2
                            );    
  Procedure sp_ah_envio_constancia(
                             P_N_CTSUC IN NUMBER,
                             P_N_CTMOD IN NUMBER,                             
                             P_N_CTTRA IN NUMBER,
                             P_N_CTREL IN NUMBER,
                             P_D_FECTRA IN DATE,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_CODERR out varchar2,
                    	       p_c_DESERR out varchar2
                            ); 
Procedure sp_ah_envio_correo(
                             P_N_CORR IN NUMBER,                             
                             P_C_EMAILS IN VARCHAR2,
                             P_C_CODERR OUT VARCHAR2,
                    	       p_c_DESERR OUT VARCHAR2
                            );                                  
 procedure sp_consulta_creditos( P_N_ID IN NUMBER,                                 
                                 P_N_NUMCTA IN NUMBER,
                                 p_c_DESERR OUT VARCHAR2);                                                       
  Function fn_ah_nombre_per(P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2              
                           ) return varchar2;
Procedure sp_crear_cuenta_cliente (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_N_CUENTA OUT NUMBER );
Procedure sp_valida_desgravamen (P_N_INSTANCIA IN NUMBER,                         
                                 P_C_APLICA OUT VARCHAR2 ) ;                          
Procedure sp_contar_creditos (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_N_CANTIDAD OUT NUMBER );     
Procedure sp_analista_vigente (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_C_ASESOR OUT VARCHAR2 ,
                            P_N_AGENCIA OUT NUMBER );  
Procedure sp_enviar_correo_gerente;  
Procedure sp_credito_aval_mora (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_C_CREMORA OUT VARCHAR2,
                            P_C_AVALMORA OUT VARCHAR2,
                            P_N_INSTANCIA OUT NUMBER); 
Procedure sp_monto_consolidado (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,                           
                            P_N_MONTO OUT NUMBER,
                            P_N_MONMAX OUT NUMBER);
Procedure sp_calcular_itf (P_N_MONTO IN NUMBER,
                           P_N_ITF OUT NUMBER);						   
procedure sp_ah_envio_voucher_digital(P_N_Drsuc  IN NUMBER,
                                        P_N_Drmod  IN NUMBER,
                                        P_N_Drtrn  IN NUMBER,
                                        P_N_Drrel  IN NUMBER,
                                        P_D_FECOPE IN DATE,
                                        P_C_CORREO IN VARCHAR2,
                                        P_C_NUMCTA IN VARCHAR2,
                                        P_C_TONOM  IN VARCHAR2,
                                        P_C_DESMDA IN VARCHAR2,
                                        P_C_MOSIGN IN VARCHAR2,
                                        P_N_IMPDEB IN NUMBER,
                                        P_N_TIPCAM IN NUMBER,
                                        P_N_CODPAI IN NUMBER,
                                        P_N_TIPDOC IN NUMBER,
                                        P_C_NUMDOC IN VARCHAR2,
                                        p_c_coderr OUT VARCHAR2,
                                        p_c_deserr OUT VARCHAR2);  
Procedure sp_enviar_correo_sueldo;			
Procedure sp_baja_sueldo      (P_N_CODPAI IN NUMBER,
                               P_N_TIPDOC IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2);				
Procedure sp_correo_pagare(
                             P_N_CORR IN NUMBER,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_CODERR OUT VARCHAR2,
                    	       p_c_DESERR OUT VARCHAR2);                               	
Procedure sp_aprobacion_gerente (P_N_INSTANCIA IN NUMBER,                         
                                 P_C_VALIDA OUT VARCHAR2 );   
Procedure sp_guardar_log_envio(p_fectra date,
                               p_hortra Character,
                               p_nutar Character,
                               p_numdoc Character,
                               p_destinatario  VARCHAR2,
                               p_destinatarioscc  VARCHAR2,  
                               p_destinatariosbcc VARCHAR2, 
                               p_mensaje          CLOB,
                               p_remitente        VARCHAR2,
                               p_asunto           VARCHAR2,
                               p_c_coderr         NUMBER,
                               p_c_deserr         VARCHAR2, 
                               p_canal            VARCHAR2);     
  -- rcuadros 05/05/2025
  PROCEDURE sp_cn_obtener_tc(pn_pizarr IN NUMBER,
                             pd_pgfape IN DATE,
                             pn_tccomp OUT NUMBER,
                             pn_tcvent OUT NUMBER,
                             pd_tcfech OUT DATE,
                             pc_tchora OUT VARCHAR2
                            );
  -- rcuadros 05/05/2025
  PROCEDURE sp_cn_calcular_tc(pn_pizarr IN NUMBER,
                              pd_tcfech IN DATE,
                              pc_tchora IN VARCHAR2,
                              pn_tccomp OUT NUMBER,
                              pn_tcvent OUT NUMBER
                             );
end PQ_CN_CAJAMOVIL;
/
create or replace package body PQ_CN_CAJAMOVIL is

    
  Procedure sp_ah_envio_mail(P_N_CODPAI IN NUMBER,          
                             P_N_TIPDOC IN NUMBER,
                             P_C_NUMDOC IN VARCHAR2,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_ADJUNT IN VARCHAR2,                                                          
                             P_C_TIPO IN VARCHAR2,
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2
                            ) is 
                                   
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);     
  lv_remitente  VARCHAR2(30);  
  lv_asunto     VARCHAR2(90);  
  lv_directorio VARCHAR2(30);  
  lv_archivos   VARCHAR2(32767);  
  lv_contacto   VARCHAR2(110);  
  lv_destinos   VARCHAR2(32767):='';  
  
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
    lv_destinos := P_C_EMAILS;
    lv_archivos := P_C_ADJUNT;
    
    lv_remitente := 'cajamovil@cajaarequipa.pe';
       
    Case
    When P_C_TIPO = 'C' then   --Contratos y Cartilla
         lv_asunto    := 'Bienvenidos a Caja Arequipa';
         lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';        
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Hola '||trim(lv_contacto)||'</p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Te damos la más cordial bienvenida a Caja Arequipa, gracias por depositar tu confianza en nosotros abriendo tu cuenta de ahorros en nuestra institución.</p>'||          
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Así mismo te adjuntamos los siguientes documentos:</p>';          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         lv_mensaje := '
                    <table width="1000" height="54" border="0">
                      <tbody>  
                        <tr>
                          <td width="15" height="23">1.</td>
                          <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Contrato de depósitos y servicios complementarios</td>
                        </tr>                                  
                        <tr>
                          <td width="15" height="23">2.</td>
                          <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Cartilla de Información de tu cuenta.</td>
                        </tr>
                      </tbody>
                    </table>';   
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
         lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Recuerda que la TREA (Tasa de Rendimiento Efectiva Anual), es la tasa que te permitirá determinar cuánto ganarás por tu dinero en el transcurso de un año.<br/>Para mayor información de tasas de interés, comisiones y gastos ingresa a www.cajaarequipa.pe o visita nuestra red de agencias a nivel nacional.</p>' ||          
                    '<p "font-family: Arial, sans-serif; font-size: 14px;"><b>Importante: </b>En caso la cuenta no reciba ningún abono en el lapso de 30 días luego de la apertura, esta será cancelada en forma automática.<br/></p>' ||          
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente.</p>'||                                                        
                    '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Jefe de Ahorros<br/>Caja Arequipa</strong></p>';                                          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
         
    When P_C_TIPO = 'E' then   --Extracto de Cuenta
         lv_asunto    := 'Confirmación de Envio de Extracto de Cuenta';
         lv_directorio:= 'DTPUMP_PR_EMAIL';        
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Hola '||trim(lv_contacto)||'</p>' ||                        
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Te adjuntamos el siguiente archivo:</p>';          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         lv_mensaje := '
                    <table width="1000" height="54" border="0">
                      <tbody>  
                        <tr>
                          <td width="15" height="23">1.</td>
                          <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Extracto de Cuenta</td>
                        </tr>                                  
                      </tbody>
                    </table>';   
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
         lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente.</p>'||                                                        
                    '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong></p>';                                          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
    When P_C_TIPO = 'G' then   --Extracto de Guardadito
         lv_asunto    := 'Confirmación de Envio de Extracto del Servicio Extra Programado';
         lv_directorio:= 'DTPUMP_PR_EMAIL';        
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE); 
                      
         lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Hola '||trim(lv_contacto)||'</p>' ||                        
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Te adjuntamos el siguiente archivo:</p>';          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         lv_mensaje := '
                    <table width="1000" height="54" border="0">
                      <tbody>  
                        <tr>
                          <td width="15" height="23">1.</td>
                          <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Extracto de Extra Programado</td>
                        </tr>                                  
                      </tbody>
                    </table>';   
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
         lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente.</p>'||                                                        
                    '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong></p>';                                          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
    Else
      null;
    End Case;
                                                           
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
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
      exception
      when others then  
           p_c_coderr := '00x';
           p_c_deserr := sqlerrm;                                                   
      end;      
      dbms_lob.freetemporary(ll_mensaje);    
                                   
  end sp_ah_envio_mail;   
  
    Procedure sp_ah_envio_constancia(
                             P_N_CTSUC IN NUMBER,
                             P_N_CTMOD IN NUMBER,                             
                             P_N_CTTRA IN NUMBER,
                             P_N_CTREL IN NUMBER,
                             P_D_FECTRA IN DATE,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_CODERR OUT VARCHAR2,
                    	       p_c_DESERR OUT VARCHAR2) 
                             is
      
                             /*P_N_CODPAI IN NUMBER,          
                             P_N_TIPDOC IN NUMBER,
                             P_C_NUMDOC IN VARCHAR2,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_ADJUNT IN VARCHAR2,                                                          
                             P_C_TIPO IN VARCHAR2,
                             P_C_NUMOPE IN VARCHAR2,
                             P_C_FECOPE IN VARCHAR2,
                             P_c_dato1 IN VARCHAR2,
                             P_c_dato2 IN VARCHAR2,
                             P_c_dato3 IN VARCHAR2,
                             p_n_moneda IN NUMBER,
                             p_n_monto1 IN NUMBER,
                             p_n_monto2 IN NUMBER,
                             p_n_monto3 IN NUMBER,
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2
                            ) is */
                                   
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);     
  lv_remitente  VARCHAR2(50);  
  lv_asunto     VARCHAR2(90);  
  lv_directorio VARCHAR2(30);  

  lv_contacto   VARCHAR2(110);  
  lv_destinos   VARCHAR2(32767):='';  
  
  lv_moneda     VARCHAR2(10); 
  lv_canal      VARCHAR2(50); 
  
  lc_fecope   VARCHAR2(30); 
  lc_numtra   VARCHAR2(40); 
  /*Variables de la AQPA705*/    
  L_AQPA705PDOC   NUMBER;
  L_AQPA705TDOC   NUMBER;
  L_AQPA705NDOC   CHAR(12); 
  L_AQPA705TIPOPE CHAR(1); 
  L_AQPA705FECTRA DATE;
  L_AQPA705HORTRA CHAR(8); 
  L_AQPA705CTAORI VARCHAR2(50); 
  L_AQPA705CTADES VARCHAR2(50); 
  L_AQPA705MONOPE NUMBER;
  L_AQPA705MDAOPE NUMBER;
  L_AQPA705COMOPE NUMBER;
  L_AQPA705AUXV1  VARCHAR2(200); 
  L_AQPA705AUXV2  VARCHAR2(200); 
  L_AQPA705AUXV3  VARCHAR2(200); 
  L_AQPA705AUXV4  VARCHAR2(200); 
  L_AQPA705AUXV5  VARCHAR2(200); 
  L_AQPA705AUXN1  NUMBER;
  L_AQPA705AUXN2  NUMBER;
  L_AQPA705AUXN3  NUMBER;
  L_AQPA705AUXN4  NUMBER;
  L_AQPA705AUXN5  NUMBER;
  L_AQPA705CORREO  VARCHAR2(500);
  L_AQPA705ARCHIV  VARCHAR2(500);
  L_AQPA705CANAL  NUMBER;

  begin
    p_c_coderr := '000';
    p_c_deserr := '';
    
    
    lv_remitente := 'cajamovil@cajaarequipa.pe';
    
    
    select AQPA705PDOC,AQPA705TDOC,AQPA705NDOC,AQPA705TIPOPE,AQPA705FECTRA,AQPA705HORTRA,AQPA705CTAORI,AQPA705CTADES,
    AQPA705MONOPE,AQPA705MDAOPE,AQPA705COMOPE,AQPA705AUXV1,AQPA705AUXV2,AQPA705AUXV3,AQPA705AUXV4,AQPA705AUXV5,
    AQPA705AUXN1,AQPA705AUXN2,AQPA705AUXN3,AQPA705AUXN4,AQPA705AUXN5, AQPA705CORREO, AQPA705ARCHIV, AQPA705CANAL
    into L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC,L_AQPA705TIPOPE,L_AQPA705FECTRA,L_AQPA705HORTRA,
    L_AQPA705CTAORI,L_AQPA705CTADES,L_AQPA705MONOPE,L_AQPA705MDAOPE,L_AQPA705COMOPE,L_AQPA705AUXV1,L_AQPA705AUXV2, 
    L_AQPA705AUXV3,L_AQPA705AUXV4,L_AQPA705AUXV5,L_AQPA705AUXN1,L_AQPA705AUXN2,L_AQPA705AUXN3,L_AQPA705AUXN4, 
    L_AQPA705AUXN5,L_AQPA705CORREO,L_AQPA705ARCHIV, L_AQPA705CANAL
    from AQPA705 where 
    AQPA705CTSUC    = P_N_CTSUC and 
    AQPA705CTMOD    = P_N_CTMOD and
    AQPA705CTTRA    = P_N_CTTRA and
    AQPA705CTREL    = P_N_CTREL and
    AQPA705CTFEC    = P_D_FECTRA;    
    
    if L_AQPA705MDAOPE = 0 then
       lv_moneda := 'S/ ';
    else
       lv_moneda := '$ ';
    end if;
    if P_C_EMAILS is null then
       lv_destinos := L_AQPA705CORREO;
    else
       lv_destinos := P_C_EMAILS;
    end if;
    
    Case            
    When L_AQPA705CANAL = 6 then
         lv_canal := 'CAJA MOVIL';
         lv_remitente := 'cajamovil@cajaarequipa.pe';   
    When L_AQPA705CANAL = 3 then
         lv_canal := 'HOMEBANKING';
         lv_remitente := 'homebanking@cajaarequipa.pe';   
    When L_AQPA705CANAL = 7 then
         lv_canal := 'HOMEBANKING'; 
         lv_remitente := 'homebanking@cajaarequipa.pe';   
    When L_AQPA705CANAL = 2 then
         lv_canal := 'CAJERO ATM';     
         lv_remitente := 'cajeroautomatico@cajaarequipa.pe'; 
    When L_AQPA705CANAL = 10 then --Hlaqui 15/06/2024 - Se agrega el Canal 10 NeoCaja - P51
         lv_canal := 'NEOCAJA P51';     
         lv_remitente := 'p51@cajaarequipa.pe';  
    else
         lv_canal := 'CAJA MOVIL';
         lv_remitente := 'cajamovil@cajaarequipa.pe';  
    End Case;
   
    
    --lv_archivos := L_AQPA705ARCHIV;
    lc_fecope:= trim(to_char(P_D_FECTRA, 'DD/MM/YYYY')) || ' ' || trim(L_AQPA705HORTRA) ;
    lc_numtra:= trim(to_char(P_D_FECTRA, 'YYYYMMDD')) || lpad(trim(P_N_CTSUC),3,'0') || lpad(trim(P_N_CTMOD),3,'0') || lpad(trim(P_N_CTTRA),3,'0') || lpad(trim(P_N_CTREL),4,'0');
       
    Case            
    When L_AQPA705TIPOPE = 'L' then   --Lineas
         --lv_asunto    := 'Confirmación de disposición de línea de crédito';
         
         lv_asunto    := 'ENVIO AUTOMATICO -  CONFIRMACION ' || 'DISPOSICION DE LINEA DE CREDITO - ' || trim(lv_canal); --' - CAJA MOVIL/HB';         
         lv_directorio:= 'DTPUMP_PR_EMAIL_DIG'; --Hlaqui 12/06/2024 - Se cambia de DTPUMP_PR_EMAIL a DTPUMP_PR_EMAIL_DIG       
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE DISPOSICION DE LINEA - ' || trim(lv_canal) || /*CAJA MOVIL */'</b>'||
         '<br>'||
         '<hr>' ||
         '<table>'||
                 
         '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||
         '<tr><td colspan="3">&nbsp;</td></tr>'||
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. línea crédito</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>Número de operación</td><td> </td><td>' || trim(L_AQPA705AUXV1) || '</td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Número de transacción</td><td> </td><td>' || trim(lc_numtra) || '</td></tr> ' ||
         '<tr><td colspan="3">&nbsp;</td></tr>'||
         '<tr style="font-family:Calibri; font-size:14px"><td>Linea total aprobada</td><td> </td><td>' || lv_moneda || trim(to_char(L_AQPA705AUXN1,'9999,999.99')) || '</td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Monto del desembolso</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPA705MONOPE,'9999,999.99')) || '</td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Monto utilizado (con este desembolso)</td><td> </td><td>' || lv_moneda || trim(to_char(L_AQPA705AUXN2,'9999,999.99')) || '</td></tr> '||
         '<tr><td colspan="3">&nbsp;</td></tr>'||
         '<tr style="font-family:Calibri; font-size:14px"><td>Cuenta de abono</td><td> </td><td>' || trim(L_AQPA705CTADES) || '</td></tr> '||
         '</table>';
                 
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         lv_mensaje :=                            
         '<hr><span style="font-family:Calibri; font-size:12px">En cronograma de pagos adjunto se incluye el detalle de monto desembolsado, importe de la cuota y fecha de primer vencimiento. Puedes verificar desembolso en cuenta en nuestros canales de atención.</span>'||
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
    When L_AQPA705TIPOPE = 'C' then   --Credito Digital
         --lv_asunto    := 'Confirmación de disposición de línea de crédito';
         
         lv_asunto    := 'ENVIO AUTOMATICO -  CONFIRMACION ' || 'DESEMBOLSO DE CREDITO - ' || trim(lv_canal); --' - CAJA MOVIL/HB';         
         lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';        
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE DESEMBOLSO DE CREDITO - ' || trim(lv_canal) || /*CAJA MOVIL */'</b>'||
         '<br>'||
         '<hr>' ||
         '<table>'||
                 
         '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||
         '<tr><td colspan="3">&nbsp;</td></tr>'||
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de crédito</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Número de transacción</td><td> </td><td>' || trim(lc_numtra) || '</td></tr> ' ||
         '<tr><td colspan="3">&nbsp;</td></tr>'||         
         '<tr style="font-family:Calibri; font-size:14px"><td>Monto del desembolso</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPA705MONOPE,'9999,999.99')) || '</td></tr> '||         
         --'<tr><td colspan="3">&nbsp;</td></tr>'||
         '<tr style="font-family:Calibri; font-size:14px"><td>Cuenta de abono</td><td> </td><td>' || trim(L_AQPA705CTADES) || '</td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha primer pago</td><td> </td><td>' || trim(L_AQPA705AUXV1) || '</td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Monto cuota</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPA705AUXN1,'9999,999.99'))  || '</td></tr> ';
         
         if L_AQPA705AUXV2 = 'Ampliación' then
             lv_mensaje := lv_mensaje ||
             '<tr><td colspan="3">&nbsp;</td></tr>'||
             '<tr style="font-family:Calibri; font-size:14px"><td>Tipo de crédito</td><td> </td><td>' || trim(L_AQPA705AUXV2) || '</td></tr> '||
             '<tr style="font-family:Calibri; font-size:14px"><td>Crédito a cancelar</td><td> </td><td>' || trim(L_AQPA705AUXV3) || '</td></tr> '||
             '<tr style="font-family:Calibri; font-size:14px"><td>Monto a cancelar</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPA705AUXN2,'9999,999.99'))  || '</td></tr> ' ||
             '<tr style="font-family:Calibri; font-size:14px"><td>Monto neto a desembolsar (menos ITF)</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPA705AUXN3,'9999,999.99'))  || '</td></tr> ';
         end if;
          
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
    When L_AQPA705TIPOPE = 'D' then   --Alta DPF
         --lv_asunto    := 'Confirmación de disposición de línea de crédito';
         
         lv_asunto    := 'ENVIO AUTOMATICO -  CONFIRMACION ' || 'ALTA DE DEPOSITO A PLAZO FIJO - ' || trim(lv_canal); --' - CAJA MOVIL/HB';         
         lv_directorio:= 'DTPUMP_PR_EMAIL_DPFDIG';        
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE DEPOSITO A PLAZO FIJO - ' || trim(lv_canal) || /*CAJA MOVIL */'</b>'||
         '<br>'||
         '<hr>' ||
         '<table>'||
                 
         '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||
         '<tr><td colspan="3">&nbsp;</td></tr>'||
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de cuenta DPF</td><td> </td><td>' || trim(L_AQPA705AUXV1) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Número de transacción</td><td> </td><td>' || trim(lc_numtra) || '</td></tr> ' ||
         '<tr><td colspan="3">&nbsp;</td></tr>'||         
         '<tr style="font-family:Calibri; font-size:14px"><td>Monto del depósito</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPA705MONOPE,'9999,999.99')) || '</td></tr> '||         
         '<tr style="font-family:Calibri; font-size:14px"><td>ITF</td><td> </td><td>' || lv_moneda ||trim(to_char(L_AQPA705AUXN1,'9999,990.99')) || '</td></tr> '||         
         --'<tr><td colspan="3">&nbsp;</td></tr>'||
         '<tr style="font-family:Calibri; font-size:14px"><td>Cuenta origen</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> ';
         if trim(L_AQPA705CTADES) <> '0' then
            lv_mensaje := lv_mensaje || '<tr style="font-family:Calibri; font-size:14px"><td>Cuenta pago intereses</td><td> </td><td>' || trim(L_AQPA705CTADES) || '</td></tr> ';
         End If;
         lv_mensaje := lv_mensaje || 
         '<tr style="font-family:Calibri; font-size:14px"><td>TREA</td><td> </td><td>' || trim(L_AQPA705AUXV2) || '% </td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Plazo</td><td> </td><td>' || trim(L_AQPA705AUXV3) || ' días </td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha de vencimiento</td><td> </td><td>' || trim(L_AQPA705AUXV4) || '</td></tr> '||
         '</table>';
                 
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         lv_mensaje :=                            
         '<hr><span style="font-family:Calibri; font-size:12px">Se adjuntan los documentos de la apertura del Depósito a Plazo Fijo. Puedes verificar tu cuenta en nuestros canales de atención.</span>'||
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
    Else
      null;
    End Case;
                                                           
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
                                               p_archivosadjuntos  => L_AQPA705ARCHIV,
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
      
  Procedure sp_ah_envio_correo(
                             P_N_CORR IN NUMBER,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_CODERR OUT VARCHAR2,
                    	       p_c_DESERR OUT VARCHAR2) 
                             is      
                                   
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767); 
  lv_correo     VARCHAR2(32767);    
  lv_remitente  VARCHAR2(50);  
  lv_asunto     VARCHAR2(150);  
  lv_directorio VARCHAR2(30);  
  lv_archivos   VARCHAR2(32767);  
  lv_contacto   VARCHAR2(110);  
  lv_destinos   VARCHAR2(32767):='';  
  ln_Tp1corr2   NUMBER(9);
  l_offset      NUMBER;
  l_ammount     NUMBER;
  lv_moneda     VARCHAR2(50); 
  lv_canal      VARCHAR2(50); 
  
  lc_fecope   VARCHAR2(30); 
  lc_numtra   VARCHAR2(40); 
  /*Variables de la AQPA705*/    
  L_AQPA705PDOC   NUMBER;
  L_AQPA705TDOC   NUMBER;
  L_AQPA705NDOC   CHAR(12);
  L_AQPA705TIPOPE CHAR(1);
  L_AQPA705FECTRA DATE;
  L_AQPA705HORTRA CHAR(8);
  L_AQPA705CTAORI VARCHAR2(50);
  L_AQPA705CTADES VARCHAR2(50);
  L_AQPA705MONOPE NUMBER;
  L_AQPA705MDAOPE NUMBER;
  L_AQPA705COMOPE NUMBER;
  L_AQPA705AUXV1  VARCHAR2(200);
  L_AQPA705AUXV2  VARCHAR2(200);
  L_AQPA705AUXV3  VARCHAR2(200);
  L_AQPA705AUXV4  VARCHAR2(200);
  L_AQPA705AUXV5  VARCHAR2(200);
  L_AQPA705AUXV6  VARCHAR2(1500);
  L_AQPA705AUXN1  NUMBER;
  L_AQPA705AUXN2  NUMBER;
  L_AQPA705AUXN3  NUMBER;
  L_AQPA705AUXN4  NUMBER;
  L_AQPA705AUXN5  NUMBER;
  L_AQPA705CORREO  VARCHAR2(500);
  L_AQPA705ARCHIV  VARCHAR2(500);
  L_AQPA705CANAL  NUMBER;
  L_AQPA705NUTAR  CHAR(19);
  lv_monsim  VARCHAR2(50);
  lv_tipcta VARCHAR(2);
  lv_descta VARCHAR(100);
  -- Inicio rcuadros 20/03/2024 - Cancelacion de Creditos
  lv_cadena VARCHAR2(1500);
  lv_delimitador1 VARCHAR2(1) := '|';
  lv_delimitador2 VARCHAR2(1) := ':';
  ln_inicio NUMBER := 1;
  ln_fin_dsc NUMBER;
  ln_fin_imp NUMBER;
  lv_descripcion VARCHAR2(50);
  ln_importe NUMBER;
  lv_importe VARCHAR2(50);
  -- Fin rcuadros 20/03/2024 - Cancelacion de Creditos
  cursor c1 (tar CHAR) is --Cuentas afiliadas a tarjeta
  
  select case when z0e479mod=21 
              then lpad(trim(z0e479cta),9,'0')  || lpad(trim(z0e479mod),3,'0') || lpad(trim(z0e479mon),3,'0') || lpad(trim(z0e479sct),2,'0') || lpad(trim(z0e479top),3,'0')
              when z0e479mod=22
              then lpad(trim(z0e479cta),9,'0')  || lpad(trim(z0e479mod),3,'0') || lpad(trim(z0e479mon),3,'0') || lpad(trim(z0e479ope),9,'0') || lpad(trim(z0e479top),3,'0')              
         end cuenta        
  from z0e479 a
  inner join fsd011 b on
  Scsuc = z0e479suc
  and Sccta = z0e479cta
  and Scmod = z0e479mod
  and Scmda = z0e479mon
  and Scsbop = z0e479sct
  and Sctope = z0e479top
  and Scpap =  z0e479pap
  and Scoper = z0e479ope 
  and pgcod  = 1
  and Scstat <> 99
  and z0e478nro=tar;
  
  -- Inicio rcuadros 01/05/2024 - Cuentas FastCash Afiliadas a la tarjeta
  CURSOR C2 (NUMTAR CHAR) IS
  SELECT
    CASE
      WHEN A.Z0E479MOD = 21
        THEN LPAD(TRIM(A.Z0E479CTA), 9, '0') || LPAD(TRIM(A.Z0E479MOD), 3, '0') || LPAD(TRIM(A.Z0E479MON), 3, '0') || LPAD(TRIM(A.Z0E479SCT), 2, '0') || LPAD(TRIM(A.Z0E479TOP), 3, '0')
      WHEN A.Z0E479MOD = 22
        THEN LPAD(TRIM(A.Z0E479CTA), 9, '0') || LPAD(TRIM(A.Z0E479MOD), 3, '0') || LPAD(TRIM(A.Z0E479MON), 3, '0') || LPAD(TRIM(A.Z0E479OPE), 9, '0') || LPAD(TRIM(A.Z0E479TOP), 3, '0')
    END CUENTA
  FROM Z0E479 A
  INNER JOIN FSD011 B
  ON B.SCSUC = A.Z0E479SUC
  AND B.SCCTA = A.Z0E479CTA
  AND B.SCMOD = A.Z0E479MOD
  AND B.SCMDA = A.Z0E479MON
  AND B.SCSBOP = A.Z0E479SCT
  AND B.SCTOPE = A.Z0E479TOP
  AND B.SCPAP = A.Z0E479PAP
  AND B.SCOPER = A.Z0E479OPE
  AND B.PGCOD = 1
  AND B.SCSTAT <> 99
  AND A.Z0E480COD = 3
  AND A.Z0E478NRO = NUMTAR;
  -- Fin rcuadros 01/05/2024 - Cuentas FastCash Afiliadas a la tarjeta
  
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
    
    
    lv_remitente := 'cajamovil@cajaarequipa.pe';
    
    
    select AQPA705PDOC,AQPA705TDOC,AQPA705NDOC,AQPA705TIPOPE,AQPA705FECTRA,AQPA705HORTRA,AQPA705CTAORI,AQPA705CTADES,
    AQPA705MONOPE,AQPA705MDAOPE,AQPA705COMOPE,AQPA705AUXV1,AQPA705AUXV2,AQPA705AUXV3,AQPA705AUXV4,AQPA705AUXV5,AQPA705AUXV6, 
    AQPA705AUXN1,AQPA705AUXN2,AQPA705AUXN3,AQPA705AUXN4,AQPA705AUXN5, AQPA705CORREO, AQPA705ARCHIV, AQPA705CANAL, AQPA705NUTAR
    into L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC,L_AQPA705TIPOPE,L_AQPA705FECTRA,L_AQPA705HORTRA, 
    L_AQPA705CTAORI,L_AQPA705CTADES,L_AQPA705MONOPE,L_AQPA705MDAOPE,L_AQPA705COMOPE,L_AQPA705AUXV1,L_AQPA705AUXV2, 
    L_AQPA705AUXV3,L_AQPA705AUXV4,L_AQPA705AUXV5,L_AQPA705AUXV6,L_AQPA705AUXN1,L_AQPA705AUXN2,L_AQPA705AUXN3,L_AQPA705AUXN4, 
    L_AQPA705AUXN5,L_AQPA705CORREO,L_AQPA705ARCHIV, L_AQPA705CANAL, L_AQPA705NUTAR
    from AQPA705 where 
    AQPA705CORR    = P_N_CORR;    
    
    if L_AQPA705MDAOPE = 0 then
       lv_moneda := 'SOL';
       lv_monsim := 'S/ ';
    else
       lv_moneda := 'DOLAR AMERICANO';
       lv_monsim := '$ ';
    end if;   
       
    if P_C_EMAILS is null then
       lv_destinos := L_AQPA705CORREO;
    else
       lv_destinos := P_C_EMAILS;
    end if;
    
    Case            
    When L_AQPA705CANAL = 6 then
         lv_canal := 'CAJA MOVIL';
         lv_remitente := 'cajamovil@cajaarequipa.pe';   
    When L_AQPA705CANAL = 3 then
         lv_canal := 'HOMEBANKING';
         lv_remitente := 'homebanking@cajaarequipa.pe';   
    When L_AQPA705CANAL = 7 then
         lv_canal := 'HOMEBANKING'; 
         lv_remitente := 'homebanking@cajaarequipa.pe';   
    When L_AQPA705CANAL = 2 then
         lv_canal := 'CAJERO ATM';     
         lv_remitente := 'cajeroautomatico@cajaarequipa.pe';   
    When L_AQPA705CANAL = 10 then --Hlaqui 15/06/2024 - Se agrega el Canal 10 NeoCaja - P51
         lv_canal := 'NEOCAJA P51';     
         lv_remitente := 'p51@cajaarequipa.pe';           
    else
         lv_canal := 'CAJA MOVIL';
         lv_remitente := 'cajamovil@cajaarequipa.pe';  
    End Case;
   
    
    --lv_archivos := L_AQPA705ARCHIV;
    lc_fecope:= trim(to_char(L_AQPA705FECTRA, 'DD/MM/YYYY')) || ' ' || trim(L_AQPA705HORTRA) ;    
       
    Case                                
    When L_AQPA705TIPOPE = 'G' then   --Afiliacion/Desafiliacion de cuentas a tarjetas
         
         lv_asunto    := 'ENVIO AUTOMATICO -  CONFIRMACION DE ' || trim(L_AQPA705AUXV1) || ' DE CUENTA - ' || trim(lv_canal); --' - CAJA MOVIL/HB';         
         lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';        
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE '|| trim(L_AQPA705AUXV1) ||' DE CUENTA - ' || trim(lv_canal) || /*CAJA MOVIL */'</b>'||
         '<hr>' ||
         '<table>'||
                 
         '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||         
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de tarjeta</td><td> </td><td>' || '426153******' || substr(L_AQPA705NUTAR,13) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de cuenta</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Acción</td><td> </td><td>' || trim(L_AQPA705AUXV1) || '</td></tr> ' ||                       
         '<tr style="font-family:Calibri; font-size:14px"><td>Afiliadas actualmente</td><td> </td><td></td></tr> ';         
         
         for i in c1 (L_AQPA705NUTAR) loop 
             lv_mensaje := lv_mensaje || '<tr style="font-family:Calibri; font-size:14px"><td></td><td> </td><td>' || trim(i.cuenta) || '</td></tr> ';
         End Loop;                                  
         lv_mensaje := lv_mensaje || '</table>';
         lv_correo := lv_mensaje;        
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         lv_mensaje :=                            
         '<hr><span style="font-family:Calibri; font-size:12px">Le recordamos que usted puede realizar la afiliación/desafiliación de sus cuentas a su tarjeta de débito en cualquier momento y con total seguridad ingresando nuestra clave Token. Así mismo podrá cambiar los límites máximos horarios de retiro por canales alternativos a través de nuestra App o Web.</span>'||
         '<br><br>' ||
         '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>'||
         '<br>' ||
         '<span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>';                         
                    
         /*'<hr>'||
         '<br>'||
         '<span style="font-family:Calibri; font-size:12px">El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja.</span>'||
         '<br>'||                
         '<span style="font-family:Calibri; font-size:12px">Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje.</span>'||
         '<br>'||
         '<span style="font-family:Calibri; font-size:12px">Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.</span>'||
         '<br>'||
         '<br>'*/
         
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                       
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
    When L_AQPA705TIPOPE = 'A' then   --Apertura de cuentas de ahorros
         lv_asunto    := 'Bienvenidos a Caja Arequipa';
         lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';                 
		     lv_tipcta := substr(trim(L_AQPA705CTAORI),19,2); --Hlaqui 31/08/2022                																					 
         select trim(tonom) into lv_descta from fst004 where modulo=21 and totope= to_number(lv_tipcta);
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);                      
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA APERTURA DE CUENTA - ' || trim(lv_canal) ||'</b>'||
         '<br>'||
         '<hr>' ||
         '<table>'||
                 
         '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ;         
         lv_mensaje := lv_mensaje || 
         '<tr style="font-family:Calibri; font-size:14px"><td>Número de cuenta</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>CCI</td><td> </td><td>' || trim(L_AQPA705AUXV1) || '</td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Moneda</td><td> </td><td>' || trim(lv_moneda) || '</td></tr> ' ||                
         '<tr style="font-family:Calibri; font-size:14px"><td>Tipo de cuenta</td><td> </td><td>' || trim(lv_descta) || '</td></tr> ' || --Hlaqui 31/08/2022
         '<tr style="font-family:Calibri; font-size:14px"><td>Documentos Adjuntos</td><td> </td><td>Contrato de depósitos y servicios complementarios</td></tr> ' ||
         '<tr style="font-family:Calibri; font-size:14px"><td></td><td> </td><td>Cartilla de Información de tu cuenta</td></tr> ';
         --Hlaqui 31/08/2022 - Cuentas CTS y Sueldo
         
         If lv_tipcta in ('02','06') then
            lv_mensaje := lv_mensaje || '<tr style="font-family:Calibri; font-size:14px"><td>RUC del empleador</td><td> </td><td>' || trim(L_AQPA705AUXV2) || '</td></tr> ';
            lv_mensaje := lv_mensaje || '<tr style="font-family:Calibri; font-size:14px"><td>Razón social del empleador</td><td> </td><td>' || trim(L_AQPA705AUXV3) || '</td></tr> ';
         End If;
         
         lv_mensaje := lv_mensaje || '</table>';
          
       
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
         lv_mensaje :=                            
         '<hr><span style="font-family:Calibri; font-size:12px">Recuerda que la TREA (Tasa de Rendimiento Efectiva Anual), es la tasa que te permitirá determinar cuánto ganarás por tu dinero en el transcurso de un año.<br>Para mayor información de tasas de interés, comisiones y gastos ingresa a www.cajaarequipa.pe o visita nuestra red de agencias a nivel nacional.</span>'||
         '<hr>';
        
         --hlaqui 31/08/2022 para cuentas CTS
         
         If lv_tipcta = '02' then
            lv_mensaje:= lv_mensaje ||
            '<br>'||
            '<span style="font-family:Calibri; font-size:12px"><b>Importante:</b>En caso tu cuenta CTS no reciba ningun abono en el lapso de 180 días luego de tu apertura, esta será cancelada en forma automática.<br> Acércate a cualquiera de nuestras agencias para regularizar tu cuenta acreditando que eres trabajador de la empresa.</span>';
         Else
            lv_mensaje := lv_mensaje ||
            '<br>'||
            '<span style="font-family:Calibri; font-size:12px"><b>Importante: </b>En caso la cuenta no reciba ningún abono en el lapso de 30 días luego de la apertura, esta será cancelada en forma automática.</span>';
         End If;
           
         lv_mensaje:= lv_mensaje ||  
         '<br><br>' ||			
         '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>'||
         '<br>'||
         '<span style="font-family:Calibri; font-size:12px"><strong>Jefe de Productos Pasivos<br/>Caja Arequipa</strong></p></span>'||
         '<br>'||
         '<br>'
         ;
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                                    
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    When L_AQPA705TIPOPE = 'T' then   --Tarjeta Digital
         lv_asunto    := 'Bienvenidos a Caja Arequipa';
         lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';                 
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         /*lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Hola '||trim(lv_contacto)||'</p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Te damos la más cordial bienvenida a Caja Arequipa, gracias por depositar tu confianza en nosotros abriendo tu cuenta de ahorros en nuestra institución.</p>'||          
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Así mismo te adjuntamos los siguientes documentos:</p>';          
         
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); */
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA TARJETA DIGITAL Y APERTURA DE CUENTA - ' || trim(lv_canal) ||'</b>'||
         '<br>'||
         '<hr>' ||
         '<table>'||
                 
         '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ;
         --'<tr><td colspan="3">&nbsp;</td></tr>'||

         --lv_mensaje := lv_mensaje || '<tr style="font-family:Calibri; font-size:14px"><td>Número de tarjeta</td><td> </td><td>' || trim(L_AQPA705AUXV2) || '</td></tr> ';

         lv_mensaje := lv_mensaje || 
         '<tr style="font-family:Calibri; font-size:14px"><td>Número de cuenta</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>CCI</td><td> </td><td>' || trim(L_AQPA705AUXV1) || '</td></tr> '||
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Moneda</td><td> </td><td>' || trim(lv_moneda) || '</td></tr> ' ||                
         '<tr style="font-family:Calibri; font-size:14px"><td>Documentos Adjuntos</td><td> </td><td>Contrato de depósitos y servicios complementarios</td></tr> ' ||
         '<tr style="font-family:Calibri; font-size:14px"><td></td><td> </td><td>Cartilla de Información de tu cuenta</td></tr> ' ||
         '<tr style="font-family:Calibri; font-size:14px"><td></td><td> </td><td>Tarjeta Digital</td></tr> ' ||
         '</table>';
          
       
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
         lv_mensaje :=                            
         '<hr><span style="font-family:Calibri; font-size:12px">Recuerda que la TREA (Tasa de Rendimiento Efectiva Anual), es la tasa que te permitirá determinar cuánto ganarás por tu dinero en el transcurso de un año.<br/>Para mayor información de tasas de interés, comisiones y gastos ingresa a www.cajaarequipa.pe o visita nuestra red de agencias a nivel nacional.</span>'||
         '<br><span style="font-family:Calibri; font-size:12px">La activación y desactivación de notificaciones por operaciones realizadas con tarjeta de débito se realizará en las oficinas de Caja Arequipa</span>'||
         '<hr>'||
         '<br>'||
         '<span style="font-family:Calibri; font-size:12px"><b>Importante: </b>En caso la cuenta no reciba ningún abono en el lapso de 30 días luego de la apertura, esta será cancelada en forma automática.</span>'||
         '<br>'||                
         '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>'||
         '<br>'||
         '<span style="font-family:Calibri; font-size:12px"><strong>Jefe de Productos Pasivos<br/>Caja Arequipa</strong></p></span>'||
         '<br>'||
         '<br>'
         ;
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
           
         /*lv_mensaje := '<p "font-family:Calibri; font-size:12px">Recuerda que la TREA (Tasa de Rendimiento Efectiva Anual), es la tasa que te permitirá determinar cuánto ganarás por tu dinero en el transcurso de un año.<br/>Para mayor información de tasas de interés, comisiones y gastos ingresa a www.cajaarequipa.pe o visita nuestra red de agencias a nivel nacional.</p>' ||          
                    '<p "font-family:Calibri; font-size:12px"><b>Importante: </b>En caso la cuenta no reciba ningún abono en el lapso de 30 días luego de la apertura, esta será cancelada en forma automática.<br/></p>' ||          
                    '<p "font-family:Calibri; font-size:12px">Cordialmente.</p>'||                                                        
                    '<p "font-family:Calibri; font-size:12px"><strong>Jefe de Ahorros<br/>Caja Arequipa</strong></p>';                                          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);  */                                  
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                     
    When L_AQPA705TIPOPE = 'H' then   --Afiliacion/Desafiliacion de Guardadito
         
         lv_asunto    := 'ENVIO AUTOMATICO -  CONFIRMACION DE ' || trim(L_AQPA705AUXV1) || ' DEL SERVICIO EXTRA PROGRAMADO - ' || trim(lv_canal); --' - CAJA MOVIL/HB';         
         lv_directorio:= 'DTPUMP_PR_EMAIL';        
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE '|| trim(L_AQPA705AUXV1) ||' DEL SERVICIO EXTRA PROGRAMADO  - ' || trim(lv_canal) || /*CAJA MOVIL */'</b>'||
         '<hr>' ||
         '<table>'||
                 
         '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||         
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. Documento</td><td> </td><td>' || trim(L_AQPA705NDOC) || '</td></tr>' ||         
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de cuenta</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Nombre</td><td> </td><td>' || trim(L_AQPA705AUXV2) || '</td></tr> ' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Frecuencia</td><td> </td><td>' || 'Del ' || trim(to_char(L_AQPA705AUXN1)) || ' al ' || trim(to_char(L_AQPA705AUXN2)) || '</td></tr> ' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Plazo</td><td> </td><td>' || to_char(trim(L_AQPA705AUXN3)) || ' Meses' || '</td></tr> ' ||
         '<tr style="font-family:Calibri; font-size:14px"><td>Monto Mensual</td><td> </td><td>' || lv_monsim || trim(to_char(L_AQPA705AUXN4,'9999,999.99')) || '</td></tr> ' ;

         lv_mensaje := lv_mensaje || '</table>';
                 
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         If trim(L_AQPA705AUXV1) = 'AFILIACION' then
            lv_mensaje :=                            
            '<hr><span style="font-family:Calibri; font-size:12px">Le recordamos que usted puede realizar la desafiliación del servicio Extra Programado en cualquier momento y con total seguridad ingresando a nuestros canales alternativos App o Web.</span>';
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         Else
            lv_mensaje :=                            
            '<hr><span style="font-family:Calibri; font-size:12px"></span>';
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         End If;
         lv_mensaje :=                                     
         '<br><br>' ||
         '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>'||
         '<br>' ||
         '<span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>';                                                    
         
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                       
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
    When L_AQPA705TIPOPE = 'U' then   --uso de datos personales
         
         lv_asunto    := 'ENVIO AUTOMATICO -  AUTORIZACION Y PROTECCION DE DATOS PERSONALES - ' || trim(lv_canal);
         lv_directorio:= 'DTPUMP_PR_EMAIL';        
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE AUTORIZACION Y PROTECCION DE DATOS PERSONALES - ' || trim(lv_canal) || /*CAJA MOVIL */'</b>'||
         '<hr>' ||
         '<table>'||
                 
         '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||         
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. Documento</td><td> </td><td>' || trim(L_AQPA705NDOC) || '</td></tr>' ||         
         '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de cuenta</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> '||               
         '<tr style="font-family:Calibri; font-size:14px"><td>Tipo de producto</td><td> </td><td>' || trim(L_AQPA705AUXV1) || '</td></tr> ' ||         
         '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ;

         lv_mensaje := lv_mensaje || '</table>';
                 
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
         lv_mensaje :=                            
         '<hr><span style="font-family:Calibri; font-size:12px"></span>';
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
                      
         lv_mensaje :=                                     
         '<br><br>' ||
         '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>'||
         '<br>' ||
         '<span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>';                                                    
         
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                       
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         
    WHEN L_AQPA705TIPOPE = 'B' THEN -- rcuadros 20/03/2024 - Cancelacion de Creditos
      lv_asunto     := 'ENVIO AUTOMATICO - CONFIRMACION DE CANCELACION DE CREDITO - ' || TRIM(lv_canal);
      lv_directorio := 'DTPUMP_PR_EMAIL';
      lv_contacto   := PQ_CN_CAJAMOVIL.fn_ah_nombre_per(L_AQPA705PDOC, L_AQPA705TDOC, L_AQPA705NDOC);
      dbms_lob.createtemporary(ll_mensaje, TRUE);
      
      lv_mensaje := 
      '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">Caja Arequipa</div>'||
      '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE CANCELACION DE CREDITO - ' || TRIM(lv_canal) || '</b>'||
      '<hr>' ||
      '<table>'||
      
      '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||
      '<tr><td colspan="3">&nbsp;</td></tr>' ||
      '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de crédito</td><td> </td><td>' || TRIM(L_AQPA705CTADES) || '</td></tr>'||
      '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  TRIM(lc_fecope) || '</td></tr>' ||
      '<tr style="font-family:Calibri; font-size:14px"><td>Número de transacción</td><td> </td><td>' || TRIM(L_AQPA705AUXV3) || '</td></tr>' ||
      '<tr><td colspan="3">&nbsp;</td></tr>';
         
      lv_cadena := L_AQPA705AUXV6;
         
      IF SUBSTR(lv_cadena, -1) = '|' THEN
        lv_cadena := RTRIM(lv_cadena, '|');
      END IF;
      
      LOOP
        ln_fin_dsc := INSTR(lv_cadena, lv_delimitador2, ln_inicio);
        EXIT WHEN ln_fin_dsc = 0;
        ln_fin_imp := INSTR(lv_cadena, lv_delimitador1, ln_fin_dsc);
        IF ln_fin_imp = 0 THEN
          ln_fin_imp := LENGTH(lv_cadena) + 1;
        END IF;
      
        lv_descripcion := SUBSTR(lv_cadena, ln_inicio, ln_fin_dsc - ln_inicio);
        ln_importe := TO_NUMBER(SUBSTR(TO_CHAR(lv_cadena), ln_fin_dsc + 1, ln_fin_imp - ln_fin_dsc - 1), '999999999.99999999999999999');
        lv_mensaje := lv_mensaje || '<tr style="font-family:Calibri; font-size:14px"><td>' || TRIM(lv_descripcion) || '</td><td> </td><td>' || lv_monsim || CASE WHEN ln_importe = 0 THEN '0.00' ELSE TRIM(TO_CHAR(ln_importe, '9999,999.99')) END || '</td></tr>';
        ln_inicio := ln_fin_imp + 1;
      END LOOP;
      
      lv_mensaje := lv_mensaje || '</table>';
      
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
      lv_mensaje :=
      '<hr><span style="font-family:Calibri; font-size:12px">De cancelar la última cuota de su crédito y no tener otras obligaciones pendientes con Caja Arequipa, puedes descargar tu Certificado de No Adeudo en la sección "Ayuda" de la página principal. www.cajaarequipa.pe o directamente en: https://productos.cajaarequipa.pe/CNA/</span>';
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      
      lv_mensaje :=
      '<br><br>' ||
      '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>'||
      '<br>' ||
      '<span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>';
      
      lv_correo := lv_mensaje;
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
    WHEN L_AQPA705TIPOPE = 'I' THEN -- rcuadros 01/05/2024 - Afiliacion / Desafiliacion de Cuentas FastCash a Tarjetas
         lv_asunto := 'ENVIO AUTOMATICO - CONFIRMACION DE ' || TRIM(L_AQPA705AUXV1) || ' DE CUENTA FASTCASH - ' || TRIM(lv_canal);
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC, L_AQPA705TDOC, L_AQPA705NDOC);                 
         dbms_lob.createtemporary(ll_mensaje, TRUE);
         lv_mensaje :=
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">' ||
           'Caja Arequipa' ||
         '</div>' ||
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE '|| TRIM(L_AQPA705AUXV1) || ' DE CUENTA FASTCASH - ' || TRIM(lv_canal) || '</b>' ||
         '<hr>' ||
         
         '<table>' ||
           '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||         
           '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de tarjeta</td><td> </td><td>' || '426153******' || SUBSTR(L_AQPA705NUTAR, 13) || '</td></tr>' ||
           '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de cuenta</td><td> </td><td>' || TRIM(L_AQPA705CTAORI) || '</td></tr>' ||
           '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  TRIM(lc_fecope) || '</td></tr>' ||
           '<tr style="font-family:Calibri; font-size:14px"><td>Acción</td><td> </td><td>' || TRIM(L_AQPA705AUXV1) || '</td></tr>' ||
           '<tr style="font-family:Calibri; font-size:14px"><td>Cuentas fastcash actualmente</td><td> </td><td></td></tr>';
           
           FOR i IN c2 (L_AQPA705NUTAR) LOOP
             lv_mensaje := lv_mensaje || '<tr style="font-family:Calibri; font-size:14px"><td></td><td> </td><td>' || TRIM(i.cuenta) || '</td></tr>';
           END LOOP;
                    
         lv_mensaje := lv_mensaje || '</table>';
         lv_correo := lv_mensaje;
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
         lv_mensaje :=
         '<hr><span style="font-family:Calibri; font-size:12px">Le recordamos que usted puede realizar la afiliación/desafiliación de sus cuentas fastcash a su tarjeta de débito en cualquier momento y con total seguridad ingresando nuestra clave Token. Así mismo podrá cambiar los límites máximos horarios de retiro por canales alternativos a través de nuestra App o Web.</span>' ||
         '<br><br>' ||
         '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>' ||
         '<br>' ||
         '<span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>';
         
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
    WHEN L_AQPA705TIPOPE = 'N' THEN -- rcuadros 27/06/2024 - Afiliacion / Desafiliacion Codigo de Referido NeoCaja P51
         lv_asunto := 'ENVIO AUTOMATICO - CONFIRMACION DE ' || TRIM(L_AQPA705AUXV1) || ' - ' || TRIM(lv_canal);
         lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC, L_AQPA705TDOC, L_AQPA705NDOC);              
         dbms_lob.createtemporary(ll_mensaje, TRUE);
         lv_mensaje :=
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">' ||
           'Caja Arequipa' ||
         '</div>' ||
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE '|| TRIM(L_AQPA705AUXV1) || ' - ' || TRIM(lv_canal) || '</b>' ||
         '<hr>' ||

         '<table>' ||
           '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||         
           '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de tarjeta</td><td> </td><td>' || '426153******' || SUBSTR(L_AQPA705NUTAR, 13) || '</td></tr>' ||
           '<tr style="font-family:Calibri; font-size:14px"><td>Código de referido utilizado</td><td> </td><td>' || TRIM(L_AQPA705AUXV2) || '</td></tr>' ||          
           '<tr style="font-family:Calibri; font-size:14px"><td>Nombre del Referidor</td><td> </td><td>' || TRIM(L_AQPA705AUXV3) || '</td></tr>' || 
           '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  TRIM(lc_fecope) || '</td></tr>' ||
           '<tr style="font-family:Calibri; font-size:14px"><td>Acción</td><td> </td><td>' || TRIM(L_AQPA705AUXV1) || '</td></tr>' ||
         '</table>';
         
         lv_correo := lv_mensaje;
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
         
         lv_mensaje :=
         '<br><br>' ||
         '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>' ||
         '<br>' ||
         '<span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>';
         
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    WHEN L_AQPA705TIPOPE = 'M' THEN -- Fpinto 02/02/2025 - Amortizacion de creditos
        lv_asunto     := 'ENVIO AUTOMATICO - CONFIRMACION DE AMORTIZACION DE CREDITO - ' || TRIM(lv_canal);
        lv_directorio := 'DTPUMP_PR_EMAIL_DIG'; --fpinto 21/05/2025 se corrige variable de directorio.
        lv_contacto   := PQ_CN_CAJAMOVIL.fn_ah_nombre_per(L_AQPA705PDOC, L_AQPA705TDOC, L_AQPA705NDOC);
        dbms_lob.createtemporary(ll_mensaje, TRUE);
        
        lv_mensaje := 
        '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">Caja Arequipa</div>'||
        '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE AMORTIZACION DE CREDITO, REDUCCION DE '||TRIM(L_AQPA705AUXV2)||' - ' || TRIM(lv_canal) || '</b>'||
        '<hr>' ||
        '<table>'||
        
        '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||
        '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de crédito</td><td> </td><td>' || TRIM(L_AQPA705CTADES) || '</td></tr>'||
        '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  TRIM(lc_fecope) || '</td></tr>' ||
        '<tr style="font-family:Calibri; font-size:14px"><td>Número de transacción</td><td> </td><td>' || TRIM(L_AQPA705AUXV3) || '</td></tr>' ||
        '<tr style="font-family:Calibri; font-size:14px"><td>Monto Amortizado</td><td> </td><td>'||TRIM(lv_monsim)||TRIM(TO_CHAR(L_AQPA705MONOPE, '9999,999.99'))||'</td></tr>' ||
        '<tr><td colspan="3">&nbsp;</td></tr>';
        lv_mensaje := lv_mensaje || '</table>';
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
        
        lv_mensaje := '<b style="font-family:Calibri; font-size:14px">NUEVA INFORMACION DE PAGO DE CREDITO</b><hr>'||
        '<table>'||
        '<tr style="font-family:Calibri; font-size:14px"><td>Producto</td><td> </td><td>' || TRIM(L_AQPA705AUXV4) || '</td></tr>' ||
        '<tr style="font-family:Calibri; font-size:14px"><td>'||SUBSTR(L_AQPA705AUXV5, 4, 16)||'</td><td> </td><td>'||SUBSTR(L_AQPA705AUXV5, 1, 2)||'</td></tr>' ||
        '<tr style="font-family:Calibri; font-size:14px"><td>'||SUBSTR(L_AQPA705AUXV6, 1, 21)||'</td><td> </td><td>'||SUBSTR(L_AQPA705AUXV6, 23, 10)||'</td></tr>' ||
        '<tr style="font-family:Calibri; font-size:14px"><td>Nuevo monto de cuota</td><td> </td><td>'||TRIM(lv_monsim)||TRIM(TO_CHAR(L_AQPA705AUXN1, '9999,999.99'))||'</td></tr>';
        lv_mensaje := lv_mensaje || '<tr><td colspan="3">&nbsp;</td></tr></table>';       
        lv_mensaje := lv_mensaje ||
        '<hr><span style="font-family:Calibri; font-size:12px">De cancelar la última cuota de su crédito y no tener otras obligaciones pendientes con Caja Arequipa, puedes descargar tu Certificado de No Adeudo en la sección "Ayuda" de la página principal. www.cajaarequipa.pe o directamente en: https://productos.cajaarequipa.pe/CNA/</span>';
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
        
        lv_mensaje :=
        '<br><br>' ||
        '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>'||
        '<br>' ||
        '<span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>';
        
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    Else
      null;
    End Case;
                                                           
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
                                               p_archivosadjuntos  => L_AQPA705ARCHIV,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
      exception
      when others then  
           p_c_coderr := '00x';
           p_c_deserr := sqlerrm;                                                   
      end;      
      dbms_lob.freetemporary(ll_mensaje);  
      
      IF L_AQPA705TIPOPE IN ('G', 'B', 'I', 'N') THEN
                PQ_CN_CAJAMOVIL.sp_guardar_log_envio(p_fectra => L_AQPA705FECTRA,
                                   p_hortra                   => L_AQPA705HORTRA ,
                                   p_nutar                    => L_AQPA705NUTAR,
                                   p_numdoc                   => L_AQPA705NDOC,
                                   p_destinatario             => lv_destinos,
                                   p_destinatarioscc          => '',
                                   p_destinatariosbcc         => '',
                                   p_mensaje                  => lv_correo,
                                   p_remitente                => lv_remitente,
                                   p_asunto                   => lv_asunto,
                                   p_c_coderr                 => p_c_coderr,
                                   p_c_deserr                 => p_c_deserr,
                                   p_canal                    => lv_canal
                                   );
      End If;   
                                   
  end sp_ah_envio_correo;
   procedure sp_consulta_creditos( P_N_ID IN NUMBER,                                   
                                   P_N_NUMCTA IN NUMBER,
                                   p_c_DESERR OUT VARCHAR2) is     
    
  
  begin
         
    Insert into AQPA710
    (AQPA710ID, AQPA710CORR, AQPA710NUMINS, AQPA710PEPAIS, AQPA710PETDOC, AQPA710PENDOC,
     AQPA710CODMOD, AQPA710CODTOP, AQPA710DESMOD, AQPA710CODUSU, AQPA710NOMAGE,
    AQPA710FECPAG, AQPA710CANCUO, AQPA710CODMDA, AQPA710CTACRE, AQPA710OPECRE, 
    AQPA710CUOMEN, AQPA710MONAPR, AQPA710PERIOD, AQPA710TASA, AQPA710TELCLI, AQPA710NOMCLI)
    
      select P_N_ID, rownum, x.N_NUMINS, x.N_CODPAI, x.N_TIPDOC, x.C_NUMDOC, 
             N_CODMOD, N_CODTOP, C_DESMOD, C_CODUSU, C_USUAGE,
             to_date(D_PRIPAG,'dd/mm/yyyy'), N_CANCUO, N_CODMDA, N_CTACLI, N_OPECTA,
             nvl(N_CUOMEN, 0) N_CUOMEN, N_MTOAPR, N_PERIOD, N_TASPRO, C_TELCLI,C_NOMCLI             
        from (select /*+ choose*/ row_number() over (partition by b.wfinsprcid order by b.wfinsprcid) orden,
               b.wfinsprcid n_numins,
               s.sng001pais n_codpai,
               s.sng001tdoc n_tipdoc,
               trim(s.sng001ndoc) c_numdoc, -- COMENTADO EL 30/09/2014
               c.xwfmodulo n_codmod,
               c.xwftipope n_codtop,
               trim(d.mdnom) c_desmod,
               trim(e.tonom) c_destop,
               trim(B.wfitemusrcod) c_codusu,
               (select trim(b1.scnom)
                  from fst046 a1, fst001 b1
                 where a1.ubsuc = b1.sucurs
                   and ubuser = B.wfitemusrcod) c_usuage,
               trim(b.wftaskcod) c_codest,
               decode(b.wftaskcod,
                      '3',
                      'Solicitud',
                      '7',
                      'Evaluacion Propuesta',
                      '11',
                      'Aprobacion',
                      '55',
                      'Desembolso') c_desest,
               trim(b.wfstscod) c_codtar,
               /*decode(b.wfstscod,
                      'A',
                      'Asignada',
                      'P',
                      'Pendiente',
                      'R',
                      'En Proceso',
                      'T',
                      '????')*/ '' c_destar,
               --to_char(b.wfiteminit, 'DD/MM/YYYY HH:MI:SS AM') d_fecins,               
               c.xwfmoneda n_codmda,               
               c.xwfmonto1 N_MTOAPR,
               c.xwfplazo1 n_placre,
               c.xwfcuenta n_ctacli,
               c.xwfoperacion n_opecta,
               round((trunc(sysdate) - wfiteminit)) n_tiempo,
               case
                 when length(trim(s.sng001ndoc)) = 8 then
                  (select trim(pfape1) || ' ' || trim(pfape2) || ' ' ||
                          trim(pfnom1) || ' ' || trim(pfnom2)
                     from fsd002
                    where pfndoc = s.sng001ndoc)
                 when length(trim(s.sng001ndoc)) = 11 then
                  (select pjrazs from fsd003 where pjndoc = s.sng001ndoc)
               end c_nomcli,
               --
               (select xlltasap
                  from x054023
                 where xllaocta = c.xwfcuenta
                   and xllaooper = c.xwfoperacion
                   and rownum <= 1
                --order by xllaocta, xllaooper, xllaosbop desc
                ) n_taspro,                
                    (
                     select to_char( min(ppfpag), 'dd/mm/yyyy')
                                 from fsd601
                                where ppcta = c.xwfcuenta
                                  and ppoper = c.xwfoperacion      
                                  and ppint > 0 
                                   )                        
                    d_pripag,
               (select xllcantcuo
                  from x054023
                 where xllaocta = c.xwfcuenta
                   and xllaooper = c.xwfoperacion
                   and rownum <= 1) n_cancuo,
               (select xllperiodo
                  from x054023
                 where xllaocta = c.xwfcuenta
                   and xllaooper = c.xwfoperacion
                   and rownum <= 1) n_period,
               (select g.ppcap + g.ppint + nvl((select ppimp11 + ppimp12 + ppimp13 + ppimp14 + ppimp15
                                                 from fsd611 a
                                                where ppcta = g.ppcta
                                                  and ppoper = g.ppoper
                                                  and a.ppfpag = g.ppfpag),
                                               0)
                  from fsd601 g
                 where g.ppcta = c.xwfcuenta
                   and g.ppoper = c.xwfoperacion
                   and g.ppsbop = (select max(ppsbop)
                                     from fsd601
                                    where ppcta = c.xwfcuenta
                                      and ppoper = c.xwfoperacion)
                   and ppint>0
                   and rownum <= 1) n_cuomen,
              '' c_tipcuo,
              '' c_dircli,
              '' c_telcli,
              '' c_ultapr
                from sng001     s,
                     wfwrkitems b,
                     xwf700     c,
                     fst003     d,
                     fst004     e,
                     fsd601     f
               where s.sng001inst = b.wfinsprcid
                 --and a.sng001inst = p_n_numins
                 /*and s.sng001pais = P_N_CODPAI
                 and s.sng001tdoc = P_N_TIPDOC
                 and s.sng001ndoc = rpad(trim(P_C_NUMDOC),'12',' ')*/
                 and s.sng001cta  = P_N_NUMCTA
                 and b.wfinsprcid = c.xwfprcins
                 and s.sng001inst = c.xwfprcins
                 and d.modulo = c.xwfmodulo
                 and d.modulo = e.modulo
                 and e.totope = c.xwftipope                                  
                 and s.sng001pais = 604
                 and c.xwfcar3 = '1'
                 and b.wftaskcod in ('55')
                 and b.wfitemstsact=1                 
                    ---
                 and f.pgcod = c.xwfempresa
                 and f.ppmod = c.xwfmodulo
                 and f.ppsuc = c.xwfsucursal
                 and f.ppmda = c.xwfmoneda
                 and f.pppap = c.xwfpapel
                 and f.ppcta = c.xwfcuenta
                 and f.ppoper = c.xwfoperacion
                 and f.ppsbop = c.xwfsubope
                 and f.pptope = c.xwftipope
                    --
                 and f.ppsbop = (select max(ppsbop)
                                   from fsd601
                                  where ppcta = c.xwfcuenta
                                    and ppoper = c.xwfoperacion)
               /*order by d_fecins desc*/) x
       /*inner join fst198 y on y.tp1cod=1 and y.tp1cod1=10801 and y.tp1corr1=65 and y.tp1corr2= x.N_CODMOD and y.tp1corr3=x.N_CODTOP
       where N_MTOAPR <= (case when x.N_CODMDA = 0 then y.tp1imp1 else y.tp1imp2 end)
       and (select count(1) from jaqm750 a, jaqz697 b where 
            a.jaqm750pai=b.jaqz697pai
            and a.jaqm750tdo=b.jaqz697tdo
            and a.jaqm750ndo = b.jaqz697ndo
            and a.jaqm750fch>=b.jaqz697fep
            and a.jaqm750imp=b.jaqz697mto
            and b.jaqz697au5='S'
            and a.jaqm750mod=b.jaqz697mod
            and a.jaqm750tip=b.jaqz697top
            and a.jaqm750suc=b.jaqz697suc
            and a.jaqm750mda=b.jaqz697mda
            --and nvl(b.jaqz697apr,'R') ='R'
            and (nvl(b.jaqz697apr,'R') ='R' or nvl(b.jaqz697apr,'N') ='N') --Se agrega filtro para no mostrar los de estado=N
            and b.jaqz697fep = (select max(jaqz697fep) from jaqz697 )
            and b.jaqz697tca = 'P'
            and a.jaqm750ins=x.N_NUMINS
            and a.jaqm750emp = 1) = 0*/
       where x.orden=1       
       ;
       
       
       commit;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      p_c_deserr := sqlerrm;  
  end sp_consulta_creditos;
                                     
  Function fn_ah_nombre_per(P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2              
                           ) return varchar2 is
  lv_contacto varchar2(110);
  begin    
    Select trim(a.pfnom1)||' '/*||trim(a.pfnom2)||' '*/||trim(a.pfape1)||' '||trim(a.pfape2)
      into lv_contacto 
      from fsd002 a 
     where a.pfpais = P_N_CODPAI
       and a.pftdoc = P_N_TIPDOC
       and a.pfndoc = rpad(P_C_NUMDOC,12,' ');
       return lv_contacto;                                       
  Exception 
  When no_data_found then
    begin    
      Select trim(a.pjrazs)
        into lv_contacto 
        from fsd003 a 
       where a.pjpais = P_N_CODPAI
         and a.pjtdoc = P_N_TIPDOC
         and a.pjndoc = rpad(P_C_NUMDOC,12,' ');
         return lv_contacto;                                       
    Exception 
    When others then
       return lv_contacto;
    end;   
  when others then
      return lv_contacto;
  end fn_ah_nombre_per;   
    
Procedure sp_crear_cuenta_cliente (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_N_CUENTA OUT NUMBER ) is
  cursor c1 is
  --HLAQUI 26/06/2017 - Se agrega logica para que las cuentas se creen tomando la direccion del cliente de la SNGC13
  select b.*, d.segcod, e.* 
  from FSD002 b 
  left outer join FSE002 c on b.pfpais = c.pfxpais and b.pftdoc = c.pfxtdoc and  b.pfndoc = c.pfxndoc
  left outer join SNGC07 d on d.SNGC07cod = c.ocucod
  left outer join sngc13 e on e.sngc13pais=b.pfpais and e.sngc13tdoc=b.pftdoc and e.sngc13ndoc= b.pfndoc  and e.docod= 1 and e.sngc13est='H' and e.sngc13pais <>0  
  where b.pfpais=P_N_CODPAI and b.pftdoc=P_N_TIPDOC and rpad(trim(P_C_NUMDOC),12,' ') = b.pfndoc;

   
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ld_fecha         date;
  lc_nomcli  varchar2(400);

begin
   --Se obtiene la fecha del sistema   
      select pgfape into ld_fecha from fst017 where pgcod = 1;        

      --Se eliminan los registros de las bandejas.
      begin        
        
        DELETE FROM bandejas.bjd008;
        DELETE FROM bandejas.bjr008;
        DELETE FROM bandejas.bjx008;      
        DELETE FROM bandejas.bje108; 

        DELETE FROM bandejas.bjd006;
        DELETE FROM bandejas.bjr006;
        DELETE FROM bandejas.bngc13;
        
        commit;
      exception
        when others then
          lc_error := sqlerrm;         
      End;
      
      --Se verifica si el documento ya tiene una cuenta cliente
      select max(c.ctnro) into ln_cuenta 
      from fsr008 c 
      where c.pendoc = rpad(trim(P_C_NUMDOC),12,' ')
      and c.pepais = P_N_CODPAI
      and c.petdoc = P_N_TIPDOC          
      and c.cttfir = 'T'      
      and (select count(1) 
           from fsr008 d 
           where d.ctnro = c.ctnro) = 1; 
           
      If  ln_cuenta is null then --Si no tiene cuenta cliente    
       ln_cuenta := 0;
       --Se obtiene el Nro de Cuenta - El siguiente Valor
       begin --BNJTI1
          select ngnum + 1 into ln_cuenta 
          from fsn999 
          where pgcod=1 and ngsuc=11 and ngtipo=3;
            
          update fsn999
          set ngnum = ngnum + 1
          where pgcod=1 and ngsuc=11 and ngtipo=3;
          
         
        exception
          when others then
              lc_error := sqlerrm;             
        end;
        
      --Se recorre la tabla JAQZ311 cuto estado sea 0         
      for i in c1 loop         
        If i.pfape1 is null then
           lc_nomcli := trim(i.pfnom1);
        Else
           lc_nomcli := trim(i.pfape1) || ' ' || trim(i.pfape2) || ', ' || trim(i.pfnom1) || ' ' || trim(i.pfnom2);
        End if;
                                                                                                   
          begin --BJD008
           insert /*+ append */ into bandejas.BJD008
            (BD008ECod,
             BD008NCta,
             BD008CNom,
             BD008Resi,
             BD008CCla, 
             BD008FAlt,
             BD008RCor,
             BD008SCod,
             BD008IFin,
             BD008Empl,
             BD008Prov,
             BD008SegM,
             BE008Suc,
             BE008FvClf,
             BD008Est,
             BD008Ctnro)
          values
            (1,
             ln_cuenta,           
             substr(lc_nomcli,1,35),
             'S', --Residencia Se cambia de N a S
             1, --no es obligatorio, y es un GAP
             ld_fecha,
             'S',
             1,
             'N',
             'N',
             'N',
             nvl(i.segcod, 3),--Se obtiene el segmento, si no se coloca el segmento Otros
             904,
             ADD_MONTHS(ld_fecha, 120),--DLYA asigna en programa de carga una fecha valida.
             'P',
             99
             );                          
            
          exception          
             when others then
              lc_error := sqlerrm;              
          end;
                          
          begin --BJD006
            insert /*+ append */ into bandejas.BJD006
              (BD006ECod,
               BD006NCta,
               BD006DCod,
               BD006Call,
               BD006Nro,
               BD006Apar,
               BD006Ciud, -- codigo de localidad
               BD006Pais,
               BD006CPos,
               BD006CCor,
               BD006Sucu,
               BD006CDep, -- coidgo de departamento
               BD006Dept,
               BD006Est,
               BD006Ref1,
               BD006Ref2,
               BD006APo,
               BD006Upo)
            values
              (1,
               ln_cuenta,
               1, --Tipo de domicilio: LEGAL
               '',
               '',
               '',
               i.sngc13prov, --lc_desdis,
               i.sngc13pais,
               null,
               null,
               null,
               i.sngc13dpto,
               null,
               'P',
               substr(i.sngc13dir,1,35),
               null,
               null,
               null);
               
          exception
            when others then
            lc_error := sqlerrm;            
          end;

         begin --BNGC13                
          insert into BANDEJAS.BNGC13
          (BNGC13PAIS, --1
           BNGC13TDOC, --2
           BNGC13NDOC, --3
           DOCOD,       --4 
           BNGC13CORR, --5
           BNGC13PDOC, --6
           BNGC12VIVC, --7
           BNGC01ID, --8
           BNGC02ID, --9
           BNGC03ID, --10
           BNGC04ID, --11
           BNGC05ID, --12
           BNGC06ID, --13
           BNGC13DSC1, --14
           BNGC13DSC2, --15
           BNGC13DSC3, --16
           BNGC13DSC4, --17
           BNGC13DSC5, --18
           BNGC13DSC6, --19
           BNGC13UGEO, --20
           BNGC13DPTO, --21
           BNGC13PROV, --22
           BNGC13DIST, --23
           BNGC13CNEG, --24
           BNGC13REF, --25
           BNGC13REF1, --26
           BNGC13DIR, --27
           BNGC13RDES, --28
           BNGC13ARR, --29
           BNGC13ATEL,--30
           BNGC13FHAB,--31
           BNGC13DEST,--32
           BNGC13EST,--33
           BNGC13FDIR,--34
           BNGC13USER,--35
           BNGC13MEST)--36
        values
          (0, --1
           0, --2
           ln_cuenta,  --3
           i.docod,  --4
           i.sngc13corr, --5
           i.sngc13pais, --HLAQUI PAIS i.sngc13pdoc, -- pais de direccion6
           i.sngc12vivc, -- codigo tipo de vivienda 7
           i.sngc01id, -- codigo tipo de via   8
           i.sngc02id, -- codigo via          9        
           i.sngc03id, -- codigo detalle de via10
           i.sngc04id,--0,11
           i.sngc05id,--0,12
           i.sngc06id,--0,  13             
           substr(i.sngc13dsc1,1,30), -- descripcion de via  14
           substr(i.sngc13dsc2,1,30), --15
           substr(i.sngc13dsc3,1,30), --16
           substr(i.sngc13dsc4,1,30), --17
           substr(i.sngc13dsc5,1,30), --18
           substr(i.sngc13dsc6,1,30), --19
           i.sngc13ugeo, --20 - Ubigeo
           i.sngc13dpto, --21  - Departamento
           i.sngc13prov, --22  - Provincia
           i.sngc13dist, --23  - Distrito
           i.sngc13cneg, --24
           i.sngc13ref, --25
           i.sngc13ref1, -- referencia26
           i.sngc13dir,--null, --27
           i.sngc13rdes ,--null, --28
           null, --29
           null, --30
           null, --31
           i.sngc13dest, --32
           i.sngc13est, --33
           null, --34
           null, --35
           'P'--36
           ); 
        exception
          when others then                
          lc_error := sqlerrm;                
        end;  
          
        begin --BJE108
           insert into bandejas.BJE108
            (BE108Cod,
             BE108Cta,
             BE108Fch,
             BE108Hora,
             BE108Usu,
             BE108Wrk,
             BE108Hab,
             BE108Est)
           values
            (1,
             ln_cuenta,
             ld_fecha,--to_date(to_char(i."Fch",'dd/mm/rrrr'),'dd/mm/rrrr'),
             TO_CHAR(sysdate, 'HH:MI:SS'),--to_char(i."Hora",'hh24:mi:ss'),
             'BANTOTAL',
             null,
             'S',
             'P'); 
        exception
          when others then
          lc_error := sqlerrm;           
        end;
          
        begin --BJR008
            insert into bandejas.BJR008
              (BR008ECod,
               BR008NCta,
               BR008Pais,
               BR008TDoc,
               BR008NDoc,
               BR008TCod,
               BR008TFir,
               BR008Est)
            values
              (1,
               ln_cuenta,
               i.pfpais,
               i.pftdoc,
               i.pfndoc,
               1,--1,
               'T',
               'P'); 
        exception
          when others then
          lc_error := sqlerrm;            
        end;                    
                  
      End Loop;  
              
      commit; 
      
      -- Generamos el registro de las cuentas en BANTOTAL
      begin
        bandejas.mig_cuentas_datos(1000);
        bandejas.mig_cuentas_domicilios(1000);
      end; 
    
    End If;  
    P_N_CUENTA := ln_cuenta;
      
end sp_crear_cuenta_cliente;
/*Hlaqui - Ampliacion montos desembolso  - Verifica Desgravamen*/
Procedure sp_valida_desgravamen (P_N_INSTANCIA IN NUMBER,                         
                                 P_C_APLICA OUT VARCHAR2 ) is
begin
    P_C_APLICA :='N';       
    begin            
        select 'S' into P_C_APLICA from fpp001 f , xwf700 x
        where f.sgcod in (select s.sgcod from fst300 s where s.sgsn02 = 5) 
        and f.pgcod = x.xwfempresa and f.aomod = x.xwfmodulo and f.aosuc = x.xwfsucursal and f.aomda = x.xwfmoneda
        and f.aopap = x.xwfpapel and f.aocta = x.xwfcuenta and f.aooper = x.xwfoperacion and f.aosbop = x.xwfsubope and f.aotope = x.xwftipope
        and x.xwfcar3 = '1' and x.xwfprcins = P_N_INSTANCIA;
 
    exception
          when others then
          P_C_APLICA :='N';       
     end;    

end sp_valida_desgravamen;
/*Hlaqui 16/02/2021 - Control para creditos con DPF*/
Procedure sp_contar_creditos (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_N_CANTIDAD OUT NUMBER ) is
begin
   
    
    select count(1) into P_N_CANTIDAD
    from fsd011 f ,fsr008 g, xwf700 h
    where f.sccta = g.ctnro 
    and f.pgcod =1
    and f.scmod in (select modulo from fst111 where dscod = 50)
    and substr(f.scrub,1,4) in ('1411','1421','1414','1424','1415','1425','1416','1426')
    and f.scmod not in (33,108)
    and g.pgcod=1
    and g.ttcod = 1
    and g.cttfir = 'T'
    and g.pepais = P_N_CODPAI
    and g.petdoc = P_N_TIPDOC
    and g.pendoc = rpad(trim(P_C_NUMDOC), '12', ' ')
    and f.scsdo <> 0
    and h.xwfcuenta = f.sccta
    and h.xwfoperacion = f.scoper
    and h.xwfempresa = f.pgcod
    and h.XWfSucursal = f.scsuc
    and h.XWfModulo = f.scmod
    and h.XWfMoneda = f.scmda
    and h.XWfPapel = f.scpap
    and h.XWfSubope = f.scsbop
    and h.XWfTipOpe = f.sctope
    and h.XWFCar3='1'
    and (select count(1) from sng122 where sng122inst=h.xwfprcins and sng122mod=70 and sng122tope=80) = 0 ;                  
    
end sp_contar_creditos;

Procedure sp_analista_vigente (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_C_ASESOR OUT VARCHAR2,
                            P_N_AGENCIA OUT NUMBER ) is
begin
    P_C_ASESOR :='';   
    P_N_AGENCIA := 0;
    begin    
        select fn_analista_credito(x.scmod,x.scsuc,x.scmda,x.scpap, x.sccta,x.scoper, x.scsbop, x.sctope) into P_C_ASESOR
        from (
              select f.scmod,f.scsuc,f.scmda,f.scpap, f.sccta,f.scoper, f.scsbop, f.sctope, 
                     row_number() over(partition by f.scoper order by f.scoper desc) orden        
              from fsd011 f ,fsr008 g
              where f.sccta = g.ctnro 
              and f.pgcod =1
              and f.scmod in (select modulo from fst111 where dscod = 50)
              and substr(f.scrub,1,4) in ('1411','1421','1414','1424','1415','1425','1416','1426')
              and f.scmod not in (33,108)
              and g.pgcod=1
              and g.ttcod = 1
              and g.cttfir = 'T'
              and g.pepais = P_N_CODPAI
              and g.petdoc = P_N_TIPDOC
              and g.pendoc = rpad(trim(P_C_NUMDOC), '12', ' ')
              and f.scsdo <> 0 )  x 
        where x.orden = 1;
        
        select ubsuc into P_N_AGENCIA from fst046 where ubuser=rpad(trim(P_C_ASESOR), '10', ' ');
 
    exception
          when others then
          P_C_ASESOR:='';
          P_N_AGENCIA := 0;  
     end;    

end sp_analista_vigente;

  Procedure sp_enviar_correo_gerente
                             is                                             
    cursor c1 is 

    select x.cuenta, x.operacion, x.asesor, x.fecha, x.monto, x.cuota, x.agenciadpf, x.correlativo
    from (
    select a.xwfcuenta cuenta,a.xwfoperacion operacion, c.sng001ase asesor,b.aofval fecha,
           b.aoimp monto, c.sng01icuot cuota, to_number(d.AQPA705AUXV4) agenciadpf, d.aqpa705corr correlativo   from xwf700 a
    inner join fsd010 b on b.pgcod=1 and b.aomod=a.xwfmodulo and b.aosuc=a.xwfsucursal 
                        and b.aomda = a.xwfmoneda and b.aopap = a.xwfpapel 
                        and b.aocta = a.xwfcuenta and b.aooper= a.xwfoperacion 
                        and b.aosbop = a.xwfsubope and b.aotope = a.xwftipope
    inner join sng001 c on c.sng001inst = a.xwfprcins and a.xwfcar3=1 
    inner join aqpa705 d on aqpa705tipOpe = 'P' and d.aqpa705auxn2=xwfprcins and aqpa705auxv5='N' 
    --DESCOMENTAR EN PRODUCCION
    Where c.sng001ase = (select rpad(trim(tp1desc), '10', ' ') from fst198 where tp1cod1=10801 and tp1corr1=74  and tp1corr2=1 and tp1corr3=1) 
    ) x;


    cursor c2 ( age NUMBER) is
    select lower(trim(ubuser)) || '@cajaarequipa.pe' correo from PRFU00 where ubuser in (select ubuser from fst046 where ubsuc=age) and PRFGCOD='GAGE01';
        
    
               
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(30);  
    lv_asunto     VARCHAR2(90);  
    lv_directorio VARCHAR2(30);  

    lv_contacto   VARCHAR2(110);  
    lv_destinos   VARCHAR2(32767):='';    
    ln_cont NUMBER(10);  
  
    p_c_coderr VARCHAR2(200);
    p_c_deserr VARCHAR2(200);   

  begin
    
    
    lv_remitente := 'cajamovil@cajaarequipa.pe';    
    
     for i in c1  loop 
       
         lv_asunto    := 'ALERTA DESEMBOLSO CREDITO CON DPF';
         lv_directorio:= '';                 
                       
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">ALERTA DESEMBOLSO CREDITO CON DPF</b>'||           
         '<br>'||                                
         '<hr><span style="font-family:Calibri; font-size:14px">Sr. Gerente de Agencia</span>'||
         '<br>'||               
         '<span style="font-family:Calibri; font-size:14px">Se ha generado un crédito con garantía DPF por el APP (Cuenta cliente: <strong>'|| to_char(i.cuenta) ||'</strong> y Número de Operacion: <strong>' || to_char(i.operacion) ||'</strong> ), agradeceremos asigne a un Analista de su Agencia para dicho crédito, considerando:</span>'||
         '<br>'||
         '<span style="font-family:Calibri; font-size:14px">1. Analista haya logrado sus metas el mes pasado.</span>'||
         '<br>'||
         '<span style="font-family:Calibri; font-size:14px">2. Analista no haya tenido ninguna sanción el mes pasado.</span>'||
         '<br>'||
         '<span style="font-family:Calibri; font-size:14px"><strong>Nota: También puede generar el reporte de Desembolsos con garantía DPF por APP en la ruta del Bantotal <br/><br/>Caja Arequipa</strong></p></span>'||
         '<br>'||
         '<br>';       
         
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                                            
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
         
         ln_cont := 1;
         for j in c2( i.agenciadpf)  loop               
              if ln_cont = 1 then
                 lv_destinos := j.correo;
              else
                 lv_destinos := lv_destinos ||';' || j.correo;
              end if;                                 
              ln_cont := ln_cont + 1;
         End Loop;         
         --lv_destinos := 'hlaqui@cajaarequipa.pe'; --BORRAR EN PRODUCCION
         
         begin
              -- Call the procedure
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                               p_destinatarioscc   => '',
                                               p_destinatariosbcc  => '',
                                               p_mensaje           => ll_mensaje,
                                               p_remitente         => lv_remitente,
                                               p_asunto            => lv_asunto,
                                               p_tipomensaje       => 'HTML',
                                               p_directorio        => '',
                                               p_archivosadjuntos  => '',
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                                                                     );
              Update aqpa705 set  aqpa705auxv5='S'  where aqpa705corr = i.correlativo;
              commit;
        exception
        when others then  
             p_c_coderr := '00x';
             p_c_deserr := sqlerrm;                                                   
        end;      
        dbms_lob.freetemporary(ll_mensaje);    
                   
     End Loop;
                                                                         
                                   
  end sp_enviar_correo_gerente; 
  Procedure sp_credito_aval_mora (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_C_CREMORA OUT VARCHAR2,
                            P_C_AVALMORA OUT VARCHAR2,
                            P_N_INSTANCIA OUT NUMBER) is
    cursor c1
    is
    select h.xwfprcins
    from fsd011 f ,fsr008 g, xwf700 h
    where f.sccta = g.ctnro 
    and f.pgcod =1
    and f.scmod in (select modulo from fst111 where dscod = 50)
    and substr(f.scrub,1,4) in ('1411','1421','1414','1424','1415','1425','1416','1426')
    and f.scmod not in (33,108)
    and g.pgcod=1
    and g.ttcod = 1
    and g.cttfir = 'T'
    and g.pepais = P_N_CODPAI
    and g.petdoc = P_N_TIPDOC
    and g.pendoc = rpad(trim(P_C_NUMDOC), '12', ' ')
    and f.scsdo <> 0
    and h.xwfcuenta = f.sccta
    and h.xwfoperacion = f.scoper
    and h.xwfempresa = f.pgcod
    and h.XWfSucursal = f.scsuc
    and h.XWfModulo = f.scmod
    and h.XWfMoneda = f.scmda
    and h.XWfPapel = f.scpap
    and h.XWfSubope = f.scsbop
    and h.XWfTipOpe = f.sctope
    and h.XWFCar3='1'
    and (select count(1) from sng122 where sng122inst=h.xwfprcins and sng122mod=70 and sng122tope=80) = 0 ;  
    
    ld_fecha date;    
  begin
   
   select pgfape into ld_fecha from fst017 where pgcod=1;
  
   for j in c1  loop 
       P_N_INSTANCIA:= j.xwfprcins;
       pq_cr_cred_procesos.sp_creditomoroso(vd_pgfape => ld_fecha,
                                       vn_instancia => j.xwfprcins,
                                       vc_gccredmor => P_C_CREMORA,
                                       vc_gccredmora => P_C_AVALMORA); 
       If   P_C_CREMORA = 'S' or P_C_AVALMORA = 'S' then 
         exit;
       End If;
   End Loop;    
                           
end sp_credito_aval_mora; 
Procedure sp_monto_consolidado (P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,                           
                            P_N_MONTO OUT NUMBER,
                            P_N_MONMAX OUT NUMBER) is   
    
    ld_fecha date; 
    ln_tipcam number(14,8);
    ln_instancia number(10):=0;
    --Monto maximos permitidos
    ln_maxsol number(10,2):= 300000; --Maxima deuda consolidada Soles
    ln_maxdol number(10,2):= 81000;  -- Maxima deuda consilidad Dolares por Examen Médico
    
  begin
   
   select pgfape into ld_fecha from fst017 where pgcod=1;
   select fn_tipo_cambio_fijo(ld_fecha) into ln_tipcam from dual;
   
   pq_cr_resolutor_autonomia.sp_cuentas(ln_pepais => P_N_CODPAI,
                                       ln_petdoc => P_N_TIPDOC,
                                       ln_pendoc => P_C_NUMDOC,
                                       tipocambio => ln_tipcam,
                                       instancia => ln_instancia,
                                       pd_fecpro => ld_fecha,
                                       ln_captotcaja => P_N_MONTO);
                                       
    
   ln_maxdol := ln_maxdol * ln_tipcam; --Convertimos todo a Soles
   --Retornamos el monto maximo permitido (Menor)
   If ln_maxsol > ln_maxdol then
      P_N_MONMAX := ln_maxdol;
   Else
      P_N_MONMAX := ln_maxsol;
   End If;
   
                                                                
end sp_monto_consolidado; 

Procedure sp_calcular_itf (P_N_MONTO IN NUMBER,
                           P_N_ITF OUT NUMBER) is
   begin      
     select pq_ah_compensa_ctas.fn_calcula_itf(P_N_MONTO) into P_N_ITF from dual;
                         
end sp_calcular_itf;

procedure sp_ah_envio_voucher_digital(P_N_Drsuc  IN NUMBER,
                                        P_N_Drmod  IN NUMBER,
                                        P_N_Drtrn  IN NUMBER,
                                        P_N_Drrel  IN NUMBER,
                                        P_D_FECOPE IN DATE,
                                        P_C_CORREO IN VARCHAR2,
                                        P_C_NUMCTA IN VARCHAR2,
                                        P_C_TONOM  IN VARCHAR2,
                                        P_C_DESMDA IN VARCHAR2,
                                        P_C_MOSIGN IN VARCHAR2,
                                        P_N_IMPDEB IN NUMBER,
                                        P_N_TIPCAM IN NUMBER,
                                        P_N_CODPAI IN NUMBER,
                                        P_N_TIPDOC IN NUMBER,
                                        P_C_NUMDOC IN VARCHAR2,
                                        p_c_coderr OUT VARCHAR2,
                                        p_c_deserr OUT VARCHAR2) is
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    lv_remitente  VARCHAR2(50);
    lv_asunto     VARCHAR2(90);
    lv_directorio VARCHAR2(30);
    lv_archivos   VARCHAR2(32767);
    lv_contacto   VARCHAR2(110);
    lv_destinos   VARCHAR2(32767) := '';
    lv_canal      VARCHAR2(50);
    --
  
  begin
    p_c_coderr  := '000';
    p_c_deserr  := '';
    lv_destinos := P_C_CORREO;
    lv_archivos := '';
  
    lv_canal     := 'CAJERO ATM';
    lv_remitente := 'cajeroautomatico@cajaarequipa.pe';
  
    --
    lv_asunto := 'Caja Arequipa - Cajeros Automaticos';
    --lv_directorio := 'DTPUMP_PR_EMAIL_DIG';
    lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(P_N_CODPAI,
                                                    P_N_TIPDOC,
                                                    P_C_NUMDOC);
    dbms_lob.createtemporary(ll_mensaje, TRUE);
  
    lv_mensaje := '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>' ||
                  '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE ' ||
                  trim('DEPOSITO') || ' - ' || trim(lv_canal) || /*CAJA MOVIL */
                  '</b>' || '<hr>' || '<table>' ||
                 
                  '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' ||
                  lv_contacto || '</td></tr>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de tarjeta</td><td> </td><td>' ||
                  '426153******' || substr('426153', 13) || '</td></tr> ' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de cuenta</td><td> </td><td>' ||
                  trim(P_C_NUMCTA) || '</td></tr> ' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Producto</td><td> </td><td>' ||
                  trim(P_C_TONOM) || '</td></tr>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||
                  to_char(P_D_FECOPE, 'DD/MM/YYYY') || ' ' ||
                  to_char(sysdate, 'HH24:MI:ss') || '</td></tr>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Monto</td><td> </td><td>' ||
                  trim(P_C_MOSIGN) || ' ' ||
                  to_char(P_N_IMPDEB, '999,999,999.00') || '</td></tr>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td>Numero de Operacion</td><td> </td><td>' ||
                  trim(lpad(to_char(P_N_Drsuc), 3, '0')) ||
                  trim(lpad(to_char(P_N_Drmod), 3, '0')) ||
                  trim(lpad(to_char(P_N_Drtrn), 3, '0')) ||
                  trim(lpad(to_char(P_N_Drrel), 4, '0')) || '</td></tr>' ||
                  '<tr style="font-family:Calibri; font-size:14px"><td></td><td> </td><td></td></tr> ';
  
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    lv_mensaje := '<hr><span style="font-family:Calibri; font-size:12px">Le recordamos que usted puede realizar la afiliación/desafiliación de sus cuentas a su tarjeta de débito en cualquier momento y con total seguridad ingresando nuestra clave Token. Así mismo podrá cambiar los límites máximos horarios de retiro por canales alternativos a través de nuestra App o Web.</span>' ||
                  '<br><br>' ||
                  '<span style="font-family:Calibri; font-size:12px">Cordialmente</span>' ||
                  '<br>' ||
                  '<span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>';
  
    /*'<hr>'||
    '<br>'||
    '<span style="font-family:Calibri; font-size:12px">El sistema de correo electrónico de la Caja Arequipa está destinado únicamente para fines del negocio, cualquier otro uso contraviene las políticas de la Caja.</span>'||
    '<br>'||                
    '<span style="font-family:Calibri; font-size:12px">Toda la información del negocio contenida en este mensaje es confidencial y de uso exclusivo de la Caja Arequipa. Su divulgación, copia y/o adulteración están prohibidas y sólo debe ser conocida por la persona a quien se dirige este mensaje.</span>'||
    '<br>'||
    '<span style="font-family:Calibri; font-size:12px">Si Ud. ha recibido este mensaje por error por favor proceda a eliminarlo y notificar al remitente.</span>'||
    '<br>'||
    '<br>'*/
  
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
                                       p_archivosadjuntos  => lv_archivos,
                                       p_c_coderr          => p_c_coderr,
                                       p_c_deserr          => p_c_deserr);
    exception
      when others then
        p_c_coderr := '00x';
        p_c_deserr := sqlerrm;
    end;
    dbms_lob.freetemporary(ll_mensaje);
  exception
    when others then
      p_c_coderr := '00x';
      p_c_deserr := sqlerrm;
  end sp_ah_envio_voucher_digital;

  Procedure sp_enviar_correo_sueldo
                             is                                             
    cursor c1 is 

    select x.cuenta, x.operacion, x.asesor, x.fecha, x.monto, x.cuota, x.agenciadpf, x.correlativo
    from (
    select a.xwfcuenta cuenta,a.xwfoperacion operacion, c.sng001ase asesor,b.aofval fecha,
           b.aoimp monto, c.sng01icuot cuota, to_number(d.AQPA705AUXV4) agenciadpf, d.aqpa705corr correlativo   from xwf700 a
    inner join fsd010 b on b.pgcod=1 and b.aomod=a.xwfmodulo and b.aosuc=a.xwfsucursal 
                        and b.aomda = a.xwfmoneda and b.aopap = a.xwfpapel 
                        and b.aocta = a.xwfcuenta and b.aooper= a.xwfoperacion 
                        and b.aosbop = a.xwfsubope and b.aotope = a.xwftipope
    inner join sng001 c on c.sng001inst = a.xwfprcins and a.xwfcar3=1 
    inner join aqpa705 d on aqpa705tipOpe = 'S' and d.aqpa705auxn2=xwfprcins and aqpa705auxv5='N' 
    --DESCOMENTAR EN PRODUCCION
    Where c.sng001ase = (select rpad(trim(tp1desc), '10', ' ') from fst198 where tp1cod1=11147 and tp1corr1=2  and tp1corr2=1 and tp1corr3=1) 
    ) x;


    cursor c2 ( age NUMBER) is
    select lower(trim(ubuser)) || '@cajaarequipa.pe' correo from PRFU00 where ubuser in (select ubuser from fst046 where ubsuc=age) and PRFGCOD='GAGE01';
        
    
               
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(30);  
    lv_asunto     VARCHAR2(90);  
    lv_directorio VARCHAR2(30);  

    lv_contacto   VARCHAR2(110);  
    lv_destinos   VARCHAR2(32767):='';    
    ln_cont NUMBER(10);  
	  
  
    p_c_coderr VARCHAR2(200);
    p_c_deserr VARCHAR2(200);   

  begin
    
    
    lv_remitente := 'cajamovil@cajaarequipa.pe';    
    
     for i in c1  loop 
       
         lv_asunto    := 'ALERTA DESEMBOLSO PRESTAMO CUENTA SUELDO';
         lv_directorio:= '';                 
                       
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := 
         '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
               Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">ALERTA DESEMBOLSO PRESTAMO CUENTA SUELDO</b>'||           
         '<br>'||                                
         '<hr><span style="font-family:Calibri; font-size:14px">Sr. Gerente de Agencia</span>'||
         '<br>'||               
         '<span style="font-family:Calibri; font-size:14px">Se ha generado un Prestamo Cuenta Sueldo por el APP (Cuenta cliente: <strong>'|| to_char(i.cuenta) ||'</strong> y Número de Operacion: <strong>' || to_char(i.operacion) ||'</strong> ), agradeceremos asigne a un Analista de su Agencia para dicho crédito.</span>'||
         '<br>'||         
         '<span style="font-family:Calibri; font-size:14px"><strong>Nota: También puede generar el reporte de Prestamo Cuenta Sueldo por APP en la ruta del Bantotal <br/><br/>Caja Arequipa</strong></p></span>'||
         '<br>'||
         '<br>';       
         
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                                            
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
         
         ln_cont := 1;
         for j in c2( i.agenciadpf)  loop               
              if ln_cont = 1 then
                 lv_destinos := j.correo;
              else
                 lv_destinos := lv_destinos ||';' || j.correo;
              end if;                                 
              ln_cont := ln_cont + 1;
         End Loop;         
         --lv_destinos := 'hlaqui@cajaarequipa.pe'; --BORRAR EN PRODUCCION
         
         begin
              -- Call the procedure
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                               p_destinatarioscc   => '',
                                               p_destinatariosbcc  => '',
                                               p_mensaje           => ll_mensaje,
                                               p_remitente         => lv_remitente,
                                               p_asunto            => lv_asunto,
                                               p_tipomensaje       => 'HTML',
                                               p_directorio        => '',
                                               p_archivosadjuntos  => '',
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                                                                     );
              Update aqpa705 set  aqpa705auxv5='S'  where aqpa705corr = i.correlativo;
              commit;
        exception
        when others then  
             p_c_coderr := '00x';
             p_c_deserr := sqlerrm;                                                   
        end;      
        dbms_lob.freetemporary(ll_mensaje);               
     End Loop;
                                                                         
                                   
  end sp_enviar_correo_sueldo;
  Procedure sp_baja_sueldo      (P_N_CODPAI IN NUMBER,
                               P_N_TIPDOC IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2)is
    
   cursor c1 is 
   select s.sng001inst
  from sng001 s, xwf700 x, wfwrkitems w
where s.sng001pais = P_N_CODPAI
   and s.sng001tdoc = P_N_TIPDOC
   and s.sng001ndoc = rpad(trim(P_C_NUMDOC),12, ' ')
   and s.sng001inst = x.xwfprcins
   and x.xwfmodulo = 106
   and x.xwftipope in (96, 97)
   and x.xwfcar3 = '1'
   and x.xwfprcins = w.wfinsprcid
   and w.wfitemstsact = 1;

   
  begin
   for j in c1  loop               
       sp_cr_cerrar_instancia(j.sng001inst);
   End Loop;     
   
                                                                
end sp_baja_sueldo; 
Procedure sp_correo_pagare(
                             P_N_CORR IN NUMBER,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_CODERR OUT VARCHAR2,
                    	       p_c_DESERR OUT VARCHAR2) 
                             is      
                                   
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);     
  lv_remitente  VARCHAR2(50);  
  lv_asunto     VARCHAR2(150);  
  lv_directorio VARCHAR2(30);  
  lv_archivos   VARCHAR2(32767);  
  lv_contacto   VARCHAR2(110);  
  lv_destinos   VARCHAR2(32767):='';  
  ln_Tp1corr2   NUMBER(9);
  l_offset      NUMBER;
  l_ammount     NUMBER;
  lv_moneda     VARCHAR2(50); 
  lv_canal      VARCHAR2(50); 
  
  lc_fecope   VARCHAR2(30); 
  lc_numtra   VARCHAR2(40); 
  /*Variables de la AQPA705*/    
  L_AQPA705PDOC   NUMBER;
  L_AQPA705TDOC   NUMBER;
  L_AQPA705NDOC   CHAR(12); 
  L_AQPA705TIPOPE CHAR(1); 
  L_AQPA705FECTRA DATE;
  L_AQPA705HORTRA CHAR(8); 
  L_AQPA705CTAORI VARCHAR2(50); 
  L_AQPA705CTADES VARCHAR2(50); 
  L_AQPA705MONOPE NUMBER;
  L_AQPA705MDAOPE NUMBER;
  L_AQPA705COMOPE NUMBER;
  L_AQPA705AUXV1  VARCHAR2(200); 
  L_AQPA705AUXV2  VARCHAR2(200); 
  L_AQPA705AUXV3  VARCHAR2(200); 
  L_AQPA705AUXV4  VARCHAR2(200); 
  L_AQPA705AUXV5  VARCHAR2(200); 
  L_AQPA705AUXN1  NUMBER;
  L_AQPA705AUXN2  NUMBER;
  L_AQPA705AUXN3  NUMBER;
  L_AQPA705AUXN4  NUMBER;
  L_AQPA705AUXN5  NUMBER;
  L_AQPA705CORREO  VARCHAR2(500);
  L_AQPA705ARCHIV  VARCHAR2(500);
  L_AQPA705CANAL  NUMBER;
  L_AQPA705NUTAR  CHAR(19);
  lv_monsim  VARCHAR2(50); 
  L_AQPA724CLIARC VARCHAR2(200); --
  L_AQPA705CTCOD NUMBER;
  L_AQPA705CTMOD NUMBER;
  L_AQPA705CTSUC NUMBER;
  L_AQPA705CTTRA NUMBER;
  L_AQPA705CTREL NUMBER;


   
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
        
    lv_remitente := 'cajamovil@cajaarequipa.pe';    
    
    select AQPA705PDOC,AQPA705TDOC,AQPA705NDOC,AQPA705TIPOPE,AQPA705FECTRA,AQPA705HORTRA,AQPA705CTAORI,AQPA705CTADES,
    AQPA705MONOPE,AQPA705MDAOPE,AQPA705COMOPE,AQPA705AUXV1,AQPA705AUXV2,AQPA705AUXV3,AQPA705AUXV4,AQPA705AUXV5, 
    AQPA705AUXN1,AQPA705AUXN2,AQPA705AUXN3,AQPA705AUXN4,AQPA705AUXN5, AQPA705CORREO, AQPA705ARCHIV, AQPA705CANAL, AQPA705NUTAR, AQPA724CLIARC,
    AQPA705CTCOD, AQPA705CTMOD, AQPA705CTSUC, AQPA705CTTRA, AQPA705CTREL
    into L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC,L_AQPA705TIPOPE,L_AQPA705FECTRA,L_AQPA705HORTRA,
    L_AQPA705CTAORI,L_AQPA705CTADES,L_AQPA705MONOPE,L_AQPA705MDAOPE,L_AQPA705COMOPE,L_AQPA705AUXV1,L_AQPA705AUXV2, 
    L_AQPA705AUXV3,L_AQPA705AUXV4,L_AQPA705AUXV5,L_AQPA705AUXN1,L_AQPA705AUXN2,L_AQPA705AUXN3,L_AQPA705AUXN4, 
    L_AQPA705AUXN5,L_AQPA705CORREO,L_AQPA705ARCHIV, L_AQPA705CANAL, L_AQPA705NUTAR, L_AQPA724CLIARC,
    L_AQPA705CTCOD, L_AQPA705CTMOD, L_AQPA705CTSUC, L_AQPA705CTTRA, L_AQPA705CTREL
    from AQPA705 a
    inner join aqpa724 b on a.aqpa705corr = b.aqpa724idref
    where aqpa724id=P_N_CORR;    
    
    if L_AQPA705MDAOPE = 0 then
       lv_moneda := 'SOL';
       lv_monsim := 'S/ ';
    else
       lv_moneda := 'DOLAR AMERICANO';
       lv_monsim := '$ ';
    end if;   
       
    if trim(P_C_EMAILS) is null then
       lv_destinos := L_AQPA705CORREO;
    else
       lv_destinos := P_C_EMAILS;
    end if;
    
    Case            
    When L_AQPA705CANAL = 6 then
         lv_canal := 'CAJA MOVIL';
         lv_remitente := 'cajamovil@cajaarequipa.pe';   
    When L_AQPA705CANAL = 3 then
         lv_canal := 'HOMEBANKING';
         lv_remitente := 'homebanking@cajaarequipa.pe';   
    When L_AQPA705CANAL = 7 then
         lv_canal := 'HOMEBANKING'; 
         lv_remitente := 'homebanking@cajaarequipa.pe';   
    When L_AQPA705CANAL = 2 then
         lv_canal := 'CAJERO ATM';     
         lv_remitente := 'cajeroautomatico@cajaarequipa.pe';   
    else
         lv_canal := 'CAJA MOVIL';
         lv_remitente := 'cajamovil@cajaarequipa.pe';  
    End Case;
    
    --lv_archivos := L_AQPA705ARCHIV;
    lc_fecope:= trim(to_char(L_AQPA705FECTRA, 'DD/MM/YYYY')) || ' ' || trim(L_AQPA705HORTRA) ;    
    lc_numtra:= trim(to_char(L_AQPA705FECTRA, 'YYYYMMDD')) || lpad(trim(L_AQPA705CTSUC),3,'0') || lpad(trim(L_AQPA705CTMOD),3,'0') || lpad(trim(L_AQPA705CTTRA),3,'0') || lpad(trim(L_AQPA705CTREL),4,'0');
  
    lv_asunto    := 'ENVIO AUTOMATICO -  CONFIRMACION ' || 'DESEMBOLSO DE CREDITO - FIRMA DIGITAL - ' || trim(lv_canal); --' - CAJA MOVIL/HB';         
    lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';        
    lv_contacto := pq_cn_cajamovil.fn_ah_nombre_per(L_AQPA705PDOC,L_AQPA705TDOC,L_AQPA705NDOC);                 
    dbms_lob.createtemporary(ll_mensaje, TRUE);              
    lv_mensaje := 
    '<div style="background-color:#002753; width:100%; padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px; color:#FFFFFF; font-weight:lighter;">
         Caja Arequipa</div>'||                  
         '<b style="font-family:Calibri; font-size:14px">CONSTANCIA DE DESEMBOLSO DE CREDITO - FIRMA DIGITAL - ' || trim(lv_canal) || /*CAJA MOVIL */'</b>'||
	  '<br>'||
    '<hr>' ||
    '<table>'||                 
    '<tr style="font-family:Calibri; font-size:14px"><td>Titular</td><td> </td><td>' || lv_contacto || '</td></tr>' ||
    '<tr><td colspan="3">&nbsp;</td></tr>'||
    '<tr style="font-family:Calibri; font-size:14px"><td>Nro. de crédito</td><td> </td><td>' || trim(L_AQPA705CTAORI) || '</td></tr> '||               
    '<tr style="font-family:Calibri; font-size:14px"><td>Fecha y hora</td><td> </td><td>' ||  trim(lc_fecope) || '</td></tr>' ||
    '<tr style="font-family:Calibri; font-size:14px"><td>Número de transacción</td><td> </td><td>' || trim(lc_numtra) || '</td></tr> ' ||
    '<tr><td colspan="3">&nbsp;</td></tr>'||         
    '<tr style="font-family:Calibri; font-size:14px"><td>Monto del desembolso</td><td> </td><td>' || lv_monsim ||trim(to_char(L_AQPA705MONOPE,'9999,999.99')) || '</td></tr> '||         
    --'<tr><td colspan="3">&nbsp;</td></tr>'||
    '<tr style="font-family:Calibri; font-size:14px"><td>Cuenta de abono</td><td> </td><td>' || trim(L_AQPA705CTADES) || '</td></tr> '||
    '<tr style="font-family:Calibri; font-size:14px"><td>Fecha primer pago</td><td> </td><td>' || trim(L_AQPA705AUXV1) || '</td></tr> '||
    '<tr style="font-family:Calibri; font-size:14px"><td>Monto cuota</td><td> </td><td>' || lv_monsim ||trim(to_char(L_AQPA705AUXN1,'9999,999.99'))  || '</td></tr> ';
         
    if L_AQPA705AUXV2 = 'Ampliación' then
       lv_mensaje := lv_mensaje ||
       '<tr><td colspan="3">&nbsp;</td></tr>'||
       '<tr style="font-family:Calibri; font-size:14px"><td>Tipo de crédito</td><td> </td><td>' || trim(L_AQPA705AUXV2) || '</td></tr> '||
       '<tr style="font-family:Calibri; font-size:14px"><td>Crédito a cancelar</td><td> </td><td>' || trim(L_AQPA705AUXV3) || '</td></tr> '||
       '<tr style="font-family:Calibri; font-size:14px"><td>Monto a cancelar</td><td> </td><td>' || lv_monsim ||trim(to_char(L_AQPA705AUXN2,'9999,999.99'))  || '</td></tr> ' ||
       '<tr style="font-family:Calibri; font-size:14px"><td>Monto neto a desembolsar (menos ITF)</td><td> </td><td>' || lv_monsim ||trim(to_char(L_AQPA705AUXN3,'9999,999.99'))  || '</td></tr> ';
    end if;
          
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
                                               p_archivosadjuntos  => L_AQPA724CLIARC,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
      exception
      when others then  
           p_c_coderr := '00x';
           p_c_deserr := sqlerrm;                                                   
      end;      
      dbms_lob.freetemporary(ll_mensaje);    
                                   
end sp_correo_pagare;                               
Procedure sp_aprobacion_gerente (P_N_INSTANCIA IN NUMBER,                         
                                 P_C_VALIDA OUT VARCHAR2 ) is
 L_COUNT NUMBER ;                                  
begin
    P_C_VALIDA :='N';      
    L_COUNT :=0 ;  
    begin      
        select count(1) into L_COUNT from jaqm750 a, jaqz697 b where 
        a.jaqm750pai=b.jaqz697pai
        and a.jaqm750tdo=b.jaqz697tdo
        and a.jaqm750ndo = b.jaqz697ndo
        and a.jaqm750fch>=b.jaqz697fep
        and a.jaqm750imp=b.jaqz697mto
        and b.jaqz697au5='S'
        and a.jaqm750mod=b.jaqz697mod
        and a.jaqm750tip=b.jaqz697top
        and a.jaqm750suc=b.jaqz697suc
        and a.jaqm750mda=b.jaqz697mda
        and (nvl(b.jaqz697apr,'R') ='R' or nvl(b.jaqz697apr,'N') ='N') --Se agrega filtro para no mostrar los de estado=N
        and b.jaqz697fep = (select max(jaqz697fep) from jaqz697 )
        and b.jaqz697tca = 'P'
        and a.jaqm750ins=P_N_INSTANCIA
        and a.jaqm750emp = 1; 
        
        if L_COUNT = 0 then
           P_C_VALIDA := 'S';
        else
           P_C_VALIDA := 'N';
        end if;
                                
    exception
          when others then
          P_C_VALIDA :='S';       
     end;    

end sp_aprobacion_gerente;   

Procedure sp_guardar_log_envio(p_fectra date,
                               p_hortra Character,
                               p_nutar Character,
                               p_numdoc Character,
                               p_destinatario  VARCHAR2,
                               p_destinatarioscc  VARCHAR2,  
                               p_destinatariosbcc VARCHAR2, 
                               p_mensaje          CLOB,
                               p_remitente        VARCHAR2,
                               p_asunto           VARCHAR2,
                               p_c_coderr         NUMBER,
                               p_c_deserr         VARCHAR2, 
                               p_canal            VARCHAR2)IS                                              
  BEGIN
  
     INSERT INTO AQPB117 (AQPB117FECHA, 
                           AQPB117HOR, 
                           AQPB117NUTAR, 
                           AQPB117THD, 
                           AQPB117PTO, 
                           AQPB117PPC, 
                           AQPB117PBCC, 
                           AQPB117TEXT,
                           AQPB117PFROM, 
                           AQPB117ASUN,
                           AQPB117CODERR,
                           AQPB117MSJERR, 
                           AQPB117CANAL)
      VALUES (p_fectra,
              p_hortra,
              p_nutar,
              p_numdoc,
              p_destinatario,
              p_destinatarioscc, 
              p_destinatariosbcc, 
              p_mensaje, 
              p_remitente, 
              p_asunto, 
              p_c_coderr, 
              p_c_deserr, 
              p_canal);
              commit;

  end sp_guardar_log_envio;
  
  -- rcuadros 05/05/2025
  PROCEDURE sp_cn_obtener_tc(
      pn_pizarr IN NUMBER,
      pd_pgfape IN DATE,
      pn_tccomp OUT NUMBER,
      pn_tcvent OUT NUMBER,
      pd_tcfech OUT DATE,
      pc_tchora OUT VARCHAR2
  ) IS

  BEGIN
      SELECT TCCPA, TCVTA, TCFCH, TCHOR
        INTO pn_tccomp, pn_tcvent, pd_tcfech, pc_tchora
        FROM (SELECT TCCPA, TCVTA, TCFCH, TCHOR
                FROM FSD120
               WHERE TCCOD = pn_pizarr
                 AND TCMDA = 101
                 AND TCFCH <= pd_pgfape
                 AND TCCPA > 0
                 AND TCVTA > 0
              ORDER BY TCFCH DESC, TCHOR DESC, TCIMP DESC)
       WHERE ROWNUM = 1;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error en sp_cn_obtener_tc: ' || SQLERRM);
  END sp_cn_obtener_tc;
  
  -- rcuadros 05/05/2025
  PROCEDURE sp_cn_calcular_tc(
      pn_pizarr IN NUMBER,
      pd_tcfech IN DATE,
      pc_tchora IN VARCHAR2,
      pn_tccomp OUT NUMBER,
      pn_tcvent OUT NUMBER
  ) IS

  BEGIN
      SELECT TCCPA, TCVTA
        INTO pn_tccomp, pn_tcvent
        FROM (SELECT TCCPA, TCVTA
                FROM FSD120
               WHERE TCCOD = pn_pizarr
                 AND TCMDA = 101
                 AND TCFCH = pd_tcfech
                 AND TCHOR = pc_tchora
                 AND TCCPA > 0
                 AND TCVTA > 0
              ORDER BY TCFCH DESC, TCHOR DESC, TCIMP DESC)
       WHERE ROWNUM = 1;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error en sp_cn_calcular_tc: ' || SQLERRM);
  END sp_cn_calcular_tc;

end PQ_CN_CAJAMOVIL;
/
