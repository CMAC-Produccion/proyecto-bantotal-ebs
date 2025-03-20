CREATE OR REPLACE PROCEDURE SP_CR_MAIL_OPINION_RIESGO(V_PARA          IN VARCHAR2,
                                                      V_CC            IN VARCHAR2,
                                                      V_MENSAJE       IN VARCHAR2,
                                                      V_REMITENTE     IN VARCHAR2,
                                                      V_ASUNTO        IN VARCHAR2,
                                                      V_REPOSITORIO   IN VARCHAR2,
                                                      V_NOMBREARCHIVO IN VARCHAR2,
                                                      V_CODIGOOPINION IN NUMBER,
                                                      V_INSTANCIA     IN NUMBER,
                                                      V_ERREXPEDIG    IN NUMBER,
                                                      V_MSGERREXPE    IN VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_actualizarEstado156
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.11
    -- Autor de Creación          : Milton cordova - IGS
    -- Uso                        : Envio correo para opinion de riesgos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 10/01/2024
    -- Autor de la Modificación   : Rcastro - igs
    -- Descripción de Modificación: Se agrega proceso para reenvio de correo
    -- Fecha de Modificación      : 31/07/2024
    -- Autor de la Modificación   : Rcastro - igs
    -- Descripción de Modificación: Se agrega param. cod erro y msg error    
    -- *****************************************************************                                                       
  lc_coderr varchar2(400) := null;
  lc_deserr varchar2(400) := null;
  auxCorrelativo number(10);
  lc_msgPreenvio varchar2(400);
  
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
  BEGIN 
    SELECT MAX(AQPC217CORR) INTO auxCorrelativo FROM AQPC217 WHERE AQPC217FEC = TO_DATE(SYSDATE, 'dd/mm/rrrr');    
  EXCEPTION
    WHEN OTHERS THEN
      auxCorrelativo := 0;  
  END; 
  
  IF auxCorrelativo IS NULL THEN
     auxCorrelativo := 0;
  END IF;
  
  auxCorrelativo := auxCorrelativo + 1;
  lc_msgPreenvio := 'PRE-ENVIO CORREO -' || trim(to_char(V_ERREXPEDIG)) || ' ' || trim(V_MSGERREXPE); --31/07/2024
  
  BEGIN
    INSERT INTO AQPC217
      (AQPC217COD,
       AQPC217INS,
       AQPC217PAR,
       AQPC217CCC,
       AQPC217ARC,
       AQPC217FEC,
       AQPC217HOR,
       AQPC217CEN,
       AQPC217MEN,
       AQPC217CORR)
    VALUES
      (V_CODIGOOPINION,
       V_INSTANCIA,
       V_PARA,
       V_CC,
       V_NOMBREARCHIVO,
       TO_DATE(SYSDATE, 'dd/mm/rrrr'),
       TO_CHAR(SYSDATE, 'HH24:MI:SS'),
       0,
       lc_msgPreenvio,--'PRE-ENVIO CORREO',
       auxCorrelativo);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
    
      BEGIN
        INSERT INTO AQPC217
          (AQPC217COD,
           AQPC217INS,
           AQPC217PAR,
           AQPC217CCC,
           AQPC217ARC,
           AQPC217FEC,
           AQPC217HOR,
           AQPC217CEN,
           AQPC217MEN,
           AQPC217CORR)
        VALUES
          (V_CODIGOOPINION,
           V_INSTANCIA,
           '',
           '',
           '',
           TO_DATE(SYSDATE, 'dd/mm/rrrr'),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           0,
           lc_msgPreenvio,--'PRE-ENVIO CORREO',
           auxCorrelativo + 1);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
  END;

  BEGIN
    pq_ah_planillas.p_sendmailattach(p_destinatariospara => V_PARA,
                                     p_destinatarioscc   => V_CC,
                                     p_destinatariosbcc  => '',
                                     p_mensaje           => V_MENSAJE,
                                     p_remitente         => V_REMITENTE,
                                     p_asunto            => V_ASUNTO,
                                     p_tipomensaje       => 'HTML',
                                     p_directorio        => V_REPOSITORIO,
                                     p_archivosadjuntos  => V_NOMBREARCHIVO,
                                     p_c_coderr          => lc_coderr,
                                     p_c_deserr          => lc_deserr);
  EXCEPTION
    WHEN OTHERS THEN
      lc_coderr := '999';
      lc_deserr := 'Error PLSQL de Envio Correo';
  END;
  
  --10012024
  ---*** INFO DE REENVIO
  P_N_CODPRO := 777;
  P_C_REMITE := V_REMITENTE;
  P_C_ASUNTO := V_ASUNTO;
  P_C_DESPAR := V_PARA;
  P_C_DESCOC := V_CC;
  P_C_MENSAJ := V_MENSAJE;
  P_C_DIRECT := V_REPOSITORIO;
  P_C_ADJUNT := V_NOMBREARCHIVO;
  P_N_AUX001 := V_CODIGOOPINION;
  P_N_AUX002 := V_INSTANCIA;
  p_c_coderr := NULL;
  p_c_msgerr := NULL;
  ---***  
  
  IF (lc_coderr <> '000') THEN
     ---*** RUTINA PARA REENVIO
     BEGIN
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
     EXCEPTION 
       WHEN OTHERS THEN
         NULL;                                                
     END; 
     
     lc_coderr := trim(p_c_coderr);
     lc_deserr := trim(p_c_msgerr);                                              
  END IF;
  --10012024
  
  

  BEGIN 
    SELECT MAX(AQPC217CORR) INTO auxCorrelativo FROM AQPC217 WHERE AQPC217FEC = TO_DATE(SYSDATE, 'dd/mm/rrrr');    
  EXCEPTION
    WHEN OTHERS THEN
      auxCorrelativo := 0;  
  END; 
  
  IF auxCorrelativo IS NULL THEN
     auxCorrelativo := 0;
  END IF;
  
  auxCorrelativo := auxCorrelativo + 1;

  BEGIN
    INSERT INTO AQPC217
      (AQPC217COD,
       AQPC217INS,
       AQPC217PAR,
       AQPC217CCC,
       AQPC217ARC,
       AQPC217FEC,
       AQPC217HOR,
       AQPC217CEN,
       AQPC217MEN,
       AQPC217CORR)
    VALUES
      (V_CODIGOOPINION,
       V_INSTANCIA,
       V_PARA,
       V_CC,
       V_NOMBREARCHIVO,
       TO_DATE(SYSDATE, 'dd/mm/rrrr'),
       TO_CHAR(SYSDATE, 'HH24:MI:SS'),
       lc_coderr,
       lc_deserr,
       auxCorrelativo);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        INSERT INTO AQPC217
          (AQPC217COD,
           AQPC217INS,
           AQPC217PAR,
           AQPC217CCC,
           AQPC217ARC,
           AQPC217FEC,
           AQPC217HOR,
           AQPC217CEN,
           AQPC217MEN,
           AQPC217CORR)
        VALUES
          (V_CODIGOOPINION,
           V_INSTANCIA,
           V_PARA,
           V_CC,
           V_NOMBREARCHIVO,
           TO_DATE(SYSDATE, 'dd/mm/rrrr'),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           999,
           lc_deserr,
           auxCorrelativo + 1);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
  END;
END;
/

