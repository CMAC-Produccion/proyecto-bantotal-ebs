CREATE OR REPLACE PACKAGE "PQ_AH_RECLAMOS_PYC" IS
  -- ***************************************************************************************
  -- Nombre                     : PROCEDURES PARA LOS RECLAMOS DE ONR (Prevencion & Control)
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.12.22
  -- Autor de Creación          : CVILLON
  -- Uso                        : P&C
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.08.26
  -- Modificado                 : CVILLON
  -- Descripción                : Exportar ONR con TDV - TRX según GUIA - Nueva TRX
  -- ***************************************************************************************
  ---***

  ---*** Proceso que Calcula la Antiguedad de un Cliente
  PROCEDURE SP_AH_RECLAMOS_CLIANT(P_FECHOY IN DATE,
                                  P_PAIS   IN NUMBER,
                                  P_TDOC   IN NUMBER,
                                  P_NDOC   IN VARCHAR,
                                  P_NANT   OUT NUMBER,
                                  P_ERRCOD OUT VARCHAR,
                                  P_ERRMSG OUT VARCHAR);

  ---*** Proceso que asigna un Reclamo a PyC
  PROCEDURE SP_AH_PYC_ASIGNARREC(P_CREUSU IN VARCHAR,
                                 P_CREFEC IN DATE,
                                 P_CREHOR IN VARCHAR,
                                 P_RECEMP IN NUMBER,
                                 P_RECCOD IN VARCHAR,
                                 P_ERRCOD OUT VARCHAR,
                                 P_ERRMSG OUT VARCHAR);

  ---*** Proceso que Envia Mail al Asignar
  PROCEDURE SP_AH_PYC_ASIGNA_EMAIL(P_RECEMP IN NUMBER,
                                   P_RECCOD IN VARCHAR,
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR);

  ---*** Proceso que Genera el Reporte de ReclamosP&C  
  PROCEDURE SP_AH_REP_RECLAMOS_PYC(P_CREUSU IN VARCHAR,
                                   P_RECCOD IN VARCHAR,
                                   P_FECINI IN DATE,
                                   P_FECFIN IN DATE,
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR);

  ---*** Exporta ONR de Cuentas al Sector ONR de P&C (Tarjetas)
  PROCEDURE SP_AH_RECLAMO_ONR_CREAR(P_PGCOD  IN NUMBER,
                                    P_PAI    IN NUMBER,
                                    P_TDC    IN NUMBER,
                                    P_NDC    IN VARCHAR,
                                    P_CREC   IN VARCHAR,
                                    P_ERRCOD OUT VARCHAR,
                                    P_ERRMSG OUT VARCHAR);

  ---*** Obtiene con que TDV se realizo una TRX                                 
  PROCEDURE SP_AH_OBTENER_TDV_TRX(P_PGCOD  IN NUMBER,
                                  P_SUC    IN NUMBER,
                                  P_MOD    IN NUMBER,
                                  P_TRAN   IN NUMBER,
                                  P_NREL   IN NUMBER,
                                  P_FECHA  IN DATE,
                                  P_TARJET OUT VARCHAR,
                                  P_ERRCOD OUT VARCHAR,
                                  P_ERRMSG OUT VARCHAR);

  ---*** Exporta ONR de Cuentas al Sector ONR de P&C (Nueva Version)
  PROCEDURE SP_AH_RECLAMO_ONR_TDV_CREAR(P_PGCOD  IN NUMBER,
                                        P_PAI    IN NUMBER,
                                        P_TDC    IN NUMBER,
                                        P_NDC    IN VARCHAR,
                                        P_CREC   IN VARCHAR,
                                        P_ERRCOD OUT VARCHAR,
                                        P_ERRMSG OUT VARCHAR);

END PQ_AH_RECLAMOS_PYC;
/* GOLDENGATE_DDL_REPLICATION */
/
CREATE OR REPLACE PACKAGE BODY "PQ_AH_RECLAMOS_PYC" IS
  -- ***************************************************************************************
  -- Nombre                     : PROCEDURES PARA LOS RECLAMOS DE ONR (Prevencion & Control)
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.12.22
  -- Autor de Creación          : CVILLON
  -- Uso                        : P&C
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.08.26
  -- Modificado                 : CVILLON
  -- Descripción                : Exportar ONR con TDV - TRX según GUIA - Nueva TRX
  -- ***************************************************************************************
  ---***

  PROCEDURE SP_AH_RECLAMOS_CLIANT(P_FECHOY IN DATE,
                                  P_PAIS   IN NUMBER,
                                  P_TDOC   IN NUMBER,
                                  P_NDOC   IN VARCHAR,
                                  P_NANT   OUT NUMBER,
                                  P_ERRCOD OUT VARCHAR,
                                  P_ERRMSG OUT VARCHAR) IS
  
    ld_FECALT DATE;
    lc_NDOC   CHAR(12);
  
  BEGIN
    ---***
    lc_NDOC := TRIM(P_NDOC);
    ---***
  
    SELECT PEFALT
      INTO ld_FECALT
      FROM FSD001
     WHERE PEPAIS = P_PAIS
       AND PETDOC = P_TDOC
       AND PENDOC = lc_NDOC;
    ---***
    P_NANT := FLOOR(MONTHS_BETWEEN(P_FECHOY, ld_FECALT) / 12);
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      P_NANT := 0;
  END SP_AH_RECLAMOS_CLIANT;

  PROCEDURE SP_AH_PYC_ASIGNARREC(P_CREUSU IN VARCHAR,
                                 P_CREFEC IN DATE,
                                 P_CREHOR IN VARCHAR,
                                 P_RECEMP IN NUMBER,
                                 P_RECCOD IN VARCHAR,
                                 P_ERRCOD OUT VARCHAR,
                                 P_ERRMSG OUT VARCHAR)
  
   IS
    ---***
    lv_PENOM  VARCHAR(90);
    lv_RECRES VARCHAR(600);
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    FOR XROW IN (SELECT *
                   FROM JAQL420
                  WHERE JAQL420EMP = P_RECEMP
                    AND JAQL420COD = P_RECCOD
                    AND JAQL420TRC = 1) LOOP
      SELECT TRIM(PENOM)
        INTO lv_PENOM
        FROM FSD001
       WHERE PEPAIS = XROW.JAQL420PAC
         AND PETDOC = XROW.JAQL420TDC
         AND PENDOC = XROW.JAQL420NDC;
      ---***
      lv_RECRES := SUBSTR(XROW.JAQL420CMR, 0, 599);
      ---***
    
      INSERT INTO AQPD302
        (AQPD302RECEMP,
         AQPD302RECCOD,
         AQPD302RECFCR,
         AQPD302RECPAI,
         AQPD302RECTDO,
         AQPD302RECNDO,
         AQPD302RECCLI,
         AQPD302RECRES,
         AQPD302CREFEC,
         AQPD302CREHOR,
         AQPD302CREUSU,
         AQPD302CRETIM,
         AQPD302EMAILS,
         AQPD302EMAILE)
      VALUES
        (P_RECEMP,
         P_RECCOD,
         XROW.JAQL420FCR,
         XROW.JAQL420PAC,
         XROW.JAQL420TDC,
         XROW.JAQL420NDC,
         lv_PENOM,
         lv_RECRES,
         P_CREFEC,
         P_CREHOR,
         P_CREUSU,
         SYSDATE,
         NULL,
         NULL);
    
    END LOOP;
    ---***
    COMMIT;
    ---***
  
  EXCEPTION
    WHEN OTHERS THEN
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
  END SP_AH_PYC_ASIGNARREC;

  PROCEDURE SP_AH_PYC_ASIGNA_EMAIL(P_RECEMP IN NUMBER,
                                   P_RECCOD IN VARCHAR,
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR) IS
  
    ll_mensaje   CLOB;
    lv_mensaje   VARCHAR2(32767);
    lv_destinos  VARCHAR2(32767) := '';
    lv_contacto  VARCHAR2(200);
    ln_corcar    NUMBER(10) := 0;
    lv_direccion VARCHAR2(200);
    ---***
    lv_asunto    VARCHAR2(30);
    lv_remitente VARCHAR2(90);
    ---***
    ln_check  NUMBER(3);
    ld_RECFCR DATE;
    lv_RECCOD VARCHAR(20);
    ln_PAIS   NUMBER(3);
    ln_TDOC   NUMBER(2);
    lc_NDOC   CHAR(12);
    lv_DOC    VARCHAR(20);
    lv_CLINOM VARCHAR(90);
    lv_RECRES VARCHAR(600);
    ---***
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    SELECT COUNT(*)
      INTO ln_check
      FROM AQPD302
     WHERE AQPD302RECEMP = P_RECEMP
       AND AQPD302RECCOD = P_RECCOD;
  
    IF (ln_check = 0) THEN
      P_ERRCOD := 'NDF';
      P_ERRMSG := '';
      RETURN;
    END IF;
    ---***
  
    SELECT AQPD302RECFCR,
           AQPD302RECCOD,
           AQPD302RECPAI,
           AQPD302RECTDO,
           AQPD302RECNDO,
           AQPD302RECCLI,
           AQPD302RECRES
      INTO ld_RECFCR,
           lv_RECCOD,
           ln_PAIS,
           ln_TDOC,
           lc_NDOC,
           lv_CLINOM,
           lv_RECRES
      FROM AQPD302
     WHERE AQPD302RECEMP = P_RECEMP
       AND AQPD302RECCOD = P_RECCOD;
  
    lv_DOC := TRIM(TO_CHAR(ln_PAIS)) || '-' || TRIM(TO_CHAR(ln_TDOC)) || '-' ||
              TRIM(lc_NDOC);
    ---***
    --SELECT * FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11146 AND TP1CORR1 = 1 AND TP1CORR2 = 71
    --FOR UPDATE
    ---*** ASUNTO
    BEGIN
      SELECT TRIM(tp1desc)
        INTO lv_asunto
        FROM FST198
       WHERE TP1COD = 1
         AND TP1cod1 = 11146
         AND TP1corr1 = 1
         AND TP1corr2 = 71
         AND TP1corr3 = 2;
    EXCEPTION
      when others then
        P_ERRCOD := '102';
        P_ERRMSG := sqlcode || '->>>' || sqlerrm;
        RETURN;
    END;
    ---*** REMITENTE
    BEGIN
      SELECT TRIM(tp1desc)
        INTO lv_remitente
        FROM FST198
       WHERE tp1cod = 1
         AND tp1cod1 = 11146
         AND tp1corr1 = 1
         AND tp1corr2 = 71
         AND tp1corr3 = 1;
    EXCEPTION
      when others then
        P_ERRCOD := '106';
        P_ERRMSG := sqlcode || '->>>' || sqlerrm;
        RETURN;
    END;
  
    lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    --lv_remitente := 'cvillon@cajaarequipa.pe';
    --dbms_output.put_line('lv_remitente: '||lv_remitente);
    --*** DESTINOS
    lv_destinos := NULL;
    --lv_destinos := 'cvillon@cajaarequipa.pe';
    FOR XDEST IN (SELECT TRIM(tp1desc) AS DESTINATARIO
                    FROM FST198
                   WHERE tp1cod = 1
                     AND tp1cod1 = 11146
                     AND tp1corr1 = 1
                     AND tp1corr2 = 71
                     AND tp1corr3 > 2) LOOP
      ---***
      XDEST.DESTINATARIO := TRIM(XDEST.DESTINATARIO) || '@cajaarequipa.pe';
      ---***
      IF (lv_destinos IS NULL) THEN
        lv_destinos := TRIM(XDEST.DESTINATARIO);
        --lv_destinos := 'cvillon@cajaarequipa.pe';
        --dbms_output.put_line('lv_destinos if: ' || lv_destinos);
      ELSE
        lv_destinos := TRIM(XDEST.DESTINATARIO) || ';' || TRIM(lv_destinos);
        --dbms_output.put_line('lv_destinos else: ' || lv_destinos);
      END IF;
    END LOOP;
    ---***
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    ---***
    ---***
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">EL Siguiente Reclamo fue asignado a PyC ...' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">********************************************************************************</p>' ||
                  '<table border = 1>' || '<tbody>' || '<tr>' ||
                  '<td><strong>Fecha de Recepción</strong></td>' || '<td>' ||
                  ld_RECFCR || '</td></tr>' ||
                  '<tr><td><strong>Código</strong></td>' || '<td>' ||
                  lv_RECCOD || '</td></tr>' ||
                  '<tr><td><strong>Documento</strong></td>' || '<td>' ||
                  lv_DOC || '</td></tr>' ||
                  '<tr><td><strong>Cliente</strong></td>' || '<td>' ||
                  lv_CLINOM || '</td></tr>' ||
                  '<tr><td><strong>Resumen</strong></td>' || '<td>' ||
                  lv_RECRES || '</td></tr>';
  
    lv_mensaje := lv_mensaje || '</tbody>' || '</table>';
  
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
          P_ERRCOD := '10S';
          P_ERRMSG := sqlcode || '->>>' || sqlerrm;
      end;
    else
      P_ERRCOD := '00y';
      P_ERRMSG := 'No existe cuenta de correo asociada';
    end if;
  
    dbms_lob.freetemporary(ll_mensaje);
    ---***
    ---***
  exception
    when others then
      P_ERRCOD := '10F';
      P_ERRMSG := sqlcode || '->>>' || sqlerrm;
    
    ---***
    ----dbms_output.put_line('p_c_coderr: '||p_c_coderr);
    ----dbms_output.put_line('p_c_deserr: '||p_c_deserr);
    ---***
  
  END SP_AH_PYC_ASIGNA_EMAIL;

  PROCEDURE SP_AH_REP_RECLAMOS_PYC(P_CREUSU IN VARCHAR,
                                   P_RECCOD IN VARCHAR,
                                   P_FECINI IN DATE,
                                   P_FECFIN IN DATE,
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR) IS
  
    ---***
    ln_ROWNUM NUMBER(9);
    lc_CREUSU CHAR(10);
  
    lv_CTA        VARCHAR(30);
    lv_CANAL      VARCHAR(40);
    lv_TIPOLOGIA  VARCHAR(30);
    lv_ESTADO     VARCHAR(100);
    lv_PAGORAPIDO VARCHAR(30);
    lv_DEVPOR     VARCHAR(30);
  
    lv_RECCOD VARCHAR(20);
    lv_RECINI VARCHAR(20);
    lv_RECFIN VARCHAR(20);
    ---*********
    ln_ACCION NUMBER(3);
    lv_ACCION VARCHAR(30);
    ln_TIPO   NUMBER(3);
    lv_TIPO   VARCHAR(30);
    lv_CONCLU VARCHAR(30);
    lv_TDNOM  VARCHAR(20);
  
    lv_MODALIDAD VARCHAR(100);
    lv_ACT       VARCHAR(30);
    lv_AGENOM    VARCHAR(30);
    ---*********
    lv_RECRES VARCHAR(1000);
    ---*********
    ---***
  BEGIN
    ---***
    P_ERRCOD  := '000';
    P_ERRMSG  := '';
    lv_RECCOD := TRIM(P_RECCOD);
  
    ln_ROWNUM := 0;
    lc_CREUSU := TRIM(P_CREUSU);
    ---***
    --INSERT INTO TEST_PYC VALUES(SYSDATE, P_CREUSU, P_RECCOD, P_FECINI, P_FECFIN, P_ERRCOD, P_ERRMSG);
    DELETE FROM AQPD301 WHERE AQPD301CREUSU = lc_CREUSU;
    COMMIT;
    ---***
    ---***
    IF (lv_RECCOD IS NULL) THEN
      lv_RECINI := 'R';
      lv_RECFIN := 'Z';
    ELSE
      lv_RECINI := lv_RECCOD;
      lv_RECFIN := lv_RECCOD;
    END IF;
    ---***
    FOR XROW IN (SELECT j420.*,
                        j759.JAQZ759NTAR,
                        f001.PENOM,
                        
                        --SELECT * FROM JAQL420
                        CASE
                          WHEN j759.JAQZ759MODUL = 21 THEN
                           lpad(j759.JAQZ759CTA, 9, '0') ||
                           lpad(j759.JAQZ759MODUL, 3, '0') ||
                           lpad(j759.JAQZ759MDA, 3, '0') ||
                           lpad(j759.JAQZ759SCT, 2, '0') ||
                           lpad(j759.JAQZ759TOPER, 3, '0')
                          ELSE
                           '-'
                        END AS CUENTA,
                        
                        j421.JAQL421DES    AS PRODUCTO,
                        j759.JAQZ759FCON,
                        j759.JAQZ759HRC,
                        j759.JAQZ759CIMP1,
                        f005.MOSIGN,
                        f034.TRNOM,
                        j759.JAQZ759ESTABL,
                        j759.JAQZ759CODAUT,
                        j759.JAQZ759CAN,
                        
                        j759.JAQZ759EST,
                        j759.JAQZ759PAGORA,
                        j759.JAQZ759DEVOLU,
                        ---***
                        j759.JAQZ759MOD,
                        j759.JAQZ759TIPOLO,
                        a301.*,
                        a302.*
                 ---***
                 
                   FROM JAQL420 j420
                   LEFT JOIN AQPD301A a301
                     ON (j420.JAQL420EMP = a301.AQPD301ARECEMP AND
                        j420.JAQL420COD = a301.AQPD301ARECCOD)
                   LEFT JOIN JAQZ759 j759
                     ON (j420.JAQL420COD = j759.JAQZ759CREC)
                   JOIN FSD001 f001
                     ON (j420.JAQL420PAC = f001.PEPAIS AND
                        j420.JAQL420TDC = f001.PETDOC AND
                        j420.JAQL420NDC = f001.PENDOC)
                   JOIN JAQL421 j421
                     ON (j420.JAQL420OPS = j421.JAQL421COD)
                   JOIN FST005 f005
                     ON (j759.JAQZ759MDA = f005.MONEDA)
                   JOIN FST034 f034
                     ON (f034.PGCOD = 1 AND j759.JAQZ759CMOD = f034.TRMOD AND
                        j759.JAQZ759TRAN = f034.TRNRO)
                   LEFT JOIN AQPD302 a302
                     ON (j420.JAQL420EMP = a302.AQPD302RECEMP AND
                        j420.JAQL420COD = a302.AQPD302RECCOD)
                  WHERE j420.JAQL420TRC = 1
                    AND JAQL420MOT = 257
                    AND ((j420.JAQL420COD BETWEEN lv_RECINI AND lv_RECFIN) AND
                        (j420.JAQL420FCR BETWEEN P_FECINI AND P_FECFIN))) LOOP
      ---***
      ln_ROWNUM := ln_ROWNUM + 1;
      ---***
      ---*** ACCION, TIPO
      -- SELECT * FROM AQPD301A
      BEGIN
        SELECT TRIM(TP1DESC)
          INTO lv_ACCION
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 69
           AND TP1CORR3 > 0
           AND TP1NRO1 = 1
           AND TP1CORR3 = XROW.AQPD301AACCION;
      EXCEPTION
        WHEN OTHERS THEN
          lv_ACCION := '-';
      END;
    
      BEGIN
        SELECT TRIM(TP1DESC)
          INTO lv_TIPO
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 69
           AND TP1CORR3 > 0
           AND TP1NRO1 = 2
           AND TP1CORR3 = XROW.AQPD301ATIPO;
      EXCEPTION
        WHEN OTHERS THEN
          lv_TIPO := '-';
      END;
    
      CASE
        WHEN XROW.JAQZ759CAN = 1 THEN
          lv_CANAL := 'Ventanilla';
        WHEN XROW.JAQZ759CAN = 2 THEN
          lv_CANAL := 'POS';
        WHEN XROW.JAQZ759CAN = 3 THEN
          lv_CANAL := 'Cajero Automático';
        WHEN XROW.JAQZ759CAN = 4 THEN
          lv_CANAL := 'Cajero Corresponsal';
        WHEN XROW.JAQZ759CAN = 5 THEN
          lv_CANAL := 'Teléfono Fijo/Fax';
        WHEN XROW.JAQZ759CAN = 6 THEN
          lv_CANAL := 'Teléfono Móvil';
        WHEN XROW.JAQZ759CAN = 7 THEN
          lv_CANAL := 'Internet - Home Banking';
        WHEN XROW.JAQZ759CAN = 8 THEN
          lv_CANAL := 'Internet - Otros';
        WHEN XROW.JAQZ759CAN = 9 THEN
          lv_CANAL := 'Otros';
        ELSE
          lv_CANAL := '-';
      END CASE;
    
      BEGIN
        SELECT TRIM(TP1DESC)
          INTO lv_TIPOLOGIA
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 66
           AND TP1CORR3 = XROW.JAQZ759TIPOLO;
      EXCEPTION
        WHEN OTHERS THEN
          lv_TIPOLOGIA := '-';
      END;
    
      BEGIN
        SELECT TRIM(JAQZ759MDES)
          INTO lv_MODALIDAD
          FROM JAQZ759M
         WHERE JAQZ759MCOD = XROW.JAQZ759MOD;
      EXCEPTION
        WHEN OTHERS THEN
          lv_MODALIDAD := '-';
      END;
    
      /*
      SELECT JAQZ759MDES INTO lv_ESTADO
      FROM JAQZ759M
      WHERE JAQZ759MCOD = XROW.JAQZ759EST;
      */
      --SELECT * FROM JAQZ759M
    
      -- PAGO RAPIDO
      BEGIN
        SELECT TRIM(TP1DESC)
          INTO lv_PAGORAPIDO
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 67
           AND TP1CORR3 = XROW.JAQZ759PAGORA;
      EXCEPTION
        WHEN OTHERS THEN
          lv_PAGORAPIDO := '-';
      END;
    
      -- DEVUELTO POR
      BEGIN
        SELECT TRIM(TP1DESC)
          INTO lv_DEVPOR
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 68
           AND TP1CORR3 = XROW.JAQZ759DEVOLU;
      EXCEPTION
        WHEN OTHERS THEN
          lv_DEVPOR := '-';
      END;
      --
    
      -- CONCLUSION
      BEGIN
        SELECT TRIM(TP1DESC)
          INTO lv_CONCLU
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 69
           AND TP1CORR3 > 0
           AND TP1NRO1 = 3
           AND TP1CORR3 = XROW.AQPD301ACONCLU;
      EXCEPTION
        WHEN OTHERS THEN
          lv_CONCLU := '-';
      END;
      -- ACCIONES TOMADAS 
      BEGIN
        SELECT TRIM(TP1DESC)
          INTO lv_ACT
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 10871
           AND TP1CORR1 = 3
           AND TP1CORR2 = 8
           AND TP1NRO1 = 1
           AND TP1CORR3 = XROW.JAQL420ACT;
      EXCEPTION
        WHEN OTHERS THEN
          lv_ACT := '-';
      END;
      ---***
      BEGIN
        SELECT TRIM(TDNOM)
          INTO lv_TDNOM
          FROM FST014
         WHERE TDOCUM = XROW.JAQL420TDC;
      EXCEPTION
        WHEN OTHERS THEN
          lv_TDNOM := '-';
      END;
      ---***
      BEGIN
        SELECT SCNOM
          INTO lv_AGENOM
          FROM FST001
         WHERE PGCOD = XROW.JAQL420EMP
           AND SUCURS = XROW.JAQL420AGE;
      EXCEPTION
        WHEN OTHERS THEN
          lv_AGENOM := '-';
      END;
      ---***
      -- SELECT * FROM AQPD301A
      -- SELECT * FROM JAQL420
      -- SELECT * FROM JAQZ759
      ---***
      lv_RECRES := SUBSTR(XROW.JAQL420RECRES, 0, 999);
      ---***
      INSERT INTO AQPD301
        (AQPD301CREUSU,
         AQPD301CRETIM,
         AQPD301ROWNUM,
         AQPD301ACCCOD,
         AQPD301ACCDES,
         AQPD301TIPCOP,
         AQPD301TIPDEP,
         AQPD301USUING,
         AQPD301RECFCR,
         AQPD301FECASI,
         AQPD301HORASI,
         AQPD301RECCOD,
         AQPD301AGECOD,
         AQPD301AGENOM,
         AQPD301CANINC,
         AQPD301CANIND,
         AQPD301NROTAR,
         AQPD301RECPAI,
         AQPD301RECTDO,
         AQPD301TDODES,
         AQPD301RECNDO,
         AQPD301CLINOM,
         AQPD301CLICAJ,
         AQPD301SEGAHO,
         AQPD301SEGNEG,
         AQPD301RECDET,
         AQPD301CUENTA,
         AQPD301PRODUC,
         AQPD301RECCEL,
         AQPD301RECEML,
         AQPD301TRXFEC,
         AQPD301TRXHOR,
         AQPD301TRXMON,
         AQPD301TRXMND,
         AQPD301TRXNOM,
         AQPD301ESTABL,
         AQPD301CODAUT,
         AQPD301TCANAL,
         AQPD301PAGORC,
         AQPD301PAGORA,
         AQPD301DEVPOC,
         AQPD301DEVPOR,
         AQPD301TIESEG,
         AQPD301CONCOD,
         AQPD301CONDES,
         AQPD301TIPCOD,
         AQPD301TIPDES,
         AQPD301ANALIS,
         AQPD301FECRES,
         AQPD301RESPON,
         AQPD301MODCOD,
         AQPD301MODDES,
         AQPD301TIPOLC,
         AQPD301TIPOLD,
         AQPD301ACCTOM,
         AQPD301RECFCC,
         AQPD301RECRES,
         AQPD301USURES,
         AQPD301GESASI)
      VALUES
        (lc_CREUSU,
         SYSDATE,
         ln_ROWNUM,
         XROW.AQPD301AACCION,
         lv_ACCION,
         XROW.AQPD301ATIPO,
         lv_TIPO,
         XROW.JAQL420USR,
         XROW.JAQL420FCR,
         XROW.AQPD302CREFEC,
         XROW.AQPD302CREHOR,
         XROW.JAQL420COD,
         XROW.JAQL420AGE,
         lv_AGENOM,
         XROW.JAQL420CANING,
         XROW.JAQL420CANIND,
         XROW.JAQZ759NTAR,
         XROW.JAQL420PAC,
         XROW.JAQL420TDC,
         lv_TDNOM,
         XROW.JAQL420NDC,
         XROW.PENOM,
         'SI',
         XROW.JAQL420SEGAHO,
         XROW.JAQL420SEGNEG,
         XROW.JAQL420CMR,
         XROW.CUENTA,
         XROW.PRODUCTO,
         XROW.JAQL420CEL,
         XROW.JAQL420EML,
         XROW.JAQZ759FCON,
         XROW.JAQZ759HRC,
         XROW.JAQZ759CIMP1,
         XROW.MOSIGN,
         XROW.TRNOM,
         XROW.JAQZ759ESTABL,
         XROW.JAQZ759CODAUT,
         XROW.JAQZ759CAN,
         XROW.JAQZ759PAGORA,
         lv_PAGORAPIDO,
         XROW.JAQZ759DEVOLU,
         lv_DEVPOR,
         XROW.AQPD301ASEGURO,
         XROW.AQPD301ACONCLU,
         lv_CONCLU,
         XROW.AQPD301ATIPO,
         lv_TIPO,
         XROW.AQPD301AANALIS,
         XROW.AQPD301AFECRES,
         XROW.AQPD301ARESPON,
         XROW.JAQZ759MOD,
         lv_MODALIDAD,
         XROW.JAQZ759TIPOLO,
         lv_TIPOLOGIA,
         lv_ACT,
         XROW.JAQL420FCC,
         lv_RECRES,
         XROW.JAQL420USC,
         XROW.JAQL420GESASI);
    
    ---***
    END LOOP;
    ---***
    COMMIT;
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RECLAMOS_PYC;

  PROCEDURE SP_AH_RECLAMO_ONR_CREAR(P_PGCOD  IN NUMBER,
                                    P_PAI    IN NUMBER,
                                    P_TDC    IN NUMBER,
                                    P_NDC    IN VARCHAR,
                                    P_CREC   IN VARCHAR,
                                    P_ERRCOD OUT VARCHAR,
                                    P_ERRMSG OUT VARCHAR) IS
    ---***
    lc_NDC             CHAR(12);
    ln_CheckTRX        NUMBER(3);
    lv_Establecimiento VARCHAR(90);
    lv_CODAUTH         VARCHAR(20);
    ---***
    ln_CANAL  NUMBER(3);
    ln_ORD    NUMBER(2);
    lv_ERRMSG VARCHAR(600);
    ---***
  BEGIN
    ---***
    P_ERRCOD  := '000';
    P_ERRMSG  := '';
    lc_NDC    := TRIM(P_NDC);
    lv_ERRMSG := '-';
    ---***
    FOR XROW IN (SELECT *
                   FROM AQPB545
                  WHERE AQPB545PGCOD = P_PGCOD
                    AND AQPB545PAI = P_PAI
                    AND AQPB545TDC = P_TDC
                    AND AQPB545NDC = lc_NDC
                    AND AQPB545CREC = P_CREC) LOOP
      ---***
      ---*** SOLO SI LA OPERACION ESTA EN LA GUIA DE TRX CON TDV
      ---***
      ln_CANAL := 0;
      ln_ORD   := 0;
      ---***
      BEGIN
        SELECT TP1CORR1, TP1NRO3
          INTO ln_CANAL, ln_ORD
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11009
           AND TP1NRO1 = XROW.AQPB545MOD
           AND TP1NRO2 = XROW.AQPB545TRAN
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          ln_CANAL := 0;
      END;
    
      IF (ln_CANAL = 0) THEN
        P_ERRCOD := '003';
      
        IF (NVL(TRIM(lv_ERRMSG), '-') = '-') THEN
          lv_ERRMSG := '(ONR) TRX No Parametrizadas: ' || XROW.AQPB545MOD || '/' ||
                       XROW.AQPB545TRAN;
        ELSE
          lv_ERRMSG := lv_ERRMSG || '; ' || XROW.AQPB545MOD || '/' ||
                       XROW.AQPB545TRAN;
        END IF;
        ---***
        CONTINUE;
        ---***
      ELSE
        ---*** Tarj. del Cliente
        FOR TROW IN (SELECT *
                       FROM (SELECT *
                               FROM Z0E478
                              WHERE Z0E478THP = P_PAI
                                AND Z0E478THT = P_TDC
                                AND Z0E478THD = lc_NDC
                              ORDER BY Z0E478FAU DESC)
                      WHERE ROWNUM = 1) LOOP
          --SELECT * FROM AQPB545
          --Z0E478NRO, Z0E479SUC, Z0E479CTA, Z0E479SCT, Z0E479MOD, Z0E479MON, Z0E479PAP, Z0E479TOP, Z0E479OPE
          FOR CROW IN (SELECT *
                         FROM Z0E479
                        WHERE Z0E478NRO = TROW.Z0E478NRO
                          AND Z0E479SUC = XROW.AQPB545SUCUR
                          AND Z0E479CTA = XROW.AQPB545CTA
                          AND Z0E479SCT = XROW.AQPB545SUBOP
                          AND Z0E479MOD = XROW.AQPB545MODUL
                          AND Z0E479MON = XROW.AQPB545MDA
                          AND Z0E479PAP = XROW.AQPB545PAP
                          AND Z0E479TOP = XROW.AQPB545TOPER
                          AND Z0E479OPE = XROW.AQPB545OPER
                          AND ROWNUM = 1) LOOP
          
            ---*** ESTABLECIMIENTO
            BEGIN
              SELECT TRIM(TXTORD)
                INTO lv_Establecimiento
                FROM FSX016
               WHERE PGCOD = 1
                 AND Hcmod = XROW.AQPB545MOD
                 AND Hsucor = XROW.AQPB545SUCOR
                 AND Htran = XROW.AQPB545TRAN
                 AND Hnrel = XROW.AQPB545NREL
                 AND Hfcon = XROW.AQPB545FCON
                 AND Hcord = XROW.AQPB545ORD
                 AND Hcsubo = XROW.AQPB545SUBOP
                 AND Txcod = 173
                 AND Txoren = 1;
            EXCEPTION
              WHEN OTHERS THEN
                lv_Establecimiento := '-';
            END;
            ---*** Cod Auth
            BEGIN
              SELECT TRIM(TXTORD)
                INTO lv_CODAUTH
                FROM FSX016
               WHERE PGCOD = 1
                 AND Hcmod = XROW.AQPB545MOD
                 AND Hsucor = XROW.AQPB545SUCOR
                 AND Htran = XROW.AQPB545TRAN
                 AND Hnrel = XROW.AQPB545NREL
                 AND Hfcon = XROW.AQPB545FCON
                 AND Hcord = XROW.AQPB545ORD
                 AND Hcsubo = XROW.AQPB545SUBOP
                 AND Txcod = 174
                 AND Txoren = 1;
            EXCEPTION
              WHEN OTHERS THEN
                lv_CODAUTH := '-';
            END;
          
            INSERT INTO JAQZ759
              (JAQZ759NTAR,
               JAQZ759PAI,
               JAQZ759TDC,
               JAQZ759NDC,
               JAQZ759CMOD,
               JAQZ759SUCOR,
               JAQZ759TRAN,
               JAQZ759NREL,
               JAQZ759CORD,
               JAQZ759FCON,
               JAQZ759CREC,
               JAQZ759CIMP1,
               JAQZ759MODUL,
               JAQZ759OPER,
               JAQZ759SCT,
               JAQZ759CTA,
               JAQZ759PAP,
               JAQZ759MDA,
               JAQZ759SUCUR,
               JAQZ759TOPER,
               JAQZ759MOD,
               JAQZ759IMP,
               JAQZ759EST,
               JAQZ759CAN,
               JAQZ759EXT,
               JAQZ759HRC,
               JAQZ759TIPOLO,
               JAQZ759CODAUT,
               JAQZ759ESTABL,
               JAQZ759PAGORA,
               JAQZ759DEVOLU)
            VALUES
              (CROW.Z0E478NRO,
               XROW.AQPB545PAI,
               XROW.AQPB545TDC,
               XROW.AQPB545NDC,
               XROW.AQPB545MOD,
               XROW.AQPB545SUCOR,
               XROW.AQPB545TRAN,
               XROW.AQPB545NREL,
               ln_ORD,
               XROW.AQPB545FCON,
               XROW.AQPB545CREC,
               XROW.AQPB545IMP1,
               XROW.AQPB545MODUL,
               XROW.AQPB545OPER,
               XROW.AQPB545SUBOP,
               XROW.AQPB545CTA,
               XROW.AQPB545PAP,
               XROW.AQPB545MDA,
               XROW.AQPB545SUCUR,
               XROW.AQPB545TOPER,
               6,
               0,
               101,
               ln_CANAL,
               0,
               XROW.AQPB545HORA,
               14,
               lv_CODAUTH,
               lv_Establecimiento,
               3,
               1);
          END LOOP;
        END LOOP;
      END IF;
    END LOOP;
    ---***
    P_ERRMSG := lv_ERRMSG;
    ---***
    COMMIT;
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_RECLAMO_ONR_CREAR;

  ---*** Obtiene con que TDV se realizo una TRX                                 
  PROCEDURE SP_AH_OBTENER_TDV_TRX(P_PGCOD  IN NUMBER,
                                  P_SUC    IN NUMBER,
                                  P_MOD    IN NUMBER,
                                  P_TRAN   IN NUMBER,
                                  P_NREL   IN NUMBER,
                                  P_FECHA  IN DATE,
                                  P_TARJET OUT VARCHAR,
                                  P_ERRCOD OUT VARCHAR,
                                  P_ERRMSG OUT VARCHAR) IS
  
    ---*********
    ld_HOY DATE;
    ---*********
  
  BEGIN
    ---*** 
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    BEGIN
      SELECT PGFAPE INTO ld_HOY FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        RETURN;
    END;
    ---***
    P_TARJET := 'TRX-NF';
    ---***
  
    --- 66 -> FSH016/FSD016
    -- Debe ser P_FECHA < ld_HOY, Pero para DESA <>
    IF (P_MOD = 66) THEN
      IF (P_FECHA <> ld_HOY) THEN
        BEGIN
          SELECT SUBSTR(TRIM(HCREF), 0, 16)
            INTO P_TARJET
            FROM FSH016
           WHERE PGCOD = P_PGCOD
             AND HSUCOR = P_SUC
             AND HCMOD = P_MOD
             AND HTRAN = P_TRAN
             AND HNREL = P_NREL
             AND HFCON = P_FECHA
             AND HCREF IS NOT NULL
             AND HCREF <> ' '
             AND HCREF LIKE '42%'
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            P_TARJET := 'TDV-NF';
        END;
      END IF;
      -- Diario 
      IF (P_FECHA = ld_HOY) THEN
        BEGIN
          SELECT SUBSTR(TRIM(ITREF), 0, 16)
            INTO P_TARJET
            FROM FSD016
           WHERE PGCOD = P_PGCOD
             AND ITSUC = P_SUC
             AND ITMOD = P_MOD
             AND ITTRAN = P_TRAN
             AND ITNREL = P_NREL
             AND ITREF IS NOT NULL
             AND ITREF <> ' '
             AND ITREF LIKE '42%'
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            P_TARJET := 'TDV-NF';
        END;
      END IF;
    END IF;
  
    --- 489,140 -> FSX015
    IF (P_MOD = 489 OR P_MOD = 140) THEN
      BEGIN
        SELECT SUBSTR(TRIM(TXTEXT), 0, 16)
          INTO P_TARJET
          FROM FSX015
         WHERE PGCOD = P_PGCOD
           AND HSUCOR = P_SUC
           AND HCMOD = P_MOD
           AND HTRAN = P_TRAN
           AND HNREL = P_NREL
           AND HFCON = P_FECHA
           AND TXCOD = 100
           AND TXTEXT IS NOT NULL
           AND TXTEXT <> ' '
           AND TXTEXT LIKE '42%'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          P_TARJET := 'TDV-NF';
      END;
    END IF;
  
    --- 490 -> JAQL006
    IF (P_MOD = 490) THEN
      BEGIN
        SELECT SUBSTR(TRIM(JAQL6NUTAR), 0, 16)
          INTO P_TARJET
          FROM JAQL006
         WHERE JAQL6FETRA = P_FECHA
           AND JAQL6CTCOD = P_PGCOD
           AND JAQL6CTSUC = P_SUC
           AND JAQL6CTMOD = P_MOD
           AND JAQL6CTTRA = P_TRAN
           AND JAQL6CTREL = P_NREL
           AND JAQL6NUTAR IS NOT NULL
           AND JAQL6NUTAR <> ' '
           AND JAQL6NUTAR LIKE '42%'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          P_TARJET := 'TDV-NF';
      END;
    END IF;
  
    --- 493 -> JAQL674
    IF (P_MOD = 493) THEN
      BEGIN
        SELECT SUBSTR(TRIM(JAQL674NUTAR), 0, 16)
          INTO P_TARJET
          FROM JAQL674
         WHERE JAQL674FETRA = P_FECHA
           AND JAQL674CTCOD = P_PGCOD
           AND JAQL674CTSUC = P_SUC
           AND JAQL674CTMOD = P_MOD
           AND JAQL674CTTRA = P_TRAN
           AND JAQL674CTREL = P_NREL
           AND JAQL674NUTAR IS NOT NULL
           AND JAQL674NUTAR <> ' '
           AND JAQL674NUTAR LIKE '42%'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          P_TARJET := 'TDV-NF';
      END;
    END IF;
  
    --- 50 -> FSX016
    IF (P_MOD = 50) THEN
      BEGIN
        SELECT SUBSTR(TRIM(TXTORD), 0, 16)
          INTO P_TARJET
          FROM FSX016
         WHERE PGCOD = P_PGCOD
           AND HSUCOR = P_SUC
           AND HCMOD = P_MOD
           AND HTRAN = P_TRAN
           AND HNREL = P_NREL
           AND HFCON = P_FECHA
           AND TXTORD IS NOT NULL
           AND TXTORD <> ' '
           AND TXTORD LIKE '42%'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          P_TARJET := 'TDV-NF';
      END;
    END IF;
  
  END SP_AH_OBTENER_TDV_TRX;

  PROCEDURE SP_AH_RECLAMO_ONR_TDV_CREAR(P_PGCOD  IN NUMBER,
                                        P_PAI    IN NUMBER,
                                        P_TDC    IN NUMBER,
                                        P_NDC    IN VARCHAR,
                                        P_CREC   IN VARCHAR,
                                        P_ERRCOD OUT VARCHAR,
                                        P_ERRMSG OUT VARCHAR) IS
    ---***
    lc_NDC             CHAR(12);
    ln_CheckTRX        NUMBER(3);
    lv_Establecimiento VARCHAR(90);
    lv_CODAUTH         VARCHAR(20);
    lv_TARJET          VARCHAR(30);
    ---***
    ln_CANAL  NUMBER(3);
    ln_ORD    NUMBER(2);
    lv_ERRMSG VARCHAR(600);
    ---***
  BEGIN
    ---***
    P_ERRCOD  := '000';
    P_ERRMSG  := '';
    lc_NDC    := TRIM(P_NDC);
    lv_ERRMSG := '-';
    ---***
    ---*** Eliminamos previamente posibles registros
    DELETE FROM JAQZ759
     WHERE JAQZ759PAI = P_PAI
       AND JAQZ759TDC = P_TDC
       AND JAQZ759NDC = lc_NDC
       AND JAQZ759CREC = P_CREC;
    COMMIT;
    ---***
    FOR XROW IN (SELECT *
                   FROM AQPB545
                  WHERE AQPB545PGCOD = P_PGCOD
                    AND AQPB545PAI = P_PAI
                    AND AQPB545TDC = P_TDC
                    AND AQPB545NDC = lc_NDC
                    AND AQPB545CREC = P_CREC) LOOP
      ---***
      ---*** SOLO SI LA OPERACION ESTA EN LA GUIA DE TRX CON TDV
      ---***
      ln_CANAL := 0;
      ln_ORD   := 0;
      ---***
      BEGIN
        SELECT TP1CORR1, TP1NRO3
          INTO ln_CANAL, ln_ORD
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11009
           AND TP1NRO1 = XROW.AQPB545MOD
           AND TP1NRO2 = XROW.AQPB545TRAN
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          ln_CANAL := 0;
      END;
    
      IF (ln_CANAL = 0) THEN
        P_ERRCOD := '003';
      
        IF (NVL(TRIM(lv_ERRMSG), '-') = '-') THEN
          lv_ERRMSG := '(ONR) TRX No Parametrizadas: ' || XROW.AQPB545MOD || '/' ||
                       XROW.AQPB545TRAN;
        ELSE
          lv_ERRMSG := lv_ERRMSG || '; ' || XROW.AQPB545MOD || '/' ||
                       XROW.AQPB545TRAN;
        END IF;
        ---***
        CONTINUE;
        ---***
      ELSE
        ---*** Tarjeta de la TRX
        ---***
        SP_AH_OBTENER_TDV_TRX(P_PGCOD,
                              XROW.AQPB545SUCOR,
                              XROW.AQPB545MOD,
                              XROW.AQPB545TRAN,
                              XROW.AQPB545NREL,
                              XROW.AQPB545FCON,
                              lv_TARJET,
                              P_ERRCOD,
                              P_ERRMSG);
      
        ---***
        ---*** ESTABLECIMIENTO
        BEGIN
          SELECT TRIM(TXTORD)
            INTO lv_Establecimiento
            FROM FSX016
           WHERE PGCOD = 1
             AND Hcmod = XROW.AQPB545MOD
             AND Hsucor = XROW.AQPB545SUCOR
             AND Htran = XROW.AQPB545TRAN
             AND Hnrel = XROW.AQPB545NREL
             AND Hfcon = XROW.AQPB545FCON
             AND Hcord = XROW.AQPB545ORD
             AND Hcsubo = XROW.AQPB545SUBOP
             AND Txcod = 173
             AND Txoren = 1;
        EXCEPTION
          WHEN OTHERS THEN
            lv_Establecimiento := '-';
        END;
        ---*** Cod Auth
        BEGIN
          SELECT TRIM(TXTORD)
            INTO lv_CODAUTH
            FROM FSX016
           WHERE PGCOD = 1
             AND Hcmod = XROW.AQPB545MOD
             AND Hsucor = XROW.AQPB545SUCOR
             AND Htran = XROW.AQPB545TRAN
             AND Hnrel = XROW.AQPB545NREL
             AND Hfcon = XROW.AQPB545FCON
             AND Hcord = XROW.AQPB545ORD
             AND Hcsubo = XROW.AQPB545SUBOP
             AND Txcod = 174
             AND Txoren = 1;
        EXCEPTION
          WHEN OTHERS THEN
            lv_CODAUTH := '-';
        END;
      
        INSERT INTO JAQZ759
          (JAQZ759NTAR,
           JAQZ759PAI,
           JAQZ759TDC,
           JAQZ759NDC,
           JAQZ759CMOD,
           JAQZ759SUCOR,
           JAQZ759TRAN,
           JAQZ759NREL,
           JAQZ759CORD,
           JAQZ759FCON,
           JAQZ759CREC,
           JAQZ759CIMP1,
           JAQZ759MODUL,
           JAQZ759OPER,
           JAQZ759SCT,
           JAQZ759CTA,
           JAQZ759PAP,
           JAQZ759MDA,
           JAQZ759SUCUR,
           JAQZ759TOPER,
           JAQZ759MOD,
           JAQZ759IMP,
           JAQZ759EST,
           JAQZ759CAN,
           JAQZ759EXT,
           JAQZ759HRC,
           JAQZ759TIPOLO,
           JAQZ759CODAUT,
           JAQZ759ESTABL,
           JAQZ759PAGORA,
           JAQZ759DEVOLU,
           JAQZ759VCTA)
        VALUES
          (lv_TARJET,
           XROW.AQPB545PAI,
           XROW.AQPB545TDC,
           XROW.AQPB545NDC,
           XROW.AQPB545MOD,
           XROW.AQPB545SUCOR,
           XROW.AQPB545TRAN,
           XROW.AQPB545NREL,
           ln_ORD,
           XROW.AQPB545FCON,
           XROW.AQPB545CREC,
           XROW.AQPB545IMP1,
           XROW.AQPB545MODUL,
           XROW.AQPB545OPER,
           XROW.AQPB545SUBOP,
           XROW.AQPB545CTA,
           XROW.AQPB545PAP,
           XROW.AQPB545MDA,
           XROW.AQPB545SUCUR,
           XROW.AQPB545TOPER,
           6,
           0,
           101,
           ln_CANAL,
           0,
           XROW.AQPB545HORA,
           14,
           lv_CODAUTH,
           lv_Establecimiento,
           3,
           1,
           XROW.AQPB545AUCHA1);
      END IF;
    END LOOP;
    ---***
    P_ERRMSG := lv_ERRMSG;
    ---***
    COMMIT;
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_RECLAMO_ONR_TDV_CREAR;

END PQ_AH_RECLAMOS_PYC;
/
