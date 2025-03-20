CREATE OR REPLACE PROCEDURE SP_AH_REC_SEGMENTAR_CLI(P_USER   IN VARCHAR,
                                                    P_PEPAIS IN NUMBER,
                                                    P_PETDOC IN NUMBER,
                                                    P_PENDOC IN VARCHAR,
                                                    P_SEGAHO OUT VARCHAR,
                                                    P_SEGNEG OUT VARCHAR,
                                                    P_ERRCOD OUT VARCHAR,
                                                    P_ERRMSG OUT VARCHAR) IS

  -- ***************************************************************************************
  -- Nombre                     : SP_AH_REC_SEGMENTAR_CLI
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.07.15
  -- Autor de Creación          : CVILLON
  -- Uso                        : Obtener Segmentacion de Clientes
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.05.02
  -- Modificado                 : CVILLON
  -- Descripción                : Nueva Segmentacion
  -- ***************************************************************************************

  ---***
  lc_PENDOC CHAR(12);
  ln_NUMP   NUMBER(5);
  ---***

BEGIN
  ---***
  P_SEGAHO := 'SIN SEGMENTAR';
  P_SEGNEG := 'SIN SEGMENTAR';
  P_ERRCOD := '000';
  P_ERRMSG := '';
  ---***
  lc_PENDOC := TRIM(P_PENDOC);
  ---***
  ---*** AHORROS
  BEGIN
    SELECT JAQL750NUMP
      INTO ln_NUMP
      FROM (SELECT *
              FROM JAQL750 j750
             WHERE j750.JAQL750PGCO = 1
               AND j750.JAQL750PAIS = P_PEPAIS
               AND j750.JAQL750TDOC = P_PETDOC
               AND j750.JAQL750NDOC = lc_PENDOC
             ORDER BY j750.JAQL750FECH DESC)
     WHERE ROWNUM = 1;
  EXCEPTION
    WHEN OTHERS THEN
      P_SEGAHO := 'SIN SEGMENTAR';
  END;
  ---*********
  CASE ln_NUMP
    WHEN 0 THEN
      P_SEGAHO := 'SIN SEGMENTAR';
    WHEN 1 THEN
      P_SEGAHO := 'VIP';
    WHEN 2 THEN
      P_SEGAHO := 'PREMIUM';
    WHEN 3 THEN
      P_SEGAHO := 'ORO';
    WHEN 4 THEN
      P_SEGAHO := 'PREFERENTE';
    WHEN 5 THEN
      P_SEGAHO := 'PLATA';
    WHEN 6 THEN
      P_SEGAHO := 'ESTANDAR';
    WHEN 7 THEN
      P_SEGAHO := 'BRONCE';
    ELSE
      P_SEGAHO := 'SIN SEGMENTAR';
  END CASE;
  ---*********
  /*  
  SELECT JAQL60CALI INTO P_SEGAHO FROM
    (SELECT *
    FROM JAQL060 J60
    WHERE J60.JAQL60PGCO = 1
    AND J60.JAQL60PAIS = P_PEPAIS
    AND J60.JAQL60TDOC = P_PETDOC
    AND J60.JAQL60NDOC = lc_PENDOC
    ORDER BY J60.JAQL60FECH DESC)
  WHERE ROWNUM = 1;
  EXCEPTION
        WHEN OTHERS THEN
        P_SEGAHO := 'SIN SEGMENTAR';
  END;
  */
  ---*** CREDITOS
  BEGIN
    SELECT SEGMENTO
      INTO P_SEGNEG
      FROM (SELECT case
                     when J67.JAQY067NCAL is null then
                      'SIN_SEGMENTAR'
                     else
                      J67.jaqy067ncal
                   end SEGMENTO
              FROM JAQY066 J66
              JOIN JAQY067 J67
                ON (J66.JAQY066CALF = J67.JAQY067CCAL)
             WHERE J66.JAQY066PAIC = P_PEPAIS
               AND J66.JAQY066TDOC = P_PETDOC
               AND J66.JAQY066TNDOC = lc_PENDOC
               AND J66.JAQY066TCAL = 'P'
               AND J66.JAQY066TSE = 'S'
               AND J66.JAQY066NSE = 'S'
             ORDER BY J66.JAQY066PANO DESC, J66.JAQY066PMES DESC)
     WHERE ROWNUM = 1;
  EXCEPTION
    WHEN OTHERS THEN
      P_SEGNEG := 'SIN SEGMENTAR';
  END;
  ---***

EXCEPTION
  WHEN OTHERS THEN
    P_ERRCOD := '001';
    P_ERRMSG := SQLCODE || '::' || SQLERRM;
    ---******
END SP_AH_REC_SEGMENTAR_CLI;
/

