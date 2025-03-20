create or replace package PQ_DATOS_CREDITO is

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_sector_creditoxinst(
                                 v_fecpro in date,
                                 v_pgcod  in number,
                                 v_Scmod  in number,
                                 v_Scsuc  in number,
                                 v_Scmda  in number,
                                 v_Scpap  in number,
                                 v_Sccta  in number,
                                 v_Scoper in number,
                                 v_Scsbop in number,
                                 v_Sctope in number,
                                 v_instancia in number
                               ) return number;
                               
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_monto_cuota (p_pgcod in number,
                         p_scsus in number,
                         p_scmod in number,
                         p_scmda in number,
                         p_scpap in number,
                         p_sccta in number,
                         p_scope in number,
                         p_scsbo in number,
                         p_sctop in number,
                         p_instancia in number
                         ) return number;     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_dias_gracia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number )return number;                                                   

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_prom_dias_atraso_ranfec(v_Pgfape in date, --fecha de proceso
                                    v_fecini in date,            
                                     v_Pgcod  in number,
                                     v_Scmod  in number,
                                     v_Scsuc  in number,
                                     v_Scmda  in number,
                                     v_Scpap  in number,
                                     v_Sccta  in number,
                                     v_Scoper in number,
                                     v_Scsbop in number,
                                     v_Sctope in number
                                   ) return number;  
                                   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_producto_regcaja(
                             d_fecpro  in date,
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in fsh012.bcrubr%type,
                             v_pepais  in fsd001.pepais%type,
                             v_petdoc  in fsd001.petdoc%type,
                             v_pendoc  in fsd001.pendoc%type,                                                          
                             v_anioseg in number, --año de ultima segmentacion de cliente menor a fecha de proceso
                             v_messeg  in number  --mes de ultima segmentacion de cliente menor a fecha de proceso
                             ) return varchar2;
                             
-- -- -- -- -- -- -- -- -- 
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
                              )  ;   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_ind_banco_nacion(            
                               v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number
                             ) return number;                                                        

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_age_banco_nacion(            
                               v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               ln_xwfprcins  in xwf700.xwfprcins%type
                             ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_institucion_conv(            
                               v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               ---original
                               v_Pgcod_ori  in number,
                               v_Scmod_ori  in number,
                               v_Scsuc_ori  in number,
                               v_Scmda_ori  in number,
                               v_Scpap_ori  in number,
                               v_Sccta_ori  in number,
                               v_Scoper_ori in number,
                               v_Scsbop_ori in number,
                               v_Sctope_ori in number
                             ) return number;
                             
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_nro_credito_desem(--lc_pepais fsr008.pepais%type,
                               --lc_petdoc fsr008.petdoc%type,            
                               lc_pendoc fsr008.pendoc%type,           
                               ld_fecini date,
                               ld_fecfin date              
                               )return number;   
                               
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_nro_credito_desem( lc_pepais fsr008.pepais%type,
                               lc_petdoc fsr008.petdoc%type,            
                               lc_pendoc fsr008.pendoc%type,           
                               ld_fecini date,
                               ld_fecfin date              
                               )return number; 
                               
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_min_fecdes(--lc_pepais fsr008.pepais%type,
                       --lc_petdoc fsr008.petdoc%type,            
                       lc_pendoc fsr008.pendoc%type,           
                       ld_fecini date,
                       ld_fecfin date              
                       )return date;
                       
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_tipsol_original (
                                 v_pgcod  in fsd010.pgcod%type,
                                 v_aomod  in fsd010.aomod%type,
                                 v_aosuc  in fsd010.aosuc%type,
                                 v_aomda  in fsd010.aomda%type,
                                 v_aopap  in fsd010.aopap%type,
                                 v_aocta  in fsd010.aocta%type,
                                 v_aooper in fsd010.aooper%type,
                                 v_aosbop in fsd010.aosbop%type,
                                 v_aotope in fsd010.aotope%type,
                                 ln_xwfprcins  in xwf700.xwfprcins%type                                
                               ) return number;    
                               
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_destino_credito(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in fsh012.bcrubr%type
                             ) return varchar2;    
                             
-- -- -- -- -- -- -- -- -- 
  procedure sp_credito_actual(
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
                              ) ;  
                              
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_prom_dias_atraso_ultcuo(v_Pgfape in date, --fecha de proceso
                                    v_cntcuo in number,            
                                    v_Pgcod  in number,
                                    v_Scmod  in number,
                                    v_Scsuc  in number,
                                    v_Scmda  in number,
                                    v_Scpap  in number,
                                    v_Sccta  in number,
                                    v_Scoper in number,
                                    v_Scsbop in number,
                                    v_Sctope in number
                                   ) return number;    
                                   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_ultimo_analista(
                              --P_PAIS in number,
                              --P_TDOC in number,
                              P_NDOC in char,  
                              ---retorno
                              lv_codase out char,
                              lv_codsuc out number
                              ) ;   
                              
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_ultimo_analistaxage(
                                  P_PAIS in number,
                                  P_TDOC in number,
                                  P_NDOC in char,  
                                  P_SUC  in number,
                                  ---retorno
                                  lv_codase out char,
                                  lv_codsuc out number
                                  ) ;
                                  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_garantias_cred (
                                 v_pgcod  in fsd010.pgcod%type,
                                 v_aomod  in fsd010.aomod%type,
                                 v_aosuc  in fsd010.aosuc%type,
                                 v_aomda  in fsd010.aomda%type,
                                 v_aopap  in fsd010.aopap%type,
                                 v_aocta  in fsd010.aocta%type,
                                 v_aooper in fsd010.aooper%type,
                                 v_aosbop in fsd010.aosbop%type,
                                 v_aotope in fsd010.aotope%type                                
                               ) return varchar2;                                                                                                                                                                                                                                                                                         
                                                                                      
end PQ_DATOS_CREDITO;
/

create or replace package body PQ_DATOS_CREDITO is
--dcastro 2021.02.23 se modifico fn_ind_banco_nacion
--rmontes 2021.03.08 se agrego rubro 0303 en linea 332
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_sector_creditoxinst(
                                 v_fecpro in date,
                                 v_pgcod  in number,
                                 v_Scmod  in number,
                                 v_Scsuc  in number,
                                 v_Scmda  in number,
                                 v_Scpap  in number,
                                 v_Sccta  in number,
                                 v_Scoper in number,
                                 v_Scsbop in number,
                                 v_Sctope in number,
                                 v_instancia in number
                               ) return number is

    ln_sector jaql101.jaql101scl%type;
  begin

  begin  
            select   JAQL101Scl
                     into ln_sector
            from
            (
                  select   JAQL101Scl

                    from   JAQL101
                   where   JAQL101Pgc =  v_pgcod
                       and JAQL101Mod =  v_Scmod
                       and JAQL101Suc =  v_Scsuc
                       and JAQL101Mon =  v_Scmda
                       and JAQL101Pap =  v_Scpap
                       and JAQL101Cta =  v_Sccta
                       and JAQL101Ope =  v_Scoper
                       and JAQL101Sop =  v_Scsbop
                       and JAQL101Top =  v_Sctope
                       and JAQL101Fch <= v_fecpro
                order by JAQL101Fch desc, JAQL101COR desc
            ) where rownum = 1;
  exception
    when no_data_found then
        begin
          
         select
                trim(wv.WFAttSVal)
               into ln_sector
         from wfattsvalues wv
         where
              WFINSPRCID = v_instancia
          and WFAttSId   = 'SECTOR';
        exception     
        when others then
             ln_sector := null;
        end;
   end;     
  
  return NVL(ln_sector,0);

end fn_sector_creditoxinst;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_monto_cuota (p_pgcod in number,
                         p_scsus in number,
                         p_scmod in number,
                         p_scmda in number,
                         p_scpap in number,
                         p_sccta in number,
                         p_scope in number,
                         p_scsbo in number,
                         p_sctop in number,
                         p_instancia in number
                         ) return number
is
  ln_mtocuo sng001.sng01icuot%type;
begin
    

   If p_scmod = 108 Then
   Begin 
      Select sum(j.ppcap+j.ppint)
        Into ln_mtocuo
        from fsd601 j
       where j.pgcod = p_pgcod
         And j.ppmod = p_scmod
         And j.ppsuc = p_scsus
         And j.ppmda = p_scmda
         And j.pppap = p_scpap
         And j.ppcta = p_sccta
         And j.ppoper= p_scope
         And j.ppsbop= p_scsbo
         And j.pptope= p_sctop
         And j.d601co='S';  
      Exception when others then
                ln_mtocuo := null;
      End;  
   else
      begin
           Select h.sng01icuot
             Into ln_mtocuo
             From sng001 h 
            Where h.sng001inst = p_instancia;
      exception when others then
                ln_mtocuo := null;
      end;
   End If;
   
    Return ln_mtocuo;
end fn_monto_cuota;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_dias_gracia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number is
  ln_diagra number;
  begin
    begin
      if pn_TOP = 550 or pn_mod in (200,33) then
         ln_diagra:= 0;
      else
         select ((select min(n.ppfpag)
                    from fsd601 n
                   where m.xllaocta  = n.ppcta
                     and m.xllaooper = n.ppoper
                     and m.xllaosbop = n.ppsbop
                     and m.xllaotop  = n.pptope
                     and m.xllaomod  = n.ppmod
                     and m.xllaosuc  = n.ppsuc
                     and m.xllaomda  = n.ppmda
                     and m.xllaopap  = n.pppap)-m.xllfvalor)-m.xllperiodo
           into ln_diagra
           from X054023 m
          where m.xllpgcod  = pn_emp
            and m.xllaocta  = pn_cta
            and m.xllaooper = pn_oper
            and m.xllaosbop = pn_sbop
            and m.xllaotop  = pn_top
            and m.xllaomod  = pn_mod
            and m.xllaosuc  = pn_suc
            and m.xllaomda  = pn_mda
            and m.xllaopap  = pn_pap;
       end if;
    exception
        when no_data_found then
           ln_diagra := null;
        when too_many_rows then
           ln_diagra := null;
    end;
     return ln_diagra;
  end fn_dias_gracia;      
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_prom_dias_atraso_ranfec(v_Pgfape in date, --fecha de proceso
                                    v_fecini in date,            
                                     v_Pgcod  in number,
                                     v_Scmod  in number,
                                     v_Scsuc  in number,
                                     v_Scmda  in number,
                                     v_Scpap  in number,
                                     v_Sccta  in number,
                                     v_Scoper in number,
                                     v_Scsbop in number,
                                     v_Sctope in number
                                   ) return number is

    ln_diaatr number(5);
    ln_cntcuo number(5);
    ln_proatr number(10,2);
    
  begin
        begin
          --vigente y refinanciado
          Select Sum(Case When nvl(b.pp1fech,v_Pgfape) - a.ppfpag > 0 
                          Then nvl(b.pp1fech,v_Pgfape) - a.ppfpag
                          Else 0
                     End),
                 count(*) 
            Into ln_diaatr,
                 ln_cntcuo           
            From FSD601 a left join FSD602 b on b.Pgcod  = a.Pgcod
                                          and b.Ppmod  = a.Ppmod
                                          and b.Ppsuc  = a.Ppsuc
                                          and b.Ppmda  = a.Ppmda
                                          and b.Pppap  = a.Pppap
                                          and b.Ppcta  = a.Ppcta
                                          and b.Ppoper = a.Ppoper
                                          and b.Ppsbop = a.Ppsbop
                                          and b.Pptope = a.Pptope
                                          and b.Ppfpag = a.Ppfpag
                                          and b.Pptipo = a.Pptipo
                                          and b.Pp1stat = 'T'
                                          and b.D602co  = 'S'
                                          and b.pp1fech <= v_Pgfape
          where a.Pgcod  = v_Pgcod
            and a.Ppmod  = v_Scmod
            and a.Ppsuc  = v_Scsuc
            and a.Ppmda  = v_Scmda
            and a.Pppap  = v_Scpap
            and a.Ppcta  = v_Sccta
            and a.Ppoper = v_Scoper
            and a.Ppsbop = v_Scsbop
            and a.Pptope = v_Sctope
            and a.Ppfpag >= v_fecini
            and a.Ppfpag <= v_Pgfape
            and a.D601co = 'S'
            and (a.ppcap + a.ppint ) > 0;
            
      exception when others then
                ln_proatr := null;
      end;
      
      /*
      If NVL(ln_cntcuo,0) <> 0 Then
         ln_proatr := round(ln_diaatr/ln_cntcuo,2);
      Else 
         ln_proatr := 0;
      End If;   
      */
      
      If ln_cntcuo is not null and NVL(ln_cntcuo,0) <> 0 Then
         ln_proatr := round(ln_diaatr/ln_cntcuo,2);
      End If; 
          
      Return ln_proatr;
      
end fn_prom_dias_atraso_ranfec;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_producto_regcaja(
                             d_fecpro  in date,
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in fsh012.bcrubr%type,
                             v_pepais  in fsd001.pepais%type,
                             v_petdoc  in fsd001.petdoc%type,
                             v_pendoc  in fsd001.pendoc%type,                                                          
                             v_anioseg in number, --año de ultima segmentacion de cliente menor a fecha de proceso
                             v_messeg  in number  --mes de ultima segmentacion de cliente menor a fecha de proceso
                             ) return varchar2 is
                             
    lc_mdnom  fst003.mdnom%type;
    lc_tonom  fst004.tonom%type;
    
    lv_bcemp  fsh012.bcemp%type;
    lv_bcmod  fsh012.bcmod%type;
    lv_bcsuc  fsh012.bcsuc%type;
    lv_bcmda  fsh012.bcmda%type;
    lv_bcpap  fsh012.bcpap%type;
    lv_bccta  fsh012.bccta%type;
    lv_bcoper fsh012.bcoper%type;
    lv_bcsbop fsh012.bcsbop%type;
    lv_bctop  fsh012.bctop%type;
    
    lc_inconv  varchar2(1); --indicador de convenio
    
    lc_segcli jaqy067.jaqy067ncal%type;
    lc_indtra fsd002.pfebco%type;
    
    lc_producto varchar2(500);
    
    ln_instconv number;
     
  begin
    
    if v_Scmod in (200,33) or v_Sctope=550 then
      --obtener la clave de credito original
      begin
            pq_datos_credito.sp_credito_original(
                                                    v_pgcod,v_Scmod,v_Scsuc,v_Scmda,v_Scpap,v_Sccta,v_Scoper,v_Scsbop,v_Sctope,      
                                                    lv_bcemp, lv_bcmod, lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta,  lv_bcoper,  lv_bcsbop,  lv_bctop                                       
                                                  );   
      exception
        when others then
            null;
      end;     
    end if;
                                                  
    
    if lv_bcmod is null then 
      lv_bcemp  := v_pgcod ;
      lv_bcmod  := v_Scmod ;
      lv_bcsuc  := v_Scsuc ;
      lv_bcmda  := v_Scmda ;
      lv_bcpap  := v_Scpap ;
      lv_bccta  := v_Sccta ;
      lv_bcoper := v_Scoper;
      lv_bcsbop := v_Scsbop;
      lv_bctop  := v_Sctope;    
    end if;

  --verificar si es convenio
  --1. Buscar si esta asociado a un convenio  
/*
    begin
      ln_instconv:= fn_institucion_conv(
                                      v_pgcod,v_Scmod,v_Scsuc,v_Scmda,v_Scpap,v_Sccta,v_Scoper,v_Scsbop,v_Sctope,      
                                      lv_bcemp, lv_bcmod, lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta,  lv_bcoper,  lv_bcsbop,  lv_bctop                                       
                                    );   
    
      lc_inconv:= (case when ln_instconv is not null then 'S' else 'N' end);   
    exception
      when others then
          null;
    end;
      */
    begin
      select count(*)
             into ln_instconv 
        from fpp102 det
       where det.pp102hab = 'S'
         and det.pp102cta = v_Sccta
         and det.pp102ope = v_Scoper;      
    exception
      when others then
          ln_instconv:=null;
    end;  
    
    lc_inconv:= (case when nvl(ln_instconv,0)>0 then 'S' else 'N' end);
   --2. Buscar por cuenta contable
    if lc_inconv is null then
       lc_inconv:= 
                  (case 
                       when substr(v_Rubro,7,4) in ('0602','0605','1906') and  substr(v_Rubro,12,2) in ('11','14') then 'S'
                       when substr(v_Rubro,5,9)='030605017' or substr(v_Rubro,5,9)='030305017' then 'S' --se agrego rubro 0303
                       else 'N'                                        
                  end);       
    end if;   
 
  --obtener descripcion de modulo 
  begin  
    select upper(mdnom)
      into lc_mdnom
      from fst003
      where modulo = lv_bcmod;
  exception
    when others then
        lc_mdnom := null;
  end;  
       
  --obtener descripcion de operacion
  begin  
    select upper(tonom)
      into lc_tonom
      from fst004
      where modulo = lv_bcmod
        and totope = lv_bctop;
  exception
    when others then
        lc_tonom := null;
  end; 

  
  --obtener calificacion mes anterior
  begin  
    select jaqy067ncal
      into lc_segcli
      from  
           jaqy066 cc
           left join jaqy067 dc
           on dc.jaqy067ccal = cc.jaqy066calf
      where              
             cc.jaqy066paic  = v_pepais
         and cc.jaqy066tdoc  = v_petdoc
         and cc.jaqy066tndoc = v_pendoc
         and cc.jaqy066pano  = v_anioseg 
         and cc.jaqy066pmes  = v_messeg;
  exception
    when others then
        lc_segcli := null;
  end;
    
  --obtener si es trabajador de la caja
  begin  
      select pfebco 
        into lc_indtra
        from fsd002 
       where       
             pfpais = v_pepais
         and pftdoc = v_petdoc
         and pfndoc = v_pendoc;
  exception
    when others then
        lc_indtra := null;
  end;  
  
     
  --obtener producto
    lc_producto:=
       CASE
         WHEN lv_bcmod = 141 then 'CARTA FIANZA'
         WHEN lv_bcmod in (116,117) and (lc_tonom like '%DPF%' or lc_tonom like '%CTS%') then 'LINEA DE CREDITO CON DEPOSITO A PLAZO FIJO O DEPOSITO CTS'
         WHEN lv_bcmod in (116,117) and lc_tonom like '%PR%F%' and lc_segcli like '%PREF%' then 'LINEA DE CREDITO PARA CLIENTE PREFERENCIAL'
         WHEN lv_bcmod in (116,117) then 'LINEA DE CREDITO'
         WHEN lc_tonom like '%MICROPYME%' and lc_tonom not like '%MICR%PUNT%' then 'MICROPYMES'  
         WHEN lc_tonom like '%MICR%PUNT%' then 'MICROPYMES PUNTUALITO'
         WHEN lc_tonom like '%MUJER%' then 'SUPERATE MUJER'  
         WHEN lc_tonom like '%PECUARIO%' and lc_tonom not like '%AGRO%' then 'PECUARIO'
         --WHEN lc_tonom like '%AGRI%' or lc_tonom like '%AGRÍ%' or lc_tonom like '%ARR%' or lc_tonom like '%PAPA%' then 'AGRÍCOLA' --2015.03.24 Se agrego papa y arroz 
         WHEN lc_tonom like '%AGRI%' or lc_tonom like '%AGRÍ%' or lc_tonom like '%ARR%' or lc_tonom like '%PAPA%' 
              or (lv_bcmod = 104 and lv_bctop in (160,161,162,165,166,167))
           then 'AGRÍCOLA' --2015.09.22 Se agrego papa y arroz, y monocultivos   
         WHEN lc_tonom like '%GANADERO%' then 'GANADERO'           
         WHEN lc_tonom like '%AGROPECUARIO%' then 'AGROPECUARIO'
         WHEN lc_tonom like '%COSECHANDO%' then 'COSECHANDO'  
         WHEN lc_tonom like '%MICROCONSUMO%' then 'MICROCONSUMO'
         WHEN lc_tonom like '%CAJA%CONSTRU%' then 'CAJACONSTRUYE'
         WHEN lv_bcmod = 112 and lv_bctop =40 then 'MOVITAXI'             
         WHEN ((lv_bcmod = 112 ) or lc_tonom like '%VEHICULAR%') and lc_indtra= 'S'  then 'VEHICULAR PARA TRABAJADORES CAJA AREQUIPA'  --agregar cualquiera con descripcion vehicular         
         WHEN ((lv_bcmod = 112 ) or lc_tonom like '%VEHICULAR%') then 'VEHICULAR'--agregar cualquiera con descripcion vehicular
         WHEN lc_tonom like '%CRE%OF%' then 'CREDIOFICIOS' --Crediofcios
         WHEN lv_bcmod = 113 then 'MOVIGAS'    
         WHEN lv_bcmod = 103 and lv_bctop =40 then 'MI BAÑO'           
         WHEN (lv_bcmod = 105 or lc_tonom like '%PARALELO%') then 'PARALELO' --Sr. Uberlando dice que esto es capital de trabajo
         WHEN lv_bcmod = 108 then 'PRENDARIO'
         WHEN lc_tonom like '%ADMINISTRATIVO%' then 'ADMINISTRATIVO'
         WHEN lc_tonom like 'CRE%LUZ%' then 'CREDILUZ'  
         WHEN lv_bcmod = 107 or (lc_inconv='S' and substr(v_Rubro,5,2)='03') then 'CONVENIO CON DESCUENTO POR PLANILLA'  --incluye judiciales
         WHEN (substr(v_Rubro,5,2)='03' or lv_bcmod = 106) and lc_indtra= 'S' then 'PERSONAL DIRECTO PARA TRABAJADORES'  
         WHEN substr(v_Rubro,5,2)='03' or lv_bcmod = 106 then 'PERSONAL DIRECTO'
         WHEN lc_tonom like '%MI%VIVIENDA%' then 'MI VIVIENDA' 
         WHEN lc_tonom like '%TECHO%PROPIO%' then 'TECHO PROPIO' 
         WHEN (substr(v_Rubro,5,2)='04' or lc_tonom like '%HIPOTECARIO%')and lc_indtra= 'S' then 'HIPOTECARIO PARA TRABAJADORES'    --agregar cualquiera con descripcion hipotecario
         WHEN substr(v_Rubro,5,2)='04' or lc_tonom like '%HIPOTECARIO%' then 'HIPOTECARIO PARA CLIENTES' --agregar cualquiera con descripcion hipotecario
         WHEN lv_bcmod = 109 or ( substr(v_Rubro,5,2) in ('12','02','13') and lc_inconv='S') then 'CONVENIOS PYMES'----incluye judiciales, adicionar tonom Convenio Pymes 
         --WHEN lc_tonom like '%ARR%' then 'ARROZ'
         --WHEN lc_tonom like '%PAPA%' then 'PAPA'   
         WHEN (lc_mdnom like '%CAPITAL%TRABAJO%') OR (lc_tonom like '%CAPTRA%') OR 
                 (lc_tonom like '%-CT-%' and lc_tonom not like '%ACT%F%') OR (lc_tonom like '%CAPITAL%TRABAJO%') OR 
                 (lc_tonom LIKE '%CAP%TRA%') OR (lc_tonom LIKE '%CAPTRA%')  OR
                 (lc_tonom like '% CT %' and (lc_tonom not like '%CTS%' or lc_mdnom not like '%CTS%')) OR
                 (upper(replace(lc_tonom,'_','-')) like '%-CT-%') OR
                 (lv_bcmod in (116,117)And lc_tonom not like '%SEGURO%' And                 
                 (lv_bcmod in (116,117) And lc_tonom not like '%CONSUMO%') And
                 (lv_bcmod in (116,117) And lc_tonom not like '%DPF%') And
                 (lv_bcmod in (116,117) And lc_tonom not like '%CTS%')) 
             THEN 'CAPITAL DE TRABAJO'
         WHEN (lc_mdnom like '%ACT%FIJO%' And lc_tonom not like '%LOC%COM%') OR 
              (lc_tonom  like '%ACT%F%' And lc_tonom not like '%LOC%COM%') OR     
              (lc_mdnom like '%ACTIVO%FIJO%' And lc_tonom not like '%LOC%COM%') OR 
              (lc_tonom  like '% AF %') OR 
              (lc_tonom like '%ACT%F%') OR (lc_tonom  like '%-AF-%') OR
              (upper(replace(lc_tonom,'_','-'))  like '%-AF-%') 
             THEN 'ACTIVO FIJO'   
         WHEN (lc_mdnom like 'LOC%COM%') OR (lc_tonom  like '% LC %') OR     
              (lc_tonom  like '%LOC%C%') OR (lc_tonom  like '%-LC-%') OR
              (upper(replace(lc_tonom,'_','-')) like '%-LC-%') 
             THEN 'LOCAL COMERCIAL'
         WHEN lv_bcmod = 115 THEN  'CAMPAÑA'       
         ELSE 'NO IDENTIFICADO'
       END; 
     
  return lc_producto;

end fn_producto_regcaja;


-- -- -- -- -- -- -- -- -- 
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
      if v_Scmod = 200 then  
        begin  
          SELECT r011.r1cod, r011.r1mod,r011.r1suc ,r011.r1mda ,r011.r1pap ,r011.r1cta ,r011.r1oper,r011.r1sbop,r011.r1tope
            into lv_bcemp, lv_bcmod,lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta, lv_bcoper, lv_bcsbop, lv_bctop
          FROM fsr011 r011
          WHERE 
                   r011.relcod = 52
               and r011.r2cod  = v_pgcod
               and r011.r2mod  = v_Scmod
               and r011.r2suc  = v_Scsuc
               and r011.r2mda  = v_Scmda
               and r011.r2pap  = v_Scpap
               and r011.r2cta  = v_Sccta
               and r011.r2oper = v_Scoper
               and r011.r2sbop = v_Scsbop
               and r011.r2tope = v_Sctope
               and rownum = 1;
        exception
          when others then
              null;
         end;  
      end if;           
             
      if v_Sctope = 550 and lv_bcmod is null then --PRE JUDICIAL CON ABOGADO 550
        begin  
        SELECT r011.r1cod, r011.r1mod,r011.r1suc ,r011.r1mda ,r011.r1pap ,r011.r1cta ,r011.r1oper,r011.r1sbop,r011.r1tope
          into lv_bcemp, lv_bcmod,lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta, lv_bcoper, lv_bcsbop, lv_bctop
        FROM fsr011 r011
        WHERE 
                 r011.relcod = 52
             and r011.r2cod  = v_pgcod
             and r011.r2mod  = v_Scmod
             and r011.r2suc  = v_Scsuc
             and r011.r2mda  = v_Scmda
             and r011.r2pap  = v_Scpap
             and r011.r2cta  = v_Sccta
             and r011.r2oper = v_Scoper
             and r011.r2sbop = v_Scsbop
             and r011.r2tope = v_Sctope
             and rownum = 1;
        exception
          when others then
              null;
         end;       
      end if;
                
       
  end sp_credito_original;  
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_ind_banco_nacion(            
                               v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number
                             ) return number is
---retorna 1 si credito pertenece a banco de la nacion
    ln_bn number(1);
    
  begin
        begin

           select 
                   distinct 1
                      into ln_bn
             from depe68 p68 join sng001 g001 on g001.sng001inst = p68.depe68cre
                             join xwf700 f700 on f700.xwfprcins = p68.depe68cre
                                             and f700.xwfcar3   = '1'
                             join fsd010 d010 on d010.pgcod = f700.xwfempresa
                                             and d010.aomod = f700.xwfmodulo                
                                             and d010.aosuc = f700.xwfsucursal
                                             and d010.aomda = f700.xwfmoneda
                                             and d010.aopap = f700.xwfpapel
                                             and d010.aocta = f700.xwfcuenta
                                             and d010.aooper= f700.xwfoperacion
                                             and d010.aosbop= f700.xwfsubope
                                             and d010.aotope= f700.xwftipope
            where p68.depe68apl=92
              and p68.depe68ban='DOUT'
               and d010.pgcod = v_Pgcod
               and d010.aomod = v_Scmod                
               and d010.aosuc = v_Scsuc
               and d010.aomda = v_Scmda
               and d010.aopap = v_Scpap
               and d010.aocta = v_Sccta
               and d010.aooper= v_Scoper
               and d010.aosbop= v_Scsbop
               and d010.aotope= v_Sctope
              ;         
            
        exception when others then
                  ln_bn := 0;
        end;
        
        /*  2020.02.23 dcastro
        begin

            if (ln_bn=0) then
              select 
                     distinct 1
                        into ln_bn        
                from 
                     ebegazo.CRE_BN_20130630 cre inner join bnj096 ma on ma.bnj096sor   = cre.c_numcre
                                                 inner join fsd010 d010 on d010.aomda      = ma.bnj096mda
                                                                     and d010.aopap      = ma.bnj096pap
                                                                     and d010.aocta      = ma.bnj096cta
                                                                     --and des.aoimp      = cre.n_mtoapr
                                                                     and d010.aooper     = ma.bnj096ope
                                                                     and d010.aomod      = ma.bnj096mod
                                                                     AND d010.aosbop     = ma.bnj096sub  
                where                                                     
                         d010.pgcod = v_Pgcod
                     and d010.aomod = v_Scmod                
                     and d010.aosuc = v_Scsuc
                     and d010.aomda = v_Scmda
                     and d010.aopap = v_Scpap
                     and d010.aocta = v_Sccta
                     and d010.aooper= v_Scoper
                     and d010.aosbop= v_Scsbop
                     and d010.aotope= v_Sctope ;                                                                   
            end if;    
            
        exception when others then
                  ln_bn := 0;
        end;        
        */
      Return ln_bn;
      
end fn_ind_banco_nacion;  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_age_banco_nacion(            
                               v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               ln_xwfprcins  in xwf700.xwfprcins%type
                             ) return number is
---retorna 1 si credito pertenece a banco de la nacion
    ln_agebn number(4);
    
  begin
    
    null;--se comenta 19.12.2018 por referencia a esquema pvargas, se confirmó con ebegazo
    
        /*begin

           select 
                   max(p68.depe68agc)
                   into ln_agebn
             from depe68 p68 join sng001 g001 on g001.sng001inst = p68.depe68cre
                             join xwf700 f700 on f700.xwfprcins = p68.depe68cre
                                             and f700.xwfcar3   = '1'
            where p68.depe68apl = 92
              and p68.depe68ban = 'DOUT'
              and p68.depe68cre = ln_xwfprcins;         
            
        exception when others then
                  ln_agebn := 0;
        end;
        
        begin

            if (ln_agebn=0) then
              select 
                     max(agenbn)
                     into ln_agebn        
                from 
                     pvargas.BN_SORFY_JUN2013 cre   
                where  
                     (
                          cre.PGCOD = v_Pgcod
                      and cre.AOSUC = v_Scsuc            
                      and cre.AOMOD = v_Scmod
                      and cre.AOMDA = v_Scmda
                      and cre.AOPAP = v_Scpap
                      and cre.AOCTA = v_Sccta
                      and cre.AOOPER= v_Scoper
                      and cre.AOSBOP= v_Scsbop
                      and cre.AOTOPE= v_Sctope
                     ) 
                      or 
                     ( 
                          BCEMP_ORI = v_Pgcod
                      and BCMOD_ORI = v_Scmod
                      and BCSUC_ORI = v_Scsuc
                      and BCMDA_ORI = v_Scmda
                      and BCPAP_ORI = v_Scpap
                      and BCCTA_ORI = v_Sccta
                      and BCOPER_ORI= v_Scoper
                      and BCSBOP_ORI= v_Scsbop
                      and BCTOP_ORI = v_Sctope
                      );                                                                   
            end if;    
            
        exception when others then
                  ln_agebn := 0;
        end;        */
        
      Return ln_agebn;
      
end fn_age_banco_nacion;  


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_institucion_conv(            
                               v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               ---original
                               v_Pgcod_ori  in number,
                               v_Scmod_ori  in number,
                               v_Scsuc_ori  in number,
                               v_Scmda_ori  in number,
                               v_Scpap_ori  in number,
                               v_Sccta_ori  in number,
                               v_Scoper_ori in number,
                               v_Scsbop_ori in number,
                               v_Sctope_ori in number
                             ) return number is

   ln_pp101ncar   fpp101.pp101ncart%type;  
begin                            
                             
  --verificar si es convenio
    begin  
         select 
                --max(det.pp102ncart)  --2016.01.21 ebegazo -> si existe mas de un convenio asociado entonces deben validarlo
                distinct det.pp102ncart
            into ln_pp101ncar
           from fpp102 det
           where det.pp102hab = 'S'
             and det.pp102cod = v_Pgcod
             and det.pp102mod = v_Scmod
             --and det.pp102suc = v_Scsuc
             and det.pp102mda = v_Scmda
             and det.pp102pap = v_Scpap
             and det.pp102cta = v_Sccta
             and det.pp102ope = v_Scoper
             and det.pp102top = v_Sctope
             and det.pp102sbo = v_Scsbop;           
    exception
        when others then
             ln_pp101ncar := null;
    end;   
    
    if ln_pp101ncar is null then
        begin

         select
                --max(det.pp102ncart)
                distinct det.pp102ncart --2016.01.21 ebegazo -> si existe mas de un convenio asociado entonces deben validarlo
            into ln_pp101ncar
           from fpp102 det
           where det.pp102hab = 'S'
             --and det.pp102cod = v_Pgcod
             --and det.pp102mod = v_Scmod
             --and det.pp102suc = v_Scsuc
             --and det.pp102mda = v_Scmda
             --and det.pp102pap = v_Scpap
             and det.pp102cta = v_Sccta
             and det.pp102ope = v_Scoper
             --and det.pp102top = v_Sctope
             and det.pp102sbo = v_Scsbop
             ;

        exception
            when others then
                 ln_pp101ncar := null;
         end;
    end if;     

    if ln_pp101ncar is null then
        begin

         select
                --max(det.pp102ncart) --2016.01.21 ebegazo -> si existe mas de un convenio asociado entonces deben validarlo
                distinct det.pp102ncart
            into ln_pp101ncar
           from fpp102 det
           where det.pp102hab = 'S'
             --and det.pp102cod = v_Pgcod
             --and det.pp102mod = v_Scmod
             --and det.pp102suc = v_Scsuc
             --and det.pp102mda = v_Scmda
             --and det.pp102pap = v_Scpap
             and det.pp102cta = v_Sccta
             and det.pp102ope = v_Scoper
             --and det.pp102top = v_Sctope
             --and det.pp102sbo = v_Scsbop
             ;

        exception
            when others then
                 ln_pp101ncar := null;
         end;
    end if;    
     
  --verificar si es convenio credito original (para migrados)
    /*if ln_pp101ncar is null then 
        begin  
          
         select 
                max(det.pp102ncart) 
            into ln_pp101ncar
           from fpp102 det
           where det.pp102hab = 'S'
             and det.pp102cod = v_Pgcod_ori
             and det.pp102mod = v_Scmod_ori
             --and det.pp102suc = v_Scsuc_ori
             and det.pp102mda = v_Scmda_ori
             and det.pp102pap = v_Scpap_ori
             and det.pp102cta = v_Sccta_ori
             and det.pp102ope = v_Scoper_ori
             and det.pp102top = v_Sctope_ori
             and det.pp102sbo = v_Scsbop_ori
             and det.pp102hab = 'S'; 
             
        exception
            when others then
                 ln_pp101ncar := null;
         end;     
    end if;  */ 
    
    Return ln_pp101ncar;                          
                             
end fn_institucion_conv;       


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_nro_credito_desem(--lc_pepais fsr008.pepais%type,
                               --lc_petdoc fsr008.petdoc%type,            
                               lc_pendoc fsr008.pendoc%type,           
                               ld_fecini date,
                               ld_fecfin date              
                               )return number is

  ln_nrodesem number;

  begin

      begin
        
        select count(*)        
          into ln_nrodesem        
          from fsd010 des
               inner join fsr008 pers
                      on pers.pgcod = des.pgcod
                     and pers.ctnro = des.aocta
                     --and pers.ttcod = 1
                     --and pers.CTTFIR = 'T'
         where 
               des.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120) union all select 117 from dual)
           and des.aomod not in (200,33,141)
           and des.aomod <> 120 --prestamos pasivos        
           and des.aotope<> 550
           --and pers.pepais = lc_pepais
           --and pers.petdoc = lc_petdoc
           and pers.pendoc = lc_pendoc
           and des.aofval between ld_fecini and ld_fecfin;
           
        exception
          when no_data_found then
               ln_nrodesem := null;
      end;

  return ln_nrodesem;
  
end fn_nro_credito_desem;    

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_nro_credito_desem( lc_pepais fsr008.pepais%type,
                               lc_petdoc fsr008.petdoc%type,            
                               lc_pendoc fsr008.pendoc%type,           
                               ld_fecini date,
                               ld_fecfin date              
                               )return number is

  ln_nrodesem number;

  begin

      begin
        
        select count(*)        
          into ln_nrodesem        
          from fsd010 des
               inner join fsr008 pers
                      on pers.pgcod = des.pgcod
                     and pers.ctnro = des.aocta
                     --and pers.ttcod = 1
                     --and pers.CTTFIR = 'T'
         where 
               des.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120) union all select 117 from dual)
           and des.aomod not in (200,33,141)
           and des.aomod <> 120 --prestamos pasivos        
           and des.aotope<> 550
           and pers.pepais = lc_pepais
           and pers.petdoc = lc_petdoc
           and pers.pendoc = lc_pendoc
           and des.aofval between ld_fecini and ld_fecfin;
           
        exception
          when no_data_found then
               ln_nrodesem := null;
      end;

  return ln_nrodesem;
  
end fn_nro_credito_desem;     

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_min_fecdes(--lc_pepais fsr008.pepais%type,
                       --lc_petdoc fsr008.petdoc%type,            
                       lc_pendoc fsr008.pendoc%type,           
                       ld_fecini date,
                       ld_fecfin date              
                       )return date is

  ld_fecdes date;

  begin

      begin
        
        select min(des.aofval)        
          into ld_fecdes        
          from fsd010 des
               inner join fsr008 pers
                      on pers.pgcod = des.pgcod
                     and pers.ctnro = des.aocta
                     --and pers.ttcod = 1
                     --and pers.CTTFIR = 'T'
         where 
               des.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120) union all select 117 from dual)
           and des.aomod not in (200,33,141)
           and des.aomod <> 120 --prestamos pasivos        
           and des.aotope<> 550
           --and pers.pepais = lc_pepais
           --and pers.petdoc = lc_petdoc
           and pers.pendoc = lc_pendoc
           and des.aofval between ld_fecini and ld_fecfin;
           
        exception
          when no_data_found then
               ld_fecdes := null;
      end;

  return ld_fecdes;
  
end fn_min_fecdes;  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_tipsol_original (
                                 v_pgcod  in fsd010.pgcod%type,
                                 v_aomod  in fsd010.aomod%type,
                                 v_aosuc  in fsd010.aosuc%type,
                                 v_aomda  in fsd010.aomda%type,
                                 v_aopap  in fsd010.aopap%type,
                                 v_aocta  in fsd010.aocta%type,
                                 v_aooper in fsd010.aooper%type,
                                 v_aosbop in fsd010.aosbop%type,
                                 v_aotope in fsd010.aotope%type,
                                 ln_xwfprcins  in xwf700.xwfprcins%type                                
                               ) return number
  is

  ln_tipsol number;        
            
  begin
    
     --TRANSADO
     begin    
          SELECT  
               max(relcod)                   
               into ln_tipsol    
          FROM fsr011 r011
          WHERE 
                   r011.relcod in (35,36)
               and r011.r2cod  = v_pgcod
               and r011.r2mod  = v_aomod
               and r011.r2suc  = v_aosuc
               and r011.r2mda  = v_aomda
               and r011.r2pap  = v_aopap
               and r011.r2cta  = v_aocta
               and r011.r2oper = v_aooper
               and r011.r2sbop = v_aosbop
               and r011.r2tope = v_aotope
               and r011co = 'S';
     exception when no_data_found then   
       begin                                  
          SELECT  
               max(relcod)                   
               into ln_tipsol    
          FROM fsr011 r011
          WHERE 
                   r011.relcod in (35,36)
               and r011.r1cod  = v_pgcod
               and r011.r1mod  = v_aomod
               and r011.r1suc  = v_aosuc
               and r011.r1mda  = v_aomda
               and r011.r1pap  = v_aopap
               and r011.r1cta  = v_aocta
               and r011.r1oper = v_aooper
               and r011.r1sbop = v_aosbop
               and r011.r1tope = v_aotope
               and r011co = 'S';
       exception when others then       
               ln_tipsol := null;    
       end;        
     end;       
     
     if ln_tipsol is null then 
       --REFINANCIADO
       begin    
            SELECT  
                 distinct 3                  
                 into ln_tipsol    
            FROM xwf700 f700
            WHERE 
                 f700.xwfprcins = ln_xwfprcins
             and f700.xwfcar3 = 'R';
       exception when no_data_found then                                     
         begin    
              SELECT  
                   max(relcod)                   
                   into ln_tipsol    
              FROM fsr011 r011
              WHERE 
                       r011.relcod in (120,121)
                   and r011.r2cod  = v_pgcod
                   and r011.r2mod  = v_aomod
                   and r011.r2suc  = v_aosuc
                   and r011.r2mda  = v_aomda
                   and r011.r2pap  = v_aopap
                   and r011.r2cta  = v_aocta
                   and r011.r2oper = v_aooper
                   and r011.r2sbop = v_aosbop
                   and r011.r2tope = v_aotope
                   and r011co = 'S';
         exception when no_data_found then                                     

           begin                                  
                SELECT  
                     max(relcod)                   
                     into ln_tipsol    
                FROM fsr011 r011
                WHERE 
                         r011.relcod in (120,121)
                     and r011.r1cod  = v_pgcod
                     and r011.r1mod  = v_aomod
                     and r011.r1suc  = v_aosuc
                     and r011.r1mda  = v_aomda
                     and r011.r1pap  = v_aopap
                     and r011.r1cta  = v_aocta
                     and r011.r1oper = v_aooper
                     and r011.r1sbop = v_aosbop
                     and r011.r1tope = v_aotope
                     and r011co = 'S';
           exception when others then       
                   ln_tipsol := null;    
           end;                 
         end;
         
       end;
       
     end if;
     
     return ln_tipsol;   
      
  end fn_tipsol_original;    
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_destino_credito(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in fsh012.bcrubr%type
                             ) return varchar2 is

    lc_mdnom  fst003.mdnom%type;
    lc_tonom  fst004.tonom%type;
    
    lv_bcemp  fsh012.bcemp%type;
    lv_bcmod  fsh012.bcmod%type;
    lv_bcsuc  fsh012.bcsuc%type;
    lv_bcmda  fsh012.bcmda%type;
    lv_bcpap  fsh012.bcpap%type;
    lv_bccta  fsh012.bccta%type;
    lv_bcoper fsh012.bcoper%type;
    lv_bcsbop fsh012.bcsbop%type;
    lv_bctop  fsh012.bctop%type;
    
    lc_inconv  varchar2(1); --indicador de convenio
    
    lc_segcli jaqy067.jaqy067ncal%type;
    lc_indtra fsd002.pfebco%type;
    
    lc_destino varchar2(100);
     
  begin
    
    --para creditos judiciales encontrar modulo inicial
    if v_Scmod = 200 then  
      begin  
        SELECT r011.r1cod, r011.r1mod,r011.r1suc ,r011.r1mda ,r011.r1pap ,r011.r1cta ,r011.r1oper,r011.r1sbop,r011.r1tope
          into lv_bcemp, lv_bcmod,lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta, lv_bcoper, lv_bcsbop, lv_bctop
        FROM fsr011 r011
        WHERE 
                 r011.relcod = 52
             and r011.r2cod  = v_pgcod
             and r011.r2mod  = v_Scmod
             and r011.r2suc  = v_Scsuc
             and r011.r2mda  = v_Scmda
             and r011.r2pap  = v_Scpap
             and r011.r2cta  = v_Sccta
             and r011.r2oper = v_Scoper
             and r011.r2sbop = v_Scsbop
             and r011.r2tope = v_Sctope
             and rownum = 1;
      exception
        when others then
            null;
       end;  
    end if;           
           
    if v_Sctope = 550 and lv_bcmod is null then --PRE JUDICIAL CON ABOGADO 550
      begin  
      SELECT r011.r1cod, r011.r1mod,r011.r1suc ,r011.r1mda ,r011.r1pap ,r011.r1cta ,r011.r1oper,r011.r1sbop,r011.r1tope
        into lv_bcemp, lv_bcmod,lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta, lv_bcoper, lv_bcsbop, lv_bctop
      FROM fsr011 r011
      WHERE 
               r011.relcod = 52
           and r011.r2cod  = v_pgcod
           and r011.r2mod  = v_Scmod
           and r011.r2suc  = v_Scsuc
           and r011.r2mda  = v_Scmda
           and r011.r2pap  = v_Scpap
           and r011.r2cta  = v_Sccta
           and r011.r2oper = v_Scoper
           and r011.r2sbop = v_Scsbop
           and r011.r2tope = v_Sctope
           and rownum = 1;
      exception
        when others then
            null;
       end;       
    end if;
    
    if lv_bcmod is null then 
      lv_bcemp  := v_pgcod ;
      lv_bcmod  := v_Scmod ;
      lv_bcsuc  := v_Scsuc ;
      lv_bcmda  := v_Scmda ;
      lv_bcpap  := v_Scpap ;
      lv_bccta  := v_Sccta ;
      lv_bcoper := v_Scoper;
      lv_bcsbop := v_Scsbop;
      lv_bctop  := v_Sctope;    
    end if;

      
  --obtener descripcion de modulo 
  begin  
    select upper(mdnom)
      into lc_mdnom
      from fst003
      where modulo = lv_bcmod;
  exception
    when others then
        lc_mdnom := null;
  end;  
       
  --obtener descripcion de operacion
  begin  
    select upper(tonom)
      into lc_tonom
      from fst004
      where modulo = lv_bcmod
        and totope = lv_bctop;
  exception
    when others then
        lc_tonom := null;
  end; 
  
  --obtener producto
    lc_destino:=
       CASE
         when substr(v_Rubro,5,2) = '03' then 'LIBRE DISPONIBILIDAD' 
         when substr(v_Rubro,5,2) = '04' then 'HIPOTECARIO'  
         WHEN (lc_mdnom like 'CAPITAL%TRABAJO%') OR (lc_tonom like '%CAPTRA%') OR 
                 (lc_tonom like '%-CT-%' and lc_tonom not like '%ACT%F%') OR (lc_tonom like '%CAPITAL%TRABAJO%') OR 
                 (lc_tonom LIKE '%CAP%TRA%') OR (lc_tonom LIKE '%CAPTRA%')  OR
                 (lc_tonom like '% CT %' and (lc_tonom not like '%CTS%' or lc_mdnom not like '%CTS%')) OR
                 (upper(replace(lc_tonom,'_','-')) like '%-CT-%') OR
                 (lv_bcmod = 116 And lc_tonom not like '%SEGURO%' And                 
                 (lv_bcmod = 116 And lc_tonom not like '%CONSUMO%') And
                 (lv_bcmod = 116 And lc_tonom not like '%DPF%') And
                 (lv_bcmod = 116 And lc_tonom not like '%CTS%')) 
             THEN 'CAPITAL DE TRABAJO'
         WHEN (lc_mdnom like 'ACT%FIJO%' And lc_tonom not like '%LOC%COM%') OR 
              (lc_tonom  like '%ACT%F%' And lc_tonom not like '%LOC%COM%') OR     
              (lc_mdnom like '%ACTIVO%FIJO%' And lc_tonom not like '%LOC%COM%') OR 
              (lc_tonom  like '% AF %') OR 
              (lc_tonom like '%ACT%F%') OR (lc_tonom  like '%-AF-%') OR
              (upper(replace(lc_tonom,'_','-'))  like '%-AF-%') 
             THEN 'ACTIVO FIJO'   
         WHEN (lc_mdnom like 'LOC%COM%') OR (lc_tonom  like '% LC %') OR     
              (lc_tonom  like '%LOC%C%') OR (lc_tonom  like '%-LC-%') OR
              (upper(replace(lc_tonom,'_','-')) like '%-LC-%') 
             THEN 'LOCAL COMERCIAL'
         ELSE 'NO IDENTIFICADO'
       END; 
     
  return lc_destino;

end fn_destino_credito;       

-- -- -- -- -- -- -- -- -- 
  procedure sp_credito_actual(
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
  --retorna el credito actual de un credito original  
    
  begin

      begin  
        SELECT 
            r011.r2cod, r011.r2mod,r011.r2suc ,r011.r2mda ,r011.r2pap ,r011.r2cta ,r011.r2oper,r011.r2sbop,r011.r2tope
                 into lv_bcemp, lv_bcmod,lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta, lv_bcoper, lv_bcsbop, lv_bctop            
          FROM            
                 (                               
                    SELECT 
                      (case when r011.r2mod = 33 then 1 
                            when r011.r2mod = 200 then 2
                      end) orden,       
                      r011.r2cod, r011.r2mod,r011.r2suc ,r011.r2mda ,r011.r2pap ,r011.r2cta ,r011.r2oper,r011.r2sbop,r011.r2tope
                    FROM fsr011 r011
                    WHERE 
                           r011.relcod = 52
                       and r011.r1cod  = v_pgcod
                       and r011.r1mod  = v_Scmod
                       and r011.r1suc  = v_Scsuc
                       and r011.r1mda  = v_Scmda
                       and r011.r1pap  = v_Scpap
                       and r011.r1cta  = v_Sccta
                       and r011.r1oper = v_Scoper
                       and r011.r1sbop = v_Scsbop
                       and r011.r1tope = v_Sctope
                       and r011.r2mod in (200,33)
                    ORDER BY orden   
                 )r011
             WHERE rownum = 1; 
         
      exception
      when others then
          null;
      end;  
         
  end sp_credito_actual;       

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_prom_dias_atraso_ultcuo(v_Pgfape in date, --fecha de proceso
                                    v_cntcuo in number,            
                                    v_Pgcod  in number,
                                    v_Scmod  in number,
                                    v_Scsuc  in number,
                                    v_Scmda  in number,
                                    v_Scpap  in number,
                                    v_Sccta  in number,
                                    v_Scoper in number,
                                    v_Scsbop in number,
                                    v_Sctope in number
                                   ) return number is

    ln_diaatr number(5);
    ln_cntcuo number(5);
    ln_proatr number(10,2);
    
  begin
        begin

          Select Sum(diaatr),
                 count(*) 
            Into ln_diaatr,
                 ln_cntcuo   
          From               
          (                        
              Select a.Ppfpag,
                    (Case When nvl(b.pp1fech,v_Pgfape) - a.ppfpag > 0 
                          Then nvl(b.pp1fech,v_Pgfape) - a.ppfpag
                          Else 0
                    End)diaatr
                From FSD601 a left join FSD602 b on b.Pgcod  = a.Pgcod
                                              and b.Ppmod  = a.Ppmod
                                              and b.Ppsuc  = a.Ppsuc
                                              and b.Ppmda  = a.Ppmda
                                              and b.Pppap  = a.Pppap
                                              and b.Ppcta  = a.Ppcta
                                              and b.Ppoper = a.Ppoper
                                              and b.Ppsbop = a.Ppsbop
                                              and b.Pptope = a.Pptope
                                              and b.Ppfpag = a.Ppfpag
                                              and b.Pptipo = a.Pptipo
                                              and b.Pp1stat = 'T'
                                              and b.D602co  = 'S'
                                              and b.pp1fech <= v_Pgfape
              where a.Pgcod  = v_Pgcod
                and a.Ppmod  = v_Scmod
                and a.Ppsuc  = v_Scsuc
                and a.Ppmda  = v_Scmda
                and a.Pppap  = v_Scpap
                and a.Ppcta  = v_Sccta
                and a.Ppoper = v_Scoper
                and a.Ppsbop = v_Scsbop
                and a.Pptope = v_Sctope
                --and a.Ppfpag >= v_fecini
                and a.Ppfpag <= v_Pgfape
                and a.D601co = 'S'
                and (a.ppcap + a.ppint ) > 0
              order by a.Ppfpag desc
          )
          where rownum<=6;
      exception when others then
                ln_proatr := null;
      end;
      
      /*
      If NVL(ln_cntcuo,0) <> 0 Then
         ln_proatr := round(ln_diaatr/ln_cntcuo,2);
      Else 
         ln_proatr := 0;
      End If;   
      */
      
      If ln_cntcuo is not null and NVL(ln_cntcuo,0) <> 0 Then
         ln_proatr := round(ln_diaatr/ln_cntcuo,2);
      End If; 
          
      Return ln_proatr;
      
end fn_prom_dias_atraso_ultcuo;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_ultimo_analista(
                              --P_PAIS in number,
                              --P_TDOC in number,
                              P_NDOC in char,  
                              ---retorno
                              lv_codase out char,
                              lv_codsuc out number
                              ) 
  is
  --retorna el ultimo analista que atendio cliente  
 
  begin

      begin 
            select  aosuc, codase 
              into  lv_codsuc,  lv_codase
            from 
            (          
                select
                       case --
                            when d.aostat <> 99 and d.aomod<>108 and r.ttcod= 1 and r.cttfir = 'T' then 1
                            when d.aostat <> 99 and d.aomod<>108 then 2
                            --  
                            when d.aomod<>108 then 3
                            else 4
                       end orden, 
                       d.aosuc,       
                       d.aofe99,
                       (case 
                         when d.aomod<>108 
                         then /*pvargas.*/fn_analista_credito(d.aomod,d.aosuc,d.aomda,d.aopap,d.aocta,d.aooper,d.aosbop,d.aotope) 
                       end)codase
                  from fsr008 r join fsd010 d on d.pgcod = r.pgcod
                                             and d.aocta = r.ctnro
                                             and d.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120) union all select 117 from dual)
                 where --r.pepais = P_PAIS
                   --and r.petdoc = P_TDOC
                   --and
                   r.pendoc = P_NDOC --rpad(P_NDOC, 12, ' ')
                   /*and (d.aofe99 is null 
                        or  
                        d.aostat<>99
                        --or 
                        --d.aofe99>= to_date('2013.07.01','rrrr.mm.dd')
                       )
                   */    
                   order by orden asc,d.aofval desc, d.aofe99 desc     
              )
              where rownum=1;
      exception when others then
                lv_codsuc:= null;
                lv_codase:= null;
      end;    

  end sp_ultimo_analista;  
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_ultimo_analistaxage(
                                  P_PAIS in number,
                                  P_TDOC in number,
                                  P_NDOC in char,  
                                  P_SUC  in number,
                                  ---retorno
                                  lv_codase out char,
                                  lv_codsuc out number
                                  ) 
  is
  --retorna el ultimo analista que atendio cliente  
 
  begin

      begin 
            select  codase, aosuc 
              into  lv_codase, lv_codsuc
            from 
            (          
                select
                       case when d.aostat <> 99 and r.ttcod= 1 and r.cttfir = 'T' then 1
                            when d.aostat <> 99 then 2
                            else 3
                       end orden, 
                       d.aosuc,       
                       d.aofe99,
                       /*pvargas.*/fn_analista_credito(d.aomod,d.aosuc,d.aomda,d.aopap,d.aocta,d.aooper,d.aosbop,d.aotope) codase
                  from fsr008 r 
                       join fsd010 d 
                       on d.pgcod = r.pgcod
                       and d.aocta = r.ctnro
                       and d.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120) union all select 117 from dual)
                 where r.pepais = P_PAIS
                   and r.petdoc = P_TDOC
                   and r.pendoc = P_NDOC --rpad(P_NDOC, 12, ' ')
                   and r.ttcod = 1
                   and r.cttfir = 'T'
                   --and d.aosuc = P_SUC
                   /*and (d.aofe99 is null 
                        or  
                        d.aostat<>99
                        --or 
                        --d.aofe99>= to_date('2013.07.01','rrrr.mm.dd')
                       )
                   */    
                   order by orden asc,d.aofval desc, d.aofe99 desc     
              )
              where codase is not null 
               and rownum=1;
      exception when others then
                lv_codase:= null;
                lv_codsuc:= null;
      end;    

  end sp_ultimo_analistaxage;    
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_garantias_cred (
                                 v_pgcod  in fsd010.pgcod%type,
                                 v_aomod  in fsd010.aomod%type,
                                 v_aosuc  in fsd010.aosuc%type,
                                 v_aomda  in fsd010.aomda%type,
                                 v_aopap  in fsd010.aopap%type,
                                 v_aocta  in fsd010.aocta%type,
                                 v_aooper in fsd010.aooper%type,
                                 v_aosbop in fsd010.aosbop%type,
                                 v_aotope in fsd010.aotope%type                                
                               ) return varchar2
  is

  /*  
  create table fsr011_gar as 
  SELECT * 
  FROM fsr011 r11
  where relcod = 50
    and r1mod = 115
    and r1tope in (600,601,602,603,604,605,606,607,608,609,640,641,642,625,621,622);  
    
    create index IX_fsr011_gar_01 on fsr011_gar (R1COD,R1MOD,R1SUC,R1MDA,R1PAP,R1CTA,R1OPER,R1SBOP,R1TOPE);        
  */        
  
  lc_garantias varchar2(1000);  
  lc_gar varchar2(100);
  
  cursor c_garantias is
      SELECT distinct trim(tonom) tonom
      FROM fsr011/*_gar*/ g
           inner join fst004  t004
           on g.r2mod = t004.modulo
           and g.r2tope = t004.totope
      WHERE 
           g.R1COD = v_pgcod
       and g.R1MOD = v_aomod
       and g.R1SUC = v_aosuc
       and g.R1MDA = v_aomda
       and g.R1PAP = v_aopap
       and g.R1CTA = v_aocta
       and g.R1OPER= v_aooper
       and g.R1SBOP= v_aosbop
       and g.R1TOPE= v_aotope    
       ;
          
  BEGIN

      for i in c_garantias  loop
          lc_garantias := lc_garantias || trim(i.tonom)|| ',';
      end loop;
      lc_garantias := substr(lc_garantias, 1, length(lc_garantias) - 1);
     
     return lc_garantias;   
      
  end fn_garantias_cred;      
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_DATOS_CREDITO;
/

