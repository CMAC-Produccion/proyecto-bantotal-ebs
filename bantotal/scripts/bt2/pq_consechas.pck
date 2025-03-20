create or replace package PQ_CONSECHAS is

  -- Author  : MARAUJO
  -- Created : 02/03/2011 04:23:53 p.m.
  -- Purpose : OBTIENE DATOS GENERALES

Function fn_modalidad(PN_PGCOD  in number,
                        PN_CODMOD in number,
                        PN_CODMDA in number,
                        PN_CODCTA in number,
                        PN_CODOPE in number,
                        PN_CODSUB in number,
                        PN_CODTOP in number,
                        PN_NUMINS in number)Return varchar2;
Function fn_cl_actividad_econom(PN_PAIS in number,
                                  PN_TDOC in number,
                                  PC_NDOC in char,
                                  PC_TPER in char
                                 )  return varchar2;
Function fn_segmento(PN_TIPDOC in number,
                     PN_NUMDOC in number,
                     PC_NUMDOC in varchar,
                     PN_Anio   in number, 
                     PN_Mes    in number) Return varchar2;
Function fn_rango_desembolso(PN_MTODES in number) Return varchar2;
Function fn_producto(PN_MODULO in number) Return varchar2;
Function fn_sbs(PN_SBS in VARCHAR, PN_MONTO IN NUMBER) Return varchar2;
Function fn_Tipo_credito(PN_RUBRO in number,
                         pn_mod in number, 
                         pn_suc in number, 
                         pn_mda in number,
                         pn_pap in number, 
                         pn_cta in number, 
                         pn_oper in number,
                         pn_sbop in number,
                         pn_top in number, 
                         pd_fecha in date /*Fecha de ejecucion*/  ) Return varchar2;
Function fn_Comite_Aprobador(PN_nroins in number , PN_MOD IN NUMBER ) return varchar2;                         

procedure sp_log(PFECPRO VARCHAR, ptipdoc NUMBER , pnumdoc varchar,  MERROR VARCHAR );
 -------------------------------------------------------------------------------
function  fn_campania_cred(p_n_modulo in number, 
                           p_n_suc in number,           
                           p_n_mda in number,                           
                           p_n_pap in number,
                           p_n_cta in number,                                                      
                           p_n_oper in number,
                           p_n_sbop in number,                                                      
                           p_n_tipope in number,
                           p_d_fecdes in date, --Fecha desembolso Real
                           p_c_flgtip in varchar --D=Desembolso  
                          ) 
return varchar2;
-------------------------------------------------
Procedure sp_datos_cupo(PN_PGCOD in number,
                        PN_CODMOD in number,
                        PN_CODSUC in number,                        
                        PN_CODMDA in number,
                        PN_CODPAP in number,
                        PN_CODCTA in number,
                        PN_CODOPE in number,
                        PN_CODSBO in number,
                        PN_CODTOP in number,
                        PD_FECVAL in date,
                        PN_AOIMP  in number,
                        PD_FECPRO in date,
                        --
                        PN_modcup Out number, 
                        PN_succup Out Number,
                        PN_mdacup Out Number,
                        PN_papcup Out Number,                        
                        PN_ctacup Out number,
                        PN_opecup Out number,
                        PN_sbocup Out Number,
                        PN_topcup Out Number,
                        PD_fvacup Out date,
                        PN_totcup Out Number
                       );
----------------------------------------------------------
 function  fn_desdolarizacion(p_n_modulo in number, 
                             p_n_suc in number,           
                             p_n_mda in number,                           
                             p_n_pap in number,
                             p_n_cta in number,                                                      
                             p_n_oper in number,
                             p_n_sbop in number,                                                      
                             p_n_tipope in number  
                             ) 
                             return varchar2;
-------------------------------------------------------------------
 procedure sp_credito_original(
                                 v_pgcod   in number,
                                 v_Scmod   in number,
                                 v_Scsuc   in number,
                                 v_Scmda   in number,
                                 v_Scpap   in number,
                                 v_Sccta   in number,
                                 v_Scoper  in number,
                                 v_Scsbop  in number,
                                 v_Sctope  in number,
                                 ---retorno
                                lv_bcemp  out fsh012.bcemp%type,
                                lv_bcmod  out fsh012.bcmod%type,
                                lv_bcsuc  out fsh012.bcsuc%type,
                                lv_bcmda  out fsh012.bcmda%type,
                                lv_bcpap  out fsh012.bcpap%type,
                                lv_bccta  out fsh012.bccta%type,
                                lv_bcoper out fsh012.bcoper%type,
                                lv_bcsbop out fsh012.bcsbop%type,
                                lv_bctop  out fsh012.bctop%type                                
                              );
end PQ_CONSECHAS;
/

create or replace package body PQ_CONSECHAS is

Function fn_modalidad(PN_PGCOD  in number,
                        PN_CODMOD in number,
                        PN_CODMDA in number,
                        PN_CODCTA in number,
                        PN_CODOPE in number,
                        PN_CODSUB in number,
                        PN_CODTOP in number,
                        PN_NUMINS in number
                       )
  Return varchar2
  -- Creado: 
  ------------------------------------------------------------
  -- Fecha: 2015.02.10
  -- Autor: Paola Vargas 
  -- Uso  : Retorna código de modalidad
  ------------------------------------------------------------
  -- Modificaciones:
  ------------------------------------------------------------
  Is
    ln_modali number(5);
    lv_modali varchar2(30);
    --ln_numins number(9);
  Begin  
        -- Refinanciado Transado
        Select count(*)
          Into ln_modali
          From fsr011 r
         Where r.r2cod = PN_PGCOD
           and r.r2mod = PN_CODMOD
           and r.r2mda = PN_CODMDA
           and r.r2cta = PN_CODCTA
           and r.r2oper= PN_CODOPE
           and r.r2sbop= PN_CODSUB
           and r.r2tope= PN_CODTOP
           and r.relcod= 35
           and r.r011co= 'S'
           and r.r2mod<>65;-- not in (33,200,65);
        If ln_modali > 0 Then  
           lv_modali := 'TRANSADO';--'16';
        Else
            Select count(*)
              Into ln_modali
              From xwf700 
             Where xwfprcins = PN_NUMINS
               and xwfcar3 = 'J'
               and PN_CODMOD not in(200,33)
               and PN_CODTOP<>550;  --Refinanciac C+I+M+ICV 1a1 -PJM           
            If ln_modali > 0 Then  
               lv_modali := 'TRANSADO';--'16';           
            End If;
        End If;   
        
        If lv_modali is null Then
           -- Refinanciado (120)
            Select count(*)
              Into ln_modali
              From fsr011 r
             Where r.r1cod = PN_PGCOD
               and r.r1mod = PN_CODMOD
               and r.r1mda = PN_CODMDA
               and r.r1cta = PN_CODCTA
               and r.r1oper= PN_CODOPE
               and r.r1sbop= PN_CODSUB
               and r.r1tope= PN_CODTOP
               and r.relcod= 120
               and r.r011co= 'S'
               and (case
                     when r1cta = r2cta and r1oper=r2oper and r1sbop>=r2sbop then 1
                     when (r1cta <> r2cta or r1oper<>r2oper)  then 1
                    end)=1 
               ;
           If ln_modali = 0 Then  
              Select count(*)
                Into ln_modali
                From fsr011 r
               Where r.r2cod = PN_PGCOD
                 and r.r2mod = PN_CODMOD
                 and r.r2mda = PN_CODMDA
                 and r.r2cta = PN_CODCTA
                 and r.r2oper= PN_CODOPE
                 and r.r2sbop= PN_CODSUB
                 and r.r2tope= PN_CODTOP
                 and r.relcod= 120
                 and r.r011co= 'S'
                 and r.r1cta = r.r2cta 
                 and r.r1oper= r.r2oper 
                 and r.r2sbop> r.r1sbop
                 and r2mod = 116                  
                 ;
           End If; 
           If ln_modali > 0 Then  
              lv_modali := 'REFINANCIADO';--'15';
           End If;  
        End If;      
        
        If lv_modali is Null Then
           -- Reprogramados por Cambio de Fecha
           Select count(*)
              Into ln_modali
              From fsr011 r
             Where r.r1cod = PN_PGCOD
               and r.r1mod = PN_CODMOD
               and r.r1mda = PN_CODMDA
               and r.r1cta = PN_CODCTA
               and r.r1oper= PN_CODOPE
               and r.r1sbop= PN_CODSUB
               and r.r1tope= PN_CODTOP
               and r.relcod= 860
               and r.r011co= 'S';
               
            If ln_modali = 0 Then
               -- Reprogramados por desastres naturales
               Select count(*)
                  Into ln_modali
                  From fsr011 r
                 Where r.r1cod = PN_PGCOD
                   and r.r1mod = PN_CODMOD
                   and r.r1mda = PN_CODMDA
                   and r.r1cta = PN_CODCTA
                   and r.r1oper= PN_CODOPE
                   and r.r1sbop= PN_CODSUB
                   and r.r1tope= PN_CODTOP
                   and r.relcod= 870
                   and r.r011co= 'S';
            Else 
                lv_modali := 'REPROGRAMADO';--'13';
            End If;    
            
            If ln_modali = 0 Then
               -- Reprogramados por campaña
               Select count(*)
                  Into ln_modali
                  From fsr011 r
                 Where r.r1cod = PN_PGCOD
                   and r.r1mod = PN_CODMOD
                   and r.r1mda = PN_CODMDA
                   and r.r1cta = PN_CODCTA
                   and r.r1oper= PN_CODOPE
                   and r.r1sbop= PN_CODSUB
                   and r.r1tope= PN_CODTOP
                   and r.relcod= 890
                   and r.r011co= 'S';
               
               If ln_modali > 0 Then  
                  lv_modali := 'REPROGRAMADO CAMPAÑA';--'17';
               End If;      
                   
            Else 
                lv_modali := 'REPROG.DESASTRE.NAT';--'14';
            End If;
        End If;  
        
        If lv_modali is Null Then
            -- Ampliados
            Select count(*)
              Into ln_modali
              From fsr011 r
             Where r.r1cod = PN_PGCOD
               and r.r1mod = PN_CODMOD
               and r.r1mda = PN_CODMDA
               and r.r1cta = PN_CODCTA
               and r.r1oper= PN_CODOPE
               and r.r1sbop= PN_CODSUB
               and r.r1tope= PN_CODTOP
               and r.relcod= 130
               and r.r011co= 'S';
           If ln_modali = 0 Then
              -- Ampliado Especial
              Select count(*)
                Into ln_modali
                From fsr011 r
               Where r.r1cod = PN_PGCOD
                 and r.r1mod = PN_CODMOD
                 and r.r1mda = PN_CODMDA
                 and r.r1cta = PN_CODCTA
                 and r.r1oper= PN_CODOPE
                 and r.r1sbop= PN_CODSUB
                 and r.r1tope= PN_CODTOP
                 and r.relcod= 880
                 and r.r011co= 'S';
               If ln_modali > 0 Then
                  lv_modali := 'AMPLIADO ESPECIAL';--'18';
               Else
                  -- Ampliacion
                  Select count(*)
                    Into ln_modali
                    From sng001 g1
                   Where g1.sng001inst = PN_NUMINS
                     and g1.sng001ori in (4,12);
                     
                   If ln_modali > 0 Then
                      lv_modali := 'AMPLIADO';--'4';
                   End If;

               End If;  
           Else
               lv_modali := 'AMPLIADO';--'4';
           End If;        
        End If;
          
     Return nvl(lv_modali,'NORMAL');    -- Return nvl(lv_modali,'0');
     
/* Dimension Modalidad
select 'NORMAL' from dual
union all
select 'AMPLIADO' from dual
union all
select 'AMPLIADO ESPECIAL' from dual
union all
select 'REPROG.DESASTRE.NAT' from dual
union all
select 'REPROGRAMADO CAMPAÑA' from dual
union all
select 'REPROGRAMADO' from dual
union all
select 'REFINANCIADO' from dual
union all
select 'TRANSADO' from dual;
*/
end;



Function fn_cl_actividad_econom(PN_PAIS in number,
                                  PN_TDOC in number,
                                  PC_NDOC in char,
                                  PC_TPER in char
                                 )
  return varchar2
  -- Creado: 
  ------------------------------------------------------------
  -- Fecha: 2015.02.10
  -- Autor: Paola Vargas 
  -- Uso  : Retorna código de activiad económica (CIIU)
  ------------------------------------------------------------
  -- Modificaciones:
  ------------------------------------------------------------
  is 
    lv_acteco varchar2(13);   
    lc_acteco varchar2(70);
    ln_existe number(2);
  Begin
       If PC_TPER = 'J' Then
           select trim(to_char(nvl(pj.expnins,0),'999999999999'))
             into lv_acteco 
             from fse001 pj
            where pj.d511pais = PN_PAIS
              and pj.d511tdoc = PN_TDOC
              and pj.d511ndoc = PC_NDOC
              and pj.impnreg  = 0; 
       Else
           select trim(to_char(nvl(pn.sngc60acte,0),'999999999999'))
             into lv_acteco 
             from sngc60 pn
            where pn.sngc60pais = PN_PAIS
              and pn.sngc60tdoc = PN_TDOC
              and pn.sngc60ndoc = PC_NDOC
              and pn.sngc60corr  = 0; 
       End If;  
       
      /* select count(*) Into ln_existe
         from tmp_dm_actividad_economica h
        Where h.codigo_actividad_economica = lv_acteco;
       
       If ln_existe <= 0 Then lv_acteco:= '0'; End If;  */
        Case when substr(lv_acteco,1,3) in (100,110,111,112,113) and 
                 substr(lv_acteco,1,4) not in (1000)  then lc_acteco:= 'Agricola';
            when  substr(lv_acteco,1,4) in (1000,1010,1020,1400,1410,1421,1422)then lc_acteco:='Mineria';
            when substr(lv_acteco,1,3) in (120,121,122,130,140) then lc_acteco:='Pecuario';
            when substr(lv_acteco,1,3) in (500) then lc_acteco:='Pesca';
            when substr(lv_acteco,1,3) in (151,152,153,154,155) then lc_acteco:='Agroindustria';
            when substr(lv_acteco,1,3) in (171,172,173,181,182) then lc_acteco:='Industria Textil';
            when substr(lv_acteco,1,3) in (191,192) then lc_acteco:='Industria de Cuero y Calzado';
            when substr(lv_acteco,1,3) in (201,202,210,221,222,223,241,242,243,251,252,261,269,
                                             271,272,273,281,289,289,291,292,293,311,312,314,315,
                                             319,321,322,331,333,341,342,343,351,352,359,361,369,
                                             371,372,401,402,403,410,451) then lc_acteco:='Otros Tipos de Industria';
            when substr(lv_acteco,1,3) in (450,452,453,454,455) then lc_acteco:='Construcción';
            when substr(lv_acteco,1,3) in (501,502,503,504,505) then lc_acteco:='Venta y reparación de vehículos';
            when substr(lv_acteco,1,3) in (511,512,519) then lc_acteco:='Venta por Mayor de alimentos y bebidas';
            when substr(lv_acteco,1,3) in (513,514,515) then lc_acteco:='Venta al por mayor de otros productos';
            when substr(lv_acteco,1,3) in (521) then lc_acteco:='Venta por menor de Alimentos, bebidas y vestido';
            when substr(lv_acteco,1,3) in (522) then lc_acteco:='Venta por Menor de Vestido';
            when substr(lv_acteco,1,3) in (523,524,526,527) then lc_acteco:='Venta al por menor diversa';
            when substr(lv_acteco,1,3) in (525) then lc_acteco:='Venta de Abarrotes y alimentos preparados';
            when substr(lv_acteco,1,3) in (551,552) then lc_acteco:='Hoteles y Restaurantes';
            when substr(lv_acteco,1,4) in (6010,6023,6110,6120,6210,6220,6301,6302,6303) then lc_acteco:='Transporte de Carga y similares';
            when substr(lv_acteco,1,4) in (6021,6022) then lc_acteco:='Transporte de Pasajeros Urbano e Interprovincial';
            when substr(lv_acteco,1,3) in (630,641,642,651,659,660,671,672,701,711,712,713,721,722,723,724,725,729,731,732,741,742,743,749,751,752,753) then lc_acteco:='Otras actividades de Servicio';
            when substr(lv_acteco,1,3) in (702) then lc_acteco:='Alquiler de Inmuebles';
            when substr(lv_acteco,1,3) in (801,802,803,809) then lc_acteco:='Actividades de Enseñanza';
            when substr(lv_acteco,1,3) in (851,852,853,900,911,912,919,921,922,923,924,930,950,990,999) then lc_acteco:='Otras actividades';
            else  lc_acteco:='Otras actividades'; end case;
       
       Return trim(lc_acteco);
       
  Exception When Others Then
      Return null;       
  End ;        
/* Dimension Actividad Economica
select 
       distinct 
       Case when substr(act.actcod1,1,3) in (100,110,111,112,113) and 
                 substr(act.actcod1,1,4) not in (1000)  then 'Agricola'
            when  substr(act.actcod1,1,4) in (1000,1010,1020,1400,1410,1421,1422)then 'Mineria'
            when substr(act.actcod1,1,3) in (120,121,122,130,140) then 'Pecuario'
            when substr(act.actcod1,1,3) in (500) then 'Pesca'
            when substr(act.actcod1,1,3) in (151,152,153,154,155) then 'Agroindustria'
            when substr(act.actcod1,1,3) in (171,172,173,181,182) then 'Industria Textil'
            when substr(act.actcod1,1,3) in (191,192) then 'Industria de Cuero y Calzado'
            when substr(act.actcod1,1,3) in (201,202,210,221,222,223,241,242,243,251,252,261,269,
                                             271,272,273,281,289,289,291,292,293,311,312,314,315,
                                             319,321,322,331,333,341,342,343,351,352,359,361,369,
                                             371,372,401,402,403,410,451) then 'Otros Tipos de Industria'
            when substr(act.actcod1,1,3) in (450,452,453,454,455) then 'Construcción'
            when substr(act.actcod1,1,3) in (501,502,503,504,505) then 'Venta y reparación de vehículos'
            when substr(act.actcod1,1,3) in (511,512,519) then 'Venta por Mayor de alimentos y bebidas'
            when substr(act.actcod1,1,3) in (513,514,515) then 'Venta al por mayor de otros productos'
            when substr(act.actcod1,1,3) in (521) then 'Venta por menor de Alimentos, bebidas y vestido'
            when substr(act.actcod1,1,3) in (522) then 'Venta por Menor de Vestido'
            when substr(act.actcod1,1,3) in (523,524,526,527) then 'Venta al por menor diversa'
            when substr(act.actcod1,1,3) in (525) then 'Venta de Abarrotes y alimentos preparados'
            when substr(act.actcod1,1,3) in (551,552) then 'Hoteles y Restaurantes'
            when substr(act.actcod1,1,4) in (6010,6023,6110,6120,6210,6220,6301,6302,6303) then 'Transporte de Carga y similares'
            when substr(act.actcod1,1,4) in (6021,6022) then 'Transporte de Pasajeros Urbano e Interprovincial'
            when substr(act.actcod1,1,3) in (630,641,642,651,659,660,671,672,701,711,712,713,721,722,723,724,725,729,731,732,741,742,743,749,751,752,753) then 'Otras actividades de Servicio'
            when substr(act.actcod1,1,3) in (702) then 'Alquiler de Inmuebles'
            when substr(act.actcod1,1,3) in (801,802,803,809) then 'Actividades de Enseñanza'
            when substr(act.actcod1,1,3) in (851,852,853,900,911,912,919,921,922,923,924,930,950,990,999) then 'Otras actividades'
            else  'Otras actividades'
        end DesActividad                                                                                                                                                                                                                                             
  from FST750 act ;
 
*/
Function fn_segmento(PN_TIPDOC in number,
                     PN_NUMDOC in number,
                     PC_NUMDOC in varchar,
                     PN_Anio   in number, -- año de desembolso
                     PN_Mes    in number)  -- mes de desembolso
                     Return varchar2 is
                     
  lc_segmento varchar2(100);
  fechae varchar2(15);
  
  begin 
    select c.jaqy067ncal
      into lc_segmento
      from jaqy066 d, JAQY067 c
     where d.jaqy066paic  = PN_TIPDOC
       and d.jaqy066tdoc  = PN_NUMDOC
       and d.jaqy066tndoc = PC_NUMDOC
       and d.jaqy066pano  = pn_anio
       and d.jaqy066pmes  = pn_mes 
       and c.jaqy067ccal  = d.jaqy066calf;
    return lc_segmento;       
  exception
     when no_data_found then
          lc_segmento := 'NO REGISTRADO' ;    
          return lc_segmento;
          
          
     when TOO_MANY_ROWS  then  
        
     BEGIN
         
         select c.jaqy067ncal
           into lc_segmento
           from jaqy066 d, JAQY067 c
          where d.jaqy066paic = PN_TIPDOC
            and d.jaqy066tdoc = PN_NUMDOC
            and d.jaqy066tndoc = PC_NUMDOC
            and d.jaqy066pano = pn_anio
            and d.jaqy066pmes = pn_mes
            and c.jaqy067ccal = d.jaqy066calf
            and d.jaqy066nse = 'S'
            and rownum <=1 ;            
            return lc_segmento;
     EXCEPTION
     WHEN OTHERS THEN
       
        fechae := to_char(pn_anio)|| lpad(to_char(pn_mes),2,'0')||'01';        
        sp_log(fechae , PN_NUMDOC  , PC_NUMDOC ,  SUBSTR(SQLERRM,1,199)  );        
        lc_segmento := 'NO REGISTRADO' ;    
        return lc_segmento;
         
      end;   
     
       
/* Dimension segmento
select to_char(JAQY067CCAL) codigo,
       upper(JAQY067NCAL) nombre
  from JAQY067 
 UNION ALL
select '0','No Registrado' from dual;
*/
End;  
  
--rmogrovejo comentado el montos----


Function fn_rango_desembolso(PN_MTODES in number)  -- mes de desembolso
                     Return varchar2 is
lc_rangodes varchar2(50);
ln_mtodes number;
begin   
  ln_mtodes := abs(nvl(PN_MTODES,0));   
  Case when ln_mtodes < 1001 then 
            lc_rangodes := 'S/.0 a S/. 1 Mil';
       when ln_mtodes >= 1001 and ln_mtodes <= 2000 then 
            lc_rangodes := 'S/.1 Mil S/. 2 Mil';
       when ln_mtodes > 2000 and ln_mtodes <= 5000 then 
            lc_rangodes := 'S/.2 Mil   a S/. 5 Mil';
       when ln_mtodes > 5000 and ln_mtodes <= 10000 then 
            lc_rangodes := 'S/.5 Mil  a S/. 10 Mil';              
       when ln_mtodes > 10000 and ln_mtodes <= 35000 then 
            lc_rangodes := 'S/.10 Mil a S/. 35 Mil';
       when ln_mtodes > 35000 and ln_mtodes <= 65000 then 
            lc_rangodes := 'S/.35 Mil  a S/. 65 Mil';     
       when ln_mtodes > 65000 and ln_mtodes <= 100000 then 
            lc_rangodes := 'S/.65 Mil  a S/. 100 Mil';     
       when ln_mtodes > 100000 then 
            lc_rangodes := 'Mayor a S/.100 Mil'; 
       else        
            lc_rangodes := 'Sin valor'; 
  end case;
  return lc_rangodes;
end;     

         
 /*Dimesion Mto Desembolso
select 0,1000, 'S/.0 a S/. 1 Mil' from dual union all
select  1001 , 2000 ,	'S/.1 Mil S/. 2 Mil' from dual union all
select  2001 ,	5000 ,	'S/.2Mil   a S/. 5 Mil' from dual union all
select  5001 	,10000 ,	'S/.5 Mil  a S/. 10 Mil' from dual union all
select  10001 ,	 35000 ,	'S/.10 Mil a S/. 35 Mil' from dual union all
select  35001 ,	 65000 ,	'S/.35 Mil  a S/. 65 Mil' from dual union all
select  65001 ,	 100000, 	'S/.65 Mil  a S/. 100 Mil' from dual union all
select  100001,  999999999999	, 'Mayor a S/.100 Mil' from dual ;
*/

Function fn_producto(PN_MODULO in number)  -- mes de desembolso
                     Return varchar2 is
lc_producto varchar2(50);

begin   
  select MDNOM	
    into lc_producto
    from fst003 
   where modulo = PN_MODULO;
  return lc_producto;
exception 
   when no_data_found then 
        lc_producto := null;
 return lc_producto;        
end;              
/* Dimension Producto
  select MDNOM  
    from fst003 
   where modulo in (select modulo from fst111 where dscod = 50 and modulo not in (29,144)
   union all
   select 117 from dual union all
   select 141 from dual );
*/


Function fn_sbs(PN_SBS in VARCHAR, PN_MONTO IN NUMBER)  -- mes de desembolso
                     Return varchar2 is
lc_producto varchar2(50);

begin   

  IF TRIM(PN_SBS) = 'PEQUEÑA EMPRESA' OR TRIM(PN_SBS) = 'PEQUEÑA EMPRESA 0' THEN
    IF PN_MONTO > 2000 AND PN_MONTO < 75000 THEN 
      lc_producto := TRIM('PEQUEÑA EMPRESA')||' 3';
    ELSE   
      IF PN_MONTO > 75000 AND PN_MONTO < 150000 THEN 
              lc_producto := TRIM('PEQUEÑA EMPRESA')||' 2';
      ELSE 
         IF  PN_MONTO > 150000 AND PN_MONTO < 350000 THEN 
              lc_producto := TRIM('PEQUEÑA EMPRESA')||' 1';
         END IF ;       
      END IF ;  
    END IF ;
  ELSE   
      IF TRIM(PN_SBS) IN ('PEQUEÑA EMPRESA 0 1','PEQUEÑA EMPRESA 0 2','PEQUEÑA EMPRESA 0 3') THEN
         lc_producto := REPLACE(TRIM(PN_SBS),'0 1','1' );
         lc_producto := REPLACE(TRIM(PN_SBS),'0 2','2' );
         lc_producto := REPLACE(TRIM(PN_SBS),'0 3','3' );         
        
      ELSE 
      lc_producto := TRIM(PN_SBS);
      END IF; 
  END IF ;   
  return lc_producto;
exception 
   when no_data_found then 
        lc_producto := null;
 return lc_producto;        
end;              




Function fn_Tipo_credito(PN_RUBRO in number,
                         pn_mod in number, 
                         pn_suc in number, 
                         pn_mda in number,
                         pn_pap in number, 
                         pn_cta in number, 
                         pn_oper in number,
                         pn_sbop in number,
                         pn_top in number, 
                         pd_fecha in date /*Fecha de ejecucion*/  ) Return varchar2 is
  lc_tipcre varchar2(50);
  ln_grupo number;
  ln_sector NUMBER;
  ld_Fecha date;
  
  --
  ln_instancia  number;

  ln_pgcodCu    number;
  ln_scmodCu    number;
  ln_ScsucCu    number;
  ln_ScmdaCu    number;
  ln_ScpapCu    number;
  ln_ScctaCu    number;
  ln_ScoperCu   number;
  ln_ScsbopCu   number;
  ln_SctopeCu   number;
  ld_aofval     date;  
begin 
    Case When Substr(PN_RUBRO, 1, 2) = '14' and
              Substr(PN_RUBRO, 5, 2) = '02' then lc_tipcre:= 'MICRO EMPRESA';
              ln_grupo := 2;
         When Substr(PN_RUBRO, 1, 2) = '14' and
              Substr(PN_RUBRO, 5, 2) = '03' then lc_tipcre:= 'CONSUMO';
              ln_grupo := 3;
         When Substr(PN_RUBRO, 1, 2) = '14' and
              Substr(PN_RUBRO, 5, 2) = '04' then lc_tipcre:= 'HIPOTECARIO';
              ln_grupo := 4;
         When Substr(PN_RUBRO, 1, 2) = '14' and
              Substr(PN_RUBRO, 5, 2) = '09' then lc_tipcre:= 'CORPORATIVO E.I.F.';
              ln_grupo := 9;
         When Substr(PN_RUBRO, 1, 2) = '14' and
              Substr(PN_RUBRO, 5, 2) = '11' then lc_tipcre:= 'GRANDES EMPRESAS';
              ln_grupo := 11;
         When Substr(PN_RUBRO, 1, 2) = '14' and
              Substr(PN_RUBRO, 5, 2) = '12' then lc_tipcre:= 'MEDIANA EMPRESA';
              ln_grupo := 12;
         When Substr(PN_RUBRO, 1, 2) = '14' and
              Substr(PN_RUBRO, 5, 2) = '13' then lc_tipcre:= 'PEQUEÑA EMPRESA';
              ln_grupo := 13;
         When Substr(PN_RUBRO,1,2) in ('71','72') and
              Substr(PN_RUBRO,7,2) = '02' then lc_tipcre:= 'MICRO EMPRESA';
              ln_grupo := 2;
         When Substr(PN_RUBRO,1,2) in ('71','72') and
              Substr(PN_RUBRO,7,2) = '03' then lc_tipcre:= 'CONSUMO';
              ln_grupo := 3;
         When Substr(PN_RUBRO,1,2) in ('71','72') and
              Substr(PN_RUBRO,7,2) = '04' then lc_tipcre:= 'HIPOTECARIO';
              ln_grupo := 4;
         When Substr(PN_RUBRO,1,2) in ('71','72') and
              Substr(PN_RUBRO,7,2) = '12' then lc_tipcre:= 'MEDIANA EMPRESA';
              ln_grupo := 12;
         When Substr(PN_RUBRO,1,2) in ('71','72') and
              Substr(PN_RUBRO,7,2) = '13' then lc_tipcre:= 'PEQUEÑA EMPRESA';
              ln_grupo := 13;
         Else lc_tipcre:= null; ln_grupo := 0;
   End case ; 
   if  ln_grupo = 13 then 
       IF pn_mod = 116 then
      begin
        SELECT R2COD, R2MOD, R2SUC, R2MDA, R2PAP,R2CTA, R2OPER, R2SBOP, R2TOPE
               into ln_pgcodCu, ln_scmodCu, ln_ScsucCu, ln_ScmdaCu, ln_ScpapCu,
                    ln_ScctaCu, ln_ScoperCu, ln_ScsbopCu, ln_SctopeCu
          FROM fsr011 r11
         where relcod = 46
           and r11.R1COD  = 1
           and r11.R1MOD  = pn_mod
           and r11.R1SUC  = pn_suc
           and r11.R1MDA  = pn_mda
           and r11.R1PAP  = pn_pap
           and r11.R1CTA  = pn_cta
           and r11.R1OPER = pn_oper
           and r11.R1SBOP = pn_sbop
           and r11.R1TOPE = pn_top;
      exception
          when others then
             null;
      end;
    END IF;

    --Los fines de mes se tiene que obtener de la jaql101
    IF pd_Fecha = last_day(pd_Fecha) THEN

      begin
        select /*+all rows*/distinct l.jaql101scl
          into ln_sector
          from jaql101 l
          where l.jaql101pgc = 1
            and l.jaql101suc = pn_suc
            and l.jaql101mon = pn_mda
            and l.jaql101pap = pn_pap
            and l.jaql101cta = pn_cta
            and l.jaql101ope = pn_oper
            and l.jaql101sop = pn_sbop
            and l.jaql101top = pn_top
            and l.jaql101mod = pn_mod
            and l.jaql101fch = pd_Fecha
            AND l.jaql101cor = (SELECT MAX(jaql101cor)
                                  FROM jaql101
                                 WHERE jaql101suc  = l.jaql101suc
                                    and jaql101mon = l.jaql101mon
                                    and jaql101pap = l.jaql101pap
                                    and jaql101cta = l.jaql101cta
                                    and jaql101ope = l.jaql101ope
                                    and jaql101sop = l.jaql101sop
                                    and jaql101top = l.jaql101top
                                    and jaql101mod = l.jaql101mod
                                    AND jaql101fch = l.jaql101fch
                               )
            and rownum = 1;
      exception
          when others then
             --ln_sector := null;
             IF last_day(ld_aofval)=last_day(pd_Fecha) THEN --desembolso en el mes de proceso
                  begin
                       select trim(wv.WFAttSVal)
                         into ln_sector
                         from WFATTSVALUES wv
                        where WFINSPRCID = ln_instancia--v_instancia
                          and WFAttSId   = 'SECTOR';
                  exception
                    when others then
                         ln_sector := null;
                  end;
              END IF;
             
      end;
      if nvl(ln_sector,0) = 0 then 
        IF last_day(ld_aofval)=last_day(pd_Fecha) THEN --desembolso en el mes de proceso
              begin
                   select trim(wv.WFAttSVal)
                     into ln_sector
                     from WFATTSVALUES wv
                    where WFINSPRCID = ln_instancia--v_instancia
                      and WFAttSId   = 'SECTOR';
              exception
                when others then
                     ln_sector := null;
              end;
          END IF;
        end if;
    ELSE --Otros dias
      begin
          select distinct JAQL101Scl
           into ln_sector
            from jaql101 a
           where a.jaql101pgc = 1
             and a.jaql101cta = pn_cta
             and a.jaql101ope = pn_oper
             and a.jaql101fch = (select max(j.jaql101fch)
                                   from JAQL101 j
                                  where JAQL101Pgc = 1
                                    and JAQL101Cta = pn_cta
                                    and JAQL101Ope = pn_oper
                                    and j.jaql101fch>=last_day(add_months(pd_Fecha,-1))--ultimo cierre antes de fecha de proceso
                                    and j.jaql101fch<=pd_Fecha
                                 )
            AND a.jaql101cor = (SELECT MAX(jaql101cor)
                                  FROM jaql101 b
                                WHERE b.jaql101suc = a.jaql101suc
                                  and b.jaql101mon = a.jaql101mon
                                  and b.jaql101pap = a.jaql101pap
                                  and b.jaql101cta = a.jaql101cta
                                  and b.jaql101ope = a.jaql101ope
                                  and b.jaql101sop = a.jaql101sop
                                  and b.jaql101top = a.jaql101top
                                  and b.jaql101mod = a.jaql101mod
                                  AND b.jaql101fch = a.jaql101fch
                                  )
            and rownum=1;

      exception
        when no_data_found then
             BEGIN
                  IF ln_pgcodCu is not null THEN --Para lineas consultar el cupo
                    begin
                        select distinct JAQL101Scl
                         into ln_sector
                          from jaql101 a
                         where a.jaql101pgc = ln_pgcodCu
                           and a.jaql101cta = ln_ScctaCu
                           and a.jaql101ope = ln_ScoperCu
                           and a.jaql101fch = (select max(j.jaql101fch)
                                                 from JAQL101 j
                                                where JAQL101Pgc = ln_pgcodCu
                                                  and JAQL101Cta = ln_ScctaCu
                                                  and JAQL101Ope = ln_ScoperCu
                                                  and j.jaql101fch>=last_day(add_months(pd_Fecha,-1))--ultimo cierre antes de fecha de proceso
                                                  and j.jaql101fch<=pd_Fecha
                                               )
                          AND a.jaql101cor = (SELECT MAX(jaql101cor)
                                                FROM jaql101 b
                                              WHERE b.jaql101suc = a.jaql101suc
                                                and b.jaql101mon = a.jaql101mon
                                                and b.jaql101pap = a.jaql101pap
                                                and b.jaql101cta = a.jaql101cta
                                                and b.jaql101ope = a.jaql101ope
                                                and b.jaql101sop = a.jaql101sop
                                                and b.jaql101top = a.jaql101top
                                                and b.jaql101mod = a.jaql101mod
                                                AND b.jaql101fch = a.jaql101fch
                                                )
                          and rownum=1;
                    exception
                      when others then
                          ln_sector := null;
                    end;
                  END IF;

                  IF  ln_sector is null THEN

                      begin
                        SELECT d10.aofval
                               into ld_aofval
                          FROM FSD010 d10
                         where d10.PGCOD  = 1
                           and d10.AOMOD  = pn_mod
                           and d10.AOSUC  = pn_suc
                           and d10.AOMDA  = pn_mda
                           and d10.AOPAP  = pn_pap
                           and d10.AOCTA  = pn_cta
                           and d10.AOOPER = pn_oper
                           and d10.AOSBOP = pn_sbop
                           and d10.AOTOPE = pn_top;
                      exception
                          when others then
                             ld_aofval:=null;
                      end;


                      begin
                        ln_instancia := fn_instancia_credito(pn_mod, pn_suc, pn_mda, pn_pap, pn_cta, pn_oper, pn_sbop, pn_top);
                      exception
                        when others then
                            ln_instancia := null;
                      end;

                      IF last_day(ld_aofval)=last_day(pd_Fecha) THEN --desembolso en el mes de proceso
                          begin
                               select trim(wv.WFAttSVal)
                                 into ln_sector
                                 from WFATTSVALUES wv
                                where WFINSPRCID = ln_instancia--v_instancia
                                  and WFAttSId   = 'SECTOR';
                          exception
                            when others then
                                 ln_sector := null;
                          end;
                      END IF;
                  END IF;
             END;
        when others then
             ln_sector := null;
       end;
    END IF;
       lc_tipcre := lc_tipcre||' '||to_char(ln_sector);
   end if;  
   return lc_tipcre;
end;

Function fn_Comite_Aprobador(PN_nroins in number , PN_MOD IN NUMBER ) return varchar2 is
lc_carapro varchar2(100);
begin
    begin 
     -- Con Excepcion
        select trim(H.SNG055DSC) 
          into lc_carapro
          from sng091 a, 
               sng065 e, 
               xwf700 g, 
               SNG055 H 
         where a.sng091aut = e.sng062aut
           and a.sng001inst = g.xwfprcins
           AND E.SNG065CAR = H.SNG055CAR
           and a.sng091res = 'A'
           and a.sng091tpo = 'P' --
           and a.sng001inst  = PN_nroins
           and e.sng065ord in (select max(sng065ord) from /*bantprod.*/sng065 where SNG062AUT	= e.SNG062AUT)
           and rownum = 1 ;	
    
    exception
       -- Sin Excepciones
       When no_data_found then 
          begin 
              select trim(H.SNG055DSC) 
              into lc_carapro
              from sng091 a, 
                   sng065 e, 
                   xwf700 g, 
                   SNG055 H 
             where a.sng091aut = e.sng062aut
               and a.sng001inst = g.xwfprcins
               AND E.SNG065CAR = H.SNG055CAR
               and a.sng091res = 'A'
               and a.sng091tpo = 'C' --
               and a.sng001inst  = PN_nroins
               and e.sng065ord in (select max(sng065ord) from /*bantprod.*/sng065 where SNG062AUT	= e.SNG062AUT)
               and rownum = 1
               ;	
          exception 
            when no_data_found then
                 IF PN_MOD = 108 THEN
                   lc_carapro := 'ANALISTA PRENDARIO';
                 ELSE     
                    lc_carapro := null;
                 END IF;  
          end;        
    end;
    return lc_carapro ;

end;

 /* Dimension Comite Aprobador
 select sng055dsc from SNG055;
 */
 
 
procedure sp_log(PFECPRO VARCHAR, ptipdoc NUMBER , pnumdoc varchar,  MERROR VARCHAR )

is 
  fec date;
begin 
-- ERROR :=   SUBSTR(SQLERRM,1,199);
       fec := to_date(PFECPRO,'rrrrmmdd');
--        insert into cosecha_E
        insert into JAQY646C
          (JAQY646CFEC,
           JAQY646CCCRE,
           JAQY646CMGE           
           )
        values
          (
           fec,
           pnumdoc,
            MERROR
          );            
          COMMIT;     

end;  
-----------------------------------///rmogrovejo//----------------------------
  
function  fn_campania_cred(p_n_modulo in number, 
                           p_n_suc in number,           
                           p_n_mda in number,                           
                           p_n_pap in number,
                           p_n_cta in number,                                                      
                           p_n_oper in number,
                           p_n_sbop in number,                                                      
                           p_n_tipope in number,
                           p_d_fecdes in date, --Fecha desembolso Real
                           p_c_flgtip in varchar --D=Desembolso  
                          
                           ) 
return varchar2
  is
    lc_codcam varchar2(20);
    lc_tipope varchar2(20);
    ln_sng014cod number(4);
    ln_sng015cod number(4);
    ln_nroins number(10);
    
    ln_cnt number(4);
    
    lc_valvar varchar2(200);
    
    ---
    ln_pgcod  number;
    ln_modulo number; 
    ln_suc    number;           
    ln_mda    number;                           
    ln_pap    number;
    ln_cta    number;                                                      
    ln_oper   number;
    ln_sbop   number;                                                      
    ln_tipope number;   
    ld_fecdes date; 
    
    lc_desdol varchar2(1); 
    
    cursor c_campanas is 
      select de.* 
        from jaqz968 ca
             inner join jaqz969 de
             on de.jaqz969cdcam = ca.jaqz968cdcam
       where ld_fecdes between ca.jaqz968fcini and ca.jaqz968fcfin;  
        
   /*  select de.* 
        from PAMCAMP@datanew ca
             inner join PADCAMP@datanew de
             on de.c_codcam = ca.c_codcam
       where ld_fecdes between ca.d_fecini and ca.d_fecfin;    */ 
    --cupo
    ln_modcup fsd010.aomod%type; 
    ln_succup fsd010.aosuc%type;
    ln_mdacup fsd010.aomda%type;
    ln_papcup fsd010.aopap%type;                        
    ln_ctacup fsd010.aocta%type;
    ln_opecup fsd010.aooper%type;
    ln_sbocup fsd010.aosbop%type;
    ln_topcup fsd010.aotope%type;
    ln_fvacup fsd010.aofval%type;
    ln_totcup fsd010.aoimp%type;
    
  begin
    
  if NVL(p_c_flgtip,'X')<>'D' then --Evaluacion cartera 
    null; --falta completar
  else --Evaluacion desembolso
    --Falta considerar los refinanciados y reprogramados que provienen de una campaña....
    ln_pgcod  := 1;
    ln_modulo := p_n_modulo; 
    ln_suc    := p_n_suc;           
    ln_mda    := p_n_mda;                           
    ln_pap    := p_n_pap;
    ln_cta    := p_n_cta;                                                      
    ln_oper   := p_n_oper;
    ln_sbop   := p_n_sbop;                                                      
    ln_tipope := p_n_tipope;   
    
    --Para lineas se debe considerar la fecha de desembolso del cupo
    if ln_modulo = 116 then
      begin
            PQ_CONSECHAS.sp_datos_cupo(
                                              ln_pgcod,ln_modulo,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tipope,p_d_fecdes,null,p_d_fecdes,      
                                              ln_modcup,ln_succup,ln_mdacup,ln_papcup,ln_ctacup,ln_opecup,ln_sbocup,ln_topcup,ln_fvacup,ln_totcup                                       
                                           ); 
            
            ld_fecdes := ln_fvacup;
                                           
      exception
        when others then
            ld_fecdes := null;
      end;   
      
      if ld_fecdes is null then
        ld_fecdes := p_d_fecdes;
      end if;
      
    else
       ld_fecdes := p_d_fecdes;  
    end if;    

  end if;
    
   -- dbms_output.put_line(ld_fecdes);
    
    lc_tipope:= ','||ln_tipope||',';     
    
    begin
        select count(*)
          into ln_cnt
         from jaqz968 ca
               inner join jaqz969 de
               on de.jaqz969cdcam = ca.jaqz968cdcam
       where ld_fecdes between ca.jaqz968fcini and ca.jaqz968fcfin
         and de.jaqz969varib is not null 
       ;
    /* select count(*)
          into ln_cnt
         from PAMCAMP@datanew ca
               inner join PADCAMP@datanew de
               on de.c_codcam = ca.c_codcam
       where ld_fecdes between ca.d_fecini and ca.d_fecfin
         and de.c_variable is not null 
       ;*/
    exception
          when no_data_found then
               ln_cnt := null;
    end;      
    
    if ln_cnt>0 then
      
      if ln_nroins is null then
        ln_nroins:=/*bantprod.*/fn_instancia_credito(ln_modulo,
                                                  ln_suc,
                                                  ln_mda,
                                                  ln_pap,
                                                  ln_cta,
                                                  ln_oper,
                                                  ln_sbop,
                                                  ln_tipope);      
      end if;
                                                          
      begin
          select sng014cod, sng015cod
            into ln_sng014cod, ln_sng015cod
           from  sng001
          where  sng001inst = ln_nroins;
      exception
            when no_data_found then
                 ln_sng014cod := null;
                 ln_sng015cod := null;
      end;    
                                                           
    end if;

  
    for x in c_campanas  loop
        case x.jaqz969tpcal 
          when '1' then --Por modulo 
            if x.jaqz969modul =ln_modulo  then 
              lc_codcam:=x.jaqz969cdcam;
            end if; 
          when '2' then --Por modulo y operacion
            if x.jaqz969modul /*x.modulo*/=ln_modulo and instr(x.jaqz969cdope,lc_tipope/* x.c_codope,lc_tipope*/)>0  then 
              lc_codcam:=x.jaqz969cdcam;
            end if;             
          when '3' then --Por modulo, operacion y variable
            if x.jaqz969varib ='PAE73POL' then 
                begin
                  select distinct PAE73POL
                         into lc_valvar
                    from fpae70 p70 
                         inner join fpae73 p73 
                          on p73.pae51eva=p70.pae51eva  
                         and p73.pae70nro=p70.pae70nro
                   where p70.pae70ins = ln_nroins 
                     and PAE73POL  = x.jaqz969valor;
                exception
                      when no_data_found then
                           lc_valvar := '0';
                end;       
            elsif x.jaqz969varib='SNG001ORI' then    
                begin
                  select distinct SNG001ORI
                         into lc_valvar
                    from sng001 g1
                   where g1.sng001inst = ln_nroins 
                     and SNG001ORI  = x.jaqz969valor;
                exception
                      when no_data_found then
                           lc_valvar := '0';
                end;                   
            end if;  
          
            if x.jaqz969modul=ln_modulo and instr(x.jaqz969cdope,lc_tipope)>0 and x.jaqz969varib='SNG014COD' and ln_sng014cod=x.jaqz969valor then 
              lc_codcam:=x.jaqz969cdcam;
            elsif x.jaqz969modul=ln_modulo and instr(x.jaqz969cdope,lc_tipope)>0 and x.jaqz969varib='PAE73POL' and lc_valvar=x.jaqz969valor then 
              lc_codcam:=x.jaqz969cdcam;
            elsif x.jaqz969modul=ln_modulo and instr(x.jaqz969cdope,lc_tipope)>0 and x.jaqz969varib='SNG001ORI' and lc_valvar=x.jaqz969valor then 
              lc_codcam:=x.jaqz969cdcam;
            end if;  
          when '6' then --Por modulo, operacion y variable diferente al valor
          
            if x.jaqz969varib='PAE73POL' then 
                begin
                  select distinct PAE73POL
                         into lc_valvar
                    from fpae70 p70 
                         inner join fpae73 p73 
                          on p73.pae51eva=p70.pae51eva  
                         and p73.pae70nro=p70.pae70nro
                   where p70.pae70ins = ln_nroins 
                     and PAE73POL  = x.jaqz969valor;
                exception
                      when no_data_found then
                           lc_valvar := '0';
                end;  
            elsif x.jaqz969varib='SNG001ORI' then    
                begin
                  select distinct SNG001ORI
                         into lc_valvar
                    from sng001 g1
                   where g1.sng001inst = ln_nroins 
                     and SNG001ORI  = x.jaqz969valor;
                exception
                      when no_data_found then
                           lc_valvar := '0';
                end;                   
            end if;  
            
            if x.jaqz969modul=ln_modulo and instr(x.jaqz969cdope,lc_tipope)>0 and x.jaqz969varib='PAE73POL' and lc_valvar='0' then 
              lc_codcam:=x.jaqz969cdcam;
            elsif x.jaqz969modul=ln_modulo and instr(x.jaqz969cdope,lc_tipope)>0 and x.jaqz969varib='SNG001ORI' and lc_valvar='0' then
              lc_codcam:=x.jaqz969cdcam;      
            end if;             
          when '4' then --Por modulo y variable
            if x.jaqz969modul=ln_modulo and x.jaqz969varib='SNG014COD' and ln_sng014cod=x.jaqz969valor then 
              lc_codcam:=x.jaqz969cdcam;
            end if;             
          when '5' then --Por funcion
            if x.jaqz969cdcam='A24' and ln_mda=0 then --Desdolarizacion
               lc_desdol:= PQ_CONSECHAS.fn_desdolarizacion(ln_modulo, 
                                                               ln_suc,           
                                                               ln_mda,                           
                                                               ln_pap,
                                                               ln_cta,                                                      
                                                               ln_oper,
                                                               ln_sbop,                                                      
                                                               ln_tipope
                                                               ); 
               if lc_desdol='S' then
                  lc_codcam:=x.jaqz969cdcam;  
               end if;                                                
            end if;
           else ---rms
             lc_codcam:= null;
        end case;                                   
    end loop;  
    
    
    
    Return lc_codcam;
      
end fn_campania_cred ; 
    
----------------------------------------------------------------------------------------
Procedure sp_datos_cupo(PN_PGCOD in number,
                        PN_CODMOD in number,
                        PN_CODSUC in number,                        
                        PN_CODMDA in number,
                        PN_CODPAP in number,
                        PN_CODCTA in number,
                        PN_CODOPE in number,
                        PN_CODSBO in number,
                        PN_CODTOP in number,
                        PD_FECVAL in date,
                        PN_AOIMP  in number,
                        PD_FECPRO in date,
                        --
                        PN_modcup Out number, 
                        PN_succup Out Number,
                        PN_mdacup Out Number,
                        PN_papcup Out Number,                        
                        PN_ctacup Out number,
                        PN_opecup Out number,
                        PN_sbocup Out Number,
                        PN_topcup Out Number,
                        PD_fvacup Out date,
                        PN_totcup Out Number
                       )
 Is 
  
  ln_r1cod fsr011.r1cod%type;
  ln_r1mod fsr011.r1mod%type;
  ln_r1suc fsr011.r1suc%type;
  ln_r1mda fsr011.r1mda%type;
  ln_r1pap fsr011.r1pap%type;
  ln_r1cta fsr011.r1cta%type;
  ln_r1ope fsr011.r1oper%type;
  ln_r1sbo fsr011.r1sbop%type;
  ln_r1top fsr011.r1tope%type;
  
  lc_indfca varchar2(1);
  --
  
Begin
  

  if PN_CODMOD in (200,33,65) or PN_CODTOP=550 then
    --obtener la clave de credito original
    begin
          PQ_CONSECHAS.sp_credito_original(
                                                  PN_PGCOD,PN_CODMOD,PN_CODSUC,PN_CODMDA,PN_CODPAP,PN_CODCTA,PN_CODOPE,PN_CODSBO,PN_CODTOP,      
                                                  ln_r1cod, ln_r1mod, ln_r1suc, ln_r1mda,ln_r1pap, ln_r1cta,  ln_r1ope,  ln_r1sbo,  ln_r1top                                       
                                               );   
    exception
      when others then
          ln_r1mod  := null;
    end;   
    
  end if;  

  if ln_r1mod is null then 
    ln_r1cod := PN_PGCOD ;
    ln_r1mod := PN_CODMOD;
    ln_r1suc := PN_CODSUC;
    ln_r1mda := PN_CODMDA;
    ln_r1pap := PN_CODPAP;
    ln_r1cta := PN_CODCTA;
    ln_r1ope := PN_CODOPE;
    ln_r1sbo := PN_CODSBO;
    ln_r1top := PN_CODTOP;    
  end if;    
  
  begin
    select distinct 'S'
           into lc_indfca
      from fsr011
     where relcod = 47 
       and r1cta = PN_CODCTA 
       and r1oper = PN_CODOPE;
  exception
        when no_data_found then
             lc_indfca := null;
  end;      
  
  If nvl(ln_r1mod,0) <> 116 and NVL(lc_indfca,'N')<>'S'  Then
    ln_r1mod  := null;  
  End If;        
  
  If ln_r1mod is not null Then
      
  Begin
      Select r2mod, r2suc, r2mda, r2pap, r2cta, r2oper,r2sbop,r2tope, aofval, aoimp
        Into PN_modcup,PN_succup,PN_mdacup,PN_papcup,PN_ctacup,PN_opecup,PN_sbocup,PN_topcup,PD_fvacup,PN_totcup
        From(  
            select r11.r2oper, r11.r2cta,r11.r2sbop,r11.r2mda,r11.r2pap,r11.r2tope,r11.r2mod, r11.r2suc,d10.aofval, d10.aoimp
              from fsr011 r11
              join fsd010 d10 on d10.pgcod = r11.r2cod
                             and d10.aomod = r11.r2mod
                             and d10.aomda = r11.r2mda
                             and d10.aopap = r11.r2pap
                             and d10.aocta = r11.r2cta
                             and d10.aooper= r11.r2oper
                             and d10.aosbop= r11.r2sbop
                             and d10.aotope= r11.r2tope 
             where r11.r1cod =ln_r1cod
               and r11.r1mod =ln_r1mod
               and r11.r1mda =ln_r1mda
               and r11.r1pap =ln_r1pap
               and r11.r1cta =ln_r1cta
               and r11.r1oper=ln_r1ope
               and r11.r1sbop=ln_r1sbo
               and r11.r1tope=ln_r1top
               and r11.relcod in (46,47)
               and r11.r011co= 'S'
               and d10.aofval <= PD_FECVAL
               and d10.aofval <= PD_FECPRO
               Order by d10.aofval desc
             ) 
       Where rownum = 1;
  Exception When Others Then
       Begin
          Select r2mod, r2suc, r2mda, r2pap, r2cta, r2oper,r2sbop,r2tope, aofval, aoimp
            Into PN_modcup,PN_succup,PN_mdacup,PN_papcup,PN_ctacup,PN_opecup,PN_sbocup,PN_topcup,PD_fvacup,PN_totcup
            From(  
                select r11.r2oper, r11.r2cta,r11.r2sbop,r11.r2mda,r11.r2pap,r11.r2tope,r11.r2mod, r11.r2suc,d10.aofval, d10.aoimp
                  from fsr011 r11
                  join fsd010 d10 
                                 on d10.pgcod  = r11.r2cod
                                 and d10.aomod = r11.r2mod
                                 and d10.aomda = r11.r2mda
                                 and d10.aopap = r11.r2pap
                                 and d10.aocta = r11.r2cta
                                 and d10.aooper= r11.r2oper
                                 and d10.aosbop= r11.r2sbop
                                 and d10.aotope= r11.r2tope
                 where r11.r1cod =ln_r1cod
                   and r11.r1mod =ln_r1mod
                   and r11.r1mda =ln_r1mda
                   and r11.r1pap =ln_r1pap
                   and r11.r1cta =ln_r1cta
                   and r11.r1oper=ln_r1ope
                   and r11.r1sbop=ln_r1sbo
                   and r11.r1tope=ln_r1top
                   and r11.relcod in (46,47)
                   and r11.r011co= 'S'
                   and d10.aofval <= PD_FECPRO
                   Order by d10.aofval desc
                 ) 
           Where rownum = 1;
           
       Exception When Others Then
            null; 
       End;  
  End ;
  End If;
  
  /*If PN_opecup is null Then
     PN_totcup := PN_AOIMP;
  End If;*/   
      
End sp_datos_cupo;  
 ------------------------------------------------------
 function  fn_desdolarizacion(p_n_modulo in number, 
                             p_n_suc in number,           
                             p_n_mda in number,                           
                             p_n_pap in number,
                             p_n_cta in number,                                                      
                             p_n_oper in number,
                             p_n_sbop in number,                                                      
                             p_n_tipope in number  
                             ) 
                             return varchar2
is
   lc_desdol varchar2(1);                          
   
   lv_PGCOD  fsh016.pgcod%type;
   lv_HCMOD  fsh016.HCMOD%type;
   lv_HSUCOR fsh016.HSUCOR%type;
   lv_HTRAN  fsh016.HTRAN%type;
   lv_HNREL  fsh016.HNREL%type;
   lv_hfcon  fsh016.hfcon%type;
   lv_hcta   fsh016.hcta%type;
   lv_hsucur fsh016.hsucur%type;
   lv_hmodul fsh016.hmodul%type;
   lv_hcimp1 fsh016.hcimp1%type;
    
begin
  
      begin
          ---credito nuevo en soles   
          select 
                h16.PGCOD,h16.HCMOD,h16.HSUCOR,h16.HTRAN,h16.HNREL,h16.hfcon,h16.hcta,h16.hsucur,h16.hmodul, h16.hcimp1     
                into lv_PGCOD,lv_HCMOD,lv_HSUCOR,lv_HTRAN,lv_HNREL,lv_hfcon,lv_hcta,lv_hsucur,lv_hmodul,lv_hcimp1
          from fsh015 h15 join fsh016 h16 on h16.pgcod = h15.pgcod
                                         and h16.hcmod = h15.hcmod
                                         and h16.hsucor= h15.hsucor
                                         and h16.htran = h15.htran
                                         and h16.hnrel = h15.hnrel
                                         and h16.hfcon = h15.hfcon
                                         and substr(h16.hrubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426)
                                         and h16.hfvco = h15.hfcon
          where h15.pgcod = 1
           and h15.hccorr <> 99
           and (
                (h15.hcmod =  30 and h15.htran in (360,951))
               )
           and h16.hcodmo = 1
           and h16.hmda = 0
           and h16.pgcod  = 1
           and h16.hsucur = p_n_suc
           and h16.hcta   = p_n_cta
           and h16.hoper  = p_n_oper
           and h16.hsubop = p_n_sbop
           and h16.hmodul = p_n_modulo
           and h16.htoper = p_n_tipope
           and h16.hmda   = p_n_mda
           and h16.hpap   = p_n_pap

           ;
        Exception When Others Then
           null; 
      end;       
      
      if lv_PGCOD is not null then
          --credito en dolares cancelado (ampliacion)
          begin
              SELECT distinct 'S'
                     into lc_desdol
                From fsh015 h15 join fsh016 h16  on h15.pgcod = h16.pgcod
                                                and h15.hcmod = h16.hcmod
                                                and h15.hsucor= h16.hsucor
                                                and h15.htran = h16.htran
                                                and h15.hnrel = h16.hnrel
                                                and h15.hfcon = h16.hfcon                                   
               where h15.pgcod = 1
                 and (h15.hcmod = 30 and h15.htran = 360)
                 and h15.hfcon = lv_hfcon
                 and h16.hmodul in (select modulo from fst111 where dscod = 50 and modulo not in (29,120,144,33,108))
                 and h15.hccorr <> 99
                 and h16.hcodmo = 2
                 and h16.hmda = 101
                 and h16.pgcod  = lv_PGCOD
                 and h16.HCMOD  = lv_HCMOD
                 and h16.HSUCOR = lv_HSUCOR
                 and h16.HTRAN  = lv_HTRAN
                 and h16.HNREL  = lv_HNREL
                 and h16.hfcon  = lv_hfcon
                 and lv_hcimp1 - (h16.hcimp1*fn_tipo_cambio_fijo(h16.hfcon))<5000;
           
            Exception 
              When no_data_found Then
                  --credito en dolares cancelado (cancelacion total)
                  begin
                      SELECT distinct 'S'
                             into lc_desdol
                        From fsh015 h15 join fsh016 h16  on h15.pgcod = h16.pgcod
                                                        and h15.hcmod = h16.hcmod
                                                        and h15.hsucor= h16.hsucor
                                                        and h15.htran = h16.htran
                                                        and h15.hnrel = h16.hnrel
                                                        and h15.hfcon = h16.hfcon                                   
                       where h15.pgcod = 1
                         and (h15.hcmod  = 30 and h15.htran   in (150))
                         and h15.hfcon = lv_hfcon  
                         and h16.hmodul in (select modulo from fst111 where dscod = 50 and modulo not in (29,120,144,33,108))
                         and h15.hccorr <> 99
                         and h16.hcodmo = 2
                         and h16.hmda = 101
                         and h16.pgcod  = lv_PGCOD
                         and h16.hfcon  = lv_hfcon
                         and h16.hcta   = lv_hcta  
                         and h16.hsucur = lv_hsucur
                         and h16.hmodul = lv_hmodul;
                    Exception When Others Then
                       null;         
                  end;          
              When Others Then
               null;         
          end;
          
      end if;
      
  Return NVL(lc_desdol,'N');
      
end fn_desdolarizacion ;

----------------------------------------------------------
 procedure sp_credito_original(
                                 v_pgcod   in number,
                                 v_Scmod   in number,
                                 v_Scsuc   in number,
                                 v_Scmda   in number,
                                 v_Scpap   in number,
                                 v_Sccta   in number,
                                 v_Scoper  in number,
                                 v_Scsbop  in number,
                                 v_Sctope  in number,
                                 ---retorno
                                lv_bcemp  out fsh012.bcemp%type,
                                lv_bcmod  out fsh012.bcmod%type,
                                lv_bcsuc  out fsh012.bcsuc%type,
                                lv_bcmda  out fsh012.bcmda%type,
                                lv_bcpap  out fsh012.bcpap%type,
                                lv_bccta  out fsh012.bccta%type,
                                lv_bcoper out fsh012.bcoper%type,
                                lv_bcsbop out fsh012.bcsbop%type,
                                lv_bctop  out fsh012.bctop%type                                
                              ) 
  is
  --retorna el credito original para un judicial y prejudicial  

    
  begin

      --para creditos judiciales encontrar modulo inicial
      if v_Scmod in (200,33,65) or v_Sctope=550 then  --judiciales, prejudicial, castigados, venta de cartera
        begin  
          select r011.r1cod, r011.r1mod,r011.r1suc ,r011.r1mda ,r011.r1pap ,r011.r1cta ,r011.r1oper,r011.r1sbop,r011.r1tope
             into lv_bcemp, lv_bcmod,lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta, lv_bcoper, lv_bcsbop, lv_bctop     
            from  
                  (         
                    SELECT r011.r1cod, r011.r1mod,r011.r1suc ,r011.r1mda ,r011.r1pap ,r011.r1cta ,r011.r1oper,r011.r1sbop,r011.r1tope,
                           (case 
                                when  r011.r1tope=550 then 2 
                                else 1      
                           end)orden                    
                    FROM fsr011 r011
                         inner join fsd010 d10
                          on d10.pgcod = r011.r1cod
                         and d10.AOMOD = r011.r1mod  
                         --and d10.AOSUC = r011.r1suc
                         and d10.AOMDA = r011.r1mda
                         and d10.AOPAP = r011.r1pap
                         and d10.AOCTA = r011.r1cta
                         and d10.AOOPER= r011.r1oper
                         and d10.AOSBOP= r011.r1sbop
                         and d10.AOTOPE= r011.r1tope
                    WHERE 
                             r011.relcod = 52
                         and r011.r2cod  = v_pgcod
                         and r011.r2mod  = v_Scmod
                         --and r011.r2suc  = v_Scsuc
                         and r011.r2mda  = v_Scmda
                         and r011.r2pap  = v_Scpap
                         and r011.r2cta  = v_Sccta
                         and r011.r2oper = v_Scoper
                         and r011.r2sbop = v_Scsbop
                         and r011.r2tope = v_Sctope
                         and r011.r011co= 'S'
                    order by orden, r011.r1sbop                         
                  )r011
            where rownum = 1;
        exception
          when others then
              null;
         end;  
      end if;           
                           
  end sp_credito_original;  



end PQ_CONSECHAS;
/

