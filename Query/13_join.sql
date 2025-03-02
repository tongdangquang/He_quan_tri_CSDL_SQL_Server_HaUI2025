-- (INNER) JOIN: Trả về các bản ghi có giá trị khớp trong cả hai bảng
-- LEFT (OUTER) JOIN: Trả về tất cả các bản ghi từ bảng bên trái và các bản ghi phù hợp từ bảng bên phải
-- RIGHT (OUTER) JOIN: Trả về tất cả các bản ghi từ bảng bên phải và bản ghi phù hợp Bản ghi từ bảng bên trái
-- FULL (OUTER) JOIN: Trả về tất cả các bản ghi khi có kết quả khớp ở cả hai bên trái hoặc bảng bên phải

-- 1. Inner join
-- Trả về tất cả các hàng khi có ít nhất một giá tị ở cả hai bảng
-- Cấu trúc:
-- SELECT column_name(s)
-- FROM table1
-- INNER JOIN table2 ON table1.column_name = table2.column_name;

-- Bài 1: Sử dụng inner join, từ bảng Products và
--  Categories, hãy in ra các thông tin sau đây: mã thể loại, tên thể loại, mã sản phẩm, tên sản phẩm
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName
FROM Products as p
INNER JOIN Categories as c ON c.CategoryID = p.CategoryID;

-- Bài 2: Sử dụng inner join, từ bảng Products và
--  Categories, hãy in ra các thông tin sau đây: mã thể loại, tên thể loại, số lượng sản phẩm
SELECT c.CategoryID, c.CategoryName, COUNT(p.ProductID)
FROM Products as p
INNER JOIN Categories as c on c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- Bài 3: Sử dụng inner join, dựa vào bảng Customers và Orders hãy in ra mã đơn hàng, tên công ty khách hàng
SELECT o.OrderID, c.CompanyName, c.CustomerID
FROM Customers as c
INNER JOIN Orders as o ON c.CustomerID = o.CustomerID;


-- 2. Left join
-- Trả lại tất cả các dòng từ bảng bên trái và các dòng đúng với điều kiện từ bảng bên phải
-- Cấu trúc:
-- SELECT column_name(s)
-- FROM table1
-- LEFT INNER JOIN table2 ON table1.column_name = table2.column_name;

-- Bài 1: Sử dụng left join
-- Categories, hãy in ra các thông tin sau đây: mã thể loại, tên thể loại, mã sản phẩm, tên sản phẩm
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID;


-- 3. Right join
-- Trả lại tất cả các dòng từ bảng bên phải và các dòng đúng với điều kiện từ bảng bên trái
-- Cấu trúc:
-- SELECT column_name(s)
-- FROM table1
-- RIGHT INNER JOIN table2 ON table1.column_name = table2.column_name;


-- 4. Full join
-- Trả về tất cả các dòng khi có kết quả phù hợp trong bảng bên trái hoặc bên phải.
-- Cấu trúc:
-- SELECT column_name(s)
-- FROM table1
-- FULL OUTER JOIN table2
-- ON table1.column_name = table2.column_name
-- WHERE condition;
-- Full outer join trả về tất cả các kết quả phù hợp hồ sơ từ cả hai bảng cho dù bảng kia có khớp hay không. Vì vậy, nếu có các hàng trong "Khách hàng" không có kết quả khớp trong "Đơn đặt hàng" hoặc nếu có là các hàng trong "Đơn hàng" không có khớp trong "Khách hàng", các hàng đó sẽ là cũng được liệt kê.
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID=Orders.CustomerID
ORDER BY Customers.CustomerName;

-- Bài 1: Sử dụng right join
-- Categories, hãy in ra các thông tin sau đây: mã thể loại, tên thể loại, mã sản phẩm, tên sản phẩm
SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName
FROM Categories c
RIGHT JOIN Products p ON c.CategoryID = p.CategoryID;


-- Luyện tập:
-- Bài 1: Liệt kê tên sản phẩm và tên nhà cung cập của các sản phảm đã được đặt hàng trong bảng Order Details. Sử dụng Inner Join để kết hợp bảng Order Details với các bảng liên quan để lấy thông tin và nhà cung cấp.
SELECT DISTINCT od.ProductID, p.ProductName, s.SupplierID, s.CompanyName
FROM [Order Details] as od
INNER JOIN [Products] p ON od.ProductID = p.ProductID
INNER JOIN [Suppliers] s ON p.SupplierID = s.SupplierID;

-- Bài 2: Liệt kê tên khách hàng và tên nhân viên phụ trách của các đoen hàng trong bảng Orders. Bao gồm cả các đơn hàng hông có nhân viên phụ trách. Sử dụng LEFT JOIN để kết hợp bảng Orders và bảng Employees để lấy thông tin về khách hàng và nhân viên phụ trách.
SELECT DISTINCT c.CompanyName as [Tên khách hàng], e.LastName + e.FirstName as [Tên nhân viên]
FROM Orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID;

-- Bài 3: Liệt kê tên khách hàng và tên nhân viên phụ trách của các đon hàng trong bảng Orders. Bao gồm cả các khách hàng không có đơn hàng. Sử dụng right join để kết hợp bảng Orders và Customers để lấy thông tin về khách hàng và nhân viên phụ trách.
SELECT DISTINCT c.CompanyName as [Tên khách hàng], e.LastName + e.FirstName as [Tên nhân viên]
FROM Orders o
RIGHT JOIN Employees e ON o.EmployeeID = e.EmployeeID
RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID;

