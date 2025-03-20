create or replace package pq_datos_solicitud is

  -- Author  : EBEGAZO
  -- Created : 18/12/2012 12:00:00 a.m.
  -- Purpose : 
  
  function fn_fecha_solicitud (p_pgcod  in fsd010.pgcod%type,
                               p_aomod  in fsd010.aomod%type,
                               p_aosuc  in fsd010.aosuc%type,
                               p_aomda  in fsd010.aomda%type,
                               p_aopap  in fsd010.aopap%type,
                               p_aocta  in fsd010.aocta%type,
                               p_aooper in fsd010.aooper%type,
                               p_aosbop in fsd010.aosbop%type,
                               p_aotope in fsd010.aotope%type,
                               p_estado in number
                              ) return date;
                              
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_tipo_solicitud (p_pgcod  in fsd010.pgcod%type,
                               p_aomod  in fsd010.aomod%type,
                               p_aosuc  in fsd010.aosuc%type,
                               p_aomda  in fsd010.aomda%type,
                               p_aopap  in fsd010.aopap%type,
                               p_aocta  in fsd010.aocta%type,
                               p_aooper in fsd010.aooper%type,
                               p_aosbop in fsd010.aosbop%type,
                               p_aotope in fsd010.aotope%type
                              ) return number;
                              
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_instancia (p_pgcod  in fsd010.pgcod%type,
                         p_aomod  in fsd010.aomod%type,
                         p_aosuc  in fsd010.aosuc%type,
                         p_aomda  in fsd010.aomda%type,
                         p_aopap  in fsd010.aopap%type,
                         p_aocta  in fsd010.aocta%type,
                         p_aooper in fsd010.aooper%type,
                         p_aosbop in fsd010.aosbop%type,
                         p_aotope in fsd010.aotope%type
                        ) return number;
                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_tip_solxinstancia (ln_xwfprcins  in xwf700.xwfprcins%type
                                ) return number; 
                                
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_promotor_credito(ln_xwfprcins  in xwf700.xwfprcins%type
                               ) return varchar2;
                               
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipo_credito(ln_xwfprcins  in xwf700.xwfprcins%type
                        ) return number;
                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecha_solicitudxinst (ln_instancia  in xwf700.xwfprcins%type,
                                    p_estado in number
                                   ) return date;
                                   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_esttarea_solicitudxinst (ln_instancia  in xwf700.xwfprcins%type,
                                      p_estado in number            
                                     ) return char;                                   
                                   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecha_solicitudxinst_min (ln_instancia  in xwf700.xwfprcins%type,
                                        p_estado in number            
                                       ) return date;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fechor_solicitudxinst_min (ln_instancia  in xwf700.xwfprcins%type,
                                        p_estado in number            
                                       ) return date;                                       
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_tipo_solicitudxinst (ln_instancia  in xwf700.xwfprcins%type
                              ) return number;                                                                                          
                               
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipo_sbsxinst(ln_xwfprcins  in xwf700.xwfprcins%type
                        ) return varchar;
                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_sectorxinst(ln_instancia  in xwf700.xwfprcins%type
                        ) return varchar;    

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipcreCMAC_xinst(ln_xwfprcins  in xwf700.xwfprcins%type
                            ) return varchar;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_calclixinst(ln_instancia  in xwf700.xwfprcins%type
                        ) return varchar; 
                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_calcli_solicitud(ln_instancia  in xwf700.xwfprcins%type,
                             ld_fecsol in date,
                             lc_pepais fsr008.pepais%type,
                             lc_petdoc fsr008.petdoc%type,            
                             lc_pendoc fsr008.pendoc%type                             
                            ) return varchar;                        
                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_segmento_linea(
                            p_aomod  in fsd010.aomod%type,
                            p_aocta  in fsd010.aocta%type
                          ) return varchar;                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_usu_captacion_credito(ln_xwfprcins  in xwf700.xwfprcins%type
                               ) return varchar2; 
                               
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipo_credito_desem(lc_pepais fsr008.pepais%type,
                               lc_petdoc fsr008.petdoc%type,            
                               lc_pendoc fsr008.pendoc%type,           
                               ld_fecref date              
                               )return number;
                               
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_excepciones(ln_xwfprcins  in xwf700.xwfprcins%type
                        ) return varchar2;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipevaluacion(ln_xwfprcins  in xwf700.xwfprcins%type
                          ) return number;                                                                                                                                                                                        

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_ingresos(ln_xwfprcins  in xwf700.xwfprcins%type
                    ) return number ;
                    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_indever(ln_xwfprcins  in xwf700.xwfprcins%type
                     ) return number ;   
                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipo_sol_xwfcar3xinst (ln_instancia  in xwf700.xwfprcins%type
                                    ) return char;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ori_captacion_credito(ln_xwfprcins  in xwf700.xwfprcins%type
                               ) return varchar2;                                    
                                                                                                                                                                                                                            
end pq_datos_solicitud;
/

create or replace package body pq_datos_solicitud is


  function fn_fecha_solicitud (p_pgcod  in fsd010.pgcod%type,
                               p_aomod  in fsd010.aomod%type,
                               p_aosuc  in fsd010.aosuc%type,
                               p_aomda  in fsd010.aomda%type,
                               p_aopap  in fsd010.aopap%type,
                               p_aocta  in fsd010.aocta%type,
                               p_aooper in fsd010.aooper%type,
                               p_aosbop in fsd010.aosbop%type,
                               p_aotope in fsd010.aotope%type,
                               p_estado in number
                              ) return date
  is
/*
  3    solicitud
  7    evaluacion
  11   aprobacion
  55   desembolso
*/  
  
  ld_fecsol date;        
  ln_instancia    xwf700.xwfprcins%type;                 
  begin
    
      --entontrar instancia
       select
            max(xw2.xwfprcins) xwfprcins
            into ln_instancia
       from xwf700 xw2
       where
               xw2.xwfempresa          =  p_pgcod
           and xw2.xwfsucursal         =  p_aosuc
           and xw2.xwfmoneda           =  p_aomda
           and xw2.xwfpapel            =  p_aopap
           and xw2.xwfcuenta           =  p_aocta
           and xw2.xwfoperacion        =  p_aooper
           and xw2.xwfsubope           =  p_aosbop
           and (xw2.xwfmodulo          =  p_aomod 
                or xw2.xwfmodulo       =  (case p_aomod when 116 then 117 else p_aomod end)                 
               )
           and xw2.xwftipope           =  p_aotope
           and xw2.xwfcar3             = '1';
           
        if ln_instancia is null then    
           select /*+use_nl(XW2) parallel(rel,2,1)*/ 
                max(xw2.xwfprcins) xwfprcins
                into ln_instancia
           from xwf700 xw2,
                Fsr011 rel
           where
                   xw2.xwfempresa   =  rel.r2cod           
               and xw2.xwfsucursal  =  rel.r2suc
               and xw2.xwfmoneda    =  rel.r2mda
               and xw2.xwfpapel     =  rel.r2pap
               and xw2.xwfcuenta    =  rel.r2cta
               and xw2.xwfoperacion =  rel.r2oper
               and xw2.xwfsubope    =  rel.r2sbop
               and (xw2.xwfmodulo    =  p_aomod 
                    or xw2.xwfmodulo    =  (case p_aomod when 116 then 117 else p_aomod end)                 
                   )
               and xw2.xwftipope    =  rel.r2tope
               and xw2.xwfcar3      = '1'
               and rel.r1cod        = p_pgcod               
               and rel.r1mod        = p_aomod
               and rel.r1suc        = p_aosuc
               and rel.r1mda        = p_aomda
               and rel.r1pap        = p_aopap
               and rel.r1cta        = p_aocta
               and rel.r1oper       = p_aooper
               and rel.r1sbop       = p_aosbop
               and rel.r1tope       = p_aotope;
         end if; 

     begin    
        SELECT 
               case when trunc(u.wfitemend)= to_date('0001.01.01','rrrr.mm.dd') 
                    then trunc(u.WFITEMINIT)
                    else trunc(u.wfitemend)
               end       
               into ld_fecsol
        FROM 
               wfwrkitems u 
        where  
               u.wftaskcod = p_estado    
           and u.wfitemid = (select max(s.wfitemid) from wfwrkitems s where s.wfinsprcid=u.wfinsprcid and s.wftaskcod = p_estado)
           and u.wfinsprcid=ln_instancia;
     exception when others then                                     
               ld_fecsol:= null;
     end;       

     return ld_fecsol;   
      
  end fn_fecha_solicitud;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_tipo_solicitud (p_pgcod  in fsd010.pgcod%type,
                               p_aomod  in fsd010.aomod%type,
                               p_aosuc  in fsd010.aosuc%type,
                               p_aomda  in fsd010.aomda%type,
                               p_aopap  in fsd010.aopap%type,
                               p_aocta  in fsd010.aocta%type,
                               p_aooper in fsd010.aooper%type,
                               p_aosbop in fsd010.aosbop%type,
                               p_aotope in fsd010.aotope%type
                              ) return number
  is
/*
0 Normal
1 Cartas Fianzas
3 Refinanciación
4 Ampliación de Crédito
7 Cupo de Desembolsos
10 Convenios
11 Línea de Crédito
12 Ampliación de LíneasFinal del formulario
Principio del formulario
13Final del formulario Reprog. x Cambio de
14 Reprog. x Desastre N
*/  
  
  sng001ori       sng001.sng001ori%type;        
  ln_instancia    xwf700.xwfprcins%type;                 
  begin
    
      --entontrar instancia
       select
            max(xw2.xwfprcins) xwfprcins
            into ln_instancia
       from xwf700 xw2
       where
               xw2.xwfempresa          =  p_pgcod
           and xw2.xwfsucursal         =  p_aosuc
           and xw2.xwfmoneda           =  p_aomda
           and xw2.xwfpapel            =  p_aopap
           and xw2.xwfcuenta           =  p_aocta
           and xw2.xwfoperacion        =  p_aooper
           and xw2.xwfsubope           =  p_aosbop
           and (xw2.xwfmodulo          =  p_aomod 
                or xw2.xwfmodulo       =  (case p_aomod when 116 then 117 else p_aomod end)                 
               )
           and xw2.xwftipope           =  p_aotope
           and xw2.xwfcar3             = '1';
           
        if ln_instancia is null then    
           select /*+use_nl(XW2) parallel(rel,2,1)*/ 
                max(xw2.xwfprcins) xwfprcins
                into ln_instancia
           from xwf700 xw2,
                Fsr011 rel
           where
                   xw2.xwfempresa   =  rel.r2cod           
               and xw2.xwfsucursal  =  rel.r2suc
               and xw2.xwfmoneda    =  rel.r2mda
               and xw2.xwfpapel     =  rel.r2pap
               and xw2.xwfcuenta    =  rel.r2cta
               and xw2.xwfoperacion =  rel.r2oper
               and xw2.xwfsubope    =  rel.r2sbop
               and (xw2.xwfmodulo    =  p_aomod 
                    or xw2.xwfmodulo    =  (case p_aomod when 116 then 117 else p_aomod end)                 
                   )
               and xw2.xwftipope    =  rel.r2tope
               and xw2.xwfcar3      = '1'
               and rel.r1cod        = p_pgcod               
               and rel.r1mod        = p_aomod
               and rel.r1suc        = p_aosuc
               and rel.r1mda        = p_aomda
               and rel.r1pap        = p_aopap
               and rel.r1cta        = p_aocta
               and rel.r1oper       = p_aooper
               and rel.r1sbop       = p_aosbop
               and rel.r1tope       = p_aotope;
         end if; 

     begin    

        select sng001ori
          into sng001ori
         from  sng001
        where  sng001inst =  ln_instancia;

     exception when others then                                     
               sng001ori:= null;
     end;       

     return sng001ori;   
      
  end fn_tipo_solicitud;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_instancia (p_pgcod  in fsd010.pgcod%type,
                         p_aomod  in fsd010.aomod%type,
                         p_aosuc  in fsd010.aosuc%type,
                         p_aomda  in fsd010.aomda%type,
                         p_aopap  in fsd010.aopap%type,
                         p_aocta  in fsd010.aocta%type,
                         p_aooper in fsd010.aooper%type,
                         p_aosbop in fsd010.aosbop%type,
                         p_aotope in fsd010.aotope%type
                        ) return number
  is
  
  ln_instancia    xwf700.xwfprcins%type;                 
  begin
    
      --entontrar instancia
       select
            max(xw2.xwfprcins) xwfprcins
            into ln_instancia
       from xwf700 xw2
       where
               xw2.xwfempresa          =  p_pgcod
           and xw2.xwfsucursal         =  p_aosuc
           and xw2.xwfmoneda           =  p_aomda
           and xw2.xwfpapel            =  p_aopap
           and xw2.xwfcuenta           =  p_aocta
           and xw2.xwfoperacion        =  p_aooper
           and xw2.xwfsubope           =  p_aosbop
           and (xw2.xwfmodulo          =  p_aomod 
                or xw2.xwfmodulo       =  (case p_aomod when 116 then 117 else p_aomod end)                 
               )
           and xw2.xwftipope           =  p_aotope
           and xw2.xwfcar3             = '1';
           
        if ln_instancia is null then    
           select /*+use_nl(XW2) parallel(rel,2,1)*/ 
                max(xw2.xwfprcins) xwfprcins
                into ln_instancia
           from xwf700 xw2,
                Fsr011 rel
           where
                   xw2.xwfempresa   =  rel.r2cod           
               and xw2.xwfsucursal  =  rel.r2suc
               and xw2.xwfmoneda    =  rel.r2mda
               and xw2.xwfpapel     =  rel.r2pap
               and xw2.xwfcuenta    =  rel.r2cta
               and xw2.xwfoperacion =  rel.r2oper
               and xw2.xwfsubope    =  rel.r2sbop
               and (xw2.xwfmodulo    =  p_aomod 
                    or xw2.xwfmodulo    =  (case p_aomod when 116 then 117 else p_aomod end)                 
                   )
               and xw2.xwftipope    =  rel.r2tope
               and xw2.xwfcar3      = '1'
               and rel.r1cod        = p_pgcod               
               and rel.r1mod        = p_aomod
               and rel.r1suc        = p_aosuc
               and rel.r1mda        = p_aomda
               and rel.r1pap        = p_aopap
               and rel.r1cta        = p_aocta
               and rel.r1oper       = p_aooper
               and rel.r1sbop       = p_aosbop
               and rel.r1tope       = p_aotope;
         end if; 


     return ln_instancia;   
      
  end fn_instancia;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_tip_solxinstancia (ln_xwfprcins  in xwf700.xwfprcins%type
                                ) return number
  is
/*
0 Normal
1 Cartas Fianzas
3 Refinanciación
4 Ampliación de Crédito
7 Cupo de Desembolsos
10 Convenios
11 Línea de Crédito
12 Ampliación de LíneasFinal del formulario
Principio del formulario
13Final del formulario Reprog. x Cambio de
14 Reprog. x Desastre N
*/  
  
  sng001ori       sng001.sng001ori%type;        
               
  begin
    
     begin    

        select sng001ori
          into sng001ori
         from  sng001
        where  sng001inst =  ln_xwfprcins;

     exception when others then                                     
               sng001ori:= null;
     end;       

     return sng001ori;   
      
  end fn_tip_solxinstancia;
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_promotor_credito(ln_xwfprcins  in xwf700.xwfprcins%type
                               ) return varchar2 is

    lc_promotor varchar2(50);
    ln_sng015cod number(4);
    ln_SNG055CAR number(3);

  begin

      begin
        select sng001usc, sng015cod
          into lc_promotor, ln_sng015cod
         from  sng001
        where  sng001inst =  ln_xwfprcins;
           --and sng015cod  =  1;
        exception
          when no_data_found then
               lc_promotor := null;
               ln_sng015cod :=null ;
      end;
      
      if NVL(ln_sng015cod,0) = 0 then 

        begin
            SELECT SNG055CAR 
              into ln_SNG055CAR
              FROM sng057 
             where sng057usr = lc_promotor;                             
          exception
            when no_data_found then
              lc_promotor := null;
        end;      
        
        if NVL(ln_SNG055CAR,0)<>101 then
           lc_promotor := null;             
        end if; 
        
      end if; 
      
  return lc_promotor;
  
end fn_promotor_credito;  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipo_credito(ln_xwfprcins  in xwf700.xwfprcins%type
                        ) return number is

    ln_tipcre number;

----retorna
--1 'CREDITO NUEVO'    
--2 'CREDITO RECURRENTE'  

  begin


      begin
        select SNG001TPCR
          into ln_tipcre
         from  sng001
        where  sng001inst =  ln_xwfprcins;
        exception
          when no_data_found then
               ln_tipcre := null;
      end;

  return ln_tipcre;
end fn_tipo_credito;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecha_solicitudxinst (ln_instancia  in xwf700.xwfprcins%type,
                                    p_estado in number            
                                   ) return date
  is
--Retorna la fecha de creacion de una estado  
/*
  3    solicitud
  7    evaluacion
  11   aprobacion
  55   desembolso
*/  

  ld_fecsol date;        
              
  begin
    
     begin    
          SELECT 
                 case when trunc(u.WFITEMINIT)= to_date('0001.01.01','rrrr.mm.dd') 
                      then trunc(u.wfitemend)
                      else trunc(u.WFITEMINIT)
                 end       
                 into ld_fecsol
          FROM 
                 wfwrkitems u 
          where  
                 u.wftaskcod = p_estado    
             and u.wfitemid = (select max(s.wfitemid) from wfwrkitems s where s.wfinsprcid=u.wfinsprcid and s.wftaskcod = p_estado)
             and u.wfinsprcid=ln_instancia;
     exception when others then                                     
               ld_fecsol:= null;
     end;       

     return ld_fecsol;   
      
  end fn_fecha_solicitudxinst;
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_esttarea_solicitudxinst (ln_instancia  in xwf700.xwfprcins%type,
                                      p_estado in number            
                                     ) return char
  is
--Retorna la fecha de creacion de una estado  
/*
  3    solicitud
  7    evaluacion
  11   aprobacion
  55   desembolso
*/  

  lc_esttar char(1);        
              
  begin
    
     begin    
          SELECT 
                 u.wfstscod       
                 into lc_esttar
          FROM 
                 wfwrkitems u 
          where  
                 u.wftaskcod = p_estado    
             and u.wfitemid = (select max(s.wfitemid) from wfwrkitems s where s.wfinsprcid=u.wfinsprcid and s.wftaskcod = p_estado)
             and u.wfinsprcid=ln_instancia;
     exception when others then                                     
               lc_esttar:= null;
     end;       

     return lc_esttar;   
      
  end fn_esttarea_solicitudxinst;  
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecha_solicitudxinst_min (ln_instancia  in xwf700.xwfprcins%type,
                                        p_estado in number            
                                       ) return date
  is
--Retorna la fecha de creacion de una estado  
/*
  3    solicitud
  7    evaluacion
  11   aprobacion
  55   desembolso
*/  

  ld_fecsol date;        
              
  begin
    
     begin    
          SELECT 
                 case when trunc(u.WFITEMINIT)= to_date('0001.01.01','rrrr.mm.dd') 
                      then trunc(u.wfitemend)
                      else trunc(u.WFITEMINIT)
                 end       
                 into ld_fecsol
          FROM 
                 wfwrkitems u 
          where  
                 u.wftaskcod = p_estado    
             and u.wfitemid = (select min(s.wfitemid) from wfwrkitems s where s.wfinsprcid=u.wfinsprcid and s.wftaskcod = p_estado)
             and u.wfinsprcid=ln_instancia;
     exception when others then                                     
               ld_fecsol:= null;
     end;       

     return ld_fecsol;   
      
  end fn_fecha_solicitudxinst_min;  
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fechor_solicitudxinst_min (ln_instancia  in xwf700.xwfprcins%type,
                                        p_estado in number            
                                       ) return date
  is
--Retorna la fecha de creacion de una estado  
/*
  3    solicitud
  7    evaluacion
  11   aprobacion
  55   desembolso
*/  

  ld_fecsol date;        
              
  begin
    
     begin    
          SELECT 
                 case when trunc(u.WFITEMINIT)= to_date('0001.01.01','rrrr.mm.dd') 
                      then u.wfitemend
                      else u.WFITEMINIT
                 end       
                 into ld_fecsol
          FROM 
                 wfwrkitems u 
          where  
                 u.wftaskcod = p_estado    
             and u.wfitemid = (select min(s.wfitemid) from wfwrkitems s where s.wfinsprcid=u.wfinsprcid and s.wftaskcod = p_estado)
             and u.wfinsprcid=ln_instancia;
     exception when others then                                     
               ld_fecsol:= null;
     end;       

     return ld_fecsol;   
      
  end fn_fechor_solicitudxinst_min;  
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_tipo_solicitudxinst (ln_instancia  in xwf700.xwfprcins%type
                              ) return number
  is
/*
0 Normal
1 Cartas Fianzas
3 Refinanciación
4 Ampliación de Crédito
7 Cupo de Desembolsos
10 Convenios
11 Línea de Crédito
12 Ampliación de LíneasFinal del formulario
Principio del formulario
13Final del formulario Reprog. x Cambio de
14 Reprog. x Desastre N
15 Ampliacion Especial
*/  
  
  sng001ori       sng001.sng001ori%type;        
            
  begin
    
     begin    

        select sng001ori
          into sng001ori
         from  sng001
        where  sng001inst =  ln_instancia;

     exception when others then                                     
               sng001ori:= null;
     end;       

     return sng001ori;   
      
  end fn_tipo_solicitudxinst;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipo_sbsxinst(ln_xwfprcins  in xwf700.xwfprcins%type
                        ) return varchar is

    lc_tipcre varchar2(100);

  begin


        begin

         select
                upper(trim(substr(wv.WFAttSVal, instr(wv.WFAttSVal,';')+1,length(wv.WFAttSVal))))
               into lc_tipcre
         from wfattsvalues wv
         where
              WFAttSId   = 'TIPO_CREDITO'
          and WFINSPRCID = ln_xwfprcins;
        exception
        when others then
             lc_tipcre := null;
        end;

  return lc_tipcre;
end fn_tipo_sbsxinst;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_sectorxinst(ln_instancia  in xwf700.xwfprcins%type
                        ) return varchar is

    lc_sector varchar2(100);--wfattsvalues.WFATTSVAL%type;

  begin


        begin

         select
                upper(trim(substr(wv.WFAttSVal, instr(wv.WFAttSVal,';')+1,length(wv.WFAttSVal))))
               into lc_sector
         from wfattsvalues wv
         where
              WFAttSId   = 'SECTOR'
          and WFINSPRCID = ln_instancia;
        exception
        when others then
             lc_sector := null;
        end;

  return lc_sector;
end fn_sectorxinst;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipcreCMAC_xinst(ln_xwfprcins  in xwf700.xwfprcins%type
                            ) return varchar is

    lc_tipcre varchar2(100);
    lc_sector varchar2(100);

    lc_tipcretot varchar2(100);
    
  begin


        begin

         select
                max(case when WFAttSId= 'TIPO_CREDITO' then upper(trim(substr(wv.WFAttSVal, instr(wv.WFAttSVal,';')+1,length(wv.WFAttSVal)))) end),
                max(case when WFAttSId= 'SECTOR' then upper(trim(substr(wv.WFAttSVal, instr(wv.WFAttSVal,';')+1,length(wv.WFAttSVal))))end)
               into lc_tipcre,lc_sector
         from wfattsvalues wv
         where
              WFAttSId   in ('TIPO_CREDITO','SECTOR')
          and WFINSPRCID = ln_xwfprcins;
        exception
        when others then
             lc_tipcre := null;
        end;
        
        if lc_tipcre like 'PEQ%' then 
          lc_tipcretot:= lc_tipcre ||' ' ||lc_sector;
        else 
          lc_tipcretot:= lc_tipcre;
        end if;  

  return lc_tipcretot;
  
end fn_tipcreCMAC_xinst;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_calclixinst(ln_instancia  in xwf700.xwfprcins%type
                        ) return varchar is

  lc_pae71val fpae71.pae71val%type;

  begin


      begin
        select pae71val
          into lc_pae71val
        from 
        (  
          select c.pae71val
          from
               wfattsvalues z,
               fpae70 b,
               fpae71 c
          where
                b.pae70wri = z.wfattsval
            and c.pae70nro = b.pae70nro
            and z.wfattsid = 'WRKITEMSOL'
            and c.pae71ite = 265
            and c.pae51eva=1
            and z.wfinsprcid = ln_instancia
          order by  b.pae70nro 
         )
         where rownum = 1   
         ;
        exception
          when no_data_found then
               lc_pae71val := null;
      end;

  return lc_pae71val;

end fn_calclixinst;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_calcli_solicitud(ln_instancia  in xwf700.xwfprcins%type,
                             ld_fecsol in date,
                             lc_pepais fsr008.pepais%type,
                             lc_petdoc fsr008.petdoc%type,            
                             lc_pendoc fsr008.pendoc%type                             
                            ) return varchar is

  lc_pae71val fpae71.pae71val%type;
  --lc_JAQY067NCAL jaqy067.JAQY067NCAL%type;

  begin


      begin
        select pae71val
          into lc_pae71val
        from 
        (  
          select c.pae71val
          from
               wfattsvalues z,
               fpae70 b,
               fpae71 c
          where
                b.pae70wri = z.wfattsval
            and c.pae70nro = b.pae70nro
            and z.wfattsid = 'WRKITEMSOL'
            and c.pae71ite = 265
            and c.pae51eva=1
            and z.wfinsprcid = ln_instancia
          order by  b.pae70nro 
         )
         where rownum = 1   
         ;
        exception
          when no_data_found then
               lc_pae71val := null;
      end;
      
      if lc_pae71val is null or lc_pae71val = 'NO PRECALIFICA' then
          begin
             select 
                   case 
                             when y67.jaqy067ncal = 'CONS RECURRENTE 12 MESES' then 'CONS NVO 12 MESES'
                             when y67.jaqy067ncal = 'CONS RECURRENTE 6 MESES' then 'CONSUMO RECUR 6M'  
                             when y67.jaqy067ncal = 'PREFERENCIAL A' then 'PREFERENCIAL A'
                             when y67.jaqy067ncal = 'PREFERENCIAL B' then 'PREFERENCIAL B'                                                                                       
                             when y67.jaqy067ncal = 'PREFERENCIAL C' then 'PREFERENCIAL C'
                             when y67.jaqy067ncal = 'PREFERENCIAL PREMIUM A' then 'PRFERENCIAL A PREM'
                             when y67.jaqy067ncal = 'PREFERENCIAL PREMIUM B' then 'PRFERENCIAL B PREM'
                             when y67.jaqy067ncal = 'PREFERENTE NUEVO A' then 'PRFERENTE NVO A'
                             when y67.jaqy067ncal = 'PREFERENTE NUEVO AA' then 'PRFERENTE NVO AA'
                             when y67.jaqy067ncal = 'PREFERENTE NUEVO B' then 'PRFERENTE NVO B'                                                                                                                                                                              
                             when y67.jaqy067ncal = 'PREFERENTE NUEVO C' then 'PRFERENTE NVO C'
                             when y67.jaqy067ncal = 'PREFERENTE NVO RECURRENTE A' then 'PRFERNTE NVOREC A'
                             when y67.jaqy067ncal = 'PREFERENTE NVO RECURRENTE AA' then 'PRFERNTE NVOREC AA'
                             when y67.jaqy067ncal = 'PREFERENTE NVO RECURRENTE B' then 'PRFERNTE NVOREC B'
                             when y67.jaqy067ncal = 'PREFERENTE NVO RECURRENTE C' then 'PRFERNTE NVOREC C'
                             when y67.jaqy067ncal = 'RECURRENTE 18 MESES' then 'RECURRENTE 18M'                                                                                                                    
                             when y67.jaqy067ncal = 'RECURRENTE 24 MESES' then 'RECURRENTE 24M'
                             when y67.jaqy067ncal = 'RECURRENTE 6 MESES' then 'RECURRENTE 6 M'                                                          
                             else y67.jaqy067ncal  
                   end
                   into lc_pae71val
             from  jaqy066 y66
                   inner join jaqy067 y67
                   on y67.jaqy067ccal = y66.jaqy066calf
             where y66.jaqy066pano = EXTRACT(YEAR FROM ADD_MONTHS(ld_fecsol,-1))
               and y66.jaqy066pmes = EXTRACT(MONTH FROM ADD_MONTHS(ld_fecsol,-1)) 
               and y66.jaqy066paic = lc_pepais
               and y66.jaqy066tdoc = lc_petdoc
               and y66.jaqy066tndoc= lc_pendoc;         
            exception
              when no_data_found then
                   lc_pae71val := null;
          end;  
                   
      end if;

  return lc_pae71val;

end fn_calcli_solicitud;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_segmento_linea(
                            p_aomod  in fsd010.aomod%type,
                            p_aocta  in fsd010.aocta%type
                          ) return varchar is

--retorna el segmento de la linea al momento de la solicitud, (se muestra en detalle en BANTOTAL)
  lc_segmento X054021.XlloTexto%type;

  begin

      begin
        select XlloTexto
          into lc_segmento
        from 
        (  
          SELECT XlloTexto 
          FROM X054021 
          WHERE (PgCod = 1 and XlloAomod = p_aomod) 
          AND (XlloAocta = p_aocta) AND (XlloTxtCod = 120) 
          AND (XlloTxtLin = 25) 
          ORDER BY PgCod, XlloAomod, XlloAosuc, XlloAomda, XlloAopap, XlloAocta, XlloAooper, XlloAosbop, XlloAotope, XlloUSts, XlloTxtCod, XlloTxtLin
         )
         where rownum = 1   
         ;
        exception
          when no_data_found then
               lc_segmento := null;
      end;

  return lc_segmento;

end fn_segmento_linea;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_usu_captacion_credito(ln_xwfprcins  in xwf700.xwfprcins%type
                               ) return varchar2 is

    lc_promotor varchar2(50);

  begin


      begin
        select sng001usc
          into lc_promotor
         from  sng001
        where  sng001inst =  ln_xwfprcins/*
           and sng015cod  =  1*/;
        exception
          when no_data_found then
               lc_promotor := null;
      end;

  return lc_promotor;
end fn_usu_captacion_credito; 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ori_captacion_credito(ln_xwfprcins  in xwf700.xwfprcins%type
                               ) return varchar2 is

    lc_origen varchar2(50);

  begin


      begin
        select s015.sng015dsc
          into lc_origen
         from  sng001 s001
               inner join SNG015 s015
               on s015.sng015cod = s001.sng015cod
        where  sng001inst =  ln_xwfprcins/*
           and sng015cod  =  1*/;
        exception
          when no_data_found then
               lc_origen := null;
      end;

  return lc_origen;
end fn_ori_captacion_credito; 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipo_credito_desem(lc_pepais fsr008.pepais%type,
                               lc_petdoc fsr008.petdoc%type,            
                               lc_pendoc fsr008.pendoc%type,           
                               ld_fecref date              
                               )return number is

    ln_tipcre number;

----retorna
--1 'CREDITO NUEVO'    
--2 'CREDITO RECURRENTE'  

  begin

      begin
        
        select (case 
                    when count(*)=0 then 1
                    else 2
               end)        
          into ln_tipcre        
          from fsd010 des
               inner join fsr008 pers
                      on pers.pgcod = des.pgcod
                     and pers.ctnro = des.aocta
                     and pers.ttcod = 1
                     and pers.CTTFIR = 'T'
         where 
               des.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29,120) union all select 117 from dual)
           and des.aomod not in (/*33,*/141)
           and des.aomod <> 120 --prestamos pasivos        
           and pers.pepais = lc_pepais
           and pers.petdoc = lc_petdoc
           and pers.pendoc = lc_pendoc
           and des.aofval < ld_fecref;
        
        exception
          when no_data_found then
               ln_tipcre := null;
      end;

  return ln_tipcre;
  
end fn_tipo_credito_desem;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_excepciones(ln_xwfprcins  in xwf700.xwfprcins%type
                        ) return varchar2  
  --retorna todas las excepciones con las que fue aprobada solicitud                        
  is
    cursor c_exc 
        is 
          SELECT distinct d.pae90msg 
          FROM sng091 a 
               inner join fpae90 d
               on d.pae90pol = a.sng091num
          WHERE
               a.sng091tpo = 'P'
           and a.sng001inst =  ln_xwfprcins  
          order by  a.sng001inst;         
        
    lv_detent varchar2(2000); 
  begin
       For x in c_exc Loop
           lv_detent := lv_detent||trim(x.pae90msg)||',';
       End Loop;   
       
       lv_detent := substr(lv_detent,1,length(lv_detent)-1);
       Return lv_detent; 
  end fn_excepciones;  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_tipevaluacion(ln_xwfprcins  in xwf700.xwfprcins%type
                          ) return number  
  --retorna el tipo de solicitud
  --13--independiente
  --14--dependiente    
  is
    ln_sng021tmod sng021.sng021tmod%type;
  begin
    
      begin
         SELECT  
                a.sng021tmod   
                into ln_sng021tmod
         FROM   sng021 a
                inner join   
                 (
                   SELECT sng021sol,max(sng021eval) sng021eval
                   FROM sng021
                   WHERE sng021sol = ln_xwfprcins
                   GROUP BY sng021sol 
                 )b
                 on b.sng021sol = a.sng021sol
                 and b.sng021eval = a.sng021eval;
        exception
          when no_data_found then
               ln_sng021tmod := null;
      end;  
         
      Return ln_sng021tmod; 
       
  end fn_tipevaluacion;  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_ingresos(ln_xwfprcins  in xwf700.xwfprcins%type
                    ) return number  

  --retorna el numero de evaluacion de la solicitud
  
  is
    ln_ingreso number(18,3);
  begin
    
      begin
         SELECT /*+parallel(a,2)*/ 
                sum(  
                case 
                  when sng026cod in (575,521)then NVL(tc.sng120tcbi,2.795)*sng023mto
                  else sng023mto
                end     
                )
                into ln_ingreso
         FROM   sng021 a
                inner join   
                 (
                   SELECT sng021sol,max(sng021eval) sng021eval
                   FROM sng021
                   WHERE sng021sol = ln_xwfprcins
                   GROUP BY sng021sol 
                 )b
                 on b.sng021sol = a.sng021sol
                 and b.sng021eval = a.sng021eval
                 inner join sng023 i
                 on i.sng021eval = a.sng021eval
                 left join sng120 tc
                 on tc.sng120ins = ln_xwfprcins
                 and tc.sng120tsk='EVALUACION'
         WHERE
                 sng026cod  in (75,575,21,521)        
                 ;
        exception
          when no_data_found then
               ln_ingreso := null;
      end;  
         
      Return ln_ingreso; 
       
  end fn_ingresos;
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_indever(ln_xwfprcins  in xwf700.xwfprcins%type
                     ) return number  

  --retorna el valor del campo sng001ever, 
  ---1 BANCO DE LA NACION
  
  is
    ln_ever sng001.sng001ever%type;
  begin
    
      begin
         SELECT  
                sng001ever
                into ln_ever
         FROM   sng001 a
         WHERE
                 sng001inst= ln_xwfprcins;
        exception
          when no_data_found then
               ln_ever := null;
      end;  
         
      Return ln_ever; 
       
  end fn_indever;    
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_tipo_sol_xwfcar3xinst (ln_instancia  in xwf700.xwfprcins%type
                                    ) return char
  is
  
  
  lc_xwfcar3       xwf700.xwfcar3%type;        
            
  begin
    
     begin    

        select xwfcar3
          into lc_xwfcar3
         from  xwf700
        where xwfcar3 in ('G','S','R')
          and xwfprcins=ln_instancia;

     exception when others then                                     
               lc_xwfcar3:= null;
     end;       

     return lc_xwfcar3;   
      
  end fn_tipo_sol_xwfcar3xinst;    

end pq_datos_solicitud;
/

