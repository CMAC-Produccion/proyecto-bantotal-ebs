CREATE OR REPLACE PROCEDURE SP_AH_RECLAMOS_UPDATE_CRM_001(P_USR    IN VARCHAR,
                                                          P_RECCOD IN VARCHAR,
                                                          P_CAN    IN NUMBER,
                                                          P_OPS    IN VARCHAR,
                                                          P_MOT    IN NUMBER,
                                                          P_ESR    IN NUMBER,
                                                          P_SUBMTV IN NUMBER,
                                                          P_PCACOD IN NUMBER,
                                                          P_PCATIP IN VARCHAR,
                                                          P_GESASI IN VARCHAR,
                                                          P_ERRCOD OUT VARCHAR,
                                                          P_ERRMSG OUT VARCHAR) IS

  -- ***************************************************************************************
  -- Nombre                     : SP_AH_RECLAMOS_UPDATE_CRM_001
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.04.11
  -- Autor de Creación          : CVILLON
  -- Uso                        : Update Reclamos via CRM
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.04.11
  -- Modificado                 : CVILLON
  -- Descripción                : Update Reclamos via CRM
  -- ***************************************************************************************

  ln_CHKREC NUMBER(3);
  ln_SUBSBS NUMBER(9);
  lv_JNOM   VARCHAR(150);

BEGIN
  ---***
  P_ERRCOD  := '000';
  P_ERRMSG  := '';
  ln_CHKREC := 0;
  ln_SUBSBS := 0;
  lv_JNOM   := '';
  ---***
  IF (P_RECCOD IS NOT NULL AND LENGTH(P_RECCOD) > 15) THEN
    SELECT COUNT(*)
      INTO ln_CHKREC
      FROM JAQL420
     WHERE JAQL420EMP = 1
       AND JAQL420COD = P_RECCOD;
    IF (ln_CHKREC = 0) THEN
      P_ERRCOD := '002';
      P_ERRMSG := 'RECLAMO NO EXISTE';
      RETURN;
    END IF;
  ELSE
    P_ERRCOD := '001';
    P_ERRMSG := 'CODIGO DE RECLAMO INVALIDO: ' || P_RECCOD;
    RETURN;
  END IF;

  IF ((P_SUBMTV IS NOT NULL) AND (P_SUBMTV > 0)) THEN
    BEGIN
      SELECT AQPB545FSBS
        INTO ln_SUBSBS
        FROM AQPB545F
       WHERE AQPB545FCOD = P_SUBMTV;
    EXCEPTION
      when others then
        P_ERRCOD := '008';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    ---***
    DELETE FROM AQPB545M
     WHERE AQPB545MREMP = 1
       AND AQPB545MRCOD = P_RECCOD;
    ---***
    INSERT INTO AQPB545M
      (AQPB545MREMP,
       AQPB545MRCOD,
       AQPB545MSCOD,
       AQPB545MSSBS,
       AQPB545MTIM,
       AQPB545MAI1,
       AQPB545MAI2,
       AQPB545MAI3,
       AQPB545MAD1,
       AQPB545MAD2,
       AQPB545MAD3,
       AQPB545MAN1,
       AQPB545MAN2,
       AQPB545MAN3,
       AQPB545MAC1,
       AQPB545MAC2,
       AQPB545MAC3)
    VALUES
      (1,
       P_RECCOD,
       P_SUBMTV,
       ln_SUBSBS,
       SYSDATE,
       0,
       0,
       0,
       NULL,
       NULL,
       NULL,
       0,
       0,
       0,
       P_USR,
       NULL,
       NULL);
    ---***
  END IF;

  ---*** PRODUCTO CAJA
  DELETE FROM AQPB545J
   WHERE AQPB545JEMP = 1
     AND AQPB545JREC = P_RECCOD;
  ---***
  SELECT AQPB545GNOM
    INTO lv_JNOM
    FROM AQPB545G
   WHERE AQPB545GEMP = 1
     AND AQPB545GCOD = P_PCACOD
     AND AQPB545GTIP = P_PCATIP;
  ---***
  INSERT INTO AQPB545J
    (AQPB545JEMP,
     AQPB545JCOD,
     AQPB545JTIP,
     AQPB545JNOM,
     AQPB545JREC,
     AQPB545JTIM,
     AQPB545JAI1,
     AQPB545JAI2,
     AQPB545JAI3,
     AQPB545JAD1,
     AQPB545JAD2,
     AQPB545JAD3,
     AQPB545JAN1,
     AQPB545JAN2,
     AQPB545JAN3,
     AQPB545JAC1,
     AQPB545JAC2,
     AQPB545JAC3)
  VALUES
    (1,
     P_PCACOD,
     P_PCATIP,
     lv_JNOM,
     P_RECCOD,
     SYSDATE,
     0,
     0,
     0,
     NULL,
     NULL,
     NULL,
     0,
     0,
     0,
     P_USR,
     NULL,
     NULL);
  ---***
  --SELECT * FROM JAQL420
  UPDATE JAQL420
     SET JAQL420CAN    = P_CAN,
         JAQL420OPS    = P_OPS,
         JAQL420MOT    = P_MOT,
         JAQL420ESR    = P_ESR,
         JAQL420GESASI = P_GESASI
   WHERE JAQL420EMP = 1
     AND JAQL420COD = P_RECCOD;
  ---***
  COMMIT;
  ---***
EXCEPTION
  when others then
    P_ERRCOD := '009';
    P_ERRMSG := sqlcode || '->' || sqlerrm;
    RETURN;
  
END SP_AH_RECLAMOS_UPDATE_CRM_001;
/

