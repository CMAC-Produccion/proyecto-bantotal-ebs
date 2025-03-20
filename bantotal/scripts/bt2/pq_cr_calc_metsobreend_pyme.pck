create or replace package PQ_CR_CALC_METSOBREEND_PYME is

  /* ************************************************************************************************************
      -- Nombre                     : Ratio Endeudamiento Patrimonio Resolutor Politica Saldo Pyme
      -- Sistema                    : BANTOTAL
      -- Versión                    : 1.0
      -- Fecha de Creación          : 07/02/2020
      -- Autor de Creación          : Juan Fernando Rodríguez Mamani
      -- Versión                    : 
      -- Fecha de Modificación      : 
      -- Autor de la Modificación   : 
      -- Descripción de Modificación: Se creo un nuevo procedimiento sp_cuentasPasivoII
      --                              que extrae los pasivos corriente y no corriente solo de creditos vigentes
      --
  * *************************************************************************************************************/

  procedure SP_INICIO(pn_instancia numeric, pn_evaluacion numeric);

  
  procedure SP_RCC(pn_instancia numeric,
                   pv_codsbs    varchar2,
                   pn_tdoc      numeric,
                   pc_ndoc      character,
                   pd_FchRCC    date,
                   pd_dateEjec  date,
                   pc_horaEjec  character);
  
  
  procedure SP_PANELSD(pn_instancia numeric,
                       pv_codsbs    varchar2,
                       pn_tdoc      numeric,
                       pc_ndoc      character,
                       pn_segmento  number,
                       pd_fecrcc    date,
                       pd_dateEjec  date,
                       pc_horaEjec  character);
                        
  
  procedure SP_OBTENER_LINEAS(pn_instancia numeric,
                              pv_codsbs    varchar2,
                              pd_fec       date,
                              pd_dateEjec  date,
                              pc_horaEjec  character);
  
  procedure SP_OBTENER_SALDO_LINEAS(pv_codsbs    varchar2,
                                    pd_fec       date,
                                    pn_instancia numeric,
                                    pc_codent    varchar2,
                                    pc_codentant in out varchar2,
                                    pc_cuenta    varchar2,
                                    pn_saldo     numeric,
                                    pn_saldo14   in out numeric,
                                    pn_saldo72   in out numeric,
                                    pn_saldo81   in out numeric,
                                    pn_saldoD14  in out numeric,
                                    pn_saldoD72  in out numeric,
                                    pn_saldoD81  in out numeric,
                                    pn_moneda    in numeric,
                                    pn_monedaAnt in out numeric,
                                    pn_tipcre    in numeric,
                                    pn_tipcreANT in out numeric,
                                    pd_dateEjec  date,
                                    pc_horaEjec  character,
                                    pn_tipo      in numeric, --chernandez 17/02/2020
                                    pn_cuenta14  in out varchar2,
                                    pn_cuenta72  in out varchar2,
                                    pn_cuenta81  in out varchar2);
 
  procedure SP_OBTENER_SALDO_LINEAS_ULTEJ(pv_codsbs    varchar2,
                                          pd_fec       date,
                                          pn_instancia numeric,
                                          pc_codentant in out varchar2,
                                          pn_saldo14   in out numeric,
                                          pn_saldo72   in out numeric,
                                          pn_saldo81   in out numeric,
                                          pn_saldoD14  in out numeric,
                                          pn_saldoD72  in out numeric,
                                          pn_saldoD81  in out numeric,
                                          pn_tipcreANT in numeric,
                                          pd_dateEjec  date,
                                          pc_horaEjec  character,
                                          pn_tipo      in numeric, --chernandez 17/02/2020
                                          pn_cuenta14  in out varchar2,
                                          pn_cuenta72  in out varchar2);
  
  procedure SP_CR_SEGMNTOACTUAL(ln_Instancia     number,
                                ln_SegmntoActual out number);

  function FN_EQUIVALENCIADOC(p_tdoc number) return varchar2;

  procedure SP_EXISTEPANEL(pn_instancia number,
                           pn_segmento  number,
                           pb_flag      out number,
                           pd_fecprc    out date);

  procedure SP_BACKUP_AQPA024(pn_instancia number,
                              PD_FECHAEJE  DATE,
                              PC_HORA      CHARACTER);
  procedure SP_DEUINGRE(pn_instancia numeric, pn_evaluacion numeric);
  
end PQ_CR_CALC_METSOBREEND_PYME;
/

create or replace package body PQ_CR_CALC_METSOBREEND_PYME is

  /* ************************************************************************************************************
      -- Nombre                     : Ratio Endeudamiento Patrimonio Resolutor Politica Saldo Pyme
      -- Sistema                    : BANTOTAL
      -- Versión                    : 1.0
      -- Fecha de Creación          : 07/02/2020
      -- Autor de Creación          : Juan Fernando Rodríguez Mamani
      -- Versión                    : 
      -- Fecha de Modificación      : 
      -- Autor de la Modificación   : 
      -- Descripción de Modificación: Se creo un nuevo procedimiento sp_cuentasPasivoII
      --                              que extrae los pasivos corriente y no corriente solo de creditos vigentes
      --Modificacion rmontes 2021.03.08 se agrego rubro 0303 lineas 350.352.354.357.378.379.381.382.562.564.566.569.593.594.596.597.693.695.697.700.724.725.727.728
  * *************************************************************************************************************/

  procedure SP_INICIO(pn_instancia numeric, pn_evaluacion numeric) is
  
    cursor CrCldrcci(numdoc varchar2, tipdoc varchar2) is
      select c_codsbs
        from (select c_codsbs
                from cldrcci
               where ((c_tdocid = tipdoc and c_docide = numdoc and
                     c_person = '1') or
                     (c_tdocid = tipdoc and c_docide = numdoc and
                     c_person = '1') or
                     (c_tdoctr = tipdoc and c_doctri = numdoc and
                     c_person = '2'))
               order by d_fecpre desc)
       where rownum = 1;
  
    cursor documentos(pn_flag number) is
      select distinct f.PEPAIS, f.PETDOC, (trim(f.pendoc)) ln_doc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = pn_instancia)
      union
      select distinct g.rppais, g.rptdoc, (trim(g.rpndoc)) ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = pn_instancia)
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and 1 = pn_flag
      union
      select distinct g.pepais, g.petdoc, (trim(g.pendoc)) ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = pn_instancia)
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and 1 = pn_flag;
  
    cursor factores(pln_SegmntoActual numeric) is ----aqpb084ta
      select aqpb084ainst,
             aqpb084agrup,
             sum(aqpb084asald),
             case
               when aqpb084agrup = 1 then
                0.044
               when aqpb084agrup = 2 then
                0.09
               when aqpb084agrup = 3 and sum(aqpb084asald) <= 30000 then
                0.0264
               when aqpb084agrup = 3 and sum(aqpb084asald) > 30000 then
                0.0222
               when aqpb084agrup = 4 and sum(aqpb084asald) <= 8000 then
                0.0514
               when aqpb084agrup = 4 and sum(aqpb084asald) <= 15000 then
                0.0356
               when aqpb084agrup = 4 and sum(aqpb084asald) <= 45000 then
                0.0282
               when aqpb084agrup = 4 and sum(aqpb084asald) > 45000 then
                0.0222
               when aqpb084agrup = 5 and sum(aqpb084asald) <= 10000 then
                0.0349
               when aqpb084agrup = 5 and sum(aqpb084asald) <= 20000 then
                0.0248
               when aqpb084agrup = 5 and sum(aqpb084asald) <= 30000 then
                0.0224
               when aqpb084agrup = 5 and sum(aqpb084asald) > 30000 then
                0.0205
               when aqpb084agrup = 6 then
                0.009
               when aqpb084agrup = 7 and sum(aqpb084asald) <= 8000 then
                0.0514
               when aqpb084agrup = 7 and sum(aqpb084asald) <= 15000 then
                0.0356
               when aqpb084agrup = 7 and sum(aqpb084asald) <= 45000 then
                0.0282
               when aqpb084agrup = 7 and sum(aqpb084asald) > 45000 then
                0.0222
             --when aqpb084agrup = 8 and pln_SegmntoActual = 1 then 0.044*0.02
             --when aqpb084agrup = 8 and pln_SegmntoActual = 2 then 0.044*0.03
               when aqpb084agrup = 9 then
                0.0017 --17/02/2020 chernandez
               when aqpb084agrup = 10 then
                0
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 8000 then
                0.0514
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 15000 then
                0.0356
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 45000 then
                0.0282
               when aqpb084agrup = 11 and sum(aqpb084asald) > 45000 then
                0.0222
               when aqpb084agrup = 12 and sum(aqpb084asald) <= 8000 then
                0.0514
               when aqpb084agrup = 12 and sum(aqpb084asald) <= 15000 then
                0.0356
               when aqpb084agrup = 12 and sum(aqpb084asald) <= 45000 then
                0.0282
               when aqpb084agrup = 12 and sum(aqpb084asald) > 45000 then
                0.0222
               when aqpb084agrup = 13 and sum(aqpb084asald) <= 8000 then
                0.0514
               when aqpb084agrup = 13 and sum(aqpb084asald) <= 15000 then
                0.0356
               when aqpb084agrup = 13 and sum(aqpb084asald) <= 45000 then
                0.0282
               when aqpb084agrup = 13 and sum(aqpb084asald) > 45000 then
                0.0222
             end factor
        from aqpb084a
       where aqpb084ainst = pn_instancia
         and aqpb084agrup <> 8
       group by aqpb084ainst, aqpb084agrup
       order by aqpb084agrup;
  
    cursor factores2(pln_SegmntoActual numeric) is   ---aqpb084b
    --chernandez 17/02/2020 cambio de factores
      select case
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.04
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.23
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.25
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 > 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.32
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.04
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.25
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.29
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 > 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.34
             end factor
      
        from aqpb084b
       where aqpb084binst = pn_instancia
         and aqpb084btipo = 1
       group by aqpb084binst;
    --chernandez 17/02/2020
    cursor factores3(pln_SegmntoActual numeric) is   ---aqpb084b
      select case
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 45 then
                0.09 * 0.03
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 65 then
                0.09 * 0.07
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 <= 85 then
                0.09 * 0.19
             
               when sum(aqpb084bsald) / sum(aqpb084bsalc) * 100 > 85 then
                0.09 * 0.38
             end factor
      
        from aqpb084b
       where aqpb084binst = pn_instancia
         and aqpb084btipo = 2
         and  REGEXP_LIKE(aqpb084bcuen, '^72.501|^72.502|^72.503|^72.504|^72.505|^72.4') -- mpostigoc 09/12/2021
       group by aqpb084binst;
  
    lc_CodSBS varchar2(10);
    ld_FchRCC date;
    --ln_tdocequi      number;
    ln_SegmntoActual number;
    ln_flag          number;
    lb_FlPnl         number;
    ld_FchRCCPnl     date;
    lc_horaEjec      character(8);
    ld_dateEjec      date;
    ln_tipEje        number;
  
  begin
    begin
      --fch RCC
      select to_date(to_char(Tpnro), 'dd/mm/yyyy')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      --fch RCC
      select pgfape into ld_dateEjec from FST017 Where Pgcod = 1;
    exception
      when others then
        ld_dateEjec := trunc(sysdate);
    end;
  
    lc_horaEjec := TO_CHAR(SYSDATE, 'HH:MI:SS');
  
    --ln_SegmntoActual := 1;
    PQ_CR_CALC_METSOBREEND_PYME.SP_CR_SEGMNTOACTUAL(pn_instancia, ln_SegmntoActual);
  
    ln_flag := 1;
    if ln_SegmntoActual = 2 then
      begin
        select 2
          into ln_flag
          from xwf700
         Where XWFPRCINS = pn_instancia
           and XWFCar3 = '1'
           and XWFMODULO = 107;
      
      exception
        when others then
          ln_flag := 1;
      end;
    end if;
    PQ_CR_CALC_METSOBREEND_PYME.SP_BACKUP_AQPA024(pn_instancia, ld_dateEjec, lc_horaEjec);
    PQ_CR_CALC_METSOBREEND_PYME.SP_EXISTEPANEL(pn_instancia, ln_SegmntoActual, lb_FlPnl, ld_FchRCCPnl);
  
    for d in documentos(ln_flag) loop
    
      lc_CodSBS := null;
    
      for rcc in CrCldrcci(d.ln_doc, FN_EQUIVALENCIADOC(d.petdoc)) loop
        lc_CodSBS := rcc.c_codsbs;
      end loop;
    
      --mod@abr 20190802
      if lc_CodSBS is null then
        lc_CodSBS := substr(trim(d.ln_doc), 1, 10);
      end if;
      --mod@abr 20190802
    
      if lb_FlPnl = 1 then
        if ld_FchRCC <> ld_FchRCCPnl then
          ln_tipEje := 1;
          PQ_CR_CALC_METSOBREEND_PYME.SP_RCC(pn_instancia,
                 lc_CodSBS,
                 d.petdoc,
                 d.ln_doc,
                 ld_FchRCC,
                 ld_dateEjec,
                 lc_horaEjec);
        else
          ln_tipEje := 2;
          SP_PANELSD(pn_instancia,
                     lc_CodSBS,
                     d.petdoc,
                     d.ln_doc,
                     ln_SegmntoActual,
                     ld_FchRCC,
                     ld_dateEjec,
                     lc_horaEjec);
        
        end if;
      else
        ln_tipEje := 1;
        SP_RCC(pn_instancia,
               lc_CodSBS,
               d.petdoc,
               d.ln_doc,
               ld_FchRCC,
               ld_dateEjec,
               lc_horaEjec);
      end if;
      SP_DEUINGRE(pn_instancia, pn_evaluacion);
    end loop;
    commit;
  
    --agrupamos aqpb084 de todos
    for r in factores(ln_SegmntoActual) loop
      insert into aqpb084
        (aqpb084INST, aqpb084FECH, aqpb084HORA, aqpb084GRUP, aqpb084FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, r.aqpb084agrup, r.factor);
    
    end loop;
  
    --calculo factor cuota potencial deuda RCC aqpb084b
    for n in factores2(ln_SegmntoActual) loop
      insert into aqpb084
        (aqpb084INST, aqpb084FECH, aqpb084HORA, aqpb084GRUP, aqpb084FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, 8, n.factor);
    end loop;
    --chernandez 17/02/2020
    for o in factores3(ln_SegmntoActual) loop
      insert into aqpb084
        (aqpb084INST, aqpb084FECH, aqpb084HORA, aqpb084GRUP, aqpb084FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, 15, o.factor);
    end loop;
  
    commit;
  
  end SP_INICIO;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
  procedure SP_RCC(pn_instancia numeric,
                   pv_codsbs    varchar2,
                   pn_tdoc      numeric,
                   pc_ndoc      character,
                   pd_FchRCC    date,
                   pd_dateEjec  date,
                   pc_horaEjec  character) is
  
    cursor CrediPym(lv_codsbs varchar2, ld_fec date) is
    
      select a.c_cuenta CUENTA,
             sum(n_salcap) SALDO,
             count(*) cant,
             case
             --chernandez 17/02/2020
             
               when REGEXP_LIKE(a.c_cuenta, '^14.[1-6]030602|^14.[1-6]030302') then --se agrego rubro 0303
                3
               when REGEXP_LIKE(a.c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and not--se agrego rubro 0303
                     REGEXP_LIKE(a.c_cuenta,
                                                                              '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                4
               when REGEXP_LIKE(a.c_cuenta,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') then--se agrego rubro 0303
                5
               when REGEXP_LIKE(a.c_cuenta, '^14.[1-6]04') then
                6
               when REGEXP_LIKE(a.c_cuenta,
                                '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
                     REGEXP_LIKE(a.c_cuenta,
                                                                                        '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601') then
                7
               when REGEXP_LIKE(a.c_cuenta, '^71.[1-4]') then
                9
               else
                0
             end GRUPO
      
        from cldrccs a
       where c_codsbs = lv_codsbs
         and d_fecpre = ld_fec
         and c_codemp <> '00104'
         and (
             
              REGEXP_LIKE(a.c_cuenta, '^14.[1-6]030602|^14.[1-6]030302') or --se agrego rubro 0303
              (REGEXP_LIKE(a.c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
               REGEXP_LIKE(a.c_cuenta,
                                                                         '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or --se agrego rubro 0303
              REGEXP_LIKE(a.c_cuenta, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or--se agrego rubro 0303
              REGEXP_LIKE(a.c_cuenta, '^14.[1-6]04') or
              (REGEXP_LIKE(a.c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(a.c_cuenta,
                                                                                               '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
              REGEXP_LIKE(a.c_cuenta, '^71.[1-4]')
             --chernandez 17/02/2020
             
             )
       group by a.c_cuenta;
  
    cursor Lineas(ln_inst number, lv_codsbs varchar2) is
      select *
        from (select cuenta.*,
                     case
                     --chernandez 17/02/2020 2 modificacion de rubros
                       when REGEXP_LIKE(cuenta,
                                       -- '^14..020601|^14..130601|^14..120601'
                                        '^14..020601|^14..130601|^14..120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') then
                        2
                       when REGEXP_LIKE(cuenta,
                                        '^14..03|^14..02|^14..12|^14..13') then
                        1
                     --when REGEXP_LIKE(cuenta, '^72.5') then 8 
                       else
                        0
                     end GRUPO
                from (select ff.aqpb084bcuen cuenta,
                             case
                               when substr(ff.aqpb084bcuen, 1, 2) = '14' then
                                sum(ff.aqpb084bsald)
                               else
                                sum(ff.aqpb084bsaln)
                             end saldo,
                             count(*) cant
                        from aqpb084b ff
                       where aqpb084bcsbs = lv_codsbs
                         and aqpb084binst = ln_inst
                       group by ff.aqpb084bcuen) cuenta)
       where GRUPO <> 0;
  
    CURSOR NoRegulado is
      select 'NO REGUL' CUENTA,
             SUM(JAQL548SALAC) SALDO,
             count(*) cant,
             13 GRUPO
        from jaql548
       where JAQL546Serial =
             (select max(jaql546serial)
                from jaql546
               where jaql546tidob = pn_tdoc
                 and jaql546nudoc = pc_ndoc
                 and jaql546coerr = '00000')
         and JAQL548Tidet = '18'
         and JAQL548indbo = '0'
         and JAQL548Estado <> '06'
         and JAQL548Ticta = 'CAC'
       group by JAQL546Serial;
    lv_codsbs varchar2(10); --mod@abr 20190801
  begin
  
    --mod@abr 20190801
    if pv_CodSBS is null then
      lv_codsbs := substr(trim(pc_ndoc), 1, 10);
    else
      lv_codsbs := substr(trim(pv_CodSBS), 1, 10);
    end if;
    --mod@abr 20190801
  
    PQ_CR_CALC_METSOBREEND_PYME.SP_OBTENER_LINEAS(pn_instancia,
                      pv_CodSBS,
                      pd_FchRCC,
                      pd_dateEjec,
                      pc_horaEjec);
    for e in CrediPym(pv_CodSBS, pd_FchRCC) loop
      insert into aqpb084a
        (aqpb084ainst,
         aqpb084acsbs,
         aqpb084acuen,
         aqpb084agrup,
         aqpb084atipo,
         aqpb084asald,
         aqpb084acont,
         aqpb084afpre,
         aqpb084atdoc,
         aqpb084andoc,
         aqpb084aFECH,
         aqpb084aHORA)
      values
        (pn_instancia,
         substr(trim(pv_CodSBS), 1, 10), --mod@abr 20190801
         e.cuenta,
         e.grupo,
         1,
         e.saldo,
         e.cant,
         pd_FchRCC,
         pn_tdoc,
         pc_ndoc,
         pd_dateEjec,
         pc_horaEjec);
    end loop;
  
    for ff in Lineas(pn_instancia, pv_CodSBS) loop
      insert into aqpb084a
        (aqpb084ainst,
         aqpb084acsbs,
         aqpb084acuen,
         aqpb084agrup,
         aqpb084atipo,
         aqpb084asald,
         aqpb084acont,
         aqpb084afpre,
         aqpb084atdoc,
         aqpb084andoc,
         aqpb084aFECH,
         aqpb084aHORA)
      values
        (pn_instancia,
         substr(trim(pv_CodSBS), 1, 10), --mod@abr 20190801
         ff.cuenta,
         ff.grupo,
         2,
         ff.saldo,
         ff.cant,
         pd_FchRCC,
         pn_tdoc,
         pc_ndoc,
         pd_dateEjec,
         pc_horaEjec);
    end loop;
  
    for gg in NoRegulado loop
      insert into aqpb084a
        (aqpb084ainst,
         aqpb084acsbs,
         aqpb084acuen,
         aqpb084agrup,
         aqpb084atipo,
         aqpb084asald,
         aqpb084acont,
         aqpb084afpre,
         aqpb084atdoc,
         aqpb084andoc,
         aqpb084aFECH,
         aqpb084aHORA)
      values
        (pn_instancia,
         substr(trim(lv_codsbs), 1, 10), --pv_CodSBS,--mod@abr 20190801
         gg.cuenta,
         gg.grupo,
         3,
         gg.saldo,
         gg.cant,
         pd_FchRCC,
         pn_tdoc,
         pc_ndoc,
         pd_dateEjec,
         pc_horaEjec);
    end loop;
  end SP_RCC;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
  procedure SP_PANELSD(pn_instancia numeric,
                       pv_codsbs    varchar2,
                       pn_tdoc      numeric,
                       pc_ndoc      character,
                       pn_segmento  number,
                       pd_fecrcc    date,
                       pd_dateEjec  date,
                       pc_horaEjec  character) is
    --panel pyme creditos 
    cursor CrediPnl(ln_inst number, ln_tdoc number, lc_ndoc character) is
    
      select a.aqpb081rubr CUENTA,
             sum(aqpb081sdeu) SALDO,
             count(*) cant,
             case
             --chernandez 17/02/2020 modificacion de rubros
             
               when REGEXP_LIKE(a.aqpb081rubr, '^14.[1-6]030602|^14.[1-6]030302') then --se agrego rubro 0303
                3
               when REGEXP_LIKE(a.aqpb081rubr, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
                     REGEXP_LIKE(a.aqpb081rubr,
                                                                                 '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                4
               when REGEXP_LIKE(a.aqpb081rubr,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                5
               when REGEXP_LIKE(a.aqpb081rubr, '^14.[1-6]04') then
                6
               when REGEXP_LIKE(a.aqpb081rubr,
                                '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
                     REGEXP_LIKE(a.aqpb081rubr,
                                                                                        '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then
                7
               when REGEXP_LIKE(a.aqpb081rubr, '^71.[1-4]') then
                9
               else
                0
             end GRUPO
        from aqpb081 a
       where aqpb081inst = ln_inst
         and aqpb081esta = 'S'
         and aqpb081dori = '1'
         and aqpb081chek = '1'
         and aqpb081flin = 'P'
         and aqpb081tdoc = ln_tdoc
         and aqpb081ndoc = lc_ndoc
         and (
             
              REGEXP_LIKE(a.aqpb081rubr, '^14.[1-6]030602|^14.[1-6]030302') or --se agrego rubro 0303
              (REGEXP_LIKE(a.aqpb081rubr, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
               REGEXP_LIKE(a.aqpb081rubr,
                                                                            '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or --se agrego rubro 0303
              REGEXP_LIKE(a.aqpb081rubr, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or --se agrego rubro 0303
              REGEXP_LIKE(a.aqpb081rubr, '^14.[1-6]04') or
              (REGEXP_LIKE(a.aqpb081rubr,
                           '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(a.aqpb081rubr,
                                                                                    '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
              REGEXP_LIKE(a.aqpb081rubr, '^71.[1-4]')
             --chernandez 17/02/2020
             
             )
       group by a.aqpb081rubr;
  
    --panel pyme lineas
    cursor CrediPnlLine(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.aqpb081rubr CUENTA,
             sum(aqpb081util) SALDO,
             count(*) cant,
             case
             --chernandez 17/02/2020 2
               when REGEXP_LIKE(aqpb081rubr,
                               -- '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601'
                                 '^14..020601|^14..130601|^14..120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') then
                2
               when REGEXP_LIKE(aqpb081rubr,
                                '^14..03|^14..02|^14..12|^14..13') then
                1
               else
                0
             end GRUPO
        from aqpb081 a
       where aqpb081inst = ln_inst
         and aqpb081esta = 'S'
         and aqpb081dori = '1'
         and aqpb081chek = '1'
         and aqpb081flin = 'L'
         and aqpb081tdoc = ln_tdoc
         and aqpb081ndoc = lc_ndoc
            --chernandez 17/02/2020
         and (REGEXP_LIKE(a.aqpb081rubr, '^14..03|^14..02|^14..12|^14..13') or
             (REGEXP_LIKE(a.aqpb081rubr,
                           '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05')))
      
       group by a.aqpb081rubr;
  
    --panel pyme lineas cuota potencial
    cursor CrePnlLineasPotencial(ln_inst number,
                                 ln_tdoc number,
                                 lc_ndoc character) is
      select aa.*,
             rownum,
             --chernandez 17/02/2020 2
             case
               when REGEXP_LIKE(aa.aqpb081rubr,
                                '^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05') or
                    (REGEXP_LIKE(aa.aqpb081rubr, '^72.503|^71.2|^71.3') and
                     not
                      REGEXP_LIKE(aa.aqpb081rubr, '^72.5030202|^72.5030302')) then
                2
               when REGEXP_LIKE(aa.aqpb081rubr, '^14.[1-6]..02') or
                    REGEXP_LIKE(aa.aqpb081rubr, '^72.506') then
                1
               else
                0
             end tipo
        from aqpb081 aa
       where aqpb081inst = ln_inst
         and aqpb081esta = 'S'
         and aqpb081dori = '1'
         and aqpb081chek = '1'
         and aqpb081flin = 'L'
         and aqpb081tdoc = ln_tdoc
         and aqpb081ndoc = lc_ndoc;
  
    --panel pyme deuda ingresada
    cursor CrePnlIngre(ln_inst number, ln_tdoc number, lc_ndoc character) is
    
      select 'NO REGUL' CUENTA,
             sum(aqpb081sdeu) SALDO,
             count(*) cant,
             13 GRUPO
        from aqpb081 a
       where aqpb081inst = ln_inst
         and aqpb081esta = 'S'
         and aqpb081dori = '2'
         and aqpb081chek = '1'
         and aqpb081tdoc = ln_tdoc
         and aqpb081ndoc = lc_ndoc
       group by a.aqpb081rubr;
  
    --panel consumo creditos
    cursor PnlConsumo(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.jaqz862rubr CUENTA,
             sum(jaqz862sdeu) SALDO,
             count(*) cant,
             case
             --chernandez 17/02/2020
             
               when REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]030602|^14.[1-6]030302') then --se agrego rubro 0303
                3
               when REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
                     REGEXP_LIKE(a.jaqz862rubr,
                                                                                 '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                4
               when REGEXP_LIKE(a.jaqz862rubr,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                5
               when REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]04') then
                6
               when REGEXP_LIKE(a.jaqz862rubr,
                                '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
                     REGEXP_LIKE(a.jaqz862rubr,
                                                                                        '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then
                7
               when REGEXP_LIKE(a.jaqz862rubr, '^71.[1-4]') then
                9
               else
                0
             end GRUPO
        from jaqz862 a
       where jaqz862inst = ln_inst
         and jaqz862esta = 'S'
         and jaqz862dori = '1'
         and jaqz862chek = '1'
         and jaqz862flin = 'P'
         and jaqz862tdoc = ln_tdoc
         and jaqz862ndoc = lc_ndoc
         and (
             
              REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]030602|^14.[1-6]030302') or --se agrego rubro 0303
              (REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
               REGEXP_LIKE(a.jaqz862rubr,
                                                                            '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or --se agrego rubro 0303
              REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or --se agrego rubro 0303
              REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]04') or
              (REGEXP_LIKE(a.jaqz862rubr,
                           '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(a.jaqz862rubr,
                                                                                    '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
              REGEXP_LIKE(a.jaqz862rubr, '^71.[1-4]')
             --chernandez 17/02/2020
             
             )
       group by a.jaqz862rubr;
  
    --panel consumo lineas
    cursor PnlConsLine(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.jaqz862rubr CUENTA,
             sum(jaqz862util) SALDO,
             count(*) cant,
             case --chernandez 17/02/2020 2
               when REGEXP_LIKE(jaqz862rubr,
                                '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') then
                2
               when REGEXP_LIKE(jaqz862rubr,
                                '^14..03|^14..02|^14..12|^14..13') then
                1
             --when REGEXP_LIKE(cuenta, '^72.5') then 8 
               else
                0
             end GRUPO
        from jaqz862 a
       where jaqz862inst = ln_inst
         and jaqz862esta = 'S'
         and jaqz862dori = '1'
         and jaqz862chek = '1'
         and jaqz862flin = 'L'
         and jaqz862tdoc = ln_tdoc
         and jaqz862ndoc = lc_ndoc
            --chernandez 17/02/2020
         and (REGEXP_LIKE(a.jaqz862rubr, '^14..03|^14..02|^14..12|^14..13') or
             (REGEXP_LIKE(a.jaqz862rubr,
                           '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3')))
      
       group by a.jaqz862rubr;
  
    --panel consumo lineas cuota potencial
    cursor PnlConsLineasPotencial(ln_inst number,
                                  ln_tdoc number,
                                  lc_ndoc character) is
      select aa.*,
             rownum,
             --chernandez 17/02/2020 2
             case
               when REGEXP_LIKE(aa.jaqz862rubr,
                                '^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') or
                    (REGEXP_LIKE(aa.jaqz862rubr, '^72.503') and
                     not
                      REGEXP_LIKE(aa.jaqz862rubr, '^72.5030202|^72.5030302')) then
                2
               when REGEXP_LIKE(aa.jaqz862rubr, '^14.[1-6]..02') or
                    REGEXP_LIKE(aa.jaqz862rubr, '^72.506') then
                1
             
               else
                0
             end tipo
        from jaqz862 aa
       where jaqz862inst = ln_inst
         and jaqz862esta = 'S'
         and jaqz862dori = '1'
         and jaqz862chek = '1'
         and jaqz862flin = 'L'
         and jaqz862tdoc = ln_tdoc
         and jaqz862ndoc = lc_ndoc;
  
    --panel consumo deuda ingresada
    cursor PnlConsumoIngre(ln_inst number,
                           ln_tdoc number,
                           lc_ndoc character) is
    
      select 'NO REGUL' CUENTA,
             sum(jaqz862sdeu) SALDO,
             count(*) cant,
             13 GRUPO
        from jaqz862 a
       where jaqz862inst = ln_inst
         and jaqz862esta = 'S'
         and jaqz862dori = '2'
         and jaqz862chek = '1'
         and jaqz862tdoc = ln_tdoc
         and jaqz862ndoc = lc_ndoc
       group by a.jaqz862rubr;
    lv_empresa varchar(5);
  begin
    if pn_segmento = 1 then
      --calculo de líneas completas aqpb084b
      for ggg in CrePnlLineasPotencial(pn_instancia, pn_tdoc, pc_ndoc) loop
        lv_empresa := trim(to_char(nvl(ggg.aqpb081CENT, ggg.rownum)));
        INSERT INTO aqpb084b
          (aqpb084binst,
           aqpb084bcsbs,
           aqpb084bcemp,
           aqpb084bcuen,
           aqpb084bsald,
           aqpb084bsalc,
           aqpb084bsaln,
           aqpb084bFPRE,
           aqpb084bhora,
           aqpb084bfech,
           aqpb084butil,
           aqpb084btipo) --chernandez 17/02/2020
        VALUES
          (pn_instancia,
           substr(trim(pc_ndoc), 1, 10), --mod@abr 20190801
           substr(lv_empresa, 1, 5),
           ggg.aqpb081rubr,
           ggg.aqpb081util,
           ggg.aqpb081util + ggg.aqpb081aux8,
           ggg.aqpb081aux8,
           ggg.aqpb081frcc,
           pc_horaEjec,
           pd_dateEjec,
           0,
           ggg.tipo); --chernandez 17/02/2020
      end loop;
    
      for e in CrediPnl(pn_instancia, pn_tdoc, pc_ndoc) loop
        insert into aqpb084a
          (aqpb084ainst,
           aqpb084acsbs,
           aqpb084acuen,
           aqpb084agrup,
           aqpb084atipo,
           aqpb084asald,
           aqpb084acont,
           aqpb084afpre,
           aqpb084atdoc,
           aqpb084andoc,
           aqpb084aFECH,
           aqpb084aHORA)
        values
          (pn_instancia,
           substr(trim(pv_CodSBS), 1, 10), --mod@abr 20190801
           e.cuenta,
           e.grupo,
           1,
           e.saldo,
           e.cant,
           pd_fecrcc,
           pn_tdoc,
           pc_ndoc,
           pd_dateEjec,
           pc_horaEjec);
      end loop;
    
      for ee in CrediPnlLine(pn_instancia, pn_tdoc, pc_ndoc) loop
        insert into aqpb084a
          (aqpb084ainst,
           aqpb084acsbs,
           aqpb084acuen,
           aqpb084agrup,
           aqpb084atipo,
           aqpb084asald,
           aqpb084acont,
           aqpb084afpre,
           aqpb084atdoc,
           aqpb084andoc,
           aqpb084aFECH,
           aqpb084aHORA)
        values
          (pn_instancia,
           substr(trim(pv_CodSBS), 1, 10), --mod@abr 20190801
           ee.cuenta,
           ee.grupo,
           2,
           ee.saldo,
           ee.cant,
           pd_fecrcc,
           pn_tdoc,
           pc_ndoc,
           pd_dateEjec,
           pc_horaEjec);
      end loop;
    
      for ff in CrePnlIngre(pn_instancia, pn_tdoc, pc_ndoc) loop
        insert into aqpb084a
          (aqpb084ainst,
           aqpb084acsbs,
           aqpb084acuen,
           aqpb084agrup,
           aqpb084atipo,
           aqpb084asald,
           aqpb084acont,
           aqpb084afpre,
           aqpb084atdoc,
           aqpb084andoc,
           aqpb084aFECH,
           aqpb084aHORA)
        values
          (pn_instancia,
           substr(trim(pv_CodSBS), 1, 10), --mod@abr 20190801
           ff.cuenta,
           ff.grupo,
           3,
           ff.saldo,
           ff.grupo,
           pd_fecrcc,
           pn_tdoc,
           pc_ndoc,
           pd_dateEjec,
           pc_horaEjec);
      end loop;
    
    else
      for e in PnlConsumo(pn_instancia, pn_tdoc, pc_ndoc) loop
        insert into aqpb084a
          (aqpb084ainst,
           aqpb084acsbs,
           aqpb084acuen,
           aqpb084agrup,
           aqpb084atipo,
           aqpb084asald,
           aqpb084acont,
           aqpb084afpre,
           aqpb084atdoc,
           aqpb084andoc,
           aqpb084aFECH,
           aqpb084aHORA)
        values
          (pn_instancia,
           substr(trim(pv_CodSBS), 1, 10), --mod@abr 20190801
           e.cuenta,
           e.grupo,
           1,
           e.saldo,
           e.cant,
           pd_fecrcc,
           pn_tdoc,
           pc_ndoc,
           pd_dateEjec,
           pc_horaEjec);
      
      end loop;
    
      for ee in PnlConsLine(pn_instancia, pn_tdoc, pc_ndoc) loop
        insert into aqpb084a
          (aqpb084ainst,
           aqpb084acsbs,
           aqpb084acuen,
           aqpb084agrup,
           aqpb084atipo,
           aqpb084asald,
           aqpb084acont,
           aqpb084afpre,
           aqpb084atdoc,
           aqpb084andoc,
           aqpb084aFECH,
           aqpb084aHORA)
        values
          (pn_instancia,
           substr(trim(pv_CodSBS), 1, 10), --mod@abr 20190801
           ee.cuenta,
           ee.grupo,
           2,
           ee.saldo,
           ee.cant,
           pd_fecrcc,
           pn_tdoc,
           pc_ndoc,
           pd_dateEjec,
           pc_horaEjec);
      
      end loop;
    
      for gg in PnlConsumoingre(pn_instancia, pn_tdoc, pc_ndoc) loop
        insert into aqpb084a
          (aqpb084ainst,
           aqpb084acsbs,
           aqpb084acuen,
           aqpb084agrup,
           aqpb084atipo,
           aqpb084asald,
           aqpb084acont,
           aqpb084afpre,
           aqpb084atdoc,
           aqpb084andoc,
           aqpb084aFECH,
           aqpb084aHORA)
        values
          (pn_instancia,
           substr(trim(pv_CodSBS), 1, 10), --mod@abr 20190801
           gg.cuenta,
           gg.grupo,
           3,
           gg.saldo,
           gg.grupo,
           pd_fecrcc,
           pn_tdoc,
           pc_ndoc,
           pd_dateEjec,
           pc_horaEjec);
      end loop;
    
      for ggg in PnlConsLineasPotencial(pn_instancia, pn_tdoc, pc_ndoc) loop
        lv_empresa := trim(to_char(nvl(ggg.jaqz862CENT, ggg.rownum)));
        INSERT INTO aqpb084b
          (aqpb084binst,
           aqpb084bcsbs,
           aqpb084bcemp,
           aqpb084bcuen,
           aqpb084bsald,
           aqpb084bsalc,
           aqpb084bsaln,
           aqpb084bFPRE,
           aqpb084bhora,
           aqpb084bfech,
           aqpb084butil,
           aqpb084btipo) --chernandez 17/02/2020
        VALUES
          (pn_instancia,
           substr(trim(pc_ndoc), 1, 10), --mod@abr 20190801
           substr(lv_empresa, 1, 5),
           ggg.jaqz862rubr,
           ggg.jaqz862util,
           ggg.jaqz862util + ggg.jaqz862aux8,
           ggg.jaqz862aux8,
           ggg.jaqz862frcc,
           pc_horaEjec,
           pd_dateEjec,
           0,
           ggg.tipo); --chernandez 17/02/2020
      end loop;
    
    end if;
    commit;
  
  end SP_PANELSD;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
  procedure SP_OBTENER_LINEAS(pn_instancia numeric,
                              pv_codsbs    varchar2,
                              pd_fec       date,
                              pd_dateEjec  date,
                              pc_horaEjec  character) is
  
    cursor lineas1 is --chernandez 28/01/2020 se eliminó parámetro
      select *
        from (select substr(a.c_cuenta, 1, 2) CUENTA,
                     sum(n_salcap) SALDO,
                     a.c_codemp,
                     substr(a.c_cuenta, 5, 2) TIPCRE,
                     substr(a.c_cuenta, 3, 1) MON
                from cldrccs a
               where c_codsbs = pv_codsbs
                 and d_fecpre = pd_fec
                 and c_codemp <> '00104'
                 and (REGEXP_LIKE(a.c_cuenta, '^14.[1-6]..02')
                     --or REGEXP_LIKE(a.c_cuenta, '^14.[1-6]020601|^141[1-6]029901|^141[1-6]130601|^141[1-6]120601')
                     )
              
               group by substr(a.c_cuenta, 1, 2),
                        a.c_codemp,
                        substr(a.c_cuenta, 5, 2),
                        substr(a.c_cuenta, 3, 1)
              
              UNION ALL
              
              select substr(a.c_cuenta, 1, 2) CUENTA,
                     sum(n_salcap) SALDO,
                     a.c_codemp,
                     substr(a.c_cuenta, 7, 2),
                     substr(a.c_cuenta, 3, 1)
                from cldrccs a
               where c_codsbs = pv_codsbs --'0113834579'
                 and d_fecpre = pd_fec
                 and c_codemp <> '00104'
                 and REGEXP_LIKE(a.c_cuenta, '^72.506') --chernandez 17/02/2020
              
               group by substr(a.c_cuenta, 1, 2),
                        a.c_codemp,
                        substr(a.c_cuenta, 7, 2),
                        substr(a.c_cuenta, 3, 1)
              
              )
      
       order by c_codemp, TIPCRE, MON;
    --chernandez 17/02/2020
    cursor lineas2 is
      select *
        from (select substr(a.c_cuenta, 1, 2) CUENTA,
                     sum(n_salcap) SALDO,
                     a.c_codemp,
                     substr(a.c_cuenta, 5, 2) TIPCRE,
                     substr(a.c_cuenta, 3, 1) MON
                from cldrccs a
               where c_codsbs = pv_codsbs
                 and d_fecpre = pd_fec
                 and c_codemp <> '00104'
                 and ( --REGEXP_LIKE(a.c_cuenta, '^14.[1-6]..02')
                      REGEXP_LIKE(a.c_cuenta,
                                  '^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601'))
              
               group by substr(a.c_cuenta, 1, 2),
                        a.c_codemp,
                        substr(a.c_cuenta, 5, 2),
                        substr(a.c_cuenta, 3, 1)
              
              UNION ALL
              
              select substr(a.c_cuenta, 1, 2) CUENTA,
                     sum(n_salcap) SALDO,
                     a.c_codemp,
                     substr(a.c_cuenta, 7, 2),
                     substr(a.c_cuenta, 3, 1)
                from cldrccs a
               where c_codsbs = pv_codsbs --'0113834579'
                 and d_fecpre = pd_fec
                 and c_codemp <> '00104'
                 and (REGEXP_LIKE(a.c_cuenta, '^72.503') and
                     not REGEXP_LIKE(a.c_cuenta, '^72.5030202|^72.5030302'))
              
               group by substr(a.c_cuenta, 1, 2),
                        a.c_codemp,
                        substr(a.c_cuenta, 7, 2),
                        substr(a.c_cuenta, 3, 1)
              
              )
      
       order by c_codemp, TIPCRE, MON;
  
    lc_cuenta    varchar2(14);
    ln_saldo     numeric(18, 2);
    lc_codemp    varchar2(5);
    lc_codempANT varchar2(5);
    ln_saldo14   numeric(18, 2);
    ln_saldo72   numeric(18, 2);
    ln_saldo81   numeric(18, 2);
    ln_saldod14  numeric(18, 2);
    ln_saldod72  numeric(18, 2);
    ln_saldod81  numeric(18, 2);
    ln_cuenta14  varchar2(14);
    ln_cuenta72  varchar2(14);
    ln_cuenta81  varchar2(14);
    ln_tipcre    numeric(5);
    ln_tipcreant numeric(5);
    ln_moneda    numeric(5);
    ln_monedaAnt numeric(5);
    ln_entro     numeric(5); --chernandez 17/02/2020
  
  begin
  
    --lineas1 soles
    ln_saldo14   := 0;
    ln_saldo72   := 0;
    ln_saldo81   := 0;
    ln_saldod14  := 0;
    ln_saldod72  := 0;
    ln_saldod81  := 0;
    lc_codempANT := '';
    ln_tipcreant := 0;
    ln_monedaAnt := 0;
    ln_cuenta14  := 0;
    ln_cuenta72  := 0;
    ln_cuenta81  := 0;
    ln_entro     := 0; --chernandez 17/02/2020
  
    for i in lineas1 loop
    
      lc_codemp := i.c_codemp;
      lc_cuenta := i.cuenta;
      ln_saldo  := i.saldo;
      ln_tipcre := i.tipcre;
      ln_moneda := i.mon;
    
      if lc_codempANT = '' or lc_codempANT is null then
        lc_codempANT := lc_codemp;
        ln_tipcreant := ln_tipcre;
        ln_monedaAnt := ln_moneda;
      end if;
    
      PQ_CR_CALC_METSOBREEND_PYME.SP_OBTENER_SALDO_LINEAS(pv_codsbs,
                              pd_fec,
                              pn_instancia,
                              lc_codemp,
                              lc_codempANT,
                              lc_cuenta,
                              ln_saldo,
                              ln_saldo14,
                              ln_saldo72,
                              ln_saldo81,
                              ln_saldod14,
                              ln_saldod72,
                              ln_saldod81,
                              ln_moneda,
                              ln_monedaAnt,
                              ln_tipcre,
                              ln_tipcreant,
                              pd_dateEjec,
                              pc_horaEjec,
                              1, --chernandez 17/02/2020
                              ln_cuenta14,
                              ln_cuenta72,
                              ln_cuenta81);
    
      lc_codempANT := lc_codemp;
      ln_entro     := 1; --chernandez 17/02/2020
    end loop;
    if ln_entro = 1 then
      --chernandez 17/02/2020
      PQ_CR_CALC_METSOBREEND_PYME.SP_OBTENER_SALDO_LINEAS_ULTEJ(pv_codsbs,
                                    pd_fec,
                                    pn_instancia,
                                    lc_codempANT,
                                    ln_saldo14,
                                    ln_saldo72,
                                    ln_saldo81,
                                    ln_saldod14,
                                    ln_saldod72,
                                    ln_saldod81,
                                    ln_tipcreant,
                                    pd_dateEjec,
                                    pc_horaEjec,
                                    1,
                                    ln_cuenta14,
                                    ln_cuenta72);
    end if;
    --chernandez 17/02/2020
    --lineas2 soles
    ln_saldo14   := 0;
    ln_saldo72   := 0;
    ln_saldo81   := 0;
    ln_saldod14  := 0;
    ln_saldod72  := 0;
    ln_saldod81  := 0;
    lc_codempANT := '';
    ln_tipcreant := 0;
    ln_monedaAnt := 0;
    ln_cuenta14  := 0;
    ln_cuenta72  := 0;
    ln_cuenta81  := 0;
    ln_entro     := 0;
  
    for i in lineas2 loop
    
      lc_codemp := i.c_codemp;
      lc_cuenta := i.cuenta;
      ln_saldo  := i.saldo;
      ln_tipcre := i.tipcre;
      ln_moneda := i.mon;
    
      if lc_codempANT = '' or lc_codempANT is null then
        lc_codempANT := lc_codemp;
        ln_tipcreant := ln_tipcre;
        ln_monedaAnt := ln_moneda;
      end if;
    
      SP_OBTENER_SALDO_LINEAS(pv_codsbs,
                              pd_fec,
                              pn_instancia,
                              lc_codemp,
                              lc_codempANT,
                              lc_cuenta,
                              ln_saldo,
                              ln_saldo14,
                              ln_saldo72,
                              ln_saldo81,
                              ln_saldod14,
                              ln_saldod72,
                              ln_saldod81,
                              ln_moneda,
                              ln_monedaAnt,
                              ln_tipcre,
                              ln_tipcreant,
                              pd_dateEjec,
                              pc_horaEjec,
                              2,
                              ln_cuenta14,
                              ln_cuenta72,
                              ln_cuenta81);
    
      lc_codempANT := lc_codemp;
      ln_entro     := 1;
    end loop;
    if ln_entro = 1 then
      SP_OBTENER_SALDO_LINEAS_ULTEJ(pv_codsbs,
                                    pd_fec,
                                    pn_instancia,
                                    lc_codempANT,
                                    ln_saldo14,
                                    ln_saldo72,
                                    ln_saldo81,
                                    ln_saldod14,
                                    ln_saldod72,
                                    ln_saldod81,
                                    ln_tipcreant,
                                    pd_dateEjec,
                                    pc_horaEjec,
                                    2,
                                    ln_cuenta14,
                                    ln_cuenta72);
    end if;
  end SP_OBTENER_LINEAS;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
  procedure SP_OBTENER_SALDO_LINEAS(pv_codsbs    varchar2,
                                    pd_fec       date,
                                    pn_instancia numeric,
                                    pc_codent    varchar2,
                                    pc_codentant in out varchar2,
                                    pc_cuenta    varchar2,
                                    pn_saldo     numeric,
                                    pn_saldo14   in out numeric,
                                    pn_saldo72   in out numeric,
                                    pn_saldo81   in out numeric,
                                    pn_saldoD14  in out numeric,
                                    pn_saldoD72  in out numeric,
                                    pn_saldoD81  in out numeric,
                                    pn_moneda    in numeric,
                                    pn_monedaANT in out numeric,
                                    pn_tipcre    in numeric,
                                    pn_tipcreANT in out numeric,
                                    pd_dateEjec  date,
                                    pc_horaEjec  character,
                                    pn_tipo      in numeric, --chernandez 17/02/2020
                                    pn_cuenta14  in out varchar2,
                                    pn_cuenta72  in out varchar2,
                                    pn_cuenta81  in out varchar2) is
    pn_cuenta    varchar2(14);
    pn_cuentadol varchar2(14);
    pv_tipo72    varchar2(2); --chernandez 17/02/2020
    pv_tipo14    varchar2(4); --chernandez 17/02/2020 2
  begin
    --chernandez 17/02/2020
    if pn_tipo = 1 then
      pv_tipo72 := '06';
      pv_tipo14 := ''; --chernandez 17/02/2020 2
    End if;
    if pn_tipo = 2 then
      pv_tipo72 := '03';
      pv_tipo14 := '0601'; --chernandez 17/02/2020 2
    End if;
    if pc_codent <> pc_codentANT or pn_tipcre <> pn_tipcreANT then
      pn_cuenta    := '';
      pn_cuentadol := '';
      if pn_saldo14 <> 0 and pn_saldo72 <> 0 then
        pn_saldo81 := pn_saldo14 + pn_saldo72;
        pn_cuenta  := pn_cuenta14 || '1.' ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0')) ||
                      pv_tipo14; --chernandez 17/02/2020 2
      end if;
    
      if pn_saldo14 = 0 and pn_saldo72 <> 0 then
        pn_saldo81 := pn_saldo72;
        --chernandez 17/02/2020
        pn_cuenta := pn_cuenta72 || '15' || pv_tipo72 ||
                     trim(lpad(to_char(pn_tipcreANT), 2, '0'));
      end if;
    
      if pn_saldo14 <> 0 and pn_saldo72 = 0 then
        pn_saldo81 := pn_saldo14;
        pn_cuenta  := pn_cuenta14 || '1.' ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0')) ||
                      pv_tipo14; --chernandez 17/02/2020 2
      end if;
    
      if pn_saldoD14 <> 0 and pn_saldoD72 <> 0 then
        pn_saldoD81  := pn_saldoD14 + pn_saldoD72;
        pn_cuentadol := pn_cuenta14 || '2.' ||
                        trim(lpad(to_char(pn_tipcreANT), 2, '0')) ||
                        pv_tipo14; --chernandez 17/02/2020 2
      end if;
    
      if pn_saldoD14 = 0 and pn_saldoD72 <> 0 then
        pn_saldoD81 := pn_saldoD72;
        --chernandez 17/02/2020
        pn_cuentadol := pn_cuenta72 || '25' || pv_tipo72 ||
                        trim(lpad(to_char(pn_tipcreANT), 2, '0'));
      end if;
    
      if pn_saldoD14 <> 0 and pn_saldoD72 = 0 then
        pn_saldoD81  := pn_saldoD14;
        pn_cuentadol := pn_cuenta14 || '2.' ||
                        trim(lpad(to_char(pn_tipcreANT), 2, '0')) ||
                        pv_tipo14; --chernandez 17/02/2020 2
      end if;
    
      if pn_saldo14 <> 0 or pn_saldo72 <> 0 then
        --insertamos tabla auxiliar
        INSERT INTO aqpb084b
          (aqpb084binst,
           aqpb084bcsbs,
           aqpb084bcemp,
           aqpb084bcuen,
           aqpb084bsald,
           aqpb084bsalc,
           aqpb084bsaln,
           aqpb084bfpre,
           aqpb084bhora,
           aqpb084bfech,
           aqpb084butil,
           aqpb084btipo) --chernandez 17/02/2020
        VALUES
          (pn_instancia,
           substr(trim(pv_codsbs), 1, 10), --mod@abr 20190801
           substr(pc_codentANT, 1, 5),
           pn_cuenta,
           pn_saldo14,
           pn_saldo81,
           pn_saldo72,
           pd_fec,
           pc_horaEjec,
           pd_dateEjec,
           pn_tipcreANT,
           pn_tipo); --chernandez 17/02/2020
      end if;
    
      if pn_saldod14 <> 0 or pn_saldod72 <> 0 then
        --insertamos tabla auxiliar
        INSERT INTO aqpb084b
          (aqpb084binst,
           aqpb084bcsbs,
           aqpb084bcemp,
           aqpb084bcuen,
           aqpb084bsald,
           aqpb084bsalc,
           aqpb084bsaln,
           aqpb084bFPRE,
           aqpb084bhora,
           aqpb084bfech,
           aqpb084butil,
           aqpb084btipo) --chernandez 17/02/2020
        VALUES
          (pn_instancia,
           substr(trim(pv_codsbs), 1, 10), --mod@abr 20190801
           substr(pc_codentANT, 1, 5),
           pn_cuentadol,
           pn_saldod14,
           pn_saldod81,
           pn_saldod72,
           pd_fec,
           pc_horaEjec,
           pd_dateEjec,
           pn_tipcreANT,
           pn_tipo); --chernandez 17/02/2020
      
      End If;
    
      pn_saldo14  := 0;
      pn_saldo72  := 0;
      pn_saldo81  := 0;
      pn_saldoD14 := 0;
      pn_saldoD72 := 0;
      pn_saldoD81 := 0;
      pn_cuenta14 := '';
      pn_cuenta72 := '';
      pn_cuenta81 := '';
      --pn_cuenta:= '';
    end if;
  
    If substr(pc_cuenta, 1, 2) = 14 and pn_moneda = 1 then
      pn_saldo14  := pn_saldo14 + pn_saldo;
      pn_cuenta14 := pc_cuenta;
    end if;
    If substr(pc_cuenta, 1, 2) = 14 and pn_moneda = 2 then
      pn_saldoD14 := pn_saldoD14 + pn_saldo;
      pn_cuenta14 := pc_cuenta;
    end if;
    If substr(pc_cuenta, 1, 2) = 72 and pn_moneda = 1 then
      pn_saldo72  := pn_saldo72 + pn_saldo;
      pn_cuenta72 := pc_cuenta;
    end if;
    If substr(pc_cuenta, 1, 2) = 72 and pn_moneda = 2 then
      pn_saldoD72 := pn_saldoD72 + pn_saldo;
      pn_cuenta72 := pc_cuenta;
    end if;
  
    pc_codentANT := pc_codent;
    pn_tipcreANT := pn_tipcre;
    pn_monedaANT := pn_moneda;
  
  END SP_OBTENER_SALDO_LINEAS;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
  procedure SP_OBTENER_SALDO_LINEAS_ULTEJ(pv_codsbs    varchar2,
                                          pd_fec       date,
                                          pn_instancia numeric,
                                          pc_codentant in out varchar2,
                                          pn_saldo14   in out numeric,
                                          pn_saldo72   in out numeric,
                                          pn_saldo81   in out numeric,
                                          pn_saldoD14  in out numeric,
                                          pn_saldoD72  in out numeric,
                                          pn_saldoD81  in out numeric,
                                          pn_tipcreANT in numeric,
                                          pd_dateEjec  date,
                                          pc_horaEjec  character,
                                          pn_tipo      in numeric, --chernandez 17/02/2020
                                          pn_cuenta14  in out varchar2,
                                          pn_cuenta72  in out varchar2) is
  
    pn_cuenta    varchar2(14);
    pn_cuentadol varchar2(14);
    pv_tipo72    varchar2(2); --chernandez 17/02/2020
    pv_tipo14    varchar2(4); --chernandez 17/02/2020 2
  begin
    --chernandez 17/02/2020
    if pn_tipo = 1 then
      pv_tipo72 := '06';
      pv_tipo14 := ''; --chernandez 17/02/2020 2
    End if;
    if pn_tipo = 2 then
      pv_tipo72 := '03';
      pv_tipo14 := '0601'; --chernandez 17/02/2020 2
    End if;
    pn_cuenta    := '';
    pn_cuentadol := '';
    if pn_saldo14 <> 0 and pn_saldo72 <> 0 then
      pn_saldo81 := pn_saldo14 + pn_saldo72;
      pn_cuenta  := pn_cuenta14 || '1.' ||
                    trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14; --chernandez 17/02/2020 2
    end if;
  
    if pn_saldo14 = 0 and pn_saldo72 <> 0 then
      pn_saldo81 := pn_saldo72;
      --chernandez 17/02/2020
      pn_cuenta := pn_cuenta72 || '15' || pv_tipo72 ||
                   trim(lpad(to_char(pn_tipcreANT), 2, '0'));
    end if;
  
    if pn_saldo14 <> 0 and pn_saldo72 = 0 then
      pn_saldo81 := pn_saldo14;
      pn_cuenta  := pn_cuenta14 || '1.' ||
                    trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14; --chernandez 17/02/2020 2
    end if;
  
    if pn_saldoD14 <> 0 and pn_saldoD72 <> 0 then
      pn_saldoD81  := pn_saldoD14 + pn_saldoD72;
      pn_cuentadol := pn_cuenta14 || '2.' ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0')) ||
                      pv_tipo14; --chernandez 17/02/2020 2
    end if;
  
    if pn_saldoD14 = 0 and pn_saldoD72 <> 0 then
      pn_saldoD81 := pn_saldoD72;
      --chernandez 17/02/2020
      pn_cuentadol := pn_cuenta72 || '25' || pv_tipo72 ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0'));
    end if;
  
    if pn_saldoD14 <> 0 and pn_saldoD72 = 0 then
      pn_saldoD81  := pn_saldoD14;
      pn_cuentadol := pn_cuenta14 || '2.' ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0')) ||
                      pv_tipo14; --chernandez 17/02/2020 2
    end if;
  
    if pn_saldo14 <> 0 or pn_saldo72 <> 0 then
      --insertamos tabla auxiliar
      INSERT INTO aqpb084b
        (aqpb084binst,
         aqpb084bcsbs,
         aqpb084bcemp,
         aqpb084bcuen,
         aqpb084bsald,
         aqpb084bsalc,
         aqpb084bsaln,
         aqpb084bfpre,
         aqpb084bhora,
         aqpb084bfech,
         aqpb084butil,
         aqpb084btipo) --chernandez 17/02/2020
      VALUES
        (pn_instancia,
         substr(trim(pv_codsbs), 1, 10), --mod@abr 20190801
         substr(pc_codentANT, 1, 5),
         pn_cuenta,
         pn_saldo14,
         pn_saldo81,
         pn_saldo72,
         pd_fec,
         pc_horaEjec,
         pd_dateEjec,
         pn_tipcreANT,
         pn_tipo); --chernandez 17/02/2020
    end if;
  
    if pn_saldod14 <> 0 or pn_saldod72 <> 0 then
      --insertamos tabla auxiliar
      INSERT INTO aqpb084b
        (aqpb084binst,
         aqpb084bcsbs,
         aqpb084bcemp,
         aqpb084bcuen,
         aqpb084bsald,
         aqpb084bsalc,
         aqpb084bsaln,
         aqpb084bFPRE,
         aqpb084bhora,
         aqpb084bfech,
         aqpb084butil,
         aqpb084btipo) --chernandez 17/02/2020
      VALUES
        (pn_instancia,
         substr(trim(pv_codsbs), 1, 10), --mod@abr 20190801
         substr(pc_codentANT, 1, 5),
         pn_cuentadol,
         pn_saldod14,
         pn_saldod81,
         pn_saldod72,
         pd_fec,
         pc_horaEjec,
         pd_dateEjec,
         pn_tipcreANT,
         pn_tipo); --chernandez 17/02/2020
    
    End If;
  
  end SP_OBTENER_SALDO_LINEAS_ULTEJ;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure SP_CR_SEGMNTOACTUAL(ln_Instancia     number,
                                ln_SegmntoActual out number) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_nrodoc char(12);
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_nrodoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    Exception
      when others then
        null;
    end;
  
    if ln_tdoc <> 9 then
    
      begin
        select to_number(trim(b.segcod))
          into ln_SegmntoActual
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and a.sngc60ndoc = lc_nrodoc
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into ln_SegmntoActual
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and a.sngc60ndoc = lc_nrodoc
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and a.sngc60ndoc = lc_nrodoc
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          null;
        
      end;
    
    else
      if ln_tdoc = 9 then
        ln_SegmntoActual := 1;
      end if;
    end if;
  
  end SP_CR_SEGMNTOACTUAL;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function FN_EQUIVALENCIADOC(p_tdoc in number) return varchar2 is
    cursor datos is
      select tp1nro2
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11111
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1nro1 = p_tdoc;
  
    resp  number(5);
    respc varchar2(1);
  begin
    resp := 1;
    for i in datos loop
      resp := i.tp1nro2;
    end loop;
    respc := to_char(resp);
    return respc;
  end FN_EQUIVALENCIADOC;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure SP_EXISTEPANEL(pn_instancia number,
                           pn_segmento  number,
                           pb_flag      out number,
                           pd_fecprc    out date) is
  
  begin
    pb_flag   := 0;
    pd_fecprc := null;
    if pn_segmento = 1 then
      begin
        select aqpb081FRCC, 1
          into pd_fecprc, pb_flag
          from aqpb081
         where aqpb081inst = pn_instancia
           and aqpb081esta = 'S'
              --and aqpb081dori = '1'
           and rownum = 1;
      exception
        when no_data_found then
          pb_flag := 0;
      end;
    else
      begin
        select jaqz862frcc, 1
          into pd_fecprc, pb_flag
          from jaqz862
         where jaqz862inst = pn_instancia
           and jaqz862esta = 'S'
              --and jaqz862dori = '1'
           and rownum = 1;
      exception
        when no_data_found then
          pb_flag := 0;
      end;
    end if;
  
  end SP_EXISTEPANEL;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure SP_BACKUP_AQPA024(pn_instancia number,
                              PD_FECHAEJE  DATE,
                              PC_HORA      CHARACTER) is
  
  begin
  
    INSERT INTO aqpb084l
      (aqpb084lfech1,
       aqpb084lhora1,
       aqpb084linst,
       aqpb084lcsbs,
       aqpb084lcuen,
       aqpb084lgrup,
       aqpb084ltipo,
       aqpb084lsald,
       aqpb084lcont,
       aqpb084lfpre,
       aqpb084ltdoc,
       aqpb084lndoc,
       aqpb084lfech,
       aqpb084lhora)
      select PD_FECHAEJE,
             PC_HORA,
             aqpb084ainst,
             aqpb084acsbs,
             aqpb084acuen,
             aqpb084agrup,
             aqpb084atipo,
             aqpb084asald,
             aqpb084acont,
             aqpb084afpre,
             aqpb084atdoc,
             aqpb084andoc,
             aqpb084afech,
             aqpb084ahora
        from aqpb084a
       where aqpb084aINST = pn_instancia;
  
    DELETE FROM aqpb084a where aqpb084aINST = pn_instancia;
  
    INSERT INTO aqpb084m
      (aqpb084mfech1,
       aqpb084mhora1,
       aqpb084minst,
       aqpb084mcsbs,
       aqpb084mcemp,
       aqpb084mcuen,
       aqpb084msald,
       aqpb084msalc,
       aqpb084msaln,
       aqpb084mbfpre,
       aqpb084mfech,
       aqpb084mhora)
      select PD_FECHAEJE,
             PC_HORA,
             aqpb084binst,
             aqpb084bcsbs,
             aqpb084bcemp,
             aqpb084bcuen,
             aqpb084bsald,
             aqpb084bsalc,
             aqpb084bsaln,
             aqpb084bfpre,
             aqpb084bfech,
             aqpb084bhora
        from aqpb084b
       where aqpb084bINST = pn_instancia;
  
    DELETE FROM aqpb084b where aqpb084bINST = pn_instancia;
  
    INSERT INTO aqpb084n
      (aqpb084nfech1,
       aqpb084nhora1,
       aqpb084ninst,
       aqpb084nfech,
       aqpb084nhora,
       aqpb084ngrup,
       aqpb084nfact)
      select PD_FECHAEJE,
             PC_HORA,
             aqpb084inst,
             aqpb084fech,
             aqpb084hora,
             aqpb084grup,
             aqpb084fact
        from aqpb084
       where aqpb084INST = pn_instancia;
  
    DELETE FROM aqpb084 where aqpb084INST = pn_instancia;
  
    COMMIT;
  end SP_BACKUP_AQPA024;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure SP_DEUINGRE(pn_instancia numeric, pn_evaluacion numeric) is
  
    cursor factores(pln_SegmntoActual numeric) is
      select aqpb084agrup,
             case
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 8000 then
                0.0514
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 15000 then
                0.0356
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 45000 then
                0.0282
               when aqpb084agrup = 11 and sum(aqpb084asald) > 45000 then
                0.0222
               when aqpb084agrup = 12 then
                0.09
             end factor
        from (select case
                       when AQPB086txt2 =
                            'Prestamo                                ' then
                        sum(AQPB086mto1)
                       else
                        sum(AQPB086mto4)
                     end aqpb084asald,
                     
                     case
                       when AQPB086txt2 =
                            'Prestamo                                ' then
                        11
                       else
                        12
                     end aqpb084agrup,
                     pn_instancia instancia
              
                from AQPB086
               where AQPB086eval = pn_evaluacion
               group by AQPB086eval, AQPB086txt2)
       group by aqpb084agrup;
  
    cursor factoresCons(pln_SegmntoActual numeric) is
      select aqpb084agrup,
             case
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 8000 then
                0.0514
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 15000 then
                0.0356
               when aqpb084agrup = 11 and sum(aqpb084asald) <= 45000 then
                0.0282
               when aqpb084agrup = 11 and sum(aqpb084asald) > 45000 then
                0.0222
               when aqpb084agrup = 12 then
                0.09
             end factor
        from (select case
                       when AQPB087txt2 =
                            'Prestamo                                ' then
                        sum(AQPB087mto1)
                       else
                        sum(AQPB087mto4)
                     end aqpb084asald,
                     
                     case
                       when AQPB087txt2 =
                            'Prestamo                                ' then
                        11
                       else
                        12
                     end aqpb084agrup,
                     pn_instancia instancia
              
                from AQPB087
               where AQPB087eval = pn_evaluacion
               group by AQPB087eval, AQPB087txt2)
       group by aqpb084agrup;
  
    cursor factores2(pln_SegmntoActual numeric) is
      select case
               when sum(AQPB086mto4) / sum(aqpb084bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.02
             
               when sum(AQPB086mto4) / sum(aqpb084bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.09
             
               when sum(AQPB086mto4) / sum(aqpb084bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.11
             
               when sum(AQPB086mto4) / sum(aqpb084bsalc) * 100 > 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.21
             
               when sum(AQPB086mto4) / sum(aqpb084bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.03
             
               when sum(AQPB086mto4) / sum(aqpb084bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.07
             
               when sum(AQPB086mto4) / sum(aqpb084bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.12
             
               when sum(AQPB086mto4) / sum(aqpb084bsalc) * 100 > 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.25
             end factor
      
        from (select AQPB086mto4,
                     AQPB086mto3 + AQPB086mto4 aqpb084bsalc,
                     AQPB086eval
                from AQPB086
               where AQPB086eval = pn_evaluacion
                 and AQPB086txt2 =
                     'Linea                                   '
                 and (AQPB086mto3 + AQPB086mto4) <> 0)
       group by AQPB086eval;
  
    cursor factores3(pln_SegmntoActual numeric) is
      select --sum(AQPB087mto4)/sum(mtotot)*100 
       case
         when sum(AQPB087mto4) / sum(aqpb084bsalc) * 100 <= 45 and
              pln_SegmntoActual = 1 then
          0.044 * 0.02
       
         when sum(AQPB087mto4) / sum(aqpb084bsalc) * 100 <= 65 and
              pln_SegmntoActual = 1 then
          0.044 * 0.09
       
         when sum(AQPB087mto4) / sum(aqpb084bsalc) * 100 <= 85 and
              pln_SegmntoActual = 1 then
          0.044 * 0.11
       
         when sum(AQPB087mto4) / sum(aqpb084bsalc) * 100 > 85 and
              pln_SegmntoActual = 1 then
          0.044 * 0.21
       
         when sum(AQPB087mto4) / sum(aqpb084bsalc) * 100 <= 45 and
              pln_SegmntoActual = 2 then
          0.044 * 0.03
       
         when sum(AQPB087mto4) / sum(aqpb084bsalc) * 100 <= 65 and
              pln_SegmntoActual = 2 then
          0.044 * 0.07
       
         when sum(AQPB087mto4) / sum(aqpb084bsalc) * 100 <= 85 and
              pln_SegmntoActual = 2 then
          0.044 * 0.12
       
         when sum(AQPB087mto4) / sum(aqpb084bsalc) * 100 > 85 and
              pln_SegmntoActual = 2 then
          0.044 * 0.25
       end factor
      
        from (select AQPB087mto4,
                     AQPB087mto3 + AQPB087mto4 aqpb084bsalc,
                     AQPB087eval
                from AQPB087
               where AQPB087eval = pn_evaluacion
                 and AQPB087txt2 =
                     'Linea                                   '
                 and (AQPB087mto3 + AQPB087mto4) <> 0)
       group by AQPB087eval;
  
    --ln_tdocequi      number;
    ln_SegmntoActual number;
    lc_horaEjec      character(8);
    ld_dateEjec      date;
  
  begin
  
    begin
      --fch RCC
      select pgfape into ld_dateEjec from FST017 Where Pgcod = 1;
    exception
      when others then
        ld_dateEjec := trunc(sysdate);
    end;
  
    lc_horaEjec := TO_CHAR(SYSDATE, 'HH:MI:SS');
  
    --ln_SegmntoActual := 1;
    SP_CR_SEGMNTOACTUAL(pn_instancia, ln_SegmntoActual);
  
    INSERT INTO aqpb084n
      (aqpb084nfech1,
       aqpb084nhora1,
       aqpb084ninst,
       aqpb084nfech,
       aqpb084nhora,
       aqpb084ngrup,
       aqpb084nfact)
      select ld_dateEjec,
             lc_horaEjec,
             aqpb084inst,
             aqpb084fech,
             aqpb084hora,
             aqpb084grup,
             aqpb084fact
        from aqpb084
       where aqpb084INST = pn_instancia
         and aqpb084GRUP in (11, 12, 14);
  
    delete from aqpb084
     where aqpb084INST = pn_instancia
       and aqpb084GRUP in (11, 12, 14);
    commit;
  
    if ln_SegmntoActual = 1 then
    
      for r in factores(ln_SegmntoActual) loop
        insert into aqpb084
          (aqpb084INST, aqpb084FECH, aqpb084HORA, aqpb084GRUP, aqpb084FACT)
        values
          (pn_instancia,
           ld_dateEjec,
           lc_horaEjec,
           r.aqpb084agrup,
           r.factor);
      
      end loop;
    
      for n in factores2(ln_SegmntoActual) loop
        insert into aqpb084
          (aqpb084INST, aqpb084FECH, aqpb084HORA, aqpb084GRUP, aqpb084FACT)
        values
          (pn_instancia, ld_dateEjec, lc_horaEjec, 14, n.factor);
      end loop;
    
    else
    
      for r in factoresCons(ln_SegmntoActual) loop
        insert into aqpb084
          (aqpb084INST, aqpb084FECH, aqpb084HORA, aqpb084GRUP, aqpb084FACT)
        values
          (pn_instancia,
           ld_dateEjec,
           lc_horaEjec,
           r.aqpb084agrup,
           r.factor);
      
      end loop;
    
      for n in factores3(ln_SegmntoActual) loop
        insert into aqpb084
          (aqpb084INST, aqpb084FECH, aqpb084HORA, aqpb084GRUP, aqpb084FACT)
        values
          (pn_instancia, ld_dateEjec, lc_horaEjec, 14, n.factor);
      end loop;
    
    end if;
  
    commit;
  exception
    when others then
      null;
  end SP_DEUINGRE;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
end PQ_CR_CALC_METSOBREEND_PYME;
/

