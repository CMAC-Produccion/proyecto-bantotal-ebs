create or replace package PQ_CR_RATIO_CONVCONS_IN is

  -- Author  : MPOSTIGOC
  -- Created : 10/10/2018 4:33:10 p. m.
  -- Purpose : 
  -- Ratio Convenio Consumo Ingreso Neto

  procedure sp_Cr_Inicio(ln_Instancia in number, ln_Ratio out number);
  --------------------------------------------------------------
  procedure sp_cr_inicioReporte(ln_Instancia in number,
                                ln_Ratio     out number);
  ---------------------------------------------------------------
  procedure sp_refinanLinea(ln_pgcod10  in number,
                            ln_mod10    in number,
                            ln_suc10    in number,
                            ln_mda10    in number,
                            ln_pap10    in number,
                            ln_cta10    in number,
                            ln_oper10   in number,
                            lc_fgRefLin out varchar2);
  ------------------------------------------------------------
  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out varchar2);
  -----------------------------------------------------------------
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
  -----------------------------------------------------------
  procedure sp_nrocuotas(ln_pgcod10    in number,
                         ln_mod10      in number,
                         ln_suc10      in number,
                         ln_mda10      in number,
                         ln_pap10      in number,
                         ln_cta10      in number,
                         ln_oper10     in number,
                         ln_sbop10     in number,
                         ln_tope10     in number,
                         ln_NRO_CUOTAS out number);
  -------------------------------------------------------------
  procedure sp_cuota_impaga(ln_pgcod10  in number,
                            ln_mod10    in number,
                            ln_suc10    in number,
                            ln_mda10    in number,
                            ln_pap10    in number,
                            ln_cta10    in number,
                            ln_oper10   in number,
                            ln_sbop10   in number,
                            ln_tope10   in number,
                            tipocambio  in number,
                            ln_Mxcuoimp out number);
  ------------------------------------------------------------
  procedure sp_cr_SaldIFIS(ln_Instancia in number, ln_SaldIFIS out number);

  ---------------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais      in number,
                           ln_Petdoc      in number,
                           ln_Pendoc      in char,
                           tipocambio     in number,
                           Instancia      in number,
                           pd_fecpro      in date,
                           ln_captotcaja  in number,
                           saldo_externo  in number,
                           ln_IngNeto     in number,
                           ln_RatConvCons in number,
                           lc_indicador   in varchar2,
                           lc_flgprg      in varchar2,
                           lc_Usuario     in varchar2);
  ------------------------------------------------------------------
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
                             ln_CAPCUO    in number,
                             lc_IndCred   IN VARCHAR2,
                             lc_flgprg    in varchar2,
                             lc_Usuario   in varchar2);
  --------------------------------------------------------                                                        

end PQ_CR_RATIO_CONVCONS_IN;
/

create or replace package body PQ_CR_RATIO_CONVCONS_IN is

  procedure sp_Cr_Inicio(ln_Instancia in number, ln_Ratio out number) is
  
    cursor lista_credvignt(ln_Pepais number,
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and d10.Aomod = 107
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro;
  
    cursor lista_credvuelo(ln_Pepais number,
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
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc
                                and Ttcod = 1
                                and Cttfir = 'T')
            
         and x.xwfmodulo = 107
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
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
                x.xwftipope;
  
    ln_Evaluacion  number;
    ln_MontIN      number := 0;
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ld_fchsist     date;
    lc_fgRefLin    varchar2(2) := 'N';
    lc_fgAdic      varchar2(2) := 'N';
    lc_fgAmpl      varchar2(2) := 'N';
    lc_FlgLn       varchar2(2) := 'N';
    ln_nrocuotas   number := 0;
    ln_MxcuoimpAux number(17, 2) := 0;
    ln_tipocambio  number;
    ln_Mxcuoimp    number(17, 2) := 0;
    lc_Usuario     varchar2(12);
    ln_flagFC      varchar2(2) := 'N';
    ln_SaldIFIS    number(17, 2);
    ln_Tarea       number;
  
  begin
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        ln_Tarea := 0;
    end;
  
    if ln_Tarea = 7 then
    
      begin
        update jaqz835 j
           set j.jaqz835est = 'I'
         where j.jaqz835inst = ln_Instancia
           and j.jaqz835est = 'H';
        commit;
      end;
    
      begin
        UPDATE JAQZ836 j
           set j.jaqz836est = 'I'
         where j.JAQZ836inst = ln_Instancia
           and j.JAQZ836est = 'H';
        commit;
      end;
    end if;
  
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
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    end;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod)
        into lc_Usuario
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    for l in lista_credvignt(ln_pais, ln_tdoc, lc_ndoc, ld_fchsist) loop
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(l.ln_pgcod10,
                                          l.ln_mod10,
                                          l.ln_suc10,
                                          l.ln_mda10,
                                          l.ln_pap10,
                                          l.ln_cta10,
                                          l.ln_oper10,
                                          lc_fgRefLin);
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(l.ln_mod10,
                                          l.ln_tope10,
                                          lc_fgAdic);
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(l.ln_pgcod10,
                                          l.ln_mod10,
                                          l.ln_suc10,
                                          l.ln_mda10,
                                          l.ln_pap10,
                                          l.ln_cta10,
                                          l.ln_oper10,
                                          l.ln_sbop10,
                                          l.ln_tope10,
                                          lc_fgAmpl);
    
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
    
      if lc_fgRefLin = 'N' and lc_fgAdic = 'N' and lc_fgAmpl = 'N' and
         lc_FlgLn = 'N' then
      
        pq_cr_ratio_convcons_in.sp_nrocuotas(ln_pgcod10    => l.ln_pgcod10,
                                             ln_mod10      => l.ln_mod10,
                                             ln_suc10      => l.ln_suc10,
                                             ln_mda10      => l.ln_mda10,
                                             ln_pap10      => l.ln_pap10,
                                             ln_cta10      => l.ln_cta10,
                                             ln_oper10     => l.ln_oper10,
                                             ln_sbop10     => l.ln_sbop10,
                                             ln_tope10     => l.ln_tope10,
                                             ln_NRO_CUOTAS => ln_nrocuotas);
      
        PQ_CR_RATIO_CUOCNSM.sp_cr_flujocaja(l.ln_pgcod10,
                                            l.ln_mod10,
                                            l.ln_suc10,
                                            l.ln_mda10,
                                            l.ln_pap10,
                                            l.ln_cta10,
                                            l.ln_oper10,
                                            l.ln_sbop10,
                                            l.ln_tope10,
                                            ln_flagFC);
        IF ln_flagFC = 'N' then
        
          pq_cr_ratio_convcons_in.sp_cuota_impaga(l.ln_pgcod10,
                                                  l.ln_mod10,
                                                  l.ln_suc10,
                                                  l.ln_mda10,
                                                  l.ln_pap10,
                                                  l.ln_cta10,
                                                  l.ln_oper10,
                                                  l.ln_sbop10,
                                                  l.ln_tope10,
                                                  ln_tipocambio,
                                                  ln_MxcuoimpAux);
        
        else
          if ln_flagFC = 'S' then
          
            PQ_CR_RATIO_CUOCNSM.sp_cr_capacidadFC(l.ln_mod10,
                                                  l.ln_suc10,
                                                  l.ln_mda10,
                                                  l.ln_pap10,
                                                  l.ln_cta10,
                                                  l.ln_oper10,
                                                  l.ln_sbop10,
                                                  l.ln_tope10,
                                                  ln_tipocambio,
                                                  ln_MxcuoimpAux);
          
          end if;
        end if;
      
        if ln_Tarea = 7 then
          pq_cr_ratio_convcons_in.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                   lnPetdoc     => ln_tdoc,
                                                   lnPendoc     => lc_ndoc,
                                                   tipocambio   => ln_tipocambio,
                                                   Instancia    => ln_Instancia,
                                                   pd_fecpro    => ld_fchsist,
                                                   ln_PGCOD     => l.ln_pgcod10,
                                                   ln_MOD       => l.ln_mod10,
                                                   ln_SUC       => l.ln_suc10,
                                                   ln_MDA       => l.ln_mda10,
                                                   ln_PAP       => l.ln_pap10,
                                                   ln_CTA       => l.ln_cta10,
                                                   ln_OPE       => l.ln_oper10,
                                                   ln_SBOP      => l.ln_sbop10,
                                                   ln_TOPE      => l.ln_tope10,
                                                   ln_peri10    => l.ln_peri10,
                                                   ln_nrocuotas => ln_nrocuotas,
                                                   ln_CAPCUO    => ln_MxcuoimpAux,
                                                   lc_IndCred   => 'CredVignt',
                                                   lc_flgprg    => 'S',
                                                   lc_Usuario   => lc_Usuario);
        end if;
      
        ln_Mxcuoimp := nvl(ln_Mxcuoimp, 0) + nvl(ln_MxcuoimpAux, 0);
      
      end if;
    
    end loop;
  
    for k in lista_credvuelo(ln_pais, ln_tdoc, lc_ndoc, ld_fchsist) loop
    
      pq_cr_ratio_convcons_in.sp_nrocuotas(ln_pgcod10    => k.ln_pgcod10,
                                           ln_mod10      => k.ln_mod10,
                                           ln_suc10      => k.ln_suc10,
                                           ln_mda10      => k.ln_mda10,
                                           ln_pap10      => k.ln_pap10,
                                           ln_cta10      => k.ln_cta10,
                                           ln_oper10     => k.ln_oper10,
                                           ln_sbop10     => k.ln_sbop10,
                                           ln_tope10     => k.ln_tope10,
                                           ln_NRO_CUOTAS => ln_nrocuotas);
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_flujocaja(k.ln_pgcod10,
                                          k.ln_mod10,
                                          k.ln_suc10,
                                          k.ln_mda10,
                                          k.ln_pap10,
                                          k.ln_cta10,
                                          k.ln_oper10,
                                          k.ln_sbop10,
                                          k.ln_tope10,
                                          ln_flagFC);
      IF ln_flagFC = 'N' then
      
        pq_cr_ratio_convcons_in.sp_cuota_impaga(k.ln_pgcod10,
                                                k.ln_mod10,
                                                k.ln_suc10,
                                                k.ln_mda10,
                                                k.ln_pap10,
                                                k.ln_cta10,
                                                k.ln_oper10,
                                                k.ln_sbop10,
                                                k.ln_tope10,
                                                ln_tipocambio,
                                                ln_MxcuoimpAux);
      
      else
        if ln_flagFC = 'S' then
        
          PQ_CR_RATIO_CUOCNSM.sp_cr_capacidadFC(k.ln_mod10,
                                                k.ln_suc10,
                                                k.ln_mda10,
                                                k.ln_pap10,
                                                k.ln_cta10,
                                                k.ln_oper10,
                                                k.ln_sbop10,
                                                k.ln_tope10,
                                                ln_tipocambio,
                                                ln_MxcuoimpAux);
        
        end if;
      end if;
    
      if ln_Tarea = 7 then
        pq_cr_ratio_convcons_in.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                 lnPetdoc     => ln_tdoc,
                                                 lnPendoc     => lc_ndoc,
                                                 tipocambio   => ln_tipocambio,
                                                 Instancia    => ln_Instancia,
                                                 pd_fecpro    => ld_fchsist,
                                                 ln_PGCOD     => k.ln_pgcod10,
                                                 ln_MOD       => k.ln_mod10,
                                                 ln_SUC       => k.ln_suc10,
                                                 ln_MDA       => k.ln_mda10,
                                                 ln_PAP       => k.ln_pap10,
                                                 ln_CTA       => k.ln_cta10,
                                                 ln_OPE       => k.ln_oper10,
                                                 ln_SBOP      => k.ln_sbop10,
                                                 ln_TOPE      => k.ln_tope10,
                                                 ln_peri10    => k.ln_peri10,
                                                 ln_nrocuotas => ln_nrocuotas,
                                                 ln_CAPCUO    => ln_MxcuoimpAux,
                                                 lc_IndCred   => 'CredVuelo',
                                                 lc_flgprg    => 'S',
                                                 lc_Usuario   => lc_Usuario);
      end if;
      ln_Mxcuoimp := ln_Mxcuoimp + ln_MxcuoimpAux;
    
    end loop;
  
    begin
      -- Monto Ingreso Neto
      begin
        select SNG021EVAL
          into ln_Evaluacion
          from sng021
         where sng021sol = ln_Instancia;
      exception
        when others then
          null;
      end;
    
      begin
        select sum(case
                     when sng026cod in (5) then
                      sng023mto * -1
                     else
                      sng023mto
                   end)
          into ln_MontIN
          from sng023
         where sng021eval = ln_Evaluacion
           and sng026cod in (1, 5);
      exception
        when others then
          null;
      end;
    end;
  
    begin
      -- Deuda del Sistema Financiero SOLO CONVENIOS
      pq_cr_ratio_convcons_in.sp_cr_SaldIFIS(ln_Instancia, ln_SaldIFIS);
    
    end;
  
    ln_Mxcuoimp := nvl(ln_Mxcuoimp, 0); --mpostigoc 071118
    ln_MontIN   := nvl(ln_MontIN, 0); --mpostigoc 071118
  
    if ln_MontIN <> 0 then
      --mpostigoc 071118
      begin
        ln_Ratio := round((ln_Mxcuoimp + ln_SaldIFIS) / ln_MontIN, 6);
      end;
    
      if ln_Tarea = 7 then
        begin
        
          pq_cr_ratio_convcons_in.sp_cr_LogRatio(ln_Pepais      => ln_pais,
                                                 ln_Petdoc      => ln_tdoc,
                                                 ln_Pendoc      => lc_ndoc,
                                                 tipocambio     => ln_tipocambio,
                                                 Instancia      => ln_Instancia,
                                                 pd_fecpro      => ld_fchsist,
                                                 ln_captotcaja  => ln_Mxcuoimp,
                                                 saldo_externo  => ln_SaldIFIS,
                                                 ln_IngNeto     => ln_MontIN,
                                                 ln_RatConvCons => ln_Ratio,
                                                 lc_indicador   => 'CC',
                                                 lc_flgprg      => 'S',
                                                 lc_Usuario     => lc_Usuario);
        
        end;
      end if;
    end if;
  
  end sp_cr_inicio;
  ----------------------------------------------

  procedure sp_cr_inicioReporte(ln_Instancia in number,
                                ln_Ratio     out number) is
  
    cursor lista_credvignt(ln_Pepais number,
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and d10.Aomod = 107
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro;
  
    cursor lista_credvuelo(ln_Pepais number,
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
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc
                                and Ttcod = 1
                                and Cttfir = 'T')
            
         and x.xwfmodulo = 107
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
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
                x.xwftipope;
  
    ln_Evaluacion  number;
    ln_MontIN      number := 0;
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ld_fchsist     date;
    lc_fgRefLin    varchar2(2) := 'N';
    lc_fgAdic      varchar2(2) := 'N';
    lc_fgAmpl      varchar2(2) := 'N';
    lc_FlgLn       varchar2(2) := 'N';
    ln_nrocuotas   number := 0;
    ln_MxcuoimpAux number(17, 2) := 0;
    ln_tipocambio  number;
    ln_Mxcuoimp    number(17, 2) := 0;
    lc_Usuario     varchar2(12);
    ln_flagFC      varchar2(2) := 'N';
    ln_SaldIFIS    number(17, 2);
  
  begin
  
    begin
      delete JAQZ836 j
       where j.JAQZ836inst = ln_Instancia
         and j.JAQZ836est = 'R';
      commit;
      delete JAQZ835 j
       where j.JAQZ835inst = ln_Instancia
         and j.JAQZ835est = 'R';
      commit;
    
    end;
  
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
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    end;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod)
        into lc_Usuario
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    for l in lista_credvignt(ln_pais, ln_tdoc, lc_ndoc, ld_fchsist) loop
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(l.ln_pgcod10,
                                          l.ln_mod10,
                                          l.ln_suc10,
                                          l.ln_mda10,
                                          l.ln_pap10,
                                          l.ln_cta10,
                                          l.ln_oper10,
                                          lc_fgRefLin);
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(l.ln_mod10,
                                          l.ln_tope10,
                                          lc_fgAdic);
      PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(l.ln_pgcod10,
                                          l.ln_mod10,
                                          l.ln_suc10,
                                          l.ln_mda10,
                                          l.ln_pap10,
                                          l.ln_cta10,
                                          l.ln_oper10,
                                          l.ln_sbop10,
                                          l.ln_tope10,
                                          lc_fgAmpl);
    
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
    
      if lc_fgRefLin = 'N' and lc_fgAdic = 'N' and lc_fgAmpl = 'N' and
         lc_FlgLn = 'N' then
      
        pq_cr_ratio_convcons_in.sp_nrocuotas(ln_pgcod10    => l.ln_pgcod10,
                                             ln_mod10      => l.ln_mod10,
                                             ln_suc10      => l.ln_suc10,
                                             ln_mda10      => l.ln_mda10,
                                             ln_pap10      => l.ln_pap10,
                                             ln_cta10      => l.ln_cta10,
                                             ln_oper10     => l.ln_oper10,
                                             ln_sbop10     => l.ln_sbop10,
                                             ln_tope10     => l.ln_tope10,
                                             ln_NRO_CUOTAS => ln_nrocuotas);
      
        PQ_CR_RATIO_CUOCNSM.sp_cr_flujocaja(l.ln_pgcod10,
                                            l.ln_mod10,
                                            l.ln_suc10,
                                            l.ln_mda10,
                                            l.ln_pap10,
                                            l.ln_cta10,
                                            l.ln_oper10,
                                            l.ln_sbop10,
                                            l.ln_tope10,
                                            ln_flagFC);
        IF ln_flagFC = 'N' then
        
          pq_cr_ratio_convcons_in.sp_cuota_impaga(l.ln_pgcod10,
                                                  l.ln_mod10,
                                                  l.ln_suc10,
                                                  l.ln_mda10,
                                                  l.ln_pap10,
                                                  l.ln_cta10,
                                                  l.ln_oper10,
                                                  l.ln_sbop10,
                                                  l.ln_tope10,
                                                  ln_tipocambio,
                                                  ln_MxcuoimpAux);
        
        else
          if ln_flagFC = 'S' then
          
            PQ_CR_RATIO_CUOCNSM.sp_cr_capacidadFC(l.ln_mod10,
                                                  l.ln_suc10,
                                                  l.ln_mda10,
                                                  l.ln_pap10,
                                                  l.ln_cta10,
                                                  l.ln_oper10,
                                                  l.ln_sbop10,
                                                  l.ln_tope10,
                                                  ln_tipocambio,
                                                  ln_MxcuoimpAux);
          
          end if;
        end if;
      
        pq_cr_ratio_convcons_in.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                 lnPetdoc     => ln_tdoc,
                                                 lnPendoc     => lc_ndoc,
                                                 tipocambio   => ln_tipocambio,
                                                 Instancia    => ln_Instancia,
                                                 pd_fecpro    => ld_fchsist,
                                                 ln_PGCOD     => l.ln_pgcod10,
                                                 ln_MOD       => l.ln_mod10,
                                                 ln_SUC       => l.ln_suc10,
                                                 ln_MDA       => l.ln_mda10,
                                                 ln_PAP       => l.ln_pap10,
                                                 ln_CTA       => l.ln_cta10,
                                                 ln_OPE       => l.ln_oper10,
                                                 ln_SBOP      => l.ln_sbop10,
                                                 ln_TOPE      => l.ln_tope10,
                                                 ln_peri10    => l.ln_peri10,
                                                 ln_nrocuotas => ln_nrocuotas,
                                                 ln_CAPCUO    => ln_MxcuoimpAux,
                                                 lc_IndCred   => 'CredVignt',
                                                 lc_flgprg    => 'R',
                                                 lc_Usuario   => lc_Usuario);
      
        ln_Mxcuoimp := ln_Mxcuoimp + ln_MxcuoimpAux;
      
      end if;
    
    end loop;
  
    for k in lista_credvuelo(ln_pais, ln_tdoc, lc_ndoc, ld_fchsist) loop
    
      pq_cr_ratio_convcons_in.sp_nrocuotas(ln_pgcod10    => k.ln_pgcod10,
                                           ln_mod10      => k.ln_mod10,
                                           ln_suc10      => k.ln_suc10,
                                           ln_mda10      => k.ln_mda10,
                                           ln_pap10      => k.ln_pap10,
                                           ln_cta10      => k.ln_cta10,
                                           ln_oper10     => k.ln_oper10,
                                           ln_sbop10     => k.ln_sbop10,
                                           ln_tope10     => k.ln_tope10,
                                           ln_NRO_CUOTAS => ln_nrocuotas);
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_flujocaja(K.ln_pgcod10,
                                          K.ln_mod10,
                                          K.ln_suc10,
                                          K.ln_mda10,
                                          K.ln_pap10,
                                          K.ln_cta10,
                                          K.ln_oper10,
                                          K.ln_sbop10,
                                          K.ln_tope10,
                                          ln_flagFC);
      IF ln_flagFC = 'N' then
      
        pq_cr_ratio_convcons_in.sp_cuota_impaga(k.ln_pgcod10,
                                                k.ln_mod10,
                                                k.ln_suc10,
                                                k.ln_mda10,
                                                k.ln_pap10,
                                                k.ln_cta10,
                                                k.ln_oper10,
                                                k.ln_sbop10,
                                                k.ln_tope10,
                                                ln_tipocambio,
                                                ln_MxcuoimpAux);
      
      else
        if ln_flagFC = 'S' then
        
          PQ_CR_RATIO_CUOCNSM.sp_cr_capacidadFC(k.ln_mod10,
                                                k.ln_suc10,
                                                k.ln_mda10,
                                                k.ln_pap10,
                                                k.ln_cta10,
                                                k.ln_oper10,
                                                k.ln_sbop10,
                                                k.ln_tope10,
                                                ln_tipocambio,
                                                ln_MxcuoimpAux);
        
        end if;
      end if;
    
      pq_cr_ratio_convcons_in.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                               lnPetdoc     => ln_tdoc,
                                               lnPendoc     => lc_ndoc,
                                               tipocambio   => ln_tipocambio,
                                               Instancia    => ln_Instancia,
                                               pd_fecpro    => ld_fchsist,
                                               ln_PGCOD     => k.ln_pgcod10,
                                               ln_MOD       => k.ln_mod10,
                                               ln_SUC       => k.ln_suc10,
                                               ln_MDA       => k.ln_mda10,
                                               ln_PAP       => k.ln_pap10,
                                               ln_CTA       => k.ln_cta10,
                                               ln_OPE       => k.ln_oper10,
                                               ln_SBOP      => k.ln_sbop10,
                                               ln_TOPE      => k.ln_tope10,
                                               ln_peri10    => k.ln_peri10,
                                               ln_nrocuotas => ln_nrocuotas,
                                               ln_CAPCUO    => ln_MxcuoimpAux,
                                               lc_IndCred   => 'CredVuelo',
                                               lc_flgprg    => 'R',
                                               lc_Usuario   => lc_Usuario);
      ln_Mxcuoimp := ln_Mxcuoimp + ln_MxcuoimpAux;
    
    end loop;
  
    begin
      -- Monto Ingreso Neto
      begin
        select SNG021EVAL
          into ln_Evaluacion
          from sng021
         where sng021sol = ln_Instancia;
      end;
    
      begin
        select sum(case
                     when sng026cod in (5) then
                      sng023mto * -1
                     else
                      sng023mto
                   end)
          into ln_MontIN
          from sng023
         where sng021eval = ln_Evaluacion
           and sng026cod in (1, 5);
      exception
        when others then
          null;
      end;
    end;
  
    begin
      -- Deuda del Sistema Financiero SOLO CONVENIOS
      pq_cr_ratio_convcons_in.sp_cr_SaldIFIS(ln_Instancia, ln_SaldIFIS);
    
    end;
  
    ln_Mxcuoimp := nvl(ln_Mxcuoimp, 0); --mpostigoc 071118
    ln_MontIN   := nvl(ln_MontIN, 0); --mpostigoc 071118
  
    if ln_MontIN > 0 then
      --mpostigoc 071118
      begin
        ln_Ratio := round((ln_Mxcuoimp + ln_SaldIFIS) / ln_MontIN, 6);
      end;
    
      begin
      
        pq_cr_ratio_convcons_in.sp_cr_LogRatio(ln_Pepais      => ln_pais,
                                               ln_Petdoc      => ln_tdoc,
                                               ln_Pendoc      => lc_ndoc,
                                               tipocambio     => ln_tipocambio,
                                               Instancia      => ln_Instancia,
                                               pd_fecpro      => ld_fchsist,
                                               ln_captotcaja  => ln_Mxcuoimp,
                                               saldo_externo  => ln_SaldIFIS,
                                               ln_IngNeto     => ln_MontIN,
                                               ln_RatConvCons => ln_Ratio,
                                               lc_indicador   => 'CC',
                                               lc_flgprg      => 'R',
                                               lc_Usuario     => lc_Usuario);
      
      end;
    end if;
  
  end sp_cr_inicioReporte;

  ------------------------------------------------
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
           and f.relcod = 46;
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

  ----------------------------------------------
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
  ----------------------------------------------
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
  ---------------------------------------------------------
  procedure sp_nrocuotas(ln_pgcod10    in number,
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
  
  end sp_nrocuotas;
  -------------------------------------------------------
  procedure sp_cuota_impaga(ln_pgcod10  in number,
                            ln_mod10    in number,
                            ln_suc10    in number,
                            ln_mda10    in number,
                            ln_pap10    in number,
                            ln_cta10    in number,
                            ln_oper10   in number,
                            ln_sbop10   in number,
                            ln_tope10   in number,
                            tipocambio  in number,
                            ln_Mxcuoimp out number) is
  
    lc_estado       character(1);
    ld_fecha        date;
    ln_cuoimp       number(17, 2);
    ln_monto_seguro number(17, 2);
    fech_maxcuota   date;
  
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
           and ppsbop = ln_sbop10
           and pptope = ln_tope10
           and D602CO in ('S', 'X');
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
           and ppsbop = ln_sbop10
           and pptope = ln_tope10
           and D602CO in ('S', 'X')
           and f602.ppfpag = ld_fecha;
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
             and ppfpag > ld_fecha
             and ppsbop = ln_sbop10
             and pptope = ln_tope10
             and D601CO in ('S', 'X');
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
                 and ppsbop = ln_sbop10
                 and pptope = ln_tope10
                 and D601CO in ('S', 'X')
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
               and ppsbop = ln_sbop10
               and pptope = ln_tope10
               and D601CO in ('S', 'X');
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
           and ppsbop = ln_sbop10
           and pptope = ln_tope10
           and D601CO in ('S', 'X')
           and rownum = 1;
      exception
        when others then
        
          NULL;
        
      end;
    
      if ln_mda10 = 101 then
        ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio;
      end if;
    
    end if;
  
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
  
    ln_Mxcuoimp := ln_cuoimp + ln_monto_seguro;
  
  end sp_cuota_impaga;
  ----------------------------------------------
  procedure sp_cr_SaldIFIS(ln_Instancia in number, ln_SaldIFIS out number) is
  
    cursor lista_CredRCC is
      select j.jaqz862rubr lc_rubro, j.jaqz862gfin ln_gastfinanc
      
        from jaqz862 j
       where j.jaqz862inst = ln_Instancia
         and j.jaqz862esta = 'S'
         and j.jaqz862chek = '1';
  
    ln_digito  varchar2(10);
    lc_ConvRCC varchar2(5) := 'N';
  
  begin
  
    ln_SaldIFIS := 0;
  
    for l in lista_CredRCC loop
      begin
        SELECT SUBSTR(to_char(l.lc_rubro), 0, 10) into ln_digito FROM DUAL;
      end;
    
      begin
        select 'S'
          into lc_ConvRCC
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 600
           and f.tp1corr3 > 1
           and trim(f.tp1desc) = trim(ln_digito)
           and rownum = 1;
      exception
        when others then
          lc_ConvRCC := 'N';
      end;
    
      if lc_ConvRCC = 'S' then
      
        ln_SaldIFIS := ln_SaldIFIS + l.ln_gastfinanc;
      
      end if;
    
    end loop;
  end sp_cr_SaldIFIS;

  ----------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais      in number,
                           ln_Petdoc      in number,
                           ln_Pendoc      in char,
                           tipocambio     in number,
                           Instancia      in number,
                           pd_fecpro      in date,
                           ln_captotcaja  in number,
                           saldo_externo  in number,
                           ln_IngNeto     in number,
                           ln_RatConvCons in number,
                           lc_indicador   in varchar2,
                           lc_flgprg      in varchar2,
                           lc_Usuario     in varchar2) is
  
    ln_corr   number;
    lc_IndEst varchar2(2);
    lc_hora   character(8);
  
  begin
  
    begin
    
      select max(j.jaqz835corr)
        into ln_corr
        from jaqz835 j
       where j.jaqz835fec = pd_fecpro
         and j.jaqz835inst = Instancia;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    if lc_flgprg = 'S' then
      lc_IndEst := 'H'; -- estado para ejecucion desde flujo de creditos
    else
      if lc_flgprg = 'R' then
        lc_IndEst := 'R'; -- estado para ejecucion desde reporte
      end if;
    end if;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    -- if lc_exist = 'N' then
    begin
      insert into jaqz835
        (jaqz835corr,
         jaqz835pais,
         jaqz835tdoc,
         jaqz835ndoc,
         jaqz835tcamb,
         jaqz835inst,
         jaqz835fec,
         jaqz835hora,
         jaqz835capcaja,
         jaqz835sldext,
         jaqz835ingnet,
         jaqz835ratio,
         jaqz835ind,
         jaqz835EST,
         jaqz835user)
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
         ln_IngNeto,
         ln_RatConvCons,
         lc_indicador,
         lc_IndEst,
         lc_Usuario);
      commit;
    
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
                             ln_CAPCUO    in number,
                             lc_IndCred   IN VARCHAR2,
                             lc_flgprg    in varchar2,
                             lc_Usuario   in varchar2) is
  
    ln_corr number;
    --lc_exist varchar2(2) := 'N';
    lc_hora   character(8);
    lc_IndEst varchar2(2);
  
  begin
  
    begin
    
      select max(j.jaqz836corr)
        into ln_corr
        from jaqz836 j
       where j.jaqz836fec = pd_fecpro
         and j.jaqz836inst = Instancia;
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
      
      end if;
    end if;
  
    -- if lc_exist = 'N' then
  
    begin
      insert into jaqz836
        (jaqz836corr,
         jaqz836fec,
         jaqz836hora,
         jaqz836pais,
         jaqz836tdoc,
         jaqz836ndoc,
         jaqz836tcamb,
         jaqz836inst,
         jaqz836pgcod,
         jaqz836mod,
         jaqz836suc,
         jaqz836mda,
         jaqz836pap,
         jaqz836cta,
         jaqz836ope,
         jaqz836sbop,
         jaqz836tope,
         jaqz836PERIO,
         jaqz836NRCUO,
         jaqz836capcuo,
         jaqz836INDIC,
         jaqz836est,
         jaqz836user)
      
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
         ln_CAPCUO,
         lc_IndCred,
         lc_IndEst,
         lc_Usuario);
    
      commit;
    
    end;
  
  end sp_cr_LogCuentas;
  --------------------------------------------------------------
end PQ_CR_RATIO_CONVCONS_IN;
/

