create or replace package PQ_CR_EJEC_SEGM_MENS_NUEV22 is

  -- Author  : IGS_RCASTRO
  -- Created : 24/10/2022 14:19:06
  -- Purpose : Programa principal de ejecución de Segmentación Mensual MYPE 2022
  

  PROCEDURE sp_ejecutar_segm_mensual(nroDesdInicProceso number, auxfecProceso varchar2, pn_limite number, pc_ubuser varchar2, njobs number);
  
    
end PQ_CR_EJEC_SEGM_MENS_NUEV22;
/

create or replace package body PQ_CR_EJEC_SEGM_MENS_NUEV22 is

  PROCEDURE sp_ejecutar_segm_mensual(nroDesdInicProceso number, auxfecProceso varchar2, pn_limite number, pc_ubuser varchar2, njobs number) IS
  ln_numjob     number(9) := 0;
  fecProceso DATE;
  BEGIN
    fecProceso := TO_DATE(auxfecProceso,'dd/mm/RRRR');
    IF nroDesdInicProceso <= 1 then
       --PASO 1
       BEGIN
         PQ_CR_SEGMENTACION_CLIENT_NUEV.sp_cr_carga_clientes_NS(p_d_fecpro => fecProceso, 
         p_n_limite => pn_limite,
         P_N_JOBS => njobs);   
       EXCEPTION WHEN OTHERS THEN
            NULL;
       END;
                                             
    END IF;     
    --PASO 2
    IF nroDesdInicProceso <= 2 then
          BEGIN
              PQ_CR_SEGM_MENS_MYPE22.sp_job_carga(p_d_fecpro => fecProceso , 
              P_N_JOBS => njobs,
              pc_usr => pc_ubuser);
          EXCEPTION WHEN OTHERS THEN
              NULL;
          END;
          
          BEGIN                                
                SELECT count(*) INTO ln_numjob
                FROM dba_jobs x    
                WHERE upper(x.what) LIKE '%PQ_CR_SEGM_MENS_MYPE22.SP_CARGA_DATA%';          
          EXCEPTION WHEN OTHERS THEN
                ln_numjob := 0;
          END;

          While ln_numjob > 0 loop
            BEGIN
              SELECT count(*)
              INTO ln_numjob
              FROM dba_jobs x     
              WHERE upper(x.what) LIKE '%PQ_CR_SEGM_MENS_MYPE22.SP_CARGA_DATA%';            
            EXCEPTION WHEN OTHERS THEN
                      ln_numjob := 0;
            END;
          End loop;   
              
    END IF; 
    
    IF  nroDesdInicProceso <= 3 THEN
          --PASO 3
          BEGIN
              PQ_CR_SEGMENTACION_CLIENT_NUEV.SP_CR_SEGMENTA_CLIENTES_JOB_NS(p_d_fecpro => fecProceso,
             P_N_JOBS =>  njobs,
              pc_usr => pc_ubuser);
          EXCEPTION WHEN OTHERS THEN
            NULL;
          END;                 
    END IF;          
        
  END;


end PQ_CR_EJEC_SEGM_MENS_NUEV22;
/

