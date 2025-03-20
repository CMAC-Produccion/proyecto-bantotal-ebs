create or replace package pq_datos_Consecutivas is
 
                                    
  Procedure sp_consecutivas_datos (pn_numsuc in number, pd_fecini in varchar2,pd_fecfin in varchar2);   
  Procedure sp_job_consecutivas_datos (pd_fecini in varchar2,pd_fecfin in varchar2 );  
  Procedure sp_job_consecutivas_datosII (pd_fecini in varchar2,pd_fecfin in varchar2 );
  Procedure sp_consecutivas_datosII (pn_numsuc in number, pd_fecini in varchar2,pd_fecfin in varchar2);
  function fn_saldo(pn_pais in number, pn_tdoc in number, pn_ndoc in char, pd_fecha in date,
                    pn_tipcamb in number, pn_mda in number) return number;  
  function fn_es_consecutiva (pn_tipcamb in number, pn_pais in number,pn_tdoc in number, pn_ndoc in char,
                            pd_fecha in date, pn_mda in number) return varchar2;                                                                                                                                                                         
end pq_datos_Consecutivas;
/

create or replace package body pq_datos_Consecutivas is




Procedure sp_job_consecutivas_datos (pd_fecini in varchar2,pd_fecfin in varchar2 ) is
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
--     execute immediate ('truncate table migra2.JAQY508');
     execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';--jflor 2014.01.22
     execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS';  --jflor 2014.01.22    
     execute immediate 'ALTER SESSION SET COMMIT_LOGGING=BATCH';     --jflor 2014.01.22
     execute immediate 'ALTER SESSION SET COMMIT_WAIT=NOWAIT';       --jflor 2014.01.22
     
     execute immediate ('truncate table JAQY508');
     delete Tab_jobs where  c_Codage = 'CONSE';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_Consecutivas.sp_consecutivas_datos('||ln_ini||','||''''||Pd_FECini||''''||','||''''||Pd_FECfin||'''' ||');'|| ' End; ';
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
        VALUES('CONSE',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CONSE',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;
end sp_job_consecutivas_datos;
  
Procedure sp_consecutivas_datos (pn_numsuc in number, pd_fecini in varchar2,pd_fecfin in varchar2) is

ld_fecini date ;
ld_fecfin date ;
lc_coderr varchar2(300); 
ln_tipcam number;
ln_limmax number;
ln_limmin number;
  /*cursor rubro is
  select rubro
    from fsd014
   where pcnivc in (113,200)
     and pcimpu = 'S'
     and pmtit  <> 9;*/

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'CONSE';
  commit;
  ld_fecini := to_date(pd_fecini,'yyyymmdd');
  ld_fecfin := to_date(pd_fecfin,'yyyymmdd');
   begin
   select g.cotcbi
      into ln_tipcam
      from fsh005 g 
     where g.moneda = 101 
       and g.cofdes = ld_fecfin;
  exception
    when others then
      ln_tipcam:=1;
  end; 
  
  ln_limmax := 10000;
  ln_limmin := 2500;
  
  --for i in rubro loop
     begin 
       insert into JAQY508(JAQY508PGCOD,JAQY508HCMOD,JAQY508HSUCOR,JAQY508HTRAN,JAQY508HNREL,
                           JAQY508HFCON,JAQY508HCORD,JAQY508HCSUBO,JAQY508HMODUL,JAQY508HTOPER,
                           JAQY508HSUCUR,JAQY508HRUBRO,JAQY508HMDA,JAQY508HPAP,JAQY508HCTA,
                           JAQY508HOPER,JAQY508HSUBOP,JAQY508HCIMP1,JAQY508HCODMO,JAQY508HORA,
                           /*JAQY508AGENCIA,*/JAQY508NROCUENTA,JAQY508PEPAIS,JAQY508PETDOC,
                           JAQY508PENDOC,JAQY508PENOM,JAQY508TIPDOC,/*JAQY508NOMOPE,*/
                           JAQY508HUSING,JAQY508MONTO_DOL,JAQY508MONTO_SOL)
       select/*+all_rows parallel(sal,2,1)*/
             sal.PGCOD,
             sal.HCMOD,
             sal.HSUCOR,
             sal.HTRAN,
             sal.HNREL,
             sal.HFCON,
             sal.HCORD,
             sal.HCSUBO,
             sal.HMODUL,
             sal.HTOPER,
             sal.HSUCUR,
             sal.HRUBRO,
             sal.HMDA,
             sal.HPAP,
             sal.HCTA,
             sal.HOPER,
             sal.HSUBOP,
             sal.HCIMP1,
             sal.HCODMO,
             usr.HHORA,
             (lpad(to_char(sal.hcta), 9, '0') || lpad(to_char(sal.hcmod), 3, '0') ||
              lpad(to_char(sal.hmda), 3, '0') || lpad(to_char(sal.hoper), 9, '0') ||
              lpad(to_char(sal.htoper), 3, '0')),
             cta.PEPAIS,
             cta.PETDOC,
             cta.PENDOC,
             nom.PENOM,
             tdo.TDNOM,
             usr.HUSING,
             decode(sal.HMDA,0,sal.hcimp1/ln_tipcam,sal.hcimp1),
             decode(sal.HMDA,101,sal.hcimp1*ln_tipcam,sal.hcimp1)
        from fsh016 sal, fsh015 usr, fsr008 cta, 
             fst014 tdo, fsd001 nom
       where sal.PGCOD  = 1
         --and sal.hrubro = i.rubro
         and sal.HSUCOR = pn_numsuc
         and sal.HFCON  between ld_fecini and ld_fecfin
         and sal.PGCOD  = usr.PGCOD
         and sal.HCMOD  = usr.HCMOD
         and sal.HSUCOR = usr.HSUCOR
         and sal.HTRAN  = usr.HTRAN
         and sal.HNREL  = usr.HNREL
         and sal.HFCON  = usr.HFCON
         and sal.HCTA   = cta.ctnro
         and cta.pgcod  = 1
         and cta.cttfir = 'T'
         and cta.petdoc = tdo.tdocum
         and cta.pepais = nom.pepais
         and cta.petdoc = nom.petdoc
         and cta.pendoc = nom.pendoc
         and sal.HMODUL = 21
         and sal.HTOPER in (1,3)
         and sal.HCMOD  not in (30,22,490)
         and sal.HTRAN  not in (select i.trnro from fst034 i where i.trmod = 66 and i.trnro  in(12,16,20,50,85))  
         and sal.HTRAN  not in (select i.trnro from fst034 i where i.trmod = 50 and i.trnro  in(31,130,456,131,535,536))  
         and sal.HTRAN  not in (select i.trnro from fst034 i where i.trmod = 21 and i.trnro  in (905,90))
         and sal.HTRAN  not in (select i.trnro from fst034 i where i.trmod = 10 and i.trnro  in(35,40,30))
         and sal.HTRAN  not in (select i.trnro from fst034 i where i.trmod = 99 and i.trnro  in(5,7,8,6,925,290,927))
         and sal.HTRAN  not in (select i.trnro from fst034 i where i.trmod = 140 and i.trnro = 99)
         and sal.HTRAN  not in (select i.trnro from fst034 i where i.trmod = 35 and i.trnro  = 60)
         and sal.HTRAN  not in (select i.trnro from fst034 i where i.trmod = 20 and i.trnro  = 90)
         and cta.pendoc not in (select h.PJNDOC from fsd003 h where h.PJPAIS = cta.pepais and h.PJTDOC = cta.petdoc 
                                                     and h.PJNDOC = cta.pendoc and h.NJCOD <> 16)
         
         and ((sal.HMDA = 0 and sal.HCIMP1 < ln_limmax * ln_tipcam and sal.HCIMP1 > ln_limmin)or
              (sal.HMDA = 101 and sal.HCIMP1 < ln_limmax and sal.HCIMP1 > ln_limmin /ln_tipcam))
         and usr.HUSING not in ('PHUARZA','JPALOMINOJ')
         and usr.hccorr <> 99              
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CONSE',/*i.rubro||*/lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  --end loop; 
  --commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'CONSE';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'CONSE';
    commit;
    return;

end sp_consecutivas_datos;  
Procedure sp_job_consecutivas_datosII (pd_fecini in varchar2,pd_fecfin in varchar2 ) is
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
--     execute immediate ('truncate table migra2.JAQY508_R');
     execute immediate ('truncate table JAQY508_R');
     delete Tab_jobs where  c_Codage = 'CONSE2';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_Consecutivas.sp_consecutivas_datosII('||ln_ini||','||''''||Pd_FECini||''''||','||''''||Pd_FECfin||'''' ||');'|| ' End; ';
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
        VALUES('CONSE2',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CONSE2',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;
end sp_job_consecutivas_datosII;
  
Procedure sp_consecutivas_datosII (pn_numsuc in number, pd_fecini in varchar2,pd_fecfin in varchar2) is

ld_fecini date ;
ld_fecfin date ;
lc_coderr varchar2(300); 
ln_tipcam number;
  /*cursor rubro is
  select rubro
    from fsd014
   where pcnivc in (113,200)
     and pcimpu = 'S'
     and pmtit  <> 9;*/

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'CONSE2';
  commit;
  ld_fecini := to_date(pd_fecini,'yyyymmdd');
  ld_fecfin := to_date(pd_fecfin,'yyyymmdd');
   --saco el tipo de cambio
  begin
   select g.cotcbi
      into ln_tipcam
      from fsh005 g 
     where g.moneda = 101 
       and g.cofdes = ld_fecfin;
  exception
    when others then
      ln_tipcam:=1;
  end;  

  --for i in rubro loop
     begin 
       insert into JAQY508_R(JAQY508PGCOD,JAQY508HCMOD,JAQY508HSUCOR,JAQY508HTRAN,JAQY508HNREL,
                           JAQY508HFCON,JAQY508HCORD,JAQY508HCSUBO,JAQY508HMODUL,JAQY508HTOPER,
                           JAQY508HSUCUR,JAQY508HRUBRO,JAQY508HMDA,JAQY508HPAP,JAQY508HCTA,
                           JAQY508HOPER,JAQY508HSUBOP,JAQY508HCIMP1,JAQY508HCODMO,JAQY508HORA,
                           JAQY508NROCUENTA,JAQY508PEPAIS,JAQY508PETDOC,JAQY508PENDOC,JAQY508PENOM,
                           JAQY508TIPDOC,JAQY508HUSING,JAQY508SALDO,JAQY508CONS,JAQY508NOMOPE,
                           JAQY508AGENCIA)
       select/*+all_rows parallel(sal,2,1)*/
             ja.jaqy508pgcod,
             ja.jaqy508hcmod,
             ja.jaqy508hsucor,
             ja.jaqy508htran,
             ja.jaqy508hnrel,
             ja.jaqy508hfcon,
             ja.jaqy508hcord,
             ja.jaqy508hcsubo,
             ja.jaqy508hmodul,
             ja.jaqy508htoper,
             ja.jaqy508hsucur,
             ja.jaqy508hrubro,
             ja.jaqy508hmda,
             ja.jaqy508hpap,
             ja.jaqy508hcta,
             ja.jaqy508hoper,
             ja.jaqy508hsubop,
             ja.jaqy508hcimp1,
             ja.jaqy508hcodmo,
             ja.jaqy508hora,
             ja.jaqy508nrocuenta,
             ja.jaqy508pepais,
             ja.jaqy508petdoc,
             ja.jaqy508pendoc,
             ja.jaqy508penom,
             ja.jaqy508tipdoc,
             ja.jaqy508husing,
             pq_datos_consecutivas.fn_saldo(ja.jaqy508pepais,ja.jaqy508petdoc,ja.jaqy508pendoc,
                                            ja.jaqy508hfcon,ln_tipcam,jaqy508hmda),
             pq_datos_consecutivas.fn_es_consecutiva(ln_tipcam,ja.jaqy508pepais,ja.jaqy508petdoc,
                                                     ja.jaqy508pendoc,ja.jaqy508hfcon,jaqy508hmda),
             ope.TRNOM,
             ag.SCNOM
        from JAQY508 ja, fst001 ag, fst034 ope
       where ja.jaqy508pgcod     = 1
         and ja.jaqy508hsucor    = pn_numsuc
         and ag.PGCOD            = ja.jaqy508pgcod
         and ag.SUCURS           = ja.jaqy508hsucor
         and ope.PGCOD           = ja.jaqy508pgcod
         and ope.TRMOD           = ja.jaqy508hcmod
         and ope.TRNRO           = ja.jaqy508htran
         --and ja.jaqy508monto_dol < 10000
         --and ja.jaqy508monto_sol > 2500
         
         
         
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CONSE2',/*i.rubro||*/lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  --end loop; 
  --commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'CONSE2';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'CONSE2';
    commit;
    return;

end sp_consecutivas_datosII;  

function fn_saldo(pn_pais in number, pn_tdoc in number, pn_ndoc in char, pd_fecha in date,
                  pn_tipcamb in number, pn_mda in number) return number is

ln_saldo number(17,2);
begin
  
  begin
    
    select sum(decode(pn_mda,0,k.jaqy508hcimp1/pn_tipcamb,k.jaqy508hcimp1))
      into ln_saldo     
      from jaqy508 k
     where k.jaqy508pepais = pn_pais
       and k.jaqy508petdoc = pn_tdoc
       and k.jaqy508pendoc = pn_ndoc
       and k.jaqy508hfcon  = pd_fecha;
    
  exception
    when others then
      ln_saldo := null;
  end;
  return ln_saldo;
end fn_saldo;

function fn_es_consecutiva (pn_tipcamb in number, pn_pais in number,pn_tdoc in number, pn_ndoc in char,
                            pd_fecha in date, pn_mda in number) return varchar2 is
lc_existe    varchar2(2);
ln_saldo     number(17,2);
--ln_saldo_dol number;

     
begin
   begin
   
        ln_saldo  := pq_datos_consecutivas.fn_saldo(pn_pais,pn_tdoc,pn_ndoc,pd_fecha,pn_tipcamb,pn_mda); --saldo acumulado por persona por dia
        --ln_saldo_dol := ln_saldo / pn_tipcamb;
        if ln_saldo > 10000 then
            lc_existe := 'S';
                     
        end if;
        
    exception when others then                     
          lc_existe := 'N';     
    end; 
            
      return lc_existe;  
    
   
end fn_es_consecutiva;


end pq_datos_Consecutivas;
/

