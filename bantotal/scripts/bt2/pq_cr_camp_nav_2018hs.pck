create or replace package pq_cr_camp_nav_2018hs is

  -- Author  : HSUAREZ
  -- Created : 1/10/2018 8:27:34 a. m.
  -- Purpose : 
  -- Public function and procedure declarations
  Procedure sp_cr_resolutor_DPF_plazo (pn_ins in number,pn_plazo out number,flag_pzo out char);

end pq_cr_camp_nav_2018hs;
/

create or replace package body pq_cr_camp_nav_2018hs is

Procedure sp_cr_resolutor_DPF_plazo (pn_ins in number,pn_plazo out number,flag_pzo out char) is
cursor estados is
select tp1cod,
       tp1cod1,
       tp1corr1,
       tp1corr2,
       tp1corr3,
       tp1nro1
  from fst198
 where tp1cod  = 1
   and tp1cod1 = 10899
   and tp1corr1= 40 
   and tp1corr2= 2
   and tp1corr3>0;
   
cursor garantias is
select s.sng122pgc  ln_pgcodGar,
       s.sng122mod  ln_modGar,
       s.sng122suc  ln_sucGar,
       s.sng122mda  ln_mdaGar,
       s.sng122pap  ln_papGar,
       s.sng122cta  ln_ctaGar,
       s.sng122oper ln_operGar,
       s.sng122sbop ln_sbopGar,
       s.sng122tope ln_topeGar
  from sng122 s
 where sng122inst = pn_ins
   and s.sng122tope in (80, 85);
ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);
ln_tasa number(10,6);
ln_tasaFinal number(10,6);
tmp_plazo number(17,6);
ln_pzo number(17,6);
guia_pzo number(17,6);
begin
     ln_tasaFinal := 0; 
     guia_pzo:=999; 
      
     for i in garantias loop
       for j in estados loop
         begin
           select r.r1cod,
                  r.r1mod,
                  r.r1suc,
                  r.r1mda,
                  r.r1pap,
                  r.r1cta,
                  r.r1oper,
                  r.r1sbop,
                  r.r1tope
             into ln_emp,
                  ln_mod,
                  ln_suc,
                  ln_mda,
                  ln_pap,
                  ln_cta,
                  ln_ope,   
                  ln_sbo,
                  ln_top
             from fsr011 r, fsd010 f
            where r.r2cod  = i.ln_pgcodGar
              and r.r2mod  = i.ln_modGar
              and r.r2suc  = i.ln_sucGar
              and r.r2mda  = i.ln_mdaGar
              and r.r2pap  = i.ln_papGar
              and r.r2cta  = i.ln_ctaGar
              and r.r2oper = i.ln_operGar
              and r.r2sbop = i.ln_sbopGar
              and r.r2tope = i.ln_topeGar
              and r.relcod = 2
              and r.r1cod  = f.pgcod
              and r.r1mod  = f.aomod
              and r.r1suc  = f.aosuc
              and r.r1mda  = f.aomda
              and r.r1pap  = f.aopap
              and r.r1cta  = f.aocta
              and r.r1oper = f.aooper
              and r.r1sbop = f.aosbop
              and r.r1tope = f.aotope
              and f.aostat = j.tp1nro1; --estados en guia.
         exception
              when others then null;
         end;
         
         begin
           select 
               f.aopzo
           into
               tmp_plazo
           from fsd010 f
           where f.pgcod = ln_emp
           and   f.aomod = ln_mod
           and   f.aosuc = ln_suc
           and   f.aomda = ln_mda
           and   f.aopap = ln_pap
           and   f.aocta = ln_cta
           and   f.aooper= ln_ope   
           and   f.aosbop= ln_sbo
           and   f.aotope= ln_top; 
         exception
              when others then null;
         end;  
         begin
                 select
                    tp1nro1       
                 into
                    ln_pzo
                 from fst198
                 where tp1cod  = 1
                 and   tp1cod1 = 10899
                 and   tp1corr1= 40
                 and   tp1corr2= 1
                 and   tp1corr3= 1;
         exception
              when others then null;
         end;     
         --if tmp_plazo>=guia_pzo then
         --flag_pzo:='N';           
            if tmp_plazo<guia_pzo then 
              --ln_pzo := tmp_plazo;
               guia_pzo := tmp_plazo;
            end if;            
         --else
         --flag_pzo:='S';
         --exit;
         --end if;         
         tmp_plazo:=0;
      end loop;                                    
     end loop;
     if guia_pzo=999 then
       guia_pzo:=0;
       end if;
     pn_plazo := guia_pzo;
	 
     if guia_pzo=999 or pn_plazo>=ln_pzo then --Validamos que el plazo sea mayor a la de la guia. si es asi no salta bloqueante
        flag_pzo:='N';
       end if;
     if pn_plazo<ln_pzo then --Si el plazo es menor a la de la guia entonces salta la politica bloqueante.
        flag_pzo:='S'; 
     end if;  
     end sp_cr_resolutor_DPF_plazo;  
  
end pq_cr_camp_nav_2018hs;
/

