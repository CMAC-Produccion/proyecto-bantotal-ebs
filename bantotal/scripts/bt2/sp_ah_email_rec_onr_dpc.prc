CREATE OR REPLACE PROCEDURE SP_AH_EMAIL_REC_ONR_DPC(P_RECCOD IN VARCHAR,
                                                    P_ERRCOD OUT VARCHAR,
                                                    P_ERRMSG OUT VARCHAR) IS

  -- ***************************************************************************************
  -- Nombre                     : SP_AH_EMAIL_REC_ONR_DPC
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.05.17
  -- Autor de Creación          : CVILLON
  -- Uso                        : Envio de Email a PyC
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.01.24
  -- Modificado                 : CVILLON
  -- ***************************************************************************************
  ---***

  ll_mensaje   CLOB;
  lv_mensaje   VARCHAR2(32767);
  lv_remitente VARCHAR2(60);
  lv_asunto    VARCHAR2(90);
  lv_contacto  VARCHAR2(200);
  ln_corcar    NUMBER(10) := 0;
  lv_direccion VARCHAR2(200);
  ---***
  lc_asunto    VARCHAR(30);
  lc_remitente VARCHAR(60);
  lv_destinos  VARCHAR2(32767) := '';
  lv_destino1  VARCHAR(30);
  lv_destino2  VARCHAR(30);
  lv_destino   VARCHAR(60);
  --***
  ln_ESR    NUMBER(3);
  ln_MOT    NUMBER(3);
  ld_FCC    DATE;
  lc_HRC    CHAR(8);
  ln_PAC    NUMBER(3);
  ln_TDC    NUMBER(2);
  lc_NDC    CHAR(12);
  lv_clinom VARCHAR(60);
  lv_clidni VARCHAR(120);
  ---***

BEGIN
  P_ERRCOD := '000';
  P_ERRMSG := '';
  ---***
  ---***
  --SELECT * FROM fst198 WHERE tp1cod1 = 11146 AND tp1corr1 = 1 AND tp1corr2 = 55 FOR UPDATE
  --Reclamos - Estado de Anulación ...
  ---*** RECLAMO
  --FROM JAQL420
  --WHERE JAQL420EMP = 1 AND JAQL420COD = P_RECCOD;

  ---***
  BEGIN
    SELECT JAQL420ESR,
           JAQL420MOT,
           JAQL420FCC,
           JAQL420HRC,
           JAQL420PAC,
           JAQL420TDC,
           JAQL420NDC
      INTO ln_ESR, ln_MOT, ld_FCC, lc_HRC, ln_PAC, ln_TDC, lc_NDC
      FROM JAQL420
     WHERE JAQL420EMP = 1
       AND JAQL420COD = P_RECCOD;
  EXCEPTION
    when others then
      P_ERRCOD := '501';
      P_ERRMSG := '(ERROR EN RECLAMO)::(' || sqlcode || ') -> ' || sqlerrm;
  END;
  ---***
  IF ((ln_ESR <> 3) OR (ln_MOT NOT IN (231, 257))) THEN
    RETURN;
  END IF;
  ---*** HORA ACTUAL
  SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO lc_HRC FROM dual;
  ---*** CLIENTE
  BEGIN
    SELECT TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ', ' || TRIM(PFNOM1) || ' ' ||
           TRIM(PFNOM2)
      INTO lv_clinom
      FROM FSD002
     WHERE PFPAIS = ln_PAC
       AND PFTDOC = ln_TDC
       AND PFNDOC = lc_NDC;
  
    lv_clidni := TRIM(lc_NDC);
  
  EXCEPTION
    when others then
      lv_clinom := 'No Registrado';
      lv_clidni := '-';
  END;
  ---***
  ---*** REMITENTE
  BEGIN
    SELECT TRIM(tp1desc)
      INTO lc_remitente
      FROM fst198
     WHERE tp1cod1 = 11146
       AND tp1corr1 = 1
       AND tp1corr2 = 59
       AND tp1corr3 = 1;
  EXCEPTION
    when others then
      P_ERRCOD := '107';
      P_ERRMSG := '(REMITENTE)::(' || sqlcode || ') -> ' || sqlerrm;
      RETURN;
  END;
  lv_remitente := TRIM(lc_remitente) || '@cajaarequipa.pe';
  ---*********
  ---*** ASUNTO
  BEGIN
    SELECT tp1desc
      INTO lc_asunto
      FROM fst198
     WHERE tp1cod1 = 11146
       AND tp1corr1 = 1
       AND tp1corr2 = 59
       AND tp1corr3 = 2;
  EXCEPTION
    when others then
      P_ERRCOD := '106';
      P_ERRMSG := '(ASUNTO)::(' || sqlcode || ') -> ' || sqlerrm;
      RETURN;
  END;
  lv_asunto := TRIM(lc_asunto);
  ---*********
  --lv_remitente := 'cvillon@cajaarequipa.pe';
  ----dbms_output.put_line('lv_remitente: '||lv_remitente);
  ---*** DESTINOS (3 y 4 es un solo destino)
  BEGIN
    SELECT TRIM(tp1desc)
      INTO lv_destino1
      FROM fst198
     WHERE tp1cod1 = 11146
       AND tp1corr1 = 1
       AND tp1corr2 = 59
       AND tp1corr3 = 3;
  EXCEPTION
    when others then
      P_ERRCOD := '109';
      P_ERRMSG := '(DEST1)::(' || sqlcode || ') -> ' || sqlerrm;
      RETURN;
  END;
  ---***
  BEGIN
    SELECT TRIM(tp1desc)
      INTO lv_destino2
      FROM fst198
     WHERE tp1cod1 = 11146
       AND tp1corr1 = 1
       AND tp1corr2 = 59
       AND tp1corr3 = 4;
  EXCEPTION
    when others then
      P_ERRCOD := '109';
      P_ERRMSG := '(DEST2)::(' || sqlcode || ') -> ' || sqlerrm;
      RETURN;
  END;
  ---***
  ---*** DESTINOS EXTRA (SI LOS HUBIERA)
  lv_destino  := NULL;
  lv_destinos := NULL;
  lv_destino  := TRIM(lv_destino1) || TRIM(lv_destino2) ||
                 '@cajaarequipa.pe';
  lv_destinos := lv_destino;
  --lv_destinos := 'cvillon@cajaarequipa.pe';
  FOR XDEST IN (SELECT TRIM(tp1desc) AS DESTINATARIO
                  FROM fst198
                 WHERE tp1cod1 = 11146
                   AND tp1corr1 = 1
                   AND tp1corr2 = 59
                   AND tp1corr3 > 4) LOOP
    ---***
    XDEST.DESTINATARIO := TRIM(XDEST.DESTINATARIO) || '@cajaarequipa.pe';
    ---***
    IF (lv_destinos IS NULL) THEN
      lv_destinos := TRIM(XDEST.DESTINATARIO);
      --lv_destinos := 'cvillon@cajaarequipa.pe';
      --dbms_output.PUT_LINE('lv_destinos if: '||lv_destinos);
    ELSE
      lv_destinos := TRIM(XDEST.DESTINATARIO) || ';' || TRIM(lv_destinos);
      --dbms_output.PUT_LINE('lv_destinos else: '||lv_destinos);
    END IF;
  END LOOP;
  ---***
  ---***
  dbms_lob.createtemporary(ll_mensaje, TRUE);
  ---***
  ---***
  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">El Siguiente Reclamo de ONR fue Respondido ...' ||
                '<p "font-family: Arial, sans-serif; font-size: 14px;">********************************************************************************</p>' ||
                '<p "font-family: Arial, sans-serif; font-size: 14px;">El Reclamo:   ' ||
                P_RECCOD || '</p>' ||
                '<p "font-family: Arial, sans-serif; font-size: 14px;">del Cliente:   ' ||
                lv_clinom || '</p>' ||
                '<p "font-family: Arial, sans-serif; font-size: 14px;">identificado con DNI:   ' ||
                lv_clidni || '</p>' ||
                '<p "font-family: Arial, sans-serif; font-size: 14px;">ha sido concluido.</p>' ||
                '<p "font-family: Arial, sans-serif; font-size: 14px;">Fecha:    ' ||
                ld_FCC || ' ' || lc_HRC || '</p>';

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
        P_ERRMSG := '(ERROR - ENVIO DE CORREO)::(' || sqlcode || ') -> ' ||
                    sqlerrm;
    end;
  else
    P_ERRCOD := '302';
    P_ERRMSG := 'No existe cuenta de correo asociada';
  end if;

  dbms_lob.freetemporary(ll_mensaje);
exception
  when others then
    P_ERRCOD := '303';
    P_ERRMSG := '(ERROR - ENVIO DE CORREO)::(' || sqlcode || ') -> ' ||
                sqlerrm;
    ---***
  ----dbms_output.put_line('p_c_coderr: '||p_c_coderr);
  ----dbms_output.put_line('p_c_deserr: '||p_c_deserr);
  ---***
END SP_AH_EMAIL_REC_ONR_DPC;
/

