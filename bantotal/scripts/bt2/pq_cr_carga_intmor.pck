create or replace package pq_cr_carga_intmor is

  -- Author  : HSUAREZ
  -- Created : 5/06/2021 21:17:32
  -- Purpose : Paquete para el proceso de cargar de interes moratorio en creditos penalidad
  
  -- Public type declarations
  ------------------------------------------------------------------------------------------
  -- 
  ------------------------------------------------------------------------------------------
  procedure sp_jobs_carga(ve_feccarg in date,ve_user in varchar2);  
  ------------------------------------------------------------------------------------------
  procedure sp_cr_actualizar_mora(ve_zona in number, ve_feccarg in date);
  ------------------------------------------------------------------------------------------
  PROCEDURE SP_CR_VAL_CRD_X054021(
                                ve_emp in number,
                                ve_mod in number,
                                ve_suc in number,
                                ve_mda in number,
                                ve_pap in number,
                                ve_cta in number,
                                ve_ope in number,
                                ve_sbo in number,
                                ve_top in number,
                                vo_rpta out varchar, -- devuelve S en caso se haya actualizado de Penalidad (P) a Mora(I),
                                vo_tipo_tasa out x054021.xllotexto%type,
                                vo_fecha_car out x054021.xllotxtfch%type                                
                                );
  ------------------------------------------------------------------------------------------
  PROCEDURE SP_CR_SLOGS_X054021(
                               ve_emp in number,
                               ve_mod in number,
                               ve_suc in number,
                               ve_mda in number,
                               ve_pap in number,
                               ve_cta in number,
                               ve_ope in number,
                               ve_sbo in number,
                               ve_top in number,
                               ve_ttsa in varchar,
                               ve_fecc in date
                             );
  ------------------------------------------------------------------------------------------
  Function fn_cr_verifica_tarea_JOBS(P_C_NOMJOB IN VARCHAR2,
                                   P_C_HOSTNA IN VARCHAR2,
                                   pn_paquete in varchar2,
                                   pn_proceso in varchar2,
                                   pn_usuario in varchar2) return number;
  -------------------------------------------------------------------------------------------                                   
end pq_cr_carga_intmor;
/

create or replace package body pq_cr_carga_intmor is

procedure sp_jobs_carga(ve_feccarg in date,ve_user in varchar2) is 

    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecini   char(10);
    lc_fecfin   char(10);
    lc_hostname varchar2(64);
    vi_numjob   number(5);
    lc_prefjob  VARCHAR(10);
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    lc_pac_nombre varchar2(100);
    lc_nomusr     varchar2(50);
    cursor zona is
      select regcod, regnom from fst810 where regcod < 100;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
   
    --lc_fecini := to_char(fecini, 'RRRR.MM.DD');
    lc_fecfin := to_char(ve_feccarg, 'RRRR.MM.DD');
    lc_prefjob    := 'CAR_PETM';
    lc_paquete    := 'pq_cr_carga_intmor';
    lc_proceso    := 'sp_cr_actualizar_mora';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
    --antes de la carga eliminar DATA
    --delete from AQPB567;
    --commit;
  
    ---carga diaria
    for i in zona loop
      ln_ini      := i.regcod;
      lc_variable := 'begin ' || lc_pac_nombre || '(' ||
                     --'  pq_cr_carga_intmor.sp_cr_actualizar_mora(' ||
                     ln_ini || ',TO_DATE(''' || lc_fecfin ||
                     ''',''RRRR.MM.DD''));' || ' End;';
      ln_job      := ln_job + 1;
    
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        --2019.07.22 cambio
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      
      
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        --('CARUNI', ln_ini, lc_variable);
        (lc_prefjob, ln_ini, lc_variable);
      COMMIT;
    
    end loop;
     -- validar si existen jobs.
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
         
     SELECT count(*)
        INTO vi_numjob
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
    --recorres mientras existan jobs     
    While vi_numjob > 0 loop
      vi_numjob := pq_cr_carga_intmor.fn_cr_verifica_tarea_JOBS(lc_prefjob,
                                                                lc_hostname,
                                                                lc_paquete,
                                                                lc_proceso,
                                                                ve_user);
    End loop;
end sp_jobs_carga;

procedure sp_cr_actualizar_mora(ve_zona in number, ve_feccarg in date) is
  cursor lista_contable is
  SELECT * FROM AQPB300 A
  WHERE A.AQPB300REG = ve_zona
    AND A.AQPB300FEC = ve_feccarg
    AND A.AQPB300GRUI NOT IN 
    (SELECT F.TP1NRO1
               FROM FST198 F
              WHERE TP1COD = 1
                AND TP1COD1 = 10899
                AND TP1CORR1 = 1500
                AND TP1CORR2 = 1
                AND TP1CORR3 > 0);
  /*
       fst810 t81,fst811 t80
       and t80.pgcod = t81.pgcod
       and t80.regcod = t81.regcod
       and t81.regcod < 100
       and t80.regcod < 100 
       and t81.regcod =  codzon
       and a.aqpb567tsuc = t80.oficod; 
      */
      vi_validar_tipo varchar(1);
      vo_rpta varchar(1);
      vo_ind varchar(1);
      vo_tas number(10,6);
      vo_corr number;
      vo_fvto date;
      vo_tipo_tasa  x054021.xllotexto%type;
      vo_fecha_car  x054021.xllotxtfch%type;
BEGIN
     BEGIN
       NULL;
       FOR j in lista_contable LOOP
           -- VALIDAR SI NO SON MEDIANA, GRAN EMPRESA Y/O CORPORATIVA.
           --vi_validar_tipo := 'N';
           /*BEGIN
             SELECT 'S'
               INTO vi_validar_tipo 
               FROM FST198
              WHERE TP1COD = 1
                AND TP1COD1 = 10899
                AND TP1CORR1 = 1500
                AND TP1CORR2 = 1
                AND TP1CORR3 = j.aqpb300grui;
             END;*/
           --IF vi_validar_tipo= 'N' THEN             
               -- INVOCAR PROCESO PARA VALIDAR EN LA X054021
               vo_rpta := 'N';
               PQ_CR_CARGA_INTMOR.SP_CR_VAL_CRD_X054021(
                                                          j.aqpb300cod ,
                                                          j.aqpb300mod ,
                                                          j.aqpb300suc ,
                                                          j.aqpb300mda ,
                                                          j.aqpb300pap ,
                                                          j.aqpb300cta ,
                                                          j.aqpb300ope ,
                                                          j.aqpb300sbop ,
                                                          j.aqpb300tope ,
                                                          vo_rpta,
                                                          vo_tipo_tasa,
                                                          vo_fecha_car      
                                                        );
               -- INVOCAR PROCESO PARA INSERTAR DATA EN LA TABLA FSD012 EN CASOS SE CUMPLAN TODAS LA CONDICIONS.
               vo_ind :='N';
               IF vo_rpta = 'S' THEN
                  begin
                    
                    pq_cr_tasa_moratoria.sp_cr_actualiza_tasa(ve_cta => j.aqpb300cta,
                                                              ve_ope => j.aqpb300ope,
                                                              ve_emp => j.aqpb300cod,
                                                              ve_mod => j.aqpb300mod,
                                                              ve_suc => j.aqpb300suc ,
                                                              ve_mda => j.aqpb300mda,
                                                              ve_pap => j.aqpb300pap,
                                                              ve_sbo => j.aqpb300sbop,
                                                              ve_top => j.aqpb300tope,
                                                              vo_ind => vo_ind,
                                                              vo_tas => vo_tas,
                                                              vo_corr => vo_corr,
                                                              vo_fvto => vo_fvto);
                  end;
                 
               -- ACTUALIZAR ESTADO DE LA TABLA EN CASO DE HABER CUMPLIDO TODAS LAS CONDICIONES. 
               IF vo_ind = 'S' THEN
                   BEGIN
                     UPDATE AQPB300 A
                     SET A.AQPB300EST   = vo_ind,
                         A.AQPB300TASAI = vo_tas,
                         A.AQPB300CORRI = vo_corr,
                         A.AQPB300FVTOI = vo_fvto
                     WHERE A.AQPB300COD = J.AQPB300COD 
                       AND A.AQPB300SUC = J.AQPB300SUC 
                       AND A.AQPB300MOD = J.AQPB300MOD 
                       AND A.AQPB300MDA = J.AQPB300MDA 
                       AND A.AQPB300PAP = J.AQPB300PAP 
                       AND A.AQPB300CTA = J.AQPB300CTA 
                       AND A.AQPB300OPE = J.AQPB300OPE 
                       AND A.AQPB300SBOP= J.AQPB300SBOP
                       AND A.AQPB300TOPE= J.AQPB300TOPE
                       AND A.AQPB300FEC = J.AQPB300FEC;
                    ------------------------------------- 
                    -- SI EL PROCESO QUE ACTUALIZA LA FSD012 ES CONFORME (S) ENTONCES 
                    --ACTUALIZA LOGS DE CAMPO ANTES DE APLICAR EL UPDATE.   
                    PQ_CR_CARGA_INTMOR.SP_CR_SLOGS_X054021(
                                                 J.AQPB300COD,
                                                 J.AQPB300MOD,
                                                 J.AQPB300SUC,
                                                 J.AQPB300MDA,
                                                 J.AQPB300PAP,
                                                 J.AQPB300CTA,
                                                 J.AQPB300OPE,
                                                 J.AQPB300SBOP,
                                                 J.AQPB300TOPE,
                                                 vo_tipo_tasa,
                                                 vo_fecha_car
                                               );  
                    -------------------------------------
                    -- ACTUALIZA LA X054021
                    -------------------------------------                             
                    UPDATE X054021 x SET x.xllotexto='I' 
                     WHERE x.pgcod     = J.AQPB300COD
                       AND x.xlloaomod = J.AQPB300MOD
                       AND x.xlloaosuc = J.AQPB300SUC
                       AND x.xlloaomda = J.AQPB300MDA 
                       AND x.xlloaopap = J.AQPB300PAP
                       AND x.xlloaocta = J.AQPB300CTA
                       AND x.xlloaooper= J.AQPB300OPE
                       AND x.xlloaosbop= J.AQPB300SBOP
                       AND x.xlloaotope= J.AQPB300TOPE
                       AND x.xllotxtcod= 250
                       AND x.xllotexto= 'P';   
                       COMMIT;
                                                
                   EXCEPTION 
                     WHEN OTHERS THEN 
                       NULL;  
                   END;
               END IF;    
           END IF;    
           --END IF;    
       END LOOP;    
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;      
END sp_cr_actualizar_mora;
PROCEDURE SP_CR_VAL_CRD_X054021(
                                ve_emp in number,
                                ve_mod in number,
                                ve_suc in number,
                                ve_mda in number,
                                ve_pap in number,
                                ve_cta in number,
                                ve_ope in number,
                                ve_sbo in number,
                                ve_top in number,
                                vo_rpta out varchar, -- devuelve S en caso se haya actualizado de Penalidad (P) a Mora(I),
                                vo_tipo_tasa out x054021.xllotexto%type,
                                vo_fecha_car out x054021.xllotxtfch%type                                
                                ) IS
vi_tipo_tasa x054021.xllotexto%type;
vi_fecha_car x054021.xllotxtfch%type;                                
BEGIN
     vi_tipo_tasa := 'Z';
     BEGIN
         SELECT x.xllotexto,x.xllotxtfch
         INTO vi_tipo_tasa, vi_fecha_car
         FROM x054021 x
         WHERE x.pgcod     = ve_emp
           AND x.xlloaomod = ve_mod
           AND x.xlloaosuc = ve_suc
           AND x.xlloaomda = ve_mda
           AND x.xlloaopap = ve_pap
           AND x.xlloaocta = ve_cta
           AND x.xlloaooper= ve_ope
           AND x.xlloaosbop= ve_sbo
           AND x.xlloaotope= ve_top
           AND x.xllotxtcod = 250;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           NULL;
      WHEN TOO_MANY_ROWS THEN
           NULL;
      WHEN OTHERS THEN
           NULL;   
    END;
    vo_rpta:='N';
    IF vi_tipo_tasa = 'P' THEN
       
       BEGIN
         vo_rpta := 'S';
         vo_tipo_tasa := vi_tipo_tasa;
         vo_fecha_car := vi_fecha_car;
         ------------------------------------------------
         /*
         PQ_CR_CARGA_INTMOR.SP_CR_SLOGS_X054021(
                                                 ve_emp,
                                                 ve_mod,
                                                 ve_suc,
                                                 ve_mda,
                                                 ve_pap,
                                                 ve_cta,
                                                 ve_ope,
                                                 ve_sbo,
                                                 ve_top,
                                                 vi_tipo_tasa,
                                                 vi_fecha_car
                                               );
         */                                      
         -------------------------------------------------                                      
         /*
         UPDATE X054021 x SET x.xllotexto='I' 
         WHERE x.pgcod     = ve_emp
           AND x.xlloaomod = ve_mod
           AND x.xlloaosuc = ve_suc
           AND x.xlloaomda = ve_mda
           AND x.xlloaopap = ve_pap
           AND x.xlloaocta = ve_cta
           AND x.xlloaooper= ve_ope
           AND x.xlloaosbop= ve_sbo
           AND x.xlloaotope= ve_top
           AND x.xllotxtcod= 250
           AND x.xllotexto= 'P';
         */  
         -----------------------------------
         -- COMMIT;
         ----------------------------------- 
         END;
    END IF;
    IF vi_tipo_tasa = 'Z' THEN
       BEGIN
         vo_rpta := 'N'; 
         END;
    END IF;
    IF vi_tipo_tasa = 'I' THEN
       BEGIN
         vo_rpta := 'E';
         PQ_CR_CARGA_INTMOR.SP_CR_SLOGS_X054021(
                                                 ve_emp,
                                                 ve_mod,
                                                 ve_suc,
                                                 ve_mda,
                                                 ve_pap,
                                                 ve_cta,
                                                 ve_ope,
                                                 ve_sbo,
                                                 ve_top,
                                                 vi_tipo_tasa,
                                                 vi_fecha_car
                                               );
         END;
    END IF;         
    -----      
END SP_CR_VAL_CRD_X054021;
PROCEDURE SP_CR_SLOGS_X054021(
                               ve_emp in number,
                               ve_mod in number,
                               ve_suc in number,
                               ve_mda in number,
                               ve_pap in number,
                               ve_cta in number,
                               ve_ope in number,
                               ve_sbo in number,
                               ve_top in number,
                               ve_ttsa in varchar,
                               ve_fecc in date
                             ) IS
vi_esql_cod number(10);
vi_esql_msg varchar(250);
vi_txtcodigo number(3);
BEGIN
     BEGIN
       /*
       SELECT X.XLLOTXTFCH
       FROM X054021 X
       WHERE X.PGCOD     = ve_emp
             X.XLLOAOMOD = ve_mod
             X.XLLOAOSUC = ve_suc
             X.XLLOAOMDA = ve_mda
             X.XLLOAOPAP = ve_pap
             X.XLLOAOCTA = ve_cta
             X.XLLOAOOPER= ve_ope
             X.XLLOAOSBOP= ve_sbo
             X.XLLOAOTOPE= ve_top
             X.XLLOTXTCOD= 250
             X.XLLOTEXTO = RPAD(ve_ttsa,60,' ')
        */
        vi_esql_cod := 0;
        vi_esql_msg := '';
        vi_txtcodigo:= 250;
        INSERT INTO AQPB580 A(AQPB580FECCA,
                              AQPB580HORA,
                              AQPB580PGC, 
                              AQPB580MOD, 
                              AQPB580SUC, 
                              AQPB580MDA, 
                              AQPB580PAP, 
                              AQPB580CTA, 
                              AQPB580OPE, 
                              AQPB580SBO, 
                              AQPB580TOP, 
                              AQPB580TXTCOD,
                              AQPB580TEXTO, 
                              AQPB580FCH, 
                              AQPB580SQLC,  
                              AQPB580SQLE                    
                            ) 
                            VALUES(
                            TRUNC(SYSDATE),
                            to_char(SYSDATE, 'HH24:MI:SS'),
                            ve_emp , 
                            ve_mod ,
                            ve_suc ,
                            ve_mda ,
                            ve_pap ,
                            ve_cta ,
                            ve_ope ,
                            ve_sbo ,
                            ve_top ,
                            vi_txtcodigo,
                            ve_ttsa,
                            ve_fecc,  
                            vi_esql_cod, 
                            vi_esql_msg
                            );       
     EXCEPTION
       WHEN OTHERS THEN
         vi_esql_cod:= SUBSTR(SQLERRM,0,250);
         vi_esql_msg:= SQLCODE;
         BEGIN
         INSERT INTO AQPB580 A(AQPB580FECCA,
                              AQPB580HORA,
                              AQPB580PGC, 
                              AQPB580MOD, 
                              AQPB580SUC, 
                              AQPB580MDA, 
                              AQPB580PAP, 
                              AQPB580CTA, 
                              AQPB580OPE, 
                              AQPB580SBO, 
                              AQPB580TOP,  
                              AQPB580SQLC,  
                              AQPB580SQLE                    
                            ) 
                            VALUES(
                            TRUNC(SYSDATE),
                            to_char(SYSDATE, 'HH24:MI:SS'),
                            ve_emp , 
                            ve_mod ,
                            ve_suc ,
                            ve_mda ,
                            ve_pap ,
                            ve_cta ,
                            ve_ope ,
                            ve_sbo ,
                            ve_top , 
                            vi_esql_cod, 
                            vi_esql_msg
                            );  
         EXCEPTION
           WHEN OTHERS THEN
             NULL;  
           END;
     END;
END;
Function fn_cr_verifica_tarea_JOBS(P_C_NOMJOB IN VARCHAR2,
                                   P_C_HOSTNA IN VARCHAR2,
                                   pn_paquete in varchar2,
                                   pn_proceso in varchar2,
                                   pn_usuario in varchar2) return number is    
    ln_numjob     number(9) := 0;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;
  
    begin
      /*
      SELECT COUNT(1)
        INTO ln_numjob
        FROM dba_scheduler_jobs job
       WHERE owner = lc_nomusr
         AND job.job_name LIKE P_C_NOMJOB || '%';
       */
    
      lc_pac_nombre := trim(pn_paquete) || '.' || trim(pn_proceso);
    
      SELECT count(*)
        INTO ln_numjob
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
        -- AND x.what LIKE '%' || trim(pn_usuario) || '%';
    
    end;
  
    return ln_numjob;
  end fn_cr_verifica_tarea_JOBS;
end pq_cr_carga_intmor;
/

