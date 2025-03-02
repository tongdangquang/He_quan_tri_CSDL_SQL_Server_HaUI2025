-- Bài 1. Tạo cơ sở dữ liệu QLKHO
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


-- Bài 2. 
CREATE VIEW ThongKeTienBan AS
    SELECT Xuat.MaVT, TenVT, SUM(SoLuongX*DonGiaX) AS 'TienBan'
    FROM Ton
    INNER JOIN Xuat ON Ton.MaVT = Xuat.MaVT
    GROUP BY Xuat.MaVT, TenVT;
GO

SELECT * FROM ThongKeTienBan;
GO

-- Bài 3.
CREATE VIEW ThongKeSoLuongXuat AS
    SELECT TenVT, SUM(SoLuongX) AS 'Số lượng xuất'
    FROM Ton 
    INNER JOIN Xuat ON Ton.MaVT = Xuat.MaVT
    GROUP BY TenVT;
GO

SELECT * FROM ThongKeSoLuongXuat;
GO

-- Bài 4. 
CREATE VIEW ThongKeSoLuongNhap AS
    SELECT TenVT, SUM(SoLuongN) AS 'Số lượng nhập'
    FROM Ton 
    INNER JOIN Nhap ON Ton.MaVT = Nhap.MaVT
    GROUP BY TenVT;
GO

SELECT * FROM ThongKeSoLuongNhap;
GO

-- Bài 5.
CREATE VIEW ThongKeSoLuongConLai AS
    SELECT T.MaVT, TenVT, SUM(SoLuongN) - SUM(SoLuongX) + SUM(SoLuongT) AS 'Số lượng còn lại'
    FROM Ton T
    INNER JOIN Nhap N ON T.MaVT = N.MaVT
    INNER JOIN Xuat X ON T.MaVT = X.MaVT
    GROUP BY T.MaVT, TenVT;
GO

SELECT * FROM ThongKeSoLuongConLai;
GO
