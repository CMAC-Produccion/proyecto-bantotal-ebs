create or replace package USRECOSISTEMAS.PKG_VENDOR_PAYMENTMETHOD is

type SA_CURSOR_VENDORPAYMENTMETHOD IS REF CURSOR;

PROCEDURE SA_VENDOR_PAYMENTMETHOD_INSERT(
puserid IN NUMBER,
ppaymentmethodid IN NUMBER,
porderpickuptimeid IN NUMBER,
porderpickuptime IN VARCHAR2,
pinstruction IN VARCHAR2,
pisactive IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE SA_VENDOR_PAYMENTMETHOD_UPDATE(
pid IN NUMBER,
porderpickuptimeid IN NUMBER,
porderpickuptime IN VARCHAR2,
pinstruction IN VARCHAR2,
pisactive IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

PROCEDURE SA_VENDOR_PAYMENTMETHOD_UPDATESTATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

PROCEDURE SA_VENDOR_PAYMENTMETHOD_UPDATEACTIVE(
pid IN NUMBER,
pisactive IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

PROCEDURE SA_VENDOR_PAYMENTMETHOD_GET_BYID(pid IN NUMBER, cursorOut OUT SA_CURSOR_VENDORPAYMENTMETHOD);

PROCEDURE SA_VENDOR_PAYMENTMETHOD_GET_BYVENDORID(puserid IN NUMBER, cursorOut OUT SA_CURSOR_VENDORPAYMENTMETHOD);

end PKG_VENDOR_PAYMENTMETHOD;


/
create or replace package body USRECOSISTEMAS.PKG_VENDOR_PAYMENTMETHOD is

PROCEDURE SA_VENDOR_PAYMENTMETHOD_INSERT(
puserid IN NUMBER,
ppaymentmethodid IN NUMBER,
porderpickuptimeid IN NUMBER,
porderpickuptime IN VARCHAR2,
pinstruction IN VARCHAR2,
pisactive IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN

INSERT INTO VENDORPAYMENTMETHOD (
USERID
,PAYMENTMETHODID
,ORDERPICKUPTIMEID
,ORDERPICKUPTIME
,INSTRUCTION
,ISACTIVE
,STATUSID
,CREATEDBY
,CREATEDDATE
)
VALUES
(
puserid
,ppaymentmethodid
,porderpickuptimeid
,porderpickuptime
,pinstruction
,pisactive
,pstatusid
,pcreatedby
,SYSDATE
)

returning ID into IDOUT;

END SA_VENDOR_PAYMENTMETHOD_INSERT;


PROCEDURE SA_VENDOR_PAYMENTMETHOD_UPDATE(
pid IN NUMBER,
porderpickuptimeid IN NUMBER,
porderpickuptime IN VARCHAR2,
pinstruction IN VARCHAR2,
pisactive IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN

  UPDATE VENDORPAYMENTMETHOD SET
  ORDERPICKUPTIMEID=porderpickuptimeid,
  ORDERPICKUPTIME=porderpickuptime,
  INSTRUCTION=pinstruction,
  ISACTIVE=pisactive,
  STATUSID = pstatusid,
  UPDATEDBY = pupdatedby,
  UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount;
  COMMIT;

END SA_VENDOR_PAYMENTMETHOD_UPDATE;

PROCEDURE SA_VENDOR_PAYMENTMETHOD_UPDATESTATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN

UPDATE VENDORPAYMENTMETHOD SET STATUSID = pstatusid, UPDATEDBY = pupdatedby, UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;

END SA_VENDOR_PAYMENTMETHOD_UPDATESTATUS;

PROCEDURE SA_VENDOR_PAYMENTMETHOD_UPDATEACTIVE(
pid IN NUMBER,
pisactive IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN

UPDATE VENDORPAYMENTMETHOD SET ISACTIVE = pisactive, UPDATEDBY = pupdatedby, UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;

END SA_VENDOR_PAYMENTMETHOD_UPDATEACTIVE;

PROCEDURE SA_VENDOR_PAYMENTMETHOD_GET_BYID(pid IN NUMBER, cursorOut OUT SA_CURSOR_VENDORPAYMENTMETHOD)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT
  sa.id,
  sa.userid,
  sa.paymentmethodid,
  param1.value1 as paymentmethodname,
  sa.orderpickuptimeid,
  param2.value1 as orderpickuptimename,
  sa.orderpickuptime,
  sa.instruction,
  sa.isactive
  FROM VENDORPAYMENTMETHOD sa LEFT JOIN mastertabledetail param1
  on sa.paymentmethodid = param1.idparameter and param1.mastertableid = 19
  LEFT JOIN mastertabledetail param2
  on sa.orderpickuptimeid = param2.idparameter and param2.mastertableid = 20
  WHERE sa.id = pid and sa.statusid = 1;
END SA_VENDOR_PAYMENTMETHOD_GET_BYID;

PROCEDURE SA_VENDOR_PAYMENTMETHOD_GET_BYVENDORID(puserid IN NUMBER, cursorOut OUT SA_CURSOR_VENDORPAYMENTMETHOD)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT
  sa.id,
  sa.userid,
  sa.paymentmethodid,
  param1.value1 as paymentmethodname,
  sa.orderpickuptimeid,
  param2.value1 as orderpickuptimename,
  sa.orderpickuptime,
  sa.instruction,
  sa.isactive
  FROM VENDORPAYMENTMETHOD sa LEFT JOIN mastertabledetail param1
  on sa.paymentmethodid = param1.idparameter and param1.mastertableid = 19
  LEFT JOIN mastertabledetail param2
  on sa.orderpickuptimeid = param2.idparameter and param2.mastertableid = 20
  WHERE sa.userid = puserid and sa.statusid = 1;

END SA_VENDOR_PAYMENTMETHOD_GET_BYVENDORID;

end PKG_VENDOR_PAYMENTMETHOD;

/