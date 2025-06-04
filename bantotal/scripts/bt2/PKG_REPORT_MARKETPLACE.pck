create or replace PACKAGE USRECOSISTEMAS.PKG_REPORT_MARKETPLACE IS 

type RPM_CURSOR IS REF CURSOR;

PROCEDURE REPORT_PRODUCT_ANALYSIS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER, 
    p_product_name IN VARCHAR2,  -- Nuevo parámetro para búsqueda por nombre
    p_page IN NUMBER,           
    p_records_per_page IN NUMBER, 
    cursorOut OUT RPM_CURSOR
);
PROCEDURE REPORT_TOP_5_BEST_SELLING_PRODUCTS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER, 
    cursorOut OUT RPM_CURSOR
);
PROCEDURE REPORT_TOP_5_CATEGORY_SALES(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER, 
    cursorOut OUT RPM_CURSOR
);
PROCEDURE REPORT_PRODUCT_VISIT_STATS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER,
    cursorOut OUT RPM_CURSOR
);
PROCEDURE REPORT_TOP_VISIT_HOURS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER,
    cursorOut OUT RPM_CURSOR
);
PROCEDURE REPORT_PRODUCT_VISITS_SALES_STATS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER,
    p_product_name IN VARCHAR2,
    p_page IN NUMBER,           
    p_records_per_page IN NUMBER, 
    cursorOut OUT RPM_CURSOR
);
PROCEDURE REPORT_SALES_EVOLUTION_BY_YEAR(
    p_year IN NUMBER,
    p_store_id IN NUMBER,
    cursorOut OUT RPM_CURSOR
);
PROCEDURE REPORT_SALES_DETAIL_BY_YEAR(
    p_year IN NUMBER,
    p_store_id IN NUMBER,
    cursorOut OUT RPM_CURSOR
);
PROCEDURE REPORT_VISIT_HISTORY(
    p_store_id IN NUMBER,
    p_product_id IN NUMBER DEFAULT NULL,
    p_category_id IN NUMBER DEFAULT NULL,
    p_subcategory_id IN NUMBER DEFAULT NULL,
    p_subsubcategory_id IN NUMBER DEFAULT NULL,
    cursorOut OUT RPM_CURSOR
);
END PKG_REPORT_MARKETPLACE;
/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_REPORT_MARKETPLACE AS

PROCEDURE REPORT_PRODUCT_ANALYSIS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER, 
    p_product_name IN VARCHAR2,  -- Nuevo parámetro para búsqueda por nombre
    p_page IN NUMBER,           
    p_records_per_page IN NUMBER, 
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    SELECT *
    FROM (
        SELECT 
            p.id AS ProductId,
            p.name AS ProductName,
            od.unitprice AS UnitPrice,
            SUM(od.quantity) AS TotalQuantity,
            COUNT(DISTINCT oh.id) AS TotalOrders,
            SUM(od.unitprice * od.quantity) AS Total,
            -- Obtener la primera imagen del producto
            (SELECT MIN(pdi.imageurl)
             FROM productdetail pd
             INNER JOIN productdetailimage pdi ON pd.id = pdi.productdetailid
             WHERE pd.productid = p.id
            ) AS ProductImage,
            ROW_NUMBER() OVER (ORDER BY SUM(od.unitprice * od.quantity) DESC) AS NroRow,
            COUNT(*) OVER() AS TotalRow
        FROM 
            product p
        INNER JOIN 
            storeproduct sp ON p.id = sp.productid 
        INNER JOIN 
            orderdetail od ON p.id = od.productid
        INNER JOIN 
            orderheader oh ON od.orderid = oh.id
        WHERE 
            oh.orderstatus = 3
            AND trunc(oh.orderdate) BETWEEN p_start_date AND p_end_date 
            AND sp.storeid = p_store_id 
            AND (p_product_name IS NULL OR lower(p.name) LIKE '%' || lower(p_product_name) || '%') -- Filtro por nombre de producto
        GROUP BY 
            p.id, p.name, od.unitprice
    ) 
    WHERE NroRow BETWEEN ((p_page - 1) * p_records_per_page) + 1 
                      AND (p_page * p_records_per_page)
    ORDER BY NroRow;
END REPORT_PRODUCT_ANALYSIS;
PROCEDURE REPORT_TOP_5_BEST_SELLING_PRODUCTS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER, 
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    WITH TopProducts AS (
        -- Obtener el TOP 5 de productos más vendidos en el rango de fechas y tienda
        SELECT 
            p.name AS ProductName,
            SUM(od.quantity) AS TotalQuantity
        FROM product p
        INNER JOIN storeproduct sp ON p.id = sp.productid
        INNER JOIN orderdetail od ON p.id = od.productid
        INNER JOIN orderheader oh ON od.orderid = oh.id
        WHERE oh.orderstatus = 3 
        AND trunc(oh.orderdate) BETWEEN p_start_date AND p_end_date -- Filtrar por fechas
        AND sp.storeid = p_store_id -- Filtrar por tienda
        GROUP BY p.name
        ORDER BY SUM(od.quantity) DESC
        FETCH FIRST 5 ROWS ONLY
    ), TotalTopSales AS (
        -- Calcular la suma total de unidades vendidas en el TOP 5
        SELECT SUM(TotalQuantity) AS TotalUnits FROM TopProducts
    )
    SELECT 
        tp.ProductName as Label,
        tp.TotalQuantity as Quantity,
        -- Calcular el porcentaje respecto al total del TOP 5
        ROUND((tp.TotalQuantity / NULLIF(tts.TotalUnits, 0)) * 100, 2) AS Value, 
        CASE 
            WHEN RANK() OVER (ORDER BY tp.TotalQuantity DESC, tp.ProductName) = 1 THEN '#3361E4' -- Azul
            WHEN RANK() OVER (ORDER BY tp.TotalQuantity DESC, tp.ProductName) = 2 THEN '#2DC653' -- Verde
            WHEN RANK() OVER (ORDER BY tp.TotalQuantity DESC, tp.ProductName) = 3 THEN '#FBBF24' -- Amarillo
            WHEN RANK() OVER (ORDER BY tp.TotalQuantity DESC, tp.ProductName) = 4 THEN '#FF776C' -- Rojo
            WHEN RANK() OVER (ORDER BY tp.TotalQuantity DESC, tp.ProductName) = 5 THEN '#01D9DA' -- Celeste
        END AS Color
    FROM TopProducts tp
    CROSS JOIN TotalTopSales tts
    ORDER BY tp.TotalQuantity DESC;
END REPORT_TOP_5_BEST_SELLING_PRODUCTS;
PROCEDURE REPORT_TOP_5_CATEGORY_SALES(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER, 
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    WITH CategorySales AS (
        -- Obtener el total de ventas por categoría en el rango de fechas y tienda
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
        INNER JOIN product p ON p.subsubcategoryid = ssc.id
        INNER JOIN storeproduct sp ON p.id = sp.productid -- Validar que el producto esté en la tienda
        INNER JOIN orderdetail od ON p.id = od.productid
        INNER JOIN orderheader oh ON oh.id = od.orderid
        WHERE 
            s.id = p_store_id -- Filtrar por tienda
            AND sp.storeid = p_store_id -- Asegurar que el producto pertenece a la tienda
            AND trunc(oh.orderdate) BETWEEN p_start_date AND p_end_date -- Filtrar por rango de fechas
            AND oh.orderstatus = 3 -- Solo pedidos confirmados
        GROUP BY 
            c.id, c.name, sc.name, ssc.name
    ), TotalCategorySales AS (
        -- Calcular el total de unidades vendidas en el TOP 5
        SELECT SUM(TotalQuantity) AS TotalUnits FROM CategorySales
    )
    SELECT 
        CategoryName || ', ' || SubCategoryName || ', ' || SubSubCategoryName AS Label,
        TotalQuantity AS Quantity,
        ROUND((TotalQuantity * 100.0) / NULLIF((SELECT TotalUnits FROM TotalCategorySales), 0), 2) AS Value,
        CASE 
             WHEN RANK() OVER (ORDER BY TotalQuantity DESC,CategoryName) = 1 THEN '#3361E4' -- Azul
            WHEN RANK() OVER (ORDER BY TotalQuantity DESC,CategoryName) = 2 THEN '#2DC653' -- Verde
            WHEN RANK() OVER (ORDER BY TotalQuantity DESC,CategoryName) = 3 THEN '#FBBF24' -- Amarillo
            WHEN RANK() OVER (ORDER BY TotalQuantity DESC,CategoryName) = 4 THEN '#FF776C' -- Rojo
            WHEN RANK() OVER (ORDER BY TotalQuantity DESC,CategoryName) = 5 THEN '#01D9DA' -- Celeste
        END AS Color
    FROM 
        CategorySales
    ORDER BY 
        TotalQuantity DESC
    FETCH FIRST 5 ROWS ONLY;
END REPORT_TOP_5_CATEGORY_SALES;

PROCEDURE REPORT_PRODUCT_VISIT_STATS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER,
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    SELECT 
        -- Total de visitas en la tienda y rango de fechas
        (SELECT NVL(SUM(mh.countvisits), 0) -- Manejo de NULL para evitar datos vacíos
         FROM myhistoryproduct mh
         INNER JOIN product p ON mh.productid = p.id
         INNER JOIN storeproduct sp ON p.id = sp.productid -- Cambio a LEFT JOIN
         WHERE mh.visitdate BETWEEN p_start_date AND p_end_date
         AND (sp.storeid = p_store_id OR sp.storeid IS NULL)) AS TotalViews, 

        -- Vistas de productos (type = 1)
        (SELECT NVL(SUM(mh.countvisits), 0)
         FROM myhistoryproduct mh
         INNER JOIN product p ON mh.productid = p.id
         INNER JOIN storeproduct sp ON p.id = sp.productid
         WHERE p.type = 1 
         AND mh.visitdate BETWEEN p_start_date AND p_end_date
         AND (sp.storeid = p_store_id OR sp.storeid IS NULL)) AS ProductViews,

        -- Vistas de servicios (type = 2)
        (SELECT NVL(SUM(mh.countvisits), 0)
         FROM myhistoryproduct mh
         INNER JOIN product p ON mh.productid = p.id
         INNER JOIN storeproduct sp ON p.id = sp.productid
         WHERE p.type = 2 
         AND mh.visitdate BETWEEN p_start_date AND p_end_date
         AND (sp.storeid = p_store_id OR sp.storeid IS NULL)) AS ServiceViews
    FROM DUAL;
END REPORT_PRODUCT_VISIT_STATS;
PROCEDURE REPORT_TOP_VISIT_HOURS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER, 
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    WITH Hours AS (
        -- Generar las horas de 9:00 AM a 8:00 PM sin el 0 delante
        SELECT LEVEL + 8 AS Hour24
        FROM DUAL
        CONNECT BY LEVEL <= 12
    )
    SELECT 
        TO_CHAR(TO_DATE(h.Hour24, 'HH24'), 'FMHH AM') AS VisitHour, -- Formato "9 AM", "10 PM" sin 0 delante
        COALESCE(SUM(mh.countvisits), 0) AS TotalVisits -- Si no hay visitas, mostrar 0
    FROM Hours h
    LEFT JOIN (
        SELECT mh.countvisits, TO_NUMBER(TO_CHAR(mh.visitdate, 'HH24')) AS VisitHour
        FROM myhistoryproduct mh
        INNER JOIN product p ON mh.productid = p.id
        INNER JOIN storeproduct sp ON p.id = sp.productid
        WHERE mh.visitdate BETWEEN p_start_date AND p_end_date
        AND sp.storeid = p_store_id
    ) mh ON h.Hour24 = mh.VisitHour -- Asegura que todas las horas aparezcan
    GROUP BY h.Hour24
    ORDER BY h.Hour24;
END REPORT_TOP_VISIT_HOURS;
PROCEDURE REPORT_PRODUCT_VISITS_SALES_STATS(
    p_start_date IN DATE, 
    p_end_date IN DATE, 
    p_store_id IN NUMBER,
    p_product_name IN VARCHAR2,
    p_page IN NUMBER,           
    p_records_per_page IN NUMBER, 
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    WITH ProductBase AS (
        -- Obtener los productos de la tienda con su imagen
        SELECT 
            p.id AS ProductId,
            p.name AS ProductName,
            (SELECT MIN(pdi.imageurl)
             FROM productdetail pd
             INNER JOIN productdetailimage pdi ON pd.id = pdi.productdetailid
             WHERE pd.productid = p.id) AS ProductImage
        FROM product p
        INNER JOIN storeproduct sp ON p.id = sp.productid
        WHERE sp.storeid = p_store_id
        AND (p_product_name IS NULL OR lower(p.name) LIKE '%' || lower(p_product_name) || '%')
    ), SalesData AS (
        -- Obtener el total de ventas por producto
        SELECT 
            od.productid,
            SUM(od.quantity) AS TotalSales
        FROM orderdetail od
        INNER JOIN orderheader oh ON od.orderid = oh.id
        WHERE oh.orderstatus = 3
        AND trunc(oh.orderdate) BETWEEN p_start_date AND p_end_date
        GROUP BY od.productid
    ), VisitData AS (
        -- Obtener el total de visitas por producto
        SELECT 
            mh.productid,
            SUM(mh.countvisits) AS TotalVisits
        FROM myhistoryproduct mh
        WHERE trunc(mh.visitdate) BETWEEN p_start_date AND p_end_date
        GROUP BY mh.productid
    )
    SELECT * FROM (
        SELECT 
            pb.ProductImage,
            pb.ProductName,
            COALESCE(sd.TotalSales, 0) AS TotalSales, -- Asegura que muestre 0 si no hay ventas
            COALESCE(vd.TotalVisits, 0) AS TotalVisits, -- Asegura que muestre 0 si no hay visitas
            CASE 
                WHEN COALESCE(vd.TotalVisits, 0) = 0 THEN 0
                ELSE ROUND((COALESCE(sd.TotalSales, 0) / vd.TotalVisits) * 100, 2) 
            END AS ConversionRate, -- Tasa de conversión sin sobrestimación
            ROW_NUMBER() OVER (ORDER BY COALESCE(sd.TotalSales, 0) DESC) AS NroRow,
            COUNT(*) OVER() AS TotalRow
        FROM ProductBase pb
        LEFT JOIN SalesData sd ON pb.ProductId = sd.productid
        LEFT JOIN VisitData vd ON pb.ProductId = vd.productid
        ORDER BY COALESCE(sd.TotalSales, 0) DESC -- Ordenar por ventas correctamente
    ) 
    WHERE NroRow BETWEEN ((p_page - 1) * p_records_per_page) + 1 
                      AND (p_page * p_records_per_page);
END REPORT_PRODUCT_VISITS_SALES_STATS;


PROCEDURE REPORT_SALES_EVOLUTION_BY_YEAR(
    p_year IN NUMBER,
    p_store_id IN NUMBER,
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    WITH Months AS (
        -- Generar los meses de enero (1) a diciembre (12)
        SELECT LEVEL AS MonthNumber
        FROM DUAL
        CONNECT BY LEVEL <= 12
    ), SalesData AS (
        -- Obtener la suma de ventas por mes en la tienda y año especificados
        SELECT 
            EXTRACT(MONTH FROM oh.orderdate) AS MonthNumber,
            SUM(od.unitprice * od.quantity) AS TotalSales
        FROM orderheader oh
        INNER JOIN orderdetail od ON oh.id = od.orderid
        INNER JOIN storeproduct sp ON od.productid = sp.productid
        WHERE EXTRACT(YEAR FROM oh.orderdate) = p_year
        AND oh.orderstatus = 3 -- Solo pedidos confirmados
        AND sp.storeid = p_store_id -- Filtrar por tienda
        GROUP BY EXTRACT(MONTH FROM oh.orderdate)
    )
    SELECT 
        TO_CHAR(TO_DATE(m.MonthNumber, 'MM'), 'Month', 'NLS_DATE_LANGUAGE=SPANISH') AS MonthName, -- Nombre completo del mes
        TO_CHAR(TO_DATE(m.MonthNumber, 'MM'), 'Mon', 'NLS_DATE_LANGUAGE=SPANISH') AS MonthShort, -- Mes abreviado (Ej: Ene, Feb)
        COALESCE(sd.TotalSales, 0) AS TotalSales -- Si no hay ventas, mostrar 0
    FROM Months m
    LEFT JOIN SalesData sd ON m.MonthNumber = sd.MonthNumber
    ORDER BY m.MonthNumber;
END REPORT_SALES_EVOLUTION_BY_YEAR;

PROCEDURE REPORT_SALES_DETAIL_BY_YEAR(
    p_year IN NUMBER,
    p_store_id IN NUMBER,
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    WITH Months AS (
        -- Generar los meses de enero (1) a diciembre (12)
        SELECT LEVEL AS MonthNumber
        FROM DUAL
        CONNECT BY LEVEL <= 12
    ), SalesData AS (
        -- Obtener la suma de ventas, unidades vendidas y total de órdenes por mes en la tienda y año especificados
        SELECT 
            EXTRACT(MONTH FROM oh.orderdate) AS MonthNumber,
            SUM(od.unitprice * od.quantity) AS TotalSales,
            SUM(od.quantity) AS TotalUnitsSold,
            COUNT(DISTINCT oh.id) AS TotalOrders
        FROM orderheader oh
        INNER JOIN orderdetail od ON oh.id = od.orderid
        INNER JOIN storeproduct sp ON od.productid = sp.productid
        WHERE EXTRACT(YEAR FROM oh.orderdate) = p_year
        AND oh.orderstatus = 3 -- Solo pedidos confirmados
        AND sp.storeid = p_store_id -- Filtrar por tienda
        GROUP BY EXTRACT(MONTH FROM oh.orderdate)
    )
    SELECT 
        TO_CHAR(TO_DATE(m.MonthNumber, 'MM'), 'Month', 'NLS_DATE_LANGUAGE=SPANISH') AS MonthName, -- Nombre completo del mes
        COALESCE(sd.TotalSales, 0) AS TotalSales, -- Si no hay ventas, mostrar 0
        COALESCE(sd.TotalUnitsSold, 0) AS TotalUnitsSold, -- Si no hay unidades vendidas, mostrar 0
        COALESCE(sd.TotalOrders, 0) AS TotalOrders -- Si no hay órdenes, mostrar 0
    FROM Months m
    LEFT JOIN SalesData sd ON m.MonthNumber = sd.MonthNumber
    ORDER BY m.MonthNumber;
END REPORT_SALES_DETAIL_BY_YEAR;


PROCEDURE REPORT_VISIT_HISTORY(
    p_store_id IN NUMBER,
    p_product_id IN NUMBER DEFAULT NULL,
    p_category_id IN NUMBER DEFAULT NULL,
    p_subcategory_id IN NUMBER DEFAULT NULL,
    p_subsubcategory_id IN NUMBER DEFAULT NULL,
    cursorOut OUT RPM_CURSOR
)
IS
BEGIN
    OPEN cursorOut FOR
    WITH Months AS (
        -- Generar los meses de enero (1) a diciembre (12)
        SELECT LEVEL AS MonthNumber
        FROM DUAL
        CONNECT BY LEVEL <= 12
    ), FilteredProducts AS (
        -- Obtener los productos filtrados por categoría, subcategoría o subsubcategoría
        SELECT DISTINCT p.id AS ProductId
        FROM product p
        INNER JOIN storeproduct sp ON p.id = sp.productid
        LEFT JOIN category c ON p.categoryid = c.id
        LEFT JOIN subcategory sc ON c.id = sc.categoryid
        LEFT JOIN subsubcategory ssc ON p.subsubcategoryid = ssc.id
        WHERE sp.storeid = p_store_id
            AND (p_product_id IS NULL OR p.id = p_product_id) -- Producto específico
            AND (p_category_id IS NULL OR c.id = p_category_id) -- Categoría
            AND (p_subcategory_id IS NULL OR sc.id = p_subcategory_id) -- Subcategoría
            AND (p_subsubcategory_id IS NULL OR ssc.id = p_subsubcategory_id) -- Subsubcategoría
    ), VisitData AS (
        -- Obtener visitas por mes aplicando los filtros correctamente
        SELECT 
            EXTRACT(MONTH FROM mh.visitdate) AS MonthNumber,
            SUM(mh.countvisits) AS TotalVisits
        FROM myhistoryproduct mh
        INNER JOIN product p ON mh.productid = p.id
        INNER JOIN storeproduct sp ON p.id = sp.productid
        WHERE sp.storeid = p_store_id
            AND EXISTS (SELECT 1 FROM FilteredProducts fp WHERE fp.ProductId = p.id) -- Aplicar filtros
        GROUP BY EXTRACT(MONTH FROM mh.visitdate)
    ), SalesData AS (
        -- Obtener ventas por mes aplicando los filtros correctamente
        SELECT 
            EXTRACT(MONTH FROM oh.orderdate) AS MonthNumber,
            SUM(od.quantity) AS TotalSales
        FROM orderdetail od
        INNER JOIN orderheader oh ON od.orderid = oh.id
            AND oh.orderstatus = 3
        INNER JOIN product p ON od.productid = p.id
        INNER JOIN storeproduct sp ON p.id = sp.productid
        WHERE sp.storeid = p_store_id
            AND EXISTS (SELECT 1 FROM FilteredProducts fp WHERE fp.ProductId = p.id) -- Aplicar filtros
        GROUP BY EXTRACT(MONTH FROM oh.orderdate)
    )
    SELECT 
        TO_CHAR(TO_DATE(m.MonthNumber, 'MM'), 'Month', 'NLS_DATE_LANGUAGE=SPANISH') AS MonthName, -- Nombre completo del mes
        TO_CHAR(TO_DATE(m.MonthNumber, 'MM'), 'Mon', 'NLS_DATE_LANGUAGE=SPANISH') AS MonthShort, -- Mes abreviado (Ene, Feb)
        COALESCE(vd.TotalVisits, 0) AS TotalVisits, -- Si no hay visitas, mostrar 0
        COALESCE(sd.TotalSales, 0) AS TotalSales, -- Si no hay ventas, mostrar 0
        CASE 
            WHEN COALESCE(vd.TotalVisits, 0) = 0 THEN 0
            ELSE ROUND((COALESCE(sd.TotalSales, 0) / NULLIF(vd.TotalVisits, 0)) * 100, 2) 
        END AS ConversionRate -- Tasa de conversión
    FROM Months m
    LEFT JOIN VisitData vd ON m.MonthNumber = vd.MonthNumber
    LEFT JOIN SalesData sd ON m.MonthNumber = sd.MonthNumber
    ORDER BY m.MonthNumber;
END REPORT_VISIT_HISTORY;

END PKG_REPORT_MARKETPLACE;
/