create or replace package PQ_CR_MANTENIMIENTO_PYME is

-- *****************************************************************
-- Nombre                     : PQ_CR_MANTENIMIENTO_PYME
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 20/02/2022
-- Autor de Creación          : YYAMPI
-- Uso                        : Procedimientos y funciones para el calculo de variables de mejora mantenimiento segmentacion pyme
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha Modificacion         : 
-- *****************************************************************   
  
  Procedure Sp_CalculaCuotas_dmax(   pn_emp      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pd_fec      in date,
                                   pd_fecor    in date,
                                   pn_stat     in number,
                                   ln_contador out number,
                                   ln_diasTot  out number,
                                   ln_diasMaxT out number ); 
                             
  Procedure Sp_DiaAtraso_linea(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_fecpro   in date,
                               ln_promedio out number);
  Procedure Sp_cr_histDiaAtr_linea_m(pn_pai        in number,
                                     pn_tdo        in number,
                                     pc_ndo        in char,
                                     pd_fecpro     in date,
                                     pd_fecini     in date,
                                     ln_contCuoTot out number,
                                     ln_diaTot     out number);
  Procedure Sp_cr_histDiaAtr_linea_nm( pn_pai        in number,
                                       pn_tdo        in number,
                                       pc_ndo        in char,
                                       pd_fecpro     in date,
                                       pd_fecini     in date,
                                       ln_contCuoTot out number,
                                       ln_diaTot     out number,
                                       ln_diaMax     out number );
                                       
  Procedure Sp_cr_histDiaAtr_linea_ii(
                                      pn_pai        in number,
                                      pn_tdo        in number,
                                      pc_ndo        in char,
                                      pd_fecor      in date,
                                      pd_fecpro     in date, /*pd_fecini in date,*/
                                      pc_periodo    in char, 
                                      ln_contCuoTot out number,
                                      ln_diaTot     out number, 
                                      ln_diaMax     out number
                                      );

  Procedure Sp_num_excepciones_segm (pn_pai      in number,
                                     pn_tdo      in number,
                                     pc_ndo      in char,
                                     ln_numexc out number);
                                     
  Procedure Sp_num_pagos (pn_pai      in number,
                         pn_tdo      in number,
                         pc_ndo      in char,
                         pd_fecpro   in date,
                         ln_numpag out number) ;
                         
  procedure sp_cr_calificacion_rcc(
                                    pn_cta number,
                                    pn_result out number
                                    );                                                           
                                                                            
  procedure sp_num_entidades_rcc(
                                    pn_cta number,
                                    pn_result out number
                                    );
                                    
  Procedure Sp_cr_ReCalcula(pn_pais     in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecpro   in date,
                            ln_contador out number);
                            
  Procedure Sp_cr_InsNuevo(pn_pais     in number,
                           pn_tdo      in number,
                           pc_ndo      in char,
                           pd_fecpro   in date,
                           pd_fecini   in date,
                           ln_contador out number);
                           
  Procedure Sp_cr_histNuevo(pn_pai      in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecini   in date,
                            pd_fecpro   in date,
                            ln_contador out number);   

  procedure sp_relacion_crediticia(
                                    pn_cta number,
                                    pn_result out number
                                    );
                                       
   procedure sp_relacion_crediticia_inv(
                                    pn_cta number,
                                    pn_result out number
                                    );                                            
   
  Procedure Sp_cr_ReCalcula_inv(pn_pais     in number,
                              pn_tdo      in number,
                              pc_ndo      in char,
                              pd_fecpro   in date,
                              ln_contador out number); 
                            
                                                                                                                                        
Function Fn_DiaPago(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pn_est in number,
                      pd_fec in date) return date;
                      
                                                            
end PQ_CR_MANTENIMIENTO_PYME;
/

create or replace package body PQ_CR_MANTENIMIENTO_PYME is

  
  
------------------------------------------------------------------------------------------
Procedure Sp_CalculaCuotas_dmax(   pn_emp      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pd_fec      in date,
                                   pd_fecor    in date,
                                   pn_stat     in number,
                                   ln_contador out number,
                                   ln_diasTot  out number,
                                   ln_diasMaxT out number ) is
    
-- *****************************************************************
-- Nombre                     : Sp_CalculaCuotas_dmax
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 20/02/2022
-- Autor de Creación          : YYAMPI
-- Uso                        : Calcula la max cuota
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha Modificacion         : 
-- *****************************************************************                               
                         
    cursor creditos is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag --,modificado 20151022 porque no esta tomando la ultima cuota pendiente de pago
      --b.ppfpag pag602,modificado 20151022
      --b.pp1fech modificado 20151022
        from fsd601 a --,fsd602 b modificado 20151022
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
            --and a.ppfpag between pd_fecor and pd_fec
            --and a.ppfpag >= pd_fecor
         and a.ppfpag < pd_fec
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0;
    /*and a.pgcod = b.pgcod
    and a.ppmod = b.ppmod
    and a.ppsuc = b.ppsuc
    and a.ppmda = b.ppmda
    and a.pppap = b.pppap
    and a.ppcta = b.ppcta
    and a.ppoper = b.ppoper
    and a.ppsbop = b.ppsbop
    and a.pptope = b.pptope
    and a.ppfpag = b.ppfpag
    and b.pp1stat = 'T'
    and b.d602co = 'S'
    and b.pp1fech >=pd_fecor*/ --modificado 20151022;
  
    --ln_contador number(5);
    ln_dias number(10) :=0;
    --ln_diasTot number(5);
  
    --ld_fecpag date;
    --ln_mpag number(2);
    --ln_mdpa number(2);
    --ln_apag number(4);
    --ln_adpa number(4);
  
    ln_flag    number(1);
    ld_fecantC date;
  
    ld_fecpago date; --modificado 20151022
    ln_diasMax number(10) :=0;
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
      ln_flag     := 0;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      For i in creditos loop
      
        begin
        
          select b.pp1fech
            into ld_fecpago
            from fsd602 b
           where b.pgcod = i.pgcod
             and b.ppmod = i.ppmod
             and b.ppsuc = i.ppsuc
             and b.ppmda = i.ppmda
             and b.pppap = i.pppap
             and b.ppcta = i.ppcta
             and b.ppoper = i.ppoper
             and b.ppsbop = i.ppsbop
             and b.pptope = i.pptope
             and b.ppfpag = i.ppfpag
             and b.pp1stat = 'T'
             and b.d602co = 'S'
             and (b.pp1cap + b.pp1int) <> 0
             and rownum = 1;
        exception
          when no_data_found then
            ld_fecpago := null;
        end;
      
        if ld_fecpago >= pd_fecor or ld_fecpago is null then
        
          if ld_fecantC <> i.ppfpag then
            ln_contador := ln_contador + 1;
          
            ln_dias := pq_cr_relcrediticia.fn_cuotasPag(   
                                                           i.pgcod,
                                                           i.ppmod,
                                                           i.ppsuc,
                                                           i.ppmda,
                                                           i.pppap,
                                                           i.ppcta,
                                                           i.ppoper,
                                                           i.ppsbop,
                                                           i.pptope,
                                                           i.ppfpag,
                                                           pd_fec
                                                           
                                                           );
                                                           
            /*Obtenemos los dias de atraso mayor para creditos*/
            if ln_diasMax <=  ln_dias  then
              ln_diasMax :=  ln_dias;              
            end if;   
            
            ln_diasTot := ln_diasTot + ln_dias;
          end if;
        
          ld_fecantC := i.ppfpag;
        end if;
      
      end loop;
      
      ln_diasMaxT := ln_diasMax;  -- se asigna los dias de atraso max 
     
      if pn_stat = 99 then
        begin
        
          select 1
            into ln_flag
            from fsd601 a
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
                --and a.ppfpag between pd_fecor and pd_fec
             and a.ppfpag >= pd_fec
                --and a.ppfpag < pd_fec
             and a.d601co = 'S'
             and (a.ppcap + a.ppint) <> 0
             and rownum = 1;
        exception
          when no_data_found then
            ln_flag := 0;
        end;
      else
        ln_flag := 0;
      end if;
    
      if ln_flag = 1 then
        ln_contador := ln_contador + 1;
      end if;
    end;
  
  end Sp_CalculaCuotas_dmax;
---------------------------------------------------------------------------------------------------------

  Procedure Sp_DiaAtraso_linea(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_fecpro   in date,
                               ln_promedio out number) is
                               
  -- *****************************************************************
    -- Nombre                     : Sp_DiaAtraso_linea
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/11/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el promedio de dias de atraso 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************                             
  
    ld_fecini   date;
    ln_vig      number(9);
    ln_diaM      number(18);
    ln_diaNM      number(18);
    ln_contadorM number(18) :=0;
    ln_contadorNM number(18) :=0;
    ln_diaMax number(18) := 0;
    
  begin
  
    begin
      select tp1nro1
        into ln_vig
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 2
         and tp1corr2 = 4;
    exception
      when others then
        ln_vig := null; --cambiar en produccion
    
    end;
  
    ld_fecini := add_months(pd_fecpro, -ln_vig);
    delete from jaqz081 a
     where a.pepais = pn_pai
       and a.petdoc = pn_tdo
       and a.pendoc = pc_ndo;
    commit;
    --execute immediate('truncate table jaqz081');
    begin
      insert into jaqz081
        (PGCOD,
         AOMOD,
         AOSUC,
         AOMDA,
         AOPAP,
         AOCTA,
         AOOPER,
         AOSBOP,
         AOTOPE,
         AOFVAL,
         AOFVTO,
         AOFE99,
         AOSTAT,
         PEPAIS,
         PETDOC,
         PENDOC,
         FEUSO)
        select B.PGCOD,
               b.aomod,
               b.aosuc,
               b.aomda,
               b.aopap,
               b.aocta,
               b.aooper,
               b.aosbop,
               b.aotope,
               b.aofval,
               b.aofvto,
               pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,
                                              AOMOD,
                                              AOSUC,
                                              AOMDA,
                                              AOPAP,
                                              AOCTA,
                                              AOOPER,
                                              AOSBOP,
                                              AOTOPE,
                                              aostat,
                                              aofe99),
               --b.aofe99,
               b.aostat,
               a.pepais,
               a.petdoc,
               a.pendoc,
               --(case when aostat <> 99 then aofvto
               --else aofe99 end )FEUSO
               
               (case
                 when aostat <> 99 then
                  aofvto
                 else
                  pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,
                                                 AOMOD,
                                                 AOSUC,
                                                 AOMDA,
                                                 AOPAP,
                                                 AOCTA,
                                                 AOOPER,
                                                 AOSBOP,
                                                 AOTOPE,
                                                 aostat,
                                                 aofe99)
               end) FEUSO
        
          from fsr008 a, fsd010 b
         where a.pgcod = 1
           and a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and a.cttfir = 'T'
           and b.pgcod = a.pgcod
           and b.aocta = a.ctnro
           and aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (200, 33, 108))
           and (aofe99 >= ld_fecini or
               aofe99 = to_date('0001.01.01', 'yyyy.mm.dd'))
           and aotope <> 550;
    
      commit;
    end;
  
  
    /*INVOCAR 2 FUNCIONES UNA DE FRECUENCIA MENSUAL Y LA OTRA DE NO MENSUAL*/
  
    PQ_CR_MANTENIMIENTO_PYME.Sp_cr_histDiaAtr_linea_m (pn_pai,
                                                       pn_tdo,
                                                       pc_ndo,
                                                       Pd_fecpro,
                                                       ld_fecini,
                                                       ln_contadorM,
                                                       ln_diaM);
    
    PQ_CR_MANTENIMIENTO_PYME.Sp_cr_histDiaAtr_linea_nm(pn_pai,
                                                       pn_tdo,
                                                       pc_ndo,
                                                       Pd_fecpro,
                                                       ld_fecini,
                                                       ln_contadorNM,
                                                       ln_diaNM,
                                                       ln_diaMax); --dias de atraso maximo 
    
   
                                                       
    if (ln_contadorM + ln_contadorNM - (case when ln_diaMax > 0 then 1 else 0 end) ) = 0 then
      --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
      ln_promedio := 0;
    else
      ln_promedio := round(
                     ( ( (ln_diaM + ln_diaNM) - (case when ln_diaMax > 0 then ln_diaMax else 0 end) ) 
                       / 
                     (ln_contadorM + ln_contadorNM - (case when ln_diaMax > 0 then 1 else 0 end) ) ), 2);
    end if;
  
    --      Sp_cr_histDiaAtr_linea
  end Sp_DiaAtraso_linea;
-----------------------------------------------------------------------------------------------------------------------
  Procedure Sp_cr_histDiaAtr_linea_m ( pn_pai        in number,
                                       pn_tdo        in number,
                                       pc_ndo        in char,
                                       pd_fecpro     in date,
                                       pd_fecini     in date,
                                       ln_contCuoTot out number,
                                       ln_diaTot     out number) is
     
    -- *****************************************************************
    -- Nombre                     : Sp_cr_histDiaAtr_linea_m
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/11/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el promedio de dias de atraso de creditos de frecuencia mensual
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************                                   
  
    cursor creditos is
      select a.*
        from jaqz081 a, fsd010 c
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.pgcod = c.pgcod -- yyampi 09/11/2021 periocidad mensual
         and a.aomod = c.aomod -- yyampi 09/11/2021 periocidad mensual
         and a.aosuc = c.aosuc -- yyampi 09/11/2021 periocidad mensual
         and a.aomda = c.aomda -- yyampi 09/11/2021 periocidad mensual
         and a.aopap = c.aopap -- yyampi 09/11/2021 periocidad mensual
         and a.aocta = c.aocta -- yyampi 09/11/2021 periocidad mensual
         and a.aooper = c.aooper -- yyampi 09/11/2021 periocidad mensual
         and a.aosbop = c.aosbop -- yyampi 09/11/2021 periocidad mensual
         and a.aotope = c.aotope -- yyampi 09/11/2021 periocidad mensual
         and c.aoperiod = 30 -- yyampi 09/11/2021 periocidad mensual        
       order by a.aostat, a.aofe99 desc, a.aofval desc; --aofe99;--aofval DESC;
       
    /*cursor creditos is
    select B.PGCOD,
                       b.aomod,
                       b.aosuc,
                       b.aomda,
                       b.aopap,
                       b.aocta,
                       b.aooper,
                       b.aosbop,
                       b.aotope,
                       b.aofval,
                       b.aofvto,
                       pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                              AOSBOP,AOTOPE,aostat,aofe99)aofe99,
                       --b.aofe99,
                       b.aostat,
                       a.pepais,
                       a.petdoc,
                       a.pendoc,
                       (case when aostat <> 99 then aofvto
                       else aofe99 end )FEUSO
                  from fsr008 a, fsd010 b
                 where a.pgcod = 1
                   and a.pepais = pn_pai
                   and a.petdoc = pn_tdo
                   and a.pendoc = pc_ndo
                   and a.cttfir = 'T'
                   and b.pgcod = a.pgcod
                   and b.aocta = a.ctnro
                   and aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108)) 
                   and (aofe99 >= pd_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                   and aotope <> 550;*/
  
    --ln_contador number(5);    
    ld_fecantD date;
    ld_fecantC date;
    --ln_aux number(4);
    ln_mesac number(2);
    ln_aniac number(4);
    ln_mesan number(2);
    ln_anian number(4);
    ln_suma  number(5);
  
    ld_aofval date;
    ld_aofe99 date;
    --ld_dia number(2);
    ld_feccorte date;
    ln_auxiliar number(5);
    ld_fecdes   date;
    ld_fecaux   date;
    lc_fecaux   char(6);
    ld_sysdate  date;
  
    --ln_contCuoTot number(5);
    --ln_diaTot number(5);
    ln_contador number(18);
  
    ln_sw number(1);
    ln_diaMax number(18):=0;
    
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      --ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    
      For i in creditos loop
        ln_sw := 0;
        if (i.aofe99 is null or
           i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
           i.aostat = 99 then
          ln_sw := 1;
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.aofe99, 'mm'));
          ln_aniac  := to_number(to_char(i.aofe99, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.aofval;
          ld_aofe99 := last_day(i.aofe99);
          --ld_aofe99 := last_day(i.aofe99);
          ld_fecdes  := i.aofval;
          ld_sysdate := last_day(pd_fecpro);
        
          if ld_aofval < pd_fecini then
            ld_aofval := pd_fecini;
          end if;
        
          if i.aostat <> 99 then
            ld_aofe99 := pd_fecpro;
          end if;
        
          if ld_fecantD is null then
            if i.aostat = 99 then
              ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            else
              ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            
            end if;
          
          Else
          
            if ld_aofe99 = ld_fecantD or
               (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
              if i.aostat = 99 then
                ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              
              else
                ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              end if;
            
            else
              if ld_aofe99 > ld_fecantD then
                --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                ld_aofe99 := last_day(ld_fecantD);
                if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if;*/
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if; */
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                end if;
              
              end if;
            
              if ld_aofe99 < ld_fecantD then
              
                if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                end if;
              
              end if;
            
            end if;
          
          end if;
        
          /*if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
             if ld_fecantC > i.aofval then
                ld_aofval := ld_fecantC;
             end if;
             ld_fecantC := pd_fecpro;
          end if;
          
          if i.aofe99 > ld_fecantC then
                       --ld_fecantD := ld_aofval;
                       ld_fecantC := i.aofe99;
          
          end if;*/
        
          --if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
          ld_fecantD := ld_aofval;
          ld_fecantC := i.aofe99;
        
          ln_mesan := to_number(to_char(ld_fecantD, 'mm'));
          ln_anian := to_number(to_char(ld_fecantD, 'yyyy'));
        
          if ln_contador = 12 then
            --ld_feccorte := i.aofval;
            lc_fecaux   := to_char(ld_aofval, 'yyyymm');
            ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
            exit;
            /*if ln_contador = 12 then
               ld_feccorte := ld_fecdes;
               pq_cr_relcrediticia.sp_calculaCuotas(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                                                 i.aooper,i.aosbop,i.aotope,pd_fecpro,
                                                 ln_contCuotas,ln_dia);
                ln_diaTot := ln_diaTot + ln_dia;
                ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
            
               exit;
            end if;*/
            /*pq_cr_relcrediticia.sp_calculaCuotas(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                                                 i.aooper,i.aosbop,i.aotope,pd_fecpro,
                                                 ln_contCuotas,ln_dia);
            ln_diaTot := ln_diaTot + ln_dia;
            ln_contCuoTot := ln_contCuoTot + ln_contCuotas;*/
          
          end if;
          if ln_contador > 12 then
            ln_auxiliar := ln_contador - 12;
            ld_fecaux   := add_months(ld_aofval, ln_auxiliar);
            lc_fecaux   := to_char(ld_fecaux, 'yyyymm');
            ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
            exit;
          end if;
          ld_feccorte := ld_aofval;
        end if;
      end loop;
      pq_cr_mantenimiento_pyme.Sp_cr_histDiaAtr_linea_ii(pn_pai,
                                                    pn_tdo,
                                                    pc_ndo,
                                                    ld_feccorte,
                                                    pd_fecpro, /*pd_fecini,*/
                                                    'M', --mensual
                                                    ln_contCuoTot,
                                                    ln_diaTot,
                                                    ln_diaMax);
    
    end;
  end Sp_cr_histDiaAtr_linea_m;

-----------------------------------------------------------------------------------------------------------------------
  Procedure Sp_cr_histDiaAtr_linea_nm (pn_pai        in number,
                                       pn_tdo        in number,
                                       pc_ndo        in char,
                                       pd_fecpro     in date,
                                       pd_fecini     in date,
                                       ln_contCuoTot out number,
                                       ln_diaTot     out number,
                                       ln_diaMax     out number                                        
                                       ) is
     
    -- *****************************************************************
    -- Nombre                     : Sp_cr_histDiaAtr_linea_nm
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/11/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el promedio de dias de atraso de creditos de frecuencia no mensual
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************                                   
  
    cursor creditos is
      select a.*
        from jaqz081 a, fsd010 c
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.pgcod = c.pgcod -- yyampi 09/11/2021 periocidad diferente a mensual
         and a.aomod = c.aomod -- yyampi 09/11/2021 periocidad diferente a mensual
         and a.aosuc = c.aosuc -- yyampi 09/11/2021 periocidad diferente a mensual
         and a.aomda = c.aomda -- yyampi 09/11/2021 periocidad diferente a mensual
         and a.aopap = c.aopap -- yyampi 09/11/2021 periocidad diferente a mensual
         and a.aocta = c.aocta -- yyampi 09/11/2021 periocidad diferente a mensual
         and a.aooper = c.aooper -- yyampi 09/11/2021 periocidad diferente a mensual
         and a.aosbop = c.aosbop -- yyampi 09/11/2021 periocidad diferente a mensual
         and a.aotope = c.aotope -- yyampi 09/11/2021 periocidad diferente a mensual
         and c.aoperiod <> 30 -- yyampi 09/11/2021 periocidad diferente a mensual        
         
       order by a.aostat, a.aofe99 desc, a.aofval desc; --aofe99;--aofval DESC;
    /*cursor creditos is
    select B.PGCOD,
                       b.aomod,
                       b.aosuc,
                       b.aomda,
                       b.aopap,
                       b.aocta,
                       b.aooper,
                       b.aosbop,
                       b.aotope,
                       b.aofval,
                       b.aofvto,
                       pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                              AOSBOP,AOTOPE,aostat,aofe99)aofe99,
                       --b.aofe99,
                       b.aostat,
                       a.pepais,
                       a.petdoc,
                       a.pendoc,
                       (case when aostat <> 99 then aofvto
                       else aofe99 end )FEUSO
                  from fsr008 a, fsd010 b
                 where a.pgcod = 1
                   and a.pepais = pn_pai
                   and a.petdoc = pn_tdo
                   and a.pendoc = pc_ndo
                   and a.cttfir = 'T'
                   and b.pgcod = a.pgcod
                   and b.aocta = a.ctnro
                   and aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108)) 
                   and (aofe99 >= pd_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                   and aotope <> 550;*/
  
    --ln_contador number(5);    
    ld_fecantD date;
    ld_fecantC date;
    --ln_aux number(4);
    ln_mesac number(2);
    ln_aniac number(4);
    ln_mesan number(2);
    ln_anian number(4);
    ln_suma  number(5);
  
    ld_aofval date;
    ld_aofe99 date;
    --ld_dia number(2);
    ld_feccorte date;
    ln_auxiliar number(5);
    ld_fecdes   date;
    ld_fecaux   date;
    lc_fecaux   char(6);
    ld_sysdate  date;
  
    --ln_contCuoTot number(5);
    --ln_diaTot number(5);
    ln_contador number(18);
  
    ln_sw number(1);
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      --ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    
      For i in creditos loop
        ln_sw := 0;
        if (i.aofe99 is null or
           i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
           i.aostat = 99 then
          ln_sw := 1;
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.aofe99, 'mm'));
          ln_aniac  := to_number(to_char(i.aofe99, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.aofval;
          ld_aofe99 := last_day(i.aofe99);
          --ld_aofe99 := last_day(i.aofe99);
          ld_fecdes  := i.aofval;
          ld_sysdate := last_day(pd_fecpro);
        
          if ld_aofval < pd_fecini then
            ld_aofval := pd_fecini;
          end if;
        
          if i.aostat <> 99 then
            ld_aofe99 := pd_fecpro;
          end if;
        
          if ld_fecantD is null then
            if i.aostat = 99 then
              ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            else
              ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            
            end if;
          
          Else
          
            if ld_aofe99 = ld_fecantD or
               (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
              if i.aostat = 99 then
                ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              
              else
                ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              end if;
            
            else
              if ld_aofe99 > ld_fecantD then
                --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                ld_aofe99 := last_day(ld_fecantD);
                if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if;*/
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if; */
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                end if;
              
              end if;
            
              if ld_aofe99 < ld_fecantD then
              
                if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                end if;
              
              end if;
            
            end if;
          
          end if;
        
          /*if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
             if ld_fecantC > i.aofval then
                ld_aofval := ld_fecantC;
             end if;
             ld_fecantC := pd_fecpro;
          end if;
          
          if i.aofe99 > ld_fecantC then
                       --ld_fecantD := ld_aofval;
                       ld_fecantC := i.aofe99;
          
          end if;*/
        
          --if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
          ld_fecantD := ld_aofval;
          ld_fecantC := i.aofe99;
        
          ln_mesan := to_number(to_char(ld_fecantD, 'mm'));
          ln_anian := to_number(to_char(ld_fecantD, 'yyyy'));
        
          if ln_contador = 36 then
            --ld_feccorte := i.aofval;
            lc_fecaux   := to_char(ld_aofval, 'yyyymm');
            ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
            exit;
            /*if ln_contador = 12 then
               ld_feccorte := ld_fecdes;
               pq_cr_relcrediticia.sp_calculaCuotas(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                                                 i.aooper,i.aosbop,i.aotope,pd_fecpro,
                                                 ln_contCuotas,ln_dia);
                ln_diaTot := ln_diaTot + ln_dia;
                ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
            
               exit;
            end if;*/
            /*pq_cr_relcrediticia.sp_calculaCuotas(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                                                 i.aooper,i.aosbop,i.aotope,pd_fecpro,
                                                 ln_contCuotas,ln_dia);
            ln_diaTot := ln_diaTot + ln_dia;
            ln_contCuoTot := ln_contCuoTot + ln_contCuotas;*/
          
          end if;
          if ln_contador > 36 then
            ln_auxiliar := ln_contador - 36;
            ld_fecaux   := add_months(ld_aofval, ln_auxiliar);
            lc_fecaux   := to_char(ld_fecaux, 'yyyymm');
            ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
            exit;
          end if;
          ld_feccorte := ld_aofval;
        end if;
      end loop;
      pq_cr_mantenimiento_pyme.Sp_cr_histDiaAtr_linea_ii( pn_pai,
                                                          pn_tdo,
                                                          pc_ndo,
                                                          ld_feccorte,
                                                          pd_fecpro, /*pd_fecini,*/
                                                          'O', --no mensual
                                                          ln_contCuoTot,
                                                          ln_diaTot,
                                                          ln_diaMax );
    
    end;
  end Sp_cr_histDiaAtr_linea_nm;
-----------------------------------------------------------------------------------------------------------------------

  Procedure Sp_cr_histDiaAtr_linea_ii ( pn_pai        in number,
                                       pn_tdo        in number,
                                       pc_ndo        in char,
                                       pd_fecor      in date,
                                       pd_fecpro     in date, 
                                       pc_periodo    in char, 
                                       ln_contCuoTot out number,
                                       ln_diaTot     out number,
                                       ln_diaMax     out number
                                      )  is
  
      -- *****************************************************************
    -- Nombre                     : Sp_cr_histDiaAtr_linea_nm
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/11/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el promedio de dias de atraso de creditos de frecuencia no mensual
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************     
  
    cursor creditos is    
      select 
           a.pgcod,a.aomod,a.aosuc,a.aomda,a.aopap,a.aocta,a.aooper,a.aosbop,
           a.aotope,a.aofval,a.aofvto,a.aofe99,a.aostat,a.pepais,a.petdoc,
           a.pendoc,a.feuso  -- yyampi 09/11/2021 se agrego fsd010
        FROM JAQZ081 a , fsd010 c
       WHERE a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.feuso >= pd_fecor
         and a.pgcod = c.pgcod
         and a.aomod = c.aomod
         and a.aosuc = c.aosuc
         and a.aomda = c.aomda
         and a.aopap = c.aopap
         and a.aocta = c.aocta
         and a.aooper = c.aooper
         and a.aosbop = c.aosbop
         and a.aotope = c.aotope
         and decode(c.aoperiod,30,'M','O') = pc_periodo -- yyampi 09/11/2021 periocidad diferente a mensual  
       order by a.aofval desc;
  
    
  
    ln_contCuotas number(18);
    ln_dia        number(18);
    
    ln_diaMaxAux  number(18) := 0;  --dias de atraso maximo temporal
  
    ld_feccan date;
  begin
    ln_diaMax     := 0;  --dias de atraso maximo
    begin
      ln_contCuoTot := 0;
      ln_diaTot     := 0;
      for i in creditos loop
        if i.aostat = 99 then
          --                ld_feccan := last_day(i.aofe99);
          ld_feccan := i.aofe99;
        else
          --ld_feccan := last_day(pd_fecpro);
          ld_feccan := pd_fecpro;
        end if;
        pq_cr_mantenimiento_pyme.Sp_CalculaCuotas_dmax(    i.pgcod,
                                                           i.aomod,
                                                           i.aosuc,
                                                           i.aomda,
                                                           i.aopap,
                                                           i.aocta,
                                                           i.aooper,
                                                           i.aosbop,
                                                           i.aotope,
                                                           ld_feccan,
                                                           pd_fecor,
                                                           i.aostat,
                                                           ln_contCuotas,
                                                           ln_dia, 
                                                           ln_diaMaxAux
                                                           );
        
        /*Se obtiene el maximo dia de atraso*/
        if ln_diaMax <= ln_diaMaxAux then
            ln_diaMax := ln_diaMaxAux;
        end if;                                                    
                                                           
        ln_diaTot     := ln_diaTot + ln_dia;
        ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
      end loop;
    
    end;
    
    null;
  
  end Sp_cr_histDiaAtr_linea_ii;
  ---------------------------------------------------------------------------------------------

  Procedure Sp_num_excepciones_segm (pn_pai      in number,
                                   pn_tdo      in number,
                                   pc_ndo      in char,
                                   ln_numexc out number) is
                               
  -- *****************************************************************
    -- Nombre                     : Sp_num_excepciones_segm
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/11/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el numero de excepciones de instancias por titular
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************                             
  
    ld_fecini   date;
    ln_vig      number(9);
    --ln_numexc number(18) := 0;
    ln_diaMax number(18) := 0;
    
  begin
  
    ln_numexc := 0;
    
    /*select count(distinct e.jaqz870inst) 
           into ln_numexc 
    from JAQZ870 e,  --TABLA DE EXCEPCIONES 
         sng001 i   
          where e.jaqz870inst = i.sng001inst
          and i.sng001pais = pn_pai
          and i.sng001tdoc = pn_tdo
          and i.sng001ndoc = pc_ndo;*/
          
   select /*+ all_rows */ 
    count(distinct e.jaqz870inst)     
         into ln_numexc 
    from JAQZ870 e,  --TABLA DE EXCEPCIONES 
         sng001 i , 
         xwf700 f,
         fsd010 c  --creditos desembolsados 
          where e.jaqz870inst = i.sng001inst
          and i.sng001pais = pn_pai
          and i.sng001tdoc = pn_tdo
          and i.sng001ndoc = pc_ndo
          and f.xwfprcins = i.sng001inst
          and f.xwfempresa = c.pgcod
          and f.xwfcuenta = c.aocta
          and f.xwfoperacion = c.aooper
          and f.xwfmodulo = c.aomod
          and f.xwfmoneda = c.aomda 
          and f.xwfpapel = c.aopap  ; 
          
    exception
      when others then
        ln_numexc := 0; --cambiar en produccion
    
   
    --      Sp_cr_histDiaAtr_linea
  end Sp_num_excepciones_segm;  
  
  --------------------------------------------------------------------------------------------



Procedure Sp_num_pagos (pn_pai      in number,
                       pn_tdo      in number,
                       pc_ndo      in char,
                       pd_fecpro   in date,
                       ln_numpag out number) is
                               
  -- *****************************************************************
    -- Nombre                     : Sp_num_pagos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/11/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el numero de pagos por cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************                             
  
    ld_fecini   date;
    ln_vig      number(9);
    --ln_numexc number(18) := 0;
    ln_mesPagos  number(18) := 0; --meses de pagos a evaluar 
    
  begin
  
    ln_numpag := 0;
    
    begin
       
       select t.tp1nro1
         into ln_mesPagos
         from fst198 t
        where t.tp1cod = 1
          and t.tp1cod1 = 11149
          and t.tp1corr1 = 4;
          
        ld_fecini := add_months(pd_fecpro, -1*ln_mesPagos);  --se obtiene la fecha inicial de evaluacion de pago
          
    exception when others then 
         ln_mesPagos := 0;
         ld_fecini := pd_fecpro;
      end ; 
    
        begin 
           
            select /*+ all_rows */ max(pagos) into ln_numpag 
            from  
              (
              select /*+ all_rows */
                     tot.pgcod,tot.ppmod,tot.ppsuc,tot.ppmda,tot.pppap,tot.ppcta,tot.ppoper,tot.ppsbop,tot.pptope, 
                     count(distinct tot.ppfpag) pagos
              from (
              select /*+ all_rows */
                    distinct t.pgcod,
                             t.ppmod,
                             t.ppsuc,
                             t.ppmda,
                             t.pppap,
                             t.ppcta,
                             t.ppoper,
                             t.ppsbop,
                             t.pptope,
                             t.ppfpag,
                             t.pp1stat
                      from fsd602 t, --calendario de pagos  
                           fsr008 r, --relaciones de cuenta cliente 
                           fsd010 c, --tabla de operaciones 
                           fst198 g --guia de proceso especiales 
                     where t.pgcod = c.pgcod
                       and t.ppmod = c.aomod
                       and t.ppsuc = c.aosuc
                       and t.ppmda = c.aomda
                       and t.pppap = c.aopap
                       and t.ppcta = c.aocta
                       and t.ppoper = c.aooper
                       and t.ppsbop = c.aosbop
                       and t.pptope = c.aotope
                       and t.pp1stat = 'T' --pago completo
                       and t.d602co = 'S' --contabilizado
                       and r.ctnro = c.aocta
                       and r.cttfir = 'T' --titular
                       and r.ttcod = 1 --titular representativo
                       and r.pendoc = pc_ndo --
                       and r.pepais = pn_pai --
                       and r.petdoc = pn_tdo --
                       and c.aocta = r.ctnro
                       and c.pgcod = r.pgcod
                       and t.ppfpag between ld_fecini and pd_fecpro
                       and t.d602cd = 1
                       and t.d602mo = g.tp1nro1 --modulo
                       and t.d602tr = g.tp1nro2 --transaccion
                       and g.tp1cod = 1 --guia de transacciones de pago
                       and g.tp1cod1 = 11149 --guia de transacciones de pago
                       and g.tp1corr1 = 3 --guia de transacciones de pago
                       and g.tp1corr2 = 1 --guia de transacciones de pago
                       and c.aoperiod = 30
                       ) tot
                       group by 
                         tot.pgcod,tot.ppmod,tot.ppsuc,tot.ppmda,tot.pppap,tot.ppcta,tot.ppoper,tot.ppsbop,tot.pptope
                       );
                    
        exception when others then 
          ln_numpag :=0;
          end;
      
    exception
      when others then
        ln_numpag := 0; --cambiar en produccion
     
  end Sp_num_pagos;  
  
  --------------------------------------------------------------------------------------------
  procedure sp_cr_calificacion_rcc(
                                    pn_cta number,
                                    pn_result out number
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_calificacion_rcc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/09/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna calificacion rcc para todos los titulares 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
    select /*+ all_rows */ distinct r.pepais, r.petdoc, r.pendoc, trim(r.pendoc) pendoc2
      from fsr008 r
    where r.ctnro = pn_cta    
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
begin
  pn_result := 100.00; --
  
            
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then 
          ld_fecrcc := null;
      end; 
   
  for ti in titulares  loop   
        
      /*obtener tipo de persona (Juridica o natural) */
      begin 
        select t.petipo into ln_petipo 
        from fsd001 t
        where t.pepais = ti.pepais
              and t.petdoc = ti.petdoc
              and t.pendoc = ti.pendoc;
      exception when others then 
       DBMS_OUTPUT.put_line(SQLERRM);                        
      end;
      
      /*Calculo de tipo de documento SBS*/
      begin 
          select t.tp1corr3 into ln_tipdocSBS 
          from FST198 t 
          where t.tp1cod = 1 and t.tp1cod1 = 11111
               and t.tp1corr1 = 1 and t.tp1corr2 = 3
               and t.tp1nro1 =  ti.petdoc; 
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                 
      end;
      
      /*Obtencion de la calificacion*/
      begin 
        if ln_petipo = 'F' then           
          select c.n_calif0, c.n_calif1, c.n_calif2, c.n_calif3, c.n_calif4
            into ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4
            from CLDRCCI c
           Where D_FECPRE = ld_fecrcc
             and C_TDOCID = ln_tipdocSBS
             and C_DOCIDE = ti.pendoc2;
             
             if ln_calif0 < 100  then 
                 pn_result :=0;
                 exit;
             end if;
          end if;     
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                               
      end; 
            
      
      begin 
          if ln_petipo = 'J' then
            select  c.n_calif0, c.n_calif1, c.n_calif2, c.n_calif3, c.n_calif4
            into ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4
            from CLDRCCI c
             Where D_FECPRE = ld_fecrcc
                and C_TDOCTR = ln_tipdocSBS
                and C_DOCTRI = ti.pendoc2 ;
                
            if ln_calif0 < 100  then 
                 pn_result :=0;
                 exit;
            end if;
          
        end if ;  
        
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                               
      end;
      
     end loop; 
      
      
  
 
       
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
  
end sp_cr_calificacion_rcc;
--------------------------------------------------------------------------------------------------

  procedure sp_num_entidades_rcc(
                                    pn_cta number,
                                    pn_result out number
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_num_entidades_rcc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/09/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el numero de entidades por todos los titulares 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
    select /*+ all_rows */ distinct r.pepais, r.petdoc, r.pendoc, trim(r.pendoc) pendoc2
      from fsr008 r
    where r.ctnro = pn_cta    
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
begin
  pn_result := 0; --
  
            
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then 
          ld_fecrcc := null;
      end; 
   
  for ti in titulares  loop   
        
      /*obtener tipo de persona (Juridica o natural) */
      begin 
        select t.petipo into ln_petipo 
        from fsd001 t
        where t.pepais = ti.pepais
              and t.petdoc = ti.petdoc
              and t.pendoc = ti.pendoc;
      exception when others then 
       DBMS_OUTPUT.put_line(SQLERRM);                        
      end;
      
      /*Calculo de tipo de documento SBS*/
      begin 
          select t.tp1corr3 into ln_tipdocSBS 
          from FST198 t 
          where t.tp1cod = 1 and t.tp1cod1 = 11111
               and t.tp1corr1 = 1 and t.tp1corr2 = 3
               and t.tp1nro1 =  ti.petdoc; 
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                 
      end;
      
      /*Obtencion del codigo SBS*/
      begin 
        if ln_petipo = 'F' then           
          select c.c_codsbs
            into lv_codSBS
            from CLDRCCI c
           Where D_FECPRE = ld_fecrcc
             and C_TDOCID = ln_tipdocSBS
             and C_DOCIDE = ti.pendoc2;
         end if;     
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                               
      end;            
      
      begin 
          if ln_petipo = 'J' then
            select c.c_codsbs
            into lv_codSBS 
            from CLDRCCI c
             Where D_FECPRE = ld_fecrcc
                and C_TDOCTR = ln_tipdocSBS
                and C_DOCTRI = ti.pendoc2 ;                     
          end if;                  
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                               
      end;
      
      
      
      /*Calcula la cantidad de entidades con deuda */
      
          select /*+ ALL_ROWS */
           count(distinct c.c_codemp)
           INTO ln_cantent
            FROM CLDRCCS C
           WHERE C.C_CODSBS = lv_codSBS 
             AND C.D_FECPRE = ld_fecrcc 
             AND C.C_CODEMP <> '00104' -- EXCLUYE DEUDAS CON CAJA AREQUIPA 
             AND C.C_CRETIP NOT IN ('11', '12') --EXCLUYE CONSUMO REVOLVENTE Y NO REVOLVENTE
             AND ((SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
                 SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6')) --CREDITOS DIRECTOS
                 OR (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND
                 SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2', '3', '4')) --CREDITOS INDIRECTOS
                 OR (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND
                 SUBSTR(C.C_CUENTA, 4, 3) = '302') --CREDITOS CASTIGADOS
                 OR
                 (SUBSTR(C.C_CUENTA, 1, 2) = '72' AND SUBSTR(C.C_CUENTA, 4, 1) = '5' AND C.N_SALCAP > 0) ----LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
                 );
         
                 ln_cantentot := ln_cantentot + ln_cantent;  --acumula todas las entidades con deuda de cada titular  
         
     end loop; 
      
     pn_result := ln_cantentot;
      
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
  
end sp_num_entidades_rcc;
--------------------------------------------------------------------------------------------------

  procedure sp_relacion_crediticia(
                                    pn_cta number,
                                    pn_result out number
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_relacion_crediticia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/09/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el numero de meses sin relacion crediticia de todos los integrantes de la cuenta 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
    select /*+ all_rows */ distinct r.pepais, r.petdoc, r.pendoc, trim(r.pendoc) pendoc2
      from fsr008 r
    where r.ctnro = pn_cta    
    ;
   
    
    ln_meses_eva number(9); --numero de meses de evaluacion la relacion crediticia
    ld_fecpro date; -- fecha de proceso 
    ln_rela number(10) :=0; --contador de meses de relacion crediticia
    ln_rela_cre number(10) :=0; -- contador final de meses de relacion crediticia
    
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
begin
  pn_result := 0; --
  
            
     /*obtiene el numero de meses de evaluacion */
     begin
        select t.tp1nro1
          into ln_meses_eva
          from Fst198 t
         Where t.tp1cod = 1
           and t.tp1cod1 = 11149
           and t.tp1corr1 = 5;
      exception when others then 
          ln_meses_eva := null;
      end; 
      
      /*se obtiene la fecha de proceso*/
      begin 
        select t.pgfape 
        into ld_fecpro
        from fst017 t where t.pgcod = 1; 
      exception when others then
        ld_fecpro := null; 
      end;   
   
  for ti in titulares  loop   
        
    pq_cr_mantenimiento_pyme.Sp_cr_ReCalcula(pn_pais     => ti.pepais,
                                             pn_tdo      => ti.petdoc,
                                             pc_ndo      => ti.pendoc,
                                             pd_fecpro   => ld_fecpro,
                                             ln_contador => ln_rela);
                                             
     /*se obtiene los dias sin relacion crediticia mayor */
     if  ln_rela_cre < (/*ln_meses_eva -*/ nvl(ln_rela,0))    then 
         ln_rela_cre := (/*ln_meses_eva -*/ nvl(ln_rela,0)); 
       end if ;
                                            
     end loop; 
      
     pn_result := ln_rela_cre;
      
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
  
end sp_relacion_crediticia;

--------------------------------------------------------------------------------------------------

  procedure sp_relacion_crediticia_inv(
                                      pn_cta number,
                                      pn_result out number
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_relacion_crediticia inversa - inactividad
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/09/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el numero de meses sin relacion crediticia de todos los integrantes de la cuenta 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
    select /*+ all_rows */ distinct r.pepais, r.petdoc, r.pendoc, trim(r.pendoc) pendoc2
      from fsr008 r
    where r.ctnro = pn_cta    
    ;
   
    
    ln_meses_eva number(9); --numero de meses de evaluacion la relacion crediticia
    ld_fecpro date; -- fecha de proceso 
    ln_rela number(10) :=0; --contador de meses de relacion crediticia
    ln_rela_cre number(10) ; -- contador final de meses de relacion crediticia
    
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
begin
  pn_result := 0; --
  
            
     /*obtiene el numero de meses de evaluacion */
     begin
        select t.tp1nro1
          into ln_meses_eva
          from Fst198 t
         Where t.tp1cod = 1
           and t.tp1cod1 = 11149
           and t.tp1corr1 = 5;           
           ln_rela_cre := ln_meses_eva;
           
      exception when others then 
          ln_meses_eva := 36;
          ln_rela_cre := ln_meses_eva;
           
      end; 
      
      /*se obtiene la fecha de proceso*/
      begin 
        select t.pgfape 
        into ld_fecpro
        from fst017 t where t.pgcod = 1; 
      exception when others then
        ld_fecpro := null; 
      end;   
   
  for ti in titulares  loop   
        
    pq_cr_mantenimiento_pyme.Sp_cr_ReCalcula_inv(pn_pais     => ti.pepais,
                                             pn_tdo      => ti.petdoc,
                                             pc_ndo      => ti.pendoc,
                                             pd_fecpro   => ld_fecpro,
                                             ln_contador => ln_rela);
                                             
     /*se obtiene los dias sin relacion crediticia mayor */
     if  ln_rela_cre > (ln_meses_eva - nvl(ln_rela,0))    then 
         ln_rela_cre := (ln_meses_eva - nvl(ln_rela,0));
         
         if ln_rela_cre < 0 then 
           ln_rela_cre := 0;
         end if;
             
       end if ;
                                            
     end loop; 
      
     pn_result := ln_rela_cre;
      
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
  
end sp_relacion_crediticia_inv;
--------------------------------------------------------------------------------------------------


Procedure Sp_cr_ReCalcula(pn_pais     in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecpro   in date,
                            ln_contador out number) is
  
    ld_fecini date;
    ln_vig    number(9);
  begin
    begin
      select tp1nro1
        into ln_vig
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 2
         and tp1corr2 = 1;
    exception
      when others then
        ln_vig := 60;
      
    end;
  
    ld_fecini := add_months(pd_fecpro, -ln_vig);
    delete from jaqz075 a
     where a.pepais = pn_pais
       and a.petdoc = pn_tdo
       and a.pendoc = pc_ndo;
    commit;
    --execute immediate('truncate table jaqz075');
    begin
    
      insert into jaqz075
        (PGCOD,
         AOMOD,
         AOSUC,
         AOMDA,
         AOPAP,
         AOCTA,
         AOOPER,
         AOSBOP,
         AOTOPE,
         AOFVAL,
         AOFVTO,
         AOFE99,
         AOSTAT,
         PEPAIS,
         PETDOC,
         PENDOC)
        select pgcod,
               aomod,
               aosuc,
               aomda,
               aopap,
               aocta,
               aooper,
               aosbop,
               aotope,
               aofval,
               aofvto,
               aofe99,
               aostat,
               pepais,
               petdoc,
               pendoc
          from (select a.pgcod,
                       a.aomod,
                       a.aosuc,
                       a.aomda,
                       a.aopap,
                       a.aocta,
                       a.aooper,
                       a.aosbop,
                       a.aotope,
                       a.aofval,
                       a.aofvto,
                       --a.aofe99,
                       pq_cr_mantenimiento_pyme.Fn_DiaPago(a.PGCOD,
                                                      AOMOD,
                                                      AOSUC,
                                                      AOMDA,
                                                      AOPAP,
                                                      AOCTA,
                                                      AOOPER,
                                                      AOSBOP,
                                                      AOTOPE,
                                                      aostat,
                                                      a.aofe99) aofe99,
                       a.aostat,
                       b.pepais,
                       b.petdoc,
                       b.pendoc,
                       (case
                         when aofe99 = to_date('0001.01.01', 'yyyy.mm.dd') and
                              aostat = 99 and aofval < ld_fecini then
                          'N'
                         else
                          'S'
                       end) flag,
                       Case
                         when aomod = 110 and
                              aotope not in
                              (select a.tp1nro1
                                 from fst198 a
                                where a.tp1cod = 1
                                  and a.tp1cod1 = 10899
                                  and a.tp1corr1 = 5000
                                  and a.tp1corr2 = 1) then
                          'N'
                         else
                          'S'
                       end hipo
                  from fsr008 b, fsd010 a
                 where b.pgcod = 1
                   and b.pepais = pn_pais
                   and b.petdoc = pn_tdo
                   and b.pendoc = pc_ndo
                   and b.cttfir = 'T'
                   and a.pgcod = b.pgcod
                   and a.aocta = b.ctnro
                   and aomod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (200, 33/*, 108, 106, 107*/)) --cambio yyampi 17/03/2022
                      
                   and (aofe99 >= ld_fecini or
                       aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')))
         where flag = 'S'
           --and hipo = 'S' cambio yyampi 17/03/2022
           ;
    
      commit;
    
    end;
  
    pq_cr_mantenimiento_pyme.Sp_cr_InsNuevo(pn_pais,
                                       pn_tdo,
                                       pc_ndo,
                                       pd_fecpro,
                                       ld_fecini,
                                       ln_contador);
  
  end Sp_cr_ReCalcula;
---------------------------------------------------------------------------------------

Procedure Sp_cr_ReCalcula_inv(pn_pais     in number,
                              pn_tdo      in number,
                              pc_ndo      in char,
                              pd_fecpro   in date,
                              ln_contador out number) is
  
    ld_fecini date;
    ln_vig    number(9);
    ln_meses_eva number(9);
  begin
    begin
               
      select t.tp1nro1 
        into ln_meses_eva
          from Fst198 t
         Where t.tp1cod = 1
           and t.tp1cod1 = 11149
           and t.tp1corr1 = 5;
    exception
      when others then
        ln_meses_eva := 36;
      
    end;
  
    ld_fecini := add_months(pd_fecpro, -ln_meses_eva);
    delete from jaqz075 a
     where a.pepais = pn_pais
       and a.petdoc = pn_tdo
       and a.pendoc = pc_ndo;
    commit;
    --execute immediate('truncate table jaqz075');
    begin
    
      insert into jaqz075
        (PGCOD,
         AOMOD,
         AOSUC,
         AOMDA,
         AOPAP,
         AOCTA,
         AOOPER,
         AOSBOP,
         AOTOPE,
         AOFVAL,
         AOFVTO,
         AOFE99,
         AOSTAT,
         PEPAIS,
         PETDOC,
         PENDOC)
        select pgcod,
               aomod,
               aosuc,
               aomda,
               aopap,
               aocta,
               aooper,
               aosbop,
               aotope,
               aofval,
               aofvto,
               aofe99,
               aostat,
               pepais,
               petdoc,
               pendoc
          from (select a.pgcod,
                       a.aomod,
                       a.aosuc,
                       a.aomda,
                       a.aopap,
                       a.aocta,
                       a.aooper,
                       a.aosbop,
                       a.aotope,
                       a.aofval,
                       a.aofvto,
                       --a.aofe99,
                       pq_cr_mantenimiento_pyme.Fn_DiaPago(a.PGCOD,
                                                      AOMOD,
                                                      AOSUC,
                                                      AOMDA,
                                                      AOPAP,
                                                      AOCTA,
                                                      AOOPER,
                                                      AOSBOP,
                                                      AOTOPE,
                                                      aostat,
                                                      a.aofe99) aofe99,
                       a.aostat,
                       b.pepais,
                       b.petdoc,
                       b.pendoc,
                       (case
                         when aofe99 = to_date('0001.01.01', 'yyyy.mm.dd') and
                              aostat = 99 and aofval < ld_fecini then
                          'N'
                         else
                          'S'
                       end) flag,
                       Case
                         when aomod = 110 and
                              aotope not in
                              (select a.tp1nro1
                                 from fst198 a
                                where a.tp1cod = 1
                                  and a.tp1cod1 = 10899
                                  and a.tp1corr1 = 5000
                                  and a.tp1corr2 = 1) then
                          'N'
                         else
                          'S'
                       end hipo
                  from fsr008 b, fsd010 a
                 where b.pgcod = 1
                   and b.pepais = pn_pais
                   and b.petdoc = pn_tdo
                   and b.pendoc = pc_ndo
                   and b.cttfir = 'T'
                   and a.pgcod = b.pgcod
                   and a.aocta = b.ctnro
                   and aomod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (200, 33, 108, 106, 107))
                      
                   and (aofe99 >= ld_fecini or
                       aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')))
         where flag = 'S'
           and hipo = 'S';
    
      commit;
    
    end;
  
    pq_cr_mantenimiento_pyme.Sp_cr_InsNuevo(pn_pais,
                                       pn_tdo,
                                       pc_ndo,
                                       pd_fecpro,
                                       ld_fecini,
                                       ln_contador);
  
  end Sp_cr_ReCalcula_inv;
---------------------------------------------------------------------------------------


  Procedure Sp_cr_InsNuevo(pn_pais     in number,
                           pn_tdo      in number,
                           pc_ndo      in char,
                           pd_fecpro   in date,
                           pd_fecini   in date,
                           ln_contador out number) is
  
    cursor creditos is
      select *
        from jaqz075 a
       where a.pepais = pn_pais
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
  
    --ln_ins number(1);
    --ln_anio number(4);
    --ln_mes number(2);
  begin
  
    Begin
    
      --ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
      --ln_mes := to_number(to_char(pd_fecpro,'mm'));
    
      for i in creditos loop
        ln_contador := null;
        pq_cr_mantenimiento_pyme.Sp_cr_histNuevo(i.pepais,
                                            i.petdoc,
                                            i.pendoc,
                                            pd_fecini,
                                            pd_fecpro,
                                            ln_contador);
      
      end loop;
      commit;
    end;
  
  end Sp_cr_InsNuevo;
----------------------------------------------------------------------------------------------
  Procedure Sp_cr_histNuevo(pn_pai      in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecini   in date,
                            pd_fecpro   in date,
                            ln_contador out number) is
  
    cursor creditos is
      select *
        from jaqz075 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
       order by a.aofval;
  
    --ln_contador number(5);    
    ld_fecantD date;
    ld_fecantC date;
    --ln_aux number(4);
    ln_mesac number(2);
    ln_aniac number(4);
    ln_mesan number(2);
    ln_anian number(4);
    ln_suma  number(5);
  
    ld_aofval date;
    ld_aofe99 date;
    --ld_dia number(2);
  
    ln_sw      number(1);
    ld_sysdate date;
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      ld_sysdate  := last_day(pd_fecpro);
      For i in creditos loop
        ln_sw := 0;
        if i.aofe99 is null and i.aostat = 99 then
          ln_sw := 1;
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.aofval, 'mm'));
          ln_aniac  := to_number(to_char(i.aofval, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.aofval;
          ld_aofe99 := last_day(i.aofe99);
        
          if ld_aofval < pd_fecini then
            ld_aofval := pd_fecini;
          end if;
        
          if ld_fecantD is null then
            if i.aostat = 99 then
              ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            else
              ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            
            end if;
          
          Else
          
            if ld_aofval = ld_fecantC or
               (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
              if i.aostat = 99 then
                ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              
              else
                ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              end if;
            
            else
              if ld_aofval < ld_fecantC then
                --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                ld_aofval := ld_fecantC;
                if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if;*/
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if; */
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                end if;
              
              end if;
            
              if ld_aofval > ld_fecantC then
              
                if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                end if;
              
              end if;
            
            end if;
          
          end if;
        
          if i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd') then
            if ld_fecantC > i.aofval then
              ld_aofval := ld_fecantC;
            end if;
            ld_fecantC := trunc(pd_fecpro); --trunc(sysdate);
          end if;
        
          if i.aofe99 > ld_fecantC then
            --ld_fecantD := ld_aofval;
            ld_fecantC := i.aofe99;
          
          end if;
          ld_fecantD := ld_aofval;
        
          ln_mesan := to_number(to_char(ld_fecantC, 'mm'));
          ln_anian := to_number(to_char(ld_fecantC, 'yyyy'));
        
        end if;
      end loop;
    
    end;
    /*
    
    begin
     ln_contador := 0;  
     ld_fecantD := null;
     ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
     
     For i in creditos loop
         ln_mesac := to_number(to_char(i.jaqz075fva,'mm'));
         ln_aniac := to_number(to_char(i.jaqz075fva,'yyyy'));
         ln_suma := null;
         ld_aofval := i.jaqz075fva;
         ld_aofe99 := last_day(i.jaqz075f99);
         
         if ld_fecantD is null then
               if i.jaqz075est = 99 then
                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                  if ln_suma <0 then 
                     ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                  else 
                      ln_suma := trunc(months_between(trunc(sysdate),ld_aofval))+1;
                      if ln_suma <0 then 
                         ln_suma := 0;
                      end if;
                      ln_contador := ln_contador + ln_suma;
                  
               end if;
               
               Else
                    
                   if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                      if i.jaqz075est = 99 then
                           ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                            if ln_suma <0 then 
                               ln_suma := 0;
                            end if;       
                           ln_contador := ln_contador + ln_suma;
                           
                           else
                             ln_suma := trunc(months_between(trunc(sysdate),
                                                                ld_aofval));
                              if ln_suma <0 then 
                                 ln_suma := 0;
                              end if;          
                             ln_contador := ln_contador + ln_suma;
                       end if;
                       
                       else
                           if ld_aofval < ld_fecantC then
                              --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                              ld_aofval :=  ld_fecantC;
                              if i.jaqz075est = 99 then
                                   ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                    if ln_suma <0 then 
                                       ln_suma := 0;
                                    end if;  
                                
                                   ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                   
                                   else
                                     ln_suma := trunc(months_between(trunc(sysdate),ld_aofval));
                                      if ln_suma <0 then 
                                         ln_suma := 0;
                                      end if;        
                                     
                                     ln_contador := ln_contador + ln_suma;-- - ln_aux;
                               end if;
                                   
                           
                           
                           end if;
                           
                           if ld_aofval > ld_fecantC then
                              
                              if i.jaqz075est = 99 then
                                   ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                    if ln_suma <0 then 
                                       ln_suma := 0;
                                    end if;  
                                   ln_contador := ln_contador + ln_suma;
                                   
                                   else
                                     ln_suma := trunc(months_between(trunc(sysdate),ld_aofval))+1;
                                      if ln_suma <0 then 
                                         ln_suma := 0;
                                      end if;  
                                     ln_contador := ln_contador + ln_suma;
                               end if;
                                   
                           
                           
                           end if;
                       
                   
                   end if;
               
         end if;
         
         if i.jaqz075f99 = to_date('0001.01.01','yyyy.mm.dd') then
            if ld_fecantC > i.jaqz075fva then
               ld_aofval := ld_fecantC;
            end if;
            ld_fecantC := trunc(sysdate);
         end if;
         
         if i.jaqz075f99 > ld_fecantC then
                      ld_fecantD := ld_aofval;
                      ld_fecantC := i.jaqz075f99;
         
         end if;
         
         
         
         
         
         ln_mesan := to_number(to_char(ld_fecantC,'mm'));
         ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
     end loop;
     
    
    
    end;  */
  
  end Sp_cr_histNuevo;
--------------------------------------------------------------------------------
Function Fn_DiaPago(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pn_est in number,
                      pd_fec in date) return date is
    ld_fecpag date;
  
  begin
  
    begin
      if pn_est = 99 then
        if pd_fec = to_date('01.01.0001', 'dd.mm.yyyy') or pd_fec is null then
          begin
          
            Select max(pp1fech)
              into ld_fecpag
              from fsd602 a
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
               and a.d602co = 'S'
               and (a.pp1cap + a.pp1int) <> 0
               and a.pp1stat = 'T';
          exception
            when no_data_found then
              ld_fecpag := to_date('01.01.0001', 'dd.mm.yyyy');
            
          end;
        else
          ld_fecpag := pd_fec;
        end if;
      
      else
        ld_fecpag := to_date('01.01.0001', 'dd.mm.yyyy');
      end if;
      /*
      if pn_est = 0 then
         ld_fecpag := to_date('01.01.0001','dd.mm.yyyy');
         else
              if pd_fec = to_date('01.01.0001','dd.mm.yyyy') or  then
                 begin
                 
                      Select max(pp1fech)
                        into ld_fecpag
                        from fsd602 a
                       where a.pgcod = pn_emp
                         and a.ppmod = pn_mod
                         and a.ppsuc = pn_suc
                         and a.ppmda = pn_mda
                         and a.pppap = pn_pap
                         and a.ppcta = pn_cta
                         and a.ppoper = pn_ope
                         and a.ppsbop = pn_sbo
                         and a.pptope = pn_top
                         and a.d602co = 'S'
                         and a.pp1stat = 'T';
                 exception 
                         when no_data_found then
                              ld_fecpag := to_date('01.01.0001','dd.mm.yyyy'); 
      
                 end;
                 else
                     ld_fecpag := pd_fec;
              end if;        
      end if;*/
    end;
    return ld_fecpag;
  end Fn_DiaPago;
---------------------------------------------------------------------------

end PQ_CR_MANTENIMIENTO_PYME;
/

