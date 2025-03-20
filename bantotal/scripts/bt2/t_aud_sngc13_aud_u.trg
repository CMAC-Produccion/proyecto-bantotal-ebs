CREATE OR REPLACE TRIGGER T_AUD_SNGC13_AUD_U
  AFTER UPDATE ON SNGC13
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

  /*PQ_CR_BUSQUEDA_DIRECCION.sp_cr_limpia_direccion_trigger(:new.sngc13pais,
                                       :new.sngc13tdoc,
                                      :new.sngc13ndoc,
                                      :new.DOCOD,
                                      :new.SNGC13CORR,
                                      :new.SNGC13UGEO ,
                                      :new.SNGC13DPTO ,
                                      :new.SNGC13PROV,
                                      :new.SNGC13DIST,
                                      :new.sngc13dir);*/

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
  INSERT INTO AUD_SNGC13_AUDIT
    (AUD_new_DOCOD,
     AUD_new_SNGC01ID,
     AUD_new_SNGC02ID,
     AUD_new_SNGC03ID,
     AUD_new_SNGC04ID,
     AUD_new_SNGC05ID,
     AUD_new_SNGC06ID,
     AUD_new_SNGC12VIVC,
     AUD_new_SNGC13ARR,
     AUD_new_SNGC13ATEL,
     AUD_new_SNGC13CNEG,
     AUD_new_SNGC13COL,
     AUD_new_SNGC13CORR,
     AUD_new_SNGC13DEST,
     AUD_new_SNGC13DIR,
     AUD_new_SNGC13DIST,
     AUD_new_SNGC13DPTO,
     AUD_new_SNGC13DSC1,
     AUD_new_SNGC13DSC2,
     AUD_new_SNGC13DSC3,
     AUD_new_SNGC13DSC4,
     AUD_new_SNGC13DSC5,
     AUD_new_SNGC13DSC6,
     AUD_new_SNGC13EST,
     AUD_new_SNGC13FDIR,
     AUD_new_SNGC13FHAB,
     AUD_new_SNGC13NDOC,
     AUD_new_SNGC13PAIS,
     AUD_new_SNGC13PDOC,
     AUD_new_SNGC13PROV,
     AUD_new_SNGC13RDES,
     AUD_new_SNGC13REF,
     AUD_new_SNGC13REF1,
     AUD_new_SNGC13TAS,
     AUD_new_SNGC13TDOC,
     AUD_new_SNGC13UGEO,
     AUD_new_SNGC13USER,
     AUD_old_DOCOD,
     AUD_old_SNGC01ID,
     AUD_old_SNGC02ID,
     AUD_old_SNGC03ID,
     AUD_old_SNGC04ID,
     AUD_old_SNGC05ID,
     AUD_old_SNGC06ID,
     AUD_old_SNGC12VIVC,
     AUD_old_SNGC13ARR,
     AUD_old_SNGC13ATEL,
     AUD_old_SNGC13CNEG,
     AUD_old_SNGC13COL,
     AUD_old_SNGC13CORR,
     AUD_old_SNGC13DEST,
     AUD_old_SNGC13DIR,
     AUD_old_SNGC13DIST,
     AUD_old_SNGC13DPTO,
     AUD_old_SNGC13DSC1,
     AUD_old_SNGC13DSC2,
     AUD_old_SNGC13DSC3,
     AUD_old_SNGC13DSC4,
     AUD_old_SNGC13DSC5,
     AUD_old_SNGC13DSC6,
     AUD_old_SNGC13EST,
     AUD_old_SNGC13FDIR,
     AUD_old_SNGC13FHAB,
     AUD_old_SNGC13NDOC,
     AUD_old_SNGC13PAIS,
     AUD_old_SNGC13PDOC,
     AUD_old_SNGC13PROV,
     AUD_old_SNGC13RDES,
     AUD_old_SNGC13REF,
     AUD_old_SNGC13REF1,
     AUD_old_SNGC13TAS,
     AUD_old_SNGC13TDOC,
     AUD_old_SNGC13UGEO,
     AUD_old_SNGC13USER,
     AUD_SNGC13_GuidKey,
     AUD_SNGC13_UOn,
     AUD_SNGC13_UT,
     AUD_SNGC13_UBR,
     AUD_SNGC13_UBC,
     AUD_SNGC13_UBT,
     AUD_SNGC13_UBU,
     AUD_SNGC13_UBA,
     AUD_SNGC13_UBS,
     AUD_SNGC13_UBP,
     AUD_SNGC13_UBM,
     AUD_SNGC13_UAs)
  VALUES
    (:new.DOCOD,
     :new.SNGC01ID,
     :new.SNGC02ID,
     :new.SNGC03ID,
     :new.SNGC04ID,
     :new.SNGC05ID,
     :new.SNGC06ID,
     :new.SNGC12VIVC,
     :new.SNGC13ARR,
     :new.SNGC13ATEL,
     :new.SNGC13CNEG,
     :new.SNGC13COL,
     :new.SNGC13CORR,
     :new.SNGC13DEST,
     :new.SNGC13DIR,
     :new.SNGC13DIST,
     :new.SNGC13DPTO,
     :new.SNGC13DSC1,
     :new.SNGC13DSC2,
     :new.SNGC13DSC3,
     :new.SNGC13DSC4,
     :new.SNGC13DSC5,
     :new.SNGC13DSC6,
     :new.SNGC13EST,
     :new.SNGC13FDIR,
     :new.SNGC13FHAB,
     :new.SNGC13NDOC,
     :new.SNGC13PAIS,
     :new.SNGC13PDOC,
     :new.SNGC13PROV,
     :new.SNGC13RDES,
     :new.SNGC13REF,
     :new.SNGC13REF1,
     :new.SNGC13TAS,
     :new.SNGC13TDOC,
     :new.SNGC13UGEO,
     :new.SNGC13USER,
     :old.DOCOD,
     :old.SNGC01ID,
     :old.SNGC02ID,
     :old.SNGC03ID,
     :old.SNGC04ID,
     :old.SNGC05ID,
     :old.SNGC06ID,
     :old.SNGC12VIVC,
     :old.SNGC13ARR,
     :old.SNGC13ATEL,
     :old.SNGC13CNEG,
     :old.SNGC13COL,
     :old.SNGC13CORR,
     :old.SNGC13DEST,
     :old.SNGC13DIR,
     :old.SNGC13DIST,
     :old.SNGC13DPTO,
     :old.SNGC13DSC1,
     :old.SNGC13DSC2,
     :old.SNGC13DSC3,
     :old.SNGC13DSC4,
     :old.SNGC13DSC5,
     :old.SNGC13DSC6,
     :old.SNGC13EST,
     :old.SNGC13FDIR,
     :old.SNGC13FHAB,
     :old.SNGC13NDOC,
     :old.SNGC13PAIS,
     :old.SNGC13PDOC,
     :old.SNGC13PROV,
     :old.SNGC13RDES,
     :old.SNGC13REF,
     :old.SNGC13REF1,
     :old.SNGC13TAS,
     :old.SNGC13TDOC,
     :old.SNGC13UGEO,
     :old.SNGC13USER,
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
     --Sofia Fernandez 11.03.2015
     PQ_CR_BUSQUEDA_DIRECCION.sp_cr_limpia_direccion_trigger(:new.sngc13pais,
                                       :new.sngc13tdoc,
                                      :new.sngc13ndoc,
                                      :new.DOCOD,
                                      :new.SNGC13CORR,
                                      :new.SNGC13UGEO ,
                                      :new.SNGC13DPTO ,
                                      :new.SNGC13PROV,
                                      :new.SNGC13DIST,
                                      :new.sngc13dir,
			              :new.sngc13est);
END T_AUD_SNGC13_AUD_U;
/

