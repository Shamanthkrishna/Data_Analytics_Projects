-- 1) Top 10 highest Revenue generating products

SELECT
    product_id,          -- Product ID
    SUM(sale_price) AS sales  -- Total sales for the product
FROM
    df_orders  -- Table containing order data
GROUP BY
    product_id  -- Grouping by product ID to aggregate sales
ORDER BY
    sales DESC  -- Ordering by total sales in descending order
LIMIT 10;  -- Limiting the output to the top 10 products



-- 2) Top 5 highest Selling products in each region

-- Common Table Expression (CTE) to calculate total sales by region and product
WITH cte AS (
    SELECT
        region,                       -- Region
        product_id,                   -- Product ID
        SUM(sale_price) AS sales     -- Total sales for the product in the region
    FROM
        df_orders                     -- Table containing order data
    GROUP BY
        region, product_id            -- Grouping by region and product ID to aggregate sales
)
-- Selecting rows from the CTE with row numbers partitioned by region and ordered by sales descending
SELECT * FROM (
    SELECT
        cte.*,                                           -- Selecting all columns from CTE
        ROW_NUMBER() OVER(PARTITION BY cte.region        -- Calculating row number partitioned by region
                          ORDER BY cte.sales DESC) AS rn  -- Ordering by sales descending within each region
    FROM
        cte                                               -- CTE used in the subquery
) AS ranked
WHERE
    rn <= 5;  -- Filtering to include only the top 5 products by sales in each region


-- 3)Find month over month growth comparison  for 2022 and 2023 sales eg:  Jan 2022 vs Jan 2023

-- Common Table Expression (CTE) to calculate sales aggregated by year and month
WITH cte AS (
    SELECT 
        YEAR(order_date) AS order_year,  -- Extract year from order_date
        MONTH(order_date) AS order_month,  -- Extract month from order_date
        SUM(sale_price) AS sales  -- Calculate total sales for each year-month combination
    FROM 
        df_orders
    GROUP BY 
        YEAR(order_date), MONTH(order_date)  -- Group by year and month
)

-- Main query to pivot sales data for years 2022 and 2023
SELECT  
    order_month,  -- Display the month
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,  -- Calculate sales for 2022
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023  -- Calculate sales for 2023
FROM 
    cte
GROUP BY 
    order_month  -- Group by month to summarize sales for each month
ORDER BY 
    order_month;  -- Order the results by month
    
    

-- 4) For each category which month had highest sales?
WITH cte AS (
    -- CTE to calculate sales per category per formatted order date and assign row numbers
    SELECT 
        DATE_FORMAT(order_date, '%Y%m%d') AS order_year_month,  -- Format order_date as 'YYYYMMDD'
        category,  -- Group by category
        SUM(sale_price) AS sales,  -- Calculate total sales per category and order date
        ROW_NUMBER() OVER(PARTITION BY category ORDER BY SUM(sale_price) DESC) AS rn  -- Assign row numbers within each category based on descending sales
    FROM 
        df_orders  -- Source table
    GROUP BY 
        category, DATE_FORMAT(order_date, '%Y%m%d')  -- Group by category and formatted order date
)

-- Main query to select results from the CTE
SELECT 
    cte.*  -- Select all columns from the CTE
FROM 
    cte  -- Source CTE
WHERE 
    rn = 1  -- Filter to include only rows where rn (row number) is 1, indicating highest sales for each category
ORDER BY 
    category, sales DESC;  -- Order the results by category and descending sales to show highest sales first


-- 5) Which Sub Category had highest growth profit in 2023 compared to 2022

-- CTE to calculate sales per sub_category per year and compare sales between 2022 and 2023
WITH cte AS (
    SELECT 
        sub_category,  -- Group by sub_category
        YEAR(order_date) AS order_year,  -- Extract year from order_date
        SUM(sale_price) AS sales  -- Calculate total sales per sub_category and year
    FROM 
        df_orders  -- Source table
    GROUP BY 
        sub_category, YEAR(order_date)  -- Group by sub_category and year
),
-- CTE to aggregate sales for 2022 and 2023 and calculate the difference
cte2 AS (
    SELECT 
        sub_category,
        SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,  -- Total sales in 2022
        SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023  -- Total sales in 2023
    FROM 
        cte  -- Source CTE
    GROUP BY 
        sub_category  -- Group by sub_category
)
-- Main query to select results from cte2, showing the sub_category with the highest growth in profit from 2022 to 2023
SELECT 
    *, 
    (sales_2023 - sales_2022) AS profit_growth  -- Calculate the difference in sales between 2023 and 2022
FROM 
    cte2  -- Source CTE
ORDER BY 
    profit_growth DESC  -- Order by profit_growth in descending order to find the highest growth
LIMIT 1;  -- Limit the result to the top 1 row
