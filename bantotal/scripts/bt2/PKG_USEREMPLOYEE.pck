create or replace package USRECOSISTEMAS.PKG_USEREMPLOYEE is

  type USR_CURSOR_USEREMPLOYEE IS REF CURSOR;
  
  PROCEDURE USR_USEREMPLOYEE_INSERT(
    pIdUserCreated IN NUMBER,
    pRolId IN NUMBER,
    pFullName IN VARCHAR2,
    pCellPhone IN VARCHAR2,
    pEmail IN VARCHAR2,
    pStatusGuid IN NUMBER,
    pStatusID IN NUMBER,
    pCreatedBy IN NUMBER,
    IDOUT out NUMBER);
PROCEDURE SEC_EXIST_EMAIL_USEREMPLOYEE(pemail IN VARCHAR2,cursorEmailOut OUT USR_CURSOR_USEREMPLOYEE);
PROCEDURE USR_USEREMPLOYE_GETBYEMAIL(pemail in VARCHAR2,cursorOut OUT USR_CURSOR_USEREMPLOYEE);
  PROCEDURE USR_USEREMPLOYEE_UPDATESTATUS(
  pid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  rowsOut out NUMBER); 
  
  PROCEDURE USR_USEREMPLOYEE_PAGINATED(psearch in VARCHAR2 ,puserid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT USR_CURSOR_USEREMPLOYEE);
  PROCEDURE SEC_EXIST_EMAIL_GUID_USEREMPLOYEE(pemail in VARCHAR2,pguid in VARCHAR2, cursorEmailOut OUT USR_CURSOR_USEREMPLOYEE);
end PKG_USEREMPLOYEE;
/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_USEREMPLOYEE IS

PROCEDURE USR_USEREMPLOYEE_INSERT(
  pIdUserCreated IN NUMBER,
    pRolId IN NUMBER,
    pFullName IN VARCHAR2,
    pCellPhone IN VARCHAR2,
    pEmail IN VARCHAR2,
    pStatusGuid IN NUMBER,
    pStatusID IN NUMBER,
    pCreatedBy IN NUMBER,
    IDOUT OUT NUMBER)
IS 
    v_GUID VARCHAR2(250);
    v_Count NUMBER;
    v_IdUserAsigned NUMBER; -- Variable para almacenar el ID obtenido de UserPerson
    v_EmployeeId NUMBER;    -- ID del empleado insertado
BEGIN
    -- Verificar si el correo existe en la tabla UserPerson (limitando a 1 resultado)
    BEGIN
        SELECT Id INTO v_IdUserAsigned 
        FROM UserPerson 
        WHERE Email = pEmail and statusid = 1
        AND ROWNUM = 1;  -- Limitar el resultado a solo el primer registro
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Si no se encuentra el correo, asignamos NULL
            v_IdUserAsigned := NULL;
    END;

    -- Generar un GUID único para el nuevo empleado
    LOOP
        v_GUID := DBMS_RANDOM.STRING('X', 20);  -- Generar GUID de 20 caracteres alfanuméricos

        -- Verificar que el GUID sea único en la tabla Employee
        SELECT COUNT(*) INTO v_Count 
        FROM Employee 
        WHERE Guid = v_GUID and statusid = 1;

        EXIT WHEN v_Count = 0;  -- Salir del loop si el GUID es único
    END LOOP;

    -- Insertar el nuevo empleado en la tabla Employee
    INSERT INTO Employee (
        IdUserCreated, RolId, Guid, FullName, CellPhone, Email, 
        StatusGuid, StatusID, CreatedBy, CreatedDate, IdUserAsigned
    ) 
    VALUES (
        pIdUserCreated, pRolId, v_GUID, 
        UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pFullName, ' ')))), 
        UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pCellPhone, ' ')))), 
        UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pEmail, ' ')))), 
        pStatusGuid, pStatusID, pCreatedBy, SYSDATE, v_IdUserAsigned
    )
    RETURNING Id INTO v_EmployeeId;  -- Guardar el ID del empleado recién insertado
    
    -- Si el empleado fue asignado a un usuario (es decir, si v_IdUserAsigned no es NULL)
    IF v_IdUserAsigned IS NOT NULL THEN
        -- Insertar las tiendas del usuario en la tabla EmployeeStore
        --FOR store_rec IN (SELECT Id FROM Store WHERE statusid = 1 and UserId = v_IdUserAsigned) LOOP
        --    INSERT INTO EmployeeStore (EmployeeId, StoreId, statusid, createdby, createddate)
        --    VALUES (v_EmployeeId, store_rec.Id, 1, pCreatedBy, sysdate);
        --END LOOP;
        
        FOR store_rec IN (SELECT Id FROM Store WHERE statusid = 1 AND UserId = pIdUserCreated) LOOP
             INSERT INTO EmployeeStore (EmployeeId, StoreId, statusid, createdby, createddate)
             VALUES (v_EmployeeId, store_rec.Id, 1, pCreatedBy, SYSDATE);
         END LOOP;
          -- Actualizar el StatusGuid a 2 en la tabla Employee para el empleado recién insertado
        UPDATE Employee
        SET StatusGuid = 2
        WHERE Id = v_EmployeeId;
    -- Si el empleado no fue asignado a un usuario (es decir, si v_IdUserAsigned es NULL)
    ELSE
    -- Insertar las tiendas del usuario creado (pCreatedBy) en la tabla EmployeeStore
    FOR store_rec IN (SELECT Id FROM Store WHERE statusid = 1 AND UserId = pIdUserCreated) LOOP
        INSERT INTO EmployeeStore (EmployeeId, StoreId, statusid, createdby, createddate)
        VALUES (v_EmployeeId, store_rec.Id, 1, pCreatedBy, SYSDATE);
    END LOOP;
    -- No se hace el update de StatusGuid en la tabla Employee
    END IF;
    
    -- Confirmar el éxito de la operación
    IDOUT := 1;  -- Código para indicar que la inserción fue exitosa

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de excepciones generales
        IDOUT := -1;  -- Código para indicar un error general
        ROLLBACK;
END USR_USEREMPLOYEE_INSERT;
PROCEDURE SEC_EXIST_EMAIL_USEREMPLOYEE(pemail in VARCHAR2, cursorEmailOut OUT USR_CURSOR_USEREMPLOYEE)
IS
BEGIN 
    OPEN cursorEmailOut FOR
    SELECT COUNT(1) from Employee WHERE trim(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(EMAIL)))) = trim(pemail) and statusid = 1;
END SEC_EXIST_EMAIL_USEREMPLOYEE;

PROCEDURE SEC_EXIST_EMAIL_GUID_USEREMPLOYEE(pemail in VARCHAR2,pguid in VARCHAR2, cursorEmailOut OUT USR_CURSOR_USEREMPLOYEE)
IS
BEGIN 
    OPEN cursorEmailOut FOR
    SELECT COUNT(1) from Employee WHERE trim(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(EMAIL)))) = trim(pemail) and trim(guid) = trim(pguid) and statusid = 1 and statusguid = 1;
END SEC_EXIST_EMAIL_GUID_USEREMPLOYEE;

PROCEDURE USR_USEREMPLOYE_GETBYEMAIL(pemail in VARCHAR2,cursorOut OUT USR_CURSOR_USEREMPLOYEE)
IS 
BEGIN
  OPEN cursorOut FOR
  select
    pr.id,
    pr.idusercreated,
    pr.iduserasigned,
    pr.rolid,
    pr.guid,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(NVL(pr.fullname, ' ')))),
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(NVL(pr.cellphone, ' ')))),
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(NVL(pr.email, ' ')))),
    pr.statusguid,
    pr.statusid
    from employee pr
    where pr.email=pemail and pr.statusid = 1;
END USR_USEREMPLOYE_GETBYEMAIL;
PROCEDURE USR_USEREMPLOYEE_UPDATESTATUS(
  pid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  rowsOut out NUMBER)
IS
BEGIN 
  UPDATE employee SET 
  STATUSID = pstatusid,
  UPDATEDBY = pupdatedby, 
  UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount; 
 COMMIT;
END USR_USEREMPLOYEE_UPDATESTATUS;
PROCEDURE USR_USEREMPLOYEE_PAGINATED(psearch in VARCHAR2 ,puserid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT USR_CURSOR_USEREMPLOYEE)
IS
BEGIN
 OPEN cursorOut FOR
 WITH UserEmployee_GetAll
 as
 (
 select id,fullName,email,cellphone,roleName,createddate,statusid,row_number() over(order by createddate desc) as NroRow from
 (select 
 e.id,
 UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(e.fullname))) as fullName,
 UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(e.email))) as email,
 UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(e.cellphone))) as cellphone,
 r.name as roleName,
 e.createddate,
e.statusid
 from employee e inner join role r
   on e.rolid = r.id
    where
    (lower(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(e.fullname)))) like lower(concat('%',psearch)) or 
    lower(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(e.email)))) like lower(concat('%',psearch)) or 
    lower(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(e.cellphone)))) like lower(concat('%',psearch)))
    and e.idusercreated = puserid and e.statusid = 1))
    select id,fullName,email,cellphone,roleName,createddate,statusid,NroRow,(select count(*) from UserEmployee_GetAll) as TotalRow from UserEmployee_GetAll where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by createddate desc,nrorow;
END USR_USEREMPLOYEE_PAGINATED;
END PKG_USEREMPLOYEE;
/