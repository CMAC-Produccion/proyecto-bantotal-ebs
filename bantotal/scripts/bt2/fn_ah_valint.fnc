create or replace function FN_AH_VALINT(P_N_NUMCTA IN NUMBER,
                                        P_N_PAIS   IN NUMBER,
                                        P_N_TIPDOC IN NUMBER,
                                        P_N_NUMDOC IN VARCHAR2          
                                       ) return varchar2 is
   -- *****************************************************************
    -- Nombre                     : FN_AH_VALINT
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Ahorros - Pasivas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 01/04/2024
    -- Autor de Creaci�n          : Yrving Lozada Bustamante
    -- Uso                        : Validaci�n de titularidad en cuenta cliente
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************                                        

  lv_indtit varchar2(1) := 'N';
begin
  select 'S'
    into lv_indtit 
    from fsr008 x 
   where x.pgcod  = 1
     and x.ctnro  = P_N_NUMCTA
     and x.pepais = P_N_PAIS
     and x.petdoc = P_N_TIPDOC
     and x.pendoc = rpad(P_N_NUMDOC,12,' ')   
     and x.ttcod  = 1
     and rownum   < 2;
     return lv_indtit;
exception
when others then
  lv_indtit := 'N';
  return lv_indtit;
end FN_AH_VALINT;
/

