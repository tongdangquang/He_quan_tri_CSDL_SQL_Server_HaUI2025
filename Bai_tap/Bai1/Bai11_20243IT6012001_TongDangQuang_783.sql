
USE master
GO

-- Câu a:
-- Tạo cơ sở dữ liệu QLSV
CREATE DATABASE QLSV
ON(
    NAME = "QLSV_data",
    FILENAME = "D:\file_hoc_lieu\SQL_server_HaUI\Database\QLSV_data.mdf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON (
    NAME = "QLSV_log",
    FILENAME = "D:\file_hoc_lieu\SQL_server_HaUI\Database\QLSV_log.ldf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE QLSV
GO

-- Tạo bảng SV
CREATE TABLE SV
(
    MaSV VARCHAR(10) NOT NULL PRIMARY KEY,
    TenSV NVARCHAR(30) NOT NULL,
    Que NVARCHAR(30) NOT NULL
);

-- Tạo bảng môn học
CREATE TABLE MON
(
    MaMH VARCHAR(10) NOT NULL PRIMARY KEY,
    TenMH NVARCHAR(50) NOT NULL,
    Sotc INT NOT NULL
);

-- Tạo bảng kết quả
CREATE TABLE KQ
(
    MaSV VARCHAR(10) NOT NULL,
    MaMH VARCHAR(10) NOT NULL,
    Dem DECIMAL(2, 1) NOT NULL
    CONSTRAINT PK_KQ PRIMARY KEY (MaSV, MaMH)
    CONSTRAINT FK_KQ_MaSV FOREIGN KEY (MaSV) REFERENCES SV(MaSV)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT FK_KQ_MaMH FOREIGN KEY (MaMH) REFERENCES MON(MaMH)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
);
GO

-- Câu b:
-- Thêm ràng buộc cho bảng môn học
ALTER TABLE MON
ADD CONSTRAINT CHECK_MON_Sotc CHECK (Sotc >= 2 AND Sotc <= 5);

ALTER TABLE MON
ADD CONSTRAINT DEFAULT_MON_Sotc DEFAULT 3 FOR Sotc;

ALTER TABLE MON
ADD CONSTRAINT UNIQUE_MON_TenMH UNIQUE (TenMH);

-- Thêm ràng buộc cho bảng kết quả
ALTER TABLE KQ
ADD CONSTRAINT CHECK_KQ_Diem CHECK (Diem >= 0 AND Diem <= 10);
GO

-- Câu c:
-- Thêm 3 sinh viên cho bảng SV
INSERT INTO SV (MaSV, TenSV, Que)
VALUES 
    ('SV001', N'Nguyễn Văn A', N'Hà Nội'),
    ('SV002', N'Lê Thị B', N'Hải Phòng'),
    ('SV003', N'Trần Văn C', N'Đà Nẵng');

-- Thêm 3 môn học cho bảng MON
INSERT INTO MON (MaMH, TenMH, Sotc)
VALUES 
    ('MH001', N'Cơ sở dữ liệu', 3),
    ('MH002', N'Toán rời rạc', 3),
    ('MH003', N'Tiếng Anh CNTT 1', 5);

-- Thêm 6 kết quả cho bảng KQ
INSERT INTO KQ (MaSV, MaMH, Diem)
VALUES 
    ('SV001', 'MH001', 8.5),
    ('SV001', 'MH002', 7.0),
    ('SV002', 'MH002', 6.5),
    ('SV002', 'MH003', 9.0),
    ('SV003', 'MH001', 5.5),
    ('SV003', 'MH003', 8.0);
GO

-- Câu d:
-- Hiển thị thông tin của bảng SV
SELECT * FROM SV;

-- Hiển thị thông tin của bảng MON
SELECT * FROM MON;

-- Hiển thị thông tin của bảng KQ
SELECT * FROM KQ;
GO