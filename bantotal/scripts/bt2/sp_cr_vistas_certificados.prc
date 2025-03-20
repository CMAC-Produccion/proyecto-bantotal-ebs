CREATE OR REPLACE PROCEDURE "SP_CR_VISTAS_CERTIFICADOS"
AS 
  -- *****************************************************************
  -- NOMBRE                     : SP_CR_VISTAS_CERTIFICADOS
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- USO                        : Carga data de Sigsretail en tablas de BT para que acceso a flujo de credito sea local
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      : 
  -- AUTOR                      : ERIKA HIDALGO      
   v_error varchar2(4000);
BEGIN
    BEGIN
    --VALIDA DBLINK
    DBMS_SCHEDULER.CREATE_JOB (
        JOB_NAME     => 'BANTPROD.DBLINK',
        JOB_TYPE     => 'PLSQL_BLOCK',
        JOB_ACTION   =>    'DECLARE '
                        || '  X CHAR; '
                        || 'BEGIN '
                        || '  SELECT dummy into x from dual@SISRETAIL'
                        || '  ;'
                        || '  DBMS_OUTPUT.put_line('''
                        || 'BANTPROD'
                        || ' '
                        || 'SISRETAIL'
                        || ' VALID'');'
                        || 'END ; ');

    EXCEPTION
        WHEN OTHERS THEN 
          NULL;
    END;

    BEGIN
        DBMS_SCHEDULER.RUN_JOB ('BANTPROD.DBLINK ', TRUE);
    EXCEPTION
        WHEN OTHERS
        THEN
            v_error := 'ORA-'||SQLCODE ||'-'||SQLERRM;
            DBMS_OUTPUT.PUT_LINE (
                   'BANTPROD'
                || ' '
                || 'SISRETAIL'
                || ' INVALID (ORA'
                || SQLCODE
                || ')');
            DBMS_SCHEDULER.DROP_JOB ('BANTPROD.DBLINK ');
            sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                                'No hay acceso a @SISRETAIL en SP_CR_VISTAS_CERTIFICADOS',
                                'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||
                                'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||
                                'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||
                                v_error||CHR(13));
            sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
                                'No hay acceso a @SISRETAIL en SP_CR_VISTAS_CERTIFICADOS',
                                'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||
                                'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||
                                'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||
                                v_error||CHR(13));
            RETURN;  --PARA TODO
    END;
    BEGIN
    DBMS_SCHEDULER.DROP_JOB ('BANTPROD.DBLINK ');
    EXCEPTION
        WHEN OTHERS THEN 
          NULL;
    END;
    --CONTINUAR

    EXECUTE IMMEDIATE 'TRUNCATE TABLE AQPB889 DROP STORAGE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE AQPB890 DROP STORAGE';


    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'AQPB889',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'AQPB890',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;

    --CARGA TABLAS PUENTE

    --V_CERTSEGUROS@SISRETAIL
    INSERT INTO AQPB889
    SELECT /*ORA_HASH(PRODUCTO||CERTIFICADO|| CUENTA|| DOCUMENTO) ID*/
     distinct FN_CR_TOKENIZADO_SHA1(PRODUCTO || '-' || CERTIFICADO || '-' || CUENTA || '-' ||    --2023.11.10
                           DOCUMENTO) NID,
     A.PRODUCTO,
     A.CERTIFICADO,
     A.CUENTA,
     A.DOCUMENTO
      FROM V_CERTSEGUROS@SISRETAIL A; --
    COMMIT;

    --V_CERTIFICADOS
    INSERT INTO AQPB890
      SELECT distinct FN_CR_TOKENIZADO_SHA1(P."PROD_Interno" || '-' || P."CANL_Interno" || '-' || --2023.11.10
                                   P."PROD_NombreProducto" || '-' ||
                                   C."CERT_NumCertificado" || '-' ||
                                   C."CERT_NumCuenta" || '-' ||
                                   C."CERT_DniTitularCta") ID,
             P."PROD_Interno" PRODINT,
             P."CANL_Interno" CANLINT,
             P."PROD_NombreProducto" PRODUCTO,
             C."CERT_NumCertificado" CERTIFICADO,
             C."CERT_NumCuenta" CUENTA,
             C."CERT_DniTitularCta" DOCUMENTO
        FROM "SSR_Certificados"@SISRETAIL C
       INNER JOIN "SSR_Productos"@SISRETAIL P
          ON P."PROD_Interno" = C."PROD_Interno"
         AND P."CANL_Interno" = C."CANL_Interno"
       WHERE C."CERT_Estado" IN ('V', 'P');
    COMMIT;

    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'AQPB889',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'AQPB890',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => 100,
                                    CASCADE          => TRUE);
    END;

    --ACTUALIZA TABLAS UTILIZADAS POR FLUJO DE CRÉDITO

    --V_CERTSEGUROS@SISRETAIL
    INSERT INTO AQPB891
      SELECT *
        FROM AQPB889 B
       WHERE NOT EXISTS (SELECT 1 FROM AQPB891 A WHERE A.NID = B.NID);
    DELETE FROM AQPB891 A
     WHERE NOT EXISTS (SELECT 1 FROM AQPB889 B WHERE B.NID = A.NID);
    COMMIT;

    --V_CERTIFICADOS
    INSERT INTO AQPB892
      SELECT *
        FROM AQPB890 B
       WHERE NOT EXISTS (SELECT 1 FROM AQPB892 A WHERE A.NID = B.NID);
    DELETE FROM AQPB892 A
     WHERE NOT EXISTS (SELECT 1 FROM AQPB890 B WHERE B.NID = A.NID);
    COMMIT;

    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'AQPB891',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                    CASCADE          => TRUE);
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'AQPB892',
                                    DEGREE           => 8,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                    CASCADE          => TRUE);
    END;

END;
 /* GOLDENGATE_DDL_REPLICATION */
/

