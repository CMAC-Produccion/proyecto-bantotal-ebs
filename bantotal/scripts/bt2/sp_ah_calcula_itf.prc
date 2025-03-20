CREATE OR REPLACE Procedure sp_ah_calcula_itf(P_N_MONTO IN NUMBER,
                              p_n_itf out number
                              ) is
  ln_itf  number(10,2):=0;
  begin
    ln_itf := pq_ah_compensa_ctas.fn_calcula_itf(P_N_MONTO);
    p_n_itf := ln_itf;
  Exception
  when others then
    p_n_itf := 0;
    return;
  end sp_ah_calcula_itf;
/

