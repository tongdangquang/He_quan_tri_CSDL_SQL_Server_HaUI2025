USE master
GO

-- Tạo cơ sở dữ liệu
CREATE DATABASE QLBanHang
ON PRIMARY(
    NAME = 'QLBanHang_data',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLBanHang_data.mdf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 20%
)
LOG ON(
    NAME = 'QLBanHang_log',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLBanHang_log.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 20%
);
GO

USE QLBanHang
GO

-- Tạo bảng HangSX
CREATE TABLE HangSX
(
    MaHangSX NCHAR(10) NOT NULL PRIMARY KEY,
    TenHang NVARCHAR(20) NOT NULL,
    DiaChi NVARCHAR(20),
    SoDT NVARCHAR(20),
    Email NVARCHAR(20)
);

-- Tạo bảng SanPham
CREATE TABLE SanPham
(
    MaSP NCHAR(10) NOT NULL PRIMARY KEY,
    MaHangSX NCHAR(10),
    TenSP NVARCHAR(20) NOT NULL,
    SoLuong INT,
    MauSac NVARCHAR(20),
    GiaBan MONEY,
    DonViTinh NCHAR(10),
    MoTa NVARCHAR(MAX),
    CONSTRAINT FK_SanPham_MaHangSX FOREIGN KEY (MaHangSX) REFERENCES HangSX(MaHangSX)
);

-- Tạo bảng NhanVien
CREATE TABLE NhanVien
(
    MaNV NCHAR(10) NOT NULL PRIMARY KEY,
    TenNV NVARCHAR(20) NOT NULL,
    GioiTinh NCHAR(10),
    DiaChi NVARCHAR(30),
    SoDT NVARCHAR(20),
    Email NVARCHAR(30),
    TenPhong NVARCHAR(30)
);

-- Tạo bảng PNhap
CREATE TABLE PNhap
(
    SoHDN NCHAR(10) NOT NULL PRIMARY KEY,
    NgayNhap DATE,
    MaNV NCHAR(10),
    CONSTRAINT FK_PNhap_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Tạo bảng Nhap
CREATE TABLE Nhap
(
    SoHDN NCHAR(10) NOT NULL,
    MaSP NCHAR(10) NOT NULL,
    SoLuongN INT,
    DonGiaN MONEY,
    CONSTRAINT PK_Nhap PRIMARY KEY (SoHDN, MaSP),
    CONSTRAINT FK_Nhap_SoHDN FOREIGN KEY (SoHDN) REFERENCES PNhap(SoHDN),
    CONSTRAINT FK_Nhap_MaSP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- Tạo bảng PXuat
CREATE TABLE PXuat
(
    SoHDX NCHAR(10) NOT NULL PRIMARY KEY,
    NgayXuat DATE,
    MaNV NCHAR(10),
    CONSTRAINT FK_PXuat_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Tạo bảng Xuat
CREATE TABLE Xuat
(
    SoHDX NCHAR(10) NOT NULL,
    MaSP NCHAR(10) NOT NULL,
    SoLuongX INT,
    CONSTRAINT PK_Xuat PRIMARY KEY (SoHDX, MaSP),
    CONSTRAINT FK_Xuat_SoHDX FOREIGN KEY (SoHDX) REFERENCES PXuat(SoHDX),
    CONSTRAINT FK_Xuat_MaSP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
GO

-- a. 
CREATE PROCEDURE sp_a 
    @MaHangSX NCHAR(10), @TenHang NVARCHAR(20), @DiaChi NVARCHAR(20), @SoDT NVARCHAR(20), @Email NVARCHAR(20), @x INT OUTPUT
AS 
BEGIN 
    IF EXISTS (SELECT * FROM HangSX WHERE MaHangSX = @MaHangSX)
    BEGIN
        SET @x = 1;
        PRINT N'Mã hãng SX đã tồn tại!';
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT * FROM HangSX WHERE TenHang = @TenHang)
        BEGIN
            SET @x = 1;
            PRINT N'Tên hãng đã tồn tại!';
        END
        ELSE
        BEGIN
            SET @x = 0;
            INSERT INTO HangSX (MaHangSX, TenHang, DiaChi, SoDT, Email)
            VALUES (@MaHangSX, @TenHang, @DiaChi, @SoDT, @Email);
            PRINT N'Thêm hãng SX thành công';
        END
    END
END
GO
DECLARE @x INT;
EXEC dbo.sp_a 'H02', N'OPPO', N'China', '081-08626262', 'oppo@gmail.com.cn', @x OUTPUT;
PRINT @x;
GO

-- b. 
CREATE PROCEDURE sp_b
    @SoHDN NCHAR(10), @MaSP NCHAR(10), @MaNV NCHAR(10), @NgayNhap DATE, @SoLuongN INT, @DonGiaN MONEY, @x INT OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        SET @x = 1;
        PRINT N'Không tồn tại sản phẩm có mã ' + @MaSP;
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM NhanVien WHERE MaNV = @MaNV)
    BEGIN
        SET @x = 2;
        PRINT N'Không tồn tại nhân viên có mã ' + @MaNV;
        RETURN;
    END

    SET @x = 0;
    IF NOT EXISTS (SELECT * FROM Nhap WHERE SoHDN = @SoHDN)
    BEGIN
        INSERT INTO PNhap VALUES (@SoHDN, @NgayNhap, @MaNV);
        INSERT INTO Nhap VALUES (@SoHDN, @MaSP, @SoLuongN, @DonGiaN);
        PRINT N'Thêm hóa đơn nhập thành công!';
    END

    ELSE
    BEGIN
        UPDATE Nhap
        SET MaSP = @MaSP, SoLuongN = @SoLuongN, DonGiaN = @DonGiaN
        WHERE SoHDN = @SoHDN;
        UPDATE PNhap
        SET NgayNhap = @NgayNhap, MaNV = @MaNV
        WHERE SoHDN = @SoHDN;
        PRINT N'Cập nhật thành công!';
    END
END
GO
DECLARE @x INT;
EXEC dbo.sp_b 'N01', 'SP01', 'NV01', '07-07-2020', 10, 17000000, @x OUTPUT;
PRINT @x;
GO

-- c. 
CREATE PROCEDURE sp_c (@SoHDX NCHAR(10), @MaSP NCHAR(10), @MaNV NCHAR(10), @NgayXuat DATE, @SoLuongX INT, @x INT OUTPUT)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        SET @x = 1;
        PRINT N'MaSP không tồn tại!';
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM NhanVien WHERE MaNV = @MaNV)
    BEGIN 
        SET @x = 2;
        PRINT N'MaNV không tồn tại!';
        RETURN;
    END

    IF @SoLuongX > (SELECT SoLuong FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        SET @x = 3;
        PRINT N'Số lượng xuất phải nhỏ hơn số lượng sản phẩm đang có!';
        RETURN;
    END

    SET @x = 0;
    IF EXISTS (SELECT * FROM PXuat WHERE SoHDX = @SoHDX)
    BEGIN
        UPDATE PXuat 
        SET NgayXuat = @NgayXuat, MaNV = @MaNV
        WHERE SoHDX = @SoHDX;
        UPDATE Xuat
        SET MaSP = @MaSP, SoLuongX = @SoLuongX
        WHERE SoHDX = @SoHDX;
        PRINT N'Cập nhật thành công!';
    END
    ELSE
    BEGIN
        INSERT INTO PXuat VALUES (@SoHDX, @NgayXuat, @MaNV);
        INSERT INTO Xuat VALUES (@SoHDX, @MaSP, @SoLuongX);
        PRINT N'Thêm hóa đơn xuất thành công!';
    END
END
GO
DECLARE @x INT;
EXEC dbo.sp_c 'X01', 'SP01', 'NV01', '1/1/2025', 10, @x OUTPUT;
GO
