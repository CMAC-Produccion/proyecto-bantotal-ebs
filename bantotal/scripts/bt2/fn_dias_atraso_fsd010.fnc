create or replace function fn_dias_atraso_fsd010 (p_pgcod  in fsd010.pgcod%type,
                               p_aomod  in fsd010.aomod%type,
                               p_aosuc  in fsd010.aosuc%type,
                               p_aomda  in fsd010.aomda%type,
                               p_aopap  in fsd010.aopap%type,
                               p_aocta  in fsd010.aocta%type,
                               p_aooper in fsd010.aooper%type,
                               p_aosbop in fsd010.aosbop%type,
                               p_aotope in fsd010.aotope%type
                              ) return number
  is
    ln_diaatr number;
  begin
    select distinct i.RI100PLAZO
      into ln_diaatr
      from FRI100 i
       where  ri100suc = p_aosuc
         and ri100mda  =p_aomda
         and ri100pap  =p_aopap
         and  ri100cta = p_aocta
         and ri100ope  =p_aooper
         and ri100sbop =p_aosbop
         and  ri100tope=p_aotope
         and ri100mod  =p_aomod;

     return ln_diaatr;
  exception when others then
        return 0;
  end fn_dias_atraso_fsd010;
/

