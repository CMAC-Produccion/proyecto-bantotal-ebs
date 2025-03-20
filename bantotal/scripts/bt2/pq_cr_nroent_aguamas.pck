create or replace package PQ_CR_NROENT_AGUAMAS is

  -- Author  : ABERNEDO
  -- Created : 27/03/2018 10:17:46 a.m.
  -- Purpose : NRO DE ENTIDADES DEL PANEL SALDO DEUDOR CONSUMO Y PYME
               --POR INSTANCIA PARA AGUA MAS

  -- Public function and procedure declarations
  Procedure sp_cr_entidades(ln_Instancia in number, ln_CantEnt out number);

end PQ_CR_NROENT_AGUAMAS;
/

create or replace package body PQ_CR_NROENT_AGUAMAS is

Procedure sp_cr_entidades(ln_Instancia in number, ln_CantEnt out number) is
  
ln_NumEnt number(10) := 0;
ln_tmod   number(4);
  
cursor entidades_rcc_P is --panel saldo deudor pyme
    
  select distinct (a.jaqy327enti)
    from jaqy327 a
   where a.jaqy327inst = ln_Instancia
     and a.jaqy327esta = 'S'
     and a.jaqy327chek = '1'
     and SUBSTR(a.jaqy327tcre, 1, 1) not in
         (select SUBSTR(aa.tp1desc, 1, 1)
            from fst198 aa
           Where aa.Tp1cod   = 1
             and aa.Tp1cod1  = 11114
             and aa.Tp1corr1 = 2
             and aa.Tp1corr2 = 1);
                 
cursor entidades_rcc_C is --panel saldo deudor consumo
    
  select distinct (a.jaqz862enti)
    from JAQZ862 a
   where a.jaqz862inst = ln_Instancia
     and a.jaqz862esta = 'S'
     and a.jaqz862chek = '1'
     and SUBSTR(a.jaqz862tcre, 1, 1) in
         (select SUBSTR(aa.tp1desc, 1, 1)
            from fst198 aa
           Where aa.Tp1cod = 1
             and aa.Tp1cod1 = 11114
             and aa.Tp1corr1 = 2
             and aa.Tp1corr2 = 2) -- no se esta excluyendo ningun tipo SBS
             ;                 
  
  begin
  
    --Obtener el tipo de modelo de evaluacion
    begin
        select a.sng021tmod
          into ln_tmod
          from sng021 a
         where a.sng021sol = ln_Instancia;
    exception
         when others then null;
    end;
    
    if ln_tmod = 13 then --independiente
        for i in entidades_rcc_P loop
          ln_NumEnt := ln_NumEnt + 1;
        
        end loop;
    end if;
    
    if ln_tmod = 14 then --dependiente
        for i in entidades_rcc_C loop
          ln_NumEnt := ln_NumEnt + 1;
        
        end loop;
    end if;
    
    
    ln_CantEnt := ln_NumEnt;
  
  end;
end PQ_CR_NROENT_AGUAMAS;
/

