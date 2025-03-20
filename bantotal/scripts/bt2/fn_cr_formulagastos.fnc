create or replace function fn_Cr_FormulaGastos(
pn_saldo in number, 
pn_taza in number, 
pn_pzo in number
) return number is
  pn_formula number;
begin
  select (pn_saldo * ((power((1+(pn_taza/100)),(1/12))) - 1))/(1-power((1+((power((1+(pn_taza/100)),(1/12))) - 1)),-pn_pzo))  into pn_formula from dual;
  return(pn_formula);
end fn_Cr_FormulaGastos;
/

