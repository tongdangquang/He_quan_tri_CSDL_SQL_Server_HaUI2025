-- tính số lượng đơn đặt hàng trong năm 1997 của từng khách hàng
SELECT CustomerID, COUNT(OrderID) as [Total Orders], YEAR(OrderDate) as [Year]
FROM Orders
WHERE YEAR(OrderDate) = 1997
GROUP BY CustomerID, YEAR(OrderDate)
ORDER BY [Total Orders] DESC;

-- tính số lượng đơn đặt hàng trong ngày 04/09/1996 của từng khách hàng
SELECT CustomerID, COUNT(OrderID) as [Tổng số đơn], YEAR(OrderDate) as [Năm], MONTH(OrderDate) as [Tháng], DAY(OrderDate) as [Ngày]
FROM Orders
WHERE YEAR(OrderDate) = 1996 and MONTH(OrderDate) = 9 and DAY(OrderDate) = 4 
GROUP BY CustomerID, YEAR(OrderDate), MONTH(OrderDate), DAY(OrderDate)
ORDER BY [Tổng số đơn] DESC;
-- cách 2
SELECT CustomerID, COUNT(OrderID) as [Tổng số đơn], OrderDate
FROM Orders
WHERE OrderDate = '1996-09-04'
GROUP BY CustomerID, OrderDate
ORDER BY [Tổng số đơn] DESC;

-- tính các đơn hàng được giao vào tháng 5 và sắp xếp tăng dần theo năm
SELECT CustomerID, COUNT(*) as [Tổng số đơn], MONTH(OrderDate) as [Tháng], YEAR(OrderDate) as [Năm]
FROM Orders
WHERE MONTH(OrderDate) = 5
GROUP BY CustomerID, MONTH(OrderDate), YEAR(OrderDate)
ORDER BY [Năm];
