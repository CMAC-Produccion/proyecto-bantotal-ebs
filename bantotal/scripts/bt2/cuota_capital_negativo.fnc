CREATE OR REPLACE FUNCTION cuota_capital_negativo (P_N_PGCOD  NUMBER, P_N_AOMOD  NUMBER,
P_N_AOSUC  NUMBER, P_N_AOMDA  NUMBER,
P_N_AOPAP  NUMBER, P_N_AOCTA  NUMBER,
P_N_AOOPER  NUMBER, P_N_AOSBOP  NUMBER,
P_N_AOTOPE  NUMBER)
RETURN NUMBER
is
 lc_rpta number;
 cursor CAL_PAGOS1 is
  select ppfpag, pptipo, pp1nump , pp1fech, pp1cap, pp1int, pp1stat from fsd602 a where
  a.pgcod = P_N_PGCOD and a.ppmod = P_N_AOMOD and a.ppsuc = P_N_AOSUC and
  a.ppmda = P_N_AOMDA and a.pppap = P_N_AOPAP and a.ppcta = P_N_AOCTA and
  a.ppoper = P_N_AOOPER and a.ppsbop = P_N_AOSBOP and a.pptope = P_N_AOTOPE;

 cursor CAL_PAGOS2 is
  select PGCOD, PPMOD, PPSUC, PPMDA, PPPAP, PPCTA,  PPOPER,  PPSBOP,  PPTOPE,  PPFPAG,sum(PP1CAP) CAPTOT
  from fsd602 a where --fsd602@produ a where
  a.pgcod = P_N_PGCOD and a.ppmod = P_N_AOMOD and a.ppsuc = P_N_AOSUC and
  a.ppmda = P_N_AOMDA and a.pppap = P_N_AOPAP and a.ppcta = P_N_AOCTA and
  a.ppoper = P_N_AOOPER and a.ppsbop = P_N_AOSBOP and a.pptope = P_N_AOTOPE
  group by PGCOD, PPMOD, PPSUC, PPMDA, PPPAP, PPCTA,  PPOPER,  PPSBOP,  PPTOPE,  PPFPAG;

begin

  for CP in CAL_PAGOS2 loop
    if CP.CAPTOT < 0 then
      lc_rpta := 1;
      exit;
    end if;
  end loop;

RETURN nvl(lc_rpta,0);
   EXCEPTION
      WHEN OTHERS THEN
        lc_rpta := 0;
     RETURN lc_rpta;
end;
/

