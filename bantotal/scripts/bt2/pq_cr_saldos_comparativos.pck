create or replace package PQ_CR_SALDOS_COMPARATIVOS is
 
    -- *****************************************************************
    -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.01.03
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER SALDOS COMPARATIVOS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2021.06.09
    -- Autor de la Modificación   : DCASTRO 
    -- Descripción de Modificación: Se comento db link @simweb, 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_carga_datos_ini(pc_sucurs in varchar2 , pd_fecpro in date);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_carga_datos(pc_sucurs in varchar2, pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_cr_job_carga(pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_inserta_tabla( pd_fecpro in date) ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_CR_SALDOS_COMPARATIVOS;
/

create or replace package body PQ_CR_SALDOS_COMPARATIVOS is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_SALDOS_COMPARATIVOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.18
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS PARA REPORTE VARIACION DE SALDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.08.06
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: sp_cr_carga_datos, sp_cr_carga_datos_ini
    --                            : 2014.12.01 DCASTRO Se modifico sp_cr_inserta_tabla,  
    --                            : 2014.12.10 DCASTRO SE modifico sp_cr_carga_datos, sp_cr_inserta_tabla
    --                            :            SFERNANDEM Se modifico sp_cr_inserta_tabla
    --                            :                
    -- *****************************************************************
      


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos_ini(pc_sucurs in varchar2 , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.18
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PARA REPORTE VARIACION DE SALDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.08.06
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: SE agrego condicion a.bcprod <> 99 para no considerar creditos vigentes sin saldo 
    -- *****************************************************************


cursor creditos(lc_sucurs varchar2, ld_fecpro date) is

 select --/*+parallel(a,2,@2) parallel(b,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) parallel(pers,2,@2)*/
       r2.regcod,
       upper(r2.RegNOM) region,
       age.sucurs,
       upper(age.Scnom) agencia,
       fn_analista_credito(a.bcmod,a.bcsuc,a.bcmda,a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop) codana,
       SUM(a.bcsdmn) SALCAPJUDICIAL,
       COUNT(DISTINCT pers.petdoc||'-'||pers.pendoc) NUMCLIS_OTORG,
       count(DISTINCT a.bcmod||'-'||a.bcsuc||'-'||a.bcmda||'-'||a.bcpap||'-'||a.bccta||'-'||a.bcoper||'-'||a.bcsbop||'-'||a.bctop) NUMCRES_OTOR3,
       SUM(case when fn_dias_atraso(a.bcfech, a.bcemp, a.bcmod, a.bcsuc, a.bcmda, a.bcpap, a.bccta, a.bcoper, a.bcsbop, a.bctop, 0, a.bcfvto)>15 then a.bcsdmn end) SALCAP15SOLES,
       SUM(case when fn_dias_atraso(a.bcfech, a.bcemp, a.bcmod, a.bcsuc, a.bcmda, a.bcpap, a.bccta, a.bcoper, a.bcsbop, a.bctop, 0, a.bcfvto)>30 then a.bcsdmn end) SALCAP30SOLES,
       sum(case when substr(a.bcrubr,1,4) in (1411,1421) then a.bcsdmn end) as SaldoVig,
       sum(case when substr(a.bcrubr,1,4) in (1416,1426) then a.bcsdmn end) as SaldoJud,
       sum(case when substr(a.bcrubr,1,4) in (1415,1425) then a.bcsdmn end) as SaldoVen,
       sum(case when substr(a.bcrubr,1,4) in (1414,1424) then a.bcsdmn end) as SaldoRef,
       count(distinct case when substr(a.bcrubr,1,4) in (1416,1426) then a.bcemp||a.bcsuc||a.bcmda||a.bcpap||a.bccta||a.bcoper||a.bcsbop||a.bctop||a.bcmod end) as CreJud,
       count(distinct case when substr(a.bcrubr,1,4) in (1415,1425) then a.bcemp||a.bcsuc||a.bcmda||a.bcpap||a.bccta||a.bcoper||a.bcsbop||a.bctop||a.bcmod end) as CreVen,
       count(distinct case when substr(a.bcrubr,1,4) in (1414,1424) then a.bcemp||a.bcsuc||a.bcmda||a.bcpap||a.bccta||a.bcoper||a.bcsbop||a.bctop||a.bcmod end) as CreRef,
       COUNT(DISTINCT case when substr(a.bcrubr,1,4) in (1416,1426) then pers.petdoc||'-'||pers.pendoc end ) CliJud,
       COUNT(DISTINCT case when substr(a.bcrubr,1,4) in (1415,1425) then pers.petdoc||'-'||pers.pendoc end ) CliVen,
       COUNT(DISTINCT case when substr(a.bcrubr,1,4) in (1414,1424) then pers.petdoc||'-'||pers.pendoc end ) CliRef       
  from fsh012 a,
       fst811 r,
       FST001 age,
       fst810 r2,
       fsr008 pers
 where a.bccta <> 999999999
   and substr(a.bcrubr,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426)
   and a.bcmod not in (33,141)
   and a.bcfech= ld_fecpro --to_date(&rrrrmmdd,'rrrrmmdd')
   and r.pgcod = 1 and r.oficod = a.bcsuc 
   and r.RegCod < 100
   AND r.pgcod = age.Pgcod 
   and age.Pgcod  = 1 and age.Sucurs = a.bcsuc
   and r2.regcod = r.regcod
   and r2.regcod<100
   and pers.pgcod = 1   
   and pers.ctnro = a.bccta 
   and pers.ttcod = 1
   and pers.CTTFIR = 'T'
   AND pers.ctnro <> 999999999
   and age.Sucurs = lc_sucurs
   and a.bcprod <> 99  --- 
GROUP BY
       r2.regcod,
       upper(r2.RegNOM),
       age.sucurs,
       upper(age.Scnom),
       fn_analista_credito(a.bcmod,a.bcsuc,a.bcmda,a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop);
            
 ln_cont NUMBER;
 
begin

   for i in creditos(pc_sucurs, pd_fecpro) loop
   
       insert into jaql967 (JAQL967FEC, JAQL967REG, JAQL967REN, JAQL967SUC, JAQL967AGE, JAQL967ANA, JAQL967SALJ, JAQL967NCL, JAQL967NCR, 
              JAQL967S15, JAQL967S30, JAQL967SJU, JAQL967SVE, JAQL967SRE, JAQL967CRJU, JAQL967CRVE, JAQL967CRRE, 
              JAQL967CLJU,JAQL967CLVE, JAQL967CLRE, JAQL967SVI
               )
   
           
       values ( pd_fecpro, i.regcod, i.region, i.sucurs, i.agencia, i.codana, i.SALCAPJUDICIAL, i.NUMCLIS_OTORG,i.NUMCRES_OTOR3, 
                i.SALCAP15SOLES, i.SALCAP30SOLES,i.SaldoJud,i.SaldoVen,i.SaldoRef,i.CreJud,i.CreVen,i.CreRef,
                i.CliJud,i.CliVen, i.CliRef, I.SALDOVIG 
              );
       
       commit; 
       
 
   
   end loop;  
   commit;
 
 end sp_cr_carga_datos_ini;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(pc_sucurs in varchar2 , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL583
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.08.06
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: SE agrego condicion a.bcprod <> 99 para no considerar creditos vigentes sin saldo 
    --                              2014.12.01 DCASTRO Se agrego campo saldo vigente para carga de datos.  
    -- *****************************************************************


cursor creditos(lc_sucurs varchar2, ld_fecpro date) is

 select --/*+parallel(a,2,@2) parallel(b,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) parallel(pers,2,@2)*/
       r2.regcod,
       upper(r2.RegNOM) region,
       age.sucurs,
       upper(age.Scnom) agencia,
       fn_analista_credito(a.bcmod,a.bcsuc,a.bcmda,a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop) codana,
       a.bcmod,a.bcsuc,a.bcmda,a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop,
       pers.petdoc,pers.pendoc,
       --fn_usuario_nombre(fn_analista_credito(a.bcmod,a.bcsuc,a.bcmda,a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop)) analista,
       /*SUM*/(nvl(a.bcsdmn,0)) SALCAPJUDICIAL,
       1 NUMCLIS_OTORG,--COUNT(DISTINCT pers.petdoc||'-'||pers.pendoc) NUMCLIS_OTORG,
       1 NUMCRES_OTOR3,--count(DISTINCT a.bcmod||'-'||a.bcsuc||'-'||a.bcmda||'-'||a.bcpap||'-'||a.bccta||'-'||a.bcoper||'-'||a.bcsbop||'-'||a.bctop) NUMCRES_OTOR3,
       /*SUM*/nvl(case when fn_dias_atraso(a.bcfech, a.bcemp, a.bcmod, a.bcsuc, a.bcmda, a.bcpap, a.bccta, a.bcoper, a.bcsbop, a.bctop, 0, a.bcfvto)>15 then a.bcsdmn end,0) SALCAP15SOLES,
       /*SUM*/nvl(case when fn_dias_atraso(a.bcfech, a.bcemp, a.bcmod, a.bcsuc, a.bcmda, a.bcpap, a.bccta, a.bcoper, a.bcsbop, a.bctop, 0, a.bcfvto)>30 then a.bcsdmn end,0) SALCAP30SOLES,
       /*sum*/nvl(case when substr(a.bcrubr,1,4) in (1411,1421) then a.bcsdmn end,0) as SaldoVig,
       /*sum*/nvl(case when substr(a.bcrubr,1,4) in (1416,1426) then a.bcsdmn end,0) as SaldoJud,
       /*sum*/nvl(case when substr(a.bcrubr,1,4) in (1415,1425) then a.bcsdmn end,0) as SaldoVen,
       /*sum*/nvl(case when substr(a.bcrubr,1,4) in (1414,1424) then a.bcsdmn end,0) as SaldoRef,
       case when substr(a.bcrubr,1,4) in (1416,1426) then 1 end CreJud,--count(distinct case when substr(a.bcrubr,1,4) in (1416,1426) then a.bcemp||a.bcsuc||a.bcmda||a.bcpap||a.bccta||a.bcoper||a.bcsbop||a.bctop||a.bcmod end) as CreJud,
       case when substr(a.bcrubr,1,4) in (1415,1425) then 1 end CreVen,--count(distinct case when substr(a.bcrubr,1,4) in (1415,1425) then a.bcemp||a.bcsuc||a.bcmda||a.bcpap||a.bccta||a.bcoper||a.bcsbop||a.bctop||a.bcmod end) as CreVen,
       case when substr(a.bcrubr,1,4) in (1414,1424) then 1 end CreRef,--count(distinct case when substr(a.bcrubr,1,4) in (1414,1424) then a.bcemp||a.bcsuc||a.bcmda||a.bcpap||a.bccta||a.bcoper||a.bcsbop||a.bctop||a.bcmod end) as CreRef,
       case when substr(a.bcrubr,1,4) in (1416,1426) then 1 end CliJud,--COUNT(DISTINCT case when substr(a.bcrubr,1,4) in (1416,1426) then pers.petdoc||'-'||pers.pendoc end ) CliJud,
       case when substr(a.bcrubr,1,4) in (1415,1425) then 1 end CliVen,--COUNT(DISTINCT case when substr(a.bcrubr,1,4) in (1415,1425) then pers.petdoc||'-'||pers.pendoc end ) CliVen,
       case when substr(a.bcrubr,1,4) in (1414,1424) then 1 end CliRef--COUNT(DISTINCT case when substr(a.bcrubr,1,4) in (1414,1424) then pers.petdoc||'-'||pers.pendoc end ) CliRef       
  from fsh012 a,
       fst811 r,
       FST001 age,
       fst810 r2,
       fsr008 pers
       
 where a.bccta <> 999999999
   and substr(a.bcrubr,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426)
   and a.bcmod not in (33,141)
   and a.bcfech= ld_fecpro --to_date(&rrrrmmdd,'rrrrmmdd')
   and r.pgcod = 1 and r.oficod = a.bcsuc and r.RegCod < 100
   AND r.pgcod = age.Pgcod 
   and age.Pgcod  = 1 and age.Sucurs = a.bcsuc
   and r2.regcod = r.regcod
   and r2.regcod<100
   and pers.pgcod = 1   
   and pers.ctnro = a.bccta 
   and pers.ttcod = 1
   and pers.CTTFIR = 'T'
   AND pers.ctnro <> 999999999
   and age.Sucurs = lc_sucurs
   and a.bcprod <> 99
/*GROUP BY
       r2.regcod,
       upper(r2.RegNOM),
       age.sucurs,
       upper(age.Scnom),
       fn_analista_credito(a.bcmod,a.bcsuc,a.bcmda,a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop)*/;
            
 ln_cont NUMBER;
 
begin

   for i in creditos(pc_sucurs, pd_fecpro) loop
   
       insert into jaql967 (
                jaql967fec, jaql967reg,jaql967ren, jaql967cod, jaql967age, jaql967ana, 
                jaql967mod, jaql967suc, jaql967mda, jaql967pap, jaql967cta, jaql967oper, jaql967sbop, jaql967top, 
                jaql967tdoc, jaql967ndoc, 
                --jaql967ncl, jaql967ncr, 
                jaql967salj, jaql967s15, jaql967s30, jaql967sju, jaql967sve, jaql967sre, jaql967crju, 
                jaql967crve, jaql967crre, 
                jaql967clju, jaql967clve, jaql967clre, JAQL967SVI 
               )
   
           
       values ( pd_fecpro, i.regcod, i.region, i.sucurs, i.agencia, i.codana, 
                i.bcmod,i.bcsuc,i.bcmda,i.bcpap,i.bccta,i.bcoper,i.bcsbop,i.bctop,       
                i.petdoc,i.pendoc,
                --i.NUMCLIS_OTORG,i.NUMCRES_OTOR3, 
                i.SALCAPJUDICIAL * -1,i.SALCAP15SOLES * -1, i.SALCAP30SOLES * -1,i.SaldoJud * -1,
                i.SaldoVen * -1,i.SaldoRef * -1 ,i.CreJud,i.CreVen,i.CreRef,
                i.CliJud,i.CliVen, i.CliRef, I.SALDOVIG * -1
                 
              );
       
       commit; 
       
 
   
   end loop;  
   commit;
 
 end sp_cr_carga_datos;


 
procedure sp_cr_job_carga(pd_fecpro in date) is

ln_ini number;
lc_variable varchar2(1000);
ln_job number:=0;
lc_fecpro char(10);
lc_hostname varchar2(64);
  cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 or sucurs >= 900;

begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  execute immediate 'truncate table jaql967';

  lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
  
  begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQL967',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

   
   
  for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := 'begin '||'  PQ_CR_SALDOS_COMPARATIVOS.sp_cr_carga_datos('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
        ln_job := ln_job +1;
--        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then           
--        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
          IF SYS.FN_BD_ISRAC='TRUE' THEN
         DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => 1,
                      --instance => 2, -- 24/10/2023
                      force => false
                      );
        else
          DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
        end if;  
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('SAL',ln_ini,lc_variable);
        COMMIT;

  end loop;          



end sp_cr_job_carga;
 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_inserta_tabla( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_tabla
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : INSERTA EN TABLA BASE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.12.01
    -- Autor de la Modificación   :  DCASTRO
    -- Descripción de Modificación:  Se agrego campos saldo vencido, vigente, refinanciado, cartera atrasada y cartera atrasada con castigos por REGION.
    --                            :  2014.12.10 DCASTRO Se agrego campos jaql968svi, jaql968scat, jaql968scac
    --                            :  2014.12.10 SFERNANDEM Se modifico obtencion de castigos diaria y mensual
    --                            :  2014.12.23 DCASTRO/SFERNANDEM Se modifico carga saldo castigo para actualizar informacion., se comento castigado diario, se muestra el acumulado.
    -- *****************************************************************


cursor region(ld_fecpro date) is
 ---por region
 
select REGCOD,REGION,SaldoCapital,SaldoCapitalJud,NroCli,NroCre,Saldo15,Mora15,Saldo30,Mora30,SaldoJu,--SaldoCa,
       SaldoVi, SaldoVe, SaldoRe, SaldoCat, Mora
 from (select jaql967reg REGCOD,
       jaql967ren REGION,
       sum(jaql967salj - jaql967sju) SaldoCapital,
       sum(jaql967salj) SaldoCapitalJud,
       COUNT(DISTINCT jaql967tdoc||'-'||jaql967ndoc) NroCli,
       count(DISTINCT jaql967mod||'-'||jaql967suc||'-'||jaql967mda||'-'||jaql967pap||'-'||jaql967cta||'-'||jaql967oper||'-'||jaql967sbop||'-'||jaql967top) NroCre,
       sum(jaql967s15) Saldo15,
       round((sum(jaql967s15) / sum(jaql967salj))*100, 2) Mora15,
       sum(jaql967s30) Saldo30, 
       round((sum(jaql967s30) / sum(jaql967salj))*100, 2) Mora30,
       sum(jaql967sju) SaldoJu,
       sum(jaql967sve) SaldoVe, --vencido
       sum(jaql967sre) SaldoRe, --refinanciado
       sum(jaql967svi) SaldoVi, --vigente 
       sum(jaql967sve + jaql967sju) SaldoCat, --cartera atrasada 
    --   sum(jaql967scac) SaldoCac, --cartera atrasada con castigos
       round( sum(jaql967sve + jaql967sju)/ (sum(jaql967svi + jaql967sre + jaql967sve + jaql967sju) )*100, 2) Mora--,
--       round(sum(jaql967scac)/ (sum(jaql967svi + jaql967sre + jaql967sve + jaql967sju) )*100, 2) MoraCas,
  from jaql967
where jaql967fec = ld_fecpro 
 group by jaql967fec,jaql967reg,jaql967ren
order by jaql967reg);

cursor castigado_mes(ld_fecpro date) is
 
          select k.jaql175emp,
                    ld_fecpro   ,
                   f.regcod,
                   sum(k.jaql175cac*decode(k.jaql175mda,101,(  select cotcbi from fsh005
                                                               where cofdes =
                                                                     (select max(cofdes)
                                                                        from fsh005
                                                                       where moneda = 101
                                                                         and cofdes <=ld_fecpro )
                                                               and moneda = 101),1))as SaldoCa
              from jaql174 j
             inner join jaql175 k on j.jaql174nro = k.jaql174nro
             inner join fst811 f on f.pgcod = k.jaql175emp
                                and k.jaql175suc = f.oficod
             inner join fst810 l on f.pgcod = k.jaql175emp
                                and f.regcod = l.regcod
             where k.jaql175itc = 'S'
               and k.jaql175fca >= TO_DATE('01/' || EXTRACT(MONTH FROM ld_fecpro ) || '/' ||EXTRACT(YEAR FROM ld_fecpro ),'dd/mm/rrrr')
               and k.jaql175fca <= ld_fecpro 
               and f.regcod < 100
               and f.ofisuc = 'S'
               and f.pgcod = l.pgcod
             group by k.jaql175emp,
                    ld_fecpro,
                   f.regcod,
                   l.regnom;

 cursor castigado_dia(ld_fecpro date) is
 
          select k.jaql175emp,
                    ld_fecpro   ,
                   f.regcod,
                   sum(k.jaql175cac*decode(k.jaql175mda,101,(  select cotcbi from fsh005
                                                               where cofdes =
                                                                     (select max(cofdes)
                                                                        from fsh005
                                                                       where moneda = 101
                                                                         and cofdes <=ld_fecpro )
                                                               and moneda = 101),1)) as SaldoCa
              from jaql174 j
             inner join jaql175 k on j.jaql174nro = k.jaql174nro
             inner join fst811 f on f.pgcod = k.jaql175emp
                                and k.jaql175suc = f.oficod
             inner join fst810 l on f.pgcod = k.jaql175emp
                                and f.regcod = l.regcod
             where k.jaql175itc = 'S'
               and k.jaql175fca = ld_fecpro 
               and f.regcod < 100
               and f.ofisuc = 'S'
               and f.pgcod = l.pgcod
             group by k.jaql175emp,
                    ld_fecpro,
                   f.regcod,
                   l.regnom;
 

cursor agencia(ld_fecpro date) is
---por agencia
select jaql967reg REGCOD,
       jaql967ren REGION,
       jaql967suc AGECOD,
       jaql967age AGENCIA,
       sum(jaql967salj - jaql967sju) SaldoCapital,
       sum(jaql967salj) SaldoCapitalJud,
       COUNT(DISTINCT jaql967tdoc||'-'||jaql967ndoc) NroCli,
       count(DISTINCT jaql967mod||'-'||jaql967suc||'-'||jaql967mda||'-'||jaql967pap||'-'||jaql967cta||'-'||jaql967oper||'-'||jaql967sbop||'-'||jaql967top) NroCre,
       sum(jaql967s15) Saldo15,
       round((sum(jaql967s15) / sum(jaql967salj))*100, 2) Mora15,
       sum(jaql967s30) Saldo30, 
       round((sum(jaql967s30) / sum(jaql967salj))*100, 2) Mora30,
       sum(jaql967sju) SaldoJu
  from jaql967
 where jaql967fec = ld_fecpro--to_date('2013.07.31', 'yyyy.mm.dd')
 group by jaql967reg,jaql967fec,jaql967ren, jaql967suc,jaql967age
 order by jaql967reg,jaql967suc;

cursor analista(ld_fecpro date) is
-----por analista
select jaql967reg REGCOD,
       jaql967ren REGION,
       jaql967suc AGECOD,
       jaql967age AGENCIA,
       jaql967ana ANALISTA,
       sum(jaql967salj - jaql967sju) SaldoCapital,
       sum(jaql967salj) SaldoCapitalJud,
       COUNT(DISTINCT jaql967tdoc||'-'||jaql967ndoc) NroCli,
       count(DISTINCT jaql967mod||'-'||jaql967suc||'-'||jaql967mda||'-'||jaql967pap||'-'||jaql967cta||'-'||jaql967oper||'-'||jaql967sbop||'-'||jaql967top) NroCre,
       sum(jaql967s15)  Saldo15,
       decode (sum(jaql967salj) , 0,0 , round((sum(jaql967s15) / sum(jaql967salj))*100, 2)) Mora15,
       sum(jaql967s30)  Saldo30, 
       decode (sum(jaql967salj) , 0,0 , round((sum(jaql967s30) / sum(jaql967salj))*100, 2)) Mora30,
       sum(jaql967sju) SaldoJu,
       sum(jaql967sve) SaldoVe,
       sum(jaql967sre) SaldoRe,
       count(DISTINCT case when jaql967crju > 0 then jaql967mod||'-'||jaql967suc||'-'||jaql967mda||'-'||jaql967pap||'-'||jaql967cta||'-'||jaql967oper||'-'||jaql967sbop||'-'||jaql967top end) NumCreJu,
       count(DISTINCT case when jaql967crve > 0 then jaql967mod||'-'||jaql967suc||'-'||jaql967mda||'-'||jaql967pap||'-'||jaql967cta||'-'||jaql967oper||'-'||jaql967sbop||'-'||jaql967top end) NumCreVe,
       count(DISTINCT case when jaql967crre > 0 then jaql967mod||'-'||jaql967suc||'-'||jaql967mda||'-'||jaql967pap||'-'||jaql967cta||'-'||jaql967oper||'-'||jaql967sbop||'-'||jaql967top end) NumCreRe,
       COUNT(DISTINCT case when jaql967clju > 0 then jaql967tdoc||'-'||jaql967ndoc end ) NumCliJu,
       COUNT(DISTINCT case when jaql967clve > 0 then jaql967tdoc||'-'||jaql967ndoc end ) NumCliVe,
       COUNT(DISTINCT case when jaql967clre > 0 then jaql967tdoc||'-'||jaql967ndoc end ) NumCliRe
  from jaql967
 where jaql967fec = ld_fecpro--to_date('2013.08.08', 'yyyy.mm.dd')
 group by jaql967fec, jaql967reg,jaql967ren, jaql967suc,jaql967age,jaql967ana
 order by jaql967reg,jaql967suc,jaql967ana;

 cursor saldocastigado is
      select pd_fecpro fecha,j.jaql968reg, sum(nvl(jaql968sca,0)) salcas 
        from jaql968 j
      where jaql968fec  >=  TO_DATE('01/' || EXTRACT(MONTH FROM pd_fecpro ) || '/' ||EXTRACT(YEAR FROM pd_fecpro ),'dd/mm/rrrr')    
        and jaql968fec  <=  pd_fecpro
        and jaql968tip = 1
      group by pd_fecpro,j.jaql968reg;

           
 ln_cont NUMBER;
 ln_numero number:= 0;    
 ln_saldoca number:= 0;       -- 2014.12.23    
 
begin
   delete from jaql968 where jaql968fec = pd_fecpro; --CASO DE REPROCESAMIENTO    
   commit;  
   
   begin      
       select count(*)   
         into ln_numero       
        from jaql968;
   exception when no_data_found then
       ln_numero := 0;              
   end;
   ln_numero := ln_numero + 1;              

   for i in region(pd_fecpro) loop
       insert into jaql968 (
                JAQL968COR, jaql968tip, jaql968fec, jaql968reg, jaql968ren, jaql968cod, jaql968age, jaql968ana, jaql968sal, 
                jaql968salj, jaql968ncl, jaql968ncr, jaql968s15, jaql968p15, jaql968s30, jaql968p30,jaql968sju,--jaql968sca,
                jaql968svi, jaql968sre, jaql968sve, jaql968scat/*, jaql968scac, jaql968pmc*/
               )--1 por region   
       values ( ln_numero,1, pd_fecpro, i.regcod, i.region, 0,'-', '-', i.SaldoCapital,
                i.SaldoCapitalJud, i.NroCli, i.NroCre, i.Saldo15, i.Mora15, i.Saldo30, i.Mora30, i.SaldoJu,--i.SaldoCa,
                i.saldovi, i.saldore, i.saldove, i.saldocat /*, i.saldocac, i.moracas*/
              );
       ln_numero := ln_numero + 1;               
   end loop;  
   commit;

  ln_saldoca := 0;
  /*If(pd_fecpro=last_day(pd_fecpro))     then */
     
     for  h in castigado_mes(pd_fecpro)loop
          update jaql968 j
             set j.jaql968sca = h.SaldoCa
           Where j.jaql968fec = h.ld_fecpro
             and j.jaql968reg = h.regcod
             and j.jaql968tip = 1;
          commit;
          
     end loop;
 
     ----2014.12.23 si es diario cartera castigada es suma desde el primer al ultimo dia generado
     for i in saldocastigado loop
     
       update jaql968 
          set jaql968scac =  nvl(jaql968scat,0) + nvl(i.salcas,0)  
        where jaql968fec = i.fecha
          and jaql968reg = i.jaql968reg
          and jaql968tip = 1;
          
       commit;
     
     end loop;   
     --2014.12.23


  /*else
       for  h in castigado_dia(pd_fecpro)loop
          update jaql968 j
             set j.jaql968sca = h.SaldoCa
           Where j.jaql968fec = h.ld_fecpro
             and j.jaql968reg = h.regcod
             and j.jaql968tip = 1;
          commit;
          
     end loop;
     
     --2014.12.23 si es fin de mes solo se considera la castera castigada de la fecha de proceso    
       update jaql968 
          set jaql968scac =  nvl(jaql968scat,0) + nvl(ln_saldoca,0)  
        where jaql968fec  =  pd_fecpro   
          and jaql968tip = 1;
       commit;
     --2014.12.23
     
  End if;*/

   ---////obtener sumatoria de toda la cartera
   ---///%MORA = Cartera Atrasada / Cartera Total
   ---///%MORA con castigos  = Cartera Atrasada con Castigos / Cartera Total
   
   


   for i in agencia(pd_fecpro) loop
       insert into jaql968 (
                JAQL968COR, jaql968tip, jaql968fec, jaql968reg, jaql968ren, jaql968cod, jaql968age, jaql968ana, jaql968sal, 
                jaql968salj, jaql968ncl, jaql968ncr, jaql968s15, jaql968p15, jaql968s30, jaql968p30,jaql968sju 
               )--2 por agencia
       values ( ln_numero, 2, pd_fecpro, i.regcod, i.region, i.agecod, i.agencia, '-', i.SaldoCapital,
                i.SaldoCapitalJud, i.NroCli, i.NroCre, i.Saldo15, i.Mora15, i.Saldo30, i.Mora30, i.SaldoJu
              );
       ln_numero := ln_numero + 1;        
   end loop;  
   commit;

   for i in analista(pd_fecpro) loop
       insert into jaql968 (
                JAQL968COR, jaql968tip, jaql968fec, jaql968reg, jaql968ren, jaql968cod, jaql968age, jaql968ana, jaql968sal, 
                jaql968salj, jaql968ncl, jaql968ncr, jaql968s15, jaql968p15, jaql968s30, jaql968p30,jaql968sju,
                jaql968sve, jaql968sre, jaql968crju, jaql968crve, jaql968crre, jaql968clju, jaql968clve, jaql968clre 
               )--3 por analista
       values ( ln_numero, 3, pd_fecpro, i.regcod, i.region, i.agecod, i.agencia, nvl(i.analista,'-'), i.SaldoCapital,
                i.SaldoCapitalJud, i.NroCli, i.NroCre, i.Saldo15, i.Mora15, i.Saldo30, i.Mora30, i.SaldoJu,
                i.saldove , i.saldore, i.numcreju, i.NumCreVe, i.numcrere, i.numcliju, i.numclive, i.numclire
              );
       ln_numero := ln_numero + 1;        
   end loop;  
   commit;

--comentado por que ya no existe db link simweb*
/*20210609 dcastro, se comento db link @simweb
  delete from  JAQL680@simweb;
   commit;
   
   --BASE FUERA DE DMZ
   insert into JAQL680@simweb
     (JAQL968FEC,
      JAQL968REG,
      JAQL968COD,
      JAQL968ANA,
      JAQL968COR,
      JAQL968REN,
      JAQL968AGE,
      JAQL968SAL,
      JAQL968SALJ,
      JAQL968NCL,
      JAQL968NCR,
      JAQL968S15,
      JAQL968P15,
      JAQL968S30,
      JAQL968P30,
      JAQL968SJU,
      JAQL968SVE,
      JAQL968SRE,
      JAQL968CRJU,
      JAQL968CRVE,
      JAQL968CRRE,
      JAQL968CLJU,
      JAQL968CLVE,
      JAQL968CLRE,
      JAQL968TIP,
      JAQL968SCA,
      JAQL968SVI,
      JAQL968SCAT,
      JAQL968SCAC)
     select JAQL968FEC,
            JAQL968REG,
            JAQL968COD,
            JAQL968ANA,
            JAQL968COR,
            JAQL968REN,
            JAQL968AGE,
            JAQL968SAL,
            JAQL968SALJ,
            JAQL968NCL,
            JAQL968NCR,
            JAQL968S15,
            JAQL968P15,
            JAQL968S30,
            JAQL968P30,
            JAQL968SJU,
            JAQL968SVE,
            JAQL968SRE,
            JAQL968CRJU,
            JAQL968CRVE,
            JAQL968CRRE,
            JAQL968CLJU,
            JAQL968CLVE,
            JAQL968CLRE,
            JAQL968TIP,
            JAQL968SCA,
            JAQL968SVI,
            JAQL968SCAT,
            JAQL968SCAC
       from jaql968
     where jaql968fec in ( 
          select pgfape-1
          from fst017
          where pgcod = 1
        union 
          select pgfape-2
          from fst017
          where pgcod = 1       
        union
           select pgfape-3
           from fst017
           where pgcod = 1       
        union      
        select  LAST_DAY(ADD_MONTHS(pgfape, -1)) --/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -1)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -1)))--* /
          from fst017
         where pgcod = 1
        union
        select LAST_DAY(ADD_MONTHS(pgfape, -2))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -2)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -2)))--* /
          from fst017
         where pgcod = 1
        union
        select LAST_DAY(ADD_MONTHS(pgfape, -3))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -3)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -3)))--* /
          from fst017
         where pgcod = 1

        union
        select LAST_DAY(ADD_MONTHS(pgfape, -4))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -4)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -4)))--* /
          from fst017
         where pgcod = 1

        union
        select LAST_DAY(ADD_MONTHS(pgfape, -5))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -5)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -5)))--* /
          from fst017
         where pgcod = 1
        union
        select LAST_DAY(ADD_MONTHS(pgfape, -6)) /*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -6)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -6)))--* /
          from fst017
         where pgcod = 1
        union
        select LAST_DAY(ADD_MONTHS(pgfape, -7))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -7)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -7)))--* /
          from fst017
         where pgcod = 1
       union
        select LAST_DAY(ADD_MONTHS(pgfape, -8))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -8)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -8)))--* /
          from fst017
         where pgcod = 1
        union
        select LAST_DAY(ADD_MONTHS(pgfape, -9))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -9)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -9)))--* /
          from fst017
         where pgcod = 1
        union
        select LAST_DAY(ADD_MONTHS(pgfape, -10))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -10)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -10)))--* /
          from fst017
         where pgcod = 1
        union
        select LAST_DAY(ADD_MONTHS(pgfape, -11))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -11)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -11)))--* /
          from fst017
         where pgcod = 1
        union
        select LAST_DAY(ADD_MONTHS(pgfape, -12))/*decode(EXTRACT(YEAR FROM TO_DATE(LAST_DAY(ADD_MONTHS(pgfape, -11)))),
                      EXTRACT(YEAR FROM TO_DATE(pgfape)),
                      LAST_DAY(ADD_MONTHS(pgfape, -11)))--* /
          from fst017
         where pgcod = 1 )and jaql968tip = 1 ;       
      /*  union
        select ADD_MONTHS(TRUNC(pgfape, 'YEAR'), -1) + 30
          from fst017
         where pgcod = 1
         )  and jaql968tip = 1;

   commit;*/
 end sp_cr_inserta_tabla;
 

end PQ_CR_SALDOS_COMPARATIVOS;
/

