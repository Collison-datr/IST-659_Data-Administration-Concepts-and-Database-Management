-- Homework Problem Set 5

USE vbay
GO

--Question 1

SELECT
    item_type,
    COUNT(*) AS total_items,
    MIN(item_reserve) AS min_reserve_price,
    AVG(item_reserve) AS avg_reserve_price,
    MAX(item_reserve) AS max_reserve_price
FROM
    vb_items  
GROUP BY
    item_type
ORDER BY
    item_type;

--Question 2
SELECT
    item_name,
    item_type,
    item_reserve,
    MIN(item_reserve) OVER (PARTITION BY item_type) AS min_reserve_per_type,
    MAX(item_reserve) OVER (PARTITION BY item_type) AS max_reserve_per_type,
    AVG(item_reserve) OVER (PARTITION BY item_type) AS avg_reserve_per_type
FROM
    vb_items
WHERE
    item_type IN ('Antiques', 'Collectables')
ORDER BY
    item_type, item_name;

-- Question 3

SELECT
    rating_for_user_id, user_firstname + '-' + user_lastname as [Seller_full_name],
    COUNT(rating_for_user_id) AS total_ratings_per,
    AVG(CAST(rating_value as DECIMAL(10, 2))) AS avg_reserve_per_type
FROM vb_user_ratings  
JOIN vb_users on  rating_for_user_id = user_id
GROUP BY rating_for_user_id, user_firstname, user_lastname


--- Question 4
SELECT item_id, item_name, bid_counts.total_bids
FROM
    vb_items
JOIN (
    SELECT bid_item_id, COUNT(bid_item_id) AS total_bids FROM vb_bids GROUP BY bid_item_id HAVING COUNT(bid_item_id) > 1
) AS bid_counts ON item_id = bid_item_id
WHERE
    item_type = 'Collectables'
ORDER BY
    bid_counts.total_bids DESC, item_name;

--Question 5
SELECT item_id, item_name, item_type, bid_user_id, bid_amount, user_firstname + '-' + user_lastname as [Bidder_full_name]
FROM vb_items 
JOIN vb_bids ON item_id = bid_item_id 
JOIN vb_users on  bid_user_id = user_id
WHERE bid_item_id = 36


--Question 6
SELECT item_id, item_name, item_type, bid_user_id, bid_amount, user_firstname + '-' + user_lastname as [Bidder_full_name], bid_datetime,
    lead(bid_user_id) OVER (PARTITION BY item_id ORDER BY bid_datetime) as next_bidder
FROM vb_items 
JOIN vb_bids ON item_id = bid_item_id 
JOIN vb_users on  bid_user_id = user_id
WHERE bid_item_id = 36


-- Question 7
SELECT user_firstname, user_lastname, user_email, rating_by_user_id, rating_value, 
    AVG(CAST(rating_value as DECIMAL(10, 2))) AS avg_rating
FROM vb_users 
JOIN vb_user_ratings ON user_id = rating_by_user_id
WHERE rating_value < (SELECT AVG(rating_value) FROM vb_user_ratings)  
GROUP BY user_id, user_firstname, user_lastname, user_email, rating_by_user_id, rating_value
HAVING COUNT(rating_value) > 1;  



--Question 8
SELECT
    user_firstname,
    user_lastname,
    user_email,
    COUNT(bid_id) AS total_valid_bids, 
    COUNT(DISTINCT bid_item_id) AS total_items_bid_upon, 
    CAST(COUNT(bid_id) AS DECIMAL(10, 2)) / COUNT(DISTINCT bid_item_id) AS bids_per_item_ratio 
FROM vb_users 
JOIN vb_bids ON user_id = bid_user_id
WHERE bid_status = 'ok'
GROUP BY user_id, user_firstname, user_lastname, user_email

-- Question 9
SELECT  item_id, item_name, item_reserve, bid_user_id, user_email, user_firstname + '-' + user_lastname as [Bidder_full_name],
    (SELECT DISTINCT(MAX(bid_amount))) AS highest_bid
FROM vb_items
JOIN vb_bids on item_id = bid_item_id
JOIN vb_users on bid_user_id = user_id
WHERE item_sold = 0 
GROUP BY item_id, item_name, item_reserve, user_email, user_firstname, user_lastname, bid_amount, bid_user_id
HAVING bid_amount = MAX(bid_amount);



-- Question 10

SELECT
    rating_for_user_id, user_firstname + '-' + user_lastname as [Seller_full_name],
    COUNT(rating_for_user_id) AS total_ratings_per,
    AVG(CAST(rating_value as DECIMAL(10, 2))) AS avg_reserve_per_type,
    (SELECT AVG(CAST(rating_value AS DECIMAL(10, 2))) FROM vb_user_ratings) AS overall_avg_rating,
    AVG(CAST(rating_value AS DECIMAL(10, 2))) - (SELECT AVG(CAST(rating_value AS DECIMAL(10, 2))) FROM vb_user_ratings) AS diff_from_overall_avg 
FROM vb_user_ratings  
JOIN vb_users on  rating_for_user_id = user_id
GROUP BY rating_for_user_id, user_firstname, user_lastname