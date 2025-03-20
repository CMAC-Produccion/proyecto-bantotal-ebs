CREATE OR REPLACE TRIGGER TG_JAQZ202_INS
  AFTER INSERT ON JAQZ202
  FOR EACH ROW
DECLARE
VHOST_NAME VARCHAR2(100);
BEGIN
  
  --chernandez 13/07/2017
  /*SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
  if UPPER(vhost_name) in ('SC01ZDBADM010101',
                           'SC01ZDBADM020101',
                           'BTRAC4051') then
    sys.sp_sy_enviamail('activaciontar@cajaarequipa.pe', --de
                        'chernandez@cajaarequipa.pe', --para                        
                        'TG_JAQZ202_INS1', --titulo
                        sys_context('USERENV', 'DB_NAME') || '-' ||
                        sys_context('USERENV', 'INSTANCE_NAME') || '-' ||
                        'ESTADO:' || :new.JAQZ202EST || '-' || 
                        'TARJETA:' || :new.JAQZ202TAR || '-' ||
                        'USUARIO:' || :new.JAQZ202USU);
    sys.sp_sy_enviamail('activaciontar@cajaarequipa.pe', --de
                        'lcarpio@cajaarequipa.pe', --para                        
                        'TG_JAQZ202_INS1', --titulo
                        sys_context('USERENV', 'DB_NAME') || '-' ||
                        sys_context('USERENV', 'INSTANCE_NAME') || '-' ||
                        'ESTADO:' || :new.JAQZ202EST || '-' || 
                        'TARJETA:' || :new.JAQZ202TAR || '-' ||
                        'USUARIO:' || :new.JAQZ202USU);
  End If;*/
  If :new.JAQZ202EST = 'A' then
    SP_CA_ACTIVACION_TARJETA(:new.JAQZ202TAR,:new.JAQZ202USU);
  End If;
END TG_JAQZ202_INS;
/

