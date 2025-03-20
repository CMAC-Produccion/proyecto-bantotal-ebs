create or replace force view ssr_funcionarios_pr as
select "FUNC_NomCom","CANL_Interno","FUNC_Codigo" from SSR_Funcionarios@sisretail;

