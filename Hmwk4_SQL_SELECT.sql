-- Homework Problem Set 4
USE vbay
GO

-- Query 1: Collectables
SELECT * FROM vb_items

SELECT * FROM vb_items WHERE item_type = 'Collectables'

SELECT item_name, item_type, item_reserve, item_soldamount FROM vb_items WHERE item_type = 'Collectables'

SELECT item_name, item_type, item_reserve, item_soldamount FROM vb_items WHERE item_type = 'Collectables' ORDER BY item_name

-- Query 2: Sellers of Antiques
SELECT * FROM vb_items
SELECT * FROM vb_users
SELECT * FROM vb_zip_codes
SELECT * FROM vb_bids

SELECT * FROM vb_items JOIN vb_users on  item_seller_user_id = user_id

SELECT * FROM vb_items JOIN vb_users on  item_seller_user_id = user_id WHERE item_type = 'Antiques'

SELECT user_email, user_firstname, user_lastname, item_type, item_name 
FROM vb_items JOIN vb_users on  item_seller_user_id = user_id WHERE item_type = 'Antiques'

-- Query 3: Seller’s Report
SELECT * FROM vb_items
SELECT * FROM vb_users

SELECT * FROM vb_items as i 
JOIN vb_users as s on s.user_id = i.item_seller_user_id 
JOIN vb_users as b on b.user_id = i.item_buyer_user_id 

SELECT * FROM vb_items as i 
LEFT JOIN vb_users as s on i.item_seller_user_id  = s.user_id
LEFT JOIN vb_users as b on i.item_buyer_user_id  = b.user_id  
WHERE i.item_sold = 1

SELECT s.user_email as sellers_email, b.user_email as buyers_email, i.item_soldamount - i.item_reserve as item_margin, i.*
FROM vb_items as i 
LEFT JOIN vb_users as s on i.item_seller_user_id  = s.user_id
LEFT JOIN vb_users as b on i.item_buyer_user_id  = b.user_id  
WHERE i.item_sold = 1

SELECT s.user_email as sellers_email, b.user_email as buyers_email, i.item_soldamount - i.item_reserve as item_margin, i.*
FROM vb_items as i 
LEFT JOIN vb_users as s on i.item_seller_user_id  = s.user_id
LEFT JOIN vb_users as b on i.item_buyer_user_id  = b.user_id  
WHERE i.item_sold = 1
ORDER BY item_margin DESC

--Question 1
SELECT * FROM vb_users
WHERE user_zip_code like '13%'

--Question 2
SELECT * FROM vb_users JOIN vb_zip_codes on user_zip_code = zip_code
WHERE zip_state = 'NY'

--Question 3
SELECT item_id, item_name, item_type, item_reserve FROM vb_items WHERE item_reserve > 250 and item_sold = 0


--Question 4
SELECT item_id, item_name, item_type, item_reserve, 
    CASE
        WHEN item_reserve >= 250 THEN 'High Priced'
        WHEN item_reserve <= 50 THEN 'Low Priced'
        ELSE 'Average Priced'
    END AS price_category
FROM vb_items 
WHERE item_type != 'All Other' and item_reserve > 250 and item_sold = 0

--Question 5
SELECT * FROM vb_bids WHERE bid_status = 'ok' ORDER BY bid_datetime


--Question 6
SELECT bid_datetime, user_id, user_email, user_firstname, user_lastname, bid_item_id, item_name FROM vb_bids 
JOIN vb_users on bid_user_id = user_id
JOIN vb_items on bid_item_id = item_id
WHERE bid_status != 'ok' 

--Question 7
SELECT DISTINCT item_id, item_name, item_type, item_seller_user_id, item_reserve, user_firstname, user_lastname
FROM vb_items
LEFT JOIN vb_bids ON vb_items.item_id = vb_bids.bid_item_id
JOIN vb_users on item_seller_user_id = user_id
WHERE vb_bids.bid_item_id IS NULL

--Question 8

SELECT ratr.rating_for_user_id + '-' + sl.user_id as [Seller_ID], sl.user_firstname + '-' + sl.user_lastname as [Seller_full_name], 
    ratr.rating_by_user_id + '-' + rt.user_id as [Rater_ID], rt.user_firstname + '-' + rt.user_lastname as [Rater_full_name]  
FROM vb_user_ratings as ratr
JOIN vb_users as sl on ratr.rating_for_user_id  = sl.user_id
JOIN vb_users as rt on ratr.rating_by_user_id  = rt.user_id

--Question 9

SELECT item_name, item_reserve, item_sold, item_seller_user_id, sl.user_firstname + '-' + sl.user_lastname as [Seller_full_name], zps.zip_city + ' ' + zps.zip_state as [Seller_City_ST],
    item_buyer_user_id, buy.user_firstname + '-' + buy.user_lastname as [Buyer_full_name], zpb.zip_city + ' ' + zpb.zip_state as [Buyer_City_ST]
FROM vb_items
JOIN vb_users as sl on item_seller_user_id  = sl.user_id
JOIN vb_users as buy on item_buyer_user_id  = buy.user_id

JOIN vb_zip_codes zps on sl.user_zip_code  = zps.zip_code
JOIN vb_zip_codes as zpb on buy.user_zip_code  = zpb.zip_code

WHERE item_sold = 1

--Question 10
SELECT * FROM vb_users
LEFT JOIN vb_items on user_id = item_seller_user_id 
LEFT JOIN vb_bids on user_id = bid_user_id 
WHERE item_seller_user_id IS NULL and bid_user_id IS NULL

