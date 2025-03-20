create or replace package PQ_CR_CALC_METSOBREEND_FIC is
  /* ************************************************************************************************************
     -- Nombre                     : PQ_CR_CALC_METSOBREEND_FIC
     -- Sistema                    : BANTOTAL
     -- Módulo                     : Metodología de sobreendeudamiento
   -- Descripción          : obtención de factores
     -- Versión                    : 1.0
     -- Fecha de Creación          : 
     -- Autor de Creación          : Cinthya Liz Hernández Ortega  
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 28/01/2020
     -- Autor de la Modificación   : Cinthya Liz Hernández Ortega  
     -- Descripción de Modificación: se elimino parametro number
   -- Fecha de Modificación      : 17/02/2020
     -- Autor de la Modificación   : Cinthya Liz Hernández Ortega  
     -- Descripción de Modificación: se cambiaron factores de metodologia
     --
  * *************************************************************************************************************/
  procedure SP_INICIO(pn_instancia  numeric,
                      pn_evaluacion numeric,
                      pn_cuenta     numeric,
                      pn_pais       numeric,
                      pn_tipdoc     numeric,
                      pv_numdoc     varchar2);

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
                                    pn_tipo      in numeric,
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
                                          pn_tipo      in numeric,
                                          pn_cuenta14  in out varchar2,
                                          pn_cuenta72  in out varchar2);

  procedure SP_CR_SEGMNTOACTUAL(ln_Instancia     number,
                                ln_SegmntoActual out number,
                                pn_pais          numeric,
                                pn_tipdoc        numeric,
                                pv_numdoc        varchar2);

  function FN_EQUIVALENCIADOC(p_tdoc number) return varchar2;

  procedure SP_EXISTEPANEL(pn_instancia number,
                           pn_segmento  number,
                           pb_flag      out number,
                           pd_fecprc    out date);

  procedure SP_BACKUP_AQPA030(pn_instancia number,
                              PD_FECHAEJE  DATE,
                              PC_HORA      CHARACTER);
  procedure SP_DEUINGRE(pn_instancia  numeric,
                        pn_evaluacion numeric,
                        pn_pais       numeric,
                        pn_tipdoc     numeric,
                        pv_numdoc     varchar2);
end PQ_CR_CALC_METSOBREEND_FIC;
/

create or replace package body PQ_CR_CALC_METSOBREEND_FIC is
--rmontesr 2021.03.08 se agrego rubr 0303 lineas 343.345.347.350.371.372.374.375.554.556.558.561.585.586.588.589.685.687.689.692.716.717.719.720
  procedure SP_INICIO(pn_instancia  numeric,
                      pn_evaluacion numeric,
                      pn_cuenta     numeric,
                      pn_pais       numeric,
                      pn_tipdoc     numeric,
                      pv_numdoc     varchar2) is
  
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
       where f.ctnro = pn_cuenta
      union
      select distinct g.rppais, g.rptdoc, (trim(g.rpndoc)) ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro = pn_cuenta
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and 1 = pn_flag
      union
      select distinct g.pepais, g.petdoc, (trim(g.pendoc)) ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro = pn_cuenta
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and 1 = pn_flag;
  
    cursor factores(pln_SegmntoActual numeric) is
      select AQPA030ainst,
             AQPA030agrup,
             sum(AQPA030asald),
             case
               when AQPA030agrup = 1 then
                0.044
               when AQPA030agrup = 2 then
                0.09
               when AQPA030agrup = 3 and sum(AQPA030asald) <= 30000 then
                0.0264
               when AQPA030agrup = 3 and sum(AQPA030asald) > 30000 then
                0.0222
               when AQPA030agrup = 4 and sum(AQPA030asald) <= 8000 then
                0.0514
               when AQPA030agrup = 4 and sum(AQPA030asald) <= 15000 then
                0.0356
               when AQPA030agrup = 4 and sum(AQPA030asald) <= 45000 then
                0.0282
               when AQPA030agrup = 4 and sum(AQPA030asald) > 45000 then
                0.0222
               when AQPA030agrup = 5 and sum(AQPA030asald) <= 10000 then
                0.0349
               when AQPA030agrup = 5 and sum(AQPA030asald) <= 20000 then
                0.0248
               when AQPA030agrup = 5 and sum(AQPA030asald) <= 30000 then
                0.0224
               when AQPA030agrup = 5 and sum(AQPA030asald) > 30000 then
                0.0205
               when AQPA030agrup = 6 then
                0.009
               when AQPA030agrup = 7 and sum(AQPA030asald) <= 8000 then
                0.0514
               when AQPA030agrup = 7 and sum(AQPA030asald) <= 15000 then
                0.0356
               when AQPA030agrup = 7 and sum(AQPA030asald) <= 45000 then
                0.0282
               when AQPA030agrup = 7 and sum(AQPA030asald) > 45000 then
                0.0222
             --when AQPA030agrup = 8 and pln_SegmntoActual = 1 then 0.044*0.02
             --when AQPA030agrup = 8 and pln_SegmntoActual = 2 then 0.044*0.03
               when AQPA030agrup = 9 then
                0.0017--17/02/2020 chernandez
               when AQPA030agrup = 10 then
                0
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 8000 then
                0.0514
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 15000 then
                0.0356
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 45000 then
                0.0282
               when AQPA030agrup = 11 and sum(AQPA030asald) > 45000 then
                0.0222
               when AQPA030agrup = 12 and sum(AQPA030asald) <= 8000 then
                0.0514
               when AQPA030agrup = 12 and sum(AQPA030asald) <= 15000 then
                0.0356
               when AQPA030agrup = 12 and sum(AQPA030asald) <= 45000 then
                0.0282
               when AQPA030agrup = 12 and sum(AQPA030asald) > 45000 then
                0.0222
               when AQPA030agrup = 13 and sum(AQPA030asald) <= 8000 then
                0.0514
               when AQPA030agrup = 13 and sum(AQPA030asald) <= 15000 then
                0.0356
               when AQPA030agrup = 13 and sum(AQPA030asald) <= 45000 then
                0.0282
               when AQPA030agrup = 13 and sum(AQPA030asald) > 45000 then
                0.0222
             end factor
        from AQPA030a
       where AQPA030ainst = pn_instancia
         and AQPA030agrup <> 8
       group by AQPA030ainst, AQPA030agrup
       order by AQPA030agrup;
  
    cursor factores2(pln_SegmntoActual numeric) is
      select case
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.04
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.23
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.25
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 > 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.32
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.04
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.25
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.29
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 > 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.34
             end factor
      
        from AQPA030b
       where AQPA030binst = pn_instancia
         and aqpa030btipo = 1
       group by AQPA030binst;
    cursor factores3(pln_SegmntoActual numeric) is
      select case
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 45 then
                0.09 * 0.03
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 65 then
                0.09 * 0.07
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 <= 85 then
                0.09 * 0.19
             
               when sum(AQPA030bsald) / sum(AQPA030bsalc) * 100 > 85 then
                0.09 * 0.38
             end factor
      
        from AQPA030b
       where AQPA030binst = pn_instancia
         and AQPA030btipo = 2   
         and REGEXP_LIKE(aqpa030bcuen, '^72.501|^72.502|^72.503|^72.504|^72.505|^72.4') -- mpostigoc 09/12/2021
             group by AQPA030binst;
  
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
    lc_numdoc        character(12);
  
  begin
    lc_numdoc := pv_numdoc;
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
    SP_CR_SEGMNTOACTUAL(pn_instancia,
                        ln_SegmntoActual,
                        pn_pais,
                        pn_tipdoc,
                        pv_numdoc);
  
    ln_flag := 1;
  
    /*if ln_SegmntoActual = 2 then
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
    end if;*/
    SP_BACKUP_AQPA030(pn_instancia, ld_dateEjec, lc_horaEjec);
    SP_EXISTEPANEL(pn_instancia, ln_SegmntoActual, lb_FlPnl, ld_FchRCCPnl);
  
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
          SP_RCC(pn_instancia,
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
      SP_DEUINGRE(pn_instancia,
                  pn_evaluacion,
                  pn_pais,
                  pn_tipdoc,
                  pv_numdoc);
    end loop;
    commit;
  
    --agrupamos AQPA030 de todos
    for r in factores(ln_SegmntoActual) loop
      insert into AQPA030
        (AQPA030INST, AQPA030FECH, AQPA030HORA, AQPA030GRUP, AQPA030FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, r.AQPA030agrup, r.factor);
    
    end loop;
  
    --calculo factor cuota potencial deuda RCC AQPA030B
    for n in factores2(ln_SegmntoActual) loop
      insert into AQPA030
        (AQPA030INST, AQPA030FECH, AQPA030HORA, AQPA030GRUP, AQPA030FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, 8, n.factor);
    end loop;
  
    for o in factores3(ln_SegmntoActual) loop
      insert into AQPA030
        (AQPA030INST, AQPA030FECH, AQPA030HORA, AQPA030GRUP, AQPA030FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, 15, o.factor);
    end loop;
    commit;
  
  end SP_INICIO;

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
               /*when REGEXP_LIKE(a.c_cuenta,
                                '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]130601|^14.[1-6]120601') then
                2*/
               when REGEXP_LIKE(a.c_cuenta, '^14.[1-6]030602|^14.[1-6]030302') then --se agrego rubro 0303
                3
               when REGEXP_LIKE(a.c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
                     REGEXP_LIKE(a.c_cuenta,
                                                                              '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                4
               when REGEXP_LIKE(a.c_cuenta,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
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
             /*cuentas*/
              REGEXP_LIKE(a.c_cuenta, '^14.[1-6]030602|^14.[1-6]030302') or --se agrego rubro 0303
              (REGEXP_LIKE(a.c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
               REGEXP_LIKE(a.c_cuenta,
                                                                         '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or --se agrego rubro 0303
              REGEXP_LIKE(a.c_cuenta, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or --se agrego rubro 0303
              REGEXP_LIKE(a.c_cuenta, '^14.[1-6]04') or
              (REGEXP_LIKE(a.c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(a.c_cuenta,
              '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
              REGEXP_LIKE(a.c_cuenta, '^71.[1-4]'))
              /*
              REGEXP_LIKE(a.c_cuenta,
                          '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]130601|^14.[1-6]120601')*/
       group by a.c_cuenta;
  
    cursor Lineas(ln_inst number, lv_codsbs varchar2) is
      select *
        from (select cuenta.*,
                     case
                     --chernandez 17/02/2020 modificacion de rubros
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
                from (select ff.AQPA030bcuen cuenta,
                             case
                               when substr(ff.AQPA030bcuen, 1, 2) = '14' then
                                sum(ff.AQPA030bsald)
                               else
                                sum(ff.AQPA030bsaln)
                             end saldo,
                             count(*) cant
                        from AQPA030B ff
                       where AQPA030bcsbs = lv_codsbs
                         and AQPA030binst = ln_inst
                       group by ff.AQPA030bcuen) cuenta)
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
  
    SP_OBTENER_LINEAS(pn_instancia,
                      pv_CodSBS,
                      pd_FchRCC,
                      pd_dateEjec,
                      pc_horaEjec);
    for e in CrediPym(pv_CodSBS, pd_FchRCC) loop
      insert into AQPA030A
        (AQPA030ainst,
         AQPA030acsbs,
         AQPA030acuen,
         AQPA030agrup,
         AQPA030atipo,
         AQPA030asald,
         AQPA030acont,
         AQPA030afpre,
         AQPA030atdoc,
         AQPA030andoc,
         AQPA030AFECH,
         AQPA030AHORA)
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
      insert into AQPA030A
        (AQPA030ainst,
         AQPA030acsbs,
         AQPA030acuen,
         AQPA030agrup,
         AQPA030atipo,
         AQPA030asald,
         AQPA030acont,
         AQPA030afpre,
         AQPA030atdoc,
         AQPA030andoc,
         AQPA030AFECH,
         AQPA030AHORA)
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
      insert into AQPA030A
        (AQPA030ainst,
         AQPA030acsbs,
         AQPA030acuen,
         AQPA030agrup,
         AQPA030atipo,
         AQPA030asald,
         AQPA030acont,
         AQPA030afpre,
         AQPA030atdoc,
         AQPA030andoc,
         AQPA030AFECH,
         AQPA030AHORA)
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
    
      select a.AQPA031rubr CUENTA,
             sum(AQPA031sdeu) SALDO,
             count(*) cant,
             case
               /*when REGEXP_LIKE(a.AQPA031rubr,
                                '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then
                2*/
               when REGEXP_LIKE(a.AQPA031rubr, '^14.[1-6]030602|^14.[1-6]030302') then--se agrego rubro 0303
                3
               when REGEXP_LIKE(a.AQPA031rubr, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
                     REGEXP_LIKE(a.AQPA031rubr,
                                                                                 '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                4
               when REGEXP_LIKE(a.AQPA031rubr,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                5
               when REGEXP_LIKE(a.AQPA031rubr, '^14.[1-6]04') then
                6
               when REGEXP_LIKE(a.AQPA031rubr,
                                '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
                     REGEXP_LIKE(a.AQPA031rubr,
                                                                                        '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then
                7
               when REGEXP_LIKE(a.AQPA031rubr, '^71.[1-4]') then
                9
               else
                0
             end GRUPO
        from AQPA031 a
       where AQPA031inst = ln_inst
         and AQPA031esta = 'S'
         and AQPA031dori = '1'
         and AQPA031chek = '1'
         and AQPA031flin = 'P'
         and AQPA031tdoc = ln_tdoc
         and AQPA031ndoc = lc_ndoc
         and (
             /*cuentas*/
              REGEXP_LIKE(a.AQPA031rubr, '^14.[1-6]030602|^14.[1-6]030302') or --se agrego rubro 0303
              (REGEXP_LIKE(a.AQPA031rubr, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
               REGEXP_LIKE(a.AQPA031rubr,
                                                                            '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or --se agrego rubro 0303
              REGEXP_LIKE(a.AQPA031rubr, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or --se agrego rubro 0303
              REGEXP_LIKE(a.AQPA031rubr, '^14.[1-6]04') or
              (REGEXP_LIKE(a.AQPA031rubr,
                           '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(a.AQPA031rubr,
                                                                                    '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
              REGEXP_LIKE(a.AQPA031rubr, '^71.[1-4]') /*or
              REGEXP_LIKE(a.AQPA031rubr,
                          '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')*/
              )
       group by a.AQPA031rubr;
  
    --panel pyme lineas
    cursor CrediPnlLine(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.AQPA031rubr CUENTA,
             sum(AQPA031util) SALDO,
             count(*) cant,
             case
       --chernandez 17/02/2020 2
               when REGEXP_LIKE(AQPA031rubr,
                              --  '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601'
                                '^14..020601|^14..130601|^14..120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') then
                2
               when REGEXP_LIKE(AQPA031rubr,
                                '^14..03|^14..02|^14..12|^14..13') then
                1       
               else
                0
             end GRUPO
        from AQPA031 a
       where AQPA031inst = ln_inst
         and AQPA031esta = 'S'
         and AQPA031dori = '1'
         and AQPA031chek = '1'
         and AQPA031flin = 'L'
         and AQPA031tdoc = ln_tdoc
         and AQPA031ndoc = lc_ndoc
          and (REGEXP_LIKE(AQPA031RUBR, '^14..03|^14..02|^14..12|^14..13') or
             (REGEXP_LIKE(AQPA031RUBR,
                           '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05'))
                           or (REGEXP_LIKE(AQPA031RUBR,
                           '^71.2|^71.3')) )
      /*and
      REGEXP_LIKE(AQPA031rubr, '^14..03')*/
       group by a.AQPA031rubr;
  
    --panel pyme lineas cuota potencial
    cursor CrePnlLineasPotencial(ln_inst number,
                                 ln_tdoc number,
                                 lc_ndoc character) is
      select aa.*, 
       rownum,case
             when REGEXP_LIKE(aa.AQPA031rubr,
                                '^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05') or
                    (REGEXP_LIKE(aa.AQPA031rubr, '^72.503|^71.2|^71.3') and
                     not
                      REGEXP_LIKE(aa.AQPA031rubr, '^72.5030202|^72.5030302')) then
                2
             
               when REGEXP_LIKE(aa.AQPA031rubr, '^14.[1-6]..02') or
                    REGEXP_LIKE(aa.AQPA031rubr, '^72.506') then
                1
               else
                0
             end tipo
        from AQPA031 aa
       where AQPA031inst = ln_inst
         and AQPA031esta = 'S'
         and AQPA031dori = '1'
         and AQPA031chek = '1'
         and AQPA031flin = 'L'
         and AQPA031tdoc = ln_tdoc
         and AQPA031ndoc = lc_ndoc;
  
    --panel pyme deuda ingresada
    cursor CrePnlIngre(ln_inst number, ln_tdoc number, lc_ndoc character) is
    
      select 'NO REGUL' CUENTA,
             sum(AQPA031sdeu) SALDO,
             count(*) cant,
             13 GRUPO
        from AQPA031 a
       where AQPA031inst = ln_inst
         and AQPA031esta = 'S'
         and AQPA031dori = '2'
         and AQPA031chek = '1'
         and AQPA031tdoc = ln_tdoc
         and AQPA031ndoc = lc_ndoc
       group by a.AQPA031rubr;
  
    --panel consumo creditos
    cursor PnlConsumo(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.AQPA032rubr CUENTA,
             sum(AQPA032sdeu) SALDO,
             count(*) cant,
             case
               /*when REGEXP_LIKE(a.AQPA032rubr,
                                '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then
                2*/
               when REGEXP_LIKE(a.AQPA032rubr, '^14.[1-6]030602|^14.[1-6]030302') then --se agrego rubro 0303
                3
               when REGEXP_LIKE(a.AQPA032rubr, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
                     REGEXP_LIKE(a.AQPA032rubr,
                                                                                 '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                4
               when REGEXP_LIKE(a.AQPA032rubr,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') then --se agrego rubro 0303
                5
               when REGEXP_LIKE(a.AQPA032rubr, '^14.[1-6]04') then
                6
               when REGEXP_LIKE(a.AQPA032rubr,
                                '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
                     REGEXP_LIKE(a.AQPA032rubr,
                                                                                        '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then
                7
               when REGEXP_LIKE(a.AQPA032rubr, '^71.[1-4]') then
                9
               else
                0
             end GRUPO
        from AQPA032 a
       where AQPA032inst = ln_inst
         and AQPA032esta = 'S'
         and AQPA032dori = '1'
         and AQPA032chek = '1'
         and AQPA032flin = 'P'
         and AQPA032tdoc = ln_tdoc
         and AQPA032ndoc = lc_ndoc
         and (
             /*cuentas*/
              REGEXP_LIKE(a.AQPA032rubr, '^14.[1-6]030602|^14.[1-6]030302') or --se agrego rubro 0303
              (REGEXP_LIKE(a.AQPA032rubr, '^14.[1-6]0306|^14.[1-6]0303') and not --se agrego rubro 0303
               REGEXP_LIKE(a.AQPA032rubr,
                                                                            '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or --se agrego rubro 0303
              REGEXP_LIKE(a.AQPA032rubr, '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or --se agrego rubro 0303
              REGEXP_LIKE(a.AQPA032rubr, '^14.[1-6]04') or
              (REGEXP_LIKE(a.AQPA032rubr,
                           '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(a.AQPA032rubr,
                                                                                    '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
              REGEXP_LIKE(a.AQPA032rubr, '^71.[1-4]') 
        /*or REGEXP_LIKE(a.AQPA032rubr,
                          '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')*/
               )
       group by a.AQPA032rubr;
  
    --panel consumo lineas
    cursor PnlConsLine(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.AQPA032rubr CUENTA,
             sum(AQPA032util) SALDO,
             count(*) cant,
             case
               when REGEXP_LIKE(AQPA032rubr, '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') then
                2
             
               when REGEXP_LIKE(AQPA032rubr, '^14..03|^14..02|^14..12|^14..13') then
                1   
             --when REGEXP_LIKE(cuenta, '^72.5') then 8 
               else
                0
             end GRUPO
        from AQPA032 a
       where AQPA032inst = ln_inst
         and AQPA032esta = 'S'
         and AQPA032dori = '1'
         and AQPA032chek = '1'
         and AQPA032flin = 'L'
         and AQPA032tdoc = ln_tdoc
         and AQPA032ndoc = lc_ndoc
         and (REGEXP_LIKE(a.AQPA032rubr, '^14..03|^14..02|^14..12|^14..13') or
             (REGEXP_LIKE(a.AQPA032rubr,
                           '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3')))
      /*and
      REGEXP_LIKE(AQPA032rubr, '^14..03')*/
       group by a.AQPA032rubr;
  
    --panel consumo lineas cuota potencial
    cursor PnlConsLineasPotencial(ln_inst number,
                                  ln_tdoc number,
                                  lc_ndoc character) is
      select aa.*,
             rownum,
             case
         when REGEXP_LIKE(aa.AQPA032rubr,
                                '^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') or
                    (REGEXP_LIKE(aa.AQPA032rubr, '^72.503') and
                     not
                      REGEXP_LIKE(aa.AQPA032rubr, '^72.5030202|^72.5030302')) then
                2
               when REGEXP_LIKE(aa.AQPA032rubr, '^14.[1-6]..02') or
                    REGEXP_LIKE(aa.AQPA032rubr, '^72.506') then
                1
               
               else
                0
             end tipo
        from AQPA032 aa
       where AQPA032inst = ln_inst
         and AQPA032esta = 'S'
         and AQPA032dori = '1'
         and AQPA032chek = '1'
         and AQPA032flin = 'L'
         and AQPA032tdoc = ln_tdoc
         and AQPA032ndoc = lc_ndoc;
  
    --panel consumo deuda ingresada
    cursor PnlConsumoIngre(ln_inst number,
                           ln_tdoc number,
                           lc_ndoc character) is
    
      select 'NO REGUL' CUENTA,
             sum(AQPA032sdeu) SALDO,
             count(*) cant,
             13 GRUPO
        from AQPA032 a
       where AQPA032inst = ln_inst
         and AQPA032esta = 'S'
         and AQPA032dori = '2'
         and AQPA032chek = '1'
         and AQPA032tdoc = ln_tdoc
         and AQPA032ndoc = lc_ndoc
       group by a.AQPA032rubr;
    lv_empresa varchar(5);
  begin
    if pn_segmento = 1 then
      --calculo de líneas completas AQPA030B
      for ggg in CrePnlLineasPotencial(pn_instancia, pn_tdoc, pc_ndoc) loop
        lv_empresa := trim(to_char(nvl(ggg.AQPA031CENT, ggg.rownum)));
        INSERT INTO AQPA030B
          (AQPA030binst,
           AQPA030bcsbs,
           AQPA030bcemp,
           AQPA030bcuen,
           AQPA030bsald,
           AQPA030bsalc,
           AQPA030bsaln,
           AQPA030BFPRE,
           AQPA030bhora,
           AQPA030bfech,
           AQPA030butil,
           aqpa030btipo)
        VALUES
          (pn_instancia,
           substr(trim(pc_ndoc), 1, 10), --mod@abr 20190801
           substr(lv_empresa, 1, 5),
           ggg.AQPA031rubr,
           ggg.AQPA031util,
           ggg.AQPA031util + ggg.AQPA031aux8,
           ggg.AQPA031aux8,
           ggg.AQPA031frcc,
           pc_horaEjec,
           pd_dateEjec,
           0,
           ggg.tipo);
      end loop;
    
      for e in CrediPnl(pn_instancia, pn_tdoc, pc_ndoc) loop
        insert into AQPA030A
          (AQPA030ainst,
           AQPA030acsbs,
           AQPA030acuen,
           AQPA030agrup,
           AQPA030atipo,
           AQPA030asald,
           AQPA030acont,
           AQPA030afpre,
           AQPA030atdoc,
           AQPA030andoc,
           AQPA030AFECH,
           AQPA030AHORA)
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
        insert into AQPA030A
          (AQPA030ainst,
           AQPA030acsbs,
           AQPA030acuen,
           AQPA030agrup,
           AQPA030atipo,
           AQPA030asald,
           AQPA030acont,
           AQPA030afpre,
           AQPA030atdoc,
           AQPA030andoc,
           AQPA030AFECH,
           AQPA030AHORA)
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
        insert into AQPA030A
          (AQPA030ainst,
           AQPA030acsbs,
           AQPA030acuen,
           AQPA030agrup,
           AQPA030atipo,
           AQPA030asald,
           AQPA030acont,
           AQPA030afpre,
           AQPA030atdoc,
           AQPA030andoc,
           AQPA030AFECH,
           AQPA030AHORA)
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
        insert into AQPA030A
          (AQPA030ainst,
           AQPA030acsbs,
           AQPA030acuen,
           AQPA030agrup,
           AQPA030atipo,
           AQPA030asald,
           AQPA030acont,
           AQPA030afpre,
           AQPA030atdoc,
           AQPA030andoc,
           AQPA030AFECH,
           AQPA030AHORA)
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
        insert into AQPA030A
          (AQPA030ainst,
           AQPA030acsbs,
           AQPA030acuen,
           AQPA030agrup,
           AQPA030atipo,
           AQPA030asald,
           AQPA030acont,
           AQPA030afpre,
           AQPA030atdoc,
           AQPA030andoc,
           AQPA030AFECH,
           AQPA030AHORA)
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
        insert into AQPA030A
          (AQPA030ainst,
           AQPA030acsbs,
           AQPA030acuen,
           AQPA030agrup,
           AQPA030atipo,
           AQPA030asald,
           AQPA030acont,
           AQPA030afpre,
           AQPA030atdoc,
           AQPA030andoc,
           AQPA030AFECH,
           AQPA030AHORA)
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
        lv_empresa := trim(to_char(nvl(ggg.AQPA032CENT, ggg.rownum)));
        INSERT INTO AQPA030B
          (AQPA030binst,
           AQPA030bcsbs,
           AQPA030bcemp,
           AQPA030bcuen,
           AQPA030bsald,
           AQPA030bsalc,
           AQPA030bsaln,
           AQPA030BFPRE,
           AQPA030bhora,
           AQPA030bfech,
           AQPA030butil,
           AQPA030btipo)
        VALUES
          (pn_instancia,
           substr(trim(pc_ndoc), 1, 10), --mod@abr 20190801
           substr(lv_empresa, 1, 5),
           ggg.AQPA032rubr,
           ggg.AQPA032util,
           ggg.AQPA032util + ggg.AQPA032aux8,
           ggg.AQPA032aux8,
           ggg.AQPA032frcc,
           pc_horaEjec,
           pd_dateEjec,
           0,
           ggg.tipo);
      end loop;
    
    end if;
    commit;
  
  end SP_PANELSD;

  procedure SP_OBTENER_LINEAS(pn_instancia numeric,
                              pv_codsbs    varchar2,
                              pd_fec       date,
                              pd_dateEjec  date,
                              pc_horaEjec  character) is
  
    cursor lineas1 is --chernandez 28/01/2020
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
                 and REGEXP_LIKE(a.c_cuenta, '^72.506')
              
               group by substr(a.c_cuenta, 1, 2),
                        a.c_codemp,
                        substr(a.c_cuenta, 7, 2),
                        substr(a.c_cuenta, 3, 1)
              
              )
      
       order by c_codemp, TIPCRE, MON;
  
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
  ln_entro     numeric(5);
  
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
  ln_entro     := 0;
  
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
                              1,
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
                                    1,
                                    ln_cuenta14,
                                    ln_cuenta72);
    end if;
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
                                    pn_tipo      in numeric,
                                    pn_cuenta14  in out varchar2,
                                    pn_cuenta72  in out varchar2,
                                    pn_cuenta81  in out varchar2) is
    pn_cuenta    varchar2(14);
    pn_cuentadol varchar2(14);
    pv_tipo72    varchar2(2);
    pv_tipo14    varchar2(4);--chernandez 17/02/2020 2      
  begin
    if pn_tipo = 1 then
      pv_tipo72 := '06';
      pv_tipo14 := '';
    End if;
    if pn_tipo = 2 then
      pv_tipo72 := '03';
      pv_tipo14 := '0601';
    End if;
    if pc_codent <> pc_codentANT or pn_tipcre <> pn_tipcreANT then
      pn_cuenta    := '';
      pn_cuentadol := '';
      if pn_saldo14 <> 0 and pn_saldo72 <> 0 then
        pn_saldo81 := pn_saldo14 + pn_saldo72;
        pn_cuenta  := pn_cuenta14 || '1.' ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14;--chernandez 17/02/2020 2
      end if;
    
      if pn_saldo14 = 0 and pn_saldo72 <> 0 then
        pn_saldo81 := pn_saldo72;
        pn_cuenta  := pn_cuenta72 || '15' || pv_tipo72 ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0'));
      end if;
    
      if pn_saldo14 <> 0 and pn_saldo72 = 0 then
        pn_saldo81 := pn_saldo14;
        pn_cuenta  := pn_cuenta14 || '1.' ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14;--chernandez 17/02/2020 2
      end if;
    
      if pn_saldoD14 <> 0 and pn_saldoD72 <> 0 then
        pn_saldoD81  := pn_saldoD14 + pn_saldoD72;
        pn_cuentadol := pn_cuenta14 || '2.' ||
                        trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14;--chernandez 17/02/2020 2
      end if;
    
      if pn_saldoD14 = 0 and pn_saldoD72 <> 0 then
        pn_saldoD81  := pn_saldoD72;
        pn_cuentadol := pn_cuenta72 || '25' || pv_tipo72 ||
                        trim(lpad(to_char(pn_tipcreANT), 2, '0'));
      end if;
    
      if pn_saldoD14 <> 0 and pn_saldoD72 = 0 then
        pn_saldoD81  := pn_saldoD14;
        pn_cuentadol := pn_cuenta14 || '2.' ||
                        trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14;--chernandez 17/02/2020 2
      end if;
    
      if pn_saldo14 <> 0 or pn_saldo72 <> 0 then
        --insertamos tabla auxiliar
        INSERT INTO AQPA030B
          (AQPA030binst,
           AQPA030bcsbs,
           AQPA030bcemp,
           AQPA030bcuen,
           AQPA030bsald,
           AQPA030bsalc,
           AQPA030bsaln,
           AQPA030bfpre,
           AQPA030bhora,
           AQPA030bfech,
           AQPA030butil,
           aqpa030btipo)
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
           pn_tipo);
      end if;
    
      if pn_saldod14 <> 0 or pn_saldod72 <> 0 then
        --insertamos tabla auxiliar
        INSERT INTO AQPA030B
          (AQPA030binst,
           AQPA030bcsbs,
           AQPA030bcemp,
           AQPA030bcuen,
           AQPA030bsald,
           AQPA030bsalc,
           AQPA030bsaln,
           AQPA030BFPRE,
           AQPA030bhora,
           AQPA030bfech,
           AQPA030butil,
           aqpa030btipo)
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
           pn_tipo);
      
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
                                          pn_tipo      in numeric,  
                                          pn_cuenta14  in out varchar2,
                                          pn_cuenta72  in out varchar2) is
  
    pn_cuenta    varchar2(14);
    pn_cuentadol varchar2(14);
    pv_tipo72    varchar2(2);
    pv_tipo14    varchar2(4);--chernandez 17/02/2020
  begin
    if pn_tipo = 1 then
      pv_tipo72 := '06';
      pv_tipo14 := '';--chernandez 17/02/2020 2
    End if;
    if pn_tipo = 2 then
      pv_tipo72 := '03';
      pv_tipo14 := '0601';--chernandez 17/02/2020 2
    End if;
    pn_cuenta    := '';
    pn_cuentadol := '';
    if pn_saldo14 <> 0 and pn_saldo72 <> 0 then
      pn_saldo81 := pn_saldo14 + pn_saldo72;
      pn_cuenta  := pn_cuenta14 || '1.' ||
                    trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14;--chernandez 17/02/2020 2
    end if;
  
    if pn_saldo14 = 0 and pn_saldo72 <> 0 then
      pn_saldo81 := pn_saldo72;
      pn_cuenta  := pn_cuenta72 || '15' || pv_tipo72 ||
                    trim(lpad(to_char(pn_tipcreANT), 2, '0'));
    end if;
  
    if pn_saldo14 <> 0 and pn_saldo72 = 0 then
      pn_saldo81 := pn_saldo14;
      pn_cuenta  := pn_cuenta14 || '1.' ||
                    trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14;--chernandez 17/02/2020 2
    end if;
  
    if pn_saldoD14 <> 0 and pn_saldoD72 <> 0 then
      pn_saldoD81  := pn_saldoD14 + pn_saldoD72;
      pn_cuentadol := pn_cuenta14 || '2.' ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14;--chernandez 17/02/2020 2
    end if;
  
    if pn_saldoD14 = 0 and pn_saldoD72 <> 0 then
      pn_saldoD81  := pn_saldoD72;
      pn_cuentadol := pn_cuenta72 || '25' || pv_tipo72 ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0'));
    end if;
  
    if pn_saldoD14 <> 0 and pn_saldoD72 = 0 then
      pn_saldoD81  := pn_saldoD14;
      pn_cuentadol := pn_cuenta14 || '2.' ||
                      trim(lpad(to_char(pn_tipcreANT), 2, '0')) || pv_tipo14;--chernandez 17/02/2020 2
    end if;
  
    if pn_saldo14 <> 0 or pn_saldo72 <> 0 then
      --insertamos tabla auxiliar
      INSERT INTO AQPA030B
        (AQPA030binst,
         AQPA030bcsbs,
         AQPA030bcemp,
         AQPA030bcuen,
         AQPA030bsald,
         AQPA030bsalc,
         AQPA030bsaln,
         AQPA030bfpre,
         AQPA030bhora,
         AQPA030bfech,
         AQPA030butil,
         aqpa030btipo)
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
         pn_tipo);
    end if;
  
    if pn_saldod14 <> 0 or pn_saldod72 <> 0 then
      --insertamos tabla auxiliar
      INSERT INTO AQPA030B
        (AQPA030binst,
         AQPA030bcsbs,
         AQPA030bcemp,
         AQPA030bcuen,
         AQPA030bsald,
         AQPA030bsalc,
         AQPA030bsaln,
         AQPA030BFPRE,
         AQPA030bhora,
         AQPA030bfech,
         AQPA030butil,
         aqpa030btipo)
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
         pn_tipo);
    
    End If;
  
  end SP_OBTENER_SALDO_LINEAS_ULTEJ;

  procedure SP_CR_SEGMNTOACTUAL(ln_Instancia     number,
                                ln_SegmntoActual out number,
                                pn_pais          numeric,
                                pn_tipdoc        numeric,
                                pv_numdoc        varchar2) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_nrodoc char(12);
  
  begin
  
    begin
      ln_pais   := pn_pais;
      ln_tdoc   := pn_tipdoc;
      lc_nrodoc := pv_numdoc;
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

  procedure SP_EXISTEPANEL(pn_instancia number,
                           pn_segmento  number,
                           pb_flag      out number,
                           pd_fecprc    out date) is
  
  begin
    pb_flag   := 0;
    pd_fecprc := null;
    if pn_segmento = 1 then
      begin
        select AQPA031FRCC, 1
          into pd_fecprc, pb_flag
          from AQPA031
         where AQPA031inst = pn_instancia
           and AQPA031esta = 'S'
              --and AQPA031dori = '1'
           and rownum = 1;
      exception
        when no_data_found then
          pb_flag := 0;
      end;
    else
      begin
        select AQPA032frcc, 1
          into pd_fecprc, pb_flag
          from AQPA032
         where AQPA032inst = pn_instancia
           and AQPA032esta = 'S'
              --and AQPA032dori = '1'
           and rownum = 1;
      exception
        when no_data_found then
          pb_flag := 0;
      end;
    end if;
  
  end SP_EXISTEPANEL;

  procedure SP_BACKUP_AQPA030(pn_instancia number,
                              PD_FECHAEJE  DATE,
                              PC_HORA      CHARACTER) is
  
  begin
  
    INSERT INTO AQPA030L
      (AQPA030lfech1,
       AQPA030lhora1,
       AQPA030linst,
       AQPA030lcsbs,
       AQPA030lcuen,
       AQPA030lgrup,
       AQPA030ltipo,
       AQPA030lsald,
       AQPA030lcont,
       AQPA030lfpre,
       AQPA030ltdoc,
       AQPA030lndoc,
       AQPA030lfech,
       AQPA030lhora)
      select PD_FECHAEJE,
             PC_HORA,
             AQPA030ainst,
             AQPA030acsbs,
             AQPA030acuen,
             AQPA030agrup,
             AQPA030atipo,
             AQPA030asald,
             AQPA030acont,
             AQPA030afpre,
             AQPA030atdoc,
             AQPA030andoc,
             AQPA030afech,
             AQPA030ahora
        from AQPA030A
       where AQPA030AINST = pn_instancia;
  
    DELETE FROM AQPA030A where AQPA030AINST = pn_instancia;
  
    INSERT INTO AQPA030M
      (AQPA030mfech1,
       AQPA030mhora1,
       AQPA030minst,
       AQPA030mcsbs,
       AQPA030mcemp,
       AQPA030mcuen,
       AQPA030msald,
       AQPA030msalc,
       AQPA030msaln,
       AQPA030mbfpre,
       AQPA030mfech,
       AQPA030mhora)
      select PD_FECHAEJE,
             PC_HORA,
             AQPA030binst,
             AQPA030bcsbs,
             AQPA030bcemp,
             AQPA030bcuen,
             AQPA030bsald,
             AQPA030bsalc,
             AQPA030bsaln,
             AQPA030bfpre,
             AQPA030bfech,
             AQPA030bhora
        from AQPA030B
       where AQPA030BINST = pn_instancia;
  
    DELETE FROM AQPA030B where AQPA030BINST = pn_instancia;
  
    INSERT INTO AQPA030N
      (AQPA030nfech1,
       AQPA030nhora1,
       AQPA030ninst,
       AQPA030nfech,
       AQPA030nhora,
       AQPA030ngrup,
       AQPA030nfact)
      select PD_FECHAEJE,
             PC_HORA,
             AQPA030inst,
             AQPA030fech,
             AQPA030hora,
             AQPA030grup,
             AQPA030fact
        from AQPA030
       where AQPA030INST = pn_instancia;
  
    DELETE FROM AQPA030 where AQPA030INST = pn_instancia;
  
    COMMIT;
  end SP_BACKUP_AQPA030;

  procedure SP_DEUINGRE(pn_instancia  numeric,
                        pn_evaluacion numeric,
                        pn_pais       numeric,
                        pn_tipdoc     numeric,
                        pv_numdoc     varchar2) is
  
    cursor factores(pln_SegmntoActual numeric) is
      select AQPA030agrup,
             case
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 8000 then
                0.0514
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 15000 then
                0.0356
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 45000 then
                0.0282
               when AQPA030agrup = 11 and sum(AQPA030asald) > 45000 then
                0.0222
               when AQPA030agrup = 12 then
                0.09
             end factor
        from (select case
                       when AQPA034txt2 =
                            'Prestamo                                ' then
                        sum(AQPA034mto1)
                       else
                        sum(AQPA034mto4)
                     end AQPA030asald,
                     
                     case
                       when AQPA034txt2 =
                            'Prestamo                                ' then
                        11
                       else
                        12
                     end AQPA030agrup,
                     pn_instancia instancia
              
                from AQPA034
               where AQPA034eval = pn_evaluacion
               group by AQPA034eval, AQPA034txt2)
       group by AQPA030agrup;
  
    cursor factoresCons(pln_SegmntoActual numeric) is
      select AQPA030agrup,
             case
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 8000 then
                0.0514
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 15000 then
                0.0356
               when AQPA030agrup = 11 and sum(AQPA030asald) <= 45000 then
                0.0282
               when AQPA030agrup = 11 and sum(AQPA030asald) > 45000 then
                0.0222
               when AQPA030agrup = 12 then
                0.09
             end factor
        from (select case
                       when AQPA035txt2 =
                            'Prestamo                                ' then
                        sum(AQPA035mto1)
                       else
                        sum(AQPA035mto4)
                     end AQPA030asald,
                     
                     case
                       when AQPA035txt2 =
                            'Prestamo                                ' then
                        11
                       else
                        12
                     end AQPA030agrup,
                     pn_instancia instancia
              
                from AQPA035
               where AQPA035eval = pn_evaluacion
               group by AQPA035eval, AQPA035txt2)
       group by AQPA030agrup;
  
    cursor factores2(pln_SegmntoActual numeric) is
      select case
               when sum(AQPA034mto4) / sum(AQPA030bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.02
             
               when sum(AQPA034mto4) / sum(AQPA030bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.09
             
               when sum(AQPA034mto4) / sum(AQPA030bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.11
             
               when sum(AQPA034mto4) / sum(AQPA030bsalc) * 100 > 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.21
             
               when sum(AQPA034mto4) / sum(AQPA030bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.03
             
               when sum(AQPA034mto4) / sum(AQPA030bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.07
             
               when sum(AQPA034mto4) / sum(AQPA030bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.12
             
               when sum(AQPA034mto4) / sum(AQPA030bsalc) * 100 > 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.25
             end factor
      
        from (select AQPA034mto4,
                     AQPA034mto3 + AQPA034mto4 AQPA030bsalc,
                     AQPA034eval
                from AQPA034
               where AQPA034eval = pn_evaluacion
                 and AQPA034txt2 =
                     'Linea                                   '
                 and (AQPA034mto3 + AQPA034mto4) <> 0)
       group by AQPA034eval;
  
    cursor factores3(pln_SegmntoActual numeric) is
      select --sum(AQPA035mto4)/sum(mtotot)*100 
       case
         when sum(AQPA035mto4) / sum(AQPA030bsalc) * 100 <= 45 and
              pln_SegmntoActual = 1 then
          0.044 * 0.02
       
         when sum(AQPA035mto4) / sum(AQPA030bsalc) * 100 <= 65 and
              pln_SegmntoActual = 1 then
          0.044 * 0.09
       
         when sum(AQPA035mto4) / sum(AQPA030bsalc) * 100 <= 85 and
              pln_SegmntoActual = 1 then
          0.044 * 0.11
       
         when sum(AQPA035mto4) / sum(AQPA030bsalc) * 100 > 85 and
              pln_SegmntoActual = 1 then
          0.044 * 0.21
       
         when sum(AQPA035mto4) / sum(AQPA030bsalc) * 100 <= 45 and
              pln_SegmntoActual = 2 then
          0.044 * 0.03
       
         when sum(AQPA035mto4) / sum(AQPA030bsalc) * 100 <= 65 and
              pln_SegmntoActual = 2 then
          0.044 * 0.07
       
         when sum(AQPA035mto4) / sum(AQPA030bsalc) * 100 <= 85 and
              pln_SegmntoActual = 2 then
          0.044 * 0.12
       
         when sum(AQPA035mto4) / sum(AQPA030bsalc) * 100 > 85 and
              pln_SegmntoActual = 2 then
          0.044 * 0.25
       end factor
      
        from (select AQPA035mto4,
                     AQPA035mto3 + AQPA035mto4 AQPA030bsalc,
                     AQPA035eval
                from AQPA035
               where AQPA035eval = pn_evaluacion
                 and AQPA035txt2 =
                     'Linea                                   '
                 and (AQPA035mto3 + AQPA035mto4) <> 0)
       group by AQPA035eval;
  
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
    SP_CR_SEGMNTOACTUAL(pn_instancia,
                        ln_SegmntoActual,
                        pn_pais,
                        pn_tipdoc,
                        pv_numdoc);
  
    INSERT INTO AQPA030N
      (AQPA030nfech1,
       AQPA030nhora1,
       AQPA030ninst,
       AQPA030nfech,
       AQPA030nhora,
       AQPA030ngrup,
       AQPA030nfact)
      select ld_dateEjec,
             lc_horaEjec,
             AQPA030inst,
             AQPA030fech,
             AQPA030hora,
             AQPA030grup,
             AQPA030fact
        from AQPA030
       where AQPA030INST = pn_instancia
         and AQPA030GRUP in (11, 12, 14);
  
    delete from AQPA030
     where AQPA030INST = pn_instancia
       and AQPA030GRUP in (11, 12, 14);
    commit;
  
    if ln_SegmntoActual = 1 then
    
      for r in factores(ln_SegmntoActual) loop
        insert into AQPA030
          (AQPA030INST, AQPA030FECH, AQPA030HORA, AQPA030GRUP, AQPA030FACT)
        values
          (pn_instancia,
           ld_dateEjec,
           lc_horaEjec,
           r.AQPA030agrup,
           r.factor);
      
      end loop;
    
      for n in factores2(ln_SegmntoActual) loop
        insert into AQPA030
          (AQPA030INST, AQPA030FECH, AQPA030HORA, AQPA030GRUP, AQPA030FACT)
        values
          (pn_instancia, ld_dateEjec, lc_horaEjec, 14, n.factor);
      end loop;
    
    else
    
      for r in factoresCons(ln_SegmntoActual) loop
        insert into AQPA030
          (AQPA030INST, AQPA030FECH, AQPA030HORA, AQPA030GRUP, AQPA030FACT)
        values
          (pn_instancia,
           ld_dateEjec,
           lc_horaEjec,
           r.AQPA030agrup,
           r.factor);
      
      end loop;
    
      for n in factores3(ln_SegmntoActual) loop
        insert into AQPA030
          (AQPA030INST, AQPA030FECH, AQPA030HORA, AQPA030GRUP, AQPA030FACT)
        values
          (pn_instancia, ld_dateEjec, lc_horaEjec, 14, n.factor);
      end loop;
    
    end if;
  
    commit;
  exception
    when others then
      null;
  end SP_DEUINGRE;

end PQ_CR_CALC_METSOBREEND_FIC;
/

