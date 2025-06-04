create or replace package USRECOSISTEMAS.PKG_TRAINING_TEACHER is

type TRA_CURSOR_TEACHER IS REF CURSOR;

PROCEDURE TRA_TRAININGTEACHER_GETALL(cursorOut OUT TRA_CURSOR_TEACHER);

PROCEDURE TRA_TRAININGTEACHER_GETBYID(pid IN NUMBER,cursorOut OUT TRA_CURSOR_TEACHER);

PROCEDURE TRA_TRAININGTEACHER_UPDATE(
pid IN NUMBER,
pfirstname IN VARCHAR2,
plastname IN VARCHAR2,
pspeciality IN VARCHAR2,
pexperience IN VARCHAR2,
pimage IN VARCHAR2,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE TRA_TRAININGTEACHER_INSERT(
pfirstname IN VARCHAR2,
plastname IN VARCHAR2,
pspeciality IN VARCHAR2,
pexperience IN VARCHAR2,
pimage IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE TRA_TRAININGTEACHER_UPDATESTATUS(pid IN NUMBER, pstatusid IN NUMBER,pupdatedby IN NUMBER ,IDOUT out NUMBER);

end PKG_TRAINING_TEACHER;

/
create or replace package body USRECOSISTEMAS.PKG_TRAINING_TEACHER is

PROCEDURE TRA_TRAININGTEACHER_GETALL(cursorOut OUT TRA_CURSOR_TEACHER)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT * FROM TRAININGTEACHER WHERE STATUS=1;
END TRA_TRAININGTEACHER_GETALL;

PROCEDURE TRA_TRAININGTEACHER_GETBYID(pid IN NUMBER,cursorOut OUT TRA_CURSOR_TEACHER)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT * FROM TRAININGTEACHER WHERE ID=pid;
END TRA_TRAININGTEACHER_GETBYID;

PROCEDURE TRA_TRAININGTEACHER_UPDATE(
pid IN NUMBER,
pfirstname IN VARCHAR2,
plastname IN VARCHAR2,
pspeciality IN VARCHAR2,
pexperience IN VARCHAR2,
pimage IN VARCHAR2,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
IDOUT out NUMBER)
IS
BEGIN
  UPDATE TRAININGTEACHER
 SET
 FirstName = pfirstname
,LastName=plastname
,Speciality = pspeciality
,Experience = pexperience
,Image = pimage
,Status = pstatusid
,updatedby = pupdatedby
,updateddate = SYSDATE
WHERE ID = pid;

 IDOUT := SQL%rowcount;
END TRA_TRAININGTEACHER_UPDATE;

PROCEDURE TRA_TRAININGTEACHER_INSERT(
    pfirstname   IN VARCHAR2,
    plastname    IN VARCHAR2,
    pspeciality  IN VARCHAR2,
    pexperience  IN VARCHAR2,
    pimage       IN VARCHAR2,
    pstatusid    IN NUMBER,
    pcreatedby   IN NUMBER,
    IDOUT        OUT NUMBER
)
IS
    v_new_id NUMBER;
BEGIN
    -- Obtener el máximo ID actual y sumarle 1 (o poner 1 si la tabla está vacía)
    SELECT NVL(MAX(ID), 0) + 1
    INTO v_new_id
    FROM TRAININGTEACHER;

    -- Insertar con el nuevo ID
    INSERT INTO TRAININGTEACHER (
        ID,
        FirstName,
        LastName,
        Speciality,
        Experience,
        Image,
        Status,
        CreatedBy,
        CreatedDate
    ) VALUES (
        v_new_id,
        pfirstname,
        plastname,
        pspeciality,
        pexperience,
        pimage,
        pstatusid,
        pcreatedby,
        SYSDATE
    );

    -- Devolver el nuevo ID
    IDOUT := v_new_id;

    COMMIT;
END TRA_TRAININGTEACHER_INSERT;

PROCEDURE TRA_TRAININGTEACHER_UPDATESTATUS(pid IN NUMBER, pstatusid IN NUMBER,pupdatedby IN NUMBER ,IDOUT out NUMBER)
IS
BEGIN
    UPDATE TRAININGTEACHER SET STATUS = pstatusid, UPDATEDBY = pupdatedby, UPDATEDDATE = sysdate WHERE ID = pid;
  IDOUT := SQL%rowcount;
 COMMIT;
END TRA_TRAININGTEACHER_UPDATESTATUS;

end PKG_TRAINING_TEACHER;
/