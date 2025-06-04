create or replace PACKAGE USRECOSISTEMAS.PKG_MY_HISTORY_PRODUCT IS

type PRDH_CURSOR_PRODUCT IS REF CURSOR;
PROCEDURE PRDH_MYHISTORYPRODUCT_FIND_BYVISITDATE(pdate IN VARCHAR2, pproductid in NUMBER,puserid in NUMBER,cursorOut OUT PRDH_CURSOR_PRODUCT);
PROCEDURE PRDH_MYHISTORYPRODUCT_UPDATE(pid in NUMBER,puserid in NUMBER,pcountvisits in NUMBER, rowsOut out NUMBER);
PROCEDURE PRDH_MYHISTORYPRODUCT_GETALL_BY_USERID(puserid IN NUMBER, cursorOut OUT PRDH_CURSOR_PRODUCT);
PROCEDURE PRDH_MYHISTORYPRODUCT_INSERT(
pproductid IN NUMBER,
puserid IN NUMBER,
pcountvisits in NUMBER,
pvisitdate IN DATE,
IDOUT out NUMBER);
PROCEDURE PRDH_MYHISTORYPRODYCT_GETLAST_VIEWED_PRODUCT(puserid IN NUMBER, cursorOut OUT PRDH_CURSOR_PRODUCT);
PROCEDURE PRDH_MYHISTORYPRODYCT_GET_CAROUSEL_PRODUCTS(puserid IN NUMBER,cursorOut OUT PRDH_CURSOR_PRODUCT);
PROCEDURE PRDH_MYHISTORYPRODYCT_GET_CAROUSEL_PRODUCTS_UBIGEO(puserid IN NUMBER,pdistrictid IN NUMBER,cursorOut OUT PRDH_CURSOR_PRODUCT);
END PKG_MY_HISTORY_PRODUCT;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_MY_HISTORY_PRODUCT IS
PROCEDURE PRDH_MYHISTORYPRODUCT_FIND_BYVISITDATE(pdate IN VARCHAR2,pproductid in NUMBER,puserid in NUMBER ,cursorOut OUT PRDH_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
 SELECT * FROM MyHistoryProduct WHERE to_char(VisitDate,'YYYY-MM-DD') = pdate and productid = pproductid and userid  = puserid and STATUSID = 1;
END PRDH_MYHISTORYPRODUCT_FIND_BYVISITDATE;

PROCEDURE PRDH_MYHISTORYPRODUCT_UPDATE(pid in NUMBER,puserid in NUMBER,pcountvisits in NUMBER, rowsOut out NUMBER)
IS
BEGIN
UPDATE MyHistoryProduct set updatedby = puserid, updateddate = sysdate, CountVisits = pcountvisits WHERE id = pid;
 rowsOut := SQL%rowcount; 
 COMMIT; 
END PRDH_MYHISTORYPRODUCT_UPDATE;

PROCEDURE PRDH_MYHISTORYPRODUCT_INSERT(
pproductid IN NUMBER,
puserid IN NUMBER,
pcountvisits in NUMBER,
pvisitdate IN DATE,
IDOUT out NUMBER)
IS
BEGIN
INSERT INTO MyHistoryProduct
(PRODUCTID,
USERID,
COUNTVISITS,
VISITDATE,
STATUSID,
CREATEDBY,
CREATEDDATE,
UPDATEDBY,
UPDATEDDATE)
VALUES(
pproductid,
puserid,
pcountvisits,
pvisitdate,
1,
puserid,
sysdate,
puserid,
sysdate
)
returning ID into IDOUT;
 IF(SQL%rowcount > 0)
  THEN
   COMMIT; 
  END IF;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;
END PRDH_MYHISTORYPRODUCT_INSERT;

PROCEDURE PRDH_MYHISTORYPRODUCT_GETALL_BY_USERID(puserid IN NUMBER, cursorOut OUT PRDH_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT 
  mh.id,
  prd.id as productId,
  prd.isvisible,
  prd.routeseo,
  prd.issyncseo,
  prd.statusid as statusProductId,
  mh.countvisits,
  mh.visitdate,
  prd.name,
  prddet.wholesaleprice,
  prddet.retailprice,
  st.name as storename,
  (select count(1) from myfavorite where userid = puserid and  productid = prd.id and statusid = 1 and rownum = 1) as isFavorite,
  (select imageUrl from ProductDetailImage where ProductDetailId = prddet.id and rownum = 1) as imageUrl,
  prd.routeseo,prd.issyncseo
  FROM MyHistoryProduct mh INNER JOIN Product prd
  on mh.ProductId = prd.id INNER JOIN ProductDetail prddet
  on prd.Id = prddet.ProductId INNER JOIN StoreProduct ps
  on prd.Id = ps.ProductId INNER JOIN Store st
  on ps.StoreId = st.Id
  where mh.StatusId = 1 AND mh.UserId = puserid;
END PRDH_MYHISTORYPRODUCT_GETALL_BY_USERID;
PROCEDURE PRDH_MYHISTORYPRODYCT_GET_CAROUSEL_PRODUCTS(puserid IN NUMBER,cursorOut OUT PRDH_CURSOR_PRODUCT)
IS 
BEGIN
OPEN cursorOut FOR
select 
prod.id as productid,
prod.name,
prod.routeseo,
prod.issyncseo,
prod.ShortDescription,
prddet.retailprice,
prddet.wholesaleprice,
sto.name as StoreName,
(select imageUrl from ProductDetailImage where ProductDetailId = prddet.id and rownum = 1) as imageUrl,
(select count(*) from myfavorite where userid = puserid and productid = prod.id and statusid = 1) as isFavorite,
sum(mh.countvisits) as  countvisits,
prod.routeseo,prod.issyncseo,
NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = sto.id AND sto.statusid = 1
     AND ROWNUM < 1),
    0) AS IsVerified
from myhistoryproduct mh inner join product prod
on mh.productid = prod.id inner join productdetail prddet
on prod.id = prddet.productid inner join storeproduct stopro
on prod.id=stopro.productid inner join store sto
on stopro.storeid=sto.id
where mh.statusid = 1
group by prod.id,prod.name,prod.routeseo,prod.issyncseo,prod.ShortDescription,prddet.retailprice,prddet.wholesaleprice,prddet.id,sto.name,prod.routeseo,prod.issyncseo
order by countvisits desc
FETCH NEXT 4 ROWS ONLY;
END PRDH_MYHISTORYPRODYCT_GET_CAROUSEL_PRODUCTS;
PROCEDURE PRDH_MYHISTORYPRODYCT_GETLAST_VIEWED_PRODUCT(puserid IN NUMBER, cursorOut OUT PRDH_CURSOR_PRODUCT)
IS
BEGIN
OPEN cursorOut FOR
select 
prod.id as productid,
prod.name,
prod.routeseo,
prod.issyncseo,
prod.ShortDescription,
prddet.retailprice,
prddet.wholesaleprice,
(select imageUrl from ProductDetailImage where ProductDetailId = prddet.id and rownum = 1) as imageUrl,
prod.routeseo,prod.issyncseo
from myhistoryproduct mh inner join product prod
on mh.productid = prod.id inner join productdetail prddet
on prod.id = prddet.productid
where mh.statusid = 1 and mh.userid = puserid order by mh.updateddate desc
FETCH NEXT 1 ROWS ONLY;
END PRDH_MYHISTORYPRODYCT_GETLAST_VIEWED_PRODUCT;
PROCEDURE PRDH_MYHISTORYPRODYCT_GET_CAROUSEL_PRODUCTS_UBIGEO(puserid IN NUMBER,pdistrictid in NUMBER,cursorOut OUT PRDH_CURSOR_PRODUCT)
IS 
BEGIN
OPEN cursorOut FOR
select 
prod.id as productid,
prod.name,
prod.routeseo,
prod.issyncseo,
prod.ShortDescription,
prddet.retailprice,
prddet.wholesaleprice,
sto.name as StoreName,
(select ImageUrl from ProductDetailImage where ProductDetailId = prddet.id and rownum = 1) as imageUrl,
(select ImageThumbnail from ProductDetailImage where ProductDetailId = prddet.id and rownum = 1) as imageThumbnail,
(select count(*) from myfavorite where userid = puserid and productid = prod.id and statusid = 1) as isFavorite,
sum(mh.countvisits) as  countvisits,
prod.routeseo,prod.issyncseo,
prddet.OfferPrice,
prddet.DiscountPercentage,
prod.isvisible,
NVL(
        (SELECT CASE 
                 WHEN stover.verificationstatusid = 3 THEN 1 
                 ELSE 0 
             END 
         FROM StoreVerification stover 
         WHERE stover.StoreID = sto.id AND stover.statusid = 1),
        0) AS IsVerified
from myhistoryproduct mh inner join product prod
on mh.productid = prod.id inner join productdetail prddet
on prod.id = prddet.productid inner join storeproduct stopro
on prod.id=stopro.productid inner join store sto
on stopro.storeid=sto.id 
where sto.isvisible =1 and mh.statusid = 1 and (pdistrictid = 0 or ((sto.districtid = pdistrictid and sto.isstorepickup = 1) or sto.ishomedelivery =1))
group by prod.id,prod.name,prod.routeseo,prod.issyncseo,prod.ShortDescription,prddet.retailprice,prddet.wholesaleprice,prddet.id,sto.id,sto.name,prod.routeseo,prod.issyncseo,prddet.OfferPrice,prddet.DiscountPercentage,prod.isvisible
order by countvisits desc
FETCH NEXT 4 ROWS ONLY;
END PRDH_MYHISTORYPRODYCT_GET_CAROUSEL_PRODUCTS_UBIGEO;
END PKG_MY_HISTORY_PRODUCT;
/