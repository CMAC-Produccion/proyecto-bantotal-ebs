create or replace package pq_cr_caplineas_movil is

  -- Author  : MPOSTIGOC
  -- Created : 10/12/2019 04:46:54 p.m.
  -- Purpose : Ratio en Disposicion movil
  -- Fecha de Modificación      : 30/11/2023
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: se considero NVL para la variable de nro de cuotas en casos de flujo de caja
  -- Fecha de Modificación      : 15/03/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se descomento el monto de cuota potencial en el denominador de la formula
  -- Fecha de Modificación      : 03/06/2025
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: En el procedimiento sp_Cr_resultadnetoyRCC se cambio los trim por RPAD 

  -----------------------------------------------------

  procedure sp_cuentas(pn_emp           in number,
                       pn_mod           in number,
                       pn_suc           in number,
                       pn_mda           in number,
                       pn_pap           in number,
                       pn_cta           in number,
                       pn_ope           in number,
                       pn_sbo           in number,
                       pn_top           in number,
                       LN_ITPGCOD       in number,
                       LN_ITSUC         in number,
                       LN_ITMOD         in number,
                       LN_ITTRAN        in number,
                       LN_ITNREL        in number,
                       LN_ITORD         in number,
                       LN_ITSBOR        in number,
                       pd_fecpro        in date,
                       ln_monto         in number,
                       ln_plazo         in number,
                       ln_captotcaja    out number,
                       ln_resultadorcc  out number,
                       ln_resultadoneto out number,
                       ln_Ratio         out number,
                       lc_MostrarMnsj   out varchar2);
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
  procedure sp_instancia(ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_SNG001Ori out number,
                         ln_instancia out number);
  -------------------------------------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            ln_sbop10     in number,
                            ln_tope10     in number,
                            ln_TipCamb    in number,
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
                                 ln_subop10    in number,
                                 ln_tope10     in number,
                                 ln_TipCamb    in number,
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
                      ln_TipCamb      in number,
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
                              ln_TipCamb in number,
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
  procedure sp_capacidadpago(ln_MAX_CUOTA    in number,
                             ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_capacidad    out number);
  -----------------------------------------------------
  procedure sp_capacidadpagoparc(ln_NRO_CUOTAS   in number,
                                 ln_SNG001Ori    in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_ln_instancia in number,
                                 ln_TipCamb      in number,
                                 ln_suc10        in number,
                                 ln_mda10        in number,
                                 ln_pap10        in number,
                                 ln_cta10        in number,
                                 ln_oper10       in number,
                                 ln_sbop10       in number,
                                 ln_tope10       in number,
                                 ln_indicador    in number,
                                 ln_cuoparc      out number,
                                 ln_capacidad    out number);
  --------------------------------------------------------
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         lc_pendoc    in char,
                         ln_instancia in number,
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
                         ln_peri10    in number,
                         ln_TipCamb   in number,
                         ln_indicador in number,
                         lc_IndCred   in varchar2,
                         lc_flgprg    in varchar2,
                         LN_ITPGCOD   in number,
                         LN_ITSUC     in number,
                         LN_ITMOD     in number,
                         LN_ITTRAN    in number,
                         LN_ITNREL    in number,
                         LN_ITORD     in number,
                         LN_ITSBOR    in number,
                         lv_usuario   in varchar2,
                         ln_capacidad out number);
  ----------------------------------------------------------
  --mod 2016.04.13
  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2);
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
                                ln_TipCamb    in number,
                                ln_cuoimp     out number,
                                fech_maxcuota out date);
  ------------------------------------------------------------

  procedure sp_capacidadpago_Lin(ln_MAX_CUOTA    in number,
                                 ln_NRO_CUOTAS   in number,
                                 ln_peri10       in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_capacidad    out number);
  ------------------------------------------------------------
  procedure sp_Cr_resultadnetoyRCC(ln_pepais        in number,
                                   ln_petdoc        in number,
                                   lc_pendoc        in varchar2,
                                   ln_TipCamb       in number,
                                   ln_segmento      in number,
                                   ln_Instancia     in number,
                                   ln_resultadoneto out number,
                                   ln_resultadorcc  out number);
  -------------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                LN_ITPGCOD      in number,
                                LN_ITSUC        in number,
                                LN_ITMOD        in number,
                                LN_ITTRAN       in number,
                                LN_ITNREL       in number,
                                LN_ITORD        in number,
                                LN_ITSBOR       in number,
                                lc_Usuario      in varchar2,
                                ln_MntCuoCntgCF out number);
  -----------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  LN_ITPGCOD        in number,
                                  LN_ITSUC          in number,
                                  LN_ITMOD          in number,
                                  LN_ITTRAN         in number,
                                  LN_ITNREL         in number,
                                  LN_ITORD          in number,
                                  LN_ITSBOR         in number,
                                  lc_Usuario        in varchar2,
                                  ln_MntCuoCntgAval out number);
  -----------------------------------------------------------------
  procedure sp_cR_CuotaPotencial(ln_Instancia   in number,
                                 ln_MntPotncial out number);
  ---------------------------------------------------------------
  procedure sp_resolutor_venc(ln_Pepais    in number,
                              ln_Petdoc    in number,
                              lc_pendoc    in char,
                              ln_instancia in number,
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
                              ln_TipCamb   in number,
                              lc_IndCred   in varchar2,
                              LN_ITPGCOD   in number,
                              LN_ITSUC     in number,
                              LN_ITMOD     in number,
                              LN_ITTRAN    in number,
                              LN_ITNREL    in number,
                              LN_ITORD     in number,
                              LN_ITSBOR    in number,
                              lv_usuario   in varchar2,
                              ln_capacidad out number);
  -----------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais        in number,
                           ln_Petdoc        in number,
                           lc_pendoc        in char,
                           ln_TipCamb       in number,
                           ln_instancia     in number,
                           pd_fecpro        in date,
                           ln_captotcaja    in number,
                           ln_resultadorcc  in number,
                           ln_resultadoneto in number,
                           ln_captotal      in number,
                           lc_indicador     in varchar2,
                           LN_ITPGCOD       in number,
                           LN_ITSUC         in number,
                           LN_ITMOD         in number,
                           LN_ITTRAN        in number,
                           LN_ITNREL        in number,
                           LN_ITORD         in number,
                           LN_ITSBOR        in number,
                           lc_garant        in varchar2,
                           ln_segmen        in number,
                           lv_usuario       in varchar2,
                           pn_mod116        in number,
                           pn_suc116        in number,
                           pn_mda116        in number,
                           pn_pap116        in number,
                           pn_cta116        in number,
                           pn_ope116        in number,
                           pn_sbo116        in number,
                           pn_top116        in number,
                           ln_ccontg        in number,
                           ln_cpoten        in number);
  -------------------------------------------------------
  procedure sp_cr_LogCuentas(lnPepais     in number,
                             lnPetdoc     in number,
                             lnPendoc     in char,
                             ln_TipCamb   in number,
                             ln_instancia in number,
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
                             ln_peri10    in number,
                             ln_nrocuotas in number,
                             ln_parciales in number,
                             ln_flagFC    in varchar2,
                             ln_cuotimp   in number,
                             ln_seguro    in number,
                             ln_CapFC     in number,
                             CapLinea     in number,
                             ln_CAPCUO    in number,
                             lc_IndCred   IN VARCHAR2,
                             LN_ITPGCOD   in number,
                             LN_ITSUC     in number,
                             LN_ITMOD     in number,
                             LN_ITTRAN    in number,
                             LN_ITNREL    in number,
                             LN_ITORD     in number,
                             LN_ITSBOR    in number,
                             lv_usuario   in varchar2);

  --------------------------------------------------------------------
  procedure sp_cr_NroCuotEstim(pn_emp     in number,
                               pn_mod     in number,
                               pn_suc     in number,
                               pn_mda     in number,
                               pn_pap     in number,
                               pn_cta     in number,
                               pn_ope     in number,
                               pn_sbo     in number,
                               pn_top     in number,
                               LN_ITPGCOD in number,
                               LN_ITSUC   in number,
                               LN_ITMOD   in number,
                               LN_ITTRAN  in number,
                               LN_ITNREL  in number,
                               LN_ITORD   in number,
                               LN_ITSBOR  in number,
                               pd_fecpro  in date,
                               ln_monto   in number,
                               ln_plazo   in number,
                               ln_MinCuo  out number,
                               ln_MaxCuo  out number,
                               lc_TipMnsj out varchar);

end pq_cr_caplineas_movil;
/
create or replace package body pq_cr_caplineas_movil is
  -- *****************************************************************
  -- Nombre                     : pq_cr_caplineas_movil
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : Maria Postigo
  -- Uso                        : Calcula el Ratio en Disposicion de Lineas Movil
  -- Estado                     : Activo
  -- Acceso                     : Público
  --
  -- *****************************************************************

  procedure sp_cuentas(pn_emp           in number,
                       pn_mod           in number,
                       pn_suc           in number,
                       pn_mda           in number,
                       pn_pap           in number,
                       pn_cta           in number,
                       pn_ope           in number,
                       pn_sbo           in number,
                       pn_top           in number,
                       LN_ITPGCOD       in number,
                       LN_ITSUC         in number,
                       LN_ITMOD         in number,
                       LN_ITTRAN        in number,
                       LN_ITNREL        in number,
                       LN_ITORD         in number,
                       LN_ITSBOR        in number,
                       pd_fecpro        in date,
                       ln_monto         in number,
                       ln_plazo         in number,
                       ln_captotcaja    out number,
                       ln_resultadorcc  out number,
                       ln_resultadoneto out number,
                       ln_Ratio         out number,
                       lc_MostrarMnsj   out varchar2) is
  
    cursor inserta_vencidos(ln_Pepais in number,
                            ln_Petdoc in number,
                            lc_pendoc in varchar2) is
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
                              and pendoc = lc_pendoc)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 1))
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
         and c.pendoc = lc_pendoc
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
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 1))
                  and modulo not in (29, 33, 200)))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto < pd_fecpro;
  
    cursor inserta(ln_Pepais in number,
                   ln_Petdoc in number,
                   lc_pendoc in varchar2) is
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
                              and pendoc = lc_pendoc)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 1))
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
         and c.pendoc = lc_pendoc
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
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 1))
                  and modulo not in (29, 33, 200)) or b.Aomod = 117)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto >= pd_fecpro;
  
    cursor vuelo(ln_Pepais in number,
                 ln_Petdoc in number,
                 lc_pendoc in varchar2) is
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
                                and pendoc = lc_pendoc)
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and tp1corr1 = 13
                                        and tp1corr2 = 1))
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
         and s.sng120ins = XWFPRCINS
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
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = lc_pendoc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and x.xwfempresa = 1
         and (xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 1))
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
         and s.sng120ins = XWFPRCINS
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
  
    cursor lineas_ven(ln_Pepais in number,
                      ln_Petdoc in number,
                      lc_pendoc in varchar2) is
    
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
       where Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = lc_pendoc)
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
         and c.pendoc = lc_pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    ln_capacidad      number(10, 2) := 0.00;
    lc_FlgLn          varchar2(2);
    lc_fgAdic         varchar2(1);
    lc_fgAmpl         varchar2(1);
    lc_ven            char(1);
    ln_indicador      number(10);
    lc_fgRefLin       varchar2(1);
    lc_flgprg         varchar2(2) := 'N';
    lc_pendoc         varchar2(12);
    ln_pepais         number;
    ln_Petdoc         number;
    ln_instancia      number := 0;
    lc_garant         varchar2(5) := 'N';
    ln_segmen         number := 0;
    lv_usuario        varchar2(10);
    lc_IndCred        varchar2(10);
    ln_periodo        number;
    ln_TipCamb        number(14, 8);
    ln_MntCuoCntgAval NUMBER(17, 2) := 0;
    ln_MntCuoCntgCF   NUMBER(17, 2) := 0;
    ln_MntPotncial    number(17, 2) := 0;
    ln_MntCuoCntg     number(17, 2) := 0;
    ln_numerador      number := 0.00;
    ln_denominador    number := 0.00;
    ln_resultado      number(10, 6) := 0.00;
    ln_tasa           number := 0.00;
    ln_montoAux       number := 0.00;
    ln_CuotLineaMovil number(17, 2) := 0;
    ln_tiposoli       number;
    lc_FlagCompRat    varchar2(2) := 'N';
    ln_RatioAComparar number := 0.00;
    lc_ExcpInst       varchar2(2) := 'N';
    lc_EvalFlujo      varchar2(2) := 'N';
    ln_pgcod116       number := 0;
    ln_mod116         number := 0;
    ln_suc116         number := 0;
    ln_mda116         number := 0;
    ln_pap116         number := 0;
    ln_cta116         number := 0;
    ln_oper116        number := 0;
    ln_sbop116        number := 0;
    ln_116tope        number := 0;
    ln_LineaUtilzd    number(17, 2) := 0.00;
    lc_EsAdicional    varchar2(2) := 'N';
  
  begin
  
    ln_captotcaja := 0;
    lc_flgprg     := 'S';
  
    begin
      select trim(f.tp1desc)
        into lv_usuario
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 150
         and f.tp1corr2 = 1
         and f.tp1nro2 = LN_ITMOD
         and f.tp1nro3 = LN_ITTRAN;
    exception
      when others then
        lv_usuario := 'OTROS';
    end;
  
    begin
      ln_TipCamb := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
    end;
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pepais, ln_Petdoc, lc_pendoc
        from fsr008 f
       where f.ctnro = pn_cta
         and f.cttfir = 'T';
    
    end;
  
    begin
      select 'S'
        into lc_garant
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10823
         and Tp1corr1 = 9
         and Tp1corr2 = 2
         and Tp1nro1 = pn_top;
    exception
      when others then
        lc_garant := 'N';
    end;
  
    begin
      pq_cr_resolutor_lineas.sp_validar_segmento(P_N_PAIS    => ln_pepais,
                                                 p_n_tipdoc  => ln_Petdoc,
                                                 p_c_numdoc  => lc_pendoc,
                                                 pn_retornar => ln_segmen);
    end;
  
    begin
      ln_instancia := fn_instancia_credito(v_Scmod  => pn_mod,
                                           v_Scsuc  => pn_suc,
                                           v_Scmda  => pn_mda,
                                           v_Scpap  => pn_pap,
                                           v_Sccta  => pn_cta,
                                           v_Scoper => pn_ope,
                                           v_Scsbop => pn_sbo,
                                           v_Sctope => pn_top);
    end;
  
    begin
      delete aqpa271a j
       where j.aqpa271aipgcod = LN_ITPGCOD
         and j.aqpa271aitsuc = LN_ITSUC
         and j.aqpa271aitmod = LN_ITMOD
         and j.aqpa271aittran = LN_ITTRAN
         and j.aqpa271aitnrel = LN_ITNREL
         and j.aqpa271aitord = LN_ITORD
         and j.aqpa271aitsbor = LN_ITSBOR
         and j.aqpa271afec = pd_fecpro
         and j.aqpa271aest = 'I';
      /*UPDATE AQPA271A j
        set AQPA271Aest = 'I'
      where j.AQPA271Ainst = ln_instancia
        and j.AQPA271Aest = 'H';*/
      commit;
    
      delete aqpa270a j
       where j. aqpa270apgcod = LN_ITPGCOD
         and j.aqpa270aitsuc = LN_ITSUC
         and j.aqpa270aitmod = LN_ITMOD
         and j.aqpa270aittran = LN_ITTRAN
         and j.aqpa270aitnrel = LN_ITNREL
         and j.aqpa270aitord = LN_ITORD
         and j.aqpa270aitsbor = LN_ITSBOR
         and j.aqpa270afec = pd_fecpro
         and j.aqpa270aest = 'I';
    
      /*UPDATE AQPA270A j
        set AQPA270Aest = 'I'
      where j.AQPA270Ainst = ln_instancia
        and j.AQPA270Aest = 'H';*/
      commit;
    
    end;
  
    for i in inserta(ln_pepais, ln_Petdoc, lc_pendoc) loop
    
      if i.ln_mod10 <> pn_mod or i.ln_cta10 <> pn_cta or
         i.ln_oper10 <> pn_ope or i.ln_sbop10 <> pn_sbo or
         i.ln_tope10 <> pn_top then
      
        lc_fgAdic    := null;
        lc_fgAmpl    := null;
        ln_indicador := 1;
        lc_IndCred   := 'CredVigent';
        lc_FlgLn     := 'N';
      
        pq_cr_caplineas_movil.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
      
        pq_cr_caplineas_movil.Sp_Adicional_CK(i.ln_mod10,
                                              i.ln_tope10,
                                              lc_fgAdic);
        pq_cr_caplineas_movil.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
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
      
        if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and
           lc_FlgLn <> 'S' and i.ln_tope10 <> 550 then
          pq_cr_caplineas_movil.sp_resolutor(ln_Pepais,
                                             ln_Petdoc,
                                             lc_pendoc,
                                             ln_instancia,
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
                                             ln_TipCamb,
                                             ln_indicador,
                                             lc_IndCred,
                                             lc_flgprg,
                                             LN_ITPGCOD,
                                             LN_ITSUC,
                                             LN_ITMOD,
                                             LN_ITTRAN,
                                             LN_ITNREL,
                                             LN_ITORD,
                                             LN_ITSBOR,
                                             lv_usuario,
                                             ln_capacidad);
        
          ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        end if;
      end if;
    end loop;
  
    for i in inserta_vencidos(ln_pepais, ln_Petdoc, lc_pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      pq_cr_caplineas_movil.sp_refinanLinea(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            lc_fgRefLin);
    
      pq_cr_caplineas_movil.Sp_Adicional_CK(i.ln_mod10,
                                            i.ln_tope10,
                                            lc_fgAdic);
    
      pq_cr_caplineas_movil.Sp_ampliados_CK(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            i.ln_sbop10,
                                            i.ln_tope10,
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
    
      if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and
         lc_FlgLn <> 'S' and i.ln_tope10 <> 550 then
        pq_cr_caplineas_movil.sp_resolutor(ln_Pepais,
                                           ln_Petdoc,
                                           lc_pendoc,
                                           ln_instancia,
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
                                           ln_TipCamb,
                                           ln_indicador,
                                           lc_IndCred,
                                           lc_flgprg,
                                           LN_ITPGCOD,
                                           LN_ITSUC,
                                           LN_ITMOD,
                                           LN_ITTRAN,
                                           LN_ITNREL,
                                           LN_ITORD,
                                           LN_ITSBOR,
                                           lv_usuario,
                                           ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    end loop;
  
    for c in vuelo(ln_pepais, ln_Petdoc, lc_pendoc) loop
    
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
      ln_periodo   := c.ln_peri10;
    
      begin
        select tp1imp1
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
        -- mpostigoc 22062020
      
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
    
      pq_cr_caplineas_movil.Sp_Adicional_CK(c.ln_mod10,
                                            c.ln_tope10,
                                            lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        pq_cr_caplineas_movil.sp_resolutor(ln_Pepais,
                                           ln_Petdoc,
                                           lc_pendoc,
                                           ln_instancia,
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
                                           ln_TipCamb,
                                           ln_indicador,
                                           lc_IndCred,
                                           lc_flgprg,
                                           LN_ITPGCOD,
                                           LN_ITSUC,
                                           LN_ITMOD,
                                           LN_ITTRAN,
                                           LN_ITNREL,
                                           LN_ITORD,
                                           LN_ITSBOR,
                                           lv_usuario,
                                           ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    end loop;
  
    for j in lineas_ven(ln_pepais, ln_Petdoc, lc_pendoc) loop
    
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
    
      pq_cr_caplineas_movil.Sp_Adicional_CK(j.ln_mod10,
                                            j.ln_tope10,
                                            lc_fgAdic);
    
      pq_cr_caplineas_movil.sp_refinanLinea(J.ln_pgcod10,
                                            J.ln_mod10,
                                            J.ln_suc10,
                                            J.ln_mda10,
                                            J.ln_pap10,
                                            J.ln_cta10,
                                            J.ln_oper10,
                                            lc_fgRefLin);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(j.ln_mod10,
                                                 j.ln_suc10,
                                                 j.ln_mda10,
                                                 j.ln_pap10,
                                                 j.ln_cta10,
                                                 j.ln_oper10,
                                                 j.ln_sbop10,
                                                 j.ln_tope10,
                                                 lc_FlgLn);
    
      if lc_ven = 'S' and lc_fgAdic <> 'S' and lc_fgRefLin <> 'S' and
         lc_FlgLn <> 'S' then
      
        pq_cr_caplineas_movil.sp_resolutor_venc(ln_Pepais,
                                                ln_Petdoc,
                                                lc_pendoc,
                                                ln_instancia,
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
                                                ln_TipCamb,
                                                lc_IndCred,
                                                LN_ITPGCOD,
                                                LN_ITSUC,
                                                LN_ITMOD,
                                                LN_ITTRAN,
                                                LN_ITNREL,
                                                LN_ITORD,
                                                LN_ITSBOR,
                                                lv_usuario,
                                                ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    end loop;
  
    begin
      -- Verifica y calcula la cuota para la disposicion movil
      pq_cr_caplineas_movil.Sp_Adicional_CK(pn_mod  => pn_mod,
                                            pn_top  => pn_top,
                                            Pc_flag => lc_EsAdicional);
    
      if lc_EsAdicional = 'N' then
      
        lc_IndCred := 'LineaMovil';
      
        begin
          select s.sng001ori
            into ln_tiposoli
            from sng001 s
           where s.sng001inst = ln_instancia;
        exception
          when others then
            null;
        end;
      
        begin
          select aotasa
            into ln_tasa
            from fsd010
           where pgcod = pn_emp
             and aocta = pn_cta
             and aooper = pn_ope
             and aomod = pn_mod
             and aosuc = pn_suc
             and aomda = pn_mda
             and aopap = pn_pap
             and aosbop = pn_sbo
             and aotope = pn_top;
        exception
          when others then
            ln_tasa := 0;
        end;
      
        if LN_ITTRAN = 61 then
          begin
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
                     ln_oper116,
                     ln_sbop116,
                     ln_116tope
                from fsr011 a, fsd010 b
               where a.r2cod = pn_emp
                 and a.r2mod = pn_mod
                 and a.r2suc = pn_suc
                 and a.r2mda = pn_mda
                 and a.r2pap = pn_pap
                 and a.r2cta = pn_cta
                 and a.r2oper = pn_ope
                 and a.r2sbop = pn_sbo
                 and a.r2tope = pn_top
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
                         ln_oper116,
                         ln_sbop116,
                         ln_116tope
                    from fsr011 a, fsd010 b
                   where a.r2cod = pn_emp
                     and a.r2mod = pn_mod
                     and a.r2suc = pn_suc
                     and a.r2mda = pn_mda
                     and a.r2pap = pn_pap
                     and a.r2cta = pn_cta
                     and a.r2oper = pn_ope
                        -- and a.r2sbop = pn_sbo
                     and a.r2tope = pn_top
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
            end;
          
            if ln_pgcod116 > 0 then
              begin
                select f.scsdo * -1
                  into ln_LineaUtilzd
                  from fsd011 f
                 where f.pgcod = ln_pgcod116
                   and f.scmod = ln_mod116
                   and f.scsuc = ln_suc116
                   and f.scmda = ln_mda116
                   and f.scpap = ln_pap116
                   and f.sccta = ln_cta116
                   and f.scoper = ln_oper116
                   and f.scsbop = ln_sbop116
                   and f.sctope = ln_116tope;
              exception
                when others then
                  null;
              end;
            
              ln_LineaUtilzd := nvl(ln_LineaUtilzd, 0);
            end if;
          
          end;
          ln_montoAux := nvl(ln_LineaUtilzd, 0) + nvl(ln_monto, 0);
        
        else
          ln_montoAux := nvl(ln_monto, 0);
        
        end if;
      
        begin
        
          ln_CuotLineaMovil := (ln_montoAux *
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                               (1 - power((1 + ((power((1 + (ln_tasa / 100)),
                                                       (1 / 12))) - 1)),
                                          -ln_plazo));
        end;
      
        begin
          if ln_CuotLineaMovil > 0 then
          
            pq_cr_caplineas_movil.sp_cr_LogCuentas(lnPepais     => ln_Pepais,
                                                   lnPetdoc     => ln_Petdoc,
                                                   lnPendoc     => lc_pendoc,
                                                   ln_TipCamb   => ln_TipCamb,
                                                   ln_instancia => ln_instancia,
                                                   pd_fecpro    => pd_fecpro,
                                                   ln_PGCOD     => pn_emp,
                                                   ln_MOD       => pn_mod,
                                                   ln_SUC       => pn_suc,
                                                   ln_MDA       => pn_mda,
                                                   ln_PAP       => pn_pap,
                                                   ln_CTA       => pn_cta,
                                                   ln_OPE       => pn_ope,
                                                   ln_SBOP      => pn_sbo,
                                                   ln_TOPE      => pn_top,
                                                   ln_peri10    => 30,
                                                   ln_nrocuotas => ln_plazo,
                                                   ln_parciales => ln_tiposoli,
                                                   ln_flagFC    => 'N',
                                                   ln_cuotimp   => ln_montoAux,
                                                   ln_seguro    => 0,
                                                   ln_CapFC     => 0,
                                                   CapLinea     => ln_CuotLineaMovil,
                                                   ln_CAPCUO    => ln_CuotLineaMovil,
                                                   lc_IndCred   => lc_IndCred,
                                                   LN_ITPGCOD   => LN_ITPGCOD,
                                                   LN_ITSUC     => LN_ITSUC,
                                                   LN_ITMOD     => LN_ITMOD,
                                                   LN_ITTRAN    => LN_ITTRAN,
                                                   LN_ITNREL    => LN_ITNREL,
                                                   LN_ITORD     => LN_ITORD,
                                                   LN_ITSBOR    => LN_ITSBOR,
                                                   lv_usuario   => lv_usuario);
          
          end if;
        end;
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_CuotLineaMovil, 0);
      end if;
    end;
  
    begin
      pq_cr_caplineas_movil.sp_Cr_resultadnetoyRCC(ln_pepais        => ln_pepais,
                                                   ln_petdoc        => ln_petdoc,
                                                   lc_pendoc        => lc_pendoc,
                                                   ln_TipCamb       => ln_TipCamb,
                                                   ln_segmento      => ln_segmen,
                                                   ln_Instancia     => ln_instancia,
                                                   ln_resultadoneto => ln_resultadoneto,
                                                   ln_resultadorcc  => ln_resultadorcc);
    
    end;
  
    pq_cr_caplineas_movil.sp_cr_CuotaContinAval(ln_Instancia      => ln_instancia,
                                                LN_ITPGCOD        => LN_ITPGCOD,
                                                LN_ITSUC          => LN_ITSUC,
                                                LN_ITMOD          => LN_ITMOD,
                                                LN_ITTRAN         => LN_ITTRAN,
                                                LN_ITNREL         => LN_ITNREL,
                                                LN_ITORD          => LN_ITORD,
                                                LN_ITSBOR         => LN_ITSBOR,
                                                lc_Usuario        => lv_usuario,
                                                ln_MntCuoCntgAval => ln_MntCuoCntgAval);
  
    pq_cr_caplineas_movil.sp_cr_CuotaContinCF(ln_Instancia    => ln_instancia,
                                              LN_ITPGCOD      => LN_ITPGCOD,
                                              LN_ITSUC        => LN_ITSUC,
                                              LN_ITMOD        => LN_ITMOD,
                                              LN_ITTRAN       => LN_ITTRAN,
                                              LN_ITNREL       => LN_ITNREL,
                                              LN_ITORD        => LN_ITORD,
                                              LN_ITSBOR       => LN_ITSBOR,
                                              lc_Usuario      => lv_usuario,
                                              ln_MntCuoCntgCF => ln_MntCuoCntgCF);
  
    ln_MntCuoCntg := NVL(ln_MntCuoCntgAval, 0) + nvl(ln_MntCuoCntgCF, 0); -- cuota contingente
  
    pq_cr_caplineas_movil.sp_cR_CuotaPotencial(ln_instancia   => ln_instancia,
                                               ln_MntPotncial => ln_MntPotncial);
  
    ln_captotcaja    := nvl(ln_captotcaja, 0);
    ln_resultadorcc  := nvl(ln_resultadorcc, 0);
    ln_MntCuoCntg    := nvl(ln_MntCuoCntg, 0);
    ln_MntPotncial   := nvl(ln_MntPotncial, 0);
    ln_resultadoneto := nvl(ln_resultadoneto, 0);
  
    ln_numerador   := (ln_captotcaja + ln_resultadorcc + ln_MntCuoCntg +
                      ln_MntPotncial);
    ln_denominador := (ln_resultadoneto + ln_resultadorcc + ln_MntPotncial);
  
    if ln_denominador <> 0 then
      ln_resultado := Round(ln_numerador / ln_denominador, 6);
    else
      ln_resultado := 0;
    end if;
  
    ln_Ratio := nvl(ln_resultado, 0);
  
    begin
    
      pq_cr_caplineas_movil.sp_cr_LogRatiO(ln_Pepais        => ln_Pepais,
                                           ln_Petdoc        => ln_Petdoc,
                                           lc_pendoc        => lc_pendoc,
                                           ln_TipCamb       => ln_TipCamb,
                                           ln_instancia     => ln_instancia,
                                           pd_fecpro        => pd_fecpro,
                                           ln_captotcaja    => ln_captotcaja,
                                           ln_resultadorcc  => ln_resultadorcc,
                                           ln_resultadoneto => ln_resultadoneto,
                                           ln_captotal      => ln_Ratio,
                                           lc_indicador     => 'P',
                                           LN_ITPGCOD       => LN_ITPGCOD,
                                           LN_ITSUC         => LN_ITSUC,
                                           LN_ITMOD         => LN_ITMOD,
                                           LN_ITTRAN        => LN_ITTRAN,
                                           LN_ITNREL        => LN_ITNREL,
                                           LN_ITORD         => LN_ITORD,
                                           LN_ITSBOR        => LN_ITSBOR,
                                           lc_garant        => lc_garant,
                                           ln_segmen        => ln_segmen,
                                           lv_usuario       => lv_usuario,
                                           pn_mod116        => pn_mod,
                                           pn_suc116        => pn_suc,
                                           pn_mda116        => pn_mda,
                                           pn_pap116        => pn_pap,
                                           pn_cta116        => pn_cta,
                                           pn_ope116        => pn_ope,
                                           pn_sbo116        => pn_sbo,
                                           pn_top116        => pn_top,
                                           ln_ccontg        => ln_MntCuoCntg,
                                           ln_cpoten        => ln_MntPotncial);
    end;
  
    begin
      -- Call the procedure
      pq_cr_resolutor_lineas.sp_empresa_lineatmp(ln_instancia => ln_instancia,
                                                 lv_flag90    => lc_FlagCompRat,
                                                 ln_valor     => ln_RatioAComparar);
    end;
  
    begin
    
      select 'S'
        into lc_ExcpInst
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10823
         and Tp1corr1 = 9
         and Tp1corr2 = 3
         and Tp1nro1 = ln_instancia;
    exception
      when others then
        lc_ExcpInst := 'N';
    end;
  
    begin
      -- Call the procedure                                 
      pq_cr_rtes_dispmovil.sp_cr_verfevalflujo(ln_mod117    => pn_mod,
                                               ln_suc117    => pn_suc,
                                               ln_mda117    => pn_mda,
                                               ln_pap117    => pn_pap,
                                               ln_cta117    => pn_cta,
                                               ln_oper117   => pn_ope,
                                               ln_sbop117   => pn_sbo,
                                               ln_tope117   => pn_top,
                                               ln_evalflujo => lc_EvalFlujo);
    end;
  
    if ln_segmen = 1 and lc_EvalFlujo = 'N' and lc_garant = 'N' and
       lc_ExcpInst = 'N' then
    
      if ln_Ratio < 0 then
        lc_MostrarMnsj := 'S';
      else
        if ln_Ratio <= ln_RatioAComparar then
          lc_MostrarMnsj := 'N';
        else
          lc_MostrarMnsj := 'S';
        end if;
      end if;
    else
      lc_MostrarMnsj := 'N';
    end if;
  
  end sp_cuentas;
  --------------------------------------------------------------------------------

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
  procedure sp_instancia(ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_SNG001Ori out number,
                         ln_instancia out number) is
  
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
                           v_instancia => ln_instancia);
    end;
  
    begin
      select SNG001Ori
        into ln_SNG001Ori
        from sng001 s01
       where s01.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
  end sp_instancia;
  ---------------------------------------------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            ln_sbop10     in number,
                            ln_tope10     in number,
                            ln_TipCamb    in number,
                            ln_cuoimp     out number,
                            fech_maxcuota out date) is
  
    lc_estado character(1);
    ld_fecha  date;
  
  begin
  
    if ln_mod10 <> 117 then
    
      BEGIN
        select max(ppfpag)
          into ld_fecha
          from fsd602 d
         where d.pgcod = ln_pgcod10
           and d.ppmod = ln_mod10
           and d.ppsuc = ln_suc10
           and d.ppmda = ln_mda10
           and d.pppap = ln_pap10
           and d.ppcta = ln_cta10
           and d.ppoper = ln_oper10
           and d.ppsbop = ln_sbop10
           and d.pptope = ln_tope10
           and D602CO = 'S';
      exception
        when others then
          NULL;
        
      END;
    
      begin
        select max(f602.pp1stat)
          into lc_estado
          from fsd602 f602
         where f602.pgcod = ln_pgcod10
           and f602.ppmod = ln_mod10
           and f602.ppsuc = ln_suc10
           and f602.ppmda = ln_mda10
           and f602.pppap = ln_pap10
           and f602.ppcta = ln_cta10
           and f602.ppoper = ln_oper10
           and f602.ppsbop = ln_sbop10
           and f602.pptope = ln_tope10
           and f602.ppfpag = ld_fecha
           and D602CO = 'S';
      exception
        when others then
          NULL;
      end;
    
      if lc_estado = 'T' or lc_estado = 'P' then
        if lc_estado = 'P' then
        
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
               and ppsbop = ln_sbop10
               and pptope = ln_tope10
               and ppfpag >= ld_fecha;
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
                   and ppsbop = ln_sbop10
                   and pptope = ln_tope10
                   and ppfpag >= ld_fecha
                   and rownum = 1;
              exception
                when others then
                  NULL;
              end;
          end;
        else
          if lc_estado = 'T' then
          
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
                 and ppsbop = ln_sbop10
                 and pptope = ln_tope10
                 and ppfpag > ld_fecha;
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
                     and ppsbop = ln_sbop10
                     and pptope = ln_tope10
                     and ppfpag > ld_fecha
                     and rownum = 1;
                exception
                  when others then
                  
                    NULL;
                end;
            end;
          end if;
        end if;
      
      else
        if lc_estado is null then
          begin
            select max(ppcap + ppint)
              into ln_cuoimp
              from fsd601 d
             where pgcod = ln_pgcod10
               and ppmod = ln_mod10
               and ppsuc = ln_suc10
               and ppmda = ln_mda10
               and pppap = ln_pap10
               and ppcta = ln_cta10
               and ppoper = ln_oper10
               and ppsbop = ln_sbop10
               and pptope = ln_tope10;
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
           and ppsbop = ln_sbop10
           and pptope = ln_tope10
           and (ppcap + ppint) = ln_cuoimp
           and rownum = 1;
      exception
        when others then
          NULL;
        
      end;
    
      if ln_mda10 = 101 then
        ln_cuoimp := nvl(ln_cuoimp, 0) * ln_TipCamb;
      end if;
    
    end if;
  
  end sp_cuota_impaga;
  -------------------------------------------------------------------
  procedure sp_cuota_impagavuelo(ln_pgcod10    in number,
                                 ln_mod10      in number,
                                 ln_suc10      in number,
                                 ln_mda10      in number,
                                 ln_pap10      in number,
                                 ln_cta10      in number,
                                 ln_oper10     in number,
                                 ln_subop10    in number,
                                 ln_tope10     in number,
                                 ln_TipCamb    in number,
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
         and d.ppsbop = ln_subop10
         and d.pptope = ln_tope10
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
         and d.ppsbop = ln_subop10
         and d.pptope = ln_tope10
         and d.d601co = 'X'
         and (d.ppcap + d.ppint) = ln_cuoimp
         and rownum = 1;
    exception
      when others then
        NULL;
      
    end;
  
    if ln_mda10 = 101 then
      ln_cuoimp := nvl(ln_cuoimp, 0) * ln_TipCamb;
    end if;
  
  end sp_cuota_impagavuelo;
  -------------------------------------------------------------
  procedure sp_seguro(ln_mod10        in number,
                      ln_suc10        in number,
                      ln_mda10        in number,
                      ln_pap10        in number,
                      ln_cta10        in number,
                      ln_oper10       in number,
                      ln_sbop10       in number,
                      ln_tope10       in number,
                      ln_TipCamb      in number,
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
      ln_monto_seguro := nvl(ln_monto_seguro, 0) * nvl(ln_TipCamb, 0);
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
                              ln_TipCamb in number,
                              ln_formula out number) is
  
    ln_plazo        number(10, 2);
    ln_tasa         number(10, 2);
    ln_saldo        number(10, 2);
    ln_instancia    number;
    ln_paralelo     number;
    ln_ln_instancia number;
    LN_TIPOCRED     number;
    lc_FlagSegmnt   varchar2(2);
    lc_FlagGuia     varchar2(1);
  
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
    
      begin
        ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod10,
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
         where w.wfinsprcid = ln_ln_instancia
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
          end;
        
        end if;
      end if;
    
    else
    
      if lc_FlagGuia = 'N' then
        -- Extraemos el plazo del Preseteo
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
        ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod10,
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
         where x.xwfprcins = ln_instancia
           and x.xwfcar3 = '1';
      exception
        when others then
          ln_saldo := 0.00;
      end;
    
      begin
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
       WHERE SNGE01INST = ln_instancia;
    exception
      when others then
        null;
    end;
  
    ln_saldo := nvl(ln_saldo, 0) - nvl(ln_paralelo, 0);
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * ln_TipCamb;
    end if;
  
    begin
    
      ln_formula := (ln_saldo *
                    ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                    (1 - power((1 +
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                               -ln_plazo));
    
    end;
  
  end sp_capacidadlinea;

  -----------------------------------------------------------
  procedure sp_capacidadpago(ln_MAX_CUOTA    in number,
                             ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_capacidad    out number) is
    ln_mensual number(10, 2);
    ln_cuota   number(10, 2);
  
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if ln_NRO_CUOTAS > 1 and ln_SNG001Ori <> 7 then
        
          ln_mensual := ln_peri10 / 30;
        
          ln_cuota := nvl(ln_MAX_CUOTA, 0) + nvl(ln_monto_seguro, 0);
        
          ln_capacidad := nvl(ln_cuota, 0) / nvl(ln_mensual, 0);
        
        end if;
      
      end if;
    end;
  end sp_capacidadpago;
  -----------------------------------------------------------------------
  procedure sp_capacidadpagoparc(ln_NRO_CUOTAS   in number,
                                 ln_SNG001Ori    in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_ln_instancia in number,
                                 ln_TipCamb      in number,
                                 ln_suc10        in number,
                                 ln_mda10        in number,
                                 ln_pap10        in number,
                                 ln_cta10        in number,
                                 ln_oper10       in number,
                                 ln_sbop10       in number,
                                 ln_tope10       in number,
                                 ln_indicador    in number,
                                 ln_cuoparc      out number,
                                 ln_capacidad    out number) is
    ln_mensual number(10, 2);
    ln_cuota   number(10, 2);
    ln_mtoPar  number(17, 2);
    ln_plazo   number(10, 2);
    ln_tasa    number(10, 2);
    ln_period  number;
    ln_cuo     number(10, 2);
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if ln_NRO_CUOTAS > 1 and ln_SNG001Ori = 7 then
        
          if ln_indicador = 2 then
            --Desembolsos parciales en vuelo          
            begin
              select a.sng120mto, A.SNG120TASA, A.SNG120CUO, a.sng120per
                into ln_mtoPar, ln_tasa, ln_plazo, ln_period
                from sng120 a
               where a.sng120ins = ln_ln_instancia
                 and a.sng120tsk like 'PROPUES%'
                 and rownum = 1;
            exception
              when others then
                null;
            end;
            if ln_mda10 = 101 then
              ln_mtoPar := ln_mtoPar * ln_TipCamb;
            end if;
          
            begin
            
              ln_cuo := (ln_mtoPar *
                        ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                        (1 - power((1 +
                                   ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                                   -ln_plazo));
            
              ln_mensual   := ln_period / 30;
              ln_cuota     := nvl(ln_cuo, 0) + nvl(ln_monto_seguro, 0);
              ln_capacidad := nvl(ln_cuota, 0) / ln_mensual; --mensualiza la cuota             
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
               where a.sng120ins = ln_ln_instancia
                 and a.sng120tsk like 'APROBAC%'
                 and rownum = 1;
            exception
              when others then
                null;
            end;
            if ln_mda10 = 101 then
              ln_mtoPar := ln_mtoPar * ln_TipCamb;
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
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         lc_pendoc    in char,
                         ln_instancia in number,
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
                         ln_peri10    in number,
                         ln_TipCamb   in number,
                         ln_indicador in number,
                         lc_IndCred   in varchar2,
                         lc_flgprg    in varchar2,
                         LN_ITPGCOD   in number,
                         LN_ITSUC     in number,
                         LN_ITMOD     in number,
                         LN_ITTRAN    in number,
                         LN_ITNREL    in number,
                         LN_ITORD     in number,
                         LN_ITSBOR    in number,
                         lv_usuario   in varchar2,
                         ln_capacidad out number) is
  
    ln_nrocuotas    number(10, 2);
    ln_parciales    number(10, 2);
    ln_cuotimp      number(10, 2) := 0;
    ln_seguro       number(10, 2);
    fech_maxcuota   date;
    ln_ln_instancia number;
    ln_flagFC       varchar2(1) := 'N';
    ln_CapFC        number(10, 2);
    CapLinea        number(10, 2);
    ln_cuoparc      number(10, 2);
  
  begin
  
    ln_CapFC := 0;
    CapLinea := 0;
  
    pq_cr_caplineas_movil.sp_cuotas(ln_pgcod10,
                                    ln_mod10,
                                    ln_suc10,
                                    ln_mda10,
                                    ln_pap10,
                                    ln_cta10,
                                    ln_oper10,
                                    ln_sbop10,
                                    ln_tope10,
                                    ln_nrocuotas);
  
    pq_cr_caplineas_movil.sp_instancia(ln_mod10     => ln_mod10,
                                       ln_suc10     => ln_suc10,
                                       ln_mda10     => ln_mda10,
                                       ln_pap10     => ln_pap10,
                                       ln_cta10     => ln_cta10,
                                       ln_oper10    => ln_oper10,
                                       ln_sbop10    => ln_sbop10,
                                       ln_tope10    => ln_tope10,
                                       ln_SNG001Ori => ln_parciales,
                                       ln_instancia => ln_ln_instancia);
  
    pq_cr_caplineas_movil.sp_cr_flujocaja(ln_pgcod10,
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
        pq_cr_caplineas_movil.sp_cuota_impaga(ln_pgcod10    => ln_pgcod10,
                                              ln_mod10      => ln_mod10,
                                              ln_suc10      => ln_suc10,
                                              ln_mda10      => ln_mda10,
                                              ln_pap10      => ln_pap10,
                                              ln_cta10      => ln_cta10,
                                              ln_oper10     => ln_oper10,
                                              ln_sbop10     => ln_sbop10,
                                              ln_tope10     => ln_tope10,
                                              ln_TipCamb    => ln_TipCamb,
                                              ln_cuoimp     => ln_cuotimp,
                                              fech_maxcuota => fech_maxcuota);
      
      else
      
        pq_cr_caplineas_movil.sp_cuota_impagavuelo(ln_pgcod10    => ln_pgcod10,
                                                   ln_mod10      => ln_mod10,
                                                   ln_suc10      => ln_suc10,
                                                   ln_mda10      => ln_mda10,
                                                   ln_pap10      => ln_pap10,
                                                   ln_cta10      => ln_cta10,
                                                   ln_oper10     => ln_oper10,
                                                   ln_subop10    => ln_sbop10,
                                                   ln_tope10     => ln_tope10,
                                                   ln_TipCamb    => ln_TipCamb,
                                                   ln_cuoimp     => ln_cuotimp,
                                                   fech_maxcuota => fech_maxcuota);
      
      end if;
    
    else
      if ln_mod10 <> 117 and ln_flagFC = 'S' then
        pq_cr_caplineas_movil.sp_cr_capacidadFC(ln_mod10,
                                                ln_suc10,
                                                ln_mda10,
                                                ln_pap10,
                                                ln_cta10,
                                                ln_oper10,
                                                ln_sbop10,
                                                ln_tope10,
                                                ln_TipCamb,
                                                ln_cuotimp);
      
        ln_CapFC := ln_cuotimp;
      
      end if;
    end if;
  
    pq_cr_caplineas_movil.sp_seguro(ln_mod10        => ln_mod10,
                                    ln_suc10        => ln_suc10,
                                    ln_mda10        => ln_mda10,
                                    ln_pap10        => ln_pap10,
                                    ln_cta10        => ln_cta10,
                                    ln_oper10       => ln_oper10,
                                    ln_sbop10       => ln_sbop10,
                                    ln_tope10       => ln_tope10,
                                    ln_TipCamb      => ln_TipCamb,
                                    fech_maxcuota   => fech_maxcuota,
                                    ln_monto_seguro => ln_seguro);
  
    if ln_mod10 = 117 then
      pq_cr_caplineas_movil.sp_capacidadlinea(ln_mod10   => ln_mod10,
                                              ln_suc10   => ln_suc10,
                                              ln_mda10   => ln_mda10,
                                              ln_pap10   => ln_pap10,
                                              ln_cta10   => ln_cta10,
                                              ln_oper10  => ln_oper10,
                                              ln_sbop10  => ln_sbop10,
                                              ln_tope10  => ln_tope10,
                                              ln_TipCamb => ln_TipCamb,
                                              ln_formula => ln_capacidad);
    
      CapLinea := ln_capacidad;
    
    end if;
  
    IF ln_parciales = 7 then
    
      pq_cr_caplineas_movil.sp_capacidadpagoparc(ln_NRO_CUOTAS   => ln_nrocuotas,
                                                 ln_SNG001Ori    => ln_parciales,
                                                 ln_monto_seguro => ln_seguro,
                                                 ln_mod10        => ln_mod10,
                                                 ln_ln_instancia => ln_ln_instancia,
                                                 ln_TipCamb      => ln_TipCamb,
                                                 ln_suc10        => ln_suc10,
                                                 ln_mda10        => ln_mda10,
                                                 ln_pap10        => ln_pap10,
                                                 ln_cta10        => ln_cta10,
                                                 ln_oper10       => ln_oper10,
                                                 ln_sbop10       => ln_sbop10,
                                                 ln_tope10       => ln_tope10,
                                                 ln_indicador    => ln_indicador,
                                                 ln_cuoparc      => ln_cuoparc,
                                                 ln_capacidad    => ln_capacidad);
    
      ln_cuotimp := ln_cuoparc;
    
    end if;
  
    if ln_mod10 <> 117 and ln_parciales <> 7 then
    
      pq_cr_caplineas_movil.sp_capacidadpago(ln_cuotimp,
                                             ln_nrocuotas,
                                             ln_parciales,
                                             ln_peri10,
                                             ln_seguro,
                                             ln_mod10,
                                             ln_capacidad);
    end if;
  
    if lc_flgprg = 'S' or lc_flgprg = 'R' or lc_flgprg = 'L' then
    
      if ln_capacidad > 0 then
      
        if ln_CapFC <> 0 then
          ln_cuotimp := 0;
        end if;
      
        pq_cr_caplineas_movil.sp_cr_LogCuentas(ln_Pepais,
                                               ln_Petdoc,
                                               lc_pendoc,
                                               ln_TipCamb,
                                               ln_instancia,
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
                                               LN_ITPGCOD,
                                               LN_ITSUC,
                                               LN_ITMOD,
                                               LN_ITTRAN,
                                               LN_ITNREL,
                                               LN_ITORD,
                                               LN_ITSBOR,
                                               lv_usuario);
      end if;
    end if;
  
  end sp_resolutor;

  --------------------------------------------------
  procedure sp_resolutor_venc(ln_Pepais    in number,
                              ln_Petdoc    in number,
                              lc_pendoc    in char,
                              ln_instancia in number,
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
                              ln_TipCamb   in number,
                              lc_IndCred   in varchar2,
                              LN_ITPGCOD   in number,
                              LN_ITSUC     in number,
                              LN_ITMOD     in number,
                              LN_ITTRAN    in number,
                              LN_ITNREL    in number,
                              LN_ITORD     in number,
                              LN_ITSBOR    in number,
                              lv_usuario   in varchar2,
                              ln_capacidad out number) is
    ln_nrocuotas  number;
    ln_cuotimp    number(10, 2);
    ln_seguro     number(10, 2);
    fech_maxcuota date;
    lc_ven        char(1);
  
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
    ln_capTem    number(10, 2);
    ln_parciales number;
    ln_flagFC    varchar2(2);
    ln_CapFC     number;
    CapLinea     number;
    ln_Insta     number;
  
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
      
        pq_cr_caplineas_movil.sp_cuotas(i.ln_pgcod10,
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
      
        pq_cr_caplineas_movil.sp_cuota_impaga_lin(i.ln_pgcod10,
                                                  i.ln_mod10,
                                                  i.ln_suc10,
                                                  i.ln_mda10,
                                                  i.ln_pap10,
                                                  i.ln_cta10,
                                                  i.ln_oper10,
                                                  ln_TipCamb,
                                                  ln_cuotimp,
                                                  fech_maxcuota);
      
        pq_cr_caplineas_movil.sp_seguro(ln_mod10        => i.ln_mod10,
                                        ln_suc10        => i.ln_suc10,
                                        ln_mda10        => i.ln_mda10,
                                        ln_pap10        => i.ln_pap10,
                                        ln_cta10        => i.ln_cta10,
                                        ln_oper10       => i.ln_oper10,
                                        ln_sbop10       => i.ln_sbop10,
                                        ln_tope10       => i.ln_tope10,
                                        ln_TipCamb      => ln_TipCamb,
                                        fech_maxcuota   => fech_maxcuota,
                                        ln_monto_seguro => ln_seguro);
      
        pq_cr_caplineas_movil.sp_capacidadpago_lin(ln_cuotimp,
                                                   ln_nrocuotas,
                                                   ln_pr116,
                                                   ln_seguro,
                                                   i.ln_mod10,
                                                   ln_capTem);
        pq_cr_caplineas_movil.sp_instancia(i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           ln_parciales,
                                           ln_Insta);
      
        if ln_capTem > 0 then
        
          ln_flagFC := 'N';
          ln_CapFC  := nvl(ln_CapFC, 0);
          CapLinea  := nvl(CapLinea, 0);
        
          pq_cr_caplineas_movil.sp_cr_LogCuentas(ln_Pepais,
                                                 ln_Petdoc,
                                                 lc_pendoc,
                                                 ln_TipCamb,
                                                 ln_instancia,
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
                                                 LN_ITPGCOD,
                                                 LN_ITSUC,
                                                 LN_ITMOD,
                                                 LN_ITTRAN,
                                                 LN_ITNREL,
                                                 LN_ITORD,
                                                 LN_ITSBOR,
                                                 lv_usuario);
        end if;
      
        ln_capacidad := nvl(ln_capacidad, 0) + nvl(ln_capTem, 0);
      
      end loop;
    end if;
  
  end sp_resolutor_venc;
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
                            Pc_flag   out varchar2) is
  
  begin
  
    begin
    
      select 'S'
        into Pc_flag
        from xwf700 a, sng001 s, wfwrkitems x
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
  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2) is
  
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
  
    ln_InstVerfca NUMBER;
  
  begin
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
           and f.relcod = 46;
      exception
        when no_data_found then
          ln_InstVerfca := 0;
      end;
    
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
    
    else
      begin
        select 'S'
          into lc_fgRefLin
          from xwf700 a, sng001 s, wfwrkitems x
         where a.xwfempresa = ln_pgcod10
           and a.xwfsucursal = ln_suc10
           and a.xwfmodulo = ln_mod10
           and a.xwfmoneda = ln_mda10
           and a.xwfpapel = ln_pap10
           and a.xwfcuenta = ln_cta10
           and a.xwfoperacion = ln_oper10
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
      -- verifica si tiene calendario de pago     
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
      -- Verifica si tiene calendario de Seguros 
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
    
      select tp1nro1
        into ln_nroflujo
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and tp1corr1 = 13
         and tp1corr2 = 3;
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
  
    ln_plazo  number := 0;
    ln_tasa   number(17, 6) := 0.00;
    ln_saldo  number(17, 2) := 0.00;
    instancia number;
    --ln_periodo number;
    ln_cuotas          number;
    ld_fchamort        date;
    lc_flagAmort       varchar2(2) := 'N';
    ln_CapPagado       number;
    ln_CapProgramad    number;
    ld_FchUltPagoTotal date;
  
  begin
  
    begin
      select max(evfval) --, 'S'
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
      
        ln_CapPagado := nvl(ln_CapPagado, 0);
      
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
      
        ln_CapProgramad := nvl(ln_CapProgramad, 0);
      
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
        
          begin
            instancia := fn_instancia_credito(v_Scmod  => ln_mod10,
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
              from sng120 s
             where s.sng120ins = instancia;
          exception
            when others then
              ln_cuotas := 0;
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
      
        ln_saldo := nvl(ln_saldo, 0);
      
        if ln_saldo = 0 then
          -- credito en vuelo
        
          begin
            instancia := fn_instancia_credito(v_Scmod  => ln_mod10,
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
             where x.xwfprcins = instancia
               and x.xwfcar3 = '1';
          exception
            when others then
              ln_saldo := 0;
          end;
        
          begin
            select max(sng120tasa)
              into ln_tasa
              from sng120
             where sng120ins = instancia;
          exception
            when others then
              ln_tasa := 0;
          end;
        
          begin
            select max(sng120cuo), max(sng120per)
              into ln_cuotas, ln_plazo
              from sng120 s
             where s.sng120ins = instancia;
          exception
            when others then
              ln_cuotas := 0;
              ln_plazo  := 0;
          end;
        
        end if;
      end if;
    end if;
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    if ln_mod10 <> 33 and ln_tasa > 0 and ln_plazo > 0 and ln_saldo > 0 and
       ln_cuotas > 0 then
    
      begin
      
        ln_tasa := ((power(1 + (ln_tasa / 100), (ln_plazo / 360))) - 1) * 100;
      end;
    
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
                                ln_TipCamb    in number,
                                ln_cuoimp     out number,
                                fech_maxcuota out date) is
  
    lc_estado character(1);
    ld_fecha  date;
  
  begin
  
    BEGIN
      select max(ppfpag)
        into ld_fecha
        from fsd602 f
       where f.pgcod = ln_pgcod10
         and f.ppmod = ln_mod10
         and f.ppsuc = ln_suc10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.d602co = 'S';
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
            from fsd601 d
           where d.pgcod = ln_pgcod10
             and d.ppmod = ln_mod10
             and d.ppsuc = ln_suc10
             and d.ppmda = ln_mda10
             and d.pppap = ln_pap10
             and d.ppcta = ln_cta10
             and d.ppoper = ln_oper10
             and d.d601co = 'S';
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
         and (ppcap + ppint) = ln_cuoimp
         and d.d601co = 'S'
         and rownum = 1;
    exception
      when others then
        NULL;
    end;
  
    if ln_mda10 = 101 then
      ln_cuoimp := nvl(ln_cuoimp, 0) * ln_TipCamb;
    end if;
  
  end sp_cuota_impaga_Lin;

  -----------------------------------------------------------
  procedure sp_capacidadpago_Lin(ln_MAX_CUOTA    in number,
                                 ln_NRO_CUOTAS   in number,
                                 ln_peri10       in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_capacidad    out number) is
    ln_mensual number(10, 2);
    ln_cuota   number(10, 2);
  
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
  ----------------------------------------------------------------------------
  procedure sp_Cr_resultadnetoyRCC(ln_pepais        in number,
                                   ln_petdoc        in number,
                                   lc_pendoc        in varchar2,
                                   ln_TipCamb       in number,
                                   ln_segmento      in number,
                                   ln_Instancia     in number,
                                   ln_resultadoneto out number,
                                   ln_resultadorcc  out number) is
  
    RsNtoSoles     number(17, 2) := 0.00;
    RsNtoDolar     number(17, 2) := 0.00;
    RCCSoles       number(17, 2) := 0.00;
    RCCDolar       number(17, 2) := 0.00;
    RCCSoles2      number(17, 2) := 0.00;
    RCCDolar2      number(17, 2) := 0.00;
    ln_contar021   number := 0;
    ln_contar515   number := 0;
    ln_CodEva021   number := 0;
    ld_fecha021    date;
    ld_fechaactual date;
    ln_Inst515     number;
    ld_Fch515      date;
    ln_CodEva516   number;
    ln_Exist862    number := 0;
  
  begin
  
    begin
      select pgfape into ld_fechaactual from fst017 where fst017.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    if ln_segmento = 2 then
      begin
        select COUNT(*)
          into ln_Exist862
          from jaqz862 w
         where w.jaqz862aux3 = 'R'
           and w.jaqz862inst = ln_instancia; -- instancia
      exception
        when others then
          null;
        
      end;
    
      if ln_Exist862 = 0 then
        begin
          select sum(w.jaqz862gfin)
            into RCCSoles
            from jaqz862 w
           where w.jaqz862inst = ln_instancia
             and w.jaqz862fech = (select g.jaqz862fech
                                    from jaqz862 g
                                   where g.jaqz862inst = ln_instancia
                                     and rownum = 1)
             and w.jaqz862hora =
                 (select max(w.jaqz862hora)
                    from jaqz862 w
                   where w.jaqz862inst = ln_instancia
                     and w.jaqz862fech = (select g.jaqz862fech
                                            from jaqz862 g
                                           where g.jaqz862inst = ln_instancia
                                             and rownum = 1));
        exception
          when others then
            null;
            RCCSoles := 0;
        end;
      else
        begin
          select sum(w.jaqz862gfin)
            into RCCSoles
            from jaqz862 w
           where w.jaqz862aux3 = 'R'
             and w.jaqz862inst = ln_instancia; -- instancia
        exception
          when others then
            null;
            RCCSoles := 0;
        end;
      end if;
    
    end if;
  
    begin
      select count(*)
        into ln_contar021
        from sng021 a
       inner join xwf070 x
          on a.sng021sol = x.xwfprcin
       where x.xwfcont = 'S'
         and a.sng021pdoc = ln_pepais
         and a.sng021tdoc = ln_petdoc
         and a.sng021ndoc = rpad(lc_pendoc, 12, ' ')
         and a.sng021fec =
             (select max(a.sng021fec)
                from sng021 a
               inner join xwf070 x
                  on a.sng021sol = x.xwfprcin
               where x.xwfcont = 'S'
                 and a.sng021pdoc = ln_pepais
                 and a.sng021tdoc = ln_petdoc
                 and a.sng021ndoc = rpad(lc_pendoc, 12, ' '));
    exception
      when others then
        null;
    end;
  
    if ln_contar021 > 0 then
    
      begin
        select a.sng021eval, a.sng021fec
          into ln_CodEva021, ld_fecha021
          from sng021 a
         inner join xwf070 x
            on a.sng021sol = x.xwfprcin
         where x.xwfcont = 'S'
           and a.sng021pdoc = ln_pepais
           and a.sng021tdoc = ln_petdoc
           and a.sng021ndoc = rpad(lc_pendoc, 12, ' ')
           and a.sng021fec =
               (select max(a.sng021fec)
                  from sng021 a
                 inner join xwf070 x
                    on a.sng021sol = x.xwfprcin
                 where x.xwfcont = 'S'
                   and a.sng021pdoc = ln_pepais
                   and a.sng021tdoc = ln_petdoc
                   and a.sng021ndoc = rpad(lc_pendoc, 12, ' '))
           AND rownum = 1;
      exception
        when others then
          null;
      end;
    end if;
  
    begin
      select count(*)
        into ln_contar515
        from jaqz515
       inner join xwf070 x
          on jaqz515.jaqz515ins = x.xwfprcin
       where x.xwfcont = 'S'
         and jaqz515.jaqz515pai = ln_pepais
         and jaqz515.jaqz515tdo = ln_petdoc
         and jaqz515.jaqz515ndo = rpad(lc_pendoc, 12, ' ')
         and jaqz515.jaqz515fee =
             (select max(jaqz515.jaqz515fee)
                from jaqz515
               inner join xwf070 x
                  on jaqz515.jaqz515ins = x.xwfprcin
               where x.xwfcont = 'S'
                 and jaqz515.jaqz515pai = ln_pepais
                 and jaqz515.jaqz515tdo = ln_petdoc
                 and jaqz515.jaqz515ndo = rpad(lc_pendoc, 12, ' '))
         AND rownum = 1;
    exception
      when others then
        null;
    end;
  
    if ln_contar515 > 0 then
    
      begin
        select jaqz515.jaqz515ins, jaqz515.jaqz515fee
          into ln_Inst515, ld_Fch515
          from jaqz515
         inner join xwf070 x
            on jaqz515.jaqz515ins = x.xwfprcin
         where x.xwfcont = 'S'
           and jaqz515.jaqz515pai = ln_pepais
           and jaqz515.jaqz515tdo = ln_petdoc
           and jaqz515.jaqz515ndo = rpad(lc_pendoc, 12, ' ')
           and jaqz515.jaqz515fee =
               (select max(jaqz515.jaqz515fee)
                  from jaqz515
                 inner join xwf070 x
                    on jaqz515.jaqz515ins = x.xwfprcin
                 where x.xwfcont = 'S'
                   and jaqz515.jaqz515pai = ln_pepais
                   and jaqz515.jaqz515tdo = ln_petdoc
                   and jaqz515.jaqz515ndo = rpad(lc_pendoc, 12, ' '))
           AND rownum = 1;
      exception
        when others then
          null;
      end;
    end if;
  
    if ln_contar515 > 0 and ln_contar021 > 0 then
    
      if ld_fecha021 >= ld_Fch515 then
      
        --Resultado Neto
        if ln_segmento = 1 then
          begin
            select sng023Mto
              into RsNtoSoles
              from sng023 a
             where a.sng021eval = ln_CodEva021
               and a.sng026cod = 40;
          exception
            when others then
              RsNtoSoles := 0;
          end;
        
          begin
            select sng023Mto
              into RsNtoDolar
              from sng023 a
             where a.sng021eval = ln_CodEva021
               and a.sng026cod = 540;
          exception
            when others then
              RsNtoDolar := 0;
          end;
        
          ----RCC
          begin
            select sng023Mto
              into RCCSoles
              from sng023 a
             where a.sng021eval = ln_CodEva021
               and a.sng026cod = 19;
          exception
            when others then
              RCCSoles := 0;
          end;
          begin
            select sng023Mto
              into RCCDolar
              from sng023 a
             where a.sng021eval = ln_CodEva021
               and a.sng026cod = 519;
          exception
            when others then
              RCCDolar := 0;
          end;
        
          begin
            select sng023Mto
              into RCCSoles2
              from sng023 a
             where a.sng021eval = ln_CodEva021
               and a.sng026cod = 79;
          exception
            when others then
              RCCSoles2 := 0;
          end;
          begin
            select sng023Mto
              into RCCDolar2
              from sng023 a
             where a.sng021eval = ln_CodEva021
               and a.sng026cod = 579;
          exception
            when others then
              RCCDolar2 := 0;
          end;
        
        else
          if ln_segmento = 2 then
          
            begin
              select sng023Mto
                into RsNtoSoles
                from sng023 a
               where a.sng021eval = ln_CodEva021
                 and a.sng026cod = 27;
            exception
              when others then
                RsNtoSoles := 0;
            end;
          
            begin
              select sng023Mto
                into RsNtoDolar
                from sng023 a
               where a.sng021eval = ln_CodEva021
                 and a.sng026cod = 527;
            exception
              when others then
                RsNtoDolar := 0;
            end;
          
          end if;
        end if;
      
        RsNtoSoles := nvl(RsNtoSoles, 0);
        RsNtoDolar := nvl(RsNtoDolar, 0);
        RCCSoles   := nvl(RCCSoles, 0);
        RCCSoles2  := nvl(RCCSoles2, 0);
        RCCDolar   := nvl(RCCDolar, 0);
        RCCDolar2  := nvl(RCCDolar2, 0);
      
        ln_resultadoneto := (RsNtoSoles + (RsNtoDolar * ln_TipCamb));
      
        ln_resultadoneto := nvl(ln_resultadoneto, 0);
      
        ln_resultadorcc := ((RCCSoles + RCCSoles2) +
                           ((RCCDolar + RCCDolar2) * ln_TipCamb));
      
        ln_resultadorcc := nvl(ln_resultadorcc, 0);
      
      else
      
        if ld_Fch515 <= ld_fechaactual then
        
          begin
            select jaqz516.jaqz516eval
              INTO ln_CodEva516
              from jaqz516
             WHERE jaqz516.jaqz516sol = ln_Inst515;
          exception
            when others then
              ln_CodEva516 := 0;
          end;
        
          ---Resultado Neto
          if ln_segmento = 1 then
            begin
              select jaqz517.jaqz517mto
                into RsNtoSoles
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 40;
            exception
              when others then
                RsNtoSoles := 0;
            end;
          
            begin
              select jaqz517.jaqz517mto
                into RsNtoDolar
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 540;
            exception
              when others then
                RsNtoDolar := 0;
            end;
          
            ---RCC
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into RCCSoles
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 19;
            exception
              when others then
                RCCSoles := 0;
            end;
          
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into RCCDolar
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 519;
            exception
              when others then
                RCCDolar := 0;
            end;
          
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into RCCSoles2
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 79;
            exception
              when others then
                RCCSoles2 := 0;
            end;
          
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into RCCDolar2
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 579;
            exception
              when others then
                RCCDolar2 := 0;
            end;
          
          else
            if ln_segmento = 2 then
            
              begin
                select jaqz517.jaqz517mto
                  into RsNtoSoles
                  from jaqz517
                 where jaqz517.jaqz517eval = ln_CodEva516
                   and jaqz517.jaqz517cod = 27;
              exception
                when others then
                  null;
                  RsNtoSoles := 0;
              end;
              begin
                select jaqz517.jaqz517mto
                  into RsNtoDolar
                  from jaqz517
                 where jaqz517.jaqz517eval = ln_CodEva516
                   and jaqz517.jaqz517cod = 527;
              exception
                when others then
                  null;
                  RsNtoDolar := 0;
              end;
            
            end if;
          end if;
        
          RsNtoSoles := nvl(RsNtoSoles, 0);
          RsNtoDolar := nvl(RsNtoDolar, 0);
          RCCSoles   := nvl(RCCSoles, 0);
          RCCSoles2  := nvl(RCCSoles2, 0);
          RCCDolar   := nvl(RCCDolar, 0);
          RCCDolar2  := nvl(RCCDolar2, 0);
        
          ln_resultadoneto := (RsNtoSoles + (RsNtoDolar * ln_TipCamb));
        
          ln_resultadoneto := nvl(ln_resultadoneto, 0);
        
          ln_resultadorcc := ((RCCSoles + RCCSoles2) +
                             ((RCCDolar + RCCDolar2) * ln_TipCamb));
        
          ln_resultadorcc := nvl(ln_resultadorcc, 0);
        end if;
      end if;
    
    else
      if ln_contar021 > 0 then
        if ld_fecha021 <= ld_fechaactual then
          ----Resultado Neto
        
          if ln_segmento = 1 then
            Begin
              select sng023Mto
                into RsNtoSoles
                from sng023 a
               where a.sng021eval = ln_CodEva021
                 and a.sng026cod = 40;
            exception
              when others then
                RsNtoSoles := 0;
            end;
          
            begin
              select sng023Mto
                into RsNtoDolar
                from sng023 a
               where a.sng021eval = ln_CodEva021
                 and a.sng026cod = 540;
            exception
              when others then
                RsNtoDolar := 0;
            end;
            ----rcc
            begin
              select sng023Mto
                into RCCSoles
                from sng023 a
               where a.sng021eval = ln_CodEva021
                 and a.sng026cod = 19;
            exception
              when others then
                RCCSoles := 0;
            end;
          
            begin
              select sng023Mto
                into RCCDolar
                from sng023 a
               where a.sng021eval = ln_CodEva021
                 and a.sng026cod = 519;
            exception
              when others then
                RCCDolar := 0;
            end;
            ---rcc2
            begin
              select sng023Mto
                into RCCSoles2
                from sng023 a
               where a.sng021eval = ln_CodEva021
                 and a.sng026cod = 79;
            exception
              when others then
                -- null;
                RCCSoles2 := 0;
            end;
            begin
              select sng023Mto
                into RCCDolar2
                from sng023 a
               where a.sng021eval = ln_CodEva021
                 and a.sng026cod = 579;
            exception
              when others then
                --null;
                RCCDolar2 := 0;
            end;
          
          else
            if ln_segmento = 2 then
              Begin
                select sng023Mto
                  into RsNtoSoles
                  from sng023 a
                 where a.sng021eval = ln_CodEva021
                   and a.sng026cod = 27;
              exception
                when others then
                  null;
                  RsNtoSoles := 0;
              end;
            
              begin
                select sng023Mto
                  into RsNtoDolar
                  from sng023 a
                 where a.sng021eval = ln_CodEva021
                   and a.sng026cod = 527;
              exception
                when others then
                  null;
                  RsNtoDolar := 0;
              end;
            
            end if;
          end if;
        
          RsNtoSoles := nvl(RsNtoSoles, 0);
          RsNtoDolar := nvl(RsNtoDolar, 0);
          RCCSoles   := nvl(RCCSoles, 0);
          RCCSoles2  := nvl(RCCSoles2, 0);
          RCCDolar   := nvl(RCCDolar, 0);
          RCCDolar2  := nvl(RCCDolar2, 0);
        
          ln_resultadoneto := (RsNtoSoles + (RsNtoDolar * ln_TipCamb));
          ln_resultadoneto := nvl(ln_resultadoneto, 0);
        
          ln_resultadorcc := ((RCCSoles + RCCSoles2) +
                             ((RCCDolar + RCCDolar2) * ln_TipCamb));
        
          ln_resultadorcc := nvl(ln_resultadorcc, 0);
        
        end if;
      else
        if ld_Fch515 <= ld_fechaactual then
        
          begin
            select jaqz516.jaqz516eval
              INTO ln_CodEva516
              from jaqz516
             WHERE jaqz516.jaqz516sol = ln_Inst515;
          exception
            when others then
              ln_CodEva516 := 0;
          end;
        
          if ln_segmento = 1 then
          
            ---Resultado Neto
            begin
              select jaqz517.jaqz517mto
                into RsNtoSoles
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 40;
            exception
              when others then
                RsNtoSoles := 0;
            end;
            begin
              select jaqz517.jaqz517mto
                into RsNtoDolar
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 540;
            exception
              when others then
                RsNtoDolar := 0;
            end;
          
            ---RCC
            begin
              select jaqz517.jaqz517mto
                into RCCSoles
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 19;
            exception
              when others then
                RCCSoles := 0;
            end;
          
            begin
              select jaqz517.jaqz517mto
                into RCCDolar
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 519;
            exception
              when others then
                RCCDolar := 0;
            end;
          
            begin
              select jaqz517.jaqz517mto
                into RCCSoles2
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 79;
            exception
              when others then
                RCCSoles2 := 0;
            end;
          
            begin
              select jaqz517.jaqz517mto
                into RCCDolar2
                from jaqz517
               where jaqz517.jaqz517eval = ln_CodEva516
                 and jaqz517.jaqz517cod = 579;
            exception
              when others then
                RCCDolar2 := 0;
            end;
          else
            if ln_segmento = 2 then
            
              begin
                select jaqz517.jaqz517mto
                  into RsNtoSoles
                  from jaqz517
                 where jaqz517.jaqz517eval = ln_CodEva516
                   and jaqz517.jaqz517cod = 27;
              exception
                when others then
                  null;
                  RsNtoSoles := 0;
              end;
              begin
                select jaqz517.jaqz517mto
                  into RsNtoDolar
                  from jaqz517
                 where jaqz517.jaqz517eval = ln_CodEva516
                   and jaqz517.jaqz517cod = 527;
              exception
                when others then
                  null;
                  RsNtoDolar := 0;
              end;
            
            end if;
          end if;
        
          RsNtoSoles := nvl(RsNtoSoles, 0);
          RsNtoDolar := nvl(RsNtoDolar, 0);
          RCCSoles   := nvl(RCCSoles, 0);
          RCCSoles2  := nvl(RCCSoles2, 0);
          RCCDolar   := nvl(RCCDolar, 0);
          RCCDolar2  := nvl(RCCDolar2, 0);
        
          ln_resultadoneto := (RsNtoSoles + (RsNtoDolar * ln_TipCamb));
          ln_resultadoneto := nvl(ln_resultadoneto, 0);
        
          ln_resultadorcc := ((RCCSoles + RCCSoles2) +
                             ((RCCDolar + RCCDolar2) * ln_TipCamb));
          ln_resultadorcc := nvl(ln_resultadorcc, 0);
        
        end if;
      
      end if;
    
    end if;
  
  end sp_Cr_resultadnetoyRCC;

  ---------------------------------------------------------------------------

  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                LN_ITPGCOD      in number,
                                LN_ITSUC        in number,
                                LN_ITMOD        in number,
                                LN_ITTRAN       in number,
                                LN_ITNREL       in number,
                                LN_ITORD        in number,
                                LN_ITSBOR       in number,
                                lc_Usuario      in varchar2,
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
         and d10.Aocta in (select Ctnro
                             from sng001 s, fsr008 f
                            where s.sng001inst = ln_Instancia
                              and s.sng001pais = f.pepais
                              and s.sng001tdoc = f.Petdoc
                              and s.sng001ndoc = f.pendoc
                              and cttfir = 'T')
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
         and x.xwfcuenta in (select Ctnro
                               from sng001 s, fsr008 f
                              where s.sng001inst = ln_Instancia
                                and s.sng001pais = f.pepais
                                and s.sng001tdoc = f.Petdoc
                                and s.sng001ndoc = f.pendoc
                                and cttfir = 'T')
            
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
    ln_moneda      number;
    pd_fecpro      date;
  
  begin
    ln_MntCuoCntgCF := 0;
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
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    begin
      select pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    end;
  
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
          pq_cr_caplineas_movil.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                 lnPetdoc     => ln_tdoc,
                                                 lnPendoc     => lc_ndoc,
                                                 ln_TipCamb   => ln_tipocambio,
                                                 ln_instancia => ln_Instancia,
                                                 pd_fecpro    => pd_fecpro,
                                                 ln_PGCOD     => L.LN_PGCOD10,
                                                 ln_MOD       => l.ln_mod10,
                                                 ln_SUC       => l.ln_suc10,
                                                 ln_MDA       => l.ln_mda10,
                                                 ln_PAP       => l.ln_pap10,
                                                 ln_CTA       => l.ln_cta10,
                                                 ln_OPE       => l.ln_oper10,
                                                 ln_SBOP      => l.ln_sbop10,
                                                 ln_TOPE      => l.ln_tope10,
                                                 ln_peri10    => 999,
                                                 ln_nrocuotas => 0,
                                                 ln_parciales => 0,
                                                 ln_flagFC    => 'N',
                                                 ln_cuotimp   => ln_SaldCap,
                                                 ln_seguro    => 0,
                                                 ln_CapFC     => 0,
                                                 CapLinea     => 0,
                                                 ln_CAPCUO    => ln_CuotCntgAux,
                                                 lc_IndCred   => 'CredVgntCF',
                                                 LN_ITPGCOD   => LN_ITPGCOD,
                                                 LN_ITSUC     => LN_ITSUC,
                                                 LN_ITMOD     => LN_ITMOD,
                                                 LN_ITTRAN    => LN_ITTRAN,
                                                 LN_ITNREL    => LN_ITNREL,
                                                 LN_ITORD     => LN_ITORD,
                                                 LN_ITSBOR    => LN_ITSBOR,
                                                 lv_usuario   => lc_Usuario);
        end;
      
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
          pq_cr_caplineas_movil.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                 lnPetdoc     => ln_tdoc,
                                                 lnPendoc     => lc_ndoc,
                                                 ln_TipCamb   => ln_tipocambio,
                                                 ln_instancia => ln_Instancia,
                                                 pd_fecpro    => pd_fecpro,
                                                 ln_PGCOD     => v.ln_pgcod10,
                                                 ln_MOD       => v.ln_mod10,
                                                 ln_SUC       => v.ln_suc10,
                                                 ln_MDA       => v.ln_mda10,
                                                 ln_PAP       => v.ln_pap10,
                                                 ln_CTA       => v.ln_cta10,
                                                 ln_OPE       => v.ln_oper10,
                                                 ln_SBOP      => v.ln_sbop10,
                                                 ln_TOPE      => v.ln_tope10,
                                                 ln_peri10    => 999,
                                                 ln_nrocuotas => 0,
                                                 ln_parciales => 0,
                                                 ln_flagFC    => 'N',
                                                 ln_cuotimp   => ln_SaldCap,
                                                 ln_seguro    => 0,
                                                 ln_CapFC     => 0,
                                                 CapLinea     => 0,
                                                 ln_CAPCUO    => ln_CuotCntgAux,
                                                 lc_IndCred   => 'CredVuelCF',
                                                 LN_ITPGCOD   => LN_ITPGCOD,
                                                 LN_ITSUC     => LN_ITSUC,
                                                 LN_ITMOD     => LN_ITMOD,
                                                 LN_ITTRAN    => LN_ITTRAN,
                                                 LN_ITNREL    => LN_ITNREL,
                                                 LN_ITORD     => LN_ITORD,
                                                 LN_ITSBOR    => LN_ITSBOR,
                                                 lv_usuario   => lc_Usuario);
        end;
      
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  LN_ITPGCOD        in number,
                                  LN_ITSUC          in number,
                                  LN_ITMOD          in number,
                                  LN_ITTRAN         in number,
                                  LN_ITNREL         in number,
                                  LN_ITORD          in number,
                                  LN_ITSBOR         in number,
                                  lc_Usuario        in varchar2,
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
                      x.xwfprcins    ln_InstanciaAvalada
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
    pd_fecpro      date;
    ln_Modulo      number;
    ln_moneda      number;
    lc_verfamp     varchar2(2) := 'N';
    lc_vrfrefrep   varchar2(2) := 'N';
    lc_verfvinc    varchar2(2) := 'N';
    ln_EsConsd     number;
  
  begin
    ln_MntCuoCntgAval := 0;
  
    begin
      -- Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
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
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    begin
      select pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    end;
  
    begin
      select w.xwfmodulo
        into ln_Modulo
        from xwf700 w
       where w.xwfprcins = ln_Instancia;
    exception
      when others then
        ln_Modulo := 0;
    end;
  
    if ln_pais is not null then
    
      for l in lista_CredVigAval(ln_pais, ln_tdoc, lc_ndoc) loop
        ln_SaldCap := 0;
      
        pq_cr_resolutor_cappago.Sp_ampliados_CK(ln_emp10  => l.ln_pgcod10,
                                                ln_mod10  => l.ln_mod10,
                                                ln_suc10  => l.ln_suc10,
                                                ln_mda10  => l.ln_mda10,
                                                ln_pap10  => l.ln_pap10,
                                                ln_cta10  => l.ln_cta10,
                                                ln_oper10 => l.ln_oper10,
                                                ln_sbop10 => l.ln_sbop10,
                                                ln_tope10 => l.ln_tope10,
                                                Pc_flag   => lc_verfamp);
      
        pq_cr_resolutor_cappago.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
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
        
          ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
        
          begin
            pq_cr_caplineas_movil.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                   lnPetdoc     => ln_tdoc,
                                                   lnPendoc     => lc_ndoc,
                                                   ln_TipCamb   => ln_tipocambio,
                                                   ln_instancia => ln_Instancia,
                                                   pd_fecpro    => pd_fecpro,
                                                   ln_PGCOD     => L.LN_PGCOD10,
                                                   ln_MOD       => l.ln_mod10,
                                                   ln_SUC       => l.ln_suc10,
                                                   ln_MDA       => l.ln_mda10,
                                                   ln_PAP       => l.ln_pap10,
                                                   ln_CTA       => l.ln_cta10,
                                                   ln_OPE       => l.ln_oper10,
                                                   ln_SBOP      => l.ln_sbop10,
                                                   ln_TOPE      => l.ln_tope10,
                                                   ln_peri10    => 999,
                                                   ln_nrocuotas => 0,
                                                   ln_parciales => 0,
                                                   ln_flagFC    => 'N',
                                                   ln_cuotimp   => ln_SaldCap,
                                                   ln_seguro    => 0,
                                                   ln_CapFC     => 0,
                                                   CapLinea     => 0,
                                                   ln_CAPCUO    => ln_CuotCntgAux,
                                                   lc_IndCred   => 'CredVgnAvl',
                                                   LN_ITPGCOD   => LN_ITPGCOD,
                                                   LN_ITSUC     => LN_ITSUC,
                                                   LN_ITMOD     => LN_ITMOD,
                                                   LN_ITTRAN    => LN_ITTRAN,
                                                   LN_ITNREL    => LN_ITNREL,
                                                   LN_ITORD     => LN_ITORD,
                                                   LN_ITSBOR    => LN_ITSBOR,
                                                   lv_usuario   => lc_Usuario);
          
          end;
        
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
        
        end if;
      end loop;
    
      for v in lista_CredvueloAval(ln_pais, ln_tdoc, lc_ndoc) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_SaldCap < 0 then
          ln_SaldCap := ln_SaldCap * -1;
        end if;
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
        
          pq_cr_caplineas_movil.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                 lnPetdoc     => ln_tdoc,
                                                 lnPendoc     => lc_ndoc,
                                                 ln_TipCamb   => ln_tipocambio,
                                                 ln_instancia => ln_Instancia,
                                                 pd_fecpro    => pd_fecpro,
                                                 ln_PGCOD     => v.LN_PGCOD10,
                                                 ln_MOD       => v.ln_mod10,
                                                 ln_SUC       => v.ln_suc10,
                                                 ln_MDA       => v.ln_mda10,
                                                 ln_PAP       => v.ln_pap10,
                                                 ln_CTA       => v.ln_cta10,
                                                 ln_OPE       => v.ln_oper10,
                                                 ln_SBOP      => v.ln_sbop10,
                                                 ln_TOPE      => v.ln_tope10,
                                                 ln_peri10    => 999,
                                                 ln_nrocuotas => 0,
                                                 ln_parciales => 0,
                                                 ln_flagFC    => 'N',
                                                 ln_cuotimp   => ln_SaldCap,
                                                 ln_seguro    => 0,
                                                 ln_CapFC     => 0,
                                                 CapLinea     => 0,
                                                 ln_CAPCUO    => ln_CuotCntgAux,
                                                 lc_IndCred   => 'CredVlAval',
                                                 LN_ITPGCOD   => LN_ITPGCOD,
                                                 LN_ITSUC     => LN_ITSUC,
                                                 LN_ITMOD     => LN_ITMOD,
                                                 LN_ITTRAN    => LN_ITTRAN,
                                                 LN_ITNREL    => LN_ITNREL,
                                                 LN_ITORD     => LN_ITORD,
                                                 LN_ITSBOR    => LN_ITSBOR,
                                                 lv_usuario   => lc_Usuario);
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
    if ln_paiscy is not null and ln_Modulo <> 107 then
    
      for l in lista_CredVigAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        begin
          select count(*)
            into ln_EsConsd
            from AQPA271A j
           where j.AQPA271Afec = pd_fecpro
             and j.AQPA271Ainst = ln_instancia
             and j.aqpa271aipgcod = LN_ITPGCOD
             and j.aqpa271aitsuc = LN_ITSUC
             and j.aqpa271aitmod = LN_ITMOD
             and j.aqpa271aittran = LN_ITTRAN
             and j.aqpa271aitnrel = LN_ITNREL
             and j.aqpa271aitord = LN_ITORD
             and j.aqpa271aitsbor = LN_ITSBOR
             and j.aqpa271apgcod = l.ln_pgcod10
             and j.aqpa271amod = l.ln_mod10
             and j.aqpa271asuc = l.ln_suc10
             and j.aqpa271amda = l.ln_mda10
             and j.aqpa271apap = l.ln_pap10
             and j.aqpa271acta = l.ln_cta10
             and j.aqpa271aope = l.ln_oper10
             and j.aqpa271asbop = l.ln_sbop10
             and j.aqpa271atope = l.ln_tope10;
        end;
      
        if ln_EsConsd = 0 then
        
          pq_cr_resolutor_cappago.Sp_ampliados_CK(ln_emp10  => l.ln_pgcod10,
                                                  ln_mod10  => l.ln_mod10,
                                                  ln_suc10  => l.ln_suc10,
                                                  ln_mda10  => l.ln_mda10,
                                                  ln_pap10  => l.ln_pap10,
                                                  ln_cta10  => l.ln_cta10,
                                                  ln_oper10 => l.ln_oper10,
                                                  ln_sbop10 => l.ln_sbop10,
                                                  ln_tope10 => l.ln_tope10,
                                                  Pc_flag   => lc_verfamp);
        
          pq_cr_resolutor_cappago.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
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
              end if;
            
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
                end if;
              
                if l.ln_mda10 = 101 then
                  ln_SaldCap := ln_SaldCap * ln_tipocambio;
                end if;
              end if;
            end if;
          
            ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
          
            begin
            
              pq_cr_caplineas_movil.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                     lnPetdoc     => ln_tdoc,
                                                     lnPendoc     => lc_ndoc,
                                                     ln_TipCamb   => ln_tipocambio,
                                                     ln_instancia => ln_Instancia,
                                                     pd_fecpro    => pd_fecpro,
                                                     ln_PGCOD     => L.LN_PGCOD10,
                                                     ln_MOD       => l.ln_mod10,
                                                     ln_SUC       => l.ln_suc10,
                                                     ln_MDA       => l.ln_mda10,
                                                     ln_PAP       => l.ln_pap10,
                                                     ln_CTA       => l.ln_cta10,
                                                     ln_OPE       => l.ln_oper10,
                                                     ln_SBOP      => l.ln_sbop10,
                                                     ln_TOPE      => l.ln_tope10,
                                                     ln_peri10    => 999,
                                                     ln_nrocuotas => 0,
                                                     ln_parciales => 0,
                                                     ln_flagFC    => 'N',
                                                     ln_cuotimp   => ln_SaldCap,
                                                     ln_seguro    => 0,
                                                     ln_CapFC     => 0,
                                                     CapLinea     => 0,
                                                     ln_CAPCUO    => ln_CuotCntgAux,
                                                     lc_IndCred   => 'CredVgnAvl',
                                                     LN_ITPGCOD   => LN_ITPGCOD,
                                                     LN_ITSUC     => LN_ITSUC,
                                                     LN_ITMOD     => LN_ITMOD,
                                                     LN_ITTRAN    => LN_ITTRAN,
                                                     LN_ITNREL    => LN_ITNREL,
                                                     LN_ITORD     => LN_ITORD,
                                                     LN_ITSBOR    => LN_ITSBOR,
                                                     lv_usuario   => lc_Usuario);
            end;
          
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
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_SaldCap < 0 then
          ln_SaldCap := ln_SaldCap * -1;
        end if;
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
          pq_cr_caplineas_movil.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                 lnPetdoc     => ln_tdoc,
                                                 lnPendoc     => lc_ndoc,
                                                 ln_TipCamb   => ln_tipocambio,
                                                 ln_instancia => ln_Instancia,
                                                 pd_fecpro    => pd_fecpro,
                                                 ln_PGCOD     => v.LN_PGCOD10,
                                                 ln_MOD       => v.ln_mod10,
                                                 ln_SUC       => v.ln_suc10,
                                                 ln_MDA       => v.ln_mda10,
                                                 ln_PAP       => v.ln_pap10,
                                                 ln_CTA       => v.ln_cta10,
                                                 ln_OPE       => v.ln_oper10,
                                                 ln_SBOP      => v.ln_sbop10,
                                                 ln_TOPE      => v.ln_tope10,
                                                 ln_peri10    => 999,
                                                 ln_nrocuotas => 0,
                                                 ln_parciales => 0,
                                                 ln_flagFC    => 'N',
                                                 ln_cuotimp   => ln_SaldCap,
                                                 ln_seguro    => 0,
                                                 ln_CapFC     => 0,
                                                 CapLinea     => 0,
                                                 ln_CAPCUO    => ln_CuotCntgAux,
                                                 lc_IndCred   => 'CredVlAval',
                                                 LN_ITPGCOD   => LN_ITPGCOD,
                                                 LN_ITSUC     => LN_ITSUC,
                                                 LN_ITMOD     => LN_ITMOD,
                                                 LN_ITTRAN    => LN_ITTRAN,
                                                 LN_ITNREL    => LN_ITNREL,
                                                 LN_ITORD     => LN_ITORD,
                                                 LN_ITSBOR    => LN_ITSBOR,
                                                 lv_usuario   => lc_Usuario);
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    end if;
  
  end sp_cr_CuotaContinAval;
  --------------------------------------------------------------------------------
  procedure sp_cR_CuotaPotencial(ln_Instancia   in number,
                                 ln_MntPotncial out number) is
  
    ln_TipoSol number;
  
  begin
  
    ln_MntPotncial := 0;
  
    begin
      select s.sng021tmod
        into ln_TipoSol
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_TipoSol = 13 then
      begin
        select j.jaqy140cpoten
          into ln_MntPotncial
          from jaqy140 j
         where j.jaqy140inst = ln_Instancia
           and j.jaqy140est = 'H'
           and j.jaqy140tarea = 55;
      exception
        when others then
          ln_MntPotncial := 0;
      end;
    
    else
      if ln_TipoSol = 14 then
      
        begin
          select j.jaqz821cpoten
            into ln_MntPotncial
            from jaqz821 j
           where j.jaqz821inst = ln_Instancia
             and j.jaqz821est = 'H'
             and j.jaqz821tarea = 55;
        exception
          when others then
            ln_MntPotncial := 0;
        end;
      end if;
    end if;
  
  end sp_cR_CuotaPotencial;
  ---------------------------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais        in number,
                           ln_Petdoc        in number,
                           lc_pendoc        in char,
                           ln_TipCamb       in number,
                           ln_instancia     in number,
                           pd_fecpro        in date,
                           ln_captotcaja    in number,
                           ln_resultadorcc  in number,
                           ln_resultadoneto in number,
                           ln_captotal      in number,
                           lc_indicador     in varchar2,
                           LN_ITPGCOD       in number,
                           LN_ITSUC         in number,
                           LN_ITMOD         in number,
                           LN_ITTRAN        in number,
                           LN_ITNREL        in number,
                           LN_ITORD         in number,
                           LN_ITSBOR        in number,
                           lc_garant        in varchar2,
                           ln_segmen        in number,
                           lv_usuario       in varchar2,
                           pn_mod116        in number,
                           pn_suc116        in number,
                           pn_mda116        in number,
                           pn_pap116        in number,
                           pn_cta116        in number,
                           pn_ope116        in number,
                           pn_sbo116        in number,
                           pn_top116        in number,
                           ln_ccontg        in number,
                           ln_cpoten        in number) is
  
    lc_IndEst varchar2(2);
    lc_hora   character(8);
    ln_corr   number := 0;
    lc_code   varchar2(40);
    lc_desc   varchar2(40);
  
  begin
  
    lc_IndEst := 'I';
  
    begin
    
      select max(j.AQPA270Acorr)
        into ln_corr
        from AQPA270A j
       where j.AQPA270Afec = pd_fecpro
         and j.AQPA270Ainst = ln_instancia
         and j.aqpa270apgcod = LN_ITPGCOD
         and j.aqpa270aitsuc = LN_ITSUC
         and j.aqpa270aitmod = LN_ITMOD
         and j.aqpa270aittran = LN_ITTRAN
         and j.aqpa270aitnrel = LN_ITNREL
         and j.aqpa270aitord = LN_ITORD
         and j.aqpa270aitsbor = LN_ITSBOR;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into AQPA270A a
        (AQPA270Acorr,
         AQPA270Apais,
         AQPA270Atdoc,
         AQPA270Andoc,
         AQPA270Atcamb,
         AQPA270Ainst,
         AQPA270Afec,
         AQPA270Ahora,
         AQPA270Acapcaja,
         AQPA270Asldext,
         AQPA270Aresnet,
         AQPA270Aratio,
         AQPA270Aind,
         AQPA270AEST,
         AQPA270Auser,
         AQPA270APGCOD,
         AQPA270AITSUC,
         AQPA270AITMOD,
         AQPA270AITTRAN,
         AQPA270AITNREL,
         AQPA270AITORD,
         AQPA270AITSBOR,
         AQPA270AGARANT,
         AQPA270ASEGMEN,
         AQPA270Amod,
         AQPA270Asuc,
         AQPA270Amda,
         AQPA270Apap,
         AQPA270Acta,
         aqpa270Aope,
         AQPA270Asbop,
         AQPA270Atop,
         aqpa270accontg,
         aqpa270acpoten)
      
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         lc_pendoc,
         ln_TipCamb,
         ln_instancia,
         pd_fecpro,
         lc_hora,
         ln_captotcaja,
         ln_resultadorcc,
         ln_resultadoneto,
         ln_captotal,
         lc_indicador,
         lc_IndEst,
         lv_usuario,
         LN_ITPGCOD,
         LN_ITSUC,
         LN_ITMOD,
         LN_ITTRAN,
         LN_ITNREL,
         LN_ITORD,
         LN_ITSBOR,
         lc_garant,
         ln_segmen,
         pn_mod116,
         pn_suc116,
         pn_mda116,
         pn_pap116,
         pn_cta116,
         pn_ope116,
         pn_sbo116,
         pn_top116,
         ln_ccontg,
         ln_cpoten);
      commit;
    exception
      when others then
        lc_code := substr(sqlcode, 1, 39);
        lc_desc := substr(sqlerrm, 1, 39);
        begin
          insert into jaqz840
            (jaqz840prgm,
             jaqz840nmbvar,
             jaqz840fecproc,
             jaqz840hora,
             jaqz840user,
             jaqz840varin1,
             jaqz840varin2,
             jaqz840varin3,
             jaqz840varin4,
             jaqz840varin5,
             jaqz840varin6,
             jaqz840varin7,
             jaqz840varin8,
             jaqz840varin9,
             jaqz840varin10,
             jaqz840varin11,
             jaqz840varnaux1,
             jaqz840varnaux2)
          values
            ('ATM/MOVIL',
             'DISPOLINEA',
             pd_fecpro,
             lc_hora,
             lv_usuario,
             ln_instancia,
             ln_Pepais,
             ln_Petdoc,
             lc_pendoc,
             LN_ITPGCOD,
             LN_ITSUC,
             LN_ITMOD,
             LN_ITTRAN,
             LN_ITNREL,
             LN_ITORD,
             LN_ITSBOR,
             lc_code,
             lc_desc);
          commit;
        
        end;
    end;
  
  end sp_cr_LogRatio;

  -------------------------------------------------------------------
  procedure sp_cr_LogCuentas(lnPepais     in number,
                             lnPetdoc     in number,
                             lnPendoc     in char,
                             ln_TipCamb   in number,
                             ln_instancia in number,
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
                             ln_peri10    in number,
                             ln_nrocuotas in number,
                             ln_parciales in number,
                             ln_flagFC    in varchar2,
                             ln_cuotimp   in number,
                             ln_seguro    in number,
                             ln_CapFC     in number,
                             CapLinea     in number,
                             ln_CAPCUO    in number,
                             lc_IndCred   IN VARCHAR2,
                             LN_ITPGCOD   in number,
                             LN_ITSUC     in number,
                             LN_ITMOD     in number,
                             LN_ITTRAN    in number,
                             LN_ITNREL    in number,
                             LN_ITORD     in number,
                             LN_ITSBOR    in number,
                             lv_usuario   in varchar2) is
  
    lc_hora   character(8);
    lc_IndEst varchar2(2);
    ln_corr   number := 0;
    lc_code   varchar2(40);
    lc_desc   varchar2(40);
  
  begin
  
    begin
      select max(j.AQPA271Acorr)
        into ln_corr
        from AQPA271A j
       where j.AQPA271Afec = pd_fecpro
         and j.AQPA271Ainst = ln_instancia
         and j.aqpa271aipgcod = LN_ITPGCOD
         and j.aqpa271aitsuc = LN_ITSUC
         and j.aqpa271aitmod = LN_ITMOD
         and j.aqpa271aittran = LN_ITTRAN
         and j.aqpa271aitnrel = LN_ITNREL
         and j.aqpa271aitord = LN_ITORD
         and j.aqpa271aitsbor = LN_ITSBOR;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    lc_IndEst := 'I';
  
    begin
      insert into AQPA271A
        (AQPA271Acorr,
         AQPA271Afec,
         AQPA271Ahora,
         AQPA271Apais,
         AQPA271Atdoc,
         AQPA271Andoc,
         AQPA271Atcamb,
         AQPA271Ainst,
         AQPA271Apgcod,
         AQPA271Amod,
         AQPA271Asuc,
         AQPA271Amda,
         AQPA271Apap,
         AQPA271Acta,
         AQPA271Aope,
         AQPA271Asbop,
         AQPA271Atope,
         AQPA271APERIO,
         AQPA271ANRCUO,
         AQPA271ATSOLI,
         AQPA271AFLCJ,
         AQPA271ACUOIMP,
         AQPA271ASEGURO,
         AQPA271ACAPFC,
         AQPA271ACAPLIN,
         AQPA271Acapcuo,
         AQPA271AINDIC,
         AQPA271Aest,
         AQPA271Auser,
         AQPA271AIPGCOD,
         AQPA271AITSUC,
         AQPA271AITMOD,
         AQPA271AITTRAN,
         AQPA271AITNREL,
         AQPA271AITORD,
         AQPA271AITSBOR)
      
      values
        (ln_corr + 1,
         pd_fecpro,
         lc_hora,
         lnPepais,
         lnPetdoc,
         lnPendoc,
         ln_TipCamb,
         ln_instancia,
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
         lv_usuario,
         LN_ITPGCOD,
         LN_ITSUC,
         LN_ITMOD,
         LN_ITTRAN,
         LN_ITNREL,
         LN_ITORD,
         LN_ITSBOR);
      commit;
    exception
      when others then
        lc_code := substr(sqlcode, 1, 39);
        lc_desc := substr(sqlerrm, 1, 39);
        begin
          insert into jaqz840
            (jaqz840prgm,
             jaqz840nmbvar,
             jaqz840fecproc,
             jaqz840hora,
             jaqz840user,
             jaqz840varin1,
             jaqz840varin2,
             jaqz840varin3,
             jaqz840varin4,
             jaqz840varin5,
             jaqz840varin6,
             jaqz840varin7,
             jaqz840varin8,
             jaqz840varin9,
             jaqz840varin10,
             jaqz840varin11,
             jaqz840varnaux1,
             jaqz840varnaux2)
          values
            ('ATM/MOVIL',
             'DISPOLINEA',
             pd_fecpro,
             lc_hora,
             lv_usuario,
             ln_instancia,
             lnPepais,
             lnPetdoc,
             lnPendoc,
             LN_ITPGCOD,
             LN_ITSUC,
             LN_ITMOD,
             LN_ITTRAN,
             LN_ITNREL,
             LN_ITORD,
             LN_ITSBOR,
             lc_code,
             lc_desc);
          commit;
        end;
    end;
  
  end sp_cr_LogCuentas;
  ------------------------------------------------------------------  
  procedure sp_cr_NroCuotEstim(pn_emp     in number,
                               pn_mod     in number,
                               pn_suc     in number,
                               pn_mda     in number,
                               pn_pap     in number,
                               pn_cta     in number,
                               pn_ope     in number,
                               pn_sbo     in number,
                               pn_top     in number,
                               LN_ITPGCOD in number,
                               LN_ITSUC   in number,
                               LN_ITMOD   in number,
                               LN_ITTRAN  in number,
                               LN_ITNREL  in number,
                               LN_ITORD   in number,
                               LN_ITSBOR  in number,
                               pd_fecpro  in date,
                               ln_monto   in number,
                               ln_plazo   in number,
                               ln_MinCuo  out number,
                               ln_MaxCuo  out number,
                               lc_TipMnsj out varchar) is
  
    ln_MntLinea       number(17, 2) := 0.00;
    ln_MntCaja        number(17, 2) := 0.00;
    ln_MntCajaSL      number(17, 2) := 0.00;
    ln_saldIFIS       number(17, 2) := 0.00;
    ln_resltneto      number(17, 2) := 0.00;
    ln_cuocntg        number(17, 2) := 0.00;
    ln_cpotncl        number(17, 2) := 0.00;
    ln_cont           number := 1;
    ln_tasa           number(14, 8) := 0.00;
    ln_MntLineaAux    number(17, 2) := 0.00;
    ln_MntCajaAux     number(17, 2) := 0.00;
    ln_ratioAux       number(10, 6) := 0.00;
    ln_plazoAux       number;
    ln_instancia      number;
    lc_FlagCompRat    varchar2(2) := 'N';
    ln_RatioAComparar number := 0.00;
    ln_ratio          number(10, 6) := 0.00;
    ln_montoAux       number(17, 2) := 0.00;
    ln_pgcod116       number := 0.00;
    ln_mod116         number := 0.00;
    ln_suc116         number := 0.00;
    ln_mda116         number := 0.00;
    ln_pap116         number := 0.00;
    ln_cta116         number := 0.00;
    ln_oper116        number := 0.00;
    ln_sbop116        number := 0.00;
    ln_116tope        number := 0.00;
    ln_LineaUtilzd    number(17, 2) := 0.00;
    lc_EsAdic         varchar2(2) := 'N';
  
  begin
    lc_TipMnsj  := 'O';
    ln_plazoAux := ln_plazo;
  
    begin
      pq_cr_rtes_dispmovil.sp_cr_verfnrocuotmax(ln_mod117    => pn_mod,
                                                ln_suc117    => pn_suc,
                                                ln_mda117    => pn_mda,
                                                ln_pap117    => pn_pap,
                                                ln_cta117    => pn_cta,
                                                ln_oper117   => pn_ope,
                                                ln_sbop117   => pn_sbo,
                                                ln_tope117   => pn_top,
                                                ln_PlazoSist => ln_MaxCuo);
    end;
  
    begin
      select a.aqpa270acapcaja, a.aqpa270aresnet, a.aqpa270aratio
        into ln_MntCaja, ln_resltneto, ln_ratio
        from aqpa270a a
       where a.aqpa270apgcod = LN_ITPGCOD
         and a.aqpa270aitsuc = LN_ITSUC
         and a.aqpa270aitmod = LN_ITMOD
         and a.aqpa270aittran = LN_ITTRAN
         and a.aqpa270aitnrel = LN_ITNREL
         and a.aqpa270aitord = LN_ITORD
         and a.aqpa270aitsbor = LN_ITSBOR
         and a.aqpa270afec = pd_fecpro;
    exception
      when others then
        ln_MntCaja := 0.00;
    end;
  
    if ln_MntCaja = 0 or ln_resltneto = 0 or ln_ratio = 0 then
      lc_TipMnsj := 'L'; -- No se guardo Log     
    end if;
  
    PQ_CR_CAPLINEAS_MOVIL.Sp_Adicional_CK(pn_mod  => pn_mod,
                                          pn_top  => pn_top,
                                          Pc_flag => lc_EsAdic);
  
    if ln_MaxCuo = ln_plazo and lc_TipMnsj = 'O' and lc_EsAdic = 'N' then
      lc_TipMnsj := 'M'; -- Monto
    
    else
      if ln_MaxCuo > ln_plazo and lc_TipMnsj = 'O' and lc_EsAdic = 'N' then
      
        begin
          ln_instancia := fn_instancia_credito(v_Scmod  => pn_mod,
                                               v_Scsuc  => pn_suc,
                                               v_Scmda  => pn_mda,
                                               v_Scpap  => pn_pap,
                                               v_Sccta  => pn_cta,
                                               v_Scoper => pn_ope,
                                               v_Scsbop => pn_sbo,
                                               v_Sctope => pn_top);
        end;
      
        begin
          -- Call the procedure
          pq_cr_resolutor_lineas.sp_empresa_lineatmp(ln_instancia => ln_instancia,
                                                     lv_flag90    => lc_FlagCompRat,
                                                     ln_valor     => ln_RatioAComparar);
        end;
      
        begin
          select aotasa
            into ln_tasa
            from fsd010
           where pgcod = pn_emp
             and aocta = pn_cta
             and aooper = pn_ope
             and aomod = pn_mod
             and aosuc = pn_suc
             and aomda = pn_mda
             and aopap = pn_pap
             and aosbop = pn_sbo
             and aotope = pn_top;
        exception
          when others then
            ln_tasa := 0;
        end;
      
        begin
          select sum(a.aqpa271acapcuo)
            into ln_MntLinea
            from aqpa271a a
           where a.aqpa271apgcod = pn_emp
             and a.aqpa271amod = pn_mod
             and a.aqpa271asuc = pn_suc
             and a.aqpa271amda = pn_mda
             and a.aqpa271apap = pn_pap
             and a.aqpa271acta = pn_cta
             and a.aqpa271aope = pn_ope
             and a.aqpa271asbop = pn_sbo
             and a.aqpa271atope = pn_top
             and a.aqpa271aipgcod = LN_ITPGCOD
             and a.aqpa271aitsuc = LN_ITSUC
             and a.aqpa271aitmod = LN_ITMOD
             and a.aqpa271aittran = LN_ITTRAN
             and a.aqpa271aitnrel = LN_ITNREL
             and a.aqpa271aitord = LN_ITORD
             and a.aqpa271aitsbor = LN_ITSBOR
             and a.aqpa271afec = pd_fecpro;
        exception
          when others then
            ln_MntLinea := 0.00;
        end;
      
        begin
          select a.aqpa270acapcaja,
                 a.aqpa270asldext,
                 a.aqpa270aresnet,
                 a.aqpa270accontg,
                 a.aqpa270acpoten
            into ln_MntCaja,
                 ln_saldIFIS,
                 ln_resltneto,
                 ln_cuocntg,
                 ln_cpotncl
            from aqpa270a a
           where a.aqpa270apgcod = LN_ITPGCOD
             and a.aqpa270aitsuc = LN_ITSUC
             and a.aqpa270aitmod = LN_ITMOD
             and a.aqpa270aittran = LN_ITTRAN
             and a.aqpa270aitnrel = LN_ITNREL
             and a.aqpa270aitord = LN_ITORD
             and a.aqpa270aitsbor = LN_ITSBOR
             and a.aqpa270afec = pd_fecpro;
        exception
          when others then
            ln_MntCaja := 0.00;
        end;
      
        ln_MntCajaSL := ln_MntCaja - ln_MntLinea;
      
        ln_plazoAux := ln_plazoAux + ln_cont;
      
        if LN_ITTRAN = 61 then
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
                   ln_oper116,
                   ln_sbop116,
                   ln_116tope
              from fsr011 a, fsd010 b
             where a.r2cod = 1
               and a.r2mod = 117
               and a.r2suc = 25
               and a.r2mda = 0
               and a.r2pap = 0
               and a.r2cta = 112547
               and a.r2oper = 6023652
               and a.r2sbop = 0
               and a.r2tope = 109
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
          
            if ln_pgcod116 > 0 then
              begin
                select f.scsdo * -1
                  into ln_LineaUtilzd
                  from fsd011 f
                 where f.pgcod = ln_pgcod116
                   and f.scmod = ln_mod116
                   and f.scsuc = ln_suc116
                   and f.scmda = ln_mda116
                   and f.scpap = ln_pap116
                   and f.sccta = ln_cta116
                   and f.scoper = ln_oper116
                   and f.scsbop = ln_sbop116
                   and f.sctope = ln_116tope;
              end;
            
            end if;
          
          end;
          ln_montoAux := nvl(ln_LineaUtilzd, 0) + nvl(ln_monto, 0);
        
        else
          ln_montoAux := nvl(ln_monto, 0);
        
        end if;
      
        while ln_MaxCuo >= ln_plazoAux loop
        
          begin
          
            ln_MntLineaAux := (ln_montoAux *
                              ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                              (1 - power((1 + ((power((1 + (ln_tasa / 100)),
                                                      (1 / 12))) - 1)),
                                         -ln_plazoAux));
          end;
        
          ln_MntCajaAux := nvl(ln_MntCajaSL, 0) + nvl(ln_MntLineaAux, 0);
          ln_MntCajaAux := nvl(ln_MntCajaAux, 0);
          ln_saldIFIS   := nvl(ln_saldIFIS, 0);
          ln_resltneto  := nvl(ln_resltneto, 0);
          ln_cuocntg    := nvl(ln_cuocntg, 0);
          ln_cpotncl    := nvl(ln_cpotncl, 0);
        
          ln_ratioAux := (ln_MntCajaAux + ln_saldIFIS + ln_cuocntg +
                         ln_cpotncl) /
                         (ln_resltneto + ln_saldIFIS + ln_cpotncl);
        
          if ln_RatioAux <= ln_RatioAComparar then
            ln_MinCuo  := ln_plazoAux;
            ln_MaxCuo  := ln_MaxCuo;
            lc_TipMnsj := 'C';
            exit;
          else
            if ln_plazoAux = ln_MaxCuo then
              ln_MinCuo  := ln_plazoAux;
              ln_MaxCuo  := ln_MaxCuo;
              lc_TipMnsj := 'M';
              exit;
            else
              ln_plazoAux := ln_plazoAux + ln_cont;
            end if;
          end if;
        
        end loop;
      
      end if;
    
    end if;
  
  end sp_cr_NroCuotEstim;
  ------------------------------------------------------------------  
end pq_cr_caplineas_movil;
/
