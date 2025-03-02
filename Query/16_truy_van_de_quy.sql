-- Sử dụng truy vấn đệ quy để tạo một cây cấu trúc quản lý của nhân viên bằng bảng "Employees"
-- Trong đó "ReportsTo" chính là mã của người quản lý.

DECLARE @EmployeeId INT
SET @EmployeeId = 2;

WITH e_cte AS (
    SELECT e.EmployeeID,
    e.FirstName + ' ' + e.LastName as Name,
    e.ReportsTo as ManagerId,
    0 AS Level
    FROM Employees e
    WHERE e.EmployeeID = @EmployeeId

    UNION ALL
    SELECT e1.EmployeeID,
    e1.FirstName + ' ' + e1.LastName AS Name,
    e1.ReportsTo as ManagerId,
    Level + 1 AS Level
    FROM Employees e1
    JOIN e_cte ON e1.ReportsTo = e_cte.EmployeeID
)

SELECT * FROM e_cte
OPTION (MAXRECURSION 500);