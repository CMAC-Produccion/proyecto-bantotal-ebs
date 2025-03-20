create or replace force view v_fsd012 as
select pgcod, aomod, aosuc, aomda, aopap, aocta, aooper, aosbop, aotope, evcorr, evtipo, evfval, evfvto, evimp, evttas, evtasa, evcap,
evint, evmor, evscap, evsint, evsmor, evintc, evmorc, evcd01, evcd02, evinv, evper, evtcbi, evtcbi1, evarb, evarb1, evmd, evmd1, evpre,
evpre1, d012cd, d012mo, d012su, d012tr, d012re, d012fc, d012or, d012sb, d012co
 from FSD012
union all
select pgcod, aomod, aosuc, aomda, aopap, aocta, aooper, aosbop, aotope, evcorr, evtipo, evfval, evfvto, evimp, evttas, evtasa, evcap,
evint, evmor, evscap, evsint, evsmor, evintc, evmorc, evcd01, evcd02, evinv, evper, evtcbi, evtcbi1, evarb, evarb1, evmd, evmd1, evpre,
evpre1, d012cd, d012mo, d012su, d012tr, d012re, d012fc, d012or, d012sb, d012co
 from FSD012
 where 1=2 with read only;

