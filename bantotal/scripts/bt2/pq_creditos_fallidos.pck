create or replace package PQ_CREDITOS_FALLIDOS is

  -- Author  : ABERNEDO
  -- Created : 14/02/2014 09:00:55 a.m.
  -- Purpose : Reporte de Creditos fallidos
  
  -- Public type declarations
  Procedure sp_job_credfallidos (pd_fecpro in varchar2,pd_fecini in varchar2,pd_fecfin in varchar2 );
  Procedure sp_credfallidos (pn_numsuc in number, pd_fecpro in varchar2, pd_fecini in varchar, 
                          pd_fecfin in varchar );
  Procedure sp_job_credfallidos_II (pd_fecpro in varchar2 );
  Procedure sp_credfallidos_II (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number ;
  function fn_des_analista (pn_instancia in number,pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2 ;
 
  Procedure sp_job_calcula_mora (pd_fecpro in varchar2 );
  Procedure sp_Calcula_mora (pn_numsuc in number, pd_fecpro in varchar2 );
  Function Fn_Mora (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number, pd_fecpro in date,
                  pd_ppfpag in date) return number ;
  --Procedure sp_job_rec_legal (pd_fecpro in varchar2 );
  --Procedure sp_rec_legal (pn_numsuc in number, pd_fecpro in varchar2 );

end PQ_CREDITOS_FALLIDOS;
/

create or replace package body PQ_CREDITOS_FALLIDOS is

Procedure sp_job_credfallidos (pd_fecpro in varchar2,pd_fecini in varchar2,pd_fecfin in varchar2 ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  lc_hostname varchar2(64);
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  --lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table JAQY545');
     delete Tab_jobs where  c_Codage = 'FALL';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  PQ_CREDITOS_FALLIDOS.sp_credfallidos('||ln_ini||','||''''||Pd_FECpro||''''||','||''''||Pd_FECini||''''||','||''''||Pd_FECfin||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
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
        VALUES('FALL',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'FALL',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end sp_job_credfallidos;
  
Procedure sp_credfallidos (pn_numsuc in number, pd_fecpro in varchar2, pd_fecini in varchar, pd_fecfin in varchar ) is

ld_fecpro date ;
ld_fecini date ;
ld_fecfin date ;
lc_coderr varchar2(300); 
cursor rubro is 
  select /*+parallel(fsd014,2,1)*/ rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111/**/
           where dscod = 50
             and modulo not in (29, 120, 144,108)) --33 castigado , 200 judicial
              /*or pcnivc in (141, 117)*/)
     and pcimpu = 'S'
     and pmtit <> 9;
--ld_fecant date;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'FALL';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  ld_fecini := to_date(pd_fecini,'yyyymmdd');
  ld_fecfin := to_date(pd_fecfin,'yyyymmdd');
  --ld_fecant := ADD_MONTHS(ld_fecpro,-1);

  for i in rubro loop
     begin 
       insert into JAQY545 (
              INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,/*DIAS_MORA,*/BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,
              TDNOM,AOIMP,BCFECH,PENOM,BCSDMO,AOPERIOD,AOSTAT,BCPROD)
       select /*+all_rows use_nl(cta nom) parallel(cta,2,1)*/
             fn_instancia_credito(bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop,bctop),
             sal.bcrubr,
             sal.bcsdmn, 
             sal.BCEMP,
             sal.bcmod,
             sal.bcsuc,
             sal.bcmda,
             sal.bcpap,
             sal.bccta,
             sal.bcoper,
             sal.bcsbop,
             sal.bctop,
             /*pq_creditos_fallidos.Fn_Mora(sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,sal.bcpap,bccta,
                                          bcoper,sal.bcsbop,sal.bctop,ld_fecpro,sal.bcfval),*/
             sal.bcfval,
             sal.bcfvto,
             cta.pepais,
             cta.petdoc,
             cta.pendoc, 
             tdo.tdnom,
             pre.aoimp,
             sal.bcfech,
             nom.penom,
             sal.bcsdmo,
             pre.aoperiod,
             pre.aostat,
             sal.bcprod
        from fsh012 sal, fsr008 cta, fsd010 pre,
             fst014 tdo, fsd001 nom
       where sal.bcemp  = 1
         and sal.bcsuc  = pn_numsuc
         and sal.bcfech  = ld_fecpro
         and sal.bcfval between  ld_fecini and ld_fecfin
         and sal.bcrubr = i.rubro
         and sal.bccta  = cta.ctnro
         and cta.pgcod  = 1
         and cta.cttfir = 'T'
         and cta.petdoc = tdo.tdocum
         and cta.pepais = nom.pepais
         and cta.petdoc = nom.petdoc
         and cta.pendoc = nom.pendoc
         and sal.bcemp  = pre.pgcod (+)   
         and sal.bcmod  = pre.aomod (+)  
         and sal.bcsuc  = pre.aosuc (+)  
         and sal.bcmda  = pre.aomda (+)   
         and sal.bcpap  = pre.aopap (+)  
         and sal.bccta  = pre.aocta (+)  
         and sal.bcoper = pre.aooper (+) 
         and sal.bcsbop = pre.aosbop (+) 
         and sal.bctop  = pre.aotope (+) 
         
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'FALL',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'FALL';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'FALL';
    commit;
    return;

end sp_credfallidos;  

 
Procedure sp_job_credfallidos_II (pd_fecpro in varchar2 ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  lc_hostname varchar2(64);
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  --lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
        
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;

     execute immediate ('truncate table JAQY546');
     --execute immediate ('truncate table CALEN_CRED');
     delete Tab_jobs where  c_Codage = 'FALLD';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_creditos_fallidos.sp_credfallidos_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
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
        VALUES('FALLD',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'FALLD',lc_variable, TRUNC(SYSDATE));
           COMMIT;


  end sp_job_credfallidos_II;
  
Procedure sp_credfallidos_II (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;
--ld_fecant date ;
lc_coderr varchar2(300); 
cursor rubro is
  select /*+parallel(fsd014,2,1)*/ rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 108)) --33 castigado , 200 judicial
              /*or pcnivc in (141, 117)*/)
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'FALLD';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  --ld_fecant := ADD_MONTHS(ld_fecpro,-1);
    for i in rubro loop
     begin 
       
       insert into JAQY546 (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,dias_mora,bcfval,bcfvto,pepais,
                             petdoc,pendoc,tdnom,aoimp,scnom,rub_act,nro_credito,des_ana,
                             cuotas_pagadas,bcsdmo,aostat,penom,numer01)
            select distinct car.INSTANCIA,car.bcemp, car.BCMOD,car.BCSUC,car.BCMDA,car.BCPAP,
                   car.BCCTA,car.BCOPER,car.BCSBOP,car.BCTOP,
                   dim.dias_mora,
                   car.BCFVAL,
                   car.BCFVTO,
                   car.PEPAIS,
                   car.PETDOC,
                   car.PENDOC,
                   car.TDNOM,
                   car.AOIMP,
                   age.scnom,
                   car.bcrubr,
                   
                   (lpad(to_char(car.bccta), 9, '0') || lpad(to_char(car.bcmod), 3, '0') ||
                   lpad(to_char(car.bcmda), 3, '0') || lpad(to_char(car.bcoper), 9, '0') ||
                   lpad(to_char(car.bctop), 3, '0')) Nro_Credito,
                   pq_creditos_fallidos.fn_des_analista(car.instancia,car.pepais,car.petdoc,car.pendoc),
                   pq_creditos_fallidos.fn_cuotas_pagadas(car.bcemp,car.bcmod,car.bcsuc,car.bcmda,car.bcpap,
                                                          car.bccta,car.bcoper,car.bcsbop,car.bctop,ld_fecpro),
                   car.bcsdmo,
                   car.aostat,
                   car.penom,
                   car.bcprod
              
                    
                     from JAQY545 car, JAQY547 dim, fst001 age
                     where car.bcsuc     = pn_numsuc
                       and car.bcrubr    = i.rubro
                       and car.bcemp     = dim.bcemp
                       and car.bcmod     = dim.bcmod
                       and car.bcsuc     = dim.bcsuc
                       and car.bcmda     = dim.bcmda
                       and car.bcpap     = dim.bcpap
                       and car.bccta     = dim.bccta
                       and car.bcoper    = dim.bcoper
                       and car.bcsbop    = dim.bcsbop
                       and car.bctop     = dim.bctop
                       and dim.dias_mora > 60
                       and age.pgcod     = car.bcemp
                       and age.sucurs    = car.bcsuc;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'FALLD',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'FALLD';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'FALLD';
    commit;
    return;

end sp_credfallidos_II;  
 


function fn_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
ln_numcuotas number;
begin
  begin
    select sum(count(*))
       into ln_numcuotas     
       from fsd602 o
      where o.pgcod   = pn_emp
        and o.ppmod   = pn_mod
        and o.ppsuc   = pn_suc 
        and o.ppmda   = pn_mda 
        and o.pppap   = pn_pap 
        and o.ppcta   = pn_cta 
        and o.ppoper  = pn_oper 
        and o.ppsbop  = pn_sbop 
        and o.pptope  = pn_top 
        and o.pp1fech  <= pd_fecpro
        and o.pp1stat = 'T' 
        and o.d602co  = 'S'
      group by o.PGCOD,
           o.PPMOD,
           o.PPSUC,
           o.PPMDA,
           o.PPPAP,
           o.PPCTA,
           o.PPOPER,
           o.PPSBOP,
           o.PPTOPE,
           o.PPFPAG;
  exception 
      when no_data_found then 
         ln_numcuotas := null;
      when too_many_rows then
         ln_numcuotas := -1;
      when others then
         ln_numcuotas := -0;
  end;   
   return ln_numcuotas;
end fn_cuotas_pagadas;



function fn_des_analista (pn_instancia in number,pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2 is
lc_desana varchar2(200);
begin
  begin
    select bb.ubnom
      into lc_desana
      from sng001 aa, fst746 bb
     where aa.sng001inst = pn_instancia
       and aa.sng001pais = pn_pais
       and aa.sng001tdoc = pn_tdoc
       and aa.sng001ndoc = pc_ndoc
       and bb.ubuser     = aa.sng001ase;
  exception 
      when too_many_rows then
           lc_desana := '2';
      when no_data_found then 
           lc_desana := null;
        
              
  end;   
    
   return lc_desana;
end fn_des_analista;
Procedure sp_job_calcula_mora (pd_fecpro in varchar2 ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  lc_hostname varchar2(64);
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  --lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table JAQY547');
     
     delete Tab_jobs where  c_Codage = 'CALM';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_creditos_fallidos.sp_Calcula_mora('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
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
        VALUES('CALM',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CALM',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_calcula_mora;
  
Procedure sp_Calcula_mora (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;
--ld_fecant date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 108)) --33 castigado , 200 judicial
              )
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'CALM';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  --ld_fecant := ADD_MONTHS(ld_fecpro,-1);
    for i in rubro loop
     begin 
     
       insert into JAQY547 (bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,dias_mora)
            select /*+all_rows*/
                   cal.PGCOD,
                   cal.ppmod,
                   cal.ppsuc, 
                   cal.ppmda,
                   cal.pppap, 
                   cal.ppcta, 
                   cal.ppoper,
                   cal.ppsbop,
                   cal.pptope,
                   max(cal.diam) from (select  /*+all_rows parallel(d601,2,1)*/
                                               FD601.PGCOD,
                                               fd601.ppmod,
                                               fd601.ppsuc, 
                                               fd601.ppmda,
                                               fd601.pppap, 
                                               fd601.ppcta, 
                                               fd601.ppoper,
                                               fd601.ppsbop,
                                               fd601.pptope,
                                               fd601.ppfpag,
                                               pq_creditos_fallidos.Fn_Mora(fd601.pgcod,fd601.ppmod, 
                                                               fd601.ppsuc,fd601.ppmda,fd601.pppap, 
                                                               fd601.ppcta,fd601.ppoper,fd601.ppsbop,
                                                               fd601.pptope,ld_fecpro,fd601.ppfpag)diam               
                                                               
                                               
                                          from fsd601 fd601, JAQY545 car
                                         where car.bcsuc    = pn_numsuc
                                           and car.bcrubr   = i.rubro
                                           and fd601.pgcod  = car.bcemp
                                           and fd601.ppmod  = car.bcmod
                                           and fd601.ppsuc  = car.bcsuc
                                           and fd601.ppmda  = car.bcmda
                                           and fd601.pppap  = car.bcpap
                                           and fd601.ppcta  = car.bccta
                                           and fd601.ppoper = car.bcoper
                                           and fd601.ppsbop = car.bcsbop
                                           and fd601.pptope = car.bctop
                                           AND fd601.PPFPAG - car.bcfval < 190) cal
                                          
                group by cal.PGCOD,
                   cal.ppmod,
                   cal.ppsuc, 
                   cal.ppmda,
                   cal.pppap, 
                   cal.ppcta, 
                   cal.ppoper,
                   cal.ppsbop,
                   cal.pptope
               ;
                    
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CALM',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'CALM';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'CALM';
    commit;
    return;

end sp_Calcula_mora;    
Function Fn_Mora (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number, pd_fecpro in date,
                  pd_ppfpag in date) return number is
                           
ln_mora number;
ld_fecmor date;

                          
Begin


   
       Begin
       
       select /*+all_rows*/
              max(d602.pp1fech)
         into ld_fecmor
         from fsd602 d602
        where d602.pgcod    = pn_emp
          and d602.ppmod    = pn_mod
          and d602.ppsuc    = pn_suc 
          and d602.ppmda    = pn_mda 
          and d602.pppap    = pn_pap 
          and d602.ppcta    = pn_cta 
          and d602.ppoper   = pn_oper
          and d602.ppsbop   = pn_sbop
          and d602.pptope   = pn_top 
          and d602.ppfpag   = pd_ppfpag
          and d602.pp1fech  <= pd_fecpro
          and d602.pp1stat  = 'T' 
          and d602.d602co   = 'S';
          
       exception
       
          when no_data_found then 
             ld_fecmor := null;
          when too_many_rows then
             ld_fecmor := null;
          when others then
             ld_fecmor := null;
       end;
       begin
             if ld_fecmor is null then
                ln_mora := pd_fecpro - pd_ppfpag;
                
                else
                        ln_mora := ld_fecmor - pd_ppfpag;
             end if;
       end;
       
       
       begin
       
           if ln_mora < 0 then
              ln_mora := 0;
           end if; 
       end;
       
  return ln_mora;
end Fn_Mora;


/* 

Procedure sp_job_rec_legal (pd_fecpro in varchar2 ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  --lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
     execute immediate ('truncate table JAQY548');
     
     delete Tab_jobs where  c_Codage = 'RECL';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_creditos_fallidos.sp_rec_legal('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      --instance => 2,
                      force => false
                      );
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('RECL',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'RECL',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end sp_job_rec_legal;
  
Procedure sp_rec_legal (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;
--ld_fecant date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 108)) --33 castigado , 200 judicial
              )
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'RECL';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  --ld_fecant := ADD_MONTHS(ld_fecpro,-1);
    for i in rubro loop
     begin 
       
       insert into JAQY548 (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,tdnom,aoimp,scnom,bcrubr,nro_credito,des_ana,
                             cuotas_pagadas,bcsdmo,penom,BCPROD)
            select car.INSTANCIA,car.bcemp, car.BCMOD,car.BCSUC,car.BCMDA,car.BCPAP,
                   car.BCCTA,car.BCOPER,car.BCSBOP,car.BCTOP,
                   car.BCFVAL,
                   car.BCFVTO,
                   car.PEPAIS,
                   car.PETDOC,
                   car.PENDOC,
                   car.TDNOM,
                   car.AOIMP,
                   age.scnom,
                   car.bcrubr,
                   
                   (lpad(to_char(car.bccta), 9, '0') || lpad(to_char(car.bcmod), 3, '0') ||
                   lpad(to_char(car.bcmda), 3, '0') || lpad(to_char(car.bcoper), 9, '0') ||
                   lpad(to_char(car.bctop), 3, '0')) Nro_Credito,
                   pq_creditos_fallidos.fn_des_analista(car.instancia,car.pepais,car.petdoc,car.pendoc),
                   pq_creditos_fallidos.fn_cuotas_pagadas(car.bcemp,car.bcmod,car.bcsuc,car.bcmda,car.bcpap,
                                                          car.bccta,car.bcoper,car.bcsbop,car.bctop,ld_fecpro),
                   car.bcsdmo,
                   --car.aostat,
                   car.penom,
                   car.bcprod
              
                    
                      from JAQY545 car, JAQL166 j160, fst001 age
                     where car.bcsuc        = pn_numsuc
                       and car.bcrubr       = i.rubro
                       and car.bcemp        = j160.jaql166pgcod
                       and car.bcmod        = j160.jaql166scmod
                       and car.bcsuc        = j160.jaql166scsuc
                       and car.bcmda        = j160.jaql166scmda
                       and car.bcpap        = j160.jaql166scpap
                       and car.bccta        = j160.jaql166sccta
                       and car.bcoper       = j160.jaql166scope
                       and car.bcsbop       = j160.jaql166scsbo
                       and car.bctop        = j160.jaql166sctop
                       and j160.jaql166fpga = to_date('00010101','yyyymmdd')
                       and age.pgcod        = car.bcemp
                       and age.sucurs       = car.bcsuc;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'RECL',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'RECL';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'RECL';
    commit;
    return;

end sp_rec_legal;*/

end PQ_CREDITOS_FALLIDOS;
/

