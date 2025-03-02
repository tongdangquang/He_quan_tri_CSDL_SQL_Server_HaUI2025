USE master;
GO

CREATE DATABASE Truonghoc
ON
(
    NAME = 'Truonghoc_data',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\Truonghoc_data.mdf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON
(
    NAME = 'Truonghoc_log',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\Truonghoc_log.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE Truonghoc;
GO

CREATE TABLE Khoa
(
    Makhoa VARCHAR(20) NOT NULL PRIMARY KEY,
    Tenkhoa NVARCHAR(30),
    Dienthoai VARCHAR(10) 
);

CREATE TABLE Lop
(
    Malop VARCHAR(20) NOT NULL PRIMARY KEY,
    Tenlop NVARCHAR(30),
    Khoa INT,
    Hedt NVARCHAR(20),
    Namnhaphoc INT,
    Makhoa VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Lop_Makhoa FOREIGN KEY(Makhoa) REFERENCES Khoa(Makhoa)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
GO

INSERT INTO Khoa(Makhoa, Tenkhoa, Dienthoai)
VALUES 
    ('K01', N'Công nghệ thông tin', '0388786341'),
    ('K02', N'Kế toán', '0388786342'),
    ('K03', N'Ngoại ngữ', '0388786343'),
    ('K04', N'Điện tử', '0388786344'),
    ('K05', N'Quản lý kinh doanh', '0388786345');

INSERT INTO Lop(Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
VALUES
    ('L01', N'HTTT01', 17, N'Đại học', 2025, 'K01'),
    ('L02', N'CNTT01', 17, N'Liên thông', 2025, 'K01'),
    ('L03', N'KT01', 17, N'Đại học', 2024, 'K02'),
    ('L04', N'NNA01', 17, N'Đại học', 2025, 'K03'),
    ('L05', N'QTKD01', 17, N'Đại học', 2024, 'K05');
GO

-- Câu 1.
CREATE PROCEDURE sp_cau_1(@Makhoa VARCHAR(20), @Tenkhoa NVARCHAR(30), @Dienthoai VARCHAR(10), @result INT OUTPUT)
AS
BEGIN
    SET @result = 1;
    IF EXISTS(SELECT * FROM Khoa WHERE Makhoa = @Makhoa OR Tenkhoa = @Tenkhoa)
        SET @result = 0;
    ELSE
        INSERT INTO Khoa(Makhoa, Tenkhoa, Dienthoai)
        VALUES (@Makhoa, @Tenkhoa, @Dienthoai);
END;
GO

DECLARE @result INT;
EXEC dbo.sp_cau_1 'K08', N'Thực phẩm', '0388786346', @result OUTPUT;
IF @result = 0
    PRINT N'Mã khoa hoặc tên khoa đã tồn tại!';
ELSE  
    PRINT N'Thêm khoa thành công!';
GO

-- Câu 2. 
CREATE PROCEDURE sp_cau_2(@Malop VARCHAR(20), @Tenlop NVARCHAR(30), @Khoa INT, @Hedt NVARCHAR(20), @Namnhaphoc INT, @Makhoa VARCHAR(20), @result INT OUTPUT)
AS
BEGIN 
    IF EXISTS (SELECT * FROM Lop WHERE Malop = @Malop OR Tenlop = @Tenlop)
        SET @result = 0;
    ELSE IF NOT EXISTS (SELECT * FROM Khoa WHERE Makhoa = @Makhoa)
        SET @result = 1;
    ELSE
        BEGIN
            INSERT INTO Lop
            VALUES (@Malop, @Tenlop, @Khoa, @Hedt, @Namnhaphoc, @Makhoa);
            SET @result = 2;
        END
END;
GO
DECLARE @result2 INT;
EXEC dbo.sp_cau_2 'L07', N'CK02', 17, N'Đại học', 2024, 'K010', @result2 OUTPUT;
IF @result2 = 0
    PRINT N'Mã lớp hoặc tên lớp đã tồn tại!';
ELSE IF @result2 = 1
    PRINT N'Mã khoa không tông tại!';
ELSE  
    PRINT N'Thêm lớp thành công!';
GO