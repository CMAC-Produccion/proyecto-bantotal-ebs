CREATE OR REPLACE PROCEDURE SP_CCE_RESET_TELTX (p_fectra    IN  DATE,
                                                p_c_coderr  OUT VARCHAR2,
                                                p_c_msgerr  OUT VARCHAR2
) AS
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : SP_CCE_RESET_TELTX
  -- Sistema               : BANTOTAL
  -- Módulo                : BANTOTAL
  -- Versión               : 1.0
  -- Fecha de Creación     : 02/10/2025
  -- Autor de Creación     : Danny Manrique Callata
  -- Uso                   : Resetear registros diarios TelTX
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 
  -- Autor de Modificación : 
  -- Descripción Modific.  : 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------
 begin
    p_c_coderr := '00000';
    p_c_msgerr := 'Proceso Correcto';
    -- Cabecera Teltex
    DELETE FROM JAQN424 WHERE JAQN424FPR = p_fectra;
    -- Detalle Teltex
    DELETE FROM JAQN425 WHERE JAQN425FPR = p_fectra;
    -- Cuadre Teltex
    DELETE FROM AQPC918 WHERE AQPC918FECPRO = p_fectra;
    COMMIT;
exception
      when others then
        p_c_msgerr:='ERROR : ' || sqlerrm;
        p_c_coderr := '91401';

end SP_CCE_RESET_TELTX;
/
