create or replace force view v_jaqz759 as
select
substr(jaqz759ntar,0,6)||'******'||substr(jaqz759ntar,13,4) jaqz759ntar,
jaqz759pai, jaqz759tdc,
'****'||substr(trim(jaqz759ndc),5,length(trim(jaqz759ndc))-4)  jaqz759ndc,
jaqz759cmod,jaqz759sucor, jaqz759tran, jaqz759nrel, jaqz759cord, jaqz759fcon, jaqz759crec, jaqz759cimp1, jaqz759modul, jaqz759oper,
jaqz759sct, jaqz759cta, jaqz759pap, jaqz759mda, jaqz759sucur, jaqz759toper, jaqz759mod, jaqz759imp, jaqz759est, jaqz759can, jaqz759ext,
jaqz759hrc
from JAQZ759;

