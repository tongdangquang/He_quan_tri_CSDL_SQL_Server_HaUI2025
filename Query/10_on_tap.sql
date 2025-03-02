-- Bài 1: Hãy cho biết những khách hàng nào đã đặt nhiều hơn 20 đơn hàng, sắp xếp theo thứ tự tổng số đơn hàng giảm dần.
SELECT CustomerID, COUNT(OrderID) as [Số đơn đã đặt]
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 20
ORDER BY COUNT(OrderID) DESC;

-- Bài 2: Hãy lọc ra các nhân viên (EmployeeID) có tổng số đơn hàng lớn hơn hoặc bằng 100, sắp xếp theo tổng số đơn hàng giảm dần.
SELECT EmployeeID, COUNT(OrderID) as [Tổng số đơn hàng]
FROM Orders
GROUP BY EmployeeID
HAVING COUNT(OrderID) >= 100
ORDER BY COUNT(OrderID) DESC;

-- Bài 3: Hãy cho biết những thể loại nào (CategoryID) có số sản phẩm khác nhau lớn hơn 11.
SELECT CategoryID, COUNT(DISTINCT ProductName) as [Số sản phẩm khách nhau]
FROM Products
GROUP BY CategoryID
HAVING COUNT(DISTINCT ProductName) > 11;

-- Bài 4: Hãy cho biết những thể loại nào (CategoryID) có số tổng số lượng sản phẩm trong kho (UNitsINStock) lớn hơn 350.
SELECT CategoryID, SUM(UnitsInStock) as [Total UnitsInStock]
FROM Products
GROUP BY CategoryID
HAVING SUM(UnitsInStock) > 350;

-- Bài 5: Hãy cho biết những quốc gia nào có nhiều hơn 7 khách hàng khác nhau.
SELECT ShipCountry, COUNT(DISTINCT CustomerID)
FROM Orders
GROUP BY ShipCountry
HAVING COUNT(DISTINCT CustomerID) > 7;

-- Bài 6: Hãy cho biết những ngày nào có nhiều hơn 5 đơn hàng được giao, sắp xếp tăng dần theo ngày giao hàng.
SELECT ShippedDate, COUNT(*) as [Tổng số đơn]
FROM Orders
GROUP BY ShippedDate
HAVING COUNT(*) > 5
ORDER BY ShippedDate;

-- Bài 7: Hãy cho biết nhũng thành phó nào có số lượng đơn hàng được giao là khác 1 và 2, ngày đặt hàng từ ngày '1997-04-01' đến ngày '1997-08-31'.
SELECT ShipCity, COUNT(*) as [Số đơn hàng]
FROM Orders
WHERE OrderDate BETWEEN '1997-04-01' AND '1997-08-31'
GROUP BY ShipCity
HAVING COUNT(*) <> 1 AND COUNT(*) <> 2;