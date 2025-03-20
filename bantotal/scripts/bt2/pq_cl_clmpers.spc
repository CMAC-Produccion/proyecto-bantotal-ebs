CREATE OR REPLACE PACKAGE "PQ_CL_CLMPERS" is
-- *****************************************************************
-- Nombre                       : PQ_CL_CLMPERS
-- Sistema                      : SORFY
-- Módulo                       : Clientes
-- Versión                      : 1.0
-- Fecha de Creación            : 02/01/2003
-- Autor de Creación            : COMMIT S.A.C.
-- Uso                          : Maestro de Persona.
-- Estado                       : Activo
-- Acceso                       : Público
-- Fecha de Modificación        : 2005.03.21
-- Autor de Modificación        : Paola Vargas  17:15
-- Descripción de Modificación  : Paola Vargas 2005.03.21 -> Nueva función fn_cl_direcomp
-- Fecha de Modificación        : 2008.04.23
-- Autor de Modificación        : jsalasv
-- Descripción de Modificación  : jsalasv 2008.04.23 -> Nueva función sp_cl_trae_resext
-- Fecha de Modificación        : 2008.08.21
-- Autor de Modificación        : jsalasv
-- Descripción de Modificación  : jsalasv 2008.08.21 -> Nueva función SP_CL_IND_RENIEC
--                              : mgorvenia 2010.04.05 -> Se agrego fn_cl_codper_nom
--                                acruz 2010.04.16 -> Se agrego procedimiento sp_cl_datos_cce
--                              : mgorvenia 2010.08.04 -> Se modifico fn_cl_codper_nom.
-- *****************************************************************

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cl_descri(P_C_CODPER in varchar2) return varchar2;

--------------------------------------------------------------------
end pq_cl_clmpers;
/

