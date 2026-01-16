CREATE OR REPLACE PROCEDURE SP_AH_ENMASCARA_TDV(P_TEXTO   IN VARCHAR2,
                                                P_TEXTOEN OUT VARCHAR2,
                                                P_ERRCOD  OUT VARCHAR2,
                                                P_ERRMSG  OUT VARCHAR2) IS
  -- ***************************************************************************************
  -- Nombre                     : SP_AH_ENMASCARA_TDV
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECLAMOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.07.01
  -- Autor de Creación          : CVILLON
  -- Uso                        : RECLAMOS - Enmascarar Tarjetas
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.11.14
  -- Modificado                 : CVILLON
  -- Descripción                : RECLAMOS - Enmascarar Tarjetas V2.0
  -- ***************************************************************************************
  -- ***************************************************************************************
  ---***
  ---***

  -- Variables
  v_work       VARCHAR2(32767);
  v_match      VARCHAR2(100);
  v_pos_inicio NUMBER;
  v_pos_match  NUMBER;
  v_separador  VARCHAR2(1);

  -- Constantes para patrones de tarjetas
  -- Soporta: Visa (4xxx), Mastercard (51-55, 2221-2720), Amex (34,37), Discover (6011,65), etc.
  c_patron_guion   CONSTANT VARCHAR2(100) := '[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}';
  c_patron_espacio CONSTANT VARCHAR2(100) := '[0-9]{4} [0-9]{4} [0-9]{4} [0-9]{4}';
  c_patron_junto   CONSTANT VARCHAR2(100) := '[0-9]{16}';

  -- Patrón adicional para American Express (15 dígitos)
  c_patron_amex_guion   CONSTANT VARCHAR2(100) := '[0-9]{4}-[0-9]{6}-[0-9]{5}';
  c_patron_amex_espacio CONSTANT VARCHAR2(100) := '[0-9]{4} [0-9]{6} [0-9]{5}';
  c_patron_amex_junto   CONSTANT VARCHAR2(100) := '[0-9]{15}';

  c_mascara      CONSTANT VARCHAR2(8) := '********';
  c_mascara_amex CONSTANT VARCHAR2(6) := '******';
  c_exito        CONSTANT VARCHAR2(3) := '000';
  c_error        CONSTANT VARCHAR2(3) := '001';

BEGIN
  -- Validación de entrada
  IF P_TEXTO IS NULL THEN
    P_TEXTOEN := NULL;
    P_ERRCOD  := c_exito;
    P_ERRMSG  := '';
    RETURN;
  END IF;

  v_work := P_TEXTO;

  -- ========================================
  -- PROCESAR TARJETAS DE 16 DÍGITOS
  -- ========================================

  -- Procesar patrón con guiones: XXXX-XXXX-XXXX-XXXX
  v_pos_inicio := 1;
  LOOP
    v_pos_match := REGEXP_INSTR(v_work, c_patron_guion, v_pos_inicio);
    EXIT WHEN v_pos_match = 0;
  
    v_match := REGEXP_SUBSTR(v_work, c_patron_guion, v_pos_inicio);
    EXIT WHEN v_match IS NULL;
  
    -- Reemplazar: XXXX-****-****-XXXX
    v_work := SUBSTR(v_work, 1, v_pos_match - 1) || SUBSTR(v_match, 1, 4) || '-' ||
              c_mascara || '-' || SUBSTR(v_match, 15, 4) ||
              SUBSTR(v_work, v_pos_match + LENGTH(v_match));
  
    v_pos_inicio := v_pos_match +
                    LENGTH(SUBSTR(v_match, 1, 4) || '-' || c_mascara || '-' ||
                           SUBSTR(v_match, 15, 4));
  END LOOP;

  -- Procesar patrón con espacios: XXXX XXXX XXXX XXXX
  v_pos_inicio := 1;
  LOOP
    v_pos_match := REGEXP_INSTR(v_work, c_patron_espacio, v_pos_inicio);
    EXIT WHEN v_pos_match = 0;
  
    v_match := REGEXP_SUBSTR(v_work, c_patron_espacio, v_pos_inicio);
    EXIT WHEN v_match IS NULL;
  
    -- Reemplazar: XXXX **** **** XXXX
    v_work := SUBSTR(v_work, 1, v_pos_match - 1) || SUBSTR(v_match, 1, 4) || ' ' ||
              c_mascara || ' ' || SUBSTR(v_match, 15, 4) ||
              SUBSTR(v_work, v_pos_match + LENGTH(v_match));
  
    v_pos_inicio := v_pos_match +
                    LENGTH(SUBSTR(v_match, 1, 4) || ' ' || c_mascara || ' ' ||
                           SUBSTR(v_match, 15, 4));
  END LOOP;

  -- Procesar patrón sin separadores: XXXXXXXXXXXXXXXX (16 dígitos)
  v_pos_inicio := 1;
  LOOP
    v_pos_match := REGEXP_INSTR(v_work, c_patron_junto, v_pos_inicio);
    EXIT WHEN v_pos_match = 0;
  
    v_match := REGEXP_SUBSTR(v_work, c_patron_junto, v_pos_inicio);
    EXIT WHEN v_match IS NULL;
  
    -- Reemplazar: XXXX********XXXX
    v_work := SUBSTR(v_work, 1, v_pos_match - 1) || SUBSTR(v_match, 1, 4) ||
              c_mascara || SUBSTR(v_match, 13, 4) ||
              SUBSTR(v_work, v_pos_match + LENGTH(v_match));
  
    v_pos_inicio := v_pos_match +
                    LENGTH(SUBSTR(v_match, 1, 4) || c_mascara ||
                           SUBSTR(v_match, 13, 4));
  END LOOP;

  -- ========================================
  -- PROCESAR AMERICAN EXPRESS (15 DÍGITOS)
  -- ========================================

  -- Procesar Amex con guiones: XXXX-XXXXXX-XXXXX
  v_pos_inicio := 1;
  LOOP
    v_pos_match := REGEXP_INSTR(v_work, c_patron_amex_guion, v_pos_inicio);
    EXIT WHEN v_pos_match = 0;
  
    v_match := REGEXP_SUBSTR(v_work, c_patron_amex_guion, v_pos_inicio);
    EXIT WHEN v_match IS NULL;
  
    -- Reemplazar: XXXX-******-XXXXX
    v_work := SUBSTR(v_work, 1, v_pos_match - 1) || SUBSTR(v_match, 1, 4) || '-' ||
              c_mascara_amex || '-' || SUBSTR(v_match, 12, 5) ||
              SUBSTR(v_work, v_pos_match + LENGTH(v_match));
  
    v_pos_inicio := v_pos_match +
                    LENGTH(SUBSTR(v_match, 1, 4) || '-' || c_mascara_amex || '-' ||
                           SUBSTR(v_match, 12, 5));
  END LOOP;

  -- Procesar Amex con espacios: XXXX XXXXXX XXXXX
  v_pos_inicio := 1;
  LOOP
    v_pos_match := REGEXP_INSTR(v_work, c_patron_amex_espacio, v_pos_inicio);
    EXIT WHEN v_pos_match = 0;
  
    v_match := REGEXP_SUBSTR(v_work, c_patron_amex_espacio, v_pos_inicio);
    EXIT WHEN v_match IS NULL;
  
    -- Reemplazar: XXXX ****** XXXXX
    v_work := SUBSTR(v_work, 1, v_pos_match - 1) || SUBSTR(v_match, 1, 4) || ' ' ||
              c_mascara_amex || ' ' || SUBSTR(v_match, 12, 5) ||
              SUBSTR(v_work, v_pos_match + LENGTH(v_match));
  
    v_pos_inicio := v_pos_match +
                    LENGTH(SUBSTR(v_match, 1, 4) || ' ' || c_mascara_amex || ' ' ||
                           SUBSTR(v_match, 12, 5));
  END LOOP;

  -- Procesar Amex sin separadores: XXXXXXXXXXXXXXX (15 dígitos)
  v_pos_inicio := 1;
  LOOP
    v_pos_match := REGEXP_INSTR(v_work, c_patron_amex_junto, v_pos_inicio);
    EXIT WHEN v_pos_match = 0;
  
    v_match := REGEXP_SUBSTR(v_work, c_patron_amex_junto, v_pos_inicio);
    EXIT WHEN v_match IS NULL;
  
    -- Reemplazar: XXXX*******XXXX (últimos 4 dígitos)
    v_work := SUBSTR(v_work, 1, v_pos_match - 1) || SUBSTR(v_match, 1, 4) ||
              '*******' || SUBSTR(v_match, 12, 4) ||
              SUBSTR(v_work, v_pos_match + LENGTH(v_match));
  
    v_pos_inicio := v_pos_match +
                    LENGTH(SUBSTR(v_match, 1, 4) || '*******' ||
                           SUBSTR(v_match, 12, 4));
  END LOOP;

  -- Resultado exitoso
  P_TEXTOEN := v_work;
  P_ERRCOD  := c_exito;
  P_ERRMSG  := '';

EXCEPTION
  WHEN OTHERS THEN
    -- Manejo de errores mejorado
    P_TEXTOEN := NULL;
    P_ERRCOD  := c_error;
    P_ERRMSG  := 'Error enmascarando tarjetas: (' || SQLCODE || ') ' ||
                 SQLERRM;
  
  -- Log del error (opcional, descomentar si tienes tabla de logs)
  -- INSERT INTO LOG_ERRORES (procedimiento, codigo, mensaje, fecha)
  -- VALUES ('SP_AH_ENMASCARA_TDV', SQLCODE, SQLERRM, SYSDATE);
  -- COMMIT;

END SP_AH_ENMASCARA_TDV;
/
