create or replace PACKAGE USRECOSISTEMAS.PKG_EXPENSE is
type FIN_CURSOR_EXPENSE IS REF CURSOR;

PROCEDURE FIN_EXPENSE_INSERT(
pname IN VARCHAR2,
pexpensetypeid NUMBER,
punitprice IN NUMBER,
pquantity IN NUMBER,
pvouchertypeid IN NUMBER,
ppaymentmethodid IN NUMBER,
pcurrencytypeid IN NUMBER,
poperationdate IN DATE,
pstoreid IN NUMBER,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
pdetail in VARCHAR2,
psupplierid in number,
ptypeincometransaction IN NUMBER,
pexpensecreditid IN NUMBER,
IDOUT out NUMBER);

PROCEDURE FIN_EXPENSE_GET_BY_ID(pid IN NUMBER,cursorExpenseOut OUT FIN_CURSOR_EXPENSE);
PROCEDURE FIN_EXPENSE_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
pexpensetypeid NUMBER,
punitprice IN NUMBER,
pquantity IN NUMBER,
pvouchertypeid IN NUMBER,
ppaymentmethodid IN NUMBER,
pcurrencytypeid IN NUMBER,
poperationdate IN DATE,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
pdetail in VARCHAR2,
psupplierid IN NUMBER,
ptypeincometransaction IN NUMBER,
pexpensecreditid IN NUMBER,
rowsOut out NUMBER);
PROCEDURE FIN_EXPENSE_UPDATE_STATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE FIN_EXPENSE_GETALL_BY_STOREID(pstoreid IN NUMBER,pdate IN DATE,prow IN NUMBER, ptotalRecord IN NUMBER,cursorExpenseOut OUT FIN_CURSOR_EXPENSE);
PROCEDURE FIN_EXPENSE_TOTAL_BY_SUPPLIERID(psupplierid IN NUMBER,cursorExpenseOut OUT FIN_CURSOR_EXPENSE);
PROCEDURE FIN_EXPENSE_GETALL_BY_SUPPLIERID(psupplierid IN NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorExpenseOut OUT FIN_CURSOR_EXPENSE);

PROCEDURE FIN_EXPENSEDETAILIMAGE_INSERT(
pexpensedetailid IN NUMBER,
pimageurl IN VARCHAR2,
pimagelink IN VARCHAR2,
pimagedescription IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);
PROCEDURE FIN_EXPENSEDETAILIMAGE_DELETE_BY_EXPENSEDETAILID(pexpensedetailid IN NUMBER,rowsOut out NUMBER);
PROCEDURE FIN_EXPENSEDETAILIMAGE_DELETE_BY_ID(pexpensedetailid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE FIN_EXPENSEDETAILIMAGE_GET_BY_EXPENSEDETAILID(pexpenseDetailId IN NUMBER, cursorOut OUT FIN_CURSOR_EXPENSE);
END PKG_EXPENSE;


/
create or replace package body USRECOSISTEMAS.PKG_EXPENSE is

PROCEDURE FIN_EXPENSE_INSERT(
pname IN VARCHAR2,
pexpensetypeid NUMBER,
punitprice IN NUMBER,
pquantity IN NUMBER,
pvouchertypeid IN NUMBER,
ppaymentmethodid IN NUMBER,
pcurrencytypeid IN NUMBER,
poperationdate IN DATE,
pstoreid IN NUMBER,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
pdetail in VARCHAR2,
psupplierid in number,
ptypeincometransaction IN NUMBER,
pexpensecreditid IN NUMBER,
IDOUT out NUMBER)
IS
BEGIN
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
CURRENCYTYPEID,
DETAIL,
SUPPLIERID,
TYPEINCOMETRANSACTION,
EXPENSECREDITID) 
VALUES
(pname,
pexpensetypeid,
punitprice,
pquantity,
pvouchertypeid,
ppaymentmethodid,
poperationdate,
pstoreid,
pstatusid,
pcreatedby,
sysdate,
pcurrencytypeid,
pdetail,
psupplierid,
ptypeincometransaction,
pexpensecreditid
)
  returning ID into IDOUT;
COMMIT; 
END FIN_EXPENSE_INSERT;

PROCEDURE FIN_EXPENSE_GET_BY_ID(pid IN NUMBER,cursorExpenseOut OUT FIN_CURSOR_EXPENSE)
IS
BEGIN
 OPEN cursorExpenseOut FOR
 SELECT 
 ex.*,
 s.name as SupplierName,
 (ex.quantity * ex.unitprice) as total
 FROM expense ex left join usersupplier s
 on ex.SupplierID = s.Id where ex.id = pid and ex.statusid=1;
END FIN_EXPENSE_GET_BY_ID;

PROCEDURE FIN_EXPENSE_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
pexpensetypeid NUMBER,
punitprice IN NUMBER,
pquantity IN NUMBER,
pvouchertypeid IN NUMBER,
ppaymentmethodid IN NUMBER,
pcurrencytypeid IN NUMBER,
poperationdate IN DATE,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
pdetail in VARCHAR2,
psupplierid IN NUMBER,
ptypeincometransaction IN NUMBER,
pexpensecreditid IN NUMBER,
rowsOut out NUMBER)
IS
v_actuallytypetransaction NUMBER;
v_countabonocredit NUMBER;
BEGIN
  SELECT typeincometransaction INTO v_actuallytypetransaction FROM expense WHERE id = pid;
 SELECT COUNT(*)INTO v_countabonocredit FROM expensecredit WHERE expenseid = pid;
  --si el tipo actual es a credito(2) y viene el tipo a cambiar venta pagada(1) y tiene abonos, no se podra
  IF v_actuallytypetransaction = 2 AND ptypeincometransaction = 1 and v_countabonocredit > 0 THEN
        rowsOut := -1; 
  ELSE     
  UPDATE EXPENSE SET 
  NAME=pname,
  expensetypeid=pexpensetypeid,
  unitprice=punitprice, 
  quantity=pquantity, 
  vouchertypeid =pvouchertypeid,
  paymentmethodid =ppaymentmethodid,
  currencytypeid = pcurrencytypeid,
  operationdate = poperationdate,
  statusid=pstatusid,
  UPDATEDBY = pupdatedby, 
  DETAIL = pdetail,
  SupplierID = psupplierid,
  TYPEINCOMETRANSACTION=ptypeincometransaction,
  EXPENSECREDITID=pexpensecreditid,
  UPDATEDDATE = sysdate WHERE ID = pid;
rowsOut := SQL%rowcount; 
 COMMIT;
 END IF;
END FIN_EXPENSE_UPDATE;

PROCEDURE FIN_EXPENSE_UPDATE_STATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE EXPENSE SET 
  statusid = pstatusid,
  UPDATEDBY = pupdatedby, 
  UPDATEDDATE = sysdate WHERE ID = pid;
rowsOut := SQL%rowcount; 
 COMMIT;
END FIN_EXPENSE_UPDATE_STATUS;

PROCEDURE FIN_EXPENSE_GETALL_BY_STOREID(pstoreid IN NUMBER,pdate IN DATE,prow IN NUMBER, ptotalRecord IN NUMBER,cursorExpenseOut OUT FIN_CURSOR_EXPENSE)
IS
BEGIN
 OPEN cursorExpenseOut FOR
 WITH Expense_GetAll
 as
 (
 select id,name,expenseTypeName,quantity,unitprice,operationdate,createddate,total,detail,voucherTypeName,paymentMethodName,currencyTypeSigla,row_number() over(order by createddate desc) as NroRow from
 (SELECT 
 r.id,
 r.name,
 param4.value1 as expenseTypeName,
 r.quantity,
 r.unitprice,
 r.operationdate,
 r.createddate,
 (r.quantity * r.unitprice) as total,
 r.detail,
 param1.value1 as voucherTypeName,
 param2.value1 as paymentMethodName,
 param3.value2 as currencyTypeSigla
 FROM expense r LEFT JOIN mastertabledetail param1 
 on r.vouchertypeid = param1.idparameter and param1.mastertableid = 14 LEFT JOIN mastertabledetail param2
 on r.paymentmethodid = param2.idparameter and param2.mastertableid = 13 LEFT JOIN mastertabledetail param3
 on r.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN mastertabledetail param4
 on r.expensetypeid=param4.idparameter and param4.mastertableid=16
 where trunc(r.operationdate)= TO_DATE(pdate,'dd-MM-yy') and r.storeid = pstoreid and r.statusid = 1))
 select id,name,expenseTypeName,quantity,unitprice,operationdate,createddate,total,detail,voucherTypeName,paymentMethodName,currencyTypeSigla,NroRow,(select count(*) from Expense_GetAll) as TotalRow from Expense_GetAll where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END FIN_EXPENSE_GETALL_BY_STOREID;

PROCEDURE FIN_EXPENSE_TOTAL_BY_SUPPLIERID(psupplierid IN NUMBER,cursorExpenseOut OUT FIN_CURSOR_EXPENSE)
IS
BEGIN
 OPEN cursorExpenseOut FOR
 select sum(unitPrice * quantity) as TotalExpense from expense where supplierid = psupplierid and statusid = 1
 group by supplierid;
END FIN_EXPENSE_TOTAL_BY_SUPPLIERID;

PROCEDURE FIN_EXPENSE_GETALL_BY_SUPPLIERID(psupplierid IN NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorExpenseOut OUT FIN_CURSOR_EXPENSE)
IS
BEGIN
 OPEN cursorExpenseOut FOR
 WITH Expense_GetAll
 as
 (
 select id,name,expenseTypeName,quantity,unitprice,operationdate,createddate,total,detail,voucherTypeName,paymentMethodName,currencyTypeSigla,row_number() over(order by createddate desc) as NroRow from
 (SELECT 
 r.id,
 r.name,
 param4.value1 as expenseTypeName,
 r.quantity,
 r.unitprice,
 r.operationdate,
 r.createddate,
 (r.quantity * r.unitprice) as total,
 r.detail,
 param1.value1 as voucherTypeName,
 param2.value1 as paymentMethodName,
 param3.value2 as currencyTypeSigla
 FROM expense r LEFT JOIN mastertabledetail param1 
 on r.vouchertypeid = param1.idparameter and param1.mastertableid = 14 LEFT JOIN mastertabledetail param2
 on r.paymentmethodid = param2.idparameter and param2.mastertableid = 13 LEFT JOIN mastertabledetail param3
 on r.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN mastertabledetail param4
 on r.expensetypeid=param4.idparameter and param4.mastertableid=16
 where r.supplierid = psupplierid and r.statusid = 1))
 select id,name,expenseTypeName,quantity,unitprice,operationdate,createddate,total,detail,voucherTypeName,paymentMethodName,currencyTypeSigla,NroRow,(select count(*) from Expense_GetAll) as TotalRow from Expense_GetAll where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END FIN_EXPENSE_GETALL_BY_SUPPLIERID;

PROCEDURE FIN_EXPENSEDETAILIMAGE_INSERT(
pexpensedetailid IN NUMBER,
pimageurl IN VARCHAR2,
pimagelink IN VARCHAR2,
pimagedescription IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN

 INSERT INTO expensedetailimage (
 EXPENSEID
,IMAGEURL
,IMAGELINK
,IMAGEDESCRIPTION
,STATUSID
,CREATEDBY
,CREATEDDATE)
VALUES(
 pexpensedetailid
,pimageurl
,pimagelink
,pimagedescription
,pstatusid
,pcreatedby
,SYSDATE
)
returning ID into IDOUT;

COMMIT;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END FIN_EXPENSEDETAILIMAGE_INSERT;
PROCEDURE FIN_EXPENSEDETAILIMAGE_DELETE_BY_EXPENSEDETAILID(pexpensedetailid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 DELETE FROM EXPENSEDETAILIMAGE WHERE ID = pexpensedetailid;
  rowsOut := SQL%rowcount;
 COMMIT;
END FIN_EXPENSEDETAILIMAGE_DELETE_BY_EXPENSEDETAILID;

PROCEDURE FIN_EXPENSEDETAILIMAGE_DELETE_BY_ID(pexpensedetailid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 DELETE FROM EXPENSEDETAILIMAGE WHERE expenseID = pexpensedetailid;
  rowsOut := SQL%rowcount;
 COMMIT;
END FIN_EXPENSEDETAILIMAGE_DELETE_BY_ID;  

PROCEDURE FIN_EXPENSEDETAILIMAGE_GET_BY_EXPENSEDETAILID(pexpenseDetailId IN NUMBER, cursorOut OUT FIN_CURSOR_EXPENSE)
IS
BEGIN
 OPEN cursorOut FOR
SELECT * FROM ExpenseDetailImage WHERE expenseid = pexpenseDetailId and STATUSID = 1;
END FIN_EXPENSEDETAILIMAGE_GET_BY_EXPENSEDETAILID;
end PKG_EXPENSE;
/