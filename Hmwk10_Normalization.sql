USE cheepwebhosting 
GO

use demo
GO

--Question 1
drop table if exists fudgenbooks
GO
create table fudgenbooks
(
    isbn varchar(20) not null,
    title varchar(50) not null,
    price money,
    author1 varchar(20) not null,
    author2 varchar(20) null,
    author3 varchar(20) null, 
    subjects varchar(100) not null,
    pages int not null,
    pub_no int not null,
    pub_name varchar(50) not null,
    pub_website varchar(50) not null,
    constraint pk_fudgenbooks_isbn primary key (isbn)
)
GO
insert into fudgenbooks VALUES
('372317842','Introduction to Money Laundering', 29.95,'Mandafort', 'Made-Off', NULL, 'scams,money laundering',367,101,'Rypoff','http://www.rypoffpublishing.com'),
('472325845','Imbezzle Like a Pro',34.95,'Made-Off','Moneesgon', NULL,'imbezzle,scams',670,101,'Rypoff','http://www.rypoffpublishing.com'),
('535621977','The Internet Scammer''s Bible',44.95, 'Screwm', 'Sucka', NULL, 'phising,id theft,scams',944,102, 'BS Press','http://www.bspress.com/books'),
('635619239','Art of the Ponzi Scheme', 39.95, 'Dewey','Screwm','Howe','scams,ponzi',450,102,'BS Press','http://www.bspress.com/books')

GO
select * from fudgenbooks

--1.1
SELECT isbn, title, price, pages, pub_no, pub_name, pub_website FROM fudgenbooks

DROP TABLE IF EXISTS fudgenbooks_1nf
GO

SELECT isbn, title, price, pages, pub_no, pub_name, pub_website 
    INTO fudgenbooks_1nf
    FROM fudgenbooks
GO

ALTER TABLE fudgenbooks_1nf ADD CONSTRAINT pk_fudgenbooks_1nf PRIMARY KEY (isbn)
GO

SELECT * FROM fudgenbooks_1nf
GO

--1.2 
SELECT author1 AS author_name FROM fudgenbooks WHERE author1 IS NOT NULL 
    UNION
SELECT author2 FROM fudgenbooks WHERE author2 IS NOT NULL 
    UNION
SELECT author3 FROM fudgenbooks WHERE author3 IS NOT NULL 

DROP TABLE IF EXISTS fb_authors
GO
SELECT a.author_name
    INTO fb_authors
FROM (
    SELECT author1 AS author_name FROM fudgenbooks WHERE author1 IS NOT NULL 
        UNION
    SELECT author2 FROM fudgenbooks WHERE author2 IS NOT NULL 
        UNION
    SELECT author3 FROM fudgenbooks WHERE author3 IS NOT NULL 
) AS a
GO

ALTER TABLE fb_authors ALTER COLUMN author_name VARCHAR(20) NOT NULL 
GO
ALTER TABLE fb_authors ADD CONSTRAINT pk_fb_authors PRIMARY KEY (author_name)
GO
SELECT * FROM fb_authors

--1.3
SELECT isbn, author_name
FROM fudgenbooks unpivot (
    author_name FOR author_column IN (author1, author2, author3) 
) AS upvt

DROP TABLE IF EXISTS fb_book_authors
GO
SELECT isbn, author_name
    INTO fb_book_authors
    FROM fudgenbooks unpivot (
        author_name FOR author_column IN (author1, author2, author3) 
    ) AS upvt
GO

ALTER TABLE fb_book_authors ALTER COLUMN author_name VARCHAR(20) NOT NULL 
GO
ALTER TABLE fb_book_authors ADD CONSTRAINT pk_fb_book_authors PRIMARY KEY (isbn, author_name)
GO
SELECT * FROM fb_book_authors

--1.4
SELECT DISTINCT VALUE AS topic FROM fudgenbooks CROSS APPLY string_split(subjects, ',')

DROP TABLE IF EXISTS fb_subjects
GO
SELECT DISTINCT VALUE as topic
    INTO fb_subjects
    FROM fudgenbooks CROSS APPLY string_split(subjects, ',')
GO

ALTER TABLE fb_subjects ALTER COLUMN topic VARCHAR(20) NOT NULL 
GO
ALTER TABLE fb_subjects ADD CONSTRAINT pk_fb_subjects PRIMARY KEY (topic)
GO
SELECT * FROM fb_subjects

--1.5
SELECT isbn, VALUE AS topic FROM fudgenbooks CROSS APPLY string_split(subjects, ',')

DROP TABLE IF EXISTS fb_book_subjects
GO
SELECT isbn, VALUE as topic
    INTO fb_book_subjects
    FROM fudgenbooks CROSS APPLY string_split(subjects, ',')
GO

ALTER TABLE fb_book_subjects ALTER COLUMN topic VARCHAR(20) NOT NULL 
GO
ALTER TABLE fb_book_subjects ADD CONSTRAINT pk_fb_book_subjects PRIMARY KEY (isbn, topic)
GO
SELECT * FROM fb_book_subjects

--3.1
SELECT isbn, title, price, pages, pub_no FROM fudgenbooks_1nf

DROP TABLE IF EXISTS fb_books
GO
SELECT isbn, title, price, pages, pub_no
    INTO fb_books
    FROM fudgenbooks_1nf
GO

ALTER TABLE fb_books ALTER COLUMN title VARCHAR(120) NOT NULL 
GO
ALTER TABLE fb_books ADD CONSTRAINT pk_fb_books PRIMARY KEY (isbn)
GO
SELECT * FROM fb_books

--3.2
SELECT DISTINCT pub_no, pub_name, pub_website FROM fudgenbooks_1nf

DROP TABLE IF EXISTS fb_publishers
GO
SELECT DISTINCT pub_no, pub_name, pub_website
    INTO fb_publishers
    FROM fudgenbooks_1nf
GO

ALTER TABLE fb_publishers ALTER COLUMN pub_no INT NOT NULL 
GO
ALTER TABLE fb_publishers ADD CONSTRAINT pk_fb_publishers PRIMARY KEY (pub_no)
GO
SELECT * FROM fb_publishers

--Question 2
--4
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'fb_%'

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_books_pub_no')
    ALTER TABLE fb_books DROP fk_books_pub_no
ALTER TABLE fb_books ADD CONSTRAINT fk_books_pub_no FOREIGN KEY (pub_no) REFERENCES fb_publishers(pub_no)


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_book_subjects_subject')
    ALTER TABLE fb_book_subjects DROP fk_book_subjects_subject
ALTER TABLE fb_book_subjects ADD CONSTRAINT fk_book_subjects_subject FOREIGN KEY (topic) REFERENCES fb_subjects(topic)


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_book_subjects_isbn')
    ALTER TABLE fb_book_subjects DROP fk_book_subjects_isbn
ALTER TABLE fb_book_subjects ADD CONSTRAINT fk_book_subjects_isbn FOREIGN KEY (isbn) REFERENCES fb_books(isbn)


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_book_authors_author_name')
    ALTER TABLE fb_book_authors DROP fk_book_authors_author_name
ALTER TABLE fb_book_authors ADD CONSTRAINT fk_book_authors_author_name FOREIGN KEY (author_name) REFERENCES fb_authors(author_name)


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_book_authors_isbn')
    ALTER TABLE fb_book_authors DROP fk_book_authors_isbn
ALTER TABLE fb_book_authors ADD CONSTRAINT fk_book_authors_isbn FOREIGN KEY (isbn) REFERENCES fb_books(isbn)


--create database xyz
go 
use demo
go
drop table if exists xyz_consulting
go
create table xyz_consulting
(
    project_id int not null,
    project_name varchar(50) not null,
    employee_id int not null,
    employee_name varchar(50) not null,
    rate_category char(1) not null,
    rate_amount money not null,
    billable_hours int not null,
    total_billed money not null,
    constraint pk_xyz_consulting primary key(project_id, employee_id)
)
insert into xyz_consulting values 
(1023,	'Madagascar travel site',	11,	'Carol Ling',	'A',	 60.00, 	5,	 300.00 ),
(1023,	'Madagascar travel site',	12,	'Chip Atooth',	'B',	 50.00, 	10,	 500.00 ),
(1023,	'Madagascar travel site',	16,	'Charlie Horse',	'C',	 40.00, 	2,	 80.00), 
(1056,	'Online estate agency',	11,	'Carol Ling',	'D',	 90.00, 	5,	 450.00 ),
(1056,	'Online estate agency',	17,	'Avi Maria',	'B',	 50.00, 	2,	 100.00 ),
(1099,	'Open travel network',	11,	'Carol Ling',	'A',	 60.00, 	6,	 360.00 ),
(1099,	'Open travel network',	12,	'Chip Atooth',	'C',	 40.00, 	8,	 320.00 ),
(1099,	'Open travel network',	14,	'Arnie Hurtz',	'D',	 90.00, 	3,	 270.00 )
GO

SELECT * FROM xyz_consulting

select distinct project_id, project_name from xyz_consulting order by project_name


--Question 3 1nf projects
DROP TABLE IF EXISTS xyz_consulting_projects
GO

select distinct project_id, project_name
    INTO xyz_consulting_projects
    from xyz_consulting
GO

ALTER TABLE xyz_consulting_projects ADD CONSTRAINT pk_xyz_consulting_projects PRIMARY KEY (project_id)
GO

SELECT * FROM xyz_consulting_projects
GO


--Employees
DROP TABLE IF EXISTS xyz_consulting_employees
GO

select distinct employee_id, employee_name
    INTO xyz_consulting_employees
    from xyz_consulting
GO

ALTER TABLE xyz_consulting_employees ADD CONSTRAINT pk_xyz_consulting_employees PRIMARY KEY (employee_id)
GO

SELECT * FROM xyz_consulting_employees
GO

--Rates
DROP TABLE IF EXISTS xyz_consulting_rates
GO

select distinct rate_category, rate_amount
    INTO xyz_consulting_rates
    from xyz_consulting
GO

ALTER TABLE xyz_consulting_rates ADD CONSTRAINT pk_xyz_consulting_rates PRIMARY KEY (rate_category)
GO

SELECT * FROM xyz_consulting_rates
GO

--Billable hours
DROP TABLE IF EXISTS xyz_consulting_billable
GO

select distinct project_id, employee_id, rate_category, billable_hours, total_billed 
    INTO xyz_consulting_billable
    from xyz_consulting
GO

ALTER TABLE xyz_consulting_billable ADD CONSTRAINT pk_xyz_consulting_billable PRIMARY KEY (project_id, employee_id, rate_category)
GO

SELECT * FROM xyz_consulting_billable
GO


--Question 6
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'xyz_consulting_%'

--Question 7
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_billable_employee')
    ALTER TABLE xyz_consulting_billable DROP fk_billable_employee
ALTER TABLE xyz_consulting_billable ADD CONSTRAINT fk_billable_project FOREIGN KEY (project_id) REFERENCES xyz_consulting_projects(project_id)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_billable_employee')
    ALTER TABLE xyz_consulting_billable DROP fk_billable_employee
ALTER TABLE xyz_consulting_billable ADD CONSTRAINT fk_billable_employee FOREIGN KEY (employee_id) REFERENCES xyz_consulting_employees(employee_id)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_billable_rate')
    ALTER TABLE xyz_consulting_billable DROP fk_billable_rate
ALTER TABLE xyz_consulting_billable ADD CONSTRAINT fk_billable_rate FOREIGN KEY (rate_category) REFERENCES xyz_consulting_rates(rate_category)








