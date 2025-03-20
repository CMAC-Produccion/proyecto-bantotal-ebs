CREATE OR REPLACE TRIGGER T_AUD_PRFU00_AUD_I
  AFTER INSERT ON PRFU00
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
  INSERT INTO BANTPROD.AUD_PRFU00_AUDIT
    (AUD_new_PGCOD,
     AUD_new_PRFGCOD,
     AUD_new_PRFUFECALT,
     AUD_new_PRFUFECVTO,
     AUD_new_PRFUTPO,
     AUD_new_PRFUUSER,
     AUD_new_UBUSER,
     AUD_PRFU00_GuidKey,
     AUD_PRFU00_UOn,
     AUD_PRFU00_UT,
     AUD_PRFU00_UBR,
     AUD_PRFU00_UBC,
     AUD_PRFU00_UBT,
     AUD_PRFU00_UBU,
     AUD_PRFU00_UBA,
     AUD_PRFU00_UBS,
     AUD_PRFU00_UBP,
     AUD_PRFU00_UBM,
     AUD_PRFU00_UAs)
  VALUES
    (:new.PGCOD,
     :new.PRFGCOD,
     :new.PRFUFECALT,
     :new.PRFUFECVTO,
     :new.PRFUTPO,
     :new.PRFUUSER,
     :new.UBUSER,
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

     begin
       if (:new.PRFGCOD='BANTOTAL') then
          sys.sp_sy_enviamail('Controlbantotal@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                          'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                          'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                          'PERFIL BANTOTAL ASIGNADO',
                          'Usuario con rol BANTOTAL:'||:new.UBUSER|| CHR(13) ||  CHR(13) ||
                          'Usuario que otorgó rol BANTOTAL:' || UserName || CHR(13) ||  CHR(13) ||
                          'Servidor Aplicación:' || Server || CHR(13) ||  CHR(13) ||
                          'IP Usuario:' || WrkstName || CHR(13) );
          sys.sp_sy_enviamail('Controlbantotal@cajaarequipa.pe','lcarpio@cajaarequipa.pe',
                          'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                          'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                          'PERFIL BANTOTAL ASIGNADO',
                          'Usuario con rol BANTOTAL:'||:new.UBUSER|| CHR(13) ||  CHR(13) ||
                          'Usuario que otorgó rol BANTOTAL:' || UserName || CHR(13) ||  CHR(13) ||
                          'Servidor Aplicación:' || Server || CHR(13) ||  CHR(13) ||
                          'IP Usuario:' || WrkstName || CHR(13) );
          sys.sp_sy_enviamail('Controlbantotal@cajaarequipa.pe','mcruze@cajaarequipa.pe',
                          'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                          'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                          'PERFIL BANTOTAL ASIGNADO',
                          'Usuario con rol BANTOTAL:'||:new.UBUSER|| CHR(13) ||  CHR(13) ||
                          'Usuario que otorgó rol BANTOTAL:' || UserName || CHR(13) ||  CHR(13) ||
                          'Servidor Aplicación:' || Server || CHR(13) ||  CHR(13) ||
                          'IP Usuario:' || WrkstName || CHR(13) );
          sys.sp_sy_enviamail('Controlbantotal@cajaarequipa.pe','babanto@cajaarequipa.pe',
                          'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                          'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                          'PERFIL BANTOTAL ASIGNADO',
                          'Usuario con rol BANTOTAL:'||:new.UBUSER|| CHR(13) ||  CHR(13) ||
                          'Usuario que otorgó rol BANTOTAL:' || UserName || CHR(13) ||  CHR(13) ||
                          'Servidor Aplicación:' || Server || CHR(13) ||  CHR(13) ||
                          'IP Usuario:' || WrkstName || CHR(13) );
          sys.sp_sy_enviamail('Controlbantotal@cajaarequipa.pe','dramireza@cajaarequipa.pe',
                          'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                          'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                          'PERFIL BANTOTAL ASIGNADO',
                          'Usuario con rol BANTOTAL:'||:new.UBUSER|| CHR(13) ||  CHR(13) ||
                          'Usuario que otorgó rol BANTOTAL:' || UserName || CHR(13) ||  CHR(13) ||
                          'Servidor Aplicación:' || Server || CHR(13) ||  CHR(13) ||
                          'IP Usuario:' || WrkstName || CHR(13) );

       end if;
     exception
       when others then
         null;
     end;
END T_AUD_PRFU00_AUD_I;
/

