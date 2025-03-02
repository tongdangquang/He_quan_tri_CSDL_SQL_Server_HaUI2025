USE master
GO

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

CREATE TABLE HangSX
(
    MaHangSX NCHAR(10) NOT NULL PRIMARY KEY,
    TenHang NVARCHAR(20) NOT NULL,
    DiaChi NVARCHAR(20),
    SoDT NVARCHAR(20),
    Email NVARCHAR(20)
);

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

CREATE TABLE PNhap
(
    SoHDN NCHAR(10) NOT NULL PRIMARY KEY,
    NgayNhap DATE,
    MaNV NCHAR(10),
    CONSTRAINT FK_PNhap_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

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

CREATE TABLE PXuat
(
    SoHDX NCHAR(10) NOT NULL PRIMARY KEY,
    NgayXuat DATE,
    MaNV NCHAR(10),
    CONSTRAINT FK_PXuat_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

CREATE TABLE Xuat
(
    SoHDX NCHAR(10) NOT NULL,
    MaSP NCHAR(10) NOT NULL,
    SoLuongX INT,
    CONSTRAINT PK_Xuat PRIMARY KEY (SoHDX, MaSP),
    CONSTRAINT FK_Nhap_SoHDX FOREIGN KEY (SoHDX) REFERENCES PXuat(SoHDX),
    CONSTRAINT FK_Xuat_MaSP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
GO

-- Nhập dữ liệu cho bảng HangSX
INSERT INTO HangSX (MaHangSX, TenHang, DiaChi, SoDT, Email)
VALUES
('HSX001', N'Samsung', N'Hà Nội', '0123456789', 'samsung@mail.com'),
('HSX002', N'Apple', N'Hồ Chí Minh', '0987654321', 'apple@mail.com'),
('HSX003', N'Sony', N'Đà Nẵng', '0345678912', 'sony@mail.com');

-- Nhập dữ liệu cho bảng SanPham
INSERT INTO SanPham (MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
VALUES
('SP001', 'HSX001', N'Tivi Samsung', 10, N'Đen', 10000000, N'Cái', N'Tivi 4K'),
('SP002', 'HSX002', N'iPhone 13', 20, N'Trắng', 20000000, N'Cái', N'Smartphone cao cấp'),
('SP003', 'HSX003', N'Tai nghe Sony', 30, N'Xanh', 3000000, N'Cái', N'Tai nghe chống ồn');

-- Nhập dữ liệu cho bảng NhanVien
INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
VALUES
('NV001', N'Nguyễn Văn A', N'Nam', N'Hà Nội', '0912345678', 'vana@mail.com', N'Phòng Kinh Doanh'),
('NV002', N'Trần Thị B', N'Nữ', N'Hồ Chí Minh', '0923456789', 'thib@mail.com', N'Phòng Kỹ Thuật'),
('NV003', N'Lê Văn C', N'Nam', N'Đà Nẵng', '0934567890', 'vanc@mail.com', N'Phòng Hành Chính');

-- Nhập dữ liệu cho bảng PNhap
INSERT INTO PNhap (SoHDN, NgayNhap, MaNV)
VALUES
('HDN001', '2024-01-01', 'NV001'),
('HDN002', '2024-01-02', 'NV002'),
('HDN003', '2024-01-03', 'NV003');

-- Nhập dữ liệu cho bảng Nhap
INSERT INTO Nhap (SoHDN, MaSP, SoLuongN, DonGiaN)
VALUES
('HDN001', 'SP001', 5, 9500000),
('HDN002', 'SP002', 10, 19000000),
('HDN003', 'SP003', 15, 2800000);

-- Nhập dữ liệu cho bảng PXuat
INSERT INTO PXuat (SoHDX, NgayXuat, MaNV)
VALUES
('HDX001', '2024-01-05', 'NV001'),
('HDX002', '2024-01-06', 'NV002'),
('HDX003', '2024-01-07', 'NV003');

-- Nhập dữ liệu cho bảng Xuat
INSERT INTO Xuat (SoHDX, MaSP, SoLuongX)
VALUES
('HDX001', 'SP001', 2),
('HDX002', 'SP002', 5),
('HDX003', 'SP003', 10);
GO

SELECT * FROM HangSX;
SELECT * FROM SanPham;
SELECT * FROM NhanVien;
SELECT * FROM PNhap;
SELECT * FROM Nhap;
SELECT * FROM PXuat;
SELECT * FROM Xuat;
GO