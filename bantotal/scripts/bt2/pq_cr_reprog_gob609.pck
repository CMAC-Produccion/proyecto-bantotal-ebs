create or replace package pq_cr_reprog_gob609 is

  Procedure sp_indicadorpro(pn_ins in number, pc_ind out varchar2);
  procedure sp_plazo(pn_ins    in number,
                     pd_Fecpro in date,
                     pn_total  out number);
  procedure sp_unicuota(pn_ins in number,
                        pn_pzo out number,
                        pc_flg out char);
  procedure sp_esCaja(pn_ins in number, pc_existe out char);
  procedure sp_indicadorCG(pn_ins in number, pc_existe out varchar2); --mod@abr 20201202
  Procedure sp_gradiente(pn_ins in number, pc_flg out char); --mod@abr 20201202
  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out char); --mod@abr 20201202   
  procedure sp_incremento(pn_ins    in number,
                          pd_Fecpro in date,
                          pn_total  out number); --mod@abr 20201202                                                 


end pq_cr_reprog_gob609;
/

create or replace package body pq_cr_reprog_gob609 is

  Procedure sp_indicadorpro(pn_ins in number, pc_ind out varchar2) is
  
    ln_mod number(3);
    ln_top number(3);
    lc_ind varchar2(5);
  begin
  
    begin
      select a.xwfmodulo, a.xwftipope
        into ln_mod, ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select trim(a.aqpa869ind)
        into lc_ind
        from aqpa869 a
       where a.aqpa869mod = ln_mod
         and a.aqpa869top = ln_top;
    exception
      when others then
        null;
    end;
  
    pc_ind := lc_ind;
  
  end sp_indicadorpro;

  procedure sp_plazo(pn_ins    in number,
                     pd_Fecpro in date,
                     pn_total  out number) is
  
    ln_emp   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
    ld_fvto  date;
    ln_meses number(5);
    ln_plazo number(5);
    ln_dias  number(5);
    lc_ind   char(5);
    ld_fec   date;
    
  begin
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpa869ind
        into lc_ind
        from aqpa869 a
       where a.aqpa869mod = ln_mod
         and a.aqpa869top = ln_top;
    exception
      when others then
        null;
    end;
  
--    ln_sbo := 609;  --CAMBIAR POR 609 EN PROCESO
  
    begin
      select a.aofvto
        into ld_fvto
        from fsd010 a
       where a.pgcod = ln_emp
         and a.aomod = ln_mod
         and a.aosuc = ln_suc
         and a.aomda = ln_mda
         and a.aopap = ln_pap
         and a.aocta = ln_cta
         and a.aooper = ln_ope
         and a.aosbop = ln_sbo
         and a.aotope = ln_top;

    exception
      when others then
        null;
    end;
  
    if lc_ind = 'H' then
      begin
        select a.tp1nro1
          into ln_meses
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 333333
           and a.tp1corr2 = 1;
      exception
        when others then
          null;
      end;
  
  /*fecha ppfpag pago minima cuota impaga fecpro*/
      begin

        SELECT min(D1.PPFVAL)
             INTO ld_fec
             FROM FSD601 D1
             WHERE D1.PGCOD =  ln_emp  
               AND D1.PPMOD =  ln_mod  
               AND D1.PPSUC =  ln_suc  
               AND D1.PPMDA =  ln_mda  
               AND D1.PPPAP =  ln_pap  
               AND D1.PPCTA =  ln_cta  
               AND D1.PPOPER = ln_ope 
               AND D1.PPSBOP = 609 
               AND D1.PPTOPE = ln_top 
               AND D1.D601CO='X';
    exception when others then
      ld_fec := null;
    end;      

  
      begin
        select a.tp1nro1
          into ln_dias
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 333333
           and a.tp1corr2 = 2;
      exception
        when others then
          null;
      end;
    
      ln_plazo := (ld_fvto - ld_fec/*pd_Fecpro*/) + ((ln_meses / 12) * 365) + ln_dias;
        
    end if;
    pn_total := ln_plazo;
  end sp_plazo;

  procedure sp_unicuota(pn_ins in number,
                        pn_pzo out number,
                        pc_flg out char) is
  
    ln_emp     number(3);
    ln_mod     number(3);
    ln_suc     number(3);
    ln_mda     number(4);
    ln_pap     number(4);
    ln_cta     number(9);
    ln_ope     number(9);
    ln_sbo     number(3);
    ln_top     number(3);
    ln_empA    number(3);
    ln_modA    number(3);
    ln_sucA    number(3);
    ln_mdaA    number(4);
    ln_papA    number(4);
    ln_ctaA    number(9);
    ln_opeA    number(9);
    ln_sboA    number(3);
    ln_topA    number(3);
    ln_period  number(5);
    ln_diaGrac number(5);
    ln_cont    number(5);
  
  begin
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_empA,
             ln_modA,
             ln_sucA,
             ln_mdaA,
             ln_papA,
             ln_ctaA,
             ln_opeA,
             ln_sboA,
             ln_topA
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
     ln_sboA := 609;  --CAMBIAR POR 609 EN PROCESO
  
    begin
      select count(*)
        into ln_cont
        from fsd601 a
       where a.pgcod = ln_empA
         and a.ppmod = ln_modA
         and a.ppsuc = ln_sucA
         and a.ppmda = ln_mdaA
         and a.pppap = ln_papA
         and a.ppcta = ln_ctaA
         and a.ppoper = ln_opeA
         and a.ppsbop = ln_sboA
         and a.pptope = ln_topA;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aoperiod
        into ln_period
        from fsd010 a
       where a.pgcod = ln_emp
         and a.aomod = ln_mod
         and a.aosuc = ln_suc
         and a.aomda = ln_mda
         and a.aopap = ln_pap
         and a.aocta = ln_cta
         and a.aooper = ln_ope
         and a.aosbop = ln_sbo
         and a.aotope = ln_top;
    exception
      when others then
        null;
    end;
  
    begin
      select a.tp1nro1
        into ln_diaGrac
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 333333
         and a.tp1corr2 = 3;
    exception
      when others then
        null;
    end;
  
    pn_pzo := ln_period + ln_diaGrac;
  
    if ln_cont = 1 then
      pc_flg := 'S';
    else
      pc_flg := 'N';
    end if;
  
  end sp_unicuota;

  procedure sp_esCaja(pn_ins in number, pc_existe out char) is
  
    ln_emp    number(3);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_cta    number(9);
    ln_ope    number(9);
    ln_sbo    number(3);
    ln_top    number(3);
    lc_existe char(1) := 'N';
  
  begin
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    begin
      SELECT 'S'
        into lc_existe
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'CAJA'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             ln_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = ln_ope
         AND F.EMPRESA = ln_emp
         AND F.SUCURSAL = ln_suc
         AND F.MODULO = ln_mod
         AND F.MONEDA = ln_mda
         AND F.PAPEL = ln_pap
         AND F.SUBOPERACION = ln_sbo
         AND F.TIPOOPERACION = ln_top;
    exception
      when others then
        null;
    end;
  
    pc_existe := nvl(lc_existe, 'N');
  end sp_esCaja;

  procedure sp_indicadorCG(pn_ins in number, pc_existe out varchar2) is
  
    ln_emp    number(3);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_cta    number(9);
    ln_ope    number(9);
    ln_sbo    number(3);
    ln_top    number(3);
    lc_existe char(1) := 'N';
    lv_tipo   varchar2(10);
  
  begin
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    begin
      SELECT L.TIPOFACILIDAD
        into lv_tipo
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
            --AND L.TIPOFACILIDAD = 'CAJA'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             ln_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = ln_ope
         AND F.EMPRESA = ln_emp
         AND F.SUCURSAL = ln_suc
         AND F.MODULO = ln_mod
         AND F.MONEDA = ln_mda
         AND F.PAPEL = ln_pap
         AND F.SUBOPERACION = ln_sbo
         AND F.TIPOOPERACION = ln_top;
    exception
      when others then
        null;
    end;
  
    if trim(lv_tipo) = 'CAJA' then
      lc_existe := 'C';
    end if;
  
    if trim(lv_tipo) = 'GOBIERNO' then
      lc_existe := 'G';
    end if;
  
    pc_existe := nvl(lc_existe, 'N');
  end sp_indicadorCG;

  Procedure sp_gradiente(pn_ins in number, pc_flg out char) is
  
    ln_emp number(3);
    ln_mod number(3);
    ln_suc number(3);
    ln_mda number(4);
    ln_pap number(4);
    ln_cta number(9);
    ln_ope number(9);
    ln_sbo number(3);
    ln_top number(3);
    lc_flg char(1);
  begin
  
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
  
    pq_cr_reprog_gob609.sp_cr_flujocaja(ln_emp,
                                          ln_mod,
                                          ln_suc,
                                          ln_mda,
                                          ln_pap,
                                          ln_cta,
                                          ln_ope,
                                          ln_sbo,
                                          ln_top,
                                          lc_flg);
    pc_flg := nvl(lc_flg, 'N');
  
  end sp_gradiente;

  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out char) is
  
    ln_fc           number(17, 2);
    ln_nroflujo     number;
    lc_tienecalen   VARCHAR2(2);
    lc_tieneseguros varchar2(2);
    ld_fecamort     date; --mod@abr 17032020
    lc_Amort        char(1) := 'N'; --mod@abr 17032020
    ln_sbo          number; ---
    ln_sbop609      number;  -----
  begin

   
   ln_sbo := ln_sbop10;
   ln_sbop609 := 609;  --CAMBIAR POR 609 EN PROCESO

  
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
         and f.ppsbop = ln_sbop609 --ln_sbop10
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
         and f.ppsbop = ln_sbop609 --ln_sbop10
         and f.pptope = ln_tope10
         and rownum = 1;
    exception
      when others then
        lc_tieneseguros := 'N';
    end;
  
    --mod@abr 17032020
    ----excluir amortizaciones 
    begin
      select max(a.evfval)
        into ld_fecamort
        from fsd012 a
       where a.pgcod = ln_emp10
         and a.aomod = ln_mod10
         and a.aosuc = ln_suc10
         and a.aomda = ln_mda10
         and a.aopap = ln_pap10
         and a.aocta = ln_cta10
         and a.aooper = ln_oper10
         and a.aosbop = ln_sbo-------------------
         and a.aotope = ln_tope10
         and a.evtipo in (31, 50);
    exception
      when others then
        null;
    end;
  
    if ld_fecamort is not null then
      lc_Amort := 'S';
    else
      lc_Amort := 'N';
    end if;
    --mod@abr 17032020
  
    if lc_Amort = 'S' then
      --mod@abr 17032020
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
             and f.ppsbop = ln_sbop609 --ln_sbop10
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
             and f.ppfpag = s.ppfpag
             and f.ppfpag > ld_fecamort --mod@abr 17032020
          ;
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
               and f.ppsbop = ln_sbop609 --ln_sbop10
               and f.pptope = ln_tope10
               and f.ppfpag > ld_fecamort --mod@abr 17032020
            ;
          exception
            when others then
              null;
            
          end;
        
        end if;
      end if;
    else
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
             and f.ppsbop = ln_sbop609 --ln_sbop10
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
               and f.ppsbop = ln_sbop609 --ln_sbop10
               and f.pptope = ln_tope10;
          exception
            when others then
              null;
            
          end;
        
        end if;
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

  procedure sp_incremento(pn_ins    in number,
                          pd_Fecpro in date,
                          pn_total  out number) is
  
    ln_emp   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
    ld_fvto  date;
    ln_inc   number(5);
    ln_plazo number(5);
    lc_ind   char(5);
    ld_fec   date;
  begin
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpa869ind
        into lc_ind
        from aqpa869 a
       where a.aqpa869mod = ln_mod
         and a.aqpa869top = ln_top;
    exception
      when others then
        null;
    end;
  

  
    begin

    select a.aofvto
        into ld_fvto
        from fsd010 a
       where a.pgcod =  ln_emp
         and a.aomod =  ln_mod
         and a.aosuc =  ln_suc
         and a.aomda =  ln_mda
         and a.aopap =  ln_pap
         and a.aocta =  ln_cta
         and a.aooper = ln_ope
         and a.aosbop = ln_sbo
         and a.aotope = ln_top;
         
    exception
      when others then
        null;
    end;

    ln_sbo := 609;  --CAMBIAR POR 609 EN PROCESO
  
  
  /*fecha ppfpag pago minima cuota impaga fecpro*/
    begin

        SELECT min(D1.PPFVAL)
             INTO ld_fec
             FROM FSD601 D1
             WHERE D1.PGCOD =  ln_emp  
               AND D1.PPMOD =  ln_mod  
               AND D1.PPSUC =  ln_suc  
               AND D1.PPMDA =  ln_mda  
               AND D1.PPPAP =  ln_pap  
               AND D1.PPCTA =  ln_cta  
               AND D1.PPOPER = ln_ope 
               AND D1.PPSBOP = 609 
               AND D1.PPTOPE = ln_top 
               AND D1.D601CO='X';
    exception when others then
      ld_fec := null;
    end;      
  
  
    begin
      select a.tp1nro1
        into ln_inc
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 333333
         and a.tp1corr2 = 4
         and a.tp1desc = lc_ind;
    exception
      when others then
        null;
    end;
  
    ln_plazo := ((ld_fvto - ld_fec)) * ( 100+ ln_inc) / 100;
  
    pn_total := ln_plazo + 29; --suma 29 dias
  
  end sp_incremento;


   
end pq_cr_reprog_gob609;
/

