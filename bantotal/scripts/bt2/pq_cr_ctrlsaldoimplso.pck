create or replace package pq_cr_CtrlSaldoImplso is

  -- Author  : MPOSTIGOC
  -- Created : 18/05/2023 09:05:44
  -- Purpose :
  -- Acceso                     : Público
  -- Fecha de Modificación      : 29/12/2023
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego validaciones para grabar los datos de las refinanciaciones segun listado
  -- Fecha de Modificación      : 14/03/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego validación para el monto máximo por tipo de cliente
  ----------------------------------------------------------------------------------------------------------------------
  -- Public type declarations

  procedure sp_cr_VerfMntPropImpl(ln_Instancia    in number,
                                  ln_MaxMntImp    out number,
                                  ln_MinMntImp    out number,
                                  lc_VerfMntImpul out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_montos(ln_pais      in number,
                         ln_tdoc      in number,
                         lc_ndoc      in varchar2,
                         ln_MaxMntImp out number,
                         ln_MinMntImp out number);
  ------------------------------------------------------
  procedure sp_cr_montosFlujo(ln_pais      in number,
                              ln_tdoc      in number,
                              lc_ndoc      in varchar2,
                              ln_MaxMntImp out number,
                              ln_MinMntImp out number);
  --------------------------------------------
  procedure sp_cr_VerfVincImpulsa(ln_instancia in number,
                                  lc_Vinculado out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_EnDesembolso(ln_Instancia in number,
                               lc_indicador out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_EsImpulso(ln_Instancia in number,
                            lc_indicador out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_GrupoImpulsa(ln_instancia in number, ln_grupo out number);
  ----------------------------------------------------
  procedure sp_cr_afectacimpl(ln_instancia  in number,
                              lc_afectacion out varchar2);
  --------------------------------------------------------------
  procedure sp_cr_TCEAImpulsa(ln_instancia in number, ln_TCEA out number);
  -------------------------------------------------------
  procedure sp_rte_grabaimpls(ln_pgcodt in number,
                              ln_suct   in number,
                              ln_modt   in number,
                              ln_ttran  in number,
                              ln_relt   in number,
                              ln_ordt   in number);
  -------------------------------------------------------------
  Procedure sp_validaImpulso(pn_emp in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pc_ind out varchar2);
  ------------------------------------------------------------
  procedure sp_Cr_InsertaAQPB161(ln_pais       in number,
                                 ln_tdoc       in number,
                                 lc_ndoc       in varchar2,
                                 ln_sald       in number,
                                 ln_mncond     in number,
                                 ln_mntadi     in number,
                                 ln_minmnt     in number,
                                 ln_maxmnt     in number,
                                 ln_MaxMntCalc in number,
                                 ln_MntCert    in number,
                                 ln_mcond      in number,
                                 ln_mtcan      in number,
                                 lc_Flag       in varchar2);
  --------------------------------------------------------------
  procedure sp_cr_logTCEA_EnWF(ln_Instancia in number,
                               ln_TCEAMax   in number,
                               ln_TCEAWF    in number);

  -----------------------------------------------------------------
  procedure sp_cr_provision(PN_PGCOD  in number,
                            PN_AOMOD  in number,
                            PN_AOSUC  in number,
                            PN_AOMDA  in number,
                            PN_AOPAP  in number,
                            PN_AOCTA  in number,
                            PN_AOOPER in number,
                            PN_AOSBOP in number,
                            PN_AOTOPE in number,
                            PD_FECHA  in date,
                            pn_saldo  out number,
                            pc_ind    out varchar2);
  --------------------------------------------------------------
  procedure sp_Cr_updateaqpb163(ln_instancia in number);
  ----------------------------------------------------------------
  procedure sp_Cr_GrabaMntCanc163(ln_inst   in number,
                                  ln_pais   in number,
                                  ln_tdoc   in number,
                                  lc_ndoc   in varchar2,
                                  ln_pgcod  in number,
                                  ln_mod    in number,
                                  ln_suc    in number,
                                  ln_mda    in number,
                                  ln_pap    in number,
                                  ln_cta    in number,
                                  ln_ope    in number,
                                  ln_sbop   in number,
                                  ln_tope   in number,
                                  ln_cap    in number,
                                  ln_int    in number,
                                  ln_mora   in number,
                                  ln_gasot  in number,
                                  ln_icv    in number,
                                  ln_pnalid in number,
                                  ln_cseg   in number,
                                  ln_mcanc  in number);
  -----------------------------------------------------
  procedure sp_cr_MntCancelar(ln_inst in number, ln_mntcanc out number);
  ----------------------------------------------------------------
  procedure sp_Cr_TotalDesembolsado(ln_MntTope   out number,
                                    ln_mntContab out number,
                                    lc_Flag      out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_RteCntrlCondo(ln_pgcodt in number,
                                ln_suct   in number,
                                ln_modt   in number,
                                ln_ttran  in number,
                                ln_relt   in number,
                                ln_ordt   in number,
                                lc_Flag   out varchar2);
  ----------------------------------------------------------------------
  procedure sp_cr_logAQPB165(ln_pgcod   in number,
                             ln_suct    in number,
                             ln_modt    in number,
                             ln_ttran   in number,
                             ln_relt    in number,
                             ln_ordt    in number,
                             ln_mntope  in number,
                             ln_mntacum in number,
                             ln_cta     in number,
                             ln_pais    in number,
                             ln_tdoc    in number,
                             lc_ndoc    in varchar2,
                             ln_credcd  in number,
                             lc_bloq    in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_TEAExcpcn(ln_instancia in number, ln_TEA out number);
  -----------------------------------------------------------------
end pq_cr_CtrlSaldoImplso;
/

create or replace package body pq_cr_CtrlSaldoImplso is

  procedure sp_cr_VerfMntPropImpl(ln_Instancia    in number,
                                  ln_MaxMntImp    out number,
                                  ln_MinMntImp    out number,
                                  lc_VerfMntImpul out varchar2) is
    -- control que valida que monto otorgado no supere el monto de la suma del saldo de capital de los creditos
    -- a cancelar.(incluir el % adicional según el grupo al que pertenece) mas intereses no descontados
  
    ln_pais    number;
    ln_tdoc    number;
    lc_ndoc    varchar2(12);
    ln_MntSoli number(17, 2) := 0.00;
  
  begin
  
    lc_VerfMntImpul := 'N';
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    Pq_Cr_Ctrlsaldoimplso.sp_cr_montosFlujo(ln_pais,
                                            ln_tdoc,
                                            lc_ndoc,
                                            ln_MaxMntImp,
                                            ln_MinMntImp);
  
    begin
      select c.xllcapital
        into ln_MntSoli
        from xwf700 x, x054023 c
       where x.xwfempresa = c.xllpgcod
         and x.xwfmodulo = c.xllaomod
         and x.xwfsucursal = c.xllaosuc
         and x.xwfmoneda = c.xllaomda
         and x.xwfpapel = c.xllaopap
         and x.xwfcuenta = c.xllaocta
         and x.xwfoperacion = c.xllaooper
         and x.xwfsubope = c.xllaosbop
         and x.xwftipope = c.xllaotop
         and x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_mntsoli < ln_MinMntImp or ln_MntSoli > ln_MaxMntImp then
      lc_VerfMntImpul := 'S';
    else
      lc_VerfMntImpul := 'N';
    end if;
  
  end sp_cr_VerfMntPropImpl;
  ---------------------------
  procedure sp_cr_montos(ln_pais      in number,
                         ln_tdoc      in number,
                         lc_ndoc      in varchar2,
                         ln_MaxMntImp out number,
                         ln_MinMntImp out number) is
  
    cursor ListadoCred(ln_paisaux number,
                       ln_tdocaux number,
                       lc_ndoc    varchar2) is
    
      select a.aqpc589emp,
             a.aqpc589mod,
             a.aqpc589suc,
             a.aqpc589mda,
             a.aqpc589pap,
             a.aqpc589cta,
             a.aqpc589oper,
             a.aqpc589sbop,
             a.aqpc589top
        from aqpc589 a
       WHERE a.aqpc589pais = ln_paisaux
         and a.aqpc589ptdc = ln_tdocaux
         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
         and AQPC589ESTPRO = 'A'
         and aqpc589ESTHAB = 'H';
  
    ln_saldoCap       number(17, 2) := 0.00;
    ln_saldoCapAux    number(17, 2) := 0.00;
    ln_grupo          number := 0;
    ln_porctadic      number := 0;
    ln_MntAdicional   number(17, 2) := 0.00;
    ln_MntNoCondonado number(17, 2) := 0.00;
    ln_paisaux        number;
    ln_tdocaux        number;
    ln_MntCertificado number(17, 2) := 0.00;
    ln_MntCondonado   number(17, 2) := 0.00;
    ln_TMntCancl      number(17, 2) := 0.00;
    ln_MaxMntCal      number(17, 2) := 0.00;
  
  begin
  
    if ln_pais = 0 or ln_tdoc = 0 then
    
      ln_paisaux := 604;
      ln_tdocaux := 21;
    
    else
      if ln_pais > 0 and ln_tdoc > 0 then
        ln_paisaux := ln_pais;
        ln_tdocaux := ln_tdoc;
      
      end if;
    end if;
  
    begin
      begin
        update aqpb161 a
           set a.aqpb161est = 'I'
         where a.aqpb161pais = ln_paisaux
           and a.aqpb161tdoc = ln_tdocaux
           and a.aqpb161ndoc = trim(lc_ndoc)
           and a.aqpb161est = 'H';
      exception
        when others then
          update aqpb161 a
             set a.aqpb161est = 'X'
           where a.aqpb161pais = ln_paisaux
             and a.aqpb161tdoc = ln_tdocaux
             and a.aqpb161ndoc = lc_ndoc
             and a.aqpb161est = 'H';
      end;
      commit;
    end;
  
    begin
      select a.aqpc363grepr, a.aqpc363mont
        into ln_grupo, ln_MntCertificado
        from aqpc363 a
       where a.aqpc363pais = ln_paisaux
         and a.aqpc363tdoc = ln_tdocaux
         and a.aqpc363ndoc = rpad(lc_ndoc, 12, ' ')
         and a.aqpc363est = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      select f.tp1nro3
        into ln_porctadic
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 120
         and f.tp1corr2 = 1
         and f.tp1nro2 = ln_grupo;
    exception
      when others then
        ln_porctadic := 0;
    end;
  
    for l in ListadoCred(ln_paisaux, ln_tdocaux, lc_ndoc) loop
      ln_saldoCapAux := 0.00;
    
      begin
        select f.scsdo
          into ln_saldoCapAux
          from fsd011 f
         where f.pgcod = l.aqpc589emp
           and f.scmod = l.aqpc589mod
           and f.scsuc = l.aqpc589suc
           and f.scmda = l.aqpc589mda
           and f.scpap = l.aqpc589pap
           and f.sccta = l.aqpc589cta
           and f.scoper = l.aqpc589oper
           and f.scsbop = l.aqpc589sbop
           and f.sctope = l.aqpc589top
           and f.scstat in (select f.tp1nro3
                              from fst198 f
                             where f.TP1COD = 1
                               and f.TP1COD1 = 11138
                               and f.TP1CORR1 = 22
                               and f.TP1CORR2 = 4
                               and f.tp1corr3 > 0);
      exception
        when others then
          ln_saldoCapAux := 0.00;
      end;
    
      if ln_saldoCapAux < 0 then
      
        ln_saldoCapAux := ln_saldoCapAux * -1;
      
      end if;
    
      ln_saldoCap := nvl(ln_saldoCap, 0) + nvl(ln_saldoCapAux, 0);
    
    end loop;
  
    begin
      -- aqui se debe agregar la validacion a las tablas de henry para identificar el monto no condonado
      -- ln_MntNoCondonado := 550;
    
      select sum(a.aqpc589inact)
        into ln_MntNoCondonado
        from aqpc589 a
       WHERE a.aqpc589pais = ln_paisaux
         and a.aqpc589ptdc = ln_tdocaux
         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
         and AQPC589ESTPRO = 'A'
         and aqpc589ESTHAB = 'H';
    exception
      when others then
        null;
    end;
  
    ln_MntNoCondonado := nvl(ln_MntNoCondonado, 0);
  
    begin
      -- aqui se debe agregar la validacion a las tablas de henry para identificar el monto no condonado
      -- ln_MntNoCondonado := 550;
    
      select sum(a.aqpc589incon)
        into ln_MntCondonado
        from aqpc589 a
       WHERE a.aqpc589pais = ln_paisaux
         and a.aqpc589ptdc = ln_tdocaux
         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
         and AQPC589ESTPRO = 'A'
         and aqpc589ESTHAB = 'H';
    exception
      when others then
        null;
    end;
  
    ln_MntCondonado := nvl(ln_MntCondonado, 0);
  
    begin
      -- Como monto minimo se considera el importe total de lo que se cancelara en ventanilla
      -- el monto es el calculado al dia de la gestion por el panel de condonaciones
    
      select sum(a.aqpc589mtdeu)
        into ln_TMntCancl
        from aqpc589 a
       WHERE a.aqpc589pais = ln_paisaux
         and a.aqpc589ptdc = ln_tdocaux
         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
         and AQPC589ESTPRO = 'A'
         and aqpc589ESTHAB = 'H';
    exception
      when others then
        null;
    end;
  
    ln_TMntCancl := nvl(ln_TMntCancl, 0);
  
    if ln_porctadic > 0 then
    
      ln_MntAdicional := (ln_saldoCap * ln_porctadic) / 100;
    
    end if;
  
    -- ln_MinMntImp := ln_saldoCap + ln_MntAdicional;
    ln_MinMntImp := ln_TMntCancl - ln_MntCondonado;
    ln_MaxMntCal := ln_saldoCap + ln_MntAdicional + ln_MntNoCondonado;
  
    if ln_MaxMntCal >= ln_MntCertificado then
      ln_MaxMntImp := ln_MntCertificado;
    else
      if ln_MaxMntCal < ln_MntCertificado then
        ln_MaxMntImp := ln_MaxMntCal;
      end if;
    end if;
  
    if ln_MinMntImp >= ln_MntCertificado then
      ln_MinMntImp := ln_MntCertificado;
    else
      if ln_MinMntImp < ln_MntCertificado then
        ln_MinMntImp := ln_MinMntImp;
      end if;
    end if;
  
    if ln_MaxMntImp > 90000 then
      ln_MaxMntImp := 90000;
    end if;
  
    if ln_MinMntImp > 90000 then
      ln_MinMntImp := 90000;
    end if;
  
    begin
      pq_cr_ctrlsaldoimplso.sp_Cr_InsertaAQPB161(ln_pais       => ln_paisaux,
                                                 ln_tdoc       => ln_tdocaux,
                                                 lc_ndoc       => trim(lc_ndoc),
                                                 ln_sald       => ln_saldoCap,
                                                 ln_mncond     => ln_MntNoCondonado,
                                                 ln_mntadi     => ln_MntAdicional,
                                                 ln_minmnt     => ln_MinMntImp,
                                                 ln_maxmnt     => ln_MaxMntImp,
                                                 ln_MaxMntCalc => ln_MaxMntCal,
                                                 ln_MntCert    => ln_MntCertificado,
                                                 ln_mcond      => ln_MntCondonado,
                                                 ln_mtcan      => ln_TMntCancl,
                                                 lc_Flag       => 'H');
    exception
      when others then
        null;
    end;
  
    begin
      update aqpc589 a
         set a.aqpc589mntmin = ln_MinMntImp, a.aqpc589mntmax = ln_MaxMntImp
       WHERE a.aqpc589pais = ln_paisaux
         and a.aqpc589ptdc = ln_tdocaux
         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
         and AQPC589ESTPRO = 'A'
         and aqpc589ESTHAB = 'H';
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_cr_montos;
  ----------------------------------------------
  procedure sp_cr_montosFlujo(ln_pais      in number,
                              ln_tdoc      in number,
                              lc_ndoc      in varchar2,
                              ln_MaxMntImp out number,
                              ln_MinMntImp out number) is
  
    cursor ListadoCred is
      select a.aqpc589emp,
             a.aqpc589mod,
             a.aqpc589suc,
             a.aqpc589mda,
             a.aqpc589pap,
             a.aqpc589cta,
             a.aqpc589oper,
             a.aqpc589sbop,
             a.aqpc589top
        from aqpc589 a
       WHERE a.aqpc589pais = ln_pais
         and a.aqpc589ptdc = ln_tdoc
         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
         and AQPC589ESTPRO = 'A'
         and aqpc589ESTHAB = 'H';
  
    ln_saldoCap       number(17, 2) := 0.00;
    ln_saldoCapAux    number(17, 2) := 0.00;
    ln_grupo          number := 0;
    ln_porctadic      number := 0;
    ln_MntAdicional   number(17, 2) := 0.00;
    ln_MntNoCondonado number(17, 2) := 0.00;
    ln_MntCertificado number(17, 2) := 0.00;
    ln_MntCondonado   number(17, 2) := 0.00;
    ln_TMntCancl      number(17, 2) := 0.00;
    ln_MaxMntCal      number(17, 2) := 0.00;
    ln_TipCliente     number;
  
  begin
    ln_MinMntImp := 0;
  
    begin
      update aqpb161 a
         set a.aqpb161est = 'N'
       where a.aqpb161pais = ln_pais
         and a.aqpb161tdoc = ln_tdoc
         and a.aqpb161ndoc = lc_ndoc
         and a.aqpb161est = 'F';
      commit;
    end;
  
    begin
      select a.aqpc363grepr, a.aqpc363mont, a.aqpc363tcli
        into ln_grupo, ln_MntCertificado, ln_TipCliente
        from aqpc363 a
       where a.aqpc363pais = ln_pais
         and a.aqpc363tdoc = ln_tdoc
         and a.aqpc363ndoc = rpad(lc_ndoc, 12, ' ')
         and a.aqpc363est = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      select f.tp1nro3
        into ln_porctadic
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 120
         and f.tp1corr2 = 1
         and f.tp1nro2 = ln_grupo;
    exception
      when others then
        ln_porctadic := 0;
    end;
  
    if ln_TipCliente = 0 then
      --mpostigoc 14/03/2024
    
      for l in ListadoCred loop
        ln_saldoCapAux := 0.00;
      
        begin
          select f.scsdo
            into ln_saldoCapAux
            from fsd011 f
           where f.pgcod = l.aqpc589emp
             and f.scmod = l.aqpc589mod
             and f.scsuc = l.aqpc589suc
             and f.scmda = l.aqpc589mda
             and f.scpap = l.aqpc589pap
             and f.sccta = l.aqpc589cta
             and f.scoper = l.aqpc589oper
             and f.scsbop = l.aqpc589sbop
             and f.sctope = l.aqpc589top
             and f.scstat in (select f.tp1nro3
                                from fst198 f
                               where f.TP1COD = 1
                                 and f.TP1COD1 = 11138
                                 and f.TP1CORR1 = 22
                                 and f.TP1CORR2 = 4
                                 and f.tp1corr3 > 0);
        exception
          when others then
            ln_saldoCapAux := 0.00;
        end;
      
        if ln_saldoCapAux < 0 then
        
          ln_saldoCapAux := ln_saldoCapAux * -1;
        
        end if;
      
        ln_saldoCap := nvl(ln_saldoCap, 0) + nvl(ln_saldoCapAux, 0);
      
      end loop;
    
      begin
        -- aqui se debe agregar la validacion a las tablas de henry para identificar el monto no condonado
        -- ln_MntNoCondonado := 550;
      
        select sum(a.aqpc589inact)
          into ln_MntNoCondonado
          from aqpc589 a
         WHERE a.aqpc589pais = ln_pais
           and a.aqpc589ptdc = ln_tdoc
           and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
           and AQPC589ESTPRO = 'A'
           and aqpc589ESTHAB = 'H';
      exception
        when others then
          null;
      end;
    
      ln_MntNoCondonado := nvl(ln_MntNoCondonado, 0);
    
      begin
        -- aqui se debe agregar la validacion a las tablas de henry para identificar el monto no condonado
        -- ln_MntNoCondonado := 550;
      
        select sum(a.aqpc589incon)
          into ln_MntCondonado
          from aqpc589 a
         WHERE a.aqpc589pais = ln_pais
           and a.aqpc589ptdc = ln_tdoc
           and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
           and AQPC589ESTPRO = 'A'
           and aqpc589ESTHAB = 'H';
      exception
        when others then
          null;
      end;
    
      ln_MntCondonado := nvl(ln_MntCondonado, 0);
    
      begin
        -- Como monto minimo se considera el importe total de lo que se cancelara en ventanilla
        -- el monto es el calculado al dia de la gestion por el panel de condonaciones
      
        select sum(a.aqpc589mtdeu)
          into ln_TMntCancl
          from aqpc589 a
         WHERE a.aqpc589pais = ln_pais
           and a.aqpc589ptdc = ln_tdoc
           and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
           and AQPC589ESTPRO = 'A'
           and aqpc589ESTHAB = 'H';
      exception
        when others then
          null;
      end;
    
      ln_TMntCancl := nvl(ln_TMntCancl, 0);
    
      if ln_porctadic > 0 then
        ln_MntAdicional := (ln_saldoCap * ln_porctadic) / 100;
      end if;
    
      -- ln_MinMntImp := ln_saldoCap + ln_MntAdicional;
      ln_MinMntImp := ln_TMntCancl + ln_MntCondonado;
      ln_MaxMntCal := ln_saldoCap + ln_MntAdicional + ln_MntNoCondonado;
    
    else
      if ln_TipCliente > 0 then
      
        ln_MaxMntImp := ln_MntCertificado;
        ln_MaxMntCal := ln_MntCertificado;
      
      end if;
    end if;
  
    if ln_MaxMntCal >= ln_MntCertificado then
      ln_MaxMntImp := ln_MntCertificado;
    else
      if ln_MaxMntCal < ln_MntCertificado then
        ln_MaxMntImp := ln_MaxMntCal;
      end if;
    end if;
  
    if ln_MinMntImp >= ln_MntCertificado then
      ln_MinMntImp := ln_MntCertificado;
    else
      if ln_MinMntImp < ln_MntCertificado then
        ln_MinMntImp := ln_MinMntImp;
      end if;
    end if;
  
    if ln_MaxMntImp > 90000 then
      ln_MaxMntImp := 90000;
    end if;
  
    if ln_MinMntImp > 90000 then
      ln_MinMntImp := 90000;
    end if;
  
    begin
      pq_cr_ctrlsaldoimplso.sp_Cr_InsertaAQPB161(ln_pais       => ln_pais,
                                                 ln_tdoc       => ln_tdoc,
                                                 lc_ndoc       => trim(lc_ndoc),
                                                 ln_sald       => ln_saldoCap,
                                                 ln_mncond     => ln_MntNoCondonado,
                                                 ln_mntadi     => ln_MntAdicional,
                                                 ln_minmnt     => ln_MinMntImp,
                                                 ln_maxmnt     => ln_MaxMntImp,
                                                 ln_MaxMntCalc => ln_MaxMntCal,
                                                 ln_MntCert    => ln_MntCertificado,
                                                 ln_mcond      => ln_MntCondonado,
                                                 ln_mtcan      => ln_TMntCancl,
                                                 lc_Flag       => 'F');
    exception
      when others then
        null;
    end;
  
  end sp_cr_montosFlujo;

  --------------------------------------------
  procedure sp_cr_VerfVincImpulsa(ln_instancia in number,
                                  lc_Vinculado out varchar2) is
  
    cursor VinculadosImpulso(ln_pais number,
                             ln_tdoc number,
                             lc_ndoc varchar2) is
      select a.aqpc589emp,
             a.aqpc589mod,
             a.aqpc589suc,
             a.aqpc589mda,
             a.aqpc589pap,
             a.aqpc589cta,
             a.aqpc589oper,
             a.aqpc589sbop,
             a.aqpc589top
        from aqpc589 a
       WHERE a.aqpc589pais = ln_pais
         and a.aqpc589ptdc = ln_tdoc
         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
         and AQPC589ESTPRO = 'A'
         and aqpc589ESTHAB = 'H';
  
    cursor VinculadosFlujo is
      select *
        from jaqy800 j
       where j.jaqy800ins = ln_instancia
         and j.jaqy800vinc = 'S';
  
    cursor lineas(ln_800pgcd number,
                  ln_800mod  number,
                  ln_800suc  number,
                  ln_800mda  number,
                  ln_800pap  number,
                  ln_800cta  number,
                  ln_800ope  number,
                  ln_800sbop number,
                  ln_800tope number) is
      select f.r1cod,
             f.r1mod,
             f.r1suc,
             f.r1mda,
             f.r1pap,
             f.r1cta,
             f.r1oper,
             f.r1sbop,
             f.r1tope
        from fsr011 f, fsd010 g
       where f.r2cod = ln_800pgcd
         and f.r2mod = ln_800mod
         and f.r2suc = ln_800suc
         and f.r2mda = ln_800mda
         and f.r2pap = ln_800pap
         and f.r2cta = ln_800cta
         and f.r2oper = ln_800ope
         and f.r2sbop = ln_800sbop
         and f.r2tope = ln_800tope
         and f.relcod = 46
         and g.PGCOD = f.r1cod
         and g.AOMOD = f.r1mod
         and g.AOSUC = f.r1suc
         and g.AOMDA = f.r1mda
         and g.AOPAP = f.r1pap
         and g.AOCTA = f.r1cta
         and g.AOOPER = f.r1oper
         and g.AOSBOP = f.r1sbop
         and g.AOTOPE = f.r1tope
         and g.AOSTAT <> 99;
  
    ln_pais     number;
    ln_tdoc     number;
    lc_ndoc     varchar2(12);
    ln_NroReg   number;
    ln_NroReg2  number;
    ln_Tiene116 number;
    ln_Vinculo  number;
    ln_pgcod117 number;
    ln_mod117   number;
    ln_suc117   number;
    ln_mda117   number;
    ln_pap117   number;
    ln_cta117   number;
    ln_ope117   number;
    ln_sbop117  number;
    ln_tope117  number;
    /*ln_pgcod116 number;
    ln_mod116     number;
    ln_suc116     number;
    ln_mda116     number;
    ln_pap116     number;
    ln_cta116     number;
    ln_ope116     number;
    ln_sbop116    number;
    ln_tope116    number;*/
    ln_DisposVgnt number;
  
  begin
  
    lc_Vinculado := 'N';
    ln_Vinculo   := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_Tiene116
        from aqpc589 a
       WHERE a.aqpc589pais = ln_pais
         and a.aqpc589ptdc = ln_tdoc
         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
         and AQPC589ESTPRO = 'A'
         and aqpc589ESTHAB = 'H'
         and a.aqpc589mod = 116;
    exception
      when others then
        null;
    end;
  
    if ln_Tiene116 = 0 then
    
      begin
        select count(*)
          into ln_NroReg
          from (select a.aqpc589emp,
                       a.aqpc589mod,
                       a.aqpc589suc,
                       a.aqpc589mda,
                       a.aqpc589pap,
                       a.aqpc589cta,
                       a.aqpc589oper,
                       a.aqpc589sbop,
                       a.aqpc589top
                  from aqpc589 a
                 WHERE a.aqpc589pais = ln_pais
                   and a.aqpc589ptdc = ln_tdoc
                   and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
                   and AQPC589ESTPRO = 'A'
                   and aqpc589ESTHAB = 'H'
                minus
                select j.jaqy800pgcd,
                       j.jaqy800mod,
                       j.jaqy800suc,
                       j.jaqy800mda,
                       j.jaqy800pap,
                       j.jaqy800cta,
                       j.jaqy800ope,
                       j.jaqy800sbop,
                       j.jaqy800tope
                  from jaqy800 j
                 where j.jaqy800ins = ln_Instancia
                   and j.jaqy800vinc = 'S') t;
      exception
        when others then
          ln_NroReg := 0;
      end;
    
      begin
        select count(*)
          into ln_NroReg2
          from (select j.jaqy800pgcd,
                       j.jaqy800mod,
                       j.jaqy800suc,
                       j.jaqy800mda,
                       j.jaqy800pap,
                       j.jaqy800cta,
                       j.jaqy800ope,
                       j.jaqy800sbop,
                       j.jaqy800tope
                  from jaqy800 j
                 where j.jaqy800ins = ln_Instancia
                   and j.jaqy800vinc = 'S'
                minus
                select a.aqpc589emp,
                       a.aqpc589mod,
                       a.aqpc589suc,
                       a.aqpc589mda,
                       a.aqpc589pap,
                       a.aqpc589cta,
                       a.aqpc589oper,
                       a.aqpc589sbop,
                       a.aqpc589top
                  from aqpc589 a
                 WHERE a.aqpc589pais = ln_pais
                   and a.aqpc589ptdc = ln_tdoc
                   and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
                   and AQPC589ESTPRO = 'A'
                   and aqpc589ESTHAB = 'H') t;
      exception
        when others then
          ln_NroReg := 0;
      end;
    
      if ln_NroReg > 0 or ln_NroReg2 > 0 then
        lc_Vinculado := 'N';
      else
        lc_Vinculado := 'S';
      end if;
    
    else
      if ln_Tiene116 > 0 then
      
        for v in VinculadosImpulso(ln_pais, ln_tdoc, lc_ndoc) loop
        
          lc_Vinculado := 'N';
          ln_Vinculo   := 0;
        
          if v.aqpc589mod <> 116 then
          
            begin
              select count(*)
                into ln_Vinculo
                from jaqy800 j
               where j.jaqy800ins = ln_Instancia
                 and j.jaqy800mod = v.aqpc589mod
                 and j.jaqy800suc = v.aqpc589suc
                 and j.jaqy800mda = v.aqpc589mda
                 and j.jaqy800pap = v.aqpc589pap
                 and j.jaqy800cta = v.aqpc589cta
                 and j.jaqy800ope = v.aqpc589oper
                 and j.jaqy800sbop = v.aqpc589sbop
                 and j.jaqy800tope = v.aqpc589top
                 and j.jaqy800vinc = 'S';
            exception
              when others then
                null;
            end;
          
          else
            if v.aqpc589mod = 116 then
            
              begin
                select f.r2cod,
                       f.r2mod,
                       f.r2suc,
                       f.r2mda,
                       f.r2pap,
                       f.r2cta,
                       f.r2oper,
                       f.r2sbop,
                       f.r2tope
                  into ln_pgcod117,
                       ln_mod117,
                       ln_suc117,
                       ln_mda117,
                       ln_pap117,
                       ln_cta117,
                       ln_ope117,
                       ln_sbop117,
                       ln_tope117
                  from fsr011 f
                 where f.r1cod = v.aqpc589emp
                   and f.r1mod = v.aqpc589mod
                   and f.r1suc = v.aqpc589suc
                   and f.r1mda = v.aqpc589mda
                   and f.r1pap = v.aqpc589pap
                   and f.r1cta = v.aqpc589cta
                   and f.r1oper = v.aqpc589oper
                   and f.r1sbop = v.aqpc589sbop
                   and f.r1tope = v.aqpc589top
                   and f.relcod = 46;
              exception
                when others then
                  null;
              end;
            
              begin
                select count(*)
                  into ln_Vinculo
                  from jaqy800 j
                 where j.jaqy800ins = ln_Instancia
                   and j.jaqy800mod = ln_mod117
                   and j.jaqy800suc = ln_suc117
                   and j.jaqy800mda = ln_mda117
                   and j.jaqy800pap = ln_pap117
                   and j.jaqy800cta = ln_cta117
                   and j.jaqy800ope = ln_ope117
                   and j.jaqy800sbop = ln_sbop117
                   and j.jaqy800tope = ln_tope117
                   and j.jaqy800vinc = 'S';
              exception
                when others then
                  null;
              end;
            
            end if;
          end if;
        
          if ln_Vinculo = 0 then
            lc_Vinculado := 'N';
            exit;
          else
            lc_Vinculado := 'S';
          end if;
        
        end loop;
      
        if lc_Vinculado = 'S' then
          for f in VinculadosFlujo loop
            lc_Vinculado := 'S';
            ln_Vinculo   := 0;
          
            if f.jaqy800mod <> 117 then
            
              begin
                select count(*)
                  into ln_Vinculo
                  from aqpc589 a
                 where a.aqpc589pais = ln_pais
                   and a.aqpc589ptdc = ln_tdoc
                   and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
                   and a.aqpc589emp = f.jaqy800pgcd
                   and a.aqpc589mod = f.jaqy800mod
                   and a.aqpc589suc = f.jaqy800suc
                   and a.aqpc589mda = f.jaqy800mda
                   and a.aqpc589pap = f.jaqy800pap
                   and a.aqpc589cta = f.jaqy800cta
                   and a.aqpc589oper = f.jaqy800ope
                   and a.aqpc589sbop = f.jaqy800sbop
                   and a.aqpc589top = f.jaqy800tope
                   and AQPC589ESTPRO = 'A'
                   and aqpc589ESTHAB = 'H';
              exception
                when others then
                  null;
              end;
            
            else
              if f.jaqy800mod = 117 then
                ln_DisposVgnt := 0;
                for l in lineas(f.jaqy800pgcd, f.jaqy800mod, f.jaqy800suc, f.jaqy800mda, f.jaqy800pap, f.jaqy800cta, f.jaqy800ope, f.jaqy800sbop, f.jaqy800tope) loop
                  begin
                    select count(*)
                      into ln_DisposVgnt
                      from fsd010 s
                     where s.pgcod = l.r1cod
                       and s.aomod = l.r1mod
                       and s.aosuc = l.r1suc
                       and s.aomda = l.r1mda
                       and s.aopap = l.r1pap
                       and s.aocta = l.r1cta
                       and s.aooper = l.r1oper
                       and s.aosbop = l.r1sbop
                       and s.aotope = l.r1tope
                       and s.aostat <> 99;
                  exception
                    when others then
                      null;
                  end;
                
                  if ln_DisposVgnt > 0 then
                  
                    begin
                      select count(*)
                        into ln_Vinculo
                        from aqpc589 a
                       where a.aqpc589pais = ln_pais
                         and a.aqpc589ptdc = ln_tdoc
                         and a.aqpc589dni = rpad(lc_ndoc, 12, ' ')
                         and a.aqpc589emp = l.r1cod
                         and a.aqpc589mod = l.r1mod
                         and a.aqpc589suc = l.r1suc
                         and a.aqpc589mda = l.r1mda
                         and a.aqpc589pap = l.r1pap
                         and a.aqpc589cta = l.r1cta
                         and a.aqpc589oper = l.r1oper
                         and a.aqpc589sbop = l.r1sbop
                         and a.aqpc589top = l.r1tope
                         and AQPC589ESTPRO = 'A'
                         and aqpc589ESTHAB = 'H';
                    exception
                      when others then
                        null;
                    end;
                  
                    if ln_Vinculo = 0 then
                      lc_Vinculado := 'N';
                      exit;
                    else
                      lc_Vinculado := 'S';
                    end if;
                  
                  else
                    lc_Vinculado := 'S';
                  end if;
                
                end loop;
              
              end if;
            end if;
          
          end loop;
        end if;
      end if;
    end if;
  
  end sp_cr_VerfVincImpulsa;
  ----------------------------------------------
  procedure sp_cr_EnDesembolso(ln_Instancia in number,
                               lc_indicador out varchar2) is
  
    ---2023.05.23 DCASTRO  determinar si se encuentra en tarea de desembolso
  begin
  
    begin
      select 'S'
        into lc_indicador
        from wfwrkitems s
       where s.wfinsprcid = ln_Instancia
         and s.WFTASKCOD = 55 --tarea desembolso
         and s.WFITEMSTSACT = 1 --estado activo
         and s.WFITEMINIT in
             (select max(WFITEMINIT)
                from wfwrkitems w
               where w.wfinsprcid = ln_Instancia);
    exception
      when others then
        lc_indicador := 'N';
    end;
  
    if lc_indicador is null then
      lc_indicador := nvl(lc_indicador, 'N');
    end if;
  
  end sp_cr_EnDesembolso;
  ------------------------------------------------------------
  procedure sp_cr_EsImpulso(ln_Instancia in number,
                            lc_indicador out varchar2) is
  
    ---2023.05.23 DCASTRO  determinar si es impulso peru
  begin
    -- 101/360
    begin
      select 'S'
        into lc_indicador
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfmodulo = 101
         and x.xwftipope = 360
         and x.xwfcar3 = '1'; --impulso Perú
    
    exception
      when others then
        lc_indicador := 'N';
    end;
  
    if lc_indicador is null then
      lc_indicador := nvl(lc_indicador, 'N');
    end if;
  
  end sp_cr_EsImpulso;
  --------------------------------------------------
  procedure sp_cr_GrupoImpulsa(ln_instancia in number, ln_grupo out number) is
  
    ln_pais number;
    ln_tdoc number;
    lc_ndoc varchar2(12);
  
  begin
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpc363grepr
        into ln_grupo
        from aqpc363 a
       where a.aqpc363pais = ln_pais
         and a.aqpc363tdoc = ln_tdoc
         and a.aqpc363ndoc = rpad(lc_ndoc, 12, ' ')
         and a.aqpc363est = 'S';
    exception
      when others then
        null;
    end;
  
  end sp_cr_GrupoImpulsa;
  ----------------------------------------------------
  procedure sp_cr_afectacimpl(ln_instancia  in number,
                              lc_afectacion out varchar2) is
  
    ln_pais number;
    ln_tdoc number;
    lc_ndoc varchar2(12);
  
  begin
  
    lc_afectacion := 'SINDATO';
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      begin
        select a.aqpc363zafec
          into lc_afectacion
          from aqpc363 a
         where a.aqpc363pais = ln_pais
           and a.aqpc363tdoc = ln_tdoc
           and a.aqpc363ndoc = rpad(lc_ndoc, 12, ' ')
           and a.aqpc363est = 'S';
      exception
        when others then
          lc_afectacion := 'SINDATO';
      end;
    end;
  
  end sp_cr_afectacimpl;
  -----------------------------------------------------
  procedure sp_cr_TCEAImpulsa(ln_instancia in number, ln_TCEA out number) is
  
    ln_pais number;
    ln_tdoc number;
    lc_ndoc varchar2(12);
  
  begin
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpc363tcea
        into ln_TCEA
        from aqpc363 a
       where a.aqpc363pais = ln_pais
         and a.aqpc363tdoc = ln_tdoc
         and a.aqpc363ndoc = rpad(lc_ndoc, 12, ' ')
         and a.aqpc363est = 'S';
    exception
      when others then
        null;
    end;
  
  end sp_cr_TCEAImpulsa;
  ----------------------------------------------------
  procedure sp_rte_grabaimpls(ln_pgcodt in number,
                              ln_suct   in number,
                              ln_modt   in number,
                              ln_ttran  in number,
                              ln_relt   in number,
                              ln_ordt   in number) is
  
    ln_pgcod       number;
    ln_mod         number;
    ln_suc         number;
    ln_mda         number;
    ln_pap         number;
    ln_cta         number;
    ln_ope         number;
    ln_sub         number;
    ln_tope        number;
    ln_instancia   number;
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ld_FechVal     date;
    ld_fchSist     date;
    ModAnu         number;
    ln_NroRel      number;
    lc_hora        varchar2(8) := '00:00:00';
    ln_InstDesemb  number;
    lc_Fecha       varchar2(10);
    ln_pgcodr      number;
    ln_modr        number;
    ln_sucr        number;
    ln_mdar        number;
    ln_papr        number;
    ln_ctar        number;
    ln_oper        number;
    ln_subr        number;
    ln_toper       number;
    ln_EstaEnLista number;
  
  begin
  
    if ln_modt < 500 then
      begin
        select f.pgcod,
               f.modulo,
               f.itsucd,
               f.moneda,
               f.papel,
               f.ctnro,
               f.itoper,
               f.itsubo,
               f.ittope,
               f.itfval
          into ln_pgcod,
               ln_mod,
               ln_suc,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sub,
               ln_tope,
               ld_FechVal
          from fsd016 f
         where f.pgcod = ln_pgcodt
           and f.itsuc = ln_suct
           and f.itmod = ln_modt
           and f.ittran = ln_ttran
           and f.itnrel = ln_relt
           and f.itord = ln_ordt;
      exception
        when others then
          null;
      end;
    
      if ln_mod = 101 and ln_tope = 360 then
      
        ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                             v_Scsuc  => ln_suc,
                                             v_Scmda  => ln_mda,
                                             v_Scpap  => ln_pap,
                                             v_Sccta  => ln_cta,
                                             v_Scoper => ln_ope,
                                             v_Scsbop => ln_sub,
                                             v_Sctope => ln_tope);
      
        begin
          select f.pepais, f.petdoc, f.pendoc
            into ln_pais, ln_tdoc, lc_ndoc
            from fsr008 f
           where f.pgcod = 1
             and f.ctnro = ln_cta
             and f.cttfir = 'T';
        exception
          when others then
            null;
        end;
      
        begin
          update aqpc363 a
             set A.AQPC363INST  = ln_instancia,
                 a.aqpc363pgcod = ln_pgcod,
                 a.aqpc363mod   = ln_mod,
                 a.aqpc363suc   = ln_suc,
                 a.aqpc363mda   = ln_mda,
                 a.aqpc363pap   = ln_pap,
                 a.aqpc363cta   = ln_cta,
                 a.aqpc363ope   = ln_ope,
                 a.aqpc363sbop  = ln_sub,
                 a.aqpc363tope  = ln_tope,
                 a.AQPC363FDES  = ld_FechVal,
                 a.aqpc363est   = 'P'
           where a.aqpc363pais = ln_pais
             and a.aqpc363tdoc = ln_tdoc
             and a.aqpc363ndoc = RPAD(lc_ndoc, 12, ' ')
             and a.aqpc363est = 'S';
        exception
          when others then
            null;
        end;
      
      else
        if ln_modt = 30 and ln_ttran in (350, 351) then
          -- Verifica si es una refinanciacion  MPOSTIGOC 29/12/2023
        
          begin
            select f.pgcod,
                   f.modulo,
                   f.itsucd,
                   f.moneda,
                   f.papel,
                   f.ctnro,
                   f.itoper,
                   f.itsubo,
                   f.ittope,
                   f.itfval
              into ln_pgcod,
                   ln_mod,
                   ln_suc,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_ope,
                   ln_sub,
                   ln_tope,
                   ld_FechVal
              from fsd016 f
             where f.pgcod = ln_pgcodt
               and f.itsuc = ln_suct
               and f.itmod = ln_modt
               and f.ittran = ln_ttran
               and f.itnrel = ln_relt
               and f.itord = ln_ordt;
          end;
        
          begin
            ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                                 v_Scsuc  => ln_suc,
                                                 v_Scmda  => ln_mda,
                                                 v_Scpap  => ln_pap,
                                                 v_Sccta  => ln_cta,
                                                 v_Scoper => ln_ope,
                                                 v_Scsbop => ln_sub,
                                                 v_Sctope => ln_tope);
          end;
          begin
            select x.xwfempresa,
                   x.xwfsucursal,
                   x.xwfmodulo,
                   x.xwfmoneda,
                   x.xwfpapel,
                   x.xwfcuenta,
                   x.xwfoperacion,
                   x.xwfsubope,
                   x.xwftipope
              into ln_pgcodr,
                   ln_sucr,
                   ln_modr,
                   ln_mdar,
                   ln_papr,
                   ln_ctar,
                   ln_oper,
                   ln_subr,
                   ln_toper
              from xwf700 x
             where x.xwfprcins = ln_instancia
               and x.xwfcar3 <> '1';
          exception
            when others then
              null;
          end;
        
          begin
            select count(*)
              into ln_EstaEnLista
              from aqpb175 a
             where a.aqpb175empr = ln_pgcodr
               and a.aqpb175modr = ln_modr
               and a.aqpb175sucr = ln_sucr
               and a.aqpb175mdar = ln_mdar
               and a.aqpb175papr = ln_papr
               and a.aqpb175ctar = ln_ctar
               and a.aqpb175oper = ln_oper
               and a.aqpb175subpr = ln_subr
               and a.aqpb175toper = ln_toper
               and a.aqpb175est = 'S';
          exception
            when others then
              null;
          end;
        
          if ln_EstaEnLista > 0 then
          
            begin
              update aqpb175 a
                 set a.aqpb175empt  = ln_pgcodt,
                     a.aqpb175modt  = ln_suct,
                     a.aqpb175suct  = ln_modt,
                     a.aqpb175tran  = ln_ttran,
                     a.aqpb175relt  = ln_relt,
                     a.aqpb175inst  = ln_instancia,
                     a.aqpb175pgcod = ln_pgcod,
                     a.aqpb175mod   = ln_mod,
                     a.aqpb175suc   = ln_suc,
                     a.aqpb175mda   = ln_mda,
                     a.aqpb175pap   = ln_pap,
                     a.aqpb175cta   = ln_cta,
                     a.aqpb175ope   = ln_ope,
                     a.aqpb175subp  = ln_sub,
                     a.aqpb175tope  = ln_tope,
                     a.aqpb175fdes  = ld_FechVal,
                     a.aqpb175est   = 'P'
               where a.aqpb175empr = ln_pgcodr
                 and a.aqpb175modr = ln_modr
                 and a.aqpb175sucr = ln_sucr
                 and a.aqpb175mdar = ln_mdar
                 and a.aqpb175papr = ln_papr
                 and a.aqpb175ctar = ln_ctar
                 and a.aqpb175oper = ln_oper
                 and a.aqpb175subpr = ln_subr
                 and a.aqpb175toper = ln_toper
                 and a.aqpb175est = 'S';
            exception
              when others then
                null;
            end;
          
          end if;
        
        end if;
      end if;
    else
      if ln_modt > 500 then
      
        begin
        
          select f.pgfape into ld_fchSist from fst017 f where f.pgcod = 1;
        exception
          when others then
            null;
        end;
      
        begin
          select to_number(Txtext)
            into ln_NroRel
            from FSX015
           Where PgCod = ln_pgcodt
             and Hcmod = ln_modt
             and Hsucor = ln_suct
             and Htran = ln_ttran
             and Hnrel = ln_relt
             and Hfcon = ld_fchSist
             and Txcod = 0
             and Txreng = 1;
        exception
          when others then
            null;
        end;
      
        ModAnu := ln_modt - 500;
      
        begin
          select f.ctnro, f.itoper, f.modulo, f.ittope
            into ln_cta, ln_ope, ln_mod, ln_tope
            from fsd016 f
           where f.pgcod = ln_pgcodt
             and f.itsuc = ln_suct
             and f.itmod = ModAnu
             and f.ittran = ln_ttran
             and f.itnrel = ln_NroRel
             and f.itord = 10;
        exception
          when others then
            null;
        end;
      
        if ln_mod = 101 and ln_tope = 360 then
          begin
            select f.pepais, f.petdoc, f.pendoc
              into ln_pais, ln_tdoc, lc_ndoc
              from fsr008 f
             where f.pgcod = 1
               and f.ctnro = ln_cta
               and f.cttfir = 'T';
          exception
            when others then
              null;
          end;
        
          begin
            select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
          exception
            when others then
              null;
          end;
        
          begin
            select a.aqpc363inst
              into ln_InstDesemb
              from aqpc363 a
             where a.aqpc363pais = ln_pais
               and a.aqpc363tdoc = ln_tdoc
               and a.aqpc363ndoc = RPAD(lc_ndoc, 12, ' ')
               and a.aqpc363cta = ln_cta
               and a.aqpc363est = 'P';
          exception
            when others then
              null;
          end;
        
          begin
            update jaqy800 j
               set j.jaqy800vinc = 'N'
             where j.jaqy800ins = ln_InstDesemb
               and j.jaqy800vinc = 'S';
          end;
        
          lc_Fecha := to_char(ld_fchSist, 'DD/MM/YYYY');
        
          begin
            update aqpc363 a
               set A.AQPC363INST  = null,
                   a.aqpc363pgcod = null,
                   a.aqpc363mod   = null,
                   a.aqpc363suc   = null,
                   a.aqpc363mda   = null,
                   a.aqpc363pap   = null,
                   a.aqpc363cta   = null,
                   a.aqpc363ope   = null,
                   a.aqpc363sbop  = null,
                   a.aqpc363tope  = null,
                   a.AQPC363FDES  = null,
                   a.aqpc363est   = 'S',
                   a.aqpc363uedi  = 'BANTPROD',
                   a.aqpc363fedi  = lc_Fecha,
                   a.aqpc363hedi  = lc_hora
             where a.aqpc363pais = ln_pais
               and a.aqpc363tdoc = ln_tdoc
               and a.aqpc363ndoc = RPAD(lc_ndoc, 12, ' ')
               and a.aqpc363est = 'P';
          exception
            when others then
              null;
          end;
        end if;
      end if;
    end if;
  
  end sp_rte_grabaimpls;
  ----------------------------------------------------
  Procedure sp_validaImpulso(pn_emp in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pc_ind out varchar2) is
  
    --dcastro 24/05/2023 valida si se encuentra en desembolso y es impulso
    ln_instancia number;
    lc_ind       varchar2(1);
    pn_emp117    number;
    pn_mod117    number;
    pn_suc117    number;
    pn_mda117    number;
    pn_pap117    number;
    pn_cta117    number;
    pn_ope117    number;
    pn_sbo117    number;
    pn_top117    number;
  
  begin
  
    pc_ind := 'N';
  
    if pn_mod <> 116 then
    
      begin
        select max(JAQY800INS)
          into ln_instancia
          from jaqy800 j, wfwrkitems k
         where JAQY800PGCD = pn_emp
           and JAQY800MOD = pn_mod
           and JAQY800SUC = pn_suc
           and JAQY800MDA = pn_mda
           and JAQY800PAP = pn_pap
           and JAQY800CTA = pn_cta
           and JAQY800OPE = pn_ope
           and JAQY800SBOP = pn_sbo
           and JAQY800TOPE = pn_top
           and JAQY800VINC = 'S'
           and k.wfinsprcid = j.JAQY800INS
           and k.wfitemstsact = '1';
      exception
        when others then
          ln_instancia := 0;
      end;
    
    else
      if pn_mod = 116 then
      
        begin
          select f.r2cod,
                 f.r2mod,
                 f.r2suc,
                 f.r2mda,
                 f.r2pap,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2tope
            into pn_emp117,
                 pn_mod117,
                 pn_suc117,
                 pn_mda117,
                 pn_pap117,
                 pn_cta117,
                 pn_ope117,
                 pn_sbo117,
                 pn_top117
            from fsr011 f
           where f.r1cod = 1
             and f.r1mod = pn_mod
             and f.r1suc = pn_suc
             and f.r1mda = pn_mda
             and f.r1pap = pn_pap
             and f.r1cta = pn_cta
             and f.r1oper = pn_ope
             and f.r1sbop = pn_sbo
             and f.r1tope = pn_top
             and f.relcod = 46;
        exception
          when others then
            null;
        end;
      
        begin
          select max(JAQY800INS)
            into ln_instancia
            from jaqy800 j, wfwrkitems k
           where JAQY800PGCD = pn_emp117
             and JAQY800MOD = pn_mod117
             and JAQY800SUC = pn_suc117
             and JAQY800MDA = pn_mda117
             and JAQY800PAP = pn_pap117
             and JAQY800CTA = pn_cta117
             and JAQY800OPE = pn_ope117
             and JAQY800SBOP = pn_sbo117
             and JAQY800TOPE = pn_top117
             and JAQY800VINC = 'S'
             and k.wfinsprcid = j.JAQY800INS
             and k.wfitemstsact = '1';
        exception
          when others then
            ln_instancia := 0;
        end;
      
      end if;
    end if;
  
    if ln_instancia <> 0 then
      begin
        pq_cr_ctrlsaldoimplso.sp_cr_endesembolso(ln_instancia => ln_instancia,
                                                 lc_indicador => lc_ind);
      end;
      if lc_ind = 'S' then
        begin
          pq_cr_ctrlsaldoimplso.sp_cr_esimpulso(ln_instancia => ln_instancia,
                                                lc_indicador => lc_ind);
        end;
        pc_ind := lc_ind;
      else
        pc_ind := 'N';
      end if;
    
    end if;
  
  end sp_validaImpulso;
  --------------------------------------------------------------------
  procedure sp_Cr_InsertaAQPB161(ln_pais       in number,
                                 ln_tdoc       in number,
                                 lc_ndoc       in varchar2,
                                 ln_sald       in number,
                                 ln_mncond     in number,
                                 ln_mntadi     in number,
                                 ln_minmnt     in number,
                                 ln_maxmnt     in number,
                                 ln_MaxMntCalc in number,
                                 ln_MntCert    in number,
                                 ln_mcond      in number,
                                 ln_mtcan      in number,
                                 lc_Flag       in varchar2) is
  
    ld_fch  date;
    lc_hora char(8);
    ln_corr number := 0;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb161corr)
        into ln_corr
        from aqpb161 a
       where a.aqpb161pais = ln_pais
         and a.aqpb161tdoc = ln_tdoc
         and a.aqpb161ndoc = lc_ndoc;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select f.pgfape into ld_fch from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb161
        (aqpb161pais,
         aqpb161tdoc,
         aqpb161ndoc,
         aqpb161fch,
         aqpb161hora,
         aqpb161sald,
         aqpb161mncond,
         aqpb161mntadi,
         aqpb161minmnt,
         aqpb161maxmnt,
         aqpb161est,
         aqpb161corr,
         AQPB161MTCALC,
         AQPB161MCERTF,
         aqpb161mcond,
         aqpb161mtcan)
      values
        (ln_pais,
         ln_tdoc,
         lc_ndoc,
         ld_fch,
         lc_hora,
         ln_sald,
         ln_mncond,
         ln_mntadi,
         ln_minmnt,
         ln_maxmnt,
         lc_Flag,
         ln_corr + 1,
         ln_MaxMntCalc,
         ln_MntCert,
         ln_mcond,
         ln_mtcan);
    
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_Cr_InsertaAQPB161;
  -----------------------------------------------------------------
  procedure sp_cr_logTCEA_EnWF(ln_Instancia in number,
                               ln_TCEAMax   in number,
                               ln_TCEAWF    in number) is
    ld_fch  date;
    lc_hora char(8);
    ln_mod  number;
    ln_tipo number;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_fch from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpb161a a
         set a.aqpb161est = 'I'
       where a.aqpb161inst = ln_Instancia;
      commit;
    end;
  
    begin
      select x.xwfmodulo, x.xwftipope
        into ln_mod, ln_tipo
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_mod = 101 and ln_tipo = 360 then
      begin
        insert into aqpb161a
          (aqpb161inst,
           aqpb161fch,
           aqpb161hora,
           aqpb161tceamx,
           aqpb161tceawf,
           aqpb161est)
        values
          (ln_Instancia, ld_fch, lc_hora, ln_TCEAMax, ln_TCEAWF, 'H');
      exception
        when others then
          null;
      end;
      commit;
    end if;
  end;

  -----------------------------------------------------------------
  procedure sp_cr_provision(PN_PGCOD  in number,
                            PN_AOMOD  in number,
                            PN_AOSUC  in number,
                            PN_AOMDA  in number,
                            PN_AOPAP  in number,
                            PN_AOCTA  in number,
                            PN_AOOPER in number,
                            PN_AOSBOP in number,
                            PN_AOTOPE in number,
                            PD_FECHA  in date,
                            pn_saldo  out number,
                            pc_ind    out varchar2) is
  
    ln_covid  number;
    ln_saldo  number;
    ld_finmes date;
  
  begin
    pn_saldo := 0;
    pc_ind   := '';
  
    ld_finmes := add_months(last_day(PD_FECHA), -1);
  
    begin
      select count(*)
        into ln_covid
        from aqpb836 a
       where a.AQPB836TIP like 'COVID%'
         and AQPB836EMP = PN_PGCOD
         and AQPB836MOD = PN_AOMOD
         and AQPB836SUC = PN_AOSUC
         and AQPB836MDA = PN_AOMDA
         and AQPB836PAP = PN_AOPAP
         and AQPB836CTA = PN_AOCTA
         and AQPB836OPER = PN_AOOPER
            --and AQPB836SBOP = PN_AOSBOP
            --and AQPB836TOP = PN_AOTOPE; 
         and AQPB836FECBI in (select max(AQPB836FECBI) from aqpb836 a);
    exception
      when others then
        ln_covid := 0;
    end;
  
    if ln_covid > 0 then
      --es covid
      pc_ind := 'S';
    else
      pc_ind := 'N';
    end if;
  
    begin
      select /*+all_rows*/
       a.bcsdmn
        into ln_saldo
        from FSH012 a
       where a.bcemp = PN_PGCOD
            --and a.BCMOD = PN_AOMOD
         and a.BCSUC = PN_AOSUC
         and a.bcmda = PN_AOMDA
         and a.bcpap = PN_AOPAP
         and a.bccta = PN_AOCTA
         and a.bcoper = PN_AOOPER
            --and a.bcsbop = PN_AOSBOP            
            -- and a.bctop = PN_AOTOPE
         and a.bcfech = ld_finmes
         and a.bcrubr like '14_9__0702%';
    exception
      when others then
        ln_saldo := 0;
    end;
  
    pn_saldo := ln_saldo;
  end;
  -----------------------------------------------------------
  procedure sp_Cr_updateaqpb163(ln_instancia in number) is
  begin
    begin
      update aqpb163 a
         set a.aqpb163est = 'I'
       where a.aqpb163inst = ln_instancia;
    end;
    commit;
  end sp_Cr_updateaqpb163;
  ----------------------------------------------------------------
  procedure sp_Cr_GrabaMntCanc163(ln_inst   in number,
                                  ln_pais   in number,
                                  ln_tdoc   in number,
                                  lc_ndoc   in varchar2,
                                  ln_pgcod  in number,
                                  ln_mod    in number,
                                  ln_suc    in number,
                                  ln_mda    in number,
                                  ln_pap    in number,
                                  ln_cta    in number,
                                  ln_ope    in number,
                                  ln_sbop   in number,
                                  ln_tope   in number,
                                  ln_cap    in number,
                                  ln_int    in number,
                                  ln_mora   in number,
                                  ln_gasot  in number,
                                  ln_icv    in number,
                                  ln_pnalid in number,
                                  ln_cseg   in number,
                                  ln_mcanc  in number) is
    ln_corr    number := 0;
    ld_fec     date;
    lc_hora    varchar2(8) := '00:00:00';
    ln_modu    number;
    ln_tipoper number;
  
  begin
  
    begin
      select x.xwfmodulo, x.xwftipope
        into ln_modu, ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_inst
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_modu = 101 and ln_tipoper = 360 then
    
      begin
        select max(a.aqpb163corr)
          into ln_corr
          from aqpb163 a
         where a.aqpb163inst = ln_inst
           and a.aqpb163fec = ld_fec;
      exception
        when others then
          null;
      end;
    
      ln_corr := nvl(ln_corr, 0);
    
      begin
        select f.pgfape into ld_fec from fst017 f where f.pgcod = 1;
      exception
        when others then
          null;
      end;
    
      begin
        select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
      exception
        when others then
          null;
      end;
    
      begin
        insert into aqpb163
          (aqpb163corr,
           aqpb163inst,
           aqpb163pais,
           aqpb163tdoc,
           aqpb163ndoc,
           aqpb163fec,
           aqpb163hora,
           aqpb163pgcod,
           aqpb163mod,
           aqpb163suc,
           aqpb163mda,
           aqpb163pap,
           aqpb163cta,
           aqpb163ope,
           aqpb163sbop,
           aqpb163tope,
           aqpb163cap,
           aqpb163int,
           aqpb163mora,
           aqpb163gasot,
           aqpb163icv,
           aqpb163pnalid,
           aqpb163cseg,
           aqpb163mcanc,
           aqpb163est)
        values
          (ln_corr + 1,
           ln_inst,
           ln_pais,
           ln_tdoc,
           lc_ndoc,
           ld_fec,
           lc_hora,
           ln_pgcod,
           ln_mod,
           ln_suc,
           ln_mda,
           ln_pap,
           ln_cta,
           ln_ope,
           ln_sbop,
           ln_tope,
           ln_cap,
           ln_int,
           ln_mora,
           ln_gasot,
           ln_icv,
           ln_pnalid,
           ln_cseg,
           ln_mcanc,
           'H');
        /* exception
        when others then
          null;*/
      end;
      commit;
    end if;
  
  end;
  -----------------------------------------------------------------
  procedure sp_cr_MntCancelar(ln_inst in number, ln_mntcanc out number) is
  
    ln_mod     number;
    ln_tipoper number;
  
  begin
    ln_mntcanc := 0;
  
    begin
      select x.xwfmodulo, x.xwftipope
        into ln_mod, ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_inst
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_mod = 101 and ln_tipoper = 360 then
    
      begin
        select sum(a.aqpb163mcanc)
          into ln_mntcanc
          from aqpb163 a
         where a.aqpb163inst = ln_inst
           and a.aqpb163est = 'H';
      exception
        when others then
          ln_mntcanc := 0;
      end;
    
    end if;
  
  end;
  ------------------------------------------------------------------
  procedure sp_Cr_TotalDesembolsado(ln_MntTope   out number,
                                    ln_mntContab out number,
                                    lc_Flag      out varchar2) is
  
  begin
  
    begin
      select f.tp1imp1
        into ln_MntTope
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 120
         and f.tp1corr2 = 2
         and f.tp1corr3 = 1;
    exception
      when others then
        ln_MntTope := 0;
    end;
  
    begin
      select sum(f.scsdo * -1)
        into ln_mntContab
        from fsd011 f
       where f.scrub = '4619000000016'
         and f.pgcod = 1
         and f.scmda = 0
         and f.scpap = 0;
    exception
      when others then
        ln_mntContab := 0.00;
    end;
  
    if ln_mntContab < ln_MntTope then
      lc_Flag := 'S';
    else
      if ln_mntContab >= ln_MntTope then
        lc_Flag := 'N';
      end if;
    end if;
  
  end sp_Cr_TotalDesembolsado;
  ----------------------------------------------------------------
  procedure sp_cr_RteCntrlCondo(ln_pgcodt in number,
                                ln_suct   in number,
                                ln_modt   in number,
                                ln_ttran  in number,
                                ln_relt   in number,
                                ln_ordt   in number,
                                lc_Flag   out varchar2) is
  
    ln_cta           number;
    ln_NroRegCnDscto number := 0;
    ln_MntTope       number := 0;
    ln_mntContab     number := 0;
    ln_pais          number;
    ln_tdoc          number;
    lc_ndoc          varchar2(12);
  
  begin
  
    lc_Flag := 'N';
  
    begin
      update aqpb165 a
         set a.aqpb165est = 'I'
       where a.aqpb165pgcod = ln_pgcodt
         and a.aqpb165suct = ln_suct
         and a.aqpb165modt = ln_modt
         and a.aqpb165ttran = ln_ttran
         and a.aqpb165relt = ln_relt
         and a.aqpb165ordt = ln_ordt;
    end;
  
    begin
      select f.tp1imp1
        into ln_MntTope
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 120
         and f.tp1corr2 = 2
         and f.tp1corr3 = 1;
    exception
      when others then
        ln_MntTope := 0;
    end;
  
    begin
      select sum(f.scsdo * -1)
        into ln_mntContab
        from fsd011 f
       where f.scrub = '4619000000016'
         and f.pgcod = 1
         and f.scmda = 0
         and f.scpap = 0;
    exception
      when others then
        ln_mntContab := 0.00;
    end;
  
    if ln_mntContab < ln_MntTope then
      lc_Flag := 'N';
    else
      if ln_mntContab >= ln_MntTope then
        lc_Flag := 'S';
      end if;
    end if;
  
    begin
      select f.ctnro
        into ln_cta
        from fsd016 f
       where f.pgcod = ln_pgcodt
         and f.itsuc = ln_suct
         and f.itmod = ln_modt
         and f.ittran = ln_ttran
         and f.itnrel = ln_relt
         and f.itord = ln_ordt;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tdoc, lc_ndoc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_cta
         and f.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    if lc_Flag = 'S' then
    
      begin
        select count(*)
          into ln_NroRegCnDscto
          from aqpc589 a, fsr008 f
         where a.aqpc589pais = f.pepais
           and a.aqpc589ptdc = f.petdoc
           and a.aqpc589dni = f.pendoc
           and a.aqpc589estpro = 'A'
           and a.aqpc589esthab = 'H'
           and f.pgcod = 1
           and f.ctnro = ln_cta
           and f.cttfir = 'T'
           and a.aqpc589pdesc > 0;
      exception
        when others then
          ln_NroRegCnDscto := 0;
      end;
    
      if ln_NroRegCnDscto = 0 then
        lc_Flag := 'N'; -- Permite continuar
      else
        lc_Flag := 'S'; -- Bloquea la tx ya que hay registros con % de dscto y ya se llego al tope maximo
      end if;
    
    end if;
  
    begin
      pq_cr_ctrlsaldoimplso.sp_cr_logAQPB165(ln_pgcod   => ln_pgcodt,
                                             ln_suct    => ln_suct,
                                             ln_modt    => ln_modt,
                                             ln_ttran   => ln_ttran,
                                             ln_relt    => ln_relt,
                                             ln_ordt    => ln_ordt,
                                             ln_mntope  => ln_MntTope,
                                             ln_mntacum => ln_mntContab,
                                             ln_cta     => ln_cta,
                                             ln_pais    => ln_pais,
                                             ln_tdoc    => ln_tdoc,
                                             lc_ndoc    => lc_ndoc,
                                             ln_credcd  => ln_NroRegCnDscto,
                                             lc_bloq    => lc_Flag);
    
    end;
  
  end sp_cr_RteCntrlCondo;
  ------------------------------------------------------------------------
  procedure sp_cr_logAQPB165(ln_pgcod   in number,
                             ln_suct    in number,
                             ln_modt    in number,
                             ln_ttran   in number,
                             ln_relt    in number,
                             ln_ordt    in number,
                             ln_mntope  in number,
                             ln_mntacum in number,
                             ln_cta     in number,
                             ln_pais    in number,
                             ln_tdoc    in number,
                             lc_ndoc    in varchar2,
                             ln_credcd  in number,
                             lc_bloq    in varchar2) is
  
    ld_fec  date;
    ln_corr number := 0;
    lc_hora varchar2(8) := '00:00:00';
  
  begin
  
    begin
      select f.pgfape into ld_fec from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb165corr)
        into ln_corr
        from aqpb165 a
       where a.aqpb165fec = ld_fec;
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
  
    begin
    
      insert into aqpb165
        (aqpb165corr,
         aqpb165pgcod,
         aqpb165suct,
         aqpb165modt,
         aqpb165ttran,
         aqpb165relt,
         aqpb165ordt,
         aqpb165fec,
         aqpb165hora,
         aqpb165mntope,
         aqpb165mntacum,
         aqpb165cta,
         aqpb165pais,
         aqpb165tdoc,
         aqpb165ndoc,
         aqpb165credcd,
         aqpb165bloq,
         aqpb165est)
      values
        (ln_corr + 1,
         ln_pgcod,
         ln_suct,
         ln_modt,
         ln_ttran,
         ln_relt,
         ln_ordt,
         ld_fec,
         lc_hora,
         ln_mntope,
         ln_mntacum,
         ln_cta,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_credcd,
         lc_bloq,
         'H');
    end;
  
  end;
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure sp_cr_TEAExcpcn(ln_instancia in number, ln_TEA out number) is
  
    ln_pais number;
    ln_tdoc number;
    lc_ndoc varchar2(12);
  
  begin
  
    ln_TEA := 0;
  
    begin
      select TP1IMP1
        into ln_TEA
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 11161
         and TP1CORR1 = 70
         and TP1NRO1 = ln_instancia;
    exception
      when others then
        ln_TEA := 0;
    end;
  
    if ln_TEA = 0 then
    
      begin
        select s.sng001pais, s.sng001tdoc, s.sng001ndoc
          into ln_pais, ln_tdoc, lc_ndoc
          from sng001 s
         where s.sng001inst = ln_Instancia;
      exception
        when others then
          null;
      end;
    
      begin
        select a.aqpc363tcea
          into ln_TEA
          from aqpc363 a
         where a.aqpc363pais = ln_pais
           and a.aqpc363tdoc = ln_tdoc
           and a.aqpc363ndoc = rpad(lc_ndoc, 12, ' ')
           and a.aqpc363est = 'S';
      exception
        when others then
          ln_TEA := 0;
      end;
    end if;
  
    ln_TEA := nvl(ln_TEA, 0);
  
  end sp_cr_TEAExcpcn;
  -----------------------------------------------------------------
end pq_cr_CtrlSaldoImplso;
/

