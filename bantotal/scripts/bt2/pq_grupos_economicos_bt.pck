CREATE OR REPLACE PACKAGE "pq_grupos_economicos_bt" is
  -- *****************************************************************
  -- Nombre                       : PQ_CR_ADJUDICAR
  -- Sistema                      : SORFY
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 18/05/2007
  -- Autor de Creación            : yyampi
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- Descripción de Modificación  : 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

   procedure SP_CR_GRUPOS_ECONOMICOS(P_PERANO in varchar2,
                                    P_PERMES in varchar2
                                    );


end "pq_grupos_economicos_bt";
/

CREATE OR REPLACE PACKAGE BODY "pq_grupos_economicos_bt" is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_CR_GRUPOS_ECONOMICOS(P_PERANO in varchar2,
                                    P_PERMES in varchar2
                                    ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_GRUPOS_ECONOMICOS
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
  --cursor   
    
  begin
  
  
  null;
  
  
  end ;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  

end "pq_grupos_economicos_bt";

/*
   create public synonym pq_cr_adjudicar for pq_cr_adjudicar;
   grant execute on pq_cr_adjudicar to rol_sorfy,rol_sorfy_consulta;

*/
/

