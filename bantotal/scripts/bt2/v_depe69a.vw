create or replace force view v_depe69a as
select
a.depe69aapl, a.depe69aban, a.depe69aenv, a.depe69acor, a.depe69atr, a.depe69anex, a.depe69amem, a.depe69aser, a.depe69aemi, a.depe69arec, a.depe69abin,
decode(a.depe69atar,b.Z0E478NRO,substr(a.depe69atar,0,6)||'******'||substr(a.depe69atar,13,4),a.depe69atar) depe69atar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.depe69aftr, a.depe69afpr, a.depe69acla, a.depe69acod, a.depe69amco, a.depe69aico, a.depe69aori, a.depe69aora, a.depe69amor, a.depe69aior, a.depe69atrc,
a.depe69aaut, a.depe69ater, a.depe69abir, a.depe69accl, a.depe69aces, a.depe69acus, a.depe69afin, a.depe69aire, a.depe69apem, a.depe69apre, a.depe69areg,
a.depe69arer, a.depe69atta, a.depe69atpr, a.depe69agir, a.depe69acco, a.depe69ator, a.depe69anom, a.depe69acit, a.depe69apaf, a.depe69apro, a.depe69apos,
a.depe69alpo, a.depe69arem, a.depe69aafi, a.depe69aite, a.depe69aidt, a.depe69aiau, a.depe69aies, a.depe69afla, a.depe69asel, a.depe69aicp, a.depe69aniv,
a.depe69acca, a.depe69acab, a.depe69agto, a.depe69acob, a.depe69arei, a.depe69amon, a.depe69atpm, a.depe69acas, a.depe69avca, a.depe69acom, a.depe69aglo,
a.depe69atit, a.depe69afsw, a.depe69acsw, a.depe69aimd, a.depe69acop, a.depe69acrp, a.depe69ahsw, a.depe69aipa, a.depe69asin, a.depe69acfa, a.depe69arct,
a.depe69acon, a.depe69aemp, a.depe69amod, a.depe69asuc, a.depe69atrn, a.depe69anre, a.depe69afco, a.depe69aman, a.depe69angi, a.depe69amap, a.depe69aere,
a.depe69acpr, a.depe69ancu, a.depe69acli
 from depe69a a left outer join Z0E478 b
  on a.depe69atar=b.Z0E478NRO;

