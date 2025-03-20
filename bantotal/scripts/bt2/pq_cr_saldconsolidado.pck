create or replace package PQ_CR_SALDCONSOLIDADO is

  -- Author  : MPOSTIGOC
  -- Created : 12/06/2019 11:26:16 a. m.
  -- Purpose : 

  procedure sp_cuentas(ln_Instancia  in number,
                       ln_TipCamb    in number,
                       ld_FecPro     in date,
                       ln_captotcaja out number);
  ------------------------------------------------------
  procedure sp_cr_saldocapital(ln_pgcod10   in number,
                               ln_mod10     in number,
                               ln_suc10     in number,
                               ln_mda10     in number,
                               ln_pap10     in number,
                               ln_cta10     in number,
                               ln_oper10    in number,
                               ln_sbop      in number,
                               ln_tope10    in number,
                               ln_TipCamb   in number,
                               ln_Instancia in number,
                               ln_saldocap  out number);

  -----------------------------------------------------

  procedure sp_cr_saldocapitalref(ln_TipCamb   in number,
                                  ln_Instancia in number,
                                  ln_saldocap  out number);

  -----------------------------------------------------
  procedure sp_resolutor(ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop      in number,
                         ln_tope10    in number,
                         ln_TipCamb   in number,
                         lc_fgRefLin  in varchar2,
                         ln_Instancia in number,
                         ln_saldocap  out number);
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
  procedure sp_resolutor_venc(ln_pgcod10   in number,
                              ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop10    in number,
                              ln_tope10    in number,
                              ln_TipCamb   in number,
                              ln_Instancia in number,
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
  -----------------------------------------------------------
  procedure sp_cr_VerfDPFCTS(ln_pgcod      in number,
                             ln_modulo     in number,
                             ln_sucursal   in number,
                             ln_moneda     in number,
                             ln_papel      in number,
                             ln_cuenta     in number,
                             ln_operacion  in number,
                             ln_subopera   in number,
                             ln_tipoper    in number,
                             lc_VerfDPFCTS out varchar2);

end PQ_CR_SALDCONSOLIDADO;
/

create or replace package body PQ_CR_SALDCONSOLIDADO is

  -- SALDO CONSOLIDADO PARA CAMPAÑA
  procedure sp_cuentas(ln_Instancia  in number,
                       ln_TipCamb    in number,
                       ld_FecPro     in date,
                       ln_captotcaja out number) is
  
    cursor inserta(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
    
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
                                        and a.tp1corr2 = 1))) or
             d10.Aomod in (141))
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
                                        and a.tp1corr2 = 1))) or
             b.Aomod in (141))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor linea(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
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
         and d10.aofvto > ld_FecPro
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
         and b.aofvto > ld_FecPro;
  
    cursor vuelo(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10,
             x.xwfprcins
        from xwf700 x
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
                                        and a.tp1corr2 = 1))) or
             xwfmodulo in (117, 141))
            
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
                 and wf.wfitemstsact = 1
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
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
             x.xwfprcins
        from xwf700 x, fsr002 c, fsr008 a
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
                                        and a.tp1corr2 = 1))) or
             xwfmodulo in (117, 141))
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
                 and wf.wfitemstsact = 1
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
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
  
    cursor lineas_ven(ln_Pepais number,
                      ln_Petdoc number,
                      ln_Pendoc varchar2) is
    
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
         and d10.aofvto < ld_FecPro
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
         and aofvto < ld_FecPro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    ln_capacidad  number;
    lc_fgAdic     varchar2(2) := 'N';
    lc_fgAmpl     varchar2(2) := 'N';
    lc_ven        char(1);
    ln_indicador  number;
    lc_fgRefLin   varchar2(2) := 'N';
    lc_fgRepro    varchar2(2) := 'N';
    ln_VrfVL      varchar2(2) := 'N';
    lc_VerfDPFCTS varchar2(2) := 'N';
    ln_Pepais     number;
    ln_Petdoc     number;
    ln_Pendoc     varchar2(12);
    ln_TipCambio  number(14, 8) := 0.000;
  
  begin
  
    ln_captotcaja := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    ln_TipCambio := ln_TipCamb;
  
    if ln_TipCambio = 0 then
      begin
        select cotcbi
          into ln_TipCambio
          from fsh005 f
         where cofdes in (select max(cofdes)
                            from fsh005 g
                           where g.cofdes <= ld_FecPro
                             and moneda = 101)
           and moneda = 101;
      exception
        when no_data_found then
          ln_TipCambio := 0;
      end;
    
    end if;
  
    for i in inserta(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
    
      PQ_CR_SALDCONSOLIDADO.sp_refinanLinea(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            lc_fgRefLin);
    
      PQ_CR_SALDCONSOLIDADO.Sp_ampliados_CK(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            i.ln_sbop10,
                                            i.ln_tope10,
                                            lc_fgAmpl);
    
      PQ_CR_SALDCONSOLIDADO.sp_cr_Reprogramados(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_fgRepro);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => i.ln_mod10,
                                                 ln_suc10  => i.ln_suc10,
                                                 ln_mda10  => i.ln_mda10,
                                                 ln_pap10  => i.ln_pap10,
                                                 ln_cta10  => i.ln_cta10,
                                                 ln_oper10 => i.ln_oper10,
                                                 ln_sbop10 => i.ln_sbop10,
                                                 ln_tope10 => i.ln_tope10,
                                                 lc_FlgLn  => ln_VrfVL);
    
      pq_cr_saldconsolidado.sp_cr_VerfDPFCTS(ln_pgcod      => i.ln_pgcod10,
                                             ln_modulo     => i.ln_mod10,
                                             ln_sucursal   => i.ln_suc10,
                                             ln_moneda     => i.ln_mda10,
                                             ln_papel      => i.ln_pap10,
                                             ln_cuenta     => i.ln_cta10,
                                             ln_operacion  => i.ln_oper10,
                                             ln_subopera   => i.ln_sbop10,
                                             ln_tipoper    => i.ln_tope10,
                                             lc_VerfDPFCTS => lc_VerfDPFCTS);
    
      if lc_fgRefLin <> 'S' and lc_fgAmpl <> 'S' AND lc_fgRepro <> 'S' and
         ln_VrfVL <> 'S' and lc_VerfDPFCTS <> 'S' then
      
        PQ_CR_SALDCONSOLIDADO.sp_resolutor(i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           ln_TipCambio,
                                           lc_fgRefLin,
                                           ln_Instancia,
                                           ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for l in linea(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
    
      PQ_CR_SALDCONSOLIDADO.sp_refinanLinea(l.ln_pgcod10,
                                            l.ln_mod10,
                                            l.ln_suc10,
                                            l.ln_mda10,
                                            l.ln_pap10,
                                            l.ln_cta10,
                                            l.ln_oper10,
                                            lc_fgRefLin);
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => l.ln_mod10,
                                                 ln_suc10  => l.ln_suc10,
                                                 ln_mda10  => l.ln_mda10,
                                                 ln_pap10  => l.ln_pap10,
                                                 ln_cta10  => l.ln_cta10,
                                                 ln_oper10 => l.ln_oper10,
                                                 ln_sbop10 => l.ln_sbop10,
                                                 ln_tope10 => l.ln_tope10,
                                                 lc_FlgLn  => ln_VrfVL);
    
      pq_cr_saldconsolidado.sp_cr_VerfDPFCTS(ln_pgcod      => l.ln_pgcod10,
                                             ln_modulo     => l.ln_mod10,
                                             ln_sucursal   => l.ln_suc10,
                                             ln_moneda     => l.ln_mda10,
                                             ln_papel      => l.ln_pap10,
                                             ln_cuenta     => l.ln_cta10,
                                             ln_operacion  => l.ln_oper10,
                                             ln_subopera   => l.ln_sbop10,
                                             ln_tipoper    => l.ln_tope10,
                                             lc_VerfDPFCTS => lc_VerfDPFCTS);
    
      if lc_fgRefLin <> 'S' and ln_VrfVL <> 'S' and lc_VerfDPFCTS <> 'S' then
      
        PQ_CR_SALDCONSOLIDADO.sp_resolutor(l.ln_pgcod10,
                                           l.ln_mod10,
                                           l.ln_suc10,
                                           l.ln_mda10,
                                           l.ln_pap10,
                                           l.ln_cta10,
                                           l.ln_oper10,
                                           l.ln_sbop10,
                                           l.ln_tope10,
                                           ln_TipCambio,
                                           lc_fgRefLin,
                                           ln_Instancia,
                                           ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for c in vuelo(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      pq_cr_saldconsolidado.sp_cr_VerfDPFCTS(ln_pgcod      => c.ln_pgcod10,
                                             ln_modulo     => c.ln_mod10,
                                             ln_sucursal   => c.ln_suc10,
                                             ln_moneda     => c.ln_mda10,
                                             ln_papel      => c.ln_pap10,
                                             ln_cuenta     => c.ln_cta10,
                                             ln_operacion  => c.ln_oper10,
                                             ln_subopera   => c.ln_sbop10,
                                             ln_tipoper    => c.ln_tope10,
                                             lc_VerfDPFCTS => lc_VerfDPFCTS);
    
      ln_indicador := 2;
    
      if lc_VerfDPFCTS <> 'S' then
      
        PQ_CR_SALDCONSOLIDADO.sp_resolutor(c.ln_pgcod10,
                                           c.ln_mod10,
                                           c.ln_suc10,
                                           c.ln_mda10,
                                           c.ln_pap10,
                                           c.ln_cta10,
                                           c.ln_oper10,
                                           c.ln_sbop10,
                                           c.ln_tope10,
                                           ln_TipCambio,
                                           lc_fgRefLin,
                                           c.xwfprcins,
                                           ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    end loop;
  
    for j in lineas_ven(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
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
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => j.ln_mod10,
                                                 ln_suc10  => j.ln_suc10,
                                                 ln_mda10  => j.ln_mda10,
                                                 ln_pap10  => j.ln_pap10,
                                                 ln_cta10  => j.ln_cta10,
                                                 ln_oper10 => j.ln_oper10,
                                                 ln_sbop10 => j.ln_sbop10,
                                                 ln_tope10 => j.ln_tope10,
                                                 lc_FlgLn  => ln_VrfVL);
    
      pq_cr_saldconsolidado.sp_cr_VerfDPFCTS(ln_pgcod      => j.ln_pgcod10,
                                             ln_modulo     => j.ln_mod10,
                                             ln_sucursal   => j.ln_suc10,
                                             ln_moneda     => j.ln_mda10,
                                             ln_papel      => j.ln_pap10,
                                             ln_cuenta     => j.ln_cta10,
                                             ln_operacion  => j.ln_oper10,
                                             ln_subopera   => j.ln_sbop10,
                                             ln_tipoper    => j.ln_tope10,
                                             lc_VerfDPFCTS => lc_VerfDPFCTS);
    
      if lc_ven = 'S' and ln_VrfVL <> 'S' and lc_VerfDPFCTS <> 'S' then
        PQ_CR_SALDCONSOLIDADO.sp_resolutor_venc(j.ln_pgcod10,
                                                j.ln_mod10,
                                                j.ln_suc10,
                                                j.ln_mda10,
                                                j.ln_pap10,
                                                j.ln_cta10,
                                                j.ln_oper10,
                                                j.ln_sbop10,
                                                j.ln_tope10,
                                                ln_TipCambio,
                                                ln_Instancia,
                                                ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
  end sp_cuentas;
  --------------------------------------------------------------------------------

  procedure sp_cr_saldocapital(ln_pgcod10   in number,
                               ln_mod10     in number,
                               ln_suc10     in number,
                               ln_mda10     in number,
                               ln_pap10     in number,
                               ln_cta10     in number,
                               ln_oper10    in number,
                               ln_sbop      in number,
                               ln_tope10    in number,
                               ln_TipCamb   in number,
                               ln_Instancia in number,
                               ln_saldocap  out number) is
  begin
    begin
    
      select scsdo
        into ln_saldocap
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
         where w.xwfprcins = ln_Instancia
           and w.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    end if;
  
    if ln_mda10 = 101 then
      ln_saldocap := ln_saldocap * ln_TipCamb;
    end if;
  
    if ln_saldocap < 0 then
      ln_saldocap := ln_saldocap * -1;
    end if;
  
  end sp_cr_saldocapital;
  ----------------------------------------------------

  procedure sp_cr_saldocapitalref(ln_TipCamb   in number,
                                  ln_Instancia in number,
                                  ln_saldocap  out number) is
    ln_mda10 number;
  
  begin
  
    begin
      select w.xwfmonto1, w.xwfmoneda
        into ln_saldocap, ln_mda10
        from xwf700 w
       where w.xwfprcins = ln_Instancia
         and w.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_mda10 = 101 then
      ln_saldocap := ln_saldocap * ln_TipCamb;
    end if;
  
    if ln_saldocap < 0 then
      ln_saldocap := ln_saldocap * -1;
    end if;
  end sp_cr_saldocapitalref;

  --------------------------------------------------
  procedure sp_resolutor(ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop      in number,
                         ln_tope10    in number,
                         ln_TipCamb   in number,
                         lc_fgRefLin  in varchar2,
                         ln_Instancia in number,
                         ln_saldocap  out number) is
  
  begin
  
    If lc_fgRefLin <> 'S' then
    
      PQ_CR_SALDCONSOLIDADO.sp_cr_saldocapital(ln_pgcod10,
                                               ln_mod10,
                                               ln_suc10,
                                               ln_mda10,
                                               ln_pap10,
                                               ln_cta10,
                                               ln_oper10,
                                               ln_sbop,
                                               ln_tope10,
                                               ln_TipCamb,
                                               ln_Instancia,
                                               ln_saldocap);
    else
      if lc_fgRefLin = 'S' then
      
        PQ_CR_SALDCONSOLIDADO.sp_cr_saldocapitalref(ln_TipCamb,
                                                    ln_Instancia,
                                                    ln_saldocap);
      
      End if;
    
    End if;
  
  end sp_resolutor;

  --------------------------------------------------
  procedure sp_resolutor_venc(ln_pgcod10   in number,
                              ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop10    in number,
                              ln_tope10    in number,
                              ln_TipCamb   in number,
                              ln_Instancia in number,
                              ln_capacidad out number) is
    ln_saldocap number;
    lc_ven      char(1);
  
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
      
        PQ_CR_SALDCONSOLIDADO.sp_cr_saldocapital(i.ln_pgcod10,
                                                 i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 ln_TipCamb,
                                                 ln_Instancia,
                                                 ln_saldocap);
      
        ln_capacidad := nvl(ln_capacidad, 0) + nvl(ln_saldocap, 0);
      
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

  Procedure Sp_Adicional_CK(pn_top in number, Pc_flag out varchar2) is
  
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
           and tp1corr1 = 18
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
      select 'S'
        into lc_fgRepro
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
          from xwf700 a, sng001 s, wfwrkitems x
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
  ----------------------------------------------------------
  procedure sp_cr_VerfDPFCTS(ln_pgcod      in number,
                             ln_modulo     in number,
                             ln_sucursal   in number,
                             ln_moneda     in number,
                             ln_papel      in number,
                             ln_cuenta     in number,
                             ln_operacion  in number,
                             ln_subopera   in number,
                             ln_tipoper    in number,
                             lc_VerfDPFCTS out varchar2) is
    ln_mod    number;
    ln_cta    number;
    ln_oper   number;
    ln_sboper number;
    ln_sucur  number;
    ln_mda    number;
    ln_tipoer number;
  
  begin
  
    lc_VerfDPFCTS := 'N';
  
    if ln_modulo = 116 then
    
      begin
      
        select f.r2mod,
               f.r2cta,
               f.r2oper,
               f.r2sbop,
               f.r2suc,
               f.r2mda,
               f.r2tope
          into ln_mod,
               ln_cta,
               ln_oper,
               ln_sboper,
               ln_sucur,
               ln_mda,
               ln_tipoer
          from fsr011 f
         where f.r1cod = ln_pgcod
           and f.r1mod = ln_modulo
           and f.r1suc = ln_sucursal
           and f.r1mda = ln_moneda
           and f.r1pap = ln_papel
           and f.r1cta = ln_cuenta
           and f.r1oper = ln_operacion
           and f.r1sbop = ln_subopera
           and f.r1tope = ln_tipoper
           and f.relcod = 46;
      
      end;
    
      begin
        Select 'S'
          into lc_VerfDPFCTS
          from fsr011 a, fsr011 b
         where a.relcod = 50
           and a.r1cod = 1
           and a.r1mod = ln_mod
           and a.r1suc = ln_sucur
           and a.r1mda = ln_mda
           and a.r1pap = 0
           and a.r1cta = ln_cta
           and a.r1oper = ln_oper
           and a.r1sbop = ln_sboper
           and a.r1tope = ln_tipoer
           and b.r2cta = a.r2cta
           and b.r2oper = a.r2oper
           and b.r2sbop = a.r2sbop
           and b.relcod in (2, 25)
           and a.r011co = 'S'
           and b.r011co = 'S'
           and rownum = 1;
      exception
        when no_data_found then
          lc_VerfDPFCTS := 'N';
        
      end;
    
    else
      if ln_modulo <> 116 then
      
        begin
          --créditos con garantía de plazo fijo o cts
        
          Select 'S'
            into lc_VerfDPFCTS
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = ln_pgcod
             and a.r1mod = ln_modulo
             and a.r1suc = ln_sucursal
             and a.r1mda = ln_moneda
             and a.r1pap = ln_papel
             and a.r1cta = ln_cuenta
             and a.r1oper = ln_operacion
             and a.r1sbop = ln_subopera
             and a.r1tope = ln_tipoper
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            lc_VerfDPFCTS := 'N';
        end;
      End If;
    
    end if;
  
  end sp_cr_VerfDPFCTS;
  -----------------------------------------------------------

end PQ_CR_SALDCONSOLIDADO;
/

