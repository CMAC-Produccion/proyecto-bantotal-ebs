CREATE OR REPLACE PACKAGE PQ_MG_CTACLIENTE  IS

PROCEDURE SP_MG_CUENTAS;
procedure sp_mg_credito;
procedure sp_mg_garantia;
procedure sp_mg_fiador;
procedure sp_mg_empleador;
procedure sp_mg_gen_estadis (pi_vc2_user in varchar2,
                              pi_vc2_nomtab in varchar2,
                              pi_vc2_tarea_wait in varchar2                              
                             );
END PQ_MG_CTACLIENTE;
/
CREATE OR REPLACE PACKAGE BODY PQ_MG_CTACLIENTE  IS

 PROCEDURE SP_MG_CUENTAS IS
   cursor cuenta is
        select distinct 
               a.CUENTA
          from MIG$CTA_CLI  a where a.tipo in ('A','D')
         order by 1;
   cursor persona(lc_cuenta in varchar2) is  
        select distinct 
               a.CUENTA,
               lpad(a.PAIS,3,'0')||lpad(a.TDOC,3,'0')||lpad(trim(a.NDOC),12,'0')||a.tit c_codper
          from MIG$CTA_CLI  a 
         where a.CUENTA = lc_cuenta
           and a.tipo in ('A','D') 
         order by 1,2;   
         
  lv_concatena varchar2(400);    
  lc_msgerr    varchar2(400);   
  ln_cont   number(10):=0;               
  ln_nro    log_carga_bandeja.n_nro%type;
  ld_fecfin date;
  ld_fecini date;

 begin

  ld_fecini := sysdate;
    select seq_nro_ejecucion.NEXTVAL into ln_nro from dual;    
    
    insert into LOG_CARGA_BANDEJA
      (n_nro,c_codbdj,c_cptbdj,d_fecini)
    values
      (ln_nro,
       'BTCTACLI_CUENTAS',
       'Tabla de Cuentas Bantotal Generado para los Clientes Luren-CUENTAS',
       ld_fecini);
    commit;
 
    for i in cuenta loop          
        lv_concatena := null;
        for j in persona(i.cuenta) loop
          if i.cuenta = j.cuenta then
            lv_concatena := lv_concatena || j.c_codper;
          else
            lv_concatena := null;
          end if;
        end loop;
        begin
            insert into btctaman
              (c_numcta,c_codper,c_indpro)
            values
              (i.CUENTA,lv_concatena,'A');
        exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTAMAN',lc_msgerr,trunc(sysdate));
        end;   
        ln_cont := ln_cont + 1;     
        lv_concatena := null;                
        
        if mod(ln_cont, 10000) =0 then 
           commit;        
        end if;
        
    End Loop;  
    commit;
   
   
     ld_fecfin := sysdate;  
  update LOG_CARGA_BANDEJA   logban
   set logban.d_fecfin = ld_fecfin
  where  logban.n_nro=ln_nro
   and c_codbdj = 'BTCTACLI_CUENTAS';
  commit; 
  
 end;     
 
 --*************************************************************************************
 procedure sp_mg_credito is
 
   cursor cuenta is
        select distinct 
               a.CUENTA
          from MIG$CTA_CLI  a where a.tipo = 'C'
         order by 1;

   cursor persona(lc_cuenta in varchar2) is  
        select distinct 
               a.CUENTA,
               lpad(a.PAIS,3,'0')||lpad(a.TDOC,3,'0')||lpad(trim(a.NDOC),12,'0')||a.tit c_codper
          from MIG$CTA_CLI  a 
         where a.CUENTA = lc_cuenta
           and a.tipo = 'C' 
         order by 1,2;        
             
  lv_concatena varchar2(400);    
  lc_msgerr    varchar2(400);   
  ln_cont   number(10):=0;               
  ln_nro    log_carga_bandeja.n_nro%type;
  ld_fecini date;
 begin

  ld_fecini := sysdate;
    select seq_nro_ejecucion.NEXTVAL into ln_nro from dual;    
    
    insert into LOG_CARGA_BANDEJA
      (n_nro,c_codbdj,c_cptbdj,d_fecini)
    values
      (ln_nro,
       'BTCTACLI_CUENTAS',
       'Tabla de Cuentas Bantotal Generado para los Clientes Luren-CUENTAS',
       ld_fecini);
    commit;
 
    for i in cuenta loop          
        lv_concatena := null;
        for j in persona(i.cuenta) loop
          if i.cuenta = j.cuenta then
            lv_concatena := lv_concatena || j.c_codper;
          else
            lv_concatena := null;
          end if;
        end loop;
        begin
            insert into btctaman
              (c_numcta,c_codper,c_indpro)
            values
              (i.CUENTA,lv_concatena,'C');
        exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTAMAN',lc_msgerr,trunc(sysdate));
        end;   
        ln_cont := ln_cont + 1;     
        lv_concatena := null;                
        
        if mod(ln_cont, 10000) =0 then 
           commit;        
        end if;
        
    End Loop;  
    commit;
   
   
 end sp_mg_credito;
 
 ---------------------------------------------------------------------------------------------
 procedure sp_mg_garantia is 
 
   cursor cuenta is
        select distinct 
               a.CUENTA
          from MIG$CTA_CLI  a where a.tipo = 'G'
         order by 1;
         
   cursor persona(lc_cuenta in varchar2) is  
        select distinct 
               a.CUENTA,
               lpad(a.PAIS,3,'0')||lpad(a.TDOC,3,'0')||lpad(trim(a.NDOC),12,'0')||a.tit c_codper
          from MIG$CTA_CLI  a 
         where a.CUENTA = lc_cuenta
           and a.tipo = 'G' 
         order by 1,2;   
         
  lv_concatena varchar2(400);    
  lc_msgerr    varchar2(400);     
  ln_cont   number(10):=0;               
  ln_nro    log_carga_bandeja.n_nro%type;  
  ld_fecini date;
 begin

  ld_fecini := sysdate;
    select seq_nro_ejecucion.NEXTVAL into ln_nro from dual;    
    
    insert into LOG_CARGA_BANDEJA
      (n_nro,c_codbdj,c_cptbdj,d_fecini)
    values
      (ln_nro,
       'BTCTACLI_CUENTAS',
       'Tabla de Cuentas Bantotal Generado para los Clientes Luren-CUENTAS',
       ld_fecini);
    commit;
 
    for i in cuenta loop          
        lv_concatena := null;
        for j in persona(i.cuenta) loop
          if i.cuenta = j.cuenta then
            lv_concatena := lv_concatena || j.c_codper;
          else
            lv_concatena := null;
          end if;
        end loop;
        begin
            insert into btctaman
              (c_numcta,c_codper,c_indpro)
            values
              (i.CUENTA,lv_concatena,'G');
        exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTAMAN',lc_msgerr,trunc(sysdate));
        end;   
        ln_cont := ln_cont + 1;     
        lv_concatena := null;                
        
        if mod(ln_cont, 10000) =0 then 
           commit;        
        end if;
        
    End Loop;  
    commit;      
 end ;  

  procedure sp_mg_fiador is 
 
   cursor cuenta is
        select distinct 
               a.CUENTA
          from MIG$CTA_CLI  a where a.tipo = 'F'
         order by 1;
         
   cursor persona(lc_cuenta in varchar2) is  
        select distinct 
               a.CUENTA,
               lpad(a.PAIS,3,'0')||lpad(a.TDOC,3,'0')||lpad(trim(a.NDOC),12,'0')||a.tit c_codper
          from MIG$CTA_CLI  a 
         where a.CUENTA = lc_cuenta
           and a.tipo = 'F' 
         order by 1,2;   
         
  lv_concatena varchar2(400);    
  lc_msgerr    varchar2(400);     
  ln_cont   number(10):=0;               
  ln_nro    log_carga_bandeja.n_nro%type;  
  ld_fecini date;
 begin

  ld_fecini := sysdate;
    select seq_nro_ejecucion.NEXTVAL into ln_nro from dual;    
    
    insert into LOG_CARGA_BANDEJA
      (n_nro,c_codbdj,c_cptbdj,d_fecini)
    values
      (ln_nro,
       'BTCTACLI_CUENTAS',
       'Tabla de Cuentas Bantotal Generado para los Clientes Luren-CUENTAS',
       ld_fecini);
    commit;
 
    for i in cuenta loop          
        lv_concatena := null;
        for j in persona(i.cuenta) loop
          if i.cuenta = j.cuenta then
            lv_concatena := lv_concatena || j.c_codper;
          else
            lv_concatena := null;
          end if;
        end loop;
        begin
            insert into btctaman
              (c_numcta,c_codper,c_indpro)
            values
              (i.CUENTA,lv_concatena,'F');
        exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTAMAN',lc_msgerr,trunc(sysdate));
        end;   
        ln_cont := ln_cont + 1;     
        lv_concatena := null;                
        
        if mod(ln_cont, 10000) =0 then 
           commit;        
        end if;
        
    End Loop;  
    commit;      
 end ;  
----------------------------------------------------------------------------------------
   procedure sp_mg_empleador is 
 
   cursor cuenta is
        select distinct 
               a.CUENTA
          from MIG$CTA_CLI  a where a.tipo = 'E'
         order by 1;
         
   cursor persona(lc_cuenta in varchar2) is  
        select distinct 
               a.CUENTA,
               lpad(a.PAIS,3,'0')||lpad(a.TDOC,3,'0')||lpad(trim(a.NDOC),12,'0')||a.tit c_codper
          from MIG$CTA_CLI  a 
         where a.CUENTA = lc_cuenta
           and a.tipo = 'E' 
         order by 1,2;   
         
  lv_concatena varchar2(400);    
  lc_msgerr    varchar2(400);     
  ln_cont   number(10):=0;               
  ln_nro    log_carga_bandeja.n_nro%type;  
  ld_fecini date;
 begin

  ld_fecini := sysdate;
    select seq_nro_ejecucion.NEXTVAL into ln_nro from dual;    
    
    insert into LOG_CARGA_BANDEJA
      (n_nro,c_codbdj,c_cptbdj,d_fecini)
    values
      (ln_nro,
       'BTCTACLI_CUENTAS',
       'Tabla de Cuentas Bantotal Generado para los Clientes Luren-CUENTAS',
       ld_fecini);
    commit;
 
    for i in cuenta loop          
        lv_concatena := null;
        for j in persona(i.cuenta) loop
          if i.cuenta = j.cuenta then
            lv_concatena := lv_concatena || j.c_codper;
          else
            lv_concatena := null;
          end if;
        end loop;
        begin
            insert into btctaman
              (c_numcta,c_codper,c_indpro)
            values
              (i.CUENTA,lv_concatena,'E');
        exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTAMAN',lc_msgerr,trunc(sysdate));
        end;   
        ln_cont := ln_cont + 1;     
        lv_concatena := null;                
        
        if mod(ln_cont, 10000) =0 then 
           commit;        
        end if;
        
    End Loop;  
    commit;      
 end ;  
  

-----------------------------------------------------------------------------------
 procedure sp_mg_gen_estadis (pi_vc2_user in varchar2,
                              pi_vc2_nomtab in varchar2,
                              pi_vc2_tarea_wait in varchar2
                             ) is


NUM_JOB_PENDIENTES number;
 begin
 
 NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => pi_vc2_tarea_wait,
   pi_vc2_nomusr => pi_vc2_user
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => pi_vc2_tarea_wait,
   pi_vc2_nomusr => pi_vc2_user
   );
 
  END LOOP;   
  dbms_stats.unlock_schema_stats('bandejas'); 
  DBMS_STATS.gather_table_stats(ownname          => pi_vc2_user,
                                tabname          => pi_vc2_nomtab,
                                degree           => 4,
                                granularity      => 'ALL',
                                estimate_percent => dbms_stats.auto_sample_size,
                                cascade          => TRUE);    
        
 end;   


 

END PQ_MG_CTACLIENTE;
/
