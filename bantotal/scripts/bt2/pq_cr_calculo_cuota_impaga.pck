create or replace package pq_cr_calculo_cuota_impaga is

  procedure sp_calcula_tcuota(pn_ins in  number,
                              pn_tot out number);

  function fn_obtener_tcambio(pn_mda in number, pn_fecha in date) return number;

end pq_cr_calculo_cuota_impaga;
/

create or replace package body pq_cr_calculo_cuota_impaga is

  procedure sp_calcula_tcuota(pn_ins in number, pn_tot out number) --return number
   is
  
    --lx_sum1 number(17, 2);
    --lx_sum2 number(17, 2);
    --lx_sumt number(17, 2);
    lx_fmax date;
    lc_ind1 number;
    lc_ind2 number;
    lx_fpag date;
  
    lx_pcap number(17, 2);
    lx_pint number(17, 2);
    lx_segu number(17, 2);
    lx_tip  number(2);
    lx_porc number(9);
  
    --pn_tot number(17, 2);
    pn_cre  number(17, 2);
    lx_tcam number(14, 8);
  
    cursor creditos is
    
      select t.xwfempresa,
             t.xwfsucursal,
             t.xwfmodulo,
             t.xwfmoneda,
             t.xwfpapel,
             t.xwfcuenta,
             t.xwfoperacion,
             t.xwfsubope,
             t.xwftipope
        from xwf700 t
       where t.xwfprcins = pn_ins
         and t.xwfcar3 not in ('1');
  
  begin
  
    pn_tot := 0;
  
    for j in creditos() loop
      pn_cre := 0;
      begin
        lc_ind1 := 1;
        lc_ind2 := 1;
        select max(t.ppfpag)
          into lx_fmax
          from fsd602 t
         where t.pgcod = j.xwfempresa
           and t.ppmod = j.xwfmodulo
           and t.ppsuc = j.xwfsucursal
           and t.ppmda = j.xwfmoneda
           and t.pppap = j.xwfpapel
           and t.ppcta = j.xwfcuenta
           and t.ppoper = j.xwfoperacion
           and t.ppsbop = j.xwfsubope
           and t.pptope = j.xwftipope
           and t.pp1stat in ('T', 'S');
      exception
        when others then
          lc_ind1 := 0;
      end;
    
      if lx_fmax is NULL then
        lc_ind1 := 0;
      else
        lc_ind1 := 1;
      end if;
    
      if lc_ind1 = 1 then
        ----Si se pagó
        begin
          select nvl(f.ppcap, 0), nvl(f.ppint, 0), f.ppfpag
            into lx_pcap, lx_pint, lx_fpag
            from (select t.ppcap, t.ppint, t.ppfpag
                    from fsd601 t
                   where t.pgcod = j.xwfempresa
                     and t.ppmod = j.xwfmodulo
                     and t.ppsuc = j.xwfsucursal
                     and t.ppmda = j.xwfmoneda
                     and t.pppap = j.xwfpapel
                     and t.ppcta = j.xwfcuenta
                     and t.ppoper = j.xwfoperacion
                     and t.ppsbop = j.xwfsubope
                     and t.pptope = j.xwftipope
                     and t.ppfpag > lx_fmax
                     and (t.ppcap + t.ppint) <> 0
                   order by t.ppfpag asc) f
           where rownum = 1;
        
        exception
          when others then
            lc_ind2 := 0;
        end;
      
      else
        --No se pagó nada
        begin
          select nvl(f.ppcap, 0), nvl(f.ppint, 0), f.ppfpag
            into lx_pcap, lx_pint, lx_fpag
            from (select t.ppcap, t.ppint, t.ppfpag
                    from fsd601 t
                   where t.pgcod = j.xwfempresa
                     and t.ppmod = j.xwfmodulo
                     and t.ppsuc = j.xwfsucursal
                     and t.ppmda = j.xwfmoneda
                     and t.pppap = j.xwfpapel
                     and t.ppcta = j.xwfcuenta
                     and t.ppoper = j.xwfoperacion
                     and t.ppsbop = j.xwfsubope
                     and t.pptope = j.xwftipope
                     and (t.ppcap + t.ppint) <> 0
                   order by t.ppfpag asc) f
           where rownum = 1;
        exception
          when others then
            lc_ind2 := 0;
        end;
      
      end if;
      ---
    
      if lc_ind2 > 0 then
        -- 2. Obtener seguros
        begin
          select nvl(t.ppimp11 + t.ppimp12 + t.ppimp13 + t.ppimp14 +
                     t.ppimp15,
                     0)
            into lx_segu
          
            from fsd611 t
           where t.pgcod = j.xwfempresa
             and t.ppmod = j.xwfmodulo
             and t.ppsuc = j.xwfsucursal
             and t.ppmda = j.xwfmoneda
             and t.pppap = j.xwfpapel
             and t.ppcta = j.xwfcuenta
             and t.ppoper = j.xwfoperacion
             and t.ppsbop = j.xwfsubope
             and t.pptope = j.xwftipope
             and t.ppfpag = lx_fpag;
        exception
          when others then
            lx_segu := 0;
        end;
      
        --3. Buscar exoneración
        begin
          select t.jaqn870tip
            into lx_tip
            from jaqn870 t
           where t.jaqn870emp = j.xwfempresa
             and t.jaqn870mod = j.xwfmodulo
             and t.jaqn870suc = j.xwfsucursal
             and t.jaqn870mda = j.xwfmoneda
             and t.jaqn870pap = j.xwfpapel
             and t.jaqn870cta = j.xwfcuenta
             and t.jaqn870ope = j.xwfoperacion
             and t.jaqn870sbo = j.xwfsubope
             and t.jaqn870top = j.xwftipope
             and t.jaqn870est = 'X'; ---- jrodriguej 27.01.2021; cambio de G a X
        exception
          when others then
            lx_tip := 0;
        end;
      
        if lx_tip > 0 then
          begin
            select t.tp1imp1
              into lx_porc
              from fst198 t
             where t.tp1cod = 1
               and t.tp1cod1 = 11140
               and t.tp1corr1 = 3
               and t.tp1corr2 = 1
               and t.tp1nro1 = lx_tip;
          exception
            when others then
              lx_porc := 0;
          end;
        
          pn_cre := (lx_pcap + lx_pint + lx_segu) * (lx_porc / 100);
          --dbms_output.put_line('pn_cre: ' || pn_cre);
        
        else
          pn_cre := (lx_pcap + lx_pint + lx_segu);
          --dbms_output.put_line('pn_cre sin porc: ' || pn_cre);
          pn_cre := 0;
        
        end if;
      
        -- 4. Evaluar tipo de cambio
        if j.xwfmoneda = 101 then
        
          lx_tcam := pq_cr_calculo_cuota_impaga.fn_obtener_tcambio(j.xwfmoneda,
                                                                   lx_fpag);
          pn_cre  := lx_tcam * pn_cre;
        
        end if;
      
      else
        pn_cre := 0;
      end if;
    
      pn_tot := pn_tot + pn_cre;
    
    end loop;
  
    ---select t.pgfape into lx_fpag from fst017 t where t.pgcod = 1;
  
  end sp_calcula_tcuota;

  function fn_obtener_tcambio(pn_mda in number, pn_fecha in date)
    return number is
  
    --lx_ope1 number(3);
    --lx_ope2 number(5);
    lx_tcam number(14, 8);
    lx_tfec date;
  
  begin
  
    select f.cotcbi, f.cofdes
      into lx_tcam, lx_tfec
      from (select t.cotcbi, t.cofdes
              from fsh005 t
             where t.moneda = pn_mda
               and t.cofdes <= pn_fecha
             order by t.cofdes desc) f
     where rownum = 1;
  
    return lx_tcam;
  
  end fn_obtener_tcambio;

end pq_cr_calculo_cuota_impaga;
/

