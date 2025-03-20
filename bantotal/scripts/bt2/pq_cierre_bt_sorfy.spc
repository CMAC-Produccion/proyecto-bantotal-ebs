CREATE OR REPLACE PACKAGE pq_cierre_bt_sorfy IS
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_saldos_ahorros_BNJ(p_d_fecpro IN date, p_c_codage in varchar2, p_c_coderr out varchar2, p_c_msgerr out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_ah_codcta(P_C_CODPRO IN CHAR,
                         P_C_TIPMTO IN CHAR,
                         P_C_INDRTJ IN CHAR,
                         P_C_INDGAR IN CHAR,
                         P_C_TIPPER IN CHAR,
                         P_C_CODSBS IN CHAR,
                         P_C_CODCTA OUT varchar2,
                         P_N_CODERR OUT NUMBER);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_cierre_cred(P_C_NUMCRE in varchar2,
                              P_D_FECPRO in date,
                              P_C_CODPAC IN VARCHAR2,
                              P_C_CODAGE IN VARCHAR2,
                              P_C_CODCMA IN VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_calendario_gen(P_C_NUMCRE in varchar2,
                                     P_D_FECGEN in date,
                                     p_c_coderr out varchar2,
                                     p_c_msgerr out varchar2);
   procedure sp_cr_genera_calendario_tmp(P_C_NUMCRE in varchar2,
                                        P_D_FECGEN in date,
                                        P_C_TIPGEN in varchar2,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2
                                       ) ;
   procedure sp_cr_carga_calendario_no_gen(P_C_NUMCRE in varchar2,
                                          P_N_NUMCAL in number,
                                          p_c_coderr out varchar2,
                                          p_c_msgerr out varchar2
                                         );
   function fn_cr_fecope(P_C_NUMCRE in varchar2,
                        P_C_NUMOPE in varchar2
                       ) return date;
   function fn_cr_new_numope(P_C_NUMCRE in varchar2
                           ) return varchar2;
   function fn_cr_max_numope(P_C_NUMCRE in varchar2
                           ) return varchar2;
   function fn_cr_corr_ope(P_C_NUMCRE in varchar2,
                          P_C_NUMOPE in varchar2
                         ) return number;
  function fn_cr_codope(P_C_NUMCRE in varchar2,
                        P_C_NUMOPE in varchar2
                       ) return varchar2 ;                                                                                                                                                                                                                       
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                     
  procedure sp_cr_insertar(P_C_NUMCRE in varchar2,
                           P_C_NUMOPE in varchar2,
                           P_C_CODOPE in varchar2,
                           P_N_CORCON in number,
                           P_D_VENCUO in date,
                           P_C_ESTCUO in varchar2,
                           P_N_MONCUO in number,
                           P_N_CAPCUO in number,
                           P_N_CAPPAG in number,
                           P_N_SALCAP in number,
                           P_N_INTCUO in number,
                           P_N_INTPAG in number,
                           P_N_SALINT in number,
                           P_N_MORCUO in number,
                           P_N_MORPAG in number,
                           P_N_SALMOR in number,
                           P_N_GASCUO in number,
                           P_N_GASPAG in number,
                           P_N_SALGAS in number,
                           P_N_IDICUO in number,
                           P_N_IDIPAG in number,
                           P_N_SALIDI in number,
                           P_N_GLGCUO in number,
                           P_N_GLGPAG in number,
                           P_N_SALGLG in number,
                           P_N_HLGCUO in number,
                           P_N_HLGPAG in number,
                           P_N_SALHLG in number,
                           P_N_SALCUO in number,
                           P_N_SALCRE in number,
                           P_N_DIAATR in number,
                           p_b_exito out boolean);                                      
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                           
  FUNCTION fn_tip_plazo(p_c_numcre IN VARCHAR2) RETURN VARCHAR2 ;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_tip_garantia(P_C_NUMCRE in varchar2) return varchar2;   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_batch_cred(P_D_FECPRO in date, p_c_codage in varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --procedure sp_saldos_creditos_BNJ(p_d_fecpro IN date, p_c_codage in varchar2, p_c_coderr out varchar2, p_c_msgerr out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                     
  PROCEDURE SP_CR_GEN_BASE( P_D_FECPRO in date,
                          --P_C_CODPAC  in varchar2,
                          P_C_CODAGE  in varchar2,
                          P_C_CODCMA  in varchar2
                          ) ;
END pq_cierre_bt_sorfy;
/

