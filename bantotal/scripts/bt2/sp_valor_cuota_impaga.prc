CREATE OR REPLACE Procedure Sp_valor_cuota_impaga(pn_emp   in number,
                                                  pn_mod   in number,
                                                  pn_suc   in number,
                                                  pn_mda   in number,
                                                  pn_pap   in number,
                                                  pn_cta   in number,
                                                  pn_oper  in number,
                                                  pn_sbop  in number,
                                                  pn_top   in number,
                                                  ln_cuota out number) is

  cap602 number;
  cap601 number;

begin
  /*begin
    
      select --\*+ parallel(n,2,1)*\
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
    
      select sum(pp1cap)
        into cap602
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
        -- and a.pp1cap > 0
         and a.ppfpag = b.ppfpag
         and a.ppmod = b.ppmod
         and a.ppsuc = b.ppsuc
         and a.ppmda = b.ppmda
         and a.pppap = b.pppap
         and a.ppcta = b.ppcta
         and a.ppoper = b.ppoper
         and a.ppsbop = b.ppsbop
         and a.pptope = b.pptope
         and a.pptipo=b.pptipo--**
         and a.d602mo <> 116;
    
    end;
  
    ln_cuota := nvl(cap601, 0) - nvl(cap602, 0);
  */

  begin
    -- Call the procedure
    sp_cr_saldoscancelaciones(pn_emp,
                              pn_mod,
                              pn_suc,
                              pn_mda,
                              pn_pap,
                              pn_cta,
                              pn_oper,
                              pn_sbop,
                              pn_top,
                              ln_cuota);
  end;

end sp_valor_cuota_impaga;
/

