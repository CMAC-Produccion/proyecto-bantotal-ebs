CREATE OR REPLACE PROCEDURE SP_AH_EMAIL_RECLAMO_ANULA(P_RECCOD IN VARCHAR,
                                       P_MODENV IN VARCHAR,
                                       P_ERRCOD OUT VARCHAR,
                                       P_ERRMSG OUT VARCHAR) IS

    ll_mensaje   CLOB;
    lv_mensaje   VARCHAR2(32767);
    lv_remitente VARCHAR2(30);
    lv_asunto    VARCHAR2(90);
    lv_destinos  VARCHAR2(32767) := '';
    lv_contacto  VARCHAR2(200);
    ln_corcar    NUMBER(10) := 0;
    lv_direccion VARCHAR2(200);
    ---***
    lc_asunto    VARCHAR(30);
    lc_remitente VARCHAR(30);
    ln_MODENV NUMBER(3);
    lv_MODENV VARCHAR(20);
    ---***
    lv_GESANU VARCHAR(60);
    lv_SUPANU VARCHAR(60);
    lv_MSGANU VARCHAR(200);
    ---***

  BEGIN
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    ln_MODENV:= 1; -- MODO de Envio por DEFECTO (Anulacion NO Autorizada)
    lv_MODENV:= 'RECHAZADA';
    IF(P_MODENV = 'C') THEN
      ln_MODENV:= 2; -- MODO de Envio (Anulacion Autorizada)
      lv_MODENV:= 'APROBADA';
    END IF;
    ---***
    --SELECT * FROM fst198 WHERE tp1cod1 = 11146 AND tp1corr1 = 1 AND tp1corr2 = 55 FOR UPDATE
    --Reclamos - Estado de Anulación ...
    ---*** RECLAMO
    SELECT TRIM(JAQL420GESANU), TRIM(JAQL420SUPANU), TRIM(JAQL420MSGANU)
    INTO lv_GESANU, lv_SUPANU, lv_MSGANU
    FROM JAQL420
    WHERE JAQL420EMP = 1 AND JAQL420COD = P_RECCOD;
    ---*** ASUNTO
    BEGIN
      SELECT tp1desc
        INTO lc_asunto
        FROM fst198
       WHERE tp1cod1 = 11146
         AND tp1corr1 = 1
         AND tp1corr2 = 55
         AND tp1corr3 = ln_MODENV;
    EXCEPTION
      when others then
        P_ERRCOD := '106';
        P_ERRMSG := '(PARAM ASUNTO)::('||sqlcode || ') -> ' || sqlerrm;
        RETURN;
    END;
    lv_asunto := TRIM(lc_asunto);
    ---*** REMITENTE
    BEGIN
      SELECT TRIM(tp1desc)
        INTO lc_remitente
        FROM fst198
       WHERE tp1cod1 = 11146
         AND tp1corr1 = 1
         AND tp1corr2 = 55
         AND tp1corr3 = 3;
    EXCEPTION
      when others then
        P_ERRCOD := '107';
        P_ERRMSG := '(PARAM REMITENTE)::('||sqlcode || ') -> ' || sqlerrm;
        RETURN;
    END;
    lv_remitente := TRIM(lc_remitente) || '@cajaarequipa.pe';
    ---*********
    --lv_remitente := 'cvillon@cajaarequipa.pe';
    ----dbms_output.put_line('lv_remitente: '||lv_remitente);
    ---*** DESTINOS
    ---***
    IF((lv_GESANU IS NULL) OR (lv_SUPANU IS NULL)) THEN
      P_ERRMSG := 'No se puede Obtener el GESTOR o el SUPERVISOR';
      RETURN;
    END IF;
    ---***
    lv_destinos := NULL;
    lv_GESANU := lv_GESANU || '@cajaarequipa.pe';
    lv_SUPANU := lv_SUPANU || '@cajaarequipa.pe';
    lv_destinos := lv_GESANU ||';'||lv_SUPANU;
    ---***
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    ---***
    ---***
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Reclamos - Estado de la Anulación ...' ||
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">********************************************************************************</p>' ||
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Reclamo:   '||P_RECCOD||'</p>'||
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Anulación: '||lv_MODENV||'</p>'||
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Motivo:    '||lv_MSGANU||'</p>';

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
                                         p_c_coderr          => P_ERRCOD,
                                         p_c_deserr          => P_ERRMSG);
      exception
        when others then
          P_ERRCOD := '301';
          P_ERRMSG := '(ERROR - ENVIO DE CORREO)::('||sqlcode || ') -> ' || sqlerrm;
      end;
    else
      P_ERRCOD := '302';
      P_ERRMSG := 'No existe cuenta de correo asociada';
    end if;

    dbms_lob.freetemporary(ll_mensaje);
  exception
    when others then
      P_ERRCOD := '303';
      P_ERRMSG := '(ERROR - ENVIO DE CORREO)::('||sqlcode || ') -> ' || sqlerrm;
      ---***
    ----dbms_output.put_line('p_c_coderr: '||p_c_coderr);
    ----dbms_output.put_line('p_c_deserr: '||p_c_deserr);
    ---***
  END SP_AH_EMAIL_RECLAMO_ANULA;
/

