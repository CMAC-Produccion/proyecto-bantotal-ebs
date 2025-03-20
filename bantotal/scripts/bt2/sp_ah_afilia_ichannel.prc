create or replace procedure SP_AH_AFILIA_ICHANNEL(P_C_JAQY660TIP IN VARCHAR2,
                                                  P_N_JAQY660PGO IN NUMBER,
                                                  P_N_JAQY660SUC IN NUMBER,
                                                  P_N_JAQY660MOD IN NUMBER,
                                                  P_N_JAQY660MDA IN NUMBER,
                                                  P_N_JAQY660CTA IN NUMBER,
                                                  P_N_JAQY660PAP IN NUMBER,
                                                  P_N_JAQY660OPE IN NUMBER,
                                                  P_N_JAQY660SUB IN NUMBER,
                                                  P_N_JAQY660TOP IN NUMBER,    
                                                  P_D_JAQY660FCH IN DATE,
                                                  P_C_JAQY660USU IN VARCHAR2,  
                                                  P_C_JAQY660TPR IN VARCHAR2,
                                                  P_C_JAQY660TME IN VARCHAR2,
                                                  P_C_JAQY660AFI IN VARCHAR2,
                                                  P_C_JAQY660FDE IN DATE,
                                                  P_C_JAQY660UDE IN VARCHAR2,
                                                  P_C_JAQY660AUX1 IN NUMBER,
                                                  P_C_JAQY660AUX2 IN VARCHAR2,
                                                  P_C_HORA        IN VARCHAR2,
                                                  P_C_CODE       OUT VARCHAR2,
                                                  P_C_ERROR      OUT VARCHAR2
                                                 ) IS
PRAGMA autonomous_transaction;

begin
  -- Call the procedure
  pq_ah_reg_alertaafiliacion.sp_ah_registra_afiliacion(p_c_jaqy660tip => p_c_jaqy660tip,
                                                       p_n_jaqy660pgo => p_n_jaqy660pgo,
                                                       p_n_jaqy660suc => p_n_jaqy660suc,
                                                       p_n_jaqy660mod => p_n_jaqy660mod,
                                                       p_n_jaqy660mda => p_n_jaqy660mda,
                                                       p_n_jaqy660cta => p_n_jaqy660cta,
                                                       p_n_jaqy660pap => p_n_jaqy660pap,
                                                       p_n_jaqy660ope => p_n_jaqy660ope,
                                                       p_n_jaqy660sub => p_n_jaqy660sub,
                                                       p_n_jaqy660top => p_n_jaqy660top,
                                                       p_d_jaqy660fch => p_d_jaqy660fch,
                                                       p_c_jaqy660usu => p_c_jaqy660usu,
                                                       p_c_jaqy660tpr => p_c_jaqy660tpr,
                                                       p_c_jaqy660tme => p_c_jaqy660tme,
                                                       p_c_jaqy660afi => p_c_jaqy660afi,
                                                       p_c_jaqy660fde => p_c_jaqy660fde,
                                                       p_c_jaqy660ude => p_c_jaqy660ude,
                                                       p_c_jaqy660aux1 =>p_c_jaqy660aux1,
                                                       p_c_jaqy660aux2 =>p_c_jaqy660aux2,
                                                       p_c_hora => p_c_hora,
                                                       p_c_code => p_c_code,
                                                       p_c_error => p_c_error
                                                       );  
end SP_AH_AFILIA_ICHANNEL;
/

