
use payroll
GO
SELECT * FROM employees

-- Question 1

SELECT employee_id, employee_firstname, employee_lastname, employee_jobtitle
FROM employees
WHERE employee_jobtitle = 'Store Manager' or employee_jobtitle = 'Owner'

CREATE INDEX ix_employees_jobtitle ON employees (employee_jobtitle)

--Question 2
SELECT employee_jobtitle, COUNT(employee_id) AS number_of_employees
FROM employees
WHERE employee_jobtitle IN ('Store Manager', 'Owner', 'Department Manager', 'Sales Associate')
GROUP BY employee_jobtitle;

use vbay
GO

--Question 3
SELECT item_id, item_name, DENSE_RANK() OVER (
    PARTITION BY item_name ORDER BY bid_datetime
    ) as bid_order,
    bid_amount, 
    LAG(user_firstname + ' ' + user_lastname) OVER (
        PARTITION BY item_name ORDER BY bid_datetime
    ) as prev_bidder,
    user_firstname + ' ' + user_lastname as bidder,
    LEAD(user_firstname + ' ' + user_lastname) OVER (
        PARTITION BY item_name ORDER BY bid_datetime) as next_bidder
    FROM vb_items
    JOIN vb_bids ON item_id = bid_item_id
    JOIN vb_users ON bid_user_id = user_id 
    WHERE bid_status = 'ok'

--Question 4
DROP INDEX IF EXISTS ix_vb_bids_status_item_datetime ON vb_bids
GO
CREATE NONCLUSTERED INDEX ix_vb_bids_status_item_datetime
ON vb_bids (bid_status, bid_item_id, bid_datetime)
INCLUDE (bid_amount, bid_user_id)

--Question 5

use fudgemart_v3
GO

 SELECT c.customer_state, c.customer_firstname + ' ' + c.customer_lastname as customer_name,
 DATEPART(year, order_date) as order_year, o.order_id, o.ship_via, od.order_qty as order_detail_qty, 
    od.order_qty * p.product_retail_price as order_detail_extd_price, p.product_id, p.product_name, p.product_department
 FROM fm_orders o
 JOIN fm_customers c on o.customer_id = c.customer_id
 JOIN fm_order_details od ON o.order_id =od.order_id
 JOIN fm_products p on p.product_id =od.product_id

DROP view IF EXISTS v_orders 
GO
CREATE VIEW v_orders
WITH SCHEMABINDING
AS
    SELECT 
        c.customer_state, 
        c.customer_firstname + ' ' + c.customer_lastname AS customer_name,
        DATEPART(year, o.order_date) AS order_year, 
        o.order_id, 
        o.ship_via, 
        od.order_qty AS order_detail_qty, 
        od.order_qty * p.product_retail_price AS order_detail_extd_price, 
        p.product_id, 
        p.product_name, 
        p.product_department
    FROM dbo.fm_orders o
    JOIN dbo.fm_customers c ON o.customer_id = c.customer_id
    JOIN dbo.fm_order_details od ON o.order_id = od.order_id
    JOIN dbo.fm_products p ON p.product_id = od.product_id;

SELECT * FROM v_orders

--Question 6

DROP INDEX IF EXISTS ix_v_orders ON dbo.v_orders
CREATE UNIQUE CLUSTERED INDEX ix_v_orders ON dbo.v_orders(order_id, product_id)

SELECT * FROM v_orders WITH (noexpand)


--Question 7

SELECT product_name, SUM(order_detail_qty)
FROM v_orders WITH (noexpand)
GROUP BY product_name

SELECT DISTINCT customer_name, product_department
FROM v_orders WITH (noexpand)

CREATE NONCLUSTERED COLUMNSTORE INDEX IX_v_orders_columnstore
ON dbo.v_orders (order_id, product_id, customer_state, order_year, ship_via, product_name, product_department);
