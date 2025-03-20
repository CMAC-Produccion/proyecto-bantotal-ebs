create or replace function FN_AH_VALINT(P_N_NUMCTA IN NUMBER,
                                        P_N_PAIS   IN NUMBER,
                                        P_N_TIPDOC IN NUMBER,
                                        P_N_NUMDOC IN VARCHAR2          
                                       ) return varchar2 is
   -- *****************************************************************
    -- Nombre                     : FN_AH_VALINT
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/04/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Validación de titularidad en cuenta cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
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

