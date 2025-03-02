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

-- Bài 1. Scalar Valued Function
-- a. Hãy xây dựng hàm Đưa ra tên HangSX khi nhập vào MaSP từ bàn phím
CREATE FUNCTION fn_cau_1a(@MaSP NCHAR(10))
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @TenHang NVARCHAR(20);
    SET @TenHang = (
        SELECT TenHang
        FROM HangSX
        INNER JOIN SanPham ON HangSX.MaHangSX = SanPham.MaHangSX
        WHERE MaSP = @MaSP
    );
    RETURN @TenHang;
END;
GO
SELECT dbo.fn_cau_1a('SP01');
GO

-- b. Hãy xây dựng hàm đưa ra tổng giá trị nhập từ năm nhập x đến năm nhập y, với x, y được nhập vào từ bàn phím.
CREATE FUNCTION fn_cau_1b(@x INT, @y INT)
RETURNS MONEY
AS
BEGIN 
    DECLARE @Tong MONEY;
    SET @Tong = (
        SELECT SUM(SoLuongN * DonGiaN)
        FROM Nhap
        INNER JOIN PNhap ON Nhap.SoHDN = PNhap.SoHDN
        WHERE YEAR(NgayNhap) BETWEEN @x AND @y
    );
    RETURN @Tong;
END;
GO
SELECT dbo.fn_cau_1b(2015, 2025);
GO

-- c. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x, y nhập từ bàn phím.
CREATE FUNCTION fn_cau_1c(@x NVARCHAR(20), @y INT)
RETURNS INT
AS
BEGIN
    DECLARE @Tongnhap INT;
    DECLARE @Tongxuat INT;
    DECLARE @Thaydoi INT;
    SET @Tongnhap = (
        SELECT SUM(SoLuongN)
        FROM Nhap
        INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
        INNER JOIN PNhap ON Nhap.SoHDN = PNhap.SoHDN
        WHERE TenSP = @x AND YEAR(NgayNhap) = @y
    );
    SET @Tongxuat = (
        SELECT SUM(SoLuongX)
        FROM Xuat
        INNER JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
        INNER JOIN PXuat ON Xuat.SoHDX = PXuat.SoHDX
        WHERE TenSP = @x AND YEAR(NgayXuat) = @y
    );
    SET @Thaydoi = @Tongnhap - @Tongxuat;
    RETURN @Thaydoi;
END;
GO
SELECT dbo.fn_cau_1c('F1 Plus', 2019);
GO

-- d. Hãy xây dựng hàm đưa ra tổng giá trị nhập từ ngày nhập x đến ngày nhập y, với x, y được nhập vào từ bàn phím.
CREATE FUNCTION fn_cau_1d(@x DATETIME, @y DATETIME)
RETURNS MONEY
AS
BEGIN
    DECLARE @Result INT;
    SET @Result = (
        SELECT SUM(SoLuongN * DonGiaN)
        FROM Nhap
        INNER JOIN PNhap ON Nhap.SoHDN = PNhap.SoHDN
        WHERE NgayNhap BETWEEN @x AND @y
    );
    RETURN @Result;
END;
GO
SELECT dbo.fn_cau_1d('04-07-2020', '05-07-2020');
GO


-- Bài 2. Table Valued Function
-- a. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím. 
CREATE FUNCTION fn_cau_2a(@TenHang NVARCHAR(20))
RETURNS @Result TABLE
    (
        MaSP NCHAR(10),
        MaHangSX NCHAR(10),
        TenSP NVARCHAR(20),
        SoLuong INT,
        MauSac NVARCHAR(20),
        GiaBan MONEY,
        DonViTinh NCHAR(10),
        MoTa NVARCHAR(MAX)
    )
AS
BEGIN
    INSERT INTO @Result
    SELECT SanPham.* 
    FROM SanPham
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
    WHERE TenHang = @TenHang;
    RETURN;
END;
GO
SELECT * FROM dbo.fn_cau_2a('Samsung');
GO

-- b. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập 
-- từ ngày x đến ngày y, với x,y nhập từ bàn phím. 
CREATE FUNCTION fn_cau_2b(@x DATETIME, @y DATETIME)
RETURNS @result TABLE
    (
        MaSP NCHAR(10),
        TenSP NVARCHAR(20),
        MaHangSX NCHAR(10),
        TenHang NVARCHAR(20),
        NgayNhap DATETIME
    )
AS
BEGIN
    INSERT INTO @result
    SELECT SanPham.MaSP, TenSP, HangSX.MaHangSX, TenHang, NgayNhap
    FROM SanPham 
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
    INNER JOIN Nhap ON SanPham.MaSP = Nhap.MaSP
    INNER JOIN PNhap ON Nhap.SoHDN = PNhap.SoHDN
    WHERE NgayNhap BETWEEN @x AND @y;
    RETURN;
END;
GO
SELECT * FROM dbo.fn_cau_2b('04-07-2020', '05-07-2020');
GO

-- c. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn, 
-- nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm có SoLuong = 0, ngược lại lựa chọn = 1
-- thì Đưa ra danh sách các sản phẩm có SoLuong > 0. 
CREATE FUNCTION fn_cau_2c(@TenHang NVARCHAR(20), @choice INT)
RETURNS @result TABLE
    (
        MaSP NCHAR(10),
        TenSP NVARCHAR(20),
        SoLuong INT,
        MaHangSX NCHAR(10),
        TenHang NVARCHAR(20)
    )
AS
BEGIN
    IF(@choice = 0)
        INSERT INTO @result
        SELECT SanPham.MaSP, TenSP, SoLuong, HangSX.MaHangSX, TenHang
        FROM SanPham
        INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
        WHERE TenHang = @TenHang AND SoLuong = 0;
    ELSE IF (@choice = 1)
        INSERT INTO @result
        SELECT SanPham.MaSP, TenSP, SoLuong, HangSX.MaHangSX, TenHang
        FROM SanPham
        INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
        WHERE TenHang = @TenHang AND SoLuong > 0;
    ELSE
        INSERT INTO @result
        SELECT SanPham.MaSP, TenSP, SoLuong, HangSX.MaHangSX, TenHang
        FROM SanPham
        INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
        WHERE 1 = 0;
    RETURN;
END;
GO  
SELECT * FROM fn_cau_2c('Samsung', 1);
GO

-- d. Hãy xây dựng hàm Đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím
CREATE FUNCTION fn_cau_2d(@TenPhong NVARCHAR(30))
RETURNS @result TABLE
    (
        MaNV NCHAR(10),
        TenNV NVARCHAR(20),
        GioiTinh NCHAR(10),
        DiaChi NVARCHAR(30),
        SoDT NVARCHAR(20),
        Email NVARCHAR(30),
        TenPhong NVARCHAR(30)
    )
AS
BEGIN
    INSERT INTO @result
    SELECT *
    FROM NhanVien 
    WHERE TenPhong = @TenPhong;
    RETURN;
END;
GO
SELECT * FROM fn_cau_2d(N'Kế toán');
GO