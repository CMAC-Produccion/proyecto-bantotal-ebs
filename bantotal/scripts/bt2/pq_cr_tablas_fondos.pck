create or replace package PQ_CR_TABLAS_FONDOS is
 
    -- *****************************************************************
    -- Nombre                     : PQ_CR_TABLAS_FONDOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.10.16
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : ACTUALIZA PK EN TABLAS FONDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2020.12.27
    -- Autor de la Modificación   : Dcastro 
    -- Descripción de Modificación: SE modifico procedimiento sp_cr_datos.
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 PROCEDURE SP_CR_AQPB067B(
                     pd_fecpro in date,
                     pn_corr   in number                                          
                     ) ;   
                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_CR_AQPB073B(
                     pd_fecpro in date,
                     pn_corr   in number                                          
                     ) ;   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_CR_AQPB065B(
                     pd_fecpro in date,
                     pn_corr   in number                                          
                     ) ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE SP_CR_AQPB095B(
                     pd_fecpro in date,
                     pn_corr   in number                                          
                     ) ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  PROCEDURE SP_CR_DATOSCRE(
                     pn_cta in number,
                     pn_ope in number,
                     pn_emp out number,
                     pn_mod out number,
                     pn_suc out number,
                     pn_mda out number,
                     pn_pap out number,
                     pn_sbo out number,
                     pn_top out number
                    );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_TABLAS_FONDOS;
/

create or replace package body PQ_CR_TABLAS_FONDOS is
 
    -- *****************************************************************
    -- Nombre                     : PQ_CR_TABLAS_FONDOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.10.16
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : ACTUALIZA PK EN TABLAS FONDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
     


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_AQPB067B(
                     pd_fecpro in date,
                     pn_corr   in number                                          
                     ) is   
    -- *****************************************************************
    -- Nombre                     : SP_CR_AQPB067B
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2020.10.16
    -- Autor de Creacion          : DCASTRO
    -- Uso                        : Almacena campos de pk del credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
  CURSOR listado is
  select distinct a.aqpb067bfec, a.aqpb067bcor, a.aqpb067bcta, a.aqpb067bope
    from aqpb067b a
   where a.aqpb067bfec = pd_fecpro
     and a.aqpb067bcor = pn_corr;

  ln_pgcod number;
  ln_mod   number;
  ln_suc   number; 
  ln_mda   number;
  ln_pap   number;
  ln_sbop  number;
  ln_tope  number;


  BEGIN

  for i in listado loop
    ln_pgcod := 0;
      
    begin
     pq_cr_tablas_fondos.sp_cr_datoscre(pn_cta => i.aqpb067bcta,
                                        pn_ope => i.aqpb067bope,
                                        pn_emp => ln_pgcod,
                                        pn_mod => ln_mod,
                                        pn_suc => ln_suc,
                                        pn_mda => ln_mda,
                                        pn_pap => ln_pap,
                                        pn_sbo => ln_sbop,
                                        pn_top => ln_tope);
    end;
   
    if ln_pgcod <> 0 then
       update aqpb067b a 
          set a.aqpb067bcod = ln_pgcod,
              a.aqpb067bmod = ln_mod, 
              a.aqpb067bsuc = ln_suc, 
              a.aqpb067bmda = ln_mda, 
              a.aqpb067bpap = ln_pap, 
              a.aqpb067bsbo = ln_sbop, 
              a.aqpb067btop = ln_tope
        where a.aqpb067bfec = i.aqpb067bfec
          and a.aqpb067bcor = i.aqpb067bcor
          and a.aqpb067bcta = i.aqpb067bcta 
          and a.aqpb067bope = i.aqpb067bope;
          
        commit;
     end if;
  end loop;

 
 END SP_CR_AQPB067B;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_AQPB073B(
                     pd_fecpro in date,
                     pn_corr   in number                                          
                     ) is   
    -- *****************************************************************
    -- Nombre                     : SP_CR_AQPB073B
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2020.10.16
    -- Autor de Creacion          : DCASTRO
    -- Uso                        : Almacena campos de pk del credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
  CURSOR listado is
  select distinct a.aqpb073bfec, a.aqpb073bcor, a.aqpb073bcta, a.aqpb073bope
    from aqpb073b a
   where a.aqpb073bfec = pd_fecpro
     and a.aqpb073bcor = pn_corr;
     
     

  ln_pgcod number;
  ln_mod   number;
  ln_suc   number; 
  ln_mda   number;
  ln_pap   number;
  ln_sbop  number;
  ln_tope  number;


  BEGIN

  for i in listado loop
      ln_pgcod := 0;
      
    begin
     pq_cr_tablas_fondos.sp_cr_datoscre(pn_cta => i.aqpb073bcta,
                                        pn_ope => i.aqpb073bope,
                                        pn_emp => ln_pgcod,
                                        pn_mod => ln_mod,
                                        pn_suc => ln_suc,
                                        pn_mda => ln_mda,
                                        pn_pap => ln_pap,
                                        pn_sbo => ln_sbop,
                                        pn_top => ln_tope);
    end;
   
    if ln_pgcod <> 0 then
       update aqpb073b a 
          set a.aqpb073bcod = ln_pgcod,
              a.aqpb073bmod = ln_mod, 
              a.aqpb073bsuc = ln_suc, 
              a.aqpb073bmda = ln_mda, 
              a.aqpb073bpap = ln_pap, 
              a.aqpb073bsbo = ln_sbop, 
              a.aqpb073btop = ln_tope
        where a.aqpb073bfec = i.aqpb073bfec
          and a.aqpb073bcor = i.aqpb073bcor
          and a.aqpb073bcta = i.aqpb073bcta 
          and a.aqpb073bope = i.aqpb073bope;
          
        commit;
     end if;
  end loop;

 
 END SP_CR_AQPB073B;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_CR_AQPB065B(
                     pd_fecpro in date,
                     pn_corr   in number                                          
                     ) is   
    -- *****************************************************************
    -- Nombre                     : SP_CR_AQPB065B
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2020.10.16
    -- Autor de Creacion          : DCASTRO
    -- Uso                        : Almacena campos de pk del credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
  CURSOR listado is
  select distinct a.aqpb065bfec, a.aqpb065bcor, a.aqpb065bcta, a.aqpb065bope
    from aqpb065b a
   where a.aqpb065bfec = pd_fecpro
     and a.aqpb065bcor = pn_corr;

  ln_pgcod number;
  ln_mod   number;
  ln_suc   number; 
  ln_mda   number;
  ln_pap   number;
  ln_sbop  number;
  ln_tope  number;


  BEGIN

  for i in listado loop
     ln_pgcod := 0;
      
    begin
     pq_cr_tablas_fondos.sp_cr_datoscre(pn_cta => i.aqpb065bcta,
                                        pn_ope => i.aqpb065bope,
                                        pn_emp => ln_pgcod,
                                        pn_mod => ln_mod,
                                        pn_suc => ln_suc,
                                        pn_mda => ln_mda,
                                        pn_pap => ln_pap,
                                        pn_sbo => ln_sbop,
                                        pn_top => ln_tope);
    end;

   
    if ln_pgcod <> 0 then
       update aqpb065b a 
          set a.aqpb065bcod = ln_pgcod,
              a.aqpb065bmod = ln_mod, 
              a.aqpb065bsuc = ln_suc, 
              a.aqpb065bmda = ln_mda, 
              a.aqpb065bpap = ln_pap, 
              a.aqpb065bsbo = ln_sbop, 
              a.aqpb065btop = ln_tope
        where a.aqpb065bfec = i.aqpb065bfec
          and a.aqpb065bcor = i.aqpb065bcor
          and a.aqpb065bcta = i.aqpb065bcta 
          and a.aqpb065bope = i.aqpb065bope;
          
        commit;
     end if;
  end loop;

 
 END SP_CR_AQPB065B;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_CR_AQPB095B(
                     pd_fecpro in date,
                     pn_corr   in number                                          
                     ) is   
    -- *****************************************************************
    -- Nombre                     : SP_CR_AQPB095B
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2020.05.07
    -- Autor de Creacion          : jrodriguej
    -- Uso                        : Almacena campos de pk del credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
  CURSOR listado is
  select distinct a.aqpb095bfec, a.aqpb095bcor, a.aqpb095bcta, a.aqpb095bope
    from aqpb095b a
   where a.aqpb095bfec = pd_fecpro
     and a.aqpb095bcor = pn_corr;

  ln_pgcod number;
  ln_mod   number;
  ln_suc   number; 
  ln_mda   number;
  ln_pap   number;
  ln_sbop  number;
  ln_tope  number;


  BEGIN

  for i in listado loop
     ln_pgcod := 0;
      
    begin
     pq_cr_tablas_fondos.sp_cr_datoscre(pn_cta => i.aqpb095bcta,
                                        pn_ope => i.aqpb095bope,
                                        pn_emp => ln_pgcod,
                                        pn_mod => ln_mod,
                                        pn_suc => ln_suc,
                                        pn_mda => ln_mda,
                                        pn_pap => ln_pap,
                                        pn_sbo => ln_sbop,
                                        pn_top => ln_tope);
    end;

   
    if ln_pgcod <> 0 then
       update aqpb095b a 
          set a.aqpb095bcod = ln_pgcod,
              a.aqpb095bmod = ln_mod, 
              a.aqpb095bsuc = ln_suc, 
              a.aqpb095bmda = ln_mda, 
              a.aqpb095bpap = ln_pap, 
              a.aqpb095bsbo = ln_sbop, 
              a.aqpb095btop = ln_tope
        where a.aqpb095bfec = i.aqpb095bfec
          and a.aqpb095bcor = i.aqpb095bcor
          and a.aqpb095bcta = i.aqpb095bcta 
          and a.aqpb095bope = i.aqpb095bope;
          
        commit;
     end if;
  end loop;

 
 END SP_CR_AQPB095B;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_CR_DATOSCRE(
                           pn_cta in number,
                           pn_ope in number,
                           pn_emp out number,
                           pn_mod out number,
                           pn_suc out number,
                           pn_mda out number,
                           pn_pap out number,
                           pn_sbo out number,
                           pn_top out number
  ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOSCRE
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2020.10.16
    -- Autor de Creacion          : DCASTRO
    -- Uso                        : Almacena campos de pk del credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      : 
    -- Fecha                      : 2020.12.27
    -- Modificado                 : DCASTRO                             
    -- Descripcion                : Se agrego exclusion de modulo diferidos 419
    --                              
    -- ***************************************************************** 
 BEGIN
    
       pn_emp := 0;
       
       begin
         select f.pgcod, f.aomod, f.aosuc, f.aomda, f.aopap, f.aosbop, f.aotope
           into pn_emp, pn_mod, pn_suc, pn_mda, pn_pap, pn_sbo, pn_top
           from fsd010 f
          where f.aocta = pn_cta 
            and f.aooper = pn_ope
            and f.AOMOD <> 419
            and f.aomod in (select k.modulo from fst111 k where k.dscod = 50)
            and f.aostat <> 99;
      exception 
          when others then
        --when no_data_found then
          begin
           select f.pgcod, f.aomod, f.aosuc, f.aomda, f.aopap, f.aosbop, f.aotope
             into pn_emp, pn_mod, pn_suc, pn_mda, pn_pap, pn_sbo, pn_top
             from fsd010 f
            where f.aocta = pn_cta 
              and f.aooper = pn_ope
              and f.AOMOD <> 419
              and f.aomod in (select k.modulo from fst111 k where k.dscod = 50)
              and f.aostat = 99
              and f.aofe99 in (
                               select max(g.aofe99)
                               from fsd010 g
                              where g.aocta = pn_cta
                                and g.aooper = pn_ope
                                and g.AOMOD <> 419
                                and g.aomod in (select k.modulo from fst111 k where k.dscod = 50)
                                and g.aostat = 99
                              ); 
         exception when others then  
            begin
             select f.pgcod, f.aomod, f.aosuc, f.aomda, f.aopap, f.aosbop, f.aotope
               into pn_emp, pn_mod, pn_suc, pn_mda, pn_pap, pn_sbo, pn_top
               from fsd010 f
              where f.aocta = pn_cta 
                and f.aooper = pn_ope
                and f.AOMOD <> 419
                and f.aomod in (select k.modulo from fst111 k where k.dscod = 50)
                and f.aostat = 99
                and f.aosbop in (
                                 select max(g.aosbop)
                                 from fsd010 g
                                where g.aocta = pn_cta
                                  and g.aooper = pn_ope
                                  and g.AOMOD <> 419
                                  and g.aomod in (select k.modulo from fst111 k where k.dscod = 50)
                                  and g.aostat = 99
                                ); 

           exception when others then 
               pn_emp := 0;          
            end;
            
          end;
      end;

  
 END SP_CR_DATOSCRE;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_TABLAS_FONDOS;
/

