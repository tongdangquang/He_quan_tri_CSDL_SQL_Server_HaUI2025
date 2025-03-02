-- tạo cơ sở dữ liệu QLSV
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
    FILENAME = 'D:\file_hoc_lieu\SQL_server\QLSV.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 20%
);

USE QLSV;
GO

-- ràng buộc CHECK: được sử dụng nhằm chỉ định điều kiện hợp lệ đối với dữ liệu
CREATE TABLE Lop(
    malop VARCHAR(20) NOT NULL,
    tenlop NVARCHAR(30) NOT NULL,
    khoa int,
    
    -- ràng buộc cho thuộc tính hedaotao chỉ được nhận 1 trong 2 giá trị 'Đại học' hoặc 'Cao đẳng'
    hedaotao NVARCHAR(30),
    CONSTRAINT chk_lop_hedaotao CHECK (hedaotao IN ('Đại học', 'Cao đẳng')),

    -- ràng buộc cho thuộc tính namnhaphoc phải nhỏ hơn hoặc bằng năm hiện tại
    namnhaphoc int,
    CONSTRAINT chk_lop_namnhaphoc CHECK (namnhaphoc <= YEAR(GETDATE())),
    makhoa CHAR(10),

    -- có thể viết gọn lại như dưới đây:
    -- CONSTRAINT chk_lop CHECK (hedaotao IN ('Đại học', 'Cao đẳng')) AND (namnhaphoc <= YEAR(GETDATE()))

-- ràng buộc UNIQUE: đảm bảo giá trị trong một cột là duy nhất
    CONSTRAINT unique_lop_malop UNIQUE(tenlop),

-- ràng buộc DEFAULT: đặt giá trị mặc định cho một cột
    startdate DATE DEFAULT GETDATE(),
)


-- ràng buộc PRIMARY KEY: được sử dụng để định nghĩa khóa chính của bảng, khóa chính không cho phép nhận giá trị NULL
-- tạo bảng Sinhvien với khóa chính là Masv
CREATE TABLE Sinhvien(
    -- cú pháp 1
    -- masv CHAR(15) NOT NULL PRIMARY KEY,

    -- cú pháp 2
    -- masv CHAR(15) NOT NULL CONSTRAINT pk_sinhvien_masv PRIMARY KEY,

    -- cú pháp 3
    masv CHAR(15) NOT NULL,
    CONSTRAINT pk_sinhvien_masv PRIMARY KEY(masv), -- thêm nhiều khóa chính bằng cách ghi các khóa vào trong ngoặc cách nhau 1 dấu phẩy

    -- các thuộc tính khác
    hodem NVARCHAR(10) NOT NULL,
    ten NVARCHAR(10) NOT NULL,
    ngaysinh DATE,
    gioitinh BIT,
    noisinh VARCHAR(255),
    malop VARCHAR(20) NOT NULL,
)

CREATE TABLE Monhoc(
    mamonhoc CHAR(10) NOT NULL,
    tenmonhoc NVARCHAR(30) NOT NULL,
    CONSTRAINT pk_monhoc PRIMARY KEY (mamonhoc),
)

-- ràng buộc FOREIGN KEY: được sử dụng trong định nghĩa bảng dữ liệu nhằm tạo nên mối quan hệ giữa các bảng trong một cơ sở dữ liệu
CREATE TABLE Diemthi(
    mamonhoc CHAR(10) NOT NULL,
    masv CHAR(15) NOT NULL,
    diemlan1 NUMERIC(4, 2),
    diemlan2 NUMERIC(4, 2),
    CONSTRAINT pk_diemthi PRIMARY KEY (mamonhoc, masv),

    -- ràng buộc khóa ngoại cho cột mamonhoc
    CONSTRAINT fk_diemthi_mamonhoc FOREIGN KEY (mamonhoc) REFERENCES Monhoc(mamonhoc)
    ON DELETE CASCADE -- tự động xóa lại dữ liệu nếu bản ghi được tham chiếu bị xóa
    ON UPDATE CASCADE, -- tự động cập nhật lại dữ liệu nếu bản ghi được tham chiếu cập nhật

    -- ràng buộc khóa ngoại cho thuộc tính masv
    CONSTRAINT fk_diemthi_masv FOREIGN KEY (masv) REFERENCES Sinhvien(masv)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
)

-- The following constraints are commonly used in SQL:
-- NOT NULL - Ensures that a column cannot have a NULL value
-- UNIQUE - Ensures that all values in a column are different
-- PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
-- FOREIGN KEY - Prevents actions that would destroy links between tables
-- CHECK - Ensures that the values in a column satisfies a specific condition
-- DEFAULT - Sets a default value for a column if no value is specified
-- CREATE INDEX - Used to create and retrieve data from the database very quickly