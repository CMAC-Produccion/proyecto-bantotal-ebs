CREATE OR REPLACE TRIGGER "TG_AUD002_DEL_AUDIT"
  BEFORE DELETE ON "BANTPROD"."AUD002"
  FOR EACH ROW
DECLARE
  V_HOSTNAME VARCHAR(100);
BEGIN
  INSERT INTO SYStabrep.AUDITA_TABLAS
    (EVENTO,
     OBJETO,
     TIP_OBJETO,
     OWN_OBJETO,
     QUIEN_LOHIZO,
     CLIENT_IDENT,
     FECHA,
     MAQUINA,
     USUARIO_SO,
     IP,
     PK)
  VALUES
    ('DELETE',
     'AUD002',
     'TABLE',
     'BANTPROD',
     SUBSTR(SYS.LOGIN_USER, 1, 30),
     SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,60),
     SYSDATE,
     SUBSTR(SYS_CONTEXT('USERENV', 'HOST'),1,64),
     SUBSTR(SYS_CONTEXT('USERENV', 'OS_USER'),1,30),
     SUBSTR(SYS_CONTEXT('USERENV', 'IP_ADDRESS'),1,15),
     to_char(:old.audgrpnam||'-'||:old.audtblnam||'-'||:old.audtblena||'-'|| :old.audtblins||'-'|| :old.audtblupd||'-'|| :old.audtbldlt||'-'|| :old.audtbltbl||'-'|| :old.audtblsts)
     );
     
  select HOST_NAME INTO V_HOSTNAME from v$instance;     
  sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe',
                                       'ehidalgom@cajaarequipa.pe',
                                       'Auditoría Eliminada en Bantotal para '||:old.audtblnam || ' ' ||sys_context('USERENV', 'DB_NAME')||' HOST '||V_HOSTNAME,
                                       'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||
                                       'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||
                                       'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS')||CHR(13)||
                                       'Revisar AUDITA_TABLAS'
                                       );
                                       
  sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe',
                                       'kcabrerac@cajaarequipa.pe',
                                       'Auditoría Eliminada en Bantotal para '||:old.audtblnam || ' ' ||sys_context('USERENV', 'DB_NAME')||' HOST '||V_HOSTNAME,
                                       'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||
                                       'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||
                                       'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS')||CHR(13)||
                                       'Revisar AUDITA_TABLAS'
                                       );
END TG_AUD002_DEL_AUDIT;
 /* GOLDENGATE_DDL_REPLICATION */
/

