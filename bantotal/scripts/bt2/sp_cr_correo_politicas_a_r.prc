create or replace procedure SP_CR_CORREO_POLITICAS_A_R(P_N_INST  IN number,
                                                       P_N_POLI  IN number,
                                                       P_N_EST  IN varchar2,
                                                       P_N_CODERR out number,
                                                       P_C_MSGERR out varchar2) is
  
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);
  lv_asunto     VARCHAR2(200);
  lv_remitente  VARCHAR2(90);
  
  lv_correog VARCHAR2(4000) := '';
  lv_estado  varchar2(100);
  
  lv_destinos   VARCHAR2(4000) := '';
  
  ------
  lv_usuario   varchar(10);
  lv_analista  varchar(1000);
  ------  
  my_errm VARCHAR2(32000);
begin

  begin
    P_N_CODERR := 0;
    
    select usu.sng001ase, trim(ana.wfusremail), upper(trim(ana.wfusrname)) 
      into lv_usuario,    lv_correog,           lv_analista
    from sng091 ins
    inner join sng001 usu on ins.sng001inst = usu.sng001inst --and pol.sng065usr = usu.sng001ase
    inner join WFUSERS ana on usu.sng001ase = ana.wfusrcod
    where ins.sng001inst = P_N_INST and ins.sng091num = P_N_POLI
    group by usu.sng001ase, trim(ana.wfusremail), upper(trim(ana.wfusrname));
    
        
    lv_estado := case when P_N_EST = 'A' then 'Autorizada' else 'Rechazada' end;
    
  exception
      when no_data_found  then
        P_N_CODERR := 1;
        P_C_MSGERR := 'Error no se encontro registros';
      when too_many_rows  then
        P_N_CODERR := 2;
        P_C_MSGERR := 'Mas de un resultado en el select';
      when others  then
        P_N_CODERR := 3;
        P_C_MSGERR := 'Error no identificado';
        my_errm := SQLERRM;
  end;

  
  -- Correo remitente
  if P_N_CODERR = 0 then
    lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    lv_asunto    := 'Atención de bloqueante';
  end if;

  -- Validar correo analista
  if lv_correog is null OR lv_correog = '' then
    P_N_CODERR := 5;
    P_C_MSGERR := 'No se encontró correo del analista '|| lv_correog;
  end if;
  
  if P_N_CODERR = 0 then 
    begin
        dbms_lob.createtemporary(ll_mensaje, TRUE);      
    exception
      when others then
          P_N_CODERR := 6;
          P_C_MSGERR := sqlerrm;
    end;
    
    lv_destinos   := lv_correog;
    lv_mensaje    := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado analista, '|| lv_analista || '.</p>' ||
                     '<p "font-family: Arial, sans-serif; font-size: 14px;">La politica Nro.: ' || to_char(P_N_POLI) 
                     || ', de la instancia Nro. ' || P_N_INST  || '<br><br>Fue gestiona. <strong>' || lv_estado || '.</strong></p>';

    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje); --**
    exception
      when others then
          P_N_CODERR := 7;
          P_C_MSGERR := sqlerrm;
    end;
    
    begin
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); --**
    exception
      when others then
          P_N_CODERR := 8;
          P_C_MSGERR := sqlerrm;
    end;
      
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">
                      <strong>No responda el presente correo electrónico<br/>Atentamente<br/>Caja Arequipa</strong>
                   </p>';

    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); --**

    
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
                                       p_c_coderr          => P_N_CODERR,
                                       p_c_deserr          => P_C_MSGERR);
      
    exception
      when others then
          P_N_CODERR := 9;
          P_C_MSGERR := sqlerrm;
    end;
    
    dbms_lob.freetemporary(ll_mensaje);
  end if; 

end SP_CR_CORREO_POLITICAS_A_R;
/

