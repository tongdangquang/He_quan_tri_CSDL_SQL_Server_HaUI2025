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

CREATE TABLE tblChucvu
(
    MaCV NVARCHAR(2) NOT NULL PRIMARY KEY,
    TenCV NVARCHAR(30)
);
CREATE TABLE tblNhanVien
(
    MaNV NVARCHAR(4) NOT NULL PRIMARY KEY,
    MaCV NVARCHAR(2),
    TenNV NVARCHAR(30),
    NgaySinh DATETIME,
    LuongCanBan FLOAT,
    NgayCong INT,
    PhuCap FLOAT
    CONSTRAINT FK_tblNhanVien_MaCV FOREIGN KEY (MaCV) REFERENCES tblChucvu(MaCV)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
GO

INSERT INTO tblChucvu(MaCV, TenCV)
VALUES
    ('BV', N'Bảo Vệ'),
    ('GD', N'Giám Đốc'),
    ('HC', N'Hành Chính'),
    ('KT', N'Kế Toán'),
    ('TQ', N'Thủ Quỹ'),
    ('VS', N'Vệ Sinh');
INSERT INTO tblNhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES
    ('NV01', 'GD', N'Nguyễn Văn An', '12/12/1977', 700000, 25, 500000),
    ('NV02', 'BV', N'Bùi Văn Tí', '10/10/1978', 400000, 24, 100000),
    ('NV03', 'KT', N'Trần Thanh Nhật', '9/9/1977', 600000, 26, 400000),
    ('NV04', 'VS', N'Nguyễn Thị Út', '10/10/1980', 300000, 26, 300000),
    ('NV05', 'HC', N'Lê Thị Hà', '10/10/1979', 500000, 27, 200000);
GO


-- 1. Giới thiệu về Index
    -- Index (chỉ mục) giúp tăng tốc truy vấn bằng cách tạo cấu trúc dữ liệu đặc biệt giúp SQL Server tìm kiếm dữ liệu nhanh hơn.
    -- Có hai loại chính: Clustered Index và Non-Clustered Index.


-- 2. Tạo và sử dùng Index
-- 2.1. Clustered Index
    -- Mỗi bảng chỉ có 1 Clustered Index.
    -- Dữ liệu trong bảng được lưu trữ vật lý theo thứ tự của cột có Clustered Index.
    -- Clustered Index giúp tìm kiếm nhanh hơn trên cột được sắp xếp.
    -- Nếu không tạo Clustered Index, SQL Server sẽ lưu trữ bảng dưới dạng Heap Table (bảng không có thứ tự).
    -- Clustered Index được tạo tự động trên khóa chính của bảng dữ liệu nhưng nếu bảng chưa có khóa chính mà lại có cột Clustered Index thì cột đó không phải khóa chính
-- Nếu bảng chưa có Clustered Index (chưa có khóa chính) thì có thể tạo theo cấu trúc như sau:
CREATE CLUSTERED INDEX idx_tblNhanVien_MaNV
ON tblNhanVien(MaNV);
GO
-- 2.2. Non-Clustered Index
    -- Mỗi bảng có thể có nhiều Non-Clustered Index.
    -- Non-Clustered Index tạo một bảng riêng biệt chứa cột cần lập chỉ mục và con trỏ trỏ đến dữ liệu gốc.
    -- Truy vấn bằng Non-Clustered Index nhanh hơn so với quét toàn bộ bảng (Table Scan).
-- Tạo Non-Clustered Index trên TenNV
CREATE NONCLUSTERED INDEX nidx_tblNhanVien_TenNV 
ON tblNhanVien(TenNV);
GO 
-- SQL Server sẽ tra cứu bảng chỉ mục này trước, lấy con trỏ, sau đó trỏ đến bảng dữ liệu vật lý và trả về kết quả truy vấn (truy vấn có sử dụng TenNV làm điều kiện truy vấn)
-- Ví dụ: Nếu bảng tblNhanVien có Clustered Index trên MaNV, thì Non-Clustered Index trên TenNV sẽ trỏ đến MaNV chứ không trỏ trực tiếp đến vị trí vật lý của dữ liệu.
-- SELECT * FROM tbl_NhanVien WHERE TenNV = 'Lê Thị Hà';
-- Khi tìm kiếm, SQL Server sẽ:
    -- Dùng Non-Clustered Index để tìm TenNV.
    -- Lấy giá trị MaNV (từ con trỏ).
    -- Dùng MaNV để tìm dữ liệu thực tế trong Clustered Index, giúp truy vấn nhanh hơn.


-- 3. Kiểm tra tốc độ truy vấn khi dùng Index
    -- Dùng SHOWPLAN để kiểm tra truy vấn có sử dụng Index không:
        -- SHOWPLAN_ALL hiển thị kế hoạch thực thi truy vấn.
        -- Nếu truy vấn dùng Index, bạn sẽ thấy Index Seek (tốt hơn).
        -- Nếu không có Index hoặc SQL Server quyết định không dùng, bạn sẽ thấy Table Scan (chậm hơn).
SET STATISTICS IO ON;
SET SHOWPLAN_ALL ON;
SELECT * FROM tblNhanVien WHERE MaNV = 'NV03';
SELECT * FROM tblNhanVien WHERE TenNV = N'Lê Thị Hà';
SET SHOWPLAN_ALL OFF;
SET STATISTICS IO OFF;
GO


-- 4. ALTER INDEX
-- Lệnh ALTER INDEX chỉ dùng để quản lý và bảo trì Index, không thể thay đổi cột hoặc loại Index.
-- 4.1. Những gì ALTER INDEX có thể làm:
    -- REBUILD: Xây dựng lại Index từ đầu.
    -- REORGANIZE: Chỉnh lại cấu trúc Index mà không cần xóa và tạo lại.
    -- DISABLE: Tạm thời vô hiệu hóa Index.

-- a. REBUILD: Tái xây dựng Index để tối ưu hiệu suất
    -- Xây dựng lại toàn bộ Index.
    -- Giúp tối ưu hiệu suất khi Index bị phân mảnh nhiều.
ALTER INDEX idx_TenNV ON tblNhanVien REBUILD;

-- b. REORGANIZE: Tổ chức lại Index:
    -- Chỉ sắp xếp lại Index mà không xóa dữ liệu cũ
    -- Nhanh hơn REBUILD, nhưng ít hiệu quả hơn nếu Index bị phân mảnh quá nhiều
ALTER INDEX idx_TenNV ON tblNhanVien REORGANIZE;

-- c. DISABLE: Vô hiệu hóa Index tạm thời
    -- Index sẽ không được sử dụng nhưng vẫn tồn tại.
ALTER INDEX idx_TenNV ON tblNhanVien DISABLE;
    -- Khi cần kích hoạt lại, phải REBUILD Index.
ALTER INDEX idx_TenNV ON tblNhanVien REBUILD;

-- 4.2. Những gì ALTER INDEX KHÔNG thể làm
    -- Không thể thay đổi cột của Index.
    -- Không thể chuyển Clustered Index → Non-Clustered Index hoặc ngược lại.
    -- Không thể thay đổi loại Index (Unique, Non-Unique).
    -- Muốn thay đổi Index thì bắt buộc phải xóa đi tạo lại
DROP INDEX idx_TenNV ON tblNhanVien;  
CREATE CLUSTERED INDEX idx_MaNV ON tblNhanVien(MaNV);


-- 5. Đổi tên Index
-- SQL Server cho phép dùng sp_rename để đổi tên Index như sau:
-- Cấu trúc: EXEC sp_rename 'Tên_Bảng.Tên_Index_Cũ', 'Tên_Index_Mới', 'INDEX';
EXEC sp_rename 'tblNhanVien.idx_TenNV', 'idx_NhanVien_Ten', 'INDEX';


-- 6. Xóa Index
DROP INDEX idx_TenNV ON tblNhanVien;