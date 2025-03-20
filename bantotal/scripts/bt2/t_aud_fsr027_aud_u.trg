CREATE OR REPLACE TRIGGER T_AUD_FSR027_AUD_U
  AFTER UPDATE ON FSR027
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
                  'NOTDEFINED')
    INTO ProgramName
    FROM dual;


IF(
:old.ctnro = :new.ctnro and
:old.modulo= :new.modulo and
:old.moneda= :new.moneda and
:old.papel = :new.papel and
:old.pgcod = :new.pgcod and
:old.tpfdes= :new.tpfdes and
:old.tpizar= :new.tpizar and
:old.tpmto = :new.tpmto and
:old.tppzo = :new.tppzo and
:old.tptasa= :new.tptasa) THEN
  null;
ELSE
  INSERT INTO BANTPROD.AUD_FSR027_AUDIT
    (AUD_new_CTNRO,
     AUD_new_MODULO,
     AUD_new_MONEDA,
     AUD_new_PAPEL,
     AUD_new_PGCOD,
     AUD_new_TPFDES,
     AUD_new_TPIZAR,
     AUD_new_TPMTO,
     AUD_new_TPPZO,
     AUD_new_TPTASA,
     AUD_old_CTNRO,
     AUD_old_MODULO,
     AUD_old_MONEDA,
     AUD_old_PAPEL,
     AUD_old_PGCOD,
     AUD_old_TPFDES,
     AUD_old_TPIZAR,
     AUD_old_TPMTO,
     AUD_old_TPPZO,
     AUD_old_TPTASA,
     AUD_FSR027_GuidKey,
     AUD_FSR027_UOn,
     AUD_FSR027_UT,
     AUD_FSR027_UBR,
     AUD_FSR027_UBC,
     AUD_FSR027_UBT,
     AUD_FSR027_UBU,
     AUD_FSR027_UBA,
     AUD_FSR027_UBS,
     AUD_FSR027_UBP,
     AUD_FSR027_UBM,
     AUD_FSR027_UAs)
  VALUES
    (:new.CTNRO,
     :new.MODULO,
     :new.MONEDA,
     :new.PAPEL,
     :new.PGCOD,
     :new.TPFDES,
     :new.TPIZAR,
     :new.TPMTO,
     :new.TPPZO,
     :new.TPTASA,
     :old.CTNRO,
     :old.MODULO,
     :old.MONEDA,
     :old.PAPEL,
     :old.PGCOD,
     :old.TPFDES,
     :old.TPIZAR,
     :old.TPMTO,
     :old.TPPZO,
     :old.TPTASA,
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
     'U');
END IF;
END T_AUD_FSR027_AUD_U;
/

