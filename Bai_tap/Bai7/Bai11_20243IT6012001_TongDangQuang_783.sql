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

-- Nhập dữ liệu cho bảng HangSX
INSERT INTO HangSX (MaHangSX, TenHang, DiaChi, SoDT, Email)
VALUES
('H01', N'Samsung', N'Korea', '011-08271717', 'ss@gmail.com.kr'),
('H02', N'OPPO', N'China', '081-08626262', 'oppo@gmail.com.cn'),
('H03', N'Vinfone', N'Việt nam', '084-098262626', 'vf@gmail.com.vn');

-- Nhập dữ liệu cho bảng SanPham
INSERT INTO SanPham (MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
VALUES
('SP01', 'H02', N'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
('SP02', 'H01', N'Galaxy Note 11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'),
('SP03', 'H02', N'F3 Lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
('SP04', 'H03', N'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông'),
('SP05', 'H01', N'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp');

-- Nhập dữ liệu cho bảng NhanVien
INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
VALUES
('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@mail.com', N'Kế toán'),
('NV02', N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252', 'nam@mail.com', N'Vật tư'),
('NV03', N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0328388388', 'hb@mail.com', N'Kế toán');

-- Nhập dữ liệu cho bảng PNhap
INSERT INTO PNhap (SoHDN, NgayNhap, MaNV)
VALUES
('N01', '02-05-2019', 'NV01'),
('N02', '04-07-2020', 'NV02'),
('N03', '05-17-2020', 'NV02'),
('N04', '03-22-2020', 'NV03'),
('N05', '07-07-2020', 'NV01');

-- Nhập dữ liệu cho bảng Nhap
INSERT INTO Nhap (SoHDN, MaSP, SoLuongN, DonGiaN)
VALUES
('N01', 'SP02', 10, 17000000),
('N02', 'SP01', 30, 6000000),
('N03', 'SP04', 20, 1200000),
('N04', 'SP01', 10, 6200000),
('N05', 'SP05', 20, 7000000);

-- Nhập dữ liệu cho bảng PXuat
INSERT INTO PXuat (SoHDX, NgayXuat, MaNV)
VALUES
('X01', '06-14-2020', 'NV02'),
('X02', '03-05-2019', 'NV03'),
('X03', '12-12-2020', 'NV01'),
('X04', '06-02-2020', 'NV02'),
('X05', '05-18-2020', 'NV01');

-- Nhập dữ liệu cho bảng Xuat
INSERT INTO Xuat (SoHDX, MaSP, SoLuongX)
VALUES
('X01', 'SP03', 5),
('X02', 'SP01', 3),
('X03', 'SP02', 1),
('X04', 'SP03', 2),
('X05', 'SP05', 1);
GO

-- a. Hãy xây dựng hàm Đưa ra tổng giá trị xuất của hãng tên hãng là A, trong năm x, với A, x được nhập từ bàn phím. 
CREATE FUNCTION fn_cau_a(@A NVARCHAR(20), @x INT)
RETURNS MONEY
AS
BEGIN 
    DECLARE @tong MONEY;
    SELECT @tong = SUM(SoLuongX * GiaBan)
    FROM HangSX H
    INNER JOIN SanPham S ON H.MaHangSX = S.MaHangSX
    INNER JOIN Xuat X ON S.MaSP = X.MaSP
    INNER JOIN PXuat P ON X.SoHDX = P.SoHDX
    WHERE TenHang = @A AND YEAR(NgayXuat) = @x;
    RETURN @tong;
END;
GO
SELECT dbo.fn_cau_a('Samsung', 2020);
GO

-- b. Hãy xây dựng hàm thống kê số lượng nhân viên mỗi phòng với tên phòng nhập từ bàn phím. 
CREATE FUNCTION fn_cau_b(@TenPhong NVARCHAR(30))
RETURNS INT
AS
BEGIN 
    DECLARE @result INT;
    SELECT @result = COUNT(MaNV) 
    FROM NhanVien
    WHERE TenPhong = @TenPhong;
    RETURN @result;
END;
GO
SELECT DISTINCT TenPhong, dbo.fn_cau_b(TenPhong) AS 'Số NV'
FROM NhanVien;
GO

-- c. Hãy viết hàm thống kê xem tên sản phẩm x đã xuất được bao nhiêu sản phẩm trong ngày y, với x, y nhập từ bản phím. 
CREATE FUNCTION fn_cau_c(@x NVARCHAR(20), @y DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @result INT;
    SELECT @result = SUM(SoLuongX)
    FROM Xuat X
    INNER JOIN PXuat P ON X.SoHDX = P.SoHDX
    INNER JOIN SanPham S ON X.MaSP = S.MaSP
    WHERE TenSP = @x AND NgayXuat = @y;
    RETURN @result;
END;
GO
SELECT dbo.fn_cau_c(N'F1 Plus', '03-05-2019');
GO

-- d. Hãy viết hàm trả về số điện thoại của nhân viên đã xuất số hóa đơn x, với x nhập từ bàn phím. 
CREATE FUNCTION fn_cau_d(@x NCHAR(10))
RETURNS NVARCHAR(20)
AS
BEGIN 
    DECLARE @result NVARCHAR(20);
    SET @result = ( SELECT SoDT
                    FROM NhanVien N
                    INNER JOIN PXuat P ON N.MaNV = P.MaNV
                    WHERE SoHDX = @x);
    RETURN @result;
END;
GO
SELECT dbo.fn_cau_d('X01');
GO

-- e. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x, y nhập từ bàn phím. 
CREATE FUNCTION fn_cau_e(@x NVARCHAR(20), @y INT)
RETURNS INT
AS
BEGIN
    DECLARE @tongnhap INT, @tongxuat INT, @thaydoi INT;
    SELECT @tongnhap = SUM(SoLuongN), @tongxuat = SUM(SoLuongX)
    FROM SanPham S
    INNER JOIN Nhap N ON S.MaSP = N.MaSP
    INNER JOIN PNhap PN ON N.SoHDN = PN.SoHDN
    INNER JOIN Xuat X ON S.MaSP = X.MaSP
    INNER JOIN PXuat PX ON X.SoHDX = PX.SoHDX
    WHERE TenSP = @x AND YEAR(NgayNhap) = @y AND YEAR(NgayXuat) = @y;
    SET @thaydoi = @tongnhap - @tongxuat;
    RETURN @thaydoi;
END;
GO
SELECT dbo.fn_cau_e(N'F1 Plus', 2020);
GO

-- f. Hãy viết hàm thống kê tổng số lượng sản phầm của hãng x, với tên hãng nhập từ bàn phím. 
CREATE FUNCTION fn_cau_f(@x NVARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @result INT;
    SELECT @result = COUNT(MaSP)
    FROM HangSX H
    INNER JOIN SanPham S ON H.MaHangSX = S.MaHangSX
    WHERE TenHang = @x;
    RETURN @result;
END;
GO
SELECT dbo.fn_cau_f(N'Samsung');
GO
