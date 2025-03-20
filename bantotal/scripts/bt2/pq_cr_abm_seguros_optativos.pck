create or replace package PQ_CR_ABM_SEGUROS_OPTATIVOS is
    -- *****************************************************************
    -- Nombre                     : ABM
    -- Sistema                    : BANTOTAL        
    -- Módulo                     : CREDITOS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.07.13
    -- Autor de Creación          : MSOLARI 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de la Modificación   : -
    -- Descripción de Modificación: -
    -- ***************************************************************** 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Procedure sp_Cuotas_Impagas(ln_cod  in number, ln_mod  in number, ln_suc  in number, 
                            ln_mda  in number, ln_pap  in number, ln_cta  in number, 
                            ln_oper in number, ln_sbop in number, ln_tope in number,
                            ld_fcha out date); 
                            
Procedure sp_Seguro(ln_cod  in number, ln_mod  in number, ln_suc  in number, 
                    ln_mda  in number, ln_pap  in number, ln_cta  in number, 
                    ln_oper in number, ln_sbop in number, ln_tope in number,
                    ln_SgCod out number);       
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_CR_ABM_SEGUROS_OPTATIVOS;
/

create or replace package body PQ_CR_ABM_SEGUROS_OPTATIVOS is
    -- *****************************************************************
    -- Nombre                     : ABM
    -- Sistema                    : BANTOTAL
    -- Módulo                     : CREDITOS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.07.13
    -- Autor de Creación          : MSOLARI 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de la Modificación   : -
    -- Descripción de Modificación: -
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Cuotas_Impagas(ln_cod  in number, ln_mod  in number, ln_suc  in number, 
                             ln_mda  in number, ln_pap  in number, ln_cta  in number, 
                             ln_oper in number, ln_sbop in number, ln_tope in number,
                             ld_fcha out date) is
 
 Begin
   Begin   

      select  distinct min(f01.ppfpag) ppfpag
        into ld_fcha
        from fsd601 f01 
        inner join fsd010 a 
           on f01.pgcod  = a.pgcod 
          and f01.ppmod  = a.aomod  
          and f01.ppsuc  = a.aosuc  
          and f01.ppmda  = a.aomda  
          and f01.pppap  = a.aopap  
          and f01.ppcta  = a.aocta  
          and f01.ppoper = a.aooper 
          and f01.ppsbop = a.aosbop 
          and f01.pptope = a.aotope
        left  join fsd602 f02
           on f01.pgcod  = f02.pgcod 
          and f01.ppmod  = f02.ppmod  
          and f01.ppsuc  = f02.ppsuc  
          and f01.ppmda  = f02.ppmda  
          and f01.pppap  = f02.pppap  
          and f01.ppcta  = f02.ppcta  
          and f01.ppoper = f02.ppoper 
          and f01.ppsbop = f02.ppsbop 
          and f01.pptope = f02.pptope
          and f01.ppfpag = f02.ppfpag
          and f02.d602co = 'S'
          where f02.ppfpag is null
          and (a.aomod in (select modulo
                             from fst111
                            where dscod = 50)) 
          and a.aostat  <> 99
          and f01.ppstat <> 'P'
          and f01.pgcod  = ln_cod
          and f01.ppmod  = ln_mod
          and f01.ppsuc  = ln_suc
          and f01.ppmda  = ln_mda
          and f01.pppap  = ln_pap
          and f01.ppcta  = ln_cta
          and f01.ppoper = ln_oper
          and f01.ppsbop = ln_sbop
          and f01.pptope = ln_tope;                      
   End;
 End sp_Cuotas_Impagas; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure sp_Seguro(ln_cod  in number, ln_mod  in number, ln_suc  in number, 
                    ln_mda  in number, ln_pap  in number, ln_cta  in number, 
                    ln_oper in number, ln_sbop in number, ln_tope in number,
                    ln_SgCod out number) is
 
 Begin
   Begin   
       select fp.sgcod
         into ln_SgCod
         from fpp001 fp 
        where fp.pgcod  = ln_cod
          and fp.aomod  = ln_mod   
          and fp.aosuc  = ln_suc   
          and fp.aomda  = ln_mda   
          and fp.aopap  = ln_pap 
          and fp.aocta  = ln_cta 
          and fp.aooper = ln_oper
          and fp.aosbop = ln_sbop
          and fp.aotope = ln_tope 
          and rownum = 1;
       Exception when no_data_found then
          ln_SgCod := 0;       
   End;
 End sp_Seguro; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
End PQ_CR_ABM_SEGUROS_OPTATIVOS;
/

