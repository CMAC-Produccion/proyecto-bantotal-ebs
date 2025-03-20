create or replace package pq_bc_ajuste_ejercicio is
Procedure sp_job_ajuste  (pn_periodo in number, pd_feccie in varchar2 ) ;
Procedure sp_ajuste_ejercicio (pn_periodo in number, pd_feccie in varchar2, pn_suc in number );

end pq_bc_ajuste_ejercicio;
/

create or replace package body pq_bc_ajuste_ejercicio is
Procedure sp_job_ajuste  (pn_periodo in number, pd_feccie in varchar2 ) is

  
  ln_ini number;
  i      number;
  lc_variable varchar2(1000);
  lc_fecha varchar2(20);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  x number;
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
 

  
  begin 
     execute immediate ('truncate table jaql115');
     --commit;
     delete Tab_jobs where  c_Codage = 'AJUS';
     commit;
     lc_hostname := 'SC01ZDBADM010101';
     for i in sucursal loop    
        lc_variable := ' begin '|| '  pq_bc_ajuste_ejercicio.sp_ajuste_ejercicio('||pn_periodo||','||''''||pd_feccie||''''||','||i.sucurs|| ');'|| ' End; ';
        ln_job := ln_job +1;
        
        IF SYS.FN_BD_ISRAC='TRUE' THEN
                   --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
                   DBMS_JOB.SUBMIT(job => ln_job,
                                what => lc_variable,
                                next_date => sysdate,
                                interval => null,
                                no_parse => false,
                                instance => 2,
                                force => false
                                );
                  INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
                  VALUES('AJUS',to_number(I.sucurs),lc_variable);
                  COMMIT;
             else
                 DBMS_JOB.SUBMIT(job => ln_job,
                                what => lc_variable,
                                next_date => sysdate,
                                interval => null,
                                no_parse => false,
                                force => false
                                );
                  INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
                  VALUES('AJUS',to_number(I.sucurs),lc_variable);
                  COMMIT;
             end if;
             select count(*) 
              into x
              from user_jobs;
            while x = 20 loop
              select count(*) 
              into x
              from user_jobs; 
            end loop;
       end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'AJUS',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
Procedure sp_ajuste_ejercicio (pn_periodo in number, pd_feccie in varchar2, pn_suc in number ) is

  
  
  ld_fecpro date;
  lc_coderr varchar2(300);
  ld_Fecini date;
  ld_Fecfin date;
  ld_feccie date;
 
  cursor cerear is
  select * from jaql115 where HASUC = pn_suc;

  cursor fecha (ld_Fecini in date, ld_fecfin in date) is
    select ffecha
      from fst028
     where ffecha between ld_Fecini and ld_fecfin
       and calcod = 1;
  
  cursor diferencia (ld_fecha in date) is 
  SELECT b.drrub,b.drsdor, b.drsdus, b.drsdmn,a.bcrubr, A.bcsdmo, A.bcsdmn , A.bcsdus,
         bcemp,bcfech,bcsuc,bcmda,bcpap,bcmod,
         a.bcsdmo - b.drsdor diferencia_o,
         a.bcsdmn - b.drsdmn diferencia_n,
         a.bcsdus - b.drsdus diferencia_e
   FROM (select aa.bcemp,aa.bcfech,aa.bcsuc,aa.bcrubr,aa.bcmda,aa.bcpap,aa.bcmod, 
                sum(aa.bcsdmo) bcsdmo, sum(aa.bcsdmn)bcsdmn, sum(aa.bcsdus)bcsdus
           from fsh012 aa
          where aa.bcfech = ld_fecha
            and aa.bcemp  = 1
            and aa.bcsuc = pn_suc
            and aa.bcrubr in (select rubro
                                from  fsd014
                               where pcimpu = 'S'
                                 and pmtit in (4, 5))
          group by  aa.bcemp,aa.bcfech,aa.bcsuc,aa.bcrubr,aa.bcmda,aa.bcpap,aa.bcmod) A, 
          FSH031 B
   WHERE a.bcemp  = b.pgcod
     and a.bcfech = b.drfch
     and a.bcsuc  = b.DRSUC
     and a.bcrubr = b.DRRUB
     and a.bcmda  = b.DRMDA
     and a.bcpap  = b.DRPAP
     and a.bcmod  = b.DRMOD
     and a.bcsdmo <> b.drsdor
     and b.drfch = ld_fecha
     and a.bcsuc = pn_suc;

  begin 
      update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = pn_suc
         and g.c_codage = 'AJUS';
      commit;
  
     --execute immediate ('truncate table jaql115');
     ld_feccie := to_date(pd_feccie,'yyyymmdd');
     insert into jaql115
     select /*+all_rows*/  ld_feccie bcfech, a.PGCOD, HASUC,HARUB,HAMDA,HAPAP,HACTA,HAOPER,HASBOP,
            HATOPE,HAANIO,HATOT,HAMOD,HAFVAL,HAFVTO,HAPZO,HASEGM,HAFUNC,HATIT,HACAP,HAPLZO,HAGRU,HASD12,HASD13,b.pmtit, 
            b.pmcap, b.pmpzo, b.pmgru
       from fsh014 a,  fsd014 b
      where haanio = pn_periodo
        and pgcod = 1
        and harub = rubro
        and pcimpu = 'S'
        and pmtit in (4,5)
        and hasd12 <> 0 
        and a.hasuc = pn_suc;
     commit;   
     -- obtener fecha de cierre ejercicio
     select distinct hfcon 
       into ld_fecpro
       from  fsh015 
      where pgcod = 1 
        and hcmod = 99 
        and htran = 700 
        and hfvc  = ld_feccie; 
     -- Restar saldo de 
     ld_Fecini := ld_feccie + 1;
     ld_Fecfin := ld_fecpro - 1;
     for i in cerear loop
         update fsh012 d
            set bcsdmo =  bcsdmo - i.hasd12,
                bcsdmn =  bcsdmn - i.hasd12,
                bcsdus =  bcsdus - i.hasd12            
          where bcemp = 1
            and bcfech between ld_fecini and ld_fecfin
            and d.bcsuc  = i.hasuc
            and d.bcrubr = i.harub
            and d.bcmda  = i.hamda
            and d.bcpap  = i.hapap
            and d.bccta  = i.hacta
            and d.bcoper = i.haoper
            and d.bcsbop = i.hasbop
            and d.bctop  = i.hatope
            and d.bcmod  = i.hamod;
         commit;   
         update fsh014
            set hasd12 = 0
          where pgcod  = 1
            and haanio = pn_periodo 
            and hasuc  = i.hasuc
            and harub  = i.harub
            and hamda  = i.hamda
            and hapap  = i.hapap
            and hacta  = i.hacta
            and haoper = i.haoper
            and hasbop = i.hasbop
            and hatope = i.hatope
            and hamod  = i.hamod;
          commit;  
     end loop;
     -- Cerea fsh031
     update fsh031 x
        set x.drsdor = 0,
            x.drsdus = 0,
            x.drsdmn = 0
      where drfch = ld_feccie 
        and pgcod = 1
        and drrub in (select rubro
                        from fsd014
                       where pcimpu = 'S'
                         and pmtit in (4, 5))
        and drsdor <> 0
        and x.drsuc = pn_suc;
      commit;  
     -- Cerrea fsh013
     update fsh013 a
        set  hrsd12 = 0
      where a.hranio = pn_periodo
        and pgcod = 1
        and hrrub in (select rubro
                        from fsd014
                       where pcimpu = 'S'
                         and pmtit in (4, 5))
        and hrsd12 <> 0
        and a.hrsuc = pn_suc;
      commit;  
       
     -- Recosntuir fh031 a partir de la fsh012
     for k in fecha (ld_Fecini , ld_Fecfin )loop
         for l in diferencia (k.ffecha) loop
             UPDATE FSH031
                SET drsdor = l.bcsdmo,
                    drsdus = l.bcsdus,
                    drsdmn = l.bcsdmN
              WHERE DRFCH     = l.BCFECH
                AND PGCOD     = l.bcemp
                AND DRSUC     = l.bcsuc 
                AND DRRUB     = l.drrub
                AND DRMDA     = l.BCMDA
                AND DRPAP     = l.BCPAP 
                AND DRMOD     = l.BCMOD;      
              COMMIT;
         end loop;
     end loop;
      update tab_jobs g
         set g.d_fecfin = sysdate
       where g.n_numer1 = pn_suc
         and g.c_codage = 'AJUS';
      commit;
  exception
     when others then
          lc_coderr := substr(sqlerrm,1,200);
          update tab_jobs g
             set g.c_inderr = 'S',
                 g.c_deserr = lc_coderr
           where g.n_numer1 = pn_suc
             and g.c_codage = 'AJUS';
  end;

end pq_bc_ajuste_ejercicio;
/

