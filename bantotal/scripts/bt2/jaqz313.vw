create or replace force view jaqz313 as
select ciacod as JAQZ313CODIN, cpagcod as JAQZ313PACOD, cpaginstcod JAQZ313PAINS,
cpagnom1 as JAQZ313PRINO,
cpagnom2 as JAQZ313SEGNO,
cpagapepat as JAQZ313APEPA,
cpagapemat as JAQZ313APEMA,
cpagesta as JAQZ313ESTA
from cmpag10@cole;

