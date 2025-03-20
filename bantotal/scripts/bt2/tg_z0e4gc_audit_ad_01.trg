CREATE OR REPLACE TRIGGER TG_Z0E4GC_AUDIT_AD_01
  AFTER DELETE ON Z0E4GC
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
  INSERT INTO Z0E4GC_AUDIT
    ( aud_old_z0e4gcapl,
      aud_old_z0e4gcban,
      aud_old_z0e4gccor,
      aud_old_z0e4gcco2,
      aud_old_z0e4gcter,
      aud_old_z0e4gctar,
      aud_old_z0e4gcfec,
      aud_old_z0e4gchor,
      aud_old_z0e4gcesm,
      aud_old_z0e4gcorj,
      aud_old_z0e4gcfne,
      aud_old_z0e4gctop,
      aud_old_z0e4gcdpg,
      aud_old_z0e4gcdsu,
      aud_old_z0e4gcdmd,
      aud_old_z0e4gcdmo,
      aud_old_z0e4gcdpa,
      aud_old_z0e4gcdct,
      aud_old_z0e4gcdsc,
      aud_old_z0e4gcdto,
      aud_old_z0e4gcdop,
      aud_old_z0e4gccpg,
      aud_old_z0e4gcsu,
      aud_old_z0e4gccmd,
      aud_old_z0e4gccmo,
      aud_old_z0e4gccpa,
      aud_old_z0e4gccct,
      aud_old_z0e4gccsc,
      aud_old_z0e4gccto,
      aud_old_z0e4gccop,
      aud_old_z0e4gcimd,
      aud_old_z0e4gcimc,
      aud_old_z0e4gcsdd,
      aud_old_z0e4gccot,
      aud_old_z0e4gcmda,
      aud_old_z0e4gcemp,
      aud_old_z0e4gcsuc,
      aud_old_z0e4gcmod,
      aud_old_z0e4gctrn,
      aud_old_z0e4gcrel,
      aud_old_z0e4gcest,
      aud_old_z0e4gctxt,
      aud_old_z0e4gcmnc,
      aud_old_z0e4gccnl,
      aud_old_z0e4gcope,
      aud_old_z0e4gcvar,
      aud_old_z0e4gcfsv,
      aud_old_z0e4gchsv,
      aud_old_z0e4gcrsv,
      aud_old_z0e4gcnsb,
      aud_old_z0e4gcori,
      aud_old_z0e4gctdd,
      aud_old_z0e4gcnse,
      aud_old_z0e4gcred,
      aud_old_z0e4gcfim,
      aud_Z0E4GC_guidkey,
      aud_Z0E4GC_uon,
      aud_Z0E4GC_ut ,
      aud_Z0E4GC_ubr,
      aud_Z0E4GC_ubc,
      aud_Z0E4GC_ubt,
      aud_Z0E4GC_ubu,
      aud_Z0E4GC_uba,
      aud_Z0E4GC_ubs,
      aud_Z0E4GC_ubp,
      aud_Z0E4GC_ubm,
      aud_Z0E4GC_uas)
  VALUES
    (:old.z0e4gcapl,
     :old.z0e4gcban,
     :old.z0e4gccor,
     :old.z0e4gcco2,
     :old.z0e4gcter,
     :old.z0e4gctar,
     :old.z0e4gcfec,
     :old.z0e4gchor,
     :old.z0e4gcesm,
     :old.z0e4gcorj,
     :old.z0e4gcfne,
     :old.z0e4gctop,
     :old.z0e4gcdpg,
     :old.z0e4gcdsu,
     :old.z0e4gcdmd,
     :old.z0e4gcdmo,
     :old.z0e4gcdpa,
     :old.z0e4gcdct,
     :old.z0e4gcdsc,
     :old.z0e4gcdto,
     :old.z0e4gcdop,
     :old.z0e4gccpg,
     :old.z0e4gcsu,
     :old.z0e4gccmd,
     :old.z0e4gccmo,
     :old.z0e4gccpa,
     :old.z0e4gccct,
     :old.z0e4gccsc,
     :old.z0e4gccto,
     :old.z0e4gccop,
     :old.z0e4gcimd,
     :old.z0e4gcimc,
     :old.z0e4gcsdd,
     :old.z0e4gccot,
     :old.z0e4gcmda,
     :old.z0e4gcemp,
     :old.z0e4gcsuc,
     :old.z0e4gcmod,
     :old.z0e4gctrn,
     :old.z0e4gcrel,
     :old.z0e4gcest,
     :old.z0e4gctxt,
     :old.z0e4gcmnc,
     :old.z0e4gccnl,
     :old.z0e4gcope,
     :old.z0e4gcvar,
     :old.z0e4gcfsv,
     :old.z0e4gchsv,
     :old.z0e4gcrsv,
     :old.z0e4gcnsb,
     :old.z0e4gcori,
     :old.z0e4gctdd,
     :old.z0e4gcnse,
     :old.z0e4gcred,
     :old.z0e4gcfim,
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
     'D');
END TG_Z0E4GC_AUDIT_AD_01;
/

