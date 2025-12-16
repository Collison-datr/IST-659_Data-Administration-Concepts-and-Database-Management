
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
END

EXEC p_upsert_major @major_code= CSC, @major_name = 'Computer Science' -- exec to call/ run stored procedure
EXEC p_upsert_major @major_code= FIN, @major_name = 'Finance' -- exec to call/ run stored procedure
SELECT * FROM majors

--Question 2

DROP FUNCTION IF EXISTS f_concat
GO
CREATE FUNCTION f_concat (  
    @a VARCHAR(50),
    @b VARCHAR(50),
    @sep CHAR(1)
) 
RETURNS VARCHAR(101) 
AS
BEGIN
    RETURN @a + @sep + @b
END
GO

SELECT * FROM students
DROP view if EXISTS v_students 
GO
CREATE VIEW v_students as 
    SELECT student_id, dbo.f_concat(student_firstname, student_lastname, ' ') as firstname_first, dbo.f_concat(student_lastname, student_firstname, ', ') as lastname_first, 
        student_gpa as GPA, student_major_id,  major_name as Major
    FROM students 
        JOIN majors on student_major_id = major_id
GO
SELECT * FROM v_students


--Question 3
SELECT * FROM majors
SELECT * FROM majors CROSS APPLY string_split(major_name, ' ') 

DROP FUNCTION IF EXISTS f_search_majors
GO
CREATE FUNCTION f_search_majors ( -- create the above view as atable valued function instead
    @major_code CHAR(3)
)
RETURNS TABLE AS
    RETURN SELECT * FROM majors CROSS APPLY string_split(major_name, ' ') WHERE [value] = 'Science' 
GO
SELECT * FROM dbo.f_search_majors(1)


--Question 4
SELECT * FROM students
--4a
ALTER TABLE students
ADD student_active CHAR(1) DEFAULT 'Y' NOT NULL,
    student_inactive_date DATE NULL;
--4b
DROP TRIGGER IF EXISTS t_students_active
GO
CREATE TRIGGER t_students_active  --create trigger for employees table whenever there is an update to employee_department
ON students
AFTER INSERT, UPDATE
AS BEGIN
    UPDATE students
    SET student_active = CASE 
                            WHEN student_inactive_date IS NOT NULL 
                            THEN 'N'
                            ELSE 'Y'
                        END 
    FROM students
END

-- 4c
UPDATE students
SET student_inactive_date = '2020-08-01'
WHERE student_year_name = 'Graduate';

SELECT * FROM students WHERE student_year_name = 'Graduate';

--4d
UPDATE students
SET student_inactive_date = NULL
WHERE student_year_name = 'Graduate';

SELECT * FROM students WHERE student_year_name = 'Graduate';

