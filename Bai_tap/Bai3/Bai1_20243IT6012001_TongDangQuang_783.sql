-- Câu 1.
-- Tạo cơ sở dữ liệu
CREATE DATABASE ThucTap
ON (
    NAME = "ThucTap_data",
    FILENAME = "D:\Documents\SQL_server_HaUI\Database\ThucTap_data.mdf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON (
    NAME = "ThucTap_log",
    FILENAME = "D:\Documents\SQL_server_HaUI\Database\ThucTap_log.ldf",
    SIZE = 1MB,
    MAXSIZE = 5MB,
    FILEGROWTH = 1MB 
);

-- Tạo bảng dữ liệu
CREATE TABLE Khoa
(
    makhoa CHAR(10) NOT NULL PRIMARY KEY,
    tenkhoa CHAR(30) NOT NULL,
    dienthoai CHAR(10) NOT NULL
);

CREATE TABLE GiangVien
(
    magv INT NOT NULL PRIMARY KEY,
    hotengv CHAR(30) NOT NULL,
    luong DECIMAL(5, 2) NOT NULL,
    makhoa CHAR(10) NOT NULL,
    CONSTRAINT FK_GiangVien_makhoa FOREIGN KEY(makhoa) REFERENCES Khoa(makhoa)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE SinhVien
(
    masv INT NOT NULL PRIMARY KEY,
    hotensv CHAR(30) NOT NULL,
    makhoa CHAR(10) NOT NULL,
    namsinh INT NOT NULL,
    quequan CHAR(30) NOT NULL,
    CONSTRAINT FK_SinhVien_makhoa FOREIGN KEY(makhoa) REFERENCES Khoa(makhoa)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE DeTai
(
    madt CHAR(10) NOT NULL PRIMARY KEY,
    tendt CHAR(30) NOT NULL,
    kinhphi INT NOT NULL,
    NoiThucTap CHAR(30) NOT NULL 
);

CREATE TABLE HuongDan
(
    masv INT NOT NULL PRIMARY KEY,
    madt CHAR(10) NOT NULL,
    magv INT NOT NULL,
    ketqua DECIMAL(5, 2),
    CONSTRAINT FK_HuongDan_masv FOREIGN KEY(masv) REFERENCES SinhVien(masv),
    CONSTRAINT FK_HuongDan_madt FOREIGN KEY(madt) REFERENCES DeTai(madt),
    CONSTRAINT FK_HuongDan_magv FOREIGN KEY(magv) REFERENCES GiangVien(magv)
);

-- Nhập dữ liệu
INSERT INTO Khoa(makhoa, tenkhoa, dienthoai)
VALUES  ('K01', 'Ngoai ngu', '0123456781'),
        ('K02', 'Ke kiem', '0123456782'),
        ('K03', 'Dien tu', '0123456783'),
        ('K04', 'Kinh te', '0123456784'),
        ('K05', 'CONG NGHE SINH HOC', '0123456745'),
        ('K06', 'TOAN', '0123456733');

INSERT INTO GiangVien(magv, hotengv, luong, makhoa)
VALUES  (101, 'Nguyen Thi Thap', 150, 'K01'),
        (102, 'Tran Van Tinh', 120, 'K02'),
        (103, 'Nguyen Van Anh', 200, 'K03'),
        (104, 'Do Tu Tai', 180, 'K04');
       
INSERT INTO SinhVien(masv, hotensv, makhoa, namsinh, quequan)
VALUES  (1, 'Le Van Son', 'K01', 2004, 'Thai Binh'),
        (2, 'Nguyen Xuan Son', 'K02', 2004, 'Hai Duong'),
        (3, 'Nguyen Van Canh', 'K03', 2002, 'Ha Noi'),
        (4, 'Tran Dinh Thang', 'K01', 2003, 'Son La');

INSERT INTO DeTai(madt, tendt, kinhphi, NoiThucTap)
VALUES  ('DT01', 'An ninh mang', 100000, 'Nam Tu Liem'),
        ('DT02', 'Kiem thu phan mem', 200000, 'Bac Tu Liem'),
        ('DT03', 'Mang may tinh', 100000, 'Ca'),
        ('DT04', 'Co so du lieu', 150000, 'Ha Noi');  

INSERT INTO HuongDan(masv, madt, magv, ketqua)
VALUES  (1, 'DT01', 101, 8.5),
        (2, 'DT02', 102, 9),
        (3, 'DT03', 103, 8);

-- Câu 2.
-- 1. Đưa ra thông tin gồm mã số, họ tênvà tên khoa của tất cả các giảng viên
SELECT GiangVien.magv, GiangVien.hotengv, Khoa.tenkhoa
FROM GiangVien
INNER JOIN Khoa ON GiangVien.makhoa = Khoa.makhoa;

-- 2. Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
SELECT GiangVien.magv, GiangVien.hotengv, Khoa.tenkhoa
FROM GiangVien
INNER JOIN Khoa ON GiangVien.makhoa = Khoa.makhoa
WHERE (Khoa.tenkhoa = 'DIA LY') OR (Khoa.tenkhoa = 'QLTN');

-- 3. Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’ 
SELECT COUNT(*) AS 'Số sinh viên'
FROM SinhVien
INNER JOIN Khoa ON SinhVien.makhoa = Khoa.makhoa
WHERE Khoa.tenkhoa = 'CONG NGHE SINH HOC';

-- 4. Đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa ‘TOAN’
SELECT SinhVien.masv, SinhVien.hotensv, YEAR(GETDATE()) - SinhVien.namsinh AS 'Tuoi'
FROM SinhVien
INNER JOIN Khoa ON SinhVien.makhoa = Khoa.makhoa
WHERE Khoa.tenkhoa = 'TOAN';

-- 5. Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC'
SELECT COUNT(*) AS 'Số giảng viên'
FROM GiangVien
INNER JOIN Khoa ON GiangVien.makhoa = Khoa.makhoa
WHERE Khoa.tenkhoa = 'CONG NGHE SINH HOC';

-- 6. Cho biết thông tin về sinh viên không tham gia thực tập
SELECT *
FROM SinhVien
WHERE SinhVien.masv NOT IN (SELECT HuongDan.masv FROM HuongDan);

-- 7. Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
SELECT Khoa.makhoa, Khoa.tenkhoa, COUNT(GiangVien.magv) AS 'Số giảng viên'
FROM Khoa
INNER JOIN GiangVien ON Khoa.makhoa = GiangVien.makhoa
GROUP BY Khoa.makhoa, Khoa.tenkhoa;

-- 8. Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
-- Cách 1.
SELECT Khoa.dienthoai
FROM Khoa
WHERE khoa.makhoa = (
    SELECT SinhVien.makhoa
    FROM SinhVien
    WHERE SinhVien.hotensv = 'Le van son');
-- Cách 2.
SELECT Khoa.dienthoai
FROM Khoa
INNER JOIN SinhVien ON Khoa.makhoa = SinhVien.makhoa
WHERE SinhVien.hotensv = 'Le van son';