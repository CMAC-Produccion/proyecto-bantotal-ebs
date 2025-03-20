create or replace package pq_cr_reporte_caplineas is

  -- Author  : MPOSTIGOC
  -- Created : 13/01/2016 04:46:54 p.m.
  -- Purpose :
  -- Modificado : 2017.03.28 DCASTRO se modifico sp_refinanLinea
  -- Modificado : 18/07/2017 MPOSTIGOC  Cambio de longitud de Variable ln_captotal1

  procedure sp_cuentas(ln_Pepais  in number,
                       ln_Petdoc  in number,
                       ln_Pendoc  in char,
                       tipocambio in number,
                       Instancia  in number,
                       pd_fecpro  in date,
                       lc_prgm    in varchar2,
                       
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
                           lc_flgprg     in varchar2);

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
                             lc_flgprg    in varchar2);

end pq_cr_reporte_caplineas;
/

create or replace package body pq_cr_reporte_caplineas is

  ------- RESOLUTOR CUOTA RESULTADO EN CAJA AQP Y DEUDA FINANCIERA EXTERNA

  procedure sp_cuentas(ln_Pepais  in number,
                       ln_Petdoc  in number,
                       ln_Pendoc  in char,
                       tipocambio in number,
                       Instancia  in number,
                       pd_fecpro  in date,
                       lc_prgm    in varchar2,
                       
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
  
    lc_flgprg varchar2(2);
  
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
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc
                       /*and Ttcod = 1
                       and Cttfir = 'T'*/
                       )
         and (Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod1 = 10899
                                        and tp1corr1 = 13
                                        and tp1corr2 = 1))))
         and Aostat <> 99
         and aofvto < pd_fecpro --mpostigoc  14/12/16
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
                                      where a.tp1cod1 = 10899
                                        and tp1corr1 = 13
                                        and tp1corr2 = 1)))) --Agregar guia de proceso para excluir modulos
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
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc
                       /*and Ttcod = 1
                       and Cttfir = 'T'*/
                       )
         and (Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod1 = 10899
                                        and tp1corr1 = 13
                                        and tp1corr2 = 1))) or Aomod = 117)
         and Aostat <> 99
         and aofvto >= pd_fecpro --mpostigoc  14/12/16
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
                                      where a.tp1cod1 = 10899
                                        and tp1corr1 = 13
                                        and tp1corr2 = 1))) or
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
       where xwfcuenta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
            
         and (xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod1 = 10899
                                        and tp1corr1 = 13
                                        and tp1corr2 = 1))) or
             xwfmodulo = 117)
            
         and XWFPRCINS in
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
         and sng120ins = XWFPRCINS
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
         and (xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod1 = 10899
                                        and tp1corr1 = 13
                                        and tp1corr2 = 1))) or
             xwfmodulo = 117)
            
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and XWFPRCINS in
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
         and sng120ins = XWFPRCINS
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
         and b.aomod not in (select tp1nro1
                               from fst198 a
                              where a.tp1cod1 = 10899
                                and tp1corr1 = 13
                                and tp1corr2 = 1)
            -- and b.aostat <> 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred varchar2(10);
  
  begin
  
    ln_captotcaja := 0;
  
    begin
    
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod1 = 10899
         and tp1corr1 = 13
         and tp1corr2 = 4
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
      
      else
        if lc_prgm = 'RJAQZ726' then
        
          lc_flgprg := 'L';
        
        end if;
      
      end if;
    
      begin
        delete JAQY142 J
         WHERE J.JAQY142INST = Instancia
           and j.jaqy142est = lc_flgprg;
      end;
      begin
        delete JAQY140 J
         WHERE J.JAQY140INST = Instancia
           and j.jaqy140est = lc_flgprg;
      end;
    
    end if;
  
    if lc_flgprg = 'S' then
      -- 04/09/2017 mpostigoc
      begin
        UPDATE jaqy142 j
           set jaqy142est = 'I'
         where j.jaqy142inst = Instancia
           and j.jaqy142est = 'H';
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
    
      pq_cr_reporte_caplineas.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
      --  end if;
    
      pq_cr_reporte_caplineas.Sp_Adicional_CK(i.ln_mod10,
                                              i.ln_tope10,
                                              lc_fgAdic);
      pq_cr_reporte_caplineas.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      if i.ln_mod10 = 117 then
        -- Ampliacion de Lineas  06/09/17 mpostigoc
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
      end if;
    
      if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and
         lc_FlgLn <> 'S' then
        pq_cr_reporte_caplineas.sp_resolutor(ln_Pepais,
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
    
      pq_cr_reporte_caplineas.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
      --  end if;
    
      pq_cr_reporte_caplineas.Sp_Adicional_CK(i.ln_mod10,
                                              i.ln_tope10,
                                              lc_fgAdic);
      pq_cr_reporte_caplineas.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      /*  pq_cr_resolutor_cappago.sp_cr_flujocaja(i.ln_pgcod10,
      i.ln_mod10,
      i.ln_suc10,
      i.ln_mda10,
      i.ln_pap10,
      i.ln_cta10,
      i.ln_oper10,
      i.ln_sbop10,
      i.ln_tope10,
      ln_flagFC);*/
    
      if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' then
        pq_cr_reporte_caplineas.sp_resolutor(ln_Pepais,
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
                                             
                                             ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      pq_cr_reporte_caplineas.Sp_Adicional_CK(c.ln_mod10,
                                              c.ln_tope10,
                                              lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        pq_cr_reporte_caplineas.sp_resolutor(ln_Pepais,
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
                                             c.ln_peri10,
                                             tipocambio,
                                             ln_indicador,
                                             lc_IndCred,
                                             lc_flgprg,
                                             
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
    
      pq_cr_reporte_caplineas.Sp_Adicional_CK(j.ln_mod10,
                                              j.ln_tope10,
                                              lc_fgAdic);
    
      pq_cr_reporte_caplineas.sp_refinanLinea(J.ln_pgcod10,
                                              J.ln_mod10,
                                              J.ln_suc10,
                                              J.ln_mda10,
                                              J.ln_pap10,
                                              J.ln_cta10,
                                              J.ln_oper10,
                                              lc_fgRefLin);
    
      if j.ln_mod10 = 117 then
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
      end if;
    
      if lc_ven = 'S' and lc_fgAdic <> 'S' and lc_fgRefLin <> 'S' and
         lc_FlgLn <> 'S' then
        pq_cr_reporte_caplineas.sp_resolutor_venc(ln_Pepais,
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
                                                  ln_capacidad);
      
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
    end;
    begin
    
      Divisor := nvl(ResultNeto, 0) + nvl(saldo_externo, 0);
    end;
    if Divisor <> 0 then
      ln_captotal1 := nvl(ln_cajaext, 0) / Divisor;
    else
      ln_captotal1 := 0;
    end if;
  
    ln_captotal := nvl(ln_captotal1, 0);
  
    if lc_flgprg = 'S' or lc_flgprg = 'R' or lc_flgprg = 'L' then
    
      pq_cr_reporte_caplineas.sp_cr_LogRatio(ln_Pepais     => ln_Pepais,
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
                                             lc_flgprg     => lc_flgprg);
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
              from fsd601 d
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
         and d.d601co = 'X';
    exception
      when others then
        NULL;
      
    end;
  
    begin
      select d.ppfpag
        into fech_maxcuota
        from fsd601 d
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
  
    ln_plazo       number(10, 2);
    ln_tasa        number(10, 2);
    ln_saldo       number(10, 2);
    instancia      number;
    ln_paralelo    number;
    ln_fsd011scsdo number;
    ln_ctaX        number(9);
  
  begin
    --mod@abr 20170927
  
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
        select x.xwfmonto1, x.xwfprcins
          into ln_saldo, instancia
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
    
      begin
        select max(sng120tasa)
          into ln_tasa
          from sng120
         where sng120ins = instancia;
      exception
        when others then
        
          NULL;
        
      end;
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
  
    pq_cr_reporte_caplineas.sp_cuotas(ln_pgcod10,
                                      ln_mod10,
                                      ln_suc10,
                                      ln_mda10,
                                      ln_pap10,
                                      ln_cta10,
                                      ln_oper10,
                                      ln_sbop10,
                                      ln_tope10,
                                      ln_nrocuotas);
  
    pq_cr_reporte_caplineas.sp_instancia(ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop10,
                                         ln_tope10,
                                         ln_parciales,
                                         ln_instancia);
  
    pq_cr_reporte_caplineas.sp_cr_flujocaja(ln_pgcod10,
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
        pq_cr_reporte_caplineas.sp_cuota_impaga(ln_pgcod10,
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
      
        pq_cr_reporte_caplineas.sp_cuota_impagavuelo(ln_pgcod10,
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
        pq_cr_reporte_caplineas.sp_cr_capacidadFC(ln_mod10,
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
  
    pq_cr_reporte_caplineas.sp_seguro(ln_mod10,
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
      pq_cr_reporte_caplineas.sp_capacidadlinea(ln_mod10,
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
    
      pq_cr_reporte_caplineas.sp_capacidadpagoparc(ln_nrocuotas,
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
    
      pq_cr_reporte_caplineas.sp_capacidadpago(ln_cuotimp,
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
      
        pq_cr_reporte_caplineas.sp_cr_LogCuentas(ln_Pepais,
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
                                                 lc_flgprg);
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
      
        pq_cr_reporte_caplineas.sp_cuotas(i.ln_pgcod10,
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
      
        pq_cr_reporte_caplineas.sp_cuota_impaga_lin(i.ln_pgcod10,
                                                    i.ln_mod10,
                                                    i.ln_suc10,
                                                    i.ln_mda10,
                                                    i.ln_pap10,
                                                    i.ln_cta10,
                                                    i.ln_oper10,
                                                    tipocambio,
                                                    ln_cuotimp,
                                                    fech_maxcuota);
      
        pq_cr_reporte_caplineas.sp_seguro(i.ln_mod10,
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
        pq_cr_reporte_caplineas.sp_capacidadpago_lin(ln_cuotimp,
                                                     ln_nrocuotas,
                                                     ln_pr116,
                                                     ln_seguro,
                                                     i.ln_mod10,
                                                     ln_capTem);
        pq_cr_reporte_caplineas.sp_instancia(i.ln_mod10,
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
        
          pq_cr_reporte_caplineas.sp_cr_LogCuentas(ln_Pepais,
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
                                                   lc_flgprg);
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
         where a.tp1cod1 = 20001
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
  
    ln_plazo  number(10, 2);
    ln_tasa   number(10, 2);
    ln_saldo  number(10, 2);
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
          end;*/ -- 18/09/2019 MPOSTIGOC
        
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
            --   into ln_plazo, ln_periodo
              from sng120 s
             where s.sng120ins = instancia;
          exception
            when others then
            
              NULL;
            
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
            select x.xwfmonto1
              into ln_saldo
              from xwf700 x
             where x.xwfprcins = instancia
               and x.xwfcar3 = '1';
          exception
            when others then
              null;
            
          end;
        
          begin
            select max(sng120tasa)
              into ln_tasa
              from sng120
             where sng120ins = instancia;
          exception
            when others then
              null;
          end;
        
          begin
          
            select max(s.sng120cuo), max(s.sng120per)
              into ln_cuotas, ln_plazo
            --   into ln_plazo, ln_periodo
              from sng120 s
             where s.sng120ins = instancia;
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
    
      begin
      
        ln_formula := ln_saldo *
                      (((ln_tasa / 100) *
                      (power(1 + (ln_tasa / 100), ln_cuotas))) /
                      (power(1 + (ln_tasa / 100), ln_cuotas) - 1));
      
      end;
    
    end if;
  end sp_cr_capacidadFC;

  --------------------------------------------------
  /* procedure sp_cr_amortizaciones(ln_mod10    in number,
                                 ln_suc10    in number,
                                 ln_mda10    in number,
                                 ln_pap10    in number,
                                 ln_cta10    in number,
                                 ln_oper10   in number,
                                 ln_sbop10   in number,
                                 ln_tope10   in number,
                                 lc_flagamor out varchar2,
                                 ln_mntamor  out number) is
  
    --  lc_flagamor varchar2(1);
    ln_mntamor1 number(17, 2);
  
  begin
  
    begin
      select 'S', sum(d.ppcap + d.ppint)
        into lc_flagamor, ln_mntamor1
        from fsd012 f, fsd601 d
       where f.pgcod = 1
         and f.aomod = ln_mod10
         and f.aosuc = ln_suc10
         and f.aomda = ln_mda10
         and f.aopap = ln_pap10
         and f.aocta = ln_cta10
         and f.aooper = ln_oper10
         and f.aosbop = ln_sbop10
         and f.aotope = ln_tope10
         and evtipo = 50
         and f.pgcod = d.pgcod
         and f.aomod = d.ppmod
         and f.aosuc = d.ppsuc
         and f.aomda = d.ppmda
         and f.aopap = d.pppap
         and f.aocta = d.ppcta
         and f.aooper = d.ppoper
         and f.aosbop = d.ppsbop
         and f.aotope = d.pptope
         and d.ppfpag > f.evfval;
  
    exception
      when no_data_found then
        lc_flagamor := 'N';
    end;
  end sp_cr_amortizaciones;*/

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
            from fsd601 d
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
                           lc_flgprg     in varchar2) is
  
    ln_corr   number;
    lc_IndEst varchar2(2);
    lc_hora   character(8);
  begin
  
    begin
    
      select max(j.jaqy140corr)
        into ln_corr
        from jaqy140 j
       where j.jaqy140fec = pd_fecpro;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    if lc_flgprg = 'S' then
    
      lc_IndEst := 'H';
    
      begin
        update jaqy140 j
           set j.jaqy140est = 'I'
         where j.jaqy140inst = Instancia
           and j.jaqy140est = 'H';
        commit;
      end;
    
    else
      if lc_flgprg = 'R' then
      
        lc_IndEst := 'R';
      
      else
        if lc_flgprg = 'L' then
          lc_IndEst := 'L';
        end if;
      end if;
    
    end if;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    -- if lc_exist = 'N' then
    begin
      insert into jaqy140
        (jaqy140corr,
         jaqy140pais,
         jaqy140tdoc,
         jaqy140ndoc,
         jaqy140tcamb,
         jaqy140inst,
         jaqy140fec,
         jaqy140hora,
         jaqy140capcaja,
         jaqy140sldext,
         jaqy140resnet,
         jaqy140ratio,
         jaqy140ind,
         JAQY140EST)
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
         lc_IndEst);
      commit;
    end;
  
    /* else
      if lc_exist = 'S' then
    
        begin
          update jaqy140
             set jaqy140capcaja = ln_captotcaja,
                 jaqy140sldext  = saldo_externo,
                 jaqy140resnet  = ResultNeto,
                 jaqy140ratio   = ln_captotal
           where \*JAQY140PAIS = ln_Pepais
                                                                                                                                                         AND JAQY140TDOC = ln_Petdoc
                                                                                                                                                         AND JAQY140NDOC = ln_Pendoc
                                                                                                                                                         and *\
           JAQY140INST = Instancia; -- 27/07/2017
          commit;
        end;
    
      END IF;
    end if;*/
  
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
                             lc_flgprg    in varchar2) is
  
    ln_corr number;
    --lc_exist varchar2(2) := 'N';
    lc_hora   character(8);
    lc_IndEst varchar2(2);
  
  begin
  
    begin
    
      select max(j.jaqy142corr)
        into ln_corr
        from jaqy142 j
       where j.jaqy142fec = pd_fecpro;
    exception
      when no_data_found then
        ln_corr := 0;
      
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    if lc_flgprg = 'S' then
    
      lc_IndEst := 'H';
    
    else
      if lc_flgprg = 'R' then
      
        lc_IndEst := 'R';
      
      else
        if lc_flgprg = 'L' then
        
          lc_IndEst := 'L';
        
        end if;
      end if;
    end if;
  
    -- if lc_exist = 'N' then
  
    begin
      insert into jaqy142
        (jaqy142corr,
         jaqy142fec,
         jaqy142hora,
         jaqy142pais,
         jaqy142tdoc,
         jaqy142ndoc,
         jaqy142tcamb,
         jaqy142inst,
         jaqy142pgcod,
         jaqy142mod,
         jaqy142suc,
         jaqy142mda,
         jaqy142pap,
         jaqy142cta,
         jaqy142ope,
         jaqy142sbop,
         jaqy142tope,
         JAQY142PERIO,
         JAQY142NRCUO,
         JAQY142TSOLI,
         JAQY142FLCJ,
         JAQY142CUOIMP,
         JAQY142SEGURO,
         JAQY142CAPFC,
         JAQY142CAPLIN,
         jaqy142capcuo,
         JAQY142INDIC,
         jaqy142est)
      
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
         lc_IndEst);
    
      commit;
    
    end;
  
  end sp_cr_LogCuentas;

end pq_cr_reporte_caplineas;
/

