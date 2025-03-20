create or replace function fn_cl_celular(P_N_CODPAI IN NUMBER,
                                         P_N_TIPDOC IN NUMBER,
                                         P_C_NUMDOC IN VARCHAR2,           
                                         P_N_NUMCEL IN NUMBER
                                        ) return  varchar2 is
 cursor c_tele is
 Select distinct  trim(a.dotelfp) tel
   from fsr005 a 
  where a.pepais = P_N_CODPAI
    and a.petdoc = P_N_TIPDOC
    and a.pendoc = rpad(P_C_NUMDOC,12,' ')
    and pq_ah_enviodigital.fn_ah_valida_celular(trim(a.dotelfp),1) = 'S';
    
 p_c_cadena varchar2(200);
 ln_cont number(10):=0;
begin
  ln_cont := 0;
  for i in c_tele loop
    ln_cont := ln_cont  + 1;
    if ln_cont < P_N_NUMCEL then
       p_c_cadena := p_c_cadena||i.tel||'-';
    Else
      if ln_cont = P_N_NUMCEL then
         p_c_cadena := p_c_cadena||i.tel;
      End if;
    End if; 
  End loop;
  if ln_cont < P_N_NUMCEL then
     p_c_cadena := substr(p_c_cadena,1,length(p_c_cadena)-1);
  end if;
  return p_c_cadena;
exception
when others then
  p_c_cadena := null;
  return p_c_cadena;
end fn_cl_celular;
/

