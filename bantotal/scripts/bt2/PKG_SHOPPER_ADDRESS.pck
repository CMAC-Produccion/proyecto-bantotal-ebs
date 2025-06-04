create or replace PACKAGE USRECOSISTEMAS.PKG_SHOPPER_ADDRESS is

type SA_CURSOR_SHOPPERADDRESS IS REF CURSOR;

PROCEDURE SA_SHOPPER_ADDRESS_INSERT( 
ptype IN NUMBER, 
puserid IN NUMBER,
pdescription IN VARCHAR2,
pdistrictid IN VARCHAR2,
ppreference IN VARCHAR2,
preceive IN NUMBER,
pname IN VARCHAR2,
plastname IN VARCHAR2,
pdocumenttypeid  IN NUMBER,
pdocumentnumber IN VARCHAR2,
pcellphone IN VARCHAR2,
pisdefault IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE SA_SHOPPER_ADDRESS_UPDATE(
pid IN NUMBER, 
ptype IN NUMBER,
pdescription IN VARCHAR2,
pdistrictid IN VARCHAR2,
ppreference IN VARCHAR2,
preceive IN NUMBER,
pname IN VARCHAR2,
plastname IN VARCHAR2,
pdocumenttypeid  IN NUMBER,
pdocumentnumber IN VARCHAR2,
pcellphone IN VARCHAR2,
pisdefault IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

PROCEDURE SA_SHOPPER_ADDRESS_UPDATESTATUS(pid IN NUMBER, pstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE SA_SHOPPER_ADDRESS_GET_DEFAULT(puserid IN NUMBER, cursorOut OUT SA_CURSOR_SHOPPERADDRESS);
PROCEDURE SA_SHOPPER_ADDRESS_GET_BYID(pid IN NUMBER, cursorOut OUT SA_CURSOR_SHOPPERADDRESS);
PROCEDURE SA_SHOPPER_ADDRESS_GET_ALL(puserid IN NUMBER, cursorOut OUT SA_CURSOR_SHOPPERADDRESS);
PROCEDURE SA_SHOPPER_ADDRESS_UPDATEDEFAULT(pid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);

END PKG_SHOPPER_ADDRESS;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_SHOPPER_ADDRESS is

PROCEDURE SA_SHOPPER_ADDRESS_INSERT( 
ptype IN NUMBER, 
puserid IN NUMBER,
pdescription IN VARCHAR2,
pdistrictid IN VARCHAR2,
ppreference IN VARCHAR2,
preceive IN NUMBER,
pname IN VARCHAR2,
plastname IN VARCHAR2,
pdocumenttypeid  IN NUMBER,
pdocumentnumber IN VARCHAR2,
pcellphone IN VARCHAR2,
pisdefault IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN
 UPDATE shopperaddress SET ISDEFAULT = 0 where userid = puserid;

 INSERT INTO shopperaddress (
TYPE
,USERID
,DESCRIPTION
,DISTRICTID
,REFERENCE
,RECEIVE
,NAME
,LASTNAME
,DOCUMENTTYPEID
,DOCUMENTNUMBER
,CELLPHONE
,ISDEFAULT
,STATUSID
,CREATEDBY
,CREATEDDATE
)  
VALUES
(
ptype
,puserid
,pdescription
,pdistrictid
,ppreference
,preceive
,pname
,plastname
,pdocumenttypeid
,pdocumentnumber
,pcellphone
,1
,pstatusid
,pcreatedby
,SYSDATE
)
returning ID into IDOUT;

END SA_SHOPPER_ADDRESS_INSERT;

PROCEDURE SA_SHOPPER_ADDRESS_UPDATE(
pid IN NUMBER, 
ptype IN NUMBER,
pdescription IN VARCHAR2,
pdistrictid IN VARCHAR2,
ppreference IN VARCHAR2,
preceive IN NUMBER,
pname IN VARCHAR2,
plastname IN VARCHAR2,
pdocumenttypeid  IN NUMBER,
pdocumentnumber IN VARCHAR2,
pcellphone IN VARCHAR2,
pisdefault IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE shopperaddress SET 
  TYPE=ptype,
  DESCRIPTION=pdescription,
  DISTRICTID=pdistrictid,
  REFERENCE=ppreference,
  RECEIVE=preceive,
  NAME=pname,
  LASTNAME=plastname,
  DOCUMENTTYPEID=pdocumenttypeid,
  DOCUMENTNUMBER=pdocumentnumber,
  CELLPHONE=pcellphone,
  ISDEFAULT=pisdefault,
  STATUSID = pstatusid, 
  UPDATEDBY = pupdatedby, 
  UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount;
COMMIT;
END SA_SHOPPER_ADDRESS_UPDATE;

PROCEDURE SA_SHOPPER_ADDRESS_UPDATESTATUS(pid IN NUMBER, pstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE shopperaddress SET STATUSID = pstatusid, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount; 
 COMMIT; 
END SA_SHOPPER_ADDRESS_UPDATESTATUS;

PROCEDURE SA_SHOPPER_ADDRESS_GET_DEFAULT(puserid IN NUMBER, cursorOut OUT SA_CURSOR_SHOPPERADDRESS)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT 
  sa.id,
  sa.description,
  sa.name,
  sa.lastname,
  param1.value1 as typeAddress,
  dep.name as departmentName,
  d.name as districtName,
  p.name as provinceName
  FROM SHOPPERADDRESS sa INNER JOIN district d
  on sa.districtid = d.id INNER JOIN province p 
  on p.id = d.provinceid INNER JOIN department dep 
  on dep.id = p.departmentid LEFT JOIN mastertabledetail param1
  on sa.type = param1.idparameter and param1.mastertableid = 17 
  WHERE sa.userid = puserid and sa.statusid = 1 and sa.isdefault = 1;
END SA_SHOPPER_ADDRESS_GET_DEFAULT;

PROCEDURE SA_SHOPPER_ADDRESS_GET_BYID(pid IN NUMBER, cursorOut OUT SA_CURSOR_SHOPPERADDRESS)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT
  sa.*,
  param1.value1 as typeAddress,
  dep.name as departmentName,
  d.name as districtName,
  p.name as provinceName,
  dep.id as departmentId,
  p.id as provinceId
  FROM SHOPPERADDRESS sa INNER JOIN district d
  on sa.districtid = d.id INNER JOIN province p 
  on p.id = d.provinceid INNER JOIN department dep 
  on dep.id = p.departmentid LEFT JOIN mastertabledetail param1
  on sa.type = param1.idparameter and param1.mastertableid = 17 
  WHERE sa.statusid = 1 and sa.id = pid;
END SA_SHOPPER_ADDRESS_GET_BYID;

PROCEDURE SA_SHOPPER_ADDRESS_GET_ALL(puserid IN NUMBER, cursorOut OUT SA_CURSOR_SHOPPERADDRESS)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT 
  sa.id,
  sa.description,
  sa.name,
  sa.lastname,
  param1.value1 as typeAddress,
  dep.name as departmentName,
  d.name as districtName,
  p.name as provinceName,
  sa.isdefault,
  dep.id as departmentID,
  p.id as provinceID,
  sa.*
  FROM SHOPPERADDRESS sa INNER JOIN district d
  on sa.districtid = d.id INNER JOIN province p 
  on p.id = d.provinceid INNER JOIN department dep 
  on dep.id = p.departmentid LEFT JOIN mastertabledetail param1
  on sa.type = param1.idparameter and param1.mastertableid = 17 
  WHERE sa.userid = puserid and sa.statusid = 1 order by sa.isdefault desc,sa.createddate desc;
END SA_SHOPPER_ADDRESS_GET_ALL;

PROCEDURE SA_SHOPPER_ADDRESS_UPDATEDEFAULT(pid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE shopperaddress SET ISDEFAULT = 0 where userid = puserid;
 UPDATE shopperaddress SET ISDEFAULT = 1, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount; 
 COMMIT; 
END SA_SHOPPER_ADDRESS_UPDATEDEFAULT;

END PKG_SHOPPER_ADDRESS;
/