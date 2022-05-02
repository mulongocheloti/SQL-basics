CREATE DATABASE Class_8;
USE Class_8;

-- SHOW DATABASES;
-- DROP DATABASE Class_8;

CREATE TABLE Student ( RegNo INT NOT NULL,
			Stud_Name VARCHAR(20) NOT NULL unique,
			DateOfBirth DATE CHECK(DateOfBirth <= '2000-01-01' ), /* Date format is diff in t-sql and pl/sql. In T-SQL we can use /, JAN, etc */
			Residence CHAR(15) DEFAULT 'NAIROBI',
			PRIMARY KEY (RegNo) );

/* Alternatively you can add a primary key as done below:
ALTER TABLE Student
ADD CONSTRAINT PRIKEY PRIMARY KEY(RegNo);
*/

CREATE TABLE Results ( STUD_ID INT NOT NULL,
			MATHS INT CHECK (MATHS<=99 AND MATHS>0),
            LANGUAGES INT CHECK (LANGUAGES<=99 AND LANGUAGES>0),
            SCIENCE INT CHECK (SCIENCE<=99 AND SCIENCE>0),
            SOCIALST_RE INT CHECK (SOCIALST_RE<=99 AND SOCIALST_RE>0)
            );
            
ALTER TABLE Results ADD CONSTRAINT FKID FOREIGN KEY(STUD_ID) REFERENCES Student(RegNo);

DESC Student; DESCRIBE Results;

SELECT * FROM INFORMATION_SCHEMA.TABLES;
	-- Gets the list of all tables and views in all the databases within the RDBMS
	
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_SCHEMA='class_8';
	-- Gets the list of tables within the specified database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS;
	-- Gets all the columns for some object in all the databases within the RDBMS
            
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_DEFAULT, EXTRA FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Student';
	-- DESC Student; equivalent

-- Single ALTER statment to add two columns to your table, the first column needs a DEFAULT value,
-- the second column needs to be put in between your Third and Fourth column of the table   
ALTER TABLE Student
	ADD Home_Addr VARCHAR(20) DEFAULT 'New York',
    ADD Email VARCHAR(30) AFTER DateOfBirth;
    
DESC Student;

	-- VARCHAR() vs CHAR()??   MEMORY ALLOCATION
ALTER TABLE Student MODIFY Home_Addr CHAR(25) NOT NULL; 
-- In T-SQL we have ALTER TABLE.... ALTER COLUMN.....

-- Single ALTER statment to modify the name and datatype of two of your columns in your table
ALTER TABLE Student 
	CHANGE Home_Addr Permanent_Address VARCHAR(25),
    CHANGE Email Student_Email CHAR(30);
    
DESC Student;

ALTER TABLE Student
	DROP COLUMN Permanent_Address,
    DROP COLUMN Student_Email;
         
INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Residence)
	VALUES (811, 'PAUL MULONGO', '1999-06-21', 'BUNGOMA'),
            (819, 'LAURA MUTHEU','1999-09-19','KITUI'),
			(812, 'RANDOLPH KITILA', '1998-04-20','NAIROBI'),
			(814, 'MARY WANJIKU', '1997-03-24', 'THIKA'),
			(816, 'RONY WAIREGA', '1998-08-20', 'LIMURU'),
			(817, 'ELVIS ODUOR','1997-09-13','KISUMU'),
			(818, 'ALLAN PETER','1998-02-14','LIMURU');
            
INSERT INTO Student (RegNo, DateOfBirth, Stud_Name, Residence)
	VALUES  (813, '2000-02-01', 'BRIAN WAEMA', 'MAKINDU'),
            (815, '2001-05-01', 'BRIDGET MWENGA', 'MACHAKOS'),
            (820, '2000-08-08', 'SHARON GITOGO','THIKA');
            
	-- Error Code: 3819. Check constraint 'student_chk_1' is violated.
    -- Since DateOfBirth should be <= '2000-01-01'

ALTER TABLE Student DROP CONSTRAINT Student_chk_1;
    
/* CREATE UNIQUE INDEX index_stud ON student (regno,stud_name,residence);
describe student;
explain analyze select * from student where regno>816;
explain analyze table student;
alter table student drop index index_stud;
desc student; */

SELECT * FROM Student;

INSERT INTO Results (STUD_ID, LANGUAGES, SOCIALST_RE, MATHS, SCIENCE) VALUES (811, 60,68,58,94), (813, 60,45,80,58), (814, 77,70,68,88);

SELECT * FROM Results; SELECT * FROM Student;

-- Limiting responses using LIMIT and OFFSET
-- In T-SQL we use TOP number | percent Clause
-- In PL/SQL we use FETCH FIRST number | percent ROWS ONLY

SELECT * FROM Student
LIMIT 3;

SELECT * FROM Student
LIMIT 4 OFFSET 2; -- Equivalent to LIMIT 2, 4

SELECT * FROM Student LIMIT 2, 4;

SELECT * FROM Student LEFT JOIN Results ON Student.RegNo = Results.STUD_ID;

DELETE FROM Student WHERE RegNo = 811;
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails

-- SOLUTION 1: To delete from the parent table first delete its children in the child table
DELETE FROM Results WHERE STUD_ID = 811;
DELETE FROM Student WHERE RegNo = 811;

-- SOLUTION 2: We can use ON DELETE CASCADE when defining the FOREIGN KEY Constraint
	-- ALTER TABLE Results ADD CONSTRAINT FKID FOREIGN KEY(STUD_ID) REFERENCES Student(RegNo) ON DELETE CASCADE;
    
-- To find the affected table by ON DELETE CASCADE action
    /*  USE INFORMATION_SCHEMA;
        SELECT table_name FROM referential_constraints  
	    WHERE constraint_schema = 'database_name' AND referenced_table_name = 'parent_table' AND delete_rule = 'CASCADE';
	*/

CREATE VIEW Born_90s AS
	SELECT Stud_Name, Residence FROM Student
		WHERE year(DateOfBirth)<2000; 

SELECT * FROM Born_90s;

-- CASE Statements
SELECT Stud_Name, Residence,
	CASE
		WHEN Residence = 'NAIROBI' THEN 'In Nairobi'
		WHEN Residence IN ('THIKA', 'LIMURU', 'KITUI') THEN 'Within Outskirts of Nairobi'
		ELSE 'Upcountry'
	END AS Availability
	FROM Born_90s
	ORDER BY Stud_Name DESC;
    
DROP VIEW Born_90s;


CREATE VIEW Age_view AS SELECT Stud_Name, (YEAR(CURRENT_TIMESTAMP())-YEAR(DateOfBirth)) AS 'Age' FROM Student WHERE YEAR(DateOfBirth)<2000;
CREATE VIEW Age_view_1 AS SELECT Stud_Name, (YEAR(NOW())-YEAR(DateOfBirth)) AS 'Age' FROM Student WHERE YEAR(DateOfBirth)=2000;
CREATE VIEW Age_view_2 AS SELECT Stud_Name, (2022-YEAR(DateOfBirth)) AS 'Age' FROM Student WHERE YEAR(DateOfBirth)>2000;

SELECT * FROM Age_view; SELECT * FROM Age_view_1; SELECT * FROM Age_view_2;

DROP VIEW Age_view;

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS;
	-- Gets all the views

-- LIKE-- %(Any no. of characters) and _(a single character)

SELECT * FROM Student WHERE Stud_Name LIKE '%A';

SELECT * FROM Student WHERE Stud_Name LIKE 'R%';

SELECT * FROM Student WHERE Stud_Name LIKE '_a%';

DELETE FROM Student WHERE Residence LIKE 'ma%';
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails

-- Solution: Lets add ON DELETE CASCADE
-- YOU CAN'T ALTER CONSTRAINT BUT WE CAN DROP AND RECREATE
ALTER TABLE Results
	DROP CONSTRAINT FKID;
    
ALTER TABLE Results
	ADD CONSTRAINT FKID FOREIGN KEY(STUD_ID) REFERENCES Student(RegNo) ON DELETE CASCADE;


-- SQL is case insensitive

UPDATE Student SET Stud_Name='KITILA RANDO' WHERE RegNo=812;

DELETE FROM Student WHERE Stud_Name = 'LAURA MUTHEU';
SELECT * FROM class_8.Student;
DELETE FROM Student;
-- Deletes all records of the specified table

ALTER TABLE Student 
	CHANGE COLUMN Residence Town VARCHAR(25);
    
-- Changing column names has great effect on stored procedures, views and functions hence it is advised not to modify them once created

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth,Town)
	VALUES	(811, 'PAUL MULONGO', '1999-06-21', 'BUNGOMA'),
			(813, 'BRIAN WAEMA', '2000-02-01', 'MAKINDU'),
			(812, 'RANDOLPH KITILA', '1998-04-20','NAIROBI'),
			(814, 'MARY WANJIKU', '1997-03-24', 'THIKA'),
			(815, 'BRIDGET MWENGA', '2000-05-01', 'MACHAKOS'),
			(816, 'RONY WAIREGA', '1998-08-20', 'LIMURU'),
			(817, 'ELVIS ODUOR','1997-09-13','KISUMU'),
			(818, 'ALLAN PETER','1998-02-14','LIMURU'),
			(820, 'SHARON GITOGO','2000-08-08','THIKA'),
			(819, 'LAURA MUTHEU','1999-09-19','KITUI');

-- Adding the DEFAULT Constraint to already created table column
ALTER TABLE Student
	ALTER DateOfBirth SET DEFAULT '2000-01-01';
    
-- In T-SQL we write
	-- ADD CONSTRAINT <constraint_name> DEFAULT <default_value> FOR <cloumn_name>;
    
-- In PL/SQL we write
	-- MODIFY <column_name> DEFAULT <default_value>;

INSERT INTO Student(RegNo, Stud_Name)
	VALUES (822, 'ABEL BARASA');

SELECT * FROM Student;

ALTER TABLE student
	ALTER DateOfBirth DROP DEFAULT;

INSERT INTO Student(RegNo, Stud_Name, DateOfBirth)
	VALUES (823, 'RUTH MUSYOKA','2002-05-04');

SELECT * FROM Student;

SELECT Stud_Name, YEAR(CURRENT_DATE())-YEAR(DateOfBirth) AS 'Age' FROM Student;

-- Add a calculated column
ALTER TABLE Student
	ADD Age INT AS (2022-YEAR(DateOfBirth)) AFTER DateOfBirth;

ALTER TABLE Student 
	ADD Position INT NOT NULL,
    ADD Prize DECIMAL(10,2) NOT NULL;

/* ALTER TABLE only allows columns to be added that can contain nulls, or have a DEFAULT definition specified, or the column being added is an identity 
   or timestamp column, or alternatively if none of the previous conditions are satisfied the table must be empty to allow addition of this column.
*/

DELETE FROM Student;

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(811, 'PAUL MULONGO', '1999-06-21', 'BUNGOMA',1,5000),
			(813, 'BRIAN WAEMA', '2000-02-01', 'MAKINDU',3,3000),
			(812, 'RANDOLPH KITILA', '1998-04-20','NAIROBI',5,1500),
			(814, 'MARY WANJIKU', '1997-03-24', 'THIKA',7,800),
			(815, 'BRIDGET MWENGA', '2000-05-01', 'MACHAKOS',9,450),
			(816, 'RONY WAIREGA', '1998-08-20', 'LIMURU',2,4000),
			(817, 'ELVIS ODUOR','1997-09-13','KISUMU',4,2000),
			(818, 'ALLAN PETER','1998-02-14','LIMURU',6,1000),
			(820, 'SHARON GITOGO','2000-08-08','THIKA',8,650),
			(819, 'LAURA MUTHEU','1999-09-19','KITUI',10,200);

SELECT * FROM Student WHERE Prize>=1000 ORDER BY Position DESC;

ALTER TABLE Student	ADD CONSTRAINT UniqConstraints UNIQUE(Position, Prize);

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(824, 'PAULINE MUSENYA', '1998-06-11', 'WOTE',3,3000.00);

   -- Error Code: 1062. Duplicate entry '3-3000.00' for key 'student.UniqConstraints'

ALTER TABLE Student DROP CONSTRAINT UniqConstraints;

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(824, 'PAULINE MUSENYA', '1998-06-11', 'WOTE',3,3000.00);

SELECT * FROM Student;

SELECT COLUMN_NAME AS Field, COLUMN_TYPE AS Type, IS_NULLABLE AS `Null`, COLUMN_KEY AS `Key`, COLUMN_DEFAULT AS `Default`, EXTRA AS Extra FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME='Student' AND TABLE_SCHEMA='Class_8'
    ORDER BY ORDINAL_POSITION ASC;
-- equivalent to
DESC Student;

DELETE FROM Student;

ALTER TABLE Student	ADD CONSTRAINT Prize_limit CHECK(Prize>100);

-- The CHECK Constraint enables a condition to check the value being entered into a record. If the condition evaluates to false, the record violates the
-- constraint and it is not entered into the table.

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(825, 'PAULINE MUSENYA', '1998-06-11', 'WOTE',15,100.00);
    -- Error Code: 3819. Check constraint 'Prize_limit' is violated.

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(825, 'PAULINE MUSENYA', '1998-06-11', 'WOTE',15,100.01);

SELECT * FROM Student;

ALTER TABLE Student DROP CONSTRAINT Prize_limit;

INSERT INTO Student (RegNo, Stud_Name, DateOfBirth, Town, Position, Prize)
	VALUES	(811, 'PAUL MULONGO', '1999-06-21', 'BUNGOMA',1,5000),
			(813, 'BRIAN WAEMA', '2000-02-01', 'MAKINDU',3,3000),
			(812, 'RANDOLPH KITILA', '1998-04-20','NAIROBI',5,1500),
			(814, 'MARY WANJIKU', '1997-03-24', 'THIKA',7,800),
			(815, 'BRIDGET MWENGA', '2000-05-01', 'MACHAKOS',9,450),
			(816, 'RONY WAIREGA', '1998-08-20', 'LIMURU',2,4000),
			(817, 'ELVIS ODUOR','1997-09-13','KISUMU',4,2000),
			(818, 'ALLAN PETER','1998-02-14','LIMURU',6,1000),
			(820, 'SHARON GITOGO','2000-08-08','THIKA',8,650),
			(819, 'LAURA MUTHEU','1999-09-19','KITUI',10,200);

SELECT * FROM Student;

-- Understanding DATE_FORMAT()
SELECT DateOfBirth, DATE_FORMAT(DateOfBirth, '%m-%d-%Y') AS modifiedDate FROM student;
SELECT DateOfBirth, DATE_FORMAT(DateOfBirth, '%M-%y-%d') AS modifiedDate FROM student;
SELECT DateOfBirth, DATE_FORMAT(DateOfBirth, '%D %M, %Y') AS modifiedDate FROM student;

-- Joining two tables using primary key and foreign key
CREATE TABLE Sales	(ID INT NOT NULL,
					EID VARCHAR(20) NOT NULL,
					AGE INT NOT NULL,
					ADDRESS CHAR(25),
					PRIMARY KEY (ID));
-- AND
DROP TABLE ORDERS;
CREATE TABLE ORDERS	(Order_ID INT NOT NULL,
					CUST_ID INT,
					Order_Date DATE,
					QTY INT,
					PRICE INT,
                    FOREIGN KEY (CUST_ID) REFERENCES Sales(ID));

-- OR you can update the table orders after creation using ALTER TABLE and insert the FOREIGN KEY Constraint
ALTER TABLE ORDERS
	ADD CONSTRAINT Sales_FKID FOREIGN KEY(CUST_ID) REFERENCES SALES(ID) ON DELETE CASCADE;
    
/* 
CREATE table statement that has a PRIMARY KEY column and have that column auto generate a value on INSERT.
*/
CREATE TABLE testTable ( Number INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
						 Name VARCHAR(20) NOT NULL
                         );
  
  -- To change auto_increment use ALTER TABLE <tablename> AUTO_INCREMENT = 100
