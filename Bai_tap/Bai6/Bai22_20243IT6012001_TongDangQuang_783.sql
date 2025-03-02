-- Câu 1. Tạo cơ sở dữ liệu QLKHO
USE master;
GO

CREATE DATABASE QLKHO
ON(
    NAME = 'QLMKHO_data',
    FILENAME = 'D:\TongDangQuang_2022603783\QLKHO_data.mdf',
    SIZE = 1MB, 
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON(
    NAME = 'QLMKHO_log',
    FILENAME = 'D:\TongDangQuang_2022603783\QLKHO_log.ldf',
    SIZE = 1MB, 
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE QLKHO;
GO

CREATE TABLE Ton
(
    MaVT CHAR(10) NOT NULL PRIMARY KEY,
    TenVT NVARCHAR(30),
    SoLuongT INT
);
GO

-- Tạo các bảng dữ liệu
CREATE TABLE Nhap
(
    SoHDN CHAR(10) NOT NULL,
    MaVT CHAR(10) NOT NULL,
    SoLuongN INT,
    DonGiaN MONEY,
    NgayN DATETIME,
    CONSTRAINT PK_Nhap PRIMARY KEY(SoHDN, MaVT),
    CONSTRAINT FK_Nhap_MaVT FOREIGN KEY (MaVT) REFERENCES Ton(MaVT)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
GO

CREATE TABLE Xuat
(
    SoHDX CHAR(10) NOT NULL,
    MaVT CHAR(10) NOT NULL,
    SoLuongX INT,
    DonGiaX MONEY,
    NgayX DATETIME,
    CONSTRAINT PK_Xuat PRIMARY KEY(SoHDX, MaVT),
    CONSTRAINT FK_Xuat_MaVT FOREIGN KEY (MaVT) REFERENCES Ton(MaVT)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
GO

-- Chèn dữ liệu vào bảng Ton
INSERT INTO Ton (MaVT, TenVT, SoLuongT)
VALUES
('VT001', N'Vật tư A', 50),
('VT002', N'Vật tư B', 100),
('VT003', N'Vật tư C', 75),
('VT004', N'Vật tư D', 150),
('VT005', N'Vật tư E', 200);

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
GO

-- Câu 2.
CREATE VIEW vw_cau_2 AS
    SELECT TOP 1 TenVT
    FROM Ton
    ORDER BY SoLuongT ASC;
GO
SELECT * FROM vw_cau_2;
GO 

-- Câu 3.
CREATE VIEW vw_cau_3 AS
    SELECT MaVT, SUM(SoLuongX) AS 'Tổng SL xuất'
    FROM Xuat
    GROUP BY MaVT
    HAVING SUM(SoLuongX) > 100;
GO
SELECT * FROM vw_cau_3;
GO 

-- Câu 4.
CREATE VIEW vw_cau_4 AS
    SELECT MONTH(NgayX) AS 'Tháng Xuất', YEAR(NgayX) AS 'Năm Xuất', SUM(SoLuongX) AS 'Tổng SL Xuất'
    FROM Xuat
    GROUP BY MONTH(NgayX), YEAR(NgayX);
GO
SELECT * FROM vw_cau_4;
GO

-- Câu 5. 
CREATE VIEW vw_cau_5 AS
    SELECT Ton.MaVT, TenVT, SoLuongN, SoLuongX, DonGiaN, DonGiaX, NgayN, NgayX
    FROM Ton
    INNER JOIN Nhap ON Ton.MaVT = Nhap.MaVT
    INNER JOIN Xuat ON Ton.MaVT = Xuat.MaVT;
GO
SELECT * FROM vw_cau_5;
GO

-- Câu 6.
CREATE VIEW vw_cau_6 AS
    SELECT Ton.MaVT, TenVT, SUM(SoluongN - SoLuongX + SoLuongT) AS 'Tổng SL còn lại'
    FROM Ton
    INNER JOIN Nhap ON Ton.MaVT = Nhap.MaVT
    INNER JOIN Xuat ON Ton.MaVT = Xuat.MaVT
    WHERE YEAR(NgayN) = 2015 AND YEAR(NgayX) = 2015
    GROUP BY Ton.MaVT, TenVT;
GO
SELECT * FROM vw_cau_6;
GO



