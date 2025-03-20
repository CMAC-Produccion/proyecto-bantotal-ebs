CREATE OR REPLACE FUNCTION FN_AH_AHTBANC (P_C_CODSBS IN varchar2
                                          ) RETURN VARCHAR2 is
  v_desefi varchar2(200);
begin
       select C_DESEFI INTO v_desefi from AHTBANC WHERE C_CODEFI=P_C_CODSBS AND C_CODEST='S';
       return(v_desefi);
exception
  when OTHERS then
    RETURN ('');
end FN_AH_AHTBANC;
/

