create or replace force view jaqz209 as
select "JAQZ209ID","JAQZ209SUC","JAQZ209MOD","JAQZ209TRAN",
"JAQZ209TOPE","JAQZ209OPE","JAQZ209MON","JAQZ209CTA","JAQZ209IMP",
"JAQZ209FVAL","JAQZ209FGPRO","JAQZ209FUPD","JAQZ209FCRE",
"JAQZ209USU","JAQZ209FGEST", JAQZ209FGCTA, JAQZ209CTATMP
from jaqz209@EVAL;

