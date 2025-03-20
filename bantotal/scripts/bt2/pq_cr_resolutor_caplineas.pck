create or replace package pq_cr_resolutor_caplineas is

  -- Author  : MPOSTIGOC
  -- Created : 13/01/2016 04:46:54 p.m.
  -- Purpose :
  -- Modificado : 2017.03.28 DCASTRO se modifico sp_refinanLinea
  -- Modificado : 18/07/2017 MPOSTIGOC  Cambio de longitud de Variable ln_captotal1
  -- Fecha de Modificación      : 07/05/2024
  -- Autor de la Modificación   : Maria Postigo
  -- Descripción de Modificación: Se reasigno una variable de number a char.
  ----------------------------------------------------------------------------------------

  procedure sp_cuentas(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       tipocambio    in number,
                       Instancia     in number,
                       pd_fecpro     in date,
                       lc_prgm       in varchar2,
                       pn_emp        in number,
                       pn_mod        in number,
                       pn_suc        in number,
                       pn_mda        in number,
                       pn_pap        in number,
                       pn_cta        in number,
                       pn_ope        in number,
                       pn_sbo        in number,
                       pn_top        in number,
                       pn_emp116     in number,
                       pn_mod116     in number,
                       pn_suc116     in number,
                       pn_mda116     in number,
                       pn_pap116     in number,
                       pn_cta116     in number,
                       pn_ope116     in number,
                       pn_sbo116     in number,
                       pn_top116     in number,
                       pn_trn        in number,
                       LN_ITPGCOD    in number, --ccerpa 27/09/2018
                       LN_ITSUC      in number, --ccerpa 27/09/2018
                       LN_ITMOD      in number, --ccerpa 27/09/2018
                       LN_ITTRAN     in number, --ccerpa 27/09/2018
                       LN_ITNREL     in number, --ccerpa 27/09/2018
                       LN_ITORD      in number, --ccerpa 27/09/2018
                       LN_ITSBOR     in number, --ccerpa 27/09/2018                                  
                       ln_garant     in varchar2, --ccerpa 27/09/2018                                                                  
                       ln_segmen     in number, --ccerpa 27/09/2018 
                       lv_usuario    in varchar2, --ccerpa 09/10/2018                          
                       ln_captotcaja out number,
                       saldo_externo out number,
                       ResultNeto    out number,
                       ln_captotal   out number);
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
                                 ln_subop10    in number,
                                 ln_tope10     in number,
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
                              pn_emp     in number,
                              pn_mod     in number,
                              pn_suc     in number,
                              pn_mda     in number,
                              pn_pap     in number,
                              pn_cta     in number,
                              pn_ope     in number,
                              pn_sbo     in number,
                              pn_top     in number,
                              pn_emp116  in number,
                              pn_mod116  in number,
                              pn_suc116  in number,
                              pn_mda116  in number,
                              pn_pap116  in number,
                              pn_cta116  in number,
                              pn_ope116  in number,
                              pn_sbo116  in number,
                              pn_top116  in number,
                              pn_trn     in number,
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
                                 ln_instancia    in number,
                                 tipocambio      in number,
                                 ln_suc10        in number, --mod 2016.04.12
                                 ln_mda10        in number, --mod 2016.04.12
                                 ln_pap10        in number, --mod 2016.04.12
                                 ln_cta10        in number, --mod 2016.04.12
                                 ln_oper10       in number, --mod 2016.04.12
                                 ln_sbop10       in number, --mod 2016.04.12
                                 ln_tope10       in number, --mod 2016.04.12
                                 ln_indicador    in number, --mod 2016.04.12
                                 ln_cuoparc      out number,
                                 ln_capacidad    out number);
  --------------------------------------------------------
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in char,
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
                         ln_peri10    in number,
                         tipocambio   in number,
                         ln_indicador in number,
                         lc_IndCred   in varchar2,
                         lc_flgprg    in varchar2,
                         pn_emp       in number,
                         pn_mod       in number,
                         pn_suc       in number,
                         pn_mda       in number,
                         pn_pap       in number,
                         pn_cta       in number,
                         pn_ope       in number,
                         pn_sbo       in number,
                         pn_top       in number,
                         pn_emp116    in number,
                         pn_mod116    in number,
                         pn_suc116    in number,
                         pn_mda116    in number,
                         pn_pap116    in number,
                         pn_cta116    in number,
                         pn_ope116    in number,
                         pn_sbo116    in number,
                         pn_top116    in number,
                         pn_trn       in number,
                         LN_ITPGCOD   in number, --ccerpa 27/09/2018
                         LN_ITSUC     in number, --ccerpa 27/09/2018
                         LN_ITMOD     in number, --ccerpa 27/09/2018
                         LN_ITTRAN    in number, --ccerpa 27/09/2018
                         LN_ITNREL    in number, --ccerpa 27/09/2018
                         LN_ITORD     in number, --ccerpa 27/09/2018
                         LN_ITSBOR    in number, --ccerpa 27/09/2018                                  
                         ln_garant    in varchar2, --ccerpa 27/09/2018                                                                  
                         ln_segmen    in number, --ccerpa 27/09/2018
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
  ---------------------------------------------------------------
  procedure sp_resolutor_venc(ln_Pepais  in number,
                              ln_Petdoc  in number,
                              ln_Pendoc  in char,
                              Instancia  in number,
                              pd_fecpro  in date,
                              ln_pgcod10 in number,
                              ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              -- ln_peri10    in number,
                              tipocambio   in number,
                              lc_IndCred   in varchar2,
                              lc_flgprg    in varchar2,
                              LN_ITPGCOD   in number, --ccerpa 27/09/2018
                              LN_ITSUC     in number, --ccerpa 27/09/2018
                              LN_ITMOD     in number, --ccerpa 27/09/2018
                              LN_ITTRAN    in number, --ccerpa 27/09/2018
                              LN_ITNREL    in number, --ccerpa 27/09/2018
                              LN_ITORD     in number, --ccerpa 27/09/2018
                              LN_ITSBOR    in number, --ccerpa 27/09/2018                                  
                              ln_garant    in varchar2, --ccerpa 27/09/2018                                                                  
                              ln_segmen    in number, --ccerpa 27/09/2018
                              lv_usuario   in varchar2,
                              ln_capacidad out number);
  -----------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais     in number,
                           ln_Petdoc     in number,
                           ln_Pendoc     in char,
                           tipocambio    in number,
                           Instancia     in number,
                           pd_fecpro     in date,
                           ln_captotcaja in number,
                           saldo_externo in number,
                           ResultNeto    in number,
                           ln_captotal   in number,
                           lc_indicador  in varchar2,
                           lc_flgprg     in varchar2,
                           LN_ITPGCOD    in number, --ccerpa 27/09/2018
                           LN_ITSUC      in number, --ccerpa 27/09/2018
                           LN_ITMOD      in number, --ccerpa 27/09/2018
                           LN_ITTRAN     in number, --ccerpa 27/09/2018
                           LN_ITNREL     in number, --ccerpa 27/09/2018
                           LN_ITORD      in number, --ccerpa 27/09/2018
                           LN_ITSBOR     in number, --ccerpa 27/09/2018                                  
                           ln_garant     in varchar2, --ccerpa 27/09/2018                                                                  
                           ln_segmen     in number, --ccerpa 27/09/2018 
                           lv_usuario    in varchar2, --ccerpa 09/10/2018 
                           pn_mod116     in number,
                           pn_suc116     in number,
                           pn_mda116     in number,
                           pn_pap116     in number,
                           pn_cta116     in number,
                           pn_ope116     in number,
                           pn_sbo116     in number,
                           pn_top116     in number);

  -------------------------------------------------------
  procedure sp_cr_LogCuentas(lnPepais     in number,
                             lnPetdoc     in number,
                             lnPendoc     in char,
                             tipocambio   in number,
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
                             lc_flgprg    in varchar2,
                             LN_ITPGCOD   in number, --ccerpa 27/09/2018
                             LN_ITSUC     in number, --ccerpa 27/09/2018
                             LN_ITMOD     in number, --ccerpa 27/09/2018
                             LN_ITTRAN    in number, --ccerpa 27/09/2018
                             LN_ITNREL    in number, --ccerpa 27/09/2018
                             LN_ITORD     in number, --ccerpa 27/09/2018
                             LN_ITSBOR    in number, --ccerpa 27/09/2018    
                             lv_usuario   in varchar2);
  -----------------------------------------------------------------
  procedure sp_cr_VerfLVInsertada(ln_instancia  in number,
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
                                  LN_ITPGCOD    in number,
                                  LN_ITSUC      in number,
                                  LN_ITMOD      in number,
                                  LN_ITTRAN     in number,
                                  LN_ITNREL     in number,
                                  LN_ITORD      in number,
                                  LN_ITSBOR     in number,
                                  lc_RegInst116 out varchar2);
  -----------------------------------------------------------                                                         
end pq_cr_resolutor_caplineas;
/

create or replace package body pq_cr_resolutor_caplineas is
  -- *****************************************************************
  -- Nombre                     : sp_resultadonetolinea
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : Calcula  deuda Caja 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  --
  -- Retorno                    : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : CCERPA 27/09/2018
  -- Descripción de Modificación: Se agregan los prametros de la transaccion

  --
  -- *****************************************************************

  procedure sp_cuentas(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       tipocambio    in number,
                       Instancia     in number,
                       pd_fecpro     in date,
                       lc_prgm       in varchar2,
                       pn_emp        in number,
                       pn_mod        in number,
                       pn_suc        in number,
                       pn_mda        in number,
                       pn_pap        in number,
                       pn_cta        in number,
                       pn_ope        in number,
                       pn_sbo        in number,
                       pn_top        in number,
                       pn_emp116     in number,
                       pn_mod116     in number,
                       pn_suc116     in number,
                       pn_mda116     in number,
                       pn_pap116     in number,
                       pn_cta116     in number,
                       pn_ope116     in number,
                       pn_sbo116     in number,
                       pn_top116     in number,
                       pn_trn        in number,
                       LN_ITPGCOD    in number, --ccerpa 27/09/2018
                       LN_ITSUC      in number, --ccerpa 27/09/2018
                       LN_ITMOD      in number, --ccerpa 27/09/2018
                       LN_ITTRAN     in number, --ccerpa 27/09/2018
                       LN_ITNREL     in number, --ccerpa 27/09/2018
                       LN_ITORD      in number, --ccerpa 27/09/2018
                       LN_ITSBOR     in number, --ccerpa 27/09/2018                                  
                       ln_garant     in varchar2, --ccerpa 27/09/2018                                                                  
                       ln_segmen     in number, --ccerpa 27/09/2018 
                       lv_usuario    in varchar2, --ccerpa 09/10/2018                          
                       ln_captotcaja out number,
                       saldo_externo out number,
                       ResultNeto    out number,
                       ln_captotal   out number) is
  
    ln_capacidad   number(10, 2);
    saldo_extSoles number(10, 2);
    saldo_extDol   number(10, 2);
    ln_cajaext     number(10, 2);
    divisor        number(10, 2);
    evaluacion     number(10, 2);
    mntsoles       number(10, 2);
    mntdolar       number(10, 2);
    lc_FlgLn       varchar2(2);
    lc_fgAdic      varchar2(1); --mod 2016.04.12
    lc_fgAmpl      varchar2(1); --mod 2016.04.12
    lc_ven         char(1); --mod 2016.04.12
    ln_indicador   number(10); --mod 2016.04.12
  
    lc_fgRefLin varchar2(1); -- 28/06/16 mpostigoc
    --ResultNeto1  number(10, 2);
    ln_captotal1 number(10, 6); -- 18/07/2017 MPOSTIGOC  Cambio de longitud de Variable
  
    lc_flgprg varchar2(2) := 'N';
  
    cursor inserta_vencidos is
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
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 25))
                  and modulo not in (29, 33, 200)))
         and d10.Aostat <> 99
         and d10.aofvto < pd_fecpro --mpostigoc  14/12/16
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
         and (b.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 25))
                  and modulo not in (29, 33, 200))) --Agregar guia de proceso para excluir modulos
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto < pd_fecpro;
  
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
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 25))
                  and modulo not in (29, 33, 200)) or d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro --mpostigoc  14/12/16
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
         and (b.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 13
                                        and a.tp1corr2 = 25))
                  and modulo not in (29, 33, 200)) or b.Aomod = 117) --Agregar guia de proceso para excluir modulos
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto >= pd_fecpro;
  
    cursor vuelo is
    
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
                                and pendoc = ln_Pendoc
                             /*and Ttcod = 1
                             and Cttfir = 'T'*/
                             )
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and tp1corr1 = 13
                                        and tp1corr2 = 25))
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
                            --and wftaskcod <> 55  --20160623ABR
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    --and wftaskcod <> 55--20160623ABR
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
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
         and c.pendoc = ln_Pendoc
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
                                        and a.tp1corr2 = 25))
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
                            --and wftaskcod <> 55--20160623ABR
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    --and wftaskcod <> 55--20160623ABR
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
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
       where Pgcod = 1
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
      -- and Aostat <> 99
      
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
            -- and b.aostat <> 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred  varchar2(10);
    ln_periodo  number;
    lc_estado   varchar2(5);
    lc_IsInsert varchar2(5) := 'N';
  
  begin
  
    ln_captotcaja := 0;
  
    begin
    
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 4
         and a.tp1corr3 = 1
         and a.tp1nro1 = 1
         and trim(tp1desc) = trim(lc_prgm);
    exception
      when others then
        lc_flgprg := 'N';
      
    end;
  
    if lc_prgm = 'RJAQY843' or lc_prgm = 'RJAQZ726' then
      -- 07/09/2017 MPOSTIGOC
    
      if lc_prgm = 'RJAQY843' then
      
        lc_flgprg := 'R';
        lc_estado := 'R';
      
      else
        if lc_prgm = 'RJAQZ726' then
        
          lc_flgprg := 'L';
          lc_estado := 'I';
        
        end if;
      
      end if;
    
      begin
        delete aqpa271 J
         WHERE J.aqpa271INST = Instancia
           and j.aqpa271est = lc_flgprg;
      end;
      /*   begin
          delete JAQY140 J
           WHERE J.JAQY140INST = Instancia
             and j.jaqy140est = lc_flgprg;
        end;
      */
    end if;
  
    if lc_flgprg = 'S' then
      -- 04/09/2017 mpostigoc
      begin
        UPDATE aqpa271 j
           set aqpa271est = 'I'
         where j.aqpa271inst = Instancia
           and j.aqpa271est = 'H';
        commit;
      end;
    
    end if;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
      --  if i.ln_mod10 = 117 then
    
      pq_cr_resolutor_caplineas.sp_refinanLinea(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                lc_fgRefLin);
      --  end if;
    
      pq_cr_resolutor_caplineas.Sp_Adicional_CK(i.ln_mod10,
                                                i.ln_tope10,
                                                lc_fgAdic);
      pq_cr_resolutor_caplineas.Sp_ampliados_CK(i.ln_pgcod10,
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
        pq_cr_resolutor_caplineas.sp_resolutor(ln_Pepais,
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
                                               i.ln_peri10,
                                               tipocambio,
                                               ln_indicador,
                                               lc_IndCred,
                                               lc_flgprg,
                                               pn_emp,
                                               pn_mod,
                                               pn_suc,
                                               pn_mda,
                                               pn_pap,
                                               pn_cta,
                                               pn_ope,
                                               pn_sbo,
                                               pn_top,
                                               pn_emp116,
                                               pn_mod116,
                                               pn_suc116,
                                               pn_mda116,
                                               pn_pap116,
                                               pn_cta116,
                                               pn_ope116,
                                               pn_sbo116,
                                               pn_top116,
                                               pn_trn,
                                               LN_ITPGCOD, --ccerpa 27/09/2018
                                               LN_ITSUC, --ccerpa 27/09/2018
                                               LN_ITMOD, --ccerpa 27/09/2018
                                               LN_ITTRAN, --ccerpa 27/09/2018
                                               LN_ITNREL, --ccerpa 27/09/2018
                                               LN_ITORD, --ccerpa 27/09/2018
                                               LN_ITSBOR, --ccerpa 27/09/2018                                  
                                               ln_garant, --ccerpa 27/09/2018                                                                  
                                               ln_segmen, --ccerpa 27/09/2018
                                               lv_usuario,
                                               ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for i in inserta_vencidos loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      --  if i.ln_mod10 = 117 then
    
      pq_cr_resolutor_caplineas.sp_refinanLinea(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                lc_fgRefLin);
      --  end if;
    
      pq_cr_resolutor_caplineas.Sp_Adicional_CK(i.ln_mod10,
                                                i.ln_tope10,
                                                lc_fgAdic);
      pq_cr_resolutor_caplineas.Sp_ampliados_CK(i.ln_pgcod10,
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
        pq_cr_resolutor_caplineas.sp_resolutor(ln_Pepais,
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
                                               i.ln_peri10,
                                               tipocambio,
                                               ln_indicador,
                                               lc_IndCred,
                                               lc_flgprg,
                                               pn_emp,
                                               pn_mod,
                                               pn_suc,
                                               pn_mda,
                                               pn_pap,
                                               pn_cta,
                                               pn_ope,
                                               pn_sbo,
                                               pn_top,
                                               pn_emp116,
                                               pn_mod116,
                                               pn_suc116,
                                               pn_mda116,
                                               pn_pap116,
                                               pn_cta116,
                                               pn_ope116,
                                               pn_sbo116,
                                               pn_top116,
                                               pn_trn,
                                               LN_ITPGCOD, --ccerpa 27/09/2018
                                               LN_ITSUC, --ccerpa 27/09/2018
                                               LN_ITMOD, --ccerpa 27/09/2018
                                               LN_ITTRAN, --ccerpa 27/09/2018
                                               LN_ITNREL, --ccerpa 27/09/2018
                                               LN_ITORD, --ccerpa 27/09/2018
                                               LN_ITSBOR, --ccerpa 27/09/2018                                  
                                               ln_garant, --ccerpa 27/09/2018                                                                  
                                               ln_segmen, --ccerpa 27/09/2018
                                               lv_usuario,
                                               ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      ln_periodo := c.ln_peri10;
    
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
    
      pq_cr_resolutor_caplineas.Sp_Adicional_CK(c.ln_mod10,
                                                c.ln_tope10,
                                                lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        pq_cr_resolutor_caplineas.sp_resolutor(ln_Pepais,
                                               ln_Petdoc,
                                               ln_Pendoc,
                                               Instancia,
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
                                               lc_flgprg,
                                               pn_emp,
                                               pn_mod,
                                               pn_suc,
                                               pn_mda,
                                               pn_pap,
                                               pn_cta,
                                               pn_ope,
                                               pn_sbo,
                                               pn_top,
                                               pn_emp116,
                                               pn_mod116,
                                               pn_suc116,
                                               pn_mda116,
                                               pn_pap116,
                                               pn_cta116,
                                               pn_ope116,
                                               pn_sbo116,
                                               pn_top116,
                                               pn_trn,
                                               LN_ITPGCOD, --ccerpa 27/09/2018
                                               LN_ITSUC, --ccerpa 27/09/2018
                                               LN_ITMOD, --ccerpa 27/09/2018
                                               LN_ITTRAN, --ccerpa 27/09/2018
                                               LN_ITNREL, --ccerpa 27/09/2018
                                               LN_ITORD, --ccerpa 27/09/2018
                                               LN_ITSBOR, --ccerpa 27/09/2018                                  
                                               ln_garant, --ccerpa 27/09/2018                                                                  
                                               ln_segmen, --ccerpa 27/09/2018
                                               lv_usuario,
                                               ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven loop
    
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
    
      pq_cr_resolutor_caplineas.Sp_Adicional_CK(j.ln_mod10,
                                                j.ln_tope10,
                                                lc_fgAdic);
    
      pq_cr_resolutor_caplineas.sp_refinanLinea(J.ln_pgcod10,
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
    
      if lc_ven = 'S' then
        pq_cr_resolutor_caplineas.sp_cr_VerfLVInsertada(ln_instancia  => Instancia,
                                                        lc_Estado     => 'I',
                                                        ln_pgcod117   => 1,
                                                        ln_mod117     => j.ln_mod10,
                                                        ln_suc117     => j.ln_suc10,
                                                        ln_mda117     => j.ln_mda10,
                                                        ln_pap117     => j.ln_pap10,
                                                        ln_cta117     => j.ln_cta10,
                                                        ln_ope117     => j.ln_oper10,
                                                        ln_sbop117    => j.ln_sbop10,
                                                        ln_tope117    => j.ln_tope10,
                                                        LN_ITPGCOD    => LN_ITPGCOD,
                                                        LN_ITSUC      => LN_ITSUC,
                                                        LN_ITMOD      => LN_ITMOD,
                                                        LN_ITTRAN     => LN_ITTRAN,
                                                        LN_ITNREL     => LN_ITNREL,
                                                        LN_ITORD      => LN_ITORD,
                                                        LN_ITSBOR     => LN_ITSBOR,
                                                        lc_RegInst116 => lc_IsInsert);
      
      end if;
    
      if lc_ven = 'S' and lc_IsInsert = 'N' and lc_fgAdic <> 'S' and
         lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        pq_cr_resolutor_caplineas.sp_resolutor_venc(ln_Pepais,
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
                                                    -- j.ln_peri10,
                                                    tipocambio,
                                                    lc_IndCred,
                                                    lc_flgprg,
                                                    LN_ITPGCOD, --ccerpa 27/09/2018
                                                    LN_ITSUC, --ccerpa 27/09/2018
                                                    LN_ITMOD, --ccerpa 27/09/2018
                                                    LN_ITTRAN, --ccerpa 27/09/2018
                                                    LN_ITNREL, --ccerpa 27/09/2018
                                                    LN_ITORD, --ccerpa 27/09/2018
                                                    LN_ITSBOR, --ccerpa 27/09/2018                                  
                                                    ln_garant, --ccerpa 27/09/2018                                                                  
                                                    ln_segmen, --ccerpa 27/09/2018
                                                    lv_usuario,
                                                    ln_capacidad --ccerpa27/09/2018
                                                    
                                                    );
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    --pq_cr_resolutor_cappago.Sp_ampliados(Instancia,tipocambio,ln_mtoampl);--mod 2016.04.12
    --ln_captotcaja := ln_captotcaja - ln_mtoampl;-- mod 2016.04.12
  
    begin
      -- deuda externa
      begin
        select sum(j.jaqy327gfin)
          into saldo_extSoles
          from jaqy327 j
         where j.jaqy327inst = Instancia
           and j.jaqy327esta = 'S'
           and j.jaqy327cent <> '00104'
           and j.jaqy327tcre in
               ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.');
      exception
        when others then
          null;
      end;
    
      begin
        begin
          select sum(j.jaqy327gfin)
            into saldo_extDol
            from jaqy327 j
           where j.jaqy327inst = Instancia
             and j.jaqy327esta = 'S'
             and j.jaqy327cent <> '00104'
             and j.jaqy327tcre in
                 ('Pymes US$', 'Consumo US$', 'Hipotecario US$');
        exception
          when others then
            null;
        end;
      
        saldo_extDol := nvl(saldo_extDol, 0) * tipocambio;
      
      end;
    
      saldo_externo := nvl(saldo_extDol, 0) + nvl(saldo_extSoles, 0);
    end;
  
    begin
      -- Suma de Deuda Caja y Deuda Externa
    
      ln_cajaext := nvl(ln_captotcaja, 0) + nvl(saldo_externo, 0);
    end;
  
    begin
      --- Resultado Neto
    
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
           and a.sng026cod = 40;
      exception
        when others then
          null;
      end;
    
      begin
        select a.sng023mto
          into mntdolar
          from sng023 a
         where a.sng021eval = evaluacion
           and a.sng026cod = 540;
      exception
        when others then
          null;
      end;
    
      ResultNeto := ((mntdolar * tipocambio) + mntsoles);
      ResultNeto := nvl(ResultNeto, 0);
      ResultNeto := round(ResultNeto, 2);
    
    end;
  
    begin
    
      Divisor := nvl(ResultNeto, 0) + nvl(saldo_externo, 0);
    end;
    if Divisor <> 0 then
      --ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6); --mpostigoc 210218
      ln_captotal1 := round(((ln_captotcaja + saldo_externo) /
                            (saldo_externo + ResultNeto)),
                            6);
    else
      ln_captotal1 := 0;
    end if;
  
    ln_captotal := nvl(ln_captotal1, 0);
  
    if lc_flgprg = 'S' or lc_flgprg = 'R' or lc_flgprg = 'L' then
    
      pq_cr_resolutor_caplineas.sp_cr_LogRatio(ln_Pepais     => ln_Pepais,
                                               ln_Petdoc     => ln_Petdoc,
                                               ln_Pendoc     => ln_Pendoc,
                                               tipocambio    => tipocambio,
                                               Instancia     => Instancia,
                                               pd_fecpro     => pd_fecpro,
                                               ln_captotcaja => ln_captotcaja,
                                               saldo_externo => saldo_externo,
                                               ResultNeto    => ResultNeto,
                                               ln_captotal   => ln_captotal,
                                               lc_indicador  => 'P',
                                               lc_flgprg     => lc_flgprg,
                                               LN_ITPGCOD    => LN_ITPGCOD, --ccerpa 27/09/2018
                                               LN_ITSUC      => LN_ITSUC, --ccerpa 27/09/2018
                                               LN_ITMOD      => LN_ITMOD, --ccerpa 27/09/2018
                                               LN_ITTRAN     => LN_ITTRAN, --ccerpa 27/09/2018
                                               LN_ITNREL     => LN_ITNREL, --ccerpa 27/09/2018
                                               LN_ITORD      => LN_ITORD, --ccerpa 27/09/2018
                                               LN_ITSBOR     => LN_ITSBOR, --ccerpa 27/09/2018                                  
                                               ln_garant     => ln_garant, --ccerpa 27/09/2018                                                                  
                                               ln_segmen     => ln_segmen, --ccerpa 27/09/2018
                                               lv_usuario    => lv_usuario,
                                               pn_mod116     => pn_mod116,
                                               pn_suc116     => pn_suc116,
                                               pn_mda116     => pn_mda116,
                                               pn_pap116     => pn_pap116,
                                               pn_cta116     => pn_cta116,
                                               pn_ope116     => pn_ope116,
                                               pn_sbo116     => pn_sbo116,
                                               pn_top116     => pn_top116
                                               
                                               );
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
  
    --- ln_instancia number;
  
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

  ---CUOTA IMPAGA --------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            ln_sbop10     in number,
                            ln_tope10     in number,
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
                                 ln_subop10    in number,
                                 ln_tope10     in number,
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
                              pn_emp     in number,
                              pn_mod     in number,
                              pn_suc     in number,
                              pn_mda     in number,
                              pn_pap     in number,
                              pn_cta     in number,
                              pn_ope     in number,
                              pn_sbo     in number,
                              pn_top     in number,
                              pn_emp116  in number,
                              pn_mod116  in number,
                              pn_suc116  in number,
                              pn_mda116  in number,
                              pn_pap116  in number,
                              pn_cta116  in number,
                              pn_ope116  in number,
                              pn_sbo116  in number,
                              pn_top116  in number,
                              pn_trn     in number,
                              ln_formula out number) is
  
    ln_plazo       number(10, 2);
    ln_tasa        number(10, 2);
    ln_saldo       number(10, 2);
    instancia      number;
    ln_paralelo    number;
    ln_fsd011scsdo number;
    ln_ctaX        number(9);
    ln_instancia   number;
    LN_TIPOCRED    number;
    lc_FlagSegmnt  varchar2(2);
    lc_FlagGuia    varchar2(1);
  
  begin
    --mod@abr 20170927
    if ln_mod10 = pn_mod and ln_suc10 = pn_suc and ln_mda10 = pn_mda and
       ln_pap10 = pn_pap and ln_cta10 = pn_cta and ln_oper10 = pn_ope and
       ln_sbop10 = pn_sbo and ln_tope10 = pn_top then
    
      begin
        select case
                 when (count(fsd011.scsdo) = 0) then
                  0
                 else
                  sum(scsdo)
               END
          into ln_fsd011scsdo
          from fsd011
         where fsd011.pgcod = pn_emp116
           and fsd011.scsuc = pn_suc116
           and fsd011.scmda = pn_mda116
           and fsd011.scpap = pn_pap116
           and fsd011.sccta = pn_cta116
           and fsd011.scoper = pn_ope116
           and fsd011.scsbop = pn_sbo116
           and fsd011.sctope = pn_top116
           and fsd011.scmod = pn_mod116
           and fsd011.scstat <> 99;
      exception
        when others then
          null;
      end;
    
      if pn_trn = 50 then
        begin
          select ((a.xllcantcuo * a.xllperiodo) / 30), a.xllcapital
            into ln_plazo, ln_saldo
            from x054023 a
           where a.xllpgcod = pn_emp116
             and a.xllaomod = pn_mod116
             and a.xllaosuc = pn_suc116
             and a.xllaomda = pn_mda116
             and a.xllaopap = pn_pap116
             and a.xllaocta = pn_cta116
             and a.xllaooper = pn_ope116
             and a.xllaosbop = pn_sbo116
             and a.xllaotop = pn_top116;
        exception
          when others then
            ln_plazo := 0;
        end;
      else
        ln_ctaX := 999999999;
        begin
          select ((a.xllcantcuo * a.xllperiodo) / 30), a.xllcapital
            into ln_plazo, ln_saldo
            from x054023 a
           where a.xllpgcod = pn_emp116
             and a.xllaomod = pn_mod116
             and a.xllaosuc = pn_suc116
             and a.xllaomda = pn_mda116
             and a.xllaopap = pn_pap116
             and a.xllaocta = ln_ctaX
             and a.xllaooper = pn_ope116
             and a.xllaosbop = pn_sbo116
             and a.xllaotop = pn_top116;
        exception
          when no_data_found then
          
            begin
              select ((a.xllcantcuo * a.xllperiodo) / 30), a.xllcapital
                into ln_plazo, ln_saldo
                from x054023 a
               where a.xllpgcod = pn_emp116
                 and a.xllaomod = pn_mod116
                 and a.xllaosuc = pn_suc116
                 and a.xllaomda = pn_mda116
                 and a.xllaopap = pn_pap116
                 and a.xllaocta = pn_cta116
                 and a.xllaooper = pn_ope116
                 and a.xllaosbop = pn_sbo116
                 and a.xllaotop = pn_top116;
            exception
              when others then
                ln_plazo := 0;
            end;
          when others then
            ln_plazo := 0;
        end;
      end if;
    
      begin
        select aotasa
          into ln_tasa
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
    
    else
    
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
      
        /*begin
          select x.xwfprcins
            into ln_instancia
            from xwf700 x
           where x.xwfempresa = 1
             and x.xwfsucursal = ln_suc10
             and x.xwfmodulo = ln_mod10
             and x.xwfmoneda = ln_mda10
             and x.xwfpapel = ln_pap10
             and x.xwfcuenta = ln_cta10
             and x.xwfoperacion = ln_oper10
             and x.xwfsubope = ln_sbop10
             and x.xwftipope = ln_tope10
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;*/
      
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
        
          select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval,
                                                         ';',
                                                         ''))),
                                          '([A-Z])',
                                          ''))
            into LN_TIPOCRED
            from wfattsvalues w
           where w.wfinsprcid = ln_instancia
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
          select x.xwfmonto1 --, x.xwfprcins
            into ln_saldo --, 
            from xwf700 x
           where x.xwfprcins = instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            ln_saldo := 0.00;
          
        end;
      
        begin
          /*select max(sng120tasa)
              into ln_tasa
              from sng120
             where sng120ins = instancia;
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
    
    end if;
  
    --fin mod@abr 20170927
  
    --ln_plazo := 3;--PRUEBA
  
    begin
      select SUM(SNGE01IMPA)
        into ln_paralelo
        from SNGE01
       WHERE SNGE01INST = instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select x.xwfprcins
        into instancia
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
      
    end;
  
    ln_saldo := nvl(ln_saldo, 0) - nvl(ln_paralelo, 0);
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  
    -- pq_cr_resolutor_cappago.Sp_Adicional(instancia,tipocambio,ln_mda10,ln_mtoAdic);
  
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
                                 ln_instancia    in number,
                                 tipocambio      in number,
                                 ln_suc10        in number, --mod 2016.04.12
                                 ln_mda10        in number, --mod 2016.04.12
                                 ln_pap10        in number, --mod 2016.04.12
                                 ln_cta10        in number, --mod 2016.04.12
                                 ln_oper10       in number, --mod 2016.04.12
                                 ln_sbop10       in number, --mod 2016.04.12
                                 ln_tope10       in number, --mod 2016.04.12
                                 ln_indicador    in number, --mod 2016.04.12
                                 ln_cuoparc      out number,
                                 ln_capacidad    out number) is
    ln_mensual number(10, 2);
    ln_cuota   number(10, 2);
    -- ln_sngmda  number;
    -- ln_cuotaimp number;
  
    ln_mtoPar number(17, 2); --mod 2016.04.12
    ln_plazo  number(10, 2); --mod 2016.04.12
    ln_tasa   number(10, 2); --mod 2016.04.12
    ln_period number; --mod 2016.04.12
    ln_cuo    number(10, 2);
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
               where a.sng120ins = ln_instancia
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
               where a.sng120ins = ln_instancia
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
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in char,
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
                         ln_peri10    in number,
                         tipocambio   in number,
                         ln_indicador in number,
                         lc_IndCred   in varchar2,
                         lc_flgprg    in varchar2,
                         pn_emp       in number,
                         pn_mod       in number,
                         pn_suc       in number,
                         pn_mda       in number,
                         pn_pap       in number,
                         pn_cta       in number,
                         pn_ope       in number,
                         pn_sbo       in number,
                         pn_top       in number,
                         pn_emp116    in number,
                         pn_mod116    in number,
                         pn_suc116    in number,
                         pn_mda116    in number,
                         pn_pap116    in number,
                         pn_cta116    in number,
                         pn_ope116    in number,
                         pn_sbo116    in number,
                         pn_top116    in number,
                         pn_trn       in number,
                         LN_ITPGCOD   in number, --ccerpa 27/09/2018
                         LN_ITSUC     in number, --ccerpa 27/09/2018
                         LN_ITMOD     in number, --ccerpa 27/09/2018
                         LN_ITTRAN    in number, --ccerpa 27/09/2018
                         LN_ITNREL    in number, --ccerpa 27/09/2018
                         LN_ITORD     in number, --ccerpa 27/09/2018
                         LN_ITSBOR    in number, --ccerpa 27/09/2018                                  
                         ln_garant    in varchar2, --ccerpa 27/09/2018                                                                  
                         ln_segmen    in number, --ccerpa 27/09/2018 
                         lv_usuario   in varchar2,
                         ln_capacidad out number) is
  
    ln_nrocuotas  number(10, 2);
    ln_parciales  number(10, 2);
    ln_cuotimp    number(10, 2) := 0;
    ln_seguro     number(10, 2);
    fech_maxcuota date;
    ln_instancia  number;
    --lc_ven        char(1);
    ln_flagFC  varchar2(1) := 'N'; -- 20/12/2016 mpostigoc
    ln_CapFC   number(10, 2);
    CapLinea   number(10, 2);
    ln_cuoparc number(10, 2);
  
  begin
  
    ln_CapFC := 0;
    CapLinea := 0;
  
    pq_cr_resolutor_caplineas.sp_cuotas(ln_pgcod10,
                                        ln_mod10,
                                        ln_suc10,
                                        ln_mda10,
                                        ln_pap10,
                                        ln_cta10,
                                        ln_oper10,
                                        ln_sbop10,
                                        ln_tope10,
                                        ln_nrocuotas);
  
    pq_cr_resolutor_caplineas.sp_instancia(ln_mod10,
                                           ln_suc10,
                                           ln_mda10,
                                           ln_pap10,
                                           ln_cta10,
                                           ln_oper10,
                                           ln_sbop10,
                                           ln_tope10,
                                           ln_parciales,
                                           ln_instancia);
  
    pq_cr_resolutor_caplineas.sp_cr_flujocaja(ln_pgcod10,
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
        pq_cr_resolutor_caplineas.sp_cuota_impaga(ln_pgcod10,
                                                  ln_mod10,
                                                  ln_suc10,
                                                  ln_mda10,
                                                  ln_pap10,
                                                  ln_cta10,
                                                  ln_oper10,
                                                  ln_sbop10,
                                                  ln_tope10,
                                                  tipocambio,
                                                  ln_cuotimp,
                                                  fech_maxcuota);
      else
      
        pq_cr_resolutor_caplineas.sp_cuota_impagavuelo(ln_pgcod10,
                                                       ln_mod10,
                                                       ln_suc10,
                                                       ln_mda10,
                                                       ln_pap10,
                                                       ln_cta10,
                                                       ln_oper10,
                                                       ln_sbop10,
                                                       ln_tope10,
                                                       tipocambio,
                                                       ln_cuotimp,
                                                       fech_maxcuota);
      
      end if;
    
    else
      if ln_mod10 <> 117 and ln_flagFC = 'S' then
        pq_cr_resolutor_caplineas.sp_cr_capacidadFC(ln_mod10,
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
  
    pq_cr_resolutor_caplineas.sp_seguro(ln_mod10,
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
      pq_cr_resolutor_caplineas.sp_capacidadlinea(ln_mod10,
                                                  ln_suc10,
                                                  ln_mda10,
                                                  ln_pap10,
                                                  ln_cta10,
                                                  ln_oper10,
                                                  ln_sbop10,
                                                  ln_tope10,
                                                  tipocambio,
                                                  pn_emp,
                                                  pn_mod,
                                                  pn_suc,
                                                  pn_mda,
                                                  pn_pap,
                                                  pn_cta,
                                                  pn_ope,
                                                  pn_sbo,
                                                  pn_top,
                                                  pn_emp116,
                                                  pn_mod116,
                                                  pn_suc116,
                                                  pn_mda116,
                                                  pn_pap116,
                                                  pn_cta116,
                                                  pn_ope116,
                                                  pn_sbo116,
                                                  pn_top116,
                                                  pn_trn,
                                                  ln_capacidad);
    
      CapLinea := ln_capacidad;
    
    end if;
  
    IF ln_parciales = 7 then
    
      pq_cr_resolutor_caplineas.sp_capacidadpagoparc(ln_nrocuotas,
                                                     ln_parciales,
                                                     ln_seguro,
                                                     ln_mod10,
                                                     ln_instancia,
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
    
      pq_cr_resolutor_caplineas.sp_capacidadpago(ln_cuotimp,
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
      
        pq_cr_resolutor_caplineas.sp_cr_LogCuentas(ln_Pepais,
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
                                                   lc_flgprg,
                                                   LN_ITPGCOD, --ccerpa 27/09/2018
                                                   LN_ITSUC, --ccerpa 27/09/2018
                                                   LN_ITMOD, --ccerpa 27/09/2018
                                                   LN_ITTRAN, --ccerpa 27/09/2018
                                                   LN_ITNREL, --ccerpa 27/09/2018
                                                   LN_ITORD, --ccerpa 27/09/2018
                                                   LN_ITSBOR, --ccerpa 27/09/2018                                  
                                                   lv_usuario);
      end if;
    end if;
  
  end sp_resolutor;

  --------------------------------------------------
  procedure sp_resolutor_venc(ln_Pepais  in number,
                              ln_Petdoc  in number,
                              ln_Pendoc  in char,
                              Instancia  in number,
                              pd_fecpro  in date,
                              ln_pgcod10 in number,
                              ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              --ln_peri10    in number,
                              tipocambio in number,
                              
                              lc_IndCred   in varchar2,
                              lc_flgprg    in varchar2,
                              LN_ITPGCOD   in number, --ccerpa 27/09/2018
                              LN_ITSUC     in number, --ccerpa 27/09/2018
                              LN_ITMOD     in number, --ccerpa 27/09/2018
                              LN_ITTRAN    in number, --ccerpa 27/09/2018
                              LN_ITNREL    in number, --ccerpa 27/09/2018
                              LN_ITORD     in number, --ccerpa 27/09/2018
                              LN_ITSBOR    in number, --ccerpa 27/09/2018                                  
                              ln_garant    in varchar2, --ccerpa 27/09/2018                                                                  
                              ln_segmen    in number, --ccerpa 27/09/2018
                              lv_usuario   in varchar2,
                              ln_capacidad out number) is
    ln_nrocuotas number;
    -- ln_parciales  number;
    ln_cuotimp    number(10, 2);
    ln_seguro     number(10, 2);
    fech_maxcuota date;
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
         and relcod = 46;
  
    ln_pr116     number;
    ln_capTem    number(10, 2);
    ln_parciales number;
    ln_flagFC    varchar2(2);
    ln_CapFC     number;
    CapLinea     number;
    ln_instancia number;
  
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
      
        pq_cr_resolutor_caplineas.sp_cuotas(i.ln_pgcod10,
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
      
        pq_cr_resolutor_caplineas.sp_cuota_impaga_lin(i.ln_pgcod10,
                                                      i.ln_mod10,
                                                      i.ln_suc10,
                                                      i.ln_mda10,
                                                      i.ln_pap10,
                                                      i.ln_cta10,
                                                      i.ln_oper10,
                                                      tipocambio,
                                                      ln_cuotimp,
                                                      fech_maxcuota);
      
        pq_cr_resolutor_caplineas.sp_seguro(i.ln_mod10,
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
        pq_cr_resolutor_caplineas.sp_capacidadpago_lin(ln_cuotimp,
                                                       ln_nrocuotas,
                                                       ln_pr116,
                                                       ln_seguro,
                                                       i.ln_mod10,
                                                       ln_capTem);
        pq_cr_resolutor_caplineas.sp_instancia(i.ln_mod10,
                                               i.ln_suc10,
                                               i.ln_mda10,
                                               i.ln_pap10,
                                               i.ln_cta10,
                                               i.ln_oper10,
                                               i.ln_sbop10,
                                               i.ln_tope10,
                                               ln_parciales,
                                               ln_instancia);
      
        if ln_capTem > 0 then
        
          ln_flagFC := 'N';
          ln_CapFC  := nvl(ln_CapFC, 0);
          CapLinea  := nvl(CapLinea, 0);
        
          pq_cr_resolutor_caplineas.sp_cr_LogCuentas(ln_Pepais,
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
                                                     lc_flgprg,
                                                     LN_ITPGCOD, --ccerpa 27/09/2018
                                                     LN_ITSUC, --ccerpa 27/09/2018
                                                     LN_ITMOD, --ccerpa 27/09/2018
                                                     LN_ITTRAN, --ccerpa 27/09/2018
                                                     LN_ITNREL, --ccerpa 27/09/2018
                                                     LN_ITORD, --ccerpa 27/09/2018
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
                            Pc_flag   out varchar2) is --mod 2016.04.12
  
  begin
  
    begin
      /*select 'S'
       into Pc_flag
       from xwf700 a
      where a.xwfempresa = ln_emp10
        and a.xwfsucursal = ln_suc10
        and a.xwfmodulo = ln_mod10
        and a.xwfmoneda = ln_mda10
        and a.xwfpapel = ln_pap10
        and a.xwfcuenta = ln_cta10
        and a.xwfoperacion = ln_oper10
        and a.xwfsubope = ln_sbop10
        and a.xwftipope = ln_tope10
        and a.xwfcar3 not in ('1', 'A')
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
    --2017.03.28 DCASTRO se agrego condicion rownum
    -- lc_fgRefLin varchar2(1);
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
           and f.relcod = 46; --2017.03.28
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
      select tp1nro1
        into ln_nroflujo
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and tp1corr1 = 13
         and tp1corr2 = 3;
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
    /*ln_r1mod  number;
    ln_r1suc  number;
    ln_r1mda  number;
    ln_r1pap  number;
    ln_r1cta  number;
    ln_r1oper number;
    ln_r1cod  number;*/
  
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
    ln_mensual number(10, 2);
    ln_cuota   number(10, 2);
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

  procedure sp_cr_LogRatio(ln_Pepais     in number,
                           ln_Petdoc     in number,
                           ln_Pendoc     in char,
                           tipocambio    in number,
                           Instancia     in number,
                           pd_fecpro     in date,
                           ln_captotcaja in number,
                           saldo_externo in number,
                           ResultNeto    in number,
                           ln_captotal   in number,
                           lc_indicador  in varchar2,
                           lc_flgprg     in varchar2,
                           LN_ITPGCOD    in number, --ccerpa 27/09/2018
                           LN_ITSUC      in number, --ccerpa 27/09/2018
                           LN_ITMOD      in number, --ccerpa 27/09/2018
                           LN_ITTRAN     in number, --ccerpa 27/09/2018
                           LN_ITNREL     in number, --ccerpa 27/09/2018
                           LN_ITORD      in number, --ccerpa 27/09/2018
                           LN_ITSBOR     in number, --ccerpa 27/09/2018                                  
                           ln_garant     in varchar2, --ccerpa 27/09/2018                                                                  
                           ln_segmen     in number, --ccerpa 27/09/2018
                           lv_usuario    in varchar2, --ccerpa 09/10/2018 
                           pn_mod116     in number,
                           pn_suc116     in number,
                           pn_mda116     in number,
                           pn_pap116     in number,
                           pn_cta116     in number,
                           pn_ope116     in number,
                           pn_sbo116     in number,
                           pn_top116     in number) is
  
    lc_IndEst varchar2(2);
    lc_hora   character(8);
    ln_corr   number := 0;
    lc_code   varchar2(40);
    lc_desc   varchar2(40);
  
  begin
  
    if lc_flgprg = 'S' then
    
      lc_IndEst := 'H';
      /*
      begin
        update jaqy140 j
           set j.jaqy140est = 'I'
         where j.jaqy140inst = Instancia
           and j.jaqy140est = 'H';
        commit;
      end;*/
    
    else
      if lc_flgprg = 'R' then
      
        lc_IndEst := 'R';
      
      else
        if lc_flgprg = 'L' then
          lc_IndEst := 'I';
        end if;
      end if;
    
    end if;
  
    begin
    
      select max(j.aqpa270corr)
        into ln_corr
        from aqpa270 j
       where j.aqpa270fec = pd_fecpro
         and j.aqpa270inst = Instancia;
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
  
    -- if lc_exist = 'N' then
    begin
      insert into aqpa270 a --jaqy140
        (aqpa270corr,
         aqpa270pais,
         aqpa270tdoc,
         aqpa270ndoc,
         aqpa270tcamb,
         aqpa270inst,
         aqpa270fec,
         aqpa270hora,
         aqpa270capcaja,
         aqpa270sldext,
         aqpa270resnet,
         aqpa270ratio,
         aqpa270ind,
         aqpa270EST,
         aqpa270user,
         AQPA270PGCOD, --ccerpa  27/09/2018
         AQPA270ITSUC,
         AQPA270ITMOD,
         AQPA270ITTRAN,
         AQPA270ITNREL,
         AQPA270ITORD,
         AQPA270ITSBOR,
         AQPA270GARANT,
         AQPA270SEGMEN,
         aqpa270mod,
         aqpa270suc,
         aqpa270mda,
         aqpa270pap,
         aqpa270cta,
         aqpa27ope,
         aqpa270sbop,
         aqpa270top) --ccerpa 27/09/2018
      
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
         saldo_externo,
         ResultNeto,
         ln_captotal,
         lc_indicador,
         lc_IndEst,
         lv_usuario,
         -- empieza ccerpa  27/09/2018
         LN_ITPGCOD, --ccerpa 27/09/2018
         LN_ITSUC, --ccerpa 27/09/2018
         LN_ITMOD, --ccerpa 27/09/2018
         LN_ITTRAN, --ccerpa 27/09/2018
         LN_ITNREL, --ccerpa 27/09/2018
         LN_ITORD, --ccerpa 27/09/2018
         LN_ITSBOR, --ccerpa 27/09/2018                                  
         ln_garant, --ccerpa 27/09/2018                                                                  
         ln_segmen, --ccerpa 27/09/2018
         -- termina ccerpa 27/09/2018
         pn_mod116,
         pn_suc116,
         pn_mda116,
         pn_pap116,
         pn_cta116,
         pn_ope116,
         pn_sbo116,
         pn_top116);
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
            ('HJAQZ726',
             'RATLINEA',
             pd_fecpro,
             lc_hora,
             lv_usuario,
             Instancia,
             ln_Pepais,
             ln_Petdoc,
             ln_Pendoc,
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
                             tipocambio   in number,
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
                             lc_flgprg    in varchar2,
                             LN_ITPGCOD   in number, --ccerpa 27/09/2018
                             LN_ITSUC     in number, --ccerpa 27/09/2018
                             LN_ITMOD     in number, --ccerpa 27/09/2018
                             LN_ITTRAN    in number, --ccerpa 27/09/2018
                             LN_ITNREL    in number, --ccerpa 27/09/2018
                             LN_ITORD     in number, --ccerpa 27/09/2018
                             LN_ITSBOR    in number, --ccerpa 27/09/2018  
                             lv_usuario   in varchar2 --ccerpa 09/10/2018     
                             
                             ) is
  
    --lc_exist varchar2(2) := 'N';
    lc_hora   character(8);
    lc_IndEst varchar2(2);
    ln_corr   number := 0;
    lc_code   varchar2(40);
    lc_desc   varchar2(40);
  
  begin
  
    begin
    
      select max(j.aqpa271corr)
        into ln_corr
        from aqpa271 j
       where j.aqpa271fec = pd_fecpro
         and j.aqpa271inst = Instancia;
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
  
    if lc_flgprg = 'S' then
    
      lc_IndEst := 'H';
    
    else
      if lc_flgprg = 'R' then
      
        lc_IndEst := 'R';
      
      else
        if lc_flgprg = 'L' then
        
          lc_IndEst := 'I';
        
        end if;
      end if;
    end if;
  
    -- if lc_exist = 'N' then
  
    begin
      insert into aqpa271
        (aqpa271corr,
         aqpa271fec,
         aqpa271hora,
         aqpa271pais,
         aqpa271tdoc,
         aqpa271ndoc,
         aqpa271tcamb,
         aqpa271inst,
         aqpa271pgcod,
         aqpa271mod,
         aqpa271suc,
         aqpa271mda,
         aqpa271pap,
         aqpa271cta,
         aqpa271ope,
         aqpa271sbop,
         aqpa271tope,
         aqpa271PERIO,
         aqpa271NRCUO,
         aqpa271TSOLI,
         aqpa271FLCJ,
         aqpa271CUOIMP,
         aqpa271SEGURO,
         aqpa271CAPFC,
         aqpa271CAPLIN,
         aqpa271capcuo,
         aqpa271INDIC,
         aqpa271est,
         aqpa271user,
         AQPA271IPGCOD, --ccerpa 27/09/2018
         AQPA271ITSUC, --ccerpa 27/09/2018
         AQPA271ITMOD, --ccerpa 27/09/2018
         AQPA271ITTRAN, --ccerpa 27/09/2018
         AQPA271ITNREL, --ccerpa 27/09/2018
         AQPA271ITORD, --ccerpa 27/09/2018
         AQPA271ITSBOR --ccerpa 27/09/2018 
         )
      
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
         LN_ITPGCOD, --ccerpa 27/09/2018
         LN_ITSUC, --ccerpa 27/09/2018
         LN_ITMOD, --ccerpa 27/09/2018
         LN_ITTRAN, --ccerpa 27/09/2018
         LN_ITNREL, --ccerpa 27/09/2018
         LN_ITORD, --ccerpa 27/09/2018
         LN_ITSBOR --ccerpa 27/09/2018 
         );
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
            ('HJAQZ726',
             'RATLINEA',
             pd_fecpro,
             lc_hora,
             lv_usuario,
             Instancia,
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
  procedure sp_cr_VerfLVInsertada(ln_instancia  in number,
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
                                  LN_ITPGCOD    in number,
                                  LN_ITSUC      in number,
                                  LN_ITMOD      in number,
                                  LN_ITTRAN     in number,
                                  LN_ITNREL     in number,
                                  LN_ITORD      in number,
                                  LN_ITSBOR     in number,
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
    ln_NroReg271 number;
    lc_IndEst    varchar2(5) := 'H';
  
  begin
    lc_RegInst116 := 'N';
  
    lc_IndEst := 'I';
  
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
          into ln_NroReg271
          from AQPA271 j
         where j.AQPA271inst = ln_instancia
           and j.aqpa271pgcod = ln_pgcod116
           and j.aqpa271mod = ln_mod116
           and j.aqpa271suc = ln_suc116
           and j.aqpa271mda = ln_mda116
           and j.aqpa271pap = ln_pap116
           and j.aqpa271cta = ln_cta116
           and j.aqpa271ope = ln_ope116
           and j.aqpa271sbop = ln_sbop116
           and j.aqpa271tope = ln_tope116
           and j.aqpa271ipgcod = LN_ITPGCOD
           and j.aqpa271itsuc = LN_ITSUC
           and j.aqpa271itmod = LN_ITMOD
           and j.aqpa271ittran = LN_ITTRAN
           and j.aqpa271itnrel = LN_ITNREL
           and j.aqpa271itord = LN_ITORD
           and j.aqpa271itsbor = LN_ITSBOR
           and j.aqpa271est = lc_IndEst;
      exception
        when others then
          null;
      end;
    
      if ln_NroReg271 > 0 then
        lc_RegInst116 := 'S';
      else
        lc_RegInst116 := 'N';
      end if;
    end if;
  
  end;
  ------------------------------------------------
end pq_cr_resolutor_caplineas;
/

