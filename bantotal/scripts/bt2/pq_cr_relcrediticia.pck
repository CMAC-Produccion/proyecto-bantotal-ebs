create or replace package PQ_CR_RELCREDITICIA is

  -- Author  : ABERNEDO
  -- Created : 19/08/2015 05:28:00 p.m.
  -- Purpose : 
  Procedure Sp_carga_data(pd_fecpro in date);
  Procedure Sp_cr_historial(pn_pai      in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecini   in date,
                            pd_fecpro   in date,
                            ln_contador out number,
                            ln_aostat   out number,
                            ln_emp      out number,
                            ln_mod      out number,
                            ln_suc      out number,
                            ln_mda      out number,
                            ln_pap      out number,
                            ln_cta      out number,
                            ln_ope      out number,
                            ln_sbo      out number,
                            ln_top      out number,
                            ld_feccan   out date);
  Procedure Sp_cr_Inserta(pd_fecpro in date, pd_fecini in date);
  Function fn_inserta(pn_pai  in number,
                      pn_tdo  in number,
                      pc_ndo  in char,
                      pn_anio in number,
                      pn_mes  in number) return number;
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
  Procedure Sp_cr_cancelados(pn_pai     in number,
                             pn_tdo     in number,
                             pc_ndo     in char,
                             pd_fecpro  in date,
                             ln_inserta out char,
                             ld_feccan  out date);
  Procedure Sp_carga_mensual(pd_fecpro in date);
  Procedure Sp_cr_Inserta_DiaAtraso(pd_fecpro in date, pd_fecini in date);
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
  Procedure Sp_CalculaCuotas(pn_emp      in number,
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
                             ln_diasTot  out number);
  Function fn_inserta_DiaAtr(pn_pai    in number,
                             pn_tdo    in number,
                             pc_ndo    in char,
                             pd_fecpro in date) return number;
  Procedure Sp_cr_histDiaAtr(pn_pai        in number,
                             pn_tdo        in number,
                             pc_ndo        in char,
                             pd_fecpro     in date,
                             pd_fecini     in date,
                             ln_contCuoTot out number,
                             ln_diaTot     out number);
  Procedure Sp_Carga_Atraso(pd_fecpro in date);
  Procedure Sp_cr_histDiaAtr_II(pn_pai        in number,
                                pn_tdo        in number,
                                pc_ndo        in char,
                                pd_fecor      in date,
                                pd_fecpro     in date,
                                ln_contCuoTot out number,
                                ln_diaTot     out number);
  Procedure Sp_RelCredi_NR(pn_pai      in number,
                           pn_tdo      in number,
                           pc_ndo      in char,
                           pd_Fecpro   in date,
                           ln_contador out number);
  Procedure Sp_DiaAtraso_linea(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_fecpro   in date,
                               ln_promedio out number);
  Procedure Sp_cr_histDiaAtr_linea(pn_pai        in number,
                                   pn_tdo        in number,
                                   pc_ndo        in char,
                                   pd_fecpro     in date,
                                   pd_fecini     in date,
                                   ln_contCuoTot out number,
                                   ln_diaTot     out number);
  Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai        in number,
                                      pn_tdo        in number,
                                      pc_ndo        in char,
                                      pd_fecor      in date,
                                      pd_fecpro     in date, /*pd_fecini in date,*/
                                      ln_contCuoTot out number,
                                      ln_diaTot     out number);
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

  Procedure Sp_Carga_NR(pd_fecpro in date);
  Procedure Sp_cr_Inserta_NR(pd_fecpro in date);
  Procedure Sp_RelCredi_NR_MENS(pd_Fecpro in date, ln_contador out number);
  Function fn_inserta_NR(pn_pai    in number,
                         pn_tdo    in number,
                         pc_ndo    in char,
                         pd_fecpro in date) return number;
  Procedure Sp_cargaRefinanciado(pd_fecpro in date);
  Function fn_inserta_REF(pn_pai    in number,
                          pn_tdo    in number,
                          pc_ndo    in char,
                          pd_fecpro in date) return number;
  Procedure Sp_diasAtrasoLineas(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_ope    in number,
                                pn_sbo    in number,
                                pn_top    in number,
                                pd_fecpro in date,
                                pn_ins    in number,
                                pn_diatr  out number);
  Procedure Sp_CalculaCuotas_Lineas(pn_emp      in number,
                                    pn_mod      in number,
                                    pn_suc      in number,
                                    pn_mda      in number,
                                    pn_pap      in number,
                                    pn_cta      in number,
                                    pn_ope      in number,
                                    pn_sbo      in number,
                                    pn_top      in number,
                                    pd_fecpro   in date,
                                    pn_stat     in number,
                                    ln_contador out number,
                                    ln_diasTot  out number);
  Procedure Sp_MoraMaxCuotas(pn_cta    in number,
                             pd_fecpro in date,
                             ln_diafin out number);
  Procedure Sp_MoraMaxCuotas_Cyg(pn_pai     in number,
                                 pn_tdo     in number,
                                 pc_ndo     in char,
                                 pd_fecpro  in date,
                                 ln_diafin  in number,
                                 ln_diafinC out number);
  Procedure Sp_JudiCast(pn_cta   in number,
                        pn_ins   in number,
                        ln_exfin out varchar2);
  Procedure Sp_Calificacion_RCC(pn_ctaP in number,
                                pn_emp  in number,
                                pn_mod  in number,
                                pn_suc  in number,
                                pn_mda  in number,
                                pn_pap  in number,
                                pn_cta  in number,
                                pn_ope  in number,
                                pn_sbo  in number,
                                pn_top  in number,
                                lc_resp out varchar2);
  Procedure Sp_Calificacion_RCC_Cyg(pn_tdo  in number,
                                    pc_ndo  in char,
                                    pn_emp  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,
                                    lc_resp out varchar2);
  Procedure Sp_Listas_Negras(pn_cta in number, lc_lista out varchar2);
  Procedure Sp_conteo_bloqueos(pn_pai  in number,
                               pn_tdo  in number,
                               pc_ndo  in char,
                               pn_cvar in number,
                               ln_cont out number);
  Procedure Sp_bloqueo_vigente(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pd_fecpro in date,
                               Pn_cta    in number,
                               pn_ope    in number,
                               ln_vig    out number);
  Procedure Sp_diasAtrasoLineas_Central(pn_emp        in number,
                                        pn_mod        in number,
                                        pn_suc        in number,
                                        pn_mda        in number,
                                        pn_pap        in number,
                                        pn_cta        in number,
                                        pn_ope        in number,
                                        pn_sbo        in number,
                                        pn_top        in number,
                                        pd_fecpro     in date,
                                        ln_diaTot     out number,
                                        ln_contCuoTot out number);
  Procedure Sp_CalCuo_Lin_Central(pn_emp      in number,
                                  pn_mod      in number,
                                  pn_suc      in number,
                                  pn_mda      in number,
                                  pn_pap      in number,
                                  pn_cta      in number,
                                  pn_ope      in number,
                                  pn_sbo      in number,
                                  pn_top      in number,
                                  pd_fecpro   in date,
                                  pn_stat     in number,
                                  ln_contador out number,
                                  ln_diasTot  out number);
  Procedure Sp_BloqueoMora(pn_pai    in number,
                           pn_tdo    in number,
                           pc_ndo    in char,
                           lc_existe out varchar2,
                           lc_flg    out varchar2);
  Procedure Sp_Segmento_Des(pn_ins in number,
                            pc_seg out varchar2,
                            pn_pai out number,
                            pn_tdo out number,
                            pc_ndo out varchar2,
                            pd_fec out date);
  Procedure Sp_carga_data_MENSUAL(pd_fecpro in date);
  Procedure Sp_cr_Inserta_MENSUAL(pd_fecpro in date, pd_fecini in date);
  --Procedure Sp_HistNR_PYME_INI(pd_Fecpro in date);
  --Function Fn_RelCredi_NR(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date)
  --                      return number ;
  --Procedure Sp_Hist_NR_MENS(pd_Fecpro in date) ;
  --Function fn_inserta_pymeNR(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fec in date)
  return number;
  Procedure Sp_Obtiene_HistPyme(pn_pai in number,
                                pn_tdo in number,
                                pc_ndo in char,
                                pc_his out varchar2);
  Procedure Sp_RelCrediNR_PYME(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_Fecpro   in date,
                               ln_contador out number);
end PQ_CR_RELCREDITICIA;
/

create or replace package body PQ_CR_RELCREDITICIA is

  Procedure Sp_cr_historial(pn_pai      in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecini   in date,
                            pd_fecpro   in date,
                            ln_contador out number,
                            ln_aostat   out number,
                            ln_emp      out number,
                            ln_mod      out number,
                            ln_suc      out number,
                            ln_mda      out number,
                            ln_pap      out number,
                            ln_cta      out number,
                            ln_ope      out number,
                            ln_sbo      out number,
                            ln_top      out number,
                            ld_feccan   out date) is
  
    cursor creditos is
      select *
        from jaqz074_aux_ii a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
       order by aofval;
  
    cursor creditos_i is
      select *
        from jaqz074_aux_ii a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
       order by aostat, aofe99 desc;
  
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
  
    ld_sysdate date;
  
    ln_sw number(1);
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      ld_sysdate  := last_day(pd_fecpro);
      For i in creditos loop
        ln_sw := 0;
        if (i.aofe99 is null or
           i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
           i.aostat = 99 then
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
            ld_fecantC := pd_fecpro; -- trunc(sysdate);
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
    
      For j in creditos_i loop
      
        ln_emp    := j.pgcod;
        ln_mod    := j.aomod;
        ln_suc    := j.aosuc;
        ln_mda    := j.aomda;
        ln_pap    := j.aopap;
        ln_cta    := j.aocta;
        ln_ope    := j.aooper;
        ln_sbo    := j.aosbop;
        ln_top    := j.aotope;
        ln_aostat := j.aostat;
        ld_feccan := j.aofe99;
        exit;
      end loop;
    end;
  
  end Sp_cr_historial;

  Procedure Sp_carga_data(pd_fecpro in date) is
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
        ln_vig := 60; --cambiar en produccion
    
    end;
  
    ld_fecini := add_months(pd_fecpro, -ln_vig);
    execute immediate ('truncate table jaqz074_aux');
    execute immediate ('truncate table jaqz074_aux_ii');
    begin
    
      insert into jaqz074_aux
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
         flag,
         hipo)
        select a.pgcod,
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
               pq_cr_relcrediticia.Fn_DiaPago(PGCOD,
                                              AOMOD,
                                              AOSUC,
                                              AOMDA,
                                              AOPAP,
                                              AOCTA,
                                              AOOPER,
                                              AOSBOP,
                                              AOTOPE,
                                              aostat,
                                              a.aofe99),
               --a.aofe99,
               a.aostat,
               (case
                 when aofe99 = to_date('0001.01.01', 'yyyy.mm.dd') and
                      aostat = 99 and aofval < ld_fecini then
                  'N'
                 else
                  'S'
               end),
               Case
                 when aomod = 110 and
                      aotope not in (select a.tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 5000
                                        and a.tp1corr2 = 1) then
                  'N'
                 else
                  'S'
               end
          from fsd010 a
         where (aomod in
               (select modulo
                   from fst111
                  where dscod = 50
                    and modulo not in (200, 33, 108, 106, 107)))
           and (aofe99 >= ld_fecini or
               aofe99 = to_date('0001.01.01', 'yyyy.mm.dd'))
           and aotope <> 550;
      commit;
    
    end;
  
    begin
    
      insert into jaqz074_aux_ii
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
      
        select a.pgcod,
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
               a.aofe99,
               a.aostat,
               b.pepais,
               b.petdoc,
               b.pendoc
          from jaqz074_aux a, fsr008 b
         where b.ctnro = a.aocta
           and b.cttfir = 'T'
           AND A.FLAG = 'S'
           and hipo = 'S';
      commit;
    
    end;
  
    commit;
  
    Pq_Cr_Relcrediticia.Sp_cr_Inserta(pd_fecpro, ld_fecini);
  end Sp_carga_data;

  Procedure Sp_cr_Inserta(pd_fecpro in date, pd_fecini in date) is
  
    cursor creditos is
      select * from JAQZ074_AUX_II a;
    ln_contador number(5);
    ln_ins      number(1);
    ln_anio     number(4);
    ln_mes      number(2);
    ln_inserta  char(1);
    ld_feccan   date;
    ln_estado   number(2);
    ln_emp      number(3);
    ln_mod      number(3);
    ln_suc      number(3);
    ln_mda      number(4);
    ln_pap      number(4);
    ln_cta      number(9);
    ln_ope      number(9);
    ln_sbo      number(3);
    ln_top      number(3);
  
    ld_fecini date;
  
    ld_fec date;
    LN_AUX NUMBER(9);
  begin
  
    Begin
    
      ln_anio := to_number(to_char(pd_fecpro, 'yyyy'));
      ln_mes  := to_number(to_char(pd_fecpro, 'mm'));
    
      ld_fecini := to_date(to_char(pd_fecini, 'yyyymm') || '01', 'yyyymmdd');
      for i in creditos loop
        ln_contador := null;
        ln_inserta  := NULL;
        ln_ins      := PQ_CR_RELCREDITICIA.fn_inserta(i.pepais,
                                                      i.petdoc,
                                                      i.pendoc,
                                                      ln_anio,
                                                      ln_mes);
      
        if ln_ins = 0 then
          --pq_cr_relcrediticia.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
          --                                     ld_feccan);
          --if ln_inserta = 'S' then
          PQ_CR_RELCREDITICIA.Sp_cr_historial(i.pepais,
                                              i.petdoc,
                                              i.pendoc,
                                              ld_fecini,
                                              pd_fecpro,
                                              ln_contador,
                                              ln_estado,
                                              ln_emp,
                                              ln_mod,
                                              ln_suc,
                                              ln_mda,
                                              ln_pap,
                                              ln_cta,
                                              ln_ope,
                                              ln_sbo,
                                              ln_top,
                                              ld_fec);
        
          insert into jaqz074
            (JAQZ074PAI,
             JAQZ074TDO,
             JAQZ074NDO,
             JAQZ074ANI,
             JAQZ074MES,
             JAQZ074FEP,
             jaqz074his,
             JAQZ074FCN,
             jaqz074est,
             jaqz074pgc,
             jaqz074mod,
             jaqz074suc,
             jaqz074mda,
             jaqz074pap,
             jaqz074cta,
             jaqz074ope,
             jaqz074sbo,
             jaqz074top,
             jaqz074FEC)
          
          values
            (i.pepais,
             i.petdoc,
             i.pendoc,
             ln_anio,
             ln_mes,
             pd_fecpro,
             ln_contador,
             ld_feccan,
             ln_estado,
             ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ld_fec);
        
          commit;
        
          --end if;
        
        end if;
        commit;
      
      end loop;
    
      LN_AUX := to_number(to_char(pd_fecpro, 'ddmmyyyy'));
      /*UPDATE FST198 set tp1nro1 = LN_AUX
      where tp1cod1 = 10823
        and tp1corr1 = 8
        and tp1corr2 = 1;
        commit;*/
    
      commit;
    end;
  
  end Sp_cr_Inserta;

  Function fn_inserta(pn_pai  in number,
                      pn_tdo  in number,
                      pc_ndo  in char,
                      pn_anio in number,
                      pn_mes  in number) return number is
    ln_existe number(1);
  
  begin
  
    begin
      select 1
        into ln_existe
        from jaqz074 a
       where a.jaqz074pai = pn_pai
         and a.jaqz074tdo = pn_tdo
         and a.jaqz074ndo = pc_ndo
         and a.jaqz074ani = pn_anio
         and a.jaqz074mes = pn_mes;
    
    exception
      when others then
        ln_existe := 0;
    end;
  
    if ln_existe is null then
      ln_existe := 0;
    end if;
    return ln_existe;
  end fn_inserta;

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
                       pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,
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
  
    PQ_CR_RELCREDITICIA.Sp_cr_InsNuevo(pn_pais,
                                       pn_tdo,
                                       pc_ndo,
                                       pd_fecpro,
                                       ld_fecini,
                                       ln_contador);
  
  end Sp_cr_ReCalcula;

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
        PQ_CR_RELCREDITICIA.Sp_cr_histNuevo(i.pepais,
                                            i.petdoc,
                                            i.pendoc,
                                            pd_fecini,
                                            pd_fecpro,
                                            ln_contador);
      
      end loop;
      commit;
    end;
  
  end Sp_cr_InsNuevo;

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
            ld_fecantC := trunc(sysdate);
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

  Procedure Sp_cr_cancelados(pn_pai     in number,
                             pn_tdo     in number,
                             pc_ndo     in char,
                             pd_fecpro  in date,
                             ln_inserta out char,
                             ld_feccan  out date) is
  
    cursor creditos is
      select *
        from jaqz074_aux_ii a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
       order by a.aofe99 desc;
    ln_vig    number(9);
    ld_fecuso date;
    ld_fecaux date;
    lc_flag   char(1);
  begin
    ld_fecuso  := null;
    lc_flag    := null;
    ln_inserta := null;
    begin
      select tp1nro1
        into ln_vig
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 2
         and tp1corr2 = 2;
    
    exception
      when others then
        ln_vig := 0;
      
    end;
  
    begin
    
      for i in creditos loop
        if i.aostat <> 99 then
          lc_flag := 'N';
          exit;
        end if;
      
      end loop;
    
    end;
  
    begin
    
      if lc_flag is null then
      
        for j in creditos loop
          if j.aostat = 99 then
            ld_fecuso := j.aofe99;
            exit;
          end if;
        end loop;
      
      end if;
    
    end;
  
    begin
      ld_fecaux := add_months(pd_fecpro, -ln_vig);
      if ld_fecuso < ld_fecaux then
        ln_inserta := 'N';
      else
        ln_inserta := 'S';
        ld_feccan  := ld_fecuso;
      end if;
    end;
  
  end Sp_cr_cancelados;

  Procedure Sp_carga_mensual(pd_fecpro in date) is
  
    cursor creditos(ln_mes in number, ln_anio in number) is
      select *
        from jaqz074
       where jaqz074mes = ln_mes
         and jaqz074ani = ln_anio;
  
    ln_mes      number(2);
    ln_anio     number(4);
    ln_estact   number(2);
    ln_contador number(5);
  begin
    ln_mes  := to_number(to_char(pd_fecpro, 'mm'));
    ln_anio := to_number(to_char(pd_fecpro, 'yyyy'));
  
    if ln_mes = 1 then
      ln_mes  := 12;
      ln_anio := ln_anio - 1;
    else
      ln_mes := ln_mes - 1;
    end if;
  
    begin
    
      for i in creditos(ln_mes, ln_anio) loop
        if i.jaqz074est <> 99 then
          begin
            select a.aostat
              into ln_estact
              from fsd010 a
             where a.pgcod = i.jaqz074pgc
               and a.aomod = i.jaqz074mod
               and a.aosuc = i.jaqz074suc
               and a.aomda = i.jaqz074mda
               and a.aopap = i.jaqz074pap
               and a.aocta = i.jaqz074cta
               and a.aooper = i.jaqz074ope
               and a.aosbop = i.jaqz074sbo
               and a.aotope = i.jaqz074top;
          exception
            when others then
              null;
          end;
        
          if ln_estact <> 99 then
            ln_contador := i.jaqz074his + 1;
          else
            ln_contador := i.jaqz074his;
          end if;
        
        else
          ln_contador := i.jaqz074his;
        
        end if;
      end loop;
    
    end;
  
  end Sp_carga_mensual;

  Procedure Sp_Carga_Atraso(pd_fecpro in date) is
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
         and tp1corr2 = 4;
    exception
      when others then
        ln_vig := 60; --cambiar en produccion
    
    end;
  
    ld_fecini := add_months(pd_fecpro, -ln_vig);
    execute immediate ('truncate table jaqz080_aux');
    execute immediate ('truncate table jaqz080_aux_ii');
    begin
    
      insert into jaqz080_aux
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
         AOSTAT)
        select a.pgcod,
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
               pq_cr_relcrediticia.Fn_DiaPago(PGCOD,
                                              AOMOD,
                                              AOSUC,
                                              AOMDA,
                                              AOPAP,
                                              AOCTA,
                                              AOOPER,
                                              AOSBOP,
                                              AOTOPE,
                                              aostat,
                                              aofe99) aofe99,
               a.aostat
        
          from fsd010 a
         where aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (200, 33, 108))
           and (aofe99 >= ld_fecini or
               aofe99 = to_date('0001.01.01', 'yyyy.mm.dd'))
           and aofval <= pd_fecpro
           and aotope <> 550;
      commit;
    
    end;
  
    begin
    
      insert into jaqz080_aux_ii
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
         fecuso)
      
        select a.pgcod,
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
               a.aofe99,
               a.aostat,
               b.pepais,
               b.petdoc,
               b.pendoc,
               (case
                 when aostat <> 99 then
                  aofvto
                 else
                  aofe99
               end) fecuso
          from jaqz080_aux a, fsr008 b
         where b.ctnro = a.aocta
           and b.pgcod = 1
           and b.cttfir = 'T';
      commit;
    
    end;
  
    commit;
  
    Pq_Cr_Relcrediticia.Sp_cr_Inserta_DiaAtraso(pd_fecpro, ld_fecini);
  
  end Sp_Carga_Atraso;

  Procedure Sp_cr_Inserta_DiaAtraso(pd_fecpro in date, pd_fecini in date) is
  
    cursor creditos is
      select * from JAQZ080_AUX_II a;
  
    ln_contador number(5);
    ln_ins      number(1);
    ln_anio     number(4);
    ln_mes      number(2);
    ln_inserta  char(1);
    --ld_feccan date;
    /*ln_estado number(2);
    ln_emp number(3);
    ln_mod number(3);
    ln_suc number(3);
    ln_mda number(4);
    ln_pap number(4);
    ln_cta number(9);
    ln_ope number(9);
    ln_sbo number(3);
    ln_top number(3);*/
    ln_dia      number(10);
    ln_promedio number(18, 2);
    ld_fecini   date;
  begin
  
    Begin
    
      ln_anio   := to_number(to_char(pd_fecpro, 'yyyy'));
      ln_mes    := to_number(to_char(pd_fecpro, 'mm'));
      ld_fecini := to_date(to_char(pd_fecini, 'yyyymm') || '01', 'yyyymmdd');
      for i in creditos loop
        ln_contador := null;
        ln_inserta  := NULL;
        ln_promedio := null;
        ln_ins      := PQ_CR_RELCREDITICIA.fn_inserta_DiaAtr(i.pepais,
                                                             i.petdoc,
                                                             i.pendoc,
                                                             pd_fecpro);
      
        if ln_ins = 0 then
          --pq_cr_relcrediticia.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
          --                                     ld_feccan);
          --if ln_inserta = 'S' then
          PQ_CR_RELCREDITICIA.Sp_cr_histDiaAtr(i.pepais,
                                               i.petdoc,
                                               i.pendoc,
                                               Pd_fecpro,
                                               ld_fecini,
                                               ln_contador,
                                               ln_dia);
          if ln_contador = 0 then
            --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
            ln_promedio := 0;
          else
            ln_promedio := round((ln_dia / ln_contador), 2);
          end if;
        
          insert into jaqz080
            (JAQZ080PAI,
             JAQZ080TDO,
             JAQZ080NDO,
             JAQZ080ANI,
             JAQZ080MES,
             JAQZ080FEP,
             jaqz080DIA)
          
          values
            (i.pepais,
             i.petdoc,
             i.pendoc,
             ln_anio,
             ln_mes,
             pd_fecpro,
             ln_promedio);
        
          commit;
          --end if;
        
        end if;
        commit;
      
      end loop;
      commit;
    end;
  
  end Sp_cr_Inserta_DiaAtraso;

  Function fn_inserta_DiaAtr(pn_pai    in number,
                             pn_tdo    in number,
                             pc_ndo    in char,
                             pd_fecpro in date) return number is
    ln_existe number(1);
  
  begin
  
    begin
      select 1
        into ln_existe
        from jaqz080 a
       where a.jaqz080pai = pn_pai
         and a.jaqz080tdo = pn_tdo
         and a.jaqz080ndo = pc_ndo
         and a.jaqz080fep = pd_fecpro;
      --                 and a.jaqz080ani = pn_anio
      --                 and a.jaqz080mes = pn_mes;
    
    exception
      when others then
        ln_existe := 0;
    end;
  
    if ln_existe is null then
      ln_existe := 0;
    end if;
    return ln_existe;
  end fn_inserta_DiaAtr;

  Procedure Sp_cr_histDiaAtr(pn_pai        in number,
                             pn_tdo        in number,
                             pc_ndo        in char,
                             pd_fecpro     in date,
                             pd_fecini     in date,
                             ln_contCuoTot out number,
                             ln_diaTot     out number) is
  
    cursor creditos is
      select *
        from jaqz080_aux_ii a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
       order by aostat, aofe99 desc, aofval desc;
  
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
    ln_contador number(10);
  
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
      pq_cr_relcrediticia.Sp_cr_histDiaAtr_ii(pn_pai,
                                              pn_tdo,
                                              pc_ndo,
                                              ld_feccorte,
                                              pd_fecpro,
                                              ln_contCuoTot,
                                              ln_diaTot);
    
    end;
  end Sp_cr_histDiaAtr;

  Procedure Sp_cr_histDiaAtr_II(pn_pai        in number,
                                pn_tdo        in number,
                                pc_ndo        in char,
                                pd_fecor      in date,
                                pd_fecpro     in date,
                                ln_contCuoTot out number,
                                ln_diaTot     out number) is
  
    cursor creditos is
    
      select *
        from JAQZ080_AUX_II a
       WHERE a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and fecuso >= pd_fecor
       order by aofval desc;
  
    ln_contCuotas number(10);
    ln_dia        number(10);
  
    ld_feccan date;
  begin
  
    begin
      ln_contCuoTot := 0;
      ln_diaTot     := 0;
      for i in creditos loop
        if i.aostat = 99 then
          --ld_feccan := last_day(i.aofe99);
          ld_feccan := i.aofe99;
        else
          ld_feccan := pd_fecpro;
        end if;
        pq_cr_relcrediticia.sp_calculaCuotas(i.pgcod,
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
                                             i.aostat, --pd_fecpro,
                                             ln_contCuotas,
                                             ln_dia);
        ln_diaTot     := ln_diaTot + ln_dia;
        ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
      end loop;
    
    end;
  
  end Sp_cr_histDiaAtr_II;

  Procedure Sp_CalculaCuotas(pn_emp      in number,
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
    ln_dias number(10);
    --ln_diasTot number(5);
  
    --ld_fecpag date;
    --ln_mpag number(2);
    --ln_mdpa number(2);
    --ln_apag number(4);
    --ln_adpa number(4);
  
    ln_flag    number(1);
    ld_fecantC date;
  
    ld_fecpago date; --modificado 20151022
  
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
          
            ln_dias    := pq_cr_relcrediticia.fn_cuotasPag(i.pgcod,
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
            ln_diasTot := ln_diasTot + ln_dias;
          end if;
        
          ld_fecantC := i.ppfpag;
        end if;
      
      end loop;
    
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
  
  end Sp_CalculaCuotas;

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
         and a.ppfpag = pd_fec
         and a.d602co = 'S'
         and a.pp1stat = 'T'
         and (a.pp1cap + a.pp1int) <> 0
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

  Procedure Sp_RelCredi_NR(pn_pai      in number,
                           pn_tdo      in number,
                           pc_ndo      in char,
                           pd_Fecpro   in date,
                           ln_contador out number) is
  
    cursor creditos is
      select a.pgcod,
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
             pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,
                                            AOMOD,
                                            AOSUC,
                                            AOMDA,
                                            AOPAP,
                                            AOCTA,
                                            AOOPER,
                                            AOSBOP,
                                            AOTOPE,
                                            aostat,
                                            aofe99) aofe99,
             a.aostat
        from fsd010 a, fsr008 b
       where aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in (200, 33, 108))
            --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
         and aotope <> 550
         and a.pgcod = 1
         and a.pgcod = b.pgcod
         and a.aocta = b.ctnro
         and b.pepais = pn_pai
         and b.petdoc = pn_tdo
         and b.pendoc = pc_ndo
       order by aofval;
  
    ld_fecantD date;
    ld_fecantC date;
  
    ln_mesac number(2);
    ln_aniac number(4);
    ln_mesan number(2);
    ln_anian number(4);
    ln_suma  number(5);
  
    ld_aofval  date;
    ld_aofe99  date;
    ld_sysdate DATE;
  
    ln_sw number(1);
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      ld_sysdate  := last_day(pd_fecpro);
      For i in creditos loop
      
        ln_sw := 0;
        if (i.aofe99 is null or
           i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
           i.aostat = 99 then
          ln_sw := 1;
        
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.aofval, 'mm'));
          ln_aniac  := to_number(to_char(i.aofval, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.aofval;
          ld_aofe99 := last_day(i.aofe99);
        
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
                
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                
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
            ld_fecantC := pd_Fecpro; --trunc(sysdate);
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
    
    END;
  
    /*
      begin
     ln_contador := 0;  
     ld_fecantD := null;
     ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
     
     For i in creditos loop
         ln_mesac := to_number(to_char(i.aofval,'mm'));
         ln_aniac := to_number(to_char(i.aofval,'yyyy'));
         ln_suma := null;
         ld_aofval := i.aofval;
         ld_aofe99 := last_day(i.aofe99);
         
         if ld_fecantD is null then
               if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                  if ln_suma <0 then 
                     ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                  else 
                      ln_suma := trunc(months_between(pd_Fecpro,ld_aofval))+1;
                      if ln_suma <0 then 
                         ln_suma := 0;
                      end if;
                      ln_contador := ln_contador + ln_suma;
                  
               end if;
               
               Else
                    
                   if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                      if i.aostat = 99 then
                           ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                            if ln_suma <0 then 
                               ln_suma := 0;
                            end if;       
                           ln_contador := ln_contador + ln_suma;
                           
                           else
                             ln_suma := trunc(months_between(pd_Fecpro,
                                                                ld_aofval));
                              if ln_suma <0 then 
                                 ln_suma := 0;
                              end if;          
                             ln_contador := ln_contador + ln_suma;
                       end if;
                       
                       else
                           if ld_aofval < ld_fecantC then
                              ld_aofval :=  ld_fecantC;
                              if i.aostat = 99 then
                                   ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                    if ln_suma <0 then 
                                       ln_suma := 0;
                                    end if;  
                              
                                   ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                   
                                   else
                                     ln_suma := trunc(months_between(pd_Fecpro,ld_aofval));
                                      if ln_suma <0 then 
                                         ln_suma := 0;
                                      end if;        
                                     
                                     ln_contador := ln_contador + ln_suma;-- - ln_aux;
                               end if;
                                   
                           
                           
                           end if;
                           
                           if ld_aofval > ld_fecantC then
                              
                              if i.aostat = 99 then
                                   ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                    if ln_suma <0 then 
                                       ln_suma := 0;
                                    end if;  
                                   ln_contador := ln_contador + ln_suma;
                                   
                                   else
                                     ln_suma := trunc(months_between(pd_Fecpro,ld_aofval))+1;
                                      if ln_suma <0 then 
                                         ln_suma := 0;
                                      end if;  
                                     ln_contador := ln_contador + ln_suma;
                               end if;
                                   
                           
                           
                           end if;
                       
                   
                   end if;
               
         end if;
         
         if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
            if ld_fecantC > i.aofval then
               ld_aofval := ld_fecantC;
            end if;
            ld_fecantC := pd_Fecpro;
         end if;
         
         if i.aofe99 > ld_fecantC then
                      
                      ld_fecantC := i.aofe99;
         
         end if;
         
         ld_fecantD := ld_aofval;
         
         
         
         ln_mesan := to_number(to_char(ld_fecantC,'mm'));
         ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
     end loop;
    
    end;     */
  
  end Sp_RelCredi_NR;

  Procedure Sp_DiaAtraso_linea(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_fecpro   in date,
                               ln_promedio out number) is
  
    ld_fecini   date;
    ln_vig      number(9);
    ln_dia      number(18);
    ln_contador number(18);
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
  
    PQ_CR_RELCREDITICIA.Sp_cr_histDiaAtr_linea(pn_pai,
                                               pn_tdo,
                                               pc_ndo,
                                               Pd_fecpro,
                                               ld_fecini,
                                               ln_contador,
                                               ln_dia);
    if ln_contador = 0 then
      --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
      ln_promedio := 0;
    else
      ln_promedio := round((ln_dia / ln_contador), 2);
    end if;
  
    --      Sp_cr_histDiaAtr_linea
  end Sp_DiaAtraso_linea;

  Procedure Sp_cr_histDiaAtr_linea(pn_pai        in number,
                                   pn_tdo        in number,
                                   pc_ndo        in char,
                                   pd_fecpro     in date,
                                   pd_fecini     in date,
                                   ln_contCuoTot out number,
                                   ln_diaTot     out number) is
  
    cursor creditos is
      select *
        from jaqz081 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
       order by aostat, aofe99 desc, aofval desc; --aofe99;--aofval DESC;
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
      pq_cr_relcrediticia.Sp_cr_histDiaAtr_linea_ii(pn_pai,
                                                    pn_tdo,
                                                    pc_ndo,
                                                    ld_feccorte,
                                                    pd_fecpro, /*pd_fecini,*/
                                                    ln_contCuoTot,
                                                    ln_diaTot);
    
    end;
  end Sp_cr_histDiaAtr_linea;

  Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai        in number,
                                      pn_tdo        in number,
                                      pc_ndo        in char,
                                      pd_fecor      in date,
                                      pd_fecpro     in date, /*pd_fecini in date,*/
                                      ln_contCuoTot out number,
                                      ln_diaTot     out number) is
  
    cursor creditos is
    
      select *
        FROM JAQZ081 a
       WHERE a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.feuso >= pd_fecor
       order by aofval desc;
  
    /*cursor creditos is
    Select * from(
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
                   and aotope <> 550)
                   where feuso >=pd_fecor
    order by aofval desc;*/
  
    ln_contCuotas number(18);
    ln_dia        number(18);
  
    ld_feccan date;
  begin
  
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
        pq_cr_relcrediticia.sp_calculaCuotas(i.pgcod,
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
                                             ln_dia);
        ln_diaTot     := ln_diaTot + ln_dia;
        ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
      end loop;
    
    end;
  
  end Sp_cr_histDiaAtr_linea_ii;

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

  Procedure Sp_Carga_NR(pd_fecpro in date) is
    --ld_fecini date;
    --ln_vig number(9);
  begin
  
    /* begin
        select tp1nro1 
          into ln_vig
          from fst198 
         where tp1cod = 1 
           and tp1cod1 = 10899
           and tp1corr1 = 2
           and tp1corr2 = 4;
    exception
           when others then ln_vig := 60;--cambiar en produccion
    
    end;*/
  
    --ld_fecini:=add_months(pd_fecpro,-ln_vig);    
    execute immediate ('truncate table jaqz083_aux');
    execute immediate ('truncate table jaqz083_aux_ii');
    begin
    
      insert into jaqz083_aux
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
         AOSTAT)
        select a.pgcod,
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
               pq_cr_relcrediticia.Fn_DiaPago(PGCOD,
                                              AOMOD,
                                              AOSUC,
                                              AOMDA,
                                              AOPAP,
                                              AOCTA,
                                              AOOPER,
                                              AOSBOP,
                                              AOTOPE,
                                              aostat,
                                              aofe99) aofe99,
               a.aostat
        
          from fsd010 a
         where aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (200, 33, 108))
              --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
           and aotope <> 550;
      commit;
    
    end;
  
    begin
    
      insert into jaqz083_aux_ii
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
         fecuso)
      
        select a.pgcod,
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
               a.aofe99,
               a.aostat,
               b.pepais,
               b.petdoc,
               b.pendoc,
               (case
                 when aostat <> 99 then
                  aofvto
                 else
                  aofe99
               end) fecuso
          from jaqz083_aux a, fsr008 b
         where b.ctnro = a.aocta
           and b.pgcod = 1
           and b.cttfir = 'T';
      commit;
    
    end;
  
    commit;
  
    Pq_Cr_Relcrediticia.Sp_cr_Inserta_NR(pd_fecpro);
  
  end Sp_Carga_NR;

  Procedure Sp_cr_Inserta_NR(pd_fecpro in date) is
  
    cursor creditos is
      select * from JAQZ083_AUX_II a;
  
    ln_contador number(5);
    ln_ins      number(1);
    ln_anio     number(4);
    ln_mes      number(2);
    ln_inserta  char(1);
    --ld_feccan date;
    /*ln_estado number(2);
    ln_emp number(3);
    ln_mod number(3);
    ln_suc number(3);
    ln_mda number(4);
    ln_pap number(4);
    ln_cta number(9);
    ln_ope number(9);
    ln_sbo number(3);
    ln_top number(3);*/
    --ln_dia number(10);
    ln_promedio number(10);
    Tip_Hist    CHAR(1);
    --ld_fecini date;
  begin
  
    Begin
    
      ln_anio := to_number(to_char(pd_fecpro, 'yyyy'));
      ln_mes  := to_number(to_char(pd_fecpro, 'mm'));
      --ld_fecini := to_date(to_char(pd_fecini,'yyyymm')||'01','yyyymmdd')   ;   
      for i in creditos loop
        ln_contador := null;
        ln_inserta  := NULL;
        ln_promedio := null;
        ln_ins      := PQ_CR_RELCREDITICIA.fn_inserta_NR(i.pepais,
                                                         i.petdoc,
                                                         i.pendoc,
                                                         pd_fecpro);
      
        if ln_ins = 0 then
          --pq_cr_relcrediticia.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
          --                                     ld_feccan);
          --if ln_inserta = 'S' then
          PQ_CR_RELCREDITICIA.Sp_RelCredi_NR(i.pepais,
                                             i.petdoc,
                                             i.pendoc,
                                             Pd_fecpro,
                                             ln_contador);
        
          if ln_contador > 18 then
            Tip_Hist := 'A';
          else
            if ln_contador <= 18 and ln_contador >= 6 then
              Tip_Hist := 'B';
            else
              if ln_contador < 6 then
                Tip_Hist := 'C';
              end if;
            end if;
          end if;
        
          insert into jaqz083
            (JAQZ083PAI,
             JAQZ083TDO,
             JAQZ083NDO,
             JAQZ083ANI,
             JAQZ083MES,
             JAQZ083FEP,
             jaqz083HNR)
          
          values
            (i.pepais,
             i.petdoc,
             i.pendoc,
             ln_anio,
             ln_mes,
             pd_fecpro,
             Tip_Hist);
        
          commit;
          --end if;
        
        end if;
        commit;
      
      end loop;
      commit;
    end;
  
  end Sp_cr_Inserta_NR;

  Function fn_inserta_NR(pn_pai    in number,
                         pn_tdo    in number,
                         pc_ndo    in char,
                         pd_fecpro in date) return number is
    ln_existe number(1);
  
  begin
  
    begin
      select 1
        into ln_existe
        from jaqz083 a
       where a.jaqz083pai = pn_pai
         and a.jaqz083tdo = pn_tdo
         and a.jaqz083ndo = pc_ndo
         and a.jaqz083fep = pd_fecpro;
      --                 and a.jaqz080ani = pn_anio
      --                 and a.jaqz080mes = pn_mes;
    
    exception
      when others then
        ln_existe := 0;
    end;
  
    if ln_existe is null then
      ln_existe := 0;
    end if;
    return ln_existe;
  end fn_inserta_NR;

  Procedure Sp_RelCredi_NR_MENS(pd_Fecpro in date, ln_contador out number) is
  
    cursor creditos is
      select * FROM jaqz083_aux_ii order by aofval;
  
    ld_fecantD date;
    ld_fecantC date;
  
    ln_mesac number(2);
    ln_aniac number(4);
    ln_mesan number(2);
    ln_anian number(4);
    ln_suma  number(5);
  
    ld_aofval  date;
    ld_aofe99  date;
    ld_sysdate DATE;
  
    ln_sw number(1);
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      ld_sysdate  := last_day(pd_fecpro);
      For i in creditos loop
      
        ln_sw := 0;
        if (i.aofe99 is null or
           i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
           i.aostat = 99 then
          ln_sw := 1;
        
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.aofval, 'mm'));
          ln_aniac  := to_number(to_char(i.aofval, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.aofval;
          ld_aofe99 := last_day(i.aofe99);
        
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
                
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                
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
            ld_fecantC := pd_Fecpro; --trunc(sysdate);
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
    
    END;
  
  end Sp_RelCredi_NR_MENS;

  Procedure Sp_cargaRefinanciado(pd_fecpro in date) is
  
    cursor creditos is
      select a.pepais, a.petdoc, a.pendoc, a.aostat, 'S' refina
        from jaqz083_aux_ii a
       where a.aostat in (61, 33, 34)
       group by a.pepais, a.petdoc, a.pendoc, a.aostat;
    ln_ins number(1);
  begin
  
    Begin
      for i in creditos loop
        ln_ins := PQ_CR_RELCREDITICIA.fn_inserta_REF(i.pepais,
                                                     i.petdoc,
                                                     i.pendoc,
                                                     pd_fecpro);
      
        if ln_ins = 0 then
          insert into jaqz084
            (jaqz084pai, jaqz084tdo, jaqz084ndo, jaqz084fec, jaqz084ref)
          values
            (i.pepais, i.petdoc, i.pendoc, pd_fecpro, i.refina);
          commit;
        End if;
      end loop;
      commit;
    
    end;
  
  end Sp_cargaRefinanciado;

  Function fn_inserta_REF(pn_pai    in number,
                          pn_tdo    in number,
                          pc_ndo    in char,
                          pd_fecpro in date) return number is
    ln_existe number(1);
  
  begin
  
    begin
      select 1
        into ln_existe
        from jaqz084 a
       where a.jaqz084pai = pn_pai
         and a.jaqz084tdo = pn_tdo
         and a.jaqz084ndo = pc_ndo
         and a.jaqz084fec = pd_fecpro;
      --                 and a.jaqz080ani = pn_anio
      --                 and a.jaqz080mes = pn_mes;
    
    exception
      when others then
        ln_existe := 0;
    end;
  
    if ln_existe is null then
      ln_existe := 0;
    end if;
    return ln_existe;
  end fn_inserta_REF;

  /*
  Procedure Sp_cr_cancelMensual(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                                pn_anio in number,pn_mes in number,
                                ln_inserta out char) is
  
  cursor creditos is
   select a.*,c.aofe99
     from jaqz074 a,fsd010 c
    where a.jaqz074pai = pn_pai
      and a.jaqz074tdo = pn_tdo
      and a.jaqz074ndo = pc_ndo
      and a.jaqz074ani = pn_anio
      and a.jaqz074mes = pn_mes
      and a.jaqz074pgc = c.pgcod
      and a.jaqz074mod = c.aomod
      and a.jaqz074suc = c.aosuc
      and a.jaqz074mda = c.aomda
      and a.jaqz074pap = c.aopap
      and a.jaqz074cta = c.aocta
      and a.jaqz074ope = c.aooper
      and a.jaqz074sbo = c.aosbop
      and a.jaqz074top = c.aotope
  order by a.aofe99 desc
  ;
  ln_vig number(9);
  ld_fecuso date;
  ld_fecaux date;
  lc_flag char(1);
  begin
      ld_fecuso := null;
      lc_flag := null;   
      ln_inserta := null;   
      begin
          select tp1nro1 
            into ln_vig
            from fst198 
           where tp1cod = 1 
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 2;
             
      exception
               when others then ln_vig := 12;
                
      end;
      
      begin
      
          for i in creditos loop
              if i.jaqz074est <> 99 then
                 lc_flag := 'N';
                 exit;
              end if;
              
              
          end loop;
                  
      end;
      
      begin
      
          if lc_flag is null then
          
             for j in creditos loop
                 if j.jaqz074est = 99 then
                   ld_fecuso := j.aofe99;
                   exit;
                end if;
             end loop;
             
             
          end if;
          
      end;
  
      begin
          ld_fecaux := add_months(pd_fecpro,-ln_vig);
          if ld_fecuso < ld_fecaux then
             ln_inserta := 'N';
             else
                   ln_inserta := 'S';
                   ld_feccan := ld_fecuso;
          end if;
      end;
  
  end Sp_cr_cancelMensual;
  */
  /*Procedure Sp_Exceptuados(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                           pc_flg out char)is
  ln_vig number(9);
  cursor creditos is
  select *
    from fsd010 a,fsr008 b
   where (a.aomod in (select modulo from fst111 where dscod = 50) or a.aomod = 117)
     and a.pgcod = 1
     and a.pgcod = b.pgcod
     and b.pepais = pn_pai
     and b.petdoc = pn_tdo
     and b.pendoc = pc_ndo
     and b.cttfir = 'T';
  begin
     begin
          select tp1nro1 
            into ln_vig
            from fst198 
           where tp1cod = 1 
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 3;
             
      exception
               when others then ln_vig := 12;
                
      end;
     begin
          
     
     end;
  end Sp_Exceptuados;     */

  Procedure Sp_diasAtrasoLineas(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_ope    in number,
                                pn_sbo    in number,
                                pn_top    in number,
                                pd_fecpro in date,
                                pn_ins    in number,
                                pn_diatr  out number) is
    cursor creditos is
      select b.pgcod,
             b.aomod,
             b.aosuc,
             b.aomda,
             b.aopap,
             b.aocta,
             b.aooper,
             b.aosbop,
             b.aotope,
             b.aofe99,
             b.aostat
        from fsr011 a, fsd010 b
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
      union all
      select b.pgcod,
             b.aomod,
             b.aosuc,
             b.aomda,
             b.aopap,
             b.aocta,
             b.aooper,
             b.aosbop,
             b.aotope,
             b.aofe99,
             b.aostat
        from xwf700 c, fsr011 a, fsd010 b
       where c.xwfprcins = pn_ins
         and c.xwfcar3 <> '1'
         and a.r2cod = c.xwfempresa
         and a.r2mod = c.xwfmodulo
         and a.r2suc = c.xwfsucursal
         and a.r2mda = c.xwfmoneda
         and a.r2pap = c.xwfpapel
         and a.r2cta = c.xwfcuenta
         and a.r2oper = c.xwfoperacion
         and a.r2sbop = c.xwfsubope
         and a.r2tope = c.xwftipope
         and a.relcod = 46
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope;
  
    ln_contCuotas number(18);
    ln_dia        number(18);
    ln_contCuoTot number(18);
    ln_diaTot     number(18);
  
    ld_feccan date;
  
  begin
    begin
    
      ln_contCuoTot := 0;
      ln_diaTot     := 0;
    
      for i in creditos loop
        if i.aostat = 99 then
          --               
          ld_feccan := i.aofe99;
        else
        
          ld_feccan := pd_fecpro;
        end if;
        pq_cr_relcrediticia.Sp_CalculaCuotas_Lineas(i.pgcod,
                                                    i.aomod,
                                                    i.aosuc,
                                                    i.aomda,
                                                    i.aopap,
                                                    i.aocta,
                                                    i.aooper,
                                                    i.aosbop,
                                                    i.aotope,
                                                    ld_feccan,
                                                    i.aostat,
                                                    ln_contCuotas,
                                                    ln_dia);
        ln_diaTot     := ln_diaTot + ln_dia;
        ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
      end loop;
    
      if ln_contCuoTot = 0 then
        --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
        pn_diatr := 0;
      else
        pn_diatr := round((ln_diaTot / ln_contCuoTot), 2);
      end if;
    
    end;
  
  end Sp_diasAtrasoLineas;

  Procedure Sp_CalculaCuotas_Lineas(pn_emp      in number,
                                    pn_mod      in number,
                                    pn_suc      in number,
                                    pn_mda      in number,
                                    pn_pap      in number,
                                    pn_cta      in number,
                                    pn_ope      in number,
                                    pn_sbo      in number,
                                    pn_top      in number,
                                    pd_fecpro   in date,
                                    pn_stat     in number,
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
         and a.ppfpag < pd_fecpro
         and (a.ppcap + a.ppint) <> 0
         and a.d601co = 'S';
  
    ln_dias    number(10);
    ln_flag    number(1);
    ld_fecantC date;
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
      ln_flag     := 0;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      For i in creditos loop
      
        if ld_fecantC <> i.ppfpag then
          ln_contador := ln_contador + 1;
        
          ln_dias    := pq_cr_relcrediticia.fn_cuotasPag(i.pgcod,
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
      end loop;
    
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
             and a.ppfpag >= pd_fecpro
             and (a.ppcap + a.ppint) <> 0
             and a.d601co = 'S'
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
  
  end Sp_CalculaCuotas_Lineas;

  Procedure Sp_MoraMaxCuotas(pn_cta    in number,
                             pd_fecpro in date,
                             ln_diafin out number) is
    cursor creditos(ln_pepais in number,
                    ln_petdoc in number,
                    lc_pendoc in char) is
      select a.pgcod,
             a.pepais,
             a.petdoc,
             a.pendoc,
             b.aomod,
             b.aosuc,
             b.aomda,
             b.aopap,
             b.aocta,
             b.aooper,
             b.aosbop,
             b.aotope
        from fsr008 a, fsd010 b
       where a.pepais = ln_pepais
         and a.petdoc = ln_petdoc
         and a.pendoc = lc_pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (select x.tp1nro1
                                      from fst198 x
                                     where x.tp1cod = 1
                                       and x.tp1cod1 = 10899
                                       and x.tp1corr1 = 950
                                       and x.tp1corr2 = 1)) --mod@abr 20191105
         and b.aostat <> 99;
  
    cursor clientes is
      select a.pepais, a.petdoc, a.pendoc
        from fsr008 a
       where a.ctnro = pn_cta;
  
    cursor calendario(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number) is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag --,
      --b.ppfpag pag602,
      -- b.pp1fech
        from fsd601 a --,fsd602 b
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag < pd_fecpro
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0
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
      and b.d602co = 'S'*/
      ;
  
    ln_dias number(18);
  
    ln_diaMax  number(9);
    ln_diafinC number(18);
  begin
    begin
      ln_diafin := 0;
      ln_dias   := 0;
      for k in clientes loop
        for i in creditos(k.pepais, k.petdoc, k.pendoc) loop
          for j in calendario(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope) loop
          
            ln_dias := pq_cr_relcrediticia.fn_cuotasPag(j.pgcod,
                                                        j.ppmod,
                                                        j.ppsuc,
                                                        j.ppmda,
                                                        j.pppap,
                                                        j.ppcta,
                                                        j.ppoper,
                                                        j.ppsbop,
                                                        j.pptope,
                                                        j.ppfpag,
                                                        pd_fecpro);
            if ln_dias > ln_diafin then
              ln_diafin := ln_dias;
            end if;
          end loop;
        end loop;
      end loop;
    end;
    begin
      select a.tp1nro1
        into ln_diaMax
        from fst198 a
       where a.tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 4
         and tp1corr2 = 1;
    exception
      when no_data_found then
        ln_diafin := 0;
      
    end;
    if ln_diafin < ln_diaMax then
      for i in clientes loop
        pq_cr_relcrediticia.Sp_MoraMaxCuotas_CYG(i.pepais,
                                                 i.petdoc,
                                                 i.pendoc,
                                                 pd_fecpro,
                                                 ln_diafin,
                                                 ln_diafinC);
      end loop;
    end if;
  end Sp_MoraMaxCuotas;

  Procedure Sp_MoraMaxCuotas_Cyg(pn_pai     in number,
                                 pn_tdo     in number,
                                 pc_ndo     in char,
                                 pd_fecpro  in date,
                                 ln_diafin  in number,
                                 ln_diafinC out number) is
    cursor creditos is
      select a.pgcod,
             a.pepais,
             a.petdoc,
             a.pendoc,
             b.aomod,
             b.aosuc,
             b.aomda,
             b.aopap,
             b.aocta,
             b.aooper,
             b.aosbop,
             b.aotope
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = pn_pai
         and c.petdoc = pn_tdo
         and c.pendoc = pc_ndo
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod in (select modulo from fst111 where dscod = 50)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor calendario(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number) is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag --,
      --b.ppfpag pag602,
      -- b.pp1fech
        from fsd601 a --,fsd602 b
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag < pd_fecpro
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0
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
      and b.d602co = 'S'*/
      ;
  
    ln_dias number(18);
  begin
    begin
      --ln_diafin := 0;
      ln_diafinC := ln_diafin;
      ln_dias    := 0;
      for i in creditos loop
        for j in calendario(i.pgcod,
                            i.aomod,
                            i.aosuc,
                            i.aomda,
                            i.aopap,
                            i.aocta,
                            i.aooper,
                            i.aosbop,
                            i.aotope) loop
        
          ln_dias := pq_cr_relcrediticia.fn_cuotasPag(j.pgcod,
                                                      j.ppmod,
                                                      j.ppsuc,
                                                      j.ppmda,
                                                      j.pppap,
                                                      j.ppcta,
                                                      j.ppoper,
                                                      j.ppsbop,
                                                      j.pptope,
                                                      j.ppfpag,
                                                      pd_fecpro);
          if ln_dias > ln_diafinC then
            ln_diafinC := ln_dias;
          end if;
        end loop;
      end loop;
    
    end;
  end Sp_MoraMaxCuotas_Cyg;

  Procedure Sp_JudiCast(pn_cta   in number,
                        pn_ins   in number,
                        ln_exfin out varchar2) is
  
    cursor clientes is
      select pepais, petdoc, pendoc from fsr008 where ctnro = pn_cta;
  
    ln_existe number(1);
    ln_exAval number(1);
    ln_exCYG  number(1);
  
  begin
    ln_existe := 0;
    ln_exAval := 0;
    ln_exCYG  := 0;
    ln_exfin  := 'N';
    --titular
    begin
      select 1
        into ln_existe
        from fsr008 a, fsd010 b
       where a.ctnro = pn_cta
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aostat in (select tp1nro1
                            from fst198 f
                           where f.tp1cod = 1
                             and tp1cod1 = 10899
                             and tp1corr1 = 900
                             and tp1corr2 = 1) --kdvc 12102017 (21,22,23,25,64,90,33,34)
         and b.aomod in (select modulo
                           from fst111
                          where dscod = 50
                         union
                         select 65
                           from dual) --kdvc 12102017 se agrego union
         and rownum = 1;
    Exception
      when no_data_found then
        ln_existe := 0;
    end;
    ln_exCYG := 0;
    for i in clientes loop
      --conyugues
      begin
        select 1
          into ln_exCYG
          from fsr008 a, fsd010 b, fsr002 c
         where c.pepais = i.pepais
           and c.petdoc = i.petdoc
           and c.pendoc = i.pendoc
           and a.pepais = c.rppais
           and a.petdoc = c.rptdoc
           and a.pendoc = c.rpndoc
           and a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and b.aostat in (select tp1nro1
                              from fst198 f
                             where f.tp1cod = 1
                               and tp1cod1 = 10899
                               and tp1corr1 = 900
                               and tp1corr2 = 1) --kdvc 12102017 (21,22,23,25,64,90,33,34)
           and b.aomod in (select modulo
                             from fst111
                            where dscod = 50
                           union
                           select 65
                             from dual)
           and c.rpccyg = 66
           and rownum = 1;
      Exception
        when no_data_found then
          ln_exCYG := 0;
      end;
    
      if ln_exCYG = 1 then
        exit;
      end if;
    end loop;
  
    --aval
    begin
      select count(*)
        into ln_exAval
        from sng003 b, fsr008 a, fsd010 c
       where b.sng001inst = pn_ins
         and b.sng003pgc = a.pgcod
         and b.sng003cta = a.ctnro
            --and a.cttfir = 'T'
         and a.pgcod = c.pgcod
         and a.ctnro = c.aocta
         and c.aostat in (select tp1nro1
                            from fst198 f
                           where f.tp1cod = 1
                             and tp1cod1 = 10899
                             and tp1corr1 = 900
                             and tp1corr2 = 1) --kdvc 12102017 (21,22,23,25,64,90,33,34)
         and c.aomod in (select modulo
                           from fst111
                          where dscod = 50
                         union
                         select 65
                           from dual);
    Exception
      when no_data_found then
        ln_exAval := 0;
    end;
  
    if ln_exAval >= 1 or ln_existe = 1 or ln_exCYG = 1 then
      ln_exfin := 'S';
    end if;
  
  end Sp_JudiCast;

  Procedure Sp_Calificacion_RCC(pn_ctaP in number,
                                pn_emp  in number,
                                pn_mod  in number,
                                pn_suc  in number,
                                pn_mda  in number,
                                pn_pap  in number,
                                pn_cta  in number,
                                pn_ope  in number,
                                pn_sbo  in number,
                                pn_top  in number,
                                lc_resp out varchar2) is
  
    cursor clientes is
      select pepais, petdoc pn_tdo, pendoc pc_ndo
        from fsr008
       where ctnro = pn_ctaP;
  
    cursor conyugues(Ln_pepais in number,
                     ln_petdoc in number,
                     lc_pendoc in char) is
      select b.rptdoc, b.rpndoc
        from fsr002 b
       where b.pepais = Ln_pepais
         and b.petdoc = ln_petdoc
         and b.pendoc = lc_pendoc
         and b.rpccyg = 66;
  
    ld_fecrcc   date;
    ld_fecdes   date;
    ln_mes      number(10);
    ln_count    number(10);
    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);
  
    ln_calif  number(5, 2);
    ln_calif1 number(5, 2);
    ln_calif2 number(5, 2);
    ln_calif3 number(5, 2);
    ln_calif4 number(5, 2);
  
    ld_fecprodu date;
  
  begin
    begin
      ln_TipoDni := 21;
      ln_TipoRuc := 9;
      ln_TipoCex := 2;
      lc_resp    := 'N';
    
      --fecha de RCC de puesta en Produccion   
      begin
        select to_date(Tp1nro1, 'dd.mm.yyyy')
          into ld_fecprodu
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 6
           and a.tp1corr2 = 1;
      exception
        when no_data_found then
          ld_fecprodu := null;
      end;
      --fecha RCC     
      begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      end;
    
      --fecha de desembolso
      begin
        select a.aofval
          into ld_fecdes
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top
           and rownum = 1;
      Exception
        when no_data_found then
          ld_fecdes := null;
      end;
    
      --codigo sbd
    
      for i in clientes loop
        --meses entre desembolso y ultimo rcc
      
        if ld_fecdes < ld_fecprodu then
          ld_fecdes := ld_fecprodu;
        else
          ld_fecdes := add_months(ld_fecdes, -1);
        end if;
      
        ld_fecdes := Last_day(ld_fecdes);
        ln_mes    := months_between(ld_fecrcc, ld_fecdes);
      
        if ln_mes = 0 then
          ln_mes := 1;
        end if;
      
        ln_count := 1;
      
        while ln_count <= ln_mes loop
        
          if i.pn_tdo = ln_TipoDni or i.pn_tdo <> ln_TipoRuc then
            If i.pn_tdo = ln_TipoDni then
              lc_C_TDOCID := '1';
            End If;
            If i.pn_tdo = ln_tipocex then
              lc_C_TDOCID := '2';
            End If;
            If i.pn_tdo <> ln_tipodni And i.pn_tdo <> ln_tiporuc then
              lc_C_TDOCID := to_char(i.pn_tdo);
            End If;
          
            begin
              select n_calif0, n_calif1, n_calif2, n_calif3, n_calif4
                into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
                from CLDRCCI a
               Where C_TDOCID = lc_C_TDOCID
                 and C_DOCIDE = trim(i.pc_ndo)
                 and D_FECPRE = ld_fecdes
                 and rownum = 1
              /*and n_calif0 <> 0*/
              ;
            exception
              when no_data_found then
                ln_calif := null;
            end;
          
          End If;
        
          If i.pn_tdo = ln_tiporuc then
          
            begin
              select n_calif0, n_calif1, n_calif2, n_calif3, n_calif4
                into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
                from CLDRCCI a
               Where C_DOCTRI = trim(i.pc_ndo)
                 and D_FECPRE = ld_fecdes
                 and rownum = 1
              /*and n_calif0 <> 0*/
              ;
            exception
              when no_data_found then
                ln_calif := null;
            end;
          End If;
        
          if ln_calif + ln_calif1 + ln_calif2 + ln_calif3 + ln_calif4 > 0 then
            if ln_calif < 90 then
              lc_resp := 'S';
              exit;
            else
              lc_resp   := 'N';
              ld_fecdes := add_months(ld_fecdes, 1);
            end if;
          else
            lc_resp   := 'N';
            ld_fecdes := add_months(ld_fecdes, 1);
          end if;
          ln_count := ln_count + 1;
        end loop;
        if lc_resp = 'S' then
          exit;
        end if;
      end loop;
    
      if lc_resp <> 'S' then
        for i in clientes loop
          for j in conyugues(i.pepais, i.pn_tdo, i.pc_ndo) loop
            pq_cr_relcrediticia.sp_calificacion_rcc_cyg(j.rptdoc,
                                                        j.rpndoc,
                                                        pn_emp,
                                                        pn_mod,
                                                        pn_suc,
                                                        pn_mda,
                                                        pn_pap,
                                                        pn_cta,
                                                        pn_ope,
                                                        pn_sbo,
                                                        pn_top,
                                                        lc_resp);
            if lc_resp = 'S' then
              exit;
            end if;
          
          end loop;
          if lc_resp = 'S' then
            exit;
          end if;
        end loop;
      end if;
    end;
  end Sp_Calificacion_RCC;

  Procedure Sp_Calificacion_RCC_Cyg(pn_tdo  in number,
                                    pc_ndo  in char,
                                    pn_emp  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,
                                    lc_resp out varchar2) is
  
    ld_fecrcc   date;
    ld_fecdes   date;
    ln_mes      number(10);
    ln_count    number(10);
    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);
  
    ln_calif  number(5, 2);
    ln_calif1 number(5, 2);
    ln_calif2 number(5, 2);
    ln_calif3 number(5, 2);
    ln_calif4 number(5, 2);
  
    ld_fecprodu date;
  
  begin
    begin
      ln_TipoDni := 21;
      ln_TipoRuc := 9;
      ln_TipoCex := 2;
      lc_resp    := 'N';
    
      --fecha de RCC de puesta en Produccion   
      begin
        select to_date(Tp1nro1, 'dd.mm.yyyy')
          into ld_fecprodu
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 6
           and a.tp1corr2 = 1;
      exception
        when no_data_found then
          ld_fecprodu := null;
      end;
    
      --fecha RCC     
      begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      end;
    
      --fecha de desembolso
      begin
        select a.aofval
          into ld_fecdes
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top
           and rownum = 1;
      Exception
        when no_data_found then
          ld_fecdes := null;
      end;
    
      --codigo sbd
    
      --meses entre desembolso y ultimo rcc
      if ld_fecdes < ld_fecprodu then
        ld_fecdes := ld_fecprodu;
      else
        ld_fecdes := add_months(ld_fecdes, -1);
      end if;
    
      ld_fecdes := Last_day(ld_fecdes);
      ln_mes    := months_between(ld_fecrcc, ld_fecdes);
    
      if ln_mes = 0 then
        ln_mes := 1;
      end if;
    
      ln_count := 1;
    
      while ln_count <= ln_mes loop
      
        if pn_tdo = ln_TipoDni or pn_tdo <> ln_TipoRuc then
          If pn_tdo = ln_TipoDni then
            lc_C_TDOCID := '1';
          End If;
          If pn_tdo = ln_tipocex then
            lc_C_TDOCID := '2';
          End If;
          If pn_tdo <> ln_tipodni And pn_tdo <> ln_tiporuc then
            lc_C_TDOCID := to_char(pn_tdo);
          End If;
        
          begin
            select n_calif0, n_calif1, n_calif2, n_calif3, n_calif4
              into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
              from CLDRCCI a
             Where C_TDOCID = lc_C_TDOCID
               and C_DOCIDE = trim(pc_ndo)
               and D_FECPRE = ld_fecdes
               and rownum = 1
            /*and n_calif0 <> 0*/
            ;
          exception
            when no_data_found then
              ln_calif := null;
          end;
        
        End If;
      
        If pn_tdo = ln_tiporuc then
        
          begin
            select n_calif0, n_calif1, n_calif2, n_calif3, n_calif4
              into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
              from CLDRCCI a
             Where C_DOCTRI = trim(pc_ndo)
               and D_FECPRE = ld_fecdes
               and rownum = 1
            /*and n_calif0 <> 0*/
            ;
          exception
            when no_data_found then
              ln_calif := null;
          end;
        End If;
      
        if ln_calif + ln_calif1 + ln_calif2 + ln_calif3 + ln_calif4 > 0 then
          if ln_calif < 90 then
            lc_resp := 'S';
            exit;
          else
            lc_resp   := 'N';
            ld_fecdes := add_months(ld_fecdes, 1);
          end if;
        else
          lc_resp   := 'N';
          ld_fecdes := add_months(ld_fecdes, 1);
        end if;
        ln_count := ln_count + 1;
      end loop;
    
    end;
  end Sp_Calificacion_RCC_Cyg;

  Procedure Sp_Listas_Negras(pn_cta in number, lc_lista out varchar2) is
  
    cursor clientes is
      select pepais, petdoc, pendoc
        from fsr008
       where pgcod = 1
         and ctnro = pn_cta;
  
    cursor conyugues(ln_pepais in number,
                     ln_petdoc in number,
                     lc_pendoc in char) is
      select b.rppais, b.rptdoc, b.rpndoc
        from fsr002 b
       where b.pepais = ln_pepais
         and b.petdoc = ln_petdoc
         and b.pendoc = lc_pendoc
         and b.rpccyg = 66;
  
  begin
    lc_lista := 'N';
  
    for i in clientes loop
      begin
        select 'S'
          into lc_lista
          from fsd201 a
         where a.lnpais = i.pepais
           and a.lntdoc = i.petdoc
           and a.lnndoc = i.pendoc
           and a.tlis not in (select tp1nro1
                                from fst198 f
                               where f.tp1cod = 1
                                 and tp1cod1 = 10899
                                 and tp1corr1 = 900
                                 and tp1corr2 = 2) --(5,6) 14/11/2017 KDVC
           and rownum = 1;
      exception
        when no_data_found then
          lc_lista := 'N';
      end;
    
      if lc_lista = 'S' then
        exit;
      end if;
    end loop;
  
    if lc_lista <> 'S' then
      for i in clientes loop
        for j in conyugues(i.pepais, i.petdoc, i.pendoc) loop
          begin
            select 'S'
              into lc_lista
              from fsd201 a
             where a.lnpais = j.rppais
               and a.lntdoc = j.rptdoc
               and a.lnndoc = j.rpndoc
               and a.tlis not in (select tp1nro1
                                    from fst198 f
                                   where f.tp1cod = 1
                                     and tp1cod1 = 10899
                                     and tp1corr1 = 900
                                     and tp1corr2 = 2) --(5,6) 14/11/2017 KDVC
               and rownum = 1;
          exception
            when no_data_found then
              lc_lista := 'N';
          end;
        
          if lc_lista = 'S' then
            exit;
          end if;
        end loop;
        if lc_lista = 'S' then
          exit;
        end if;
      end loop;
    end if;
  
  end Sp_Listas_Negras;

  Procedure Sp_conteo_bloqueos(pn_pai  in number,
                               pn_tdo  in number,
                               pc_ndo  in char,
                               pn_cvar in number,
                               ln_cont out number) is
  
  begin
    begin
    
      select count(*)
        into ln_cont
        from jaqz090 a
       where a.jaqz090pai = pn_pai
         and a.jaqz090tdo = pn_tdo
         and a.jaqz090ndo = pc_ndo
         and a.jaqz090cva = pn_cvar;
    exception
      when no_data_found then
        ln_cont := 0;
    end;
  
  end Sp_conteo_bloqueos;

  Procedure Sp_bloqueo_vigente(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pd_fecpro in date,
                               Pn_cta    in number,
                               pn_ope    in number,
                               ln_vig    out number) is
    ld_fecmax date;
  begin
    begin
      select max(a.jaqz090fef)
        into ld_fecmax
        from jaqz090 a
       where a.jaqz090pai = pn_pai
         and a.jaqz090tdo = pn_tdo
         and a.jaqz090ndo = pc_ndo
         and a.jaqz090cta = Pn_cta
         and a.jaqz090ope = pn_ope;
    Exception
      when no_data_found then
        ld_fecmax := null;
    end;
  
    if ld_fecmax is not null then
      if pd_fecpro <= ld_fecmax then
      
        begin
          select max(a.jaqz090cmo)
            into ln_vig
            from jaqz090 a
           where a.jaqz090pai = pn_pai
             and a.jaqz090tdo = pn_tdo
             and a.jaqz090ndo = pc_ndo
                --and a.jaqz090fef = ld_fecmax
             and a.jaqz090cta = Pn_cta
             and a.jaqz090ope = pn_ope
          --and rownum = 1
          ;
        
        exception
          when no_data_found then
            ln_vig := 0;
          
        end;
      
      else
        ln_vig := 0;
      end if;
    
    else
      ln_vig := 0;
    
    end if;
  
  end Sp_bloqueo_vigente;

  Procedure Sp_diasAtrasoLineas_Central(pn_emp        in number,
                                        pn_mod        in number,
                                        pn_suc        in number,
                                        pn_mda        in number,
                                        pn_pap        in number,
                                        pn_cta        in number,
                                        pn_ope        in number,
                                        pn_sbo        in number,
                                        pn_top        in number,
                                        pd_fecpro     in date,
                                        ln_diaTot     out number,
                                        ln_contCuoTot out number) is
    cursor creditos is
      select *
        from fsr011 a, fsd010 b
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope;
  
    ln_contCuotas number(18);
    ln_dia        number(18);
    --ln_contCuoTot number(18);
    --ln_diaTot number(18);
  
    ld_feccan date;
  
  begin
    begin
    
      ln_contCuoTot := 0;
      ln_diaTot     := 0;
    
      for i in creditos loop
        if i.aostat = 99 then
          --               
          ld_feccan := i.aofe99;
        else
        
          ld_feccan := pd_fecpro;
        end if;
        pq_cr_relcrediticia.Sp_CalCuo_Lin_Central(i.pgcod,
                                                  i.aomod,
                                                  i.aosuc,
                                                  i.aomda,
                                                  i.aopap,
                                                  i.aocta,
                                                  i.aooper,
                                                  i.aosbop,
                                                  i.aotope,
                                                  ld_feccan,
                                                  i.aostat,
                                                  ln_contCuotas,
                                                  ln_dia);
        ln_diaTot     := ln_diaTot + ln_dia;
        ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
      end loop;
    
      /*
       if ln_contCuoTot = 0 then
         --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
         pn_diatr := 0;
         else
              pn_diatr := round((ln_diaTot/ln_contCuoTot),2);
      end if;*/
    
    end;
  
  end Sp_diasAtrasoLineas_Central;

  Procedure Sp_CalCuo_Lin_Central(pn_emp      in number,
                                  pn_mod      in number,
                                  pn_suc      in number,
                                  pn_mda      in number,
                                  pn_pap      in number,
                                  pn_cta      in number,
                                  pn_ope      in number,
                                  pn_sbo      in number,
                                  pn_top      in number,
                                  pd_fecpro   in date,
                                  pn_stat     in number,
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
         and a.ppfpag < pd_fecpro
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0;
  
    ln_dias    number(10);
    ln_flag    number(1);
    ld_fecantC date;
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
      ln_flag     := 0;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      For i in creditos loop
      
        if ld_fecantC <> i.ppfpag then
          ln_contador := ln_contador + 1;
        
          ln_dias    := pq_cr_relcrediticia.fn_cuotasPag(i.pgcod,
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
      end loop;
    
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
             and a.ppfpag >= pd_fecpro
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
  
  end Sp_CalCuo_Lin_Central;

  Procedure Sp_BloqueoMora(pn_pai    in number,
                           pn_tdo    in number,
                           pc_ndo    in char,
                           lc_existe out varchar2,
                           lc_flg    out varchar2) is
  
    ld_fecblo date;
    ln_cta    number(9);
    ln_ope    number(9);
    --lc_flg char(1);
  begin
  
    lc_flg    := 'N';
    lc_existe := 'N';
  
    begin
      select a.jaqz090fef, 'S', a.jaqz090cta, a.jaqz090ope
        into ld_fecblo, lc_flg, ln_cta, ln_ope
        from jaqz090 a
       where a.jaqz090pai = pn_pai
         and a.jaqz090tdo = pn_tdo
         and a.jaqz090ndo = pc_ndo
         and a.jaqz090cva = 1
         and a.jaqz090cva not in (2, 3, 4, 5)
         and a.jaqz090cmo <> 3
         and a.jaqz090fef = (select max(aa.jaqz090fef)
                               from jaqz090 aa
                              where aa.jaqz090pai = a.jaqz090pai
                                and aa.jaqz090tdo = a.jaqz090tdo
                                and aa.jaqz090ndo = a.jaqz090ndo
                                and aa.jaqz090cva = 1
                                and aa.jaqz090cva not in (2, 3, 4, 5)
                                and aa.jaqz090cmo <> 3)
         and rownum = 1;
    exception
      when no_data_found then
        ld_fecblo := null;
        lc_flg    := 'N';
        ln_cta    := null;
        ln_ope    := null;
    end;
  
    if lc_flg = 'S' then
      begin
        select 'S'
          into lc_existe
          from fsh016 a
         where a.pgcod = 1
           and a.hcmod = 116
           and a.htran in (50, 60)
           and a.hfcon > ld_fecblo
           and a.hcta = ln_cta
           and a.hoper = ln_ope
           and rownum = 1;
      exception
        when no_data_found then
          lc_existe := 'N';
      end;
    end if;
  
  end Sp_BloqueoMora;

  Procedure Sp_Segmento_Des(pn_ins in number,
                            pc_seg out varchar2,
                            pn_pai out number,
                            pn_tdo out number,
                            pc_ndo out varchar2,
                            pd_fec out date) is
  
  begin
    begin
      select n.pae70pdoc, n.pae70tdoc, n.pae70ndoc, n.pae70time, v.pae71val
        into pn_pai, pn_tdo, pc_ndo, pd_fec, pc_seg
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 265
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 1
         and n.pae70nro =
             (select max(pae70nro) from fpae70 where pae70ins = pn_ins);
    exception
      when no_data_found then
        pn_pai := null;
        pn_tdo := null;
        pc_ndo := null;
        pd_fec := null;
    end;
  
  end Sp_Segmento_Des;

  Procedure Sp_carga_data_MENSUAL(pd_fecpro in date) is
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
        ln_vig := 60; --cambiar en produccion
    
    end;
  
    ld_fecini := add_months(pd_fecpro, -ln_vig);
    execute immediate ('truncate table jaqz074_aux');
    execute immediate ('truncate table jaqz074_aux_ii');
    begin
    
      insert into jaqz074_aux
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
         flag,
         hipo)
        select a.pgcod,
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
               pq_cr_relcrediticia.Fn_DiaPago(PGCOD,
                                              AOMOD,
                                              AOSUC,
                                              AOMDA,
                                              AOPAP,
                                              AOCTA,
                                              AOOPER,
                                              AOSBOP,
                                              AOTOPE,
                                              aostat,
                                              a.aofe99),
               --a.aofe99,
               a.aostat,
               (case
                 when aofe99 = to_date('0001.01.01', 'yyyy.mm.dd') and
                      aostat = 99 and aofval < ld_fecini then
                  'N'
                 else
                  'S'
               end),
               Case
                 when aomod = 110 and
                      aotope not in (select a.tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 5000
                                        and a.tp1corr2 = 1) then
                  'N'
                 else
                  'S'
               end
          from fsd010 a
         where (aomod in
               (select modulo
                   from fst111
                  where dscod = 50
                    and modulo not in (200, 33, 108, 106, 107)))
           and (aofe99 >= ld_fecini or
               aofe99 = to_date('0001.01.01', 'yyyy.mm.dd'))
           and aotope <> 550;
      commit;
    
    end;
  
    begin
    
      insert into jaqz074_aux_ii
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
      
        select a.pgcod,
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
               a.aofe99,
               a.aostat,
               b.pepais,
               b.petdoc,
               b.pendoc
          from jaqz074_aux a, fsr008 b
         where b.ctnro = a.aocta
           and b.cttfir = 'T'
           AND A.FLAG = 'S'
           and hipo = 'S';
      commit;
    
    end;
  
    commit;
  
    Pq_Cr_Relcrediticia.Sp_cr_Inserta_MENSUAL(pd_fecpro, ld_fecini);
  end Sp_carga_data_MENSUAL;

  Procedure Sp_cr_Inserta_MENSUAL(pd_fecpro in date, pd_fecini in date) is
  
    cursor creditos is
      select * from JAQZ074_AUX_II a;
    ln_contador number(5);
    ln_ins      number(1);
    ln_anio     number(4);
    ln_mes      number(2);
    ln_inserta  char(1);
    ld_feccan   date;
    ln_estado   number(2);
    ln_emp      number(3);
    ln_mod      number(3);
    ln_suc      number(3);
    ln_mda      number(4);
    ln_pap      number(4);
    ln_cta      number(9);
    ln_ope      number(9);
    ln_sbo      number(3);
    ln_top      number(3);
  
    ld_fecini date;
  
    ld_fec date;
    LN_AUX NUMBER(9);
  
    ld_fecguia date;
    ln_histAnt number(5);
    ln_estAnt  number(2);
    ln_empAnt  number(3);
    ln_modAnt  number(3);
    ln_sucAnt  number(3);
    ln_mdaAnt  number(4);
    ln_papAnt  number(4);
    ln_ctaAnt  number(9);
    ln_opeAnt  number(9);
    ln_sboAnt  number(3);
    ln_topAnt  number(3);
    ld_fecAnt  date;
  
    ln_estPro  number(2);
    ln_empPro  number(3);
    ln_modPro  number(3);
    ln_sucPro  number(3);
    ln_mdaPro  number(4);
    ln_papPro  number(4);
    ln_ctaPro  number(9);
    ln_opePro  number(9);
    ln_sboPro  number(3);
    ln_topPro  number(3);
    ld_fecPro  date;
    ln_contPro number(5);
  
    ld_fectmp date;
    ld_fecvac date;
  
  begin
  
    Begin
    
      ln_anio := to_number(to_char(pd_fecpro, 'yyyy'));
      ln_mes  := to_number(to_char(pd_fecpro, 'mm'));
    
      ld_fecini := to_date(to_char(pd_fecini, 'yyyymm') || '01', 'yyyymmdd');
    
      ld_fectmp := to_date(to_char(add_months(pd_fecpro, -12), 'yyyymm') || '01',
                           'yyyymmdd');
      ld_fecvac := to_date('0001.01.01', 'yyyy.mm.dd');
    
      begin
        select to_date(a.tp1nro1, 'ddmmyyyy')
          into ld_fecguia
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10823
           and a.tp1corr1 = 8
           and a.tp1corr2 = 1;
      exception
        when no_data_found then
          ld_fecguia := null;
      end;
    
      for i in creditos loop
        ln_contador := null;
        ln_inserta  := NULL;
        ln_estado   := null;
        ln_emp      := null;
        ln_mod      := null;
        ln_suc      := null;
        ln_mda      := null;
        ln_pap      := null;
        ln_cta      := null;
        ln_ope      := null;
        ln_sbo      := null;
        ln_top      := null;
        ld_feC      := null;
        ln_ins      := PQ_CR_RELCREDITICIA.fn_inserta(i.pepais,
                                                      i.petdoc,
                                                      i.pendoc,
                                                      ln_anio,
                                                      ln_mes);
      
        begin
          select a.jaqz074his,
                 a.jaqz074est,
                 a.jaqz074pgc,
                 a.jaqz074mod,
                 a.jaqz074suc,
                 a.jaqz074mda,
                 a.jaqz074pap,
                 a.jaqz074cta,
                 a.jaqz074ope,
                 a.jaqz074sbo,
                 a.jaqz074top,
                 a.jaqz074fec
            into ln_histAnt,
                 ln_estAnt,
                 ln_empAnt,
                 ln_modAnt,
                 ln_sucAnt,
                 ln_mdaAnt,
                 ln_papAnt,
                 ln_ctaAnt,
                 ln_opeAnt,
                 ln_sboAnt,
                 ln_topAnt,
                 ld_fecAnt
            from jaqz074 a
           where a.jaqz074pai = i.pepais
             and a.jaqz074tdo = i.petdoc
             and a.jaqz074ndo = i.pendoc
             and a.jaqz074fep = ld_fecguia;
        
        exception
          when no_data_found then
            ln_histAnt := null;
            ln_estAnt  := null;
        end;
      
        if ln_ins = 0 then
          --pq_cr_relcrediticia.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
          --                                     ld_feccan);
          --if ln_inserta = 'S' then
          PQ_CR_RELCREDITICIA.Sp_cr_historial(i.pepais,
                                              i.petdoc,
                                              i.pendoc,
                                              ld_fecini,
                                              pd_fecpro,
                                              ln_contPro,
                                              ln_estPro,
                                              ln_empPro,
                                              ln_modPro,
                                              ln_sucPro,
                                              ln_mdaPro,
                                              ln_papPro,
                                              ln_ctaPro,
                                              ln_opePro,
                                              ln_sboPro,
                                              ln_topPro,
                                              ld_fecPro);
          if ln_estAnt is not null then
            --mod 2016.03.30                              
            if ln_estAnt <> 99 or ln_estPro <> 99 then
              ln_contador := ln_histAnt + 1;
              ln_estado   := ln_estPro;
              ln_emp      := ln_empPro;
              ln_mod      := ln_modPro;
              ln_suc      := ln_sucPro;
              ln_mda      := ln_mdaPro;
              ln_pap      := ln_papPro;
              ln_cta      := ln_ctaPro;
              ln_ope      := ln_opePro;
              ln_sbo      := ln_sboPro;
              ln_top      := ln_topPro;
              ld_feC      := ld_fecPro;
            
            end if;
          end if;
        
          if ln_estAnt is null then
            ln_contador := ln_contPro;
            ln_estado   := ln_estPro;
            ln_emp      := ln_empPro;
            ln_mod      := ln_modPro;
            ln_suc      := ln_sucPro;
            ln_mda      := ln_mdaPro;
            ln_pap      := ln_papPro;
            ln_cta      := ln_ctaPro;
            ln_ope      := ln_opePro;
            ln_sbo      := ln_sboPro;
            ln_top      := ln_topPro;
            ld_feC      := ld_fecPro;
          
          end if;
        
          if ln_estAnt = 99 and ln_estPro = 99 then
            --mod 2016.03.30
            if ld_fecvac = ld_fecAnt or ld_fecAnt >= ld_fectmp then
              ln_contador := ln_histAnt;
              ln_estado   := ln_estPro;
              ln_emp      := ln_empPro;
              ln_mod      := ln_modPro;
              ln_suc      := ln_sucPro;
              ln_mda      := ln_mdaPro;
              ln_pap      := ln_papPro;
              ln_cta      := ln_ctaPro;
              ln_ope      := ln_opePro;
              ln_sbo      := ln_sboPro;
              ln_top      := ln_topPro;
              ld_feC      := ld_fecPro;
            
            else
              ln_contador := ln_contPro;
              ln_estado   := ln_estPro;
              ln_emp      := ln_empPro;
              ln_mod      := ln_modPro;
              ln_suc      := ln_sucPro;
              ln_mda      := ln_mdaPro;
              ln_pap      := ln_papPro;
              ln_cta      := ln_ctaPro;
              ln_ope      := ln_opePro;
              ln_sbo      := ln_sboPro;
              ln_top      := ln_topPro;
              ld_feC      := ld_fecPro;
            
            end if;
          end if;
        
          insert into jaqz074
            (JAQZ074PAI,
             JAQZ074TDO,
             JAQZ074NDO,
             JAQZ074ANI,
             JAQZ074MES,
             JAQZ074FEP,
             jaqz074his,
             JAQZ074FCN,
             jaqz074est,
             jaqz074pgc,
             jaqz074mod,
             jaqz074suc,
             jaqz074mda,
             jaqz074pap,
             jaqz074cta,
             jaqz074ope,
             jaqz074sbo,
             jaqz074top,
             jaqz074FEC)
          
          values
            (i.pepais,
             i.petdoc,
             i.pendoc,
             ln_anio,
             ln_mes,
             pd_fecpro,
             ln_contador,
             ld_feccan,
             ln_estado,
             ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ld_fec);
        
          commit;
        
          --end if;
        
        end if;
        commit;
      
      end loop;
    
      commit;
    
      LN_AUX := to_number(to_char(pd_fecpro, 'ddmmyyyy'));
      UPDATE FST198
         set tp1nro1 = LN_AUX
       where tp1cod = 1 --modabr 20210702
         and tp1cod1 = 10823
         and tp1corr1 = 8
         and tp1corr2 = 1;
      commit;
    end;
  
  end Sp_cr_Inserta_MENSUAL;

  /*
  Procedure Sp_HistNR_PYME_INI(pd_Fecpro in date) is
  
  cursor persona is
  select pepais, 
         petdoc, 
         pendoc  
    from JAQZ514_aux;
    
  ln_contador number(10);
  lc_tipHN char(1);
  ln_ins number(1);
  LN_AUX NUMBER(9);
  begin
            execute immediate('truncate table JAQZ514_aux');
            execute immediate('truncate table JAQZ514_aux_II');
            
            begin
                insert into JAQZ514_AUX_II
                
                select a.pgcod,
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
                       pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                                          AOSBOP,AOTOPE,aostat,aofe99)aofe99,
                       a.aostat,
                       Case 
                          when aomod = 110 and aotope not in (select tp1nro1
                                                                from fst198
                                                               where tp1cod = 1
                                                                 and tp1cod1 = 10899
                                                                 and tp1corr1 = 25
                                                                 and tp1corr2= 3) then 'N'
                          else 'S'
                       end
                  from fsd010 a
                 where aomod in (select modulo 
                                   from fst111 
                                  where dscod = 50 
                                    and modulo not in (select v.tp1nro1
                                                         from fst198 v 
                                                        where tp1cod1  = 10899
                                                          and tp1corr1 = 25
                                                          and tp1corr2 = 1))
                   --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                   and aotope <> 550
                   and a.pgcod = 1;   
                commit;
            end;
            
            begin
                insert into JAQZ514_AUX
                
                select a.pgcod,
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
                       aofe99,
                       a.aostat,
                       PEPAIS,
                       PETDOC,
                       PENDOC
                  from JAQZ514_AUX_II a, fsr008 b
                 where a.pgcod = b.pgcod
                   and a.aocta = b.ctnro
                   and HIPO = 'S';
    
                commit;
            end;
            
            begin
              for i in persona loop
                ln_ins := pq_cr_relcrediticia.fn_inserta_pymeNR(i.pepais,i.petdoc,i.pendoc,pd_fecpro); 
                          
               if ln_ins = 0 then
                begin
                  
                  ln_contador := pq_cr_relcrediticia.Fn_RelCredi_NR(i.pepais,i.petdoc,i.pendoc,pd_fecpro);
                  
                  if ln_contador > 18 then
                      lc_tipHN := 'X';
                      else
                           lc_tipHN := 'Z';
                           
                   end if;   
                  insert into jaqz514
                  values(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_contador,lc_tipHN);
                  commit;
                end;
              end if;
                
              end loop;
              
            end;
            
            LN_AUX :=to_number(to_char(pd_fecpro,'ddmmyyyy'));
            UPDATE FST198 set tp1nro1 = LN_AUX
            where tp1cod1 = 10899
              and tp1corr1 = 25
              and tp1corr2 = 2
              and tp1corr3 = 1;
              commit;
     
            
  end Sp_HistNR_PYME_INI;
  */
  /*
  Function Fn_RelCredi_NR(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date)
                          return number  is
  
  cursor creditos is
  select * from jaqz514_aux
  where pepais = pn_pai
     and petdoc = pn_tdo
     and pendoc = pc_ndo
     order by aofval;
     
  
                      
  ld_fecantD date;
  ld_fecantC date;
  
  ln_mesac number(2);
  ln_aniac number(4);
  ln_mesan number(2);
  ln_anian number(4);
  ln_suma number(5);
  
  ld_aofval date;
  ld_aofe99 date;
  ld_sysdate DATE;
  
  ln_sw number(1);
  
  ln_contador number(10);
  begin
  
  
      begin
      ln_contador := 0;  
      ld_fecantD := null;
      ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
      ld_sysdate := last_day(pd_fecpro );
      For i in creditos loop
      
      ln_sw := 0;
        if (i.aofe99 is null or i.aofe99 = to_date('0001.01.01','yyyy.mm.dd'))and i.aostat = 99 then
           ln_sw := 1;
           
        end if;
        if ln_sw = 0 then
        
          ln_mesac := to_number(to_char(i.aofval,'mm'));
          ln_aniac := to_number(to_char(i.aofval,'yyyy'));
          ln_suma := null;
          ld_aofval := i.aofval;
          ld_aofe99 := last_day(i.aofe99);
          
          
          if ld_fecantD is null then
                if i.aostat = 99 then
                   ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                   if ln_suma <0 then 
                      ln_suma := 0;
                   end if;
                   ln_contador := ln_contador + ln_suma;
                   else 
                       ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                       if ln_suma <0 then 
                          ln_suma := 0;
                       end if;
                       ln_contador := ln_contador + ln_suma;
                   
                end if;
                
                Else
                     
                    if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                       if i.aostat = 99 then
                            ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                             if ln_suma <0 then 
                                ln_suma := 0;
                             end if;       
                            ln_contador := ln_contador + ln_suma;
                            
                            else
                              ln_suma := trunc(months_between(ld_sysdate,
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
                               if i.aostat = 99 then
                                    ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;  
                                  
                                    ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                    
                                    else
                                      ln_suma := trunc(months_between(ld_sysdate,ld_aofval));
                                       if ln_suma <0 then 
                                          ln_suma := 0;
                                       end if;        
                                      
                                      ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                end if;
                                    
                            
                            
                            end if;
                            
                            if ld_aofval > ld_fecantC then
                               
                               if i.aostat = 99 then
                                    ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;  
                                    ln_contador := ln_contador + ln_suma;
                                    
                                    else
                                      ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                                       if ln_suma <0 then 
                                          ln_suma := 0;
                                       end if;  
                                      ln_contador := ln_contador + ln_suma;
                                end if;
                                    
                            
                            
                            end if;
                        
                    
                    end if;
                
          end if;
          
          if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
             if ld_fecantC > i.aofval then
                ld_aofval := ld_fecantC;
             end if;
             ld_fecantC := pd_Fecpro;--trunc(sysdate);
          end if;
          
          if i.aofe99 > ld_fecantC then
                      --ld_fecantD := ld_aofval;
                       ld_fecantC := i.aofe99;
          
          end if;
          ld_fecantD := ld_aofval;
          
          
          
          
          ln_mesan := to_number(to_char(ld_fecantC,'mm'));
          ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
        end if;
      end loop;
  
      END;
      return ln_contador;
     
  end Fn_RelCredi_NR;   
  */
  /*
  Procedure Sp_Hist_NR_MENS(pd_Fecpro in date) is
  
  cursor persona is
  select pepais, 
         petdoc, 
         pendoc  
    from jaqz514_aux;
  ln_contador number(10);
  lc_tipHN char(1);
  ld_fecant date;
  lc_hisAnt char(1);
  ln_ins number(1);
  LN_AUX NUMBER(9);
  begin
            execute immediate('truncate table jaqz514_aux');
            ld_fecant := add_months(pd_Fecpro,-1);
            execute immediate('truncate table jaqz514_aux_II');
            
            begin
                insert into jaqz514_AUX_II
                
                select a.pgcod,
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
                       pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                                          AOSBOP,AOTOPE,aostat,aofe99)aofe99,
                       a.aostat,
                       Case 
                          when aomod = 110 and aotope not in (select tp1nro1
                                                                from fst198
                                                               where tp1cod = 1
                                                                 and tp1cod1 = 10899
                                                                 and tp1corr1 = 25
                                                                 and tp1corr2= 3) then 'N'
                          else 'S'
                       end
                  from fsd010 a
                 where aomod in (select modulo 
                                   from fst111 
                                  where dscod = 50 
                                    and modulo not in (select v.tp1nro1
                                                         from fst198 v 
                                                        where tp1cod1  = 10899
                                                          and tp1corr1 = 25
                                                          and tp1corr2 = 1))
                   --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                   and aotope <> 550
                   and a.pgcod = 1;   
                commit;
            end;
            
            begin
                insert into jaqz514_AUX
                
                select a.pgcod,
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
                       aofe99,
                       a.aostat,
                       PEPAIS,
                       PETDOC,
                       PENDOC
                  from jaqz514_AUX_II a, fsr008 b
                 where a.pgcod = b.pgcod
                   and a.aocta = b.ctnro
                   and HIPO = 'S';
    
                commit;
            end;
            
            begin
              for i in persona loop
               ln_ins := pq_cr_relcrediticia.fn_inserta_pymeNR(i.pepais,i.petdoc,i.pendoc,pd_fecpro); 
                          
               if ln_ins = 0 then
                begin
                  select a.JAQZ514his
                    into lc_hisAnt
                    from jaqz514 a
                   where a.JAQZ514pai = i.pepais
                     and a.JAQZ514tdo = i.petdoc
                     and a.JAQZ514ndo = i.pendoc 
                     and a.JAQZ514fec = ld_fecant;
                Exception
                when no_data_found then
                     lc_hisAnt := null;
                end;
              
                if lc_hisAnt = 'X' then
                  lc_tipHN := 'X';
                  else
                    
                      ln_contador := pq_cr_relcrediticia.Fn_RelCredi_NR(i.pepais,i.petdoc,i.pendoc,pd_fecpro);
                        
                      if ln_contador > 18 then
                          lc_tipHN := 'X';
                          else
                               lc_tipHN := 'Z';
                               
                       end if;   
                end if;
                
                begin
                  insert into jaqz514
                  values(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_contador,lc_tipHN);
                  commit;
                end;
              end if;  
              end loop;
              
            end;
     
            LN_AUX :=to_number(to_char(pd_fecpro,'ddmmyyyy'));
            UPDATE FST198 set tp1nro1 = LN_AUX
            where tp1cod1 = 10899
              and tp1corr1 = 25
              and tp1corr2 = 2
              and tp1corr3 = 1;
              commit;
            
  end Sp_Hist_NR_MENS;  
  */
  /*
  Function fn_inserta_pymeNR(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fec in date)
                         return number is
  ln_existe number(1);
  
  begin
      
           begin
                select 1
                  into ln_existe
                  from JAQZ514 a
                 where a.JAQZ514pai = pn_pai
                   and a.JAQZ514tdo = pn_tdo
                   and a.JAQZ514ndo = pc_ndo
                   and a.JAQZ514fec = pd_fec;
                   
           exception
                   when others then 
                        ln_existe := 0;
           end;
  
           if ln_existe is null then
              ln_existe := 0;
           end if;
           return ln_existe;
  end fn_inserta_pymeNR;
  */
  Procedure Sp_Obtiene_HistPyme(pn_pai in number,
                                pn_tdo in number,
                                pc_ndo in char,
                                pc_his out varchar2) is
    ld_fec    date;
    pd_fecpro date;
    ln_cont   number(5);
  begin
    --Obtiene ultima fecha de carga
    /*begin
      select to_date(a.tp1nro1,'ddmmyyyy')
        into ld_fec
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 25
         and a.tp1corr2 = 2
         and a.tp1corr3 = 1;
    exception 
      when others then null;     
    end;
    
    begin
      select a.jaqz514his
        into pc_his
        from jaqz514 a
       where a.jaqz514pai = pn_pai
         and a.jaqz514tdo = pn_tdo
         and a.jaqz514ndo = pc_ndo
         and a.jaqz514fec = ld_fec;
    exception
      when others then 
           null;
    end;*/
    --Obtiene fecha bantotal
    begin
      select pgfape into pd_fecpro from fst017 a where a.pgcod = 1;
    end;
    Pq_cr_relcrediticia.Sp_RelCrediNR_PYME(pn_pai,
                                           pn_tdo,
                                           pc_ndo,
                                           pd_fecpro,
                                           ln_cont);
  
    if ln_cont < 18 then
      pc_his := 'Z';
    else
      pc_his := 'X';
    
    end if;
  
  end Sp_Obtiene_HistPyme;

  Procedure Sp_RelCrediNR_PYME(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_Fecpro   in date,
                               ln_contador out number) is
  
    cursor creditos is
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
             hipo
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
                     pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,
                                                    AOMOD,
                                                    AOSUC,
                                                    AOMDA,
                                                    AOPAP,
                                                    AOCTA,
                                                    AOOPER,
                                                    AOSBOP,
                                                    AOTOPE,
                                                    aostat,
                                                    aofe99) aofe99,
                     a.aostat,
                     Case
                       when aomod = 110 and
                            aotope not in (select tp1nro1
                                             from fst198
                                            where tp1cod = 1
                                              and tp1cod1 = 10899
                                              and tp1corr1 = 25
                                              and tp1corr2 = 3) then
                        'N'
                       else
                        'S'
                     end hipo
                from fsd010 a, fsr008 b
               where aomod in (select modulo
                                 from fst111
                                where dscod = 50
                                  and modulo not in
                                      (select v.tp1nro1
                                         from fst198 v
                                        where tp1cod = 1 --modabr 20210702
                                          and tp1cod1 = 10899
                                          and tp1corr1 = 25
                                          and tp1corr2 = 1))
                 and aotope <> 550
                 and a.pgcod = 1
                 and a.pgcod = b.pgcod
                 and a.aocta = b.ctnro
                 and b.pepais = pn_pai
                 and b.petdoc = pn_tdo
                 and b.pendoc = pc_ndo
               order by aofval)
       where hipo = 'S';
  
    ld_fecantD date;
    ld_fecantC date;
  
    ln_mesac number(2);
    ln_aniac number(4);
    ln_mesan number(2);
    ln_anian number(4);
    ln_suma  number(5);
  
    ld_aofval  date;
    ld_aofe99  date;
    ld_sysdate DATE;
  
    ln_sw number(1);
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      ld_sysdate  := last_day(pd_fecpro);
      For i in creditos loop
      
        ln_sw := 0;
        if (i.aofe99 is null or
           i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
           i.aostat = 99 then
          ln_sw := 1;
        
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.aofval, 'mm'));
          ln_aniac  := to_number(to_char(i.aofval, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.aofval;
          ld_aofe99 := last_day(i.aofe99);
        
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
                
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                
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
            ld_fecantC := pd_Fecpro; --trunc(sysdate);
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
    
    END;
  
  end Sp_RelCrediNR_PYME;
end PQ_CR_RELCREDITICIA;
/

