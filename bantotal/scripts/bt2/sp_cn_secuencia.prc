create or replace procedure SP_CN_SECUENCIA(P_C_NOMSEQ IN varchar2,
                                         P_N_CORREL OUT number) is
  lc_select varchar2(500);
begin
  
 lc_select := 'select ' || P_C_NOMSEQ || '.nextval from dual';
 execute immediate lc_select into P_N_CORREL;  

end SP_CN_SECUENCIA;
/

