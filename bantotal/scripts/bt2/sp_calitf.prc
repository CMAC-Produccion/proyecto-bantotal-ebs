CREATE OR REPLACE Procedure sp_CalITF(P_N_MONTO  IN NUMBER,
                                      p_ValITF   OUT NUMBER)
is
  ln_poritf number(14,8):= 0;
  ln_fijo1  number(1)   := 5;
  ln_fijo2  number(5,2) := 0.05;
  ln_valor1 number(10,2):= 0;
  ln_valor2 number(10,2):= 0;
  ln_itf    number(10,2):= 0;
  begin
  begin

      select coefic into ln_poritf
         from fst144
        where coecod = 7
          and coefdes =
              (select max(coefdes) from fst144 where coecod = 7);
  end;
  ln_valor1 := trunc(P_N_MONTO*ln_poritf,2);
  ln_valor2 := trunc(P_N_MONTO*ln_poritf,1);

  If (ln_valor1 - ln_valor2)*100 >= ln_fijo1 then
     ln_itf := ln_valor1 + (ln_fijo2 - (ln_valor1 - ln_valor2));
  Else
     ln_itf := ln_valor1 - (ln_valor1 - ln_valor2);
  end If;
  p_ValITF := ln_itf;

  end sp_CalITF;
/

