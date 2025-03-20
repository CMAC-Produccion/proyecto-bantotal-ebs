CREATE OR REPLACE TRIGGER TG_INS_FSD012
  after insert on FSD012
  for each row

DECLARE
  pn_pgcod   fst017.pgcod%type;
  pn_hcmod   fst003.modulo%type;
  pn_htran   fsd015.ittran%type;
  ln_flag    number := 0;
  ln_inditr  number := 0;
  Txcodo     number := 70;
  ln_pgcod   fsx016.pgcod%type;
  ln_hcmod   fsx016.hcmod%type;
  ln_hsucor  fsx016.hsucor%type;
  ln_htran   fsx016.htran%type;
  ln_hnrel   fsx016.hnrel%type;
  ln_hfcon   fsx016.hfcon%type;
  ln_hcord   fsx016.hcord%type;
  ln_hcsubo  fsx016.hcsubo%type;  
  ln_txoren  fsx016.txoren%type; 
  lc_usuario CHAR(10);
  lc_cierre  CHAR(1);
  ln_tasa    FSD010.AOTASA%TYPE;
  ln_flagX   number := 0;  
  
BEGIN 
  select OPGVAL into  lc_cierre from fst200 where opgcod = 99999;
  lc_usuario := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);     
   begin
    select x.aotasa into ln_tasa 
      from fsd010 x 
     where x.pgcod  = :new.pgcod
       and x.aomod  = :new.aomod
       and x.aosuc  = :new.aosuc
       and x.aomda  = :new.aomda
       and x.aopap  = :new.aopap
       and x.aocta  = :new.aocta
       and x.aooper = :new.aooper
       and x.aosbop = :new.aosbop
       and x.aotope = :new.aotope;       
  exception
  when others then   
    ln_tasa := 0;
  end;
      begin
       select 1,
              a.tp1imp1,
              a.tp1nro1,
              a.tp1nro2,
              a.tp1nro3               
         into ln_flag, 
              ln_inditr,
              pn_pgcod,
              pn_hcmod,
              pn_htran                                   
         from fst198 a 
        where a.tp1cod   = 1 
          and a.tp1cod1  = 10825 
          and a.tp1corr1 = 23 
          and a.tp1corr2 = 1;
      exception 
      when others then    
        ln_flag   := 0;
        ln_inditr := 0;
        pn_pgcod  := 0;
        pn_hcmod  := 0;
        pn_htran  := 0;                                           
      end;
            
      begin
        select x.pgcod,
               x.hcmod,
               x.hsucor,
               x.htran,
               x.hnrel,
               x.hfcon,
               x.hcord,
               x.hcsubo,
               x.txoren 
        into   ln_pgcod,
               ln_hcmod,
               ln_hsucor,
               ln_htran,
               ln_hnrel,
               ln_hfcon,
               ln_hcord,
               ln_hcsubo,
               ln_txoren 
          from (
                select a.pgcod,
                       a.hcmod,
                       a.hsucor,
                       a.htran,
                       a.hnrel,
                       a.hfcon,
                       a.hcord,
                       a.hcsubo,
                       a.txcod,
                       a.txoren 
                  from fsx016 a
                 where PgCod  = pn_pgcod
                   and Hcmod  = pn_hcmod 
                   and Htran  = pn_htran            
                   and Hfcon  = :new.d012fc          
                   and txtsuc = :new.aosuc
                   and txtmda = :new.aomda
                   and txtpap = :new.aopap
                   and txtcta = :new.aocta
                   and txtope = :new.aooper
                   and txtsbo = :new.aosbop
                   and txttop = :new.aotope
                   and txtmod = :new.aomod                                                 
                   and Txcod  = Txcodo
               order by a.hnrel desc
               ) x
             where rownum = 1;
             
             if ln_txoren in (1,2,3) then
                ln_flag := 1;
             else
                ln_flag := 0;
             end if;
             
        exception 
        when no_data_found then                      
          ln_flag := 0;
        when others then            
          ln_flag := 9;
        end;
        
      begin
       select 1                  
         into ln_flagx                                           
         from fst198 a 
        where a.tp1cod   = 1 
          and a.tp1cod1  = 10825 
          and a.tp1corr1 = 106 
          and a.tp1corr2 = 1
          and a.tp1nro1 = :new.d012mo
          and a.tp1nro2 = :new.d012tr;
      exception 
      when others then    
        ln_flagx   := 0;                                       
      end;        
        
      If ln_flag = 1 and ln_flagx = 0 and (:new.evtasa <> ln_tasa) and lc_cierre = 'N' then
         --invocamos proceso de envio de mail
          begin
             -- Call the procedure
            sp_ah_mail_asignacion_tasa_pos(p_n_pgcod   => ln_pgcod,
                                           p_n_hcmod   => ln_hcmod,
                                           p_n_hsucor  => ln_hsucor,
                                           p_n_htran   => ln_htran,
                                           p_n_hnrel   => ln_hnrel,
                                           p_d_hfcon   => ln_hfcon,
                                           p_n_txoren  => ln_txoren,
                                           p_n_txtsuc  => :new.aosuc,
                                           p_n_txtmda  => :new.aomda,
                                           p_n_txtpap  => :new.aopap,
                                           p_n_txtcta  => :new.aocta,
                                           p_n_txtope  => :new.aooper,
                                           p_n_txtsbo  => :new.aosbop,
                                           p_n_txttop  => :new.aotope,
                                           p_n_txtmod  => :new.aomod,
                                           p_n_inditr  => ln_inditr,
                                           p_n_tasa    => :new.evtasa,
                                           p_n_tast    => :old.evtasa,
                                           p_d_fecval  => :new.evfval,
                                           p_c_usuario => lc_usuario||'INS-'||ln_flag
                                           );
          end;
      elsif :new.aomod = 22 and ln_flag = 0 and ln_flagx = 0 and :new.evtipo = 3  and (:new.evtasa <> ln_tasa) and lc_cierre = 'N' then       
          begin        
             -- Call the procedure
            sp_ah_mail_asignacion_tasa_pos(p_n_pgcod  => 1,
                                           p_n_hcmod  => 22,
                                           p_n_hsucor => 11,
                                           p_n_htran  => 0,
                                           p_n_hnrel  => 0,
                                           p_d_hfcon  => trunc(sysdate),
                                           p_n_txoren => 0,--ln_txoren,
                                           p_n_txtsuc => :new.aosuc,
                                           p_n_txtmda => :new.aomda,
                                           p_n_txtpap => :new.aopap,
                                           p_n_txtcta => :new.aocta,
                                           p_n_txtope => :new.aooper,
                                           p_n_txtsbo => :new.aosbop,
                                           p_n_txttop => :new.aotope,
                                           p_n_txtmod => :new.aomod,
                                           p_n_inditr => ln_inditr,
                                           p_n_tasa   => :new.evtasa,
                                           p_n_tast   => :old.evtasa,
                                           p_d_fecval => :new.evfval,
                                           p_c_usuario => lc_usuario||'INS-'||ln_flag
                                           );   
          end;                                                    
      end if;            

            
Exception
When others then
    null;
END TG_INS_FSD012;
/

