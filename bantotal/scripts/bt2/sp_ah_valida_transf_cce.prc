create or replace procedure sp_ah_valida_transf_cce(P_N_PGCOD  IN NUMBER,
                                                    P_N_ITMOD  IN NUMBER,
                                                    P_N_ITSUC  IN NUMBER,
                                                    P_N_ITTRAN IN NUMBER,
                                                    P_N_ITNREL IN NUMBER,
                                                    P_D_FECCON IN DATE,
                                                    p_c_indcla out varchar2
                                                    ) is
begin
  Select trim(a.se115clasi)
    into p_c_indcla
    from fse115 a 
   where a.se115cd = P_N_PGCOD
     and a.se115su = P_N_ITSUC
     and a.se115md = P_N_ITMOD
     and a.se115tr = P_N_ITTRAN
     and a.se115re = P_N_ITNREL
     and a.se115fc = P_D_FECCON;
exception
when others then  
  p_c_indcla := 'M';  
end sp_ah_valida_transf_cce;
/

