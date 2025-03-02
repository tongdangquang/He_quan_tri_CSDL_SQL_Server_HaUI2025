USE master;
GO

CREATE DATABASE QLNV
ON
(
    NAME = 'QLNV_data',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLNV_data.mdf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON
(
    NAME = 'QLNV_LOG',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLNV_LOG.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE QLNV;
GO

CREATE TABLE tblChucvu
(
    MaCV NVARCHAR(2) NOT NULL PRIMARY KEY,
    TenCV NVARCHAR(30)
);
CREATE TABLE tblNhanVien
(
    MaNV NVARCHAR(4) NOT NULL PRIMARY KEY,
    MaCV NVARCHAR(2),
    TenNV NVARCHAR(30),
    NgaySinh DATETIME,
    LuongCanBan FLOAT,
    NgayCong INT,
    PhuCap FLOAT
    CONSTRAINT FK_tblNhanVien_MaCV FOREIGN KEY (MaCV) REFERENCES tblChucvu(MaCV)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
GO

INSERT INTO tblChucvu(MaCV, TenCV)
VALUES
    ('BV', N'Bảo Vệ'),
    ('GD', N'Giám Đốc'),
    ('HC', N'Hành Chính'),
    ('KT', N'Kế Toán'),
    ('TQ', N'Thủ Quỹ'),
    ('VS', N'Vệ Sinh');
INSERT INTO tblNhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES
    ('NV01', 'GD', N'Nguyễn Văn An', '12/12/1977', 700000, 25, 500000),
    ('NV02', 'BV', N'Bùi Văn Tí', '10/10/1978', 400000, 24, 100000),
    ('NV03', 'KT', N'Trần Thanh Nhật', '9/9/1977', 600000, 26, 400000),
    ('NV04', 'VS', N'Nguyễn Thị Út', '10/10/1980', 300000, 26, 300000),
    ('NV05', 'HC', N'Lê Thị Hà', '10/10/1979', 500000, 27, 200000);
GO

-- 1.
CREATE PROCEDURE SP_Them_Nhan_Vien 
    @MaNV NVARCHAR(4), @MaCV NVARCHAR(2), @TenNV NVARCHAR(30), @NgaySinh DATETIME, @LuongCanBan FLOAT, @NgayCong INT, @PhuCap FLOAT, @result INT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT * FROM tblNhanVien WHERE MaNV = @MaNV)
        SET @result = 0;
    ELSE
        BEGIN
            IF NOT EXISTS (SELECT * FROM tblChucvu WHERE MaCV = @MaCV)
                SET @result = 0;
            ELSE
                BEGIN
                    INSERT INTO tblNhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
                    VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap);
                    SET @result = 1;
                END
        END
END;
GO
DECLARE @result INT;
EXEC dbo.SP_Them_Nhan_Vien 'NV06', 'HC', N'Lê Thu Huyền', '10/10/1979', 450000, 27, 250000, @result OUTPUT;
IF @result = 0
    PRINT N'Thêm NV không thành công';
ELSE
    PRINT N'Thêm NV thành công';
GO

-- 2.
ALTER PROCEDURE SP_Them_Nhan_Vien
    @MaNV NVARCHAR(4), @MaCV NVARCHAR(2), @TenNV NVARCHAR(30), @NgaySinh DATETIME, @LuongCanBan FLOAT, @NgayCong INT, @PhuCap FLOAT
AS
BEGIN 
    DECLARE @result INT;
    IF EXISTS (SELECT * FROM tblNhanVien WHERE MaNV = @MaNV)
        BEGIN
            SET @result = 0;
            RETURN @result;
        END
    IF NOT EXISTS (SELECT * FROM tblChucvu WHERE MaCV = @MaCV)
        BEGIN
            SET @result = 1;
            RETURN @result;
        END
    INSERT INTO tblNhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
    VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap);
    SET @result = 2;
    RETURN @result;
END;
GO

DECLARE @result1 INT;
EXEC @result1 = dbo.SP_Them_Nhan_Vien 'NV07', 'VS', N'Lê Thanh Huyền', '10/10/1979', 450000, 27, 250000;
PRINT @result1;
GO

-- 3. 
CREATE PROCEDURE SP_CapNhat_NgaySinh
    @MaNV NVARCHAR(4), @NgaySinh DATETIME
AS
BEGIN
    DECLARE @result INT;
    IF EXISTS (SELECT * FROM tblNhanVien WHERE MaNV = @MaNV)
        BEGIN
            UPDATE tblNhanVien
            SET NgaySinh = @NgaySinh
            WHERE MaNV = @MaNV;
            SET @result = 1;
            PRINT N'Cập nhật thành công!';
        END
    ELSE
        BEGIN
            SET @result = 0;
            PRINT N'MaNV không tồn tại!';
        END
    RETURN @result;
END;
GO

DECLARE @result2 INT;
EXEC @result2 = dbo.SP_CapNhat_NgaySinh 'NV09', '12/11/1979';
PRINT @result2;
GO
