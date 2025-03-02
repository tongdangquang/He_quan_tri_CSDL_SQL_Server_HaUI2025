-- Thay vì viết tường minh tường câu lênh Select trong mỗi lần truy vấn thì ta có thể dùng WITH để viết 1 lần và mỗi lần cầu truy vấn thì chỉ cần gọi lại WITH thì sẽ tối ưu hơn. 
-- Tưởng tượng nó giống như hàm (function) trong ngôn ngữ lập trình.
WITH short_e AS(
    SELECT EmployeeID, LastName, FirstName
    FROM Employees
)

SELECT * FROM short_e;

-- Lấy thông tin về đơn hàng (Orders) cùng với tổng giá trị đơn hàng và tỷ lệ giữa tổng giá trị và phí giao hàng.
WITH OrderTotals AS (
    SELECT OrderID, SUM(od.Quantity * od.UnitPrice) AS TotalPrice
    FROM [Order Details] od
    GROUP BY OrderID
)

SELECT 
    o.OrderID,
    o.OrderDate,
    o.Freight,
    ot.TotalPrice,
    ot.TotalPrice/o.Freight AS Ratio
FROM Orders o
JOIN OrderTotals ot ON o.OrderID = ot.OrderID;
