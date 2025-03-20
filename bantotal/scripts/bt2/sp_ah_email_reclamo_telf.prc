CREATE OR REPLACE PROCEDURE SP_AH_EMAIL_RECLAMO_TELF(P_CREUSR   IN VARCHAR2,
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

BEGIN

  P_C_CODRES := '000';
  P_C_MSGRES := '';
  P_C_ERRSQL := '';
  ln_CODIGO  := 0;

  lv_archivo  := TRIM(P_C_CODREC) || '.pdf';
  lv_destinos := '';

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
  lv_asunto := 'Caja Arequipa - Constancia de Reclamo Nro.' || ' ' ||
               P_C_CODREC;
  --lv_destinos  := 'cvillon@cajaarequipa.pe';
  ---***
  SELECT JAQL420EML, JAQL420FAPROX
    INTO lv_destinos, ld_AQPB527FECREX
    FROM JAQL420
   WHERE JAQL420COD = P_C_CODREC;
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
         AQPB527ENVRES)
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
         'NO');
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
   WHERE JAQL420COD = P_C_CODREC;

  lc_JAQL420EML := lv_destinos;

  lc_AQPB527FECREC := TO_CHAR(ld_JAQL420FCR, 'yyyy/MM/dd');

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
    SELECT TRIM(PFAPE1), TRIM(PFAPE2), TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)
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
           AQPB527ENVRES)
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
           'RV');
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
           AQPB527ENVRES)
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
           'NO') RETURN AQPB527MSFILE INTO l_blob;
        l_bfile := BFILENAME(lv_directorio, lv_archivo);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
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
         AQPB527ENVRES)
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
         'SI') RETURN AQPB527MSFILE INTO l_blob;
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
         AQPB527ENVRES)
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
         'NO') RETURN AQPB527MSFILE INTO l_blob;
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

END SP_AH_EMAIL_RECLAMO_TELF;
/

