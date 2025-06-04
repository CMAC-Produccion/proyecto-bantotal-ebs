create or replace package USRECOSISTEMAS.PKG_SHOPPINGCART is
  type FIN_CURSOR_SHOPPINGCART IS REF CURSOR; 
  PROCEDURE SHOPPINGCART_SAVE(
  puserid NUMBER,
  pproductid IN NUMBER,
  pquantity IN NUMBER,
  pstatusid IN NUMBER,
  pcreatedby  IN NUMBER,
  IDOUT out NUMBER);
  PROCEDURE SHOPPINGCART_GETBYUSERID(puserid IN NUMBER, cursorOut OUT FIN_CURSOR_SHOPPINGCART);
  PROCEDURE SHOPPINGCART_UPDATESTATUS(
  puserid NUMBER,
  pproductid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby  IN NUMBER,
  rowsOut out NUMBER);
  
  PROCEDURE REPORT_SHOPPING_CART_DETAILS (cursorOut OUT FIN_CURSOR_SHOPPINGCART);
  PROCEDURE GET_CARTS_PENDING_PURCHASE_1H (cursorOut OUT FIN_CURSOR_SHOPPINGCART);
PROCEDURE MARK_CART_AS_NOTIFIED(pCartId IN NUMBER,  IDOUT OUT NUMBER);
end PKG_SHOPPINGCART;
/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_SHOPPINGCART IS

PROCEDURE SHOPPINGCART_SAVE(
  puserid IN NUMBER,
  pproductid IN NUMBER,
  pquantity IN NUMBER,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT OUT NUMBER)
IS
  v_cart_id NUMBER;
  v_storeid NUMBER;
  v_price NUMBER(13,2);
  v_existing_quantity NUMBER;
  v_exists NUMBER;
  v_err_msg VARCHAR2(4000);
BEGIN
  BEGIN
    BEGIN
      SELECT id 
      INTO v_cart_id
      FROM SHOPPINGCART
      WHERE userid = puserid 
      AND statusid = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_cart_id := NULL;
    END;

    IF v_cart_id IS NULL THEN
      INSERT INTO SHOPPINGCART (userid, statusid, createdby, Createddate)
      VALUES (puserid, pstatusid, pcreatedby, SYSDATE)
      RETURNING id INTO v_cart_id;
    END IF;
    
    IDOUT := v_cart_id;

    BEGIN
      SELECT storeid 
      INTO v_storeid
      FROM storeproduct
      WHERE productid = pproductid
      AND ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_storeid := NULL;
        DBMS_OUTPUT.PUT_LINE('Error: No se encontr? storeid para el productid ' || pproductid);
        RAISE;
    END;

    BEGIN
      SELECT CASE
               WHEN offerprice IS NULL OR offerprice = 0 THEN retailprice
               ELSE offerprice
             END AS price
      INTO v_price
      FROM productdetail
      WHERE productid = pproductid
      AND ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_price := NULL;
        DBMS_OUTPUT.PUT_LINE('Error: No se encontr? precio para el productid ' || pproductid);
        RAISE;
    END;

    SELECT COUNT(*)
    INTO v_exists
    FROM SHOPPINGCARTDETAIL
    WHERE SHOPPINGCARTID = v_cart_id
    AND PRODUCTID = pproductid
    AND STATUSID = 1;
    
    IF v_exists > 0 THEN
      SELECT quantity 
      INTO v_existing_quantity
      FROM SHOPPINGCARTDETAIL
      WHERE SHOPPINGCARTID = v_cart_id
      AND PRODUCTID = pproductid
      AND STATUSID = 1;
      
      UPDATE SHOPPINGCARTDETAIL
      SET QUANTITY = pquantity,
          PRICE = v_price,
          CREATEDBY = pcreatedby,
          CREATEDDATE = SYSDATE
      WHERE SHOPPINGCARTID = v_cart_id
      AND PRODUCTID = pproductid
      AND STATUSID = 1;
    ELSE
      INSERT INTO SHOPPINGCARTDETAIL(SHOPPINGCARTID, PRODUCTID, STOREID, PRICE, QUANTITY, STATUSID, CREATEDBY, CREATEDDATE)
      VALUES(v_cart_id, pproductid, v_storeid, v_price, pquantity, pstatusid, pcreatedby, SYSDATE);
    END IF;
    
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      v_err_msg := SQLERRM;
      DBMS_OUTPUT.PUT_LINE('Error: ' || v_err_msg);
      ROLLBACK;
      RAISE;
  END;
END SHOPPINGCART_SAVE;
PROCEDURE SHOPPINGCART_GETBYUSERID(puserid IN NUMBER, cursorOut OUT FIN_CURSOR_SHOPPINGCART)
  IS
BEGIN
 OPEN cursorOut FOR
select 
sc.id,
sc.statusid,
scd.id as shoppingcartdetailid,
scd.productid,
scd.storeid,
scd.price,
scd.quantity,
sto.name as storename,
pro.name as productname,
pro.sku,
prodet.retailprice,
prodet.offerprice,
prodet.stock,
(select imageurl from productdetailimage proddetimg where proddetimg.productdetailid=prodet.Id and rownum=1) as ImageUrl,
round((scd.price*scd.quantity),2) as SubTotal,
sto.userid as vendorid
from shoppingcart sc
inner join shoppingcartdetail scd on sc.id=scd.shoppingcartid and sc.userid=puserid and sc.statusid=1 and scd.statusid=1
inner join store sto on sto.id=scd.storeid
inner join product pro on scd.productid=pro.id
inner join productdetail prodet on pro.id=prodet.productid;
END SHOPPINGCART_GETBYUSERID;
PROCEDURE SHOPPINGCART_UPDATESTATUS(
  puserid NUMBER,
  pproductid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby  IN NUMBER,
  rowsOut out NUMBER)
IS
  v_cart_id NUMBER;
  v_count NUMBER;
BEGIN
  SELECT id 
  INTO v_cart_id
  FROM SHOPPINGCART
  WHERE userid = puserid 
  AND statusid = 1;
  
  IF v_cart_id > 0 THEN
    
    update shoppingcartdetail set statusid=pstatusid, updatedby=pupdatedby, updateddate=sysdate where productid=pproductid and shoppingcartid=v_cart_id;
    
    SELECT COUNT(*)
    INTO v_count
    FROM shoppingcartdetail
    WHERE shoppingcartid = v_cart_id
    AND statusid = pstatusid;
    
    SELECT COUNT(*)
    INTO v_count
    FROM shoppingcartdetail
    WHERE shoppingcartid = v_cart_id
      AND statusid <> pstatusid;
      
    IF v_count = 0 THEN
      UPDATE shoppingcart
      SET statusid = pstatusid,updatedby=pupdatedby, updateddate=sysdate
      WHERE id = v_cart_id;
    END IF; 
    
    rowsOut := v_cart_id;
    
    COMMIT;
  END IF;
END SHOPPINGCART_UPDATESTATUS;
PROCEDURE REPORT_SHOPPING_CART_DETAILS(cursorOut OUT FIN_CURSOR_SHOPPINGCART)
IS
BEGIN
  OPEN cursorOut FOR
    SELECT
      UserId,
      FirstName,
      LastName,
      Email,
      ShoppingCartId,
      ProductId,
      ProductName,
      ProductImage
    FROM (
      SELECT
        u.id AS UserId,
        u.firstname AS FirstName,
        u.lastname AS LastName,
        u.email AS Email,
        sc.id AS ShoppingCartId,
        p.id AS ProductId,
        p.name AS ProductName,
        (
          SELECT MIN(pdi.imageurl)
          FROM productdetail pd
          JOIN productdetailimage pdi ON pd.id = pdi.productdetailid
          WHERE pd.productid = p.id
        ) AS ProductImage
      FROM userperson u
      JOIN shoppingcart sc ON sc.userid = u.id
      JOIN shoppingcartdetail scd ON scd.shoppingcartid = sc.id
      JOIN product p ON scd.productid = p.id
      WHERE u.statusid = 1
        AND sc.statusid = 1
        AND scd.statusid = 1
        AND p.statusid = 1
        AND sc.createddate <= (SYSDATE - (1/24)) -- hace más de 1 hora
    )
    ORDER BY UserId, ShoppingCartId, RowNum;
END REPORT_SHOPPING_CART_DETAILS;

PROCEDURE GET_CARTS_PENDING_PURCHASE_1H (
    cursorOut OUT FIN_CURSOR_SHOPPINGCART
)
IS
BEGIN
    OPEN cursorOut FOR
    SELECT *
    FROM (
        SELECT 
            sc.id AS ShoppingCartID,
            sc.userid AS UserID,
            u.email AS Email,
            p.id AS ProductID, 
            p.name AS ProductName,
            pdi.imageurl AS ImageUrl,
            scd.price AS ProductPrice,
            ROW_NUMBER() OVER (PARTITION BY sc.id ORDER BY scd.createddate ASC) AS ProductRow
        FROM shoppingcart sc 
        INNER JOIN shoppingcartdetail scd ON sc.id = scd.shoppingcartid
        INNER JOIN product p ON scd.productid = p.id
        inner join Productdetail Pdl on Pdl.ProductId = p.Id
        inner join productdetailimage pdi on pdi.ProductDetailId = Pdl.Id
        LEFT JOIN userperson u ON sc.userid = u.id
        WHERE 
            sc.statusid = 1
            AND sc.createddate <= SYSDATE - (1/24)
            AND (sc.notified IS NULL OR sc.notified = 0)
    )
    WHERE ProductRow <= 3
    ORDER BY ShoppingCartID, ProductRow;
END GET_CARTS_PENDING_PURCHASE_1H; 
PROCEDURE MARK_CART_AS_NOTIFIED (
    pCartId IN NUMBER,
     IDOUT OUT NUMBER
)
IS
BEGIN 
    UPDATE shoppingcart
    SET notified = 1, updateddate = SYSDATE
    WHERE id = pCartId;
     IDOUT := SQL%rowcount;
    COMMIT;
END MARK_CART_AS_NOTIFIED;
END PKG_SHOPPINGCART;

/