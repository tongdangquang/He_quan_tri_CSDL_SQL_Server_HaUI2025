USE QLBanHang
GO

-- a.
SELECT * FROM SanPham;
SELECT * FROM HangSX;
SELECT * FROM NhanVien;
SELECT * FROM Nhap;
SELECT * FROM PNhap;
SELECT * FROM Xuat;
SELECT * FROM PXuat;
GO

-- b.
SELECT MaSP, TenSP, TenHang, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
FROM SanPham
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX;
GO

-- c.
SELECT SanPham.*
FROM SanPham 
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
WHERE TenHang = 'Samsung';
GO

-- d.
SELECT *
FROM NhanVien
WHERE GioiTinh = 'Nữ' AND TenPhong = 'Phòng Kế Toán';
GO

-- e. 
SELECT PN.SoHDN, SP.MaSP, TenSP, TenHang, SoLuongN, DonGiaN, SoLuongN*DonGiaN AS 'TienNhap', MauSac, DonViTinh, NgayNhap, TenNV, TenPhong
FROM Nhap N
INNER JOIN PNhap PN ON N.SoHDN = PN.SoHDN
INNER JOIN SanPham SP ON N.MaSP = SP.MaSP
INNER JOIN HangSX H ON SP.MaHangSX = H.MaHangSX
INNER JOIN NhanVien NV ON PN.MaNV = NV.MaNV
ORDER BY PN.SoHDN ASC;
GO

-- f.
SELECT PX.SoHDX, SP.MaSP, TenSP, TenHang, SoLuongX, GiaBan, SoLuongX*GiaBan AS 'TienXuat', MauSac, DonViTinh, NgayXuat, TenNV, TenPhong
FROM Xuat X
INNER JOIN PXuat PX ON X.SoHDX = PX.SoHDX
INNER JOIN SanPham SP ON X.MaSP = SP.MaSP
INNER JOIN HangSX H ON SP.MaHangSX = H.MaHangSX
INNER JOIN NhanVien NV ON PX.MaNV = NV.MaNV
WHERE MONTH(NgayXuat) = 6 AND YEAR(NgayXuat) = 2020
ORDER BY PX.SoHDX ASC;
GO