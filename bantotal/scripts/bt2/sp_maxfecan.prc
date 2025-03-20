CREATE OR REPLACE PROCEDURE SP_MAXFECAN (SENTENCIA IN VARCHAR2,
										FECMAX IN OUT DATE) IS
    -- *****************************************************************
    -- Nombre                     : SP_MAXFECAN
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : DBEDOYA
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : PRIVADO
    -- Parámetros de Entrada      :
    --
    -- Retorno                    :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
BEGIN

  EXECUTE IMMEDIATE SENTENCIA INTO FECMAX ;

END SP_MAXFECAN;
/

