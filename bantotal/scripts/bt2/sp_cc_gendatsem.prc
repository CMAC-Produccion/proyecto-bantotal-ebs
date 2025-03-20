create or replace procedure SP_CC_GENDATSEM
 is
  ---> OJO - Sistema NO pregunta - Elimina Información - OJO
  ----------------------------------------------------------
  pn_CodPro    number;
  ls_Cad001    varchar2(32000);
  ls_Cad002    varchar2(32000);
  ls_Cad003    varchar2(32000);
  ls_FecCie    varchar2(10);
  ls_FecPro    varchar2(10);
  ls_FecRcc    varchar2(10);
  ls_FecEnd    varchar2(10);
  ls_IndFec    varchar2(8);
  ls_AnoCie    varchar2(4);
  ls_MesCie    varchar2(2);
  ln_NumReg    number;
  ln_CodPro    number;
  ld_FecCie    date;
  ld_FecCieMor date;
  ld_SobEnd    date;

begin
  delete from jaql831d_aux;
  commit;


  ls_Cad001 := 'create table operador.jaql831_' ||
               to_char(sysdate, 'ddmmyyyy') ||
               ' compress as 
        select * from jaql831';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'create table operador.jaql831d_' ||
               to_char(sysdate, 'ddmmyyyy') ||
               ' compress as 
        select * from jaql831d';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'create table operador.jaql831a_' ||
               to_char(sysdate, 'ddmmyyyy') ||
               ' compress as 
        select * from jaql831a';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'create table operador.jaql831e_' ||
               to_char(sysdate, 'ddmmyyyy') ||
               ' compress as 
        select * from jaql831e';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  execute immediate ls_Cad001;

  ls_Cad001 := 'ALTER SESSION SET NLS_TERRITORY=''SPAIN''';
  execute immediate ls_Cad001;

  --ld_FecCie := Trunc(sysdate) - to_number(to_char(trunc(sysdate),'d'));                     -- Último domingo
  ld_FecCie    := trunc(sysdate - 1);
  ld_FecCieMor := trunc(sysdate);
  --ld_FecCie := to_date('2017.07.30','yyyy.mm.dd');
  --ld_FecCie := to_date('2017.02.28','yyyy.mm.dd');
  ls_IndFec := to_char(ld_FecCie, 'yyyymmdd');

  ls_FecCie := to_char(Trunc(ld_feccie) - to_char(Trunc(ld_feccie), 'DD'),
                       'yyyy.mm.dd'); -- Fecha de Cierre de Mes
  --ls_FecCie:= '2019.08.31';           -- Fecha de Cierre de Mes

  ls_AnoCie := substr(ls_FecCie, 1, 4);
  ls_MesCie := substr(ls_FecCie, 6, 2);

  ls_FecPro := to_char(Trunc(sysdate), 'yyyy.mm.dd'); -- Fecha de Proceso (Sistema)

  select to_char(max(d_fecpre), 'yyyy.mm.dd') into ls_FecRcc from cldrcci;
  ls_Cad001 := 'select max(y_490s.jaqy490fec) from jaqy490s y_490s';
  execute immediate ls_Cad001
    into ld_SobEnd; -- Fecha del Sobreendeudamiento
  ls_FecEnd := to_char(ld_SobEnd, 'yyyy.mm.dd');

  select nvl(max(jaql831cpro), 0)
    into ln_CodPro
    from jaql831
   where jaql831tpro = 1;
  ln_CodPro := ln_CodPro + 1;
  pn_CodPro := ln_CodPro;
  ls_Cad001 := 'insert into jaql831
                (jaql831cpro,jaql831fpro,jaql831tpro,jaql831hini,jaql831hfin,
                 jaql831nreg,jaql831obse,jaql831fsis,jaql831frcc,jaql831ffin)
                 values
                (' || to_char(ln_CodPro, '999999999') ||
               ',to_date(''' || to_char(ld_FecCie, 'yyyy.mm.dd') ||
               ''',''yyyy.mm.dd''),
                 1,to_char(sysdate,''HH24:MI:SS''),to_char(sysdate,''HH24:MI:SS''),0,''Genera Data Total'',
                 to_date(''' || ls_FecPro ||
               ''',''yyyy.mm.dd''),to_date(''' || ls_FecRcc ||
               ''',''yyyy.mm.dd''),
                 to_date(''' || ls_FecEnd ||
               ''',''yyyy.mm.dd''))';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'truncate table JAQL831A';
  execute immediate ls_Cad001;
  commit;

  ---> Genera Data
  ls_Cad001 := 'insert into jaql831A
                 select /*+index(h_012 FSH01210) index(d_010 SYS_C00977166)*/
                        h_012.bcemp,d_010.aomod,d_010.aocta,d_010.aooper,d_010.aotope,d_010.aosbop,
                        d_010.aomda,d_010.aoimp,PQ_CC_CONSULTAS_BT.BT_Fec_Desemb(d_010.aocta,d_010.aooper),
                        PQ_CC_CONSULTAS_BT.BT_TEA_Credito(d_010.pgcod,d_010.aomod,d_010.aosuc,d_010.aomda,d_010.aopap,
                                                          d_010.aocta,d_010.aooper,d_010.aosbop,d_010.aotope),
                        d_010.aosuc,h_012.bcrubr,''00000000000000'',abs(h_012.bcsdmo),abs(h_012.bcsdmn),
                        ''xxxxxxxxxx'',99999,to_date(''1990.01.01'',''yyyy.mm.dd''),d_010.aostat,
                        0,0,'' '','' '',
                        round(PQ_CC_CONSULTAS_BT.BT_Factor_Mora(d_010.pgcod,d_010.aomod,d_010.aosuc,d_010.aomda,d_010.aopap,
                                                                d_010.aocta,d_010.aooper,d_010.aosbop,d_010.aotope),4),
                        to_date(''' ||
               to_char(ld_FecCie, 'yyyy.mm.dd') || ''',''yyyy.mm.dd'')' || ',
                        '' '','' ''
                   from fsh012 h_012,
                        fsd010 d_010
                  where h_012.bcemp = d_010.pgcod
                    and h_012.bcfech = to_date(''' ||
               to_char(ld_FecCie, 'yyyy.mm.dd') ||
               ''',''yyyy.mm.dd'')
                    and h_012.bcmod = d_010.aomod
                    and h_012.bcsuc = d_010.aosuc
                    and h_012.bcmda = d_010.aomda
                    and h_012.bcpap = d_010.aopap
                    and h_012.bccta = d_010.aocta
                    and h_012.bcoper = d_010.aooper
                    and h_012.bcsbop = d_010.aosbop
                    and h_012.bctop = d_010.aotope
                    and h_012.bcmod in (101,102,103,104,105,116,141,142,106,109,110,112,113,115)
                    and d_010.aostat not in (21,22,23,25,33,34,99)
                    and h_012.bcsdmo <> 0';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'delete jaql831a
                  where jaql831aCodMod = 103
                    and jaql831aCodTip in (50,51)';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831a
                    set jaql831aVenCuo = PQ_CC_CONSULTAS_BT.BT_CuotaVence(jaql831aCuenta,jaql831aOperac,jaql831aCodTip,jaql831aSubTip,jaql831aCodMod,
                                                       jaql831aCodAge,jaql831aMoneda,Trunc(sysdate))';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831a
                    set jaql831aDiaAtr = to_date(''' ||
               to_char(ld_FecCieMor, 'yyyy.mm.dd') ||
               ''',''yyyy.mm.dd'') - jaql831aVenCuo';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831a
                    set jaql831aCodSbs = (select lpad(max(x739.bc739sbs),10,''0'')
                                           from FBC739 x739
                                          where x739.bc739cta = jaql831aCuenta)';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831a
                    set jaql831aCodPai = (select r_008.pepais
                                            from fsr008 r_008
                                           where r_008.pgcod = 1
                                             and r_008.ctnro = jaql831aCuenta
                                             and r_008.cttfir = ''T''),
                        jaql831aTipDoc = (select r_008.petdoc
                                            from fsr008 r_008
                                           where r_008.pgcod = 1
                                             and r_008.ctnro = jaql831aCuenta
                                             and r_008.cttfir = ''T''),
                        jaql831aNumDoc = (select r_008.pendoc
                                            from fsr008 r_008
                                           where r_008.pgcod = 1
                                             and r_008.ctnro = jaql831aCuenta
                                             and r_008.cttfir = ''T'')';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831
                    set jaql831hfin = to_char(sysdate,''HH24:MI:SS''),
                        jaql831nreg = (select count(*) from jaql831a)
                  where jaql831tpro = 1
                    and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ----> Fin de la Creación de la Data.

  ls_Cad001 := 'insert into jaql831d
                 select ' ||
               trim(to_char(ln_CodPro, '999999999')) ||
               ',Dia_0.jaql831aCuenta,Dia_0.jaql831aOperac,
                        (select trim(r_008.pendoc)
                           from fsr008 r_008
                          where Dia_0.jaql831aCuenta = r_008.ctnro
                            and r_008.cttfir = ''T''),'' '',
                        (select t_003.mdnom
                           from fst003 t_003
                          where Dia_0.jaql831aCodMod = t_003.modulo) prod,
                        case
                        when Dia_0.jaql831atipdoc = 9 then
                            (select trim(d_003.pjrazs)
                               from fsd003 d_003
                              where d_003.pjpais = Dia_0.jaql831acodpai
                                and d_003.pjtdoc = Dia_0.jaql831atipdoc
                                and d_003.pjndoc = Dia_0.jaql831anumdoc)
                        else
                            (select trim(d_002.pfnom1) || '' '' ||  trim(d_002.pfnom2)
                               from fsd002 d_002
                              where d_002.pfpais = Dia_0.jaql831acodpai
                                and d_002.pftdoc = Dia_0.jaql831atipdoc
                                and d_002.pfndoc = Dia_0.jaql831anumdoc)
                         end nomb,
                        (select trim(d_002.pfape1)
                           from fsd002 d_002
                          where d_002.pfpais = Dia_0.jaql831acodpai
                            and d_002.pftdoc = Dia_0.jaql831atipdoc
                            and d_002.pfndoc = Dia_0.jaql831anumdoc) apat,
                        (select trim(d_002.pfape2)
                           from fsd002 d_002
                          where d_002.pfpais = Dia_0.jaql831acodpai
                            and d_002.pftdoc = Dia_0.jaql831atipdoc
                            and d_002.pfndoc = Dia_0.jaql831anumdoc) amat,
                        Dia_0.jaql831aDiaAtr dmor,'' '' rmor,
                        PQ_CC_CONSULTAS_BT.BT_Deuda_Mora(1,Dia_0.jaql831aCodMod,Dia_0.jaql831aCodAge,Dia_0.jaql831aMoneda,
                                      0,Dia_0.jaql831aCuenta,Dia_0.jaql831aOperac,Dia_0.jaql831aSubTip,
                                      Dia_0.jaql831aCodTip,Dia_0.jaql831aFacMor,Dia_0.jaql831aDiaAtr) smor,
                        PQ_CC_CONSULTAS_BT.BT_Deuda_Capital(1,Dia_0.jaql831aCodMod,Dia_0.jaql831aCodAge,Dia_0.jaql831aMoneda,
                                      0,Dia_0.jaql831aCuenta,Dia_0.jaql831aOperac,Dia_0.jaql831aSubTip,Dia_0.jaql831aCodTip) sacc,
                        (select nvl(abs(d_011.scsdo),0)
                           from fsd011 d_011
                          where d_011.pgcod = Dia_0.jaql831aCodEmp
                            and d_011.scsuc = Dia_0.jaql831aCodAge
                            and d_011.scmda = Dia_0.jaql831aMoneda
                            and d_011.scpap = 0
                            and d_011.sccta = Dia_0.jaql831aCuenta
                            and d_011.scoper = Dia_0.jaql831aOperac
                            and d_011.scsbop = Dia_0.jaql831aSubTip
                            and d_011.sctope = Dia_0.jaql831aCodTip
                            and rownum =  1
                            and d_011.scmod  = Dia_0.jaql831aCodMod) scap,
                        (select nvl(abs(d_010.aoimp),0)
                           from fsd010 d_010
                          where d_010.pgcod = Dia_0.jaql831aCodEmp
                            and d_010.aosuc = Dia_0.jaql831aCodAge
                            and d_010.aomda = Dia_0.jaql831aMoneda
                            and d_010.aopap = 0
                            and d_010.aocta = Dia_0.jaql831aCuenta
                            and d_010.aooper = Dia_0.jaql831aOperac
                            and d_010.aosbop = Dia_0.jaql831aSubTip
                            and d_010.aotope = Dia_0.jaql831aCodTip
                            and d_010.aomod  = Dia_0.jaql831aCodMod) mlim,
                        '' '' cfac,'' '' ffac,Dia_0.jaql831aVenCuo fven,
                        (select t_005.mosign
                           from fst005 t_005
                          where t_005.moneda = Dia_0.jaql831amoneda) mone,0 mptm,
                        PQ_CC_CONSULTAS_BT.BT_Mto_Cuota(Dia_0.jaql831aCuenta,Dia_0.jaql831aOperac,
                                                        Dia_0.jaql831aCodTip,Dia_0.jaql831aSubTip,
                                                        Dia_0.jaql831aCodMod,Dia_0.jaql831aCodAge,
                                                        Dia_0.jaql831aMoneda) mcuo,
                        (select nvl(sum(d_602x.pp1cap + d_602x.Pp1int + d_602x.Pp1intm),0)
                           from fsd602 d_602x
                          where d_602x.pgcod = 1
                            and Dia_0.jaql831aCodMod = d_602x.ppmod
                            and Dia_0.jaql831acodage = d_602x.ppsuc
                            and Dia_0.jaql831amoneda = d_602x.ppmda
                            and d_602x.pppap = 0
                            and Dia_0.jaql831aCuenta = d_602x.ppcta
                            and Dia_0.jaql831aOperac = d_602x.ppoper
                            and Dia_0.jaql831aSubtip = d_602x.ppsbop
                            and Dia_0.jaql831aCodTip = d_602x.pptope
                            and d_602x.d602mo in (30,35,209,490,140)
                            and d_602x.d602tr not in (508)
                            and d_602x.d602co = ''S''
                            and d_602x.Pp1fech = (select nvl(max(d_602.pp1fech), to_date(''1901.01.01'',''yyyy.mm.dd''))
                                                        from fsd602 d_602
                                                       where d_602.pgcod = 1
                                                         and Dia_0.jaql831aCodMod = d_602.ppmod
                                                         and Dia_0.jaql831acodage = d_602.ppsuc
                                                         and Dia_0.jaql831amoneda = d_602.ppmda
                                                         and d_602.pppap = 0
                                                         and Dia_0.jaql831aCuenta = d_602.ppcta
                                                         and Dia_0.jaql831aOperac = d_602.ppoper
                                                         and Dia_0.jaql831aSubtip = d_602.ppsbop
                                                         and Dia_0.jaql831aCodTip = d_602.pptope
                                                         and d_602.d602co = ''S'')) mupa,
                        (select max(d_602x.Pp1fech - d_602x.Ppfpag)
                           from fsd602 d_602x
                          where d_602x.pgcod = 1
                            and Dia_0.jaql831aCodMod = d_602x.ppmod
                            and Dia_0.jaql831acodage = d_602x.ppsuc
                            and Dia_0.jaql831amoneda = d_602x.ppmda
                            and d_602x.pppap = 0
                            and Dia_0.jaql831aCuenta = d_602x.ppcta
                            and Dia_0.jaql831aOperac = d_602x.ppoper
                            and Dia_0.jaql831aSubtip = d_602x.ppsbop
                            and Dia_0.jaql831aCodTip = d_602x.pptope
                            and d_602x.d602mo in (30,35,209,490,140)
                            and d_602x.d602tr not in (508)
                            and d_602x.pp1cap <> 0
                            and d_602x.d602co = ''S''
                            and d_602x.pp1stat = ''T''
                            and d_602x.Ppfpag = (select nvl(max(d_602.Ppfpag), to_date(''1901.01.01'',''yyyy.mm.dd''))
                                                   from fsd602 d_602
                                                  where d_602.pgcod = 1
                                                    and Dia_0.jaql831aCodMod = d_602.ppmod
                                                    and Dia_0.jaql831acodage = d_602.ppsuc
                                                    and Dia_0.jaql831amoneda = d_602.ppmda
                                                    and d_602.pppap = 0
                                                    and Dia_0.jaql831aCuenta = d_602.ppcta
                                                    and Dia_0.jaql831aOperac = d_602.ppoper
                                                    and Dia_0.jaql831aSubtip = d_602.ppsbop
                                                   and Dia_0.jaql831aCodTip = d_602.pptope
                                                    and d_602.d602mo in (30,35,209,490,140)
                                                    and d_602.d602tr not in (508)
                                                    and d_602.pp1cap <> 0
                                                    and d_602.pp1stat = ''T''
                                                    and d_602.d602co = ''S'')) daup,
                        (select max(d_602x.Pp1fech)
                           from fsd602 d_602x
                          where d_602x.pgcod = 1
                            and Dia_0.jaql831aCodMod = d_602x.ppmod
                            and Dia_0.jaql831acodage = d_602x.ppsuc
                            and Dia_0.jaql831amoneda = d_602x.ppmda
                            and d_602x.pppap = 0
                            and Dia_0.jaql831aCuenta = d_602x.ppcta
                            and Dia_0.jaql831aOperac = d_602x.ppoper
                            and Dia_0.jaql831aSubtip = d_602x.ppsbop
                            and Dia_0.jaql831aCodTip = d_602x.pptope
                            and d_602x.d602mo in (30,35,209,490,140)
                            and d_602x.d602tr not in (508)
                            and d_602x.d602co = ''S'') feup,
                        (select d_002.pfcant
                           from fsd002 d_002
                          where Dia_0.jaql831acodpai = d_002.pfpais
                            and Dia_0.jaql831atipdoc = d_002.pftdoc
                            and Dia_0.jaql831anumdoc = d_002.pfndoc) sexo,
                        (select t_009.ecnom
                           from fst009 t_009
                          where t_009.eccod = (select d_002.pfeciv
                                                 from fsd002 d_002
                                                where Dia_0.jaql831acodpai = d_002.pfpais
                                                  and Dia_0.jaql831atipdoc = d_002.pftdoc
                                                  and Dia_0.jaql831anumdoc = d_002.pfndoc)) eciv,
                        (decode((select d_001.petipo
                                   from fsd001 d_001
                                  where d_001.pepais = Dia_0.jaql831acodpai
                                    and d_001.petdoc = Dia_0.jaql831atipdoc
                                    and d_001.pendoc = Dia_0.jaql831anumdoc),''F'',''Persona Natural'',
                        decode((select d_001.petipo
                                  from fsd001 d_001
                                 where d_001.pepais = Dia_0.jaql831acodpai
                                    and d_001.petdoc = Dia_0.jaql831atipdoc
                                    and d_001.pendoc = Dia_0.jaql831anumdoc),''J'',''Persona Juridica'',''Error en Tipo''))) tper,
                        (select d_002.pffnac
                           from fsd002 d_002
                          where d_002.pfpais = Dia_0.jaql831acodpai
                            and d_002.pftdoc = Dia_0.jaql831atipdoc
                            and d_002.pfndoc = Dia_0.jaql831anumdoc) fnac,
                        (select trunc((to_date(''' ||
               ls_FecPro ||
               ''',''yyyy.mm.dd'') -
                                (select d_002.pffnac
                                   from fsd002 d_002
                                  where d_002.pfpais = Dia_0.jaql831acodpai
                                    and d_002.pftdoc = Dia_0.jaql831atipdoc
                                    and d_002.pfndoc = Dia_0.jaql831anumdoc)) / 365) from dual) edad,
                        (select t_114.ninsdsc
                           from fst114 t_114
                          where t_114.ninscod = (select e_002.NinsCod
                                                   from fse002 e_002
                                                  where e_002.pfxpais = Dia_0.jaql831acodpai
                                                    and e_002.pfxtdoc = Dia_0.jaql831atipdoc
                                                    and e_002.pfxndoc = Dia_0.jaql831anumdoc)) nest,
                        (select c07.sngc07dsc
                          from SNGC07 c07
                         where c07.sngc07cod = (select gc_60.sngc60ocup
                                                  from sngc60 gc_60
                                                 where gc_60.sngc60pais = Dia_0.jaql831acodpai
                                                   and gc_60.sngc60tdoc = Dia_0.jaql831atipdoc
                                                   and gc_60.sngc60ndoc = Dia_0.jaql831anumdoc
                                                   and gc_60.sngc60corr = (select max(gc_60a.sngc60corr)
                                                                             from sngc60 gc_60a
                                                                            where gc_60a.sngc60pais = Dia_0.jaql831acodpai
                                                                              and gc_60a.sngc60tdoc = Dia_0.jaql831atipdoc
                                                                              and gc_60a.sngc60ndoc = Dia_0.jaql831anumdoc))) ocup,
                        (select trim(gc_60.sngc60rzso) || '' RUC '' || trim(gc_60.sngc60rute)
                           from sngc60 gc_60
                          where gc_60.sngc60pais = Dia_0.jaql831acodpai
                            and gc_60.sngc60tdoc = Dia_0.jaql831atipdoc
                            and gc_60.sngc60ndoc = Dia_0.jaql831anumdoc
                            and gc_60.sngc60corr = (select max(gc_60a.sngc60corr)
                                                      from sngc60 gc_60a
                                                     where gc_60a.sngc60pais = Dia_0.jaql831acodpai
                                                       and gc_60a.sngc60tdoc = Dia_0.jaql831atipdoc
                                                       and gc_60a.sngc60ndoc = Dia_0.jaql831anumdoc)) ctra,';

  ls_Cad002 := '(select st_41.segnom
                           from fst041 st_41
                          where st_41.segcod = (select c07.segcod
                                                  from sngc07 c07
                                                 where c07.sngc07cod = (select gc_60.sngc60ocup
                                                                          from sngc60 gc_60
                                                                         where gc_60.sngc60pais = Dia_0.jaql831acodpai
                                                                           and gc_60.sngc60tdoc = Dia_0.jaql831atipdoc
                                                                          and gc_60.sngc60ndoc = Dia_0.jaql831anumdoc
                                                                           and gc_60.sngc60corr = (select max(gc_60a.sngc60corr)
                                                                                                     from sngc60 gc_60a
                                                                                                    where gc_60a.sngc60pais = Dia_0.jaql831acodpai
                                                                                                      and gc_60a.sngc60tdoc = Dia_0.jaql831atipdoc
                                                                                                      and gc_60a.sngc60ndoc = Dia_0.jaql831anumdoc)))) slab,
                        (select gc_12.sngc12dsc
                           from sngc12 gc_12
                          where gc_12.sngc12vivc = (select gc_13.SNGC12Vivc
                                                      from sngc13 gc_13
                                                     where gc_13.sngc13pais = Dia_0.jaql831acodpai
                                                       and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                                                       and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                                                       and gc_13.docod = 1
                                                       and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                                                  from sngc13 gc_13a
                                                                                 where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                                                   and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                                                   and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                                                   and gc_13a.docod = 1)))) tviv,
                        (select trim(t_810.regnom)
                           from fst810 t_810,
                                fst811 t_811
                          where Dia_0.jaql831acodage = t_811.oficod
                            and t_811.regcod = t_810.regcod
                            and t_810.regcod < 100) regi,'' '' plaz,
                        (select gc_13.sngc13dir
                           from sngc13 gc_13
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.docod = 1
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                        and gc_13a.docod = 1))) ddom,
                        (select ubig_01.fst071dsc
                          from sngc13 gc_13,
                               fst071 ubig_01
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.sngc13dist = ubig_01.fst071col
                             and gc_13.docod = 1
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                         from sngc13 gc_13a
                                                        where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                          and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                          and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                          and gc_13a.docod = 1))) disd,
                        (select ubig_01.locnom
                          from sngc13 gc_13,
                               fst070 ubig_01
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.sngc13prov = ubig_01.loccod
                             and gc_13.docod = 1
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                         and gc_13a.docod = 1))) dciu,
                        (select ubig_01.depnom
                          from sngc13 gc_13,
                               fst068 ubig_01
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.sngc13dpto = ubig_01.depcod
                             and gc_13.docod = 1
                             and rownum = 1
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                         and gc_13a.docod = 1))) ddep,
                        (select upper(gc_13.sngc13ref1)
                          from sngc13 gc_13,
                               fst071 ubig_01
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.sngc13dist = ubig_01.fst071col
                             and gc_13.docod = 1
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                         and gc_13a.docod = 1))) dref,
                         (select gc_13.sngc13dir
                            from sngc13 gc_13
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                            and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.docod = 4
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                         and gc_13a.docod = 4))) dlab,
                        (select ubig_01.fst071dsc
                          from sngc13 gc_13,
                               fst071 ubig_01
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.sngc13dist = ubig_01.fst071col
                             and gc_13.docod = 4
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                         and gc_13a.docod = 4))) ldis,
                        (select ubig_01.locnom
                          from sngc13 gc_13,
                               fst070 ubig_01
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.sngc13prov = ubig_01.loccod
                             and gc_13.docod = 4
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                         and gc_13a.docod = 4))) lciu,
                        (select ubig_01.depnom
                          from sngc13 gc_13,
                               fst068 ubig_01
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.sngc13dpto = ubig_01.depcod
                             and gc_13.docod = 4
                             and rownum = 1
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                         and gc_13a.docod = 4))) ldep,
                        (select upper(gc_13.sngc13ref1)
                          from sngc13 gc_13,
                               fst071 ubig_01
                           where gc_13.sngc13pais = Dia_0.jaql831acodpai
                             and gc_13.sngc13tdoc = Dia_0.jaql831atipdoc
                             and gc_13.sngc13ndoc = Dia_0.jaql831anumdoc
                             and gc_13.sngc13dist = ubig_01.fst071col
                             and gc_13.docod = 4
                             and gc_13.sngc13corr = ((select max(gc_13a.sngc13corr)
                                                        from sngc13 gc_13a
                                                       where gc_13a.sngc13pais = Dia_0.jaql831acodpai
                                                         and gc_13a.sngc13tdoc = Dia_0.jaql831atipdoc
                                                         and gc_13a.sngc13ndoc = Dia_0.jaql831anumdoc
                                                         and gc_13a.docod = 4))) lref,';

  ls_Cad003 := 'PQ_CC_CONSULTAS_BT.BT_Tel_Cli(Dia_0.jaql831acodpai,Dia_0.jaql831atipdoc,Dia_0.jaql831anumdoc,1) tdom,
                       PQ_CC_CONSULTAS_BT.BT_Tel_Cli(Dia_0.jaql831acodpai,Dia_0.jaql831atipdoc,Dia_0.jaql831anumdoc,4) tlab,
                       PQ_CC_CONSULTAS_BT.BT_Cel_Cli(Dia_0.jaql831acodpai,Dia_0.jaql831atipdoc,Dia_0.jaql831anumdoc) tcel,
                       PQ_CC_CONSULTAS_BT.BT_Mail_Cli(Dia_0.jaql831acodEmp,Dia_0.jaql831aCuenta) mail,
                       (select d_001.penom
                          from fsr002 r_002,
                               fsd001 d_001
                         where r_002.rppais = d_001.pepais
                           and r_002.rptdoc = d_001.petdoc
                           and r_002.rpndoc = d_001.pendoc
                           and r_002.pepais = Dia_0.jaql831acodpai
                           and r_002.petdoc = Dia_0.jaql831atipdoc
                           and r_002.pendoc = Dia_0.jaql831anumdoc
                           and r_002.rpccyg = 66
                           and rownum = 1) nre1,
                        ''Cónyuge'' tre1,
                        PQ_CC_CONSULTAS_BT.BT_FonCli((select r_002.rppais
                                                         from fsr002 r_002
                                                        where r_002.pepais = Dia_0.jaql831acodpai
                                                          and r_002.petdoc = Dia_0.jaql831atipdoc
                                                          and r_002.pendoc = Dia_0.jaql831anumdoc
                                                          and r_002.rpccyg = 66
                                                          and rownum = 1),
                                                      (select r_002.rptdoc
                                                         from fsr002 r_002
                                                        where r_002.pepais = Dia_0.jaql831acodpai
                                                          and r_002.petdoc = Dia_0.jaql831atipdoc
                                                          and r_002.pendoc = Dia_0.jaql831anumdoc
                                                          and r_002.rpccyg = 66
                                                          and rownum = 1),
                                                      (select r_002.rpndoc
                                                         from fsr002 r_002
                                                         where r_002.pepais = Dia_0.jaql831acodpai
                                                           and r_002.petdoc = Dia_0.jaql831atipdoc
                                                           and r_002.pendoc = Dia_0.jaql831anumdoc
                                                           and r_002.rpccyg = 66
                                                           and rownum = 1)) ter1,
                        (select d_008.ctnom
                           from fsr011 r_011,fsd008 d_008
                          where r_011.r1cod = Dia_0.jaql831aCodEmp
                            and r_011.r1mod = Dia_0.jaql831aCodMod
                            and r_011.r1suc = Dia_0.jaql831aCodAge
                            and r_011.r1mda = Dia_0.jaql831aMoneda
                            and r_011.r1pap = 0
                            and r_011.r1cta = Dia_0.jaql831acuenta
                            and r_011.r1oper = Dia_0.jaql831aoperac
                            and r_011.relcod = 50
                            and r_011.r2tope = 91
                            and r_011.r2mod = 70
                            and r_011.r011co = ''S''
                            and r_011.r1cod = d_008.pgcod
                            and r_011.r2cta = d_008.ctnro
                            and rownum = 1) nre2,''Aval   '' tre2,
                        PQ_CC_CONSULTAS_BT.BT_FonCli((select r_008.pepais
                                                         from fsr011 r_011,fsr008 r_008
                                                        where r_011.r1cod = Dia_0.jaql831aCodEmp
                                                         and r_011.r1mod = Dia_0.jaql831aCodMod
                                                          and r_011.r1suc = Dia_0.jaql831aCodAge
                                                          and r_011.r1mda = Dia_0.jaql831aMoneda
                                                          and r_011.r1pap = 0
                                                          and r_011.r1cta = Dia_0.jaql831acuenta
                                                          and r_011.r1oper = Dia_0.jaql831aoperac
                                                          and r_011.relcod = 50
                                                          and r_011.r2tope = 91
                                                          and r_011.r2mod = 70
                                                          and r_011.r011co = ''S''
                                                          and r_011.r1cod = r_008.pgcod
                                                          and r_011.r2cta = r_008.ctnro
                                                          and rownum = 1),
                                                      (select r_008.petdoc
                                                         from fsr011 r_011,fsr008 r_008
                                                        where r_011.r1cod = Dia_0.jaql831aCodEmp
                                                          and r_011.r1mod = Dia_0.jaql831aCodMod
                                                          and r_011.r1suc = Dia_0.jaql831aCodAge
                                                          and r_011.r1mda = Dia_0.jaql831aMoneda
                                                          and r_011.r1pap = 0
                                                          and r_011.r1cta = Dia_0.jaql831acuenta
                                                         and r_011.r1oper = Dia_0.jaql831aoperac
                                                          and r_011.relcod = 50
                                                          and r_011.r2tope = 91
                                                          and r_011.r2mod = 70
                                                          and r_011.r011co = ''S''
                                                          and r_011.r1cod = r_008.pgcod
                                                          and r_011.r2cta = r_008.ctnro
                                                          and rownum = 1),
                                                      (select r_008.pendoc
                                                         from fsr011 r_011,fsr008 r_008
                                                        where r_011.r1cod = Dia_0.jaql831aCodEmp
                                                          and r_011.r1mod = Dia_0.jaql831acodmod
                                                          and r_011.r1suc = Dia_0.jaql831aCodAge
                                                          and r_011.r1mda = Dia_0.jaql831aMoneda
                                                          and r_011.r1pap = 0
                                                          and r_011.r1cta = Dia_0.jaql831acuenta
                                                          and r_011.r1oper = Dia_0.jaql831aoperac
                                                          and r_011.relcod = 50
                                                          and r_011.r2tope = 91
                                                          and r_011.r2mod = 70
                                                          and r_011.r011co = ''S''
                                                          and r_011.r1cod = r_008.pgcod
                                                          and r_011.r2cta = r_008.ctnro
                                                          and rownum = 1)) ter2,
                        (select decode(y_490s.jaqy490sob,''0'',''N'',
                                decode(y_490s.jaqy490sob,''1'',''S'',''X''))
                           from jaqy490s y_490s
                          where y_490s.jaqy490pai = Dia_0.jaql831acodpai
                            and y_490s.jaqy490tdo = Dia_0.jaql831atipdoc
                            and y_490s.jaqy490ndo = Dia_0.jaql831anumdoc
                            and y_490s.jaqy490fec = to_date(''' ||
              to_char(ld_SobEnd, 'yyyy.mm.dd') ||
               ''',''yyyy.mm.dd'')) send,
                        (select y_067.jaqy067ncal
                           from jaqy067 y_067
                          where y_067.jaqy067ccal = (select max(y_066.jaqy066calf)
                                                       from jaqy066 y_066
                                                      where y_066.jaqy066pano = ' ||
               to_number(ls_AnoCie, '9999') || '
                                                        and y_066.jaqy066pmes = ' ||
               to_number(ls_MesCie, '99') || '
                                                        and y_066.jaqy066paic = Dia_0.jaql831acodpai
                                                        and y_066.jaqy066tdoc = Dia_0.jaql831atipdoc
                                                        and y_066.jaqy066tndoc = Dia_0.jaql831anumdoc)) tcli,
                        PQ_CC_CONSULTAS_BT.BT_CalCli(Dia_0.jaql831acuenta, to_date(''' ||
               ls_FecCie ||
               ''',''yyyy.mm.dd'')) cali,
                        Dia_0.jaql831aCodSbs csbs,
                        (select nvl(count(*),0)
                           from fsd601 d_601
                          where d_601.pgcod  = 1
                            and d_601.ppmod  = Dia_0.jaql831aCodMod
                            and d_601.ppsuc  = Dia_0.jaql831acodage
                            and d_601.ppmda  = Dia_0.jaql831amoneda
                            and d_601.pppap  = 0
                            and d_601.ppcta  = Dia_0.jaql831aCuenta
                            and d_601.ppoper = Dia_0.jaql831aOperac
                            and d_601.ppsbop = Dia_0.jaql831aSubTip
                            and d_601.pptope = Dia_0.jaql831aCodTip
                            and d_601.pptipo <> ''K'') cpac,
                        (select nvl(count(*),0)
                           from fsd601 d_601,
                                fsd602 d_602
                          where d_601.pgcod  = 1
                            and d_601.ppmod  = Dia_0.jaql831aCodMod
                            and d_601.ppsuc  = Dia_0.jaql831acodage
                            and d_601.ppmda  = Dia_0.jaql831amoneda
                            and d_601.pppap  = 0
                            and d_601.ppcta  = Dia_0.jaql831aCuenta
                            and d_601.ppoper = Dia_0.jaql831aOperac
                            and d_601.ppsbop = Dia_0.jaql831aSubTip
                            and d_601.pptope = Dia_0.jaql831aCodTip
                            and d_601.pptipo <> ''K''
                            and d_601.pgcod  = d_602.pgcod
                            and d_601.ppmod  = d_602.ppmod
                            and d_601.ppsuc  = d_602.ppsuc
                            and d_601.ppmda  = d_602.ppmda
                            and d_601.pppap  = d_602.pppap
                            and d_601.ppcta  = d_602.ppcta
                            and d_601.ppoper = d_602.ppoper
                            and d_601.ppsbop = d_602.ppsbop
                            and d_601.pptope = d_602.pptope
                            and d_601.ppfpag = d_602.ppfpag
                            and d_602.d602mo not in (116)
                            and d_602.d602tr not in (508)
                            and d_602.pp1stat = ''T''
                            and d_602.d602co  = ''S'') cpag,
                        '' '' fcma,'' '' flsf,Dia_0.jaql831acodmod modu,dia_0.jaql831acodage cage,Dia_0.jaql831aEstado esta,
                        (select t_026.cenom
                           from fst026 t_026
                          where t_026.cecod = Dia_0.jaql831aestado) dest,''N'' repo,0 matr,Dia_0.jaql831aFacMor fmor,0 orde,
                        Dia_0.jaql831aFecCie fcie,Dia_0.jaql831aMoneda cmon,Dia_0.jaql831aSubtip stip,Dia_0.jaql831aCodTip tipo,
                        PQ_CC_CONSULTAS_BT.BT_Deuda_Cuota(1,Dia_0.jaql831aCodMod,Dia_0.jaql831aCodAge,Dia_0.jaql831aMoneda,0,
                                      Dia_0.jaql831aCuenta,Dia_0.jaql831aOperac,Dia_0.jaql831aSubtip,Dia_0.jaql831aCodTip) stcu,
                       0 nseg,0 mseg,0 sseg,Dia_0.jaql831aCodRes cres,'' '' nage,'' '' ares,'' ''cori,0,Dia_0.jaql831aTipDoc,Dia_0.jaql831acodpai
                   from jaql831a Dia_0
                   where Dia_0.jaql831aCodMod not in (107, 108)
                     and Dia_0.jaql831aDiaAtr between -5 and 30
                     --and Dia_0.jaql831aDiaAtr <> 0
                     and not exists (select 1
                                       from FSD008 f_008
                                      where f_008.pgcod = 1
                                        and f_008.ctnro = Dia_0.jaql831acuenta
                                        and f_008.ctempl = ''S'')
                     and exists (select 1
                                   from fsr005 r_005
                                  where r_005.pepais = Dia_0.jaql831acodpai
                                    and r_005.petdoc = Dia_0.jaql831atipdoc
                                    and r_005.pendoc = Dia_0.jaql831anumdoc
                                    and length(trim(r_005.dotelfp)) = 9)';

  --DBMS_OUTPUT.PUT_LINE(ls_Cad001);
  execute immediate ls_Cad001 || ls_Cad002 || ls_Cad003;
  commit;

  -------> Preparar la Data
  ls_Cad001 := 'delete jaql831D where jaql831DDAUP < 1 and jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  -- 1.- Saldo de Seguro
  ls_Cad001 := 'update jaql831D Dia_0
                     set Dia_0.jaql831dsseg = nvl((select nvl(sum(d_611.ppimp11 + d_611.ppimp12 + d_611.ppimp13 + d_611.ppimp14 + d_611.ppimp15),0)
                                                    from fsd611 d_611
                                                   where d_611.pgcod = 1
                                                     and d_611.ppmod = Dia_0.jaql831dModu
                                                     and d_611.ppsuc = Dia_0.jaql831dCAge
                                                     and d_611.ppmda = Dia_0.jaql831dCMon
                                                     and d_611.pppap = 0
                                                     and d_611.ppcta = Dia_0.jaql831dNCta
                                                     and d_611.ppoper = Dia_0.jaql831dNOpe
                                                     and d_611.ppsbop = Dia_0.jaql831dStip
                                                     and d_611.pptope = Dia_0.jaql831dTipo
                                                     and d_611.ppfpag = Dia_0.jaql831dFVen),0) - nvl((select nvl(sum(d_612.pp1imp11 + d_612.pp1imp12 + d_612.pp1imp13 + d_612.pp1imp14 + d_612.pp1imp15),0)
                                                    from fsd612 d_612
                                                   where d_612.pgcod = 1
                                                     and d_612.ppmod = Dia_0.jaql831dModu
                                                     and d_612.ppsuc = Dia_0.jaql831dCAge
                                                     and d_612.ppmda = Dia_0.jaql831dCMon
                                                     and d_612.pppap = 0
                                                     and d_612.ppcta = Dia_0.jaql831dNCta
                                                     and d_612.ppoper = Dia_0.jaql831dNOpe
                                                     and d_612.ppsbop = Dia_0.jaql831dStip
                                                     and d_612.pptope = Dia_0.jaql831dTipo
                                                     and d_612.ppfpag = Dia_0.jaql831dFVen),0)
                  where Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  -- 2.- Nro de Seguros
  ls_Cad001 := 'update jaql831d Dia_0
                     set Dia_0.jaql831dnseg = (select nvl(count(*),0)
                                                from fpp001 p_001
                                               where p_001.pgcod  = 1
                                                 and p_001.aomod  = Dia_0.jaql831dModu
                                                 and p_001.aosuc  = Dia_0.jaql831dCAge
                                                 and p_001.aopap  = 0
                                                and p_001.aomda  = Dia_0.jaql831dCMon
                                                 and p_001.aosbop = Dia_0.jaql831dStip
                                                 and p_001.aotope = Dia_0.jaql831dTipo
                                                 and p_001.aocta = Dia_0.jaql831dNCta
                                                 and p_001.aooper = Dia_0.jaql831dNOpe
                                                 and p_001.pp001imp > 0
                                                 and Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999') || ')
                  where Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  -- 3.- Monto Seguros
  ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831dmseg = (select nvl(sum(p_001.pp001imp),0)
                                                from fpp001 p_001
                                               where p_001.pgcod  = 1
                                                and p_001.aomod  = Dia_0.jaql831dModu
                                                 and p_001.aosuc  = Dia_0.jaql831dCAge
                                                 and p_001.aopap  = 0
                                                 and p_001.aomda  = Dia_0.jaql831dCMon
                                                 and p_001.aosbop = Dia_0.jaql831dSTip
                                                 and p_001.aotope = Dia_0.jaql831dTipo
                                                 and p_001.aocta = Dia_0.jaql831dNCta
                                                 and p_001.aooper = Dia_0.jaql831dNOpe
                                                 and p_001.pp001imp > 0
                                                 and Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999') || ')
                  where Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  -- 4.- Saldo de Deuda a Pagar
  ls_Cad001 := 'update jaql831d Dia_0
                     set Dia_0.jaql831dmptm = nvl(Dia_0.jaql831dstcu,0) + nvl(Dia_0.jaql831dsmor,0) + nvl(Dia_0.jaql831dsseg,0)
                  where Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  -- 5.- Eliminar registros con saldos menores
  ls_Cad001 := 'delete jaql831d Dia_0
                   where nvl(Dia_0.jaql831dmptm,0) < 3 and nvl(Dia_0.jaql831dmptm,0) <> 0
                     and Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'delete jaql831d Dia_0
                   where nvl(Dia_0.jaql831dmcuo,0) <= 5
                     and Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'delete jaql831d Dia_0
                   where nvl(jaql831dsacc,0) <= 0
                     and Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  -- 6 .- Agencia y Analista Responsable
  ls_Cad001 := 'update jaql831d x1 /*+ALL_ROWS PARALLEL(x1,6)*/
                     set x1.jaql831dcres = fn_analista_credito(x1.jaql831dmodu, x1.jaql831dcage, x1.jaql831dcmon,0,x1.jaql831dncta,x1.jaql831dnope,x1.jaql831dstip,x1.jaql831dtipo)
                  where x1.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d x1 /*+ALL_ROWS PARALLEL(x1,6)*/
                     set x1.jaql831dnage = (select x4.scnom
                                              from fst001 x4
                                             where x4.pgcod = 1
                                               and x1.jaql831dcage = x4.sucurs)
                  where x1.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d x1 /*+ALL_ROWS PARALLEL(x1,6)*/
                     set x1.jaql831dares = (select t_746.ubnom
                                              from fst746 t_746
                                             where t_746.ubuser = x1.jaql831dcres)
                  where x1.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  ---> Actualizar Flag del RCC
  -----------------------------
  ls_Cad001 := 'update jaql831d Dia_0 /*+ALL_ROWS PARALLEL(Dia_0,6)*/
                     set Dia_0.jaql831dflsf = (select ''S''
                                                 from cldrccs rcc
                                                 where rcc.d_fecpre = to_date(''' ||
               ls_FecRcc || ''',''yyyy.mm.dd'')
                                                   and rcc.c_codsbs = Dia_0.jaql831dCSbs
                                                   and rcc.c_codemp <> ''00104''
                                                   and rcc.c_calvig in (''1'',''2'',''3'',''4'')
                                                   and rownum = 1)
                  where Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d Dia_0 /*+ALL_ROWS PARALLEL(Dia_0,6)*/
                     set Dia_0.jaql831dfcma = (select ''S''
                                              from cldrccs rcc
                                             where rcc.d_fecpre = to_date(''' ||
               ls_FecRcc || ''',''yyyy.mm.dd'')
                                               and rcc.c_codsbs = Dia_0.jaql831dCSbs
                                               and rcc.c_codemp = ''00104''
                                               and rcc.c_calvig = ''0''
                                               and rownum = 1)
                  where Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d Dia_0 /*+ALL_ROWS PARALLEL(Dia_0,6)*/
                     set Dia_0.jaql831drepo = ''N''
                  where Dia_0.jaql831cpro = ' ||
               to_char(ln_CodPro, '999999999');
  execute immediate ls_Cad001;
  commit;

  ---> Paso 6
  ---> Paso 6.1: Insertar Créditos con días de atraso mayor a cero

  ls_Cad001 := 'truncate table jaql831e';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831ddmor > 0
                         and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d
                    set jaql831drepo = ''S''
                  where jaql831ddmor > 0
                    and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831dsend in (''S'', ''E'')
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831drepo = ''S''
                  where Dia_0.jaql831dsend in (''S'', ''E'')
                    and Dia_0.jaql831drepo = ''N''
                    and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831desta <> 0
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831drepo = ''S''
                  where Dia_0.jaql831desta <> 0
                    and Dia_0.jaql831drepo = ''N''
                    and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831dflsf = ''S''
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831drepo = ''S''
                  where Dia_0.jaql831dflsf = ''S''
                   and Dia_0.jaql831drepo = ''N''
                    and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831dfcma = ''S''
                         and Dia_0.jaql831ddaup > 0
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831drepo = ''S''
                  where Dia_0.jaql831dfcma = ''S''
                    and Dia_0.jaql831ddaup > 0
                    and Dia_0.jaql831drepo = ''N''
                    and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831ddaup > 0
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d Dia_0
                     set Dia_0.jaql831drepo = ''S''
                   where Dia_0.jaql831ddaup > 0
                     and Dia_0.jaql831drepo = ''N''
                     and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'delete jaql831d Dia_0
                   where Dia_0.jaql831drepo = ''N''
                     and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d
                    set jaql831dctra = ''''
                  where jaql831dctra = '' RUC ''
                    and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d
                     set jaql831dtre1 = null
                   where jaql831dnre1 is null
                     and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d
                     set jaql831dtre2 = null
                   where jaql831dnre2 is null
                     and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'declare
                     cursor c_dat is select jaql831dndoc,jaql831ddmor
                                       from jaql831d
                                      where jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999')) || '
                                   order by jaql831ddmor desc;
                     pn_cnt number;
                  begin
                     pn_cnt := 1;
                     for c_det in c_dat
                     loop
                        update jaql831d Dia_0
                           set jaql831dorde = pn_cnt
                         where Dia_0.jaql831dndoc = c_det.jaql831dndoc
                           and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999')) || ';
                        pn_cnt := pn_cnt + 1;
                     end loop;
                     commit;
                  end;';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'declare
                     cursor c_dat is select jaql831dndoc,jaql831ddmor,jaql831dmatr
                                      from jaql831d
                                     where jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999')) || ';
                     pn_max_atr number;
                  begin

                     for c_det in c_dat
                     loop
                        select max(Dia_0.jaql831ddmor)
                          into pn_max_atr
                          from jaql831d Dia_0
                          where Dia_0.jaql831dndoc = c_det.jaql831dndoc
                           and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999')) || ';
                        update jaql831d Dia_0
                           set Dia_0.jaql831dmatr = pn_max_atr
                         where Dia_0.jaql831dndoc = c_det.jaql831dndoc
                           and Dia_0.jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999')) || ';
                        commit;
                     end loop;
                  end;';
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d
                     set jaql831drmor = ''Administrativa''
                   where jaql831ddmor > 0
                     and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  -- se cambia jaql831dmatr por jaql831ddmor 120919
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d
                     set jaql831drmor = ''VenceHoy''
                   where jaql831ddmor = 0
                     and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  -- se cambia jaql831dmatr por jaql831ddmor 120919
  execute immediate ls_Cad001;
  commit;

  ls_Cad001 := 'update jaql831d
                     set jaql831drmor = ''Preventiva''
                   where jaql831ddmor < 0
                     and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  -- se cambia jaql831dmatr por jaql831ddmor 120919
  execute immediate ls_Cad001;
  commit;

  update jaql831d set jaql831dcori = 'CMAC-AQP';
  commit;

  ls_Cad001 := 'update jaql831
                    set jaql831hfin = to_char(sysdate,''HH24:MI:SS''),
                        jaql831nreg = (select count(*) from jaql831e),
                        jaql831ffin = to_date(''' ||
               ls_FecPro || ''',''yyyy.mm.dd'')
                  where jaql831tpro = 1
                    and jaql831cpro = ' ||
               trim(to_char(ln_CodPro, '999999999'));
  execute immediate ls_Cad001;
  commit;

  insert into jaql831d_aux
    select *
      from jaql831d a
     where a.jaql831cpro in
           (select max(jaql831cpro) from jaql831 r where r.jaql831tpro = 1)
       and a.jaql831ddmor not in (-5, -4, -3, 1)
       and a.jaql831dsacc >= 100
       and a.jaql831dnope not in
           (select b.jaql831dnope
              from jaql831d b
            where b.jaql831cpro in
                   (select max(jaql831cpro) - 1
                      from jaql831 r
                     where r.jaql831tpro = 1));

  delete from jaql831d a
   where a.jaql831cpro in
         (select max(jaql831cpro) from jaql831 r where r.jaql831tpro = 1); -- no se puede determinar la cantidad de registros

  delete from jaql831
   where jaql831tpro = 1
     and JAQL831CPRO in
         (select max(jaql831cpro) from jaql831 r where r.jaql831tpro = 1); -- no se puede determinar la cantidad de registros
  commit;

  sys.sp_sy_enviamail(PC_DE      => 'pilotocall@cajaarequipa.pe',
                      PC_AQUIEN  => 'lcarpio@cajaarequipa.pe',
                      PC_MOTIVO  => 'Data Piloto Call Center',
                      PC_MENSAJE => 'BD=' ||
                                    sys_context('USERENV', 'DB_NAME') ||
                                    CHR(13) || 'INSTANCIA=' ||
                                    sys_context('USERENV', 'INSTANCE_NAME') ||
                                    CHR(13) || 'Hora Actual en Servidor : ' ||
                                    to_char(sysdate, 'HH24:MI:SS') ||
                                    CHR(13) || CHR(13));
  sys.sp_sy_enviamail(PC_DE      => 'pilotocall@cajaarequipa.pe',
                      PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                      PC_MOTIVO  => 'Data Piloto Call Center',
                      PC_MENSAJE => 'BD=' ||
                                    sys_context('USERENV', 'DB_NAME') ||
                                    CHR(13) || 'INSTANCIA=' ||
                                    sys_context('USERENV', 'INSTANCE_NAME') ||
                                    CHR(13) || 'Hora Actual en Servidor : ' ||
                                    to_char(sysdate, 'HH24:MI:SS') ||
                                    CHR(13) || CHR(13));

end;
/

