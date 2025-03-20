create or replace package PQ_CR_CENTRAL is

  -- Author  : ABERNEDO
  -- Created : 28/09/2015 10:08:06 a.m.
  -- Purpose : 
  -- Modificacion: CHERNANDEZ
  -- Fecha Modificación: 22/01/2020
  -- Descripcion: Se agrandó variable sp_promtot
  Procedure Sp_Atraso_Acumulado(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                              pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                              pn_top in number,pd_fecpro in date,pd_fecven in date,
                              ln_atraTot out number);
                              
  Procedure Sp_Max_atraso(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                        pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                        pn_top in number,pd_fecpro in date,pd_fecven in date,
                        ln_maxAtr out number) ;
                        
  Procedure Sp_DiaAtr_Ultima(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                           pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                           pn_top in number,pd_fecpro in date,pd_fecven in date,
                           ln_atrult out number) ;
                           
  Procedure Sp_6meses(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,pd_fecpro in date,ln_atr6 out number);
                    
  Procedure Sp_12meses(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,pd_fecpro in date,ln_atr12 out number);
                    
  Procedure Sp_24meses(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,pd_fecpro in date,ln_atr24 out number);
                    
  Procedure Sp_PromTot(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,pd_fecpro in date,ln_atrtot out number);   
                    
  procedure sp_cr_ultCuota (pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,ultcuota out number);                                                                    

end PQ_CR_CENTRAL;
/

create or replace package body PQ_CR_CENTRAL is

Procedure Sp_Atraso_Acumulado(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                              pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                              pn_top in number,pd_fecpro in date,pd_fecven in date,
                              ln_atraTot out number)is
cursor creditos is
select * from fsd601 a
where a.pgcod = pn_emp
  and a.ppmod = pn_mod
  and a.ppsuc = pn_suc
  and a.ppmda = pn_mda
  and a.pppap = pn_pap
  and a.ppcta = pn_cta
  and a.ppoper = pn_ope
  and a.ppsbop = pn_Sbo
  and a.pptope = pn_top
  and a.ppfpag <= pd_fecpro
  and a.D601co = 'S'
  and (a.ppcap + a.ppint) > 0;
  
ln_atra number(5);                              

begin
      begin
        ln_atraTot := 0;
        If pn_mod in (200,33,141) Then   

           ln_atraTot := pd_fecpro - pd_fecven;

           If ln_atraTot < 0 then
              ln_atraTot := 0 ;
           End if;

        Else
        
           begin
           
               for i in creditos loop
                   begin
                      select (b.pp1fech - b.ppfpag)
                        into ln_atra
                        from FSD602 b 
                       where b.Pgcod = i.Pgcod
                         and b.Ppmod = i.Ppmod
                         and b.Ppsuc = i.Ppsuc
                         and b.Ppmda = i.Ppmda
                         and b.Pppap = i.Pppap
                         and b.Ppcta = i.Ppcta
                         and b.Ppoper = i.Ppoper
                         and b.Ppsbop = i.Ppsbop
                         and b.Pptope = i.Pptope
                         and b.Ppfpag = i.Ppfpag
                         and b.Pptipo = i.Pptipo
                         and b.Pp1stat = 'T'
                         and b.D602co = 'S'
                         and b.pp1fech <= pd_fecpro;---<= pd_fecpro;
                   exception
                         when no_data_found then
                              ln_atra := pd_fecpro - i.Ppfpag;
                         when too_many_rows then
                            select (b.pp1fech - b.ppfpag)
                              into ln_atra
                              from FSD602 b 
                             where b.Pgcod = i.Pgcod
                               and b.Ppmod = i.Ppmod
                               and b.Ppsuc = i.Ppsuc
                               and b.Ppmda = i.Ppmda
                               and b.Pppap = i.Pppap
                               and b.Ppcta = i.Ppcta
                               and b.Ppoper = i.Ppoper
                               and b.Ppsbop = i.Ppsbop
                               and b.Pptope = i.Pptope
                               and b.Ppfpag = i.Ppfpag
                               and b.Pptipo = i.Pptipo
                               and b.Pp1stat = 'T'
                               and b.D602co = 'S'
                               and b.pp1fech <= pd_fecpro
                               and rownum = 1;    
                   end;
                   
                   if ln_atra < 0 then
                      ln_atra := 0;
                   end if;
                   ln_atraTot := ln_atraTot + ln_atra;
                   
               end loop;
           end;
        
        end if;
      
      end;
end Sp_Atraso_Acumulado;

Procedure Sp_Max_atraso(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                        pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                        pn_top in number,pd_fecpro in date,pd_fecven in date,
                        ln_maxAtr out number) is
cursor creditos is
select * from fsd601 a
where a.pgcod = pn_emp
  and a.ppmod = pn_mod
  and a.ppsuc = pn_suc
  and a.ppmda = pn_mda
  and a.pppap = pn_pap
  and a.ppcta = pn_cta
  and a.ppoper = pn_ope
  and a.ppsbop = pn_Sbo
  and a.pptope = pn_top
  and a.ppfpag <= pd_fecpro
  and a.D601co = 'S'
  and (a.ppcap + a.ppint) > 0;
  
ln_atra number(5)  ;

begin

  begin
      ln_maxAtr := 0;
      If pn_mod in (200,33,141) Then   

           ln_maxAtr := pd_fecpro - pd_fecven;

           If ln_maxAtr < 0 then
              ln_maxAtr := 0 ;
           End if;

        Else
           begin
               for i in creditos loop
                   begin
                      select (b.pp1fech - b.ppfpag)
                        into ln_atra
                        from FSD602 b 
                       where b.Pgcod = i.Pgcod
                         and b.Ppmod = i.Ppmod
                         and b.Ppsuc = i.Ppsuc
                         and b.Ppmda = i.Ppmda
                         and b.Pppap = i.Pppap
                         and b.Ppcta = i.Ppcta
                         and b.Ppoper = i.Ppoper
                         and b.Ppsbop = i.Ppsbop
                         and b.Pptope = i.Pptope
                         and b.Ppfpag = i.Ppfpag
                         and b.Pptipo = i.Pptipo
                         and b.Pp1stat = 'T'
                         and b.D602co = 'S'
                         and b.pp1fech <= pd_fecpro
                         and rownum = 1;
                   exception
                         when no_data_found then
                              ln_atra := pd_fecpro - i.Ppfpag;
                        
                                
                   end;
                   
                   if ln_atra < 0 then
                      ln_atra := 0;
                   end if;
                   if ln_atra > ln_maxAtr then 
                      ln_maxAtr := ln_atra;
                   end if;
                   
                   
               end loop;
           end;
        
        
      end if;
  end;      

end Sp_Max_atraso;

Procedure Sp_DiaAtr_Ultima(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                           pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                           pn_top in number,pd_fecpro in date,pd_fecven in date,
                           ln_atrult out number) is
ld_ultfec date;
begin
     --obtiene ultima fecha de vigentes
     begin
         select max(a.ppfpag)
           into ld_ultfec
           from fsd602 a
          where a.pgcod = pn_emp
            and a.ppmod = pn_mod
            and a.ppsuc = pn_suc
            and a.ppmda = pn_mda
            and a.pppap = pn_pap
            and a.ppcta = pn_cta
            and a.ppoper = pn_ope
            and a.ppsbop = pn_Sbo
            and a.pptope = pn_top
            and a.Pp1stat = 'T'
            and a.D602co = 'S'
            and a.pp1fech <= pd_fecpro
            ;
     exception
            when no_data_found then
                 begin
                 
                      select /*+ parallel(n,2,1)*/  
                             min(n.ppfpag) 
                        into ld_ultfec   
                        from fsd601 n 
                       where n.pgcod  = pn_emp     
                         and n.ppcta  = pn_cta     
                         and n.ppmda  = pn_mda    
                         and n.ppsuc  = pn_suc    
                         and n.pppap  = pn_pap    
                         and n.ppoper = pn_ope
                         and n.ppsbop = pn_sbo
                         and n.pptope = pn_top  
                         and n.ppmod  = pn_mod    
                         and n.d601co = 'S'
                         and (n.ppcap+n.ppint)<>0
                         and n.ppfpag <= pd_fecpro;
                 exception
                        when no_data_found then
                             ld_ultfec := null;
                 end;
                 
     end;
     
     --calcula los dias de atraso de la ultima cuota
     
     If pn_mod in (200,33,141) Then   

           ln_atrult := pd_fecpro - pd_fecven;

           If ln_atrult < 0 then
              ln_atrult := 0 ;
           End if;

        Else
           begin
                 
                      select /*+ parallel(n,2,1)*/  
                             (n.pp1fech-ld_ultfec)
                        into ln_atrult   
                        from fsd602 n 
                       where n.pgcod  = pn_emp     
                         and n.ppcta  = pn_cta     
                         and n.ppmda  = pn_mda    
                         and n.ppsuc  = pn_suc    
                         and n.pppap  = pn_pap    
                         and n.ppoper = pn_ope
                         and n.ppsbop = pn_sbo
                         and n.pptope = pn_top  
                         and n.ppmod  = pn_mod   
                         and n.ppfpag = ld_ultfec
                         and n.d602co = 'S'
                         and n.pp1stat = 'T'
                         and n.pp1fech <= pd_fecpro
                         and rownum < 2;
                 exception
                        when no_data_found then
                            ln_atrult := pd_fecpro - ld_ultfec;
                 end;
           
           If ln_atrult < 0 then
              ln_atrult := 0 ;
           End if;
           
     end if;
        
end Sp_DiaAtr_Ultima;

Procedure Sp_6meses(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,pd_fecpro in date,ln_atr6 out number)is
cursor creditos is
select * from fsd601 a
where a.pgcod = pn_emp
  and a.ppmod = pn_mod
  and a.ppsuc = pn_suc
  and a.ppmda = pn_mda
  and a.pppap = pn_pap
  and a.ppcta = pn_cta
  and a.ppoper = pn_ope
  and a.ppsbop = pn_Sbo
  and a.pptope = pn_top
  and a.ppfpag <= pd_fecpro
  and a.D601co = 'S'
  and (a.ppcap + a.ppint) > 0
order by a.ppfpag desc;
ln_cont number(5);
ln_atra number(5);
ln_atraTot number(5);
begin
      begin
         ln_cont := 0;
         ln_atraTot := 0;
         for i in creditos loop
             ln_cont := ln_cont + 1;
             if ln_cont <= 6 then
                 begin
                      select (b.pp1fech - b.ppfpag)
                        into ln_atra
                        from FSD602 b 
                       where b.Pgcod = i.Pgcod
                         and b.Ppmod = i.Ppmod
                         and b.Ppsuc = i.Ppsuc
                         and b.Ppmda = i.Ppmda
                         and b.Pppap = i.Pppap
                         and b.Ppcta = i.Ppcta
                         and b.Ppoper = i.Ppoper
                         and b.Ppsbop = i.Ppsbop
                         and b.Pptope = i.Pptope
                         and b.Ppfpag = i.Ppfpag
                         and b.Pptipo = i.Pptipo
                         and b.Pp1stat = 'T'
                         and b.D602co = 'S'
                         and b.pp1fech <= pd_fecpro
                         and rownum = 1;
                   exception
                         when no_data_found then
                              ln_atra := pd_fecpro - i.Ppfpag;
                   end;
                   if ln_atra < 0 then
                      ln_atra := 0;
                   end if;
                   ln_atraTot := ln_atraTot + ln_atra;
                
             end if;
             if ln_cont = 6 then
                exit;
             end if;
         
         end loop;
         if ln_cont <> 0 then
            ln_atr6 := ln_atraTot/ln_cont;
            else
                     ln_atr6 :=0;
         end if;
      
      end;

end Sp_6meses;

Procedure Sp_12meses(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,pd_fecpro in date,ln_atr12 out number)is
cursor creditos is
select * from fsd601 a
where a.pgcod = pn_emp
  and a.ppmod = pn_mod
  and a.ppsuc = pn_suc
  and a.ppmda = pn_mda
  and a.pppap = pn_pap
  and a.ppcta = pn_cta
  and a.ppoper = pn_ope
  and a.ppsbop = pn_Sbo
  and a.pptope = pn_top
  and a.ppfpag <= pd_fecpro
  and a.D601co = 'S'
  and (a.ppcap + a.ppint) > 0
order by a.ppfpag desc;
ln_cont number(5);
ln_atra number(5);
ln_atraTot number(5);
begin
      begin
         ln_cont := 0;
         ln_atraTot := 0;
         for i in creditos loop
             ln_cont := ln_cont + 1;
             if ln_cont <= 12 then
                 begin
                      select (b.pp1fech - b.ppfpag)
                        into ln_atra
                        from FSD602 b 
                       where b.Pgcod = i.Pgcod
                         and b.Ppmod = i.Ppmod
                         and b.Ppsuc = i.Ppsuc
                         and b.Ppmda = i.Ppmda
                         and b.Pppap = i.Pppap
                         and b.Ppcta = i.Ppcta
                         and b.Ppoper = i.Ppoper
                         and b.Ppsbop = i.Ppsbop
                         and b.Pptope = i.Pptope
                         and b.Ppfpag = i.Ppfpag
                         and b.Pptipo = i.Pptipo
                         and b.Pp1stat = 'T'
                         and b.D602co = 'S'
                         and b.pp1fech <= pd_fecpro
                         and rownum = 1;
                   exception
                         when no_data_found then
                              ln_atra := pd_fecpro - i.Ppfpag;
                   end;
                   if ln_atra < 0 then
                      ln_atra := 0;
                   end if;
                   ln_atraTot := ln_atraTot + ln_atra;
                
             end if;
             if ln_cont = 12 then
                exit;
             end if;
         
         end loop;
         if ln_cont <> 0 then
            ln_atr12 := ln_atraTot/ln_cont;
            else
                     ln_atr12 :=0;
         end if;
      end;

end Sp_12meses;

--------------------------------------------------------------------------------------------------
Procedure Sp_24meses(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,pd_fecpro in date,ln_atr24 out number)is
cursor creditos is
select * from fsd601 a
where a.pgcod = pn_emp
  and a.ppmod = pn_mod
  and a.ppsuc = pn_suc
  and a.ppmda = pn_mda
  and a.pppap = pn_pap
  and a.ppcta = pn_cta
  and a.ppoper = pn_ope
  and a.ppsbop = pn_Sbo
  and a.pptope = pn_top
  and a.ppfpag <= pd_fecpro
  and a.D601co = 'S'
  and (a.ppcap + a.ppint) > 0
order by a.ppfpag desc;
ln_cont number(5);
ln_atra number(5);
ln_atraTot number(5);
begin
      begin
         ln_cont := 0;
         ln_atraTot := 0;
         for i in creditos loop
             ln_cont := ln_cont + 1;
             if ln_cont <= 24 then
                 begin
                      select (b.pp1fech - b.ppfpag)
                        into ln_atra
                        from FSD602 b 
                       where b.Pgcod = i.Pgcod
                         and b.Ppmod = i.Ppmod
                         and b.Ppsuc = i.Ppsuc
                         and b.Ppmda = i.Ppmda
                         and b.Pppap = i.Pppap
                         and b.Ppcta = i.Ppcta
                         and b.Ppoper = i.Ppoper
                         and b.Ppsbop = i.Ppsbop
                         and b.Pptope = i.Pptope
                         and b.Ppfpag = i.Ppfpag
                         and b.Pptipo = i.Pptipo
                         and b.Pp1stat = 'T'
                         and b.D602co = 'S'
                         and b.pp1fech <= pd_fecpro;
                   exception
                         when no_data_found then
                              ln_atra := pd_fecpro - i.Ppfpag;
                         when too_many_rows then
                             select (b.pp1fech - b.ppfpag)
                        into ln_atra
                        from FSD602 b 
                       where b.Pgcod = i.Pgcod
                         and b.Ppmod = i.Ppmod
                         and b.Ppsuc = i.Ppsuc
                         and b.Ppmda = i.Ppmda
                         and b.Pppap = i.Pppap
                         and b.Ppcta = i.Ppcta
                         and b.Ppoper = i.Ppoper
                         and b.Ppsbop = i.Ppsbop
                         and b.Pptope = i.Pptope
                         and b.Ppfpag = i.Ppfpag
                         and b.Pptipo = i.Pptipo
                         and b.Pp1stat = 'T'
                         and b.D602co = 'S'
                         and b.pp1fech <= pd_fecpro
                         and rownum = 1;   
                   end;
                   if ln_atra < 0 then
                      ln_atra := 0;
                   end if;
                   ln_atraTot := ln_atraTot + ln_atra;
                
             end if;
             if ln_cont = 24 then
                exit;
             end if;
         
         end loop;
         if ln_cont <> 0 then
            ln_atr24 := ln_atraTot/ln_cont;
            else
                     ln_atr24 :=0;
         end if;
      end;

end Sp_24meses;


---------------------------------------------------------------------------------------------------
Procedure Sp_PromTot(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,pd_fecpro in date,ln_atrtot out number)is
cursor creditos is
select * from fsd601 a
where a.pgcod = pn_emp
  and a.ppmod = pn_mod
  and a.ppsuc = pn_suc
  and a.ppmda = pn_mda
  and a.pppap = pn_pap
  and a.ppcta = pn_cta
  and a.ppoper = pn_ope
  and a.ppsbop = pn_Sbo
  and a.pptope = pn_top
  and a.ppfpag <= pd_fecpro
  and a.D601co = 'S'
  and (a.ppcap + a.ppint) > 0
order by a.ppfpag desc;
ln_cont number(5);
--chernandez 22/01/2020 se cambió variables de 5 a 8
ln_atra number(8);
ln_atraTot number(8);
begin
      begin
         ln_cont := 0;
         ln_atraTot := 0;
         for i in creditos loop
             ln_cont := ln_cont + 1;
             --if ln_cont <= 12 then
                 begin
                      select (b.pp1fech - b.ppfpag)
                        into ln_atra
                        from FSD602 b 
                       where b.Pgcod = i.Pgcod
                         and b.Ppmod = i.Ppmod
                         and b.Ppsuc = i.Ppsuc
                         and b.Ppmda = i.Ppmda
                         and b.Pppap = i.Pppap
                         and b.Ppcta = i.Ppcta
                         and b.Ppoper = i.Ppoper
                         and b.Ppsbop = i.Ppsbop
                         and b.Pptope = i.Pptope
                         and b.Ppfpag = i.Ppfpag
                         and b.Pptipo = i.Pptipo
                         and b.Pp1stat = 'T'
                         and b.D602co = 'S'
                         and b.pp1fech <= pd_fecpro;
                   exception
                         when no_data_found then
                              ln_atra := pd_fecpro - i.Ppfpag;
                         when too_many_rows then
                           select (b.pp1fech - b.ppfpag)
                        into ln_atra
                        from FSD602 b 
                       where b.Pgcod = i.Pgcod
                         and b.Ppmod = i.Ppmod
                         and b.Ppsuc = i.Ppsuc
                         and b.Ppmda = i.Ppmda
                         and b.Pppap = i.Pppap
                         and b.Ppcta = i.Ppcta
                         and b.Ppoper = i.Ppoper
                         and b.Ppsbop = i.Ppsbop
                         and b.Pptope = i.Pptope
                         and b.Ppfpag = i.Ppfpag
                         and b.Pptipo = i.Pptipo
                         and b.Pp1stat = 'T'
                         and b.D602co = 'S'
                         and b.pp1fech <= pd_fecpro
                         and rownum = 1;
                   end;
                   if ln_atra < 0 then
                      ln_atra := 0;
                   end if;
                   ln_atraTot := ln_atraTot + ln_atra;
                
             --end if;
         
         end loop;
         if ln_cont <> 0 then
            ln_atrtot := ln_atraTot/ln_cont;
            else
                     ln_atrtot :=0;
         end if;
      end;

end Sp_PromTot;
------------------------------------------------------------------------------------

--Calcula la ultima cuota pendiente de Pago
procedure sp_cr_ultCuota (pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_Sbo in number,
                    pn_top in number,ultcuota out number) is
   
fecha602 date; 
mont601 number;  
seguro  number;         
  
begin 

begin
     
  select max(ppfpag)
  into fecha602
  from FSD602
 where Pgcod = pn_emp
   and Ppmod = pn_mod
   and Ppsuc = pn_suc
   and Ppmda = pn_mda
   and Pppap = pn_pap
   and Ppcta = pn_cta
   and Ppoper = pn_ope
   and Ppsbop = pn_Sbo
   and Pptope = pn_top
   and Pp1stat = 'T'
   and D602co = 'S';
   exception when others then 
                   NULL;
   
   if fecha602 is null then  -- 23/11/15 MPOSTIGOC
     
       begin       
         select min(ppfpag)
           into fecha602
           from fsd601 d601
          where d601.pgcod = pn_emp
            and d601.ppmod = pn_mod
            and d601.ppsuc = pn_suc
            and d601.ppmda = pn_mda
            and d601.pppap = pn_pap
            and d601.ppcta = pn_cta
            and d601.ppoper = pn_ope
            and d601.ppsbop = pn_Sbo
            and d601.pptope = pn_top
            and d601.d601co = 'S';
       exception when too_many_rows then
           NULL;
         
       end;
      end if;
   end;
   
begin

  select sum(Ppcap + Ppint + Ppiint)
    into mont601
    from fsd601
   WHERE pgcod = pn_emp
     and Ppmod = pn_mod
     and Ppsuc = pn_suc
     and Ppmda = pn_mda
     and Pppap = pn_pap
     and Ppcta = pn_cta
     and Ppoper = pn_ope
     and Ppsbop = pn_Sbo
     and Pptope = pn_top
     and Ppfpag > fecha602
     and rownum = 1;
exception
  when others then
    NULL;
end;

begin
select sum(ppimp11)
into seguro
  from fsd611
 where pgcod = pn_emp
   and ppmod = pn_mod
   and ppsuc = pn_suc
   and ppmda = pn_mda
   and pppap = pn_pap
   and ppcta= pn_cta
   and ppoper = pn_ope
   and Ppfpag > fecha602
   and rownum = 1;
   exception when others then 
                   NULL;
   
  end; 
  
    ultcuota := nvl(mont601,0)+ nvl(seguro,0);            
                    

end sp_cr_ultCuota;

end PQ_CR_CENTRAL;
/

