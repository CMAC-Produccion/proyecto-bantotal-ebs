create or replace PACKAGE USRECOSISTEMAS.PKG_STORE IS
type SEC_CURSOR_STORE IS REF CURSOR;

PROCEDURE SEC_STORE_GET_BY_USERID(puserid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_GET_BY_ID(pid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
paddress IN VARCHAR2,
plogo IN VARCHAR2,
preference IN VARCHAR2,
pscheduleofoperation IN VARCHAR2,
pcellphone IN VARCHAR2,
plinkfacebook IN VARCHAR2,
plinkinstagram IN VARCHAR2,
plinktiktok IN VARCHAR2,
plinktwitter IN VARCHAR2,
puserid IN NUMBER,
pisvisible IN NUMBER,
pdistrictid IN NUMBER,
pishomedelivery IN NUMBER,
pisstorepickup IN NUMBER,
rowsOut out NUMBER);
PROCEDURE SEC_STORE_UPDATESTATUS(pid IN NUMBER, pstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE SEC_STORE_UPDATEISVISIBLE(pid IN NUMBER, pisvisible IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE SEC_STORE_INSERT(
puserid IN NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
plogo IN VARCHAR2,
preference IN VARCHAR2,
paddress IN VARCHAR2,
pcellphone IN VARCHAR2,
pbusiness IN VARCHAR2,
pscheduleofoperation IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
pisvisible IN NUMBER,
plinkfacebook IN VARCHAR2,
plinkinstagram IN VARCHAR2,
plinktwitter IN VARCHAR2,
plinktiktok IN VARCHAR2,
pdistrictid IN NUMBER,
pishomedelivery IN NUMBER,
pisstorepickup IN NUMBER,
IDOUT out NUMBER);
PROCEDURE PRD_PRODUCT_SEARCH_STORE_PAGINATED(pstoreid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_EXIST(pname IN VARCHAR2,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_GET_DETAIL_BYPRODUCTID(pproductid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_SEARCH_BY_CATEGORY_PAGINATED(pcategoryid IN NUMBER,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_SEARCH_PAGINATED(pstore IN VARCHAR2,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_MORE_RELEVANT_PAGINATED(puserid IN NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_AUTOCOMPLETE(pname in VARCHAR2,prows in NUMBER,cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_UPDATE_CURRENT(pidstore IN NUMBER,puserid in number, pcurrent IN NUMBER,rowsOut out NUMBER);
PROCEDURE SEC_STORE_CATEGORY_EXIST(pstoreid IN NUMBER, puserid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_GETBYROUTESEO(prouteseo IN VARCHAR2,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_UPDATEROUTESEO(rowsOut out NUMBER);
PROCEDURE SEC_STORE_GETALLFORSITEMAP(cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_MORE_RELEVANT_UBIGEO_PAGINATED(puserid IN NUMBER,pdistrictid IN NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_FILTER_DYNAMIC_PAGINATED(
    puserid INT,
    pcategories VARCHAR2,
    porderby VARCHAR2,
    porderdirection VARCHAR2,
    pdistrictid INT,
    psearch VARCHAR2,
    prow INT,
    ptotalrecord INT,
    cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_ADMIN_STORE_SEARCH_PAGINATED(puserid IN NUMBER,ptextsearch IN VARCHAR2, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_ADMIN_STORE_GET_ALL(puserid IN NUMBER,psearch IN VARCHAR2,pstatusid IN NUMBER, pcategoryid IN NUMBER, pstatusverificationid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_ADMIN_INSERT(
puserid IN NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
plogo IN VARCHAR2,
preference IN VARCHAR2,
paddress IN VARCHAR2,
pcellphone IN VARCHAR2,
pbusiness IN VARCHAR2,
pscheduleofoperation IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
pisvisible IN NUMBER,
plinkfacebook IN VARCHAR2,
plinkinstagram IN VARCHAR2,
plinktwitter IN VARCHAR2,
plinktiktok IN VARCHAR2,
pdistrictid IN NUMBER,
pishomedelivery IN NUMBER,
pisstorepickup IN NUMBER,
IDOUT out NUMBER);
PROCEDURE SEC_STORE_ADMIN_EXIST(pname IN VARCHAR2,puserid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_ADMIN_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
paddress IN VARCHAR2,
plogo IN VARCHAR2,
preference IN VARCHAR2,
pscheduleofoperation IN VARCHAR2,
pcellphone IN VARCHAR2,
plinkfacebook IN VARCHAR2,
plinkinstagram IN VARCHAR2,
plinktiktok IN VARCHAR2,
plinktwitter IN VARCHAR2,
puserid IN NUMBER,
pupdatedby IN NUMBER,
pisvisible IN NUMBER,
pdistrictid IN NUMBER,
pishomedelivery IN NUMBER,
pisstorepickup IN NUMBER,
pstatusid IN NUMBER,
rowsOut out NUMBER);
PROCEDURE SEC_STORE_GET_BY_ID_ADMIN(pid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_UPDATESTATUS_ADMIN(pid IN NUMBER, pstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER);
PROCEDURE SEC_STORE_VALIDATE_CATEGORY_UPLOAD_MASIVE(pstoreid IN NUMBER, psubSubCategoryIds IN VARCHAR2 ,presult out SEC_CURSOR_STORE);
PROCEDURE SEC_ADMIN_STORE_GET_BYID(pstoreid IN NUMBER, cursorOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STOREVERIFICATION_UPDATE_ADMIN(
pid IN NUMBER,
pruc IN VARCHAR2,
pcommercialname IN VARCHAR2,
pcompanyname IN VARCHAR2,
prucfile IN VARCHAR2,
ptypeofcompanyid IN NUMBER,
pfiscaladdress IN VARCHAR2,
pdistrictid IN NUMBER,
pnameoflegalrepresentative IN VARCHAR2,
pdocumenttypeid IN NUMBER,
pdocumentnumber IN VARCHAR2,
pdocumentfile IN VARCHAR2,
pemail IN VARCHAR2,
pcellphone IN VARCHAR2,
pverificationstatusid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE SEC_STOREVERIFICATION_GET_BYID_ADMIN(pid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STOREVERIFICATION_INSERT(
pstoreid in NUMBER,
pruc IN VARCHAR2,
pcommercialname IN VARCHAR2,
pcompanyname IN VARCHAR2,
prucfile IN VARCHAR2,
ptypeofcompanyid IN NUMBER,
pfiscaladdress IN VARCHAR2,
pdistrictid IN NUMBER,
pnameoflegalrepresentative IN VARCHAR2,
pdocumenttypeid IN NUMBER,
pdocumentnumber IN VARCHAR2,
pdocumentfile IN VARCHAR2,
pemail IN VARCHAR2,
pcellphone IN VARCHAR2,
pverificationstatusid IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);
PROCEDURE SEC_STOREVERIFICATIONRUC_EXIST(pruc IN VARCHAR2,cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STORE_GET_PAGINATED_BY_USERID(puserid IN NUMBER, prow IN NUMBER, ptotalrecord IN NUMBER, cursorStoreOut OUT SEC_CURSOR_STORE);
PROCEDURE SEC_STOREVERIFICATION_FILTER_DYNAMIC_PAGINATED(
    puserid INT,
    pcategories VARCHAR2,
    porderby VARCHAR2,
    porderdirection VARCHAR2,
    pdistrictid INT,
    psearch VARCHAR2,
    prow INT,
    ptotalrecord INT,
    cursorOut OUT SEC_CURSOR_STORE);
END PKG_STORE;
/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_STORE IS

PROCEDURE SEC_STORE_GET_BY_USERID(
    puserid IN NUMBER,
    cursorStoreOut OUT SEC_CURSOR_STORE
) 
IS
    v_employeeExists NUMBER;
BEGIN
    -- Verificar si existe un registro en la tabla employee con el puserid asignado
    SELECT COUNT(*)
    INTO v_employeeExists
    FROM employee e
    WHERE e.iduserasigned = puserid
      AND e.statusid = 1;

    IF v_employeeExists > 0 THEN
        -- Caso 1: Si el usuario está asignado en la tabla employee
        OPEN cursorStoreOut FOR
            SELECT
                s.id,
                s.name,
                s.description,
                s.logo,
                s.currentstore,
                s.isvisible, 
                s.userid,
                LISTAGG(cat.name, ', ') WITHIN GROUP (ORDER BY s.id) AS categorys,
                s.issyncseo,
                s.routeseo,
                COALESCE(sv.verificationstatusid, 1) AS verificationstatusid
            FROM 
                STORE s
                JOIN CategoryStore ct ON s.id = ct.idstore  
                JOIN Category cat ON ct.idcategory = cat.id
                LEFT JOIN storeverification sv ON s.id = sv.storeid
                -- Se une con Employee y EmployeeStore
                INNER JOIN employeestore es ON s.id = es.storeid
                INNER JOIN employee e ON e.id = es.employeeid
            WHERE 
                s.statusid = 1 
                AND e.iduserasigned = puserid
            GROUP BY 
                s.id, s.name, s.description, s.logo, s.currentstore, s.isvisible, 
                s.userid, s.issyncseo, s.routeseo, COALESCE(sv.verificationstatusid, 1);

    ELSE
        -- Caso 2: Si no hay registros en employee, usar directamente el USERID de STORE
        OPEN cursorStoreOut FOR
            SELECT
                s.id,
                s.name,
                s.description,
                s.logo,
                s.currentstore,
                s.isvisible, 
                s.userid,
                LISTAGG(cat.name, ', ') WITHIN GROUP (ORDER BY s.id) AS categorys,
                s.issyncseo,
                s.routeseo,
                COALESCE(sv.verificationstatusid, 1) AS verificationstatusid
            FROM 
                STORE s
                JOIN CategoryStore ct ON s.id = ct.idstore  
                JOIN Category cat ON ct.idcategory = cat.id
                LEFT JOIN storeverification sv ON s.id = sv.storeid
            WHERE 
                s.userid = puserid
                AND s.statusid = 1
            GROUP BY 
                s.id, s.name, s.description, s.logo, s.currentstore, s.isvisible, 
                s.userid, s.issyncseo, s.routeseo, COALESCE(sv.verificationstatusid, 1);
    END IF;
END SEC_STORE_GET_BY_USERID;

PROCEDURE SEC_STORE_GET_BY_ID(pid IN NUMBER, cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorStoreOut FOR
  SELECT
    t.id,
    t.name,
    t.description,
    t.logo,
    t.isvisible,
    t.address,
    t.cellPhone,
    t.logo,
    t.reference,
    t.business,
    t.scheduleofoperation,
    t.linkfacebook,
    t.linkinstagram,
    t.linktwitter,
    t.linktiktok,
    LISTAGG(cat.name, ', ') WITHIN GROUP (ORDER BY t.id) AS categorys,
    (SELECT CatP.name 
     FROM Category CatP 
     INNER JOIN CategoryStore CatStop ON CatP.Id = CatStop.Idcategory 
     WHERE CatStop.Idstore = t.Id AND ROWNUM = 1) AS CategoryName,
    NVL(t.districtid, -1) AS districtid,
    t.ishomedelivery,
    t.isstorepickup,
    NVL(prov.id, -1) AS ProvinceId,
    NVL(dep.id, -1) AS DepartmentId,
    t.issyncseo,
    t.routeseo,
    t.IsVerified,
    Fn_Store_GetOrderRatingAverage(pid) AS AverageOrderRating,
    Fn_Store_GetTotalSales(pid) AS TotalSales,
    Fn_Store_GetTotalOrderRating(pid) AS TotalOrderRating,
      prov.name as ProvinceName,
      dep.name as DepartmentName,
      dis.name as DistrictName,
      t.userid,
      t.email
  FROM (
    SELECT 
      sto.id, 
      sto.name,
      sto.description,
      sto.logo,
      sto.isvisible,
      sto.address,
      sto.cellPhone,
      sto.reference,
      sto.business,
      sto.scheduleofoperation,
      sto.linkfacebook,
      sto.linkinstagram,
      sto.linktwitter,
      sto.linktiktok,
      sto.districtid,
      sto.ishomedelivery,
      sto.isstorepickup,
      sto.issyncseo,
      sto.routeseo,
      sto.statusid,
      sto.userid,
      NVL(
        (SELECT CASE 
                 WHEN stover.verificationstatusid = 3 THEN 1 
                 ELSE 0 
             END 
         FROM StoreVerification stover 
         WHERE stover.StoreID = sto.id AND stover.statusid = 1),
        0) AS IsVerified,
      NVL(
        (SELECT us.email
         FROM UserPerson us 
         WHERE sto.userid = us.id AND sto.statusid = 1),
        0) AS email
    FROM STORE sto
  ) t
  JOIN CategoryStore ct ON t.id = ct.idstore
  JOIN Category cat ON ct.idcategory = cat.id
  LEFT JOIN District dis ON dis.id = t.districtid
  LEFT JOIN Province prov ON dis.provinceid = prov.id
  LEFT JOIN Department dep ON prov.departmentid = dep.id
  WHERE t.id = pid AND t.statusid = 1
  GROUP BY 
    t.id, t.name, t.description, t.logo, t.isvisible,
    t.address, t.cellPhone, t.reference,
    t.business, t.scheduleofoperation, t.linkfacebook,
    t.linkinstagram, t.linktwitter, t.linktiktok,
    t.districtid, t.ishomedelivery, t.isstorepickup,
    t.issyncseo, t.routeseo, prov.id, dep.id, t.IsVerified,prov.name,dep.name,dis.name,t.userid,t.email;
END SEC_STORE_GET_BY_ID;


PROCEDURE SEC_STORE_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
paddress IN VARCHAR2,
plogo IN VARCHAR2,
preference IN VARCHAR2,
pscheduleofoperation IN VARCHAR2,
pcellphone IN VARCHAR2,
plinkfacebook IN VARCHAR2,
plinkinstagram IN VARCHAR2,
plinktiktok IN VARCHAR2,
plinktwitter IN VARCHAR2,
puserid IN NUMBER,
pisvisible IN NUMBER,
pdistrictid IN NUMBER,
pishomedelivery IN NUMBER,
pisstorepickup IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE STORE SET NAME=pname, ADDRESS=paddress, LOGO=plogo, REFERENCE=preference, SCHEDULEOFOPERATION=pscheduleofoperation,
  CELLPHONE=pcellphone,LINKFACEBOOK=plinkfacebook,
  LINKINSTAGRAM=plinkinstagram,LINKTIKTOK=plinktiktok,LINKTWITTER=plinktwitter,
  UPDATEDBY = puserid, UPDATEDDATE = sysdate,isvisible = pisvisible,
  districtid=pdistrictid, ishomedelivery=pishomedelivery, isstorepickup=pisstorepickup
  WHERE ID = pid;
rowsOut := SQL%rowcount;
 COMMIT;
END SEC_STORE_UPDATE;

PROCEDURE SEC_STORE_UPDATESTATUS(pid IN NUMBER, pstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE STORE SET STATUSID = pstatusid, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;
END SEC_STORE_UPDATESTATUS;

PROCEDURE SEC_STORE_UPDATEISVISIBLE(pid IN NUMBER, pisvisible IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE STORE SET ISVISIBLE = pisvisible, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;
END SEC_STORE_UPDATEISVISIBLE;

PROCEDURE SEC_STORE_INSERT(
puserid IN NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
plogo IN VARCHAR2,
preference IN VARCHAR2,
paddress IN VARCHAR2,
pcellphone IN VARCHAR2,
pbusiness IN VARCHAR2,
pscheduleofoperation IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
pisvisible IN NUMBER,
plinkfacebook IN VARCHAR2,
plinkinstagram IN VARCHAR2,
plinktwitter IN VARCHAR2,
plinktiktok IN VARCHAR2,
pdistrictid IN NUMBER,
pishomedelivery IN NUMBER,
pisstorepickup IN NUMBER,
IDOUT out NUMBER)
IS
BEGIN
  
 INSERT INTO STORE (
USERID,
NAME,
DESCRIPTION,
LOGO,
REFERENCE,
ADDRESS,
CELLPHONE,
BUSINESS,
SCHEDULEOFOPERATION,
STATUSID,
CREATEDBY,
CREATEDDATE,
UPDATEDBY,
UPDATEDDATE,
ISVISIBLE,
LINKFACEBOOK,
LINKINSTAGRAM,
LINKTWITTER,
LINKTIKTOK,
DISTRICTID,
ISHOMEDELIVERY,
ISSTOREPICKUP,
ROUTESEO,
ISSYNCSEO
)
VALUES
(puserid,
pname,
pdescription,
plogo,
preference,
paddress,
pcellphone,
pbusiness,
pscheduleofoperation,
pstatusid,
pcreatedby,
sysdate,
NULL,
NULL,
pisvisible,
plinkfacebook,
plinkinstagram,
plinktwitter,
plinktiktok,
pdistrictid,
pishomedelivery,
pisstorepickup,
LOWER(REGEXP_REPLACE(TRIM(pname), '[^a-zA-Z0-9]+', '-')),
0
)
  returning ID into IDOUT;
COMMIT;

END SEC_STORE_INSERT;


PROCEDURE PRD_PRODUCT_SEARCH_STORE_PAGINATED(pstoreid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorOut FOR
  select * from
  (select distinct Prod.ID, Prod.TYPE,ProdDet.ProductID,  Prod.CONDITION, Prod.NAME, Prod.SHORTDESCRIPTION,Prod.LARGEDESCRIPTION,Cat.Name as CategoryName,ProdDet.Stock, row_number() over(order by Prod.CREATEDDATE desc) as NroRow,
  (select count(*) from Product ProdT inner join StoreProduct StoProdT on ProdT.Id=StoProdT.Productid and StoProdT.Storeid=pStoreId) as TotalRow
  from Product Prod
  inner join subsubcategory ssc on prod.subsubcategoryid=ssc.id
  inner join subcategory sc on sc.id=ssc.subcategoryid
  inner join Category Cat on Cat.ID=sc.categoryid
  inner join ProductDetail ProdDet on ProdDet.ProductID=Prod.ID
  inner join StoreProduct StoPro on StoPro.Productid=PROD.Id and StoPro.Storeid=pStoreId where Prod.statusid=1 and Prod.IsVisible=1) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord)
  order by nrorow;
END PRD_PRODUCT_SEARCH_STORE_PAGINATED;

PROCEDURE SEC_STORE_EXIST(pname IN VARCHAR2,cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
 OPEN cursorStoreOut FOR
    SELECT COUNT(1) from STORE WHERE lower(NAME) = lower(pname) and STATUSID = 1;
END SEC_STORE_EXIST;

PROCEDURE SEC_STORE_GET_DETAIL_BYPRODUCTID(pproductid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
OPEN cursorStoreOut FOR
 SELECT
 us.ID as UserSellerId,
 st.name as storename,
 us.firstname,
 us.lastname,
 us.email,
 st.cellphone,
 st.linkfacebook,
 st.linkinstagram,
 st.linktwitter,
 st.linktiktok,
 st.id,
 st.issyncseo,
 st.routeseo,
 st.address,
 dep.name || ', ' || prov.name || ', ' || dis.name as ubigeo
 FROM STORE st INNER JOIN STOREPRODUCT stpr
 on st.ID = stpr.STOREID INNER JOIN USERPERSON us
 on st.USERID = us.ID LEFT JOIN District dis
 on dis.id = st.districtid LEFT JOIN Province prov
 on dis.provinceid = prov.id LEFT JOIN Department dep
 on prov.departmentid = dep.id
 WHERE stpr.PRODUCTID = pproductid;
END SEC_STORE_GET_DETAIL_BYPRODUCTID;

PROCEDURE SEC_STORE_SEARCH_BY_CATEGORY_PAGINATED(pcategoryid IN NUMBER,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Store_Temporal
  AS
  (select ID,Name,Description,Logo,LinkFacebook,LinkInstagram,LinkTwitter,LinkTikTok,CategoryName,CategoryID,IsFavorite,IsVisible,issyncseo,
 routeseo, row_number() over(order by CreatedDate desc) as NroRow from
  (select distinct Sto.ID,Sto.Name,Sto.Description,Sto.Logo, Sto.LinkFacebook,  Sto.LinkInstagram, Sto.LinkTwitter, Sto.LinkTikTok,Sto.CreatedDate,Sto.IsVisible,sto.issyncseo,
 sto.routeseo,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1 and CatP.id=pcategoryid) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1 and CatP.id=pcategoryid) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and storeid=Sto.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from Store Sto inner join CategoryStore CatSto on Sto.Id=CatSto.Idstore inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Sto.Statusid=1 and Sto.isvisible = 1 and Cat.Id=pcategoryid and CatSto.Idcategory=pcategoryid))
  select * from
  (select ID,Name,Description,Logo,LinkFacebook,LinkInstagram,LinkTwitter,LinkTikTok,CategoryName,CategoryID,IsFavorite,IsVisible,issyncseo,
 routeseo, row_number() over(order by CreatedDate desc) as NroRow, (select count(*) from Store_Temporal) as TotalRow from
  (select distinct Sto.ID,Sto.Name,Sto.Description,Sto.Logo, Sto.LinkFacebook,  Sto.LinkInstagram, Sto.LinkTwitter, Sto.LinkTikTok,Sto.CreatedDate,Sto.IsVisible,sto.issyncseo,
 sto.routeseo,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1 and CatP.id=pcategoryid) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1 and CatP.id=pcategoryid) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and storeid=Sto.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from Store Sto inner join CategoryStore CatSto on Sto.Id=CatSto.Idstore inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Sto.Statusid=1 and Sto.isvisible = 1 and Cat.Id=pCategoryid and CatSto.Idcategory=pcategoryid)) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_STORE_SEARCH_BY_CATEGORY_PAGINATED;



PROCEDURE SEC_STORE_SEARCH_PAGINATED(pstore IN VARCHAR2,puserid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Store_Temporal
  AS
  (select ID,Name,Description,Logo,LinkFacebook,LinkInstagram,LinkTwitter,LinkTikTok,CategoryName,CategoryID,IsFavorite,IsVisible,issyncseo,
 routeseo, row_number() over(order by Name asc) as NroRow from
  (select distinct Sto.ID,Sto.Name,Sto.Description,Sto.Logo, Sto.LinkFacebook,  Sto.LinkInstagram, Sto.LinkTwitter, Sto.LinkTikTok,Sto.CreatedDate,Sto.IsVisible,sto.issyncseo,
 sto.routeseo,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and storeid=Sto.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from Store Sto inner join CategoryStore CatSto on Sto.Id=CatSto.Idstore inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Sto.Statusid=1 and Sto.isvisible = 1 and lower(Sto.name) like '%'||lower(pstore)||'%'))
  select * from
  (select ID,Name,Description,Logo,LinkFacebook,LinkInstagram,LinkTwitter,LinkTikTok,CategoryName,CategoryID,IsFavorite,IsVisible,issyncseo,
 routeseo, row_number() over(order by Name asc) as NroRow, (select count(*) from Store_Temporal) as TotalRow from
  (select distinct Sto.ID,Sto.Name,Sto.Description,Sto.Logo, Sto.LinkFacebook,  Sto.LinkInstagram, Sto.LinkTwitter, Sto.LinkTikTok,Sto.CreatedDate,Sto.IsVisible,sto.issyncseo,
 sto.routeseo,
  (select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryName,
  (select CatP.Id from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryID,
  case when (select id from myfavorite where statusid=1 and userid=puserid and storeid=Sto.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite
  from Store Sto inner join CategoryStore CatSto on Sto.Id=CatSto.Idstore inner join Category Cat on CatSto.Idcategory=Cat.Id
  Where Sto.Statusid=1 and Sto.isvisible = 1 and lower(Sto.name) like '%'||lower(pstore)||'%')) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_STORE_SEARCH_PAGINATED;

PROCEDURE SEC_STORE_MORE_RELEVANT_PAGINATED(puserid IN NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Store_More_Revelant
as
(
select Id,UserId,Name,Description,CellPhone,Logo,Linkfacebook,Linkinstagram,Linktwitter,Linktiktok,CategoryName,IsFavorite,TotalProduct,IsVisible,routeseo,issyncseo, row_number() over(order by TotalProduct desc) as NroRow from
(select distinct Sto.Id,Sto.UserId,Sto.Name,Sto.Description,Sto.CellPhone,Sto.Logo,Sto.Linkfacebook,Sto.Linkinstagram,Sto.Linktwitter,Sto.Linktiktok,Sto.StatusId,Sto.IsVisible,
 sto.routeseo,sto.issyncseo,case when (select id from myfavorite where statusid=1 and userid=puserid and storeid=Sto.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,
(select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryName,
(select count(*) from storeproduct stoprod inner join product prod on stoprod.productid=prod.id and stoprod.storeid=Sto.id where stoprod.storeid=Sto.id and stoprod.statusid=1) as TotalProduct
from store Sto
where Sto.statusid=1 and Sto.IsVisible=1))
select Id,UserId,Name,Description,CellPhone,Logo,Linkfacebook,Linkinstagram,Linktwitter,Linktiktok,CategoryName,IsFavorite,TotalProduct,IsVisible,routeseo,issyncseo,NroRow,(select count(*) from Store_More_Revelant) as TotalRow from Store_More_Revelant where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_STORE_MORE_RELEVANT_PAGINATED;

PROCEDURE SEC_STORE_AUTOCOMPLETE(pname in VARCHAR2,prows in NUMBER,cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
 OPEN cursorOut FOR
 select sto.id,sto.name,up.email as useremail from store sto
 inner join userperson up on sto.userid=up.id
 where lower(sto.name) like lower(concat('%',pname)) and sto.statusid = 1 and sto.isvisible = 1
 ORDER BY sto.id
 OFFSET 0 ROWS FETCH NEXT prows ROWS ONLY;
END SEC_STORE_AUTOCOMPLETE;

PROCEDURE SEC_STORE_UPDATE_CURRENT(pidstore IN NUMBER,puserid in number, pcurrent IN NUMBER,rowsOut out NUMBER)
IS
BEGIN
 UPDATE STORE SET CURRENTSTORE = 0 WHERE USERID = puserid;
 UPDATE STORE SET CURRENTSTORE = pcurrent, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE ID = pidstore;
  rowsOut := SQL%rowcount;
 COMMIT;
END SEC_STORE_UPDATE_CURRENT;
PROCEDURE SEC_STORE_CATEGORY_EXIST(pstoreid IN NUMBER, puserid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
 OPEN cursorStoreOut FOR
    SELECT NVL(iscreatecategory, 0) as iscreatecategory from UserPerson WHERE id = puserid and STATUSID = 1;
END SEC_STORE_CATEGORY_EXIST;

PROCEDURE SEC_STORE_GETBYROUTESEO(prouteseo IN VARCHAR2, cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorStoreOut FOR
  SELECT
    t.id,
    t.name,
    t.description,
    t.logo,
    t.isvisible,
    t.address,
    t.cellPhone,
    t.logo,
    t.reference,
    t.business,
    t.scheduleofoperation,
    t.linkfacebook,
    t.linkinstagram,
    t.linktwitter,
    t.linktiktok,
    LISTAGG(cat.name, ', ') WITHIN GROUP (ORDER BY t.id) AS categorys,
    (SELECT CatP.name 
     FROM Category CatP 
     INNER JOIN CategoryStore CatStop ON CatP.Id = CatStop.Idcategory 
     WHERE CatStop.Idstore = t.Id AND ROWNUM = 1) AS CategoryName,
    NVL(t.districtid, -1) AS districtid,
    t.ishomedelivery,
    t.isstorepickup,
    NVL(prov.id, -1) AS ProvinceId,
    NVL(dep.id, -1) AS DepartmentId,
    t.issyncseo,
    t.routeseo,
    t.IsVerified
  FROM (
    SELECT 
      sto.id, 
      sto.name,
      sto.description,
      sto.logo,
      sto.isvisible,
      sto.address,
      sto.cellPhone,
      sto.reference,
      sto.business,
      sto.scheduleofoperation,
      sto.linkfacebook,
      sto.linkinstagram,
      sto.linktwitter,
      sto.linktiktok,
      sto.districtid,
      sto.ishomedelivery,
      sto.isstorepickup,
      sto.issyncseo,
      sto.routeseo,
      sto.statusid,
      NVL(
        (SELECT CASE 
                 WHEN stover.verificationstatusid = 3 THEN 1 
                 ELSE 0 
             END 
         FROM StoreVerification stover 
         WHERE stover.StoreID = sto.id AND stover.statusid = 1),
        0) AS IsVerified
    FROM STORE sto
  ) t
  JOIN CategoryStore ct ON t.id = ct.idstore
  JOIN Category cat ON ct.idcategory = cat.id
  LEFT JOIN District dis ON dis.id = t.districtid
  LEFT JOIN Province prov ON dis.provinceid = prov.id
  LEFT JOIN Department dep ON prov.departmentid = dep.id
  WHERE lower(t.routeSeo) = lower(prouteseo) AND t.statusid = 1
  GROUP BY 
    t.id, t.name, t.description, t.logo, t.isvisible,
    t.address, t.cellPhone, t.reference,
    t.business, t.scheduleofoperation, t.linkfacebook,
    t.linkinstagram, t.linktwitter, t.linktiktok,
    t.districtid, t.ishomedelivery, t.isstorepickup,
    t.issyncseo, t.routeseo, prov.id, dep.id, t.IsVerified;
END SEC_STORE_GETBYROUTESEO;


PROCEDURE SEC_STORE_UPDATEROUTESEO(rowsOut out NUMBER)
IS
BEGIN
  rowsOut := 0;
   FOR c1_rec IN (SELECT id, name
                    FROM store
                   WHERE IsSyncSeo = 0
                   FOR UPDATE OF routeSeo) LOOP
       UPDATE store
          SET routeSeo = LOWER(REGEXP_REPLACE(REMOVE_ACCENTS(TRIM(name)), '[^a-zA-Z0-9]+', '-'));
       rowsOut := rowsOut + 1;
   END LOOP;
   COMMIT;
END SEC_STORE_UPDATEROUTESEO;

PROCEDURE SEC_STORE_GETALLFORSITEMAP(cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorStoreOut FOR
 SELECT
 sto.id,
 sto.name,
 sto.issyncseo,
 sto.routeseo
 FROM STORE sto 
 WHERE sto.issyncseo=0 and sto.isvisible=1 and sto.STATUSID = 1;
END SEC_STORE_GETALLFORSITEMAP; 

PROCEDURE SEC_STORE_MORE_RELEVANT_UBIGEO_PAGINATED(puserid IN NUMBER,pdistrictid IN NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Store_More_Revelant
as
(
select Id,UserId,Name,Description,CellPhone,Logo,Linkfacebook,Linkinstagram,Linktwitter,Linktiktok,CategoryName,IsFavorite,TotalProduct,IsVisible,routeseo,issyncseo,IsVerified, row_number() over(order by TotalProduct desc) as NroRow from
(select distinct Sto.Id,Sto.UserId,Sto.Name,Sto.Description,Sto.CellPhone,Sto.Logo,Sto.Linkfacebook,Sto.Linkinstagram,Sto.Linktwitter,Sto.Linktiktok,Sto.StatusId,Sto.IsVisible,
 sto.routeseo,sto.issyncseo,case when (select id from myfavorite where statusid=1 and userid=puserid and storeid=Sto.Id)>0 then TO_NUMBER(1) else TO_NUMBER(0) end as IsFavorite,
(select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryName,
(select count(*) from storeproduct stoprod inner join product prod on stoprod.productid=prod.id and stoprod.storeid=Sto.id where stoprod.storeid=Sto.id and stoprod.statusid=1) as TotalProduct,
NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = sto.id AND sto.statusid = 1),
    0) AS IsVerified
from store Sto
where Sto.statusid=1 and Sto.IsVisible=1 and (pdistrictid = 0 or ((Sto.districtid = pdistrictid and Sto.isstorepickup = 1) or Sto.ishomedelivery =1)))) 
select Id,UserId,Name,Description,CellPhone,Logo,Linkfacebook,Linkinstagram,Linktwitter,Linktiktok,CategoryName,IsFavorite,TotalProduct,IsVisible,routeseo,issyncseo,IsVerified,NroRow,(select count(*) from Store_More_Revelant) as TotalRow from Store_More_Revelant where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END SEC_STORE_MORE_RELEVANT_UBIGEO_PAGINATED;

PROCEDURE SEC_STORE_FILTER_DYNAMIC_PAGINATED(
    puserid INT,
    pcategories VARCHAR2,
    porderby VARCHAR2,
    porderdirection VARCHAR2,
    pdistrictid INT,
    psearch VARCHAR2,
    prow INT,
    ptotalrecord INT,
    cursorOut OUT SEC_CURSOR_STORE)
AS
   v_sql VARCHAR2(4000);
BEGIN
  v_sql := 'WITH FilteredStores AS (
                SELECT 
                    sto.id,
                    sto.name,
                    sto.description,
                    sto.logo,
                    sto.linkfacebook,
                    sto.linkinstagram,
                    sto.linktwitter,
                    sto.linktiktok,
                    sto.routeseo,
                    sto.issyncseo,
                    sto.IsVisible,
                    sto.createddate,
                    case when (select id from myfavorite where statusid=1 and userid=' || puserid || ' and storeId=sto.Id)>0 then 1 else 0 end as IsFavorite,
                    LISTAGG('''' || CatP.name || '''', '', '') WITHIN GROUP (ORDER BY CatP.name) AS CategoryNames,
                    LISTAGG('''' || CatP.id || '''', '', '') WITHIN GROUP (ORDER BY CatP.id) AS CategoryIds,
                    NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = sto.id),
    0) AS IsVerified
                FROM store sto
                LEFT JOIN CategoryStore CatStop ON sto.Id = CatStop.Idstore
                LEFT JOIN Category CatP ON CatStop.Idcategory = CatP.Id
                WHERE 1=1 and sto.Statusid=1 and sto.isvisible = 1';
                
    IF pcategories IS NOT NULL AND LENGTH(pcategories) > 0 THEN
    v_sql := v_sql || ' AND EXISTS (
        SELECT 1
        FROM categorystore sc
        WHERE sc.idstore = sto.id
        AND sc.idcategory IN (' || pcategories || '))';
    END IF;
                
    IF psearch IS NOT NULL  THEN
        v_sql := v_sql || ' AND lower(sto.name) LIKE ''%' || lower(psearch) || '%'' '; 
    END IF;

    IF pdistrictid > 0 THEN
        v_sql := v_sql || ' AND sto.districtId = ' || pdistrictid;
    END IF;

    v_sql := v_sql || '
               GROUP BY sto.id, sto.name, sto.description, sto.logo, sto.linkfacebook, sto.linkinstagram, sto.linktwitter, sto.linktiktok, sto.routeseo, sto.issyncseo, sto.IsVisible, sto.createddate
              ),
              TotalRow AS (
                SELECT COUNT(*) AS TotalRow FROM FilteredStores
              ),
              PaginatedStores AS (
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
        IF porderdirection IS NOT NULL THEN
            v_sql := v_sql || ' ' || porderdirection;
        ELSE
            v_sql := v_sql || ' ASC';
        END IF;
    ELSE
        v_sql := v_sql || 'fp.id ASC';
    END IF;

    v_sql := v_sql || ') AS NroRow
              FROM FilteredStores fp, TotalRow tc
              )
              SELECT * FROM PaginatedStores
              WHERE NroRow BETWEEN ((' || prow || ' - 1) * ' || ptotalRecord || ' + 1) 
              AND (' || prow || ' * ' || ptotalRecord || ')';
              
     DBMS_OUTPUT.PUT_LINE(v_sql);


    OPEN cursorOut FOR v_sql;
END SEC_STORE_FILTER_DYNAMIC_PAGINATED;

PROCEDURE SEC_ADMIN_STORE_SEARCH_PAGINATED(puserid IN NUMBER,ptextsearch IN VARCHAR2, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorOut FOR
  select * from
(
select 
sto.id,
sto.userid,
sto.name,
sto.description,
sto.logo,
sto.address,
sto.cellphone,
sto.business,
sto.scheduleofoperation,
sto.linkfacebook,
sto.linkinstagram,
sto.linktwitter,
sto.linktiktok,
sto.IsVisible,
sto.currentstore,
sto.ishomedelivery,
sto.isstorepickup,
sto.districtid,
sto.reference,
sto.routeseo,
sto.issyncseo,
sto.createddate,
NVL((SELECT mtd.value1 
                 FROM StoreVerification stover
                 INNER JOIN mastertabledetail mtd 
                   ON stover.verificationstatusid = mtd.idparameter 
                   AND mtd.mastertableid = 30
                 WHERE stover.StoreID = sto.id AND sto.statusid = 1),
                'No Verificado') AS verificationstatusname,
NVL((SELECT stover.id 
                 FROM StoreVerification stover
                 WHERE stover.StoreID = sto.id AND sto.statusid = 1),
                0) AS storeverificationid,
(select count(*) from product prod 
inner join storeproduct stopro
on prod.id=stopro.productid and stopro.storeid=sto.id) as productQuantity,
row_number() over (order by sto.createddate desc) as NroRow,
(select count(*) from store sto1 
where sto1.statusid=1 
AND (sto1.userid = case when puserid>0 then puserid else sto1.userid end) 
AND UPPER(sto1.name) LIKE UPPER('%'||ptextsearch||'%')
  ) as TotalRow
from store sto
where sto.statusid=1
AND (sto.userid = case when puserid>0 then puserid else sto.userid end) 
AND UPPER(sto.name) LIKE UPPER('%'||ptextsearch||'%')) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord)
order by nrorow;
END SEC_ADMIN_STORE_SEARCH_PAGINATED;
PROCEDURE SEC_ADMIN_STORE_GET_ALL(puserid IN NUMBER,psearch IN VARCHAR2,pstatusid IN NUMBER, pcategoryid IN NUMBER, pstatusverificationid IN NUMBER, prow IN NUMBER, ptotalRecord IN NUMBER, cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
OPEN cursorOut FOR
    WITH Store_Base AS (
        SELECT 
            sto.id,
            sto.userid,
            sto.name,
            sto.description,
            sto.logo,
            sto.address,
            sto.cellphone,
            sto.business,
            sto.scheduleofoperation,
            sto.linkfacebook,
            sto.linkinstagram,
            sto.linktwitter,
            sto.linktiktok,
            sto.IsVisible,
            sto.currentstore,
            sto.ishomedelivery,
            sto.isstorepickup,
            sto.districtid,
            sto.reference,
            sto.routeseo,
            sto.issyncseo,
            sto.createddate,
            dis.name AS districtname,
            NVL((SELECT mtd.value1 
                 FROM StoreVerification stover
                 INNER JOIN mastertabledetail mtd 
                   ON stover.verificationstatusid = mtd.idparameter 
                   AND mtd.mastertableid = 30
                 WHERE stover.StoreID = sto.id AND sto.statusid = 1),
                'No Verificado') AS verificationstatusname,
            NVL((SELECT stover.id 
                 FROM StoreVerification stover
                 WHERE stover.StoreID = sto.id AND sto.statusid = 1),
                0) AS storeverificationid,
            NVL((SELECT stover.verificationstatusid 
                 FROM StoreVerification stover
                 WHERE stover.StoreID = sto.id AND sto.statusid = 1),
                1) AS verificationstatusid,
            sto.statusid,
            (SELECT COUNT(*)
             FROM product prod
             INNER JOIN storeproduct stopro
             ON prod.id = stopro.productid
             AND stopro.storeid = sto.id
             AND prod.statusid = 1) AS productQuantity
        FROM store sto
        JOIN CategoryStore ct
        ON sto.id = ct.idstore
        JOIN Category cat
        ON ct.idcategory = cat.id
        LEFT JOIN District dis
        ON dis.id = sto.districtid
        LEFT JOIN Province prov
        ON dis.provinceid = prov.id
        LEFT JOIN Department dep
        ON prov.departmentid = dep.id
        WHERE
            (LOWER(sto.name) LIKE LOWER(CONCAT('%', psearch))
             OR LOWER(cat.name) LIKE LOWER(CONCAT('%', psearch)))
            AND (NVL(pStatusId, -1) = -1 OR sto.statusid = pStatusId)
            AND (NVL(pCategoryId, -1) = -1 OR cat.id = pCategoryId)
            AND sto.statusid <> 2 AND (sto.userid = case when puserid>0 then puserid else sto.userid END)
        GROUP BY
            sto.id,
            sto.userid,
            sto.name,
            sto.description,
            sto.logo,
            sto.address,
            sto.cellphone,
            sto.business,
            sto.scheduleofoperation,
            sto.linkfacebook,
            sto.linkinstagram,
            sto.linktwitter,
            sto.linktiktok,
            sto.IsVisible,
            sto.currentstore,
            sto.ishomedelivery,
            sto.isstorepickup,
            sto.districtid,
            sto.reference,
            sto.routeseo,
            sto.issyncseo,
            sto.createddate,
            dis.name,
            sto.statusid
    ),
    Store_GetAll AS (
        SELECT 
            Store_Base.*,
            ROW_NUMBER() OVER (ORDER BY createddate DESC) AS NroRow
        FROM Store_Base
        WHERE NVL(pstatusverificationid, -1) = -1 OR verificationstatusid = pstatusverificationid
    )
    SELECT 
        id,
        userid,
        name,
        description,
        logo,
        address,
        cellphone,
        business,
        scheduleofoperation,
        linkfacebook,
        linkinstagram,
        linktwitter,
        linktiktok,
        IsVisible,
        currentstore,
        ishomedelivery,
        isstorepickup,
        districtid,
        reference,
        routeseo,
        issyncseo,
        createddate,
        districtname,
        statusid,
        verificationstatusname,
        storeverificationid,
        verificationstatusid,
        productQuantity,
        NroRow,
        (SELECT COUNT(*) FROM Store_GetAll) AS TotalRow
    FROM Store_GetAll
    WHERE NroRow >= ((pRow - 1) * pTotalRecord) + 1 AND NroRow <= (pRow * pTotalRecord)
    ORDER BY createddate DESC, NroRow;
END SEC_ADMIN_STORE_GET_ALL; 
PROCEDURE SEC_STORE_ADMIN_INSERT(
puserid IN NUMBER, 
pname IN VARCHAR2,
pdescription IN VARCHAR2,
plogo IN VARCHAR2,
preference IN VARCHAR2,
paddress IN VARCHAR2,
pcellphone IN VARCHAR2,
pbusiness IN VARCHAR2,
pscheduleofoperation IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
pisvisible IN NUMBER,
plinkfacebook IN VARCHAR2,
plinkinstagram IN VARCHAR2,
plinktwitter IN VARCHAR2,
plinktiktok IN VARCHAR2,
pdistrictid IN NUMBER,
pishomedelivery IN NUMBER,
pisstorepickup IN NUMBER,
IDOUT out NUMBER)
IS
   v_exists NUMBER;
BEGIN
   SELECT COUNT(*)
    INTO v_exists
    FROM STORE
    WHERE USERID = puserid
    AND lower(NAME) = lower(pname);
    
     IF v_exists > 0 THEN
    IDOUT := -1;
    ELSE
 INSERT INTO STORE (
USERID,
NAME,
DESCRIPTION,
LOGO,
REFERENCE,
ADDRESS,
CELLPHONE,
BUSINESS,
SCHEDULEOFOPERATION,
STATUSID,
CREATEDBY,
CREATEDDATE,
UPDATEDBY,
UPDATEDDATE,
ISVISIBLE,
LINKFACEBOOK,
LINKINSTAGRAM,
LINKTWITTER,
LINKTIKTOK,
DISTRICTID,
ISHOMEDELIVERY,
ISSTOREPICKUP,
ROUTESEO,
ISSYNCSEO
)
VALUES
(puserid,
pname,
pdescription,
plogo,
preference,
paddress,
pcellphone,
pbusiness,
pscheduleofoperation,
pstatusid,
pcreatedby,
sysdate,
NULL,
NULL,
pisvisible,
plinkfacebook,
plinkinstagram,
plinktwitter,
plinktiktok,
pdistrictid,
pishomedelivery,
pisstorepickup,
LOWER(REGEXP_REPLACE(TRIM(pname), '[^a-zA-Z0-9]+', '-')),
0
)
  returning ID into IDOUT;
COMMIT;
END IF;
END SEC_STORE_ADMIN_INSERT;
PROCEDURE SEC_STORE_ADMIN_EXIST(pname IN VARCHAR2,puserid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
 OPEN cursorStoreOut FOR 
    SELECT COUNT(1) from STORE WHERE lower(NAME) = lower(pname) and userid = puserid;
END SEC_STORE_ADMIN_EXIST;
PROCEDURE SEC_STORE_ADMIN_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
paddress IN VARCHAR2,
plogo IN VARCHAR2,
preference IN VARCHAR2,
pscheduleofoperation IN VARCHAR2,
pcellphone IN VARCHAR2,
plinkfacebook IN VARCHAR2,
plinkinstagram IN VARCHAR2,
plinktiktok IN VARCHAR2,
plinktwitter IN VARCHAR2,
puserid IN NUMBER, 
pupdatedby IN NUMBER,
pisvisible IN NUMBER,
pdistrictid IN NUMBER,
pishomedelivery IN NUMBER,
pisstorepickup IN NUMBER,
pstatusid IN NUMBER, 
rowsOut out NUMBER)
IS
BEGIN
  UPDATE STORE SET NAME=pname, ADDRESS=paddress, LOGO=plogo, REFERENCE=preference, SCHEDULEOFOPERATION=pscheduleofoperation,
  CELLPHONE=pcellphone,LINKFACEBOOK=plinkfacebook,
  LINKINSTAGRAM=plinkinstagram,LINKTIKTOK=plinktiktok,LINKTWITTER=plinktwitter,
  UPDATEDBY = pupdatedby, USERID = puserid, UPDATEDDATE = sysdate,isvisible = pisvisible,
  districtid=pdistrictid, ishomedelivery=pishomedelivery, isstorepickup=pisstorepickup, statusid=pstatusid
  WHERE ID = pid;
rowsOut := SQL%rowcount;
 COMMIT;
END SEC_STORE_ADMIN_UPDATE;
PROCEDURE SEC_STORE_GET_BY_ID_ADMIN(pid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorStoreOut FOR
 SELECT
 sto.id,
 sto.name,
 sto.description,
 sto.logo,
 sto.isvisible,
 sto.address,
 sto.cellPhone,
 sto.logo,
 sto.reference,
 sto.business,
 sto.scheduleofoperation,
 sto.linkfacebook,
 sto.linkinstagram,
 sto.linktwitter,
 sto.linktiktok,
 sto.userId,
     LISTAGG(
          cat.name,
          ', '
       ) WITHIN GROUP ( ORDER BY sto.id ) AS categorys,
(select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryName,
 NVL(sto.districtid,-1) as districtid,
 sto.ishomedelivery,
 sto.isstorepickup,
 NVL(prov.id, -1) as ProvinceId,
 NVL(dep.id,-1) as DepartmentId,
 sto.issyncseo,
 sto.routeseo,
 Fn_Store_GetOrderRatingAverage(pid) as AverageOrderRating,
 Fn_Store_GetTotalSales(pid) as TotalSales,
 Fn_Store_GetTotalOrderRating(pid) as TotalOrderRating
 FROM STORE sto JOIN CategoryStore ct
 on sto.id = ct.idstore JOIN Category cat
 on ct.idcategory = cat.id LEFT JOIN District dis
 on dis.id = sto.districtid LEFT JOIN Province prov
 on dis.provinceid = prov.id LEFT JOIN Department dep
 on prov.departmentid = dep.id
 WHERE sto.ID = pid
 group by sto.id,sto.name,sto.description,sto.logo, sto.isvisible,
 sto.address,
 sto.cellPhone,
 sto.logo,
 sto.reference,
 sto.business,
 sto.scheduleofoperation,
 sto.linkfacebook,
 sto.linkinstagram,
 sto.linktwitter,
 sto.linktiktok,
  sto.districtid,
  sto.ishomedelivery,
 sto.isstorepickup,
 sto.issyncseo,
 sto.routeseo,
 prov.id,
 dep.id;
END SEC_STORE_GET_BY_ID_ADMIN;
PROCEDURE SEC_STORE_UPDATESTATUS_ADMIN(pid IN NUMBER, pstatusid IN NUMBER,puserid IN NUMBER ,rowsOut out NUMBER)
IS
BEGIN
 UPDATE STORE SET STATUSID = pstatusid, UPDATEDBY = puserid, UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount;
 COMMIT;
END SEC_STORE_UPDATESTATUS_ADMIN;
PROCEDURE SEC_STORE_VALIDATE_CATEGORY_UPLOAD_MASIVE(pstoreid IN NUMBER, psubSubCategoryIds IN VARCHAR2 ,presult out SEC_CURSOR_STORE)
IS
BEGIN
OPEN presult FOR
        SELECT 
            ss_ids.COLUMN_VALUE AS subsubcategoryid,
            NVL(c.id,0)  AS categoryid,
            pstoreid AS storeId,
            CASE 
                WHEN cs.idcategory IS NOT NULL THEN 1
                ELSE 0
            END AS exist
        FROM 
            (SELECT * FROM TABLE(split_string(psubSubCategoryIds))) ss_ids
        LEFT JOIN 
            subsubcategory ss ON ss.id = ss_ids.COLUMN_VALUE
        LEFT JOIN 
            subcategory sc ON ss.subcategoryid = sc.id
        LEFT JOIN 
            category c ON sc.categoryid = c.id
        LEFT JOIN 
            CategoryStore cs ON c.id = cs.idcategory AND cs.idstore = pstoreid;
END SEC_STORE_VALIDATE_CATEGORY_UPLOAD_MASIVE;
PROCEDURE SEC_ADMIN_STORE_GET_BYID(pstoreid IN NUMBER, cursorOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorOut FOR
 SELECT
 sto.id,
 sto.name,
 sto.description,
 sto.logo,
 sto.isvisible,
 sto.address,
 sto.cellPhone,
 sto.logo,
 sto.reference,
 sto.business,
 sto.scheduleofoperation,
 sto.linkfacebook,
 sto.linkinstagram,
 sto.linktwitter,
 sto.linktiktok,
     LISTAGG(
          cat.name,
          ', '
       ) WITHIN GROUP ( ORDER BY sto.id ) AS categorys,
(select CatP.name from Category CatP Inner join CategoryStore CatStop on CatP.Id=CatStop.Idcategory and CatStop.Idstore=Sto.Id and rownum=1) as CategoryName,
 NVL(sto.districtid,-1) as districtid,
 sto.ishomedelivery,
 sto.isstorepickup,
 NVL(prov.id, -1) as ProvinceId,
 NVL(dep.id,-1) as DepartmentId,
 sto.issyncseo,
 sto.routeseo,
 Fn_Store_GetOrderRatingAverage(pstoreid) as AverageOrderRating,
 Fn_Store_GetTotalSales(pstoreid) as TotalSales,
 Fn_Store_GetTotalOrderRating(pstoreid) as TotalOrderRating,
 sto.userid,
 sto.statusid
 FROM STORE sto JOIN CategoryStore ct
 on sto.id = ct.idstore JOIN Category cat
 on ct.idcategory = cat.id LEFT JOIN District dis
 on dis.id = sto.districtid LEFT JOIN Province prov
 on dis.provinceid = prov.id LEFT JOIN Department dep
 on prov.departmentid = dep.id
 WHERE sto.ID = pstoreid 
 group by sto.id,sto.name,sto.description,sto.logo, sto.isvisible,
 sto.address,
 sto.cellPhone, 
 sto.logo,
 sto.reference,
 sto.business,
 sto.scheduleofoperation,
 sto.linkfacebook,
 sto.linkinstagram,
 sto.linktwitter,
 sto.linktiktok,
  sto.districtid,
  sto.ishomedelivery,
 sto.isstorepickup,
 sto.issyncseo,
 sto.routeseo,
 prov.id,
 dep.id,
 sto.userid,
 sto.statusid; 
END SEC_ADMIN_STORE_GET_BYID; 
PROCEDURE SEC_STOREVERIFICATION_UPDATE_ADMIN(
pid IN NUMBER,
pruc IN VARCHAR2,
pcommercialname IN VARCHAR2,
pcompanyname IN VARCHAR2,
prucfile IN VARCHAR2,
ptypeofcompanyid IN NUMBER,
pfiscaladdress IN VARCHAR2,
pdistrictid IN NUMBER,
pnameoflegalrepresentative IN VARCHAR2,
pdocumenttypeid IN NUMBER,
pdocumentnumber IN VARCHAR2,
pdocumentfile IN VARCHAR2,
pemail IN VARCHAR2,
pcellphone IN VARCHAR2,
pverificationstatusid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE StoreVerification SET RUC=pruc, commercialname=pcommercialname, companyname=pcompanyname, 
  rucfile=prucfile, typeofcompanyid=ptypeofcompanyid,
  fiscaladdress=pfiscaladdress,districtid=pdistrictid,
  nameoflegalrepresentative=pnameoflegalrepresentative,documenttypeid=pdocumenttypeid,documentnumber=pdocumentnumber, 
  documentfile=pdocumentfile,email=pemail,cellphone=pcellphone,verificationstatusid=pverificationstatusid,
  updatedby=pupdatedby,UPDATEDDATE = sysdate,statusid=pstatusid
  WHERE ID = pid;
rowsOut := SQL%rowcount;
 COMMIT;
END SEC_STOREVERIFICATION_UPDATE_ADMIN;
PROCEDURE SEC_STOREVERIFICATION_GET_BYID_ADMIN(pid IN NUMBER,cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
  OPEN cursorStoreOut FOR
  select stover.*,sto.name as storename,
dis.name as districtname,
prov.id as provinceid,
prov.name as provincename,
dep.id as departmentid,
dep.name as departmentname 
from StoreVerification stover
  inner join Store sto on sto.id=stover.storeid and stover.statusid=1 and stover.id=pid
  inner join District dis on stover.districtid=dis.id
  inner join Province prov on dis.provinceid=prov.id
  inner join Department dep on prov.departmentid=dep.id;
END SEC_STOREVERIFICATION_GET_BYID_ADMIN;
PROCEDURE SEC_STOREVERIFICATION_INSERT(
pstoreid in NUMBER,
pruc IN VARCHAR2,
pcommercialname IN VARCHAR2,
pcompanyname IN VARCHAR2,
prucfile IN VARCHAR2,
ptypeofcompanyid IN NUMBER,
pfiscaladdress IN VARCHAR2,
pdistrictid IN NUMBER,
pnameoflegalrepresentative IN VARCHAR2,
pdocumenttypeid IN NUMBER,
pdocumentnumber IN VARCHAR2,
pdocumentfile IN VARCHAR2,
pemail IN VARCHAR2,
pcellphone IN VARCHAR2,
pverificationstatusid IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS
   v_exists NUMBER;
BEGIN
   SELECT COUNT(*)
    INTO v_exists
    FROM StoreVerification
    WHERE lower(RUC) = lower(pruc) and statusid=1;
     IF v_exists > 0 THEN
    IDOUT := -1;
    ELSE
 INSERT INTO StoreVerification (
STOREID,
RUC,
COMMERCIALNAME,
COMPANYNAME,
RUCFILE,
TYPEOFCOMPANYID,
FISCALADDRESS,
DISTRICTID,
NAMEOFLEGALREPRESENTATIVE,
DOCUMENTTYPEID,
DOCUMENTNUMBER,
DOCUMENTFILE,
EMAIL,
CELLPHONE,
VERIFICATIONSTATUSID,
STATUSID,
CREATEDBY,
CREATEDDATE
)
VALUES
(pstoreid,
pruc,
pcommercialname,
pcompanyname,
prucfile,
ptypeofcompanyid,
pfiscaladdress,
pdistrictid,
pnameoflegalrepresentative,
pdocumenttypeid,
pdocumentnumber,
pdocumentfile,
pemail,
pcellphone,
pverificationstatusid,
pstatusid,
pcreatedby,
sysdate
)
  returning ID into IDOUT;
COMMIT;
END IF;
END SEC_STOREVERIFICATION_INSERT;
PROCEDURE SEC_STOREVERIFICATIONRUC_EXIST(pruc IN VARCHAR2,cursorStoreOut OUT SEC_CURSOR_STORE)
IS
BEGIN
 OPEN cursorStoreOut FOR
    SELECT COUNT(1) from storeverification WHERE lower(ruc) = lower(pruc) and STATUSID = 1;
END SEC_STOREVERIFICATIONRUC_EXIST;
PROCEDURE SEC_STORE_GET_PAGINATED_BY_USERID(
    puserid IN NUMBER,
    prow IN NUMBER,             
    ptotalrecord IN NUMBER,     
    cursorStoreOut OUT SEC_CURSOR_STORE
)
IS
BEGIN
  OPEN cursorStoreOut FOR
  WITH Store_Paginated AS (
    SELECT 
      s.id,
      s.name,
      s.description,
      s.logo,
      s.currentstore,
      s.isvisible, 
      s.userid,
      LISTAGG(cat.name, ', ') WITHIN GROUP (ORDER BY s.id) AS categorys,
      s.issyncseo,
      s.routeseo,
      COALESCE(sv.verificationstatusid, 1) AS verificationstatusid,
      ROW_NUMBER() OVER (ORDER BY s.id) AS NroRow  -- Numeración de filas
    FROM 
      STORE s 
    JOIN 
      CategoryStore ct ON s.id = ct.idstore  
    JOIN 
      Category cat ON ct.idcategory = cat.id
    LEFT JOIN 
      storeverification sv ON s.id = sv.storeid
    WHERE 
      s.USERID = puserid 
      AND s.STATUSID = 1
    GROUP BY 
      s.id, s.name, s.description, s.logo, s.currentstore, s.isvisible, 
      s.userid, s.issyncseo, s.routeseo, COALESCE(sv.verificationstatusid, 1)
  )
  SELECT 
    id, 
    name, 
    description, 
    logo, 
    currentstore, 
    isvisible, 
    userid, 
    categorys, 
    issyncseo, 
    routeseo, 
    verificationstatusid, 
    NroRow, 
    (SELECT COUNT(*) FROM Store_Paginated) AS TotalRow  -- Total de filas
  FROM 
    Store_Paginated 
  WHERE 
    NroRow >= ((pRow - 1) * pTotalRecord) + 1 
    AND NroRow <= (pRow * pTotalRecord)
  ORDER BY 
    NroRow;
END SEC_STORE_GET_PAGINATED_BY_USERID;
PROCEDURE SEC_STOREVERIFICATION_FILTER_DYNAMIC_PAGINATED(
    puserid INT,
    pcategories VARCHAR2,
    porderby VARCHAR2,
    porderdirection VARCHAR2,
    pdistrictid INT,
    psearch VARCHAR2,
    prow INT,
    ptotalrecord INT,
    cursorOut OUT SEC_CURSOR_STORE)
AS
   v_sql VARCHAR2(4000);
BEGIN
  v_sql := 'WITH FilteredStores AS (
                SELECT 
                    sto.id,
                    sto.name,
                    sto.description,
                    sto.logo,
                    sto.linkfacebook,
                    sto.linkinstagram,
                    sto.linktwitter,
                    sto.linktiktok,
                    sto.routeseo,
                    sto.issyncseo,
                    sto.IsVisible,
                    sto.createddate,
                    Fn_Store_GetOrderRatingAverage(sto.Id) as AverageOrderRating,
                    Fn_Store_GetTotalOrderRating(sto.Id) as TotalOrderRating,
                    case when (select id from myfavorite where statusid=1 and userid=' || puserid || ' and storeId=sto.Id)>0 then 1 else 0 end as IsFavorite,
                    LISTAGG('''' || CatP.name || '''', '', '') WITHIN GROUP (ORDER BY CatP.name) AS CategoryNames,
                    LISTAGG('''' || CatP.id || '''', '', '') WITHIN GROUP (ORDER BY CatP.id) AS CategoryIds,
                    NVL(
    (SELECT CASE 
                WHEN stover.verificationstatusid = 3 THEN 1 
                ELSE 0 
            END 
     FROM StoreVerification stover
     WHERE stover.StoreID = sto.id),
    0) AS IsVerified
                FROM store sto
                LEFT JOIN CategoryStore CatStop ON sto.Id = CatStop.Idstore
                LEFT JOIN Category CatP ON CatStop.Idcategory = CatP.Id
                LEFT JOIN StoreVerification stover ON sto.id = stover.StoreID
                WHERE 1=1 and sto.Statusid=1 and sto.isvisible = 1 AND stover.verificationstatusid=3';
                
    IF pcategories IS NOT NULL AND LENGTH(pcategories) > 0 THEN
    v_sql := v_sql || ' AND EXISTS (
        SELECT 1
        FROM categorystore sc
        WHERE sc.idstore = sto.id
        AND sc.idcategory IN (' || pcategories || '))';
    END IF;
                
    IF psearch IS NOT NULL  THEN
        v_sql := v_sql || ' AND lower(sto.name) LIKE ''%' || lower(psearch) || '%'' '; 
    END IF;

    IF pdistrictid > 0 THEN
        v_sql := v_sql || ' AND sto.districtId = ' || pdistrictid;
    END IF;

    v_sql := v_sql || '
               GROUP BY sto.id, sto.name, sto.description, sto.logo, sto.linkfacebook, sto.linkinstagram, sto.linktwitter, sto.linktiktok, sto.routeseo, sto.issyncseo, sto.IsVisible, sto.createddate
              ),
              TotalRow AS (
                SELECT COUNT(*) AS TotalRow FROM FilteredStores
              ),
              PaginatedStores AS (
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
        IF porderdirection IS NOT NULL THEN
            v_sql := v_sql || ' ' || porderdirection;
        ELSE
            v_sql := v_sql || ' ASC';
        END IF;
    ELSE
        v_sql := v_sql || 'fp.id ASC';
    END IF;

    v_sql := v_sql || ') AS NroRow
              FROM FilteredStores fp, TotalRow tc
              )
              SELECT * FROM PaginatedStores
              WHERE NroRow BETWEEN ((' || prow || ' - 1) * ' || ptotalRecord || ' + 1) 
              AND (' || prow || ' * ' || ptotalRecord || ')';
              
     DBMS_OUTPUT.PUT_LINE(v_sql);


    OPEN cursorOut FOR v_sql;
END SEC_STOREVERIFICATION_FILTER_DYNAMIC_PAGINATED;

END PKG_STORE;

/