create or replace package PQ_CC_CONSULTAS_BT is

   procedure SP_GenDatSem(pd_FecPro in date,pn_CodPro out number);
   
   function BT_Factor_Mora(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                        pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                        pn_Operac in number,pn_SubTip in number,pn_CodTip in number) 
   return number;
   
   function BT_TEA_Credito(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                        pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                        pn_Operac in number,pn_SubTip in number,pn_CodTip in number)
   return number;
   
   function BT_Fec_Desemb(pn_Cuenta in number,pn_Operac in number)
   return date;
   
   function BT_CuotaVence(pn_Cuenta in number,pn_Operac in number,pn_CodTip in number,
                       pn_SubTip in number,pn_CodMod in number,pn_CodSuc in number,
                       pn_Moneda in number,pd_FecPro in date)
   return date;
   
   function BT_Deuda_Mora(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                        pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                        pn_Operac in number,pn_SubTip in number,pn_CodTip in number,
                        pn_Factor in number,pn_DiaAtr in number)
   return number;
   
   function BT_Deuda_Capital(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                       pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                       pn_Operac in number,pn_SubTip in number,pn_CodTip in number)
   return number;
   
   function BT_Mto_Cuota(pn_Cuenta in number,pn_Operac in number,pn_CodTip in number,
                       pn_SubTip in number,pn_CodMod in number,pn_CodSuc in number,
                       pn_Moneda in number)
   return number;
   
   function BT_FonCli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2)
   return varchar2;
   
   function BT_Tel_Cli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2,pn_TipTel in number)
   return varchar2;
   
   function BT_Cel_Cli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2)
   return varchar2;
   
   function BT_Mail_Cli(pn_CodEmp in number,pn_Cuenta in number)
   return varchar2;
   
   function BT_Deuda_Cuota(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                       pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                       pn_Operac in number,pn_SubTip in number,pn_CodTip in number)
   return number;
   
   function BT_CalCli(pn_Cuenta in number,pd_FecPro in date)
   return varchar2;
   
   procedure SP_GenPagDia(pd_FecPro in date,pd_FecPag in date,pn_CodPro out number);
   
   procedure SP_MaxNumPro(pc_TipPro in varchar2,pn_CodPro out number);
   
   procedure SP_SalCre(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                   pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                   pn_Operac in number,pn_SubTip in number,pn_CodTip in number,
                   pn_SalCap out number);
                   
   procedure SP_ActRes(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                   pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                   pn_Operac in number,pn_SubTip in number,pn_CodTip in number,
                   ps_FecRea in varchar2,ps_HorRea in varchar2,ps_DetRea in varchar2,
                   pn_CodRea in number,pn_MotRea in number,ps_FecCom in varchar2); 
end PQ_CC_CONSULTAS_BT;
/

create or replace package body PQ_CC_CONSULTAS_BT is

procedure SP_GenDatSem(pd_FecPro in date,pn_CodPro out number) is

---> OJO - Sistema NO pregunta - Elimina Información - OJO
----------------------------------------------------------


   ls_Cad001 varchar2(32000);
   ls_Cad002 varchar2(32000);
   ls_Cad003 varchar2(32000);
   ls_FecCie varchar2(10);
   ls_FecPro varchar2(10);
   ls_FecRcc varchar2(10);
   ls_FecEnd varchar2(10);
   ls_IndFec varchar2(8);
   ls_AnoCie varchar2(4);
   ls_MesCie varchar2(2);
   ln_NumReg number;
   ln_CodPro number;
   ld_FecCie date;
   ld_SobEnd date;

begin

   ls_Cad001 := 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
   execute immediate ls_Cad001;

   ls_Cad001 := 'ALTER SESSION SET NLS_TERRITORY=''SPAIN''';
   execute immediate ls_Cad001;

   ld_FecCie := Trunc(sysdate) - to_number(to_char(trunc(sysdate),'d'));                     -- Último domingo
   --ld_FecCie := to_date('2017.07.30','yyyy.mm.dd');
   --ld_FecCie := to_date('2019.11.30','yyyy.mm.dd');
   ls_IndFec := to_char(ld_FecCie,'yyyymmdd');

   ls_FecCie:= to_char(Trunc(ld_feccie) - to_char(Trunc(ld_feccie),'DD'),'yyyy.mm.dd');           -- Fecha de Cierre de Mes

   ls_AnoCie := substr(ls_FecCie,1,4);
   ls_MesCie  := substr(ls_FecCie,6,2);

   ls_FecPro := to_char(Trunc(sysdate),'yyyy.mm.dd');         -- Fecha de Proceso (Sistema)

   select to_char(max(d_fecpre),'yyyy.mm.dd')
     into ls_FecRcc
     from cldrcci;
   ls_Cad001 := 'select max(y_490s.jaqy490fec) from jaqy490s y_490s';
   execute immediate ls_Cad001 into ld_SobEnd;                  -- Fecha del Sobreendeudamiento
   ls_FecEnd := to_char(ld_SobEnd,'yyyy.mm.dd');

   select nvl(max(jaql831cpro),0) into ln_CodPro from jaql831 where jaql831tpro = 1;
   ln_CodPro := ln_CodPro + 1;
   pn_CodPro := ln_CodPro;
   ls_Cad001 := 'insert into jaql831
                (jaql831cpro,jaql831fpro,jaql831tpro,jaql831hini,jaql831hfin,
                 jaql831nreg,jaql831obse,jaql831fsis,jaql831frcc,jaql831ffin) 
                 values
                (' || to_char(ln_CodPro,'999999999') || ',to_date(''' || to_char(ld_FecCie,'yyyy.mm.dd') || ''',''yyyy.mm.dd''),
                 1,to_char(sysdate,''HH24:MI:SS''),to_char(sysdate,''HH24:MI:SS''),0,''Genera Data Total'',
                 to_date(''' || ls_FecPro || ''',''yyyy.mm.dd''),to_date(''' || ls_FecRcc  || ''',''yyyy.mm.dd''),
                 to_date(''' || ls_FecEnd  || ''',''yyyy.mm.dd''))';
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'truncate table JAQL831A';
   execute immediate ls_Cad001;
   commit;

---> Genera Data
   ls_Cad001 := 'insert into jaql831A 
                 select /*+index(h_012 FSH01210) index(d_010 SYS_C003198774)*/
                        h_012.bcemp,d_010.aomod,d_010.aocta,d_010.aooper,d_010.aotope,d_010.aosbop,
                        d_010.aomda,d_010.aoimp,PQ_CC_CONSULTAS_BT.BT_Fec_Desemb(d_010.aocta,d_010.aooper),
                        PQ_CC_CONSULTAS_BT.BT_TEA_Credito(d_010.pgcod,d_010.aomod,d_010.aosuc,d_010.aomda,d_010.aopap,
                                                          d_010.aocta,d_010.aooper,d_010.aosbop,d_010.aotope),
                        d_010.aosuc,h_012.bcrubr,''00000000000000'',abs(h_012.bcsdmo),abs(h_012.bcsdmn),
                        ''xxxxxxxxxx'',99999,to_date(''1990.01.01'',''yyyy.mm.dd''),d_010.aostat,
                        0,0,'' '','' '',
                        round(PQ_CC_CONSULTAS_BT.BT_Factor_Mora(d_010.pgcod,d_010.aomod,d_010.aosuc,d_010.aomda,d_010.aopap,
                                                                d_010.aocta,d_010.aooper,d_010.aosbop,d_010.aotope),4),
                        to_date(''' || to_char(ld_FecCie,'yyyy.mm.dd') || ''',''yyyy.mm.dd'')' || ',
                        '' '','' ''
                   from fsh012 h_012,
                        fsd010 d_010
                  where h_012.bcemp = d_010.pgcod
                    and h_012.bcfech = to_date(''' || to_char(ld_FecCie,'yyyy.mm.dd') || ''',''yyyy.mm.dd'')
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
                    and h_012.bcsdmo <> 0
                 union all
                 select /*+index(h_012 FSH01210) index(d_010 SYS_C003198774)*/
                        h_012.bcemp,d_010.aomod,d_010.aocta,d_010.aooper,d_010.aotope,d_010.aosbop,
                        d_010.aomda,d_010.aoimp,PQ_CC_CONSULTAS_BT.BT_Fec_Desemb(d_010.aocta,d_010.aooper),
                        PQ_CC_CONSULTAS_BT.BT_TEA_Credito(d_010.pgcod,d_010.aomod,d_010.aosuc,d_010.aomda,d_010.aopap,
                                                          d_010.aocta,d_010.aooper,d_010.aosbop,d_010.aotope),
                        d_010.aosuc,h_012.bcrubr,''00000000000000'',abs(h_012.bcsdmo),abs(h_012.bcsdmn),
                        ''xxxxxxxxxx'',99999,to_date(''1990.01.01'',''yyyy.mm.dd''),d_010.aostat,
                        0,0,'' '','' '',
                        round(PQ_CC_CONSULTAS_BT.BT_Factor_Mora(d_010.pgcod,d_010.aomod,d_010.aosuc,d_010.aomda,d_010.aopap,
                                                                d_010.aocta,d_010.aooper,d_010.aosbop,d_010.aotope),4),
                        to_date(''' || to_char(ld_FecCie,'yyyy.mm.dd') || ''',''yyyy.mm.dd'')' || ',
                        '' '',''2''
                   from fsh012 h_012,fsd010 d_010,jaql831t t_831
                  where t_831.jaql831tncta = d_010.aocta
                    and t_831.jaql831tnope = d_010.aooper
                    and t_831.jaql831tcest = ''0''
                    and h_012.bcemp = d_010.pgcod
                    and h_012.bcfech = to_date(''' || to_char(ld_FecCie,'yyyy.mm.dd') || ''',''yyyy.mm.dd'')
                    and h_012.bcmod = d_010.aomod
                    and h_012.bcsuc = d_010.aosuc
                    and h_012.bcmda = d_010.aomda
                    and h_012.bcpap = d_010.aopap
                    and h_012.bccta = d_010.aocta
                    and h_012.bcoper = d_010.aooper
                    and h_012.bcsbop = d_010.aosbop
                    and h_012.bctop = d_010.aotope';
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
                    set jaql831aDiaAtr = to_date(''' || to_char(ld_FecCie,'yyyy.mm.dd') || ''',''yyyy.mm.dd'') - jaql831aVenCuo';
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
                    and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999'));
   execute immediate ls_Cad001;
   commit;

----> Fin de la Creación de la Data.

   ls_Cad001 := 'insert into jaql831d
                 select ' || trim(to_char(ln_CodPro,'999999999')) ||',Dia_0.jaql831aCuenta,Dia_0.jaql831aOperac,
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
                        (select trunc((to_date(''' || ls_FecPro || ''',''yyyy.mm.dd'') -
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
                            and y_490s.jaqy490fec = to_date(''' || to_char(ld_SobEnd,'yyyy.mm.dd') || ''',''yyyy.mm.dd'')) send,
                        (select y_067.jaqy067ncal
                           from jaqy067 y_067
                          where y_067.jaqy067ccal = (select max(y_066.jaqy066calf)
                                                       from jaqy066 y_066
                                                      where y_066.jaqy066pano = ' || to_number(ls_AnoCie,'9999') || '
                                                        and y_066.jaqy066pmes = ' || to_number(ls_MesCie,'99') || '
                                                        and y_066.jaqy066paic = Dia_0.jaql831acodpai
                                                        and y_066.jaqy066tdoc = Dia_0.jaql831atipdoc
                                                        and y_066.jaqy066tndoc = Dia_0.jaql831anumdoc)) tcli,
                        PQ_CC_CONSULTAS_BT.BT_CalCli(Dia_0.jaql831acuenta, to_date(''' || ls_FecCie  || ''',''yyyy.mm.dd'')) cali,
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
                     and Dia_0.jaql831aDiaAtr between -5 and 8
                     and Dia_0.jaql831aDiaAtr <> 0
                     and Dia_0.jaql831aorigen <> ''2''
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
   
-- Inserta Nuevos Creditos Riesgos
   ls_Cad001 := 'insert into jaql831d
                 select ' || trim(to_char(ln_CodPro,'999999999')) ||',Dia_0.jaql831aCuenta,Dia_0.jaql831aOperac,
                        (select trim(r_008.pendoc)
                           from fsr008 r_008
                          where Dia_0.jaql831aCuenta = r_008.ctnro
                            and r_008.cttfir = ''T''),''2'',
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
                        (select trunc((to_date(''' || ls_FecPro || ''',''yyyy.mm.dd'') -
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
                            and y_490s.jaqy490fec = to_date(''' || to_char(ld_SobEnd,'yyyy.mm.dd') || ''',''yyyy.mm.dd'')) send,
                        (select y_067.jaqy067ncal
                           from jaqy067 y_067
                          where y_067.jaqy067ccal = (select max(y_066.jaqy066calf)
                                                       from jaqy066 y_066
                                                      where y_066.jaqy066pano = ' || to_number(ls_AnoCie,'9999') || '
                                                        and y_066.jaqy066pmes = ' || to_number(ls_MesCie,'99') || '
                                                        and y_066.jaqy066paic = Dia_0.jaql831acodpai
                                                        and y_066.jaqy066tdoc = Dia_0.jaql831atipdoc
                                                        and y_066.jaqy066tndoc = Dia_0.jaql831anumdoc)) tcli,
                        PQ_CC_CONSULTAS_BT.BT_CalCli(Dia_0.jaql831acuenta, to_date(''' || ls_FecCie  || ''',''yyyy.mm.dd'')) cali,
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
                   where Dia_0.jaql831aCodMod = 116
                     and Dia_0.jaql831aorigen = ''2''';

   execute immediate ls_Cad001 || ls_Cad002 || ls_Cad003;
   commit;   
  
-------> Preparar la Data
   ls_Cad001 := 'delete jaql831D where jaql831DDAUP < 1 and jaql831dtarj <> ''2'' and jaql831cpro = ' || to_char(ln_CodPro,'999999999');
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
                  where Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');
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
                                                 and Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999') || ')
                  where Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');
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
                                                 and Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999') || ')
                  where Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');                                                 
   execute immediate ls_Cad001;
   commit;

-- 4.- Saldo de Deuda a Pagar
   ls_Cad001 := 'update jaql831d Dia_0
                     set Dia_0.jaql831dmptm = nvl(Dia_0.jaql831dstcu,0) + nvl(Dia_0.jaql831dsmor,0) + nvl(Dia_0.jaql831dsseg,0)
                  where Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');   
   execute immediate ls_Cad001;
   commit;

-- 5.- Eliminar registros con saldos menores
   ls_Cad001 := 'delete jaql831d Dia_0
                   where nvl(Dia_0.jaql831dmptm,0) < 3 and nvl(Dia_0.jaql831dmptm,0) <> 0
                     and jaql831dtarj <> ''2''
                     and Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999'); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'delete jaql831d Dia_0
                   where nvl(Dia_0.jaql831dmcuo,0) <= 5
                     and jaql831dtarj <> ''2''
                     and Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'delete jaql831d Dia_0
                   where nvl(jaql831dsacc,0) <= 0
                     and jaql831dtarj <> ''2''
                     and Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');
   execute immediate ls_Cad001;
   commit;

-- 6 .- Agencia y Analista Responsable
   ls_Cad001 := 'update jaql831d x1 /*+ALL_ROWS PARALLEL(x1,6)*/
                     set x1.jaql831dcres = fn_analista_credito(x1.jaql831dmodu, x1.jaql831dcage, x1.jaql831dcmon,0,x1.jaql831dncta,x1.jaql831dnope,x1.jaql831dstip,x1.jaql831dtipo)
                  where x1.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');    
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d x1 /*+ALL_ROWS PARALLEL(x1,6)*/
                     set x1.jaql831dnage = (select x4.scnom
                                              from fst001 x4
                                             where x4.pgcod = 1
                                               and x1.jaql831dcage = x4.sucurs)
                  where x1.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');                             
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d x1 /*+ALL_ROWS PARALLEL(x1,6)*/
                     set x1.jaql831dares = (select t_746.ubnom
                                              from fst746 t_746
                                             where t_746.ubuser = x1.jaql831dcres)
                  where x1.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');                         
   execute immediate ls_Cad001;
   commit;

---> Actualizar Flag del RCC
-----------------------------
   ls_Cad001 := 'update jaql831d Dia_0 /*+ALL_ROWS PARALLEL(Dia_0,6)*/
                     set Dia_0.jaql831dflsf = (select ''S''
                                                 from cldrccs rcc
                                                 where rcc.d_fecpre = to_date(''' || ls_FecRcc || ''',''yyyy.mm.dd'')
                                                   and rcc.c_codsbs = Dia_0.jaql831dCSbs
                                                   and rcc.c_codemp <> ''00104''
                                                   and rcc.c_calvig in (''1'',''2'',''3'',''4'')
                                                   and rownum = 1)
                  where Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');                               
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d Dia_0 /*+ALL_ROWS PARALLEL(Dia_0,6)*/
                     set Dia_0.jaql831dfcma = (select ''S''
                                              from cldrccs rcc
                                             where rcc.d_fecpre = to_date(''' || ls_FecRcc || ''',''yyyy.mm.dd'')
                                               and rcc.c_codsbs = Dia_0.jaql831dCSbs
                                               and rcc.c_codemp = ''00104''
                                               and rcc.c_calvig = ''0''
                                               and rownum = 1)
                  where Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');                                               
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d Dia_0 /*+ALL_ROWS PARALLEL(Dia_0,6)*/
                     set Dia_0.jaql831drepo = ''N''
                  where Dia_0.jaql831cpro = ' ||  to_char(ln_CodPro,'999999999');   
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
                         and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d
                    set jaql831drepo = ''S''
                  where jaql831ddmor > 0
                    and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831dsend in (''S'', ''E'')
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831drepo = ''S''
                  where Dia_0.jaql831dsend in (''S'', ''E'')
                    and Dia_0.jaql831drepo = ''N''
                    and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831desta <> 0
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831drepo = ''S''
                  where Dia_0.jaql831desta <> 0
                    and Dia_0.jaql831drepo = ''N''
                    and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831dflsf = ''S''
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831drepo = ''S''
                  where Dia_0.jaql831dflsf = ''S''
                    and Dia_0.jaql831drepo = ''N''
                    and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831dfcma = ''S''
                         and Dia_0.jaql831ddaup > 0
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d Dia_0
                    set Dia_0.jaql831drepo = ''S''
                  where Dia_0.jaql831dfcma = ''S''
                    and Dia_0.jaql831ddaup > 0
                    and Dia_0.jaql831drepo = ''N''
                    and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'insert into jaql831e
                      select Dia_0.*
                        from jaql831d Dia_0
                       where Dia_0.jaql831ddaup > 0
                         and Dia_0.jaql831drepo = ''N''
                         and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d Dia_0
                     set Dia_0.jaql831drepo = ''S''
                   where Dia_0.jaql831ddaup > 0
                     and Dia_0.jaql831drepo = ''N''
                     and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;
   
   ls_Cad001 := 'delete jaql831d Dia_0
                   where Dia_0.jaql831drepo = ''N''
                     and jaql831dtarj <> ''2''
                     and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')); 
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d
                    set jaql831dctra = ''''
                  where jaql831dctra = '' RUC ''
                    and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999'));
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d
                     set jaql831dtre1 = null
                   where jaql831dnre1 is null
                     and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999'));
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d
                     set jaql831dtre2 = null
                   where jaql831dnre2 is null
                     and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999'));
   execute immediate ls_Cad001;
   commit;
   
   ls_Cad001 := 'declare
                     cursor c_dat is select jaql831dndoc,jaql831ddmor 
                                       from jaql831d 
                                      where jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')) ||'
                                   order by jaql831ddmor desc;
                     pn_cnt number;
                  begin
                     pn_cnt := 1;
                     for c_det in c_dat
                     loop
                        update jaql831d Dia_0
                           set jaql831dorde = pn_cnt
                         where Dia_0.jaql831dndoc = c_det.jaql831dndoc
                           and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')) ||';
                        pn_cnt := pn_cnt + 1;
                     end loop;
                     commit;
                  end;';
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'declare
                     cursor c_dat is select jaql831dndoc,jaql831ddmor,jaql831dmatr 
                                      from jaql831d 
                                     where jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')) || ';
                     pn_max_atr number;
                  begin

                     for c_det in c_dat
                     loop
                        select max(Dia_0.jaql831ddmor)
                          into pn_max_atr
                          from jaql831d Dia_0
                          where Dia_0.jaql831dndoc = c_det.jaql831dndoc
                           and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')) || ';
                        update jaql831d Dia_0
                           set Dia_0.jaql831dmatr = pn_max_atr
                         where Dia_0.jaql831dndoc = c_det.jaql831dndoc
                           and Dia_0.jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')) || ';
                        commit;
                     end loop;
                  end;';
   execute immediate ls_Cad001;
   commit;
   
   ls_Cad001 := 'update jaql831d
                     set jaql831drmor = ''Administrativa''
                   where jaql831ddmor > 0
                     and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999'));
   -- se cambia jaql831dmatr por jaql831ddmor 120919
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'update jaql831d
                     set jaql831drmor = ''Preventiva''
                   where jaql831ddmor < 0
                     and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999'));
   -- se cambia jaql831dmatr por jaql831ddmor 120919                  
   execute immediate ls_Cad001;
   commit;
   
   update jaql831d 
      set jaql831dcori = 'CMAC-AQP';
   /*update jaql831d 
      set jaql831dcori = 'CJ-LURENP'
    where jaql831dmodu in (102,107,106,104,110,101)
      and jaql831dtipo = 250;*/
   commit;      
   
   ls_Cad001 := 'update jaql831
                    set jaql831hfin = to_char(sysdate,''HH24:MI:SS''),
                        jaql831nreg = (select count(*) from jaql831e),
                        jaql831ffin = to_date(''' || ls_FecPro || ''',''yyyy.mm.dd'')
                  where jaql831tpro = 1
                    and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999'));
   execute immediate ls_Cad001;
   commit;
   
   update jaql831t set jaql831tcest = '1' where jaql831tcest = '0';
   commit;

---> Paso 8.2
---> Generar un orden

   /*ls_Cad001 := 'declare
                     cursor c_dat is select DNI, dias_mora from jaql831e order by dias_mora desc;
                     pn_cnt number;
                  begin
                     pn_cnt := 1;
                     for c_det in c_dat
                     loop
                        update jaql831e Dia_0
                           set Dia_0.Orden = pn_cnt
                         where Dia_0.DNI = c_det.DNI;
                        pn_cnt := pn_cnt + 1;
                     end loop;
                     commit;
                  end;';
   execute immediate ls_Cad001;
   commit;*/
   /*begin
         ls_Cad001 := 'drop index jaql831ec';
         execute immediate ls_Cad001;
   exception when others then
      null;
   end;

   ls_Cad001 := 'CREATE INDEX  jaql831ec on jaql831e (NUMERO_DE_CUENTA, NUMERO_DE_CUENTA_DE_PAGO) compute statistics parallel (degree 4)';
   execute immediate ls_Cad001;*/

end SP_GenDatSem;


function BT_Factor_Mora(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                        pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                        pn_Operac in number,pn_SubTip in number,pn_CodTip in number) 
return number is

   ln_FacMor number(5,3);
   ln_TasMor fsd012.evtasa%type;
begin
   begin
      select nvl(d_012.evtasa,0)
        into ln_TasMor
        from fsd012 d_012
       where d_012.pgcod  = pn_CodEmp
         and d_012.aomod  = pn_CodMod
         and d_012.aosuc  = pn_CodAge
         and d_012.aomda  = pn_Moneda
         and d_012.aopap  = pn_CodPap
         and d_012.aocta  = pn_Cuenta
         and d_012.aooper = pn_Operac
         and d_012.aosbop = pn_SubTip
         and d_012.aotope = pn_CodTip
         and d_012.evtipo = 4
         and d_012.evcorr = (select max(d_012a.evcorr)
                               from fsd012 d_012a
                              where d_012a.pgcod  = pn_CodEmp
                                and d_012a.aomod  = pn_CodMod
                                and d_012a.aosuc  = pn_CodAge
                                and d_012a.aomda  = pn_Moneda
                                and d_012a.aopap  = pn_CodPap
                                and d_012a.aocta  = pn_Cuenta
                                and d_012a.aooper = pn_Operac
                                and d_012a.aosbop = pn_SubTip
                                and d_012a.aotope = pn_CodTip
                                and d_012a.evtipo = 4
                                and d_012a.d012co = 'S')
         and d_012.d012co = 'S';
   exception
   when no_data_found then
      ln_TasMor := -1;
   end;
   if ln_TasMor = -1 then
      begin
         select nvl(d_010.aotmor,0)
           into ln_TasMor
           from fsd010 d_010
          where d_010.pgcod  = pn_CodEmp
            and d_010.aomod  = pn_CodMod
            and d_010.aosuc  = pn_CodAge
            and d_010.aomda  = pn_Moneda
            and d_010.aopap  = pn_CodPap
            and d_010.aocta  = pn_Cuenta
            and d_010.aooper = pn_Operac
            and d_010.aosbop = pn_SubTip
            and d_010.aotope = pn_CodTip
            and d_010.aostat <> 99;
      exception
      when no_data_found then
         ln_TasMor := -1;
      end;
   end if;
   if ln_TasMor <> -1 then
      ln_FacMor := ln_TasMor / 360;
   end if;
   return ln_FacMor;
end BT_Factor_Mora;

function BT_TEA_Credito(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                        pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                        pn_Operac in number,pn_SubTip in number,pn_CodTip in number)
return number is

   ln_TasCre number(10,6);
begin
   begin
      select nvl(d_012.evtasa,0)
        into ln_TasCre
        from fsd012 d_012
       where d_012.pgcod  = pn_CodEmp
         and d_012.aomod  = pn_CodMod
         and d_012.aosuc  = pn_CodAge
         and d_012.aomda  = pn_Moneda
         and d_012.aopap  = pn_CodPap
         and d_012.aocta  = pn_Cuenta
         and d_012.aooper = pn_Operac
         and d_012.aosbop = pn_SubTip
         and d_012.aotope = pn_CodTip
         and d_012.evtipo = 3
         and d_012.evcorr = (select max(d_012a.evcorr)
                               from fsd012 d_012a
                              where d_012a.pgcod  = pn_CodEmp
                                and d_012a.aomod  = pn_CodMod
                                and d_012a.aosuc  = pn_CodAge
                                and d_012a.aomda  = pn_Moneda
                                and d_012a.aopap  = pn_CodPap
                                and d_012a.aocta  = pn_Cuenta
                                and d_012a.aooper = pn_Operac
                                and d_012a.aosbop = pn_SubTip
                                and d_012a.aotope = pn_CodTip
                                and d_012a.evtipo = 3
                                and d_012a.d012co = 'S')
         and d_012.d012co = 'S';
   exception
   when no_data_found then
      ln_TasCre := -1;
   end;
   if ln_TasCre = -1 then
      begin
         select nvl(d_010.aotasa,0)
           into ln_TasCre
           from fsd010 d_010
          where d_010.pgcod  = pn_CodEmp
            and d_010.aomod  = pn_CodMod
            and d_010.aosuc  = pn_CodAge
            and d_010.aomda  = pn_Moneda
            and d_010.aopap  = pn_CodPap
            and d_010.aocta  = pn_Cuenta
            and d_010.aooper = pn_Operac
            and d_010.aosbop = pn_SubTip
            and d_010.aotope = pn_CodTip
            and d_010.aostat <> 99;
      exception
      when no_data_found then
         ln_TasCre := -1;
      end;
   end if;
   return ln_TasCre;
end BT_TEA_Credito;

function BT_Fec_Desemb(pn_Cuenta in number,pn_Operac in number)
return date is

   ld_FecDes date := null;
begin

   begin
      select min(d_010.aofval)
        into ld_FecDes
        from fsd010 d_010
       where d_010.pgcod  = 1
         and d_010.aosuc  = (select d_010.aosuc
                               from fsd010 d_010
                              where d_010.pgcod  = 1
                                and d_010.aocta = pn_Cuenta
                                and d_010.aooper = pn_Operac
                                and d_010.aosbop = 0
                                and d_010.aomod not in (117,442,443,415,183,185,419) and rownum = 1)
         and d_010.aomda  = (select d_010.aomda
                               from fsd010 d_010
                              where d_010.pgcod  = 1
                                and d_010.aocta = pn_Cuenta
                                and d_010.aooper = pn_Operac
                                and d_010.aosbop = 0
                                and d_010.aomod not in (117,442,443,415,183,185,419) and rownum = 1)
         and d_010.aopap  = 0
         and d_010.aocta  = pn_Cuenta
         and d_010.aooper = pn_Operac
         and d_010.aosbop = 0
         and d_010.aofval <> to_date('0001.01.01','yyyy.mm.dd');
   exception
   when no_data_found then        -- Cuando no hizo ningún pago
        ld_FecDes := null;
   when others then
      dbms_output.put_line(pn_Cuenta);
      dbms_output.put_line(pn_Operac);
   end;

   return ld_FecDes;
end BT_Fec_Desemb;

function BT_CuotaVence(pn_Cuenta in number,pn_Operac in number,pn_CodTip in number,
                       pn_SubTip in number,pn_CodMod in number,pn_CodSuc in number,
                       pn_Moneda in number,pd_FecPro in date)
return date is

  ld_UltCuo  date := null;
  ld_UltCan date := null;

begin

   begin
      select max(ppfpag)
        into ld_UltCuo
        from fsd602
       where PGCOD = 1
         and ppmod   = pn_CodMod
         and ppsuc   = pn_CodSuc
         and ppmda   = pn_Moneda
         and pppap   = 0
         and ppcta   = pn_Cuenta
         and ppoper  = pn_Operac
         and ppsbop  = pn_SubTip
         and pptope  = pn_CodTip
         and pp1stat = 'T'
         and d602co  = 'S'
         and pp1fech <= pd_FecPro;
   exception
   when no_data_found then        -- Cuando no hizo ningún pago
        ld_UltCuo := null;
   end;
   if ld_UltCuo is null then
      select min(ppfpag)
        into ld_UltCan
        from fsd601
       where pgcod = 1
         and ppmod  = pn_CodMod
         and ppsuc  = pn_CodSuc
         and ppmda  = pn_moneda
         and pppap  = 0
         and ppcta  = pn_Cuenta
         and ppoper = pn_Operac
         and ppsbop = pn_SubTip
         and pptope = pn_CodTip
         and pptipo <> 'K';
   end if;
   if ld_UltCan is null then
      begin
         select min(ppfpag)
           into ld_UltCan
           from fsd601
          where pgcod = 1
            and ppmod  = pn_CodMod
            and ppsuc  = pn_CodSuc
            and ppmda  = pn_moneda
            and pppap  = 0
            and ppcta  = pn_Cuenta
            and ppoper = pn_Operac
            and ppsbop = pn_SubTip
            and pptope = pn_CodTip
            and pptipo <> 'K'
            and ppfpag > ld_UltCuo;
      exception
      when no_data_found then
         ld_UltCan := '';
      end;
   end if;

  return(ld_UltCan);
end BT_CuotaVence;

function BT_Deuda_Mora(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                       pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                       pn_Operac in number,pn_SubTip in number,pn_CodTip in number,
                       pn_Factor in number,pn_DiaAtr in number)
return number is
   ld_UltCan Date;
   ld_ProVen Date;
   ln_CapCal number;
   ln_CapMov number;
   ln_MonMor number;
   ln_DeuCap number;
begin

   if pn_DiaAtr <= 0 then
      return 0;
   end if;
   ln_MonMor := 0;
   begin
      select max(d_602.ppfpag)
        into ld_UltCan
        from fsd602 d_602
       where d_602.pgcod  = pn_CodEmp
         and d_602.ppmod  = pn_CodMod
         and d_602.ppsuc  = pn_CodAge
         and d_602.ppmda  = pn_Moneda
         and d_602.pppap  = pn_CodPap
         and d_602.ppcta  = pn_Cuenta
         and d_602.ppoper = pn_Operac
         and d_602.ppsbop = pn_SubTip
         and d_602.pptope = pn_CodTip
         and d_602.pp1stat = 'T'
         and d_602.d602co = 'S'
         and d_602.d602mo <> 116;
   exception
   when others then
      ld_UltCan := null;
   end;
   if ld_UltCan is null then
      begin
         select min(d_601.ppfpag)
           into ld_ProVen
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K';
      exception
      when others then
         ld_ProVen := null;
      end;
   end if;

   if ld_UltCan is not null then
      begin
         select min(d_601.ppfpag)
           into ld_ProVen
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K'
            and d_601.ppfpag > ld_UltCan;
      exception
      when others then
         ld_ProVen := null;
      end;
   end if;

   if ld_ProVen is not null then
      begin
         select nvl(sum(d_601.ppcap),0)
           into ln_CapCal
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K'
            and d_601.ppfpag = ld_ProVen;
      exception
      when others then
         ln_CapCal := 0;
      end;
      begin
         select nvl(sum(d_602.pp1cap),0)
           into ln_CapMov
           from fsd602 d_602
          where d_602.pgcod  = pn_CodEmp
            and d_602.ppmod  = pn_CodMod
            and d_602.ppsuc  = pn_CodAge
            and d_602.ppmda  = pn_Moneda
            and d_602.pppap  = pn_CodPap
            and d_602.ppcta  = pn_Cuenta
            and d_602.ppoper = pn_Operac
            and d_602.ppsbop = pn_SubTip
            and d_602.pptope = pn_CodTip
            and d_602.pptipo <> 'K'
            and d_602.ppfpag = ld_ProVen
            and d_602.d602co = 'S'
            and d_602.d602mo <> 116;
      exception
      when others then
         ln_CapMov := 0;
      end;
      ln_DeuCap := ln_CapCal - ln_CapMov;
      ln_MonMor := round(ln_DeuCap * (pn_Factor / 100) * pn_DiaAtr,2);
   end if;
   return ln_MonMor;
end BT_Deuda_Mora;

function BT_Deuda_Capital(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                       pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                       pn_Operac in number,pn_SubTip in number,pn_CodTip in number)
return number is
   ld_UltCan Date;
   ld_ProVen Date;
   ln_CapCal number;
   ln_CapMov number;
   ln_DeuCap number;
begin

   begin
      select max(d_602.ppfpag)
        into ld_UltCan
        from fsd602 d_602
       where d_602.pgcod  = pn_CodEmp
         and d_602.ppmod  = pn_CodMod
         and d_602.ppsuc  = pn_CodAge
         and d_602.ppmda  = pn_Moneda
         and d_602.pppap  = pn_CodPap
         and d_602.ppcta  = pn_Cuenta
         and d_602.ppoper = pn_Operac
         and d_602.ppsbop = pn_SubTip
         and d_602.pptope = pn_CodTip
         and d_602.pp1stat = 'T'
         and d_602.d602co = 'S'
         and d_602.d602mo <> 116;
   exception
   when others then
      ld_UltCan := null;
   end;
   if ld_UltCan is null then
      begin
         select min(d_601.ppfpag)
           into ld_ProVen
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K';
      exception
      when others then
         ld_ProVen := null;
      end;
   end if;

   if ld_UltCan is not null then
      begin
         select min(d_601.ppfpag)
           into ld_ProVen
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K'
            and d_601.ppfpag > ld_UltCan;
      exception
      when others then
         ld_ProVen := null;
      end;
   end if;

   if ld_ProVen is not null then
      begin
         select nvl(sum(d_601.ppcap),0)
           into ln_CapCal
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K'
            and d_601.ppfpag = ld_ProVen;
      exception
      when others then
         ln_CapCal := 0;
      end;
      begin
         select nvl(sum(d_602.pp1cap),0)
           into ln_CapMov
           from fsd602 d_602
          where d_602.pgcod  = pn_CodEmp
            and d_602.ppmod  = pn_CodMod
            and d_602.ppsuc  = pn_CodAge
            and d_602.ppmda  = pn_Moneda
            and d_602.pppap  = pn_CodPap
            and d_602.ppcta  = pn_Cuenta
            and d_602.ppoper = pn_Operac
            and d_602.ppsbop = pn_SubTip
            and d_602.pptope = pn_CodTip
            and d_602.pptipo <> 'K'
            and d_602.ppfpag = ld_ProVen
            and d_602.d602co = 'S'
            and d_602.d602mo <> 116;
      exception
      when others then
         ln_CapMov := 0;
      end;
      ln_DeuCap := ln_CapCal - ln_CapMov;
   end if;
   return ln_DeuCap;
end BT_Deuda_Capital;

function BT_Mto_Cuota(pn_Cuenta in number,pn_Operac in number,pn_CodTip in number,
                       pn_SubTip in number,pn_CodMod in number,pn_CodSuc in number,
                       pn_Moneda in number)
return number is

  ld_UltCuo  date := null;
  ld_UltCan date := null;
  ln_MonCuo number := 0;
begin

   begin
      select max(ppfpag)
        into ld_UltCuo
        from fsd602
       where pgcod = 1
         and ppmod   = pn_CodMod
         and ppsuc   = pn_CodSuc
         and ppmda   = pn_Moneda
         and pppap   = 0
         and ppcta   = pn_Cuenta
         and ppoper  = pn_Operac
         and ppsbop  = pn_SubTip
         and pptope  = pn_CodTip
         and pp1stat = 'T'
         and pptipo <> 'K'
         and d602co  = 'S';
   exception
   when no_data_found then        -- Cuando no hizo ningún pago
        ld_UltCuo := null;
   end;
   if ld_UltCuo is null then
      select min(ppfpag)
        into ld_UltCan
        from fsd601
       where pgcod  = 1
         and ppmod  = pn_CodMod
         and ppsuc  = pn_CodSuc
         and ppmda  = pn_Moneda
         and pppap  = 0
         and ppcta  = pn_Cuenta
         and ppoper = pn_Operac
         and ppsbop = pn_SubTip
         and pptope = pn_CodTip
         and pptipo <> 'K';
   end if;
   if ld_UltCan is null then
      begin
         select min(ppfpag)
           into ld_UltCan
           from fsd601
          where pgcod  = 1
            and ppmod  = pn_CodMod
            and ppsuc  = pn_CodSuc
            and ppmda  = pn_Moneda
            and pppap  = 0
            and ppcta  = pn_Cuenta
            and ppoper = pn_Operac
            and ppsbop = pn_SubTip
            and pptope = pn_CodTip
            and pptipo <> 'K'
            and ppfpag > ld_UltCuo;
      exception
      when no_data_found then
         ld_UltCan := '';
      end;
   end if;
---> Hallar el Mto. de la Cuota pendiente de Pago  
   select sum(ppcap + ppint)
     into ln_MonCuo
     from fsd601
    where pgcod  = 1
      and ppmod  = pn_CodMod
      and ppsuc  = pn_CodSuc
      and ppmda  = pn_Moneda
      and pppap  = 0
      and ppcta  = pn_Cuenta
      and ppoper = pn_Operac
      and ppsbop = pn_SubTip
      and pptope = pn_CodTip
      and pptipo <> 'K'
      and ppfpag = ld_UltCan;
  return(nvl(ln_MonCuo,0));
end BT_Mto_Cuota;

function BT_FonCli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2)
return varchar2 is

   ls_NumTel varchar2(4000) := '';
   ls_NumDoc varchar2(12) := '';

   cursor c_TelCli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2)
   
    is (select r_05.dotelfp
          from fsr005 r_05
         where r_05.pepais = pn_CodPai
           and r_05.petdoc = pn_TipDoc
           and r_05.pendoc = ps_NumDoc);
begin
   ls_NumDoc := rpad(ps_NumDoc,12,' ');
   for c_DatCli in c_TelCli(pn_CodPai,pn_TipDoc,ls_NumDoc)
   loop
      ls_NumTel := ls_NumTel || trim(c_DatCli.dotelfp) || ' - ' ;
   end loop;
   ls_NumTel := substr(ls_NumTel,1,length(ls_NumTel) -3);
   return substr(ls_NumTel,1,100);           
end BT_FonCli;

function BT_Tel_Cli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2,pn_TipTel in number)
return varchar2 is

   ls_NumTel varchar2(4000) := '';
   ls_NumDoc varchar2(12) := '';

   cursor c_TelCli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2,pn_TipTel in number)

    is (select r_05.dotelfp
          from fsr005 r_05
         where r_05.pepais = pn_CodPai
           and r_05.petdoc = pn_TipDoc
           and r_05.pendoc = ps_NumDoc
           and r_05.docod = pn_TipTel);
begin

   ls_NumDoc := rpad(ps_NumDoc,12,' ');
   for c_DatCli in c_TelCli(pn_CodPai,pn_TipDoc,ls_NumDoc,pn_TipTel)
   loop
      ls_NumTel := ls_NumTel || trim(c_DatCli.dotelfp) || ' - ' ;
   end loop;
   ls_NumTel := substr(ls_NumTel,1,length(ls_NumTel) -3);
   return substr(ls_NumTel,1,100);
end BT_Tel_Cli;

function BT_Cel_Cli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2)
return varchar2 is

   ls_NumTel varchar2(4000) := '';
   ls_NumDoc varchar2(12) := '';

   cursor c_TelCli(pn_CodPai in number,pn_TipDoc in number,ps_NumDoc in varchar2)

    is (select distinct r_05.dotelfp
          from fsr005 r_05
         where r_05.pepais = pn_CodPai
           and r_05.petdoc = pn_TipDoc
           and r_05.pendoc = ps_NumDoc
           and length(trim(r_05.dotelfp)) = 9);
begin

   ls_NumDoc := rpad(ps_NumDoc,12,' ');
   for c_DatCli in c_TelCli(pn_CodPai,pn_TipDoc,ls_NumDoc)
   loop

      ls_NumTel := ls_NumTel || trim(c_DatCli.dotelfp) || ' - ' ;
   end loop;
   ls_NumTel := substr(ls_NumTel,1,length(ls_NumTel) -3);
   return substr(ls_NumTel,1,100);
end BT_Cel_Cli;

function BT_Mail_Cli(pn_CodEmp in number,pn_Cuenta in number)
return varchar2 is

   ls_Correo varchar2(4000) := '';

   cursor c_Correo(pn_CodEmp in number,pn_Cuenta in number)
                  is (select x_08.ctxtxt 
                        from fsx008 x_08
                       where x_08.pgcod = pn_CodEmp
                         and x_08.ctnro = pn_Cuenta
                         and x_08.txcod = 0);

begin

   for c_DatCli in c_Correo(pn_CodEmp, pn_Cuenta)
   loop

      ls_Correo := ls_Correo || trim(c_DatCli.ctxtxt) || ' - ' ;
   end loop;
   ls_Correo := substr(ls_Correo,1,length(ls_Correo) -3);
   return lower(substr(ls_Correo,1,300));
end BT_Mail_Cli;

function BT_Deuda_Cuota(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                       pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                       pn_Operac in number,pn_SubTip in number,pn_CodTip in number)
return number is
   ld_UltCan Date;
   ld_ProVen Date;
   ln_CapCal number;
   ln_IntCal number;
   ln_CapMov number;
   ln_IntMov number;
   ln_MonDeu number;
   ln_DeuCap number;
   ln_DeuInt number;
begin

   ln_MonDeu := 0;
   begin
      select max(d_602.ppfpag)
        into ld_UltCan
        from fsd602 d_602
       where d_602.pgcod  = pn_CodEmp
         and d_602.ppmod  = pn_CodMod
         and d_602.ppsuc  = pn_CodAge
         and d_602.ppmda  = pn_Moneda
         and d_602.pppap  = pn_CodPap
         and d_602.ppcta  = pn_Cuenta
         and d_602.ppoper = pn_Operac
         and d_602.ppsbop = pn_SubTip
         and d_602.pptope = pn_CodTip
         and d_602.pp1stat = 'T'
         and d_602.d602co = 'S';
   exception
   when others then
      ld_UltCan := null;
   end;
   if ld_UltCan is null then
      begin
         select min(d_601.ppfpag)
           into ld_ProVen
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K';
      exception
      when others then
         ld_ProVen := null;
      end;
   end if;

   if ld_UltCan is not null then
      begin
         select min(d_601.ppfpag)
           into ld_ProVen
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K'
            and d_601.ppfpag > ld_UltCan;
      exception
      when others then
         ld_ProVen := null;
      end;
   end if;

   if ld_ProVen is not null then
      begin
         select nvl(sum(d_601.ppcap),0)
           into ln_CapCal
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K'
            and d_601.ppfpag = ld_ProVen;
      exception
      when others then
         ln_CapCal := 0;
      end;
      begin
         select nvl(sum(d_601.ppint),0)
           into ln_IntCal
           from fsd601 d_601
          where d_601.pgcod  = pn_CodEmp
            and d_601.ppmod  = pn_CodMod
            and d_601.ppsuc  = pn_CodAge
            and d_601.ppmda  = pn_Moneda
            and d_601.pppap  = pn_CodPap
            and d_601.ppcta  = pn_Cuenta
            and d_601.ppoper = pn_Operac
            and d_601.ppsbop = pn_SubTip
            and d_601.pptope = pn_CodTip
            and d_601.pptipo <> 'K'
            and d_601.ppfpag = ld_ProVen;
      exception
      when others then
         ln_IntCal := 0;
      end;
      begin
         select nvl(sum(d_602.pp1cap),0)
           into ln_CapMov
           from fsd602 d_602
          where d_602.pgcod  = pn_CodEmp
            and d_602.ppmod  = pn_CodMod
            and d_602.ppsuc  = pn_CodAge
            and d_602.ppmda  = pn_Moneda
            and d_602.pppap  = pn_CodPap
            and d_602.ppcta  = pn_Cuenta
            and d_602.ppoper = pn_Operac
            and d_602.ppsbop = pn_SubTip
            and d_602.pptope = pn_CodTip
            and d_602.pptipo <> 'K'
            and d_602.d602co = 'S'
            and d_602.d602mo <> 116
            and d_602.ppfpag = ld_ProVen;
      exception
      when others then
         ln_CapMov := 0;
      end;
      begin
         select nvl(sum(d_602.pp1int),0)
           into ln_IntMov
           from fsd602 d_602
          where d_602.pgcod  = pn_CodEmp
            and d_602.ppmod  = pn_CodMod
            and d_602.ppsuc  = pn_CodAge
            and d_602.ppmda  = pn_Moneda
            and d_602.pppap  = pn_CodPap
            and d_602.ppcta  = pn_Cuenta
            and d_602.ppoper = pn_Operac
            and d_602.ppsbop = pn_SubTip
            and d_602.pptope = pn_CodTip
            and d_602.pptipo <> 'K'
            and d_602.d602co = 'S'
            and d_602.d602mo <> 116
            and d_602.ppfpag = ld_ProVen;
      exception
      when others then
         ln_IntMov := 0;
      end;
      ln_DeuCap := ln_CapCal - ln_CapMov;
      ln_DeuInt := ln_IntCal - ln_IntMov;
      ln_MonDeu := ln_DeuCap + ln_DeuInt;
   end if;
   return ln_MonDeu;
end BT_Deuda_Cuota;

function BT_CalCli(pn_Cuenta in number,pd_FecPro in date)
return varchar2 is

   ls_CalCli varchar2(15) := '';

begin

select r_212.CATCATE
  into ls_CalCli
  from fsd212 d_212,
       fsr212 r_212
 where d_212.pgcod = 1
   and d_212.catfchdes = pd_FecPro
   and d_212.catcod = 4
   and d_212.catcateg = r_212.catcate
   and r_212.catcod = 4
   and d_212.catcta = pn_Cuenta;

   return ls_CalCli;
end BT_CalCli;

procedure SP_GenPagDia(pd_FecPro in date,pd_FecPag in date,pn_CodPro out number) is

   ls_Cad001 varchar2(3200);
   ls_Cad002 varchar2(3200);
   ls_Cad003 varchar2(3200);
   ls_FecPro varchar2(10);
   ls_FecPag varchar2(10);
   ls_FecTmp varchar2(8);
   ls_NumDia number(1);
   ld_FecCie date;
   ld_NewCie date;
   ln_CodPro number;
   ln_ProDat number;

begin

   ls_Cad001 := 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
   execute immediate ls_Cad001;

   ls_Cad001 := 'select max(jaql831fpro) + 1 from jaql831 where jaql831tpro = 2'; -- Último día procesado más uno
   execute immediate ls_Cad001 into ld_FecCie;
   ls_FecPag := to_char(Trunc(pd_FecPag),'yyyy.mm.dd');
   ls_FecPro := to_char(Trunc(sysdate),'yyyy.mm.dd');  -- Fecha de Proceso (Sistema)
   if ld_FecCie is null then
      ld_FecCie := pd_FecPro + 1;
   end if;
   ls_NumDia := to_number(to_char( trunc(sysdate) ,'d'));
   if ls_NumDia = 1 then  -- Lunes, cargar a la semana pasada
      ls_FecTmp := to_char(Trunc(sysdate) - to_number(to_char( trunc(sysdate) ,'d')) -7,'yyyymmdd');
   else
      ls_FecTmp := to_char(Trunc(sysdate) - to_number(to_char( trunc(sysdate) ,'d')),'yyyymmdd');
   end if;

   select max(jaql831cpro) into ln_CodPro from jaql831 where jaql831tpro =  2;
   if ln_CodPro is null then
      ln_CodPro := 1;
   else   
      ln_CodPro := ln_CodPro + 1;
   end if;   
   select max(jaql831cpro) into ln_ProDat from jaql831 where jaql831tpro =  1;
   pn_CodPro := ln_CodPro;
   ls_Cad001 := 'insert into jaql831
                (jaql831cpro,jaql831fpro,jaql831tpro,jaql831hini,jaql831hfin,
                 jaql831nreg,jaql831obse,jaql831fsis) 
                 values
                (' || to_char(ln_CodPro,'999999999') || ',to_date(''' || to_char(pd_FecPro,'yyyy.mm.dd') || ''',''yyyy.mm.dd''),
                 2,to_char(sysdate,''HH24:MI:SS''),to_char(sysdate,''HH24:MI:SS''),0,''Detalle de Pagos'',
                 to_date(''' || ls_FecPro || ''',''yyyy.mm.dd''))';
   execute immediate ls_Cad001;
   commit;

   ls_Cad001 := 'insert into jaql831p
                  select ' || to_char(ln_CodPro,'999999999') || ',h_016.hcta,h_016.hoper,h_016.hfcon,h_016.hcimp6,t_034.trnom,Dia_0.jaql831dccal
                    from fsh016 h_016,
                         fsh015 h_015,
                         fst034 t_034,
                         jaql831d Dia_0
                   where Dia_0.jaql831cpro = ' || to_char(ln_ProDat,'999999999') || '
                     and h_015.pgcod = 1
                     and h_016.pgcod = 1
                     and t_034.pgcod = 1
                     and h_016.hcta  = Dia_0.jaql831dncta
                     and h_016.hoper = Dia_0.jaql831dnope
                     and t_034.trmod = h_016.hcmod
                     and t_034.trnro = h_016.htran
                     and h_016.hfcon = to_date(''' || to_char(pd_FecPag,'yyyy.mm.dd') || ''',''yyyy.mm.dd'')
                     and h_016.hmodul in (101,102,103,104,105,116,141,142,106,109,110,112,113,115,144) -- NO: Judicial, Convenio, Prendario
                     and h_016.hcmod <> 99
                     and h_016.hcmod <> 300
                     and h_016.hcmod <> 530
                     and h_016.hcmod <> 599
                     and h_016.hcmod <> 600
                     and h_016.hcmod <> 616
                     and h_016.hcmod <> 709
                     and h_016.hcmod <> 710
                     and h_016.hcmod <> 800
                     and h_016.hcmod <> 990';
   ls_Cad002 := '    and h_016.hcmod || ''-'' || h_016.htran <> ''30-951'' -- Alta de Préstamos
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-508'' -- Desembolso Parcial
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-931'' -- Transferencia de Cart.
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-972'' -- Renovacion Prendario
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-407'' -- Pago Castigado
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-401'' -- Pago Judicial
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-350'' -- Refinanciaciones "1 a 1"
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-351'' -- Refinanciaciones "n a 1"
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-357'' -- Ampliación Especial
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-403'' -- Pago Judicial Fallecido
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-408'' -- Pago Castigado Fallecido
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-355'' -- Reprograma Cambio de Fecha
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-356'' -- Reprogramacion Desastre Natural
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-935'' -- Transferencia - Líneas c/Util.
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-975'' -- Remate de Joyas
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-976'' -- Adjudicacion de Joyas
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-936''	-- TransfCartera pjabo,pjdem,judi
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-937''	-- Transf Cartera castigados
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-955'' -- Alta Carta Fianza
                     and h_016.hcmod || ''-'' || h_016.htran <> ''30-107'' -- Canc Honramiento Carta Fianza
                     and h_016.hcmod || ''-'' || h_016.htran <> ''69-260'' -- Relacionar Garant-PrestJudCas
                     and h_016.hcmod || ''-'' || h_016.htran <> ''98-303'' --	Amort.Créd.Jud.Adjudicacion
                     and h_016.hcmod || ''-'' || h_016.htran <> ''98-310'' --	Castigo de cr¿ditos
                     and h_016.hcmod || ''-'' || h_016.htran <> ''98-107'' -- Cancelación Batch C.Fianza
                     and h_016.hcmod || ''-'' || h_016.htran <> ''98-312'' -- Psje. a Judic-cance.estr M200
                     and h_016.hcmod || ''-'' || h_016.htran <> ''98-405'' --	Reclasificacion Rubros SBS
                     and h_016.hcmod || ''-'' || h_016.htran <> ''98-430'' --	Reclasificacion SBS - C.Fianza
                     and h_016.hcmod || ''-'' || h_016.htran <> ''100-550'' -- Reclasificacion Rubros SBS-int
                     and h_016.hcmod || ''-'' || h_016.htran <> ''100-551'' -- Reclas Rubros SBS-int-env.jud';
   ls_Cad003 := '    and h_016.hcmod || ''-'' || h_016.htran <> ''100-703'' -- Reasig.Saldo de Créd/Ing.Refin
                     and h_016.hcmod || ''-'' || h_016.htran <> ''100-706'' -- Cancelac.de créd.K=0 Mod.144
                     and h_016.hcmod || ''-'' || h_016.htran <> ''116-50'' -- Alta de Linea de Credito
                     and h_016.hcmod || ''-'' || h_016.htran <> ''116-60'' -- Incremento Linea de Credito
                     and h_016.hcmod || ''-'' || h_016.htran <> ''116-200'' -- Cancelación Linea de Credito x Ampliación
                     and h_016.hcmod || ''-'' || h_016.htran <> ''141-107'' -- Cancela Carta Fianza
                     and h_016.hcmod || ''-'' || h_016.htran <> ''141-108'' -- Renovación Carta Fianza Autoli
                     and h_016.hcmod || ''-'' || h_016.htran <> ''141-110'' -- Honramiento Carta Fianza
                     and h_016.hcmod || ''-'' || h_016.htran <> ''183-10'' --	Alta de Cupo Desemb. Parciales
                     and h_016.hcmod || ''-'' || h_016.htran <> ''210-971'' -- Alta Prendario
                     and h_015.hcmod  = h_016.hcmod
                     and h_015.hsucor = h_016.hsucor
                     and h_015.htran  = h_016.htran
                     and h_015.hnrel  = h_016.hnrel
                     and h_015.hfcon  = h_016.hfcon
                     and h_015.hccorr <> 99';      -- No extornados
   execute immediate ls_Cad001 || ls_Cad002 || ls_Cad003;
   Commit;

--and h_016.hfcon >= to_date(''' || to_char(ld_FecCie,'yyyy.mm.dd') || ''',''yyyy.mm.dd'')
   
   ls_Cad001 := 'update jaql831
                    set jaql831hfin = to_char(sysdate,''HH24:MI:SS''),
                        jaql831nreg = (select count(*) from jaql831p where jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999')) ||'),
                        jaql831ffin = to_date(''' || ls_FecPro || ''',''yyyy.mm.dd''),
                        jaql831frcc = to_date(''' || ls_FecPag || ''',''yyyy.mm.dd'')
                  where jaql831tpro = 2
                    and jaql831cpro = ' || trim(to_char(ln_CodPro,'999999999'));
   execute immediate ls_Cad001;
   commit;
   
end SP_GenPagDia;

procedure SP_MaxNumPro(pc_TipPro in varchar2,pn_CodPro out number) is

   ln_CodPro number;
begin
   if pc_TipPro = 'T' Then
      select Count(*) into ln_CodPro from jaql831t where jaql831tcest = '0';
   else   
      select nvl(max(jaql831cpro),0) into ln_CodPro from jaql831 where jaql831tpro = pc_TipPro;
   end if;   
   pn_CodPro := ln_CodPro;
end SP_MaxNumPro;

procedure SP_SalCre(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                   pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                   pn_Operac in number,pn_SubTip in number,pn_CodTip in number,
                   pn_SalCap out number) is

   begin
      select nvl(abs(d_011.scsdo),0)
        into pn_SalCap
        from fsd011 d_011
       where d_011.pgcod = pn_CodEmp
         and d_011.scsuc = pn_CodAge
         and d_011.scmda = pn_Moneda
         and d_011.scpap = 0
         and d_011.sccta = pn_Cuenta
         and d_011.scoper = pn_Operac
         and d_011.scsbop = pn_SubTip
         and d_011.sctope = pn_CodTip
         and d_011.scmod  = pn_CodMod;
   exception
   when others then
         pn_SalCap := 0;

end SP_SalCre;

procedure SP_ActRes(pn_CodEmp in number,pn_CodMod in number,pn_CodAge in number,
                   pn_Moneda in number,pn_CodPap in number,pn_Cuenta in number,
                   pn_Operac in number,pn_SubTip in number,pn_CodTip in number,
                   ps_FecRea in varchar2,ps_HorRea in varchar2,ps_DetRea in varchar2,
                   pn_CodRea in number,pn_MotRea in number,ps_FecCom in varchar2) is
ln_CodIns number;
ld_FecCom date;
ld_FecPro date;
begin
   if ps_FecCom <> '9999' then
      ld_FecCom := to_date(ps_FecCom,'DD/MM/YYYY');
   end if;      
   ld_FecPro := Trunc(sysdate);
   sp_instancia_credito_cce(pn_CodMod,pn_CodAge,pn_Moneda,pn_CodPap,pn_Cuenta,pn_Operac,pn_SubTip,pn_CodTip,ln_CodIns);
   if nvl(ln_CodIns,0) <> 0 then
      insert into jaql523 (D_FECREA,C_HORREA,N_NUMINS,C_CODUSU,C_IPCELU,C_IMEIEQ,C_ESTREG,N_LATITU,N_LONGIT,C_DETREA,
                           N_CODMOT,N_CODACC,N_MOTREA,N_MOTNPA,D_FECCOM,C_TIPREA,C_CODERR,C_MSGERR)
           values (ld_FecPro,ps_HorRea,ln_CodIns,'CCEXT','CALL EXTERNO','','0','','',ps_DetRea,
                   5,1,trim(to_char(pn_CodRea)),trim(to_char(pn_MotRea)),ld_FecCom,'M','','');
        --to_date(ps_FecRea,'DD/MM/YYYY')        
      commit; 
   end if;   
end SP_ActRes;

end PQ_CC_CONSULTAS_BT;
/

