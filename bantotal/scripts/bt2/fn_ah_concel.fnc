create or replace function FN_AH_CONCEL(P_N_PAIS   IN NUMBER,
                                        P_N_TIPDOC IN NUMBER,
                                        P_N_NUMDOC IN VARCHAR2,          
                                        P_N_NUMCEL IN NUMBER
                                       ) return varchar2 is
   -- *****************************************************************
    -- Nombre                     : FN_AH_CONCEL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/04/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Consulta un celular si esta validado o no de acuerdo a la guia parametrizada
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                        

  lv_indval varchar2(1) := 'N';
begin
  select decode(TRIM(x.jaqn2aest),'VALIDADO','S','N')
    into lv_indval
    from jaqn2a x, 
         jaqn3a y
   where x.jaqn2apai  = y.jaqn3apai
     and x.jaqn2atdoc = y.jaqn3atdoc
     and x.jaqn2andoc = y.jaqn3andoc
     and x.jaqn2acor  = y.jaqn3acor
     and x.jaqn2afeg  = y.jaqn3afeg
     and x.jaqn2atipv = y.jaqn3atipv
     and y.jaqn3avig  = 'S'
     and x.jaqn2apai  = P_N_PAIS
     and x.jaqn2atdoc = P_N_TIPDOC
     and x.jaqn2andoc = P_N_NUMDOC
     and trim(x.jaqn2atelf) is not null
     and x.jaqn2atelf = P_N_NUMCEL;
                           
     return lv_indval;
exception
when others then
  lv_indval := 'N';
  return lv_indval;
end FN_AH_CONCEL;
/

