create or replace package PQ_CR_RATIOCNSM_FLJEXP is
  -- *****************************************************************
  -- Nombre                       : PQ_CR_RATIOCNSM_FLJEXP
  -- Sistema                      : BANTOTAL
  -- Módulo                       : ACTIVAS
  -- Descripción                  : Ratio Consumo Flujo Express para Campaña por Caja Movil o HomeBanking
  -- Versión                      : 1.0
  -- Fecha de Creación            : 29/10/2024 23:32:52
  -- Autor de Creación            : MPOSTIGOC
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 25/02/2025
  -- Autor de Modificación        : MPOSTIGOC
  -- Descripción de Modificación  : Se modifico el denominador para el calculo del ratio, ahora se considera ingreso neto
  -- Fecha de Modificación        : 10/10/2025
  -- Autor de Modificación        : MPOSTIGOC
  -- Descripción de Modificación  : Se modifico el denominador para el calculo del ratio, ahora se considera Excedente Mensual
  -- *****************************************************************  

  procedure sp_CalculoRatio(ln_Correlativo in number,
                            ld_fchcorre    in date,
                            lc_Usuario     in varchar2,
                            ln_cuota       in number,
                            ln_captotcaja  out number,
                            saldo_externo  out number,
                            ln_ExcdentMnsl out number,
                            ln_MntPotncial out number,
                            ln_MntCuoCntg  out number,
                            ln_Ratio       out number);
  ---------------------------------------------------
  procedure sp_resolutor(ln_Correlativo in number,
                         ld_fchcorre    in date,
                         ln_Pepais      in number,
                         ln_Petdoc      in number,
                         ln_Pendoc      in char,
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
  -----------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Correlativo  in number,
                                ld_fchcorre     in date,
                                ln_pais         in number,
                                ln_tdoc         in number,
                                lc_ndoc         in varchar2,
                                pd_fecpro       in date,
                                ln_MntCuoCntgCF out number);
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Correlativo    in number,
                                  ld_fchcorre       in date,
                                  ln_pais           in number,
                                  ln_tdoc           in number,
                                  lc_ndoc           in varchar2,
                                  pd_fecpro         in date,
                                  ln_MntCuoCntgAval out number);
  ---------------------------------------------------
  procedure sp_cr_InsertLogAQPB179(ld_fcorr   in date,
                                   ln_corr    in number,
                                   ln_pai     in number,
                                   ln_tdoc    in number,
                                   lc_ndoc    in varchar2,
                                   ln_tcam    in number,
                                   lc_user    in varchar2,
                                   ln_mntca   in number,
                                   ln_mntifi  in number,
                                   ln_cuopot  in number,
                                   ln_cuocont in number,
                                   ln_exdmns  in number,
                                   ln_ratio   in number);
  -----------------------------------------------------------------
  procedure sp_Cr_InsertLogAQPB180(ld_fcorr  in date,
                                   ln_corr   in number,
                                   ln_pai    in number,
                                   ln_tdoc   in number,
                                   lc_ndoc   in varchar2,
                                   ld_fproc  in date,
                                   ln_tcam   in number,
                                   lc_user   in varchar2,
                                   ln_pgcocr in number,
                                   ln_modcr  in number,
                                   ln_succr  in number,
                                   ln_mdacr  in number,
                                   ln_papcr  in number,
                                   ln_ctacr  in number,
                                   ln_opecr  in number,
                                   ln_sopecr in number,
                                   ln_topecr in number,
                                   ln_percre in number,
                                   ln_numcou in number,
                                   ln_tipsol in number,
                                   lc_flucaj in varchar2,
                                   ln_maxpen in number,
                                   ln_segcre in number,
                                   ln_capfcj in number,
                                   ln_caplin in number,
                                   ln_capcuo in number,
                                   lc_indcre in varchar2);
  ----------------------------------------------------
  Procedure Sp_insert_bandeja1(pd_fecpro in date,
                               pn_cor    in number,
                               pd_fec    in date,
                               pd_fecPri in date,
                               ln_seguro in number,
                               lc_Mnsj   out varchar2);
  -----------------------------------------
  Procedure Sp_insert_bandeja2(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pd_Fecpro in date,
                               pc_ase    in char,
                               pn_seg    in number,
                               pn_cor    in number,
                               pd_fecP   in date);
  ---------------------------------------------------------
  Procedure Sp_insert_bandeja3(pn_eva in number);
  -----------------------------------------------
  procedure sp_cr_get_segurodesgra(pn_pais       in number,
                                   pn_tdoc       in number,
                                   pc_ndoc       in VARchar2,
                                   pn_edad       out number,
                                   pn_seg_basico out number,
                                   pn_seg_devolu out number);

end PQ_CR_RATIOCNSM_FLJEXP;
/
create or replace package body PQ_CR_RATIOCNSM_FLJEXP is

  procedure sp_CalculoRatio(ln_Correlativo in number,
                            ld_fchcorre    in date,
                            lc_Usuario     in varchar2,
                            ln_cuota       in number,
                            ln_captotcaja  out number,
                            saldo_externo  out number,
                            ln_ExcdentMnsl out number,
                            ln_MntPotncial out number,
                            ln_MntCuoCntg  out number,
                            ln_Ratio       out number) is
  
    cursor inserta_vencidos(ln_Pepais number,
                            ln_Petdoc number,
                            ln_Pendoc varchar2,
                            pd_fecpro date) is
    
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
         and d10.Aocta in
             (select Ctnro
                from fsr008
               where pepais = ln_Pepais
                 and Petdoc = ln_Petdoc
                 and pendoc = rpad(ln_Pendoc, 12))
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
         and c.pendoc = rpad(ln_Pendoc, 12)
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
  
    cursor inserta(ln_Pepais number,
                   ln_Petdoc number,
                   ln_Pendoc varchar2,
                   pd_fecpro date) is
    
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
         and d10.Aocta in
             (select Ctnro
                from fsr008
               where pepais = ln_Pepais
                 and Petdoc = ln_Petdoc
                 and pendoc = rpad(ln_Pendoc, 12))
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
         and c.pendoc = rpad(ln_Pendoc, 12)
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
  
    cursor vuelo(ln_Pepais number,
                 ln_Petdoc number,
                 ln_Pendoc varchar2,
                 pd_fecpro date) is
    
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
         and x.xwfcuenta in
             (select Ctnro
                from fsr008
               where pepais = ln_Pepais
                 and Petdoc = ln_Petdoc
                 and pendoc = rpad(ln_Pendoc, 12))
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
         and c.pendoc = rpad(ln_Pendoc, 12)
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
  
    cursor lineas_ven(ln_Pepais number,
                      ln_Petdoc number,
                      ln_Pendoc varchar2,
                      pd_fecpro date) is
    
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
         and d10.Aocta in
             (select Ctnro
                from fsr008
               where pepais = ln_Pepais
                 and Petdoc = ln_Petdoc
                 and pendoc = rpad(ln_Pendoc, 12))
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
         and c.pendoc = rpad(ln_Pendoc, 12)
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
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    ln_capacidad      number(17, 2);
    ln_cajaext        number(17, 2);
    lc_FlgLn          varchar2(2);
    lc_fgAdic         varchar2(1);
    lc_fgAmpl         varchar2(1);
    lc_ven            char(1);
    ln_indicador      number(10);
    lc_fgRefLin       varchar2(1);
    ln_captotal1      number(17, 6);
    lc_TieneRL        varchar2(5) := 'N';
    lc_IndCred        varchar2(10);
    ln_MntCuoCntgCF   number;
    ln_MntCuoCntgAval number;
    ln_periodo        number;
    ln_tope10         number;
    ln_Pepais         number;
    ln_Petdoc         number;
    ln_Pendoc         varchar2(12);
    pd_fecpro         date;
    tipocambio        number(14, 8) := 0.00;
    ln_NroEva         number;
    ln_ExcSoles       number(17, 2) := 0.00;
    ln_ExcDolar       number(17, 2) := 0.00;
    ln_sucprop        number := 0;
    ln_mdaprop        number := 0;
    ln_ctaprop        number := 0;
    ln_modprop        number := 0;
    ln_topeprop       number := 0;
    ln_plazo          number := 0;
    ln_nrocuot        number := 0;
    Divisor           number(17, 2) := 0.00;
    ln_IngNetoSol     number(17, 2) := 0.00;
    ln_IngNetoDol     number(17, 2) := 0.00;
    ln_IngNeto        number(17, 2) := 0.00;
  
  begin
  
    ln_captotcaja  := 0;
    saldo_externo  := 0;
    ln_ExcdentMnsl := 0;
    ln_MntPotncial := 0;
    ln_MntCuoCntg  := 0;
    ln_Ratio       := 0.0;
  
    begin
      select a.jaqz697pai, a.jaqz697tdo, a.jaqz697ndo, a.jaqz697eva
        into ln_Pepais, ln_Petdoc, ln_Pendoc, ln_NroEva
        from jaqz697 a
       where a.jaqz697fep = ld_fchcorre
         and a.jaqz697cor = ln_Correlativo
         and a.jaqz697au5 = 'B';
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
    end;
  
    tipocambio := nvl(tipocambio, 1);
  
    begin
      update aqpb179 a
         set a.aqpb179est = 'I'
       where a.aqpb179fcorr = ld_fchcorre
         and a.aqpb179corr = ln_Correlativo;
    
      update aqpb180 a
         set a.aqpb180est = 'I'
       where a.aqpb180fcorr = ld_fchcorre
         and a.aqpb180corr = ln_Correlativo;
      commit;
    end;
  
    for i in inserta(ln_Pepais, ln_Petdoc, ln_Pendoc, pd_fecpro) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
    
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
      
        PQ_CR_RATIOCNSM_FLJEXP.sp_resolutor(ln_Correlativo => ln_Correlativo,
                                            ld_fchcorre    => ld_fchcorre,
                                            ln_Pepais      => ln_Pepais,
                                            ln_Petdoc      => ln_Petdoc,
                                            ln_Pendoc      => ln_Pendoc,
                                            pd_fecpro      => pd_fecpro,
                                            ln_pgcod10     => i.ln_pgcod10,
                                            ln_mod10       => i.ln_mod10,
                                            ln_suc10       => i.ln_suc10,
                                            ln_mda10       => i.ln_mda10,
                                            ln_pap10       => i.ln_pap10,
                                            ln_cta10       => i.ln_cta10,
                                            ln_oper10      => i.ln_oper10,
                                            ln_sbop10      => i.ln_sbop10,
                                            ln_tope10      => i.ln_tope10,
                                            ln_peri10      => i.ln_peri10,
                                            tipocambio     => tipocambio,
                                            ln_indicador   => ln_indicador,
                                            lc_IndCred     => lc_IndCred,
                                            lc_Usuario     => lc_Usuario,
                                            -- lc_TipoCarga   => 'CAJAMOVIL',
                                            ln_capacidad => ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
      end if;
    
    end loop;
  
    for i in inserta_vencidos(ln_Pepais, ln_Petdoc, ln_Pendoc, pd_fecpro) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
    
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
      
        PQ_CR_RATIOCNSM_FLJEXP.sp_resolutor(ln_Correlativo => ln_Correlativo,
                                            ld_fchcorre    => ld_fchcorre,
                                            ln_Pepais      => ln_Pepais,
                                            ln_Petdoc      => ln_Petdoc,
                                            ln_Pendoc      => ln_Pendoc,
                                            pd_fecpro      => pd_fecpro,
                                            ln_pgcod10     => i.ln_pgcod10,
                                            ln_mod10       => i.ln_mod10,
                                            ln_suc10       => i.ln_suc10,
                                            ln_mda10       => i.ln_mda10,
                                            ln_pap10       => i.ln_pap10,
                                            ln_cta10       => i.ln_cta10,
                                            ln_oper10      => i.ln_oper10,
                                            ln_sbop10      => i.ln_sbop10,
                                            ln_tope10      => i.ln_tope10,
                                            ln_peri10      => i.ln_peri10,
                                            tipocambio     => tipocambio,
                                            ln_indicador   => ln_indicador,
                                            lc_IndCred     => lc_IndCred,
                                            lc_Usuario     => lc_Usuario,
                                            -- lc_TipoCarga   => 'CAJAMOVIL',
                                            ln_capacidad => ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
      if i.ln_tope10 = 550 then
        lc_TieneRL := 'S';
      end if;
    
    end loop;
  
    for c in vuelo(ln_Pepais, ln_Petdoc, ln_Pendoc, pd_fecpro) loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      ln_periodo := c.ln_peri10;
    
      begin
        select tp1imp1
          into ln_periodo
          from fst198 f
         where tp1cod = 1 -- mpostigoc 07.02.2022
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
      
        PQ_CR_RATIOCNSM_FLJEXP.sp_resolutor(ln_Correlativo => ln_Correlativo,
                                            ld_fchcorre    => ld_fchcorre,
                                            ln_Pepais      => ln_Pepais,
                                            ln_Petdoc      => ln_Petdoc,
                                            ln_Pendoc      => ln_Pendoc,
                                            pd_fecpro      => pd_fecpro,
                                            ln_pgcod10     => c.ln_pgcod10,
                                            ln_mod10       => c.ln_mod10,
                                            ln_suc10       => c.ln_suc10,
                                            ln_mda10       => c.ln_mda10,
                                            ln_pap10       => c.ln_pap10,
                                            ln_cta10       => c.ln_cta10,
                                            ln_oper10      => c.ln_oper10,
                                            ln_sbop10      => c.ln_sbop10,
                                            ln_tope10      => c.ln_tope10,
                                            ln_peri10      => c.ln_peri10,
                                            tipocambio     => tipocambio,
                                            ln_indicador   => ln_indicador,
                                            lc_IndCred     => lc_IndCred,
                                            lc_Usuario     => lc_Usuario,
                                            --lc_TipoCarga   => 'CAJAMOVIL',
                                            ln_capacidad => ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for j in lineas_ven(ln_Pepais, ln_Petdoc, ln_Pendoc, pd_fecpro) loop
    
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
    
      if lc_ven = 'S' and lc_fgAdic <> 'S' and lc_fgRefLin <> 'S' and
         lc_FlgLn <> 'S' then
      
        PQ_CR_RATIOCNSM_FLJEXP.sp_resolutor(ln_Correlativo => ln_Correlativo,
                                            ld_fchcorre    => ld_fchcorre,
                                            ln_Pepais      => ln_Pepais,
                                            ln_Petdoc      => ln_Petdoc,
                                            ln_Pendoc      => ln_Pendoc,
                                            pd_fecpro      => pd_fecpro,
                                            ln_pgcod10     => j.ln_pgcod10,
                                            ln_mod10       => j.ln_mod10,
                                            ln_suc10       => j.ln_suc10,
                                            ln_mda10       => j.ln_mda10,
                                            ln_pap10       => j.ln_pap10,
                                            ln_cta10       => j.ln_cta10,
                                            ln_oper10      => j.ln_oper10,
                                            ln_sbop10      => j.ln_sbop10,
                                            ln_tope10      => j.ln_tope10,
                                            ln_peri10      => j.ln_peri10,
                                            tipocambio     => tipocambio,
                                            ln_indicador   => ln_indicador,
                                            lc_IndCred     => lc_IndCred,
                                            lc_Usuario     => lc_Usuario,
                                            --  lc_TipoCarga   => 'CAJAMOVIL',
                                            ln_capacidad => ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    begin
      -- Cred Propuesto
    
      begin
        select a.jaqz697suc,
               a.jaqz697mda,
               a.jaqz697cta,
               a.jaqz697mod,
               a.jaqz697top,
               a.jaqz697pzo,
               a.jaqz697cuo
          into ln_sucprop,
               ln_mdaprop,
               ln_ctaprop,
               ln_modprop,
               ln_topeprop,
               ln_plazo,
               ln_nrocuot
          from jaqz697 a
         where a.jaqz697fep = ld_fchcorre
           and a.jaqz697cor = ln_Correlativo;
      exception
        when others then
          null;
      end;
    
      ln_capacidad  := nvl(ln_cuota, 0);
      ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
    
      PQ_CR_RATIOCNSM_FLJEXP.sp_cr_InsertLogAQPB180(ld_fcorr  => ld_fchcorre,
                                                    ln_corr   => ln_Correlativo,
                                                    ln_pai    => ln_Pepais,
                                                    ln_tdoc   => ln_Petdoc,
                                                    lc_ndoc   => ln_Pendoc,
                                                    ld_fproc  => pd_fecpro,
                                                    ln_tcam   => tipocambio,
                                                    lc_user   => lc_Usuario,
                                                    ln_pgcocr => 1,
                                                    ln_modcr  => ln_modprop,
                                                    ln_succr  => ln_sucprop,
                                                    ln_mdacr  => ln_mdaprop,
                                                    ln_papcr  => 0,
                                                    ln_ctacr  => ln_ctaprop,
                                                    ln_opecr  => 0,
                                                    ln_sopecr => 0,
                                                    ln_topecr => ln_topeprop,
                                                    ln_percre => ln_plazo,
                                                    ln_numcou => ln_nrocuot,
                                                    ln_tipsol => 0,
                                                    lc_flucaj => 'N',
                                                    ln_maxpen => ln_cuota,
                                                    ln_segcre => 0,
                                                    ln_capfcj => 0.00,
                                                    ln_caplin => 0.00,
                                                    ln_capcuo => ln_cuota,
                                                    lc_indcre => 'CredProp');
    end;
  
    begin
      -- Cuota Contingente 
      PQ_CR_RATIOCNSM_FLJEXP.sp_cr_CuotaContinCF(ln_Correlativo  => ln_Correlativo,
                                                 ld_fchcorre     => ld_fchcorre,
                                                 ln_pais         => ln_Pepais,
                                                 ln_tdoc         => ln_Petdoc,
                                                 lc_ndoc         => ln_Pendoc,
                                                 pd_fecpro       => pd_fecpro,
                                                 ln_MntCuoCntgCF => ln_MntCuoCntgCF);
    
      PQ_CR_RATIOCNSM_FLJEXP.sp_cr_CuotaContinAval(ln_Correlativo    => ln_Correlativo,
                                                   ld_fchcorre       => ld_fchcorre,
                                                   ln_pais           => ln_Pepais,
                                                   ln_tdoc           => ln_Petdoc,
                                                   lc_ndoc           => ln_Pendoc,
                                                   pd_fecpro         => pd_fecpro,
                                                   ln_MntCuoCntgAval => ln_MntCuoCntgAval);
    
      ln_MntCuoCntg := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
    end;
  
    begin
    
      -- Call the procedure
      PQ_CR_RATIOPYME_DTEN.sp_cR_y327bdj(ln_NroEval     => ln_NroEva,
                                         ln_TipoCamb    => tipocambio,
                                         ln_DeudaIFIS   => saldo_externo,
                                         ln_MntPotncial => ln_MntPotncial);
    
      ln_MntPotncial := nvl(ln_MntPotncial, 0);
      saldo_externo  := nvl(saldo_externo, 0);
    end;
  
    begin
      select a.aqpa190bmto
        into ln_ExcSoles
        from aqpa190b_bdj a
       where a.aqpa190beval = ln_NroEva
         and a.aqpa190bcod = 27;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpa190bmto
        into ln_ExcDolar
        from aqpa190b_bdj a
       where a.aqpa190beval = ln_NroEva
         and a.aqpa190bcod = 527;
    exception
      when others then
        null;
    end;
  
    ln_ExcdentMnsl := nvl(ln_ExcSoles, 0) + nvl(ln_ExcDolar, 0);
  
    /* begin
        --24/02/2025
        begin
          select sum(case
                       when a.aqpa190bcod in (5, 6, 7, 8) then
                        a.aqpa190bmto * -1
                       else
                        a.aqpa190bmto
                     end)
            into ln_IngNetoSol
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_NroEva
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
           where a.aqpa190beval = ln_NroEva
             AND a.aqpa190bcod IN
                 (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512);
        exception
          when others then
            null;
        end;
      
        ln_IngNeto := nvl(ln_IngNetoSol, 0) + nvl(ln_IngNetoDol, 0);
      end;
    */
    begin
    
      -- Suma de Deuda Caja y Deuda Externa
    
      ln_cajaext := nvl(ln_captotcaja, 0) + nvl(saldo_externo, 0) +
                    nvl(ln_MntCuoCntg, 0) + nvl(ln_MntPotncial, 0);
    
      Divisor := nvl(ln_ExcdentMnsl, 0) + nvl(saldo_externo, 0) +
                 nvl(ln_MntPotncial, 0);
    
      --   Divisor := nvl(ln_IngNeto, 0);
    
    end;
  
    if Divisor <> 0 then
      ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    if lc_TieneRL = 'S' then
      -- MPOSTIGOC 20.09.2020
      ln_Ratio := 550;
    else
      if lc_TieneRL = 'N' then
        ln_Ratio := nvl(ln_captotal1, 0);
      end if;
    end if;
  
    PQ_CR_RATIOCNSM_FLJEXP.sp_cr_InsertLogAQPB179(ld_fcorr   => ld_fchcorre,
                                                  ln_corr    => ln_Correlativo,
                                                  ln_pai     => ln_Pepais,
                                                  ln_tdoc    => ln_Petdoc,
                                                  lc_ndoc    => ln_Pendoc,
                                                  ln_tcam    => tipocambio,
                                                  lc_user    => lc_Usuario,
                                                  ln_mntca   => ln_captotcaja,
                                                  ln_mntifi  => saldo_externo,
                                                  ln_cuopot  => ln_MntPotncial,
                                                  ln_cuocont => ln_MntCuoCntg,
                                                  ln_exdmns  => ln_ExcdentMnsl,
                                                  ln_ratio   => ln_Ratio);
  
    ln_ExcdentMnsl := ln_ExcdentMnsl;
  
  end sp_CalculoRatio;
  ---------------------------------------------------
  procedure sp_resolutor(ln_Correlativo in number,
                         ld_fchcorre    in date,
                         ln_Pepais      in number,
                         ln_Petdoc      in number,
                         ln_Pendoc      in char,
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
                                               0,
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
  
    if ln_capacidad > 0 then
    
      if ln_CapFC <> 0 then
        ln_cuotimp := 0;
      end if;
    
      PQ_CR_RATIOCNSM_FLJEXP.sp_Cr_InsertLogAQPB180(ld_fcorr  => ld_fchcorre,
                                                    ln_corr   => ln_Correlativo,
                                                    ln_pai    => ln_Pepais,
                                                    ln_tdoc   => ln_Petdoc,
                                                    lc_ndoc   => ln_Pendoc,
                                                    ld_fproc  => pd_fecpro,
                                                    ln_tcam   => tipocambio,
                                                    lc_user   => lc_Usuario,
                                                    ln_pgcocr => ln_pgcod10,
                                                    ln_modcr  => ln_mod10,
                                                    ln_succr  => ln_suc10,
                                                    ln_mdacr  => ln_mda10,
                                                    ln_papcr  => ln_pap10,
                                                    ln_ctacr  => ln_cta10,
                                                    ln_opecr  => ln_oper10,
                                                    ln_sopecr => ln_sbop10,
                                                    ln_topecr => ln_tope10,
                                                    ln_percre => ln_peri10,
                                                    ln_numcou => ln_nrocuotas,
                                                    ln_tipsol => ln_parciales,
                                                    lc_flucaj => ln_flagFC,
                                                    ln_maxpen => ln_cuotimp,
                                                    ln_segcre => ln_seguro,
                                                    ln_capfcj => ln_CapFC,
                                                    ln_caplin => CapLinea,
                                                    ln_capcuo => ln_capacidad,
                                                    lc_indcre => lc_IndCred);
    
    end if;
  
  end sp_resolutor;
  -------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Correlativo  in number,
                                ld_fchcorre     in date,
                                ln_pais         in number,
                                ln_tdoc         in number,
                                lc_ndoc         in varchar2,
                                pd_fecpro       in date,
                                ln_MntCuoCntgCF out number) is
  
    cursor lista_CredVigCF is
    
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
                             from fsr008 f
                            where f.pepais = ln_pais
                              and f.petdoc = ln_tdoc
                              and f.pendoc = rpad(lc_ndoc, 12)
                              and cttfir = 'T')
         and d10.Aomod = 141
         and d10.Aostat <> 99;
  
    cursor lista_CredvueloCF is
    
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
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = rpad(lc_ndoc, 12)
                                and cttfir = 'T')
         and x.xwfmodulo = 141
         and x.XWFPRCINS = w.wfinsprcid
         and w.wfitemstsact = 1
         and x.xwfcar3 = '1';
  
    ln_CuotCntgAux number;
    ln_SaldCap     number;
    ln_tipocambio  number;
    lc_Usuario     varchar2(10);
    ln_moneda      number;
  
  begin
    ln_MntCuoCntgCF := 0;
  
    ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
  
    if ln_pais is not null then
    
      for l in lista_CredVigCF loop
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100;
      
        begin
        
          PQ_CR_RATIOCNSM_FLJEXP.sp_Cr_InsertLogAQPB180(ld_fcorr  => ld_fchcorre,
                                                        ln_corr   => ln_Correlativo,
                                                        ln_pai    => ln_pais,
                                                        ln_tdoc   => ln_tdoc,
                                                        lc_ndoc   => lc_ndoc,
                                                        ld_fproc  => pd_fecpro,
                                                        ln_tcam   => ln_tipocambio,
                                                        lc_user   => lc_Usuario,
                                                        ln_pgcocr => l.ln_pgcod10,
                                                        ln_modcr  => l.ln_mod10,
                                                        ln_succr  => l.ln_suc10,
                                                        ln_mdacr  => l.ln_mda10,
                                                        ln_papcr  => l.ln_pap10,
                                                        ln_ctacr  => l.ln_cta10,
                                                        ln_opecr  => l.ln_oper10,
                                                        ln_sopecr => l.ln_sbop10,
                                                        ln_topecr => l.ln_tope10,
                                                        ln_percre => l.ln_peri10,
                                                        ln_numcou => 999,
                                                        ln_tipsol => 0,
                                                        lc_flucaj => 'N',
                                                        ln_maxpen => ln_SaldCap,
                                                        ln_segcre => 0,
                                                        ln_capfcj => 0,
                                                        ln_caplin => 0,
                                                        ln_capcuo => ln_CuotCntgAux,
                                                        lc_indcre => 'CredVgntCF');
        
        end;
      
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloCF loop
      
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100;
      
        begin
          PQ_CR_RATIOCNSM_FLJEXP.sp_Cr_InsertLogAQPB180(ld_fcorr  => ld_fchcorre,
                                                        ln_corr   => ln_Correlativo,
                                                        ln_pai    => ln_pais,
                                                        ln_tdoc   => ln_tdoc,
                                                        lc_ndoc   => lc_ndoc,
                                                        ld_fproc  => pd_fecpro,
                                                        ln_tcam   => ln_tipocambio,
                                                        lc_user   => lc_Usuario,
                                                        ln_pgcocr => v.ln_pgcod10,
                                                        ln_modcr  => v.ln_mod10,
                                                        ln_succr  => v.ln_suc10,
                                                        ln_mdacr  => v.ln_mda10,
                                                        ln_papcr  => v.ln_pap10,
                                                        ln_ctacr  => v.ln_cta10,
                                                        ln_opecr  => v.ln_oper10,
                                                        ln_sopecr => v.ln_sbop10,
                                                        ln_topecr => v.ln_tope10,
                                                        ln_percre => 999,
                                                        ln_numcou => 0,
                                                        ln_tipsol => 0,
                                                        lc_flucaj => 'N',
                                                        ln_maxpen => ln_SaldCap,
                                                        ln_segcre => 0,
                                                        ln_capfcj => 0,
                                                        ln_caplin => 0,
                                                        ln_capcuo => ln_CuotCntgAux,
                                                        lc_indcre => 'CredVuelCF');
        end;
      
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Correlativo    in number,
                                  ld_fchcorre       in date,
                                  ln_pais           in number,
                                  ln_tdoc           in number,
                                  lc_ndoc           in varchar2,
                                  pd_fecpro         in date,
                                  ln_MntCuoCntgAval out number) is
  
    cursor lista_CredVigAval is
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
                                and f.pendoc = rpad(lc_ndoc, 12)
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
  
    cursor lista_CredvueloAval is
    
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
                                and f.pendoc = rpad(lc_ndoc, 12)
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
  
    ln_CuotCntgAux number;
    ln_SaldCap     number;
    ln_tipocambio  number;
    lc_Usuario     varchar2(10);
    -- pd_fecpro      date;
  
    ln_moneda    number;
    lc_verfamp   varchar2(2) := 'N';
    lc_vrfrefrep varchar2(2) := 'N';
    lc_verfvinc  varchar2(2) := 'N';
  
  begin
    ln_MntCuoCntgAval := 0;
  
    ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
  
    if ln_pais is not null then
    
      for l in lista_CredVigAval loop
      
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
        
          ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100;
        
          begin
          
            PQ_CR_RATIOCNSM_FLJEXP.sp_Cr_InsertLogAQPB180(ld_fcorr  => ld_fchcorre,
                                                          ln_corr   => ln_Correlativo,
                                                          ln_pai    => ln_pais,
                                                          ln_tdoc   => ln_tdoc,
                                                          lc_ndoc   => lc_ndoc,
                                                          ld_fproc  => pd_fecpro,
                                                          ln_tcam   => ln_tipocambio,
                                                          lc_user   => lc_Usuario,
                                                          ln_pgcocr => l.ln_pgcod10,
                                                          ln_modcr  => l.ln_mod10,
                                                          ln_succr  => l.ln_suc10,
                                                          ln_mdacr  => l.ln_mda10,
                                                          ln_papcr  => l.ln_pap10,
                                                          ln_ctacr  => l.ln_cta10,
                                                          ln_opecr  => l.ln_oper10,
                                                          ln_sopecr => l.ln_sbop10,
                                                          ln_topecr => l.ln_tope10,
                                                          ln_percre => 999,
                                                          ln_numcou => 0,
                                                          ln_tipsol => 0,
                                                          lc_flucaj => 'N',
                                                          ln_maxpen => ln_SaldCap,
                                                          ln_segcre => 0,
                                                          ln_capfcj => 0,
                                                          ln_caplin => 0,
                                                          ln_capcuo => ln_CuotCntgAux,
                                                          lc_indcre => 'CredVgnAvl');
          
          end;
        
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
          ln_MntCuoCntgAval := round(ln_MntCuoCntgAval, 2);
        
        end if;
      end loop;
    
      for v in lista_CredvueloAval loop
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100;
      
        begin
          PQ_CR_RATIOCNSM_FLJEXP.sp_Cr_InsertLogAQPB180(ld_fcorr  => ld_fchcorre,
                                                        ln_corr   => ln_Correlativo,
                                                        ln_pai    => ln_pais,
                                                        ln_tdoc   => ln_tdoc,
                                                        lc_ndoc   => lc_ndoc,
                                                        ld_fproc  => pd_fecpro,
                                                        ln_tcam   => ln_tipocambio,
                                                        lc_user   => lc_Usuario,
                                                        ln_pgcocr => v.ln_pgcod10,
                                                        ln_modcr  => v.ln_mod10,
                                                        ln_succr  => v.ln_suc10,
                                                        ln_mdacr  => v.ln_mda10,
                                                        ln_papcr  => v.ln_pap10,
                                                        ln_ctacr  => v.ln_cta10,
                                                        ln_opecr  => v.ln_oper10,
                                                        ln_sopecr => v.ln_sbop10,
                                                        ln_topecr => v.ln_tope10,
                                                        ln_percre => 999,
                                                        ln_numcou => 0,
                                                        ln_tipsol => 0,
                                                        lc_flucaj => 'N',
                                                        ln_maxpen => ln_SaldCap,
                                                        ln_segcre => 0,
                                                        ln_capfcj => 0,
                                                        ln_caplin => 0,
                                                        ln_capcuo => ln_CuotCntgAux,
                                                        lc_indcre => 'CredVlAval');
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
        ln_MntCuoCntgAval := round(ln_MntCuoCntgAval, 2);
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinAval;
  ---------------------------------------------------
  procedure sp_cr_InsertLogAQPB179(ld_fcorr   in date,
                                   ln_corr    in number,
                                   ln_pai     in number,
                                   ln_tdoc    in number,
                                   lc_ndoc    in varchar2,
                                   ln_tcam    in number,
                                   lc_user    in varchar2,
                                   ln_mntca   in number,
                                   ln_mntifi  in number,
                                   ln_cuopot  in number,
                                   ln_cuocont in number,
                                   ln_exdmns  in number,
                                   ln_ratio   in number) is
  
    lc_hproc varchar2(8) := '00:00:00';
    ln_nreg  number := 0;
    ld_fproc date;
  
  begin
  
    begin
      select max(a.aqpb179nreg)
        into ln_nreg
        from aqpb179 a
       where a.aqpb179fcorr = ld_fcorr
         and a.aqpb179corr = ln_corr;
    exception
      when others then
        ln_nreg := 0;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hproc from dual;
    exception
      when others then
        null;
    end;
  
    ln_nreg := nvl(ln_nreg, 0);
  
    begin
      select f.pgfape into ld_fproc from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb179
        (aqpb179nreg,
         aqpb179fcorr,
         aqpb179corr,
         aqpb179pai,
         aqpb179tdoc,
         aqpb179ndoc,
         aqpb179tcam,
         aqpb179fproc,
         aqpb179hproc,
         aqpb179user,
         aqpb179mntca,
         aqpb179mntifi,
         aqpb179cuopot,
         aqpb179cuocont,
         aqpb179exdmns,
         aqpb179ratio,
         aqpb179est,
         aqpb179tcarg)
      values
        (ln_nreg + 1,
         ld_fcorr,
         ln_corr,
         ln_pai,
         ln_tdoc,
         lc_ndoc,
         ln_tcam,
         ld_fproc,
         lc_hproc,
         lc_user,
         ln_mntca,
         ln_mntifi,
         ln_cuopot,
         ln_cuocont,
         ln_exdmns,
         ln_ratio,
         'H',
         'CAJAMOVIL');
    
      commit;
    
    end;
  
  end sp_cr_InsertLogAQPB179;
  ----------------------------------------------
  procedure sp_Cr_InsertLogAQPB180(ld_fcorr  in date,
                                   ln_corr   in number,
                                   ln_pai    in number,
                                   ln_tdoc   in number,
                                   lc_ndoc   in varchar2,
                                   ld_fproc  in date,
                                   ln_tcam   in number,
                                   lc_user   in varchar2,
                                   ln_pgcocr in number,
                                   ln_modcr  in number,
                                   ln_succr  in number,
                                   ln_mdacr  in number,
                                   ln_papcr  in number,
                                   ln_ctacr  in number,
                                   ln_opecr  in number,
                                   ln_sopecr in number,
                                   ln_topecr in number,
                                   ln_percre in number,
                                   ln_numcou in number,
                                   ln_tipsol in number,
                                   lc_flucaj in varchar2,
                                   ln_maxpen in number,
                                   ln_segcre in number,
                                   ln_capfcj in number,
                                   ln_caplin in number,
                                   ln_capcuo in number,
                                   lc_indcre in varchar2) is
  
    lc_hproc varchar2(8) := '00:00:00';
    ln_nreg  number := 0;
  
  begin
  
    begin
      select max(a.aqpb180nreg)
        into ln_nreg
        from aqpb180 a
       where a.aqpb180fcorr = ld_fcorr
         and a.aqpb180corr = ln_corr;
    exception
      when others then
        ln_nreg := 0;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hproc from dual;
    exception
      when others then
        null;
    end;
  
    ln_nreg := nvl(ln_nreg, 0);
  
    begin
      insert into aqpb180
        (aqpb180nreg,
         aqpb180fcorr,
         aqpb180corr,
         aqpb180pai,
         aqpb180tdoc,
         aqpb180ndoc,
         aqpb180fproc,
         aqpb180hproc,
         aqpb180tcam,
         aqpb180user,
         aqpb180pgcocr,
         aqpb180modcr,
         aqpb180succr,
         aqpb180mdacr,
         aqpb180papcr,
         aqpb180ctacr,
         aqpb180opecr,
         aqpb180sopecr,
         aqpb180topecr,
         aqpb180percre,
         aqpb180numcou,
         aqpb180tipsol,
         aqpb180flucaj,
         aqpb180maxpen,
         aqpb180segcre,
         aqpb180capfcj,
         aqpb180caplin,
         aqpb180capcuo,
         aqpb180indcre,
         aqpb180est,
         aqpb180tcarg)
      values
        (ln_nreg + 1,
         ld_fcorr,
         ln_corr,
         ln_pai,
         ln_tdoc,
         lc_ndoc,
         ld_fproc,
         lc_hproc,
         ln_tcam,
         lc_user,
         ln_pgcocr,
         ln_modcr,
         ln_succr,
         ln_mdacr,
         ln_papcr,
         ln_ctacr,
         ln_opecr,
         ln_sopecr,
         ln_topecr,
         ln_percre,
         ln_numcou,
         ln_tipsol,
         lc_flucaj,
         ln_maxpen,
         ln_segcre,
         ln_capfcj,
         ln_caplin,
         ln_capcuo,
         lc_indcre,
         'H',
         'CAJAMOVIL');
      commit;
    
    end;
  end sp_Cr_InsertLogAQPB180;
  ----------------------------------------------------
  Procedure Sp_insert_bandeja1(pd_fecpro in date,
                               pn_cor    in number,
                               pd_fec    in date,
                               pd_fecPri in date,
                               ln_seguro in number,
                               lc_Mnsj   out varchar2) is
  
    ld_Fecaux   date;
    lc_hab      char(1) := 'N';
    ln_cont     number(5);
    pd_fecprim  date;
    pn_HisNR    number(1);
    ln_Corr     number(9);
    lc_estado   char(1);
    ln_flgProc  number(5) := 0;
    ln_Cor751   number(9);
    lc_existe   char(1) := 'N';
    lc_flgAmpl  char(30) := 'N';
    ln_mod      number(3);
    ln_suc      number(3);
    ln_mda      number(4);
    ln_cta      number(9);
    ln_top      number(3);
    lc_reactiva char(1) := 'N';
    pn_pai      number;
    pn_tdo      number;
    pc_ndo      varchar2(12);
    pn_mto      number(17, 2) := 0.00;
    pc_ase      varchar2(10);
    pn_pzo      number(5);
    pn_cuo      number(9);
    ln_eva      number(10);
    ln_moe      number(5);
  
    --0 se ejecuta proceso de fintech
    --1 se ejecuta proceso de flujo online
  
  begin
  
    begin
      select a.jaqz697pai,
             a.jaqz697tdo,
             a.jaqz697ndo,
             a.jaqz697suc,
             a.jaqz697mda,
             a.jaqz697cta,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697ase,
             a.jaqz697mto,
             a.jaqz697pzo,
             a.jaqz697cuo,
             a.jaqz697moe,
             a.jaqz697eva
        into pn_pai,
             pn_tdo,
             pc_ndo,
             ln_suc,
             ln_mda,
             ln_cta,
             ln_mod,
             ln_top,
             pc_ase,
             pn_mto,
             pn_pzo,
             pn_cuo,
             ln_moe,
             ln_eva
        from jaqz697 a
       where a.jaqz697fep = pd_fec
         and a.jaqz697cor = pn_cor;
      /* exception
      when others then
        null;*/
    end;
  
    --mod@abr 20200623
    begin
      select 'S'
        into lc_reactiva
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 11
         and a.tp1corr2 = 1
         and a.tp1nro1 = ln_mod
         and a.tp1nro2 = ln_top;
    exception
      when others then
        null;
    end;
    --mod@abr 20200623
  
    begin
      select 'S'
        into lc_existe
        from jaqz697 j, jaqm750 k
       where j.jaqz697pai = k.jaqm750pai
         and j.jaqz697tdo = k.jaqm750tdo
         and j.jaqz697ndo = k.jaqm750ndo
         and j.jaqz697suc = k.jaqm750suc
         and j.jaqz697mda = k.jaqm750mda
         and j.jaqz697cta = k.jaqm750cta
         and j.jaqz697mod = k.jaqm750mod
         and j.jaqz697top = k.jaqm750tip
         and j.jaqz697pai = pn_pai
         and j.jaqz697tdo = pn_tdo
         and j.jaqz697ndo = pc_ndo
         and j.jaqz697cor = pn_cor --mod@abr 20191210
         and k.jaqm750fch >= j.jaqz697fep
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if nvl(lc_existe, 'N') = 'N' then
      --**Verifica si es ampliado**--
      begin
        select a.tp1nro1
          into ln_flgProc
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 77777
           and a.tp1corr2 = 1
           and a.tp1corr3 = 1;
      exception
        when others then
          ln_flgProc := 0;
      end;
    
      if nvl(ln_flgProc, 0) = 0 then
        --flujo express
        begin
          select TRIM(a.tp1desc)
            into lc_estado
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 77777
             and a.tp1corr2 = 2
             and a.tp1corr3 = 2;
        exception
          when others then
            null;
        end;
      else
        --flujo online
        begin
          select trim(a.tp1desc)
            into lc_estado
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 77777
             and a.tp1corr2 = 2
             and a.tp1corr3 = 1;
        exception
          when others then
            null;
        end;
      end if;
    
      ---------FECHA PRIMER PAGO--------------
      --ld_Fecaux := pd_fecpro + pn_pzo;
      ld_Fecaux := pd_fecPri;
      --verificar si es dia habil
      begin
        select a.fhabil
          into lc_hab
          from fst028 a, fst001 b
         where a.calcod = b.calcod
           and a.ffecha = ld_Fecaux
           and b.sucurs = ln_suc;
      exception
        when others then
          null;
      end;
    
      if nvl(lc_hab, 'N') = 'N' then
        begin
          select min(a.ffecha)
            into pd_fecprim
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha > ld_Fecaux
             and b.sucurs = ln_suc
             and a.fhabil = 'S';
        exception
          when others then
            null;
        end;
      else
        pd_fecprim := ld_Fecaux;
      end if;
    
      ---------------------NUEVO/RECURRENTE-----------------
      Pq_Cr_Relcrediticia.Sp_RelCredi_NR(pn_pai      => pn_pai,
                                         pn_tdo      => pn_tdo,
                                         pc_ndo      => pc_ndo,
                                         pd_Fecpro   => pd_fecpro,
                                         ln_contador => ln_cont);
    
      if ln_cont >= 6 then
        pn_HisNR := 2; --Recurrente
      end if;
    
      if ln_cont < 6 then
        pn_HisNR := 1; --Nuevo
      end if;
    
      if nvl(ln_flgProc, 0) = 0 then
        --proceso fintech
        begin
          select nvl(max(jaqm750reg), 0) + 1
            into ln_Corr
            from jaqm750
           where jaqm750fch = pd_fecpro
             and jaqm750reg < 1000000;
        exception
          when others then
            ln_Corr := null;
        end;
      
        if nvl(ln_Corr, 0) = 0 then
          ln_Corr := 1;
        end if;
      
      else
        --proceso flujo online
        begin
          select nvl(max(jaqm750reg), 0) + 1
            into ln_Corr
            from jaqm750
           where jaqm750fch = pd_fecpro
             and jaqm750reg >= 1000000;
        exception
          when others then
            ln_Corr := null;
        end;
      
        if nvl(ln_Corr, 0) = 1 then
          ln_Corr := 1000000;
        end if;
      
      end if;
      lc_flgAmpl := nvl(lc_flgAmpl, 'N');
    
      if lc_flgAmpl = 'N' then
      
        --mod@abr 20210505
        if ln_mod = 117 then
          Insert into JAQM750
          values
            (1,
             pd_fecpro,
             ln_Corr,
             pn_pai,
             pn_tdo,
             pc_ndo,
             0,
             11,
             pn_HisNR,
             ln_mod,
             ln_top,
             ln_suc,
             ln_mda,
             0,
             ln_cta,
             pc_ase,
             2,
             1,
             pd_fecprim,
             pn_mto,
             pn_cuo,
             pn_pzo,
             lc_estado);
          commit;
        
        else
          Insert into JAQM750
          values
            (1,
             pd_fecpro,
             ln_Corr,
             pn_pai,
             pn_tdo,
             pc_ndo,
             0,
             0,
             pn_HisNR,
             ln_mod,
             ln_top,
             ln_suc,
             ln_mda,
             0,
             ln_cta,
             pc_ase,
             2,
             1,
             pd_fecprim,
             pn_mto,
             pn_cuo,
             pn_pzo,
             lc_estado);
        
          commit;
        end if;
        ---INSERTAR JAQM751 SEGUROS
        if nvl(lc_reactiva, 'N') = 'N' then
        
          begin
            -- Desgravamen
            /* begin
              select a.tp1nro1
                into ln_seg
                from fst198 a
               where a.tp1cod = 1
                 and a.tp1cod1 = 10899
                 and a.tp1corr1 = 77777
                 and a.tp1corr2 = 3
                 and a.tp1nro2 = pn_pzo
                 and a.tp1nro3 = pn_moe;
            exception
              when others then
                ln_seg := 0;
            end;*/
          
            begin
              select nvl(max(a.jaqm751cor), 0) + 1
                into ln_Cor751
                from jaqm751 a
               where a.jaqm751emp = 1
                 and a.jaqm751fch = pd_fecpro
                 and a.jaqm751att = 'SEGCOD'
                 and a.jaqm751reg = ln_Corr;
            exception
              when others then
                ln_Cor751 := null;
            end;
          
            if nvl(ln_Cor751, 0) = 1 then
              ln_Cor751 := 1;
            end if;
          
            insert into jaqm751
              (jaqm751emp,
               jaqm751fch,
               jaqm751reg,
               jaqm751att,
               jaqm751cor,
               jaqm751val)
            values
              (1, pd_fecpro, ln_Corr, 'SEGCOD', ln_Cor751, ln_seguro);
            commit;
          end;
        end if;
      end if;
    
      pq_cr_ratiocnsm_fljexp.Sp_insert_bandeja2(pn_pai    => pn_pai,
                                                pn_tdo    => pn_tdo,
                                                pc_ndo    => pc_ndo,
                                                pd_Fecpro => pd_fecpro,
                                                pc_ase    => pc_ase,
                                                pn_seg    => ln_moe,
                                                pn_cor    => pn_cor,
                                                pd_fecP   => pd_fec);
    
      pq_cr_ratiocnsm_fljexp.Sp_insert_bandeja3(pn_eva => ln_eva);
    
      lc_Mnsj := 'Procesado Correctamente';
    
    end if;
  end Sp_insert_bandeja1;
  ----------------------------------------------------
  Procedure Sp_insert_bandeja2(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pd_Fecpro in date,
                               pc_ase    in char,
                               pn_seg    in number,
                               pn_cor    in number,
                               pd_fecP   in date) is
  
    lc_existe char(1) := 'N';
    ln_eva    number(10);
  
  begin
  
    begin
      select a.jaqz697eva
        into ln_eva
        from jaqz697 a
       where a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo
         and a.jaqz697cor = pn_cor
         and a.jaqz697fep = pd_fecP;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_existe
        from jaqz697 j, Aqpa190a k
       where j.jaqz697pai = k.aqpa190apdoc
         and j.jaqz697tdo = k.aqpa190atdoc
         and j.jaqz697ndo = k.aqpa190andoc
         and j.jaqz697ase = k.aqpa190ausu
         and j.jaqz697pai = pn_pai
         and j.jaqz697tdo = pn_tdo
         and j.jaqz697ndo = pc_ndo
         and j.jaqz697cor = pn_cor
         and j.jaqz697eva = k.aqpa190aeval
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if nvl(lc_existe, 'N') = 'N' then
      Insert into Aqpa190a
        (Aqpa190aeval,
         Aqpa190apdoc,
         Aqpa190atdoc,
         Aqpa190andoc,
         Aqpa190afec,
         Aqpa190ausu,
         Aqpa190asol,
         Aqpa190atmod)
      values
        (ln_eva, pn_pai, pn_tdo, pc_ndo, pd_Fecpro, pc_ase, 0, pn_seg);
    
      commit;
    end if;
  
  end Sp_insert_bandeja2;
  ---------------------------------------------------------------------------
  Procedure Sp_insert_bandeja3(pn_eva in number) is
  
    cursor evaluacion(cn_eva in number) is
      select * from aqpa190b_bdj a where a.aqpa190beval = cn_eva;
  
    ln_eva    number(10);
    lc_existe char(1);
  begin
  
    /* begin
      select a.jaqz697eva
        into ln_eva
        from jaqz697 a
       where a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo
         and a.jaqz697cor = pn_corr
         and a.jaqz697fep = pd_fecP;
      /* exception
      when others then
        null;
    end;*/
  
    begin
      select 'S'
        into lc_existe
        from AQPA190b a
       where a.aqpa190beval = ln_eva
         and rownum = 1;
    exception
      when others then
        lc_existe := 'N';
    end;
  
    if nvl(lc_existe, 'N') = 'N' then
      for i in evaluacion(pn_eva) loop
      
        insert into AQPA190b
        values
          (i.aqpa190beval, i.aqpa190bcod, i.aqpa190bmto);
        commit;
      end loop;
    end if;
  
  end Sp_insert_bandeja3;
  ------------------------------------------------------------------------------
  procedure sp_cr_get_segurodesgra(pn_pais       in number,
                                   pn_tdoc       in number,
                                   pc_ndoc       in VARchar2,
                                   pn_edad       out number,
                                   pn_seg_basico out number,
                                   pn_seg_devolu out number) is
    ld_fnac date;
    --ln_edad     numeric;
  begin
    begin
      select a.pffnac
        into ld_fnac
        from fsd002 a
       where a.pfpais = pn_pais
         and a.pftdoc = pn_tdoc
         and a.pfndoc = rpad(pc_ndoc, 12);
    exception
      when others then
        null;
    end;
    begin
      select floor(months_between(b.pgfape, ld_fnac) / 12)
        into pn_edad
        from fst017 b
       where b.pgcod = 1;
    exception
      when others then
        null;
    end;
    --basico
    if pn_edad >= 71 then
      pn_seg_basico := 393;
    else
      pn_seg_basico := 363;
    end if;
    --devolucion
    if pn_edad >= 71 then
      pn_seg_devolu := 453;
    else
      if pn_edad >= 61 then
        pn_seg_devolu := 483;
      else
        pn_seg_devolu := 423;
      end if;
    end if;
  end sp_cr_get_segurodesgra;
end PQ_CR_RATIOCNSM_FLJEXP;
/
