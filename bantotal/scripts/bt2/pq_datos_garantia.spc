CREATE OR REPLACE PACKAGE pq_datos_Garantia IS
  procedure sp_modulo_ope(p_c_indins in varchar2,  p_c_indnew in varchar2, p_n_codsug in number, p_n_codtsp in number,
                          ln_modulo out number, ln_totope out number);
                                   
    function fn_aval(P_N_CODPAT in number) return varchar2 ;
      
  function fn_ultimo_asiento(P_N_CODPAT in number) return number;
  --procedure sp_ganate ;
END pq_datos_Garantia;
/

