create or replace package PQ_CR_EJEC_SEGM_CONS_NUEV is

  -- Author  : IGS_RCASTRO
  -- Created : 24/10/2022 14:19:06
  -- Purpose : Programa principal de ejecuci?n de Segmentaci?n Mensual MYPE 2022

  PROCEDURE sp_ejecutar_segm_mens_cons(nroDesdInicProceso number,
                                       auxfecProceso      varchar2,
                                       pn_limite          number,
                                       pc_ubuser          varchar2,
                                       njobs              number);

end PQ_CR_EJEC_SEGM_CONS_NUEV;
/

create or replace package body PQ_CR_EJEC_SEGM_CONS_NUEV is

  PROCEDURE sp_ejecutar_segm_mens_cons(nroDesdInicProceso number,
                                       auxfecProceso      varchar2,
                                       pn_limite          number,
                                       pc_ubuser          varchar2,
                                       njobs              number) IS
    ln_numjob  number(9) := 0;
    fecProceso DATE;
  BEGIN
    fecProceso := TO_DATE(auxfecProceso, 'dd/mm/RRRR');
  
    --PASO 1
    IF nroDesdInicProceso <= 1 then
      BEGIN
        PQ_CR_SEGMENTACION_MENS_CONS.sp_cr_carga_clientes_ns(p_d_fecpro => fecProceso,
                                                             p_n_limite => pn_limite,
                                                             p_n_jobs   => njobs);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    --PASO 2
    IF nroDesdInicProceso <= 2 then
      BEGIN
        PQ_CR_SEGMENTACION_MENS_CONS.sp_job_carga(p_d_fecpro => fecProceso,
                                                  pc_usr     => pc_ubuser,
                                                  p_n_jobs   => njobs);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE
               UPPER('%pq_Cr_segmentacion_mens_cons.SP_CARGA_DATA%');
      
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      While ln_numjob > 0 loop
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 UPPER('%pq_Cr_segmentacion_mens_cons.SP_CARGA_DATA%');
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      End loop;
    
    END IF;
  
    --PASO 3
    IF nroDesdInicProceso <= 3 THEN
      BEGIN
        PQ_CR_SEGMENTACION_MENS_CONS.sp_cr_segmenta_clientes_job_ns(p_d_fecpro => fecProceso,
                                                                    pc_usr     => pc_ubuser,
                                                                    p_n_jobs   => njobs);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END;

end PQ_CR_EJEC_SEGM_CONS_NUEV;
/

