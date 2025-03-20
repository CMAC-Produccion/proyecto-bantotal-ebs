CREATE OR REPLACE PACKAGE PQ_AH_RECLAMOS_NOTIFICA IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_RECLAMOS_NOTIFICA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.02.21
  -- Autor de Creación          : CVILLON
  -- Uso                        : NOTIFICACIONES DEL MODULO DE RECLAMOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.12.06
  -- Autor de Modificación      : CVILLON
  -- Descripción                : Reenvio Notificación ONR
  -- ***************************************************************************************

  PROCEDURE SP_AH_REC_NOTI_ONR(P_CREUSR IN VARCHAR,
                               P_RECEMP IN NUMBER,
                               P_RECCOD IN VARCHAR,
                               P_RECFEC IN DATE,
                               P_ERRCOD OUT VARCHAR,
                               P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_NOTI_ONR(P_CREUSR IN VARCHAR,
                           P_RECEMP IN NUMBER,
                           P_RECCOD IN VARCHAR,
                           P_RECFEC IN DATE,
                           P_ERRCOD OUT VARCHAR,
                           P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REC_ADOLESCENTE_TRAB(P_CREUSR IN VARCHAR,
                                       P_FECHOY IN DATE,
                                       P_PAIS   IN NUMBER,
                                       P_TDOC   IN NUMBER,
                                       P_NDOC   IN VARCHAR,
                                       P_ADOTRA OUT VARCHAR,
                                       P_ERRCOD OUT VARCHAR,
                                       P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_PC_REGISTRA_FORMATO(P_CODEMP IN NUMBER,
                                   P_CODREC IN VARCHAR2,
                                   P_NOMARC IN VARCHAR2,
                                   P_DESARC IN VARCHAR2,
                                   P_CODUSU IN VARCHAR2,
                                   P_ERRCOD OUT VARCHAR2,
                                   P_ERRMSG OUT VARCHAR2);

  PROCEDURE SP_AH_DESCARGA_DATOS(P_EMPCOD IN NUMBER,
                                 P_CODREC IN VARCHAR2,
                                 P_NROARC IN VARCHAR2,
                                 P_NOMARC OUT VARCHAR2,
                                 P_CODERR OUT VARCHAR2,
                                 P_DESERR OUT VARCHAR2);

  PROCEDURE SP_AH_EMAIL_RECLAMOS_NOTI1(P_CREUSR   IN VARCHAR2,
                                       P_N_CODEMP IN NUMBER,
                                       P_C_CODREC IN VARCHAR2,
                                       P_C_CODRES OUT VARCHAR2,
                                       P_C_MSGRES OUT VARCHAR2,
                                       P_C_ERRSQL OUT VARCHAR2);

  PROCEDURE SP_AH_EMAIL_RECLAMOS_NOTI2(P_CREUSR   IN VARCHAR2,
                                       P_N_CODEMP IN NUMBER,
                                       P_C_CODREC IN VARCHAR2,
                                       P_C_CODRES OUT VARCHAR2,
                                       P_C_MSGRES OUT VARCHAR2,
                                       P_C_ERRSQL OUT VARCHAR2);

  PROCEDURE SP_AH_RECDES(P_CREUSR   IN VARCHAR2,
                         P_N_CODEMP IN NUMBER,
                         P_C_CODREC IN VARCHAR2,
                         P_N_ARCNRO IN NUMBER,
                         P_C_NOMREP IN VARCHAR2,
                         P_C_CODRES OUT VARCHAR2,
                         P_C_MSGRES OUT VARCHAR2,
                         P_C_ERRSQL OUT VARCHAR2);

END PQ_AH_RECLAMOS_NOTIFICA;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_RECLAMOS_NOTIFICA IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_RECLAMOS_NOTIFICA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.02.21
  -- Autor de Creación          : CVILLON
  -- Uso                        : NOTIFICACIONES DEL MODULO DE RECLAMOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.12.06
  -- Autor de Modificación      : CVILLON
  -- Descripción                : Reenvio Notificación ONR
  -- ***************************************************************************************

  PROCEDURE SP_AH_REC_NOTI_ONR(P_CREUSR IN VARCHAR,
                               P_RECEMP IN NUMBER,
                               P_RECCOD IN VARCHAR,
                               P_RECFEC IN DATE,
                               P_ERRCOD OUT VARCHAR,
                               P_ERRMSG OUT VARCHAR) IS
  
  BEGIN
    P_ERRCOD := '000';
    P_ERRMSG := '';
  
    PQ_AH_RECLAMOS_NOTIFICA.SP_AH_NOTI_ONR(P_CREUSR,
                                           P_RECEMP,
                                           P_RECCOD,
                                           P_RECFEC,
                                           P_ERRCOD,
                                           P_ERRMSG);
  
    INSERT INTO AQPD307
      (AQPD307CREUSR,
       AQPD307CRETIM,
       AQPD307RECEMP,
       AQPD307RECCOD,
       AQPD307RECFEC,
       AQPD307ERRCOD,
       AQPD307ERRMSG)
    VALUES
      (P_CREUSR, SYSDATE, P_RECEMP, P_RECCOD, P_RECFEC, P_ERRCOD, P_ERRMSG);
    ---***
    COMMIT;
    ---***
  
    --dbms_output.PUT_LINE('P_ERRCOD: '||P_ERRCOD);
    --dbms_output.PUT_LINE('P_ERRMSG: '||P_ERRMSG);
  
  exception
    when others then
      P_ERRCOD := '601';
      P_ERRMSG := '(ERROR - Notificación a PyC)::(' || sqlcode || ') -> ' ||
                  sqlerrm;
    
      INSERT INTO AQPD307
        (AQPD307CREUSR,
         AQPD307CRETIM,
         AQPD307RECEMP,
         AQPD307RECCOD,
         AQPD307RECFEC,
         AQPD307ERRCOD,
         AQPD307ERRMSG)
      VALUES
        (P_CREUSR,
         SYSDATE,
         P_RECEMP,
         P_RECCOD,
         P_RECFEC,
         P_ERRCOD,
         P_ERRMSG);
      ---***
      COMMIT;
      ---***
  
  END SP_AH_REC_NOTI_ONR;

  PROCEDURE SP_AH_NOTI_ONR(P_CREUSR IN VARCHAR,
                           P_RECEMP IN NUMBER,
                           P_RECCOD IN VARCHAR,
                           P_RECFEC IN DATE,
                           P_ERRCOD OUT VARCHAR,
                           P_ERRMSG OUT VARCHAR) IS
  
    ll_mensaje   CLOB;
    lv_mensaje   VARCHAR2(32767);
    lv_remitente VARCHAR2(60);
    lv_asunto    VARCHAR2(90);
    lv_contacto  VARCHAR2(200);
    ln_corcar    NUMBER(10) := 0;
    lv_direccion VARCHAR2(200);
    ---***
    lc_remitente VARCHAR(60);
    lv_destinos  VARCHAR2(32767) := '';
    lv_destino1  VARCHAR(30);
    lv_destino2  VARCHAR(30);
    lv_destino   VARCHAR(60);
    --***
    ln_ESR    NUMBER(3);
    ln_MOT    NUMBER(3);
    ld_FCR    DATE;
    lc_HRC    CHAR(8);
    ln_PAC    NUMBER(3);
    ln_TDC    NUMBER(2);
    lc_NDC    CHAR(12);
    lv_clinom VARCHAR(60);
    lv_clidni VARCHAR(120);
    ---***
    ---*********
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
    ---*********
  
  BEGIN
    ---*********
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---*********
    BEGIN
      SELECT JAQL420ESR,
             JAQL420MOT,
             JAQL420FCR,
             JAQL420HRC,
             JAQL420PAC,
             JAQL420TDC,
             JAQL420NDC
        INTO ln_ESR, ln_MOT, ld_FCR, lc_HRC, ln_PAC, ln_TDC, lc_NDC
        FROM JAQL420
       WHERE JAQL420EMP = P_RECEMP
         AND JAQL420COD = P_RECCOD;
    EXCEPTION
      when others then
        P_ERRCOD := '101';
        P_ERRMSG := '(No Existe RECLAMO)::(' || sqlcode || ') -> ' ||
                    sqlerrm;
    END;
  
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
  
    ---*********
  
    ---*** REMITENTE
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_remitente
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 73
         AND TP1CORR3 = 1;
      lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    exception
      when others then
        P_ERRCOD := '001';
        P_ERRMSG := 'No hay REMITENTE Parametrizado';
        RETURN;
    END;
  
    ---*** ASUNTO
    BEGIN
      SELECT TRIM(tp1desc)
        INTO lv_asunto
        FROM fst198
       WHERE tp1cod1 = 11146
         AND tp1corr1 = 1
         AND tp1corr2 = 73
         AND tp1corr3 = 2;
    EXCEPTION
      when others then
        P_ERRCOD := '002';
        P_ERRMSG := 'No hay ASUNTO Parametrizado';
        --P_ERRMSG := '(ASUNTO)::(' || sqlcode || ') -> ' || sqlerrm;
        RETURN;
    END;
  
    ---*** DESTINATARIO
    BEGIN
      SELECT TRIM(tp1desc)
        INTO lv_destino
        FROM fst198
       WHERE tp1cod1 = 11146
         AND tp1corr1 = 1
         AND tp1corr2 = 73
         AND tp1corr3 = 3;
    EXCEPTION
      when others then
        P_ERRCOD := '003';
        P_ERRMSG := 'No hay DESTINATARIO Parametrizado';
        RETURN;
    END;
    ---*** DESTINOS EXTRA (SI LOS HUBIERA)
    lv_destinos := NULL;
    lv_destino  := TRIM(lv_destino) || '@cajaarequipa.pe';
    lv_destinos := lv_destino;
    --lv_destinos := 'cvillon@cajaarequipa.pe';
    FOR XDEST IN (SELECT TRIM(tp1desc) AS DESTINATARIO
                    FROM fst198
                   WHERE tp1cod1 = 11146
                     AND tp1corr1 = 1
                     AND tp1corr2 = 73
                     AND tp1corr3 > 3) LOOP
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
    ---*** MENSAJE
    ---***
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    ---***
  
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">El siguiente Reclamo de ONR acaba de ser registrado: ' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">********************************************************************************</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">El Reclamo:   ' ||
                  P_RECCOD || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">del Cliente:   ' ||
                  lv_clinom || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">identificado con DNI:   ' ||
                  lv_clidni || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Fecha de Ingreso:    ' ||
                  ld_FCR || '</p>';
  
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
      
        IF (P_ERRCOD <> '000') THEN
        
          ---*** INFO DE REENVIO
          P_N_CODPRO := 98;
          P_C_REMITE := lv_remitente;
          P_C_ASUNTO := lv_asunto;
          P_C_DESPAR := lv_destinos;
          P_C_MENSAJ := ll_mensaje;
          P_C_DIRECT := '';
          P_C_ADJUNT := '';
          P_C_AUX007 := TRIM(P_RECCOD);
          P_C_AUX008 := TRIM(P_CREUSR);
          p_c_coderr := NULL;
          p_c_msgerr := NULL;
          ---*********
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
        
          ---*********
          RETURN;
        END IF;
      
      exception
        when others then
          P_ERRCOD := '501';
          P_ERRMSG := '(ERROR - ENVIO DE CORREO)::(' || sqlcode || ') -> ' ||
                      sqlerrm;
      end;
    else
      P_ERRCOD := '502';
      P_ERRMSG := 'No existe cuenta de correo asociada';
    end if;
  
    dbms_lob.freetemporary(ll_mensaje);
  exception
    when others then
      P_ERRCOD := '503';
      P_ERRMSG := '(ERROR - ENVIO DE CORREO)::(' || sqlcode || ') -> ' ||
                  sqlerrm;
      ---***
    ----dbms_output.put_line('p_c_coderr: '||p_c_coderr);
    ----dbms_output.put_line('p_c_deserr: '||p_c_deserr);
    ---***
  END SP_AH_NOTI_ONR;

  PROCEDURE SP_AH_REC_ADOLESCENTE_TRAB(P_CREUSR IN VARCHAR,
                                       P_FECHOY IN DATE,
                                       P_PAIS   IN NUMBER,
                                       P_TDOC   IN NUMBER,
                                       P_NDOC   IN VARCHAR,
                                       P_ADOTRA OUT VARCHAR,
                                       P_ERRCOD OUT VARCHAR,
                                       P_ERRMSG OUT VARCHAR) IS
  
    ---***
    ln_ChkCTA NUMBER(3);
    lc_NDOC   CHAR(12);
  
    ln_SNGC60OCUP NUMBER(5);
    lv_SNGC60RZSO VARCHAR(50);
    lv_SNGC07DSC  VARCHAR(30);
    ln_SEGCOD     NUMBER(2);
    ---***
    ln_EDADMIN NUMBER(3);
    ln_EDADMAX NUMBER(3);
    ld_FECNAC  DATE;
    lc_MENOR   VARCHAR(1);
  
    ---***
  BEGIN
    --select * from sngc60 where sngc60ocup in (1,2); --determinar tipo de persona
    --select * from sngc07; --segcod = 1 independiente / 2 dependiente
  
    P_ERRCOD  := '000';
    P_ERRMSG  := '';
    P_ADOTRA  := 'F';
    ln_ChkCTA := 0;
    lc_NDOC   := TRIM(P_NDOC);
  
    ---*** Es Menor de Edad?
    BEGIN
      SELECT PFFNAC
        INTO ld_FECNAC
        FROM FSD002
       WHERE PFPAIS = P_PAIS
         AND PFTDOC = P_TDOC
         AND PFNDOC = lc_NDOC;
    exception
      when others then
        P_ADOTRA := 'F';
        P_ERRCOD := '000';
        P_ERRMSG := '';
        RETURN;
    END;
  
    ln_EDADMIN := 0;
    ln_EDADMAX := 18;
    lc_MENOR   := 'N';
  
    PQ_AH_NEW_COMISION.SP_VALIDA_EDAD_JUNIOR(ln_EDADMIN,
                                             ln_EDADMAX,
                                             ld_FECNAC,
                                             P_FECHOY,
                                             lc_MENOR);
  
    IF (lc_MENOR = 'N') THEN
      P_ADOTRA := 'F';
      P_ERRCOD := '000';
      P_ERRMSG := '';
      RETURN;
    END IF;
  
    ---*** Tiene Cuenta?
    SELECT COUNT(*)
      INTO ln_ChkCTA
      FROM FSR008
     WHERE PGCOD = 1
       AND PEPAIS = P_PAIS
       AND PETDOC = P_TDOC
       AND PENDOC = lc_NDOC
       AND CTTFIR = 'T';
  
    IF (ln_ChkCTA > 0) THEN
      BEGIN
        SELECT s60.SNGC60OCUP, s60.SNGC60RZSO, s07.SNGC07DSC, s07.SEGCOD
          INTO ln_SNGC60OCUP, lv_SNGC60RZSO, lv_SNGC07DSC, ln_SEGCOD
          FROM SNGC60 s60
          JOIN SNGC07 s07
            ON (s60.SNGC60OCUP = s07.SNGC07COD)
         WHERE s60.SNGC60PAIS = P_PAIS
           AND s60.SNGC60TDOC = P_TDOC
           AND s60.SNGC60NDOC = lc_NDOC;
      
        IF (ln_SEGCOD = 2) THEN
          P_ADOTRA := 'V';
        END IF;
      
      exception
        when others then
          P_ADOTRA := 'F';
          P_ERRCOD := '000';
          P_ERRMSG := '';
      END;
    END IF;
  
  END SP_AH_REC_ADOLESCENTE_TRAB;

  PROCEDURE SP_PC_REGISTRA_FORMATO(P_CODEMP IN NUMBER,
                                   P_CODREC IN VARCHAR2,
                                   P_NOMARC IN VARCHAR2,
                                   P_DESARC IN VARCHAR2,
                                   P_CODUSU IN VARCHAR2,
                                   P_ERRCOD OUT VARCHAR2,
                                   P_ERRMSG OUT VARCHAR2) IS
    L_BFILE   BFILE;
    L_BLOB    BLOB;
    LV_NOMREP VARCHAR2(30);
  
  BEGIN
  
    BEGIN
      ---*** REPOSITORIO
      SELECT TRIM(A.TP1DESC)
        INTO LV_NOMREP
        FROM FST198 A
       WHERE A.TP1COD = 1
         AND A.TP1COD1 = 10825
         AND A.TP1CORR1 = 61
         AND A.TP1CORR2 = 6
         AND A.TP1CORR3 = 3;
    EXCEPTION
      WHEN OTHERS THEN
        LV_NOMREP := '';
    END;
  
    INSERT INTO AQPD311
      (AQPD311EMP,
       AQPD311COD,
       AQPD311NRO,
       AQPD311DES,
       AQPD311NOM,
       AQPD311ARC,
       AQPD311USR,
       AQPD311TIM)
    VALUES
      (P_CODEMP,
       P_CODREC,
       (SELECT COUNT(*) + 1
          FROM AQPD311 A
         WHERE A.AQPD311EMP = P_CODEMP
           AND A.AQPD311COD = P_CODREC),
       P_DESARC,
       P_NOMARC,
       EMPTY_BLOB(),
       P_CODUSU,
       SYSDATE()) RETURN AQPD311ARC INTO L_BLOB;
  
    L_BFILE := BFILENAME(LV_NOMREP, P_NOMARC);
    DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADFROMFILE(L_BLOB, L_BFILE, DBMS_LOB.GETLENGTH(L_BFILE));
    DBMS_LOB.FILECLOSE(L_BFILE);
  
    P_ERRCOD := '000';
    P_ERRMSG := '';
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      P_ERRCOD := '001';
      P_ERRMSG := 'ERROR AL CARGAR: ' || LV_NOMREP || '/' || P_NOMARC || ':' ||
                  TRIM(SQLCODE) || ':' || TRIM(SQLERRM);
      ROLLBACK;
  END SP_PC_REGISTRA_FORMATO;

  PROCEDURE SP_AH_EMAIL_RECLAMOS_NOTI1(P_CREUSR   IN VARCHAR2,
                                       P_N_CODEMP IN NUMBER,
                                       P_C_CODREC IN VARCHAR2,
                                       P_C_CODRES OUT VARCHAR2,
                                       P_C_MSGRES OUT VARCHAR2,
                                       P_C_ERRSQL OUT VARCHAR2) IS
  
    lv_destinos   varchar2(400) := '';
    lv_archivo    varchar2(21) := '';
    lv_remitente  varchar2(100);
    lv_asunto     varchar2(100);
    lv_estado     CHAR(1);
    lv_directorio varchar2(100);
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    l_bfile       BFILE;
    l_blob        BLOB;
    lv_indenv     char(1) := 'N';
    lc_usrori     char(10);
    lc_usrsup     char(10);
  
    ln_CODIGO        NUMBER(9);
    lc_AQPB527FECREC VARCHAR(10);
    lc_AQPB527TIPDOC VARCHAR(20);
    lc_AQPB527NUMDOC VARCHAR(12);
    lc_AQPB527TIPPER VARCHAR(1);
    lc_AQPB527NUMCEL VARCHAR(20);
    lc_AQPB527CEMAIL VARCHAR(100);
    lc_AQPB527APEPAT VARCHAR(30);
    lc_AQPB527APEMAT VARCHAR(30);
    lc_AQPB527NOMBRE VARCHAR(70);
    ld_AQPB527ENVFEX DATE;
    lc_AQPB527ENVFEC VARCHAR(10);
    lc_AQPB527ENVHOR VARCHAR(8);
    lc_AQPB527ENVRES VARCHAR(2);
  
    ld_AQPB527FECREX DATE;
    lc_AQPB527FECRES VARCHAR(10);
  
    ld_JAQL420FCR DATE;
    ln_JAQL420PAC NUMBER(3);
    ln_JAQL420TDC NUMBER(2);
    lc_JAQL420NDC CHAR(12);
    lc_JAQL420CEL VARCHAR(20);
    lc_JAQL420EML VARCHAR(60);
  
    ln_TIPPER NUMBER(3);
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
    ln_CANING NUMBER(3);
    lv_CANIND VARCHAR(20);
    ---***
  
  BEGIN
  
    P_C_CODRES := '000';
    P_C_MSGRES := '';
    P_C_ERRSQL := '';
    ln_CODIGO  := 0;
  
    lv_archivo  := TRIM(P_C_CODREC) || '.pdf';
    lv_destinos := '';
    ---***
    ln_CANING := 0;
    lv_CANIND := '';
    ---***
    ---***
    ---*** ORACLE NOMBRE FOLDER (DIRECTORIO)
    BEGIN
      --SELECT * FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11146 AND TP1CORR1 = 1 AND TP1CORR2 = 46 AND TP1CORR3 = 1;
      SELECT TRIM(TP1DESC)
        INTO lv_directorio
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 46
         AND TP1CORR3 = 1;
    exception
      when others then
        P_C_CODRES := '101';
        P_C_MSGRES := 'No hay DIRECTORIO Parametrizado';
        RETURN;
    END;
    ---***
    ---*** REMITENTE
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_remitente
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 46
         AND TP1CORR3 = 2;
      lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    exception
      when others then
        P_C_CODRES := '102';
        P_C_MSGRES := 'No hay REMITENTE Parametrizado';
        RETURN;
    END;
    ---***
  
    --lv_directorio:= 'DTPUMP_PR_EMAIL';
    --lv_remitente  := 'cvillon@cajaarequipa.pe';
    --lv_asunto := 'Caja Arequipa - Constancia de Reclamo Nro.' || ' ' ||
    --             P_C_CODREC;
    lv_asunto := 'Caja Arequipa - Reclamo Nro.' || ' ' || P_C_CODREC;
  
    --lv_destinos  := 'cvillon@cajaarequipa.pe';
    ---***
    SELECT JAQL420EML, JAQL420FAPROX, JAQL420VIR
      INTO lv_destinos, ld_AQPB527FECREX, ln_CANING
      FROM JAQL420
     WHERE JAQL420EMP = P_N_CODEMP
       AND JAQL420COD = P_C_CODREC;
    ---***
    ---***
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_CANIND
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10871
         AND TP1CORR1 = 3
         AND TP1CORR2 = 1
         AND TP1CORR3 = ln_CANING
         AND TP1NRO1 = 1;
    exception
      when others then
        lv_CANIND := 'DESCONOCIDO';
    END;
    ---***
    ---***
    SELECT PGFAPE, TO_CHAR(PGFAPE, 'yyyy/MM/dd')
      INTO ld_AQPB527ENVFEX, lc_AQPB527ENVFEC
      FROM FST017
     WHERE PGCOD = 1;
    lc_AQPB527ENVHOR := TO_CHAR(SYSDATE, 'hh24:mi:ss');
    ---***
    --ld_AQPB527FECREX := ld_AQPB527ENVFEX + 30;
    --lc_AQPB527FECRES := TO_CHAR(ld_AQPB527FECREX, 'yyyy/MM/dd');
    ---*** PRY4967 - NVA CONTABILIZACION DIAS
    lc_AQPB527FECRES := TO_CHAR(ld_AQPB527FECREX, 'yyyy/MM/dd');
    ---***
    --DBMS_OUTPUT.PUT_LINE('lv_destinos(1):= '||lv_destinos);
    ---***
    IF (lv_destinos IS NULL OR LENGTH(lv_destinos) < 10) THEN
      ---*************************************************************
      ---***REGISTRAMOS LOG
      BEGIN
        ---***
        BEGIN
          SELECT MAX(AQPB527CODIGO) INTO ln_CODIGO FROM AQPB527;
          IF (ln_CODIGO IS NULL) THEN
            ln_CODIGO := 0;
          END IF;
          ln_CODIGO := ln_CODIGO + 1;
        exception
          when others then
            ln_CODIGO := 1;
        END;
        ---***
        P_C_CODRES := '001';
        P_C_MSGRES := 'OCURRIO UN ERROR AL ENVIAR EMAIL';
        P_C_ERRSQL := 'No EMAIL Destino::(' || sqlcode || ') ' || sqlerrm;
        ---***
      
        INSERT INTO AQPB527
          (AQPB527CODIGO,
           AQPB527CREUSR,
           AQPB527CRETIM,
           AQPB527ESTADO,
           AQPB527CODREC,
           AQPB527CODRES,
           AQPB527MSGRES,
           AQPB527ERRSQL,
           AQPB527MSFILE,
           AQPB527FECREC,
           AQPB527TIPDOC,
           AQPB527NUMDOC,
           AQPB527TIPPER,
           AQPB527NUMCEL,
           AQPB527CEMAIL,
           AQPB527APEPAT,
           AQPB527APEMAT,
           AQPB527NOMBRE,
           AQPB527ENVFEX,
           AQPB527ENVFEC,
           AQPB527ENVHOR,
           AQPB527ENVRES,
           AQPB527CANING,
           AQPB527CANIND)
        values
          (ln_CODIGO,
           P_CREUSR,
           SYSDATE,
           'F',
           P_C_CODREC,
           P_C_CODRES,
           P_C_MSGRES,
           P_C_ERRSQL,
           NULL,
           lc_AQPB527FECREC,
           lc_AQPB527TIPDOC,
           lc_AQPB527NUMDOC,
           lc_AQPB527TIPPER,
           lc_AQPB527NUMCEL,
           lc_AQPB527CEMAIL,
           lc_AQPB527APEPAT,
           lc_AQPB527APEMAT,
           lc_AQPB527NOMBRE,
           ld_AQPB527ENVFEX,
           lc_AQPB527ENVFEC,
           lc_AQPB527ENVHOR,
           'NO',
           ln_CANING,
           lv_CANIND);
        COMMIT;
      exception
        when others then
          P_C_CODRES := '201';
          P_C_MSGRES := 'OCURRIO UN ERROR AL ENVIAR EMAIL';
          P_C_ERRSQL := 'No EMAIL Destino::(' || sqlcode || ') ' || sqlerrm;
      END;
      ---*************************************************************
      RETURN;
    END IF;
  
    --SELECT JAQL420EML FROM JAQL420 WHERE JAQL420COD = 'R004002202221046';
    --CVILLON@CAJAAREQUIPA.PE\
    --SELECT * FROM JAQL420 WHERE JAQL420COD = 'R004002202221046' FOR UPDATE
    --SELECT * FROM JAQL420 WHERE JAQL420COD = 'R004002202221046'
  
    ---***
    lv_destinos := NVL(SUBSTR(lv_destinos, 0, INSTR(lv_destinos, '\') - 1),
                       lv_destinos);
    lv_destinos := TRIM(lv_destinos);
    ---***
    --DBMS_OUTPUT.PUT_LINE('lv_destinos(2):= '||lv_destinos);
    ---***
  
    SELECT JAQL420FCR,
           JAQL420PAC,
           JAQL420TDC,
           JAQL420NDC,
           JAQL420CEL,
           JAQL420EML
      INTO ld_JAQL420FCR,
           ln_JAQL420PAC,
           ln_JAQL420TDC,
           lc_JAQL420NDC,
           lc_JAQL420CEL,
           lc_JAQL420EML
      FROM JAQL420
     WHERE JAQL420EMP = P_N_CODEMP
       AND JAQL420COD = P_C_CODREC;
  
    lc_JAQL420EML := lv_destinos;
  
    lc_AQPB527FECREC := TO_CHAR(ld_JAQL420FCR, 'yyyy/MM/dd');
    ---***
    SELECT TRIM(TDNOM)
      INTO lc_AQPB527TIPDOC
      FROM FST014
     WHERE TDOCUM = ln_JAQL420TDC;
  
    SELECT COUNT(*)
      INTO ln_TIPPER
      FROM FSD002
     WHERE PFPAIS = ln_JAQL420PAC
       AND PFTDOC = ln_JAQL420TDC
       AND PFNDOC = lc_JAQL420NDC;
  
    IF (ln_TIPPER > 0) THEN
      lc_AQPB527TIPPER := 'N';
    ELSE
      SELECT COUNT(*)
        INTO ln_TIPPER
        FROM FSD003
       WHERE PJPAIS = ln_JAQL420PAC
         AND PJTDOC = ln_JAQL420TDC
         AND PJNDOC = lc_JAQL420NDC;
      IF (ln_TIPPER > 0) THEN
        lc_AQPB527TIPPER := 'J';
      ELSE
        lc_AQPB527TIPPER := 'X';
      END IF;
    END IF;
  
    lc_AQPB527NUMDOC := TRIM(lc_JAQL420NDC);
    lc_AQPB527NUMCEL := TRIM(lc_JAQL420CEL);
    lc_AQPB527CEMAIL := lv_destinos;
  
    ---***
    IF (lc_AQPB527TIPPER = 'N') THEN
      SELECT TRIM(PFAPE1),
             TRIM(PFAPE2),
             TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)
        INTO lc_AQPB527APEPAT, lc_AQPB527APEMAT, lc_AQPB527NOMBRE
        FROM FSD002
       WHERE PFPAIS = ln_JAQL420PAC
         AND PFTDOC = ln_JAQL420TDC
         AND PFNDOC = lc_JAQL420NDC;
    END IF;
    ---***
    IF (lc_AQPB527TIPPER = 'J') THEN
      SELECT TRIM(PJRAZS)
        INTO lc_AQPB527NOMBRE
        FROM FSD003
       WHERE PJPAIS = ln_JAQL420PAC
         AND PJTDOC = ln_JAQL420TDC
         AND PJNDOC = lc_JAQL420NDC;
    END IF;
    ---***
    ---*** ARMADO DEL CUERPO
    /*
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Buenos días Sr. (a)(ta) ' ||
                  lc_AQPB527NOMBRE || ' ' || lc_AQPB527APEPAT || ':</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Tenemos información importante para usted; le adjuntamos la "Constancia de Atención de Reclamo" Nro. ' ||
                  P_C_CODREC || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">en atención a su comunicación de fecha ' ||
                  lc_AQPB527FECREC ||
                  ', la cual ha sido derivada al Área de Reclamos.</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Uno de nuestros asesores esta tomando su caso el cual será resuelto y comunicado a su correo electrónico, cuyo tiempo</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">estimado de respuesta es el ' ||
                  lc_AQPB527FECRES || '.</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">El contenido de este mensaje es automático, generado por nuestro sistema. Por favor no responda a este correo.</p>' ||
                  '<p><br></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Si desea comunicarse con nosotros, tenemos a su disposición los siguientes canales</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">para atender sus consultas referidas a nuestros productos y servicios, </p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">en el horario de lunes a viernes de 8.30 a 18.30 hrs. y sábado de 9.00 a 18.00 hrs.</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Central telefónica (054) 380670</strong></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Buzón: servicioalcliente@cajaarequipa.pe</strong></p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    lv_mensaje := '<p><br></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>#PensamosEnTuBienestar</strong></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>#JuntosContigo</strong></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 20px;"><strong>Caja Arequipa</strong></p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    */
  
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Te hacemos llegar el Reporte de presentación de tu Reclamo.' ||
                  '<p><br></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>¡Celebramos a quienes apuestan por un mañana mejor!</strong>' ||
                  '<p><br></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Por favor no respondas a este correo electrónico.</p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    --ENVIO MAIL
    BEGIN
      ---*** INFO DE REENVIO
      P_N_CODPRO := 99;
      P_C_REMITE := lv_remitente;
      P_C_ASUNTO := lv_asunto;
      P_C_DESPAR := lv_destinos;
      P_C_MENSAJ := ll_mensaje;
      P_C_DIRECT := lv_directorio;
      P_C_ADJUNT := lv_archivo;
      P_C_AUX007 := TRIM(P_C_CODREC);
      P_C_AUX008 := TRIM(P_CREUSR);
      p_c_coderr := NULL;
      p_c_msgerr := NULL;
      ---***
      -- Call the procedure
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => '',
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => lv_archivo,
                                       p_c_coderr          => P_C_CODRES,
                                       p_c_deserr          => P_C_MSGRES);
    
      ---***
      IF (P_C_CODRES <> '000') THEN
        ---***REGISTRAMOS LOG
        BEGIN
          ---***
          BEGIN
            SELECT MAX(AQPB527CODIGO) INTO ln_CODIGO FROM AQPB527;
            IF (ln_CODIGO IS NULL) THEN
              ln_CODIGO := 0;
            END IF;
            ln_CODIGO := ln_CODIGO + 1;
          exception
            when others then
              ln_CODIGO := 1;
          END;
          ---***
          --select * from aqpa145
          ---***
          INSERT INTO AQPB527
            (AQPB527CODIGO,
             AQPB527CREUSR,
             AQPB527CRETIM,
             AQPB527ESTADO,
             AQPB527CODREC,
             AQPB527CODRES,
             AQPB527MSGRES,
             AQPB527ERRSQL,
             AQPB527MSFILE,
             AQPB527FECREC,
             AQPB527TIPDOC,
             AQPB527NUMDOC,
             AQPB527TIPPER,
             AQPB527NUMCEL,
             AQPB527CEMAIL,
             AQPB527APEPAT,
             AQPB527APEMAT,
             AQPB527NOMBRE,
             AQPB527ENVFEX,
             AQPB527ENVFEC,
             AQPB527ENVHOR,
             AQPB527ENVRES,
             AQPB527CANING,
             AQPB527CANIND)
          values
            (ln_CODIGO,
             P_CREUSR,
             SYSDATE,
             'R',
             P_C_CODREC,
             P_C_CODRES,
             P_C_MSGRES,
             P_C_ERRSQL,
             NULL,
             lc_AQPB527FECREC,
             lc_AQPB527TIPDOC,
             lc_AQPB527NUMDOC,
             lc_AQPB527TIPPER,
             lc_AQPB527NUMCEL,
             lc_AQPB527CEMAIL,
             lc_AQPB527APEPAT,
             lc_AQPB527APEMAT,
             lc_AQPB527NOMBRE,
             ld_AQPB527ENVFEX,
             lc_AQPB527ENVFEC,
             lc_AQPB527ENVHOR,
             'RV',
             ln_CANING,
             lv_CANIND);
          COMMIT;
        exception
          when others then
            P_C_CODRES := '007';
            P_C_MSGRES := 'OCURRIO UN ERROR AL ENVIAR EMAIL';
            P_C_ERRSQL := '(' || sqlcode || ') ' || sqlerrm;
        END;
        ---*************************************************************
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
      
        P_C_CODRES := '010';
        P_C_MSGRES := 'SE REENVIARA EL CORREO EN EL TRANSCURSO DEL DIA ...';
        P_C_ERRSQL := 'Proceso de Reenvio Iniciado ...';
      
        RETURN;
      END IF;
      ---***
    exception
      when others then
        P_C_CODRES := '002';
        P_C_MSGRES := 'OCURRIO UN ERROR AL ENVIAR EMAIL';
        P_C_ERRSQL := '(' || sqlcode || ') ' || sqlerrm;
      
        ---*************************************************************
        ---***REGISTRAMOS LOG
        BEGIN
          ---***
          BEGIN
            SELECT MAX(AQPB527CODIGO) INTO ln_CODIGO FROM AQPB527;
            IF (ln_CODIGO IS NULL) THEN
              ln_CODIGO := 0;
            END IF;
            ln_CODIGO := ln_CODIGO + 1;
          exception
            when others then
              ln_CODIGO := 1;
          END;
          ---***
        
          INSERT INTO AQPB527
            (AQPB527CODIGO,
             AQPB527CREUSR,
             AQPB527CRETIM,
             AQPB527ESTADO,
             AQPB527CODREC,
             AQPB527CODRES,
             AQPB527MSGRES,
             AQPB527ERRSQL,
             AQPB527MSFILE,
             AQPB527FECREC,
             AQPB527TIPDOC,
             AQPB527NUMDOC,
             AQPB527TIPPER,
             AQPB527NUMCEL,
             AQPB527CEMAIL,
             AQPB527APEPAT,
             AQPB527APEMAT,
             AQPB527NOMBRE,
             AQPB527ENVFEX,
             AQPB527ENVFEC,
             AQPB527ENVHOR,
             AQPB527ENVRES,
             AQPB527CANING,
             AQPB527CANIND)
          values
            (ln_CODIGO,
             P_CREUSR,
             SYSDATE,
             'F',
             P_C_CODREC,
             P_C_CODRES,
             P_C_MSGRES,
             P_C_ERRSQL,
             EMPTY_BLOB(),
             lc_AQPB527FECREC,
             lc_AQPB527TIPDOC,
             lc_AQPB527NUMDOC,
             lc_AQPB527TIPPER,
             lc_AQPB527NUMCEL,
             lc_AQPB527CEMAIL,
             lc_AQPB527APEPAT,
             lc_AQPB527APEMAT,
             lc_AQPB527NOMBRE,
             ld_AQPB527ENVFEX,
             lc_AQPB527ENVFEC,
             lc_AQPB527ENVHOR,
             'NO',
             ln_CANING,
             lv_CANIND) RETURN AQPB527MSFILE INTO l_blob;
          l_bfile := BFILENAME(lv_directorio, lv_archivo);
          DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
          DBMS_LOB.loadfromfile(l_blob,
                                l_bfile,
                                DBMS_LOB.getlength(l_bfile));
          DBMS_LOB.fileclose(l_bfile);
          COMMIT;
        exception
          when others then
            P_C_CODRES := '003';
            P_C_MSGRES := 'OCURRIO UN ERROR AL ENVIAR EMAIL';
            P_C_ERRSQL := '(' || sqlcode || ') ' || sqlerrm;
        END;
        ---*************************************************************
    
    END;
  
    IF P_C_CODRES = '000' then
      P_C_MSGRES := 'ENVIO SATISFACTORIO';
      P_C_ERRSQL := '';
      ---*************************************************************
      ---***REGISTRAMOS LOG
      BEGIN
        ---***
        BEGIN
          SELECT MAX(AQPB527CODIGO) INTO ln_CODIGO FROM AQPB527;
          IF (ln_CODIGO IS NULL) THEN
            ln_CODIGO := 0;
          END IF;
          ln_CODIGO := ln_CODIGO + 1;
        exception
          when others then
            ln_CODIGO := 1;
        END;
        ---***
      
        INSERT INTO AQPB527
          (AQPB527CODIGO,
           AQPB527CREUSR,
           AQPB527CRETIM,
           AQPB527ESTADO,
           AQPB527CODREC,
           AQPB527CODRES,
           AQPB527MSGRES,
           AQPB527ERRSQL,
           AQPB527MSFILE,
           AQPB527FECREC,
           AQPB527TIPDOC,
           AQPB527NUMDOC,
           AQPB527TIPPER,
           AQPB527NUMCEL,
           AQPB527CEMAIL,
           AQPB527APEPAT,
           AQPB527APEMAT,
           AQPB527NOMBRE,
           AQPB527ENVFEX,
           AQPB527ENVFEC,
           AQPB527ENVHOR,
           AQPB527ENVRES,
           AQPB527CANING,
           AQPB527CANIND)
        values
          (ln_CODIGO,
           P_CREUSR,
           SYSDATE,
           'G',
           P_C_CODREC,
           P_C_CODRES,
           P_C_MSGRES,
           P_C_ERRSQL,
           EMPTY_BLOB(),
           lc_AQPB527FECREC,
           lc_AQPB527TIPDOC,
           lc_AQPB527NUMDOC,
           lc_AQPB527TIPPER,
           lc_AQPB527NUMCEL,
           lc_AQPB527CEMAIL,
           lc_AQPB527APEPAT,
           lc_AQPB527APEMAT,
           lc_AQPB527NOMBRE,
           ld_AQPB527ENVFEX,
           lc_AQPB527ENVFEC,
           lc_AQPB527ENVHOR,
           'SI',
           ln_CANING,
           lv_CANIND) RETURN AQPB527MSFILE INTO l_blob;
        l_bfile := BFILENAME(lv_directorio, lv_archivo);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);
        COMMIT;
      exception
        when others then
          P_C_CODRES := '004';
          P_C_MSGRES := 'OCURRIO UN ERROR AL ENVIAR EMAIL';
          P_C_ERRSQL := '(' || sqlcode || ') ' || sqlerrm;
      END;
      ---*************************************************************
    END IF;
  
    dbms_lob.freetemporary(ll_mensaje);
  
  exception
    when others then
      P_C_CODRES := '005';
      P_C_MSGRES := 'OCURRIO UN ERROR AL ENVIAR EMAIL';
      P_C_ERRSQL := '(' || sqlcode || ') ' || sqlerrm;
    
      ---*************************************************************
      ---***REGISTRAMOS LOG
      BEGIN
        ---***
        BEGIN
          SELECT MAX(AQPB527CODIGO) INTO ln_CODIGO FROM AQPB527;
          IF (ln_CODIGO IS NULL) THEN
            ln_CODIGO := 0;
          END IF;
          ln_CODIGO := ln_CODIGO + 1;
        exception
          when others then
            ln_CODIGO := 1;
        END;
        ---***
      
        INSERT INTO AQPB527
          (AQPB527CODIGO,
           AQPB527CREUSR,
           AQPB527CRETIM,
           AQPB527ESTADO,
           AQPB527CODREC,
           AQPB527CODRES,
           AQPB527MSGRES,
           AQPB527ERRSQL,
           AQPB527MSFILE,
           AQPB527FECREC,
           AQPB527TIPDOC,
           AQPB527NUMDOC,
           AQPB527TIPPER,
           AQPB527NUMCEL,
           AQPB527CEMAIL,
           AQPB527APEPAT,
           AQPB527APEMAT,
           AQPB527NOMBRE,
           AQPB527ENVFEX,
           AQPB527ENVFEC,
           AQPB527ENVHOR,
           AQPB527ENVRES,
           AQPB527CANING,
           AQPB527CANIND)
        values
          (ln_CODIGO,
           P_CREUSR,
           SYSDATE,
           'F',
           P_C_CODREC,
           P_C_CODRES,
           P_C_MSGRES,
           P_C_ERRSQL,
           EMPTY_BLOB(),
           lc_AQPB527FECREC,
           lc_AQPB527TIPDOC,
           lc_AQPB527NUMDOC,
           lc_AQPB527TIPPER,
           lc_AQPB527NUMCEL,
           lc_AQPB527CEMAIL,
           lc_AQPB527APEPAT,
           lc_AQPB527APEMAT,
           lc_AQPB527NOMBRE,
           ld_AQPB527ENVFEX,
           lc_AQPB527ENVFEC,
           lc_AQPB527ENVHOR,
           'NO',
           ln_CANING,
           lv_CANIND) RETURN AQPB527MSFILE INTO l_blob;
        l_bfile := BFILENAME(lv_directorio, lv_archivo);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);
        COMMIT;
      exception
        when others then
          P_C_CODRES := '006';
          P_C_MSGRES := 'OCURRIO UN ERROR AL ENVIAR EMAIL';
          P_C_ERRSQL := '(' || sqlcode || ') ' || sqlerrm;
      END;
      ---*************************************************************
  
  END SP_AH_EMAIL_RECLAMOS_NOTI1;

  ---*********
  ---*********

  PROCEDURE SP_AH_EMAIL_RECLAMOS_NOTI2(P_CREUSR   IN VARCHAR2,
                                       P_N_CODEMP IN NUMBER,
                                       P_C_CODREC IN VARCHAR2,
                                       P_C_CODRES OUT VARCHAR2,
                                       P_C_MSGRES OUT VARCHAR2,
                                       P_C_ERRSQL OUT VARCHAR2) IS
  
    ---***
    ln_CODIGO        NUMBER(3);
    ld_AQPD312RECFEC DATE;
    lv_AQPD312RECFED VARCHAR(10);
    lv_AQPD312RECHOR VARCHAR(8);
    ln_JAQL420PAC    NUMBER(3);
    ln_JAQL420TDC    NUMBER(2);
    lv_JAQL420TDC    VARCHAR(20);
    lc_JAQL420NDC    CHAR(12);
    lv_JAQL420NDC    VARCHAR(12);
    lv_AQPD312NUMCEL VARCHAR(20);
    lv_AQPD312CEMAIL VARCHAR(60);
  
    ln_TIPPER        NUMBER(3);
    lv_TIPPER        VARCHAR(1);
    lv_AQPD312CODRES VARCHAR(20);
    lv_AQPD312MSGRES VARCHAR(600);
    lv_AQPD312APEPAT VARCHAR(30);
    lv_AQPD312APEMAT VARCHAR(30);
    lv_AQPD312NOMBRE VARCHAR(70);
    lv_AQPD312TIPDOS VARCHAR(20);
    lv_cuerpo1       VARCHAR(120);
    ---***
    lv_destinos   varchar2(400) := NULL;
    lv_archivo    varchar2(100) := NULL;
    lv_remitente  varchar2(100);
    lv_asunto     varchar2(100);
    lv_estado     CHAR(1);
    lv_directorio varchar2(100);
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    l_bfile       BFILE;
    l_blob        BLOB;
    lv_indenv     char(1) := 'N';
    lc_usrori     char(10);
    lc_usrsup     char(10);
    ---***
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
    ---*********
    P_C_CODRES := '000';
    P_C_MSGRES := '';
    P_C_ERRSQL := '';
    ---*********
    ---*** REMITENTE
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_remitente
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 74
         AND TP1CORR3 = 1;
      lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    exception
      when others then
        P_C_CODRES := '102';
        P_C_MSGRES := 'No hay REMITENTE Parametrizado';
        RETURN;
    END;
    ---***
    BEGIN
      ---*** REPOSITORIO
      SELECT TRIM(A.TP1DESC)
        INTO lv_directorio
        FROM FST198 A
       WHERE A.TP1COD = 1
         AND A.TP1COD1 = 10825
         AND A.TP1CORR1 = 61
         AND A.TP1CORR2 = 6
         AND A.TP1CORR3 = 3;
    EXCEPTION
      WHEN OTHERS THEN
        lv_directorio := 'DTPUMP_PR_EMAIL';
    END;
  
    --lv_directorio:= 'DTPUMP_PR_EMAIL';
    --lv_remitente  := 'cvillon@cajaarequipa.pe';
  
    BEGIN
      SELECT COUNT(*)
        INTO ln_CODIGO
        FROM AQPD312
       WHERE AQPD312EMPCOD = P_N_CODEMP
         AND AQPD312RECCOD = P_C_CODREC;
    EXCEPTION
      WHEN OTHERS THEN
        ln_CODIGO := 0;
    END;
    ---*** CODIGO PARA TABLA AQPD312
    ln_CODIGO := ln_CODIGO + 1;
    ---***
  
    IF (ln_CODIGO = 1) THEN
      lv_asunto := 'Caja Arequipa - tenemos una Respuesta para ti, NRO. ' ||
                   P_C_CODREC;
    
      lv_cuerpo1 := 'y resultado del análisis adjuntamos la carta de respuesta al presente correo electrónico.';
    
    ELSE
      lv_asunto := 'Caja Arequipa - tenemos una Respuesta para ti, NRO. ' ||
                   P_C_CODREC || ' - ' || ln_CODIGO;
    
      lv_cuerpo1 := 'y resultado del análisis adjuntamos el duplicado de la carta de respuesta al presente correo electrónico.';
    END IF;
    ---***
    BEGIN
      SELECT JAQL420PAC,
             JAQL420TDC,
             TRIM(JAQL420NDC),
             TRIM(JAQL420EML),
             JAQL420FCR,
             TO_CHAR(JAQL420FCR, 'yyyy/MM/dd'),
             JAQL420HRC,
             JAQL420CEL,
             JAQL420EML
        INTO ln_JAQL420PAC,
             ln_JAQL420TDC,
             lc_JAQL420NDC,
             lv_destinos,
             ld_AQPD312RECFEC,
             lv_AQPD312RECFED,
             lv_AQPD312RECHOR,
             lv_AQPD312NUMCEL,
             lv_AQPD312CEMAIL
        FROM JAQL420
       WHERE JAQL420EMP = P_N_CODEMP
         AND JAQL420COD = P_C_CODREC;
    EXCEPTION
      WHEN OTHERS THEN
        P_C_CODRES := '001';
        P_C_MSGRES := 'CODIGO DE RECLAMO NO EXISTE';
        P_C_ERRSQL := '(' || SQLCODE || ') ' || SQLERRM;
        RETURN;
    END;
    ---***
    BEGIN
      SELECT TRIM(TDNOM)
        INTO lv_AQPD312TIPDOS
        FROM FST014
       WHERE TDOCUM = ln_JAQL420TDC;
    EXCEPTION
      WHEN OTHERS THEN
        lv_AQPD312TIPDOS := '-';
    END;
    lv_JAQL420NDC := TRIM(lc_JAQL420NDC);
    ---***
    SELECT COUNT(*)
      INTO ln_TIPPER
      FROM FSD002
     WHERE PFPAIS = ln_JAQL420PAC
       AND PFTDOC = ln_JAQL420TDC
       AND PFNDOC = lc_JAQL420NDC;
  
    IF (ln_TIPPER > 0) THEN
      lv_TIPPER := 'N';
    ELSE
      SELECT COUNT(*)
        INTO ln_TIPPER
        FROM FSD003
       WHERE PJPAIS = ln_JAQL420PAC
         AND PJTDOC = ln_JAQL420TDC
         AND PJNDOC = lc_JAQL420NDC;
      IF (ln_TIPPER > 0) THEN
        lv_TIPPER := 'J';
      ELSE
        lv_TIPPER := 'X';
      END IF;
    END IF;
  
    IF (lv_TIPPER = 'N') THEN
      SELECT PFAPE1, PFAPE2, PFNOM1 || ' ' || PFNOM2
        INTO lv_AQPD312APEPAT, lv_AQPD312APEMAT, lv_AQPD312NOMBRE
        FROM FSD002
       WHERE PFPAIS = ln_JAQL420PAC
         AND PFTDOC = ln_JAQL420TDC
         AND PFNDOC = lc_JAQL420NDC;
    END IF;
  
    ---***
    --lv_destinos := 'cvillon@cajaarequipa.pe';
    IF (lv_destinos IS NULL) THEN
      P_C_CODRES := '011';
      P_C_MSGRES := 'NO EXISTE EMAIL DESTINO';
      P_C_ERRSQL := '(' || SQLCODE || ') ' || SQLERRM;
      RETURN;
    END IF;
    ---***
    ---***
    ---*** Creando Archivos Adjuntos en el TOMCAT
    FOR AROW IN (SELECT *
                   FROM AQPD311
                  WHERE AQPD311EMP = P_N_CODEMP
                    AND AQPD311COD = P_C_CODREC) LOOP
    
      SP_AH_RECDES(P_CREUSR,
                   P_N_CODEMP,
                   P_C_CODREC,
                   AROW.AQPD311NRO,
                   lv_directorio,
                   P_C_CODRES,
                   P_C_MSGRES,
                   P_C_ERRSQL);
      ---***
      IF (lv_archivo IS NULL) THEN
        lv_archivo := TRIM(AROW.AQPD311DES);
      ELSE
        lv_archivo := TRIM(AROW.AQPD311DES) || ';' || TRIM(lv_archivo);
      END IF;
      ---***
    
      IF (P_C_CODRES <> '000') THEN
        P_C_CODRES := '002';
        P_C_MSGRES := 'ERROR AL CREAR ARCHIVO EN REPOSITORIO';
        P_C_ERRSQL := P_C_ERRSQL;
        RETURN;
      END IF;
    
    END LOOP;
  
    ---***
    --DBMS_OUTPUT.PUT_LINE('lv_archivo: ' || lv_archivo);
    ---***
    ---*** ARMADO DEL CUERPO
  
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) Sr.(a)  ' ||
                  lv_AQPD312APEPAT || ':</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Reciba nuestro cordial saludo, gracias por la confianza, hemos considerado la información respecto a su caso N° ' ||
                  P_C_CODREC || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">' ||
                  lv_cuerpo1 || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>¡Celebramos a quienes apuestan por un mañana mejor!</strong>' ||
                  '<p><br></p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Por favor no respondas a este correo electrónico.</p>';
  
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    ---*********
    ---*** ENVIO MAIL
    BEGIN
      ---*** INFO DE REENVIO
      P_N_CODPRO := 99;
      P_C_REMITE := lv_remitente;
      P_C_ASUNTO := lv_asunto;
      P_C_DESPAR := lv_destinos;
      P_C_MENSAJ := ll_mensaje;
      P_C_DIRECT := lv_directorio;
      P_C_ADJUNT := lv_archivo;
      P_C_AUX007 := TRIM(P_C_CODREC);
      P_C_AUX008 := TRIM(P_CREUSR);
      p_c_coderr := NULL;
      p_c_msgerr := NULL;
      ---***
      ---*** Call the procedure
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => '',
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => lv_archivo,
                                       p_c_coderr          => P_C_CODRES,
                                       p_c_deserr          => P_C_MSGRES);
    
      ---*** ENVIO SATISFACTORIO
      IF (P_C_CODRES = '000') THEN
        P_C_MSGRES := 'ENVIO SATISFACTORIO';
      
        INSERT INTO AQPD312
          (AQPD312EMPCOD,
           AQPD312RECCOD,
           AQPD312CODIGO,
           AQPD312CREUSR,
           AQPD312CRETIM,
           AQPD312ESTADO,
           AQPD312RECFEC,
           AQPD312RECFED,
           AQPD312RECHOR,
           AQPD312CODRES,
           AQPD312MSGRES,
           AQPD312ERRSQL,
           AQPD312PEPAIS,
           AQPD312TIPDOC,
           AQPD312TIPDOS,
           AQPD312NUMDOC,
           AQPD312TIPPER,
           AQPD312NUMCEL,
           AQPD312CEMAIL,
           AQPD312APEPAT,
           AQPD312APEMAT,
           AQPD312NOMBRE,
           AQPD312ENVFEX,
           AQPD312ENVFEC,
           AQPD312ENVHOR,
           AQPD312ENVRES)
        VALUES
          (P_N_CODEMP,
           P_C_CODREC,
           ln_CODIGO,
           P_CREUSR,
           SYSDATE,
           'E',
           ld_AQPD312RECFEC,
           lv_AQPD312RECFED,
           lv_AQPD312RECHOR,
           P_C_CODRES,
           P_C_MSGRES,
           P_C_ERRSQL,
           ln_JAQL420PAC,
           ln_JAQL420TDC,
           lv_AQPD312TIPDOS,
           lv_JAQL420NDC,
           lv_TIPPER,
           lv_AQPD312NUMCEL,
           lv_AQPD312CEMAIL,
           lv_AQPD312APEPAT,
           lv_AQPD312APEMAT,
           lv_AQPD312NOMBRE,
           TRUNC(SYSDATE),
           TO_CHAR(SYSDATE, 'yyyy/MM/dd'),
           TO_CHAR(SYSDATE, 'hh24:mi:ss'),
           'SI');
      
        ---***
        COMMIT;
        ---***
      ELSE
        -- OCURRIO UN ERROR AL ENVIAR EMAIL (MANDAR A REENVIO)
      
        lv_AQPD312CODRES := '000';
        lv_AQPD312MSGRES := 'REENVIO';
        ---*********  
      
        INSERT INTO AQPD312
          (AQPD312EMPCOD,
           AQPD312RECCOD,
           AQPD312CODIGO,
           AQPD312CREUSR,
           AQPD312CRETIM,
           AQPD312ESTADO,
           AQPD312RECFEC,
           AQPD312RECFED,
           AQPD312RECHOR,
           AQPD312CODRES,
           AQPD312MSGRES,
           AQPD312ERRSQL,
           AQPD312PEPAIS,
           AQPD312TIPDOC,
           AQPD312TIPDOS,
           AQPD312NUMDOC,
           AQPD312TIPPER,
           AQPD312NUMCEL,
           AQPD312CEMAIL,
           AQPD312APEPAT,
           AQPD312APEMAT,
           AQPD312NOMBRE,
           AQPD312ENVFEX,
           AQPD312ENVFEC,
           AQPD312ENVHOR,
           AQPD312ENVRES)
        VALUES
          (P_N_CODEMP,
           P_C_CODREC,
           ln_CODIGO,
           P_CREUSR,
           SYSDATE,
           'R',
           ld_AQPD312RECFEC,
           lv_AQPD312RECFED,
           lv_AQPD312RECHOR,
           lv_AQPD312CODRES,
           lv_AQPD312MSGRES,
           P_C_ERRSQL,
           ln_JAQL420PAC,
           ln_JAQL420TDC,
           lv_AQPD312TIPDOS,
           lv_JAQL420NDC,
           lv_TIPPER,
           lv_AQPD312NUMCEL,
           lv_AQPD312CEMAIL,
           lv_AQPD312APEPAT,
           lv_AQPD312APEMAT,
           lv_AQPD312NOMBRE,
           TRUNC(SYSDATE),
           TO_CHAR(SYSDATE, 'yyyy/MM/dd'),
           TO_CHAR(SYSDATE, 'hh24:mi:ss'),
           'SI');
      
        ---***
        COMMIT;
        ---*** 
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
      
        P_C_CODRES := '015';
        P_C_MSGRES := 'SE REENVIARA EL CORREO EN EL TRANSCURSO DEL DIA ...';
        P_C_ERRSQL := 'Proceso de Reenvio Iniciado ...';
      
        RETURN;
        ---***
      
      END IF;
    END;
  
  END SP_AH_EMAIL_RECLAMOS_NOTI2;

  PROCEDURE SP_AH_RECDES(P_CREUSR   IN VARCHAR2,
                         P_N_CODEMP IN NUMBER,
                         P_C_CODREC IN VARCHAR2,
                         P_N_ARCNRO IN NUMBER,
                         P_C_NOMREP IN VARCHAR2,
                         P_C_CODRES OUT VARCHAR2,
                         P_C_MSGRES OUT VARCHAR2,
                         P_C_ERRSQL OUT VARCHAR2) IS
  
    VBLOB     BLOB;
    VSTART    NUMBER := 1;
    BYTELEN   NUMBER := 32000;
    LEN       NUMBER;
    MY_VR     RAW(32000);
    X         NUMBER;
    L_OUTPUT  UTL_FILE.FILE_TYPE;
    LV_ARCDES VARCHAR2(50);
  
  BEGIN
    P_C_CODRES := '000';
    P_C_MSGRES := '';
    VSTART     := 1;
    BYTELEN    := 32000;
  
    ---***
    -- GET LENGTH OF BLOB
    BEGIN
      SELECT DBMS_LOB.GETLENGTH(A.AQPD311ARC),
             A.AQPD311ARC,
             TRIM(A.AQPD311DES)
        INTO LEN, VBLOB, LV_ARCDES
        FROM AQPD311 A
       WHERE A.AQPD311EMP = P_N_CODEMP
         AND A.AQPD311COD = P_C_CODREC
         AND A.AQPD311NRO = P_N_ARCNRO;
    
    EXCEPTION
      WHEN OTHERS THEN
        P_C_CODRES := '066';
        P_C_MSGRES := 'CODIGO DE RECLAMO NO EXISTE';
        P_C_ERRSQL := '(' || SQLCODE || ') ' || SQLERRM;
        RETURN;
    END;
    -- DEFINE OUTPUT DIRECTORY
    L_OUTPUT := UTL_FILE.FOPEN(P_C_NOMREP, LV_ARCDES, 'WB', 32760);
  
    -- SAVE BLOB LENGTH
    X := LEN;
  
    -- IF SMALL ENOUGH FOR A SINGLE WRITE
    IF LEN < 32760 THEN
      UTL_FILE.PUT_RAW(L_OUTPUT, VBLOB);
      UTL_FILE.FFLUSH(L_OUTPUT);
    ELSE
      -- WRITE IN PIECES
      VSTART := 1;
      WHILE VSTART < LEN AND BYTELEN > 0 LOOP
        DBMS_LOB.READ(VBLOB, BYTELEN, VSTART, MY_VR);
      
        UTL_FILE.PUT_RAW(L_OUTPUT, MY_VR);
        UTL_FILE.FFLUSH(L_OUTPUT);
      
        -- SET THE START POSITION FOR THE NEXT CUT
        VSTART := VSTART + BYTELEN;
      
        -- SET THE END POSITION IF LESS THAN 32000 BYTES
        X := X - BYTELEN;
        IF X < 32000 THEN
          BYTELEN := X;
        END IF;
      END LOOP;
      UTL_FILE.FCLOSE(L_OUTPUT);
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      P_C_CODRES := '077';
      P_C_MSGRES := 'ERROR EN SP_AH_RECDES';
      P_C_ERRSQL := '(' || SQLCODE || ') ' || SQLERRM;
  END SP_AH_RECDES;

  PROCEDURE SP_AH_DESCARGA_DATOS(P_EMPCOD IN NUMBER,
                                 P_CODREC IN VARCHAR2,
                                 P_NROARC IN VARCHAR2,
                                 P_NOMARC OUT VARCHAR2,
                                 P_CODERR OUT VARCHAR2,
                                 P_DESERR OUT VARCHAR2) IS
    CURSOR C_ARCHIVOS IS
      SELECT DBMS_LOB.GETLENGTH(A.AQPD311ARC) LEN_AQPD311ARC,
             A.AQPD311ARC AQPD311ARC,
             TRIM(A.AQPD311NOM) AQPD311NOM
        FROM AQPD311 A
       WHERE A.AQPD311EMP = P_EMPCOD
         AND A.AQPD311COD = P_CODREC
         AND A.AQPD311NRO = P_NROARC;
  
    VBLOB     BLOB;
    VSTART    NUMBER := 1;
    BYTELEN   NUMBER := 32000;
    LEN       NUMBER;
    MY_VR     RAW(32000);
    X         NUMBER;
    L_OUTPUT  UTL_FILE.FILE_TYPE;
    LV_NOMARC VARCHAR2(30);
    LV_TIPARC VARCHAR2(1);
    LV_NOMPRG VARCHAR2(10);
    LV_NOMREP VARCHAR2(30);
    LN_CONT   NUMBER(9) := 0;
  
  BEGIN
    P_CODERR := '000';
    P_DESERR := '';
    VSTART   := 1;
    BYTELEN  := 32000;
    LN_CONT  := 0;
  
    ---*** MAPEO DE NOMBRE UNICOS PARA LOS ARCHIVOS
    LV_TIPARC := 'D';
    LV_NOMPRG := 'HJAQL420';
    LV_NOMARC := '';
    SP_AH_GEN_COR_ARCH(P_C_TIPARC => LV_TIPARC,
                       P_C_NOMPRG => LV_NOMPRG,
                       P_C_NOMARC => LV_NOMARC);
  
    BEGIN
      UPDATE AQPD311 A
         SET A.AQPD311NOM = LV_NOMARC
       WHERE A.AQPD311EMP = P_EMPCOD
         AND A.AQPD311COD = P_CODREC
         AND A.AQPD311NRO = P_NROARC;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        P_CODERR := '0X1';
        P_DESERR := 'NO SE PUDO ACTUALIZAR NOMBRE DE ARCHIVO A DESCARGAR';
        RETURN;
    END;
  
    ---*** FIN MAPEO NOMBRES 
    FOR I IN C_ARCHIVOS LOOP
      LN_CONT   := LN_CONT + 1;
      LEN       := I.LEN_AQPD311ARC;
      VBLOB     := I.AQPD311ARC;
      LV_NOMARC := I.AQPD311NOM;
      EXIT;
    END LOOP;
    IF LN_CONT = 0 THEN
      LV_NOMARC := NULL;
      P_NOMARC  := LV_NOMARC;
      P_CODERR  := '006';
      P_DESERR  := 'NO EXISTE ARCHIVO A DESCARGAR';
      RETURN;
    ELSE
      P_NOMARC := LV_NOMARC;
      --OBTENEMOS REPOSITORIO
      BEGIN
        SELECT TRIM(A.TP1DESC)
          INTO LV_NOMREP
          FROM FST198 A
         WHERE A.TP1COD = 1
           AND A.TP1COD1 = 10825
           AND A.TP1CORR1 = 61
           AND A.TP1CORR2 = 6
           AND A.TP1CORR3 = 3; --REPOSITORIO  
      EXCEPTION
        WHEN OTHERS THEN
          LV_NOMREP := '';
      END;
    END IF;
  
    -- DEFINE OUTPUT DIRECTORY
    BEGIN
      L_OUTPUT := UTL_FILE.FOPEN(LV_NOMREP, LV_NOMARC, 'WB', 32760);
    EXCEPTION
      WHEN OTHERS THEN
        P_CODERR := '0XX';
        P_DESERR := 'NO EXISTE EL ARCHIVO';
        RETURN;
    END;
  
    -- SAVE BLOB LENGTH
    X := LEN;
  
    -- IF SMALL ENOUGH FOR A SINGLE WRITE
    IF LEN < 32760 THEN
      UTL_FILE.PUT_RAW(L_OUTPUT, VBLOB);
      UTL_FILE.FFLUSH(L_OUTPUT);
    ELSE
      -- WRITE IN PIECES
      VSTART := 1;
      WHILE VSTART < LEN AND BYTELEN > 0 LOOP
        DBMS_LOB.READ(VBLOB, BYTELEN, VSTART, MY_VR);
      
        UTL_FILE.PUT_RAW(L_OUTPUT, MY_VR);
        UTL_FILE.FFLUSH(L_OUTPUT);
      
        -- SET THE START POSITION FOR THE NEXT CUT
        VSTART := VSTART + BYTELEN;
      
        -- SET THE END POSITION IF LESS THAN 32000 BYTES
        X := X - BYTELEN;
        IF X < 32000 THEN
          BYTELEN := X;
        END IF;
      END LOOP;
      UTL_FILE.FCLOSE(L_OUTPUT);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_CODERR := SQLCODE;
      P_DESERR := SQLERRM;
  END SP_AH_DESCARGA_DATOS;

END PQ_AH_RECLAMOS_NOTIFICA;
/

