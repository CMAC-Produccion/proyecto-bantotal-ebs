create or replace package PQ_CR_BBP_IMPULSO is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_BBP_IMPULSO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/12/2024 16:54:23
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Proceso listado creditos con beneficio de BBP
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 26/02/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico el procedimiento sp_Cr_VerfAntUltCuot la logica para obtener el saldo pendiente.
  -- Fecha de Modificación      : 03/03/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico el mensaje de la RTE de pagos a Solicitud de Negocio Linea 1546
  -- Fecha de Modificación      : 08/05/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico el mensaje de la voucher de pagos a Solicitud de Negocio Linea 1271
  -- Fecha de Modificación      : 24/11/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- *****************************************************************

  procedure sp_Cr_Inicio;
  ----------------------------------------------------------
  procedure sp_cr_VerfAmort(ln_pgcod    in number,
                            ln_mod      in number,
                            ln_suc      in number,
                            ln_mda      in number,
                            ln_pap      in number,
                            ln_cta      in number,
                            ln_oper     in number,
                            ln_sbop     in number,
                            ln_tope     in number,
                            lc_TnAmortz out varchar2);
  --------------------------------------------------------------
  procedure sp_Cr_VerfAntUltCuot(ln_pgcod       in number,
                                 ln_mod         in number,
                                 ln_suc         in number,
                                 ln_mda         in number,
                                 ln_pap         in number,
                                 ln_cta         in number,
                                 ln_oper        in number,
                                 ln_sbop        in number,
                                 ln_tope        in number,
                                 ln_CuoCaln     out number,
                                 ln_CuotPag     out number,
                                 ln_CuoPend     out number,
                                 lc_EsAntUltCuo out varchar2,
                                 ln_capital     out number,
                                 ld_FchBBP      out date);
  -----------------------------------------------------------------
  procedure sp_Cr_AtrasoMax(ln_pgcod     in number,
                            ln_mod       in number,
                            ln_suc       in number,
                            ln_mda       in number,
                            ln_pap       in number,
                            ln_cta       in number,
                            ln_ope       in number,
                            ln_sbop      in number,
                            ln_tope      in number,
                            ld_Fecha     in date,
                            ln_AtrasoMax out number);
  -----------------------------------------------------------------
  procedure sp_cr_LogAQPB187A(ld_fecha   in date,
                              ln_ins     in number,
                              ln_pais    in number,
                              ln_tdoc    in number,
                              lv_ndoc    in varchar2,
                              ln_pgcod   in number,
                              ln_mod     in number,
                              ln_suc     in number,
                              ln_mda     in number,
                              ln_pap     in number,
                              ln_cta     in number,
                              ln_ope     in number,
                              ln_sbop    in number,
                              ln_tope    in number,
                              lv_idcof   in varchar2,
                              lv_codcob  in varchar2,
                              ld_fdes    in date,
                              ln_mntdes  in number,
                              ln_scap    in number,
                              lv_amortz  in varchar2,
                              ln_NCUOTS  in number,
                              ln_CPAG    in number,
                              ln_NCPEND  in number,
                              lv_antpcuo in varchar2,
                              ln_atraso  in number,
                              ln_porc15  in number,
                              ln_cap2cuo in number,
                              ln_bbp     in number,
                              ld_FchBBP  in date);
  ----------------------------------------------------------------
  procedure sp_cr_LogAQPB187(ld_fch    in date,
                             ln_ins    in number,
                             ln_pais   in number,
                             ln_tdoc   in number,
                             lv_ndoc   in varchar2,
                             ln_pgcod  in number,
                             ln_mod    in number,
                             ln_suc    in number,
                             ln_mda    in number,
                             ln_pap    in number,
                             ln_cta    in number,
                             ln_ope    in number,
                             ln_sbop   in number,
                             ln_tope   in number,
                             lv_idcof  in varchar2,
                             lv_codcob in varchar2,
                             ld_fdes   in date,
                             ln_mntdes in number,
                             ln_scap   in number,
                             ld_fibbp  in date,
                             ln_bbp    in number);
  -------------------------------------------------------------
  procedure sp_cr_LogAQPB188(ld_fch     in date,
                             ln_ins     in number,
                             ln_pgcod   in number,
                             ln_mod     in number,
                             ln_suc     in number,
                             ln_mda     in number,
                             ln_pap     in number,
                             ln_cta     in number,
                             ln_ope     in number,
                             ln_sbop    in number,
                             ln_tope    in number,
                             ln_fcron   in date,
                             ln_pais    in number,
                             ln_tdoc    in number,
                             lv_ndoc    in varchar2,
                             lv_idcof   in varchar2,
                             ln_ncuot   in number,
                             ln_tcea    in number,
                             ln_tea     in number,
                             ld_fpagbn  in varchar2,
                             ln_datraso in number,
                             ln_salcap  in number);
  --------------------------------------------------------------------                              
  procedure sp_cr_Voucher(ln_pgcodt in number,
                          ln_suct   in number,
                          ln_modt   in number,
                          ln_ttran  in number,
                          ln_relt   in number,
                          ln_ordt   in number,
                          ln_subord in number,
                          lv_Flag   out varchar2,
                          lv_msg    out varchar2);
  ---------------------------------------------------------------------
  procedure sp_cr_RTEPagos(ln_pgcodt  in number,
                           ln_suct    in number,
                           ln_modt    in number,
                           ln_ttran   in number,
                           ln_relt    in number,
                           ln_ordt    in number,
                           ln_subord  in number,
                           lv_pcancel out varchar2,
                           lv_msj     out varchar2);
  -------------------------------------------------------------
  procedure sp_Cr_LogAQPB189(ld_fch     in date,
                             ln_pgcod   in number,
                             ln_suctx   in number,
                             ln_modtx   in number,
                             ln_tx      in number,
                             ln_reltx   in number,
                             ln_ordtx   in number,
                             ln_sbordtx in number);
  -------------------------------------------------------------------
end PQ_CR_BBP_IMPULSO;
/
create or replace package body PQ_CR_BBP_IMPULSO is

  procedure sp_Cr_Inicio is
  
    cursor listado(ld_Fecha date) is
    
      select distinct t.aqpc366hemp,
                      t.aqpc366hmod,
                      t.aqpc366hsuc,
                      t.aqpc366hmnda,
                      t.aqpc366hpapl,
                      t.aqpc366hncta,
                      t.aqpc366hnope,
                      t.aqpc366hsbop,
                      t.aqpc366htope,
                      t.aqpc366hidcof,
                      t.aqpc366hcodcob,
                      t.aqpc366hfdes,
                      t.aqpc366htdoc,
                      t.aqpc366hndoc,
                      t.aqpc366hcdes,
                      t.aqpc366hscap
        from aqpc366h t, fsd010 f
       where t.aqpc366hemp = f.pgcod
         and t.aqpc366hmod = f.aomod
         and t.aqpc366hsuc = f.aosuc
         and t.aqpc366hmnda = f.aomda
         and t.aqpc366hpapl = f.aopap
         and t.aqpc366hncta = f.aocta
         and t.aqpc366hnope = f.aooper
         and t.aqpc366hsbop = f.aosbop
         and t.aqpc366htope = f.aotope
         and t.aqpc366husur = 'BANTPROD'
         and t.aqpc366hfproc = ld_Fecha
         and f.aostat = 0;
  
    cursor data_final(ld_FchSist date) is
      select a.aqpb187ains,
             a.aqpb187apais,
             a.aqpb187atdoc,
             a.aqpb187andoc,
             a.aqpb187apgcod,
             a.aqpb187amod,
             a.aqpb187asuc,
             a.aqpb187amda,
             a.aqpb187apap,
             a.aqpb187acta,
             a.aqpb187aope,
             a.aqpb187asbop,
             a.aqpb187atope,
             a.aqpb187aidcof,
             a.aqpb187acodcob,
             a.aqpb187afdes,
             a.aqpb187amntdes,
             a.aqpb187ascap,
             a.aqpb187afchbbp,
             a.aqpb187abbp
        from aqpb187a a
       where a.aqpb187afch = ld_FchSist
         and a.aqpb187aamortz = 'N'
         and a.aqpb187aantpcuo = 'S'
         and a.aqpb187aatraso < 3;
  
    cursor plantilla_crono(ld_FchSist date) is
      select A.AQPB187FCH,
             A.AQPB187INS,
             A.AQPB187PGCOD,
             A.AQPB187MOD,
             A.AQPB187SUC,
             A.AQPB187MDA,
             A.AQPB187PAP,
             A.AQPB187CTA,
             A.AQPB187OPE,
             A.AQPB187SBOP,
             A.AQPB187TOPE,
             A.AQPB187PAIS,
             A.AQPB187TDOC,
             A.AQPB187NDOC,
             A.AQPB187IDCOF,
             A.AQPB187SCAP,
             a.aqpb187fibbp
        from aqpb187 a
       where a.aqpb187fch = ld_FchSist;
  
    cursor calendario(ln_pgcod number,
                      ln_mod   number,
                      ln_suc   number,
                      ln_mda   number,
                      ln_pap   number,
                      ln_cta   number,
                      ln_oper  number,
                      ln_sbop  number,
                      ln_tope  number,
                      ld_fecha date) is
      select rownum ln_nroreg, f.ppfpag
        from fsd601 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_oper
         and f.ppsbop = ln_sbop
         and f.pptope = ln_tope
         and f.d601co = 'S'
       order by ppfpag;
  
    lv_VerfAmortz  varchar2(5) := 'N';
    ld_MaxFch366h  date;
    lv_EsAntUltCuo varchar2(5) := 'N';
    ld_FchSist     date;
    ln_instancia   number(10);
    ln_pais        number(3);
    ln_tdoc        number(3);
    lv_ndoc        varchar2(12);
    ln_SaldCap     number(17, 2) := 0.00;
    ln_Atraso      number;
    ln_QuincePorc  number(17, 2) := 0.00;
    ln_Cap2UltCuo  number(17, 2) := 0.00;
    ln_BBP         number(17, 2) := 0.00;
    ln_PagoAyer    number := 0;
    ln_NroCuotas   number := 0;
    ln_CuoPagads   number := 0;
    ln_CuoPndients number := 0;
    ld_FchIniBBP   date;
    ln_TCEA        number(10, 6) := 0.00;
    ln_TEA         number(10, 6) := 0.00;
    ln_Existe      number;
    ln_DiaAtraso   number;
    ld_FchPago     date;
    Dia_Atraso     number;
    ln_SaldCapCuot number(17, 2) := 0.00;
    ln_MntCapCuo   number(17, 2) := 0.00;
    ln_LogCofide   number := 0;
    ln_MntDesemb   number(17, 2) := 0.00;
  
  begin
  
    begin
      select max(a.aqpc366hfproc)
        into ld_MaxFch366h
        from aqpc366h a
       where a.aqpc366husur = 'BANTPROD';
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --    ld_FchSist := '11/02/2025';
  
    begin
      delete from aqpb187a a where a.aqpb187afch = ld_FchSist;
      delete from aqpb187 b where b.aqpb187fch = ld_FchSist;
      delete from aqpb188 b where b.aqpb188fch = ld_FchSist;
      commit;
    end;
  
    for l in listado(ld_MaxFch366h) loop
      ln_SaldCap     := 0;
      lv_VerfAmortz  := 'N';
      ln_NroCuotas   := 0;
      ln_CuoPagads   := 0;
      ln_CuoPndients := 0;
      lv_EsAntUltCuo := 'N';
      ln_Atraso      := 0;
      ln_QuincePorc  := 0;
      ln_Cap2UltCuo  := 0;
      ln_BBP         := 0;
      ld_FchIniBBP   := NULL;
    
      begin
        select count(*)
          into ln_PagoAyer
          from fsd602 f
         where f.pgcod = l.aqpc366hemp
           and f.ppmod = l.aqpc366hmod
           and f.ppsuc = l.aqpc366hsuc
           and f.ppmda = l.aqpc366hmnda
           and f.pppap = l.aqpc366hpapl
           and f.ppcta = l.aqpc366hncta
           and f.ppoper = l.aqpc366hnope
           and f.ppsbop = l.aqpc366hsbop
           and f.pptope = l.aqpc366htope
           and f.d602fc = ld_FchSist - 1
           and f.pp1stat = 'T'
           and f.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_Existe
          from aqpb187 a
         where a.aqpb187pgcod = l.aqpc366hemp
           and a.aqpb187mod = l.aqpc366hmod
           and a.aqpb187suc = l.aqpc366hsuc
           and a.aqpb187mda = l.aqpc366hmnda
           and a.aqpb187pap = l.aqpc366hpapl
           and a.aqpb187cta = l.aqpc366hncta
           and a.aqpb187ope = l.aqpc366hnope
           and a.aqpb187sbop = l.aqpc366hsbop
           and a.aqpb187tope = l.aqpc366htope;
      exception
        when others then
          ln_Existe := 0;
      end;
    
      if ln_PagoAyer > 0 and ln_Existe = 0 then
      
        ln_Atraso := 0;
      
        pq_Cr_bbp_impulso.sp_cr_VerfAmort(ln_pgcod    => l.aqpc366hemp,
                                          ln_mod      => l.aqpc366hmod,
                                          ln_suc      => l.aqpc366hsuc,
                                          ln_mda      => l.aqpc366hmnda,
                                          ln_pap      => l.aqpc366hpapl,
                                          ln_cta      => l.aqpc366hncta,
                                          ln_oper     => l.aqpc366hnope,
                                          ln_sbop     => l.aqpc366hsbop,
                                          ln_tope     => l.aqpc366htope,
                                          lc_TnAmortz => lv_VerfAmortz);
      
        pq_Cr_bbp_impulso.sp_Cr_VerfAntUltCuot(ln_pgcod       => l.aqpc366hemp,
                                               ln_mod         => l.aqpc366hmod,
                                               ln_suc         => l.aqpc366hsuc,
                                               ln_mda         => l.aqpc366hmnda,
                                               ln_pap         => l.aqpc366hpapl,
                                               ln_cta         => l.aqpc366hncta,
                                               ln_oper        => l.aqpc366hnope,
                                               ln_sbop        => l.aqpc366hsbop,
                                               ln_tope        => l.aqpc366htope,
                                               ln_CuoCaln     => ln_NroCuotas,
                                               ln_CuotPag     => ln_CuoPagads,
                                               ln_CuoPend     => ln_CuoPndients,
                                               lc_EsAntUltCuo => lv_EsAntUltCuo,
                                               ln_capital     => ln_Cap2UltCuo,
                                               ld_FchBBP      => ld_FchIniBBP);
      
        pq_Cr_bbp_impulso.sp_Cr_AtrasoMax(ln_pgcod     => l.aqpc366hemp,
                                          ln_mod       => l.aqpc366hmod,
                                          ln_suc       => l.aqpc366hsuc,
                                          ln_mda       => l.aqpc366hmnda,
                                          ln_pap       => l.aqpc366hpapl,
                                          ln_cta       => l.aqpc366hncta,
                                          ln_ope       => l.aqpc366hnope,
                                          ln_sbop      => l.aqpc366hsbop,
                                          ln_tope      => l.aqpc366htope,
                                          ld_Fecha     => ld_FchSist,
                                          ln_AtrasoMax => ln_Atraso);
      
        ln_instancia := fn_instancia_credito(v_Scmod  => l.aqpc366hmod,
                                             v_Scsuc  => l.aqpc366hsuc,
                                             v_Scmda  => l.aqpc366hmnda,
                                             v_Scpap  => l.aqpc366hpapl,
                                             v_Sccta  => l.aqpc366hncta,
                                             v_Scoper => l.aqpc366hnope,
                                             v_Scsbop => l.aqpc366hsbop,
                                             v_Sctope => l.aqpc366htope);
      
        begin
          select f.pepais, f.petdoc, f.pendoc
            into ln_pais, ln_tdoc, lv_ndoc
            from fsr008 f
           where f.pgcod = 1
             and f.ctnro = l.aqpc366hncta
             and f.cttfir = 'T';
        exception
          when others then
            null;
        end;
      
        begin
          select f.scsdo
            into ln_SaldCap
            from fsd011 f
           where f.pgcod = l.aqpc366hemp
             and f.scmod = l.aqpc366hmod
             and f.scsuc = l.aqpc366hsuc
             and f.scmda = l.aqpc366hmnda
             and f.scpap = l.aqpc366hpapl
             and f.sccta = l.aqpc366hncta
             and f.scoper = l.aqpc366hnope
             and f.scsbop = l.aqpc366hsbop
             and f.sctope = l.aqpc366htope
             and f.scstat = 0;
        exception
          when others then
            null;
        end;
      
        if ln_SaldCap < 0 then
          ln_SaldCap := ln_SaldCap * -1;
        end if;
      
        ln_SaldCap := nvl(ln_SaldCap, 0);
      
        begin
          select (l.aqpc366hcdes * 15) / 100 into ln_QuincePorc from dual;
        exception
          when others then
            ln_QuincePorc := 0;
        end;
        ln_QuincePorc := nvl(ln_QuincePorc, 0);
        ln_Cap2UltCuo := nvl(ln_Cap2UltCuo, 0);
      
        if ln_QuincePorc <= ln_Cap2UltCuo then
          ln_BBP := ln_QuincePorc;
        else
          if ln_Cap2UltCuo < ln_QuincePorc then
            ln_BBP := ln_Cap2UltCuo;
          end if;
        end if;
      
        pq_Cr_bbp_impulso.sp_cr_LogAQPB187A(ld_fecha   => ld_FchSist,
                                            ln_ins     => ln_instancia,
                                            ln_pais    => ln_pais,
                                            ln_tdoc    => ln_tdoc,
                                            lv_ndoc    => lv_ndoc,
                                            ln_pgcod   => l.aqpc366hemp,
                                            ln_mod     => l.aqpc366hmod,
                                            ln_suc     => l.aqpc366hsuc,
                                            ln_mda     => l.aqpc366hmnda,
                                            ln_pap     => l.aqpc366hpapl,
                                            ln_cta     => l.aqpc366hncta,
                                            ln_ope     => l.aqpc366hnope,
                                            ln_sbop    => l.aqpc366hsbop,
                                            ln_tope    => l.aqpc366htope,
                                            lv_idcof   => l.aqpc366hidcof,
                                            lv_codcob  => l.aqpc366hcodcob,
                                            ld_fdes    => l.aqpc366hfdes,
                                            ln_mntdes  => l.aqpc366hcdes,
                                            ln_scap    => ln_SaldCap,
                                            lv_amortz  => lv_VerfAmortz,
                                            ln_NCUOTS  => ln_NroCuotas,
                                            ln_CPAG    => ln_CuoPagads,
                                            ln_NCPEND  => ln_CuoPndients,
                                            lv_antpcuo => lv_EsAntUltCuo,
                                            ln_atraso  => ln_Atraso,
                                            ln_porc15  => ln_QuincePorc,
                                            ln_cap2cuo => ln_Cap2UltCuo,
                                            ln_bbp     => ln_BBP,
                                            ld_FchBBP  => ld_FchIniBBP);
      end if;
    end loop;
  
    for d in data_final(ld_FchSist) loop
    
      begin
        pq_Cr_bbp_impulso.sp_cr_LogAQPB187(ld_fch    => ld_FchSist,
                                           ln_ins    => d.aqpb187ains,
                                           ln_pais   => d.aqpb187apais,
                                           ln_tdoc   => d.aqpb187atdoc,
                                           lv_ndoc   => d.aqpb187andoc,
                                           ln_pgcod  => d.aqpb187apgcod,
                                           ln_mod    => d.aqpb187amod,
                                           ln_suc    => d.aqpb187asuc,
                                           ln_mda    => d.aqpb187amda,
                                           ln_pap    => d.aqpb187apap,
                                           ln_cta    => d.aqpb187acta,
                                           ln_ope    => d.aqpb187aope,
                                           ln_sbop   => d.aqpb187asbop,
                                           ln_tope   => d.aqpb187atope,
                                           lv_idcof  => d.aqpb187aidcof,
                                           lv_codcob => d.aqpb187acodcob,
                                           ld_fdes   => d.aqpb187afdes,
                                           ln_mntdes => d.aqpb187amntdes,
                                           ln_scap   => d.aqpb187ascap,
                                           ld_fibbp  => d.aqpb187afchbbp,
                                           ln_bbp    => d.aqpb187abbp);
      end;
    end loop;
  
    for p in plantilla_crono(ld_FchSist) loop
    
      begin
        select a.aqpb161tceawf
          into ln_TCEA
          from aqpb161a a
         where a.aqpb161inst = p.aqpb187ins
           and a.aqpb161est = 'H';
      exception
        when others then
          ln_TCEA := 0;
      end;
    
      begin
        -- Call the procedure
        PQ_CR_ACTUALIZACIONES.sp_cr_TasaActual(ln_pgcod   => p.aqpb187pgcod,
                                               ln_mod     => p.aqpb187mod,
                                               ln_suc     => p.aqpb187suc,
                                               ln_mda     => p.aqpb187mda,
                                               ln_pap     => p.aqpb187pap,
                                               ln_cta     => p.aqpb187cta,
                                               ln_oper    => p.aqpb187ope,
                                               ln_subop   => p.aqpb187sbop,
                                               ln_tope    => p.aqpb187tope,
                                               ln_TasaAct => ln_TEA);
      end;
    
      for c in calendario(p.aqpb187pgcod, p.aqpb187mod, p.aqpb187suc, p.aqpb187mda, p.aqpb187pap, p.aqpb187cta, p.aqpb187ope, p.aqpb187sbop, p.aqpb187tope, p.aqpb187fibbp) loop
      
        Dia_Atraso     := 0;
        ld_FchPago     := null;
        Dia_Atraso     := null;
        ln_DiaAtraso   := null;
        ln_SaldCapCuot := null;
      
        begin
          select f.pp1fech, f.pp1fech - f.ppfpag
            into ld_FchPago, Dia_Atraso
            from fsd602 f
           where f.pgcod = p.aqpb187pgcod
             and f.ppmod = p.aqpb187mod
             and f.ppsuc = p.aqpb187suc
             and f.ppmda = p.aqpb187mda
             and f.pppap = p.aqpb187pap
             and f.ppcta = p.aqpb187cta
             and f.ppoper = p.aqpb187ope
             and f.ppsbop = p.aqpb187sbop
             and f.pptope = p.aqpb187tope
             and f.ppfpag = c.ppfpag
             and f.d602co = 'S'
             and f.pp1stat = 'T';
        exception
          when others then
            null;
        end;
      
        if Dia_Atraso < 0 then
          ln_DiaAtraso := 0;
        else
          ln_DiaAtraso := Dia_Atraso;
        end if;
      
        if ld_FchPago is not null then
        
          begin
            select count(*)
              into ln_LogCofide
              from aqpc366h t
             where t.aqpc366hemp = p.aqpb187pgcod
               and t.aqpc366hmod = p.aqpb187mod
               and t.aqpc366hsuc = p.aqpb187suc
               and t.aqpc366hmnda = p.aqpb187mda
               and t.aqpc366hpapl = p.aqpb187pap
               and t.aqpc366hncta = p.aqpb187cta
               and t.aqpc366hnope = p.aqpb187ope
               and t.aqpc366hsbop = p.aqpb187sbop
               and t.aqpc366htope = p.aqpb187tope
               and t.aqpc366husur = 'BANTPROD'
               and t.aqpc366hfproc = ld_FchPago + 1;
          exception
            when others then
              null;
          end;
        
          if ln_LogCofide > 0 then
            begin
              select max(t.aqpc366hscap)
                into ln_SaldCapCuot
                from aqpc366h t
               where t.aqpc366hemp = p.aqpb187pgcod
                 and t.aqpc366hmod = p.aqpb187mod
                 and t.aqpc366hsuc = p.aqpb187suc
                 and t.aqpc366hmnda = p.aqpb187mda
                 and t.aqpc366hpapl = p.aqpb187pap
                 and t.aqpc366hncta = p.aqpb187cta
                 and t.aqpc366hnope = p.aqpb187ope
                 and t.aqpc366hsbop = p.aqpb187sbop
                 and t.aqpc366htope = p.aqpb187tope
                 and t.aqpc366husur = 'BANTPROD'
                 and t.aqpc366hfproc = ld_FchPago + 1;
            exception
              when others then
                ln_SaldCapCuot := 0;
            end;
          
          else
            begin
              select f.ppcap
                into ln_MntCapCuo
                from fsd601 f
               where f.pgcod = p.aqpb187pgcod
                 and f.ppmod = p.aqpb187mod
                 and f.ppsuc = p.aqpb187suc
                 and f.ppmda = p.aqpb187mda
                 and f.pppap = p.aqpb187pap
                 and f.ppcta = p.aqpb187cta
                 and f.ppoper = p.aqpb187ope
                 and f.ppsbop = p.aqpb187sbop
                 and f.pptope = p.aqpb187tope
                 and f.ppfpag = c.ppfpag
                 and f.d601co = 'S';
            exception
              when others then
                null;
            end;
          
            if ln_MntCapCuo = 0 then
            
              begin
                select x.xllcapital
                  into ln_SaldCapCuot
                  from x054023 x
                 where x.xllpgcod = p.aqpb187pgcod
                   and x.xllaomod = p.aqpb187mod
                   and x.xllaosuc = p.aqpb187suc
                   and x.xllaomda = p.aqpb187mda
                   and x.xllaopap = p.aqpb187pap
                   and x.xllaocta = p.aqpb187cta
                   and x.xllaooper = p.aqpb187ope
                   and x.xllaosbop = p.aqpb187sbop
                   and x.xllaotop = p.aqpb187tope;
              exception
                when others then
                  ln_SaldCapCuot := 0;
              end;
            
            else
            
              begin
                select x.xllcapital
                  into ln_MntDesemb
                  from x054023 x
                 where x.xllpgcod = p.aqpb187pgcod
                   and x.xllaomod = p.aqpb187mod
                   and x.xllaosuc = p.aqpb187suc
                   and x.xllaomda = p.aqpb187mda
                   and x.xllaopap = p.aqpb187pap
                   and x.xllaocta = p.aqpb187cta
                   and x.xllaooper = p.aqpb187ope
                   and x.xllaosbop = p.aqpb187sbop
                   and x.xllaotop = p.aqpb187tope;
              exception
                when others then
                  ln_MntDesemb := 0;
              end;
            
              begin
                select sum(f.ppcap)
                  into ln_MntCapCuo
                  from fsd601 f
                 where f.pgcod = p.aqpb187pgcod
                   and f.ppmod = p.aqpb187mod
                   and f.ppsuc = p.aqpb187suc
                   and f.ppmda = p.aqpb187mda
                   and f.pppap = p.aqpb187pap
                   and f.ppcta = p.aqpb187cta
                   and f.ppoper = p.aqpb187ope
                   and f.ppsbop = p.aqpb187sbop
                   and f.pptope = p.aqpb187tope
                   and f.ppfpag <= c.ppfpag
                   and f.d601co = 'S';
              exception
                when others then
                  ln_MntCapCuo := 0;
              end;
            
              ln_SaldCapCuot := nvl(ln_MntDesemb, 0) - nvl(ln_MntCapCuo, 0);
            
            end if;
          end if;
        end if;
      
        pq_cr_bbp_impulso.sp_cr_LogAQPB188(ld_fch     => ld_FchSist,
                                           ln_ins     => p.aqpb187ins,
                                           ln_pgcod   => p.aqpb187pgcod,
                                           ln_mod     => p.aqpb187mod,
                                           ln_suc     => p.aqpb187suc,
                                           ln_mda     => p.aqpb187mda,
                                           ln_pap     => p.aqpb187pap,
                                           ln_cta     => p.aqpb187cta,
                                           ln_ope     => p.aqpb187ope,
                                           ln_sbop    => p.aqpb187sbop,
                                           ln_tope    => p.aqpb187tope,
                                           ln_fcron   => c.ppfpag,
                                           ln_pais    => p.aqpb187pais,
                                           ln_tdoc    => p.aqpb187tdoc,
                                           lv_ndoc    => p.aqpb187ndoc,
                                           lv_idcof   => p.aqpb187idcof,
                                           ln_ncuot   => c.ln_nroreg,
                                           ln_tcea    => ln_TCEA,
                                           ln_tea     => ln_TEA,
                                           ld_fpagbn  => ld_FchPago,
                                           ln_datraso => ln_DiaAtraso,
                                           ln_salcap  => ln_SaldCapCuot);
      end loop;
    
    end loop;
  
  end sp_Cr_Inicio;
  ----------------------------------------------------------
  procedure sp_cr_VerfAmort(ln_pgcod    in number,
                            ln_mod      in number,
                            ln_suc      in number,
                            ln_mda      in number,
                            ln_pap      in number,
                            ln_cta      in number,
                            ln_oper     in number,
                            ln_sbop     in number,
                            ln_tope     in number,
                            lc_TnAmortz out varchar2) is
    ln_NroAmortizcns number;
  
  begin
  
    begin
      select count(*)
        into ln_NroAmortizcns
        from fsd012 f
       where f.pgcod = ln_pgcod
         and f.aomod = ln_mod
         and f.aosuc = ln_suc
         and f.aomda = ln_mda
         and f.aopap = ln_pap
         and f.aocta = ln_cta
         and f.aooper = ln_oper
         and f.aosbop = ln_sbop
         and f.aotope = ln_tope
         and f.evtipo = 50
         and f.d012co = 'S';
    exception
      when others then
        null;
    end;
  
    if ln_NroAmortizcns = 0 then
      lc_TnAmortz := 'N';
    else
      if ln_NroAmortizcns > 0 then
        lc_TnAmortz := 'S';
      end if;
    end if;
  
  end sp_cr_VerfAmort;
  -----------------------------------------------------------
  procedure sp_Cr_VerfAntUltCuot(ln_pgcod       in number,
                                 ln_mod         in number,
                                 ln_suc         in number,
                                 ln_mda         in number,
                                 ln_pap         in number,
                                 ln_cta         in number,
                                 ln_oper        in number,
                                 ln_sbop        in number,
                                 ln_tope        in number,
                                 ln_CuoCaln     out number,
                                 ln_CuotPag     out number,
                                 ln_CuoPend     out number,
                                 lc_EsAntUltCuo out varchar2,
                                 ln_capital     out number,
                                 ld_FchBBP      out date) is
  
    ln_NroCuot  number;
    ln_CuotPagd number;
    ln_CuotCtrl number;
    ln_CuotPend number := 0;
    -- ld_FchBBP   date;
  
  begin
    lc_EsAntUltCuo := 'N';
    ln_capital     := 0;
  
    begin
      select x.xllcantcuo
        into ln_NroCuot
        from x054023 x
       where x.xllpgcod = ln_pgcod
         and x.xllaomod = ln_mod
         and x.xllaosuc = ln_suc
         and x.xllaomda = ln_mda
         and x.xllaopap = ln_pap
         and x.xllaocta = ln_cta
         and x.xllaooper = ln_oper
         and x.xllaosbop = ln_sbop
         and x.xllaotop = ln_tope;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_CuotPagd
        from fsd602 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_oper
         and f.ppsbop = ln_sbop
         and f.pptope = ln_tope
         and f.pp1stat = 'T'
         and f.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    ln_CuotCtrl := ln_NroCuot - 2;
  
    if ln_CuotCtrl <= ln_CuotPagd then
      lc_EsAntUltCuo := 'S';
    end if;
  
    ln_CuotPend := nvl(ln_NroCuot, 0) - nvl(ln_CuotPagd, 0);
  
    if ln_CuotPend <= 2 then
    
      begin
        select sum(ln_cap)
          into ln_capital
          from (select f.ppcap ln_cap
                  from fsd601 f
                 where f.pgcod = ln_pgcod
                   and f.ppmod = ln_mod
                   and f.ppsuc = ln_suc
                   and f.ppmda = ln_mda
                   and f.pppap = ln_pap
                   and f.ppcta = ln_cta
                   and f.ppoper = ln_oper
                   and f.ppsbop = ln_sbop
                   and f.pptope = ln_tope
                   and f.d601co = 'S'
                   and rownum <= ln_CuotPend
                 order by f.ppfpag desc) dual;
      exception
        when others then
          ln_capital := 0;
      end;
    
      begin
        select min(g.ppfpag)
          into ld_FchBBP
          from fsd601 g
         where g.pgcod = ln_pgcod
           and g.ppmod = ln_mod
           and g.ppsuc = ln_suc
           and g.ppmda = ln_mda
           and g.pppap = ln_pap
           and g.ppcta = ln_cta
           and g.ppoper = ln_oper
           and g.ppsbop = ln_sbop
           and g.pptope = ln_tope
           and g.ppfpag > (select max(f.ppfpag)
                             from fsd602 f
                            where f.pgcod = ln_pgcod
                              and f.ppmod = ln_mod
                              and f.ppsuc = ln_suc
                              and f.ppmda = ln_mda
                              and f.pppap = ln_pap
                              and f.ppcta = ln_cta
                              and f.ppoper = ln_oper
                              and f.ppsbop = ln_sbop
                              and f.pptope = ln_tope
                              and f.pp1stat = 'T'
                              and f.d602co = 'S');
      exception
        when others then
          null;
      end;
    
    else
      if ln_CuotPend <= 3 then
        begin
          select sum(ln_cap)
            into ln_capital
            from (select f.ppcap ln_cap
                    from fsd601 f
                   where f.pgcod = ln_pgcod
                     and f.ppmod = ln_mod
                     and f.ppsuc = ln_suc
                     and f.ppmda = ln_mda
                     and f.pppap = ln_pap
                     and f.ppcta = ln_cta
                     and f.ppoper = ln_oper
                     and f.ppsbop = ln_sbop
                     and f.pptope = ln_tope
                     and f.d601co = 'S'
                     and rownum <= 3
                   order by f.ppfpag desc) dual;
        exception
          when others then
            ln_capital := 0;
        end;
      
        begin
          select min(g.ppfpag)
            into ld_FchBBP
            from fsd601 g
           where g.pgcod = ln_pgcod
             and g.ppmod = ln_mod
             and g.ppsuc = ln_suc
             and g.ppmda = ln_mda
             and g.pppap = ln_pap
             and g.ppcta = ln_cta
             and g.ppoper = ln_oper
             and g.ppsbop = ln_sbop
             and g.pptope = ln_tope
             and g.ppfpag > (select max(f.ppfpag)
                               from fsd602 f
                              where f.pgcod = ln_pgcod
                                and f.ppmod = ln_mod
                                and f.ppsuc = ln_suc
                                and f.ppmda = ln_mda
                                and f.pppap = ln_pap
                                and f.ppcta = ln_cta
                                and f.ppoper = ln_oper
                                and f.ppsbop = ln_sbop
                                and f.pptope = ln_tope
                                and f.pp1stat = 'T'
                                and f.d602co = 'S');
        exception
          when others then
            null;
        end;
      
      end if;
    end if;
  
    ln_CuoCaln := ln_NroCuot;
    ln_CuotPag := ln_CuotPagd;
    ln_CuoPend := ln_CuotPend;
    ln_capital := nvl(ln_capital, 0);
  
  end sp_Cr_VerfAntUltCuot;
  -----------------------------------------------------------
  procedure sp_Cr_AtrasoMax(ln_pgcod     in number,
                            ln_mod       in number,
                            ln_suc       in number,
                            ln_mda       in number,
                            ln_pap       in number,
                            ln_cta       in number,
                            ln_ope       in number,
                            ln_sbop      in number,
                            ln_tope      in number,
                            ld_Fecha     in date,
                            ln_AtrasoMax out number) is
  
    cursor calendario is
    
      select *
        from fsd601 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_ope
         and f.ppsbop = ln_sbop
         and f.pptope = ln_tope
         and f.ppfpag <= ld_Fecha
         and f.d601co = 'S'
       order by ppfpag;
  
    ld_Dias     number;
    ln_NroCuota number := 0;
  
  begin
  
    for c in calendario loop
      ld_Dias := 0;
    
      begin
        select g.pp1fech - g.ppfpag
          into ld_Dias
          from fsd602 g
         where g.pgcod = c.pgcod
           and g.ppmod = c.ppmod
           and g.ppsuc = c.ppsuc
           and g.ppmda = c.ppmda
           and g.pppap = c.pppap
           and g.ppcta = c.ppcta
           and g.ppoper = c.ppoper
           and g.ppsbop = c.ppsbop
           and g.pptope = c.pptope
           and g.ppfpag = c.ppfpag
           and g.pp1stat = 'T'
           and g.d602co = 'S';
      Exception
        when others then
          begin
            select ld_Fecha - g.ppfpag
              into ld_Dias
              from fsd602 g
             where g.pgcod = c.pgcod
               and g.ppmod = c.ppmod
               and g.ppsuc = c.ppsuc
               and g.ppmda = c.ppmda
               and g.pppap = c.pppap
               and g.ppcta = c.ppcta
               and g.ppoper = c.ppoper
               and g.ppsbop = c.ppsbop
               and g.pptope = c.pptope
               and g.ppfpag = c.ppfpag
               and g.pp1stat = 'T'
               and g.d602co = 'S';
          exception
            when others then
              ld_Dias := 9999;
          end;
      end;
    
      if ld_Dias > 8 then
        ln_NroCuota := ln_NroCuota + 1;
      end if;
    end loop;
  
    ln_atrasoMax := ln_NroCuota;
  
  end sp_Cr_AtrasoMax;
  -----------------------------------------------------------
  procedure sp_cr_LogAQPB187A(ld_fecha   in date,
                              ln_ins     in number,
                              ln_pais    in number,
                              ln_tdoc    in number,
                              lv_ndoc    in varchar2,
                              ln_pgcod   in number,
                              ln_mod     in number,
                              ln_suc     in number,
                              ln_mda     in number,
                              ln_pap     in number,
                              ln_cta     in number,
                              ln_ope     in number,
                              ln_sbop    in number,
                              ln_tope    in number,
                              lv_idcof   in varchar2,
                              lv_codcob  in varchar2,
                              ld_fdes    in date,
                              ln_mntdes  in number,
                              ln_scap    in number,
                              lv_amortz  in varchar2,
                              ln_NCUOTS  in number,
                              ln_CPAG    in number,
                              ln_NCPEND  in number,
                              lv_antpcuo in varchar2,
                              ln_atraso  in number,
                              ln_porc15  in number,
                              ln_cap2cuo in number,
                              ln_bbp     in number,
                              ld_FchBBP  in date) is
  
    ln_cor  number := 0;
    lc_hora varchar2(10);
  
  begin
  
    begin
      select max(a.aqpb187acor)
        into ln_cor
        from aqpb187a a
       where a.aqpb187afch = ld_fecha;
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb187a
        (aqpb187acor,
         aqpb187afch,
         aqpb187ahora,
         aqpb187ains,
         aqpb187apais,
         aqpb187atdoc,
         aqpb187andoc,
         aqpb187apgcod,
         aqpb187amod,
         aqpb187asuc,
         aqpb187amda,
         aqpb187apap,
         aqpb187acta,
         aqpb187aope,
         aqpb187asbop,
         aqpb187atope,
         aqpb187aidcof,
         aqpb187acodcob,
         aqpb187afdes,
         aqpb187amntdes,
         aqpb187ascap,
         aqpb187aamortz,
         AQPB187ANCUOTS,
         AQPB187ANCPAG,
         AQPB187ANCPEND,
         aqpb187aantpcuo,
         aqpb187aatraso,
         aqpb187aporc15,
         aqpb187acap2cuo,
         aqpb187abbp,
         aqpb187aFchBBP)
      values
        (ln_cor + 1,
         ld_fecha,
         lc_hora,
         ln_ins,
         ln_pais,
         ln_tdoc,
         lv_ndoc,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         lv_idcof,
         lv_codcob,
         ld_fdes,
         ln_mntdes,
         ln_scap,
         lv_amortz,
         ln_NCUOTS,
         ln_CPAG,
         ln_NCPEND,
         lv_antpcuo,
         ln_atraso,
         ln_porc15,
         ln_cap2cuo,
         ln_bbp,
         ld_FchBBP);
      commit;
    end;
  
  end sp_cr_LogAQPB187A;
  -------------------------------------------------------------
  procedure sp_cr_LogAQPB187(ld_fch    in date,
                             ln_ins    in number,
                             ln_pais   in number,
                             ln_tdoc   in number,
                             lv_ndoc   in varchar2,
                             ln_pgcod  in number,
                             ln_mod    in number,
                             ln_suc    in number,
                             ln_mda    in number,
                             ln_pap    in number,
                             ln_cta    in number,
                             ln_ope    in number,
                             ln_sbop   in number,
                             ln_tope   in number,
                             lv_idcof  in varchar2,
                             lv_codcob in varchar2,
                             ld_fdes   in date,
                             ln_mntdes in number,
                             ln_scap   in number,
                             ld_fibbp  in date,
                             ln_bbp    in number) is
  
    ln_cor number := 0;
  
  begin
  
    begin
      select max(a.aqpb187cor)
        into ln_cor
        from aqpb187 a
       where a.aqpb187fch = ld_fch;
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      insert into aqpb187
        (aqpb187cor,
         aqpb187fch,
         aqpb187ins,
         aqpb187pais,
         aqpb187tdoc,
         aqpb187ndoc,
         aqpb187pgcod,
         aqpb187mod,
         aqpb187suc,
         aqpb187mda,
         aqpb187pap,
         aqpb187cta,
         aqpb187ope,
         aqpb187sbop,
         aqpb187tope,
         aqpb187idcof,
         aqpb187codcob,
         aqpb187fdes,
         aqpb187mntdes,
         aqpb187scap,
         aqpb187fibbp,
         aqpb187bbp,
         aqpb187est)
      values
        (ln_cor + 1,
         ld_fch,
         ln_ins,
         ln_pais,
         ln_tdoc,
         lv_ndoc,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         lv_idcof,
         lv_codcob,
         ld_fdes,
         ln_mntdes,
         ln_scap,
         ld_fibbp,
         ln_bbp,
         'No Aplicado');
      commit;
    end;
  
  end sp_cr_LogAQPB187;
  -------------------------------------------------------------
  procedure sp_cr_LogAQPB188(ld_fch     in date,
                             ln_ins     in number,
                             ln_pgcod   in number,
                             ln_mod     in number,
                             ln_suc     in number,
                             ln_mda     in number,
                             ln_pap     in number,
                             ln_cta     in number,
                             ln_ope     in number,
                             ln_sbop    in number,
                             ln_tope    in number,
                             ln_fcron   in date,
                             ln_pais    in number,
                             ln_tdoc    in number,
                             lv_ndoc    in varchar2,
                             lv_idcof   in varchar2,
                             ln_ncuot   in number,
                             ln_tcea    in number,
                             ln_tea     in number,
                             ld_fpagbn  in varchar2,
                             ln_datraso in number,
                             ln_salcap  in number) is
  
    ln_cor number := 0;
  begin
  
    begin
      select max(a.aqpb188cor)
        into ln_cor
        from aqpb188 a
       where a.aqpb188fch = ld_fch;
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      insert into aqpb188
        (aqpb188cor,
         aqpb188fch,
         aqpb188ins,
         aqpb188pgcod,
         aqpb188mod,
         aqpb188suc,
         aqpb188mda,
         aqpb188pap,
         aqpb188cta,
         aqpb188ope,
         aqpb188sbop,
         aqpb188tope,
         aqpb188fcron,
         aqpb188pais,
         aqpb188tdoc,
         aqpb188ndoc,
         aqpb188idcof,
         aqpb188ncuot,
         aqpb188tcea,
         aqpb188tea,
         aqpb188fpagbn,
         aqpb188datraso,
         aqpb188salcap)
      values
        (ln_cor + 1,
         ld_fch,
         ln_ins,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_fcron,
         ln_pais,
         ln_tdoc,
         lv_ndoc,
         lv_idcof,
         ln_ncuot,
         ln_tcea,
         ln_tea,
         ld_fpagbn,
         ln_datraso,
         ln_salcap);
      commit;
    end;
  
  end sp_cr_LogAQPB188;
  -------------------------------------------------------------
  procedure sp_cr_Voucher(ln_pgcodt in number,
                          ln_suct   in number,
                          ln_modt   in number,
                          ln_ttran  in number,
                          ln_relt   in number,
                          ln_ordt   in number,
                          ln_subord in number,
                          lv_Flag   out varchar2,
                          lv_msg    out varchar2) is
  
    ln_cont number;
  
  begin
    lv_Flag := 'N';
    lv_msg  := '';
  
    begin
      select count(*)
        into ln_cont
        from aqpb189 a
       where a.aqpb189pgcod = ln_pgcodt
         and a.aqpb189suctx = ln_suct
         and a.aqpb189modtx = ln_modt
         and a.aqpb189tx = ln_ttran
         and a.aqpb189reltx = ln_relt
         and a.aqpb189ordtx = ln_ordt
         and a.aqpb189sbordtx = ln_subord
         and a.aqpb189fch =
             (select f.pgfape from fst017 f where f.pgcod = 1)
         and a.aqpb189est = 'H';
    exception
      when others then
        ln_cont := 0;
    end;
  
    if ln_cont > 0 then
    
      lv_Flag := 'S';
      lv_msg  := 'Usted ha calificado al Bono del Buen Pagador de su crédito Impulso';
    
    else
      lv_Flag := 'N';
      lv_msg  := '';
    
    end if;
  
  end sp_cr_voucher;
  -------------------------------------------------------------
  procedure sp_cr_RTEPagos(ln_pgcodt  in number,
                           ln_suct    in number,
                           ln_modt    in number,
                           ln_ttran   in number,
                           ln_relt    in number,
                           ln_ordt    in number,
                           ln_subord  in number,
                           lv_pcancel out varchar2,
                           lv_msj     out varchar2) is
  
    ln_pgcod    number;
    ln_modulo   number;
    ln_sucur    number;
    ln_mda      number;
    ln_pap      number;
    ln_cta      number;
    ln_ope      number;
    ln_sbop     number;
    ln_tope     number;
    lc_Amortzcn varchar2(5) := 'N';
    --ln_NroCuo     number;
    --ln_CuoPag     number;
    --ln_CuoPend    number;
    lv_IndAnpCuot varchar2(5) := 'N';
    --ln_Capital    number(17, 2);
    -- ld_FchBBP     date;
    ln_NCuoAtraso number;
    ld_FchSist    date;
    ln_Existe     number;
    ln_NroCuot    number;
    ln_CuotPagd   number;
    ln_CuotCtrl   number;
    ld_MaxFchPag  date;
    ln_pgcodtx    number;
    ln_modtx      number;
    ln_suctx      number;
    ln_tx         number;
    ln_reltx      number;
    ld_fectx      date;
    ln_ordtx      number;
    ln_subtx      number;
    ln_PagoAntes  number := 0;
  
  begin
  
    lv_pcancel    := 'N';
    lv_msj        := '';
    lv_IndAnpCuot := 'N';
    ln_PagoAntes  := 0;
  
    begin
      select f.pgcod,
             f.modulo,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo,
             f.ittope
        into ln_pgcod,
             ln_modulo,
             ln_sucur,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbop,
             ln_tope
        from fsd016 f
       where f.pgcod = ln_pgcodt
         and f.itsuc = ln_suct
         and f.itmod = ln_modt
         and f.ittran = ln_ttran
         and f.itnrel = ln_relt
         and f.itord = ln_ordt
         and f.itsbor = ln_subord;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    if ln_modulo = 101 and ln_tope = 360 then
    
      begin
        select count(*)
          into ln_Existe
          from aqpb187 a
         where a.aqpb187pgcod = ln_pgcod
           and a.aqpb187mod = ln_modulo
           and a.aqpb187suc = ln_sucur
           and a.aqpb187mda = ln_mda
           and a.aqpb187pap = ln_pap
           and a.aqpb187cta = ln_cta
           and a.aqpb187ope = ln_ope
           and a.aqpb187sbop = ln_sbop
           and a.aqpb187tope = ln_tope;
      exception
        when others then
          ln_Existe := 0;
      end;
    
      if ln_Existe = 0 then
        begin
          begin
            select max(f.ppfpag)
              into ld_MaxFchPag
              from fsd602 f
             where f.pgcod = ln_pgcod
               and f.ppmod = ln_modulo
               and f.ppsuc = ln_sucur
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_ope
               and f.ppsbop = ln_sbop
               and f.pptope = ln_tope
               and f.pp1stat = 'T'
               and f.d602co = 'S';
          exception
            when others then
              null;
          end;
        
          if ld_MaxFchPag is not null then
          
            begin
              select f.d602cd,
                     f.d602mo,
                     f.d602su,
                     f.d602tr,
                     f.d602re,
                     f.d602fc,
                     f.d602or,
                     f.d602sb
                into ln_pgcodtx,
                     ln_modtx,
                     ln_suctx,
                     ln_tx,
                     ln_reltx,
                     ld_fectx,
                     ln_ordtx,
                     ln_subtx
                from fsd602 f
               where f.pgcod = ln_pgcod
                 and f.ppmod = ln_modulo
                 and f.ppsuc = ln_sucur
                 and f.ppmda = ln_mda
                 and f.pppap = ln_pap
                 and f.ppcta = ln_cta
                 and f.ppoper = ln_ope
                 and f.ppsbop = ln_sbop
                 and f.pptope = ln_tope
                 and f.pp1stat = 'T'
                 and f.d602co = 'S'
                 and f.ppfpag = ld_MaxFchPag;
            exception
              when others then
                null;
            end;
          
          end if;
        end;
      
        begin
          select count(*)
            into ln_PagoAntes
            from aqpb189 a
           where a.aqpb189fch = ld_fectx
             and a.aqpb189pgcod = ln_pgcodtx
             and a.aqpb189suctx = ln_suctx
             and a.aqpb189modtx = ln_modtx
             and a.aqpb189tx = ln_tx
             and a.aqpb189reltx = ln_reltx
             and a.aqpb189ordtx = ln_ordtx
             and a.aqpb189sbordtx = ln_subtx
             and a.aqpb189est = 'H';
        exception
          when others then
            ln_PagoAntes := 0;
        end;
      
      end if;
    
      if ln_Existe = 0 and ln_PagoAntes = 0 then
      
        pq_Cr_bbp_impulso.sp_cr_VerfAmort(ln_pgcod    => ln_pgcod,
                                          ln_mod      => ln_modulo,
                                          ln_suc      => ln_sucur,
                                          ln_mda      => ln_mda,
                                          ln_pap      => ln_pap,
                                          ln_cta      => ln_cta,
                                          ln_oper     => ln_ope,
                                          ln_sbop     => ln_sbop,
                                          ln_tope     => ln_tope,
                                          lc_TnAmortz => lc_Amortzcn);
        if lc_Amortzcn = 'N' then
        
          begin
            select x.xllcantcuo
              into ln_NroCuot
              from x054023 x
             where x.xllpgcod = ln_pgcod
               and x.xllaomod = ln_modulo
               and x.xllaosuc = ln_sucur
               and x.xllaomda = ln_mda
               and x.xllaopap = ln_pap
               and x.xllaocta = ln_cta
               and x.xllaooper = ln_ope
               and x.xllaosbop = ln_sbop
               and x.xllaotop = ln_tope;
          exception
            when others then
              null;
          end;
        
          begin
            select count(*)
              into ln_CuotPagd
              from fsd602 f
             where f.pgcod = ln_pgcod
               and f.ppmod = ln_modulo
               and f.ppsuc = ln_sucur
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_ope
               and f.ppsbop = ln_sbop
               and f.pptope = ln_tope
               and f.pp1stat = 'T'
               and f.d602co = 'S';
          exception
            when others then
              null;
          end;
        
          ln_CuotCtrl := ln_NroCuot - 3;
        
          if ln_CuotCtrl <= ln_CuotPagd then
            lv_IndAnpCuot := 'S';
          end if;
        
          if lv_IndAnpCuot = 'S' then
          
            pq_Cr_bbp_impulso.sp_Cr_AtrasoMax(ln_pgcod     => ln_pgcod,
                                              ln_mod       => ln_modulo,
                                              ln_suc       => ln_sucur,
                                              ln_mda       => ln_mda,
                                              ln_pap       => ln_pap,
                                              ln_cta       => ln_cta,
                                              ln_ope       => ln_ope,
                                              ln_sbop      => ln_sbop,
                                              ln_tope      => ln_tope,
                                              ld_Fecha     => ld_FchSist,
                                              ln_AtrasoMax => ln_NCuoAtraso);
            if ln_NCuoAtraso < 3 then
            
              lv_pcancel := 'S';
              lv_msj     := 'Informar al cliente que con el pago total de esta cuota califica al BBP, no pudiendo realizar una cancelación o pago anticipado sino perderá el  beneficio, para lo cual se debe actualizar los datos de celular y correo vigente del cliente';
            
              pq_Cr_bbp_impulso.sp_Cr_LogAQPB189(ld_fch     => ld_FchSist,
                                                 ln_pgcod   => ln_pgcodt,
                                                 ln_suctx   => ln_suct,
                                                 ln_modtx   => ln_modt,
                                                 ln_tx      => ln_ttran,
                                                 ln_reltx   => ln_relt,
                                                 ln_ordtx   => ln_ordt,
                                                 ln_sbordtx => ln_subord);
            else
              lv_pcancel := 'N';
              lv_msj     := '';
            end if;
          else
            lv_pcancel := 'N';
            lv_msj     := '';
          end if;
        else
          lv_pcancel := 'N';
          lv_msj     := '';
        end if;
      else
        lv_pcancel := 'N';
        lv_msj     := '';
      end if;
    else
      lv_pcancel := 'N';
      lv_msj     := '';
    end if;
  
  end sp_cr_RTEPagos;
  ----------------------------------------
  procedure sp_Cr_LogAQPB189(ld_fch     in date,
                             ln_pgcod   in number,
                             ln_suctx   in number,
                             ln_modtx   in number,
                             ln_tx      in number,
                             ln_reltx   in number,
                             ln_ordtx   in number,
                             ln_sbordtx in number) is
  
    ln_Cor number := 0;
  
  begin
  
    begin
      select max(a.aqpb189cor)
        into ln_Cor
        from aqpb189 a
       where a.aqpb189fch = ld_fch;
    exception
      when others then
        ln_Cor := 0;
    end;
  
    ln_Cor := nvl(ln_Cor, 0);
  
    begin
      insert into aqpb189
        (aqpb189cor,
         aqpb189fch,
         aqpb189pgcod,
         aqpb189suctx,
         aqpb189modtx,
         aqpb189tx,
         aqpb189reltx,
         aqpb189ordtx,
         aqpb189sbordtx,
         aqpb189est)
      values
        (ln_Cor + 1,
         ld_fch,
         ln_pgcod,
         ln_suctx,
         ln_modtx,
         ln_tx,
         ln_reltx,
         ln_ordtx,
         ln_sbordtx,
         'H');
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_Cr_LogAQPB189;
  -----------------------------------------------------------
end PQ_CR_BBP_IMPULSO;
/
