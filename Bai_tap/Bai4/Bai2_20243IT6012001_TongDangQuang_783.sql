USE QLBanHang;
GO
-- Bài 1.
-- a. 
SELECT PN.SoHDN,SP.MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
FROM SanPham SP
INNER JOIN Nhap N ON SP.MaSP = N.MaSP
INNER JOIN PNhap PN ON N.SoHDN = PN.SoHDN
INNER JOIN NhanVien NV ON PN.MaNV = NV.MaNV
INNER JOIN HangSX H ON H.MaHangSX = SP.MaHangSX
WHERE TenHang = 'Samsung' AND YEAR(NgayNhap) = 2020;
GO

-- b. 
SELECT TOP 10 Xuat.SoHDX, MaSP, SoLuongX
FROM Xuat
INNER JOIN PXuat ON Xuat.SoHDX = PXuat.SoHDX
WHERE YEAR(NgayXuat) = 2020
ORDER BY SoLuongX DESC;
GO

-- c. 
SELECT TOP 10 *
FROM SanPham 
ORDER BY GiaBan DESC;
GO

-- d. 
SELECT SanPham.*
FROM SanPham
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
WHERE TenHang = 'Samsung' AND GiaBan BETWEEN 100000 AND 50000000;
GO

-- e. 
SELECT SUM(SoLuongN * DonGiaN) AS 'Tổng tiền đã nhập'
FROM Nhap
INNER JOIN PNhap ON Nhap.SoHDN = PNhap.SoHDN
INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
WHERE YEAR(NgayNhap) = 2020 AND TenHang = 'Samsung';
GO

-- f. 
SELECT SUM(SoLuongX * GiaBan) AS 'Tổng tiền đã xuất'
FROM Xuat
INNER JOIN PXuat ON Xuat.SoHDX = PXuat.SoHDX
INNER JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
WHERE NgayXuat = '14/06/2020';
GO

-- g.
SELECT TOP 1 SoHDN, NgayNhap, TienNhap
FROM (
    SELECT Nhap.SoHDN, NgayNhap, SoLuongN * DonGiaN AS TienNhap
    FROM Nhap
    INNER JOIN PNhap ON Nhap.SoHDN = PNhap.SoHDN
    WHERE YEAR(NgayNhap) = 2024
) AS Temp
ORDER BY TienNhap DESC;


-- Bài 2.
-- a. 
SELECT HangSX.MaHangSX, TenHang,COUNT(SanPham.MaSP) AS 'Số loại sản phẩm'
FROM HangSX
INNER JOIN SanPham ON HangSX.MaHangSX = SanPham.MaHangSX
GROUP BY HangSX.MaHangSX, TenHang;
GO

-- b. 
SELECT SanPham.MaSP, SanPham.TenSP, SUM(SoLuongN * DonGiaN) AS 'Tổng tiền nhập'
FROM SanPham
INNER JOIN Nhap ON SanPham.MaSP = Nhap.MaSP
INNER JOIN PNhap ON Nhap.SoHDN = PNhap.SoHDN
WHERE YEAR(NgayNhap) = 2020
GROUP BY SanPham.MaSP, SanPham.TenSP;
GO

-- c. 
SELECT SanPham.MaSP, SanPham.TenSP, SUM(SoLuongX) AS 'Tổng số lượng xuất'
FROM SanPham
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
INNER JOIN Xuat ON SanPham.MaSP = Xuat.MaSP
INNER JOIN PXuat ON Xuat.SoHDX = PXuat.SoHDX
WHERE YEAR(NgayXuat) = 2020 AND TenHang = 'Samsung'
GROUP BY SanPham.MaSP, SanPham.TenSP
HAVING SUM(SoLuongX) > 100000;
GO 

-- d. 
SELECT TenPhong, COUNT(MaNV) AS 'Số lượng nhân viên nam'
FROM NhanVien
WHERE GioiTinh = 'Nam'
GROUP BY TenPhong;
GO

-- e. 
SELECT HangSX.MaHangSX, TenHang, SUM(SoLuongN) AS 'Tổng số lượng nhập'
FROM HangSX
INNER JOIN SanPham ON HangSX.MaHangSX = SanPham.MaHangSX
INNER JOIN Nhap ON SanPham.MaSP = Nhap.MaSP
INNER JOIN PNhap ON Nhap.SoHDN = PNhap.SoHDN
WHERE YEAR(NgayNhap) = 2018
GROUP BY HangSX.MaHangSX, TenHang;
GO 

-- f. 
SELECT NhanVien.MaNV, TenNV, SUM(SoLuongX * GiaBan) AS 'Tổng lượng tiền xuất'
FROM NhanVien
INNER JOIN PXuat ON NhanVien.MaNV = PXuat.MaNV
INNER JOIN Xuat ON PXuat.SoHDX = Xuat.SoHDX
INNER JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
WHERE YEAR(NgayXuat) = 2018
GROUP BY NhanVien.MaNV, TenNV;
GO 