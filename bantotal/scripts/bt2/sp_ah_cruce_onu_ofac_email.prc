CREATE OR REPLACE PROCEDURE SP_AH_CRUCE_ONU_OFAC_EMAIL(P_CLINOM IN VARCHAR
, P_NRODOC IN VARCHAR
, P_CTACLI IN NUMBER
, P_AGEOPE IN VARCHAR
, P_TIPOPE IN VARCHAR
, P_MONTO IN NUMBER
, P_FECOPE IN VARCHAR
, P_TIPLIS IN VARCHAR
, p_c_coderr out VARCHAR2, p_c_deserr out VARCHAR2) IS

  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);
  lv_remitente  VARCHAR2(30);
  lv_asunto     VARCHAR2(90);
  lv_destinos   VARCHAR2(32767):='';
  lv_contacto   VARCHAR2(200);
  ln_corcar     NUMBER(10) := 0;
  lv_direccion  VARCHAR2(200);
  ---***
  lc_asunto VARCHAR(30);
  lc_remitente VARCHAR(30);
  ---***

  begin
    p_c_coderr := '000';
    p_c_deserr := '';

    ---*** ASUNTO
    SELECT tp1desc INTO lc_asunto FROM fst198 WHERE tp1cod1 = 11146 AND tp1corr1 = 1 AND tp1corr2 = 8 AND tp1corr3 = 1;
    lv_asunto := TRIM(lc_asunto);
    ---*** REMITENTE
    SELECT TRIM(tp1desc) INTO lc_remitente FROM fst198 WHERE tp1cod1 = 11146 AND tp1corr1 = 1 AND tp1corr2 = 8 AND tp1corr3 = 2;
    lv_remitente := TRIM(lc_remitente)||'@cajaarequipa.pe';
    --lv_remitente := 'cvillon@cajaarequipa.pe';
    --dbms_output.PUT_LINE('lv_remitente: '||lv_remitente);
    ---*** DESTINOS
    lv_destinos := NULL;
    --lv_destinos := 'cvillon@cajaarequipa.pe';
    FOR XDEST IN (SELECT TRIM(tp1desc) AS DESTINATARIO FROM fst198 WHERE tp1cod1 = 11146 AND tp1corr1 = 1 AND tp1corr2 = 8 AND tp1corr3 > 2)
    LOOP
      ---***
      XDEST.DESTINATARIO := TRIM(XDEST.DESTINATARIO)||'@cajaarequipa.pe';
      ---***
      IF(lv_destinos IS NULL) THEN
        lv_destinos := TRIM(XDEST.DESTINATARIO);
        --lv_destinos := 'cvillon@cajaarequipa.pe';
        --dbms_output.PUT_LINE('lv_destinos if: '||lv_destinos);
      ELSE
        lv_destinos := TRIM(XDEST.DESTINATARIO)||';'||TRIM(lv_destinos);
        --dbms_output.PUT_LINE('lv_destinos else: '||lv_destinos);
      END IF;
    END LOOP;
    ---***
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    ---***
    --El siguiente cliente/usuario tiene una coincidencia en las listas ONU-OFAC
    --Apellidos y Nombres:
    --N. D.O.I:
    --N. Cuenta cliente:
    --N. Agencia operación:
    --Tipo de operación: CREDITO O AHORRO
    --Monto:
    --Fecha de la Operación: 15/10/21
    --Coincidencia listas:
    --Lista: ONU u OFAC
    ---***
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">El siguiente cliente/usuario tiene una coincidencia en las listas ONU-OFAC'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">********************************************************************************</p>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Apellidos y Nombres: '||P_CLINOM||'</p>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">N. D.O.I: '||P_NRODOC||'</p>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">N. Cuenta cliente: '||P_CTACLI||'</p>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">N. Agencia operación: '||P_AGEOPE||'</p>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Tipo de operación: '||P_TIPOPE||'</p>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Monto: '||TO_CHAR(P_MONTO, '999999999990.00')||'</p>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Fecha de la Operación: '||P_FECOPE||'</p>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Coincidencia listas: '||P_TIPLIS||'</p>';


    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

    if trim(lv_destinos) is not null then
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
          exception
          when others then
               p_c_coderr := '00x';
               p_c_deserr := sqlerrm;
          end;
      else
               p_c_coderr := '00y';
               p_c_deserr := 'No existe cuenta de correo asociada';
      end if;

  dbms_lob.freetemporary(ll_mensaje);
  exception
      when others then
           p_c_coderr := sqlcode;
           p_c_deserr := sqlerrm;
           ---***
           --dbms_output.PUT_LINE('p_c_coderr: '||p_c_coderr);
           --dbms_output.PUT_LINE('p_c_deserr: '||p_c_deserr);
           ---***
end SP_AH_CRUCE_ONU_OFAC_EMAIL;
/

