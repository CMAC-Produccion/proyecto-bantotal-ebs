create or replace package USRECOSISTEMAS.PCK_ORDERRATING is

  -- Author  : JHONATAN
  -- Created : 04/03/2024 08:17:43
  -- Purpose :
type RAT_CURSOR_ORDERRATING IS REF CURSOR;

PROCEDURE RAT_ORDERRATING_GETBYSHOPPERANDSEARCH_PAGINATED(pshopperid IN number,psearch IN varchar2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT RAT_CURSOR_ORDERRATING);

PROCEDURE RAT_ORDERRATING_GETBYSHOPPERVENDORANDSEARCH_PAGINATED(pshopperid IN number,pvendorid IN number,psearch IN varchar2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT RAT_CURSOR_ORDERRATING);

PROCEDURE RAT_ORDERRATING_GETBYID(pid IN number,cursorOut OUT RAT_CURSOR_ORDERRATING);

PROCEDURE RAT_ORDERRATING_GETBYORDERDETAILID(porderdetailid IN number,cursorOut OUT RAT_CURSOR_ORDERRATING);

PROCEDURE RAT_ORDERRATING_GETBYPRODUCT_PAGINATED(pproductid IN number, porderType IN NUMBER DEFAULT 1,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT RAT_CURSOR_ORDERRATING,cursorRatingOut OUT RAT_CURSOR_ORDERRATING,averageRatingOut OUT NUMBER);

PROCEDURE RAT_ORDERRATING_INSERT(
pshopperid IN NUMBER,
porderdetailid IN NUMBER,
prating IN NUMBER,
popinion IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);


PROCEDURE RAT_ORDERRATING_UPDATE(
pid IN NUMBER,
prating IN NUMBER,
popinion IN VARCHAR2,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

PROCEDURE RAT_ORDERRATING_UPDATESTATUS(
pid IN NUMBER,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);

PROCEDURE RAT_ORDERRATING_INSERT_XML(
    pshopperid      IN NUMBER,     -- ID del comprador
    porderdetailid  IN NUMBER,     -- ID del detalle de la orden
    prating         IN NUMBER,     -- Calificación general de la orden
    popinion        IN VARCHAR2,   -- Opinión general de la orden
    pstatusid       IN NUMBER,     -- ID del estado
    pcreatedby      IN NUMBER,     -- ID del usuario que crea la entrada
    pOrderRatingXML IN XMLTYPE,    -- XML con los detalles de calificación para los productos
    porderid      IN NUMBER,     -- ID de la orden
    IDOUT           OUT NUMBER     -- ID de la tabla OrderRating
);

PROCEDURE RAT_ORDERRATING_UPDATE_XML(
    --pshopperid      IN NUMBER,
    --porderdetailid  IN NUMBER,
    prating         IN NUMBER,
    popinion        IN VARCHAR2,  -- Comentario general para la orden
    pstatusid       IN NUMBER,
    pupdatedby      IN NUMBER,
    pOrderRatingXML IN XMLTYPE,  -- XML para los detalles de productos
    porderid        IN NUMBER,
    pid           IN NUMBER, -- ID del registro que se va a actualizar
    rowsOut out NUMBER
);
PROCEDURE RAT_ORDERRATINGDETAIL_GETBYID(
    pOrderRatingID IN NUMBER,
    cursorOut OUT RAT_CURSOR_ORDERRATING
);
end PCK_ORDERRATING;
/
create or replace package body USRECOSISTEMAS.PCK_ORDERRATING is

PROCEDURE RAT_ORDERRATING_GETBYSHOPPERANDSEARCH_PAGINATED(pshopperid IN number,psearch IN varchar2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT RAT_CURSOR_ORDERRATING)
IS
BEGIN
  OPEN cursorOut FOR
  select * from
  (select distinct ort.id, ort.shopperid, ort.vendorid, ort.orderdetailid,ort.statusid,
  sto.name as StoreName,pro.name as ProductName,oh.orderdate, ort.rating,ort.opinion,
  (select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodet.Id and rownum=1) as ImageUrl,
  row_number() over (order by ort.createddate desc) as NroRow,
  (select count(*) from OrderRating ort1 where ort1.statusid=1 and ort1.shopperid=pshopperid and ort1.orderdetailid=od.id and od.productid=pro.id and ((lower(pro.name) like '%'||lower(psearch)||'%'))) as TotalRow
  from OrderRating ort inner join OrderDetail od on ort.orderdetailid=od.id
  inner join OrderHeader oh on od.orderid=oh.id
  inner join Product pro on od.productid=pro.id
  inner join productdetail prodet on prodet.productid=pro.id
  inner join StoreProduct stopro on stopro.productid=pro.id
  inner join Store sto on stopro.storeid=sto.id
  where ort.statusid=1 and ort.shopperid=pshopperid and (
(lower(pro.name) like '%'||lower(psearch)||'%'))) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord)
  order by nrorow;
END RAT_ORDERRATING_GETBYSHOPPERANDSEARCH_PAGINATED;

PROCEDURE RAT_ORDERRATING_GETBYSHOPPERVENDORANDSEARCH_PAGINATED(pshopperid IN number,pvendorid IN number,psearch IN varchar2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT RAT_CURSOR_ORDERRATING)
IS
BEGIN
  OPEN cursorOut FOR
    select * from (
      select distinct ort.id, ort.shopperid, ort.vendorid,
       COALESCE(od.id, ord.orderdetailid) AS orderdetailid,
      ort.statusid,
      sto.name as StoreName, pro.name as ProductName, oh.orderdate, ort.rating, ort.opinion,
      (select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodet.Id and rownum=1) as ImageUrl,
      NVL(
        (SELECT CASE 
                 WHEN stover.verificationstatusid = 3 THEN 1 
                 ELSE 0 
             END 
         FROM StoreVerification stover 
         WHERE stover.StoreID = sto.id AND stover.statusid = 1),
        0) AS IsVerified,
      oh.ordernumber,
      oh.total,
     pro.id as ProductId,
     pro.sku AS Sku,
      row_number() over (order by ort.createddate desc) as NroRow,
      (select count(*) from OrderRating ort1 inner join OrderDetail od1 on ort1.orderdetailid=od1.id inner join Product pro1 on od1.productid=pro1.id
       where ort1.statusid=1 and ort1.shopperid=pshopperid and (
         (pshopperid > 0 and ort1.shopperid=pshopperid)
       ) and (
         (lower(pro1.name) like '%'||lower(psearch)||'%')
       )
      ) as TotalRow
      from OrderRating ort
      LEFT JOIN OrderRatingDetail ord ON ord.OrderRatingID = ort.id 
      LEFT JOIN orderdetail od ON COALESCE(ort.orderdetailid, ord.orderdetailid) = od.id
      --inner join OrderDetail od on ort.orderdetailid=od.id
      inner join OrderHeader oh on od.orderid=oh.id
      inner join Product pro on od.productid=pro.id
      inner join productdetail prodet on prodet.productid=pro.id
      inner join StoreProduct stopro on stopro.productid=pro.id
      inner join Store sto on stopro.storeid=sto.id
      where ort.statusid=1 and (
        (pshopperid > 0 and ort.shopperid=pshopperid)
      ) and (
        (lower(pro.name) like '%'||lower(psearch)||'%') OR (LOWER(sto.name) LIKE '%' || LOWER(psearch) || '%')
        OR (LOWER(oh.ordernumber) LIKE '%' || LOWER(psearch) || '%')
      )
    )
    where NroRow >= ((pRow-1)*pTotalRecord)+1 and NroRow <= (pRow*pTotalRecord)
    order by nrorow;
END RAT_ORDERRATING_GETBYSHOPPERVENDORANDSEARCH_PAGINATED;

PROCEDURE RAT_ORDERRATING_GETBYPRODUCT_PAGINATED(
    pproductid IN NUMBER,
    porderType IN NUMBER DEFAULT 1,
    prow IN NUMBER,
    ptotalRecord IN NUMBER,
    cursorOut OUT RAT_CURSOR_ORDERRATING,
    cursorRatingOut OUT RAT_CURSOR_ORDERRATING,
    averageRatingOut OUT NUMBER)
IS
  v_sql VARCHAR2(4000);
  totalRatings NUMBER := 0;
  totalVotes NUMBER := 0;
BEGIN
  v_sql := 'SELECT * FROM ( ' ||
           'SELECT DISTINCT ort.id, ort.shopperid, ort.vendorid, ort.orderdetailid,ort.createddate,ort.statusid,dis.name as districtname,prov.name as provincename,dep.name as departmentname, ' ||
           '(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodet.Id and rownum=1) as ImageUrl,dis1.name as districtnamestore,prov1.name as provincenamestore,dep1.name as departmentnamestore,up.firstName,up.lastName,up.picture,sto.name AS StoreName, pro.name AS ProductName, oh.orderdate, ort.rating, ort.opinion, ' ||
           'ROW_NUMBER() OVER (ORDER BY ';

  IF porderType = 1 THEN
    v_sql := v_sql || 'ort.createddate DESC';
  ELSIF porderType = 2 THEN
    v_sql := v_sql || 'ort.rating DESC';
  ELSIF porderType = 3 THEN
    v_sql := v_sql || 'ort.rating ASC';
  ELSE
    v_sql := v_sql || 'ort.createddate DESC';
  END IF;

  v_sql := v_sql ||
           ') AS NroRow, ' ||
           '(SELECT COUNT(*) FROM OrderRating ort1 INNER JOIN OrderDetail od1 ON ort1.orderdetailid = od1.id WHERE ort1.statusid = 1 AND od1.productid = ' || pproductid || ') AS TotalRow ' ||
           'FROM OrderRating ort INNER JOIN OrderDetail od ON ort.orderdetailid = od.id ' ||
           'INNER JOIN OrderHeader oh ON od.orderid = oh.id ' ||
           'INNER JOIN Product pro ON od.productid = pro.id ' ||
           'inner join productdetail prodet on prodet.productid=pro.id ' ||
           'INNER JOIN StoreProduct stopro ON stopro.productid = pro.id ' ||
           'INNER JOIN Store sto ON stopro.storeid = sto.id ' ||
           'INNER JOIN UserPerson up ON ort.shopperid = up.id ' ||
           'LEFT JOIN orderdetailaddress oda ON oda.orderid = oh.id ' ||
           'LEFT JOIN district dis ON dis.id = oda.districtid ' ||
           'LEFT JOIN province prov ON prov.id = dis.provinceid ' ||
           'LEFT JOIN department dep ON dep.id = prov.departmentid ' ||
           'LEFT JOIN district dis1 ON dis1.id = sto.districtid ' ||
           'LEFT JOIN province prov1 ON prov1.id = dis1.provinceid ' ||
           'LEFT JOIN department dep1 ON dep1.id = prov1.departmentid ' ||
           'WHERE ort.statusid = 1 AND od.productid = ' || pproductid || ') ' ||
           'WHERE NroRow >= (( ' || prow || ' - 1) * ' || ptotalRecord || ' ) + 1 AND NroRow <= ( ' || prow || ' * ' || ptotalRecord || ' ) ' ||
           'ORDER BY NroRow';

  DBMS_OUTPUT.PUT_LINE('Generated SQL: ' || v_sql);

  OPEN cursorOut FOR v_sql;

  OPEN cursorRatingOut FOR
    WITH rating_values AS (
      SELECT 1 AS rating FROM DUAL UNION ALL
      SELECT 2 FROM DUAL UNION ALL
      SELECT 3 FROM DUAL UNION ALL
      SELECT 4 FROM DUAL UNION ALL
      SELECT 5 FROM DUAL
    )
    SELECT rv.rating, COALESCE(orc.ratingCount, 0) AS ratingCount
    FROM rating_values rv
    LEFT JOIN (
      SELECT ort.rating, COUNT(*) AS ratingCount
      FROM OrderRating ort
      JOIN OrderDetail od ON ort.orderdetailid = od.id
      WHERE od.productid = pproductid AND ort.statusid = 1
      GROUP BY ort.rating
    ) orc ON rv.rating = orc.rating
    ORDER BY rv.rating desc;

    FOR rec IN (
    SELECT ort.rating, COUNT(*) AS ratingCount
    FROM OrderRating ort
    JOIN OrderDetail od ON ort.orderdetailid = od.id
    WHERE od.productid = pproductid AND ort.statusid = 1
    GROUP BY ort.rating
  ) LOOP
    totalRatings := totalRatings + (rec.rating * rec.ratingCount);
    totalVotes := totalVotes + rec.ratingCount;
  END LOOP;

  IF totalVotes > 0 THEN
    averageRatingOut := ROUND(totalRatings / totalVotes,1);
  ELSE
    averageRatingOut := 0;
  END IF;
END RAT_ORDERRATING_GETBYPRODUCT_PAGINATED;

PROCEDURE RAT_ORDERRATING_GETBYID(pid IN number,cursorOut OUT RAT_CURSOR_ORDERRATING)
IS
BEGIN
  OPEN cursorOut FOR
SELECT 
  ort.id, 
  ort.shopperid, 
  ort.vendorid, 
  COALESCE(od.id, ord.orderdetailid) AS orderdetailid,  -- Para manejar tanto datos antiguos como nuevos
  ort.statusid,
  sto.name AS StoreName,
  pro.name AS ProductName, 
  ort.rating,
  ort.opinion,
  (SELECT imageurl 
   FROM productdetailimage proddetimg 
   WHERE proddetimg.productdetailid = prodet.id 
   AND ROWNUM = 1) AS ImageUrl,
  od.orderid--ort.orderid
FROM 
  orderrating ort
LEFT JOIN 
  OrderRatingDetail ord ON ord.OrderRatingID = ort.id 
LEFT JOIN 
  orderdetail od ON COALESCE(ort.orderdetailid, ord.orderdetailid) = od.id  -- Relacionamos tanto con el valor en OrderRating como con el valor en OrderRatingDetail
INNER JOIN 
  Product pro ON od.productid = pro.id
INNER JOIN 
  productdetail prodet ON prodet.productid = pro.id  
INNER JOIN 
  StoreProduct stopro ON stopro.productid = pro.id
INNER JOIN 
  Store sto ON stopro.storeid = sto.id
WHERE 
  ort.id = pid 
  AND ort.statusid = 1;
END RAT_ORDERRATING_GETBYID;

PROCEDURE RAT_ORDERRATING_GETBYORDERDETAILID(porderdetailid IN number,cursorOut OUT RAT_CURSOR_ORDERRATING)
IS
  v_orderid NUMBER;  -- Variable para almacenar el OrderID
BEGIN
  -- Obtener el OrderID a partir del OrderDetailID
  SELECT orderid 
  INTO v_orderid
  FROM orderdetail
  WHERE id = porderdetailid;
  OPEN cursorOut FOR
SELECT 
  ort.id, 
  ort.shopperid, 
  ort.vendorid, 
  COALESCE(od.id, ord.orderdetailid) AS orderdetailid,  -- Para manejar tanto datos antiguos como nuevos
  ort.statusid,
  sto.name AS StoreName,
  pro.name AS ProductName, 
  ort.rating,
  ort.opinion,
  (SELECT imageurl 
   FROM productdetailimage proddetimg 
   WHERE proddetimg.productdetailid = prodet.id 
   AND ROWNUM = 1) AS ImageUrl,
  ort.orderid
FROM 
  orderrating ort
LEFT JOIN 
  OrderRatingDetail ord ON ord.OrderRatingID = ort.id 
LEFT JOIN 
  orderdetail od ON COALESCE(ort.orderdetailid, ord.orderdetailid) = od.id  -- Relacionamos tanto con el valor en OrderRating como con el valor en OrderRatingDetail
INNER JOIN 
  Product pro ON od.productid = pro.id
INNER JOIN 
  productdetail prodet ON prodet.productid = pro.id  
INNER JOIN 
  StoreProduct stopro ON stopro.productid = pro.id
INNER JOIN 
  Store sto ON stopro.storeid = sto.id
WHERE 
  ort.orderid = v_orderid 
  AND ort.statusid = 1;
END RAT_ORDERRATING_GETBYORDERDETAILID;

PROCEDURE RAT_ORDERRATING_INSERT(
pshopperid IN NUMBER,
porderdetailid IN NUMBER,
prating IN NUMBER,
popinion IN VARCHAR2,
pstatusid  IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
AS
pSearchVendorID NUMBER:=0;
BEGIN
    select nvl((select nvl(oh.vendorid,0) from orderheader oh inner join orderdetail od on oh.id=od.orderid
    where rownum=1 and od.id=porderdetailid),0) into pSearchVendorID from dual;
    
 INSERT INTO OrderRating (
Shopperid,
Vendorid,
Orderdetailid,
Rating,
Opinion,
STATUSID,
CREATEDBY,
CREATEDDATE
)
VALUES
(pshopperid,
pSearchVendorID,
porderdetailid,
prating,
popinion,
pstatusid,
pcreatedby,
sysdate
)
  returning ID into IDOUT;
COMMIT;
END RAT_ORDERRATING_INSERT;

PROCEDURE RAT_ORDERRATING_UPDATE(
pid IN NUMBER,
prating IN NUMBER,
popinion IN VARCHAR2,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  Update OrderRating set Rating=prating, Opinion=popinion, StatusID=pstatusid, UpdatedBy=pupdatedby, UPDATEDDATE = sysdate WHERE ID = pid;

 rowsOut := SQL%rowcount;
 COMMIT;
END RAT_ORDERRATING_UPDATE;

PROCEDURE RAT_ORDERRATING_UPDATESTATUS(
pid IN NUMBER,
pstatusid  IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  Update OrderRating set StatusID=pstatusid, UpdatedBy=pupdatedby, UPDATEDDATE = sysdate WHERE ID = pid;
 rowsOut := SQL%rowcount;
 COMMIT;
END RAT_ORDERRATING_UPDATESTATUS;

PROCEDURE RAT_ORDERRATING_INSERT_XML(
    pshopperid      IN NUMBER,
    porderdetailid  IN NUMBER,
    prating         IN NUMBER,
    popinion        IN VARCHAR2,  -- Comentario general para la orden
    pstatusid       IN NUMBER,
    pcreatedby      IN NUMBER,
    pOrderRatingXML IN XMLTYPE,  -- XML para los detalles de productos
    porderid      IN NUMBER,
    IDOUT           OUT NUMBER
) AS
    pSearchVendorID NUMBER := 0;
    pidorder NUMBER := 0;

    -- Cursor para procesar el XML y extraer los datos de los productos
    CURSOR c_orderRatingDetails IS
        SELECT x.orderdetailid, x.productid, x.rating
        FROM XMLTABLE('/products/product' PASSING porderratingxml
            COLUMNS 
                orderdetailid NUMBER PATH 'orderdetailid',
                productid NUMBER PATH 'productid',
                rating    NUMBER PATH 'rating'
        ) x;

BEGIN
    -- Obtener VendorID y OrderID de la tabla OrderHeader
    SELECT NVL(oh.vendorid, 0), NVL(oh.id, 0)
    INTO pSearchVendorID, pidorder
    FROM orderheader oh
    INNER JOIN orderdetail od ON oh.id = od.orderid
    WHERE oh.id = porderid 
      AND ROWNUM = 1;

    -- Inserción de los datos en la tabla OrderRating
    INSERT INTO OrderRating (
        Shopperid,
        Vendorid,
        Orderdetailid,
        Rating,
        Opinion,  -- Comentario general
        STATUSID,
        CREATEDBY,
        CREATEDDATE,
        ORDERID
    )
    VALUES (
        pshopperid,
        pSearchVendorID,
        porderdetailid,
        prating,
        popinion,  -- Comentario general se inserta aquí
        pstatusid,
        pcreatedby,
        SYSDATE,
        porderid
    )
    RETURNING ID INTO IDOUT;
 
    -- Recorrer los detalles de calificación obtenidos del XML
    FOR detail_rec IN c_orderRatingDetails LOOP
        INSERT INTO OrderRatingDetail (
            OrderRatingID,
            OrderDetailID,
            ProductID,
            Rating,
            CREATEDBY,
            CREATEDDATE
        )
        VALUES (
            IDOUT,  -- El ID generado en la tabla OrderRating
            detail_rec.orderdetailid,  -- Vincula el OrderDetailID aquí
            detail_rec.productid,
            detail_rec.rating,
            pcreatedby,
            SYSDATE
        );
    END LOOP;

    COMMIT;
END RAT_ORDERRATING_INSERT_XML;

PROCEDURE RAT_ORDERRATING_UPDATE_XML(
   -- pshopperid      IN NUMBER, 
    --porderdetailid  IN NUMBER,
    prating         IN NUMBER,
    popinion        IN VARCHAR2,  -- Comentario general para la orden
    pstatusid       IN NUMBER,
    pupdatedby      IN NUMBER,
    pOrderRatingXML IN XMLTYPE,  -- XML para los detalles de productos
    porderid        IN NUMBER,
    pid             IN NUMBER,  -- ID del registro que se va a actualizar
    rowsOut out NUMBER
) AS 
    pSearchVendorID NUMBER := 0;
    pidorder        NUMBER := 0;

    -- Cursor para procesar el XML y extraer los datos de los productos
    CURSOR c_orderRatingDetails IS
        SELECT x.orderdetailid, x.productid, x.rating
        FROM XMLTABLE('/products/product' PASSING pOrderRatingXML
            COLUMNS 
                orderdetailid NUMBER PATH 'orderdetailid',
                productid NUMBER PATH 'productid',
                rating    NUMBER PATH 'rating'
        ) x;

BEGIN 
    -- Obtener VendorID y OrderID de la tabla OrderHeader
    SELECT NVL(oh.vendorid, 0), NVL(oh.id, 0)
    INTO pSearchVendorID, pidorder
    FROM orderheader oh
    INNER JOIN orderdetail od ON oh.id = od.orderid
    WHERE oh.id = porderid 
      AND ROWNUM = 1;

    -- Actualizar los datos en la tabla OrderRating
    UPDATE OrderRating
    SET
        --Shopperid   = pshopperid,
        --Vendorid    = pSearchVendorID,
        --Orderdetailid = porderdetailid,
        Rating      = prating,
        Opinion     = popinion,  -- Comentario general se actualiza aquí
        STATUSID    = pstatusid,
        UPDATEDBY   = pupdatedby,
        UPDATEDDATE = SYSDATE,
        ORDERID     = porderid
    WHERE ID = pid;  -- Para identificar el registro que se va a actualizar

    -- Si se actualiza correctamente, seguimos con la actualización de los detalles
    IF SQL%ROWCOUNT > 0 THEN
        -- Recorrer los detalles de calificación obtenidos del XML
        FOR detail_rec IN c_orderRatingDetails LOOP
            -- Actualizar en OrderRatingDetail
            UPDATE OrderRatingDetail
            SET
                Rating      = detail_rec.rating,
                UPDATEDBY   = pupdatedby,
                UPDATEDDATE = SYSDATE
            WHERE OrderRatingID = pid
              AND OrderDetailID = detail_rec.orderdetailid
              AND ProductID     = detail_rec.productid;
        END LOOP;
    END IF;
    rowsOut := SQL%rowcount;

    COMMIT;
END RAT_ORDERRATING_UPDATE_XML;

PROCEDURE RAT_ORDERRATINGDETAIL_GETBYID(pOrderRatingID IN NUMBER,
    cursorOut OUT RAT_CURSOR_ORDERRATING)
AS
BEGIN
  OPEN cursorOut FOR
  
   SELECT 
        ordet.OrderRatingID,
        ordet.OrderDetailID,
        ordet.ProductID,
        ordet.Rating,
        (select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodet.Id and rownum=1) as ImageUrl,
        pro.name as ProductName,
        pro.sku as Sku
    FROM  
        OrderRatingDetail ordet 
        inner join orderrating ort on ort.id = ordet.OrderRatingID
        inner join Product pro on ordet.productid=pro.id
        inner join productdetail prodet on prodet.productid=pro.id  
    WHERE 
        ordet.OrderRatingID = pOrderRatingID
        and ort.statusid=1;
  
END RAT_ORDERRATINGDETAIL_GETBYID;

end PCK_ORDERRATING;
/