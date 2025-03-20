create or replace package PQ_CR_SALDOPYMEVIG is

  -- Author  : MPOSTIGOC
  -- Created : 01/08/2017
  -- Purpose : Ratio Endeudamiento Resolutor Politica Saldo Pyme

  procedure sp_cuentas(Instancia in number, ln_captotcaja out number);
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
  --------------------------------------------------------
  procedure sp_cr_VerificaDPFCTS(ln_pgcod     in number,
                                 ln_modulo    in number,
                                 ln_sucursal  in number,
                                 ln_moneda    in number,
                                 ln_papel     in number,
                                 ln_cuenta    in number,
                                 ln_operac    in number,
                                 ln_suboper   in number,
                                 ln_tipoper   in number,
                                 lc_VerifExcp out Varchar2);

end PQ_CR_SALDOPYMEVIG;
/

create or replace package body PQ_CR_SALDOPYMEVIG is

  -- Author  : MPOSTIGOC
  -- Created : 01/08/2017
  -- Purpose : Saldo Vigente Actual

  procedure sp_cuentas(Instancia in number, ln_captotcaja out number) is
  
    ln_capacidad number;
    lc_fgAdic    varchar2(1);
    lc_fgAmpl    varchar2(1);
    lc_ven       char(1);
    ln_indicador number;
    lc_fgRefLin  varchar2(1) := 'N';
    lc_fgRepro   varchar2(2);
    lc_FlgLn     varchar2(2);
    tipocambio   number;
  
    cursor inserta(ln_Pepais   number,
                   ln_Petdoc   number,
                   ln_Pendoc   varchar2,
                   ld_FechSist date) is
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
         and d10.Aomod in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (106, 107, 108, 109))
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
         and b.Aomod in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (106, 107, 108, 109))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor linea(ln_Pepais   number,
                 ln_Petdoc   number,
                 ln_Pendoc   varchar2,
                 ld_FechSist date) is
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
         and d10.aofvto > ld_FechSist
      
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
         and b.aofvto > ld_FechSist;
  
    cursor vuelo(ln_Pepais   number,
                 ln_Petdoc   number,
                 ln_Pendoc   varchar2,
                 ld_FechSist date) is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             x.xwfprcins,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc)
            
         and x.xwfmodulo in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (106, 107, 108, 109))
            
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
                x.xwftipope,
                x.xwfprcins
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
             x.xwfprcins,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s, fsr002 c, fsr008 a
      
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and x.xwfempresa = 1
         and x.xwfmodulo in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (106, 107, 108, 109))
            
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
                     (select max(w.wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                            -- and wftaskcod <> 55
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    -- and wftaskcod <> 55
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
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
                x.xwftipope,
                x.xwfprcins;
  
    cursor lineas_ven(ln_Pepais   number,
                      ln_Petdoc   number,
                      ln_Pendoc   varchar2,
                      ld_FechSist date) is
    
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
         and d10.aofvto < ld_FechSist
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
         and b.aofvto < ld_FechSist
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred     varchar2(12);
    lc_flgprg      varchar2(2);
    ln_Pepais      number;
    ln_Petdoc      number;
    ln_Pendoc      varchar2(12);
    ld_FechSist    date;
    lc_VerifDpfCts varchar2(2) := 'N';
  begin
  
    ln_captotcaja := 0;
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where sng001inst = Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select w.sng120tcbi
        into tipocambio
        from sng120 w
       where w.sng120ins = Instancia
         and w.sng120tsk like 'EVALUA%';
    exception
      when others then
        null;
    end;
    begin
      select pgfape into ld_FechSist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    for i in inserta(ln_Pepais, ln_Petdoc, ln_Pendoc, ld_FechSist) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigente';
    
      PQ_CR_SALDOPYMEVIG.sp_refinanLinea(i.ln_pgcod10,
                                         i.ln_mod10,
                                         i.ln_suc10,
                                         i.ln_mda10,
                                         i.ln_pap10,
                                         i.ln_cta10,
                                         i.ln_oper10,
                                         lc_fgRefLin);
    
      PQ_CR_SALDOPYMEVIG.Sp_ampliados_CK(i.ln_pgcod10,
                                         i.ln_mod10,
                                         i.ln_suc10,
                                         i.ln_mda10,
                                         i.ln_pap10,
                                         i.ln_cta10,
                                         i.ln_oper10,
                                         i.ln_sbop10,
                                         i.ln_tope10,
                                         lc_fgAmpl);
    
      PQ_CR_SALDOPYMEVIG.sp_cr_Reprogramados(i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             lc_fgRepro);
    
      PQ_CR_SALDOPYMEVIG.sp_cr_VerificaDPFCTS(I.LN_PGCOD10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_VerifDpfCts);
    
      if lc_fgRefLin <> 'S' and lc_fgAmpl <> 'S' AND lc_fgRepro <> 'S' and
         lc_VerifDpfCts <> 'N' then
        PQ_CR_SALDOPYMEVIG.sp_resolutor(ln_Pepais,
                                        ln_Petdoc,
                                        ln_Pendoc,
                                        tipocambio,
                                        Instancia,
                                        ld_FechSist,
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
                                        ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for l in linea(ln_Pepais, ln_Petdoc, ln_Pendoc, ld_FechSist) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredLinea';
    
      PQ_CR_SALDOPYMEVIG.sp_refinanLinea(l.ln_pgcod10,
                                         l.ln_mod10,
                                         l.ln_suc10,
                                         l.ln_mda10,
                                         l.ln_pap10,
                                         l.ln_cta10,
                                         l.ln_oper10,
                                         lc_fgRefLin);
      PQ_CR_SALDOPYMEVIG.sp_cr_VerificaDPFCTS(l.LN_PGCOD10,
                                              l.ln_mod10,
                                              l.ln_suc10,
                                              l.ln_mda10,
                                              l.ln_pap10,
                                              l.ln_cta10,
                                              l.ln_oper10,
                                              l.ln_sbop10,
                                              l.ln_tope10,
                                              lc_VerifDpfCts);
    
      if l.ln_mod10 = 117 then
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
             and rownum = 1;
        exception
          when others then
            lc_FlgLn := 'N';
        end;
      end if;
    
      if lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' and lc_VerifDpfCts <> 'N' then
      
        PQ_CR_SALDOPYMEVIG.sp_resolutor(ln_Pepais,
                                        ln_Petdoc,
                                        ln_Pendoc,
                                        tipocambio,
                                        Instancia,
                                        ld_FechSist,
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
                                        ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for c in vuelo(ln_Pepais, ln_Petdoc, ln_Pendoc, ld_FechSist) loop
      ln_indicador := 2;
      lc_IndCred   := 'CredEnVuelo';
    
      PQ_CR_SALDOPYMEVIG.sp_cr_VerificaDPFCTS(c.LN_PGCOD10,
                                              c.ln_mod10,
                                              c.ln_suc10,
                                              c.ln_mda10,
                                              c.ln_pap10,
                                              c.ln_cta10,
                                              c.ln_oper10,
                                              c.ln_sbop10,
                                              c.ln_tope10,
                                              lc_VerifDpfCts);
      if lc_VerifDpfCts <> 'N' then
      
        PQ_CR_SALDOPYMEVIG.sp_resolutorvuelo(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             tipocambio,
                                             Instancia,
                                             ld_FechSist,
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
                                             ln_capacidad);
      end if;
    
      ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven(ln_Pepais, ln_Petdoc, ln_Pendoc, ld_FechSist) loop
    
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
    
      PQ_CR_SALDOPYMEVIG.sp_refinanLinea(j.ln_pgcod10,
                                         j.ln_mod10,
                                         j.ln_suc10,
                                         j.ln_mda10,
                                         j.ln_pap10,
                                         j.ln_cta10,
                                         j.ln_oper10,
                                         lc_fgRefLin);
    
      PQ_CR_SALDOPYMEVIG.sp_cr_VerificaDPFCTS(j.LN_PGCOD10,
                                              j.ln_mod10,
                                              j.ln_suc10,
                                              j.ln_mda10,
                                              j.ln_pap10,
                                              j.ln_cta10,
                                              j.ln_oper10,
                                              j.ln_sbop10,
                                              j.ln_tope10,
                                              lc_VerifDpfCts);
    
      if lc_ven = 'S' and lc_fgRefLin <> 'S' and lc_VerifDpfCts <> 'N' then
        PQ_CR_SALDOPYMEVIG.sp_resolutor_venc(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             tipocambio,
                                             Instancia,
                                             ld_FechSist,
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
                                             ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
  end sp_cuentas;
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
      
        SELECT SUBSTR(to_char(ln_rubro), 5, 2) into ln_digito FROM DUAL;
      
      else
        if ln_mod10 = 117 then
        
          SELECT SUBSTR(to_char(ln_rubro), 7, 2) into ln_digito FROM DUAL;
        
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
                         ln_saldocap out number) is
  
  begin
  
    If lc_fgRefLin <> 'S' then
    
      PQ_CR_SALDOPYMEVIG.sp_cr_saldocapital(ln_pgcod10,
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
      
        PQ_CR_SALDOPYMEVIG.sp_cr_saldocapitalref(tipocambio,
                                                 Instancia,
                                                 ln_saldocap);
      
      End if;
    
    End if;
  
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
                              ln_saldocap  out number) is
  
  begin
  
    If lc_fgRefLin <> 'S' then
    
      PQ_CR_SALDOPYMEVIG.sp_cr_saldocapital(ln_pgcod10,
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
      
        PQ_CR_SALDOPYMEVIG.sp_cr_saldocapitalref(tipocambio,
                                                 ln_InstVerif,
                                                 ln_saldocap);
      
      End if;
    
    End if;
  
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
                              ln_capacidad out number) is
    ln_saldocap number;
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
      
        PQ_CR_SALDOPYMEVIG.sp_cr_saldocapital(i.ln_pgcod10,
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

  ----------------------------------------------------------
  procedure sp_cr_VerificaDPFCTS(ln_pgcod     in number,
                                 ln_modulo    in number,
                                 ln_sucursal  in number,
                                 ln_moneda    in number,
                                 ln_papel     in number,
                                 ln_cuenta    in number,
                                 ln_operac    in number,
                                 ln_suboper   in number,
                                 ln_tipoper   in number,
                                 lc_VerifExcp out Varchar2) is
  
    FlgIncl      varchar2(2);
    ln_modul117  number;
    ln_cta117    number;
    ln_oper117   number;
    ln_sboper117 number;
    ln_sucur117  number;
    ln_mda117    number;
    ln_tipoer117 number;
  
  begin
  
    begin
    
      if ln_modulo = 116 then
      
        begin
        
          select f.r2mod,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2suc,
                 f.r2mda,
                 f.r2tope
            into ln_modul117,
                 ln_cta117,
                 ln_oper117,
                 ln_sboper117,
                 ln_sucur117,
                 ln_mda117,
                 ln_tipoer117
            from fsr011 f
           where f.r1cod = ln_pgcod
             and f.r1mod = ln_modulo
             and f.r1suc = ln_sucursal
             and f.r1mda = ln_moneda
             and f.r1pap = ln_papel
             and f.r1cta = ln_cuenta
             and f.r1oper = ln_operac
             and f.r1sbop = ln_suboper
             and f.r1tope = ln_tipoper
             and f.relcod = 46;
        
        end;
      
        begin
          Select 'N'
            into FlgIncl
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = ln_pgcod
             and a.r1mod = ln_modul117
             and a.r1suc = ln_sucur117
             and a.r1mda = ln_mda117
             and a.r1pap = 0
             and a.r1cta = ln_cta117
             and a.r1oper = ln_oper117
             and a.r1sbop = ln_sboper117
             and a.r1tope = ln_tipoer117
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
          
        end;
      
      else
        if ln_modulo <> 116 then
        
          begin
            --créditos con garantía de plazo fijo o cts
          
            Select 'N'
              into FlgIncl
              from fsr011 a, fsr011 b
             where a.relcod = 50
               and a.r1cod = ln_pgcod
               and a.r1mod = ln_modulo
               and a.r1suc = ln_sucursal
               and a.r1mda = ln_moneda
               and a.r1pap = ln_papel
               and a.r1cta = ln_cuenta
               and a.r1oper = ln_operac
               and a.r1sbop = ln_suboper
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
              -- ln_rcta := 0;
              FlgIncl := 'S';
          end;
        End If;
      
      end if;
    
    end;
  
    if FlgIncl = 'N' /*or ln_NRO_CUOTAS < 2*/
     then
      lc_VerifExcp := 'N';
    
    else
      lc_VerifExcp := 'S';
    end if;
  
  end sp_cr_VerificaDPFCTS;

-----------------------------------------------------------
end PQ_CR_SALDOPYMEVIG;
/

