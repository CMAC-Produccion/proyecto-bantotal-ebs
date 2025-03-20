create or replace force view jaql363 as
select
"CANL_Interno" "JAQL363INTER",
"FUNC_CodManual" "JAQL363DOCMA",
"FUNC_NomCom" "JAQL363NOMCO",
"FUNC_DocIden" "JAQL363DOCFU",
"FUNC_Sexo" "JAQL363SEXOF",
"FUNC_Direccion" "JAQL363DIREC",
"FUNC_Telefono1" "JAQL363TELF1",
"FUNC_Telefono2" "JAQL363TELF2",
"FUNC_Email" "JAQL363EMAIL",
"TIPO_CodFun" "JAQL363CODFU",
"TIPO_TabFun" "JAQL363TABFU",
"AGEN_CodManual" "JAQL363CODAG",
"FUNC_Habilitado" "JAQL363HABIL",
"FUNC_comisionCCS" "JAQL363COCCS",
"FUNC_comisionPN" "JAQL363COMPN",
"FUNC_ID" "JAQL363FUNID"
from  IMP_Funcionarios@sisretail;

