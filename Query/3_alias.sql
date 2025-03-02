-- 3. Bí danh (Alias), có 3 cách đặt bí danh như dưới đây
-- 3.1. dùng bí danh để thay thế tên trường
SELECT ProductID as Pid from Products;
SELECT ProductID as [Mã sản phẩm] from Products;
SELECT ProductID as "Mã sản phẩm" from Products;

-- 3.2. dùng bí danh để thay thế tên bảng
SELECT top 15 O.* FROM Orders as O;
SELECT top 15 * FROM Orders as O;
SELECT top 15 ProductName as "Tên sản phẩm", SupplierID as "Mã nhà cung cấp", CategoryID as "Mã thể loại" FROM Products as "P";
