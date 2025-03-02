-- 7. group by
-- group by thường kết hợp với các hàm sum(), avg(), min(), max(), count() để thống kê và tính toán giá trị
SELECT ShipCountry, COUNT(OrderID)FROM Orders GROUP BY ShipCountry; -- đếm xem một quốc gia nhận bao nhiêu đơn hàng
-- tính trung bình giá của 1 sản phẩm
SELECT SupplierID, AVG(UnitPrice) as [AVG Price]
FROM Products 
GROUP BY SupplierID;

-- tìm quốc gia có nhiều đơn hàng nhất
SELECT TOP 1 ShipCountry, COUNT(OrderID) AS [number orders]
FROM Orders 
GROUP BY ShipCountry
ORDER BY [number orders] DESC;

-- tính hàng tồn kho
SELECT CategoryID, SUM(UnitsInStock) - SUM(UnitsOnOrder) as [SUM]
FROM Products 
GROUP BY CategoryID;

-- tìm giá vận chuyển thấp nhất và cao nhất của các đơn hàng theo từng thành phố và từng quốc gia khác nhau
SELECT ShipCountry, ShipCity, MAX(Freight) AS [MAX_Freight], MIN(Freight) AS [MIN_Freight]
FROM Orders 
GROUP BY ShipCountry, ShipCity;