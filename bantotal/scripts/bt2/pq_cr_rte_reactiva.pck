create or replace package PQ_CR_RTE_REACTIVA is

  -- Author  : MPOSTIGOC
  -- Created : 22/06/2020 11:35:08 a. m.
  -- Purpose : Control para cancelacion o amortizacion el mismo dia de un desembolso reactiva
  ---------------------------------------------------------------------
  procedure sp_cr_inicio(ln_Pgcod   in number,
                         ln_Itsuc   in number,
                         ln_Itmod   in number,
                         ln_Ittran  in number,
                         ln_Itnrel  in number,
                         ln_Itord   in number,
                         ln_Itsbor  in number,
                         lc_Pcancel out varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_cancelaciones(ln_pgcod16 in number,
                                ln_mod16   in number,
                                ln_suc16   in number,
                                ln_mda16   in number,
                                ln_pap16   in number,
                                ln_cta16   in number,
                                ln_ope16   in number,
                                ln_sub16   in number,
                                ln_tope16  in number,
                                ld_FchSist in date,
                                lc_pcancel out varchar2);
  ------------------------------------------------------------------------
  procedure sp_cr_amortizacion(ln_pgcod16 in number,
                               ln_mod16   in number,
                               ln_suc16   in number,
                               ln_mda16   in number,
                               ln_pap16   in number,
                               ln_cta16   in number,
                               ln_ope16   in number,
                               ln_sub16   in number,
                               ln_tope16  in number,
                               ld_FchSist in date,
                               ln_Pgcod   in number,
                               ln_Itsuc   in number,
                               ln_Itmod   in number,
                               ln_Ittran  in number,
                               ln_Itnrel  in number,
                               ln_Itord   in number,
                               ln_Itsbor  in number,
                               lc_pcancel out varchar2);
  -------------------------------------------------------------------------
  procedure sp_cr_VerfFndCrcVig(ln_Instancia    in number,
                                lc_TieneFCVigen out varchar2);
  ------------------------------------------------------------------------
end PQ_CR_RTE_REACTIVA;
/

create or replace package body PQ_CR_RTE_REACTIVA is

  procedure sp_cr_inicio(ln_Pgcod   in number,
                         ln_Itsuc   in number,
                         ln_Itmod   in number,
                         ln_Ittran  in number,
                         ln_Itnrel  in number,
                         ln_Itord   in number,
                         ln_Itsbor  in number,
                         lc_Pcancel out varchar2) is
  
    ln_pgcod16     number := 0;
    ln_mod16       number := 0;
    ln_suc16       number := 0;
    ln_mda16       number := 0;
    ln_pap16       number := 0;
    ln_cta16       number := 0;
    ln_ope16       number := 0;
    ln_sub16       number := 0;
    ln_tope16      number := 0;
    ln_pais        number := 0;
    ln_tdoc        number := 0;
    lc_ndoc        character(12);
    ld_fchsist     date;
    ln_NroCreditos number := 0;
  
  begin
  
    lc_pcancel := 'N';
  
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
        into ln_pgcod16,
             ln_mod16,
             ln_suc16,
             ln_mda16,
             ln_pap16,
             ln_cta16,
             ln_ope16,
             ln_sub16,
             ln_tope16
        from fsd016 f
       where f.pgcod = ln_Pgcod
         and f.itsuc = ln_Itsuc
         and f.itmod = ln_Itmod
         and f.ittran = ln_Ittran
         and f.itnrel = ln_Itnrel
         and f.itord = ln_Itord
         and f.itsbor = ln_Itsbor;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tdoc, lc_ndoc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_cta16
         and f.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_fchsist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_NroCreditos
        from fsd010 f
       where f.pgcod = 1
         and f.aomod = 101
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aocta in (select g.ctnro
                           from fsr008 g
                          where g.pgcod = 1
                            and g.pepais = ln_pais
                            and g.petdoc = ln_tdoc
                            and g.pendoc = lc_ndoc)
         and f.aotope = 353
         and f.aofval = ld_fchsist
         and f.aostat = 0;
    end;
  
    if ln_NroCreditos > 0 then
      if ln_Itmod = 30 and ln_Ittran = 150 then
        pq_cr_rte_reactiva.sp_cr_cancelaciones(ln_pgcod16,
                                               ln_mod16,
                                               ln_suc16,
                                               ln_mda16,
                                               ln_pap16,
                                               ln_cta16,
                                               ln_ope16,
                                               ln_sub16,
                                               ln_tope16,
                                               ld_FchSist,
                                               lc_pcancel);
      else
        if ln_Itmod = 30 and ln_Ittran = 100 then
          pq_cr_rte_reactiva.sp_cr_amortizacion(ln_pgcod16,
                                                ln_mod16,
                                                ln_suc16,
                                                ln_mda16,
                                                ln_pap16,
                                                ln_cta16,
                                                ln_ope16,
                                                ln_sub16,
                                                ln_tope16,
                                                ld_FchSist,
                                                ln_Pgcod,
                                                ln_Itsuc,
                                                ln_Itmod,
                                                ln_Ittran,
                                                ln_Itnrel,
                                                ln_Itord,
                                                ln_Itsbor,
                                                lc_pcancel);
        
        else
          if ln_Itmod = 30 and ln_Ittran = 97 then
            lc_pcancel := 'S'; -- mpostigoc 09.11.2020
          
          end if;
        end if;
      end if;
    else
      lc_Pcancel := 'N';
    end if;
  
  end sp_cr_inicio;
  ------------------------------------------------------------------------------------------
  procedure sp_cr_cancelaciones(ln_pgcod16 in number,
                                ln_mod16   in number,
                                ln_suc16   in number,
                                ln_mda16   in number,
                                ln_pap16   in number,
                                ln_cta16   in number,
                                ln_ope16   in number,
                                ln_sub16   in number,
                                ln_tope16  in number,
                                ld_FchSist in date,
                                lc_pcancel out varchar2) is
  
    ln_MaxFchPago date;
  
  begin
  
    lc_pcancel := 'N';
  
    begin
      select max(f.ppfpag)
        into ln_MaxFchPago
        from fsd601 f
       where f.pgcod = ln_pgcod16
         and f.ppmod = ln_mod16
         and f.ppsuc = ln_suc16
         and f.ppmda = ln_mda16
         and f.pppap = ln_pap16
         and f.ppcta = ln_cta16
         and f.ppoper = ln_ope16
         and f.ppsbop = ln_sub16
         and f.pptope = ln_tope16
         and f.d601co = 'S';
    end;
  
    if ld_FchSist < ln_MaxFchPago then
      lc_pcancel := 'S'; -- bloqueara la transaccion ya que es una cancelacion adelantada
    else
      if ld_FchSist >= ln_MaxFchPago then
        lc_pcancel := 'N'; -- No bloquea la trnasaccion
      end if;
    end if;
  end sp_cr_cancelaciones;
  ----------------------------------------------------------------------------
  procedure sp_cr_amortizacion(ln_pgcod16 in number,
                               ln_mod16   in number,
                               ln_suc16   in number,
                               ln_mda16   in number,
                               ln_pap16   in number,
                               ln_cta16   in number,
                               ln_ope16   in number,
                               ln_sub16   in number,
                               ln_tope16  in number,
                               ld_FchSist in date,
                               ln_Pgcod   in number,
                               ln_Itsuc   in number,
                               ln_Itmod   in number,
                               ln_Ittran  in number,
                               ln_Itnrel  in number,
                               ln_Itord   in number,
                               ln_Itsbor  in number,
                               lc_pcancel out varchar2) is
  
    ln_TieneEvent number := 0;
  begin
    lc_pcancel := 'N';
  
    begin
      select count(*)
        into ln_TieneEvent
        from fsd012 f
       where f.pgcod = ln_pgcod16
         and f.aomod = ln_mod16
         and f.aosuc = ln_suc16
         and f.aomda = ln_mda16
         and f.aopap = ln_pap16
         and f.aocta = ln_cta16
         and f.aooper = ln_ope16
         and f.aosbop = ln_sub16
         and f.aotope = ln_tope16
         and f.evtipo = 31
         and f.d012cd = ln_Pgcod
         and f.d012mo = ln_Itmod
         and f.d012su = ln_Itsuc
         and f.d012tr = ln_Ittran
         and f.d012re = ln_Itnrel
         and f.d012fc = ld_FchSist
         and f.d012or = ln_Itord
         and f.d012sb = ln_Itsbor;
    exception
      when others then
        ln_TieneEvent := 0;
    end;
  
    ln_TieneEvent := nvl(ln_TieneEvent, 0);
  
    if ln_TieneEvent > 0 then
      lc_pcancel := 'S'; -- bloqueara la transaccion ya que es una amortizacion
    else
      lc_pcancel := 'N';
    end if;
  
  end sp_cr_amortizacion;
  -------------------------------------------------------------------
  procedure sp_cr_VerfFndCrcVig(ln_Instancia    in number,
                                lc_TieneFCVigen out varchar2) is
    ln_pais   number := 0;
    ln_tdoc   number := 0;
    lc_ndoc   varchar2(12);
    ln_NroReg number := 0;
  
  begin
  
    lc_TieneFCVigen := 'N';
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from SNG001 S
       WHERE s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_pais > 0 then
      begin
        select count(*)
          into ln_NroReg
          from aqpa377 a, fsd010 f
         where a.aqpa377pais = ln_pais
           and a.aqpa377tdoc = ln_tdoc
           and a.aqpa377ndoc = lc_ndoc
           and a.aqpa377pgcod = f.pgcod
           and a.aqpa377mod = f.aomod
           and a.aqpa377suc = f.aosuc
           and a.aqpa377mda = f.aomda
           and a.aqpa377pap = f.aopap
           and a.aqpa377cta = f.aocta
           and a.aqpa377ope = f.aooper
           and a.aqpa377sbop = f.aosbop
           and a.aqpa377tope = f.aotope
           and f.aostat <> 99;
      exception
        when others then
          null;
      end;
    
      ln_NroReg := nvl(ln_NroReg, 0);
    
      if ln_NroReg > 0 then
        lc_TieneFCVigen := 'S';
      else
        lc_TieneFCVigen := 'N';
      end if;
    end if;
  
  end sp_cr_VerfFndCrcVig;
  -------------------------------------------------------------------
end PQ_CR_RTE_REACTIVA;
/

