-- Tạo cơ sở dữ liệu QLKHO
USE master;
GO

CREATE DATABASE QLKHO
ON(
    NAME = 'QLMKHO_data',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLKHO_data.mdf',
    SIZE = 1MB, 
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON(
    NAME = 'QLMKHO_log',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLKHO_log.ldf',
    SIZE = 1MB, 
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE QLKHO;
GO

-- Tạo các bảng dữ liệu
CREATE TABLE Nhap
(
    SoHDN CHAR(10) NOT NULL,
    MaVT CHAR(10) NOT NULL,
    SoLuongN INT,
    DonGiaN MONEY,
    NgayN DATETIME,
    CONSTRAINT PK_Nhap PRIMARY KEY(SoHDN, MaVT)
);
GO

CREATE TABLE Xuat
(
    SoHDX CHAR(10) NOT NULL,
    MaVT CHAR(10) NOT NULL,
    SoLuongX INT,
    DonGiaX MONEY,
    NgayX DATETIME,
    CONSTRAINT PK_Xuat PRIMARY KEY(SoHDX, MaVT)
);
GO

CREATE TABLE Ton
(
    MaVT CHAR(10) NOT NULL PRIMARY KEY,
    TenVT NVARCHAR(30),
    SoLuongT INT
);
GO

-- Chèn dữ liệu vào bảng Nhap
INSERT INTO Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN)
VALUES
('HDN001', 'VT001', 100, 15000, '2025-01-10'),
('HDN002', 'VT002', 200, 20000, '2025-01-11'),
('HDN003', 'VT003', 150, 18000, '2025-01-12');

-- Chèn dữ liệu vào bảng Xuat
INSERT INTO Xuat (SoHDX, MaVT, SoLuongX, DonGiaX, NgayX)
VALUES
('HDX001', 'VT001', 50, 16000, '2025-01-14'),
('HDX002', 'VT002', 100, 21000, '2025-01-15');

-- Chèn dữ liệu vào bảng Ton
INSERT INTO Ton (MaVT, TenVT, SoLuongT)
VALUES
('VT001', N'Vật tư A', 50),
('VT002', N'Vật tư B', 100),
('VT003', N'Vật tư C', 75),
('VT004', N'Vật tư D', 150),
('VT005', N'Vật tư E', 200);
GO


-- I. Có ba loại function chính trong SQL Server:
    -- 1. Scalar Function (Hàm vô hướng): Trả về một giá trị đơn lẻ.
    -- 2. Table-Valued Function (Hàm trả về bảng): Trả về một tập hợp dữ liệu dạng bảng.
    -- 3. Inline Table-Valued Function (Hàm bảng không định nghĩa trước - hàm nội tuyến): Tương tự table-valued nhưng không có phần khai báo biến.
-- Các hàm không thể thực hiện các lệnh thay đổi dữ liệu như INSERT, UPDATE, DELETE.
-- Thích hợp cho việc xử lý và truy vấn dữ liệu mà không làm thay đổi cơ sở dữ liệu.

-- VD1. Scalar Function (Hàm vô hướng)
-- Hàm tính tổng giá trị nhập kho cho một mã vật tư.
CREATE FUNCTION dbo.TinhTongNhap(@MaVT CHAR(10))
RETURNS MONEY
AS
BEGIN
    DECLARE @TongTien MONEY;
    SELECT @TongTien = SUM(SoLuongN * DonGiaN)
    FROM Nhap
    WHERE MaVT = @MaVT;
    RETURN @TongTien;
END;
GO
-- Gọi hàm
SELECT *, dbo.TinhTongNhap(MaVT) AS 'Tổng tiền'
FROM Nhap;
GO


-- VD2. Table-Valued Function (Hàm trả về bảng)
-- Hàm trả về phiếu nhập theo tháng chỉ định.
CREATE FUNCTION dbo.LayPhieuNhapTrongThang(@Thang INT, @Nam INT)
RETURNS @KetQua TABLE
(
    SoHDN CHAR(10),
    MaVT CHAR(10),
    SoLuongN INT,
    DonGiaN MONEY,
    NgayN DATETIME
)
AS
BEGIN
    INSERT INTO @KetQua
    SELECT SoHDN, MaVT, SoLuongN, DonGiaN, NgayN
    FROM Nhap
    WHERE MONTH(NgayN) = @Thang AND YEAR(NgayN) = @Nam;
    
    RETURN;
END;
GO
-- Gọi hàm
SELECT * FROM dbo.LayPhieuNhapTrongThang(1, 2025);
GO


-- VD3. Inline Table-Valued Function (Hàm bảng không định nghĩa trước - hàm nội tuyến)
-- Hàm trả về danh sách các phiếu nhập trong tháng hiện tại.
CREATE FUNCTION dbo.DanhSachPhieuNhapTrongThang()
RETURNS TABLE
AS
RETURN
(
    SELECT * 
    FROM Nhap
    WHERE MONTH(NgayN) = MONTH(GETDATE()) AND YEAR(NgayN) = YEAR(GETDATE())
);
GO
-- Gọi hàm
SELECT * FROM dbo.DanhSachPhieuNhapTrongThang();
GO


-- II. ALTER FUNCTION: được sử dụng để sửa đổi (cập nhật) một hàm đã tồn tại mà không cần xóa
--  Lưu ý:
    -- Chỉ có thể sửa đổi hàm do người dùng tạo (User-defined function - UDF), không áp dụng cho hàm hệ thống.
    -- Cú pháp ALTER FUNCTION phải khớp với kiểu dữ liệu trả về và các tham số gốc của hàm.

-- a. Sửa đổi Scalar-Valued Function:
-- Bạn có một hàm fn_GetProductPrice trả về giá của một sản phẩm theo MaSP. Bây giờ, bạn muốn thay đổi hàm để trả về giá kèm theo đơn vị tiền tệ (VND).
CREATE FUNCTION fn_GetProductPrice(@MaSP NCHAR(10))
RETURNS MONEY
AS
BEGIN
    DECLARE @Gia MONEY;
    SET @Gia = (SELECT GiaBan FROM SanPham WHERE MaSP = @MaSP);
    RETURN @Gia;
END;
GO

-- Dùng ALTER FUNCTION để sửa đổi:
ALTER FUNCTION fn_GetProductPrice(@MaSP NCHAR(10))
RETURNS NVARCHAR(50)  -- Sửa đổi kiểu trả về từ MONEY → NVARCHAR(50)
AS
BEGIN
    DECLARE @Gia NVARCHAR(50);
    SELECT @Gia = CAST(GiaBan AS NVARCHAR) + ' VND'
    FROM SanPham 
    WHERE MaSP = @MaSP;
    RETURN @Gia;
END;

GO
SELECT dbo.fn_GetProductPrice('SP01'); 
GO


-- b. Sửa đổi Inline Table-Valued Function
-- Bạn có một hàm fn_SanPhamTheoHang hiển thị sản phẩm theo hãng sản xuất. Bây giờ, bạn muốn sửa đổi nó để chỉ hiển thị các sản phẩm có số lượng > 0.
CREATE FUNCTION fn_SanPhamTheoHang(@TenHang NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT MaSP, TenSP, SoLuong, GiaBan, DonViTinh
    FROM SanPham
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
    WHERE TenHang = @TenHang
);
GO

-- Dùng ALTER FUNCTION để sửa đổi:
ALTER FUNCTION fn_SanPhamTheoHang(@TenHang NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT MaSP, TenSP, SoLuong, GiaBan, DonViTinh
    FROM SanPham
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
    WHERE TenHang = @TenHang AND SoLuong > 0  -- Thêm điều kiện lọc
);
GO

SELECT * FROM fn_SanPhamTheoHang('Samsung');
GO

-- III. DROP FUNCTION: được sử dụng để xóa (xóa vĩnh viễn) một hàm do người dùng tạo ra
DROP FUNCTION fn_GetProductPrice;
DROP FUNCTION fn_SanPhamTheoHang;
GO