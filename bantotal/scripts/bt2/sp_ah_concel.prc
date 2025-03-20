create or replace procedure SP_AH_CONCEL(P_N_PAIS   IN NUMBER,
                                         P_N_TIPDOC IN NUMBER,
                                         P_N_NUMDOC IN VARCHAR2, 
                                         P_N_NUMCEL IN NUMBER,
                                         p_c_indval out varchar2
                                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_AH_CONCEL
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Ahorros - Pasivas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 24/04/2024
    -- Autor de Creaci�n          : Yrving Lozada Bustamante
    -- Uso                        : Consulta un celular si esta validado o n�.
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************                                          
begin
  p_c_indval := FN_AH_CONCEL(P_N_PAIS,P_N_TIPDOC,P_N_NUMDOC,P_N_NUMCEL);
Exception
when others then  
  p_c_indval := 'N';
end SP_AH_CONCEL;
/

