create or replace function Fn_Cr_saldo_relacion_linea(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,/*pn_top in number,*/ pn_nrorel in number,
                           pn_rubro in number) return number is
ln_saldo number;
ln_rubro number;
begin
  if pn_mod = 117 then 
  
               begin
               
                 select re.rrrubr
                   into ln_rubro
                   from fsr014 re
                  where re.rubro = pn_rubro
                    and re.rrcod = 18;
               exception
                    when others then 
                         ln_rubro := null;
               end;
                  
               begin
                   select s.scsdo
                     into ln_saldo
                     from fsr014 r, fsd011 s
                    where s.pgcod = pn_emp
                      and s.scsuc = pn_suc
                      and r.rubro = ln_rubro
                      and r.rrrubr= s.scrub
                      and r.rrcod = pn_nrorel
                      and s.scmda = pn_mda
                      and s.scpap = pn_pap
                      and s.sccta = pn_cta
                      and s.scoper= pn_oper
                      and s.scsbop= pn_sbop;
                  exception
                      when others then
                         ln_saldo := NULL;
                  end;
   end if;
  return ln_saldo;
end Fn_Cr_saldo_relacion_linea;
/

