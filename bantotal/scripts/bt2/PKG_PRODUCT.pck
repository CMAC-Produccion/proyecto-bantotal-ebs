create or replace package USRECOSISTEMAS.PKG_PRODUCT is
type PRD_CURSOR_PRODUCT IS REF CURSOR;

PROCEDURE PRD_PRODUCT_SEARCH_STORE_PAGINATED(pstoreid IN NUMBER,pname in VARCHAR2,puserid IN NUMBER,pvisible IN NUMBER, prow IN NUMBER, ptotalrecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_UPDATESTATUS(pproductid IN NUMBER, pstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE PRD_PRODUCT_UPDATESTOCK(pproductid IN NUMBER, pstock IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE SEC_PRODUCT_EXIST(pname IN VARCHAR2,cursorProductOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_EXIST_BYSKU(pstoreid IN NUMBER, psku IN VARCHAR2,cursorProductOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_INSERT(
ptype IN NUMBER,
pcondition IN NUMBER,
pname IN VARCHAR2,
pshortdescription IN VARCHAR2,
plargedescription IN VARCHAR2,
pcategoryid IN NUMBER,
pwarranty IN NUMBER,
pisvisible  IN NUMBER,
pstoreid IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
pusergroupid IN NUMBER,
pusersupplierid IN NUMBER,
pmodulecreateid IN NUMBER,
psubsubcategoryid IN NUMBER,
psku IN VARCHAR2,
IDOUT out NUMBER);
PROCEDURE SEC_PRODUCTDETAIL_INSERT(
pproductid IN NUMBER,
pstock IN NUMBER,
pstockmin IN NUMBER,
pstockmax IN NUMBER,
psizeid IN NUMBER,
pretailprice IN NUMBER,
pwholesaleprice IN NUMBER,
ppurchaseprice IN NUMBER,
pcolorid IN NUMBER,
punitofmeasureid IN NUMBER,
punitofmeasurevalue IN NUMBER,
pdimensionlong IN NUMBER,
pdimensionwidth IN NUMBER,
pdimensionheight IN NUMBER,
pbrand IN VARCHAR2,
pbarcode IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
pofferprice IN NUMBER,
pdiscountpercentage IN NUMBER,
IDOUT out NUMBER);
PROCEDURE SEC_PRODUCTDETAILIMAGE_INSERT(
pproductdetailid IN NUMBER,
pimageurl IN VARCHAR2,
pimagelink IN VARCHAR2,
pimagedescription IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
pimageThumbnail IN VARCHAR2,
IDOUT out NUMBER);
PROCEDURE PRD_PRODUCT_GET_BY_ID(pid IN NUMBER,puserid IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCTDETAILIMAGE_GET_BY_PRODUCTDETAILID(pproductDetailId IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCTDETAILIMAGE_DELETE_BY_PRODUCTDETAILID(pproductdetailid IN NUMBER,rowsOut out NUMBER);
PROCEDURE PRD_PRODUCTDETAILIMAGE_DELETE_BY_ID(pproductdetailid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE SEC_PRODUCT_UPDATE(
pid IN NUMBER,
ptype IN NUMBER,
pname IN VARCHAR2,
pshortdescription IN VARCHAR2,
plargedescription IN VARCHAR2,
pcategoryid IN NUMBER,
pwarranty IN NUMBER,
pisvisible  IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
pusergroupid IN NUMBER,
pusersupplierid IN NUMBER,
pmodulecreateid IN NUMBER,
pcondition IN NUMBER,
psubsubcategoryid IN NUMBER,
psku IN VARCHAR2,
IDOUT out NUMBER);
PROCEDURE SEC_PRODUCTDETAIL_UPDATE(
pid IN NUMBER,
pproductid IN NUMBER,
pstock IN NUMBER,
pstockmin IN NUMBER,
pstockmax IN NUMBER,
pretailprice IN NUMBER,
pwholesaleprice IN NUMBER,
ppurchaseprice IN NUMBER,
punitofmeasureid IN NUMBER,
punitofmeasurevalue IN NUMBER,
pdimensionlong IN NUMBER,
pdimensionwidth IN NUMBER,
pdimensionheight IN NUMBER,
pbrand IN VARCHAR2,
pbarcode IN VARCHAR2,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
pofferprice IN NUMBER,
pdiscountpercentage IN NUMBER,
IDOUT out NUMBER);
PROCEDURE SEC_PRODUCT_SEARCH_BY_CATEGORY_PAGINATED(pcategoryid IN NUMBER,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_SEARCH_PAGINATED(pproduct IN VARCHAR2,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_MOST_RECENT_PAGINATED(puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_AUTOCOMPLETE(pname in VARCHAR2,prows in NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_BLACKLISTPRODUCT_REASONALL(cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_REPORTBLACKLIST_PRODUCT_INSERT(preasonid IN NUMBER, pproductid IN NUMBER, pdescription IN VARCHAR2, puserid IN NUMBER, pstatusid IN NUMBER, rowsOut out NUMBER);
PROCEDURE PRD_PRODUCT_AUTOCOMPLETE_BY_STORE(pname in VARCHAR2,prows in NUMBER,pstoreid in NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_MY_INVENTORY(pproductid in NUMBER, pname in VARCHAR2 ,pstoreid in NUMBER,pcategoryid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_MY_INVENTORY_COUNT(pstoreid in NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_AUTOCOMPLETE_BY_STORE_WITHSTOCK(pname in VARCHAR2 ,prows in NUMBER,pstoreid in NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_POPUP_EXIST(puserid IN NUMBER,ptype IN NUMBER,cursorPopPupOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_POPUPVIEW_UPDATE(puserid IN NUMBER, pisproductedit IN NUMBER, pisstoreedit IN NUMBER, ptype IN NUMBER, pstatusid IN NUMBER, rowsOut out NUMBER);
PROCEDURE SEC_PRODUCT_EXIST_STOCK(pproductid IN NUMBER,cursorProductOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_EXIST_PAYMENTMETHOD(puseridshopper IN NUMBER,cursorProductOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_UPDATEPRICE(pproductid IN NUMBER, pprice IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE PRD_PRODUCT_UPDATESTOCK_INVENTORY(pproductid IN NUMBER, pstock IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE PRD_PRODUCT_MOST_SEARCHING_PAGINATED(puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCTDETAIL_UPDATE_QUANTITYSEARCH(pproductid IN NUMBER, pcountSearch IN NUMBER ,rowsOut out NUMBER);
PROCEDURE PRD_PRODUCT_UPDATEROUTESEO(rowsOut out NUMBER);
PROCEDURE PRD_PRODUCT_GETBYROUTESEO(prouteseo IN VARCHAR2,puserid IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_GETALLFORSITEMAP(cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_FILTER_PAGINATED(pproduct IN VARCHAR2,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_MOST_SEARCHING_UBIGEO_PAGINATED(puserid IN NUMBER,pdistrictid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_MOST_RECENT_UBIGEO_PAGINATED(puserid IN NUMBER,pdistrictId IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_FILTER_DYNAMIC_PAGINATED(
    puserid INT,
    pcategoryId INT,
    psubcategoryid INT,
    psubsubCategoryid INT,
    porderby VARCHAR2,
    porderdirection VARCHAR2,
    ppricelow NUMBER,
    ppricehigh NUMBER,
    pishomedelivery INT,
    pisstorepickup INT,
    pdistrictid INT,
    psearch VARCHAR2,
    pstoreid INT,
    prow INT,
    ptotalrecord INT,
    cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_SEARCH_BY_CATEGORY_UBIGEO_PAGINATED(pcategoryid IN NUMBER,puserid IN NUMBER,pdistrictId IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_SEARCH_UBIGEO_PAGINATED(pproduct IN VARCHAR2,puserid IN NUMBER,pdistrictId IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_SEARCH_SIMILAR(ptop IN NUMBER,puserid IN NUMBER,psubsubcategoryid IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_SEARCH_RECENTLY_VIEWED(ptop IN NUMBER,puserid IN NUMBER,pids VARCHAR2, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_VALIDATE_NAMES(products VARCHAR2, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_SEARCH_STORE_PAGINATED_ADMIN(pstoreid IN NUMBER,puserid IN NUMBER,pvisible IN NUMBER, ptextsearch IN VARCHAR2, prow IN NUMBER, ptotalrecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_INSERT_ADMIN(
pproductxml IN XMLTYPE,
IDOUT out NUMBER); 
PROCEDURE SEC_PRODUCT_UPDATE_ADMIN(
pproductxml IN XMLTYPE,
rowsOut out NUMBER);
PROCEDURE SEC_PRODUCTDETAILIMAGE_UPDATE(
pproductdetailid IN NUMBER,
pimageThumbnail IN VARCHAR2,
IDOUT out NUMBER);
PROCEDURE PRD_PRODUCT_GETALLFORTHUMBNAIL(cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE SEC_PRODUCT_GETBYID_ADMIN(pid IN NUMBER, 
  cursorOut OUT PRD_CURSOR_PRODUCT,
  cursorOutProductDetail OUT PRD_CURSOR_PRODUCT,
  cursorOutProductDetailImage OUT PRD_CURSOR_PRODUCT  
);
PROCEDURE SEC_PRODUCT_VALIDATESTOCKLIST(pproductsxml IN XMLTYPE,presultxml OUT XMLTYPE);
PROCEDURE SEC_PRODUCT_VALIDATE_SKU(pskus VARCHAR2,pstoreid NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCTS_FOR_REVENUE(pname in VARCHAR2 ,pstoreid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT);
PROCEDURE PRD_PRODUCT_BULK_IMAGE_INSERT(
    pproductxml IN XMLTYPE,
    IDOUT out NUMBER
);
PROCEDURE PRD_PRODUCT_MY_INFO_INVENTORY(pstoreid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT);
end PKG_PRODUCT;
/
create or replace package body USRECOSISTEMAS.PKG_PRODUCT is
PROCEDURE PRD_PRODUCT_SEARCH_STORE_PAGINATED(pstoreid IN NUMBER,pname in VARCHAR2 ,puserid IN NUMBER,pvisible IN NUMBER, prow IN NUMBER, ptotalrecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS 
BEGIN
  OPEN cursorOut FOR
  with Product_Most_Recent 
AS
(
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,OfferPrice,ImageUrl,StoreName,
routeseo,issyncseo,IsFavorite,sku,
row_number() over(order by eventdate desc) as NroRow from
(select distinct Prod.ID, Prod.TYPE,ProdDet.ProductID,  Prod.CONDITION, Prod.NAME, Prod.SHORTDESCRIPTION,Prod.LARGEDESCRIPTION,Cat.Name as CategoryName,ProdDet.Stock, prod.createddate,prod.updateddate,prod.eventdate,
prod.isvisible,prod.statusid,proddet.retailprice,proddet.offerprice,
(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageUrl,
(select name from Store sto where sto.id=StoProd.Storeid and rownum=1) as StoreName,
prod.routeseo,prod.issyncseo,
case when (select id from myfavorite fav where fav.statusid=1 and fav.userid=puserid and fav.productid=prod.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,sku
 from Product prod
inner join ProductDetail prodDet on prod.id=prodDet.Productid
inner join Category Cat on Cat.ID=Prod.CategoryID
inner join Storeproduct StoProd on Stoprod.Productid=prod.id and stoprod.storeid=pStoreId where lower(prod.name) like lower(concat('%',pname)) and  prod.statusid=1
and (prod.isvisible = case when pvisible>0 then pvisible else prod.isvisible end) 
order by prod.eventdate desc))
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,OfferPrice,ImageUrl,StoreName,routeseo,issyncseo,IsFavorite,sku,NroRow,
(select count(*) from Product_Most_Recent) as TotalRow from Product_Most_Recent where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END PRD_PRODUCT_SEARCH_STORE_PAGINATED;

PROCEDURE PRD_PRODUCT_UPDATESTATUS(pproductid IN NUMBER, pstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE PRODUCT SET STATUSID = pstatusid, UPDATEDBY = puserid, UPDATEDDATE = sysdate, EVENTDATE=sysdate WHERE ID = pproductid;
  rowsOut := SQL%rowcount;
 COMMIT;
END PRD_PRODUCT_UPDATESTATUS;


PROCEDURE PRD_PRODUCT_UPDATESTOCK(pproductid IN NUMBER, pstock IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE ProductDetail SET STOCK = STOCK + pstock, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE productid = pproductid;
  rowsOut := SQL%rowcount;
 COMMIT;
END PRD_PRODUCT_UPDATESTOCK;

PROCEDURE SEC_PRODUCT_EXIST(pname IN VARCHAR2,cursorProductOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorProductOut FOR
    SELECT COUNT(1) from PRODUCT WHERE lower(NAME) = lower(pname) and STATUSID = 1;
END SEC_PRODUCT_EXIST;
PROCEDURE SEC_PRODUCT_EXIST_BYSKU(pstoreid IN NUMBER, psku IN VARCHAR2,cursorProductOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorProductOut FOR
    SELECT COUNT(1)
    FROM storeproduct sp
    JOIN product p ON sp.productid = p.id
    WHERE sp.storeid = pstoreid AND p.sku = psku and p.STATUSID = 1;
END SEC_PRODUCT_EXIST_BYSKU;
PROCEDURE SEC_PRODUCT_INSERT(
ptype IN NUMBER,
pcondition IN NUMBER,
pname IN VARCHAR2,
pshortdescription IN VARCHAR2,
plargedescription IN VARCHAR2,
pcategoryid IN NUMBER,
pwarranty IN NUMBER,
pisvisible  IN NUMBER,
pstoreid IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
pusergroupid IN NUMBER,
pusersupplierid IN NUMBER,
pmodulecreateid IN NUMBER,
psubsubcategoryid IN NUMBER,
psku IN VARCHAR2,
IDOUT out NUMBER)
IS

BEGIN
 INSERT INTO PRODUCT (
TYPE
,CONDITION
,NAME
,SHORTDESCRIPTION
,LARGEDESCRIPTION
,CATEGORYID
,WARRANTY
,ISVISIBLE
,STATUSID
,CREATEDBY
,CREATEDDATE
,USERGROUPID
,USERSUPPLIERID
,MODULECREATE
,SUBSUBCATEGORYID
,SKU
)
VALUES
(
ptype
,pcondition
,pname
,pshortdescription
,plargedescription
,pcategoryid
,pwarranty
,pisvisible
,pstatusid
,pcreatedby
,SYSDATE
,pusergroupid
,pusersupplierid
,pmodulecreateid
,psubsubcategoryid
,psku
)
returning ID into IDOUT;
 IF(SQL%rowcount > 0)
  THEN

INSERT INTO STOREPRODUCT (
STOREID
,PRODUCTID
,STATUSID
,CREATEDBY
,CREATEDDATE)
VALUES(
pstoreid
,IDOUT
,pstatusid
,pcreatedby
,SYSDATE);

UPDATE product SET routeSeo = LOWER(REGEXP_REPLACE(TRIM(pname), '[^a-zA-Z0-9]+', '-')) || '-' || IDOUT, issyncseo=0 where id=IDOUT;

  END IF;

COMMIT;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END SEC_PRODUCT_INSERT;
PROCEDURE SEC_PRODUCTDETAIL_INSERT(
pproductid IN NUMBER,
pstock IN NUMBER,
pstockmin IN NUMBER,
pstockmax IN NUMBER,
psizeid IN NUMBER,
pretailprice IN NUMBER,
pwholesaleprice IN NUMBER,
ppurchaseprice IN NUMBER,
pcolorid IN NUMBER,
punitofmeasureid IN NUMBER,
punitofmeasurevalue IN NUMBER,
pdimensionlong IN NUMBER,
pdimensionwidth IN NUMBER,
pdimensionheight IN NUMBER,
pbrand IN VARCHAR2,
pbarcode IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
pofferprice IN NUMBER,
pdiscountpercentage IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN

INSERT INTO PRODUCTDETAIL (
PRODUCTID
,STOCK
,STOCKMIN
,STOCKMAX
,SIZEID
,RETAILPRICE
,WHOLESALEPRICE
,PURCHASEPRICE
,COLORID
,UNITOFMEASUREID
,UNITOFMEASUREVALUE
,DIMENSIONLONG
,DIMENSIONWIDTH
,DIMENSIONHEIGHT
,BRAND
,BARCODE
,STATUSID
,CREATEDBY
,CREATEDDATE
,OFFERPRICE
,DISCOUNTPERCENTAGE
)
VALUES
(
pproductid
,pstock
,pstockmin
,pstockmax
,psizeid
,pretailprice
,pwholesaleprice
,ppurchaseprice
,pcolorid
,punitofmeasureid
,punitofmeasurevalue
,pdimensionlong
,pdimensionwidth
,pdimensionheight
,pbrand
,pbarcode
,pstatusid
,pcreatedby
,SYSDATE
,pofferprice
,pdiscountpercentage)
  returning ID into IDOUT;
COMMIT;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END SEC_PRODUCTDETAIL_INSERT;
PROCEDURE SEC_PRODUCTDETAILIMAGE_INSERT(
pproductdetailid IN NUMBER,
pimageurl IN VARCHAR2,
pimagelink IN VARCHAR2,
pimagedescription IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
pimageThumbnail IN VARCHAR2,
IDOUT out NUMBER)
IS

BEGIN

 INSERT INTO productdetailimage (
PRODUCTDETAILID
,IMAGEURL
,IMAGELINK
,IMAGEDESCRIPTION
,STATUSID
,CREATEDBY
,CREATEDDATE,
IMAGETHUMBNAIL)
VALUES(
pproductdetailid
,pimageurl
,pimagelink
,pimagedescription
,pstatusid
,pcreatedby
,SYSDATE
,pimageThumbnail
)
returning ID into IDOUT;

COMMIT;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END SEC_PRODUCTDETAILIMAGE_INSERT;

PROCEDURE PRD_PRODUCT_GET_BY_ID(pid IN NUMBER,puserid IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
SELECT
prod.id,
prod.name,
prod.type,
prod.shortdescription,
prod.largedescription,
mtd.value1 as warrantyname,
proddet.retailprice,
proddet.wholesaleprice,
proddet.stock,
proddet.stockmax,
proddet.stockmin,
proddet.ID as productdetailid,
proddet.purchaseprice,
prod.warranty as warrantyid,
prod.isvisible as isvisibleid,
prod.condition as condition,
prod.modulecreate as modulecreateid,
NVL((select id from usergroup where id=prod.usergroupid), 0) as usergroupid,
NVL((select id from usersupplier where id=prod.usersupplierid), 0) as usersupplierid,
NVL((select name from usergroup where id=prod.usergroupid), '') as usergroupname,
NVL((select name from usersupplier where id=prod.usersupplierid), '') as usersuppliername,
case when (select id from myfavorite fav where fav.statusid=1 and fav.userid=puserid and fav.productid=prod.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,
nvl(sto.ishomedelivery,0) as ishomedelivery,
nvl(sto.isstorepickup,0) as isstorepickup,
nvl(proddet.unitofmeasureid,0) as unitofmeasureid,
mtd1.value1 as unitofmeasuredescription,
proddet.unitofmeasurevalue,
proddet.dimensionlong,
proddet.dimensionwidth,
proddet.dimensionheight,
proddet.brand,
proddet.barcode,
prod.routeseo,
prod.issyncseo,
cat.id as categoryid,
cat.name as categoryname,
sc.id as subcategoryid,
sc.name as subcategoryname,
ssc.name as subsubcategoryname,
prod.subsubcategoryid,
proddet.offerPrice,
prod.sku
FROM PRODUCT prod INNER JOIN productdetail proddet
on prod.id = proddet.productid LEFT JOIN mastertabledetail mtd
on prod.warranty = mtd.idparameter and mtd.mastertableid = 6 LEFT JOIN mastertabledetail mtd1
on proddet.unitofmeasureid = mtd1.idparameter and mtd1.mastertableid=21
inner join subsubcategory ssc on ssc.id=prod.subsubcategoryid
inner join subcategory sc on sc.id=ssc.subcategoryid
inner JOIN category cat on sc.categoryid = cat.id 
inner join storeproduct stoprod on prod.id=stoprod.productid inner join store sto on sto.id=stoprod.storeid
WHERE prod.ID = pid and prod.STATUSID = 1;
END PRD_PRODUCT_GET_BY_ID;

PROCEDURE PRD_PRODUCTDETAILIMAGE_GET_BY_PRODUCTDETAILID(pproductDetailId IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
SELECT * FROM PRODUCTDETAILIMAGE WHERE PRODUCTDETAILID = pproductDetailId and STATUSID = 1;
END PRD_PRODUCTDETAILIMAGE_GET_BY_PRODUCTDETAILID;

PROCEDURE PRD_PRODUCTDETAILIMAGE_DELETE_BY_PRODUCTDETAILID(pproductdetailid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 DELETE FROM PRODUCTDETAILIMAGE WHERE ID = pproductdetailid;
  rowsOut := SQL%rowcount;
 COMMIT;
END PRD_PRODUCTDETAILIMAGE_DELETE_BY_PRODUCTDETAILID;

PROCEDURE PRD_PRODUCTDETAILIMAGE_DELETE_BY_ID(pproductdetailid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 DELETE FROM PRODUCTDETAILIMAGE WHERE PRODUCTDETAILID = pproductdetailid;
  rowsOut := SQL%rowcount;
 COMMIT;
END PRD_PRODUCTDETAILIMAGE_DELETE_BY_ID;

PROCEDURE SEC_PRODUCT_UPDATE(
pid IN NUMBER,
ptype IN NUMBER,
pname IN VARCHAR2,
pshortdescription IN VARCHAR2,
plargedescription IN VARCHAR2,
pcategoryid IN NUMBER,
pwarranty IN NUMBER,
pisvisible  IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
pusergroupid IN NUMBER,
pusersupplierid IN NUMBER,
pmodulecreateid IN NUMBER,
pcondition IN NUMBER,
psubsubcategoryid IN NUMBER,
psku IN VARCHAR2,
IDOUT out NUMBER)
IS

BEGIN
 UPDATE PRODUCT
 SET
 TYPE = ptype
,NAME = pname
,SHORTDESCRIPTION = pshortdescription
,LARGEDESCRIPTION = plargedescription
,CATEGORYID = pcategoryid
,WARRANTY= pwarranty
,ISVISIBLE = pisvisible
,STATUSID = pstatusid
,updatedby = pupdatedby
,updateddate = SYSDATE
,eventdate=SYSDATE
,usergroupid = pusergroupid
,usersupplierid=pusersupplierid
,modulecreate=pmodulecreateid
,condition = pcondition
,subsubcategoryid=psubsubcategoryid
,sku=psku
WHERE ID = pid;

 IDOUT := SQL%rowcount;

COMMIT;


END SEC_PRODUCT_UPDATE;

PROCEDURE SEC_PRODUCTDETAIL_UPDATE(
pid IN NUMBER,
pproductid IN NUMBER,
pstock IN NUMBER,
pstockmin IN NUMBER,
pstockmax IN NUMBER,
pretailprice IN NUMBER,
pwholesaleprice IN NUMBER,
ppurchaseprice IN NUMBER,
punitofmeasureid IN NUMBER,
punitofmeasurevalue IN NUMBER,
pdimensionlong IN NUMBER,
pdimensionwidth IN NUMBER,
pdimensionheight IN NUMBER,
pbrand IN VARCHAR2,
pbarcode IN VARCHAR2,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
pofferprice IN NUMBER,
pdiscountpercentage IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN

    UPDATE PRODUCTDETAIL SET
PRODUCTID =pproductid
,STOCK=pstock
,STOCKMIN=pstockmin
,STOCKMAX=pstockmax
,RETAILPRICE=pretailprice
,WHOLESALEPRICE=pwholesaleprice
,PURCHASEPRICE=ppurchaseprice
,UNITOFMEASUREID=punitofmeasureid
,UNITOFMEASUREVALUE=punitofmeasurevalue
,DIMENSIONLONG=pdimensionlong
,DIMENSIONWIDTH=pdimensionwidth
,DIMENSIONHEIGHT=pdimensionheight
,BRAND=pbrand
,BARCODE=pbarcode
,STATUSID=pstatusid
,UPDATEDBY=pupdatedby
,UPDATEDDATE=SYSDATE
,OFFERPRICE = pofferprice
,discountpercentage = pdiscountpercentage
WHERE ID = pid;
  IDOUT := SQL%rowcount;
COMMIT;


END SEC_PRODUCTDETAIL_UPDATE;
PROCEDURE SEC_PRODUCT_SEARCH_BY_CATEGORY_PAGINATED(pcategoryid IN NUMBER,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Product_Temporal
  AS
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by CreatedDate desc) as NroRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription, Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
  (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1 and CatP.id=pcategoryid) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1 and CatP.id=pcategoryid) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1 and CatP.id=pcategoryid) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from
    Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
    inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
    inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Pro.Statusid=1 and pro.isvisible = 1 and Cat.Id=pcategoryid and CatSto.Idcategory=pcategoryid))
  select * from
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by CreatedDate desc) as NroRow, (select count(*) from Product_Temporal) as TotalRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription,Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
    (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1 and CatP.id=pcategoryid) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1 and CatP.id=pcategoryid) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1 and CatP.id=pcategoryid) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from  Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
     inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
     inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Pro.Statusid=1 and Pro.isvisible = 1 and Cat.Id=pCategoryid and CatSto.Idcategory=pcategoryid)) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_PRODUCT_SEARCH_BY_CATEGORY_PAGINATED;

PROCEDURE SEC_PRODUCT_SEARCH_PAGINATED(pproduct IN VARCHAR2,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Product_Temporal
  AS
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by RetailPrice asc) as NroRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription, Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
  (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from
    Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
    inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
    inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Pro.Statusid=1 and pro.isvisible = 1 and lower(Pro.Name) like '%'|| lower(pproduct)||'%'))
  select * from
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by RetailPrice asc) as NroRow, (select count(*) from Product_Temporal) as TotalRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription,Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
    (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from  Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
     inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
     inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Pro.Statusid=1 and Pro.isvisible = 1 and lower(Pro.Name) like '%'||lower(pproduct)||'%')) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_PRODUCT_SEARCH_PAGINATED;


PROCEDURE PRD_PRODUCT_MOST_RECENT_PAGINATED(puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  with Product_Most_Recent
AS
(
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,routeseo,issyncseo,ImageUrl,ImageThumbnail,StoreName,IsFavorite,OfferPrice,DiscountPercentage,IsVerified,
row_number() over(order by eventdate desc) as NroRow from
(select distinct Prod.ID, Prod.TYPE,ProdDet.ProductID,  Prod.CONDITION, Prod.NAME, Prod.SHORTDESCRIPTION,Prod.LARGEDESCRIPTION,Cat.Name as CategoryName,ProdDet.Stock, prod.createddate,prod.updateddate,prod.eventdate,
prod.isvisible,prod.statusid,proddet.retailprice,prod.routeseo,prod.issyncseo,
(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageUrl,
(select imageThumbnail from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageThumbnail,
(select name from Store sto where sto.id=StoProd.Storeid and rownum=1) as StoreName,
case when (select id from myfavorite fav where fav.statusid=1 and fav.userid=puserid and fav.productid=prod.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,
prodDet.OfferPrice,
prodDet.DiscountPercentage,
NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = sto.id AND sto.statusid = 1),
    0) AS IsVerified
 from Product prod
inner join ProductDetail prodDet on prod.id=prodDet.Productid
inner join subsubcategory ssc on ssc.id=Prod.Subsubcategoryid
inner join subcategory sc on sc.id=ssc.subcategoryid
inner join Category Cat on Cat.ID=sc.categoryid
inner join Storeproduct StoProd on Stoprod.Productid=prod.id 
inner join Store sto on stoprod.storeid=sto.id
where sto.isvisible = 1 and prod.statusid=1 and prod.isvisible=1
order by prod.eventdate desc))
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,routeseo,issyncseo,ImageUrl,ImageThumbnail,StoreName,IsFavorite,OfferPrice,DiscountPercentage,IsVerified,NroRow,
(select count(*) from Product_Most_Recent) as TotalRow from Product_Most_Recent where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END;
PROCEDURE PRD_PRODUCT_AUTOCOMPLETE(pname in VARCHAR2,prows in NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
 select id,name from product
 where lower(name) like lower(concat('%',pname)) and statusid = 1 and isvisible = 1
 ORDER BY id
 OFFSET 0 ROWS FETCH NEXT prows ROWS ONLY;
END PRD_PRODUCT_AUTOCOMPLETE;

PROCEDURE PRD_BLACKLISTPRODUCT_REASONALL(cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  select idparameter as id, value1 as name from mastertabledetail where mastertableid = 11 AND STATUS = 1
  ORDER BY ID ASC;
END PRD_BLACKLISTPRODUCT_REASONALL;
PROCEDURE PRD_REPORTBLACKLIST_PRODUCT_INSERT(preasonid IN NUMBER, pproductid IN NUMBER, pdescription IN VARCHAR2, puserid IN NUMBER, pstatusid IN NUMBER, rowsOut out NUMBER)
IS
BEGIN
    INSERT INTO ReportBlackListProduct (REASONID, PRODUCTID,STATUSID, DESCRIPTION,CREATEDBY, CREATEDDATE) VALUES (preasonid,pproductid,pstatusid,pdescription,puserid,SYSDATE);
      rowsOut := SQL%rowcount;
 COMMIT;
END PRD_REPORTBLACKLIST_PRODUCT_INSERT;

PROCEDURE PRD_PRODUCT_AUTOCOMPLETE_BY_STORE(
    pname IN VARCHAR2,
    prows IN NUMBER,
    pstoreid IN NUMBER,
    cursorOut OUT PRD_CURSOR_PRODUCT
)
IS
BEGIN
    OPEN cursorOut FOR
    SELECT pr.id, pr.name 
    FROM product pr 
    INNER JOIN storeproduct sp ON pr.id = sp.productid
    where sp.storeid = pstoreid and lower(pr.name) like lower(concat('%',pname)) and pr.statusid = 1
    ORDER BY pr.id
    -- Si prows es -1, traer toda la data; de lo contrario, aplicar paginación
    FETCH FIRST CASE WHEN prows = -1 THEN 1000000 ELSE prows END ROWS ONLY;
END PRD_PRODUCT_AUTOCOMPLETE_BY_STORE;

PROCEDURE PRD_PRODUCT_MY_INVENTORY(pproductid in NUMBER, pname in VARCHAR2 ,pstoreid in NUMBER,pcategoryid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
 WITH Product_GetAll
 as
 (
 select id,name,stock,imageurl,retailprice,row_number() over(order by createddate desc) as NroRow from
 (select
    pr.id,
    pr.name,
    pd.stock,
    (select pdi.imageurl  from productdetailimage pdi where productdetailid = pd.id and rownum  = 1) as imageurl,
    pr.createddate,
    pd.retailprice
    from product pr inner join storeproduct sp
    on pr.id = sp.productid inner join productdetail pd
    on pr.id = pd.productid
    where lower(pr.name) like lower(concat('%',pname)) and (pproductid <= 0 or pr.id = pproductid) and (pcategoryid <= -1 or pr.categoryid = pcategoryid) and sp.storeid = pstoreid and pr.statusid = 1))
    select id,name,stock,imageurl,retailprice,NroRow,(select count(*) from Product_GetAll) as TotalRow from Product_GetAll where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END PRD_PRODUCT_MY_INVENTORY;

PROCEDURE PRD_PRODUCT_MY_INVENTORY_COUNT(pstoreid in NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
 select
    pr.id,
    pr.name,
    pd.stock
    from product pr inner join storeproduct sp
    on pr.id = sp.productid inner join productdetail pd
    on pr.id = pd.productid
    where  sp.storeid = pstoreid and pr.statusid = 1;
END PRD_PRODUCT_MY_INVENTORY_COUNT;



PROCEDURE PRD_PRODUCT_AUTOCOMPLETE_BY_STORE_WITHSTOCK(pname in VARCHAR2 ,prows in NUMBER,pstoreid in NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
 select
    pr.id,
    pr.name,
    pd.stock,
    pd.retailprice,
    pd.wholesaleprice,
    pd.purchaseprice,
    (select pdi.imageurl  from productdetailimage pdi where productdetailid = pd.id and rownum  = 1) as imageurl,
    pr.createddate
    from product pr inner join storeproduct sp
    on pr.id = sp.productid inner join productdetail pd
    on pr.id = pd.productid
    where lower(pr.name) like lower(concat('%',pname)) and sp.storeid = pstoreid and pr.statusid = 1 and pd.stock>0
    ORDER BY pr.createddate desc
    OFFSET 0 ROWS FETCH NEXT prows ROWS ONLY;

END PRD_PRODUCT_AUTOCOMPLETE_BY_STORE_WITHSTOCK;

PROCEDURE SEC_POPUP_EXIST(puserid IN NUMBER, ptype IN NUMBER,cursorPopPupOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
    IF ptype = 1
    THEN
         OPEN cursorPopPupOut FOR
         SELECT COUNT(1) from POPPUPVIEW WHERE userid = puserid and IsStoreEdit = 1 and statusid = 1;
    ELSE
        OPEN cursorPopPupOut FOR
                  SELECT COUNT(1) from POPPUPVIEW WHERE userid = puserid and isProductEdit = 1 and statusid = 1;
    END IF;

END SEC_POPUP_EXIST;

PROCEDURE PRD_POPUPVIEW_UPDATE(puserid IN NUMBER, pisproductedit IN NUMBER, pisstoreedit IN NUMBER, ptype IN NUMBER, pstatusid IN NUMBER, rowsOut out NUMBER)
IS
BEGIN
if  ptype = 1
then
INSERT INTO POPPUPVIEW (USERID,ISSTOREEDIT,STATUSID,CREATEDBY,CREATEDDATE) VALUES (puserid,pisstoreedit,pstatusid, puserid,SYSDATE)
  returning ID into rowsOut;
else
DECLARE
    l_count NUMBER;
BEGIN
   SELECT COUNT(1) into l_count from POPPUPVIEW WHERE userid = puserid and isProductEdit = 1 and statusid = 1;
    IF l_count = 0  THEN
        INSERT INTO POPPUPVIEW (USERID,ISPRODUCTEDIT,STATUSID,CREATEDBY,CREATEDDATE) VALUES (puserid,pisproductedit,pstatusid, puserid,SYSDATE)
        returning ID into rowsOut;
    END IF;

END;
end if;


 COMMIT;
END PRD_POPUPVIEW_UPDATE;
PROCEDURE SEC_PRODUCT_EXIST_STOCK(pproductid IN NUMBER,cursorProductOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorProductOut FOR
    SELECT stock from ProductDetail WHERE productid = pproductid and statusid = 1;
END SEC_PRODUCT_EXIST_STOCK;
PROCEDURE SEC_PRODUCT_EXIST_PAYMENTMETHOD(puseridshopper IN NUMBER,cursorProductOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorProductOut FOR
    SELECT COUNT(1) from ProductDetail WHERE productid = puseridshopper and statusid = 1;
END SEC_PRODUCT_EXIST_PAYMENTMETHOD;
PROCEDURE PRD_PRODUCT_UPDATEPRICE(pproductid IN NUMBER, pprice IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE ProductDetail SET retailprice = pprice,wholesaleprice = pprice, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE productid = pproductid;
  rowsOut := SQL%rowcount;
 COMMIT;
END PRD_PRODUCT_UPDATEPRICE;
PROCEDURE PRD_PRODUCT_UPDATESTOCK_INVENTORY(pproductid IN NUMBER, pstock IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE ProductDetail SET STOCK = pstock,STOCKMIN=pstock,STOCKMAX=pstock, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE productid = pproductid;
  rowsOut := SQL%rowcount;
 COMMIT;
END PRD_PRODUCT_UPDATESTOCK_INVENTORY;
PROCEDURE PRD_PRODUCT_MOST_SEARCHING_PAGINATED(puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  with Product_Most_Searching
AS 
(  
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,routeseo,issyncseo,ImageUrl,ImageThumbnail,StoreName,IsFavorite,QUANTITYSEARCH,OfferPrice,DiscountPercentage,
row_number() over(order by NVL(QUANTITYSEARCH, 0) DESC) as NroRow from
(select distinct Prod.ID, Prod.TYPE,ProdDet.ProductID,  Prod.CONDITION, Prod.NAME, Prod.SHORTDESCRIPTION,Prod.LARGEDESCRIPTION,Cat.Name as CategoryName,ProdDet.Stock, prod.createddate,prod.updateddate,prod.eventdate,
prod.isvisible,prod.statusid,proddet.retailprice,prod.routeseo,prod.issyncseo,
(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageUrl,
(select imageThumbnail from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageThumbnail,
(select name from Store sto where sto.id=StoProd.Storeid and rownum=1) as StoreName,
case when (select id from myfavorite fav where fav.statusid=1 and fav.userid=puserid and fav.productid=prod.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
,prodDet.QUANTITYSEARCH,prodDet.OfferPrice,prodDet.DiscountPercentage
 from Product prod 
inner join ProductDetail prodDet on prod.id=prodDet.Productid
inner join Subsubcategory ssc on ssc.id=prod.subsubcategoryid
inner join subcategory sc on sc.id=ssc.subcategoryid
inner join Category Cat on Cat.ID=sc.categoryid
inner join Storeproduct StoProd on Stoprod.Productid=prod.id where prod.statusid=1 and prod.isvisible=1
order by NVL(prodDet.QUANTITYSEARCH, 0) DESC))
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,routeseo,issyncseo,ImageUrl,ImageThumbnail,StoreName,IsFavorite,QUANTITYSEARCH,OfferPrice,DiscountPercentage,NroRow,
(select count(*) from Product_Most_Searching) as TotalRow 
from Product_Most_Searching where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END PRD_PRODUCT_MOST_SEARCHING_PAGINATED;
PROCEDURE PRD_PRODUCTDETAIL_UPDATE_QUANTITYSEARCH(pproductid IN NUMBER, pcountSearch IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE productdetail SET QUANTITYSEARCH = NVL(QUANTITYSEARCH, 0) + pcountSearch WHERE productid = pproductid;
  rowsOut := SQL%rowcount; 
 COMMIT; 
END PRD_PRODUCTDETAIL_UPDATE_QUANTITYSEARCH;
PROCEDURE PRD_PRODUCT_UPDATEROUTESEO(rowsOut out NUMBER)
IS
BEGIN
  rowsOut := 0;
   FOR c1_rec IN (SELECT id, name
                    FROM product
                   WHERE IsSyncSeo = 0
                   FOR UPDATE OF routeSeo) LOOP
       UPDATE product
          SET routeSeo = LOWER(REGEXP_REPLACE(REMOVE_ACCENTS(TRIM(name)), '[^a-zA-Z0-9]+', '-')) || '-' || id;
       rowsOut := rowsOut + 1;
   END LOOP;
   COMMIT;
END PRD_PRODUCT_UPDATEROUTESEO;

PROCEDURE PRD_PRODUCT_GETBYROUTESEO(prouteseo IN VARCHAR2,puserid IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
SELECT
prod.id,
prod.name,
prod.type,
prod.shortdescription,
prod.largedescription,
mtd.value1 as warrantyname,
proddet.retailprice,
proddet.wholesaleprice,
proddet.stock,
proddet.ID as productdetailid,
proddet.purchaseprice,
prod.warranty as warrantyid,
prod.isvisible as isvisibleid,
prod.condition as condition,
prod.modulecreate as modulecreateid,
NVL((select id from usergroup where id=prod.usergroupid), 0) as usergroupid,
NVL((select id from usersupplier where id=prod.usersupplierid), 0) as usersupplierid,
NVL((select name from usergroup where id=prod.usergroupid), '') as usergroupname,
NVL((select name from usersupplier where id=prod.usersupplierid), '') as usersuppliername,
case when (select id from myfavorite fav where fav.statusid=1 and fav.userid=puserid and fav.productid=prod.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,
nvl(sto.ishomedelivery,0) as ishomedelivery,
nvl(sto.isstorepickup,0) as isstorepickup,
nvl(proddet.unitofmeasureid,0) as unitofmeasureid,
mtd1.value1 as unitofmeasuredescription,
proddet.unitofmeasurevalue,
proddet.dimensionlong,
proddet.dimensionwidth,
proddet.dimensionheight,
proddet.brand,
proddet.barcode,
prod.routeseo,
prod.issyncseo,
cat.id as categoryid,
cat.name as categoryname,
sc.id as subcategoryid,
sc.name as subcategoryname,
ssc.name as subsubcategoryname,
prod.subsubcategoryid,
proddet.offerprice,
proddet.discountpercentage,
prod.sku
FROM PRODUCT prod INNER JOIN productdetail proddet
on prod.id = proddet.productid LEFT JOIN mastertabledetail mtd
on prod.warranty = mtd.idparameter and mtd.mastertableid = 6 LEFT JOIN mastertabledetail mtd1
on proddet.unitofmeasureid = mtd1.idparameter and mtd1.mastertableid=21
inner join subsubcategory ssc on ssc.id=prod.subsubcategoryid
inner join subcategory sc on sc.id=ssc.subcategoryid
inner join category cat on sc.categoryid = cat.id 
inner join storeproduct stoprod on prod.id=stoprod.productid inner join store sto on sto.id=stoprod.storeid
WHERE lower(trim(prod.routeseo)) = lower(trim(prouteseo)) and prod.STATUSID = 1;
END PRD_PRODUCT_GETBYROUTESEO;

PROCEDURE PRD_PRODUCT_GETALLFORSITEMAP(cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
SELECT
prod.id,
prod.name,
prod.routeseo,
prod.issyncseo
FROM PRODUCT prod where prod.issyncseo=0 and prod.isvisible=1 and prod.STATUSID = 1;
END PRD_PRODUCT_GETALLFORSITEMAP;
PROCEDURE SEC_PRODUCT_FILTER_PAGINATED(pproduct IN VARCHAR2,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Product_Temporal
  AS
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by RetailPrice asc) as NroRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription,Pro.CreatedDate ,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
  (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,
  str.isHomeDelivery, str.isStorePickup
  from
    Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
    inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
    inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Pro.Statusid=1 and pro.isvisible = 1 and lower(Pro.Name) like '%'||lower(pproduct)||'%'))
  select * from
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo,isHomeDelivery, isStorePickup, createdDate, row_number() over(order by RetailPrice asc) as NroRow, (select count(*) from Product_Temporal) as TotalRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription,Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
    (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,
   isHomeDelivery, isStorePickup 
  from  Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
     inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
     inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Pro.Statusid=1 and Pro.isvisible = 1 and lower(Pro.Name) like '%'||lower(pproduct)||'%')) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_PRODUCT_FILTER_PAGINATED; 
PROCEDURE PRD_PRODUCT_MOST_SEARCHING_UBIGEO_PAGINATED(puserid IN NUMBER, pdistrictid IN NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  with Product_Most_Searching
AS 
(  
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,routeseo,issyncseo,ImageUrl,ImageThumbnail,StoreName,IsVerified,IsFavorite,QUANTITYSEARCH,OfferPrice,DiscountPercentage,
row_number() over(order by NVL(QUANTITYSEARCH, 0) DESC) as NroRow from
(select distinct Prod.ID, Prod.TYPE,ProdDet.ProductID,  Prod.CONDITION, Prod.NAME, Prod.SHORTDESCRIPTION,Prod.LARGEDESCRIPTION,Cat.Name as CategoryName,ProdDet.Stock, prod.createddate,prod.updateddate,prod.eventdate,
prod.isvisible,prod.statusid,proddet.retailprice,prod.routeseo,prod.issyncseo,
(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageUrl,
(select imageThumbnail from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageThumbnail,
--(select name from Store sto where sto.id=StoProd.Storeid and rownum=1) as StoreName,
sto.name as StoreName,
NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = sto.id AND sto.statusid = 1),
    0) AS IsVerified,
case when (select id from myfavorite fav where fav.statusid=1 and fav.userid=puserid and fav.productid=prod.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
,prodDet.QUANTITYSEARCH,
proddet.offerprice,
proddet.discountpercentage
 from Product prod 
inner join ProductDetail prodDet on prod.id=prodDet.Productid
inner join Subsubcategory ssc on ssc.id=prod.subsubcategoryid
inner join subcategory sc on sc.id=ssc.subcategoryid
inner join Category Cat on Cat.ID=sc.categoryid
inner join Storeproduct StoProd on Stoprod.Productid=prod.id 
inner join Store sto on stoprod.storeid = sto.id
where sto.isvisible = 1 and prod.statusid=1 and prod.isvisible=1 and (pdistrictid = 0 or ((sto.districtid = pdistrictid and sto.isstorepickup = 1) or sto.ishomedelivery =1))
order by NVL(prodDet.QUANTITYSEARCH, 0) DESC))
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,routeseo,issyncseo,ImageUrl,ImageThumbnail,StoreName,IsVerified,IsFavorite,QUANTITYSEARCH,OfferPrice,DiscountPercentage,NroRow,
(select count(*) from Product_Most_Searching) as TotalRow 
from Product_Most_Searching where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END PRD_PRODUCT_MOST_SEARCHING_UBIGEO_PAGINATED;

PROCEDURE PRD_PRODUCT_MOST_RECENT_UBIGEO_PAGINATED(puserid IN NUMBER,pdistrictId IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  with Product_Most_Recent
AS
(
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,routeseo,issyncseo,ImageUrl,ImageThumbnail,StoreName,IsVerified,IsFavorite,offerprice,discountpercentage,
row_number() over(order by eventdate desc) as NroRow from
(select distinct Prod.ID, Prod.TYPE,ProdDet.ProductID,  Prod.CONDITION, Prod.NAME, Prod.SHORTDESCRIPTION,Prod.LARGEDESCRIPTION,Cat.Name as CategoryName,ProdDet.Stock, prod.createddate,prod.updateddate,prod.eventdate,
prod.isvisible,prod.statusid,proddet.retailprice,prod.routeseo,prod.issyncseo,
(select ImageUrl from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageUrl,
(select ImageThumbnail from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageThumbnail,
--(select name from Store sto where sto.id=StoProd.Storeid and rownum=1) as StoreName,
sto.name as StoreName,
NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = sto.id AND sto.statusid = 1),
    0) AS IsVerified,
case when (select id from myfavorite fav where fav.statusid=1 and fav.userid=puserid and fav.productid=prod.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,
proddet.offerprice,
proddet.discountpercentage
 from Product prod
inner join ProductDetail prodDet on prod.id=prodDet.Productid
inner join subsubcategory ssc on ssc.id=Prod.Subsubcategoryid
inner join subcategory sc on sc.id=ssc.subcategoryid
inner join Category Cat on Cat.ID=sc.categoryid
inner join Storeproduct StoProd on Stoprod.Productid=prod.id
inner join Store sto on stoprod.storeid = sto.id

where sto.isvisible = 1 and prod.statusid=1 and prod.isvisible=1 and (pdistrictid = 0 or ((sto.districtid = pdistrictid and sto.isstorepickup = 1) or sto.ishomedelivery =1))
order by prod.eventdate desc))
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,routeseo,issyncseo,ImageUrl,ImageThumbnail,StoreName,IsVerified,IsFavorite,offerprice,discountpercentage,NroRow,
(select count(*) from Product_Most_Recent) as TotalRow from Product_Most_Recent where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END PRD_PRODUCT_MOST_RECENT_UBIGEO_PAGINATED;
PROCEDURE PRD_PRODUCT_FILTER_DYNAMIC_PAGINATED(
    puserid INT,
    pcategoryid INT,
    psubcategoryid INT,
    psubsubCategoryid INT,
    porderby VARCHAR2,
    porderdirection VARCHAR2,
    ppricelow NUMBER,
    ppricehigh NUMBER,
    pishomedelivery INT,
    pisstorepickup INT,
    pdistrictid INT,
    psearch VARCHAR2,
    pstoreid INT,
    prow INT,
    ptotalRecord INT,
    cursorOut OUT PRD_CURSOR_PRODUCT
)
AS
    v_sql VARCHAR2(4000);
BEGIN
    v_sql := 'WITH FilteredProducts AS (
                SELECT 
                    p.id,
                    p.name,
                    p.ShortDescription,
                    p.IsVisible,
                    pd.retailprice,
                    c.id as CategoryID,
                    c.name as CategoryName,
                    str.name as StoreName,
                    str.isHomeDelivery, 
                    str.isStorePickup,
                    p.routeseo,
                    p.issyncseo,
                    p.createddate,
                    (SELECT pdi.imageUrl FROM productdetailimage pdi 
                     WHERE pdi.productdetailid = pd.id AND ROWNUM = 1) AS imageUrl,
                    (SELECT pdg.imageThumbnail FROM productdetailimage pdg 
                     WHERE pdg.productdetailid = pd.id AND ROWNUM = 1) AS imageThumbnail,
                    case when (select id from myfavorite where statusid=1 and userid=' || puserid || ' and productid=p.Id)>0 then 1 else 0 end as IsFavorite,
                    pd.offerPrice,
                    pd.discountPercentage,
                    NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = str.id AND str.statusid = 1),
    0) AS IsVerified
                FROM product p
                INNER JOIN subsubcategory ssc ON p.subsubcategoryid = ssc.id
                INNER JOIN subcategory sc ON ssc.subcategoryid = sc.id
                INNER JOIN category c ON sc.categoryid = c.id
                INNER JOIN productdetail pd on p.id=pd.productid
                INNER JOIN storeproduct Stp on Stp.ProductId = p.Id
                INNER JOIN store str on str.id = Stp.storeid
                WHERE 1=1 and p.Statusid=1 and p.isvisible = 1 and str.isvisible = 1';
                
    IF psearch IS NOT NULL THEN
        v_sql := v_sql || ' AND lower(p.name) LIKE ''%' || lower(psearch) || '%'' '; 
    END IF;
    
    IF pstoreid != 0 THEN
      v_sql := v_sql || ' AND str.id = ' || pstoreid;
    END IF;

    IF pcategoryid != 0 THEN
        v_sql := v_sql || ' AND c.id = ' || pcategoryid;
    END IF;
    
    IF psubcategoryid != 0 THEN
        v_sql := v_sql || ' AND sc.id = ' || psubcategoryid;
    END IF;
    IF psubsubCategoryid != 0 THEN
        v_sql := v_sql || ' AND ssc.id = ' || psubsubCategoryid;
    END IF;
    
    IF pdistrictid > 0 THEN
        v_sql := v_sql || ' AND ((str.districtId = ' || pdistrictid || ' and str.isstorepickup = 1) or str.ishomedelivery = 1)';
    END IF;
    
    IF ppricelow != 0 OR ppricehigh != 0 THEN
        v_sql := v_sql || ' AND pd.retailprice BETWEEN ' || ppricelow || ' AND ' || ppricehigh;
    END IF;
    
    IF pishomedelivery != 0 and pisstorepickup != 0 THEN
        v_sql := v_sql || ' AND (str.isHomeDelivery = ' || pishomedelivery || ' OR str.isStorePickup = ' || pisstorepickup || ')';
    END IF;
    
    IF pishomedelivery = 0 and pisstorepickup = 0 THEN
     v_sql := v_sql || ' AND (str.isHomeDelivery = ' || 1 || ' OR str.isStorePickup = ' || 1 || ')';
    END IF;
    
    IF pishomedelivery != 0 and pisstorepickup = 0 THEN
        v_sql := v_sql || ' AND str.isHomeDelivery = ' || pishomedelivery;
    END IF;
    
    IF pisstorepickup != 0 and pishomedelivery = 0 THEN
        v_sql := v_sql || ' AND str.isStorePickup = ' || pisstorepickup;
    END IF;

    v_sql := v_sql || '),
              TotalRow AS (
                SELECT COUNT(*) AS TotalRow FROM FilteredProducts
              ),
              PaginatedProducts AS (
                SELECT 
                    fp.*,
                    tc.TotalRow,
                    ROW_NUMBER() OVER (ORDER BY ';

    IF porderby IS NOT NULL THEN
        IF porderby IN ('name') THEN
          v_sql := v_sql || 'UPPER(' || porderby || ')';
        ELSE
          v_sql := v_sql || porderby;
        END IF;
        IF porderdirection IS NOT NULL  THEN
            v_sql := v_sql || ' ' || porderdirection;
        ELSE
            v_sql := v_sql || ' ASC';
        END IF;
    ELSE
        v_sql := v_sql || 'fp.id ASC';
    END IF;

    v_sql := v_sql || ') AS NroRow
              FROM FilteredProducts fp, TotalRow tc
              )
              SELECT * FROM PaginatedProducts
              WHERE NroRow BETWEEN ((' || prow || ' - 1) * ' || ptotalRecord || ' + 1) 
              AND (' || prow || ' * ' || ptotalRecord || ')';

     DBMS_OUTPUT.PUT_LINE(v_sql);
    OPEN cursorOut FOR v_sql;
END PRD_PRODUCT_FILTER_DYNAMIC_PAGINATED;
PROCEDURE SEC_PRODUCT_SEARCH_BY_CATEGORY_UBIGEO_PAGINATED(pcategoryid IN NUMBER,puserid IN NUMBER,pdistrictId IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Product_Temporal
  AS
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by CreatedDate desc) as NroRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription, Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
  (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1 and (CatP.id=pcategoryid)) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1 and CatP.id=pcategoryid) as CategoryName,
pcategoryid as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from
    Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
    inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
    inner join Category Cat on CatSto.Idcategory=Cat.Id
    inner join subsubcategory ssc on Pro.subsubcategoryid = ssc.id
  Where Pro.Statusid=1 and pro.isvisible = 1 and (Cat.Id=pcategoryid or  ssc.subcategoryid = pcategoryid or pro.subsubcategoryid = pcategoryid) AND 
  (pdistrictid = 0 or ((str.districtid = pdistrictid and str.isstorepickup = 1) or str.ishomedelivery =1))))
  select * from
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by CreatedDate desc) as NroRow, (select count(*) from Product_Temporal) as TotalRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription,Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
    (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1 and CatP.id=pcategoryid) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1 and CatP.id=pcategoryid) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1 and CatP.id=pcategoryid) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from  Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
     inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
     inner join Category Cat on CatSto.Idcategory=Cat.Id
         inner join subsubcategory ssc on Pro.subsubcategoryid = ssc.id

  Where Pro.Statusid=1 and Pro.isvisible = 1 and (Cat.Id=pcategoryid or  ssc.subcategoryid = pcategoryid or pro.subsubcategoryid = pcategoryid) AND 
    (pdistrictid = 0 or ((str.districtid = pdistrictid and str.isstorepickup = 1) or str.ishomedelivery =1)))) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_PRODUCT_SEARCH_BY_CATEGORY_UBIGEO_PAGINATED;

PROCEDURE SEC_PRODUCT_SEARCH_UBIGEO_PAGINATED(pproduct IN VARCHAR2,puserid IN NUMBER,pdistrictId IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Product_Temporal
  AS
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by RetailPrice asc) as NroRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription, Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
  (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from
    Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
    inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
    inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Pro.Statusid=1 and pro.isvisible = 1 and  (pdistrictid = 0 or ((str.districtid = pdistrictid and str.isstorepickup = 1) or str.ishomedelivery =1)) AND  lower(Pro.Name) like '%'||lower(pproduct)||'%'))
  select * from
  (select ID,Name,ShortDescription,ImageUrl,CategoryName,CategoryID,IsFavorite,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by RetailPrice asc) as NroRow, (select count(*) from Product_Temporal) as TotalRow from
  (select distinct Pro.ID,Pro.Name,Pro.ShortDescription,Pro.CreatedDate,Pro.IsVisible,Pdl.RetailPrice, str.name as StoreName,pro.routeseo,pro.issyncseo,
    (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1) as ImageUrl,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=Pro.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from  Product Pro
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
     inner join store str on str.id = Stp.storeid
     inner join CategoryStore CatSto on Stp.StoreId=CatSto.Idstore
     inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Pro.Statusid=1 and Pro.isvisible = 1 and  (pdistrictid = 0 or ((str.districtid = pdistrictid and str.isstorepickup = 1) or str.ishomedelivery =1)) AND lower(Pro.Name) like '%'||lower(pproduct)||'%')) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_PRODUCT_SEARCH_UBIGEO_PAGINATED;
PROCEDURE SEC_PRODUCT_SEARCH_SIMILAR(ptop IN NUMBER,puserid IN NUMBER,psubsubcategoryid IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT p.id,p.name,
  p.ShortDescription,
  p.IsVisible,
  pd.retailprice,
  c.id as CategoryID,
  c.name as CategoryName,
  sc.id as SubCategoryID,
  sc.name as SubCategoryName,
  ssc.id as SubSubCategoryID,
  ssc.name as SubSubCategoryName,
  str.name as StoreName,
  str.isHomeDelivery,
  str.isStorePickup,
  p.routeseo,
  p.issyncseo,
  p.createddate,
  NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = str.id AND str.statusid = 1),
    0) AS IsVerified,
  (SELECT pdi.imageUrl FROM productdetailimage pdi WHERE pdi.productdetailid = pd.id AND ROWNUM = 1) AS imageUrl,
   (select imageThumbnail from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageThumbnail,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=p.Id)>0 then 1 else 0 end as IsFavorite
  FROM product p
  inner join ProductDetail prodDet on p.id=prodDet.Productid
  INNER JOIN subsubcategory ssc ON p.subsubcategoryid = ssc.id
  INNER JOIN subcategory sc ON ssc.subcategoryid = sc.id
  INNER JOIN category c ON sc.categoryid = c.id
  INNER JOIN productdetail pd on p.id=pd.productid
  INNER JOIN storeproduct Stp on Stp.ProductId = p.Id
  INNER JOIN store str on str.id = Stp.storeid
  WHERE 1=1 and p.Statusid=1 and p.isvisible = 1 and str.isvisible = 1 and rownum<=ptop and p.subsubcategoryid=psubsubcategoryid;
END SEC_PRODUCT_SEARCH_SIMILAR;
PROCEDURE SEC_PRODUCT_SEARCH_RECENTLY_VIEWED(ptop IN NUMBER,puserid IN NUMBER,pids VARCHAR2, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT p.id,p.name,
  p.ShortDescription,
  p.IsVisible,
  pd.retailprice,
  c.id as CategoryID,
  c.name as CategoryName,
  sc.id as SubCategoryID,
  sc.name as SubCategoryName,
  ssc.id as SubSubCategoryID,
  ssc.name as SubSubCategoryName,
  str.name as StoreName,
  str.isHomeDelivery,
  str.isStorePickup,
  p.routeseo,
  p.issyncseo,
  p.createddate,
  (SELECT pdi.imageUrl FROM productdetailimage pdi WHERE pdi.productdetailid = pd.id AND ROWNUM = 1) AS imageUrl,
  (select imageThumbnail from productdetailimage proddetimg where proddetimg.productdetailid=pd.Id and rownum=1) as ImageThumbnail,
  case when (select id from myfavorite where statusid=1 and userid=puserid and productid=p.Id)>0 then 1 else 0 end as IsFavorite
  FROM product p
  INNER JOIN subsubcategory ssc ON p.subsubcategoryid = ssc.id
  INNER JOIN subcategory sc ON ssc.subcategoryid = sc.id
  INNER JOIN category c ON sc.categoryid = c.id
  INNER JOIN productdetail pd on p.id=pd.productid
  INNER JOIN storeproduct Stp on Stp.ProductId = p.Id
  INNER JOIN store str on str.id = Stp.storeid
  WHERE 1=1 and p.Statusid=1 and p.isvisible = 1 and str.isvisible = 1 and rownum<=ptop and INSTR(',' || pids || ',', ',' || TO_CHAR(p.id) || ',') > 0;
END SEC_PRODUCT_SEARCH_RECENTLY_VIEWED;
PROCEDURE SEC_PRODUCT_VALIDATE_NAMES(products VARCHAR2, cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
   OPEN cursorOut FOR
        SELECT 
            pna.COLUMN_VALUE as product,
            CASE 
                WHEN p.NAME IS NOT NULL THEN 1
                ELSE 0
            END AS exist
        FROM 
            (SELECT * FROM TABLE(SPLIT_STRING_TEXT(products))) pna
        LEFT JOIN 
            product p ON lower(p.name) = lower(pna.COLUMN_VALUE) and p.statusid = 1;
END SEC_PRODUCT_VALIDATE_NAMES;
PROCEDURE SEC_PRODUCT_VALIDATE_SKU(pskus VARCHAR2, pstoreid NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
IS 
BEGIN 
  OPEN cursorOut FOR
         SELECT
            NVL(prd.id, 0) AS ProductDetailID,
            pna.COLUMN_VALUE AS SKU,
            CASE 
                WHEN p.NAME IS NOT NULL AND
                     EXISTS (SELECT 1 
                             FROM storeproduct sp 
                             WHERE sp.productid = p.id 
                               AND sp.storeid = pstoreid) THEN 1
                ELSE 0
            END AS exist
        FROM 
            (SELECT * FROM TABLE(SPLIT_STRING_TEXT(pskus))) pna
        LEFT JOIN product p 
            ON LOWER(p.SKU) = LOWER(pna.COLUMN_VALUE)
        LEFT JOIN productdetail prd 
            ON p.id = prd.productid  
        WHERE p.statusid = 1 
           OR p.id IS NULL; -- To handle cases where SKU doesn't exist in the product table
END SEC_PRODUCT_VALIDATE_SKU;

PROCEDURE SEC_PRODUCT_SEARCH_STORE_PAGINATED_ADMIN(pstoreid IN NUMBER,puserid IN NUMBER,pvisible IN NUMBER, ptextsearch IN VARCHAR2, prow IN NUMBER, ptotalrecord IN NUMBER, cursorOut OUT PRD_CURSOR_PRODUCT)
  IS
BEGIN
  OPEN cursorOut FOR
  with Product_Most_Recent 
AS
(
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,OfferPrice,ImageUrl,StoreName,
routeseo,issyncseo,IsFavorite,
row_number() over(order by eventdate desc) as NroRow from
(select distinct Prod.ID, Prod.TYPE,ProdDet.ProductID,  Prod.CONDITION, Prod.NAME, Prod.SHORTDESCRIPTION,Prod.LARGEDESCRIPTION,Cat.Name as CategoryName,ProdDet.Stock, prod.createddate,prod.updateddate,prod.eventdate,
prod.isvisible,prod.statusid,proddet.retailprice,proddet.offerprice,
(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodDet.Id and rownum=1) as ImageUrl,
(select name from Store sto where sto.id=StoProd.Storeid and rownum=1) as StoreName,
prod.routeseo,prod.issyncseo,
case when (select id from myfavorite fav where fav.statusid=1 and fav.userid=puserid and fav.productid=prod.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
 from Product prod
inner join ProductDetail prodDet on prod.id=prodDet.Productid
inner join Category Cat on Cat.ID=Prod.CategoryID
inner join Storeproduct StoProd on Stoprod.Productid=prod.id where prod.statusid=1
AND (pstoreid = 0 OR StoProd.storeid = pstoreid)
and (prod.isvisible = case when pvisible>0 then pvisible else prod.isvisible end)
and (lower(prod.name) like '%'|| lower(ptextsearch)||'%') 
order by prod.eventdate desc))
select Id,Type,ProductId,Condition,Name,ShortDescription,LargeDescription,CategoryName,Stock,CreatedDate,UpdatedDate,EventDate,IsVisible,StatusId,RetailPrice,OfferPrice,ImageUrl,StoreName,routeseo,issyncseo,IsFavorite,NroRow,
(select count(*) from Product_Most_Recent) as TotalRow from Product_Most_Recent where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_PRODUCT_SEARCH_STORE_PAGINATED_ADMIN;

PROCEDURE SEC_PRODUCT_INSERT_ADMIN(
    pproductxml IN XMLTYPE,
    IDOUT OUT NUMBER
)
IS
    vproductid NUMBER;
    vproductdetailid NUMBER;
BEGIN
    -- Insertar en la tabla product
    INSERT INTO product (
        type, condition, name, shortdescription, largedescription, categoryid, 
        warranty, isvisible, usersupplierid, usergroupid, modulecreate, 
        subsubcategoryid, statusid, createdby, createddate
    )
    SELECT 
        x.type, x.condition, x.name, x.shortdescription, x.largedescription,
        x.categoryid, x.warranty, x.isvisible, x.usersupplierid, x.usergroupid,
        x.modulecreate, x.subsubcategoryid, x.status, x.createdby, sysdate
    FROM XMLTABLE('/product'
        PASSING pproductxml
        COLUMNS 
            type NUMBER PATH 'type',
            condition NUMBER PATH 'condition',
            name VARCHAR2(200) PATH 'name',
            shortdescription VARCHAR2(1000) PATH 'shortdescription',
            largedescription VARCHAR2(1000) PATH 'largedescription',
            categoryid NUMBER PATH 'categoryid',
            warranty NUMBER PATH 'warranty',
            isvisible NUMBER PATH 'isvisible',
            usersupplierid NUMBER PATH 'usersupplierid',
            usergroupid NUMBER PATH 'usergroupid',
            modulecreate NUMBER PATH 'modulecreate',
            subsubcategoryid NUMBER PATH 'subsubcategoryid',
            status NUMBER PATH 'status',
            createdby NUMBER PATH 'createdby'
    ) x;
    SELECT PRODUCT_SEQ.CURRVAL INTO vproductid FROM dual;
    
    INSERT INTO STOREPRODUCT(STOREID,PRODUCTID,STATUSID,CREATEDBY,CREATEDDATE)
    SELECT 
        x.storeid, vproductid, x.status,x.createdby, sysdate
        FROM XMLTABLE('/product/store'
        PASSING pproductxml
        COLUMNS 
            storeid NUMBER PATH 'storeid',
            status NUMBER PATH 'status',
            createdby NUMBER PATH 'createdby'
    ) x; 

    -- Insertar en la tabla productdetail
    INSERT INTO productdetail (
        productid, stock, stockmin, stockmax, retailprice, wholesaleprice, 
        offerprice, discountpercentage, statusid, createdby, createddate
    )
    SELECT 
        vproductid, x.stock, x.stockmin, x.stockmax, x.retailprice, 
        x.wholesaleprice, x.offerprice, x.discountpercentage, x.status, 
        x.createdby, sysdate
    FROM XMLTABLE('/product/productdetail'
        PASSING pproductxml
        COLUMNS 
            stock NUMBER PATH 'stock',
            stockmin NUMBER PATH 'stockmin',
            stockmax NUMBER PATH 'stockmax',
            retailprice NUMBER(13,2) PATH 'retailprice',
            wholesaleprice NUMBER(13,2) PATH 'wholesaleprice',
            offerprice NUMBER(13,2) PATH 'offerprice',
            discountpercentage NUMBER(13,2) PATH 'discountpercentage',
            status NUMBER PATH 'status',
            createdby NUMBER PATH 'createdby'
    ) x;
    SELECT PRODUCTDETAIL_SEQ.CURRVAL INTO vproductdetailid FROM dual;

    -- Insertar en la tabla productdetailimage
    FOR rec IN (
        SELECT 
            x.imageurl, x.imagethumbnail, x.status, x.createdby
        FROM XMLTABLE('/product/productdetail/productdetailimages/productdetailimage'
            PASSING pproductxml
            COLUMNS 
                imageurl VARCHAR2(200) PATH 'imageurl',
                imagethumbnail VARCHAR2(200) PATH 'imagethumbnail',
                status NUMBER PATH 'status',
                createdby NUMBER PATH 'createdby'
        ) x
    ) LOOP
        INSERT INTO productdetailimage (
            productdetailid, imageurl, statusid, createdby, createddate
        )
        VALUES (
            vproductdetailid, rec.imageurl, rec.status, rec.createdby, sysdate
        );
    END LOOP;

    -- Devolver el ID del producto insertado
    IDOUT := vproductid;
    
    UPDATE product SET routeSeo = LOWER(REGEXP_REPLACE(TRIM((select pro.name from product pro where pro.id=IDOUT)), '[^a-zA-Z0-9]+', '-')) || '-' || IDOUT, issyncseo=0 where id=IDOUT;

    COMMIT;
    
END SEC_PRODUCT_INSERT_ADMIN;
PROCEDURE SEC_PRODUCT_UPDATE_ADMIN(
pproductxml IN XMLTYPE,
rowsOut out NUMBER)
IS
    vproductid NUMBER;
    vproductdetailid NUMBER;
    vimagecount NUMBER;
BEGIN
    MERGE INTO product p
    USING (
        SELECT 
            x.id, x.type, x.condition, x.name, x.shortdescription, x.largedescription,
            x.categoryid, x.warranty, x.isvisible, x.usersupplierid, x.usergroupid,
            x.modulecreate, x.subsubcategoryid, x.status, x.updatedby
        FROM XMLTABLE('/product'
            PASSING pproductxml
            COLUMNS 
                id NUMBER PATH 'id',
                type NUMBER PATH 'type',
                condition NUMBER PATH 'condition',
                name VARCHAR2(200) PATH 'name',
                shortdescription VARCHAR2(1000) PATH 'shortdescription',
                largedescription VARCHAR2(1000) PATH 'largedescription',
                categoryid NUMBER PATH 'categoryid',
                warranty NUMBER PATH 'warranty',
                isvisible NUMBER PATH 'isvisible',
                usersupplierid NUMBER PATH 'usersupplierid',
                usergroupid NUMBER PATH 'usergroupid',
                modulecreate NUMBER PATH 'modulecreate',
                subsubcategoryid NUMBER PATH 'subsubcategoryid',
                status NUMBER PATH 'status',
                updatedby NUMBER PATH 'updatedby'
        ) x
    ) xml_data
    ON (p.id = xml_data.id)
    WHEN MATCHED THEN
        UPDATE SET 
            p.type = xml_data.type,
            p.condition = xml_data.condition,
            p.name = xml_data.name,
            p.shortdescription = xml_data.shortdescription,
            p.largedescription = xml_data.largedescription,
            p.categoryid = xml_data.categoryid,
            p.warranty = xml_data.warranty,
            p.isvisible = xml_data.isvisible,
            p.usersupplierid = xml_data.usersupplierid,
            p.usergroupid = xml_data.usergroupid,
            p.modulecreate = xml_data.modulecreate,
            p.subsubcategoryid = xml_data.subsubcategoryid,
            p.statusid = xml_data.status,
            p.updatedby = xml_data.updatedby,
            p.updateddate = sysdate;
            
    SELECT x.id INTO vproductid
    FROM XMLTABLE('/product'
        PASSING pproductxml
        COLUMNS 
            id NUMBER PATH 'id'
    ) x;
    
    MERGE INTO productdetail pd
    USING (
        SELECT 
            x.id, x.stock, x.stockmin, x.stockmax, x.retailprice, 
            x.wholesaleprice, x.offerprice, x.discountpercentage, 
            x.status, x.updatedby
        FROM XMLTABLE('/product/productdetail'
            PASSING pproductxml
            COLUMNS 
                id NUMBER PATH 'id',
                stock NUMBER PATH 'stock',
                stockmin NUMBER PATH 'stockmin',
                stockmax NUMBER PATH 'stockmax',
                retailprice NUMBER(13,2) PATH 'retailprice',
                wholesaleprice NUMBER(13,2) PATH 'wholesaleprice',
                offerprice NUMBER(13,2) PATH 'offerprice',
                discountpercentage NUMBER(13,2) PATH 'discountpercentage',
                status NUMBER PATH 'status',
                updatedby NUMBER PATH 'updatedby'
        ) x
    ) xml_data
    ON (pd.id = xml_data.id)
    WHEN MATCHED THEN
        UPDATE SET 
            pd.stock = xml_data.stock,
            pd.stockmin = xml_data.stockmin,
            pd.stockmax = xml_data.stockmax,
            pd.retailprice = xml_data.retailprice,
            pd.wholesaleprice = xml_data.wholesaleprice,
            pd.offerprice = xml_data.offerprice,
            pd.discountpercentage = xml_data.discountpercentage,
            pd.statusid = xml_data.status,
            pd.updatedby = xml_data.updatedby,
            pd.updateddate = sysdate;
            
    SELECT x.id INTO vproductdetailid
    FROM XMLTABLE('/product/productdetail'
        PASSING pproductxml
        COLUMNS 
            id NUMBER PATH 'id'
    ) x;
    
    SELECT COUNT(*)
    INTO vimagecount
    FROM XMLTABLE('/product/productdetail/productdetailimages/productdetailimage'
        PASSING pproductxml
        COLUMNS 
            imageurl VARCHAR2(200) PATH 'imageurl'
    );

    IF vimagecount > 0 THEN
  
    DELETE FROM productdetailimage WHERE productdetailid = vproductdetailid;

    FOR rec IN (
        SELECT 
            x.imageurl, x.imagethumbnail, x.status, x.createdby
        FROM XMLTABLE('/product/productdetail/productdetailimages/productdetailimage'
            PASSING pproductxml
            COLUMNS 
                imageurl VARCHAR2(200) PATH 'imageurl',
                imagethumbnail VARCHAR2(200) PATH 'imagethumbnail',
                status NUMBER PATH 'status',
                createdby NUMBER PATH 'createdby'
        ) x
    ) LOOP
        INSERT INTO productdetailimage (
            productdetailid, imageurl,imagethumbnail, statusid, createdby, createddate
        )
        VALUES (
            vproductdetailid, rec.imageurl, rec.imagethumbnail, rec.status, rec.createdby, sysdate
        );
    END LOOP;
    END IF;
    
    rowsOut := vproductid;
    
    COMMIT;
END SEC_PRODUCT_UPDATE_ADMIN;
PROCEDURE PRD_PRODUCT_GETALLFORTHUMBNAIL(cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
SELECT
prod.id,
prod.imageurl,
prod.imagedescription,
prod.imagethumbnail
FROM productdetailimage prod where prod.STATUSID = 1 and prod.IMAGETHUMBNAIL is null;
END PRD_PRODUCT_GETALLFORTHUMBNAIL;

PROCEDURE SEC_PRODUCTDETAILIMAGE_UPDATE(
pproductdetailid IN NUMBER, 
pimageThumbnail IN VARCHAR2,
IDOUT out NUMBER)
IS
BEGIN
 UPDATE productdetailimage SET imagethumbnail = pimageThumbnail WHERE ID = pproductdetailid;
  IDOUT := SQL%rowcount;
 COMMIT;
END SEC_PRODUCTDETAILIMAGE_UPDATE;
PROCEDURE SEC_PRODUCT_GETBYID_ADMIN(pid IN NUMBER, 
  cursorOut OUT PRD_CURSOR_PRODUCT,
  cursorOutProductDetail OUT PRD_CURSOR_PRODUCT,
  cursorOutProductDetailImage OUT PRD_CURSOR_PRODUCT  
)
IS
BEGIN

OPEN cursorOut FOR
SELECT
prod.id,
prod.name,
prod.type,
prod.shortdescription,
prod.largedescription,
mtd.value1 as warrantyname,
prod.warranty as warrantyid,
prod.isvisible as isvisibleid,
prod.condition,
prod.modulecreate,
prod.routeseo,
prod.issyncseo,
cat.id as categoryid,
cat.name as categoryname,
sc.id as subcategoryid,
sc.name as subcategoryname,
ssc.name as subsubcategoryname,
prod.subsubcategoryid,
sto.ID AS storeid,
sto.name as storename,
prod.statusid,
prod.sku
FROM PRODUCT prod LEFT JOIN mastertabledetail mtd on prod.warranty = mtd.idparameter and mtd.mastertableid = 6 
inner join subsubcategory ssc on ssc.id=prod.subsubcategoryid
inner join subcategory sc on sc.id=ssc.subcategoryid
inner JOIN category cat on sc.categoryid = cat.id 
inner join storeproduct stoprod on prod.id=stoprod.productid 
inner join store sto on sto.id=stoprod.storeid
WHERE prod.ID = pid;


OPEN cursorOutProductDetail FOR
SELECT
proddet.retailprice,
proddet.wholesaleprice,
proddet.stock,
proddet.productid,
proddet.id,
proddet.purchaseprice,
nvl(proddet.unitofmeasureid,0) as unitofmeasureid,
mtd1.value1 as unitofmeasuredescription,
proddet.unitofmeasurevalue,
proddet.dimensionlong,
proddet.dimensionwidth,
proddet.dimensionheight,
proddet.brand,
proddet.barcode,
proddet.offerPrice
FROM productdetail proddet LEFT JOIN mastertabledetail mtd1
on proddet.unitofmeasureid = mtd1.idparameter and mtd1.mastertableid=21
WHERE proddet.productid = pid;

OPEN cursorOutProductDetailImage FOR
SELECT
proddetimg.id,
proddetimg.imageurl,
proddetimg.imagelink,
proddetimg.imagedescription,
proddetimg.imagethumbnail,
proddet.ID as productdetailid
FROM productdetailimage proddetimg inner join
productdetail proddet on proddetimg.productdetailid=proddet.id
WHERE proddet.productid = pid;

END SEC_PRODUCT_GETBYID_ADMIN;
PROCEDURE SEC_PRODUCT_VALIDATESTOCKLIST(pproductsxml IN XMLTYPE,presultxml OUT XMLTYPE)
  IS
  v_productid NUMBER;
  v_quantity NUMBER;
  v_stock NUMBER;
  v_hasStock VARCHAR2(5);
  v_message VARCHAR2(255);
  v_result CLOB := '';
  
  TYPE t_results IS TABLE OF XMLTYPE INDEX BY PLS_INTEGER;
  l_results t_results;
  
  CURSOR c_products IS
    SELECT EXTRACTVALUE(VALUE(p), '/Product/productid') AS productid,
           EXTRACTVALUE(VALUE(p), '/Product/quantity') AS quantity
    FROM TABLE(XMLSEQUENCE(EXTRACT(pproductsxml, '/Products/Product'))) p;
BEGIN
  OPEN c_products;
  LOOP
    FETCH c_products INTO v_productid, v_quantity;
    EXIT WHEN c_products%NOTFOUND;
    
    BEGIN
      SELECT stock INTO v_stock
      FROM productdetail
      WHERE productid = v_productid;
      
      IF v_stock >= v_quantity THEN
        v_hasStock := 'true';
        v_message := 'El producto cuenta con el stock';
      ELSE
        v_hasStock := 'false';
        v_message := 'El producto no cuenta con el stock necesario';
      END IF;
      
      l_results(l_results.COUNT + 1) := XMLTYPE('<Product>' ||
                                                '<productid>' || v_productid || '</productid>' ||
                                                '<quantity>' || v_quantity || '</quantity>' ||
                                                '<stock>' || v_stock || '</stock>' ||
                                                '<hasStock>' || v_hasStock || '</hasStock>' ||
                                                '<message>' || v_message || '</message>' ||
                                                '</Product>');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_results(l_results.COUNT + 1) := XMLTYPE('<Product>' ||
                                                  '<productid>' || v_productid || '</productid>' ||
                                                  '<quantity>' || v_quantity || '</quantity>' ||
                                                  '<stock>0</stock>' ||
                                                  '<hasStock>false</hasStock>' ||
                                                  '<message>El producto no se encuentra</message>' ||
                                                  '</Product>');
    END;
  END LOOP;
  CLOSE c_products;
  
  FOR i IN 1..l_results.COUNT LOOP
    v_result := v_result || l_results(i).getCLOBVal();
  END LOOP;
  
  presultxml := XMLTYPE('<Products>' || v_result || '</Products>');
EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END SEC_PRODUCT_VALIDATESTOCKLIST;
PROCEDURE PRD_PRODUCTS_FOR_REVENUE(pname in VARCHAR2 ,pstoreid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT PRD_CURSOR_PRODUCT)
IS
BEGIN
 OPEN cursorOut FOR
 WITH Product_GetAll
 as
 (
 select id,name,stock,imageurl,retailprice,offerprice,price,row_number() over(order by createddate desc) as NroRow from
 (select
    pr.id,
    pr.name,
    pd.stock,
    (select pdi.imageurl  from productdetailimage pdi where productdetailid = pd.id and rownum  = 1) as imageurl,
    pr.createddate,
    pd.retailprice,
    pd.offerprice,
       case when pd.offerprice > 0 then pd.offerprice
    else pd.retailprice end as price
    from product pr inner join storeproduct sp
    on pr.id = sp.productid inner join productdetail pd
    on pr.id = pd.productid
    where concat(lower(pr.name),lower(pr.sku)) like lower(concat('%',pname)) and sp.storeid = pstoreid and pr.statusid = 1 and pd.stock > 0))
    select id,name,stock,imageurl,retailprice,offerprice,price,NroRow,(select count(*) from Product_GetAll) as TotalRow from Product_GetAll where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END PRD_PRODUCTS_FOR_REVENUE;

PROCEDURE PRD_PRODUCT_BULK_IMAGE_INSERT(
    pproductxml IN XMLTYPE,
    IDOUT OUT NUMBER
)
IS
    vRows NUMBER := 0;  -- Contador de actualizaciones/inserciones
BEGIN
    -- Procesar el XML e insertar/actualizar los datos
    FOR rec IN (
        SELECT 
            x.productdetailid, x.imageurl, x.imagethumbnail, x.status, x.createdby
        FROM XMLTABLE('/productdetails/productdetailimage'
            PASSING pproductxml
            COLUMNS 
                productdetailid NUMBER PATH 'productdetailid',
                imageurl VARCHAR2(200) PATH 'imageurl',
                imagethumbnail VARCHAR2(200) PATH 'imagethumbnail',
                status NUMBER PATH 'status',
                createdby NUMBER PATH 'createdby'
        ) x
    ) LOOP
        -- Usar MERGE para hacer un UPSERT (update si existe, insert si no existe)
        MERGE INTO productdetailimage tgt
        USING (
            SELECT rec.productdetailid AS productdetailid, rec.imageurl AS imageurl FROM dual
        ) src
        ON (tgt.productdetailid = src.productdetailid AND tgt.imageurl = src.imageurl)
        WHEN MATCHED THEN
            UPDATE SET
                tgt.imagethumbnail = rec.imagethumbnail,
                tgt.statusid = rec.status,
                tgt.updatedby = rec.createdby,
                tgt.updateddate = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (
                productdetailid, imageurl, imagethumbnail, statusid, createdby, createddate
            )
            VALUES (
                rec.productdetailid, rec.imageurl, rec.imagethumbnail, rec.status, rec.createdby, SYSDATE
            );

        -- Incrementar el contador de actualizaciones/inserciones
        vRows := vRows + 1;
    END LOOP;

    -- Asignar el número total de registros procesados
    IDOUT := vRows;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores en caso de que ocurra algún problema
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Error en PRD_PRODUCT_BULK_IMAGE_INSERT: ' || SQLERRM);
END PRD_PRODUCT_BULK_IMAGE_INSERT;
PROCEDURE PRD_PRODUCT_MY_INFO_INVENTORY(
    pstoreid IN NUMBER, 
    prow IN NUMBER, 
    ptotalRecord IN NUMBER, 
    cursorOut OUT PRD_CURSOR_PRODUCT
)
IS
BEGIN
    OPEN cursorOut FOR
    WITH Product_GetAll AS (
        SELECT 
            id,
            name,
            stock,
            imageurl,
            retailprice,
            sku,
            ROW_NUMBER() OVER (ORDER BY stock ASC, createddate DESC) AS NroRow
        FROM (
            SELECT
                pr.id,
                pr.name,
                pd.stock,
                (SELECT pdi.imageurl  
                 FROM productdetailimage pdi 
                 WHERE pdi.productdetailid = pd.id AND ROWNUM = 1) AS imageurl,
                pr.createddate,
                pd.retailprice,
                pr.sku
            FROM 
                product pr 
            INNER JOIN 
                storeproduct sp ON pr.id = sp.productid 
            INNER JOIN 
                productdetail pd ON pr.id = pd.productid
            WHERE sp.storeid = pstoreid 
                AND pr.statusid = 1
                AND pd.stock <= 2 -- Mostrar solo productos con stock <= 2
        )
    )
    SELECT 
        id,
        name,
        stock,
        imageurl,
        retailprice,
        sku,
        NroRow,
        (SELECT COUNT(*) FROM Product_GetAll) AS TotalRow
    FROM 
        Product_GetAll
    WHERE 
        NroRow >= ((prow - 1) * ptotalRecord) + 1 
        AND NroRow <= (prow * ptotalRecord)
    ORDER BY 
        NroRow;
END PRD_PRODUCT_MY_INFO_INVENTORY;

END PKG_PRODUCT;
