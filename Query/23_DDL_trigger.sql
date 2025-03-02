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

-- 1. DDL Trigger là gì?
-- DDL (Data Definition Language) Trigger là trigger được kích hoạt khi có sự kiện thay đổi cấu trúc của database, chẳng hạn như:
    -- Tạo mới (CREATE): Bảng, View, Stored Procedure, Function, Index,...
    -- Sửa đổi (ALTER): Bảng, View, Column, Index,...
    -- Xóa (DROP): Bảng, View, Stored Procedure,...
    -- DDL trigger chỉ có FOR..., không có ALTER... và INSTEAD OF...
-- Khác với DML Trigger, DDL Trigger không áp dụng trên bảng dữ liệu mà áp dụng trên toàn bộ database hoặc server.


-- 2. Cú pháp
-- CREATE TRIGGER ten_trigger
-- ON { DATABASE | ALL SERVER }
-- FOR { Sự kiện_DDL }
-- AS
-- BEGIN
--     -- Nội dung trigger
-- END;


-- 3. Minh họa DDL TRIGGER
-- Ví dụ 1. Chặn xóa bảng trong database
CREATE TRIGGER trg_prevent_drop_table
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    PRINT N'Không được phép xóa bảng trong CSDL này!';
    ROLLBACK;
END
GO
DROP TABLE tbl_NhanVien; 
GO

-- Ví dụ 2. Ghi log khi có người tạo bảng mới
-- Tạo bảng lưu log
CREATE TABLE tbl_LogDDL 
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    SuKien NVARCHAR(100),
    TenDoiTuong NVARCHAR(100),
    TenNguoiThucHien NVARCHAR(100),
    ThoiGian DATETIME DEFAULT GETDATE()
);

-- Tạo trigger ghi log khi có ai đó tạo bảng mới
CREATE TRIGGER trg_LogCreateTable
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    INSERT INTO tbl_LogDDL (SuKien, TenDoiTuong, TenNguoiThucHien)
    SELECT 
        'CREATE TABLE', 
        EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)'),
        EVENTDATA().value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(100)');
END
GO

-- Kiểm tra
CREATE TABLE TestTable (ID INT);
SELECT * FROM tbl_LogDDL;
GO


-- 4. ALTER trigger
ALTER TRIGGER trg_prevent_drop_table
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    RAISERROR(N'Không thể xóa bảng trong CSDL này!', 16, 1);
END
GO

DROP TABLE tbl_NhanVien; 
GO

-- 5. DISABLE/ENABLE trigger
-- Xóa DDL Trigger
DROP TRIGGER trg_LogCreateTable ON DATABASE;
GO

-- Tắt DDL Trigger tạm thời
DISABLE TRIGGER trg_LogCreateTable ON DATABASE;
GO

-- Bật lại Trigger:
ENABLE TRIGGER trg_LogCreateTable ON DATABASE;
GO

