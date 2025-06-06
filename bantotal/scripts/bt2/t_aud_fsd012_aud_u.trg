CREATE OR REPLACE TRIGGER T_AUD_FSD012_AUD_U
  AFTER UPDATE ON FSD012
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


  INSERT INTO AUD_FSD012_AUDIT
    (AUD_new_AOCTA,
     AUD_new_AOMDA,
     AUD_new_AOMOD,
     AUD_new_AOOPER,
     AUD_new_AOPAP,
     AUD_new_AOSBOP,
     AUD_new_AOSUC,
     AUD_new_AOTOPE,
     AUD_new_D012CD,
     AUD_new_D012CO,
     AUD_new_D012FC,
     AUD_new_D012MO,
     AUD_new_D012OR,
     AUD_new_D012RE,
     AUD_new_D012SB,
     AUD_new_D012SU,
     AUD_new_D012TR,
     AUD_new_EVARB,
     AUD_new_EVARB1,
     AUD_new_EVCAP,
     AUD_new_EVCD01,
     AUD_new_EVCD02,
     AUD_new_EVCORR,
     AUD_new_EVFVAL,
     AUD_new_EVFVTO,
     AUD_new_EVIMP,
     AUD_new_EVINT,
     AUD_new_EVINTC,
     AUD_new_EVINV,
     AUD_new_EVMD,
     AUD_new_EVMD1,
     AUD_new_EVMOR,
     AUD_new_EVMORC,
     AUD_new_EVPER,
     AUD_new_EVPRE,
     AUD_new_EVPRE1,
     AUD_new_EVSCAP,
     AUD_new_EVSINT,
     AUD_new_EVSMOR,
     AUD_new_EVTASA,
     AUD_new_EVTCBI,
     AUD_new_EVTCBI1,
     AUD_new_EVTIPO,
     AUD_new_EVTTAS,
     AUD_new_PGCOD,
     AUD_old_AOCTA,
     AUD_old_AOMDA,
     AUD_old_AOMOD,
     AUD_old_AOOPER,
     AUD_old_AOPAP,
     AUD_old_AOSBOP,
     AUD_old_AOSUC,
     AUD_old_AOTOPE,
     AUD_old_D012CD,
     AUD_old_D012CO,
     AUD_old_D012FC,
     AUD_old_D012MO,
     AUD_old_D012OR,
     AUD_old_D012RE,
     AUD_old_D012SB,
     AUD_old_D012SU,
     AUD_old_D012TR,
     AUD_old_EVARB,
     AUD_old_EVARB1,
     AUD_old_EVCAP,
     AUD_old_EVCD01,
     AUD_old_EVCD02,
     AUD_old_EVCORR,
     AUD_old_EVFVAL,
     AUD_old_EVFVTO,
     AUD_old_EVIMP,
     AUD_old_EVINT,
     AUD_old_EVINTC,
     AUD_old_EVINV,
     AUD_old_EVMD,
     AUD_old_EVMD1,
     AUD_old_EVMOR,
     AUD_old_EVMORC,
     AUD_old_EVPER,
     AUD_old_EVPRE,
     AUD_old_EVPRE1,
     AUD_old_EVSCAP,
     AUD_old_EVSINT,
     AUD_old_EVSMOR,
     AUD_old_EVTASA,
     AUD_old_EVTCBI,
     AUD_old_EVTCBI1,
     AUD_old_EVTIPO,
     AUD_old_EVTTAS,
     AUD_old_PGCOD,
     AUD_FSD012_GuidKey,
     AUD_FSD012_UOn,
     AUD_FSD012_UT,
     AUD_FSD012_UBR,
     AUD_FSD012_UBC,
     AUD_FSD012_UBT,
     AUD_FSD012_UBU,
     AUD_FSD012_UBA,
     AUD_FSD012_UBS,
     AUD_FSD012_UBP,
     AUD_FSD012_UBM,
     AUD_FSD012_UAs)
  VALUES
    (:new.AOCTA,
     :new.AOMDA,
     :new.AOMOD,
     :new.AOOPER,
     :new.AOPAP,
     :new.AOSBOP,
     :new.AOSUC,
     :new.AOTOPE,
     :new.D012CD,
     :new.D012CO,
     :new.D012FC,
     :new.D012MO,
     :new.D012OR,
     :new.D012RE,
     :new.D012SB,
     :new.D012SU,
     :new.D012TR,
     :new.EVARB,
     :new.EVARB1,
     :new.EVCAP,
     :new.EVCD01,
     :new.EVCD02,
     :new.EVCORR,
     :new.EVFVAL,
     :new.EVFVTO,
     :new.EVIMP,
     :new.EVINT,
     :new.EVINTC,
     :new.EVINV,
     :new.EVMD,
     :new.EVMD1,
     :new.EVMOR,
     :new.EVMORC,
     :new.EVPER,
     :new.EVPRE,
     :new.EVPRE1,
     :new.EVSCAP,
     :new.EVSINT,
     :new.EVSMOR,
     :new.EVTASA,
     :new.EVTCBI,
     :new.EVTCBI1,
     :new.EVTIPO,
     :new.EVTTAS,
     :new.PGCOD,
     :old.AOCTA,
     :old.AOMDA,
     :old.AOMOD,
     :old.AOOPER,
     :old.AOPAP,
     :old.AOSBOP,
     :old.AOSUC,
     :old.AOTOPE,
     :old.D012CD,
     :old.D012CO,
     :old.D012FC,
     :old.D012MO,
     :old.D012OR,
     :old.D012RE,
     :old.D012SB,
     :old.D012SU,
     :old.D012TR,
     :old.EVARB,
     :old.EVARB1,
     :old.EVCAP,
     :old.EVCD01,
     :old.EVCD02,
     :old.EVCORR,
     :old.EVFVAL,
     :old.EVFVTO,
     :old.EVIMP,
     :old.EVINT,
     :old.EVINTC,
     :old.EVINV,
     :old.EVMD,
     :old.EVMD1,
     :old.EVMOR,
     :old.EVMORC,
     :old.EVPER,
     :old.EVPRE,
     :old.EVPRE1,
     :old.EVSCAP,
     :old.EVSINT,
     :old.EVSMOR,
     :old.EVTASA,
     :old.EVTCBI,
     :old.EVTCBI1,
     :old.EVTIPO,
     :old.EVTTAS,
     :old.PGCOD,
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

END T_AUD_FSD012_AUD_U;
/

