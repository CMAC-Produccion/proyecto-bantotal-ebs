CREATE OR REPLACE PROCEDURE SP_AH_ENMASCARA_TDV(P_TEXTO   IN VARCHAR2,
                                                P_TEXTOEN OUT VARCHAR2,
                                                P_ERRCOD  OUT VARCHAR2,
                                                P_ERRMSG  OUT VARCHAR2) IS
  -- ***************************************************************************************
  -- Nombre                     : SP_AH_ENMASCARA_TDV
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : RECLAMOS
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 2025.07.01
  -- Autor de Creaci�n          : CVILLON
  -- Uso                        : RECLAMOS - Enmascarar Tarjetas
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 2025.07.01
  -- Modificado                 : CVILLON
  -- Descripci�n                : RECLAMOS - Enmascarar Tarjetas
  -- ***************************************************************************************
  -- ***************************************************************************************
  ---***
  ---***

  v_work  VARCHAR2(32767) := P_TEXTO;
  v_match VARCHAR2(100);
  v_pos   NUMBER;

BEGIN

  LOOP
    v_match := REGEXP_SUBSTR(v_work, '4261([0-9]{8})([0-9]{4})');
    EXIT WHEN v_match IS NULL;
  
    v_work := REPLACE(v_work,
                      v_match,
                      SUBSTR(v_match, 1, 4) || '********' ||
                      SUBSTR(v_match, 13, 4));
  END LOOP;

  P_TEXTOEN := v_work;
  P_ERRCOD  := '000';
  P_ERRMSG  := '';

EXCEPTION
  WHEN OTHERS THEN
    P_TEXTOEN := '';
    P_ERRCOD  := '001';
    P_ERRMSG  := '(' || sqlcode || ')' || ' : ' || sqlerrm;
    RETURN;
  
END SP_AH_ENMASCARA_TDV;
/
