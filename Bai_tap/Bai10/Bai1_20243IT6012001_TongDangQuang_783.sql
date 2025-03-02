USE master;
GO
-- DROP DATABASE QLBH;

CREATE DATABASE QLBH
ON
(
    NAME = 'QLBH_data',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLBH_data.mdf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON
(
    NAME = 'QLBH_log',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLBH_log.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE QLBH;
GO

CREATE TABLE Hang 
(
    Mahang NVARCHAR(10) NOT NULL PRIMARY KEY,
    Tenhang NVARCHAR(30),
    Soluong INT,
    Giaban MONEY
);
CREATE TABLE Hoadon
(
    Mahd NVARCHAR(10) NOT NULL PRIMARY KEY,
    Mahang NVARCHAR(10),
    Soluongban INT,
    Ngayban DATETIME
    -- CONSTRAINT fk_Hoadon_Mahang FOREIGN KEY (Mahang) REFERENCES Hang(Mahang)
);
GO 

-- Chèn dữ liệu vào bảng Hang
INSERT INTO Hang (Mahang, Tenhang, Soluong, Giaban)
VALUES 
    ('H1', N'Điện thoại', 50, 5000000),
    ('H2', N'Máy tính bảng', 30, 7000000),
    ('H3', N'Laptop', 20, 15000000);
GO

-- Chèn dữ liệu vào bảng Hoadon
INSERT INTO Hoadon (Mahd, Mahang, Soluongban, Ngayban)
VALUES 
    ('HD1', 'H1', 2, '2025-02-10'),
    ('HD2', 'H2', 1, '2025-02-09'),
    ('HD3', 'H3', 1, '2025-02-08');
GO

-- Bài tâp:
CREATE TRIGGER trg_insert_Hoadon
ON Hoadon
FOR INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Hang INNER JOIN inserted ON Hang.Mahang = inserted.Mahang)
    BEGIN
        RAISERROR(N'Mahang không tồn tại!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM Hang h INNER JOIN inserted i ON h.Mahang = i.Mahang WHERE h.Soluong >= i.Soluongban)
    BEGIN
        RAISERROR(N'Yêu cầu Soluongban <= Soluong!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE Hang
    SET Soluong = Soluong - i.Soluongban
    FROM Hang h
    INNER JOIN inserted i ON h.Mahang = i.Mahang;
END
GO

-- Kiểm tra trigger
INSERT INTO Hoadon VALUES ('HD4', 'H7', 3, '2025-02-08');
SELECT * FROM Hang;
SELECT * FROM Hoadon;
GO