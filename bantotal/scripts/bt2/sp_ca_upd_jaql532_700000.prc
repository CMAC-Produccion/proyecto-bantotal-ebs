CREATE OR REPLACE PROCEDURE "SP_CA_UPD_JAQL532_700000" IS
  N_CONT     number;
  V_HOSTNAME VARCHAR2(1000);
BEGIN
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
  SELECT COUNT(*) INTO N_CONT FROM JAQL532 WHERE JAQL532NUINT > 700000;
  IF N_CONT >= 1 THEN
    UPDATE JAQL532 SET JAQL532NUINT = 1 WHERE JAQL532NUINT > 700000;
    COMMIT;
    SYS.SP_SY_ENVIAMAIL('ehidalgom@cajaarequipa.pe',
                         'ehidalgom@cajaarequipa.pe',
                         'Limite de operaciones en agentes Claro - btprod- ' ||
                         SYS_CONTEXT('USERENV', 'DB_NAME'),
                         'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                         CHR(13) || 'INSTANCIA=' ||
                         SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                         'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         'Hora Actual en Servidor : ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||CHR(13) ||
                         'select count(*) from bantprod.jaql532 where jaql532nuint>700000' ||
                         CHR(13) || 'count(*) = ' || N_CONT || CHR(13) ||
                         'Se actualizó "UPDATE JAQL532 SET JAQL532NUINT=1 WHERE JAQL532NUINT>700000;"' ||
                         CHR(13));
    SYS.SP_SY_ENVIAMAIL('kcabrerac@cajaarequipa.pe',
                        'kcabrerac@cajaarequipa.pe',
                        'Limite de operaciones en agentes Claro - btprod- ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||CHR(13) ||
                         'select count(*) from bantprod.jaql532 where jaql532nuint>700000' ||
                         CHR(13) || 'count(*) = ' || N_CONT || CHR(13) ||
                         'Se actualizó "UPDATE JAQL532 SET JAQL532NUINT=1 WHERE JAQL532NUINT>700000;"' ||
                         CHR(13));
    SYS.SP_SY_ENVIAMAIL('bantoem@cajaarequipa.pe',
                        'lcarpio@cajaarequipa.pe',
                        'Limite de operaciones en agentes Claro - btprod- ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||CHR(13) ||
                         'select count(*) from bantprod.jaql532 where jaql532nuint>700000' ||
                         CHR(13) || 'count(*) = ' || N_CONT || CHR(13) ||
                         'Se actualizó "UPDATE JAQL532 SET JAQL532NUINT=1 WHERE JAQL532NUINT>700000;"' ||
                         CHR(13));
    SYS.SP_SY_ENVIAMAIL('bantoem@cajaarequipa.pe',
                        'jsanchez@cajaarequipa.pe',
                        'Limite de operaciones en agentes Claro - btprod- ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||CHR(13) ||
                         'select count(*) from bantprod.jaql532 where jaql532nuint>700000' ||
                         CHR(13) || 'count(*) = ' || N_CONT || CHR(13) ||
                         'Se actualizó "UPDATE JAQL532 SET JAQL532NUINT=1 WHERE JAQL532NUINT>700000;"' ||
                         CHR(13));
  END IF;
END SP_CA_UPD_JAQL532_700000;
 /* GOLDENGATE_DDL_REPLICATION */
/

