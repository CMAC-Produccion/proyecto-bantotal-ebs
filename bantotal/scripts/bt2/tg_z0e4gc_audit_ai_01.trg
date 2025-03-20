CREATE OR REPLACE TRIGGER TG_Z0E4GC_AUDIT_AI_01
  AFTER INSERT ON Z0E4GC
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
    ( aud_new_z0e4gcapl,
      aud_new_z0e4gcban,
      aud_new_z0e4gccor,
      aud_new_z0e4gcco2,
      aud_new_z0e4gcter,
      aud_new_z0e4gctar,
      aud_new_z0e4gcfec,
      aud_new_z0e4gchor,
      aud_new_z0e4gcesm,
      aud_new_z0e4gcorj,
      aud_new_z0e4gcfne,
      aud_new_z0e4gctop,
      aud_new_z0e4gcdpg,
      aud_new_z0e4gcdsu,
      aud_new_z0e4gcdmd,
      aud_new_z0e4gcdmo,
      aud_new_z0e4gcdpa,
      aud_new_z0e4gcdct,
      aud_new_z0e4gcdsc,
      aud_new_z0e4gcdto,
      aud_new_z0e4gcdop,
      aud_new_z0e4gccpg,
      aud_new_z0e4gcsu,
      aud_new_z0e4gccmd,
      aud_new_z0e4gccmo,
      aud_new_z0e4gccpa,
      aud_new_z0e4gccct,
      aud_new_z0e4gccsc,
      aud_new_z0e4gccto,
      aud_new_z0e4gccop,
      aud_new_z0e4gcimd,
      aud_new_z0e4gcimc,
      aud_new_z0e4gcsdd,
      aud_new_z0e4gccot,
      aud_new_z0e4gcmda,
      aud_new_z0e4gcemp,
      aud_new_z0e4gcsuc,
      aud_new_z0e4gcmod,
      aud_new_z0e4gctrn,
      aud_new_z0e4gcrel,
      aud_new_z0e4gcest,
      aud_new_z0e4gctxt,
      aud_new_z0e4gcmnc,
      aud_new_z0e4gccnl,
      aud_new_z0e4gcope,
      aud_new_z0e4gcvar,
      aud_new_z0e4gcfsv,
      aud_new_z0e4gchsv,
      aud_new_z0e4gcrsv,
      aud_new_z0e4gcnsb,
      aud_new_z0e4gcori,
      aud_new_z0e4gctdd,
      aud_new_z0e4gcnse,
      aud_new_z0e4gcred,
      aud_new_z0e4gcfim,
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
    ( :new.z0e4gcapl,
      :new.z0e4gcban,
      :new.z0e4gccor,
      :new.z0e4gcco2,
      :new.z0e4gcter,
      :new.z0e4gctar,
      :new.z0e4gcfec,
      :new.z0e4gchor,
      :new.z0e4gcesm,
      :new.z0e4gcorj,
      :new.z0e4gcfne,
      :new.z0e4gctop,
      :new.z0e4gcdpg,
      :new.z0e4gcdsu,
      :new.z0e4gcdmd,
      :new.z0e4gcdmo,
      :new.z0e4gcdpa,
      :new.z0e4gcdct,
      :new.z0e4gcdsc,
      :new.z0e4gcdto,
      :new.z0e4gcdop,
      :new.z0e4gccpg,
      :new.z0e4gcsu,
      :new.z0e4gccmd,
      :new.z0e4gccmo,
      :new.z0e4gccpa,
      :new.z0e4gccct,
      :new.z0e4gccsc,
      :new.z0e4gccto,
      :new.z0e4gccop,
      :new.z0e4gcimd,
      :new.z0e4gcimc,
      :new.z0e4gcsdd,
      :new.z0e4gccot,
      :new.z0e4gcmda,
      :new.z0e4gcemp,
      :new.z0e4gcsuc,
      :new.z0e4gcmod,
      :new.z0e4gctrn,
      :new.z0e4gcrel,
      :new.z0e4gcest,
      :new.z0e4gctxt,
      :new.z0e4gcmnc,
      :new.z0e4gccnl,
      :new.z0e4gcope,
      :new.z0e4gcvar,
      :new.z0e4gcfsv,
      :new.z0e4gchsv,
      :new.z0e4gcrsv,
      :new.z0e4gcnsb,
      :new.z0e4gcori,
      :new.z0e4gctdd,
      :new.z0e4gcnse,
      :new.z0e4gcred,
      :new.z0e4gcfim,
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
      'I');
END TG_Z0E4GC_AUDIT_AI_01;
/

