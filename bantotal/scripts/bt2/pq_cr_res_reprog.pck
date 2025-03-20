create or replace package pq_cr_res_reprog is

  Procedure Sp_gadriente(pn_ins in number, pc_flagFC out char);

end pq_cr_res_reprog;
/

create or replace package body pq_cr_res_reprog is

  Procedure Sp_gadriente(pn_ins in number, pc_flagFC out char) is
  
    ln_emp          number(3);
    ln_mod          number(3);
    ln_suc          number(3);
    ln_mda          number(4);
    ln_pap          number(4);
    ln_cta          number(9);
    ln_ope          number(9);
    ln_sbo          number(3);
    ln_top          number(3);
    ln_cont         number(10) := 0;
    ld_Fec          date;
    lc_tienecalen   char(1);
    lc_tieneseguros char(1);
    ld_fecamort     date;
    ln_fc           number(17, 2);
    ln_nroflujo     number;
    lc_Amort        char(1) := 'N';
  
    cursor calendario is
      select *
        from fsd601 f
       where f.pgcod = ln_emp
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_ope
         and f.ppsbop = ln_sbo
         and f.pptope = ln_top;
  
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
  
    --obtiene cuota 13
    for i in calendario loop
      ln_cont := ln_cont + 1;
      if ln_cont = 13 then
        ld_Fec := i.ppfpag;
        exit;
      end if;
    end loop;
    -- verifica si tiene calendario de pago 05/07/2017 mpostigoc
    begin
      select 'S'
        into lc_tienecalen
        from fsd601 f
       where f.pgcod = ln_emp
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_ope
         and f.ppsbop = ln_sbo
         and f.pptope = ln_top
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
       where f.pgcod = ln_emp
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_ope
         and f.ppsbop = ln_sbo
         and f.pptope = ln_top
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
       where a.pgcod = ln_emp
         and a.aomod = ln_mod
         and a.aosuc = ln_suc
         and a.aomda = ln_mda
         and a.aopap = ln_pap
         and a.aocta = ln_cta
         and a.aooper = ln_ope
         and a.aosbop = ln_sbo
         and a.aotope = ln_top
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
          
           where f.pgcod = ln_emp
             and f.ppmod = ln_mod
             and f.ppsuc = ln_suc
             and f.ppmda = ln_mda
             and f.pppap = ln_pap
             and f.ppcta = ln_cta
             and f.ppoper = ln_ope
             and f.ppsbop = ln_sbo
             and f.pptope = ln_top
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
             and f.ppfpag >= ld_Fec;
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
             where f.pgcod = ln_emp
               and f.ppmod = ln_mod
               and f.ppsuc = ln_suc
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_ope
               and f.ppsbop = ln_sbo
               and f.pptope = ln_top
               and f.ppfpag > ld_fecamort --mod@abr 17032020
               and f.ppfpag >= ld_Fec;
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
          
           where f.pgcod = ln_emp
             and f.ppmod = ln_mod
             and f.ppsuc = ln_suc
             and f.ppmda = ln_mda
             and f.pppap = ln_pap
             and f.ppcta = ln_cta
             and f.ppoper = ln_ope
             and f.ppsbop = ln_sbo
             and f.pptope = ln_top
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
             and f.ppfpag >= ld_Fec;
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
             where f.pgcod = ln_emp
               and f.ppmod = ln_mod
               and f.ppsuc = ln_suc
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_ope
               and f.ppsbop = ln_sbo
               and f.pptope = ln_top
               and f.ppfpag >= ld_Fec;
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
        pc_flagFC := 'N';
      else
        pc_flagFC := 'S';
      END IF;
    
    else
      if ln_fc is null then
        pc_flagFC := 'N';
      
      end if;
    
    end if;
  
  end Sp_gadriente;
end pq_cr_res_reprog;
/

