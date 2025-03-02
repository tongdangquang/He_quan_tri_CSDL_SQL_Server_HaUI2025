USE master
GO

-- Câu 1. Tạo cơ sở dữ liệu
CREATE DATABASE MarkManagement
ON (
    NAME = "MarkManagement_data",
    FILENAME = "D:\Documents\SQL_server_HaUI\Database\MarkManagement_data.mdf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON (
    NAME = "MarkManagement_log",
    FILENAME = "D:\Documents\SQL_server_HaUI\Database\MarkManagement_log.ldf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE MarkManagement
GO

-- Câu 2. Tạo các bảng dữ liệu
-- Tạo bảng Students
CREATE TABLE Students
(
    StudentID NVARCHAR(12) NOT NULL PRIMARY KEY,
    StudentName NVARCHAR(25) NOT NULL,
    DateofBirth DATETIME NOT NULL,
    Email NVARCHAR(40),
    Phone NVARCHAR(12),
    Class NVARCHAR(10)
);

-- Tạo bảng Subjects
CREATE TABLE Subjects
(
    SubjectID NVARCHAR(10) NOT NULL PRIMARY KEY,
    SubjectName NVARCHAR(25) NOT NULL
);

-- Tạo bảng Mark
CREATE TABLE Mark
(
    StudentID NVARCHAR(12) NOT NULL,
    SubjectID NVARCHAR(10) NOT NULL,
    Date DATETIME,
    Theory TINYINT,
    Practical TINYINT,
    CONSTRAINT PK_Mark PRIMARY KEY(StudentID, SubjectID),
    CONSTRAINT FK_Mark_StudentID FOREIGN KEY(StudentID) REFERENCES Students(StudentID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT FK_Mark_SubjectID FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
GO

-- Câu 3: Chèn dữ liệu
-- Chèn dữ liệu cho bảng Students
INSERT INTO Students(StudentID, StudentName, DateofBirth, Email, Phone, Class)
VALUES
    (N'AV0807005', N'Mai Trung Hiếu', '11/10/1989', N'trunghieu@yahoo.com', N'0904115116', N'AV1'),
    (N'AV0807006', N'Nguyễn Quý Hùng', '2/12/1988', N'quyhung@yahoo.com', N'0955667787', N'AV2'),
    (N'AV0807007', N'Đỗ Đắc Huỳnh', '2/1/1990', N'dachuynh@yahoo.com', N'0988574747', N'AV2'),
    (N'AV0807009', N'An Đăng Khuê', '6/3/1986', N'dangkhue@yahoo.com', N'0986757463', N'AV1'),
    (N'AV0807010', N'Nguyễn T. Tuyết Lan', '12/7/1989', N'tuyetlan@yahoo.com', N'0983310342', N'AV2'),
    (N'AV0807011', N'Đinh Phụng Long', '2/12/1990', N'phunglong@yahoo.com', NULL, N'AV1'),
    (N'AV0807012', N'Nguyễn Tuấn Nam', '2/3/1990', N'tuannam@yahoo.com', NULL, N'AV1');

-- Chèn dữ liệu cho bảng Subjects
INSERT INTO Subjects(SubjectID, SubjectName)
VALUES
    (N'S001', N'SQL'),
    (N'S002', N'Java Simplefield'),
    (N'S003', N'Active Server Page');

-- Chèn dữ liệu cho bảng Mark
INSERT INTO Mark(StudentID, SubjectID, Theory, Practical, Date)
VALUES
    (N'AV0807005', N'S001', 8, 25, '6/5/2008'),
    (N'AV0807006', N'S002', 16, 30, '6/5/2008'),
    (N'AV0807007', N'S001', 10, 25, '6/5/2008'),
    (N'AV0807009', N'S003', 7, 13, '6/5/2008'),
    (N'AV0807010', N'S003', 9, 16, '6/5/2008'),
    (N'AV0807011', N'S002', 8, 30, '6/5/2008'),
    (N'AV0807012', N'S001', 7, 31, '6/5/2008'),
    (N'AV0807005', N'S002', 12, 11, '6/6/2008'),
    (N'AV0807010', N'S001', 7, 6, '6/6/2008');
GO

-- Câu 4. Thực hiện truy vấn
-- 1.  Hiển thị nội dung bảng Students 
SELECT * FROM Students;
GO

-- 2.  Hiển thị nội dung danh sách sinh viên lớp AV1 
SELECT * 
FROM Students
WHERE Class = 'AV1';
GO

-- 3.  Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2 
UPDATE Students
SET Class = 'AV2'
WHERE StudentID = 'AV0807012';
GO

-- 4.  Tính tổng số sinh viên của từng lớp 
SELECT Class, COUNT(StudentID) AS 'Tổng số sinh viên'
FROM Students
GROUP BY Class;
GO
-- 5.  Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName 
SELECT StudentID, StudentName, Class
FROM Students
WHERE Class = 'AV2'
ORDER BY StudentName ASC;
GO

-- 6.  Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008 
SELECT S.StudentID, S.StudentName, M.Theory
FROM Students S
INNER JOIN Mark M ON S.StudentID = M.StudentID
WHERE M.SubjectID = 'S001' AND (M.Theory < 10) AND (M.Date = '6/5/2008');
GO

-- 7.  Hiển thị tổng số sinh viên không đạt lý thuyết môn S001. (theory <10) 
SELECT SubjectID, COUNT(StudentID) AS 'Số sinh viên không đạt lý thuyết'
FROM Mark
WHERE SubjectID = 'S001' AND Theory < 10
GROUP BY SubjectID;

-- 8.  Hiển thị Danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980 
SELECT StudentID, StudentName, Class, DateofBirth
FROM Students
WHERE Class = 'AV1' AND DateofBirth > '1/1/1980';
GO

-- 9.  Xoá sinh viên có mã AV0807011 
DELETE Students
WHERE StudentID = 'AV0807011';
GO

-- 10. Hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008 bao gồm các trường sau: StudentID, StudentName, SubjectName, Theory, Practical, Date
SELECT S.StudentID, StudentName, SubjectName, Theory, Practical, Date 
FROM Students S
INNER JOIN Mark M ON S.StudentID = M.StudentID
INNER JOIN Subjects Su ON M.SubjectID = Su.SubjectID
WHERE M.SubjectID = 'S001' AND M.Date = '6/5/2008';
GO
