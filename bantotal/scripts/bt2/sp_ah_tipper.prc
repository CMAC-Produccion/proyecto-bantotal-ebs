CREATE OR REPLACE PROCEDURE SP_AH_TIPPER(P_PAIS   IN NUMBER,
                                         P_TDOC   IN NUMBER,
                                         P_NDOC   IN VARCHAR,
                                         P_TIPPER OUT VARCHAR,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR) IS

  -- ***************************************************************************************
  -- Nombre                     : SP_AH_TIPPER
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECLAMOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.03.22
  -- Autor de Creación          : CVILLON
  -- Uso                        : CONSTANCIA DE RECLAMOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.03.22
  -- Modificado                 : CVILLON
  -- Descripción                : Determina el Tipo de Persona
  -- ***************************************************************************************

  ---***
  lc_NDOC   CHAR(12);
  lc_TDVAL  CHAR(1);
  lv_RUCINI VARCHAR(2);
  ---***

BEGIN
  ---***
  -- P_TIPPER := F(FISICA)/J(JURIDICA)
  P_TIPPER := 'F';
  P_ERRCOD := '000';
  P_ERRMSG := '';
  --lc_NDOC:= TRIM(P_NDOC);
  ---***

  IF (P_TDOC <> 0) THEN
    SELECT TDTVAL INTO lc_TDVAL FROM FST014 WHERE TDOCUM = P_TDOC;
  END IF;
  ---***
  IF (lc_TDVAL = 'F') THEN
    P_TIPPER := 'F';
  END IF;
  IF (lc_TDVAL = 'J') THEN
    P_TIPPER := 'J';
  END IF;
  IF (lc_TDVAL = 'A') THEN
    lv_RUCINI := SUBSTR(TRIM(P_NDOC), 1, 2);
    ---***
    DBMS_OUTPUT.PUT_LINE('lv_RUCINI:= ' || lv_RUCINI);
    ---***
    IF (P_TDOC = 9 AND lv_RUCINI = '20') THEN
      P_TIPPER := 'J';
    ELSE
      P_TIPPER := 'F';
    END IF;
  END IF;
  ---***
  DBMS_OUTPUT.PUT_LINE('P_TIPPER:= ' || P_TIPPER);
  ---***
END SP_AH_TIPPER;
/

