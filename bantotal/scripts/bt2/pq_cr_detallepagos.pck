create or replace package PQ_CR_DETALLEPAGOS is

  -- Author  : MPOSTIGOC
  -- Created : 7/05/2024 10:14:31
  -- Purpose : Procedimientos para calcular los importes pagados en creditos 
  -- Fecha de Modificación      : 28/05/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico el script para obtener el capital pagado
  -- Fecha de Modificación      : 31/05/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego procedimiento para obtener el monto desembolsado en el alta de credito
  -- Fecha de Modificación      : 05/06/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modificó el script para obtener la fecha fin del evento.
  -----------------------------------------------------------------------------------------------

  procedure sp_cr_inicio(lc_usuario in char, lc_Credito in varchar2);
  -------------------------------------------------------------------------
  procedure sp_Cr_importes(ln_pgcod   in number,
                           ln_itmod   in number,
                           ln_ittran  in number,
                           ln_itsuc   in number,
                           ln_itnrel  in number,
                           ld_fcon    in date,
                           ld_fpag    out date,
                           ln_hmod    out number,
                           ln_htran   out number,
                           ln_hsucor  out number,
                           ln_rela    out number,
                           ln_cap     out number,
                           ln_int     out number,
                           ln_ice     out number,
                           ln_mora    out number,
                           ln_seguros out number,
                           ln_rubobli out number,
                           ln_gastos  out number);
  ---------------------------------------------------
  procedure sp_cr_totaleshist(lc_usuario   in char,
                              lc_Credito   in varchar2,
                              ln_CapTotPag out number,
                              ln_IntTotPag out number,
                              ln_MorTotPag out number,
                              ln_SegTotPag out number,
                              ln_ICVTotPag out number,
                              ln_PenTotPag out number,
                              ln_CapNegTot out number,
                              ln_IntDeudor out number,
                              ln_mntDesemb out number);
  --------------------------------------------------
  procedure sp_cr_logAQPC866(ld_866fec    in date,
                             lc_866cred   in varchar2,
                             ln_NroCamb   in number,
                             lc_866usr    in varchar2,
                             ln_866pgcod  in number,
                             ln_866mod    in number,
                             ln_866suc    in number,
                             ln_866mda    in number,
                             ln_866pap    in number,
                             ln_866cta    in number,
                             ln_866oper   in number,
                             ln_866sbop   in number,
                             ln_866tope   in number,
                             ld_FchIni    in date,
                             ld_FchFin    in date,
                             ld_866fpag   in date,
                             ln_866cap    in number,
                             ln_866int    in number,
                             ln_866susepa in number,
                             ld_866fpag2  in date,
                             ln_866moncap in number,
                             ln_866pagcap in number,
                             ln_866pagint in number,
                             ln_866painca in number,
                             ln_866pagmor in number,
                             ln_866pagpen in number,
                             ln_866pagicv in number,
                             ln_866pagseg in number,
                             ln_866pagotr in number,
                             ln_866tcd    in number,
                             ln_866tmo    in number,
                             ln_866tsu    in number,
                             ln_866ttr    in number,
                             ln_866tre    in number,
                             ld_866tfc    in date,
                             ln_IntDeu    in number);

  function fn_cr_mtodesembolso(v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number) return number;

end PQ_CR_DETALLEPAGOS;
/

create or replace package body PQ_CR_DETALLEPAGOS is

  procedure sp_cr_inicio(lc_usuario in char, lc_Credito in varchar2) is
  
    cursor inicio is
      select a.aqpb838cod1,
             a.aqpb838mod1,
             a.aqpb838suc1,
             a.aqpb838mda1,
             a.aqpb838pap1,
             a.aqpb838cta1,
             a.aqpb838oper1,
             a.aqpb838sbop1,
             a.aqpb838tope1,
             a.aqpb838fc,
             a.aqpb838corr,
             a.aqpb838rel
        from aqpb838 a
       where a.aqpb838usu = lc_usuario
         and a.aqpb838cred = lc_Credito
       order by a.aqpb838corr desc;
  
    cursor calendario(ln_pgcod  number,
                      ln_mod    number,
                      ln_suc    number,
                      ln_mda    number,
                      ln_pap    number,
                      ln_cta    number,
                      ln_ope    number,
                      ln_sbop   number,
                      ln_tope   number,
                      ld_FchIni date,
                      ld_FchFin date) is
      select *
        from fsd602 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_ope
         and f.ppsbop = ln_sbop
         and f.pptope = ln_tope
         and f.d602co = 'S'
         and f.ppfpag between ld_FchIni and ld_FchFin
         and (f.d602mo, f.d602tr) in
             (select tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10871
                 and tp1corr1 = 7
                 and tp1corr2 = 10
                 and tp1corr3 > 0);
  
    cursor CalenUnico(ln_pgcod  number,
                      ln_mod    number,
                      ln_suc    number,
                      ln_mda    number,
                      ln_pap    number,
                      ln_cta    number,
                      ln_ope    number,
                      ln_sbop   number,
                      ln_tope   number,
                      ld_FchIni date) is
      select *
        from fsd602 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_ope
         and f.ppsbop = ln_sbop
         and f.pptope = ln_tope
         and f.d602co = 'S'
         and f.ppfpag >= ld_FchIni
         and (f.d602mo, f.d602tr) in
             (select tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10871
                 and tp1corr1 = 7
                 and tp1corr2 = 10
                 and tp1corr3 > 0);
  
    cursor actualizar is
    
      select distinct a.aqpb838cod1,
                      a.aqpb838mod1,
                      a.aqpb838suc1,
                      a.aqpb838mda1,
                      a.aqpb838pap1,
                      a.aqpb838cta1,
                      a.aqpb838oper1,
                      a.aqpb838sbop1,
                      a.aqpb838tope1,
                      a.aqpb838fc
        from aqpb838 a
       where a.aqpb838usu = lc_usuario
         and a.aqpb838cred = lc_Credito
         and a.aqpb838rel = 2;
  
    ld_FchSist         date;
    ln_Capital         number(17, 2) := 0.00;
    ln_Interes         number(17, 2) := 0.00;
    ln_Seguro          number(17, 2) := 0.00;
    ln_MntCapitalizado number(17, 2) := 0.00;
    ld_FchPago         date;
    ln_ModPago         number;
    ln_TxPago          number;
    ln_SucPago         number;
    ln_RelPago         number;
    ln_CapPagado       number(17, 2) := 0.00;
    ln_IntPagado       number(17, 2) := 0.00;
    ln_ICExtPagado     number(17, 2) := 0.00;
    ln_MoraPagado      number(17, 2) := 0.00;
    ln_SegPagado       number(17, 2) := 0.00;
    ln_OtrsRubrPagado  number(17, 2) := 0.00;
    ln_GastoPagado     number(17, 2) := 0.00;
    ln_NroReg          number := 0;
    ld_FchIni          date;
    ld_FchFin          date;
    ln_CorrAux         number;
    ln_TienePagos      number := 0;
    ln_CapPag          number(17, 2) := 0.00;
    ln_IntPag          number(17, 2) := 0.00;
    ln_MoraPag         number(17, 2) := 0.00;
    ln_PenaPag         number(17, 2) := 0.00;
    ln_ICVPag          number(17, 2) := 0.00;
    ln_SegPag          number(17, 2) := 0.00;
    --ln_Cuenta          number;
    --ln_Operacion       number;
    ld_ULT_FEC      date;
    ld_N_TOT_MONT   number(17, 2) := 0.00;
    lV_ERROR        varchar2(10);
    ln_IntDeudor    number(17, 2) := 0;
    ln_IntDeuCons   number(17, 2) := 0;
    ln_SegPagadoAux number(17, 2) := 0;
    ln_MinCorr      number;
    ln_mtodes       number(17, 2) := 0;
  
  begin
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpc866 a
         set a.aqpc866est = 'I'
       where a.aqpc866usr = lc_usuario
         and a.aqpc866cred = lc_Credito;
      commit;
    end;
  
    begin
      select count(*)
        into ln_NroReg
        from aqpb838 a
       where a.aqpb838usu = lc_usuario
         and a.aqpb838cred = lc_Credito;
    exception
      when others then
        null;
    end;
  
    /* begin
      select substr(lc_Credito, 17, 9) into ln_Cuenta from dual;
    exception
      when others then
        null;
    end;
    
    begin
      select substr(lc_Credito, 26, 9) into ln_Operacion from dual;
    exception
      when others then
        null;
    end;*/
  
    for i in inicio loop
    
      ln_CapPag          := 0;
      ln_IntPag          := 0;
      ln_MoraPag         := 0;
      ln_SegPag          := 0;
      ln_ICVPag          := 0;
      ln_PenaPag         := 0;
      ln_MntCapitalizado := 0;
      ln_IntDeuCons      := 0;
    
      ld_FchIni := i.aqpb838fc;
    
      begin
        select min(a.aqpb838fc) --, a.aqpb838corr
          into ld_FchFin --, ln_CorrAux
          from aqpb838 a
         where a.aqpb838usu = lc_usuario
           and a.aqpb838cred = lc_Credito
           and a.aqpb838cod2 = i.aqpb838cod1
           and a.aqpb838mod2 = i.aqpb838mod1
           and a.aqpb838suc2 = i.aqpb838suc1
           and a.aqpb838mda2 = i.aqpb838mda1
           and a.aqpb838pap2 = i.aqpb838pap1
           and a.aqpb838cta2 = i.aqpb838cta1
           and a.aqpb838oper2 = i.aqpb838oper1
           and a.aqpb838sbop2 = i.aqpb838sbop1
           and a.aqpb838tope2 = i.aqpb838tope1
           and a.aqpb838fc > i.aqpb838fc;
      exception
        when others then
          ld_FchFin  := null;
          ln_CorrAux := null;
      end;
    
      if ld_FchFin is not null then
      
        begin
          select count(*)
            into ln_TienePagos
            from fsd602 f
           where f.pgcod = i.aqpb838cod1
             and f.ppmod = i.aqpb838mod1
             and f.ppsuc = i.aqpb838suc1
             and f.ppmda = i.aqpb838mda1
             and f.pppap = i.aqpb838pap1
             and f.ppcta = i.aqpb838cta1
             and f.ppoper = i.aqpb838oper1
             and f.ppsbop = i.aqpb838sbop1
             and f.pptope = i.aqpb838tope1
             and f.d602co = 'S'
             and f.ppfpag between ld_FchIni and ld_FchFin
             and (f.d602mo, f.d602tr) in
                 (select tp1nro2, tp1nro3
                    from fst198
                   where tp1cod = 1
                     and tp1cod1 = 10871
                     and tp1corr1 = 7
                     and tp1corr2 = 10
                     and tp1corr3 > 0);
        exception
          when others then
            null;
        end;
      
        begin
          -- Call the procedure
          PQ_CR_MONTO_CAPITALIZADO.SP_CR_OBTENER_MONTO_CAPITALIZADO(P_N_CTA      => i.aqpb838cta1,
                                                                    P_N_OPER     => i.aqpb838oper1,
                                                                    P_V_USU      => lc_usuario,
                                                                    P_D_ULT_FEC  => ld_ULT_FEC,
                                                                    P_N_TOT_MONT => ld_N_TOT_MONT,
                                                                    P_V_ERROR    => lV_ERROR);
        end;
      
        if ln_TienePagos > 0 then
          for c in calendario(i.aqpb838cod1, i.aqpb838mod1, i.aqpb838suc1, i.aqpb838mda1, i.aqpb838pap1, i.aqpb838cta1, i.aqpb838oper1, i.aqpb838sbop1, i.aqpb838tope1, ld_FchIni, ld_FchFin) loop
            --for t in transaccion(c.d602cd, c.d602mo, c.d602tr, c.d602su, c.d602re, c.d602fc) loop
            ln_Capital        := 0;
            ln_Interes        := 0;
            ln_Seguro         := 0;
            ld_FchPago        := null;
            ln_ModPago        := 0;
            ln_TxPago         := 0;
            ln_SucPago        := 0;
            ln_RelPago        := 0;
            ln_CapPagado      := 0;
            ln_IntPagado      := 0;
            ln_ICExtPagado    := 0;
            ln_MoraPagado     := 0;
            ln_SegPagado      := 0;
            ln_OtrsRubrPagado := 0;
            ln_GastoPagado    := 0;
            ln_IntDeudor      := 0;
          
            begin
              select f.ppcap, f.ppint
                into ln_Capital, ln_Interes
                from fsd601 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.ppmod
                 and f.ppsuc = c.ppsuc
                 and f.ppmda = c.ppmda
                 and f.pppap = c.pppap
                 and f.ppcta = c.ppcta
                 and f.ppoper = c.ppoper
                 and f.ppsbop = c.ppsbop
                 and f.pptope = c.pptope
                 and f.ppfpag = c.ppfpag
                 and f.d601co = 'S';
            exception
              when others then
                null;
            end;
          
            begin
              select sum(f.ppimp11 + f.ppimp12 + f.ppimp13 + f.ppimp14 +
                         f.ppimp15)
                into ln_Seguro
                from fsd611 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.ppmod
                 and f.ppsuc = c.ppsuc
                 and f.ppmda = c.ppmda
                 and f.pppap = c.pppap
                 and f.ppcta = c.ppcta
                 and f.ppoper = c.ppoper
                 and f.ppsbop = c.ppsbop
                 and f.pptope = c.pptope
                 and f.ppfpag = c.ppfpag;
            exception
              when others then
                null;
            end;
          
            begin
              select sum(f.pp1imp10 + f.pp1imp11 + f.pp1imp12 + f.pp1imp13 +
                         f.pp1imp14 + f.pp1imp15)
                into ln_SegPagado
                from fsd612 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.ppmod
                 and f.ppsuc = c.ppsuc
                 and f.ppmda = c.ppmda
                 and f.pppap = c.pppap
                 and f.ppcta = c.ppcta
                 and f.ppoper = c.ppoper
                 and f.ppsbop = c.ppsbop
                 and f.pptope = c.pptope
                 and f.ppfpag = c.ppfpag
                 and f.pp1nump = c.pp1nump;
            exception
              when others then
                null;
            end;
          
            pq_cr_detallepagos.sp_Cr_importes(ln_pgcod   => c.d602cd,
                                              ln_itmod   => c.d602mo,
                                              ln_ittran  => c.d602tr,
                                              ln_itsuc   => c.d602su,
                                              ln_itnrel  => c.d602re,
                                              ld_fcon    => c.d602fc,
                                              ld_fpag    => ld_FchPago,
                                              ln_hmod    => ln_ModPago,
                                              ln_htran   => ln_TxPago,
                                              ln_hsucor  => ln_SucPago,
                                              ln_rela    => ln_RelPago,
                                              ln_cap     => ln_CapPagado,
                                              ln_int     => ln_IntPagado,
                                              ln_ice     => ln_ICExtPagado,
                                              ln_mora    => ln_MoraPagado,
                                              ln_seguros => ln_SegPagadoAux,
                                              ln_rubobli => ln_OtrsRubrPagado,
                                              ln_gastos  => ln_GastoPagado);
          
            if c.pp1cap < 0 then
            
              ln_IntPagado := c.pp1int + c.pp1cap;
              ln_CapPagado := 0;
              -- ln_IntDeudor := ln_Capital;
            else
              ln_IntPagado := c.pp1int;
              ln_CapPagado := c.pp1cap;
            
            end if;
          
            pq_Cr_detallepagos.sp_cr_logAQPC866(ld_866fec    => ld_FchSist,
                                                lc_866cred   => lc_Credito,
                                                ln_NroCamb   => i.aqpb838corr,
                                                lc_866usr    => lc_usuario,
                                                ln_866pgcod  => i.aqpb838cod1,
                                                ln_866mod    => i.aqpb838mod1,
                                                ln_866suc    => i.aqpb838suc1,
                                                ln_866mda    => i.aqpb838mda1,
                                                ln_866pap    => i.aqpb838pap1,
                                                ln_866cta    => i.aqpb838cta1,
                                                ln_866oper   => i.aqpb838oper1,
                                                ln_866sbop   => i.aqpb838sbop1,
                                                ln_866tope   => i.aqpb838tope1,
                                                ld_FchIni    => ld_FchIni,
                                                ld_FchFin    => ld_FchFin,
                                                ld_866fpag   => c.ppfpag,
                                                ln_866cap    => ln_Capital,
                                                ln_866int    => ln_Interes,
                                                ln_866susepa => ln_Seguro,
                                                ld_866fpag2  => c.pp1fech,
                                                ln_866moncap => ln_MntCapitalizado,
                                                ln_866pagcap => ln_CapPagado,
                                                ln_866pagint => ln_IntPagado,
                                                ln_866painca => 0,
                                                ln_866pagmor => ln_MoraPagado,
                                                ln_866pagpen => 0,
                                                ln_866pagicv => ln_ICExtPagado,
                                                ln_866pagseg => ln_SegPagado,
                                                ln_866pagotr => ln_OtrsRubrPagado,
                                                ln_866tcd    => c.d602cd,
                                                ln_866tmo    => c.d602mo,
                                                ln_866tsu    => c.d602su,
                                                ln_866ttr    => c.d602tr,
                                                ln_866tre    => c.d602re,
                                                ld_866tfc    => c.d602fc,
                                                ln_IntDeu    => 0);
            --end loop;
          end loop;
        else
          pq_Cr_detallepagos.sp_cr_logAQPC866(ld_866fec    => ld_FchSist,
                                              lc_866cred   => lc_Credito,
                                              ln_NroCamb   => i.aqpb838corr,
                                              lc_866usr    => lc_usuario,
                                              ln_866pgcod  => i.aqpb838cod1,
                                              ln_866mod    => i.aqpb838mod1,
                                              ln_866suc    => i.aqpb838suc1,
                                              ln_866mda    => i.aqpb838mda1,
                                              ln_866pap    => i.aqpb838pap1,
                                              ln_866cta    => i.aqpb838cta1,
                                              ln_866oper   => i.aqpb838oper1,
                                              ln_866sbop   => i.aqpb838sbop1,
                                              ln_866tope   => i.aqpb838tope1,
                                              ld_FchIni    => ld_FchIni,
                                              ld_FchFin    => ld_FchFin,
                                              ld_866fpag   => null,
                                              ln_866cap    => 0,
                                              ln_866int    => 0,
                                              ln_866susepa => 0,
                                              ld_866fpag2  => null,
                                              ln_866moncap => 0,
                                              ln_866pagcap => 0,
                                              ln_866pagint => 0,
                                              ln_866painca => 0,
                                              ln_866pagmor => 0,
                                              ln_866pagpen => 0,
                                              ln_866pagicv => 0,
                                              ln_866pagseg => 0,
                                              ln_866pagotr => 0,
                                              ln_866tcd    => 0,
                                              ln_866tmo    => 0,
                                              ln_866tsu    => 0,
                                              ln_866ttr    => 0,
                                              ln_866tre    => 0,
                                              ld_866tfc    => null,
                                              ln_IntDeu    => 0);
        end if;
      else
      
        begin
          select count(*)
            into ln_TienePagos
            from fsd602 f
           where f.pgcod = i.aqpb838cod1
             and f.ppmod = i.aqpb838mod1
             and f.ppsuc = i.aqpb838suc1
             and f.ppmda = i.aqpb838mda1
             and f.pppap = i.aqpb838pap1
             and f.ppcta = i.aqpb838cta1
             and f.ppoper = i.aqpb838oper1
             and f.ppsbop = i.aqpb838sbop1
             and f.pptope = i.aqpb838tope1
             and f.d602co = 'S'
             and f.ppfpag >= ld_FchIni
             and (f.d602mo, f.d602tr) in
                 (select tp1nro2, tp1nro3
                    from fst198
                   where tp1cod = 1
                     and tp1cod1 = 10871
                     and tp1corr1 = 7
                     and tp1corr2 = 10
                     and tp1corr3 > 0);
        exception
          when others then
            null;
        end;
      
        if ln_TienePagos > 0 then
        
          begin
            -- Call the procedure
            PQ_CR_MONTO_CAPITALIZADO.SP_CR_OBTENER_MONTO_CAPITALIZADO(P_N_CTA      => i.aqpb838cta1,
                                                                      P_N_OPER     => i.aqpb838oper1,
                                                                      P_V_USU      => lc_usuario,
                                                                      P_D_ULT_FEC  => ld_ULT_FEC,
                                                                      P_N_TOT_MONT => ld_N_TOT_MONT,
                                                                      P_V_ERROR    => lV_ERROR);
          end;
        
          for c in CalenUnico(i.aqpb838cod1, i.aqpb838mod1, i.aqpb838suc1, i.aqpb838mda1, i.aqpb838pap1, i.aqpb838cta1, i.aqpb838oper1, i.aqpb838sbop1, i.aqpb838tope1, ld_FchIni) loop
            --for t in transaccion(c.d602cd, c.d602mo, c.d602tr, c.d602su, c.d602re, c.d602fc) loop
            ln_Capital        := 0;
            ln_Interes        := 0;
            ln_Seguro         := 0;
            ld_FchPago        := null;
            ln_ModPago        := 0;
            ln_TxPago         := 0;
            ln_SucPago        := 0;
            ln_RelPago        := 0;
            ln_CapPagado      := 0;
            ln_IntPagado      := 0;
            ln_ICExtPagado    := 0;
            ln_MoraPagado     := 0;
            ln_SegPagado      := 0;
            ln_OtrsRubrPagado := 0;
            ln_GastoPagado    := 0;
            ln_IntDeudor      := 0;
          
            begin
              select f.ppcap, f.ppint
                into ln_Capital, ln_Interes
                from fsd601 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.ppmod
                 and f.ppsuc = c.ppsuc
                 and f.ppmda = c.ppmda
                 and f.pppap = c.pppap
                 and f.ppcta = c.ppcta
                 and f.ppoper = c.ppoper
                 and f.ppsbop = c.ppsbop
                 and f.pptope = c.pptope
                 and f.ppfpag = c.ppfpag
                 and f.d601co = 'S';
            exception
              when others then
                null;
            end;
          
            begin
              select sum(f.ppimp10 + f.ppimp11 + f.ppimp12 + f.ppimp13 +
                         f.ppimp14 + f.ppimp15)
                into ln_Seguro
                from fsd611 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.ppmod
                 and f.ppsuc = c.ppsuc
                 and f.ppmda = c.ppmda
                 and f.pppap = c.pppap
                 and f.ppcta = c.ppcta
                 and f.ppoper = c.ppoper
                 and f.ppsbop = c.ppsbop
                 and f.pptope = c.pptope
                 and f.ppfpag = c.ppfpag;
            exception
              when others then
                null;
            end;
          
            begin
              select sum(f.pp1imp10 + f.pp1imp11 + f.pp1imp12 + f.pp1imp13 +
                         f.pp1imp14 + f.pp1imp15)
                into ln_SegPagado
                from fsd612 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.ppmod
                 and f.ppsuc = c.ppsuc
                 and f.ppmda = c.ppmda
                 and f.pppap = c.pppap
                 and f.ppcta = c.ppcta
                 and f.ppoper = c.ppoper
                 and f.ppsbop = c.ppsbop
                 and f.pptope = c.pptope
                 and f.ppfpag = c.ppfpag
                 and f.pp1nump = c.pp1nump;
            exception
              when others then
                null;
            end;
          
            pq_cr_detallepagos.sp_Cr_importes(ln_pgcod   => c.d602cd,
                                              ln_itmod   => c.d602mo,
                                              ln_ittran  => c.d602tr,
                                              ln_itsuc   => c.d602su,
                                              ln_itnrel  => c.d602re,
                                              ld_fcon    => c.d602fc,
                                              ld_fpag    => ld_FchPago,
                                              ln_hmod    => ln_ModPago,
                                              ln_htran   => ln_TxPago,
                                              ln_hsucor  => ln_SucPago,
                                              ln_rela    => ln_RelPago,
                                              ln_cap     => ln_CapPagado,
                                              ln_int     => ln_IntPagado,
                                              ln_ice     => ln_ICExtPagado,
                                              ln_mora    => ln_MoraPagado,
                                              ln_seguros => ln_SegPagadoAux,
                                              ln_rubobli => ln_OtrsRubrPagado,
                                              ln_gastos  => ln_GastoPagado);
          
            if c.pp1cap < 0 then
            
              ln_IntPagado := c.pp1int + c.pp1cap;
              ln_CapPagado := 0;
              -- ln_IntDeudor := ln_Capital;
            else
              ln_IntPagado := c.pp1int;
              ln_CapPagado := c.pp1cap;
            
            end if;
          
            pq_Cr_detallepagos.sp_cr_logAQPC866(ld_866fec    => ld_FchSist,
                                                lc_866cred   => lc_Credito,
                                                ln_NroCamb   => i.aqpb838corr,
                                                lc_866usr    => lc_usuario,
                                                ln_866pgcod  => i.aqpb838cod1,
                                                ln_866mod    => i.aqpb838mod1,
                                                ln_866suc    => i.aqpb838suc1,
                                                ln_866mda    => i.aqpb838mda1,
                                                ln_866pap    => i.aqpb838pap1,
                                                ln_866cta    => i.aqpb838cta1,
                                                ln_866oper   => i.aqpb838oper1,
                                                ln_866sbop   => i.aqpb838sbop1,
                                                ln_866tope   => i.aqpb838tope1,
                                                ld_FchIni    => ld_FchIni,
                                                ld_FchFin    => null,
                                                ld_866fpag   => c.ppfpag,
                                                ln_866cap    => ln_Capital,
                                                ln_866int    => ln_Interes,
                                                ln_866susepa => ln_Seguro,
                                                ld_866fpag2  => c.pp1fech,
                                                ln_866moncap => ln_MntCapitalizado,
                                                ln_866pagcap => ln_CapPagado,
                                                ln_866pagint => ln_IntPagado,
                                                ln_866painca => 0,
                                                ln_866pagmor => ln_MoraPagado,
                                                ln_866pagpen => 0,
                                                ln_866pagicv => ln_ICExtPagado,
                                                ln_866pagseg => ln_SegPagado,
                                                ln_866pagotr => ln_OtrsRubrPagado,
                                                ln_866tcd    => c.d602cd,
                                                ln_866tmo    => c.d602mo,
                                                ln_866tsu    => c.d602su,
                                                ln_866ttr    => c.d602tr,
                                                ln_866tre    => c.d602re,
                                                ld_866tfc    => c.d602fc,
                                                ln_IntDeu    => 0);
            --end loop;
          end loop;
        else
          pq_Cr_detallepagos.sp_cr_logAQPC866(ld_866fec    => ld_FchSist,
                                              lc_866cred   => lc_Credito,
                                              ln_NroCamb   => i.aqpb838corr,
                                              lc_866usr    => lc_usuario,
                                              ln_866pgcod  => i.aqpb838cod1,
                                              ln_866mod    => i.aqpb838mod1,
                                              ln_866suc    => i.aqpb838suc1,
                                              ln_866mda    => i.aqpb838mda1,
                                              ln_866pap    => i.aqpb838pap1,
                                              ln_866cta    => i.aqpb838cta1,
                                              ln_866oper   => i.aqpb838oper1,
                                              ln_866sbop   => i.aqpb838sbop1,
                                              ln_866tope   => i.aqpb838tope1,
                                              ld_FchIni    => ld_FchIni,
                                              ld_FchFin    => ld_FchFin,
                                              ld_866fpag   => null,
                                              ln_866cap    => 0,
                                              ln_866int    => 0,
                                              ln_866susepa => 0,
                                              ld_866fpag2  => null,
                                              ln_866moncap => 0,
                                              ln_866pagcap => 0,
                                              ln_866pagint => 0,
                                              ln_866painca => 0,
                                              ln_866pagmor => 0,
                                              ln_866pagpen => 0,
                                              ln_866pagicv => 0,
                                              ln_866pagseg => 0,
                                              ln_866pagotr => 0,
                                              ln_866tcd    => 0,
                                              ln_866tmo    => 0,
                                              ln_866tsu    => 0,
                                              ln_866ttr    => 0,
                                              ln_866tre    => 0,
                                              ld_866tfc    => null,
                                              ln_IntDeu    => 0);
        end if;
      end if;
    
      begin
        select sum(a.aqpc866pagcap),
               sum(a.aqpc866pagint),
               sum(a.aqpc866pagmor),
               sum(a.aqpc866pagpen),
               sum(a.aqpc866pagicv),
               sum(a.aqpc866pagseg)
        --   sum(a.aqpc866intdeu)
          into ln_CapPag,
               ln_IntPag,
               ln_MoraPag,
               ln_PenaPag,
               ln_ICVPag,
               ln_SegPag
        --   ln_IntDeuCons
          from aqpc866 a
         where a.aqpc866cred = lc_Credito
           and a.aqpc866usr = lc_usuario
           and a.aqpc866pgcod = i.aqpb838cod1
           and a.aqpc866mod = i.aqpb838mod1
           and a.aqpc866suc = i.aqpb838suc1
           and a.aqpc866mda = i.aqpb838mda1
           and a.aqpc866pap = i.aqpb838pap1
           and a.aqpc866cta = i.aqpb838cta1
           and a.aqpc866oper = i.aqpb838oper1
           and a.aqpc866sbop = i.aqpb838sbop1
           and a.aqpc866tope = i.aqpb838tope1
           and a.aqpc866fini = i.aqpb838fc
           and a.aqpc866ncamb = i.aqpb838corr
           and a.aqpc866est = 'H';
      exception
        when others then
          ln_CapPag  := 0;
          ln_IntPag  := 0;
          ln_MoraPag := 0;
          ln_PenaPag := 0;
          ln_ICVPag  := 0;
          ln_SegPag  := 0;
      end;
    
      begin
        select a.aqpc955mont --, a.aqpc955aux1
          into ln_MntCapitalizado --, ln_IntDeuCons
          from AQPC955 A
         WHERE A.AQPC955CTA = i.aqpb838cta1
           and a.aqpc955oper = i.aqpb838oper1
           and a.aqpc955usrg = lc_usuario
           and a.aqpc955ehab = 'H'
           and a.aqpc955emp = i.aqpb838cod1
           and a.aqpc955mod = i.aqpb838mod1
              -- and a.aqpc955suc = i.aqpb838suc1
           and a.aqpc955mda = i.aqpb838mda1
           and a.aqpc955pap = i.aqpb838pap1
           and a.aqpc955cta = i.aqpb838cta1
           and a.aqpc955oper = i.aqpb838oper1
              --  and a.aqpc955sbop = i.aqpb838sbop1 - 1
           and a.aqpc955tope = i.aqpb838tope1
           and a.aqpc955cont = 'CONTABLE' --APACHECOH 2024.05.23
           and a.aqpc955fep = i.aqpb838fc;
      exception
        when others then
          ln_MntCapitalizado := 0;
      end;
    
      begin
        select a.aqpc955aux1
          into ln_IntDeuCons
          from AQPC955 A
         WHERE A.AQPC955CTA = i.aqpb838cta1
           and a.aqpc955oper = i.aqpb838oper1
           and a.aqpc955usrg = lc_usuario
           and a.aqpc955ehab = 'H'
           and a.aqpc955emp = i.aqpb838cod1
           and a.aqpc955mod = i.aqpb838mod1
              -- and a.aqpc955suc = i.aqpb838suc1
           and a.aqpc955mda = i.aqpb838mda1
           and a.aqpc955pap = i.aqpb838pap1
           and a.aqpc955cta = i.aqpb838cta1
           and a.aqpc955oper = i.aqpb838oper1
              --  and a.aqpc955sbop = i.aqpb838sbop1 - 1
           and a.aqpc955tope = i.aqpb838tope1
           and a.aqpc955fep = i.aqpb838fc;
      exception
        when others then
          ln_IntDeuCons := 0;
      end;
    
      if ln_MntCapitalizado < 0 then
        ln_MntCapitalizado := 0;
      end if;
    
      ln_CapPag          := nvl(ln_CapPag, 0);
      ln_IntPag          := nvl(ln_IntPag, 0);
      ln_MoraPag         := nvl(ln_MoraPag, 0);
      ln_SegPag          := nvl(ln_SegPag, 0);
      ln_ICVPag          := nvl(ln_ICVPag, 0);
      ln_PenaPag         := nvl(ln_PenaPag, 0);
      ln_MntCapitalizado := nvl(ln_MntCapitalizado, 0);
      ln_IntDeuCons      := nvl(ln_IntDeuCons, 0);
    
      --obtiene monto desembolsado
      if i.aqpb838rel = 24 then
        begin
          ln_mtodes := PQ_CR_DETALLEPAGOS.fn_cr_mtodesembolso(v_Pgcod  => i.aqpb838cod1,
                                                              v_Scmod  => i.aqpb838mod1,
                                                              v_Scsuc  => i.aqpb838suc1,
                                                              v_Scmda  => i.aqpb838mda1,
                                                              v_Scpap  => i.aqpb838pap1,
                                                              v_Sccta  => i.aqpb838cta1,
                                                              v_Scoper => i.aqpb838oper1,
                                                              v_Scsbop => i.aqpb838sbop1,
                                                              v_Sctope => i.aqpb838tope1);
        end;
      else
        ln_mtodes := null;
      end if;
    
      begin
        update aqpb838 a
           set a.aqpb838cap    = ln_CapPag,
               a.aqpb838int    = ln_IntPag,
               a.aqpb838mor    = ln_MoraPag,
               a.aqpb838seg    = ln_SegPag,
               a.aqpb838icv    = ln_ICVPag,
               a.aqpb838pen    = ln_PenaPag,
               a.aqpb838ncap   = ln_MntCapitalizado,
               a.aqpb838intdeu = ln_IntDeuCons,
               a.aqpb838mtod   = ln_mtodes
         where a.aqpb838cod1 = i.aqpb838cod1
           and a.aqpb838mod1 = i.aqpb838mod1
           and a.aqpb838suc1 = i.aqpb838suc1
           and a.aqpb838mda1 = i.aqpb838mda1
           and a.aqpb838pap1 = i.aqpb838pap1
           and a.aqpb838cta1 = i.aqpb838cta1
           and a.aqpb838oper1 = i.aqpb838oper1
           and a.aqpb838sbop1 = i.aqpb838sbop1
           and a.aqpb838tope1 = i.aqpb838tope1
           and a.aqpb838corr = i.aqpb838corr
           and a.aqpb838usu = lc_usuario
           and a.aqpb838cred = lc_Credito;
        commit;
      
      end;
    
    end loop;
  
    for c in actualizar loop
    
      begin
        select min(a.aqpb838corr)
          into ln_MinCorr
          from aqpb838 a
         where a.aqpb838usu = lc_usuario
           and a.aqpb838cred = lc_Credito
           and a.aqpb838rel = 2
           and a.aqpb838cod1 = c.aqpb838cod1
           and a.aqpb838mod1 = c.aqpb838mod1
           and a.aqpb838suc1 = c.aqpb838suc1
           and a.aqpb838mda1 = c.aqpb838mda1
           and a.aqpb838pap1 = c.aqpb838pap1
           and a.aqpb838cta1 = c.aqpb838cta1
           and a.aqpb838oper1 = c.aqpb838oper1
           and a.aqpb838sbop1 = c.aqpb838sbop1
           and a.aqpb838tope1 = c.aqpb838tope1
           and a.aqpb838fc = c.aqpb838fc;
      exception
        when others then
          null;
      end;
    
      begin
        update aqpb838 a
           set a.aqpb838cap = 0,
               a.aqpb838int = 0,
               a.aqpb838mor = 0,
               a.aqpb838seg = 0,
               a.aqpb838icv = 0,
               a.aqpb838pen = 0,
               --a.aqpb838ncap   = 0,
               a.aqpb838intdeu = 0
         where a.aqpb838usu = lc_usuario
           and a.aqpb838cred = lc_Credito
           and a.aqpb838rel = 2
           and a.aqpb838cod1 = c.aqpb838cod1
           and a.aqpb838mod1 = c.aqpb838mod1
           and a.aqpb838suc1 = c.aqpb838suc1
           and a.aqpb838mda1 = c.aqpb838mda1
           and a.aqpb838pap1 = c.aqpb838pap1
           and a.aqpb838cta1 = c.aqpb838cta1
           and a.aqpb838oper1 = c.aqpb838oper1
           and a.aqpb838sbop1 = c.aqpb838sbop1
           and a.aqpb838tope1 = c.aqpb838tope1
           and a.aqpb838fc = c.aqpb838fc
           and a.aqpb838corr <> ln_MinCorr;
        commit;
      
      end;
    
    end loop;
  
  end sp_cr_inicio;
  ----------------------------------------------------------------------------
  procedure sp_Cr_importes(ln_pgcod   in number,
                           ln_itmod   in number,
                           ln_ittran  in number,
                           ln_itsuc   in number,
                           ln_itnrel  in number,
                           ld_fcon    in date,
                           ld_fpag    out date,
                           ln_hmod    out number,
                           ln_htran   out number,
                           ln_hsucor  out number,
                           ln_rela    out number,
                           ln_cap     out number,
                           ln_int     out number,
                           ln_ice     out number,
                           ln_mora    out number,
                           ln_seguros out number,
                           ln_rubobli out number,
                           ln_gastos  out number) is
  
    ld_FchSist date;
  
  begin
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    if ld_FchSist > ld_fcon then
      begin
        select f_pag,
               hcmod,
               htran,
               hsucor,
               hnrel,
               sum(decode(tp1nro1, 1, (monto / cont), 0)) capital,
               sum(decode(tp1nro1, 2, (monto / cont), 0)) interes,
               sum(decode(tp1nro3,
                          1,
                          decode(tp1nro1, 3, (monto / cont), 0),
                          4,
                          decode(tp1nro1, 3, (monto4 / cont), 0),
                          12)) int_comp_extra,
               sum(decode(tp1nro3,
                          1,
                          decode(tp1nro1, 4, (monto / cont), 0),
                          4,
                          decode(tp1nro1, 4, (monto4 / cont), 0),
                          12)) mora,
               sum(decode(tp1nro1, 5, (monto / cont), 0)) seguros,
               sum(decode(tp1nro1, 6, (monto / cont), 0)) rub_obli,
               sum(decode(tp1nro1, 7, (monto / cont), 0)) gastos
        
          into ld_fpag,
               ln_hmod,
               ln_htran,
               ln_hsucor,
               ln_rela,
               ln_cap,
               ln_int,
               ln_ice,
               ln_mora,
               ln_seguros,
               ln_rubobli,
               ln_gastos
          from (select g.tp1nro1,
                       h.hcmod,
                       g.tp1nro3,
                       h.htran,
                       h.hsucor,
                       h.hnrel,
                       f.hfcon as f_pag,
                       sum(h.hcimp1) monto,
                       sum(h.hcimp4) monto4,
                       count(*) cont
                  from fsh016 h
                 inner join fst198 g
                    on h.hcmod = g.tp1corr1
                   and h.htran = g.tp1corr2
                   and h.hcord = g.tp1imp1
                   and g.tp1cod = 1
                   and g.tp1cod1 = 10876
                   and g.tp1corr1 <> 999999
                 inner join fsh015 f
                    on f.pgcod = h.pgcod
                   and f.hsucor = h.hsucor
                   and f.hcmod = h.hcmod
                   and f.htran = h.htran
                   and f.hnrel = h.hnrel
                   and f.hfcon = h.hfcon
                 where f.pgcod = ln_pgcod
                   and f.hcmod = ln_itmod
                   and f.htran = ln_ittran
                   and f.hsucor = ln_itsuc
                   and f.hnrel = ln_itnrel
                   and f.hfcon = ld_fcon
                      --and f.itcont = 'S'
                   and f.hccorr = 0
                 group by g.tp1nro1,
                          h.hcmod,
                          h.htran,
                          h.hsucor,
                          h.hnrel,
                          f.hfcon,
                          f.hfvc,
                          g.tp1nro3)
         group by f_pag, hcmod, htran, hsucor, hnrel;
      exception
        when others then
          null;
      end;
    
      if ld_FchSist = ld_fcon then
        begin
          select f_pag,
                 itmod,
                 ittran,
                 itsuc,
                 itnrel,
                 sum(decode(tp1nro1, 1, (monto / cont), 0)) capital,
                 sum(decode(tp1nro1, 2, (monto / cont), 0)) interes,
                 sum(decode(tp1nro3,
                            1,
                            decode(tp1nro1, 3, (monto / cont), 0),
                            4,
                            decode(tp1nro1, 3, (monto4 / cont), 0),
                            12,
                            decode(tp1nro1, 3, (monto12 / cont), 0))) int_comp_extra, -- 062017 -- sum(decode(tp1nro1,3,(monto/cont),0 )) int_comp_extra,--ICV        
                 sum(decode(tp1nro3,
                            1,
                            decode(tp1nro1, 4, (monto / cont), 0),
                            4,
                            decode(tp1nro1, 4, (monto4 / cont), 0),
                            12,
                            decode(tp1nro1, 4, (monto12 / cont), 0))) mora, --062017 -- sum(decode(tp1nro1,4,(monto/cont),0 )) mora,
                 sum(decode(tp1nro1, 5, (monto / cont), 0)) seguros,
                 sum(decode(tp1nro1, 6, (monto / cont), 0)) rub_obli,
                 sum(decode(tp1nro1, 7, (monto / cont), 0)) gastos
            into ld_fpag,
                 ln_hmod,
                 ln_htran,
                 ln_hsucor,
                 ln_rela,
                 ln_cap,
                 ln_int,
                 ln_ice,
                 ln_mora,
                 ln_seguros,
                 ln_rubobli,
                 ln_gastos
            from (select g.tp1nro1,
                         h.itmod,
                         g.tp1nro3,
                         h.ittran,
                         h.itsuc,
                         h.itnrel,
                         itfcon as f_pag, -- 062017 (select g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
                         sum(h.itimp1) monto,
                         sum(h.itimp4) monto4,
                         sum(h.itimp12) monto12,
                         count(*) cont --062017 se adiciono suma de impuestos --sum(h.itimp1) monto,count(*) cont
                    from fsd016 h
                   inner join fst198 g
                      on h.itmod = g.tp1corr1
                     and h.ittran = g.tp1corr2
                     and h.itord = g.tp1imp1 --  062017--and h.itord=g.tp1corr3
                     and g.tp1cod = 1
                     and g.tp1cod1 = 10876
                     and g.tp1corr1 <> 999999
                   inner join fsd015 f
                      on f.pgcod = h.pgcod
                     and f.itsuc = h.itsuc
                     and f.itmod = h.itmod
                     and f.ittran = h.ittran
                     and f.itnrel = h.itnrel
                   where f.pgcod = ln_pgcod
                     and f.itmod = ln_itmod
                     and f.ittran = ln_ittran
                     and f.itsuc = ln_itsuc
                     and f.itnrel = ln_itnrel
                     and f.itcont = 'S'
                     and f.itcorr = 0
                     and h.itanu = 'N' --19/12/2022 kvalenciac
                   group by g.tp1nro1,
                            h.itmod,
                            h.ittran,
                            h.itsuc,
                            h.itnrel,
                            f.itfcon,
                            f.itfvc,
                            g.tp1nro3) --062017 --group by g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc)
           group by f_pag, itmod, ittran, itsuc, itnrel;
        exception
          when others then
            null;
          
        end;
      end if;
    end if;
  
  end sp_Cr_importes;
  ------------------------------------------------------------------------------------------
  procedure sp_cr_totaleshist(lc_usuario   in char,
                              lc_Credito   in varchar2,
                              ln_CapTotPag out number,
                              ln_IntTotPag out number,
                              ln_MorTotPag out number,
                              ln_SegTotPag out number,
                              ln_ICVTotPag out number,
                              ln_PenTotPag out number,
                              ln_CapNegTot out number,
                              ln_IntDeudor out number,
                              ln_mntDesemb out number) is
  
  begin
    begin
      select sum(a.aqpb838cap),
             sum(a.aqpb838int),
             sum(a.aqpb838mor),
             sum(a.aqpb838seg),
             sum(a.aqpb838icv),
             sum(a.aqpb838pen),
             sum(a.aqpb838ncap),
             sum(a.aqpb838intdeu),
             sum(a.aqpb838mtod)
        into ln_CapTotPag,
             ln_IntTotPag,
             ln_MorTotPag,
             ln_SegTotPag,
             ln_ICVTotPag,
             ln_PenTotPag,
             ln_CapNegTot,
             ln_IntDeudor,
             ln_mntDesemb
        from aqpb838 a
       where a.aqpb838usu = lc_usuario
         and a.aqpb838cred = lc_Credito;
    
    exception
      when others then
        null;
    end;
  
    ln_CapTotPag := nvl(ln_CapTotPag, 0);
    ln_IntTotPag := nvl(ln_IntTotPag, 0);
    ln_MorTotPag := nvl(ln_MorTotPag, 0);
    ln_SegTotPag := nvl(ln_SegTotPag, 0);
    ln_ICVTotPag := nvl(ln_ICVTotPag, 0);
    ln_PenTotPag := nvl(ln_PenTotPag, 0);
    ln_CapNegTot := nvl(ln_CapNegTot, 0);
  
  end;
  ------------------------------------------------------------------------------------------
  procedure sp_cr_logAQPC866(ld_866fec    in date,
                             lc_866cred   in varchar2,
                             ln_NroCamb   in number,
                             lc_866usr    in varchar2,
                             ln_866pgcod  in number,
                             ln_866mod    in number,
                             ln_866suc    in number,
                             ln_866mda    in number,
                             ln_866pap    in number,
                             ln_866cta    in number,
                             ln_866oper   in number,
                             ln_866sbop   in number,
                             ln_866tope   in number,
                             ld_FchIni    in date,
                             ld_FchFin    in date,
                             ld_866fpag   in date,
                             ln_866cap    in number,
                             ln_866int    in number,
                             ln_866susepa in number,
                             ld_866fpag2  in date,
                             ln_866moncap in number,
                             ln_866pagcap in number,
                             ln_866pagint in number,
                             ln_866painca in number,
                             ln_866pagmor in number,
                             ln_866pagpen in number,
                             ln_866pagicv in number,
                             ln_866pagseg in number,
                             ln_866pagotr in number,
                             ln_866tcd    in number,
                             ln_866tmo    in number,
                             ln_866tsu    in number,
                             ln_866ttr    in number,
                             ln_866tre    in number,
                             ld_866tfc    in date,
                             ln_IntDeu    in number) is
  
    ln_corr      number;
    lc_hora      varchar2(8);
    ln_IntDeuAux number(17, 2) := 0.00;
  
  begin
  
    ln_IntDeuAux := ln_IntDeu;
  
    begin
      select max(a.aqpc866corr)
        into ln_corr
        from aqpc866 a
       where a.aqpc866usr = lc_866usr
         and a.aqpc866cred = lc_866cred;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    if ln_IntDeuAux < 0 then
    
      ln_IntDeuAux := ln_IntDeuAux * -1;
    
    end if;
  
    begin
      insert into aqpc866
        (aqpc866corr,
         aqpc866fec,
         aqpc866hor,
         aqpc866cred,
         aqpc866ncamb,
         aqpc866usr,
         aqpc866pgcod,
         aqpc866mod,
         aqpc866suc,
         aqpc866mda,
         aqpc866pap,
         aqpc866cta,
         aqpc866oper,
         aqpc866sbop,
         aqpc866tope,
         AQPC866FINI,
         AQPC866FFIN,
         aqpc866fpag,
         aqpc866cap,
         aqpc866int,
         aqpc866susepa,
         aqpc866fpag2,
         aqpc866moncap,
         aqpc866pagcap,
         aqpc866pagint,
         aqpc866painca,
         aqpc866pagmor,
         aqpc866pagpen,
         aqpc866pagicv,
         aqpc866pagseg,
         aqpc866pagotr,
         aqpc866tcd,
         aqpc866tmo,
         aqpc866tsu,
         aqpc866ttr,
         aqpc866tre,
         aqpc866tfc,
         aqpc866est,
         aqpc866intdeu)
      values
        (ln_corr + 1,
         ld_866fec,
         lc_hora,
         lc_866cred,
         ln_NroCamb,
         lc_866usr,
         ln_866pgcod,
         ln_866mod,
         ln_866suc,
         ln_866mda,
         ln_866pap,
         ln_866cta,
         ln_866oper,
         ln_866sbop,
         ln_866tope,
         ld_FchIni,
         ld_FchFin,
         ld_866fpag,
         ln_866cap,
         ln_866int,
         ln_866susepa,
         ld_866fpag2,
         ln_866moncap,
         ln_866pagcap,
         ln_866pagint,
         ln_866painca,
         ln_866pagmor,
         ln_866pagpen,
         ln_866pagicv,
         ln_866pagseg,
         ln_866pagotr,
         ln_866tcd,
         ln_866tmo,
         ln_866tsu,
         ln_866ttr,
         ln_866tre,
         ld_866tfc,
         'H',
         ln_IntDeuAux);
      commit;
    end;
  
  end sp_cr_logAQPC866;

  --------------------------
  function fn_cr_mtodesembolso(v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number) return number is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_mtodesembolso
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2024.05.30
    -- Autor de Creaci¿n          : DCASTRO/YYAMPI
    -- Uso                        : Retorna Mto Desembolso
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
  
    ln_mtodes number(17, 2);
  
  BEGIN
  
    --existe en tabla
    begin
      select j.aoimp
        into ln_mtodes
        from fsd010 j
       where j.pgcod = v_Pgcod
         and j.aomod = v_Scmod
         and j.aosuc = v_Scsuc
         and j.aomda = v_Scmda
         and j.aopap = v_Scpap
         and j.aocta = v_Sccta
         and j.aooper = v_Scoper
         and j.aosbop = v_Scsbop
         and j.aotope = v_Sctope;
    
    exception
      when others then
        ln_mtodes := 0;
    end;
  
    return ln_mtodes;
  
  end fn_cr_mtodesembolso;

end PQ_CR_DETALLEPAGOS;
/

