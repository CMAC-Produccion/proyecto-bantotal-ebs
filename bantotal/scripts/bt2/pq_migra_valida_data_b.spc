create or replace package pq_migra_valida_data_b is

  procedure sp_job_valida_data_b (p_c_error out varchar2);
  procedure sp_inserta_valida_data_b(P_C_DIGITO1 IN VARCHAR2,
                                   P_C_DIGITO2 IN VARCHAR2,
                                   ln_ini      in number
                                   );                              

end pq_migra_valida_data_b;
/

