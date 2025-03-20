CREATE OR REPLACE TRIGGER T_AUD_FSD120_MAIL_U
  AFTER UPDATE ON FSD120
  FOR EACH ROW
DECLARE
  RequestNumber     VARCHAR2(50);
  UserName          VARCHAR2(50);
  WrkstName         VARCHAR2(50);
  Server            VARCHAR2(50);
  Application       VARCHAR2(50);
  ProgramName       VARCHAR2(50);
  TransactionNumber VARCHAR2(50);
  ConnectionId      VARCHAR2(50);
  ExistConData      NUMBER;
BEGIN
  SELECT sys_context('USERENV', 'SID') INTO ConnectionId FROM dual;
  SELECT COUNT(*)
    INTO ExistConData
    FROM DBA_OBJECTS
   WHERE OWNER = sys_context('userenv', 'current_schema')
     AND OBJECT_TYPE = 'TABLE'
     AND OBJECT_NAME = 'CONDATA';
  IF ExistConData > 0 THEN
    SELECT MAX(Value)
      INTO RequestNumber
      FROM CONDATA
     WHERE Data = 'REQUESTID';

    SELECT MAX(Value) INTO UserName FROM CONDATA WHERE Data = 'USERID';
    SELECT MAX(Value) INTO WrkstName FROM CONDATA WHERE Data = 'WRKST';
    SELECT MAX(Value) INTO Server FROM CONDATA WHERE Data = 'SERVER';
    SELECT MAX(Value)
      INTO Application
      FROM CONDATA
     WHERE Data = 'APPLICATION';
    SELECT MAX(Value) INTO ProgramName FROM CONDATA WHERE Data = 'PROGRAM';
  END IF;
  RequestNumber     := COALESCE(RequestNumber, '-1');
  TransactionNumber := COALESCE(TransactionNumber, '-1');
  ConnectionId      := COALESCE(ConnectionId, '-1');
  SELECT COALESCE(UserName,
                  sys_context('USERENV', 'SESSION_USER'),
                  'NOTDEFINED')
    INTO UserName
    FROM dual;
  SELECT COALESCE(WrkstName, sys_context('USERENV', 'HOST'), 'NOTDEFINED')
    INTO WrkstName
    FROM dual;
  SELECT COALESCE(Server,
                  sys_context('USERENV', 'SERVER_HOST'),
                  'NOTDEFINED')
    INTO Server
    FROM dual;
  SELECT COALESCE(Application,
                  sys_context('USERENV', 'ACTION'),
                  'NOTDEFINED')
    INTO Application
    FROM dual;
  SELECT COALESCE(ProgramName,
                  sys_context('USERENV', 'ACTION'),
                  'NOTDEFINED') INTO ProgramName
    FROM dual;


      sys.SP_SY_ENVIAMAIL('csosa@cajaarequipa.pe','csosa@cajaarequipa.pe',
                      'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                      'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                      'UPDATE A TABLA FSD120',
                      'El usuario ' || UserName || ' ha cambiado la pizarra '||:new.TCCOD ||
                      ' el día '|| :new.TCFCH ||' a horas '||:new.TCHOR||' con los valores TCCPA: '||:new.TCCPA ||' y TCVTA:' || :new.TCVTA );
                      
      sys.SP_SY_ENVIAMAIL('ivargas@cajaarequipa.pe','ivargas@cajaarequipa.pe',
                      'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                      'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                      'UPDATE A TABLA FSD120',
                      'El usuario ' || UserName || ' ha cambiado la pizarra '||:new.TCCOD ||
                      ' el día '|| :new.TCFCH ||' a horas '||:new.TCHOR||' con los valores TCCPA: '||:new.TCCPA ||' y TCVTA:' || :new.TCVTA);
                      
      sys.SP_SY_ENVIAMAIL('lcarpio@cajaarequipa.pe','lcarpio@cajaarequipa.pe',
                      'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                      'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                      'UPDATE A TABLA FSD120',
                      'El usuario ' || UserName || ' ha cambiado la pizarra '||:new.TCCOD ||
                      ' el día '|| :new.TCFCH ||' a horas '||:new.TCHOR||' con los valores TCCPA: '||:new.TCCPA ||' y TCVTA:' || :new.TCVTA);
              
      

   /* INTO ProgramName
    FROM dual;
  INSERT INTO BANTPROD.AUD_FSD120_AUDIT
    (AUD_new_TCARBCNT,
     AUD_new_TCARBCPA,
     AUD_new_TCARBTOL,
     AUD_new_TCARBVTA,
     AUD_new_TCCOD,
     AUD_new_TCCPA,
     AUD_new_TCFCH,
     AUD_new_TCFHINV,
     AUD_new_TCHOR,
     AUD_new_TCIMP,
     AUD_new_TCMDA,
     AUD_new_TCTOLC,
     AUD_new_TCTOLV,
     AUD_new_TCVTA,
     AUD_old_TCARBCNT,
     AUD_old_TCARBCPA,
     AUD_old_TCARBTOL,
     AUD_old_TCARBVTA,
     AUD_old_TCCOD,
     AUD_old_TCCPA,
     AUD_old_TCFCH,
     AUD_old_TCFHINV,
     AUD_old_TCHOR,
     AUD_old_TCIMP,
     AUD_old_TCMDA,
     AUD_old_TCTOLC,
     AUD_old_TCTOLV,
     AUD_old_TCVTA,
     AUD_FSD120_GuidKey,
     AUD_FSD120_UOn,
     AUD_FSD120_UT,
     AUD_FSD120_UBR,
     AUD_FSD120_UBC,
     AUD_FSD120_UBT,
     AUD_FSD120_UBU,
     AUD_FSD120_UBA,
     AUD_FSD120_UBS,
     AUD_FSD120_UBP,
     AUD_FSD120_UBM,
     AUD_FSD120_UAs)
  VALUES
    (:new.TCARBCNT,
     :new.TCARBCPA,
     :new.TCARBTOL,
     :new.TCARBVTA,
     :new.TCCOD,
     :new.TCCPA,
     :new.TCFCH,
     :new.TCFHINV,
     :new.TCHOR,
     :new.TCIMP,
     :new.TCMDA,
     :new.TCTOLC,
     :new.TCTOLV,
     :new.TCVTA,
     :old.TCARBCNT,
     :old.TCARBCPA,
     :old.TCARBTOL,
     :old.TCARBVTA,
     :old.TCCOD,
     :old.TCCPA,
     :old.TCFCH,
     :old.TCFHINV,
     :old.TCHOR,
     :old.TCIMP,
     :old.TCMDA,
     :old.TCTOLC,
     :old.TCTOLV,
     :old.TCVTA,
     SYS_GUID(),
     SYSTIMESTAMP,
     SYSTIMESTAMP,
     RequestNumber,
     ConnectionId,
     TransactionNumber,
     UserName,
     Application,
     Server,
     ProgramName,
     WrkstName,
     'U')*/ 
     
END T_AUD_FSD120_MAIL_U;
/

