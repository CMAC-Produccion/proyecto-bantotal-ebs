create or replace package PQ_RIESGOS_CALIFICACION is

  -- Author  : ABERNEDO
  -- Created : 22/08/2014 11:12:03 a.m.
  -- Purpose : Proceso Calificacion de Agencias
  Procedure sp_job_Query1 (pd_fecpro in date );
  Procedure SP_Query1 (pn_numsuc in number, pd_fecpro in date ) ;
  Procedure SP_Query1_II(pd_fecpro in date);
  Procedure sp_job_Query2 (pd_fecpro in date );
  Procedure SP_Query2_II (pn_numsuc in number, pd_fecpro in date ) ;
  --Procedure SP_Query2(pd_fecpro in date);
  Function Fn_instancia(pn_emp in number,pn_suc in number,pn_mod in number,pn_mda in number,
                      pn_pap in number, pn_cta in number, pn_ope in number, pn_sbo in number,
                      pn_top in number) return number;
end PQ_RIESGOS_CALIFICACION;
/

create or replace package body PQ_RIESGOS_CALIFICACION is

Procedure sp_job_Query1 (pd_fecpro in date ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_hostname varchar2(64);
  --lc_coderr varchar2(300);
  cursor sucursal is
  select sucurs from fst001 where pgcod =1 ;
  begin
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table JAQY299');
     delete Tab_jobs where  c_Codage = 'QY';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  PQ_RIESGOS_CALIFICACION.SP_Query1('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
        DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 1,
                      --instance => 2, 01/01/2024
                      force => false
                      );
        else
          DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
          end if;
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('QY',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'QY',lc_variable, TRUNC(SYSDATE));
           COMMIT;
end sp_job_Query1;

Procedure SP_Query1 (pn_numsuc in number, pd_fecpro in date ) is

cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50));
lc_coderr varchar2(300);

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'QY';
  commit;
  for i in rubro loop
     begin

       insert into JAQY299(PGCOD,SCMOD,SCSUC,SCMDA,SCPAP,SCCTA,SCOPER,SCSBOP,SCTOPE,SCSTAT,SCGRU,
                             SCRUB,SCSDO,DIAS_ATRASO,SECTOR,INSTANCIA)
        -- select /*+all_rows parallel(a,4,1)*/
         select /*+all_rows*/
                   a.pgcod, 
                   a.scmod, 
                   a.scsuc, 
                   a.scmda,
                   a.scpap, 
                   a.sccta, 
                   a.scoper, 
                   a.scsbop,
                   a.sctope, 
                   a.scstat, 
                   a.scgru, 
                   a.scrub, 
                   a.scsdo,
                   fn_dias_atraso(pd_fecpro, --'27/11/2013'
                                  a.pgcod, a.scmod, a.scsuc, a.scmda,
                                  a.scpap, a.sccta, a.scoper, a.scsbop,
                                  a.sctope, a.scstat, a.scfvto) dias_atraso,
                   fn_sector_credito(pd_fecpro,--'27/11/2013'
                                     pgcod, scmod, scsuc, scmda,
                                     scpap, sccta, scoper, scsbop,
                                     sctope) sector,
                   pq_riesgos_calificacion.Fn_instancia(a.pgcod,a.scsuc,a.scmod,a.scmda,a.scpap,
                                                        a.sccta,a.scoper,a.scsbop,a.sctope)
              from fsd011 a
             where a.pgcod = 1
               and a.scrub = i.rubro
               and a.scsuc = pn_numsuc
               
               /*and (scrub like '1411%' or scrub like '1421%' or scrub like '1414%' or
                    scrub like '1424%' or scrub like '1415%' or scrub like '1425%')
               and exists (select modulo 
                             from FST111 f11 
                            where DsCOD = 50 
                              and a.scmod = f11.modulo) -- 351746*/
                
               and scstat not in (90, 99, 64)
               and (scgru = 2 or scgru = 13);
         commit;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'QY',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'QY';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'QY';
    commit;
    return;

end SP_Query1;

Procedure SP_Query1_II(pd_fecpro in date)is

begin
     execute immediate ('truncate table JAQY300');     
     begin
          
          insert into JAQY300(PGCOD,SCMOD,SCSUC,SCMDA,SCPAP,SCCTA,SCOPER,SCSBOP,SCTOPE,SCSTAT,SCGRU,
                             SCRUB,SCSDO,DIAS_ATRASO,SECTOR,INSTANCIA)
                             
          select aa.pgcod,
                 aa.scmod,
                 aa.scsuc,
                 aa.scmda,
                 aa.scpap,
                 aa.sccta,
                 aa.scoper,
                 aa.scsbop,
                 aa.sctope,
                 aa.scstat,
                 aa.scgru,
                 aa.scrub,
                 aa.scsdo,
                 aa.dias_atraso,
                 aa.sector,
                 aa.instancia
            from jaqy299 aa   
           where (scrub like '1411%' or scrub like '1421%' or scrub like '1414%' or
                    scrub like '1424%' or scrub like '1415%' or scrub like '1425%');                          
     
     
     commit;
     end;



end SP_Query1_II;


Procedure sp_job_Query2 (pd_fecpro in date ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_hostname varchar2(64);
  --lc_coderr varchar2(300);
  cursor sucursal is
  select sucurs from fst001 where pgcod =1 ;
  begin
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table CREDTMP');
     delete Tab_jobs where  c_Codage = 'QYS';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  PQ_RIESGOS_CALIFICACION.SP_Query2_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
        DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 1,
                      --instance => 2, 01/01/2024
                      force => false
                      );
else
      DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
  end if;
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('QYS',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'QYS',lc_variable, TRUNC(SYSDATE));
           COMMIT;
end sp_job_Query2;

Procedure SP_Query2_II (pn_numsuc in number, pd_fecpro in date ) is

ln_mongar_s number;
 ln_mongar_d number;
 ln_tipcam number;
        
 ln_monsol number;
 ln_mondol number;              
 lc_desgar varchar2(2000);        
 lc_tonom char(30);
 ln_AOPERIOD number(5);
 ln_CANENT number(3);
 ln_fecha number(9);
 lc_fecha char(8);
 ld_fecha date;
 LC_CODSBS varCHAR2(10);
 LN_SALDOCCI NUMBER(17,2);
 lc_documento varchar2(15);
 lc_SNG001ASE char(10);
 lc_SNG001USC char(10);
 ln_numcsinp number(3); -- numero de cuotas atrasadas sin pagar mayores a 5 
 ln_numcatra number(3); -- numero de cuotas pagadas con atrasos mayores a 5
 ln_jaql157ani number(4);
 ln_jaql157mes number(2);
 lc_jaql157sob char(1);
 lc_desalerta char(45);
 lc_actnom1 char(60);       
 ln_sng001inst NUMBER(10);
 lc_desaval CHAR(40);--TIENE AVAL O AVALISTA
 ln_contaval NUMBER(4);
 ln_contavta NUMBER(4);
 ln_deudir number(18,2);
 ln_deupot number(18,2);
 ln_patrim number(18,2);
 ln_ratdpa number(10,2);
       
 ------------------------------ INDICADOR CUOTA/RESULTADO NETO            
 ln_cpeque number(18,2);-- cuota pequeña
 ln_cmicro number(18,2);-- cuota microempresa
 ln_cnrevo number(18,2);-- cuota consumo no revolvente
 ln_crevol number(18,2);-- cuota consumo revolvente
 ln_chipot number(18,2);-- cuota hipotecario
 ln_cexpeq_1 number(18,2);-- cuota exposicion equivalente - consumo
 ln_cexpeq_2 number(18,2);-- cuota exposicion equivalente - pequeño
 ln_cexpeq_3 number(18,2);-- cuota exposicion equivalente - micro
 ln_resnet number(18,2);-- Resultado Neto
       
 ln_csifin number(18,2);-- cuota sistema financiero
 ln_csifin_1 number(18,2);-- cuota sistema financiero
 ln_csifin_2 number(18,2);-- cuota sistema financiero
 ln_csifin_3 number(18,2);-- cuota sistema financiero              
            
 ln_tpeque number(10,7);-- tasa mensual pequeña empresa
 ln_tmicro number(10,7);-- tasa mensual microempresa
 ln_tconsu number(10,7);-- tasa mensual consumo
 ln_thipot number(10,7);-- tasa mensual hipotecario
            
 ln_npeque number(5);-- número de meses pequeña empresa
 ln_nmicro number(5);-- número de meses microempresa
 ln_nhipot number(5);-- número de meses hipotecario
            
 ln_nconsr number(5);-- número de meses consumo revolvente
 ln_nconsn number(5);-- número de meses no revolvente

 ln_tdoctr number(9);
       
 ln_ratcrn number(10,2); -- ratio cuota / resultado neto
 -----------------------------
 LN_C1PEQU  NUMBER(18,2); --CUOTA PEQUEÑA EMPRESA - NORMAL
 LN_C1MICR  NUMBER(18,2); --CUOTA MICROEMPRESA - NORMAL 
 LN_C1REVO  NUMBER(18,2); --CUOTA CONSUMO REVOLVENTE - NORMAL
 LN_C1NREV  NUMBER(18,2); --CUOTA CONSUMO NO REVOLVENTE - NORMAL
 LN_C1HIPO  NUMBER(18,2); --CUOTA HIPOTECARIO - NORMAL 
 LN_C2PEQU  NUMBER(18,2); --CUOTA PEQUEÑA EMPRESA - FCC CAJA
 LN_C2MICR  NUMBER(18,2); --CUOTA MICROEMPRESA - FCC CAJA
 LN_C2REVO  NUMBER(18,2); --CUOTA CONSUMO REVOLVENTE - FCC CAJA
 LN_C2NREV  NUMBER(18,2); --CUOTA CONSUMO NO REVOLVENTE - FCC CAJA
 LN_C2HIPO  NUMBER(18,2); --CUOTA HIPOTECARIO - FCC CAJA
 LN_C3PEQU  NUMBER(18,2); --CUOTA PEQUEÑA EMPRESA - FCC SISTEMA FIANCIERO
 LN_C3MICR  NUMBER(18,2); --CUOTA MICROEMPRESA - FCC SISTEMA FIANCIERO
 LN_C3REVO  NUMBER(18,2); --CUOTA CONSUMO REVOLVENTE - FCC SISTEMA FIANCIERO
 LN_C3NREV  NUMBER(18,2); --CUOTA CONSUMO NO REVOLVENTE - FCC SISTEMA FIANCIERO
 LN_C3HIPO  NUMBER(18,2); --CUOTA HIPOTECARIO - FCC SISTEMA FIANCIERO         
------------------------------           
 LN_AOIMP NUMBER(17,2); -- MONTO DEL CRÉDITO OTORGADO, 
 LC_MDNOM CHAR(30); -- DESTINO DEL CRÉDITO, COMPRA DE DEUDA, ACTIVO FIJO 
 ld_fectmp date;
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50));
lc_coderr varchar2(300);


cursor creditos_atraso(pn_numsuc in number,rubro in number) is
            select (select z.tdnom 
                      from fst014 z 
                     where z.tdocum = datos.petdoc) tdnom,
                   (lpad(datos.sccta, 9,'0')|| lpad(datos.scmod,3,'0')|| lpad(datos.scmda,3,'0')||lpad(datos.scoper,9,'0')) num_cta,
                   (select p.scnom 
                      from fst001 p 
                     where p.pgcod = 1
                       and p.sucurs = datos.scsuc) scnom,
                   case
                     when datos.scgru = 2 then 'MICROEMPRESAS'
                     when datos.scgru = 13 then 'PEQUEÑA EMPRESA'
                   end TIPSBS,
                   datos.sector PASCMA,
                   case
                     when substr(datos.scrub,1,4) = '1411' or substr(datos.scrub,1,4) = '1421' or
                          substr(datos.scrub,1,4) = '1415' or substr(datos.scrub,1,4) = '1425' then 'VIGENTE'
                     when substr(datos.scrub,1,4) = '1414' or substr(datos.scrub,1,4) = '1424' then 'REFINANCIADO'
                   end c_descon,
                   case
                     when substr(datos.scrub,1,4) = '1415' or substr(datos.scrub,1,4) = '1425' then 'CRÉDITO VENCIDO'
                     else 'CRÉDITO NORMAL MOROSO'
                   end c_escon, -- ESTADO CONTABLE
                   case
                     when datos.sng001ori = 4 and datos.cant_cuentas > 1 then 'CRÉDITO AMPLIADO'
                     when datos.scmod = 116 or datos.scmod = 117 then 'CRÉDITO AUTOMÁTICO'
                     when datos.sng001tpcr = 1 or datos.cant_cuentas = 1 then 'CRÉDITO NUEVO'
                     when datos.scmod = 105 then 'CRÉDITO PARALELO'
                     when datos.sng001tpcr = 2 or datos.cant_cuentas > 1 then 'CRÉDITO RECURRENTE'
                   end TIP_CREDITO,
                   datos.scsdo saldo_capital, --revisar       
                   datos.*,
                   PQ_CR_jaql964_cartera.fn_cr_monto(datos.SCMOD, datos.SCCTA, datos.SCOPER, datos.SCSBOP, datos.SCTOPE,
                                                     datos.SCSUC, datos.SCMDA) MONTO_APROB,
                   (select max(case
                                 when fsd602.pp1fech is null then case when trunc(SYSDATE - fsd601.ppfpag)>0  
                                                                            then trunc(SYSDATE - fsd601.ppfpag) 
                                                                  else 0 end
                                 when fsd602.pp1fech is not null then case when fsd602.pp1fech- fsd601.ppfpag > 0  
                                                                                then  fsd602.pp1fech - fsd601.ppfpag 
                                                                      else 0 end
                               end) dias_atraso
                      from fsd601
                      left outer join (select distinct max(fsd602.pp1fech) pp1fech, 
                                                           fsd602.ppfpag, 
                                                           fsd602.pp1stat, 
                                                           fsd602.pgcod , 
                                                           fsd602.ppmod, 
                                                           fsd602.ppsuc,
                                                           fsd602.ppmda, 
                                                           fsd602.pppap, 
                                                           fsd602.ppcta,
                                                           fsd602.ppoper, 
                                                           fsd602.ppsbop, 
                                                           fsd602.pptope
                                         from fsd602
                                        where fsd602.d602co='S'
                                        group by fsd602.ppfpag,
                                                 fsd602.pp1stat,
                                                 fsd602.pgcod ,
                                                 fsd602.ppmod,
                                                 fsd602.ppsuc, 
                                                 fsd602.ppmda,
                                                 fsd602.pppap,
                                                 fsd602.ppcta,
                                                 fsd602.ppoper, 
                                                 fsd602.ppsbop,
                                                 fsd602.pptope
                                        order by fsd602.ppfpag asc,
                                                 fsd602.pgcod ,
                                                 fsd602.ppmod,
                                                 fsd602.ppsuc, 
                                                 fsd602.ppmda,
                                                 fsd602.pppap,
                                                 fsd602.ppcta,
                                                 fsd602.ppoper, 
                                                 fsd602.ppsbop,
                                                 fsd602.pptope) fsd602
                                 on (fsd602.pgcod =fsd601.pgcod 
                                 and fsd602.ppmod=fsd601.ppmod 
                                 and fsd602.ppsuc=fsd601.ppsuc 
                                 and fsd602.ppmda=fsd601.ppmda 
                                 and  fsd602.pppap=fsd601.pppap 
                                 and fsd602.ppcta=fsd601.ppcta 
                                 and fsd602.ppoper=fsd601.ppoper
                                 and fsd602.ppsbop=fsd601.ppsbop 
                                 and fsd602.pptope=fsd601.pptope 
                                 and fsd602.ppfpag=fsd601.ppfpag)
                     where fsd601.d601co='S'
                       and fsd601.pgcod = datos.pgcod
                       and fsd601.ppmod= datos.scmod
                       and fsd601.ppsuc = datos.scsuc
                       and fsd601.ppmda= datos.scmda
                       and fsd601.pppap = datos.scpap
                       and fsd601.ppcta= datos.sccta
                       and fsd601.ppoper=datos.scoper
                       and fsd601.ppsbop=datos.scsbop
                       and fsd601.pptope=datos.sctope) DIAS_MAX_ATRASO
          -- from (select /*+parallel (c,4), (t1,4), (t2,4)*/
           from (select 
                        c.*,
                        x.pepais, 
                        x.petdoc, 
                        x.pendoc, 
                        x.penom, 
                        x.petipo,
                        (select z.sng001ori 
                           from sng001 z 
                          where z.sng001inst = c.instancia) sng001ori,           
                        (select z.sng001tpcr 
                           from sng001 z 
                          where z.sng001inst = c.instancia) sng001tpcr,
                        (select count(t1.pgcod) 
                           from fsd010 t1, 
                                fsr008 t2, 
                                fst111 t4  
                          where t1.pgcod = 1 
                            and t1.aocta  = t2.ctnro
                            and t2.PEPAIS = x.pepais
                            and t2.PETDOC = x.petdoc
                            and t2.pendoc = x.pendoc
                            and t2.cttfir ='T'
                            and t1.aocta = t2.ctnro
                            and t4.dscod=50 
                            and t4.modulo = t1.aomod) CANT_CUENTAS,
                         (select count(t1.pgcod) 
                            from fsd010 t1, 
                                 fsr008 t2, 
                                 fst111 t4  
                           where t1.pgcod = 1 
                             and t1.aocta  = t2.ctnro
                             and t2.PEPAIS = x.pepais
                             and t2.PETDOC = x.petdoc
                             and t2.pendoc = x.pendoc
                             and t2.cttfir ='T'
                             and t1.aocta = t2.ctnro
                             and t4.dscod=50 
                             and t4.modulo = t1.aomod
                             and t1.aostat <> 99) CANT_CUENTAS_V
                   from jaqy300 c, 
                        fsd001 x, 
                        fsr008 y
                  where c.scrub = rubro
                    and c.scsuc = pn_numsuc
                    and c.dias_atraso <60 
                    and (c.sector <> 1 or c.sector is null)
                    and y.ctnro = c.sccta
                    and x.pepais = y.pepais 
                    and x.petdoc = y.petdoc 
                    and x.pendoc = y.pendoc 
                    and y.cttfir = 'T') datos;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'QYS';
  commit;
  BEGIN
          select tpnro 
            into ln_fecha
            from Fst098 
           Where pgcod = 1 
             and Tpcod = 7647 
             and Tpcorr = 12;
        exception
          when no_data_found then
               ln_fecha := 0;
        END;      
        ld_fectmp := to_date(ln_fecha,'ddmmyyyy');
        ln_jaql157ani := to_number(to_char(ld_fectmp,'yyyy'));
        ln_jaql157mes := to_number(to_char(ld_fectmp,'mm'));
        
        --ln_fecha := 30062014;--30062013; -- temporal
        lc_fecha := to_char(ln_fecha);
        ld_fecha := to_date(lc_fecha,'ddmmyyyy');
  for i in rubro loop
     for cred in creditos_atraso(pn_numsuc,i.rubro) loop      
               
        begin
        
            pq_metodologia.proc_garantias( cred.PGCOD, cred.SCMOD, cred.SCSUC, cred.SCMDA,
              cred.SCPAP, cred.SCCTA, cred.SCOPER, cred.SCSBOP, cred.SCTOPE, ln_monsol, 
              ln_mondol, lc_desgar             
            );
            ------------------------------
            BEGIN
              select TONOM
                into lc_tonom
                from fst004 
               where MODULO = cred.SCMOD 
                 and TOTOPE = cred.SCTOPE;
            exception
              when no_data_found then
                   lc_tonom := '';
            END;
            ------------------------------
            BEGIN
              select MDNOM
                into LC_MDNOM
                from fst003
               where MODULO = cred.SCMOD;
            exception
              when no_data_found then
                   LC_MDNOM := '';
            END;                        
            ------------------------------
            BEGIN
              select AOPERIOD, 
                     AOIMP 
                into ln_AOPERIOD, 
                     LN_AOIMP
                from fsd010 
               where PGCOD = cred.PGCOD
                 and AOMOD = cred.SCMOD
                 and AOSUC = cred.SCSUC
                 and AOMDA = cred.SCMDA
                 and AOPAP = cred.SCPAP
                 and AOCTA = cred.SCCTA
                 and AOOPER = cred.SCOPER
                 and AOSBOP = cred.SCSBOP
                 and AOTOPE = cred.SCTOPE;
            exception
              when no_data_found then
                ln_AOPERIOD := 0;   
                LN_AOIMP := 0;           
            END;
            
            ------------------------------ DATOS CCI            
            
            lc_documento := Trim(cred.PENDOC);
            
            ------------------------------  BUSCAMOS EL C_CODSBS            
            BEGIN
              select f.TP1CORR3 
                into ln_tdoctr 
                from FST198 f
               Where f.Tp1cod   = 1
                 and f.Tp1cod1  = 11111
                 and f.Tp1corr1 = 1
                 and f.Tp1corr2 = 3
                 and f.TP1NRO1  = cred.PETDOC;
            EXCEPTION
              when no_data_found then
              ln_tdoctr := 0;
            END;
            
            ------------------------------
            /*
            BEGIN 
              select a.C_CODSBS, 
                     a.N_CANENT 
                into LC_CODSBS, ln_CANENT
                from cldrcci a
               where a.d_fecpre = ld_fecha 
                 and ((a.C_DOCTRI = lc_documento and a.C_TDOCTR = to_char(ln_tdoctr))OR
                      (C_DOCIDE = lc_documento and C_TDOCID = to_char(ln_tdoctr)))
                 and c_person = (case cred.PETIPO when 'F' then 1
                                                  when 'J' then 2
                                 end)
                 and rownum = 1;            
            
            EXCEPTION
              when no_data_found then
                   LC_CODSBS := '0';            
            END;*/
            
            if cred.petipo = 'F' then
               
               BEGIN 
                  select a.C_CODSBS, 
                         a.N_CANENT 
                    into LC_CODSBS, ln_CANENT
                    from cldrcci a
                   where a.c_tdocid = to_char(ln_tdoctr)
                     and a.c_docide = lc_documento
                     and a.d_fecpre = ld_fecha 
                     and a.c_person = 1
                     and rownum = 1;
                       
            
               EXCEPTION
                 when no_data_found then
                   LC_CODSBS := '0';            
               END;
            
               else
                   
                   BEGIN 
                      select a.C_CODSBS, 
                             a.N_CANENT 
                        into LC_CODSBS, ln_CANENT
                        from cldrcci a
                       where a.C_DOCTRI = lc_documento
                         and a.d_fecpre = ld_fecha 
                         and a.c_person = 2
                         and rownum = 1;
       
                
                   EXCEPTION
                     when no_data_found then
                       LC_CODSBS := '0';            
                   END;
               
            end if;
            
            
            
            ------------------------------  MONTO CCI
            
            BEGIN
            select sum(N_SALCAP) 
              into LN_SALDOCCI
              from cldrccs  
             where d_fecpre = ld_fecha 
               and c_codsbs = LC_CODSBS ;
            exception
              when no_data_found then
                   LN_SALDOCCI := 0;
            END;
            
            ------------------------------ ANALISTA RESPONSABLE, ANALISTA EMISOR
            BEGIN 
              select SNG001ASE , 
                     SNG001USC 
                into lc_SNG001ASE, 
                     lc_SNG001USC
                from sng001 
               where sng001inst = cred.instancia;
              exception
                when no_data_found then
                  lc_SNG001ASE := '';
                  lc_SNG001USC := '';
            END;            
            
            ------------------------------ CUOTAS SIN PAGAR CON ATRASO
            
            BEGIN 
              select count(PGCOD) 
                into ln_numcsinp 
                from (select fsd601.PGCOD, 
                             fsd601.PPMOD, 
                             fsd601.PPSUC,  
                             fsd601.PPMDA, 
                             fsd601.PPPAP,  
                             fsd601.PPCTA,  
                             fsd601.PPOPER, 
                             fsd601.PPSBOP, 
                             fsd601.PPTOPE, 
                             fsd601.PPFPAG,
                             (select count(b.PGCOD) 
                                from fsd602 b 
                               where b.PGCOD = fsd601.PGCOD 
                                 and b.PPMOD = fsd601.PPMOD 
                                 and b.PPSUC = fsd601.PPSUC 
                                 and b.PPMDA = fsd601.PPMDA 
                                 and b.PPPAP = fsd601.PPPAP 
                                 and b.PPCTA = fsd601.PPCTA 
                                 and b.PPOPER = fsd601.PPOPER 
                                 and b.PPSBOP = fsd601.PPSBOP 
                                 and b.PPTOPE = fsd601.PPTOPE 
                                 and b.PPFPAG = fsd601.PPFPAG
                                 and pp1stat = 'T') PAGOS_T,
                             fsd601.ppfpag fsd601_ppfpag, 
                             --fsd602.ppfpag fsd602_ppfpag, 
                             --fsd602.pp1fech fsd602_pp1fech, 
                             --fsd602.pp1stat,
                             case when trunc(SYSDATE - fsd601.ppfpag)>0 then trunc(SYSDATE - fsd601.ppfpag) 
                                  else 0 
                             end dias_atraso
                             /*(case
                                when fsd602.pp1fech is null then case when trunc(SYSDATE - fsd601.ppfpag)>0  
                                                                           then trunc(SYSDATE - fsd601.ppfpag) 
                                                                      else 0 
                                                                 end
                                when fsd602.pp1fech is not null then case when fsd602.pp1fech- fsd601.ppfpag > 0  
                                                                               then  fsd602.pp1fech - fsd601.ppfpag 
                                                                          else 0 
                                                                     end
                              end) dias_atraso*/
                        from fsd601
                        /*left outer join (select distinct max(fsd602.pp1fech) pp1fech, 
                                                         fsd602.ppfpag, 
                                                         fsd602.pp1stat, 
                                                         fsd602.pgcod , 
                                                         fsd602.ppmod, 
                                                         fsd602.ppsuc,
                                                         fsd602.ppmda, 
                                                         fsd602.pppap, 
                                                         fsd602.ppcta,
                                                         fsd602.ppoper, 
                                                         fsd602.ppsbop, 
                                                         fsd602.pptope
                                                    from fsd602
                                                   where fsd602.d602co='S'
                                                group by fsd602.ppfpag,
                                                         fsd602.pp1stat,
                                                         fsd602.pgcod ,
                                                         fsd602.ppmod,
                                                         fsd602.ppsuc, 
                                                         fsd602.ppmda,
                                                         fsd602.pppap,
                                                         fsd602.ppcta,
                                                         fsd602.ppoper, 
                                                         fsd602.ppsbop,
                                                         fsd602.pptope
                                                order by fsd602.ppfpag asc,
                                                         fsd602.pgcod ,
                                                         fsd602.ppmod,
                                                         fsd602.ppsuc, 
                                                         fsd602.ppmda,
                                                         fsd602.pppap,
                                                         fsd602.ppcta,
                                                         fsd602.ppoper, 
                                                         fsd602.ppsbop,
                                                         fsd602.pptope) fsd602
                                     on (fsd602.pgcod =fsd601.pgcod 
                                     and fsd602.ppmod=fsd601.ppmod 
                                     and fsd602.ppsuc=fsd601.ppsuc 
                                     and fsd602.ppmda=fsd601.ppmda 
                                     and fsd602.pppap=fsd601.pppap 
                                     and fsd602.ppcta=fsd601.ppcta 
                                     and fsd602.ppoper=fsd601.ppoper
                                     and fsd602.ppsbop=fsd601.ppsbop 
                                     and fsd602.pptope=fsd601.pptope 
                                     and fsd602.ppfpag=fsd601.ppfpag)*/
                       where fsd601.d601co='S'
                         and fsd601.pgcod = cred.PGCOD
                         and fsd601.ppmod = cred.SCMOD
                         and fsd601.ppsuc = cred.SCSUC
                         and fsd601.ppmda= cred.SCMDA
                         and fsd601.pppap = cred.SCPAP
                         and fsd601.ppcta = cred.SCCTA
                         and fsd601.ppoper = cred.SCOPER
                         and fsd601.ppsbop = cred.SCSBOP
                         and fsd601.pptope = cred.SCTOPE
                         and not exists 
                                        (select ppmod, ppcta,ppoper, pptope,ppfpag 
                                           from fsd602 o
                                          where o.pgcod   = fsd601.pgcod
                                            and o.ppmod   = fsd601.ppmod
                                            and o.ppsuc   = fsd601.ppsuc
                                            and o.ppmda   = fsd601.ppmda
                                            and o.pppap   = fsd601.pppap
                                            and o.ppcta   = fsd601.ppcta
                                            and o.ppoper  = fsd601.ppoper
                                            and o.ppsbop  = fsd601.ppsbop
                                            and o.pptope  = fsd601.pptope
                                            and o.ppfpag  = fsd601.ppfpag
                                            and o.pp1fech  <= pd_fecpro
                                            and o.pp1stat = 'T' 
                                            and o.d602co  = 'S'))t  
               where dias_atraso > 4
                 and PAGOS_T = 0;       
            exception
                when no_data_found then
                     ln_numcsinp := 0;                  
            END;
                       
            ------------------------------
            
            begin
              -- cuotas pagadas con atrasos - final
              select count(pp1stat) 
                into ln_numcatra 
                from (select fsd601.ppfpag fsd601_ppfpag, 
                             fsd602.ppfpag fsd602_ppfpag, 
                             fsd602.pp1fech fsd602_pp1fech, 
                             fsd602.pp1stat,
                             (case
                                when fsd602.pp1fech is null then case when trunc(SYSDATE - fsd601.ppfpag)>0  
                                                                           then trunc(SYSDATE - fsd601.ppfpag) 
                                                                      else 0 
                                                                 end
                                when fsd602.pp1fech is not null then case when fsd602.pp1fech- fsd601.ppfpag > 0  
                                                                               then  fsd602.pp1fech - fsd601.ppfpag 
                                                                          else 0 
                                                                     end
                              end) dias_atraso
                        from fsd601
                         left outer join (select distinct max(fsd602.pp1fech) pp1fech, 
                                                          fsd602.ppfpag, 
                                                          fsd602.pp1stat, 
                                                          fsd602.pgcod , 
                                                          fsd602.ppmod, 
                                                          fsd602.ppsuc,
                                                          fsd602.ppmda, 
                                                          fsd602.pppap, 
                                                          fsd602.ppcta,
                                                          fsd602.ppoper, 
                                                          fsd602.ppsbop, 
                                                          fsd602.pptope
                                                     from fsd602
                                                    where fsd602.d602co='S'
                                                 group by fsd602.ppfpag,
                                                          fsd602.pp1stat,
                                                          fsd602.pgcod ,
                                                          fsd602.ppmod,
                                                          fsd602.ppsuc, 
                                                          fsd602.ppmda,
                                                          fsd602.pppap,
                                                          fsd602.ppcta,
                                                          fsd602.ppoper, 
                                                          fsd602.ppsbop,
                                                          fsd602.pptope
                                                 order by fsd602.ppfpag asc,
                                                          fsd602.pgcod ,
                                                          fsd602.ppmod,
                                                          fsd602.ppsuc, 
                                                          fsd602.ppmda,
                                                          fsd602.pppap,
                                                          fsd602.ppcta,
                                                          fsd602.ppoper, 
                                                          fsd602.ppsbop,
                                                          fsd602.pptope) fsd602
                                      on (fsd602.pgcod =fsd601.pgcod 
                                     and fsd602.ppmod=fsd601.ppmod 
                                     and fsd602.ppsuc=fsd601.ppsuc 
                                     and fsd602.ppmda=fsd601.ppmda 
                                     and fsd602.pppap=fsd601.pppap 
                                     and fsd602.ppcta=fsd601.ppcta 
                                     and fsd602.ppoper=fsd601.ppoper
                                     and fsd602.ppsbop=fsd601.ppsbop 
                                     and fsd602.pptope=fsd601.pptope 
                                     and fsd602.ppfpag=fsd601.ppfpag)
                                   where fsd601.d601co='S'
                                    and  fsd601.pgcod = cred.PGCOD
                                    and  fsd601.ppmod = cred.SCMOD
                                    and  fsd601.ppsuc = cred.SCSUC
                                    and  fsd601.ppmda= cred.SCMDA
                                    and  fsd601.pppap = cred.SCPAP
                                    and  fsd601.ppcta = cred.SCCTA
                                    and  fsd601.ppoper = cred.SCOPER
                                    and  fsd601.ppsbop = cred.SCSBOP
                                    and  fsd601.pptope = cred.SCTOPE)t  
               where dias_atraso > 4
                 and pp1stat = 'T';                      
            exception
                when no_data_found then
                     ln_numcatra := 0;                  
            END;  
                            
            ------------------------------ ALERTA DE SOBREENDEUDAMIENTO
            begin
              select jaql157sob 
                into lc_jaql157sob 
                from jaql157
               where jaql157ani = ln_jaql157ani 
                 and jaql157mes = ln_jaql157mes 
                 and jaql157pai = cred.PEPAIS 
                 and jaql157tdo = cred.PETDOC 
                 and jaql157ndo = cred.PENDOC;
            exception
                when no_data_found then
                     ln_numcatra := 0;                  
            END;
                                         
            case lc_jaql157sob
             when 'S' then
                  lc_desalerta := 'SOBRENDEUDADO';
             when 'E' then
                  lc_desalerta := 'POSIBLEMENTE SOBREENDEUDADO';
             when 'N' then
                  lc_desalerta := 'SIN EVIDENCIA DE SOBREENDEUDAMIENTO/NORMAL';
             when 'I' then        
                  lc_desalerta := 'SIN IDENTIFICACION';
             else
                  lc_desalerta := 'SIN IDENTIFICACION';
            end case;
             
            ------------------------------   ACTIVIDAD ECONOMICA
            BEGIN
              select actnom1 
                into lc_actnom1
                from sngc60 aa, fst750 xx
               where aa.sngc60pais = cred.pepais
                 and aa.sngc60tdoc = cred.PETDOC 
                 and aa.sngc60ndoc = cred.PENDOC
                 and aa.sngc60corr = 0
                 and aa.sngc60acte = xx.actcod1;            
            exception
                when no_data_found then
                     lc_actnom1 := '';
            END;                 
            
            ------------------------------ TIENE AVAL
            ln_contaval := 0;
            ln_contavta := 0;
            BEGIN
              select count(sng003pgc) 
                into ln_contaval
                from sng003
               where sng001inst = cred.instancia;
            exception
                when no_data_found then
                     ln_contaval := 0;
            END;
            ------------------------------ ES AVALISTA
            BEGIN
              select count(sng003pgc) 
                into ln_contavta
                from sng003
               where sng003cta = cred.SCCTA;
            exception
                when no_data_found then
                     ln_contavta := 0;
            END;            
            
            if ln_contaval > 0  and ln_contavta = 0 then
               lc_desaval := 'TIENE AVAL';
            else
                if ln_contavta > 0 and ln_contaval = 0 then
                   lc_desaval :=  'AVALISTA';
                else
                   lc_desaval := 'TIENE AVAL - AVALISTA';
                end if; 
            end if;                        
            
            ------------------------------ INDICADOR PASIVO/PATRIMONIO
            ln_deudir := 0;
            ln_deupot := 0;
            ln_patrim := 0;
            ln_ratdpa := 0;
            
            --Deuda directa
            begin
              select nvl(sum(n_salcap),0) 
                into ln_deudir 
                from cldrccs 
               where d_fecpre = ld_fecha
                 and c_codsbs = LC_CODSBS 
                 and (substr(c_cuenta,1,4) in('1401', '1403', '1404', '1405', '1406', 
                                              '1411', '1413', '1414', '1415', '1416', 
                                              '1421', '1423', '1424', '1425', '1426', 
                                              '1408', '1418', '1428') or 
                      substr(c_cuenta,1,6) in ('810302', '811302', '812302')); 
            exception
                when no_data_found then
                     ln_deudir := 0;                         
            end;
           
            --Deuda potencial
            begin
              select nvl(sum(n_salcap),0) 
                into ln_deupot 
                from cldrccs 
               where d_fecpre = ld_fecha
                 and c_codsbs = LC_CODSBS 
                 and (substr(c_cuenta,1,4) in ('7101', '7111', '7112', '7102', '7112', '7122',
                                               '7103', '7113', '7123', '7104', '7114', '7124') or 
                      substr(c_cuenta,1,6) in ('720501', '720502', '720503', '720504',
                                               '720505', '720506', '720507',
                                               '721501', '721502', '721503', '721504',
                                               '721505', '721506', '721507',
                                               '722501', '722502', '722503', '722504',
                                               '722505', '722506', '722507'));
            exception
                when no_data_found then
                     ln_deupot := 0;               
            end;
            
            --patrimonio            
            begin
              select nvl(sum(sng023mto), 0) into ln_patrim --a1.*, a2.sng026dsc 
              from sng023 a1, sng026 a2
              where a1.sng026cod = a2.sng026cod and
               sng021eval = 
              (
                select p.sng021eval from
                (
                  select a.sng021eval
                    from sng021 a
                   where a.sng021pdoc = cred.PEPAIS
                     and a.sng021tdoc = cred.PETDOC
                     and a.sng021ndoc = cred.PENDOC
                     order by a.sng021fec desc
                )p where rownum = 1     
              ) and (a1.sng026cod = 70);
            exception
                when no_data_found then
                     ln_patrim := 0;               
            end;            
            
            if ln_patrim = 0 or ln_patrim is null then
               ln_ratdpa := 0;
            else
               ln_ratdpa := (ln_deudir+ln_deupot)/nullif(ln_patrim,0);
            end if;    
                    
            ------------------------------ INDICADOR CUOTA/RESULTADO NETO
            -- Tasas efectivas mensuales
            ln_tpeque := 0.0172836;
            ln_tmicro := 0.0235929;
            ln_tconsu := 0.0261997;
            ln_thipot := 0.0072150;          
            -- Número de meses
            ln_nconsr := 36;
            ln_nconsn := 36;            
            ln_npeque := 24;
            ln_nmicro := 24;
            ln_nhipot := 180;           
                                   
            if lc_codsbs <> '0' then
            
              --drc DEUDA DIRECTA
            
              select nvl(sum(n_salcap), 0) 
                into LN_C1PEQU
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha
                 and (substr(c_cuenta,1,4) in ('1401', '1403', '1404', '1405', '1406', 
                                               '1411', '1413', '1414', '1415', '1416', 
                                               '1421', '1423', '1424', '1425', '1426', 
                                               '1408', '1418', '1428')or
                      substr(c_cuenta,1,6) in ('810302', '811302', '812302'))                
                 and c_cretip = '09'; -- 'PEQUEÑA EMPRESA';

              select nvl(sum(n_salcap), 0) 
                into LN_C1MICR
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha
                 and (substr(c_cuenta,1,4) in ('1401', '1403', '1404', '1405', '1406', 
                                               '1411', '1413', '1414', '1415', '1416', 
                                               '1421', '1423', '1424', '1425', '1426', 
                                               '1408', '1418', '1428') or
                      substr(c_cuenta,1,6) in ('810302', '811302', '812302'))                
                 and c_cretip = '10'; -- 'MICROEMPRESA';
                                        
              select nvl(sum(n_salcap), 0) 
                into LN_C1REVO
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha                
                 and (substr(c_cuenta,1,4) in ('1401', '1403', '1404', '1405', '1406', 
                                               '1411', '1413', '1414', '1415', '1416', 
                                               '1421', '1423', '1424', '1425', '1426', 
                                               '1408', '1418', '1428')or
                      substr(c_cuenta,1,6) in ('810302', '811302', '812302'))
                 and c_cretip = '11'; -- 'CON.REVOLVENTE' 

              select nvl(sum(n_salcap), 0) 
                into LN_C1NREV
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha
                 and (substr(c_cuenta,1,4) in ('1401', '1403', '1404', '1405', '1406', 
                                               '1411', '1413', '1414', '1415', '1416', 
                                               '1421', '1423', '1424', '1425', '1426', 
                                               '1408', '1418', '1428')or
                      substr(c_cuenta,1,6) in ('810302', '811302', '812302'))                
                 and c_cretip = '12'; -- 'CON.NO.REVOLVENTE'
                
              select nvl(sum(n_salcap), 0) 
                into LN_C1HIPO
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha
                 and (substr(c_cuenta,1,4) in ('1401', '1403', '1404', '1405', '1406', 
                                               '1411', '1413', '1414', '1415', '1416', 
                                               '1421', '1423', '1424', '1425', '1426', 
                                               '1408', '1418', '1428')or
                      substr(c_cuenta,1,6) in ('810302', '811302', '812302'))                
                 and c_cretip = '13'; -- 'HIPOTECARIO'            
                
              
              -- drc DEUDA POTENCIAL                
              -- Revisar para el caso de otros si su rubro se refiere a micro, pequeña o hipoteca
              -- Calculo de la cuota para pequeña, micro, consumo revolvente, no revolvente e hipotecario
              
              LN_C1PEQU := LN_C1PEQU*((power((1+ln_tpeque), ln_npeque)*ln_tpeque)/(power((1+ln_tpeque), ln_npeque)-1));                                   
              LN_C1MICR := LN_C1MICR*((power((1+ln_tmicro), ln_nmicro)*ln_tmicro)/(power((1+ln_tmicro), ln_nmicro)-1));
              LN_C1REVO := LN_C1REVO*((power((1+ln_tconsu), ln_nconsr)*ln_tconsu)/(power((1+ln_tconsu), ln_nconsr)-1));
              LN_C1NREV := LN_C1NREV*((power((1+ln_tconsu), ln_nconsn)*ln_tconsu)/(power((1+ln_tconsu), ln_nconsn)-1));
              LN_C1HIPO := LN_C1HIPO*((power((1+ln_thipot), ln_nhipot)*ln_thipot)/(power((1+ln_tpeque), ln_nhipot)-1));
              
              ------------------------------
            end if;
            
            -- Estimación de la cuota por exposición equivalente a riesgo crediticio
            -- Deuda potencial Cuota - Consumo
            begin
              select nvl(sum(n_salcap),0) 
                into LN_C2REVO 
                from cldrccs y 
               where d_fecpre = ld_fecha
                 and c_codsbs = LC_CODSBS 
                 and (substr(c_cuenta,1,4) in ('7101', '7111', '7112', '7102', '7112', '7122',
                                               '7103', '7113', '7123', '7104', '7114', '7124') or 
                      substr(c_cuenta,1,6) in ('720501', '720502', '720503', '720504',
                                               '720505', '720506', '720507',
                                               '721501', '721502', '721503', '721504',
                                               '721505', '721506', '721507',
                                               '722501', '722502', '722503', '722504',
                                               '722505', '722506', '722507')) 
                 and (C_CRETIP IN ('11', '12') or 
                     (c_cretip = '99' and (select UPPER(pcnomr) 
                                             from fsd014 b 
                                            where b.rubro = substr(y.c_cuenta,1,13)) 
                                                  like '%CONSUM%'));-- Para Deuda Potencial Consumo
              
            exception
                when no_data_found then
                     LN_C2REVO := 0;               
            end;
            
            LN_C2REVO := LN_C2REVO*(0.5)*((power((1+ln_tconsu), ln_nconsr)*ln_tconsu)/(power((1+ln_tconsu), ln_nconsr)-1)); --drc
            
            -- Deuda potencial Cuota - Pequeña                 
            begin
              select nvl(sum(n_salcap),0) 
                into LN_C2PEQU 
                from cldrccs y 
               where d_fecpre = ld_fecha
                 and c_codsbs = LC_CODSBS 
                 and (substr(c_cuenta,1,4) in ('7101', '7111', '7112', '7102', '7112', '7122',
                                               '7103', '7113', '7123', '7104', '7114', '7124') or 
                      substr(c_cuenta,1,6) in ('720501', '720502', '720503', '720504',
                                               '720505', '720506', '720507',
                                               '721501', '721502', '721503', '721504',
                                               '721505', '721506', '721507',
                                               '722501', '722502', '722503', '722504',
                                               '722505', '722506', '722507')) 
                 and (C_CRETIP = '09' or 
                     (c_cretip = '99' and (select UPPER(pcnomr) 
                                             from fsd014 b
                                            where b.rubro = substr(y.c_cuenta,1,13)) 
                                                  like '%PEQUEÑA%'));-- Para Deuda Potencial Pequeña
            exception
                when no_data_found then
                     LN_C2PEQU := 0;
            end;                   
            
            LN_C2PEQU := LN_C2PEQU*(0.30)*((power((1+ln_tpeque), ln_npeque)*ln_tpeque)/(power((1+ln_tpeque), ln_npeque)-1));
            
            -- Deuda potencial Cuota - Microempresa
            begin
              select nvl(sum(n_salcap),0) 
                into LN_C2MICR 
                from cldrccs y 
               where d_fecpre = ld_fecha
                 and c_codsbs = LC_CODSBS
                 and (substr(c_cuenta,1,4) in ('7101', '7111', '7112', '7102', '7112', '7122',
                                               '7103', '7113', '7123', '7104', '7114', '7124') or 
                      substr(c_cuenta,1,6) in ('720501', '720502', '720503', '720504',
                                               '720505', '720506', '720507',
                                               '721501', '721502', '721503', '721504',
                                               '721505', '721506', '721507',
                                               '722501', '722502', '722503', '722504',
                                               '722505', '722506', '722507')) 
                 and ((C_CRETIP = '10') or 
                      (c_cretip = '99' and (select UPPER(pcnomr) 
                                              from fsd014 b 
                                             where b.rubro = substr(y.c_cuenta,1,13)) 
                                                   like '%MICROEMP%'));-- Para Deuda Potencial Microempresa
            exception
                when no_data_found then
                     LN_C2MICR := 0;
            end;
            
            LN_C2MICR := LN_C2MICR*(0.30)*((power((1+ln_tmicro), ln_nmicro)*ln_tmicro)/(power((1+ln_tmicro), ln_nmicro)-1));             
            
            -- Deuda potencial Cuota - Hipotecario
            begin
              select nvl(sum(n_salcap),0) 
                into LN_C2HIPO 
                from cldrccs y 
               where d_fecpre = ld_fecha
                 and c_codsbs = LC_CODSBS 
                 and (substr(c_cuenta,1,4) in ('7101', '7111', '7112', '7102', '7112', '7122',
                                               '7103', '7113', '7123', '7104', '7114', '7124') or 
                      substr(c_cuenta,1,6) in ('720501', '720502', '720503', '720504',
                                               '720505', '720506', '720507',
                                               '721501', '721502', '721503', '721504',
                                               '721505', '721506', '721507',
                                               '722501', '722502', '722503', '722504',
                                               '722505', '722506', '722507')) 
                 and (C_CRETIP = '13' or 
                     (c_cretip = '99' and (select UPPER(pcnomr) 
                                             from fsd014 b 
                                            where b.rubro = substr(y.c_cuenta,1,13)) 
                                                  like '%HIPOT%'));-- Para Deuda Potencial Hipotecario
            exception
                when no_data_found then
                     LN_C2HIPO := 0;
            end;
            
            LN_C2HIPO := LN_C2HIPO*(0.30)*((power((1+ln_tmicro), ln_nmicro)*ln_tmicro)/(power((1+ln_tmicro), ln_nmicro)-1));             

            -------------------------            
            -- FCC Sistema Financiero
            begin 
              select nvl(sum(n_salcap), 0) 
                into LN_C3REVO
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha
                 and substr(c_cuenta, 1, 6) = '720506'
                 and (C_CRETIP in ('11', '12') or
                     (c_cretip = '99' and (select UPPER(pcnomr) 
                                             from fsd014 b 
                                            where b.rubro = substr(a.c_cuenta,1,13)) 
                                                  like '%CONSUM%')); -- 'FCC Sistema Financiero'- Consumo
            exception
                when no_data_found then
                     LN_C3REVO := 0;
            end;
            
            LN_C3REVO := LN_C3REVO*(0.50)*((power((1+ln_tconsu), ln_nconsr)*ln_tconsu)/(power((1+ln_tconsu), ln_nconsr)-1));

            --
            begin 
              select nvl(sum(n_salcap), 0) 
                into LN_C3PEQU
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha
                 and substr(c_cuenta, 1, 6) = '720506'
                 and (C_CRETIP = '09' or
                     (c_cretip = '99' and (select UPPER(pcnomr) 
                                             from fsd014 b 
                                            where b.rubro = substr(a.c_cuenta,1,13)) 
                                                  like '%PEQUEÑA%')); -- 'FCC Sistema Financiero' - Pequeño
            exception
                when no_data_found then
                     LN_C3PEQU := 0;
            end;
                        
            LN_C3PEQU := LN_C3PEQU*(0.50)*((power((1+ln_tpeque), ln_npeque)*ln_tpeque)/(power((1+ln_tpeque), ln_npeque)-1));
            
            --
            begin 
              select nvl(sum(n_salcap), 0) 
                into LN_C3MICR
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha
                 and substr(c_cuenta, 1, 6) = '720506'
                 and (C_CRETIP = '10' or
                     (c_cretip = '99' and (select UPPER(pcnomr) 
                                             from fsd014 b 
                                            where b.rubro = substr(a.c_cuenta,1,13)) 
                                                  like '%MICROEMP%')); -- 'FCC Sistema Financiero' - Micro
            exception
                when no_data_found then
                     LN_C3MICR := 0;
            end;
            
            LN_C3MICR := LN_C3MICR*(0.50)*((power((1+ln_tmicro), ln_nmicro)*ln_tmicro)/(power((1+ln_tmicro), ln_nmicro)-1));
            --
            begin 
              select nvl(sum(n_salcap), 0) 
                into LN_C3HIPO
                from cldrccs a
               where c_codsbs = lc_codsbs
                 and d_fecpre = ld_fecha
                 and substr(c_cuenta, 1, 6) = '720506'
                 and (C_CRETIP = '13' or
                     (c_cretip = '99' and (select UPPER(pcnomr) 
                                             from fsd014 b 
                                            where b.rubro = substr(a.c_cuenta,1,13)) 
                                                  like '%HIPOT%')); -- 'FCC Sistema Financiero' - Hipotecario
            exception
                when no_data_found then
                     LN_C3HIPO := 0;
            end;
            
            LN_C3HIPO := LN_C3HIPO*(0.50)*((power((1+ln_tmicro), ln_nmicro)*ln_tmicro)/(power((1+ln_tmicro), ln_nmicro)-1));


            ------------------------------
            -- Resultado Neto
            begin
              select nvl(sum(sng023mto), 0) 
                into ln_resnet --a1.*, a2.sng026dsc 
                from sng023 a1, sng026 a2
               where a1.sng026cod = a2.sng026cod 
                 and sng021eval = (select sng021eval
                                     from sng021 a
                                    where a.sng021pdoc = cred.PEPAIS
                                      and a.sng021tdoc = cred.PETDOC
                                      and a.sng021ndoc = cred.PENDOC--946825
                                      and a.sng021fec = (select max(sng021fec)
                                                          from sng021 aa
                                                         where aa.sng021pdoc = a.sng021pdoc   
                                                           and aa.sng021tdoc = a.sng021tdoc
                                                           and aa.sng021ndoc = a.sng021ndoc)
                                      AND ROWNUM = 1)
                 and (a1.sng026cod = 40); -- Resultado Neto
            exception
                when no_data_found then
                     ln_resnet := 0;               
                
            end;            
            
            if ln_resnet = 0 then               
               ln_csifin := (LN_C1PEQU + LN_C1MICR + LN_C1REVO + LN_C1NREV + LN_C1HIPO + LN_C2PEQU + LN_C2MICR + LN_C2REVO + LN_C2HIPO + LN_C3PEQU + LN_C3MICR + LN_C3REVO + LN_C3HIPO);
               ln_ratcrn := ln_csifin/nullif((ln_csifin),0);
            else
               ln_csifin := (LN_C1PEQU + LN_C1MICR + LN_C1REVO + LN_C1NREV + LN_C1HIPO + LN_C2PEQU + LN_C2MICR + LN_C2REVO + LN_C2HIPO + LN_C3PEQU + LN_C3MICR + LN_C3REVO + LN_C3HIPO);
               ln_ratcrn := ln_csifin/nullif((ln_csifin+ln_resnet), 0);
            end if;                
            
            --Destino del Crédito
            
            --Monto del Crédito Otorgado 
            
            ------------------------------            
             INSERT /*+append*/ INTO CREDTMP(
              TDNOM,  PETDOC, PENDOC, PENOM, NUM_CTA,SCNOM, TIPSBS, PASCMA,
              C_DESCON, C_ESCON, SNG001ORI,SNG001TPCR, TIP_CREDITO, SALDO_CAPITAL, PGCOD, SCMOD,
              SCSUC, SCMDA, SCPAP, SCCTA, SCOPER, SCSBOP, SCTOPE, SCSTAT,
              SCGRU,  SCRUB, SCSDO,  DIAS_ATRASO,SECTOR, XWFPRCINS, CANT_CUENTAS, CANT_CUENTAS_V,
              DIAS_MAX_ATRASO, MONAPR, MONGARS, MONGARD, DESGAR, PRODCMAC, AOPERIOD, 
              N_CANENT, SALDOCCI, SNG001ASE, SNG001USC, CUOTASP, CUOTAST, DESALERTA,
              ACTNOM1, C_DESAVAL,              
              N_DEUDIR, N_DEUPOT, N_PATRIM, N_RATDPA, C_CODSBS, PETIPO,              
              N_C1PEQU, N_C1MICR, N_C1REVO, N_C1NREV, N_C1HIPO,
              N_C2PEQU, N_C2MICR, N_C2REVO, N_C2NREV, N_C2HIPO,
              N_C3PEQU, N_C3MICR, N_C3REVO, N_C3NREV, N_C3HIPO, N_RATCRN, N_AOIMP, C_MDNOM
            )            
            VALUES(
              cred.TDNOM,  cred.PETDOC, cred.PENDOC, cred.PENOM, cred.NUM_CTA, cred.SCNOM, cred.TIPSBS, cred.PASCMA,
              cred.C_DESCON, cred.C_ESCON, cred.SNG001ORI, cred.SNG001TPCR, cred.TIP_CREDITO, cred.SALDO_CAPITAL, cred.PGCOD, cred.SCMOD, 
              cred.SCSUC, cred.SCMDA, cred.SCPAP, cred.SCCTA, cred.SCOPER, cred.SCSBOP, cred.SCTOPE, cred.SCSTAT,
              cred.SCGRU,  cred.SCRUB, cred.SCSDO,  cred.DIAS_ATRASO, cred.SECTOR, cred.instancia, cred.CANT_CUENTAS, cred.CANT_CUENTAS_V, 
              cred.DIAS_MAX_ATRASO, cred.MONTO_APROB, ln_monsol, ln_mondol, lc_desgar, lc_tonom, ln_AOPERIOD,
              ln_CANENT, LN_SALDOCCI, lc_SNG001ASE, lc_SNG001USC, ln_numcsinp, ln_numcatra, lc_desalerta, 
              lc_actnom1, lc_desaval,
              ln_deudir, ln_deupot, ln_patrim, ln_ratdpa, lc_codsbs, cred.PETIPO,              
              LN_C1PEQU, LN_C1MICR, LN_C1REVO, LN_C1NREV, LN_C1HIPO,
              LN_C2PEQU, LN_C2MICR, LN_C2REVO, LN_C2NREV, LN_C2HIPO,
              LN_C3PEQU, LN_C3MICR, LN_C3REVO, LN_C3NREV, LN_C3HIPO, LN_RATCRN, LN_AOIMP, LC_MDNOM
            );       
                    
                    
         commit;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'QYS',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
  end loop;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'QYS';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'QYS';
    commit;
    return;

end SP_Query2_II;

      
Function Fn_instancia(pn_emp in number,pn_suc in number,pn_mod in number,pn_mda in number,
                      pn_pap in number, pn_cta in number, pn_ope in number, pn_sbo in number,
                      pn_top in number) return number is
ln_instancia number(10);
begin
    begin
         select max(q.xwfprcins) 
           into ln_instancia
           from xwf700 q
          where q.xwfcar3      =  '1'
            and q.xwfempresa   =  pn_emp
            and q.xwfsucursal  =  pn_suc
            and q.xwfmodulo    =  pn_mod
            and q.xwfmoneda    =  pn_mda
            and q.xwfpapel     =  pn_pap
            and q.xwfcuenta    =  pn_cta
            and q.xwfoperacion =  pn_ope
            and q.xwfsubope    =  pn_sbo 
            and q.xwftipope    =  pn_top
            and q.xwfprcins    <> 0;
    exception
            when others then null;
    end;
    return ln_instancia;
end Fn_instancia;
end PQ_RIESGOS_CALIFICACION;
/

