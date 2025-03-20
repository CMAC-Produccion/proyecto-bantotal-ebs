create or replace procedure sp_ah_gen_cor_arch(P_C_TIPARC IN VARCHAR2,
                                               P_C_NOMPRG IN VARCHAR2,
                                               p_c_nomarc out varchar2
                                               ) is

  ln_itrel number(10) := 0;                               
  begin
              begin
               select a.aqpa132cor
                 into ln_itrel
                 from aqpa132 a
                where a.aqpa132pan = RPAD(P_C_NOMPRG,10,' ')
                  for update of a.aqpa132cor;                  
              exception
              when no_data_found then
                   begin
                   insert into aqpa132(aqpa132pan,
                                       aqpa132cor                                     
                                       )                             
                                values(RPAD(P_C_NOMPRG,10,' '),
                                       0                                      
                                       );
                    end;   
                           
                    begin
                       select a.aqpa132cor
                         into ln_itrel
                         from aqpa132 a
                        where a.aqpa132pan = RPAD(P_C_NOMPRG,10,' ')
                          for update of a.aqpa132cor;           
                    end;        
              end;    
      -- Actualización.
      ln_itrel := ln_itrel + 1;
     update aqpa132 a 
        set a.aqpa132cor = ln_itrel 
      where a.aqpa132pan = RPAD(P_C_NOMPRG,10,' ');
      -- Grabación.
      commit;      
      p_c_nomarc := P_C_TIPARC||LPAD(P_C_NOMPRG,10,'0')||LPAD(ln_itrel,10,'0')||'.pdf';            
                                                                               
end sp_ah_gen_cor_arch;
/

