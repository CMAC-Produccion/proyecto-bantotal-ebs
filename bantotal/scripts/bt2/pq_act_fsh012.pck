create or replace package pq_ACT_FSH012 is
 
  Procedure sp_job_act_ciuu_h12 (pd_fecpro in varchar2, pn_sistema number );
  Procedure sp_act_ciuu_h12 (pn_numsuc in number, pd_fecpro in varchar2, pn_sistema in number );

  
end pq_ACT_FSH012;
/

create or replace package body pq_ACT_FSH012 is


Procedure sp_job_act_ciuu_h12 (pd_fecpro in varchar2, pn_sistema number ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_hostname varchar2(64);
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(500);
  ln_sis number;
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     delete migra2.Tab_jobs where  c_Codage = 'FH12';
     commit;
     ln_sis := pn_sistema;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_ACT_FSH012.sp_act_ciuu_h12('||ln_ini||','||''''||Pd_FECpro||'''' ||','||ln_sis||');'|| ' End; ';
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
                      instance => 2,
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
        INSERT INTO migra2.Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('FH12',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO migra2.LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'FSH12',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
Procedure sp_act_ciuu_h12 (pn_numsuc in number, pd_fecpro in varchar2, pn_sistema in number ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = pn_sistema))
     and pcimpu = 'S';
ld_fecant date;

cursor actualiza ( ln_rubro in number, ld_fecpro in date) is
SELECT /*+ALL_ROWS PARALLEL(A,2,1) PARALLEL(B,2,1) PARALLEL(C,2,1)*/ 
       DISTINCT A.BCACTI, C.ACTCOD2 
   FROM FSH012 A , FSD008 B, FST750 C
  WHERE BCEMP = 1
    AND BCFECH = ld_fecpro
    AND BCSUC = pn_numsuc
    AND BCRUBR = ln_rubro
    AND A.BCCTA = B.CTNRO
    AND B.CTNROI = C.ACTCOD1
    AND A.BCACTI <> C.ACTCOD2;

begin

  update migra2.tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'FH12';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  

  for i in rubro loop
    for j in actualiza ( i.rubro, ld_fecpro) loop
     begin 
         UPDATE FSH012
            SET BCACTI = j.actcod2
          WHERE BCEMP  = 1
            AND BCFECH = ld_fecpro
            AND BCSUC  = pn_numsuc
            AND BCRUBR = i.rubro
            and BCACTI = j.BCACTI;
     commit;
     exception
        when others then
           lc_coderr:=sqlerrm;
           INSERT INTO migra2.LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'FSH12',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
           
     end;  
    end loop;      
     commit;
  end loop; 
  commit;
  update migra2.tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'FH12';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update migra2.tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'FH12';
    commit;
    return;

end sp_act_ciuu_h12;  

  
end pq_ACT_FSH012;
/

