-- ------------------------------------------------------------------
-- 0). First, How Many Rows are in the Products Table?
-- ------------------------------------------------------------------
SELECT COUNT(*) AS product_count FROM northwind.products; -- 45 rows

-- ------------------------------------------------------------------
-- 1). Product Name and Unit/Quantity
-- ------------------------------------------------------------------
SELECT product_name, quantity_per_unit 
FROM northwind.products;

-- ------------------------------------------------------------------
-- 2). Product ID and Name of Current Products
-- ------------------------------------------------------------------
SELECT id AS product_id, product_name
FROM northwind.products 
WHERE discontinued = 0;

-- ------------------------------------------------------------------
-- 3). Product ID and Name of Discontinued Products
-- ------------------------------------------------------------------
SELECT id AS product_id, product_name
FROM northwind.products WHERE discontinued != 0; -- no discontinued products

-- ------------------------------------------------------------------
-- 4). Name & List Price of Most & Least Expensive Products
-- ------------------------------------------------------------------
SELECT product_name, list_price 
FROM northwind.products
WHERE list_price IN (
	(SELECT MAX(list_price) FROM products), 
	(SELECT MIN(list_price) FROM products)
    );

-- ------------------------------------------------------------------
-- 5). Product ID, Name & List Price Costing Less Than $20
-- ------------------------------------------------------------------
SELECT id AS product_id, product_name, list_price
FROM northwind.products
WHERE list_price < 20.0;

-- ------------------------------------------------------------------
-- 6). Product ID, Name & List Price Costing Between $15 and $20
-- ------------------------------------------------------------------
SELECT id AS product_id, product_name, list_price
FROM products
WHERE list_price < 20.0 AND list_price > 15.0;

-- ------------------------------------------------------------------
-- 7). Product Name & List Price Costing Above Average List Price
-- ------------------------------------------------------------------
SELECT product_name, list_price
FROM northwind.products
WHERE list_price > 
	(SELECT AVG(list_price) FROM northwind.products);

-- ------------------------------------------------------------------
-- 8). Product Name & List Price of 10 Most Expensive Products 
-- ------------------------------------------------------------------
WITH MostExpensive AS  
(  
    SELECT product_name, list_price,  
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS row_num  
    FROM northwind.products  
)   
SELECT product_name, list_price  
FROM MostExpensive   
WHERE row_num <= 10;  

-- ------------------------------------------------------------------ 
-- 9). Count of Current and Discontinued Products 
-- ------------------------------------------------------------------
SELECT discontinued, COUNT(discontinued) AS count
FROM northwind.products
GROUP BY discontinued;

-- ------------------------------------------------------------------
-- 10). Product Name, Units on Order and Units in Stock
--      Where Quantity In-Stock is Less Than the Quantity On-Order. 
-- ------------------------------------------------------------------
WITH InStock AS (  
    SELECT p.id AS product_id, product_name, o.quantity AS quantity_on_order,
		i.quantity AS quantity_in_stock
	FROM northwind.products AS p
    LEFT OUTER JOIN northwind.order_details AS o
    ON p.id = o.product_id
    LEFT OUTER JOIN northwind.inventory_transactions as i
    ON o.product_id = i.product_id
)  
SELECT product_name, SUM(quantity_on_order) AS units_on_order, 
		SUM(quantity_in_stock) AS units_in_stock
FROM InStock
GROUP BY product_name
HAVING units_on_order > units_in_stock;

-- ------------------------------------------------------------------
-- EXTRA CREDIT -----------------------------------------------------
-- ------------------------------------------------------------------


-- ------------------------------------------------------------------
-- 11). Products with Supplier Company & Address Info
-- ------------------------------------------------------------------
WITH supplierInfo AS (
SELECT product_name, p.id AS product_id, s.company as supplier_company, s.address AS address 
FROM products AS p
LEFT OUTER JOIN purchase_order_details AS pd
ON p.id = pd.product_id
INNER JOIN purchase_orders AS o
ON pd.purchase_order_id = o.id
INNER JOIN suppliers AS s
ON o.supplier_id = s.id
)
SELECT product_name, supplier_company, address
FROM supplierInfo
WHERE address IS NOT NULL
GROUP BY product_name;
-- all addresses are null

-- ------------------------------------------------------------------
-- 12). Number of Products per Category With Less Than 5 Units
-- ------------------------------------------------------------------
SELECT COUNT(id) AS count, category
FROM northwind.products
GROUP BY category
HAVING count < 5;


-- ------------------------------------------------------------------
-- 13). Number of Products per Category Priced Less Than $20.00
-- ------------------------------------------------------------------
SELECT COUNT(id) AS count, category, list_price
FROM northwind.products
WHERE list_price < 20.0
GROUP BY category;