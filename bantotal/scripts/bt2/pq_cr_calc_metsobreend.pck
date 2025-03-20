create or replace package PQ_CR_CALC_METSOBREEND is

  /* ************************************************************************************************************
  -- Nombre                     : PQ_CR_CALC_METSOBREEND
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
  -- Fecha de Modificación      : 30/01/2024
  -- Autor de la Modificación   : Maria Caridad Postigo Condori  
  -- Descripción de Modificación: Se agregaron rubros para el grupo 15
  -- Fecha de Modificación      : 11/07/2024
  -- Autor de la Modificación   : Maria Caridad Postigo Condori  
  -- Descripción de Modificación: Se Modifico la logica de como obtener la deuda no regulada segun los cambios realizados
                                  en las tramas que envian para Experian.
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
end PQ_CR_CALC_METSOBREEND;
/

create or replace package body PQ_CR_CALC_METSOBREEND is
  --rmontes 2021.03.08 modifiaciones rubro 0303 lineas 337.339.341.344.365.366.368.369.551.553.555.558.582.583.585.586.687.689.691.694.718.719.721.722
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
  
    cursor factores(pln_SegmntoActual numeric) is
      select aqpa024ainst,
             aqpa024agrup,
             sum(aqpa024asald),
             case
               when aqpa024agrup = 1 then
                0.044
               when aqpa024agrup = 2 then
                0.09
               when aqpa024agrup = 3 and sum(aqpa024asald) <= 30000 then
                0.0264
               when aqpa024agrup = 3 and sum(aqpa024asald) > 30000 then
                0.0222
               when aqpa024agrup = 4 and sum(aqpa024asald) <= 8000 then
                0.0514
               when aqpa024agrup = 4 and sum(aqpa024asald) <= 15000 then
                0.0356
               when aqpa024agrup = 4 and sum(aqpa024asald) <= 45000 then
                0.0282
               when aqpa024agrup = 4 and sum(aqpa024asald) > 45000 then
                0.0222
               when aqpa024agrup = 5 and sum(aqpa024asald) <= 10000 then
                0.0349
               when aqpa024agrup = 5 and sum(aqpa024asald) <= 20000 then
                0.0248
               when aqpa024agrup = 5 and sum(aqpa024asald) <= 30000 then
                0.0224
               when aqpa024agrup = 5 and sum(aqpa024asald) > 30000 then
                0.0205
               when aqpa024agrup = 6 then
                0.009
               when aqpa024agrup = 7 and sum(aqpa024asald) <= 8000 then
                0.0514
               when aqpa024agrup = 7 and sum(aqpa024asald) <= 15000 then
                0.0356
               when aqpa024agrup = 7 and sum(aqpa024asald) <= 45000 then
                0.0282
               when aqpa024agrup = 7 and sum(aqpa024asald) > 45000 then
                0.0222
             --when aqpa024agrup = 8 and pln_SegmntoActual = 1 then 0.044*0.02
             --when aqpa024agrup = 8 and pln_SegmntoActual = 2 then 0.044*0.03
               when aqpa024agrup = 9 then
                0.0017 --17/02/2020 chernandez
               when aqpa024agrup = 10 then
                0
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 8000 then
                0.0514
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 15000 then
                0.0356
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 45000 then
                0.0282
               when aqpa024agrup = 11 and sum(aqpa024asald) > 45000 then
                0.0222
               when aqpa024agrup = 12 and sum(aqpa024asald) <= 8000 then
                0.0514
               when aqpa024agrup = 12 and sum(aqpa024asald) <= 15000 then
                0.0356
               when aqpa024agrup = 12 and sum(aqpa024asald) <= 45000 then
                0.0282
               when aqpa024agrup = 12 and sum(aqpa024asald) > 45000 then
                0.0222
               when aqpa024agrup = 13 and sum(aqpa024asald) <= 8000 then
                0.0514
               when aqpa024agrup = 13 and sum(aqpa024asald) <= 15000 then
                0.0356
               when aqpa024agrup = 13 and sum(aqpa024asald) <= 45000 then
                0.0282
               when aqpa024agrup = 13 and sum(aqpa024asald) > 45000 then
                0.0222
             end factor
        from aqpa024a
       where aqpa024ainst = pn_instancia
         and aqpa024agrup <> 8
       group by aqpa024ainst, aqpa024agrup
       order by aqpa024agrup;
  
    cursor factores2(pln_SegmntoActual numeric) is
    --chernandez 17/02/2020 cambio de factores
      select case
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 5 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.06
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 25 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.07
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 45 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.23
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 65 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.38
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.44
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 >= 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.48
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 5 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.05
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 25 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.07
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 45 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.21
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 65 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.35
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.46
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 >= 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.52
             end factor
      
        from aqpa024b
       where aqpa024binst = pn_instancia
         and aqpa024btipo = 1
       group by aqpa024binst;
  
    --chernandez 17/02/2020
    cursor factores3(pln_SegmntoActual numeric) is
      select case
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 45 then
                0.09 * 0.02
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 65 then
                0.09 * 0.17
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 < 85 then
                0.09 * 0.29
             
               when sum(aqpa024bsald) / sum(aqpa024bsalc) * 100 >= 85 then
                0.09 * 0.50
             end factor
        from aqpa024b
       where aqpa024binst = pn_instancia
         and aqpa024btipo = 2
         and REGEXP_LIKE(aqpa024bcuen,
                         '^72.501|^72.502|^72.503|^72.504|^72.505|^72.4|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05') -- mpostigoc 30/01/2024
       group by aqpa024binst;
  
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
    ln_EsSupEmpr     number;
  
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
    SP_CR_SEGMNTOACTUAL(pn_instancia, ln_SegmntoActual);
  
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
    
    else
      if ln_SegmntoActual = 1 then
        -- PRY6415 Mpostigoc 21.08.2023
        begin
          select count(*)
            into ln_EsSupEmpr
            from fst004 f
           where (f.modulo, f.totope) in
                 (select x.xwfmodulo, x.xwftipope
                    from xwf700 x
                   where x.xwfprcins = pn_instancia
                     and x.xwfcar3 = '1')
             and f.modulo = 103
             and (f.tonom like '%Sup%' or f.tonom like '%Emp%');
        exception
          when others then
            null;
        end;
      
        if ln_EsSupEmpr > 0 then
          ln_flag := 2;
        else
          ln_flag := 1;
        end if;
      end if;
    end if;
  
    -- Fin PRY6415 Mpostigoc 21.08.2023
  
    SP_BACKUP_AQPA024(pn_instancia, ld_dateEjec, lc_horaEjec);
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
      SP_DEUINGRE(pn_instancia, pn_evaluacion);
    end loop;
    commit;
  
    --agrupamos AQPA024 de todos
    for r in factores(ln_SegmntoActual) loop
      insert into AQPA024
        (AQPA024INST, AQPA024FECH, AQPA024HORA, AQPA024GRUP, AQPA024FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, r.aqpa024agrup, r.factor);
      commit;
    end loop;
  
    --calculo factor cuota potencial deuda RCC AQPA024B
    for n in factores2(ln_SegmntoActual) loop
      insert into AQPA024
        (AQPA024INST, AQPA024FECH, AQPA024HORA, AQPA024GRUP, AQPA024FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, 8, n.factor);
      commit;
    end loop;
    --chernandez 17/02/2020
    for o in factores3(ln_SegmntoActual) loop
      insert into AQPA024
        (AQPA024INST, AQPA024FECH, AQPA024HORA, AQPA024GRUP, AQPA024FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, 15, o.factor);
      commit;
    end loop;
  
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
             --chernandez 17/02/2020
             /*when REGEXP_LIKE(a.c_cuenta,
                             '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]130601|^14.[1-6]120601') then
             2*/
               when REGEXP_LIKE(a.c_cuenta,
                                '^14.[1-6]030602|^14.[1-6]030302') then -- se agrego rubro 0303
                3
               when REGEXP_LIKE(a.c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and
                    not -- se agrego rubro 0303
                     REGEXP_LIKE(a.c_cuenta,
                                 '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') then -- se agrego rubro 0303
                4
               when REGEXP_LIKE(a.c_cuenta,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') then -- se agrego rubro 0303
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
              REGEXP_LIKE(a.c_cuenta, '^14.[1-6]030602|^14.[1-6]030302') or -- se agrego rubro 0303
              (REGEXP_LIKE(a.c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') and
              not -- se agrego rubro 0303
               REGEXP_LIKE(a.c_cuenta,
                            '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or -- se agrego rubro 0303
              REGEXP_LIKE(a.c_cuenta,
                          '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or -- se agrego rubro 0303
              REGEXP_LIKE(a.c_cuenta, '^14.[1-6]04') or
              (REGEXP_LIKE(a.c_cuenta, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(a.c_cuenta,
                                                                                               '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
              REGEXP_LIKE(a.c_cuenta, '^71.[1-4]')
             --chernandez 17/02/2020
             /*or
             REGEXP_LIKE(a.c_cuenta,
                         '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]130601|^14.[1-6]120601')*/
             )
       group by a.c_cuenta;
  
    cursor Lineas(ln_inst number, lv_codsbs varchar2) is
      select *
        from (select cuenta.*,
                     case
                     --chernandez 17/02/2020 2 modificacion de rubros
                     --mpostigoc 09/12/2021 se agrego 6 nuevos rubros
                       when REGEXP_LIKE(cuenta,
                                        '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14.[1-6]..99|^14.[1-6]0.05|^14.[1-6]030601|^14.[1-6]..05|^71.2|^71.3') then
                        2
                       when REGEXP_LIKE(cuenta,
                                        '^14.[1-6]03|^14.[1-6]02|^14.[1-6]12|^14.[1-6]13') then
                        1
                     --when REGEXP_LIKE(cuenta, '^72.5') then 8 
                       else
                        0
                     end GRUPO
                from (select ff.aqpa024bcuen cuenta,
                             case
                               when substr(ff.aqpa024bcuen, 1, 2) = '14' then
                                sum(ff.aqpa024bsald)
                               else
                                sum(ff.aqpa024bsaln)
                             end saldo,
                             count(*) cant
                        from AQPA024B ff
                       where aqpa024bcsbs = lv_codsbs
                         and aqpa024binst = ln_inst
                       group by ff.aqpa024bcuen) cuenta)
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
         and JAQL548indbo in ('3', '4')
         and JAQL548numer = '998'
         and JAQL548Estado <> '06'
         and JAQL548REGU = 'NR'
         and JAQL548Ticta = 'CAC' -- INC7231 11.07.2024 MPOSTIGOC
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
      insert into AQPA024A
        (aqpa024ainst,
         aqpa024acsbs,
         aqpa024acuen,
         aqpa024agrup,
         aqpa024atipo,
         aqpa024asald,
         aqpa024acont,
         aqpa024afpre,
         aqpa024atdoc,
         aqpa024andoc,
         AQPA024AFECH,
         AQPA024AHORA)
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
      insert into AQPA024A
        (aqpa024ainst,
         aqpa024acsbs,
         aqpa024acuen,
         aqpa024agrup,
         aqpa024atipo,
         aqpa024asald,
         aqpa024acont,
         aqpa024afpre,
         aqpa024atdoc,
         aqpa024andoc,
         AQPA024AFECH,
         AQPA024AHORA)
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
      insert into AQPA024A
        (aqpa024ainst,
         aqpa024acsbs,
         aqpa024acuen,
         aqpa024agrup,
         aqpa024atipo,
         aqpa024asald,
         aqpa024acont,
         aqpa024afpre,
         aqpa024atdoc,
         aqpa024andoc,
         AQPA024AFECH,
         AQPA024AHORA)
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
      select a.jaqy327rubr CUENTA,
             sum(jaqy327sdeu) SALDO,
             count(*) cant,
             case
             --chernandez 17/02/2020 modificacion de rubros
             /*when REGEXP_LIKE(a.jaqy327rubr, '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then 2*/
               when REGEXP_LIKE(a.jaqy327rubr,
                                '^14.[1-6]030602|^14.[1-6]030302') -- se agrego rubro 0303
                then
                3
               when REGEXP_LIKE(a.jaqy327rubr, '^14.[1-6]0306|^14.[1-6]0303') and
                    not -- se agrego rubro 0303
                     REGEXP_LIKE(a.jaqy327rubr,
                                 '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') -- se agrego rubro 0303
                then
                4
               when REGEXP_LIKE(a.jaqy327rubr,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') -- se agrego rubro 0303
                then
                5
               when REGEXP_LIKE(a.jaqy327rubr, '^14.[1-6]04') then
                6
               when REGEXP_LIKE(a.jaqy327rubr,
                                '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
                     REGEXP_LIKE(a.jaqy327rubr,
                                                                                        '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then
                7
               when REGEXP_LIKE(a.jaqy327rubr, '^71.[1-4]') then
                9
               else
                0
             end GRUPO
        from jaqy327 a
       where jaqy327inst = ln_inst
         and jaqy327esta = 'S'
         and jaqy327dori = '1'
         and jaqy327chek = '1'
         and jaqy327flin = 'P'
         and JAQY327tdoc = ln_tdoc
         and JAQY327ndoc = lc_ndoc
         and (
             /*cuentas*/
              REGEXP_LIKE(a.jaqy327rubr, '^14.[1-6]030602|^14.[1-6]030302') or -- se agrego rubro 0303
              (REGEXP_LIKE(a.jaqy327rubr, '^14.[1-6]0306|^14.[1-6]0303') and
              not -- se agrego rubro 0303
               REGEXP_LIKE(a.jaqy327rubr,
                            '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or -- se agrego rubro 0303
              REGEXP_LIKE(a.jaqy327rubr,
                          '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or -- se agrego rubro 0303
              REGEXP_LIKE(a.jaqy327rubr, '^14.[1-6]04') or
              (REGEXP_LIKE(a.jaqy327rubr,
                           '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(a.jaqy327rubr,
                                                                                    '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
              REGEXP_LIKE(a.jaqy327rubr, '^71.[1-4]')
             --chernandez 17/02/2020
             /*or
             REGEXP_LIKE(a.jaqy327rubr,
                         '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')*/
             )
       group by a.jaqy327rubr;
  
    --panel pyme lineas
    cursor CrediPnlLine(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.jaqy327rubr CUENTA,
             sum(jaqy327util) SALDO,
             count(*) cant,
             case
             --chernandez 17/02/2020 2
             --mpostigoc 09/12/2021 se agrego 6 nuevos rubros
               when REGEXP_LIKE(jaqy327rubr,
                                -- '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601'
                                '^14..020601|^14..130601|^14..120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') then
                2
               when REGEXP_LIKE(jaqy327rubr,
                                '^14..03|^14..02|^14..12|^14..13') then
                1
               else
                0
             end GRUPO
        from jaqy327 a
       where jaqy327inst = ln_inst
         and jaqy327esta = 'S'
         and jaqy327dori = '1'
         and jaqy327chek = '1'
         and jaqy327flin = 'L'
         and JAQY327tdoc = ln_tdoc
         and JAQY327ndoc = lc_ndoc
            --chernandez 17/02/2020
         and (REGEXP_LIKE(a.jaqy327rubr, '^14..03|^14..02|^14..12|^14..13') or
             (REGEXP_LIKE(a.jaqy327rubr,
                           '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05')) or
             (REGEXP_LIKE(a.jaqy327rubr, '^71.2|^71.3')))
      /*and
      REGEXP_LIKE(jaqy327rubr, '^14..03')*/
       group by a.jaqy327rubr;
  
    --panel pyme lineas cuota potencial
    cursor CrePnlLineasPotencial(ln_inst number,
                                 ln_tdoc number,
                                 lc_ndoc character) is
      select aa.*,
             rownum,
             --chernandez 17/02/2020 2
             case
               when REGEXP_LIKE(aa.jaqy327rubr, '^14.[1-6]0303|^72.503') then
                1 --EFUENTES 2022.01.31
               when REGEXP_LIKE(aa.jaqy327rubr,
                                '^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05') or
                    (REGEXP_LIKE(aa.jaqy327rubr, '^72.503|^71.2|^71.3') and not
                      REGEXP_LIKE(aa.jaqy327rubr,
                                                                                         '^72.5030202|^72.5030302|^72.5010302|^72.5020202|^72.5040202|^72.5040302|^72.5050202')) then
                2
               when REGEXP_LIKE(aa.jaqy327rubr, '^14.[1-6]..02') or
                    REGEXP_LIKE(aa.jaqy327rubr, '^72.506') then
                1
               else
                0
             end tipo
        from jaqy327 aa
       where jaqy327inst = ln_inst
         and jaqy327esta = 'S'
         and jaqy327dori = '1'
         and jaqy327chek = '1'
         and jaqy327flin = 'L'
         and JAQY327tdoc = ln_tdoc
         and JAQY327ndoc = lc_ndoc;
  
    --panel pyme lineas cuota potencial JAQY142L EFUENTES
    cursor CrePnlLineasPotencial_JAQY142L(ln_inst   number,
                                          lv_estado varchar2) is
      select jaqy142lrubro,
             jaqy142lusado,
             jaqy142lmntcr,
             jaqy142ldispb,
             case
               when REGEXP_LIKE(jaqy142lrubro, '^72.503|^71.2|^71.3') and not
                     REGEXP_LIKE(jaqy142lrubro,
                                                                                       '^72.5030202|^72.5030302|^72.5010302|^72.5020202|^72.5040202|^72.5040302|^72.5050202') then
                2
               else
                0
             end tipo
        from jaqy142l
       where jaqy142linst = ln_inst
         and jaqy142lest = lv_estado
         and substr(jaqy142lrubro, 1, 2) = '72'; --lv_rubro--'7215031300001'
  
    --panel pyme deuda ingresada
    cursor CrePnlIngre(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select 'NO REGUL' CUENTA,
             sum(jaqy327sdeu) SALDO,
             count(*) cant,
             13 GRUPO
        from jaqy327 a
       where jaqy327inst = ln_inst
         and jaqy327esta = 'S'
         and jaqy327dori = '2'
         and jaqy327chek = '1'
         and JAQY327tdoc = ln_tdoc
         and JAQY327ndoc = lc_ndoc
       group by a.jaqy327rubr;
  
    --panel consumo creditos
    cursor PnlConsumo(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.jaqz862rubr CUENTA,
             sum(jaqz862sdeu) SALDO,
             count(*) cant,
             case
             --chernandez 17/02/2020
             /*when REGEXP_LIKE(a.jaqz862rubr,
                             '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202') then
             2*/
               when REGEXP_LIKE(a.jaqz862rubr,
                                '^14.[1-6]030602|^14.[1-6]030302') then -- se agrego rubro 0303
                3
               when REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]0306|^14.[1-6]0303') and
                    not -- se agrego rubro 0303
                     REGEXP_LIKE(a.jaqz862rubr,
                                 '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312') then -- se agrego rubro 0303
                4
               when REGEXP_LIKE(a.jaqz862rubr,
                                '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') then -- se agrego rubro 0303
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
         and (REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]030602|^14.[1-6]030302') or -- se agrego rubro 0303
             (REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]0306|^14.[1-6]0303') and
             not -- se agrego rubro 0303
              REGEXP_LIKE(a.jaqz862rubr,
                            '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) or -- se agrego rubro 0303
             REGEXP_LIKE(a.jaqz862rubr,
                          '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') or -- se agrego rubro 0303
             REGEXP_LIKE(a.jaqz862rubr, '^14.[1-6]04') or
             (REGEXP_LIKE(a.jaqz862rubr,
                           '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
              REGEXP_LIKE(a.jaqz862rubr,
                                                                                     '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')) or
             REGEXP_LIKE(a.jaqz862rubr, '^71.[1-4]')
             --chernandez 17/02/2020
             /* or REGEXP_LIKE(a.jaqz862rubr,
             '^14.[1-6]020601|^14.[1-6]029901|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')*/
             )
       group by a.jaqz862rubr;
  
    --panel consumo lineas
    cursor PnlConsLine(ln_inst number, ln_tdoc number, lc_ndoc character) is
      select a.jaqz862rubr CUENTA,
             sum(jaqz862util) SALDO,
             count(*) cant,
             case --chernandez 17/02/2020 2
             --when REGEXP_LIKE(jaqz862rubr, '^14.[1-6]0303') then 4 --EFUENTES 2022.01.28
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
      /*and
      REGEXP_LIKE(jaqz862rubr, '^14..03')*/
       group by a.jaqz862rubr;
  
    --panel consumo lineas cuota potencial
    cursor PnlConsLineasPotencial(ln_inst number,
                                  ln_tdoc number,
                                  lc_ndoc character) is
      select aa.*,
             rownum,
             --chernandez 17/02/2020 2
             case
               when REGEXP_LIKE(aa.jaqz862rubr, '^14.[1-6]0303|^72.503') then
                1 --EFUENTES 2022.01.31
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
  
    --panel consumo lineas cuota potencial JAQY142L
    cursor PnlConsLineasPotencial_JAQY142L(ln_inst   number,
                                           lv_estado varchar2) is
      select jaqy142lrubro,
             jaqy142lusado,
             jaqy142lmntcr,
             jaqy142ldispb,
             case
               when REGEXP_LIKE(jaqy142lrubro, '^14.[1-6]0303') then
                1
               when REGEXP_LIKE(jaqy142lrubro,
                                '^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05|^71.2|^71.3') or
                    (REGEXP_LIKE(jaqy142lrubro, '^72.503') and
                     not
                      REGEXP_LIKE(jaqy142lrubro, '^72.5030202|^72.5030302')) then
                2
               when REGEXP_LIKE(jaqy142lrubro, '^14.[1-6]..02') or
                    REGEXP_LIKE(jaqy142lrubro, '^72.506') then
                1
               else
                0
             end tipo
        from jaqy142l
       where jaqy142linst = ln_inst
         and jaqy142lest = lv_estado
         and substr(jaqy142lrubro, 1, 2) = '72'; --lv_rubro--'7215031300001'
  
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
      --calculo de líneas completas AQPA024B
      for ggg in CrePnlLineasPotencial(pn_instancia, pn_tdoc, pc_ndoc) loop
        lv_empresa := trim(to_char(nvl(ggg.JAQY327CENT, ggg.rownum)));
      
        if ggg.jaqy327cent = '00104' and
           substr(ggg.jaqy327rubr, 1, 2) <> '72' then
          for w in CrePnlLineasPotencial_JAQY142L(pn_instancia, 'H') loop
            begin
              INSERT INTO AQPA024B
                (aqpa024binst,
                 aqpa024bcsbs,
                 aqpa024bcemp,
                 aqpa024bcuen,
                 aqpa024bsald,
                 aqpa024bsalc,
                 aqpa024bsaln,
                 AQPA024BFPRE,
                 aqpa024bhora,
                 aqpa024bfech,
                 aqpa024butil,
                 aqpa024btipo)
              VALUES
                (pn_instancia,
                 substr(trim(pc_ndoc), 1, 10),
                 substr(lv_empresa, 1, 5),
                 w.jaqy142lrubro,
                 w.jaqy142lusado,
                 w.jaqy142lmntcr,
                 w.jaqy142ldispb,
                 ggg.jaqy327frcc,
                 pc_horaEjec,
                 pd_dateEjec,
                 0,
                 w.tipo);
            exception
              when others then
                null;
            end;
          end loop;
        end if;
      
        begin
          INSERT INTO AQPA024B
            (aqpa024binst,
             aqpa024bcsbs,
             aqpa024bcemp,
             aqpa024bcuen,
             aqpa024bsald,
             aqpa024bsalc,
             aqpa024bsaln,
             AQPA024BFPRE,
             aqpa024bhora,
             aqpa024bfech,
             aqpa024butil,
             aqpa024btipo) --chernandez 17/02/2020
          VALUES
            (pn_instancia,
             substr(trim(pc_ndoc), 1, 10), --mod@abr 20190801
             substr(lv_empresa, 1, 5),
             ggg.jaqy327rubr,
             ggg.jaqy327util,
             ggg.jaqy327util + ggg.jaqy327aux8,
             ggg.jaqy327aux8,
             ggg.jaqy327frcc,
             pc_horaEjec,
             pd_dateEjec,
             0,
             ggg.tipo); --chernandez 17/02/2020
        
        exception
          when others then
            null;
        end;
      
        commit;
      end loop;
    
      for e in CrediPnl(pn_instancia, pn_tdoc, pc_ndoc) loop
        begin
          insert into AQPA024A
            (aqpa024ainst,
             aqpa024acsbs,
             aqpa024acuen,
             aqpa024agrup,
             aqpa024atipo,
             aqpa024asald,
             aqpa024acont,
             aqpa024afpre,
             aqpa024atdoc,
             aqpa024andoc,
             AQPA024AFECH,
             AQPA024AHORA)
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
        exception
          when others then
            null;
        end;
        commit;
      end loop;
    
      for ee in CrediPnlLine(pn_instancia, pn_tdoc, pc_ndoc) loop
        begin
          insert into AQPA024A
            (aqpa024ainst,
             aqpa024acsbs,
             aqpa024acuen,
             aqpa024agrup,
             aqpa024atipo,
             aqpa024asald,
             aqpa024acont,
             aqpa024afpre,
             aqpa024atdoc,
             aqpa024andoc,
             AQPA024AFECH,
             AQPA024AHORA)
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
        exception
          when others then
            null;
        end;
        commit;
      end loop;
    
      for ff in CrePnlIngre(pn_instancia, pn_tdoc, pc_ndoc) loop
        begin
          insert into AQPA024A
            (aqpa024ainst,
             aqpa024acsbs,
             aqpa024acuen,
             aqpa024agrup,
             aqpa024atipo,
             aqpa024asald,
             aqpa024acont,
             aqpa024afpre,
             aqpa024atdoc,
             aqpa024andoc,
             AQPA024AFECH,
             AQPA024AHORA)
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
        exception
          when others then
            null;
        end;
        commit;
      end loop;
    
    else
      for e in PnlConsumo(pn_instancia, pn_tdoc, pc_ndoc) loop
        begin
          insert into AQPA024A
            (aqpa024ainst,
             aqpa024acsbs,
             aqpa024acuen,
             aqpa024agrup,
             aqpa024atipo,
             aqpa024asald,
             aqpa024acont,
             aqpa024afpre,
             aqpa024atdoc,
             aqpa024andoc,
             AQPA024AFECH,
             AQPA024AHORA)
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
        exception
          when others then
            null;
        end;
        commit;
      end loop;
    
      for ee in PnlConsLine(pn_instancia, pn_tdoc, pc_ndoc) loop
        begin
          insert into AQPA024A
            (aqpa024ainst,
             aqpa024acsbs,
             aqpa024acuen,
             aqpa024agrup,
             aqpa024atipo,
             aqpa024asald,
             aqpa024acont,
             aqpa024afpre,
             aqpa024atdoc,
             aqpa024andoc,
             AQPA024AFECH,
             AQPA024AHORA)
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
        exception
          when others then
            null;
        end;
        commit;
      end loop;
    
      for gg in PnlConsumoingre(pn_instancia, pn_tdoc, pc_ndoc) loop
        begin
          insert into AQPA024A
            (aqpa024ainst,
             aqpa024acsbs,
             aqpa024acuen,
             aqpa024agrup,
             aqpa024atipo,
             aqpa024asald,
             aqpa024acont,
             aqpa024afpre,
             aqpa024atdoc,
             aqpa024andoc,
             AQPA024AFECH,
             AQPA024AHORA)
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
        exception
          when others then
            null;
        end;
        commit;
      end loop;
    
      for ggg in PnlConsLineasPotencial(pn_instancia, pn_tdoc, pc_ndoc) loop
        lv_empresa := trim(to_char(nvl(ggg.jaqz862CENT, ggg.rownum)));
      
        if ggg.jaqz862CENT = '00104' and
           substr(ggg.jaqz862rubr, 1, 2) <> '72' then
          for ww in PnlConsLineasPotencial_JAQY142L(pn_instancia, 'H') loop
            begin
              INSERT INTO AQPA024B
                (aqpa024binst,
                 aqpa024bcsbs,
                 aqpa024bcemp,
                 aqpa024bcuen,
                 aqpa024bsald,
                 aqpa024bsalc,
                 aqpa024bsaln,
                 AQPA024BFPRE,
                 aqpa024bhora,
                 aqpa024bfech,
                 aqpa024butil,
                 aqpa024btipo) --chernandez 17/02/2020
              VALUES
                (pn_instancia,
                 substr(trim(pc_ndoc), 1, 10), --mod@abr 20190801
                 substr(lv_empresa, 1, 5),
                 ww.jaqy142lrubro,
                 ww.jaqy142lusado,
                 ww.jaqy142lmntcr,
                 ww.jaqy142ldispb,
                 ggg.jaqz862frcc,
                 pc_horaEjec,
                 pd_dateEjec,
                 0,
                 ww.tipo);
            exception
              when others then
                null;
            end;
          end loop;
        end if;
      
        begin
          INSERT INTO AQPA024B
            (aqpa024binst,
             aqpa024bcsbs,
             aqpa024bcemp,
             aqpa024bcuen,
             aqpa024bsald,
             aqpa024bsalc,
             aqpa024bsaln,
             AQPA024BFPRE,
             aqpa024bhora,
             aqpa024bfech,
             aqpa024butil,
             aqpa024btipo) --chernandez 17/02/2020
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
        exception
          when others then
            null;
        end;
        commit;
      end loop;
    
    end if;
    commit;
  
  end SP_PANELSD;

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
                                  -- '^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601'
                                  '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601|^14..99|^14..0.05|^14..030601|^14..05'))
              
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
                 and (REGEXP_LIKE(a.c_cuenta, '^72.503|^71.2|^71.3') and
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
                              1, --chernandez 17/02/2020
                              ln_cuenta14,
                              ln_cuenta72,
                              ln_cuenta81);
    
      lc_codempANT := lc_codemp;
      ln_entro     := 1; --chernandez 17/02/2020
    end loop;
    if ln_entro = 1 then
      --chernandez 17/02/2020
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
        INSERT INTO AQPA024B
          (aqpa024binst,
           aqpa024bcsbs,
           aqpa024bcemp,
           aqpa024bcuen,
           aqpa024bsald,
           aqpa024bsalc,
           aqpa024bsaln,
           aqpa024bfpre,
           aqpa024bhora,
           aqpa024bfech,
           aqpa024butil,
           aqpa024btipo) --chernandez 17/02/2020
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
        INSERT INTO AQPA024B
          (aqpa024binst,
           aqpa024bcsbs,
           aqpa024bcemp,
           aqpa024bcuen,
           aqpa024bsald,
           aqpa024bsalc,
           aqpa024bsaln,
           AQPA024BFPRE,
           aqpa024bhora,
           aqpa024bfech,
           aqpa024butil,
           aqpa024btipo) --chernandez 17/02/2020
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
      INSERT INTO AQPA024B
        (aqpa024binst,
         aqpa024bcsbs,
         aqpa024bcemp,
         aqpa024bcuen,
         aqpa024bsald,
         aqpa024bsalc,
         aqpa024bsaln,
         aqpa024bfpre,
         aqpa024bhora,
         aqpa024bfech,
         aqpa024butil,
         aqpa024btipo) --chernandez 17/02/2020
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
      INSERT INTO AQPA024B
        (aqpa024binst,
         aqpa024bcsbs,
         aqpa024bcemp,
         aqpa024bcuen,
         aqpa024bsald,
         aqpa024bsalc,
         aqpa024bsaln,
         AQPA024BFPRE,
         aqpa024bhora,
         aqpa024bfech,
         aqpa024butil,
         aqpa024btipo) --chernandez 17/02/2020
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
        select jaqy327FRCC, 1
          into pd_fecprc, pb_flag
          from jaqy327
         where jaqy327inst = pn_instancia
           and jaqy327esta = 'S'
              --and jaqy327dori = '1'
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

  procedure SP_BACKUP_AQPA024(pn_instancia number,
                              PD_FECHAEJE  DATE,
                              PC_HORA      CHARACTER) is
  
  begin
  
    INSERT INTO AQPA024L
      (aqpa024lfech1,
       aqpa024lhora1,
       aqpa024linst,
       aqpa024lcsbs,
       aqpa024lcuen,
       aqpa024lgrup,
       aqpa024ltipo,
       aqpa024lsald,
       aqpa024lcont,
       aqpa024lfpre,
       aqpa024ltdoc,
       aqpa024lndoc,
       aqpa024lfech,
       aqpa024lhora)
      select PD_FECHAEJE,
             PC_HORA,
             aqpa024ainst,
             aqpa024acsbs,
             aqpa024acuen,
             aqpa024agrup,
             aqpa024atipo,
             aqpa024asald,
             aqpa024acont,
             aqpa024afpre,
             aqpa024atdoc,
             aqpa024andoc,
             aqpa024afech,
             aqpa024ahora
        from AQPA024A
       where AQPA024AINST = pn_instancia;
  
    DELETE FROM AQPA024A where AQPA024AINST = pn_instancia;
  
    INSERT INTO AQPA024M
      (aqpa024mfech1,
       aqpa024mhora1,
       aqpa024minst,
       aqpa024mcsbs,
       aqpa024mcemp,
       aqpa024mcuen,
       aqpa024msald,
       aqpa024msalc,
       aqpa024msaln,
       aqpa024mbfpre,
       aqpa024mfech,
       aqpa024mhora)
      select PD_FECHAEJE,
             PC_HORA,
             aqpa024binst,
             aqpa024bcsbs,
             aqpa024bcemp,
             aqpa024bcuen,
             aqpa024bsald,
             aqpa024bsalc,
             aqpa024bsaln,
             aqpa024bfpre,
             aqpa024bfech,
             aqpa024bhora
        from AQPA024B
       where AQPA024BINST = pn_instancia;
  
    DELETE FROM AQPA024B where AQPA024BINST = pn_instancia;
  
    INSERT INTO AQPA024N
      (aqpa024nfech1,
       aqpa024nhora1,
       aqpa024ninst,
       aqpa024nfech,
       aqpa024nhora,
       aqpa024ngrup,
       aqpa024nfact)
      select PD_FECHAEJE,
             PC_HORA,
             aqpa024inst,
             aqpa024fech,
             aqpa024hora,
             aqpa024grup,
             aqpa024fact
        from AQPA024
       where AQPA024INST = pn_instancia;
  
    DELETE FROM AQPA024 where AQPA024INST = pn_instancia;
  
    COMMIT;
  end SP_BACKUP_AQPA024;

  procedure SP_DEUINGRE(pn_instancia numeric, pn_evaluacion numeric) is
  
    cursor factores(pln_SegmntoActual numeric) is
      select aqpa024agrup,
             case
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 8000 then
                0.0514
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 15000 then
                0.0356
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 45000 then
                0.0282
               when aqpa024agrup = 11 and sum(aqpa024asald) > 45000 then
                0.0222
               when aqpa024agrup = 12 then
                0.09
             end factor
        from (select case
                       when jaqz864txt2 =
                            'Prestamo                                ' then
                        sum(JAQZ864mto1)
                       else
                        sum(JAQZ864mto4)
                     end aqpa024asald,
                     
                     case
                       when jaqz864txt2 =
                            'Prestamo                                ' then
                        11
                       else
                        12
                     end aqpa024agrup,
                     pn_instancia instancia
              
                from jaqz864
               where jaqz864eval = pn_evaluacion
               group by jaqz864eval, jaqz864txt2)
       group by aqpa024agrup;
  
    cursor factoresCons(pln_SegmntoActual numeric) is
      select aqpa024agrup,
             case
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 8000 then
                0.0514
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 15000 then
                0.0356
               when aqpa024agrup = 11 and sum(aqpa024asald) <= 45000 then
                0.0282
               when aqpa024agrup = 11 and sum(aqpa024asald) > 45000 then
                0.0222
               when aqpa024agrup = 12 then
                0.09
             end factor
        from (select case
                       when jaqz865txt2 =
                            'Prestamo                                ' then
                        sum(JAQZ865mto1)
                       else
                        sum(JAQZ865mto4)
                     end aqpa024asald,
                     
                     case
                       when jaqz865txt2 =
                            'Prestamo                                ' then
                        11
                       else
                        12
                     end aqpa024agrup,
                     pn_instancia instancia
              
                from jaqz865
               where jaqz865eval = pn_evaluacion
               group by jaqz865eval, jaqz865txt2)
       group by aqpa024agrup;
  
    cursor factores2(pln_SegmntoActual numeric) is
      select case
               when sum(jaqz864mto4) / sum(aqpa024bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.02
             
               when sum(jaqz864mto4) / sum(aqpa024bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.09
             
               when sum(jaqz864mto4) / sum(aqpa024bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.11
             
               when sum(jaqz864mto4) / sum(aqpa024bsalc) * 100 > 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.21
             
               when sum(jaqz864mto4) / sum(aqpa024bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.03
             
               when sum(jaqz864mto4) / sum(aqpa024bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.07
             
               when sum(jaqz864mto4) / sum(aqpa024bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.12
             
               when sum(jaqz864mto4) / sum(aqpa024bsalc) * 100 > 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.25
             end factor
      
        from (select jaqz864mto4,
                     jaqz864mto3 + jaqz864mto4 aqpa024bsalc,
                     jaqz864eval
                from jaqz864
               where jaqz864eval = pn_evaluacion
                 and jaqz864txt2 =
                     'Linea                                   '
                 and (jaqz864mto3 + jaqz864mto4) <> 0)
       group by jaqz864eval;
  
    cursor factores3(pln_SegmntoActual numeric) is
      select --sum(jaqz865mto4)/sum(mtotot)*100 
       case
         when sum(jaqz865mto4) / sum(aqpa024bsalc) * 100 <= 45 and
              pln_SegmntoActual = 1 then
          0.044 * 0.02
       
         when sum(jaqz865mto4) / sum(aqpa024bsalc) * 100 <= 65 and
              pln_SegmntoActual = 1 then
          0.044 * 0.09
       
         when sum(jaqz865mto4) / sum(aqpa024bsalc) * 100 <= 85 and
              pln_SegmntoActual = 1 then
          0.044 * 0.11
       
         when sum(jaqz865mto4) / sum(aqpa024bsalc) * 100 > 85 and
              pln_SegmntoActual = 1 then
          0.044 * 0.21
       
         when sum(jaqz865mto4) / sum(aqpa024bsalc) * 100 <= 45 and
              pln_SegmntoActual = 2 then
          0.044 * 0.03
       
         when sum(jaqz865mto4) / sum(aqpa024bsalc) * 100 <= 65 and
              pln_SegmntoActual = 2 then
          0.044 * 0.07
       
         when sum(jaqz865mto4) / sum(aqpa024bsalc) * 100 <= 85 and
              pln_SegmntoActual = 2 then
          0.044 * 0.12
       
         when sum(jaqz865mto4) / sum(aqpa024bsalc) * 100 > 85 and
              pln_SegmntoActual = 2 then
          0.044 * 0.25
       end factor
      
        from (select jaqz865mto4,
                     jaqz865mto3 + jaqz865mto4 aqpa024bsalc,
                     jaqz865eval
                from jaqz865
               where jaqz865eval = pn_evaluacion
                 and jaqz865txt2 =
                     'Linea                                   '
                 and (jaqz865mto3 + jaqz865mto4) <> 0)
       group by jaqz865eval;
  
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
  
    INSERT INTO AQPA024N
      (aqpa024nfech1,
       aqpa024nhora1,
       aqpa024ninst,
       aqpa024nfech,
       aqpa024nhora,
       aqpa024ngrup,
       aqpa024nfact)
      select ld_dateEjec,
             lc_horaEjec,
             aqpa024inst,
             aqpa024fech,
             aqpa024hora,
             aqpa024grup,
             aqpa024fact
        from AQPA024
       where AQPA024INST = pn_instancia
         and AQPA024GRUP in (11, 12, 14);
  
    delete from AQPA024
     where AQPA024INST = pn_instancia
       and AQPA024GRUP in (11, 12, 14);
    commit;
  
    if ln_SegmntoActual = 1 then
    
      for r in factores(ln_SegmntoActual) loop
        insert into AQPA024
          (AQPA024INST, AQPA024FECH, AQPA024HORA, AQPA024GRUP, AQPA024FACT)
        values
          (pn_instancia,
           ld_dateEjec,
           lc_horaEjec,
           r.aqpa024agrup,
           r.factor);
      
      end loop;
    
      for n in factores2(ln_SegmntoActual) loop
        insert into AQPA024
          (AQPA024INST, AQPA024FECH, AQPA024HORA, AQPA024GRUP, AQPA024FACT)
        values
          (pn_instancia, ld_dateEjec, lc_horaEjec, 14, n.factor);
      end loop;
    
    else
    
      for r in factoresCons(ln_SegmntoActual) loop
        insert into AQPA024
          (AQPA024INST, AQPA024FECH, AQPA024HORA, AQPA024GRUP, AQPA024FACT)
        values
          (pn_instancia,
           ld_dateEjec,
           lc_horaEjec,
           r.aqpa024agrup,
           r.factor);
      
      end loop;
    
      for n in factores3(ln_SegmntoActual) loop
        insert into AQPA024
          (AQPA024INST, AQPA024FECH, AQPA024HORA, AQPA024GRUP, AQPA024FACT)
        values
          (pn_instancia, ld_dateEjec, lc_horaEjec, 14, n.factor);
      end loop;
    
    end if;
  
    commit;
  exception
    when others then
      null;
  end SP_DEUINGRE;

end PQ_CR_CALC_METSOBREEND;
/

