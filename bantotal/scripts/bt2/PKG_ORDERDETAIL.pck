create or replace PACKAGE USRECOSISTEMAS.PKG_ORDERDETAIL is type FIN_CURSOR_ORDERDETAIL IS REF CURSOR;
 PROCEDURE ORDERDETAIL_INSERT(
porderid IN NUMBER ,
pproductid NUMBER,
puniteprice IN NUMBER,
pquantity IN NUMBER,
pdiscount IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER); 
PROCEDURE ORDERDETAIL_GET_BYORDERID(pid IN NUMBER, cursorOut OUT FIN_CURSOR_ORDERDETAIL);
END PKG_ORDERDETAIL;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_ORDERDETAIL IS

PROCEDURE ORDERDETAIL_INSERT(
porderid IN NUMBER ,
pproductid NUMBER,
puniteprice IN NUMBER,
pquantity IN NUMBER,
pdiscount IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER) 
IS  
BEGIN
 INSERT INTO orderdetail ( 
ORDERID,
PRODUCTID, 
UNITPRICE,
QUANTITY,
DISCOUNT,
CREATEDBY,
CREATEDDATE) 
VALUES
(porderid,
pproductid,
puniteprice,
pquantity,
pdiscount,
pcreatedby,
sysdate
)
  returning ID into IDOUT;
COMMIT; 
END ORDERDETAIL_INSERT;
PROCEDURE ORDERDETAIL_GET_BYORDERID(pid IN NUMBER, cursorOut OUT FIN_CURSOR_ORDERDETAIL)
IS
BEGIN
  OPEN cursorOut FOR
  select distinct
od.ID,
od.ORDERID,
od.PRODUCTID, 
od.UNITPRICE,
od.UNITPRICE as UNITEPRICE,
od.QUANTITY,
od.DISCOUNT,
od.CREATEDBY,
od.CREATEDDATE,
od.NORMALPRICE,
od.OFFERPRICE,
sto.name as storename,
(select imageurl from productdetailimage proddetimg 
inner join productdetail prodet on proddetimg.productdetailid=prodet.Id
inner join product pro on pro.id=prodet.productid
where pro.id=prod.id and rownum=1) as ImageUrl,
prod.name as productname,
 ROUND(
        CASE 
            WHEN od.OFFERPRICE > 0 THEN od.OFFERPRICE * od.QUANTITY
            ELSE od.NORMALPRICE * od.QUANTITY
        END, 
        2
    ) AS subtotal
  from orderdetail od
  inner join storeproduct stoprod on od.productid=stoprod.productid
  inner join store sto on stoprod.storeid=sto.id
  inner join product prod on prod.id=stoprod.productid
  WHERE od.ORDERID = pid;
END ORDERDETAIL_GET_BYORDERID;
END PKG_ORDERDETAIL;
/