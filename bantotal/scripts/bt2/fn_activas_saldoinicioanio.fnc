CREATE OR REPLACE FUNCTION FN_ACTIVAS_SALDOINICIOANIO (RUBROP IN NUMBER, FECHAP IN DATE )
RETURN NUMBER IS


-- *****************************************************************
    -- Nombre                     : FUNCION PARA OBTENER EL SALDO INICIAL DEL AÑO DE UN RUBRO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2018.09.12
    -- Autor de Creación          : WILLIAM RODRIGUEZ LAZO
    -- Uso                        : muestra el saldo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : rubro y fecha.
    --
    --
    --
    -- *****************************************************************


SALDOA NUMBER(19,2);

BEGIN

SALDOA :=0;

SELECT NVL(sum(H31.drsdmn),0)
INTO SALDOA
FROM FSH031 H31 WHERE H31.DRRUB = RUBROP
AND PGCOD=1
AND H31.DRFCH = TRUNC(FECHAP,'YYYY')-1;


RETURN SALDOA;

END;
/

