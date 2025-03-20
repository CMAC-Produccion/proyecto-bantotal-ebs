CREATE OR REPLACE Procedure sp_cr_SaldosCancelaciones(pn_emp   in number,
                                                      pn_mod   in number,
                                                      pn_suc   in number,
                                                      pn_mda   in number,
                                                      pn_pap   in number,
                                                      pn_cta   in number,
                                                      pn_oper  in number,
                                                      pn_sbop  in number,
                                                      pn_top   in number,
                                                      ln_cuota out number) is

  cursor Notiene_comodin is
    select pp1cap ln_capital, a.d602mo ln_modtr, a.d602tr ln_trans
      from fsd602 a, fsd601 b
     where a.pgcod = pn_emp
       and a.ppcta = pn_cta
       and a.ppmda = pn_mda
       and a.ppsuc = pn_suc
       and a.pppap = pn_pap
       and a.ppoper = pn_oper
       and a.ppsbop = pn_sbop
       and a.pptope = pn_top
       and a.ppmod = pn_mod
       and a.d602co = 'S'
       and a.pp1cap > 0
       and a.ppfpag = b.ppfpag
       and a.ppmod = b.ppmod
       and a.ppsuc = b.ppsuc
       and a.ppmda = b.ppmda
       and a.pppap = b.pppap
       and a.ppcta = b.ppcta
       and a.ppoper = b.ppoper
       and a.ppsbop = b.ppsbop
       and a.pptope = b.pptope
       and a.d602mo <> 116
       and a.d602tr <> 508;

  cursor tiene_comodin is
    select pp1cap ln_capital, a.d602mo ln_modtr, a.d602tr ln_trans
      from fsd602 a, fsd601 b
     where a.pgcod = pn_emp
       and a.ppcta = pn_cta
       and a.ppmda = pn_mda
       and a.ppsuc = pn_suc
       and a.pppap = pn_pap
       and a.ppoper = pn_oper
       and a.ppsbop = pn_sbop
       and a.pptope = pn_top
       and a.ppmod = pn_mod
       and a.d602co = 'S'
       and a.ppfpag = b.ppfpag
       and a.ppmod = b.ppmod
       and a.ppsuc = b.ppsuc
       and a.ppmda = b.ppmda
       and a.pppap = b.pppap
       and a.ppcta = b.ppcta
       and a.ppoper = b.ppoper
       and a.ppsbop = b.ppsbop
       and a.pptope = b.pptope
       and a.d602mo <> 116
       and a.d602tr <> 508;

  cap602           number;
  cap601           number;
  Tiene_CuoComodin number := 0;
  lc_Considerar    varchar2(5) := 'S';

begin

  begin
    select /*+ parallel(n,2,1)*/
     sum(p.PPCAP)
      into cap601
      from fsd601 p
     where p.pgcod = pn_emp
       and p.ppcta = pn_cta
       and p.ppmda = pn_mda
       and p.ppsuc = pn_suc
       and p.pppap = pn_pap
       and p.ppoper = pn_oper
       and p.ppsbop = pn_sbop
       and p.pptope = pn_top
       and p.ppmod = pn_mod
       and p.d601co = 'S';
  end;

  begin
    select count(*)
      into Tiene_CuoComodin
      from fsd602 a
     where a.pgcod = pn_emp
       and a.ppcta = pn_cta
       and a.ppmda = pn_mda
       and a.ppsuc = pn_suc
       and a.pppap = pn_pap
       and a.ppoper = pn_oper
       and a.ppsbop = pn_sbop
       and a.pptope = pn_top
       and a.ppmod = pn_mod
       and a.d602cd = 1
       and a.d602co = 'S'
       and a.d602mo = 99
       and a.d602tr = 703;
  exception
    when others then
      Tiene_CuoComodin := 0;
  end;

  if Tiene_CuoComodin > 0 then
  
    for sc in Notiene_comodin loop
      lc_Considerar := 'S';
    
      begin
        select 'N'
          into lc_Considerar
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 150
           and f.tp1nro2 = sc.ln_modtr
           and f.tp1nro3 = sc.ln_trans;
      exception
        when others then
          lc_Considerar := 'S';
      end;
    
      if lc_Considerar = 'S' then
        cap602 := nvl(cap602, 0) + sC.LN_CAPITAL;
      end if;
    end loop;
  else
    if Tiene_CuoComodin = 0 then
      for cc in tiene_comodin loop
        lc_Considerar := 'S';
        begin
          select 'N'
            into lc_Considerar
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10899
             and f.tp1corr1 = 150
             and f.tp1nro2 = cc.ln_modtr
             and f.tp1nro3 = cc.ln_trans;
        exception
          when others then
            lc_Considerar := 'S';
        end;
      
        if lc_Considerar = 'S' then
          cap602 := nvl(cap602, 0) + cC.LN_CAPITAL;
        end if;
      end loop;
    end if;
  end if;

  ln_cuota := nvl(cap601, 0) - nvl(cap602, 0);

end sp_cr_SaldosCancelaciones;
/

