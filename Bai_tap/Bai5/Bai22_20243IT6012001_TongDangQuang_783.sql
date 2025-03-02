USE master;
GO

-- Bài 1. Tạo cơ sở dữ liệu QLSV
CREATE DATABASE QLSV
ON
(
    NAME = 'QLSV_data',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLSV_data.mdf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON
(
    NAME = 'QLSV_log',
    FILENAME = 'D:\Documents\SQL_server_HaUI\Database\QLSV_log.ldf',
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
);
GO

USE QLSV;
GO

CREATE TABLE LOP
(
    MaLop CHAR(10) NOT NULL PRIMARY KEY,
    TenLop NVARCHAR(30),
    Phong CHAR(10)
);

CREATE TABLE SV
(
    MaSV CHAR(10) NOT NULL PRIMARY KEY,
    TenSV NVARCHAR(30),
    MaLop CHAR(10),
    CONSTRAINT FK_SV_MaLop FOREIGN KEY(MaLop) REFERENCES Lop(MaLop)
);
GO

INSERT INTO LOP (MaLop, TenLop, Phong)
VALUES ('1', 'CD', '1'),
       ('2', 'DH', '2'),
       ('3', 'LT', '3'),
       ('4', 'CH', '4'),
       ('5', 'CD', '1');

INSERT INTO SV (MaSV, TenSV, MaLop)
VALUES ('1', 'A', '1'),
       ('2', 'B', '2'),
       ('3', 'C', '1'),
       ('4', 'D', '3');
GO


-- Bài 2.
-- 1. Viết hàm thống kê xem mỗi lớp có bao nhiêu sinh viên
-- với malop là tham số truyền vào từ bàn phím.
CREATE FUNCTION dbo.Thongke1(@MaLop CHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @TongSV INT;
    SELECT @TongSV = COUNT(MaSV)
    FROM SV
    WHERE MaLop = @MaLop;
    RETURN @TongSV;
END;
GO

SELECT MaLop, TenLop, dbo.Thongke1(MaLop) AS 'Số SV'
FROM LOP;
GO

-- 2. Đưa ra danh sách sinh viên(masv,tensv) học lớp với 
-- tenlop được truyền vào từ bàn phím
CREATE FUNCTION dbo.Thongke2(@TenLop NVARCHAR(30))
RETURNS @Result TABLE 
    (
        MaSV CHAR(10),
        TenSV NVARCHAR(30)
    )
AS
BEGIN
    INSERT INTO @Result
    SELECT MaSV, TenSV
    FROM SV
    INNER JOIN LOP ON SV.MaLop = LOP.MaLop
    WHERE TenLop = @TenLop;
    RETURN;
END;
GO

SELECT * FROM dbo.Thongke2('DH');
GO

-- 3. Đưa ra hàm thống kê sinhvien: malop,tenlop,soluong sinh viên trong lớp,
-- với tên lớp được nhập từ bàn phím. Nếu lớp đó chưa tồn tại 
-- thì thống kê tất cả các lớp, ngược lại nếu lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó.
CREATE FUNCTION dbo.Thongke3(@TenLop NVARCHAR(30))
RETURNS @Result TABLE
    (
        MaLop CHAR(10),
        TenLop NVARCHAR(30),
        SoLuong INT
    )
AS
BEGIN
    IF(NOT EXISTS(SELECT MaLop FROM LOP WHERE TenLop = @TenLop))
        INSERT INTO @Result
        SELECT LOP.MaLop, TenLop, COUNT(MaSV)
        FROM LOP
        INNER JOIN SV ON LOP.MaLop = SV.MaLop
        GROUP BY LOP.MaLop, TenLop;
    ELSE
        INSERT INTO @Result
        SELECT LOP.MaLop, TenLop, COUNT(MaSV)
        FROM LOP
        INNER JOIN SV ON LOP.MaLop = SV.MaLop
        WHERE TenLop = @TenLop
        GROUP BY LOP.MaLop, TenLop;
    RETURN;
END;
GO

SELECT * FROM dbo.Thongke3('DH');
GO

-- 4. Đưa ra phòng học của tên sinh viên nhập từ bàn phím.
CREATE FUNCTION dbo.Thongke4(@TenSV NVARCHAR(30))
RETURNS CHAR(10)
AS
BEGIN
    DECLARE @TenPhong CHAR(10);
    SELECT @TenPhong = Phong
    FROM LOP
    INNER JOIN SV ON LOP.MaLop = SV.MaLop
    WHERE TenSV = @TenSV;
    RETURN @TenPhong;
END;
GO

SELECT MaSV, TenSV, dbo.Thongke4(TenSV) AS 'Tên phòng'
FROM SV;


-- 5.  Đưa ra thống kê masv, tensv, tenlop với tham biến nhập từ bàn phím là phòng. Nếu phòng 
-- không tồn tại thì đưa ra tất cả các sinh viên và các phòng. Nếu phòng tồn tại thì đưa ra các 
-- sinh viên của các lớp học phòng đó (Nhiều lớp học cùng phòng)
CREATE FUNCTION dbo.Thongke5(@Phong CHAR(10))
RETURNS @Result TABLE
    (
        MaSV CHAR(10),
        TenSV NVARCHAR(30),
        TenLop NVARCHAR(30),
        Phong CHAR(10)
    )
AS
BEGIN
    IF(NOT EXISTS(SELECT Phong FROM LOP WHERE Phong = @Phong))
        INSERT INTO @Result
        SELECT MaSV, TenSV, LOP.TenLop, Phong
        FROM SV
        INNER JOIN LOP ON SV.MaLop = LOP.MaLop;
    ELSE
        INSERT INTO @Result
        SELECT MaSV, TenSV, LOP.TenLop, Phong
        FROM SV
        INNER JOIN LOP ON SV.MaLop = LOP.MaLop
        WHERE Phong = @Phong;
    RETURN;
END;
GO

SELECT * FROM dbo.Thongke5(3);
GO

-- 6. Viết hàm thống kê xem mỗi phòng có bao nhiêu lớp học. 
-- Nếu phòng không tồn tại trả về giá trị 0. 
CREATE FUNCTION dbo.Thongke6 (@Phong CHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @Dem INT;
    IF (NOT EXISTS(SELECT Phong FROM LOP WHERE Phong = @Phong))
        SET @Dem = 0;
    ELSE
        SELECT @Dem = COUNT(MaLop)
        FROM LOP 
        WHERE Phong = @Phong;
    RETURN @Dem;
END;
GO

SELECT DISTINCT(Phong), dbo.Thongke6(Phong) AS 'Số lớp'
FROM LOP;
GO
