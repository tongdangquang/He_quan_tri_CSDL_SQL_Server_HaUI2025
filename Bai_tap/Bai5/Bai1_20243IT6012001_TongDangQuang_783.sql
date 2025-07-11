-- 1. Tạo cơ sở dữ liệu TRUONGHOC
USE master;
GO 

CREATE DATABASE TRUONGHOC
ON (
    NAME = 'TRUONGHOC_data',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\TRUONGHOC_data.mdf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON (
    NAME = 'TRUONGHOC_log',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\TRUONGHOC_log.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO 


-- Tạo các bảng cơ sở dữ liệu
USE TRUONGHOC;
GO 
-- Tạo bảng HOCSINH
CREATE TABLE HOCSINH
(
    MAHS CHAR(5) NOT NULL PRIMARY KEY,
    TEN NVARCHAR(30),
    NAM BIT,
    NGAYSINH DATETIME,
    DIACHI VARCHAR(20),
    DIEMTB FLOAT
);

-- Tạo bảng GIAOVIEN
CREATE TABLE GIAOVIEN
(
    MAGV CHAR(5) NOT NULL PRIMARY KEY,
    TEN NVARCHAR(30),
    NAM BIT,
    NGAYSINH DATETIME,
    DIACHI VARCHAR(20),
    LUONG MONEY
);

-- Tạo bảng LOPHOC
CREATE TABLE LOPHOC
(
    MALOP CHAR(10) NOT NULL PRIMARY KEY,
    TENLOP NVARCHAR(30),
    SOLUONG INT
);

