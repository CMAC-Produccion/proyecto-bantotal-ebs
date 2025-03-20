CREATE OR REPLACE TRIGGER T_AUD_X054023_AUD_U
  AFTER UPDATE ON X054023
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

IF (
      :old.xllpgcod=:new.xllpgcod and
      :old.xllaomod=:new.xllaomod and
      :old.xllaosuc=:new.xllaosuc and
      :old.xllaomda=:new.xllaomda and
      :old.xllaopap=:new.xllaopap and
      :old.xllaocta=:new.xllaocta and
      :old.xllaooper=:new.xllaooper and
      :old.xllaosbop=:new.xllaosbop and
      :old.xllaotop=:new.xllaotop and
      :old.xllfvalor=:new.xllfvalor and
      :old.xllcapital=:new.xllcapital and
      :old.xllfprimpa=:new.xllfprimpa and
      :old.xllcantcuo=:new.xllcantcuo and
      :old.xllperiodo=:new.xllperiodo and
      :old.xlltipopre=:new.xlltipopre and
      :old.xlltipodia=:new.xlltipodia and
      :old.xlltipotas=:new.xlltipotas and
      :old.xlltasap=:new.xlltasap and
      :old.xllgradper=:new.xllgradper and
      :old.xllgradpor=:new.xllgradpor and
      :old.xllgradimp=:new.xllgradimp and
      :old.xlltipoano=:new.xlltipoano and
      :old.xlltipdiap=:new.xlltipdiap and
      :old.xllpcltcod=:new.xllpcltcod and
      :old.xllpclplus=:new.xllpclplus and
      :old.xllpcldrev=:new.xllpcldrev and
      :old.xlltferp=:new.xlltferp and
      :old.xllcntcuoi=:new.xllcntcuoi and
      :old.xllfpripag=:new.xllfpripag and
      :old.xllplazo=:new.xllplazo and
      :old.xllfvto=:new.xllfvto and
      :old.xllmodocal=:new.xllmodocal and
      :old.xllgracfij=:new.xllgracfij and
      :old.xllaux1=:new.xllaux1 and
      :old.xllaux2=:new.xllaux2 and
      :old.xllaux3=:new.xllaux3 and
      :old.xllciud=:new.xllciud and
      :old.xllcapliq=:new.xllcapliq and
      :old.xllmedico=:new.xllmedico and
      :old.xllfinanc=:new.xllfinanc and
      :old.xlltasaej=:new.xlltasaej and
      :old.xllvalcan=:new.xllvalcan and
      :old.xllvalcuo=:new.xllvalcuo and
      :old.xllcapfin=:new.xllcapfin and
      :old.xllimpu=:new.xllimpu and
      :old.xllaux4=:new.xllaux4 and
      :old.xllaux5=:new.xllaux5 and
      :old.xllredon=:new.xllredon and
      :old.xllaux6=:new.xllaux6 and
      :old.xllprecio=:new.xllprecio
  ) THEN
  null;
ELSE
  INSERT INTO AUD_X054023_AUDIT
    (AUD_new_XLLAOCTA,
     AUD_new_XLLAOMDA,
     AUD_new_XLLAOMOD,
     AUD_new_XLLAOOPER,
     AUD_new_XLLAOPAP,
     AUD_new_XLLAOSBOP,
     AUD_new_XLLAOSUC,
     AUD_new_XLLAOTOP,
     AUD_new_XLLAUX1,
     AUD_new_XLLAUX2,
     AUD_new_XLLAUX3,
     AUD_new_XLLAUX4,
     AUD_new_XLLAUX5,
     AUD_new_XLLAUX6,
     AUD_new_XLLCANTCUO,
     AUD_new_XLLCAPFIN,
     AUD_new_XLLCAPITAL,
     AUD_new_XLLCAPLIQ,
     AUD_new_XLLCIUD,
     AUD_new_XLLCNTCUOI,
     AUD_new_XLLFINANC,
     AUD_new_XLLFPRIMPA,
     AUD_new_XLLFPRIPAG,
     AUD_new_XLLFVALOR,
     AUD_new_XLLFVTO,
     AUD_new_XLLGRACFIJ,
     AUD_new_XLLGRADIMP,
     AUD_new_XLLGRADPER,
     AUD_new_XLLGRADPOR,
     AUD_new_XLLIMPU,
     AUD_new_XLLMEDICO,
     AUD_new_XLLMODOCAL,
     AUD_new_XLLPCLDREV,
     AUD_new_XLLPCLPLUS,
     AUD_new_XLLPCLTCOD,
     AUD_new_XLLPERIODO,
     AUD_new_XLLPGCOD,
     AUD_new_XLLPLAZO,
     AUD_new_XLLPRECIO,
     AUD_new_XLLREDON,
     AUD_new_XLLTASAEJ,
     AUD_new_XLLTASAP,
     AUD_new_XLLTFERP,
     AUD_new_XLLTIPDIAP,
     AUD_new_XLLTIPOANO,
     AUD_new_XLLTIPODIA,
     AUD_new_XLLTIPOPRE,
     AUD_new_XLLTIPOTAS,
     AUD_new_XLLVALCAN,
     AUD_new_XLLVALCUO,
     AUD_old_XLLAOCTA,
     AUD_old_XLLAOMDA,
     AUD_old_XLLAOMOD,
     AUD_old_XLLAOOPER,
     AUD_old_XLLAOPAP,
     AUD_old_XLLAOSBOP,
     AUD_old_XLLAOSUC,
     AUD_old_XLLAOTOP,
     AUD_old_XLLAUX1,
     AUD_old_XLLAUX2,
     AUD_old_XLLAUX3,
     AUD_old_XLLAUX4,
     AUD_old_XLLAUX5,
     AUD_old_XLLAUX6,
     AUD_old_XLLCANTCUO,
     AUD_old_XLLCAPFIN,
     AUD_old_XLLCAPITAL,
     AUD_old_XLLCAPLIQ,
     AUD_old_XLLCIUD,
     AUD_old_XLLCNTCUOI,
     AUD_old_XLLFINANC,
     AUD_old_XLLFPRIMPA,
     AUD_old_XLLFPRIPAG,
     AUD_old_XLLFVALOR,
     AUD_old_XLLFVTO,
     AUD_old_XLLGRACFIJ,
     AUD_old_XLLGRADIMP,
     AUD_old_XLLGRADPER,
     AUD_old_XLLGRADPOR,
     AUD_old_XLLIMPU,
     AUD_old_XLLMEDICO,
     AUD_old_XLLMODOCAL,
     AUD_old_XLLPCLDREV,
     AUD_old_XLLPCLPLUS,
     AUD_old_XLLPCLTCOD,
     AUD_old_XLLPERIODO,
     AUD_old_XLLPGCOD,
     AUD_old_XLLPLAZO,
     AUD_old_XLLPRECIO,
     AUD_old_XLLREDON,
     AUD_old_XLLTASAEJ,
     AUD_old_XLLTASAP,
     AUD_old_XLLTFERP,
     AUD_old_XLLTIPDIAP,
     AUD_old_XLLTIPOANO,
     AUD_old_XLLTIPODIA,
     AUD_old_XLLTIPOPRE,
     AUD_old_XLLTIPOTAS,
     AUD_old_XLLVALCAN,
     AUD_old_XLLVALCUO,
     AUD_X054023_GuidKey,
     AUD_X054023_UOn,
     AUD_X054023_UT,
     AUD_X054023_UBR,
     AUD_X054023_UBC,
     AUD_X054023_UBT,
     AUD_X054023_UBU,
     AUD_X054023_UBA,
     AUD_X054023_UBS,
     AUD_X054023_UBP,
     AUD_X054023_UBM,
     AUD_X054023_UAs)
  VALUES
    (:new.XLLAOCTA,
     :new.XLLAOMDA,
     :new.XLLAOMOD,
     :new.XLLAOOPER,
     :new.XLLAOPAP,
     :new.XLLAOSBOP,
     :new.XLLAOSUC,
     :new.XLLAOTOP,
     :new.XLLAUX1,
     :new.XLLAUX2,
     :new.XLLAUX3,
     :new.XLLAUX4,
     :new.XLLAUX5,
     :new.XLLAUX6,
     :new.XLLCANTCUO,
     :new.XLLCAPFIN,
     :new.XLLCAPITAL,
     :new.XLLCAPLIQ,
     :new.XLLCIUD,
     :new.XLLCNTCUOI,
     :new.XLLFINANC,
     :new.XLLFPRIMPA,
     :new.XLLFPRIPAG,
     :new.XLLFVALOR,
     :new.XLLFVTO,
     :new.XLLGRACFIJ,
     :new.XLLGRADIMP,
     :new.XLLGRADPER,
     :new.XLLGRADPOR,
     :new.XLLIMPU,
     :new.XLLMEDICO,
     :new.XLLMODOCAL,
     :new.XLLPCLDREV,
     :new.XLLPCLPLUS,
     :new.XLLPCLTCOD,
     :new.XLLPERIODO,
     :new.XLLPGCOD,
     :new.XLLPLAZO,
     :new.XLLPRECIO,
     :new.XLLREDON,
     :new.XLLTASAEJ,
     :new.XLLTASAP,
     :new.XLLTFERP,
     :new.XLLTIPDIAP,
     :new.XLLTIPOANO,
     :new.XLLTIPODIA,
     :new.XLLTIPOPRE,
     :new.XLLTIPOTAS,
     :new.XLLVALCAN,
     :new.XLLVALCUO,
     :old.XLLAOCTA,
     :old.XLLAOMDA,
     :old.XLLAOMOD,
     :old.XLLAOOPER,
     :old.XLLAOPAP,
     :old.XLLAOSBOP,
     :old.XLLAOSUC,
     :old.XLLAOTOP,
     :old.XLLAUX1,
     :old.XLLAUX2,
     :old.XLLAUX3,
     :old.XLLAUX4,
     :old.XLLAUX5,
     :old.XLLAUX6,
     :old.XLLCANTCUO,
     :old.XLLCAPFIN,
     :old.XLLCAPITAL,
     :old.XLLCAPLIQ,
     :old.XLLCIUD,
     :old.XLLCNTCUOI,
     :old.XLLFINANC,
     :old.XLLFPRIMPA,
     :old.XLLFPRIPAG,
     :old.XLLFVALOR,
     :old.XLLFVTO,
     :old.XLLGRACFIJ,
     :old.XLLGRADIMP,
     :old.XLLGRADPER,
     :old.XLLGRADPOR,
     :old.XLLIMPU,
     :old.XLLMEDICO,
     :old.XLLMODOCAL,
     :old.XLLPCLDREV,
     :old.XLLPCLPLUS,
     :old.XLLPCLTCOD,
     :old.XLLPERIODO,
     :old.XLLPGCOD,
     :old.XLLPLAZO,
     :old.XLLPRECIO,
     :old.XLLREDON,
     :old.XLLTASAEJ,
     :old.XLLTASAP,
     :old.XLLTFERP,
     :old.XLLTIPDIAP,
     :old.XLLTIPOANO,
     :old.XLLTIPODIA,
     :old.XLLTIPOPRE,
     :old.XLLTIPOTAS,
     :old.XLLVALCAN,
     :old.XLLVALCUO,
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
END T_AUD_X054023_AUD_U;
/

