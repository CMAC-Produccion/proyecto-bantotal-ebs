CREATE OR REPLACE PACKAGE pq_saldos_iniciales IS
  --                                          : lllosa 2012.04.02 3:00pm
  --                                          : lllosa 2012.04.09 4:40pm
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_ah_codcta(P_C_CODPRO IN CHAR,
                         P_C_TIPMTO IN CHAR,
                         P_C_INDRTJ IN CHAR,
                         P_C_INDGAR IN CHAR,
                         P_C_TIPPER IN CHAR,
                         P_C_CODSBS IN CHAR,
                         p_c_indtra in char,
                         P_C_CODCTA OUT varchar2,
                         P_N_CODERR OUT NUMBER);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                           
  FUNCTION fn_tip_plazo(p_c_numcre IN VARCHAR2) RETURN VARCHAR2 ;  
  procedure sp_bien_adjudicado(p_d_fecpro in date, p_n_tipcam in number,  p_c_msgerr out varchar2);
  procedure sp_joyas_adjudicadas ( p_n_tipcam in number,  p_c_msgerr out varchar2);
  procedure sp_refinan_prov (p_d_fecpro in date, p_n_tipcam in number,  pc_coderr out varchar2, p_c_msgerr out varchar2) ;
  procedure sp_judicial_prov (p_d_fecpro in date, p_n_tipcam in number,  pc_coderr out varchar2, p_c_msgerr out varchar2) ;
  procedure sp_ins_saldos_72 /* (p_n_sucur in number)*/;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_tip_garantia(P_C_NUMCRE in varchar2) return varchar2;   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                     
  procedure sp_saldos_iniciales_BNJ(p_d_fecpro in date,/* p_n_sucur in number,*/p_c_coderr out varchar2, p_c_msgerr out varchar2);
END pq_saldos_iniciales;
/

