create or replace force view v_jaql707 as
select
jaql707fech, jaql707hora, jaql707idop, jaql707pgco, jaql707scsu, jaql707scmo, jaql707scmd, jaql707scpa, jaql707scct, jaql707scop,
jaql707scsb, jaql707scto, jaql707titr, jaql707bcor, jaql707suor, jaql707bcde, jaql707sude, jaql707ccio, jaql707ccid,
case
  when jaql707tacr not like '0000%' then
       trim(substr(trim(jaql707tacr),0,6)||'******'||substr(trim(jaql707tacr),13,4)||substr(trim(jaql707tacr),17,27))
  else jaql707tacr
  end jaql707tacr,
jaql707tita, jaql707plaz, jaql707impo, jaql707mcob, jaql707icob, jaql707mcoc, jaql707icoc, jaql707paor, jaql707tdor,
jaql707ndor, jaql707noor, jaql707dior, jaql707pabe, jaql707tdbe, jaql707ndbe, jaql707nobe, jaql707dibe, jaql707tebe, jaql707refe, jaql707clas,
jaql707cana, jaql707conc, jaql707itcd, jaql707itsu, jaql707itmo, jaql707ittr, jaql707itre, jaql707itfc, jaql707itor, jaql707itso,
jaql707itco,jaql707au01, jaql707au02, jaql707au03, jaql707au04, jaql707au05, jaql707au06, jaql707au07, jaql707au08, jaql707au09,
jaql707au10, jaql707au11, jaql707au12, jaql707ctme, jaql707ctan, jaql707ctsu, jaql707reca, jaql707fliq, jaql707mliq, jaql707atra,jaql707pxvl,
jaql707pxtp
from JAQL707;

