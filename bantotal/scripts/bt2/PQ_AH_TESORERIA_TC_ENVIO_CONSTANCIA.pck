CREATE OR REPLACE PACKAGE PQ_AH_TESORERIA_TC_ENVIO_CONSTANCIA IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_TESORERIA_TC_ENVIO_CONSTANCIA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.10.15
  -- Autor de Creación          : CVILLON
  -- Uso                        : PROCEDURES PARA PROCESO de Envio de Constancia Ope. TC - TESORERIA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.10.15
  -- Modificado                 : CVILLON
  -- Descripción                : Version Inicial
  -- ***************************************************************************************
  ---***
  ---*** Obtiene Correo(s) de Tabla AQPA210A
  PROCEDURE SP_AH_OBTENER_CORREO_AQPA210A(P_AQPA210APJPAIS IN NUMBER,
                                          P_AQPA210APJTDOC IN NUMBER,
                                          P_AQPA210APJNDOC IN VARCHAR,
                                          P_CORREOS        OUT VARCHAR,
                                          P_ERRCOD         OUT VARCHAR,
                                          P_ERRMSG         OUT VARCHAR);

  PROCEDURE SP_AH_ENVIAR_CORREO(P_PAIS    IN NUMBER,
                                P_TDOC    IN NUMBER,
                                P_NDOC    IN VARCHAR,
                                P_FECH    IN DATE,
                                P_CREUSR  IN VARCHAR,
                                P_CORREOS IN VARCHAR,
                                P_ARCHIVO IN VARCHAR,
                                P_OPEMOD  IN NUMBER,
                                P_OPETRA  IN NUMBER,
                                P_OPEREL  IN NUMBER,
                                P_ERRCOD  OUT VARCHAR,
                                P_ERRMSG  OUT VARCHAR);

  PROCEDURE SP_AH_GENERA_CONSTANCIA(P_PAIS        IN NUMBER,
                                    P_TDOC        IN NUMBER,
                                    P_NDOC        IN VARCHAR,
                                    P_FECH        IN DATE,
                                    P_CORREOS     IN VARCHAR,
                                    P_OPEMOD      IN NUMBER,
                                    P_OPETRA      IN NUMBER,
                                    P_OPEREL      IN NUMBER,
                                    P_FECHA_STR   OUT VARCHAR,
                                    P_CLIENTE_STR OUT VARCHAR,
                                    P_TIPOPE_STR  OUT VARCHAR,
                                    P_TRX_STR     OUT VARCHAR,
                                    P_ERRCOD      OUT VARCHAR,
                                    P_ERRMSG      OUT VARCHAR);

  PROCEDURE SP_AH_OBTENER_FECHA_STR(P_FECHA     IN DATE,
                                    P_FECHA_STR OUT VARCHAR);

END PQ_AH_TESORERIA_TC_ENVIO_CONSTANCIA;
/
CREATE OR REPLACE PACKAGE BODY PQ_AH_TESORERIA_TC_ENVIO_CONSTANCIA IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_TESORERIA_TC_ENVIO_CONSTANCIA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.10.15
  -- Autor de Creación          : CVILLON
  -- Uso                        : PROCEDURES PARA PROCESO de Envio de Constancia Ope. TC - TESORERIA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.10.15
  -- Modificado                 : CVILLON
  -- Descripción                : Version Inicial
  -- ***************************************************************************************
  ---***
  ---*** Obtiene Correo(s) de Tabla AQPA210A
  PROCEDURE SP_AH_OBTENER_CORREO_AQPA210A(P_AQPA210APJPAIS IN NUMBER,
                                          P_AQPA210APJTDOC IN NUMBER,
                                          P_AQPA210APJNDOC IN VARCHAR,
                                          P_CORREOS        OUT VARCHAR,
                                          P_ERRCOD         OUT VARCHAR,
                                          P_ERRMSG         OUT VARCHAR) IS
    ---***                                        
    lv_CORREO         VARCHAR(200);
    ln_CORREO         NUMBER(3);
    lc_AQPA210APJNDOC CHAR(12);
    ---***
  
  BEGIN
    ---***  
    lv_CORREO := '';
    ln_CORREO := 0;
    P_ERRCOD  := '000';
    P_ERRMSG  := '';
    ---***
    lc_AQPA210APJNDOC := TRIM(P_AQPA210APJNDOC);
    ---***
    --DBMS_OUTPUT.PUT_LINE('SP_AH_OBTENER_CORREO_AQPA210A ...');
  
    FOR AROW IN (SELECT *
                   FROM AQPA210A
                  WHERE AQPA210APJPAIS = P_AQPA210APJPAIS
                    AND AQPA210APJTDOC = P_AQPA210APJTDOC
                    AND AQPA210APJNDOC = lc_AQPA210APJNDOC)
    
     LOOP
      IF (ln_CORREO = 0) THEN
        lv_CORREO := TRIM(AROW.AQPA210AEMA);
      ELSE
        lv_CORREO := lv_CORREO || '; ' || TRIM(AROW.AQPA210AEMA);
      END IF;
      ---*********
      ln_CORREO := ln_CORREO + 1;
      ---*********
    END LOOP;
    ---*********
    P_CORREOS := TRIM(lv_CORREO);
    ---*********
  EXCEPTION
    WHEN OTHERS THEN
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' >>> ' || sqlerrm;
      ---***  
  
  END SP_AH_OBTENER_CORREO_AQPA210A;

  /*
  &GRD_Pais NUMBER
      &GRD_TDOC NUMBER
      &GRD_NDOC VARCHAR
      &JAQZ587FECH DATE
      &JAQZ587OPEMOD NUMBER
      &JAQZ587OPETRA NUMBER
      &JAQZ587OPEREL NUMBER
      &vJAQZ587TIPOP VARCHAR
      &JAQZ587IMPD NUMBER
      &JAQZ587IMPS NUMBER
      &JAQZ587TCPRE NUMBER
   */

  PROCEDURE SP_AH_ENVIAR_CORREO(P_PAIS    IN NUMBER,
                                P_TDOC    IN NUMBER,
                                P_NDOC    IN VARCHAR,
                                P_FECH    IN DATE,
                                P_CREUSR  IN VARCHAR,
                                P_CORREOS IN VARCHAR,
                                P_ARCHIVO IN VARCHAR,
                                P_OPEMOD  IN NUMBER,
                                P_OPETRA  IN NUMBER,
                                P_OPEREL  IN NUMBER,
                                P_ERRCOD  OUT VARCHAR,
                                P_ERRMSG  OUT VARCHAR) IS
  
    ---***
    lv_archivo    varchar2(90) := '';
    lv_remitente  varchar2(100);
    lv_destinos   VARCHAR2(32767) := '';
    lv_destadd    varchar2(100);
    lv_asunto     varchar2(100);
    lv_directorio varchar2(100);
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    l_bfile       BFILE;
    l_blob        BLOB;
    lv_indenv     char(1) := 'N';
    lc_usrori     char(10);
    lc_usrsup     char(10);
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
    ---*** PARAMTROS DE REENVIO
    P_N_CODPRO NUMBER(9); -- CODIGO DE PROCESO
    P_C_ASUNTO VARCHAR2(100); -- ASUNTO
    P_C_DESPAR VARCHAR2(400); -- DESTINATARIOS (PARA)
    P_C_DESCOC VARCHAR2(400); -- DESTINATARIOS (CC)
    P_C_DESCCO VARCHAR2(400); -- DESTINATARIOS (CCO)
    P_C_MENSAJ CLOB; -- CUERPO EN HTML
    P_C_REMITE VARCHAR2(100); -- REMITENTE
    P_C_DIRECT VARCHAR2(100); -- DIRECTORIO PARA OBTENER LOS ADJUNTOS
    P_C_ADJUNT VARCHAR2(400); -- LISTADO DE ARCHIVOS SEPARADOS POR ;
    P_N_AUX001 NUMBER(17, 2);
    P_N_AUX002 NUMBER(17, 2);
    P_N_AUX003 NUMBER(9);
    P_N_AUX004 NUMBER(9);
    P_D_AUX005 DATE;
    P_D_AUX006 DATE;
    P_C_AUX007 VARCHAR2(100);
    P_C_AUX008 VARCHAR2(100);
    P_C_AUX009 VARCHAR2(100);
    p_c_coderr varchar2(9);
    p_c_msgerr varchar2(600);
    ---***
  
  BEGIN
    --DBMS_OUTPUT.PUT_LINE('SP_AH_ENVIAR_CORREO ...');
  
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    --lv_archivo := TRIM(P_ARCHIVO) || '.pdf';
    lv_archivo := TRIM(P_ARCHIVO);
    ---***
    lv_destinos := TRIM(P_CORREOS);
    ---***
    ---*** ORACLE NOMBRE FOLDER (DIRECTORIO)
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_directorio
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 94
         AND TP1CORR3 = 1;
    exception
      when others then
        P_ERRCOD := '101';
        P_ERRMSG := 'No hay DIRECTORIO Parametrizado';
        RETURN;
    END;
    ---***
    ---***
    ---*** REMITENTE
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_remitente
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 94
         AND TP1CORR3 = 2;
      lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    exception
      when others then
        P_ERRCOD := '102';
        P_ERRMSG := 'No hay REMITENTE Parametrizado';
        RETURN;
    END;
    ---***
    ---*** DESTINO CC
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_destadd
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 94
         AND TP1CORR3 = 3;
      lv_destadd := TRIM(lv_destadd) || '@cajaarequipa.pe';
    exception
      when others then
        P_ERRCOD := '102';
        P_ERRMSG := 'No hay DESTINO CC Parametrizado';
        RETURN;
    END;
    ---***
    ---***
    lv_asunto := 'Comprobante FX SPOT';
    ---***
    ---***
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado Cliente:' ||
                 --'<p><br></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Adjunto al presente les remitimos el documento indicado en el asunto</p>' ||
                 --'<p><br></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente, </p>' ||
                 --'<p><br></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    ---*********
    --ENVIO MAIL
    BEGIN
      ---*** INFO DE REENVIO
      P_N_CODPRO := 99;
      P_C_REMITE := lv_remitente;
      P_C_ASUNTO := lv_asunto;
      P_C_DESPAR := lv_destinos;
      P_C_DESCOC := lv_destadd;
      P_C_MENSAJ := ll_mensaje;
      P_C_DIRECT := lv_directorio;
      P_C_ADJUNT := lv_archivo;
      P_C_AUX007 := TRIM(P_ARCHIVO);
      P_C_AUX008 := TRIM(P_CREUSR);
      p_c_coderr := NULL;
      p_c_msgerr := NULL;
      ---***
      -- Call the procedure
    
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => lv_destadd,
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => lv_archivo,
                                       p_c_coderr          => P_ERRCOD,
                                       p_c_deserr          => P_ERRMSG);
    
      /*
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => lv_destadd,
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => '',
                                       p_archivosadjuntos  => '',
                                       p_c_coderr          => P_ERRCOD,
                                       p_c_deserr          => P_ERRMSG);
      
      */
      IF (P_ERRCOD <> '000') THEN
        ---*** RUTINA PARA REENVIO
        pq_cr_enviar_correos.sp_ah_reprocesa_mail(P_N_CODPRO, --CODIGO DE PROCESO
                                                  P_C_ASUNTO, --ASUNTO
                                                  P_C_DESPAR, --DESTINATARIOS (PARA)
                                                  P_C_DESCOC, --DESTINATARIOS (CC)
                                                  P_C_DESCCO, --DESTINATARIOS (CCO)
                                                  P_C_MENSAJ, --CUERPO EN HTML
                                                  P_C_REMITE, --REMITENTE
                                                  P_C_DIRECT, --DIRECTORIO PARA OBTENER LOS ADJUNTOS
                                                  P_C_ADJUNT, --LISTADO DE ARCHIVOS SEPARADOS POR ;
                                                  P_N_AUX001, --NUMBER(17,2)
                                                  P_N_AUX002, --NUMBER(17,2)
                                                  P_N_AUX003, --NUMBER(9)
                                                  P_N_AUX004, --NUMBER(9)
                                                  P_D_AUX005, --DATE
                                                  P_D_AUX006, --DATE
                                                  P_C_AUX007, --VARCHAR2(100)
                                                  P_C_AUX008, --VARCHAR2(100)
                                                  P_C_AUX009, --VARCHAR2(100)
                                                  p_c_coderr,
                                                  p_c_msgerr);
      
        P_ERRCOD := '010';
        P_ERRMSG := 'SE REENVIARA EL CORREO EN EL TRANSCURSO DEL DIA ...';
        RETURN;
      END IF;
      ---***
    EXCEPTION
      WHEN OTHERS THEN
        P_ERRCOD := '002';
        P_ERRMSG := 'OCURRIO UN ERROR AL ENVIAR EMAIL (' || SQLCODE || ') ' ||
                    SQLERRM;
    END;
  
  END SP_AH_ENVIAR_CORREO;

  PROCEDURE SP_AH_GENERA_CONSTANCIA(P_PAIS        IN NUMBER,
                                    P_TDOC        IN NUMBER,
                                    P_NDOC        IN VARCHAR,
                                    P_FECH        IN DATE,
                                    P_CORREOS     IN VARCHAR,
                                    P_OPEMOD      IN NUMBER,
                                    P_OPETRA      IN NUMBER,
                                    P_OPEREL      IN NUMBER,
                                    P_FECHA_STR   OUT VARCHAR,
                                    P_CLIENTE_STR OUT VARCHAR,
                                    P_TIPOPE_STR  OUT VARCHAR,
                                    P_TRX_STR     OUT VARCHAR,
                                    P_ERRCOD      OUT VARCHAR,
                                    P_ERRMSG      OUT VARCHAR) IS
  
    ---*********
    lc_JAQZ587DNI   CHAR(12);
    lv_JAQZ587TIPOP VARCHAR(20);
    ln_JAQZ587IMPS  NUMBER(17, 2);
    ln_JAQZ587IMPD  NUMBER(17, 2);
    ln_JAQZ587TCPRE NUMBER(9, 6);
    lc_PETIPO       CHAR(1);
    lv_PJRAZS       VARCHAR(70);
    ---*********
  
  BEGIN
    --DBMS_OUTPUT.PUT_LINE('SP_AH_GENERA_CONSTANCIA ...');
  
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    lc_JAQZ587DNI := TRIM(P_NDOC);
    ---***
  
    BEGIN
      SELECT TRIM(JAQZ587TIPOP), JAQZ587IMPS, JAQZ587IMPD, JAQZ587TCPRE
        INTO lv_JAQZ587TIPOP,
             ln_JAQZ587IMPS,
             ln_JAQZ587IMPD,
             ln_JAQZ587TCPRE
        FROM JAQZ587
       WHERE JAQZ587FECH = P_FECH
         AND JAQZ587DNI = lc_JAQZ587DNI
         AND JAQZ587OPEMOD = P_OPEMOD
         AND JAQZ587OPETRA = P_OPETRA
         AND JAQZ587OPEREL = P_OPEREL
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        P_ERRCOD := '001';
        P_ERRMSG := '(ERROR)::(' || SQLCODE || ') -> ' || SQLERRM;
    END;
  
    ---********* 
    SP_AH_OBTENER_FECHA_STR(P_FECH, P_FECHA_STR);
    ---*********
    BEGIN
      SELECT PETIPO
        INTO lc_PETIPO
        FROM FSD001
       WHERE PEPAIS = P_PAIS
         AND PETDOC = P_TDOC
         AND PENDOC = lc_JAQZ587DNI;
    
      IF (lc_PETIPO = 'J') THEN
        SELECT TRIM(PJRAZS)
          INTO lv_PJRAZS
          FROM FSD003
         WHERE PJPAIS = P_PAIS
           AND PJTDOC = P_TDOC
           AND PJNDOC = lc_JAQZ587DNI;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        P_ERRCOD := '001';
        P_ERRMSG := '(ERROR)::(' || SQLCODE || ') -> ' || SQLERRM;
    END;
  
    ---*********
    P_CLIENTE_STR := TRIM(lv_PJRAZS);
    P_TIPOPE_STR  := TRIM(lv_JAQZ587TIPOP);
    P_TRX_STR     := TRIM(TO_CHAR(P_OPEMOD)) || TRIM(TO_CHAR(P_OPETRA)) ||
                     TRIM(TO_CHAR(P_OPEREL));
    ---*********
  
  END SP_AH_GENERA_CONSTANCIA;

  PROCEDURE SP_AH_OBTENER_FECHA_STR(P_FECHA     IN DATE,
                                    P_FECHA_STR OUT VARCHAR) IS
    v_dia       VARCHAR2(20);
    v_mes       VARCHAR2(20);
    v_resultado VARCHAR2(100);
  BEGIN
    SELECT CASE TO_CHAR(p_fecha, 'D', 'NLS_DATE_LANGUAGE=SPANISH')
             WHEN '1' THEN
              'domingo'
             WHEN '2' THEN
              'lunes'
             WHEN '3' THEN
              'martes'
             WHEN '4' THEN
              'miércoles'
             WHEN '5' THEN
              'jueves'
             WHEN '6' THEN
              'viernes'
             WHEN '7' THEN
              'sábado'
           END
      INTO v_dia
      FROM DUAL;
  
    SELECT CASE TO_CHAR(p_fecha, 'MM')
             WHEN '01' THEN
              'enero'
             WHEN '02' THEN
              'febrero'
             WHEN '03' THEN
              'marzo'
             WHEN '04' THEN
              'abril'
             WHEN '05' THEN
              'mayo'
             WHEN '06' THEN
              'junio'
             WHEN '07' THEN
              'julio'
             WHEN '08' THEN
              'agosto'
             WHEN '09' THEN
              'septiembre'
             WHEN '10' THEN
              'octubre'
             WHEN '11' THEN
              'noviembre'
             WHEN '12' THEN
              'diciembre'
           END
      INTO v_mes
      FROM DUAL;
  
    ---********* 
    v_resultado := 'Arequipa, ' || v_dia || ' ' || TO_CHAR(p_fecha, 'DD') ||
                   ' de ' || v_mes || ' de ' || TO_CHAR(p_fecha, 'YYYY');
  
    P_FECHA_STR := v_resultado;
    ---*********
  END SP_AH_OBTENER_FECHA_STR;

END PQ_AH_TESORERIA_TC_ENVIO_CONSTANCIA;
/
