create or replace package PQ_CR_TOPE_TASA is
 
    -- *****************************************************************
    -- Nombre                     : PQ_CR_TOPE_TASA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.27
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
                     v_tipevto in number,
                     v_tiptasa in number,
                     v_tasa    in number,
                     v_ubuser in varchar2,
                     v_coderr out number,
                     v_msgerr out varchar2
                     )  ;                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 PROCEDURE SP_CR_VALIDAINS(
                     v_instancia  in number,
                     v_fecape in date,
                     v_tasa   out number
                      ) ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_TOPE_TASA;
/

create or replace package body PQ_CR_TOPE_TASA is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_TOPE_TASA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.27
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
                     v_tipevto in number,
                     v_tiptasa in number,
                     v_tasa    in number,
                     v_ubuser in varchar2,
                     v_coderr out number,
                     v_msgerr out varchar2
                     )  is
                     
--  Ppgcod, paomod, paosuc, paomda, paopap, paooper, paosbop, paotope, tipoevento, tipotasa, tasa, ubuser, Errcod, Errmsg
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

ln_Tasa number;
ln_fecini number;
ln_fecfin number;
ld_fecini date;
ld_fecfin date;
ld_fecsis date;

BEGIN

    begin
        select f.pgfape
          into ld_fecsis
          from fst017 f
         where f.pgcod = 1;  
    end;      
       
    --existe en tabla
    begin
      
        select f.tp1imp1, f.tp1nro1, f.tp1nro2
         into ln_Tasa, ln_fecini, ln_fecfin
         from fst198 f 
        where f.TP1COD = 1
          and f.TP1COD1 = 11156 
          and f.tp1corr1 = 10
          and f.tp1corr2 = 1
          and f.tp1nro3 =  v_Scmda
          and f.tp1imp2 =  1;
              
    exception when others then
      ln_Tasa  := null;
      ln_fecini := null; 
      ln_fecfin := null;
    end;     

    ld_fecini := to_date(ln_fecini, 'RRRRMMDD');
    ld_fecfin := to_date(ln_fecfin, 'RRRRMMDD');

    if ld_fecsis >= ld_fecini and ld_fecsis <= ld_fecfin then

        if v_tipevto = 3 then -- si es cambio de tasa interes
          
           if v_tasa > ln_Tasa then --si tasa propuesta es mayor a tasa tope
              v_coderr   := 1;
              v_msgerr   := 'Tasa excede el tope permitido de '||ln_Tasa;       
           else   
              v_coderr   := 0;
              v_msgerr   := null;
           end if;
        else   
              v_coderr   := 0;
              v_msgerr   := null;
        end if;
  
    else --sino se encuentra en el rango de fechas no valida
       v_coderr   := 0;
       v_msgerr   := null;   
    end if;    
    
 end SP_CR_VALIDA;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 PROCEDURE SP_CR_VALIDAINS(
                     v_instancia  in number,
                     v_fecape in date,
                     v_tasa   out number
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

ln_Tasa number;
ln_fecini number;
ln_fecfin number;
ld_fecini date;
ld_fecfin date;
ld_fecsis date;
ln_moneda number;

BEGIN

    ld_fecsis := v_fecape;
          
    begin
        select x.xwfmoneda
          into ln_moneda
          from xwf700 x
         where x.xwfprcins =  v_instancia
           and x.xwfcar3 = '1';        
    exception when others then
       null;
    end;      

    --existe en tabla
    begin
         select f.tp1imp1, f.tp1nro1, f.tp1nro2
         into ln_Tasa, ln_fecini, ln_fecfin
         from fst198 f 
        where f.TP1COD = 1
          and f.TP1COD1 = 11156 
          and f.tp1corr1 = 10
          and f.tp1corr2 = 1
          and f.tp1nro3 =  ln_moneda
          and f.tp1imp2 =  1;
              
    exception when others then
      ln_Tasa  := null;
      ln_fecini := null; 
      ln_fecfin := null;
    end;     

    ld_fecini := to_date(ln_fecini, 'RRRRMMDD');
    ld_fecfin := to_date(ln_fecfin, 'RRRRMMDD');

    if ld_fecsis >= ld_fecini and ld_fecsis <= ld_fecfin then

       v_tasa := ln_Tasa;
  
    else --sino se encuentra en el rango de fechas no valida
       v_tasa := 0;
    end if;    
    
 end SP_CR_VALIDAINS;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_TOPE_TASA;
/

