-- xếp hạng sản phẩm theo giá giảm dần trên toàn bộ table
SELECT 
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    RANK() OVER (ORDER BY UnitPrice DESC) AS Ranking
FROM Products;

-- xếp hạng sản phẩm theo giá giảm dần theo từng thể loại sản phẩm
SELECT 
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    RANK() OVER (PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS Ranking
FROM Products;

-- sử dụng LAG() để lấy thông tin về đơn đặt hàng và ngày đặt hàng của đơn đặt hàng trước đó cho mỗi khách 
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS PreviousOrderDate
FROM Orders
ORDER BY CustomerID, OrderDate;