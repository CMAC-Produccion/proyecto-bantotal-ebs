create or replace package PQ_CR_JOBS_MONTO_CAPITALIZADO is
  -- *****************************************************************
  -- NOMBRE                     : PQ_CR_JOBS_MONTO_CAPITALIZADO
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : CRÉDITOS - ACTIVAS
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 2024.05.15
  -- AUTOR DE CREACIÓN          : APACHECOH
  -- USO                        : EJECUTAR JOBS MONTO CAPITALIZADO EN LA CARTERA
  -- ESTADO                     : ACTIVO
  -- ACCESO                     : PÚBLICO
  -- FECHA DE MODIFICACIÓN      : 
  -- AUTOR DE LA MODIFICACIÓN   : 
  -- DESCRIPCIÓN DE MODIFICACIÓN: 
  -- *****************************************************************

  procedure sp_job_carga(P_D_FECPRO IN DATE, P_C_USR IN VARCHAR2);

  Procedure sp_carga_data(P_D_FECPRO IN DATE,
                          P_N_DIGITO IN NUMBER,
                          P_C_USR    IN VARCHAR2);

end PQ_CR_JOBS_MONTO_CAPITALIZADO;
/

create or replace package body PQ_CR_JOBS_MONTO_CAPITALIZADO is

  procedure sp_job_carga(P_D_FECPRO IN DATE, P_C_USR IN VARCHAR2) IS
  
    lc_fecpro   varchar2(10);
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    ln_limit    number := 0;
    ln_numjob   number := 0;
  BEGIN
    begin
      select host_name into lc_hostname from v$instance;
    end;
    lc_fecpro := to_char(P_D_FECPRO, 'RRRR.MM.DD');
  
    --apachecoh 2024.05.15
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 12
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
  
    FOR job IN 0 .. 99 LOOP
      lc_variable := ' begin ' ||
                     ' PQ_CR_JOBS_MONTO_CAPITALIZADO.sp_carga_data(TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),' || job || ',''' ||
                     P_C_USR || ''');' || ' End; ';
      ln_job      := ln_job + 1;
    
      BEGIN
        IF SYS.FN_BD_ISRAC = 'TRUE' THEN
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          --instance => ln_inst,
                          instance => 1,
                          force    => false);
        ELSE
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          force     => false);
        END IF;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --apachecoh 2023.10.10  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE
               upper('%PQ_CR_JOBS_MONTO_CAPITALIZADO.sp_carga_data%');
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob >= ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 upper('%PQ_CR_JOBS_MONTO_CAPITALIZADO.sp_carga_data%');
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
    END LOOP;
  
  end sp_job_carga;

  Procedure sp_carga_data(P_D_FECPRO IN DATE,
                          P_N_DIGITO IN NUMBER,
                          P_C_USR    IN VARCHAR2) is
  
    CURSOR C_CLIENTES(P_D_FECHA DATE) IS
      SELECT T.AQPC867PGCOD,
             T.AQPC867MOD,
             T.AQPC867SUC,
             T.AQPC867MDA,
             T.AQPC867PAP,
             T.AQPC867CTA,
             T.AQPC867OPER,
             T.AQPC867SBOP,
             T.AQPC867TOPE
        FROM AQPC867 T
       WHERE MOD(T.AQPC867OPER, 100) = P_N_DIGITO       
         --AND T.AQPC867CTA = 2022340
         AND T.AQPC867FEC = P_D_FECPRO;
  
    LC_CODERR         VARCHAR2(2000);
    L_D_ULT_FEC       DATE;
    L_N_TOT_MONT      NUMBER(17, 2);
    L_N_CAPPAG        NUMBER(17, 2);
    L_V_ERROR         VARCHAR2(100);
    L_N_ERROR         NUMBER(5);
    P_C_CREDITO       VARCHAR2(50);
    L_AQPB838CAP_TOT  NUMBER(17, 2);
    L_AQPB838INT_TOT  NUMBER(17, 2);
    L_AQPB838MOR_TOT  NUMBER(17, 2);
    L_AQPB838SEG_TOT  NUMBER(17, 2);
    L_AQPB838ICV_TOT  NUMBER(17, 2);
    L_AQPB838PEN_TOT  NUMBER(17, 2);
    L_AQPB838NCAP_TOT NUMBER(17, 2);
    L_AQPB838INTD_TOT NUMBER(17, 2);
    L_AQPB838MTOD_TOT NUMBER(17, 2);
  
  BEGIN
    begin
      update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = P_N_DIGITO
         and g.c_codage = 'SC';
      commit;
    exception
      when others then
        null;
    end;
  
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=". "';
  
    FOR I IN C_CLIENTES(P_D_FECPRO) LOOP
      --Cargar Historico
      begin
        pq_cr_cambios_creditos.sp_cambios_historia(P_C_USR,
                                                   I.AQPC867PGCOD,
                                                   I.AQPC867MOD,
                                                   I.AQPC867SUC,
                                                   I.AQPC867MDA,
                                                   I.AQPC867PAP,
                                                   I.AQPC867CTA,
                                                   I.AQPC867OPER,
                                                   I.AQPC867SBOP,
                                                   I.AQPC867TOPE,
                                                   L_N_ERROR,
                                                   L_V_ERROR);
        /*PQ_CR_MONTO_CAPITALIZADO.SP_CR_OBTENER_MONTO_CAPITALIZADO(I.AQPC867CTA,
        I.AQPC867OPER,
        P_C_USR,
        L_D_ULT_FEC,
        L_N_TOT_MONT,
        L_V_ERROR);*/
        P_C_CREDITO := trim(to_char(I.AQPC867PGCOD, '000')) ||
                       trim(to_char(I.AQPC867MOD, '000')) ||
                       trim(to_char(I.AQPC867SUC, '000')) ||
                       trim(to_char(I.AQPC867MDA, '000')) ||
                       trim(to_char(I.AQPC867PAP, '0000')) ||
                       trim(to_char(I.AQPC867CTA, '000000000')) ||
                       trim(to_char(I.AQPC867OPER, '000000000')) ||
                       trim(to_char(I.AQPC867SBOP, '000')) ||
                       trim(to_char(I.AQPC867TOPE, '000'));
      exception
        when others then
          null;
      end;
      --Obtener Totales
      begin
        pQ_CR_DETALLEPAGOS.sp_cr_totaleshist(P_C_USR,
                                             P_C_CREDITO,
                                             L_AQPB838CAP_TOT,
                                             L_AQPB838INT_TOT,
                                             L_AQPB838MOR_TOT,
                                             L_AQPB838SEG_TOT,
                                             L_AQPB838ICV_TOT,
                                             L_AQPB838PEN_TOT,
                                             L_AQPB838NCAP_TOT,
                                             L_AQPB838INTD_TOT,
                                             L_AQPB838MTOD_TOT);
      
      exception
        when others then
          null;
      end;
      --Obtener capital pagado
      /*begin
        SELECT NVL(SUM(PP1CAP), 0)
          INTO L_N_CAPPAG
          FROM FSD602 F
         WHERE F.PGCOD = I.AQPC867PGCOD
           AND F.PPMOD = I.AQPC867MOD
           AND F.PPSUC = I.AQPC867SUC
           AND F.PPMDA = I.AQPC867MDA
           AND F.PPPAP = I.AQPC867PAP
           AND F.PPCTA = I.AQPC867CTA
           AND F.PPOPER = I.AQPC867OPER
           AND F.PPSBOP = I.AQPC867SBOP
           AND F.PPTOPE = I.AQPC867TOPE
           AND F.PP1CAP > 0
           AND F.D602CO = 'S';
      exception
        when others then
          null;
      end;*/
      --Actualizar tabla
      begin
        UPDATE AQPC867 A
           SET A.AQPC867SUMOCA = NVL(L_AQPB838NCAP_TOT + L_AQPB838INTD_TOT,0),
               A.AQPC867DIF    = NVL(A.AQPC867SACACR - L_AQPB838NCAP_TOT, 0),
               A.AQPC867CAPPAG = L_AQPB838CAP_TOT,
               A.AQPC867AUX1   = P_C_CREDITO,
               A.AQPC867AUX2   = P_C_USR,
               A.AQPC867AUX3   = TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               A.AQPC867AUXD1  = TRUNC(SYSDATE)
         WHERE A.AQPC867CTA = I.AQPC867CTA
           AND A.AQPC867OPER = I.AQPC867OPER
           AND A.AQPC867FEC = P_D_FECPRO;
        COMMIT;
      exception
        when others then
          null;
      end;
      begin
        update tab_jobs g
           set g.d_fecfin = SYSDATE
         where g.n_numer1 = P_N_DIGITO
           and g.c_codage = 'SC';
        commit;
      exception
        when others then
          null;
      end;
    END LOOP;
  
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      begin
        update tab_jobs g
           set g.c_inderr = 'S', g.c_deserr = lc_coderr
         where g.n_numer1 = P_N_DIGITO
           and g.c_codage = 'SC';
        commit;
      exception
        when others then
          null;
      end;
      return;
  end sp_carga_data;

end PQ_CR_JOBS_MONTO_CAPITALIZADO;
/

