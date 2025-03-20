CREATE OR REPLACE PACKAGE "pq_grupos_economicos_bt" is
  -- *****************************************************************
  -- Nombre                       : PQ_CR_ADJUDICAR
  -- Sistema                      : SORFY
  -- M�dulo                       : Cr�ditos
  -- Versi�n                      : 1.0
  -- Fecha de Creaci�n            : 18/05/2007
  -- Autor de Creaci�n            : yyampi
  -- Estado                       : Activo
  -- Acceso                       : P�blico
  -- Fecha de Modificaci�n        : 
  -- Autor de Modificaci�n        : 
  -- Descripci�n de Modificaci�n  : 
  -- Descripci�n de Modificaci�n  : 
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
    -- M�dulo                     : Cr�ditos
    -- Versi�n                    : 
    -- Fecha de Creaci�n          : 
    -- Autor de Creaci�n          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : P_PERANO ( a�o del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Par�metros de Salida       : 
    -- Fecha de Modificaci�n      :
    -- Autor de la Modificaci�n   :
    -- Descripci�n de Modificaci�n:
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Cr�dito.   
    
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

