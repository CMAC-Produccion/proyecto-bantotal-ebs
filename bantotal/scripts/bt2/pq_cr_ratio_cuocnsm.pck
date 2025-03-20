create or replace package PQ_CR_RATIO_CUOCNSM is

  -- Author  : MPOSTIGOC
  -- Created : 18/10/17 12:46:54 p.m.
  -- Purpose : Ratio Cuota Resultado Consumo
  -- Fecha de Modificación      : 30/11/2023
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: se considero NVL para la variable de nro de cuotas en casos de flujo de caja
  -- Fecha de Modificación      : 15/03/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se descomento el monto de cuota potencial en el denominador de la formula  
  -----------------------------------------------------------

  procedure sp_cuentas(ln_Pepais        in number,
                       ln_Petdoc        in number,
                       ln_Pendoc        in char,
                       tipocambio       in number,
                       Instancia        in number,
                       pd_fecpro        in date,
                       lc_prgm          in varchar2,
                       ln_captotcaja    out number,
                       saldo_externo    out number,
                       ln_ExcdntMensual out number,
                       ln_RatioConsumo  out number);
  ------------------------------------------------------
  procedure sp_cuentas_normal(ln_Pepais        in number,
                              ln_Petdoc        in number,
                              ln_Pendoc        in char,
                              tipocambio       in number,
                              Instancia        in number,
                              pd_fecpro        in date,
                              lc_prgm          in varchar2,
                              ln_captotcaja    out number,
                              saldo_externo    out number,
                              ln_ExcdntMensual out number,
                              ln_RatioConsumo  out number);
  ------------------------------------------------------
  procedure sp_cuentas_hip(ln_Pepais        in number,
                           ln_Petdoc        in number,
                           ln_Pendoc        in char,
                           tipocambio       in number,
                           Instancia        in number,
                           pd_fecpro        in date,
                           lc_prgm          in varchar2,
                           ln_captotcaja    out number,
                           saldo_externo    out number,
                           ln_ExcdntMensual out number,
                           ln_RatioConsumo  out number);
  -----------------------------------------------------------
  procedure sp_CalculoRatio(ln_Pepais        in number,
                            ln_Petdoc        in number,
                            ln_Pendoc        in char,
                            tipocambio       in number,
                            Instancia        in number,
                            pd_fecpro        in date,
                            lc_prgm          in varchar2,
                            ln_Usuario       in varchar2,
                            ln_captotcaja    out number,
                            saldo_externo    out number,
                            ln_ExcdntMensual out number,
                            ln_RatioConsumo  out number);
  --------------------------------------------------------
  procedure sp_cuentas_convenio(ln_Pepais        in number,
                                ln_Petdoc        in number,
                                ln_Pendoc        in char,
                                tipocambio       in number,
                                Instancia        in number,
                                pd_fecpro        in date,
                                lc_prgm          in varchar2,
                                ln_captotcaja    out number,
                                saldo_externo    out number,
                                ln_ExcdntMensual out number,
                                ln_RatioConsumo  out number);
  --------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                pd_fecpro       in date,
                                lc_flgprg       in varchar2,
                                ln_MntCuoCntgCF out number);
  -----------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  pd_fecpro         in date,
                                  lc_flgprg         in varchar2,
                                  ln_MntCuoCntgAval out number);
  ----------------------------------------------------------
  /*procedure sp_cR_CuotaPotencial(ln_Instancia   in number,
  ln_MntPotncial out number);*/
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
                            ln_subop10    in number,
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
                         lc_EjecRatio in varchar2,
                         lc_Usuario   in varchar2,
                         ln_Tarea     in number,
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
                              --ln_peri10    in number,
                              tipocambio   in number,
                              lc_IndCred   in varchar2,
                              lc_flgprg    in varchar2,
                              lc_EjecRatio in varchar2,
                              lc_Usuario   in varchar2,
                              ln_Tarea     in number,
                              ln_capacidad out number);
  -----------------------------------------------------------

  procedure sp_cr_LogRatio(ln_Pepais        in number,
                           ln_Petdoc        in number,
                           ln_Pendoc        in char,
                           tipocambio       in number,
                           Instancia        in number,
                           pd_fecpro        in date,
                           ln_captotcaja    in number,
                           saldo_externo    in number,
                           ln_ExcdntMensual in number,
                           ln_MntCuoCntg    in number,
                           ln_MntPotncial   in number,
                           ln_RatioConsumo  in number,
                           lc_indicador     in varchar2,
                           lc_flgprg        in varchar2,
                           lc_Usuario       in varchar2,
                           ln_Tarea         in number);

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
                             lc_Usuario   in varchar2,
                             ln_Tarea     in number);
  -------------------------------------------------------------
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
                                  lc_RegInst116 out varchar2);

end PQ_CR_RATIO_CUOCNSM;
/

create or replace package body PQ_CR_RATIO_CUOCNSM is

  ------- RESOLUTOR CUOTA CONSUMO EN CAJA AQP Y DEUDA FINANCIERA EXTERNA

  procedure sp_cuentas(ln_Pepais        in number,
                       ln_Petdoc        in number,
                       ln_Pendoc        in char,
                       tipocambio       in number,
                       Instancia        in number,
                       pd_fecpro        in date,
                       lc_prgm          in varchar2,
                       ln_captotcaja    out number,
                       saldo_externo    out number,
                       ln_ExcdntMensual out number,
                       ln_RatioConsumo  out number) is
  
    ln_ModuloInst number; -- MPOSTIGOC 11/01/2018 Para PRY789 
  
  begin
  
    begin
      select xwfmodulo
        into ln_ModuloInst
        from xwf700
       where xwfprcins = Instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_ModuloInst = 107 then
    
      pq_cr_ratio_cuocnsm.sp_cuentas_convenio(ln_Pepais,
                                              ln_Petdoc,
                                              ln_Pendoc,
                                              tipocambio,
                                              Instancia,
                                              pd_fecpro,
                                              lc_prgm,
                                              ln_captotcaja,
                                              saldo_externo,
                                              ln_ExcdntMensual,
                                              ln_RatioConsumo);
    
    else
      if ln_ModuloInst <> 107 then
        pq_cr_ratio_cuocnsm.sp_cuentas_normal(ln_Pepais,
                                              ln_Petdoc,
                                              ln_Pendoc,
                                              tipocambio,
                                              Instancia,
                                              pd_fecpro,
                                              lc_prgm,
                                              ln_captotcaja,
                                              saldo_externo,
                                              ln_ExcdntMensual,
                                              ln_RatioConsumo);
      
      end if;
    end if;
  
  end sp_cuentas;
  --------------------------------------------------------------------------------
  procedure sp_cuentas_hip(ln_Pepais        in number,
                           ln_Petdoc        in number,
                           ln_Pendoc        in char,
                           tipocambio       in number,
                           Instancia        in number,
                           pd_fecpro        in date,
                           lc_prgm          in varchar2,
                           ln_captotcaja    out number,
                           saldo_externo    out number,
                           ln_ExcdntMensual out number,
                           ln_RatioConsumo  out number) is
    ln_capacidad   number(17, 2);
    saldo_extSoles number(17, 2);
    saldo_extDol   number(17, 2);
    ln_cajaext     number(17, 2);
    divisor        number(17, 2);
    lc_FlgLn       varchar2(2);
    lc_fgAdic      varchar2(1);
    lc_fgAmpl      varchar2(1);
    lc_ven         char(1);
    ln_indicador   number(10);
    lc_fgRefLin    varchar2(1);
    ln_captotal1   number(17, 6);
    evaluacion     number(10);
    mntsoles       number(17, 2);
    mntdolar       number(17, 2);
    lc_flgprg      varchar2(2);
  
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
                                and pendoc = ln_Pendoc)
            
         and (x.xwfmodulo in
             (select f.modulo
                 from fst111 f
                where f.dscod = 50
                  and modulo not in (29, 33, 200)) or x.xwfmodulo = 117)
            
         and x.XWFPRCINS in
             (select wf.wfinsprcid
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
             (select wf.wfinsprcid
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
  
    lc_IndCred     varchar2(10);
    lc_Usuario     varchar2(10);
    ln_captotcaja1 number;
    ln_captotcaja2 number;
    ln_Tarea       number;
    ln_tipocambio  number;
    ln_periodo     number;
    lc_EjecRatio   varchar2(2) := 'N';
    lc_TieneRL     varchar2(5) := 'N';
    lc_IsInsert    varchar2(5) := 'N';
  
  begin
  
    ln_captotcaja := 0;
  
    ln_tipocambio := tipocambio;
  
    if ln_tipocambio is null or ln_tipocambio <= 0 then
    
      begin
        select s. sng120tcbi
          into ln_tipocambio
          from sng120 s
         where s.sng120ins = Instancia
           and s.sng120tsk = 'EVALUACION';
      exception
        when others then
          ln_tipocambio := 0;
      end;
    
    end if;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
      --  if i.ln_mod10 = 117 then
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                          i.ln_tope10,
                                          lc_fgAdic);
    
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         ln_tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         'S',
                                         lc_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
      end if;
    
    end loop;
  
    for i in inserta_vencidos loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      --  if i.ln_mod10 = 117 then
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                          i.ln_tope10,
                                          lc_fgAdic);
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         ln_tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         'S',
                                         lc_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
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
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(c.ln_mod10,
                                          c.ln_tope10,
                                          lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         ln_tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         'S',
                                         lc_Usuario,
                                         ln_Tarea,
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
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(j.ln_mod10,
                                          j.ln_tope10,
                                          lc_fgAdic);
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(J.ln_pgcod10,
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
        --mpostigoc 22.06.23
        Pq_Cr_Ratio_Cuocnsm.sp_cr_VerfLVInsertada(ln_instancia  => Instancia,
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
         lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        PQ_CR_RATIO_CUOCNSM.sp_resolutor_venc(ln_Pepais,
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
                                              ln_tipocambio,
                                              lc_IndCred,
                                              lc_flgprg,
                                              'S',
                                              lc_Usuario,
                                              ln_Tarea,
                                              ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    begin
      -- deuda externa
      begin
        --MPOSTIGOC 04/10/18 INC1373
        -- actualizamos todos los valores que se tienen para la tarea de Evaluacion/Propuesta
        update JAQZ862 j
           set j.JAQZ862aux3 = ''
         where j.JAQZ862inst = Instancia
           and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
        commit;
      end;
    
      begin
        --MPOSTIGOC 04/10/18 INC1373
        -- actualizamos los ultimos valores que se tienen para la tarea de Evaluacion/Propuesta contabilizados
        -- con una marca en R
        update JAQZ862 j
           set j.JAQZ862aux3 = 'R'
         where j.JAQZ862inst = Instancia
           and j.JAQZ862esta = 'S'
           and j.JAQZ862chek = '1'
           and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
        commit;
      end;
    
      begin
        select sum(j.JAQZ862gfin)
          into saldo_extSoles
          from JAQZ862 j
         where j.JAQZ862inst = Instancia
           and j.JAQZ862esta = 'S'
           and j.JAQZ862chek = '1'
           and j.jaqz862cent <> '00104'
           and j.JAQZ862tcre in
               ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
           and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
           and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
      exception
        when others then
          saldo_extSoles := 0;
      end;
    
      begin
        begin
          select sum(j.JAQZ862gfin)
            into saldo_extDol
            from JAQZ862 j
           where j.JAQZ862inst = Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.jaqz862cent <> '00104'
             and j.JAQZ862tcre in
                 ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
             and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
             and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
        exception
          when others then
            saldo_extDol := 0;
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
           and a.sng026cod = 27;
      exception
        when others then
          null;
      end;
    
      begin
        select a.sng023mto
          into mntdolar
          from sng023 a
         where a.sng021eval = evaluacion
           and a.sng026cod = 527;
      exception
        when others then
          null;
      end;
    
      ln_ExcdntMensual := ((mntdolar * tipocambio) + mntsoles);
      ln_ExcdntMensual := nvl(ln_ExcdntMensual, 0);
    
    end;
  
    begin
    
      Divisor := nvl(ln_ExcdntMensual, 0) + nvl(saldo_externo, 0);
    end;
  
    if Divisor <> 0 then
      ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    if lc_TieneRL = 'S' then
      -- MPOSTIGOC 20.09.2020
      ln_RatioConsumo := 550;
    else
      if lc_TieneRL = 'N' then
        ln_RatioConsumo := nvl(ln_captotal1, 0);
      end if;
    end if;
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_LogRatio(ln_Pepais        => ln_Pepais,
                                         ln_Petdoc        => ln_Petdoc,
                                         ln_Pendoc        => ln_Pendoc,
                                         tipocambio       => ln_tipocambio,
                                         Instancia        => Instancia,
                                         pd_fecpro        => pd_fecpro,
                                         ln_captotcaja    => ln_captotcaja,
                                         saldo_externo    => saldo_externo,
                                         ln_ExcdntMensual => ln_ExcdntMensual,
                                         ln_MntCuoCntg    => 0,
                                         ln_MntPotncial   => 0,
                                         ln_RatioConsumo  => ln_RatioConsumo,
                                         lc_indicador     => 'C',
                                         lc_flgprg        => lc_flgprg,
                                         lc_Usuario       => lc_Usuario,
                                         ln_Tarea         => 1);
    end if;
  
  end sp_cuentas_hip;

  --------------------------------------------------------------------------------
  procedure sp_cuentas_normal(ln_Pepais        in number,
                              ln_Petdoc        in number,
                              ln_Pendoc        in char,
                              tipocambio       in number,
                              Instancia        in number,
                              pd_fecpro        in date,
                              lc_prgm          in varchar2,
                              ln_captotcaja    out number,
                              saldo_externo    out number,
                              ln_ExcdntMensual out number,
                              ln_RatioConsumo  out number) is
    ln_capacidad   number(17, 2);
    saldo_extSoles number(17, 2);
    saldo_extDol   number(17, 2);
    ln_cajaext     number(17, 2);
    divisor        number(17, 2);
    lc_FlgLn       varchar2(2);
    lc_fgAdic      varchar2(1); --mod 2016.04.12
    lc_fgAmpl      varchar2(1); --mod 2016.04.12
    lc_ven         char(1); --mod 2016.04.12
    ln_indicador   number(10); --mod 2016.04.12
  
    lc_fgRefLin  varchar2(1); -- 28/06/16 mpostigoc
    ln_captotal1 number(17, 6); -- 18/07/2017 MPOSTIGOC  Cambio de longitud de Variable
    evaluacion   number(10);
    mntsoles     number(17, 2);
    mntdolar     number(17, 2);
    lc_flgprg    varchar2(2);
  
    lc_TieneRL  varchar(5) := 'N';
    lc_IsInsert varchar(5) := 'N';
  
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
                  and modulo not in (29, 33, 200))) --mpostigoc 04/10/18 INC1373
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
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200))) --mpostigoc 04/10/18 INC1373
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
                  and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             d10.Aomod = 117)
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
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             b.Aomod = 117) --Agregar guia de proceso para excluir modulos
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
             (select f.modulo
                 from fst111 f
                where f.dscod = 50
                  and modulo not in (29, 33, 200)) or x.xwfmodulo = 117) --mpostigoc 04/10/18 INC1373
            
         and x.XWFPRCINS in
             (select wf.wfinsprcid
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
                  and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             x.xwfmodulo = 117)
            
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in
             (select wf.wfinsprcid
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
  
    lc_IndCred     varchar2(10);
    lc_Usuario     varchar2(10);
    ln_captotcaja1 number;
    ln_captotcaja2 number;
    ln_Tarea       number;
    ln_tipocambio  number;
    ln_periodo     number;
    lc_EjecRatio   varchar2(2) := 'N';
  
  begin
  
    ln_captotcaja := 0;
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod)
        into lc_Usuario
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      -- 24/01/19 Verifica si el ratio 
      select 'S'
        into lc_EjecRatio
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.TP1CORR2 = 50
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    begin
    
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 200
         and a.tp1corr2 = 2
         and a.tp1corr3 = 1
         and a.tp1nro1 = 1
         and trim(a.tp1desc) = trim(lc_prgm);
    exception
      when others then
        lc_flgprg := 'N';
      
    end;
  
    if lc_prgm = 'RJAQY843' then
      -- 07/09/2017 MPOSTIGOC
    
      lc_flgprg := 'R';
    
      begin
        delete JAQZ822 J
         WHERE J.JAQZ822INST = Instancia
           and j.JAQZ822est = 'R';
      end;
      begin
        delete JAQZ821 J
         WHERE J.JAQZ821INST = Instancia
           and j.JAQZ821est = 'R';
      end;
    
    end if;
  
    if lc_flgprg = 'S' and lc_EjecRatio = 'S' then
      -- 04/09/2017 mpostigoc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
      begin
        UPDATE JAQZ822 j
           set JAQZ822est = 'I'
         where j.JAQZ822inst = Instancia
           and j.JAQZ822est = 'H';
        commit;
      end;
    
    end if;
  
    --lc_flgprg := 'X';
  
    ln_tipocambio := tipocambio;
  
    if ln_tipocambio is null or ln_tipocambio <= 0 then
    
      begin
        select s. sng120tcbi
          into ln_tipocambio
          from sng120 s
         where s.sng120ins = Instancia
           and s.sng120tsk = 'EVALUACION';
      exception
        when others then
          ln_tipocambio := 0;
      end;
    
    end if;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
      --  if i.ln_mod10 = 117 then
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                          i.ln_tope10,
                                          lc_fgAdic);
    
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         ln_tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         'S',
                                         lc_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
      end if;
    
    end loop;
  
    for i in inserta_vencidos loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      --  if i.ln_mod10 = 117 then
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                          i.ln_tope10,
                                          lc_fgAdic);
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         ln_tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         'S',
                                         lc_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        --ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
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
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(c.ln_mod10,
                                          c.ln_tope10,
                                          lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         ln_tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         'S',
                                         lc_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
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
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(j.ln_mod10,
                                          j.ln_tope10,
                                          lc_fgAdic);
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(J.ln_pgcod10,
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
        --mpostigoc 22.06.23
        Pq_Cr_Ratio_Cuocnsm.sp_cr_VerfLVInsertada(ln_instancia  => Instancia,
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
         lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        PQ_CR_RATIO_CUOCNSM.sp_resolutor_venc(ln_Pepais,
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
                                              ln_tipocambio,
                                              lc_IndCred,
                                              lc_flgprg,
                                              'S',
                                              lc_Usuario,
                                              ln_Tarea,
                                              ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    if lc_prgm = 'RJAQY843' then
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja1
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'R'
           and (j.jaqz822mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 200
                    and a.tp1corr2 = 1
                    and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118                   
           and j.jaqz822nrcuo > 1
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja2
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'R'
           and j.jaqz822mod = 117
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    else
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja1
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'H'
           and (j.jaqz822mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 200
                    and a.tp1corr2 = 1
                    and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118 
           and j.jaqz822nrcuo > 1
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja2
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'H'
           and j.jaqz822mod = 117
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    end if;
    begin
      -- deuda externa
      begin
        --MPOSTIGOC 04/10/18 INC1373
        -- actualizamos todos los valores que se tienen para la tarea de Evaluacion/Propuesta
        update JAQZ862 j
           set j.JAQZ862aux3 = ''
         where j.JAQZ862inst = Instancia
           and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
        commit;
      end;
    
      begin
        --MPOSTIGOC 04/10/18 INC1373
        -- actualizamos los ultimos valores que se tienen para la tarea de Evaluacion/Propuesta contabilizados
        -- con una marca en R
        update JAQZ862 j
           set j.JAQZ862aux3 = 'R'
         where j.JAQZ862inst = Instancia
           and j.JAQZ862esta = 'S'
           and j.JAQZ862chek = '1'
           and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
        commit;
      end;
    
      begin
        select sum(j.JAQZ862gfin)
          into saldo_extSoles
          from JAQZ862 j
         where j.JAQZ862inst = Instancia
           and j.JAQZ862esta = 'S'
           and j.JAQZ862chek = '1'
           and j.jaqz862cent <> '00104'
           and j.JAQZ862tcre in
               ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
           and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
           and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
      exception
        when others then
          saldo_extSoles := 0;
      end;
    
      begin
        begin
          select sum(j.JAQZ862gfin)
            into saldo_extDol
            from JAQZ862 j
           where j.JAQZ862inst = Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.jaqz862cent <> '00104'
             and j.JAQZ862tcre in
                 ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
             and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
             and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
        exception
          when others then
            saldo_extDol := 0;
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
           and a.sng026cod = 27;
      exception
        when others then
          null;
      end;
    
      begin
        select a.sng023mto
          into mntdolar
          from sng023 a
         where a.sng021eval = evaluacion
           and a.sng026cod = 527;
      exception
        when others then
          null;
      end;
    
      ln_ExcdntMensual := ((mntdolar * tipocambio) + mntsoles);
      ln_ExcdntMensual := nvl(ln_ExcdntMensual, 0);
    
    end;
  
    begin
    
      Divisor := nvl(ln_ExcdntMensual, 0) + nvl(saldo_externo, 0);
    end;
  
    if Divisor <> 0 then
      ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    if lc_TieneRL = 'S' then
      -- MPOSTIGOC 20.09.2020
      ln_RatioConsumo := 550;
    else
      if lc_TieneRL = 'N' then
        ln_RatioConsumo := nvl(ln_captotal1, 0);
      end if;
    end if;
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_LogRatio(ln_Pepais        => ln_Pepais,
                                         ln_Petdoc        => ln_Petdoc,
                                         ln_Pendoc        => ln_Pendoc,
                                         tipocambio       => ln_tipocambio,
                                         Instancia        => Instancia,
                                         pd_fecpro        => pd_fecpro,
                                         ln_captotcaja    => ln_captotcaja,
                                         saldo_externo    => saldo_externo,
                                         ln_ExcdntMensual => ln_ExcdntMensual,
                                         ln_MntCuoCntg    => 0,
                                         ln_MntPotncial   => 0,
                                         ln_RatioConsumo  => ln_RatioConsumo,
                                         lc_indicador     => 'C',
                                         lc_flgprg        => lc_flgprg,
                                         lc_Usuario       => lc_Usuario,
                                         ln_Tarea         => 1);
    end if;
  
  end sp_cuentas_normal;
  ---------------------------------------------------------------------------------
  procedure sp_CalculoRatio(ln_Pepais        in number,
                            ln_Petdoc        in number,
                            ln_Pendoc        in char,
                            tipocambio       in number,
                            Instancia        in number,
                            pd_fecpro        in date,
                            lc_prgm          in varchar2,
                            ln_Usuario       in varchar2,
                            ln_captotcaja    out number,
                            saldo_externo    out number,
                            ln_ExcdntMensual out number,
                            ln_RatioConsumo  out number) is
  
    ln_capacidad   number(17, 2);
    saldo_extSoles number(17, 2);
    saldo_extDol   number(17, 2);
    ln_cajaext     number(17, 2);
    divisor        number(17, 2);
    lc_FlgLn       varchar2(2);
    lc_fgAdic      varchar2(1); --mod 2016.04.12
    lc_fgAmpl      varchar2(1); --mod 2016.04.12
    lc_ven         char(1); --mod 2016.04.12
    ln_indicador   number(10); --mod 2016.04.12
  
    lc_fgRefLin varchar2(1); -- 28/06/16 mpostigoc
    --ResultNeto1  number(10, 2);
    ln_captotal1 number(17, 6); -- 18/07/2017 MPOSTIGOC  Cambio de longitud de Variable
    evaluacion   number(10);
    mntsoles     number(17, 2);
    mntdolar     number(17, 2);
    lc_flgprg    varchar2(2);
    lc_TieneRL   varchar2(5) := 'N';
    lc_IsInsert  varchar2(5) := 'N';
  
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
                  and modulo not in (29, 33, 200))) --mpostigoc 04/10/18 INC1373
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
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200))) --mpostigoc 04/10/18 INC1373
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
                  and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             d10.Aomod = 117)
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
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             b.Aomod = 117) --Agregar guia de proceso para excluir modulos
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
             (select f.modulo
                 from fst111 f
                where f.dscod = 50
                  and modulo not in (29, 33, 200)) or x.xwfmodulo = 117) --mpostigoc 04/10/18 INC1373
            
         and x.XWFPRCINS in
             (select wf.wfinsprcid
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
                  and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             x.xwfmodulo = 117)
            
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in
             (select wf.wfinsprcid
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
         and b.aomod not in (select tp1nro1
                               from fst198 a
                              where a.tp1cod = 1
                                and a.tp1cod1 = 10899
                                and a.tp1corr1 = 200
                                and a.tp1corr2 = 1
                                and a.tp1corr3 > 0)
            -- and b.aostat <> 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred         varchar2(10);
    ln_captotcaja1     number;
    ln_captotcaja2     number;
    ln_Tarea           number;
    lc_EjecRatio       varchar2(5) := 'N';
    ln_MntCuoCntg      number;
    ln_MntCuoCntgCF    number;
    ln_MntCuoCntgAval  number;
    ln_MntPotncial     number;
    ln_periodo         number;
    ln_MntPotncialCMAC number;
  
  begin
  
    ln_captotcaja := 0;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      -- 24/01/19 Verifica si el ratio 
      select 'S'
        into lc_EjecRatio
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.TP1CORR2 = 50
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    begin
    
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 200
         and a.tp1corr2 = 2
         and a.tp1corr3 = 1
         and a.tp1nro1 = 1
         and trim(a.tp1desc) = trim(lc_prgm);
    exception
      when others then
        lc_flgprg := 'N';
      
    end;
  
    if lc_prgm = 'RJAQY843' then
      -- 07/09/2017 MPOSTIGOC
    
      lc_flgprg := 'R';
    
      begin
        delete JAQZ822 J
         WHERE J.JAQZ822INST = Instancia
           and j.JAQZ822est = 'R';
      end;
      begin
        delete JAQZ821 J
         WHERE J.JAQZ821INST = Instancia
           and j.JAQZ821est = 'R';
      end;
    
    end if;
  
    if lc_flgprg = 'S' and lc_EjecRatio = 'S' then
      -- 04/09/2017 mpostigoc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
      begin
        UPDATE JAQZ822 j
           set JAQZ822est = 'I'
         where j.JAQZ822inst = Instancia
           and j.JAQZ822est = 'H'
           and j.jaqz822tarea = ln_Tarea;
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
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                          i.ln_tope10,
                                          lc_fgAdic);
    
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         lc_EjecRatio,
                                         ln_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
      end if;
    
    end loop;
  
    for i in inserta_vencidos loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      --  if i.ln_mod10 = 117 then
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                          i.ln_tope10,
                                          lc_fgAdic);
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         lc_EjecRatio,
                                         ln_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        --ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
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
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(c.ln_mod10,
                                          c.ln_tope10,
                                          lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         lc_EjecRatio,
                                         ln_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
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
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(j.ln_mod10,
                                          j.ln_tope10,
                                          lc_fgAdic);
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(J.ln_pgcod10,
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
        --mpostigoc 22.06.23
        Pq_Cr_Ratio_Cuocnsm.sp_cr_VerfLVInsertada(ln_instancia  => Instancia,
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
         lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        PQ_CR_RATIO_CUOCNSM.sp_resolutor_venc(ln_Pepais,
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
                                              lc_EjecRatio,
                                              ln_Usuario,
                                              ln_tarea,
                                              ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    if lc_prgm = 'RJAQY843' then
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja1
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'R'
           and (j.jaqz822mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 200
                    and a.tp1corr2 = 1
                    and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118                   
           and j.jaqz822nrcuo > 1
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd')
           and j.jaqz822tarea = ln_tarea; --mpostigoc 26.09.2020
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja2
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'R'
           and j.jaqz822mod = 117
           and j.jaqz822indic in
               ( /*'CredVigent', 'CredVencid',*/ 'CredVuelo', 'LineaVencd')
           and j.jaqz822tarea = ln_tarea; --mpostigoc 26.09.2020
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    else
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja1
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'H'
           and (j.jaqz822mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 200
                    and a.tp1corr2 = 1
                    and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118 
           and j.jaqz822nrcuo > 1
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd')
           and j.jaqz822tarea = ln_tarea; --mpostigoc 26.09.2020;
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja2
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'H'
           and j.jaqz822mod = 117
           and j.jaqz822indic in
               ( /*'CredVigent', 'CredVencid',*/ 'CredVuelo', 'LineaVencd')
           and j.jaqz822tarea = ln_tarea; --mpostigoc 26.09.2020;
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    end if;
  
    begin
      -- Cuota Contingente PRY1574 
      PQ_CR_RATIO_CUOCNSM.sp_cr_CuotaContinCF(Instancia,
                                              pd_fecpro,
                                              lc_flgprg,
                                              ln_MntCuoCntgCF);
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_CuotaContinAval(Instancia,
                                                pd_fecpro,
                                                lc_flgprg,
                                                ln_MntCuoCntgAval);
    
      ln_MntCuoCntg := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
    end;
  
    /* begin
      -- Cuota Potencial PRY1574
      PQ_CR_RATIO_CUOCNSM.sp_cR_CuotaPotencial(Instancia, ln_MntPotncial);
    end;*/
  
    -- 09/07/2019 mpostigoc
    begin
      pq_cr_resolutor_cappago.sp_cr_CuotaPotencialII(Instancia,
                                                     pd_fecpro,
                                                     ln_Usuario,
                                                     ln_MntPotncial);
    
    end;
  
    if ln_MntPotncial = 9999 then
      -- 07/03/2019 mpostigoc
      ln_RatioConsumo := 9999;
    
    else
      begin
        -- deuda externa
        begin
          --MPOSTIGOC 04/10/18 INC1373
          -- actualizamos todos los valores que se tienen para la tarea de Evaluacion/Propuesta
          update JAQZ862 j
             set j.JAQZ862aux3 = ''
           where j.JAQZ862inst = Instancia
             and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
          commit;
        end;
      
        begin
          --MPOSTIGOC 04/10/18 INC1373
          -- actualizamos los ultimos valores que se tienen para la tarea de Evaluacion/Propuesta contabilizados
          -- con una marca en R
          update JAQZ862 j
             set j.JAQZ862aux3 = 'R'
           where j.JAQZ862inst = Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
          commit;
        end;
      
        begin
          select sum(j.JAQZ862gfin)
            into saldo_extSoles
            from JAQZ862 j
           where j.JAQZ862inst = Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.jaqz862cent <> '00104'
             and j.JAQZ862tcre in
                 ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
             and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
             and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
        exception
          when others then
            saldo_extSoles := 0;
        end;
      
        begin
          begin
            select sum(j.JAQZ862gfin)
              into saldo_extDol
              from JAQZ862 j
             where j.JAQZ862inst = Instancia
               and j.JAQZ862esta = 'S'
               and j.JAQZ862chek = '1'
               and j.jaqz862cent <> '00104'
               and j.JAQZ862tcre in
                   ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
               and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
               and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
          exception
            when others then
              saldo_extDol := 0;
          end;
        
          saldo_extDol := nvl(saldo_extDol, 0) * tipocambio;
        
        end;
      
        saldo_externo := nvl(saldo_extDol, 0) + nvl(saldo_extSoles, 0);
      end;
    
      -- saldo_externo := nvl(saldo_externo, 0) - nvl(ln_MntPotncial, 0); --mpostigoc 03.07.21
    
      begin
        -- Suma de Deuda Caja y Deuda Externa
      
        ln_cajaext := nvl(ln_captotcaja, 0) + nvl(saldo_externo, 0) +
                      nvl(ln_MntCuoCntg, 0) + nvl(ln_MntPotncial, 0);
      end;
    
      begin
        --- Excedente Mensual
      
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
             and a.sng026cod = 27;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into mntdolar
            from sng023 a
           where a.sng021eval = evaluacion
             and a.sng026cod = 527;
        exception
          when others then
            null;
        end;
      
        ln_ExcdntMensual := ((mntdolar * tipocambio) + mntsoles);
        ln_ExcdntMensual := nvl(ln_ExcdntMensual, 0);
      
      end;
    
      begin
      
        Divisor := nvl(ln_ExcdntMensual, 0) + nvl(saldo_externo, 0) +
                   nvl(ln_MntPotncial, 0);
      end;
    
      if Divisor <> 0 then
      
        begin
          ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6);
        exception
          when others then
            ln_captotal1 := 0;
        end;
      
      else
        ln_captotal1 := 0;
      end if;
    
      if lc_TieneRL = 'S' then
        -- MPOSTIGOC 20.09.2020
        ln_RatioConsumo := 550;
      else
        if lc_TieneRL = 'N' then
          ln_RatioConsumo := nvl(ln_captotal1, 0);
        end if;
      end if;
    
    end if; -- 07/03/2019 mpostigoc
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_LogRatio(ln_Pepais        => ln_Pepais,
                                         ln_Petdoc        => ln_Petdoc,
                                         ln_Pendoc        => ln_Pendoc,
                                         tipocambio       => tipocambio,
                                         Instancia        => Instancia,
                                         pd_fecpro        => pd_fecpro,
                                         ln_captotcaja    => ln_captotcaja,
                                         saldo_externo    => saldo_externo,
                                         ln_ExcdntMensual => ln_ExcdntMensual,
                                         ln_MntCuoCntg    => ln_MntCuoCntg,
                                         ln_MntPotncial   => ln_MntPotncial,
                                         ln_RatioConsumo  => ln_RatioConsumo,
                                         lc_indicador     => 'CS',
                                         lc_flgprg        => lc_flgprg,
                                         lc_Usuario       => ln_Usuario,
                                         ln_Tarea         => ln_Tarea);
    end if;
  
  end sp_CalculoRatio;
  ----------------------------------------------------------------------------------
  procedure sp_cuentas_convenio(ln_Pepais        in number,
                                ln_Petdoc        in number,
                                ln_Pendoc        in char,
                                tipocambio       in number,
                                Instancia        in number,
                                pd_fecpro        in date,
                                lc_prgm          in varchar2,
                                ln_captotcaja    out number,
                                saldo_externo    out number,
                                ln_ExcdntMensual out number,
                                ln_RatioConsumo  out number) is
    ln_capacidad   number(17, 2);
    saldo_extSoles number(17, 2);
    saldo_extDol   number(17, 2);
    ln_cajaext     number(17, 2);
    divisor        number(17, 2);
    lc_FlgLn       varchar2(2);
    lc_fgAdic      varchar2(1); --mod 2016.04.12
    lc_fgAmpl      varchar2(1); --mod 2016.04.12
    lc_ven         char(1); --mod 2016.04.12
    ln_indicador   number(10); --mod 2016.04.12
  
    lc_fgRefLin varchar2(1); -- 28/06/16 mpostigoc
    --ResultNeto1  number(10, 2);
    ln_captotal1      number(17, 6); -- 18/07/2017 MPOSTIGOC  Cambio de longitud de Variable
    evaluacion        number(10);
    mntsoles          number(17, 2);
    mntdolar          number(17, 2);
    lc_flgprg         varchar2(2);
    ln_captotcaja1    number;
    ln_captotcaja2    number;
    ln_MntCuoCntg     number;
    ln_MntCuoCntgCF   number;
    ln_MntCuoCntgAval number;
    ln_MntPotncial    number;
    ln_periodo        number := 0;
    lc_TieneRL        varchar2(5) := 'N';
    lc_IsInsert       varchar2(5) := 'N';
  
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
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 200
                                        and a.tp1corr2 = 1
                                        and a.tp1corr3 > 0))))
         and d10.Aostat <> 99
         and d10.aofvto < pd_fecpro;
  
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
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 200
                                        and a.tp1corr2 = 1
                                        and a.tp1corr3 > 0))) or
             d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro;
  
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
                                and Ttcod = 1
                                and Cttfir = 'T')
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 200
                                        and a.tp1corr2 = 1
                                        and a.tp1corr3 > 0))) or
             x.xwfmodulo = 117)
            
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
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro;
  
    lc_IndCred   varchar2(10);
    lc_Usuario   varchar2(10);
    ln_Tarea     number;
    lc_EjecRatio varchar2(2);
  
  begin
  
    ln_captotcaja := 0;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod), w.wftaskcod
        into lc_Usuario, ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      -- 24/01/19 Verifica si el ratio 
      select 'S'
        into lc_EjecRatio
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.TP1CORR2 = 50
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    begin
    
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 200
         and a.tp1corr2 = 2
         and a.tp1corr3 = 1
         and a.tp1nro1 = 1
         and trim(a.tp1desc) = trim(lc_prgm);
    exception
      when others then
        lc_flgprg := 'N';
      
    end;
  
    if lc_prgm = 'RJAQY843' then
      -- 07/09/2017 MPOSTIGOC
    
      lc_flgprg := 'R';
    
      begin
        delete JAQZ822 J
         WHERE J.JAQZ822INST = Instancia
           and j.JAQZ822est = 'R';
      end;
      begin
        delete JAQZ821 J
         WHERE J.JAQZ821INST = Instancia
           and j.JAQZ821est = 'R';
      end;
    
    end if;
  
    if lc_flgprg = 'S' then
      -- 04/09/2017 mpostigoc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
      begin
        UPDATE JAQZ822 j
           set JAQZ822est = 'I'
         where j.JAQZ822inst = Instancia
           and j.JAQZ822est = 'H';
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
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                          i.ln_tope10,
                                          lc_fgAdic);
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         lc_EjecRatio,
                                         lc_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
      end if;
    
    end loop;
  
    for i in inserta_vencidos loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      --  if i.ln_mod10 = 117 then
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                          i.ln_tope10,
                                          lc_fgAdic);
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          lc_fgAmpl);
    
      if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and
         i.ln_tope10 <> 550 then
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         lc_EjecRatio,
                                         lc_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        --  ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(c.ln_mod10,
                                          c.ln_tope10,
                                          lc_fgAdic);
    
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
    
      if lc_fgAdic <> 'S' then
      
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
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
                                         lc_EjecRatio, --MPOSTIGOC 08/08/2019 se cambio el orden
                                         lc_Usuario, --MPOSTIGOC 08/08/2019 se cambio el orden
                                         ln_Tarea,
                                         ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
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
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(j.ln_mod10,
                                          j.ln_tope10,
                                          lc_fgAdic);
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(J.ln_pgcod10,
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
        --mpostigoc 22.06.23
        Pq_Cr_Ratio_Cuocnsm.sp_cr_VerfLVInsertada(ln_instancia  => Instancia,
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
         lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        PQ_CR_RATIO_CUOCNSM.sp_resolutor_venc(ln_Pepais,
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
                                              lc_EjecRatio,
                                              lc_Usuario,
                                              ln_Tarea,
                                              ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    if lc_prgm = 'RJAQY843' then
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja1
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'R'
           and (j.jaqz822mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 200
                    and a.tp1corr2 = 1
                    and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118                   
           and j.jaqz822nrcuo > 1;
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja2
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'R'
           and j.jaqz822mod = 117;
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    else
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja1
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'H'
           and (j.jaqz822mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 200
                    and a.tp1corr2 = 1
                    and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118 
           and j.jaqz822nrcuo > 1;
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja2
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'H'
           and j.jaqz822mod = 117;
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    end if;
  
    begin
      -- deuda externa
      begin
        --MPOSTIGOC 04/10/18 INC1373
        -- actualizamos todos los valores que se tienen para la tarea de Evaluacion/Propuesta
        update JAQZ862 j
           set j.JAQZ862aux3 = ''
         where j.JAQZ862inst = Instancia
           and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
        commit;
      end;
    
      begin
        --MPOSTIGOC 04/10/18 INC1373
        -- actualizamos los ultimos valores que se tienen para la tarea de Evaluacion/Propuesta contabilizados
        -- con una marca en R
        update JAQZ862 j
           set j.JAQZ862aux3 = 'R'
         where j.JAQZ862inst = Instancia
           and j.JAQZ862esta = 'S'
           and j.JAQZ862chek = '1'
           and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
        commit;
      end;
    
      begin
        select sum(j.JAQZ862gfin)
          into saldo_extSoles
          from JAQZ862 j
         where j.JAQZ862inst = Instancia
           and j.JAQZ862esta = 'S'
           and j.JAQZ862chek = '1'
           and j.jaqz862cent <> '00104'
           and j.JAQZ862tcre in
               ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
           and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
           and j.JAQZ862aux1 = 7; -- Tarea de Evaluacion Propuesta MPOSTIGOC 04/10/18 INC1373
      exception
        when others then
          saldo_extSoles := 0;
      end;
    
      begin
        begin
          select sum(j.JAQZ862gfin)
            into saldo_extDol
            from JAQZ862 j
           where j.JAQZ862inst = Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.jaqz862cent <> '00104'
             and j.JAQZ862tcre in
                 ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
             and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
             and j.JAQZ862aux1 = 7; -- Tarea de Evaluacion Propuesta MPOSTIGOC 04/10/18 INC1373
        exception
          when others then
            saldo_extDol := 0;
        end;
      
        saldo_extDol := nvl(saldo_extDol, 0) * tipocambio;
      
      end;
    
      saldo_externo := nvl(saldo_extDol, 0) + nvl(saldo_extSoles, 0);
    end;
  
    begin
      -- Cuota Contingente PRY1527 
      PQ_CR_RATIO_CUOCNSM.sp_cr_CuotaContinCF(Instancia,
                                              pd_fecpro,
                                              lc_flgprg,
                                              ln_MntCuoCntgCF);
      PQ_CR_RATIO_CUOCNSM.sp_cr_CuotaContinAval(Instancia,
                                                pd_fecpro,
                                                lc_flgprg,
                                                ln_MntCuoCntgAval);
    
      ln_MntCuoCntg := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
    end;
  
    /* begin
      -- Cuota Potencial PRY1527
      PQ_CR_RATIO_CUOCNSM.sp_cR_CuotaPotencial(Instancia, ln_MntPotncial);
    end;*/
  
    begin
      pq_cr_resolutor_cappago.sp_cr_CuotaPotencialII(Instancia,
                                                     pd_fecpro,
                                                     lc_usuario,
                                                     ln_MntPotncial);
      ln_MntPotncial := nvl(ln_MntPotncial, 0);
    end;
  
    -- saldo_externo := nvl(saldo_externo, 0) - nvl(ln_MntPotncial, 0); --mpostigoc 18.08.2021
  
    begin
      -- Suma de Deuda Caja y Deuda Externa
    
      ln_cajaext := nvl(ln_captotcaja, 0) + nvl(saldo_externo, 0) +
                    nvl(ln_MntCuoCntg, 0) + nvl(ln_MntPotncial, 0);
    end;
  
    begin
      --- Excedente Mensual
    
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
           and a.sng026cod = 27;
      exception
        when others then
          null;
      end;
    
      begin
        select a.sng023mto
          into mntdolar
          from sng023 a
         where a.sng021eval = evaluacion
           and a.sng026cod = 527;
      exception
        when others then
          null;
      end;
    
      ln_ExcdntMensual := ((mntdolar * tipocambio) + mntsoles);
      ln_ExcdntMensual := nvl(ln_ExcdntMensual, 0);
    
    end;
  
    begin
    
      Divisor := nvl(ln_ExcdntMensual, 0) + nvl(saldo_externo, 0) +
                 nvl(ln_MntPotncial, 0);
    end;
  
    if Divisor <> 0 then
      ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    if lc_TieneRL = 'S' then
      -- mpostigoc 20.09.2020
      ln_RatioConsumo := 550;
    else
      if lc_TieneRL = 'N' then
      
        ln_RatioConsumo := nvl(ln_captotal1, 0);
      end if;
    end if;
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_LogRatio(ln_Pepais        => ln_Pepais,
                                         ln_Petdoc        => ln_Petdoc,
                                         ln_Pendoc        => ln_Pendoc,
                                         tipocambio       => tipocambio,
                                         Instancia        => Instancia,
                                         pd_fecpro        => pd_fecpro,
                                         ln_captotcaja    => ln_captotcaja,
                                         saldo_externo    => saldo_externo,
                                         ln_ExcdntMensual => ln_ExcdntMensual,
                                         ln_MntCuoCntg    => ln_MntCuoCntg,
                                         ln_MntPotncial   => ln_MntPotncial,
                                         ln_RatioConsumo  => ln_RatioConsumo,
                                         lc_indicador     => 'CV',
                                         lc_flgprg        => lc_flgprg,
                                         lc_Usuario       => lc_Usuario,
                                         ln_Tarea         => ln_Tarea);
    end if;
  
  end sp_cuentas_convenio;
  -------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                pd_fecpro       in date,
                                lc_flgprg       in varchar2,
                                ln_MntCuoCntgCF out number) is
  
    cursor lista_CredVigCF(ln_pais number,
                           ln_tdoc number,
                           lc_ndoc varchar2) is
    
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
    
      select x.xwfempresa   ln_pgcod10,
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
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod), w.wftaskcod
        into lc_Usuario, ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        if lc_flgprg = 'S' or lc_flgprg = 'R' then
          begin
            PQ_CR_RATIO_CUOCNSM.sp_cr_LogCuentas(ln_pais,
                                                 ln_tdoc,
                                                 lc_ndoc,
                                                 ln_tipocambio,
                                                 ln_Instancia,
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
                                                 lc_flgprg,
                                                 lc_Usuario,
                                                 ln_Tarea);
          end;
        end if;
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
      
        if lc_flgprg = 'S' or lc_flgprg = 'R' then
          begin
            PQ_CR_RATIO_CUOCNSM.sp_cr_LogCuentas(ln_pais,
                                                 ln_tdoc,
                                                 lc_ndoc,
                                                 ln_tipocambio,
                                                 ln_Instancia,
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
                                                 lc_flgprg,
                                                 lc_Usuario,
                                                 ln_Tarea);
          end;
        end if;
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
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
    lc_Usuario     varchar2(10);
    -- pd_fecpro      date;
    ln_Tarea     number;
    ln_Modulo    number;
    ln_moneda    number;
    lc_verfamp   varchar2(2) := 'N';
    lc_vrfrefrep varchar2(2) := 'N';
    lc_verfvinc  varchar2(2) := 'N';
  
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
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod), w.wftaskcod
        into lc_Usuario, ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
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
  
    /* begin
      select pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    end;
    */
  
    begin
      select w.xwfmodulo
        into ln_Modulo
        from xwf700 w
       where w.xwfprcins = ln_Instancia
         and w.xwfcar3 = '1';
    exception
      when others then
        ln_Modulo := 0;
    end;
  
    if ln_pais is not null then
    
      for l in lista_CredVigAval(ln_pais, ln_tdoc, lc_ndoc) loop
      
        ln_SaldCap := 0;
      
        pq_cr_ratio_cuocnsm.Sp_ampliados_CK(ln_emp10  => l.ln_pgcod10,
                                            ln_mod10  => l.ln_mod10,
                                            ln_suc10  => l.ln_suc10,
                                            ln_mda10  => l.ln_mda10,
                                            ln_pap10  => l.ln_pap10,
                                            ln_cta10  => l.ln_cta10,
                                            ln_oper10 => l.ln_oper10,
                                            ln_sbop10 => l.ln_sbop10,
                                            ln_tope10 => l.ln_tope10,
                                            Pc_flag   => lc_verfamp);
      
        pq_cr_ratio_cuocnsm.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
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
        
          if (lc_flgprg = 'S' or lc_flgprg = 'R') and ln_saldcap > 0 then
            begin
              PQ_CR_RATIO_CUOCNSM.sp_cr_LogCuentas(ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   ln_tipocambio,
                                                   ln_Instancia,
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
                                                   lc_flgprg,
                                                   lc_Usuario,
                                                   ln_Tarea);
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
           where w.xwfprcins = v.ln_InstanciaAvalada
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
          PQ_CR_RATIO_CUOCNSM.sp_cr_LogCuentas(ln_pais,
                                               ln_tdoc,
                                               lc_ndoc,
                                               ln_tipocambio,
                                               ln_Instancia,
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
                                               lc_flgprg,
                                               lc_Usuario,
                                               ln_Tarea);
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
    if ln_paiscy is not null and ln_Modulo <> 107 then
    
      for l in lista_CredVigAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        pq_cr_ratio_cuocnsm.Sp_ampliados_CK(ln_emp10  => l.ln_pgcod10,
                                            ln_mod10  => l.ln_mod10,
                                            ln_suc10  => l.ln_suc10,
                                            ln_mda10  => l.ln_mda10,
                                            ln_pap10  => l.ln_pap10,
                                            ln_cta10  => l.ln_cta10,
                                            ln_oper10 => l.ln_oper10,
                                            ln_sbop10 => l.ln_sbop10,
                                            ln_tope10 => l.ln_tope10,
                                            Pc_flag   => lc_verfamp);
      
        pq_cr_ratio_cuocnsm.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
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
        
          if (lc_flgprg = 'S' or lc_flgprg = 'R') and ln_SaldCap > 0 then
            begin
              PQ_CR_RATIO_CUOCNSM.sp_cr_LogCuentas(ln_pais,
                                                   ln_tdoc,
                                                   lc_ndoc,
                                                   ln_tipocambio,
                                                   ln_Instancia,
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
                                                   lc_flgprg,
                                                   lc_Usuario,
                                                   ln_Tarea);
            end;
          end if;
        
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
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
        end if; --mpostigoc 08/07/2019
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
          PQ_CR_RATIO_CUOCNSM.sp_cr_LogCuentas(ln_pais,
                                               ln_tdoc,
                                               lc_ndoc,
                                               ln_tipocambio,
                                               ln_Instancia,
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
                                               lc_flgprg,
                                               lc_Usuario,
                                               ln_Tarea);
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    end if;
  
  end sp_cr_CuotaContinAval;
  --------------------------------------------------------------------------------
  /*procedure sp_cR_CuotaPotencial(ln_Instancia   in number,
                                 ln_MntPotncial out number) is
  
    cursor lista_lineas is
      select sum(j.jaqz862tlin) ln_LineaTotal,
             sum(j.jaqz862util) ln_LineaUtilizada
        from jaqz862 j
       where j.jaqz862inst = ln_Instancia
         and j.jaqz862esta = 'S'
         and j.jaqz862chek = '1'
         and j.jaqz862flin in ('L');
  
    ln_LineaUtilizada   number := 0;
    ln_LineaNoUtilizada number := 0;
    ln_LineaTotal       number := 0;
    ln_MntPotncialAux   number := 0;
    ln_PorcUtilz        number := 0;
    ln_FccEscalonado    number := 0;
    ln_LineasConCero    number := 0;
  
  begin
  
    ln_MntPotncial := 0;
  
    begin
      select count(*)
        into ln_LineasConCero
        from jaqz862 j
       where j.jaqz862inst = ln_Instancia
         and j.jaqz862esta = 'S'
         and j.jaqz862chek = '1'
         and j.jaqz862flin in ('L')
         and j.jaqz862tlin = 0;
    exception
      when others then
        ln_LineasConCero := 0;
    end;
  
    if ln_LineasConCero = 0 then
      for l in lista_lineas loop
      
        if l.ln_LineaTotal > 0 then
        
          ln_LineaNoUtilizada := l.ln_LineaTotal - l.ln_LineaUtilizada;
          -- ln_PorcUtilz        := (l.ln_LineaUtilizada * 100) / l.ln_LineaTotal; --> @MPCA MOD 13/02/2019
          ln_PorcUtilz := (l.ln_LineaUtilizada) / l.ln_LineaTotal;
        
          if ln_PorcUtilz < 0.45 then
            ln_FccEscalonado := 0.03;
          else
            if ln_PorcUtilz >= 0.45 and ln_PorcUtilz < 0.65 then
              ln_FccEscalonado := 0.07;
            
            else
              if ln_PorcUtilz >= 0.65 and ln_PorcUtilz < 0.85 then
                ln_FccEscalonado := 0.12;
              
              else
                if ln_PorcUtilz >= 0.85 then
                  ln_FccEscalonado := 0.25;
                
                end if;
              end if;
            end if;
          
          end if;
        
        elsif l.ln_LineaTotal = 0 then
        
          ln_MntPotncial := 9999;
        
        end if;
      
        ln_MntPotncialAux := ln_LineaNoUtilizada * 0.044 * ln_FccEscalonado;
      
        ln_MntPotncial := nvl(ln_MntPotncial, 0) +
                          nvl(ln_MntPotncialAux, 0);
      
      end loop;
    
    else
      if ln_LineasConCero > 0 then
        ln_MntPotncial := 9999;
      end if;
    end if;
  
  end sp_cR_CuotaPotencial;*/

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
         and D601co in ('S', 'X', 'E');
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
      select s01.SNG001Ori
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
                            ln_subop10    in number,
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
          from fsd602
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10
           and ppsbop = ln_subop10
           and pptope = ln_tope10
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
           and f602.ppsbop = ln_subop10
           and f602.pptope = ln_tope10
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
             and ppsbop = ln_subop10
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
                 and ppsbop = ln_subop10
                 and pptope = ln_tope10
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
               and ppoper = ln_oper10
               and ppsbop = ln_subop10
               and pptope = ln_tope10;
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
           and ppsbop = ln_subop10
           and pptope = ln_tope10
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
         and d.d601co in ('X', 'E');
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
  
    ln_plazo      number(10, 2);
    ln_tasa       number(10, 2);
    ln_saldo      number(10, 2);
    instancia     number;
    ln_instancia  number;
    ln_paralelo   number;
    LN_TIPOCRED   number;
    lc_FlagSegmnt varchar2(2);
    lc_FlagGuia   varchar2(1) := 'N';
  
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
          null;
        
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
  
    begin
      select SUM(SNGE01IMPA)
        into ln_paralelo
        from SNGE01
       WHERE SNGE01INST = instancia;
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
                         lc_EjecRatio in varchar2,
                         lc_Usuario   in varchar2,
                         ln_Tarea     in number,
                         ln_capacidad out number) is
  
    ln_nrocuotas  number(17, 2);
    ln_parciales  number(17, 2);
    ln_cuotimp    number(17, 2) := 0;
    ln_seguro     number(17, 2);
    fech_maxcuota date;
    ln_instancia  number;
    --lc_ven        char(1);
    ln_flagFC  varchar2(1) := 'N'; -- 20/12/2016 mpostigoc
    ln_CapFC   number(17, 2);
    CapLinea   number(17, 2);
    ln_cuoparc number(17, 2);
  
  begin
  
    ln_CapFC := 0;
    CapLinea := 0;
  
    PQ_CR_RATIO_CUOCNSM.sp_cuotas(ln_pgcod10,
                                  ln_mod10,
                                  ln_suc10,
                                  ln_mda10,
                                  ln_pap10,
                                  ln_cta10,
                                  ln_oper10,
                                  ln_sbop10,
                                  ln_tope10,
                                  ln_nrocuotas);
  
    PQ_CR_RATIO_CUOCNSM.sp_instancia(ln_mod10,
                                     ln_suc10,
                                     ln_mda10,
                                     ln_pap10,
                                     ln_cta10,
                                     ln_oper10,
                                     ln_sbop10,
                                     ln_tope10,
                                     ln_parciales,
                                     ln_instancia);
  
    PQ_CR_RATIO_CUOCNSM.sp_cr_flujocaja(ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_cuota_impaga(ln_pgcod10,
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
      
        PQ_CR_RATIO_CUOCNSM.sp_cuota_impagavuelo(ln_pgcod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_cr_capacidadFC(ln_mod10,
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
  
    PQ_CR_RATIO_CUOCNSM.sp_seguro(ln_mod10,
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
      PQ_CR_RATIO_CUOCNSM.sp_capacidadlinea(ln_mod10,
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
    
      PQ_CR_RATIO_CUOCNSM.sp_capacidadpagoparc(ln_nrocuotas,
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
    
      PQ_CR_RATIO_CUOCNSM.sp_capacidadpago(ln_cuotimp,
                                           ln_nrocuotas,
                                           ln_parciales,
                                           ln_peri10,
                                           ln_seguro,
                                           ln_mod10,
                                           ln_capacidad);
    end if;
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
    
      if ln_capacidad > 0 then
      
        if ln_CapFC <> 0 then
          ln_cuotimp := 0;
        end if;
      
        PQ_CR_RATIO_CUOCNSM.sp_cr_LogCuentas(ln_Pepais,
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
                                             lc_Usuario,
                                             ln_Tarea);
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
                              tipocambio   in number,
                              lc_IndCred   in varchar2,
                              lc_flgprg    in varchar2,
                              lc_EjecRatio in varchar2,
                              lc_Usuario   in varchar2,
                              ln_Tarea     in number,
                              ln_capacidad out number) is
    ln_nrocuotas number;
    -- ln_parciales  number;
    ln_cuotimp    number(17, 2);
    ln_seguro     number(17, 2);
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
    ln_capTem    number(17, 2);
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
      
        PQ_CR_RATIO_CUOCNSM.sp_cuotas(i.ln_pgcod10,
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
      
        PQ_CR_RATIO_CUOCNSM.sp_cuota_impaga_lin(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                tipocambio,
                                                ln_cuotimp,
                                                fech_maxcuota);
      
        PQ_CR_RATIO_CUOCNSM.sp_seguro(i.ln_mod10,
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
        PQ_CR_RATIO_CUOCNSM.sp_capacidadpago_lin(ln_cuotimp,
                                                 ln_nrocuotas,
                                                 ln_pr116,
                                                 ln_seguro,
                                                 i.ln_mod10,
                                                 ln_capTem);
        PQ_CR_RATIO_CUOCNSM.sp_instancia(i.ln_mod10,
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
        
          PQ_CR_RATIO_CUOCNSM.sp_cr_LogCuentas(ln_Pepais,
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
                                               lc_Usuario,
                                               ln_Tarea);
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
    ln_MaxFchTx     date;
  
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
    
      if ln_mod10 <> 116 then
      
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
        begin
          select max(f.d602fc)
            into ln_MaxFchTx
            from fsd602 f
           where f.pgcod = 1
             and f.ppmod = ln_mod10
             and f.ppsuc = ln_suc10
             and f.ppmda = ln_mda10
             and f.pppap = ln_pap10
             and f.ppcta = ln_cta10
             and f.ppoper = ln_oper10
             and f.ppsbop = ln_sbop10
             and f.pptope = ln_tope10
             and f.d602mo = 116
             and f.d602tr in (50, 60);
        exception
          when others then
            null;
        end;
      
        if ln_MaxFchTx is not null then
        
          begin
            select max(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 +
                       s.ppimp13 + s.ppimp14 + s.ppimp15) -
                   min(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 +
                       s.ppimp13 + s.ppimp14 + s.ppimp15)
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
               and f.ppfpag > ln_MaxFchTx
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
              ln_fc := 0;
          end;
        
        else
        
          begin
            select max(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 +
                       s.ppimp13 + s.ppimp14 + s.ppimp15) -
                   min(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 +
                       s.ppimp13 + s.ppimp14 + s.ppimp15)
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
              ln_fc := 0;
          end;
        
        end if;
      end if;
    
    else
      if lc_tienecalen = 'S' and lc_tieneseguros = 'N' then
        --05/07/2017 mpostigoc
      
        if ln_mod10 <> 116 then
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
        
        else
          begin
            select max(f.d602fc)
              into ln_MaxFchTx
              from fsd602 f
             where f.pgcod = 1
               and f.ppmod = ln_mod10
               and f.ppsuc = ln_suc10
               and f.ppmda = ln_mda10
               and f.pppap = ln_pap10
               and f.ppcta = ln_cta10
               and f.ppoper = ln_oper10
               and f.ppsbop = ln_sbop10
               and f.pptope = ln_tope10
               and f.d602mo = 116
               and f.d602tr in (50, 60);
          exception
            when others then
              null;
          end;
        
          if ln_MaxFchTx is not null then
          
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
                 and f.pptope = ln_tope10
                 and f.ppfpag > ln_MaxFchTx;
            exception
              when others then
                ln_fc := 0;
            end;
          
          else
          
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
                ln_fc := 0;
            end;
          
          end if;
        end if;
      
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
  
    ln_plazo  number := 0;
    ln_tasa   number(17, 6) := 0.00;
    ln_saldo  number(17, 2) := 0.00;
    instancia number;
    --ln_periodo number;
    ln_cuotas          number := 0;
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
        
          if ln_mod10 <> 116 then
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
          
          end if;
        
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

  procedure sp_cr_LogRatio(ln_Pepais        in number,
                           ln_Petdoc        in number,
                           ln_Pendoc        in char,
                           tipocambio       in number,
                           Instancia        in number,
                           pd_fecpro        in date,
                           ln_captotcaja    in number,
                           saldo_externo    in number,
                           ln_ExcdntMensual in number,
                           ln_MntCuoCntg    in number,
                           ln_MntPotncial   in number,
                           ln_RatioConsumo  in number,
                           lc_indicador     in varchar2,
                           lc_flgprg        in varchar2,
                           lc_Usuario       in varchar2,
                           ln_Tarea         in number) is
  
    ln_corr    number;
    lc_IndEst  varchar2(2);
    lc_hora    character(8);
    ln_correrr number;
    lc_cod     varchar2(50);
    lc_msg     varchar2(1500);
  
  begin
  
    begin
    
      select max(j.JAQZ821corr)
        into ln_corr
        from JAQZ821 j
       where j.JAQZ821fec = pd_fecpro
         and j.jaqz821inst = Instancia;
    exception
      when others then
        null;
    end;
  
    begin
    
      select max(j.jaqy140errcorr)
        into ln_correrr
        from jaqy140err j
       where j.jaqy140errfec = pd_fecpro
         and j.jaqy140errinst = Instancia;
    exception
      when others then
        null;
    end;
  
    ln_corr    := nvl(ln_corr, 0);
    ln_correrr := nvl(ln_correrr, 0); -- 01/08/2019 mpostigoc
  
    if lc_flgprg = 'S' then
    
      lc_IndEst := 'H';
    
      begin
        update JAQZ821 j
           set j.JAQZ821est = 'I'
         where j.JAQZ821inst = Instancia
           and j.JAQZ821est = 'H'
           and j.jaqz821tarea = ln_Tarea;
        commit;
      end;
    
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
      insert into JAQZ821
        (JAQZ821corr,
         JAQZ821pais,
         JAQZ821tdoc,
         JAQZ821ndoc,
         JAQZ821tcamb,
         JAQZ821inst,
         JAQZ821fec,
         JAQZ821hora,
         JAQZ821capcaja,
         JAQZ821sldext,
         JAQZ821EXDMENS,
         JAQZ821ratio,
         JAQZ821ind,
         JAQZ821EST,
         jaqz821user,
         jaqz821CCONTG,
         jaqz821cpoten,
         jaqz821tarea)
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
         ln_ExcdntMensual,
         ln_RatioConsumo,
         lc_indicador,
         lc_IndEst,
         lc_Usuario,
         ln_MntCuoCntg,
         ln_MntPotncial,
         ln_Tarea);
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
             Instancia,
             pd_fecpro,
             lc_hora,
             ln_captotcaja,
             saldo_externo,
             ln_ExcdntMensual,
             ln_RatioConsumo,
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
                             lc_Usuario   in varchar2,
                             ln_Tarea     in number) is
  
    ln_corr number;
    --lc_exist varchar2(2) := 'N';
    lc_hora   character(8);
    lc_IndEst varchar2(2);
  
  begin
  
    begin
    
      select max(j.JAQZ822corr)
        into ln_corr
        from JAQZ822 j
       where j.JAQZ822fec = pd_fecpro
         and j.jaqz822inst = Instancia;
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
      
      end if;
    end if;
  
    -- if lc_exist = 'N' then
  
    begin
      insert into JAQZ822
        (JAQZ822corr,
         JAQZ822fec,
         JAQZ822hora,
         JAQZ822pais,
         JAQZ822tdoc,
         JAQZ822ndoc,
         JAQZ822tcamb,
         JAQZ822inst,
         JAQZ822pgcod,
         JAQZ822mod,
         JAQZ822suc,
         JAQZ822mda,
         JAQZ822pap,
         JAQZ822cta,
         JAQZ822ope,
         JAQZ822sbop,
         JAQZ822tope,
         JAQZ822PERIO,
         JAQZ822NRCUO,
         JAQZ822TSOLI,
         JAQZ822FLCJ,
         JAQZ822CUOIMP,
         JAQZ822SEGURO,
         JAQZ822CAPFC,
         JAQZ822CAPLIN,
         JAQZ822capcuo,
         JAQZ822INDIC,
         JAQZ822est,
         jaqz822user,
         jaqz822tarea)
      
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
         lc_Usuario,
         ln_Tarea);
    
      commit;
    
    end;
  
  end sp_cr_LogCuentas;
  -------------------------------------------------------------
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
  
    if lc_Estado = 'S' then
    
      lc_IndEst := 'H';
    
    else
      if lc_Estado = 'R' then
      
        lc_IndEst := 'R';
      
      end if;
    end if;
  
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
          from jaqz822 j
         where j.jaqz822inst = ln_instancia
           and j.jaqz822pgcod = ln_pgcod116
           and j.jaqz822mod = ln_mod116
           and j.jaqz822suc = ln_suc116
           and j.jaqz822mda = ln_mda116
           and j.jaqz822pap = ln_pap116
           and j.jaqz822cta = ln_cta116
           and j.jaqz822ope = ln_ope116
           and j.jaqz822sbop = ln_sbop116
           and j.jaqz822tope = ln_tope116
           and j.jaqz822est = lc_IndEst;
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

end PQ_CR_RATIO_CUOCNSM;
/

