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

SELECT * FROM HangSX;
SELECT * FROM SanPham;
SELECT * FROM NhanVien;
SELECT * FROM PNhap;
SELECT * FROM Nhap;
SELECT * FROM PXuat;
SELECT * FROM Xuat;
GO


-- a. Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 2020, 
-- gồm: SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.
CREATE VIEW vw_cau_a AS
    SELECT N.SoHDN, N.MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
    FROM Nhap N
    INNER JOIN PNhap PN ON N.SoHDN = PN.SoHDN
    INNER JOIN NhanVien NV ON PN.MaNV = NV.MaNV
    INNER JOIN SanPham SP ON N.MaSP = SP.MaSP
    INNER JOIN HangSX H ON SP.MaHangSX = H.MaHangSX
    WHERE TenHang = 'Samsung' AND YEAR(NgayNhap) = 2020;
GO 
SELECT * FROM vw_cau_a;
GO

-- b. Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng Samsung. 
CREATE VIEW vw_cau_b AS
    SELECT SP.* 
    FROM SanPham SP
    INNER JOIN HangSX H ON SP.MaHangSX = H.MaHangSX
    WHERE (GiaBan BETWEEN 100000 AND 500000) AND (TenHang = 'Samsung');
GO
SELECT * FROM vw_cau_b;
GO

-- c. Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung.  
CREATE VIEW vw_cau_c AS
    SELECT SUM(SoLuongN * DonGiaN) AS 'Tổng tiền đã nhập'
    FROM Nhap N
    INNER JOIN SanPham SP ON N.MaSP = SP.MaSP
    INNER JOIN HangSX H ON SP.MaHangSX = H.MaHangSX
    INNER JOIN PNhap PN ON N.SoHDN = PN.SoHDN
    WHERE YEAR(NgayNhap) = 2020 AND TenHang = 'Samsung';
GO
SELECT * FROM vw_cau_c;
GO

-- d. Thống kê tổng tiền đã xuất trong ngày 14/06/2020. 
CREATE VIEW vw_cau_d AS
    SELECT SUM(SoLuongX * GiaBan) AS 'Tổng tiền xuất' 
    FROM Xuat X
    INNER JOIN SanPham SP ON X.MaSP = SP.MaSP
    INNER JOIN PXuat PX ON X.SoHDX = PX.SoHDX
    WHERE NgayXuat = '06/14/2020';
GO
SELECT * FROM vw_cau_d;
GO

-- e. Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020. 
CREATE VIEW vw_cau_e AS
    SELECT TOP 1 N.SoHDN, NgayNhap, (SoLuongN * DonGiaN) AS 'Tiền nhập'
    FROM Nhap N
    INNER JOIN PNhap PN ON N.SoHDN = PN.SoHDN
    WHERE YEAR(NgayNhap) = 2020
    ORDER BY (SoLuongN * DonGiaN) ASC;
GO
SELECT * FROM vw_cau_e;
GO

-- f. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm 
CREATE VIEW vw_cau_f AS
    SELECT H.MaHangSX, H.TenHang, COUNT(MaSP) AS 'Số loại SP'
    FROM HangSX H
    INNER JOIN SanPham SP ON H.MaHangSX = SP.MaHangSX
    GROUP BY H.MaHangSX, H.TenHang;
GO
SELECT * FROM vw_cau_f;
GO

-- g. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020. 
CREATE VIEW vw_cau_g AS
    SELECT SP.MaSP, TenSP, SUM(SoLuongN * DonGiaN) AS 'Tổng tiền nhập'
    FROM SanPham SP
    INNER JOIN Nhap N ON SP.MaSP = N.MaSP
    INNER JOIN PNhap PN ON N.SoHDN = PN.SoHDN
    WHERE YEAR(NgayNhap) = 2020
    GROUP BY SP.MaSP, TenSP;
GO
SELECT * FROM vw_cau_g;
GO

-- h. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản phẩm của hãng Samsung. 
CREATE VIEW vw_cau_h AS
    SELECT SP.MaSP, TenSP
    FROM SanPham SP
    INNER JOIN HangSX H ON SP.MaHangSX = H.MaHangSX
    INNER JOIN Xuat X ON SP.MaSP = X.MaSP
    INNER JOIN PXuat PX ON X.SoHDX = PX.SoHDX
    WHERE YEAR(NgayXuat) = 2020 AND SoLuongX > 10000 AND TenHang = 'Samsung';
GO
SELECT * FROM vw_cau_h;
GO

-- i. Thống kê số lượng nhân viên Nam của mỗi phòng ban. 
CREATE VIEW vw_cau_i AS
    SELECT TenPhong, COUNT(MaNV) AS 'Số NV Nam'
    FROM NhanVien 
    WHERE GioiTinh = 'Nam'
    GROUP BY TenPhong;
GO
SELECT * FROM vw_cau_i;
GO

-- j. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018. 
CREATE VIEW vw_cau_j AS
    SELECT H.MaHangSX, TenHang, SUM(SoLuongN) AS 'Tổng SL Nhập'
    FROM HangSX H
    INNER JOIN SanPham SP ON H.MaHangSX = SP.MaHangSX
    INNER JOIN Nhap N ON SP.MaSP = N.MaSP
    INNER JOIN PNhap PN ON N.SoHDN = PN.SoHDN
    WHERE YEAR(NgayNhap) = 2018
    GROUP BY H.MaHangSX, TenHang;
GO
SELECT * FROM vw_cau_j;
GO

-- k. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.
CREATE VIEW vw_cau_k AS
    SELECT NV.MaNV, TenNV, SUM(SoLuongX * GiaBan) AS 'Tổng tiền xuất'
    FROM NhanVien NV
    INNER JOIN PXuat PX ON NV.MaNV = PX.MaNV
    INNER JOIN Xuat X ON PX.SoHDX = X.SoHDX
    INNER JOIN SanPham SP ON X.MaSP = SP.MaSP
    WHERE YEAR(NgayXuat) = 2018
    GROUP BY NV.MaNV, TenNV;
GO
SELECT * FROM vw_cau_k;
GO
