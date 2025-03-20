create or replace function sp_cr_lineas_utilizadas(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return char is
ln_existe number(5);
lc_ex char(1);
cursor creditos is
select * from fsr011 a
                 where a.r2cod = pn_emp
                   and a.r2mod =pn_mod
                   and a.r2suc =pn_suc
                   and a.r2mda =pn_mda
                   and a.r2pap =pn_pap
                   and a.r2cta =pn_cta
                   and a.r2oper =pn_oper
                   and a.r2sbop =pn_sbop
                   and a.r2tope =pn_top
                   and relcod = 46; 
                   
begin
          begin
               lc_ex := 'N';
               for i in creditos loop
                   begin
                     select count(*)
                       into ln_existe
                       from fsd010 a
                      where a.pgcod =  i.r1cod 
                        and a.aomod =  i.r1mod 
                        and a.aosuc =  i.r1suc 
                        and a.aomda =  i.r1mda 
                        and a.aopap =  i.r1pap 
                        and a.aocta  = i.r1cta 
                        and a.aooper = i.r1oper
                        and a.aosbop = i.r1sbop
                        and a.aotope = i.r1tope
                        and aostat <> 99;
                   exception
                        when no_data_found then
                             ln_existe :=0;
                   end;
                   if ln_existe > 0 then
                      lc_ex := 'S';
                      exit;
                      
                   end if;
                   
               end loop;
                
          end;  
  return lc_ex;
end sp_cr_lineas_utilizadas;
/

