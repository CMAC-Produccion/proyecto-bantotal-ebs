create or replace procedure sp_genera_relacion(P_C_CODPRG IN VARCHAR2,
                                               P_N_CODSUC IN NUMBER,            
                                               P_D_FECPRO IN DATE,
                                               P_N_COCOD1 IN NUMBER,            
                                               P_N_CCORR1 IN NUMBER,            
                                               P_N_CCORR2 IN NUMBER, 
                                               p_n_codmod out number,          
                                               p_n_codtrx out number,
                                               p_n_codrel out number
                                               ) is
  cursor c_transacciones is
    select * 
      from fst198                                               
    where Tp1cod   = 1
      and Tp1cod1  = P_N_COCOD1
      and Tp1corr1 = P_N_CCORR1
      and Tp1corr2 = P_N_CCORR2;    
    
  ln_itrel  number(4) := 0;
  Itmod     number(3):= 0;
  Ittran    number(3):= 0;
  lc_codprg char(10);
begin            
     lc_codprg := rpad(P_C_CODPRG,10,' ');       
     for i in c_transacciones loop
            
            Itmod  := i.Tp1nro2;
            Ittran := i.Tp1nro3;
            
              begin
               select jaqz155rel
                 into ln_itrel
                 from jaqz155
                where jaqz155prg = lc_codprg
                  and jaqz155pgc = 1
                  and jaqz155suc = P_N_CODSUC
                  and jaqz155mod = Itmod
                  and jaqz155trx = Ittran
                  and jaqz155fec = P_D_FECPRO
                  for update of jaqz155rel;                  
              exception
              when no_data_found then
                   begin
                   insert into jaqz155(jaqz155prg,
                                       jaqz155pgc,
                                       jaqz155suc,
                                       jaqz155mod,
                                       jaqz155trx,
                                       jaqz155fec,
                                       jaqz155rel
                                       )                             
                                values(lc_codprg,
                                       1,
                                       P_N_CODSUC,
                                       Itmod,
                                       Ittran,
                                       P_D_FECPRO,
                                       0
                                      );
                    end;   
                           
                    begin
                       select jaqz155rel
                         into ln_itrel
                         from jaqz155
                         where jaqz155prg = lc_codprg
                           and jaqz155pgc = 1
                           and jaqz155suc = P_N_CODSUC
                           and jaqz155mod = Itmod
                           and jaqz155trx = Ittran
                           and jaqz155fec = P_D_FECPRO
                           for update of jaqz155rel;            
                    end;        
              end;


            if ln_itrel < 9999 then
                exit;
            End If;
      End loop;  
      -- Actualización.
      ln_itrel := ln_itrel + 1;
     update jaqz155 
        set jaqz155rel = ln_itrel 
      where jaqz155prg = lc_codprg
        and jaqz155pgc = 1
        and jaqz155suc = P_N_CODSUC
        and jaqz155mod = Itmod
        and jaqz155trx = Ittran
        and jaqz155fec = P_D_FECPRO;

      -- Grabación.
      commit;    
  p_n_codrel := ln_itrel;   
  p_n_codmod := Itmod;
  p_n_codtrx := Ittran;
  
end sp_genera_relacion;
/

