CREATE OR REPLACE PROCEDURE SP_CR_AGREGA_AQPC565VAR(CODREPROG  IN NUMBER,
                                                    INSTANCIA  IN NUMBER,
                                                    AQPC565VAR OUT VARCHAR2,
                                                    CODERROR   OUT VARCHAR2,
                                                    MSGERROR   OUT VARCHAR2) IS
   -- *****************************************************************
    -- Nombre                     : SP_CR_AGREGA_AQPC565VAR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/09/2025
    -- Autor de Creación          : MCORDOVA
    -- Uso                        : Forma parte del proceso de bot de reprogramaciones.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************

  FECHAREPROG DATE;
BEGIN

  BEGIN
  
    SELECT aqpb556fecrpg
      INTO FECHAREPROG
      FROM aqpb556
     WHERE AQPB556COD = CODREPROG;
    CODERROR   := '00000';
    MSGERROR   := 'Ok';
    AQPC565VAR := 've_fec_reprog|D|' || TO_CHAR(FECHAREPROG, 'DD/MM/YYYY') || ';' ||
                  've_cod_reprog|N|' || TRIM(TO_CHAR(CODREPROG)) || ';' ||
                  've_inst|N|' || TRIM(TO_CHAR(INSTANCIA)) || '';
  
  EXCEPTION
    WHEN OTHERS THEN
      CODERROR   := '00001';
      MSGERROR   := 'Error';
      AQPC565VAR := '';
  END;

END;
/
