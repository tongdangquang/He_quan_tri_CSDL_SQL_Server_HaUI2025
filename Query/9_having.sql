-- tìm những khách hàng đặt nhiều hơn 20 đơn hàng, sắp xếp theo thứ tự tổng số đơn hàng giảm dần
-- vì where đứng trước group by mà cột count(OrderID) là cột phát sinh khi chạy đến câu lệnh group by (chạy qua lệnh where) nên không thể gọi lại lênh where, vì vậy ta có lệnh having để thêm điều kiện cho cột phát sinh count(OrderID)
SELECT CustomerID, COUNT(OrderID) as [Tống_số_đơn]
FROM Orders
-- WHERE COUNT(OrderID) > 20 
GROUP BY CustomerID 
HAVING COUNT(OrderID) > 20 
ORDER BY COUNT(OrderID) DESC;

-- chạy đoạn code trên và đoạn này để thấy sự khác biệt 
SELECT CustomerID, COUNT(OrderID) as [Tổng_số_đơn]
FROM Orders
GROUP BY CustomerID 
-- HAVING COUNT(OrderID) > 20 
ORDER BY COUNT(OrderID) DESC;

-- lọc những nhà cung cấp sản phẩm có tổng số lượng hàng trong kho (UnitsInStock) lớn hơn 30 và lcos trung bình giá (UnitPrice) dưới 50
SELECT SupplierID, SUM(UnitsInStock) as [Hàng lưu kho], AVG(UnitPrice) as [Trung bình giá]
FROM Products
GROUP BY SupplierID
HAVING SUM(UnitsInStock) > 30 AND AVG(UnitPrice) < 50;