create or replace procedure SP_CR_MTOPRIMA_MULTI(pn_instancia in number,
                                                 pn_montoprim out number) is
                                                 
pn_mda number;
monto number(17,2):= 0;
prima number(17,2):= 0;
pd_fecha date;
pn_tipcam number(17,6);
fecha date;
begin
  Begin
    select pgfape 
      into fecha
     from fst017 where pgcod =1 ;
  exception 
    when no_Data_found then
      fecha := null;
  end;
  begin
    select xwfmoneda ,xwfmonto1 
      into pn_mda, monto      
      from xwf700
     where xwfprcins  = pn_instancia
       and xwfcar3 = '1';                                     
  exception
   when no_data_found then
     monto:= 0;
   when others then  
     monto:= 0;
  end;
  
   
      
    if pn_mda = 0 then
      prima := (monto * 0.028)/100;
    else
      pd_fecha  := last_day(add_months(fecha,-1));
      pn_tipcam := fn_tipo_cambio_fijo(pd_fecha);
      monto := monto/pn_tipcam;
      prima := (monto * 0.028)/100;
    end if;
  
       
    if prima < 5.1 and monto <= 20000 then
      prima := 5.1;
    end if;
    if prima < 6.1 and (monto >= 20001 and monto <=30000) then
      prima := 6.1;
    end if;
    if prima < 8.1 and (monto >= 30001  and monto <=600000) then
      prima := 8.1;
    end if;
      
   pn_montoprim := prima;  
  
end SP_CR_MTOPRIMA_MULTI;
/

