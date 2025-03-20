create or replace procedure sp_cr_valida_credito(P_N_CODMOD IN NUMBER,
                                                 P_N_OPERAC IN NUMBER,
                                                 P_N_CODMON IN NUMBER,
                                                 p_c_inserta out varchar2
                                                 ) is
begin
 select 'S' 
   into p_c_inserta
   from fsd010 a,
        fst198 b
  where b.tp1cod   = a.pgcod
    and b.tp1cod1  = 10807  
    and b.tp1corr1 = 41
    and b.tp1nro1  = a.aosuc
    and a.pgcod    = 1  
    and a.aopap    = 0
    and a.aostat   <> 99  
    and a.aomod    = P_N_CODMOD
    and a.aooper   = P_N_OPERAC
    and a.aomda    = P_N_CODMON
    and rownum = 1
    ;
exception
when others then
   p_c_inserta := 'N';     
end sp_cr_valida_credito;
/

