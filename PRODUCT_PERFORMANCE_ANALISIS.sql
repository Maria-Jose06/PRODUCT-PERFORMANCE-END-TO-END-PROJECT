CREATE TABLE `product_datas` (
  `Product_ID` text,
  `Product` text,
  `Category` text,
  `Sale_Price` decimal (10,2),
  `Cost_Price` decimal (10,2),
  `Brand` text,
  `Description` text,
  `Image_url` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO product_datas (
  `Product_ID`,
  `Product`,
  `Category`,
  `Cost_Price`,
  `Sale_Price`,
  `Brand`,
  `Description`,
  `Image_url`
)
SELECT
  `Product ID`,
  `Product`,
  `Category`,
  CAST(REPLACE(REPLACE(`Cost Price`, '$', ''), ',', '') AS DECIMAL(10,2)),
  CAST(REPLACE(REPLACE(`Sale Price`, '$', ''), ',', '') AS DECIMAL(10,2)),
  `Brand`,
  `Description`,
  `Image url`
FROM product_data;

CREATE TABLE `product_saless` (
  `Date` date,
  `Customer_Type` text,
  `Country` text,
  `Product` text,
  `Discount_Band` text,
  `Units_Sold` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO product_saless (
  `Date`,
  `Customer_Type`,
  `Country`,
  `Product`,
  `Discount_Band`,
  `Units_Sold`
)
SELECT
  STR_TO_DATE(`Date`, '%e/%c/%Y') AS `Date`,
  `Customer Type`,
  `Country`,
  `Product`,
  `Discount Band`,
  `Units Sold`
FROM product_sales;

CREATE TABLE `discount_datas` (
  `Month` text,
  `Discount_Band` text,
  `Discount` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO discount_datas
(`Month`,
`Discount_Band`,
`Discount`)
SELECT 
`Month`,
CONCAT(UPPER(LEFT(TRIM(`Discount Band`), 1)), LOWER(SUBSTRING(TRIM(`Discount Band`), 2))) AS `Discount_Band`,
`Discount`
FROM discount_data;

SELECT *
FROM product_datas;

SELECT *
FROM product_saless;

SELECT *
FROM discount_datas;

WITH cte_a AS 
(
SELECT 
da.Product,
da.Category,
da.Brand,
da.`Description`,
da.Sale_Price,
da.Cost_Price,
da.Image_url,
sa.`Date`,
sa.Customer_Type,
sa.Discount_Band,
sa.Units_Sold,
(Sale_Price*Units_Sold) AS revenue,
(Cost_Price*Units_Sold) AS total_cost,
monthname(date) AS 'month',
year(date) AS 'year'
FROM product_datas AS da
JOIN product_saless AS sa
	ON da.Product_ID=sa.Product)

SELECT *,
(1- Discount*1.0/100)*revenue AS discount_revenue
FROM cte_a AS ct
JOIN discount_datas	AS di
	ON TRIM(ct.Discount_Band)=di.Discount_Band
    AND ct.`Month`=di.`Month`;







