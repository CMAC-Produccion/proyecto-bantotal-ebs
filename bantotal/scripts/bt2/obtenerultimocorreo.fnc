CREATE OR REPLACE FUNCTION ObtenerUltimoCorreo(p_cadena VARCHAR2) RETURN VARCHAR2 IS
    -- *****************************************************************
    -- Nombre                     : FUNCION PARA OBTENER EL ULTIMO CORREO DEL CLIENTE
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Ahorros - Pasivas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 2023.12.04
    -- Autor de Creaci�n          : EDEHILTON NINA HURTADO
    -- Uso                        : Realiza la busqueda de caracteres.
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      :
    --
    --
    --
    -- *****************************************************************

    v_correos VARCHAR2(4000);
    v_ultimo_correo VARCHAR2(255);
BEGIN
    -- Extraer todos los correos electr�nicos de la cadena
    SELECT LISTAGG(REGEXP_SUBSTR(p_cadena, '[^\\]+@[[:alnum:]]+(\.[[:alnum:]]+)+', 1, LEVEL, NULL, 0), '\') 
           WITHIN GROUP (ORDER BY LEVEL) 
    INTO v_correos
    FROM dual
    CONNECT BY REGEXP_SUBSTR(p_cadena, '[^\\]+@[[:alnum:]]+(\.[[:alnum:]]+)+', 1, LEVEL, NULL, 0) IS NOT NULL;

    -- Separar los correos electr�nicos y obtener el �ltimo
    v_ultimo_correo := REGEXP_SUBSTR(v_correos, '[^\\]+$', 1, 1);

    RETURN v_ultimo_correo;
END ObtenerUltimoCorreo;
/

