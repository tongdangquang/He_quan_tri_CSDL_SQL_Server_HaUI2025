USE master
GO

-- Câu 1. Tạo cơ sở dữ liệu DeptEmp
CREATE DATABASE DeptEmp
ON (
    NAME = "DeptEmp_data",
    FILENAME = "D:\Documents\SQL_server_HaUI\Database\DeptEmp_data.mdf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON (
    NAME = "DeptEmp_log",
    FILENAME = "D:\Documents\SQL_server_HaUI\Database\DeptEmp_log.ldf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);

USE DeptEmp
GO

-- Câu 2. Tạo các bảng dữ liệu
-- Tạo bảng Department
CREATE TABLE Department
(
    DepartmentNo INT NOT NULL PRIMARY KEY, 
    DepartmentName CHAR(25) NOT NULL,
    Location CHAR(25) NOT NULL
);

-- Tạo bảng Employee
CREATE TABLE Employee
(
    EmpNo INT NOT NULL PRIMARY KEY, 
    Fname VARCHAR(15) NOT NULL,
    Lname VARCHAR(15) NOT NULL,
    Job VARCHAR(25) NOT NULL,
    HireDate DATETIME NOT NULL,
    Salary NUMERIC NOT NULL,
    Commision NUMERIC,
    DepartmentNo INT NOT NULL,
    CONSTRAINT FK_Employee_DepartmentNo FOREIGN KEY(DepartmentNo) REFERENCES Department(DepartmentNo)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
);
GO

-- Câu 3. Chèn dữ liệu
-- Chèn dữ liệu cho bảng Department
INSERT INTO Department(DepartmentNo, DepartmentName, Location)
VALUES 
    (10, 'Accounting', 'Melbourne'),
    (20, 'Research', 'Adealide'),
    (30, 'Sales', 'Sydney'),
    (40, 'Operations', 'Perth');

-- Chèn dữ liệu cho bảng Employee
INSERT INTO Employee(EmpNo, Fname, Lname, Job, HireDate, Salary, Commision, DepartmentNo)
VALUES 
    (1, 'John', 'Smith', 'Clerk', '17-Dec-1980', 800, null, 20),
    (2, 'Peter', 'Allen', 'Salesman', '20-Feb-1981', 1600, 300, 30),
    (3, 'Kate', 'Ward', 'Salesman', '22-Feb-1981', 1250, 500, 30),
    (4, 'Jack', 'Jones', 'Manager', '02-Apr-1981', 2975, null, 20),
    (5, 'Joe', 'Martin', 'Salesman', '28-Sep-1981', 1250, 1400, 30);
GO
-- Kiểm tra kết quả
SELECT * FROM Department;
SELECT * FROM Employee;
GO