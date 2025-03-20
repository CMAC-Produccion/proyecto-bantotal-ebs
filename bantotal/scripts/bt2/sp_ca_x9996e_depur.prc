CREATE OR REPLACE PROCEDURE "SP_CA_X9996E_DEPUR" IS
  c_error VARCHAR2(30000);
  TABLA_ACTUAL VARCHAR2(1000);
  CURSOR C_GRANTS(V_TABLA_ACTUAL VARCHAR2) IS
    SELECT 'grant ' || PRIVILEGE || ' on ' || OWNER || '.X9996E to ' ||
           GRANTEE COMANDO
      FROM DBA_TAB_PRIVS A
     WHERE TABLE_NAME = V_TABLA_ACTUAL
       AND OWNER = 'BANTPROD';

  CURSOR C_OBJDESC IS
    SELECT 'ALTER ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME ||
           ' COMPILE DEBUG' COMPILAR
      FROM DBA_OBJECTS
     WHERE OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'TRIGGER')
       AND OWNER = 'BANTPROD'
       AND STATUS = 'INVALID'
    UNION
    SELECT 'ALTER PACKAGE ' || OWNER || '.' || OBJECT_NAME ||
           ' COMPILE DEBUG BODY' COMPILAR
      FROM DBA_OBJECTS
     WHERE OBJECT_TYPE = 'PACKAGE BODY'
       AND OWNER = 'BANTPROD'
       AND STATUS = 'INVALID'
    UNION
    SELECT 'ALTER ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME ||
           ' COMPILE' COMPILAR
      FROM DBA_OBJECTS
     WHERE OBJECT_TYPE IN ('VIEW')
       AND OWNER = 'BANTPROD'
       AND STATUS = 'INVALID';
  N_CONT number;
BEGIN

  SELECT COUNT(9)
    INTO N_CONT
    FROM DBA_TABLES
   WHERE OWNER = 'BANTPROD'
     AND TABLE_NAME = 'X9996E_NEW';

  IF N_CONT > 0 THEN
    TABLA_ACTUAL := 'X9996E_DEPU_' || TO_CHAR(SYSDATE, 'DDMMRRRR_HH24MI');

    BEGIN
      EXECUTE IMMEDIATE 'RENAME X9996E TO ' || TABLA_ACTUAL;
      EXECUTE IMMEDIATE 'RENAME X9996E_NEW TO X9996E';
    EXCEPTION
      WHEN OTHERS THEN
      c_error := TO_CHAR('ERROR: '||SQLCODE||' - '||SQLERRM);
      sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',   'FALLÓ EN RENAME DE X9996E','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla X9996E');
      sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',     'FALLÓ EN RENAME DE X9996E','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||c_error||CHR(13)||'Revisar tabla X9996E');
      RETURN;
    end;

    EXECUTE IMMEDIATE 'create or replace public synonym X9996E for bantprod.X9996E';

    FOR I IN C_GRANTS(TABLA_ACTUAL) LOOP
      EXECUTE IMMEDIATE I.COMANDO;
    END LOOP;

    --1RA ITERACIÓN
    EXECUTE IMMEDIATE 'update ' || TABLA_ACTUAL || ' a
     set a.X9996EVALC = ''99999999999999999999999999999''';
    COMMIT;
    --2DA ITERACIÓN
    EXECUTE IMMEDIATE 'update ' || TABLA_ACTUAL || ' a
     set a.X9996EVALC = ''88888888888888888888888888888''';
    COMMIT;
    --3RA ITERACIÓN
    EXECUTE IMMEDIATE 'update ' || TABLA_ACTUAL || ' a
     set a.X9996EVALC = ''77777777777777777777777777777''';
    COMMIT;
    --DEPURACIÓN
    EXECUTE IMMEDIATE 'drop table ' || TABLA_ACTUAL || ' purge';

    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'X9996E',
                                    DEGREE           => 12,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                    CASCADE          => TRUE);
    END;

    FOR I IN C_OBJDESC LOOP
      BEGIN
        EXECUTE IMMEDIATE I.COMPILAR;
      EXCEPTION
        WHEN OTHERS THEN
          C_ERROR := TO_CHAR('ERROR: ' || SQLCODE || ' - ' || SQLERRM);
          DBMS_OUTPUT.PUT_LINE(C_ERROR);
      END;
    END LOOP;

    --LOG
    INSERT INTO AQPB884 VALUES (USER, SYSDATE, 'SP_CA_X9996E_DEPUR');
    COMMIT;
  END IF;

END SP_CA_X9996E_DEPUR;
 /* GOLDENGATE_DDL_REPLICATION */
/

