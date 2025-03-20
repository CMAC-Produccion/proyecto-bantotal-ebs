create or replace procedure SP_AH_CONMAIL(P_N_PAIS   IN NUMBER,
                                         P_N_TIPDOC  IN NUMBER,
                                         P_N_NUMDOC  IN VARCHAR2, 
                                         P_C_MAIL    IN VARCHAR2,
                                         p_c_indval out varchar2
                                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_AH_CONMAIL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 24/04/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Consulta si un correo esta validado o nó.
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
  select decode(TRIM(x.jaqn2aest),'VALIDADO','S','N')
    into p_c_indval
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
     and trim(x.jaqn2acorr) is not null
     and upper(trim(x.jaqn2acorr)) = upper(trim(P_C_MAIL));
exception
when others then
  p_c_indval := 'N';
end SP_AH_CONMAIL;
/

