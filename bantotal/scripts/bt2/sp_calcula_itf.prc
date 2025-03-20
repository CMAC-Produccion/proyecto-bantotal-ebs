create or replace procedure SP_CALCULA_ITF(P_N_PGCOD  IN NUMBER,
                                           P_N_SCMOD  IN NUMBER,
                                           P_N_SCSUC  IN NUMBER,
                                           P_N_SCMDA  IN NUMBER,
                                           P_N_SCPAP  IN NUMBER,
                                           P_N_SCCTA  IN NUMBER,
                                           P_N_SCOPER IN NUMBER,
                                           P_N_SCSBOP IN NUMBER,
                                           P_N_SCTOPE IN NUMBER,
                                           P_N_MONTO  IN NUMBER,
                                           P_N_AFECT  OUT NUMBER,
                                           P_N_ITF    OUT NUMBER) is

  lc_exoner char(1);
begin

  P_N_AFECT := 0;
  lc_exoner := pq_ah_compensa_ctas.fn_cr_verexonera(p_n_pgcod,
                                                    p_n_scmod,
                                                    p_n_scsuc,
                                                    p_n_scmda,
                                                    p_n_scpap,
                                                    p_n_sccta,
                                                    p_n_scoper,
                                                    p_n_scsbop,
                                                    p_n_sctope);

  If lc_exoner = 'N' then
    P_N_ITF := pq_ah_compensa_ctas.fn_calcula_itf(P_N_MONTO);
    P_N_AFECT := 1;
  End If;

end SP_CALCULA_ITF;
/

