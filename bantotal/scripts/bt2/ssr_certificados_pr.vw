create or replace force view ssr_certificados_pr as
select "CERT_FecEmision","CANL_Interno","FUNC_Codigo","PROD_Interno" from ssr_certificados@sisretail;

