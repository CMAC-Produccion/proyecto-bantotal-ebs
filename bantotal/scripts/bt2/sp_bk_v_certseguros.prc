CREATE OR REPLACE PROCEDURE "SP_BK_V_CERTSEGUROS" IS
  LC_ERROR   VARCHAR2(1000);
  LC_STMT    VARCHAR2(2000);
  V_HOSTNAME VARCHAR2(1000);
BEGIN
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
  BEGIN
    LC_STMT := 'create table OPERADOR.V_CERTSEGUROS_' ||
               TO_CHAR(SYSDATE, 'RRRRMMDD_HH24MISS') ||
               ' as SELECT * FROM V_CERTSEGUROS@SISRETAIL';
    EXECUTE IMMEDIATE LC_STMT;
  EXCEPTION
    WHEN OTHERS THEN
      LC_ERROR := SQLCODE || ' - ' || SQLERRM;
      SYS.SP_SY_ENVIAMAIL('ehidalgom@cajaarequipa.pe',
                          'ehidalgom@cajaarequipa.pe',
                          'Error Proceso SP_BK_V_CERTSEGUROS- ' ||
                          SYS_CONTEXT('USERENV', 'DB_NAME'),
                          'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                          CHR(13) || 'INSTANCIA=' ||
                          SYS_CONTEXT('USERENV', 'INSTANCE_NAME') ||
                          CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                          'Hora Actual en Servidor : ' ||
                          TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                          'Error :' || LC_ERROR || CHR(13) || 'Revisar.');
      SYS.SP_SY_ENVIAMAIL('kcabrerac@cajaarequipa.pe',
                          'kcabrerac@cajaarequipa.pe',
                          'Error Proceso SP_BK_V_CERTSEGUROS- ' ||
                          SYS_CONTEXT('USERENV', 'DB_NAME'),
                          'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                          CHR(13) || 'INSTANCIA=' ||
                          SYS_CONTEXT('USERENV', 'INSTANCE_NAME') ||
                          CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                          'Hora Actual en Servidor : ' ||
                          TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                          'Error :' || LC_ERROR || CHR(13) || 'Revisar.');
  END;

END SP_BK_V_CERTSEGUROS;
 /* GOLDENGATE_DDL_REPLICATION */
/

