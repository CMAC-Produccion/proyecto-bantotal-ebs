CREATE OR REPLACE PROCEDURE SP_AH_OBTENER_CORREO(P_PAIS   IN NUMBER,
                                                 P_TDOC   IN NUMBER,
                                                 P_NDOC   IN VARCHAR,
                                                 P_CORREO OUT VARCHAR) IS
  -- ***************************************************************************************
  -- Nombre                     : SP_AH_OBTENER_CORREO
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : RECLAMOS
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 2023.10.27
  -- Autor de Creaci�n          : CVILLON
  -- Uso                        : RECLAMOS - Obtener Correo del Cliente
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 2025.06.23
  -- Modificado                 : CVILLON
  -- Descripci�n                : EXPERIENCIA AL CLIENTE - Check Adicional
  -- ***************************************************************************************
  -- ***************************************************************************************
  ---***
  lv_CORREO VARCHAR(150);
  lc_NDOC   CHAR(12);
  ln_PEXREN NUMBER(3);
  ---***
BEGIN

  ---***
  lc_NDOC := TRIM(P_NDOC);
  ---***
  SELECT MAX(PEXREN)
    INTO ln_PEXREN
    FROM FSX001
   WHERE PEPAIS = P_PAIS
     AND PETDOC = P_TDOC
     AND PENDOC = lc_NDOC
     AND TXCOD = 0
     AND length(substr(trim(PEXTXT), 1, instr(trim(PEXTXT), '\') - 1)) > 0;

  SELECT substr(trim(PEXTXT), 1, instr(trim(PEXTXT), '\') - 1)
    INTO lv_CORREO
    FROM FSX001
   WHERE PEPAIS = P_PAIS
     AND PETDOC = P_TDOC
     AND PENDOC = lc_NDOC
     AND TXCOD = 0
     AND length(substr(trim(PEXTXT), 1, instr(trim(PEXTXT), '\') - 1)) > 0
     AND PEXREN = ln_PEXREN;
  ---***
  P_CORREO := LOWER(lv_CORREO);
  ---***

EXCEPTION
  WHEN OTHERS THEN
    P_CORREO := '';
  
END SP_AH_OBTENER_CORREO;
/
