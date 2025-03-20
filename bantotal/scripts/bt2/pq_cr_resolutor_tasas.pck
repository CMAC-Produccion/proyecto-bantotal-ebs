create or replace package PQ_CR_RESOLUTOR_TASAS is
 
    -- *****************************************************************
    -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.01.03
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER SALDOS COMPARATIVOS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_fsr025( pn_pgcod in number,
                          pn_aomod in number,
                          pn_pizar in number,
                          pn_aomda in number,
                          pn_aopap in number,
                          pn_aopzo in number,
                          pn_aomto in number,
                          pn_aosuc in number,
                          pn_tatol out number,
                          pn_tatasa out number,
                          pn_tasa out number
                          );   
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_RESOLUTOR_TASAS;
/

create or replace package body PQ_CR_RESOLUTOR_TASAS is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_RESOLUTOR_TASAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.12.31
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS PARA REPORTE VARIACION DE SALDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.08.06
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: sp_cr_carga_datos, sp_cr_carga_datos_ini
   -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_fsr025( pn_pgcod in number,
                          pn_aomod in number,
                          pn_pizar in number,
                          pn_aomda in number,
                          pn_aopap in number,
                          pn_aopzo in number,
                          pn_aomto in number,
                          pn_aosuc in number,
                          pn_tatol out number,
                          pn_tatasa out number,
                          pn_tasa out number
                          ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_fsr025
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

  cursor regiones is
     select regcod 
       from fst811
      Where Pgcod = pn_pgcod
        and OfiCod = pn_aosuc
        and regcod >100;
       

ln_puntopor number := 100;   
ln_tvmporc number(7,4) :=0; 
ln_tasa number(11,6):=0;
ln_tamto number:=0;
ln_tafdes date;

ln_tvfmon fsd527.tvfmon%type;
ld_tvfdes fsd527.tvfdes%type;
  
 begin
 
    begin
        select min(tamto), max(tafdes)
          into ln_tamto, ln_tafdes   
          from FSR025
         where Pgcod = pn_Pgcod
           and Tamod = pn_Aomod 
           and Tpizar = pn_pizar
           and Tamda = pn_aomda
           and Tapap = pn_aopap
           and Tamto >= pn_aomto;
    exception when others then
      ln_tamto := 0;
      ln_tafdes := null;  
    end;    
 
   begin
   /* 
        select Tatol, Tatasa
         into pn_tatol, pn_tatasa
          from FSR025
         where Pgcod = pn_Pgcod
           and Tamod = pn_Aomod 
           and Tpizar = pn_pizar
           and Tamda = pn_aomda
           and Tapap = pn_aopap
           and Tamto >= pn_aomto
           and Tamto in (select min(tamto)
                  from FSR025
                 where Pgcod = pn_Pgcod
                   and Tamod = pn_Aomod 
                   and Tpizar = pn_pizar
                   and Tamda = pn_aomda
                   and Tapap = pn_aopap
                   and Tamto >= pn_aomto);*/
        select Tatol, Tatasa
          into pn_tatol, pn_tatasa
          from FSR025
         where Pgcod = pn_Pgcod
           and Tamod = pn_Aomod 
           and Tpizar = pn_pizar
           and Tamda = pn_aomda
           and Tapap = pn_aopap
           and Tamto = ln_tamto
           and Tafdes = ln_tafdes;
    exception when no_data_found then
      pn_Tatol := 0;      
      pn_TaTasa := 0;    
    end;

   
   if pn_tatasa > 0 then  
      
       for i in regiones loop
             
           begin
             select min(TVFMON), max(tvfdes)
               into ln_tvfmon, ld_tvfdes
               from FSD527 f
              Where Pgcod = pn_Pgcod
                and Tamod = pn_Aomod 
                and Tpizar = pn_pizar
                and Tapap = pn_Aopap
                and Tamda = pn_AoMda
                and TvSuc = i.RegCod
                and TVFMON >= pn_AoMto;
           exception when others then
               ln_tvfmon := null;
               ld_tvfdes := null;
           end;
       
          if ln_tvfmon is not null then
               begin
                /* select distinct TVMPORC
                   into ln_tvmporc
                   from FSD527
                  Where Pgcod = pn_Pgcod
                    and Tamod = pn_Aomod 
                    and Tpizar = pn_pizar
                    and Tapap = pn_Aopap
                    and Tamda = pn_AoMda
                    and TvSuc = i.RegCod
                    and TVFMON >= pn_AoMto
                    and tvfmon in 
                    (
                       select min(TVFMON)
                         from FSD527 f
                        Where Pgcod = pn_Pgcod
                          and Tamod = pn_Aomod 
                          and Tpizar = pn_pizar
                          and Tapap = pn_Aopap
                          and Tamda = pn_AoMda
                          and TvSuc = i.RegCod
                          and TVFMON >= pn_AoMto
                    );*/
                   select distinct TVMPORC
                     into ln_tvmporc
                     from FSD527
                    Where Pgcod = pn_Pgcod
                      and Tamod = pn_Aomod 
                      and Tpizar = pn_pizar
                      and Tapap = pn_Aopap
                      and Tamda = pn_AoMda
                      and TvSuc = i.RegCod
                      and tvfmon = ln_tvfmon 
                      and tvfdes = ld_tvfdes;
               exception when no_Data_found then
                    ln_tvmporc := 0;
               end;
               if ln_tvmporc > 0 then
                 exit;
               end if;
               
           end if;
           
        end loop;
      
       if ln_tvmporc = 0 then
          ln_puntopor := 0;
       end if;
       ln_puntopor := ln_tvmporc - ln_puntopor; --punto porcentual

       ln_tasa := pn_TaTasa + ln_puntopor; --sumar a la tasa

       ln_tasa := ln_tasa - round((ln_tasa * pn_Tatol/100),6); --tasa minima

       pn_tasa := ln_tasa;
        
   end if;
   
 end sp_cr_fsr025;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_RESOLUTOR_TASAS;
/

