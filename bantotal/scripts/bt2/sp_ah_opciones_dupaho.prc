create or replace procedure sp_ah_opciones_dupaho(P_N_PAIS   IN NUMBER,
                                                  P_N_TIPO   IN NUMBER,
                                                  P_C_NUMERO IN VARCHAR2,
                                                  P_N_CODCAM  IN NUMBER,
                                                  p_n_numsor out number
                                                  )  is
begin
  p_n_numsor :=0;                                                  
    begin
      -- Call the function
      p_n_numsor := fn_ah_opciones_dupaho(p_n_pais   => P_N_PAIS,
                                          p_n_tipo   => P_N_TIPO,
                                          p_c_numero => P_C_NUMERO,
                                          p_n_codcam => P_N_CODCAM
                                          );
    end;  
exception
when others then    
  p_n_numsor := 0;  
end sp_ah_opciones_dupaho;
/

