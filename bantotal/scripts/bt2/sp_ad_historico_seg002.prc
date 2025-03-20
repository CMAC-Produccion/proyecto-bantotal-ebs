CREATE OR REPLACE PROCEDURE "SP_AD_HISTORICO_SEG002" IS
  CURSOR C1 IS
    SELECT INDEX_NAME
      FROM DBA_INDEXES
     WHERE TABLE_NAME = 'SEG002'
       AND OWNER = 'BANTPROD';
  V_ERROR VARCHAR2(4000);
  -- *****************************************************************
  -- Nombre                     : SP_AD_HISTORICO_SEG002
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Logins Bantotal
  -- Versión                    : 1.0
  -- Fecha de Creación          : 17/11/2023
  -- Autor de Creación          : ERIKA HIDALGO/LUIS CARPIO
  -- Uso                        : Pase a histórico SEG002
  -- Estado                     : Activo
  -- Parámetros de Entrada      : 
  -- Fecha de Modificación      : 20/11/2023
  -- Autor de Modificación      : ERIKA HIDALGO/LUIS CARPIO
BEGIN
  INSERT INTO SEG002H
    SELECT * FROM SEG002 WHERE SEG002FCI < TRUNC(SYSDATE) - 7; --20.11.2023
  COMMIT;
  DELETE FROM SEG002 WHERE SEG002FCI < TRUNC(SYSDATE) - 7; --20.11.2023
  COMMIT;
  EXECUTE IMMEDIATE 'ALTER TABLE SEG002 MOVE ONLINE';
  FOR I IN C1 LOOP
    EXECUTE IMMEDIATE 'alter index ' || I.INDEX_NAME || ' rebuild online';
  END LOOP;
  DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                TABNAME          => 'SEG002',
                                DEGREE           => 8,
                                GRANULARITY      => 'ALL',
                                ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                CASCADE          => TRUE);
EXCEPTION
  WHEN OTHERS THEN
    v_error := 'ORA-'||SQLCODE ||'-'||SQLERRM;
    SYS.SP_SY_ENVIAMAIL('ehidalgom@cajaarequipa.pe',
                        'ehidalgom@cajaarequipa.pe',
                        'Revisar SP_AD_HISTORICO_SEG002',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        V_ERROR || CHR(13));
    SYS.SP_SY_ENVIAMAIL('kcabrerac@cajaarequipa.pe',
                        'kcabrerac@cajaarequipa.pe',
                        'Revisar SP_AD_HISTORICO_SEG002',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        V_ERROR || CHR(13));
END SP_AD_HISTORICO_SEG002;
 /* GOLDENGATE_DDL_REPLICATION */
/

