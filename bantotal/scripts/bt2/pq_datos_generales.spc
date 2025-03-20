CREATE OR REPLACE PACKAGE pq_datos_Generales IS
  function fn_moneda(P_C_CODMON in varchar2) return number;
  FUNCTION fn_sucursal(p_c_codage IN VARCHAR2) RETURN number;                      

END pq_datos_Generales;
/

