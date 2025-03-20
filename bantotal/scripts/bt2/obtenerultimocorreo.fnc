CREATE OR REPLACE FUNCTION ObtenerUltimoCorreo(p_cadena VARCHAR2) RETURN VARCHAR2 IS
    -- *****************************************************************
    -- Nombre                     : FUNCION PARA OBTENER EL ULTIMO CORREO DEL CLIENTE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.12.04
    -- Autor de Creación          : EDEHILTON NINA HURTADO
    -- Uso                        : Realiza la busqueda de caracteres.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    --
    --
    -- *****************************************************************

    v_correos VARCHAR2(4000);
    v_ultimo_correo VARCHAR2(255);
BEGIN
    -- Extraer todos los correos electrónicos de la cadena
    SELECT LISTAGG(REGEXP_SUBSTR(p_cadena, '[^\\]+@[[:alnum:]]+(\.[[:alnum:]]+)+', 1, LEVEL, NULL, 0), '\') 
           WITHIN GROUP (ORDER BY LEVEL) 
    INTO v_correos
    FROM dual
    CONNECT BY REGEXP_SUBSTR(p_cadena, '[^\\]+@[[:alnum:]]+(\.[[:alnum:]]+)+', 1, LEVEL, NULL, 0) IS NOT NULL;

    -- Separar los correos electrónicos y obtener el último
    v_ultimo_correo := REGEXP_SUBSTR(v_correos, '[^\\]+$', 1, 1);

    RETURN v_ultimo_correo;
END ObtenerUltimoCorreo;
/

