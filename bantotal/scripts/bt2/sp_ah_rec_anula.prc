CREATE OR REPLACE PROCEDURE SP_AH_REC_ANULA(P_RECCOD IN VARCHAR
, P_RECUSU IN  VARCHAR
, P_PGFAPE IN  DATE
, P_RECESR OUT NUMBER
, P_ERRCOD OUT VARCHAR
, P_ERRMSG OUT VARCHAR) IS

  ---***
  lc_recusu CHAR(10);
  ln_persup NUMBER(3); -- Perfil de Supervisor
  ln_recesr NUMBER(3); -- Estado Actual
  lv_estanu VARCHAR(1);-- Estado de Anulacion

  ---***
  BEGIN
  ---***
  lc_recusu := TRIM(P_RECUSU);
  P_ERRCOD := '000';
  P_ERRMSG := '';
  ---*** VERIFICAR SI EL USUARIO TIENE PERFIL DE SUPERVISOR
  SELECT COUNT(*) INTO ln_persup
  FROM PRFU00 WHERE PGCOD = 1 AND UBUSER = lc_recusu AND TRIM(PRFGCOD) IN
  (SELECT TRIM(TP1DESC) FROM FST198 WHERE TP1COD = 1
  AND TP1COD1 = 11146
  AND TP1CORR1 = 1
  AND TP1CORR2 = 53);
  ---***
  BEGIN
    SELECT JAQL420ESR, JAQL420ESTANU
    INTO ln_recesr, lv_estanu
    FROM JAQL420
    WHERE JAQL420EMP = 1 AND JAQL420COD = P_RECCOD;
    EXCEPTION
        when others then
          P_ERRCOD := 'E01';
          P_ERRMSG := '('||sqlcode||')'||' : '|| sqlerrm;
          RETURN;
  END;
  ---***
  IF(ln_persup > 0 AND (lv_estanu IS NULL OR lv_estanu <> 'S')) THEN -- Es Supervisor y Anula
    UPDATE JAQL420 SET JAQL420ESR = 4
    , JAQL420ESTANU = 'C' -- Estado Confirmado
    , JAQL420GESANU = P_RECUSU
    , JAQL420GESFEC = P_PGFAPE
    , JAQL420SUPANU = P_RECUSU
    , JAQL420SUPFEC = P_PGFAPE
    WHERE JAQL420EMP = 1 AND JAQL420COD = P_RECCOD;
      P_RECESR := 4;
      ---***
      --dbms_output.put_line('Es Supervisor y Anula ...');
      ---***
  ELSIF(ln_persup > 0 AND lv_estanu = 'S') THEN -- Es Supervisor y Confirma Anulación
    UPDATE JAQL420 SET JAQL420ESR = 4
    , JAQL420ESTANU = 'C' -- Estado Confirmado
    , JAQL420SUPANU = P_RECUSU
    , JAQL420SUPFEC = P_PGFAPE
    WHERE JAQL420EMP = 1 AND JAQL420COD = P_RECCOD;
      P_RECESR := 4;
      ---***
      --dbms_output.put_line('Es Supervisor y Confirma Anulación ...');
      ---***
  ELSE -- Es Solicitud
    UPDATE JAQL420 SET JAQL420ESTANU = 'S' -- Estado Solicitud
    , JAQL420GESANU = P_RECUSU
    , JAQL420GESFEC = P_PGFAPE
    WHERE JAQL420EMP = 1 AND JAQL420COD = P_RECCOD;
    P_RECESR := ln_recesr; -- No Cambia del Estado Actual
    ---***
    --dbms_output.put_line('No Cambia el Estado Actual ...');
    ---***
  END IF;
  ---***
  COMMIT;
  ---***
END SP_AH_REC_ANULA;
/

