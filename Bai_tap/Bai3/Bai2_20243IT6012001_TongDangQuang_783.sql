-- Câu 1. Trong file Bai1_20243IT6012001_TongDangQuang_783.sql

-- Câu 2.
-- 1. Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
SELECT DeTai.madt, DeTai.tendt
FROM DeTai
INNER JOIN HuongDan ON DeTai.madt = HuongDan.madt
INNER JOIN GiangVien ON HuongDan.magv = GiangVien.magv
WHERE GiangVien.hotengv = 'Tran son';

-- 2. Cho biết tên đề tài không có sinh viên nào thực tập 
SELECT DeTai.tendt
FROM DeTai
WHERE DeTai.madt NOT IN (
    SELECT HuongDan.madt 
    FROM HuongDan
);

-- 3. Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên
SELECT GiangVien.magv, GiangVien.hotengv, Khoa.tenkhoa, COUNT(HuongDan.masv) AS 'Số sinh viên hướng dẫn'
FROM GiangVien
INNER JOIN Khoa ON GiangVien.makhoa = Khoa.makhoa
INNER JOIN HuongDan ON GiangVien.magv = HuongDan.magv
GROUP BY GiangVien.magv, GiangVien.hotengv, Khoa.tenkhoa
HAVING COUNT(HuongDan.masv) >= 3;

-- 4. Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
SELECT DeTai.madt, DeTai.tendt, DeTai.kinhphi
FROM DeTai
WHERE DeTai.kinhphi = (SELECT MAX(DeTai.kinhphi) FROM DeTai);

-- 5. Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập 
SELECT DeTai.madt, DeTai.tendt, COUNT(HuongDan.masv) AS 'Số sinh viên tham gia'
FROM DeTai
INNER JOIN HuongDan ON DeTai.madt = HuongDan.madt
GROUP BY DeTai.madt, DeTai.tendt
HAVING COUNT(HuongDan.masv) > 2;

-- 6. Đưa ra mã số, họ tên và điểm của các sinh viên khoa 'DIALY' và 'QLTN' 
SELECT SinhVien.masv, SinhVien.hotensv, Khoa.tenkhoa, HuongDan.ketqua
FROM SinhVien
INNER JOIN Khoa ON SinhVien.makhoa = Khoa.makhoa
INNER JOIN HuongDan ON SinhVien.masv = HuongDan.masv
WHERE Khoa.tenkhoa = 'DIALY' OR Khoa.tenkhoa = 'QLTN';

-- 7. Đưa ra tên khoa, số lượng sinh viên của mỗi khoa 
SELECT Khoa.tenkhoa, COUNT(SinhVien.masv) AS 'Số lượng sinh viên'
FROM Khoa
LEFT JOIN SinhVien ON Khoa.makhoa = SinhVien.makhoa
GROUP BY Khoa.tenkhoa;

-- 8. Cho biết thông tin về các sinh viên thực tập tại quê nhà 
SELECT SinhVien.masv, SinhVien.hotensv, SinhVien.makhoa, SinhVien.namsinh, SinhVien.quequan
FROM SinhVien
INNER JOIN HuongDan ON SinhVien.masv = HuongDan.masv
INNER JOIN DeTai ON HuongDan.madt = DeTai.madt
WHERE DeTai.NoiThucTap = SinhVien.quequan;

-- 9. Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập 
SELECT SinhVien.masv, SinhVien.hotensv, SinhVien.makhoa, SinhVien.namsinh, SinhVien.quequan
FROM SinhVien
INNER JOIN HuongDan ON SinhVien.masv = HuongDan.masv
WHERE HuongDan.ketqua IS NULL;

-- 10. Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
SELECT SinhVien.masv, SinhVien.hotensv, HuongDan.ketqua
FROM SinhVien
INNER JOIN HuongDan ON SinhVien.masv = HuongDan.masv
WHERE HuongDan.ketqua = 0;