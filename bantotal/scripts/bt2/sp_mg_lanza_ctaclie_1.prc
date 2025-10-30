create or replace procedure sp_mg_lanza_ctaclie_1 is


lc_variable VARCHAR2(2000);
ln_job NUMBER(10);

 BEGIN
  begin  execute immediate ('truncate table MIG$CTA_CLI'); exception when others then null; end;
  begin  execute immediate ('truncate table btctaman'); exception when others then null; end;
  begin  execute immediate ('truncate table btctacli'); exception when others then null; end;  
  begin  execute immediate ('drop index  XN_BTCTAMANDES_001'); exception when others then null; end;
  begin  execute immediate ('drop index  XN_BTCTAMAN_001'); exception when others then null; end;
  begin  execute immediate ('drop index  XN_BTCTAMAN_002'); exception when others then null; end;


    begin
        insert into MIG$CTA_CLI(cuenta,pais,tdoc,ndoc,cliente,nom,tit,tipo,Ope,sbop,mda,suc,codtcu,numfir,numfio,tipper,mixto)
          select CUENTA , PAIS , TDOC , NDOC , CLIENTE , Nom , Tit , Tipo , Ope , Sbop , Mda , Suc , CodTcu , NumFir , NumFio ,Tipper, MIXTO from MIG$CTA_CLI@credinka;
        commit;
    Exception
      When others then
        null;
    end;


  -- lanza estadisticas de tabla MIG$CTA_CLI    
    begin
      dbms_stats.unlock_schema_stats('bandejas');
      DBMS_STATS.gather_table_stats(ownname          => 'bandejas',
                                    tabname          => 'MIG$CTA_CLI',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
     
      
 --***************************************************
 -- lanza cta cliente SP_MG_CUENTAS
 --***************************************************
  ln_job := 0;
  lc_variable := NULL;
  lc_variable := ' begin   PQ_MG_CTACLIENTE.SP_MG_CUENTAS; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);


  dbms_scheduler.create_job(
         job_name=> 'CTACLI_CUENTAS'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true,
         auto_drop=> TRUE,
         comments => 'MIGRANDO PQ_MG_CTACLIENTE.SP_MG_CUENTAS'
         );
         COMMIT;

 --***************************************************
 -- lanza cta cliente CREDITOS
 --***************************************************
  ln_job := 0;
  lc_variable := NULL;
  lc_variable := ' begin   PQ_MG_CTACLIENTE.sp_mg_credito; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);


  dbms_scheduler.create_job(
         job_name=> 'CTACLI_CREDITO'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true,
         auto_drop=> TRUE,
         comments => 'MIGRANDO PQ_MG_CTACLIENTE.SP_MG_CREDITO'
         );
         COMMIT;

 --***************************************************
 -- lanza cta cliente GARANTIAS
 --***************************************************
  ln_job := 0;
  lc_variable := NULL;
  lc_variable := ' begin   PQ_MG_CTACLIENTE.sp_mg_garantia; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);


  dbms_scheduler.create_job(
         job_name=> 'CTACLI_GARANTIA'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true,
         auto_drop=> TRUE,
         comments => 'MIGRANDO PQ_MG_CTACLIENTE.sp_mg_garantia'
         );
         COMMIT;

 --***************************************************
 -- lanza cta cliente FIADORES
 --***************************************************
  ln_job := 0;
  lc_variable := NULL;
  lc_variable := ' begin   PQ_MG_CTACLIENTE.sp_mg_fiador; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);


  dbms_scheduler.create_job(
         job_name=> 'CTACLI_FIADOR'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true,
         auto_drop=> TRUE,
         comments => 'MIGRANDO PQ_MG_CTACLIENTE.sp_mg_fiador'
         );
         COMMIT;
         
 --***************************************************
 -- lanza cta cliente EMPLEADOR
 --***************************************************
  ln_job := 0;
  lc_variable := NULL;
  lc_variable := ' begin   PQ_MG_CTACLIENTE.sp_mg_empleador; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);


  dbms_scheduler.create_job(
         job_name=> 'CTACLI_EMPLEA'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true,
         auto_drop=> TRUE,
         comments => 'MIGRANDO PQ_MG_CTACLIENTE.sp_mg_empleador'
         );
         COMMIT;         

--***************************************************
 -- lanza creacion de cuenta cliente
 --***************************************************
  ln_job := 0;
  lc_variable := NULL;
  lc_variable := ' begin   pq_migra_personas_credinka_II.sp_MGM_ctacliente; End; ';
  ln_job := ln_job +1;
  dbms_output.put_line (lc_variable);


  dbms_scheduler.create_job(
         job_name=> 'CTACLI_INSERTA'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true,
         auto_drop=> TRUE,
         comments => 'MIGRANDO pq_migra_personas_credinka_II.sp_MGM_ctacliente'
         );
         COMMIT;
   
end sp_mg_lanza_ctaclie_1;
/
