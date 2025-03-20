CREATE OR REPLACE PROCEDURE SP_MAXFECAN (SENTENCIA IN VARCHAR2,
										FECMAX IN OUT DATE) IS
    -- *****************************************************************
    -- Nombre                     : SP_MAXFECAN
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          :
    -- Autor de Creaci�n          : DBEDOYA
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : PRIVADO
    -- Par�metros de Entrada      :
    --
    -- Retorno                    :
    -- Fecha de Modificaci�n      :
    -- Autor de la Modificaci�n   :
    -- Descripci�n de Modificaci�n:
    --
    -- *****************************************************************
BEGIN

  EXECUTE IMMEDIATE SENTENCIA INTO FECMAX ;

END SP_MAXFECAN;
/

