create or replace package "PQ_CR_EXTORDEV_DIARIO" is
  /*
  *-- Author  : HSUAREZ
  *-- Created : 8/04/2021 14:33:38
  *-- Modificado: Bhernard S. Beisaga
  *-- Purpose : Paqute para el calculo de devengados en créditos reprogramados
  *-- Modificado: 15/07/2022
      Se ha adicionado sp_jobs_cargaini_nor para ejecucion por schedules
      Se ha adiconado sp_jobs_cargaini_bulk para ejecuciones por Bulk (DATA MASIVA)
      Se ha adicionado SP_CR_CARGAINI_BULK carga de FSH016 po bulk
      Se ha adicionado SP_CR_CARGAINI_NOR carga de FSH016 po schedules
      Se ha adicionado SP_CR_INSERT_REPROGRAMADOS para lsita de reprogramados
      Se ha adicionado SP_CR_INSERT_REPOFINAL entregable
      Modificado: Hsuarez - 10/05/2023 -  Se cambio los jobs de Regiones a Sucursales, y se implemento la nueva forma de devengamiento.
      Modificado: Hsuarez - 25/12/2023 - Se agrego filtros adicionales y guia para ser dinamico el devengamiento total de los crditos con rubros segun Carmen y guia especial.
      Modificado: Hsuarez - 30/01/2024 - Se modifico el proceso de extorno para los que se cumple que se deben extornar todo se optimizo consulta para que demore menos.
      Modificado: Hsuarez - 23/09/2024 - Se modifico el log de correos se agregaron exceptions.
      Modificado: JALVAROH - 04/10/2024 - Se agrego filtro de fecha a la tabla TMP_FSH016
      Modificado: JALVAROH - 19/12/2024 - Se agrego el procedimiento SP_CR_INSERTA_FECHA_MAXIMA que obtiene la fecha maxima
      Modificado: JALVAROH - 19/12/2024 - Se modifico el paquete SP_CR_DIARIO_INSERT_REPROGRAMADOS se reestructuro la insercion de scripts
      Modificado: JALVAROH - 23/12/2024 - Se agrego jobs al procedimiento de insercion de reprogramados
      Modificado: JALVAROH - 23/12/2024 - Se agrego jobs para actualizar la fecha maxima en la tabla AQPB567T
      Modificado: JALVAROH - 26/12/2024 - Se modifico el procedimiento sp_jobs_DIARIO_cargaini_nor, llamada al lista reprogamado
      */


  procedure sp_jobs_DIARIO_cargaini_nor(ve_fecini in varchar,
                                        ve_fecfin in varchar);

  PROCEDURE SP_CR_DIARIO_CARGAINI_NOR(ve_codregion in number,
                                      ve_fchini    in date,
                                      ve_fchcorte  in date);

  PROCEDURE SP_CR_DIARIO_INSERT_REPROGRAMADOS(ve_fchini    in date,
                                              ve_fchcorte  in date,
                                              Ve_FECHA_INI in date);
  procedure sp_jobs_DIARIO_lista_reprog(ve_fecini in date,
                                        ve_fecfin in date,
                                        vo_datos  out number);

  procedure sp_jobs_DIARIO_carga_devengado(ve_fecini in date,
                                           ve_fecfin in date);

  procedure sp_cr_DIARIO_inserta_devengado(codzon in number,
                                           fecini in date,
                                           fecfin in date);

  PROCEDURE SP_CR_DIARIO_PRIMER_ENTREGABLE(ve_fchini         in date,
                                           ve_fchcorte       in date,
                                           vs_filasafectadas out number);

  PROCEDURE SP_CR_DIARIO_SEGUNDO_ENTREGABLE(ve_fchini         in date,
                                            ve_fchcorte       in date,
                                            vs_filasafectadas out number);

  Function fn_cr_DIARIO_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                       P_C_HOSTNA IN VARCHAR2) return number;

  procedure sp_jobs_DIARIO_fecha_maxima(ve_fecini in date,
                                        ve_fecfin in date);
  PROCEDURE SP_CR_INSERTA_FECHA_MAXIMA(vi_suc in number);

end PQ_CR_EXTORDEV_DIARIO;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_CR_EXTORDEV_DIARIO" is

  --1

  procedure sp_jobs_DIARIO_cargaini_nor(ve_fecini in varchar,
                                        ve_fecfin in varchar) is

    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecini   date;
    lc_fecfin   date;
    lc_hostname varchar2(64);

    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_rpta       number := 0;
    n_inst        number;
    vi_contab     number;
    resultado     varchar2(3000);
    vi_correos    VARCHAR2(300);
    p_c_coderr    VARCHAR2(1500);
    p_c_deserr    VARCHAR2(1500);
    --
    lc_nomusr VARCHAR(30);
    cursor zona is
    --select regcod, regnom from fst810 where regcod < 100;
      select SUCURS from fst001 where sucurs < 800; --HASL cambio de codigo de region a sucursal.
    cursor email is
      select TP1DESC
        from fst198
       where tp1cod1 = 10899
         and tp1corr1 = 4000
         and TP1CORR2 = 1
         and TP1CORR3 > 0;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;

    lc_fecini := to_date(ve_fecini, 'dd/mm/yyyy');
    lc_fecfin := to_date(ve_fecfin, 'dd/mm/yyyy');

    delete from AQPB755 where hfvco >= lc_fecini; --@HSUAREZ - 2023.07.27 - Comentado descomentar
    dbms_output.put_line('FILAS BORRADAS AQPB755: ' || SQL%ROWCOUNT);
    resultado := 'FILAS BORRADAS AQPB755: ' || SQL%ROWCOUNT;
    commit;

    dbms_output.put_line('>>>>INICIO DE LA CARGA INI NOR : ' ||
                         localtimestamp);
    resultado := resultado || '<br><br> >>>>INICIO DE LA CARGA INI NOR : ' ||
                 localtimestamp;
    ---carga diaria
    for i in zona loop
      ln_ini        := i.sucurs;
      lc_prefjob    := 'AQPB755D';
      pi_vc2_nomjob := lc_prefjob || to_char(lc_fecfin, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job

      lc_variable := 'BEGIN ' ||
                     '  PQ_CR_EXTORDEV_DIARIO.SP_CR_DIARIO_CARGAINI_NOR(' ||
                     ln_ini || ',''' || lc_fecini || ''',''' || lc_fecfin ||
                     '''); END;';
      ln_job      := ln_job + 1;

      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;
      if n_inst in (1, 2) then
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Carga_diaria_fsd016');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob,
                                       'instance_id',
                                       n_inst);
        exception
          when others then
            null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Carga_diaria_fsd016');

      End If;
      commit;
      --     dbms_output.put_line ('RESPUESTA: ' || to_char(lc_rpta));

      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('AQPB755D', ln_ini, lc_variable);
      COMMIT;

    end loop;

    ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);

    While ln_numjob > 0 loop
      ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;

    dbms_output.put_line('>>>>CARGA MASIVA TERMINADA: ' || localtimestamp);
    resultado := resultado || '<br><br> >>>>CARGA MASIVA TERMINADA: ' ||
                 localtimestamp;


    dbms_output.put_line('>>>>INSERT INICIO REPROGRAMADOS : ' ||
                         localtimestamp);
    resultado := resultado || '<br><br> >>>>INSERT INICIO REPROGRAMADOS : ' ||
                 localtimestamp;

    -----------------------------------------------------
    -- aqui se colocara l jobs de lista reprogamado
    -----------------------------------------------------

    PQ_CR_EXTORDEV_DIARIO.sp_jobs_DIARIO_lista_reprog(lc_fecini,
                                                      lc_fecfin,
                                                      lc_rpta);

    dbms_output.put_line('>>>>INSERT REPROGRAMADOS TERMINADO: ' ||
                         localtimestamp);
    resultado := resultado ||
                 '<br><br> >>>>INSERT REPROGRAMADOS TERMINADO: ' ||
                 localtimestamp;

    /* --- ESTADISTICAS AQPB567T */
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;
    DBMS_STATS.gather_table_stats(ownname          => lc_nomusr,
                                  tabname          => 'AQPB567T',
                                  degree           => 40,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
    /* FIN ESTADISTICAS */
    If lc_rpta > 0 then
      /* INSERT FECHA ULTIMA CONTABLE POR CREDITO PROCESADO*/
      PQ_CR_EXTORDEV_DIARIO.sp_jobs_DIARIO_fecha_maxima(lc_fecini,
                                                        lc_fecfin);
      dbms_output.put_line('>>>>INSERT FECHA MAXIMA TERMINADO: ' ||
                           localtimestamp);
      resultado := resultado ||
                   '<br><br> >>>>INSERT FECHA MAXIMA TERMINADO: ' ||
                   localtimestamp;
      /*CARGO LOS DEVENGADOS DE LOS CREDITOS */
      PQ_CR_EXTORDEV_DIARIO.sp_jobs_DIARIO_carga_devengado(lc_fecini,
                                                           lc_fecfin);
      dbms_output.put_line('>>>>INSERT DEVENGADOS TERMINADO: ' ||
                           localtimestamp);
      resultado := resultado ||
                   '<br><br> >>>>INSERT DEVENGADOS TERMINADO: ' ||
                   localtimestamp;
      /* --- ESTADISTICAS */
      begin
        select TRIM(TP1DESC)
          INTO lc_nomusr
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
      end;
      DBMS_STATS.gather_table_stats(ownname          => lc_nomusr,
                                    tabname          => 'AQPB567',
                                    degree           => 40,
                                    granularity      => 'ALL',
                                    estimate_percent => 100,
                                    cascade          => TRUE);
      /* FIN ESTADISTICAS */
      PQ_CR_EXTORDEV_DIARIO.SP_CR_DIARIO_PRIMER_ENTREGABLE(lc_fecini,
                                                           lc_fecfin,
                                                           vs_filasafectadas => lc_rpta);
      dbms_output.put_line('>>>>INSERT PRIMER ENTGREGABLE: ' ||
                           localtimestamp);
      resultado := resultado || '<br><br> >>>>INSERT PRIMER ENTGREGABLE: ' ||
                   localtimestamp;
      If lc_rpta >= 0 then
        PQ_CR_EXTORDEV_DIARIO.SP_CR_DIARIO_SEGUNDO_ENTREGABLE(lc_fecini,
                                                              lc_fecfin,
                                                              vs_filasafectadas => lc_rpta);
        dbms_output.put_line('>>>>INSERT SEGUNDO ENTGREGABLE: ' ||
                             localtimestamp);
        resultado := resultado ||
                     '<br><br> >>>>INSERT SEGUNDO ENTGREGABLE: ' ||
                     localtimestamp;
        If lc_rpta > 0 then
          DBMS_OUTPUT.put_line('Se ha procesado TODO satisfactoriamente');
          resultado := resultado ||
                       '<br><br> Se ha procesado TODO satisfactoriamente';
        else
          DBMS_OUTPUT.put_line('Falla en el proceso');
          resultado := resultado || '<br><br> Falla en el proceso';
        end if;
      else
        DBMS_OUTPUT.put_line('Falla en SP_CR_DIARIO_PRIMER_ENTREGABLE');
        resultado := resultado ||
                     '<br><br> Falla en SP_CR_DIARIO_PRIMER_ENTREGABLE';
      end if;
    end if;
    --AGREGADO ADICIONAL - EMIAL DE STATUS DEL PROCESO.
    FOR X IN EMAIL LOOP
      BEGIN
        vi_correos := vi_correos || trim(X.TP1DESC) || ';';
      END;
    END LOOP;
    vi_correos := SUBSTR(vi_correos, 1, (LENGTH(vi_correos) - 1));
    BEGIN
      pq_ah_planillas.p_sendmailattach(vi_correos, --p_destinatariospara
                                       '', --p_destinatarioscc
                                       '', --p_destinatariosbcc
                                       resultado, --mensaje a enviar
                                       'notificacionesbantotal@cajaarequipa.pe', --remitente
                                       'Resultados de la Ejecucion', --p_asunto
                                       'HTML', --p_asunto
                                       '', --p_directorio
                                       '', --p_archivosadjuntos
                                       p_c_coderr,
                                       p_c_deserr);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    DBMS_OUTPUT.put_line('Error2: ' || p_c_coderr || '-' || p_c_deserr);
  END;

  PROCEDURE SP_CR_DIARIO_CARGAINI_NOR(ve_codregion in number,
                                      ve_fchini    in date,
                                      ve_fchcorte  in date) IS
    err_code            NUMBER;
    err_msg             VARCHAR2(1500);
    p_c_coderr          VARCHAR2(1500);
    p_c_deserr          VARCHAR2(1500);
    p_destinatariospara varchar2(30);
    p_destinatarioscc   varchar2(30);
    vi_correos          VARCHAR2(200);

    cursor email is
      select TP1DESC
        from fst198
       where tp1cod1 = 10899
         and tp1corr1 = 4000
         and TP1CORR2 = 1
         and TP1CORR3 > 0;

    cursor data is

      SELECT /*+ all_rows */
       F.PGCOD,
       F.ITMOD,
       F.ITSUC,
       F.ITTRAN,
       F.ITNREL,
       H5.ITFCON AS HFCON, --ve_fchcorte AS HFCON, hasl@17.08.2023
       F.ITORD,
       F.ITSBOR,
       F.RUBRO,
       F.MONEDA,
       F.PAPEL,
       F.CTNRO,
       F.ITOPER,
       F.ITIMP1,
       h5.ITFVC AS HFVCO, --ve_fchcorte AS HFVCO, hasl@17.08.2023
       F.ITDBHA AS HCODMO,
       (CASE
         WHEN F.ITDBHA = 2 THEN
          (F.ITIMP1) * -1
         WHEN F.ITDBHA = 1 THEN
          (F.ITIMP1)
       END) IMPORTED, --0=Sdo.Anterior 1=Debe 2=Haber
       ve_fchcorte AS FCARGA
        FROM FSD016 F, FSD015 H5 --, FST811 S
       WHERE F.pgcod = H5.PGCOD
         AND F.ITMOD = H5.ITMOD
         AND F.ITSUC = H5.ITSUC
         AND F.ITTRAN = H5.ITTRAN
         AND F.ITNREL = H5.ITNREL
         AND F.ITSUCD = ve_codregion
         AND SUBSTR(F.RUBRO, 1, 4) IN ('1418', '1428')
         AND H5.ITCORR = 0; --EXTORNO QUE NO SE

  BEGIN

    FOR Y IN DATA LOOP
      BEGIN
        INSERT INTO AQPB755
          (PGCOD,
           HCMOD,
           HSUCOR,
           HTRAN,
           HNREL,
           HFCON,
           HCORD,
           HCSUBO,
           HRUBRO,
           HMDA,
           HPAP,
           HCTA,
           HOPER,
           HCIMP1,
           HFVCO,
           HCODMO,
           IMPORTED,
           FCARGA)
        VALUES
          (Y.PGCOD,
           Y.ITMOD,
           Y.ITSUC,
           Y.ITTRAN,
           Y.ITNREL,
           Y.HFCON,
           Y.ITORD,
           Y.ITSBOR, --(SUBORDINAL)
           Y.RUBRO,
           Y.MONEDA,
           Y.PAPEL,
           Y.CTNRO,
           Y.ITOPER,
           Y.ITIMP1,
           Y.HFVCO,
           Y.HCODMO,
           Y.IMPORTED,
           Y.FCARGA);
        COMMIT;
        -- DBMS_OUTPUT.put_line('Ok');
      EXCEPTION
        when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 500);
          err_msg  := 'Error1: ' || err_code || '-' || err_msg || '  Cta: ' ||
                      Y.CTNRO || '  Oper: ' || Y.ITOPER;
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
          -- @HSUAREZ 27072023 - comentado solo para las pruebas. descomentar
          BEGIN
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
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;

          DBMS_OUTPUT.put_line('Error2: ' || p_c_coderr || '-' ||
                               p_c_deserr);
          --*/
          ---------------------------------------------------------------------------
          rollback;
      END;
    END LOOP;
  END SP_CR_DIARIO_CARGAINI_NOR;

  PROCEDURE SP_CR_DIARIO_INSERT_REPROGRAMADOS(ve_fchini    in date,
                                              ve_fchcorte  in date,
                                              Ve_FECHA_INI in date) IS
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
    vs_filasafectadas   number(17, 2);
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
        /*AND*/
         F.HFVCO = VIC_FECHA),
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
                   AND F.hfvco <= ve_fchcorte) LISTA)

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

    --    vs_filasafectadas := 0;
    --RECORREMOS LAS FECHAS SEGUN RANGO
    --VI_FECHA_ITER:=VI_FECHA_INI;
    vs_filasafectadas := 0;
    --WHILE VI_FECHA_ITER <= ve_fchcorte  LOOP
    --INSERTAMOS LA LISTA DE REPROGMADOS
    BEGIN
      OPEN c_reprog(VE_FECHA_INI);
      FETCH c_reprog BULK COLLECT
        INTO tabla_data_reprog;
      CLOSE c_reprog;
      /*FORALL IDX IN INDICES OF tabla_data_reprog
      SAVE EXCEPTIONS INSERT
        INTO aqpb567t VALUES tabla_data_reprog(IDX);*/
      FORALL IDX IN INDICES OF tabla_data_reprog
        MERGE INTO aqpb567t tgt
        USING (SELECT * FROM DUAL) src
        ON (tgt.AQPB567TEMP = tabla_data_reprog(idx).EMPR AND tgt.AQPB567MOD = tabla_data_reprog(idx).MODL AND tgt.AQPB567TSUC = tabla_data_reprog(idx).SUCL AND tgt.AQPB567TMDA = tabla_data_reprog(idx).MNDA AND tgt.AQPB567TPAP = tabla_data_reprog(idx).PAPL AND tgt.AQPB567TCTA = tabla_data_reprog(idx).NCTA AND tgt.AQPB567TOPE = tabla_data_reprog(idx).NOPE AND tgt.AQPB567TSBO = tabla_data_reprog(idx).NSBO AND tgt.AQPB567TTOP = tabla_data_reprog(idx).NTOP AND tgt.AQPB567TORI = tabla_data_reprog(idx).ORGN AND tgt.AQPB567TFEP = tabla_data_reprog(idx).FCHR) -- Reemplazar con la clave única
        WHEN NOT MATCHED THEN
          INSERT
            (AQPB567TEMP,
             AQPB567MOD,
             AQPB567TSUC,
             AQPB567TMDA,
             AQPB567TPAP,
             AQPB567TCTA,
             AQPB567TOPE,
             AQPB567TSBO,
             AQPB567TTOP,
             AQPB567TORI,
             AQPB567TFEP) -- Reemplazar con todas las columnas
          VALUES
            (tabla_data_reprog(idx).EMPR,
             tabla_data_reprog(idx).MODL,
             tabla_data_reprog(idx).SUCL,
             tabla_data_reprog(idx).MNDA,
             tabla_data_reprog(idx).PAPL,
             tabla_data_reprog(idx).NCTA,
             tabla_data_reprog(idx).NOPE,
             tabla_data_reprog(idx).NSBO,
             tabla_data_reprog(idx).NTOP,
             tabla_data_reprog(idx).ORGN,
             tabla_data_reprog(idx).FCHR);
      COMMIT;
      vs_filasafectadas := SQL%ROWCOUNT;
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
    --  VI_FECHA_ITER := VI_FECHA_ITER +1;
    --END LOOP;
    DBMS_OUTPUT.put_line('Filas insertadas AQPB567T:' ||
                         to_char(vs_filasafectadas));
  EXCEPTION
    WHEN OTHERS THEN
      vs_filasafectadas := 0;
      ROLLBACK;
  END;

  --------------------

  Function fn_cr_DIARIO_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
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
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    end;

    begin
      SELECT COUNT(1)
        INTO ln_numjob
        FROM dba_scheduler_jobs job
       WHERE owner = lc_nomusr
         AND job.job_name LIKE P_C_NOMJOB || '%';
    exception
      when others then
        ln_numjob := 0;
    end;

    return ln_numjob;
  end fn_cr_DIARIO_verifica_tarea;

  procedure sp_jobs_DIARIO_lista_reprog(ve_fecini in date,
                                        ve_fecfin in date,
                                        vo_datos  out number) IS

    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    n_inst        number;
    VI_FECHA_ITER DATE;
    VI_FECHA_INI  DATE;

    -- variables faltantes
    VI_EXISTE  NUMBER;
    err_code   NUMBER;
    err_msg    VARCHAR2(1500);
    vi_correos varchar2(200);
    p_c_coderr VARCHAR2(1500);
    p_c_deserr VARCHAR2(1500);


    cursor email is
      select TP1DESC
        from fst198
       where tp1cod1 = 10899
         and tp1corr1 = 4000
         and TP1CORR2 = 1
         and TP1CORR3 > 0;

  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;

    BEGIN
      -- CONSULTA ADICIONAL PARA SABER SI HAY DATA EN CASO NO SE CARGUE LA DE BI
      VI_EXISTE := 0;
      BEGIN
        SELECT COUNT(*)
          INTO VI_EXISTE
          FROM AQPB836
         WHERE AQPB836FECBI = to_date(ve_fecfin, 'DD/MM/RRRR')
           AND AQPB836APLEXT = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          VI_EXISTE := 0;
      END;

      IF VI_EXISTE = 0 THEN
        err_code := SQLCODE;
        err_msg  := SUBSTR(SQLERRM, 1, 500);
        err_msg  := 'No existe data cargada en BI, con Fecha ' || ve_fecfin;
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

    /* INICIALIZANDO VARIABLES */
    BEGIN
      SELECT MIN(AQPB836FEC)
        INTO VI_FECHA_INI
        FROM AQPB836 J
       WHERE J.AQPB836APLEXT = 'S'
         AND J.AQPB836FECBI = ve_fecfin; --ve_fchcorte;
    EXCEPTION
      WHEN OTHERS THEN
        VI_FECHA_INI := TO_DATE('01/01/2030', 'DD/MM/YYYY');
    END;
    /* FIN */

    ---carga diaria
    VI_FECHA_ITER := VI_FECHA_INI;
    -- vs_filasafectadas := 0;

    -- verificamos sia hay data para ejecutar el insert reprogramados
    IF VI_EXISTE > 0 THEN
      WHILE VI_FECHA_ITER <= ve_fecfin LOOP
        -- ve_fchcorte
        ln_ini        := to_number(to_char(ve_fecfin, 'ddmmrrrr')); --i.SUCURS
        lc_prefjob    := 'AQPB567T';
        pi_vc2_nomjob := lc_prefjob || to_char(ve_fecfin, 'ddmmrrrr') ||
                         TO_CHAR(VI_FECHA_ITER, 'DDMMYYYY'); ---ln_job

        lc_variable := 'begin ' ||
                       '  PQ_CR_EXTORDEV_DIARIO.sp_cr_DIARIO_INSERT_REPROGRAMADOS(''' ||
                       ve_fecini || ''',''' || ve_fecfin || ''' ,''' ||
                       VI_FECHA_ITER || '''); End;';
        ln_job      := ln_job + 1;

        --     IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;
        if n_inst in (1, 2) then

          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable,
                                    start_date => SYSTIMESTAMP, --sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Insercion devengado AQPB567T');
          begin
            dbms_scheduler.set_attribute(pi_vc2_nomjob,
                                         'instance_id',
                                         n_inst);
          exception
            when others then
              null;
          end;
        Else
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable,
                                    start_date => SYSTIMESTAMP, --sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Insercion devengado AQPB567T');

        End If;
        commit;

        INSERT INTO Tab_jobs
          (c_Codage, n_Numer1, c_detjob)
        VALUES
          ('AQPB567T', ln_ini, lc_variable);
        COMMIT;
        VI_FECHA_ITER := VI_FECHA_ITER + 1;
      end loop;

      ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);

      While ln_numjob > 0 loop
        ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);
      End loop;

      DBMS_OUTPUT.put_line('Se termino JOBS Lista');
    END IF;
    -- fin del insert reprogramados

    BEGIN
      SELECT COUNT(*) INTO vo_datos FROM AQPB567T;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    DBMS_OUTPUT.put_line('TOTAL CREDITOS AQPB567T: ' || vo_datos);
  end;

  procedure sp_jobs_DIARIO_carga_devengado(ve_fecini in date,
                                           ve_fecfin in date) IS

    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;

    lc_hostname varchar2(64);

    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    n_inst        number;

    cursor zona is
    --select regcod, regnom from fst810 where regcod < 100;
      select SUCURS from fst001 where sucurs < 800;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
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

    ---carga diaria
    for i in zona loop
      ln_ini        := i.SUCURS;
      lc_prefjob    := 'AQPB567D';
      pi_vc2_nomjob := lc_prefjob || to_char(ve_fecfin, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job

      lc_variable := 'begin ' ||
                     '  PQ_CR_EXTORDEV_DIARIO.sp_cr_DIARIO_inserta_devengado(' ||
                     ln_ini || ',''' || ve_fecini || ''',''' || ve_fecfin ||
                     ''' ); End;';
      ln_job      := ln_job + 1;

      --     IF SYS.FN_BD_ISRAC = 'TRUE' THEN
      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;
      if n_inst in (1, 2) then

        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => SYSTIMESTAMP, --sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Insercion devengado AQPB567');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob,
                                       'instance_id',
                                       n_inst);
        exception
          when others then
            null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => SYSTIMESTAMP, --sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Insercion devengado AQPB567');

      End If;
      commit;

      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('AQPB567D', ln_ini, lc_variable);
      COMMIT;

    end loop;

    ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);

    While ln_numjob > 0 loop
      ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;

    DBMS_OUTPUT.put_line('Se termino JOBS devengado');

  end;

  PROCEDURE SP_CR_DIARIO_PRIMER_ENTREGABLE(ve_fchini         in date,
                                           ve_fchcorte       in date,
                                           vs_filasafectadas out number) IS
    err_code        NUMBER;
    err_msg         VARCHAR2(1500);
    VI_FECINI_EXTOR DATE;
  BEGIN
    BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE AQPB756';
      DBMS_OUTPUT.put_line('TRUNCADO AQPB756');
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Nose pudo Truncar AQPB756 ');
    END;

    ---
    --GUIA AUXILIAR
    BEGIN
      SELECT TO_DATE(TPDESC, 'RRRR.MM.DD')
        INTO VI_FECINI_EXTOR
        FROM FST098
       where PGCOD = 1
         and TPCOD = 7754
         and TPCORR = 1;
    EXCEPTION
      WHEN OTHERS THEN
        VI_FECINI_EXTOR := TO_DATE('20/12/2022', 'DD/MM/RRRR');
    END;

    --SCRIPT PARA PROCESAR SOLO LOS ENVIADOS POR BI Y QUE CUMPLEN LA CONDICION QUE SE DEBE EXTORNAR
    BEGIN
      INSERT INTO AQPB756
        SELECT /*+ all_rows*/
         aqpb567emp as AQPB756EMP,
         aqpb567mod as AQPB756MOD,
         aqpb567suc as AQPB756SUC,
         aqpb567mda as AQPB756MDA,
         aqpb567pap as AQPB756PAP,
         aqpb567cta as AQPB756CTA,
         aqpb567ope as AQPB756OPE,
         aqpb567sbo as AQPB756SBO,
         aqpb567top as AQPB756TOP,
         aqpb567ori as AQPB756ORI,
         aqpb567fep as AQPB756FEP,
         importe    as AQPB756IMP, -- importe del devengado en movimientos es acumulativo
         --(CASE WHEN F.HCODMO=2 THEN (F.HCIMP1)*-1 WHEN F.HCODMO=1 THEN (F.HCIMP1) END) -- 0=Sdo.Anterior 1=Debe 2=Haber
         BCCATE as AQPB756BCCATE, -- O:NOR; 1:CPP; 2:DEF; 3:DUD; 4:PER
         d.SCRUB as AQPB756RUBR,
         d.SCSDO as AQPB756BCSDMO, -- saldo de devengado moneda origen
         (importe + d.SCSDO) AS AQPB756TOT,
         ve_fchcorte as AQPB756FCARGA
          FROM (SELECT /*+ all_rows parallel(R,20) parallel(f,20) parallel(g,20) index(f FSD01110)*/
                 aqpb567emp,
                 aqpb567mod,
                 aqpb567suc,
                 aqpb567mda,
                 aqpb567pap,
                 aqpb567cta,
                 aqpb567ope,
                 aqpb567sbo,
                 aqpb567top,
                 aqpb567ori,
                 aqpb567fep,
                 sum(aqpb567impo) importe,
                 g.BCCATE
                  FROM AQPB567 R, FSD011 f, FSH012 g
                 WHERE f.pgcod = R.aqpb567emp
                   and f.SCSUC = R.aqpb567suc
                   and f.SCMDA = R.aqpb567mda
                   and f.SCPAP = R.aqpb567pap
                   and f.SCCTA = R.aqpb567cta
                   and f.SCOPER = R.aqpb567ope
                   and f.SCSBOP = R.aqpb567sbo
                   and f.sctope = R.aqpb567top
                   and f.SCSDO <> 0
                      -------------------------
                   and g.BCEMP = AQPB567EMP
                   AND g.BCSUC = AQPB567SUC
                   AND g.BCMDA = AQPB567MDA
                   AND g.BCPAP = AQPB567PAP
                   AND g.BCCTA = AQPB567CTA
                   AND g.BCOPER = AQPB567OPE
                   AND g.BCSBOP = AQPB567SBO
                   AND g.bctop = R.aqpb567top
                   AND
                      --                   AND (SUBSTR(g.BCRUBR, 1, 4) IN ('1418','1428'))
                      --g.BCFECH = (ve_fchcorte - 1)-- @HSUAREZ volver en la bcfech a restando 1 dia, solo para pruebas se quito la resta
                       g.BCFECH = (ve_fchcorte - 1) --and g.BCSDMO<>0*/
                 GROUP BY R.aqpb567emp,
                          R.aqpb567mod,
                          R.aqpb567suc,
                          R.aqpb567mda,
                          R.aqpb567pap,
                          R.aqpb567cta,
                          R.aqpb567ope,
                          R.aqpb567sbo,
                          R.aqpb567top,
                          R.aqpb567ori,
                          R.aqpb567fep,
                          g.BCCATE) y
          LEFT JOIN fsd011 D
            ON d.pgcod = AQPB567EMP
           AND D.SCSUC = AQPB567SUC
           AND (SUBSTR(D.SCRUB, 1, 4) IN ('1418', '1428'))
           AND D.SCMDA = AQPB567MDA
           AND D.SCPAP = AQPB567PAP
           AND D.SCCTA = AQPB567CTA
           AND D.SCOPER = AQPB567OPE
           AND D.SCSBOP = AQPB567SBO
           AND D.SCSDO <> 0;

      vs_filasafectadas := SQL%ROWCOUNT;
      DBMS_OUTPUT.put_line('Filas insertadas AQPB756:' ||
                           vs_filasafectadas);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        err_code := SQLCODE;
        err_msg  := SUBSTR(SQLERRM, 1, 500);
        DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg);
        vs_filasafectadas := 0;
        rollback;
    END;
    --FIN DE NUEVO SCRIPT EXCLUSIVO PARA LOS DE OFICIO 2022.

  END SP_CR_DIARIO_PRIMER_ENTREGABLE;

  PROCEDURE SP_CR_DIARIO_SEGUNDO_ENTREGABLE(ve_fchini         in date,
                                            ve_fchcorte       in date,
                                            vs_filasafectadas out number) IS
    err_code NUMBER;
    err_msg  VARCHAR2(1500);

    pd_fecpro  date;
    lc_fecproa char(8);
    lc_fecprod char(10);
    lc_sql     varchar(4000);

    vi_correos varchar2(200);
    p_c_coderr VARCHAR2(1500);
    p_c_deserr VARCHAR2(1500);

    cursor email is
      select TP1DESC
        from fst198
       where tp1cod1 = 10899
         and tp1corr1 = 4000
         and TP1CORR2 = 1
         and TP1CORR3 > 0;
  BEGIN
    vs_filasafectadas := 1;
    /*verifica si hay contabilizacion*/
    BEGIN
      DELETE FROM AQPB758H WHERE AQPB758HFCAR >= ve_fchcorte;
      dbms_output.put_line('FILAS BORRADAS AQPB758H: ' || SQL%ROWCOUNT);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('Nose pudo Borrar AQPB758H');
    END;
    BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE AQPB758';
      DBMS_OUTPUT.put_line('TRUNCADO AQPB758');
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('No se pudo Truncar AQPB758: ');
    END;

    BEGIN
      INSERT INTO AQPB758
        SELECT AQPB756EMP,
               AQPB756MOD,
               AQPB756SUC,
               AQPB756MDA,
               AQPB756PAP,
               AQPB756CTA,
               AQPB756OPE,
               AQPB756SBO,
               AQPB756TOP,
               AQPB756ORI,
               AQPB756FEP,
               AQPB756BCCATE,
               AQPB756RUBR,
               (CASE
                 WHEN AQPB756TOT > 0 THEN
                  AQPB756BCSDMO * -1
                 ELSE
                  AQPB756IMP
               END) AS AQPB758IMPEXT,
               0 AS AQPB758MODT,
               0 AS AQPB758SUCT,
               0 AS AQPB758TRAT,
               0 AS AQPB758RELT,
               'N' AS AQPB758CONT,
               ' ' as AQPB758ERROR,
               null AS FECT,
               AQPB756FCARGA as AQPB758FCAR,
               '' AS AQPB758USER
          FROM AQPB756
         WHERE AQPB756IMP > 0
           AND --1era regla
               substr(AQPB756BCCATE, 1, 1) < 3
           AND --2da regla
               AQPB756BCSDMO < 0
           AND -- 3ra regla
               AQPB756RUBR IS NOT NULL; -- 4ta regla
      vs_filasafectadas := SQL%ROWCOUNT;
      DBMS_OUTPUT.put_line('Filas insertadas AQPB758:' ||
                           to_char(vs_filasafectadas));
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        err_code := SQLCODE;
        err_msg  := SUBSTR(SQLERRM, 1, 500);
        DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg);
        vs_filasafectadas := 0;
        ROLLBACK;
    END;
    BEGIN
      INSERT INTO AQPB758H
        SELECT AQPB756EMP,
               AQPB756MOD,
               AQPB756SUC,
               AQPB756MDA,
               AQPB756PAP,
               AQPB756CTA,
               AQPB756OPE,
               AQPB756SBO,
               AQPB756TOP,
               AQPB756ORI,
               AQPB756FEP,
               AQPB756BCCATE,
               AQPB756RUBR,
               (CASE
                 WHEN AQPB756TOT > 0 THEN
                  AQPB756BCSDMO * -1
                 ELSE
                  AQPB756IMP
               END) AS AQPB758IMPEXT,
               0 AS AQPB758MODT,
               0 AS AQPB758SUCT,
               0 AS AQPB758TRAT,
               0 AS AQPB758RELT,
               'N' AS AQPB758CONT,
               ' ' as AQPB758ERROR,
               null AS FECT,
               AQPB756FCARGA as AQPB758FCAR,
               '' AS AQPB758HUSER
          FROM AQPB756
         WHERE AQPB756IMP > 0
           AND --1era regla
               substr(AQPB756BCCATE, 1, 1) < 3
           AND --2da regla
               AQPB756BCSDMO < 0
           AND -- 3ra regla
               AQPB756RUBR IS NOT NULL; -- 4ta regla

      vs_filasafectadas := SQL%ROWCOUNT;
      DBMS_OUTPUT.put_line('Filas insertadas AQPB758H:' ||
                           to_char(vs_filasafectadas));
      commit;

    EXCEPTION
      WHEN OTHERS THEN
        err_code := SQLCODE;
        err_msg  := SUBSTR(SQLERRM, 1, 500);
        DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg);
        vs_filasafectadas := 0;
        ROLLBACK;
    END;

    BEGIN
      pd_fecpro  := to_date(ve_fchcorte, 'DD/MM/RRRR');
      lc_fecproa := to_char((pd_fecpro - 1), 'RRRRMMDD');
      lc_fecprod := to_char(pd_fecpro, 'DD/MM/RRRR');

      lc_sql := 'DECLARE
                      CURSOR c_consulta IS
                      SELECT DISTINCT
                         AQPB756EMP,AQPB756MOD,AQPB756SUC,AQPB756MDA,AQPB756PAP,AQPB756CTA,AQPB756OPE,AQPB756SBO,AQPB756TOP,AQPB756ORI,
                         AQPB756FEP,''-'' AQPB756BCCATE,AQPB756RUBR,AQPB758IMPEXT,AQPB758MODT,AQPB758SUCT,AQPB758TRAT,AQPB758RELT,
                         AQPB758CONT,AQPB758ERROR,FECT,AQPB758FCAR,AQPB758USER
                      FROM
                      (SELECT
                             B.AQPB836EMP AQPB756EMP, B.AQPB836MOD AQPB756MOD,B.AQPB836SUC AQPB756SUC, B.AQPB836MDA AQPB756MDA,
                             B.AQPB836PAP AQPB756PAP, B.AQPB836CTA AQPB756CTA,B.AQPB836OPER AQPB756OPE, B.AQPB836SBOP AQPB756SBO,
                             B.AQPB836TOP AQPB756TOP, ''81_954y937'' AQPB756ORI,B.AQPB836FEC AQPB756FEP, '''' AQPB756BCCATE,
                             D.SCRUB AQPB756RUBR, D.SCSDO * -1 AQPB758IMPEXT,0 AS AQPB758MODT, 0 AS AQPB758SUCT,0 AS AQPB758TRAT, 0 AS AQPB758RELT,
                             ''N'' AS AQPB758CONT, '' '' AS AQPB758ERROR,NULL AS FECT, B.AQPB836FECBI AS AQPB758FCAR, '' '' AS AQPB758USER
                          FROM AQPB836 B,fsd011 D
                          WHERE D.PGCOD = B.AQPB836EMP
                            AND B.AQPB836FECBI = to_date(''' ||
                lc_fecprod ||
                ''',''dd/mm/rrrr'')
                            AND B.AQPB836APLEXT = ''S''
                            AND B.AQPB836TIP IN (SELECT RPAD(TP1DESC, 34, '' '') FROM FST198 F WHERE F.TP1COD = 1 AND F.TP1COD1 = 11161 AND F.TP1CORR1 = 400 AND F.TP1CORR2 = 3)
                            AND B.AQPB836FEC >=(SELECT TO_DATE(TP1DESC, ''RRRRMMDD'') FROM FST198 WHERE TP1COD1 = 11161 AND TP1CORR1 = 400 AND TP1CORR2 = 2 AND TP1CORR3 = 1)
                            AND D.PGCOD = B.AQPB836EMP
                            AND D.SCRUB IN (SELECT RUBRO FROM FSD014 WHERE RUBRO LIKE ''14_8%'')
                            AND D.SCMDA = B.AQPB836MDA
                            AND D.SCPAP = B.AQPB836PAP
                            AND D.SCCTA = B.AQPB836CTA
                            AND D.SCOPER = B.AQPB836OPER
                            AND D.SCSDO < 0
                      );
                    BEGIN
                      FOR X IN c_consulta LOOP
                        INSERT INTO AQPB758(aqpb758emp, aqpb758mod,aqpb758suc,aqpb758mda,aqpb758pap,aqpb758cta,aqpb758ope,aqpb758sbo,aqpb758top,aqpb758ori,aqpb758fep,aqpb758bccate,aqpb758rubr,aqpb758impext,aqpb758modt,aqpb758suct,aqpb758trat,aqpb758relt,aqpb758cont,aqpb758error,aqpb758fect,aqpb758fcar,aqpb758user )
                        VALUES (X.AQPB756EMP, X.AQPB756MOD, X.AQPB756SUC, X.AQPB756MDA, X.AQPB756PAP,X.AQPB756CTA, X.AQPB756OPE, X.AQPB756SBO, X.AQPB756TOP, X.AQPB756ORI,
                                X.AQPB756FEP,  (SELECT TRIM(F.BCCATE) from fsh012 partition(FSH012_' ||
                lc_fecproa ||
                ') f where f.BCEMP = X.AQPB756EMP AND f.BCFECH = (to_date(''' ||
                lc_fecprod || ''',''dd/mm/rrrr'') - 1)
                        AND f.BCRUBR IN  (SELECT ds.RUBRO FROM FSD014 ds WHERE PCNIVC IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50 AND MODULO >= 100 AND MODULO <= 116))
                        AND f.BCCTA = X.AQPB756CTA AND f.BCOPER = X.AQPB756OPE AND f.BCCATE IN (SELECT SUBSTR(TP1DESC, 1, 15) FROM FST198 WHERE TP1COD1 = 11161 AND TP1CORR1 = 400 AND TP1CORR2 = 4) and rownum=1),
                                X.AQPB756RUBR, X.AQPB758IMPEXT,X.AQPB758MODT, X.AQPB758SUCT, X.AQPB758TRAT, X.AQPB758RELT,
                                X.AQPB758CONT, X.AQPB758ERROR, X.FECT, X.AQPB758FCAR, X.AQPB758USER); COMMIT;
                      END LOOP;
                    END;';
      --INSERT INTO PRUEBA_LOG(PGCOD,MSG) VALUES(150,lc_sql); commit;
      EXECUTE IMMEDIATE lc_sql;
      --dbms_output.put_line(lc_sql);
      commit;

      BEGIN
        -- GUARDAR BACKUP EN LA AQPB758H
        INSERT INTO AQPB758H
          SELECT *
            FROM AQPB758 a
           where a.aqpb758ori = '81_954y937'
             and aqpb758fcar = to_date(lc_fecprod, 'DD/MM/RRRR');
        commit;
      EXCEPTION
        WHEN OTHERS THEN
          begin
            err_msg := SUBSTR(SQLERRM, 1, 500);
            err_msg := err_msg || '--' || lc_sql;
            -----------------envio de correo en caso de error-------------------
            vi_correos := '';
            FOR X IN EMAIL LOOP
              BEGIN
                vi_correos := vi_correos || trim(X.TP1DESC) || ';';
              END;
            END LOOP;
            vi_correos := SUBSTR(vi_correos, 1, (LENGTH(vi_correos) - 1));
            --       DBMS_OUTPUT.put_line(vi_correos);
            BEGIN
              pq_ah_planillas.p_sendmailattach(vi_correos, --p_destinatariospara
                                               '', --p_destinatarioscc
                                               '', --p_destinatariosbcc
                                               err_msg, --mensaje a enviar
                                               'notificacionesbantotal@cajaarequipa.pe', --remitente
                                               'Error insert registro en AQPB758H RUBROS PARTICULAR', --p_asunto
                                               'HTML', --p_asunto
                                               '', --p_directorio
                                               '', --p_archivosadjuntos
                                               p_c_coderr,
                                               p_c_deserr);
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          exception
            when others then
              null;
          end;
      END;

    EXCEPTION
      WHEN OTHERS THEN
        err_msg := SUBSTR(SQLERRM, 1, 500);
        begin
          -----------------envio de correo en caso de error-------------------
          vi_correos := '';
          FOR X IN EMAIL LOOP
            BEGIN
              vi_correos := vi_correos || trim(X.TP1DESC) || ';';
            END;
          END LOOP;
          vi_correos := SUBSTR(vi_correos, 1, (LENGTH(vi_correos) - 1));
          --       DBMS_OUTPUT.put_line(vi_correos);
          BEGIN
            pq_ah_planillas.p_sendmailattach(vi_correos, --p_destinatariospara
                                             '', --p_destinatarioscc
                                             '', --p_destinatariosbcc
                                             err_msg, --mensaje a enviar
                                             'notificacionesbantotal@cajaarequipa.pe', --remitente
                                             'Error insert registro en AQPB758 RUBROS PARTICULAR', --p_asunto
                                             'HTML', --p_asunto
                                             '', --p_directorio
                                             '', --p_archivosadjuntos
                                             p_c_coderr,
                                             p_c_deserr);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        exception
          when others then
            null;
        end;
    END;
    --FIN SCRIPT DE EXTORNO TOTAL DE DEVENGADO.
  END;

  procedure sp_cr_DIARIO_inserta_devengado(codzon in number,
                                           fecini in date,
                                           fecfin in date) is
    err_code       NUMBER;
    err_msg        VARCHAR2(1500);
    vii_fec_iterac DATE;
    cursor lista_maestra_creditos_unicos(vic_suc NUMBER) is
      SELECT * FROM AQPB567T T where T.AQPB567TSUC = vic_suc;

    cursor lista_contable(VIC_emp    NUMBER,
                          VIC_MOD    NUMBER,
                          VIC_SUC    NUMBER,
                          VIC_mda    NUMBER,
                          VIC_pap    NUMBER,
                          VIC_cta    NUMBER,
                          VIC_ope    NUMBER,
                          VIC_sbo    NUMBER,
                          VIC_top    NUMBER,
                          VIC_ori    VARCHAR,
                          VIC_FER    DATE,
                          VIC_FECMAX DATE,
                          VIC_FECHA  DATE) is
      select /*+ all_rows */
       VIC_emp    AS aqpb567temp,
       VIC_MOD    AS aqpb567mod,
       VIC_SUC    AS aqpb567tsuc,
       VIC_mda    AS aqpb567tmda,
       VIC_pap    AS aqpb567tpap,
       VIC_cta    AS aqpb567tcta,
       VIC_ope    AS aqpb567tope,
       VIC_sbo    AS aqpb567tsbo,
       VIC_top    AS aqpb567ttop,
       VIC_ori    AS aqpb567tori,
       VIC_FER    AS aqpb567tfep,
       h.hcimp1,
       h.hrubro,
       h.hfvco,
       h.PGCOD,
       h.HCMOD,
       h.HSUCOR,
       h.HTRAN,
       h.HNREL,
       h.hcodmo,
       h.imported
        from AQPB755 h /*, AQPB567T a*/ /*, fsd011 f, fsh012 g,*/ /* fst810 t81,fst811 t80*/
       where h.pgcod = VIC_emp
         and h.hmda = VIC_mda
         and h.hpap = VIC_pap
         and h.hcta = VIC_cta
         and h.hoper = VIC_ope
         and h.hfvco = VIC_FECHA --BETWEEN a.aqpb567tfep and fecfin
      --and a.aqpb567tsuc = codzon
      UNION ALL
      select /*+ all_rows */
       VIC_emp AS aqpb567temp,
       VIC_MOD AS aqpb567mod,
       VIC_SUC AS aqpb567tsuc,
       VIC_mda AS aqpb567tmda,
       VIC_pap AS aqpb567tpap,
       VIC_cta AS aqpb567tcta,
       VIC_ope AS aqpb567tope,
       VIC_sbo AS aqpb567tsbo,
       VIC_top AS aqpb567ttop,
       VIC_ori AS aqpb567tori,
       VIC_FER AS aqpb567tfep,
       h.hcimp1,
       h.hrubro,
       h.hfvco,
       h.PGCOD,
       h.HCMOD,
       h.HSUCOR,
       h.HTRAN,
       h.HNREL,
       h.hcodmo,
       h.imported * -1 /*Agregado esto para restar el importe*/
        from AQPB755 h /*, AQPB567T a*/ /*, fsd011 f, fsh012 g,*/ /* fst810 t81,fst811 t80*/
       where h.pgcod = VIC_emp
         and h.hmda = VIC_mda
         and h.hpap = VIC_pap
         and h.hcta = VIC_cta
         and h.hoper = VIC_ope
         and h.hfvco = VIC_FECMAX
         and h.hcodmo = 1;
    --and a.aqpb567tsuc = codzon;
  begin
    --RECORRO CURSOR
    for xx in lista_maestra_creditos_unicos(codzon) loop
      vii_fec_iterac := xx.aqpb567tfep;
      while vii_fec_iterac <= fecfin LOOP
        for x in lista_contable(xx.aqpb567temp, xx.aqpb567mod, xx.aqpb567tsuc, xx.aqpb567tmda, xx.aqpb567tpap, xx.aqpb567tcta, xx.aqpb567tope, xx.aqpb567tsbo, xx.aqpb567ttop, xx.aqpb567tori, xx.aqpb567tfep, xx.aqpb567fmax, vii_fec_iterac) loop
          begin
            INSERT INTO aqpb567
              (AQPB567emp,
               AQPB567mod,
               AQPB567suc,
               AQPB567mda,
               AQPB567pap,
               AQPB567cta,
               AQPB567ope,
               AQPB567sbo,
               AQPB567top,
               AQPB567ori,
               AQPB567fep,
               AQPB567imp,
               AQPB567rubr,
               AQPB567pgc,
               AQPB567hcmo,
               AQPB567hsuc,
               AQPB567htra,
               AQPB567hnre,
               AQPB567hfc,
               AQPB567hcdm,
               AQPB567impo)
            VALUES
              (x.aqpb567temp,
               x.aqpb567mod,
               x.aqpb567tsuc,
               x.aqpb567tmda,
               x.aqpb567tpap,
               x.aqpb567tcta,
               x.aqpb567tope,
               x.aqpb567tsbo,
               x.aqpb567ttop,
               x.aqpb567tori,
               x.aqpb567tfep,
               x.hcimp1,
               x.hrubro,
               x.PGCOD,
               x.HCMOD,
               x.HSUCOR,
               x.HTRAN,
               x.HNREL,
               x.hfvco,
               x.HCODMO,
               x.IMPORTED);
            COMMIT;
            DBMS_OUTPUT.put_line('Ok');
          exception
            when others then
              err_code := SQLCODE;
              err_msg  := SUBSTR(SQLERRM, 1, 500);
              DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg);
          end;
        end loop;
        vii_fec_iterac := vii_fec_iterac + 1;
      END LOOP;
    end loop;
  end;

  procedure sp_jobs_DIARIO_fecha_maxima(ve_fecini in date,
                                        ve_fecfin in date) IS

    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;

    lc_hostname varchar2(64);

    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    n_inst        number;

    cursor zona is
    --select regcod, regnom from fst810 where regcod < 100;
      select SUCURS from fst001 where sucurs < 800;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;

    ---carga diaria
    for i in zona loop
      ln_ini        := i.SUCURS;
      lc_prefjob    := 'AQPB567TF';
      pi_vc2_nomjob := lc_prefjob || to_char(ve_fecfin, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job

      lc_variable := 'begin ' ||
                     '  PQ_CR_EXTORDEV_DIARIO.SP_CR_INSERTA_FECHA_MAXIMA(' ||
                     ln_ini || ' ); End;';
      ln_job      := ln_job + 1;

      --     IF SYS.FN_BD_ISRAC = 'TRUE' THEN
      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;
      if n_inst in (1, 2) then

        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => SYSTIMESTAMP, --sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Insercion devengado AQPB567TF');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob,
                                       'instance_id',
                                       n_inst);
        exception
          when others then
            null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => SYSTIMESTAMP, --sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Insercion fecha maxima AQPB567TF');

      End If;
      commit;

      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('AQPB567TF', ln_ini, lc_variable);
      COMMIT;

    end loop;

    ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);

    While ln_numjob > 0 loop
      ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;

    DBMS_OUTPUT.put_line('Se la actualizacion de la fecha en la tabla AQPB567T');

  end;

  PROCEDURE SP_CR_INSERTA_FECHA_MAXIMA(vi_suc in number) IS
    cursor LISTA_AQPB567T IS
      SELECT * FROM AQPB567T T where T.AQPB567TSUC = vi_suc;
  BEGIN
    FOR x in LISTA_AQPB567T LOOP
      UPDATE AQPB567T a
         SET AQPB567FMAX =
             (SELECT /*+ all_rows */
               MAX(h.hfvco)
                FROM AQPB755 h
               WHERE h.pgcod = a.aqpb567temp
                 AND h.hmda = a.aqpb567tmda
                 AND h.hpap = a.aqpb567tpap
                 AND h.hcta = a.aqpb567tcta
                 AND h.hoper = a.aqpb567tope
                 AND h.hfvco < a.aqpb567tfep)
       WHERE A.AQPB567TEMP = x.aqpb567temp
         AND A.AQPB567MOD = x.aqpb567mod
         AND A.AQPB567TSUC = x.aqpb567tsuc
         AND A.AQPB567TMDA = x.aqpb567tmda
         AND A.AQPB567TPAP = x.aqpb567tpap
         AND A.AQPB567TCTA = x.aqpb567tcta
         AND A.AQPB567TOPE = x.aqpb567tope
         AND A.AQPB567TSBO = x.aqpb567tsbo
         AND A.AQPB567TTOP = x.aqpb567ttop
         AND A.AQPB567TFEP = x.aqpb567tfep;

    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END SP_CR_INSERTA_FECHA_MAXIMA;
end PQ_CR_EXTORDEV_DIARIO;
 /* GOLDENGATE_DDL_REPLICATION */
/

