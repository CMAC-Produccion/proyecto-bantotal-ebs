create or replace PACKAGE USRECOSISTEMAS.PKG_CATEGORY IS

type CAT_CURSOR_CATEGORY IS REF CURSOR;

PROCEDURE CAT_CATEGORY_GETALL(
  cursorCategories OUT CAT_CURSOR_CATEGORY,
  cursorSubCategories OUT CAT_CURSOR_CATEGORY,
  cursorSubSubCategories OUT CAT_CURSOR_CATEGORY
  );
PROCEDURE CAT_CATEGORY_GETBYSTORE(pstoreid IN number,cursorOut OUT CAT_CURSOR_CATEGORY);
PROCEDURE CAT_CATEGORY_GETCONTAINSPRODUCT(cursorOut OUT CAT_CURSOR_CATEGORY);
PROCEDURE CAT_CATEGORY_UPDATEROUTESEO(rowsOut out NUMBER);
PROCEDURE CAT_CATEGORY_GETBYROUTESEO(prouteseo IN VARCHAR2,cursorOut OUT CAT_CURSOR_CATEGORY);
PROCEDURE CAT_CATEGORY_GETALLFORSITEMAP(cursorOut OUT CAT_CURSOR_CATEGORY);
PROCEDURE CAT_CAT_PROD_STO_UPDATEISSYNCSEO (
    pLstCategories IN VARCHAR2,
    pLstStores IN VARCHAR2,
    pLstProducts IN VARCHAR2,
    rowsOut OUT NUMBER
);
PROCEDURE CAT_CATEGORYALL_GETBYSTORE(pstoreid IN number,cursorOut OUT CAT_CURSOR_CATEGORY);
PROCEDURE CAT_CATEGORY_INSERT(
pname IN VARCHAR2,
pdescription IN VARCHAR2,
picon IN VARCHAR2,
prouteseo IN VARCHAR2,
pissyncseo IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);
PROCEDURE CAT_SUBCATEGORY_INSERT(
pcategoryid in NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
pisdefault IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);
PROCEDURE CAT_SUBSUBCATEGORY_INSERT(
psubcategoryid in NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
pisdefault IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);
PROCEDURE CAT_CATEGORY_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
picon IN VARCHAR2,
prouteseo IN VARCHAR2,
pissyncseo IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE CAT_SUBCATEGORY_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
pisdefault IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE CAT_SUBSUBCATEGORY_UPDATE(
pid in NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
pisdefault IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE CAT_CATEGORY_UPDATESTATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE CAT_SUBCATEGORY_UPDATESTATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE CAT_SUBSUBCATEGORY_UPDATESTATUS(
pid in NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE CAT_CATEGORY_ALL_SORT_ORDER(p_categories IN XMLTYPE,rowsOut OUT NUMBER);
END PKG_CATEGORY;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_CATEGORY IS
PROCEDURE CAT_CATEGORY_GETALL(
  cursorCategories OUT CAT_CURSOR_CATEGORY,
  cursorSubCategories OUT CAT_CURSOR_CATEGORY,
  cursorSubSubCategories OUT CAT_CURSOR_CATEGORY
  )
IS
BEGIN
  OPEN cursorCategories FOR
  SELECT c.*, 
         (SELECT COUNT(p.id)
          FROM product p
          JOIN subsubcategory ssc ON p.subsubcategoryid = ssc.id
          JOIN subcategory sc ON ssc.subcategoryid = sc.id
          WHERE sc.categoryid = c.id and p.statusid!=2) AS quantityproduct
  FROM category c
  WHERE c.statusid = 1
  ORDER BY c.sort ASC;
  
   OPEN cursorSubCategories FOR
  SELECT sc.*, 
         (SELECT COUNT(p.id)
          FROM product p
          JOIN subsubcategory ssc ON p.subsubcategoryid = ssc.id
          WHERE ssc.subcategoryid = sc.id and p.statusid!=2) AS quantityproduct
  FROM subcategory sc
  WHERE sc.statusid = 1
  ORDER BY sc.sort ASC;
    
    OPEN cursorSubSubCategories FOR
  SELECT ssc.*, 
         (SELECT COUNT(p.id)
          FROM product p
          WHERE p.subsubcategoryid = ssc.id and p.statusid!=2) AS quantityproduct
  FROM subsubcategory ssc
  WHERE ssc.statusid = 1
  ORDER BY ssc.sort ASC;
  
END CAT_CATEGORY_GETALL;
PROCEDURE CAT_CATEGORY_GETBYSTORE(pstoreid IN number, cursorOut OUT CAT_CURSOR_CATEGORY)
IS
BEGIN
  OPEN cursorOut FOR

SELECT distinct CA.ID, CA.NAME,CA.ROUTESEO,CA.ISSYNCSEO FROM CATEGORY CA INNER JOIN CATEGORYSTORE CS ON CA.ID = CS.IDCATEGORY
                         INNER JOIN STORE ST ON CS.IDSTORE = ST.ID
WHERE ST.ID = pstoreid AND ST.STATUSID = 1;

END CAT_CATEGORY_GETBYSTORE;
PROCEDURE CAT_CATEGORY_GETCONTAINSPRODUCT(cursorOut OUT CAT_CURSOR_CATEGORY)
IS
BEGIN
    OPEN cursorOut FOR
        SELECT DISTINCT cat.id, cat.name, cat.icon, CAT.ROUTESEO, CAT.ISSYNCSEO, 
            (SELECT COUNT(*) 
             FROM product prod 
             INNER JOIN subsubcategory ssub ON prod.subsubcategoryid = ssub.id
             INNER JOIN subcategory sub ON ssub.subcategoryid = sub.id
             WHERE sub.categoryid = cat.id AND prod.statusid = 1
            ) AS TotalProduct 
        FROM category cat 
        INNER JOIN subcategory subcat ON cat.id = subcat.categoryid
        INNER JOIN subsubcategory subsubcat ON subcat.id = subsubcat.subcategoryid
        INNER JOIN categorystore catsto ON cat.id = catsto.idcategory
        INNER JOIN store sto ON sto.id = catsto.idstore AND catsto.statusid = 1
        WHERE cat.statusid = 1 
        AND cat.id IN (SELECT sub.categoryid 
                       FROM product prod 
                       INNER JOIN subsubcategory ssub ON prod.subsubcategoryid = ssub.id
                       INNER JOIN subcategory sub ON ssub.subcategoryid = sub.id
                       WHERE prod.statusid = 1)
        ORDER BY TotalProduct DESC;
END CAT_CATEGORY_GETCONTAINSPRODUCT;
PROCEDURE CAT_CATEGORY_UPDATEROUTESEO(rowsOut out NUMBER)
IS
BEGIN
    rowsOut := 0;
    FOR c1_rec IN (SELECT id, name
                   FROM category
                   WHERE IsSyncSeo = 0
                   FOR UPDATE OF routeSeo) LOOP
        UPDATE category
        SET routeSeo = LOWER(REGEXP_REPLACE(REMOVE_ACCENTS(TRIM(name)), '[^a-zA-Z0-9]+', '-'))
        WHERE id = c1_rec.id;
        rowsOut := rowsOut + 1;
    END LOOP;
    COMMIT;
END CAT_CATEGORY_UPDATEROUTESEO;
PROCEDURE CAT_CATEGORY_GETBYROUTESEO(prouteseo IN VARCHAR2,cursorOut OUT CAT_CURSOR_CATEGORY)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT * FROM CATEGORY WHERE STATUSID = 1 and lower(ROUTESEO)=lower(prouteseo)
  ORDER BY ID ASC;
END CAT_CATEGORY_GETBYROUTESEO;
PROCEDURE CAT_CATEGORY_GETALLFORSITEMAP(cursorOut OUT CAT_CURSOR_CATEGORY)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT * FROM CATEGORY WHERE STATUSID = 1 and issyncseo=0
  ORDER BY ID ASC;
END CAT_CATEGORY_GETALLFORSITEMAP;

PROCEDURE CAT_CAT_PROD_STO_UPDATEISSYNCSEO (
    pLstCategories IN VARCHAR2,
    pLstStores IN VARCHAR2,
    pLstProducts IN VARCHAR2,
    rowsOut OUT NUMBER
) 
IS
    l_count NUMBER := 0;
BEGIN
    -- Actualizar categor?as
    FOR i IN (SELECT * FROM TABLE(split_string(pLstCategories)))
    LOOP
        UPDATE category SET issyncseo=1, updateddate = SYSDATE WHERE id = i.column_value;
        l_count := l_count + SQL%ROWCOUNT;
    END LOOP;

    -- Actualizar tiendas
    FOR i IN (SELECT * FROM TABLE(split_string(pLstStores)))
    LOOP
        UPDATE store SET issyncseo=1, updateddate = SYSDATE WHERE id = i.column_value;
        l_count := l_count + SQL%ROWCOUNT;
    END LOOP;

    -- Actualizar productos
    FOR i IN (SELECT * FROM TABLE(split_string(pLstProducts)))
    LOOP
        UPDATE product set issyncseo =1, updateddate = SYSDATE WHERE id = i.column_value;
        l_count := l_count + SQL%ROWCOUNT;
    END LOOP;

    rowsOut := l_count;
    COMMIT;
END CAT_CAT_PROD_STO_UPDATEISSYNCSEO;
PROCEDURE CAT_CATEGORYALL_GETBYSTORE(pstoreid IN number, cursorOut OUT CAT_CURSOR_CATEGORY)
IS
BEGIN
  OPEN cursorOut FOR

SELECT distinct CA.ID, SSC.ID as SUBSUBCATEGORYID, CA.NAME as CATEGORYNAME, SC.NAME AS SUBCATEGORYNAME, SSC.NAME AS SUBSUBCATEGORYNAME 
                         FROM CATEGORY CA INNER JOIN CATEGORYSTORE CS ON CA.ID = CS.IDCATEGORY
                         INNER JOIN STORE ST ON CS.IDSTORE = ST.ID
                         INNER JOIN SUBCATEGORY SC ON CA.ID = SC.CATEGORYID
                         INNER JOIN SUBSUBCATEGORY SSC ON SSC.SUBCATEGORYID = SC.ID
WHERE ST.ID = pstoreid AND ST.STATUSID = 1
ORDER BY CA.ID ASC;

END CAT_CATEGORYALL_GETBYSTORE;
PROCEDURE CAT_CATEGORY_INSERT(
pname IN VARCHAR2,
pdescription IN VARCHAR2,
picon IN VARCHAR2,
prouteseo IN VARCHAR2,
pissyncseo IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS
   v_id NUMBER;
   v_sort NUMBER;
BEGIN
    SELECT MAX(id) INTO v_id
    FROM category
    WHERE id != 99;
    
    select MAX(sort) + 1 INTO v_sort
    from category where id=v_id;
    
    v_id:=v_id+1;
    
    insert into category(id,name,description,icon,routeseo,issyncseo,sort,statusid,createdby,createddate)
    values(v_id,pname,pdescription,picon,prouteseo,pissyncseo,v_sort,pstatusid,pcreatedby,sysdate);
    
     IDOUT:=v_id;
     COMMIT;
END CAT_CATEGORY_INSERT;
PROCEDURE CAT_SUBCATEGORY_INSERT(
pcategoryid in NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
pisdefault IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS
v_sort NUMBER;
BEGIN
  SELECT COALESCE(MAX(sort) + 1, 1) INTO v_sort
  from subcategory where categoryid=pcategoryid;
    
  insert into subcategory(categoryid,name,description,isdefault,sort,statusid,createdby,createddate)
  values(pcategoryid,pname,pdescription,pisdefault,v_sort,pstatusid,pcreatedby,sysdate)
  returning ID into IDOUT;
COMMIT;
END CAT_SUBCATEGORY_INSERT;
PROCEDURE CAT_SUBSUBCATEGORY_INSERT(
psubcategoryid in NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
pisdefault IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS
v_sort NUMBER;
BEGIN
  SELECT COALESCE(MAX(sort) + 1, 1) INTO v_sort
  from subsubcategory where subcategoryid=psubcategoryid;
  
  insert into subsubcategory(subcategoryid,name,description,isdefault,sort,statusid,createdby,createddate)
  values(psubcategoryid,pname,pdescription,pisdefault,v_sort,pstatusid,pcreatedby,sysdate)
  returning ID into IDOUT;
  COMMIT;
END CAT_SUBSUBCATEGORY_INSERT;
PROCEDURE CAT_CATEGORY_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
picon IN VARCHAR2,
prouteseo IN VARCHAR2,
pissyncseo IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE category SET name=pname,description=pdescription,icon=picon,routeseo=prouteseo,issyncseo=pissyncseo,statusid=pstatusid,updatedby=pupdatedby WHERE id = pid;
  rowsOut := SQL%rowcount;
  COMMIT;
END CAT_CATEGORY_UPDATE;
PROCEDURE CAT_SUBCATEGORY_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
pisdefault IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE subcategory SET name=pname,description=pdescription,isdefault=pisdefault,statusid=pstatusid,updatedby=pupdatedby WHERE id = pid;
  rowsOut := SQL%rowcount;
  COMMIT;
END CAT_SUBCATEGORY_UPDATE;
PROCEDURE CAT_SUBSUBCATEGORY_UPDATE(
pid in NUMBER,
pname IN VARCHAR2,
pdescription IN VARCHAR2,
pisdefault IN NUMBER,
psort IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE subsubcategory SET name=pname,description=pdescription,isdefault=pisdefault,statusid=pstatusid,updatedby=pupdatedby WHERE id = pid;
  rowsOut := SQL%rowcount;
  COMMIT;
END CAT_SUBSUBCATEGORY_UPDATE;
PROCEDURE CAT_CATEGORY_UPDATESTATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE category SET statusid=pstatusid,updatedby=pupdatedby WHERE id = pid;
  rowsOut := SQL%rowcount;
  COMMIT;
END CAT_CATEGORY_UPDATESTATUS;
PROCEDURE CAT_SUBCATEGORY_UPDATESTATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE subsubcategory SET statusid=pstatusid,updatedby=pupdatedby WHERE id = pid;
  rowsOut := SQL%rowcount;
  COMMIT;
END CAT_SUBCATEGORY_UPDATESTATUS;
PROCEDURE CAT_SUBSUBCATEGORY_UPDATESTATUS(
pid in NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE subsubcategory SET statusid=pstatusid,updatedby=pupdatedby WHERE id = pid;
  rowsOut := SQL%rowcount;
  COMMIT;
END CAT_SUBSUBCATEGORY_UPDATESTATUS;
PROCEDURE CAT_CATEGORY_ALL_SORT_ORDER(p_categories IN XMLTYPE, rowsOut OUT NUMBER) 
IS
    rows_updated NUMBER := 0;

    -- Procesar las categor?as de primer nivel
    CURSOR c_categories IS
        SELECT x.id, x.sort, x.subCategories 
        FROM XMLTABLE('/categories/category' PASSING p_categories
            COLUMNS 
                id NUMBER PATH 'id',
                sort NUMBER PATH 'sort',
                subCategories XMLTYPE PATH 'subCategories'
        ) x;

    -- Procesar las subcategor?as de segundo nivel
    CURSOR c_subCategories(subCategories XMLTYPE) IS
        SELECT x.id, x.sort, x.subSubCategories 
        FROM XMLTABLE('/subCategories/subCategory' PASSING subCategories
            COLUMNS 
                id NUMBER PATH 'id',
                sort NUMBER PATH 'sort',
                subSubCategories XMLTYPE PATH 'subSubCategories'
        ) x;

    -- Procesar las subsubcategor?as de tercer nivel
    CURSOR c_subSubCategories(subSubCategories XMLTYPE) IS
        SELECT x.id, x.sort 
        FROM XMLTABLE('/subSubCategories/subSubCategory' PASSING subSubCategories
            COLUMNS 
                id NUMBER PATH 'id',
                sort NUMBER PATH 'sort'
        ) x;

BEGIN
    FOR cat IN c_categories LOOP
        -- Actualizar categor?as de primer nivel
        IF cat.id < 99 THEN
        UPDATE category SET sort = cat.sort WHERE id = cat.id;
        rows_updated := rows_updated + SQL%ROWCOUNT;
    END IF;

        -- Procesar subcategor?as de segundo nivel
        FOR subCat IN c_subCategories(cat.subCategories) LOOP
            -- Actualizar subcategor?as de segundo nivel
            UPDATE subcategory SET sort = subCat.sort WHERE id = subCat.id;
            rows_updated := rows_updated + SQL%ROWCOUNT;

            -- Procesar subsubcategor?as de tercer nivel
            FOR subSubCat IN c_subSubCategories(subCat.subSubCategories) LOOP
                -- Actualizar subsubcategor?as de tercer nivel
                UPDATE subsubcategory SET sort = subSubCat.sort WHERE id = subSubCat.id;
                rows_updated := rows_updated + SQL%ROWCOUNT;
            END LOOP;
        END LOOP;
    END LOOP;
    rowsOut := rows_updated;
    commit;
END CAT_CATEGORY_ALL_SORT_ORDER;
END PKG_CATEGORY;


/