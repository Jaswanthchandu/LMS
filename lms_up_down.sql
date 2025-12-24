USE library_management
GO


-- DOWN

-- Drop child tables first
DROP TABLE IF EXISTS Fine_Payment;
DROP TABLE IF EXISTS Fine_Due;
DROP TABLE IF EXISTS Book_Issue;
DROP TABLE IF EXISTS Book_Request;
DROP TABLE IF EXISTS Book_Request_Status;
DROP TABLE IF EXISTS Member_Preference;
DROP TABLE IF EXISTS Member_Contact;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Member_Status;
DROP TABLE IF EXISTS Book_Tag;
DROP TABLE IF EXISTS Tag;
DROP TABLE IF EXISTS Book_Author;
DROP TABLE IF EXISTS Author_Award;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Book_Format;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Location_Service;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Publisher;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Library_Staff;
GO


--UP – METADATA


CREATE TABLE Category (
    category_id INT IDENTITY PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);
GO

CREATE TABLE Publisher (
    publisher_id INT IDENTITY PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL,
    publication_language VARCHAR(100),
    publication_type VARCHAR(100)
);
GO

CREATE TABLE Location (
    location_id INT IDENTITY PRIMARY KEY,
    shelf_no VARCHAR(50),
    shelf_name VARCHAR(255),
    floor_no INT
);
GO

CREATE TABLE Location_Service (
    location_id INT,
    service_name VARCHAR(255),
    PRIMARY KEY (location_id, service_name),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

CREATE TABLE Book (
    book_id INT PRIMARY KEY IDENTITY,
    ISBN_Code VARCHAR(13) UNIQUE NOT NULL,
    book_title VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    publisher_id INT NOT NULL,
    publication_year INT,
    book_edition VARCHAR(50),
    copies_total INT,
    copies_available INT,
    location_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (publisher_id) REFERENCES Publisher(publisher_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

CREATE TABLE Book_Format (
    book_id INT,
    format_type VARCHAR(50),
    PRIMARY KEY (book_id, format_type),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

CREATE TABLE Author (
    author_id INT PRIMARY KEY IDENTITY,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

CREATE TABLE Book_Author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);

CREATE TABLE Author_Award (
    author_id INT,
    award_name VARCHAR(255),
    award_year INT,
    PRIMARY KEY (author_id, award_name, award_year),
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);

CREATE TABLE Tag (
    tag_id INT PRIMARY KEY IDENTITY,
    tag_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Book_Tag (
    book_id INT,
    tag_id INT,
    PRIMARY KEY (book_id, tag_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (tag_id) REFERENCES Tag(tag_id)
);

CREATE TABLE Member_Status (
    active_status_id INT PRIMARY KEY IDENTITY,
    account_type VARCHAR(50),
    account_status VARCHAR(50),
    membership_start_date DATE,
    membership_end_date DATE
);

CREATE TABLE Member (
    member_id INT PRIMARY KEY IDENTITY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    city VARCHAR(255),
    mobile_no VARCHAR(20),
    email_id VARCHAR(255),
    date_of_birth DATE,
    active_status_id INT,
    FOREIGN KEY (active_status_id) REFERENCES Member_Status(active_status_id)
);

CREATE TABLE Member_Contact (
    member_id INT,
    contact_type VARCHAR(50),
    contact_value VARCHAR(255),
    PRIMARY KEY (member_id, contact_type, contact_value),
    FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

CREATE TABLE Member_Preference (
    member_id INT,
    preference_type VARCHAR(50),
    preference_value VARCHAR(255),
    PRIMARY KEY (member_id, preference_type, preference_value),
    FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

CREATE TABLE Book_Request_Status (
    available_status_id INT PRIMARY KEY IDENTITY,
    available_status VARCHAR(50),
    nearest_available_date DATE
);

CREATE TABLE Book_Request (
    request_id INT PRIMARY KEY IDENTITY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    request_date DATE,
    available_status_id INT,
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (available_status_id) REFERENCES Book_Request_Status(available_status_id)
);

CREATE TABLE Library_Staff (
    staff_id INT PRIMARY KEY IDENTITY,
    staff_name VARCHAR(255),
    staff_designation VARCHAR(255)
);

CREATE TABLE Book_Issue (
    issue_id INT PRIMARY KEY IDENTITY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    issue_date DATE,
    return_date DATE,
    issue_status VARCHAR(50),
    issued_by_id INT,
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (issued_by_id) REFERENCES Library_Staff(staff_id)
);

CREATE TABLE Fine_Due (
    fine_id INT PRIMARY KEY IDENTITY,
    member_id INT NOT NULL,
    issue_id INT NOT NULL,
    fine_date DATE,
    fine_total DECIMAL(10, 2),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (issue_id) REFERENCES Book_Issue(issue_id)
);

CREATE TABLE Fine_Payment (
    payment_id INT PRIMARY KEY IDENTITY,
    member_id INT NOT NULL,
    fine_id INT NOT NULL,
    payment_date DATE,
    payment_amount DECIMAL(10, 2),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (fine_id) REFERENCES Fine_Due(fine_id)
);

GO



 --  UP – DATA
   

INSERT INTO Category (category_name)
VALUES 
('Fiction'), ('Science'), ('History'), ('Philosophy'),
('Biography'), ('Fantasy'), ('Technology');
GO

INSERT INTO Publisher (publisher_name, publication_language, publication_type)
VALUES
('Penguin Books', 'English', 'Books'),
('Springer', 'English', 'Journals');
GO
 Insert data for Location
INSERT INTO Location (shelf_no, shelf_name, floor_no)
VALUES 
('A1', 'Fiction Shelf', 1), 
('B2', 'Science Shelf', 2), 
('C3', 'History Shelf', 3), 
('D4', 'Philosophy Shelf', 4);

-- Insert data for Location_Service
INSERT INTO Location_Service (location_id, service_name)
VALUES 
(1, 'Printing'), 
(1, 'Internet Access'), 
(2, 'Study Space');

-- Insert data for Book
INSERT INTO Book (ISBN_Code, book_title, category_id, publisher_id, publication_year, book_edition, copies_total, copies_available, location_id)
VALUES 
('9780141036137', '1984', 1, 1, 1949, '1st', 10, 8, 1),
('9780307417138', 'Physics of the Impossible', 2, 2, 2008, '1st', 5, 4, 2),
('9780198204496', 'A History of the Middle Ages', 3, 3, 1998, '2nd', 7, 5, 3),
('9781430207427', 'Programming Python', 7, 4, 2010, '3rd', 6, 4, 4);

-- Insert data for Book_Format
INSERT INTO Book_Format (book_id, format_type)
VALUES 
(1, 'Hardcover'), 
(1, 'Paperback'), 
(2, 'eBook'), 
(3, 'Hardcover'), 
(4, 'Paperback');

-- Insert data for Author
INSERT INTO Author (first_name, last_name)
VALUES 
('George', 'Orwell'), 
('Michio', 'Kaku'), 
('John', 'Doe'), 
('Mark', 'Lutz');

-- Insert data for Book_Author
INSERT INTO Book_Author (book_id, author_id)
VALUES 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4);

-- Insert data for Tag
INSERT INTO Tag (tag_name)
VALUES 
('Classic'), 
('Science'), 
('Programming'), 
('History');

-- Insert data for Book_Tag
INSERT INTO Book_Tag (book_id, tag_id)
VALUES 
(1, 1), 
(2, 2), 
(3, 4), 
(4, 3);

-- Insert data for Member_Status
INSERT INTO Member_Status (account_type, account_status, membership_start_date, membership_end_date)
VALUES 
('Regular', 'Active', '2023-01-01', '2024-01-01'), 
('Premium', 'Inactive', '2022-06-01', '2023-06-01');

-- Insert data for Member
INSERT INTO Member (first_name, last_name, city, mobile_no, email_id, date_of_birth, active_status_id)
VALUES 
('Alice', 'Smith', 'New York', '1234567890', 'alice@example.com', '1990-01-01', 1), 
('Bob', 'Johnson', 'Los Angeles', '0987654321', 'bob@example.com', '1985-05-15', 2);

-- Insert data for Member_Contact
INSERT INTO Member_Contact (member_id, contact_type, contact_value)
VALUES 
(1, 'Phone', '1234567890'), 
(1, 'Email', 'alice@example.com'), 
(2, 'Phone', '0987654321');

-- Insert data for Member_Preference
INSERT INTO Member_Preference (member_id, preference_type, preference_value)
VALUES 
(1, 'Genre', 'Fiction'), 
(2, 'Author', 'George Orwell');

-- Insert data for Book_Request_Status
INSERT INTO Book_Request_Status (available_status, nearest_available_date)
VALUES 
('Pending', '2023-12-01'), 
('Available', '2023-11-15');

-- Insert data for Book_Request
INSERT INTO Book_Request (book_id, member_id, request_date, available_status_id)
VALUES 
(1, 1, '2023-10-01', 1), 
(2, 2, '2023-10-05', 2);

-- Insert data for Library_Staff
INSERT INTO Library_Staff (staff_name, staff_designation)
VALUES 
('Charles Dickens', 'Librarian'), 
('Emily Bronte', 'Assistant Librarian');

-- Insert data for Book_Issue
INSERT INTO Book_Issue (book_id, member_id, issue_date, return_date, issue_status, issued_by_id)
VALUES 
(1, 1, '2023-09-01', '2023-09-15', 'Returned', 1), 
(2, 2, '2023-09-05', '2023-09-20', 'Overdue', 2);

-- Insert data for Fine_Due
INSERT INTO Fine_Due (member_id, issue_id, fine_date, fine_total)
VALUES 
(1, 1, '2023-09-20', 15.00), 
(2, 2, '2023-09-25', 10.00);

-- Insert data for Fine_Payment
INSERT INTO Fine_Payment (member_id, fine_id, payment_date, payment_amount)
VALUES 
(1, 1, '2023-09-21', 15.00), 
(2, 2, '2023-09-26', 10.00);

GO



  -- VERIFY


SELECT * FROM Category;
SELECT * FROM Book;
SELECT * FROM Member;
SELECT * FROM Book_Issue;
GO
