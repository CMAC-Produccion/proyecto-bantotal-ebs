create or replace procedure sp_ah_saltot_supe(P_D_FECPRO IN DATE,
                                              P_N_NUMCTA IN NUMBER,
                                              P_N_CTAEMP IN NUMBER,
                                              P_N_MDAREM IN NUMBER,  
                                              p_n_saltot out number      
                                              ) is
begin
  --OBTENEMOS EL SALDO DE LA FSD011
  Select round(sum(case
                     when P_N_MDAREM > a.scmda then
                      a.scsdo * fn_tipo_cambio(P_D_FECPRO, a.scmda, P_N_MDAREM, 500)
                     when P_N_MDAREM < a.scmda then
                      a.scsdo / fn_tipo_cambio(P_D_FECPRO, a.scmda, P_N_MDAREM, 500)
                     else
                      a.scsdo
                   end),
               2)
    into p_n_saltot
    from fsd011 a, fsr011 b
   where a.pgcod = b.r1cod
     and a.scmda = b.r2mda
     and a.scpap = b.r2mda
     and a.sccta = b.r2cta
     and a.scoper = b.r2oper
     and a.scsbop = b.r2sbop
     and a.scsuc = b.r2suc
     and a.sctope = b.r2tope
     and a.scmod = b.r2mod
     and b.r011co = 'S'
     and b.relcod = 45
     and b.r1cta = P_N_CTAEMP
     and a.pgcod = 1
     and a.scmod = 21
     and a.scpap = 0
     and a.scoper = 0
     and a.sctope = 2
     and a.sccta = P_N_NUMCTA
     and a.scsdo <> 0
     and a.scstat <> 99;
Exception      
when others then
  p_n_saltot := 0;
end sp_ah_saltot_supe;
/

