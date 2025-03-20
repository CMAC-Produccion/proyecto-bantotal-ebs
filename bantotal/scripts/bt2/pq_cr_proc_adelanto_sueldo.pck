create or replace package pq_cr_proc_adelanto_sueldo is

  -- Author  : RMONTESR
  -- Created : 13/05/2021 19:00:29
  -- Purpose : Porcedimientos para req. adelanto de sueldo
  
  procedure sp_cuentas_titular(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       tipocambio    in number,
                       Instancia     in number,
                       pd_fecpro     in date,
                       ln_captotcaja out number);
  -------------------------------------------------------------------------

  procedure sp_cr_traba_activocaja(pn_pais in numeric,
                                   pn_tdoc in numeric,
                                   pc_ndoc in char,
                                   pv_rpta out varchar2);
  ------------------------------------------------------------
  procedure sp_cr_calif_rcc_pae(pn_tdoc in numeric,
                                pc_ndoc in char,
                                pv_rpta out varchar2);
  -----------------------------------------------------------------
  procedure sp_cr_maxdias_atraso(pd_fape in date,
                              pn_pais in numeric,
                              pn_tdoc in numeric,
                              pc_ndoc in char,
                              pn_rpta out numeric);
  Procedure sp_cr_get_codsbs(pn_tipdoc in number,
                             pc_numdoc in char,
                             pv_codsbs out varchar2);

end pq_cr_proc_adelanto_sueldo;
/

create or replace package body pq_cr_proc_adelanto_sueldo is

  
  -----------------------------------------------------------
  procedure sp_cuentas_titular(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       tipocambio    in number,
                       Instancia     in number,
                       pd_fecpro     in date,
                       ln_captotcaja out number) is
  
    ln_capacidad number;
  
    lc_fgAdic    varchar2(1); 
    lc_fgAmpl    varchar2(1); 
    lc_ven       char(1); 
    ln_indicador number; 
    lc_fgRefLin  varchar2(1) := 'N'; 
    lc_fgRepro   varchar2(2);
  
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
                                        and a.tp1corr2 = 1))) or
             d10.Aomod in (141))
         and d10.Aostat <> 99
      --  and aofvto > pd_fecpro
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
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 1))) or
             b.Aomod in (141)) --Agregar guia de proceso para excluir modulos
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
            and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.Aomod in (117) --Agregar guia de proceso para excluir modulos
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto > pd_fecpro;
  
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
             x.xwfprcins,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc
                                and Cttfir = 'T'
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
                            -- and wftaskcod <> 55
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    --and wftaskcod <> 55
                 and wf.wfitemstsact = 1
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
                            -- and wftaskcod <> 55
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) 
                    -- and wftaskcod <> 55
                 and wf.wfitemstsact = 1
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
         and aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_Vinculado varchar2(5) := 'N';
  
  begin
  
    ln_captotcaja := 0;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
    
      PQ_CR_RESOLUTOR_AUTONOMIA.sp_refinanLinea(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                lc_fgRefLin);
    
      PQ_CR_RESOLUTOR_AUTONOMIA.Sp_ampliados_CK(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_fgAmpl);
    
      PQ_CR_RESOLUTOR_AUTONOMIA.sp_cr_Reprogramados(i.ln_pgcod10,
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
                                                 lc_FlgLn  => lc_Vinculado);
    
      -- end if;*/
    
      -- if /*lc_fgAdic <> 'S' and*/ lc_fgAmpl <> 'S' then
      if lc_fgRefLin <> 'S' and lc_fgAmpl <> 'S' AND lc_fgRepro <> 'S' and
         lc_Vinculado <> 'S' then
        PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor(i.ln_pgcod10,
                                               i.ln_mod10,
                                               i.ln_suc10,
                                               i.ln_mda10,
                                               i.ln_pap10,
                                               i.ln_cta10,
                                               i.ln_oper10,
                                               i.ln_sbop10,
                                               i.ln_tope10,
                                               tipocambio,
                                               lc_fgRefLin,
                                               Instancia,
                                               
                                               ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for l in linea loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
    
      PQ_CR_RESOLUTOR_AUTONOMIA.sp_refinanLinea(l.ln_pgcod10,
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
                                                 lc_FlgLn  => lc_Vinculado);
    
      if lc_fgRefLin <> 'S' and lc_Vinculado <> 'S' then
      
        PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor(l.ln_pgcod10,
                                               l.ln_mod10,
                                               l.ln_suc10,
                                               l.ln_mda10,
                                               l.ln_pap10,
                                               l.ln_cta10,
                                               l.ln_oper10,
                                               l.ln_sbop10,
                                               l.ln_tope10,
                                               tipocambio,
                                               lc_fgRefLin,
                                               Instancia,
                                               
                                               ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor(c.ln_pgcod10,
                                             c.ln_mod10,
                                             c.ln_suc10,
                                             c.ln_mda10,
                                             c.ln_pap10,
                                             c.ln_cta10,
                                             c.ln_oper10,
                                             c.ln_sbop10,
                                             c.ln_tope10,
                                             tipocambio,
                                             lc_fgRefLin,
                                             --Instancia,
                                             c.xwfprcins,
                                             
                                             ln_capacidad);
    
      ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
    end loop;
  
    
    for j in lineas_ven loop
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
                                                 lc_FlgLn  => lc_Vinculado);
    
      if lc_ven = 'S' and lc_Vinculado <> 'S' then
      
        PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor_venc(j.ln_pgcod10,
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
                                                    Instancia,
                                                    ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
  end sp_cuentas_titular;
  -------------------------------------------------------------------------------------------
  procedure sp_cr_traba_activocaja(pn_pais in numeric,
                                   pn_tdoc in numeric,
                                   pc_ndoc in char,
                                   pv_rpta out varchar2) is
  
    ln_conta number;
  begin
  
    pv_rpta := 'N';
    begin
      select count(*)
        into ln_conta
        from fsd002 t1
      
       where t1.pfpais = pn_pais
         and t1.pftdoc = pn_tdoc
         and t1.pfndoc = pc_ndoc
         and t1.pfebco = 'S';
    exception
      when others then
        ln_conta := 0;
    end;
    if ln_conta > 0 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;
  
  end sp_cr_traba_activocaja;
  ---------------------------------------------------------------------------------------
  procedure sp_cr_calif_rcc_pae(pn_tdoc in numeric,
                                pc_ndoc in char,
                                pv_rpta out varchar2) is
  
    ln_conta  number;    
    lv_codsbs varchar2(12);
    ld_fecha  date;
  begin
  
    pv_rpta := 'N';
    
    begin
      select to_date(substr(tpnro, 1, 2) || '/' || substr(tpnro, 3, 2) || '/' ||
                     substr(tpnro, 5, 4),
                     'dd/mm/yyyy')
        into ld_fecha
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
    begin
      pq_cr_proc_adelanto_sueldo.sp_cr_get_codsbs(pn_tdoc, pc_ndoc, lv_codsbs);
      exception
      when others then
        null;
    end;
    begin
      select count(*)
        into ln_conta
        from cldrcci t2
       where t2.c_codsbs = lv_codsbs
         and t2.d_fecpre between add_months(ld_fecha, -5) and ld_fecha
         and t2.n_calif0 <> 100
         and t2.n_calif0 + t2.n_calif1 + t2.n_calif2 + t2.n_calif3 +
             t2.n_calif4 <> 0;
    exception
      when others then
        ln_conta := 0;
    end;
    if ln_conta > 0 then
      pv_rpta := 'N';
    else
      pv_rpta := 'S';
    end if;
  
  end sp_cr_calif_rcc_pae;
  -----------------------------------------------------------------------------
  procedure sp_cr_maxdias_atraso(pd_fape in date,
                              pn_pais in numeric,
                              pn_tdoc in numeric,
                              pc_ndoc in char,
                              pn_rpta out numeric) is
    ln_diasat number;
    ln_mdiasat number;
    ln_pgcod  number;
    ln_aomod  number;
    ln_aosuc  number;
    ln_aomda  number;
    ln_aopap  number;
    ln_aocta  number;
    ln_aooper number;
    ln_aosbop number;
    ln_aotope number;
    ld_aofvto date;
    ln_aostat number;
  begin
    ln_mdiasat :=0;
    begin
      for insta in (select *
                      from sng001 t3
                     where t3.sng001pais = pn_pais
                       and t3.sng001tdoc = pn_tdoc
                       and t3.sng001ndoc = pc_ndoc) loop
        begin
          select t4.pgcod,
                 t4.aomod,
                 t4.aosuc,
                 t4.aomda,
                 t4.aopap,
                 t4.aocta,
                 t4.aooper,
                 t4.aosbop,
                 t4.aotope,
                 t4.aofvto,
                 t4.aostat
            into ln_pgcod,
                 ln_aomod,
                 ln_aosuc,
                 ln_aomda,
                 ln_aopap,
                 ln_aocta,
                 ln_aooper,
                 ln_aosbop,
                 ln_aotope,
                 ld_aofvto,
                 ln_aostat
            from xwf700 t1
           inner join fsd010 t4
              on t4.pgcod = t1.xwfempresa
             and t4.aomod = t1.xwfmodulo
             and t4.aosuc = t1.xwfsucursal
             and t4.aomda = t1.xwfmoneda
             and t4.aopap = t1.xwfpapel
             and t4.aocta = t1.xwfcuenta
             and t4.aooper = t1.xwfoperacion
             and t4.aosbop = t1.xwfsubope
             and t4.aotope = t1.xwftipope
          
           where t1.xwfprcins = insta.sng001inst
             and t4.aomod in
                 (select g.modulo from fst111 g where g.dscod = 50)
             and t4.aostat <> 99;
          pq_cr_dias_atraso.dias_atraso(pd_fape,
                                        ln_pgcod,
                                        ln_aomod,
                                        ln_aosuc,
                                        ln_aomda,
                                        ln_aopap,
                                        ln_aocta,
                                        ln_aooper,
                                        ln_aosbop,
                                        ln_aotope,
                                        ln_aostat,
                                        ld_aofvto,
                                        ln_diasat);
        exception
          when others then
            ln_diasat := 0;
        end;
        --max
        if ln_diasat > ln_mdiasat then
          ln_mdiasat := ln_diasat;
        end if;
        --exit when ln_diasat > 0; --first
      end loop;
      pn_rpta := ln_mdiasat;
    end;
  
  end sp_cr_maxdias_atraso;
  -------------------------------------------------------------------------------------------------------------------
  Procedure sp_cr_get_codsbs(pn_tipdoc in number,
                             pc_numdoc in char,
                             pv_codsbs out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_get_codsbs
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/08/2021
    -- Autor de Creación          : RMONTESR
    -- Uso                        : RESOLUTOR POLITICA ACUERDO COMITE RIESGOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    --ld_fecrcc      date;
    ln_TipoDni     number(2);
    ln_TipoRuc     number(2);
    ln_TipoCex     number(2);
    lc_C_TDOCID    char(1);
    lc_docide      varchar(12);
    ln_TipCedIdent number;
  
  begin
  
    ln_TipoDni     := 21;
    ln_TipoRuc     := 9;
    ln_TipoCex     := 2;
    ln_TipCedIdent := 10;
  
    /*begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from Fst098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;*/
  
    if pn_tipdoc = ln_TipoDni or pn_tipdoc <> ln_TipoRuc then
      If pn_tipdoc = ln_TipoDni then
        lc_C_TDOCID := '1';
      End If;
      If pn_tipdoc = ln_tipocex or pn_tipdoc = ln_TipCedIdent then
        lc_C_TDOCID := '2';
      End If;
      If pn_tipdoc <> ln_tipodni And pn_tipdoc <> ln_tiporuc and
         lc_C_TDOCID is null then
        lc_C_TDOCID := to_char(pn_tipdoc);
      End If;
    
      lc_docide := trim(pc_numdoc);
    
      begin
        select a.C_CODSBS
          into pv_codsbs
          from CLDRCCI a
         Where C_TDOCID = lc_C_TDOCID
           and C_DOCIDE = lc_docide
           --and D_FECPRE = ld_fecrcc
           and rownum = 1;
      exception
        when no_data_found then
          pv_codsbs := null;
      end;
    
    Else
      If pn_tipdoc = ln_tiporuc then
      
        begin
          select a.C_CODSBS
            into pv_codsbs
            from CLDRCCI a
           Where C_DOCTRI = lc_docide
             --and D_FECPRE = ld_fecrcc
             and rownum = 1;
        exception
          when no_data_found then
            pv_codsbs := null;
        end;
      End If;
    
    end if;
  
  end sp_cr_get_codsbs;

end pq_cr_proc_adelanto_sueldo;
/

