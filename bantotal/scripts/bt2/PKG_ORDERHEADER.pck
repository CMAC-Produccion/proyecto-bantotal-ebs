create or replace PACKAGE USRECOSISTEMAS.PKG_ORDERHEADER is
type FIN_CURSOR_ORDERHEADER IS REF CURSOR;
PROCEDURE ORDERHEADER_INSERT(
puserid NUMBER,
pdeliverytype IN NUMBER,
pordernumber IN VARCHAR2,
pshippingcost IN NUMBER,
ppaymentmethod IN NUMBER,
ptax IN NUMBER,
ptotal IN NUMBER,
porderdate IN DATE,
porderstatus  IN NUMBER,
pvendorid IN NUMBER,
pcreatedby IN NUMBER,

pproductid NUMBER,
puniteprice IN NUMBER,
pofferprice IN NUMBER,
pnormalprice IN NUMBER,
pquantity IN NUMBER,
pdiscount IN NUMBER, 

ptype NUMBER,
pdescription IN VARCHAR2,
pdistrictid IN NUMBER,
preference IN VARCHAR2,
preceive IN NUMBER,
pname IN VARCHAR2,
plastname IN VARCHAR2,
pdocumenttypeid  IN NUMBER,
pdocumentnumber  IN VARCHAR2,
pcellphone  IN VARCHAR2,
pstatusid  IN NUMBER,
IDOUT out NUMBER

);


PROCEDURE ORDERHEADER_INSERT_XML(
puserid NUMBER,
pdeliverytype IN NUMBER,
pordernumber IN VARCHAR2,
pshippingcost IN NUMBER,
ppaymentmethod IN NUMBER,
ptax IN NUMBER,
ptotal IN NUMBER,
porderdate IN DATE,
porderstatus  IN NUMBER,
pvendorid IN NUMBER,
pcreatedby IN NUMBER,
pproductsxml IN XMLTYPE,
ptype NUMBER,
pdescription IN VARCHAR2,
pdistrictid IN NUMBER,
preference IN VARCHAR2,
preceive IN NUMBER,
pname IN VARCHAR2,
plastname IN VARCHAR2,
pdocumenttypeid  IN NUMBER,
pdocumentnumber  IN VARCHAR2,
pcellphone  IN VARCHAR2,
pstatusid  IN NUMBER,
pshoppingcartid IN NUMBER,
pruc IN VARCHAR2,
pcompanyname IN VARCHAR2,
IDOUT out NUMBER
);

PROCEDURE ORDERHEADER_UPDATEORDERSTATUS(pid IN NUMBER, porderstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);

PROCEDURE ORDERHEADER_GET_BYID(pid IN NUMBER, cursorOut OUT FIN_CURSOR_ORDERHEADER);

PROCEDURE ORDERHEADER_GETBYFILTER_PAGINATED(pvendorid IN number,pshopperid IN number,porderstatusid IN number,pfilter IN varchar2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT FIN_CURSOR_ORDERHEADER);

PROCEDURE ORDERHEADER_GETBYFILTER_ADMIN_PAGINATED(puserid IN NUMBER,pstorename IN varchar2,pordernumber IN varchar2,porderstatusid IN number,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT FIN_CURSOR_ORDERHEADER);
PROCEDURE ORDERHEADER_ADMIN_GET_BYID(pid IN NUMBER, cursorOut OUT FIN_CURSOR_ORDERHEADER);

END PKG_ORDERHEADER;
/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_ORDERHEADER IS
PROCEDURE ORDERHEADER_INSERT(
puserid NUMBER,
pdeliverytype IN NUMBER,
pordernumber IN VARCHAR2, 
pshippingcost IN NUMBER,
ppaymentmethod IN NUMBER,
ptax IN NUMBER,
ptotal IN NUMBER,
porderdate IN DATE,
porderstatus  IN NUMBER,
pvendorid IN NUMBER,
pcreatedby IN NUMBER,

pproductid NUMBER,
puniteprice IN NUMBER,
pofferprice IN NUMBER,
pnormalprice IN NUMBER,
pquantity IN NUMBER,
pdiscount IN NUMBER, 

ptype NUMBER,
pdescription IN VARCHAR2,
pdistrictid IN NUMBER,
preference IN VARCHAR2,
preceive IN NUMBER,
pname IN VARCHAR2,
plastname IN VARCHAR2,
pdocumenttypeid  IN NUMBER,
pdocumentnumber  IN VARCHAR2,
pcellphone  IN VARCHAR2,
pstatusid  IN NUMBER,

IDOUT out NUMBER)
IS
BEGIN
 
savepoint start_point;

 INSERT INTO ORDERHEADER (
USERID,
DELIVERYTYPE,
ORDERNUMBER,
SHIPPINGCOST,
PAYMENTMETHOD,
TAX,
TOTAL,
ORDERDATE,
ORDERSTATUS,
VENDORID,
CREATEDBY,
CREATEDDATE,
STATUSID) 
VALUES
(
puserid,
pdeliverytype,
'ORD0000'||to_char(ORDERHEADER_SEQ.nextval + 1) ,
pshippingcost,
ppaymentmethod,
ptax,
ptotal,
sysdate,
porderstatus,
pvendorid,
pcreatedby,
sysdate,
pstatusid
)

 returning ID into IDOUT;
 
INSERT INTO orderdetail ( 
ORDERID,
PRODUCTID, 
UNITPRICE,
NORMALPRICE,
OFFERPRICE,
QUANTITY,
DISCOUNT,
CREATEDBY,
CREATEDDATE) 
VALUES
(
IDOUT,
pproductid,
puniteprice,
pnormalprice,
pofferprice,
pquantity,
pdiscount,
pcreatedby,
sysdate
);
 
 update productdetail set stock = stock - pquantity where productid = pproductid;
 
if(pdeliverytype = 1)
 then
 INSERT INTO ORDERDETAILADDRESS (
ORDERID,
TYPE,
USERID,
DESCRIPTION,
DISTRICTID,
REFERENCE,
RECEIVE,
NAME,
LASTNAME,
DOCUMENTTYPEID,
DOCUMENTNUMBER,
CELLPHONE,  
STATUSID,
CREATEDBY,
CREATEDDATE) 
VALUES
(
IDOUT,
ptype,
puserId,
pdescription,
pdistrictid,
preference,
preceive,
pname,
plastname,
pdocumenttypeid,
pdocumentnumber,
pcellphone,
pstatusid,
pcreatedby, 
sysdate
);
end if;
  
COMMIT;
exception when others then
   rollback to start_point;
   commit; 

END ORDERHEADER_INSERT;

PROCEDURE ORDERHEADER_INSERT_XML(
puserid NUMBER,
pdeliverytype IN NUMBER,
pordernumber IN VARCHAR2,
pshippingcost IN NUMBER,
ppaymentmethod IN NUMBER,
ptax IN NUMBER,
ptotal IN NUMBER,
porderdate IN DATE,
porderstatus  IN NUMBER,
pvendorid IN NUMBER,
pcreatedby IN NUMBER,
pproductsxml IN XMLTYPE,
ptype NUMBER,
pdescription IN VARCHAR2,
pdistrictid IN NUMBER,
preference IN VARCHAR2,
preceive IN NUMBER,
pname IN VARCHAR2,
plastname IN VARCHAR2,
pdocumenttypeid  IN NUMBER,
pdocumentnumber  IN VARCHAR2,
pcellphone  IN VARCHAR2,
pstatusid  IN NUMBER,
pshoppingcartid IN NUMBER,
pruc IN VARCHAR2,
pcompanyname IN VARCHAR2,
IDOUT out NUMBER
)
IS
v_count NUMBER;

            
CURSOR c_products IS
        SELECT x.productid,x.unitprice,x.normalprice,x.offerprice,x.quantity,x.discount,x.shoppingcartdetailid
        FROM XMLTABLE('/products/product' PASSING pproductsxml
            COLUMNS 
                productid NUMBER PATH 'productid',
                unitprice VARCHAR2(255) PATH 'unitprice',
                normalprice VARCHAR2(255) PATH 'normalprice',
                offerprice VARCHAR2(255) PATH 'offerprice',
                quantity NUMBER PATH 'quantity',
                discount VARCHAR2(255) PATH 'discount',
                shoppingcartdetailid NUMBER PATH 'shoppingcartdetailid'
        ) x;
BEGIN
  
    -- Insertar en ORDERHEADER
    INSERT INTO ORDERHEADER (
        USERID,
        DELIVERYTYPE,
        ORDERNUMBER,
        SHIPPINGCOST,
        PAYMENTMETHOD,
        TAX,
        TOTAL,
        ORDERDATE,
        ORDERSTATUS,
        VENDORID,
        CREATEDBY,
        CREATEDDATE,
        STATUSID,
        RUC,
        COMPANYNAME
    ) 
    VALUES (
        puserid,
        pdeliverytype,
        'ORD0000' || TO_CHAR(ORDERHEADER_SEQ.NEXTVAL + 1),
        pshippingcost,
        ppaymentmethod,
        ptax,
        ptotal,
        SYSDATE,
        porderstatus,
        pvendorid,
        pcreatedby,
        SYSDATE,
        pstatusid,
        pruc,
        pcompanyname
    )
    RETURNING ID INTO IDOUT;

    
    FOR product_rec IN c_products LOOP
        INSERT INTO ORDERDETAIL ( 
            ORDERID,
            PRODUCTID, 
            UNITPRICE,
            NORMALPRICE,
            OFFERPRICE,
            QUANTITY,
            DISCOUNT,
            CREATEDBY,
            CREATEDDATE
        ) 
        VALUES (
            IDOUT,
            product_rec.productid,
            TO_NUMBER(product_rec.unitprice, '9999999999D99', 'nls_numeric_characters = ''.,'''),
            TO_NUMBER(product_rec.normalprice, '9999999999D99', 'nls_numeric_characters = ''.,'''),
            TO_NUMBER(product_rec.offerprice, '9999999999D99', 'nls_numeric_characters = ''.,'''),
            product_rec.quantity,
            TO_NUMBER(product_rec.discount, '9999999999D99', 'nls_numeric_characters = ''.,'''),
            pcreatedby,
            SYSDATE
        );
        
        UPDATE productdetail
        SET stock = stock - product_rec.quantity
        WHERE productid = product_rec.productid;
          
        UPDATE shoppingcartdetail
        set statusid=2,
        updatedby=pcreatedby,
        updateddate=sysdate
        where id=product_rec.shoppingcartdetailid;
        
        
    END LOOP;
    
    COMMIT;
    
    SELECT COUNT(*)
    INTO v_count
    FROM shoppingcartdetail
    WHERE shoppingcartid = pshoppingcartid AND statusid <> 2;
    
    IF v_count = 0 THEN
      UPDATE shoppingcart
      SET statusid = 2,updatedby=pcreatedby, updateddate=sysdate
      WHERE id = pshoppingcartid;
    END IF;
    
    IF pdeliverytype = 1 THEN
        INSERT INTO ORDERDETAILADDRESS (
            ORDERID,
            TYPE,
           USERID,
            DESCRIPTION,
            DISTRICTID,
            REFERENCE,
            RECEIVE,
            NAME,
           LASTNAME,
            DOCUMENTTYPEID,
            DOCUMENTNUMBER,
            CELLPHONE,  
            STATUSID,
            CREATEDBY,
            CREATEDDATE
        ) 
       VALUES (
            IDOUT,
            ptype,
            puserid,
            pdescription,
           pdistrictid,
            preference,
           preceive,
           pname,
            plastname,
           pdocumenttypeid,
            pdocumentnumber,
            pcellphone,
            pstatusid,
           pcreatedby, 
           SYSDATE
        );
   END IF;
EXCEPTION
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK TO start_point;
        COMMIT;
END ORDERHEADER_INSERT_XML;

PROCEDURE ORDERHEADER_UPDATEORDERSTATUS(pid IN NUMBER, porderstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
AS
pOrderStatusPrev NUMBER:=0;
BEGIN
  select nvl((select NVL(orderstatus,0) from orderheader oh where oh.id=pid), 0) into pOrderStatusPrev from dual;
  
 UPDATE ORDERHEADER SET ORDERSTATUS = porderstatusid, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;
END ORDERHEADER_UPDATEORDERSTATUS;

PROCEDURE ORDERHEADER_GET_BYID(pid IN NUMBER, cursorOut OUT FIN_CURSOR_ORDERHEADER) 
IS
BEGIN
  OPEN cursorOut FOR
  Select distinct
oh.id,
oh.userid as ShopperId,
oh.deliverytype,
oh.ordernumber,
oh.orderdate,
oh.orderstatus,
mtd.value1 as orderstatusname,
oh.vendorid as VendorId,
oh.total,
pro.id as ProductId,
pro.name as ProductName,
od.unitprice,
od.quantity,
od.discount,
(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodet.Id and rownum=1) as ImageUrl,
sto.name as StoreName,
case oda.name when '' then oda.name || ' ' || oda.lastname else up.firstname || ' ' || up.lastname end as ShopperName,
nvl(oda.cellphone, up.cellphone) as ShopperCellPhone,
up.email as ShopperEmail,
oda.description as ShopperAddressName,
oda.reference as ShopperAddressReference,
d.name || ' - ' || p.name || ' - ' || dep.name as ShopperAddressUbigeo,
sto.cellphone as StoreCellPhone,
sto.scheduleofoperation StoreScheduleOfOperation,
sto.address StoreAddress,
od.OfferPrice,
od.NormalPrice,
od.id as OrderDetailID,
NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = sto.id AND sto.statusid = 1),
    0) AS IsVerified,
    pro.sku as Sku
from orderheader oh inner join orderdetail od
on oh.id=od.orderid inner join product pro on od.productid=pro.id
left join orderdetailaddress oda on oda.orderid=oh.id
left join district d on oda.districtid=d.id
left join province p on d.provinceid=p.id
left join department dep on  p.departmentid=dep.id
left join userperson up on up.id=oda.userid or up.id=oh.userid
inner join productdetail prodet on prodet.productid=pro.id
inner join storeproduct stopro on stopro.productid=pro.id
inner join store sto on sto.id=stopro.storeid 
inner join mastertabledetail mtd on mtd.idparameter=oh.orderstatus and mtd.mastertableid=23
where oh.id=pid;
END ORDERHEADER_GET_BYID;

PROCEDURE ORDERHEADER_GETBYFILTER_PAGINATED(pvendorid IN number,pshopperid IN number,porderstatusid IN number,pfilter IN varchar2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT FIN_CURSOR_ORDERHEADER)
IS
BEGIN
  OPEN cursorOut FOR
  select * from
  (select distinct 
  oh.id as Id,
oh.userid as ShopperId,
oh.deliverytype,
oh.ordernumber,
oh.orderdate,
oh.orderstatus,
mtd.value1 as orderstatusname,
oh.vendorid as VendorId,
oh.total,
pro.id as ProductId,
pro.name as ProductName,
od.unitprice,
od.quantity,
od.discount,
NVL(
        (SELECT CASE 
                 WHEN stover.verificationstatusid = 3 THEN 1 
                 ELSE 0 
             END 
         FROM StoreVerification stover 
         WHERE stover.StoreID = sto.id AND stover.statusid = 1),
        0) AS IsVerified,
(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodet.Id and rownum=1) as ImageUrl,
sto.name as StoreName,
pro.sku AS Sku,
row_number() over (order by oh.orderdate desc) as NroRow,
(select count(*) from orderheader oh inner join orderdetail od
on oh.id=od.orderid inner join product pro on od.productid=pro.id
inner join productdetail prodet on prodet.productid=pro.id
inner join storeproduct stopro on stopro.productid=pro.id
inner join store sto on sto.id=stopro.storeid 
inner join mastertabledetail mtd on mtd.idparameter=oh.orderstatus and mtd.mastertableid=23
where 
(oh.orderstatus = case when porderstatusid>0 then porderstatusid else oh.orderstatus end) and
(oh.userid = case when pshopperid>0 then pshopperid else oh.userid end) and
(oh.vendorid = case when pvendorid>0 then pvendorid else oh.vendorid end) and
(lower(oh.ordernumber) like '%'||lower(pfilter)||'%') and
(lower(pro.name) like '%'||lower(pfilter)||'%')) as TotalRow
from orderheader oh inner join orderdetail od
on oh.id=od.orderid inner join product pro on od.productid=pro.id
inner join productdetail prodet on prodet.productid=pro.id
inner join storeproduct stopro on stopro.productid=pro.id
inner join store sto on sto.id=stopro.storeid 
inner join mastertabledetail mtd on mtd.idparameter=oh.orderstatus and mtd.mastertableid=23
where
(oh.orderstatus = case when porderstatusid>0 then porderstatusid else oh.orderstatus end) and
(oh.userid = case when pshopperid>0 then pshopperid else oh.userid end) and
(oh.vendorid = case when pvendorid>0 then pvendorid else oh.vendorid end) and
((lower(oh.ordernumber) like '%'||lower(pfilter)||'%') or
(lower(pro.name) like '%'||lower(pfilter)||'%'))) where NroRow>=((prow-1)*ptotalRecord)+1 and NroRow<=(prow*ptotalRecord)
 order by nrorow;
END ORDERHEADER_GETBYFILTER_PAGINATED;

PROCEDURE ORDERHEADER_GETBYFILTER_ADMIN_PAGINATED(
    puserid IN NUMBER,
    pstorename IN varchar2,
    pordernumber IN varchar2,
    porderstatusid IN number,
    prow IN NUMBER, 
    ptotalRecord IN NUMBER,
    cursorOut OUT FIN_CURSOR_ORDERHEADER
)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT DISTINCT *
  FROM (
      SELECT distinct
          oh.id,
          oh.ordernumber,
          oh.orderdate,
          up.firstname,
          up.lastname,
          oh.total,
          oh.deliverytype,
          oh.orderstatus,
          mtd.value1 as orderstatusname,
          (SELECT s.name
           FROM store s
           INNER JOIN storeproduct sp ON s.id = sp.storeid
           INNER JOIN orderdetail od ON sp.productid = od.productid
           WHERE od.orderid = oh.id
           AND ROWNUM = 1) AS storename,
           row_number() over (order by oh.orderdate desc) as NroRow,
           (select count(*)  FROM 
          orderheader oh
      INNER JOIN 
          userperson up ON oh.userid = up.id
      INNER JOIN 
          mastertabledetail mtd ON mtd.idparameter = oh.orderstatus AND mtd.mastertableid = 23
      WHERE 
          oh.statusid = 1 and (oh.vendorid = CASE WHEN puserid>0 THEN puserid ELSE oh.vendorid END)  
      AND 
          (oh.orderstatus = CASE WHEN porderstatusid > 0 THEN porderstatusid ELSE oh.orderstatus END)
      AND 
          (((lower(oh.ordernumber) LIKE '%'||lower(pordernumber)||'%')) AND (lower((SELECT s.name 
                     FROM store s 
                     INNER JOIN storeproduct sp ON s.id = sp.storeid
                     INNER JOIN orderdetail od ON sp.productid = od.productid
                     WHERE od.orderid = oh.id 
                     AND ROWNUM = 1)) LIKE '%'||lower(pstorename)||'%'))) as TotalRow
      FROM 
          orderheader oh
      INNER JOIN 
          userperson up ON oh.userid = up.id
      INNER JOIN 
          mastertabledetail mtd ON mtd.idparameter = oh.orderstatus AND mtd.mastertableid = 23
      WHERE 
          oh.statusid = 1 and (oh.vendorid = CASE WHEN puserid>0 THEN puserid ELSE oh.vendorid END)  
      AND 
          (oh.orderstatus = CASE WHEN porderstatusid > 0 THEN porderstatusid ELSE oh.orderstatus END)
      AND 
          (((lower(oh.ordernumber) LIKE '%'||lower(pordernumber)||'%')) AND (lower((SELECT s.name 
                     FROM store s 
                     INNER JOIN storeproduct sp ON s.id = sp.storeid
                     INNER JOIN orderdetail od ON sp.productid = od.productid
                     WHERE od.orderid = oh.id 
                     AND ROWNUM = 1)) LIKE '%'||lower(pstorename)||'%')))
 where NroRow>=((prow-1)*ptotalRecord)+1 and NroRow<=(prow*ptotalRecord)
  ORDER BY NroRow;
END ORDERHEADER_GETBYFILTER_ADMIN_PAGINATED;

PROCEDURE ORDERHEADER_ADMIN_GET_BYID(pid IN NUMBER, cursorOut OUT FIN_CURSOR_ORDERHEADER)
IS
BEGIN
  OPEN cursorOut FOR 
  Select distinct
oh.id,
    oh.ordernumber,
    oh.orderdate,
    up.firstname,
    up.lastname,
    up.email,
    up.cellphone,
    oh.total,
    oh.deliverytype,
    oh.orderstatus,
    mtd.value1 as orderstatusname,
    (SELECT s.name
     FROM store s
     INNER JOIN storeproduct sp ON s.id = sp.storeid
     INNER JOIN orderdetail od ON sp.productid = od.productid
     WHERE od.orderid = oh.id
     AND ROWNUM = 1) AS storename
FROM 
    orderheader oh
INNER JOIN 
    userperson up ON oh.userid = up.id
INNER JOIN 
    orderdetail od ON oh.id = od.orderid
inner join mastertabledetail mtd on mtd.idparameter=oh.orderstatus and mtd.mastertableid=23
where oh.id=pid;
END ORDERHEADER_ADMIN_GET_BYID;



END PKG_ORDERHEADER;

/