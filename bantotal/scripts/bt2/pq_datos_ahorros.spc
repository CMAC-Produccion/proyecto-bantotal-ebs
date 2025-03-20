CREATE OR REPLACE PACKAGE pq_datos_Ahorros IS
  procedure sp_modulo_ope(p_c_numcta IN VARCHAR2, ln_modulo out number, ln_totope out number);
  function fn_codcli_tit_principal(P_C_NUMCTA in varchar2) return varchar2;
  function fn_descri(P_C_CODPER in varchar2) return varchar2 ;
  function fn_nomcli_tit_principal(P_C_NUMCTA in varchar2) return varchar2;                                     
  
END pq_datos_Ahorros;
/

