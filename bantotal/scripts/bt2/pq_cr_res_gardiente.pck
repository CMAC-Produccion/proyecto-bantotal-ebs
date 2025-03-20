create or replace package pq_cr_res_gardiente is

  Procedure Sp_promedio(pn_ins in number, pn_porc out number);

  procedure sp_numCuotas(pn_ins in number, pn_cont out number);

end pq_cr_res_gardiente;
/

create or replace package body pq_cr_res_gardiente is

  Procedure Sp_promedio(pn_ins in number, pn_porc out number) is
    ln_emp    number(3);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_cta    number(9);
    ln_ope    number(9);
    ln_sbo    number(3);
    ln_top    number(3);
    ln_cont   number(5) := 0;
    ln_cap    number(17, 2) := 0;
    ln_int    number(17, 2) := 0;
    ln_seg    number(17, 2) := 0;
    ln_cuo    number(17, 2) := 0;
    ln_cuoTot number(17, 2) := 0;
  
    ln_cont2   number(5) := 0;
    ln_cap2    number(17, 2) := 0;
    ln_int2    number(17, 2) := 0;
    ln_seg2    number(17, 2) := 0;
    ln_cuo2    number(17, 2) := 0;
    ln_cuoTot2 number(17, 2) := 0;
  
    ln_cont3 number(5) := 0;
  
    ln_promedio1 number(17, 2) := 0;
    ln_promedio2 number(17, 2) := 0;
  
    ln_porc number(10);
  
    cursor cuotas(cn_emp in number,
                  cn_mod in number,
                  cn_suc in number,
                  cn_mda in number,
                  cn_pap in number,
                  cn_cta in number,
                  cn_ope in number,
                  cn_sbo in number,
                  cn_top in number) is
      select *
        from fsd601 a
       where a.pgcod = cn_emp
         and a.ppmod = cn_mod
         and a.ppsuc = cn_suc
         and a.ppmda = cn_mda
         and a.pppap = cn_pap
         and a.ppcta = cn_cta
         and a.ppoper = cn_ope
         and a.ppsbop = cn_sbo
         and a.pptope = cn_top
      --and a.d601co = 'S'
       order by a.ppfpag;
  
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
  
    for i in cuotas(ln_emp,
                    ln_mod,
                    ln_suc,
                    ln_mda,
                    ln_pap,
                    ln_cta,
                    ln_ope,
                    ln_sbo,
                    ln_top) loop
    
      ln_cont := ln_cont + 1;
      ln_cuo  := 0;
      if ln_cont <= 3 then
      
        ln_cap := i.ppcap;
        ln_int := i.ppint;
      
        begin
          select (a.ppimp11 + a.ppimp12 + a.ppimp13 + a.ppimp14 + a.ppimp15)
            into ln_seg
            from fsd611 a
           where a.pgcod = i.pgcod
             and a.ppmod = i.ppmod
             and a.ppsuc = i.ppsuc
             and a.ppmda = i.ppmda
             and a.pppap = i.pppap
             and a.ppcta = i.ppcta
             and a.ppoper = i.ppoper
             and a.ppsbop = i.ppsbop
             and a.pptope = i.pptope
             and a.ppfpag = i.ppfpag;
        exception
          when others then
            null;
        end;
        ln_cuo    := nvl(ln_cap, 0) + nvl(ln_int, 0) + nvl(ln_seg, 0);
        ln_cuoTot := ln_cuoTot + nvl(ln_cuo, 0);
      end if;
    
      if ln_cont > 3 then
        exit;
      end if;
    
    end loop;
    ln_promedio1 := ln_cuoTot / 3;
  
    for j in cuotas(ln_emp,
                    ln_mod,
                    ln_suc,
                    ln_mda,
                    ln_pap,
                    ln_cta,
                    ln_ope,
                    ln_sbo,
                    ln_top) loop
    
      ln_cont2 := ln_cont2 + 1;
      ln_cuo2  := 0;
      if ln_cont2 > 3 then
      
        ln_cont3 := ln_cont3 + 1;
        ln_cap2  := j.ppcap;
        ln_int2  := j.ppint;
      
        begin
          select (a.ppimp11 + a.ppimp12 + a.ppimp13 + a.ppimp14 + a.ppimp15)
            into ln_seg2
            from fsd611 a
           where a.pgcod = j.pgcod
             and a.ppmod = j.ppmod
             and a.ppsuc = j.ppsuc
             and a.ppmda = j.ppmda
             and a.pppap = j.pppap
             and a.ppcta = j.ppcta
             and a.ppoper = j.ppoper
             and a.ppsbop = j.ppsbop
             and a.pptope = j.pptope
             and a.ppfpag = j.ppfpag;
        exception
          when others then
            null;
        end;
        ln_cuo2    := nvl(ln_cap2, 0) + nvl(ln_int2, 0) + nvl(ln_seg2, 0);
        ln_cuoTot2 := ln_cuoTot2 + nvl(ln_cuo2, 0);
      end if;
    
    end loop;
    if ln_cont3 = 0 then
      ln_promedio2 := 0;
    else
    
      ln_promedio2 := ln_cuoTot2 / ln_cont3;
    end if;
  
    if ln_promedio2 <= ln_promedio1 then
      ln_porc := 0;
    else
    
      ln_porc := round(((1 - (ln_promedio1 / ln_promedio2)) * 100), 0);
    end if;
  
    pn_porc := ln_porc;
  
  end Sp_promedio;

  Procedure Sp_promedio_increm(pn_ins in number, pn_porc out number) is
    ln_emp    number(3);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_cta    number(9);
    ln_ope    number(9);
    ln_sbo    number(3);
    ln_top    number(3);
    ln_cont   number(5) := 0;
    ln_cap    number(17, 2) := 0;
    ln_int    number(17, 2) := 0;
    ln_seg    number(17, 2) := 0;
    ln_cuo    number(17, 2) := 0;
    ln_cuoTot number(17, 2) := 0;
  
    ln_cont2   number(5) := 0;
    ln_cap2    number(17, 2) := 0;
    ln_int2    number(17, 2) := 0;
    ln_seg2    number(17, 2) := 0;
    ln_cuo2    number(17, 2) := 0;
    ln_cuoTot2 number(17, 2) := 0;
  
    ln_cont3 number(5) := 0;
  
    ln_promedio1 number(17, 2) := 0;
    ln_promedio2 number(17, 2) := 0;
  
    ln_porc number(10);
  
    cursor cuotas(cn_emp in number,
                  cn_mod in number,
                  cn_suc in number,
                  cn_mda in number,
                  cn_pap in number,
                  cn_cta in number,
                  cn_ope in number,
                  cn_sbo in number,
                  cn_top in number) is
      select *
        from fsd601 a
       where a.pgcod = cn_emp
         and a.ppmod = cn_mod
         and a.ppsuc = cn_suc
         and a.ppmda = cn_mda
         and a.pppap = cn_pap
         and a.ppcta = cn_cta
         and a.ppoper = cn_ope
         and a.ppsbop = cn_sbo
         and a.pptope = cn_top
      --and a.d601co = 'S'
       order by a.ppfpag;
  
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
  
    for i in cuotas(ln_emp,
                    ln_mod,
                    ln_suc,
                    ln_mda,
                    ln_pap,
                    ln_cta,
                    ln_ope,
                    ln_sbo,
                    ln_top) loop
    
      ln_cont := ln_cont + 1;
      ln_cuo  := 0;
      if ln_cont <= 3 then
      
        ln_cap := i.ppcap;
        ln_int := i.ppint;
      
        begin
          select (a.ppimp11 + a.ppimp12 + a.ppimp13 + a.ppimp14 + a.ppimp15)
            into ln_seg
            from fsd611 a
           where a.pgcod = i.pgcod
             and a.ppmod = i.ppmod
             and a.ppsuc = i.ppsuc
             and a.ppmda = i.ppmda
             and a.pppap = i.pppap
             and a.ppcta = i.ppcta
             and a.ppoper = i.ppoper
             and a.ppsbop = i.ppsbop
             and a.pptope = i.pptope
             and a.ppfpag = i.ppfpag;
        exception
          when others then
            null;
        end;
        ln_cuo    := nvl(ln_cap, 0) + nvl(ln_int, 0) + nvl(ln_seg, 0);
        ln_cuoTot := ln_cuoTot + nvl(ln_cuo, 0);
      end if;
    
      if ln_cont > 3 then
        exit;
      end if;
    
    end loop;
    ln_promedio1 := ln_cuoTot / 3;
  
    for j in cuotas(ln_emp,
                    ln_mod,
                    ln_suc,
                    ln_mda,
                    ln_pap,
                    ln_cta,
                    ln_ope,
                    ln_sbo,
                    ln_top) loop
    
      ln_cont2 := ln_cont2 + 1;
      ln_cuo2  := 0;
      if ln_cont2 > 3 then
      
        ln_cont3 := ln_cont3 + 1;
        ln_cap2  := j.ppcap;
        ln_int2  := j.ppint;
      
        begin
          select (a.ppimp11 + a.ppimp12 + a.ppimp13 + a.ppimp14 + a.ppimp15)
            into ln_seg2
            from fsd611 a
           where a.pgcod = j.pgcod
             and a.ppmod = j.ppmod
             and a.ppsuc = j.ppsuc
             and a.ppmda = j.ppmda
             and a.pppap = j.pppap
             and a.ppcta = j.ppcta
             and a.ppoper = j.ppoper
             and a.ppsbop = j.ppsbop
             and a.pptope = j.pptope
             and a.ppfpag = j.ppfpag;
        exception
          when others then
            null;
        end;
        ln_cuo2    := nvl(ln_cap2, 0) + nvl(ln_int2, 0) + nvl(ln_seg2, 0);
        ln_cuoTot2 := ln_cuoTot2 + nvl(ln_cuo2, 0);
      end if;
    
    end loop;
  
    ln_promedio2 := ln_cuoTot2 / ln_cont3;
  
    if ln_promedio2 <= ln_promedio1 then
      ln_porc := 0;
    else
    
      ln_porc := round((((ln_promedio2 / ln_promedio1) * 100) - 100), 0);
    end if;
  
    pn_porc := ln_porc;
  
  end Sp_promedio_increm;

  procedure sp_numCuotas(pn_ins in number, pn_cont out number) is
  
    ln_emp  number(3);
    ln_mod  number(3);
    ln_suc  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbo  number(3);
    ln_top  number(3);
    ln_cont number(5);
  
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
    
      select count(*)
        into ln_cont
        from fsd601 a
       where a.pgcod = ln_emp
         and a.ppmod = ln_mod
         and a.ppsuc = ln_suc
         and a.ppmda = ln_mda
         and a.pppap = ln_pap
         and a.ppcta = ln_cta
         and a.ppoper = ln_ope
         and a.ppsbop = ln_sbo
         and a.pptope = ln_top
      --and a.d601co = 'S'
      ;
    exception
      when others then
        null;
    end;
    pn_cont := ln_cont;
  
  end;

end pq_cr_res_gardiente;
/

