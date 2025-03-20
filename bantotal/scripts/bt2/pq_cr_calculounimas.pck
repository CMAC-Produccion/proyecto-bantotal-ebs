create or replace package "PQ_CR_CALCULOUNIMAS" is
/*
  *-- Author  : HSUAREZ
  *-- Created : 8/04/2021 14:33:38
  *-- Modificado: Bhernard S. Beisaga
  *-- Purpose : Paqute para el calculo de devengados en créditos reprogramados
  *-- Modificado: Modelo para carga masica
      Se ha adicionado sp_jobs_cargaini_nor para ejecucion por schedules
      Se ha adiconado sp_jobs_cargaini_bulk para ejecuciones por Bulk (DATA MASIVA)
      Se ha adicionado SP_CR_CARGAINI_BULK carga de FSH016 po bulk
      Se ha adicionado SP_CR_CARGAINI_NOR carga de FSH016 po schedules
      Se ha adicionado SP_CR_INSERT_REPROGRAMADOS para lsita de reprogramados
      Se ha adicionado SP_CR_INSERT_REPOFINAL entregable
  *
  */


 procedure sp_jobs_cargaini_nor(ve_fecini in varchar,ve_fecfin in varchar);

 PROCEDURE SP_CR_CARGAINI_BULK(ve_fchcorte in date, vs_filasafectadas out number);

 PROCEDURE SP_CR_CARGAINI_NOR(ve_codregion in number, ve_fchini in date, ve_fchcorte in date);

 PROCEDURE SP_CR_INSERT_REPROGRAMADOS(ve_fchini in date, ve_fchcorte in date,vs_filasafectadas out number);

 procedure sp_jobs_carga_devengado (ve_fecini in date, ve_fecfin in date);

 procedure sp_cr_inserta_devengado(codzon in number,fecini in date,fecfin in date);

 PROCEDURE SP_CR_PRIMER_ENTREGABLE (ve_fchini in date, ve_fchcorte in date, vs_filasafectadas out number);

 PROCEDURE SP_CR_SEGUNDO_ENTREGABLE (ve_fchini in date, ve_fchcorte in date, vs_filasafectadas out number);

 Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2, P_C_HOSTNA IN VARCHAR2) return number;


end PQ_CR_CALCULOUNIMAS;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_CR_CALCULOUNIMAS" is

--1

procedure sp_jobs_cargaini_nor(ve_fecini in varchar,ve_fecfin in varchar) is

    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecini   date;
    lc_fecfin   date;
    lc_hostname varchar2(64);

    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_rpta       number:=0;
    vi_contab number;
--    n_inst number;

    cursor zona is
      select regcod, regnom from fst810 where regcod < 100;

  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
      null;
    end;

    lc_fecini := to_date(ve_fecini, 'dd/mm/yyyy');
    lc_fecfin := to_date(ve_fecfin, 'dd/mm/yyyy');


    --antes de la carga eliminar DATA
   /*verifica si hay contabilizacion
   SELECT count(*) INTO vi_contab FROM AQPB758H WHERE AQPB758HCONT = 'S' AND AQPB758HFCAR >= lc_fecfin ;
   IF vi_contab > 0 THEN
      dbms_output.put_line ('Existen contabilizaciones pendientes de extornar');
     RETURN;
   END IF;*/

    delete from AQPB755 where hfvco >= lc_fecini;
    dbms_output.put_line ('FILAS BORRADAS AQPB755: ' || SQL%ROWCOUNT);
    commit;

--    dbms_output.put_line ('fer: ' || localtimestamp);
    ---carga diaria
    for i in zona loop
      ln_ini      := i.regcod;
      lc_prefjob    := 'AQPB755M';
      pi_vc2_nomjob := lc_prefjob || to_char(lc_fecfin, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job

      lc_variable := 'BEGIN ' ||
                     '  PQ_CR_CALCULOUNIMAS.SP_CR_CARGAINI_NOR(' ||
                     ln_ini || ',''' || lc_fecini ||
                     ''',''' || lc_fecfin || '''); END;';
      ln_job      := ln_job + 1;

     --dbms_output.put_line ('QRY: ' || to_char(lc_variable));
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
--     select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;
  --   if n_inst in (1,2) then
  /*******SCHEDULES PARA FUERA DE LA CADENA DE CIERRE, DONDE SE EJECUTAN PROCESONS EN PARALELO******/
     IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Carga_masivanor_fsh016');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Carga_masivanor_fsh016');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        end;
      End If;
      commit;
--     dbms_output.put_line ('RESPUESTA: ' || to_char(lc_rpta));
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('AQPB755M', ln_ini, lc_variable);
      COMMIT;
    end loop;

    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);

    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;

    dbms_output.put_line ('>>>>CARGA MASIVA TERMINADA: ' || localtimestamp);
    PQ_CR_CALCULOUNIMAS.SP_CR_INSERT_REPROGRAMADOS (lc_fecini,lc_fecfin,vs_filasafectadas => lc_rpta );
    dbms_output.put_line ('>>>>INSERT REPROGRAMADOS TERMINADO: ' || localtimestamp);
    If lc_rpta > 0 then
       PQ_CR_CALCULOUNIMAS.sp_jobs_carga_devengado (lc_fecini, lc_fecfin);
       dbms_output.put_line ('>>>>INSERT DEVENGADOS TERMINADO: ' || localtimestamp);
       PQ_CR_CALCULOUNIMAS.SP_CR_PRIMER_ENTREGABLE (lc_fecini, lc_fecfin, vs_filasafectadas =>lc_rpta);
       dbms_output.put_line ('>>>>INSERT PRIMER ENTGREGABLE: ' || localtimestamp);
       If lc_rpta > 0 then
          PQ_CR_CALCULOUNIMAS.SP_CR_SEGUNDO_ENTREGABLE (lc_fecini, lc_fecfin, vs_filasafectadas =>lc_rpta);
          dbms_output.put_line ('>>>>INSERT SEGUNDO ENTGREGABLE: ' || localtimestamp);
          If lc_rpta > 0 then
             DBMS_OUTPUT.put_line ('Se ha procesado TODO satisfactoriamente');
          else
             DBMS_OUTPUT.put_line ('Falla en el proceso');
          end if;
        else
            DBMS_OUTPUT.put_line ('Falla en SP_CR_PRIMER_ENTREGABLE');
        end if;
     end if;
  END;


PROCEDURE SP_CR_CARGAINI_NOR(ve_codregion in number, ve_fchini in date, ve_fchcorte in date) IS
    err_code    NUMBER;
    err_msg   VARCHAR2(1500);
  BEGIN
    BEGIN
      INSERT INTO AQPB755
      SELECT  /*+ all_rows */  F.PGCOD, F.HCMOD, F.HSUCOR, F.HTRAN,
                            F.HNREL, F.HFCON, F.HCORD, F.HCSUBO,
                            F.HRUBRO, F.HMDA,  F.HPAP,  F.HCTA,
                            F.HOPER, F.HCIMP1, F.HFVCO, F.HCODMO,
                            (CASE WHEN F.HCODMO=2 THEN (F.HCIMP1)*-1 WHEN F.HCODMO=1 THEN (F.HCIMP1) END) IMPORTED,--0=Sdo.Anterior 1=Debe 2=Haber
                             ve_fchcorte AS FCARGA
                     FROM FSH016 F,FSH015 H5, FST811 S
                     WHERE F.pgcod = H5.PGCOD AND
                     F.hcmod = H5.HCMOD AND
                     F.hsucor= H5.hsucor AND
                     F.htran = H5.HTRAN AND
                     F.HNREL = H5.hnrel AND
                     F.hfcon = H5.hfcon AND
                     F.PGCOD  = S.PGCOD AND
                     F.HSUCUR = S.OFICOD AND
                     S.REGCOD = ve_codregion AND
                     (F.hfvco BETWEEN ve_fchini AND ve_fchcorte) AND
                     SUBSTR(F.HRUBRO, 1, 4) IN('1418','1428') AND
                     H5.hccorr = 0; --EXTORNO QUE NO SE */
          commit;
                DBMS_OUTPUT.put_line('Ok');
                EXCEPTION
                  when others then
                     err_code := SQLCODE;
                     err_msg := SUBSTR(SQLERRM, 1, 500);
                     DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg );
                rollback;
    END;

  END;

PROCEDURE SP_CR_CARGAINI_BULK(ve_fchcorte in date, vs_filasafectadas out number) IS
  /* CARGA MASIVA DE HISTORICO POST CADENA DE CIERRE (EJECUTAR TODOS LOS DIAS CON LA FECHA DEL DIA ANTERIOR) 
  * ING. BHERNARD BEISAGA ARENAS
  * V.1.0.
  */
    err_code    NUMBER;
    err_msg   VARCHAR2(1500);
  

  TYPE rec_fsh016 IS RECORD ( PGCOD fsh016.pgcod%type, HCMOD fsh016.hcmod%type, HSUCOR fsh016.hsucor%type, HTRAN fsh016.htran%type,
                             HNREL fsh016.hnrel%type, HFCON fsh016.hfcon%type, HCORD fsh016.hcord%type,   HCSUBO fsh016.hcsubo%type,
                             HRUBRO fsh016.hrubro%type, HMDA fsh016.hmda%type,HPAP fsh016.hpap%type,    HCTA fsh016.hcta%type,
                             HOPER fsh016.hoper%type, HCIMP1 fsh016.hcimp1%type, HFVCO fsh016.hfvco%type, HCODMO fsh016.hcodmo%type,
                             IMPORTED fsh016.hcimp1%type, FCARGA date);

  TYPE dat_fsh016 IS TABLE OF rec_fsh016;
  tabla_dat_fsh016 dat_fsh016; 

  CURSOR c_fsh016 IS  SELECT  /*+ all_rows */  F.PGCOD, F.HCMOD, F.HSUCOR, F.HTRAN,
                      F.HNREL, F.HFCON, F.HCORD, F.HCSUBO,
                      F.HRUBRO, F.HMDA,  F.HPAP,  F.HCTA,
                      F.HOPER, F.HCIMP1, F.HFVCO, F.HCODMO,
                      CASE WHEN F.HCODMO=2 THEN (F.HCIMP1)*-1 WHEN F.HCODMO=1 THEN (F.HCIMP1) END IMPORTED,--0=Sdo.Anterior 1=Debe 2=Haber
                      ve_fchcorte AS FCARGA
                     FROM FSH016 F,FSH015 H5
                     WHERE F.pgcod = H5.PGCOD AND
                     F.hcmod = H5.HCMOD AND
                     F.hsucor= H5.hsucor AND
                     F.htran = H5.HTRAN AND
                     F.HNREL = H5.hnrel AND
                     F.hfcon = H5.hfcon AND
                     F.hfvco >= (ve_fchcorte - 1) AND
                     SUBSTR(F.HRUBRO, 1, 4) IN('1418','1428') AND
                     H5.hccorr = 0; --EXTORNO QUE NO SE */
  BEGIN
    BEGIN 
      delete from AQPB755 where hfvco >= (ve_fchcorte - 1);
      dbms_output.put_line ('FILAS BORRADAS AQPB755: ' || SQL%ROWCOUNT);
      commit;
    END;    
    BEGIN
      OPEN c_fsh016;
      FETCH c_fsh016 BULK COLLECT INTO tabla_dat_fsh016;
            DBMS_OUTPUT.put_line ('Registros en array: '||TO_CHAR(tabla_dat_fsh016.COUNT));
      CLOSE c_fsh016;

--      FORALL IDX IN tabla_dat_fsh016.FIRST .. tabla_dat_fsh016.LAST -- FOR ALL CON LIMITE INFERIOR Y SUPERIOR
        FORALL IDX IN INDICES OF tabla_dat_fsh016 SAVE EXCEPTIONS
             INSERT INTO AQPB755
                    VALUES tabla_dat_fsh016(IDX);
              vs_filasafectadas:= SQL%ROWCOUNT;
              DBMS_OUTPUT.put_line('Filas insertadas AQPB755: ' || SQL%ROWCOUNT);
              commit;
        EXCEPTION
               WHEN OTHERS THEN                 
               err_code := SQLCODE;
               err_msg := SUBSTR(SQLERRM, 1, 500);
               DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg );                              
               DBMS_OUTPUT.put_line ('Exceptiones BULK: '||TO_CHAR(SQL%BULK_EXCEPTIONS.COUNT));
                FOR id IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
                  LOOP
                     DBMS_OUTPUT.put_line('Error'
                                            || id
                                            || ' en el indice'
                                            || SQL%BULK_EXCEPTIONS(id).ERROR_INDEX
                                            || ' cuando se insertaba ');
                      DBMS_OUTPUT.put_line('Error Oracle ' || SQLERRM(-1 * SQL%BULK_EXCEPTIONS(id).ERROR_CODE));
                  END LOOP;
              vs_filasafectadas:= 0;
              DBMS_OUTPUT.put_line('Error 0 Filas insertadas');
              rollback;
    END;
  END;


    PROCEDURE SP_CR_INSERT_REPROGRAMADOS(ve_fchini         in date,
                                                ve_fchcorte       in date,
                                                vs_filasafectadas out number) IS
    /*******************************************************************************
    * Autor: BBEISAGA
    * Fecha: 13-08-2021
    * Objetivo: Carga maswiva de historicos y reprogramados AQPB567t
    * tambien se crea una tabla backup de AQPB567t_DDMMYYY
    ********************************************************************************/
    err_code            NUMBER;
    err_msg             VARCHAR2(1500);
    VI_EXISTE           NUMBER;
    p_c_coderr          VARCHAR2(1500);
    p_c_deserr          VARCHAR2(1500);
    p_destinatariospara varchar2(30);
    p_destinatarioscc   varchar2(30);
    vi_correos          VARCHAR2(200);
    lc_nomusr           VARCHAR(30);
    VI_FECHA_INI        DATE;
    VI_FECHA_ITER       DATE;
    TYPE record_reprog IS RECORD(
      EMPR NUMBER(3, 0),
      MODL NUMBER(3, 0),
      SUCL NUMBER(3, 0),
      MNDA NUMBER(4, 0),
      PAPL NUMBER(4, 0),
      NCTA NUMBER(9, 0),
      NOPE NUMBER(9, 0),
      NSBO NUMBER(3, 0),
      NTOP NUMBER(3, 0),
      ORGN VARCHAR2(10),
      FCHR DATE,
      FMAX DATE); --FCHR->FECHA REPROGRAMCION
    TYPE table_reprog IS TABLE OF record_reprog;
  
    tabla_data_reprog table_reprog;
  
    cursor email is
      select TP1DESC
        from fst198
       where tp1cod1 = 10899
         and tp1corr1 = 4000
         and TP1CORR2 = 1
         and TP1CORR3 > 0;
  
    CURSOR c_reprog(VIC_FECHA DATE) IS
    --EMPIESO QUERY TODOS LOS REPROGRAMADOS
      WITH TMP_FSH016 AS
       (SELECT /*+ all_rows*/
         F.PGCOD,
         F.HFCON,
         F.HRUBRO,
         F.HMDA,
         F.HPAP,
         F.HCTA,
         F.HOPER,
         F.HCIMP1,
         F.HFVCO
          FROM AQPB755 F
         WHERE --F.hfvco <= ve_fchcorte -- '25/09/2024' 
           /*AND*/ F.HFVCO = VIC_FECHA),
      TMP_LISTA AS
       (SELECT /*+ all_rows*/
         JAQA400EMP AS EMPR,
         JAQA400MOD AS MODL,
         JAQA400SUC AS SUCL,
         JAQA400MDA AS MNDA,
         JAQA400PAP AS PAPL,
         JAQA400CTA AS NCTA,
         JAQA400OPE AS NOPE,
         JAQA400SBO AS NSBO,
         JAQA400TOP AS NTOP,
         JAQA400FEC AS FCHR,
         HFCON      AS FCON,
         ORIGEN     AS ORGN,
         HCIMP1     AS IMP1,
         HRUBRO     AS RBRO,
         NULL       AS FMAX
          FROM (SELECT /*+ all_rows*/
                 J.AQPB836EMP   JAQA400EMP,
                 J.AQPB836MOD   JAQA400MOD,
                 J.AQPB836SUC   JAQA400SUC,
                 J.AQPB836MDA   JAQA400MDA,
                 J.AQPB836PAP   JAQA400PAP,
                 J.AQPB836CTA   JAQA400CTA,
                 J.AQPB836OPER  JAQA400OPE,
                 J.AQPB836SBOP  JAQA400SBO,
                 J.AQPB836TOP   JAQA400TOP,
                 J.AQPB836FEC   JAQA400FEC, -- FECHA DE REPROGRAMACION
                 F.HFCON, --FECHA DE REGISTRO EN FSH016
                 J.AQPB836SBTIP ORIGEN, --'UNILATERAL' ORIGEN,--ORIGEN
                 F.HCIMP1, --MONTO FSH016 RUBRO 14_8
                 F.HRUBRO --RUBRO 14_8
                  FROM TMP_FSH016 F, AQPB836 J
                 WHERE J.AQPB836APLEXT = 'S'
                   AND J.AQPB836FECBI = ve_fchcorte
                   AND J.AQPB836TIP NOT IN
                       ( --@hasl 2023.10.27 - agregando creditos que no se consideran para extorno.
                        SELECT RPAD(TP1DESC, 34, ' ')
                          FROM FST198 F
                         WHERE F.TP1COD = 1
                           AND F.TP1COD1 = 11161
                           AND F.TP1CORR1 = 400
                           AND F.TP1CORR2 = 1
                           AND F.TP1CORR3 > 0)
                   and J.AQPB836FEC < ( --PARA FECHA LIMITE PARA NO INCLUIR EN LOS EXTORNO DE ULTIMA REPROGRAMACIÓN LOS QUE ESTAN DESPUES DE LA FECHA SEGUN GUIA.
                                       SELECT to_date(TRIM(tp1desc), 'RRRRMMDD')
                                         FROM FST198 F
                                        WHERE F.TP1COD = 1
                                          AND F.TP1COD1 = 11161
                                          AND F.TP1CORR1 = 400
                                          AND F.TP1CORR2 = 2
                                          AND F.TP1CORR3 = 1)
                      --Aquellos que tienen en el campo AQPB836TIP = EXCL.OM 19109, independiente que tengan en el campo AQPB836APLEXT = `S¿ .
                   and F.PGCOD = J.AQPB836EMP
                   AND F.HMDA = J.AQPB836MDA
                   AND F.HPAP = J.AQPB836PAP
                   AND F.HCTA = J.AQPB836CTA
                   AND F.HOPER = J.AQPB836OPER
                   AND F.hfvco >= J.AQPB836FEC
                   AND F.hfvco <= ve_fchcorte
                UNION ALL
                SELECT /*+ all_rows*/
                 J.AQPB836EMP   JAQA400EMP,
                 J.AQPB836MOD   JAQA400MOD,
                 J.AQPB836SUC   JAQA400SUC,
                 J.AQPB836MDA   JAQA400MDA,
                 J.AQPB836PAP   JAQA400PAP,
                 J.AQPB836CTA   JAQA400CTA,
                 J.AQPB836OPER  JAQA400OPE,
                 J.AQPB836SBOP  JAQA400SBO,
                 J.AQPB836TOP   JAQA400TOP,
                 J.AQPB836FEC   JAQA400FEC, -- FECHA DE REPROGRAMACION
                 F.HFCON, --FECHA DE REGISTRO EN FSH016
                 J.AQPB836SBTIP ORIGEN, --'UNILATERAL' ORIGEN,--ORIGEN
                 F.HCIMP1, --MONTO FSH016 RUBRO 14_8
                 F.HRUBRO --RUBRO 14_8
                  FROM TMP_FSH016 F, AQPB836 J
                 WHERE J.AQPB836APLEXT = 'S'
                   AND J.AQPB836FECBI = ve_fchcorte
                   AND J.AQPB836TIP NOT IN ( --@hasl 2023.10.27 - agregando creditos que no se consideran para extorno.
                                            SELECT RPAD(TP1DESC, 34, ' ')
                                              FROM FST198 F
                                             WHERE F.TP1COD = 1
                                               AND F.TP1COD1 = 11161
                                               AND F.TP1CORR1 = 400
                                               AND F.TP1CORR2 = 3
                                               AND F.TP1CORR3 > 0
                                            --aqpb836TIP ('CTA. 81_954% y CTA. 81_937%','CTA. 81_954%')
                                            )
                   and J.AQPB836FEC >=
                       ( --PARA FECHA LIMITE PARA NO INCLUIR EN LOS EXTORNO DE ULTIMA REPROGRAMACIÓN LOS QUE ESTAN DESPUES DE LA FECHA SEGUN GUIA.
                        SELECT to_date(TRIM(tp1desc), 'RRRRMMDD')
                          FROM FST198 F
                         WHERE F.TP1COD = 1
                           AND F.TP1COD1 = 11161
                           AND F.TP1CORR1 = 400
                           AND F.TP1CORR2 = 2
                           AND F.TP1CORR3 = 1)
                      --Aquellos que tienen en el campo AQPB836TIP = EXCL.OM 19109, independiente que tengan en el campo AQPB836APLEXT = `S¿ .
                   and F.PGCOD = J.AQPB836EMP
                   AND F.HMDA = J.AQPB836MDA
                   AND F.HPAP = J.AQPB836PAP
                   AND F.HCTA = J.AQPB836CTA
                   AND F.HOPER = J.AQPB836OPER
                   AND F.hfvco >= J.AQPB836FEC
                   AND F.hfvco <= ve_fchcorte                
                ) LISTA)
      
      -- DISTINCT DE LOS CREDITOS, TMP_LISTA                  
      SELECT /*+ all_rows*/
      DISTINCT EMPR,
               MODL,
               SUCL,
               MNDA,
               PAPL,
               NCTA,
               NOPE,
               NSBO,
               NTOP,
               ORGN,
               FCHR, --fecha reprogramacion
               FMAX
        FROM TMP_LISTA A
       WHERE FCHR = (SELECT MIN(FCHR)
                       FROM TMP_LISTA B
                      WHERE B.EMPR = A.EMPR
                        AND B.MODL = A.MODL
                        AND B.SUCL = A.SUCL
                        AND B.MNDA = A.MNDA
                        AND B.PAPL = A.PAPL
                        AND B.NCTA = A.NCTA
                        AND B.NOPE = A.NOPE
                        AND B.NSBO = A.NSBO
                        AND B.NTOP = A.NTOP);
  
    --FIN QUERY TODOS LOS REPROGRAMADOS
  
  BEGIN
    /* INICIALIZANDO VARIABLES */
    BEGIN
      SELECT MIN(AQPB836FEC)
        INTO VI_FECHA_INI
        FROM AQPB836 J
       WHERE J.AQPB836APLEXT = 'S'
         AND J.AQPB836FECBI = ve_fchcorte;
    EXCEPTION
      WHEN OTHERS THEN
        VI_FECHA_INI:=TO_DATE('01/01/2030','DD/MM/YYYY') ;
    END;
    /* FIN */

    --    vs_filasafectadas := 0;
    BEGIN
      -- CONSULTA ADICIONAL PARA SABER SI HAY DATA EN CASO NO SE CARGUE LA DE BI 
      VI_EXISTE := 0;
      BEGIN
        SELECT COUNT(*)
          INTO VI_EXISTE
          FROM AQPB836
         WHERE AQPB836FECBI = to_date(ve_fchcorte, 'DD/MM/RRRR')
           AND AQPB836APLEXT = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          VI_EXISTE := 0;
      END;
    
      IF VI_EXISTE = 0 THEN
        err_code := SQLCODE;
        err_msg  := SUBSTR(SQLERRM, 1, 500);
        err_msg  := 'No existe data cargada en BI, con Fecha ' ||
                    ve_fchcorte;
        DBMS_OUTPUT.put_line(err_msg);
        -----------------envio de correo en caso de error-------------------       
        vi_correos := '';
        FOR X IN EMAIL LOOP
          BEGIN
            vi_correos := vi_correos || trim(X.TP1DESC) || ';';
          END;
        END LOOP;
        vi_correos := SUBSTR(vi_correos, 1, (LENGTH(vi_correos) - 1));
        --       DBMS_OUTPUT.put_line(vi_correos);
        pq_ah_planillas.p_sendmailattach(vi_correos, --p_destinatariospara
                                         '', --p_destinatarioscc
                                         '', --p_destinatariosbcc
                                         err_msg, --mensaje a enviar
                                         'notificacionesbantotal@cajaarequipa.pe', --remitente
                                         'Error insert registro en aqpb755 DEVENGADO DIARIO', --p_asunto
                                         'HTML', --p_asunto
                                         '', --p_directorio
                                         '', --p_archivosadjuntos
                                         p_c_coderr,
                                         p_c_deserr);
      END IF;
    
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpb567t';
      -- DBMS_OUTPUT.put_line('Filas borradas AQPB567T: ' || TO_CHAR(SQL%ROWCOUNT));
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Nose pudo Truncar AQPB567T: ');
    END;
    --RECORREMOS LAS FECHAS SEGUN RANGO
    VI_FECHA_ITER:=VI_FECHA_INI;
    vs_filasafectadas := 0;
    WHILE VI_FECHA_ITER <= ve_fchcorte  LOOP
      --INSERTAMOS LA LISTA DE REPROGMADOS
      BEGIN      
          OPEN c_reprog(VI_FECHA_ITER);
          FETCH c_reprog BULK COLLECT
            INTO tabla_data_reprog;
          CLOSE c_reprog;
          /*FORALL IDX IN INDICES OF tabla_data_reprog
            SAVE EXCEPTIONS INSERT              
              INTO aqpb567t VALUES tabla_data_reprog(IDX);*/        
          FORALL IDX IN INDICES OF tabla_data_reprog
            MERGE INTO aqpb567t tgt
            USING (SELECT * FROM DUAL) src
            ON (tgt.AQPB567TEMP = tabla_data_reprog(idx).EMPR AND tgt.AQPB567MOD = tabla_data_reprog(idx).MODL AND tgt.AQPB567TSUC= tabla_data_reprog(idx).SUCL AND tgt.AQPB567TMDA= tabla_data_reprog(idx).MNDA
            AND tgt.AQPB567TPAP = tabla_data_reprog(idx).PAPL AND tgt.AQPB567TCTA= tabla_data_reprog(idx).NCTA AND tgt.AQPB567TOPE=tabla_data_reprog(idx).NOPE AND tgt.AQPB567TSBO=tabla_data_reprog(idx).NSBO AND tgt.AQPB567TTOP=tabla_data_reprog(idx).NTOP 
            AND tgt.AQPB567TORI = tabla_data_reprog(idx).ORGN AND tgt.AQPB567TFEP=tabla_data_reprog(idx).FCHR) -- Reemplazar con la clave única
            WHEN NOT MATCHED THEN
                INSERT (AQPB567TEMP, AQPB567MOD, AQPB567TSUC, AQPB567TMDA, AQPB567TPAP, AQPB567TCTA, AQPB567TOPE, AQPB567TSBO, AQPB567TTOP, AQPB567TORI, AQPB567TFEP) -- Reemplazar con todas las columnas
                VALUES (tabla_data_reprog(idx).EMPR,tabla_data_reprog(idx).MODL,tabla_data_reprog(idx).SUCL,tabla_data_reprog(idx).MNDA,tabla_data_reprog(idx).PAPL,tabla_data_reprog(idx).NCTA,tabla_data_reprog(idx).NOPE,tabla_data_reprog(idx).NSBO,tabla_data_reprog(idx).NTOP,tabla_data_reprog(idx).ORGN,tabla_data_reprog(idx).FCHR);
          vs_filasafectadas := vs_filasafectadas + SQL%ROWCOUNT;                           
      EXCEPTION
        WHEN OTHERS THEN
          err_code          := SQLCODE;
          err_msg           := SUBSTR(SQLERRM, 1, 500);
          vs_filasafectadas := 0;
          DBMS_OUTPUT.put_line('ERROR1: ' || err_code || '-' || err_msg);
          FOR id IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
            DBMS_OUTPUT.put_line('Error2: ' || id || ' en el indice' || SQL%BULK_EXCEPTIONS(id).ERROR_INDEX ||
                                 ' cuando se insertaba ');
            DBMS_OUTPUT.put_line('Error Oracle ' ||
                                 SQLERRM(-1 * SQL%BULK_EXCEPTIONS(id).ERROR_CODE));
          END LOOP;
                
      END;
      COMMIT;
      VI_FECHA_ITER := VI_FECHA_ITER +1; 
    END LOOP;
    DBMS_OUTPUT.put_line('Filas insertadas AQPB567T:' ||
                               to_char(vs_filasafectadas));          
  EXCEPTION
    WHEN OTHERS THEN
      vs_filasafectadas := 0;
      ROLLBACK;
  END;


------funcion que devuelve una funcion tabla----------------------------

--  type tab_aqpb567 is table of aqpb567%rowtype;
/*FUNCTION FN_CR_DEVENGADO RETURN nt_aqpb567 IS
      aqpb567_data nt_aqpb567;
 BEGIN
  SELECT obj_aqpb567(AQPB567EMP, AQPB567MOD)

  BULK COLLECT INTO aqpb567_data
  FROM AQPB567 WHERE ROWNUM < 5  ;

  RETURN aqpb567_data;

  END;*/
--------------------

Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                 P_C_HOSTNA IN VARCHAR2) return number is

    ln_numjob number(9) := 0;
    lc_nomusr varchar2(50);

  begin

    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then
      null;
    end;

    begin
      SELECT COUNT(1)
        INTO ln_numjob
        FROM dba_scheduler_jobs job
       WHERE owner = lc_nomusr
         AND job.job_name LIKE P_C_NOMJOB || '%';
    exception when others then
      null;
    end;

    return ln_numjob;
  end fn_cr_verifica_tarea;




procedure sp_jobs_carga_devengado (ve_fecini in date, ve_fecfin in date) IS

    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
--    lc_fecini   date;
--    lc_fecfin   date;
    lc_hostname varchar2(64);

    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
--    n_inst number;

    cursor zona is
      select regcod, regnom from fst810 where regcod < 100;

  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
      null;
    end;
    BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpb567';
--       DBMS_OUTPUT.put_line('Filas borradas AQPB567: ' || TO_CHAR(SQL%ROWCOUNT));
      COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Nose pudo Truncar AQPB567 ');
    END;

--    lc_fecini := to_date(ve_fecini, 'dd/mm/yyyy');
--    lc_fecfin := to_date(ve_fecfin, 'dd/mm/yyyy');


    ---carga diaria
    for i in zona loop
      ln_ini      := i.regcod;
      lc_prefjob    := 'AQPB567M';
      pi_vc2_nomjob := lc_prefjob || to_char(ve_fecfin, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job

      lc_variable := 'begin ' ||
                     '  pq_cr_calculounimas.sp_cr_inserta_devengado(' ||
                     ln_ini || ',''' || ve_fecini ||
                     ''',''' || ve_fecfin || ''' ); End;';
      ln_job      := ln_job + 1;
  --   select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;
    -- if n_inst in (1,2) then
     IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Insercion devengado AQPB567');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Insercion devengado AQPB567');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        end;
      End If;
      commit;


      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('AQPB567M', ln_ini, lc_variable);
      COMMIT;

    end loop;

    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);

    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;

   DBMS_OUTPUT.put_line('Se termino JOBS devengado' );

  end;

PROCEDURE SP_CR_PRIMER_ENTREGABLE (ve_fchini in date, ve_fchcorte in date, vs_filasafectadas out number) IS
 err_code    NUMBER;
 err_msg   VARCHAR2(1500);

  BEGIN
    BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE AQPB756';
       DBMS_OUTPUT.put_line('TRUNCADO AQPB756');
      COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
       DBMS_OUTPUT.put_line('Nose pudo Truncar AQPB756 ');
    END;
    BEGIN
        INSERT INTO  AQPB756
          SELECT /*+ all_rows */ aqpb567emp as AQPB756EMP,aqpb567mod as AQPB756MOD,aqpb567suc as AQPB756SUC,aqpb567mda as AQPB756MDA,
            aqpb567pap as AQPB756PAP,aqpb567cta as AQPB756CTA,aqpb567ope as AQPB756OPE,aqpb567sbo as AQPB756SBO,
            aqpb567top as AQPB756TOP,aqpb567ori as AQPB756ORI,aqpb567fep as AQPB756FEP,
            importe as AQPB756IMP, -- importe del devengado en movimientos es acumulativo, pero siempre en positivo
                                   --(CASE WHEN F.HCODMO=2 THEN (F.HCIMP1)*-1 WHEN F.HCODMO=1 THEN (F.HCIMP1) END) -- 0=Sdo.Anterior 1=Debe 2=Haber
            CATE as AQPB756BCCATE, -- O:NOR; 1:CPP; 2:DEF; 3:DUD; 4:PER
            D.BCRUBR AQPB756RUBR,
            D.BCSDMO AQPB756BCSDMO, -- saldo de devengado moneda origen, pero siempre en negativo
            (importe + D.BCSDMO) AS AQPB756TOT,
           ve_fchcorte as AQPB756FCARGA

          from ( 
               SELECT /*+ all_rows parallel(R,20) parallel(f,20) index(f FSH01200)*/ aqpb567emp,aqpb567mod,
                      aqpb567suc,aqpb567mda,aqpb567pap,aqpb567cta,aqpb567ope,aqpb567sbo,aqpb567top,aqpb567ori,aqpb567fep,
                      sum(aqpb567impo) importe,f.BCCATE CATE
               FROM AQPB567 R,  fsh012 f
               WHERE f.BCEMP = R.aqpb567emp and 
               f.BCSUC = R.aqpb567suc and 
               f.BCMDA = R.aqpb567mda and
               f.BCPAP = R.aqpb567pap and 
               f.BCCTA = R.aqpb567cta and 
               f.BCOPER = R.aqpb567ope and 
               f.BCSBOP = R.aqpb567sbo and
               f.BCTOP = R.aqpb567top and 
               f.BCFECH = ve_fchcorte and 
               f.BCSDMO<>0
               group by R.aqpb567emp,R.aqpb567mod,R.aqpb567suc,R.aqpb567mda,R.aqpb567pap,R.aqpb567cta,R.aqpb567ope,
                       R.aqpb567sbo,R.aqpb567top,R.aqpb567ori,R.aqpb567fep,f.BCCATE
              ) LEFT JOIN FSH012 D  ON D.BCEMP  = aqpb567emp AND D.BCSUC  = aqpb567suc
              AND (SUBSTR(D.BCRUBR, 1, 4) IN ('1418', '1428'))
              AND D.BCMDA  = aqpb567mda AND D.BCPAP  = aqpb567pap AND
              D.BCCTA = aqpb567cta AND D.BCOPER = aqpb567ope AND D.BCSBOP = aqpb567sbo AND
              D.BCFECH = ve_fchcorte AND D.BCSDMO <> 0;

          vs_filasafectadas := SQL%ROWCOUNT;
                 DBMS_OUTPUT.put_line('Filas insertadas AQPB756:' || vs_filasafectadas);
          COMMIT;
         EXCEPTION
           WHEN OTHERS THEN
           err_code := SQLCODE;
           err_msg := SUBSTR(SQLERRM, 1, 500);
           DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg  );
           vs_filasafectadas:= 0;
           rollback;
      END;
END SP_CR_PRIMER_ENTREGABLE;

PROCEDURE SP_CR_SEGUNDO_ENTREGABLE (ve_fchini in date, ve_fchcorte in date, vs_filasafectadas out number) IS
   err_code    NUMBER;
 err_msg   VARCHAR2(1500);

BEGIN
   vs_filasafectadas:=1;
     BEGIN
       DELETE FROM AQPB758H WHERE AQPB758HFCAR >= ve_fchcorte ;
                 dbms_output.put_line ('FILAS BORRADAS AQPB758H: ' || SQL%ROWCOUNT);
       COMMIT;
     EXCEPTION
       WHEN OTHERS THEN
                dbms_output.put_line ('Nose pudo Borrar AQPB758H');
     END;
    BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE AQPB758';
       DBMS_OUTPUT.put_line('TRUNCADO AQPB758');
      COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
       DBMS_OUTPUT.put_line('Nose pudo Truncar AQPB758: ');
    END;


    BEGIN
        INSERT INTO AQPB758
        SELECT AQPB756EMP ,AQPB756MOD,
                AQPB756SUC ,AQPB756MDA,
                AQPB756PAP ,AQPB756CTA,
                AQPB756OPE ,AQPB756SBO,
                AQPB756TOP ,AQPB756ORI,
                AQPB756FEP ,AQPB756BCCATE,
                AQPB756RUBR,
                (CASE WHEN AQPB756TOT > 0 THEN AQPB756BCSDMO * -1 ELSE AQPB756IMP END) AS AQPB758IMPEXT,
                0 AS AQPB758MODT, 0 AS AQPB758SUCT,
                0 AS AQPB758TRAT, 0 AS AQPB758RELT,
                'N'  AS AQPB758CONT, ' ' as AQPB758ERROR,
                null AS FECT, AQPB756FCARGA as AQPB758FCAR, '' AS AQPB758USER
         FROM AQPB756
         WHERE (AQPB756EMP ,AQPB756MOD, AQPB756SUC ,AQPB756MDA, AQPB756PAP ,AQPB756CTA, AQPB756OPE ,AQPB756SBO,AQPB756TOP )
         NOT IN (/*NO CONCIDERAR LOS CREDITOS CUYA ULTIMA REPROGRMACION SON CONCENSUADOS*/
            SELECT  /*+ all_rows */ j.jaqa400emp, j.jaqa400mod ,j.jaqa400suc ,j.jaqa400mda, j.jaqa400pap ,j.jaqa400cta ,j.jaqa400ope,j.jaqa400sbo,j.jaqa400top
            FROM jaqa400 j
            WHERE j.jaqa400est = 'C'
            and j.jaqa400ac1 = 'C'
            and j.jaqa400fec = (select /*+ FIRST_ROWS (1) */ max(jaqa400fec) from jaqa400 jj
                               where jj.jaqa400emp=j.jaqa400emp
                               and jj.jaqa400mod=j.jaqa400mod
                               and jj.jaqa400suc=j.jaqa400suc
                               and jj.jaqa400mda=j.jaqa400mda
                               and jj.jaqa400pap=j.jaqa400pap
                               and jj.jaqa400cta=j.jaqa400cta
                               and jj.jaqa400ope=j.jaqa400ope
                               and jj.jaqa400sbo=j.jaqa400sbo
                               and jj.jaqa400top=j.jaqa400top
                               and jj.jaqa400est= 'C'
                               and jj.jaqa400fec<=ve_fchcorte)) AND
         AQPB756IMP > 0 AND --1era regla
         substr(AQPB756BCCATE,1,1)< 3 AND --2da regla
         AQPB756BCSDMO < 0 AND -- 3ra regla
         AQPB756RUBR IS NOT NULL; -- 4ta regla

              vs_filasafectadas := SQL%ROWCOUNT;
              DBMS_OUTPUT.put_line('Filas insertadas AQPB758:' || to_char(vs_filasafectadas));
         commit;
          EXCEPTION
            WHEN OTHERS THEN
              err_code := SQLCODE;
              err_msg := SUBSTR(SQLERRM, 1, 500);
              DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg  );
              vs_filasafectadas:=0;
              ROLLBACK;

     END;
     BEGIN

         INSERT INTO AQPB758H
         SELECT AQPB756EMP ,AQPB756MOD,
                AQPB756SUC ,AQPB756MDA,
                AQPB756PAP ,AQPB756CTA,
                AQPB756OPE ,AQPB756SBO,
                AQPB756TOP ,AQPB756ORI,
                AQPB756FEP ,AQPB756BCCATE,
                AQPB756RUBR,(CASE WHEN AQPB756TOT > 0 THEN AQPB756BCSDMO * -1 ELSE AQPB756IMP END) AS AQPB758IMPEXT,
                0 AS AQPB758MODT, 0 AS AQPB758SUCT,
                0 AS AQPB758TRAT, 0 AS AQPB758RELT,
                'N'  AS AQPB758CONT, ' ' as AQPB758ERROR,
                null AS FECT, AQPB756FCARGA as AQPB758FCAR, '' AS AQPB758HUSER
         FROM AQPB756
         WHERE (AQPB756EMP ,AQPB756MOD, AQPB756SUC ,AQPB756MDA, AQPB756PAP ,AQPB756CTA, AQPB756OPE ,AQPB756SBO,AQPB756TOP )
         NOT IN (/*NO CONCIDERAR LOS CREDITOS CUYA ULTIMA REPROGRMACION SON CONCENSUADOS*/
            SELECT /*+ all_rows */ j.jaqa400emp, j.jaqa400mod ,j.jaqa400suc ,j.jaqa400mda, j.jaqa400pap ,j.jaqa400cta ,j.jaqa400ope,j.jaqa400sbo,j.jaqa400top
            FROM jaqa400 j
            WHERE j.jaqa400est = 'C'
            and j.jaqa400ac1 = 'C'
            and j.jaqa400fec = (select max(jaqa400fec) from jaqa400 jj
                               where jj.jaqa400emp=j.jaqa400emp
                               and jj.jaqa400mod=j.jaqa400mod
                               and jj.jaqa400suc=j.jaqa400suc
                               and jj.jaqa400mda=j.jaqa400mda
                               and jj.jaqa400pap=j.jaqa400pap
                               and jj.jaqa400cta=j.jaqa400cta
                               and jj.jaqa400ope=j.jaqa400ope
                               and jj.jaqa400sbo=j.jaqa400sbo
                               and jj.jaqa400top=j.jaqa400top
                               and jj.jaqa400est= 'C'
                               and jj.jaqa400fec<=ve_fchcorte)) AND
         AQPB756IMP > 0 AND --1era regla
         substr(AQPB756BCCATE,1,1)< 3 AND --2da regla
         AQPB756BCSDMO < 0 AND -- 3ra regla
         AQPB756RUBR IS NOT NULL; -- 4ta regla

        vs_filasafectadas := SQL%ROWCOUNT;
              DBMS_OUTPUT.put_line('Filas insertadas AQPB758H:' || to_char(vs_filasafectadas));
         commit;



       EXCEPTION
            WHEN OTHERS THEN
              err_code := SQLCODE;
              err_msg := SUBSTR(SQLERRM, 1, 500);
              DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg  );
              vs_filasafectadas:=0;
              ROLLBACK;
     END;
END;





procedure sp_cr_inserta_devengado(codzon in number,fecini in date, fecfin in date)
  is
    err_code    NUMBER;
  err_msg   VARCHAR2(1500);


  cursor lista_contable is
  select  a.aqpb567temp,a.aqpb567mod,a.aqpb567tsuc,a.aqpb567tmda,a.aqpb567tpap ,a.aqpb567tcta,
          a.aqpb567tope,a.aqpb567tsbo,a.aqpb567ttop,a.aqpb567tori,a.aqpb567tfep,
          h.hcimp1,h.hrubro,h.hfvco,h.PGCOD,h.HCMOD,h.HSUCOR,h.HTRAN,h.HNREL,h.hcodmo,h.imported
     from AQPB755 h, AQPB567T a, fst810 t81,fst811 t80
     where h.pgcod = a.aqpb567temp
       and h.hmda = a.aqpb567tmda
       and h.hpap = a.aqpb567tpap
       and h.hcta = a.aqpb567tcta
       and h.hoper = a.aqpb567tope
       and h.hfvco BETWEEN a.aqpb567tfep and  fecfin
       and a.aqpb567tsuc = t80.oficod
       and t80.pgcod = t81.pgcod
       and t80.regcod = t81.regcod
       and t81.regcod < 100
       and t80.regcod < 100
       and t81.regcod =  codzon;
  begin
     --RECORRO CURSOR
     for x in lista_contable loop
       begin
           INSERT INTO  aqpb567 ( AQPB567emp ,
                                  AQPB567mod ,
                                  AQPB567suc ,
                                  AQPB567mda ,
                                  AQPB567pap ,
                                  AQPB567cta ,
                                  AQPB567ope ,
                                  AQPB567sbo ,
                                  AQPB567top ,
                                  AQPB567ori ,
                                  AQPB567fep ,
                                  AQPB567imp ,
                                  AQPB567rubr,
                                  AQPB567pgc ,
                                  AQPB567hcmo,
                                  AQPB567hsuc,
                                  AQPB567htra,
                                  AQPB567hnre,
                                  AQPB567hfc ,
                                  AQPB567hcdm,
                                  AQPB567impo)
                          VALUES (x.aqpb567temp,x.aqpb567mod,x.aqpb567tsuc,x.aqpb567tmda,x.aqpb567tpap,x.aqpb567tcta,
                                  x.aqpb567tope,x.aqpb567tsbo,x.aqpb567ttop,x.aqpb567tori,x.aqpb567tfep,
                                  x.hcimp1,x.hrubro,x.PGCOD,x.HCMOD,x.HSUCOR,x.HTRAN,x.HNREL,x.hfvco,
                                  x.HCODMO,
                                  x.IMPORTED);
                          COMMIT;
                               DBMS_OUTPUT.put_line('Ok' );
       exception
         when others then
                       err_code := SQLCODE;
                     err_msg := SUBSTR(SQLERRM, 1, 500);
                     DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg );
         end;
     end loop;
--  exception
 -- when others then
  --  null;
  end;
end PQ_CR_CALCULOUNIMAS;
 /* GOLDENGATE_DDL_REPLICATION */
/

