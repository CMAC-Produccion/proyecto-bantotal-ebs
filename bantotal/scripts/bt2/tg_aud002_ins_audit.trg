CREATE OR REPLACE TRIGGER "TG_AUD002_INS_AUDIT"
  BEFORE INSERT ON "BANTPROD"."AUD002"
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
     pk)
  VALUES
    ('INSERT',
     'AUD002',
     'TABLE',
     'BANTPROD',
     SUBSTR(SYS.LOGIN_USER, 1, 30),
     SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,60),
     SYSDATE,
     SUBSTR(SYS_CONTEXT('USERENV', 'HOST'),1,64),
     SUBSTR(SYS_CONTEXT('USERENV', 'OS_USER'),1,30),
     SUBSTR(SYS_CONTEXT('USERENV', 'IP_ADDRESS'),1,15),
     to_char(:new.audgrpnam||'-'||:new.audtblnam||'-'||:new.audtblena||'-'|| :new.audtblins||'-'|| :new.audtblupd||'-'|| :new.audtbldlt||'-'|| :new.audtbltbl||'-'|| :new.audtblsts)
     );
  select HOST_NAME INTO V_HOSTNAME from v$instance;     
  sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe',
                                       'ehidalgom@cajaarequipa.pe',
                                       'Nueva Auditoría Habilitada en Bantotal para '||:new.audtblnam || ' ' ||sys_context('USERENV', 'DB_NAME')||' HOST '||V_HOSTNAME,
                                       'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||
                                       'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||
                                       'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS')
                                       );
                                       
  sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe',
                                       'kcabrerac@cajaarequipa.pe',
                                       'Nueva Auditoría Habilitada en Bantotal para '||:new.audtblnam || ' ' ||sys_context('USERENV', 'DB_NAME')||' HOST '||V_HOSTNAME,
                                       'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||
                                       'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||
                                       'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS')
                                       );
                                                                                                  
END TG_AUD002_INS_AUDIT;
 /* GOLDENGATE_DDL_REPLICATION */
/

