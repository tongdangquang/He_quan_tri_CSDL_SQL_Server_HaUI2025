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

-- a. Hãy tạo hàm Đưa ra danh sách các hãng sản xuất có địa chỉ nhập vào từ bàn phím (Lưu ý – Dùng hàm Like để lọc). 
CREATE FUNCTION fn_cau_a(@x NVARCHAR(20))
RETURNS TABLE
AS  
RETURN
(
    SELECT *
    FROM HangSX
    WHERE DiaChi LIKE CONCAT('%', @x, '%')
);
GO
SELECT * FROM dbo.fn_cau_a(N'Việt nam');
GO

-- b. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được xuất từ năm x đến năm y, với x, y nhập từ bàn phím. 
CREATE FUNCTION fn_cau_b(@x INT, @y INT)
RETURNS TABLE
AS
RETURN
(
    SELECT S.*, H.TenHang
    FROM SanPham S
    INNER JOIN HangSX H ON S.MaHangSX = H.MaHangSX
    INNER JOIN Xuat X ON S.MaSP = X.MaSP
    INNER JOIN PXuat P ON X.SoHDX = P.SoHDX
    WHERE YEAR(NgayXuat) BETWEEN @x AND @y
);
GO
SELECT * FROM dbo.fn_cau_b(2019, 2020);
GO

-- c. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn, nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm đã được nhập, ngược lại lựa chọn = 1 thì Đưa ra danh sách các sản phẩm đã được xuất. 
CREATE FUNCTION fn_cau_c(@x NVARCHAR(20), @y INT)
RETURNS @result TABLE
    (
        MaSP NCHAR(10),
        MaHangSX NCHAR(10),
        TenSP NVARCHAR(20),
        SoLuong INT,
        MauSac NVARCHAR(20),
        GiaBan MONEY,
        DonViTinh NCHAR(10),
        MoTa NVARCHAR(MAX),
        TenHang NVARCHAR(20)
    )
AS 
BEGIN 
    IF @y = 0
        INSERT INTO @result
        SELECT S.*, H.TenHang
        FROM SanPham S
        INNER JOIN HangSX H ON S.MaHangSX = H.MaHangSX
        INNER JOIN Nhap N ON S.MaSP = N.MaSP
        WHERE TenHang = @x;
    ELSE IF @y = 1
        INSERT INTO @result
        SELECT S.*, H.TenHang
        FROM SanPham S
        INNER JOIN HangSX H ON S.MaHangSX = H.MaHangSX
        INNER JOIN Xuat X ON S.MaSP = X.MaSP
        WHERE TenHang = @x;
    ELSE
        INSERT INTO @result
        SELECT S.*, H.TenHang
        FROM SanPham S
        INNER JOIN HangSX H ON S.MaHangSX = H.MaHangSX
        INNER JOIN Xuat X ON S.MaSP = X.MaSP
        WHERE 1 = 0;
    RETURN;
END;
GO
SELECT * FROM dbo.fn_cau_c('Samsung', 0);
GO

-- d. Hãy xây dựng hàm Đưa ra danh sách các nhân viên đã nhập hàng vào ngày được đưa vào từ bàn phím. 
CREATE FUNCTION fn_cau_d(@x DATETIME)
RETURNS TABLE
AS
RETURN
(
    SELECT NV.*
    FROM NhanVien NV
    INNER JOIN PNhap P ON NV.MaNV = P.MaNV
    WHERE NgayNhap = @x
);
GO
SELECT * FROM fn_cau_d('04-07-2020');
GO

-- e. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm có giá bán từ x đến y, do công ty z sản xuất, với x, y, z nhập từ bàn phím. 
CREATE FUNCTION fn_cau_e(@x MONEY, @y MONEY, @z NVARCHAR(20))
RETURNS TABLE
AS
RETURN
(
    SELECT S.*
    FROM SanPham S
    INNER JOIN HangSX H ON S.MaHangSX = H.MaHangSX
    WHERE (GiaBan BETWEEN @x AND @y) AND (TenHang = @z)
);
GO
SELECT * FROM dbo.fn_cau_e(3000000, 19000000, N'Samsung');
GO

-- f. Hãy xây dựng hàm không tham biến Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng.
CREATE FUNCTION fn_cau_f()
RETURNS TABLE
AS
RETURN
(
    SELECT MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa, H.MaHangSX, TenHang, DiaChi, SoDT, Email  
    FROM SanPham S
    INNER JOIN HangSX H ON S.MaHangSX = H.MaHangSX
);
GO
SELECT * FROM dbo.fn_cau_f();
GO
