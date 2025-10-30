create or replace procedure sp_mg_lanza_inventarios_II_cdk
 is


NUM_JOB_PENDIENTES NUMBER(10);
lc_variable VARCHAR2(2000);
ln_job NUMBER(10);
lc_error VARCHAR2(200);
lc_msgerr VARCHAR2(200);

 BEGIN
 
 --***************************************************
 -- LIMPIA TABLAS
 --*************************************************** 
 execute immediate ('truncate table bandejas.bnj002');
 execute immediate ('truncate table bandejas.bnj005');
 --execute immediate ('truncate table bandejas.BNJ700');
 execute immediate ('truncate table bandejas.bjr011');
 execute immediate ('truncate table bandejas.FSD012_tmp');
 execute immediate ('truncate table bandejas.JAQL165_tmp');
 execute immediate ('truncate table bandejas.JAQL166_tmp');
 execute immediate ('truncate table bandejas.JAQY068_tmp');

 
--***************************************************
 -- Datos Adicionales de judiciales
 --*************************************************** 
BEGIN pq_migra_Activas_cdk.sp_llena_BNJ002; End;
BEGIN pq_migra_Activas_cdk.sp_llena_BNJ005; End;
BEGIN pq_migra_Activas_cdk.sp_llena_bjr011; End;
BEGIN pq_migra_Activas_cdk.sp_llena_JAQL165; End;
BEGIN pq_migra_Activas_cdk.sp_llena_JAQL166; End;
BEGIN pq_migra_Activas_cdk.sp_llena_JAQY068; End;
BEGIN pq_migra_Activas_cdk.sp_llena_FSD012_tmp; End;

  /*ln_job := 0; 
  lc_variable := NULL;
  lc_variable := ' begin   pq_migra_otros_manual.sp_job_dat_adic_jud; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);
  dbms_scheduler.create_job(
   job_name=> 'DAT_JUD'||LPAD(TO_CHAR(ln_job),5,'0'),
   job_type=> 'PLSQL_BLOCK',
   job_action=> lc_variable,
   start_date => sysdate+1/(24*180),
   enabled => true, 
   auto_drop=> TRUE,
   comments => 'DATOS ADICIONALES JUDICIALES'
   );
   COMMIT;*/
       
--***************************************************
 -- Procesa DAtos para Evaluaciones
 --***************************************************            
  /*ln_job := 0; 
  lc_variable := NULL;
  lc_variable := ' begin   migra2.pq_migra_eval_cred.sp_jobs_procesa_datos; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);

  dbms_scheduler.create_job(
         job_name=> 'DAT_EVA'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'PROCESA EVALUACIONES'
         );
         COMMIT;       */         
  --***************************************************
 -- Evaluaciones
 --***************************************************            
 /* ln_job := 0; 
  lc_variable := NULL;
  lc_variable := ' begin   migra2.pq_migra_eval_cred.sp_job_evaluaciones; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);

  dbms_scheduler.create_job(
         job_name=> 'EVA_CRED'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'MIGRANDO XWF700'
         );
         COMMIT;     
*/

 --***************************************************
 -- Datos Para Visualizar Evaluaciones
 --***************************************************            
  /*ln_job := 0; 
  lc_variable := NULL;
  lc_variable := ' begin   migra2.pq_migra_eval_cred.sp_jobs_procesa_XWF700; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);

  dbms_scheduler.create_job(
         job_name=> 'EVA_XWF700'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'MIGRANDO XWF700'
         );
         COMMIT; 

*/
--***************************************************
 -- Datos Para Visualizar SNG122
 --***************************************************            
  /*ln_job := 0; 
  lc_variable := NULL;
  lc_variable := ' begin   migra2.pq_migra_eval_cred.sp_jobs_procesa_SNG122; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);

  dbms_scheduler.create_job(
         job_name=> 'S12_SNG122'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'MIGRANDO SNG122'
         );
         COMMIT; */
           
 --***************************************************
 -- Categorizacion
 --***************************************************            
 /* ln_job := 0; 
  lc_variable := NULL;
  lc_variable := ' begin   migra2.pq_activas_categorizacion.sp_migra_categorizacion; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);

  dbms_scheduler.create_job(
         job_name=> 'FSD212'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'MIGRANDO CATEGORIZACION ACTIVAS'
         );
         COMMIT;
                             */  
                                             
end sp_mg_lanza_inventarios_II_cdk;
/
