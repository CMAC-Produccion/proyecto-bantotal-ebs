create or replace procedure Sp_actualiza_tasa(P_N_PGCOD IN NUMBER,
                                              P_N_ITSUC IN NUMBER,
                                              P_N_ITMOD IN NUMBER,
                                              P_N_ITTRA IN NUMBER,
                                              P_N_ITNRE IN NUMBER,
                                              P_N_ITORD IN NUMBER,
                                              P_D_FECPR IN DATE,
                                              P_N_TASA  IN NUMBER
                                             ) is
  pragma autonomous_transaction;
  ln_monto   number(17,2):=0;
  ln_mtorea  number(17,2):=0;
  ln_mtoint  number(17,2):=0;
  ln_itf     number(17,2):=0;
  ln_plazo   number(5):=0;
begin
   begin
     Select a.itimp1,a.itpzo
       into ln_monto,ln_plazo  
      from fsd016 a 
     where a.pgcod  = P_N_PGCOD
       and a.itsuc  = P_N_ITSUC
       and a.itmod  = P_N_ITMOD
       and a.ittran = P_N_ITTRA
       and a.itnrel = P_N_ITNRE
       and a.itord  = P_N_ITORD;
   Exception
   when others then    
     return;
   end;
   if P_N_ITMOD = 22 and P_N_ITTRA = 600 then
      begin
         Select a.itimp1
           into ln_itf
          from fsd016 a 
         where a.pgcod  = P_N_PGCOD
           and a.itsuc  = P_N_ITSUC
           and a.itmod  = P_N_ITMOD
           and a.ittran = P_N_ITTRA
           and a.itnrel = P_N_ITNRE    
           and a.rubro  like '25_%';
      Exception
      when others then 
        ln_itf := 0;
      End;
      ln_mtorea := ln_monto - ln_itf;
   Else
      ln_mtorea := ln_monto;
   End if;
   
   ln_mtoint := round(pq_ah_calc_dpf.fn_ah_calcint(ln_plazo,P_N_TASA,ln_mtorea),2);
   
   update fsd016 a 
      set a.ittasa = P_N_TASA,
          a.itimp2 = ln_mtoint,
          a.itimp3 = ln_monto + ln_mtoint
    where a.pgcod  = P_N_PGCOD
      and a.itsuc  = P_N_ITSUC
      and a.itmod  = P_N_ITMOD
      and a.ittran = P_N_ITTRA
      and a.itnrel = P_N_ITNRE
      and a.itord  = P_N_ITORD;
      commit;
      
   update fsd601 b
      set b.ppint = ln_mtoint
    where b.D601CD = P_N_PGCOD  
      and b.D601MO = P_N_ITMOD      
      and b.D601SU = P_N_ITSUC
      and b.D601TR = P_N_ITTRA 
      and b.D601RE = P_N_ITNRE 
      and b.D601FC = P_D_FECPR  
      and b.D601OR = P_N_ITORD;
      commit;
   
  if P_N_ITMOD = 22 and P_N_ITTRA = 800 then
     update fsd603 a 
        set PfdTas1  = P_N_TASA,
            PfdIm15  = ln_mtoint
      where a.pgcod  = P_N_PGCOD
        and a.itsuc  = P_N_ITSUC
        and a.itmod  = P_N_ITMOD
        and a.ittran = P_N_ITTRA
        and a.itnrel = P_N_ITNRE;
        commit;
  End If;
exception
when others then  
  null;
end Sp_actualiza_tasa;
/

