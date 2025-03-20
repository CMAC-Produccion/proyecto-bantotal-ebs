create or replace package PQ_CR_RESO_RIESCAMBDOLAR is

  -- Author  : MPOSTIGOC
  -- Created : 13/01/2016 04:46:54 p.m.
  -- Purpose : 

  procedure sp_cuentas(ln_Pepais   in number,
                       ln_Petdoc   in number,
                       ln_Pendoc   in character,
                       tipocambio  in number,
                       ln_captotal out number);
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
                            ln_NRO_CUOTAS in number,
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
                              ln_formula out number);
  --------------------------------------------------
  procedure sp_capacidadpago(ln_MAX_CUOTA    in number,
                             ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_instancia    in number,
                             tipocambio      in number,
                             ln_capacidad    out number);
  -----------------------------------------------------
  procedure sp_resolutor(ln_pgcod10   in number,
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
                         ln_capacidad out number);

end PQ_CR_RESO_RIESCAMBDOLAR;
/

create or replace package body PQ_CR_RESO_RIESCAMBDOLAR is

  ------ RIESGO CREDITICIO DOLARES

  procedure sp_cuentas(ln_Pepais   in number,
                       ln_Petdoc   in number,
                       ln_Pendoc   in character,
                       tipocambio  in number,
                       ln_captotal out number) is
  
    ln_capacidad number;
  
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
         and d10.Aomod in
             (33, 101, 102, 103, 104, 105, 106, 107, 109, 110, 111, 112, 113, 115, 117, 141, 142, 200)
         and d10.Aostat <> 99
         and d10.aomda = 101;
  
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
         and x.xwfmodulo in
             (33, 101, 102, 103, 104, 105, 106, 107, 109, 110, 111, 112, 113, 115, 117, 141, 142, 200)
            
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.Wfstscod not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                            --and wftaskcod <> 55
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd'))
                    --  and wftaskcod <> 55
                 and wf.wfitemstsact = 1
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
            
         and s.sng120ins = XWFPRCINS
         and x.xwfmoneda = 101
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope;
  
  begin
  
    ln_captotal := 0;
  
    for i in inserta loop
    
      PQ_CR_RESO_RIESCAMBDOLAR.sp_resolutor(i.ln_pgcod10,
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
                                            ln_capacidad);
    
      ln_captotal := ln_captotal + ln_capacidad;
    
    end loop;
  
    for c in vuelo loop
    
      PQ_CR_RESO_RIESCAMBDOLAR.sp_resolutor(c.ln_pgcod10,
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
                                            ln_capacidad);
    
      ln_captotal := ln_captotal + ln_capacidad;
    end loop;
  
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
  
    --  ln_instancia number;
  
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
        NULL;
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
                            ln_NRO_CUOTAS in number,
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
             and rownum = 1;
        exception
          when others then
            NULL;
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
    
      --  end if;
    
      if ln_mda10 = 101 and ln_NRO_CUOTAS > 12 then
        ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio * 1.2;
      else
        if ln_mda10 = 101 and ln_NRO_CUOTAS <= 12 then
          ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio * 1.1;
        end if;
      
      end if;
    
    end if;
  
  end sp_cuota_impaga;
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
      select sum(ppimp10 + ppimp11 + ppimp12 + ppimp13)
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
  
    if ln_monto_seguro = 101 then
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
                              ln_formula out number) is
  
    ln_plazo number(10, 2);
    ln_tasa  number(10, 3);
    ln_saldo number(10, 2);
  
  begin
  
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
  
    begin
    
      ln_formula := (ln_saldo *
                    ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                    (1 - power((1 +
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                               -ln_plazo));
    
    end;
  
  end sp_capacidadlinea;

  ------------------------------------------------------------
  procedure sp_capcartfianza(ln_mod10   in number,
                             ln_suc10   in number,
                             ln_mda10   in number,
                             ln_pap10   in number,
                             ln_cta10   in number,
                             ln_oper10  in number,
                             ln_sbop10  in number,
                             ln_tope10  in number,
                             ln_formula out number) is
  
    --ln_plazo number(10, 2);
    ln_tasa  number(10, 3);
    ln_saldo number(10, 2);
  
  begin
    begin
      select tpimp
        into ln_tasa
        from fst098
       where pgcod = 1
         and tpcod = 7697
         and tpcorr = 1
         and tpnro = 141;
    exception
      when others then
        NULL;
    end;
  
    begin
      select aoimp
        into ln_saldo
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
        select x.xwfmonto1
          into ln_saldo
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
    end if;
  
    ln_saldo := ((30 * ln_saldo) / 100);
  
    begin
    
      ln_formula := (ln_saldo *
                    ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                    (1 - power((1 +
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                               -24));
    end;
  
  end sp_capcartfianza;

  -----------------------------------------------------------
  procedure sp_capacidadpago(ln_MAX_CUOTA    in number,
                             ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_instancia    in number,
                             tipocambio      in number,
                             ln_capacidad    out number) is
    ln_mensual  number;
    ln_cuota    number;
    ln_sngmda   number;
    ln_cuotaimp number;
  
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if ln_NRO_CUOTAS > 1 and ln_SNG001Ori <> 7 then
        
          ln_mensual := ln_peri10 / 30;
        
          ln_cuota := ln_MAX_CUOTA / ln_mensual;
        
          ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
        
        else
          if ln_NRO_CUOTAS > 1 and ln_SNG001Ori = 7 then
          
            begin
              select sng120cuo, sng120mda
                into ln_cuotaimp, ln_sngmda
                from sng120
               where SNG120INS = ln_instancia;
            exception
              when others then
                NULL;
            end;
          
            if ln_sngmda = 101 and ln_NRO_CUOTAS > 12 then
              ln_cuotaimp := nvl(ln_cuotaimp, 0) * nvl(tipocambio, 0) * 1.2;
            else
              if ln_sngmda = 101 and ln_NRO_CUOTAS <= 12 then
                ln_cuotaimp := nvl(ln_cuotaimp, 0) * nvl(tipocambio, 0) * 1.1;
              end if;
            
            end if;
          
            ln_mensual := ln_peri10 / 30;
          
            ln_cuota := ln_cuotaimp / ln_mensual;
          
            ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
          end if;
        
        end if;
      end if;
    end;
  end sp_capacidadpago;

  --------------------------------------------------
  procedure sp_resolutor(ln_pgcod10   in number,
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
                         ln_capacidad out number) is
    ln_nrocuotas  number;
    ln_parciales  number;
    ln_cuotimp    number;
    ln_seguro     number;
    fech_maxcuota date;
    ln_instancia  number;
  
  begin
    PQ_CR_RESO_RIESCAMBDOLAR.sp_cuotas(ln_pgcod10,
                                       ln_mod10,
                                       ln_suc10,
                                       ln_mda10,
                                       ln_pap10,
                                       ln_cta10,
                                       ln_oper10,
                                       ln_sbop10,
                                       ln_tope10,
                                       ln_nrocuotas);
  
    PQ_CR_RESO_RIESCAMBDOLAR.sp_instancia(ln_mod10,
                                          ln_suc10,
                                          ln_mda10,
                                          ln_pap10,
                                          ln_cta10,
                                          ln_oper10,
                                          ln_sbop10,
                                          ln_tope10,
                                          ln_parciales,
                                          ln_instancia);
  
    if ln_mod10 <> 117 and ln_mod10 <> 141 then
      PQ_CR_RESO_RIESCAMBDOLAR.sp_cuota_impaga(ln_pgcod10,
                                               ln_mod10,
                                               ln_suc10,
                                               ln_mda10,
                                               ln_pap10,
                                               ln_cta10,
                                               ln_oper10,
                                               tipocambio,
                                               ln_nrocuotas,
                                               ln_cuotimp,
                                               fech_maxcuota);
    end if;
  
    PQ_CR_RESO_RIESCAMBDOLAR.sp_instancia(ln_mod10,
                                          ln_suc10,
                                          ln_mda10,
                                          ln_pap10,
                                          ln_cta10,
                                          ln_oper10,
                                          ln_sbop10,
                                          ln_tope10,
                                          ln_parciales,
                                          ln_instancia);
  
    if ln_mod10 = 117 then
      PQ_CR_RESO_RIESCAMBDOLAR.sp_capacidadlinea(ln_mod10,
                                                 ln_suc10,
                                                 ln_mda10,
                                                 ln_pap10,
                                                 ln_cta10,
                                                 ln_oper10,
                                                 ln_sbop10,
                                                 ln_tope10,
                                                 ln_capacidad);
    end if;
  
    if ln_mod10 = 141 then
      PQ_CR_RESO_RIESCAMBDOLAR.sp_capcartfianza(ln_mod10,
                                                ln_suc10,
                                                ln_mda10,
                                                ln_pap10,
                                                ln_cta10,
                                                ln_oper10,
                                                ln_sbop10,
                                                ln_tope10,
                                                ln_capacidad);
    end if;
  
    if ln_mod10 <> 117 and ln_mod10 <> 141 then
      PQ_CR_RESO_RIESCAMBDOLAR.sp_capacidadpago(ln_cuotimp,
                                                ln_nrocuotas,
                                                ln_parciales,
                                                ln_peri10,
                                                ln_seguro,
                                                ln_mod10,
                                                ln_instancia,
                                                tipocambio,
                                                ln_capacidad);
    end if;
  
  end sp_resolutor;

--------------------------------------------------
end PQ_CR_RESO_RIESCAMBDOLAR;
/

