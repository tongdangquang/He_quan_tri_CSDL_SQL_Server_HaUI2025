USE master; -- chuyển ngữ cảnh sang cơ sở dữ liệu hệ thông master
GO -- kết thúc khối lệnh

-- tạo cơ sở dữ liệu QLBH
CREATE DATABASE QLBH
-- xác định tập tin dữ liệu chính
ON PRIMARY (
   NAME = 'QLBH_data', -- đặt tên logic cho tập dữ liệu chính
   FILENAME = 'D:\file_hoc_lieu\SQL_server\QLBH.mdf', -- nơi lưu trữ tập tin chính
   SIZE = 10MB, -- kích thước ban đầu của tập tin
   MAXSIZE = 100MB, -- kích thước tôi đa mà tập tin có thể mở rộng
   FILEGROWTH = 10MB -- khi tập tin đầy, nó sẽ tự động mở thêm 10MB mỗi lần
)

-- xác định tập tin nhật ký giao dịch
LOG ON (
   NAME = 'QLBH_log',
   FILENAME = 'D:\file_hoc_lieu\SQL_server\QLBH_log.ldf',
   SIZE = 1MB,
   MAXSIZE = 5MB,
   FILEGROWTH = 20%
);
GO

USE QLBH; -- chuyển ngữ cảnh sang cơ sở dữ liệu QLBH
GO

-- tạo các bảng trong cơ sở dữ liệu QLBH
CREATE TABLE CongTy (
   MaCT NCHAR(10) NOT NULL PRIMARY KEY, -- cột MaCT được đặt là khóa chính và không được để trống
   TenCT NVARCHAR(20) NOT NULL,
   TrangThai NCHAR(10),
   ThanhPho NVARCHAR(20)
);

CREATE TABLE SanPham (
   MaSP NCHAR(10) NOT NULL PRIMARY KEY,
   TenSP NVARCHAR(20),
   MauSac NCHAR(10) DEFAULT N'Đỏ', -- nếu không có giá trị thì MauSac mặc định là Đỏ
   Gia MONEY, -- kiểu dữ liệu money
   SoLuongCo INT,
   CONSTRAINT unique_SP UNIQUE(TenSP) -- ràng buộc Unique đảm bảo rằng mỗi tên sản phẩm là duy nhất trong bảng sản phẩm
);

CREATE TABLE CungUng (
   MaCT NCHAR(10) NOT NULL,
   MaSP NCHAR(10) NOT NULL,
   SoLuongBan INT,
   CONSTRAINT PK_CungUng PRIMARY KEY (MaCT, MaSP), -- ràng buộc 2 cột MaCT và MaSP là khóa chính
   CONSTRAINT chk_SLB CHECK (SoLuongBan > 0) -- ràng buộc check đảm bảo rằng SoLuongBan lớn hơn 0
);


-- Xóa cơ sở dữ liệu
DROP DATABASE QLBH;
