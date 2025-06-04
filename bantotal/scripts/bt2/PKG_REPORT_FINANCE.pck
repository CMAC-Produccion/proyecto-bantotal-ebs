create or replace package USRECOSISTEMAS.PKG_REPORT_FINANCE is
  type REPFIN_CURSOR_REPORTFINANCE IS REF CURSOR;
  type ARRAY_NUMBER IS TABLE OF NUMBER;

PROCEDURE REPFIN_REPORTFINANCE_GETBYSTOREANDDATE(pstoreid IN NUMBER, pdate IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_GETWEEKLY(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_GETMONTH(pstoreid IN NUMBER, pmonth IN VARCHAR2,pyear IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_GETYEAR(pstoreid IN NUMBER,pyear IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_GETRANGE(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);

 PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_DATE(pstoreid IN NUMBER, pdate IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
 PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETWEEKLY(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETMONTH(pstoreid IN NUMBER, pmonth IN VARCHAR2,pyear IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETYEAR(pstoreid IN NUMBER,pyear IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETRANGE(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);

PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_DATE(pstoreid IN NUMBER, pdate IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETWEEKLY (pstoreid IN NUMBER,pdatestart IN VARCHAR2,pdateend IN VARCHAR2, cursorOut OUT REPFIN_CURSOR_REPORTFINANCE );
PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETMONTH(pstoreid IN NUMBER, pmonth IN VARCHAR2,pyear IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETYEAR(pstoreid IN NUMBER,pyear IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETRANGE(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
PROCEDURE REPFIN_REPORTFINANCE_GETTOTAL_ENTREPRENEURS(ptypeprofile IN NUMBER, cursorOut OUT REPFIN_CURSOR_REPORTFINANCE);
end PKG_REPORT_FINANCE;
/
create or replace package body USRECOSISTEMAS.PKG_REPORT_FINANCE is


PROCEDURE REPFIN_REPORTFINANCE_GETBYSTOREANDDATE(pstoreid IN NUMBER, pdate IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE)
  IS
  BEGIN
    OPEN cursorOut FOR
    WITH Report_Finance_ByStoreAndDate
as
(
SELECT 
e.id,
e.name,
e.quantity,
e.unitprice,'expense' as operationType,
2 as operationTypeID, 
e.operationdate as operationdate,
e.createddate as createddate,
(e.quantity * e.unitprice) as total,
param3.value2 as currencyTypeSigla,
supp.name as supplierName,
param4.value1 as paymentMethodName,
e.typeincometransaction as typeincometransaction,
'' as customername,
e.expenseCreditID as creditid
    FROM expense e LEFT JOIN mastertabledetail param3
    on e.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN  usersupplier supp
    on e.supplierid = supp.id LEFT JOIN mastertabledetail param4
    on e.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    WHERE 
      to_char(e.operationdate,'YYYY-MM-DD') = pdate 
     AND e.storeid=pstoreid and e.statusid=1
    union
    select 
    r.id,
    r.name,
    r.quantity,
    r.unitprice,'revenue' as operationType,
    1 as operationTypeID, 
    r.operationdate as operationdate,
    r.createddate as createddate,
    (r.total) as total,
    param3.value2 as currencyTypeSigla,
    '' as supplierName,
    param4.value1 as paymentMethodName,
    r.typeincometransaction,
    r.customername,
    r.revenuecreditid as creditid
    from revenue r LEFT JOIN mastertabledetail param3
    on r.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN mastertabledetail param4
    on r.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    where    
     (ppaymentMethodIDs is null or r.paymentmethodid in (SELECT * FROM TABLE(split_string(ppaymentMethodIDs))))
     AND (pvoucherTypeIDs is null or r.vouchertypeid in (SELECT * FROM TABLE(split_string(pvoucherTypeIDs))))
     AND to_char(r.operationdate,'YYYY-MM-DD') = pdate 
     AND r.storeid=pstoreid and r.statusid=1
    order by createddate desc)
    select id,name, quantity,unitprice,operationType,operationTypeID,operationdate,createddate,total,currencyTypeSigla,supplierName,paymentMethodName,typeincometransaction,customername,creditid,rownum from Report_Finance_ByStoreAndDate;
  END REPFIN_REPORTFINANCE_GETBYSTOREANDDATE;
PROCEDURE REPFIN_REPORTFINANCE_GETWEEKLY(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE)
  IS
  BEGIN
   OPEN cursorOut FOR
    WITH Report_Finance_ByStoreAndWeeklyDate
as
(   SELECT 
e.id,
e.name,
e.quantity,
e.unitprice,'expense' as operationType,
2 as operationTypeID, 
e.operationdate as operationdate,
e.createddate as createddate,
(e.quantity * e.unitprice) as total,
param3.value2 as currencyTypeSigla,
supp.name as supplierName,
param4.value1 as paymentMethodName,
e.typeincometransaction as typeincometransaction,
'' as customername,
e.expenseCreditID as creditid
    FROM expense e LEFT JOIN mastertabledetail param3
    on e.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN  usersupplier supp
    on e.supplierid = supp.id LEFT JOIN mastertabledetail param4
    on e.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    WHERE 
     to_char(e.operationdate,'YYYY-MM-DD') >= pdatestart and  to_char(e.operationdate,'YYYY-MM-DD') <= pdateend
     AND e.storeid=pstoreid and e.statusid=1
    union
    select r.id,r.name,r.quantity,r.unitprice,'revenue' as operationType,1 as operationTypeID, r.operationdate as operationdate,r.createddate as createddate,
        (r.total) as total,param3.value2 as currencyTypeSigla,
    '' as supplierName,
    param4.value1 as paymentMethodName,
    r.typeincometransaction,
    r.customername,
    r.revenuecreditid as creditid
    from revenue r LEFT JOIN mastertabledetail param3
    on r.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN mastertabledetail param4
    on r.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    where    
         (ppaymentMethodIDs is null or r.paymentmethodid in (SELECT * FROM TABLE(split_string(ppaymentMethodIDs))))
     AND (pvoucherTypeIDs is null or r.vouchertypeid in (SELECT * FROM TABLE(split_string(pvoucherTypeIDs))))
     AND to_char(r.operationdate,'YYYY-MM-DD') >= pdatestart and  to_char(r.operationdate,'YYYY-MM-DD') <= pdateend
     AND r.storeid=pstoreid and r.statusid=1
    order by createddate desc)
    select id,name, quantity,unitprice,operationType,operationTypeID,operationdate,createddate,total,currencyTypeSigla,supplierName,paymentMethodName,typeincometransaction,customername,creditid,rownum from Report_Finance_ByStoreAndWeeklyDate;
  END REPFIN_REPORTFINANCE_GETWEEKLY;
PROCEDURE REPFIN_REPORTFINANCE_GETMONTH(pstoreid IN NUMBER, pmonth IN VARCHAR2,pyear IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE)
  IS
  BEGIN
    OPEN cursorOut FOR
    WITH Report_Finance_ByStoreAndMonthDate
as
( SELECT 
e.id,
e.name,
e.quantity,
e.unitprice,
'expense' as operationType,
2 as operationTypeID, 
e.operationdate as operationdate,
e.createddate as createddate,
(e.quantity * e.unitprice) as total,
param3.value2 as currencyTypeSigla,
supp.name as supplierName,
param4.value1 as paymentMethodName,
e.typeincometransaction as typeincometransaction,
'' as customername,
e.expenseCreditID as creditid
    FROM expense e LEFT JOIN mastertabledetail param3
    on e.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN  usersupplier supp
    on e.supplierid = supp.id LEFT JOIN mastertabledetail param4
    on e.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    WHERE 
     to_char(e.operationdate,'MM') = pmonth and to_char(e.operationdate,'YYYY') = pyear
     AND e.storeid=pstoreid and e.statusid=1
    union
    select r.id,r.name,r.quantity,r.unitprice,'revenue' as operationType,1 as operationTypeID, r.operationdate as operationdate,r.createddate as createddate,
        (r.total) as total,param3.value2 as currencyTypeSigla,
    '' as supplierName,
    param4.value1 as paymentMethodName,
    r.typeincometransaction,
    r.customername,
    r.revenuecreditid as creditid
    from revenue r LEFT JOIN mastertabledetail param3
    on r.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN mastertabledetail param4
    on r.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    where    
   (ppaymentMethodIDs is null or r.paymentmethodid in (SELECT * FROM TABLE(split_string(ppaymentMethodIDs))))
     AND (pvoucherTypeIDs is null or r.vouchertypeid in (SELECT * FROM TABLE(split_string(pvoucherTypeIDs))))
    AND to_char(r.operationdate,'MM') = pmonth and to_char(r.operationdate,'YYYY') = pyear
     AND r.storeid=pstoreid and r.statusid=1
    order by createddate desc)
    select id,name, quantity,unitprice,operationType,operationTypeID,operationdate,createddate,total,currencyTypeSigla,supplierName,paymentMethodName,typeincometransaction,customername,creditid,rownum from Report_Finance_ByStoreAndMonthDate;
  END REPFIN_REPORTFINANCE_GETMONTH;
PROCEDURE REPFIN_REPORTFINANCE_GETYEAR(pstoreid IN NUMBER,pyear IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE)
  IS
  BEGIN
    OPEN cursorOut FOR
    WITH Report_Finance_ByStoreAndYearDate
    AS
   (SELECT e.id,e.name,e.quantity,e.unitprice,'expense' as operationType,2 as operationTypeID, e.operationdate as operationdate,e.createddate as createddate,
    (e.quantity * e.unitprice) as total,param3.value2 as currencyTypeSigla,
    supp.name as supplierName,
    param4.value1 as paymentMethodName,
e.typeincometransaction as typeincometransaction,
'' as customername,
e.expenseCreditID as creditid
    FROM expense e LEFT JOIN mastertabledetail param3 
    on e.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN  usersupplier supp
    on e.supplierid = supp.id LEFT JOIN mastertabledetail param4
    on e.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    WHERE  
    to_char(e.operationdate,'YYYY') = pyear and e.storeid=pstoreid and e.statusid=1
    union
    select r.id,r.name,r.quantity,r.unitprice,'revenue' as operationType,1 as operationTypeID, r.operationdate as operationdate,r.createddate as createddate,
       (r.total) as total,param3.value2 as currencyTypeSigla,
    '' as supplierName,
    param4.value1 as paymentMethodName,
    r.typeincometransaction,
    r.customername,
    r.revenuecreditid as creditid
    from revenue r LEFT JOIN mastertabledetail param3
    on r.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN mastertabledetail param4
    on r.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    where    (ppaymentMethodIDs is null or r.paymentmethodid in (SELECT * FROM TABLE(split_string(ppaymentMethodIDs))))
     AND (pvoucherTypeIDs is null or r.vouchertypeid in (SELECT * FROM TABLE(split_string(pvoucherTypeIDs))))
     AND to_char(r.operationdate,'YYYY') = pyear and r.storeid=pstoreid and r.statusid=1
    order by createddate desc)
    select id,name, quantity,unitprice,operationType,operationTypeID,operationdate,createddate,total,currencyTypeSigla,supplierName,paymentMethodName,typeincometransaction,customername,creditid,rownum from Report_Finance_ByStoreAndYearDate;
  END REPFIN_REPORTFINANCE_GETYEAR;
PROCEDURE REPFIN_REPORTFINANCE_GETRANGE(pstoreid IN NUMBER, pdatestart IN VARCHAR2,pdateend IN VARCHAR2,ppaymentMethodIDs IN VARCHAR2,pvoucherTypeIDs IN VARCHAR2,cursorOut OUT REPFIN_CURSOR_REPORTFINANCE)
  IS
  BEGIN
   OPEN cursorOut FOR
    WITH Report_Finance_ByStoreAndRangeDate
as
(   SELECT 
e.id,
e.name,
e.quantity,
e.unitprice,'expense' as operationType,
2 as operationTypeID, 
e.operationdate as operationdate,
e.createddate as createddate,
(e.quantity * e.unitprice) as total,
param3.value2 as currencyTypeSigla,
supp.name as supplierName,
param4.value1 as paymentMethodName,
e.typeincometransaction as typeincometransaction,
'' as customername,
e.expenseCreditID as creditid
    FROM expense e LEFT JOIN mastertabledetail param3
    on e.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN  usersupplier supp
    on e.supplierid = supp.id LEFT JOIN mastertabledetail param4
    on e.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    WHERE 
       to_char(e.operationdate,'YYYY-MM-DD') >= pdatestart and  to_char(e.operationdate,'YYYY-MM-DD') <= pdateend
     AND e.storeid=pstoreid and e.statusid=1
    union
    select r.id,r.name,r.quantity,r.unitprice,'revenue' as operationType,1 as operationTypeID, r.operationdate as operationdate,r.createddate as createddate,
       (r.total) as total,param3.value2 as currencyTypeSigla,
    '' as supplierName,
    param4.value1 as paymentMethodName,
    r.typeincometransaction,
    r.customername, 
    r.revenuecreditid as creditid
    from revenue r LEFT JOIN mastertabledetail param3 
    on r.currencytypeid = param3.idparameter and param3.mastertableid = 15 LEFT JOIN mastertabledetail param4
    on r.paymentmethodid = param4.idparameter and param4.mastertableid = 13
    where    
     (ppaymentMethodIDs is null or r.paymentmethodid in (SELECT * FROM TABLE(split_string(ppaymentMethodIDs))))
     AND (pvoucherTypeIDs is null or r.vouchertypeid in (SELECT * FROM TABLE(split_string(pvoucherTypeIDs))))
     AND to_char(r.operationdate,'YYYY-MM-DD') >= pdatestart and  to_char(r.operationdate,'YYYY-MM-DD') <= pdateend
     AND r.storeid=pstoreid and r.statusid=1
    order by createddate desc)
    select id,name, quantity,unitprice,operationType,operationTypeID,operationdate,createddate,total,currencyTypeSigla,supplierName,paymentMethodName,typeincometransaction,customername,creditid,rownum from Report_Finance_ByStoreAndRangeDate;
  END REPFIN_REPORTFINANCE_GETRANGE;
  
PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_DATE (
    pstoreid IN NUMBER,          
    pdate IN VARCHAR2,           
    cursorOut OUT REPFIN_CURSOR_REPORTFINANCE 
) AS
BEGIN
    OPEN cursorOut FOR
        WITH ProductSales AS (
            SELECT 
                 ProductID,
                 ProductName,
                SUM(quantity) AS TotalQuantity
            FROM (
                -- Ventas de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    od.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN orderdetail od ON p.id = od.productid
                INNER JOIN orderheader oh ON oh.id = od.orderid
                WHERE 
                    s.id = pstoreid
                    AND to_char(oh.orderdate, 'YYYY-MM-DD') = pdate 
                    AND oh.orderstatus = 3
                
                UNION ALL
                
                -- Ingresos de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    rdp.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN revenuedetailproduct rdp ON p.id = rdp.productid
                INNER JOIN revenue rh ON rh.id = rdp.revenueid
                WHERE 
                    s.id = pstoreid
                    AND to_char(rh.createddate, 'YYYY-MM-DD') = pdate
                    AND rdp.statusid = 1 -- Solo incluir ingresos válidos
            ) CombinedData
            GROUP BY 
                ProductID, ProductName
        )
        SELECT  
            ProductName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM ProductSales), 2) AS Percentage
        FROM 
            ProductSales
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_DATE;
PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETWEEKLY (
  pstoreid IN NUMBER,
  pdatestart IN VARCHAR2,
  pdateend IN VARCHAR2,          
  cursorOut OUT REPFIN_CURSOR_REPORTFINANCE 
) AS
BEGIN 
    OPEN cursorOut FOR
        WITH ProductSales AS (
            SELECT 
                ProductID,
                ProductName,
                SUM(Quantity) AS TotalQuantity
            FROM (
                -- Ventas de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    od.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN orderdetail od ON p.id = od.productid
                INNER JOIN orderheader oh ON oh.id = od.orderid
                WHERE 
                    s.id = pstoreid
                    AND to_char(oh.orderdate, 'YYYY-MM-DD') >= pdatestart 
                    AND to_char(oh.orderdate, 'YYYY-MM-DD') <= pdateend
                    AND oh.orderstatus = 3
                
                UNION ALL
                
                -- Ingresos de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    rdp.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN revenuedetailproduct rdp ON p.id = rdp.productid
                INNER JOIN revenue rh ON rh.id = rdp.revenueid
                WHERE 
                    s.id = pstoreid
                    AND to_char(rh.createddate, 'YYYY-MM-DD') >= pdatestart 
                    AND to_char(rh.createddate, 'YYYY-MM-DD') <= pdateend
                    AND rdp.statusid = 1 -- Solo incluir ingresos válidos
            ) CombinedData
            GROUP BY 
                ProductID, ProductName
        )
        SELECT  
            ProductName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM ProductSales), 2) AS Percentage
        FROM 
            ProductSales
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETWEEKLY;
PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETMONTH (
  pstoreid IN NUMBER,
  pmonth IN VARCHAR2,
  pyear IN VARCHAR2,      
  cursorOut OUT REPFIN_CURSOR_REPORTFINANCE 
) AS
BEGIN 
    OPEN cursorOut FOR
        WITH ProductSales AS (
            SELECT 
                ProductID,
                ProductName,
                SUM(Quantity) AS TotalQuantity
            FROM (
                -- Ventas de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    od.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN orderdetail od ON p.id = od.productid
                INNER JOIN orderheader oh ON oh.id = od.orderid
                WHERE 
                    s.id = pstoreid
                    AND to_char(oh.orderdate, 'MM') = pmonth 
                    AND to_char(oh.orderdate, 'YYYY') = pyear
                    AND oh.orderstatus = 3
                
                UNION ALL
                
                -- Ingresos de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    rdp.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN revenuedetailproduct rdp ON p.id = rdp.productid
                INNER JOIN revenue rh ON rh.id = rdp.revenueid
                WHERE 
                    s.id = pstoreid
                    AND to_char(rh.createddate, 'MM') = pmonth 
                    AND to_char(rh.createddate, 'YYYY') = pyear
                    AND rdp.statusid = 1 -- Solo incluir ingresos válidos
            ) CombinedData
            GROUP BY 
                ProductID, ProductName
        )
        SELECT   
            ProductName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM ProductSales), 2) AS Percentage
        FROM 
            ProductSales
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETMONTH;
PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETYEAR (
  pstoreid IN NUMBER,
  pyear IN VARCHAR2,
  cursorOut OUT REPFIN_CURSOR_REPORTFINANCE 
) AS
BEGIN 
    OPEN cursorOut FOR
        WITH ProductSales AS (
            SELECT 
                ProductID,
                ProductName,
                SUM(Quantity) AS TotalQuantity
            FROM (
                -- Ventas de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    od.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN orderdetail od ON p.id = od.productid
                INNER JOIN orderheader oh ON oh.id = od.orderid
                WHERE 
                    s.id = pstoreid
                    AND to_char(oh.orderdate, 'YYYY') = pyear
                    AND oh.orderstatus = 3
                
                UNION ALL
                
                -- Ingresos de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    rdp.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN revenuedetailproduct rdp ON p.id = rdp.productid
                INNER JOIN revenue rh ON rh.id = rdp.revenueid
                WHERE 
                    s.id = pstoreid
                    AND to_char(rh.createddate, 'YYYY') = pyear
                    AND rdp.statusid = 1 -- Solo incluir ingresos válidos
            ) CombinedData
            GROUP BY 
                ProductID, ProductName
        )
        SELECT    
            ProductName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM ProductSales), 2) AS Percentage
        FROM 
            ProductSales 
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETYEAR;

PROCEDURE REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETRANGE (
  pstoreid IN NUMBER,
  pdatestart IN VARCHAR2,
  pdateend IN VARCHAR2,
  cursorOut OUT REPFIN_CURSOR_REPORTFINANCE 
) AS
BEGIN  
    OPEN cursorOut FOR
        WITH ProductSales AS (
            SELECT 
                ProductID,
                ProductName,
                SUM(Quantity) AS TotalQuantity
            FROM (
                -- Ventas de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    od.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN orderdetail od ON p.id = od.productid
                INNER JOIN orderheader oh ON oh.id = od.orderid
                WHERE 
                    s.id = pstoreid
                    AND to_char(oh.orderdate, 'YYYY-MM-DD') >= pdatestart 
                    AND to_char(oh.orderdate, 'YYYY-MM-DD') <= pdateend
                    AND oh.orderstatus = 3
                
                UNION ALL
                
                -- Ingresos de productos
                SELECT 
                    p.id AS ProductID,
                    p.name AS ProductName,
                    rdp.quantity AS Quantity
                FROM 
                    store s
                INNER JOIN storeproduct sp ON s.id = sp.storeid
                INNER JOIN product p ON p.id = sp.productid
                INNER JOIN revenuedetailproduct rdp ON p.id = rdp.productid
                INNER JOIN revenue rh ON rh.id = rdp.revenueid
                WHERE 
                    s.id = pstoreid
                    AND to_char(rh.createddate, 'YYYY-MM-DD') >= pdatestart 
                    AND to_char(rh.createddate, 'YYYY-MM-DD') <= pdateend
                    AND rdp.statusid = 1 -- Solo incluir ingresos válidos
            ) CombinedData
            GROUP BY 
                ProductID, ProductName
        )
        SELECT    
            ProductName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM ProductSales), 2) AS Percentage
        FROM 
            ProductSales 
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_PRODUCTS_BESTSELLER_GETRANGE;

PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_DATE (
    pstoreid IN NUMBER,        
    pdate IN VARCHAR2,          
    cursorOut OUT REPFIN_CURSOR_REPORTFINANCE
) AS
BEGIN
   OPEN cursorOut FOR
        WITH CategorySales AS (
            SELECT 
                c.id AS CategoryID,
                c.name AS CategoryName,
                sc.name AS SubCategoryName,
                ssc.name AS SubSubCategoryName,
                SUM(od.quantity) AS TotalQuantity
            FROM 
                store s
            INNER JOIN categorystore cs ON s.id = cs.idstore
            INNER JOIN category c ON cs.idcategory = c.id
            INNER JOIN subcategory sc ON sc.categoryid = c.id
            INNER JOIN subsubcategory ssc ON ssc.subcategoryid = sc.id
            INNER JOIN product p ON p.subsubcategoryid = ssc.id  -- Relaciona sub-subcategoría con producto
            INNER JOIN orderdetail od ON p.id = od.productid
            INNER JOIN orderheader oh ON oh.id = od.orderid
             WHERE 
                s.id = pstoreid
                 AND to_char(oh.orderdate,'YYYY-MM-DD') = pdate
                AND oh.orderstatus = 3 
            GROUP BY 
                c.id, c.name, sc.name, ssc.name
        ) 
        SELECT 
            CategoryName || ', ' || SubCategoryName || ', ' || SubSubCategoryName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM CategorySales), 2) AS Percentage
        FROM 
            CategorySales
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_DATE;

PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETWEEKLY (
     pstoreid IN NUMBER,
  pdatestart IN VARCHAR2,
  pdateend IN VARCHAR2,          
    cursorOut OUT REPFIN_CURSOR_REPORTFINANCE 
) AS
BEGIN
   OPEN cursorOut FOR
        WITH CategorySales AS (
            SELECT 
                c.id AS CategoryID,
                c.name AS CategoryName,
                sc.name AS SubCategoryName,
                ssc.name AS SubSubCategoryName,
                SUM(od.quantity) AS TotalQuantity
            FROM 
                store s
            INNER JOIN categorystore cs ON s.id = cs.idstore
            INNER JOIN category c ON cs.idcategory = c.id
            INNER JOIN subcategory sc ON sc.categoryid = c.id
            INNER JOIN subsubcategory ssc ON ssc.subcategoryid = sc.id
            INNER JOIN product p ON p.subsubcategoryid = ssc.id  -- Relaciona sub-subcategoría con producto
            INNER JOIN orderdetail od ON p.id = od.productid
            INNER JOIN orderheader oh ON oh.id = od.orderid
             WHERE 
                s.id = pstoreid
                 AND to_char(oh.orderdate,'YYYY-MM-DD') >= pdatestart and  to_char(oh.orderdate,'YYYY-MM-DD') <= pdateend
                AND oh.orderstatus = 3 
            GROUP BY 
                c.id, c.name, sc.name, ssc.name
        ) 
        SELECT 
            CategoryName || ', ' || SubCategoryName || ', ' || SubSubCategoryName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM CategorySales), 2) AS Percentage
        FROM 
            CategorySales
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETWEEKLY;

PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETMONTH (
   pstoreid IN NUMBER,
 pmonth IN VARCHAR2,
 pyear IN VARCHAR2,      
    cursorOut OUT REPFIN_CURSOR_REPORTFINANCE 
) AS
BEGIN
     OPEN cursorOut FOR
        WITH CategorySales AS (
            SELECT 
                c.id AS CategoryID,
                c.name AS CategoryName,
                sc.name AS SubCategoryName,
                ssc.name AS SubSubCategoryName,
                SUM(od.quantity) AS TotalQuantity
            FROM 
                store s
            INNER JOIN categorystore cs ON s.id = cs.idstore
            INNER JOIN category c ON cs.idcategory = c.id
            INNER JOIN subcategory sc ON sc.categoryid = c.id
            INNER JOIN subsubcategory ssc ON ssc.subcategoryid = sc.id
            INNER JOIN product p ON p.subsubcategoryid = ssc.id  -- Relaciona sub-subcategoría con producto
            INNER JOIN orderdetail od ON p.id = od.productid
            INNER JOIN orderheader oh ON oh.id = od.orderid
              WHERE 
                s.id = pstoreid
                AND to_char(oh.orderdate,'MM') = pmonth and to_char(oh.orderdate,'YYYY') = pyear
                AND oh.orderstatus = 3 
            GROUP BY 
                c.id, c.name, sc.name, ssc.name
        ) 
        SELECT 
            CategoryName || ', ' || SubCategoryName || ', ' || SubSubCategoryName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM CategorySales), 2) AS Percentage
        FROM 
            CategorySales
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETMONTH;

PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETYEAR (
  pstoreid IN NUMBER,
  pyear IN VARCHAR2,
  cursorOut OUT REPFIN_CURSOR_REPORTFINANCE
) AS
BEGIN
    OPEN cursorOut FOR
        WITH CategorySales AS (
            SELECT 
                c.id AS CategoryID,
                c.name AS CategoryName,
                sc.name AS SubCategoryName,
                ssc.name AS SubSubCategoryName,
                SUM(od.quantity) AS TotalQuantity
            FROM 
                store s
            INNER JOIN categorystore cs ON s.id = cs.idstore
            INNER JOIN category c ON cs.idcategory = c.id
            INNER JOIN subcategory sc ON sc.categoryid = c.id
            INNER JOIN subsubcategory ssc ON ssc.subcategoryid = sc.id
            INNER JOIN product p ON p.subsubcategoryid = ssc.id  -- Relaciona sub-subcategoría con producto
            INNER JOIN orderdetail od ON p.id = od.productid
            INNER JOIN orderheader oh ON oh.id = od.orderid
            WHERE 
                s.id = pstoreid
                AND TO_CHAR(oh.orderdate, 'YYYY') = pyear
                AND oh.orderstatus = 3 
            GROUP BY 
                c.id, c.name, sc.name, ssc.name
        ) 
        SELECT 
            CategoryName || ', ' || SubCategoryName || ', ' || SubSubCategoryName AS name,
            TotalQuantity AS quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM CategorySales), 2) AS Percentage
        FROM 
            CategorySales
        ORDER BY 
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETYEAR;

PROCEDURE REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETRANGE (
 pstoreid IN NUMBER,
 pdatestart IN VARCHAR2,
 pdateend IN VARCHAR2,
 cursorOut OUT REPFIN_CURSOR_REPORTFINANCE 
) AS 
BEGIN
    OPEN cursorOut FOR
        WITH CategorySales AS (
                 SELECT 
                c.id AS CategoryID,
                c.name AS CategoryName,
                sc.name AS SubCategoryName,
                ssc.name AS SubSubCategoryName,
                SUM(od.quantity) AS TotalQuantity
            FROM 
                store s
            INNER JOIN categorystore cs ON s.id = cs.idstore
            INNER JOIN category c ON cs.idcategory = c.id
            INNER JOIN subcategory sc ON sc.categoryid = c.id
            INNER JOIN subsubcategory ssc ON ssc.subcategoryid = sc.id
            INNER JOIN product p ON p.subsubcategoryid = ssc.id  -- Relaciona sub-subcategoría con producto
            INNER JOIN orderdetail od ON p.id = od.productid
            INNER JOIN orderheader oh ON oh.id = od.orderid
            WHERE 
                s.id = pstoreid
                AND to_char(oh.orderdate,'YYYY-MM-DD') >= pdatestart and  to_char(oh.orderdate,'YYYY-MM-DD') <= pdateend
                AND oh.orderstatus = 3 
            GROUP BY 
                c.id, c.name, sc.name, ssc.name
        ) 
        SELECT 
             CategoryName || ', ' || SubCategoryName || ', ' || SubSubCategoryName AS name,
            TotalQuantity as quantity,
            ROUND((TotalQuantity * 100.0) / (SELECT SUM(TotalQuantity) FROM CategorySales), 2) AS Percentage
        FROM 
            CategorySales
        ORDER BY
            TotalQuantity DESC
        FETCH FIRST 5 ROWS ONLY;
END REPFIN_REPORTFINANCE_CATEGORY_BESTSELLER_GETRANGE;
PROCEDURE REPFIN_REPORTFINANCE_GETTOTAL_ENTREPRENEURS(ptypeprofile IN NUMBER, cursorOut OUT REPFIN_CURSOR_REPORTFINANCE)
  IS
  BEGIN
    OPEN cursorOut FOR
    select COUNT(*) as TotalEntrepreneurs from userperson WHERE ISVENDOR = ptypeprofile AND STATUSID = 1;
  END REPFIN_REPORTFINANCE_GETTOTAL_ENTREPRENEURS;
end PKG_REPORT_FINANCE;
/