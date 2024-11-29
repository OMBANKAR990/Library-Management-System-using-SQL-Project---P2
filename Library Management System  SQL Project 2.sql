-- Library System Management SQL Project

-- CREATE DATABASE PROJECT;

CREATE DATABASE PROJECT2;
USE PROJECT2;



-- Create table "Branch"
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);


SELECT * FROM MEMBERS;

-- BASIC LEVEL QUATIONS

-- TASK 1: Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO BOOKS 
VALUES 
('978-1-60129-456-2','To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


-- Task 2: Update an Existing Member's Address
SET SQL_SAFE_UPDATES =0;
UPDATE MEMBERS
SET MEMBER_ADDRESS = "125 Oak StR"
WHERE MEMBER_ID = 'C103';
SELECT * FROM MEMBERS;

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table
DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID ='IS121';
SELECT * FROM ISSUED_STATUS;

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'
SELECT *
FROM ISSUED_STATUS
WHERE ISSUED_EMP_ID = 'E101';
SELECT * FROM ISSUED_STATUS;

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book
SELECT ISSUED_EMP_ID, COUNT(ISSUED_BOOK_NAME) 
FROM ISSUED_STATUS
GROUP BY ISSUED_EMP_ID
HAVING COUNT(ISSUED_BOOK_NAME) > 1 ;

SELECT * FROM ISSUED_STATUS;

-- Task 6: Create Summary Tables: Used CTAS (Create Table As Select) to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;



-- Task 7. Retrieve All Books in a Specific Category:
select * 
from books
where category ='classic';

-- Task 8: Find Total Rental Income by Category

SELECT b.category,SUM(b.rental_price),COUNT(*)
FROM issued_status as i
JOIN books as b
ON b.isbn = i.issued_book_isbn
GROUP BY category;

-- Task 9:List Members Who Registered in the Last 180 Days:

SELECT *
FROM members
WHERE reg_date >= DATE_SUB(CURDATE(), INTERVAL 180 DAY);

-- Task 10:List Employees with Their Branch Manager's Name and their branch details:

SELECT e1.emp_id,e1.emp_name,e1.position,e1.salary,b.*,e2.emp_name as manager
FROM employees as e1
JOIN branch as b
ON e1.branch_id = b.branch_id    
JOIN employees as e2
ON e2.emp_id = b.manager_id;





