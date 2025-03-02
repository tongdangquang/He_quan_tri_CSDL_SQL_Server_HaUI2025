-- Bài 1: Từ bảng Products, lọc ra những sản phẩm có giá lớn hơn giá trung bình
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);

-- Bài 2: Lọc ra những khách hàng có số đơn hàng lớn hơn 10, dựa vào bảng Orders và Products
-- Cách thông thường
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) as [Total]
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
HAVING COUNT(o.OrderID) > 10;

-- Sử dụng sub query
SELECT CustomerID 
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders 
    GROUP BY CustomerID
    HAVING COUNT(OrderID) > 10
);

-- Bài 3: Tính tổng tiền cho từng đơn hàng
SELECT o.OrderID, (
    SELECT SUM(od.Quantity*od.UnitPrice)
    FROM [Order Details] od
    WHERE o.OrderID = od.OrderID
) as [Total]
FROM Orders o;

-- Bài 4: Lọc ra tên sản phẩm và tổng số đơn hàng của sản phẩm
SELECT p.ProductID, p.ProductName, (
    SELECT COUNT(od.OrderID)
    FROM [Order Details] od
    WHERE p.ProductID = od.ProductID
) AS [Products Total]
FROM Products p;
-- Cách 2:
SELECT ProductName, [Products Total]
FROM (
    SELECT p.ProductID, p.ProductName, (
    SELECT COUNT(od.OrderID)
    FROM [Order Details] od
    WHERE p.ProductID = od.ProductID
    ) AS [Products Total]
    FROM Products p
) AS temp;
