-- tạo cơ sở dữ liệu
USE master;
GO

CREATE DATABASE QLSV
ON PRIMARY (
    NAME = 'QLSV_data',
    FILENAME = 'D:\file_hoc_lieu\SQL_server\QLSV.mdf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB
)

LOG ON (
    NAME = 'QLSV_log',
    FILENAME = 'D:\file_hoc_lieu\SQL_server\QLSV_log.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 20%
);
GO

USE QLSV;
GO

-- tạo các bảng trong QLSV
-- CREATE TABLE SV(
--     MaSV VARCHAR(10) NOT NULL PRIMARY KEY,
--     HotenSV NVARCHAR(30) NOT NULL,
--     Diachi NVARCHAR(30) NOT NULL,
-- );
-- CREATE TABLE MONHOC(
--     MaMH VARCHAR(10) NOT NULL PRIMARY KEY,
--     TenMH NVARCHAR(30) NOT NULL,
--     Sotc int NOT NULL,
-- );
-- CREATE TABLE DIEM(
--     MaSV VARCHAR(10) NOT NULL,
--     MaMH VARCHAR(10) NOT NULL,
--     Diem FLOAT,
--     CONSTRAINT fk_diem_masv FOREIGN KEY (MaSV) REFERENCES SV(MaSV),
--     CONSTRAINT fk_diem_mamh FOREIGN KEY (MaMH) REFERENCES MONHOC(MaMH),
-- );

-- ALTER TABLE SV
-- ALTER COLUMN Diachi NVARCHAR(30) NULL;



-- I. chèn dữ liệu vào bảng SV
-- 1. Chèn dữ liệu vào tất cả các cột trong bảng
INSERT INTO SV
VALUES ('2022603783', 'Tống Đăng Quang', 'Thái Bình');

-- 2. Chèn dữ liệu vào từng cột
INSERT INTO SV(MaSV, HotenSV)
VALUES ('2022603784', 'Nguyễn Văn A');

-- 3. Chèn nhiều dữ liệu cùng lúc
INSERT INTO SV(MaSV, HotenSV, Diachi) -- lưu ý: chèn nhiều dữ liệu cùng lúc thì phải ghi rõ ràng các cột trong bảng ra
VALUES
    ('2022603785', 'Nguyễn Văn B', 'Hà Nội'),
    ('2022603786', 'Nguyễn Văn C', 'Hà Nội'),
    ('2022603787', 'Nguyễn Văn D', 'Hà Nội'),
    ('2022603788', 'Nguyễn Văn E', 'Hà Nội');


SELECT * FROM SV;


-- II. xóa dữ liệu
-- 1. Xóa dữ liệu nằm trong điều kiện
DELETE FROM SV 
WHERE MaSV = '2022603783';

DELETE FROM SV 
WHERE Diachi IS NULL;

-- 2. Xóa toàn bộ dữ liệu trong bảng
DELETE FROM SV;


-- III. cập nhật dữ liệu
-- 1. UPDATE Table - cập nhật 1 bản ghi
UPDATE SV
SET HotenSV = 'Trân Van A', Diachi = 'Thai Binh'
WHERE MaSV = '2022603785';

-- 2. UPDATE Multiple - cập nhật nhiều bản ghi
UPDATE SV 
SET Diachi = 'Vietnam'
WHERE MaSV LIKE '2022%';

-- 3. Update không có điều kiện Where
UPDATE SV
SET Diachi = 'Ha Noi'; -- tất cả địa chỉ đều chuyển về hà nội