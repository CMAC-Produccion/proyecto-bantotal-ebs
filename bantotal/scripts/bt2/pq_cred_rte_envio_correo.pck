create or replace package pq_cred_rte_envio_correo is
 -- *****************************************************************
      -- Sistema                    : BANTOTAL
      -- Módulo                     : Créditos - Activas
      -- Versión                    : 1.0
      -- Fecha de Creación          : 11/08/2022
      -- Autor de Creación          : IGS_RCASTRO
      -- Uso                        : RTE de confirmación envio de correo inmobiliario
      -- Estado                     : Activo
      -- Acceso                     : Público
      -- Fecha de Modificación      : --
      -- Autor de la Modificación   : --
      -- Descripción de Modificación: --
      -- *****************************************************************
  
  procedure sp_cr_obtenerdatos(cuenta in number,
                               fechatrx in varchar2,
                               importetrx in number,
                               auxrubro in number);                           
  
end pq_cred_rte_envio_correo;
/

create or replace package body pq_cred_rte_envio_correo is

 procedure sp_cr_obtenerdatos(cuenta in number, fechatrx in varchar2, importetrx in number, auxrubro in number) is
  -------------------   
  CURSOR CORREOS is 
  SELECT * FROM FST198 WHERE TP1COD1 = 11152 AND TP1CORR1 = 4 AND TP1CORR2 = 1  AND TP1NRO1 = 1;
  CURSOR CORREOS2 IS
  SELECT * FROM FST198 WHERE TP1COD1 = 11152 AND TP1CORR1 = 4 AND TP1CORR2 = 1  AND TP1NRO1 = 2;
  ------------------- 
 ------------------- 
    flag_data char(1);
    ln_pago number(17,6);
    flg_hdata char(1);
    
    --------------------          
    subject varchar2(1000);   
    --------------------              
    v_header varchar2(10000);-- Cabecera
    v_wstring clob;
    data varchar2(32000);
    rawdata long raw;
    --------------------
    fechaApertura date;
    remitente varchar(100);
    receptor  varchar(80);
    textSubtotal varchar(30); 
    ----------------------
    lv_destinos varchar2(300);
    -------------------
    lv_emisor  varchar2(200) := ''; 
    lv_destino varchar2(100) := ''; 
    lv_descopi varchar2(300) := ''; 
    lv_asunto  varchar2(70) := ''; 
    ll_mensaje long := '';
    p_c_coderr  varchar2(5);
    p_c_msgerr  varchar2(200);
    
    ----------------------
    nrodoc varchar2(12);
    cliente varchar2(100);
    Nomcliente VARCHAR(400);
    v_descrubro varchar2(50);
    
  BEGIN  
    BEGIN
        SELECT Pgfape into fechaApertura from FST017 WHERE PGCOD = 1; 
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        fechaApertura := sysdate;     
    END;
    BEGIN      
        --remitente      
        SELECT tp1desc into lv_emisor FROM FST198 WHERE TP1COD1 = 11152 AND TP1CORR1 = 4 AND TP1CORR2 = 1  AND TP1NRO1 = 3;
    EXCEPTION                    
    WHEN NO_DATA_FOUND THEN
        lv_emisor := 'notificaciones@cajaarequipa.pe';
    END;     
    ---------------------------------------------------------------------------------  
    FOR REG_CORREOS IN CORREOS LOOP
        receptor := receptor || trim(REG_CORREOS.TP1DESC);        
    END LOOP; 
    
    FOR REG_CORREOS2 IN CORREOS2 LOOP
        lv_descopi := lv_descopi || trim(REG_CORREOS2.TP1DESC);        
    END LOOP; 
                    BEGIN
                       SELECT pendoc into nrodoc FROM FSR008 WHERE CTNRO = cuenta and CTTFIR = 'T';                       
                    EXCEPTION 
                      WHEN NO_DATA_FOUND THEN
                        nrodoc := '';                                            
                    END;    
                    BEGIN
                       SELECT PENOM into cliente FROM FSD001 WHERE PENDOC= nrodoc; 
                    EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                        cliente := '';  
                    END;
                    
                    BEGIN
                       select f.pcnomr INTO v_descrubro from fsd014 f where f.rubro= auxrubro;
                    EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                        v_descrubro := '';  
                    END;
    
                    textSubtotal:= replace(to_char(importetrx),',','.');   
                    
                    Nomcliente := upper(replace(upper(cliente),'Ñ','N'));   
    
                    --lv_emisor := 'notificaciones@cajaarequipa.pe';
                    lv_asunto := 'ALERTA: INFORMACIÓN DE TRANSACCIÓN';      
                    ll_mensaje := '<html><head><style type="text/css"></style>' ||
                    '<meta http-equiv="content-type" content="text/html; utf-8"> </head><body>' ||
                    '<p>
                    <ul><li> Nombre cliente: ' || trim(Nomcliente) || '
                    </li><li> Fecha de la transacción: ' || fechatrx || '
                    </li><li> Importe de la transacción: ' || textSubtotal || 
                    '</li><li> Comisión: ' || to_char(auxrubro) || ' - ' || trim(v_descrubro) ||
                     '</li></ul>
                    </p>'||                    
                    '<br><p>Atte.- <br><br>Caja Arequipa.</p></body></html>';                        
                                
                    begin
                    pq_ah_planillas.p_sendmailattach(p_destinatariospara => receptor,
                                                     p_destinatarioscc   => lv_descopi,
                                                     p_destinatariosbcc  => '',
                                                     p_mensaje           => ll_mensaje,
                                                     p_remitente         => lv_emisor,
                                                     p_asunto            => lv_asunto,
                                                     p_tipomensaje       => 'HTML',
                                                     p_directorio        => '',
                                                     p_archivosadjuntos  => '',
                                                     p_c_coderr          => p_c_coderr,
                                                     p_c_deserr          => p_c_msgerr);
                                                                                           
                    END;               
                              
  ---------------------------------------------------------------------------------                               
  END sp_cr_obtenerdatos;     
end pq_cred_rte_envio_correo;
/

