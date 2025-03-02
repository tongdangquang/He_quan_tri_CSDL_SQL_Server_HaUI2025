-- 2.1. đếm và trả về số lượng giá trị (dữ liệu) trong cột (trường)
SELECT COUNT(DISTINCT ShipCountry) FROM Orders;
SELECT COUNT(*) FROM Orders; -- trả về số lượng orders

-- 2.2. tìm min, max của 1 trường trong một bảng
SELECT MIN(UnitPrice) as Min_Price FROM Products;
SELECT MAX(UnitPrice) as Max_Price FROM Products;
SELECT MAX(ProductName) as Min_Name FROM Products; -- trường hợp này sẽ trả về tê nhỏ nhất (tách ký tự đầu tiên của tên xong áp vảo bảng Ascii để so sánh và trả về kết quả)
