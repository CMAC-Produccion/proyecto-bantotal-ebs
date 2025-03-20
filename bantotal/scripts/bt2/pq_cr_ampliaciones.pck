create or replace package PQ_CR_AMPLIACIONES is

  -- Author  : ABERNEDO
  -- Created : 15/01/2016 04:13:24 p.m.
  -- Purpose : 
  -- Autor Modificación: Cinthya Liz Hernandez Ortega
  -- Fecha : 11/02/2019
  -- Descripción: Se cambio guia para obtener cantidad de meses de obtencion de mora.

  Procedure sp_promedio_mora(lc_prgm      in varchar2,
                             lc_nmbvar    in varchar2,
                             lc_user      in varchar2,
                             ln_Instancia in number,
                             pn_pai       in number,
                             pn_tdo       in number,
                             pc_ndo       in char,
                             pd_fecpro    in date,
                             ln_promedio  out number,
                             pn_moramax   out number);

  Procedure Sp_CalculaCuotas(pn_emp      in number,
                             pn_mod      in number,
                             pn_suc      in number,
                             pn_mda      in number,
                             pn_pap      in number,
                             pn_cta      in number,
                             pn_ope      in number,
                             pn_sbo      in number,
                             pn_top      in number,
                             pd_fecpro   in date,
                             pd_fecorte  in date,
                             ln_contador out number,
                             ln_diasTot  out number);

  Procedure Sp_CalculaCuotas_New(pn_emp      in number,
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
                                 ln_periodo  in number, --MPOSTIGOC 
                                 ln_contador out number,
                                 ln_diasTot  out number,
                                 ln_diafin   out number);

  --------------------------------------------------------------                                 
  -- mpostigoc 06/11/2019                                 
  Procedure Sp_CalculaCuotas_NewLog(ld_FecProc   in date,
                                    lc_usuario   in varchar2,
                                    ln_instancia in number,
                                    ln_pais      in number,
                                    ln_tdocumnt  in number,
                                    lc_ndocumnt  in varchar2,
                                    pn_emp       in number,
                                    pn_mod       in number,
                                    pn_suc       in number,
                                    pn_mda       in number,
                                    pn_pap       in number,
                                    pn_cta       in number,
                                    pn_ope       in number,
                                    pn_sbo       in number,
                                    pn_top       in number,
                                    pd_fec       in date,
                                    pd_fecor     in date,
                                    pn_stat      in number,
                                    ln_periodo   in number,
                                    lc_EsPgrm    in varchar2,
                                    ln_contador  out number,
                                    ln_diasTot   out number,
                                    ln_diafin    out number);
  ---------------------------------------------------------------                                                                     
  Function Fn_CuotasPag(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pd_fecpro in date) return number;
  Procedure Sp_capitalPag50(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_flag   out varchar2);
  Procedure Sp_capitalPag35(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_flag   out varchar2);
  Procedure Sp_capitalPag70(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_flag   out varchar2);
  Procedure Sp_cuopag(pn_emp    in number,
                      pn_mod    in number,
                      pn_suc    in number,
                      pn_mda    in number,
                      pn_pap    in number,
                      pn_cta    in number,
                      pn_ope    in number,
                      pn_sbo    in number,
                      pn_top    in number,
                      pd_fecpro in date,
                      pn_cont   out number);
  Procedure Sp_nro_ampliaciones(pn_ins in number, pn_cont out number);
  Procedure Sp_CodActividad(pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pn_cod out number);

  ------------------------------------------------------------------
  procedure sp_cr_VerificaExcepciones(ln_pgcod     in number,
                                      ln_modulo    in number,
                                      ln_sucursal  in number,
                                      ln_moneda    in number,
                                      ln_papel     in number,
                                      ln_cuenta    in number,
                                      ln_operac    in number,
                                      ln_suboper   in number,
                                      ln_tipoper   in number,
                                      lc_VerifExcp out Varchar2);
  ----------------------------------------------------------------------
  procedure sp_cr_InsertLogJAQZ840(lc_prgm       in varchar2,
                                   lc_nmbvar     in varchar2,
                                   lc_user       in varchar2,
                                   ln_Instancia  in number,
                                   pn_pai        in number,
                                   pn_tdo        in number,
                                   pc_ndo        in char,
                                   pd_fecpro     in date,
                                   ln_diaTot     in number,
                                   ln_contCuoTot in number,
                                   ln_promedio   in number,
                                   pn_moramax    in number);
  ----------------------------------------------------------------------
  procedure sp_cr_LogAQPA368(ld_FEC      in date,
                             lc_USER     in varchar2,
                             ln_INST     in number,
                             ln_PAIS     in number,
                             ln_TDOC     in number,
                             lc_NDOC     in varchar2,
                             ln_TDIAS    in number,
                             ln_NCUOT    in number,
                             ln_PROMT    in number,
                             ln_MORMAX   in number,
                             ln_ContCred in number);
  -----------------------------------------------------------------
  procedure sp_cr_LogAQPA367(ld_fec   in date,
                             lc_user  in varchar2,
                             ln_inst  in number,
                             ln_pais  in number,
                             ln_tdoc  in number,
                             lc_ndoc  in varchar2,
                             ln_pgcod in number,
                             ln_mod   in number,
                             ln_suc   in number,
                             ln_mda   in number,
                             ln_pap   in number,
                             ln_cta   in number,
                             ln_ope   in number,
                             ln_sbop  in number,
                             ln_tope  in number,
                             ld_fcal  in date,
                             ln_dias  in number,
                             ln_prom  in number);
  -----------------------------------------------------------------
  procedure sp_cr_LogAQPA366(ld_fec        in date,
                             lc_user       in varchar2,
                             ln_inst       in number,
                             ln_pais       in number,
                             ln_tdoc       in number,
                             lc_ndoc       in varchar2,
                             ln_pgcod      in number,
                             ln_mod        in number,
                             ln_suc        in number,
                             ln_mda        in number,
                             ln_pap        in number,
                             ln_cta        in number,
                             ln_ope        in number,
                             ln_sbop       in number,
                             ln_tope       in number,
                             lc_expc       in varchar2,
                             ln_ncuot      in number,
                             ln_dias       in number,
                             ln_mormax     in number,
                             lc_TnRegstros in number);
  -----------------------------------------------------------------   
  procedure sp_cr_VerificaLog(ln_Instancia in number,
                              ln_VerfLog   out varchar2);
  ------------------------------------------------------------------                                                                                                                                                                                         

end PQ_CR_AMPLIACIONES;
/

create or replace package body PQ_CR_AMPLIACIONES is

  Procedure sp_promedio_mora(lc_prgm      in varchar2,
                             lc_nmbvar    in varchar2,
                             lc_user      in varchar2,
                             ln_Instancia in number,
                             pn_pai       in number,
                             pn_tdo       in number,
                             pc_ndo       in char,
                             pd_fecpro    in date,
                             ln_promedio  out number,
                             pn_moramax   out number) is
  
    cursor clientes is
      select distinct a.ctnro --mod@enero 2022 RayMontes
        from fsr008 a      
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and (a.pendoc = pc_ndo or
             a.pendoc = (select b.rpndoc
                            from fsr002 b
                           where b.pepais = pn_pai
                             and b.petdoc = pn_tdo
                             and b.pendoc = pc_ndo
                             and b.rpccyg = 66
                             and rownum = 1));
  
    cursor creditos( --ln_pai in number, --mod@abr 20170821 
                    --ln_tdo in number, --mod@abr 20170821
                    --lc_ndo in char, --mod@abr 20170821
                    ln_cta in number, --mod@abr 20170821                   
                    ld_fec in date) is
      select *
        from (select distinct B.PGCOD,
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
                              
                              --b.aofe99,
                              b.aostat,
                              a.pepais,
                              a.petdoc,
                              a.pendoc,
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
                              end) FEUSO,
                              
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
                                                             aofe99) fecpago
                from fsd010 b, fsr008 a
               where b.pgcod = 1
                 and b.aocta = ln_cta
                 and b.pgcod = a.pgcod
                 and b.aocta = a.ctnro
                 and a.cttfir = 'T'
                    --a.pgcod = 1  --mod@abr 20170821 
                    --and a.pepais = ln_pai  --mod@abr 20170821
                    --and a.petdoc = ln_tdo  --mod@abr 20170821
                    --and a.pendoc = lc_ndo  --mod@abr 20170821
                    --and a.cttfir = 'T'     --mod@abr 20170821
                    --and b.pgcod = a.pgcod  --mod@abr 20170821
                    --and b.aocta = a.ctnro  --mod@abr 20170821
                 and aomod in (select modulo
                                 from fst111
                                where dscod = 50
                                  and modulo not in (200, 33, 108))
                    
                 and aotope <> 550)
       where (fecpago >= ld_fec or
             fecpago = to_date('01/01/0001', 'DD/MM/YYYY')) --mod@abr 20170821
       order by aofval desc;
  
    ln_contCuotas number(18);
    ln_dia        number(18, 2);
  
    ln_contCuoTot number(18);
    ln_diaTot     number(18, 2);
    ln_nromeses   number(5);
  
    ld_fecorte date;
  
    ln_moramax    number(10);
    ln_sw         number(1) := 0; --mod@abr 20170822
    lc_VerifExcp  varchar2(2); -- mpostigoc 20171102
    ln_periodoaux number; -- mpostigoc 20171106
    ln_periodo    number; -- mpostigoc 20171106
  
    lc_EsPgrm      varchar2(2) := 'N'; --mpostigoc 20191105
    ln_contCuotLog number(18) := 0; --mpostigoc 20191105
    ln_diaLog      number(18, 2) := 0.00; --mpostigoc 20191105
    ln_MoraMaxLog  number(10) := 0; --mpostigoc 20191105
    ln_ContCred    number := 0; --mpostigoc 20191105
    lc_TnRegstros  number := 0;
  
  begin
  
    begin
      ln_contCuoTot := 0;
      ln_diaTot     := 0;
    
      -- mpostigoc 05/11/2019
      begin
        select 'S'
          into lc_EsPgrm
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11105
           and tp1corr1 = 30
           and tp1corr2 = 1
           and tp1corr3 = 1
           and trim(tp1desc) = trim(lc_prgm);
      exception
        when others then
          lc_EsPgrm := 'N';
      end;
    
      if lc_EsPgrm = 'S' then
        delete from aqpa366 a where a.aqpa366inst = ln_Instancia;
        delete from aqpa367 a where a.aqpa367inst = ln_Instancia;
        delete from aqpa368 a where a.aqpa368inst = ln_Instancia;
        commit;
      end if;
    
      begin
        --chernandez 11/02/2019
        select tp1nro1
          into ln_nromeses
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11105
           and tp1corr1 = 15
           and tp1corr2 = 1
           and tp1corr3 = 1;
      exception
        when others then
          ln_nromeses := 0;
      end;
      ld_fecorte    := to_date(to_char(add_months(pd_fecpro, -ln_nromeses),
                                       'yyyymm') || '01',
                               'yyyymmdd');
      ln_moramax    := 0;
      pn_moramax    := 0;
      ln_periodo    := 0;
      ln_contCuotas := 0;
      ln_dia        := 0;
      ln_moramax    := 0;
    
      for j in clientes loop
        for i in creditos(j.ctnro,
                          --j.pepais,  --mod@abr 20170821 
                          --j.petdoc,  --mod@abr 20170821 
                          --j.pendoc,  --mod@abr 20170821 
                          ld_fecorte) loop
        
          if (i.fecpago is null or
             i.fecpago = to_date('0001.01.01', 'yyyy.mm.dd')) and
             i.aostat = 99 then
            ln_sw := 1;
          end if;
        
          ln_periodo    := 0;
          ln_contCuotas := 0;
          ln_dia        := 0;
          ln_moramax    := 0;
          lc_TnRegstros := 0;
        
          ln_ContCred := ln_ContCred + 1;
        
          pq_cr_ampliaciones.sp_cr_VerificaExcepciones(ln_pgcod     => I.PGCOD,
                                                       ln_modulo    => I.AOMOD,
                                                       ln_sucursal  => I.AOSUC,
                                                       ln_moneda    => I.AOMDA,
                                                       ln_papel     => I.AOPAP,
                                                       ln_cuenta    => I.AOCTA,
                                                       ln_operac    => I.AOOPER,
                                                       ln_suboper   => I.AOSBOP,
                                                       ln_tipoper   => I.AOTOPE,
                                                       lc_VerifExcp => lc_VerifExcp);
        
          if lc_VerifExcp <> 'N' then
          
            if ln_sw = 0 then
            
              begin
              
                begin
                  -- MPOSTIGOC 20171106
                  -- Periodo            
                  select a.aoperiod
                    into ln_periodoaux
                    from fsd010 a
                   where a.pgcod = i.pgcod
                     and a.aomod = i.aomod
                     and a.aosuc = i.aosuc
                     and a.aomda = i.aomda
                     and a.aopap = i.aopap
                     and a.aocta = i.aocta
                     and a.aooper = i.aooper
                     and a.aosbop = i.aosbop
                     and a.aotope = i.aotope;
                exception
                  when others then
                    ln_periodoaux := 0;
                end;
              
                --Mensualizamos el periodo
                ln_periodo := ln_periodoaux / 30;
              
              end;
            
              pq_cr_ampliaciones.sp_calculaCuotas_new(i.pgcod,
                                                      i.aomod,
                                                      i.aosuc,
                                                      i.aomda,
                                                      i.aopap,
                                                      i.aocta,
                                                      i.aooper,
                                                      i.aosbop,
                                                      i.aotope,
                                                      pd_fecpro,
                                                      ld_fecorte,
                                                      i.aostat,
                                                      ln_periodo, -- mpostigoc 2017/11/06
                                                      ln_contCuotas,
                                                      ln_dia,
                                                      ln_moramax);
            
              -- mpostigoc 06/11/2019, se creo otro procedimiento xq no se sabe que programas desde genexus invoca 
              -- al procedimiento de sp_promedio_mora y sp_calculacuotas_new
            
              pq_cr_ampliaciones.Sp_CalculaCuotas_NewLog(ld_FecProc   => pd_fecpro,
                                                         lc_usuario   => lc_user,
                                                         ln_instancia => ln_Instancia,
                                                         ln_pais      => pn_pai,
                                                         ln_tdocumnt  => pn_tdo,
                                                         lc_ndocumnt  => pc_ndo,
                                                         pn_emp       => i.pgcod,
                                                         pn_mod       => i.aomod,
                                                         pn_suc       => i.aosuc,
                                                         pn_mda       => i.aomda,
                                                         pn_pap       => i.aopap,
                                                         pn_cta       => i.aocta,
                                                         pn_ope       => i.aooper,
                                                         pn_sbo       => i.aosbop,
                                                         pn_top       => i.aotope,
                                                         pd_fec       => pd_fecpro,
                                                         pd_fecor     => ld_fecorte,
                                                         pn_stat      => i.aostat,
                                                         ln_periodo   => ln_periodo,
                                                         lc_EsPgrm    => lc_EsPgrm,
                                                         ln_contador  => ln_contCuotLog,
                                                         ln_diasTot   => ln_diaLog,
                                                         ln_diafin    => ln_MoraMaxLog);
            
              ln_diaTot     := ln_diaTot + ln_dia;
              ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
              --mora maxima
              if ln_moramax > pn_moramax then
                pn_moramax := ln_moramax;
              end if;
              --mora maxima           
            
            end if;
          
          end if;
        
          --mpostigoc 06/11/2019 PRY2166
          if lc_EsPgrm = 'S' then
          
            begin
              select count(*)
                into lc_TnRegstros
                from aqpa367 a
               where a.aqpa367pgcod = i.pgcod
                 and a.aqpa367mod = i.aomod
                 and a.aqpa367suc = i.aosuc
                 and a.aqpa367mda = i.aomda
                 and a.aqpa367pap = i.aopap
                 and a.aqpa367cta = i.aocta
                 and a.aqpa367ope = i.aooper
                 and a.aqpa367sbop = i.aosbop
                 and a.aqpa367tope = i.aotope
                 and a.aqpa367inst = ln_Instancia;
            exception
              when others then
                lc_TnRegstros := 0;
            end;
          
            begin
              pq_cr_ampliaciones.sp_cr_LogAQPA366(ld_fec        => pd_fecpro,
                                                  lc_user       => lc_user,
                                                  ln_inst       => ln_Instancia,
                                                  ln_pais       => pn_pai,
                                                  ln_tdoc       => pn_tdo,
                                                  lc_ndoc       => pc_ndo,
                                                  ln_pgcod      => i.pgcod,
                                                  ln_mod        => i.aomod,
                                                  ln_suc        => i.aosuc,
                                                  ln_mda        => i.aomda,
                                                  ln_pap        => i.aopap,
                                                  ln_cta        => i.aocta,
                                                  ln_ope        => i.aooper,
                                                  ln_sbop       => i.aosbop,
                                                  ln_tope       => i.aotope,
                                                  lc_expc       => lc_VerifExcp,
                                                  ln_ncuot      => ln_contCuotas,
                                                  ln_dias       => ln_dia,
                                                  ln_mormax     => ln_moramax,
                                                  lc_TnRegstros => lc_TnRegstros);
            end;
          
          end if;
        
        end loop;
      end loop;
    end;
  
    if ln_contCuoTot = 0 then
      --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
      ln_promedio := 0;
    else
      ln_promedio := round((ln_diaTot / ln_contCuoTot), 2);
    end if;
  
    pq_cr_ampliaciones.sp_cr_InsertLogJAQZ840(lc_prgm,
                                              lc_nmbvar,
                                              lc_user,
                                              ln_Instancia,
                                              pn_pai,
                                              pn_tdo,
                                              pc_ndo,
                                              pd_fecpro,
                                              ln_diaTot,
                                              ln_contCuoTot,
                                              ln_promedio,
                                              pn_moramax);
  
    if lc_EsPgrm = 'S' then
    
      pq_cr_ampliaciones.sp_cr_LogAQPA368(ld_FEC      => pd_fecpro,
                                          lc_USER     => lc_user,
                                          ln_INST     => ln_Instancia,
                                          ln_PAIS     => pn_pai,
                                          ln_TDOC     => pn_tdo,
                                          lc_NDOC     => pc_ndo,
                                          ln_TDIAS    => ln_diaTot,
                                          ln_NCUOT    => ln_contCuoTot,
                                          ln_PROMT    => ln_promedio,
                                          ln_MORMAX   => pn_moramax,
                                          ln_ContCred => ln_ContCred); -- MPOSTIGOC 05/11/2019  
    end if;
  
  end sp_promedio_mora;

  ----------------------------------------------------------------------------------------
  Procedure Sp_CalculaCuotas(pn_emp      in number,
                             pn_mod      in number,
                             pn_suc      in number,
                             pn_mda      in number,
                             pn_pap      in number,
                             pn_cta      in number,
                             pn_ope      in number,
                             pn_sbo      in number,
                             pn_top      in number,
                             pd_fecpro   in date,
                             pd_fecorte  in date,
                             ln_contador out number,
                             ln_diasTot  out number) is
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
        from /*bantprod.*/ fsd601 a --,fsd602 b modificado 20151022
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
         and a.ppfpag >= pd_fecorte
         and a.ppfpag <= pd_fecpro
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) > 0;
  
    --ln_contador number(5);
    ln_dias number(10);
    --ln_diasTot number(5);
  
    --ld_fecpag date;
    --ln_mpag number(2);
    --ln_mdpa number(2);
    --ln_apag number(4);
    --ln_adpa number(4);
  
    ld_fecantC date;
  
    ld_fecpago date; --modificado 20151022
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
    
      ld_fecantC := to_date('2000.01.01', 'yyyy.mm.dd');
      For i in creditos loop
      
        begin
        
          select b.pp1fech
            into ld_fecpago
            from /*bantprod.*/ fsd602 b
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
             and rownum = 1;
        exception
          when no_data_found then
            ld_fecpago := null;
        end;
      
        --if ld_fecpago is null then
      
        if ld_fecantC <> i.ppfpag then
          ln_contador := ln_contador + 1;
        
          ln_dias    := pq_cr_ampliaciones.fn_cuotasPag(i.pgcod,
                                                        i.ppmod,
                                                        i.ppsuc,
                                                        i.ppmda,
                                                        i.pppap,
                                                        i.ppcta,
                                                        i.ppoper,
                                                        i.ppsbop,
                                                        i.pptope,
                                                        i.ppfpag,
                                                        pd_fecpro);
          ln_diasTot := ln_diasTot + ln_dias;
        end if;
      
        ld_fecantC := i.ppfpag;
        --end if;
      
      end loop;
    
    end;
  
  end Sp_CalculaCuotas;
  ----------------------------------------------------------------------------------------
  Procedure Sp_CalculaCuotas_New(pn_emp      in number,
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
                                 ln_periodo  in number, -- mpostigoc 2017/11/06
                                 ln_contador out number,
                                 ln_diasTot  out number,
                                 ln_diafin   out number) is
  
    cursor creditos(ld_fecfin in date) is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag
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
         and a.ppfpag < ld_fecfin --pd_fec mod@abr 20170905
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0;
  
    ln_dias number(10, 2);
  
    ln_flag    number(1);
    ld_fecantC date;
  
    ld_fecpago    date; --modificado 20151022
    ld_fectemp    date; --mod@abr 20170905
    lc_sinM       char(1) := 'N';
    ld_1fech      date; --mod@abr 20191105
    lc_flgAdel    char(1) := 'N'; --mod@abr 20191105
    ld_fecan      date; --mod@abr 20191105
    ln_NRO_CUOTAS number := 0; --mpostigoc 25/11/19
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
      ln_flag     := 0;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
    
      ln_diafin := 0;
      ln_dias   := 0;
    
      ld_fectemp := last_day(pd_fec);
    
      begin
        select count(*)
          into ln_NRO_CUOTAS
          from fsd601
         where Pgcod = pn_emp
           and Ppmod = pn_mod
           and Ppsuc = pn_suc
           and Ppmda = pn_mda
           and Pppap = pn_pap
           and Ppcta = pn_cta
           and Ppoper = pn_ope
           and Ppsbop = pn_sbo
           and Pptope = pn_top
           and D601co in ('S', 'X');
      exception
        when others then
          ln_NRO_CUOTAS := 2;
      end;
    
      For i in creditos(ld_fectemp) loop
        lc_flgAdel := 'N';
        begin
        
          select b.ppfpag, b.pp1fech --mod@abr 20191105
            into ld_fecpago, ld_1fech
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
            ld_1fech   := null;
        end;
        --mod@abr 20191105
        begin
        
          select 'S', last_day(b.d602fc) --mod@abr 20191105
            into lc_flgAdel, ld_fecan
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
             and (b.d602mo, b.d602tr) = (select 30, 150 from dual)
             and (b.pp1cap + b.pp1int) <> 0
             and rownum = 1;
        exception
          when no_data_found then
            lc_flgAdel := 'N';
        end;
      
        if lc_flgAdel = 'S' then
          if i.ppfpag <= ld_fecan then
            lc_flgAdel := 'N';
          end if;
        end if;
      
        --mod@abr 20191105
      
        if ld_fecpago is null then
          if i.ppfpag > pd_fec then
            --mod@abr 20170912
            lc_sinM := 'S';
          end if;
        end if;
      
        if ld_fecpago >= pd_fecor or ld_fecpago is null then
        
          if /*ld_fecantC <> ld_1fech*/
           lc_flgAdel = 'N' or ld_fecpago is null then
          
            if lc_sinM <> 'S' then
              ln_contador := ln_contador + 1;
            end if;
          
            ln_dias := pq_cr_relcrediticia.fn_cuotasPag(i.pgcod,
                                                        i.ppmod,
                                                        i.ppsuc,
                                                        i.ppmda,
                                                        i.pppap,
                                                        i.ppcta,
                                                        i.ppoper,
                                                        i.ppsbop,
                                                        i.pptope,
                                                        i.ppfpag,
                                                        pd_fec);
          
            /*if ln_periodo <> 1 and ln_dias <= 30 and ln_NRO_CUOTAS > 1 then
              -- mpostigoc 2017/11/06
              --PRY2166 solo se mensualiza los creditos diferentes a un solo vencimiento 25/11/2019             
              ln_dias := ln_dias / ln_periodo; -- Se mensualiza los dias de atraso
            end if;*/ -- a solicitud de negocio no se mensualiza ningun credito 28/11/19
          
            ln_diasTot := ln_diasTot + ln_dias;
          
            --mora maxima
            if ln_dias > ln_diafin then
              ln_diafin := ln_dias;
            end if;
            --mora maxima
          end if;
        
          ld_fecantC := ld_1fech;
        end if;
      
      end loop;
    
      /*if pn_stat = 99 then
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
             and a.ppfpag >= pd_fec
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
      end if;*/ --mod@abr 20191105
    end;
  
  end Sp_CalculaCuotas_New;
  ---------------------------------------------------------------
  Procedure Sp_CalculaCuotas_NewLog(ld_FecProc   in date,
                                    lc_usuario   in varchar2,
                                    ln_instancia in number,
                                    ln_pais      in number,
                                    ln_tdocumnt  in number,
                                    lc_ndocumnt  in varchar2,
                                    pn_emp       in number,
                                    pn_mod       in number,
                                    pn_suc       in number,
                                    pn_mda       in number,
                                    pn_pap       in number,
                                    pn_cta       in number,
                                    pn_ope       in number,
                                    pn_sbo       in number,
                                    pn_top       in number,
                                    pd_fec       in date,
                                    pd_fecor     in date,
                                    pn_stat      in number,
                                    ln_periodo   in number, -- mpostigoc 2017/11/06
                                    lc_EsPgrm    in varchar2,
                                    ln_contador  out number,
                                    ln_diasTot   out number,
                                    ln_diafin    out number) is
  
    cursor creditos(ld_fecfin in date) is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag
      
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
         and a.ppfpag < ld_fecfin --pd_fec mod@abr 20170905
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0;
  
    ln_dias number(10, 2);
  
    ln_flag    number(1);
    ld_fecantC date;
  
    ld_fecpago    date; --modificado 20151022
    ld_fectemp    date; --mod@abr 20170905
    lc_sinM       char(1) := 'N';
    ld_1fech      date; --mod@abr 20191105
    lc_flgAdel    char(1) := 'N'; --mod@abr 20191105
    ld_fecan      date; --mod@abr 20191105
    ln_NRO_CUOTAS number := 0; --mpostigoc 25/11/19
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
      ln_flag     := 0;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
    
      ln_diafin := 0;
      ln_dias   := 0;
    
      ld_fectemp := last_day(pd_fec);
    
      begin
        select count(*)
          into ln_NRO_CUOTAS
          from fsd601
         where Pgcod = pn_emp
           and Ppmod = pn_mod
           and Ppsuc = pn_suc
           and Ppmda = pn_mda
           and Pppap = pn_pap
           and Ppcta = pn_cta
           and Ppoper = pn_ope
           and Ppsbop = pn_sbo
           and Pptope = pn_top
           and D601co in ('S', 'X');
      exception
        when others then
          ln_NRO_CUOTAS := 2;
      end;
    
      For i in creditos(ld_fectemp) loop
        lc_flgAdel := 'N';
        begin
        
          select b.ppfpag, b.pp1fech --mod@abr 20191105
            into ld_fecpago, ld_1fech
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
            ld_1fech   := null;
        end;
        --mod@abr 20191105
        begin
        
          select 'S', last_day(b.d602fc) --mod@abr 20191105
            into lc_flgAdel, ld_fecan
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
             and (b.d602mo, b.d602tr) = (select 30, 150 from dual)
             and (b.pp1cap + b.pp1int) <> 0
             and rownum = 1;
        exception
          when no_data_found then
            lc_flgAdel := 'N';
        end;
      
        if lc_flgAdel = 'S' then
          if i.ppfpag <= ld_fecan then
            lc_flgAdel := 'N';
          end if;
        end if;
      
        --mod@abr 20191105
      
        if ld_fecpago is null then
          if i.ppfpag > pd_fec then
            --mod@abr 20170912
            lc_sinM := 'S';
          end if;
        end if;
      
        if ld_fecpago >= pd_fecor or ld_fecpago is null then
        
          if /*ld_fecantC <> ld_1fech*/
           lc_flgAdel = 'N' or ld_fecpago is null then
          
            if lc_sinM <> 'S' then
              ln_contador := ln_contador + 1;
            end if;
          
            ln_dias := pq_cr_relcrediticia.fn_cuotasPag(i.pgcod,
                                                        i.ppmod,
                                                        i.ppsuc,
                                                        i.ppmda,
                                                        i.pppap,
                                                        i.ppcta,
                                                        i.ppoper,
                                                        i.ppsbop,
                                                        i.pptope,
                                                        i.ppfpag,
                                                        pd_fec);
          
            /*  if ln_periodo <> 1 and ln_dias <= 30 and ln_NRO_CUOTAS > 1 then
              -- mpostigoc 2017/11/06
              ln_dias := ln_dias / ln_periodo; -- Se mensualiza los dias de atraso
            end if;*/ -- a solicitud de negocio no se mensualiza ningun credito 28/11/19
          
            ln_diasTot := ln_diasTot + ln_dias;
          
            --mora maxima
            if ln_dias > ln_diafin then
              ln_diafin := ln_dias;
            end if;
            --mora maxima
          
            -- mpostigoc 06/11/2019
            if lc_sinM <> 'S' and lc_EsPgrm = 'S' then
              begin
                pq_cr_ampliaciones.sp_cr_LogAQPA367(ld_fec   => ld_FecProc,
                                                    lc_user  => lc_usuario,
                                                    ln_inst  => ln_instancia,
                                                    ln_pais  => ln_pais,
                                                    ln_tdoc  => ln_tdocumnt,
                                                    lc_ndoc  => lc_ndocumnt,
                                                    ln_pgcod => pn_emp,
                                                    ln_mod   => pn_mod,
                                                    ln_suc   => pn_suc,
                                                    ln_mda   => pn_mda,
                                                    ln_pap   => pn_pap,
                                                    ln_cta   => pn_cta,
                                                    ln_ope   => pn_ope,
                                                    ln_sbop  => pn_sbo,
                                                    ln_tope  => pn_top,
                                                    ld_fcal  => i.ppfpag,
                                                    ln_dias  => ln_dias,
                                                    ln_prom  => ln_periodo);
              end;
            end if;
          end if;
        
          ld_fecantC := ld_1fech;
        end if;
      
      end loop;
    
    end;
  
  end Sp_CalculaCuotas_NewLog;

  -----------------------------------------------------------------------------------------------
  Function Fn_CuotasPag(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pd_fecpro in date) return number is
    ln_dias number(10);
  begin
  
    begin
    
      select (a.pp1fech - a.ppfpag)
        into ln_dias
        from /*bantprod.*/ fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.d602co = 'S'
         and a.pp1stat = 'T'
         and rownum = 1;
    
    exception
      when no_data_found then
        ln_dias := pd_fecpro - pd_fec;
      When too_many_rows then
        dbms_output.put_line(pn_cta || '-' || pn_ope || '-' || pn_sbo || '-' ||
                             pn_top || '-' || pd_fec);
      
    end;
    if ln_dias < 0 then
      ln_dias := 0;
    end if;
  
    return ln_dias;
  
  end Fn_CuotasPag;
  -----------------------------------------------------------------------------------------------

  Procedure Sp_capitalPag50(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_flag   out varchar2) is
  
    ln_saldo number(17, 2);
    ln_capag number(17, 2);
    --ln_dif number(17,2);
    ln_50 number(17, 2);
  begin
  
    --monto aprobado
    begin
      select a.xwfmonto1
        into ln_saldo
        from xwf700 a, xwf070 b
       where a.xwfempresa = pn_emp
         and a.xwfsucursal = pn_suc
         and a.xwfmodulo = pn_mod
         and a.xwfmoneda = pn_mda
         and a.xwfpapel = pn_pap
         and a.xwfcuenta = pn_cta
         and a.xwfoperacion = pn_ope
         and a.xwfsubope = pn_sbo
         and a.xwftipope = pn_top
         and a.xwfcar3 = '1'
         and a.xwfprcins = b.xwfprcin
         and b.xwfcont = 'S';
    
    exception
      when no_data_found then
        ln_saldo := null;
      when too_many_rows then
        begin
          select a.xwfmonto1
            into ln_saldo
            from xwf700 a, xwf070 b
           where a.xwfempresa = pn_emp
             and a.xwfsucursal = pn_suc
             and a.xwfmodulo = pn_mod
             and a.xwfmoneda = pn_mda
             and a.xwfpapel = pn_pap
             and a.xwfcuenta = pn_cta
             and a.xwfoperacion = pn_ope
             and a.xwfsubope = pn_sbo
             and a.xwftipope = pn_top
             and a.xwfcar3 = '1'
             and a.xwfprcins = b.xwfprcin
             and b.xwfcont = 'S'
             and rownum = 1;
        
        exception
          when no_data_found then
            ln_saldo := null;
          when others then
            null;
          
        end;
      when others then
        null;
    end;
  
    --50% de capital
    ln_50 := ln_saldo / 2;
  
    --capital pagado
    begin
      select sum(a.pp1cap)
        into ln_capag
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
         and a.pp1stat = 'T'
         and a.d602co = 'S'
         and a.ppfpag <= pd_fecpro;
    
    exception
      when no_data_found then
        ln_capag := 0;
      when too_many_rows then
        begin
          select sum(a.pp1cap)
            into ln_capag
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
             and a.pp1stat = 'T'
             and a.d602co = 'S'
             and a.ppfpag <= pd_fecpro;
        
        exception
          when no_data_found then
            ln_capag := 0;
          when others then
            null;
          
        end;
      when others then
        null;
    end;
  
    if ln_capag > ln_50 then
      pc_flag := 'S';
    else
      pc_flag := 'N';
    end if;
  
  end Sp_capitalPag50;
  -----------------------------------------------------------------------------------------------

  Procedure Sp_capitalPag35(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_flag   out varchar2) is
  
    ln_saldo number(17, 2);
    ln_capag number(17, 2);
    --ln_dif number(17,2);
    ln_35 number(17, 2);
  begin
  
    --monto aprobado
    begin
      select a.xwfmonto1
        into ln_saldo
        from xwf700 a, xwf070 b
       where a.xwfempresa = pn_emp
         and a.xwfsucursal = pn_suc
         and a.xwfmodulo = pn_mod
         and a.xwfmoneda = pn_mda
         and a.xwfpapel = pn_pap
         and a.xwfcuenta = pn_cta
         and a.xwfoperacion = pn_ope
         and a.xwfsubope = pn_sbo
         and a.xwftipope = pn_top
         and a.xwfcar3 = '1'
         and a.xwfprcins = b.xwfprcin
         and b.xwfcont = 'S';
    
    exception
      when no_data_found then
        ln_saldo := null;
      when too_many_rows then
        begin
          select a.xwfmonto1
            into ln_saldo
            from xwf700 a, xwf070 b
           where a.xwfempresa = pn_emp
             and a.xwfsucursal = pn_suc
             and a.xwfmodulo = pn_mod
             and a.xwfmoneda = pn_mda
             and a.xwfpapel = pn_pap
             and a.xwfcuenta = pn_cta
             and a.xwfoperacion = pn_ope
             and a.xwfsubope = pn_sbo
             and a.xwftipope = pn_top
             and a.xwfcar3 = '1'
             and a.xwfprcins = b.xwfprcin
             and b.xwfcont = 'S'
             and rownum = 1;
        
        exception
          when no_data_found then
            ln_saldo := null;
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    --50% de capital
    ln_35 := (ln_saldo * 35) / 100;
  
    --capital pagado
    begin
      select sum(a.pp1cap)
        into ln_capag
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
         and a.pp1stat = 'T'
         and a.d602co = 'S'
         and a.ppfpag <= pd_fecpro;
    
    exception
      when no_data_found then
        ln_capag := 0;
      when too_many_rows then
        begin
          select sum(a.pp1cap)
            into ln_capag
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
             and a.pp1stat = 'T'
             and a.d602co = 'S'
             and a.ppfpag <= pd_fecpro
             and rownum = 1;
        
        exception
          when no_data_found then
            ln_capag := 0;
          when others then
            null;
          
        end;
      when others then
        null;
      
    end;
  
    if ln_capag > ln_35 then
      pc_flag := 'S';
    else
      pc_flag := 'N';
    end if;
  
  end Sp_capitalPag35;

  -----------------------------------------------------------------------------------------------

  Procedure Sp_capitalPag70(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_flag   out varchar2) is
  
    ln_saldo number(17, 2);
    ln_capag number(17, 2);
    --ln_dif number(17,2);
    ln_70 number(17, 2);
  begin
  
    --monto aprobado
    begin
      select a.xwfmonto1
        into ln_saldo
        from xwf700 a, xwf070 b
       where a.xwfempresa = pn_emp
         and a.xwfsucursal = pn_suc
         and a.xwfmodulo = pn_mod
         and a.xwfmoneda = pn_mda
         and a.xwfpapel = pn_pap
         and a.xwfcuenta = pn_cta
         and a.xwfoperacion = pn_ope
         and a.xwfsubope = pn_sbo
         and a.xwftipope = pn_top
         and a.xwfcar3 = '1'
         and a.xwfprcins = b.xwfprcin
         and b.xwfcont = 'S';
    
    exception
      when no_data_found then
        ln_saldo := null;
      when too_many_rows then
        begin
          select a.xwfmonto1
            into ln_saldo
            from xwf700 a, xwf070 b
           where a.xwfempresa = pn_emp
             and a.xwfsucursal = pn_suc
             and a.xwfmodulo = pn_mod
             and a.xwfmoneda = pn_mda
             and a.xwfpapel = pn_pap
             and a.xwfcuenta = pn_cta
             and a.xwfoperacion = pn_ope
             and a.xwfsubope = pn_sbo
             and a.xwftipope = pn_top
             and a.xwfcar3 = '1'
             and a.xwfprcins = b.xwfprcin
             and b.xwfcont = 'S'
             and rownum = 1;
        
        exception
          when no_data_found then
            ln_saldo := null;
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    --70% de capital
    ln_70 := (ln_saldo * 70) / 100;
  
    --capital pagado
    begin
      select sum(a.pp1cap)
        into ln_capag
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
         and a.pp1stat = 'T'
         and a.d602co = 'S'
         and a.ppfpag <= pd_fecpro;
    
    exception
      when no_data_found then
        ln_capag := 0;
      when too_many_rows then
        begin
          select sum(a.pp1cap)
            into ln_capag
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
             and a.pp1stat = 'T'
             and a.d602co = 'S'
             and a.ppfpag <= pd_fecpro
             and rownum = 1;
        
        exception
          when no_data_found then
            ln_capag := 0;
          when others then
            null;
          
        end;
      when others then
        null;
      
    end;
  
    if ln_capag > ln_70 then
      pc_flag := 'S';
    else
      pc_flag := 'N';
    end if;
  
  end Sp_capitalPag70;
  -----------------------------------------------------------------------------------------------

  Procedure Sp_cuopag(pn_emp    in number,
                      pn_mod    in number,
                      pn_suc    in number,
                      pn_mda    in number,
                      pn_pap    in number,
                      pn_cta    in number,
                      pn_ope    in number,
                      pn_sbo    in number,
                      pn_top    in number,
                      pd_fecpro in date,
                      pn_cont   out number) is
  
  begin
    begin
      select count(*)
        into pn_cont
        from fsd602 o
       where o.pgcod = pn_emp
         and o.ppmod = pn_mod
         and o.ppsuc = pn_suc
         and o.ppmda = pn_mda
         and o.pppap = pn_pap
         and o.ppcta = pn_cta
         and o.ppoper = pn_ope
         and o.ppsbop = pn_sbo
         and o.pptope = pn_top
         and o.pp1stat = 'T'
         and o.d602co = 'S'
         and (o.pp1cap + o.pp1int) <> 0
         and o.ppfpag <= pd_fecpro
       group by o.pgcod,
                o.ppmod,
                o.ppsuc,
                o.ppmda,
                o.pppap,
                o.ppcta,
                o.ppoper,
                o.ppsbop,
                o.pptope;
    
    exception
      when no_data_found then
        pn_cont := 0;
      
    end;
  
  end Sp_cuopag;

  ------------------------------------------------------------------------------------
  Procedure Sp_nro_ampliaciones(pn_ins in number, pn_cont out number) is
  
    ln_emp number(3);
    ln_mod number(3);
    ln_suc number(3);
    ln_mda number(4);
    ln_pap number(4);
    ln_cta number(9);
    ln_ope number(9);
    ln_sbo number(3);
    ln_top number(3);
    ln_ori number(2);
  
    ln_empAnt number(3);
    ln_modAnt number(3);
    ln_sucAnt number(3);
    ln_mdaAnt number(4);
    ln_papAnt number(4);
    ln_ctaAnt number(9);
    ln_opeAnt number(9);
    ln_sboAnt number(3);
    ln_topAnt number(3);
    ln_oriAnt number(2);
    ln_insAnt number(10);
  
    lc_end char(1);
  begin
    pn_cont := 0;
    lc_end  := 'O';
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 <> '1';
    exception
      when others then
        null;
    end;
  
    ln_insAnt := fn_instancia_credito(ln_mod,
                                      ln_suc,
                                      ln_mda,
                                      ln_pap,
                                      ln_cta,
                                      ln_ope,
                                      ln_sbo,
                                      ln_top);
  
    begin
      select a.sng001ori
        into ln_ori
        from sng001 a
       where a.sng001inst = ln_insAnt;
    exception
      when others then
        null;
      
    end;
  
    if ln_ori not in (4, 13, 14, 15, 16) then
      lc_end := 'N';
    end if;
  
    while lc_end <> 'N' loop
    
      if ln_ori in (4, 13, 14, 15, 16) then
      
        case
          when ln_ori = 4 then
            begin
              select a.r2cod,
                     a.r2mod,
                     a.r2suc,
                     a.r2mda,
                     a.r2pap,
                     a.r2cta,
                     a.r2oper,
                     a.r2sbop,
                     a.r2tope
                into ln_empAnt,
                     ln_modAnt,
                     ln_sucAnt,
                     ln_mdaAnt,
                     ln_papAnt,
                     ln_ctaAnt,
                     ln_opeAnt,
                     ln_sboAnt,
                     ln_topAnt
                from fsr011 a
               where a.r1cod = ln_emp
                 and a.r1mod = ln_mod
                 and a.r1suc = ln_suc
                 and a.r1mda = ln_mda
                 and a.r1pap = ln_pap
                 and a.r1cta = ln_cta
                 and a.r1oper = ln_ope
                 and a.r1sbop = ln_sbo
                 and a.r1tope = ln_top
                 and a.relcod = 130;
            exception
              when others then
                null;
              
            end;
            ln_insAnt := fn_instancia_credito(ln_modAnt,
                                              ln_sucAnt,
                                              ln_mdaAnt,
                                              ln_papAnt,
                                              ln_ctaAnt,
                                              ln_opeAnt,
                                              ln_sboAnt,
                                              ln_topAnt);
            begin
              select a.sng001ori
                into ln_oriAnt
                from sng001 a
               where a.sng001inst = ln_insAnt;
            exception
              when others then
                null;
              
            end;
          
            pn_cont := pn_cont + 1;
          
          when ln_ori = 13 then
            begin
              select a.r2cod,
                     a.r2mod,
                     a.r2suc,
                     a.r2mda,
                     a.r2pap,
                     a.r2cta,
                     a.r2oper,
                     a.r2sbop,
                     a.r2tope
                into ln_empAnt,
                     ln_modAnt,
                     ln_sucAnt,
                     ln_mdaAnt,
                     ln_papAnt,
                     ln_ctaAnt,
                     ln_opeAnt,
                     ln_sboAnt,
                     ln_topAnt
                from fsr011 a
               where a.r1cod = ln_emp
                 and a.r1mod = ln_mod
                 and a.r1suc = ln_suc
                 and a.r1mda = ln_mda
                 and a.r1pap = ln_pap
                 and a.r1cta = ln_cta
                 and a.r1oper = ln_ope
                 and a.r1sbop = ln_sbo
                 and a.r1tope = ln_top
                 and a.relcod = 860;
            exception
              when others then
                null;
              
            end;
            ln_insAnt := fn_instancia_credito(ln_modAnt,
                                              ln_sucAnt,
                                              ln_mdaAnt,
                                              ln_papAnt,
                                              ln_ctaAnt,
                                              ln_opeAnt,
                                              ln_sboAnt,
                                              ln_topAnt);
            begin
              select a.sng001ori
                into ln_oriAnt
                from sng001 a
               where a.sng001inst = ln_insAnt;
            exception
              when others then
                null;
            end;
          
          when ln_ori = 14 then
            begin
              select a.r2cod,
                     a.r2mod,
                     a.r2suc,
                     a.r2mda,
                     a.r2pap,
                     a.r2cta,
                     a.r2oper,
                     a.r2sbop,
                     a.r2tope
                into ln_empAnt,
                     ln_modAnt,
                     ln_sucAnt,
                     ln_mdaAnt,
                     ln_papAnt,
                     ln_ctaAnt,
                     ln_opeAnt,
                     ln_sboAnt,
                     ln_topAnt
                from fsr011 a
               where a.r1cod = ln_emp
                 and a.r1mod = ln_mod
                 and a.r1suc = ln_suc
                 and a.r1mda = ln_mda
                 and a.r1pap = ln_pap
                 and a.r1cta = ln_cta
                 and a.r1oper = ln_ope
                 and a.r1sbop = ln_sbo
                 and a.r1tope = ln_top
                 and a.relcod = 870;
            exception
              when others then
                null;
            end;
            ln_insAnt := fn_instancia_credito(ln_modAnt,
                                              ln_sucAnt,
                                              ln_mdaAnt,
                                              ln_papAnt,
                                              ln_ctaAnt,
                                              ln_opeAnt,
                                              ln_sboAnt,
                                              ln_topAnt);
            begin
              select a.sng001ori
                into ln_oriAnt
                from sng001 a
               where a.sng001inst = ln_insAnt;
            exception
              when others then
                null;
            end;
          
          when ln_ori = 15 then
            begin
              select a.r2cod,
                     a.r2mod,
                     a.r2suc,
                     a.r2mda,
                     a.r2pap,
                     a.r2cta,
                     a.r2oper,
                     a.r2sbop,
                     a.r2tope
                into ln_empAnt,
                     ln_modAnt,
                     ln_sucAnt,
                     ln_mdaAnt,
                     ln_papAnt,
                     ln_ctaAnt,
                     ln_opeAnt,
                     ln_sboAnt,
                     ln_topAnt
                from fsr011 a
               where a.r1cod = ln_emp
                 and a.r1mod = ln_mod
                 and a.r1suc = ln_suc
                 and a.r1mda = ln_mda
                 and a.r1pap = ln_pap
                 and a.r1cta = ln_cta
                 and a.r1oper = ln_ope
                 and a.r1sbop = ln_sbo
                 and a.r1tope = ln_top
                 and a.relcod = 880;
            exception
              when others then
                null;
            end;
            ln_insAnt := fn_instancia_credito(ln_modAnt,
                                              ln_sucAnt,
                                              ln_mdaAnt,
                                              ln_papAnt,
                                              ln_ctaAnt,
                                              ln_opeAnt,
                                              ln_sboAnt,
                                              ln_topAnt);
            begin
              select a.sng001ori
                into ln_oriAnt
                from sng001 a
               where a.sng001inst = ln_insAnt;
            exception
              when others then
                null;
            end;
          
          when ln_ori = 16 then
            begin
              select a.r2cod,
                     a.r2mod,
                     a.r2suc,
                     a.r2mda,
                     a.r2pap,
                     a.r2cta,
                     a.r2oper,
                     a.r2sbop,
                     a.r2tope
                into ln_empAnt,
                     ln_modAnt,
                     ln_sucAnt,
                     ln_mdaAnt,
                     ln_papAnt,
                     ln_ctaAnt,
                     ln_opeAnt,
                     ln_sboAnt,
                     ln_topAnt
                from fsr011 a
               where a.r1cod = ln_emp
                 and a.r1mod = ln_mod
                 and a.r1suc = ln_suc
                 and a.r1mda = ln_mda
                 and a.r1pap = ln_pap
                 and a.r1cta = ln_cta
                 and a.r1oper = ln_ope
                 and a.r1sbop = ln_sbo
                 and a.r1tope = ln_top
                 and a.relcod = 890;
            exception
              when others then
                null;
            end;
            ln_insAnt := fn_instancia_credito(ln_modAnt,
                                              ln_sucAnt,
                                              ln_mdaAnt,
                                              ln_papAnt,
                                              ln_ctaAnt,
                                              ln_opeAnt,
                                              ln_sboAnt,
                                              ln_topAnt);
            begin
              select a.sng001ori
                into ln_oriAnt
                from sng001 a
               where a.sng001inst = ln_insAnt;
            exception
              when others then
                null;
            end;
          
        end case;
      
      else
        lc_end := 'N';
      
      end if;
    
      ln_emp := ln_empAnt;
      ln_mod := ln_modAnt;
      ln_suc := ln_sucAnt;
      ln_mda := ln_mdaAnt;
      ln_pap := ln_papAnt;
      ln_cta := ln_ctaAnt;
      ln_ope := ln_opeAnt;
      ln_sbo := ln_sboAnt;
      ln_top := ln_topAnt;
      ln_ori := ln_oriAnt;
    
    end loop;
  
  end Sp_nro_ampliaciones;

  Procedure Sp_CodActividad(pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pn_cod out number) is
    lc_tipo char(1);
  begin
    begin
      select a.petipo
        into lc_tipo
        from fsd001 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    exception
      when others then
        null;
    end;
  
    if lc_tipo = 'J' then
    
      begin
        select aa.sngc60tipa
          into pn_cod
          from sngc60 aa
         where aa.sngc60pais = pn_pai
           and aa.sngc60tdoc = pn_tdo
           and aa.sngc60ndoc = pc_ndo
           and aa.sngc60corr = 0; -- MOD @MPCA 24/07/2018
        /* (select max(aa.sngc60corr)
         from sngc60 aaa
        where aaa.sngc60pais = aa.sngc60pais
          and aaa.sngc60tdoc = aa.sngc60tdoc
          and aaa.sngc60ndoc = aa.sngc60ndoc);*/ --- MOD @MPCA 24/07/2018
      exception
        when too_many_rows then
          begin
            select aa.sngc60tipa
              into pn_cod
              from sngc60 aa
             where aa.sngc60pais = pn_pai
               and aa.sngc60tdoc = pn_tdo
               and aa.sngc60ndoc = pc_ndo
               and aa.sngc60corr = 0 -- MOD @MPCA 24/07/2018
                  /*(select max(aa.sngc60corr)
                   from sngc60 aaa
                  where aaa.sngc60pais = aa.sngc60pais
                    and aaa.sngc60tdoc = aa.sngc60tdoc
                    and aaa.sngc60ndoc = aa.sngc60ndoc)*/ -- MOD @MPCA 24/07/2018
               and rownum = 1;
          exception
            when others then
              null;
          end;
        when others then
          null;
      end;
    
      if pn_cod is null then
        begin
        
          select cc.sngc11tpa2
            into pn_cod
            from sngc11 cc
           where cc.sngc11pais = pn_pai
             and cc.sngc11tdoc = pn_tdo
             and cc.sngc11ndoc = pc_ndo;
        exception
          when too_many_rows then
            begin
              select cc.sngc11tpa2
                into pn_cod
                from sngc11 cc
               where cc.sngc11pais = pn_pai
                 and cc.sngc11tdoc = pn_tdo
                 and cc.sngc11ndoc = pc_ndo
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          
          when others then
            null;
        end;
      end if;
    
    else
    
      begin
        select a.sngc60ocup
          into pn_cod
          from sngc60 a
         where a.sngc60pais = pn_pai
           and a.sngc60tdoc = pn_tdo
           and a.sngc60ndoc = pc_ndo
           and a.sngc60corr = 0; -- MOD @MPCA 24/07/2018
        /*  (select max(aa.sngc60corr)
         from sngc60 aa
        where aa.sngc60pais = a.sngc60pais
          and aa.sngc60tdoc = a.sngc60tdoc
          and aa.sngc60ndoc = a.sngc60ndoc);*/ -- MOD @MPCA 24/07/2018
      exception
        when too_many_rows then
          begin
            select a.sngc60ocup
              into pn_cod
              from sngc60 a
             where a.sngc60pais = pn_pai
               and a.sngc60tdoc = pn_tdo
               and a.sngc60ndoc = pc_ndo
               and a.sngc60corr = 0 -- MOD @MPCA 24/07/2018
                  /*(select max(aa.sngc60corr)
                   from sngc60 aa
                  where aa.sngc60pais = a.sngc60pais
                    and aa.sngc60tdoc = a.sngc60tdoc
                    and aa.sngc60ndoc = a.sngc60ndoc)*/ -- MOD @MPCA 24/07/2018
               and rownum = 1;
          exception
            when others then
              null;
          end;
        when others then
          null;
      end;
    end if;
  end;

  --------------------------------------
  -- 02/11/17 Verifica excepciones MPOSTIGOC 
  procedure sp_cr_VerificaExcepciones(ln_pgcod     in number,
                                      ln_modulo    in number,
                                      ln_sucursal  in number,
                                      ln_moneda    in number,
                                      ln_papel     in number,
                                      ln_cuenta    in number,
                                      ln_operac    in number,
                                      ln_suboper   in number,
                                      ln_tipoper   in number,
                                      lc_VerifExcp out Varchar2) is
  
    FlgIncl       varchar2(2);
    ln_modul117   number;
    ln_cta117     number;
    ln_oper117    number;
    ln_sboper117  number;
    ln_sucur117   number;
    ln_mda117     number;
    ln_tipoer117  number;
    ln_NRO_CUOTAS number;
  
  begin
  
    begin
    
      if ln_modulo = 116 then
      
        begin
        
          select f.r2mod,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2suc,
                 f.r2mda,
                 f.r2tope
            into ln_modul117,
                 ln_cta117,
                 ln_oper117,
                 ln_sboper117,
                 ln_sucur117,
                 ln_mda117,
                 ln_tipoer117
            from fsr011 f
           where f.r1cod = ln_pgcod
             and f.r1mod = ln_modulo
             and f.r1suc = ln_sucursal
             and f.r1mda = ln_moneda
             and f.r1pap = ln_papel
             and f.r1cta = ln_cuenta
             and f.r1oper = ln_operac
             and f.r1sbop = ln_suboper
             and f.r1tope = ln_tipoper
             and f.relcod = 46;
        exception
          --28/06/2019 mpostigoc
          when others then
            null;
          
        end;
      
        begin
          Select 'N'
            into FlgIncl
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = ln_pgcod
             and a.r1mod = ln_modul117
             and a.r1suc = ln_sucur117
             and a.r1mda = ln_mda117
             and a.r1pap = 0
             and a.r1cta = ln_cta117
             and a.r1oper = ln_oper117
             and a.r1sbop = ln_sboper117
             and a.r1tope = ln_tipoer117
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
          
        end;
      
      else
        if ln_modulo <> 116 then
        
          begin
            --créditos con garantía de plazo fijo o cts
          
            Select 'N'
              into FlgIncl
              from fsr011 a, fsr011 b
             where a.relcod = 50
               and a.r1cod = ln_pgcod
               and a.r1mod = ln_modulo
               and a.r1suc = ln_sucursal
               and a.r1mda = ln_moneda
               and a.r1pap = ln_papel
               and a.r1cta = ln_cuenta
               and a.r1oper = ln_operac
               and a.r1sbop = ln_suboper
               and a.r1tope = ln_tipoper
               and b.r2cta = a.r2cta
               and b.r2oper = a.r2oper
               and b.r2sbop = a.r2sbop
               and b.relcod in (2, 25)
               and a.r011co = 'S'
               and b.r011co = 'S'
               and rownum = 1;
          exception
            when no_data_found then
              -- ln_rcta := 0;
              FlgIncl := 'S';
          end;
        End If;
      
      end if;
    
    end;
  
    begin
      select count(*)
        into ln_NRO_CUOTAS
        from fsd601
       where Pgcod = ln_pgcod
         and Ppmod = ln_modulo
         and Ppsuc = ln_sucursal
         and Ppmda = ln_moneda
         and Pppap = ln_papel
         and Ppcta = ln_cuenta
         and Ppoper = ln_operac
         and Ppsbop = ln_suboper
         and Pptope = ln_tipoper
         and D601co in ('S', 'X');
    exception
      when others then
        null;
    end;
  
    if FlgIncl = 'N' /*or ln_NRO_CUOTAS < 2*/
     then
      -- 25/11/2019
      lc_VerifExcp := 'N';
    
    else
      lc_VerifExcp := 'S';
    end if;
  
  end sp_cr_VerificaExcepciones;

  ------------------------------------------------------------
  procedure sp_cr_InsertLogJAQZ840(lc_prgm       in varchar2,
                                   lc_nmbvar     in varchar2,
                                   lc_user       in varchar2,
                                   ln_Instancia  in number,
                                   pn_pai        in number,
                                   pn_tdo        in number,
                                   pc_ndo        in char,
                                   pd_fecpro     in date,
                                   ln_diaTot     in number,
                                   ln_contCuoTot in number,
                                   ln_promedio   in number,
                                   pn_moramax    in number) is
  
    lc_pai        varchar2(15);
    lc_tdo        varchar2(15);
    lc_fecpro     varchar2(15);
    lc_promedio   varchar2(15);
    lc_moramax    varchar2(15);
    lc_hora       character(8);
    ld_FchProc    date;
    lc_diaTot     varchar2(15);
    lc_contCuoTot varchar2(15);
    lc_CodEtapa   varchar2(15);
  
  begin
  
    lc_pai        := to_char(pn_pai);
    lc_tdo        := to_char(pn_tdo);
    lc_fecpro     := to_char(pd_fecpro, 'DD/MM/YYYY');
    lc_diaTot     := to_char(ln_diaTot);
    lc_contCuoTot := to_char(ln_contCuoTot);
    lc_promedio   := to_char(ln_promedio);
    lc_moramax    := to_char(pn_moramax);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
    begin
      select pgfape into ld_FchProc from fst017 where pgcod = 1;
    end;
  
    begin
      select to_char(w.wftaskcod)
        into lc_CodEtapa
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    begin
      insert into JAQZ840
        (JAQZ840PRGM,
         JAQZ840NMBVAR,
         JAQZ840FECPROC,
         JAQZ840HORA,
         JAQZ840USER,
         JAQZ840VARIN1,
         JAQZ840VARIN2,
         JAQZ840VARIN3,
         JAQZ840VARIN4,
         JAQZ840VARIN5,
         JAQZ840VARIN6,
         JAQZ840VAROUT1,
         JAQZ840VAROUT2,
         JAQZ840VAROUT3,
         JAQZ840VAROUT4)
      values
        (lc_prgm,
         lc_nmbvar,
         ld_FchProc,
         lc_hora,
         lc_user,
         ln_Instancia,
         lc_CodEtapa,
         lc_pai,
         lc_tdo,
         pc_ndo,
         lc_fecpro,
         lc_diaTot,
         lc_contCuoTot,
         lc_promedio,
         lc_moramax);
      commit;
    end;
  
  end sp_cr_InsertLogJAQZ840;
  --------------------------------------------------------
  procedure sp_cr_LogAQPA368(ld_FEC      in date,
                             lc_USER     in varchar2,
                             ln_INST     in number,
                             ln_PAIS     in number,
                             ln_TDOC     in number,
                             lc_NDOC     in varchar2,
                             ln_TDIAS    in number,
                             ln_NCUOT    in number,
                             ln_PROMT    in number,
                             ln_MORMAX   in number,
                             ln_ContCred in number) is
  
    ln_corr number;
    lc_hora character(8);
  
  begin
  
    begin
      select max(a.aqpa368corr)
        into ln_corr
        from aqpa368 a
       where a.aqpa368inst = ln_INST
         and a.aqpa368fec = ld_FEC;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into AQPA368
        (AQPA368CORR,
         AQPA368FEC,
         AQPA368HORA,
         AQPA368USER,
         AQPA368INST,
         AQPA368PAIS,
         AQPA368TDOC,
         AQPA368NDOC,
         AQPA368TDIAS,
         AQPA368NCUOT,
         AQPA368PROMT,
         AQPA368MORMAX,
         AQPA368NAUX1)
      values
        (ln_corr + 1,
         ld_FEC,
         lc_hora,
         lc_USER,
         ln_INST,
         ln_PAIS,
         ln_TDOC,
         lc_NDOC,
         ln_TDIAS,
         ln_NCUOT,
         ln_PROMT,
         ln_MORMAX,
         ln_ContCred);
      commit;
    end;
  
  end sp_cr_LogAQPA368;
  ---------------------------------------------------------
  procedure sp_cr_LogAQPA367(ld_fec   in date,
                             lc_user  in varchar2,
                             ln_inst  in number,
                             ln_pais  in number,
                             ln_tdoc  in number,
                             lc_ndoc  in varchar2,
                             ln_pgcod in number,
                             ln_mod   in number,
                             ln_suc   in number,
                             ln_mda   in number,
                             ln_pap   in number,
                             ln_cta   in number,
                             ln_ope   in number,
                             ln_sbop  in number,
                             ln_tope  in number,
                             ld_fcal  in date,
                             ln_dias  in number,
                             ln_prom  in number) is
  
    ln_corr number;
    lc_hora character(8);
  
  begin
  
    begin
      select max(a.aqpa367corr)
        into ln_corr
        from aqpa367 a
       where a.aqpa367inst = ln_INST
         and a.aqpa367fec = ld_FEC;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa367
        (aqpa367corr,
         aqpa367fec,
         aqpa367hora,
         aqpa367user,
         aqpa367inst,
         aqpa367pais,
         aqpa367tdoc,
         aqpa367ndoc,
         aqpa367pgcod,
         aqpa367mod,
         aqpa367suc,
         aqpa367mda,
         aqpa367pap,
         aqpa367cta,
         aqpa367ope,
         aqpa367sbop,
         aqpa367tope,
         aqpa367fcal,
         aqpa367dias,
         aqpa367prom)
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         lc_user,
         ln_inst,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ld_fcal,
         ln_dias,
         ln_prom);
      commit;
    end;
  
  end sp_cr_LogAQPA367;
  -------------------------------------------------------  
  procedure sp_cr_LogAQPA366(ld_fec        in date,
                             lc_user       in varchar2,
                             ln_inst       in number,
                             ln_pais       in number,
                             ln_tdoc       in number,
                             lc_ndoc       in varchar2,
                             ln_pgcod      in number,
                             ln_mod        in number,
                             ln_suc        in number,
                             ln_mda        in number,
                             ln_pap        in number,
                             ln_cta        in number,
                             ln_ope        in number,
                             ln_sbop       in number,
                             ln_tope       in number,
                             lc_expc       in varchar2,
                             ln_ncuot      in number,
                             ln_dias       in number,
                             ln_mormax     in number,
                             lc_TnRegstros in number) is
  
    ln_corr number;
    lc_hora character(8);
  
  begin
  
    begin
      select /*+index (a AQPA3665)*/
       max(a.aqpa366corr)
        into ln_corr
        from aqpa366 a
       where a.aqpa366inst = ln_INST
         and a.aqpa366fec = ld_FEC;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa366
        (aqpa366corr,
         aqpa366fec,
         aqpa366hora,
         aqpa366user,
         aqpa366inst,
         aqpa366pais,
         aqpa366tdoc,
         aqpa366ndoc,
         aqpa366pgcod,
         aqpa366mod,
         aqpa366suc,
         aqpa366mda,
         aqpa366pap,
         aqpa366cta,
         aqpa366ope,
         aqpa366sbop,
         aqpa366tope,
         aqpa366expc,
         aqpa366ncuot,
         aqpa366dias,
         aqpa366mormax,
         aqpa366naux1)
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         lc_user,
         ln_inst,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         lc_expc,
         ln_ncuot,
         ln_dias,
         ln_mormax,
         lc_TnRegstros);
      commit;
    end;
  
  end sp_cr_LogAQPA366;
  -----------------------------------------------------
  procedure sp_cr_VerificaLog(ln_Instancia in number,
                              ln_VerfLog   out varchar2) is
  
    ln_NroReg    number := 0;
    ln_NroRegDet number := 0;
    ln_NroDetIns number := 0;
  
  begin
  
    ln_VerfLog := 'N'; -- No se muestra Politica
  
    begin
      select count(*)
        into ln_NroReg
        from aqpa368 a
       where a.aqpa368inst = ln_Instancia;
    exception
      when others then
        ln_NroReg := 0;
    end;
  
    if ln_NroReg > 0 then
    
      begin
        select AQPA368NAUX1
          into ln_NroRegDet
          from aqpa368 a
         where a.aqpa368inst = ln_Instancia;
      exception
        when others then
          ln_NroRegDet := 0;
      end;
    
      if ln_NroRegDet > 0 then
      
        begin
          select count(*)
            into ln_NroDetIns
            from aqpa366 a
           where a.aqpa366inst = ln_Instancia;
        exception
          when others then
            ln_NroDetIns := 0;
        end;
      
        if ln_NroDetIns <> ln_NroRegDet then
          ln_VerfLog := 'S';
        else
          ln_VerfLog := 'N';
        end if;
      
      else
        if ln_NroRegDet = 0 then
          ln_VerfLog := 'N';
        end if;
      
      end if;
    
    else
      if ln_NroReg = 0 then
        ln_VerfLog := 'S';
      end if;
    end if;
  
  end sp_cr_VerificaLog;

---------------------------------------------------

end PQ_CR_AMPLIACIONES;
/

