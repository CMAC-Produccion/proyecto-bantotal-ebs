create or replace procedure SP_CR_ANULREPROMASIVCCAPIT(dfecha date,
                                                       corre  number) is
  cursor creditos is
    select *
      from jaqz698 a
     where jaqz698fep = dfecha
       and jaqz698cor = corre
     order by a.jaqz698fep desc;
  contPagos number(8);
  ln_602Ant number(8);
  flag      number(5);
begin
  --Luis Carpio/Erika Hidalgo
  begin
    for i in creditos loop
      flag := 1;
      select count(*)
        into contPagos
        from fsd602 a
       where a.pgcod = i.jaqz698emp
         and a.ppmod = i.jaqz698mod
         and a.ppsuc = i.jaqz698suc
         and a.ppmda = i.jaqz698mda
         and a.pppap = i.jaqz698pap
         and a.ppcta = i.jaqz698cta
         and a.ppoper = i.jaqz698ope
         and a.ppsbop = i.jaqz698sbo
         and a.pptope = i.jaqz698top
         and a.d602co = 'S'
       order by ppfpag;
    
      select count(*)
        into ln_602Ant
        from JAQZ520_602C a
       where a.pgcod = i.jaqz698emp
         and a.ppmod = i.jaqz698mod
         and a.ppsuc = i.jaqz698suc
         and a.ppmda = i.jaqz698mda
         and a.pppap = i.jaqz698pap
         and a.ppcta = i.jaqz698cta
         and a.ppoper = i.jaqz698ope
         and a.ppsbop = i.jaqz698sbo
         and a.pptope = i.jaqz698top
         and a.d602co = 'S'
         and a.fec = i.jaqz698fep
         and a.cor = i.jaqz698cor;
    
      --tiene pagos posteriores y estaba o estaría en mora
      if contPagos <> ln_602Ant then
        flag := 0;
      end if;
      if flag = 1 then
        execute immediate 'create table operador.fsd601_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from fsd601 ' ||
                          'where pgcod = ' || i.jaqz698emp ||
                          ' and ppmod = ' || i.jaqz698mod ||
                          ' and ppsuc = ' || i.jaqz698suc ||
                          ' and ppmda = ' || i.jaqz698mda ||
                          ' and pppap = ' || i.jaqz698pap ||
                          ' and ppcta = ' || i.jaqz698cta ||
                          ' and ppoper = ' || i.jaqz698ope ||
                          ' and ppsbop = ' || i.jaqz698sbo ||
                          ' and pptope = ' || i.jaqz698top;
        --fsd601
        delete from fsd601 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;
      
        commit;
      
        insert into fsd601
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PPFVAL,
                 PPFVTO,
                 PPPZO,
                 PPCAP,
                 PPINT,
                 PPINTMEX,
                 PPICAP,
                 PPIINT,
                 PPSTAT,
                 PPNUME,
                 PPFINV,
                 D601CD,
                 D601MO,
                 D601SU,
                 D601TR,
                 D601RE,
                 D601FC,
                 D601OR,
                 D601SB,
                 D601CO
            from JAQZ520_601C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;
      
        commit;
      
        execute immediate 'create table operador.fsd611_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from fsd611 ' ||
                          'where pgcod = ' || i.jaqz698emp ||
                          ' and ppmod = ' || i.jaqz698mod ||
                          ' and ppsuc = ' || i.jaqz698suc ||
                          ' and ppmda = ' || i.jaqz698mda ||
                          ' and pppap = ' || i.jaqz698pap ||
                          ' and ppcta = ' || i.jaqz698cta ||
                          ' and ppoper = ' || i.jaqz698ope ||
                          ' and ppsbop = ' || i.jaqz698sbo ||
                          ' and pptope = ' || i.jaqz698top;
        --fsd611
        delete from fsd611 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;
      
        commit;
      
        insert into fsd611
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PPEXTE,
                 PPIMP1,
                 PPIMP2,
                 PPIMP3,
                 PPIMP4,
                 PPIMP5,
                 PPIMP6,
                 PPIMP7,
                 PPIMP8,
                 PPIMP9,
                 PPIMP10,
                 PPIMP11,
                 PPIMP12,
                 PPIMP13,
                 PPIMP14,
                 PPIMP15,
                 PPIMP16,
                 PPIMP17,
                 PPIMP18,
                 PPIMP19,
                 PPIMP20
            from JAQZ520_611C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;
      
        commit;
      
        execute immediate 'create table operador.fsd602_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from fsd602 ' ||
                          'where pgcod = ' || i.jaqz698emp ||
                          ' and ppmod = ' || i.jaqz698mod ||
                          ' and ppsuc = ' || i.jaqz698suc ||
                          ' and ppmda = ' || i.jaqz698mda ||
                          ' and pppap = ' || i.jaqz698pap ||
                          ' and ppcta = ' || i.jaqz698cta ||
                          ' and ppoper = ' || i.jaqz698ope ||
                          ' and ppsbop = ' || i.jaqz698sbo ||
                          ' and pptope = ' || i.jaqz698top;
        --fsd602
        delete from fsd602 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;
        commit;
      
        insert into fsd602
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PP1NUMP,
                 PP1FECH,
                 PP1CAP,
                 PP1INT,
                 PP1INTMEX,
                 PP1INTM,
                 PP1INTMMEX,
                 PP1ICAP,
                 PP1IINT,
                 PP1IINTM,
                 PP1SALCAP,
                 PP1SALINT,
                 PP1SALADE,
                 PP1SALMOR,
                 PP1STAT,
                 PP1SALINTM,
                 PP1SALMORM,
                 PP1SALADEM,
                 D602CD,
                 D602MO,
                 D602SU,
                 D602TR,
                 D602RE,
                 D602FC,
                 D602OR,
                 D602SB,
                 D602CO
            from JAQZ520_602C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;
      
        commit;
      
        execute immediate 'create table operador.fsd612_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from fsd612 ' ||
                          'where pgcod = ' || i.jaqz698emp ||
                          ' and ppmod = ' || i.jaqz698mod ||
                          ' and ppsuc = ' || i.jaqz698suc ||
                          ' and ppmda = ' || i.jaqz698mda ||
                          ' and pppap = ' || i.jaqz698pap ||
                          ' and ppcta = ' || i.jaqz698cta ||
                          ' and ppoper = ' || i.jaqz698ope ||
                          ' and ppsbop = ' || i.jaqz698sbo ||
                          ' and pptope = ' || i.jaqz698top;
        --fsd612
        delete from fsd612 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;
      
        commit;
      
        insert into fsd612
          select PGCOD,
                 PPMOD,
                 PPSUC,
                 PPMDA,
                 PPPAP,
                 PPCTA,
                 PPOPER,
                 PPSBOP,
                 PPTOPE,
                 PPFPAG,
                 PPTIPO,
                 PP1NUMP,
                 PP1EXTE,
                 PP1IMP1,
                 PP1IMP2,
                 PP1IMP3,
                 PP1IMP4,
                 PP1IMP5,
                 PP1IMP6,
                 PP1IMP7,
                 PP1IMP8,
                 PP1IMP9,
                 PP1IMP10,
                 PP1IMP11,
                 PP1IMP12,
                 PP1IMP13,
                 PP1IMP14,
                 PP1IMP15,
                 PP1IMP16,
                 PP1IMP17,
                 PP1IMP18,
                 PP1IMP19,
                 PP1IMP20,
                 PP1SAL1,
                 PP1SAL2,
                 PP1SAL3,
                 PP1SAL4,
                 PP1SAL5,
                 PP1SAL6,
                 PP1SAL7,
                 PP1SAL8,
                 PP1SAL9,
                 PP1SAL10,
                 PP1SAL11,
                 PP1SAL12,
                 PP1SAL13,
                 PP1SAL14,
                 PP1SAL15,
                 PP1SAL16,
                 PP1SAL17,
                 PP1SAL18,
                 PP1SAL19,
                 PP1SAL20
            from JAQZ520_612C t
           where t.pgcod = i.jaqz698emp
             and t.ppmod = i.jaqz698mod
             and t.ppsuc = i.jaqz698suc
             and t.ppmda = i.jaqz698mda
             and t.pppap = i.jaqz698pap
             and t.ppcta = i.jaqz698cta
             and t.ppoper = i.jaqz698ope
             and t.ppsbop = i.jaqz698sbo
             and t.pptope = i.jaqz698top
             and t.fec = i.jaqz698fep
             and t.cor = i.jaqz698cor;
      
        commit;
      
        execute immediate 'create table operador.fsd010_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from fsd010 ' ||
                          'where pgcod = ' || i.jaqz698emp ||
                          ' and aomod = ' || i.jaqz698mod ||
                          ' and aosuc = ' || i.jaqz698suc ||
                          ' and aomda = ' || i.jaqz698mda ||
                          ' and aopap = ' || i.jaqz698pap ||
                          ' and aocta = ' || i.jaqz698cta ||
                          ' and aooper = ' || i.jaqz698ope ||
                          ' and aosbop = ' || i.jaqz698sbo ||
                          ' and aotope = ' || i.jaqz698top;
      
        --fsd010
        update fsd010 u
           set AOFVTO =
               (select max(AOFVTO)
                  from JAQZ520_010C t
                 where t.pgcod = i.jaqz698emp
                   and t.aomod = i.jaqz698mod
                   and t.aosuc = i.jaqz698suc
                   and t.aomda = i.jaqz698mda
                   and t.aopap = i.jaqz698pap
                   and t.aocta = i.jaqz698cta
                   and t.aooper = i.jaqz698ope
                   and t.aosbop = i.jaqz698sbo
                   and t.aotope = i.jaqz698top
                   and t.fec = i.jaqz698fep
                   and t.cor = i.jaqz698cor),
               AOPZO =
               (select max(AOPZO)
                  from JAQZ520_010C t
                 where t.pgcod = i.jaqz698emp
                   and t.aomod = i.jaqz698mod
                   and t.aosuc = i.jaqz698suc
                   and t.aomda = i.jaqz698mda
                   and t.aopap = i.jaqz698pap
                   and t.aocta = i.jaqz698cta
                   and t.aooper = i.jaqz698ope
                   and t.aosbop = i.jaqz698sbo
                   and t.aotope = i.jaqz698top
                   and t.fec = i.jaqz698fep
                   and t.cor = i.jaqz698cor)
         where u.pgcod = i.jaqz698emp
           and u.aomod = i.jaqz698mod
           and u.aosuc = i.jaqz698suc
           and u.aomda = i.jaqz698mda
           and u.aopap = i.jaqz698pap
           and u.aocta = i.jaqz698cta
           and u.aooper = i.jaqz698ope
           and u.aosbop = i.jaqz698sbo
           and u.aotope = i.jaqz698top;
      
        commit;
      
        --fsd011
      
        execute immediate 'create table operador.fsd011_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from fsd011 ' ||
                          'where pgcod = ' || i.jaqz698emp ||
                          ' and scmod = ' || i.jaqz698mod ||
                          ' and scsuc = ' || i.jaqz698suc ||
                          ' and scmda = ' || i.jaqz698mda ||
                          ' and scpap = ' || i.jaqz698pap ||
                          ' and sccta = ' || i.jaqz698cta ||
                          ' and scoper = ' || i.jaqz698ope ||
                          ' and scsbop = ' || i.jaqz698sbo ||
                          ' and sctope = ' || i.jaqz698top;
      
        update fsd011 u
           set scfvto =
               (select max(scfvto)
                  from JAQZ520_011C t
                 where t.pgcod = i.jaqz698emp
                   and t.scmod = i.jaqz698mod
                   and t.scsuc = i.jaqz698suc
                   and t.scmda = i.jaqz698mda
                   and t.scpap = i.jaqz698pap
                   and t.sccta = i.jaqz698cta
                   and t.scoper = i.jaqz698ope
                   and t.scsbop = i.jaqz698sbo
                   and t.sctope = i.jaqz698top
                   and t.fec = i.jaqz698fep
                   and t.cor = i.jaqz698cor),
               scpzo =
               (select max(scpzo)
                  from JAQZ520_011C t
                 where t.pgcod = i.jaqz698emp
                   and t.scmod = i.jaqz698mod
                   and t.scsuc = i.jaqz698suc
                   and t.scmda = i.jaqz698mda
                   and t.scpap = i.jaqz698pap
                   and t.sccta = i.jaqz698cta
                   and t.scoper = i.jaqz698ope
                   and t.scsbop = i.jaqz698sbo
                   and t.sctope = i.jaqz698top
                   and t.fec = i.jaqz698fep
                   and t.cor = i.jaqz698cor)
         where u.pgcod = i.jaqz698emp
           and u.scmod = i.jaqz698mod
           and u.scsuc = i.jaqz698suc
           and u.scmda = i.jaqz698mda
           and u.scpap = i.jaqz698pap
           and u.sccta = i.jaqz698cta
           and u.scoper = i.jaqz698ope
           and u.scsbop = i.jaqz698sbo
           and u.sctope = i.jaqz698top;
        commit;
      
        --fpp001
      
        execute immediate 'create table operador.fpp001_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from fpp001 ' ||
                          'where pgcod = ' || i.jaqz698emp ||
                          ' and aomod = ' || i.jaqz698mod ||
                          ' and aosuc = ' || i.jaqz698suc ||
                          ' and aomda = ' || i.jaqz698mda ||
                          ' and aopap = ' || i.jaqz698pap ||
                          ' and aocta = ' || i.jaqz698cta ||
                          ' and aooper = ' || i.jaqz698ope ||
                          ' and aosbop = ' || i.jaqz698sbo ||
                          ' and aotope = ' || i.jaqz698top;
      
        delete from fpp001 a
         where a.pgcod = i.jaqz698emp
           and a.aomod = i.jaqz698mod
           and a.aosuc = i.jaqz698suc
           and a.aomda = i.jaqz698mda
           and a.aopap = i.jaqz698pap
           and a.aocta = i.jaqz698cta
           and a.aooper = i.jaqz698ope
           and a.aosbop = i.jaqz698sbo
           and a.aotope = i.jaqz698top;
        commit;
      
        insert into fpp001
          select aqpa4cpgcod,
                 aqpa4caomod,
                 aqpa4caosuc,
                 aqpa4caomda,
                 aqpa4caopap,
                 aqpa4caocta,
                 aqpa4caooper,
                 aqpa4caosbop,
                 aqpa4caotope,
                 aqpa4csgcod,
                 --aqpa4cfpro,
                 aqpa4cvc,
                 aqpa4cimp,
                 aqpa4cporc,
                 aqpa4cplus,
                 aqpa4cpart,
                 aqpa4cveh,
                 aqpa4cinm,
                 aqpa4cend,
                 aqpa4cstat,
                 aqpa4cco,
                 aqpa4caux1,
                 aqpa4caux2,
                 aqpa4caux3,
                 aqpa4caux4,
                 aqpa4caux5,
                 aqpa4caux6,
                 aqpa4caux7
            from AQPA004V1 a
           where a.aqpa4cpgcod = i.jaqz698emp
             and a.aqpa4caomod = i.jaqz698mod
             and a.aqpa4caosuc = i.jaqz698suc
             and a.aqpa4caomda = i.jaqz698mda
             and a.aqpa4caopap = i.jaqz698pap
             and a.aqpa4caocta = i.jaqz698cta
             and a.aqpa4caooper = i.jaqz698ope
             and a.aqpa4caosbop = i.jaqz698sbo
             and a.aqpa4caotope = i.jaqz698top
             and a.aqpa4cfep = i.jaqz698fep
             and a.aqpa4ccor = i.jaqz698cor;
      
        commit;
      
        --fpp003
      
        execute immediate 'create table operador.fpp003_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from fpp003 ' ||
                          'where pgcod = ' || i.jaqz698emp ||
                          ' and ppmod = ' || i.jaqz698mod ||
                          ' and ppsuc = ' || i.jaqz698suc ||
                          ' and ppmda = ' || i.jaqz698mda ||
                          ' and pppap = ' || i.jaqz698pap ||
                          ' and ppcta = ' || i.jaqz698cta ||
                          ' and ppoper = ' || i.jaqz698ope ||
                          ' and ppsbop = ' || i.jaqz698sbo ||
                          ' and pptope = ' || i.jaqz698top;
      
        delete from fpp003 a
         where a.pgcod = i.jaqz698emp
           and a.ppmod = i.jaqz698mod
           and a.ppsuc = i.jaqz698suc
           and a.ppmda = i.jaqz698mda
           and a.pppap = i.jaqz698pap
           and a.ppcta = i.jaqz698cta
           and a.ppoper = i.jaqz698ope
           and a.ppsbop = i.jaqz698sbo
           and a.pptope = i.jaqz698top;
        commit;
      
        insert into fpp003
          select aqpa4dpgcod,
                 aqpa4dmod,
                 aqpa4dsuc,
                 aqpa4dmda,
                 aqpa4dpap,
                 aqpa4dcta,
                 aqpa4doper,
                 aqpa4dsbop,
                 aqpa4dtope,
                 aqpa4dfpag,
                 aqpa4dtipo,
                 aqpa4dnump,
                 aqpa4dprcnc,
                 --aqpa4dfepro,
                 aqpa4dimp,
                 aqpa4dstat,
                 aqpa4daux1,
                 aqpa4daux2,
                 aqpa4daux3
          
            from AQPA004D1 a
           where a.aqpa4dpgcod = i.jaqz698emp
             and a.aqpa4dmod = i.jaqz698mod
             and a.aqpa4dsuc = i.jaqz698suc
             and a.aqpa4dmda = i.jaqz698mda
             and a.aqpa4dpap = i.jaqz698pap
             and a.aqpa4dcta = i.jaqz698cta
             and a.aqpa4doper = i.jaqz698ope
             and a.aqpa4dsbop = i.jaqz698sbo
             and a.aqpa4dtope = i.jaqz698top
             and a.aqpa4dfep = i.jaqz698fep
             and a.aqpa4dcor = i.jaqz698cor;
      
        commit;
        --jaqz698
      
        execute immediate 'create table operador.JAQZ698_' ||
                          to_char(systimestamp, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) ||
                          ' as select * from JAQZ698 ' ||
                          'where jaqz698emp = ' || i.jaqz698emp ||
                          ' and jaqz698mod = ' || i.jaqz698mod ||
                          ' and jaqz698suc = ' || i.jaqz698suc ||
                          ' and jaqz698mda = ' || i.jaqz698mda ||
                          ' and jaqz698pap = ' || i.jaqz698pap ||
                          ' and jaqz698cta = ' || i.jaqz698cta ||
                          ' and jaqz698ope = ' || i.jaqz698ope ||
                          ' and jaqz698sbo = ' || i.jaqz698sbo ||
                          ' and jaqz698top = ' || i.jaqz698top ||
                          ' and jaqz698fep = to_date(''' ||
                          to_char(i.jaqz698fep, 'YYYYMMDD') ||
                          ''',''YYYYMMDD'') and jaqz698cor = ' ||
                          i.jaqz698cor;
      
        update jaqz698 a
           set a.jaqz698est = 'V'
         where a.jaqz698emp = i.jaqz698emp
           and a.jaqz698mod = i.jaqz698mod
           and a.jaqz698suc = i.jaqz698suc
           and a.jaqz698mda = i.jaqz698mda
           and a.jaqz698pap = i.jaqz698pap
           and a.jaqz698cta = i.jaqz698cta
           and a.jaqz698ope = i.jaqz698ope
           and a.jaqz698sbo = i.jaqz698sbo
           and a.jaqz698top = i.jaqz698top
           and a.jaqz698fep = i.jaqz698fep
           and a.jaqz698cor = i.jaqz698cor;
      
        commit;
      end if;
    end loop;
  end;
insert into AQPB876 values (user,sysdate,'SP_CR_ANULREPROMASIVCCAPIT', to_char(dfecha,'DD/MM/RRRR')||'-'||corre);
commit;
end SP_CR_ANULREPROMASIVCCAPIT;
/

