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

-- Câu 1. Viết trigger kiểm soát việc Delete bảng HOADON, hãy cập nhật lại 
-- Soluong trong bảng HANG với: SOLUONG =SOLUONG + DELETED.SOLUONGBAN
CREATE TRIGGER trg_delete_Hoadon
ON Hoadon
FOR DELETE
AS
BEGIN
    UPDATE Hang
    SET Soluong = Soluong + d.Soluongban
    FROM Hang
    INNER JOIN deleted d ON Hang.Mahang = d.Mahang;
END
GO
-- Kiểm tra kết quả của trigger
DELETE FROM Hoadon
WHERE Mahd = 'HD1';
SELECT * FROM Hang;
SELECT * FROM Hoadon;
GO


-- Câu 2. Hãy viết trigger kiểm soát việc Update bảng HOADON. Khi đó hãy update lại soluong trong bảng HANG. 
CREATE TRIGGER trg_update_Hoadon
ON Hoadon
FOR UPDATE
AS
BEGIN
    DECLARE @Macu NVARCHAR(10), @Mamoi NVARCHAR(10);
    DECLARE @x1 INT, @x2 INT, @x3 INT, @x4 INT;

    -- Lấy thông tin Mahang cũ và mới
    SELECT @Macu = Mahang, @x1 = Soluongban FROM deleted;  -- Mahang cũ và số lượng bán cũ
    SELECT @Mamoi = Mahang, @x2 = Soluongban FROM inserted; -- Mahang mới và số lượng bán mới

    -- Nếu Mahang thay đổi
    IF @Macu != @Mamoi
    BEGIN
        -- Kiểm tra nếu Mahang mới không tồn tại
        IF NOT EXISTS (SELECT 1 FROM Hang WHERE Mahang = @Mamoi)
        BEGIN
            RAISERROR(N'Mahang mới không tồn tại!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Kiểm tra số lượng của Mahang mới có đủ không
        SELECT @x4 = Soluong FROM Hang WHERE Mahang = @Mamoi; -- Số lượng tồn kho của Mahang mới
        IF @x2 > @x4 + @x1
        BEGIN
            RAISERROR(N'Số lượng không đủ để cập nhật!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Hoàn lại số lượng cho Mahang cũ và trừ đi số lượng của Mahang mới
        UPDATE Hang SET Soluong = Soluong + @x1 WHERE Mahang = @Macu;
        UPDATE Hang SET Soluong = Soluong - @x2 WHERE Mahang = @Mamoi;
    END
    ELSE
    BEGIN
        -- Nếu Mahang không thay đổi, chỉ kiểm tra số lượng tồn kho
        SELECT @x3 = Soluong FROM Hang WHERE Mahang = @Macu;
        IF @x2 > @x3 + @x1
        BEGIN
            RAISERROR(N'Số lượng không đủ để cập nhật!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Cập nhật số lượng hàng trong kho
        UPDATE Hang SET Soluong = Soluong + @x1 - @x2 WHERE Mahang = @Macu;
    END
END
GO


-- Kiểm tra trigger
SELECT * FROM Hang;
SELECT * FROM Hoadon;
GO

UPDATE Hoadon 
SET Soluongban = 10, Mahang = 'H1'
WHERE Mahd = 'HD2';
GO

SELECT * FROM Hang;
SELECT * FROM Hoadon;
GO

