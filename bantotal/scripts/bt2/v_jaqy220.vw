create or replace force view v_jaqy220 as
select
jaqy220cor, jaqy220usu, jaqy220mov, jaqy220fmv, jaqy220cct, jaqy220fvl, jaqy220dsc,
case
    when a.jaqy220doc like '4261%' then
      substr(trim(a.jaqy220doc),0,6)||'******'||substr(trim(a.jaqy220doc),13,30)
  else a.jaqy220doc
    end jaqy220doc,
jaqy220dep, jaqy220ret, jaqy220sdo, jaqy220ope, jaqy220age, jaqy220hor, jaqy220ndp, jaqy220omd, jaqy220mt1, jaqy220mt2, jaqy220mt3,
jaqy220ch1, jaqy220ch2, jaqy220ch3, jaqy220da1, jaqy220da2, jaqy220da3, jaqy220nu1, jaqy220nu2, jaqy220nu3, jaqy220tsu, jaqy220tmo,
jaqy220ttr, jaqy220tre, jaqy220tor, jaqy220tsb
from JAQY220  a;

