create or replace package PQ_CR_JAQY821_CAMBIO_TASA is
 
    -- *****************************************************************
    -- Nombre                     : CAMBIO DE TASA CAMPAÑAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.12.31
    -- Autor de Creación          : RLIVISI
    -- Uso                        : OBTENER USUARIOS QUE REALIZARON CAMBIO DE TASA CAMPAÑAS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2016.02.08 
    -- Autor de la Modificación   : RLIVISI 
    -- Descripción de Modificación: Adicion de campo Cargo Usuario que cambia tasa 
    
    -- Fecha de Modificación      : 2016.07.08 
    -- Autor de la Modificación   : RLIVISI 
    -- Descripción de Modificación: Adicion de campo Fecha de último Pago que cambia tasa 
    
    
    -- *****************************************************************

 procedure sp_cr_inserta_datos( pd_fecini in date, 
                                pd_fecfin in date,
                                pc_codusu in varchar2,
                                pn_tiptas in number,
                                pc_usuario in varchar2
                                );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_nomestado( pn_estado in number) return varchar2;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_codestado(pn_pgcod in number,          
          pn_aomod in number,
          pn_aomda in number,
          pn_aopap in number,
          pn_aocta in number,
          pn_aosuc in number,
          pn_aooper in number,
          pn_aosbop in number,
          pn_aotope in number
                        
         ) return number ;
         
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_fecultimopago(pn_ppgcod in number,          
          pn_ppmod in number,
          pn_ppsuc in number,
          pn_ppmda in number,
          pn_pppap in number,
          pn_ppcta in number,          
          pn_ppoper in number,
          pn_ppsbop in number,
          pn_pptope in number   
    
         ) return date;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_codcargo( pc_analista in char) return number;

 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_nomcargo(pn_cargo in number) return varchar2;

 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 Function fn_cr_fechdesem(pn_pgcod in number,          
          pn_aomod in number,
          pn_aosuc in number,
          pn_aomda in number,
          pn_aopap in number,
          pn_aocta in number,          
          pn_aooper in number,
          pn_aosbop in number,
          pn_aotope in number
                        
         ) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_nomoneda( pn_moneda in number) return varchar2;  
   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
                                                                  
    end PQ_CR_JAQY821_CAMBIO_TASA;
/

create or replace package body PQ_CR_JAQY821_CAMBIO_TASA is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_JAQY821_CAMBIO_TASA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28.12.2015
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2016.02.08 
    -- Autor de la Modificación   : RLIVISI 
    -- Descripción de Modificación: Adicion de campo Cargo Usuario que cambia tasa 
    
    -- Fecha de Modificación      : 2016.07.08 
    -- Autor de la Modificación   : RLIVISI 
    -- Descripción de Modificación: Adicion de campo Fecha de último Pago que cambia tasa 
    -- *****************************************************************
    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_datos( pd_fecini in date, 
                                pd_fecfin in date,
                                pc_codusu in varchar2,
                                pn_tiptas in number,
                                pc_usuario in varchar2
                                ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28.12.2015 
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

   cursor datos(lc_analista char) is
      select /*+ all_rows*/
       b.pgcod,
       b.aomod,
       b.aosuc,
       b.aomda,
       b.aocta,
       b.aopap,
       b.aooper,
       b.aosbop,
       b.aotope,
       b.evcorr,
       b.evtipo,
       b.evfval,
       b.evttas,
       b.evtasa,
       b.d012fc,
       b.d012co,
       a.aud_fsd012_ubu 
        from aud_fsd012_audit a, fsd012 b
       where a.aud_new_aocta = b.aocta
         and a.aud_new_aomda = b.aomda
         and a.aud_new_aomod = b.aomod
         and a.aud_new_aooper = b.aooper
         and a.aud_new_aopap = b.aopap
         and a.aud_new_aosbop = b.aosbop
         and a.aud_new_aosuc = b.aosuc
         and a.aud_new_aotope = b.aotope
         and a.aud_new_evcorr = b.evcorr
         and b.pgcod = 1
         and b.aomod in
             (101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 141)
         and b.evtipo in (3, 4)
         and d012fc >= pd_fecini
         and d012fc <= pd_fecfin 
         and b.d012mo = 0
         and b.d012fc = a.AUD_NEW_D012FC
         and b.d012fc = trunc(a.AUD_fsd012_uon)
         and a.aud_fsd012_ubu like '%'||lc_analista||'%'
         and b.aocta <> 0
         --and b.aocta <> 58740--01Feb2016
       order by b.aocta, b.aooper, b.d012fc;
   
  
 lc_estado varchar2(50);
 ln_estado number;
 lc_tipoeve varchar2(50);
 ln_moneda number;
 lc_moneda varchar2(50);
 lc_tipotasa varchar2(50);
 ld_fechdesemb date; 
 lc_analista varchar2(50);
 lc_indicador char(1);
 ln_numero number := 0;
 lc_cargo varchar2(50);--01Feb2016
 ln_cargo number; --01Feb2016
 ld_fecultimopago date; ---08.07.2016
 lc_usuarioce char(10);----22.07.2016 usuario con espacios
 begin



     if trim(pc_codusu) is null then
        lc_analista := '%';
     else
        lc_analista := pc_codusu;    
     end if;

     
     
     lc_usuarioce :=rpad(trim(pc_usuario), 10, ' '); ---adicionando usuario con espacios---22.07.2016   
     delete from jaqy821 where jaqy821usu = lc_usuarioce;--pc_usuario;
     commit;        

      for i in datos(lc_analista) loop
      
        lc_indicador := 'N'; 
        if pn_tiptas = 1 and (i.evtipo = 3  or i.evtipo = 4) then
          lc_indicador := 'S'; --insertar
        else 
            if (pn_tiptas = 3 and i.evtipo = 3) then
                lc_indicador := 'S';
            else
                if (pn_tiptas = 4 and i.evtipo = 4) then
                    lc_indicador := 'S';
                else
                    lc_indicador := 'N'; 
                end if;
            end if;
        end if;             
             
        
        if lc_indicador = 'S'   then
             lc_tipoeve:= null;
             if i.evtipo = 3 then
                 lc_tipoeve := 'Compensatoria';
              else
                 if i.evtipo = 4 then
                    lc_tipoeve := 'Moratoria';
                 end if;
              end if;
              
              
              
            -------
             lc_tipotasa:=null;
             if i.evttas = 1 then
                lc_tipotasa := 'Efectiva Anual';
             else   
                 if i.evttas = 2 then
                    lc_tipotasa := 'Lineal Anual'; 
                 else
                    if i.evttas = 3 then
                    lc_tipotasa := 'Efectiva Mensual'; 
                    else
                        if i.evttas = 4 then
                        lc_tipotasa := 'Lineal Mensual';   
                        end if;
                    end if; 
                end if;
             end if;
            -------

            
              
              --llamar a funcion  que retorna estado
              ln_estado := pq_cr_jaqy821_cambio_tasa.fn_cr_codestado(pn_pgcod => i.pgcod,
                                                             pn_aomod => i.aomod,
                                                             pn_aomda => i.aomda,
                                                             pn_aopap => i.aopap,
                                                             pn_aocta => i.aocta,
                                                             pn_aosuc => i.aosuc,
                                                             pn_aooper => i.aooper,
                                                             pn_aosbop => i.aosbop,
                                                             pn_aotope => i.aotope);
               
             if  ln_estado is not null  then     
             
              --llamar a funcion que retorna  cod cargo usuario que realiza cambio de tasa  01Feb2016
               ln_cargo := pq_cr_jaqy821_cambio_tasa.fn_cr_codcargo(pc_analista => i.aud_fsd012_ubu);   
                
               --llamar a funcion que retorna  nombre del cargo usuario que realiza cambio de tasa 02Feb2016
                lc_cargo:=  pq_cr_jaqy821_cambio_tasa.fn_cr_nomcargo(pn_cargo => ln_cargo);
                                                                    
               lc_moneda := pq_cr_jaqy821_cambio_tasa.fn_cr_nomoneda(i.aomda);
               lc_estado := pq_cr_jaqy821_cambio_tasa.fn_cr_nomestado(ln_estado);
               ld_fechdesemb := pq_cr_jaqy821_cambio_tasa.fn_cr_fechdesem(pn_pgcod => i.pgcod,
                                                             pn_aomod => i.aomod,
                                                             pn_aosuc => i.aosuc,
                                                             pn_aomda => i.aomda,
                                                             pn_aopap => i.aopap,
                                                             pn_aocta => i.aocta,                                                       
                                                             pn_aooper => i.aooper,
                                                             pn_aosbop => i.aosbop,
                                                             pn_aotope => i.aotope); 
          
            
               ld_fecultimopago := pq_cr_jaqy821_cambio_tasa.fn_cr_fecultimopago(pn_ppgcod => i.pgcod,
                                                             pn_ppmod => i.aomod,
                                                             pn_ppsuc => i.aosuc,
                                                             pn_ppmda => i.aomda,
                                                             pn_pppap => i.aopap,
                                                             pn_ppcta => i.aocta,                                                       
                                                             pn_ppoper => i.aooper,
                                                             pn_ppsbop => i.aosbop,
                                                             pn_pptope => i.aotope); 
          
                       
                --insertar registros
                ln_numero := ln_numero +1;
                insert into JAQY821(
                            jaqy821mod, jaqy821suc, jaqy821mda, jaqy821nmda, jaqy821cta, jaqy821oper, jaqy821sbop, 
                            jaqy821tope, jaqy821evcor, jaqy821evtip, jaqy821evtnom, jaqy821evfval, jaqy821evttas, jaqy821evttan, 
                            jaqy821evtasa, jaqy821d012fc, jaqy821d012co, jaqy821ad012u, jaqy821stat, jaqy821statn,jaqy821fval,
                            jaqy821cor, jaqy821usu, jaqy821caruct, jaqy821fupag )
                values (i.aomod ,i.aosuc, i.aomda, lc_moneda, i.aocta, i.aooper, i.aosbop, 
                        i.aotope,i.evcorr,i.evtipo, lc_tipoeve, i.evfval, i.evttas, lc_tipotasa,         
                        i.evtasa,i.d012fc,i.d012co,i.aud_fsd012_ubu,ln_estado,lc_estado, ld_fechdesemb,
                        ln_numero, pc_usuario, lc_cargo, ld_fecultimopago);

            
                
               commit;    
              end if; 
          end if;
                   
                                 
      end loop;


   
 end sp_cr_inserta_datos;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Function fn_cr_nomestado( pn_estado in number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_estado
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28.12.2015
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_estado varchar2(50);
    
    /*Sub 'NOMBRE ESTADO'

    For Each Cecod //FST026
        Where Cecod =  &scstat
        &CENOMB = Cenom
    EndFor
EndSub /
*/
        
  begin  
    begin
       select Cenom
         into lc_estado
         from fst026
       where  Cecod =  pn_estado;
       
       exception 
          when no_data_found then
              lc_estado :=null; 
          when too_many_rows then
             lc_estado :=null;      
       
    end;
   
    return  lc_estado;
    
  end fn_cr_nomestado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_codestado(pn_pgcod in number,          
          pn_aomod in number,
          pn_aomda in number,
          pn_aopap in number,
          pn_aocta in number,
          pn_aosuc in number,
          pn_aooper in number,
          pn_aosbop in number,
          pn_aotope in number
                        
         ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_codestado
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28.12.2015
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codestado number;
    
/*  Sub 'FSD011 ESTADO'
    For Each PgCod, Scmod, Scmda, Scpap, Sccta, Scsuc, Scoper, Scsbop, Sctope// fsd011--Obtener Estado fsd011
        Where PgCod =  &pgcod_12
        Where Scmod =  &aomod_12
        Where Scmda =  &aomda_12
        Where Scpap =  &aopap_12
        Where Sccta =  &aocta_12
        Where Scsuc =  &aosuc_12
        Where Scoper = &aooper_12
        Where Scsbop = &aosbop_12
        Where Sctope = &aotope_12    
        &scstat= Scstat
	 EndFor
EndSub // 'FSD011 ESTADO'
    */
  begin  
    begin
       select aostat
         into ln_codestado
         from fsd010
          where pgcod  = pn_pgcod       
          and   aomod   = pn_aomod
          and   aomda   = pn_aomda 
          and   aopap   = pn_aopap      
          and   aocta   = pn_aocta
          and   aosuc   = pn_aosuc
          and   aooper  = pn_aooper   
          and   aosbop  = pn_aosbop   
          and   aotope  = pn_aotope ;  
      exception 
          when no_data_found then
              ln_codestado :=null; 
          when too_many_rows then
              ln_codestado :=null; 
      end;
       
      
      return  ln_codestado;
      
   end fn_cr_codestado;
   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_fecultimopago(pn_ppgcod in number,          
          pn_ppmod in number,
          pn_ppsuc in number,
          pn_ppmda in number,
          pn_pppap in number,
          pn_ppcta in number,          
          pn_ppoper in number,
          pn_ppsbop in number,
          pn_pptope in number   
    
         ) return date is
    -- *****************************************************************
    -- Nombre                     : fn_cr_fecultimopago
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 08.07.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ld_fecultpag date;
    

  begin  
    begin
     
       select max(g.pp1fech)--(d602fc)---24.08.2016
         into ld_fecultpag
         from fsd602 g
          where pgcod  = pn_ppgcod      
          and ppmod  = pn_ppmod
          and ppsuc  = pn_ppsuc 
          and ppmda  = pn_ppmda        
          and pppap  = pn_pppap 
          and ppcta  = pn_ppcta
          and ppoper = pn_ppoper   
          and ppsbop = pn_ppsbop   
          and pptope = pn_pptope  
          and d602co = 'S'
          and g.d602mo not in 300
          and g.d602tr not in (390, 400, 406, 160, 170, 155);
       exception 
          when no_data_found then
              ld_fecultpag :=null; 
          when too_many_rows then
              ld_fecultpag :=null; 
      end;
             
      return  ld_fecultpag;
      
   end fn_cr_fecultimopago;   
   
    
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
Function fn_cr_codcargo( pc_analista in char) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_nomcargo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01.02.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna el nombre del cargo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
    ln_cargo number; 
    
/*Sub 'CodCargoTipana'
    //&analista2 = trim(&analista)
	For Each //sng057    
	Where SNG057Usr = &analista//&analista2 //cambiar &asesor por &analista 21Ene2016
	&SNG055Car = SNG055Car  
	EndFor
	Do 'CargoTipana'
EndSub // 'CodCargoTipana'*/ 

        
  begin  
    begin
       select SNG055Car
         into ln_cargo
         from sng057
       where  SNG057Usr = pc_analista;
       
       exception 
          when no_data_found then
              ln_cargo :=null; 
          when too_many_rows then
             ln_cargo :=null;      
       
    end;
   
    return  ln_cargo;
    
  end fn_cr_codcargo;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


Function fn_cr_nomcargo(pn_cargo in number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_nomcargo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01.02.2016
    -- Autor de Creación          : RLIVISI
    -- Uso                        : Retorna nombre del cargo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_nomcargo varchar2(50);   
    
/*Sub 'CargoTipana'
    For Each SNG055Emp, SNG055Car//sng055
    Where SNG055Emp = &Pgcod
	Where SNG055Car = &sng055car
	&SNG055Dsc = SNG055Dsc  // 55-Cargo
	EndFor
EndSub // 'CargoTipana'*/    

  begin  
    begin
       select SNG055Dsc
         into lc_nomcargo
         from sng055
          where sng055car  = pn_cargo;           
          
      exception 
          when no_data_found then
              lc_nomcargo :=null; 
          when too_many_rows then
              lc_nomcargo :=null; 
      end;
      
      return  lc_nomcargo;
      
   end fn_cr_nomcargo;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
   Function fn_cr_fechdesem(pn_pgcod in number,          
          pn_aomod in number,
          pn_aosuc in number,
          pn_aomda in number,
          pn_aopap in number,
          pn_aocta in number,          
          pn_aooper in number,
          pn_aosbop in number,
          pn_aotope in number
                        
         ) return date is
    -- *****************************************************************
    -- Nombre                     : fn_cr_fechdesem
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28.12.2015
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ld_fechdesem date;
    
/*  Sub 'FSD010 FechaDesem'
    For Each PgCod, aomod, aomda, aopap, aocta, aosuc, aooper, aosbop, aotope// fsd010--Obtener Estado fsd010
        Where PgCod =  &pgcod
        Where aomod =  &aomod
        Where aomda =  &aomda
        Where aopap =  &aopap
        Where aocta =  &aocta
        Where aosuc =  &aosuc
        Where aooper = &aooper
        Where aosbop = &aosbop
        Where aotope = &aotope    
        &aostat= aofval
	 EndFor
EndSub // 'FSD010 FechaDesem'
    */
  
 
  begin  
    begin
       select aofval
         into ld_fechdesem
         from fsd010
          Where PgCod   = pn_pgcod    
          and aomod   = pn_aomod
          and aosuc   = pn_aosuc
          and aomda   = pn_aomda 
          and aopap   = pn_aopap    
          and aocta   = pn_aocta          
          and aooper  = pn_aooper   
          and aosbop  = pn_aosbop   
          and aotope  = pn_aotope ;             
     
      exception 
          when no_data_found then
              ld_fechdesem :=null; 
          when too_many_rows then
             ld_fechdesem :=null; 
      end;
            
      
      return  ld_fechdesem;
      
   end fn_cr_fechdesem;
   
   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Function fn_cr_nomoneda( pn_moneda in number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_estado
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28.12.2015
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_moneda varchar2(50);
/*    
Sub 'NOMBRE MONEDA'
For Each Moneda// fst005
Where Moneda = &aomda_12
&monom = Monom
EndFor
EndSub // 'NOMBRE MONEDA'
*/
   
    
  begin
  
    begin
       select Monom
         into lc_moneda
         from fst005
         where  Moneda =  pn_moneda;
    end;
   
    return  lc_moneda;
    
  end fn_cr_nomoneda;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
end PQ_CR_JAQY821_CAMBIO_TASA;
/

