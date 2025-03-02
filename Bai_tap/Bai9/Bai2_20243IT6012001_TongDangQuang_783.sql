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

-- Bài 1. 
-- a. 
CREATE PROCEDURE sp_1a 
    @MaSP NCHAR(10), @MaHangSX NCHAR(10), @TenSP NVARCHAR(20), @SoLuong INT, @MauSac NVARCHAR(20), @GiaBan MONEY, @DonViTinh NCHAR(10), @MoTa NVARCHAR(MAX)
AS
BEGIN 
    IF EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
        BEGIN
            IF EXISTS (SELECT * FROM HangSX WHERE MaHangSX = @MaHangSX)
                BEGIN
                    UPDATE SanPham
                    SET MaHangSX = @MaHangSX, TenSP = @TenSP, SoLuong = @SoLuong, MauSac = @MauSac, GiaBan = @GiaBan, DonViTinh = @DonViTinh, MoTa = @MoTa
                    WHERE MaSP = @MaSP;
                    PRINT N'Cập nhật thành công!';
                END
            ELSE
                PRINT N'MaHangSX không tồn tại!';
        END
    ELSE
        BEGIN
            IF EXISTS (SELECT * FROM HangSX WHERE MaHangSX = @MaHangSX)
                BEGIN
                INSERT INTO SanPham
                VALUES (@MaSP, @MaHangSX, @TenSP, @SoLuong, @MauSac, @GiaBan, @DonViTinh, @MoTa);
                PRINT N'Thêm SP thành công!';
            END
            ELSE
                PRINT N'MaHangSX không tồn tại!';
        END
END
GO 
EXEC dbo.sp_1a 'SP01', 'H01', N'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp';
GO

-- b.
CREATE PROCEDURE sp_1b
    @TenHang NVARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM HangSX WHERE TenHang = @TenHang)
        PRINT N'Tên hãng không tồn tại!';
    ELSE
        BEGIN
            DELETE FROM SanPham
            WHERE MaHangSX = (SELECT MaHangSX FROM HangSX WHERE TenHang = @TenHang);
            DELETE FROM HangSX
            WHERE TenHang = @TenHang;
            PRINT N'Xóa hãng SX thành công!';
        END
END
GO
EXEC dbo.sp_1b 'Samsung';
GO

-- c.
CREATE PROCEDURE sp_1c
    @MaNV NCHAR(10), @TenNV NVARCHAR(20), @GioiTinh NCHAR(10), @DiaChi NVARCHAR(30), @SoDT NVARCHAR(20), @Email NVARCHAR(30), @TenPhong NVARCHAR(30), @Flag INT
AS
BEGIN
    IF @Flag = 0
        BEGIN
            IF NOT EXISTS (SELECT * FROM NhanVien WHERE MaNV = @MaNV)
                PRINT N'Không tồn tại MaNV = ' + @MaNV + N' để cập nhật!';
            ELSE
                BEGIN
                    UPDATE NhanVien
                    SET TenNV = @TenNV, GioiTinh = @GioiTinh, DiaChi = @DiaChi, SoDT = @SoDT, Email = @Email, TenPhong = @TenPhong
                    WHERE MaNV = @MaNV;
                    PRINT N'Cập nhật NV thành công!';
                END
        END
    ELSE
         BEGIN
            IF EXISTS (SELECT * FROM NhanVien WHERE MaNV = @MaNV)
                PRINT N'MaNV đã tồn tại!';
            ELSE
                BEGIN 
                    INSERT INTO NhanVien
                    VALUES (@MaNV, @TenNV, @GioiTinh, @DiaChi, @SoDT, @Email, @TenPhong);
                    PRINT N'Thêm NV thành công!';
                END
        END
END
GO
EXEC dbo.sp_1c 'NV01', N'Nguyễn Thanh Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@mail.com', N'Kế toán', 1;
GO

-- d. 
CREATE PROCEDURE sp_1d
    @SoHDN NCHAR(10), @MaSP NCHAR(10), @MaNV NCHAR(10), @NgayNhap DATE, @SoLuongN INT, @DonGiaN MONEY
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
        BEGIN
            PRINT N'Không tồn tại sản phẩm có mã ' + @MaSP;
            RETURN;
        END
    IF NOT EXISTS (SELECT * FROM NhanVien WHERE MaNV = @MaNV)
        BEGIN
            PRINT N'Không tồn tại nhân viên có mã ' + @MaNV;
            RETURN;
        END
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
EXEC dbo.sp_1d 'N01', 'SP01', 'NV01', '07-07-2020', 10, 17000000;
GO

-- Bài 2. 
-- a.
CREATE PROCEDURE sp_2a 
    @MaSP NCHAR(10), @TenHang NVARCHAR(20), @TenSP NVARCHAR(20), 
    @SoLuong INT, @MauSac NVARCHAR(20), @GiaBan MONEY, @DonViTinh NCHAR(10), 
    @MoTa NVARCHAR(MAX), @Flag INT, @result INT OUTPUT
AS
BEGIN 
    DECLARE @MaHangSX NCHAR(10);
    IF NOT EXISTS (SELECT * FROM HangSX WHERE TenHang = @TenHang)
        BEGIN
            SET @result = 1;
            PRINT N'Tên hãng không tồn tại!';
            RETURN;
        END
    ELSE
        SET @MaHangSX = (SELECT MaHangSX FROM HangSX WHERE TenHang = @TenHang);
    
    IF @SoLuong < 0
        BEGIN
            SET @result = 2;
            PRINT N'Số lượng phải >= 0!';
            RETURN;
        END

    IF @Flag = 0
        BEGIN
            IF EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
                BEGIN
                    PRINT N'MaSP đã tồn tại!';
                    RETURN;
                END
            ELSE
                BEGIN
                    INSERT INTO SanPham
                    VALUES (@MaSP, @MaHangSX, @TenSP, @SoLuong, @MauSac, @GiaBan, @DonViTinh, @MoTa);
                    PRINT N'Thêm SP thành công!';
                END
        END
    ELSE
        BEGIN
            UPDATE SanPham
            SET MaHangSX = @MaHangSX, TenSP = @TenSP, SoLuong = @SoLuong, MauSac = @MauSac, GiaBan = @GiaBan, DonViTinh = @DonViTinh, MoTa = @MoTa
            WHERE MaSP = @MaSP;
            PRINT N'Cập nhật thành công!';
        END
END
GO 
DECLARE @result INT;
EXEC dbo.sp_2a 'SP02', 'Oppo', N'F1 Plus', 100, N'Đen', 7000000, N'Chiếc', N'Hàng cận cao cấp', 1, @result OUTPUT;
PRINT @result;
GO

-- b. 
CREATE PROCEDURE sp_2b
    @MaNV NCHAR(10), @x INT OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM NhanVien WHERE MaNV = @MaNV)
        BEGIN
            SET @x = 1;
            PRINT N'Không tồn tại nhân viên có mã ' + @MaNV;
        END
    ELSE
        BEGIN
            SET @x = 0;
            DELETE FROM Nhap WHERE SoHDN = (SELECT SoHDN FROM PNhap WHERE MaNV = @MaNV);
            DELETE FROM PNhap WHERE MaNV = @MaNV;
            DELETE FROM Xuat WHERE SoHDX = (SELECT SoHDX FROM PXuat WHERE MaNV = @MaNV);
            DELETE FROM PXuat WHERE MaNV = @MaNV;
            DELETE FROM NhanVien WHERE MaNV = @MaNV;
            PRINT N'Xóa NV thành công!';
        END
END
GO
DECLARE @result INT;
EXEC sp_2b 'NV02', @result OUTPUT;
PRINT @result;
GO 

-- c. 
CREATE PROCEDURE sp_2c
    @MaSP NCHAR(10), @x INT OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
        BEGIN
            SET @x = 1;
            PRINT N'Không tồn tại sản phẩm có mã ' + @MaSP;
        END
    ELSE
        BEGIN
            SET @x = 0;
            DELETE FROM Nhap WHERE MaSP = @MaSP;
            DELETE FROM Xuat WHERE MaSP = @MaSP
            DELETE FROM SanPham WHERE MaSP = @MaSP;
            PRINT N'Xóa sản phẩm thành công!';
        END
END
GO
DECLARE @result INT;
EXEC sp_2c 'SP01', @result OUTPUT;
PRINT @result;
GO 