create or replace package pq_ah_genera_opciones is

  -- Author  : YLOZADA
  -- Created : 04/04/2018 09:03:26 a.m.
  -- Purpose : 
  Procedure sp_ah_crea_schedulers(P_D_FECPRO IN DATE,
                                  P_N_TIPPRO IN NUMBER
                                  );
   
  Procedure sp_ah_lanza_schedulers(P_N_JOBINI IN NUMBER,
                                   P_N_JOBFIN IN NUMBER,
                                   P_N_NUMJOB IN NUMBER,
                                   P_C_FECPRO IN VARCHAR2,
                                   P_N_TIPPRO IN NUMBER
                                  );
  Function fn_ah_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_NOMUSR IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2
                               ) return number;                                  

end pq_ah_genera_opciones;
/

create or replace package body pq_ah_genera_opciones is

  Procedure sp_ah_crea_schedulers(P_D_FECPRO IN DATE,
                                  P_N_TIPPRO IN NUMBER
                                 ) is
     
    cursor c_jobs  is
      select substr(jaqz169cta,1,1)  j_ini,
             nvl(substr(jaqz169cta,2,1),'-1')  j_fin
        from JAQZ169       
    group by substr(jaqz169cta,1,1),
             nvl(substr(jaqz169cta,2,1),'-1');   
  
    lc_variable   varchar2(4000);   
    pi_vc2_nomjob varchar2(65);
    lc_fecpro     varchar2(10);
    ln_cont       number(9):=0;
    lc_hostname   varchar2(64);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9):=0;
  
  begin
    --Obtener hostname
    begin
      select host_name
        into lc_hostname
        from v$instance;
    end;
   
    lc_fecpro := to_char(P_D_FECPRO, 'dd/mm/rrrr');
    for i in c_jobs loop
      ln_cont       := ln_cont + 1;  
      lc_prefjob    := 'OPT_AHO_'; 
      pi_vc2_nomjob := lc_prefjob ||to_char(P_D_FECPRO, 'ddmmrrrr')||lpad(ln_cont,3,'0');    
      lc_variable   := ' begin ' ||
                     ' pq_ah_genera_opciones.sp_ah_lanza_schedulers(' || i.j_ini || ',' ||
                     i.j_fin || ',' ||ln_cont  || ',' || '''' || lc_fecpro || '''' ||','||P_N_TIPPRO|| ');' || ' End; ';
                     
--      if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then            
IF SYS.FN_BD_ISRAC='TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Opciones_sorteo'
                                 );                    
        begin        
              dbms_scheduler.set_attribute(pi_vc2_nomjob,'instance_id',2);
        end;                                  
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Opciones_sorteo'
                                 );       
        begin        
              dbms_scheduler.set_attribute(pi_vc2_nomjob,'instance_id',1);
        end;                                      
      End If;  
      commit;  
        
      INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
      VALUES('OPT_AHO',ln_cont,lc_variable);
      COMMIT;        
    end loop;  
    
    ln_numjob := fn_ah_verifica_tarea(lc_prefjob,user,lc_hostname);
    
    While ln_numjob > 0 loop    
      ln_numjob := fn_ah_verifica_tarea(lc_prefjob,user,lc_hostname);
    End loop;    
       
  end sp_ah_crea_schedulers;
  Procedure sp_ah_lanza_schedulers(P_N_JOBINI IN NUMBER,
                                   P_N_JOBFIN IN NUMBER,
                                   P_N_NUMJOB IN NUMBER,
                                   P_C_FECPRO IN VARCHAR2,
                                   P_N_TIPPRO IN NUMBER
                                  ) is
 cursor c_opciones(ld_feccor in date,ld_fecpro in date) is
    select jaqz169pgc,
           jaqz169mod,
           jaqz169suc,
           jaqz169mda,
           jaqz169pap,
           jaqz169cta,
           jaqz169ope,
           jaqz169sbo,
           jaqz169tpo,
           lpad(jaqz169cta,9,'0')||lpad(jaqz169mod,3,'0')||lpad(jaqz169mda,3,'0')||lpad(jaqz169sbo,2,'0')||lpad(jaqz169tpo,3,'0') cuenta,
           jaqz169fec,
           'S' estado,
           jaqz169opt,
           jaqz169sor,
           jaqz169ax5
      from JAQZ169 
     where jaqz169fec = ld_fecpro
       and substr(jaqz169cta,1,1) = P_N_JOBINI
       and nvl(substr(jaqz169cta,2,1),'-1') = P_N_JOBFIN       
       and (case                
                when (ld_feccor is null) and (jaqz169opt > 0 and jaqz169fec = jaqz169ax5) then
                     1  
                when (ld_feccor is not null) and (jaqz169opt > 0 or jaqz169sor > 0) then     
                     1                   
                Else
                     0
                End          
             ) = 1
       ; 
       
cursor c_opciones_reg(ld_feccor in date,ld_fecpro in date) is
    select jaqz169pgc,
           jaqz169mod,
           jaqz169suc,
           jaqz169mda,
           jaqz169pap,
           jaqz169cta,
           jaqz169ope,
           jaqz169sbo,
           jaqz169tpo,
           lpad(jaqz169cta,9,'0')||lpad(jaqz169mod,3,'0')||lpad(jaqz169mda,3,'0')||lpad(jaqz169sbo,2,'0')||lpad(jaqz169tpo,3,'0') cuenta,
           jaqz169fec,
           'S' estado,
           jaqz169opt,
           jaqz169sor,
           jaqz169ax5
      from JAQZ169 
     where jaqz169ax5 = ld_fecpro
       and substr(jaqz169cta,1,1) = P_N_JOBINI
       and nvl(substr(jaqz169cta,2,1),'-1') = P_N_JOBFIN       
       and (case                
                when (ld_feccor is null) and (jaqz169opt > 0 and ld_fecpro = jaqz169ax5) then
                     1  
                when (ld_feccor is not null) and (jaqz169opt > 0 or jaqz169sor > 0) then     
                     1                   
                Else
                     0
                End          
             ) = 1
       ;        
       
  ld_feccor date;        
  ld_fecpro date; 
  ln_cont   number(9);  
  lc_deserr varchar2(200);                                    
  begin
    
   update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 =  P_N_NUMJOB
     and g.c_codage = 'OPT_AHO';
     commit;
  
    ld_fecpro := TO_DATE(P_C_FECPRO,'DD/MM/RRRR');
   --verificamos si fecha de proceso es igual a fecha de corte de sorteo
    begin
      select to_date(trim(x.tp1desc),'dd/mm/rrrr')
        into ld_feccor
        from fst198 x
       where x.tp1cod   = 1
         and x.tp1cod1  = 10825
         and x.tp1corr1 = 60
         and x.tp1corr2 = 3
         and to_date(trim(x.tp1desc),'dd/mm/rrrr') = ld_fecpro;       
    exception 
    when others then
      ld_feccor := NULL;
    end; 
    If P_N_TIPPRO = 1 then
      For i in c_opciones_reg(ld_feccor,ld_fecpro) loop
        ln_cont := i.jaqz169opt;
                
        --verifica cuanto cupones tiene antes de insertarlo
                
        For j in 1..ln_cont loop
          begin
            insert into JAQL406(jaql406cup,    
                                jaql406pgc,    
                                jaql406mod,    
                                jaql406suc,    
                                jaql406mda,    
                                jaql406pap,    
                                jaql406cta,   
                                jaql406ope,    
                                jaql406sbo,    
                                jaql406top,    
                                jaql406cre,    
                                jaql406fec,    
                                jaql406est,    
                                jaql406opc,
                                jaql406tip,
                                Jaql406excup,
                                jaql406fop                                   
                               )
                         values(SQ_CR_JAQL406_1.NEXTVAL,
                                i.jaqz169pgc,
                                i.jaqz169mod,
                                i.jaqz169suc,
                                i.jaqz169mda,
                                i.jaqz169pap,
                                i.jaqz169cta,
                                i.jaqz169ope,
                                i.jaqz169sbo,
                                i.jaqz169tpo,
                                i.cuenta,
                                ld_fecpro,
                                i.estado,
                                i.jaqz169opt,
                                'A',
                                'C',
                                ld_fecpro                                                                  
                               );

          exception
          when others then  
              lc_deserr := 'No se pudo copiar opciones por apertura reg - '||P_N_JOBINI||'-'||P_N_JOBFIN||'-'||P_N_NUMJOB||'-'||sqlerrm;   
              --registra log
              insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values (P_N_NUMJOB,'OPT_AHO',lc_deserr,ld_fecpro);                            
              update tab_jobs g
                   set g.d_fecfin = sysdate
                 where g.n_numer1 =  P_N_NUMJOB
                   and g.c_codage = 'OPT_AHO'
                   and g.c_inderr = 'S';
                   commit;  
              return;
          end;
        End loop;
      End loop;      
    Else
        if ld_feccor is null then
              For i in c_opciones(ld_feccor,ld_fecpro) loop
                ln_cont := i.jaqz169opt;
                
                --verifica cuanto cupones tiene antes de insertarlo
                
                For j in 1..ln_cont loop
                  begin
                    insert into JAQL406(jaql406cup,    
                                        jaql406pgc,    
                                        jaql406mod,    
                                        jaql406suc,    
                                        jaql406mda,    
                                        jaql406pap,    
                                        jaql406cta,   
                                        jaql406ope,    
                                        jaql406sbo,    
                                        jaql406top,    
                                        jaql406cre,    
                                        jaql406fec,    
                                        jaql406est,    
                                        jaql406opc,
                                        jaql406tip,
                                        Jaql406excup,
                                        jaql406fop                                   
                                       )
                                 values(SQ_CR_JAQL406_1.NEXTVAL,
                                        i.jaqz169pgc,
                                        i.jaqz169mod,
                                        i.jaqz169suc,
                                        i.jaqz169mda,
                                        i.jaqz169pap,
                                        i.jaqz169cta,
                                        i.jaqz169ope,
                                        i.jaqz169sbo,
                                        i.jaqz169tpo,
                                        i.cuenta,
                                        i.jaqz169fec,
                                        i.estado,
                                        i.jaqz169opt,
                                        'A',
                                        'C',
                                        i.jaqz169fec                                                                  
                                       );

                  exception
                  when others then  
                      lc_deserr := 'No se pudo copiar opciones por apertura - '||P_N_JOBINI||'-'||P_N_JOBFIN||'-'||P_N_NUMJOB||'-'||sqlerrm;   
                      --registra log
                      insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values (P_N_NUMJOB,'OPT_AHO',lc_deserr,ld_fecpro);                            
                      update tab_jobs g
                           set g.d_fecfin = sysdate
                         where g.n_numer1 =  P_N_NUMJOB
                           and g.c_codage = 'OPT_AHO'
                           and g.c_inderr = 'S';
                           commit;  
                      return;
                  end;
                End loop;
              End loop;
        Else
              For i in c_opciones(ld_feccor,ld_fecpro) loop
                ln_cont := i.jaqz169sor;
                For j in 1..ln_cont loop
                  begin
                    insert into JAQL406(jaql406cup,    
                                        jaql406pgc,    
                                        jaql406mod,    
                                        jaql406suc,    
                                        jaql406mda,    
                                        jaql406pap,    
                                        jaql406cta,   
                                        jaql406ope,    
                                        jaql406sbo,    
                                        jaql406top,    
                                        jaql406cre,    
                                        jaql406fec,    
                                        jaql406est,    
                                        jaql406opc,
                                        jaql406tip,
                                        Jaql406excup,
                                        jaql406fop 
                                       )
                                 values(SQ_CR_JAQL406_1.NEXTVAL,
                                        i.jaqz169pgc,
                                        i.jaqz169mod,
                                        i.jaqz169suc,
                                        i.jaqz169mda,
                                        i.jaqz169pap,
                                        i.jaqz169cta,
                                        i.jaqz169ope,
                                        i.jaqz169sbo,
                                        i.jaqz169tpo,
                                        i.cuenta,
                                        i.jaqz169fec,
                                        i.estado,
                                        i.jaqz169sor,
                                        'A',
                                        'C',
                                        i.jaqz169fec
                                       );

                  exception
                  when others then  
                      lc_deserr := 'No se pudo copiar opciones por incremento - '||P_N_JOBINI||'-'||P_N_JOBFIN||'-'||P_N_NUMJOB||'-'||sqlerrm;   
                      --registra log
                      insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values (P_N_NUMJOB,'OPT_AHO',lc_deserr,ld_fecpro);                            
                      update tab_jobs g
                           set g.d_fecfin = sysdate
                         where g.n_numer1 =  P_N_NUMJOB
                           and g.c_codage = 'OPT_AHO'
                           and g.c_inderr = 'S';
                           commit;  
                      return;
                  end;
                End loop;
                
                ln_cont := i.jaqz169opt;
                if i.jaqz169ax5 = ld_fecpro then
                  For j in 1..ln_cont loop
                    begin
                      insert into JAQL406(jaql406cup,    
                                          jaql406pgc,    
                                          jaql406mod,    
                                          jaql406suc,    
                                          jaql406mda,    
                                          jaql406pap,    
                                          jaql406cta,   
                                          jaql406ope,    
                                          jaql406sbo,    
                                          jaql406top,    
                                          jaql406cre,    
                                          jaql406fec,    
                                          jaql406est,    
                                          jaql406opc,
                                          jaql406tip,
                                          Jaql406excup,
                                          jaql406fop 
                                         )
                                   values(SQ_CR_JAQL406_1.NEXTVAL,
                                          i.jaqz169pgc,
                                          i.jaqz169mod,
                                          i.jaqz169suc,
                                          i.jaqz169mda,
                                          i.jaqz169pap,
                                          i.jaqz169cta,
                                          i.jaqz169ope,
                                          i.jaqz169sbo,
                                          i.jaqz169tpo,
                                          i.cuenta,
                                          i.jaqz169fec,
                                          i.estado,
                                          i.jaqz169opt,
                                          'A',
                                          'C',
                                          i.jaqz169fec
                                         );

                    exception
                    when others then  
                        lc_deserr := 'No se pudo copiar opciones por apertura - '||P_N_JOBINI||'-'||P_N_JOBFIN||'-'||P_N_NUMJOB||'-'||sqlerrm;   
                        --registra log
                        insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values (P_N_NUMJOB,'OPT_AHO',lc_deserr,ld_fecpro);                            
                        update tab_jobs g
                             set g.d_fecfin = sysdate
                           where g.n_numer1 =  P_N_NUMJOB
                             and g.c_codage = 'OPT_AHO'
                             and g.c_inderr = 'S';
                             commit;                      
                        return;
                    end;
                  End loop;   
                End If;         
              End loop;          
        End If;
    End If;
    commit;
    
    update tab_jobs g
         set g.d_fecfin = sysdate
       where g.n_numer1 =  P_N_NUMJOB
         and g.c_codage = 'OPT_AHO';
         commit;                                           
  Exception
  when others then  
    update tab_jobs g
         set g.d_fecfin = sysdate
       where g.n_numer1 =  P_N_NUMJOB
         and g.c_codage = 'OPT_AHO'
         and g.c_inderr = 'S';
         commit;       
  End sp_ah_lanza_schedulers;  
  
  Function fn_ah_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_NOMUSR IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2
                               ) return number is
  ln_numjob number(9):=0;
  v_found number;
  begin
    
--     if  UPPER(P_C_HOSTNA) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then   

  SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(P_C_HOSTNA);

     if v_found =1 then 
  
        SELECT COUNT(1)
          INTO ln_numjob
          FROM dba_scheduler_running_jobs job
         WHERE owner = 'BANTPROD'
           AND job.job_name LIKE P_C_NOMJOB || '%';     
     Else
        SELECT COUNT(1)
          INTO ln_numjob
          FROM dba_scheduler_running_jobs job
         WHERE owner = P_C_NOMUSR      
           AND job.job_name LIKE P_C_NOMJOB || '%';          
     End If;  
  
  return ln_numjob;  
  end fn_ah_verifica_tarea;  
    
  
end pq_ah_genera_opciones;
/

