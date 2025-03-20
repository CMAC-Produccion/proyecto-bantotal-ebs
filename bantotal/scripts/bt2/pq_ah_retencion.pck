create or replace package PQ_AH_RETENCION is

  -- Author  : YLOZADA
  -- Created : 1/10/2018 3:05:41 p. m.
  -- Purpose : 


  -- Public function and procedure declarations
  procedure sp_ah_gencod(P_N_CODAGE IN NUMBER,
                         P_N_NUMANO IN NUMBER,
                         p_n_numcor out number
                        );

end PQ_AH_RETENCION;
/

create or replace package body PQ_AH_RETENCION is

  procedure sp_ah_gencod(P_N_CODAGE IN NUMBER,
                         P_N_NUMANO IN NUMBER,
                         p_n_numcor out number
                        ) is
  ln_codcor number(8):= 0;                        
  begin
              begin
               select a.jaqz182cor
                 into ln_codcor
                 from jaqz182 a
                where a.jaqz182suc = P_N_CODAGE
                  and a.jaqz182ano = P_N_NUMANO
                  for update of a.jaqz182cor;                  
              exception
              when no_data_found then
                   begin
                   insert into jaqz182(jaqz182cor,
                                       jaqz182suc,
                                       jaqz182ano
                                       )                             
                                values(0,
                                       P_N_CODAGE,
                                       P_N_NUMANO
                                      );
                    end;   
                           
                    begin
                     select a.jaqz182cor
                       into ln_codcor
                       from jaqz182 a
                      where a.jaqz182suc = P_N_CODAGE
                        and a.jaqz182ano = P_N_NUMANO
                        for update of a.jaqz182cor;           
                    end;        
              end;   
      -- Actualización.
     ln_codcor := ln_codcor + 1;
     update jaqz182 a 
        set a.jaqz182cor = ln_codcor 
      where a.jaqz182suc = P_N_CODAGE
        and a.jaqz182ano = P_N_NUMANO;
      -- Grabación.
      commit;       
  p_n_numcor := ln_codcor;                 
  end sp_ah_gencod;                        
end PQ_AH_RETENCION;
/

