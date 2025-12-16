USE tinyu
GO

SELECT * FROM majors

--Question 1

DROP PROCEDURE IF EXISTS p_upsert_major
GO
CREATE PROCEDURE p_upsert_major ( 
    @major_code CHAR(3),
    @major_name VARCHAR(100) -- this procedure will have 2 arguments employee_id and department
) as BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
        IF EXISTS (SELECT * FROM majors WHERE major_code = @major_code)
        BEGIN
            UPDATE majors
            SET major_name = @major_name
            WHERE major_code = @major_code;
        END
        ELSE
        BEGIN
            DECLARE @major_id INT;
            SELECT @major_id = (MAX(major_id)) + 1 FROM majors;
            INSERT INTO majors (major_id, major_code, major_name)
            VALUES (@major_id, @major_code, @major_name);
        END
        COMMIT
        END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW
    END CATCH
END

--Question 2
EXEC p_upsert_major @major_code= CSC, @major_name = 'Computer Science' -- exec to call/ run stored procedure

--Question 3
USE vbay
GO

DROP PROCEDURE IF EXISTS p_place_bid
GO
create procedure p_place_bid
(	@bid_item_id INT,
	@bid_user_id int,
	@bid_amount money
) AS 
    BEGIN TRANSACTION
    BEGIN TRY
        declare @max_bid_amount money
        declare @item_seller_user_id int
        declare @bid_status varchar(20)
        
        -- be optimistic :-)
        set @bid_status = 'ok'
        
        -- TODO: 5.5.1 set @max_bid_amount to the higest bid amount for that item id 
        set @max_bid_amount = (select max(bid_amount) from vb_bids where bid_item_id=@bid_item_id and bid_status='ok') 
        
        -- TODO: 5.5.2 set @item_seller_user_id to the seller_user_id for the item id
        set @item_seller_user_id = (select item_seller_user_id from vb_items where item_id=@bid_item_id) 

        -- TODO: 5.5.3 if no bids then set the @max_bid_amount to the item_reserve amount for the item_id
        if (@max_bid_amount is null) 
            set @max_bid_amount = (select item_reserve from vb_items where item_id=@bid_item_id) 
        
        -- if you're the item seller, set bid status
        if ( @item_seller_user_id = @bid_user_id)
            set @bid_status = 'item_seller'
        
        -- if the current bid lower or equal to the last bid, set bid status
        if ( @bid_amount <= @max_bid_amount)
            set @bid_status = 'low_bid'
            
        -- TODO: 5.5.4 insert the bid at this point and return the bid_id 		
        insert into vb_bids (bid_user_id, bid_item_id, bid_amount, bid_status)
            values (@bid_user_id, @bid_item_id, @bid_amount, @bid_status)
        return  @@identity 
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW
    END CATCH
    COMMIT
END


--Question 4
EXEC p_place_bid @bid_item_id= 36, @bid_user_id = 2, @bid_amount = 100  -- exec to call/ run stored procedure


--Question 5

DROP PROCEDURE IF EXISTS [dbo].[p_rate_user]
GO
create procedure [dbo].[p_rate_user]
(
	@rating_by_user_id int,
	@rating_for_user_id int,
	@rating_astype varchar(20),
	@rating_value int,
	@rating_comment text 
)
as
begin
BEGIN TRANSACTION
    BEGIN TRY
    -- TODO: 5.3
	insert into vb_user_ratings (rating_by_user_id, rating_for_user_id, rating_astype, rating_value,rating_comment)
	values (@rating_by_user_id, @rating_for_user_id, @rating_astype, @rating_value, @rating_comment)
	
	return @@identity 

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW
    END CATCH
    COMMIT
END
GO

-- Question 6
EXEC p_rate_user @rating_by_user_id= 2, @rating_for_user_id = 2, @rating_astype = 'star', @rating_value = 4, @rating_comment ='good' -- exec to call/ run stored procedure


-- Question 7

USE tinyu
GO
SELECT * FROM students

DROP TRIGGER IF EXISTS students_in_major
GO
CREATE TRIGGER students_in_major --create trigger for employees table whenever there is an insert, delete or update 
ON students 
AFTER INSERT, UPDATE, DELETE
AS BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE (
            SELECT COUNT(*)
            FROM students s
            WHERE s.student_major_id = i.student_major_id
        ) > 15
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('Major cannot have more than 15 students.', 16, 1);
        RETURN;
END
END;

-- Question 8

UPDATE students
SET student_major_id = 2
WHERE student_firstname = 'Robin';

SELECT * FROM students WHERE student_year_name = 'Graduate';
