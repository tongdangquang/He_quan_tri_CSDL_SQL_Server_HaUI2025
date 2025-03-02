-- 6.1. truy vấn có điều kiện
-- tìm những nhân viên đến từ thành phố London
SELECT * FROM Employees WHERE City = 'London'; -- lưu ý, chỉ được dùng cặp dấu nháy đơn '', không được dùng nháy kép ""
-- sắp xếp nhân viên đến từ thành phố London theo thứ tự tên A-Z
SELECT * FROM Employees WHERE City = 'London' ORDER BY LastName ASC;
-- liệt kê những đơn hàng giao muộn
SELECT RequiredDate, ShippedDate FROM Orders WHERE RequiredDate < ShippedDate;
-- lấy ra những đơn hàng được giảm giá từ 10%
SELECT OrderID, Discount FROM [Order Details] WHERE Discount >= 0.1;
-- lấy ra những khách hàng có id là 1
SELECT CustomerID FROM Customers WHERE CustomerID = 1;

-- 6.2 and, or, not
-- tìm lượng hàng tồn kho trong khoảng (50 < x < 100), sử dụng toán tử and
SELECT UnitsInStock FROM Products WHERE UnitsInStock > 50 AND UnitsInStock < 100;
-- tìm những khách hàng đến từ Germany hoặc Brazil, sử dụng toán tử or
SELECT CustomerID, Country FROM Customers WHERE Country = 'Germany' OR Country = 'Brazil';
-- tìm những sản phẩm có mã thể loại khác 1, sử dụng toán tử not
SELECT ProductName, CategoryID FROM Products WHERE NOT(CategoryID = 1);

-- 6.3. between
-- tìm sản phẩm có giá nằm giữa khoảng 10-30
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 10 AND 30;
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice NOT BETWEEN 10 AND 30;
-- tìm sản phẩm trong ngày
SELECT CustomerID, OrderDate FROM Orders WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31';
-- tính tổng số tiền từ ngày này đển ngày kia
SELECT SUM(Freight) FROM Orders WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31';
SELECT OrderID, ShipVia, OrderDate FROM Orders WHERE (OrderDate BETWEEN '1996-07-01' AND '1996-07-31') AND (ShipVia = 3);

-- 6.4. like: Toán tử được sử dụng trong một mệnh đề để tìm kiếm một mẫu cụ thể trong một cột.
-- Dấu phần trăm đại diện cho không, một hoặc nhiều ký tự "%"
-- Dấu gạch dưới đại diện cho một ký tự duy nhất "_"
-- tìm khách hàng đến từ quốc gia có tên có chữ A đầu tiên
SELECT CustomerID, Country FROM Customers WHERE Country LIKE 'A%';
SELECT CustomerID, Country FROM Customers WHERE Country NOT LIKE 'A%'; -- không bắt đầu bởi ký tự "A"
-- tìm đơn hàng ship đến thành phố có tên có chữ 'a' trong tên
SELECT OrderID, ShipCity FROM Orders WHERE ShipCity LIKE '%a%';
-- tìm quốc gia tên chỉ có 2 ký tự và bắt đầu bằng chữ U
SELECT OrderID, ShipCountry FROM Orders WHERE ShipCountry LIKE 'U_';
-- tìm quốc gia tên chỉ có 3 ký tự và chữ S đứng giữa 2 ký tự còn lại
SELECT OrderID, ShipCountry FROM Orders WHERE ShipCountry LIKE '_S_';

-- 6.5. wildcards
-- %: đại diện cho không hoặc nhiều ký tự
-- _: đại diện cho một ký tự duy nhất
-- []: đại diện cho bất kì ký tự nào trong ngoặc (ví dụ [a, b, c]: có thể là a hoặc b hoặc c)
-- ^: đại diện cho một ký tự nào đó không có trong ngoặc ([^a, b, c...])
-- -: đại diện cho bất kỳ ký tự nào trong phạm vi được chỉ định ([a-f])
SELECT ContactName FROM Customers WHERE ContactName LIKE 'A_[a-f]%';
SELECT ContactName FROM Customers WHERE (ContactName LIKE 'A%') and (ContactName NOT LIKE '%b%'); --tìm tên chứa ký tự A đầu tiên và không chứa ký tự b trong tên

-- 6.6. in, not in
-- đơn hàng được giao đến Germany, uK, Brazil
SELECT ShipCountry FROM Orders WHERE ShipCountry IN ('Germany', 'UK', 'Brazil'); -- dùng in
SELECT ShipCountry FROM Orders WHERE ShipCountry = 'Germany' OR ShipCountry = 'UK' OR ShipCountry = 'Brazil'; -- dùng OR
-- đơn hàng không giao đến Germany, UK, Brazil
SELECT ShipCountry FROM Orders WHERE ShipCountry NOT IN ('Germany', 'UK', 'Brazil'); -- dùng in
SELECT * FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM Orders); -- trả lại tất cả khách hàng có đơn hàng trong bảng Orders

-- 6.7. is null, is not null
SELECT OrderID FROM Orders WHERE ShippedDate IS NULL; -- Lấy ra tất cả đơn hàng chưa được giao
SELECT OrderID FROM Orders WHERE ShippedDate IS NOT NULL; -- đếm số lượng đơn hàng đã được giao
SELECT COUNT(OrderID) FROM Orders WHERE ShippedDate IS NULL; -- đếm số lượng đơn hàng chưa được giao
