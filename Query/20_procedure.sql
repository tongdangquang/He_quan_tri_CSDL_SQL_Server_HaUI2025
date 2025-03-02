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

-- 1. Sự khác nhau giữa Procedure và Function
-- Procedure dùng để thực hiện những tác vụ phức tạp mà function không làm được
-- Procedure không bắt buộc phải trả về giá trị như function (function bắt buộc trả về giá trị hoặc trả về bảng)
-- Procedure có thể truy cập và làm thay đổi dữ liệu gốc còn function thì không
-- Dùng lệnh EXEC để thực thi Procedure chứ không thể thực thi trực tiếp trong SELECT FROM WHERE như function


-- 2. Cấu trúc của 1 Procdure
    -- CREATE PROCEDURE UpdateCustomerBalance
    -- @CustomerID INT,
    -- @NewBalance DECIMAL(10, 2)
    -- AS
    -- BEGIN
    --     UPDATE Customer
    --     SET Balance = @NewBalance
    --     WHERE CustomerID = @CustomerID;
    -- END;


-- 3. Tạo Procdure
-- 3.1. Tạo Stored Procedure đơn giản
-- Hiển thị danh sách tất cả các sản phẩm
CREATE PROCEDURE sp_3_1
AS
BEGIN
    SELECT * FROM SanPham;
END;
GO
EXEC sp_3_1;
GO
    
-- 3.2. Tạo Stored Procedure có tham số đầu vào
-- Hiển thị các sản phẩm của hãng có tên là x với x được nhập từ bàn phím
CREATE PROCEDURE sp_3_2
    @x NVARCHAR(20)
AS
BEGIN 
    SELECT MaSP, TenSP, SanPham.MaHangSX, TenHang
    FROM SanPham
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
    WHERE TenHang = @x;
END;
GO
EXEC sp_3_2 'Oppo';
GO

-- 3.3. Tạo Stored Procedure có tham số đầu ra
-- a. Đếm số sản phẩm của hãng có tên là x với x được nhập từ bàn phím
-- Dùng OUTPUT để trả về kết quả
CREATE PROCEDURE sp_3_3_a1
    @x NVARCHAR(20), @result INT OUTPUT
AS
BEGIN
    SELECT @result = COUNT(MaSP)
    FROM SanPham
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
    WHERE TenHang = @x;
END;
GO
DECLARE @result INT;
EXEC sp_3_3_a1 'Vinfone', @result OUTPUT;
PRINT @result;
GO 

-- Dùng RETURN để trả về kết quả
CREATE PROCEDURE sp_3_3_a2
    @x NVARCHAR(20)
AS
BEGIN
    DECLARE @count INT;
    SELECT @count = COUNT(MaSP)
    FROM SanPham
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
    WHERE TenHang = @x;
    RETURN @count;
END;
GO
-- Gọi procedure và lấy giá trị từ RETURN
DECLARE @result2 INT;
EXEC @result2 = sp_3_3_a2 'Vinfone';
PRINT @result2;
GO


-- b. Hãy tạo Stored Procedure đưa ra thông tin các sản phẩm có giá bán >= x và do hãng y cung ứng. Với x, y nhập từ bàn phím.
CREATE PROCEDURE sp_3_3_b
    @x MONEY, @y NVARCHAR(20)
AS
BEGIN 
    SELECT SanPham.* 
    FROM SanPham 
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
    WHERE GiaBan >= @x AND TenHang = @y;
END;
GO
EXEC sp_3_3_b 1500000, 'Samsung';
GO

-- 3.4. Stored Procedure có điều kiện và xử lý lỗi
-- Hãy tạo Stored Procedure thêm 1 sản phẩm mới vào bảng sản phẩm
CREATE PROCEDURE sp_3_4
    @MaSP NCHAR(10),
    @MaHangSX NCHAR(10),
    @TenSP NVARCHAR(20),
    @SoLuong INT,
    @MauSac NVARCHAR(20),
    @GiaBan MONEY,
    @DonViTinh NCHAR(10),
    @MoTa NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra nếu MaSP cần thêm đã tồn tại
        IF EXISTS(SELECT MaSP FROM SanPham WHERE MaSP = @MaSP)
            BEGIN -- dùng cặp BEGIN ... END vì sau IF, ELSE IF, ELSE chỉ đi kèm với duy nhất 1 câu lệnh hoặc 1 cặp lệnh
                PRINT N'Mã sản phẩm đã tồn tại!';
                RETURN; -- dùng RETURN để thoát Stored Procedure luôn mà không chạy các lệnh phía sau
            END

        -- Kiểm tra nếu MaHangSX cần thêm không tồn tại
        IF NOT EXISTS(SELECT MaHangSX FROM HangSX WHERE MaHangSX = @MaHangSX)
            BEGIN
                PRINT N'MaHangSX không tồn tại!';
                RETURN;
            END

        -- Khi ckeck không có lỗi thì sẽ tiến hành thêm sản phẩm và thông báo khi thêm thành công
        INSERT INTO SanPham(MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
        VALUES(@MaSP, @MaHangSX, @TenSP, @SoLuong, @MauSac, @GiaBan, @DonViTinh, @MoTa);
        PRINT N'Thêm sản phẩm thành công!';
    END TRY

    -- Sử dụng TRY CATCH để bắt lỗi ngoại lệ như trong lập trình ví dụ như sai kiểu dữ liệu, thiếu dữ liệu, lỗi hệ thống,...
    BEGIN CATCH
        PRINT(N'Có lỗi xảy ra, thêm sản phẩm không thành công!');
    END CATCH
END;
GO
EXEC sp_3_4 'SP07', 'H03', N'OPPO Reno8', 100, N'Xanh', 12000000, N'Chiếc', N'Mẫu mới nhất';
GO


-- 4. ALTER PROCEDURE: Cập nhật Stored Procedure
-- Ví dụ: sửa sp_3_1 từ hiện thị toàn bộ thông tin thành chỉ hiển thị MaSP và TenSP
ALTER PROCEDURE sp_3_1
AS
BEGIN
    SELECT MaSP, TenSP
    FROM SanPham;
END;
GO
EXEC sp_3_1;
GO


-- 5. DROP PROCEDURE: Xóa Stored Procedure
DROP PROCEDURE sp_3_1;
GO
