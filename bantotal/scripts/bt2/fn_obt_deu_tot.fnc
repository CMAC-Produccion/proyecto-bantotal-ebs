create or replace function fn_Obt_Deu_Tot( pn_emp in number,
                                           pn_mod in number,
                                           pn_suc in number,
                                           pn_mda in number,
                                           pn_pap in number,
                                           pn_cta in number,
                                           pn_ope in number,
                                           pn_sbo in number,
                                           pn_top in number,
                                           pd_fecpro in date
                                           ) return number is
DeuTot number;
begin
  begin
    select pq_cr_cuotamora.fn_monto_cuota(a.pgcod,
                                        a.ppmod,
                                        a.ppsuc,
                                        a.ppmda,
                                        a.pppap,
                                        a.ppcta,
                                        a.ppoper,
                                        a.ppsbop,
                                        a.pptope,
                                        a.ppfpag,
                                        a.ppcap,
                                        a.ppint,
                                        pd_fecpro)
    into DeuTot
    from fsd601 a
   where a.pgcod = pn_emp
     and a.ppmod = pn_mod
     and a.ppsuc = pn_suc
     and a.ppmda = pn_mda
     and a.pppap = pn_pap
     and a.ppcta = pn_cta
     and a.ppoper = pn_ope
     and a.ppsbop = pn_sbo
     and a.pptope = pn_top
     and a.d601co = 'S'
     and a.ppfpag <= pd_fecpro
     and not exists (select b.ppmod,
                 b.ppsuc,
                 b.ppmda,
                 b.pppap,
                 b.ppcta,
                 b.ppoper,
                 b.ppsbop,
                 b.pptope,
                 b.ppfpag
            from fsd602 b
           where b.pgcod = a.pgcod
             and b.ppmod = a.ppmod
             and b.ppsuc = a.ppsuc
             and b.ppmda = a.ppmda
             and b.pppap = a.pppap
             and b.ppcta = a.ppcta
             and b.ppoper = a.ppoper
             and b.ppsbop = a.ppsbop
             and b.pptope = a.pptope
             and b.ppfpag = a.ppfpag
             and b.d602co = 'S'
             and b.pp1stat = 'T'
             and (b.pp1cap + b.pp1int) <> 0)
   order by a.ppfpag;
    exception
      when others then
        null;
    end;

  return(DeuTot);
end fn_Obt_Deu_Tot;
/

