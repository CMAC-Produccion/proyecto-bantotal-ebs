create or replace package PQ_CR_JAQL975_LogReporte is
    -- *****************************************************************
    -- Nombre                     : paquete para almacenar el log de reportes
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2015.11.10
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Realiza Calculos
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: se modifico fn_Cr_analista
    -- *****************************************************************

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
 procedure pr_cr_contador_ini(pn_numcor out number );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure fn_cr_inserta(pc_nomrep in varchar2,
                         pc_codusu in varchar2,
                         pd_fecpro in date,
                         pc_horini in varchar2,
                         pc_horfin in varchar2           
                        ) ;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure pr_cr_contador(pn_numcor out number );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

------------------------------------------         
end PQ_CR_JAQL975_LogReporte;
/

create or replace package body PQ_CR_JAQL975_LogReporte is
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
  procedure pr_cr_contador_ini(pn_numcor out number ) is
    
    -- *****************************************************************
    -- Nombre                     : pr_cr_contador
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2016.04.28
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Maximo Correlativo Reporte
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Par¿metros de Entrada      :
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 
    -- Autor de la Modificaci¿n   : 
    -- Descripci¿n de Modificaci¿n: 
    --
    -- *****************************************************************
    ln_numcor number;
    
  begin
  
   begin 
    select max(jaql975cor) 
      into ln_numcor
      from jaql975;
   end;
  
   pn_numcor := ln_numcor;                     
      
  end pr_cr_contador_ini;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure fn_cr_inserta(pc_nomrep in varchar2,
                         pc_codusu in varchar2,
                         pd_fecpro in date,
                         pc_horini in varchar2,
                         pc_horfin in varchar2           
                        ) is

    -- *****************************************************************
    -- Nombre                     : fn_cr_inserta
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2016.07.25
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Inserta en tabla JAQL975 
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Par¿metros de Entrada      :
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 
    -- Autor de la Modificaci¿n   : 
    -- Descripci¿n de Modificaci¿n: 
    --
    -- *****************************************************************

 ln_numcor number;
 pc_coderr varchar2(1000);
 pc_msgerr varchar2(1000);
 
 begin
 
    pq_cr_jaql975_logReporte.pr_cr_contador(ln_numcor);
    
    insert into jaql975(jaql975cor, jaql975nom, jaql975usr, jaql975fec, jaql975hin, jaql975hfi)    
    values(ln_numcor + 1, pc_nomrep, pc_codusu, pd_fecpro, pc_horini, pc_horfin );        
 
    commit;
 exception when others then
   pc_coderr := sqlcode;
   pc_msgerr := sqlerrm;      
 end fn_cr_inserta;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure pr_cr_contador(pn_numcor out number ) is
    
    -- *****************************************************************
    -- Nombre                     : pr_cr_contador
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2016.07.25
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Maximo Correlativo por Fecha para genrar Reporte 
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Par¿metros de Entrada      :
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 
    -- Autor de la Modificaci¿n   : 
    -- Descripci¿n de Modificaci¿n: 
    --
    -- *****************************************************************
    ln_numcor number;
    ld_fecha date;
  begin
  
    
    begin
        select pgfape into ld_fecha from fst017 where pgcod = 1;
    
    end;
    
    
     begin 
      select max(jaql975cor) 
        into ln_numcor
        from jaql975
       where jaql975fec = ld_fecha;
     exception when no_data_found then
       ln_numcor := 0;          
     end;
    
     if ln_numcor is null then
        ln_numcor := 0;
     end if;
     pn_numcor := ln_numcor;                     
      
  end pr_cr_contador;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
----------------------------------------------------------------------------------------
end PQ_CR_JAQL975_LogReporte;
/

