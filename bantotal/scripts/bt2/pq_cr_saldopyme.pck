create or replace package PQ_CR_SALDOPYME is

  /* ************************************************************************************************************
      -- Nombre                     : Ratio Endeudamiento Patrimonio Resolutor Politica Saldo Pyme
      -- Sistema                    : BANTOTAL
      -- Versión                    : 1.0
      -- Fecha de Creación          : 01/08/2017
      -- Autor de Creación          : Maria Caridad Postigo Condori
      -- Versión                    : 2.0
      -- Fecha de Modificación      : 18/06/2019
      -- Autor de la Modificación   : Maria Caridad Postigo Condori
      -- Descripción de Modificación: Se creo un nuevo procedimiento sp_cuentasPasivoII
      --                              que extrae los pasivos corriente y no corriente solo de creditos vigentes
      -- Versión                    : 3.0
      -- Fecha de Modificación      : 29/11/2023
      -- Autor de la Modificación   : Maria Caridad Postigo Condori
      -- Descripción de Modificación: se modifico apra grabar log de ejecuciones por tarea y permite procesar por etapas guardando log
      --
  * *************************************************************************************************************/

  procedure sp_cuentas(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       tipocambio    in number,
                       Instancia     in number,
                       pd_fecpro     in date,
                       lc_prgm       IN VARCHAR2,
                       ln_captotcaja out number);
  -------------------------------------------------------
  procedure sp_cr_ValoresRatio(ln_Instancia    in number,
                               ln_captotcaja   out number,
                               ln_Patrimonio   out number,
                               ln_SaldExt      out number,
                               ln_RatioEndPatr out number);
  --------------------------------------------------------
  procedure sp_cuentasRatio(ln_Pepais     in number,
                            ln_Petdoc     in number,
                            ln_Pendoc     in char,
                            tipocambio    in number,
                            Instancia     in number,
                            pd_fecpro     in date,
                            lc_prgm       IN VARCHAR2,
                            ln_captotcaja out number);
  -------------------------------------------------------
  procedure sp_cr_DeudaIFIS(Instancia in number, saldo_externo out number);
  -------------------------------------------------------
  procedure sp_cuentasPasivo(ln_Pepais          in number,
                             ln_Petdoc          in number,
                             ln_Pendoc          in char,
                             Instancia          in number,
                             ln_PasivoCorrSol   out number,
                             ln_PasivoCorrDol   out number,
                             ln_PasivoNoCorrSol out number,
                             ln_PasivoNoCorrDol out number);
  -----------------------------------------------------------
  procedure sp_cuentasPasivoII(ln_Pepais          in number,
                               ln_Petdoc          in number,
                               ln_Pendoc          in char,
                               Instancia          in number,
                               ln_PasivoCorrSol   out number,
                               ln_PasivoCorrDol   out number,
                               ln_PasivoNoCorrSol out number,
                               ln_PasivoNoCorrDol out number);
  ------------------------------------------------------
  procedure sp_cr_saldocapital(ln_pgcod10  in number,
                               ln_mod10    in number,
                               ln_suc10    in number,
                               ln_mda10    in number,
                               ln_pap10    in number,
                               ln_cta10    in number,
                               ln_oper10   in number,
                               ln_sbop     in number,
                               ln_tope10   in number,
                               tipocambio  in number,
                               Instancia   in number,
                               ln_saldocap out number);

  -----------------------------------------------------

  procedure sp_cr_saldocapitalref(tipocambio  in number,
                                  Instancia   in number,
                                  ln_saldocap out number);
  --------------------------------------------------
  procedure sp_cr_SaldCapPasivo(ln_pgcod10    in number,
                                ln_mod10      in number,
                                ln_suc10      in number,
                                ln_mda10      in number,
                                ln_pap10      in number,
                                ln_cta10      in number,
                                ln_oper10     in number,
                                ln_sbop       in number,
                                ln_tope10     in number,
                                Instancia     in number,
                                ln_MontSolAux out number,
                                ln_MontDolAux out number);

  -----------------------------------------------------------
  procedure sp_cr_SaldCapRefPas(Instancia     in number,
                                ln_MontSolAux out number,
                                ln_MontDolAux out number);

  -----------------------------------------------------
  procedure sp_resolutor(ln_Pepais   in number,
                         ln_Petdoc   in number,
                         ln_Pendoc   in char,
                         tipocambio  in number,
                         Instancia   in number,
                         pd_fecpro   in date,
                         ln_pgcod10  in number,
                         ln_mod10    in number,
                         ln_suc10    in number,
                         ln_mda10    in number,
                         ln_pap10    in number,
                         ln_cta10    in number,
                         ln_oper10   in number,
                         ln_sbop     in number,
                         ln_tope10   in number,
                         lc_fgRefLin in varchar2,
                         lc_IndCred  in varchar2,
                         lc_flgprg   in varchar2,
                         ln_tarea    in number,
                         ln_saldocap out number);
  -------------------------------------------------------------
  procedure sp_resolutorvuelo(ln_Pepais    in number,
                              ln_Petdoc    in number,
                              ln_Pendoc    in char,
                              tipocambio   in number,
                              Instancia    in number,
                              pd_fecpro    in date,
                              ln_InstVerif in number,
                              ln_pgcod10   in number,
                              ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop      in number,
                              ln_tope10    in number,
                              lc_fgRefLin  in varchar2,
                              lc_IndCred   in varchar2,
                              lc_flgprg    in varchar2,
                              ln_tarea     in number,
                              ln_saldocap  out number);
  --------------------------------------------------------
  procedure sp_resolutorPasivo(ln_Pepais   in number,
                               ln_Petdoc   in number,
                               ln_Pendoc   in char,
                               Instancia   in number,
                               pd_fecpro   in date,
                               ln_pgcod10  in number,
                               ln_mod10    in number,
                               ln_suc10    in number,
                               ln_mda10    in number,
                               ln_pap10    in number,
                               ln_cta10    in number,
                               ln_oper10   in number,
                               ln_sbop     in number,
                               ln_tope10   in number,
                               lc_fgRefLin in varchar2,
                               lc_IndCred  in varchar2,
                               --lc_flgprg     in varchar2,
                               ld_FchVenc    in date,
                               ld_FchCorte   in date,
                               ln_MontSolAux out number,
                               ln_MontDolAux out number);
  ------------------------------------------------------------
  procedure sp_resolutorvueloPasivo(ln_Pepais in number,
                                    ln_Petdoc in number,
                                    ln_Pendoc in char,
                                    
                                    Instancia     in number,
                                    pd_fecpro     in date,
                                    ln_InstVerif  in number,
                                    ln_pgcod10    in number,
                                    ln_mod10      in number,
                                    ln_suc10      in number,
                                    ln_mda10      in number,
                                    ln_pap10      in number,
                                    ln_cta10      in number,
                                    ln_oper10     in number,
                                    ln_sbop       in number,
                                    ln_tope10     in number,
                                    lc_fgRefLin   in varchar2,
                                    lc_IndCred    in varchar2,
                                    ld_FchVenc    in date,
                                    ld_FchCorte   in date,
                                    ln_MontSolAux out number,
                                    ln_MontDolAux out number);
  -----------------------------------------------------------
  procedure sp_resolutor_vencPasivo(ln_Pepais     in number,
                                    ln_Petdoc     in number,
                                    ln_Pendoc     in char,
                                    Instancia     in number,
                                    pd_fecpro     in date,
                                    ln_pgcod10    in number,
                                    ln_mod10      in number,
                                    ln_suc10      in number,
                                    ln_mda10      in number,
                                    ln_pap10      in number,
                                    ln_cta10      in number,
                                    ln_oper10     in number,
                                    ln_sbop10     in number,
                                    ln_tope10     in number,
                                    lc_IndCred    in varchar2,
                                    lc_flgprg     in varchar2,
                                    ld_FchVenc    in date,
                                    ld_FchCorte   in date,
                                    ln_MontSolAux out number,
                                    ln_MontDolAux out number);
  ----------------------------------------------------------
  --mod 2016.04.13
  Procedure Sp_Adicional_CK(pn_top in number, Pc_flag out varchar2);
  ----------------------------------------------------------
  --mod 2016.04.13
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2);
  ------------------------------------------------------------
  procedure sp_cr_Reprogramados(ln_emp10   in number,
                                ln_mod10   in number,
                                ln_suc10   in number,
                                ln_mda10   in number,
                                ln_pap10   in number,
                                ln_cta10   in number,
                                ln_oper10  in number,
                                ln_sbop10  in number,
                                ln_tope10  in number,
                                lc_fgRepro out varchar2);

  ---------------------------------------------------------------
  procedure sp_resolutor_venc(ln_Pepais    in number,
                              ln_Petdoc    in number,
                              ln_Pendoc    in char,
                              tipocambio   in number,
                              Instancia    in number,
                              pd_fecpro    in date,
                              ln_pgcod10   in number,
                              ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop10    in number,
                              ln_tope10    in number,
                              lc_IndCred   in varchar2,
                              lc_flgprg    in varchar2,
                              ln_tarea     in number,
                              ln_capacidad out number);

  --------------------------------------------------
  procedure sp_refinanLinea(ln_pgcod10  in number,
                            ln_mod10    in number,
                            ln_suc10    in number,
                            ln_mda10    in number,
                            ln_pap10    in number,
                            ln_cta10    in number,
                            ln_oper10   in number,
                            lc_fgRefLin out varchar2);
  ------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais     in number,
                           ln_Petdoc     in number,
                           ln_Pendoc     in char,
                           tipocambio    in number,
                           Instancia     in number,
                           pd_fecpro     in date,
                           ln_captotcaja in number,
                           Patrimonio    in number,
                           SaldExter     in number,
                           CapTotal      in number,
                           lc_indicador  in varchar2,
                           lc_flgprg     in varchar2,
                           ln_tarea      in number);
  -----------------------------------------------------
  procedure sp_cr_LogCuentas(lnPepais   in number,
                             lnPetdoc   in number,
                             lnPendoc   in char,
                             tipocambio in number,
                             Instancia  in number,
                             pd_fecpro  in date,
                             ln_PGCOD   in number,
                             ln_MOD     in number,
                             ln_SUC     in number,
                             ln_MDA     in number,
                             ln_PAP     in number,
                             ln_CTA     in number,
                             ln_OPE     in number,
                             ln_SBOP    in number,
                             ln_TOPE    in number,
                             ln_SALDCAP in number,
                             lc_IndCred IN VARCHAR2,
                             lc_flgprg  in varchar2,
                             ln_tarea   in number);
  ----------------------------------------------------------------
  procedure sp_cr_LogPasivo(ln_Pepais in number,
                            ln_Petdoc in number,
                            ln_Pendoc in char,
                            
                            Instancia          in number,
                            pd_fecpro          in date,
                            ln_PasivoNoCorrSol in number,
                            ln_PasivoNoCorrDol in number,
                            ln_PasivoCorrSol   in number,
                            ln_PasivoCorrDol   in number,
                            lc_indicador       in varchar2);
  -------------------------------------------------------------
  procedure sp_cr_LogCtaPasivo(lnPepais in number,
                               lnPetdoc in number,
                               lnPendoc in char,
                               
                               Instancia    in number,
                               pd_fecpro    in date,
                               ln_PGCOD     in number,
                               ln_MOD       in number,
                               ln_SUC       in number,
                               ln_MDA       in number,
                               ln_PAP       in number,
                               ln_CTA       in number,
                               ln_OPE       in number,
                               ln_SBOP      in number,
                               ln_TOPE      in number,
                               ln_SALDCAP   in number,
                               ld_FchVenc   in date,
                               lc_IndCred   IN VARCHAR2,
                               lc_IndPasivo in varchar2);

end PQ_CR_SALDOPYME;
/
create or replace package body PQ_CR_SALDOPYME is

  /* ************************************************************************************************************
      -- Nombre                     : Ratio Endeudamiento Patrimonio Resolutor Politica Saldo Pyme
      -- Sistema                    : BANTOTAL
      -- Versión                    : 1.0
      -- Fecha de Creación          : 01/08/2017
      -- Autor de Creación          : Maria Caridad Postigo Condori
      -- Versión                    : 2.0
      -- Fecha de Modificación      : 18/06/2019
      -- Autor de la Modificación   : Maria Caridad Postigo Condori
      -- Descripción de Modificación: Se creo un nuevo procedimiento sp_cuentasPasivoII
      --                              que extrae los pasivos corriente y no corriente solo de creditos vigentes
      -- Versión                    : 3.0
      -- Fecha de Modificación      : 29/11/2023
      -- Autor de la Modificación   : Maria Caridad Postigo Condori
      -- Descripción de Modificación: se modifico apra grabar log de ejecuciones por tarea y permite procesar por etapas guardando log
      --
  * *************************************************************************************************************/

  procedure sp_cuentas(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       tipocambio    in number,
                       Instancia     in number,
                       pd_fecpro     in date,
                       lc_prgm       IN VARCHAR2,
                       ln_captotcaja out number) is
  
    ln_PasivoCorrSol   number;
    ln_PasivoCorrDol   number;
    ln_PasivoNoCorrSol number;
    ln_PasivoNoCorrDol number;
  
  begin
  
    if lc_prgm = 'PASIVO' then
      pq_cr_saldopyme.sp_cuentasPasivo(ln_Pepais,
                                       ln_Petdoc,
                                       ln_Pendoc,
                                       
                                       Instancia,
                                       ln_PasivoCorrSol,
                                       ln_PasivoCorrDol,
                                       ln_PasivoNoCorrSol,
                                       ln_PasivoNoCorrDol);
    
    else
      if lc_prgm <> 'PASIVO' then
      
        Pq_Cr_Saldopyme.sp_cuentasRatio(ln_Pepais,
                                        ln_Petdoc,
                                        ln_Pendoc,
                                        tipocambio,
                                        Instancia,
                                        pd_fecpro,
                                        lc_prgm,
                                        ln_captotcaja);
      
      end if;
    end if;
  
  end sp_cuentas;
  ---------------------------------------------------------------------------------
  procedure sp_cr_ValoresRatio(ln_Instancia    in number,
                               ln_captotcaja   out number,
                               ln_Patrimonio   out number,
                               ln_SaldExt      out number,
                               ln_RatioEndPatr out number) is
  begin
    begin
      select j.jaqy147saldpyme,
             j.jaqy147patrim,
             j.jaqy147sldext,
             j.jaqy147ratio
        into ln_captotcaja, ln_Patrimonio, ln_SaldExt, ln_RatioEndPatr
        from jaqy147 j
       where j.jaqy147inst = ln_Instancia
         and j.jaqy147tarea = 7
         and j.jaqy147est = 'H';
    exception
      when others then
        null;
    end;
  end sp_cr_ValoresRatio;
  ----------------------------------------------------------------------------------
  procedure sp_cuentasRatio(ln_Pepais     in number,
                            ln_Petdoc     in number,
                            ln_Pendoc     in char,
                            tipocambio    in number,
                            Instancia     in number,
                            pd_fecpro     in date,
                            lc_prgm       IN VARCHAR2,
                            ln_captotcaja out number) is
  
    ln_capacidad number;
    lc_fgAdic    varchar2(1);
    lc_fgAmpl    varchar2(1);
    lc_ven       char(1);
    ln_indicador number;
    lc_fgRefLin  varchar2(1) := 'N';
    lc_fgRepro   varchar2(2);
    lc_FlgLn     varchar2(2);
    Patrimonio   number(17, 2);
    evaluacion   number(17, 2);
    mntsoles     number(17, 2);
    mntdolar     number(17, 2);
    --saldo_extSoles NUMBER(10, 2);
    --saldo_extDol   number(10, 2);
    saldo_externo number(17, 2);
    ln_cajaext    number(17, 2);
    ln_captotal1  number(10, 6);
    ln_captotal   number(10, 6);
  
    cursor inserta is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or d10.Aomod in (141))
         and d10.Aostat <> 99
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or b.Aomod in (141))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor linea is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and d10.Aomod = 117
         and d10.Aostat <> 99
         and d10.aofvto > pd_fecpro
      
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.Aomod in (117)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto > pd_fecpro;
  
    cursor vuelo is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             x.xwfprcins /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       max(s.sng120per) ln_peri10*/
        from xwf700 x /*, sng120 s*/
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc)
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or
             x.xwfmodulo in (117, 141))
            
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                 and wf.wfitemstsact = 1
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
            --and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope,
                x.xwfprcins
      union
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             x.xwfprcins /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       max(s.sng120per) ln_peri10*/
        from xwf700 x /*, sng120 s,*/, fsr002 c, fsr008 a
      
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and x.xwfempresa = 1
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or
             x.xwfmodulo in (117, 141))
            
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                            -- and wftaskcod <> 55
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    -- and wftaskcod <> 55
                 and wf.wfitemstsact = 1
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
            -- and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope,
                x.xwfprcins;
  
    cursor lineas_ven is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro
      --and Aostat = 99
      
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
            --and b.aostat = 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred      varchar2(12);
    lc_flgprg       varchar2(2);
    ln_NroSolCred   number := 0;
    ln_NroEval      number := 0;
    lc_TieneInfoPSD varchar2(2) := 'S';
    lc_VerfEval     varchar2(2) := 'S';
    ln_tarea        number;
  
  begin
  
    ln_captotcaja := 0;
  
    begin
      select w.wftaskcod
        into ln_tarea
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        ln_tarea := 0;
    end;
  
    begin
      select 'S'
        into lc_flgprg
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 13
         and f.tp1corr2 = 5
         and f.tp1nro3 = ln_tarea
         and trim(f.tp1desc) = trim(lc_prgm);
    exception
      when others then
        lc_flgprg := 'N';
    end;
  
    if lc_prgm = 'RJAQY843' then
    
      lc_flgprg := 'R';
    
      begin
        delete JAQY147 J
         WHERE J.JAQY147INST = Instancia
           and j.jaqy147est = 'R';
      end;
      begin
        delete JAQY148 J
         WHERE J.JAQY148INST = Instancia
           and j.jaqy148est = 'R';
      end;
    
    end if;
  
    if lc_flgprg = 'S' then
    
      update jaqy147 j
         set j.jaqy147est = 'I'
       where j.jaqy147inst = Instancia
         and j.jaqy147tarea = ln_tarea
         and j.jaqy147est = 'H';
    
      UPDATE JAQY148 j
         set j.JAQY148est = 'I'
       where j.JAQY148inst = Instancia
         and j.jaqy148tarea = ln_tarea
         and j.JAQY148est = 'H';
      commit;
    
    end if;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigente';
    
      PQ_CR_SALDOPYME.sp_refinanLinea(i.ln_pgcod10,
                                      i.ln_mod10,
                                      i.ln_suc10,
                                      i.ln_mda10,
                                      i.ln_pap10,
                                      i.ln_cta10,
                                      i.ln_oper10,
                                      lc_fgRefLin);
    
      PQ_CR_SALDOPYME.Sp_ampliados_CK(i.ln_pgcod10,
                                      i.ln_mod10,
                                      i.ln_suc10,
                                      i.ln_mda10,
                                      i.ln_pap10,
                                      i.ln_cta10,
                                      i.ln_oper10,
                                      i.ln_sbop10,
                                      i.ln_tope10,
                                      lc_fgAmpl);
    
      PQ_CR_SALDOPYME.sp_cr_Reprogramados(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          lc_fgRepro);
    
      PQ_CR_RESOLUTOR_CAPPAGO.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
    
      /* begin
          --PRY1509
          select 'S'
            into lc_FlgLn
            from jaqy800
           where JAQY800PGCD = 1
             and JAQY800MOD = i.ln_mod10
             and JAQY800SUC = i.ln_suc10
             and JAQY800MDA = i.ln_mda10
             and JAQY800PAP = i.ln_pap10
             and JAQY800CTA = i.ln_cta10
             and JAQY800OPE = i.ln_oper10
             and JAQY800SBOP = i.ln_sbop10
             and JAQY800TOPE = i.ln_tope10
             and jaqy800vinc = 'S'
             and rownum = 1;
        exception
          when others then
            lc_FlgLn := 'N';
        end;
      */
      if lc_fgRefLin <> 'S' and lc_fgAmpl <> 'S' AND lc_fgRepro <> 'S' and
         lc_FlgLn <> 'S' then
        PQ_CR_SALDOPYME.sp_resolutor(ln_Pepais,
                                     ln_Petdoc,
                                     ln_Pendoc,
                                     tipocambio,
                                     Instancia,
                                     pd_fecpro,
                                     i.ln_pgcod10,
                                     i.ln_mod10,
                                     i.ln_suc10,
                                     i.ln_mda10,
                                     i.ln_pap10,
                                     i.ln_cta10,
                                     i.ln_oper10,
                                     i.ln_sbop10,
                                     i.ln_tope10,
                                     lc_fgRefLin,
                                     lc_IndCred,
                                     lc_flgprg,
                                     ln_tarea,
                                     ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for l in linea loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredLinea';
    
      PQ_CR_SALDOPYME.sp_refinanLinea(l.ln_pgcod10,
                                      l.ln_mod10,
                                      l.ln_suc10,
                                      l.ln_mda10,
                                      l.ln_pap10,
                                      l.ln_cta10,
                                      l.ln_oper10,
                                      lc_fgRefLin);
      --  if l.ln_mod10 = 117 then -- PRY1509
      -- Ampliacion de Lineas  16.08.17 mpostigoc
      /* begin
          select 'S'
            into lc_FlgLn
            from jaqy800
           where JAQY800PGCD = 1
             and JAQY800MOD = l.ln_mod10
             and JAQY800SUC = l.ln_suc10
             and JAQY800MDA = l.ln_mda10
             and JAQY800PAP = l.ln_pap10
             and JAQY800CTA = l.ln_cta10
             and JAQY800OPE = l.ln_oper10
             and JAQY800SBOP = l.ln_sbop10
             and JAQY800TOPE = l.ln_tope10
             and jaqy800vinc = 'S'
             and rownum = 1;
        exception
          when others then
            lc_FlgLn := 'N';
        end;
        --   end if;
      */
    
      PQ_CR_RESOLUTOR_CAPPAGO.sp_cr_VerVincLinea(l.ln_mod10,
                                                 l.ln_suc10,
                                                 l.ln_mda10,
                                                 l.ln_pap10,
                                                 l.ln_cta10,
                                                 l.ln_oper10,
                                                 l.ln_sbop10,
                                                 l.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
      
        PQ_CR_SALDOPYME.sp_resolutor(ln_Pepais,
                                     ln_Petdoc,
                                     ln_Pendoc,
                                     tipocambio,
                                     Instancia,
                                     pd_fecpro,
                                     l.ln_pgcod10,
                                     l.ln_mod10,
                                     l.ln_suc10,
                                     l.ln_mda10,
                                     l.ln_pap10,
                                     l.ln_cta10,
                                     l.ln_oper10,
                                     l.ln_sbop10,
                                     l.ln_tope10,
                                     lc_fgRefLin,
                                     lc_IndCred,
                                     lc_flgprg,
                                     ln_tarea,
                                     ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_IndCred   := 'CredEnVuelo';
      PQ_CR_SALDOPYME.sp_resolutorvuelo(ln_Pepais,
                                        ln_Petdoc,
                                        ln_Pendoc,
                                        tipocambio,
                                        Instancia,
                                        pd_fecpro,
                                        c.xwfprcins,
                                        c.ln_pgcod10,
                                        c.ln_mod10,
                                        c.ln_suc10,
                                        c.ln_mda10,
                                        c.ln_pap10,
                                        c.ln_cta10,
                                        c.ln_oper10,
                                        c.ln_sbop10,
                                        c.ln_tope10,
                                        lc_fgRefLin,
                                        lc_IndCred,
                                        lc_flgprg,
                                        ln_tarea,
                                        ln_capacidad);
    
      ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven loop
    
      lc_IndCred   := 'LineaVencd';
      ln_indicador := 3;
      begin
        select 'S'
          into lc_ven
          from fsr011 a, fsd010 b
         where a.r2cod = j.ln_pgcod10
           and a.r2mod = j.ln_mod10
           and a.r2suc = j.ln_suc10
           and a.r2mda = j.ln_mda10
           and a.r2pap = j.ln_pap10
           and a.r2cta = j.ln_cta10
           and a.r2oper = j.ln_oper10
           and a.r2sbop = j.ln_sbop10
           and a.r2tope = j.ln_tope10
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99
           and relcod = 46
           and rownum = 1;
      exception
        when no_data_found then
          lc_ven := 'N';
      end;
    
      lc_fgAdic := null;
    
      PQ_CR_SALDOPYME.sp_refinanLinea(j.ln_pgcod10,
                                      j.ln_mod10,
                                      j.ln_suc10,
                                      j.ln_mda10,
                                      j.ln_pap10,
                                      j.ln_cta10,
                                      j.ln_oper10,
                                      lc_fgRefLin);
    
      --    if j.ln_mod10 = 117 then --PRY1509
      -- Ampliacion de Lineas  06/09/17 mpostigoc
      /* begin
        select 'S'
          into lc_FlgLn
          from jaqy800
         where JAQY800PGCD = 1
           and JAQY800MOD = j.ln_mod10
           and JAQY800SUC = j.ln_suc10
           and JAQY800MDA = j.ln_mda10
           and JAQY800PAP = j.ln_pap10
           and JAQY800CTA = j.ln_cta10
           and JAQY800OPE = j.ln_oper10
           and JAQY800SBOP = j.ln_sbop10
           and JAQY800TOPE = j.ln_tope10
           and jaqy800vinc = 'S'
           and rownum = 1;
      exception
        when others then
          lc_FlgLn := 'N';
      end;
      --     end if;
      */
    
      PQ_CR_RESOLUTOR_CAPPAGO.sp_cr_VerVincLinea(j.ln_mod10,
                                                 j.ln_suc10,
                                                 j.ln_mda10,
                                                 j.ln_pap10,
                                                 j.ln_cta10,
                                                 j.ln_oper10,
                                                 j.ln_sbop10,
                                                 j.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_ven = 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        PQ_CR_SALDOPYME.sp_resolutor_venc(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          tipocambio,
                                          Instancia,
                                          pd_fecpro,
                                          j.ln_pgcod10,
                                          j.ln_mod10,
                                          j.ln_suc10,
                                          j.ln_mda10,
                                          j.ln_pap10,
                                          j.ln_cta10,
                                          j.ln_oper10,
                                          j.ln_sbop10,
                                          j.ln_tope10,
                                          lc_IndCred,
                                          lc_flgprg,
                                          ln_tarea,
                                          ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    --- Patrimonio
    begin
    
      begin
        select a.sng021eval
          into evaluacion
          from sng021 a
         where a.sng021sol = Instancia;
      exception
        when others then
          null;
      end;
    
      begin
        select a.sng023mto
          into mntsoles
          from sng023 a
         where a.sng021eval = evaluacion
           and a.sng026cod = 70;
      exception
        when others then
          null;
      end;
    
      begin
        select a.sng023mto
          into mntdolar
          from sng023 a
         where a.sng021eval = evaluacion
           and a.sng026cod = 570;
      exception
        when others then
          null;
      end;
    
      Patrimonio := ((mntdolar * tipocambio) + mntsoles);
      Patrimonio := nvl(Patrimonio, 0);
    
    end; --- Fin Patrimonio
  
    -- Saldo Externo
    -- DEUDA IFIS 19/11/2019 MPOSTIGOC
    pq_cr_mantiene_eval.sp_cr_verifPSD(Instancia, lc_TieneInfoPSD);
    pq_cr_mantiene_eval.sp_cr_verifEval(Instancia, lc_VerfEval);
  
    if lc_TieneInfoPSD = 'S' then
    
      Pq_Cr_Saldopyme.sp_cr_DeudaIFIS(Instancia, saldo_externo);
    else
      if lc_TieneInfoPSD = 'N' and lc_VerfEval = 'S' then
        PQ_Cr_mantiene_eval.sp_Cr_VerfUltEvaluacion(Instancia,
                                                    ln_NroSolCred,
                                                    ln_NroEval);
        if ln_NroSolCred > 0 and ln_NroEval > 0 then
          Pq_Cr_Saldopyme.sp_cr_DeudaIFIS(ln_NroSolCred, saldo_externo);
        
        end if;
      end if;
    end if;
  
    saldo_externo := nvl(saldo_externo, 0);
  
    begin
      -- Suma de Deuda Caja y Deuda Externa
    
      ln_cajaext := nvl(ln_captotcaja, 0) + nvl(saldo_externo, 0);
    end; -- Fin Saldo Externo
  
    -- Calculo Ratio
    if Patrimonio <> 0 then
      ln_captotal1 := nvl(ln_cajaext, 0) / Patrimonio;
    else
      ln_captotal1 := 0;
    end if;
  
    ln_captotal := nvl(ln_captotal1, 0);
  
    if lc_flgprg = 'S' or lc_flgprg = 'R' then
    
      pq_cr_saldopyme.sp_cr_LogRatio(ln_Pepais,
                                     ln_Petdoc,
                                     ln_Pendoc,
                                     tipocambio,
                                     Instancia,
                                     pd_fecpro,
                                     ln_captotcaja,
                                     Patrimonio,
                                     saldo_externo,
                                     ln_captotal,
                                     'SP',
                                     lc_flgprg,
                                     ln_tarea);
    end if;
  
  end sp_cuentasRatio;
  -----------------------------------------------------------------
  procedure sp_cr_DeudaIFIS(Instancia in number, saldo_externo out number) is
  
    saldo_extSoles number(17, 2) := 0.00;
  
  begin
    begin
      --MPOSTIGOC 09/10/18 INC1373
      -- actualizamos todos los valores que se tienen para la tarea de Evaluacion/Propuesta
      update jaqy327 j
         set j.jaqy327aux3 = ''
       where j.jaqy327inst = Instancia
         and j.jaqy327aux1 = 7; --Tarea de Evaluacion Propuesta
      commit;
    end;
  
    begin
      --MPOSTIGOC 04/10/18 INC1373
      -- actualizamos los ultimos valores que se tienen para la tarea de Evaluacion/Propuesta contabilizados
      -- con una marca en R
      update jaqy327 j
         set j.jaqy327aux3 = 'R'
       where j.jaqy327inst = Instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327chek = '1'
         and j.jaqy327aux1 = 7; --Tarea de Evaluacion Propuesta
      commit;
    end;
  
    begin
      select sum(j.jaqy327sdeu)
        into saldo_extSoles
        from jaqy327 j
       where j.jaqy327inst = Instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327chek = '1'
         and j.jaqy327tcre in ('Pymes S/.', 'Pymes US$')
         and j.jaqy327cent <> '00104'
         and j.jaqy327aux3 = 'R' -- MPOSTIGOC 09/10/18 INC1373
         and j.jaqy327aux1 = 7;
    exception
      when others then
        saldo_extSoles := 0;
    end;
  
    saldo_externo := nvl(saldo_extSoles, 0);
  
    if saldo_externo = 0 then
      -- MPOSTIGOC 25/11/2019 
      begin
        select sum(j.jaqy327sdeu)
          into saldo_extSoles
          from jaqy327 j
         where j.jaqy327inst = Instancia
           and j.jaqy327esta = 'S'
           and j.jaqy327chek = '1'
           and j.jaqy327tcre in ('Pymes S/.', 'Pymes US$')
           and j.jaqy327cent <> '00104'; -- mpostigoc 28/09/2022
      exception
        when others then
          saldo_extSoles := 0;
      end;
    end if;
  
    saldo_externo := nvl(saldo_extSoles, 0);
  
  end sp_cr_DeudaIFIS;
  ----------------------------------------------------------------------------------

  procedure sp_cuentasPasivo(ln_Pepais          in number,
                             ln_Petdoc          in number,
                             ln_Pendoc          in char,
                             Instancia          in number,
                             ln_PasivoCorrSol   out number,
                             ln_PasivoCorrDol   out number,
                             ln_PasivoNoCorrSol out number,
                             ln_PasivoNoCorrDol out number) is
    lc_fgAdic    varchar2(1);
    lc_fgAmpl    varchar2(1);
    lc_ven       char(1);
    ln_indicador number;
    lc_fgRefLin  varchar2(1) := 'N';
    lc_fgRepro   varchar2(2);
    lc_FlgLn     varchar2(2);
  
    cursor inserta is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aofvto   ld_FchVencimiento
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or d10.Aomod in (141))
         and d10.Aostat <> 99
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10,
             b.aofvto   ld_FchVencimiento
      
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or b.Aomod in (141))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor linea(pd_fecpro in date) is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aofvto   ld_FchVencimiento
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and d10.Aomod = 117
         and d10.Aostat <> 99
         and d10.aofvto > pd_fecpro
      
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10,
             b.aofvto   ld_FchVencimiento
      
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.Aomod in (117)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto > pd_fecpro;
  
    cursor vuelo is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             x.xwfprcins /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       max(s.sng120per) ln_peri10*/
        from xwf700 x /*sng120 s*/
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc)
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or
             x.xwfmodulo in (117, 141))
            
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                 and wf.wfitemstsact = 1
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
            -- and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope,
                x.xwfprcins
      union
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             x.xwfprcins /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       max(s.sng120per) ln_peri10*/
        from xwf700 x, /*sng120 s,*/ fsr002 c, fsr008 a
      
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and x.xwfempresa = 1
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or
             x.xwfmodulo in (117, 141))
            
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                            -- and wftaskcod <> 55
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    -- and wftaskcod <> 55
                 and wf.wfitemstsact = 1
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
            --  and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope,
                x.xwfprcins;
  
    cursor lineas_ven(pd_fecpro in date) is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aofvto   ld_FchVencimiento
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro
      
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10,
             b.aofvto   ld_FchVencimiento
      
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
            --and b.aostat = 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred        varchar2(12);
    lc_flgprg         varchar2(2);
    ld_FchCorte       date;
    ln_MontSolAux     number := 0;
    ln_MontDolAux     number := 0;
    ld_FchVencimiento date;
  
    pd_fecpro date;
  
  begin
  
    ln_PasivoCorrSol   := 0;
    ln_PasivoCorrDol   := 0;
    ln_PasivoNoCorrSol := 0;
    ln_PasivoNoCorrDol := 0;
    ln_MontSolAux      := 0;
  
    ln_MontDolAux := 0;
  
    begin
      UPDATE JAQZ843 j
         set j.JAQZ843est = 'I'
       where j.JAQZ843inst = Instancia
         and j.JAQZ843est = 'H';
      commit;
    end;
  
    BEGIN
      select pgfape into pd_fecpro from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      -- Fecha de Corte    
      SELECT ADD_MONTHS(pd_fecpro, 12) --modabr
        into ld_FchCorte
        FROM DUAL;
    exception
      when others then
        null;
      
    end;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigente';
    
      PQ_CR_SALDOPYME.sp_refinanLinea(i.ln_pgcod10,
                                      i.ln_mod10,
                                      i.ln_suc10,
                                      i.ln_mda10,
                                      i.ln_pap10,
                                      i.ln_cta10,
                                      i.ln_oper10,
                                      lc_fgRefLin);
    
      PQ_CR_SALDOPYME.Sp_ampliados_CK(i.ln_pgcod10,
                                      i.ln_mod10,
                                      i.ln_suc10,
                                      i.ln_mda10,
                                      i.ln_pap10,
                                      i.ln_cta10,
                                      i.ln_oper10,
                                      i.ln_sbop10,
                                      i.ln_tope10,
                                      lc_fgAmpl);
    
      PQ_CR_SALDOPYME.sp_cr_Reprogramados(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          lc_fgRepro);
    
      begin
        select 'S'
          into lc_FlgLn
          from jaqy800
         where JAQY800PGCD = 1
           and JAQY800MOD = i.ln_mod10
           and JAQY800SUC = i.ln_suc10
           and JAQY800MDA = i.ln_mda10
           and JAQY800PAP = i.ln_pap10
           and JAQY800CTA = i.ln_cta10
           and JAQY800OPE = i.ln_oper10
           and JAQY800SBOP = i.ln_sbop10
           and JAQY800TOPE = i.ln_tope10
           and jaqy800vinc = 'S'
           and rownum = 1;
      exception
        when others then
          lc_FlgLn := 'N';
      end;
    
      if lc_fgRefLin <> 'S' and lc_fgAmpl <> 'S' AND lc_fgRepro <> 'S' and
         lc_FlgLn <> 'S' then
        PQ_CR_SALDOPYME.sp_resolutorpasivo(ln_Pepais,
                                           ln_Petdoc,
                                           ln_Pendoc,
                                           Instancia,
                                           pd_fecpro,
                                           i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           lc_fgRefLin,
                                           lc_IndCred,
                                           i.ld_fchvencimiento,
                                           ld_FchCorte,
                                           ln_MontSolAux,
                                           ln_MontDolAux);
      
        if i.ld_fchvencimiento > ld_FchCorte then
        
          ln_PasivoNoCorrSol := nvl(ln_PasivoNoCorrSol, 0) +
                                nvl(ln_MontSolAux, 0);
          ln_PasivoNoCorrDol := nvl(ln_PasivoNoCorrDol, 0) +
                                nvl(ln_MontDolAux, 0);
        
        else
          if i.ld_fchvencimiento <= ld_FchCorte then
            ln_PasivoCorrSol := nvl(ln_PasivoCorrSol, 0) +
                                nvl(ln_MontSolAux, 0);
            ln_PasivoCorrDol := nvl(ln_PasivoCorrDol, 0) +
                                nvl(ln_MontDolAux, 0);
          end if;
        end if;
      
      end if;
    
    end loop;
  
    for l in linea(pd_fecpro) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredLinea';
    
      PQ_CR_SALDOPYME.sp_refinanLinea(l.ln_pgcod10,
                                      l.ln_mod10,
                                      l.ln_suc10,
                                      l.ln_mda10,
                                      l.ln_pap10,
                                      l.ln_cta10,
                                      l.ln_oper10,
                                      lc_fgRefLin);
      --  if l.ln_mod10 = 117 then --PRY1509
      -- Ampliacion de Lineas  16.08.17 mpostigoc
      begin
        select 'S'
          into lc_FlgLn
          from jaqy800
         where JAQY800PGCD = 1
           and JAQY800MOD = l.ln_mod10
           and JAQY800SUC = l.ln_suc10
           and JAQY800MDA = l.ln_mda10
           and JAQY800PAP = l.ln_pap10
           and JAQY800CTA = l.ln_cta10
           and JAQY800OPE = l.ln_oper10
           and JAQY800SBOP = l.ln_sbop10
           and JAQY800TOPE = l.ln_tope10
           and jaqy800vinc = 'S'
           and rownum = 1;
      exception
        when others then
          lc_FlgLn := 'N';
      end;
      --  end if;
    
      if lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
      
        PQ_CR_SALDOPYME.sp_resolutorPasivo(ln_Pepais,
                                           ln_Petdoc,
                                           ln_Pendoc,
                                           Instancia,
                                           pd_fecpro,
                                           l.ln_pgcod10,
                                           l.ln_mod10,
                                           l.ln_suc10,
                                           l.ln_mda10,
                                           l.ln_pap10,
                                           l.ln_cta10,
                                           l.ln_oper10,
                                           l.ln_sbop10,
                                           l.ln_tope10,
                                           lc_fgRefLin,
                                           lc_IndCred,
                                           l.ld_fchvencimiento,
                                           ld_FchCorte,
                                           ln_MontSolAux,
                                           ln_MontDolAux);
      
        ln_PasivoCorrSol := nvl(ln_PasivoCorrSol, 0) +
                            nvl(ln_MontSolAux, 0);
      
        ln_PasivoCorrDol := nvl(ln_PasivoCorrDol, 0) +
                            nvl(ln_MontDolAux, 0);
      
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_IndCred   := 'CredEnVuelo';
    
      begin
        --Fecha de Vencimiento
        select max(f.ppfpag)
          into ld_FchVencimiento
          from fsd601 f
         where f.pgcod = c.ln_pgcod10
           and f.ppmod = c.ln_mod10
           and f.ppsuc = c.ln_suc10
           and f.ppmda = c.ln_mda10
           and f.pppap = c.ln_pap10
           and f.ppcta = c.ln_cta10
           and f.ppoper = c.ln_oper10
           and f.ppsbop = c.ln_sbop10
           and f.pptope = c.ln_tope10
           and f.d601co = 'X';
      exception
        when others then
          null;
        
      end;
    
      PQ_CR_SALDOPYME.sp_resolutorvueloPasivo(ln_Pepais,
                                              ln_Petdoc,
                                              ln_Pendoc,
                                              Instancia,
                                              pd_fecpro,
                                              c.xwfprcins,
                                              c.ln_pgcod10,
                                              c.ln_mod10,
                                              c.ln_suc10,
                                              c.ln_mda10,
                                              c.ln_pap10,
                                              c.ln_cta10,
                                              c.ln_oper10,
                                              c.ln_sbop10,
                                              c.ln_tope10,
                                              lc_fgRefLin,
                                              lc_IndCred,
                                              ld_FchVencimiento,
                                              ld_FchCorte,
                                              ln_MontSolAux,
                                              ln_MontDolAux);
    
      if c.ln_mod10 <> 117 then
        if ld_FchVencimiento > ld_FchCorte then
        
          ln_PasivoNoCorrSol := nvl(ln_PasivoNoCorrSol, 0) +
                                nvl(ln_MontSolAux, 0);
          ln_PasivoNoCorrDol := nvl(ln_PasivoNoCorrDol, 0) +
                                nvl(ln_MontDolAux, 0);
        
        else
          if ld_FchVencimiento <= ld_FchCorte then
            ln_PasivoCorrSol := nvl(ln_PasivoCorrSol, 0) +
                                nvl(ln_MontSolAux, 0);
          
            ln_PasivoCorrDol := nvl(ln_PasivoCorrDol, 0) +
                                nvl(ln_MontDolAux, 0);
          
          end if;
        end if;
      else
        if c.ln_mod10 = 117 then
          ln_PasivoCorrSol := nvl(ln_PasivoCorrSol, 0) +
                              nvl(ln_MontSolAux, 0);
        
          ln_PasivoCorrDol := nvl(ln_PasivoCorrDol, 0) +
                              nvl(ln_MontDolAux, 0);
        
        end if;
      end if;
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven(pd_fecpro) loop
    
      lc_IndCred   := 'LineaVencd';
      ln_indicador := 3;
      begin
        select 'S'
          into lc_ven
          from fsr011 a, fsd010 b
         where a.r2cod = j.ln_pgcod10
           and a.r2mod = j.ln_mod10
           and a.r2suc = j.ln_suc10
           and a.r2mda = j.ln_mda10
           and a.r2pap = j.ln_pap10
           and a.r2cta = j.ln_cta10
           and a.r2oper = j.ln_oper10
           and a.r2sbop = j.ln_sbop10
           and a.r2tope = j.ln_tope10
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99
           and relcod = 46
           and rownum = 1;
      exception
        when no_data_found then
          lc_ven := 'N';
      end;
    
      lc_fgAdic := null;
    
      PQ_CR_SALDOPYME.sp_refinanLinea(j.ln_pgcod10,
                                      j.ln_mod10,
                                      j.ln_suc10,
                                      j.ln_mda10,
                                      j.ln_pap10,
                                      j.ln_cta10,
                                      j.ln_oper10,
                                      lc_fgRefLin);
    
      --  if j.ln_mod10 = 117 then --PRY1509
      -- Ampliacion de Lineas  06/09/17 mpostigoc
      begin
        select 'S'
          into lc_FlgLn
          from jaqy800
         where JAQY800PGCD = 1
           and JAQY800MOD = j.ln_mod10
           and JAQY800SUC = j.ln_suc10
           and JAQY800MDA = j.ln_mda10
           and JAQY800PAP = j.ln_pap10
           and JAQY800CTA = j.ln_cta10
           and JAQY800OPE = j.ln_oper10
           and JAQY800SBOP = j.ln_sbop10
           and JAQY800TOPE = j.ln_tope10
           and jaqy800vinc = 'S'
           and rownum = 1;
      exception
        when others then
          lc_FlgLn := 'N';
      end;
      --  end if;
    
      if lc_ven = 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        PQ_CR_SALDOPYME.sp_resolutor_vencPasivo(ln_Pepais,
                                                ln_Petdoc,
                                                ln_Pendoc,
                                                Instancia,
                                                pd_fecpro,
                                                j.ln_pgcod10,
                                                j.ln_mod10,
                                                j.ln_suc10,
                                                j.ln_mda10,
                                                j.ln_pap10,
                                                j.ln_cta10,
                                                j.ln_oper10,
                                                j.ln_sbop10,
                                                j.ln_tope10,
                                                lc_IndCred,
                                                lc_flgprg,
                                                j.ld_fchvencimiento,
                                                ld_FchCorte,
                                                ln_MontSolAux,
                                                ln_MontDolAux);
      
        if j.ld_fchvencimiento > ld_FchCorte then
        
          ln_PasivoNoCorrSol := nvl(ln_PasivoNoCorrSol, 0) +
                                nvl(ln_MontSolAux, 0);
          ln_PasivoNoCorrDol := nvl(ln_PasivoNoCorrDol, 0) +
                                nvl(ln_MontDolAux, 0);
        
        else
          if j.ld_fchvencimiento <= ld_FchCorte then
            ln_PasivoCorrSol := nvl(ln_PasivoCorrSol, 0) +
                                nvl(ln_MontSolAux, 0);
          
            ln_PasivoCorrDol := nvl(ln_PasivoCorrDol, 0) +
                                nvl(ln_MontDolAux, 0);
          
          end if;
        end if;
      
      end if;
    
    end loop;
  
    PQ_CR_SALDOPYME.sp_cr_LogPasivo(ln_Pepais,
                                    ln_Petdoc,
                                    ln_Pendoc,
                                    Instancia,
                                    pd_fecpro,
                                    ln_PasivoNoCorrSol,
                                    ln_PasivoNoCorrDol,
                                    ln_PasivoCorrSol,
                                    ln_PasivoCorrDol,
                                    'PSV');
  
  end sp_cuentasPasivo;
  -------------------------------------------------------------------------------
  --18/06/2019 mpostigoc
  -- Solo considera creditos vigentes que posee el Titular y su conyuge, a solicitud del
  -- negocio no se considera solicitudes en vuelo. 

  procedure sp_cuentasPasivoII(ln_Pepais          in number,
                               ln_Petdoc          in number,
                               ln_Pendoc          in char,
                               Instancia          in number,
                               ln_PasivoCorrSol   out number,
                               ln_PasivoCorrDol   out number,
                               ln_PasivoNoCorrSol out number,
                               ln_PasivoNoCorrDol out number) is
  
    lc_fgAdic    varchar2(1);
    lc_fgAmpl    varchar2(1);
    lc_ven       char(1);
    ln_indicador number;
    lc_fgRefLin  varchar2(1) := 'N';
    -- lc_fgRepro   varchar2(2);
    --lc_FlgLn     varchar2(2);
  
    cursor inserta is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aofvto   ld_FchVencimiento
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or d10.Aomod in (141))
         and d10.Aostat <> 99
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10,
             b.aofvto   ld_FchVencimiento
      
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or b.Aomod in (141))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor linea(pd_fecpro in date) is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aofvto   ld_FchVencimiento
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and d10.Aomod = 117
         and d10.Aostat <> 99
         and d10.aofvto > pd_fecpro
      
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10,
             b.aofvto   ld_FchVencimiento
      
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.Aomod in (117)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto > pd_fecpro;
  
    cursor lineas_ven(pd_fecpro in date) is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aofvto   ld_FchVencimiento
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro
      union
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10,
             b.aofvto   ld_FchVencimiento
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
            --and b.aostat = 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred        varchar2(12);
    lc_flgprg         varchar2(2);
    ld_FchCorte       date;
    ln_MontSolAux     number := 0;
    ln_MontDolAux     number := 0;
    ld_FchVencimiento date;
  
    pd_fecpro date;
  
  begin
  
    ln_PasivoCorrSol   := 0;
    ln_PasivoCorrDol   := 0;
    ln_PasivoNoCorrSol := 0;
    ln_PasivoNoCorrDol := 0;
    ln_MontSolAux      := 0;
  
    ln_MontDolAux := 0;
  
    begin
      UPDATE JAQZ843 j
         set j.JAQZ843est = 'I'
       where j.JAQZ843inst = Instancia
         and j.JAQZ843est = 'H';
      commit;
    end;
  
    BEGIN
      select pgfape into pd_fecpro from fst017 where pgcod = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      -- Fecha de Corte    
      SELECT ADD_MONTHS(pd_fecpro, 12) --modabr
        into ld_FchCorte
        FROM DUAL;
    exception
      when others then
        null;
      
    end;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigente';
    
      PQ_CR_SALDOPYME.sp_resolutorpasivo(ln_Pepais,
                                         ln_Petdoc,
                                         ln_Pendoc,
                                         Instancia,
                                         pd_fecpro,
                                         i.ln_pgcod10,
                                         i.ln_mod10,
                                         i.ln_suc10,
                                         i.ln_mda10,
                                         i.ln_pap10,
                                         i.ln_cta10,
                                         i.ln_oper10,
                                         i.ln_sbop10,
                                         i.ln_tope10,
                                         lc_fgRefLin,
                                         lc_IndCred,
                                         i.ld_fchvencimiento,
                                         ld_FchCorte,
                                         ln_MontSolAux,
                                         ln_MontDolAux);
    
      if i.ld_fchvencimiento > ld_FchCorte then
      
        ln_PasivoNoCorrSol := nvl(ln_PasivoNoCorrSol, 0) +
                              nvl(ln_MontSolAux, 0);
        ln_PasivoNoCorrDol := nvl(ln_PasivoNoCorrDol, 0) +
                              nvl(ln_MontDolAux, 0);
      
      else
        if i.ld_fchvencimiento <= ld_FchCorte then
          ln_PasivoCorrSol := nvl(ln_PasivoCorrSol, 0) +
                              nvl(ln_MontSolAux, 0);
          ln_PasivoCorrDol := nvl(ln_PasivoCorrDol, 0) +
                              nvl(ln_MontDolAux, 0);
        end if;
      end if;
    
    end loop;
  
    for l in linea(pd_fecpro) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredLinea';
    
      PQ_CR_SALDOPYME.sp_resolutorPasivo(ln_Pepais,
                                         ln_Petdoc,
                                         ln_Pendoc,
                                         Instancia,
                                         pd_fecpro,
                                         l.ln_pgcod10,
                                         l.ln_mod10,
                                         l.ln_suc10,
                                         l.ln_mda10,
                                         l.ln_pap10,
                                         l.ln_cta10,
                                         l.ln_oper10,
                                         l.ln_sbop10,
                                         l.ln_tope10,
                                         lc_fgRefLin,
                                         lc_IndCred,
                                         l.ld_fchvencimiento,
                                         ld_FchCorte,
                                         ln_MontSolAux,
                                         ln_MontDolAux);
    
      ln_PasivoCorrSol := nvl(ln_PasivoCorrSol, 0) + nvl(ln_MontSolAux, 0);
    
      ln_PasivoCorrDol := nvl(ln_PasivoCorrDol, 0) + nvl(ln_MontDolAux, 0);
    
    end loop;
  
    for j in lineas_ven(pd_fecpro) loop
    
      lc_IndCred   := 'LineaVencd';
      ln_indicador := 3;
      begin
        select 'S'
          into lc_ven
          from fsr011 a, fsd010 b
         where a.r2cod = j.ln_pgcod10
           and a.r2mod = j.ln_mod10
           and a.r2suc = j.ln_suc10
           and a.r2mda = j.ln_mda10
           and a.r2pap = j.ln_pap10
           and a.r2cta = j.ln_cta10
           and a.r2oper = j.ln_oper10
           and a.r2sbop = j.ln_sbop10
           and a.r2tope = j.ln_tope10
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99
           and relcod = 46
           and rownum = 1;
      exception
        when no_data_found then
          lc_ven := 'N';
      end;
    
      lc_fgAdic := null;
    
      if lc_ven = 'S' then
        PQ_CR_SALDOPYME.sp_resolutor_vencPasivo(ln_Pepais,
                                                ln_Petdoc,
                                                ln_Pendoc,
                                                Instancia,
                                                pd_fecpro,
                                                j.ln_pgcod10,
                                                j.ln_mod10,
                                                j.ln_suc10,
                                                j.ln_mda10,
                                                j.ln_pap10,
                                                j.ln_cta10,
                                                j.ln_oper10,
                                                j.ln_sbop10,
                                                j.ln_tope10,
                                                lc_IndCred,
                                                lc_flgprg,
                                                j.ld_fchvencimiento,
                                                ld_FchCorte,
                                                ln_MontSolAux,
                                                ln_MontDolAux);
      
        if j.ld_fchvencimiento > ld_FchCorte then
        
          ln_PasivoNoCorrSol := nvl(ln_PasivoNoCorrSol, 0) +
                                nvl(ln_MontSolAux, 0);
          ln_PasivoNoCorrDol := nvl(ln_PasivoNoCorrDol, 0) +
                                nvl(ln_MontDolAux, 0);
        
        else
          if j.ld_fchvencimiento <= ld_FchCorte then
            ln_PasivoCorrSol := nvl(ln_PasivoCorrSol, 0) +
                                nvl(ln_MontSolAux, 0);
          
            ln_PasivoCorrDol := nvl(ln_PasivoCorrDol, 0) +
                                nvl(ln_MontDolAux, 0);
          
          end if;
        
        END IF;
      end if;
    end loop;
  
    PQ_CR_SALDOPYME.sp_cr_LogPasivo(ln_Pepais,
                                    ln_Petdoc,
                                    ln_Pendoc,
                                    Instancia,
                                    pd_fecpro,
                                    ln_PasivoNoCorrSol,
                                    ln_PasivoNoCorrDol,
                                    ln_PasivoCorrSol,
                                    ln_PasivoCorrDol,
                                    'PSVII');
  
  end sp_cuentasPasivoII;
  --------------------------------------------------------------------------------

  procedure sp_cr_saldocapital(ln_pgcod10  in number,
                               ln_mod10    in number,
                               ln_suc10    in number,
                               ln_mda10    in number,
                               ln_pap10    in number,
                               ln_cta10    in number,
                               ln_oper10   in number,
                               ln_sbop     in number,
                               ln_tope10   in number,
                               tipocambio  in number,
                               Instancia   in number,
                               ln_saldocap out number) is
  
    ln_rubro   number;
    ln_digito  varchar2(4);
    flag_rubro varchar2(2);
  begin
    begin
    
      select scsdo, scrub
        into ln_saldocap, ln_rubro
        from fsd011
       where PGCOD = ln_pgcod10
         and SCMOD = ln_mod10
         and SCMDA = ln_mda10
         and SCPAP = ln_pap10
         and SCCTA = ln_cta10
         and SCSUC = ln_suc10
         and SCOPER = ln_oper10
         and scsbop = ln_sbop
         and sctope = ln_tope10
         and scstat <> 99;
    exception
      when others then
        null;
    end;
  
    if ln_saldocap is null then
      begin
        select w.xwfmonto1
          into ln_saldocap
          from xwf700 w
         where w.xwfprcins = Instancia
           and w.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      begin
        -- Rubro de la Solicitud en Vuelo
        select to_number(ww.pp028defc)
          into ln_rubro
          from fpp028 ww
         where ww.pp017par = 115
           and ww.pp028mod = ln_mod10
           and ww.pp028top = ln_tope10
           and ww.pp028emp = ln_pgcod10
           and ww.pp028mda = ln_mda10
           and ww.pp028pap = ln_pap10;
      exception
        when others then
          null;
      end;
    
    end if;
  
    if ln_mda10 = 101 then
      ln_saldocap := ln_saldocap * tipocambio;
    end if;
  
    begin
      -- rubro
      if ln_mod10 <> 117 then
      
        begin
          SELECT SUBSTR(to_char(ln_rubro), 5, 2) into ln_digito FROM DUAL;
        exception
          when others then
            null;
        end;
      
      else
        if ln_mod10 = 117 then
        
          begin
            SELECT SUBSTR(to_char(ln_rubro), 7, 2)
              into ln_digito
              FROM DUAL;
          exception
            when others then
              null;
          end;
        
        end if;
      end if;
    
    end;
  
    begin
      select 'S'
        into flag_rubro
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 17
         and a.tp1corr2 = 3
         and trim(a.tp1desc) = ln_digito;
    exception
      when no_data_found then
        flag_rubro := 'N';
    end;
  
    if flag_rubro = 'S' then
      if ln_saldocap < 0 then
        ln_saldocap := ln_saldocap * -1;
      end if;
    else
      if flag_rubro = 'N' then
        ln_saldocap := 0;
      end if;
    end if;
  
  end sp_cr_saldocapital;
  ----------------------------------------------------

  procedure sp_cr_saldocapitalref(tipocambio  in number,
                                  Instancia   in number,
                                  ln_saldocap out number) is
    ln_mda10 number;
  
  begin
  
    begin
      select w.xwfmonto1, w.xwfmoneda
        into ln_saldocap, ln_mda10
        from xwf700 w
       where w.xwfprcins = Instancia
         and w.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_mda10 = 101 then
      ln_saldocap := ln_saldocap * tipocambio;
    end if;
  
    if ln_saldocap < 0 then
      ln_saldocap := ln_saldocap * -1;
    end if;
  end sp_cr_saldocapitalref;

  ---------------------------------------------------------------
  procedure sp_cr_SaldCapPasivo(ln_pgcod10    in number,
                                ln_mod10      in number,
                                ln_suc10      in number,
                                ln_mda10      in number,
                                ln_pap10      in number,
                                ln_cta10      in number,
                                ln_oper10     in number,
                                ln_sbop       in number,
                                ln_tope10     in number,
                                Instancia     in number,
                                ln_MontSolAux out number,
                                ln_MontDolAux out number) is
  
    ln_rubro    number;
    ln_digito   varchar2(4);
    flag_rubro  varchar2(2);
    ln_saldocap NUMBER;
  
  begin
    begin
    
      select scsdo, scrub
        into ln_saldocap, ln_rubro
        from fsd011
       where PGCOD = ln_pgcod10
         and SCMOD = ln_mod10
         and SCMDA = ln_mda10
         and SCPAP = ln_pap10
         and SCCTA = ln_cta10
         and SCSUC = ln_suc10
         and SCOPER = ln_oper10
         and scsbop = ln_sbop
         and sctope = ln_tope10
         and scstat <> 99;
    exception
      when others then
        null;
    end;
  
    if ln_saldocap is null then
      begin
        select w.xwfmonto1
          into ln_saldocap
          from xwf700 w
         where w.xwfprcins = Instancia
           and w.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      begin
        -- Rubro de la Solicitud en Vuelo
        select to_number(ww.pp028defc)
          into ln_rubro
          from fpp028 ww
         where ww.pp017par = 115
           and ww.pp028mod = ln_mod10
           and ww.pp028top = ln_tope10
           and ww.pp028emp = ln_pgcod10
           and ww.pp028mda = ln_mda10
           and ww.pp028pap = ln_pap10;
      exception
        when others then
          null;
      end;
    
    end if;
  
    /*if ln_mda10 = 101 then
      ln_saldocap := ln_saldocap * tipocambio;
    end if;*/
  
    begin
      -- rubro
      if ln_mod10 <> 117 then
      
        begin
          SELECT SUBSTR(to_char(ln_rubro), 5, 2) into ln_digito FROM DUAL;
        exception
          when others then
            null;
        end;
      
      else
        if ln_mod10 = 117 then
        
          begin
            SELECT SUBSTR(to_char(ln_rubro), 7, 2)
              into ln_digito
              FROM DUAL;
          exception
            when others then
              null;
          end;
        
        end if;
      end if;
    
    end;
  
    begin
      select 'S'
        into flag_rubro
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 17
         and a.tp1corr2 = 3
         and trim(a.tp1desc) = ln_digito;
    exception
      when no_data_found then
        flag_rubro := 'N';
    end;
  
    if flag_rubro = 'S' then
      if ln_saldocap < 0 then
        if ln_mda10 <> 101 then
          ln_MontSolAux := ln_saldocap * -1;
        else
          ln_MontDolAux := ln_saldocap * -1;
        end if;
      end if;
    
      if ln_saldocap > 0 then
        if ln_mda10 <> 101 then
          ln_MontSolAux := ln_saldocap;
        else
          ln_MontDolAux := ln_saldocap;
        end if;
      end if;
    else
      if flag_rubro = 'N' then
        ln_MontSolAux := 0;
        ln_MontDolAux := 0;
      end if;
    end if;
  
    ln_MontSolAux := nvl(ln_MontSolAux, 0);
    ln_MontDolAux := nvl(ln_MontDolAux, 0);
  
  end sp_cr_SaldCapPasivo;
  ----------------------------------------------------

  procedure sp_cr_SaldCapRefPas( --tipocambio    in number,
                                Instancia     in number,
                                ln_MontSolAux out number,
                                ln_MontDolAux out number) is
    ln_mda10    number;
    ln_saldocap number(17, 2);
  
  begin
  
    begin
      select w.xwfmonto1, w.xwfmoneda
        into ln_saldocap, ln_mda10
        from xwf700 w
       where w.xwfprcins = Instancia
         and w.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    /* if ln_mda10 = 101 then
      ln_saldocap := ln_saldocap * tipocambio;
    end if;*/
  
    if ln_saldocap < 0 then
      if ln_mda10 <> 101 then
        ln_MontSolAux := ln_saldocap * -1;
      else
        ln_MontDolAux := ln_saldocap * -1;
      end if;
    end if;
  
    ln_MontSolAux := nvl(ln_MontSolAux, 0);
    ln_MontDolAux := nvl(ln_MontDolAux, 0);
  
  end sp_cr_SaldCapRefPas;

  --------------------------------------------------
  procedure sp_resolutor(ln_Pepais   in number,
                         ln_Petdoc   in number,
                         ln_Pendoc   in char,
                         tipocambio  in number,
                         Instancia   in number,
                         pd_fecpro   in date,
                         ln_pgcod10  in number,
                         ln_mod10    in number,
                         ln_suc10    in number,
                         ln_mda10    in number,
                         ln_pap10    in number,
                         ln_cta10    in number,
                         ln_oper10   in number,
                         ln_sbop     in number,
                         ln_tope10   in number,
                         lc_fgRefLin in varchar2,
                         lc_IndCred  in varchar2,
                         lc_flgprg   in varchar2,
                         ln_tarea    in number,
                         ln_saldocap out number) is
  
  begin
  
    If lc_fgRefLin <> 'S' then
    
      PQ_CR_SALDOPYME.sp_cr_saldocapital(ln_pgcod10,
                                         ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop,
                                         ln_tope10,
                                         tipocambio,
                                         Instancia,
                                         ln_saldocap);
    else
      if lc_fgRefLin = 'S' then
      
        PQ_CR_SALDOPYME.sp_cr_saldocapitalref(tipocambio,
                                              Instancia,
                                              ln_saldocap);
      
      End if;
    
    End if;
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and ln_saldocap > 0 then
    
      pq_cr_saldopyme.sp_cr_LogCuentas(ln_Pepais,
                                       ln_Petdoc,
                                       ln_Pendoc,
                                       tipocambio,
                                       Instancia,
                                       pd_fecpro,
                                       ln_pgcod10,
                                       ln_mod10,
                                       ln_suc10,
                                       ln_mda10,
                                       ln_pap10,
                                       ln_cta10,
                                       ln_oper10,
                                       ln_sbop,
                                       ln_tope10,
                                       ln_saldocap,
                                       lc_IndCred,
                                       lc_flgprg,
                                       ln_tarea);
    end if;
  
  end sp_resolutor;
  --------------------------------------------------
  procedure sp_resolutorvuelo(ln_Pepais    in number,
                              ln_Petdoc    in number,
                              ln_Pendoc    in char,
                              tipocambio   in number,
                              Instancia    in number,
                              pd_fecpro    in date,
                              ln_InstVerif in number,
                              ln_pgcod10   in number,
                              ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop      in number,
                              ln_tope10    in number,
                              lc_fgRefLin  in varchar2,
                              lc_IndCred   in varchar2,
                              lc_flgprg    in varchar2,
                              ln_tarea     in number,
                              ln_saldocap  out number) is
  
  begin
  
    If lc_fgRefLin <> 'S' then
    
      PQ_CR_SALDOPYME.sp_cr_saldocapital(ln_pgcod10,
                                         ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop,
                                         ln_tope10,
                                         tipocambio,
                                         ln_InstVerif,
                                         ln_saldocap);
    else
      if lc_fgRefLin = 'S' then
      
        PQ_CR_SALDOPYME.sp_cr_saldocapitalref(tipocambio,
                                              ln_InstVerif,
                                              ln_saldocap);
      
      End if;
    
    End if;
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and ln_saldocap > 0 then
    
      pq_cr_saldopyme.sp_cr_LogCuentas(ln_Pepais,
                                       ln_Petdoc,
                                       ln_Pendoc,
                                       tipocambio,
                                       Instancia,
                                       pd_fecpro,
                                       ln_pgcod10,
                                       ln_mod10,
                                       ln_suc10,
                                       ln_mda10,
                                       ln_pap10,
                                       ln_cta10,
                                       ln_oper10,
                                       ln_sbop,
                                       ln_tope10,
                                       ln_saldocap,
                                       lc_IndCred,
                                       lc_flgprg,
                                       ln_tarea);
    end if;
  
  end sp_resolutorvuelo;

  --------------------------------------------------
  procedure sp_resolutor_venc(ln_Pepais    in number,
                              ln_Petdoc    in number,
                              ln_Pendoc    in char,
                              tipocambio   in number,
                              Instancia    in number,
                              pd_fecpro    in date,
                              ln_pgcod10   in number,
                              ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop10    in number,
                              ln_tope10    in number,
                              lc_IndCred   in varchar2,
                              lc_flgprg    in varchar2,
                              ln_tarea     in number,
                              ln_capacidad out number) is
    ln_saldocap number(17, 2);
    -- ln_parciales  number;
    /* ln_cuotimp    number;
    ln_seguro     number;
    fech_maxcuota date;*/
    --   ln_instancia  number;
    lc_ven char(1);
  
    cursor creditos is
      select a.r1cod  ln_pgcod10,
             a.r1mod  ln_mod10,
             a.r1suc  ln_suc10,
             a.r1mda  ln_mda10,
             a.r1pap  ln_pap10,
             a.r1cta  ln_cta10,
             a.r1oper ln_oper10,
             a.r1sbop ln_sbop10,
             a.r1tope ln_tope10
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and a.relcod = 46;
  
    -- ln_pr116  number;
    --  ln_capTem number;
  
  begin
  
    begin
      select 'S'
        into lc_ven
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and a.relcod = 46
         and rownum = 1;
    exception
      when no_data_found then
        lc_ven := 'N';
    end;
  
    if lc_ven = 'S' then
      for i in creditos loop
      
        PQ_CR_SALDOPYME.sp_cr_saldocapital(i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           tipocambio,
                                           Instancia,
                                           ln_saldocap);
      
        if lc_flgprg = 'S' then
        
          pq_cr_saldopyme.sp_cr_LogCuentas(ln_Pepais,
                                           ln_Petdoc,
                                           ln_Pendoc,
                                           tipocambio,
                                           Instancia,
                                           pd_fecpro,
                                           i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           ln_saldocap,
                                           lc_IndCred,
                                           lc_flgprg,
                                           ln_tarea);
        end if;
      
        ln_capacidad := nvl(ln_capacidad, 0) + nvl(ln_saldocap, 0);
      
      end loop;
    end if;
  
  end sp_resolutor_venc;

  ------------------------------------------------------------------------------------------
  procedure sp_resolutorPasivo(ln_Pepais   in number,
                               ln_Petdoc   in number,
                               ln_Pendoc   in char,
                               Instancia   in number,
                               pd_fecpro   in date,
                               ln_pgcod10  in number,
                               ln_mod10    in number,
                               ln_suc10    in number,
                               ln_mda10    in number,
                               ln_pap10    in number,
                               ln_cta10    in number,
                               ln_oper10   in number,
                               ln_sbop     in number,
                               ln_tope10   in number,
                               lc_fgRefLin in varchar2,
                               lc_IndCred  in varchar2,
                               --lc_flgprg     in varchar2,
                               ld_FchVenc    in date,
                               ld_FchCorte   in date,
                               ln_MontSolAux out number,
                               ln_MontDolAux out number) is
  
    ln_saldocap  number(17, 2);
    lc_IndPasivo varchar2(25);
  
  begin
  
    If lc_fgRefLin <> 'S' then
    
      PQ_CR_SALDOPYME.sp_cr_SaldCapPasivo(ln_pgcod10,
                                          ln_mod10,
                                          ln_suc10,
                                          ln_mda10,
                                          ln_pap10,
                                          ln_cta10,
                                          ln_oper10,
                                          ln_sbop,
                                          ln_tope10,
                                          -- tipocambio,
                                          Instancia,
                                          ln_MontSolAux,
                                          ln_MontDolAux);
    else
      if lc_fgRefLin = 'S' then
      
        PQ_CR_SALDOPYME.sp_cr_saldocapitalref(Instancia,
                                              ln_MontSolAux,
                                              ln_MontDolAux);
      
      End if;
    
    End if;
  
    if ln_MontSolAux > 0 or ln_MontDolAux > 0 then
    
      if ln_MontSolAux > 0 then
        ln_saldocap := ln_MontSolAux;
      else
        ln_saldocap := ln_MontDolAux;
      end if;
    
      if ld_FchVenc > ld_FchCorte then
        if ln_MontSolAux > 0 then
          lc_IndPasivo := 'PasivoNoCorrSol';
        else
          lc_IndPasivo := 'PasivoNoCorrDol';
        end if;
      
      else
        if ld_FchVenc <= ld_FchCorte then
          if ln_MontSolAux > 0 then
            lc_IndPasivo := 'PasivoCorrSol';
          else
            lc_IndPasivo := 'PasivoCorrDol';
          end if;
        end if;
      end if;
    
      PQ_CR_SALDOPYME.sp_cr_LogCtaPasivo(ln_Pepais,
                                         ln_Petdoc,
                                         ln_Pendoc,
                                         
                                         Instancia,
                                         pd_fecpro,
                                         ln_pgcod10,
                                         ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop,
                                         ln_tope10,
                                         ln_saldocap,
                                         ld_FchVenc,
                                         lc_IndCred,
                                         lc_IndPasivo);
    end if;
  
  end sp_resolutorPasivo;
  -----------------------------------------------------------  
  procedure sp_resolutorvueloPasivo(ln_Pepais     in number,
                                    ln_Petdoc     in number,
                                    ln_Pendoc     in char,
                                    Instancia     in number,
                                    pd_fecpro     in date,
                                    ln_InstVerif  in number,
                                    ln_pgcod10    in number,
                                    ln_mod10      in number,
                                    ln_suc10      in number,
                                    ln_mda10      in number,
                                    ln_pap10      in number,
                                    ln_cta10      in number,
                                    ln_oper10     in number,
                                    ln_sbop       in number,
                                    ln_tope10     in number,
                                    lc_fgRefLin   in varchar2,
                                    lc_IndCred    in varchar2,
                                    ld_FchVenc    in date,
                                    ld_FchCorte   in date,
                                    ln_MontSolAux out number,
                                    ln_MontDolAux out number) is
  
    ln_saldocap  number(17, 2);
    lc_IndPasivo varchar2(25);
  begin
  
    If lc_fgRefLin <> 'S' then
    
      PQ_CR_SALDOPYME.sp_cr_SaldCapPasivo(ln_pgcod10,
                                          ln_mod10,
                                          ln_suc10,
                                          ln_mda10,
                                          ln_pap10,
                                          ln_cta10,
                                          ln_oper10,
                                          ln_sbop,
                                          ln_tope10,
                                          -- tipocambio,
                                          ln_InstVerif,
                                          ln_MontSolAux,
                                          ln_MontDolAux);
    else
      if lc_fgRefLin = 'S' then
      
        PQ_CR_SALDOPYME.sp_cr_SaldCapRefPas( --tipocambio,
                                            ln_InstVerif,
                                            ln_MontSolAux,
                                            ln_MontDolAux);
      
      End if;
    
    End if;
  
    if ln_MontSolAux > 0 or ln_MontDolAux > 0 then
    
      if ln_MontSolAux > 0 then
        ln_saldocap := ln_MontSolAux;
      else
        ln_saldocap := ln_MontDolAux;
      end if;
    
      if ld_FchVenc > ld_FchCorte then
        if ln_MontSolAux > 0 then
          lc_IndPasivo := 'PasivoNoCorrSol';
        else
          lc_IndPasivo := 'PasivoNoCorrDol';
        end if;
      
      else
        if ld_FchVenc <= ld_FchCorte then
          if ln_MontSolAux > 0 then
            lc_IndPasivo := 'PasivoCorrSol';
          else
            lc_IndPasivo := 'PasivoCorrDol';
          end if;
        end if;
      end if;
    
      Pq_Cr_Saldopyme.sp_cr_LogCtaPasivo(ln_Pepais,
                                         ln_Petdoc,
                                         ln_Pendoc,
                                         Instancia,
                                         pd_fecpro,
                                         ln_pgcod10,
                                         ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop,
                                         ln_tope10,
                                         ln_saldocap,
                                         ld_FchVenc,
                                         lc_IndCred,
                                         lc_IndPasivo);
    end if;
  
  end sp_resolutorvueloPasivo;
  ------------------------------------------------------------------------------------------
  procedure sp_resolutor_vencPasivo(ln_Pepais     in number,
                                    ln_Petdoc     in number,
                                    ln_Pendoc     in char,
                                    Instancia     in number,
                                    pd_fecpro     in date,
                                    ln_pgcod10    in number,
                                    ln_mod10      in number,
                                    ln_suc10      in number,
                                    ln_mda10      in number,
                                    ln_pap10      in number,
                                    ln_cta10      in number,
                                    ln_oper10     in number,
                                    ln_sbop10     in number,
                                    ln_tope10     in number,
                                    lc_IndCred    in varchar2,
                                    lc_flgprg     in varchar2,
                                    ld_FchVenc    in date,
                                    ld_FchCorte   in date,
                                    ln_MontSolAux out number,
                                    ln_MontDolAux out number) is
    ln_saldocap  number(17, 2);
    lc_IndPasivo varchar2(25);
  
    lc_ven char(1);
  
    cursor creditos is
      select a.r1cod  ln_pgcod10,
             a.r1mod  ln_mod10,
             a.r1suc  ln_suc10,
             a.r1mda  ln_mda10,
             a.r1pap  ln_pap10,
             a.r1cta  ln_cta10,
             a.r1oper ln_oper10,
             a.r1sbop ln_sbop10,
             a.r1tope ln_tope10
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and a.relcod = 46;
  
    -- ln_pr116  number;
    --  ln_capTem number;
  
  begin
  
    begin
      select 'S'
        into lc_ven
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and a.relcod = 46
         and rownum = 1;
    exception
      when no_data_found then
        lc_ven := 'N';
    end;
  
    if lc_ven = 'S' then
      for i in creditos loop
      
        Pq_Cr_Saldopyme.sp_cr_SaldCapPasivo(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            i.ln_sbop10,
                                            i.ln_tope10,
                                            -- tipocambio,
                                            Instancia,
                                            ln_MontSolAux,
                                            ln_MontDolAux);
      
        if lc_flgprg = 'S' then
        
          if ln_MontSolAux > 0 then
            ln_saldocap := ln_MontSolAux;
          else
            ln_saldocap := ln_MontDolAux;
          end if;
        
          if to_char(ld_FchVenc, 'YYYYMMDD') >
             to_char(ld_FchCorte, 'YYYYMMDD') then
            if ln_MontSolAux > 0 then
              lc_IndPasivo := 'PasivoNoCorrSol';
            else
              lc_IndPasivo := 'PasivoNoCorrDol';
            end if;
          
          else
            if to_char(ld_FchVenc, 'YYYYMMDD') <=
               to_char(ld_FchCorte, 'YYYYMMDD') then
              if ln_MontSolAux > 0 then
                lc_IndPasivo := 'PasivoCorrSol';
              else
                lc_IndPasivo := 'PasivoCorrDol';
              end if;
            end if;
          end if;
        
          PQ_CR_SALDOPYME.sp_cr_LogCtaPasivo(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             
                                             Instancia,
                                             pd_fecpro,
                                             i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             ln_saldocap,
                                             ld_FchVenc,
                                             lc_IndCred,
                                             lc_IndPasivo);
        end if;
      
      end loop;
    end if;
  
  end sp_resolutor_vencPasivo;
  -------------------------------------------------------------------------------------------
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2) is --mod 2016.04.12
  
  begin
  
    begin
    
      /*select 'S'
       into Pc_flag
       from xwf700 a, sng001 s, xwf070 w, wfwrkitems x
      where a.xwfempresa = ln_emp10
        and a.xwfsucursal = ln_suc10
        and a.xwfmodulo = ln_mod10
        and a.xwfmoneda = ln_mda10
        and a.xwfpapel = ln_pap10
        and a.xwfcuenta = ln_cta10
        and a.xwfoperacion = ln_oper10
        and a.xwfsubope = ln_sbop10
        and a.xwftipope = ln_tope10
        and a.xwfprcins = s.sng001inst
        and s.sng001ori = 4 -- Ampliaciones
        and s.sng001inst = x.wfinsprcid
        and x.wftaskcod = 55
        and x.wfitemid = w.xwfwrkite
        and s.sng001inst = w.xwfprcin
        and w.xwfcont = 'S'
        and rownum = 1;*/
    
      select 'S'
        into Pc_flag
        from xwf700 a, sng001 s /* xwf070 w,*/, wfwrkitems x
       where a.xwfempresa = ln_emp10
         and a.xwfsucursal = ln_suc10
         and a.xwfmodulo = ln_mod10
         and a.xwfmoneda = ln_mda10
         and a.xwfpapel = ln_pap10
         and a.xwfcuenta = ln_cta10
         and a.xwfoperacion = ln_oper10
         and a.xwfsubope = ln_sbop10
         and a.xwftipope = ln_tope10
         and a.xwfprcins = s.sng001inst
         and s.sng001ori in (4, 15) -- Ampliaciones Normales, Ampliaciones Especiales
         and s.sng001inst = x.wfinsprcid
         and x.wfitemstsact = 1
         and rownum = 1;
    exception
      when no_data_found then
        Pc_flag := 'N';
    end;
  
  end Sp_ampliados_CK;

  --------------------------------------------------------------------------

  Procedure Sp_Adicional_CK(pn_top in number, Pc_flag out varchar2) is --mod 2016.04.12
  
  begin
  
    begin
      select 'S'
        into Pc_flag
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 20001
         and a.tp1corr1 = 1
         and a.tp1corr2 = 1211
         and a.tp1nro1 = pn_top;
    exception
      when no_data_found then
        Pc_flag := 'N';
    end;
  
    If Pc_flag = 'S' then
    
      begin
        select 'N'
          into Pc_flag
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 18
           and a.tp1nro1 = pn_top;
      exception
        when no_data_found then
          Pc_flag := 'N';
      end;
    End If;
  end Sp_Adicional_CK;

  ----------------------------------------------------
  procedure sp_cr_Reprogramados(ln_emp10   in number,
                                ln_mod10   in number,
                                ln_suc10   in number,
                                ln_mda10   in number,
                                ln_pap10   in number,
                                ln_cta10   in number,
                                ln_oper10  in number,
                                ln_sbop10  in number,
                                ln_tope10  in number,
                                lc_fgRepro out varchar2) is
  begin
  
    begin
      /* select 'S'
       into lc_fgRepro
       from xwf700 a, sng001 g
      where a.xwfempresa = ln_emp10
        and a.xwfsucursal = ln_suc10
        and a.xwfmodulo = ln_mod10
        and a.xwfmoneda = ln_mda10
        and a.xwfpapel = ln_pap10
        and a.xwfcuenta = ln_cta10
        and a.xwfoperacion = ln_oper10
        and a.xwfsubope = ln_sbop10
        and a.xwftipope = ln_tope10
        and a.xwfprcins = g.sng001inst
        and g.sng001ori in (13, 14)
        and rownum = 1;*/
    
      select 'S'
        into lc_fgRepro
        from xwf700 a, sng001 s, /*xwf070 w,*/ wfwrkitems x
       where a.xwfempresa = ln_emp10
         and a.xwfsucursal = ln_suc10
         and a.xwfmodulo = ln_mod10
         and a.xwfmoneda = ln_mda10
         and a.xwfpapel = ln_pap10
         and a.xwfcuenta = ln_cta10
         and a.xwfoperacion = ln_oper10
         and a.xwfsubope = ln_sbop10
         and a.xwftipope = ln_tope10
         and a.xwfprcins = s.sng001inst
         and s.sng001ori in (13, 14) -- Reprogramaciones
         and s.sng001inst = x.wfinsprcid
         and x.wfitemstsact = 1
         and rownum = 1;
    exception
      when no_data_found then
        lc_fgRepro := 'N';
    end;
  
  end sp_cr_Reprogramados;
  --------------------------------------------------
  procedure sp_refinanLinea(ln_pgcod10  in number,
                            ln_mod10    in number,
                            ln_suc10    in number,
                            ln_mda10    in number,
                            ln_pap10    in number,
                            ln_cta10    in number,
                            ln_oper10   in number,
                            lc_fgRefLin out varchar2) is
    ln_InstVerfca number; --07012020 mpostigoc
  begin
  
    lc_fgRefLin := 'N';
    if ln_mod10 = 117 then
    
      begin
        select max(w.xwfprcins)
          into ln_InstVerfca
          from fsr011 f, xwf700 w
         where f.r1cod = w.xwfempresa
           and f.r1mod = w.xwfmodulo
           and f.r1suc = w.xwfsucursal
           and f.r1mda = w.xwfmoneda
           and f.r1pap = w.xwfpapel
           and f.r1cta = w.xwfcuenta
           and w.xwfcar3 = 'R'
           and f.r2cod = ln_pgcod10
           and f.r2mod = ln_mod10
           and f.r2suc = ln_suc10
           and f.R2MDA = ln_mda10
           and f.R2PAP = ln_pap10
           and f.r2cta = ln_cta10
           and f.r2oper = ln_oper10
           and f.relcod = 46; --mpostigoc 25/02/2020
      exception
        when no_data_found then
          ln_InstVerfca := 0;
      end;
    
      --mpostigoc 20200107 INC2264
      begin
        select 'S'
          into lc_fgRefLin
          from wfwrkitems w, sng001 s
         where w.wfinsprcid = s.sng001inst
           and w.wfinsprcid = ln_InstVerfca
           and s.sng001ori in (3, 13, 14)
           and w.wfitemstsact = 1;
      exception
        when others then
          lc_fgRefLin := 'N';
      end;
      --
    else
      begin
        select 'S'
          into lc_fgRefLin
          from xwf700 a, sng001 s, /*xwf070 w,*/ wfwrkitems x
         where a.xwfempresa = ln_pgcod10
           and a.xwfsucursal = ln_suc10
           and a.xwfmodulo = ln_mod10
           and a.xwfmoneda = ln_mda10
           and a.xwfpapel = ln_pap10
           and a.xwfcuenta = ln_cta10
           and a.xwfoperacion = ln_oper10
           and a.xwfprcins = s.sng001inst
           and s.sng001ori in (3) -- Refinanciaciones
           and s.sng001inst = x.wfinsprcid
           and x.wfitemstsact = 1
           and rownum = 1;
      exception
        when no_data_found then
          lc_fgRefLin := 'N';
        
      end;
    end if;
  
  end sp_refinanLinea;

  -----------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais     in number,
                           ln_Petdoc     in number,
                           ln_Pendoc     in char,
                           tipocambio    in number,
                           Instancia     in number,
                           pd_fecpro     in date,
                           ln_captotcaja in number,
                           Patrimonio    in number,
                           SaldExter     in number,
                           CapTotal      in number,
                           lc_indicador  in varchar2,
                           lc_flgprg     in varchar2,
                           ln_tarea      in number) is
  
    ln_corr   number;
    lc_IndEst varchar2(2) := 'O';
    lc_hora   character(8);
  begin
  
    begin
    
      select /*+index (j JAQY1474)*/
       max(j.jaqy147corr)
        into ln_corr
        from jaqy147 j
       where j.jaqy147fec = pd_fecpro
         and j.jaqy147inst = Instancia;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    if lc_flgprg = 'R' then
    
      lc_IndEst := 'R';
    else
      if lc_flgprg = 'S' then
        lc_IndEst := 'H';
      end if;
    end if;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
      
    end;
  
    -- if lc_exist = 'N' then
    begin
      insert into jaqy147
        (jaqy147corr,
         jaqy147pais,
         jaqy147tdoc,
         jaqy147ndoc,
         jaqy147tcamb,
         jaqy147inst,
         jaqy147fec,
         jaqy147hora,
         jaqy147saldpyme,
         jaqy147ind,
         JAQY147EST,
         jaqy147patrim,
         JAQY147SLDEXT,
         JAQY147RATIO,
         jaqy147tarea)
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         tipocambio,
         Instancia,
         pd_fecpro,
         lc_hora,
         ln_captotcaja,
         lc_indicador,
         lc_IndEst,
         Patrimonio,
         SaldExter,
         CapTotal,
         ln_tarea);
      commit;
    end;
  
  end sp_cr_LogRatio;

  -------------------------------------------------------------
  procedure sp_cr_LogCuentas(lnPepais   in number,
                             lnPetdoc   in number,
                             lnPendoc   in char,
                             tipocambio in number,
                             Instancia  in number,
                             pd_fecpro  in date,
                             ln_PGCOD   in number,
                             ln_MOD     in number,
                             ln_SUC     in number,
                             ln_MDA     in number,
                             ln_PAP     in number,
                             ln_CTA     in number,
                             ln_OPE     in number,
                             ln_SBOP    in number,
                             ln_TOPE    in number,
                             ln_SALDCAP in number,
                             lc_IndCred IN VARCHAR2,
                             lc_flgprg  in varchar2,
                             ln_tarea   in number) is
  
    ln_corr   number;
    lc_IndEst varchar2(2);
    lc_hora   character(8);
  
  begin
  
    begin
    
      select max(j.JAQY148corr)
        into ln_corr
        from JAQY148 j
       where j.JAQY148fec = pd_fecpro
         and j.jaqy148inst = Instancia;
    exception
      when no_data_found then
        ln_corr := 0;
      
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    if lc_flgprg = 'S' then
    
      lc_IndEst := 'H';
    
    else
      if lc_flgprg = 'R' then
      
        lc_IndEst := 'R';
      
      end if;
    end if;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
      
    end;
  
    -- if lc_exist = 'N' then
  
    begin
      insert into JAQY148
        (JAQY148corr,
         JAQY148fec,
         JAQY148hora,
         JAQY148pais,
         JAQY148tdoc,
         JAQY148ndoc,
         JAQY148tcamb,
         JAQY148inst,
         JAQY148pgcod,
         JAQY148mod,
         JAQY148suc,
         JAQY148mda,
         JAQY148pap,
         JAQY148cta,
         JAQY148ope,
         JAQY148sbop,
         JAQY148tope,
         JAQY148SALDCAP,
         JAQY148INDIC,
         JAQY148est,
         jaqy148tarea)
      values
        (ln_corr + 1,
         pd_fecpro,
         lc_hora,
         lnPepais,
         lnPetdoc,
         lnPendoc,
         tipocambio,
         Instancia,
         ln_PGCOD,
         ln_MOD,
         ln_SUC,
         ln_MDA,
         ln_PAP,
         ln_CTA,
         ln_OPE,
         ln_SBOP,
         ln_TOPE,
         ln_SALDCAP,
         lc_IndCred,
         lc_IndEst,
         ln_tarea);
      commit;
    
    end;
  
  end sp_cr_LogCuentas;
  -----------------------------------------------------------

  procedure sp_cr_LogPasivo(ln_Pepais          in number,
                            ln_Petdoc          in number,
                            ln_Pendoc          in char,
                            Instancia          in number,
                            pd_fecpro          in date,
                            ln_PasivoNoCorrSol in number,
                            ln_PasivoNoCorrDol in number,
                            ln_PasivoCorrSol   in number,
                            ln_PasivoCorrDol   in number,
                            lc_indicador       in varchar2) is
  
    ln_corr   number;
    lc_IndEst varchar2(2);
    lc_hora   character(8);
  begin
  
    begin
    
      select max(j.JAQZ842corr)
        into ln_corr
        from JAQZ842 j
       where j.JAQZ842fec = pd_fecpro
         and j.jaqz842inst = Instancia;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    lc_IndEst := 'H';
  
    begin
      update JAQZ842 j
         set j.JAQZ842est = 'I'
       where j.JAQZ842inst = Instancia
         and j.JAQZ842est = 'H';
      commit;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    -- if lc_exist = 'N' then
    begin
      insert into JAQZ842
        (JAQZ842corr,
         JAQZ842pais,
         JAQZ842tdoc,
         JAQZ842ndoc,
         JAQZ842tcamb,
         JAQZ842inst,
         JAQZ842fec,
         JAQZ842hora,
         JAQZ842PSVNCSOL,
         JAQZ842PSVNCDOL,
         JAQZ842PSVCSOL,
         JAQZ842PSVCDOL,
         JAQZ842ind,
         JAQZ842EST)
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         0.0,
         Instancia,
         pd_fecpro,
         lc_hora,
         ln_PasivoNoCorrSol,
         ln_PasivoNoCorrDol,
         ln_PasivoCorrSol,
         ln_PasivoCorrDol,
         lc_indicador,
         lc_IndEst);
      commit;
    end;
  
  end sp_cr_LogPasivo;

  -------------------------------------------------------------
  procedure sp_cr_LogCtaPasivo(lnPepais     in number,
                               lnPetdoc     in number,
                               lnPendoc     in char,
                               Instancia    in number,
                               pd_fecpro    in date,
                               ln_PGCOD     in number,
                               ln_MOD       in number,
                               ln_SUC       in number,
                               ln_MDA       in number,
                               ln_PAP       in number,
                               ln_CTA       in number,
                               ln_OPE       in number,
                               ln_SBOP      in number,
                               ln_TOPE      in number,
                               ln_SALDCAP   in number,
                               ld_FchVenc   in date,
                               lc_IndCred   IN VARCHAR2,
                               lc_IndPasivo in varchar2) is
  
    ln_corr   number;
    lc_IndEst varchar2(2);
    lc_hora   character(8);
  
  begin
  
    begin
    
      select max(j.JAQZ843corr)
        into ln_corr
        from JAQZ843 j
       where j.JAQZ843fec = pd_fecpro
         and j.jaqz843inst = Instancia;
    exception
      when no_data_found then
        ln_corr := 0;
      
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    lc_IndEst := 'H';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
      
    end;
  
    -- if lc_exist = 'N' then
  
    begin
      insert into JAQZ843
      
        (JAQZ843corr,
         JAQZ843fec,
         JAQZ843hora,
         JAQZ843pais,
         JAQZ843tdoc,
         JAQZ843ndoc,
         JAQZ843tcamb,
         JAQZ843inst,
         JAQZ843pgcod,
         JAQZ843mod,
         JAQZ843suc,
         JAQZ843mda,
         JAQZ843pap,
         JAQZ843cta,
         JAQZ843ope,
         JAQZ843sbop,
         JAQZ843tope,
         JAQZ843SALDCAP,
         jaqz843fchvnc,
         JAQZ843INDIC,
         JAQZ843INDPASV,
         JAQZ843est)
      values
        (ln_corr + 1,
         pd_fecpro,
         lc_hora,
         lnPepais,
         lnPetdoc,
         lnPendoc,
         0.0,
         Instancia,
         ln_PGCOD,
         ln_MOD,
         ln_SUC,
         ln_MDA,
         ln_PAP,
         ln_CTA,
         ln_OPE,
         ln_SBOP,
         ln_TOPE,
         ln_SALDCAP,
         ld_FchVenc,
         lc_IndCred,
         lc_IndPasivo,
         lc_IndEst);
    
      commit;
    
    end;
  
  end sp_cr_LogCtaPasivo;
  --------------------------------------------
end PQ_CR_SALDOPYME;
/
