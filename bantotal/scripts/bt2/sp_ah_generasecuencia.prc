create or replace procedure SP_AH_GENERASECUENCIA(V_ANO   IN  NUMBER,
                                                  CODIGO  out NUMBER) is

ln_itrel  number(10);
begin
  begin
     select jaqy692cod
       into ln_itrel
       from jaqy692
      where jaqy692year = v_ano
      for update of jaqy692cod;                  
      
  exception
     when no_data_found then
           begin
           insert into jaqy692(jaqy692year,
                               jaqy692cod
                               )                             
                        values(v_ano,
                               1
                              );
           exception
             when dup_val_on_index then
               null;
           end;                     
           ln_itrel := 1;                    
  end;
  -- Actualización.
      codigo := ln_itrel;
      ln_itrel := ln_itrel + 1;
     update jaqy692 
        set jaqy692cod = ln_itrel 
      where jaqy692year = v_ano;
   -- Grabación.
      commit;    
    
end SP_AH_GENERASECUENCIA;
/

