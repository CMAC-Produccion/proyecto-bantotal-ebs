create or replace PACKAGE USRECOSISTEMAS.PKG_REVENUE is
type REV_CURSOR_REVENUE IS REF CURSOR;

PROCEDURE REV_REVENUE_INSERT(
pname IN VARCHAR2,
punitprice IN NUMBER,
pquantity IN NUMBER,
pvouchertypeid IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pstoreid IN NUMBER,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
pcurrencytypeid IN NUMBER,
pproductid IN NUMBER,
ptypeincometransaction IN NUMBER,
pcustomername IN VARCHAR2,
prevenuecreditid IN NUMBER,
pusercustomerid IN NUMBER,
IDOUT out NUMBER);

PROCEDURE REV_REVENUE_GET_BY_ID(pid IN NUMBER,cursorRevenueOut OUT REV_CURSOR_REVENUE);
PROCEDURE REV_REVENUE_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
punitprice IN NUMBER,
pquantity IN NUMBER,
pvouchertypeid IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
puserid IN NUMBER,
pcurrencytypeid IN NUMBER,
pproductid IN NUMBER,
ptypeincometransaction IN NUMBER,
pcustomername IN VARCHAR2,
prevenuecreditid IN NUMBER,
pusercustomerid IN NUMBER,
rowsOut out NUMBER);
PROCEDURE REV_REVENUE_UPDATE_STATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
puserid IN NUMBER,
rowsOut out NUMBER);
PROCEDURE REV_REVENUE_GETALL_BY_STOREID(pstoreid IN NUMBER,pdate IN DATE,prow IN NUMBER, ptotalRecord IN NUMBER,cursorRevenueOut OUT REV_CURSOR_REVENUE);
PROCEDURE REPINV_REPORTINVENTORY_GETBYSTOREANDDATE(pstoreid IN NUMBER,pdate IN VARCHAR2,cursorRevenueOut OUT REV_CURSOR_REVENUE);
PROCEDURE REPINV_REPORTINVENTORY_GETWEEKLY(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,cursorOut OUT REV_CURSOR_REVENUE);
PROCEDURE REPINV_REPORTINVENTORY_GETMONTH(pstoreid IN NUMBER, pmonth IN VARCHAR2,pyear IN VARCHAR2,cursorOut OUT REV_CURSOR_REVENUE);
PROCEDURE SEC_REVENUEDETAILIMAGE_INSERT(
prevenuedetailid IN NUMBER,
pimageurl IN VARCHAR2,
pimagelink IN VARCHAR2,
pimagedescription IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);
PROCEDURE REV_REVENUEDETAILIMAGE_DELETE_BY_REVENUEDETAILID(prevenuedetailid IN NUMBER,rowsOut out NUMBER);
PROCEDURE REV_REVENUEDETAILIMAGE_DELETE_BY_ID(prevenuedetailid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE REV_REVENUEDETAILIMAGE_GET_BY_REVENUEDETAILID(prevenueDetailId IN NUMBER, cursorOut OUT REV_CURSOR_REVENUE);
PROCEDURE REV_REVENUEDETAILPRODUCT_INSERT(
prevenueid IN NUMBER,
pproductid IN NUMBER,
pquantity IN NUMBER,
pprice IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE REV_REVENUEDETAILPRODUCT_GET_BY_REVENUEID(
prevenueid IN NUMBER,
cursorOut OUT REV_CURSOR_REVENUE
);
PROCEDURE REV_REVENUEDETAILPRODUCT_DELETE_BY_REVENUEDETAILID(prevenuedetailid IN NUMBER,pupdatedby IN NUMBER,rowsOut out NUMBER);
PROCEDURE REV_REVENUEDETAILPRODUCT_UPDATE(
pid IN NUMBER,
punitprice IN NUMBER,
pquantity IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
END PKG_REVENUE;
/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_REVENUE IS
 
PROCEDURE REV_REVENUE_INSERT(
pname IN VARCHAR2,
punitprice IN NUMBER,
pquantity IN NUMBER,
pvouchertypeid IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
pstoreid IN NUMBER, 
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
pcurrencytypeid IN NUMBER,
pproductid IN NUMBER,
ptypeincometransaction IN NUMBER,
pcustomername IN VARCHAR2,
prevenuecreditid IN NUMBER,
pusercustomerid IN NUMBER,
IDOUT out NUMBER)
IS 
BEGIN
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
TYPEINCOMETRANSACTION,
CUSTOMERNAME,
REVENUECREDITID,
USERCUSTOMERID,
total) 
VALUES
(pname,
punitprice,
pquantity,
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
ptypeincometransaction,
pcustomername,
prevenuecreditid,
pusercustomerid,
punitprice
)
  returning ID into IDOUT;
COMMIT; 
END REV_REVENUE_INSERT;

PROCEDURE REV_REVENUE_GET_BY_ID(pid IN NUMBER,cursorRevenueOut OUT REV_CURSOR_REVENUE)
IS
BEGIN
 OPEN cursorRevenueOut FOR
 SELECT 
 r.*
 FROM revenue r where r.id = pid;
END REV_REVENUE_GET_BY_ID;

PROCEDURE REV_REVENUE_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
punitprice IN NUMBER,
pquantity IN NUMBER,
pvouchertypeid IN NUMBER,
ppaymentmethodid IN NUMBER,
poperationdate IN DATE,
puserid IN NUMBER,
pcurrencytypeid IN NUMBER,
pproductid IN NUMBER,
ptypeincometransaction IN NUMBER,
pcustomername IN VARCHAR2,
prevenuecreditid IN NUMBER,
pusercustomerid IN NUMBER,
rowsOut out NUMBER)
IS
v_actuallytypetransaction NUMBER;
v_countabonocredit NUMBER;
BEGIN

 SELECT typeincometransaction INTO v_actuallytypetransaction FROM revenue WHERE id = pid;
 SELECT COUNT(*)INTO v_countabonocredit FROM revenuecredit WHERE revenueid = pid;
  --si el tipo actual es a credito(2) y viene el tipo a cambiar venta pagada(1) y tiene abonos, no se podra
  IF v_actuallytypetransaction = 2 AND ptypeincometransaction = 1 and v_countabonocredit > 0 THEN
        rowsOut := -1; 
  ELSE     
      UPDATE REVENUE SET 
      NAME=pname,
      unitprice=punitprice, 
      quantity=pquantity, 
      vouchertypeid =pvouchertypeid,
      paymentmethodid =ppaymentmethodid,
      operationdate = poperationdate,
      currencytypeid = pcurrencytypeid,
      UPDATEDBY = puserid, 
      UPDATEDDATE = sysdate, 
      PRODUCTID=pproductid,
      TYPEINCOMETRANSACTION=ptypeincometransaction,
      CUSTOMERNAME=pcustomername,
      REVENUECREDITID=prevenuecreditid,
      USERCUSTOMERID=pusercustomerid,
      total =punitprice
      WHERE ID = pid;
        rowsOut := SQL%rowcount; 
        COMMIT;

END IF;
    
END REV_REVENUE_UPDATE;

PROCEDURE REV_REVENUE_UPDATE_STATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
puserid IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE REVENUE SET 
  statusid = pstatusid,
  UPDATEDBY = puserid, 
  UPDATEDDATE = sysdate WHERE ID = pid;
rowsOut := SQL%rowcount; 
 COMMIT;
END REV_REVENUE_UPDATE_STATUS;

PROCEDURE REV_REVENUE_GETALL_BY_STOREID(pstoreid IN NUMBER,pdate IN DATE,prow IN NUMBER, ptotalRecord IN NUMBER,cursorRevenueOut OUT REV_CURSOR_REVENUE)
IS
BEGIN
 OPEN cursorRevenueOut FOR
  WITH Revenue_GetAll
 as
 (
 select id,name,quantity,unitprice,operationdate,createddate,total,voucherTypeName,paymentMethodName,currencyTypeSigla,row_number() over(order by createddate desc) as NroRow from
 (SELECT 
 r.id,
 r.name,
 r.quantity,
 r.unitprice,
 r.operationdate,
 r.createddate,
 (r.quantity * r.unitprice) as total,
 param1.value1 as voucherTypeName,
 param2.value1 as paymentMethodName,
 param3.value2 as currencyTypeSigla
 FROM revenue r LEFT JOIN mastertabledetail param1 
 on r.vouchertypeid = param1.idparameter and param1.mastertableid = 14 LEFT JOIN mastertabledetail param2
 on r.paymentmethodid = param2.idparameter and param2.mastertableid = 13 LEFT JOIN mastertabledetail param3
 on r.currencytypeid = param3.idparameter and param3.mastertableid = 15 
 where trunc(r.operationdate)= TO_DATE(pdate,'dd-MM-yy')  and storeid = pstoreid and statusid = 1))
select id,name,quantity,unitprice,operationdate,createddate,total,voucherTypeName,paymentMethodName,currencyTypeSigla,NroRow,(select count(*) from Revenue_GetAll) as TotalRow from Revenue_GetAll where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END REV_REVENUE_GETALL_BY_STOREID;

PROCEDURE REPINV_REPORTINVENTORY_GETBYSTOREANDDATE(pstoreid IN NUMBER,pdate IN VARCHAR2,cursorRevenueOut OUT REV_CURSOR_REVENUE)
  IS
  BEGIN
    OPEN cursorRevenueOut FOR   
    select * from 
    (
        select 
        r.productid,
        r.name, 
        sum(r.quantity) as quantity, 
        sum(r.quantity * r.unitprice) as total, 
        (select pdi.imageurl  from productdetailimage pdi where productdetailid = pd.id and rownum  = 1) as imageurl,
        (Select TRUNC(operationdate) from (select rv.operationdate from revenue rv where rv.productid = r.productid order by rv.operationdate desc) where ROWNUM = 1) as operationdate
        from revenue r inner join productdetail pd  on r.productid = pd.productid
        where r.productid IS NOT NULL AND r.productid > 0 and r.statusid=1 and r.storeid=pstoreid and to_char(r.operationdate,'YYYY-MM-DD') = pdate
        group by r.productid,r.name,pd.productid,pd.id,r.operationdate
        order by quantity desc
    )
where rownum <=3;  
      
END REPINV_REPORTINVENTORY_GETBYSTOREANDDATE;
 
PROCEDURE REPINV_REPORTINVENTORY_GETWEEKLY(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,cursorOut OUT REV_CURSOR_REVENUE)
  IS
  BEGIN
    OPEN cursorOut FOR
     select * from 
    (
     select 
        r.productid,
        r.name, 
        sum(r.quantity) as quantity, 
        sum(r.quantity * r.unitprice) as total, 
        (select pdi.imageurl  from productdetailimage pdi where productdetailid = pd.id and rownum  = 1) as imageurl
       -- (Select TRUNC(operationdate) from (select rv.operationdate from revenue rv where rv.productid = r.productid order by rv.operationdate desc) where ROWNUM = 1) as operationdate
        from revenue r inner join productdetail pd  on r.productid = pd.productid 
        where r.productid IS NOT NULL AND r.productid > 0 and r.statusid=1 and r.storeid=pstoreid and to_char(operationdate,'YYYY-MM-DD') >= pdatestart and  to_char(operationdate,'YYYY-MM-DD') <= pdateend
        group by r.productid,r.name,pd.productid,pd.id,r.operationdate
        order by quantity desc
       -- order by operationdate desc
        )
    where rownum <=3;  
  END REPINV_REPORTINVENTORY_GETWEEKLY; 
  
PROCEDURE REPINV_REPORTINVENTORY_GETMONTH(pstoreid IN NUMBER, pmonth IN VARCHAR2,pyear IN VARCHAR2,cursorOut OUT REV_CURSOR_REVENUE)
  IS
  BEGIN
    OPEN cursorOut FOR
   select * from 
    (
     select 
        r.productid,
        r.name, 
        sum(r.quantity) as quantity, 
        sum(r.quantity * r.unitprice) as total, 
        (select pdi.imageurl  from productdetailimage pdi where productdetailid = pd.id and rownum  = 1) as imageurl,
        (Select TRUNC(operationdate) from (select rv.operationdate from revenue rv where rv.productid = r.productid order by rv.operationdate desc) where ROWNUM = 1) as operationdate
        from revenue r inner join productdetail pd  on r.productid = pd.productid 
        where r.productid IS NOT NULL AND r.productid > 0 and r.statusid=1 and r.storeid=pstoreid and to_char(operationdate,'MM') = pmonth and to_char(operationdate,'YYYY')= pyear
        group by r.productid,r.name,pd.productid,pd.id,r.operationdate
         order by quantity desc
        )
    where rownum <=3;

  END REPINV_REPORTINVENTORY_GETMONTH;  
  PROCEDURE SEC_REVENUEDETAILIMAGE_INSERT(
prevenuedetailid IN NUMBER,
pimageurl IN VARCHAR2,
pimagelink IN VARCHAR2,
pimagedescription IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN

 INSERT INTO revenuedetailimage (
 REVENUEID
,IMAGEURL
,IMAGELINK
,IMAGEDESCRIPTION
,STATUSID
,CREATEDBY
,CREATEDDATE)
VALUES(
 prevenuedetailid
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

END SEC_REVENUEDETAILIMAGE_INSERT;
PROCEDURE REV_REVENUEDETAILIMAGE_DELETE_BY_REVENUEDETAILID(prevenuedetailid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 DELETE FROM REVENUEDETAILIMAGE WHERE ID = prevenuedetailid;
  rowsOut := SQL%rowcount;
 COMMIT;
END REV_REVENUEDETAILIMAGE_DELETE_BY_REVENUEDETAILID;

PROCEDURE REV_REVENUEDETAILIMAGE_DELETE_BY_ID(prevenuedetailid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 DELETE FROM REVENUEDETAILIMAGE WHERE revenueID = prevenuedetailid;
  rowsOut := SQL%rowcount;
 COMMIT;
END REV_REVENUEDETAILIMAGE_DELETE_BY_ID;  

PROCEDURE REV_REVENUEDETAILIMAGE_GET_BY_REVENUEDETAILID(prevenueDetailId IN NUMBER, cursorOut OUT REV_CURSOR_REVENUE)
IS
BEGIN
 OPEN cursorOut FOR
SELECT * FROM RevenueDetailImage WHERE revenueid = prevenueDetailId and STATUSID = 1;
END REV_REVENUEDETAILIMAGE_GET_BY_REVENUEDETAILID;

PROCEDURE REV_REVENUEDETAILPRODUCT_INSERT(
prevenueid IN NUMBER,
pproductid IN NUMBER,
pquantity IN NUMBER,
pprice IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN

 INSERT INTO RevenueDetailProduct (
 REVENUEID
,PRODUCTID
,QUANTITY
,PRICE
,STATUSID
,CREATEDBY
,CREATEDDATE)
VALUES(
 prevenueid
,pproductid
,pquantity
,pprice
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

END REV_REVENUEDETAILPRODUCT_INSERT;

PROCEDURE REV_REVENUEDETAILPRODUCT_GET_BY_REVENUEID(
prevenueid IN NUMBER,
cursorOut OUT REV_CURSOR_REVENUE
)
 IS
  BEGIN
    OPEN cursorOut FOR
   select 
   rdet.*,
   pr.name as productName,
   pd.stock,
   (rdet.quantity * rdet.price) as subTotal,
   (select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=pd.Id and rownum=1) as ImageUrl
   from revenuedetailproduct rdet inner join product pr 
   on rdet.productid =pr.id inner join productdetail pd
   on pr.id = pd.productid
   where rdet.revenueid = prevenueid and rdet.statusid = 1;
END REV_REVENUEDETAILPRODUCT_GET_BY_REVENUEID;
PROCEDURE REV_REVENUEDETAILPRODUCT_DELETE_BY_REVENUEDETAILID(prevenuedetailid IN NUMBER,pupdatedby IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
  UPDATE REVENUEDETAILPRODUCT SET STATUSID = 2, updatedby =pupdatedby, updateddate = sysdate  WHERE ID = prevenuedetailid;
  rowsOut := SQL%rowcount;
 COMMIT;
END REV_REVENUEDETAILPRODUCT_DELETE_BY_REVENUEDETAILID;

PROCEDURE REV_REVENUEDETAILPRODUCT_UPDATE(
pid IN NUMBER,
punitprice IN NUMBER,
pquantity IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
   UPDATE REVENUEDETAILPRODUCT SET 
      price=punitprice, 
      quantity=pquantity, 
      UPDATEDBY = pupdatedby, 
      UPDATEDDATE = sysdate
      WHERE ID = pid;
        rowsOut := SQL%rowcount; 
        COMMIT;

    
END REV_REVENUEDETAILPRODUCT_UPDATE;

END PKG_REVENUE;
/