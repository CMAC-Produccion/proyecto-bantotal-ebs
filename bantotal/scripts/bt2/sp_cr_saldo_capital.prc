create or replace procedure SP_CR_SALDO_CAPITAL(P_N_CUENTA IN number,
                                             P_N_OPERACION IN number,
                                             P_D_FECHA IN date,
                                             P_N_PGCOD in number,
                                             P_N_AOMOD in number,
                                             P_N_AOSUC in number,
                                             P_N_AOMDA in number,
                                             P_N_AOPAP in number,
                                             P_N_AOSBOP in number,
                                             P_N_AOTOPE in number,
                                             P_F_RESULTADO out number)as
ln_salcap number(18,2):=0;   
ln_cappag number(18,2):=0;                    
begin 
  begin
  select sum(pp1cap)
         into ln_salcap 
         from fsd602 
  where ppcta=P_N_CUENTA 
  and pgcod=P_N_PGCOD
  and ppmod=P_N_AOMOD
  and ppsuc=P_N_AOSUC
  and ppmda=P_N_AOMDA
  and pppap=P_N_AOPAP
  and ppcta=P_N_CUENTA
  and ppoper=P_N_OPERACION
  and ppsbop=P_N_AOSBOP
  and pptope=P_N_AOTOPE
  and Pp1fech<=P_D_FECHA;
  
  exception when others then
  ln_salcap:=0;
  end;
  begin
  select aoimp into ln_cappag from fsd010 
                where pgcod=P_N_PGCOD 
                and aomod=P_N_AOMOD 
                and aosuc=P_N_AOSUC 
                and aomda=P_N_AOMDA 
                and aopap=P_N_AOPAP 
                and aosbop=P_N_AOSBOP
                and aotope=P_N_AOTOPE
                and aocta=P_N_CUENTA 
                and aooper=P_N_OPERACION;
P_F_RESULTADO := (ln_cappag - ln_salcap);
exception  when others then
   P_F_RESULTADO:=0;
  end;
end SP_CR_SALDO_CAPITAL;
/

