create or replace package PQ_CR_CALC_METSOBREEND_LIN is
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

  * *************************************************************************************************************/
  procedure SP_INICIO(pn_instancia numeric,
                      ln_pgcod     in number,
                      ln_itsuc     in number,
                      ln_modulo    in number,
                      ln_trans     in number,
                      ln_rela      in number,
                      ld_fcont     in date,
                      lc_usuario   in character);

  procedure SP_RCC(pn_instancia numeric,
                   pv_codsbs    varchar2,
                   pn_tdoc      numeric,
                   pc_ndoc      character,
                   pd_FchRCC    date,
                   pd_dateEjec  date,
                   pc_horaEjec  character,
                   ln_pgcod     in number,
                   ln_itsuc     in number,
                   ln_modulo    in number,
                   ln_trans     in number,
                   ln_rela      in number,
                   ld_fcont     in date,
                   lc_usuario   in character);

  procedure SP_OBTENER_LINEAS(pn_instancia numeric,
                              pv_codsbs    varchar2,
                              pd_fec       date,
                              pd_dateEjec  date,
                              pc_horaEjec  character,
                              ln_pgcod     in number,
                              ln_itsuc     in number,
                              ln_modulo    in number,
                              ln_trans     in number,
                              ln_rela      in number,
                              ld_fcont     in date,
                              lc_usuario   in character);

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
                                    pn_tipo      in numeric,--chernandez 17/02/2020
                                    pn_cuenta14  in out varchar2,
                                    pn_cuenta72  in out varchar2,
                                    pn_cuenta81  in out varchar2,
                                    ln_pgcod     in number,
                                    ln_itsuc     in number,
                                    ln_modulo    in number,
                                    ln_trans     in number,
                                    ln_rela      in number,
                                    ld_fcont     in date,
                                    lc_usuario   in character);

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
                                          pn_tipo      in numeric,--chernandez 17/02/2020
                                          pn_cuenta14  in out varchar2,
                                          pn_cuenta72  in out varchar2,
                                          ln_pgcod     in number,
                                          ln_itsuc     in number,
                                          ln_modulo    in number,
                                          ln_trans     in number,
                                          ln_rela      in number,
                                          ld_fcont     in date,
                                          lc_usuario   in character);

  procedure SP_CR_SEGMNTOACTUAL(ln_Instancia     number,
                                ln_SegmntoActual out number);

  function FN_EQUIVALENCIADOC(p_tdoc number) return varchar2;

  procedure SP_INICIO_II(pn_instancia numeric);

  procedure SP_RCC_II(pn_instancia numeric,
                      pv_codsbs    varchar2,
                      pn_tdoc      numeric,
                      pc_ndoc      character,
                      pd_FchRCC    date,
                      pd_dateEjec  date,
                      pc_horaEjec  character);

  procedure SP_OBTENER_LINEAS_II(pn_instancia numeric,
                                 pv_codsbs    varchar2,
                                 pd_fec       date,
                                 pd_dateEjec  date,
                                 pc_horaEjec  character);

  procedure SP_OBTENER_SALDO_LINEAS_II(pv_codsbs    varchar2,
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
                                       pn_tipo      in numeric,--chernandez 17/02/2020
                                       pn_cuenta14  in out varchar2,
                                       pn_cuenta72  in out varchar2,
                                       pn_cuenta81  in out varchar2);

  procedure SP_OBTENER_SALDO_LINEAS_ULTEII(pv_codsbs    varchar2,
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
                                           pn_tipo      in numeric,--chernandez 17/02/2020
                                           pn_cuenta14  in out varchar2,
                                           pn_cuenta72  in out varchar2);

end PQ_CR_CALC_METSOBREEND_LIN;
/

create or replace package body PQ_CR_CALC_METSOBREEND_LIN is
-- rmontes 2021.03.08 modificaciones runro 0303 lineas 448.450.452.455.476.477.479.480.1698.1700.1702.1705.1726.1727.1729.1730
  procedure SP_INICIO(pn_instancia numeric,
                      ln_pgcod     in number,
                      ln_itsuc     in number,
                      ln_modulo    in number,
                      ln_trans     in number,
                      ln_rela      in number,
                      ld_fcont     in date,
                      lc_usuario   in character) is
  
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
      select aqpa419ainst,
             aqpa419agrup,
             sum(aqpa419asald),
             case
               when aqpa419agrup = 1 then
                0.044
               when aqpa419agrup = 2 then
                0.09
               when aqpa419agrup = 3 and sum(aqpa419asald) <= 30000 then
                0.0264
               when aqpa419agrup = 3 and sum(aqpa419asald) > 30000 then
                0.0222
               when aqpa419agrup = 4 and sum(aqpa419asald) <= 8000 then
                0.0514
               when aqpa419agrup = 4 and sum(aqpa419asald) <= 15000 then
                0.0356
               when aqpa419agrup = 4 and sum(aqpa419asald) <= 45000 then
                0.0282
               when aqpa419agrup = 4 and sum(aqpa419asald) > 45000 then
                0.0222
               when aqpa419agrup = 5 and sum(aqpa419asald) <= 10000 then
                0.0349
               when aqpa419agrup = 5 and sum(aqpa419asald) <= 20000 then
                0.0248
               when aqpa419agrup = 5 and sum(aqpa419asald) <= 30000 then
                0.0224
               when aqpa419agrup = 5 and sum(aqpa419asald) > 30000 then
                0.0205
               when aqpa419agrup = 6 then
                0.009
               when aqpa419agrup = 7 and sum(aqpa419asald) <= 8000 then
                0.0514
               when aqpa419agrup = 7 and sum(aqpa419asald) <= 15000 then
                0.0356
               when aqpa419agrup = 7 and sum(aqpa419asald) <= 45000 then
                0.0282
               when aqpa419agrup = 7 and sum(aqpa419asald) > 45000 then
                0.0222
             --when aqpa419agrup = 8 and pln_SegmntoActual = 1 then 0.044*0.02
             --when aqpa419agrup = 8 and pln_SegmntoActual = 2 then 0.044*0.03
               when aqpa419agrup = 9 then
                0.0017--17/02/2020 chernandez
               when aqpa419agrup = 10 then
                0
               when aqpa419agrup = 11 and sum(aqpa419asald) <= 8000 then
                0.0514
               when aqpa419agrup = 11 and sum(aqpa419asald) <= 15000 then
                0.0356
               when aqpa419agrup = 11 and sum(aqpa419asald) <= 45000 then
                0.0282
               when aqpa419agrup = 11 and sum(aqpa419asald) > 45000 then
                0.0222
               when aqpa419agrup = 12 and sum(aqpa419asald) <= 8000 then
                0.0514
               when aqpa419agrup = 12 and sum(aqpa419asald) <= 15000 then
                0.0356
               when aqpa419agrup = 12 and sum(aqpa419asald) <= 45000 then
                0.0282
               when aqpa419agrup = 12 and sum(aqpa419asald) > 45000 then
                0.0222
               when aqpa419agrup = 13 and sum(aqpa419asald) <= 8000 then
                0.0514
               when aqpa419agrup = 13 and sum(aqpa419asald) <= 15000 then
                0.0356
               when aqpa419agrup = 13 and sum(aqpa419asald) <= 45000 then
                0.0282
               when aqpa419agrup = 13 and sum(aqpa419asald) > 45000 then
                0.0222
             end factor
        from aqpa419a
       where aqpa419ainst = pn_instancia
         and aqpa419agrup <> 8
         and aqpa419apgcod = ln_pgcod
         and aqpa419aitsuc = ln_itsuc
         and aqpa419aitmod = ln_modulo
         and aqpa419aittran = ln_trans
         and aqpa419aitfcon = ld_fcont
         and aqpa419aitnrel = ln_rela
         and aqpa419aituing = lc_usuario
       group by aqpa419ainst, aqpa419agrup
       order by aqpa419agrup;
  
    cursor factores2(pln_SegmntoActual numeric) is
  --chernandez 17/02/2020 cambio de factores
      select case
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.04
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.23
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.25
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 > 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.32
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.04
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.25
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.29
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 > 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.34
             end factor
      
        from aqpa419b
       where aqpa419binst = pn_instancia
         and aqpa419bpgcod = ln_pgcod
         and aqpa419bitsuc = ln_itsuc
         and aqpa419bitmod = ln_modulo
         and aqpa419bittran = ln_trans
         and aqpa419bitfcon = ld_fcont
         and aqpa419bitnrel = ln_rela
         and aqpa419bituing = lc_usuario
         and aqpa419btipo = 1
       group by aqpa419binst;
  
  --chernandez 17/02/2020
    cursor factores3(pln_SegmntoActual numeric) is
      select case
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 45 then
                0.09 * 0.03
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 65 then
                0.09 * 0.07
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 <= 85 then
                0.09 * 0.19
             
               when sum(aqpa419bsald) / sum(aqpa419bsalc) * 100 > 85 then
                0.09 * 0.38
             end factor
      
        from aqpa419b b
       where aqpa419binst = pn_instancia
         and aqpa419bpgcod = ln_pgcod
         and aqpa419bitsuc = ln_itsuc
         and aqpa419bitmod = ln_modulo
         and aqpa419bittran = ln_trans
         and aqpa419bitfcon = ld_fcont
         and aqpa419bitnrel = ln_rela
         and aqpa419bituing = lc_usuario
         and aqpa419btipo = 2
         and REGEXP_LIKE(aqpa419bcuen, '^72.501|^72.502|^72.503|^72.504|^72.505|^72.4') -- mpostigoc 09/12/2021
       group by aqpa419binst;
  
    lc_CodSBS varchar2(10);
    ld_FchRCC date;
    --ln_tdocequi      number;
    ln_SegmntoActual number;
    ln_flag          number;
    lc_horaEjec      character(8);
    ld_dateEjec      date;
    ln_tipEje        number;
  
  begin
  
    begin
      delete aqpa419
       where aqpa419.aqpa419inst = pn_instancia
         and aqpa419.aqpa419pgcod = ln_pgcod
         and aqpa419.aqpa419itsuc = ln_itsuc
         and aqpa419.aqpa419itmod = ln_modulo
         and aqpa419.aqpa419ittran = ln_trans
         and aqpa419.aqpa419itnrel = ln_rela
         and aqpa419.aqpa419itfcon = ld_fcont;
      commit;
      delete aqpa419a
       where aqpa419a.aqpa419ainst = pn_instancia
         and aqpa419a.aqpa419apgcod = ln_pgcod
         and aqpa419a.aqpa419aitsuc = ln_itsuc
         and aqpa419a.aqpa419aitmod = ln_modulo
         and aqpa419a.aqpa419aittran = ln_trans
         and aqpa419a.aqpa419aitnrel = ln_rela
         and aqpa419a.aqpa419aitfcon = ld_fcont;
      commit;
      delete aqpa419b
       where aqpa419b.aqpa419binst = pn_instancia
         and aqpa419b.aqpa419bpgcod = ln_pgcod
         and aqpa419b.aqpa419bitsuc = ln_itsuc
         and aqpa419b.aqpa419bitmod = ln_modulo
         and aqpa419b.aqpa419bittran = ln_trans
         and aqpa419b.aqpa419bitnrel = ln_rela
         and aqpa419b.aqpa419bitfcon = ld_fcont;
      commit;
    
    end;
  
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
    end if;
  
    for d in documentos(ln_flag) loop
    
      lc_CodSBS := null;
    
      for rcc in CrCldrcci(d.ln_doc, FN_EQUIVALENCIADOC(d.petdoc)) loop
        lc_CodSBS := rcc.c_codsbs;
      end loop;
    
      if lc_CodSBS is not null then
      
        ln_tipEje := 1;
        SP_RCC(pn_instancia,
               lc_CodSBS,
               d.petdoc,
               d.ln_doc,
               ld_FchRCC,
               ld_dateEjec,
               lc_horaEjec,
               ln_pgcod,
               ln_itsuc,
               ln_modulo,
               ln_trans,
               ln_rela,
               ld_fcont,
               lc_usuario);
      end if;
    end loop;
    commit;
  
    --agrupamos AQPA024 de todos
    for r in factores(ln_SegmntoActual) loop
      insert into aqpa419
        (aqpa419INST,
         aqpa419FECH,
         aqpa419HORA,
         aqpa419GRUP,
         aqpa419FACT,
         aqpa419pgcod,
         aqpa419itsuc,
         aqpa419itmod,
         aqpa419ittran,
         aqpa419itnrel,
         aqpa419itfcon,
         aqpa419ituing)
      values
        (pn_instancia,
         ld_dateEjec,
         lc_horaEjec,
         r.aqpa419agrup,
         r.factor,
         ln_pgcod,
         ln_itsuc,
         ln_modulo,
         ln_trans,
         ln_rela,
         ld_fcont,
         lc_usuario);
    
    end loop;
  
    --calculo factor cuota potencial deuda RCC aqpa419b
    for n in factores2(ln_SegmntoActual) loop
      insert into aqpa419
        (aqpa419INST,
         aqpa419FECH,
         aqpa419HORA,
         aqpa419GRUP,
         aqpa419FACT,
         aqpa419pgcod,
         aqpa419itsuc,
         aqpa419itmod,
         aqpa419ittran,
         aqpa419itnrel,
         aqpa419itfcon,
         aqpa419ituing)
      values
        (pn_instancia,
         ld_dateEjec,
         lc_horaEjec,
         8,
         n.factor,
         ln_pgcod,
         ln_itsuc,
         ln_modulo,
         ln_trans,
         ln_rela,
         ld_fcont,
         lc_usuario);
    end loop;
    --chernandez 17/02/2020
    for o in factores3(ln_SegmntoActual) loop
      insert into aqpa419
        (aqpa419INST,
         aqpa419FECH,
         aqpa419HORA,
         aqpa419GRUP,
         aqpa419FACT,
         aqpa419pgcod,
         aqpa419itsuc,
         aqpa419itmod,
         aqpa419ittran,
         aqpa419itnrel,
         aqpa419itfcon,
         aqpa419ituing)
      values
        (pn_instancia,
         ld_dateEjec,
         lc_horaEjec,
         15,
         o.factor,
         ln_pgcod,
         ln_itsuc,
         ln_modulo,
         ln_trans,
         ln_rela,
         ld_fcont,
         lc_usuario);
         
          
           
    end loop;
    commit;
  
  end SP_INICIO;

  procedure SP_RCC(pn_instancia numeric,
                   pv_codsbs    varchar2,
                   pn_tdoc      numeric,
                   pc_ndoc      character,
                   pd_FchRCC    date,
                   pd_dateEjec  date,
                   pc_horaEjec  character,
                   ln_pgcod     in number,
                   ln_itsuc     in number,
                   ln_modulo    in number,
                   ln_trans     in number,
                   ln_rela      in number,
                   ld_fcont     in date,
                   lc_usuario   in character) is
  
    cursor CrediPym(lv_codsbs varchar2, ld_fec date) is
    
      select a.c_cuenta CUENTA,
             sum(n_salcap) SALDO,
             count(*) cant,
             case
       --chernandez 17/02/2020
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
                from (select ff.aqpa419bcuen cuenta,
                             case
                               when substr(ff.aqpa419bcuen, 1, 2) = '14' then
                                sum(ff.aqpa419bsald)
                               else
                                sum(ff.aqpa419bsaln)
                             end saldo,
                             count(*) cant
                        from aqpa419b ff
                       where aqpa419bcsbs = lv_codsbs
                         and aqpa419binst = ln_inst
                         and aqpa419bpgcod = ln_pgcod
                         and aqpa419bitsuc = ln_itsuc
                         and aqpa419bitmod = ln_modulo
                         and aqpa419bittran = ln_trans
                         and aqpa419bitfcon = ld_fcont
                         and aqpa419bitnrel = ln_rela
                         and aqpa419bituing = lc_usuario
                       group by ff.aqpa419bcuen) cuenta)
       where GRUPO <> 0;
  
    lv_codsbs varchar2(10); --mod@abr 20190801
  begin
  
    SP_OBTENER_LINEAS(pn_instancia,
                      pv_CodSBS,
                      pd_FchRCC,
                      pd_dateEjec,
                      pc_horaEjec,
                      ln_pgcod,
                      ln_itsuc,
                      ln_modulo,
                      ln_trans,
                      ln_rela,
                      ld_fcont,
                      lc_usuario);
  
    for e in CrediPym(pv_CodSBS, pd_FchRCC) loop
      insert into aqpa419a
        (aqpa419ainst,
         aqpa419acsbs,
         aqpa419acuen,
         aqpa419agrup,
         aqpa419atipo,
         aqpa419asald,
         aqpa419acont,
         aqpa419afpre,
         aqpa419atdoc,
         aqpa419andoc,
         aqpa419aFECH,
         aqpa419aHORA,
         aqpa419apgcod,
         aqpa419aitsuc,
         aqpa419aitmod,
         aqpa419aittran,
         aqpa419aitnrel,
         aqpa419aitfcon,
         aqpa419aituing)
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
         pc_horaEjec,
         ln_pgcod,
         ln_itsuc,
         ln_modulo,
         ln_trans,
         ln_rela,
         ld_fcont,
         lc_usuario);
    end loop;
  
    for ff in Lineas(pn_instancia, pv_CodSBS) loop
      insert into aqpa419a
        (aqpa419ainst,
         aqpa419acsbs,
         aqpa419acuen,
         aqpa419agrup,
         aqpa419atipo,
         aqpa419asald,
         aqpa419acont,
         aqpa419afpre,
         aqpa419atdoc,
         aqpa419andoc,
         aqpa419aFECH,
         aqpa419aHORA,
         aqpa419apgcod,
         aqpa419aitsuc,
         aqpa419aitmod,
         aqpa419aittran,
         aqpa419aitnrel,
         aqpa419aitfcon,
         aqpa419aituing)
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
         pc_horaEjec,
         ln_pgcod,
         ln_itsuc,
         ln_modulo,
         ln_trans,
         ln_rela,
         ld_fcont,
         lc_usuario);
    end loop;
  
  end SP_RCC;

  procedure SP_OBTENER_LINEAS(pn_instancia numeric,
                              pv_codsbs    varchar2,
                              pd_fec       date,
                              pd_dateEjec  date,
                              pc_horaEjec  character,
                              ln_pgcod     in number,
                              ln_itsuc     in number,
                              ln_modulo    in number,
                              ln_trans     in number,
                              ln_rela      in number,
                              ld_fcont     in date,
                              lc_usuario   in character) is
  
    cursor lineas1 is
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
                 and REGEXP_LIKE(a.c_cuenta, '^72.506')--chernandez 17/02/2020
              
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
                                  '^14..020601|^14..130601|^14..120601|^14..99|^14..0.05|^14..030601|^14..05'))
              
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
    ln_entro     numeric(5);--chernandez 17/02/2020          
  
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
    ln_entro     := 0;--chernandez 17/02/2020
  
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
                              1,--chernandez 17/02/2020
                              ln_cuenta14,
                              ln_cuenta72,
                              ln_cuenta81,
                              ln_pgcod,
                              ln_itsuc,
                              ln_modulo,
                              ln_trans,
                              ln_rela,
                              ld_fcont,
                              lc_usuario);
    
      lc_codempANT := lc_codemp;
      ln_entro     := 1;--chernandez 17/02/2020    
    end loop;
    if ln_entro = 1 then--chernandez 17/02/2020    
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
                                  ln_cuenta72,
                                  ln_pgcod,
                                  ln_itsuc,
                                  ln_modulo,
                                  ln_trans,
                                  ln_rela,
                                  ld_fcont,
                                  lc_usuario);
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
                              ln_cuenta81,
                              ln_pgcod,
                              ln_itsuc,
                              ln_modulo,
                              ln_trans,
                              ln_rela,
                              ld_fcont,
                              lc_usuario);
    
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
                                    ln_cuenta72,
                  ln_pgcod,
                  ln_itsuc,
                  ln_modulo,
                  ln_trans,
                  ln_rela,
                  ld_fcont,
                  lc_usuario);
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
                                    pn_tipo      in numeric,--chernandez 17/02/2020
                                    pn_cuenta14  in out varchar2,
                                    pn_cuenta72  in out varchar2,
                                    pn_cuenta81  in out varchar2,
                                    ln_pgcod     in number,
                                    ln_itsuc     in number,
                                    ln_modulo    in number,
                                    ln_trans     in number,
                                    ln_rela      in number,
                                    ld_fcont     in date,
                                    lc_usuario   in character) is
    pn_cuenta    varchar2(14);
    pn_cuentadol varchar2(14);
    pv_tipo72    varchar2(2);--chernandez 17/02/2020
    pv_tipo14    varchar2(4);--chernandez 17/02/2020 2
  begin
  
    --chernandez 17/02/2020
    if pn_tipo = 1 then
      pv_tipo72 := '06';
      pv_tipo14 := '';--chernandez 17/02/2020 2
    End if;
    if pn_tipo = 2 then
      pv_tipo72 := '03';
      pv_tipo14 := '0601';--chernandez 17/02/2020 2
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
    --chernandez 17/02/2020
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
    --chernandez 17/02/2020
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
        INSERT INTO aqpa419b
          (aqpa419binst,
           aqpa419bcsbs,
           aqpa419bcemp,
           aqpa419bcuen,
           aqpa419bsald,
           aqpa419bsalc,
           aqpa419bsaln,
           aqpa419bfpre,
           aqpa419bhora,
           aqpa419bfech,
           aqpa419butil,
           aqpa419btipo,--chernandez 17/02/2020
           aqpa419bpgcod,
           aqpa419bitsuc,
           aqpa419bitmod,
           aqpa419bittran,
           aqpa419bitnrel,
           aqpa419bitfcon,
           aqpa419bituing)
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
           pn_tipo,--chernandez 17/02/2020
           ln_pgcod,
           ln_itsuc,
           ln_modulo,
           ln_trans,
           ln_rela,
           ld_fcont,
           lc_usuario);
      end if;
    
      if pn_saldod14 <> 0 or pn_saldod72 <> 0 then
        --insertamos tabla auxiliar
        INSERT INTO aqpa419b
          (aqpa419binst,
           aqpa419bcsbs,
           aqpa419bcemp,
           aqpa419bcuen,
           aqpa419bsald,
           aqpa419bsalc,
           aqpa419bsaln,
           aqpa419bFPRE,
           aqpa419bhora,
           aqpa419bfech,
           aqpa419butil,
           aqpa419btipo,--chernandez 17/02/2020
           aqpa419bpgcod,
           aqpa419bitsuc,
           aqpa419bitmod,
           aqpa419bittran,
           aqpa419bitnrel,
           aqpa419bitfcon,
           aqpa419bituing)
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
           pn_tipo,--chernandez 17/02/2020
           ln_pgcod,
           ln_itsuc,
           ln_modulo,
           ln_trans,
           ln_rela,
           ld_fcont,
           lc_usuario);
      
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
                                          pn_tipo      in numeric,--chernandez 17/02/2020
                                          pn_cuenta14  in out varchar2,
                                          pn_cuenta72  in out varchar2,
                                          ln_pgcod     in number,
                                          ln_itsuc     in number,
                                          ln_modulo    in number,
                                          ln_trans     in number,
                                          ln_rela      in number,
                                          ld_fcont     in date,
                                          lc_usuario   in character) is
  
    pn_cuenta    varchar2(14);
    pn_cuentadol varchar2(14);
    pv_tipo72    varchar2(2);--chernandez 17/02/2020      
    pv_tipo14    varchar2(4);--chernandez 17/02/2020 2
  begin
    --chernandez 17/02/2020
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
    --chernandez 17/02/2020
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
    --chernandez 17/02/2020
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
      INSERT INTO aqpa419b
        (aqpa419binst,
         aqpa419bcsbs,
         aqpa419bcemp,
         aqpa419bcuen,
         aqpa419bsald,
         aqpa419bsalc,
         aqpa419bsaln,
         aqpa419bfpre,
         aqpa419bhora,
         aqpa419bfech,
         aqpa419butil,
         aqpa419btipo,--chernandez 17/02/2020
         aqpa419bpgcod,
         aqpa419bitsuc,
         aqpa419bitmod,
         aqpa419bittran,
         aqpa419bitnrel,
         aqpa419bitfcon,
         aqpa419bituing)
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
         pn_tipo,--chernandez 17/02/2020
         ln_pgcod,
         ln_itsuc,
         ln_modulo,
         ln_trans,
         ln_rela,
         ld_fcont,
         lc_usuario);
    end if;
  
    if pn_saldod14 <> 0 or pn_saldod72 <> 0 then
      --insertamos tabla auxiliar
      INSERT INTO aqpa419b
        (aqpa419binst,
         aqpa419bcsbs,
         aqpa419bcemp,
         aqpa419bcuen,
         aqpa419bsald,
         aqpa419bsalc,
         aqpa419bsaln,
         aqpa419bFPRE,
         aqpa419bhora,
         aqpa419bfech,
         aqpa419butil,
         aqpa419btipo,--chernandez 17/02/2020
         aqpa419bpgcod,
         aqpa419bitsuc,
         aqpa419bitmod,
         aqpa419bittran,
         aqpa419bitnrel,
         aqpa419bitfcon,
         aqpa419bituing)
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
         pn_tipo,--chernandez 17/02/2020
         ln_pgcod,
         ln_itsuc,
         ln_modulo,
         ln_trans,
         ln_rela,
         ld_fcont,
         lc_usuario);
    
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
  procedure SP_INICIO_II(pn_instancia numeric) is
  
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
      select AQPA422ainst,
             AQPA422agrup,
             sum(AQPA422asald),
             case
               when AQPA422agrup = 1 then
                0.044
               when AQPA422agrup = 2 then
                0.09
               when AQPA422agrup = 3 and sum(AQPA422asald) <= 30000 then
                0.0264
               when AQPA422agrup = 3 and sum(AQPA422asald) > 30000 then
                0.0222
               when AQPA422agrup = 4 and sum(AQPA422asald) <= 8000 then
                0.0514
               when AQPA422agrup = 4 and sum(AQPA422asald) <= 15000 then
                0.0356
               when AQPA422agrup = 4 and sum(AQPA422asald) <= 45000 then
                0.0282
               when AQPA422agrup = 4 and sum(AQPA422asald) > 45000 then
                0.0222
               when AQPA422agrup = 5 and sum(AQPA422asald) <= 10000 then
                0.0349
               when AQPA422agrup = 5 and sum(AQPA422asald) <= 20000 then
                0.0248
               when AQPA422agrup = 5 and sum(AQPA422asald) <= 30000 then
                0.0224
               when AQPA422agrup = 5 and sum(AQPA422asald) > 30000 then
                0.0205
               when AQPA422agrup = 6 then
                0.009
               when AQPA422agrup = 7 and sum(AQPA422asald) <= 8000 then
                0.0514
               when AQPA422agrup = 7 and sum(AQPA422asald) <= 15000 then
                0.0356
               when AQPA422agrup = 7 and sum(AQPA422asald) <= 45000 then
                0.0282
               when AQPA422agrup = 7 and sum(AQPA422asald) > 45000 then
                0.0222
             --when AQPA422agrup = 8 and pln_SegmntoActual = 1 then 0.044*0.02
             --when AQPA422agrup = 8 and pln_SegmntoActual = 2 then 0.044*0.03
               when AQPA422agrup = 9 then
                0.0017--17/02/2020 chernandez
               when AQPA422agrup = 10 then
                0
               when AQPA422agrup = 11 and sum(AQPA422asald) <= 8000 then
                0.0514
               when AQPA422agrup = 11 and sum(AQPA422asald) <= 15000 then
                0.0356
               when AQPA422agrup = 11 and sum(AQPA422asald) <= 45000 then
                0.0282
               when AQPA422agrup = 11 and sum(AQPA422asald) > 45000 then
                0.0222
               when AQPA422agrup = 12 and sum(AQPA422asald) <= 8000 then
                0.0514
               when AQPA422agrup = 12 and sum(AQPA422asald) <= 15000 then
                0.0356
               when AQPA422agrup = 12 and sum(AQPA422asald) <= 45000 then
                0.0282
               when AQPA422agrup = 12 and sum(AQPA422asald) > 45000 then
                0.0222
               when AQPA422agrup = 13 and sum(AQPA422asald) <= 8000 then
                0.0514
               when AQPA422agrup = 13 and sum(AQPA422asald) <= 15000 then
                0.0356
               when AQPA422agrup = 13 and sum(AQPA422asald) <= 45000 then
                0.0282
               when AQPA422agrup = 13 and sum(AQPA422asald) > 45000 then
                0.0222
             end factor
        from AQPA422a
       where AQPA422ainst = pn_instancia
         and AQPA422agrup <> 8
       group by AQPA422ainst, AQPA422agrup
       order by AQPA422agrup;
  
    cursor factores2(pln_SegmntoActual numeric) is
      select case
               when sum(AQPA422Bsald) / sum(AQPA422Bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.04
             
               when sum(AQPA422Bsald) / sum(AQPA422Bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.23
             
               when sum(AQPA422Bsald) / sum(AQPA422Bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.25
             
               when sum(AQPA422Bsald) / sum(AQPA422Bsalc) * 100 > 85 and
                    pln_SegmntoActual = 2 then
                0.044 * 0.32
             
               when sum(AQPA422Bsald) / sum(AQPA422Bsalc) * 100 <= 45 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.04
             
               when sum(AQPA422Bsald) / sum(AQPA422Bsalc) * 100 <= 65 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.25
             
               when sum(AQPA422Bsald) / sum(AQPA422Bsalc) * 100 <= 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.29
             
               when sum(AQPA422Bsald) / sum(AQPA422Bsalc) * 100 > 85 and
                    pln_SegmntoActual = 1 then
                0.044 * 0.34
             end factor
      
        from AQPA422B
       where AQPA422Binst = pn_instancia
         and AQPA422Btipo = 1
       group by AQPA422Binst;
  --chernandez 17/02/2020
    cursor factores3(pln_SegmntoActual numeric) is
      select case
             
               when sum(AQPA422bsald) / sum(AQPA422bsalc) * 100 <= 45 then
                0.09 * 0.03
             
               when sum(AQPA422bsald) / sum(AQPA422bsalc) * 100 <= 65 then
                0.09 * 0.07
             
               when sum(AQPA422bsald) / sum(AQPA422bsalc) * 100 <= 85 then
                0.09 * 0.19
             
               when sum(AQPA422bsald) / sum(AQPA422bsalc) * 100 > 85 then
                0.09 * 0.38
             end factor
      
        from AQPA422b
       where AQPA422binst = pn_instancia
         and AQPA422btipo = 2
       group by AQPA422binst;
  
    lc_CodSBS varchar2(10);
    ld_FchRCC date;
    --ln_tdocequi      number;
    ln_SegmntoActual number;
    ln_flag          number;
    lc_horaEjec      character(8);
    ld_dateEjec      date;
    ln_tipEje        number;
  
  begin
  
    begin
      delete AQPA422 where AQPA422.AQPA422inst = pn_instancia;
      commit;
      delete AQPA422a where AQPA422a.AQPA422ainst = pn_instancia;
      commit;
      delete AQPA422b where AQPA422b.AQPA422binst = pn_instancia;
      commit;
    
    end;
  
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
    end if;
  
    for d in documentos(ln_flag) loop
    
      lc_CodSBS := null;
    
      for rcc in CrCldrcci(d.ln_doc, FN_EQUIVALENCIADOC(d.petdoc)) loop
        lc_CodSBS := rcc.c_codsbs;
      end loop;
    
      if lc_CodSBS is not null then
      
        ln_tipEje := 1;
        SP_RCC_II(pn_instancia,
                  lc_CodSBS,
                  d.petdoc,
                  d.ln_doc,
                  ld_FchRCC,
                  ld_dateEjec,
                  lc_horaEjec);
      end if;
    end loop;
    commit;
  
    for r in factores(ln_SegmntoActual) loop
      insert into AQPA422
        (AQPA422INST, AQPA422FECH, AQPA422HORA, AQPA422GRUP, AQPA422FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, r.AQPA422agrup, r.factor);
    
    end loop;
  
    for n in factores2(ln_SegmntoActual) loop
      insert into AQPA422
        (AQPA422INST, AQPA422FECH, AQPA422HORA, AQPA422GRUP, AQPA422FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, 8, n.factor);
    end loop;
    --chernandez 17/02/2020
    for o in factores3(ln_SegmntoActual) loop
      insert into AQPA422
        (AQPA422INST, AQPA422FECH, AQPA422HORA, AQPA422GRUP, AQPA422FACT)
      values
        (pn_instancia, ld_dateEjec, lc_horaEjec, 15, o.factor);
    end loop;
    commit;
  
  end SP_INICIO_II;

  procedure SP_RCC_II(pn_instancia numeric,
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
           --chernandez 17/02/2020 modificacion de rubros
                       when REGEXP_LIKE(cuenta,
                                        '^14..020601|^14..130601|^14..120601') then
                        2
                       when REGEXP_LIKE(cuenta,
                                        '^14..03|^14..02|^14..12|^14..13') then
                        1

                     --when REGEXP_LIKE(cuenta, '^72.5') then 8 
                       else
                        0
                     end GRUPO
                from (select ff.AQPA422bcuen cuenta,
                             case
                               when substr(ff.AQPA422bcuen, 1, 2) = '14' then
                                sum(ff.AQPA422bsald)
                               else
                                sum(ff.AQPA422bsaln)
                             end saldo,
                             count(*) cant
                        from AQPA422b ff
                       where AQPA422bcsbs = lv_codsbs
                         and AQPA422binst = ln_inst
                       group by ff.AQPA422bcuen) cuenta)
       where GRUPO <> 0;
  
    lv_codsbs varchar2(10); --mod@abr 20190801
  begin
  
    SP_OBTENER_LINEAS_II(pn_instancia,
                         pv_CodSBS,
                         pd_FchRCC,
                         pd_dateEjec,
                         pc_horaEjec);
  
    for e in CrediPym(pv_CodSBS, pd_FchRCC) loop
      insert into AQPA422A
        (AQPA422Ainst,
         AQPA422Acsbs,
         AQPA422Acuen,
         AQPA422Agrup,
         AQPA422Atipo,
         AQPA422Asald,
         AQPA422Acont,
         AQPA422Afpre,
         AQPA422Atdoc,
         AQPA422Andoc,
         AQPA422AFECH,
         AQPA422AHORA)
      
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
      insert into AQPA422A
        (AQPA422Ainst,
         AQPA422Acsbs,
         AQPA422Acuen,
         AQPA422Agrup,
         AQPA422Atipo,
         AQPA422Asald,
         AQPA422Acont,
         AQPA422Afpre,
         AQPA422Atdoc,
         AQPA422Andoc,
         AQPA422AFECH,
         AQPA422AHORA)
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
  
  end SP_RCC_II;

  procedure SP_OBTENER_LINEAS_II(pn_instancia numeric,
                                 pv_codsbs    varchar2,
                                 pd_fec       date,
                                 pd_dateEjec  date,
                                 pc_horaEjec  character) is
  
    cursor lineas1 is
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
                 and REGEXP_LIKE(a.c_cuenta, '^72.506')--chernandez 17/02/2020
              
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
    ln_entro     numeric(5);--chernandez 17/02/2020
  
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
    ln_entro     := 0;--chernandez 17/02/2020
  
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
    
      SP_OBTENER_SALDO_LINEAS_II(pv_codsbs,
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
                              1,--chernandez 17/02/2020
                              ln_cuenta14,
                              ln_cuenta72,
                              ln_cuenta81);
    
      lc_codempANT := lc_codemp;
      ln_entro     := 1;--chernandez 17/02/2020
    end loop;
    if ln_entro = 1 then--chernandez 17/02/2020
      SP_OBTENER_SALDO_LINEAS_ULTEII(pv_codsbs,
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
    
      SP_OBTENER_SALDO_LINEAS_II(pv_codsbs,
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
      SP_OBTENER_SALDO_LINEAS_ULTEII(pv_codsbs,
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
  end SP_OBTENER_LINEAS_II;

  procedure SP_OBTENER_SALDO_LINEAS_II(pv_codsbs    varchar2,
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
                                       pn_tipo      in numeric,--chernandez 17/02/2020
                                       pn_cuenta14  in out varchar2,
                                       pn_cuenta72  in out varchar2,
                                       pn_cuenta81  in out varchar2) is
    pn_cuenta    varchar2(14);
    pn_cuentadol varchar2(14);
    pv_tipo72    varchar2(2);--chernandez 17/02/2020
    pv_tipo14    varchar2(4);--chernandez 17/02/2020 2
  begin
    --chernandez 17/02/2020
    if pn_tipo = 1 then
      pv_tipo72 := '06';
      pv_tipo14 := '';--chernandez 17/02/2020 2
    End if;
    if pn_tipo = 2 then
      pv_tipo72 := '03';
      pv_tipo14 := '0601';--chernandez 17/02/2020 2
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
    --chernandez 17/02/2020
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
    --chernandez 17/02/2020
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
        INSERT INTO AQPA422B
          (AQPA422Binst,
           AQPA422Bcsbs,
           AQPA422Bcemp,
           AQPA422Bcuen,
           AQPA422Bsald,
           AQPA422Bsalc,
           AQPA422Bsaln,
           AQPA422Bfpre,
           AQPA422Bhora,
           AQPA422Bfech,
           AQPA422Butil,
           AQPA422btipo)--chernandez 17/02/2020
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
           pn_tipo);--chernandez 17/02/2020
      end if;
    
      if pn_saldod14 <> 0 or pn_saldod72 <> 0 then
        --insertamos tabla auxiliar
        INSERT INTO AQPA422B
          (AQPA422Binst,
           AQPA422Bcsbs,
           AQPA422Bcemp,
           AQPA422Bcuen,
           AQPA422Bsald,
           AQPA422Bsalc,
           AQPA422Bsaln,
           AQPA422BFPRE,
           AQPA422Bhora,
           AQPA422Bfech,
           AQPA422Butil,
           AQPA422btipo)--chernandez 17/02/2020        
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
           pn_tipo);--chernandez 17/02/2020
      
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
  
  END SP_OBTENER_SALDO_LINEAS_II;

  procedure SP_OBTENER_SALDO_LINEAS_ULTEII(pv_codsbs    varchar2,
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
                                           pn_tipo      in numeric,--chernandez 17/02/2020
                                           pn_cuenta14  in out varchar2,
                                           pn_cuenta72  in out varchar2) is
  
    pn_cuenta    varchar2(14);
    pn_cuentadol varchar2(14);
    pv_tipo72    varchar2(2);--chernandez 17/02/2020
    pv_tipo14    varchar2(4);--chernandez 17/02/2020 2
  begin
    --chernandez 17/02/2020
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
    --chernandez 17/02/2020
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
    --chernandez 17/02/2020
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
      INSERT INTO AQPA422B
        (AQPA422Binst,
         AQPA422Bcsbs,
         AQPA422Bcemp,
         AQPA422Bcuen,
         AQPA422Bsald,
         AQPA422Bsalc,
         AQPA422Bsaln,
         AQPA422Bfpre,
         AQPA422Bhora,
         AQPA422Bfech,
         AQPA422Butil,
         AQPA422btipo)--chernandez 17/02/2020
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
         pn_tipo);--chernandez 17/02/2020
    end if;
  
    if pn_saldod14 <> 0 or pn_saldod72 <> 0 then
      --insertamos tabla auxiliar
      INSERT INTO AQPA422B
        (AQPA422Binst,
         AQPA422Bcsbs,
         AQPA422Bcemp,
         AQPA422Bcuen,
         AQPA422Bsald,
         AQPA422Bsalc,
         AQPA422Bsaln,
         AQPA422BFPRE,
         AQPA422Bhora,
         AQPA422Bfech,
         AQPA422Butil,
         aqpa422btipo)--chernandez 17/02/2020
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
         pn_tipo);--chernandez 17/02/2020
    
    End If;
  
  end SP_OBTENER_SALDO_LINEAS_ULTEII;
end PQ_CR_CALC_METSOBREEND_LIN;
/

