create or replace force view v_jaql706 as
select
jaql706pgco, jaql706scsu, jaql706scmo, jaql706scmd, jaql706scpa, jaql706scct, jaql706scop, jaql706scsb, jaql706scto,
jaql706trco, jaql706titr, jaql706bcor, jaql706suor, jaql706bcde, jaql706sude, jaql706ccio, jaql706ccid,
--jaql706tacr,
case
  when jaql706tacr not like '0000%' then
       trim(substr(trim(jaql706tacr),0,6)||'******'||substr(trim(jaql706tacr),13,4)||substr(trim(jaql706tacr),17,27))
  else jaql706tacr
  end jaql706tacr,
jaql706tita, jaql706plaz, jaql706impo, jaql706mcob, jaql706icob, jaql706mcoc, jaql706icoc, jaql706paor, jaql706tdor,
jaql706ndor, jaql706noor, jaql706dior, jaql706pabe, jaql706tdbe, jaql706ndbe, jaql706nobe, jaql706dibe, jaql706tebe,
jaql706refe, jaql706clas, jaql706cana, jaql706conc, jaql706itcd, jaql706itsu, jaql706itmo, jaql706ittr, jaql706itre,
jaql706itfc, jaql706itor, jaql706itso, jaql706itco, jaql706au01, jaql706au02, jaql706au03, jaql706au04, jaql706au05,
jaql706au06, jaql706au07, jaql706au08, jaql706au09, jaql706au10, jaql706au11, jaql706au12, jaql706trac, jaql706hora,
jaql706fech, jaql706term, jaql706user, jaql706esta, jaql706ctme, jaql706ctan, jaql706ctsu, jaql706reca, jaql706regf,
jaql706regh, jaql706regr,JAQL706FLIQ,JAQL706MLIQ,JAQL706ATRA,jaql706hfin,jaql706mtrx,jaql706dir,jaql706pxvl,jaql706pxtp,
jaql706trama,jaql706fecap,jaql706fecre
from JAQL706
;

