CREATE OR REPLACE PACKAGE "PQ_CL_CLMPERS" is
-- *****************************************************************
-- Nombre                       : PQ_CL_CLMPERS
-- Sistema                      : SORFY
-- M�dulo                       : Clientes
-- Versi�n                      : 1.0
-- Fecha de Creaci�n            : 02/01/2003
-- Autor de Creaci�n            : COMMIT S.A.C.
-- Uso                          : Maestro de Persona.
-- Estado                       : Activo
-- Acceso                       : P�blico
-- Fecha de Modificaci�n        : 2005.03.21
-- Autor de Modificaci�n        : Paola Vargas  17:15
-- Descripci�n de Modificaci�n  : Paola Vargas 2005.03.21 -> Nueva funci�n fn_cl_direcomp
-- Fecha de Modificaci�n        : 2008.04.23
-- Autor de Modificaci�n        : jsalasv
-- Descripci�n de Modificaci�n  : jsalasv 2008.04.23 -> Nueva funci�n sp_cl_trae_resext
-- Fecha de Modificaci�n        : 2008.08.21
-- Autor de Modificaci�n        : jsalasv
-- Descripci�n de Modificaci�n  : jsalasv 2008.08.21 -> Nueva funci�n SP_CL_IND_RENIEC
--                              : mgorvenia 2010.04.05 -> Se agrego fn_cl_codper_nom
--                                acruz 2010.04.16 -> Se agrego procedimiento sp_cl_datos_cce
--                              : mgorvenia 2010.08.04 -> Se modifico fn_cl_codper_nom.
-- *****************************************************************

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cl_descri(P_C_CODPER in varchar2) return varchar2;

--------------------------------------------------------------------
end pq_cl_clmpers;
/

