create or replace package PQ_CR_TABLA_AQPB433 is
 
    -- *****************************************************************
    -- Nombre                     : CARGAR AQPB433
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.08.05
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
 PROCEDURE SP_CR_VALIDA(
                     v_Pgcod  in number,
                     v_Scmod  in number,
                     v_Scsuc  in number,
                     v_Scmda  in number,
                     v_Scpap  in number,
                     v_Sccta  in number,
                     v_Scoper in number,
                     v_Scsbop in number,
                     v_Sctope in number,
                     v_ind    out number
                     ) ;                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_TABLA_AQPB433;
/

create or replace package body PQ_CR_TABLA_AQPB433 is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_TABLA_AQPB433
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.08.05
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 
    -- *****************************************************************
      


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
 PROCEDURE SP_CR_VALIDA(
                     v_Pgcod  in number,
                     v_Scmod  in number,
                     v_Scsuc  in number,
                     v_Scmda  in number,
                     v_Scpap  in number,
                     v_Sccta  in number,
                     v_Scoper in number,
                     v_Scsbop in number,
                     v_Sctope in number,
                     v_ind    out number
                     )  is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_VALIDA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2021.08.05
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Indicador
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 



BEGIN


    begin
      select a.aqpb433pcj
       into v_ind
       from aqpb433 a
      where a.aqpb433cod = v_Pgcod 
        and a.aqpb433mod = v_Scmod 
        and a.aqpb433suc = v_Scsuc 
        and a.aqpb433mda = v_Scmda 
        and a.aqpb433pap = v_Scpap 
        and a.aqpb433cta = v_Sccta 
        and a.aqpb433ope = v_Scoper
        and a.aqpb433sbo = v_Scsbop
        and a.aqpb433top = v_Sctope
        and a.aqpb433est = 'C'; 
              
    exception when others then
      v_ind := 0;
    end;     

      
 end SP_CR_VALIDA;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_TABLA_AQPB433;
/

