create or replace PACKAGE USRECOSISTEMAS.PKG_EXPENSE_CREDIT is
type EXP_CURSOR_EXPENSE_CREDIT IS REF CURSOR;

PROCEDURE EXP_EXPENSE_CREDIT_INSERT(
pexpenseid IN NUMBER,
pamount IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pconcept IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE EXP_EXPENSE_CREDIT_GET(pexpenseid IN NUMBER,cursorExpenseOut OUT EXP_CURSOR_EXPENSE_CREDIT);

PROCEDURE EXP_EXPENSE_CREDIT_GET_BY_ID(pid IN NUMBER,cursorExpenseOut OUT EXP_CURSOR_EXPENSE_CREDIT);

PROCEDURE EXP_EXPENSE_CREDIT_UPDATE(
pid IN NUMBER,
pamount IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pconcept IN VARCHAR2,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

PROCEDURE EXP_EXPENSE_CREDIT_UPDATESTATUS(
pid IN NUMBER,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

END PKG_EXPENSE_CREDIT;


/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_EXPENSE_CREDIT IS

PROCEDURE EXP_EXPENSE_CREDIT_INSERT(
pexpenseid IN NUMBER,
pamount IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pconcept IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS
 -- Variables to store data fetched from revenue table
    pname expense.name%TYPE;
    pexpensetype expense.expensetypeid%TYPE;
    --punitprice revenue.unitprice%TYPE;
    pquantity expense.quantity%TYPE;
    pvouchertypeid expense.vouchertypeid%TYPE;
    pstoreid expense.storeid%TYPE;
    pcurrencytypeid expense.currencytypeid%TYPE;
    psuplierid expense.supplierid%TYPE;
    --ptypeincometransaction revenue.typeincometransaction%TYPE;
  BEGIN
   INSERT INTO expensecredit (
    EXPENSEID,
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
pexpenseid,
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
    SELECT NAME,EXPENSETYPEID, QUANTITY, VOUCHERTYPEID, STOREID, CURRENCYTYPEID, SUPPLIERID--, Typeincometransaction
    INTO pname,pexpensetype, pquantity, pvouchertypeid, pstoreid, pcurrencytypeid, psuplierid--, ptypeincometransaction
    FROM expense
    WHERE ID = pexpenseid;

INSERT INTO EXPENSE (
NAME,
EXPENSETYPEID,
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
SUPPLIERID,
--TYPEINCOMETRANSACTION,
EXPENSECREDITID)
VALUES
(
pconcept,
pexpensetype,
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
psuplierid,
--ptypeincometransaction,
IDOUT
);

COMMIT;

END EXP_EXPENSE_CREDIT_INSERT;

PROCEDURE EXP_EXPENSE_CREDIT_GET(pexpenseid IN NUMBER,cursorExpenseOut OUT EXP_CURSOR_EXPENSE_CREDIT)
IS
BEGIN
 OPEN cursorExpenseOut FOR
 SELECT
 id,
 concept,
 amount,
 operationdate
 FROM expensecredit WHERE expenseid = pexpenseid and statusid = 1;

END EXP_EXPENSE_CREDIT_GET;

PROCEDURE EXP_EXPENSE_CREDIT_GET_BY_ID(pid IN NUMBER,cursorExpenseOut OUT EXP_CURSOR_EXPENSE_CREDIT)
IS
BEGIN
 OPEN cursorExpenseOut FOR
 SELECT
 id,
 concept,
 amount,
 operationdate,
 paymentmethodid
 FROM expensecredit WHERE id = pid and statusid = 1;

END EXP_EXPENSE_CREDIT_GET_BY_ID;

PROCEDURE EXP_EXPENSE_CREDIT_UPDATE(
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
   UPDATE EXPENSECREDIT SET
   AMOUNT=pamount,
   PAYMENTMETHODID=ppaymentmethodid,
   OPERATIONDATE=poperationdate,
   CONCEPT =pconcept,
   UPDATEDBY = pupdatedby,
   UPDATEDDATE = sysdate
   WHERE ID = pid;
   rowsOut := SQL%rowcount;

   UPDATE EXPENSE
   SET UNITPRICE=pamount
   WHERE EXPENSECREDITID=pid;

   COMMIT;
END EXP_EXPENSE_CREDIT_UPDATE;

PROCEDURE EXP_EXPENSE_CREDIT_UPDATESTATUS(
pid IN NUMBER,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE EXPENSECREDIT SET
   STATUSID=pstatusid,
   UPDATEDBY = pupdatedby,
   UPDATEDDATE = sysdate
   WHERE ID = pid;
   rowsOut := SQL%rowcount;

   UPDATE EXPENSE
   SET STATUSID=pstatusid
   WHERE EXPENSECREDITID=pid;

   COMMIT;
END EXP_EXPENSE_CREDIT_UPDATESTATUS;

END PKG_EXPENSE_CREDIT;

/