create or replace force view jaql736 as
select z0e4gcapl jaql736apl,
       z0e4gcban jaql736ban,
       z0e4gccor jaql736cor,
       z0e4gcco2 jaql736co2,
       decode(z0e4gcdpg, 0, z0e4gccpg, z0e4gcdpg) jaql736pgc,
       decode(z0e4gcdsu, 0, z0e4gcsu, z0e4gcdsu) jaql736suc,
       decode(z0e4gcdmd, 0, z0e4gccmd, z0e4gcdmd) jaql736mod,
       decode(z0e4gcdmo, 0, z0e4gccmo, z0e4gcdmo) jaql736mda,
       decode(z0e4gcdpa, 0, z0e4gccpa, z0e4gcdpa) jaql736pap,
       decode(z0e4gcdct, 0, z0e4gccct, z0e4gcdct) jaql736sct,
       decode(z0e4gcdsc, 0, z0e4gccsc, z0e4gcdsc) jaql736sbo,
       decode(z0e4gcdto, 0, z0e4gccto, z0e4gcdto) jaql736top,
       decode(z0e4gcdop, 0, z0e4gccop, z0e4gcdop) jaql736ope,
       Z0e4gcfec JAQL736FMV,
       a3.cmnom JAQL736CCT,
       a4.trnom JAQL736DSC,
       Z0e4gctar JAQL736DOC,
       decode(Z0E4GCDCT, 0, Z0e4gcimc, 0) JAQL736DEP,
       decode(Z0E4GCcCT, 0, Z0e4gcimd, 0) JAQL736RET,
       Z0e4gchor JAQL736HOR,
       Z0E4GCTER jaql736TER,
       trunc(a2.tp1imp1) JAQL736TSU,
       a2.tp1nro1 JAQL736TMO,
       a2.tp1nro2 JAQL736TTR,
       Z0e4gcrel JAQL736TRE,
       0 JAQL736TOR,
       0 JAQL736TSB,
       Z0e4gcest JAQL736est
  from Z0e4gc a1, fst198 a2, fst025 a3, fst034 a4
 where a2.tp1cod = decode(z0e4gcdpg, 0, z0e4gccpg, z0e4gcdpg)
   and a2.tp1cod1 = 10822
   and a2.tp1corr1 = 6
   and a2.tp1corr2 = 1
   and a2.tp1corr3 = to_number(a1.Z0E4GCTOP)
   and a3.cmcod = a2.tp1nro3
   and a4.pgcod = a2.tp1cod
   and a4.trmod = a2.tp1nro1
   and a4.trnro = a2.tp1nro2;

