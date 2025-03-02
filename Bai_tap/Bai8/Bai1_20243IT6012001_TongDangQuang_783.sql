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

-- Câu 1. Viết  thủ  tục  nhập  dữ  liệu  vào  bảng  KHOA  với  các  tham  biến: 
-- makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa, 
-- nếu đã tồn tại đưa ra thông báo, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2 
-- trường hợp.
CREATE PROCEDURE sp_cau_1(@Makhoa VARCHAR(20), @Tenkhoa NVARCHAR(30), @Dienthoai VARCHAR(10))
AS
BEGIN
    IF EXISTS(SELECT * FROM Khoa WHERE Makhoa = @Makhoa)
        PRINT N'Mã khoa ' + @Makhoa + N' đã tồn tại!';
    ELSE IF EXISTS(SELECT * FROM Khoa WHERE Tenkhoa = @Tenkhoa)
        PRINT N'Tên khoa ' + @Tenkhoa + N' đã tồn tại!';
    ELSE
        BEGIN
            INSERT INTO Khoa(Makhoa, Tenkhoa, Dienthoai)
            VALUES (@Makhoa, @Tenkhoa, @Dienthoai);
            PRINT N'Thêm khoa thành công!';
        END
END;
GO
EXEC dbo.sp_cau_1 'K06', N'Cơ khí', '0388786346';
GO
    
-- Câu 2. Hãy viết thủ tục nhập dữ liệu cho bảng Lop với các tham biến Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa nhập từ bàn phím. 
    -- Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì thông báo 
    -- Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì thông báo 
    -- Nếu đầy đủ thông tin thì cho nhập
CREATE PROCEDURE sp_cau_2(@Malop VARCHAR(20), @Tenlop NVARCHAR(30), @Khoa INT, @Hedt NVARCHAR(20), @Namnhaphoc INT, @Makhoa VARCHAR(20))
AS
BEGIN 
    IF EXISTS (SELECT * FROM Lop WHERE Malop = @Malop OR Tenlop = @Tenlop)
        PRINT N'Mã lớp hoặc tên lớp đã tồn tại!';
    ELSE IF NOT EXISTS (SELECT * FROM Khoa WHERE Makhoa = @Makhoa)
        PRINT N'Mã khoa không tồn tại!';
    ELSE
        BEGIN
            INSERT INTO Lop
            VALUES (@Malop, @Tenlop, @Khoa, @Hedt, @Namnhaphoc, @Makhoa);
            PRINT N'Thêm lớp thành công!';
        END
END;
GO
EXEC dbo.sp_cau_2 'L06', N'CK01', 17, N'Đại học', 2024, 'K06';
GO