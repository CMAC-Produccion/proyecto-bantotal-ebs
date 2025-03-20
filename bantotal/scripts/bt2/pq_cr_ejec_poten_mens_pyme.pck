create or replace package PQ_CR_EJEC_POTEN_MENS_PYME is

  -- Author  : APACHECOH
  -- Created : 19/12/2022 08:43:10
  -- Purpose : 

  PROCEDURE sp_ejecutar_potn_mensual(nroDesdInicProceso number,
                                     auxfecProceso      varchar2,
                                     njobs              number);

end PQ_CR_EJEC_POTEN_MENS_PYME;
/

create or replace package body PQ_CR_EJEC_POTEN_MENS_PYME is
    
  PROCEDURE sp_ejecutar_potn_mensual(nroDesdInicProceso number,
                                     auxfecProceso      varchar2,
                                     njobs              number) IS
                                     
    -- *****************************************************************
    -- Nombre                     : sp_ejecutar_potn_mensual
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.12.20
    -- Autor de Creación          : APACHECOH
    -- Uso                        : EJECUTA LA POTENCIALIDAD MENSUAL
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : nroDesdInicProceso ( FECHA DE PROCESO )
    --                            : auxfecProceso ( FECHA DE PROCESO )
    --                            : njobs ( NRO DE JOBS )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- *****************************************************************
    ln_numjob  number(9) := 0;
    fecProceso DATE;
  BEGIN
    fecProceso := TO_DATE(auxfecProceso, 'dd/mm/RRRR');
    --PASO 1
    IF nroDesdInicProceso <= 1 then
      BEGIN
        pq_cr_potencial_pyme_new.sp_job_tiempo_potencial(fecProceso,njobs);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE x.what LIKE '%pq_cr_potencial_pyme_new.sp_tiempo_potencial_j%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      While ln_numjob > 0 loop
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE x.what LIKE
                 '%pq_cr_potencial_pyme_new.sp_tiempo_potencial_j%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      End loop;
      
    END IF;
    
    --PASO 2
    IF nroDesdInicProceso <= 2 then
      BEGIN
        pq_cr_potencial_pyme_new.sp_job_volumen_credito(fecProceso,njobs);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE x.what LIKE '%pq_cr_potencial_pyme_new.sp_volumen_credito_j%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      While ln_numjob > 0 loop
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE x.what LIKE
                 '%pq_cr_potencial_pyme_new.sp_volumen_credito_j%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      End loop;
    
    END IF;
  
    --PASO 3
    IF nroDesdInicProceso <= 3 THEN
      BEGIN
        pq_cr_potencial_pyme_new.sp_job_recurrencia_credito(fecProceso,njobs);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE x.what LIKE '%pq_cr_potencial_pyme_new.sp_recurrencia_credito_j%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      While ln_numjob > 0 loop
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE x.what LIKE
                 '%pq_cr_potencial_pyme_new.sp_recurrencia_credito_j%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      End loop;
      
    END IF;
    
    --PASO 4
    IF nroDesdInicProceso <= 4 THEN
      BEGIN
        pq_cr_potencial_pyme_new.sp_job_resultado_credito(fecProceso,njobs);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE x.what LIKE '%pq_cr_potencial_pyme_new.sp_resultado_credito_j%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      While ln_numjob > 0 loop
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE x.what LIKE
                 '%pq_cr_potencial_pyme_new.sp_resultado_credito_j%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      End loop;
      
    END IF;
    
  END;

end PQ_CR_EJEC_POTEN_MENS_PYME;
/

