CREATE OR REPLACE TRIGGER TG_SNG065_AU_01
AFTER UPDATE OF sng065res ON SNG065
FOR EACH ROW
DECLARE
    P_N_EST_ANT  sng065.sng065res%type;
    p_sng065res  sng065.sng065res%type; --estado 
       
    p_sng062aut  sng065.sng062aut%type; --autorizacion
    p_sng065ord  sng065.sng065ord%type; --ordinal
    p_sng065emp  sng065.sng065emp%type; --empresa
    p_sng065car  sng065.sng065car%type; --car
    p_sng046mto  sng065.sng046mto%type; --monto

    p_sng091num  sng091.sng091num%type; --politica
    P_sng001inst sng091.sng001inst%type; --instancia 
    
    my_errm     VARCHAR2(32000);
    P_N_CODERR  NUMBER := 0;
    P_C_MSGERR  varchar2(500) := '';

BEGIN
  P_N_EST_ANT := :old.sng065res; --estado anterior
  p_sng065res := :new.sng065res; --estado nuevo
      
  p_sng062aut := :new.sng062aut; --autorizacion
  p_sng065ord := :new.sng065ord; --ordinal
  p_sng065emp := :new.sng065emp; --empresa
  p_sng065car := :new.sng065car; --car
  p_sng046mto := :new.sng046mto; --monto
  
  p_sng091num := 0; --politica *****
  P_sng001inst := 0; --instancia *****
  
  P_N_CODERR := 0; --codigo de error

  
  begin         
      select s.sng091num, s.sng001inst
            into p_sng091num, P_sng001inst
      from sng091 s --politica e instancia
      inner join sng060 d on s.sng090pqt = d.sng060pqt 
      where s.sng091aut = p_sng062aut
      group by s.sng091num, s.sng001inst;

    exception
      when others then
        P_N_CODERR := 1;
        my_errm := SQLERRM;
  end;

  begin
    if (p_sng091num = '') or (p_sng091num = 0) or (p_sng091num IS NULL)  then     
        P_N_CODERR := 3;
    end if; 
    exception
      when others then
        P_N_CODERR := 3;
  end;
  
  /*
  if P_N_CODERR = 0 then 
    begin 
      select TP1NRO1 
        into p_sng091num_temp 
      from fst198 where tp1cod1=11003 and tp1corr1=100 and tp1nro1 = p_sng091num;
    exception
      when others then
        P_N_CODERR := 2;
    end;
  end if;*/

  if P_N_CODERR = 0 then 
    
    if (P_N_EST_ANT <> p_sng065res) and (p_sng065res = 'A' or p_sng065res = 'R') then     
      begin
            
        SP_CR_CORREO_POLITICAS_A_R (P_sng001inst, p_sng091num, p_sng065res, P_N_CODERR, P_C_MSGERR);

      exception
        when others then
          P_N_CODERR := 4;
          my_errm := SQLERRM;
      end;
      
    else
      P_N_CODERR := 3;
    end if; 
  
  end if;
  

END;
/

