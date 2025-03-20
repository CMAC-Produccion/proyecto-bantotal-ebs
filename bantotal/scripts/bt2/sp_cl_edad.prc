create or replace procedure sp_cl_edad(P_D_FECSYS IN DATE,
                                       P_D_FECNAC IN DATE, 
                                       p_n_edad out number 
                                       ) is
begin
  p_n_edad := trunc(months_between(P_D_FECSYS,P_D_FECNAC)/12,0);
end sp_cl_edad;
/

