create or replace package PQ_DATOS is

  -- Author  : MARAUJO
  -- Created : 02/03/2011 04:23:53 p.m.
  -- Purpose : OBTIENE DATOS GENERALES

  function FN_AH_TASEFE(P_C_CODPPA in varchar2, P_N_TASNOM in number)
    return number;
  function FN_AH_PROVISION(P_C_NUMCTA IN VARCHAR2, P_D_FECPRO IN DATE)
    return number;
  function FN_CL_NOMPER(p_c_codper in varchar2) return varchar2;

  function FN_AH_PLF_CALCINT(p_n_numdia in number,
                             p_n_tasint in number,
                             p_n_mtocap in number) return number;

  function FN_AH_ES_GARANTIA(P_C_NUMCTA IN varchar2) return char;

  function FN_AH_CORMOV_ACTUAL(p_c_numcta IN VARCHAR2) return number;

  function FN_AH_TASA_ORIGINAL(p_c_numcta IN VARCHAR2) return number;

end PQ_DATOS;
/

