create or replace package PQ_CR_EJEC_SEGM_MENS_NUEV22_Y is
  -- *****************************************************************
  -- Nombre  : PQ_CR_EJEC_SEGM_MENS_NUEV22_Y
  -- Author  : MHUAMANIA
  -- Created : 10/12/2025 04:20:32 p.m
  -- Purpose : Programa principal de ejecución de SEGMENTACION DE UN CLIENTE
  -- *****************************************************************
  PROCEDURE sp_ejecutar_segm_mensual(nroDesdInicProceso number,
                                     auxfecProceso      date,
                                     pn_limite          number,
                                     pc_ubuser          varchar2,
                                     njobs              number,
                                     P_PAIS_Y           IN NUMBER,
                                     P_TDOC_Y           IN NUMBER,
                                     P_NDOC_Y           IN CHAR,
                                     P_INSTANCIA        IN NUMBER);

end PQ_CR_EJEC_SEGM_MENS_NUEV22_Y;
/
create or replace package body PQ_CR_EJEC_SEGM_MENS_NUEV22_Y is
  -- *****************************************************************
  -- Nombre  : PQ_CR_EJEC_SEGM_MENS_NUEV22_Y  
  -- Author  : MHUAMANIA
  -- Created : 10/12/2025 04:20:32 p.m
  -- Purpose : Programa principal de ejecución de SEGMENTACION DE UN CLIENTE
  -- *****************************************************************
  PROCEDURE sp_ejecutar_segm_mensual(nroDesdInicProceso number,
                                     auxfecProceso      DATE,
                                     pn_limite          number,
                                     pc_ubuser          varchar2,
                                     njobs              number,
                                     P_PAIS_Y           IN NUMBER,
                                     P_TDOC_Y           IN NUMBER,
                                     P_NDOC_Y           IN CHAR,
                                     P_INSTANCIA        IN NUMBER) IS
    ln_numjob  number(9) := 0;
    fecProceso DATE;
    conta      number(2) := 0;
    segmen870  CHAR(30);
    codsegm    number(4);
    v_anio     NUMBER;
    v_mes      NUMBER;
    t_cal      CHAR(1);
    v_hora     CHAR(10);
  
  BEGIN
    fecProceso := TO_DATE(auxfecProceso, 'dd/mm/RRRR');
    v_anio     := to_number(to_char(fecProceso, 'RRRR'));
    v_mes      := to_number(to_char(fecProceso, 'MM'));
    v_hora     := to_char(sysdate(), 'HH24:MI:SS');
    t_cal      := 'P';
    begin
    
      select count(*)
        into conta
        from jaqz870
       where JAQZ870INST = P_INSTANCIA;
    
      if conta > 0 then
        select JAQZ870SEGF
          into segmen870
          from jaqz870
         where JAQZ870INST = P_INSTANCIA;
        begin
          segmen870 := TRIM(segmen870);
          SELECT TP1NRO1
            into codsegm
            FROM FST198
           WHERE Tp1cod = 1
             AND Tp1cod1 = 10823
             AND Tp1corr1 = 2
             AND Tp1corr2 = 13
             AND TP1DESC = segmen870;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        end;
        begin
          delete from aqpd784 A
           where AQPD784pano = v_anio
             and AQPD784pmes = v_mes
             and a.AQPD784nse = 'S'
             and a.AQPD784tse = 'N'
             and a.aqpd784paic = P_PAIS_Y
             and a.aqpd784tdoc = P_TDOC_Y
             and a.AQPD784tndoc = P_NDOC_Y;
          commit;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        end;
      
        BEGIN
          insert into aqpd784
            (AQPD784PANO,
             AQPD784PMES,
             AQPD784PAIC,
             AQPD784TDOC,
             AQPD784TNDOC,
             AQPD784CALF,
             AQPD784FECP,
             AQPD784HORP,
             AQPD784TCAL,
             AQPD784nse,
             AQPD784TSE)
          values
            (v_anio,
             v_mes,
             P_PAIS_Y,
             P_TDOC_Y,
             P_NDOC_Y,
             codsegm,
             fecProceso,
             v_hora,
             t_cal,
             'S',
             'N');
          commit;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
       return;
      end if;
     
    end;
  
    IF nroDesdInicProceso <= 1 then
      --PASO 1
      BEGIN
        PQ_CR_SEGMENTACION_CLIENT_NUEV_Y.sp_cr_carga_clientes_NS(P_D_FECPRO => fecProceso,
                                                                 P_N_LIMITE => pn_limite,
                                                                 P_N_JOBS   => njobs,
                                                                 P_Y_PAIS   => P_PAIS_Y,
                                                                 P_Y_TDOC   => P_TDOC_Y,
                                                                 P_Y_NDOC   => P_NDOC_Y);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    END IF;
    --PASO 2
    IF nroDesdInicProceso <= 2 then
      BEGIN
        PQ_CR_SEGM_MENS_MYPE22_Y.sp_job_carga(p_d_fecpro => fecProceso,
                                              P_N_JOBS   => njobs,
                                              pc_usr     => pc_ubuser,
                                              P_N_DOC    => P_NDOC_Y);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    END IF;
  
    IF nroDesdInicProceso <= 3 THEN
      --PASO 3
      BEGIN
        PQ_CR_SEGMENTACION_CLIENT_NUEV_Y.SP_CR_SEGMENTA_CLIENTES_JOB_NS(p_d_fecpro => fecProceso,
                                                                        P_N_JOBS   => njobs,
                                                                        pc_usr     => pc_ubuser,
                                                                        pc_ndoc    => P_NDOC_Y);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END;

end PQ_CR_EJEC_SEGM_MENS_NUEV22_Y;
/
