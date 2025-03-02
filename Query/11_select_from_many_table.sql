-- Từ bảng Products và Categories, hãy in ra mã thể loại, tên thể loại, mã sản phẩm, tên sản phẩm
SELECT Products.ProductID, Products.ProductName, Categories.CategoryID, Categories.CategoryName
FROM Products, Categories
WHERE Categories.CategoryID = Products.CategoryID;

-- Từ bảng Employees và Orders hãy in ra các thông tin: mã nhân viên, tên nhân viên, số lượng đơn hàng mà nhân viên đã bán được
SELECT e.EmployeeID, e.LastName, e.FirstName, COUNT(o.OrderID) as [Tổng số đơn bán được]
FROM Employees as e, Orders as o
WHERE e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.LastName, e.FirstName;

-- Từ bảng Customers và Orders hãy in ra các thông tin sau: mã số khách hàng, tên công ty. tên liên hệ, số lượng đon hàng đã mua với điều kiện quốc gia của khách hàng là UK
SELECT c.CustomerID, c.CompanyName, c.ContactName, c.Country, COUNT(o.OrderID) as [Số lượng đơn hàng đã mua]
FROM Customers as c, Orders as o
WHERE c.CustomerID = o.CustomerID and c.Country = 'UK'
GROUP BY c.CustomerID, c.CompanyName, c.ContactName, c.Country;

-- Từ bảng Orders và Shippers hãy in ra các thông tin: mã nhà vận chuyển, tên công ty vận chuyển, tổng số tiền được vận chuyển và in ra màn hình theo thứ tự sắp xếp tổng số tiền vận chuyển giảm dần.
SELECT s.ShipperID, s.CompanyName, SUM(o.Freight) as [Tổng số tiền vận chuyển]
FROM Shippers as s, Orders as o
WHERE s.ShipperID = o.ShipVia
GROUP BY s.ShipperID, s.CompanyName
ORDER BY SUM(o.Freight) DESC;

-- Từ bảng Products và Suppliers, hãy in ra các thông tin: mã nhà cung cấp, tên công ty, tổng số các sản phẩm khác nhau đã cung cấp. Điều kiện: chỉ in ra màn hình duy nhất 1 nhà cung cấp có số lượng sản phẩm khác nhau nhiều nhất.
SELECT TOP 1 s.SupplierID, s.CompanyName, COUNT(DISTINCT p.ProductID) as [Tổng số các sản phẩm khác nhau đã cung cấp]
FROM Products as p, Suppliers as s
WHERE s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.CompanyName
ORDER BY COUNT(DISTINCT p.ProductID) DESC;

-- Từ bảng Orders và Orders Details, hãy in ra các thông tin: mã đơn hàng, tổng số tiền sản phẩm của đơn hàng đó.
SELECT o.OrderID, SUM(od.UnitPrice*od.Quantity) as [Tổng số tiền]
FROM Orders as o, [Order Details] as od
WHERE o.OrderID = od.OrderID
GROUP BY o.OrderID;

-- Từ 3 bảng Order Details, Orders, Employees hãy chỉ ra các thông tin sau: mã đơn hàng, tên nhân viên, tổng số tiền sản phẩm của đơn hàng đó
SELECT o.OrderID, e.LastName, e.FirstName, SUM(od.UnitPrice*od.Quantity) as [Tổng số tiền]
FROM Orders as o, [Order Details] as od, Employees as e
WHERE o.OrderID = od.OrderID and o.EmployeeID = e.EmployeeID
GROUP BY o.OrderID, e.LastName, e.FirstName;

-- Từ 3 bảng Orders, Customers, Shippers hãy in ra các thông tin sau: mã đơn hàng, tên khách hàng, tên công ty vận chuyển và chỉ in ra các đơn hàng được giao đến 'UK' trong năm 1997
SELECT o.OrderID as [Mã đơn hàng], c.ContactName as [Tên khách hàng], s.CompanyName as [Tên công ty vận chuyển], o.ShipCountry as [Địa chỉ], YEAR(o.ShippedDate) as [Năm]
FROM Orders as o, Customers as c, Shippers as s
WHERE  o.ShipVia = s.ShipperID and o.CustomerID = c.CustomerID and o.ShipCountry = 'UK' and YEAR(o.ShippedDate) = 1997
GROUP BY  o.OrderID, c.ContactName, s.CompanyName, o.ShipCountry, YEAR(o.ShippedDate);


