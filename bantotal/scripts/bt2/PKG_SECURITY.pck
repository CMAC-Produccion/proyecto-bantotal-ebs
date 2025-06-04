create or replace PACKAGE USRECOSISTEMAS.PKG_SECURITY is

type SEC_CURSOR IS REF CURSOR;


PROCEDURE SEC_USERPERSON_LOGIN(pusername IN VARCHAR2,pmoduleid IN NUMBER, cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_LOGIN_V2(pusername IN VARCHAR2,pisadmin IN NUMBER, cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_GETBYID(pid IN NUMBER, cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_INSERT(
  pfirstname IN VARCHAR2,
  plastname IN VARCHAR2,
  pemail IN VARCHAR2,
  pcellphone IN VARCHAR2,
  ppassword IN VARCHAR2,
  pisshopper IN NUMBER,
  pisvendor IN NUMBER,
  pdocumenttypeid IN NUMBER,
  pdocumenttypenumber IN VARCHAR2,
  ppicture IN VARCHAR2,
  pstatusid  IN NUMBER,
  pcreatedby  IN NUMBER,
  pmoduleid IN NUMBER,
  panotherCodeReferral IN VARCHAR2,
  paccesstype IN NUMBER,
  pisadmin IN NUMBER,
  pguid IN VARCHAR2,
  IDOUT out NUMBER);
PROCEDURE SEC_EXIST_EMAIL_USERPERSON(pemail IN VARCHAR2,cursorEmailOut OUT SEC_CURSOR);
PROCEDURE SEC_EXIST_DOCNUMBER_USERPERSON(pdocnumber IN VARCHAR2,cursordocNumberlOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_UPDATE(pid IN NUMBER, pcellphone IN VARCHAR2, rowsOut out NUMBER);
PROCEDURE SEC_USERPERSON_UPDATE_PASSWORD(pid IN NUMBER, ppassword IN VARCHAR2, rowsOut out NUMBER);
PROCEDURE SEC_USERPASSWORDTOKEN_INSERT(puserpersonid IN NUMBER, pemail IN VARCHAR2, ptoken IN VARCHAR2, ptimeexpired IN DATE,pstatusid IN NUMBER,pcreatedby  IN NUMBER,IDOUT out NUMBER);
PROCEDURE SEC_USERPASSWORDTOKEN_EXPIRED(pid IN NUMBER,pstatusid IN NUMBER,pupdatedby IN NUMBER,IDOUT out NUMBER);
PROCEDURE SEC_USERPERSON_DELETE(preasonid IN NUMBER, puserpersonid IN NUMBER, pdescription IN VARCHAR2, pstatusid IN NUMBER, rowsOut out NUMBER);
PROCEDURE SEC_USERPASSWORDTOKEN_GETBYTOKEN(ptoken IN VARCHAR2, cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_PICTURE_UPDATE(pid IN NUMBER, ppicture IN VARCHAR2, rowsOut out NUMBER);
PROCEDURE SEC_ADD_MODULE_MARKETPLACE(piduser in NUMBER,pidmodule in NUMBER,IDOUT out NUMBER);
PROCEDURE SEC_EXIST_USERMODULE(piduser in NUMBER,pidmodule in NUMBER,cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERTOKEN_INSERT(
  puserid IN NUMBER,
  ptoken IN VARCHAR2,
  pstatusid  IN NUMBER,
  pcreatedby  IN NUMBER,
  IDOUT out NUMBER);
PROCEDURE SEC_USERTOKEN_UPDATE(
  ptoken IN VARCHAR2,
  pstatusid  IN NUMBER,
  pupdatedby  IN NUMBER,
  rowsOut out NUMBER);
PROCEDURE SEC_USERTOKEN_GETACTIVE(ptoken IN VARCHAR2,cursorUserToken OUT SEC_CURSOR);
PROCEDURE SEC_USERSELECTMODULELOGIN_INSERT(
  puserid IN NUMBER,
  puseremail IN VARCHAR2,
  pmoduleid  IN NUMBER,
  pmodulename IN VARCHAR2,
  pcreatedby  IN NUMBER,
  IDOUT out NUMBER);
  PROCEDURE SEC_GUIDUSERPERSON_INSERT(
    puserid IN NUMBER,
    pemail IN VARCHAR2,
    pmoduleid IN NUMBER,
    pguid OUT VARCHAR2);
PROCEDURE SEC_USERPERSON_EMAILACTIVE(pguid IN VARCHAR2, cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_UPDATE_EMAILACTIVE(pid IN NUMBER, rowsOut out NUMBER);
PROCEDURE SEC_USERPERSON_EMAILACTIVE_BYEMAIL(pemail IN VARCHAR2, cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_EMAILACTIVE_GETBYGUID(pguid IN VARCHAR2, cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_EMAILACTIVE_GETALL(cursorOut OUT SEC_CURSOR);
PROCEDURE SEC_USERPERSON_EMAILACTIVE_UPDATE_EMAILREMINDER(pguid IN VARCHAR2, rowsOut out NUMBER);
END PKG_SECURITY;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_SECURITY is
FUNCTION generar_codigo_alfanumerico RETURN VARCHAR2 IS
    v_letras VARCHAR2(4);
    v_numeros VARCHAR2(4);
    v_codigo_referral VARCHAR2(8); 
    v_existencia NUMBER;
BEGIN 
    -- Inicializar variables
    v_letras := '';
    v_numeros := '';
    v_codigo_referral := '';
     v_existencia := 0;
    -- Generar 4 letras
    FOR i IN 1..4 LOOP
        v_letras := v_letras || CHR(TRUNC(DBMS_RANDOM.VALUE(65, 91))); -- Letras mayusculas (A-Z)
    END LOOP;

    -- Generar 4 numeros
    FOR i IN 1..4 LOOP
        v_numeros := v_numeros || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 10))); -- Numeros (0-9)
    END LOOP;

    -- Combina letras y numeros para el codigo de referencia
    v_codigo_referral := v_letras || v_numeros;

    -- Verificar si el codigo ya existe en la tabla
    SELECT COUNT(*)
    INTO v_existencia
    FROM userperson
    WHERE OwnCodeReferral = v_codigo_referral;

    -- Si el codigo ya existe, generar uno nuevo (esto puede repetirse varias veces si es necesario)
    WHILE v_existencia > 0 LOOP
        -- Resetear variables para la nueva generacion
        v_letras := '';
        v_numeros := '';

        FOR i IN 1..4 LOOP
            v_letras := v_letras || CHR(TRUNC(DBMS_RANDOM.VALUE(65, 91)));
        END LOOP;

        FOR i IN 1..4 LOOP
            v_numeros := v_numeros || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 10)));
        END LOOP;

        -- Combina letras y numeros para el codigo de referencia
        v_codigo_referral := v_letras || v_numeros;

        -- Verificar nuevamente si el nuevo codigo existe en la tabla
        SELECT COUNT(*)
        INTO v_existencia
        FROM userperson
        WHERE OwnCodeReferral = v_codigo_referral;
    END LOOP;

    RETURN v_codigo_referral;
END generar_codigo_alfanumerico;
FUNCTION generar_guid_alfanumerico RETURN VARCHAR2 IS 
    v_letras VARCHAR2(4);
    v_numeros VARCHAR2(4);
    v_codigo_referral VARCHAR2(8); 
    v_existencia NUMBER;
BEGIN
    -- Inicializar variables
    v_letras := '';
    v_numeros := '';
    v_codigo_referral := '';
    v_existencia := 0;

    -- Generar 4 letras
    FOR i IN 1..4 LOOP
        v_letras := v_letras || CHR(TRUNC(DBMS_RANDOM.VALUE(65, 91))); -- Letras mayusculas (A-Z)
    END LOOP;

    -- Generar 4 numeros
    FOR i IN 1..4 LOOP
        v_numeros := v_numeros || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 10))); -- Numeros (0-9)
    END LOOP;

    -- Combina letras y numeros para el codigo de referencia
    v_codigo_referral := v_letras || v_numeros;

    -- Verificar si el codigo ya existe en la tabla UserPersonEmailActive
    SELECT COUNT(*)
    INTO v_existencia
    FROM UserPersonEmailActive
    WHERE guid = v_codigo_referral;

    -- Si el codigo ya existe, generar uno nuevo
    WHILE v_existencia > 0 LOOP
        -- Resetear variables para la nueva generacion
        v_letras := '';
        v_numeros := '';

        FOR i IN 1..4 LOOP
            v_letras := v_letras || CHR(TRUNC(DBMS_RANDOM.VALUE(65, 91)));
        END LOOP;

        FOR i IN 1..4 LOOP
            v_numeros := v_numeros || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 10)));
        END LOOP;

        -- Combina letras y numeros para el codigo de referencia
        v_codigo_referral := v_letras || v_numeros;

        -- Verificar nuevamente si el nuevo codigo existe en la tabla UserPersonEmailActive
        SELECT COUNT(*)
        INTO v_existencia
        FROM UserPersonEmailActive
        WHERE guid = v_codigo_referral;
    END LOOP;

    RETURN v_codigo_referral;
END generar_guid_alfanumerico;
PROCEDURE SEC_USERPERSON_LOGIN(pusername IN VARCHAR2,pmoduleid IN NUMBER, cursorOut OUT SEC_CURSOR)
AS
userID NUMBER;
employeeID NUMBER := 0;
BEGIN 
    select count(*) into userID from USERPERSON up inner join USERMODULE um on up.id = um.userid  
    where lower(up.EMAIL)=lower(pusername) and um.MODULEID=pmoduleid and up.STATUSID = 1 and um.STATUSID = 1;
    
  BEGIN
    SELECT id INTO employeeID
    FROM EMPLOYEE
    WHERE LOWER(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(email)))) = LOWER(pusername)
      AND statusid = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      employeeID := 0; -- Si no se encuentra, se deja el valor en NULL
  END;

  if userID > 0
  then
          OPEN cursorOut FOR
          SELECT
          ID,
          FIRSTNAME,
          LASTNAME,
          EMAIL, 
          CELLPHONE,
          PASSWORD,
          ISSHOPPER,
          ISVENDOR,
          DOCUMENTTYPEID,
          DOCUMENTNUMBER,
          PICTURE,
          STATUSID,
          CREATEDBY,
          CREATEDDATE,
          UPDATEDBY,
          UPDATEDDATE,
          ISCREATECATEGORY,
          OwnCodeReferral,
          AnotherCodeReferral,
          employeeID as employeeId
          FROM USERPERSON WHERE lower(EMAIL) = lower(pusername) and STATUSID = 1;
  END IF;
END SEC_USERPERSON_LOGIN;

PROCEDURE SEC_USERPERSON_LOGIN_V2(pusername IN VARCHAR2,pisadmin IN NUMBER,cursorOut OUT SEC_CURSOR)
AS

employeeID NUMBER := 0;
BEGIN 
     BEGIN
    SELECT id INTO employeeID
    FROM EMPLOYEE
    WHERE LOWER(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(email)))) = LOWER(pusername)
      AND statusid = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      employeeID := 0; -- Si no se encuentra, se deja el valor en NULL
  END;

    OPEN cursorOut FOR
          SELECT
          ID,
          FIRSTNAME,
          LASTNAME,
          EMAIL, 
          CELLPHONE,
          PASSWORD,
          ISSHOPPER,
          ISVENDOR,
          DOCUMENTTYPEID,
          DOCUMENTNUMBER,
          PICTURE,
          STATUSID,
          CREATEDBY,
          CREATEDDATE,
          UPDATEDBY,
          UPDATEDDATE,
          ISCREATECATEGORY,
          OwnCodeReferral,
          AnotherCodeReferral,
          AccessType,
          IsAdmin,
           employeeID as employeeId
          FROM USERPERSON WHERE lower(EMAIL) = lower(pusername) and STATUSID = 1
          AND (pisadmin IS NULL OR pisadmin = 0 OR (pisadmin = 1 AND ISADMIN = pisadmin));
END SEC_USERPERSON_LOGIN_V2;

PROCEDURE SEC_USERPERSON_GETBYID(pid IN NUMBER, cursorOut OUT SEC_CURSOR)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT
  ID,
  FIRSTNAME,
  LASTNAME,
  EMAIL,
  CELLPHONE,
  PASSWORD,
  ISSHOPPER,
  ISVENDOR,
  DOCUMENTTYPEID,
  DOCUMENTNUMBER,
  PICTURE,
  STATUSID,
  CREATEDBY,
  CREATEDDATE,
  UPDATEDBY,
  UPDATEDDATE,
  ISCREATECATEGORY 
  FROM USERPERSON WHERE ID = pid;
END SEC_USERPERSON_GETBYID;

PROCEDURE SEC_USERPASSWORDTOKEN_GETBYTOKEN(ptoken IN VARCHAR2, cursorOut OUT SEC_CURSOR)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT
  *
  FROM USERPASSWORDTOKEN WHERE TOKEN = ptoken and STATUSID=1;
END SEC_USERPASSWORDTOKEN_GETBYTOKEN;

PROCEDURE SEC_USERPERSON_INSERT(
  pfirstname IN VARCHAR2,
  plastname IN VARCHAR2,
  pemail IN VARCHAR2,
  pcellphone IN VARCHAR2,
  ppassword IN VARCHAR2,
  pisshopper IN NUMBER,
  pisvendor IN NUMBER,
  pdocumenttypeid IN NUMBER,
  pdocumenttypenumber IN VARCHAR2,
  ppicture IN VARCHAR2,
  pstatusid  IN NUMBER,
  pcreatedby  IN NUMBER,
  pmoduleid IN NUMBER,
  panotherCodeReferral IN VARCHAR2,
  paccesstype IN NUMBER,
  pisadmin IN NUMBER,
  pguid IN VARCHAR2,
  IDOUT OUT NUMBER)
IS
 v_codigo_referral VARCHAR2(8);
  v_employeeId NUMBER;
  v_employeeExists BOOLEAN := FALSE;
  TYPE ModuleIdArrayType IS VARRAY(4) OF NUMBER;
  moduleIds ModuleIdArrayType := ModuleIdArrayType(1, 2, 3, 4);
BEGIN
   -- Llamar a la funcion para generar el codigo alfanumerico
    v_codigo_referral := generar_codigo_alfanumerico();

  INSERT INTO USERPERSON
  (
  FIRSTNAME,
  LASTNAME,
  EMAIL,
  CELLPHONE,
  PASSWORD,
  ISSHOPPER,
  ISVENDOR,
  DOCUMENTTYPEID,
  DOCUMENTNUMBER,
  PICTURE,
  STATUSID,
  CREATEDBY,
  CREATEDDATE,
  OwnCodeReferral,
  AnotherCodeReferral,
  AccessType,
  IsAdmin,
  moduleid
  )
  values
  (
  pfirstname,
  plastname,
  pemail,
  pcellphone,
  ppassword,
  pisshopper,
  pisvendor,
  pdocumenttypeid,
  pdocumenttypenumber,
  ppicture,
  pstatusid,
  pcreatedby,
  sysdate,
  v_codigo_referral, -- Utiliza el codigo generado --pownCodeReferral,
  panotherCodeReferral,
  paccesstype,
  pisadmin,
  pmoduleid
  )
  returning ID into IDOUT;

   IF(SQL%rowcount > 0 and pisadmin=0)
  THEN

FOR i IN 1..moduleIds.COUNT LOOP
      INSERT INTO USERMODULE (
        USERID,
        MODULEID,
        STATUSID,
        CREATEDBY,
        CREATEDDATE
      )
      VALUES (
        IDOUT,
        moduleIds(i),
        pstatusid,
        pcreatedby,
        SYSDATE
      );
    END LOOP;

  END IF;

 -- Logica para actualizar la tabla Employee si existe un registro con las condiciones dadas
  BEGIN
    -- Verificar si existe el empleado
    SELECT id INTO v_employeeId
    FROM employee
    WHERE guid = pguid
      AND email = pemail
      AND statusid = 1
      AND statusGuid = 1
    FOR UPDATE;
    
    v_employeeExists := TRUE; -- Marcar que el empleado existe

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- No hacer nada, ya que no se encontro un empleado
      v_employeeExists := FALSE;
  END;

  -- Si se encuentra el empleado, actualizar su iduserasigned
  IF v_employeeExists THEN
    UPDATE employee
    SET iduserasigned = IDOUT,
        updatedby = pcreatedby,
        updateddate = sysdate,
        statusguid = 2
    WHERE id = v_employeeId;
  END IF;
COMMIT;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END SEC_USERPERSON_INSERT;

PROCEDURE SEC_EXIST_EMAIL_USERPERSON(pemail in VARCHAR2, cursorEmailOut OUT SEC_CURSOR)
IS
BEGIN
    OPEN cursorEmailOut FOR
    SELECT COUNT(1) from USERPERSON WHERE trim(EMAIL) = trim(pemail);
END SEC_EXIST_EMAIL_USERPERSON;

PROCEDURE SEC_EXIST_DOCNUMBER_USERPERSON(pdocnumber in VARCHAR2, cursordocNumberlOut OUT SEC_CURSOR)
IS
BEGIN
    OPEN cursordocNumberlOut FOR
    SELECT COUNT(1) from USERPERSON WHERE trim(DOCUMENTNUMBER) = trim(pdocnumber);
END SEC_EXIST_DOCNUMBER_USERPERSON;

PROCEDURE SEC_USERPERSON_UPDATE(pid IN NUMBER, pcellphone IN VARCHAR2, rowsOut out NUMBER)
IS
BEGIN

 UPDATE USERPERSON SET CELLPHONE = pcellphone,
                     UPDATEDDATE = SYSDATE,
                     UPDATEDBY = pid
                     WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;
END SEC_USERPERSON_UPDATE;



PROCEDURE SEC_USERPERSON_UPDATE_PASSWORD(pid IN NUMBER, ppassword IN VARCHAR2, rowsOut out NUMBER)
IS
BEGIN
  UPDATE USERPERSON SET PASSWORD = ppassword,
                     UPDATEDDATE = SYSDATE,
                     UPDATEDBY = pid
                     WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;
END SEC_USERPERSON_UPDATE_PASSWORD;

PROCEDURE SEC_USERPASSWORDTOKEN_INSERT(puserpersonid IN NUMBER, pemail IN VARCHAR2, ptoken IN VARCHAR2, ptimeexpired IN DATE,pstatusid IN NUMBER,pcreatedby IN NUMBER,IDOUT out NUMBER)
IS
BEGIN
  INSERT INTO USERPASSWORDTOKEN
  (
  USERPERSONID,
  EMAIL,
  TOKEN,
  TIMEEXPIRED,
  STATUSID,
  CREATEDBY,
  CREATEDDATE
  )
  values
  (
  puserpersonid,
  pemail,
  ptoken,
  ptimeexpired,
  pstatusid,
  pcreatedby,
  sysdate
  )
  returning ID into IDOUT;
END SEC_USERPASSWORDTOKEN_INSERT;

PROCEDURE SEC_USERPASSWORDTOKEN_EXPIRED(pid IN NUMBER,pstatusid IN NUMBER,pupdatedby IN NUMBER,IDOUT out NUMBER)
IS
BEGIN
  UPDATE USERPASSWORDTOKEN SET STATUSID=pstatusid, UPDATEDBY=pupdatedby, UPDATEDDATE=sysdate where ID=pid;
  IDOUT := SQL%rowcount;
END SEC_USERPASSWORDTOKEN_EXPIRED;

PROCEDURE SEC_USERPERSON_DELETE(preasonid IN NUMBER, puserpersonid IN NUMBER, pdescription IN VARCHAR2, pstatusid IN NUMBER, rowsOut out NUMBER)
IS
BEGIN

 UPDATE USERPERSON SET
                     STATUSID = pstatusid,
                     UPDATEDDATE = SYSDATE,
                     UPDATEDBY = puserpersonid
                     WHERE ID = puserpersonid;
  rowsOut := SQL%rowcount;

  IF(rowsOut > 0)
  THEN
    INSERT INTO preferenceaccount (REASONID, USERPERSONID, DESCRIPTION,CREATEDBY, CREATEDDATE) VALUES (preasonid,puserpersonid,pdescription,puserpersonid, SYSDATE);
  END IF;
 COMMIT;
END SEC_USERPERSON_DELETE;

PROCEDURE SEC_USERPERSON_PICTURE_UPDATE(pid IN NUMBER, ppicture IN VARCHAR2, rowsOut out NUMBER)
IS
BEGIN

 UPDATE USERPERSON SET PICTURE = ppicture,
                     UPDATEDDATE = SYSDATE,
                     UPDATEDBY = pid
                     WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;
END SEC_USERPERSON_PICTURE_UPDATE;

PROCEDURE SEC_ADD_MODULE_MARKETPLACE(piduser in NUMBER,pidmodule in NUMBER,IDOUT out NUMBER)
IS
BEGIN
 INSERT INTO USERMODULE(USERID,MODULEID,STATUSID,CREATEDBY,CREATEDDATE)
 values(piduser,pidmodule,1,piduser,sysdate)
 returning ID into IDOUT;
 COMMIT;
END SEC_ADD_MODULE_MARKETPLACE;
PROCEDURE SEC_EXIST_USERMODULE(piduser in NUMBER,pidmodule in NUMBER,cursorOut OUT SEC_CURSOR)
IS
BEGIN
 OPEN cursorOut FOR
    SELECT COUNT(1) from USERMODULE WHERE userid = piduser and moduleid= pidmodule and STATUSID = 1;
END SEC_EXIST_USERMODULE;

PROCEDURE SEC_USERTOKEN_INSERT(
  puserid IN NUMBER,
  ptoken IN VARCHAR2,
  pstatusid  IN NUMBER,
  pcreatedby  IN NUMBER,
  IDOUT out NUMBER)
IS
BEGIN
  INSERT INTO USERTOKEN
  (
  USERID,
  TOKEN,
  STATUSID,
  CREATEDBY,
  CREATEDDATE
  )
  values
  (
  puserid,
  ptoken,
  pstatusid,
  pcreatedby,
  sysdate
  )
  returning ID into IDOUT;
 IF(SQL%rowcount > 0)
  THEN
   COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END SEC_USERTOKEN_INSERT;

PROCEDURE SEC_USERTOKEN_UPDATE(
  ptoken IN VARCHAR2,
  pstatusid  IN NUMBER,
  pupdatedby  IN NUMBER,
  rowsOut out NUMBER)
IS
BEGIN
  UPDATE USERTOKEN SET STATUSID = pstatusid,
                     UPDATEDDATE = SYSDATE,
                     UPDATEDBY = pupdatedby
                     WHERE TOKEN = ptoken;
  rowsOut := SQL%rowcount;
 COMMIT;

END SEC_USERTOKEN_UPDATE;

PROCEDURE SEC_USERTOKEN_GETACTIVE(ptoken IN VARCHAR2,cursorUserToken OUT SEC_CURSOR)
IS
BEGIN
  OPEN cursorUserToken FOR
  SELECT
  *
  FROM USERTOKEN WHERE TOKEN = ptoken and STATUSID=1;
END SEC_USERTOKEN_GETACTIVE;

PROCEDURE SEC_USERSELECTMODULELOGIN_INSERT(
  puserid IN NUMBER,
  puseremail IN VARCHAR2,
  pmoduleid  IN NUMBER,
  pmodulename IN VARCHAR2,
  pcreatedby  IN NUMBER,
  IDOUT out NUMBER)
IS
BEGIN
  INSERT INTO UserSelectModuleLogin
  (
  UserID,
  UserEmail,
  ModuleID,
  ModuleName,
  CREATEDBY,
  CREATEDDATE
  )
  values
  (
  puserid,
  puseremail,
  pmoduleid,
  pmodulename,
  pcreatedby,
  sysdate
  )
  returning ID into IDOUT;
 IF(SQL%rowcount > 0)
  THEN
   COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END SEC_USERSELECTMODULELOGIN_INSERT;
PROCEDURE SEC_GUIDUSERPERSON_INSERT (
    puserid IN NUMBER,
    pemail IN VARCHAR2,
    pmoduleid IN NUMBER,
    pguid OUT VARCHAR2
) IS
    vguid VARCHAR2(50); 
BEGIN 
    --Inhabilita los guid del usuario para crear uno nuevo
    UPDATE userpersonemailactive SET FLAGEMAILACTIVE = 1,
                     STATUSID = 2,
                     UPDATEDDATE = SYSDATE 
                     WHERE IDUSERCREATED = puserid;
                     
   vguid := generar_guid_alfanumerico();

    -- Insertar el registro en la tabla UserPersonEmailActive
    INSERT INTO UserPersonEmailActive (
        idusercreated,
        guid,
        email,
        flagemailactive,
        statusid,
        createdby,
        createddate,
        moduleid
    ) VALUES (
        puserid,
        vguid,
        pemail,
        0,              -- flagemailactive por defecto a 0
        1,              -- statusid por defecto a 1
        puserid,       -- createdby como el ID de usuario
        SYSDATE,
        pmoduleid
    );

    -- Asignar el GUID generado al parametro de salida
    pguid := vguid;

    -- Confirmar la transaccion
    COMMIT;
END SEC_GUIDUSERPERSON_INSERT;
PROCEDURE SEC_USERPERSON_EMAILACTIVE(pguid IN VARCHAR2, cursorOut OUT SEC_CURSOR)
AS
BEGIN 
          OPEN cursorOut FOR
          SELECT
          ID,IDUSERCREATED,GUID,EMAIL,FLAGEMAILACTIVE,STATUSID,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,MODULEID
          FROM userpersonemailactive WHERE GUID = pguid;
END SEC_USERPERSON_EMAILACTIVE;

PROCEDURE SEC_USERPERSON_UPDATE_EMAILACTIVE(pid IN NUMBER, rowsOut out NUMBER)
IS
 v_email VARCHAR2(255);
BEGIN 
  -- Obten el primer correo electronico asociado al pid
    SELECT EMAIL 
    INTO v_email 
    FROM userpersonemailactive 
    WHERE ID = pid
    AND ROWNUM = 1;
    
      UPDATE userpersonemailactive 
        SET   emailreminder = 1
     WHERE EMAIL = v_email;
    
  UPDATE userpersonemailactive SET FLAGEMAILACTIVE = 1,
                     STATUSID = 2,
                     emailreminder = 1,
                     UPDATEDDATE = SYSDATE 
                     WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;
END SEC_USERPERSON_UPDATE_EMAILACTIVE;
PROCEDURE SEC_USERPERSON_EMAILACTIVE_BYEMAIL(pemail IN VARCHAR2, cursorOut OUT SEC_CURSOR)
AS
BEGIN 
          OPEN cursorOut FOR
         SELECT
        ID, IDUSERCREATED, GUID, EMAIL, FLAGEMAILACTIVE, STATUSID, CREATEDBY, CREATEDDATE, UPDATEDBY, UPDATEDDATE, MODULEID, EmailReminder
    FROM 
        (SELECT * 
         FROM userpersonemailactive 
         WHERE email = pemail
         ORDER BY ID DESC) 
    WHERE ROWNUM = 1;
END SEC_USERPERSON_EMAILACTIVE_BYEMAIL;
PROCEDURE SEC_USERPERSON_EMAILACTIVE_GETBYGUID(pguid IN VARCHAR2, cursorOut OUT SEC_CURSOR)
AS
BEGIN 
          OPEN cursorOut FOR
          SELECT 
          ID,IDUSERCREATED,GUID,EMAIL,FLAGEMAILACTIVE,STATUSID,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,MODULEID,EmailReminder
          FROM userpersonemailactive WHERE GUID = pguid;
END SEC_USERPERSON_EMAILACTIVE_GETBYGUID;
PROCEDURE SEC_USERPERSON_EMAILACTIVE_GETALL(cursorOut OUT SEC_CURSOR)
AS
BEGIN 
          OPEN cursorOut FOR
          SELECT 
          Id,IdUserCreated,Guid,Email,FlagEmailActive,StatusId,CreatedBy,CreatedDate,ModuleId,EmailReminder
          FROM USERPERSONEMAILACTIVE where EmailReminder is null AND TRUNC(CreatedDate) <= TRUNC(SYSDATE) - 5
          order by Id desc; 
END SEC_USERPERSON_EMAILACTIVE_GETALL;
PROCEDURE SEC_USERPERSON_EMAILACTIVE_UPDATE_EMAILREMINDER(pguid IN VARCHAR2, rowsOut out NUMBER)
IS
BEGIN 
  UPDATE userpersonemailactive SET EMAILREMINDER = 1,
                     UPDATEDDATE = SYSDATE 
                     WHERE GUID = pguid;
  rowsOut := SQL%rowcount; 
 COMMIT;
END SEC_USERPERSON_EMAILACTIVE_UPDATE_EMAILREMINDER;
END PKG_SECURITY;
/