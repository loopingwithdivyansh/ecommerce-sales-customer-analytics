--1. Order Status Distribution
SELECT order_status, COUNT(*) AS order_count
FROM dbo.ecommerce_sales
GROUP BY order_status
ORDER BY order_count DESC;

-- 2. Net Sales by Sales Channel
SELECT
    sales_channel,
    SUM(net_sales) AS total_net_sales
FROM dbo.ecommerce_sales
GROUP BY sales_channel
ORDER BY total_net_sales DESC;

-- 3. Profit by Sales Channel
Select sales_channel, sum(profit) as total_profit 
From dbo.ecommerce_sales
Group By sales_channel
Order By total_profit DESC;

-- 4. Net Sales by Customer Segment
Select customer_segment, sum(net_sales) as total_net_sales
From dbo.ecommerce_sales
Group By customer_segment
Order By total_net_sales Desc;

-- 5. Overall Sales Performance
Select count(*) as total_orders, sum(net_sales) as total_net_sales, avg(net_sales) as avg_order_value
From dbo.ecommerce_sales;

-- 6. Monthly Net Sales Trend
Select year(order_date) as sales_year, month(order_date) as sales_month, sum(net_sales) as total_net_sales
From dbo.ecommerce_sales
Group By year(order_date), Month(order_date)
Order By sales_year, sales_month;

-- 7. Yearly Net Sales Trend
Select year(order_date) as sales_year, sum(net_sales) as total_net_sales
From dbo.ecommerce_sales
Group By Year(order_date)
Order By sales_year;

-- 8. Year-over-Year Sales Growth
WITH YearlySales AS (
    SELECT
        YEAR(order_date) AS sales_year,
        SUM(net_sales) AS total_net_sales
    FROM dbo.ecommerce_sales
    GROUP BY YEAR(order_date)
)
SELECT
    sales_year,
    total_net_sales,
    LAG(total_net_sales) OVER (
        ORDER BY sales_year
    ) AS previous_year_sales,
    total_net_sales - LAG(total_net_sales) OVER (
        ORDER BY sales_year
    ) AS sales_difference,
    (
        total_net_sales - LAG(total_net_sales) OVER (
            ORDER BY sales_year
        )
    ) * 100.0 /
    NULLIF(
        LAG(total_net_sales) OVER (
            ORDER BY sales_year
        ), 0
    ) AS yoy_growth_percentage
FROM YearlySales
ORDER BY sales_year;

-- 9. Sales and Profit by Sales Channel
Select sales_channel, sum(net_sales) as total_net_sales, sum(profit) as total_profit
From dbo.ecommerce_sales
Group By sales_channel
Order By total_net_sales DESC;

-- 10. Return Rate by Sales Channel
SELECT
    sales_channel,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN order_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_status = 'Returned' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS return_rate_pct
FROM dbo.ecommerce_sales
GROUP BY sales_channel
ORDER BY return_rate_pct DESC;

-- 11. Profit and Margin by Customer Segment
Select customer_segment, sum(net_sales) as total_net_sales, sum(profit) as total_profit, round(100.0 * sum(profit) / nullif(sum(net_sales),0),2) As profit_margin_pct
FRom dbo.ecommerce_sales
group By customer_segment
order By total_profit desc;

-- 12. Average Delivery Time by Shipping Method
SELECT
    shipping_method,
    COUNT(*) AS completed_orders,
    AVG(CAST(delivery_days AS FLOAT)) AS avg_delivery_days,
    AVG(CAST(estimated_delivery_days AS FLOAT)) AS avg_estimated_days
FROM dbo.ecommerce_sales
WHERE order_status = 'Completed'
GROUP BY shipping_method
ORDER BY avg_delivery_days;

-- 13. Payment Method Performance
Select payment_method, count(*) as total_orders, sum(net_sales) as total_net_sales, sum(profit) as total_profit
From dbo.ecommerce_sales
Group By payment_method
Order By total_net_sales Desc;

-- 14. Marketing Channel Performance
Select marketing_channel, count(*) as total_orders, sum(net_sales) as total_net_sales, sum(profit) as total_profit
From dbo.ecommerce_sales
Group By marketing_channel
Order By total_net_sales desc;

-- 15. Sales by Region
Select region, count(*) as total_orders, sum(net_sales) as total_net_sales, sum(profit) as total_profit
From dbo.ecommerce_sales
Group By region
Order By total_net_sales desc;

-- 16. Order Status Analysis with Percentages
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM dbo.ecommerce_sales),
        2
    ) AS order_percentage
FROM dbo.ecommerce_sales
GROUP BY order_status
ORDER BY total_orders DESC;

-- 17. Monthly Order Trends
Select year(order_date) as sales_year,
       month(order_date) as sales_month,
       count(*) as total_orders
From dbo.ecommerce_sales
Group By year(order_date),
         month(order_date)
Order By sales_year, sales_month;

-- 18. Return Rate by Sales Channel (Rounded)
SELECT
    sales_channel,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN order_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_status = 'Returned' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS return_rate_pct
FROM dbo.ecommerce_sales
GROUP BY sales_channel
ORDER BY return_rate_pct DESC;

-- 19. Order Analysis by Customer Type
Select customer_type, count(*) as total_orders, sum(net_sales) as total_net_sales, sum(profit) as total_profit
From dbo.ecommerce_sales
Group By customer_type  
Order By total_net_sales DESC;       