CREATE OR REPLACE Procedure Sp_Cr_FormulaGastos(pn_saldo   in number,
                                                pn_taza    in number,
                                                pn_pzo     in number,
                                                pn_formula out number) is

  pn_denomi number(17, 2);
  --pn_tea number(17,2);
  --pn_div number(10,6);
  --pn_pot number(17,2);
begin

  --pn_div := 1/12;
  --pn_pot := power((1+(pn_taza/100)),pn_div);
  --pn_tea := pn_pot - 1;
  pn_denomi := (1 -
               power((1 + ((power((1 + (pn_taza / 100)), (1 / 12))) - 1)),
                      -pn_pzo));
  if pn_denomi = 0 then
    pn_formula := 0;
  else
    pn_formula := (pn_saldo *
                  ((power((1 + (pn_taza / 100)), (1 / 12))) - 1)) /
                  pn_denomi;
  end if;

end;
/

