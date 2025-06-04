create or replace PACKAGE USRECOSISTEMAS.PKG_MY_FAVORITE IS

type FAV_CURSOR_FAVORITE IS REF CURSOR;

PROCEDURE FAV_FAVORITE_STORE_GETPAGINATED(puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT FAV_CURSOR_FAVORITE);
PROCEDURE FAV_FAVORITE_STORE_SAVE(puserid IN NUMBER, pstoreid IN NUMBER, pstatusid IN NUMBER, rowsOut out NUMBER);
PROCEDURE FAV_FAVORITE_PRODUCT_GETPAGINATED(puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT FAV_CURSOR_FAVORITE);
PROCEDURE FAV_FAVORITE_PRODUCT_SAVE(puserid IN NUMBER, pproductid IN NUMBER, pstatusid IN NUMBER, rowsOut out NUMBER);
PROCEDURE FAV_FAVORITE_STORE_GETPAGINATED_DYNAMIC(
    puserid IN NUMBER,
    pcategories VARCHAR2,
    pcategoryid IN NUMBER,
    psubcategoryid IN NUMBER,
    psubsubCategoryid IN NUMBER,
    porderby IN VARCHAR2,
    porderdirection IN VARCHAR2,
    ppricelow IN NUMBER,
    ppricehigh IN NUMBER,
    pishomedelivery IN NUMBER,
    pisstorepickup IN NUMBER,
    pdistrictid IN NUMBER,
    psearch IN VARCHAR2,
    pstoreid IN NUMBER,
    prow IN NUMBER,
    ptotalRecord IN NUMBER,
    cursorOut OUT FAV_CURSOR_FAVORITE);
PROCEDURE FAV_FAVORITE_PRODUCT_GETPAGINATED_DYNAMIC(
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
    cursorOut OUT FAV_CURSOR_FAVORITE
);    
END PKG_MY_FAVORITE;


/
create or replace PACKAGE BODY  USRECOSISTEMAS.PKG_MY_FAVORITE IS

PROCEDURE FAV_FAVORITE_STORE_GETPAGINATED(puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT FAV_CURSOR_FAVORITE)
IS
BEGIN

OPEN cursorOut FOR
WITH MyFavorite_Store_Temporal
AS
(
select Id,StoreId,UserId,Name,Description,Logo,Linkfacebook,Linkinstagram,Linktwitter,Linktiktok,CategoryName,IsFavorite,StatusId,IsVisible,Routeseo,issyncseo, row_number() over(order by UpdatedDate desc) as NroRow from
(SELECT distinct MyFav.Id,Sto.Id StoreId,MyFav.Userid, Sto.Name,Sto.Description,Sto.Logo,Sto.Linkfacebook,Sto.Linkinstagram,Sto.Linktwitter,Sto.Linktiktok,
(select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryName,MyFav.CreatedDate,MyFav.UpdatedDate,
case when MyFav.StatusId=1 then 1 else 0 end as IsFavorite, Sto.Statusid as StatusId, Sto.Isvisible,Sto.Routeseo,sto.issyncseo
FROM MyFavorite MyFav inner join Store Sto on MyFav.Storeid=Sto.Id inner join Categorystore CatSto on Sto.Id=CatSto.Idstore and MyFav.Userid=puserid and MyFav.Statusid=1 order by MyFav.UpdatedDate))
select Id as MyFavoriteId,StoreId as Id,UserId,Name,Description,Logo,Linkfacebook,Linkinstagram,Linktwitter,Linktiktok,CategoryName,IsFavorite,StatusId,IsVisible,Routeseo,issyncseo,NroRow,(select count(*) from MyFavorite_Store_Temporal) as TotalRow 
from MyFavorite_Store_Temporal where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;

END FAV_FAVORITE_STORE_GETPAGINATED;

PROCEDURE FAV_FAVORITE_STORE_SAVE(puserid IN NUMBER, pstoreid IN NUMBER, pstatusid IN NUMBER, rowsOut out NUMBER)
IS
idFavorite NUMBER;
BEGIN

 select NVL(max(id),0) INTO idFavorite
 from MyFavorite where StoreId=pstoreid and UserId=puserid;

 if idFavorite > 0
 then
   update MyFavorite set StatusId=pstatusid, updatedby=puserid,updateddate=sysdate where StoreId=pstoreid and UserId=puserid;
   rowsOut := SQL%rowcount;
   COMMIT; 
 else
   insert into MyFavorite(Userid,storeid,productid,statusid,Createdby,createddate,updateddate)
   values(puserid,pstoreid,0,pstatusid,puserid,sysdate,sysdate);
   rowsOut := SQL%rowcount;
   COMMIT; 
 end if;

END FAV_FAVORITE_STORE_SAVE;

PROCEDURE FAV_FAVORITE_PRODUCT_GETPAGINATED(puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT FAV_CURSOR_FAVORITE)
IS
BEGIN

OPEN cursorOut FOR 
WITH MyFavorite_Product_Temporal
AS
(
select Id,ProductId,UserId,Name,ShortDescription,ImageUrl,CategoryName,IsFavorite,StatusId,IsVisible,RetailPrice,StoreName,routeseo,issyncseo, row_number() over(order by NVL(updateddate, createddate) desc) as NroRow from
(SELECT distinct MyFav.Id,Pro.Id ProductId,MyFav.Userid, Pro.Name,Pro.ShortDescription,
 (select Prdii.ImageUrl from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId 
  inner join Productdetail Pdll on Pdll.ProductId = Pro.Id inner join productdetailimage Prdii on Prdii.ProductDetailId = Pdll.Id
  and rownum=1) as ImageUrl,
(select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Stp.StoreId and rownum=1) as CategoryName,MyFav.createddate,MyFav.updateddate,
case when MyFav.StatusId=1 then 1 else 0 end as IsFavorite, Pro.Statusid as StatusId, Pro.Isvisible, Pdl.RetailPrice, str.name as StoreName,
  pro.routeseo,pro.issyncseo
FROM MyFavorite MyFav 
    inner join Product Pro on MyFav.ProductId=Pro.Id
    inner join Productdetail Pdl on Pdl.ProductId = Pro.Id
    inner join productdetailimage Prdi on Prdi.ProductDetailId = Pdl.Id
    inner join storeproduct Stp on Stp.ProductId = Pro.Id
    inner join store str on str.id = Stp.storeid
    inner join Categorystore CatSto on Stp.StoreId=CatSto.Idstore and MyFav.Userid=puserid and MyFav.Statusid=1 order by MyFav.Updateddate desc))
select Id as MyFavoriteId,ProductId as Id,UserId,Name,ShortDescription,ImageUrl,
CategoryName,IsFavorite,StatusId,IsVisible,RetailPrice,StoreName,routeseo,issyncseo,NroRow,(select count(*) from MyFavorite_Product_Temporal) as TotalRow 
from MyFavorite_Product_Temporal where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;

END FAV_FAVORITE_PRODUCT_GETPAGINATED;

PROCEDURE FAV_FAVORITE_PRODUCT_SAVE(puserid IN NUMBER, pproductid IN NUMBER, pstatusid IN NUMBER, rowsOut out NUMBER)
IS
idFavorite NUMBER;
BEGIN
 SAVEPOINT start_tx;

 select NVL(max(id),0) INTO idFavorite
 from MyFavorite where ProductId=pproductid and UserId=puserid;

 if idFavorite > 0
 then
 begin
   update MyFavorite set StatusId=pstatusid, updatedby=puserid,updateddate=sysdate where ProductId=pproductid and UserId=puserid;
   rowsOut := SQL%rowcount;
   end;
 else
 begin
   insert into MyFavorite(Userid,productid,storeid,statusid,Createdby,createddate,updateddate)
   values(puserid,pproductid,0,pstatusid,puserid,sysdate,sysdate);
   rowsOut := SQL%rowcount;
   end;
 end if;
 commit;
EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK TO start_tx;
                PKG_LOG.LOG_GETERRORINFO;
END FAV_FAVORITE_PRODUCT_SAVE;
PROCEDURE FAV_FAVORITE_STORE_GETPAGINATED_DYNAMIC(
    puserid IN NUMBER,
    pcategories VARCHAR2,
    pcategoryid IN NUMBER,
    psubcategoryid IN NUMBER,
    psubsubCategoryid IN NUMBER,
    porderby IN VARCHAR2,
    porderdirection IN VARCHAR2,
    ppricelow IN NUMBER,
    ppricehigh IN NUMBER,
    pishomedelivery IN NUMBER,
    pisstorepickup IN NUMBER,
    pdistrictid IN NUMBER,
    psearch IN VARCHAR2,
    pstoreid IN NUMBER,
    prow IN NUMBER,
    ptotalRecord IN NUMBER,
    cursorOut OUT FAV_CURSOR_FAVORITE
)
AS
    v_sql VARCHAR2(4000);
BEGIN
    v_sql := 'WITH MyFavorite_Store_Temporal AS (
                SELECT DISTINCT
                    MyFav.Id AS MyFavoriteId,
                    Sto.Id AS StoreId,
                    MyFav.Userid,
                    Sto.Name,
                    Sto.Description,
                    Sto.Logo,
                    Sto.Linkfacebook,
                    Sto.Linkinstagram,
                    Sto.Linktwitter,
                    Sto.Linktiktok,
                    (SELECT CatP.name FROM Category CatP 
                     INNER JOIN CategoryStore CatStop 
                     ON CatP.Id = CatStop.Idcategory 
                     AND CatStop.Idstore = Sto.Id WHERE ROWNUM = 1) AS CategoryName,
                    MyFav.CreatedDate,
                    MyFav.UpdatedDate,
                    CASE 
                        WHEN MyFav.StatusId = 1 THEN 1 
                        ELSE 0 
                    END AS IsFavorite,
                    Sto.Statusid AS StatusId,
                    Sto.Isvisible,
                    Sto.Routeseo,
                    Sto.issyncseo,
                    ROW_NUMBER() OVER (ORDER BY ';

    -- Ordenación dinámica
    IF porderby IS NOT NULL THEN
        IF porderby IN ('name') THEN
            v_sql := v_sql || 'UPPER(' || porderby || ')';
        ELSE
            v_sql := v_sql || 'MyFav.' || porderby;
        END IF;

        IF porderdirection IS NOT NULL THEN
            v_sql := v_sql || ' ' || porderdirection;
        ELSE
            v_sql := v_sql || ' DESC';
        END IF;
    ELSE
        v_sql := v_sql || 'MyFav.UpdatedDate DESC, MyFav.Id';  -- Agregamos MyFav.Id para asegurar unicidad en la ordenación
    END IF;

    v_sql := v_sql || ') AS NroRow
                FROM MyFavorite MyFav 
                INNER JOIN Store Sto ON MyFav.Storeid = Sto.Id
                WHERE MyFav.Userid = ' || puserid || ' 
                AND MyFav.Statusid = 1 
                AND Sto.Isvisible = 1';

    IF pcategories IS NOT NULL AND LENGTH(pcategories) > 0 THEN
    v_sql := v_sql || ' AND EXISTS (
        SELECT 1
        FROM categorystore sc
        WHERE sc.idstore = sto.id
        AND sc.idcategory IN (' || pcategories || '))';
    END IF;
    -- Filtros adicionales
    IF psearch IS NOT NULL THEN
        v_sql := v_sql || ' AND lower(Sto.Name) LIKE ''%' || lower(psearch) || '%''';
    END IF;

    IF pstoreid != 0 THEN
        v_sql := v_sql || ' AND Sto.Id = ' || pstoreid;
    END IF;

    IF pcategoryid != 0 THEN
        v_sql := v_sql || ' AND EXISTS (SELECT 1 FROM CategoryStore CS WHERE CS.Idstore = Sto.Id AND CS.Idcategory = ' || pcategoryid || ')';
    END IF;

    -- Final de la consulta dinámica
    v_sql := v_sql || '),
              TotalRow AS (
                SELECT COUNT(*) AS TotalRow FROM MyFavorite_Store_Temporal
              )
              SELECT MyFavoriteId, StoreId, Userid, Name, Description, Logo, Linkfacebook, Linkinstagram, Linktwitter, Linktiktok, CategoryName, IsFavorite, StatusId, IsVisible, Routeseo, issyncseo, NroRow, TotalRow
              FROM MyFavorite_Store_Temporal, TotalRow
              WHERE NroRow BETWEEN ((' || prow || ' - 1) * ' || ptotalRecord || ' + 1) 
              AND (' || prow || ' * ' || ptotalRecord || ') 
              ORDER BY NroRow';

    -- Mostrar la consulta generada para depuración
    DBMS_OUTPUT.PUT_LINE(v_sql);

    -- Ejecutar la consulta y devolver el cursor de salida
    OPEN cursorOut FOR v_sql;
END FAV_FAVORITE_STORE_GETPAGINATED_DYNAMIC;

PROCEDURE FAV_FAVORITE_PRODUCT_GETPAGINATED_DYNAMIC(
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
    cursorOut OUT FAV_CURSOR_FAVORITE
)
AS
    v_sql VARCHAR2(4000);
BEGIN 
    v_sql := 'WITH FilteredProducts AS (
                SELECT DISTINCT
                    P.Id,
                    P.Id as ProductId,
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
                FROM MyFavorite MyFav
                INNER JOIN product p on MyFav.ProductId=p.Id
                INNER JOIN subsubcategory ssc ON p.subsubcategoryid = ssc.id
                INNER JOIN subcategory sc ON ssc.subcategoryid = sc.id
                INNER JOIN category c ON sc.categoryid = c.id
                INNER JOIN productdetail pd on p.id=pd.productid
                INNER JOIN storeproduct Stp on Stp.ProductId = p.Id
                INNER JOIN store str on str.id = Stp.storeid
                INNER JOIN Categorystore CatSto on Stp.StoreId=CatSto.Idstore and MyFav.Userid=' || puserid || ' and MyFav.Statusid=1
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
END FAV_FAVORITE_PRODUCT_GETPAGINATED_DYNAMIC;

END PKG_MY_FAVORITE;
/