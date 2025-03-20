create or replace package PQ_CR_CARGA_AQPB252 is
 
    -- *****************************************************************
    -- Nombre                     : CARGAR DATA REFINANCIACION - JAQN870
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.09.23
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
                     v_fecini out date,
                     v_fecfin out date,    
                     v_ind    out varchar2
                     ) ;                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_CARGA_AQPB252;
/

create or replace package body PQ_CR_CARGA_AQPB252 is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_CARGA_AQPB252
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.09.23
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA INFORMACION AQPB252
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
                     v_fecini out date,
                     v_fecfin out date,                     
                     v_ind    out varchar2
                     )  is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_VALIDA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.10.19
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

      --existe en tabla
    begin
       select 'S', j.aqpb252fini, j.aqpb252ffin
         into v_ind , v_fecini, v_fecfin        
         from aqpb252 j
        where j.aqpb252emp = v_Pgcod 
          and j.aqpb252mod = v_Scmod 
          and j.aqpb252suc = v_Scsuc 
          and j.aqpb252mda = v_Scmda 
          and j.aqpb252pap = v_Scpap 
          and j.aqpb252cta = v_Sccta 
          and j.aqpb252oper = v_Scoper
          and j.aqpb252sbop = v_Scsbop
          and j.aqpb252top = v_Sctope
          and j.aqpb252est = 'S';  
              
    exception when others then
      v_ind := 'N';
      v_fecini := null; 
      v_fecfin := null;
    end;     

      
 end SP_CR_VALIDA;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_CARGA_AQPB252;
/

