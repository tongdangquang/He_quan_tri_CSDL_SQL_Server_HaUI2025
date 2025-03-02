USE master
GO

-- Câu a:
-- Tạo cơ sở dữ liệu
CREATE DATABASE QLBanHang
ON (
    NAME = "QLBanHang_data",
    FILENAME = "D:\file_hoc_lieu\SQL_server_HaUI\Database\QLBanHang_data.mdf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON (
    NAME = "QLBanHang_log",
    FILENAME = "D:\file_hoc_lieu\SQL_server_HaUI\Database\QLBanHang_log.ldf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE QLBanHang
GO

-- Tạo bảng CongTy
CREATE TABLE CongTy
(
    MaCT VARCHAR(10) NOT NULL PRIMARY KEY,
    TenCT NVARCHAR(50) NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL,
    ThanhPho NVARCHAR(50) NOT NULL
);

-- Tạo bảng SanPham
CREATE TABLE SanPham
(
    MaSP VARCHAR(10) NOT NULL PRIMARY KEY,
    TenSP NVARCHAR(40) NOT NULL,
    MauSac NVARCHAR(15) NOT NULL,
    Gia FLOAT NOT NULL,
    SoluongCo INT NOT NULL,
);

-- Tạo bảng Cungung
CREATE TABLE Cungung
(
    MaCT VARCHAR(10) NOT NULL,
    MaSP VARCHAR(10) NOT NULL,
    SoLuongBan INT NOT NULL,
    CONSTRAINT PK_Cungung PRIMARY KEY (MaCT, MaSP),
    CONSTRAINT FK_Cungung_MaCT FOREIGN KEY (MaCT) REFERENCES CongTy(MaCT)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT FK_Cungung_MaSP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
);
GO

-- Câu b:
-- Thêm ràng buộc cho bảng SanPham
ALTER TABLE SanPham
ADD CONSTRAINT DEFAULT_SanPham_MauSac DEFAULT N'Đỏ' FOR MauSac;

ALTER TABLE SanPham
ADD CONSTRAINT UNIQUE_SanPham_TenSP UNIQUE(TenSP);

-- Thêm ràng buộc cho bảng Cungung
ALTER TABLE Cungung
ADD CONSTRAINT CHECK_Cungung_SoLuongBan CHECK(SoLuongBan > 0);
GO

-- Câu c:
-- Nhập dữ liệu 3 công ty
INSERT INTO CongTy (MaCT, TenCT, TrangThai, ThanhPho)
VALUES 
    ('CT001', N'Công ty A', N'Hoạt động', N'Hà Nội'),
    ('CT002', N'Công ty B', N'Ngừng hoạt động', N'Hải Phòng'),
    ('CT003', N'Công ty C', N'Hoạt động', N'Đà Nẵng');

-- Nhập dữ liệu 3 sản phẩm
INSERT INTO SanPham (MaSP, TenSP, MauSac, Gia, SoluongCo)
VALUES 
    ('SP001', N'Tủ lạnh', N'Xanh', 5000000, 10),
    ('SP002', N'Máy giặt', N'Xám', 7000000, 5),
    ('SP003', N'Tivi', N'Đen', 8000000, 8);

-- Nhập dữ liệu 6 cung ứng
INSERT INTO Cungung (MaCT, MaSP, SoLuongBan)
VALUES 
    ('CT001', 'SP001', 3),
    ('CT001', 'SP002', 2),
    ('CT002', 'SP002', 1),
    ('CT002', 'SP003', 4),
    ('CT003', 'SP001', 5),
    ('CT003', 'SP003', 3);
GO

-- Câu d:
-- Hiển thị thông tin của bảng CongTy
SELECT * FROM CongTy;

-- Hiển thị thông tin của bảng SanPham
SELECT * FROM SanPham;

-- Hiển thị thông tin của bảng Cungung
SELECT * FROM Cungung;
GO