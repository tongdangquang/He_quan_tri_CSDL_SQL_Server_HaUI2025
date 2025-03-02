-- VIEW là một BẢNG ẢO được tạo từ kết quả của một câu truy vấn SQL. 
-- VIEW giúp đơn giản hóa các câu truy vấn phức tạp, cải thiện bảo mật bằng cách chỉ hiển thị một phần dữ liệu cần thiết 
-- và cung cấp một lớp trừu tượng cho các bảng thực.

-- Cấu trúc View
--CREATE VIEW ten_view AS
--SELECT cot1, cot2, ...
--FROM ten_bang
--WHERE dieu_kien;

-- MẪU: Tạo bảng thống kê doanh số bán háng theo tháng
CREATE VIEW ThongKeTheoThang AS
	SELECT YEAR(OrderDate) AS 'Năm',
		   MONTH(OrderDate) AS 'Tháng',
		   COUNT(*) AS 'Số lượng đơn hàng'
	FROM Orders
	GROUP BY YEAR(OrderDate), MONTH(OrderDate);

-- Truy vấn trong view như truy vấn trong các bảng dữ liệu thực
SELECT * FROM ThongKeTheoThang;

-- Có thể xóa VIEW (khung nhìn) nếu không cần thiết khỏi cơ sở dữ liệu
DROP VIEW ThongKeTheoThang;


-- VD1: tạo view kết hợp thông tin về khách hàng và đơn hàng
CREATE VIEW CustomerOrders AS
	SELECT C.CustomerID,
		   C.CompanyName,
		   O.OrderID,
		   O.OrderDate,
		   O.ShipCountry
	FROM Customers C
	JOIN Orders O ON C.CustomerID = O.CustomerID;


