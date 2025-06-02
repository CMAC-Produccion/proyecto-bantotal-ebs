CREATE OR REPLACE PROCEDURE SP_AH_REC_RECLASIFICA(P_EMP    IN NUMBER,
                                                  P_RECCOD IN VARCHAR,
                                                  P_TIPNEW IN NUMBER,
                                                  P_RECOPS IN VARCHAR,
                                                  P_RECMOT IN NUMBER,
                                                  P_CREFEC IN DATE,
                                                  P_CREHOR IN VARCHAR,
                                                  P_CREUSU IN VARCHAR,
                                                  P_NEWCOD OUT VARCHAR,
                                                  P_ERRCOD OUT VARCHAR,
                                                  P_ERRMSG OUT VARCHAR) IS

  -- ***************************************************************************************
  -- Nombre                     : SP_AH_REC_RECLASIFICA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.03.21
  -- Autor de Creación          : CVILLON
  -- Uso                        : RECLASIFICACIONES RECLAMO - QUEJA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.03.21
  -- Autor de Modificación      : CVILLON
  -- Descripción                : Reclasificacion - Cambio de Código
  -- ***************************************************************************************
  ---*********
  ln_SEQ    NUMBER;
  lv_OLDCOD VARCHAR(20);
  lv_NEWCOD VARCHAR(20);
  ---*********
BEGIN
  ---***
  P_NEWCOD := '-';
  P_ERRCOD := '000';
  P_ERRMSG := '';
  ---***
  SELECT (COUNT(*) + 1)
    INTO ln_SEQ
    FROM AQPD304
   WHERE AQPD304RECEMP = P_EMP
     AND AQPD304RECCOD = P_RECCOD;
  ---***

  --- PASA A RECLAMO
  IF (P_TIPNEW = 1) THEN
    --***
    lv_OLDCOD := P_RECCOD;
    lv_NEWCOD := 'R' || SUBSTR(lv_OLDCOD, 2);
    --***  
    UPDATE JAQL420
       SET JAQL420COD    = lv_NEWCOD,
           JAQL420TRC    = P_TIPNEW,
           JAQL420OPS    = P_RECOPS,
           JAQL420MOT    = P_RECMOT,
           JAQL420QUERE1 = 'S',
           JAQL420QUERE2 = 'S',
           JAQL420QUERE3 = 'S'
     WHERE JAQL420EMP = P_EMP
       AND JAQL420COD = P_RECCOD;
  
  END IF;

  --- PASA A QUEJA
  IF (P_TIPNEW = 2) THEN
    --***    
    lv_OLDCOD := P_RECCOD;
    lv_NEWCOD := 'E' || SUBSTR(lv_OLDCOD, 2);
    --***  
    UPDATE JAQL420
       SET JAQL420COD    = lv_NEWCOD,
           JAQL420TRC    = P_TIPNEW,
           JAQL420QUERE1 = 'N',
           JAQL420QUERE2 = 'N',
           JAQL420QUERE3 = 'S'
     WHERE JAQL420EMP = P_EMP
       AND JAQL420COD = P_RECCOD;
  
  END IF;

  --- Eliminar Sub Motivos Preexistentes
  DELETE FROM AQPB545M
   WHERE AQPB545MREMP = P_EMP
     AND AQPB545MRCOD = P_RECCOD;

  --- Crear LOG de Reclasificacion
  INSERT INTO AQPD304
    (AQPD304RECEMP,
     AQPD304RECCOD,
     AQPD304RECSEQ,
     AQPD304RECTIP,
     AQPD304CREFEC,
     AQPD304CREHOR,
     AQPD304CREUSU,
     AQPD304CRETIM)
  VALUES
    (P_EMP,
     lv_NEWCOD,
     ln_SEQ,
     P_TIPNEW,
     P_CREFEC,
     P_CREHOR,
     P_CREUSU,
     SYSDATE);

  ---***
  P_NEWCOD := lv_NEWCOD;
  ---***
  COMMIT;
  ---***
EXCEPTION
  when others then
    P_ERRCOD := '101';
    P_ERRMSG := '(' || sqlcode || ')' || ' : ' || sqlerrm;
    RETURN;
  
END SP_AH_REC_RECLASIFICA;
/
