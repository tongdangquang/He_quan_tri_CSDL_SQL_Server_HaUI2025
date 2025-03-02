-- Câu 1. 
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

CREATE TABLE Mathang
(
    mahang NVARCHAR(10) NOT NULL PRIMARY KEY,
    tenhang NVARCHAR(30),
    soluong INT
);

CREATE TABLE Nhatkybanhang
(
    stt INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    ngay DATE,
    nguoimua NVARCHAR(30),
    mahang NVARCHAR(10),
    soluong INT,
    giaban MONEY,
    CONSTRAINT fk_Nhatkybanhang_mahang FOREIGN KEY (mahang) REFERENCES Mathang(mahang)
);
GO

-- Câu 2. 
INSERT INTO Mathang(mahang, tenhang, soluong)
VALUES  ('1', 'Keo', 100),
        ('2', 'Banh', 200),
        ('3', 'Thuoc', 100);

INSERT INTO Nhatkybanhang(ngay, nguoimua, mahang, soluong, giaban)
VALUES ('02-09-1999', 'ab', '2', 230, 50000);
GO

SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
GO 

-- Câu 3. 
-- a. 
CREATE TRIGGER trg_nhatkybanhang_insert
ON Nhatkybanhang
FOR INSERT
AS
BEGIN
    UPDATE Mathang
    SET soluong = m.soluong - i.soluong
    FROM Mathang m
    INNER JOIN inserted i ON m.mahang = i.mahang;
END
GO

INSERT INTO Nhatkybanhang (ngay, nguoimua, mahang, soluong, giaban)
VALUES ('01-01-2025', 'bc', '3', 30, 30000);
SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
GO 


-- b. 
CREATE TRIGGER trg_nhatkybanhang_update_soluong
ON Nhatkybanhang
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Trường hợp chỉ cập nhật soluong (mahang không đổi)
    IF UPDATE(soluong) AND NOT UPDATE(mahang)
    BEGIN
        UPDATE Mathang
        SET soluong = m.soluong + d.soluong - i.soluong
        FROM Mathang m
        INNER JOIN deleted d ON m.mahang = d.mahang
        INNER JOIN inserted i ON m.mahang = i.mahang;
    END

    -- Trường hợp chỉ cập nhật mahang (soluong không đổi)
    IF UPDATE(mahang) AND NOT UPDATE(soluong)
    BEGIN
        -- 1. Hoàn tác số lượng mặt hàng cũ
        UPDATE Mathang
        SET soluong = m.soluong + d.soluong
        FROM Mathang m
        INNER JOIN deleted d ON m.mahang = d.mahang;

        -- 2. Trừ số lượng mặt hàng mới
        UPDATE Mathang
        SET soluong = m.soluong - i.soluong
        FROM Mathang m
        INNER JOIN inserted i ON m.mahang = i.mahang;
    END

    -- Trường hợp cập nhật cả mahang và soluong
    IF UPDATE(mahang) AND UPDATE(soluong)
    BEGIN
        -- 1. Hoàn tác số lượng mặt hàng cũ
        UPDATE Mathang
        SET soluong = m.soluong + d.soluong
        FROM Mathang m
        INNER JOIN deleted d ON m.mahang = d.mahang;

        -- 2. Trừ số lượng mặt hàng mới
        UPDATE Mathang
        SET soluong = m.soluong - i.soluong
        FROM Mathang m
        INNER JOIN inserted i ON m.mahang = i.mahang;
    END
END
GO 

UPDATE Nhatkybanhang
SET soluong = 20, mahang = '7'
WHERE stt = 1;

SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
GO


-- c. 
CREATE TRIGGER trg_insert_Nhatkybanhang
ON Nhatkybanhang
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Mathang m
        INNER JOIN inserted i ON m.mahang = i.mahang
        WHERE m.soluong < i.soluong
    )
    BEGIN
        RAISERROR(N'Số lượng hàng không đủ!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    ELSE
    BEGIN
        UPDATE Mathang
        SET soluong = m.soluong - i.soluong
        FROM Mathang m 
        INNER JOIN inserted i ON m.mahang = i.mahang;
    END
END
GO

INSERT INTO Nhatkybanhang(ngay, nguoimua, mahang, soluong, giaban)
VALUES ('02-01-2025', 'ef', '2', 0, 50000);
SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
GO


-- d. 
CREATE TRIGGER trg_update_Nhatkybanhang2
ON Nhatkybanhang
FOR UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        RAISERROR(N'Chỉ được cập nhật 1 bản ghi!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF UPDATE(soluong)
        UPDATE Mathang
        SET soluong = m.soluong + d.soluong - i.soluong
        FROM Mathang m 
        INNER JOIN inserted i ON m.mahang = i.mahang
        INNER JOIN deleted d ON m.mahang = d.mahang;
END
GO

UPDATE Nhatkybanhang
SET soluong = 100
WHERE mahang = 2;
SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
GO


-- e. 
CREATE TRIGGER trg_delete_Nhatkybanhang
ON Nhatkybanhang
for DELETE
AS
BEGIN
    IF (SELECT COUNT(*) FROM deleted) > 1
    BEGIN
        RAISERROR(N'Mỗi lần chỉ được xóa một bản ghi!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE Mathang
    SET soluong = m.soluong + d.soluong
    FROM Mathang m 
    INNER JOIN deleted d ON m.mahang = d.mahang;
END
GO

DELETE FROM Nhatkybanhang
WHERE stt = '1';
SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
GO


-- f. 
CREATE TRIGGER trg_update_Nhatkybanhang
ON Nhatkybanhang
FOR UPDATE
AS
BEGIN
    IF UPDATE(soluong)
    BEGIN
        IF (SELECT COUNT(*) FROM inserted) > 1
        BEGIN
            RAISERROR(N'Chỉ được cập nhật một bản ghi!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF EXISTS (
            SELECT 1
            FROM Mathang m 
            INNER JOIN inserted i ON m.mahang = i.mahang
            INNER JOIN deleted d ON m.mahang = i.mahang
            WHERE m.soluong + d.soluong < i.soluong
        )
        BEGIN
            RAISERROR(N'Không đủ số lượng để cập nhật!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF (SELECT soluong FROM inserted) = (SELECT soluong FROM deleted)
        BEGIN
            RAISERROR(N'Không cần cập nhật vì số lượng không thay đổi!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE Mathang
        SET soluong = m.soluong + d.soluong - i.soluong
        FROM Mathang m 
        INNER JOIN inserted i ON m.mahang = i.mahang
        INNER JOIN deleted d ON m.mahang = d.mahang;
    END
END

UPDATE Nhatkybanhang
SET soluong = 200
WHERE stt = 1;
SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
GO

-- g. 
CREATE PROCEDURE sp_delete_Mathang
    @mahang NVARCHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Mathang WHERE mahang = @mahang)
    BEGIN
        PRINT N'mahang không tồn tại để xóa!';
        RETURN;
    END
    
    DELETE FROM Nhatkybanhang
    WHERE mahang = @mahang;

    DELETE FROM Mathang
    WHERE mahang = @mahang;
END
GO

EXEC dbo.sp_delete_Mathang '1';
SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
GO

-- h. 
CREATE FUNCTION fn_cau_h (@tenhang NVARCHAR(30))
RETURNS MONEY
AS
BEGIN
    DECLARE @result MONEY;
    SELECT @result = SUM(n.soluong * n.giaban)
    FROM Mathang m 
    INNER JOIN Nhatkybanhang n ON m.mahang = n.mahang
    WHERE tenhang = @tenhang
    GROUP BY n.mahang;

    RETURN @result;
END
GO  

SELECT dbo.fn_cau_h('Banh');
GO

