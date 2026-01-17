CREATE OR REPLACE PROCEDURE SP_AH_BASEFRAUDES (
    p_codigo   IN  NUMBER,
    p_valor    IN  VARCHAR2,
    p_salida   OUT VARCHAR2
) AS
   -- *****************************************************************
    -- Nombre                     : SP_AH_BASEFRAUDES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/11/2025
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Paquete relacionado a la base negativa de fraudes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 04/12/2025
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se adicionó validadicón del estado en "S"
    -- Fecha de Modificación      : 14/01/2026
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se corrigió validación de correo con expresion regular
    -- *****************************************************************   
	v_count NUMBER;
BEGIN
  
	 IF p_codigo = 3 THEN
     	SELECT CASE 
                 WHEN EXISTS (
                   SELECT 1
                   FROM AQPA133
                   WHERE AQPA133EST = 'S'
                     AND AQPA133TIP = p_codigo
                     AND REGEXP_REPLACE(AQPA133VAL, '[[:space:]]+', '') = TRIM(p_valor)
                 )
                 THEN 'S'
                 ELSE 'N'
               END
        INTO p_salida
        FROM DUAL;   
    ELSE
    
        SELECT COUNT(*) INTO v_count
	    FROM AQPA133 
	    WHERE AQPA133EST = 'S' 
      AND AQPA133TIP = p_codigo
	   	AND REGEXP_REPLACE(UPPER(AQPA133VAL), '[[:space:]]+', '') = UPPER(TRIM(p_Valor))
	   	AND ROWNUM = 1; 
		 
		IF v_count > 0 THEN
	        p_salida := 'S';
	    ELSE
	        p_salida := 'N';
	    END IF;
	    
    END IF;
	
	
   
 EXCEPTION
    WHEN OTHERS THEN
        p_salida := 'N';
END SP_AH_BASEFRAUDES;
/
