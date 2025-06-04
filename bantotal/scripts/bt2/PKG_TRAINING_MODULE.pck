create or replace package USRECOSISTEMAS.PKG_TRAINING_MODULE is

  -- Author  : JHONATAN
  -- Created : 20/07/2023 08:17:43
  -- Purpose : 
  
  type TRA_CURSOR_MODULE IS REF CURSOR;
  
  PROCEDURE TRA_TRAININGMODULE_GETALL(cursorOut OUT TRA_CURSOR_MODULE);
  
  PROCEDURE TRA_TRAININGMODULE_INSERT(
  pname IN VARCHAR2,
  pdescription IN VARCHAR2,
  picon IN VARCHAR2,
  porder IN NUMBER,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT out NUMBER);
  
PROCEDURE TRA_TRAININGMODULE_UPDATE(
  pid IN NUMBER,
  pname IN VARCHAR2,
  pdescription IN VARCHAR2,
  picon IN VARCHAR2,
  porder IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  IDOUT out NUMBER);
  
  PROCEDURE TRA_TRAININGMODULE_UPDATESTATUS(
  pid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  IDOUT out NUMBER);

end PKG_TRAINING_MODULE;

/
create or replace package body USRECOSISTEMAS.PKG_TRAINING_MODULE is

PROCEDURE TRA_TRAININGMODULE_GETALL(cursorOut OUT TRA_CURSOR_MODULE)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT * FROM TRAININGMODULE WHERE STATUS = 1
  ORDER BY ORDERVIEW;
END TRA_TRAININGMODULE_GETALL;

PROCEDURE TRA_TRAININGMODULE_INSERT(
  pname IN VARCHAR2,
  pdescription IN VARCHAR2,
  picon IN VARCHAR2,
  porder IN NUMBER,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT out NUMBER) 
IS
BEGIN
  INSERT INTO trainingmodule (
Name,
Description,
Icon,
OrderView,
Status,
CreatedBy,
CreatedDate
)
VALUES
(pname,
pdescription,
picon,
porder,
pstatusid,
pcreatedby,
sysdate
)
  returning ID into IDOUT;
COMMIT;

END TRA_TRAININGMODULE_INSERT;

PROCEDURE TRA_TRAININGMODULE_UPDATE(
  pid IN NUMBER,
  pname IN VARCHAR2,
  pdescription IN VARCHAR2,
  picon IN VARCHAR2,
  porder IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  IDOUT out NUMBER)
  IS
BEGIN
 UPDATE trainingmodule
 SET
 Name = pname
,Description = pdescription
,Icon = picon
,OrderView = porder
,Status = pstatusid
,updatedby = pupdatedby
,updateddate = SYSDATE
WHERE ID = pid;

 IDOUT := SQL%rowcount;

COMMIT;
END TRA_TRAININGMODULE_UPDATE;

PROCEDURE TRA_TRAININGMODULE_UPDATESTATUS(
  pid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  IDOUT out NUMBER)
  IS
BEGIN
 UPDATE trainingmodule
 SET Status = pstatusid
,updatedby = pupdatedby
,updateddate = SYSDATE
WHERE ID = pid;

 IDOUT := SQL%rowcount;

COMMIT;
END TRA_TRAININGMODULE_UPDATESTATUS;
end PKG_TRAINING_MODULE;
/