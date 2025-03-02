-- Câu 1. Tạo cơ sở dữ liệu DeptEmp
USE master
GO

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
GO

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

-- Câu 4. Thực hiện truy vấn
-- 1. Hiển thị nội dung bảng Department 
SELECT * FROM Department;
GO
-- 2. Hiển thị nội dung bảng Employee 
SELECT * FROM Employee;
GO

-- 3. Hiển thị employee number, employee first name và employee last name từ bảng Employee mà  employee first name có tên là ‘Kate’. 
SELECT EmpNo, Fname, Lname
FROM Employee
WHERE Fname ='Kate';
GO

-- 4. Hiển thị ghép 2 trường Fname và Lname thành Full Name, Salary, 10%Salary (tăng 10% so với lương ban đầu).   
SELECT (Fname + ' ' + Lname) AS 'Full Name', Salary, (Salary + Salary * 0.1) AS '10% Salary'
FROM Employee;
GO

-- 5. Hiển thị Fname, Lname, HireDate cho tất cả các Employee có HireDate là năm 1981 và sắp xếp theo thứ tự tăng dần của Lname. 
SELECT Fname, Lname, HireDate
FROM Employee
WHERE YEAR(HireDate) = 1981
ORDER BY Lname ASC;
GO

-- 6. Hiển thị trung bình(average), lớn nhất (max) và nhỏ nhất(min) của lương(salary) cho từng phòng ban trong bảng Employee. 
SELECT D.DepartmentNo, DepartmentName, AVG(Salary) AS 'Average Salary', MAX(Salary) AS 'Max Salary', MIN(Salary) AS 'Min Salary'
FROM Department D
INNER JOIN Employee E ON D.DepartmentNo = E.DepartmentNo
GROUP BY D.DepartmentNo, DepartmentName;
GO

-- 7. Hiển thị DepartmentNo và số người có trong từng phòng ban có trong bảng Employee. 
SELECT D.DepartmentNo, COUNT(E.EmpNo) AS 'Số nhân viên'
FROM Department D
LEFT JOIN Employee E ON D.DepartmentNo = E.DepartmentNo
GROUP BY D.DepartmentNo;
GO

-- 8. Hiển thị DepartmentNo, DepartmentName, FullName (Fname và Lname), Job, Salary trong bảng Department và bảng Employee. 
SELECT D.DepartmentNo, DepartmentName, (Fname + ' ' + Lname) AS 'Full Name', Job, Salary
FROM Department D
INNER JOIN Employee E ON D.DepartmentNo = E.DepartmentNo;
GO

-- 9. Hiển thị DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Department và bảng Employee. 
SELECT D.DepartmentNo, DepartmentName, Location, COUNT(E.EmpNo) AS 'Số nhân viên'
FROM Department D
INNER JOIN Employee E ON D.DepartmentNo = E.DepartmentNo
GROUP BY D.DepartmentNo, DepartmentName, Location;
GO

-- 10. Hiển thị tất cả DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Department và bảng Employee
SELECT D.DepartmentNo, DepartmentName, Location, COUNT(E.EmpNo) AS 'Số nhân viên'
FROM Department D
LEFT JOIN Employee E ON D.DepartmentNo = E.DepartmentNo
GROUP BY D.DepartmentNo, DepartmentName, Location;
GO
