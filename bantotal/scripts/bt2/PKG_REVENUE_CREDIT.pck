create or replace PACKAGE USRECOSISTEMAS.PKG_REVENUE_CREDIT is
type REV_CURSOR_REVENUE_CREDIT IS REF CURSOR;
 
PROCEDURE REV_REVENUE_CREDIT_INSERT(
prevenueid IN NUMBER,
pamount IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pconcept IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE REV_REVENUE_CREDIT_GET(prevenudid IN NUMBER,cursorRevenueOut OUT REV_CURSOR_REVENUE_CREDIT);

PROCEDURE REV_REVENUE_CREDIT_GET_BY_ID(pid IN NUMBER,cursorRevenueOut OUT REV_CURSOR_REVENUE_CREDIT);

PROCEDURE REV_REVENUE_CREDIT_UPDATE(
pid IN NUMBER,
pamount IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pconcept IN VARCHAR2,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

PROCEDURE REV_REVENUE_CREDIT_UPDATESTATUS(
pid IN NUMBER,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

END PKG_REVENUE_CREDIT;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_REVENUE_CREDIT IS
  
PROCEDURE REV_REVENUE_CREDIT_INSERT(
prevenueid IN NUMBER,
pamount IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pconcept IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER) 
IS
 -- Variables to store data fetched from revenue table
    pname revenue.name%TYPE;
    --punitprice revenue.unitprice%TYPE;
    pquantity revenue.quantity%TYPE;
    pvouchertypeid revenue.vouchertypeid%TYPE;
    pstoreid revenue.storeid%TYPE;
    pcurrencytypeid revenue.currencytypeid%TYPE;
    pproductid revenue.productid%TYPE;
    --ptypeincometransaction revenue.typeincometransaction%TYPE;
  BEGIN
   INSERT INTO revenuecredit (
    REVENUEID,
    AMOUNT, 
    PAYMENTMETHODID, 
    OPERATIONDATE, 
    CONCEPT,
    STATUSID,
    CREATEDBY, 
    CREATEDDATE
    ) 
VALUES
( 
prevenueid,
pamount,
ppaymentmethodid,
poperationdate,
pconcept,
pstatusid,
pcreatedby,
sysdate
)
  returning ID into IDOUT;
  
    -- Fetch data from revenue table based on prevenueid
    SELECT NAME, QUANTITY, VOUCHERTYPEID, STOREID, CURRENCYTYPEID, PRODUCTID--, Typeincometransaction
    INTO pname, pquantity, pvouchertypeid, pstoreid, pcurrencytypeid, pproductid--, ptypeincometransaction
    FROM revenue
    WHERE ID = prevenueid; 
  
INSERT INTO REVENUE (
NAME,
UNITPRICE,
QUANTITY,
VOUCHERTYPEID,
PAYMENTMETHODID,
OPERATIONDATE,
STOREID,
STATUSID,
CREATEDBY,
CREATEDDATE,
UPDATEDBY,
UPDATEDDATE,
CURRENCYTYPEID,
PRODUCTID,
--TYPEINCOMETRANSACTION,
REVENUECREDITID) 
VALUES
(pconcept,
pamount,
1,
pvouchertypeid,
ppaymentmethodid,
poperationdate,
pstoreid,
pstatusid,
pcreatedby,
sysdate,
NULL,
NULL,
pcurrencytypeid,
pproductid,
--ptypeincometransaction,
IDOUT
);
  
COMMIT; 

END REV_REVENUE_CREDIT_INSERT;

PROCEDURE REV_REVENUE_CREDIT_GET(prevenudid IN NUMBER,cursorRevenueOut OUT REV_CURSOR_REVENUE_CREDIT)
IS
BEGIN
 OPEN cursorRevenueOut FOR
 SELECT  
 id,
 concept,
 amount,
 operationdate
 FROM revenuecredit WHERE revenueid = prevenudid and statusid = 1;

END REV_REVENUE_CREDIT_GET;

PROCEDURE REV_REVENUE_CREDIT_GET_BY_ID(pid IN NUMBER,cursorRevenueOut OUT REV_CURSOR_REVENUE_CREDIT)
IS
BEGIN
 OPEN cursorRevenueOut FOR
 SELECT  
 id,
 concept,
 amount,
 operationdate,
 paymentmethodid
 FROM revenuecredit WHERE id = pid and statusid = 1;

END REV_REVENUE_CREDIT_GET_BY_ID;

PROCEDURE REV_REVENUE_CREDIT_UPDATE(
pid IN NUMBER,
pamount IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pconcept IN VARCHAR2,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
   UPDATE REVENUECREDIT SET 
   AMOUNT=pamount,
   PAYMENTMETHODID=ppaymentmethodid, 
   OPERATIONDATE=poperationdate, 
   CONCEPT =pconcept,
   UPDATEDBY = pupdatedby, 
   UPDATEDDATE = sysdate
   WHERE ID = pid;
   rowsOut := SQL%rowcount;
   
   UPDATE REVENUE
   SET UNITPRICE=pamount
   WHERE REVENUECREDITID=pid;
   
   COMMIT; 
END REV_REVENUE_CREDIT_UPDATE;

PROCEDURE REV_REVENUE_CREDIT_UPDATESTATUS(
pid IN NUMBER,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE REVENUECREDIT SET 
   STATUSID=pstatusid,
   UPDATEDBY = pupdatedby, 
   UPDATEDDATE = sysdate
   WHERE ID = pid;
   rowsOut := SQL%rowcount;
   
   UPDATE REVENUE
   SET STATUSID=pstatusid
   WHERE REVENUECREDITID=pid;
   
   COMMIT; 
END REV_REVENUE_CREDIT_UPDATESTATUS;

END PKG_REVENUE_CREDIT;

/