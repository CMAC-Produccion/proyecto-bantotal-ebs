create or replace package PQ_CR_RATIOPYME_DTEN is

  -- Author  : MPOSTIGOC
  -- Created : 07.07.2020 08:46:54 a.m.
  -- Purpose : Ratio reprogramaciones Pyme
  -- Fecha de Modificación      : 30/11/2023
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: se considero NVL para la variable de nro de cuotas en casos de flujo de caja
  -- Fecha de Modificación      : 15/03/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se descomento el monto de cuota potencial en el denominador de la formula  
  -- Fecha de Modificación      : 21/10/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se agrego la validacion del ratio consumo 
  -- Fecha de Modificación        : 25/02/2025
  -- Autor de Modificación        : MPOSTIGOC
  -- Descripción de Modificación  : Se modifico el denominador para el calculo del ratio, ahora se considera ingreso neto para consumo
  -----------------------------------------------------------

  procedure sp_CalculoRatio(ln_Pepais      in number,
                            ln_Petdoc      in number,
                            ln_Pendoc      in char,
                            ln_Correlativo in number,
                            ld_fchcorre    in date,
                            ln_Usuario     in varchar2,
                            ln_cuota       in number,
                            ln_captotcaja  out number,
                            saldo_externo  out number,
                            ln_ResultNeto  out number,
                            ln_MntPotncial out number,
                            ln_MntCuoCntg  out number,
                            ln_RatioPyme   out number);
  --------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Correlativo  in number,
                                ld_fchcorre     in date,
                                pd_fecpro       in date,
                                lc_flgprg       in varchar2,
                                ln_MntCuoCntgCF out number);
  -----------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Correlativo    in number,
                                  ld_fchcorre       in date,
                                  pd_fecpro         in date,
                                  lc_flgprg         in varchar2,
                                  ln_MntCuoCntgAval out number);
  ----------------------------------------------------------
  procedure sp_cR_y327bdj(ln_NroEval     in number,
                          ln_TipoCamb    in number,
                          ln_DeudaIFIS   out number,
                          ln_MntPotncial out number);
  -------------------------------------------------------------
  procedure sp_cr_ExcdntMnsual(ln_eval       in number,
                               ln_TipCamb    in number,
                               ln_ResultNeto out number,
                               ln_IngNeto    out number);
  ------------------------------------------------------
  procedure sp_cuotas(ln_pgcod10    in number,
                      ln_mod10      in number,
                      ln_suc10      in number,
                      ln_mda10      in number,
                      ln_pap10      in number,
                      ln_cta10      in number,
                      ln_oper10     in number,
                      ln_sbop10     in number,
                      ln_tope10     in number,
                      ln_NRO_CUOTAS out number);
  -------------------------------------------------------
  procedure sp_instancia(ln_mod10       in number,
                         ln_suc10       in number,
                         ln_mda10       in number,
                         ln_pap10       in number,
                         ln_cta10       in number,
                         ln_oper10      in number,
                         ln_sbop10      in number,
                         ln_tope10      in number,
                         ln_SNG001Ori   out number,
                         ln_Correlativo out number);
  -------------------------------------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            tipocambio    in number,
                            ln_cuoimp     out number,
                            fech_maxcuota out date);
  ---------------------------------------------------------                            
  procedure sp_cuota_impagavuelo(ln_pgcod10    in number,
                                 ln_mod10      in number,
                                 ln_suc10      in number,
                                 ln_mda10      in number,
                                 ln_pap10      in number,
                                 ln_cta10      in number,
                                 ln_oper10     in number,
                                 tipocambio    in number,
                                 ln_cuoimp     out number,
                                 fech_maxcuota out date);
  ---------------------------------------------------------
  procedure sp_seguro(ln_mod10        in number,
                      ln_suc10        in number,
                      ln_mda10        in number,
                      ln_pap10        in number,
                      ln_cta10        in number,
                      ln_oper10       in number,
                      ln_sbop10       in number,
                      ln_tope10       in number,
                      tipocambio      in number,
                      fech_maxcuota   in date,
                      ln_monto_seguro out number);
  ----------------------------------------------------------

  procedure sp_capacidadlinea(ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              tipocambio in number,
                              ln_formula out number);
  --------------------------------------------------
  procedure sp_cr_capacidadFC(ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              tipocambio in number,
                              ln_formula out number);
  -----------------------------------------------------------                              
  procedure sp_capacidadpago(ln_MAX_CUOTA in number,
                             --ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_capacidad    out number);
  -----------------------------------------------------
  procedure sp_capacidadpagoparc( --ln_NRO_CUOTAS     in number,
                                 ln_SNG001Ori      in number,
                                 ln_monto_seguro   in number,
                                 ln_mod10          in number,
                                 ln_ln_Correlativo in number,
                                 tipocambio        in number,
                                 ln_suc10          in number,
                                 ln_mda10          in number,
                                 ln_pap10          in number,
                                 ln_cta10          in number,
                                 ln_oper10         in number,
                                 ln_sbop10         in number,
                                 ln_tope10         in number,
                                 ln_indicador      in number,
                                 ln_cuoparc        out number,
                                 ln_capacidad      out number);
  --------------------------------------------------------
  procedure sp_resolutor(ln_Pepais      in number,
                         ln_Petdoc      in number,
                         ln_Pendoc      in char,
                         ln_Correlativo in number,
                         ld_fchcorre    in date,
                         pd_fecpro      in date,
                         ln_pgcod10     in number,
                         ln_mod10       in number,
                         ln_suc10       in number,
                         ln_mda10       in number,
                         ln_pap10       in number,
                         ln_cta10       in number,
                         ln_oper10      in number,
                         ln_sbop10      in number,
                         ln_tope10      in number,
                         ln_peri10      in number,
                         tipocambio     in number,
                         ln_indicador   in number,
                         lc_IndCred     in varchar2,
                         lc_Usuario     in varchar2,
                         ln_capacidad   out number);
  -----------------------------------------------------------
  procedure sp_resolutor_prop(ln_Pepais      in number,
                              ln_Petdoc      in number,
                              ln_Pendoc      in char,
                              ln_Correlativo in number,
                              ld_fchcorre    in date,
                              pd_fecpro      in date,
                              ln_pgcod10     in number,
                              ln_mod10       in number,
                              ln_suc10       in number,
                              ln_mda10       in number,
                              ln_pap10       in number,
                              ln_cta10       in number,
                              ln_oper10      in number,
                              ln_sbop10      in number,
                              ln_tope10      in number,
                              ln_peri10      in number,
                              ln_nrocuotas   in number,
                              tipocambio     in number,
                              lc_IndCred     in varchar2,
                              lc_Usuario     in varchar2,
                              ln_cuota       in number,
                              ln_capacidad   out number);
  ----------------------------------------------------------
  --mod 2016.04.13
  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2);
  ----------------------------------------------------------
  Procedure Sp_ampliados_CK(ln_emp10       in number,
                            ln_mod10       in number,
                            ln_suc10       in number,
                            ln_mda10       in number,
                            ln_pap10       in number,
                            ln_cta10       in number,
                            ln_oper10      in number,
                            ln_sbop10      in number,
                            ln_tope10      in number,
                            ln_correlativo in number,
                            ld_fchcorre    in date,
                            Pc_flag        out varchar2);
  ----------------------------------------------------------------

  procedure sp_refinanLinea(ln_pgcod10  in number,
                            ln_mod10    in number,
                            ln_suc10    in number,
                            ln_mda10    in number,
                            ln_pap10    in number,
                            ln_cta10    in number,
                            ln_oper10   in number,
                            lc_fgRefLin out varchar2);
  ---------------------------------------------------------

  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out varchar2);

  ------------------------------------------------------------
  procedure sp_cuota_impaga_Lin(ln_pgcod10    in number,
                                ln_mod10      in number,
                                ln_suc10      in number,
                                ln_mda10      in number,
                                ln_pap10      in number,
                                ln_cta10      in number,
                                ln_oper10     in number,
                                tipocambio    in number,
                                ln_cuoimp     out number,
                                fech_maxcuota out date);
  ------------------------------------------------------------                            

  procedure sp_capacidadpago_Lin(ln_MAX_CUOTA    in number,
                                 ln_NRO_CUOTAS   in number,
                                 ln_peri10       in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_capacidad    out number);
  --------------------------------------------------
  procedure sp_resolutor_venc(ln_Pepais      in number,
                              ln_Petdoc      in number,
                              ln_Pendoc      in char,
                              ln_Correlativo in number,
                              ld_fchcorre    in date,
                              pd_fecpro      in date,
                              ln_pgcod10     in number,
                              ln_mod10       in number,
                              ln_suc10       in number,
                              ln_mda10       in number,
                              ln_pap10       in number,
                              ln_cta10       in number,
                              ln_oper10      in number,
                              ln_sbop10      in number,
                              ln_tope10      in number,
                              tipocambio     in number,
                              lc_IndCred     in varchar2,
                              lc_Usuario     in varchar2,
                              ln_capacidad   out number);
  ---------------------------------------------------------------------------
  procedure sp_cr_VerfVincAliInterno(ln_pgcod  in number,
                                     ln_mod    in number,
                                     ln_suc    in number,
                                     ln_mda    in number,
                                     ln_pap    in number,
                                     ln_cta    in number,
                                     ln_ope    in number,
                                     ln_sbop   in number,
                                     ln_tope   in number,
                                     lc_EsVinc out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais      in number,
                           ln_Petdoc      in number,
                           ln_Pendoc      in char,
                           tipocambio     in number,
                           ln_Correlativo in number,
                           ld_fchcorre    in date,
                           pd_fecpro      in date,
                           ln_captotcaja  in number,
                           saldo_externo  in number,
                           ln_ResultNeto  in number,
                           ln_MntCuoCntg  in number,
                           ln_MntPotncial in number,
                           ln_RatioPyme   in number,
                           lc_indicador   in varchar2,
                           lc_Usuario     in varchar2);

  -------------------------------------------------------
  procedure sp_cr_LogCuentas(lnPepais       in number,
                             lnPetdoc       in number,
                             lnPendoc       in char,
                             tipocambio     in number,
                             ln_Correlativo in number,
                             ld_fchcorre    in date,
                             pd_fecpro      in date,
                             ln_PGCOD       in number,
                             ln_MOD         in number,
                             ln_SUC         in number,
                             ln_MDA         in number,
                             ln_PAP         in number,
                             ln_CTA         in number,
                             ln_OPE         in number,
                             ln_SBOP        in number,
                             ln_TOPE        in number,
                             ln_peri10      in number,
                             ln_nrocuotas   in number,
                             ln_parciales   in number,
                             ln_flagFC      in varchar2,
                             ln_cuotimp     in number,
                             ln_seguro      in number,
                             ln_CapFC       in number,
                             CapLinea       in number,
                             ln_CAPCUO      in number,
                             lc_IndCred     IN VARCHAR2,
                             lc_Usuario     in varchar2);
  ------------------------------------------------------------- 
  procedure sp_cr_VerfLVInsertada(ln_corre      in number,
                                  ld_fchcorre   in date,
                                  lc_Estado     in varchar2,
                                  ln_pgcod117   number,
                                  ln_mod117     in number,
                                  ln_suc117     in number,
                                  ln_mda117     in number,
                                  ln_pap117     in number,
                                  ln_cta117     in number,
                                  ln_ope117     in number,
                                  ln_sbop117    in number,
                                  ln_tope117    in number,
                                  lc_RegInst116 out varchar2);

end PQ_CR_RATIOPYME_DTEN;
/

create or replace package body PQ_CR_RATIOPYME_DTEN is

  ------- RATIO CUOTA RESULTADO PARA DATA ENTRY

  procedure sp_CalculoRatio(ln_Pepais      in number,
                            ln_Petdoc      in number,
                            ln_Pendoc      in char,
                            ln_Correlativo in number,
                            ld_fchcorre    in date,
                            ln_Usuario     in varchar2,
                            ln_cuota       in number,
                            ln_captotcaja  out number,
                            saldo_externo  out number,
                            ln_ResultNeto  out number,
                            ln_MntPotncial out number,
                            ln_MntCuoCntg  out number,
                            ln_RatioPyme   out number) is
  
    cursor inserta_vencidos(pd_fecpro date) is
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
                  and modulo not in (29, 33, 200)))
         and d10.Aostat <> 99
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
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200)))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto < pd_fecpro;
  
    cursor inserta(pd_fecpro date) is
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
                  and modulo not in (29, 33, 200)) or d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro
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
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200)) or
             b.Aomod = 117)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto >= pd_fecpro;
  
    cursor vuelo(pd_fecpro date) is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
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
                  and modulo not in (29, 33, 200)) or x.xwfmodulo = 117)
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
                             to_date('2013.07.01', 'yyyy.mm.dd'))
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
         and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1'
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope
      union
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s, fsr002 c, fsr008 a
       where x.xwfempresa = 1
         and c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or x.xwfmodulo = 117)
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
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd'))
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
         and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1'
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope;
  
    cursor lineas_ven(pd_fecpro date) is
    
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
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor cred_propuesto is
      select 1            ln_pgcod10,
             j.jaqz697mod ln_mod10,
             j.jaqz697suc ln_suc10,
             j.jaqz697mda ln_mda10,
             0            ln_pap10,
             j.jaqz697cta ln_cta10,
             j.jaqz697opa ln_oper10,
             0            ln_sbop10,
             j.jaqz697top ln_tope10,
             j.jaqz697pzo ln_peri10,
             j.jaqz697cuo ln_nrocuotas
        from jaqz697 j
       where j.jaqz697fep = ld_fchcorre
         and j.jaqz697cor = ln_Correlativo
      /*and j.jaqz697tip = 'A'*/
      ;
  
    lc_IndCred        varchar2(10);
    ln_captotcaja1    number(17, 2) := 0.00;
    ln_captotcaja2    number(17, 2) := 0.00;
    ln_MntCuoCntgCF   number(17, 2) := 0.00;
    ln_MntCuoCntgAval number(17, 2) := 0.00;
    ln_periodo        number;
    pd_fecpro         date;
    tipocambio        number(14, 5) := 1;
    ln_capacidad      number(17, 2) := 0.00;
    ln_cajaext        number(17, 2) := 0.00;
    divisor           number(17, 2) := 0.00;
    lc_FlgLn          varchar2(2);
    lc_fgAdic         varchar2(1);
    lc_fgAmpl         varchar2(1);
    lc_ven            char(1);
    ln_indicador      number(10);
    lc_fgRefLin       varchar2(1);
    ln_captotal1      number(17, 6);
    lc_flgprg         varchar2(2);
    ln_NroEval        number := 0;
    ln_EsAliIntr      varchar2(5) := 'N';
    ln_mod            number;
    ln_tope           number;
    lc_EsVincAI       varchar2(5) := 'N';
    lc_IsInsert       varchar2(5) := 'N';
    ln_IngNeto        number(17, 2) := 0.00;
    ln_ModEva         number;
  
  begin
  
    ln_captotcaja := 0;
  
    begin
      select f.pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
    end;
  
    begin
      UPDATE jaqy140a j
         set j.jaqy140est = 'I'
       where j.JAQY140CORRLT = ln_Correlativo
         and j.jaqy140fcorr = ld_fchcorre
         and J.JAQY140EST = 'H';
    
      UPDATE JAQY142A Y
         SET Y.JAQY142EST = 'I'
       WHERE Y.JAQY142CORRLT = ln_Correlativo
         and y.jaqy142fcorr = ld_fchcorre
         AND Y.JAQY142EST = 'H';
      commit;
    end;
  
    begin
      select j.jaqz697mod, j.jaqz697top
        into ln_mod, ln_tope
        from jaqz697 j
       where j.jaqz697fep = ld_fchcorre
         and j.jaqz697cor = ln_Correlativo;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into ln_EsAliIntr
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 901
         and f.tp1corr2 = 4
         and f.tp1corr3 > 0
         and f.tp1nro2 = ln_mod
         and f.tp1nro3 = ln_tope;
    exception
      when others then
        ln_EsAliIntr := 'N';
    end;
  
    for i in inserta(pd_fecpro) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
      --  if i.ln_mod10 = 117 then
    
      PQ_CR_RATIOPYME_DTEN.sp_refinanLinea(i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIOPYME_DTEN.Sp_Adicional_CK(i.ln_mod10,
                                           i.ln_tope10,
                                           lc_fgAdic);
    
      PQ_CR_RATIOPYME_DTEN.Sp_ampliados_CK(i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           ln_Correlativo,
                                           ld_fchcorre,
                                           lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
      if ln_EsAliIntr = 'S' then
        pq_cr_ratiopyme_dten.sp_cr_VerfVincAliInterno(ln_pgcod  => i.ln_pgcod10,
                                                      ln_mod    => i.ln_mod10,
                                                      ln_suc    => i.ln_suc10,
                                                      ln_mda    => i.ln_mda10,
                                                      ln_pap    => i.ln_pap10,
                                                      ln_cta    => i.ln_cta10,
                                                      ln_ope    => i.ln_oper10,
                                                      ln_sbop   => i.ln_sbop10,
                                                      ln_tope   => i.ln_tope10,
                                                      lc_EsVinc => lc_EsVincAI);
      
      end if;
    
      if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and
         lc_FlgLn <> 'S' and i.ln_tope10 <> 550 and lc_EsVincAI = 'N' then
        PQ_CR_RATIOPYME_DTEN.sp_resolutor(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          ln_Correlativo,
                                          ld_fchcorre,
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
                                          i.ln_peri10,
                                          tipocambio,
                                          ln_indicador,
                                          lc_IndCred,
                                          ln_Usuario,
                                          ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for i in inserta_vencidos(pd_fecpro) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      --  if i.ln_mod10 = 117 then
    
      PQ_CR_RATIOPYME_DTEN.sp_refinanLinea(i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIOPYME_DTEN.Sp_Adicional_CK(i.ln_mod10,
                                           i.ln_tope10,
                                           lc_fgAdic);
      PQ_CR_RATIOPYME_DTEN.Sp_ampliados_CK(i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           ln_Correlativo,
                                           ld_fchcorre,
                                           lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 lc_FlgLn);
      if ln_EsAliIntr = 'S' then
        pq_cr_ratiopyme_dten.sp_cr_VerfVincAliInterno(ln_pgcod  => i.ln_pgcod10,
                                                      ln_mod    => i.ln_mod10,
                                                      ln_suc    => i.ln_suc10,
                                                      ln_mda    => i.ln_mda10,
                                                      ln_pap    => i.ln_pap10,
                                                      ln_cta    => i.ln_cta10,
                                                      ln_ope    => i.ln_oper10,
                                                      ln_sbop   => i.ln_sbop10,
                                                      ln_tope   => i.ln_tope10,
                                                      lc_EsVinc => lc_EsVincAI);
      
      end if;
    
      if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and
         lc_FlgLn <> 'S' and i.ln_tope10 <> 550 and lc_EsVincAI = 'N' then
        PQ_CR_RATIOPYME_DTEN.sp_resolutor(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          ln_Correlativo,
                                          ld_fchcorre,
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
                                          i.ln_peri10,
                                          tipocambio,
                                          ln_indicador,
                                          lc_IndCred,
                                          ln_Usuario,
                                          ln_capacidad);
      
        --ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for c in vuelo(pd_fecpro) loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      ln_periodo := c.ln_peri10;
    
      begin
        select max(tp1imp1)
          into ln_periodo
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10801
           and tp1corr1 = 54
           and tp1corr2 = 1
           and tp1corr3 > 0
           and tp1nro2 = c.ln_mod10
           and tp1nro3 = c.ln_tope10;
      exception
        when no_data_found then
          ln_periodo := c.ln_peri10;
      end;
    
      ln_periodo := nvl(ln_periodo, 0);
    
      if ln_periodo = 0 then
        -- mpostigoc 11052020
      
        begin
          select x.xllperiodo
            into ln_periodo
            from x054023 x
           where x.xllpgcod = c.ln_pgcod10
             and x.xllaomod = c.ln_mod10
             and x.xllaosuc = c.ln_suc10
             and x.xllaomda = c.ln_mda10
             and x.xllaopap = c.ln_pap10
             and x.xllaocta = c.ln_cta10
             and x.xllaooper = c.ln_oper10
             and x.xllaosbop = c.ln_sbop10
             and x.xllaotop = c.ln_tope10;
        exception
          when others then
            ln_periodo := 30;
        end;
      end if;
    
      PQ_CR_RATIOPYME_DTEN.Sp_Adicional_CK(c.ln_mod10,
                                           c.ln_tope10,
                                           lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        PQ_CR_RATIOPYME_DTEN.sp_resolutor(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          ln_Correlativo,
                                          ld_fchcorre,
                                          pd_fecpro,
                                          c.ln_pgcod10,
                                          c.ln_mod10,
                                          c.ln_suc10,
                                          c.ln_mda10,
                                          c.ln_pap10,
                                          c.ln_cta10,
                                          c.ln_oper10,
                                          c.ln_sbop10,
                                          c.ln_tope10,
                                          ln_periodo,
                                          tipocambio,
                                          ln_indicador,
                                          lc_IndCred,
                                          ln_Usuario,
                                          ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven(pd_fecpro) loop
    
      lc_IndCred := 'LineaVencd';
    
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
    
      PQ_CR_RATIOPYME_DTEN.Sp_Adicional_CK(j.ln_mod10,
                                           j.ln_tope10,
                                           lc_fgAdic);
    
      PQ_CR_RATIOPYME_DTEN.sp_refinanLinea(J.ln_pgcod10,
                                           J.ln_mod10,
                                           J.ln_suc10,
                                           J.ln_mda10,
                                           J.ln_pap10,
                                           J.ln_cta10,
                                           J.ln_oper10,
                                           lc_fgRefLin);
    
      PQ_CR_RATIOPYME_DTEN.Sp_ampliados_CK(j.ln_pgcod10,
                                           j.ln_mod10,
                                           j.ln_suc10,
                                           j.ln_mda10,
                                           j.ln_pap10,
                                           j.ln_cta10,
                                           j.ln_oper10,
                                           j.ln_sbop10,
                                           j.ln_tope10,
                                           ln_Correlativo,
                                           ld_fchcorre,
                                           lc_fgAmpl);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(j.ln_mod10,
                                                 j.ln_suc10,
                                                 j.ln_mda10,
                                                 j.ln_pap10,
                                                 j.ln_cta10,
                                                 j.ln_oper10,
                                                 j.ln_sbop10,
                                                 j.ln_tope10,
                                                 lc_FlgLn);
      if ln_EsAliIntr = 'S' then
        pq_cr_ratiopyme_dten.sp_cr_VerfVincAliInterno(ln_pgcod  => j.ln_pgcod10,
                                                      ln_mod    => j.ln_mod10,
                                                      ln_suc    => j.ln_suc10,
                                                      ln_mda    => j.ln_mda10,
                                                      ln_pap    => j.ln_pap10,
                                                      ln_cta    => j.ln_cta10,
                                                      ln_ope    => j.ln_oper10,
                                                      ln_sbop   => j.ln_sbop10,
                                                      ln_tope   => j.ln_tope10,
                                                      lc_EsVinc => lc_EsVincAI);
      
      end if;
    
      if lc_ven = 'S' then
        Pq_Cr_Ratiopyme_Dten.sp_cr_VerfLVInsertada(ln_corre      => ln_Correlativo,
                                                   ld_fchcorre   => ld_fchcorre,
                                                   lc_Estado     => lc_flgprg,
                                                   ln_pgcod117   => 1,
                                                   ln_mod117     => j.ln_mod10,
                                                   ln_suc117     => j.ln_suc10,
                                                   ln_mda117     => j.ln_mda10,
                                                   ln_pap117     => j.ln_pap10,
                                                   ln_cta117     => j.ln_cta10,
                                                   ln_ope117     => j.ln_oper10,
                                                   ln_sbop117    => j.ln_sbop10,
                                                   ln_tope117    => j.ln_tope10,
                                                   lc_RegInst116 => lc_IsInsert);
      end if;
    
      if lc_ven = 'S' and lc_IsInsert = 'N' and lc_fgAdic <> 'S' and
         lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' and
         lc_EsVincAI = 'N' then
        PQ_CR_RATIOPYME_DTEN.sp_resolutor_venc(ln_Pepais,
                                               ln_Petdoc,
                                               ln_Pendoc,
                                               ln_Correlativo,
                                               ld_fchcorre,
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
                                               tipocambio,
                                               lc_IndCred,
                                               ln_Usuario,
                                               ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for p in cred_propuesto loop
      PQ_CR_RATIOPYME_DTEN.sp_resolutor_prop(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             ln_Correlativo,
                                             ld_fchcorre,
                                             pd_fecpro,
                                             p.ln_pgcod10,
                                             p.ln_mod10,
                                             p.ln_suc10,
                                             p.ln_mda10,
                                             p.ln_pap10,
                                             p.ln_cta10,
                                             p.ln_oper10,
                                             p.ln_sbop10,
                                             p.ln_tope10,
                                             p.ln_peri10,
                                             p.ln_nrocuotas,
                                             tipocambio,
                                             'CredProp',
                                             ln_Usuario,
                                             ln_cuota,
                                             ln_capacidad);
    end loop;
  
    -- Cuota CMAC
  
    begin
      select sum(j.JAQY142CAPCUO)
        into ln_captotcaja1
        from jaqy142a j
       where j.JAQY142CORRLT = ln_Correlativo
         and j.jaqy142fcorr = ld_fchcorre
         and j.JAQY142est = 'H'
         and (j.jaqy142mod not in
             (select tp1nro1
                 from fst198 a
                where a.tp1cod = 1
                  and a.tp1cod1 = 10899
                  and a.tp1corr1 = 13
                  and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 24.08.2022
         and j.JAQY142nrcuo > 1
         and j.JAQY142indic in ('CredVigent',
                                'CredVencid',
                                'CredVuelo',
                                'LineaVencd',
                                'CredProp');
    exception
      when others then
        ln_captotcaja1 := 0;
    end;
  
    begin
      select sum(j.jaqy142capcuo)
        into ln_captotcaja2
        from jaqy142a j
       where j.jaqy142CORRLT = ln_Correlativo
         and j.jaqy142fcorr = ld_fchcorre
         and j.jaqy142est = 'H'
         and j.jaqy142mod = 117
         and j.jaqy142indic in ( /*'CredVigent',
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               'CredVencid',*/'CredVuelo',
                                'LineaVencd',
                                'CredProp'); --mpostigoc 24.08.2022
    exception
      when others then
        ln_captotcaja2 := 0;
    end;
  
    ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
  
    begin
      -- Cuota Contingente PRY1574 
      PQ_CR_RATIOPYME_DTEN.sp_cr_CuotaContinCF(ln_Correlativo,
                                               ld_fchcorre,
                                               pd_fecpro,
                                               lc_flgprg,
                                               ln_MntCuoCntgCF);
    
      PQ_CR_RATIOPYME_DTEN.sp_cr_CuotaContinAval(ln_Correlativo,
                                                 ld_fchcorre,
                                                 pd_fecpro,
                                                 lc_flgprg,
                                                 ln_MntCuoCntgAval);
    
      ln_MntCuoCntg := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
    end;
  
    begin
      -- Deuda IFIS y Cuota Potencial
      begin
        select y.jaqz697eva, y.jaqz697moe
          into ln_NroEval, ln_ModEva
          from jaqz697 y
         where y.jaqz697fep = ld_fchcorre
           and y.jaqz697cor = ln_Correlativo
        /*and y.jaqz697tip = 'A'*/
        ;
      exception
        when others then
          ln_NroEval := 0;
      end;
      begin
      
        PQ_CR_RATIOPYME_DTEN.sp_cR_y327bdj(ln_NroEval,
                                           tipocambio,
                                           saldo_externo,
                                           ln_MntPotncial);
      end;
    end;
  
    -- mpostigoc 03.07.21 
    -- saldo_externo := nvl(saldo_externo, 0) - nvl(ln_MntPotncial, 0);
  
    begin
      -- Suma de Deuda Caja y Deuda Externa
    
      ln_cajaext := nvl(ln_captotcaja, 0) + nvl(saldo_externo, 0) +
                    nvl(ln_MntCuoCntg, 0) + nvl(ln_MntPotncial, 0);
    end;
  
    begin
      --- Excedente Mensual
      PQ_CR_RATIOPYME_DTEN.sp_cr_ExcdntMnsual(ln_NroEval,
                                              tipocambio,
                                              ln_ResultNeto,
                                              ln_IngNeto);
    end;
  
    begin
    
      if ln_ModEva = 13 then
        Divisor := nvl(ln_ResultNeto, 0) + nvl(saldo_externo, 0) +
                   nvl(ln_MntPotncial, 0);
      else
        if ln_ModEva = 14 then
          Divisor       := ln_IngNeto;
          ln_ResultNeto := ln_IngNeto;
        end if;
      end if;
    end;
  
    if Divisor <> 0 then
      ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    ln_RatioPyme := nvl(ln_captotal1, 0);
  
    PQ_CR_RATIOPYME_DTEN.sp_cr_LogRatio(ln_Pepais      => ln_Pepais,
                                        ln_Petdoc      => ln_Petdoc,
                                        ln_Pendoc      => ln_Pendoc,
                                        tipocambio     => tipocambio,
                                        ln_Correlativo => ln_Correlativo,
                                        ld_fchcorre    => ld_fchcorre,
                                        pd_fecpro      => pd_fecpro,
                                        ln_captotcaja  => ln_captotcaja,
                                        saldo_externo  => saldo_externo,
                                        ln_ResultNeto  => ln_ResultNeto,
                                        ln_MntCuoCntg  => ln_MntCuoCntg,
                                        ln_MntPotncial => ln_MntPotncial,
                                        ln_RatioPyme   => ln_RatioPyme,
                                        lc_indicador   => 'CS',
                                        lc_Usuario     => ln_Usuario);
  
  end sp_CalculoRatio;
  -------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Correlativo  in number,
                                ld_fchcorre     in date,
                                pd_fecpro       in date,
                                lc_flgprg       in varchar2,
                                ln_MntCuoCntgCF out number) is
  
    cursor lista_CredVigCF(ln_pais number,
                           ln_tdoc number,
                           lc_ndoc varchar2) is
    
      select distinct d10.pgcod    ln_pgcod10,
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
         and d10.Aocta in (select f.Ctnro
                             from jaqz697 j, fsr008 f
                            where j.jaqz697fep = ld_fchcorre
                              and j.jaqz697cor = ln_Correlativo
                              and j.jaqz697pai = f.pepais
                              and j.jaqz697tdo = f.Petdoc
                              and j.jaqz697ndo = f.pendoc
                              and f.cttfir = 'T')
         and d10.Aomod = 141
         and d10.Aostat <> 99;
  
    cursor lista_CredvueloCF(ln_pais number,
                             ln_tdoc number,
                             lc_ndoc varchar2) is
    
      select distinct x.xwfempresa   ln_pgcod10,
                      x.xwfmodulo    ln_mod10,
                      x.xwfsucursal  ln_suc10,
                      x.xwfmoneda    ln_mda10,
                      x.xwfpapel     ln_pap10,
                      x.xwfcuenta    ln_cta10,
                      x.xwfoperacion ln_oper10,
                      x.xwfsubope    ln_sbop10,
                      x.xwftipope    ln_tope10,
                      x.xwfprcins    ln_InstAvalada
        from xwf700 x, wfwrkitems w
       where x.xwfempresa = 1
         and x.xwfcuenta in (select f.Ctnro
                               from jaqz697 j, fsr008 f
                              where j.jaqz697fep = ld_fchcorre
                                and j.jaqz697cor = ln_Correlativo
                                and j.jaqz697pai = f.pepais
                                and j.jaqz697tdo = f.Petdoc
                                and j.jaqz697ndo = f.pendoc
                                and f.cttfir = 'T')
            
         and x.xwfmodulo = 141
         and x.XWFPRCINS = w.wfinsprcid
         and w.wfitemstsact = 1
         and x.xwfcar3 = '1';
  
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        number;
    ln_CuotCntgAux number;
    ln_SaldCap     number;
    ln_tipocambio  number;
    lc_Usuario     varchar2(10);
    --  pd_fecpro      date;
    ln_Tarea  number;
    ln_moneda number;
  
  begin
    ln_MntCuoCntgCF := 0;
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Correlativo;
    exception
      when others then
        null;
    end;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod), w.wftaskcod
        into lc_Usuario, ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Correlativo
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Correlativo
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    /* begin
      select pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    end;*/
  
    if ln_pais is not null then
    
      for l in lista_CredVigCF(ln_pais, ln_tdoc, lc_ndoc) loop
        begin
          select f.scsdo * -1
            into ln_SaldCap
            from fsd011 f
           where f.pgcod = l.ln_pgcod10
             and f.scsuc = l.ln_suc10
             and f.scmda = l.ln_mda10
             and f.scpap = l.ln_pap10
             and f.sccta = l.ln_cta10
             and f.scoper = l.ln_oper10
             and f.scsbop = l.ln_sbop10
             and f.sctope = l.ln_tope10;
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if l.ln_mda10 = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        -- if lc_flgprg = 'S' or lc_flgprg = 'R' then
        begin
          PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_pais,
                                                ln_tdoc,
                                                lc_ndoc,
                                                ln_tipocambio,
                                                ln_Correlativo,
                                                ld_fchcorre,
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
                                                l.ln_peri10,
                                                0,
                                                0,
                                                0,
                                                ln_SaldCap,
                                                0,
                                                0,
                                                0,
                                                ln_CuotCntgAux,
                                                'CredVgntCF',
                                                lc_Usuario);
        end;
        --end if;
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloCF(ln_pais, ln_tdoc, lc_ndoc) loop
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_InstAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        -- if lc_flgprg = 'S' or lc_flgprg = 'R' then
        begin
          PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_pais,
                                                ln_tdoc,
                                                lc_ndoc,
                                                ln_tipocambio,
                                                ln_Correlativo,
                                                ld_fchcorre,
                                                pd_fecpro,
                                                v.ln_pgcod10,
                                                v.ln_mod10,
                                                v.ln_suc10,
                                                v.ln_mda10,
                                                v.ln_pap10,
                                                v.ln_cta10,
                                                v.ln_oper10,
                                                v.ln_sbop10,
                                                v.ln_tope10,
                                                999,
                                                0,
                                                0,
                                                0,
                                                ln_SaldCap,
                                                0,
                                                0,
                                                0,
                                                ln_CuotCntgAux,
                                                'CredVuelCF',
                                                lc_Usuario);
        end;
        -- end if;
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Correlativo    in number,
                                  ld_fchcorre       in date,
                                  pd_fecpro         in date,
                                  lc_flgprg         in varchar2,
                                  ln_MntCuoCntgAval out number) is
  
    cursor lista_CredVigAval(ln_pais number,
                             ln_tdoc number,
                             lc_doc  varchar2) is
      select distinct h.pgcod  ln_pgcod10,
                      h.aomod  ln_mod10,
                      h.aosuc  ln_suc10,
                      h.aomda  ln_mda10,
                      h.aopap  ln_pap10,
                      h.aocta  ln_cta10,
                      h.aooper ln_oper10,
                      h.aosbop ln_sbop10,
                      h.aotope ln_tope10
        from sng003 g, xwf700 x, fsd010 h
       where g.sng003cta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_doc
                                and f.cttfir = 'T')
         and g.sng001inst = x.xwfprcins
         and x.xwfcar3 = '1'
         and x.xwfempresa = h.pgcod
         and x.xwfsucursal = h.aosuc
         and x.xwfmodulo = h.aomod
         and x.xwfmoneda = h.aomda
         and x.xwfpapel = h.aopap
         and x.xwfcuenta = h.aocta
         and x.xwfoperacion = h.aooper
         and x.xwfsubope = h.aosbop
         and x.xwftipope = h.aotope
         and (x.xwfmodulo in
             (select k.modulo
                 from fst111 k
                where k.dscod = 50
                  and k.modulo not in (33, 200)) or
             x.xwfmodulo in (117, 141))
         and h.aostat <> 99;
  
    cursor lista_CredvueloAval(ln_pais number,
                               ln_tdoc number,
                               lc_doc  varchar2) is
    
      select distinct x.xwfempresa   ln_pgcod10,
                      x.xwfsucursal  ln_suc10,
                      x.xwfmodulo    ln_mod10,
                      x.xwfmoneda    ln_mda10,
                      x.xwfpapel     ln_pap10,
                      x.xwfcuenta    ln_cta10,
                      x.xwfoperacion ln_oper10,
                      x.xwfsubope    ln_sbop10,
                      x.xwftipope    ln_tope10,
                      x.xwfprcins    ln_ln_CorrelativoAvalada
        from sng003 g, xwf700 x, wfwrkitems w
       where g.sng003cta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_doc
                                and f.cttfir = 'T')
         and g.sng001inst = x.xwfprcins
         and x.xwfcar3 = '1'
         and x.xwfprcins = w.wfinsprcid
         and (x.xwfmodulo in
             (select k.modulo
                 from fst111 k
                where k.dscod = 50
                  and k.modulo not in (33, 200)) or
             x.xwfmodulo in (117, 141))
         and w.wfitemstsact = 1;
  
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ln_paiscy      number;
    ln_tdoccy      number;
    lc_ndoccy      varchar2(12);
    ln_CuotCntgAux number;
    ln_SaldCap     number;
    ln_tipocambio  number;
    lc_Usuario     varchar2(10);
    ln_moneda      number;
    lc_verfamp     varchar2(2) := 'N';
    lc_vrfrefrep   varchar2(2) := 'N';
    lc_verfvinc    varchar2(2) := 'N';
    ln_EsConsd     number;
  
  begin
    ln_MntCuoCntgAval := 0;
  
    begin
      -- Datos del Titular
      select s.jaqz697pai, s.jaqz697tdo, s.jaqz697ndo
        into ln_pais, ln_tdoc, lc_ndoc
        from JAQZ697 s
       where s.jaqz697cor = ln_Correlativo
         and s.jaqz697fep = ld_fchcorre;
    exception
      when others then
        null;
    end;
  
    begin
      --- Datos del Cnyuge
      select f.rppais, f.rptdoc, f.rpndoc
        into ln_paiscy, ln_tdoccy, lc_ndoccy
        from fsr002 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.rpccyg = 66;
    exception
      when no_data_found then
        begin
          select f.rppais, f.rptdoc, f.rpndoc
            into ln_paiscy, ln_tdoccy, lc_ndoccy
            from fsr002 f
           where f.rppais = ln_pais
             and f.rptdoc = ln_tdoc
             and f.rpndoc = lc_ndoc
             and f.rpccyg = 66;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    begin
      ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
    
    end;
  
    if ln_pais is not null then
    
      for l in lista_CredVigAval(ln_pais, ln_tdoc, lc_ndoc) loop
      
        ln_SaldCap := 0;
      
        PQ_CR_RATIOPYME_DTEN.Sp_ampliados_CK(ln_emp10       => l.ln_pgcod10,
                                             ln_mod10       => l.ln_mod10,
                                             ln_suc10       => l.ln_suc10,
                                             ln_mda10       => l.ln_mda10,
                                             ln_pap10       => l.ln_pap10,
                                             ln_cta10       => l.ln_cta10,
                                             ln_oper10      => l.ln_oper10,
                                             ln_sbop10      => l.ln_sbop10,
                                             ln_tope10      => l.ln_tope10,
                                             ln_correlativo => ln_Correlativo,
                                             ld_fchcorre    => ld_fchcorre,
                                             Pc_flag        => lc_verfamp);
      
        PQ_CR_RATIOPYME_DTEN.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
                                             ln_mod10    => l.ln_mod10,
                                             ln_suc10    => l.ln_suc10,
                                             ln_mda10    => l.ln_mda10,
                                             ln_pap10    => l.ln_pap10,
                                             ln_cta10    => l.ln_cta10,
                                             ln_oper10   => l.ln_oper10,
                                             lc_fgRefLin => lc_vrfrefrep);
      
        pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => l.ln_mod10,
                                                   ln_suc10  => l.ln_suc10,
                                                   ln_mda10  => l.ln_mda10,
                                                   ln_pap10  => l.ln_pap10,
                                                   ln_cta10  => l.ln_cta10,
                                                   ln_oper10 => l.ln_oper10,
                                                   ln_sbop10 => l.ln_sbop10,
                                                   ln_tope10 => l.ln_tope10,
                                                   lc_FlgLn  => lc_verfvinc);
      
        if lc_verfamp = 'N' and lc_vrfrefrep = 'N' and lc_verfvinc = 'N' then
        
          if l.ln_mod10 <> 117 then
            begin
              select f.scsdo
                into ln_SaldCap
                from fsd011 f
               where f.pgcod = l.ln_pgcod10
                 and f.scsuc = l.ln_suc10
                 and f.scmda = l.ln_mda10
                 and f.scpap = l.ln_pap10
                 and f.sccta = l.ln_cta10
                 and f.scoper = l.ln_oper10
                 and f.scsbop = l.ln_sbop10
                 and f.sctope = l.ln_tope10;
            exception
              when others then
                ln_SaldCap := 0;
            end;
          
            if ln_SaldCap < 0 then
              ln_SaldCap := ln_SaldCap * -1;
            end if; --mpostigoc 08/07/2019
          
            if l.ln_mda10 = 101 then
              ln_SaldCap := ln_SaldCap * ln_tipocambio;
            end if;
          
          else
            if l.ln_mod10 = 117 then
              begin
                select x.xwfmonto1
                  into ln_SaldCap
                  from xwf700 x
                 where x.xwfempresa = l.ln_pgcod10
                   and x.xwfsucursal = l.ln_suc10
                   and x.xwfmodulo = l.ln_mod10
                   and x.xwfmoneda = l.ln_mda10
                   and x.xwfpapel = l.ln_pap10
                   and x.xwfcuenta = l.ln_cta10
                   and x.xwfoperacion = l.ln_oper10
                   and x.xwfsubope = l.ln_sbop10
                   and x.xwftipope = l.ln_tope10
                   and x.xwfcar3 = '1';
              exception
                when others then
                  ln_SaldCap := 0;
              end;
            
              if ln_SaldCap < 0 then
                ln_SaldCap := ln_SaldCap * -1;
              end if; --mpostigoc 08/07/2019
            
              if l.ln_mda10 = 101 then
                ln_SaldCap := ln_SaldCap * ln_tipocambio;
              end if;
            end if;
          end if;
        
          ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
        
          if /*(lc_flgprg = 'S' or lc_flgprg = 'R') and*/
           ln_saldcap > 0 then
            begin
              PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_pais,
                                                    ln_tdoc,
                                                    lc_ndoc,
                                                    ln_tipocambio,
                                                    ln_Correlativo,
                                                    ld_fchcorre,
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
                                                    999,
                                                    0,
                                                    0,
                                                    'N',
                                                    ln_SaldCap,
                                                    0,
                                                    0,
                                                    0,
                                                    ln_CuotCntgAux,
                                                    'CredVgnAvl',
                                                    lc_Usuario);
            end;
          end if;
        
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
        end if;
      end loop;
    
      for v in lista_CredvueloAval(ln_pais, ln_tdoc, lc_ndoc) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_ln_CorrelativoAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_SaldCap < 0 then
          ln_SaldCap := ln_SaldCap * -1;
        end if; --mpostigoc 08/07/2019
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        begin
          PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_pais,
                                                ln_tdoc,
                                                lc_ndoc,
                                                ln_tipocambio,
                                                ln_Correlativo,
                                                ld_fchcorre,
                                                pd_fecpro,
                                                v.ln_pgcod10,
                                                v.ln_mod10,
                                                v.ln_suc10,
                                                v.ln_mda10,
                                                v.ln_pap10,
                                                v.ln_cta10,
                                                v.ln_oper10,
                                                v.ln_sbop10,
                                                v.ln_tope10,
                                                999,
                                                0,
                                                0,
                                                'N',
                                                ln_SaldCap,
                                                0,
                                                0,
                                                0,
                                                ln_CuotCntgAux,
                                                'CredVlAval',
                                                lc_Usuario);
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
    if ln_paiscy is not null then
    
      for l in lista_CredVigAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        if lc_flgprg = 'S' then
          begin
            select count(*)
              into ln_EsConsd
              from JAQY142A j
             where j.JAQY142pgcod = l.ln_pgcod10
               and j.JAQY142mod = l.ln_mod10
               and j.JAQY142suc = l.ln_suc10
               and j.JAQY142mda = l.ln_mda10
               and j.JAQY142pap = l.ln_pap10
               and j.JAQY142cta = l.ln_cta10
               and j.JAQY142ope = l.ln_oper10
               and j.JAQY142sbop = l.ln_sbop10
               and j.JAQY142tope = l.ln_tope10
               and j.jaqy142fec = pd_fecpro
               and j.jaqy142corrlt = ln_Correlativo
               and j.jaqy142fcorr = ld_fchcorre
               and j.JAQY142est = 'H';
          exception
            when others then
              null;
          end;
        else
          if lc_flgprg = 'R' then
          
            begin
              select count(*)
                into ln_EsConsd
                from JAQY142A j
               where j.JAQY142pgcod = l.ln_pgcod10
                 and j.JAQY142mod = l.ln_mod10
                 and j.JAQY142suc = l.ln_suc10
                 and j.JAQY142mda = l.ln_mda10
                 and j.JAQY142pap = l.ln_pap10
                 and j.JAQY142cta = l.ln_cta10
                 and j.JAQY142ope = l.ln_oper10
                 and j.JAQY142sbop = l.ln_sbop10
                 and j.JAQY142tope = l.ln_tope10
                 and j.jaqy142fec = pd_fecpro
                 and j.jaqy142corrlt = ln_Correlativo
                 and j.jaqy142fcorr = ld_fchcorre
                 and j.JAQY142est = 'R';
            exception
              when others then
                null;
            end;
          
          end if;
        end if;
      
        if ln_EsConsd = 0 then
        
          PQ_CR_RATIOPYME_DTEN.Sp_ampliados_CK(ln_emp10       => l.ln_pgcod10,
                                               ln_mod10       => l.ln_mod10,
                                               ln_suc10       => l.ln_suc10,
                                               ln_mda10       => l.ln_mda10,
                                               ln_pap10       => l.ln_pap10,
                                               ln_cta10       => l.ln_cta10,
                                               ln_oper10      => l.ln_oper10,
                                               ln_sbop10      => l.ln_sbop10,
                                               ln_tope10      => l.ln_tope10,
                                               ln_correlativo => ln_Correlativo,
                                               ld_fchcorre    => ld_fchcorre,
                                               Pc_flag        => lc_verfamp);
        
          PQ_CR_RATIOPYME_DTEN.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
                                               ln_mod10    => l.ln_mod10,
                                               ln_suc10    => l.ln_suc10,
                                               ln_mda10    => l.ln_mda10,
                                               ln_pap10    => l.ln_pap10,
                                               ln_cta10    => l.ln_cta10,
                                               ln_oper10   => l.ln_oper10,
                                               lc_fgRefLin => lc_vrfrefrep);
        
          pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => l.ln_mod10,
                                                     ln_suc10  => l.ln_suc10,
                                                     ln_mda10  => l.ln_mda10,
                                                     ln_pap10  => l.ln_pap10,
                                                     ln_cta10  => l.ln_cta10,
                                                     ln_oper10 => l.ln_oper10,
                                                     ln_sbop10 => l.ln_sbop10,
                                                     ln_tope10 => l.ln_tope10,
                                                     lc_FlgLn  => lc_verfvinc);
        
          if lc_verfamp = 'N' and lc_vrfrefrep = 'N' and lc_verfvinc = 'N' then
          
            if l.ln_mod10 <> 117 then
              begin
                select f.scsdo
                  into ln_SaldCap
                  from fsd011 f
                 where f.pgcod = l.ln_pgcod10
                   and f.scsuc = l.ln_suc10
                   and f.scmda = l.ln_mda10
                   and f.scpap = l.ln_pap10
                   and f.sccta = l.ln_cta10
                   and f.scoper = l.ln_oper10
                   and f.scsbop = l.ln_sbop10
                   and f.sctope = l.ln_tope10;
              exception
                when others then
                  ln_SaldCap := 0;
              end;
            
              if ln_SaldCap < 0 then
                ln_SaldCap := ln_SaldCap * -1;
              end if; --mpostigoc 08/07/2019
            
              if l.ln_mda10 = 101 then
                ln_SaldCap := ln_SaldCap * ln_tipocambio;
              end if;
            
            else
              if l.ln_mod10 = 117 then
                begin
                  select x.xwfmonto1
                    into ln_SaldCap
                    from xwf700 x
                   where x.xwfempresa = l.ln_pgcod10
                     and x.xwfsucursal = l.ln_suc10
                     and x.xwfmodulo = l.ln_mod10
                     and x.xwfmoneda = l.ln_mda10
                     and x.xwfpapel = l.ln_pap10
                     and x.xwfcuenta = l.ln_cta10
                     and x.xwfoperacion = l.ln_oper10
                     and x.xwfsubope = l.ln_sbop10
                     and x.xwftipope = l.ln_tope10
                     and x.xwfcar3 = '1';
                exception
                  when others then
                    ln_SaldCap := 0;
                end;
              
                if ln_SaldCap < 0 then
                  ln_SaldCap := ln_SaldCap * -1;
                end if; --mpostigoc 08/07/2019
              
                if l.ln_mda10 = 101 then
                  ln_SaldCap := ln_SaldCap * ln_tipocambio;
                end if;
              end if;
            end if;
          
            ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
          
            if /*(lc_flgprg = 'S' or lc_flgprg = 'R') and*/
             ln_SaldCap > 0 then
              begin
                PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_pais,
                                                      ln_tdoc,
                                                      lc_ndoc,
                                                      ln_tipocambio,
                                                      ln_Correlativo,
                                                      ld_fchcorre,
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
                                                      999,
                                                      0,
                                                      0,
                                                      'N',
                                                      ln_SaldCap,
                                                      0,
                                                      0,
                                                      0,
                                                      ln_CuotCntgAux,
                                                      'CredVgnAvl',
                                                      lc_Usuario);
              end;
            end if;
          
            ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
          end if;
        end if;
      end loop;
    
      for v in lista_CredvueloAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_ln_CorrelativoAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_SaldCap < 0 then
          ln_SaldCap := ln_SaldCap * -1;
        end if; --mpostigoc 08/07/2019
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        begin
          PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_pais,
                                                ln_tdoc,
                                                lc_ndoc,
                                                ln_tipocambio,
                                                ln_Correlativo,
                                                ld_fchcorre,
                                                pd_fecpro,
                                                v.ln_pgcod10,
                                                v.ln_mod10,
                                                v.ln_suc10,
                                                v.ln_mda10,
                                                v.ln_pap10,
                                                v.ln_cta10,
                                                v.ln_oper10,
                                                v.ln_sbop10,
                                                v.ln_tope10,
                                                999,
                                                0,
                                                0,
                                                'N',
                                                ln_SaldCap,
                                                0,
                                                0,
                                                0,
                                                ln_CuotCntgAux,
                                                'CredVlAval',
                                                lc_Usuario);
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    end if;
  
  end sp_cr_CuotaContinAval;
  --------------------------------------------------------------------------------
  procedure sp_cR_y327bdj(ln_NroEval     in number,
                          ln_TipoCamb    in number,
                          ln_DeudaIFIS   out number,
                          ln_MntPotncial out number) is
  
    saldo_extSoles number(17, 2) := 0.00;
    saldo_extDol   number(17, 2) := 0.00;
  
  begin
  
    ln_MntPotncial := 0;
    begin
      -- Deuda IFIS
      begin
        --MPOSTIGOC 04/10/18 INC1373
        -- actualizamos los ultimos valores que se tienen para la tarea de Evaluacion/Propuesta contabilizados
        -- con una marca en R
        update jaqy327_bdj j
           set j.jaqy327aux3 = 'R'
         where j.jaqy327neva = ln_NroEval
           and j.jaqy327esta = 'S'
           and j.jaqy327chek = '1'
           and j.jaqy327aux1 = 7; --Tarea de Evaluacion Propuesta
        commit;
      end;
      begin
        select sum(j.jaqy327gfin)
          into saldo_extSoles
          from jaqy327_bdj j
         where j.jaqy327neva = ln_NroEval
           and j.jaqy327esta = 'S'
           and j.jaqy327chek = '1'
           and j.jaqy327tcre in
               ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
           and j.jaqy327aux3 = 'R'
           and j.jaqy327aux1 = 7;
      exception
        when others then
          saldo_extSoles := 0;
      end;
    
      begin
        begin
          select sum(j.jaqy327gfin)
            into saldo_extDol
            from jaqy327_bdj j
           where j.jaqy327neva = ln_NroEval
             and j.jaqy327esta = 'S'
             and j.jaqy327chek = '1'
             and j.jaqy327tcre in
                 ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
             and j.jaqy327aux3 = 'R'
             and j.jaqy327aux1 = 7;
        exception
          when others then
            saldo_extDol := 0;
        end;
      
        saldo_extDol := nvl(saldo_extDol, 0) * ln_TipoCamb;
      end;
      ln_DeudaIFIS := nvl(saldo_extDol, 0) + nvl(saldo_extSoles, 0);
    end;
  
    Begin
    
      select sum(j.jaqy327cptn)
        into ln_MntPotncial
        from jaqy327_bdj j
       where j.jaqy327neva = ln_NroEval
         and j.jaqy327esta = 'S'
         and j.jaqy327chek = '1'
         and j.jaqy327flin = 'L';
    exception
      when others then
        ln_MntPotncial := 0;
    end;
    ln_MntPotncial := nvl(ln_MntPotncial, 0);
  
  end sp_cR_y327bdj;
  ------------------------------------------------------------------------------
  procedure sp_cr_ExcdntMnsual(ln_eval       in number,
                               ln_TipCamb    in number,
                               ln_ResultNeto out number,
                               ln_IngNeto    out number) is
  
    mntsoles      number(17, 2) := 0.00;
    mntdolar      number(17, 2) := 0.00;
    ln_IngNetoSol number(17, 2) := 0.00;
    ln_IngNetoDol number(17, 2) := 0.00;
  
  begin
  
    begin
      select a.aqpa190bmto
        into mntsoles
        from aqpa190b_bdj a
       where a.aqpa190beval = ln_eval
         and a.aqpa190bcod = 40;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpa190bmto
        into mntdolar
        from aqpa190b_bdj a
       where a.aqpa190beval = ln_eval
         and a.aqpa190bcod = 540;
    exception
      when others then
        null;
    end;
  
    mntsoles := nvl(mntsoles, 0);
    mntdolar := nvl(mntdolar, 0);
  
    if mntsoles = 0 and mntdolar = 0 then
      begin
        select a.aqpa190bmto
          into mntsoles
          from aqpa190b_bdj a
         where a.aqpa190beval = ln_eval
           and a.aqpa190bcod = 27;
      exception
        when others then
          null;
      end;
    
      begin
        select a.aqpa190bmto
          into mntdolar
          from aqpa190b_bdj a
         where a.aqpa190beval = ln_eval
           and a.aqpa190bcod = 527;
      exception
        when others then
          null;
      end;
    
      mntsoles := nvl(mntsoles, 0);
      mntdolar := nvl(mntdolar, 0);
    
      begin
        select sum(case
                     when a.aqpa190bcod in (5, 6, 7, 8) then
                      a.aqpa190bmto * -1
                     else
                      a.aqpa190bmto
                   end)
          into ln_IngNetoSol
          from aqpa190b_bdj a
         where a.aqpa190beval = ln_eval
           AND a.aqpa190bcod IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
      exception
        when others then
          null;
      end;
    
      begin
        select sum(case
                     when a.aqpa190bcod in (505, 506, 507, 508) then
                      a.aqpa190bmto * -1
                     else
                      a.aqpa190bmto
                   end)
          into ln_IngNetoDol
          from aqpa190b_bdj a
         where a.aqpa190beval = ln_eval
           AND a.aqpa190bcod IN
               (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512);
      exception
        when others then
          null;
      end;
    
      ln_IngNetoSol := nvl(ln_IngNetoSol, 0);
      ln_IngNetoDol := nvl(ln_IngNetoDol, 0);
    
    end if;
  
    ln_ResultNeto := ((mntdolar * ln_TipCamb) + mntsoles);
    ln_ResultNeto := nvl(ln_ResultNeto, 0);
    ln_IngNeto    := ln_IngNetoSol + (ln_IngNetoDol * ln_TipCamb);
    ln_IngNeto    := nvl(ln_IngNeto, 0);
  
  end;
  ----------------------------------------------------------------------------------

  procedure sp_cuotas(ln_pgcod10    in number,
                      ln_mod10      in number,
                      ln_suc10      in number,
                      ln_mda10      in number,
                      ln_pap10      in number,
                      ln_cta10      in number,
                      ln_oper10     in number,
                      ln_sbop10     in number,
                      ln_tope10     in number,
                      ln_NRO_CUOTAS out number) is
  begin
    begin
    
      select count(*)
        into ln_NRO_CUOTAS
        from fsd601
       where Pgcod = ln_pgcod10
         and Ppmod = ln_mod10
         and Ppsuc = ln_suc10
         and Ppmda = ln_mda10
         and Pppap = ln_pap10
         and Ppcta = ln_cta10
         and Ppoper = ln_oper10
         and Ppsbop = ln_sbop10
         and Pptope = ln_tope10
         and D601co in ('S', 'X');
    exception
      when others then
        null;
    end;
  
  end sp_cuotas;
  ----------------------------------------------------
  procedure sp_instancia(ln_mod10       in number,
                         ln_suc10       in number,
                         ln_mda10       in number,
                         ln_pap10       in number,
                         ln_cta10       in number,
                         ln_oper10      in number,
                         ln_sbop10      in number,
                         ln_tope10      in number,
                         ln_SNG001Ori   out number,
                         ln_Correlativo out number) is
  
    --- ln_ln_Correlativo number;
  
  begin
    begin
      sp_instancia_credito(v_Scmod     => ln_mod10,
                           v_Scsuc     => ln_suc10,
                           v_Scmda     => ln_mda10,
                           v_Scpap     => ln_pap10,
                           v_Sccta     => ln_cta10,
                           v_Scoper    => ln_oper10,
                           v_Scsbop    => ln_sbop10,
                           v_Sctope    => ln_tope10,
                           v_instancia => ln_Correlativo);
    end;
  
    begin
      select s01.SNG001Ori
        into ln_SNG001Ori
        from sng001 s01
       where s01.sng001inst = ln_Correlativo;
    exception
      when others then
        null;
    end;
  
  end sp_instancia;

  ---CUOTA IMPAGA --------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            tipocambio    in number,
                            ln_cuoimp     out number,
                            fech_maxcuota out date) is
  
    lc_estado character(1);
    ld_fecha  date;
    /*ln_r1mod  number;
    ln_r1suc  number;
    ln_r1mda  number;
    ln_r1pap  number;
    ln_r1cta  number;
    ln_r1oper number;
    ln_r1cod  number;*/
  
  begin
  
    if ln_mod10 <> 117 then
    
      BEGIN
        select max(ppfpag)
          into ld_fecha
          from fsd602
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10
           and D602CO = 'S';
      exception
        when others then
          NULL;
        
      END;
    
      begin
        select max(f602.pp1stat) --, ppfpag
          into lc_estado
          from fsd602 f602
         where f602.pgcod = ln_pgcod10
           and f602.ppmod = ln_mod10
           and f602.ppsuc = ln_suc10
           and f602.ppmda = ln_mda10
           and f602.pppap = ln_pap10
           and f602.ppcta = ln_cta10
           and f602.ppoper = ln_oper10
           and f602.ppfpag = ld_fecha
           and D602CO = 'S';
      exception
        when others then
          NULL;
      end;
    
      if lc_estado = 'T' or lc_estado = 'P' then
        begin
          select max(ppcap + ppint)
            into ln_cuoimp
            from fsd601
           where pgcod = ln_pgcod10
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10
             and ppfpag > ld_fecha;
          -- and rownum = 1;
        exception
          when too_many_rows then
            begin
              select max(ppcap + ppint)
                into ln_cuoimp
                from fsd601
               where pgcod = ln_pgcod10
                 and ppmod = ln_mod10
                 and ppsuc = ln_suc10
                 and ppmda = ln_mda10
                 and pppap = ln_pap10
                 and ppcta = ln_cta10
                 and ppoper = ln_oper10
                 and ppfpag > ld_fecha
                 and rownum = 1;
            exception
              when others then
              
                NULL;
            end;
        end;
      
      else
        if lc_estado is null then
          begin
            select max(ppcap + ppint)
              into ln_cuoimp
              from fsd601
             where pgcod = ln_pgcod10
               and ppmod = ln_mod10
               and ppsuc = ln_suc10
               and ppmda = ln_mda10
               and pppap = ln_pap10
               and ppcta = ln_cta10
               and ppoper = ln_oper10;
          exception
            when others then
            
              NULL;
            
          end;
        
        end if;
      
      end if;
    
      begin
        select d.ppfpag
          into fech_maxcuota
          from fsd601 d
         where d.pgcod = ln_pgcod10
           and d.ppmod = ln_mod10
           and d.ppsuc = ln_suc10
           and d.ppmda = ln_mda10
           and d.pppap = ln_pap10
           and d.ppcta = ln_cta10
           and d.ppoper = ln_oper10
           and (d.ppcap + d.ppint) = ln_cuoimp
           and rownum = 1;
      exception
        when others then
        
          NULL;
        
      end;
    
      if ln_mda10 = 101 then
        ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio;
      end if;
    
    end if;
  
  end sp_cuota_impaga;

  ---CUOTA IMPAGA --------------------------
  procedure sp_cuota_impagavuelo(ln_pgcod10    in number,
                                 ln_mod10      in number,
                                 ln_suc10      in number,
                                 ln_mda10      in number,
                                 ln_pap10      in number,
                                 ln_cta10      in number,
                                 ln_oper10     in number,
                                 tipocambio    in number,
                                 ln_cuoimp     out number,
                                 fech_maxcuota out date) is
  
  begin
  
    begin
      select max(d.ppcap + d.ppint)
        into ln_cuoimp
        from fsd601 d
       where d.pgcod = ln_pgcod10
         and d.ppmod = ln_mod10
         and d.ppsuc = ln_suc10
         and d.ppmda = ln_mda10
         and d.pppap = ln_pap10
         and d.ppcta = ln_cta10
         and d.ppoper = ln_oper10
         and d.d601co = 'X';
    exception
      when others then
        NULL;
      
    end;
  
    begin
      select d.ppfpag
        into fech_maxcuota
        from fsd601 d
       where d.pgcod = ln_pgcod10
         and d.ppmod = ln_mod10
         and d.ppsuc = ln_suc10
         and d.ppmda = ln_mda10
         and d.pppap = ln_pap10
         and d.ppcta = ln_cta10
         and d.ppoper = ln_oper10
         and (d.ppcap + d.ppint) = ln_cuoimp
         and rownum = 1;
    exception
      when others then
      
        NULL;
      
    end;
  
    if ln_mda10 = 101 then
      ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio;
    end if;
  
  end sp_cuota_impagavuelo;

  --------------------------------------------------
  procedure sp_seguro(ln_mod10        in number,
                      ln_suc10        in number,
                      ln_mda10        in number,
                      ln_pap10        in number,
                      ln_cta10        in number,
                      ln_oper10       in number,
                      ln_sbop10       in number,
                      ln_tope10       in number,
                      tipocambio      in number,
                      fech_maxcuota   in date,
                      ln_monto_seguro out number) is
  
  begin
    begin
      select sum(ppimp11 + ppimp12 + ppimp13 + ppimp14 + ppimp15)
        into ln_monto_seguro
        from fsd611
       where Pgcod = 1
         and Ppmod = ln_mod10
         and Ppsuc = ln_suc10
         and Ppmda = ln_mda10
         and Pppap = ln_pap10
         and Ppcta = ln_cta10
         and Ppoper = ln_oper10
         and Ppsbop = ln_sbop10
         and Pptope = ln_tope10
         and ppfpag = fech_maxcuota;
    exception
      when others then
        null;
    end;
  
    if ln_mda10 = 101 then
      ln_monto_seguro := nvl(ln_monto_seguro, 0) * nvl(tipocambio, 0);
    end if;
  
    ln_monto_seguro := nvl(ln_monto_seguro, 0);
  
  end sp_seguro;
  --------------------------------------------------

  procedure sp_capacidadlinea(ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              tipocambio in number,
                              ln_formula out number) is
  
    ln_plazo          number(10, 2);
    ln_tasa           number(10, 2);
    ln_saldo          number(10, 2);
    ln_Correlativo    number;
    ln_ln_Correlativo number;
    ln_paralelo       number;
    LN_TIPOCRED       number;
    lc_FlagSegmnt     varchar2(2);
    lc_FlagGuia       varchar2(1) := 'N';
  
  begin
  
    begin
      select 'S'
        into lc_FlagGuia
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 18
         and a.tp1nro2 = ln_mod10
         and a.tp1nro3 = ln_tope10;
    exception
      when others then
        lc_FlagGuia := 'N';
      
    end;
  
    if lc_FlagGuia = 'S' then
      --Extraemos el plazo de la guia
    
      begin
        ln_Correlativo := fn_instancia_credito(v_Scmod  => ln_mod10,
                                               v_Scsuc  => ln_suc10,
                                               v_Scmda  => ln_mda10,
                                               v_Scpap  => ln_pap10,
                                               v_Sccta  => ln_cta10,
                                               v_Scoper => ln_oper10,
                                               v_Scsbop => ln_sbop10,
                                               v_Sctope => ln_tope10);
      end;
    
      begin
        -- Tipo de Credito en el flujo
      
        select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval, ';', ''))),
                                        '([A-Z])',
                                        ''))
          into LN_TIPOCRED
          from wfattsvalues w
         where w.wfinsprcid = ln_ln_Correlativo
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
    
      begin
        select 'S'
          into lc_FlagSegmnt
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 17
           and a.tp1nro3 = LN_TIPOCRED;
      exception
        when others then
          lc_FlagSegmnt := 'N';
      end;
    
      if lc_FlagSegmnt = 'S' then
        -- mpostigoc 23/11/2017
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = ln_tope10
             and f.pp028mda = ln_mda10; -- plazo
        exception
          when others then
            null;
        end;
      
      else
        if lc_FlagSegmnt = 'N' then
        
          begin
            select a.tp1nro2
              into ln_plazo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 13
               and a.tp1corr2 = 17
               and a.tp1corr3 = 4;
          exception
            when others then
              null;
          end;
        
        end if;
      end if;
    
    else
    
      if lc_FlagGuia = 'N' then
        -- Extraemos el plazo del Preseteo
        -- mpostigoc 09/01/2018
      
        begin
          select f.pp028maxn
            into ln_plazo
            from fpp028 f
           where f.pp017par = 103
             and f.pp028mod = 116
             and f.pp028top = ln_tope10
             and f.pp028mda = ln_mda10; -- plazo
        exception
          when others then
            null;
        end;
      
      end if;
    
    end if;
  
    begin
      select aotasa, aoimp
        into ln_tasa, ln_saldo
        from fsd010
       where pgcod = 1
         and aocta = ln_cta10
         and aooper = ln_oper10
         and aomod = ln_mod10
         and aosuc = ln_suc10
         and aomda = ln_mda10
         and aopap = ln_pap10
         and aosbop = ln_sbop10
         and aotope = ln_tope10; --tasa
    exception
      when others then
        null;
    end;
  
    if ln_saldo is null then
      begin
        ln_Correlativo := fn_instancia_credito(v_Scmod  => ln_mod10,
                                               v_Scsuc  => ln_suc10,
                                               v_Scmda  => ln_mda10,
                                               v_Scpap  => ln_pap10,
                                               v_Sccta  => ln_cta10,
                                               v_Scoper => ln_oper10,
                                               v_Scsbop => ln_sbop10,
                                               v_Sctope => ln_tope10);
      end;
    
      begin
        select x.xwfmonto1 --, x.xwfprcins
          into ln_saldo --, 
          from xwf700 x
         where x.xwfprcins = ln_Correlativo
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
        
      end;
    
      begin
        /*select max(sng120tasa)
            into ln_tasa
            from sng120
           where sng120ins = ln_Correlativo;
        exception
          when others then
          
            NULL;*/
        select x.xlltasap
          into ln_tasa
          from x054023 x
         where x.Xllpgcod = 1
           and x.Xllaomod = ln_mod10
           and x.Xllaosuc = ln_suc10
           and x.Xllaomda = ln_mda10
           and x.Xllaopap = ln_pap10
           and x.XLLAOCTA = ln_cta10
           and x.Xllaooper = ln_oper10
           and x.Xllaosbop = ln_sbop10
           and x.Xllaotop = ln_tope10;
      exception
        when others then
          NULL;
        
      end;
    end if;
  
    begin
      select SUM(SNGE01IMPA)
        into ln_paralelo
        from SNGE01
       WHERE SNGE01INST = ln_Correlativo;
    exception
      when others then
        null;
    end;
  
    ln_saldo := nvl(ln_saldo, 0) - nvl(ln_paralelo, 0);
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    -- pq_cr_resolutor_cappago.Sp_Adicional(ln_Correlativo,tipocambio,ln_mda10,ln_mtoAdic);
  
    -- ln_saldo := ln_saldo - ln_mtoAdic;
  
    begin
    
      ln_formula := (ln_saldo *
                    ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                    (1 - power((1 +
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                               -ln_plazo));
    
    end;
  
  end sp_capacidadlinea;

  -----------------------------------------------------------
  procedure sp_capacidadpago(ln_MAX_CUOTA in number,
                             --ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_capacidad    out number) is
    ln_mensual number(17, 2);
    ln_cuota   number(17, 2);
  
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if /*ln_NRO_CUOTAS > 1 and */
         ln_SNG001Ori <> 7 then
        
          ln_mensual := ln_peri10 / 30;
        
          ln_cuota := nvl(ln_MAX_CUOTA, 0) + nvl(ln_monto_seguro, 0);
        
          ln_capacidad := nvl(ln_cuota, 0) / nvl(ln_mensual, 0);
        
        end if;
      
      end if;
    end;
  end sp_capacidadpago;
  -----------------------------------------------------------------------
  procedure sp_capacidadpagoparc( --ln_NRO_CUOTAS     in number,
                                 ln_SNG001Ori      in number,
                                 ln_monto_seguro   in number,
                                 ln_mod10          in number,
                                 ln_ln_Correlativo in number,
                                 tipocambio        in number,
                                 ln_suc10          in number, --mod 2016.04.12
                                 ln_mda10          in number, --mod 2016.04.12
                                 ln_pap10          in number, --mod 2016.04.12
                                 ln_cta10          in number, --mod 2016.04.12
                                 ln_oper10         in number, --mod 2016.04.12 
                                 ln_sbop10         in number, --mod 2016.04.12
                                 ln_tope10         in number, --mod 2016.04.12
                                 ln_indicador      in number, --mod 2016.04.12
                                 ln_cuoparc        out number,
                                 ln_capacidad      out number) is
    ln_mensual number(17, 2);
    ln_cuota   number(17, 2);
    -- ln_sngmda  number;
    -- ln_cuotaimp number;
  
    ln_mtoPar number(17, 2); --mod 2016.04.12
    ln_plazo  number(17, 2); --mod 2016.04.12
    ln_tasa   number(17, 2); --mod 2016.04.12
    ln_period number; --mod 2016.04.12
    ln_cuo    number(17, 2);
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if /*ln_NRO_CUOTAS > 1 and*/ -- mpostigoc 04/10/18 INC1373
         ln_SNG001Ori = 7 then
        
          if ln_indicador = 2 then
            --Desembolsos parciales en vuelo
          
            begin
              select a.sng120mto, A.SNG120TASA, A.SNG120CUO, a.sng120per
                into ln_mtoPar, ln_tasa, ln_plazo, ln_period
                from sng120 a
               where a.sng120ins = ln_ln_Correlativo
                 and a.sng120tsk like 'PROPUES%'
                 and rownum = 1;
            exception
              when others then
                null;
            end;
            if ln_mda10 = 101 then
              ln_mtoPar := ln_mtoPar * tipocambio;
            end if;
          
            begin
            
              ln_cuo := (ln_mtoPar *
                        ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                        (1 - power((1 +
                                   ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                                   -ln_plazo));
            
              ln_mensual := ln_period / 30;
            
              /*ln_cuota     := ln_cuo / ln_mensual; --mensualisa la cuota
              ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);*/
            
              ln_cuota := nvl(ln_cuo, 0) + nvl(ln_monto_seguro, 0);
            
              ln_capacidad := nvl(ln_cuota, 0) / ln_mensual; --mensualiza la cuota ;
            
            end;
          end if;
        
          if ln_indicador = 1 then
            --Desembolsos parciales contabilizados
          
            begin
              select a.aotasa, a.aoperiod
                into ln_tasa, ln_period
                from fsd010 a
               where a.pgcod = 1
                 and a.aomod = ln_mod10
                 and a.aosuc = ln_suc10
                 and a.aomda = ln_mda10
                 and a.aopap = ln_pap10
                 and a.aocta = ln_cta10
                 and a.aooper = ln_oper10
                 and a.aosbop = ln_sbop10
                 and a.aotope = ln_tope10;
            exception
              when others then
                null;
            end;
            begin
              select count(*)
                into ln_plazo
                from fsd601 a
               where a.pgcod = 1
                 and a.ppmod = ln_mod10
                 and a.ppsuc = ln_suc10
                 and a.ppmda = ln_mda10
                 and a.pppap = ln_pap10
                 and a.ppcta = ln_cta10
                 and a.ppoper = ln_oper10
                 and a.ppsbop = ln_sbop10
                 and a.pptope = ln_tope10
                 and a.d601co = 'S'
                 and (a.ppcap + a.ppint) <> 0;
            exception
              when others then
                null;
            end;
            begin
              select a.sng120mto
                into ln_mtoPar
                from sng120 a
               where a.sng120ins = ln_ln_Correlativo
                 and a.sng120tsk like 'APROBAC%'
                 and rownum = 1;
            exception
              when others then
                null;
            end;
            if ln_mda10 = 101 then
              ln_mtoPar := ln_mtoPar * tipocambio;
            end if;
          
            begin
            
              ln_cuo := (ln_mtoPar *
                        ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                        (1 - power((1 +
                                   ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                                   -ln_plazo));
            
              ln_mensual := ln_period / 30;
            
              ln_cuota := nvl(ln_cuo, 0) + nvl(ln_monto_seguro, 0);
            
              ln_capacidad := nvl(ln_cuota, 0) / ln_mensual; --mensualiza la cuota ;
            
            end;
          end if;
        
        end if;
      
        ln_cuoparc := nvl(ln_cuo, 0);
      
      end if;
    end;
  end sp_capacidadpagoparc;

  --------------------------------------------------
  procedure sp_resolutor(ln_Pepais      in number,
                         ln_Petdoc      in number,
                         ln_Pendoc      in char,
                         ln_Correlativo in number,
                         ld_fchcorre    in date,
                         pd_fecpro      in date,
                         ln_pgcod10     in number,
                         ln_mod10       in number,
                         ln_suc10       in number,
                         ln_mda10       in number,
                         ln_pap10       in number,
                         ln_cta10       in number,
                         ln_oper10      in number,
                         ln_sbop10      in number,
                         ln_tope10      in number,
                         ln_peri10      in number,
                         tipocambio     in number,
                         ln_indicador   in number,
                         lc_IndCred     in varchar2,
                         lc_Usuario     in varchar2,
                         ln_capacidad   out number) is
  
    ln_nrocuotas      number(17, 2);
    ln_parciales      number(17, 2);
    ln_cuotimp        number(17, 2) := 0;
    ln_seguro         number(17, 2);
    fech_maxcuota     date;
    ln_ln_Correlativo number;
    --lc_ven        char(1);
    ln_flagFC  varchar2(1) := 'N'; -- 20/12/2016 mpostigoc
    ln_CapFC   number(17, 2);
    CapLinea   number(17, 2);
    ln_cuoparc number(17, 2);
  
  begin
  
    ln_CapFC := 0;
    CapLinea := 0;
  
    PQ_CR_RATIOPYME_DTEN.sp_cuotas(ln_pgcod10,
                                   ln_mod10,
                                   ln_suc10,
                                   ln_mda10,
                                   ln_pap10,
                                   ln_cta10,
                                   ln_oper10,
                                   ln_sbop10,
                                   ln_tope10,
                                   ln_nrocuotas);
  
    PQ_CR_RATIOPYME_DTEN.sp_instancia(ln_mod10,
                                      ln_suc10,
                                      ln_mda10,
                                      ln_pap10,
                                      ln_cta10,
                                      ln_oper10,
                                      ln_sbop10,
                                      ln_tope10,
                                      ln_parciales,
                                      ln_ln_Correlativo);
  
    PQ_CR_RATIOPYME_DTEN.sp_cr_flujocaja(ln_pgcod10,
                                         ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop10,
                                         ln_tope10,
                                         ln_flagFC);
  
    if ln_mod10 <> 117 and ln_flagFC = 'N' then
      if ln_indicador <> 2 then
        PQ_CR_RATIOPYME_DTEN.sp_cuota_impaga(ln_pgcod10,
                                             ln_mod10,
                                             ln_suc10,
                                             ln_mda10,
                                             ln_pap10,
                                             ln_cta10,
                                             ln_oper10,
                                             tipocambio,
                                             ln_cuotimp,
                                             fech_maxcuota);
      else
      
        PQ_CR_RATIOPYME_DTEN.sp_cuota_impagavuelo(ln_pgcod10,
                                                  ln_mod10,
                                                  ln_suc10,
                                                  ln_mda10,
                                                  ln_pap10,
                                                  ln_cta10,
                                                  ln_oper10,
                                                  tipocambio,
                                                  ln_cuotimp,
                                                  fech_maxcuota);
      
      end if;
    
    else
      if ln_mod10 <> 117 and ln_flagFC = 'S' then
        PQ_CR_RATIOPYME_DTEN.sp_cr_capacidadFC(ln_mod10,
                                               ln_suc10,
                                               ln_mda10,
                                               ln_pap10,
                                               ln_cta10,
                                               ln_oper10,
                                               ln_sbop10,
                                               ln_tope10,
                                               tipocambio,
                                               ln_cuotimp);
      
        ln_CapFC := ln_cuotimp;
      
      end if;
    end if;
  
    PQ_CR_RATIOPYME_DTEN.sp_seguro(ln_mod10,
                                   ln_suc10,
                                   ln_mda10,
                                   ln_pap10,
                                   ln_cta10,
                                   ln_oper10,
                                   ln_sbop10,
                                   ln_tope10,
                                   tipocambio,
                                   fech_maxcuota,
                                   ln_seguro);
  
    if ln_mod10 = 117 then
      PQ_CR_RATIOPYME_DTEN.sp_capacidadlinea(ln_mod10,
                                             ln_suc10,
                                             ln_mda10,
                                             ln_pap10,
                                             ln_cta10,
                                             ln_oper10,
                                             ln_sbop10,
                                             ln_tope10,
                                             tipocambio,
                                             ln_capacidad);
    
      CapLinea := ln_capacidad;
    
    end if;
  
    IF ln_parciales = 7 then
    
      PQ_CR_RATIOPYME_DTEN.sp_capacidadpagoparc( --ln_nrocuotas,
                                                ln_parciales,
                                                ln_seguro,
                                                ln_mod10,
                                                ln_ln_Correlativo,
                                                tipocambio,
                                                ln_suc10,
                                                ln_mda10,
                                                ln_pap10,
                                                ln_cta10,
                                                ln_oper10,
                                                ln_sbop10,
                                                ln_tope10,
                                                ln_indicador,
                                                ln_cuoparc,
                                                ln_capacidad);
    
      ln_cuotimp := ln_cuoparc;
    
    end if;
  
    if ln_mod10 <> 117 and ln_parciales <> 7 then
    
      PQ_CR_RATIOPYME_DTEN.sp_capacidadpago(ln_cuotimp,
                                            -- ln_nrocuotas,
                                            ln_parciales,
                                            ln_peri10,
                                            ln_seguro,
                                            ln_mod10,
                                            ln_capacidad);
    end if;
  
    if ln_capacidad > 0 then
    
      if ln_CapFC <> 0 then
        ln_cuotimp := 0;
      end if;
    
      PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_Pepais,
                                            ln_Petdoc,
                                            ln_Pendoc,
                                            tipocambio,
                                            ln_Correlativo,
                                            ld_fchcorre,
                                            pd_fecpro,
                                            ln_pgcod10,
                                            ln_mod10,
                                            ln_suc10,
                                            ln_mda10,
                                            ln_pap10,
                                            ln_cta10,
                                            ln_oper10,
                                            ln_sbop10,
                                            ln_tope10,
                                            ln_peri10,
                                            ln_nrocuotas,
                                            ln_parciales,
                                            ln_flagFC,
                                            ln_cuotimp,
                                            ln_seguro,
                                            ln_CapFC,
                                            CapLinea,
                                            ln_capacidad,
                                            lc_IndCred,
                                            lc_Usuario);
    end if;
  
  end sp_resolutor;
  --------------------------------------------------
  procedure sp_resolutor_prop(ln_Pepais      in number,
                              ln_Petdoc      in number,
                              ln_Pendoc      in char,
                              ln_Correlativo in number,
                              ld_fchcorre    in date,
                              pd_fecpro      in date,
                              ln_pgcod10     in number,
                              ln_mod10       in number,
                              ln_suc10       in number,
                              ln_mda10       in number,
                              ln_pap10       in number,
                              ln_cta10       in number,
                              ln_oper10      in number,
                              ln_sbop10      in number,
                              ln_tope10      in number,
                              ln_peri10      in number,
                              ln_nrocuotas   in number,
                              tipocambio     in number,
                              lc_IndCred     in varchar2,
                              lc_Usuario     in varchar2,
                              ln_cuota       in number,
                              ln_capacidad   out number) is
  
    ln_mensual number;
  
  begin
  
    ln_mensual   := ln_peri10 / 30;
    ln_capacidad := nvl(ln_cuota, 0) / nvl(ln_mensual, 0);
  
    PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          tipocambio,
                                          ln_Correlativo,
                                          ld_fchcorre,
                                          pd_fecpro,
                                          ln_pgcod10,
                                          ln_mod10,
                                          ln_suc10,
                                          ln_mda10,
                                          ln_pap10,
                                          ln_cta10,
                                          ln_oper10,
                                          ln_sbop10,
                                          ln_tope10,
                                          ln_peri10,
                                          ln_nrocuotas,
                                          0,
                                          'N',
                                          ln_cuota,
                                          0.00,
                                          0.00,
                                          0.00,
                                          ln_capacidad,
                                          lc_IndCred,
                                          lc_Usuario);
  
  end sp_resolutor_prop;
  --------------------------------------------------
  procedure sp_resolutor_venc(ln_Pepais      in number,
                              ln_Petdoc      in number,
                              ln_Pendoc      in char,
                              ln_Correlativo in number,
                              ld_fchcorre    in date,
                              pd_fecpro      in date,
                              ln_pgcod10     in number,
                              ln_mod10       in number,
                              ln_suc10       in number,
                              ln_mda10       in number,
                              ln_pap10       in number,
                              ln_cta10       in number,
                              ln_oper10      in number,
                              ln_sbop10      in number,
                              ln_tope10      in number,
                              tipocambio     in number,
                              lc_IndCred     in varchar2,
                              lc_Usuario     in varchar2,
                              ln_capacidad   out number) is
    ln_nrocuotas number;
    -- ln_parciales  number;
    ln_cuotimp    number(17, 2);
    ln_seguro     number(17, 2);
    fech_maxcuota date;
    --   ln_ln_Correlativo  number;
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
         and relcod = 46;
  
    ln_pr116     number;
    ln_capTem    number(17, 2);
    ln_parciales number;
    ln_flagFC    varchar2(2);
    ln_CapFC     number;
    CapLinea     number;
    ln_Instancia number;
  
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
         and relcod = 46
         and rownum = 1;
    exception
      when no_data_found then
        lc_ven := 'N';
    end;
  
    if lc_ven = 'S' then
      for i in creditos loop
      
        PQ_CR_RATIOPYME_DTEN.sp_cuotas(i.ln_pgcod10,
                                       i.ln_mod10,
                                       i.ln_suc10,
                                       i.ln_mda10,
                                       i.ln_pap10,
                                       i.ln_cta10,
                                       i.ln_oper10,
                                       i.ln_sbop10,
                                       i.ln_tope10,
                                       ln_nrocuotas);
        begin
          select a.aoperiod
            into ln_pr116
            from fsd010 a
           where a.pgcod = i.ln_pgcod10
             and a.aomod = i.ln_mod10
             and a.aosuc = i.ln_suc10
             and a.aomda = i.ln_mda10
             and a.aopap = i.ln_pap10
             and a.aocta = i.ln_cta10
             and a.aooper = i.ln_oper10
             and a.aosbop = i.ln_sbop10
             and a.aotope = i.ln_tope10;
        exception
          when others then
            null;
        end;
      
        PQ_CR_RATIOPYME_DTEN.sp_cuota_impaga_lin(i.ln_pgcod10,
                                                 i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 tipocambio,
                                                 ln_cuotimp,
                                                 fech_maxcuota);
      
        PQ_CR_RATIOPYME_DTEN.sp_seguro(i.ln_mod10,
                                       i.ln_suc10,
                                       i.ln_mda10,
                                       i.ln_pap10,
                                       i.ln_cta10,
                                       i.ln_oper10,
                                       i.ln_sbop10,
                                       i.ln_tope10,
                                       tipocambio,
                                       fech_maxcuota,
                                       ln_seguro);
        PQ_CR_RATIOPYME_DTEN.sp_capacidadpago_lin(ln_cuotimp,
                                                  ln_nrocuotas,
                                                  ln_pr116,
                                                  ln_seguro,
                                                  i.ln_mod10,
                                                  ln_capTem);
        PQ_CR_RATIOPYME_DTEN.sp_instancia(i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          ln_parciales,
                                          ln_Instancia);
      
        if ln_capTem > 0 then
        
          ln_flagFC := 'N';
          ln_CapFC  := nvl(ln_CapFC, 0);
          CapLinea  := nvl(CapLinea, 0);
        
          PQ_CR_RATIOPYME_DTEN.sp_cr_LogCuentas(ln_Pepais,
                                                ln_Petdoc,
                                                ln_Pendoc,
                                                tipocambio,
                                                ln_Correlativo,
                                                ld_fchcorre,
                                                pd_fecpro,
                                                ln_pgcod10,
                                                ln_mod10,
                                                ln_suc10,
                                                ln_mda10,
                                                ln_pap10,
                                                ln_cta10,
                                                ln_oper10,
                                                ln_sbop10,
                                                ln_tope10,
                                                ln_pr116,
                                                ln_nrocuotas,
                                                ln_parciales,
                                                ln_flagFC,
                                                ln_cuotimp,
                                                ln_seguro,
                                                ln_CapFC,
                                                CapLinea,
                                                ln_capTem,
                                                lc_IndCred,
                                                lc_Usuario);
        end if;
      
        ln_capacidad := nvl(ln_capacidad, 0) + nvl(ln_capTem, 0);
      
      end loop;
    end if;
  
  end sp_resolutor_venc;
  -------------------------------------------------------------------------------------------
  Procedure Sp_ampliados_CK(ln_emp10       in number,
                            ln_mod10       in number,
                            ln_suc10       in number,
                            ln_mda10       in number,
                            ln_pap10       in number,
                            ln_cta10       in number,
                            ln_oper10      in number,
                            ln_sbop10      in number,
                            ln_tope10      in number,
                            ln_correlativo in number,
                            ld_fchcorre    in date,
                            Pc_flag        out varchar2) is
  
    ln_mod  number;
    ln_suc  number;
    ln_mda  number;
    ln_pap  number;
    ln_cta  number;
    ln_oper number;
    ln_sbop number;
    ln_tope number;
  
  begin
  
    begin
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
  
    if Pc_flag = 'N' then
    
      ln_mod  := ln_mod10;
      ln_suc  := ln_suc10;
      ln_mda  := ln_mda10;
      ln_pap  := ln_pap10;
      ln_cta  := ln_cta10;
      ln_oper := ln_oper10;
      ln_sbop := ln_sbop10;
      ln_tope := ln_tope10;
    
      if ln_mod10 = 116 then
      
        begin
          select f.r2mod,
                 f.r2suc,
                 f.r2mda,
                 f.r2pap,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2tope
            into ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_oper,
                 ln_sbop,
                 ln_tope
            from fsr011 f
           where f.r1cod = 1
             and f.r1mod = ln_mod
             and f.r1suc = ln_suc
             and f.r1mda = ln_mda
             and f.r1pap = ln_pap
             and f.r1cta = ln_cta
             and f.r1oper = ln_oper
             and f.r1sbop = ln_sbop
             and f.r1tope = ln_tope
             and f.relcod = 46;
        exception
          when others then
            null;
        end;
      end if;
    
      begin
        select 'S'
          into Pc_flag
          from jaqz697 j
         where j.jaqz697fep = ld_fchcorre
           and j.jaqz697cor = ln_correlativo
           and j.jaqz697moa = ln_mod
           and j.jaqz697sua = ln_suc
           and j.jaqz697maa = ln_mda
           and j.jaqz697paa = ln_pap
           and j.jaqz697caa = ln_cta
           and j.jaqz697opa = ln_oper
           and j.jaqz697sba = ln_sbop
           and j.jaqz697toa = ln_tope;
      exception
        when no_data_found then
          Pc_flag := 'N';
      end;
    end if;
  
  end Sp_ampliados_CK;

  --------------------------------------------------------------------------

  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2) is --mod 2016.04.12
  
  begin
    if pn_mod = 117 then
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
    else
      Pc_flag := 'N';
    end if;
  
  end Sp_Adicional_CK;

  ------------------------------------------------------------

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
           and f.relcod = 46; -- mpostigoc 25/02/2020
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
          from xwf700 a, sng001 s /*, xwf070 w*/, wfwrkitems x
         where a.xwfempresa = ln_pgcod10
           and a.xwfsucursal = ln_suc10
           and a.xwfmodulo = ln_mod10
           and a.xwfmoneda = ln_mda10
           and a.xwfpapel = ln_pap10
           and a.xwfcuenta = ln_cta10
           and a.xwfoperacion = ln_oper10
              -- and a.xwfsubope = ln_sbop10
              -- and a.xwftipope = ln_tope10
           and a.xwfprcins = s.sng001inst
           and s.sng001ori in (3, 13, 14) -- Refinanciaciones, Reprogramaciones
           and s.sng001inst = x.wfinsprcid
           and x.wfitemstsact = 1
           and rownum = 1;
      exception
        when no_data_found then
          lc_fgRefLin := 'N';
        
      end;
    end if;
  
  end sp_refinanLinea;
  --------------------------------------------------
  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out varchar2) is
  
    ln_fc           number(10, 2);
    ln_nroflujo     number;
    lc_tienecalen   VARCHAR2(2);
    lc_tieneseguros varchar2(2);
  
  begin
  
    begin
      -- verifica si tiene calendario de pago 05/07/2017 mpostigoc
    
      select 'S'
        into lc_tienecalen
        from fsd601 f
       where f.pgcod = ln_emp10
         and f.ppmod = ln_mod10
         and f.ppsuc = ln_suc10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and rownum = 1;
    exception
      when others then
        lc_tienecalen := 'N';
    end;
  
    begin
      -- Verifica si tiene calendario de Seguros 05/07/2017 mpostigoc
      select 'S'
        into lc_tieneseguros
        from fsd611 f
       where f.pgcod = ln_emp10
         and f.ppmod = ln_mod10
         and f.ppsuc = ln_suc10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and rownum = 1;
    exception
      when others then
        lc_tieneseguros := 'N';
    end;
  
    if lc_tienecalen = 'S' and lc_tieneseguros = 'S' then
      --05/07/2017 mpostigoc
    
      begin
      
        select max(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 + s.ppimp13 +
                   s.ppimp14 + s.ppimp15) -
               min(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 + s.ppimp13 +
                   s.ppimp14 + s.ppimp15)
          into ln_fc
          from fsd601 f, fsd611 s
        
         where f.pgcod = ln_emp10
           and f.ppmod = ln_mod10
           and f.ppsuc = ln_suc10
           and f.ppmda = ln_mda10
           and f.pppap = ln_pap10
           and f.ppcta = ln_cta10
           and f.ppoper = ln_oper10
           and f.ppsbop = ln_sbop10
           and f.pptope = ln_tope10
           and f.pgcod = s.pgcod
           and f.ppmod = s.ppmod
           and f.ppsuc = s.ppsuc
           and f.ppmda = s.ppmda
           and f.pppap = s.pppap
           and f.ppcta = s.ppcta
           and f.ppoper = s.ppoper
           and f.ppsbop = s.ppsbop
           and f.pptope = s.pptope
           and f.ppfpag = s.ppfpag;
      exception
        when others then
          null;
        
      end;
    
    else
      if lc_tienecalen = 'S' and lc_tieneseguros = 'N' then
        --05/07/2017 mpostigoc
      
        begin
        
          select max(f.ppcap + f.ppint) - min(f.ppcap + f.ppint)
            into ln_fc
            from fsd601 f
           where f.pgcod = ln_emp10
             and f.ppmod = ln_mod10
             and f.ppsuc = ln_suc10
             and f.ppmda = ln_mda10
             and f.pppap = ln_pap10
             and f.ppcta = ln_cta10
             and f.ppoper = ln_oper10
             and f.ppsbop = ln_sbop10
             and f.pptope = ln_tope10;
        exception
          when others then
            null;
          
        end;
      
      end if;
    end if;
  
    begin
    
      select a.tp1nro1
        into ln_nroflujo
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 3;
    exception
      when others then
        null;
    end;
  
    if ln_fc is not null then
    
      if ln_fc <= ln_nroflujo then
        ln_flagFC := 'N';
      else
        ln_flagFC := 'S';
      END IF;
    
    else
      if ln_fc is null then
        ln_flagFC := 'N';
      
      end if;
    
    end if;
  end sp_cr_flujocaja;

  -------------------------------------------------

  procedure sp_cr_capacidadFC(ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              tipocambio in number,
                              ln_formula out number) is
  
    ln_plazo       number(17, 2);
    ln_tasa        number(17, 2);
    ln_saldo       number(17, 2);
    ln_Correlativo number;
    --ln_periodo number;
    ln_cuotas          number;
    ld_fchamort        date;
    lc_flagAmort       varchar2(2) := 'N';
    ln_CapPagado       number;
    ln_CapProgramad    number;
    ld_FchUltPagoTotal date;
  
  begin
  
    begin
      select max(f.evfval) --, 'S'
        into ld_fchamort --, lc_flagAmort
        from fsd012 f
       where f.pgcod = 1
         and f.aomod = ln_mod10
         and f.aosuc = ln_suc10
         and f.aomda = ln_mda10
         and f.aopap = ln_pap10
         and f.aocta = ln_cta10
         and f.aooper = ln_oper10
         and f.aosbop = ln_sbop10
         and f.aotope = ln_tope10
         and f.evtipo = 50
         and f.d012co = 'S'; --mpostigoc 25/02/2020
    exception
      when others then
        null;
      
    end;
  
    if ld_fchamort is not null then
    
      lc_flagAmort := 'S';
    else
      lc_flagAmort := 'N';
    end if;
  
    if lc_flagAmort = 'S' then
      -- 16/10/2017 El credito es una amortizacion mpostigoc
      begin
        begin
          select sum(pp1cap)
            into ln_CapPagado
            from fsd602
           where pgcod = 1
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10
             and ppsbop = ln_sbop10
             and pptope = ln_tope10
             and pp1cap > 0
             and d602co = 'S';
        exception
          when others then
            ln_CapPagado := 0;
        end;
      
        begin
          select sum(ppcap)
            into ln_CapProgramad
            from fsd601
           where pgcod = 1
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10
             and ppsbop = ln_sbop10
             and pptope = ln_tope10
             and ppcap > 0;
        exception
          when others then
            ln_CapProgramad := 0;
        end;
      
        begin
          select max(ppfpag)
            into ld_FchUltPagoTotal
            from fsd602
           where pgcod = 1
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10
             and ppsbop = ln_sbop10
             and pptope = ln_tope10
             and pp1stat = 'T'
             and d602co = 'S';
        exception
          when others then
            null;
        end;
      
        begin
          select count(*)
            into ln_cuotas
            from fsd601
           where pgcod = 1
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10
             and ppsbop = ln_sbop10
             and pptope = ln_tope10
             and ppfpag > ld_FchUltPagoTotal;
        exception
          when others then
            ln_cuotas := 0;
        end;
      
        begin
          select aotasa, aoperiod
            into ln_tasa, ln_plazo
            from fsd010
           where pgcod = 1
             and aocta = ln_cta10
             and aooper = ln_oper10
             and aomod = ln_mod10
             and aosuc = ln_suc10
             and aomda = ln_mda10
             and aopap = ln_pap10
             and aosbop = ln_sbop10
             and aotope = ln_tope10; --tasa
        exception
          when others then
            null;
        end;
      
        ln_saldo := nvl(ln_CapProgramad, 0) - nvl(ln_CapPagado, 0);
      
      end;
    
    else
      if lc_flagAmort = 'N' then
        -- 16/10/2017 El credito no es una amortizacion mpostigoc
      
        begin
          select aotasa, aoimp, aoperiod
            into ln_tasa, ln_saldo, ln_plazo
            from fsd010
           where pgcod = 1
             and aocta = ln_cta10
             and aooper = ln_oper10
             and aomod = ln_mod10
             and aosuc = ln_suc10
             and aomda = ln_mda10
             and aopap = ln_pap10
             and aosbop = ln_sbop10
             and aotope = ln_tope10; --tasa
        exception
          when others then
            null;
        end;
      
        begin
          /*begin
            select x.xwfprcins
              into ln_Correlativo
              from xwf700 x
             where x.xwfempresa = 1
               and x.xwfsucursal = ln_suc10
               and x.xwfmodulo = ln_mod10
               and x.xwfmoneda = ln_mda10
               and x.xwfpapel = ln_pap10
               and x.xwfcuenta = ln_cta10
               and x.xwfoperacion = ln_oper10
               and x.xwfsubope = ln_sbop10
               and x.xwftipope = ln_tope10;
          exception
            when others then
              null;
          end;*/ -- 18/09/2019 MPOSTIGOC
        
          begin
            ln_Correlativo := fn_instancia_credito(v_Scmod  => ln_mod10,
                                                   v_Scsuc  => ln_suc10,
                                                   v_Scmda  => ln_mda10,
                                                   v_Scpap  => ln_pap10,
                                                   v_Sccta  => ln_cta10,
                                                   v_Scoper => ln_oper10,
                                                   v_Scsbop => ln_sbop10,
                                                   v_Sctope => ln_tope10);
          end;
        
          begin
          
            select max(sng120cuo)
              into ln_cuotas
            --   into ln_plazo, ln_periodo
              from sng120 s
             where s.sng120ins = ln_Correlativo;
          exception
            when others then
            
              NULL;
            
          end;
        
          ln_cuotas := nvl(ln_cuotas, 0);
        
          if ln_cuotas = 0 then
          
            begin
            
              select count(*)
                into ln_cuotas
                from fsd601
               where Pgcod = 1 --ln_pgcod10
                 and Ppmod = ln_mod10
                 and Ppsuc = ln_suc10
                 and Ppmda = ln_mda10
                 and Pppap = ln_pap10
                 and Ppcta = ln_cta10
                 and Ppoper = ln_oper10
                 and Ppsbop = ln_sbop10
                 and Pptope = ln_tope10
                 and D601co in ('S');
            exception
              when others then
                null;
            end;
          
          end if;
        end;
      
        if ln_saldo is null then
          begin
            ln_Correlativo := fn_instancia_credito(v_Scmod  => ln_mod10,
                                                   v_Scsuc  => ln_suc10,
                                                   v_Scmda  => ln_mda10,
                                                   v_Scpap  => ln_pap10,
                                                   v_Sccta  => ln_cta10,
                                                   v_Scoper => ln_oper10,
                                                   v_Scsbop => ln_sbop10,
                                                   v_Sctope => ln_tope10);
          end;
        
          begin
            select x.xwfmonto1
              into ln_saldo
              from xwf700 x
             where x.xwfprcins = ln_Correlativo
               and x.xwfcar3 = '1';
          exception
            when others then
              null;
            
          end;
        
          begin
            select max(sng120tasa)
              into ln_tasa
              from sng120
             where sng120ins = ln_Correlativo;
          exception
            when others then
              null;
            
          end;
        
          begin
          
            select max(s.sng120cuo), max(s.sng120per)
              into ln_cuotas, ln_plazo
            --   into ln_plazo, ln_periodo
              from sng120 s
             where s.sng120ins = ln_Correlativo;
          exception
            when others then
            
              NULL;
            
          end;
        end if;
      end if;
    end if;
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    if ln_mod10 <> 33 then
    
      begin
      
        ln_tasa := ((power(1 + (ln_tasa / 100), (ln_plazo / 360))) - 1) * 100;
        -- ln_tasa := ((power(1 + (ln_tasa / 100), (ln_periodo / 360))) - 1) * 100;
      end;
    
      --if ln_tasa <> 0 and ln_cuotas <> 0 then
    
      if ln_tasa <= 0 then
        -- INC6802 18.01.2024 mpostigoc
        ln_tasa := 0.000001;
      end if;
    
      begin
      
        ln_formula := ln_saldo *
                      (((ln_tasa / 100) *
                      (power(1 + (ln_tasa / 100), ln_cuotas))) /
                      (power(1 + (ln_tasa / 100), ln_cuotas) - 1));
      
      end;
    
    end if;
  end sp_cr_capacidadFC;

  --------------------------------------------------

  procedure sp_cuota_impaga_Lin(ln_pgcod10    in number,
                                ln_mod10      in number,
                                ln_suc10      in number,
                                ln_mda10      in number,
                                ln_pap10      in number,
                                ln_cta10      in number,
                                ln_oper10     in number,
                                tipocambio    in number,
                                ln_cuoimp     out number,
                                fech_maxcuota out date) is
  
    lc_estado character(1);
    ld_fecha  date;
  
  begin
  
    BEGIN
      select max(ppfpag)
        into ld_fecha
        from fsd602
       where pgcod = ln_pgcod10
         and ppmod = ln_mod10
         and ppsuc = ln_suc10
         and ppmda = ln_mda10
         and pppap = ln_pap10
         and ppcta = ln_cta10
         and ppoper = ln_oper10;
    exception
      when others then
        NULL;
      
    END;
  
    begin
      select max(f602.pp1stat) --, ppfpag
        into lc_estado
        from fsd602 f602
       where f602.pgcod = ln_pgcod10
         and f602.ppmod = ln_mod10
         and f602.ppsuc = ln_suc10
         and f602.ppmda = ln_mda10
         and f602.pppap = ln_pap10
         and f602.ppcta = ln_cta10
         and f602.ppoper = ln_oper10
         and f602.ppfpag = ld_fecha
         and f602.d602co = 'S';
    exception
      when others then
        NULL;
    end;
  
    if lc_estado = 'T' or lc_estado = 'P' then
      begin
        select max(ppcap + ppint)
          into ln_cuoimp
          from fsd601
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10
           and ppfpag > ld_fecha;
        -- and rownum = 1;
      exception
        when too_many_rows then
          begin
            select max(ppcap + ppint)
              into ln_cuoimp
              from fsd601
             where pgcod = ln_pgcod10
               and ppmod = ln_mod10
               and ppsuc = ln_suc10
               and ppmda = ln_mda10
               and pppap = ln_pap10
               and ppcta = ln_cta10
               and ppoper = ln_oper10
               and ppfpag > ld_fecha
               and rownum = 1;
          exception
            when others then
            
              NULL;
          end;
      end;
    
    else
      if lc_estado is null then
        begin
          select max(ppcap + ppint)
            into ln_cuoimp
            from fsd601
           where pgcod = ln_pgcod10
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10;
        exception
          when others then
          
            NULL;
          
        end;
      
      end if;
    
    end if;
  
    begin
      select ppfpag
        into fech_maxcuota
        from fsd601
       where pgcod = ln_pgcod10
         and ppmod = ln_mod10
         and ppsuc = ln_suc10
         and ppmda = ln_mda10
         and pppap = ln_pap10
         and ppcta = ln_cta10
         and ppoper = ln_oper10
         and (ppcap + ppint) = ln_cuoimp
         and rownum = 1;
    exception
      when others then
        NULL;
      
    end;
  
    if ln_mda10 = 101 then
      ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio;
    end if;
  
  end sp_cuota_impaga_Lin;

  -----------------------------------------------------------
  procedure sp_capacidadpago_Lin(ln_MAX_CUOTA    in number,
                                 ln_NRO_CUOTAS   in number,
                                 ln_peri10       in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_capacidad    out number) is
    ln_mensual number(17, 2);
    ln_cuota   number(17, 2);
    -- ln_sngmda  number;
    -- ln_cuotaimp number;
  
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if ln_NRO_CUOTAS > 1 then
        
          ln_mensual := ln_peri10 / 30;
        
          ln_cuota := nvl(ln_MAX_CUOTA, 0) + nvl(ln_monto_seguro, 0);
        
          ln_capacidad := nvl(ln_cuota, 0) / nvl(ln_mensual, 0); -- Se mensualiza la cuota
        
        end if;
      
      end if;
    end;
  end sp_capacidadpago_Lin;
  ---------------------------------------------------------------------------
  procedure sp_cr_VerfVincAliInterno(ln_pgcod  in number,
                                     ln_mod    in number,
                                     ln_suc    in number,
                                     ln_mda    in number,
                                     ln_pap    in number,
                                     ln_cta    in number,
                                     ln_ope    in number,
                                     ln_sbop   in number,
                                     ln_tope   in number,
                                     lc_EsVinc out varchar2) is
  
    ln_EstaVnc number;
  
  begin
    begin
      select count(*)
        into ln_EstaVnc
        from aqpc701 a
       where a.aqpc701emp = ln_pgcod
         and a.aqpc701mod = ln_mod
         and a.aqpc701suc = ln_suc
         and a.aqpc701mda = ln_mda
         and a.aqpc701pap = ln_pap
         and a.aqpc701cta = ln_cta
         and a.aqpc701ope = ln_ope
         and a.aqpc701sbo = ln_sbop
         and a.aqpc701top = ln_tope
         and a.aqpc701ind = 'N';
    exception
      when others then
        null;
    end;
  
    if ln_EstaVnc > 0 then
      lc_EsVinc := 'S';
    else
      lc_EsVinc := 'N';
    end if;
  end sp_cr_VerfVincAliInterno;
  ---------------------------------------------------------------------------

  procedure sp_cr_LogRatio(ln_Pepais      in number,
                           ln_Petdoc      in number,
                           ln_Pendoc      in char,
                           tipocambio     in number,
                           ln_Correlativo in number,
                           ld_fchcorre    in date,
                           pd_fecpro      in date,
                           ln_captotcaja  in number,
                           saldo_externo  in number,
                           ln_ResultNeto  in number,
                           ln_MntCuoCntg  in number,
                           ln_MntPotncial in number,
                           ln_RatioPyme   in number,
                           lc_indicador   in varchar2,
                           lc_Usuario     in varchar2) is
  
    ln_corr    number;
    lc_IndEst  varchar2(2);
    lc_hora    character(8);
    ln_correrr number;
    lc_cod     varchar2(50);
    lc_msg     varchar2(1500);
  
  begin
  
    begin
    
      select max(j.JAQY140corr)
        into ln_corr
        from JAQY140A j
       where j.JAQY140fec = pd_fecpro
         and j.JAQY140corrlt = ln_Correlativo
         and j.jaqy140fcorr = ld_fchcorre;
    exception
      when others then
        null;
    end;
  
    begin
    
      select max(j.jaqy140errcorr)
        into ln_correrr
        from jaqy140err j
       where j.jaqy140errfec = pd_fecpro
         and j.jaqy140errinst = ln_Correlativo;
    exception
      when others then
        null;
    end;
  
    ln_corr    := nvl(ln_corr, 0);
    ln_correrr := nvl(ln_correrr, 0); -- 01/08/2019 mpostigoc
  
    lc_IndEst := 'H';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into jaqy140a
        (jaqy140corr,
         jaqy140pais,
         jaqy140tdoc,
         jaqy140ndoc,
         jaqy140tcamb,
         jaqy140corrlt,
         jaqy140fec,
         jaqy140capcaja,
         jaqy140sldext,
         jaqy140resnet,
         jaqy140ccontg,
         jaqy140cpoten,
         jaqy140ratio,
         jaqy140ind,
         jaqy140est,
         jaqy140hora,
         jaqy140user,
         jaqy140fcorr)
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         tipocambio,
         ln_Correlativo,
         pd_fecpro,
         ln_captotcaja,
         saldo_externo,
         ln_ResultNeto,
         ln_MntCuoCntg,
         ln_MntPotncial,
         ln_RatioPyme,
         lc_indicador,
         lc_IndEst,
         lc_hora,
         lc_Usuario,
         ld_fchcorre);
      commit;
    exception
      when others then
        lc_cod := substr(sqlcode, 1, 50); -- 01/08/2019 mpostigoc
        lc_msg := substr(sqlerrm, 1, 1500); -- 01/08/2019 mpostigoc
        begin
          insert into jaqy140ERR
            (jaqy140ERRcorr,
             jaqy140ERRpais,
             jaqy140ERRtdoc,
             jaqy140ERRndoc,
             jaqy140ERRtcamb,
             jaqy140ERRinst,
             jaqy140ERRfec,
             jaqy140ERRhora,
             jaqy140ERRcapcaja,
             jaqy140ERRsldext,
             jaqy140ERRresnet,
             jaqy140ERRratio,
             jaqy140ERRind,
             jaqy140ERREST,
             jaqy140ERRUSER,
             jaqy140ERRCODERR,
             jaqy140ERRMSGERR)
          values
            (ln_correrr + 1,
             ln_Pepais,
             ln_Petdoc,
             ln_Pendoc,
             tipocambio,
             ln_Correlativo,
             pd_fecpro,
             lc_hora,
             ln_captotcaja,
             saldo_externo,
             ln_ResultNeto,
             ln_RatioPyme,
             lc_indicador,
             lc_IndEst,
             lc_Usuario,
             lc_cod,
             lc_msg);
          commit;
        
        end;
    end;
  
  end sp_cr_LogRatio;

  -------------------------------------------------------------------
  procedure sp_cr_LogCuentas(lnPepais       in number,
                             lnPetdoc       in number,
                             lnPendoc       in char,
                             tipocambio     in number,
                             ln_Correlativo in number,
                             ld_fchcorre    in date,
                             pd_fecpro      in date,
                             ln_PGCOD       in number,
                             ln_MOD         in number,
                             ln_SUC         in number,
                             ln_MDA         in number,
                             ln_PAP         in number,
                             ln_CTA         in number,
                             ln_OPE         in number,
                             ln_SBOP        in number,
                             ln_TOPE        in number,
                             ln_peri10      in number,
                             ln_nrocuotas   in number,
                             ln_parciales   in number,
                             ln_flagFC      in varchar2,
                             ln_cuotimp     in number,
                             ln_seguro      in number,
                             ln_CapFC       in number,
                             CapLinea       in number,
                             ln_CAPCUO      in number,
                             lc_IndCred     IN VARCHAR2,
                             lc_Usuario     in varchar2) is
  
    ln_corr number;
    --lc_exist varchar2(2) := 'N';
    lc_hora   character(8);
    lc_IndEst varchar2(2);
  
  begin
  
    begin
    
      select max(j.jaqy142corr)
        into ln_corr
        from jaqy142a j
       where j.jaqy142fec = pd_fecpro
         and j.jaqy142corrlt = ln_Correlativo
         and j.jaqy142fcorr = ld_fchcorre;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    lc_IndEst := 'H';
  
    -- if lc_exist = 'N' then
  
    begin
      insert into jaqy142a
        (jaqy142corr,
         jaqy142fec,
         jaqy142hora,
         jaqy142pais,
         jaqy142tdoc,
         jaqy142ndoc,
         jaqy142tcamb,
         jaqy142corrlt,
         jaqy142pgcod,
         jaqy142mod,
         jaqy142suc,
         jaqy142mda,
         jaqy142pap,
         jaqy142cta,
         jaqy142ope,
         jaqy142sbop,
         jaqy142tope,
         jaqy142perio,
         jaqy142nrcuo,
         jaqy142tsoli,
         jaqy142flcj,
         jaqy142cuoimp,
         jaqy142seguro,
         jaqy142capfc,
         jaqy142caplin,
         jaqy142capcuo,
         jaqy142indic,
         jaqy142est,
         jaqy142user,
         jaqy142fcorr)
      values
        (ln_corr + 1,
         pd_fecpro,
         lc_hora,
         lnPepais,
         lnPetdoc,
         lnPendoc,
         tipocambio,
         ln_Correlativo,
         ln_PGCOD,
         ln_MOD,
         ln_SUC,
         ln_MDA,
         ln_PAP,
         ln_CTA,
         ln_OPE,
         ln_SBOP,
         ln_TOPE,
         ln_peri10,
         ln_nrocuotas,
         ln_parciales,
         ln_flagFC,
         ln_cuotimp,
         ln_seguro,
         ln_CapFC,
         CapLinea,
         ln_CAPCUO,
         lc_IndCred,
         lc_IndEst,
         lc_Usuario,
         ld_fchcorre);
    
      commit;
    
    end;
  end sp_cr_LogCuentas;
  ------------------------------------------------------------- 
  procedure sp_cr_VerfLVInsertada(ln_corre      in number,
                                  ld_fchcorre   in date,
                                  lc_Estado     in varchar2,
                                  ln_pgcod117   number,
                                  ln_mod117     in number,
                                  ln_suc117     in number,
                                  ln_mda117     in number,
                                  ln_pap117     in number,
                                  ln_cta117     in number,
                                  ln_ope117     in number,
                                  ln_sbop117    in number,
                                  ln_tope117    in number,
                                  lc_RegInst116 out varchar2) is
  
    ln_pgcod116  number;
    ln_mod116    number;
    ln_suc116    number;
    ln_mda116    number;
    ln_pap116    number;
    ln_cta116    number;
    ln_ope116    number;
    ln_sbop116   number;
    ln_tope116   number;
    ln_NroReg142 number;
    lc_IndEst    varchar2(5) := 'H';
  
  begin
    lc_RegInst116 := 'N';
  
    lc_IndEst := 'H';
  
    begin
      select a.r1cod,
             a.r1mod,
             a.r1suc,
             a.r1mda,
             a.r1pap,
             a.r1cta,
             a.r1oper,
             a.r1sbop,
             a.r1tope
        into ln_pgcod116,
             ln_mod116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_ope116,
             ln_sbop116,
             ln_tope116
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod117
         and a.r2mod = ln_mod117
         and a.r2suc = ln_suc117
         and a.r2mda = ln_mda117
         and a.r2pap = ln_pap117
         and a.r2cta = ln_cta117
         and a.r2oper = ln_ope117
         and a.r2sbop = ln_sbop117
         and a.r2tope = ln_tope117
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
      when others then
        null;
    end;
  
    if ln_pgcod116 > 0 then
    
      begin
        select count(*)
          into ln_NroReg142
          from jaqy142a j
         where j.jaqy142corrlt = ln_corre
           and j.jaqy142fcorr = ld_fchcorre
           and j.jaqy142pgcod = ln_pgcod116
           and j.jaqy142mod = ln_mod116
           and j.jaqy142suc = ln_suc116
           and j.jaqy142mda = ln_mda116
           and j.jaqy142pap = ln_pap116
           and j.jaqy142cta = ln_cta116
           and j.jaqy142ope = ln_ope116
           and j.jaqy142sbop = ln_sbop116
           and j.jaqy142tope = ln_tope116
           and j.jaqy142est = lc_IndEst;
      exception
        when others then
          null;
      end;
    
      if ln_NroReg142 > 0 then
        lc_RegInst116 := 'S';
      else
        lc_RegInst116 := 'N';
      end if;
    end if;
  
  end;
  -------------------------------------------------------------
end PQ_CR_RATIOPYME_DTEN;
/

