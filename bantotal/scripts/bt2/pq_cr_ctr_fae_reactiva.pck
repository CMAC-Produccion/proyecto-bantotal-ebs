create or replace package PQ_CR_CTR_FAE_REACTIVA is

  -- Author  : CHERNANDEZ
  -- Created : 21/09/2020 11:27:26
  -- Purpose : 
  function FN_EQUIVALENCIADOC(p_tdoc in number) return varchar2;
  procedure sp_verifica_reactiva(pn_ctnro   number,
                                 pn_tipo    number,
                                 pv_rpta    out varchar2,
                                 pv_rptaRcc out varchar2,
                                 pd_fecre   out date);
  procedure sp_es_fae(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_tpo in number,
                      pv_rpt out varchar2);

  procedure sp_es_fae_1(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_tpo in number,
                        pv_rpt out varchar2);

  procedure sp_es_fae1(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_tpo in number,
                       pv_rpt out varchar2,
                       pd_fec out date);

  procedure sp_es_fae2(pn_mod number, pn_tpo number, pv_rpt out varchar2);

  procedure sp_es_reactiva(pn_mod number,
                           pn_tpo number,
                           pv_rpt out varchar2);
  procedure sp_es_reactiva_rcc(pn_tdoc number,
                               pv_ndoc varchar2,
                               pv_rpt  out varchar2);
  procedure sp_verifica_fae1(pn_ctnro number, pv_rpta out varchar2);
  procedure sp_plazo_fae1(pn_emp   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_tpo   in number,
                          pd_feape in date,
                          pn_dias  out varchar2);
  procedure sp_verif_nofondo_mora(pn_ctnro  number,
                                  pd_pgfape date,
                                  pv_rpta   out varchar2);

  --*********************************************************
  procedure sp_es_fae_agro(pn_mod number,
                           pn_tpo number,
                           pv_rpt out varchar2);

  --*********************************************************
  procedure sp_verifica_fae_agro(pn_ctnro   number,
                                 pn_tipo    number,
                                 pv_rpta    out varchar2,
                                 pv_rptaRcc out varchar2,
                                 pd_fecre   out date);

  --*********************************************************
  procedure sp_pago_anticipado(pn_pgcod  in number,
                               pn_itmod  in number,
                               pn_itsuc  in number,
                               pn_ittran in number,
                               pn_itrel  in number,
                               pn_pgfape in date,
                               pn_cancuo out number,
                               pd_ppfpag out date);

  --*********************************************************
  procedure sp_ObtenerTipo(pn_pgcod in number,
                           pn_ctnro in number,
                           pn_conta out number,
                           pn_tipo  out number);

  --*********************************************************
  procedure sp_ObtenerPeriodo(pn_R1COD    in number,
                              pn_R1MOD    in number,
                              pn_R1SUC    in number,
                              pn_R1MDA    in number,
                              pn_R1PAP    in number,
                              pn_R1CTA    in number,
                              pn_R1OPER   in number,
                              pn_R1SBOP   in number,
                              pn_R1TOPE   in number,
                              pn_aoperiod out number,
                              pn_aostat   out number);

  --*********************************************************
  procedure sp_ObtenerRubro(pn_R1COD  in number,
                            pn_R1MOD  in number,
                            pn_R1SUC  in number,
                            pn_R1MDA  in number,
                            pn_R1PAP  in number,
                            pn_R1CTA  in number,
                            pn_R1OPER in number,
                            pn_R1SBOP in number,
                            pn_R1TOPE in number,
                            pn_Rubroc out number,
                            pc_Rubro  out varchar2);

  --*********************************************************
  procedure sp_Es_Negociacion(pn_Pgcod       in number,
                              pn_R1MOD       in number,
                              pn_R1SUC       in number,
                              pn_R1MDA       in number,
                              pn_R1PAP       in number,
                              pn_R1CTA       in number,
                              pn_R1OPER      in number,
                              pn_R1SBOP      in number,
                              pn_R1TOPE      in number,
                              pn_PgcodT      in number,
                              pn_Itsuc       in number,
                              pn_Itmod       in number,
                              pn_Ittran      in number,
                              pn_Itnrel      in number,
                              pd_pgfape      in date,
                              pc_Negociacion out varchar2);

  --*********************************************************
  procedure sp_Verificar_Credito(pn_Pgcod   in number,
                                 pn_Itsuc   in number,
                                 pn_Itmod   in number,
                                 pn_Ittran  in number,
                                 pn_Itnrel  in number,
                                 pn_Itord   in number,
                                 pn_Itsbor  in number,
                                 pd_pgfape  in date,
                                 pc_Pcancel out varchar2,
                                 pc_MsgRpta out varchar2);

  --*********************************************************
  procedure sp_Ver_Reactiva_Comp(pn_Pgcod   in number,
                                 pn_Itsuc   in number,
                                 pn_Itmod   in number,
                                 pn_Ittran  in number,
                                 pn_Itnrel  in number,
                                 pn_Itord   in number,
                                 pn_Itsbor  in number,
                                 pd_pgfape  in date,
                                 pc_Pcancel out varchar2,
                                 pc_MsgRpta out varchar2);

  --*********************************************************
  procedure sp_Ver_Fae_Comp(pn_Pgcod   in number,
                            pn_Itsuc   in number,
                            pn_Itmod   in number,
                            pn_Ittran  in number,
                            pn_Itnrel  in number,
                            pn_Itord   in number,
                            pn_Itsbor  in number,
                            pd_pgfape  in date,
                            pc_Pcancel out varchar2,
                            pc_MsgRpta out varchar2);

  --*********************************************************
  procedure sp_Ver_Pae_Mype_Comp(pn_Pgcod   in number,
                                 pn_Itsuc   in number,
                                 pn_Itmod   in number,
                                 pn_Ittran  in number,
                                 pn_Itnrel  in number,
                                 pn_Itord   in number,
                                 pn_Itsbor  in number,
                                 pd_pgfape  in date,
                                 pc_Pcancel out varchar2,
                                 pc_MsgRpta out varchar2);

  --*********************************************************    
  procedure sp_es_Pae_Mype(pn_mod number,
                           pn_tpo number,
                           pv_rpt out varchar2);

  --*********************************************************  
  procedure sp_es_Pae_Mype_rcc(pn_tdoc number,
                               pv_ndoc varchar2,
                               pv_rpt  out varchar2);

  --*********************************************************                               
  procedure sp_verifica_pae_mype(pn_ctnro   number,
                                 pn_tipo    number,
                                 pv_rpta    out varchar2,
                                 pv_rptaRcc out varchar2,
                                 pd_fecre   out date);

  --*********************************************************  
  procedure sp_fae_Rep_Ref(pn_R1COD  in number,
                           pn_R1MOD  in number,
                           pn_R1SUC  in number,
                           pn_R1MDA  in number,
                           pn_R1PAP  in number,
                           pn_R1CTA  in number,
                           pn_R1OPER in number,
                           pn_R1SBOP in number,
                           pn_R1TOPE in number,
                           pc_FLAGRR OUT VARCHAR2);

end PQ_CR_CTR_FAE_REACTIVA;
/

create or replace package body PQ_CR_CTR_FAE_REACTIVA is

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

  procedure sp_verifica_reactiva(pn_ctnro   number,
                                 pn_tipo    number,
                                 pv_rpta    out varchar2,
                                 pv_rptaRcc out varchar2,
                                 pd_fecre   out date) is
    cursor integrantes(pn_tipoI in number) is
      select distinct f.PEPAIS, f.PETDOC, f.pendoc ln_doc
        from fsr008 f
       where f.ctnro = pn_ctnro
         and f.cttfir = 'T'
      union
      select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro = pn_ctnro
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and f.cttfir = 'T'
         and 2 = pn_tipoI --pn_tipo  24062021
      union
      select distinct g.pepais, g.petdoc, g.pendoc ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro = pn_ctnro
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and f.cttfir = 'T'
         and 2 = pn_tipoI; --pn_tipo  24062021
    --    cursor cuentas is  24062021
    cursor cuentas(pn_TipoI in number) is
      select x.ctnro, x.pepais, x.PETDOC, x.pendoc
        from fsr008 x
       where (PEPAIS, PETDOC, pendoc) in
             (select distinct f.PEPAIS, f.PETDOC, f.pendoc ln_doc
                from fsr008 f
               where f.ctnro = pn_ctnro
                 and f.cttfir = 'T'
              union
              select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.pepais
                 and f.petdoc = g.petdoc
                 and f.pendoc = g.pendoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
                 and 2 = pn_tipoI --pn_tipo  24062021
              union
              select distinct g.pepais, g.petdoc, g.pendoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.rppais
                 and f.petdoc = g.rptdoc
                 and f.pendoc = g.rpndoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
                 and 2 = pn_tipoI) --pn_tipo)  24062021
         and cttfir = 'T';
  
    cursor creditos(lpn_cta numeric) is
      select c.*, cc.pepais, cc.petdoc, cc.pendoc
        from fsd010 c, fsr008 cc
       where cc.pgcod = c.pgcod
         and cc.ctnro = c.aocta
         and cc.cttfir = 'T'
         and c.pgcod = 1
         and c.aomod in (select modulo from fst111 where dscod = 50)
         and c.aostat <> 99
         and c.aocta = lpn_cta;
  
    lv_rpta   varchar2(1);
    lv_rpta2  varchar2(1);
    ld_fec601 date;
  
    ln_tipo number; --24062021
  begin
    pv_rpta    := 'N';
    pv_rptaRcc := 'N';
  
    --validar tipo 24062021
    ln_tipo := 0;
    begin
      select count(*) + pn_tipo
        into ln_tipo
        from (select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.pepais
                 and f.petdoc = g.petdoc
                 and f.pendoc = g.pendoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
              union
              select distinct g.pepais, g.petdoc, g.pendoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.rppais
                 and f.petdoc = g.rptdoc
                 and f.pendoc = g.rpndoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T');
    exception
      when others then
        ln_tipo := 1;
    end;
    --fin validar 24062021
  
    --    for i in cuentas loop  24062021
    for i in cuentas(ln_tipo) loop
      for j in creditos(i.ctnro) loop
        lv_rpta := 'N';
        sp_es_reactiva(j.aomod, j.aotope, lv_rpta);
        if lv_rpta = 'S' then
          select min(a.ppfpag)
            into ld_fec601
            from fsd601 a
           where pgcod = j.pgcod
             and ppmod = j.aomod
             and ppsuc = j.aosuc
             and ppmda = j.aomda
             and pppap = j.aopap
             and ppcta = j.aocta
             and ppoper = j.aooper
             and ppsbop = j.aosbop
             and pptope = j.aotope
             and d601co = 'S'
             and pptipo <> 'K'
             and not exists (select *
                    from fsd602 b
                   where b.pgcod = a.pgcod
                     and b.ppmod = a.ppmod
                     and b.ppsuc = a.ppsuc
                     and b.ppmda = a.ppmda
                     and b.pppap = a.pppap
                     and b.ppcta = a.ppcta
                     and b.ppoper = a.ppoper
                     and b.ppsbop = a.ppsbop
                     and b.pptope = a.pptope
                     and b.ppfpag = a.ppfpag
                     and b.d602co = 'S'
                     and b.pp1stat = 'T');
          if pd_fecre is null or pd_fecre > ld_fec601 then
            pd_fecre := ld_fec601;
          end if;
          pv_rpta := 'S';
        end if;
      end loop;
    end loop;
  
    --    for k in integrantes loop  --24062021
    for k in integrantes(ln_tipo) loop
      lv_rpta2 := 'N';
      sp_es_reactiva_rcc(k.petdoc, trim(k.ln_doc), lv_rpta2);
      if lv_rpta2 = 'S' then
        pv_rptaRcc := 'S';
      end if;
    end loop;
    rollback;
  end sp_verifica_reactiva;

  procedure sp_es_fae(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_tpo in number,
                      pv_rpt out varchar2) is
    ln_fae1 number(3);
  begin
    pv_rpt := 'N';
    --EFUENTES 20220419 SE MODIFICO VALIDACION 
    begin
      select nvl(count(*), 0)
        into ln_fae1
        from aqpb067b a
       where a.AQPB067BCOD = pn_emp
         and a.AQPB067BMOD in (select modulo from fst111 where dscod = 50)
         and a.AQPB067BMDA = pn_mda
         and a.AQPB067BPAP = pn_pap
         and a.AQPB067BCTA = pn_cta
         and a.AQPB067BOPE = pn_ope
         and a.aqpb067best <> 'D';
    exception
      when others then
        ln_fae1 := 0;
    end;
  
    /*if pn_mod = 101 and pn_tpo = 354 then
      pv_rpt := 'S';
    end if;
    select nvl(count(*), 0)
      into ln_fae1
      from fsr011
     where r1cod = pn_emp
       --and r1mod = pn_mod
       and r1mod in (select modulo from fst111 where dscod = 50 )
       --and r1suc = pn_suc
       and r1mda = pn_mda
       and r1pap = pn_pap
       and r1cta = pn_cta
       and r1oper = pn_ope
       --and r1sbop = pn_sbo
       --and r1tope = pn_tpo
       and relcod = 30
       and r2cta = 8523
       and r011co = 'S';*/
    if ln_fae1 > 0 then
      pv_rpt := 'S';
    end if;
  end sp_es_fae;

  --EFUENTES 20220419 SE CREO NUEVO PROCEDIMIENTO
  procedure sp_es_fae_1(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_tpo in number,
                        pv_rpt out varchar2) is
    ln_fae1 number(3);
  begin
    pv_rpt := 'N';
  
    begin
      select nvl(count(*), 0)
        into ln_fae1
        from aqpb067b a
       where a.AQPB067BCOD = pn_emp
         and a.AQPB067BMOD in (select modulo from fst111 where dscod = 50)
         and a.AQPB067BMDA = pn_mda
         and a.AQPB067BPAP = pn_pap
         and a.AQPB067BCTA = pn_cta
         and a.AQPB067BOPE = pn_ope
         and a.aqpb067btop <> 354
         and a.aqpb067best <> 'D';
    exception
      when others then
        ln_fae1 := 0;
    end;
  
    if ln_fae1 > 0 then
      pv_rpt := 'S';
    end if;
  end sp_es_fae_1;

  procedure sp_es_fae2(pn_mod number, pn_tpo number, pv_rpt out varchar2) is
  begin
    if pn_mod = 101 and pn_tpo = 354 then
      pv_rpt := 'S';
    else
      pv_rpt := 'N';
    end if;
  end sp_es_fae2;

  procedure sp_es_reactiva(pn_mod number,
                           pn_tpo number,
                           pv_rpt out varchar2) is
  begin
    if pn_mod = 101 and pn_tpo = 353 then
      pv_rpt := 'S';
    else
      pv_rpt := 'N';
    end if;
  end sp_es_reactiva;

  procedure sp_es_reactiva_rcc(pn_tdoc number,
                               pv_ndoc varchar2,
                               pv_rpt  out varchar2) is
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
  
    lc_CodSBS varchar2(10);
    ld_FchRCC date;
    ln_cont   numeric(5);
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
    lc_CodSBS := null;
    pv_rpt    := 'N';
    for rcc in CrCldrcci(pv_ndoc, FN_EQUIVALENCIADOC(pn_tdoc)) loop
      lc_CodSBS := rcc.c_codsbs;
      if lc_CodSBS is not null then
        select nvl(count(*), 0)
          into ln_cont
          from cldrccs c
         where c.c_codsbs = lc_CodSBS
           and d_fecpre = ld_FchRCC
           and c_cuenta like '81_8%' --se modifico para permitir soles y dolares 08032021
           and c_codemp <> '00104';
        if ln_cont > 0 then
          pv_rpt := 'S';
        end if;
      end if;
    end loop;
  
  end sp_es_reactiva_rcc;

  --chernandez 06/10/2020

  procedure sp_es_fae1(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_tpo in number,
                       pv_rpt out varchar2,
                       pd_fec out date) is
    ln_fae1 NUMBER := 0;
  begin
    --EFUENTES 20220419 SE MODIFICO VALIDACION 
    /*select r011fc
      into pd_fec
      from fsr011
     where r1cod = pn_emp
       --and r1mod = pn_mod
       and r1mod in (select modulo from fst111 where dscod = 50 )
       --and r1suc = pn_suc
       and r1mda = pn_mda
       and r1pap = pn_pap
       and r1cta = pn_cta
       and r1oper = pn_ope
       --and r1sbop = pn_sbo
       --and r1tope = pn_tpo
       and relcod = 30
       and r2cta = 8523
       and r011co = 'S';
    pv_rpt := 'S';*/
    sp_es_fae_1(pn_emp,
                pn_mod,
                pn_suc,
                pn_mda,
                pn_pap,
                pn_cta,
                pn_ope,
                pn_sbo,
                pn_tpo,
                pv_rpt);
  exception
    when others then
      pv_rpt := 'N';
      pd_fec := null;
  end sp_es_fae1;

  procedure sp_verifica_fae1(pn_ctnro number, pv_rpta out varchar2) is
  
    cursor cuentas is
      select x.ctnro, x.pepais, x.PETDOC, x.pendoc
        from fsr008 x
       where (PEPAIS, PETDOC, pendoc) in
             (select distinct f.PEPAIS, f.PETDOC, f.pendoc ln_doc
                from fsr008 f
               where f.ctnro = pn_ctnro
                 and f.cttfir = 'T')
         and cttfir = 'T';
  
    cursor creditos(lpn_cta numeric) is
      select c.*
        from fsd010 c
       where c.pgcod = 1
         and c.aomod in (select modulo from fst111 where dscod = 50)
         and c.aostat <> 99
         and c.aocta = lpn_cta;
  
    lv_rpta   varchar2(1);
    ld_fec601 date;
  begin
    pv_rpta := 'N';
    for i in cuentas loop
      for j in creditos(i.ctnro) loop
        lv_rpta := 'N';
        /*sp_es_fae1(j.pgcod,
        j.aomod,
        j.aosuc,
        j.aomda,
        j.aopap,
        j.aocta,
        j.aooper,
        j.aosbop,
        j.aotope,
        lv_rpta,
        ld_fec601);*/
        sp_es_fae_1(j.pgcod,
                    j.aomod,
                    j.aosuc,
                    j.aomda,
                    j.aopap,
                    j.aocta,
                    j.aooper,
                    j.aosbop,
                    j.aotope,
                    lv_rpta);
        if lv_rpta = 'S' then
          pv_rpta := 'S';
        end if;
      end loop;
    
    end loop;
  end sp_verifica_fae1;

  procedure sp_plazo_fae1(pn_emp   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_tpo   in number,
                          pd_feape in date,
                          pn_dias  out varchar2) is
  
    lv_rpta   varchar2(1);
    ld_fec601 date;
  begin
    lv_rpta := 'N';
    pn_dias := 0;
    sp_es_fae1(pn_emp,
               pn_mod,
               pn_suc,
               pn_mda,
               pn_pap,
               pn_cta,
               pn_ope,
               pn_sbo,
               pn_tpo,
               lv_rpta,
               ld_fec601);
    if lv_rpta = 'S' then
      select add_months(ld_fec601, 36) - ld_fec601 - (pd_feape - ld_fec601)
        into pn_dias
        from dual;
    end if;
  end sp_plazo_fae1;

  procedure sp_verif_nofondo_mora(pn_ctnro  number,
                                  pd_pgfape date,
                                  pv_rpta   out varchar2) is
  
    cursor cuentas is
      select x.ctnro, x.pepais, x.PETDOC, x.pendoc
        from fsr008 x
       where (PEPAIS, PETDOC, pendoc) in
             (select distinct f.PEPAIS, f.PETDOC, f.pendoc ln_doc
                from fsr008 f
               where f.ctnro = pn_ctnro
                 and f.cttfir = 'T')
         and cttfir = 'T';
  
    cursor creditos(lpn_cta numeric) is
      select c.*
        from fsd010 c
       where c.pgcod = 1
         and c.aomod in (select modulo from fst111 where dscod = 50)
         and c.aostat <> 99
         and c.aocta = lpn_cta;
  
    ld_fec601 date;
    lv_fae1   varchar2(1);
    lv_fae2   varchar2(1);
    lv_reac   varchar2(1);
    ln_dias   number(9);
  begin
  
    pv_rpta := 'N';
    for i in cuentas loop
      for j in creditos(i.ctnro) loop
        lv_fae1 := 'N';
      
        sp_es_fae1(j.pgcod,
                   j.aomod,
                   j.aosuc,
                   j.aomda,
                   j.aopap,
                   j.aocta,
                   j.aooper,
                   j.aosbop,
                   j.aotope,
                   lv_fae1,
                   ld_fec601);
      
        lv_fae2 := 'N';
        sp_es_fae2(j.aomod, j.aotope, lv_fae2);
      
        lv_reac := 'N';
        sp_es_reactiva(j.aomod, j.aotope, lv_reac);
      
        if lv_fae1 = 'N' and lv_fae2 = 'N' and lv_reac = 'N' then
          ln_dias := 0;
          sp_cr_dias_atraso_vigente(j.pgcod,
                                    j.aomod,
                                    j.aosuc,
                                    j.aomda,
                                    j.aopap,
                                    j.aocta,
                                    j.aooper,
                                    j.aosbop,
                                    j.aotope,
                                    pd_pgfape,
                                    ln_dias);
          if ln_dias > 0 then
            pv_rpta := 'S';
          end if;
        end if;
      
      end loop;
    
    end loop;
  end sp_verif_nofondo_mora;

  --*********************************************************
  --EFUENTES INICIO
  procedure sp_es_fae_agro(pn_mod number,
                           pn_tpo number,
                           pv_rpt out varchar2) is
  begin
    if pn_mod = 116 and pn_tpo = 20 then
      pv_rpt := 'S';
    else
      pv_rpt := 'N';
    end if;
  end sp_es_fae_agro;

  --*********************************************************
  procedure sp_verifica_fae_agro(pn_ctnro   number,
                                 pn_tipo    number,
                                 pv_rpta    out varchar2,
                                 pv_rptaRcc out varchar2,
                                 pd_fecre   out date) is
    cursor integrantes(pn_tipoI in number) is
      select distinct f.PEPAIS, f.PETDOC, f.pendoc ln_doc
        from fsr008 f
       where f.ctnro = pn_ctnro
         and f.cttfir = 'T'
      union
      select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro = pn_ctnro
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and f.cttfir = 'T'
         and 2 = pn_tipoI --pn_tipo  24062021
      union
      select distinct g.pepais, g.petdoc, g.pendoc ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro = pn_ctnro
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and f.cttfir = 'T'
         and 2 = pn_tipoI; --pn_tipo  24062021
  
    cursor cuentas(pn_TipoI in number) is
      select x.ctnro, x.pepais, x.PETDOC, x.pendoc
        from fsr008 x
       where (PEPAIS, PETDOC, pendoc) in
             (select distinct f.PEPAIS, f.PETDOC, f.pendoc ln_doc
                from fsr008 f
               where f.ctnro = pn_ctnro
                 and f.cttfir = 'T'
              union
              select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.pepais
                 and f.petdoc = g.petdoc
                 and f.pendoc = g.pendoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
                 and 2 = pn_tipoI --pn_tipo  24062021
              union
              select distinct g.pepais, g.petdoc, g.pendoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.rppais
                 and f.petdoc = g.rptdoc
                 and f.pendoc = g.rpndoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
                 and 2 = pn_tipoI) --pn_tipo)  24062021
         and cttfir = 'T';
  
    cursor creditos(lpn_cta numeric) is
      select c.*, cc.pepais, cc.petdoc, cc.pendoc
        from fsd010 c, fsr008 cc
       where cc.pgcod = c.pgcod
         and cc.ctnro = c.aocta
         and cc.cttfir = 'T'
         and c.pgcod = 1
         and c.aomod in (select modulo from fst111 where dscod = 50)
         and c.aostat <> 99
         and c.aocta = lpn_cta;
  
    lv_rpta varchar2(1);
    --lv_rpta2  varchar2(1);
    ld_fec601 date;
  
    ln_tipo number;
  begin
    pv_rpta    := 'N';
    pv_rptaRcc := 'N';
  
    ln_tipo := 0;
    begin
      select count(*) + pn_tipo
        into ln_tipo
        from (select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.pepais
                 and f.petdoc = g.petdoc
                 and f.pendoc = g.pendoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
              union
              select distinct g.pepais, g.petdoc, g.pendoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.rppais
                 and f.petdoc = g.rptdoc
                 and f.pendoc = g.rpndoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T');
    exception
      when others then
        ln_tipo := 1;
    end;
  
    for i in cuentas(ln_tipo) loop
      for j in creditos(i.ctnro) loop
        lv_rpta := 'N';
        sp_es_fae_agro(j.aomod, j.aotope, lv_rpta);
        if lv_rpta = 'S' then
          select min(a.ppfpag)
            into ld_fec601
            from fsd601 a
           where pgcod = j.pgcod
             and ppmod = j.aomod
             and ppsuc = j.aosuc
             and ppmda = j.aomda
             and pppap = j.aopap
             and ppcta = j.aocta
             and ppoper = j.aooper
             and ppsbop = j.aosbop
             and pptope = j.aotope
             and d601co = 'S'
             and pptipo <> 'K'
             and not exists (select *
                    from fsd602 b
                   where b.pgcod = a.pgcod
                     and b.ppmod = a.ppmod
                     and b.ppsuc = a.ppsuc
                     and b.ppmda = a.ppmda
                     and b.pppap = a.pppap
                     and b.ppcta = a.ppcta
                     and b.ppoper = a.ppoper
                     and b.ppsbop = a.ppsbop
                     and b.pptope = a.pptope
                     and b.ppfpag = a.ppfpag
                     and b.d602co = 'S'
                     and b.pp1stat = 'T');
          if pd_fecre is null or pd_fecre > ld_fec601 then
            pd_fecre := ld_fec601;
          end if;
          pv_rpta := 'S';
        end if;
      end loop;
    end loop;
  
    /*
    for k in integrantes(ln_tipo) loop
      lv_rpta2 := 'N';
      sp_es_reactiva_rcc(k.petdoc, trim(k.ln_doc), lv_rpta2);
      if lv_rpta2 = 'S' then
        pv_rptaRcc := 'S';
      end if;
    end loop;
    */
    rollback;
  end sp_verifica_fae_agro;

  --*********************************************************
  procedure sp_pago_anticipado(pn_pgcod  in number,
                               pn_itmod  in number,
                               pn_itsuc  in number,
                               pn_ittran in number,
                               pn_itrel  in number,
                               pn_pgfape in date,
                               pn_cancuo out number,
                               pd_ppfpag out date) is
    cursor Fec_Pago(pgcod  number,
                    itmod  number,
                    itsuc  number,
                    ittran number,
                    itrel  number,
                    pgfape date) is
      SELECT C.Ppfpag,
             C.D602cd,
             C.D602mo,
             C.D602su,
             C.D602tr,
             C.D602re,
             C.D602fc
        FROM fsd602 C
       Where D602cd = pgcod
         AND D602mo = itmod
         AND D602su = itsuc
         AND D602tr = ittran
         AND D602re = itrel
         AND D602fc = pgfape
       ORDER BY D602cd, D602mo, D602su, D602tr, D602re, D602fc;
  
  begin
  
    begin
      for i in Fec_Pago(pn_pgcod,
                        pn_itmod,
                        pn_itsuc,
                        pn_ittran,
                        pn_itrel,
                        pn_pgfape) loop
        pd_ppfpag := i.Ppfpag;
      end loop;
    exception
      when others then
        pd_ppfpag := null;
    end;
  
    begin
      select count(*)
        into pn_cancuo
        from fsd602
       Where D602cd = pn_pgcod
         And D602mo = pn_itmod
         And D602su = pn_itsuc
         And D602tr = pn_ittran
         And D602re = pn_itrel
         And D602fc = pn_pgfape;
    exception
      when others then
        pn_cancuo := 0;
    end;
  end sp_pago_anticipado;

  --*********************************************************
  procedure sp_ObtenerTipo(pn_pgcod in number,
                           pn_ctnro in number,
                           pn_conta out number,
                           pn_tipo  out number) is
  
  begin
    begin
      select count(*)
        into pn_conta
        from fsr008
       Where Pgcod = pn_pgcod
         and Ctnro = pn_ctnro;
    exception
      when others then
        pn_conta := 0;
    end;
  
    if pn_conta = 1 then
      pn_tipo := 1;
    else
      pn_tipo := 2;
    end if;
  
  end sp_ObtenerTipo;

  --*********************************************************
  procedure sp_ObtenerPeriodo(pn_R1COD    in number,
                              pn_R1MOD    in number,
                              pn_R1SUC    in number,
                              pn_R1MDA    in number,
                              pn_R1PAP    in number,
                              pn_R1CTA    in number,
                              pn_R1OPER   in number,
                              pn_R1SBOP   in number,
                              pn_R1TOPE   in number,
                              pn_aoperiod out number,
                              pn_aostat   out number) is
  begin
    begin
      select Aoperiod, Aostat
        into pn_aoperiod, pn_aostat
        from fsd010
       where Pgcod = pn_R1COD
         AND Aomod = pn_R1MOD
         AND Aosuc = pn_R1SUC
         AND Aomda = pn_R1MDA
         AND Aopap = pn_R1PAP
         AND Aocta = pn_R1CTA
         AND Aooper = pn_R1OPER
         AND Aosbop = pn_R1SBOP
         AND Aotope = pn_R1TOPE;
    exception
      when others then
        pn_aoperiod := 30;
    end;
  
  end sp_ObtenerPeriodo;

  --*********************************************************
  procedure sp_ObtenerRubro(pn_R1COD  in number,
                            pn_R1MOD  in number,
                            pn_R1SUC  in number,
                            pn_R1MDA  in number,
                            pn_R1PAP  in number,
                            pn_R1CTA  in number,
                            pn_R1OPER in number,
                            pn_R1SBOP in number,
                            pn_R1TOPE in number,
                            pn_Rubroc out number,
                            pc_Rubro  out varchar2) is
    lc_Rubro VARCHAR2(16);
  begin
    begin
      select Scrub
        into pn_Rubroc
        from fsd011
       where Pgcod = pn_R1COD
         AND Scmod = pn_R1MOD
         AND Scsuc = pn_R1SUC
         AND Scmda = pn_R1MDA
         AND Scpap = pn_R1PAP
         AND Sccta = pn_R1CTA
         AND Scoper = pn_R1OPER
         AND Scsbop = pn_R1SBOP
         AND Sctope = pn_R1TOPE;
    
      lc_Rubro := CAST(pn_Rubroc AS VARCHAR2);
      pc_Rubro := SUBSTR(lc_Rubro, 1, 4);
    exception
      when others then
        pn_Rubroc := '';
        pc_Rubro  := '';
    end;
  
  end sp_ObtenerRubro;

  --*********************************************************
  procedure sp_Es_Negociacion(pn_Pgcod       in number,
                              pn_R1MOD       in number,
                              pn_R1SUC       in number,
                              pn_R1MDA       in number,
                              pn_R1PAP       in number,
                              pn_R1CTA       in number,
                              pn_R1OPER      in number,
                              pn_R1SBOP      in number,
                              pn_R1TOPE      in number,
                              pn_PgcodT      in number,
                              pn_Itsuc       in number,
                              pn_Itmod       in number,
                              pn_Ittran      in number,
                              pn_Itnrel      in number,
                              pd_pgfape      in date,
                              pc_Negociacion out varchar2) is
    ln_contador number;
  begin
    begin
      select count(*)
        into ln_contador
        from fsd012
       Where Pgcod = pn_Pgcod
         AND Aomod = pn_R1MOD
         AND Aosuc = pn_R1SUC
         AND Aomda = pn_R1MDA
         AND Aopap = pn_R1PAP
         AND Aocta = pn_R1CTA
         AND Aooper = pn_R1OPER
         AND Aosbop = pn_R1SBOP
         AND Aotope = pn_R1TOPE
         AND D012cd = pn_PgcodT
         AND D012su = pn_Itsuc
         AND D012mo = pn_Itmod
         AND D012tr = pn_Ittran
         AND D012re = pn_Itnrel
         AND D012fc = pd_pgfape
         AND Evtipo in (31, 50);
    
      if ln_contador > 0 then
        pc_Negociacion := 'S';
      else
        pc_Negociacion := 'N';
      end if;
    
    exception
      when others then
        pc_Negociacion := 'N';
    end;
  
  end sp_Es_Negociacion;

  --*********************************************************
  procedure sp_Verificar_Credito(pn_Pgcod   in number,
                                 pn_Itsuc   in number,
                                 pn_Itmod   in number,
                                 pn_Ittran  in number,
                                 pn_Itnrel  in number,
                                 pn_Itord   in number,
                                 pn_Itsbor  in number,
                                 pd_pgfape  in date,
                                 pc_Pcancel out varchar2,
                                 pc_MsgRpta out varchar2) is
  
  begin
    pc_Pcancel := 'N';
    pc_MsgRpta := '';
  
    sp_Ver_Reactiva_Comp(pn_Pgcod,
                         pn_Itsuc,
                         pn_Itmod,
                         pn_Ittran,
                         pn_Itnrel,
                         pn_Itord,
                         pn_Itsbor,
                         pd_pgfape,
                         pc_Pcancel,
                         pc_MsgRpta);
  
    If pc_Pcancel = 'N' then
      sp_Ver_Fae_Comp(pn_Pgcod,
                      pn_Itsuc,
                      pn_Itmod,
                      pn_Ittran,
                      pn_Itnrel,
                      pn_Itord,
                      pn_Itsbor,
                      pd_pgfape,
                      pc_Pcancel,
                      pc_MsgRpta);
    End If;
  
    If pc_Pcancel = 'N' then
      sp_Ver_Pae_Mype_Comp(pn_Pgcod,
                           pn_Itsuc,
                           pn_Itmod,
                           pn_Ittran,
                           pn_Itnrel,
                           pn_Itord,
                           pn_Itsbor,
                           pd_pgfape,
                           pc_Pcancel,
                           pc_MsgRpta);
    End If;
  
  end sp_Verificar_Credito;

  --*********************************************************
  procedure sp_Ver_Reactiva_Comp(pn_Pgcod   in number,
                                 pn_Itsuc   in number,
                                 pn_Itmod   in number,
                                 pn_Ittran  in number,
                                 pn_Itnrel  in number,
                                 pn_Itord   in number,
                                 pn_Itsbor  in number,
                                 pd_pgfape  in date,
                                 pc_Pcancel out varchar2,
                                 pc_MsgRpta out varchar2) is
    ln_puedePagar number(1);
  
    ld_pgfape date;
  
    ln_R1MOD  number;
    ln_R1TOPE number;
    ln_R1SUC  number;
    ln_R1MDA  number;
    ln_R1PAP  number;
    ln_R1CTA  number;
    ln_R1OPER number;
    ln_R1SBOP number;
    ln_R1COD  number;
  
    lc_tiene_reactiva varchar2(1);
  
    ln_contador number(10);
    ln_tipo     number(5);
  
    lc_int_tiene_reactiva    varchar2(1);
    lc_int_tiene_reactivaRcc varchar2(1);
  
    ld_pfpagRe date;
  
    ln_cantCuotas number;
    ld_ppfpag     date;
  
    ln_aoperiod number;
    ln_aostat   number;
  
    ln_Rubroc number(16);
    lc_Rubro  varchar2(4);
  
    lc_Negociacion varchar2(1);
  
    ld_fechaTmp1 date;
    ld_fechaTmp2 date;
  
    ln_eval_reactiva number(9);
    lc_esReact       char(1);
  
  begin
    pc_Pcancel    := 'N';
    pc_MsgRpta    := '';
    ln_puedePagar := 1;
    /*
    -- buscar fecha 
    begin
      select Pgfape into ld_pgfape
      from fst017
      Where Pgcod = 1;
    exception when others then
      ld_pgfape  := null;
    end;
    */
    ld_pgfape := pd_pgfape;
  
    -- buscar clave credito 
    begin
      ln_R1COD := pn_Pgcod;
      select Modulo, Ittope, Itsucd, Moneda, Papel, Ctnro, Itoper, Itsubo
        into ln_R1MOD,
             ln_R1TOPE,
             ln_R1SUC,
             ln_R1MDA,
             ln_R1PAP,
             ln_R1CTA,
             ln_R1OPER,
             ln_R1SBOP
        from FSD016
       Where Pgcod = pn_Pgcod
         AND Itsuc = pn_Itsuc
         AND Itmod = pn_Itmod
         AND Ittran = pn_Ittran
         AND Itnrel = pn_Itnrel
         AND Itord = pn_Itord;
    exception
      when others then
        null;
    end;
    ln_eval_reactiva := 1;
    begin
      select tp1nro1
        into ln_eval_reactiva
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 5
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_eval_reactiva := 1;
    end;
    if ln_eval_reactiva = 1 then
    
      --Do 'Verifica Rectiva'
      sp_es_reactiva(ln_R1MOD, ln_R1TOPE, lc_tiene_reactiva);
    
      if lc_tiene_reactiva = 'N' then
        --Do 'ObtenerTipo'
        sp_ObtenerTipo(ln_R1COD, ln_R1CTA, ln_contador, ln_tipo);
      
        --sp_verifica_reactiva(in, in, out, out, out)      
        sp_verifica_reactiva(ln_R1CTA,
                             ln_tipo,
                             lc_int_tiene_reactiva,
                             lc_int_tiene_reactivaRcc,
                             ld_pfpagRe);
      
        --Do 'Verificar Pago Anticipado'    
        ln_cantCuotas := 0;
        --sp_pago_anticipado(in, in, in, in, in, in, out, out)
        sp_pago_anticipado(pn_Pgcod,
                           pn_Itmod,
                           pn_Itsuc,
                           pn_Ittran,
                           pn_Itnrel,
                           ld_pgfape,
                           ln_cantCuotas,
                           ld_ppfpag);
      
        --Do 'Obtener periodo'
        ln_aoperiod := 30;
        sp_ObtenerPeriodo(ln_R1COD,
                          ln_R1MOD,
                          ln_R1SUC,
                          ln_R1MDA,
                          ln_R1PAP,
                          ln_R1CTA,
                          ln_R1OPER,
                          ln_R1SBOP,
                          ln_R1TOPE,
                          ln_aoperiod,
                          ln_aostat);
        sp_ObtenerRubro(ln_R1COD,
                        ln_R1MOD,
                        ln_R1SUC,
                        ln_R1MDA,
                        ln_R1PAP,
                        ln_R1CTA,
                        ln_R1OPER,
                        ln_R1SBOP,
                        ln_R1TOPE,
                        ln_Rubroc,
                        lc_Rubro);
      
        ld_fechaTmp1 := last_day(ld_pgfape) + ln_aoperiod;
        If ld_ppfpag > ld_fechaTmp1 then
          ln_puedePagar := 0;
          pc_MsgRpta    := 'Reactivae';
        
          if lc_int_tiene_reactivaRcc = 'S' then
            pc_MsgRpta := 'Reactiva (en otra entidad)';
          end if;
        
          if lc_int_tiene_reactiva <> 'S' and
             lc_int_tiene_reactivaRcc <> 'S' then
            ln_puedePagar := 1;
            pc_MsgRpta    := '';
          end if;
        else
          if (lc_int_tiene_reactiva = 'S' or lc_int_tiene_reactivaRcc = 'S') and
             ld_pfpagRe is not null then
            ld_fechaTmp2 := ld_pfpagRe + ln_aoperiod;
            --if ld_pfpagRe < ld_ppfpag then 
            --if ld_fechaTmp2 < ld_ppfpag then
            if ld_fechaTmp2 < ld_pgfape then
              ln_puedePagar := 0;
              pc_MsgRpta    := 'Reactiva';
              if lc_int_tiene_reactivaRcc = 'S' then
                pc_MsgRpta := 'Reactiva (en otra entidad)';
              end if;
              if lc_int_tiene_reactiva = 'S' or
                 lc_int_tiene_reactivaRcc = 'S' then
                DBMS_OUTPUT.put_line('PAQPB015 &int_tiene_reactivaRcc: entro :');
                DBMS_OUTPUT.put_line(lc_int_tiene_reactiva);
              End If;
            end if;
            --Do 'Es_Negociacion'
            lc_Negociacion := 'N';
            --sp_Es_Negociacion(in, in, in, in, in, in, in, in, in, in, in, in, in, in, in, out)
            sp_Es_Negociacion(pn_Pgcod,
                              ln_R1MOD,
                              ln_R1SUC,
                              ln_R1MDA,
                              ln_R1PAP,
                              ln_R1CTA,
                              ln_R1OPER,
                              ln_R1SBOP,
                              ln_R1TOPE,
                              pn_Pgcod,
                              pn_Itsuc,
                              pn_Itmod,
                              pn_Ittran,
                              pn_Itnrel,
                              ld_pgfape,
                              lc_Negociacion);
            if lc_Negociacion = 'S' or (pn_Itmod = 30 and pn_Ittran = 150) then
              --&cantCuotas >= 2
              ln_puedePagar := 0;
              pc_MsgRpta    := 'Reactiva';
            End If;
          End If;
        end if;
        if (lc_int_tiene_reactiva = 'S' or lc_int_tiene_reactivaRcc = 'S') then
          --Do 'Es_Negociacion'
          sp_Es_Negociacion(pn_Pgcod,
                            ln_R1MOD,
                            ln_R1SUC,
                            ln_R1MDA,
                            ln_R1PAP,
                            ln_R1CTA,
                            ln_R1OPER,
                            ln_R1SBOP,
                            ln_R1TOPE,
                            pn_Pgcod,
                            pn_Itsuc,
                            pn_Itmod,
                            pn_Ittran,
                            pn_Itnrel,
                            ld_pgfape,
                            lc_Negociacion);
        
          if lc_Negociacion = 'S' or (pn_Itmod = 30 and pn_Ittran = 150) then
            --&cantCuotas >= 2
            ln_puedePagar := 0;
            pc_MsgRpta    := 'Reactiva';
          End If;
        end if;
        if lc_Rubro = '1415' or lc_Rubro = '1425' then
          ln_puedePagar := 1;
          pc_MsgRpta    := '';
        end if;
      end if;
    else
      --Do 'ObtenerTipo'
      --Do 'Verifica Rectiva'
      sp_es_reactiva(ln_R1MOD, ln_R1TOPE, lc_esReact);
      sp_ObtenerTipo(ln_R1COD, ln_R1CTA, ln_contador, ln_tipo);
    
      --sp_verifica_reactiva(in, in, out, out, out)      
      sp_verifica_reactiva(ln_R1CTA,
                           ln_tipo,
                           lc_int_tiene_reactiva,
                           lc_int_tiene_reactivaRcc,
                           ld_pfpagRe);
      if lc_esReact = 'N' then
        if (lc_int_tiene_reactiva = 'S' or lc_int_tiene_reactivaRcc = 'S') then
          lc_Negociacion := 'N';
          --Do 'Es_Negociacion'
          sp_Es_Negociacion(pn_Pgcod,
                            ln_R1MOD,
                            ln_R1SUC,
                            ln_R1MDA,
                            ln_R1PAP,
                            ln_R1CTA,
                            ln_R1OPER,
                            ln_R1SBOP,
                            ln_R1TOPE,
                            pn_Pgcod,
                            pn_Itsuc,
                            pn_Itmod,
                            pn_Ittran,
                            pn_Itnrel,
                            ld_pgfape,
                            lc_Negociacion);
        
          if lc_Negociacion = 'S' or (pn_Itmod = 30 and pn_Ittran = 150) then
            --&cantCuotas >= 2
            ln_puedePagar := 0;
            pc_MsgRpta    := 'Reactiva';
          End If;
        end if;
      end if;
      if lc_Rubro = '1415' or lc_Rubro = '1425' then
        ln_puedePagar := 1;
        pc_MsgRpta    := '';
      end if;
    end if;
    If ln_puedePagar = 0 then
      pc_Pcancel := 'S';
    End If;
  end sp_Ver_Reactiva_Comp;

  --*********************************************************
  procedure sp_Ver_Fae_Comp(pn_Pgcod   in number,
                            pn_Itsuc   in number,
                            pn_Itmod   in number,
                            pn_Ittran  in number,
                            pn_Itnrel  in number,
                            pn_Itord   in number,
                            pn_Itsbor  in number,
                            pd_pgfape  in date,
                            pc_Pcancel out varchar2,
                            pc_MsgRpta out varchar2) is
  
    ln_puedePagar number(1);
  
    ld_pgfape date;
  
    ln_R1MOD  number;
    ln_R1TOPE number;
    ln_R1SUC  number;
    ln_R1MDA  number;
    ln_R1PAP  number;
    ln_R1CTA  number;
    ln_R1OPER number;
    ln_R1SBOP number;
    ln_R1COD  number;
  
    ln_contador number(10);
    ln_tipo     number(5);
  
    ld_pfpagRe date;
  
    ln_cantCuotas number;
    ld_ppfpag     date;
  
    ln_aoperiod number;
    ln_aostat   number;
  
    ln_Rubroc number(16);
    lc_Rubro  varchar2(4);
  
    lc_Negociacion varchar2(1);
  
    ---------------------
    lc_tiene_fae        varchar2(1);
    lc_int_tiene_fae    varchar2(1);
    lc_int_tiene_faeRcc varchar2(1);
  
    ---------------------  
    lc_FlagRR varchar2(1);
  
    ld_fechaTmp1 date;
    ld_fechaTmp2 date;
  
  begin
    pc_Pcancel    := 'N';
    pc_MsgRpta    := '';
    ln_puedePagar := 1;
    /*
    -- buscar fecha 
    begin
      select Pgfape into ld_pgfape
      from fst017
      Where Pgcod = 1;
    exception when others then
      ld_pgfape  := null;
    end;
    */
    ld_pgfape := pd_pgfape;
  
    -- buscar clave credito 
    begin
      ln_R1COD := pn_Pgcod;
      select Modulo, Ittope, Itsucd, Moneda, Papel, Ctnro, Itoper, Itsubo
        into ln_R1MOD,
             ln_R1TOPE,
             ln_R1SUC,
             ln_R1MDA,
             ln_R1PAP,
             ln_R1CTA,
             ln_R1OPER,
             ln_R1SBOP
        from FSD016
       Where Pgcod = pn_Pgcod
         AND Itsuc = pn_Itsuc
         AND Itmod = pn_Itmod
         AND Ittran = pn_Ittran
         AND Itnrel = pn_Itnrel
         AND Itord = pn_Itord;
    exception
      when others then
        null;
    end;
  
    --VERIFICAR SI ES REPROGRAMACION O REFINANCIAMIENTO
    sp_fae_Rep_Ref(ln_R1COD,
                   ln_R1MOD,
                   ln_R1SUC,
                   ln_R1MDA,
                   ln_R1PAP,
                   ln_R1CTA,
                   ln_R1OPER,
                   ln_R1SBOP,
                   ln_R1TOPE,
                   lc_FlagRR);
  
    if lc_FlagRR = 'N' then
      --Do 'Verifica_Fae_Agro'
      sp_es_fae_agro(ln_R1MOD, ln_R1TOPE, lc_tiene_fae);
    
      if lc_tiene_fae = 'N' then
        --Do 'ObtenerTipo'
        sp_ObtenerTipo(ln_R1COD, ln_R1CTA, ln_contador, ln_tipo);
      
        --sp_verifica_reactiva(in, in, out, out, out)      
        sp_verifica_fae_agro(ln_R1CTA,
                             ln_tipo,
                             lc_int_tiene_fae,
                             lc_int_tiene_faeRcc,
                             ld_pfpagRe);
      
        --Do 'Verificar Pago Anticipado'    
        ln_cantCuotas := 0;
        --sp_pago_anticipado(in, in, in, in, in, in, out, out)
        sp_pago_anticipado(pn_Pgcod,
                           pn_Itmod,
                           pn_Itsuc,
                           pn_Ittran,
                           pn_Itnrel,
                           ld_pgfape,
                           ln_cantCuotas,
                           ld_ppfpag);
      
        --Do 'Obtener periodo'
        ln_aoperiod := 30;
        sp_ObtenerPeriodo(ln_R1COD,
                          ln_R1MOD,
                          ln_R1SUC,
                          ln_R1MDA,
                          ln_R1PAP,
                          ln_R1CTA,
                          ln_R1OPER,
                          ln_R1SBOP,
                          ln_R1TOPE,
                          ln_aoperiod,
                          ln_aostat);
        sp_ObtenerRubro(ln_R1COD,
                        ln_R1MOD,
                        ln_R1SUC,
                        ln_R1MDA,
                        ln_R1PAP,
                        ln_R1CTA,
                        ln_R1OPER,
                        ln_R1SBOP,
                        ln_R1TOPE,
                        ln_Rubroc,
                        lc_Rubro);
      
        ld_fechaTmp1 := last_day(ld_pgfape) + ln_aoperiod;
        If ld_ppfpag > ld_fechaTmp1 then
          ln_puedePagar := 0;
          pc_MsgRpta    := 'Fae Agro';
        
          if lc_int_tiene_fae <> 'S' then
            ln_puedePagar := 1;
            pc_MsgRpta    := '';
          end if;
        else
          if (lc_int_tiene_fae = 'S') and ld_pfpagRe is not null then
            ld_fechaTmp2 := ld_pfpagRe + ln_aoperiod;
            --if ld_pfpagRe < ld_ppfpag then 
            --if ld_fechaTmp2 < ld_ppfpag then
            if ld_fechaTmp2 < ld_pgfape then
              ln_puedePagar := 0;
              pc_MsgRpta    := 'Fae Agro';
            
              if lc_int_tiene_fae = 'S' then
                DBMS_OUTPUT.put_line('PAQPB015 &int_tiene_reactivaRcc: entro :');
                DBMS_OUTPUT.put_line(lc_int_tiene_fae);
              End If;
            
            end if;
          
            --Do 'Es_Negociacion' 
            lc_Negociacion := 'N';
            --sp_Es_Negociacion(in, in, in, in, in, in, in, in, in, in, in, in, in, in, in, out)
            sp_Es_Negociacion(pn_Pgcod,
                              ln_R1MOD,
                              ln_R1SUC,
                              ln_R1MDA,
                              ln_R1PAP,
                              ln_R1CTA,
                              ln_R1OPER,
                              ln_R1SBOP,
                              ln_R1TOPE,
                              pn_Pgcod,
                              pn_Itsuc,
                              pn_Itmod,
                              pn_Ittran,
                              pn_Itnrel,
                              ld_pgfape,
                              lc_Negociacion);
          
            if lc_Negociacion = 'S' or (pn_Itmod = 30 and pn_Ittran = 150) then
              ln_puedePagar := 0;
              pc_MsgRpta    := 'Fae Agro';
            End If;
          
          End If;
        
        End If;
      
        if (lc_int_tiene_fae = 'S') then
          --Do 'Es_Negociacion'  
          sp_Es_Negociacion(pn_Pgcod,
                            ln_R1MOD,
                            ln_R1SUC,
                            ln_R1MDA,
                            ln_R1PAP,
                            ln_R1CTA,
                            ln_R1OPER,
                            ln_R1SBOP,
                            ln_R1TOPE,
                            pn_Pgcod,
                            pn_Itsuc,
                            pn_Itmod,
                            pn_Ittran,
                            pn_Itnrel,
                            ld_pgfape,
                            lc_Negociacion);
        
          if lc_Negociacion = 'S' or (pn_Itmod = 30 and pn_Ittran = 150) then
            --&cantCuotas >= 2
            ln_puedePagar := 0;
            pc_MsgRpta    := 'Fae Agro';
          End If;
        end if;
      
        if lc_Rubro = '1415' or lc_Rubro = '1425' then
          ln_puedePagar := 1;
          pc_MsgRpta    := '';
        end if;
      
      End If;
    
    Else
      ln_puedePagar := 1;
    End If;
  
    If ln_puedePagar = 0 then
      pc_Pcancel := 'S';
    End If;
  
  end sp_Ver_Fae_Comp;

  --*********************************************************
  procedure sp_Ver_Pae_Mype_Comp(pn_Pgcod   in number,
                                 pn_Itsuc   in number,
                                 pn_Itmod   in number,
                                 pn_Ittran  in number,
                                 pn_Itnrel  in number,
                                 pn_Itord   in number,
                                 pn_Itsbor  in number,
                                 pd_pgfape  in date,
                                 pc_Pcancel out varchar2,
                                 pc_MsgRpta out varchar2) is
    ln_puedePagar number(1);
  
    ld_pgfape date;
  
    ln_R1MOD  number;
    ln_R1TOPE number;
    ln_R1SUC  number;
    ln_R1MDA  number;
    ln_R1PAP  number;
    ln_R1CTA  number;
    ln_R1OPER number;
    ln_R1SBOP number;
    ln_R1COD  number;
  
    lc_tiene_pae varchar2(1);
  
    ln_contador number(10);
    ln_tipo     number(5);
  
    lc_int_tiene_pae    varchar2(1);
    lc_int_tiene_paeRcc varchar2(1);
  
    ld_pfpagRe date;
  
    ln_cantCuotas number;
    ld_ppfpag     date;
  
    ln_aoperiod number;
    ln_aostat   number;
  
    ln_Rubroc number(16);
    lc_Rubro  varchar2(4);
  
    lc_Negociacion varchar2(1);
  
    ld_fechaTmp2 date;
  
  begin
    pc_Pcancel    := 'N';
    pc_MsgRpta    := '';
    ln_puedePagar := 1;
    /*
    -- buscar fecha 
    begin
      select Pgfape into ld_pgfape
      from fst017
      Where Pgcod = 1;
    exception when others then
      ld_pgfape  := null;
    end;
    */
    ld_pgfape := pd_pgfape;
  
    -- buscar clave credito 
    begin
      ln_R1COD := pn_Pgcod;
      select Modulo, Ittope, Itsucd, Moneda, Papel, Ctnro, Itoper, Itsubo
        into ln_R1MOD,
             ln_R1TOPE,
             ln_R1SUC,
             ln_R1MDA,
             ln_R1PAP,
             ln_R1CTA,
             ln_R1OPER,
             ln_R1SBOP
        from FSD016
       Where Pgcod = pn_Pgcod
         AND Itsuc = pn_Itsuc
         AND Itmod = pn_Itmod
         AND Ittran = pn_Ittran
         AND Itnrel = pn_Itnrel
         AND Itord = pn_Itord;
    exception
      when others then
        null;
    end;
  
    sp_es_Pae_Mype(ln_R1MOD, ln_R1TOPE, lc_tiene_pae);
  
    if lc_tiene_pae = 'N' then
    
      sp_ObtenerTipo(ln_R1COD, ln_R1CTA, ln_contador, ln_tipo);
    
      sp_verifica_pae_mype(ln_R1CTA,
                           ln_tipo,
                           lc_int_tiene_pae,
                           lc_int_tiene_paeRcc,
                           ld_pfpagRe);
    
      --Do 'Verificar Pago Anticipado'    
      ln_cantCuotas := 0;
      --sp_pago_anticipado(in, in, in, in, in, in, out, out)
      sp_pago_anticipado(pn_Pgcod,
                         pn_Itmod,
                         pn_Itsuc,
                         pn_Ittran,
                         pn_Itnrel,
                         ld_pgfape,
                         ln_cantCuotas,
                         ld_ppfpag);
    
      --Do 'Obtener periodo'
      ln_aoperiod := 30;
      sp_ObtenerPeriodo(ln_R1COD,
                        ln_R1MOD,
                        ln_R1SUC,
                        ln_R1MDA,
                        ln_R1PAP,
                        ln_R1CTA,
                        ln_R1OPER,
                        ln_R1SBOP,
                        ln_R1TOPE,
                        ln_aoperiod,
                        ln_aostat);
      sp_ObtenerRubro(ln_R1COD,
                      ln_R1MOD,
                      ln_R1SUC,
                      ln_R1MDA,
                      ln_R1PAP,
                      ln_R1CTA,
                      ln_R1OPER,
                      ln_R1SBOP,
                      ln_R1TOPE,
                      ln_Rubroc,
                      lc_Rubro);
    
      If ld_ppfpag > last_day(ld_pgfape) + ln_aoperiod then
        ln_puedePagar := 0;
        pc_MsgRpta    := 'PAE MYPE';
      
        if lc_int_tiene_paeRcc = 'S' then
          pc_MsgRpta := 'PAE MYPE (en otra entidad)';
        end if;
      
        if lc_int_tiene_pae <> 'S' and lc_int_tiene_paeRcc <> 'S' then
          ln_puedePagar := 1;
          pc_MsgRpta    := '';
        end if;
      else
        if (lc_int_tiene_pae = 'S' or lc_int_tiene_paeRcc = 'S') and
           ld_pfpagRe is not null then
          ld_fechaTmp2 := ld_pfpagRe + ln_aoperiod;
          --if ld_pfpagRe < ld_ppfpag then 
          --if ld_fechaTmp2 < ld_ppfpag then
          if ld_fechaTmp2 < ld_pgfape then
            ln_puedePagar := 0;
            pc_MsgRpta    := 'PAE MYPE';
          
            if lc_int_tiene_paeRcc = 'S' then
              pc_MsgRpta := 'PAE MYPE (en otra entidad)';
            end if;
          
            if lc_int_tiene_pae = 'S' or lc_int_tiene_paeRcc = 'S' then
              DBMS_OUTPUT.put_line('PAQPB015 &int_tiene_reactivaRcc: entro :');
              DBMS_OUTPUT.put_line(lc_int_tiene_pae);
            End If;
          
          end if;
        
          --Do 'Es_Negociacion'
          lc_Negociacion := 'N';
          --sp_Es_Negociacion(in, in, in, in, in, in, in, in, in, in, in, in, in, in, in, out)
          sp_Es_Negociacion(pn_Pgcod,
                            ln_R1MOD,
                            ln_R1SUC,
                            ln_R1MDA,
                            ln_R1PAP,
                            ln_R1CTA,
                            ln_R1OPER,
                            ln_R1SBOP,
                            ln_R1TOPE,
                            pn_Pgcod,
                            pn_Itsuc,
                            pn_Itmod,
                            pn_Ittran,
                            pn_Itnrel,
                            ld_pgfape,
                            lc_Negociacion);
        
          if lc_Negociacion = 'S' or (pn_Itmod = 30 and pn_Ittran = 150) then
            --&cantCuotas >= 2
            ln_puedePagar := 0;
            pc_MsgRpta    := 'PAE MYPE';
          End If;
        
        End If;
      
      end if;
    
      if (lc_int_tiene_pae = 'S' or lc_int_tiene_paeRcc = 'S') then
        --Do 'Es_Negociacion'
        sp_Es_Negociacion(pn_Pgcod,
                          ln_R1MOD,
                          ln_R1SUC,
                          ln_R1MDA,
                          ln_R1PAP,
                          ln_R1CTA,
                          ln_R1OPER,
                          ln_R1SBOP,
                          ln_R1TOPE,
                          pn_Pgcod,
                          pn_Itsuc,
                          pn_Itmod,
                          pn_Ittran,
                          pn_Itnrel,
                          ld_pgfape,
                          lc_Negociacion);
      
        if lc_Negociacion = 'S' or (pn_Itmod = 30 and pn_Ittran = 150) then
          --&cantCuotas >= 2
          ln_puedePagar := 0;
          pc_MsgRpta    := 'PAE MYPE';
        End If;
      
      end if;
    
      if lc_Rubro = '1415' or lc_Rubro = '1425' then
        ln_puedePagar := 1;
        pc_MsgRpta    := '';
      end if;
    
    end if;
  
    If ln_puedePagar = 0 then
      pc_Pcancel := 'S';
    End If;
  
  end sp_Ver_Pae_Mype_Comp;

  --*********************************************************    
  procedure sp_es_Pae_Mype(pn_mod number,
                           pn_tpo number,
                           pv_rpt out varchar2) is
  begin
    if pn_mod = 101 and pn_tpo = 356 then
      pv_rpt := 'S';
    else
      pv_rpt := 'N';
    end if;
  end sp_es_Pae_Mype;

  --*********************************************************  
  procedure sp_es_Pae_Mype_rcc(pn_tdoc number,
                               pv_ndoc varchar2,
                               pv_rpt  out varchar2) is
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
  
    lc_CodSBS varchar2(10);
    ld_FchRCC date;
    ln_cont   numeric(5);
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
    lc_CodSBS := null;
    pv_rpt    := 'N';
    for rcc in CrCldrcci(pv_ndoc, FN_EQUIVALENCIADOC(pn_tdoc)) loop
      lc_CodSBS := rcc.c_codsbs;
      if lc_CodSBS is not null then
        select nvl(count(*), 0)
          into ln_cont
          from cldrccs c
         where c.c_codsbs = lc_CodSBS
           and d_fecpre = ld_FchRCC
           and c_cuenta like '81_8%' --se modifico para permitir soles y dolares 08032021
           and c_codemp <> '00104';
        if ln_cont > 0 then
          pv_rpt := 'S';
        end if;
      end if;
    end loop;
  
  end sp_es_Pae_Mype_rcc;

  --*********************************************************  
  procedure sp_verifica_pae_mype(pn_ctnro   number,
                                 pn_tipo    number,
                                 pv_rpta    out varchar2,
                                 pv_rptaRcc out varchar2,
                                 pd_fecre   out date) is
  
    cursor integrantes(pn_tipoI in number) is
      select distinct f.PEPAIS, f.PETDOC, f.pendoc ln_doc
        from fsr008 f
       where f.ctnro = pn_ctnro
         and f.cttfir = 'T'
      union
      select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro = pn_ctnro
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and f.cttfir = 'T'
         and 2 = pn_tipoI --pn_tipo  24062021
      union
      select distinct g.pepais, g.petdoc, g.pendoc ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro = pn_ctnro
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and f.cttfir = 'T'
         and 2 = pn_tipoI; --pn_tipo  24062021
  
    cursor cuentas(pn_TipoI in number) is
      select x.ctnro, x.pepais, x.PETDOC, x.pendoc
        from fsr008 x
       where (PEPAIS, PETDOC, pendoc) in
             (select distinct f.PEPAIS, f.PETDOC, f.pendoc ln_doc
                from fsr008 f
               where f.ctnro = pn_ctnro
                 and f.cttfir = 'T'
              union
              select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.pepais
                 and f.petdoc = g.petdoc
                 and f.pendoc = g.pendoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
                 and 2 = pn_tipoI --pn_tipo  24062021
              union
              select distinct g.pepais, g.petdoc, g.pendoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.rppais
                 and f.petdoc = g.rptdoc
                 and f.pendoc = g.rpndoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
                 and 2 = pn_tipoI) --pn_tipo)  24062021
         and cttfir = 'T';
  
    cursor creditos(lpn_cta numeric) is
      select c.*, cc.pepais, cc.petdoc, cc.pendoc
        from fsd010 c, fsr008 cc
       where cc.pgcod = c.pgcod
         and cc.ctnro = c.aocta
         and cc.cttfir = 'T'
         and c.pgcod = 1
         and c.aomod in (select modulo from fst111 where dscod = 50)
         and c.aostat <> 99
         and c.aocta = lpn_cta;
  
    lv_rpta   varchar2(1);
    lv_rpta2  varchar2(1);
    ld_fec601 date;
  
    ln_tipo number; --24062021
  begin
    pv_rpta    := 'N';
    pv_rptaRcc := 'N';
  
    ln_tipo := 0;
    begin
      select count(*) + pn_tipo
        into ln_tipo
        from (select distinct g.rppais, g.rptdoc, g.rpndoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.pepais
                 and f.petdoc = g.petdoc
                 and f.pendoc = g.pendoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T'
              union
              select distinct g.pepais, g.petdoc, g.pendoc ln_doc
                from fsr008 f, fsr002 g
               where f.ctnro = pn_ctnro
                 and f.pepais = g.rppais
                 and f.petdoc = g.rptdoc
                 and f.pendoc = g.rpndoc
                 and g.rpccyg = 66
                 and f.cttfir = 'T');
    exception
      when others then
        ln_tipo := 1;
    end;
  
    for i in cuentas(ln_tipo) loop
      for j in creditos(i.ctnro) loop
        lv_rpta := 'N';
        sp_es_Pae_Mype(j.aomod, j.aotope, lv_rpta);
        if lv_rpta = 'S' then
          select min(a.ppfpag)
            into ld_fec601
            from fsd601 a
           where pgcod = j.pgcod
             and ppmod = j.aomod
             and ppsuc = j.aosuc
             and ppmda = j.aomda
             and pppap = j.aopap
             and ppcta = j.aocta
             and ppoper = j.aooper
             and ppsbop = j.aosbop
             and pptope = j.aotope
             and d601co = 'S'
             and pptipo <> 'K'
             and not exists (select *
                    from fsd602 b
                   where b.pgcod = a.pgcod
                     and b.ppmod = a.ppmod
                     and b.ppsuc = a.ppsuc
                     and b.ppmda = a.ppmda
                     and b.pppap = a.pppap
                     and b.ppcta = a.ppcta
                     and b.ppoper = a.ppoper
                     and b.ppsbop = a.ppsbop
                     and b.pptope = a.pptope
                     and b.ppfpag = a.ppfpag
                     and b.d602co = 'S'
                     and b.pp1stat = 'T');
          if pd_fecre is null or pd_fecre > ld_fec601 then
            pd_fecre := ld_fec601;
          end if;
          pv_rpta := 'S';
        end if;
      end loop;
    end loop;
  
    for k in integrantes(ln_tipo) loop
      lv_rpta2 := 'N';
      sp_es_Pae_Mype_rcc(k.petdoc, trim(k.ln_doc), lv_rpta2);
      if lv_rpta2 = 'S' then
        pv_rptaRcc := 'S';
      end if;
    end loop;
    rollback;
  end sp_verifica_pae_mype;

  --*********************************************************  
  procedure sp_fae_Rep_Ref(pn_R1COD  in number,
                           pn_R1MOD  in number,
                           pn_R1SUC  in number,
                           pn_R1MDA  in number,
                           pn_R1PAP  in number,
                           pn_R1CTA  in number,
                           pn_R1OPER in number,
                           pn_R1SBOP in number,
                           pn_R1TOPE in number,
                           pc_FLAGRR OUT VARCHAR2) is
  
    CURSOR lst_Solicitudes IS
      SELECT F.TP1NRO3 CurTipSol
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11138
         AND F.TP1CORR1 = 100
         AND F.TP1CORR2 = 1;
  
    LN_INSTANCIA NUMBER(10);
    LN_TIPSOL    NUMBER(2);
    LN_CONT      NUMBER(2);
  
  BEGIN
    --INSTANCIA
    begin
      SELECT F.XWFPRCINS
        INTO LN_INSTANCIA
        FROM XWF700 F
       WHERE F.XWFEMPRESA = pn_R1COD
         AND F.XWFSUCURSAL = pn_R1SUC
         AND F.XWFMODULO = pn_R1MOD
         AND F.XWFMONEDA = pn_R1MDA
         AND F.XWFPAPEL = pn_R1PAP
         AND F.XWFCUENTA = pn_R1CTA
         AND F.XWFOPERACION = pn_R1OPER
         AND F.XWFSUBOPE = pn_R1SBOP
         AND F.XWFTIPOPE = pn_R1TOPE
         AND F.XWFCAR3 = '1';
    EXCEPTION
      when others then
        pc_FLAGRR := 'N';
    end;
  
    --TIPO SOLICITUD
    begin
      SELECT X.SNG001ORI
        INTO LN_TIPSOL
        FROM SNG001 X
       WHERE X.SNG001INST = LN_INSTANCIA;
    EXCEPTION
      when others then
        pc_FLAGRR := 'N';
    end;
  
    --VERIFICAR LISTADO DE SOLICITADOS
    begin
      FOR i IN lst_Solicitudes LOOP
        if i.CurTipSol = LN_TIPSOL then
          pc_FLAGRR := 'S';
        else
          pc_FLAGRR := 'N';
        end if;
        EXIT WHEN pc_FLAGRR = 'S';
      END LOOP;
    EXCEPTION
      when others then
        pc_FLAGRR := 'N';
    end;
  
    if pc_FLAGRR = 'N' then
      begin
        select count(*)
          into LN_CONT
          from jaqa400 j
         where j.jaqa400est = 'C'
           and j.jaqa400emp = pn_R1COD
           and j.jaqa400mod = pn_R1MOD
           and j.jaqa400suc = pn_R1SUC
           and j.jaqa400mda = pn_R1MDA
           and j.jaqa400pap = pn_R1PAP
           and j.jaqa400cta = pn_R1CTA
           and j.jaqa400ope = pn_R1OPER
           and j.jaqa400sbo = pn_R1SBOP
           and j.jaqa400top = pn_R1TOPE;
      
        if LN_CONT = 0 then
          pc_FLAGRR := 'N';
        else
          pc_FLAGRR := 'S';
        end if;
      
      EXCEPTION
        when others then
          pc_FLAGRR := 'N';
      end;
    end if;
  
  END sp_fae_Rep_Ref;
  --EFUENTES FIN
end PQ_CR_CTR_FAE_REACTIVA;
/

