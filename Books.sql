Create database Bookstore
CREATE TABLE Authors( 
Author_Id INT NOT NULL IDENTITY(1,1)
			CONSTRAINT pk_Author PRIMARY KEY,
Name varchar(100)
);

CREATE TABLE Books (
Book_Id INT NOT NULL IDENTITY (1,1)
		CONSTRAINT pk_Books PRIMARY KEY,
		Author_Id INT
				CONSTRAINT fk_Books_Author_Id FOREIGN KEY
											REFERENCES Authors(Author_Id)
		,Name varchar(100)
		);

	INSERT INTO Authors VALUES
	('Itzik Ben-Gan'),
	('Grant Fritchey'),
	('Kellyn Pot"Vin-Gorman');

	INSERT INTO Books VALUES 
	(1,'T-SQL Fundamentals'),
	(1,'T-SQL Window Functions')
	,(2,'SQL Server 2017 Query Performance Tuning')
	,(2,'SQL Server Query Performance Tuning')
	,(3,'Crushing the IT Gender Bias');

	SELECT * FROM Authors
	SELECT * FROM Books
	-- Lỗi hay gặp INSERT INTO Books VALUES(3) 
	INSERT INTO Books VALUES (3)
	INSERT INTO Books (Author_Id) VALUES (3)
	INSERT INTO Books(Author_Id) VALUES(33)

	-- UPDATE
	UPDATE Books SET Name = 'SQL-SERVER' WHERE Book_Id = 1;

	-- DELETE
	DELETE FROM Books WHERE Author_Id = 2;
	DELETE FROM Books WHERE Author_Id = 3;
	DELETE FROM Authors WHERE Name = 'Grant Fritchey';

	TRUNCATE TABLE AUTHORS;
	TRUNCATE TABLE BOOKS;