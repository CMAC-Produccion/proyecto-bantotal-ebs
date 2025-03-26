CREATE OR REPLACE PROCEDURE SP_MG_LANZA_PASIVAS IS

lc_variable VARCHAR2(2000);
ln_job NUMBER(10):= 0;
BEGIN
  execute immediate ('truncate table bnj002')  ;
  execute immediate ('truncate table bnj004')  ;
  execute immediate ('truncate table bnj012')  ;
  execute immediate ('truncate table bnj601')  ;
  execute immediate ('truncate table bnj602')  ;
  execute immediate ('truncate table bjr011')  ;  
  execute immediate ('truncate table bjr111')  ;    
  execute immediate ('truncate table bnjti2')  ;      
  -- Se agrego para credinka
  execute immediate ('truncate table bjd016')  ;
--  execute immediate ('truncate table jaql714')  ; --son tablas de produccion
/*    begin
      do_truncate('jaql714');
    end;*/

  execute immediate ('delete from CTS001 WHERE ctsusurg=''CLUREN''');

  
  EXECUTE IMMEDIATE ('truncate table LOG_ERROR_BANDEJA');


    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bnj002; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BNJ002'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BNJ002'
             );

        COMMIT;
    end; 
    
    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bnj004; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BNJ004'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BNJ004'
             );

        COMMIT;
    end;       

    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bnj012; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BNJ012'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BNJ012'
             );

        COMMIT;
    end;  

    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bnj601; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BNJ601'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BNJ601'
             );

        COMMIT;
    end;  

    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bnj602; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BNJ602'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BNJ602'
             );

        COMMIT;
    end;  

    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_jaql714; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'JAQL714'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_JAQL714'
             );

        COMMIT;
    end;  

    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_cts001; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'CTS001'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_CTS001'
             );

        COMMIT;
    end;
    
    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bjr011; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BJR011'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BJR011'
             );

        COMMIT;
    end;      
    
    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bjr111; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BJR111'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BJR111'
             );

        COMMIT;
    end;      
    
    begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bnjti2; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BNJTI2'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BNJTI2'
             );

        COMMIT;
    end;    
     begin

        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_pasivas.sp_bandeja_bjd016; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'BJD016'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_BJD016'
             );

        COMMIT;
    end;             
END;
/
