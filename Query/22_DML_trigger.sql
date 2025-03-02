USE master;
GO

CREATE DATABASE QLNV
ON
(
    NAME = 'QLNV_data',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLNV_data.mdf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON
(
    NAME = 'QLNV_LOG',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLNV_LOG.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE QLNV;
GO

CREATE TABLE tbl_ChucVu
(
    MaCV NVARCHAR(2) NOT NULL PRIMARY KEY,
    TenCV NVARCHAR(30)
);
CREATE TABLE tbl_NhanVien
(
    MaNV NVARCHAR(4) NOT NULL PRIMARY KEY,
    MaCV NVARCHAR(2),
    TenNV NVARCHAR(30),
    NgaySinh DATETIME,
    LuongCanBan FLOAT,
    NgayCong INT,
    PhuCap FLOAT
    CONSTRAINT FK_tbl_NhanVien_MaCV FOREIGN KEY (MaCV) REFERENCES tbl_ChucVu(MaCV)
);
GO

INSERT INTO tbl_ChucVu(MaCV, TenCV)
VALUES
    ('BV', N'Bảo Vệ'),
    ('GD', N'Giám Đốc'),
    ('HC', N'Hành Chính'),
    ('KT', N'Kế Toán'),
    ('TQ', N'Thủ Quỹ'),
    ('VS', N'Vệ Sinh');
INSERT INTO tbl_NhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES
    ('NV01', 'GD', N'Nguyễn Văn An', '12/12/1977', 700000, 25, 500000),
    ('NV02', 'BV', N'Bùi Văn Tí', '10/10/1978', 400000, 24, 100000),
    ('NV03', 'KT', N'Trần Thanh Nhật', '9/9/1977', 600000, 26, 400000),
    ('NV04', 'VS', N'Nguyễn Thị Út', '10/10/1980', 300000, 26, 300000),
    ('NV05', 'HC', N'Lê Thị Hà', '10/10/1979', 500000, 27, 200000);
GO

-- 1. Giới thiệu về trigger
    -- Trigger là một đối tượng trong SQL Server, tự động thực thi khi có một sự kiện (INSERT, UPDATE, DELETE) xảy ra trên một bảng hoặc một view. 
    -- Trigger giúp thực hiện các hành động tự động, đảm bảo tính toàn vẹn dữ liệu và hỗ trợ ghi nhật ký thay đổi.
    -- Có 3 loại trigger là: (trong file này sẽ tìm hiểu về trigger DML và trigger DDL)
        -- Trigger dữ liệu ngôn ngữ thao tác (Trigger DML) kích hoạt khi xảy ra sự kiện INSERT, UPDATE và DELETE dữ liệu xảy ra trên bảng.
        -- Trigger dữ liệu ngôn ngữ định nghĩa (Trigger DDL) kích hoạt khi xảy ra các câu lệnh CREATE, ALTER và DROP.
        -- Trigger đăng nhập (Trigger  Logon) kích hoạt khi xảy ra các sự kiện LOGON.

-- 2. Trigger DML
-- 2.1. AFTER Trigger (hay còn gọi là FOR Trigger)
    -- Tự động kích hoạt ngay sau khi câu lệnh INSERT, UPDATE, DELETE hoàn tất.
    -- Không áp dụng cho VIEW.
    -- AFTER và FOR là tương đương, nhưng AFTER rõ nghĩa hơn.
-- Ví dụ ghi lại lịch sử khi thêm 1 nhân viên vào bảng tbl_NhanVien:
-- Tạo bảng lưu lịch sử
CREATE TABLE tbl_LichSuThemNV
(
    -- Khi chèn dữ liệu chỉ cần INSERT INTO ... VALUES(MaNV, TenNV) vì 2 cột còn lại sẽ tự động chèn dữ liệu tương ứng
    ID INT IDENTITY(1,1) PRIMARY KEY, -- IDENTITY(start, step): thường dùng để đánh số thứ tự
    MaNV NVARCHAR(4),
    TenNV NVARCHAR(30),
    NgayThem DATETIME DEFAULT GETDATE() -- Dùng GETDATE() để đặt ngày giờ hiện tại cho mỗi bản ghi
);
GO

-- Tạo trigger
CREATE TRIGGER trg_after_insert_tbl_NhanVien
ON tbl_NhanVien
AFTER INSERT
AS
BEGIN
    INSERT INTO tbl_LichSuThemNV(MaNV, TenNV)
    SELECT MaNV, TenNV FROM inserted;
END
GO

-- Kiểm tra trigger
INSERT INTO tbl_NhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES ('NV08', 'TQ', N'Trần Vũ Hùng', '11/11/1985', 550000, 25, 250000),
       ('NV09', 'VS', N'Nguyễn Thị Mười', '10/10/1980', 300000, 26, 300000);
SELECT * FROM tbl_LichSuThemNV;
GO


-- 2.2. INSTEAD OF Trigger
    -- Kích hoạt thay thế câu lệnh INSERT, UPDATE, DELETE (tức là sẽ không INSERT, UPDATE, DELETE như bình thường nữa mà thay vào đó sẽ chạy đoạn mã trong trigger).
    -- Có thể sử dụng trên cả bảng và VIEW.
    -- Dùng để kiểm soát hoặc ngăn chặn các thay đổi không mong muốn
    -- Nếu một bảng có ràng buộc FOREIGN KEY với tùy chọn ON UPDATE CASCADE hoặc ON DELETE CASCADE, thì không thể tạo INSTEAD OF UPDATE hoặc INSTEAD OF DELETE trigger trên bảng đó.
-- Ví dụ dùng INSTEAD OF Trigger để ngăn việc cập nhật trực tiếp lương khi sự kiện UPDATE được sử dụng
CREATE TRIGGER trg_update_tbl_NhanVien
ON tbl_NhanVien
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON; -- dùng "SET NOCOUNT ON;"" để kết quả không hiển thị mấy dòng (1 rows affected)
    IF UPDATE(LuongCanBan)
    BEGIN 
        PRINT N'Không thể cập nhật lương trực tiếp. Vui lòng chờ phê duyệt.';
        RETURN;
    END
    UPDATE tbl_NhanVien
    SET MaCV = i.MaCV,
        TenNV = i.TenNV, 
        NgaySinh = i.NgaySinh, 
        NgayCong = i.NgayCong, 
        PhuCap = i.PhuCap
    FROM inserted i
    WHERE tbl_NhanVien.MaNV = i.MaNV;
END
GO 

-- Kiểm tra trigger
SET NOCOUNT ON;
UPDATE tbl_NhanVien
SET LuongCanBan = 10000000
WHERE MaNV = 'NV01';
GO


-- 3. DISABLE/ENABLE trigger
-- 3.1. DISABLE trigger
-- Tắt trigger tạm thời
DISABLE TRIGGER trg_after_insert_tbl_NhanVien ON tbl_NhanVien;
GO
-- Tắt tất cả trigger trên 1 bảng
DISABLE TRIGGER ALL ON tbl_NhanVien;
GO 
-- Tắt tất cả trigger của database
DISABLE TRIGGER ALL ON DATABASE;
GO 

-- 3.2. ENABLE trigger
-- Bật lại một trigger
ENABLE TRIGGER trg_after_insert_tbl_NhanVien ON tbl_NhanVien;
GO
-- Bật lại toàn bộ trigger trên 1 bảng
ENABLE TRIGGER ALL ON tbl_NhanVien;
GO 
-- Bật lại toàn bộ trigger trên 1 database
ENABLE TRIGGER ALL ON DATABASE;
GO 


-- 4. ALTER trigger
-- Không thể ALTER để đổi loại trigger (ví dụ: từ AFTER sang INSTEAD OF), phải DROP rồi CREATE lại.
ALTER TRIGGER trg_after_insert_tbl_NhanVien
ON tbl_NhanVien
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON; -- bổ sung dòng này cho trg_after_insert_tbl_NhanVien 
    INSERT INTO tbl_LichSuThemNV(MaNV, TenNV)
    SELECT MaNV, TenNV FROM inserted;
END
GO

-- 5. DROP trigger
-- Xóa một trigger
DROP TRIGGER trg_after_insert_tbl_NhanVien;
GO

-- Xóa nhiều trigger trên một bảng
DROP TRIGGER trg_after_insert_tbl_NhanVien, trg_update_tbl_NhanVien;
GO

-- Xóa trigger trên toàn bộ database
DROP TRIGGER trg_Audit ON DATABASE; -- chưa có trg_Audit nhưng lấy tên đó là ví dụ
GO 

-- 6. ROLLBACK TRANSACTION, RAISERROR() 
-- ROLLBACK TRANSACTION dùng để hủy bỏ các thay đổi trong một giao dịch (TRANSACTION) nếu có lỗi hoặc điều kiện không mong muốn xảy ra. 
-- Nó giúp đảm bảo tính toàn vẹn dữ liệu bằng cách hoàn tác mọi thao tác SQL đã thực hiện trong giao dịch.
-- Khi dùng trong trigger, ROLLBACK có thể chặn hoàn toàn hành động INSERT, UPDATE hoặc DELETE.
CREATE TRIGGER trg_update_tbl_NhanVien
ON tbl_NhanVien
INSTEAD OF UPDATE
AS
BEGIN
    IF UPDATE(LuongCanBan)
    BEGIN
        PRINT N'Không thể cập nhật lương trực tiếp!';
        ROLLBACK TRANSACTION;
    END
END
GO

-- Khi chạy trigger có ROLLBACK TRANSACTION, sẽ có thông báo lỗi "The transaction ended in the trigger. The batch has been aborted."
-- vì ROLLBACK TRANSACTION dừng đột ngột toàn bộ chương trình. Thay vào đó hãy sử dụng RAISERROR(), nó cũng dừng đột ngột nhưng co thể thay đổi thông báo lỗi theo ý mình.
CREATE TRIGGER trg_update_tbl_NhanVien
ON tbl_NhanVien
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(LuongCanBan)
    BEGIN
        RAISERROR(N'Không thể cập nhật lương!', 16, 1); -- 16 là mức độ lỗi, 1 là đùng để đánh dấu (các trigger khác sẽ dùng 2, 3, ...) để dễ fix khi có bug
        RETURN;
    END
    -- Nếu không cập nhật LuongCanBan thì cho phép cập nhật các cột khác
    UPDATE tbl_NhanVien
    SET TenNV = i.TenNV,
        NgaySinh = i.NgaySinh,
        NgayCong = i.NgayCong,
        PhuCap = i.PhuCap
    FROM inserted i
    WHERE tbl_NhanVien.MaNV = i.MaNV;
END;

UPDATE tbl_NhanVien
SET LuongCanBan = 80000000
WHERE MaNV = 'NV01';
GO

-- Có thể kết hợp ROLLBACK TRANSACTION và RAISERROR()
CREATE TRIGGER trg_Update_tbl_NhanVien2
ON tbl_NhanVien
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(LuongCanBan)
    BEGIN
        ROLLBACK TRANSACTION; -- ROLLBACK TRANSACTION giúp đảm bảo dữ liệu không bị thay đổi sai sót
        RAISERROR(N'Không thể cập nhật lương! Giao dịch đã bị hủy.', 16, 1); -- RAISERROR giúp báo lỗi rõ ràng cho người dùng
        RETURN;
    END

    -- Nếu không cập nhật LuongCanBan thì cho phép cập nhật các cột khác
    UPDATE tbl_NhanVien
    SET TenNV = i.TenNV,
        NgaySinh = i.NgaySinh,
        NgayCong = i.NgayCong,
        PhuCap = i.PhuCap
    FROM inserted i
    WHERE tbl_NhanVien.MaNV = i.MaNV;
END;
GO


