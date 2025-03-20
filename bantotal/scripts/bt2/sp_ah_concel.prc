create or replace procedure SP_AH_CONCEL(P_N_PAIS   IN NUMBER,
                                         P_N_TIPDOC IN NUMBER,
                                         P_N_NUMDOC IN VARCHAR2, 
                                         P_N_NUMCEL IN NUMBER,
                                         p_c_indval out varchar2
                                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_AH_CONCEL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 24/04/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Consulta un celular si esta validado o nó.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                          
begin
  p_c_indval := FN_AH_CONCEL(P_N_PAIS,P_N_TIPDOC,P_N_NUMDOC,P_N_NUMCEL);
Exception
when others then  
  p_c_indval := 'N';
end SP_AH_CONCEL;
/

