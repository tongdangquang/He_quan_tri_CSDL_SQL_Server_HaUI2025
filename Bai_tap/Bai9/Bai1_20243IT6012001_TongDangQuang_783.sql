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
CREATE PROCEDURE sp_cau_a 
    @MaHangSX NCHAR(10), @TenHang NVARCHAR(20), @DiaChi NVARCHAR(20), @SoDT NVARCHAR(20), @Email NVARCHAR(20)
AS 
BEGIN 
    IF EXISTS (SELECT * FROM HangSX WHERE MaHangSX = @MaHangSX)
        PRINT N'Mã hãng SX đã tồn tại!';
    ELSE
        BEGIN
            IF EXISTS (SELECT * FROM HangSX WHERE TenHang = @TenHang)
                PRINT N'Tên hãng đã tồn tại!';
            ELSE
                BEGIN
                    INSERT INTO HangSX (MaHangSX, TenHang, DiaChi, SoDT, Email)
                    VALUES (@MaHangSX, @TenHang, @DiaChi, @SoDT, @Email);
                    PRINT N'Thêm hãng SX thành công';
                END
        END
END
GO
EXEC dbo.sp_cau_a 'H02', N'OPPO', N'China', '081-08626262', 'oppo@gmail.com.cn';
GO

-- b. 
CREATE PROCEDURE sp_cau_b
    @MaNV NCHAR(10), @TenNV NVARCHAR(20), @GioiTinh NCHAR(10), @DiaChi NVARCHAR(30), @SoDT NVARCHAR(20), @Email NVARCHAR(30), @TenPhong NVARCHAR(30), @Flag INT
AS
BEGIN
    DECLARE @check INT;
    IF @GioiTinh != N'Nam' AND @GioiTinh != N'Nữ'
        BEGIN
            SET @check = 1;
            RETURN @check;
        END

    SET @check = 0;
    IF @Flag = 0
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
    ELSE
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
    RETURN @check;
END
GO

DECLARE @result INT;
EXEC @result = dbo.sp_cau_b 'NV01', N'Nguyễn Thanh Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@mail.com', N'Kế toán', 1;
PRINT @result;
GO

SELECT * FROM NhanVien;
GO