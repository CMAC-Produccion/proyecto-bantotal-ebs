CREATE OR REPLACE PACKAGE pq_datos_Creditos IS
  procedure sp_modulo_ope(p_c_numcta IN VARCHAR2, ln_modulo out number, ln_totope out number, lc_rubpro out varchar2);
  function fn_codcli_tit_principal(P_C_NUMCTA in varchar2) return varchar2;
  function fn_descri(P_C_CODPER in varchar2) return varchar2 ;
  function fn_nomcli_tit_principal(P_C_NUMCTA in varchar2) return varchar2; 
  procedure sp_cr_datos_linea (p_c_codper in varchar2, 
                             p_c_numcre in varchar2, 
                             p_c_tiplin out varchar2,
                             p_n_monlin out number,
                             p_n_saldis out number );
   function fn_int_diferido(P_C_NUMCTA in varchar2/*, p_n_tipcam in number*/) return number;  
   function fn_int_diferido_jud(P_C_NUMCTA in varchar2/*, p_n_tipcam in number*/) return number;
   function fn_num_cafi(P_C_NUMCRE in varchar2) return varchar2;
    function fn_rep_sbs(P_C_NUMCRE in varchar2) return varchar2;
END pq_datos_Creditos;
/

