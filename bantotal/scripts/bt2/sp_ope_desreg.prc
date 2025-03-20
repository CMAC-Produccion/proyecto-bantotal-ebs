create or replace procedure sp_ope_desreg(P_N_CODAGE in number,P_C_NOMREG out Varchar2) is
   begin
      begin
      select f.tp1desc into P_C_NOMREG
      from fst810 t81 , fst811 t80, fst198 f 
      where t80.pgcod = t81.pgcod
      and t80.regcod = t81.regcod
      and t81.regcod = f.tp1nro2 
      and  tp1cod = 1 and tp1cod1= 10872 and tp1corr1= 11
      and  t81.regcod < 100
      and  t80.regcod < 100  
      and  t80.oficod = P_N_CODAGE;
    exception
       when no_data_found then
            P_C_NOMREG := null;
       when others then
            P_C_NOMREG := null;
      end;           
end;
/

